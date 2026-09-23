[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

if ($null -eq (Get-Command psql -ErrorAction SilentlyContinue)) {
  throw "psql is required for the CORR-032 concurrency harness."
}

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

function Invoke-Corr032Psql {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $output = & psql --no-psqlrc --quiet --set=ON_ERROR_STOP=1 --tuples-only --no-align `
    --command (Add-Corr032Timeouts -Sql $Sql) 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Bounded CORR-032 psql command failed."
  }
  return ($output -join [Environment]::NewLine).Trim()
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
    param($Statement)
    $result = & psql --no-psqlrc --quiet --set=ON_ERROR_STOP=1 --tuples-only --no-align `
      --command $Statement 2>&1
    if ($LASTEXITCODE -ne 0) {
      throw "Bounded CORR-032 control worker failed."
    }
    return ($result -join [Environment]::NewLine).Trim()
  } -ArgumentList $boundedSql
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
  $result = Receive-Job -Job $Job -ErrorAction SilentlyContinue
  $state = $Job.State
  Remove-Job -Job $Job -Force -ErrorAction SilentlyContinue
  if ($state -ne "Completed") {
    throw "CORR-032 concurrent worker failed with state $state."
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

  $gateCancelled = Invoke-Corr032Psql -Sql @"
select pg_cancel_backend(pid)::text
from pg_stat_activity
where application_name = '$preconditionGateName';
"@
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

  Write-Output "CORR-032 CONCURRENCY HARNESS = PASS"
}
finally {
  $corr032Jobs | Where-Object { $_.State -in @("Running", "NotStarted") } |
    Stop-Job -ErrorAction SilentlyContinue
  $corr032Jobs | Remove-Job -Force -ErrorAction SilentlyContinue
  Invoke-Corr032Psql -Sql $cleanupSql | Out-Null
  if ($null -eq $previousConnectTimeout) {
    Remove-Item -LiteralPath Env:PGCONNECT_TIMEOUT -ErrorAction SilentlyContinue
  } else {
    $env:PGCONNECT_TIMEOUT = $previousConnectTimeout
  }
}
