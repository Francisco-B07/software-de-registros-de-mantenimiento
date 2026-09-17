\set ON_ERROR_STOP on

begin;

select plan(52);

insert into auth.users (id)
values
  ('96000000-0000-4000-8000-000000000001'),
  ('96000000-0000-4000-8000-000000000002'),
  ('96000000-0000-4000-8000-000000000003'),
  ('96000000-0000-4000-8000-000000000004'),
  ('96000000-0000-4000-8000-000000000005'),
  ('96000000-0000-4000-8000-000000000006'),
  ('96000000-0000-4000-8000-000000000007'),
  ('96000000-0000-4000-8000-000000000008');

insert into public.maintenance_companies (id)
values
  ('16000000-0000-4000-8000-000000009001'),
  ('16000000-0000-4000-8000-000000009999');

insert into public.platform_users (id, is_super_admin)
values
  ('16000000-0000-4000-8000-000000000101', true),
  ('16000000-0000-4000-8000-000000000102', false),
  ('16000000-0000-4000-8000-000000000103', false),
  ('16000000-0000-4000-8000-000000000104', false),
  ('16000000-0000-4000-8000-000000000106', true),
  ('16000000-0000-4000-8000-000000000107', true),
  ('16000000-0000-4000-8000-000000000108', true);

insert into public.platform_user_auth_subjects (
  auth_subject_id,
  platform_user_id
)
values
  ('96000000-0000-4000-8000-000000000001', '16000000-0000-4000-8000-000000000101'),
  ('96000000-0000-4000-8000-000000000002', '16000000-0000-4000-8000-000000000102'),
  ('96000000-0000-4000-8000-000000000003', '16000000-0000-4000-8000-000000000103'),
  ('96000000-0000-4000-8000-000000000004', '16000000-0000-4000-8000-000000000104'),
  ('96000000-0000-4000-8000-000000000006', '16000000-0000-4000-8000-000000000106'),
  ('96000000-0000-4000-8000-000000000007', '16000000-0000-4000-8000-000000000107'),
  ('96000000-0000-4000-8000-000000000008', '16000000-0000-4000-8000-000000000108');

insert into public.company_memberships (
  id,
  platform_user_id,
  maintenance_company_id,
  role,
  is_enabled
)
values
  ('16000000-0000-4000-8000-000000001103', '16000000-0000-4000-8000-000000000103', '16000000-0000-4000-8000-000000009001', 'COMPANY_ADMIN', true),
  ('16000000-0000-4000-8000-000000001104', '16000000-0000-4000-8000-000000000104', '16000000-0000-4000-8000-000000009001', 'TECHNICIAN', true),
  ('16000000-0000-4000-8000-000000001106', '16000000-0000-4000-8000-000000000106', '16000000-0000-4000-8000-000000009001', 'COMPANY_ADMIN', true),
  ('16000000-0000-4000-8000-000000001107', '16000000-0000-4000-8000-000000000107', '16000000-0000-4000-8000-000000009001', 'TECHNICIAN', false);

create temporary table task016_results (
  label text primary key,
  outcome text not null,
  changed boolean not null,
  maintenance_company_id uuid,
  reason text not null
);
grant select, insert on task016_results to authenticated;

create temporary table task016_baseline as
select
  (select count(*) from public.platform_users) as platform_user_count,
  (select count(*) from public.company_memberships) as membership_count,
  (select count(*) from public.verification_challenges) as challenge_count,
  (select count(*) from public.audit_events) as audit_event_count;

set local role authenticated;

select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000001', true);
insert into task016_results
select 'auth001', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000010001') as result;

select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000002', true);
insert into task016_results
select 'auth002', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000010002') as result;

select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000003', true);
insert into task016_results
select 'auth003', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000010003') as result;

select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000004', true);
insert into task016_results
select 'auth004', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000010004') as result;

select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000005', true);
insert into task016_results
select 'auth005', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000010005') as result;

select set_config('request.jwt.claim.sub', '', true);
insert into task016_results
select 'auth006', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000010006') as result;

select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000006', true);
insert into task016_results
select 'auth007', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000010007') as result;

select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000007', true);
insert into task016_results
select 'auth008', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000010008') as result;

select set_config('request.jwt.claim.role', 'SUPER_ADMIN', true);
select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000002', true);
insert into task016_results
select 'auth009', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000010009') as result;

select set_config('request.jwt.claim.role', '', true);
select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000008', true);
insert into task016_results
select 'auth010', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000010010') as result;

select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000002', true);
insert into task016_results
select 'auth011', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000010011') as result;

reset role;

select ok(
  (select outcome = 'CREATED' and changed from task016_results where label = 'auth001'),
  'T016-AUTH-001 current valid global SUPER_ADMIN without membership can create'
);
select is((select outcome from task016_results where label = 'auth002'), 'DENIED', 'T016-AUTH-002 DB false denies');
select is((select outcome from task016_results where label = 'auth003'), 'DENIED', 'T016-AUTH-003 COMPANY_ADMIN denies');
select is((select outcome from task016_results where label = 'auth004'), 'DENIED', 'T016-AUTH-004 TECHNICIAN denies');
select is((select outcome from task016_results where label = 'auth005'), 'DENIED', 'T016-AUTH-005 missing PlatformUser denies');
select is((select outcome from task016_results where label = 'auth006'), 'DENIED', 'T016-AUTH-006 missing auth.uid denies');
select ok(
  (select outcome = 'DENIED' and reason = 'INCONSISTENT_AUTHORITY' from task016_results where label = 'auth007'),
  'T016-AUTH-007 global plus enabled membership denies as inconsistent'
);
select ok(
  (select outcome = 'DENIED' and reason = 'INCONSISTENT_AUTHORITY' from task016_results where label = 'auth008'),
  'T016-AUTH-008 global plus disabled membership denies as inconsistent'
);
select is((select outcome from task016_results where label = 'auth009'), 'DENIED', 'T016-AUTH-009 stale global claim cannot override DB false');
select is((select outcome from task016_results where label = 'auth010'), 'CREATED', 'T016-AUTH-010 DB true without global claim allows');
select ok(
  (select outcome = 'DENIED' and maintenance_company_id is null from task016_results where label = 'auth011')
  and pg_get_function_identity_arguments('public.create_maintenance_company(uuid)'::regprocedure) = 'p_creation_operation_id uuid',
  'T016-AUTH-011 caller-supplied authority data cannot affect the one-input RPC'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000001', true);
insert into task016_results
select 'create', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000020001') as result;
reset role;

select is(
  (select count(*) from public.maintenance_companies where creation_operation_id = '16000000-0000-4000-8000-000000020001'),
  1::bigint,
  'T016-CREATE-001 authorized new operation creates exactly one row'
);
select ok(
  (select outcome = 'CREATED' and changed and reason = 'CREATED' from task016_results where label = 'create'),
  'T016-CREATE-002 result is CREATED with changed true'
);
select ok(
  (select maintenance_company_id is not null and maintenance_company_id <> '16000000-0000-4000-8000-000000020001' from task016_results where label = 'create'),
  'T016-CREATE-003 company ID is a generated UUID distinct from the operation ID'
);
select ok(
  exists (
    select 1
    from public.maintenance_companies as company
    join task016_results as result
      on result.maintenance_company_id = company.id
    where result.label = 'create'
      and company.creation_operation_id = '16000000-0000-4000-8000-000000020001'
  ),
  'T016-CREATE-004 persisted operation ID matches the input'
);
select is(
  (select count(*) from public.company_memberships),
  (select membership_count from task016_baseline),
  'T016-CREATE-005 creation produces no CompanyMembership'
);
select is(
  (select count(*) from public.platform_users),
  (select platform_user_count from task016_baseline),
  'T016-CREATE-006 creation produces no PlatformUser'
);
select ok(to_regclass('public.user_client_accesses') is null, 'T016-CREATE-007 creation produces no UserClientAccess');
select ok(to_regclass('public.support_access_grants') is null, 'T016-CREATE-008 creation produces no SupportAccessGrant');
select is(
  (select count(*) from public.verification_challenges),
  (select challenge_count from task016_baseline),
  'T016-CREATE-009 creation produces no VerificationChallenge'
);
select is(
  (select count(*) from public.audit_events),
  (select audit_event_count from task016_baseline),
  'T016-CREATE-010 creation produces no AuditEvent'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000001', true);
insert into task016_results
select 'idem-first', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000030001') as result;
insert into task016_results
select 'idem-retry', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000030001') as result;
insert into task016_results
select 'idem-distinct-a', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000030002') as result;
insert into task016_results
select 'idem-distinct-b', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000030003') as result;
insert into task016_results
select 'idem-null', result.*
from public.create_maintenance_company(null) as result;
reset role;

select ok(
  (select maintenance_company_id from task016_results where label = 'idem-first') =
  (select maintenance_company_id from task016_results where label = 'idem-retry'),
  'T016-IDEM-001 same operation retry returns the same company'
);
select ok(
  (select outcome = 'ALREADY_CREATED' and not changed from task016_results where label = 'idem-retry'),
  'T016-IDEM-002 same operation retry is ALREADY_CREATED with changed false'
);
select is(
  (select count(*) from public.maintenance_companies where creation_operation_id = '16000000-0000-4000-8000-000000030001'),
  1::bigint,
  'T016-IDEM-003 same operation row count remains one'
);
select ok(
  (select bool_and(outcome = 'CREATED') from task016_results where label in ('idem-distinct-a', 'idem-distinct-b'))
  and (select count(distinct maintenance_company_id) = 2 from task016_results where label in ('idem-distinct-a', 'idem-distinct-b')),
  'T016-IDEM-004 distinct operation IDs create two distinct companies'
);
select ok(
  exists (
    select 1 from public.maintenance_companies
    where id = '16000000-0000-4000-8000-000000009999'
      and creation_operation_id is null
  ),
  'T016-IDEM-005 pre-TASK-016 row with NULL operation ID remains valid'
);
select ok(
  not exists (
    select 1
    from public.maintenance_companies
    where id in (
      '16000000-0000-4000-8000-000000009001',
      '16000000-0000-4000-8000-000000009999'
    )
      and creation_operation_id is not null
  ),
  'T016-IDEM-006 migration manufactures no historical operation IDs'
);
select ok(
  (select outcome = 'DENIED' and reason = 'INVALID_INPUT' from task016_results where label = 'idem-null')
  and not exists (
    select 1 from public.maintenance_companies where creation_operation_id is null and id not in (
      '16000000-0000-4000-8000-000000009001',
      '16000000-0000-4000-8000-000000009999'
    )
  ),
  'T016-IDEM-007 invalid operation ID creates no row'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000008', true);
insert into task016_results
select 'idem-revoke-first', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000030008') as result;
reset role;
update public.platform_users
set is_super_admin = false
where id = '16000000-0000-4000-8000-000000000108';
set local role authenticated;
select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000008', true);
insert into task016_results
select 'idem-revoke-retry', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000030008') as result;
reset role;

select ok(
  (select outcome = 'CREATED' from task016_results where label = 'idem-revoke-first')
  and (select outcome = 'DENIED' and maintenance_company_id is null from task016_results where label = 'idem-revoke-retry')
  and (select count(*) = 1 from public.maintenance_companies where creation_operation_id = '16000000-0000-4000-8000-000000030008'),
  'T016-IDEM-008 revoked DB authority makes same-operation retry DENIED without mutation'
);

set local role authenticated;
select throws_ok(
  $$insert into public.maintenance_companies (id, creation_operation_id) values ('16000000-0000-4000-8000-000000008001', '16000000-0000-4000-8000-000000008001')$$,
  '42501',
  null,
  'T016-RLS-001 direct authenticated INSERT remains denied'
);
reset role;

set local role anon;
select throws_ok(
  $$select * from public.create_maintenance_company('16000000-0000-4000-8000-000000040002')$$,
  '42501',
  null,
  'T016-RLS-002 anon cannot execute the RPC'
);
reset role;

select ok(
  not exists (
    select 1
    from pg_proc as function_definition
    cross join lateral aclexplode(coalesce(function_definition.proacl, acldefault('f', function_definition.proowner))) as privilege
    where function_definition.oid = 'public.create_maintenance_company(uuid)'::regprocedure
      and privilege.grantee = 0
      and privilege.privilege_type = 'EXECUTE'
  ),
  'T016-RLS-003 PUBLIC has no EXECUTE'
);
select ok(
  has_function_privilege('authenticated', 'public.create_maintenance_company(uuid)', 'EXECUTE')
  and not has_table_privilege('authenticated', 'public.maintenance_companies', 'INSERT'),
  'T016-RLS-004 authenticated has exact RPC EXECUTE and no table INSERT'
);
select is(
  (select array_to_string(proconfig, ',') from pg_proc where oid = 'public.create_maintenance_company(uuid)'::regprocedure),
  'search_path=""',
  'T016-RLS-005 RPC has an empty fixed search_path'
);
select is(
  (select count(*) from pg_proc where pronamespace = 'public'::regnamespace and proname = 'create_maintenance_company'),
  1::bigint,
  'T016-RLS-006 no privileged overload exists'
);
select ok(
  (
    select count(*) = 1 and bool_and(cmd = 'SELECT') and bool_and(qual ilike '%company_memberships%')
    from pg_policies
    where schemaname = 'public' and tablename = 'maintenance_companies'
  ),
  'T016-RLS-007 maintenance company tenant RLS remains unchanged'
);
set local role authenticated;
select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000001', true);
select is(
  (select count(*) from public.maintenance_companies where creation_operation_id = '16000000-0000-4000-8000-000000020001'),
  0::bigint,
  'T016-RLS-008 SUPER_ADMIN receives no operational read access to the created tenant'
);
reset role;
select ok(
  (
    select count(*) = 1 and bool_and(cmd = 'SELECT') and bool_and(qual ilike '%is_enabled%')
    from pg_policies
    where schemaname = 'public' and tablename = 'company_memberships'
  ),
  'T016-RLS-009 company_memberships policies remain unchanged'
);

select is(
  pg_get_function_identity_arguments('public.create_maintenance_company(uuid)'::regprocedure),
  'p_creation_operation_id uuid',
  'T016-SEC-001 caller cannot choose company ID'
);
select ok(
  pg_get_function_arguments('public.create_maintenance_company(uuid)'::regprocedure) not ilike '%actor%',
  'T016-SEC-002 caller cannot choose actor'
);
select ok(
  pg_get_function_arguments('public.create_maintenance_company(uuid)'::regprocedure) not ilike '%platform_user%',
  'T016-SEC-003 caller cannot select another PlatformUser'
);
set local role authenticated;
select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000002', true);
insert into task016_results
select 'sec-reuse', result.*
from public.create_maintenance_company('16000000-0000-4000-8000-000000020001') as result;
reset role;
select ok(
  (select outcome = 'DENIED' and maintenance_company_id is null from task016_results where label = 'sec-reuse'),
  'T016-SEC-004 knowing an operation ID grants no authority'
);
select ok(
  not has_function_privilege('service_role', 'public.create_maintenance_company(uuid)', 'EXECUTE'),
  'T016-SEC-005 service_role has no ordinary RPC path'
);
select ok(
  not exists (
    select 1 from pg_proc
    where pronamespace = 'private'::regnamespace
      and proname ilike '%create%maintenance%company%'
  ),
  'T016-SEC-006 no generic privileged helper exists'
);
select ok(
  pg_get_functiondef('public.create_maintenance_company(uuid)'::regprocedure) !~* 'secret|service[_-]?role',
  'T016-SEC-007 function introduces no secret dependency'
);
select ok(
  pg_get_functiondef('public.create_maintenance_company(uuid)'::regprocedure) !~* 'auth\.admin|auth\.users',
  'T016-SEC-008 function performs no Auth Admin operation'
);
select ok(
  pg_get_functiondef('public.create_maintenance_company(uuid)'::regprocedure) !~* 'hook|auth_session_grants|auth_bridge_credentials',
  'T016-SEC-009 function changes no Auth hook or configuration'
);
select ok(
  pg_get_functiondef('public.create_maintenance_company(uuid)'::regprocedure) !~* '\mexecute\M'
  and pg_get_functiondef('public.create_maintenance_company(uuid)'::regprocedure) !~* 'password|token|credential',
  'T016-SEC-010 function uses no dynamic SQL or secret-bearing data'
);

create function pg_temp.task016_reject_company_insert()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  raise exception using errcode = 'P0001', message = 'forced local test failure';
end;
$$;

create trigger task016_reject_company_insert
before insert on public.maintenance_companies
for each row execute function pg_temp.task016_reject_company_insert();

create function pg_temp.task016_failure_rolls_back(p_operation_id uuid)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
begin
  begin
    perform * from public.create_maintenance_company(p_operation_id);
  exception when others then
    null;
  end;

  return not exists (
    select 1
    from public.maintenance_companies
    where creation_operation_id = p_operation_id
  );
end;
$$;

set local role authenticated;
select set_config('request.jwt.claim.sub', '96000000-0000-4000-8000-000000000001', true);
select ok(
  pg_temp.task016_failure_rolls_back('16000000-0000-4000-8000-000000050001'),
  'T016-FAIL-001 DB failure before commit leaves no new row'
);
reset role;
drop trigger task016_reject_company_insert on public.maintenance_companies;

select ok(
  (select outcome = 'DENIED' from task016_results where label = 'auth005')
  and not exists (
    select 1 from public.maintenance_companies where creation_operation_id = '16000000-0000-4000-8000-000000010005'
  ),
  'T016-FAIL-002 authority lookup failure leaves no new row'
);
select ok(
  (select outcome = 'ALREADY_CREATED' from task016_results where label = 'idem-retry')
  and (select maintenance_company_id from task016_results where label = 'idem-first') =
      (select maintenance_company_id from task016_results where label = 'idem-retry'),
  'T016-FAIL-003 response-lost retry reconciles the same operation ID'
);
select throws_ok(
  $$insert into public.maintenance_companies (id, creation_operation_id) values ('16000000-0000-4000-8000-000000050004', '16000000-0000-4000-8000-000000030001')$$,
  '23505',
  null,
  'T016-FAIL-004 duplicate correlation fails closed'
);

select * from finish();

rollback;
