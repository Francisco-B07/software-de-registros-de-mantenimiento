\set ON_ERROR_STOP on

begin;

select no_plan();

select is(
  (
    select string_agg(column_name || ':' || data_type || ':' || is_nullable, ',' order by ordinal_position)
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'platform_users'
      and column_name in ('first_name', 'last_name', 'profile_completed_at')
  ),
  'first_name:text:YES,last_name:text:YES,profile_completed_at:timestamp with time zone:YES',
  'T019-A-SCHEMA-001 PlatformUser profile columns have exact names, types, and nullability'
);

select is(
  (
    select string_agg(column_name || ':' || data_type || ':' || is_nullable, ',' order by ordinal_position)
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'first_admin_onboarding_intents'
      and column_name in (
        'completion_operation_id',
        'completed_platform_user_id',
        'completed_company_membership_id',
        'completed_at'
      )
  ),
  'completion_operation_id:uuid:YES,completed_platform_user_id:uuid:YES,completed_company_membership_id:uuid:YES,completed_at:timestamp with time zone:YES',
  'T019-A-SCHEMA-002 intent completion columns have exact names, types, and nullability'
);

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.platform_users'::regclass
      and conname = 'platform_users_profile_completion_state_check'
      and contype = 'c'
  ),
  'T019-A-SCHEMA-003 profile coupled-state check exists'
);

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and conname = 'first_admin_onboarding_intents_completion_state_check'
      and contype = 'c'
  ),
  'T019-A-SCHEMA-004 intent terminal coupled-state check exists'
);

select is(
  (
    select confdeltype::text
    from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and conname = 'first_admin_onboarding_intents_completed_platform_user_id_fkey'
  ),
  'r',
  'T019-A-SCHEMA-005 completed PlatformUser FK uses ON DELETE RESTRICT'
);

select is(
  (
    select confdeltype::text
    from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and conname = 'first_admin_onboarding_intents_completed_company_membership_id_fkey'
  ),
  'r',
  'T019-A-SCHEMA-006 completed membership FK uses ON DELETE RESTRICT'
);

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and conname = 'first_admin_onboarding_intents_completion_operation_id_key'
      and contype = 'u'
  ),
  'T019-A-SCHEMA-007 completion operation is unique'
);

select ok(
  (
    select relrowsecurity
    from pg_class
    where oid = 'public.platform_users'::regclass
  )
  and (
    select relrowsecurity
    from pg_class
    where oid = 'public.first_admin_onboarding_intents'::regclass
  ),
  'T019-A-RLS-001 RLS remains enabled on both extended tables'
);

select is(
  (
    select count(*)::integer
    from pg_policy
    where polname like 'task_019%'
  ),
  0,
  'T019-A-RLS-002 no TASK-019 ordinary table policy is introduced'
);

select is(
  (
    select count(*)::integer
    from pg_policy
    where polrelid in (
      'public.platform_users'::regclass,
      'public.platform_user_auth_subjects'::regclass,
      'public.company_memberships'::regclass,
      'public.maintenance_companies'::regclass,
      'public.audit_events'::regclass,
      'public.first_admin_onboarding_intents'::regclass,
      'public.auth_session_grants'::regclass,
      'public.auth_bridge_credentials'::regclass
    )
  ),
  8,
  'T019-A-RLS-003 relevant ordinary policy count is unchanged'
);

select ok(
  not has_table_privilege('authenticated', 'public.platform_users', 'INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.platform_user_auth_subjects', 'INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.company_memberships', 'INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.audit_events', 'INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.first_admin_onboarding_intents', 'INSERT,UPDATE,DELETE'),
  'T019-A-ACL-001 authenticated receives no generic table writer'
);

select is(
  (
    select count(*)::integer
    from pg_proc
    where pronamespace in ('public'::regnamespace, 'private'::regnamespace)
      and proname in (
        'complete_first_admin_onboarding',
        'resolve_current_first_admin_onboarding_state'
      )
  ),
  4,
  'T019-A-FUNC-001 exactly four TASK-019 functions exist'
);

select is(
  pg_get_function_identity_arguments(
    'public.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ),
  'p_first_name text, p_last_name text, p_operation_id uuid',
  'T019-A-FUNC-002 public completion signature is exact'
);

select is(
  pg_get_function_identity_arguments(
    'private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ),
  'p_first_name text, p_last_name text, p_operation_id uuid',
  'T019-A-FUNC-003 private completion signature is exact'
);

select is(
  pg_get_function_result(
    'public.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ),
  'TABLE(outcome text, reason text, platform_user_id uuid, company_membership_id uuid, completed_at timestamp with time zone)',
  'T019-A-FUNC-004 completion return shape is exact'
);

select is(
  pg_get_function_result(
    'public.resolve_current_first_admin_onboarding_state()'::regprocedure
  ),
  'TABLE(state text, completed_at timestamp with time zone)',
  'T019-A-FUNC-005 resolver return shape is exact'
);

select is(
  (
    select string_agg(
      n.nspname || '.' || p.proname || ':' || l.lanname || ':' || p.provolatile::text || ':' || p.prosecdef::text,
      ',' order by n.nspname, p.proname
    )
    from pg_proc as p
    join pg_namespace as n on n.oid = p.pronamespace
    join pg_language as l on l.oid = p.prolang
    where p.oid in (
      'public.complete_first_admin_onboarding(text,text,uuid)'::regprocedure,
      'private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure,
      'public.resolve_current_first_admin_onboarding_state()'::regprocedure,
      'private.resolve_current_first_admin_onboarding_state()'::regprocedure
    )
  ),
  'private.complete_first_admin_onboarding:plpgsql:v:true,private.resolve_current_first_admin_onboarding_state:plpgsql:s:true,public.complete_first_admin_onboarding:sql:v:false,public.resolve_current_first_admin_onboarding_state:sql:s:false',
  'T019-A-FUNC-006 language volatility and security modes are exact'
);

select ok(
  not exists (
    select 1
    from pg_proc
    where oid in (
      'public.complete_first_admin_onboarding(text,text,uuid)'::regprocedure,
      'private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure,
      'public.resolve_current_first_admin_onboarding_state()'::regprocedure,
      'private.resolve_current_first_admin_onboarding_state()'::regprocedure
    )
      and (
        pg_get_userbyid(proowner) <> 'postgres'
        or array_to_string(proconfig, ',') <> 'search_path=""'
      )
  ),
  'T019-A-FUNC-007 all functions are postgres-owned with empty search_path'
);

select ok(
  pg_get_functiondef(
    'public.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ) ilike '%private.complete_first_admin_onboarding%'
  and pg_get_functiondef(
    'public.resolve_current_first_admin_onboarding_state()'::regprocedure
  ) ilike '%private.resolve_current_first_admin_onboarding_state%'
  and pg_get_functiondef(
    'public.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ) !~* '\m(insert|update|delete|merge|truncate)\M',
  'T019-A-FUNC-008 public wrappers only delegate to private implementations'
);

select ok(
  pg_get_functiondef(
    'private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ) !~* '\mexecute\M'
  and pg_get_functiondef(
    'private.resolve_current_first_admin_onboarding_state()'::regprocedure
  ) !~* '\mexecute\M',
  'T019-A-FUNC-009 private functions contain no dynamic SQL'
);

select ok(
  strpos(
    pg_get_functiondef('private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure),
    E'from public.platform_users as actor\n  where actor.id = v_initiated_by_platform_user_id\n  for key share'
  ) > 0
  and strpos(
    pg_get_functiondef('private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure),
    E'from public.platform_users as actor\n  where actor.id = v_initiated_by_platform_user_id\n  for key share'
  ) < strpos(
    pg_get_functiondef('private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure),
    'from public.maintenance_companies as company'
  )
  and strpos(
    pg_get_functiondef('private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure),
    'from public.maintenance_companies as company'
  ) < strpos(
    pg_get_functiondef('private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure),
    E'select intent.*\n  into strict v_intent'
  )
  and pg_get_functiondef(
    'private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ) ilike '%v_auth_subject_id := auth.uid()%'
  and pg_get_functiondef(
    'private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ) ilike '%for update%',
  'T019-A-LOCK-001 historical actor key-share precedes company and intent locks and post-lock auth re-read is physical'
);

select ok(
  strpos(
    function_source.definition,
    E'from public.platform_users as actor\n  where actor.id = v_initiated_by_platform_user_id\n  for key share'
  ) < strpos(
    function_source.definition,
    'from public.maintenance_companies as company'
  )
  and strpos(
    function_source.definition,
    'from public.maintenance_companies as company'
  ) < strpos(
    function_source.definition,
    E'select intent.*\n  into strict v_intent'
  )
  and strpos(
    function_source.definition,
    E'select intent.*\n  into strict v_intent'
  ) < strpos(
    function_source.definition,
    E'from public.platform_user_auth_subjects as auth_subject\n  join public.platform_users as platform_user\n    on platform_user.id = auth_subject.platform_user_id\n  where auth_subject.auth_subject_id = v_auth_subject_id\n  for update of auth_subject, platform_user'
  )
  and strpos(
    function_source.definition,
    E'from public.platform_user_auth_subjects as auth_subject\n  join public.platform_users as platform_user\n    on platform_user.id = auth_subject.platform_user_id\n  where auth_subject.auth_subject_id = v_auth_subject_id\n  for update of auth_subject, platform_user'
  ) < strpos(
    function_source.definition,
    E'from public.company_memberships as membership\n  where membership.maintenance_company_id = v_intent.maintenance_company_id\n  for update'
  ),
  'T019-A-LOCK-002 actor company intent identity and membership locks have canonical relative order'
)
from (
  select pg_get_functiondef(
    'private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ) as definition
) as function_source;

select ok(
  function_source.definition ilike '%intent.initiated_by_platform_user_id <> v_initiated_by_platform_user_id%'
  and function_source.definition ilike '%intent.initiated_by_platform_user_id = v_initiated_by_platform_user_id%'
  and strpos(
    function_source.definition,
    E'from public.platform_users as actor\n  where actor.id = v_initiated_by_platform_user_id\n  for key share'
  ) < strpos(
    function_source.definition,
    'from public.maintenance_companies as company'
  ),
  'T019-A-LOCK-003 provisional actor correlation is locked and revalidated without company-to-actor inversion'
)
from (
  select pg_get_functiondef(
    'private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ) as definition
) as function_source;

select ok(
  has_schema_privilege('authenticated', 'private', 'USAGE')
  and not has_schema_privilege('anon', 'private', 'USAGE')
  and not has_schema_privilege('service_role', 'private', 'USAGE')
  and not has_schema_privilege('supabase_auth_admin', 'private', 'USAGE'),
  'T019-A-ACL-002 private schema exposure matches CORR-021'
);

select ok(
  has_function_privilege('authenticated', 'public.complete_first_admin_onboarding(text,text,uuid)', 'EXECUTE')
  and has_function_privilege('authenticated', 'private.complete_first_admin_onboarding(text,text,uuid)', 'EXECUTE')
  and has_function_privilege('authenticated', 'public.resolve_current_first_admin_onboarding_state()', 'EXECUTE')
  and has_function_privilege('authenticated', 'private.resolve_current_first_admin_onboarding_state()', 'EXECUTE'),
  'T019-A-ACL-003 authenticated can execute the exact wrapper/private chains'
);

select ok(
  not has_function_privilege('public', 'public.complete_first_admin_onboarding(text,text,uuid)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.complete_first_admin_onboarding(text,text,uuid)', 'EXECUTE')
  and not has_function_privilege('service_role', 'public.complete_first_admin_onboarding(text,text,uuid)', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'public.complete_first_admin_onboarding(text,text,uuid)', 'EXECUTE')
  and not has_function_privilege('public', 'public.resolve_current_first_admin_onboarding_state()', 'EXECUTE')
  and not has_function_privilege('anon', 'public.resolve_current_first_admin_onboarding_state()', 'EXECUTE')
  and not has_function_privilege('service_role', 'public.resolve_current_first_admin_onboarding_state()', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'public.resolve_current_first_admin_onboarding_state()', 'EXECUTE'),
  'T019-A-ACL-004 public anon service_role and auth admin cannot execute public APIs'
);

select ok(
  not has_function_privilege('public', 'private.complete_first_admin_onboarding(text,text,uuid)', 'EXECUTE')
  and not has_function_privilege('anon', 'private.complete_first_admin_onboarding(text,text,uuid)', 'EXECUTE')
  and not has_function_privilege('service_role', 'private.complete_first_admin_onboarding(text,text,uuid)', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'private.complete_first_admin_onboarding(text,text,uuid)', 'EXECUTE')
  and not has_function_privilege('public', 'private.resolve_current_first_admin_onboarding_state()', 'EXECUTE')
  and not has_function_privilege('anon', 'private.resolve_current_first_admin_onboarding_state()', 'EXECUTE')
  and not has_function_privilege('service_role', 'private.resolve_current_first_admin_onboarding_state()', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'private.resolve_current_first_admin_onboarding_state()', 'EXECUTE'),
  'T019-A-ACL-005 rejected roles cannot execute private implementations'
);

set local role anon;
select throws_ok(
  $$select * from public.complete_first_admin_onboarding('A', 'B', '19000000-0000-4000-8000-000000000701')$$,
  '42501',
  null,
  'T019-A-AUTH-001 anon completion execution is denied'
);
reset role;

insert into auth.users (id, email)
values
  ('19000000-0000-4000-8000-000000000001', 'new@example.test'),
  ('19000000-0000-4000-8000-000000000002', 'compatible@example.test'),
  ('19000000-0000-4000-8000-000000000003', 'super@example.test'),
  ('19000000-0000-4000-8000-000000000004', 'member@example.test'),
  ('19000000-0000-4000-8000-000000000005', 'completed@example.test'),
  ('19000000-0000-4000-8000-000000000006', 'revoked@example.test'),
  ('19000000-0000-4000-8000-000000000007', 'unconsumed@example.test'),
  ('19000000-0000-4000-8000-000000000008', 'rollback@example.test'),
  ('19000000-0000-4000-8000-000000000009', 'broken@example.test'),
  ('19000000-0000-4000-8000-000000000010', 'bridge-other@example.test'),
  ('19000000-0000-4000-8000-000000000011', 'unrelated@example.test'),
  ('19000000-0000-4000-8000-000000000012', 'ambiguous@example.test'),
  ('19000000-0000-4000-8000-000000000013', 'tenant-conflict@example.test');

insert into public.maintenance_companies (id)
values
  ('19000000-0000-4000-8000-000000000100'),
  ('19000000-0000-4000-8000-000000000101'),
  ('19000000-0000-4000-8000-000000000102'),
  ('19000000-0000-4000-8000-000000000103'),
  ('19000000-0000-4000-8000-000000000104'),
  ('19000000-0000-4000-8000-000000000105'),
  ('19000000-0000-4000-8000-000000000106'),
  ('19000000-0000-4000-8000-000000000107'),
  ('19000000-0000-4000-8000-000000000108'),
  ('19000000-0000-4000-8000-000000000109'),
  ('19000000-0000-4000-8000-000000000110'),
  ('19000000-0000-4000-8000-000000000111');

insert into public.platform_users (
  id,
  is_super_admin,
  first_name,
  last_name,
  profile_completed_at
)
values
  ('19000000-0000-4000-8000-000000000900', true, null, null, null),
  ('19000000-0000-4000-8000-000000000902', false, null, null, null),
  ('19000000-0000-4000-8000-000000000903', true, null, null, null),
  ('19000000-0000-4000-8000-000000000904', false, null, null, null),
  ('19000000-0000-4000-8000-000000000905', false, 'Already', 'Complete', statement_timestamp()),
  ('19000000-0000-4000-8000-000000000906', false, 'Existing', 'Tenant User', statement_timestamp());

insert into public.platform_user_auth_subjects (auth_subject_id, platform_user_id)
values
  ('19000000-0000-4000-8000-000000000002', '19000000-0000-4000-8000-000000000902'),
  ('19000000-0000-4000-8000-000000000003', '19000000-0000-4000-8000-000000000903'),
  ('19000000-0000-4000-8000-000000000004', '19000000-0000-4000-8000-000000000904'),
  ('19000000-0000-4000-8000-000000000005', '19000000-0000-4000-8000-000000000905');

insert into public.company_memberships (
  id,
  platform_user_id,
  maintenance_company_id,
  role,
  is_enabled
)
values
  (
    '19000000-0000-4000-8000-000000000804',
    '19000000-0000-4000-8000-000000000904',
    '19000000-0000-4000-8000-000000000103',
    'COMPANY_ADMIN',
    true
  ),
  (
    '19000000-0000-4000-8000-000000000811',
    '19000000-0000-4000-8000-000000000906',
    '19000000-0000-4000-8000-000000000111',
    'TECHNICIAN',
    true
  );

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
  ('19000000-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid,
  (array[
    'new@example.test',
    'compatible@example.test',
    'super@example.test',
    'member@example.test',
    'completed@example.test',
    'revoked@example.test',
    'unconsumed@example.test',
    'rollback@example.test',
    'broken@example.test'
  ])[series],
  decode(repeat('19', 32), 'hex'),
  'task019-v1',
  statement_timestamp() - interval '12 minutes',
  statement_timestamp() + interval '7 hours 48 minutes',
  1,
  statement_timestamp() - interval '11 minutes',
  ('19000001-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid
from generate_series(1, 9) as series;

insert into public.auth_bridge_credentials (
  id,
  email,
  auth_user_id,
  technical_password_key_version,
  created_at,
  bound_at
)
select
  ('19000002-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid,
  (array[
    'new@example.test',
    'compatible@example.test',
    'super@example.test',
    'member@example.test',
    'completed@example.test',
    'revoked@example.test',
    'unconsumed@example.test',
    'rollback@example.test',
    'broken@example.test'
  ])[series],
  case
    when series = 9 then '19000000-0000-4000-8000-000000000010'::uuid
    else ('19000000-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid
  end,
  'task019-v1',
  statement_timestamp() - interval '12 minutes',
  statement_timestamp() - interval '11 minutes'
from generate_series(1, 9) as series;

insert into public.auth_session_grants (
  id,
  challenge_id,
  auth_bridge_credential_id,
  auth_user_id,
  purpose,
  auth_method,
  created_at,
  expires_at,
  consumed_at,
  revoked_at,
  grant_operation_id
)
select
  ('19000003-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid,
  ('19000000-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid,
  ('19000002-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid,
  ('19000000-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid,
  'initial_session',
  'password',
  statement_timestamp() - interval '10 minutes',
  statement_timestamp() - interval '5 minutes',
  case when series in (6, 7) then null else statement_timestamp() - interval '9 minutes' end,
  case when series = 6 then statement_timestamp() - interval '9 minutes' else null end,
  ('19000004-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid
from generate_series(1, 9) as series;

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
  ('19000005-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid,
  ('19000000-0000-4000-8000-' || lpad((series + 99)::text, 12, '0'))::uuid,
  (array[
    'new@example.test',
    'compatible@example.test',
    'super@example.test',
    'member@example.test',
    'completed@example.test',
    'revoked@example.test',
    'unconsumed@example.test',
    'rollback@example.test',
    'broken@example.test'
  ])[series],
  '19000000-0000-4000-8000-000000000900',
  ('19000006-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid,
  ('19000000-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid,
  ('19000003-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid,
  session_grant.created_at
from generate_series(1, 9) as series
join public.auth_session_grants as session_grant
  on session_grant.id =
    ('19000003-0000-4000-8000-' || lpad(series::text, 12, '0'))::uuid;

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
values (
  '19000017-0000-4000-8000-000000000001',
  'tenant-conflict@example.test',
  decode(repeat('1c', 32), 'hex'),
  'task019-v1',
  statement_timestamp() - interval '12 minutes',
  statement_timestamp() + interval '7 hours 48 minutes',
  1,
  statement_timestamp() - interval '11 minutes',
  '19000018-0000-4000-8000-000000000001'
);

insert into public.auth_bridge_credentials (
  id,
  email,
  auth_user_id,
  technical_password_key_version,
  created_at,
  bound_at
)
values (
  '19000019-0000-4000-8000-000000000001',
  'tenant-conflict@example.test',
  '19000000-0000-4000-8000-000000000013',
  'task019-v1',
  statement_timestamp() - interval '12 minutes',
  statement_timestamp() - interval '11 minutes'
);

insert into public.auth_session_grants (
  id,
  challenge_id,
  auth_bridge_credential_id,
  auth_user_id,
  purpose,
  auth_method,
  created_at,
  expires_at,
  consumed_at,
  grant_operation_id
)
values (
  '19000020-0000-4000-8000-000000000001',
  '19000017-0000-4000-8000-000000000001',
  '19000019-0000-4000-8000-000000000001',
  '19000000-0000-4000-8000-000000000013',
  'initial_session',
  'password',
  statement_timestamp() - interval '10 minutes',
  statement_timestamp() - interval '5 minutes',
  statement_timestamp() - interval '9 minutes',
  '19000021-0000-4000-8000-000000000001'
);

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
  '19000022-0000-4000-8000-000000000001',
  '19000000-0000-4000-8000-000000000111',
  'tenant-conflict@example.test',
  '19000000-0000-4000-8000-000000000900',
  '19000023-0000-4000-8000-000000000001',
  '19000017-0000-4000-8000-000000000001',
  session_grant.id,
  session_grant.created_at
from public.auth_session_grants as session_grant
where session_grant.id = '19000020-0000-4000-8000-000000000001';

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
values
  (
    '19000010-0000-4000-8000-000000000001',
    'ambiguous@example.test',
    decode(repeat('1a', 32), 'hex'),
    'task019-v1',
    statement_timestamp() - interval '12 minutes',
    statement_timestamp() + interval '7 hours 48 minutes',
    1,
    statement_timestamp() - interval '11 minutes',
    '19000011-0000-4000-8000-000000000001'
  ),
  (
    '19000010-0000-4000-8000-000000000002',
    'ambiguous@example.test',
    decode(repeat('1b', 32), 'hex'),
    'task019-v1',
    statement_timestamp() - interval '12 minutes',
    statement_timestamp() + interval '7 hours 48 minutes',
    1,
    statement_timestamp() - interval '11 minutes',
    '19000011-0000-4000-8000-000000000002'
  );

insert into public.auth_bridge_credentials (
  id,
  email,
  auth_user_id,
  technical_password_key_version,
  created_at,
  bound_at
)
values (
  '19000012-0000-4000-8000-000000000001',
  'ambiguous@example.test',
  '19000000-0000-4000-8000-000000000012',
  'task019-v1',
  statement_timestamp() - interval '12 minutes',
  statement_timestamp() - interval '11 minutes'
);

insert into public.auth_session_grants (
  id,
  challenge_id,
  auth_bridge_credential_id,
  auth_user_id,
  purpose,
  auth_method,
  created_at,
  expires_at,
  consumed_at,
  grant_operation_id
)
values
  (
    '19000013-0000-4000-8000-000000000001',
    '19000010-0000-4000-8000-000000000001',
    '19000012-0000-4000-8000-000000000001',
    '19000000-0000-4000-8000-000000000012',
    'initial_session',
    'password',
    statement_timestamp() - interval '10 minutes',
    statement_timestamp() - interval '5 minutes',
    statement_timestamp() - interval '9 minutes',
    '19000014-0000-4000-8000-000000000001'
  ),
  (
    '19000013-0000-4000-8000-000000000002',
    '19000010-0000-4000-8000-000000000002',
    '19000012-0000-4000-8000-000000000001',
    '19000000-0000-4000-8000-000000000012',
    'initial_session',
    'password',
    statement_timestamp() - interval '10 minutes',
    statement_timestamp() - interval '5 minutes',
    statement_timestamp() - interval '9 minutes',
    '19000014-0000-4000-8000-000000000002'
  );

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
  fixture.intent_id,
  fixture.company_id,
  'ambiguous@example.test',
  '19000000-0000-4000-8000-000000000900',
  fixture.establishment_operation_id,
  fixture.challenge_id,
  fixture.grant_id,
  session_grant.created_at
from (
  values
    (
      '19000015-0000-4000-8000-000000000001'::uuid,
      '19000000-0000-4000-8000-000000000109'::uuid,
      '19000016-0000-4000-8000-000000000001'::uuid,
      '19000010-0000-4000-8000-000000000001'::uuid,
      '19000013-0000-4000-8000-000000000001'::uuid
    ),
    (
      '19000015-0000-4000-8000-000000000002'::uuid,
      '19000000-0000-4000-8000-000000000110'::uuid,
      '19000016-0000-4000-8000-000000000002'::uuid,
      '19000010-0000-4000-8000-000000000002'::uuid,
      '19000013-0000-4000-8000-000000000002'::uuid
    )
) as fixture(intent_id, company_id, establishment_operation_id, challenge_id, grant_id)
join public.auth_session_grants as session_grant
  on session_grant.id = fixture.grant_id;

select throws_ok(
  $$insert into public.platform_users (id, is_super_admin, first_name) values ('19000000-0000-4000-8000-000000000990', false, 'Partial')$$,
  '23514',
  null,
  'T019-A-CONSTRAINT-001 partial profile state is rejected'
);

select throws_ok(
  $$insert into public.platform_users (id, is_super_admin, first_name, last_name, profile_completed_at) values ('19000000-0000-4000-8000-000000000991', false, ' Trimmed ', 'Name', statement_timestamp())$$,
  '23514',
  null,
  'T019-A-CONSTRAINT-002 untrimmed completed profile is rejected'
);

select throws_ok(
  $$update public.first_admin_onboarding_intents set completion_operation_id = '19000007-0000-4000-8000-000000000999' where id = '19000005-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'T019-A-CONSTRAINT-003 partial terminal intent state is rejected'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('A', 'B', '19000007-0000-4000-8000-000000000001')$$,
  array['DENIED|AUTHORIZATION_DENIED']::text[],
  'T019-A-AUTH-002 missing Auth subject is denied'
);

select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000011', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('A', 'B', '19000007-0000-4000-8000-000000000011')$$,
  array['DENIED|SECURITY_CORRELATION_FAILURE']::text[],
  'T019-A-AUTH-003 unrelated authenticated subject fails closed'
);

select results_eq(
  $$select state from public.resolve_current_first_admin_onboarding_state()$$,
  array['UNAVAILABLE']::text[],
  'T019-A-RESOLVER-001 unrelated subject resolves UNAVAILABLE'
);

select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000012', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('Ambiguous', 'Subject', '19000007-0000-4000-8000-000000000012')$$,
  array['DENIED|SECURITY_CORRELATION_FAILURE']::text[],
  'T019-A-AUTH-004 multiple authoritative candidates fail closed'
);

select results_eq(
  $$select state from public.resolve_current_first_admin_onboarding_state()$$,
  array['UNAVAILABLE']::text[],
  'T019-A-RESOLVER-004 ambiguous current state resolves UNAVAILABLE'
);

select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000001', true);
select throws_ok(
  $$select * from public.complete_first_admin_onboarding('A', 'B', 'not-a-uuid')$$,
  '22P02',
  null,
  'T019-A-INPUT-004 malformed operation UUID is rejected by the typed boundary'
);

select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('A', 'B', null)$$,
  array['DENIED|INVALID_INPUT']::text[],
  'T019-A-INPUT-001 null operation is rejected'
);

select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('', 'B', '19000007-0000-4000-8000-000000000004')$$,
  array['DENIED|INVALID_INPUT']::text[],
  'T019-A-INPUT-005 empty first name is rejected'
);

select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('A', '', '19000007-0000-4000-8000-000000000005')$$,
  array['DENIED|INVALID_INPUT']::text[],
  'T019-A-INPUT-006 empty last name is rejected'
);

select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('   ', 'B', '19000007-0000-4000-8000-000000000002')$$,
  array['DENIED|INVALID_INPUT']::text[],
  'T019-A-INPUT-002 blank first name is rejected'
);

select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('A', '   ', '19000007-0000-4000-8000-000000000003')$$,
  array['DENIED|INVALID_INPUT']::text[],
  'T019-A-INPUT-003 whitespace last name is rejected'
);

select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000013', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('Conflict', 'Target', '19000024-0000-4000-8000-000000000001')$$,
  array['DENIED|INITIAL_MEMBERSHIP_CONFLICT']::text[],
  'T019-A-TENANT-CONFLICT-001 preexisting membership for another tenant user fails closed'
);
reset role;

select ok(
  not exists (
    select 1
    from public.platform_user_auth_subjects
    where auth_subject_id = '19000000-0000-4000-8000-000000000013'
  )
  and (
    select count(*)::integer
    from public.platform_users
  ) = 6,
  'T019-A-TENANT-CONFLICT-002 target subject receives no PlatformUser or Auth-subject mapping'
);

select is(
  (
    select string_agg(
      membership.id::text || '|' || membership.platform_user_id::text,
      ',' order by membership.id
    )
    from public.company_memberships as membership
    where membership.maintenance_company_id = '19000000-0000-4000-8000-000000000111'
  ),
  '19000000-0000-4000-8000-000000000811|19000000-0000-4000-8000-000000000906',
  'T019-A-TENANT-CONFLICT-003 preexisting membership is neither adopted nor supplemented'
);

select is(
  (
    select count(*)::integer
    from public.audit_events
    where maintenance_company_id = '19000000-0000-4000-8000-000000000111'
      and action = 'USER_CREATED'
  ),
  0,
  'T019-A-TENANT-CONFLICT-004 denial creates no USER_CREATED audit event'
);

select ok(
  exists (
    select 1
    from public.first_admin_onboarding_intents
    where id = '19000022-0000-4000-8000-000000000001'
      and completion_operation_id is null
      and completed_platform_user_id is null
      and completed_company_membership_id is null
      and completed_at is null
  ),
  'T019-A-TENANT-CONFLICT-005 denied intent remains non-terminal'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000001', true);
select results_eq(
  $$select state || '|' || coalesce(completed_at::text, 'NULL') from public.resolve_current_first_admin_onboarding_state()$$,
  array['PENDING_PROFILE|NULL']::text[],
  'T019-A-RESOLVER-002 valid new-identity flow resolves PENDING_PROFILE'
);

select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('  New  ', '  Admin  ', '19000007-0000-4000-8000-000000000001')$$,
  array['COMPLETED|COMPLETED']::text[],
  'T019-A-COMPLETE-001 no-application-identity completion succeeds'
);
reset role;

select is(
  (
    select platform_user.first_name || '|' || platform_user.last_name
    from public.platform_user_auth_subjects as auth_subject
    join public.platform_users as platform_user
      on platform_user.id = auth_subject.platform_user_id
    where auth_subject.auth_subject_id = '19000000-0000-4000-8000-000000000001'
  ),
  'New|Admin',
  'T019-A-COMPLETE-002 trimmed profile is persisted on the newly created PlatformUser'
);

select ok(
  exists (
    select 1
    from public.platform_user_auth_subjects as auth_subject
    join public.platform_users as platform_user
      on platform_user.id = auth_subject.platform_user_id
    where auth_subject.auth_subject_id = '19000000-0000-4000-8000-000000000001'
      and not platform_user.is_super_admin
      and platform_user.profile_completed_at is not null
  ),
  'T019-A-COMPLETE-003 new Auth-subject mapping and trusted profile timestamp exist'
);

select ok(
  exists (
    select 1
    from public.platform_user_auth_subjects as auth_subject
    join public.company_memberships as membership
      on membership.platform_user_id = auth_subject.platform_user_id
    join public.first_admin_onboarding_intents as intent
      on intent.completed_company_membership_id = membership.id
    where auth_subject.auth_subject_id = '19000000-0000-4000-8000-000000000001'
      and membership.maintenance_company_id = '19000000-0000-4000-8000-000000000100'
      and membership.role = 'COMPANY_ADMIN'
      and membership.is_enabled
      and intent.id = '19000005-0000-4000-8000-000000000001'
      and intent.completion_operation_id = '19000007-0000-4000-8000-000000000001'
      and intent.completed_platform_user_id = auth_subject.platform_user_id
      and intent.completed_at is not null
  ),
  'T019-A-COMPLETE-004 membership tenant role enabled state and terminal evidence derive from intent'
);

select is(
  (
    select count(*)::integer
    from public.audit_events as audit_event
    join public.platform_user_auth_subjects as auth_subject
      on auth_subject.platform_user_id = audit_event.subject_platform_user_id
    where auth_subject.auth_subject_id = '19000000-0000-4000-8000-000000000001'
      and audit_event.maintenance_company_id = '19000000-0000-4000-8000-000000000100'
      and audit_event.actor_kind = 'PLATFORM_USER'
      and audit_event.actor_platform_user_id = '19000000-0000-4000-8000-000000000900'
      and audit_event.actor_internal_process_key is null
      and audit_event.action = 'USER_CREATED'
      and audit_event.scope_kind = 'USER'
      and audit_event.role_before is null
      and audit_event.role_after is null
  ),
  1,
  'T019-A-AUDIT-001 USER_CREATED has exact historical actor subject and tenant provenance'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000001', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('Ignored', 'Names', '19000007-0000-4000-8000-000000000001')$$,
  array['ALREADY_COMPLETED|ALREADY_COMPLETED']::text[],
  'T019-A-IDEMPOTENCY-001 same operation reconciles committed completion'
);

select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('Different', 'Operation', '19000007-0000-4000-8000-000000000099')$$,
  array['DENIED|ONBOARDING_ALREADY_COMPLETED']::text[],
  'T019-A-IDEMPOTENCY-002 different operation cannot reopen terminal intent'
);

select results_eq(
  $$select state from public.resolve_current_first_admin_onboarding_state()$$,
  array['COMPLETED']::text[],
  'T019-A-RESOLVER-003 terminal consistent flow resolves COMPLETED'
);
reset role;

select is(
  (
    select platform_user.first_name || '|' || platform_user.last_name
    from public.platform_user_auth_subjects as auth_subject
    join public.platform_users as platform_user
      on platform_user.id = auth_subject.platform_user_id
    where auth_subject.auth_subject_id = '19000000-0000-4000-8000-000000000001'
  ),
  'New|Admin',
  'T019-A-IDEMPOTENCY-003 same-operation retry does not rewrite names'
);

select is(
  (
    select count(*)::integer
    from public.audit_events as audit_event
    join public.platform_user_auth_subjects as auth_subject
      on auth_subject.platform_user_id = audit_event.subject_platform_user_id
    where auth_subject.auth_subject_id = '19000000-0000-4000-8000-000000000001'
      and audit_event.action = 'USER_CREATED'
  ),
  1,
  'T019-A-IDEMPOTENCY-004 retry creates no duplicate audit'
);

select is(
  (
    select count(*)::integer
    from public.company_memberships as membership
    join public.platform_user_auth_subjects as auth_subject
      on auth_subject.platform_user_id = membership.platform_user_id
    where auth_subject.auth_subject_id = '19000000-0000-4000-8000-000000000001'
  ),
  1,
  'T019-A-IDEMPOTENCY-005 retry creates no duplicate membership'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000002', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding(' Compatible ', ' User ', '19000007-0000-4000-8000-000000000002')$$,
  array['COMPLETED|COMPLETED']::text[],
  'T019-A-COMPAT-001 compatible existing PlatformUser completes successfully'
);
reset role;

select is(
  (
    select platform_user_id::text
    from public.platform_user_auth_subjects
    where auth_subject_id = '19000000-0000-4000-8000-000000000002'
  ),
  '19000000-0000-4000-8000-000000000902',
  'T019-A-COMPAT-002 existing PlatformUser ID is reused without relinking'
);

select is(
  (
    select first_name || '|' || last_name
    from public.platform_users
    where id = '19000000-0000-4000-8000-000000000902'
  ),
  'Compatible|User',
  'T019-A-COMPAT-003 existing compatible PlatformUser receives trimmed profile'
);

select is(
  (
    select count(*)::integer
    from public.platform_users
    where id = '19000000-0000-4000-8000-000000000902'
  ),
  1,
  'T019-A-COMPAT-004 compatible path creates no second PlatformUser'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000003', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('Super', 'Target', '19000007-0000-4000-8000-000000000003')$$,
  array['DENIED|IDENTITY_INCOMPATIBLE']::text[],
  'T019-A-DENY-001 SUPER_ADMIN target fails closed'
);

select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000004', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('Member', 'Target', '19000007-0000-4000-8000-000000000004')$$,
  array['DENIED|INITIAL_MEMBERSHIP_CONFLICT']::text[],
  'T019-A-DENY-002 existing membership fails closed'
);

select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000005', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('Already', 'Complete', '19000007-0000-4000-8000-000000000005')$$,
  array['DENIED|IDENTITY_INCOMPATIBLE']::text[],
  'T019-A-DENY-003 pre-completed profile fails closed'
);

select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000006', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('Revoked', 'Grant', '19000007-0000-4000-8000-000000000006')$$,
  array['DENIED|SECURITY_CORRELATION_FAILURE']::text[],
  'T019-A-DENY-004 revoked grant fails closed'
);

select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000007', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('Unconsumed', 'Grant', '19000007-0000-4000-8000-000000000007')$$,
  array['DENIED|SECURITY_CORRELATION_FAILURE']::text[],
  'T019-A-DENY-005 unconsumed grant fails closed'
);

select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000009', true);
select results_eq(
  $$select outcome || '|' || reason from public.complete_first_admin_onboarding('Broken', 'Bridge', '19000007-0000-4000-8000-000000000009')$$,
  array['DENIED|SECURITY_CORRELATION_FAILURE']::text[],
  'T019-A-DENY-006 broken bridge/current-subject correlation fails closed'
);
reset role;

select is(
  (
    select count(*)::integer
    from public.first_admin_onboarding_intents
    where id in (
      '19000005-0000-4000-8000-000000000003',
      '19000005-0000-4000-8000-000000000004',
      '19000005-0000-4000-8000-000000000005',
      '19000005-0000-4000-8000-000000000006',
      '19000005-0000-4000-8000-000000000007',
      '19000005-0000-4000-8000-000000000009'
    )
      and completion_operation_id is not null
  ),
  0,
  'T019-A-DENY-007 denied calls leave all tested intents non-terminal'
);

create function pg_temp.task019_force_audit_failure()
returns trigger
language plpgsql
as $$
begin
  if new.maintenance_company_id = '19000000-0000-4000-8000-000000000107'::uuid then
    raise exception using errcode = 'P0001', message = 'forced TASK-019 audit failure';
  end if;
  return new;
end;
$$;

create trigger task019_force_audit_failure
before insert on public.audit_events
for each row execute function pg_temp.task019_force_audit_failure();

set local role authenticated;
select set_config('request.jwt.claim.sub', '19000000-0000-4000-8000-000000000008', true);
select throws_ok(
  $$select * from public.complete_first_admin_onboarding('Rollback', 'Target', '19000007-0000-4000-8000-000000000008')$$,
  'P0001',
  'forced TASK-019 audit failure',
  'T019-A-ATOMIC-001 forced audit failure propagates'
);
reset role;

drop trigger task019_force_audit_failure on public.audit_events;

select ok(
  not exists (
    select 1
    from public.platform_user_auth_subjects
    where auth_subject_id = '19000000-0000-4000-8000-000000000008'
  )
  and not exists (
    select 1
    from public.company_memberships
    where maintenance_company_id = '19000000-0000-4000-8000-000000000107'
  )
  and not exists (
    select 1
    from public.audit_events
    where maintenance_company_id = '19000000-0000-4000-8000-000000000107'
  )
  and not exists (
    select 1
    from public.first_admin_onboarding_intents
    where id = '19000005-0000-4000-8000-000000000008'
      and completion_operation_id is not null
  ),
  'T019-A-ATOMIC-002 forced failure rolls back identity membership audit and terminal evidence'
);

select ok(
  exists (
    select 1
    from public.first_admin_onboarding_intents
    where id = '19000005-0000-4000-8000-000000000001'
      and completed_at is not null
  ),
  'T019-A-EXPIRY-001 consumed valid grant remains usable after original grant expiry'
);

select ok(
  pg_get_functiondef(
    'private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ) not ilike '%apply_company_membership_lifecycle%'
  and pg_get_functiondef(
    'private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ) not ilike '%pg_advisory%'
  and pg_get_functiondef(
    'private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure
  ) not ilike '%expires_at%',
  'T019-A-SCOPE-001 TASK-015 API is not expanded and no advisory/global or expiry authority is introduced'
);

select * from finish();

rollback;
