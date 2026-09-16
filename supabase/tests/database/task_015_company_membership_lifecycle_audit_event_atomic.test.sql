\set ON_ERROR_STOP on

begin;

select plan(93);

insert into auth.users (id)
values
  ('95000000-0000-4000-8000-000000000001'),
  ('95000000-0000-4000-8000-000000000002'),
  ('95000000-0000-4000-8000-000000000003'),
  ('95000000-0000-4000-8000-000000000004'),
  ('95000000-0000-4000-8000-000000000005'),
  ('95000000-0000-4000-8000-000000000006'),
  ('95000000-0000-4000-8000-000000000007'),
  ('95000000-0000-4000-8000-000000000008'),
  ('95000000-0000-4000-8000-000000000009'),
  ('95000000-0000-4000-8000-000000000010'),
  ('95000000-0000-4000-8000-000000000011'),
  ('95000000-0000-4000-8000-000000000012');

insert into public.maintenance_companies (id)
values
  ('15000000-0000-4000-8000-000000000001'),
  ('15000000-0000-4000-8000-000000000002');

insert into public.platform_users (id, is_super_admin)
values
  ('15000000-0000-4000-8000-000000000101', false),
  ('15000000-0000-4000-8000-000000000102', false),
  ('15000000-0000-4000-8000-000000000103', false),
  ('15000000-0000-4000-8000-000000000104', false),
  ('15000000-0000-4000-8000-000000000105', false),
  ('15000000-0000-4000-8000-000000000106', false),
  ('15000000-0000-4000-8000-000000000107', true),
  ('15000000-0000-4000-8000-000000000108', true),
  ('15000000-0000-4000-8000-000000000109', false),
  ('15000000-0000-4000-8000-000000000110', false),
  ('15000000-0000-4000-8000-000000000201', false),
  ('15000000-0000-4000-8000-000000000202', false);

insert into public.platform_user_auth_subjects (
  auth_subject_id,
  platform_user_id
)
values
  ('95000000-0000-4000-8000-000000000001', '15000000-0000-4000-8000-000000000101'),
  ('95000000-0000-4000-8000-000000000002', '15000000-0000-4000-8000-000000000102'),
  ('95000000-0000-4000-8000-000000000003', '15000000-0000-4000-8000-000000000103'),
  ('95000000-0000-4000-8000-000000000004', '15000000-0000-4000-8000-000000000104'),
  ('95000000-0000-4000-8000-000000000005', '15000000-0000-4000-8000-000000000105'),
  ('95000000-0000-4000-8000-000000000006', '15000000-0000-4000-8000-000000000106'),
  ('95000000-0000-4000-8000-000000000007', '15000000-0000-4000-8000-000000000107'),
  ('95000000-0000-4000-8000-000000000008', '15000000-0000-4000-8000-000000000108'),
  ('95000000-0000-4000-8000-000000000009', '15000000-0000-4000-8000-000000000201'),
  ('95000000-0000-4000-8000-000000000010', '15000000-0000-4000-8000-000000000202'),
  ('95000000-0000-4000-8000-000000000011', '15000000-0000-4000-8000-000000000109');

insert into public.company_memberships (
  id,
  platform_user_id,
  maintenance_company_id,
  role,
  is_enabled
)
values
  ('15000000-0000-4000-8000-000000001101', '15000000-0000-4000-8000-000000000101', '15000000-0000-4000-8000-000000000001', 'COMPANY_ADMIN', true),
  ('15000000-0000-4000-8000-000000001102', '15000000-0000-4000-8000-000000000102', '15000000-0000-4000-8000-000000000001', 'COMPANY_ADMIN', true),
  ('15000000-0000-4000-8000-000000001103', '15000000-0000-4000-8000-000000000103', '15000000-0000-4000-8000-000000000001', 'TECHNICIAN', true),
  ('15000000-0000-4000-8000-000000001104', '15000000-0000-4000-8000-000000000104', '15000000-0000-4000-8000-000000000001', 'TECHNICIAN', false),
  ('15000000-0000-4000-8000-000000001105', '15000000-0000-4000-8000-000000000105', '15000000-0000-4000-8000-000000000001', 'TECHNICIAN', true),
  ('15000000-0000-4000-8000-000000001106', '15000000-0000-4000-8000-000000000106', '15000000-0000-4000-8000-000000000001', 'COMPANY_ADMIN', false),
  ('15000000-0000-4000-8000-000000001108', '15000000-0000-4000-8000-000000000108', '15000000-0000-4000-8000-000000000001', 'COMPANY_ADMIN', true),
  ('15000000-0000-4000-8000-000000001110', '15000000-0000-4000-8000-000000000110', '15000000-0000-4000-8000-000000000001', 'COMPANY_ADMIN', false),
  ('15000000-0000-4000-8000-000000001201', '15000000-0000-4000-8000-000000000201', '15000000-0000-4000-8000-000000000002', 'COMPANY_ADMIN', true),
  ('15000000-0000-4000-8000-000000001202', '15000000-0000-4000-8000-000000000202', '15000000-0000-4000-8000-000000000002', 'TECHNICIAN', true);

select is(
  (
    select count(*)
    from pg_proc
    where pronamespace = 'public'::regnamespace
      and proname = 'apply_company_membership_lifecycle'
  ),
  1::bigint,
  'T015-DB-STATIC-001 exactly one public RPC overload exists'
);
select has_function(
  'private',
  'apply_company_membership_lifecycle',
  array['uuid', 'text', 'text'],
  'T015-DB-STATIC-002 private implementation exists'
);
select ok(
  not (
    select prosecdef
    from pg_proc
    where oid = 'public.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ),
  'T015-DB-STATIC-003 public RPC is SECURITY INVOKER'
);
select ok(
  (
    select prosecdef
    from pg_proc
    where oid = 'private.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ),
  'T015-DB-STATIC-004 private implementation is SECURITY DEFINER'
);
select is(
  (
    select array_to_string(proconfig, ',')
    from pg_proc
    where oid = 'public.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ),
  'search_path=""',
  'T015-DB-STATIC-005 public RPC has an empty fixed search_path'
);
select is(
  (
    select array_to_string(proconfig, ',')
    from pg_proc
    where oid = 'private.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ),
  'search_path=""',
  'T015-DB-STATIC-006 private implementation has an empty fixed search_path'
);
select is(
  (
    select pg_get_userbyid(proowner)
    from pg_proc
    where oid = 'private.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ),
  'postgres',
  'T015-DB-STATIC-007 private implementation owner is postgres'
);
select is(
  pg_get_function_result(
    'public.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ),
  'TABLE(outcome text, changed boolean, reason text)',
  'T015-DB-STATIC-008 RPC output is the exact minimal shape'
);
select is(
  pg_get_function_identity_arguments(
    'public.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ),
  'p_target_company_membership_id uuid, p_operation text, p_requested_role text',
  'T015-DB-STATIC-008A RPC has only the three approved business inputs'
);
select is(
  (
    select provolatile::text
    from pg_proc
    where oid = 'private.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ),
  'v',
  'T015-DB-STATIC-009 implementation is VOLATILE'
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
      'public.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
      and privilege.grantee = 0
      and privilege.privilege_type = 'EXECUTE'
  ),
  'T015-DB-STATIC-010 PUBLIC cannot execute the RPC'
);
select ok(
  not has_function_privilege(
    'anon',
    'public.apply_company_membership_lifecycle(uuid,text,text)',
    'EXECUTE'
  ),
  'T015-DB-STATIC-011 anon cannot execute the RPC'
);
select ok(
  has_function_privilege(
    'authenticated',
    'public.apply_company_membership_lifecycle(uuid,text,text)',
    'EXECUTE'
  ),
  'T015-DB-STATIC-012 authenticated can execute the RPC'
);
select ok(
  has_schema_privilege('authenticated', 'private', 'USAGE')
  and has_function_privilege(
    'authenticated',
    'private.apply_company_membership_lifecycle(uuid,text,text)',
    'EXECUTE'
  )
  and not has_schema_privilege('authenticated', 'private', 'CREATE'),
  'T015-DB-STATIC-013 authenticated has the minimum internal path'
);
select ok(
  not has_function_privilege(
    'service_role',
    'public.apply_company_membership_lifecycle(uuid,text,text)',
    'EXECUTE'
  )
  and not has_function_privilege(
    'service_role',
    'private.apply_company_membership_lifecycle(uuid,text,text)',
    'EXECUTE'
  )
  and not has_schema_privilege('service_role', 'private', 'USAGE'),
  'T015-DB-STATIC-014 service_role has no ordinary execution path'
);
select ok(
  not has_table_privilege('authenticated', 'public.company_memberships', 'UPDATE')
  and not has_table_privilege('authenticated', 'public.audit_events', 'INSERT'),
  'T015-DB-STATIC-015 direct table writes remain unavailable'
);
select ok(
  not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename in ('company_memberships', 'audit_events')
      and cmd in ('INSERT', 'UPDATE', 'DELETE', 'ALL')
  ),
  'T015-DB-STATIC-016 no direct write policy was introduced'
);

set local role anon;
select throws_ok(
  $$select * from public.apply_company_membership_lifecycle('15000000-0000-4000-8000-000000001103', 'DISABLE', null)$$,
  '42501',
  null,
  'T015-RLS-004 anon cannot execute the RPC in practice'
);
reset role;

set local role service_role;
select throws_ok(
  $$select * from public.apply_company_membership_lifecycle('15000000-0000-4000-8000-000000001103', 'DISABLE', null)$$,
  '42501',
  null,
  'TASK-015 supplemental service_role execution is denied in practice'
);
reset role;

set local role authenticated;
select set_config('request.jwt.claim.sub', '', true);
select is(
  (select outcome from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', null
  )),
  'DENIED',
  'T015-AUTH-005.a missing auth.uid leaves the actor unresolved and denied'
);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    null, 'DISABLE', null
  )),
  'INVALID_INPUT',
  'TASK-015 supplemental null target is invalid input'
);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'UNKNOWN', null
  )),
  'INVALID_INPUT',
  'TASK-015 supplemental unknown operation is invalid input'
);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'CHANGE_ROLE', 'OWNER'
  )),
  'INVALID_INPUT',
  'T015-ROLE-008 invalid custom role is denied'
);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', 'TECHNICIAN'
  )),
  'INVALID_INPUT',
  'TASK-015 supplemental role input is forbidden for DISABLE'
);

select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000005', true);
select set_config('request.jwt.claim.company_role', '', true);
select ok(
  (select outcome = 'DENIED' and not changed and reason = 'AUTHORIZATION_DENIED'
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', null
  )),
  'T015-AUTH-002.a enabled TECHNICIAN is denied DISABLE'
);
reset role;
select ok(
  (
    select role = 'TECHNICIAN' and is_enabled
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001103'
  ),
  'T015-AUTH-002.b denied DISABLE preserves the enabled TECHNICIAN target'
);
select is(
  (
    select count(*)
    from public.audit_events
    where actor_platform_user_id = '15000000-0000-4000-8000-000000000105'
      and subject_platform_user_id = '15000000-0000-4000-8000-000000000103'
      and action = 'USER_DISABLED_OR_REVOKED'
  ),
  0::bigint,
  'T015-AUTH-002.c denied DISABLE writes no matching AuditEvent'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000005', true);
select ok(
  (select outcome = 'DENIED' and not changed and reason = 'AUTHORIZATION_DENIED'
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001104', 'REINSTATE', null
  )),
  'T015-AUTH-002.d enabled TECHNICIAN is denied REINSTATE'
);
reset role;
select ok(
  (
    select role = 'TECHNICIAN' and not is_enabled
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001104'
  ),
  'T015-AUTH-002.e denied REINSTATE preserves the disabled TECHNICIAN target'
);
select is(
  (
    select count(*)
    from public.audit_events
    where actor_platform_user_id = '15000000-0000-4000-8000-000000000105'
      and subject_platform_user_id = '15000000-0000-4000-8000-000000000104'
      and action = 'USER_REINSTATED'
  ),
  0::bigint,
  'T015-AUTH-002.f denied REINSTATE writes no matching AuditEvent'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000005', true);
select ok(
  (select outcome = 'DENIED' and not changed and reason = 'AUTHORIZATION_DENIED'
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'CHANGE_ROLE', 'COMPANY_ADMIN'
  )),
  'T015-AUTH-002.g enabled TECHNICIAN is denied CHANGE_ROLE'
);
reset role;
select ok(
  (
    select role = 'TECHNICIAN' and is_enabled
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001103'
  ),
  'T015-AUTH-002.h denied CHANGE_ROLE preserves the enabled TECHNICIAN target'
);
select is(
  (
    select count(*)
    from public.audit_events
    where actor_platform_user_id = '15000000-0000-4000-8000-000000000105'
      and subject_platform_user_id = '15000000-0000-4000-8000-000000000103'
      and action = 'USER_ROLE_CHANGED'
  ),
  0::bigint,
  'T015-AUTH-002.i denied CHANGE_ROLE writes no matching AuditEvent'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000005', true);
select set_config('request.jwt.claim.company_role', 'COMPANY_ADMIN', true);
select ok(
  (select outcome = 'DENIED' and not changed and reason = 'AUTHORIZATION_DENIED'
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', null
  )),
  'T015-AUTH-009.a misleading COMPANY_ADMIN metadata does not override DB TECHNICIAN authority'
);
reset role;
select ok(
  (
    select role = 'TECHNICIAN' and is_enabled
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001103'
  ),
  'T015-AUTH-009.b misleading role metadata preserves the enabled TECHNICIAN target'
);
select is(
  (
    select count(*)
    from public.audit_events
    where actor_platform_user_id = '15000000-0000-4000-8000-000000000105'
      and subject_platform_user_id = '15000000-0000-4000-8000-000000000103'
      and action = 'USER_DISABLED_OR_REVOKED'
  ),
  0::bigint,
  'T015-AUTH-009.c misleading role metadata writes no matching AuditEvent'
);
select set_config('request.jwt.claim.company_role', '', true);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000005', true);
select set_config('request.jwt.claim.company_role', 'COMPANY_ADMIN', true);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', null
  )),
  'AUTHORIZATION_DENIED',
  'T015-AUTH-008 stale admin claim does not override DB TECHNICIAN authority'
);

select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000006', true);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001104', 'DISABLE', null
  )),
  'AUTHORIZATION_DENIED',
  'T015-AUTH-003 disabled actor is denied despite a valid session subject'
);

select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000007', true);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', null
  )),
  'AUTHORIZATION_DENIED',
  'T015-AUTH-006 global-only SUPER_ADMIN is denied'
);

select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000008', true);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', null
  )),
  'AUTHORIZATION_DENIED',
  'T015-AUTH-007 global plus tenant actor inconsistency is denied'
);

select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000011', true);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', null
  )),
  'AUTHORIZATION_DENIED',
  'T015-AUTH-004 actor without membership is denied'
);

select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000012', true);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', null
  )),
  'AUTHORIZATION_DENIED',
  'T015-AUTH-005.b auth subject without PlatformUser mapping is unresolved and denied'
);

select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000001', true);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001202', 'DISABLE', null
  )),
  'TARGET_UNAVAILABLE',
  'T015-TGT-002 cross-tenant target receives an opaque denial'
);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-999999999999', 'DISABLE', null
  )),
  'TARGET_UNAVAILABLE',
  'T015-TGT-003 nonexistent target receives the same opaque denial'
);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001108', 'DISABLE', null
  )),
  'TARGET_UNAVAILABLE',
  'T015-TGT-004 inconsistent global plus tenant target is denied opaquely'
);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001101', 'DISABLE', null
  )),
  'SELF_TARGET_NOT_ALLOWED',
  'T015-DIS-003 self-disable is denied'
);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001101', 'CHANGE_ROLE', 'COMPANY_ADMIN'
  )),
  'SELF_TARGET_NOT_ALLOWED',
  'T015-ROLE-004 self-role-change is denied even for the current role'
);
select ok(
  (select outcome = 'ALREADY_SATISFIED' and not changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001101', 'REINSTATE', null
  )),
  'T015-REI-005 enabled actor targeting self for reinstate receives a valid no-op'
);

select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000006', true);
select is(
  (select reason from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001106', 'REINSTATE', null
  )),
  'AUTHORIZATION_DENIED',
  'T015-REI-004 disabled actor cannot self-reinstate'
);

select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000009', true);
select ok(
  (select outcome = 'DENIED' and not changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001201', 'DISABLE', null
  )),
  'T015-DIS-004.a last enabled admin destructive disable is denied'
);
select ok(
  (
    select is_enabled and role = 'COMPANY_ADMIN'
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001201'
  ),
  'T015-DIS-004.b last enabled admin membership remains unchanged after disable denial'
);
reset role;
select is(
  (
    select count(*)
    from public.audit_events
    where maintenance_company_id = '15000000-0000-4000-8000-000000000002'
      and subject_platform_user_id = '15000000-0000-4000-8000-000000000201'
  ),
  0::bigint,
  'T015-DIS-004.c last enabled admin disable denial creates no AuditEvent'
);
set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000009', true);
select ok(
  (select outcome = 'DENIED' and not changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001201', 'CHANGE_ROLE', 'TECHNICIAN'
  )),
  'T015-ROLE-003.a last enabled admin destructive demotion is denied'
);
select ok(
  (
    select is_enabled and role = 'COMPANY_ADMIN'
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001201'
  ),
  'T015-ROLE-003.b last enabled admin membership remains unchanged after demotion denial'
);
reset role;
select is(
  (
    select count(*)
    from public.audit_events
    where maintenance_company_id = '15000000-0000-4000-8000-000000000002'
      and subject_platform_user_id = '15000000-0000-4000-8000-000000000201'
  ),
  0::bigint,
  'T015-ROLE-003.c last enabled admin demotion denial creates no AuditEvent'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000001', true);

select is(
  (select outcome from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', null
  )),
  'APPLIED',
  'T015-DIS-001.a enabled TECHNICIAN can be disabled'
);
reset role;

select ok(
  (
    select not is_enabled and role = 'TECHNICIAN'
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001103'
  ),
  'T015-DIS-006 disable preserves the target role'
);
select ok(
  (
    select count(*) = 1
      and bool_and(actor_kind = 'PLATFORM_USER')
      and bool_and(actor_platform_user_id = '15000000-0000-4000-8000-000000000101')
      and bool_and(action = 'USER_DISABLED_OR_REVOKED')
      and bool_and(scope_kind = 'USER')
      and bool_and(subject_platform_user_id = '15000000-0000-4000-8000-000000000103')
      and bool_and(role_before is null and role_after is null)
    from public.audit_events
    where subject_platform_user_id = '15000000-0000-4000-8000-000000000103'
  ),
  'T015-AUD-001 disable writes exactly one complete AuditEvent'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000001', true);
select ok(
  (select outcome = 'ALREADY_SATISFIED' and not changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', null
  )),
  'T015-DIS-005 duplicate disable is a no-op success'
);
reset role;
select is(
  (select count(*) from public.audit_events),
  1::bigint,
  'T015-AUD-010 no-op disable creates no duplicate event'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000001', true);
select ok(
  (select outcome = 'APPLIED' and changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'REINSTATE', null
  )),
  'T015-REI-001.a disabled TECHNICIAN can be reinstated'
);
select ok(
  (select outcome = 'ALREADY_SATISFIED' and not changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'REINSTATE', null
  )),
  'T015-REI-003 duplicate reinstate is a no-op success'
);
reset role;

select ok(
  (
    select is_enabled and role = 'TECHNICIAN'
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001103'
  ),
  'T015-REI-001.b reinstate preserves current TECHNICIAN role'
);
select is(
  (
    select count(*)
    from public.audit_events
    where subject_platform_user_id = '15000000-0000-4000-8000-000000000103'
      and action = 'USER_REINSTATED'
      and role_before is null
      and role_after is null
  ),
  1::bigint,
  'T015-AUD-002 reinstate writes one exact AuditEvent and no no-op event'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000001', true);
select ok(
  (select outcome = 'APPLIED' and changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'CHANGE_ROLE', 'COMPANY_ADMIN'
  )),
  'T015-ROLE-001.a enabled TECHNICIAN can be changed to COMPANY_ADMIN'
);
select ok(
  (select outcome = 'ALREADY_SATISFIED' and not changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'CHANGE_ROLE', 'COMPANY_ADMIN'
  )),
  'T015-ROLE-005 non-self same-role request is a no-op success'
);
select ok(
  (select outcome = 'APPLIED' and changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'CHANGE_ROLE', 'TECHNICIAN'
  )),
  'T015-ROLE-002 enabled COMPANY_ADMIN can be demoted when another admin remains'
);
reset role;

select ok(
  (
    select is_enabled and role = 'TECHNICIAN'
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001103'
  ),
  'TASK-015 supplemental role changes preserve enabled state'
);
select is(
  (
    select count(*)
    from public.audit_events
    where subject_platform_user_id = '15000000-0000-4000-8000-000000000103'
      and action = 'USER_ROLE_CHANGED'
      and role_before = 'TECHNICIAN'
      and role_after = 'COMPANY_ADMIN'
  ),
  1::bigint,
  'T015-ROLE-009.a promotion writes exact authoritative snapshots once'
);
select is(
  (
    select count(*)
    from public.audit_events
    where subject_platform_user_id = '15000000-0000-4000-8000-000000000103'
      and action = 'USER_ROLE_CHANGED'
      and role_before = 'COMPANY_ADMIN'
      and role_after = 'TECHNICIAN'
  ),
  1::bigint,
  'T015-ROLE-009.b demotion writes exact authoritative snapshots once'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000001', true);
select ok(
  (select outcome = 'APPLIED' and changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001104', 'CHANGE_ROLE', 'COMPANY_ADMIN'
  )),
  'T015-ROLE-007.a disabled TECHNICIAN can be promoted'
);
reset role;
select ok(
  (
    select not is_enabled and role = 'COMPANY_ADMIN'
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001104'
  ),
  'T015-ROLE-007.b disabled target remains disabled after promotion'
);
select is(
  (
    select count(*)
    from public.audit_events
    where subject_platform_user_id = '15000000-0000-4000-8000-000000000104'
      and action = 'USER_ROLE_CHANGED'
      and role_before = 'TECHNICIAN'
      and role_after = 'COMPANY_ADMIN'
  ),
  1::bigint,
  'T015-ROLE-009.c disabled-target promotion snapshots are exact'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000001', true);
select ok(
  (select outcome = 'APPLIED' and changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001104', 'CHANGE_ROLE', 'TECHNICIAN'
  )),
  'T015-ROLE-006.a disabled COMPANY_ADMIN can be demoted'
);
reset role;
select ok(
  (
    select not is_enabled and role = 'TECHNICIAN'
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001104'
  ),
  'T015-ROLE-006.b disabled target remains disabled after demotion'
);
select is(
  (
    select count(*)
    from public.audit_events
    where subject_platform_user_id = '15000000-0000-4000-8000-000000000104'
      and action = 'USER_ROLE_CHANGED'
      and role_before = 'COMPANY_ADMIN'
      and role_after = 'TECHNICIAN'
  ),
  1::bigint,
  'T015-ROLE-009.d disabled-target demotion snapshots are exact'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000001', true);
select ok(
  (select outcome = 'APPLIED' and changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001104', 'REINSTATE', null
  )),
  'T015-ROLE-010.a changed disabled role is used on reinstate'
);
reset role;
select ok(
  (
    select is_enabled and role = 'TECHNICIAN'
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001104'
  ),
  'T015-ROLE-010.b reinstate does not restore the historical role'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000001', true);
select ok(
  (select outcome = 'APPLIED' and changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001110', 'REINSTATE', null
  )),
  'T015-REI-002.a disabled COMPANY_ADMIN can be reinstated'
);
reset role;
select ok(
  (
    select is_enabled and role = 'COMPANY_ADMIN'
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001110'
  ),
  'T015-REI-002.b admin reinstate preserves current admin role'
);

create function pg_temp.task_015_reject_audit_insert()
returns trigger
language plpgsql
as $$
begin
  raise exception using errcode = 'P0001', message = 'TASK-015 injected audit failure';
end;
$$;

create trigger task_015_reject_audit_insert
before insert on public.audit_events
for each row execute function pg_temp.task_015_reject_audit_insert();

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000001', true);
select throws_ok(
  $$select * from public.apply_company_membership_lifecycle('15000000-0000-4000-8000-000000001104', 'CHANGE_ROLE', 'COMPANY_ADMIN')$$,
  'P0001',
  'TASK-015 injected audit failure',
  'T015-ATM-002.a injected AuditEvent failure aborts the RPC'
);
reset role;

drop trigger task_015_reject_audit_insert on public.audit_events;

select ok(
  (
    select is_enabled and role = 'TECHNICIAN'
    from public.company_memberships
    where id = '15000000-0000-4000-8000-000000001104'
  ),
  'T015-ATM-002.b AuditEvent failure rolls back the membership mutation'
);
select is(
  (select count(*) from public.audit_events),
  8::bigint,
  'T015-ATM-002.c AuditEvent failure leaves no partial event'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000001', true);
select ok(
  (select outcome = 'APPLIED' and changed
   from public.apply_company_membership_lifecycle(
    '15000000-0000-4000-8000-000000001103', 'DISABLE', null
  )),
  'T015-DIS-001.b authoritative disable succeeds after prior role change'
);
reset role;

set local role authenticated;
select set_config('request.jwt.claim.sub', '95000000-0000-4000-8000-000000000003', true);
select is(
  (select count(*) from public.company_memberships),
  0::bigint,
  'T015-DIS-007 disabled target loses ordinary tenant visibility immediately'
);
select throws_ok(
  $$update public.company_memberships set is_enabled = true where id = '15000000-0000-4000-8000-000000001103'$$,
  '42501',
  null,
  'T015-RLS-001 authenticated cannot bypass RPC with direct membership UPDATE'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values (pg_catalog.gen_random_uuid(), '15000000-0000-4000-8000-000000000001', 'PLATFORM_USER', '15000000-0000-4000-8000-000000000103', 'USER_REINSTATED', 'USER', '15000000-0000-4000-8000-000000000103')$$,
  '42501',
  null,
  'T015-RLS-002 authenticated cannot fabricate AuditEvent directly'
);
select throws_ok(
  $$update public.audit_events set action = 'USER_REINSTATED'$$,
  '42501',
  null,
  'T015-RLS-003.a authenticated cannot update AuditEvent directly'
);
select throws_ok(
  $$delete from public.audit_events$$,
  '42501',
  null,
  'T015-RLS-003.b authenticated cannot delete AuditEvent directly'
);
reset role;

select is(
  (
    select count(*)
    from public.audit_events
    where action = 'USER_DISABLED_OR_REVOKED'
      and subject_platform_user_id = '15000000-0000-4000-8000-000000000103'
  ),
  2::bigint,
  'T015-ATM-001 distinct real disables each write exactly one event'
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
  'T015-DB-STATIC-017 ordinary CompanyMembership RLS remains unchanged'
);
select ok(
  not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'audit_events'
  ),
  'T015-DB-STATIC-018 AuditEvent RLS remains deny-by-default'
);
select ok(
  pg_get_functiondef(
    'private.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ) ilike '%from public.maintenance_companies%for update%'
  and pg_get_functiondef(
    'private.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ) ilike '%for update of actor_subject, actor_user, actor_membership%'
  and pg_get_functiondef(
    'private.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ) ilike '%for update of target_membership, target_user%'
  and pg_get_functiondef(
    'private.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ) ilike '%auth.uid()%'
  and pg_get_functiondef(
    'private.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure
  ) !~* '\mexecute\M',
  'T015-DB-STATIC-019 implementation has tenant lock target lock auth.uid and no dynamic SQL'
);

select * from finish();

rollback;
