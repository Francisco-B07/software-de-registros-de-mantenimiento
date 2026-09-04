\set ON_ERROR_STOP on

begin;

select plan(33);

select has_column(
  'public',
  'platform_users',
  'is_super_admin',
  'T014-DB-001 is_super_admin exists'
);
select col_type_is(
  'public',
  'platform_users',
  'is_super_admin',
  'boolean',
  'T014-DB-002 is_super_admin is boolean'
);
select col_not_null(
  'public',
  'platform_users',
  'is_super_admin',
  'T014-DB-003 is_super_admin is NOT NULL'
);
select col_default_is(
  'public',
  'platform_users',
  'is_super_admin',
  'false',
  'T014-DB-004 is_super_admin defaults to false'
);
select ok(
  not exists (
    select 1 from public.platform_users where is_super_admin
  ),
  'T014-DB-005 no pre-existing PlatformUser is promoted'
);

insert into auth.users (id)
values
  ('94000000-0000-4000-8000-000000000001'),
  ('94000000-0000-4000-8000-000000000002'),
  ('94000000-0000-4000-8000-000000000003'),
  ('94000000-0000-4000-8000-000000000004'),
  ('94000000-0000-4000-8000-000000000005'),
  ('94000000-0000-4000-8000-000000000006'),
  ('94000000-0000-4000-8000-000000000007');

insert into public.maintenance_companies (id)
values ('00000000-0000-4000-8000-000000014001');

insert into public.platform_users (id)
values
  ('00000000-0000-4000-8000-000000014101'),
  ('00000000-0000-4000-8000-000000014102'),
  ('00000000-0000-4000-8000-000000014103'),
  ('00000000-0000-4000-8000-000000014104'),
  ('00000000-0000-4000-8000-000000014105'),
  ('00000000-0000-4000-8000-000000014106');

select ok(
  not exists (
    select 1 from public.platform_users where is_super_admin
  ),
  'T014-DB-006 omitted fixture values remain false by default'
);

update public.platform_users
set is_super_admin = true
where id in (
  '00000000-0000-4000-8000-000000014101',
  '00000000-0000-4000-8000-000000014102',
  '00000000-0000-4000-8000-000000014103'
);

insert into public.platform_user_auth_subjects (
  auth_subject_id,
  platform_user_id
)
values
  ('94000000-0000-4000-8000-000000000001', '00000000-0000-4000-8000-000000014101'),
  ('94000000-0000-4000-8000-000000000002', '00000000-0000-4000-8000-000000014102'),
  ('94000000-0000-4000-8000-000000000003', '00000000-0000-4000-8000-000000014103'),
  ('94000000-0000-4000-8000-000000000004', '00000000-0000-4000-8000-000000014104'),
  ('94000000-0000-4000-8000-000000000005', '00000000-0000-4000-8000-000000014105'),
  ('94000000-0000-4000-8000-000000000006', '00000000-0000-4000-8000-000000014106');

insert into public.company_memberships (
  id,
  platform_user_id,
  maintenance_company_id,
  role,
  is_enabled
)
values
  ('00000000-0000-4000-8000-000000014202', '00000000-0000-4000-8000-000000014102', '00000000-0000-4000-8000-000000014001', 'COMPANY_ADMIN', true),
  ('00000000-0000-4000-8000-000000014203', '00000000-0000-4000-8000-000000014103', '00000000-0000-4000-8000-000000014001', 'TECHNICIAN', false),
  ('00000000-0000-4000-8000-000000014205', '00000000-0000-4000-8000-000000014105', '00000000-0000-4000-8000-000000014001', 'TECHNICIAN', true),
  ('00000000-0000-4000-8000-000000014206', '00000000-0000-4000-8000-000000014106', '00000000-0000-4000-8000-000000014001', 'TECHNICIAN', false);

select is(
  (
    select count(*)
    from pg_proc
    where pronamespace = 'public'::regnamespace
      and proname = 'resolve_current_global_authority'
  ),
  1::bigint,
  'T014-DB-007 exactly one RPC overload exists'
);
select is(
  (
    select pronargs
    from pg_proc
    where oid = 'public.resolve_current_global_authority()'::regprocedure
  ),
  0::smallint,
  'T014-DB-008 RPC has zero business identity arguments'
);
select ok(
  (
    select prosecdef
    from pg_proc
    where oid = 'public.resolve_current_global_authority()'::regprocedure
  ),
  'T014-DB-009 RPC is SECURITY DEFINER'
);
select is(
  (
    select provolatile::text
    from pg_proc
    where oid = 'public.resolve_current_global_authority()'::regprocedure
  ),
  's'::text,
  'T014-DB-010 RPC is read-only STABLE'
);
select is(
  (
    select pg_get_userbyid(proowner)
    from pg_proc
    where oid = 'public.resolve_current_global_authority()'::regprocedure
  ),
  'postgres',
  'T014-DB-011 RPC owner is postgres'
);
select is(
  (
    select array_to_string(proconfig, ',')
    from pg_proc
    where oid = 'public.resolve_current_global_authority()'::regprocedure
  ),
  'search_path=""',
  'T014-DB-012 RPC has an empty fixed search_path'
);
select is(
  pg_get_function_result('public.resolve_current_global_authority()'::regprocedure),
  'TABLE(identity_resolved boolean, is_super_admin boolean, has_company_membership boolean)',
  'T014-DB-013 RPC output is the exact minimal boolean shape'
);
select ok(
  not exists (
    select 1
    from pg_proc as function_definition
    cross join lateral aclexplode(
      coalesce(
        function_definition.proacl,
        acldefault('f', function_definition.proowner)
      )
    ) as privilege
    where function_definition.oid =
      'public.resolve_current_global_authority()'::regprocedure
      and privilege.grantee = 0
      and privilege.privilege_type = 'EXECUTE'
  ),
  'T014-DB-014 PUBLIC cannot execute the RPC'
);
select ok(
  not has_function_privilege(
    'anon',
    'public.resolve_current_global_authority()',
    'EXECUTE'
  ),
  'T014-DB-015 anon cannot execute the RPC'
);
select ok(
  has_function_privilege(
    'authenticated',
    'public.resolve_current_global_authority()',
    'EXECUTE'
  ),
  'T014-DB-016 authenticated has the minimum RPC EXECUTE privilege'
);
select ok(
  not has_function_privilege(
    'service_role',
    'public.resolve_current_global_authority()',
    'EXECUTE'
  )
  and not has_function_privilege(
    'supabase_auth_admin',
    'public.resolve_current_global_authority()',
    'EXECUTE'
  ),
  'T014-DB-017 no privileged application role receives RPC execution'
);
select ok(
  not has_table_privilege('authenticated', 'public.platform_users', 'UPDATE'),
  'T014-DB-018 authenticated receives no authority write privilege'
);

set local role anon;
select throws_ok(
  $$select * from public.resolve_current_global_authority()$$,
  '42501',
  null,
  'T014-DB-019 anon execution is denied in practice'
);

reset role;

set local role authenticated;
select set_config('request.jwt.claim.sub', '', true);

select ok(
  not (select identity_resolved from public.resolve_current_global_authority()),
  'T014-DB-020 missing auth.uid is unresolved'
);

select set_config(
  'request.jwt.claim.sub',
  '94000000-0000-4000-8000-000000000007',
  true
);
select ok(
  not (select identity_resolved from public.resolve_current_global_authority()),
  'T014-DB-021 missing PlatformUser mapping is unresolved'
);

select set_config('request.jwt.claim.sub', '94000000-0000-4000-8000-000000000001', true);
select ok(
  (select identity_resolved and is_super_admin and not has_company_membership
   from public.resolve_current_global_authority()),
  'T014-DB-022 true plus no membership classifies as global'
);

select set_config('request.jwt.claim.sub', '94000000-0000-4000-8000-000000000002', true);
select ok(
  (select identity_resolved and is_super_admin and has_company_membership
   from public.resolve_current_global_authority()),
  'T014-DB-023 true plus enabled membership exposes the inconsistent booleans'
);

select set_config('request.jwt.claim.sub', '94000000-0000-4000-8000-000000000003', true);
select ok(
  (select identity_resolved and is_super_admin and has_company_membership
   from public.resolve_current_global_authority()),
  'T014-DB-024 true plus disabled membership exposes the inconsistent booleans'
);

select set_config('request.jwt.claim.sub', '94000000-0000-4000-8000-000000000004', true);
select ok(
  (select identity_resolved and not is_super_admin and not has_company_membership
   from public.resolve_current_global_authority()),
  'T014-DB-025 false plus no membership is not global'
);

select set_config('request.jwt.claim.sub', '94000000-0000-4000-8000-000000000005', true);
select ok(
  (select identity_resolved and not is_super_admin and has_company_membership
   from public.resolve_current_global_authority()),
  'T014-DB-026 false plus enabled membership is not global'
);

select set_config('request.jwt.claim.sub', '94000000-0000-4000-8000-000000000006', true);
select ok(
  (select identity_resolved and not is_super_admin and has_company_membership
   from public.resolve_current_global_authority()),
  'T014-DB-027 false plus disabled membership is not global'
);
select is(
  (select count(*) from public.company_memberships),
  0::bigint,
  'T014-DB-028 disabled membership remains invisible through ordinary RLS'
);
select ok(
  (select has_company_membership
   from public.resolve_current_global_authority()),
  'T014-DB-029 purpose-specific RPC still detects disabled membership existence'
);

select set_config('request.jwt.claim.sub', '94000000-0000-4000-8000-000000000001', true);
select ok(
  (select is_super_admin and not has_company_membership
   from public.resolve_current_global_authority()),
  'T014-DB-030 caller A cannot select caller B as a target'
);
select throws_ok(
  $$update public.platform_users set is_super_admin = false where id = '00000000-0000-4000-8000-000000014101'$$,
  '42501',
  null,
  'T014-DB-031 authenticated cannot mutate is_super_admin'
);

reset role;

select ok(
  (select count(*) from public.platform_users where is_super_admin) = 3
  and (select count(*) from public.company_memberships) = 4,
  'T014-DB-032 RPC calls are read-only'
);
select ok(
  (
    select count(*) = 1
      and bool_and(cmd = 'SELECT')
      and bool_and(qual ilike '%is_enabled%')
    from pg_policies
    where schemaname = 'public'
      and tablename = 'company_memberships'
  ),
  'T014-DB-033 ordinary company_memberships RLS remains unchanged'
);

select * from finish();

rollback;
