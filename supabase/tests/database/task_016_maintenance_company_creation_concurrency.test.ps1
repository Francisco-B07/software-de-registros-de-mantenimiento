[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

if ($null -eq (Get-Command psql -ErrorAction SilentlyContinue)) {
  throw "psql is required for the TASK-016 concurrency harness."
}

$task016Jobs = [System.Collections.Generic.List[object]]::new()
$previousConnectTimeout = $env:PGCONNECT_TIMEOUT
$env:PGCONNECT_TIMEOUT = "5"
$jobTimeoutSeconds = 35
$subjectOne = "96990000-0000-4000-8000-000000000001"
$subjectTwo = "96990000-0000-4000-8000-000000000002"
$userOne = "16990000-0000-4000-8000-000000000101"
$userTwo = "16990000-0000-4000-8000-000000000102"
$sameOperation = "16990000-0000-4000-8000-000000001001"
$distinctOperationA = "16990000-0000-4000-8000-000000001002"
$distinctOperationB = "16990000-0000-4000-8000-000000001003"

function Invoke-Task016Psql {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $boundedSql = "set statement_timeout = '30s'; set lock_timeout = '20s'; $Sql"
  $output = & psql --no-psqlrc --quiet --set=ON_ERROR_STOP=1 --tuples-only --no-align --command $boundedSql 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Bounded TASK-016 psql command failed."
  }

  return ($output -join [Environment]::NewLine).Trim()
}

function Start-Task016PsqlJob {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $boundedSql = "set statement_timeout = '30s'; set lock_timeout = '20s'; $Sql"
  $job = Start-Job -ScriptBlock {
    param($Statement)
    $result = & psql --no-psqlrc --quiet --set=ON_ERROR_STOP=1 --tuples-only --no-align --command $Statement 2>&1
    if ($LASTEXITCODE -ne 0) {
      throw "Bounded TASK-016 concurrent worker failed."
    }
    ($result -join [Environment]::NewLine).Trim()
  } -ArgumentList $boundedSql
  $script:task016Jobs.Add($job) | Out-Null
  return $job
}

function Receive-Task016Job {
  param([Parameter(Mandatory = $true)]$Job)

  $completed = Wait-Job -Job $Job -Timeout $script:jobTimeoutSeconds
  if ($null -eq $completed) {
    Stop-Job -Job $Job -ErrorAction SilentlyContinue
    throw "TASK-016 concurrent worker timed out."
  }
  $result = Receive-Job -Job $Job -ErrorAction SilentlyContinue
  if ($Job.State -ne "Completed") {
    throw "TASK-016 concurrent worker failed."
  }
  Remove-Job -Job $Job -Force -ErrorAction SilentlyContinue
  return ($result -join [Environment]::NewLine).Trim()
}

function New-Task016CallSql {
  param(
    [Parameter(Mandatory = $true)][string]$SubjectId,
    [Parameter(Mandatory = $true)][string]$OperationId
  )

  return @"
begin;
set local role authenticated;
do `$claim`$
begin
  perform set_config('request.jwt.claim.sub', '$SubjectId', true);
end;
`$claim`$;
select outcome || '|' || maintenance_company_id::text
from public.create_maintenance_company('$OperationId');
commit;
"@
}

function Assert-Task016 {
  param(
    [Parameter(Mandatory = $true)][bool]$Condition,
    [Parameter(Mandatory = $true)][string]$Label
  )

  if (-not $Condition) {
    throw "$Label failed."
  }
  Write-Output "$Label = PASS"
}

$cleanupSql = @"
delete from public.maintenance_companies
where creation_operation_id in ('$sameOperation', '$distinctOperationA', '$distinctOperationB');
delete from public.platform_user_auth_subjects
where auth_subject_id in ('$subjectOne', '$subjectTwo');
delete from public.platform_users
where id in ('$userOne', '$userTwo');
delete from auth.users
where id in ('$subjectOne', '$subjectTwo');
"@

$setupSql = @"
$cleanupSql
insert into auth.users (id) values ('$subjectOne'), ('$subjectTwo');
insert into public.platform_users (id, is_super_admin)
values ('$userOne', true), ('$userTwo', true);
insert into public.platform_user_auth_subjects (auth_subject_id, platform_user_id)
values ('$subjectOne', '$userOne'), ('$subjectTwo', '$userTwo');
"@

try {
  Invoke-Task016Psql -Sql $setupSql | Out-Null

  $sameA = Start-Task016PsqlJob -Sql (New-Task016CallSql -SubjectId $subjectOne -OperationId $sameOperation)
  $sameB = Start-Task016PsqlJob -Sql (New-Task016CallSql -SubjectId $subjectOne -OperationId $sameOperation)
  $sameResultA = Receive-Task016Job -Job $sameA
  $sameResultB = Receive-Task016Job -Job $sameB
  $sameResults = @($sameResultA, $sameResultB)
  $sameRows = Invoke-Task016Psql -Sql "select count(*) from public.maintenance_companies where creation_operation_id = '$sameOperation';"
  $sameIds = @($sameResults | ForEach-Object { ($_ -split '\|')[1] } | Sort-Object -Unique)

  Assert-Task016 -Condition ($sameRows -eq "1") -Label "T016-CON-001"
  Assert-Task016 -Condition ($sameIds.Count -eq 1 -and -not [string]::IsNullOrWhiteSpace($sameIds[0])) -Label "T016-CON-002"

  $distinctA = Start-Task016PsqlJob -Sql (New-Task016CallSql -SubjectId $subjectOne -OperationId $distinctOperationA)
  $distinctB = Start-Task016PsqlJob -Sql (New-Task016CallSql -SubjectId $subjectTwo -OperationId $distinctOperationB)
  $distinctResultA = Receive-Task016Job -Job $distinctA
  $distinctResultB = Receive-Task016Job -Job $distinctB
  $distinctResults = @($distinctResultA, $distinctResultB)
  $distinctRows = Invoke-Task016Psql -Sql "select count(*) from public.maintenance_companies where creation_operation_id in ('$distinctOperationA', '$distinctOperationB');"

  Assert-Task016 -Condition ($distinctRows -eq "2" -and (@($distinctResults | Where-Object { $_ -like 'CREATED|*' }).Count -eq 2)) -Label "T016-CON-003"
  Assert-Task016 -Condition ((@($sameResults | ForEach-Object { ($_ -split '\|')[0] } | Sort-Object) -join ',') -eq 'ALREADY_CREATED,CREATED') -Label "T016-CON-004"

  Write-Output "TASK-016 CONCURRENCY HARNESS = PASS"
}
finally {
  $task016Jobs | Where-Object { $_.State -in @("Running", "NotStarted") } |
    Stop-Job -ErrorAction SilentlyContinue
  $task016Jobs | Remove-Job -Force -ErrorAction SilentlyContinue
  Invoke-Task016Psql -Sql $cleanupSql | Out-Null
  if ($null -eq $previousConnectTimeout) {
    Remove-Item -LiteralPath Env:PGCONNECT_TIMEOUT -ErrorAction SilentlyContinue
  } else {
    $env:PGCONNECT_TIMEOUT = $previousConnectTimeout
  }
}
