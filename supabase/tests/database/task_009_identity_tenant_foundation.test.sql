\set ON_ERROR_STOP on

\set task_009_use_external_auth_fixtures false

\if :{?task_009_user_a_id}
  \if :{?task_009_user_b_id}
    \if :{?task_009_user_c_id}
      \set task_009_use_external_auth_fixtures true
    \endif
  \endif
\endif

\if :task_009_use_external_auth_fixtures
\else
  \set task_009_user_a_id '90000000-0000-4000-8000-000000000901'
  \set task_009_user_b_id '90000000-0000-4000-8000-000000000902'
  \set task_009_user_c_id '90000000-0000-4000-8000-000000000903'
\endif

begin;

select plan(33);

-- Every privileged mutation in this file is isolated Development test setup.
-- It implements no product flow and satisfies no AuditEvent duty. Future
-- functional identity and membership flows retain their AuditEvent duties.
\if :task_009_use_external_auth_fixtures
  select count(*) = 3 and count(distinct id) = 3
    as task_009_auth_fixtures_valid
  from auth.users
  where id in (
    :'task_009_user_a_id'::uuid,
    :'task_009_user_b_id'::uuid,
    :'task_009_user_c_id'::uuid
  )
  \gset

  \if :task_009_auth_fixtures_valid
  \else
    \echo 'Expected three distinct disposable Auth subjects in Development.'
    \quit 3
  \endif
\else
  insert into auth.users (id)
  values
    (:'task_009_user_a_id'::uuid),
    (:'task_009_user_b_id'::uuid),
    (:'task_009_user_c_id'::uuid);
\endif

insert into public.maintenance_companies (id)
values
  ('00000000-0000-4000-8000-00000000c001'),
  ('00000000-0000-4000-8000-00000000c002');

insert into public.platform_users (id)
values
  ('00000000-0000-4000-8000-00000000a001'),
  ('00000000-0000-4000-8000-00000000b001'),
  ('00000000-0000-4000-8000-00000000c001');

insert into public.platform_user_auth_subjects (
  auth_subject_id,
  platform_user_id
)
values
  (
    :'task_009_user_a_id'::uuid,
    '00000000-0000-4000-8000-00000000a001'
  ),
  (
    :'task_009_user_b_id'::uuid,
    '00000000-0000-4000-8000-00000000b001'
  ),
  (
    :'task_009_user_c_id'::uuid,
    '00000000-0000-4000-8000-00000000c001'
  );

insert into public.company_memberships (
  id,
  platform_user_id,
  maintenance_company_id,
  role,
  is_enabled
)
values
  (
    '00000000-0000-4000-8000-00000000a002',
    '00000000-0000-4000-8000-00000000a001',
    '00000000-0000-4000-8000-00000000c001',
    'COMPANY_ADMIN',
    true
  ),
  (
    '00000000-0000-4000-8000-00000000b002',
    '00000000-0000-4000-8000-00000000b001',
    '00000000-0000-4000-8000-00000000c002',
    'TECHNICIAN',
    true
  );

select set_config('task_009.user_a_id', :'task_009_user_a_id', true)
  as task_009_set_user_a
\gset

select throws_ok(
  $$
    insert into public.platform_user_auth_subjects (
      auth_subject_id,
      platform_user_id
    ) values (
      current_setting('task_009.user_a_id')::uuid,
      '00000000-0000-4000-8000-00000000b001'
    )
  $$,
  '23505',
  null,
  'T009-DB-001 an Auth subject cannot map to two PlatformUsers'
);

select ok(
  not exists (
    select 1
    from pg_constraint as constraint_definition
    join pg_attribute as constrained_column
      on constrained_column.attrelid = constraint_definition.conrelid
     and constrained_column.attnum = any (constraint_definition.conkey)
    where constraint_definition.conrelid =
      'public.platform_user_auth_subjects'::regclass
      and constraint_definition.contype in ('p', 'u')
      and constrained_column.attname = 'platform_user_id'
  ),
  'T009-DB-002 inverse PlatformUser cardinality remains open'
);

select throws_ok(
  $$
    insert into public.company_memberships (
      id,
      platform_user_id,
      maintenance_company_id,
      role,
      is_enabled
    ) values (
      '00000000-0000-4000-8000-00000000a003',
      '00000000-0000-4000-8000-00000000a001',
      '00000000-0000-4000-8000-00000000c002',
      'TECHNICIAN',
      true
    )
  $$,
  '23505',
  null,
  'T009-DB-003 a PlatformUser cannot have two memberships'
);

select throws_ok(
  $$
    insert into public.company_memberships (
      id,
      platform_user_id,
      maintenance_company_id,
      role,
      is_enabled
    ) values (
      '00000000-0000-4000-8000-00000000c002',
      '00000000-0000-4000-8000-00000000c001',
      '00000000-0000-4000-8000-00000000ffff',
      'TECHNICIAN',
      true
    )
  $$,
  '23503',
  null,
  'T009-DB-004 a membership cannot reference a nonexistent tenant'
);

select throws_ok(
  $$
    insert into public.company_memberships (
      id,
      platform_user_id,
      maintenance_company_id,
      role,
      is_enabled
    ) values (
      '00000000-0000-4000-8000-00000000c003',
      '00000000-0000-4000-8000-00000000ffff',
      '00000000-0000-4000-8000-00000000c001',
      'TECHNICIAN',
      true
    )
  $$,
  '23503',
  null,
  'T009-DB-005 a membership cannot reference a nonexistent PlatformUser'
);

select throws_ok(
  $$
    insert into public.company_memberships (
      id,
      platform_user_id,
      maintenance_company_id,
      role,
      is_enabled
    ) values (
      '00000000-0000-4000-8000-00000000e001',
      '00000000-0000-4000-8000-00000000c001',
      '00000000-0000-4000-8000-00000000c001',
      'SUPER_ADMIN',
      true
    )
  $$,
  '23514',
  null,
  'T009-DB-006a SUPER_ADMIN is not a tenant role'
);

select throws_ok(
  $$
    insert into public.company_memberships (
      id,
      platform_user_id,
      maintenance_company_id,
      role,
      is_enabled
    ) values (
      '00000000-0000-4000-8000-00000000e002',
      '00000000-0000-4000-8000-00000000c001',
      '00000000-0000-4000-8000-00000000c001',
      'UNKNOWN',
      true
    )
  $$,
  '23514',
  null,
  'T009-DB-006b UNKNOWN is not a tenant role'
);

select throws_ok(
  $$
    insert into public.platform_user_auth_subjects (
      auth_subject_id,
      platform_user_id
    ) values (
      '00000000-0000-4000-8000-00000000ffff',
      '00000000-0000-4000-8000-00000000c001'
    )
  $$,
  '23503',
  null,
  'T009-DB-007 a nonexistent Auth subject is rejected by the FK'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', :'task_009_user_a_id', true)
  as task_009_set_subject
\gset

select is(
  (
    select count(*)
    from public.platform_user_auth_subjects
    where auth_subject_id = :'task_009_user_a_id'::uuid
  ),
  1::bigint,
  'T009-RLS-001 Subject A reads its own Auth mapping'
);

select is(
  (
    select count(*)
    from public.platform_user_auth_subjects
    where auth_subject_id <> :'task_009_user_a_id'::uuid
  ),
  0::bigint,
  'T009-RLS-002 Subject A cannot read any other Auth mapping'
);

select is(
  (
    select count(*)
    from public.platform_users
    where id = '00000000-0000-4000-8000-00000000a001'::uuid
  ),
  1::bigint,
  'T009-RLS-003 Subject A reads its own PlatformUser'
);

select is(
  (
    select count(*)
    from public.platform_users
    where id <> '00000000-0000-4000-8000-00000000a001'::uuid
  ),
  0::bigint,
  'T009-RLS-004 Subject A cannot enumerate any other PlatformUser'
);

select is(
  (select id from public.company_memberships limit 1),
  '00000000-0000-4000-8000-00000000a002'::uuid,
  'T009-RLS-005 User A reads its enabled membership'
);

select is(
  (
    select count(*)
    from public.company_memberships
    where id = '00000000-0000-4000-8000-00000000b002'
  ),
  0::bigint,
  'T009-RLS-006 User A cannot read User B membership'
);

select is(
  (select id from public.maintenance_companies limit 1),
  '00000000-0000-4000-8000-00000000c001'::uuid,
  'T009-RLS-007 User A reads MaintenanceCompany A'
);

select is(
  (
    select count(*)
    from public.maintenance_companies
    where id = '00000000-0000-4000-8000-00000000c002'
  ),
  0::bigint,
  'T009-RLS-008 a known foreign tenant UUID remains invisible'
);

select is(
  (
    select count(*)
    from public.company_memberships
    where maintenance_company_id =
      '00000000-0000-4000-8000-00000000c002'
  ),
  0::bigint,
  'T009-RLS-009 filtering by Tenant B does not make it authoritative'
);

select throws_ok(
  $$insert into public.maintenance_companies (id) values ('00000000-0000-4000-8000-00000000d001')$$,
  '42501', null,
  'T009-RLS-014a authenticated cannot insert MaintenanceCompany'
);
select throws_ok(
  $$insert into public.platform_users (id) values ('00000000-0000-4000-8000-00000000d002')$$,
  '42501', null,
  'T009-RLS-014b authenticated cannot insert PlatformUser'
);
select throws_ok(
  $$insert into public.platform_user_auth_subjects (auth_subject_id, platform_user_id) values (current_setting('request.jwt.claim.sub')::uuid, '00000000-0000-4000-8000-00000000a001')$$,
  '42501', null,
  'T009-RLS-014c authenticated cannot insert Auth mapping'
);
select throws_ok(
  $$insert into public.company_memberships (id, platform_user_id, maintenance_company_id, role, is_enabled) values ('00000000-0000-4000-8000-00000000d003', '00000000-0000-4000-8000-00000000c001', '00000000-0000-4000-8000-00000000c001', 'TECHNICIAN', true)$$,
  '42501', null,
  'T009-RLS-014d authenticated cannot insert membership'
);

select throws_ok(
  $$update public.maintenance_companies set id = id where id = '00000000-0000-4000-8000-00000000c001'$$,
  '42501', null,
  'T009-RLS-015a authenticated cannot update MaintenanceCompany'
);
select throws_ok(
  $$update public.platform_users set id = id where id = '00000000-0000-4000-8000-00000000a001'$$,
  '42501', null,
  'T009-RLS-015b authenticated cannot update PlatformUser'
);
select throws_ok(
  $$update public.platform_user_auth_subjects set platform_user_id = platform_user_id where auth_subject_id = current_setting('request.jwt.claim.sub')::uuid$$,
  '42501', null,
  'T009-RLS-015c authenticated cannot update Auth mapping'
);
select throws_ok(
  $$update public.company_memberships set role = 'TECHNICIAN', is_enabled = false where id = '00000000-0000-4000-8000-00000000a002'$$,
  '42501', null,
  'T009-RLS-015d authenticated cannot update role or membership state'
);

select throws_ok(
  $$delete from public.maintenance_companies where id = '00000000-0000-4000-8000-00000000c001'$$,
  '42501', null,
  'T009-RLS-016a authenticated cannot delete MaintenanceCompany'
);
select throws_ok(
  $$delete from public.platform_users where id = '00000000-0000-4000-8000-00000000a001'$$,
  '42501', null,
  'T009-RLS-016b authenticated cannot delete PlatformUser'
);
select throws_ok(
  $$delete from public.platform_user_auth_subjects where auth_subject_id = current_setting('request.jwt.claim.sub')::uuid$$,
  '42501', null,
  'T009-RLS-016c authenticated cannot delete Auth mapping'
);
select throws_ok(
  $$delete from public.company_memberships where id = '00000000-0000-4000-8000-00000000a002'$$,
  '42501', null,
  'T009-RLS-016d authenticated cannot delete membership'
);

reset role;
update public.company_memberships
set is_enabled = false
where id = '00000000-0000-4000-8000-00000000a002';

set local role authenticated;
select set_config('request.jwt.claim.sub', :'task_009_user_a_id', true)
  as task_009_set_subject
\gset

select is(
  (select count(*) from public.company_memberships),
  0::bigint,
  'T009-RLS-010 disabled membership is immediately invisible'
);
select is(
  (select count(*) from public.maintenance_companies),
  0::bigint,
  'T009-RLS-011 tenant access does not survive authoritative disable'
);

reset role;
update public.company_memberships
set role = 'TECHNICIAN', is_enabled = true
where id = '00000000-0000-4000-8000-00000000a002';

set local role authenticated;
select set_config('request.jwt.claim.sub', :'task_009_user_a_id', true)
  as task_009_set_subject
\gset
select set_config('request.jwt.claim.tenant_role', 'COMPANY_ADMIN', true)
  as task_009_set_stale_role
\gset

select is(
  (select role from public.company_memberships where id = '00000000-0000-4000-8000-00000000a002'),
  'TECHNICIAN',
  'T009-RLS-012 current DB role overrides a stale custom role claim'
);

select set_config('request.jwt.claim.sub', :'task_009_user_c_id', true)
  as task_009_set_subject
\gset
select is(
  (select count(*) from public.maintenance_companies),
  0::bigint,
  'T009-RLS-013 a recognized subject without membership fails closed'
);

reset role;

select * from finish();

rollback;
