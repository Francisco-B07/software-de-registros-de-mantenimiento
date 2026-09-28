[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-Task019PsqlPath {
  $command = Get-Command psql.exe -ErrorAction SilentlyContinue
  if ($null -ne $command) {
    return $command.Source
  }

  $repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..\..')).Path
  $configPath = Join-Path $repoRoot 'supabase\config.toml'
  $versions = @(
    Get-Content -LiteralPath $configPath |
      Select-String -Pattern '^\s*major_version\s*=\s*([0-9]+)\s*(?:#.*)?$' |
      ForEach-Object { [int]$_.Matches[0].Groups[1].Value }
  )
  if ($versions.Count -ne 1) {
    throw "supabase/config.toml PostgreSQL major version is missing or ambiguous."
  }

  $candidate = Join-Path ([Environment]::GetFolderPath('ProgramFiles')) `
    "PostgreSQL\$($versions[0])\bin\psql.exe"
  if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
    throw "psql is required for the TASK-019 concurrency harness."
  }
  return $candidate
}

$script:Task019PsqlPath = Get-Task019PsqlPath
$script:Task019Jobs = [System.Collections.Generic.List[object]]::new()
$script:Task019SqlStatePattern = '(?im)\b(40P01|55P03|57014):'
$previousConnectTimeout = $env:PGCONNECT_TIMEOUT
$env:PGCONNECT_TIMEOUT = "5"
$script:Task019WorkerTimeoutSeconds = 42
$script:Task019ReadinessTimeoutSeconds = 12

$actorSubject = "19190000-0000-4000-8000-000000000900"
$actorPlatformUser = "19190000-0000-4000-8000-000000000901"

$subjectA = "19190000-0000-4000-8000-000000000001"
$subjectB = "19190000-0000-4000-8000-000000000002"
$subjectC = "19190000-0000-4000-8000-000000000003"
$subjectDTarget = "19190000-0000-4000-8000-000000000004"
$subjectDUnrelated = "19190000-0000-4000-8000-000000000005"
$subjectDDenied = "19190000-0000-4000-8000-000000000006"

$companyA = "19190000-0000-4000-8000-000000000101"
$companyB = "19190000-0000-4000-8000-000000000102"
$companyC = "19190000-0000-4000-8000-000000000103"
$companyDTarget = "19190000-0000-4000-8000-000000000104"
$companyDUnrelated = "19190000-0000-4000-8000-000000000105"
$companyDDenied = "19190000-0000-4000-8000-000000000106"

$challengeA = "19190000-0000-4000-8000-000000000201"
$challengeB = "19190000-0000-4000-8000-000000000202"
$challengeC = "19190000-0000-4000-8000-000000000203"
$challengeDTarget = "19190000-0000-4000-8000-000000000204"
$challengeDUnrelated = "19190000-0000-4000-8000-000000000205"
$challengeDDenied = "19190000-0000-4000-8000-000000000206"

$intentA = "19190000-0000-4000-8000-000000000501"
$intentB = "19190000-0000-4000-8000-000000000502"
$intentC = "19190000-0000-4000-8000-000000000503"
$intentDTarget = "19190000-0000-4000-8000-000000000504"
$intentDUnrelated = "19190000-0000-4000-8000-000000000505"
$intentDDenied = "19190000-0000-4000-8000-000000000506"

$establishmentA = "19190000-0000-4000-8000-000000000601"
$establishmentB = "19190000-0000-4000-8000-000000000602"
$establishmentC = "19190000-0000-4000-8000-000000000603"
$establishmentDTarget = "19190000-0000-4000-8000-000000000604"
$establishmentDUnrelated = "19190000-0000-4000-8000-000000000605"
$establishmentDDenied = "19190000-0000-4000-8000-000000000606"

$issueC = "19190000-0000-4000-8000-000000000703"
$operationA = "19190000-0000-4000-8000-000000000801"
$operationBA = "19190000-0000-4000-8000-000000000802"
$operationBB = "19190000-0000-4000-8000-000000000803"
$operationC = "19190000-0000-4000-8000-000000000804"
$operationDTarget = "19190000-0000-4000-8000-000000000805"
$operationDUnrelated = "19190000-0000-4000-8000-000000000806"
$operationDDenied = "19190000-0000-4000-8000-000000000807"

function Add-Task019Timeouts {
  param([Parameter(Mandatory = $true)][string]$Sql)

  return "set statement_timeout = '30s'; set lock_timeout = '25s'; $Sql"
}

function Invoke-Task019Psql {
  param(
    [Parameter(Mandatory = $true)][string]$Sql,
    [string]$Phase = "TASK-019 psql command"
  )

  $output = & $script:Task019PsqlPath --no-psqlrc --quiet --set=ON_ERROR_STOP=1 `
    --set=VERBOSITY=verbose --tuples-only --no-align `
    --command (Add-Task019Timeouts -Sql $Sql) 2>&1
  $exitCode = $LASTEXITCODE
  $text = ($output -join [Environment]::NewLine).Trim()
  if ($exitCode -ne 0) {
    throw "$Phase failed with exit code $exitCode. Output: $text"
  }
  return $text
}

function Start-Task019Worker {
  param(
    [Parameter(Mandatory = $true)][string]$Sql,
    [Parameter(Mandatory = $true)][string]$Name
  )

  $boundedSql = Add-Task019Timeouts -Sql $Sql
  $job = Start-Job -ScriptBlock {
    param($PsqlPath, $Statement, $WorkerName, $SqlStatePattern)

    $startedAt = [DateTime]::UtcNow
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $process = $null
    try {
      $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
      $startInfo.FileName = $PsqlPath
      $startInfo.UseShellExecute = $false
      $startInfo.CreateNoWindow = $true
      $startInfo.RedirectStandardOutput = $true
      $startInfo.RedirectStandardError = $true
      foreach ($argument in @(
        '--no-psqlrc',
        '--quiet',
        '--set=ON_ERROR_STOP=1',
        '--set=VERBOSITY=verbose',
        '--tuples-only',
        '--no-align',
        '--command',
        $Statement
      )) {
        $startInfo.ArgumentList.Add($argument)
      }

      $process = [System.Diagnostics.Process]::new()
      $process.StartInfo = $startInfo
      if (-not $process.Start()) {
        throw "psql did not start."
      }

      $stdoutTask = $process.StandardOutput.ReadToEndAsync()
      $stderrTask = $process.StandardError.ReadToEndAsync()
      $process.WaitForExit()
      $stdout = $stdoutTask.GetAwaiter().GetResult().Trim()
      $stderr = $stderrTask.GetAwaiter().GetResult().Trim()
      $exitCode = $process.ExitCode
      $combined = ($stdout + [Environment]::NewLine + $stderr).Trim()
      $databaseErrorCode = "NONE"
      if ($combined -match $SqlStatePattern) {
        $databaseErrorCode = $Matches[1]
      }

      $classification = "PASS"
      if ($exitCode -ne 0) {
        if ($databaseErrorCode -eq "40P01") {
          $classification = "POSTGRES_DEADLOCK"
        }
        elseif ($databaseErrorCode -in @("55P03", "57014")) {
          $classification = "TIMEOUT_OR_HANG"
        }
        else {
          $classification = "UNEXPECTED_SQL_FAILURE"
        }
      }

      return [pscustomobject]@{
        Name = $WorkerName
        Classification = $classification
        ExitCode = $exitCode
        StdOut = $stdout
        StdErr = $stderr
        DatabaseErrorCode = $databaseErrorCode
        StartedAtUtc = $startedAt.ToString("o")
        FinishedAtUtc = [DateTime]::UtcNow.ToString("o")
        ElapsedMilliseconds = [int64]$stopwatch.ElapsedMilliseconds
        TimedOut = $false
      }
    }
    catch {
      return [pscustomobject]@{
        Name = $WorkerName
        Classification = "UNEXPECTED_SQL_FAILURE"
        ExitCode = -1
        StdOut = ""
        StdErr = $_.Exception.Message
        DatabaseErrorCode = "NONE"
        StartedAtUtc = $startedAt.ToString("o")
        FinishedAtUtc = [DateTime]::UtcNow.ToString("o")
        ElapsedMilliseconds = [int64]$stopwatch.ElapsedMilliseconds
        TimedOut = $false
      }
    }
    finally {
      if ($null -ne $process) {
        $process.Dispose()
      }
    }
  } -ArgumentList $script:Task019PsqlPath, $boundedSql, $Name, $script:Task019SqlStatePattern

  $script:Task019Jobs.Add($job) | Out-Null
  return [pscustomobject]@{ Job = $job; Name = $Name; StartedAtUtc = [DateTime]::UtcNow }
}

function Receive-Task019Worker {
  param([Parameter(Mandatory = $true)]$Handle)

  $completed = Wait-Job -Job $Handle.Job -Timeout $script:Task019WorkerTimeoutSeconds
  if ($null -eq $completed) {
    Stop-Job -Job $Handle.Job -ErrorAction SilentlyContinue
    Receive-Job -Job $Handle.Job -ErrorAction SilentlyContinue | Out-Null
    Remove-Job -Job $Handle.Job -Force -ErrorAction SilentlyContinue
    return [pscustomobject]@{
      Name = $Handle.Name
      Classification = "TIMEOUT_OR_HANG"
      ExitCode = -1
      StdOut = ""
      StdErr = "Worker exceeded $($script:Task019WorkerTimeoutSeconds) seconds."
      DatabaseErrorCode = "NONE"
      StartedAtUtc = $Handle.StartedAtUtc.ToString("o")
      FinishedAtUtc = [DateTime]::UtcNow.ToString("o")
      ElapsedMilliseconds = [int64]($script:Task019WorkerTimeoutSeconds * 1000)
      TimedOut = $true
    }
  }

  $result = @(Receive-Job -Job $Handle.Job -ErrorAction SilentlyContinue)[0]
  $state = $Handle.Job.State
  Remove-Job -Job $Handle.Job -Force -ErrorAction SilentlyContinue
  if ($state -ne "Completed" -or $null -eq $result) {
    return [pscustomobject]@{
      Name = $Handle.Name
      Classification = "UNEXPECTED_SQL_FAILURE"
      ExitCode = -1
      StdOut = ""
      StdErr = "PowerShell worker ended with state $state."
      DatabaseErrorCode = "NONE"
      StartedAtUtc = $Handle.StartedAtUtc.ToString("o")
      FinishedAtUtc = [DateTime]::UtcNow.ToString("o")
      ElapsedMilliseconds = 0
      TimedOut = $false
    }
  }
  return $result
}

function Write-Task019WorkerEvidence {
  param(
    [Parameter(Mandatory = $true)]$Result,
    [Parameter(Mandatory = $true)][string]$Label
  )

  $stdout = if ([string]::IsNullOrWhiteSpace([string]$Result.StdOut)) { "<empty>" } else { [string]$Result.StdOut }
  $stderr = if ([string]::IsNullOrWhiteSpace([string]$Result.StdErr)) { "<empty>" } else { [string]$Result.StdErr }
  Write-Output "$Label name = $($Result.Name)"
  Write-Output "$Label classification = $($Result.Classification)"
  Write-Output "$Label exit code = $($Result.ExitCode)"
  Write-Output "$Label stdout = $stdout"
  Write-Output "$Label stderr = $stderr"
  Write-Output "$Label database error code = $($Result.DatabaseErrorCode)"
  Write-Output "$Label started UTC = $($Result.StartedAtUtc)"
  Write-Output "$Label finished UTC = $($Result.FinishedAtUtc)"
  Write-Output "$Label elapsed milliseconds = $($Result.ElapsedMilliseconds)"
  Write-Output "$Label timeout/hang = $($Result.TimedOut)"
}

function Assert-Task019 {
  param(
    [Parameter(Mandatory = $true)][bool]$Condition,
    [Parameter(Mandatory = $true)][string]$Label
  )

  if (-not $Condition) {
    throw "$Label failed."
  }
  Write-Output "$Label = PASS"
}

function Assert-Task019WorkerPass {
  param(
    [Parameter(Mandatory = $true)]$Result,
    [Parameter(Mandatory = $true)][string]$Label
  )

  Write-Task019WorkerEvidence -Result $Result -Label $Label
  Assert-Task019 -Condition ($Result.Classification -eq "PASS") -Label "$Label process"
  Assert-Task019 -Condition ($Result.DatabaseErrorCode -ne "40P01") -Label "$Label deadlock absent"
  Assert-Task019 -Condition (-not $Result.TimedOut) -Label "$Label timeout absent"
}

function Wait-Task019SqlValue {
  param(
    [Parameter(Mandatory = $true)][string]$Sql,
    [Parameter(Mandatory = $true)][string]$Expected,
    [Parameter(Mandatory = $true)][string]$Label
  )

  $deadline = [DateTime]::UtcNow.AddSeconds($script:Task019ReadinessTimeoutSeconds)
  $actual = ""
  do {
    $actual = Invoke-Task019Psql -Sql $Sql -Phase $Label
    if ($actual -eq $Expected) {
      Write-Output "$Label = PASS"
      return
    }
    Start-Sleep -Milliseconds 100
  } while ([DateTime]::UtcNow -lt $deadline)

  throw "$Label timed out; expected '$Expected', received '$actual'."
}

function New-Task019CompletionSql {
  param(
    [Parameter(Mandatory = $true)][string]$SubjectId,
    [Parameter(Mandatory = $true)][string]$FirstName,
    [Parameter(Mandatory = $true)][string]$LastName,
    [Parameter(Mandatory = $true)][string]$OperationId,
    [Parameter(Mandatory = $true)][string]$ApplicationName
  )

  return @"
set application_name = '$ApplicationName';
begin;
set local role authenticated;
do `$claim`$
begin
  perform set_config('request.jwt.claim.sub', '$SubjectId', true);
end;
`$claim`$;
select
  outcome || '|' || reason || '|' ||
  coalesce(platform_user_id::text, 'NULL') || '|' ||
  coalesce(company_membership_id::text, 'NULL') || '|' ||
  coalesce(completed_at::text, 'NULL')
from public.complete_first_admin_onboarding('$FirstName', '$LastName', '$OperationId');
commit;
"@
}

function New-Task019Task017ReconcileSql {
  param([Parameter(Mandatory = $true)][string]$ApplicationName)

  return @"
set application_name = '$ApplicationName';
begin;
set local role authenticated;
do `$claim`$
begin
  perform set_config('request.jwt.claim.sub', '$actorSubject', true);
end;
`$claim`$;
select
  outcome || '|' || reason || '|' ||
  coalesce(intent_id::text, 'NULL') || '|' || coalesce(challenge_id::text, 'NULL')
from public.establish_first_admin_onboarding_intent(
  '$intentC',
  '$companyC',
  'task019-con-c@example.test',
  '$establishmentC',
  '$challengeC',
  decode(repeat('c3', 32), 'hex'),
  'task019-con-v1',
  '$issueC'
);
commit;
"@
}

function Get-Task019DurableState {
  param(
    [Parameter(Mandatory = $true)][string]$SubjectId,
    [Parameter(Mandatory = $true)][string]$IntentId,
    [Parameter(Mandatory = $true)][string]$CompanyId
  )

  return Invoke-Task019Psql -Phase "durable state $IntentId" -Sql @"
select
  (select count(*) from public.platform_user_auth_subjects
   where auth_subject_id = '$SubjectId') || '|' ||
  (select count(*)
   from public.platform_users as platform_user
   join public.platform_user_auth_subjects as auth_subject
     on auth_subject.platform_user_id = platform_user.id
   where auth_subject.auth_subject_id = '$SubjectId') || '|' ||
  (select count(*)
   from public.company_memberships as membership
   join public.platform_user_auth_subjects as auth_subject
     on auth_subject.platform_user_id = membership.platform_user_id
   where auth_subject.auth_subject_id = '$SubjectId'
     and membership.maintenance_company_id = '$CompanyId'
     and membership.role = 'COMPANY_ADMIN'
     and membership.is_enabled) || '|' ||
  (select count(*)
   from public.audit_events as audit_event
   join public.platform_user_auth_subjects as auth_subject
     on auth_subject.platform_user_id = audit_event.subject_platform_user_id
   where auth_subject.auth_subject_id = '$SubjectId'
     and audit_event.maintenance_company_id = '$CompanyId'
     and audit_event.actor_kind = 'PLATFORM_USER'
     and audit_event.actor_platform_user_id = '$actorPlatformUser'
     and audit_event.actor_internal_process_key is null
     and audit_event.action = 'USER_CREATED'
     and audit_event.scope_kind = 'USER'
     and audit_event.role_before is null
     and audit_event.role_after is null) || '|' ||
  (select count(*)
   from public.first_admin_onboarding_intents as intent
   where intent.id = '$IntentId'
     and intent.completion_operation_id is not null
     and intent.completed_platform_user_id is not null
     and intent.completed_company_membership_id is not null
     and intent.completed_at is not null) || '|' ||
  (select count(*)
   from public.first_admin_onboarding_intents as intent
   join public.platform_user_auth_subjects as auth_subject
     on auth_subject.auth_subject_id = '$SubjectId'
    and auth_subject.platform_user_id = intent.completed_platform_user_id
   join public.platform_users as platform_user
     on platform_user.id = intent.completed_platform_user_id
    and platform_user.profile_completed_at = intent.completed_at
   join public.company_memberships as membership
     on membership.id = intent.completed_company_membership_id
    and membership.platform_user_id = platform_user.id
    and membership.maintenance_company_id = intent.maintenance_company_id
    and membership.role = 'COMPANY_ADMIN'
    and membership.is_enabled
   where intent.id = '$IntentId'
     and intent.maintenance_company_id = '$CompanyId') || '|' ||
  (select count(*)
   from public.platform_users as platform_user
   join public.platform_user_auth_subjects as auth_subject
     on auth_subject.platform_user_id = platform_user.id
   where auth_subject.auth_subject_id = '$SubjectId'
     and (
       platform_user.first_name is null
       or platform_user.last_name is null
       or platform_user.profile_completed_at is null
     )) || '|' ||
  coalesce((select completion_operation_id::text
            from public.first_admin_onboarding_intents
            where id = '$IntentId'), 'NONE') || '|' ||
  coalesce((select platform_user.first_name || '/' || platform_user.last_name
            from public.platform_users as platform_user
            join public.platform_user_auth_subjects as auth_subject
              on auth_subject.platform_user_id = platform_user.id
            where auth_subject.auth_subject_id = '$SubjectId'), 'NONE');
"@
}

function Assert-Task019CompletedState {
  param(
    [Parameter(Mandatory = $true)][string]$State,
    [Parameter(Mandatory = $true)][string[]]$AllowedOperations,
    [Parameter(Mandatory = $true)][string[]]$AllowedProfiles,
    [Parameter(Mandatory = $true)][string]$Label
  )

  Write-Output "$Label durable state = $State"
  $parts = $State -split '\|'
  Assert-Task019 -Condition ($parts.Count -eq 9) -Label "$Label state shape"
  Assert-Task019 -Condition (($parts[0..6] -join '|') -eq '1|1|1|1|1|1|0') -Label "$Label atomic counts"
  Assert-Task019 -Condition ($parts[7] -in $AllowedOperations) -Label "$Label completion operation"
  Assert-Task019 -Condition ($parts[8] -in $AllowedProfiles) -Label "$Label completed profile"
}

$cleanupSql = @"
drop trigger if exists task019_concurrency_test_delay on public.audit_events;
drop function if exists public.task019_concurrency_test_delay();

begin;
create temporary table task019_cleanup_platform_users (
  id uuid primary key
) on commit drop;

insert into task019_cleanup_platform_users (id)
select platform_user_id
from public.platform_user_auth_subjects
where auth_subject_id::text like '19190000-%'
on conflict do nothing;

insert into task019_cleanup_platform_users (id)
values ('$actorPlatformUser')
on conflict do nothing;

delete from public.audit_events
where maintenance_company_id::text like '19190000-%'
   or actor_platform_user_id in (select id from task019_cleanup_platform_users)
   or subject_platform_user_id in (select id from task019_cleanup_platform_users);

delete from public.first_admin_onboarding_intents
where id::text like '19190000-%'
   or maintenance_company_id::text like '19190000-%';

delete from public.company_memberships
where maintenance_company_id::text like '19190000-%'
   or platform_user_id in (select id from task019_cleanup_platform_users);

delete from public.platform_user_auth_subjects
where auth_subject_id::text like '19190000-%'
   or platform_user_id in (select id from task019_cleanup_platform_users);

delete from public.platform_users
where id in (select id from task019_cleanup_platform_users)
   or id::text like '19190000-%';

delete from public.auth_session_grants where id::text like '19190000-%';
delete from public.auth_bridge_credentials where id::text like '19190000-%';
delete from public.verification_challenges where id::text like '19190000-%';
delete from public.maintenance_companies where id::text like '19190000-%';
delete from auth.users where id::text like '19190000-%';
commit;
"@

$setupSql = @"
$cleanupSql

insert into auth.users (id, email)
values
  ('$actorSubject', 'task019-con-actor@example.test'),
  ('$subjectA', 'task019-con-a@example.test'),
  ('$subjectB', 'task019-con-b@example.test'),
  ('$subjectC', 'task019-con-c@example.test'),
  ('$subjectDTarget', 'task019-con-d-target@example.test'),
  ('$subjectDUnrelated', 'task019-con-d-unrelated@example.test'),
  ('$subjectDDenied', 'task019-con-d-denied@example.test');

insert into public.maintenance_companies (id)
values
  ('$companyA'),
  ('$companyB'),
  ('$companyC'),
  ('$companyDTarget'),
  ('$companyDUnrelated'),
  ('$companyDDenied');

insert into public.platform_users (id, is_super_admin)
values ('$actorPlatformUser', true);

insert into public.platform_user_auth_subjects (auth_subject_id, platform_user_id)
values ('$actorSubject', '$actorPlatformUser');

insert into public.verification_challenges (
  id, email, verifier, verifier_key_version, issued_at, expires_at,
  attempt_count, consumed_at, issue_operation_id
)
values
  ('$challengeA', 'task019-con-a@example.test', decode(repeat('a1', 32), 'hex'), 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() + interval '7 hours 48 minutes', 1, statement_timestamp() - interval '11 minutes', '19190000-0000-4000-8000-000000000701'),
  ('$challengeB', 'task019-con-b@example.test', decode(repeat('b2', 32), 'hex'), 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() + interval '7 hours 48 minutes', 1, statement_timestamp() - interval '11 minutes', '19190000-0000-4000-8000-000000000702'),
  ('$challengeC', 'task019-con-c@example.test', decode(repeat('c3', 32), 'hex'), 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() + interval '7 hours 48 minutes', 1, statement_timestamp() - interval '11 minutes', '$issueC'),
  ('$challengeDTarget', 'task019-con-d-target@example.test', decode(repeat('d4', 32), 'hex'), 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() + interval '7 hours 48 minutes', 1, statement_timestamp() - interval '11 minutes', '19190000-0000-4000-8000-000000000704'),
  ('$challengeDUnrelated', 'task019-con-d-unrelated@example.test', decode(repeat('e5', 32), 'hex'), 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() + interval '7 hours 48 minutes', 1, statement_timestamp() - interval '11 minutes', '19190000-0000-4000-8000-000000000705'),
  ('$challengeDDenied', 'task019-con-d-denied@example.test', decode(repeat('f6', 32), 'hex'), 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() + interval '7 hours 48 minutes', 0, null, '19190000-0000-4000-8000-000000000706');

insert into public.auth_bridge_credentials (
  id, email, auth_user_id, technical_password_key_version, created_at, bound_at
)
values
  ('19190000-0000-4000-8000-000000000301', 'task019-con-a@example.test', '$subjectA', 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() - interval '11 minutes'),
  ('19190000-0000-4000-8000-000000000302', 'task019-con-b@example.test', '$subjectB', 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() - interval '11 minutes'),
  ('19190000-0000-4000-8000-000000000303', 'task019-con-c@example.test', '$subjectC', 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() - interval '11 minutes'),
  ('19190000-0000-4000-8000-000000000304', 'task019-con-d-target@example.test', '$subjectDTarget', 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() - interval '11 minutes'),
  ('19190000-0000-4000-8000-000000000305', 'task019-con-d-unrelated@example.test', '$subjectDUnrelated', 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() - interval '11 minutes'),
  ('19190000-0000-4000-8000-000000000306', 'task019-con-d-denied@example.test', '$subjectDDenied', 'task019-con-v1', statement_timestamp() - interval '12 minutes', statement_timestamp() - interval '11 minutes');

insert into public.auth_session_grants (
  id, challenge_id, auth_bridge_credential_id, auth_user_id,
  purpose, auth_method, created_at, expires_at, consumed_at, grant_operation_id
)
values
  ('19190000-0000-4000-8000-000000000401', '$challengeA', '19190000-0000-4000-8000-000000000301', '$subjectA', 'initial_session', 'password', statement_timestamp() - interval '10 minutes', statement_timestamp() - interval '5 minutes', statement_timestamp() - interval '9 minutes', '19190000-0000-4000-8000-000000000711'),
  ('19190000-0000-4000-8000-000000000402', '$challengeB', '19190000-0000-4000-8000-000000000302', '$subjectB', 'initial_session', 'password', statement_timestamp() - interval '10 minutes', statement_timestamp() - interval '5 minutes', statement_timestamp() - interval '9 minutes', '19190000-0000-4000-8000-000000000712'),
  ('19190000-0000-4000-8000-000000000403', '$challengeC', '19190000-0000-4000-8000-000000000303', '$subjectC', 'initial_session', 'password', statement_timestamp() - interval '10 minutes', statement_timestamp() - interval '5 minutes', statement_timestamp() - interval '9 minutes', '19190000-0000-4000-8000-000000000713'),
  ('19190000-0000-4000-8000-000000000404', '$challengeDTarget', '19190000-0000-4000-8000-000000000304', '$subjectDTarget', 'initial_session', 'password', statement_timestamp() - interval '10 minutes', statement_timestamp() - interval '5 minutes', statement_timestamp() - interval '9 minutes', '19190000-0000-4000-8000-000000000714'),
  ('19190000-0000-4000-8000-000000000405', '$challengeDUnrelated', '19190000-0000-4000-8000-000000000305', '$subjectDUnrelated', 'initial_session', 'password', statement_timestamp() - interval '10 minutes', statement_timestamp() - interval '5 minutes', statement_timestamp() - interval '9 minutes', '19190000-0000-4000-8000-000000000715'),
  ('19190000-0000-4000-8000-000000000406', '$challengeDDenied', '19190000-0000-4000-8000-000000000306', '$subjectDDenied', 'initial_session', 'password', statement_timestamp() - interval '10 minutes', statement_timestamp() - interval '5 minutes', null, '19190000-0000-4000-8000-000000000716');

insert into public.first_admin_onboarding_intents (
  id, maintenance_company_id, target_email, initiated_by_platform_user_id,
  establishment_operation_id, current_challenge_id, handoff_session_grant_id, handoff_ready_at
)
select fixture.intent_id, fixture.company_id, fixture.email, '$actorPlatformUser',
  fixture.establishment_id, fixture.challenge_id, fixture.grant_id, session_grant.created_at
from (
  values
    ('$intentA'::uuid, '$companyA'::uuid, 'task019-con-a@example.test', '$establishmentA'::uuid, '$challengeA'::uuid, '19190000-0000-4000-8000-000000000401'::uuid),
    ('$intentB'::uuid, '$companyB'::uuid, 'task019-con-b@example.test', '$establishmentB'::uuid, '$challengeB'::uuid, '19190000-0000-4000-8000-000000000402'::uuid),
    ('$intentC'::uuid, '$companyC'::uuid, 'task019-con-c@example.test', '$establishmentC'::uuid, '$challengeC'::uuid, '19190000-0000-4000-8000-000000000403'::uuid),
    ('$intentDTarget'::uuid, '$companyDTarget'::uuid, 'task019-con-d-target@example.test', '$establishmentDTarget'::uuid, '$challengeDTarget'::uuid, '19190000-0000-4000-8000-000000000404'::uuid),
    ('$intentDUnrelated'::uuid, '$companyDUnrelated'::uuid, 'task019-con-d-unrelated@example.test', '$establishmentDUnrelated'::uuid, '$challengeDUnrelated'::uuid, '19190000-0000-4000-8000-000000000405'::uuid),
    ('$intentDDenied'::uuid, '$companyDDenied'::uuid, 'task019-con-d-denied@example.test', '$establishmentDDenied'::uuid, '$challengeDDenied'::uuid, '19190000-0000-4000-8000-000000000406'::uuid)
) as fixture(intent_id, company_id, email, establishment_id, challenge_id, grant_id)
join public.auth_session_grants as session_grant on session_grant.id = fixture.grant_id;

create function public.task019_concurrency_test_delay()
returns trigger
language plpgsql
set search_path = ''
as `$task019_delay`$
begin
  if new.maintenance_company_id in (
    '$companyA'::uuid,
    '$companyB'::uuid,
    '$companyC'::uuid,
    '$companyDTarget'::uuid,
    '$companyDUnrelated'::uuid
  ) then
    perform pg_catalog.pg_sleep(5);
  end if;
  return new;
end;
`$task019_delay`$;

create trigger task019_concurrency_test_delay
before insert on public.audit_events
for each row execute function public.task019_concurrency_test_delay();
"@

try {
  Write-Output "fixture authority = local PostgreSQL administrative setup/cleanup only"
  Write-Output "caller authority = authenticated role through public TASK-017/TASK-019 boundaries"
  Write-Output "worker Auth subjects = $subjectA,$subjectB,$subjectC,$subjectDTarget,$subjectDUnrelated,$subjectDDenied"
  Invoke-Task019Psql -Sql $setupSql -Phase "TASK-019 concurrency fixture setup" | Out-Null

  Write-Output "SCENARIO A fixture = subject=$subjectA intent=$intentA company=$companyA operation=$operationA"
  $a1Name = "t019_a_worker_1"
  $a2Name = "t019_a_worker_2"
  $a1 = Start-Task019Worker -Name $a1Name -Sql (New-Task019CompletionSql -SubjectId $subjectA `
    -FirstName "Same" -LastName "Operation" -OperationId $operationA -ApplicationName $a1Name)
  Wait-Task019SqlValue -Expected "1" -Label "SCENARIO A worker 1 reached transactional delay" -Sql @"
select count(*) from pg_stat_activity
where application_name = '$a1Name' and state = 'active'
  and wait_event_type = 'Timeout' and wait_event = 'PgSleep';
"@
  $a2 = Start-Task019Worker -Name $a2Name -Sql (New-Task019CompletionSql -SubjectId $subjectA `
    -FirstName "Same" -LastName "Operation" -OperationId $operationA -ApplicationName $a2Name)
  Wait-Task019SqlValue -Expected "1" -Label "SCENARIO A real lock overlap" -Sql @"
select count(*)
from pg_stat_activity as waiter
where waiter.application_name = '$a2Name'
  and waiter.state = 'active'
  and waiter.wait_event_type = 'Lock'
  and exists (
    select 1 from unnest(pg_blocking_pids(waiter.pid)) as blocking(pid)
    join pg_stat_activity as holder on holder.pid = blocking.pid
    where holder.application_name = '$a1Name'
  );
"@
  $a1Result = Receive-Task019Worker -Handle $a1
  $a2Result = Receive-Task019Worker -Handle $a2
  Assert-Task019WorkerPass -Result $a1Result -Label "SCENARIO A worker 1"
  Assert-Task019WorkerPass -Result $a2Result -Label "SCENARIO A worker 2"
  $aOutcomes = @($a1Result.StdOut, $a2Result.StdOut) | ForEach-Object { (($_ -split '\|')[0..1] -join '|') } | Sort-Object
  Assert-Task019 -Condition (($aOutcomes -join ',') -eq 'ALREADY_COMPLETED|ALREADY_COMPLETED,COMPLETED|COMPLETED') `
    -Label "T019-CON-A outcomes"
  $aState = Get-Task019DurableState -SubjectId $subjectA -IntentId $intentA -CompanyId $companyA
  Assert-Task019CompletedState -State $aState -AllowedOperations @($operationA) `
    -AllowedProfiles @("Same/Operation") -Label "SCENARIO A"

  Write-Output "SCENARIO B fixture = subject=$subjectB intent=$intentB company=$companyB operations=$operationBA,$operationBB"
  $b1Name = "t019_b_worker_1"
  $b2Name = "t019_b_worker_2"
  $b1 = Start-Task019Worker -Name $b1Name -Sql (New-Task019CompletionSql -SubjectId $subjectB `
    -FirstName "Different" -LastName "Alpha" -OperationId $operationBA -ApplicationName $b1Name)
  Wait-Task019SqlValue -Expected "1" -Label "SCENARIO B worker 1 reached transactional delay" -Sql @"
select count(*) from pg_stat_activity
where application_name = '$b1Name' and state = 'active'
  and wait_event_type = 'Timeout' and wait_event = 'PgSleep';
"@
  $b2 = Start-Task019Worker -Name $b2Name -Sql (New-Task019CompletionSql -SubjectId $subjectB `
    -FirstName "Different" -LastName "Beta" -OperationId $operationBB -ApplicationName $b2Name)
  Wait-Task019SqlValue -Expected "1" -Label "SCENARIO B real lock overlap" -Sql @"
select count(*)
from pg_stat_activity as waiter
where waiter.application_name = '$b2Name'
  and waiter.state = 'active'
  and waiter.wait_event_type = 'Lock'
  and exists (
    select 1 from unnest(pg_blocking_pids(waiter.pid)) as blocking(pid)
    join pg_stat_activity as holder on holder.pid = blocking.pid
    where holder.application_name = '$b1Name'
  );
"@
  $b1Result = Receive-Task019Worker -Handle $b1
  $b2Result = Receive-Task019Worker -Handle $b2
  Assert-Task019WorkerPass -Result $b1Result -Label "SCENARIO B worker 1"
  Assert-Task019WorkerPass -Result $b2Result -Label "SCENARIO B worker 2"
  $bOutcomes = @($b1Result.StdOut, $b2Result.StdOut) | ForEach-Object { (($_ -split '\|')[0..1] -join '|') } | Sort-Object
  Assert-Task019 -Condition (($bOutcomes -join ',') -eq 'COMPLETED|COMPLETED,DENIED|ONBOARDING_ALREADY_COMPLETED') `
    -Label "T019-CON-B outcomes"
  $bState = Get-Task019DurableState -SubjectId $subjectB -IntentId $intentB -CompanyId $companyB
  Assert-Task019CompletedState -State $bState -AllowedOperations @($operationBA, $operationBB) `
    -AllowedProfiles @("Different/Alpha", "Different/Beta") -Label "SCENARIO B"
  $bParts = $bState -split '\|'
  $bExpectedProfile = if ($bParts[7] -eq $operationBA) { "Different/Alpha" } else { "Different/Beta" }
  Assert-Task019 -Condition ($bParts[8] -eq $bExpectedProfile) -Label "SCENARIO B loser did not rewrite profile"

  Write-Output "SCENARIO C fixture = actor=$actorSubject target=$subjectC intent=$intentC company=$companyC establishment=$establishmentC completion=$operationC"
  $cCompletionName = "t019_c_completion"
  $cTask017Name = "t019_c_task017_reconcile"
  $cCompletion = Start-Task019Worker -Name $cCompletionName -Sql (New-Task019CompletionSql -SubjectId $subjectC `
    -FirstName "Cross" -LastName "Task" -OperationId $operationC -ApplicationName $cCompletionName)
  Wait-Task019SqlValue -Expected "1" -Label "SCENARIO C TASK-019 reached transactional delay" -Sql @"
select count(*) from pg_stat_activity
where application_name = '$cCompletionName' and state = 'active'
  and wait_event_type = 'Timeout' and wait_event = 'PgSleep';
"@
  $cTask017 = Start-Task019Worker -Name $cTask017Name -Sql (New-Task019Task017ReconcileSql -ApplicationName $cTask017Name)
  Wait-Task019SqlValue -Expected "1" -Label "SCENARIO C TASK-017/TASK-019 common-lock overlap" -Sql @"
select count(*)
from pg_stat_activity as waiter
where waiter.application_name = '$cTask017Name'
  and waiter.state = 'active'
  and waiter.wait_event_type = 'Lock'
  and exists (
    select 1 from unnest(pg_blocking_pids(waiter.pid)) as blocking(pid)
    join pg_stat_activity as holder on holder.pid = blocking.pid
    where holder.application_name = '$cCompletionName'
  );
"@
  $cCompletionResult = Receive-Task019Worker -Handle $cCompletion
  $cTask017Result = Receive-Task019Worker -Handle $cTask017
  Assert-Task019WorkerPass -Result $cCompletionResult -Label "SCENARIO C TASK-019 worker"
  Assert-Task019WorkerPass -Result $cTask017Result -Label "SCENARIO C TASK-017 worker"
  Assert-Task019 -Condition ($cCompletionResult.StdOut -like 'COMPLETED|COMPLETED|*') -Label "T019-CON-C completion outcome"
  Assert-Task019 -Condition ($cTask017Result.StdOut -eq "ALREADY_RECONCILED|ALREADY_RECONCILED|$intentC|$challengeC") `
    -Label "T019-CON-C TASK-017 reconciliation outcome"
  $cState = Get-Task019DurableState -SubjectId $subjectC -IntentId $intentC -CompanyId $companyC
  Assert-Task019CompletedState -State $cState -AllowedOperations @($operationC) `
    -AllowedProfiles @("Cross/Task") -Label "SCENARIO C"
  Write-Output "SCENARIO C PostgreSQL deadlock = NO"
  Write-Output "SCENARIO C hung process = NO"
  Write-Output "SCENARIO C terminal intent coherent = YES"
  Write-Output "SCENARIO C PlatformUser count = 1"
  Write-Output "SCENARIO C membership count = 1"
  Write-Output "SCENARIO C USER_CREATED count = 1"

  Write-Output "SCENARIO D fixtures = target_subject=$subjectDTarget unrelated_subject=$subjectDUnrelated denied_subject=$subjectDDenied target_company=$companyDTarget unrelated_company=$companyDUnrelated denied_company=$companyDDenied"
  $dTargetName = "t019_d_target_valid"
  $dUnrelatedName = "t019_d_unrelated_valid"
  $dDeniedName = "t019_d_cross_subject_denied"
  $dTarget = Start-Task019Worker -Name $dTargetName -Sql (New-Task019CompletionSql -SubjectId $subjectDTarget `
    -FirstName "Target" -LastName "Tenant" -OperationId $operationDTarget -ApplicationName $dTargetName)
  Wait-Task019SqlValue -Expected "1" -Label "SCENARIO D target tenant reached transactional delay" -Sql @"
select count(*) from pg_stat_activity
where application_name = '$dTargetName' and state = 'active'
  and wait_event_type = 'Timeout' and wait_event = 'PgSleep';
"@
  $dUnrelated = Start-Task019Worker -Name $dUnrelatedName -Sql (New-Task019CompletionSql -SubjectId $subjectDUnrelated `
    -FirstName "Unrelated" -LastName "Tenant" -OperationId $operationDUnrelated -ApplicationName $dUnrelatedName)
  Wait-Task019SqlValue -Expected "2" -Label "SCENARIO D unrelated tenant not globally blocked" -Sql @"
select count(*) from pg_stat_activity
where application_name in ('$dTargetName', '$dUnrelatedName')
  and state = 'active' and wait_event_type = 'Timeout' and wait_event = 'PgSleep';
"@
  Write-Output "SCENARIO D shared historical actor KEY SHARE compatibility = PASS"
  Write-Output "SCENARIO D unrelated tenant bounded overlap = PASS"
  $dDenied = Start-Task019Worker -Name $dDeniedName -Sql (New-Task019CompletionSql -SubjectId $subjectDDenied `
    -FirstName "Denied" -LastName "Subject" -OperationId $operationDDenied -ApplicationName $dDeniedName)
  $dDeniedResult = Receive-Task019Worker -Handle $dDenied
  Wait-Task019SqlValue -Expected "2" -Label "SCENARIO D denied call completed during valid cross-tenant overlap" -Sql @"
select count(*) from pg_stat_activity
where application_name in ('$dTargetName', '$dUnrelatedName')
  and state = 'active' and wait_event_type = 'Timeout' and wait_event = 'PgSleep';
"@
  $dTargetResult = Receive-Task019Worker -Handle $dTarget
  $dUnrelatedResult = Receive-Task019Worker -Handle $dUnrelated
  Assert-Task019WorkerPass -Result $dTargetResult -Label "SCENARIO D target worker"
  Assert-Task019WorkerPass -Result $dUnrelatedResult -Label "SCENARIO D unrelated-tenant worker"
  Assert-Task019WorkerPass -Result $dDeniedResult -Label "SCENARIO D denied worker"
  Assert-Task019 -Condition ($dTargetResult.StdOut -like 'COMPLETED|COMPLETED|*') -Label "T019-CON-D target outcome"
  Assert-Task019 -Condition ($dUnrelatedResult.StdOut -like 'COMPLETED|COMPLETED|*') -Label "T019-CON-D unrelated outcome"
  Assert-Task019 -Condition ($dDeniedResult.StdOut -eq 'DENIED|SECURITY_CORRELATION_FAILURE|NULL|NULL|NULL') `
    -Label "T019-CON-D denied outcome"
  $dTargetState = Get-Task019DurableState -SubjectId $subjectDTarget -IntentId $intentDTarget -CompanyId $companyDTarget
  Assert-Task019CompletedState -State $dTargetState -AllowedOperations @($operationDTarget) `
    -AllowedProfiles @("Target/Tenant") -Label "SCENARIO D target"
  $dUnrelatedState = Get-Task019DurableState -SubjectId $subjectDUnrelated -IntentId $intentDUnrelated -CompanyId $companyDUnrelated
  Assert-Task019CompletedState -State $dUnrelatedState -AllowedOperations @($operationDUnrelated) `
    -AllowedProfiles @("Unrelated/Tenant") -Label "SCENARIO D unrelated tenant"
  $dDeniedState = Get-Task019DurableState -SubjectId $subjectDDenied -IntentId $intentDDenied -CompanyId $companyDDenied
  Write-Output "SCENARIO D denied durable state = $dDeniedState"
  Assert-Task019 -Condition ($dDeniedState -eq '0|0|0|0|0|0|0|NONE|NONE') -Label "SCENARIO D denied isolation"

  Write-Output "same-operation concurrency = PASS"
  Write-Output "different-operation concurrency = PASS"
  Write-Output "TASK-017/TASK-019 cross-task concurrency = PASS"
  Write-Output "denied isolation concurrency = PASS"
  Write-Output "PostgreSQL deadlock = NO"
  Write-Output "timeout/hang = NO"
  Write-Output "unexpected SQL error = NO"
  Write-Output "SQLSTATE parser ERROR token capture = NOT POSSIBLE"
  Write-Output "boundedness probe = PASS"
  Write-Output "global TASK-019 advisory lock = NOT INTRODUCED"
  Write-Output "TASK-019 CONCURRENCY HARNESS = PASS"
}
finally {
  $script:Task019Jobs | Where-Object { $_.State -in @("Running", "NotStarted") } |
    Stop-Job -ErrorAction SilentlyContinue
  $script:Task019Jobs | Remove-Job -Force -ErrorAction SilentlyContinue
  Invoke-Task019Psql -Sql $cleanupSql -Phase "TASK-019 concurrency fixture cleanup" | Out-Null
  if ($null -eq $previousConnectTimeout) {
    Remove-Item -LiteralPath Env:PGCONNECT_TIMEOUT -ErrorAction SilentlyContinue
  }
  else {
    $env:PGCONNECT_TIMEOUT = $previousConnectTimeout
  }
}
