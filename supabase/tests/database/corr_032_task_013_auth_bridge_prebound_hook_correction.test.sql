\set ON_ERROR_STOP on

begin;

select plan(26);

create function pg_temp.corr032_hook_succeeds(hook_event jsonb)
returns boolean
language plpgsql
as $$
begin
  perform public.task_013_custom_access_token_hook(hook_event);
  return true;
exception
  when sqlstate 'P0001' then
    return false;
end;
$$;

create function pg_temp.corr032_statement_row_count(statement text)
returns bigint
language plpgsql
as $$
declare
  affected_rows bigint;
begin
  execute statement;
  get diagnostics affected_rows = row_count;
  return affected_rows;
end;
$$;

create temporary table corr032_clock (
  now_value timestamptz not null
) on commit drop;

insert into corr032_clock values (clock_timestamp());

insert into auth.users (id, email)
values
  ('32000000-0000-4000-8000-000000000001', 'corr032-user-a@example.test'),
  ('32000000-0000-4000-8000-000000000002', 'corr032-user-b@example.test'),
  ('32000000-0000-4000-8000-000000000003', 'corr032-user-c@example.test');

insert into public.verification_challenges (
  id,
  email,
  verifier,
  verifier_key_version,
  issued_at,
  expires_at,
  consumed_at,
  issue_operation_id
)
select
  fixture.id,
  fixture.email,
  decode(repeat('32', 32), 'hex'),
  'v1',
  clock.now_value - interval '1 minute',
  clock.now_value + interval '7 hours 59 minutes',
  clock.now_value - interval '30 seconds',
  fixture.operation_id
from corr032_clock as clock
cross join (values
  ('32000000-0000-4000-8100-000000000001'::uuid, 'corr032-unbound@example.test', '32000000-0000-4000-8200-000000000001'::uuid),
  ('32000000-0000-4000-8100-000000000002'::uuid, 'corr032-bound@example.test', '32000000-0000-4000-8200-000000000002'::uuid),
  ('32000000-0000-4000-8100-000000000003'::uuid, 'corr032-wrong-subject@example.test', '32000000-0000-4000-8200-000000000003'::uuid),
  ('32000000-0000-4000-8100-000000000004'::uuid, 'corr032-expired@example.test', '32000000-0000-4000-8200-000000000004'::uuid),
  ('32000000-0000-4000-8100-000000000005'::uuid, 'corr032-revoked@example.test', '32000000-0000-4000-8200-000000000005'::uuid),
  ('32000000-0000-4000-8100-000000000006'::uuid, 'corr032-consumed@example.test', '32000000-0000-4000-8200-000000000006'::uuid)
) as fixture(id, email, operation_id);

insert into public.auth_bridge_credentials (
  id,
  email,
  auth_user_id,
  technical_password_key_version,
  bound_at
)
select
  fixture.id,
  fixture.email,
  fixture.auth_user_id,
  'v1',
  case when fixture.auth_user_id is null then null else clock.now_value - interval '2 minutes' end
from corr032_clock as clock
cross join (values
  ('32000000-0000-4000-8300-000000000001'::uuid, 'corr032-unbound@example.test', null::uuid),
  ('32000000-0000-4000-8300-000000000002'::uuid, 'corr032-bound@example.test', '32000000-0000-4000-8000-000000000002'::uuid),
  ('32000000-0000-4000-8300-000000000003'::uuid, 'corr032-wrong-subject@example.test', '32000000-0000-4000-8000-000000000003'::uuid),
  ('32000000-0000-4000-8300-000000000004'::uuid, 'corr032-expired@example.test', null::uuid),
  ('32000000-0000-4000-8300-000000000005'::uuid, 'corr032-revoked@example.test', null::uuid),
  ('32000000-0000-4000-8300-000000000006'::uuid, 'corr032-consumed@example.test', null::uuid)
) as fixture(id, email, auth_user_id);

create temporary table corr032_bridge_snapshot
on commit drop
as
select id, auth_user_id, bound_at
from public.auth_bridge_credentials
where id = '32000000-0000-4000-8300-000000000002';

insert into public.auth_session_grants (
  id,
  challenge_id,
  auth_bridge_credential_id,
  auth_user_id,
  created_at,
  expires_at,
  consumed_at,
  revoked_at,
  grant_operation_id
)
select
  fixture.id,
  fixture.challenge_id,
  fixture.bridge_id,
  fixture.auth_user_id,
  fixture.created_at,
  fixture.created_at + interval '5 minutes',
  fixture.consumed_at,
  fixture.revoked_at,
  fixture.operation_id
from corr032_clock as clock
cross join lateral (values
  ('32000000-0000-4000-8400-000000000001'::uuid, '32000000-0000-4000-8100-000000000001'::uuid, '32000000-0000-4000-8300-000000000001'::uuid, null::uuid, clock.now_value - interval '1 minute', null::timestamptz, null::timestamptz, '32000000-0000-4000-8500-000000000001'::uuid),
  ('32000000-0000-4000-8400-000000000002'::uuid, '32000000-0000-4000-8100-000000000002'::uuid, '32000000-0000-4000-8300-000000000002'::uuid, '32000000-0000-4000-8000-000000000002'::uuid, clock.now_value - interval '1 minute', null::timestamptz, null::timestamptz, '32000000-0000-4000-8500-000000000002'::uuid),
  ('32000000-0000-4000-8400-000000000003'::uuid, '32000000-0000-4000-8100-000000000003'::uuid, '32000000-0000-4000-8300-000000000003'::uuid, '32000000-0000-4000-8000-000000000003'::uuid, clock.now_value - interval '1 minute', null::timestamptz, null::timestamptz, '32000000-0000-4000-8500-000000000003'::uuid),
  ('32000000-0000-4000-8400-000000000004'::uuid, '32000000-0000-4000-8100-000000000004'::uuid, '32000000-0000-4000-8300-000000000004'::uuid, null::uuid, clock.now_value - interval '6 minutes', null::timestamptz, null::timestamptz, '32000000-0000-4000-8500-000000000004'::uuid),
  ('32000000-0000-4000-8400-000000000005'::uuid, '32000000-0000-4000-8100-000000000005'::uuid, '32000000-0000-4000-8300-000000000005'::uuid, null::uuid, clock.now_value - interval '1 minute', null::timestamptz, clock.now_value - interval '30 seconds', '32000000-0000-4000-8500-000000000005'::uuid),
  ('32000000-0000-4000-8400-000000000006'::uuid, '32000000-0000-4000-8100-000000000006'::uuid, '32000000-0000-4000-8300-000000000006'::uuid, null::uuid, clock.now_value - interval '1 minute', clock.now_value - interval '30 seconds', null::timestamptz, '32000000-0000-4000-8500-000000000006'::uuid)
) as fixture(id, challenge_id, bridge_id, auth_user_id, created_at, consumed_at, revoked_at, operation_id);

select ok(
  (select not prosecdef from pg_proc where oid = 'public.task_013_custom_access_token_hook(jsonb)'::regprocedure),
  'C032-DB-001 Hook remains SECURITY INVOKER'
);

select ok(
  (select relrowsecurity from pg_class where oid = 'public.auth_bridge_credentials'::regclass)
  and (select relrowsecurity from pg_class where oid = 'public.auth_session_grants'::regclass),
  'C032-DB-002 bridge and SessionGrant RLS remain enabled'
);

select ok(
  (select proconfig = array['search_path=""']::text[] from pg_proc where oid = 'public.task_013_custom_access_token_hook(jsonb)'::regprocedure),
  'C032-DB-003 Hook preserves the empty search_path boundary'
);

set local role supabase_auth_admin;
do $$
begin
  perform set_config(
    'corr032.unbound_hook_result',
    public.task_013_custom_access_token_hook(jsonb_build_object(
      'user_id', '32000000-0000-4000-8000-000000000001',
      'authentication_method', 'password',
      'claims', jsonb_build_object('email', 'corr032-unbound@example.test')
    ))::text,
    true
  );
end $$;
reset role;

select ok(
  current_setting('corr032.unbound_hook_result')::jsonb = jsonb_build_object('claims', jsonb_build_object('email', 'corr032-unbound@example.test')),
  'C032-DB-004 unbound compatible bridge authorizes the initial password session'
);

select ok(
  (select auth_user_id = '32000000-0000-4000-8000-000000000001' and bound_at is not null
   from public.auth_bridge_credentials where id = '32000000-0000-4000-8300-000000000001'),
  'C032-DB-005 unbound compatible bridge binds the exact Hook subject once'
);

select ok(
  (select auth_user_id = '32000000-0000-4000-8000-000000000001' and consumed_at is not null and revoked_at is null
   from public.auth_session_grants where id = '32000000-0000-4000-8400-000000000001'),
  'C032-DB-006 unbound path consumes the correlated SessionGrant atomically'
);

set local role supabase_auth_admin;
do $$
begin
  perform set_config(
    'corr032.bound_hook_result',
    public.task_013_custom_access_token_hook(jsonb_build_object(
      'user_id', '32000000-0000-4000-8000-000000000002',
      'authentication_method', 'password',
      'claims', jsonb_build_object('email', 'corr032-bound@example.test')
    ))::text,
    true
  );
end $$;
reset role;

select ok(
  current_setting('corr032.bound_hook_result')::jsonb = jsonb_build_object('claims', jsonb_build_object('email', 'corr032-bound@example.test')),
  'C032-DB-007 already-bound same-subject bridge authorizes the initial password session'
);

select is(
  (select auth_user_id from public.auth_bridge_credentials where id = '32000000-0000-4000-8300-000000000002'),
  (select auth_user_id from corr032_bridge_snapshot),
  'C032-DB-008 already-bound success preserves auth_user_id'
);

select is(
  (select bound_at from public.auth_bridge_credentials where id = '32000000-0000-4000-8300-000000000002'),
  (select bound_at from corr032_bridge_snapshot),
  'C032-DB-009 already-bound success preserves bound_at'
);

select ok(
  (select auth_user_id = '32000000-0000-4000-8000-000000000002' and consumed_at is not null
   from public.auth_session_grants where id = '32000000-0000-4000-8400-000000000002'),
  'C032-DB-010 already-bound success consumes exactly its correlated SessionGrant'
);

set local role supabase_auth_admin;
do $$
begin
  perform set_config(
    'corr032.wrong_subject_result',
    pg_temp.corr032_hook_succeeds(jsonb_build_object(
      'user_id', '32000000-0000-4000-8000-000000000001',
      'authentication_method', 'password',
      'claims', jsonb_build_object('email', 'corr032-wrong-subject@example.test')
    ))::text,
    true
  );
end $$;
reset role;

select ok(
  not current_setting('corr032.wrong_subject_result')::boolean,
  'C032-DB-011 already-bound wrong-subject request is denied'
);

select ok(
  (select auth_user_id = '32000000-0000-4000-8000-000000000003'
   from public.auth_bridge_credentials where id = '32000000-0000-4000-8300-000000000003')
  and (select consumed_at is null from public.auth_session_grants where id = '32000000-0000-4000-8400-000000000003'),
  'C032-DB-012 wrong-subject denial mutates neither bridge nor grant'
);

set local role supabase_auth_admin;
do $$
begin
  perform set_config('corr032.wrong_email_result', pg_temp.corr032_hook_succeeds(jsonb_build_object(
    'user_id', '32000000-0000-4000-8000-000000000001', 'authentication_method', 'password',
    'claims', jsonb_build_object('email', 'corr032-wrong-email@example.test')) )::text, true);
  perform set_config('corr032.missing_grant_result', pg_temp.corr032_hook_succeeds(jsonb_build_object(
    'user_id', '32000000-0000-4000-8000-000000000001', 'authentication_method', 'password',
    'claims', jsonb_build_object('email', 'corr032-missing-grant@example.test')) )::text, true);
  perform set_config('corr032.expired_result', pg_temp.corr032_hook_succeeds(jsonb_build_object(
    'user_id', '32000000-0000-4000-8000-000000000001', 'authentication_method', 'password',
    'claims', jsonb_build_object('email', 'corr032-expired@example.test')) )::text, true);
  perform set_config('corr032.revoked_result', pg_temp.corr032_hook_succeeds(jsonb_build_object(
    'user_id', '32000000-0000-4000-8000-000000000001', 'authentication_method', 'password',
    'claims', jsonb_build_object('email', 'corr032-revoked@example.test')) )::text, true);
  perform set_config('corr032.consumed_result', pg_temp.corr032_hook_succeeds(jsonb_build_object(
    'user_id', '32000000-0000-4000-8000-000000000001', 'authentication_method', 'password',
    'claims', jsonb_build_object('email', 'corr032-consumed@example.test')) )::text, true);
  perform set_config('corr032.refresh_result', public.task_013_custom_access_token_hook(jsonb_build_object(
    'authentication_method', 'token_refresh',
    'claims', jsonb_build_object('sub', '32000000-0000-4000-8000-000000000001')))::text, true);
end $$;
reset role;

select ok(not current_setting('corr032.wrong_email_result')::boolean, 'C032-DB-013 wrong email or bridge correlation is denied');
select ok(not current_setting('corr032.missing_grant_result')::boolean, 'C032-DB-014 password authentication without a grant is denied');
select ok(not current_setting('corr032.expired_result')::boolean, 'C032-DB-015 expired SessionGrant is denied');
select ok(not current_setting('corr032.revoked_result')::boolean, 'C032-DB-016 revoked SessionGrant is denied');
select ok(not current_setting('corr032.consumed_result')::boolean, 'C032-DB-017 consumed or replayed SessionGrant is denied');
select ok(
  current_setting('corr032.refresh_result')::jsonb = jsonb_build_object('claims', jsonb_build_object('sub', '32000000-0000-4000-8000-000000000001')),
  'C032-DB-018 token_refresh preserves the existing post-cutover contract'
);

select ok(
  (select consumed_at is null from public.auth_session_grants where id = '32000000-0000-4000-8400-000000000003'),
  'C032-DB-019 token_refresh consumes no fresh initial-session grant'
);

select ok(
  not has_table_privilege('anon', 'public.auth_bridge_credentials', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('anon', 'public.auth_session_grants', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.auth_bridge_credentials', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.auth_session_grants', 'SELECT,INSERT,UPDATE,DELETE'),
  'C032-DB-020 browser Data API roles retain zero direct bridge and grant CRUD'
);

select ok(
  not has_table_privilege('supabase_auth_admin', 'public.maintenance_companies', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('supabase_auth_admin', 'public.platform_users', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('supabase_auth_admin', 'public.company_memberships', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('supabase_auth_admin', 'public.audit_events', 'SELECT,INSERT,UPDATE,DELETE'),
  'C032-DB-021 CORR-032 introduces no supabase_auth_admin tenant privilege'
);

select ok(
  coalesce((
    select array_agg(column_name::text order by column_name)
    from information_schema.column_privileges
    where grantee = 'supabase_auth_admin'
      and table_schema = 'public'
      and table_name = 'auth_session_grants'
      and privilege_type = 'SELECT'
  ), array[]::text[]) = array['auth_bridge_credential_id', 'auth_method', 'auth_user_id', 'consumed_at', 'expires_at', 'id', 'purpose', 'revoked_at']::text[]
  and coalesce((
    select array_agg(column_name::text order by column_name)
    from information_schema.column_privileges
    where grantee = 'supabase_auth_admin'
      and table_schema = 'public'
      and table_name = 'auth_session_grants'
      and privilege_type = 'UPDATE'
  ), array[]::text[]) = array['auth_user_id', 'consumed_at']::text[],
  'C032-DB-022 SessionGrant grants remain the exact TASK-013 minimal column surface'
);

select ok(
  coalesce((
    select array_agg(column_name::text order by column_name)
    from information_schema.column_privileges
    where grantee = 'supabase_auth_admin'
      and table_schema = 'public'
      and table_name = 'auth_bridge_credentials'
      and privilege_type = 'SELECT'
  ), array[]::text[]) = array['auth_user_id', 'email', 'id']::text[]
  and coalesce((
    select array_agg(column_name::text order by column_name)
    from information_schema.column_privileges
    where grantee = 'supabase_auth_admin'
      and table_schema = 'public'
      and table_name = 'auth_bridge_credentials'
      and privilege_type = 'UPDATE'
  ), array[]::text[]) = array['auth_user_id', 'bound_at']::text[],
  'C032-DB-023 bridge grants remain the exact TASK-013 minimal column surface'
);

select ok(
  (select count(*) = 4 from pg_policy where polname like 'task_013_auth_hook_%')
  and exists (
    select 1
    from pg_policy
    where polname = 'task_013_auth_hook_bind_bridge_credentials'
      and polrelid = 'public.auth_bridge_credentials'::regclass
      and lower(pg_get_expr(polqual, polrelid)) like '%auth_user_id is null%'
      and lower(pg_get_expr(polqual, polrelid)) like '%bound_at is null%'
  ),
  'C032-DB-024 CORR-032 preserves the four narrow TASK-013 RLS policies'
);

set local role supabase_auth_admin;
do $$
begin
  perform set_config(
    'corr032.rebind_count',
    pg_temp.corr032_statement_row_count($statement$
      update public.auth_bridge_credentials
      set auth_user_id = '32000000-0000-4000-8000-000000000002',
          bound_at = clock_timestamp()
      where id = '32000000-0000-4000-8300-000000000002'
    $statement$)::text,
    true
  );
end $$;
reset role;

select is(
  current_setting('corr032.rebind_count')::bigint,
  0::bigint,
  'C032-DB-025 bound bridge remains non-rebindable by the Hook role'
);

select ok(
  (select
    position('IF V_BRIDGE.AUTH_USER_ID IS NULL THEN' in upper(pg_get_functiondef(oid))) > 0
    and position('WHERE ID = V_GRANT.AUTH_BRIDGE_CREDENTIAL_ID;' in upper(pg_get_functiondef(oid))) > 0
    and regexp_count(upper(pg_get_functiondef(oid)), 'FOR UPDATE') = 2
   from pg_proc
   where oid = 'public.task_013_custom_access_token_hook(jsonb)'::regprocedure),
  'C032-DB-026 Hook separates plain bound validation from unbound binding lock'
);

select * from finish();

rollback;
