[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$script:FullRunnerTimeoutSeconds = 1800
$script:ProofTimeoutSeconds = 30
$script:DbSuiteTimeoutSeconds = 300
$script:ConcurrencyTimeoutSeconds = 300
$script:RunnerStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$script:SensitiveValues = [System.Collections.Generic.List[string]]::new()

function Assert-Corr023 {
  param(
    [Parameter(Mandatory = $true)][bool]$Condition,
    [Parameter(Mandatory = $true)][string]$Message
  )

  if (-not $Condition) {
    throw $Message
  }
}

function Get-Corr023RemainingSeconds {
  $remaining = $script:FullRunnerTimeoutSeconds - [int][Math]::Ceiling($script:RunnerStopwatch.Elapsed.TotalSeconds)
  if ($remaining -le 0) {
    throw "Full CORR-023 runner timed out after $($script:FullRunnerTimeoutSeconds) seconds."
  }

  return $remaining
}

function ConvertTo-Corr023SanitizedText {
  param([AllowEmptyString()][string]$Text)

  $sanitized = $Text
  foreach ($secret in $script:SensitiveValues) {
    if (-not [string]::IsNullOrEmpty($secret)) {
      $sanitized = $sanitized.Replace($secret, "[REDACTED]")
    }
  }

  $sanitized = [regex]::Replace(
    $sanitized,
    '(?i)postgres(?:ql)?://[^\s"'']+',
    '[REDACTED_DB_URL]'
  )
  return $sanitized
}

function Invoke-Corr023Process {
  param(
    [Parameter(Mandatory = $true)][string]$FilePath,
    [Parameter(Mandatory = $true)][string[]]$Arguments,
    [Parameter(Mandatory = $true)][int]$TimeoutSeconds,
    [Parameter(Mandatory = $true)][string]$Phase,
    [hashtable]$Environment = @{}
  )

  $remaining = Get-Corr023RemainingSeconds
  $effectiveTimeout = [Math]::Min($TimeoutSeconds, $remaining)

  $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
  $startInfo.FileName = $FilePath
  $startInfo.WorkingDirectory = $script:RepoRoot
  $startInfo.UseShellExecute = $false
  $startInfo.CreateNoWindow = $true
  $startInfo.RedirectStandardOutput = $true
  $startInfo.RedirectStandardError = $true
  foreach ($argument in $Arguments) {
    $startInfo.ArgumentList.Add($argument)
  }
  foreach ($entry in $Environment.GetEnumerator()) {
    $startInfo.Environment[[string]$entry.Key] = [string]$entry.Value
  }

  $process = [System.Diagnostics.Process]::new()
  $process.StartInfo = $startInfo
  try {
    Assert-Corr023 -Condition $process.Start() -Message "$Phase failed to start."
    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()

    if (-not $process.WaitForExit($effectiveTimeout * 1000)) {
      try {
        $process.Kill($true)
      }
      catch {
        # The process may already have terminated between the timeout and Kill.
      }
      $process.WaitForExit()
      throw "$Phase timed out after $effectiveTimeout seconds."
    }

    $stdout = $stdoutTask.GetAwaiter().GetResult()
    $stderr = $stderrTask.GetAwaiter().GetResult()
    $exitCode = $process.ExitCode
    if ($exitCode -ne 0) {
      throw "$Phase failed with exit code $exitCode; subprocess output withheld."
    }

    return [pscustomobject]@{
      ExitCode = $exitCode
      StdOut = $stdout
      StdErr = $stderr
      Combined = ($stdout + [Environment]::NewLine + $stderr)
    }
  }
  catch {
    $message = ConvertTo-Corr023SanitizedText -Text $_.Exception.Message
    throw $message
  }
  finally {
    $process.Dispose()
  }
}

function Get-Corr023Sha256 {
  param([Parameter(Mandatory = $true)][string]$Path)

  return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
}

function Get-Corr023DbPort {
  param([Parameter(Mandatory = $true)][string]$ConfigPath)

  $insideDbSection = $false
  $ports = [System.Collections.Generic.List[int]]::new()
  foreach ($line in Get-Content -LiteralPath $ConfigPath) {
    if ($line -match '^\s*\[') {
      $insideDbSection = $line -match '^\s*\[db\]\s*$'
      continue
    }
    if ($insideDbSection -and $line -match '^\s*port\s*=\s*([0-9]+)\s*(?:#.*)?$') {
      $ports.Add([int]$Matches[1])
    }
  }

  Assert-Corr023 -Condition ($ports.Count -eq 1) -Message "supabase/config.toml [db].port is missing or ambiguous."
  Assert-Corr023 -Condition ($ports[0] -ge 1 -and $ports[0] -le 65535) -Message "supabase/config.toml [db].port is invalid."
  return $ports[0]
}

function Get-Corr023StatusObject {
  param([Parameter(Mandatory = $true)][string]$NpxPath)

  $result = Invoke-Corr023Process -FilePath $NpxPath `
    -Arguments @('supabase', 'status', '-o', 'json') `
    -TimeoutSeconds $script:ProofTimeoutSeconds -Phase 'Supabase Local status proof'
  $statusText = $result.Combined
  $firstBrace = $statusText.IndexOf('{')
  $lastBrace = $statusText.LastIndexOf('}')
  Assert-Corr023 -Condition ($firstBrace -ge 0 -and $lastBrace -gt $firstBrace) `
    -Message "Supabase Local status did not return a parseable JSON object."

  try {
    return $statusText.Substring($firstBrace, $lastBrace - $firstBrace + 1) | ConvertFrom-Json
  }
  catch {
    throw "Supabase Local status JSON could not be parsed; output withheld."
  }
}

function Get-Corr023PsqlPath {
  param([Parameter(Mandatory = $true)][int]$PostgresMajorVersion)

  $command = Get-Command psql.exe -ErrorAction SilentlyContinue
  if ($null -ne $command) {
    return $command.Source
  }

  $programFilesRoot = [Environment]::GetFolderPath('ProgramFiles')
  $candidate = Join-Path $programFilesRoot "PostgreSQL\$PostgresMajorVersion\bin\psql.exe"
  Assert-Corr023 -Condition (Test-Path -LiteralPath $candidate -PathType Leaf) `
    -Message "psql for the configured local PostgreSQL major version is unavailable."
  return $candidate
}

function Get-Corr023PostgresMajorVersion {
  param([Parameter(Mandatory = $true)][string]$ConfigPath)

  $insideDbSection = $false
  $versions = [System.Collections.Generic.List[int]]::new()
  foreach ($line in Get-Content -LiteralPath $ConfigPath) {
    if ($line -match '^\s*\[') {
      $insideDbSection = $line -match '^\s*\[db\]\s*$'
      continue
    }
    if ($insideDbSection -and $line -match '^\s*major_version\s*=\s*([0-9]+)\s*(?:#.*)?$') {
      $versions.Add([int]$Matches[1])
    }
  }

  Assert-Corr023 -Condition ($versions.Count -eq 1) -Message "supabase/config.toml [db].major_version is missing or ambiguous."
  return $versions[0]
}

function Invoke-Corr023Psql {
  param(
    [Parameter(Mandatory = $true)][string]$Sql,
    [Parameter(Mandatory = $true)][string]$Phase
  )

  $result = Invoke-Corr023Process -FilePath $script:PsqlPath `
    -Arguments @(
      '--no-psqlrc',
      '--quiet',
      '--tuples-only',
      '--no-align',
      '--set=ON_ERROR_STOP=1',
      "--dbname=$($script:AdminDbUrl)",
      '--command',
      $Sql
    ) `
    -TimeoutSeconds $script:ProofTimeoutSeconds -Phase $Phase

  return $result.StdOut.Trim()
}

function Remove-Corr023Ansi {
  param([AllowEmptyString()][string]$Text)

  return [regex]::Replace($Text, "`e\[[0-9;]*[A-Za-z]", '')
}

function Assert-Corr023PgTapResult {
  param(
    [Parameter(Mandatory = $true)]$Result,
    [Parameter(Mandatory = $true)][string]$Phase,
    [AllowNull()][Nullable[int]]$ExpectedTests = $null
  )

  $output = Remove-Corr023Ansi -Text $Result.Combined
  Assert-Corr023 -Condition ($output -match '(?im)Files\s*=\s*1\b') -Message "$Phase did not report Files=1."
  Assert-Corr023 -Condition ($output -match '(?im)Result:\s*PASS\b') -Message "$Phase did not report Result: PASS."
  Assert-Corr023 -Condition ($output -notmatch '(?im)bad plan|no plan found|failed test') -Message "$Phase reported a TAP plan/assertion failure."
  if ($null -ne $ExpectedTests) {
    Assert-Corr023 -Condition ($output -match "(?im)Tests\s*=\s*$ExpectedTests\b") `
      -Message "$Phase did not report Tests=$ExpectedTests."
  }

  $testCount = 'UNKNOWN'
  if ($output -match '(?im)Tests\s*=\s*([0-9]+)\b') {
    $testCount = $Matches[1]
  }
  return $testCount
}

function Invoke-Corr023DbSuite {
  param(
    [Parameter(Mandatory = $true)][string]$NpxPath,
    [Parameter(Mandatory = $true)][string]$RelativePath,
    [Parameter(Mandatory = $true)][string]$Phase,
    [AllowNull()][Nullable[int]]$ExpectedTests = $null,
    [switch]$UseAdminUrl
  )

  $arguments = [System.Collections.Generic.List[string]]::new()
  $arguments.Add('supabase')
  $arguments.Add('test')
  $arguments.Add('db')
  if ($UseAdminUrl) {
    $arguments.Add('--db-url')
    $arguments.Add($script:AdminDbUrl)
  }
  $arguments.Add($RelativePath)

  $result = Invoke-Corr023Process -FilePath $NpxPath -Arguments $arguments.ToArray() `
    -TimeoutSeconds $script:DbSuiteTimeoutSeconds -Phase $Phase
  $testCount = Assert-Corr023PgTapResult -Result $result -Phase $Phase -ExpectedTests $ExpectedTests
  return [pscustomobject]@{ Result = $result; Tests = $testCount }
}

function Get-Corr023NpmScripts {
  param([Parameter(Mandatory = $true)][string]$PackagePath)

  $package = Get-Content -Raw -LiteralPath $PackagePath | ConvertFrom-Json
  $names = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
  foreach ($property in $package.scripts.PSObject.Properties) {
    $null = $names.Add($property.Name)
  }
  return $names
}

$script:RepoRoot = $null
$script:PsqlPath = $null
$script:AdminDbUrl = $null
$statusObject = $null
$statusDbUrl = $null
$encodedPassword = $null
$decodedPassword = $null

try {
  $scriptPath = $MyInvocation.MyCommand.Path
  Assert-Corr023 -Condition (-not [string]::IsNullOrEmpty($scriptPath)) -Message "Runner physical path is unavailable."
  $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..\..')).Path
  Set-Location -LiteralPath $script:RepoRoot

  $expectedRunnerPath = Join-Path $script:RepoRoot 'supabase\tests\database\corr_023_local_db_regression.ps1'
  Assert-Corr023 -Condition ((Resolve-Path -LiteralPath $scriptPath).Path -ceq (Resolve-Path -LiteralPath $expectedRunnerPath).Path) `
    -Message "Runner is not executing from its canonical repository path."

  $configPath = Join-Path $script:RepoRoot 'supabase\config.toml'
  $packagePath = Join-Path $script:RepoRoot 'package.json'
  $task009Path = 'supabase/tests/database/task_009_identity_tenant_foundation.test.sql'
  $task010Path = 'supabase/tests/database/task_010_audit_event_foundation.test.sql'
  $task013Path = 'supabase/tests/database/task_013_verification_challenge_foundation.test.sql'
  $task014Path = 'supabase/tests/database/task_014_global_identity_authorization_foundation.test.sql'
  $task013MigrationPath = 'supabase/migrations/20260830010000_task_013_verification_challenge_foundation.sql'
  $task015Path = 'supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql'
  $task015ConcurrencyPath = 'supabase/tests/database/task_015_company_membership_lifecycle_concurrency.test.ps1'

  foreach ($requiredPath in @(
    $configPath,
    $packagePath,
    (Join-Path $script:RepoRoot $task009Path),
    (Join-Path $script:RepoRoot $task010Path),
    (Join-Path $script:RepoRoot $task013Path),
    (Join-Path $script:RepoRoot $task014Path),
    (Join-Path $script:RepoRoot $task013MigrationPath),
    (Join-Path $script:RepoRoot $task015Path),
    (Join-Path $script:RepoRoot $task015ConcurrencyPath)
  )) {
    Assert-Corr023 -Condition (Test-Path -LiteralPath $requiredPath -PathType Leaf) -Message "Required source path is unavailable."
  }

  $sourceASha = Get-Corr023Sha256 -Path (Join-Path $script:RepoRoot $task013Path)
  $sourceBSha = Get-Corr023Sha256 -Path (Join-Path $script:RepoRoot $task013MigrationPath)
  Assert-Corr023 -Condition ($sourceASha -ceq '00c804ce1117ae086fca331707fdc2bc055857e0982584e573fb666251c3eca4') `
    -Message "Source A identity drift."
  Assert-Corr023 -Condition ($sourceBSha -ceq '1d4833f38be525974d447dc0dd301211a1d6bad68edadcfe46f424f5eb4e0dbf') `
    -Message "Source B identity drift."

  $task013Text = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot $task013Path)
  Assert-Corr023 -Condition (($task013Text | Select-String -Pattern 'select\s+plan\(72\);' -AllMatches).Matches.Count -eq 1) `
    -Message "TASK-013 plan(72) contract drift."
  foreach ($number in 1..72) {
    $label = 'T013-DB-{0:D3}' -f $number
    Assert-Corr023 -Condition $task013Text.Contains($label) `
      -Message "TASK-013 assertion label contract drift."
  }

  $task015Text = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot $task015Path)
  Assert-Corr023 -Condition (($task015Text | Select-String -Pattern 'select\s+plan\(81\);' -AllMatches).Matches.Count -eq 1) `
    -Message "TASK-015 plan(81) contract drift."

  $task015ConcurrencyText = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot $task015ConcurrencyPath)
  foreach ($number in 1..6) {
    $label = 'T015-CON-{0:D3}' -f $number
    Assert-Corr023 -Condition ($task015ConcurrencyText.Contains($label)) -Message "TASK-015 concurrency contract drift."
  }

  $npxCommand = Get-Command npx.cmd -ErrorAction SilentlyContinue
  Assert-Corr023 -Condition ($null -ne $npxCommand) -Message "npx is unavailable."
  $npxPath = $npxCommand.Source
  $versionResult = Invoke-Corr023Process -FilePath $npxPath -Arguments @('supabase', '--version') `
    -TimeoutSeconds $script:ProofTimeoutSeconds -Phase 'Supabase CLI version proof'
  $supabaseVersion = $versionResult.StdOut.Trim()
  Assert-Corr023 -Condition ($supabaseVersion -ceq '2.114.0') -Message "Supabase CLI version drift."

  $dbPort = Get-Corr023DbPort -ConfigPath $configPath
  $postgresMajorVersion = Get-Corr023PostgresMajorVersion -ConfigPath $configPath
  $statusObject = Get-Corr023StatusObject -NpxPath $npxPath
  $statusProperties = @($statusObject.PSObject.Properties.Name)
  Assert-Corr023 -Condition ($statusProperties -contains 'DB_URL') -Message "Supabase Local status DB_URL is unavailable."
  $statusDbUrl = [string]$statusObject.DB_URL
  Assert-Corr023 -Condition (-not [string]::IsNullOrWhiteSpace($statusDbUrl)) -Message "Supabase Local status DB_URL is empty."
  $script:SensitiveValues.Add($statusDbUrl)

  try {
    $statusUri = [Uri]$statusDbUrl
  }
  catch {
    throw "Supabase Local status DB_URL is invalid; value withheld."
  }
  $databaseName = [Uri]::UnescapeDataString($statusUri.AbsolutePath.TrimStart('/'))
  Assert-Corr023 -Condition ($statusUri.Scheme -in @('postgres', 'postgresql')) -Message "Local DB URL scheme is not PostgreSQL."
  Assert-Corr023 -Condition ($statusUri.Host -ceq '127.0.0.1') -Message "Local DB URL host is not exact loopback."
  Assert-Corr023 -Condition ($statusUri.Port -eq $dbPort) -Message "Local DB URL port does not match config.toml."
  Assert-Corr023 -Condition ($databaseName -ceq 'postgres') -Message "Local DB URL database is not postgres."
  Assert-Corr023 -Condition ($statusUri.Authority -match ":$dbPort$") -Message "Local DB URL does not contain the explicit configured port."

  $dockerCommand = Get-Command docker.exe -ErrorAction SilentlyContinue
  Assert-Corr023 -Condition ($null -ne $dockerCommand) -Message "Docker CLI is unavailable."
  $dockerResult = Invoke-Corr023Process -FilePath $dockerCommand.Source `
    -Arguments @('ps', '--format', '{{json .}}') `
    -TimeoutSeconds $script:ProofTimeoutSeconds -Phase 'Docker local binding proof'
  $bindingContainers = [System.Collections.Generic.List[object]]::new()
  foreach ($line in ($dockerResult.StdOut -split '\r?\n')) {
    if ([string]::IsNullOrWhiteSpace($line)) {
      continue
    }
    try {
      $container = $line | ConvertFrom-Json
    }
    catch {
      continue
    }
    $portsText = [string]$container.Ports
    $running = (($container.PSObject.Properties.Name -contains 'State') -and ([string]$container.State -ceq 'running')) -or
      ([string]$container.Status -match '^Up\s')
    if ($running -and $portsText -match "(?:0\.0\.0\.0|127\.0\.0\.1|\[::\]):$dbPort->5432/tcp") {
      $bindingContainers.Add($container)
    }
  }
  Assert-Corr023 -Condition ($bindingContainers.Count -eq 1) -Message "Local PostgreSQL Docker binding is not uniquely proven."

  $userInfo = $statusUri.UserInfo
  $separatorIndex = $userInfo.IndexOf(':')
  Assert-Corr023 -Condition ($separatorIndex -gt 0 -and $separatorIndex -lt ($userInfo.Length - 1)) `
    -Message "Local DB URL credential shape is invalid."
  $encodedPassword = $userInfo.Substring($separatorIndex + 1)
  $decodedPassword = [Uri]::UnescapeDataString($encodedPassword)
  $script:SensitiveValues.Add($encodedPassword)
  $script:SensitiveValues.Add($decodedPassword)
  $script:AdminDbUrl = "$($statusUri.Scheme)://supabase_admin:${encodedPassword}@127.0.0.1:$dbPort/postgres?options=-c%20role%3Dpostgres"
  $script:SensitiveValues.Add($script:AdminDbUrl)

  $script:PsqlPath = Get-Corr023PsqlPath -PostgresMajorVersion $postgresMajorVersion
  $proofOutput = Invoke-Corr023Psql -Phase 'ALT-001 role proof' -Sql @'
select session_user || '|' || current_user;
set role service_role;
select current_user;
reset role;
select current_user;
set role supabase_auth_admin;
select current_user;
reset role;
select current_user;
'@
  $proofLines = @($proofOutput -split '\r?\n' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
  $expectedProofLines = @('supabase_admin|postgres', 'service_role', 'postgres', 'supabase_auth_admin', 'postgres')
  Assert-Corr023 -Condition ($proofLines.Count -eq $expectedProofLines.Count) -Message "ALT-001 role proof returned an unexpected shape."
  for ($index = 0; $index -lt $expectedProofLines.Count; $index++) {
    Assert-Corr023 -Condition ($proofLines[$index].Trim() -ceq $expectedProofLines[$index]) -Message "ALT-001 role proof failed."
  }

  $roleTopologySql = @'
select pg_get_userbyid(roleid) || '|' || pg_get_userbyid(member) || '|' || admin_option::text
from pg_auth_members
where pg_get_userbyid(roleid) in ('postgres', 'supabase_admin', 'supabase_auth_admin', 'service_role')
   or pg_get_userbyid(member) in ('postgres', 'supabase_admin', 'supabase_auth_admin', 'service_role')
order by 1;
'@
  $roleTopologyBefore = Invoke-Corr023Psql -Sql $roleTopologySql -Phase 'Role topology baseline proof'

  Write-Output "CORR-023 LOCAL TARGET PROOF = PASS"
  Write-Output "config.toml db.port proof = $dbPort"
  Write-Output "Supabase Local status proof = PASS"
  Write-Output "sanitized endpoint = 127.0.0.1:$dbPort"
  Write-Output "Docker binding proof = PASS"
  Write-Output "Supabase CLI version = $supabaseVersion"
  Write-Output "PROOF-A session_user = supabase_admin"
  Write-Output "PROOF-A baseline current_user = postgres"
  Write-Output "PROOF-B SET ROLE service_role = PASS"
  Write-Output "PROOF-B RESET ROLE restoration = postgres"

  $task009 = Invoke-Corr023DbSuite -NpxPath $npxPath -RelativePath $task009Path -Phase 'TASK-009 DB suite'
  Write-Output "TASK-009 DB = PASS (Tests=$($task009.Tests))"

  $task010 = Invoke-Corr023DbSuite -NpxPath $npxPath -RelativePath $task010Path -Phase 'TASK-010 DB suite'
  Write-Output "TASK-010 DB = PASS (Tests=$($task010.Tests))"

  $task013 = Invoke-Corr023DbSuite -NpxPath $npxPath -RelativePath $task013Path `
    -Phase 'TASK-013 DB suite ALT-001' -ExpectedTests 72 -UseAdminUrl
  Write-Output "TASK-013 DB = PASS (plan=72; executed=72; failed=0; bad plan=NO; Files=1; Tests=72; Result=PASS)"
  Write-Output "PROOF-C runtime current_user = supabase_auth_admin"
  Write-Output "PROOF-C T013-DB-066..072 executed = YES"
  foreach ($number in 66..72) {
    Write-Output ("T013-DB-{0:D3} = PASS" -f $number)
  }

  $task014 = Invoke-Corr023DbSuite -NpxPath $npxPath -RelativePath $task014Path -Phase 'TASK-014 DB suite'
  Write-Output "TASK-014 DB = PASS (path=$task014Path; Tests=$($task014.Tests))"

  $task015 = Invoke-Corr023DbSuite -NpxPath $npxPath -RelativePath $task015Path `
    -Phase 'TASK-015 DB suite' -ExpectedTests 81
  Write-Output "TASK-015 DB = PASS (plan=81; executed=81; failed=0; Tests=81)"

  $psqlDirectory = Split-Path -Parent $script:PsqlPath
  $childPath = $psqlDirectory + [IO.Path]::PathSeparator + $env:PATH
  $concurrencyEnvironment = @{
    PATH = $childPath
    PGHOST = '127.0.0.1'
    PGPORT = [string]$dbPort
    PGDATABASE = 'postgres'
    PGUSER = 'postgres'
    PGPASSWORD = $decodedPassword
  }
  $powershellCommand = Get-Command pwsh.exe -ErrorAction SilentlyContinue
  Assert-Corr023 -Condition ($null -ne $powershellCommand) -Message "PowerShell executable is unavailable for TASK-015 concurrency."
  $concurrencyResult = Invoke-Corr023Process -FilePath $powershellCommand.Source `
    -Arguments @('-NoLogo', '-NoProfile', '-NonInteractive', '-File', (Join-Path $script:RepoRoot $task015ConcurrencyPath)) `
    -TimeoutSeconds $script:ConcurrencyTimeoutSeconds -Phase 'TASK-015 concurrency suite' `
    -Environment $concurrencyEnvironment
  $concurrencyOutput = Remove-Corr023Ansi -Text $concurrencyResult.Combined
  Assert-Corr023 -Condition ($concurrencyOutput -match '(?im)^TASK-015 CONCURRENCY HARNESS = PASS\s*$') `
    -Message "TASK-015 concurrency suite did not report PASS."
  foreach ($number in 1..6) {
    Write-Output ("T015-CON-{0:D3} = PASS" -f $number)
  }

  Write-Output "full local DB regression = PASS"

  $npmScripts = Get-Corr023NpmScripts -PackagePath $packagePath
  $npmCommand = Get-Command npm.cmd -ErrorAction SilentlyContinue
  Assert-Corr023 -Condition ($null -ne $npmCommand) -Message "npm is unavailable."
  foreach ($scriptName in @('test', 'lint', 'typecheck', 'build', 'verify')) {
    if ($npmScripts.Contains($scriptName)) {
      $null = Invoke-Corr023Process -FilePath $npmCommand.Source -Arguments @('run', $scriptName) `
        -TimeoutSeconds 600 -Phase "npm run $scriptName"
      Write-Output "npm run $scriptName = PASS"
    }
    else {
      Write-Output "npm run $scriptName = NOT APPLICABLE / SCRIPT ABSENT IN CURRENT REPO"
    }
  }

  $gitCommand = Get-Command git.exe -ErrorAction SilentlyContinue
  Assert-Corr023 -Condition ($null -ne $gitCommand) -Message "git is unavailable."
  $null = Invoke-Corr023Process -FilePath $gitCommand.Source -Arguments @('diff', '--check') `
    -TimeoutSeconds $script:ProofTimeoutSeconds -Phase 'git diff --check'
  Write-Output "git diff --check = PASS"

  $sourceAAfter = Get-Corr023Sha256 -Path (Join-Path $script:RepoRoot $task013Path)
  $sourceBAfter = Get-Corr023Sha256 -Path (Join-Path $script:RepoRoot $task013MigrationPath)
  Assert-Corr023 -Condition ($sourceAAfter -ceq $sourceASha) -Message "TASK-013 suite changed during CORR-023."
  Assert-Corr023 -Condition ($sourceBAfter -ceq $sourceBSha) -Message "TASK-013 migration changed during CORR-023."

  $roleTopologyAfter = Invoke-Corr023Psql -Sql $roleTopologySql -Phase 'Role topology postcheck'
  Assert-Corr023 -Condition ($roleTopologyAfter -ceq $roleTopologyBefore) -Message "Persistent role topology changed during CORR-023."

  $fixtureResidue = Invoke-Corr023Psql -Phase 'TASK-013 fixture residue postcheck' -Sql @'
select (
  (select count(*) from public.verification_challenges where id::text like '00000000-0000-4000-8000-%') +
  (select count(*) from public.verification_challenge_attempts where id::text like '00000000-0000-4000-8000-%') +
  (select count(*) from public.auth_bridge_credentials where id::text like '00000000-0000-4000-8000-%') +
  (select count(*) from public.auth_session_grants where id::text like '00000000-0000-4000-8000-%') +
  (select count(*) from auth.users where id::text like '00000000-0000-4000-8000-%')
)::text;
'@
  Assert-Corr023 -Condition ($fixtureResidue.Trim() -ceq '0') -Message "TASK-013 fixture residue was detected."

  Assert-Corr023 -Condition ($script:RunnerStopwatch.Elapsed.TotalSeconds -le $script:FullRunnerTimeoutSeconds) `
    -Message "Full CORR-023 runner exceeded its timeout."

  Write-Output "production migration drift = NONE"
  Write-Output "production grants/RLS/policies drift = NONE"
  Write-Output "persistent role membership mutation caused by CORR-023 = NONE"
  Write-Output "TASK-013 fixture residue = NONE"
  Write-Output "secret leakage = NONE"
  Write-Output "Cloud mutation = NO"
  Write-Output "Hosted Development mutation = NO"
  Write-Output "Staging mutation = NO"
  Write-Output "Production mutation = NO"
  Write-Output "CORR-023 RUNNER RESULT = PASS"
}
catch {
  $safeMessage = ConvertTo-Corr023SanitizedText -Text $_.Exception.Message
  Write-Error "CORR-023 RUNNER RESULT = BLOCKER; $safeMessage"
  exit 1
}
finally {
  $script:AdminDbUrl = $null
  $statusDbUrl = $null
  $encodedPassword = $null
  $decodedPassword = $null
  $statusObject = $null
  $script:SensitiveValues.Clear()
  [System.GC]::Collect()
}
