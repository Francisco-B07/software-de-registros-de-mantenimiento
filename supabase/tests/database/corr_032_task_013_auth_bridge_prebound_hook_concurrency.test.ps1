[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$psqlCommand = Get-Command psql -ErrorAction SilentlyContinue
if ($null -eq $psqlCommand) {
  throw "psql is required for the CORR-032 concurrency harness."
}
$script:corr032PsqlPath = $psqlCommand.Source

$corr032Jobs = [System.Collections.Generic.List[object]]::new()
$previousConnectTimeout = $env:PGCONNECT_TIMEOUT
$env:PGCONNECT_TIMEOUT = "5"
$jobTimeoutSeconds = 35
$readinessTimeoutSeconds = 10

$userA = "32900000-0000-4000-8000-000000000001"
$userB = "32900000-0000-4000-8000-000000000002"
$userC = "32900000-0000-4000-8000-000000000003"
$userD = "32900000-0000-4000-8000-000000000004"
$userE = "32900000-0000-4000-8000-000000000005"
$preboundChallenge = "32900000-0000-4000-8100-000000000001"
$unboundChallenge = "32900000-0000-4000-8100-000000000002"
$preconditionChallenge = "32900000-0000-4000-8100-000000000003"
$preboundBridge = "32900000-0000-4000-8200-000000000001"
$unboundBridge = "32900000-0000-4000-8200-000000000002"
$preconditionBridge = "32900000-0000-4000-8200-000000000003"
$preboundGrant = "32900000-0000-4000-8300-000000000001"
$unboundGrant = "32900000-0000-4000-8300-000000000002"
$preconditionGrant = "32900000-0000-4000-8300-000000000003"
$preboundBoundAt = "2026-09-23 12:00:00+00"
$preconditionGateKey = 320032
$preconditionGateName = "corr032_precondition_gate"
$preconditionBlockerName = "corr032_precondition_blocker"
$preconditionHookName = "corr032_precondition_hook"

function Add-Corr032Timeouts {
  param([Parameter(Mandatory = $true)][string]$Sql)

  return "set statement_timeout = '30s'; set lock_timeout = '20s'; $Sql"
}

function ConvertTo-Corr032SafeDiagnosticText {
  param([AllowEmptyString()][string]$Text)

  if ([string]::IsNullOrEmpty($Text)) {
    return "<empty>"
  }

  $safeText = $Text
  $safeText = [regex]::Replace(
    $safeText,
    '(?i)(postgres(?:ql)?://[^:\s/@]+:)[^@\s]+@',
    '$1<redacted>@'
  )
  $safeText = [regex]::Replace(
    $safeText,
    '(?im)(PGPASSWORD\s*=\s*)\S+',
    '$1<redacted>'
  )
  $safeText = [regex]::Replace(
    $safeText,
    '(?im)((?:password|access_token|refresh_token|service_role|secret_key)\s*[=:]\s*)\S+',
    '$1<redacted>'
  )
  return $safeText.Trim()
}

function New-Corr032PsqlFailureMessage {
  param(
    [Parameter(Mandatory = $true)][string]$Context,
    [Parameter(Mandatory = $true)][int]$ExitCode,
    [AllowEmptyString()][string]$Stdout,
    [AllowEmptyString()][string]$Stderr
  )

  $safeStdout = ConvertTo-Corr032SafeDiagnosticText -Text $Stdout
  $safeStderr = ConvertTo-Corr032SafeDiagnosticText -Text $Stderr
  $sqlState = "NOT EXPOSED"
  $severity = "NOT EXPOSED"
  $message = "NOT EXPOSED"
  $detail = "NOT EXPOSED"
  $hint = "NOT EXPOSED"

  $errorMatch = [regex]::Match(
    $safeStderr,
    '(?m)^(?<severity>ERROR|FATAL|PANIC):\s+(?<state>[0-9A-Z]{5}):\s*(?<message>[^\r\n]*)\r?$'
  )
  if ($errorMatch.Success) {
    $sqlState = $errorMatch.Groups['state'].Value
    $severity = $errorMatch.Groups['severity'].Value
    $message = $errorMatch.Groups['message'].Value
  }

  $detailMatch = [regex]::Match($safeStderr, '(?m)^DETAIL:\s*(?<value>[^\r\n]*)\r?$')
  if ($detailMatch.Success) {
    $detail = $detailMatch.Groups['value'].Value
  }
  $hintMatch = [regex]::Match($safeStderr, '(?m)^HINT:\s*(?<value>[^\r\n]*)\r?$')
  if ($hintMatch.Success) {
    $hint = $hintMatch.Groups['value'].Value
  }

  return @(
    "$Context failed.",
    "numeric exit code = $ExitCode",
    "safe stdout =",
    $safeStdout,
    "safe stderr =",
    $safeStderr,
    "SQLSTATE = $sqlState",
    "severity = $severity",
    "message = $message",
    "detail = $detail",
    "hint = $hint"
  ) -join [Environment]::NewLine
}

function Invoke-Corr032Psql {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
  $startInfo.FileName = $script:corr032PsqlPath
  $startInfo.UseShellExecute = $false
  $startInfo.RedirectStandardOutput = $true
  $startInfo.RedirectStandardError = $true
  $startInfo.CreateNoWindow = $true
  foreach ($argument in @(
      "--no-psqlrc",
      "--quiet",
      "--set=ON_ERROR_STOP=1",
      "--set=VERBOSITY=verbose",
      "--tuples-only",
      "--no-align",
      "--command",
      (Add-Corr032Timeouts -Sql $Sql)
    )) {
    $startInfo.ArgumentList.Add($argument)
  }

  $process = [System.Diagnostics.Process]::new()
  $process.StartInfo = $startInfo
  try {
    $process.Start() | Out-Null
    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()
    $process.WaitForExit()
    $stdout = $stdoutTask.GetAwaiter().GetResult()
    $stderr = $stderrTask.GetAwaiter().GetResult()
    $exitCode = $process.ExitCode
  } finally {
    $process.Dispose()
  }

  if ($exitCode -ne 0) {
    throw (New-Corr032PsqlFailureMessage -Context "Bounded CORR-032 psql command" `
      -ExitCode $exitCode -Stdout $stdout -Stderr $stderr)
  }
  return $stdout.Trim()
}

function Start-Corr032HookJob {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $boundedSql = Add-Corr032Timeouts -Sql $Sql
  $job = Start-Job -ScriptBlock {
    param($Statement)
    $result = & psql --no-psqlrc --quiet --set=ON_ERROR_STOP=1 --tuples-only --no-align `
      --command $Statement 2>&1
    if ($LASTEXITCODE -ne 0) {
      return "UNEXPECTED_ERROR"
    }
    $outcome = ($result -join [Environment]::NewLine).Trim()
    if ($outcome -notin @("ALLOW", "DENY")) {
      return "UNEXPECTED_ERROR"
    }
    return $outcome
  } -ArgumentList $boundedSql
  $script:corr032Jobs.Add($job) | Out-Null
  return $job
}

function Start-Corr032ControlJob {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $boundedSql = Add-Corr032Timeouts -Sql $Sql
  $job = Start-Job -ScriptBlock {
    param($Statement, $PsqlPath)

    $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $PsqlPath
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.CreateNoWindow = $true
    foreach ($argument in @(
        "--no-psqlrc",
        "--quiet",
        "--set=ON_ERROR_STOP=1",
        "--set=VERBOSITY=verbose",
        "--tuples-only",
        "--no-align",
        "--command",
        $Statement
      )) {
      $startInfo.ArgumentList.Add($argument)
    }

    $process = [System.Diagnostics.Process]::new()
    $process.StartInfo = $startInfo
    try {
      $process.Start() | Out-Null
      $stdoutTask = $process.StandardOutput.ReadToEndAsync()
      $stderrTask = $process.StandardError.ReadToEndAsync()
      $process.WaitForExit()
      $stdout = $stdoutTask.GetAwaiter().GetResult()
      $stderr = $stderrTask.GetAwaiter().GetResult()
      $exitCode = $process.ExitCode
    } finally {
      $process.Dispose()
    }

    if ($exitCode -ne 0) {
      $safeStdout = if ([string]::IsNullOrEmpty($stdout)) { "<empty>" } else { $stdout.Trim() }
      $safeStderr = if ([string]::IsNullOrEmpty($stderr)) { "<empty>" } else { $stderr.Trim() }
      $safeStdout = [regex]::Replace(
        $safeStdout,
        '(?i)(postgres(?:ql)?://[^:\s/@]+:)[^@\s]+@',
        '$1<redacted>@'
      )
      $safeStderr = [regex]::Replace(
        $safeStderr,
        '(?i)(postgres(?:ql)?://[^:\s/@]+:)[^@\s]+@',
        '$1<redacted>@'
      )
      $safeStdout = [regex]::Replace(
        $safeStdout,
        '(?im)(PGPASSWORD\s*=\s*)\S+',
        '$1<redacted>'
      )
      $safeStderr = [regex]::Replace(
        $safeStderr,
        '(?im)(PGPASSWORD\s*=\s*)\S+',
        '$1<redacted>'
      )
      throw (@(
          "Bounded CORR-032 control worker psql nonzero.",
          "numeric exit code = $exitCode",
          "safe stdout =",
          $safeStdout,
          "safe stderr =",
          $safeStderr
        ) -join [Environment]::NewLine)
    }
    return $stdout.Trim()
  } -ArgumentList $boundedSql, $script:corr032PsqlPath
  $script:corr032Jobs.Add($job) | Out-Null
  return $job
}

function Receive-Corr032Job {
  param([Parameter(Mandatory = $true)]$Job)

  $completed = Wait-Job -Job $Job -Timeout $script:jobTimeoutSeconds
  if ($null -eq $completed) {
    Stop-Job -Job $Job -ErrorAction SilentlyContinue
    throw "CORR-032 concurrent worker timed out."
  }
  $workerErrors = @()
  $result = Receive-Job -Job $Job -ErrorAction SilentlyContinue -ErrorVariable +workerErrors
  $state = $Job.State
  Remove-Job -Job $Job -Force -ErrorAction SilentlyContinue
  if ($state -ne "Completed") {
    $workerDiagnostic = if ($workerErrors.Count -eq 0) {
      "NOT EXPOSED"
    } else {
      ConvertTo-Corr032SafeDiagnosticText -Text (($workerErrors | Out-String).Trim())
    }
    throw (@(
        "CORR-032 concurrent worker failed with state $state.",
        "worker diagnostic =",
        $workerDiagnostic
      ) -join [Environment]::NewLine)
  }
  return ($result -join [Environment]::NewLine).Trim()
}

function Remove-Corr032CancelledGateJob {
  param([Parameter(Mandatory = $true)]$Job)

  $completed = Wait-Job -Job $Job -Timeout $script:jobTimeoutSeconds
  if ($null -eq $completed) {
    Stop-Job -Job $Job -ErrorAction SilentlyContinue
    Remove-Job -Job $Job -Force -ErrorAction SilentlyContinue
    throw "CORR-032 controlled gate did not terminate."
  }

  Receive-Job -Job $Job -ErrorAction SilentlyContinue | Out-Null
  $state = $Job.State
  Remove-Job -Job $Job -Force -ErrorAction SilentlyContinue
  if ($state -ne "Failed") {
    throw "CORR-032 controlled gate expected cancellation but received state $state."
  }
}

function Wait-Corr032SqlValue {
  param(
    [Parameter(Mandatory = $true)][string]$Sql,
    [Parameter(Mandatory = $true)][string]$Expected,
    [Parameter(Mandatory = $true)][string]$Label
  )

  $deadline = [DateTime]::UtcNow.AddSeconds($script:readinessTimeoutSeconds)
  $actual = ""
  do {
    $actual = Invoke-Corr032Psql -Sql $Sql
    if ($actual -eq $Expected) {
      return
    }
    Start-Sleep -Milliseconds 100
  } while ([DateTime]::UtcNow -lt $deadline)

  throw "$Label timed out; expected '$Expected', received '$actual'."
}

function Assert-Corr032 {
  param(
    [Parameter(Mandatory = $true)][bool]$Condition,
    [Parameter(Mandatory = $true)][string]$Label
  )

  if (-not $Condition) {
    throw "$Label failed."
  }
  Write-Output "$Label = PASS"
}

function New-Corr032HookSql {
  param(
    [Parameter(Mandatory = $true)][string]$UserId,
    [Parameter(Mandatory = $true)][string]$Email,
    [Parameter(Mandatory = $true)][string]$ApplicationName
  )

  return @"
set application_name = '$ApplicationName';
begin;
set local role supabase_auth_admin;
do `$hook`$
begin
  perform public.task_013_custom_access_token_hook(
    jsonb_build_object(
      'user_id', '$UserId',
      'authentication_method', 'password',
      'claims', jsonb_build_object('email', '$Email')
    )
  );
  perform set_config('corr032.worker_outcome', 'ALLOW', true);
exception
  when sqlstate 'P0001' then
    perform set_config('corr032.worker_outcome', 'DENY', true);
end;
`$hook`$;
select current_setting('corr032.worker_outcome');
commit;
"@
}

$cleanupSql = @"
delete from public.auth_session_grants where id::text like '32900000-%';
delete from public.auth_bridge_credentials where id::text like '32900000-%';
delete from public.verification_challenges where id::text like '32900000-%';
delete from auth.users where id::text like '32900000-%';
"@

$setupSql = @"
$cleanupSql
insert into auth.users (id, email)
values
  ('$userA', 'corr032-con-user-a@example.test'),
  ('$userB', 'corr032-con-user-b@example.test'),
  ('$userC', 'corr032-con-user-c@example.test'),
  ('$userD', 'corr032-con-user-d@example.test'),
  ('$userE', 'corr032-con-user-e@example.test');

insert into public.verification_challenges (
  id, email, verifier, verifier_key_version, issued_at, expires_at, consumed_at, issue_operation_id
)
values
  ('$preboundChallenge', 'corr032-con-prebound@example.test', decode(repeat('91', 32), 'hex'), 'v1',
   statement_timestamp() - interval '1 minute', statement_timestamp() + interval '7 hours 59 minutes',
   clock_timestamp() - interval '30 seconds', '32900000-0000-4000-8400-000000000001'),
  ('$unboundChallenge', 'corr032-con-unbound@example.test', decode(repeat('92', 32), 'hex'), 'v1',
   statement_timestamp() - interval '1 minute', statement_timestamp() + interval '7 hours 59 minutes',
   clock_timestamp() - interval '30 seconds', '32900000-0000-4000-8400-000000000002'),
  ('$preconditionChallenge', 'corr032-con-precondition@example.test', decode(repeat('93', 32), 'hex'), 'v1',
   statement_timestamp() - interval '1 minute', statement_timestamp() + interval '7 hours 59 minutes',
   clock_timestamp() - interval '30 seconds', '32900000-0000-4000-8400-000000000003');

insert into public.auth_bridge_credentials (
  id, email, auth_user_id, technical_password_key_version, bound_at
)
values
  ('$preboundBridge', 'corr032-con-prebound@example.test', '$userA', 'v1', '$preboundBoundAt'),
  ('$unboundBridge', 'corr032-con-unbound@example.test', null, 'v1', null),
  ('$preconditionBridge', 'corr032-con-precondition@example.test', null, 'v1', null);

insert into public.auth_session_grants (
  id, challenge_id, auth_bridge_credential_id, auth_user_id,
  created_at, expires_at, grant_operation_id
)
values
  ('$preboundGrant', '$preboundChallenge', '$preboundBridge', '$userA',
   statement_timestamp() - interval '1 minute', statement_timestamp() + interval '4 minutes',
   '32900000-0000-4000-8500-000000000001'),
  ('$unboundGrant', '$unboundChallenge', '$unboundBridge', null,
   statement_timestamp() - interval '1 minute', statement_timestamp() + interval '4 minutes',
   '32900000-0000-4000-8500-000000000002'),
  ('$preconditionGrant', '$preconditionChallenge', '$preconditionBridge', null,
   statement_timestamp() - interval '1 minute', statement_timestamp() + interval '4 minutes',
   '32900000-0000-4000-8500-000000000003');
"@

$primaryFailure = $null
$cleanupFailures = [System.Collections.Generic.List[string]]::new()
$cleanupTrackedJobs = -1
$cleanupFixtureResidue = -1
$cleanupSessionResidue = -1
$connectTimeoutRestored = $false

try {
  Invoke-Corr032Psql -Sql $setupSql | Out-Null

  $preboundSql = New-Corr032HookSql -UserId $userA -Email "corr032-con-prebound@example.test" `
    -ApplicationName "corr032_prebound_hook"
  $preboundA = Start-Corr032HookJob -Sql $preboundSql
  $preboundB = Start-Corr032HookJob -Sql $preboundSql
  $preboundResults = @(
    (Receive-Corr032Job -Job $preboundA),
    (Receive-Corr032Job -Job $preboundB)
  )
  $preboundState = Invoke-Corr032Psql -Sql @"
select
  (select count(*) from public.auth_bridge_credentials
   where id = '$preboundBridge' and auth_user_id = '$userA' and bound_at = '$preboundBoundAt')
  || '|' ||
  (select count(*) from public.auth_session_grants
   where id = '$preboundGrant' and auth_user_id = '$userA'
     and consumed_at is not null and revoked_at is null);
"@
  $preboundAllow = @($preboundResults | Where-Object { $_ -eq "ALLOW" }).Count
  $preboundDeny = @($preboundResults | Where-Object { $_ -eq "DENY" }).Count
  $preboundUnexpected = @($preboundResults | Where-Object { $_ -eq "UNEXPECTED_ERROR" }).Count
  Write-Output "C032-CON-PREBOUND-OUTCOMES = ALLOW=$preboundAllow DENY=$preboundDeny UNEXPECTED_ERROR=$preboundUnexpected"

  Assert-Corr032 -Condition ($preboundAllow -eq 1 -and $preboundDeny -eq 1 -and $preboundUnexpected -eq 0) -Label "C032-CON-001"
  Assert-Corr032 -Condition ($preboundState -eq "1|1") -Label "C032-CON-002"
  Assert-Corr032 -Condition ((Invoke-Corr032Psql -Sql "select count(*) from public.auth_session_grants where id = '$preboundGrant' and consumed_at is not null;") -eq "1") -Label "C032-CON-003"

  $unboundA = Start-Corr032HookJob -Sql (New-Corr032HookSql -UserId $userB `
    -Email "corr032-con-unbound@example.test" -ApplicationName "corr032_unbound_hook_a")
  $unboundB = Start-Corr032HookJob -Sql (New-Corr032HookSql -UserId $userC `
    -Email "corr032-con-unbound@example.test" -ApplicationName "corr032_unbound_hook_b")
  $unboundResults = @(
    (Receive-Corr032Job -Job $unboundA),
    (Receive-Corr032Job -Job $unboundB)
  )
  $unboundState = Invoke-Corr032Psql -Sql @"
select
  (select count(*) from public.auth_bridge_credentials
   where id = '$unboundBridge' and auth_user_id in ('$userB', '$userC') and bound_at is not null)
  || '|' ||
  (select count(*)
   from public.auth_session_grants as session_grant
   join public.auth_bridge_credentials as bridge
     on bridge.id = session_grant.auth_bridge_credential_id
   where session_grant.id = '$unboundGrant'
     and session_grant.auth_user_id = bridge.auth_user_id
     and session_grant.consumed_at is not null
     and session_grant.revoked_at is null);
"@
  $unboundAllow = @($unboundResults | Where-Object { $_ -eq "ALLOW" }).Count
  $unboundDeny = @($unboundResults | Where-Object { $_ -eq "DENY" }).Count
  $unboundUnexpected = @($unboundResults | Where-Object { $_ -eq "UNEXPECTED_ERROR" }).Count
  Write-Output "C032-CON-UNBOUND-OUTCOMES = ALLOW=$unboundAllow DENY=$unboundDeny UNEXPECTED_ERROR=$unboundUnexpected"

  Assert-Corr032 -Condition ($unboundAllow -eq 1 -and $unboundDeny -eq 1 -and $unboundUnexpected -eq 0) -Label "C032-CON-004"
  Assert-Corr032 -Condition ($unboundState -eq "1|1") -Label "C032-CON-005"
  Assert-Corr032 -Condition ((Invoke-Corr032Psql -Sql "select count(*) from public.auth_session_grants where id = '$unboundGrant' and consumed_at is not null;") -eq "1") -Label "C032-CON-006"

  $gateSql = @"
set application_name = '$preconditionGateName';
select pg_advisory_lock($preconditionGateKey);
select pg_sleep(25);
select pg_advisory_unlock($preconditionGateKey);
"@
  $blockerSql = @"
set application_name = '$preconditionBlockerName';
begin;
set local role postgres;
select id from public.auth_bridge_credentials where id = '$preconditionBridge' for update;
select pg_advisory_xact_lock($preconditionGateKey);
update public.auth_bridge_credentials
set auth_user_id = '$userD', bound_at = clock_timestamp()
where id = '$preconditionBridge' and auth_user_id is null;
commit;
"@

  $gateJob = Start-Corr032ControlJob -Sql $gateSql
  Wait-Corr032SqlValue -Sql @"
select count(*)
from pg_stat_activity
where application_name = '$preconditionGateName'
  and state = 'active'
  and wait_event_type = 'Timeout'
  and wait_event = 'PgSleep';
"@ -Expected "1" -Label "C032 precondition gate readiness"

  $blockerJob = Start-Corr032ControlJob -Sql $blockerSql
  Wait-Corr032SqlValue -Sql @"
select count(*)
from pg_stat_activity as blocker
where blocker.application_name = '$preconditionBlockerName'
  and blocker.state = 'active'
  and blocker.wait_event_type = 'Lock'
  and exists (
    select 1
    from unnest(pg_blocking_pids(blocker.pid)) as blocking(pid)
    join pg_stat_activity as gate on gate.pid = blocking.pid
    where gate.application_name = '$preconditionGateName'
  );
"@ -Expected "1" -Label "C032 bridge blocker readiness"

  $preconditionHook = Start-Corr032HookJob -Sql (New-Corr032HookSql -UserId $userE `
    -Email "corr032-con-precondition@example.test" -ApplicationName $preconditionHookName)
  Wait-Corr032SqlValue -Sql @"
select count(*)
from pg_stat_activity as hook
where hook.application_name = '$preconditionHookName'
  and hook.state = 'active'
  and hook.wait_event_type = 'Lock'
  and exists (
    select 1
    from unnest(pg_blocking_pids(hook.pid)) as blocking(pid)
    join pg_stat_activity as blocker on blocker.pid = blocking.pid
    where blocker.application_name = '$preconditionBlockerName'
  );
"@ -Expected "1" -Label "C032 Hook bridge-lock wait"

  $grantLockProof = Invoke-Corr032Psql -Sql @"
begin;
set local role postgres;
do `$probe`$
begin
  begin
    perform id from public.auth_session_grants where id = '$preconditionGrant' for update nowait;
    perform set_config('corr032.grant_lock_proof', 'UNLOCKED', true);
  exception
    when lock_not_available then
      perform set_config('corr032.grant_lock_proof', 'LOCKED', true);
  end;
end;
`$probe`$;
select current_setting('corr032.grant_lock_proof');
rollback;
"@
  Assert-Corr032 -Condition ($grantLockProof -eq "LOCKED") -Label "C032-CON-007"

  $gateCancellationEvidence = Invoke-Corr032Psql -Sql @"
begin;
do `$identity`$
begin
  if session_user <> 'supabase_admin' or current_user <> 'postgres' then
    raise exception using
      errcode = '42501',
      message = 'CORR-032 cancellation baseline identity mismatch';
  end if;
  perform set_config('corr032.cancel_baseline_session_user', session_user, true);
  perform set_config('corr032.cancel_baseline_current_user', current_user, true);
end;
`$identity`$;
set local role supabase_admin;
do `$identity`$
begin
  if session_user <> 'supabase_admin' or current_user <> 'supabase_admin' then
    raise exception using
      errcode = '42501',
      message = 'CORR-032 bounded cancellation identity mismatch';
  end if;
end;
`$identity`$;
select current_setting('corr032.cancel_baseline_session_user')
  || '|' || current_setting('corr032.cancel_baseline_current_user')
  || '|' || session_user
  || '|' || current_user
  || '|' || pg_cancel_backend(pid)::text
from pg_stat_activity
where application_name = '$preconditionGateName';
commit;
"@
  $gateCancellationFields = @($gateCancellationEvidence -split '\|')
  if ($gateCancellationFields.Count -ne 5) {
    throw "CORR-032 cancellation evidence was ambiguous."
  }
  Write-Output "CORR-032 CANCELLATION BASELINE = session_user=$($gateCancellationFields[0]) current_user=$($gateCancellationFields[1])"
  Write-Output "CORR-032 CANCELLATION BOUNDED AUTHORITY = session_user=$($gateCancellationFields[2]) current_user=$($gateCancellationFields[3])"
  Write-Output "CORR-032 PG_CANCEL_BACKEND CALLS = 1"
  $gateCancelled = $gateCancellationFields[4]
  Assert-Corr032 -Condition ($gateCancelled -eq "true") -Label "C032-CON-008"
  Remove-Corr032CancelledGateJob -Job $gateJob
  Receive-Corr032Job -Job $blockerJob | Out-Null
  $preconditionOutcome = Receive-Corr032Job -Job $preconditionHook

  $preconditionState = Invoke-Corr032Psql -Sql @"
select
  (select count(*) from public.auth_bridge_credentials
   where id = '$preconditionBridge' and auth_user_id = '$userD' and bound_at is not null)
  || '|' ||
  (select count(*) from public.auth_session_grants
   where id = '$preconditionGrant' and auth_user_id is null
     and consumed_at is null and revoked_at is null);
"@
  Write-Output "C032-CON-PRECONDITION-OUTCOME = $preconditionOutcome"
  Write-Output "C032-CON-PRECONDITION-STATE = external_binding_preserved|grant_unconsumed"

  Assert-Corr032 -Condition ($preconditionOutcome -eq "DENY") -Label "C032-CON-009"
  Assert-Corr032 -Condition ($preconditionState -eq "1|1") -Label "C032-CON-010"

}
catch {
  $primaryFailure = $_
}
finally {
  foreach ($trackedJob in @($corr032Jobs)) {
    $existingJob = Get-Job -Id $trackedJob.Id -ErrorAction SilentlyContinue
    if ($null -eq $existingJob) {
      continue
    }
    if ($existingJob.State -in @("Running", "NotStarted")) {
      try {
        Stop-Job -Job $existingJob -ErrorAction Stop
      } catch {
        $cleanupFailures.Add(
          "job stop failure: $(ConvertTo-Corr032SafeDiagnosticText -Text $_.Exception.Message)"
        )
      }
    }
    try {
      Remove-Job -Job $existingJob -Force -ErrorAction Stop
    } catch {
      $cleanupFailures.Add(
        "job removal failure: $(ConvertTo-Corr032SafeDiagnosticText -Text $_.Exception.Message)"
      )
    }
  }

  $cleanupTrackedJobs = @(
    $corr032Jobs | Where-Object {
      $job = Get-Job -Id $_.Id -ErrorAction SilentlyContinue
      $null -ne $job -and $job.State -in @("Running", "NotStarted")
    }
  ).Count
  if ($cleanupTrackedJobs -ne 0) {
    $cleanupFailures.Add("tracked jobs still active: $cleanupTrackedJobs")
  }

  try {
    Invoke-Corr032Psql -Sql $cleanupSql | Out-Null
  } catch {
    $cleanupFailures.Add(
      "fixture cleanup failure: $(ConvertTo-Corr032SafeDiagnosticText -Text $_.Exception.Message)"
    )
  }

  try {
    $cleanupFixtureResidue = [int](Invoke-Corr032Psql -Sql @"
select
  (select count(*) from public.auth_session_grants where id::text like '32900000-%')
  + (select count(*) from public.auth_bridge_credentials where id::text like '32900000-%')
  + (select count(*) from public.verification_challenges where id::text like '32900000-%')
  + (select count(*) from auth.users where id::text like '32900000-%');
"@)
    if ($cleanupFixtureResidue -ne 0) {
      $cleanupFailures.Add("fixture residue remained: $cleanupFixtureResidue")
    }
  } catch {
    $cleanupFailures.Add(
      "fixture residue verification failure: $(ConvertTo-Corr032SafeDiagnosticText -Text $_.Exception.Message)"
    )
  }

  try {
    $cleanupSessionResidue = [int](Invoke-Corr032Psql -Sql @"
select count(*)
from pg_stat_activity
where application_name in (
  '$preconditionGateName',
  '$preconditionBlockerName',
  '$preconditionHookName'
);
"@)
    if ($cleanupSessionResidue -ne 0) {
      $cleanupFailures.Add("precondition session residue remained: $cleanupSessionResidue")
    }
  } catch {
    $cleanupFailures.Add(
      "session residue verification failure: $(ConvertTo-Corr032SafeDiagnosticText -Text $_.Exception.Message)"
    )
  }

  try {
    if ($null -eq $previousConnectTimeout) {
      Remove-Item -LiteralPath Env:PGCONNECT_TIMEOUT -ErrorAction Stop
      $connectTimeoutRestored = $null -eq $env:PGCONNECT_TIMEOUT
    } else {
      $env:PGCONNECT_TIMEOUT = $previousConnectTimeout
      $connectTimeoutRestored = $env:PGCONNECT_TIMEOUT -eq $previousConnectTimeout
    }
  } catch {
    $cleanupFailures.Add(
      "PGCONNECT_TIMEOUT restoration failure: $(ConvertTo-Corr032SafeDiagnosticText -Text $_.Exception.Message)"
    )
  }
  if (-not $connectTimeoutRestored) {
    $cleanupFailures.Add("PGCONNECT_TIMEOUT restoration verification failed")
  }
}

if ($null -ne $primaryFailure -or $cleanupFailures.Count -ne 0) {
  $failureParts = [System.Collections.Generic.List[string]]::new()
  if ($null -ne $primaryFailure) {
    $failureParts.Add(
      "primary failure:`n$(ConvertTo-Corr032SafeDiagnosticText -Text $primaryFailure.Exception.Message)"
    )
  }
  if ($cleanupFailures.Count -ne 0) {
    $failureParts.Add("cleanup failures:`n$($cleanupFailures -join [Environment]::NewLine)")
  }
  throw ($failureParts -join [Environment]::NewLine)
}

Write-Output "CORR-032 CLEANUP TRACKED JOBS = $cleanupTrackedJobs"
Write-Output "CORR-032 CLEANUP FIXTURE RESIDUE = $cleanupFixtureResidue"
Write-Output "CORR-032 CLEANUP SESSION RESIDUE = $cleanupSessionResidue"
Write-Output "CORR-032 PGCONNECT_TIMEOUT RESTORED = YES"
Write-Output "CORR-032 CLEANUP = PASS"
Write-Output "CORR-032 CONCURRENCY HARNESS = PASS"
