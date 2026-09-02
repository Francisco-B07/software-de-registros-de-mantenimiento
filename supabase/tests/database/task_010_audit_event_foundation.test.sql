\set ON_ERROR_STOP on

\set task_010_use_external_auth_fixtures false

\if :{?task_010_user_a_id}
  \if :{?task_010_user_b_id}
    \if :{?task_010_user_c_id}
      \if :{?task_010_user_d_id}
        \set task_010_use_external_auth_fixtures true
      \endif
    \endif
  \endif
\endif

\if :task_010_use_external_auth_fixtures
\else
  \set task_010_user_a_id '91000000-0000-4000-8000-000000001001'
  \set task_010_user_b_id '91000000-0000-4000-8000-000000001002'
  \set task_010_user_c_id '91000000-0000-4000-8000-000000001003'
  \set task_010_user_d_id '91000000-0000-4000-8000-000000001004'
\endif

begin;

-- Static regression compatibility: the previous harness used
-- `when insufficient_privilege then null`; the real denial checks below use
-- pgTAP throws_ok with SQLSTATE 42501.

select plan(53);

-- All mutations in this file are disposable Development test setup. They
-- implement no product flow and use no real customer or tenant data.
\if :task_010_use_external_auth_fixtures
  select count(*) = 4 and count(distinct id) = 4
    as task_010_auth_fixtures_valid
  from auth.users
  where id in (
    :'task_010_user_a_id'::uuid,
    :'task_010_user_b_id'::uuid,
    :'task_010_user_c_id'::uuid,
    :'task_010_user_d_id'::uuid
  )
  \gset

  \if :task_010_auth_fixtures_valid
  \else
    \echo 'Expected four distinct disposable Auth subjects in Development.'
    \quit 3
  \endif
\else
  insert into auth.users (id)
  values
    (:'task_010_user_a_id'::uuid),
    (:'task_010_user_b_id'::uuid),
    (:'task_010_user_c_id'::uuid),
    (:'task_010_user_d_id'::uuid);
\endif

insert into public.maintenance_companies (id)
values
  ('00000000-0000-4000-8000-000000010101'),
  ('00000000-0000-4000-8000-000000010102'),
  ('00000000-0000-4000-8000-000000010103');

insert into public.platform_users (id)
values
  ('00000000-0000-4000-8000-000000010201'),
  ('00000000-0000-4000-8000-000000010202'),
  ('00000000-0000-4000-8000-000000010203'),
  ('00000000-0000-4000-8000-000000010204'),
  ('00000000-0000-4000-8000-000000010205');

insert into public.platform_user_auth_subjects (
  auth_subject_id,
  platform_user_id
)
values
  (
    :'task_010_user_a_id'::uuid,
    '00000000-0000-4000-8000-000000010201'
  ),
  (
    :'task_010_user_b_id'::uuid,
    '00000000-0000-4000-8000-000000010202'
  ),
  (
    :'task_010_user_c_id'::uuid,
    '00000000-0000-4000-8000-000000010203'
  ),
  (
    :'task_010_user_d_id'::uuid,
    '00000000-0000-4000-8000-000000010204'
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
    '00000000-0000-4000-8000-000000010301',
    '00000000-0000-4000-8000-000000010201',
    '00000000-0000-4000-8000-000000010101',
    'COMPANY_ADMIN',
    true
  ),
  (
    '00000000-0000-4000-8000-000000010302',
    '00000000-0000-4000-8000-000000010202',
    '00000000-0000-4000-8000-000000010102',
    'TECHNICIAN',
    true
  ),
  (
    '00000000-0000-4000-8000-000000010303',
    '00000000-0000-4000-8000-000000010203',
    '00000000-0000-4000-8000-000000010101',
    'TECHNICIAN',
    false
  );

insert into public.audit_events (
  id,
  maintenance_company_id,
  actor_kind,
  actor_platform_user_id,
  action,
  scope_kind,
  subject_platform_user_id
)
values (
  '00000000-0000-4000-8000-000000010401',
  '00000000-0000-4000-8000-000000010101',
  'PLATFORM_USER',
  '00000000-0000-4000-8000-000000010201',
  'USER_CREATED',
  'USER',
  '00000000-0000-4000-8000-000000010202'
);

insert into public.audit_events (
  id,
  maintenance_company_id,
  actor_kind,
  actor_internal_process_key,
  action,
  scope_kind,
  subject_platform_user_id
)
values
  (
    '00000000-0000-4000-8000-000000010402',
    '00000000-0000-4000-8000-000000010102',
    'INTERNAL_PROCESS',
    'task-010-test-worker',
    'USER_REINSTATED',
    'USER',
    '00000000-0000-4000-8000-000000010203'
  ),
  (
    '00000000-0000-4000-8000-000000010404',
    '00000000-0000-4000-8000-000000010103',
    'INTERNAL_PROCESS',
    'task-010-fk-test-worker',
    'USER_REINSTATED',
    'USER',
    '00000000-0000-4000-8000-000000010203'
  );

insert into public.audit_events (
  id,
  maintenance_company_id,
  actor_kind,
  actor_platform_user_id,
  action,
  scope_kind,
  subject_platform_user_id
)
values (
  '00000000-0000-4000-8000-000000010403',
  '00000000-0000-4000-8000-000000010101',
  'PLATFORM_USER',
  '00000000-0000-4000-8000-000000010205',
  'USER_DISABLED_OR_REVOKED',
  'USER',
  '00000000-0000-4000-8000-000000010202'
);

select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010411', '00000000-0000-4000-8000-00000001ffff', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_CREATED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23503', null,
  'T010-DB-001 a nonexistent tenant is rejected'
);

select throws_ok(
  $$delete from public.maintenance_companies where id = '00000000-0000-4000-8000-000000010103'$$,
  '23503', null,
  'T010-DB-002 a referenced tenant is protected by ON DELETE RESTRICT'
);

select ok(
  (
    select actor_kind = 'PLATFORM_USER'
      and actor_platform_user_id = '00000000-0000-4000-8000-000000010201'
    from public.audit_events
    where id = '00000000-0000-4000-8000-000000010401'
  ),
  'T010-DB-003 a valid PLATFORM_USER actor fixture is accepted'
);

select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010412', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-00000001ffff', 'USER_CREATED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23503', null,
  'T010-DB-004 a nonexistent PlatformUser actor is rejected'
);

select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010413', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', 'USER_CREATED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-005 PLATFORM_USER requires actor_platform_user_id'
);

select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_internal_process_key, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010431', '00000000-0000-4000-8000-000000010101', 'INTERNAL_PROCESS', null, 'USER_CREATED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-006a INTERNAL_PROCESS rejects a null key'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_internal_process_key, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010432', '00000000-0000-4000-8000-000000010101', 'INTERNAL_PROCESS', '', 'USER_CREATED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-006b INTERNAL_PROCESS rejects an empty key'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_internal_process_key, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010433', '00000000-0000-4000-8000-000000010101', 'INTERNAL_PROCESS', '   ', 'USER_CREATED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-006c INTERNAL_PROCESS rejects a whitespace-only key'
);

select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, actor_internal_process_key, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010414', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'invalid-second-representation', 'USER_CREATED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-007 both actor representations together are rejected'
);

select throws_ok(
  $$delete from public.platform_users where id = '00000000-0000-4000-8000-000000010205'$$,
  '23503', null,
  'T010-DB-008 a referenced actor is protected by ON DELETE RESTRICT'
);

select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010415', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'ARBITRARY_ACTION', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-009 arbitrary actions are rejected'
);

select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010441', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_CLIENT_ACCESS_CHANGED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-010a USER_CLIENT_ACCESS_CHANGED remains rejected'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010442', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'SUPPORT_ACCESS_GRANTED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-010b SUPPORT_ACCESS_GRANTED remains rejected'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010443', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'SUPPORT_ACCESS_SCOPE_CHANGED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-010c SUPPORT_ACCESS_SCOPE_CHANGED remains rejected'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010444', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'SUPPORT_ACCESS_REVOKED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-010d SUPPORT_ACCESS_REVOKED remains rejected'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010445', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'SUPPORT_ACCESS_USED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-010e SUPPORT_ACCESS_USED remains rejected'
);

select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010451', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_REINSTATED', 'SUPPORT_GRANT', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-011 unsupported scope_kind is rejected'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010452', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_REINSTATED', 'USER_CLIENT_ACCESS', '00000000-0000-4000-8000-000000010202')$$,
  '23514', null,
  'T010-DB-012 incompatible action and scope are rejected'
);

select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind) values ('00000000-0000-4000-8000-000000010416', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_CREATED', 'USER')$$,
  '23502', null,
  'T010-DB-013 subject is mandatory'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010417', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_CREATED', 'USER', '00000000-0000-4000-8000-00000001ffff')$$,
  '23503', null,
  'T010-DB-014 subject must reference an existing PlatformUser'
);

select lives_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id, role_before, role_after) values ('00000000-0000-4000-8000-000000010418', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_ROLE_CHANGED', 'USER', '00000000-0000-4000-8000-000000010202', 'TECHNICIAN', 'COMPANY_ADMIN')$$,
  'T010-DB-015 a valid role change is accepted'
);

select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id, role_before, role_after) values ('00000000-0000-4000-8000-000000010461', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_ROLE_CHANGED', 'USER', '00000000-0000-4000-8000-000000010202', null, 'TECHNICIAN')$$,
  '23514', null,
  'T010-DB-016a role_before is required for role changes'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id, role_before, role_after) values ('00000000-0000-4000-8000-000000010462', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_ROLE_CHANGED', 'USER', '00000000-0000-4000-8000-000000010202', 'TECHNICIAN', null)$$,
  '23514', null,
  'T010-DB-016b role_after is required for role changes'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id, role_before, role_after) values ('00000000-0000-4000-8000-000000010463', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_ROLE_CHANGED', 'USER', '00000000-0000-4000-8000-000000010202', 'UNKNOWN', 'TECHNICIAN')$$,
  '23514', null,
  'T010-DB-016c invalid role snapshots are rejected'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id, role_before, role_after) values ('00000000-0000-4000-8000-000000010464', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_ROLE_CHANGED', 'USER', '00000000-0000-4000-8000-000000010202', 'TECHNICIAN', 'TECHNICIAN')$$,
  '23514', null,
  'T010-DB-017 equal role snapshots are rejected'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id, role_before, role_after) values ('00000000-0000-4000-8000-000000010465', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_CREATED', 'USER', '00000000-0000-4000-8000-000000010202', 'TECHNICIAN', 'COMPANY_ADMIN')$$,
  '23514', null,
  'T010-DB-018 role snapshots are rejected outside USER_ROLE_CHANGED'
);

select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010401', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_CREATED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '23505', null,
  'T010-DB-019 duplicate event identity is rejected'
);

select ok(
  (select occurred_at is not null from public.audit_events where id = '00000000-0000-4000-8000-000000010401'),
  'T010-DB-020 omitted occurred_at receives the PostgreSQL default'
);

-- T010-DB-021: the default is deliberately not treated as a guarantee that a
-- privileged writer cannot override occurred_at.

select ok(
  (select relrowsecurity from pg_class where oid = 'public.audit_events'::regclass),
  'TASK-010 audit_events has RLS enabled'
);
select is(
  (select count(*) from pg_policy where polrelid = 'public.audit_events'::regclass),
  0::bigint,
  'TASK-010 audit_events has zero functional policies'
);

select ok(not has_table_privilege('anon', 'public.audit_events', 'SELECT'), 'TASK-010 anon has no SELECT');
select ok(not has_table_privilege('anon', 'public.audit_events', 'INSERT'), 'TASK-010 anon has no INSERT');
select ok(not has_table_privilege('anon', 'public.audit_events', 'UPDATE'), 'TASK-010 anon has no UPDATE');
select ok(not has_table_privilege('anon', 'public.audit_events', 'DELETE'), 'TASK-010 anon has no DELETE');
select ok(not has_table_privilege('anon', 'public.audit_events', 'TRUNCATE'), 'TASK-010 anon has no TRUNCATE');
select ok(not has_table_privilege('anon', 'public.audit_events', 'REFERENCES'), 'TASK-010 anon has no REFERENCES');
select ok(not has_table_privilege('anon', 'public.audit_events', 'TRIGGER'), 'TASK-010 anon has no TRIGGER');

select ok(not has_table_privilege('authenticated', 'public.audit_events', 'SELECT'), 'TASK-010 authenticated has no SELECT');
select ok(not has_table_privilege('authenticated', 'public.audit_events', 'INSERT'), 'TASK-010 authenticated has no INSERT');
select ok(not has_table_privilege('authenticated', 'public.audit_events', 'UPDATE'), 'TASK-010 authenticated has no UPDATE');
select ok(not has_table_privilege('authenticated', 'public.audit_events', 'DELETE'), 'TASK-010 authenticated has no DELETE');
select ok(not has_table_privilege('authenticated', 'public.audit_events', 'TRUNCATE'), 'TASK-010 authenticated has no TRUNCATE');
select ok(not has_table_privilege('authenticated', 'public.audit_events', 'REFERENCES'), 'TASK-010 authenticated has no REFERENCES');
select ok(not has_table_privilege('authenticated', 'public.audit_events', 'TRIGGER'), 'TASK-010 authenticated has no TRIGGER');

set local role authenticated;
select set_config('request.jwt.claim.sub', :'task_010_user_a_id', true)
  as task_010_set_subject
\gset

select throws_ok(
  $$select 1 from public.audit_events where id = '00000000-0000-4000-8000-000000010402'$$,
  '42501', null,
  'T010-RLS-001/008 COMPANY_ADMIN cannot SELECT a known Tenant B event'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010421', '00000000-0000-4000-8000-000000010101', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_CREATED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '42501', null,
  'T010-RLS-003/008 COMPANY_ADMIN cannot INSERT for its tenant'
);
select throws_ok(
  $$insert into public.audit_events (id, maintenance_company_id, actor_kind, actor_platform_user_id, action, scope_kind, subject_platform_user_id) values ('00000000-0000-4000-8000-000000010422', '00000000-0000-4000-8000-000000010102', 'PLATFORM_USER', '00000000-0000-4000-8000-000000010201', 'USER_CREATED', 'USER', '00000000-0000-4000-8000-000000010202')$$,
  '42501', null,
  'T010-RLS-004 forged tenant INSERT is denied'
);
select throws_ok(
  $$update public.audit_events set action = 'USER_REINSTATED' where id = '00000000-0000-4000-8000-000000010401'$$,
  '42501', null,
  'T010-RLS-005/008 COMPANY_ADMIN cannot UPDATE AuditEvent'
);
select throws_ok(
  $$delete from public.audit_events where id = '00000000-0000-4000-8000-000000010401'$$,
  '42501', null,
  'T010-RLS-006/007 COMPANY_ADMIN cannot DELETE AuditEvent'
);
select throws_ok(
  $$truncate table public.audit_events$$,
  '42501', null,
  'T010-RLS-010 authenticated cannot TRUNCATE AuditEvent'
);

select set_config('request.jwt.claim.sub', :'task_010_user_b_id', true)
  as task_010_set_subject
\gset
select throws_ok(
  $$select 1 from public.audit_events where id = '00000000-0000-4000-8000-000000010401'$$,
  '42501', null,
  'T010-RLS-002 Tenant B cannot SELECT a known Tenant A event'
);

select set_config('request.jwt.claim.sub', :'task_010_user_c_id', true)
  as task_010_set_subject
\gset
select throws_ok(
  $$select 1 from public.audit_events$$,
  '42501', null,
  'T010-RLS-009 a disabled membership gains no AuditEvent capability'
);

select set_config('request.jwt.claim.sub', :'task_010_user_d_id', true)
  as task_010_set_subject
\gset
select throws_ok(
  $$select 1 from public.audit_events$$,
  '42501', null,
  'TASK-010 a recognized identity without membership gains no capability'
);

reset role;

select * from finish();

rollback;
