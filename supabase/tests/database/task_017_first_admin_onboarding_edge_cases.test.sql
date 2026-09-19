\set ON_ERROR_STOP on

begin;

select plan(37);

insert into auth.users (id, email)
values ('98000000-0000-4000-8000-000000000001', 'task017-edge-actor@example.test');

insert into public.platform_users (id, is_super_admin)
values ('17200000-0000-4000-8000-000000000001', true);

insert into public.platform_user_auth_subjects (auth_subject_id, platform_user_id)
values ('98000000-0000-4000-8000-000000000001', '17200000-0000-4000-8000-000000000001');

insert into public.maintenance_companies (id)
select ('17200000-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid
from generate_series(101, 107) as series;

create function pg_temp.task017_establish(
  p_number integer,
  p_email text
)
returns void
language plpgsql
set search_path = ''
as $$
declare
  v_result record;
begin
  select * into strict v_result
  from public.establish_first_admin_onboarding_intent(
    ('17200000-0000-4000-8100-' || lpad(p_number::text, 12, '0'))::uuid,
    ('17200000-0000-4000-8000-' || lpad((p_number + 100)::text, 12, '0'))::uuid,
    p_email,
    ('17200000-0000-4000-8200-' || lpad(p_number::text, 12, '0'))::uuid,
    ('17200000-0000-4000-8300-' || lpad(p_number::text, 12, '0'))::uuid,
    decode(lpad(to_hex(p_number), 64, '0'), 'hex'),
    'v1',
    ('17200000-0000-4000-8400-' || lpad(p_number::text, 12, '0'))::uuid
  );

  if v_result.outcome <> 'ESTABLISHED' then
    raise exception 'edge fixture establishment failed';
  end if;
end;
$$;

grant execute on function pg_temp.task017_establish(integer, text) to authenticated;

set local role authenticated;
select set_config('request.jwt.claim.sub', '98000000-0000-4000-8000-000000000001', true);
select pg_temp.task017_establish(1, 'attempt-three@example.test');
select pg_temp.task017_establish(2, 'exhausted@example.test');
select pg_temp.task017_establish(3, 'expired@example.test');
select pg_temp.task017_establish(4, 'attempt-one@example.test');
select pg_temp.task017_establish(5, 'stale-pointer@example.test');
select pg_temp.task017_establish(6, 'resend-rollback@example.test');
select pg_temp.task017_establish(7, 'verify-rollback@example.test');
reset role;

set local role service_role;

select is(
  (select attempt_number from public.verify_first_admin_onboarding_challenge(
    '17200000-0000-4000-8100-000000000001',
    '17200000-0000-4000-8300-000000000001',
    'attempt-three@example.test',
    '17200000-0000-4000-8500-000000000001',
    false,
    'v1'
  )),
  1::smallint,
  'T017-EDGE-001 first wrong proof consumes attempt one'
);
select is(
  (select attempt_number from public.verify_first_admin_onboarding_challenge(
    '17200000-0000-4000-8100-000000000001',
    '17200000-0000-4000-8300-000000000001',
    'attempt-three@example.test',
    '17200000-0000-4000-8500-000000000002',
    false,
    'v1'
  )),
  2::smallint,
  'T017-EDGE-002 second wrong proof consumes attempt two'
);
select ok(
  (select outcome = 'CONSUMED' and attempt_number = 3 and handoff_ready
   from public.verify_first_admin_onboarding_challenge(
     '17200000-0000-4000-8100-000000000001',
     '17200000-0000-4000-8300-000000000001',
     'attempt-three@example.test',
     '17200000-0000-4000-8500-000000000003',
     true,
     'v1'
   )),
  'T017-EDGE-003 correct proof succeeds on attempt three'
);
select ok(
  exists (
    select 1 from public.verification_challenges
    where id = '17200000-0000-4000-8300-000000000001'
      and attempt_count = 3
      and consumed_at is not null
      and exhausted_at is null
  ),
  'T017-EDGE-004 attempt-three success is consumed rather than exhausted'
);

select is(
  (select outcome from public.verify_first_admin_onboarding_challenge(
    '17200000-0000-4000-8100-000000000002',
    '17200000-0000-4000-8300-000000000002',
    'exhausted@example.test',
    '17200000-0000-4000-8500-000000000011',
    false,
    'v1'
  )),
  'INVALID',
  'T017-EDGE-005 exhausted fixture wrong attempt one is invalid'
);
select is(
  (select outcome from public.verify_first_admin_onboarding_challenge(
    '17200000-0000-4000-8100-000000000002',
    '17200000-0000-4000-8300-000000000002',
    'exhausted@example.test',
    '17200000-0000-4000-8500-000000000012',
    false,
    'v1'
  )),
  'INVALID',
  'T017-EDGE-006 exhausted fixture wrong attempt two is invalid'
);
select is(
  (select outcome from public.verify_first_admin_onboarding_challenge(
    '17200000-0000-4000-8100-000000000002',
    '17200000-0000-4000-8300-000000000002',
    'exhausted@example.test',
    '17200000-0000-4000-8500-000000000013',
    false,
    'v1'
  )),
  'EXHAUSTED',
  'T017-EDGE-007 third wrong proof exhausts current challenge'
);
select throws_ok(
  $$select * from public.verify_first_admin_onboarding_challenge('17200000-0000-4000-8100-000000000002', '17200000-0000-4000-8300-000000000002', 'exhausted@example.test', '17200000-0000-4000-8500-000000000014', true, 'v1')$$,
  'P0001',
  'Verification attempt denied.',
  'T017-EDGE-008 fourth effective attempt is impossible'
);
select is(
  (select count(*)::integer from public.verification_challenge_attempts where challenge_id = '17200000-0000-4000-8300-000000000002'),
  3,
  'T017-EDGE-009 exhausted challenge contains exactly three attempts'
);

select ok(
  (select outcome = 'CONSUMED' and attempt_number = 1 and handoff_ready
   from public.verify_first_admin_onboarding_challenge(
     '17200000-0000-4000-8100-000000000004',
     '17200000-0000-4000-8300-000000000004',
     'attempt-one@example.test',
     '17200000-0000-4000-8500-000000000021',
     true,
     'v1'
   )),
  'T017-EDGE-010 correct proof succeeds on attempt one'
);
select throws_ok(
  $$select * from public.verify_first_admin_onboarding_challenge('17200000-0000-4000-8100-000000000004', '17200000-0000-4000-8300-000000000004', 'attempt-one@example.test', '17200000-0000-4000-8500-000000000021', false, 'v1')$$,
  'P0001',
  'First-admin verification request denied.',
  'T017-EDGE-010A operation ID cannot reconcile success when the presented proof does not match'
);
select throws_ok(
  $$select * from public.verify_first_admin_onboarding_challenge('17200000-0000-4000-8100-000000000004', '17200000-0000-4000-8300-000000000004', 'wrong@example.test', '17200000-0000-4000-8500-000000000022', true, 'v1')$$,
  'P0001',
  'First-admin verification request denied.',
  'T017-EDGE-011 presented email mismatch is denied generically'
);

reset role;

create temporary table task017_rev001_results (
  label text primary key,
  outcome text not null,
  attempt_number smallint not null,
  handoff_ready boolean not null
);
grant select, insert on task017_rev001_results to service_role;
create temporary table task017_rev001_material (
  label text primary key,
  challenge_id uuid not null
);
grant select, insert on task017_rev001_material to service_role;

set local role service_role;

insert into task017_rev001_material
select 'consumed-same-operation', challenge_id
from public.get_first_admin_onboarding_challenge_material(
  '17200000-0000-4000-8100-000000000004',
  'attempt-one@example.test',
  '17200000-0000-4000-8500-000000000021'
);
insert into task017_rev001_material
select 'consumed-different-operation', challenge_id
from public.get_first_admin_onboarding_challenge_material(
  '17200000-0000-4000-8100-000000000004',
  'attempt-one@example.test',
  '17200000-0000-4000-8500-000000000023'
);

insert into task017_rev001_results
select 'consumed-retry', result.*
from public.verify_first_admin_onboarding_challenge(
  '17200000-0000-4000-8100-000000000004',
  '17200000-0000-4000-8300-000000000004',
  'attempt-one@example.test',
  '17200000-0000-4000-8500-000000000021',
  true,
  'v1'
) as result;

reset role;

select ok(
  exists (
    select 1 from task017_rev001_material
    where label = 'consumed-same-operation'
      and challenge_id = '17200000-0000-4000-8300-000000000004'
  )
  and exists (
    select 1 from task017_rev001_results
    where label = 'consumed-retry'
      and outcome = 'CONSUMED'
      and attempt_number = 1
      and handoff_ready
  )
  and (select attempt_count = 1 from public.verification_challenges where id = '17200000-0000-4000-8300-000000000004')
  and (select count(*) = 1 from public.verification_challenge_attempts where challenge_id = '17200000-0000-4000-8300-000000000004')
  and (select count(*) = 1 from public.auth_session_grants where challenge_id = '17200000-0000-4000-8300-000000000004')
  and (select count(*) = 1 from public.first_admin_onboarding_intents where id = '17200000-0000-4000-8100-000000000004' and handoff_session_grant_id is not null),
  'T017-REV-001-A success response-loss retry reconciles the same consumed attempt grant and handoff'
);

set local role service_role;
select throws_ok(
  $$select * from public.verify_first_admin_onboarding_challenge('17200000-0000-4000-8100-000000000004', '17200000-0000-4000-8300-000000000004', 'attempt-one@example.test', '17200000-0000-4000-8500-000000000021', false, 'v1')$$,
  'P0001',
  'First-admin verification request denied.',
  'T017-REV-001-B successful same operation with incompatible proof fails closed'
);

select throws_ok(
  $$select * from public.verify_first_admin_onboarding_challenge('17200000-0000-4000-8100-000000000004', '17200000-0000-4000-8300-000000000004', 'attempt-one@example.test', '17200000-0000-4000-8500-000000000023', true, 'v1')$$,
  'P0001',
  'First-admin verification request denied.',
  'T017-REV-001-C different operation after consume remains denied'
);
reset role;
select ok(
  (select attempt_count = 1 from public.verification_challenges where id = '17200000-0000-4000-8300-000000000004')
  and (select count(*) = 1 from public.verification_challenge_attempts where challenge_id = '17200000-0000-4000-8300-000000000004')
  and (select count(*) = 1 from public.auth_session_grants where challenge_id = '17200000-0000-4000-8300-000000000004'),
  'T017-REV-001-C-STATE different operation creates no attempt grant or handoff change'
);

set local role service_role;
insert into task017_rev001_material
select 'exhausted-same-operation', challenge_id
from public.get_first_admin_onboarding_challenge_material(
  '17200000-0000-4000-8100-000000000002',
  'exhausted@example.test',
  '17200000-0000-4000-8500-000000000013'
);
insert into task017_rev001_material
select 'exhausted-different-operation', challenge_id
from public.get_first_admin_onboarding_challenge_material(
  '17200000-0000-4000-8100-000000000002',
  'exhausted@example.test',
  '17200000-0000-4000-8500-000000000024'
);
insert into task017_rev001_results
select 'exhausted-retry', result.*
from public.verify_first_admin_onboarding_challenge(
  '17200000-0000-4000-8100-000000000002',
  '17200000-0000-4000-8300-000000000002',
  'exhausted@example.test',
  '17200000-0000-4000-8500-000000000013',
  false,
  'v1'
) as result;

reset role;

select ok(
  exists (
    select 1 from task017_rev001_material
    where label = 'exhausted-same-operation'
      and challenge_id = '17200000-0000-4000-8300-000000000002'
  )
  and exists (
    select 1 from task017_rev001_results
    where label = 'exhausted-retry'
      and outcome = 'EXHAUSTED'
      and attempt_number = 3
      and not handoff_ready
  )
  and (select attempt_count = 3 from public.verification_challenges where id = '17200000-0000-4000-8300-000000000002')
  and (select count(*) = 3 from public.verification_challenge_attempts where challenge_id = '17200000-0000-4000-8300-000000000002')
  and (select count(*) = 0 from public.auth_session_grants where challenge_id = '17200000-0000-4000-8300-000000000002')
  and (select count(*) = 1 from public.first_admin_onboarding_intents where id = '17200000-0000-4000-8100-000000000002' and handoff_session_grant_id is null and handoff_ready_at is null),
  'T017-REV-001-D exhausted same operation reconciles without fourth attempt grant or handoff'
);

set local role service_role;
select throws_ok(
  $$select * from public.verify_first_admin_onboarding_challenge('17200000-0000-4000-8100-000000000002', '17200000-0000-4000-8300-000000000002', 'exhausted@example.test', '17200000-0000-4000-8500-000000000024', false, 'v1')$$,
  'P0001',
  'Verification attempt denied.',
  'T017-REV-001-E different operation after exhaustion remains denied'
);
reset role;
select ok(
  (select attempt_count = 3 from public.verification_challenges where id = '17200000-0000-4000-8300-000000000002')
  and (select count(*) = 3 from public.verification_challenge_attempts where challenge_id = '17200000-0000-4000-8300-000000000002')
  and (select count(*) = 0 from public.auth_session_grants where challenge_id = '17200000-0000-4000-8300-000000000002'),
  'T017-REV-001-E-STATE exhausted different operation creates no fourth attempt or grant'
);

select ok(
  exists (
    select 1 from task017_rev001_material
    where label = 'consumed-same-operation'
  )
  and not exists (
    select 1 from task017_rev001_material
    where label = 'consumed-different-operation'
  )
  and exists (
    select 1 from task017_rev001_material
    where label = 'exhausted-same-operation'
  )
  and not exists (
    select 1 from task017_rev001_material
    where label = 'exhausted-different-operation'
  )
  and has_function_privilege('service_role', 'public.get_first_admin_onboarding_challenge_material(uuid,text,uuid)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.get_first_admin_onboarding_challenge_material(uuid,text,uuid)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.get_first_admin_onboarding_challenge_material(uuid,text,uuid)', 'EXECUTE')
  and not has_function_privilege('public', 'public.get_first_admin_onboarding_challenge_material(uuid,text,uuid)', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'public.get_first_admin_onboarding_challenge_material(uuid,text,uuid)', 'EXECUTE'),
  'T017-REV-001-F terminal material is same-operation-only and remains server-side'
);

reset role;

update public.verification_challenges
set
  issued_at = statement_timestamp() - interval '9 hours',
  expires_at = statement_timestamp() - interval '1 hour'
where id = '17200000-0000-4000-8300-000000000003';

set local role service_role;
select is_empty(
  $$select * from public.get_first_admin_onboarding_challenge_material('17200000-0000-4000-8100-000000000003', 'expired@example.test', '17200000-0000-4000-8500-000000000031')$$,
  'T017-EDGE-012 expired current exposes no verifier material'
);
select throws_ok(
  $$select * from public.verify_first_admin_onboarding_challenge('17200000-0000-4000-8100-000000000003', '17200000-0000-4000-8300-000000000003', 'expired@example.test', '17200000-0000-4000-8500-000000000031', true, 'v1')$$,
  'P0001',
  'Verification attempt denied.',
  'T017-EDGE-013 expired current cannot verify'
);
select throws_ok(
  $$select * from public.verify_first_admin_onboarding_challenge('17200000-0000-4000-8100-000000000002', '17200000-0000-4000-8300-000000000002', 'exhausted@example.test', '17200000-0000-4000-8500-000000000032', true, 'v1')$$,
  'P0001',
  'Verification attempt denied.',
  'T017-EDGE-014 exhausted current cannot verify'
);
reset role;

set local role authenticated;
select set_config('request.jwt.claim.sub', '98000000-0000-4000-8000-000000000001', true);
select is(
  (select outcome from public.resend_first_admin_onboarding_challenge(
    '17200000-0000-4000-8100-000000000002',
    '17200000-0000-4000-8300-000000000102',
    decode(repeat('62', 32), 'hex'),
    'v1',
    '17200000-0000-4000-8400-000000000102'
  )),
  'RESENT',
  'T017-EDGE-015 exhausted current can produce an authorized successor'
);
select is(
  (select outcome from public.resend_first_admin_onboarding_challenge(
    '17200000-0000-4000-8100-000000000003',
    '17200000-0000-4000-8300-000000000103',
    decode(repeat('63', 32), 'hex'),
    'v1',
    '17200000-0000-4000-8400-000000000103'
  )),
  'RESENT',
  'T017-EDGE-016 expired current can produce an authorized successor'
);
reset role;

select ok(
  exists (
    select 1 from public.verification_challenges
    where id = '17200000-0000-4000-8300-000000000002'
      and exhausted_at is not null
      and invalidated_at is null
  ),
  'T017-EDGE-017 exhausted predecessor stays terminal and is never reactivated'
);
select ok(
  exists (
    select 1 from public.verification_challenges
    where id = '17200000-0000-4000-8300-000000000003'
      and invalidated_at is not null
  ),
  'T017-EDGE-018 expired predecessor is invalidated by accepted successor'
);

set local role service_role;
select * from public.verify_first_admin_onboarding_challenge(
  '17200000-0000-4000-8100-000000000005',
  '17200000-0000-4000-8300-000000000005',
  'stale-pointer@example.test',
  '17200000-0000-4000-8500-000000000041',
  false,
  'v1'
);
reset role;

set local role authenticated;
select set_config('request.jwt.claim.sub', '98000000-0000-4000-8000-000000000001', true);
select * from public.resend_first_admin_onboarding_challenge(
  '17200000-0000-4000-8100-000000000005',
  '17200000-0000-4000-8300-000000000105',
  decode(repeat('65', 32), 'hex'),
  'v1',
  '17200000-0000-4000-8400-000000000105'
);
reset role;

set local role service_role;
select throws_ok(
  $$select * from public.verify_first_admin_onboarding_challenge('17200000-0000-4000-8100-000000000005', '17200000-0000-4000-8300-000000000105', 'stale-pointer@example.test', '17200000-0000-4000-8500-000000000041', false, 'v1')$$,
  'P0001',
  'Verification attempt denied.',
  'T017-EDGE-019 stale predecessor verification operation cannot rotate or consume current successor'
);
select throws_ok(
  $$select * from public.verify_first_admin_onboarding_challenge('17200000-0000-4000-8100-000000000002', '17200000-0000-4000-8300-000000000102', 'exhausted@example.test', '17200000-0000-4000-8500-000000000021', true, 'v1')$$,
  'P0001',
  'Verification attempt denied.',
  'T017-EDGE-020 verification operation from another intent cannot cross-replay'
);
reset role;

create function pg_temp.task017_reject_atomic_state()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if tg_op = 'INSERT'
    and new.id = '17200000-0000-4000-8600-000000000001'::uuid then
    raise exception using errcode = 'P0001', message = 'forced intent insert failure';
  end if;

  if tg_op = 'UPDATE'
    and new.id = '17200000-0000-4000-8100-000000000006'::uuid
    and new.current_challenge_id = '17200000-0000-4000-8300-000000000106'::uuid then
    raise exception using errcode = 'P0001', message = 'forced intent pointer failure';
  end if;

  if tg_op = 'UPDATE'
    and new.id = '17200000-0000-4000-8100-000000000007'::uuid
    and old.handoff_session_grant_id is null
    and new.handoff_session_grant_id is not null then
    raise exception using errcode = 'P0001', message = 'forced intent handoff failure';
  end if;

  return new;
end;
$$;

create trigger task017_reject_atomic_state
before insert or update on public.first_admin_onboarding_intents
for each row execute function pg_temp.task017_reject_atomic_state();

create function pg_temp.task017_catch_establish_failure()
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
begin
  begin
    perform * from public.establish_first_admin_onboarding_intent(
      '17200000-0000-4000-8600-000000000001',
      '17200000-0000-4000-8000-000000000101',
      'initial-rollback@example.test',
      '17200000-0000-4000-8600-000000000002',
      '17200000-0000-4000-8600-000000000003',
      decode(repeat('71', 32), 'hex'),
      'v1',
      '17200000-0000-4000-8600-000000000004'
    );
  exception when others then
    null;
  end;

  return not exists (
    select 1 from public.verification_challenges
    where issue_operation_id = '17200000-0000-4000-8600-000000000004'
  ) and not exists (
    select 1 from public.first_admin_onboarding_intents
    where establishment_operation_id = '17200000-0000-4000-8600-000000000002'
  );
end;
$$;

set local role authenticated;
select set_config('request.jwt.claim.sub', '98000000-0000-4000-8000-000000000001', true);
select ok(pg_temp.task017_catch_establish_failure(), 'T017-ATOMIC-001 forced intent insert failure rolls back first challenge and intent');
reset role;

create function pg_temp.task017_catch_resend_failure()
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
begin
  begin
    perform * from public.resend_first_admin_onboarding_challenge(
      '17200000-0000-4000-8100-000000000006',
      '17200000-0000-4000-8300-000000000106',
      decode(repeat('72', 32), 'hex'),
      'v1',
      '17200000-0000-4000-8400-000000000106'
    );
  exception when others then
    null;
  end;

  return not exists (
    select 1 from public.verification_challenges
    where id = '17200000-0000-4000-8300-000000000106'
  ) and exists (
    select 1 from public.verification_challenges
    where id = '17200000-0000-4000-8300-000000000006'
      and invalidated_at is null
  ) and exists (
    select 1 from public.first_admin_onboarding_intents
    where id = '17200000-0000-4000-8100-000000000006'
      and current_challenge_id = '17200000-0000-4000-8300-000000000006'
  );
end;
$$;

set local role authenticated;
select set_config('request.jwt.claim.sub', '98000000-0000-4000-8000-000000000001', true);
select ok(pg_temp.task017_catch_resend_failure(), 'T017-ATOMIC-002 forced pointer failure rolls back invalidation and successor');
reset role;

create function pg_temp.task017_catch_verify_failure()
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
begin
  begin
    perform * from public.verify_first_admin_onboarding_challenge(
      '17200000-0000-4000-8100-000000000007',
      '17200000-0000-4000-8300-000000000007',
      'verify-rollback@example.test',
      '17200000-0000-4000-8700-000000000001',
      true,
      'v1'
    );
  exception when others then
    null;
  end;

  return exists (
    select 1 from public.verification_challenges
    where id = '17200000-0000-4000-8300-000000000007'
      and consumed_at is null
      and attempt_count = 0
  ) and not exists (
    select 1 from public.verification_challenge_attempts
    where operation_id = '17200000-0000-4000-8700-000000000001'
  ) and not exists (
    select 1 from public.auth_session_grants
    where grant_operation_id = '17200000-0000-4000-8700-000000000001'
  ) and exists (
    select 1 from public.first_admin_onboarding_intents
    where id = '17200000-0000-4000-8100-000000000007'
      and handoff_session_grant_id is null
      and handoff_ready_at is null
  );
end;
$$;

set local role service_role;
select ok(pg_temp.task017_catch_verify_failure(), 'T017-ATOMIC-003 forced handoff failure rolls back attempt consume grant and handoff');
reset role;

select is(
  (select count(*)::integer from public.audit_events),
  0,
  'T017-SCOPE-005 TASK-017 issue resend verify create no AuditEvent'
);
select is(
  (select count(*)::integer from public.company_memberships),
  0,
  'T017-SCOPE-006 TASK-017 edge flows create no membership or tenant authority'
);
select ok(
  not exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name in ('first_admin_onboarding_intents', 'verification_challenges')
      and column_name in ('code', 'plaintext_code', 'candidate_code')
  ),
  'T017-SEC-001 plaintext or candidate code has no persistence column'
);
select ok(
  not has_function_privilege('authenticated', 'private.task_017_verify_verification_challenge(uuid,text,uuid,boolean,text)', 'EXECUTE')
  and not has_function_privilege('service_role', 'private.task_017_verify_verification_challenge(uuid,text,uuid,boolean,text)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'private.task_017_resend_verification_challenge(uuid,uuid,text,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('service_role', 'private.task_017_resend_verification_challenge(uuid,uuid,text,bytea,text,uuid)', 'EXECUTE'),
  'T017-SEC-002 internal TASK-013 composition helpers are not directly executable by runtime roles'
);
select ok(
  (select relrowsecurity from pg_class where oid = 'public.maintenance_companies'::regclass)
  and (select relrowsecurity from pg_class where oid = 'public.company_memberships'::regclass),
  'T017-REG-001 tenant-owned RLS remains enabled'
);

select * from finish();

rollback;
