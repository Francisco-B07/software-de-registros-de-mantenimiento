[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

if ($null -eq (Get-Command psql -ErrorAction SilentlyContinue)) {
  throw "psql is required for the TASK-015 concurrency harness."
}

$fixturePrefix = "15990000-0000-4000-8000-"
$companyOne = "${fixturePrefix}000000000001"
$companyTwo = "${fixturePrefix}000000000002"
$companyThree = "${fixturePrefix}000000000003"
$task015Jobs = [System.Collections.Generic.List[object]]::new()
$jobTimeoutSeconds = 35
$readinessTimeoutSeconds = 10
$previousConnectTimeout = $env:PGCONNECT_TIMEOUT
$env:PGCONNECT_TIMEOUT = "5"

function Add-Task015Timeouts {
  param([Parameter(Mandatory = $true)][string]$Sql)

  return @"
set statement_timeout = '30s';
set lock_timeout = '20s';
$Sql
"@
}

function Invoke-Task015Psql {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $boundedSql = Add-Task015Timeouts -Sql $Sql
  $output = & psql --no-psqlrc --quiet --set=ON_ERROR_STOP=1 --tuples-only --no-align --command $boundedSql 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Bounded psql command failed."
  }

  return ($output -join [Environment]::NewLine).Trim()
}

function Start-Task015PsqlJob {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $boundedSql = Add-Task015Timeouts -Sql $Sql
  $job = Start-Job -ScriptBlock {
    param($Statement)
    $result = & psql --no-psqlrc --quiet --set=ON_ERROR_STOP=1 --tuples-only --no-align --command $Statement 2>&1
    if ($LASTEXITCODE -ne 0) {
      throw "Bounded concurrent psql worker failed."
    }
    ($result -join [Environment]::NewLine).Trim()
  } -ArgumentList $boundedSql
  $script:task015Jobs.Add($job) | Out-Null
  return $job
}

function Receive-Task015Job {
  param(
    [Parameter(Mandatory = $true)]$Job,
    [string]$Label = "concurrent psql worker"
  )

  $completed = Wait-Job -Job $Job -Timeout $script:jobTimeoutSeconds
  if ($null -eq $completed) {
    Stop-Job -Job $Job -ErrorAction SilentlyContinue
    Remove-Job -Job $Job -Force -ErrorAction SilentlyContinue
    throw "$Label timed out after $($script:jobTimeoutSeconds) seconds."
  }

  $result = Receive-Job -Job $Job -ErrorAction SilentlyContinue
  $state = $Job.State
  Remove-Job -Job $Job -Force -ErrorAction SilentlyContinue
  if ($state -ne "Completed") {
    throw "$Label failed with state $state."
  }

  return ($result -join [Environment]::NewLine).Trim()
}

function Remove-Task015CancelledGateJob {
  param(
    [Parameter(Mandatory = $true)]$Job,
    [Parameter(Mandatory = $true)][string]$Label
  )

  $completed = Wait-Job -Job $Job -Timeout $script:jobTimeoutSeconds
  if ($null -eq $completed) {
    Stop-Job -Job $Job -ErrorAction SilentlyContinue
    Remove-Job -Job $Job -Force -ErrorAction SilentlyContinue
    throw "$Label did not terminate after controlled cancellation."
  }

  Receive-Job -Job $Job -ErrorAction SilentlyContinue | Out-Null
  $state = $Job.State
  Remove-Job -Job $Job -Force -ErrorAction SilentlyContinue
  if ($state -ne "Failed") {
    throw "$Label expected a cancelled/failed gate worker but received state $state."
  }
}

function Wait-Task015SqlValue {
  param(
    [Parameter(Mandatory = $true)][string]$Sql,
    [Parameter(Mandatory = $true)][string]$Expected,
    [Parameter(Mandatory = $true)][string]$Label
  )

  $deadline = [DateTime]::UtcNow.AddSeconds($script:readinessTimeoutSeconds)
  $actual = ""
  do {
    $actual = Invoke-Task015Psql -Sql $Sql
    if ($actual -eq $Expected) {
      return
    }
    Start-Sleep -Milliseconds 100
  } while ([DateTime]::UtcNow -lt $deadline)

  throw "$Label timed out after $($script:readinessTimeoutSeconds) seconds; expected '$Expected', received '$actual'."
}

function Assert-Task015Equal {
  param(
    [Parameter(Mandatory = $true)][string]$Actual,
    [Parameter(Mandatory = $true)][string]$Expected,
    [Parameter(Mandatory = $true)][string]$Label
  )

  if ($Actual -ne $Expected) {
    throw "$Label expected '$Expected' but received '$Actual'."
  }
}

function Assert-Task015True {
  param(
    [Parameter(Mandatory = $true)][bool]$Condition,
    [Parameter(Mandatory = $true)][string]$Label
  )

  if (-not $Condition) {
    throw "$Label expected true."
  }
}

function New-Task015CallSql {
  param(
    [Parameter(Mandatory = $true)][string]$ApplicationName,
    [Parameter(Mandatory = $true)][string]$AuthSubjectId,
    [Parameter(Mandatory = $true)][string]$TargetMembershipId,
    [string]$Operation = "DISABLE",
    [AllowNull()][string]$RequestedRole = $null
  )

  $requestedRoleSql = if ([string]::IsNullOrEmpty($RequestedRole)) {
    "null"
  } else {
    "'$RequestedRole'"
  }

  return @"
set application_name = '$ApplicationName';
begin;
set local role authenticated;
do `$claim`$
begin
  perform set_config('request.jwt.claim.sub', '$AuthSubjectId', true);
end;
`$claim`$;
select outcome from public.apply_company_membership_lifecycle(
  '$TargetMembershipId',
  '$Operation',
  $requestedRoleSql
);
commit;
"@
}

function Invoke-Task015CoordinatedRace {
  param(
    [Parameter(Mandatory = $true)][string]$Label,
    [Parameter(Mandatory = $true)][long]$GateKey,
    [Parameter(Mandatory = $true)][string]$CompanyId,
    [Parameter(Mandatory = $true)][string]$WorkerAName,
    [Parameter(Mandatory = $true)][string]$WorkerASql,
    [AllowNull()][string]$WorkerBName = $null,
    [AllowNull()][string]$WorkerBSql = $null,
    [string]$BlockerAfterGateSql = ""
  )

  $gateName = "task015_${Label}_gate"
  $blockerName = "task015_${Label}_blocker"
  $gateSql = @"
set application_name = '$gateName';
select pg_advisory_lock($GateKey);
select pg_sleep(25);
select pg_advisory_unlock($GateKey);
"@
  $blockerSql = @"
set application_name = '$blockerName';
begin;
select id from public.maintenance_companies where id = '$CompanyId' for update;
select pg_advisory_xact_lock($GateKey);
$BlockerAfterGateSql
commit;
"@

  $gateJob = Start-Task015PsqlJob -Sql $gateSql
  Wait-Task015SqlValue -Sql @"
select count(*)
from pg_stat_activity
where application_name = '$gateName'
  and state = 'active'
  and wait_event_type = 'Timeout'
  and wait_event = 'PgSleep';
"@ -Expected "1" -Label "$Label gate readiness"

  $blockerJob = Start-Task015PsqlJob -Sql $blockerSql
  Wait-Task015SqlValue -Sql @"
select count(*)
from pg_stat_activity as blocker
where blocker.application_name = '$blockerName'
  and blocker.state = 'active'
  and blocker.wait_event_type = 'Lock'
  and exists (
    select 1
    from unnest(pg_blocking_pids(blocker.pid)) as blocking(pid)
    join pg_stat_activity as gate on gate.pid = blocking.pid
    where gate.application_name = '$gateName'
  );
"@ -Expected "1" -Label "$Label blocker tenant-lock readiness"

  $workerAJob = Start-Task015PsqlJob -Sql $WorkerASql
  $workerBJob = $null
  $workerNames = @($WorkerAName)
  if (-not [string]::IsNullOrEmpty($WorkerBSql)) {
    $workerBJob = Start-Task015PsqlJob -Sql $WorkerBSql
    $workerNames += $WorkerBName
  }
  $workerNamesSql = ($workerNames | ForEach-Object { "'$_'" }) -join ", "
  $coordinationNamesSql = "'$blockerName', $workerNamesSql"
  $expectedWorkerCount = $workerNames.Count.ToString()

  Wait-Task015SqlValue -Sql @"
select count(*)
from pg_stat_activity as worker
where worker.application_name in ($workerNamesSql)
  and worker.state = 'active'
  and worker.wait_event_type = 'Lock'
  and exists (
    select 1
    from unnest(pg_blocking_pids(worker.pid)) as blocking(pid)
    join pg_stat_activity as coordinator on coordinator.pid = blocking.pid
    where coordinator.application_name in ($coordinationNamesSql)
  );
"@ -Expected $expectedWorkerCount -Label "$Label observed worker lock waits"

  $gateCancelled = Invoke-Task015Psql -Sql @"
select pg_cancel_backend(pid)::text
from pg_stat_activity
where application_name = '$gateName';
"@
  Assert-Task015Equal -Actual $gateCancelled -Expected "true" -Label "$Label controlled gate release"
  Remove-Task015CancelledGateJob -Job $gateJob -Label "$Label gate worker"
  Receive-Task015Job -Job $blockerJob -Label "$Label blocker" | Out-Null

  $workerAResult = Receive-Task015Job -Job $workerAJob -Label "$Label worker A"
  $workerBResult = if ($null -ne $workerBJob) {
    Receive-Task015Job -Job $workerBJob -Label "$Label worker B"
  } else {
    $null
  }

  return [pscustomobject]@{
    A = $workerAResult
    B = $workerBResult
  }
}

$cleanupSql = @"
delete from public.audit_events
where maintenance_company_id in ('$companyOne', '$companyTwo', '$companyThree');
delete from public.company_memberships
where maintenance_company_id in ('$companyOne', '$companyTwo', '$companyThree');
delete from public.platform_user_auth_subjects
where platform_user_id::text like '15990000-0000-4000-8000-%';
delete from public.platform_users
where id::text like '15990000-0000-4000-8000-%';
delete from auth.users
where id::text like '95990000-0000-4000-8000-%';
delete from public.maintenance_companies
where id in ('$companyOne', '$companyTwo', '$companyThree');
"@

$setupSql = @"
$cleanupSql

insert into auth.users (id)
values
  ('95990000-0000-4000-8000-000000000001'),
  ('95990000-0000-4000-8000-000000000002'),
  ('95990000-0000-4000-8000-000000000003'),
  ('95990000-0000-4000-8000-000000000004'),
  ('95990000-0000-4000-8000-000000000005'),
  ('95990000-0000-4000-8000-000000000006'),
  ('95990000-0000-4000-8000-000000000007'),
  ('95990000-0000-4000-8000-000000000008');

insert into public.maintenance_companies (id)
values ('$companyOne'), ('$companyTwo'), ('$companyThree');

insert into public.platform_users (id)
values
  ('15990000-0000-4000-8000-000000000101'),
  ('15990000-0000-4000-8000-000000000102'),
  ('15990000-0000-4000-8000-000000000201'),
  ('15990000-0000-4000-8000-000000000202'),
  ('15990000-0000-4000-8000-000000000301'),
  ('15990000-0000-4000-8000-000000000302'),
  ('15990000-0000-4000-8000-000000000303'),
  ('15990000-0000-4000-8000-000000000304');

insert into public.platform_user_auth_subjects (auth_subject_id, platform_user_id)
values
  ('95990000-0000-4000-8000-000000000001', '15990000-0000-4000-8000-000000000101'),
  ('95990000-0000-4000-8000-000000000002', '15990000-0000-4000-8000-000000000102'),
  ('95990000-0000-4000-8000-000000000003', '15990000-0000-4000-8000-000000000201'),
  ('95990000-0000-4000-8000-000000000004', '15990000-0000-4000-8000-000000000202'),
  ('95990000-0000-4000-8000-000000000005', '15990000-0000-4000-8000-000000000301'),
  ('95990000-0000-4000-8000-000000000006', '15990000-0000-4000-8000-000000000302'),
  ('95990000-0000-4000-8000-000000000007', '15990000-0000-4000-8000-000000000303'),
  ('95990000-0000-4000-8000-000000000008', '15990000-0000-4000-8000-000000000304');

insert into public.company_memberships (
  id, platform_user_id, maintenance_company_id, role, is_enabled
)
values
  ('15990000-0000-4000-8000-000000001101', '15990000-0000-4000-8000-000000000101', '$companyOne', 'COMPANY_ADMIN', true),
  ('15990000-0000-4000-8000-000000001102', '15990000-0000-4000-8000-000000000102', '$companyOne', 'COMPANY_ADMIN', true),
  ('15990000-0000-4000-8000-000000001201', '15990000-0000-4000-8000-000000000201', '$companyTwo', 'COMPANY_ADMIN', true),
  ('15990000-0000-4000-8000-000000001202', '15990000-0000-4000-8000-000000000202', '$companyTwo', 'TECHNICIAN', true),
  ('15990000-0000-4000-8000-000000001301', '15990000-0000-4000-8000-000000000301', '$companyThree', 'COMPANY_ADMIN', true),
  ('15990000-0000-4000-8000-000000001302', '15990000-0000-4000-8000-000000000302', '$companyThree', 'COMPANY_ADMIN', true),
  ('15990000-0000-4000-8000-000000001303', '15990000-0000-4000-8000-000000000303', '$companyThree', 'TECHNICIAN', true),
  ('15990000-0000-4000-8000-000000001304', '15990000-0000-4000-8000-000000000304', '$companyThree', 'TECHNICIAN', true);
"@

try {
  Invoke-Task015Psql -Sql $setupSql | Out-Null

  $duplicate = Invoke-Task015CoordinatedRace `
    -Label "con001" -GateKey 15015001 -CompanyId $companyTwo `
    -WorkerAName "task015_con001_a" `
    -WorkerASql (New-Task015CallSql -ApplicationName "task015_con001_a" `
      -AuthSubjectId "95990000-0000-4000-8000-000000000003" `
      -TargetMembershipId "15990000-0000-4000-8000-000000001202") `
    -WorkerBName "task015_con001_b" `
    -WorkerBSql (New-Task015CallSql -ApplicationName "task015_con001_b" `
      -AuthSubjectId "95990000-0000-4000-8000-000000000003" `
      -TargetMembershipId "15990000-0000-4000-8000-000000001202")
  Assert-Task015Equal -Actual ((@($duplicate.A, $duplicate.B) | Sort-Object) -join ",") `
    -Expected "ALREADY_SATISFIED,APPLIED" -Label "T015-CON-001 outcomes"
  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select (not is_enabled)::text
from public.company_memberships
where id = '15990000-0000-4000-8000-000000001202';
"@) -Expected "true" -Label "T015-CON-001 target final state"
  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select count(*)
from public.audit_events
where maintenance_company_id = '$companyTwo'
  and subject_platform_user_id = '15990000-0000-4000-8000-000000000202'
  and action = 'USER_DISABLED_OR_REVOKED';
"@) -Expected "1" -Label "T015-CON-001 matching audit count"

  $duplicateRole = Invoke-Task015CoordinatedRace `
    -Label "con002" -GateKey 15015002 -CompanyId $companyTwo `
    -WorkerAName "task015_con002_a" `
    -WorkerASql (New-Task015CallSql -ApplicationName "task015_con002_a" `
      -AuthSubjectId "95990000-0000-4000-8000-000000000003" `
      -TargetMembershipId "15990000-0000-4000-8000-000000001202" `
      -Operation "CHANGE_ROLE" -RequestedRole "COMPANY_ADMIN") `
    -WorkerBName "task015_con002_b" `
    -WorkerBSql (New-Task015CallSql -ApplicationName "task015_con002_b" `
      -AuthSubjectId "95990000-0000-4000-8000-000000000003" `
      -TargetMembershipId "15990000-0000-4000-8000-000000001202" `
      -Operation "CHANGE_ROLE" -RequestedRole "COMPANY_ADMIN")
  Assert-Task015Equal -Actual ((@($duplicateRole.A, $duplicateRole.B) | Sort-Object) -join ",") `
    -Expected "ALREADY_SATISFIED,APPLIED" -Label "T015-CON-002 outcomes"
  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select (not is_enabled and role = 'COMPANY_ADMIN')::text
from public.company_memberships
where id = '15990000-0000-4000-8000-000000001202';
"@) -Expected "true" -Label "T015-CON-002 target role and enabled state"
  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select count(*)
from public.audit_events
where maintenance_company_id = '$companyTwo'
  and subject_platform_user_id = '15990000-0000-4000-8000-000000000202'
  and action = 'USER_ROLE_CHANGED'
  and role_before = 'TECHNICIAN'
  and role_after = 'COMPANY_ADMIN';
"@) -Expected "1" -Label "T015-CON-002 exact role audit count"

  $lastAdmin = Invoke-Task015CoordinatedRace `
    -Label "con003" -GateKey 15015003 -CompanyId $companyOne `
    -WorkerAName "task015_con003_a" `
    -WorkerASql (New-Task015CallSql -ApplicationName "task015_con003_a" `
      -AuthSubjectId "95990000-0000-4000-8000-000000000001" `
      -TargetMembershipId "15990000-0000-4000-8000-000000001102") `
    -WorkerBName "task015_con003_b" `
    -WorkerBSql (New-Task015CallSql -ApplicationName "task015_con003_b" `
      -AuthSubjectId "95990000-0000-4000-8000-000000000002" `
      -TargetMembershipId "15990000-0000-4000-8000-000000001101")
  Assert-Task015Equal -Actual ((@($lastAdmin.A, $lastAdmin.B) | Sort-Object) -join ",") `
    -Expected "APPLIED,DENIED" -Label "T015-CON-003 outcomes"
  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select count(*)
from public.company_memberships
where maintenance_company_id = '$companyOne'
  and is_enabled
  and role = 'COMPANY_ADMIN';
"@) -Expected "1" -Label "T015-CON-003 enabled admin final count"
  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select count(*)
from public.audit_events
where maintenance_company_id = '$companyOne'
  and subject_platform_user_id in (
    '15990000-0000-4000-8000-000000000101',
    '15990000-0000-4000-8000-000000000102'
  )
  and action = 'USER_DISABLED_OR_REVOKED';
"@) -Expected "1" -Label "T015-CON-003 matching destructive audit count"

  Invoke-Task015Psql -Sql @"
update public.company_memberships
set is_enabled = true, role = 'COMPANY_ADMIN'
where maintenance_company_id = '$companyOne';
delete from public.audit_events where maintenance_company_id = '$companyOne';
"@ | Out-Null

  $demotions = Invoke-Task015CoordinatedRace `
    -Label "con004" -GateKey 15015004 -CompanyId $companyOne `
    -WorkerAName "task015_con004_a" `
    -WorkerASql (New-Task015CallSql -ApplicationName "task015_con004_a" `
      -AuthSubjectId "95990000-0000-4000-8000-000000000001" `
      -TargetMembershipId "15990000-0000-4000-8000-000000001102" `
      -Operation "CHANGE_ROLE" -RequestedRole "TECHNICIAN") `
    -WorkerBName "task015_con004_b" `
    -WorkerBSql (New-Task015CallSql -ApplicationName "task015_con004_b" `
      -AuthSubjectId "95990000-0000-4000-8000-000000000002" `
      -TargetMembershipId "15990000-0000-4000-8000-000000001101" `
      -Operation "CHANGE_ROLE" -RequestedRole "TECHNICIAN")
  Assert-Task015Equal -Actual ((@($demotions.A, $demotions.B) | Sort-Object) -join ",") `
    -Expected "APPLIED,DENIED" -Label "T015-CON-004 outcomes"
  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select count(*)
from public.company_memberships
where maintenance_company_id = '$companyOne'
  and is_enabled
  and role = 'COMPANY_ADMIN';
"@) -Expected "1" -Label "T015-CON-004 enabled admin final count"
  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select count(*)
from public.audit_events
where maintenance_company_id = '$companyOne'
  and subject_platform_user_id in (
    '15990000-0000-4000-8000-000000000101',
    '15990000-0000-4000-8000-000000000102'
  )
  and action = 'USER_ROLE_CHANGED';
"@) -Expected "1" -Label "T015-CON-004 matching role audit count"

  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select (is_enabled and role = 'COMPANY_ADMIN')::text
from public.company_memberships
where id = '15990000-0000-4000-8000-000000001301';
"@) -Expected "true" -Label "T015-CON-005 actor initial authority"
  $actorLoss = Invoke-Task015CoordinatedRace `
    -Label "con005" -GateKey 15015005 -CompanyId $companyThree `
    -WorkerAName "task015_con005_victim" `
    -WorkerASql (New-Task015CallSql -ApplicationName "task015_con005_victim" `
      -AuthSubjectId "95990000-0000-4000-8000-000000000005" `
      -TargetMembershipId "15990000-0000-4000-8000-000000001303") `
    -BlockerAfterGateSql @"
update public.company_memberships
set is_enabled = false
where id = '15990000-0000-4000-8000-000000001301';
"@
  Assert-Task015Equal -Actual $actorLoss.A -Expected "DENIED" `
    -Label "T015-CON-005 post-lock actor revalidation outcome"
  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select (not is_enabled)::text
from public.company_memberships
where id = '15990000-0000-4000-8000-000000001301';
"@) -Expected "true" -Label "T015-CON-005 actor authority removed by blocker"
  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select (is_enabled and role = 'TECHNICIAN')::text
from public.company_memberships
where id = '15990000-0000-4000-8000-000000001303';
"@) -Expected "true" -Label "T015-CON-005 target remains unchanged"
  Assert-Task015Equal -Actual (Invoke-Task015Psql -Sql @"
select count(*)
from public.audit_events
where maintenance_company_id = '$companyThree'
  and subject_platform_user_id = '15990000-0000-4000-8000-000000000303'
  and action = 'USER_DISABLED_OR_REVOKED';
"@) -Expected "0" -Label "T015-CON-005 target audit count"

  $opposing = Invoke-Task015CoordinatedRace `
    -Label "con006" -GateKey 15015006 -CompanyId $companyThree `
    -WorkerAName "task015_con006_disable" `
    -WorkerASql (New-Task015CallSql -ApplicationName "task015_con006_disable" `
      -AuthSubjectId "95990000-0000-4000-8000-000000000006" `
      -TargetMembershipId "15990000-0000-4000-8000-000000001304") `
    -WorkerBName "task015_con006_reinstate" `
    -WorkerBSql (New-Task015CallSql -ApplicationName "task015_con006_reinstate" `
      -AuthSubjectId "95990000-0000-4000-8000-000000000006" `
      -TargetMembershipId "15990000-0000-4000-8000-000000001304" `
      -Operation "REINSTATE")
  Assert-Task015Equal -Actual $opposing.A -Expected "APPLIED" `
    -Label "T015-CON-006 DISABLE outcome"
  Assert-Task015True -Condition ($opposing.B -in @("APPLIED", "ALREADY_SATISFIED")) `
    -Label "T015-CON-006 REINSTATE outcome"
  $opposingState = Invoke-Task015Psql -Sql @"
select membership.is_enabled::text || ',' || membership.role || ',' ||
  disable_events.event_count || ',' || reinstate_events.event_count
from public.company_memberships as membership
cross join lateral (
  select count(*) as event_count
  from public.audit_events
  where maintenance_company_id = '$companyThree'
    and subject_platform_user_id = '15990000-0000-4000-8000-000000000304'
    and action = 'USER_DISABLED_OR_REVOKED'
) as disable_events
cross join lateral (
  select count(*) as event_count
  from public.audit_events
  where maintenance_company_id = '$companyThree'
    and subject_platform_user_id = '15990000-0000-4000-8000-000000000304'
    and action = 'USER_REINSTATED'
) as reinstate_events
where membership.id = '15990000-0000-4000-8000-000000001304';
"@
  if ($opposing.B -eq "APPLIED") {
    Assert-Task015Equal -Actual $opposingState -Expected "true,TECHNICIAN,1,1" `
      -Label "T015-CON-006 DISABLE then REINSTATE serialization"
  } else {
    Assert-Task015Equal -Actual $opposingState -Expected "false,TECHNICIAN,1,0" `
      -Label "T015-CON-006 REINSTATE no-op then DISABLE serialization"
  }

  Write-Output "TASK-015 CONCURRENCY HARNESS = PASS"
}
finally {
  $task015Jobs | Where-Object { $_.State -in @("Running", "NotStarted") } |
    Stop-Job -ErrorAction SilentlyContinue
  $task015Jobs | Remove-Job -Force -ErrorAction SilentlyContinue
  Invoke-Task015Psql -Sql $cleanupSql | Out-Null
  if ($null -eq $previousConnectTimeout) {
    Remove-Item -LiteralPath Env:PGCONNECT_TIMEOUT -ErrorAction SilentlyContinue
  } else {
    $env:PGCONNECT_TIMEOUT = $previousConnectTimeout
  }
}
