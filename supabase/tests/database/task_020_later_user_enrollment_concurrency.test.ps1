[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$previousPath = $env:PATH
if ($null -eq (Get-Command psql -ErrorAction SilentlyContinue)) {
  $postgresBin = Join-Path ([Environment]::GetFolderPath('ProgramFiles')) 'PostgreSQL\17\bin'
  $psqlCandidate = Join-Path $postgresBin 'psql.exe'
  if (Test-Path -LiteralPath $psqlCandidate -PathType Leaf) {
    $env:PATH = $postgresBin + [IO.Path]::PathSeparator + $env:PATH
  }
}

if ($null -eq (Get-Command psql -ErrorAction SilentlyContinue)) {
  throw "psql is required for the TASK-020 concurrency harness."
}

$jobs = [System.Collections.Generic.List[object]]::new()
$previousConnectTimeout = $env:PGCONNECT_TIMEOUT
$env:PGCONNECT_TIMEOUT = "5"
$jobTimeoutSeconds = 45
$subjectId = "a2990000-0000-4000-8000-000000000001"
$actorId = "b2990000-0000-4000-8000-000000000001"
$companyId = "c2990000-0000-4000-8000-000000000001"
$membershipId = "d2990000-0000-4000-8000-000000000001"

function Invoke-Task020Psql {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $boundedSql = "set statement_timeout = '40s'; set lock_timeout = '30s'; $Sql"
  $output = & psql --no-psqlrc --quiet --set=ON_ERROR_STOP=1 --tuples-only --no-align --command $boundedSql 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Bounded TASK-020 psql command failed."
  }
  return ($output -join [Environment]::NewLine).Trim()
}

function Start-Task020PsqlJob {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $boundedSql = "set statement_timeout = '40s'; set lock_timeout = '30s'; $Sql"
  $job = Start-Job -ScriptBlock {
    param($Statement)
    $result = & psql --no-psqlrc --quiet --set=ON_ERROR_STOP=1 --tuples-only --no-align --command $Statement 2>&1
    if ($LASTEXITCODE -ne 0) {
      return "ERROR"
    }
    ($result -join [Environment]::NewLine).Trim()
  } -ArgumentList $boundedSql
  $script:jobs.Add($job) | Out-Null
  return $job
}

function Receive-Task020Job {
  param([Parameter(Mandatory = $true)]$Job)

  $completed = Wait-Job -Job $Job -Timeout $script:jobTimeoutSeconds
  if ($null -eq $completed) {
    Stop-Job -Job $Job -ErrorAction SilentlyContinue
    throw "TASK-020 concurrent worker timed out."
  }
  $result = Receive-Job -Job $Job -ErrorAction SilentlyContinue
  if ($Job.State -ne "Completed") {
    throw "TASK-020 concurrent worker failed."
  }
  Remove-Job -Job $Job -Force -ErrorAction SilentlyContinue
  return ($result -join [Environment]::NewLine).Trim()
}

function Assert-Task020 {
  param(
    [Parameter(Mandatory = $true)][bool]$Condition,
    [Parameter(Mandatory = $true)][string]$Label
  )

  if (-not $Condition) {
    throw "$Label failed."
  }
  Write-Output "$Label = PASS"
}

function New-EstablishSql {
  param(
    [Parameter(Mandatory = $true)][string]$IntentId,
    [Parameter(Mandatory = $true)][string]$Email,
    [Parameter(Mandatory = $true)][string]$EstablishmentId,
    [Parameter(Mandatory = $true)][string]$ChallengeId,
    [Parameter(Mandatory = $true)][string]$IssueId,
    [Parameter(Mandatory = $true)][string]$VerifierHex
  )

  return @"
begin;
set local role authenticated;
do `$claim`$
begin
  perform set_config('request.jwt.claim.sub', '$subjectId', true);
end;
`$claim`$;
select outcome || '|' || coalesce(intent_id::text, '') || '|' || coalesce(challenge_id::text, '')
from public.establish_later_user_enrollment_intent(
  '$IntentId', '$Email', 'TECHNICIAN', '$EstablishmentId', '$ChallengeId',
  decode('$VerifierHex', 'hex'), 'v1', '$IssueId'
);
commit;
"@
}

function New-ResendSql {
  param(
    [Parameter(Mandatory = $true)][string]$IntentId,
    [Parameter(Mandatory = $true)][string]$ChallengeId,
    [Parameter(Mandatory = $true)][string]$IssueId,
    [Parameter(Mandatory = $true)][string]$VerifierHex
  )

  return @"
begin;
set local role authenticated;
do `$claim`$
begin
  perform set_config('request.jwt.claim.sub', '$subjectId', true);
end;
`$claim`$;
select outcome || '|' || coalesce(challenge_id::text, '')
from public.resend_later_user_enrollment_challenge(
  '$IntentId', '$ChallengeId', decode('$VerifierHex', 'hex'), 'v1', '$IssueId'
);
commit;
"@
}

function New-VerifySql {
  param(
    [Parameter(Mandatory = $true)][string]$IntentId,
    [Parameter(Mandatory = $true)][string]$ChallengeId,
    [Parameter(Mandatory = $true)][string]$Email,
    [Parameter(Mandatory = $true)][string]$OperationId,
    [Parameter(Mandatory = $true)][bool]$Matched
  )

  $matchedSql = if ($Matched) { "true" } else { "false" }
  return @"
begin;
set local role service_role;
select outcome || '|' || attempt_number::text || '|' || handoff_ready::text
from public.verify_later_user_enrollment_challenge(
  '$IntentId', '$ChallengeId', '$Email', '$OperationId', $matchedSql, 'v1'
);
commit;
"@
}

$cleanupSql = @"
drop trigger if exists task020_concurrency_delay on public.verification_challenges;
drop function if exists public.task020_concurrency_delay();
delete from public.later_user_enrollment_intents where id::text like '20990000-%';
delete from public.auth_session_grants where challenge_id::text like '20990000-%';
delete from public.verification_challenge_attempts where challenge_id::text like '20990000-%';
delete from public.verification_challenges where id::text like '20990000-%' and supersedes_challenge_id is not null;
delete from public.verification_challenges where id::text like '20990000-%';
delete from public.auth_bridge_credentials where email like 'task020-con-%@example.test';
delete from public.company_memberships where id = '$membershipId';
delete from public.maintenance_companies where id = '$companyId';
delete from public.platform_user_auth_subjects where auth_subject_id = '$subjectId';
delete from public.platform_users where id = '$actorId';
delete from auth.users where id = '$subjectId';
"@

$setupSql = @"
$cleanupSql
insert into auth.users (id, email) values ('$subjectId', 'task020-con-actor@example.test');
insert into public.platform_users (id) values ('$actorId');
insert into public.platform_user_auth_subjects (auth_subject_id, platform_user_id)
values ('$subjectId', '$actorId');
insert into public.maintenance_companies (id) values ('$companyId');
insert into public.company_memberships (id, platform_user_id, maintenance_company_id, role, is_enabled)
values ('$membershipId', '$actorId', '$companyId', 'COMPANY_ADMIN', true);
create function public.task020_concurrency_delay()
returns trigger
language plpgsql
set search_path = ''
as `$body`$
begin
  if new.id::text like '20990000-0000-4000-8500-%'
    or new.id::text like '20990000-0000-4000-8600-%' then
    perform pg_catalog.pg_sleep(1.2);
  end if;
  return new;
end;
`$body`$;
create trigger task020_concurrency_delay
before insert on public.verification_challenges
for each row execute function public.task020_concurrency_delay();
"@

try {
  Invoke-Task020Psql -Sql $setupSql | Out-Null

  $sameIntent = "20990000-0000-4000-8000-000000000001"
  $sameChallenge = "20990000-0000-4000-8100-000000000001"
  $sameSql = New-EstablishSql -IntentId $sameIntent -Email 'task020-con-same@example.test' `
    -EstablishmentId '20990000-0000-4000-8200-000000000001' `
    -ChallengeId $sameChallenge -IssueId '20990000-0000-4000-8300-000000000001' `
    -VerifierHex (('11' * 32) -join '')
  $sameA = Start-Task020PsqlJob -Sql $sameSql
  $sameB = Start-Task020PsqlJob -Sql $sameSql
  $sameResults = @((Receive-Task020Job -Job $sameA), (Receive-Task020Job -Job $sameB))
  Write-Output "T020-CON-SAME-RESULTS = $($sameResults -join ',')"
  $sameState = Invoke-Task020Psql -Sql "select (select count(*) from public.later_user_enrollment_intents where id = '$sameIntent') || '|' || (select count(*) from public.verification_challenges where id = '$sameChallenge');"
  Assert-Task020 -Condition ($sameState -eq '1|1') -Label 'T020-CON-001'
  Assert-Task020 -Condition ((@($sameResults | ForEach-Object { ($_ -split '\|')[0] } | Sort-Object) -join ',') -eq 'ALREADY_RECONCILED,ESTABLISHED') -Label 'T020-CON-002'

  $collisionEmail = 'task020-con-collision@example.test'
  $collisionA = Start-Task020PsqlJob -Sql (New-EstablishSql `
    -IntentId '20990000-0000-4000-8000-000000000002' -Email $collisionEmail `
    -EstablishmentId '20990000-0000-4000-8200-000000000002' `
    -ChallengeId '20990000-0000-4000-8100-000000000002' `
    -IssueId '20990000-0000-4000-8300-000000000002' -VerifierHex (('21' * 32) -join ''))
  $collisionB = Start-Task020PsqlJob -Sql (New-EstablishSql `
    -IntentId '20990000-0000-4000-8000-000000000003' -Email $collisionEmail `
    -EstablishmentId '20990000-0000-4000-8200-000000000003' `
    -ChallengeId '20990000-0000-4000-8100-000000000003' `
    -IssueId '20990000-0000-4000-8300-000000000003' -VerifierHex (('22' * 32) -join ''))
  $collisionResults = @((Receive-Task020Job -Job $collisionA), (Receive-Task020Job -Job $collisionB))
  Write-Output "T020-CON-COLLISION-RESULTS = $($collisionResults -join ',')"
  $collisionState = Invoke-Task020Psql -Sql "select (select count(*) from public.later_user_enrollment_intents where target_email = '$collisionEmail') || '|' || (select count(*) from public.verification_challenges where email = '$collisionEmail');"
  Assert-Task020 -Condition ($collisionState -eq '1|1') -Label 'T020-CON-003'
  Assert-Task020 -Condition ((@($collisionResults | ForEach-Object { ($_ -split '\|')[0] } | Sort-Object) -join ',') -eq 'CONFLICT,ESTABLISHED') -Label 'T020-CON-004'

  $resendA = Start-Task020PsqlJob -Sql (New-ResendSql -IntentId $sameIntent `
    -ChallengeId '20990000-0000-4000-8500-000000000001' `
    -IssueId '20990000-0000-4000-8500-000000000101' -VerifierHex (('31' * 32) -join ''))
  $resendB = Start-Task020PsqlJob -Sql (New-ResendSql -IntentId $sameIntent `
    -ChallengeId '20990000-0000-4000-8500-000000000002' `
    -IssueId '20990000-0000-4000-8500-000000000102' -VerifierHex (('32' * 32) -join ''))
  $resendResults = @((Receive-Task020Job -Job $resendA), (Receive-Task020Job -Job $resendB))
  Write-Output "T020-CON-RESEND-RESULTS = $($resendResults -join ',')"
  $resendState = Invoke-Task020Psql -Sql "select (select count(*) from public.verification_challenges where supersedes_challenge_id = '$sameChallenge') || '|' || (select count(*) from public.later_user_enrollment_intents where id = '$sameIntent' and current_challenge_id in ('20990000-0000-4000-8500-000000000001','20990000-0000-4000-8500-000000000002'));"
  Assert-Task020 -Condition ($resendState -eq '1|1') -Label 'T020-CON-005'
  Assert-Task020 -Condition ((@($resendResults | ForEach-Object { ($_ -split '\|')[0] } | Sort-Object) -join ',') -eq 'RESENT,STALE_OR_CONFLICT') -Label 'T020-CON-006'

  $verifyIntent = "20990000-0000-4000-8000-000000000004"
  $verifyChallenge = "20990000-0000-4000-8100-000000000004"
  Invoke-Task020Psql -Sql (New-EstablishSql -IntentId $verifyIntent `
    -Email 'task020-con-verify@example.test' `
    -EstablishmentId '20990000-0000-4000-8200-000000000004' `
    -ChallengeId $verifyChallenge -IssueId '20990000-0000-4000-8300-000000000004' `
    -VerifierHex (('41' * 32) -join '')) | Out-Null
  $verifyA = Start-Task020PsqlJob -Sql (New-VerifySql -IntentId $verifyIntent `
    -ChallengeId $verifyChallenge -Email 'task020-con-verify@example.test' `
    -OperationId '20990000-0000-4000-8700-000000000001' -Matched $true)
  $verifyB = Start-Task020PsqlJob -Sql (New-VerifySql -IntentId $verifyIntent `
    -ChallengeId $verifyChallenge -Email 'task020-con-verify@example.test' `
    -OperationId '20990000-0000-4000-8700-000000000002' -Matched $true)
  $verifyResults = @((Receive-Task020Job -Job $verifyA), (Receive-Task020Job -Job $verifyB))
  Write-Output "T020-CON-VERIFY-RESULTS = $($verifyResults -join ',')"
  $verifyState = Invoke-Task020Psql -Sql "select (select count(*) from public.verification_challenge_attempts where challenge_id = '$verifyChallenge') || '|' || (select count(*) from public.auth_session_grants where challenge_id = '$verifyChallenge') || '|' || (select count(*) from public.later_user_enrollment_intents where id = '$verifyIntent' and handoff_session_grant_id is not null);"
  Assert-Task020 -Condition ($verifyState -eq '1|1|1') -Label 'T020-CON-007'
  Assert-Task020 -Condition ((@($verifyResults | Where-Object { $_ -like 'CONSUMED|*' }).Count -eq 1) -and (@($verifyResults | Where-Object { $_ -eq 'ERROR' }).Count -eq 1)) -Label 'T020-CON-008'

  $wrongIntent = "20990000-0000-4000-8000-000000000005"
  $wrongChallenge = "20990000-0000-4000-8100-000000000005"
  Invoke-Task020Psql -Sql (New-EstablishSql -IntentId $wrongIntent `
    -Email 'task020-con-wrong@example.test' `
    -EstablishmentId '20990000-0000-4000-8200-000000000005' `
    -ChallengeId $wrongChallenge -IssueId '20990000-0000-4000-8300-000000000005' `
    -VerifierHex (('51' * 32) -join '')) | Out-Null
  $wrongJobs = 1..4 | ForEach-Object {
    Start-Task020PsqlJob -Sql (New-VerifySql -IntentId $wrongIntent `
      -ChallengeId $wrongChallenge -Email 'task020-con-wrong@example.test' `
      -OperationId ("20990000-0000-4000-8800-{0}" -f $_.ToString('D12')) -Matched $false)
  }
  $wrongResults = @($wrongJobs | ForEach-Object { Receive-Task020Job -Job $_ })
  Write-Output "T020-CON-WRONG-RESULTS = $($wrongResults -join ',')"
  $wrongState = Invoke-Task020Psql -Sql "select attempt_count::text || '|' || (exhausted_at is not null)::text || '|' || (select count(*) from public.verification_challenge_attempts where challenge_id = '$wrongChallenge') from public.verification_challenges where id = '$wrongChallenge';"
  Assert-Task020 -Condition ($wrongState -eq '3|true|3') -Label 'T020-CON-009'
  Assert-Task020 -Condition ((@($wrongResults | Where-Object { $_ -eq 'ERROR' }).Count -eq 1) -and (@($wrongResults | Where-Object { $_ -like 'INVALID|*' -or $_ -like 'EXHAUSTED|*' }).Count -eq 3)) -Label 'T020-CON-010'

  $raceIntent = "20990000-0000-4000-8000-000000000006"
  $raceChallenge = "20990000-0000-4000-8100-000000000006"
  $raceSuccessor = "20990000-0000-4000-8600-000000000001"
  Invoke-Task020Psql -Sql (New-EstablishSql -IntentId $raceIntent `
    -Email 'task020-con-race@example.test' `
    -EstablishmentId '20990000-0000-4000-8200-000000000006' `
    -ChallengeId $raceChallenge -IssueId '20990000-0000-4000-8300-000000000006' `
    -VerifierHex (('61' * 32) -join '')) | Out-Null
  $raceVerify = Start-Task020PsqlJob -Sql (New-VerifySql -IntentId $raceIntent `
    -ChallengeId $raceChallenge -Email 'task020-con-race@example.test' `
    -OperationId '20990000-0000-4000-8900-000000000001' -Matched $true)
  $raceResend = Start-Task020PsqlJob -Sql (New-ResendSql -IntentId $raceIntent `
    -ChallengeId $raceSuccessor -IssueId '20990000-0000-4000-8900-000000000002' `
    -VerifierHex (('62' * 32) -join ''))
  $raceResults = @((Receive-Task020Job -Job $raceVerify), (Receive-Task020Job -Job $raceResend))
  Write-Output "T020-CON-RACE-RESULTS = $($raceResults -join ',')"
  $raceState = Invoke-Task020Psql -Sql "select (intent.handoff_session_grant_id is not null)::text || '|' || (intent.current_challenge_id = '$raceSuccessor')::text || '|' || (select count(*) from public.auth_session_grants where challenge_id = '$raceChallenge') || '|' || (select count(*) from public.verification_challenges where supersedes_challenge_id = '$raceChallenge') from public.later_user_enrollment_intents as intent where intent.id = '$raceIntent';"
  Assert-Task020 -Condition ($raceState -in @('true|false|1|0', 'false|true|0|1')) -Label 'T020-CON-011'
  Assert-Task020 -Condition (-not ((@($raceResults | Where-Object { $_ -like 'CONSUMED|*' }).Count -eq 1) -and (@($raceResults | Where-Object { $_ -like 'RESENT|*' }).Count -eq 1))) -Label 'T020-CON-012'

  Write-Output "TASK-020 CONCURRENCY HARNESS = PASS"
}
finally {
  $jobs | Where-Object { $_.State -in @("Running", "NotStarted") } |
    Stop-Job -ErrorAction SilentlyContinue
  $jobs | Remove-Job -Force -ErrorAction SilentlyContinue
  Invoke-Task020Psql -Sql $cleanupSql | Out-Null
  if ($null -eq $previousConnectTimeout) {
    Remove-Item -LiteralPath Env:PGCONNECT_TIMEOUT -ErrorAction SilentlyContinue
  }
  else {
    $env:PGCONNECT_TIMEOUT = $previousConnectTimeout
  }
  $env:PATH = $previousPath
}
