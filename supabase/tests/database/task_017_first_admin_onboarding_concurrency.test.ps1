[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

if ($null -eq (Get-Command psql -ErrorAction SilentlyContinue)) {
  throw "psql is required for the TASK-017 concurrency harness."
}

$task017Jobs = [System.Collections.Generic.List[object]]::new()
$previousConnectTimeout = $env:PGCONNECT_TIMEOUT
$env:PGCONNECT_TIMEOUT = "5"
$jobTimeoutSeconds = 40
$subjectId = "97990000-0000-4000-8000-000000000001"
$actorId = "17390000-0000-4000-8000-000000000001"
$companySame = "17390000-0000-4000-8000-000000000101"
$companyDistinct = "17390000-0000-4000-8000-000000000102"
$companyVerify = "17390000-0000-4000-8000-000000000103"
$companyWrong = "17390000-0000-4000-8000-000000000104"
$intentSame = "17390000-0000-4000-8100-000000000001"
$intentDistinctA = "17390000-0000-4000-8100-000000000002"
$intentDistinctB = "17390000-0000-4000-8100-000000000003"
$intentVerify = "17390000-0000-4000-8100-000000000004"
$intentWrong = "17390000-0000-4000-8100-000000000005"
$challengeSame = "17390000-0000-4000-8200-000000000001"
$challengeDistinctA = "17390000-0000-4000-8200-000000000002"
$challengeDistinctB = "17390000-0000-4000-8200-000000000003"
$challengeVerify = "17390000-0000-4000-8200-000000000004"
$challengeWrong = "17390000-0000-4000-8200-000000000005"
$establishmentSame = "17390000-0000-4000-8300-000000000001"
$establishmentDistinctA = "17390000-0000-4000-8300-000000000002"
$establishmentDistinctB = "17390000-0000-4000-8300-000000000003"
$establishmentVerify = "17390000-0000-4000-8300-000000000004"
$establishmentWrong = "17390000-0000-4000-8300-000000000005"
$issueSame = "17390000-0000-4000-8400-000000000001"
$issueDistinctA = "17390000-0000-4000-8400-000000000002"
$issueDistinctB = "17390000-0000-4000-8400-000000000003"
$issueVerify = "17390000-0000-4000-8400-000000000004"
$issueWrong = "17390000-0000-4000-8400-000000000005"

function Invoke-Task017Psql {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $boundedSql = "set statement_timeout = '35s'; set lock_timeout = '25s'; $Sql"
  $output = & psql --no-psqlrc --quiet --set=ON_ERROR_STOP=1 --tuples-only --no-align --command $boundedSql 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw "Bounded TASK-017 psql command failed."
  }

  return ($output -join [Environment]::NewLine).Trim()
}

function Start-Task017PsqlJob {
  param([Parameter(Mandatory = $true)][string]$Sql)

  $boundedSql = "set statement_timeout = '35s'; set lock_timeout = '25s'; $Sql"
  $job = Start-Job -ScriptBlock {
    param($Statement)
    $result = & psql --no-psqlrc --quiet --set=ON_ERROR_STOP=1 --tuples-only --no-align --command $Statement 2>&1
    if ($LASTEXITCODE -ne 0) {
      return "ERROR"
    }
    ($result -join [Environment]::NewLine).Trim()
  } -ArgumentList $boundedSql
  $script:task017Jobs.Add($job) | Out-Null
  return $job
}

function Receive-Task017Job {
  param([Parameter(Mandatory = $true)]$Job)

  $completed = Wait-Job -Job $Job -Timeout $script:jobTimeoutSeconds
  if ($null -eq $completed) {
    Stop-Job -Job $Job -ErrorAction SilentlyContinue
    throw "TASK-017 concurrent worker timed out."
  }
  $result = Receive-Job -Job $Job -ErrorAction SilentlyContinue
  if ($Job.State -ne "Completed") {
    throw "TASK-017 concurrent worker failed."
  }
  Remove-Job -Job $Job -Force -ErrorAction SilentlyContinue
  return ($result -join [Environment]::NewLine).Trim()
}

function Assert-Task017 {
  param(
    [Parameter(Mandatory = $true)][bool]$Condition,
    [Parameter(Mandatory = $true)][string]$Label
  )

  if (-not $Condition) {
    throw "$Label failed."
  }
  Write-Output "$Label = PASS"
}

function New-Task017EstablishSql {
  param(
    [Parameter(Mandatory = $true)][string]$IntentId,
    [Parameter(Mandatory = $true)][string]$CompanyId,
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
from public.establish_first_admin_onboarding_intent(
  '$IntentId', '$CompanyId', '$Email', '$EstablishmentId', '$ChallengeId',
  decode('$VerifierHex', 'hex'), 'v1', '$IssueId'
);
commit;
"@
}

function New-Task017ResendSql {
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
from public.resend_first_admin_onboarding_challenge(
  '$IntentId', '$ChallengeId', decode('$VerifierHex', 'hex'), 'v1', '$IssueId'
);
commit;
"@
}

function New-Task017VerifySql {
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
from public.verify_first_admin_onboarding_challenge(
  '$IntentId', '$ChallengeId', '$Email', '$OperationId', $matchedSql, 'v1'
);
commit;
"@
}

$cleanupSql = @"
drop trigger if exists task017_concurrency_delay on public.verification_challenges;
drop function if exists public.task017_concurrency_delay();
delete from public.first_admin_onboarding_intents where id::text like '17390000-%';
delete from public.auth_session_grants where challenge_id::text like '17390000-%';
delete from public.verification_challenge_attempts where challenge_id::text like '17390000-%';
delete from public.verification_challenges where id::text like '17390000-%' and supersedes_challenge_id is not null;
delete from public.verification_challenges where id::text like '17390000-%';
delete from public.auth_bridge_credentials where email like 'task017-con-%@example.test';
delete from public.company_memberships where platform_user_id = '$actorId';
delete from public.maintenance_companies where id::text like '17390000-%';
delete from public.platform_user_auth_subjects where auth_subject_id = '$subjectId';
delete from public.platform_users where id = '$actorId';
delete from auth.users where id = '$subjectId';
"@

$setupSql = @"
$cleanupSql
insert into auth.users (id, email) values ('$subjectId', 'task017-con-actor@example.test');
insert into public.platform_users (id, is_super_admin) values ('$actorId', true);
insert into public.platform_user_auth_subjects (auth_subject_id, platform_user_id)
values ('$subjectId', '$actorId');
insert into public.maintenance_companies (id)
values ('$companySame'), ('$companyDistinct'), ('$companyVerify'), ('$companyWrong');
create function public.task017_concurrency_delay()
returns trigger
language plpgsql
set search_path = ''
as `$body`$
begin
  if new.id::text like '17390000-0000-4000-8500-%'
    or new.id::text like '17390000-0000-4000-8600-%' then
    perform pg_catalog.pg_sleep(1.5);
  end if;
  return new;
end;
`$body`$;
create trigger task017_concurrency_delay
before insert on public.verification_challenges
for each row execute function public.task017_concurrency_delay();
"@

try {
  Invoke-Task017Psql -Sql $setupSql | Out-Null

  $sameSql = New-Task017EstablishSql -IntentId $intentSame -CompanyId $companySame `
    -Email 'task017-con-same@example.test' -EstablishmentId $establishmentSame `
    -ChallengeId $challengeSame -IssueId $issueSame -VerifierHex (('11' * 32) -join '')
  $sameA = Start-Task017PsqlJob -Sql $sameSql
  $sameB = Start-Task017PsqlJob -Sql $sameSql
  $sameResults = @((Receive-Task017Job -Job $sameA), (Receive-Task017Job -Job $sameB))
  $sameCounts = Invoke-Task017Psql -Sql "select (select count(*) from public.first_admin_onboarding_intents where id = '$intentSame') || '|' || (select count(*) from public.verification_challenges where id = '$challengeSame');"
  Write-Output "T017-CON-SAME-RESULTS = $($sameResults -join ',')"

  Assert-Task017 -Condition ($sameCounts -eq '1|1') -Label 'T017-CON-001'
  Assert-Task017 -Condition ((@($sameResults | ForEach-Object { ($_ -split '\|')[0] } | Sort-Object) -join ',') -eq 'ALREADY_RECONCILED,ESTABLISHED') -Label 'T017-CON-002'

  $distinctA = Start-Task017PsqlJob -Sql (New-Task017EstablishSql -IntentId $intentDistinctA -CompanyId $companyDistinct `
    -Email 'task017-con-distinct-a@example.test' -EstablishmentId $establishmentDistinctA `
    -ChallengeId $challengeDistinctA -IssueId $issueDistinctA -VerifierHex (('21' * 32) -join ''))
  $distinctB = Start-Task017PsqlJob -Sql (New-Task017EstablishSql -IntentId $intentDistinctB -CompanyId $companyDistinct `
    -Email 'task017-con-distinct-b@example.test' -EstablishmentId $establishmentDistinctB `
    -ChallengeId $challengeDistinctB -IssueId $issueDistinctB -VerifierHex (('22' * 32) -join ''))
  $distinctResults = @((Receive-Task017Job -Job $distinctA), (Receive-Task017Job -Job $distinctB))
  $distinctCount = Invoke-Task017Psql -Sql "select count(*) from public.first_admin_onboarding_intents where maintenance_company_id = '$companyDistinct';"
  Write-Output "T017-CON-DISTINCT-RESULTS = $($distinctResults -join ',')"

  Assert-Task017 -Condition ($distinctCount -eq '1') -Label 'T017-CON-003'
  Assert-Task017 -Condition ((@($distinctResults | ForEach-Object { ($_ -split '\|')[0] } | Sort-Object) -join ',') -eq 'CONFLICT,ESTABLISHED') -Label 'T017-CON-004'

  $resendA = Start-Task017PsqlJob -Sql (New-Task017ResendSql -IntentId $intentSame `
    -ChallengeId '17390000-0000-4000-8500-000000000001' -IssueId '17390000-0000-4000-8500-000000000101' -VerifierHex (('31' * 32) -join ''))
  $resendB = Start-Task017PsqlJob -Sql (New-Task017ResendSql -IntentId $intentSame `
    -ChallengeId '17390000-0000-4000-8500-000000000002' -IssueId '17390000-0000-4000-8500-000000000102' -VerifierHex (('32' * 32) -join ''))
  $resendResults = @((Receive-Task017Job -Job $resendA), (Receive-Task017Job -Job $resendB))
  $resendState = Invoke-Task017Psql -Sql "select (select count(*) from public.verification_challenges where supersedes_challenge_id = '$challengeSame') || '|' || (select count(*) from public.first_admin_onboarding_intents where id = '$intentSame' and current_challenge_id in ('17390000-0000-4000-8500-000000000001','17390000-0000-4000-8500-000000000002'));"
  Write-Output "T017-CON-RESEND-RESULTS = $($resendResults -join ',')"

  Assert-Task017 -Condition ($resendState -eq '1|1') -Label 'T017-CON-005'
  Assert-Task017 -Condition ((@($resendResults | ForEach-Object { ($_ -split '\|')[0] } | Sort-Object) -join ',') -eq 'RESENT,STALE_OR_CONFLICT') -Label 'T017-CON-006'

  Invoke-Task017Psql -Sql (New-Task017EstablishSql -IntentId $intentVerify -CompanyId $companyVerify `
    -Email 'task017-con-verify@example.test' -EstablishmentId $establishmentVerify `
    -ChallengeId $challengeVerify -IssueId $issueVerify -VerifierHex (('41' * 32) -join '')) | Out-Null
  $verifyA = Start-Task017PsqlJob -Sql (New-Task017VerifySql -IntentId $intentVerify -ChallengeId $challengeVerify `
    -Email 'task017-con-verify@example.test' -OperationId '17390000-0000-4000-8700-000000000001' -Matched $true)
  $verifyB = Start-Task017PsqlJob -Sql (New-Task017VerifySql -IntentId $intentVerify -ChallengeId $challengeVerify `
    -Email 'task017-con-verify@example.test' -OperationId '17390000-0000-4000-8700-000000000002' -Matched $true)
  $verifyResults = @((Receive-Task017Job -Job $verifyA), (Receive-Task017Job -Job $verifyB))
  $verifyState = Invoke-Task017Psql -Sql "select (select count(*) from public.verification_challenge_attempts where challenge_id = '$challengeVerify') || '|' || (select count(*) from public.auth_session_grants where challenge_id = '$challengeVerify') || '|' || (select count(*) from public.first_admin_onboarding_intents where id = '$intentVerify' and handoff_session_grant_id is not null);"
  Write-Output "T017-CON-VERIFY-RESULTS = $($verifyResults -join ',')"

  Assert-Task017 -Condition ($verifyState -eq '1|1|1') -Label 'T017-CON-007'
  Assert-Task017 -Condition ((@($verifyResults | Where-Object { $_ -like 'CONSUMED|*' }).Count -eq 1) -and (@($verifyResults | Where-Object { $_ -eq 'ERROR' }).Count -eq 1)) -Label 'T017-CON-008'

  Invoke-Task017Psql -Sql (New-Task017EstablishSql -IntentId $intentWrong -CompanyId $companyWrong `
    -Email 'task017-con-wrong@example.test' -EstablishmentId $establishmentWrong `
    -ChallengeId $challengeWrong -IssueId $issueWrong -VerifierHex (('51' * 32) -join '')) | Out-Null
  $wrongJobs = 1..4 | ForEach-Object {
    Start-Task017PsqlJob -Sql (New-Task017VerifySql -IntentId $intentWrong -ChallengeId $challengeWrong `
      -Email 'task017-con-wrong@example.test' -OperationId ("17390000-0000-4000-8800-{0}" -f $_.ToString('D12')) -Matched $false)
  }
  $wrongResults = @($wrongJobs | ForEach-Object { Receive-Task017Job -Job $_ })
  $wrongState = Invoke-Task017Psql -Sql "select attempt_count::text || '|' || (exhausted_at is not null)::text || '|' || (select count(*) from public.verification_challenge_attempts where challenge_id = '$challengeWrong') from public.verification_challenges where id = '$challengeWrong';"
  Write-Output "T017-CON-WRONG-RESULTS = $($wrongResults -join ',')"

  Assert-Task017 -Condition ($wrongState -eq '3|true|3') -Label 'T017-CON-009'
  Assert-Task017 -Condition ((@($wrongResults | Where-Object { $_ -eq 'ERROR' }).Count -eq 1) -and (@($wrongResults | Where-Object { $_ -like 'INVALID|*' -or $_ -like 'EXHAUSTED|*' }).Count -eq 3)) -Label 'T017-CON-010'

  Write-Output "TASK-017 CONCURRENCY HARNESS = PASS"
}
finally {
  $task017Jobs | Where-Object { $_.State -in @("Running", "NotStarted") } |
    Stop-Job -ErrorAction SilentlyContinue
  $task017Jobs | Remove-Job -Force -ErrorAction SilentlyContinue
  Invoke-Task017Psql -Sql $cleanupSql | Out-Null
  if ($null -eq $previousConnectTimeout) {
    Remove-Item -LiteralPath Env:PGCONNECT_TIMEOUT -ErrorAction SilentlyContinue
  } else {
    $env:PGCONNECT_TIMEOUT = $previousConnectTimeout
  }
}
