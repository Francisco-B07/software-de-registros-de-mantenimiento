\set ON_ERROR_STOP on

begin;

select plan(65);

select is(
  (
    select count(*)::integer
    from pg_proc
    where pronamespace = 'public'::regnamespace
      and proname = 'resolve_first_admin_auth_handoff'
  ),
  1,
  'T018-A1-DB-001 exactly one resolver overload exists'
);

select is(
  pg_get_function_identity_arguments(
    'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
  ),
  'p_intent_id uuid',
  'T018-A1-DB-002 resolver has the exact one-locator signature'
);

select is(
  (
    select language.lanname
    from pg_proc as function_definition
    join pg_language as language on language.oid = function_definition.prolang
    where function_definition.oid =
      'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
  ),
  'plpgsql',
  'T018-A1-DB-003 resolver language is plpgsql'
);

select is(
  (
    select provolatile::text
    from pg_proc
    where oid = 'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
  ),
  's',
  'T018-A1-DB-004 resolver is read-only STABLE'
);

select ok(
  (
    select prosecdef
    from pg_proc
    where oid = 'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
  ),
  'T018-A1-DB-005 resolver is SECURITY DEFINER for its narrow RLS-crossing read'
);

select is(
  (
    select pg_get_userbyid(proowner)
    from pg_proc
    where oid = 'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
  ),
  'postgres',
  'T018-A1-DB-006 resolver owner is postgres'
);

select is(
  (
    select array_to_string(proconfig, ',')
    from pg_proc
    where oid = 'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
  ),
  'search_path=""',
  'T018-A1-DB-007 resolver fixes an empty search_path'
);

select is(
  pg_get_function_result(
    'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
  ),
  'TABLE(intent_id uuid, maintenance_company_id uuid, target_email text, current_challenge_id uuid, handoff_session_grant_id uuid, handoff_ready_at timestamp with time zone, challenge_consumed_at timestamp with time zone, auth_bridge_credential_id uuid, bridge_auth_user_id uuid, grant_auth_user_id uuid, grant_purpose text, grant_auth_method text, grant_created_at timestamp with time zone, grant_expires_at timestamp with time zone, grant_consumed_at timestamp with time zone, grant_revoked_at timestamp with time zone, handoff_eligibility text, identity_compatibility text)',
  'T018-A1-DB-008 resolver return shape is exact and bounded'
);

select ok(
  pg_get_functiondef(
    'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
  ) !~* '\m(insert|update|delete|merge|truncate)\M',
  'T018-A1-DB-009 resolver definition contains no data-writing statement'
);

select ok(
  pg_get_functiondef(
    'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
  ) !~* '\mexecute\M',
  'T018-A1-DB-010 resolver contains no dynamic SQL'
);

select ok(
  not has_function_privilege(
    'public',
    'public.resolve_first_admin_auth_handoff(uuid)',
    'EXECUTE'
  ),
  'T018-A1-ACL-001 PUBLIC cannot execute the resolver'
);

select ok(
  not has_function_privilege(
    'anon',
    'public.resolve_first_admin_auth_handoff(uuid)',
    'EXECUTE'
  ),
  'T018-A1-ACL-002 anon cannot execute the resolver'
);

select ok(
  not has_function_privilege(
    'authenticated',
    'public.resolve_first_admin_auth_handoff(uuid)',
    'EXECUTE'
  ),
  'T018-A1-ACL-003 authenticated cannot execute the resolver'
);

select ok(
  not has_function_privilege(
    'supabase_auth_admin',
    'public.resolve_first_admin_auth_handoff(uuid)',
    'EXECUTE'
  ),
  'T018-A1-ACL-004 supabase_auth_admin cannot execute the resolver'
);

select ok(
  has_function_privilege(
    'service_role',
    'public.resolve_first_admin_auth_handoff(uuid)',
    'EXECUTE'
  ),
  'T018-A1-ACL-005 service_role can execute the resolver'
);

select is(
  (
    select array_agg(pg_get_userbyid(privilege.grantee) order by privilege.grantee)::text
    from pg_proc as function_definition
    cross join lateral aclexplode(
      coalesce(
        function_definition.proacl,
        acldefault('f', function_definition.proowner)
      )
    ) as privilege
    where function_definition.oid =
      'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
      and privilege.privilege_type = 'EXECUTE'
      and privilege.grantee <> function_definition.proowner
  ),
  '{service_role}',
  'T018-A1-ACL-006 service_role is the only non-owner executor'
);

select ok(
  not has_table_privilege(
    'service_role',
    'public.first_admin_onboarding_intents',
    'SELECT,INSERT,UPDATE,DELETE'
  ),
  'T018-A1-ACL-007 resolver adds no direct intent table grant'
);

select ok(
  not exists (
    select 1
    from pg_policy
    where polname like 'task_018%'
  )
  and (
    select count(*)
    from pg_policy
    where polrelid in (
      'public.first_admin_onboarding_intents'::regclass,
      'public.verification_challenges'::regclass,
      'public.verification_challenge_attempts'::regclass,
      'public.auth_session_grants'::regclass,
      'public.auth_bridge_credentials'::regclass,
      'public.platform_user_auth_subjects'::regclass,
      'public.platform_users'::regclass,
      'public.company_memberships'::regclass
    )
  ) = 7,
  'T018-A1-RLS-001 no TASK-018 policy is added and prior relevant policy count is unchanged'
);

select ok(
  pg_get_function_result(
    'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
  ) !~* '(verifier|verification_code|technical_password|key_version|pending|rotation|platform_user_id|membership|membership_role|access_token|refresh_token)',
  'T018-A1-SCOPE-001 return shape excludes verifier credential password key rotation membership and token material'
);

select ok(
  pg_get_functiondef(
    'public.resolve_first_admin_auth_handoff(uuid)'::regprocedure
  ) !~* '(verification_challenges\.verifier|technical_password|key_version|pending_key_version|rotation_operation_id|rotation_started_at|rotated_at|membership\.maintenance_company_id|membership\.role|access_token|refresh_token)',
  'T018-A1-SCOPE-002 resolver does not read rejected sensitive or membership-detail columns'
);

set local role anon;
select throws_ok(
  $$select * from public.resolve_first_admin_auth_handoff('18000000-0000-4000-8000-000000000001')$$,
  '42501',
  null,
  'T018-A1-ACL-008 anon execution is denied in practice'
);
reset role;

set local role authenticated;
select throws_ok(
  $$select * from public.resolve_first_admin_auth_handoff('18000000-0000-4000-8000-000000000001')$$,
  '42501',
  null,
  'T018-A1-ACL-009 authenticated execution is denied in practice'
);
reset role;

create temporary table task018_clock (
  valid_created_at timestamptz not null,
  expired_created_at timestamptz not null
);

insert into task018_clock
values (
  statement_timestamp() - interval '1 minute',
  statement_timestamp() - interval '10 minutes'
);

grant select on task018_clock to service_role;

insert into auth.users (id, email)
values
  ('18000000-0000-4000-8000-000000000001', 'unmapped@example.test'),
  ('18000000-0000-4000-8000-000000000002', 'compatible@example.test'),
  ('18000000-0000-4000-8000-000000000003', 'super@example.test'),
  ('18000000-0000-4000-8000-000000000004', 'enabled@example.test'),
  ('18000000-0000-4000-8000-000000000005', 'disabled@example.test'),
  ('18000000-0000-4000-8000-000000000006', 'foreign@example.test'),
  ('18000000-0000-4000-8000-000000000007', 'mismatch@example.test');

insert into public.maintenance_companies (id)
values
  ('18000000-0000-4000-8000-000000000100'),
  ('18000000-0000-4000-8000-000000000101');

insert into public.platform_users (id, is_super_admin)
values
  ('18000000-0000-4000-8000-000000000900', true),
  ('18000000-0000-4000-8000-000000000902', false),
  ('18000000-0000-4000-8000-000000000903', true),
  ('18000000-0000-4000-8000-000000000904', false),
  ('18000000-0000-4000-8000-000000000905', false),
  ('18000000-0000-4000-8000-000000000906', false);

insert into public.platform_user_auth_subjects (
  auth_subject_id,
  platform_user_id
)
values
  ('18000000-0000-4000-8000-000000000002', '18000000-0000-4000-8000-000000000902'),
  ('18000000-0000-4000-8000-000000000003', '18000000-0000-4000-8000-000000000903'),
  ('18000000-0000-4000-8000-000000000004', '18000000-0000-4000-8000-000000000904'),
  ('18000000-0000-4000-8000-000000000005', '18000000-0000-4000-8000-000000000905'),
  ('18000000-0000-4000-8000-000000000006', '18000000-0000-4000-8000-000000000906');

insert into public.company_memberships (
  id,
  platform_user_id,
  maintenance_company_id,
  role,
  is_enabled
)
values
  ('18000000-0000-4000-8000-000000001004', '18000000-0000-4000-8000-000000000904', '18000000-0000-4000-8000-000000000100', 'COMPANY_ADMIN', true),
  ('18000000-0000-4000-8000-000000001005', '18000000-0000-4000-8000-000000000905', '18000000-0000-4000-8000-000000000100', 'TECHNICIAN', false),
  ('18000000-0000-4000-8000-000000001006', '18000000-0000-4000-8000-000000000906', '18000000-0000-4000-8000-000000000101', 'COMPANY_ADMIN', true);

insert into public.verification_challenges (
  id,
  email,
  verifier,
  verifier_key_version,
  issued_at,
  expires_at,
  attempt_count,
  consumed_at,
  issue_operation_id
)
select
  '18000000-0000-4000-8000-000000000200',
  'first-admin@example.test',
  decode(repeat('18', 32), 'hex'),
  'v1',
  valid_created_at - interval '1 minute',
  valid_created_at + interval '7 hours 59 minutes',
  1,
  valid_created_at,
  '18000000-0000-4000-8000-000000000210'
from task018_clock;

insert into public.verification_challenge_attempts (
  id,
  challenge_id,
  operation_id,
  attempt_number,
  matched,
  created_at
)
select
  '18000000-0000-4000-8000-000000000300',
  '18000000-0000-4000-8000-000000000200',
  '18000000-0000-4000-8000-000000000310',
  1,
  true,
  valid_created_at
from task018_clock;

insert into public.auth_bridge_credentials (
  id,
  email,
  technical_password_key_version
)
values (
  '18000000-0000-4000-8000-000000000400',
  'first-admin@example.test',
  'v1'
);

insert into public.auth_session_grants (
  id,
  challenge_id,
  auth_bridge_credential_id,
  created_at,
  expires_at,
  grant_operation_id
)
select
  '18000000-0000-4000-8000-000000000500',
  '18000000-0000-4000-8000-000000000200',
  '18000000-0000-4000-8000-000000000400',
  valid_created_at,
  valid_created_at + interval '5 minutes',
  '18000000-0000-4000-8000-000000000310'
from task018_clock;

insert into public.first_admin_onboarding_intents (
  id,
  maintenance_company_id,
  target_email,
  initiated_by_platform_user_id,
  establishment_operation_id,
  current_challenge_id,
  handoff_session_grant_id,
  handoff_ready_at
)
select
  '18000000-0000-4000-8000-000000000600',
  '18000000-0000-4000-8000-000000000100',
  'first-admin@example.test',
  '18000000-0000-4000-8000-000000000900',
  '18000000-0000-4000-8000-000000000610',
  '18000000-0000-4000-8000-000000000200',
  '18000000-0000-4000-8000-000000000500',
  valid_created_at
from task018_clock;

set local role service_role;

select lives_ok(
  $$select * from public.resolve_first_admin_auth_handoff('18000000-0000-4000-8000-000000000600')$$,
  'T018-A1-RESOLVE-001 service_role can execute the exact resolver'
);

select is(
  (
    select count(*)::integer
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  1,
  'T018-A1-RESOLVE-002 resolver always returns one bounded result'
);

select ok(
  (
    select
      intent_id = '18000000-0000-4000-8000-000000000600'
      and maintenance_company_id = '18000000-0000-4000-8000-000000000100'
      and target_email = 'first-admin@example.test'
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'T018-A1-RESOLVE-003 valid handoff resolves authoritative intent tenant and email'
);

select ok(
  (
    select
      current_challenge_id = '18000000-0000-4000-8000-000000000200'
      and handoff_session_grant_id = '18000000-0000-4000-8000-000000000500'
      and auth_bridge_credential_id = '18000000-0000-4000-8000-000000000400'
      and challenge_consumed_at = handoff_ready_at
      and grant_created_at = handoff_ready_at
      and grant_expires_at = grant_created_at + interval '5 minutes'
      and grant_purpose = 'initial_session'
      and grant_auth_method = 'password'
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'T018-A1-RESOLVE-004 valid handoff resolves exact current challenge grant bridge and timing correlations'
);

select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'ELIGIBLE',
  'T018-A1-RESOLVE-005 live unconsumed unrevoked grant is eligible'
);

select is(
  (
    select identity_compatibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'NO_APPLICATION_IDENTITY',
  'T018-A1-ID-001 unbound bridge has no application identity'
);

select is(
  (
    select handoff_eligibility || ':' || identity_compatibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000009999'
    )
  ),
  'FAIL_CLOSED:FAIL_CLOSED',
  'T018-A1-FAIL-001 missing intent fails closed'
);

select is(
  (
    select handoff_eligibility || ':' || identity_compatibility
    from public.resolve_first_admin_auth_handoff(null)
  ),
  'FAIL_CLOSED:FAIL_CLOSED',
  'T018-A1-FAIL-002 null locator fails closed'
);

select ok(
  (
    select
      intent_id is null
      and maintenance_company_id is null
      and target_email is null
      and current_challenge_id is null
      and handoff_session_grant_id is null
      and auth_bridge_credential_id is null
      and bridge_auth_user_id is null
      and grant_auth_user_id is null
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000009999'
    )
  ),
  'T018-A1-FAIL-003 fail-closed result masks authoritative and subject fields'
);

reset role;

update public.first_admin_onboarding_intents
set handoff_session_grant_id = null, handoff_ready_at = null
where id = '18000000-0000-4000-8000-000000000600';

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED',
  'T018-A1-FAIL-004 handoff not ready fails closed'
);
reset role;

update public.first_admin_onboarding_intents
set
  handoff_session_grant_id = '18000000-0000-4000-8000-000000000500',
  handoff_ready_at = (select valid_created_at from task018_clock)
where id = '18000000-0000-4000-8000-000000000600';

set local session_replication_role = replica;
update public.first_admin_onboarding_intents
set handoff_session_grant_id = '18000000-0000-4000-8000-000000009999'
where id = '18000000-0000-4000-8000-000000000600';
set local session_replication_role = origin;

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED',
  'T018-A1-FAIL-005 missing handoff grant fails closed'
);
reset role;

set local session_replication_role = replica;
update public.first_admin_onboarding_intents
set handoff_session_grant_id = '18000000-0000-4000-8000-000000000500'
where id = '18000000-0000-4000-8000-000000000600';
set local session_replication_role = origin;

insert into public.verification_challenges (
  id,
  email,
  verifier,
  verifier_key_version,
  issued_at,
  expires_at,
  supersedes_challenge_id,
  issue_operation_id
)
select
  '18000000-0000-4000-8000-000000000201',
  'first-admin@example.test',
  decode(repeat('19', 32), 'hex'),
  'v1',
  valid_created_at,
  valid_created_at + interval '8 hours',
  '18000000-0000-4000-8000-000000000200',
  '18000000-0000-4000-8000-000000000211'
from task018_clock;

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED',
  'T018-A1-FAIL-006 stale current-challenge pointer with a successor fails closed'
);
reset role;

delete from public.verification_challenges
where id = '18000000-0000-4000-8000-000000000201';

update public.verification_challenges
set consumed_at = null
where id = '18000000-0000-4000-8000-000000000200';

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED',
  'T018-A1-FAIL-007 challenge outside required consumed current state fails closed'
);
reset role;

update public.verification_challenges
set consumed_at = (select valid_created_at from task018_clock)
where id = '18000000-0000-4000-8000-000000000200';

set local session_replication_role = replica;
update public.auth_session_grants
set challenge_id = '18000000-0000-4000-8000-000000009998'
where id = '18000000-0000-4000-8000-000000000500';
set local session_replication_role = origin;

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED',
  'T018-A1-FAIL-008 grant challenge mismatch fails closed'
);
reset role;

set local session_replication_role = replica;
update public.auth_session_grants
set challenge_id = '18000000-0000-4000-8000-000000000200'
where id = '18000000-0000-4000-8000-000000000500';
set local session_replication_role = origin;

update public.auth_session_grants
set grant_operation_id = '18000000-0000-4000-8000-000000009997'
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED',
  'T018-A1-FAIL-009 grant without its exact matched attempt fails closed'
);
reset role;

update public.auth_session_grants
set grant_operation_id = '18000000-0000-4000-8000-000000000310'
where id = '18000000-0000-4000-8000-000000000500';

set local session_replication_role = replica;
update public.auth_session_grants
set auth_bridge_credential_id = '18000000-0000-4000-8000-000000009996'
where id = '18000000-0000-4000-8000-000000000500';
set local session_replication_role = origin;

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED',
  'T018-A1-FAIL-010 missing or mismatched bridge correlation fails closed'
);
reset role;

set local session_replication_role = replica;
update public.auth_session_grants
set auth_bridge_credential_id = '18000000-0000-4000-8000-000000000400'
where id = '18000000-0000-4000-8000-000000000500';
set local session_replication_role = origin;

update public.auth_bridge_credentials
set email = 'wrong-first-admin@example.test'
where id = '18000000-0000-4000-8000-000000000400';

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED',
  'T018-A1-FAIL-011 bridge and authoritative intent email mismatch fails closed'
);
reset role;

update public.auth_bridge_credentials
set email = 'first-admin@example.test'
where id = '18000000-0000-4000-8000-000000000400';

alter table public.auth_session_grants
drop constraint auth_session_grants_purpose_check;

update public.auth_session_grants
set purpose = 'other_purpose'
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED',
  'T018-A1-FAIL-012 wrong grant purpose fails closed'
);
reset role;

update public.auth_session_grants
set purpose = 'initial_session'
where id = '18000000-0000-4000-8000-000000000500';

alter table public.auth_session_grants
drop constraint auth_session_grants_auth_method_check;

update public.auth_session_grants
set auth_method = 'other_method'
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED',
  'T018-A1-FAIL-013 wrong grant auth_method fails closed'
);
reset role;

update public.auth_session_grants
set auth_method = 'password'
where id = '18000000-0000-4000-8000-000000000500';

update public.verification_challenges
set consumed_at = (select expired_created_at from task018_clock)
where id = '18000000-0000-4000-8000-000000000200';

update public.verification_challenge_attempts
set created_at = (select expired_created_at from task018_clock)
where id = '18000000-0000-4000-8000-000000000300';

update public.auth_session_grants
set
  created_at = (select expired_created_at from task018_clock),
  expires_at = (select expired_created_at + interval '5 minutes' from task018_clock)
where id = '18000000-0000-4000-8000-000000000500';

update public.first_admin_onboarding_intents
set handoff_ready_at = (select expired_created_at from task018_clock)
where id = '18000000-0000-4000-8000-000000000600';

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'GRANT_EXPIRED',
  'T018-A1-GRANT-001 expired grant is classified and is not eligible'
);
reset role;

update public.verification_challenges
set consumed_at = (select valid_created_at from task018_clock)
where id = '18000000-0000-4000-8000-000000000200';

update public.verification_challenge_attempts
set created_at = (select valid_created_at from task018_clock)
where id = '18000000-0000-4000-8000-000000000300';

update public.auth_session_grants
set
  created_at = (select valid_created_at from task018_clock),
  expires_at = (select valid_created_at + interval '5 minutes' from task018_clock)
where id = '18000000-0000-4000-8000-000000000500';

update public.first_admin_onboarding_intents
set handoff_ready_at = (select valid_created_at from task018_clock)
where id = '18000000-0000-4000-8000-000000000600';

update public.auth_session_grants
set revoked_at = (select valid_created_at + interval '10 seconds' from task018_clock)
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'GRANT_REVOKED',
  'T018-A1-GRANT-002 revoked grant is classified and is not eligible'
);
reset role;

update public.auth_session_grants
set revoked_at = null
where id = '18000000-0000-4000-8000-000000000500';

update public.auth_session_grants
set consumed_at = (select valid_created_at + interval '10 seconds' from task018_clock)
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'GRANT_CONSUMED',
  'T018-A1-GRANT-003 consumed grant is classified consumed'
);

select is(
  (
    select grant_consumed_at
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  (select valid_created_at + interval '10 seconds' from task018_clock),
  'T018-A1-GRANT-004 resolver leaves the consumed timestamp observable and unchanged'
);
reset role;

update public.auth_session_grants
set consumed_at = null
where id = '18000000-0000-4000-8000-000000000500';

update public.auth_bridge_credentials
set
  auth_user_id = '18000000-0000-4000-8000-000000000002',
  bound_at = (select valid_created_at from task018_clock)
where id = '18000000-0000-4000-8000-000000000400';

update public.auth_session_grants
set auth_user_id = '18000000-0000-4000-8000-000000000007'
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select handoff_eligibility || ':' || identity_compatibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED:FAIL_CLOSED',
  'T018-A1-FAIL-014 bridge-bound and grant-bound subject mismatch fails closed'
);
reset role;

update public.auth_bridge_credentials
set auth_user_id = '18000000-0000-4000-8000-000000000001'
where id = '18000000-0000-4000-8000-000000000400';

update public.auth_session_grants
set auth_user_id = '18000000-0000-4000-8000-000000000001'
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select identity_compatibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'NO_APPLICATION_IDENTITY',
  'T018-A1-ID-002 bound Auth subject without mapping has no application identity'
);
reset role;

update public.auth_bridge_credentials
set auth_user_id = '18000000-0000-4000-8000-000000000003'
where id = '18000000-0000-4000-8000-000000000400';
update public.auth_session_grants
set auth_user_id = '18000000-0000-4000-8000-000000000003'
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select identity_compatibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'INCOMPATIBLE_IDENTITY',
  'T018-A1-ID-003 current SUPER_ADMIN is incompatible'
);
reset role;

update public.auth_bridge_credentials
set auth_user_id = '18000000-0000-4000-8000-000000000004'
where id = '18000000-0000-4000-8000-000000000400';
update public.auth_session_grants
set auth_user_id = '18000000-0000-4000-8000-000000000004'
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select identity_compatibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'INCOMPATIBLE_IDENTITY',
  'T018-A1-ID-004 enabled target-tenant membership is incompatible'
);
reset role;

update public.auth_bridge_credentials
set auth_user_id = '18000000-0000-4000-8000-000000000005'
where id = '18000000-0000-4000-8000-000000000400';
update public.auth_session_grants
set auth_user_id = '18000000-0000-4000-8000-000000000005'
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select identity_compatibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'INCOMPATIBLE_IDENTITY',
  'T018-A1-ID-005 disabled target-tenant membership is incompatible'
);
reset role;

update public.auth_bridge_credentials
set auth_user_id = '18000000-0000-4000-8000-000000000006'
where id = '18000000-0000-4000-8000-000000000400';
update public.auth_session_grants
set auth_user_id = '18000000-0000-4000-8000-000000000006'
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select identity_compatibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'INCOMPATIBLE_IDENTITY',
  'T018-A1-ID-006 foreign-tenant membership is incompatible'
);
reset role;

update public.auth_bridge_credentials
set auth_user_id = '18000000-0000-4000-8000-000000000002'
where id = '18000000-0000-4000-8000-000000000400';
update public.auth_session_grants
set auth_user_id = '18000000-0000-4000-8000-000000000002'
where id = '18000000-0000-4000-8000-000000000500';

set local role service_role;
select is(
  (
    select identity_compatibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'COMPATIBLE_EXISTING_APPLICATION_IDENTITY',
  'T018-A1-ID-007 mapped non-SUPER_ADMIN with zero memberships is compatible'
);
reset role;

update public.first_admin_onboarding_intents
set handoff_ready_at = (select valid_created_at + interval '1 second' from task018_clock)
where id = '18000000-0000-4000-8000-000000000600';

set local role service_role;
select is(
  (
    select handoff_eligibility
    from public.resolve_first_admin_auth_handoff(
      '18000000-0000-4000-8000-000000000600'
    )
  ),
  'FAIL_CLOSED',
  'T018-A1-FAIL-015 impossible handoff-ready and grant-created correlation fails closed'
);
reset role;

update public.first_admin_onboarding_intents
set handoff_ready_at = (select valid_created_at from task018_clock)
where id = '18000000-0000-4000-8000-000000000600';

create temporary table task018_state_snapshot (
  relation_name text primary key,
  relation_digest text not null
);

insert into task018_state_snapshot (relation_name, relation_digest)
values
  (
    'first_admin_onboarding_intents',
    (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.first_admin_onboarding_intents as row_data)
  ),
  (
    'verification_challenges',
    (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.verification_challenges as row_data)
  ),
  (
    'verification_challenge_attempts',
    (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.verification_challenge_attempts as row_data)
  ),
  (
    'auth_session_grants',
    (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.auth_session_grants as row_data)
  ),
  (
    'auth_bridge_credentials',
    (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.auth_bridge_credentials as row_data)
  ),
  (
    'platform_user_auth_subjects',
    (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.auth_subject_id::text), '')) from public.platform_user_auth_subjects as row_data)
  ),
  (
    'platform_users',
    (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.platform_users as row_data)
  ),
  (
    'company_memberships',
    (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.company_memberships as row_data)
  ),
  (
    'maintenance_companies',
    (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.maintenance_companies as row_data)
  ),
  (
    'audit_events',
    (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.audit_events as row_data)
  ),
  (
    'auth_users',
    (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from auth.users as row_data)
  );

set local role service_role;
select lives_ok(
  $$select * from public.resolve_first_admin_auth_handoff('18000000-0000-4000-8000-000000000600')$$,
  'T018-A1-READ-001 final valid resolver execution succeeds observationally'
);
reset role;

select is(
  (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.first_admin_onboarding_intents as row_data),
  (select relation_digest from task018_state_snapshot where relation_name = 'first_admin_onboarding_intents'),
  'T018-A1-READ-002 resolver does not mutate FirstAdminOnboardingIntent'
);

select is(
  (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.verification_challenges as row_data),
  (select relation_digest from task018_state_snapshot where relation_name = 'verification_challenges'),
  'T018-A1-READ-003 resolver does not mutate VerificationChallenge'
);

select is(
  (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.verification_challenge_attempts as row_data),
  (select relation_digest from task018_state_snapshot where relation_name = 'verification_challenge_attempts'),
  'T018-A1-READ-004 resolver does not mutate VerificationChallengeAttempt'
);

select is(
  (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.auth_session_grants as row_data),
  (select relation_digest from task018_state_snapshot where relation_name = 'auth_session_grants'),
  'T018-A1-READ-005 resolver does not consume reactivate or otherwise mutate SessionGrant'
);

select is(
  (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.auth_bridge_credentials as row_data),
  (select relation_digest from task018_state_snapshot where relation_name = 'auth_bridge_credentials'),
  'T018-A1-READ-006 resolver does not mutate AuthBridgeCredential'
);

select is(
  (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.auth_subject_id::text), '')) from public.platform_user_auth_subjects as row_data),
  (select relation_digest from task018_state_snapshot where relation_name = 'platform_user_auth_subjects'),
  'T018-A1-READ-007 resolver does not mutate Auth subject mapping'
);

select is(
  (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.platform_users as row_data),
  (select relation_digest from task018_state_snapshot where relation_name = 'platform_users'),
  'T018-A1-READ-008 resolver does not mutate PlatformUser'
);

select is(
  (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.company_memberships as row_data),
  (select relation_digest from task018_state_snapshot where relation_name = 'company_memberships'),
  'T018-A1-READ-009 resolver does not mutate CompanyMembership'
);

select is(
  (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.maintenance_companies as row_data),
  (select relation_digest from task018_state_snapshot where relation_name = 'maintenance_companies'),
  'T018-A1-READ-010 resolver does not mutate MaintenanceCompany'
);

select is(
  (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from public.audit_events as row_data),
  (select relation_digest from task018_state_snapshot where relation_name = 'audit_events'),
  'T018-A1-READ-011 resolver produces no AuditEvent'
);

select is(
  (select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), '')) from auth.users as row_data),
  (select relation_digest from task018_state_snapshot where relation_name = 'auth_users'),
  'T018-A1-READ-012 resolver performs no Auth provider mutation'
);

select * from finish();

rollback;
