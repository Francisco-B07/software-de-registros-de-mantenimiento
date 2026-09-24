\set ON_ERROR_STOP on

begin;

select plan(37);

select is(
  (
    select count(*)::integer
    from pg_proc
    where pronamespace = 'public'::regnamespace
      and proname = 'resolve_first_admin_auth_bridge_technical_password_state'
  ),
  1,
  'T018-B1A-DB-001 exactly one technical-password state resolver overload exists'
);

select is(
  pg_get_function_identity_arguments(
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ),
  'p_auth_bridge_credential_id uuid',
  'T018-B1A-DB-002 resolver has the exact one-credential signature'
);

select is(
  (
    select language.lanname
    from pg_proc as function_definition
    join pg_language as language on language.oid = function_definition.prolang
    where function_definition.oid =
      'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ),
  'sql',
  'T018-B1A-DB-003 resolver language is sql'
);

select is(
  (
    select provolatile::text
    from pg_proc
    where oid =
      'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ),
  's',
  'T018-B1A-DB-004 resolver is read-only STABLE'
);

select ok(
  (
    select prosecdef
    from pg_proc
    where oid =
      'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ),
  'T018-B1A-DB-005 resolver is SECURITY DEFINER for its narrow RLS-crossing read'
);

select is(
  (
    select pg_get_userbyid(proowner)
    from pg_proc
    where oid =
      'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ),
  'postgres',
  'T018-B1A-DB-006 resolver owner is postgres'
);

select is(
  (
    select array_to_string(proconfig, ',')
    from pg_proc
    where oid =
      'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ),
  'search_path=""',
  'T018-B1A-DB-007 resolver fixes an empty search_path'
);

select is(
  pg_get_function_result(
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ),
  'TABLE(auth_bridge_credential_id uuid, technical_password_key_version text, rotation_state text)',
  'T018-B1A-DB-008 resolver return shape is exact and bounded'
);

select ok(
  pg_get_functiondef(
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ) !~* '\m(insert|update|delete|merge|truncate)\M',
  'T018-B1A-DB-009 resolver definition contains no data-writing statement'
);

select ok(
  pg_get_functiondef(
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ) !~* '\mexecute\M',
  'T018-B1A-DB-010 resolver contains no dynamic SQL'
);

select ok(
  not has_function_privilege(
    'public',
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)',
    'EXECUTE'
  ),
  'T018-B1A-ACL-001 PUBLIC cannot execute the resolver'
);

select ok(
  not has_function_privilege(
    'anon',
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)',
    'EXECUTE'
  ),
  'T018-B1A-ACL-002 anon cannot execute the resolver'
);

select ok(
  not has_function_privilege(
    'authenticated',
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)',
    'EXECUTE'
  ),
  'T018-B1A-ACL-003 authenticated cannot execute the resolver'
);

select ok(
  not has_function_privilege(
    'supabase_auth_admin',
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)',
    'EXECUTE'
  ),
  'T018-B1A-ACL-004 supabase_auth_admin cannot execute the resolver'
);

select ok(
  has_function_privilege(
    'service_role',
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)',
    'EXECUTE'
  ),
  'T018-B1A-ACL-005 service_role can execute the resolver'
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
      'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
      and privilege.privilege_type = 'EXECUTE'
      and privilege.grantee <> function_definition.proowner
  ),
  '{service_role}',
  'T018-B1A-ACL-006 service_role is the only non-owner executor'
);

select ok(
  (
    select array_agg(privilege.privilege_type order by privilege.privilege_type)::text
    from pg_class as relation
    cross join lateral aclexplode(
      coalesce(relation.relacl, acldefault('r', relation.relowner))
    ) as privilege
    where relation.oid = 'public.auth_bridge_credentials'::regclass
      and pg_get_userbyid(privilege.grantee) = 'service_role'
  ) = '{INSERT,SELECT,UPDATE}',
  'T018-B1A-ACL-007 AuthBridgeCredential table retains only its pre-B1a TASK-013 service-role grants'
);

select ok(
  not exists (
    select 1
    from pg_policy
    where polname like 'task_018_b1a%'
  ),
  'T018-B1A-RLS-001 no B1a RLS policy is introduced'
);

select is(
  (
    select count(*)
    from pg_policy
    where polrelid in (
      'public.auth_bridge_credentials'::regclass,
      'auth.users'::regclass,
      'public.audit_events'::regclass
    )
  ),
  2::bigint,
  'T018-B1A-RLS-002 relevant pre-B1a policy count remains unchanged'
);

select ok(
  pg_get_function_result(
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ) !~* '(email|auth_user_id|pending_key_version|rotation_operation_id|rotation_started_at|rotated_at|tenant|role|membership|token|secret)',
  'T018-B1A-SCOPE-001 return shape excludes all non-authorized bridge provider tenant role membership token and secret fields'
);

select ok(
  pg_get_functiondef(
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ) !~* '(technicalpasswordactiveversion|technical_password_active_version|auth_technical_password_active_version|secret_key|key_material)',
  'T018-B1A-SCOPE-002 resolver cannot inspect application active-version configuration or key material'
);

set local role anon;
select throws_ok(
  $$select * from public.resolve_first_admin_auth_bridge_technical_password_state('181a0000-0000-4000-8000-000000000001')$$,
  '42501',
  null,
  'T018-B1A-ACL-008 anon execution is denied in practice'
);
reset role;

set local role authenticated;
select throws_ok(
  $$select * from public.resolve_first_admin_auth_bridge_technical_password_state('181a0000-0000-4000-8000-000000000001')$$,
  '42501',
  null,
  'T018-B1A-ACL-009 authenticated execution is denied in practice'
);
reset role;

select is(
  (
    select count(*)::integer
    from public.resolve_first_admin_auth_bridge_technical_password_state(
      '181a0000-0000-4000-8000-000000000099'
    )
  ),
  0,
  'T018-B1A-STATE-001 missing credential returns no row and no manufactured fallback'
);

insert into public.auth_bridge_credentials (
  id,
  email,
  technical_password_key_version
)
values (
  '181a0000-0000-4000-8000-000000000001',
  'task018-b1a-ready@example.test',
  'v1'
);

insert into public.auth_bridge_credentials (
  id,
  email,
  technical_password_key_version,
  pending_key_version,
  rotation_operation_id,
  rotation_started_at
)
values (
  '181a0000-0000-4000-8000-000000000002',
  'task018-b1a-pending@example.test',
  'v1',
  'v2',
  '181a0000-0000-4000-8100-000000000002',
  statement_timestamp()
);

create temporary table task018_b1a_state_snapshot (
  relation_name text primary key,
  relation_digest text not null
);

insert into task018_b1a_state_snapshot (relation_name, relation_digest)
values
  (
    'auth_bridge_credentials',
    (
      select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), ''))
      from public.auth_bridge_credentials as row_data
    )
  ),
  (
    'auth.users',
    (
      select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), ''))
      from auth.users as row_data
    )
  ),
  (
    'audit_events',
    (
      select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), ''))
      from public.audit_events as row_data
    )
  );

select is(
  (
    select
      auth_bridge_credential_id::text || '|' ||
      technical_password_key_version || '|' ||
      rotation_state
    from public.resolve_first_admin_auth_bridge_technical_password_state(
      '181a0000-0000-4000-8000-000000000001'
    )
  ),
  '181a0000-0000-4000-8000-000000000001|v1|READY',
  'T018-B1A-STATE-002 READY returns only credential id persisted confirmed version and bounded state'
);

select is(
  (
    select technical_password_key_version
    from public.resolve_first_admin_auth_bridge_technical_password_state(
      '181a0000-0000-4000-8000-000000000001'
    )
  ),
  'v1',
  'T018-B1A-STATE-003 persisted v1 remains authoritative independently of application active-version configuration'
);

select is(
  (
    select row_to_json(first_result)::text
    from public.resolve_first_admin_auth_bridge_technical_password_state(
      '181a0000-0000-4000-8000-000000000001'
    ) as first_result
  ),
  (
    select row_to_json(second_result)::text
    from public.resolve_first_admin_auth_bridge_technical_password_state(
      '181a0000-0000-4000-8000-000000000001'
    ) as second_result
  ),
  'T018-B1A-STATE-004 identical authoritative state produces a deterministic result'
);

select is(
  (
    select rotation_state
    from public.resolve_first_admin_auth_bridge_technical_password_state(
      '181a0000-0000-4000-8000-000000000002'
    )
  ),
  'PENDING_ROTATION',
  'T018-B1A-STATE-005 coherent pending rotation returns PENDING_ROTATION'
);

select is(
  (
    select technical_password_key_version
    from public.resolve_first_admin_auth_bridge_technical_password_state(
      '181a0000-0000-4000-8000-000000000002'
    )
  ),
  null::text,
  'T018-B1A-STATE-006 PENDING_ROTATION returns no confirmed version'
);

select throws_ok(
  $$
    insert into public.auth_bridge_credentials (
      id, email, technical_password_key_version, pending_key_version
    ) values (
      '181a0000-0000-4000-8000-000000000003',
      'task018-b1a-partial-pending@example.test',
      'v1',
      'v2'
    )
  $$,
  '23514',
  null,
  'T018-B1A-STATE-007 physical constraint rejects pending version without complete rotation state'
);

select throws_ok(
  $$
    insert into public.auth_bridge_credentials (
      id, email, technical_password_key_version, rotation_operation_id
    ) values (
      '181a0000-0000-4000-8000-000000000004',
      'task018-b1a-partial-operation@example.test',
      'v1',
      '181a0000-0000-4000-8100-000000000004'
    )
  $$,
  '23514',
  null,
  'T018-B1A-STATE-008 physical constraint rejects rotation operation without complete rotation state'
);

select throws_ok(
  $$
    insert into public.auth_bridge_credentials (
      id, email, technical_password_key_version
    ) values (
      '181a0000-0000-4000-8000-000000000005',
      'task018-b1a-invalid-version@example.test',
      '   '
    )
  $$,
  '23514',
  null,
  'T018-B1A-STATE-009 physical constraint rejects an invalid confirmed key version'
);

select ok(
  pg_get_functiondef(
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ) ~* 'FAIL_CLOSED'
  and pg_get_functiondef(
    'public.resolve_first_admin_auth_bridge_technical_password_state(uuid)'::regprocedure
  ) ~* 'ELSE NULL::text',
  'T018-B1A-STATE-010 impossible malformed rotation state retains a defensive FAIL_CLOSED branch with no version'
);

set local role service_role;
select is(
  (
    select rotation_state
    from public.resolve_first_admin_auth_bridge_technical_password_state(
      '181a0000-0000-4000-8000-000000000001'
    )
  ),
  'READY',
  'T018-B1A-ACL-010 service_role executes the purpose-specific resolver in practice'
);
reset role;

select is(
  (
    select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), ''))
    from public.auth_bridge_credentials as row_data
  ),
  (
    select relation_digest
    from task018_b1a_state_snapshot
    where relation_name = 'auth_bridge_credentials'
  ),
  'T018-B1A-READ-001 resolver does not mutate AuthBridgeCredential'
);

select is(
  (
    select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), ''))
    from auth.users as row_data
  ),
  (
    select relation_digest
    from task018_b1a_state_snapshot
    where relation_name = 'auth.users'
  ),
  'T018-B1A-READ-002 resolver does not mutate auth.users'
);

select is(
  (
    select md5(coalesce(string_agg(to_jsonb(row_data)::text, ',' order by row_data.id::text), ''))
    from public.audit_events as row_data
  ),
  (
    select relation_digest
    from task018_b1a_state_snapshot
    where relation_name = 'audit_events'
  ),
  'T018-B1A-READ-003 resolver produces no AuditEvent'
);

select * from finish();

rollback;
