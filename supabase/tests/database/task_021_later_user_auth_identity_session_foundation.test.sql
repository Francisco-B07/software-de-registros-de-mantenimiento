\set ON_ERROR_STOP on

begin;
select no_plan();

select ok(
  to_regclass('public.auth_subject_authority_anchors') is not null,
  'T021-A-001 subject authority anchor table exists'
);
select ok(
  to_regclass('public.later_user_initial_session_coordinations') is not null,
  'T021-A-002 later-user initial-session coordination table exists'
);
select is(
  (
    select string_agg(column_name || ':' || data_type || ':' || is_nullable, ',' order by ordinal_position)
    from information_schema.columns
    where table_schema = 'public' and table_name = 'auth_subject_authority_anchors'
  ),
  'auth_subject_id:uuid:NO,created_at:timestamp with time zone:NO',
  'T021-A-003 anchor has the exact minimal physical shape'
);
select is(
  (
    select string_agg(column_name || ':' || data_type || ':' || is_nullable, ',' order by ordinal_position)
    from information_schema.columns
    where table_schema = 'public' and table_name = 'later_user_initial_session_coordinations'
  ),
  'id:uuid:NO,later_user_enrollment_intent_id:uuid:NO,auth_bridge_credential_id:uuid:NO,auth_session_grant_id:uuid:NO,logical_operation_id:uuid:NO,expected_auth_subject_id:uuid:NO,reserved_auth_subject_id:uuid:YES,confirmed_auth_subject_id:uuid:YES,state:text:NO,expires_at:timestamp with time zone:NO,terminal_result:text:YES,created_at:timestamp with time zone:NO,updated_at:timestamp with time zone:NO',
  'T021-A-004 coordination has the approved physical columns only'
);
select is(
  (select count(*)::integer from pg_constraint where conrelid = 'public.later_user_initial_session_coordinations'::regclass and contype = 'f'),
  3,
  'T021-A-005 intent, bridge and grant correlations are foreign keys'
);
select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.later_user_initial_session_coordinations'::regclass
      and conname = 'task_021_coordination_state_check'
      and pg_get_constraintdef(oid) like all (array[
        '%PREPARING%', '%PROVISIONING_UNKNOWN%', '%SUBJECT_CONFIRMED%',
        '%ISSUANCE_ACTIVE%', '%GATE_CONSUMED%',
        '%SESSION_ESTABLISHED_NO_AUTHORITY%', '%EXPIRED%', '%ABANDONED%',
        '%REPAIR_REQUIRED%'
      ])
  ),
  'T021-A-006 lifecycle constraint contains every and only reviewed state vocabulary'
);
select ok(
  exists (
    select 1 from pg_indexes
    where schemaname = 'public'
      and indexname = 'task_021_one_active_subject_fence_idx'
      and indexdef like '%UNIQUE%'
      and indexdef like '%ISSUANCE_ACTIVE%'
      and indexdef like '%GATE_CONSUMED%'
  ),
  'T021-A-007 exact-subject active fence is physically unique'
);
select ok(
  (select relrowsecurity from pg_class where oid = 'public.auth_subject_authority_anchors'::regclass)
  and (select relrowsecurity from pg_class where oid = 'public.later_user_initial_session_coordinations'::regclass),
  'T021-A-008 both platform-owned tables have RLS enabled'
);
select ok(
  not has_table_privilege('anon', 'public.auth_subject_authority_anchors', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.auth_subject_authority_anchors', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('service_role', 'public.auth_subject_authority_anchors', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('anon', 'public.later_user_initial_session_coordinations', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.later_user_initial_session_coordinations', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('service_role', 'public.later_user_initial_session_coordinations', 'SELECT,INSERT,UPDATE,DELETE'),
  'T021-A-009 browser roles and ordinary service role have no direct coordination CRUD'
);

select ok(
  has_function_privilege('service_role', 'public.task_021_reconcile_initial_session(uuid)', 'EXECUTE')
  and has_function_privilege('service_role', 'public.task_021_confirm_auth_subject(uuid,uuid)', 'EXECUTE')
  and has_function_privilege('service_role', 'public.task_021_activate_issuance(uuid,uuid,uuid)', 'EXECUTE')
  and has_function_privilege('service_role', 'public.task_021_finalize_initial_session(uuid,uuid)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.task_021_reconcile_initial_session(uuid)', 'EXECUTE'),
  'T021-A-010 only the server role can execute purpose-specific mutation boundaries'
);
select ok(
  has_function_privilege('authenticated', 'public.resolve_current_later_user_pre_client_state()', 'EXECUTE')
  and not has_function_privilege('anon', 'public.resolve_current_later_user_pre_client_state()', 'EXECUTE'),
  'T021-F-001 only an authenticated session may resolve pending pre-client state'
);
select ok(
  not exists (
    select 1 from pg_proc
    where proname like 'task_021_%'
      and pronamespace in ('public'::regnamespace, 'private'::regnamespace)
      and (pg_get_userbyid(proowner) <> 'postgres' or proconfig is distinct from array['search_path=""']::text[])
  ),
  'T021-A-011 every TASK-021 function is postgres-owned with empty search_path'
);
select ok(
  (select not prosecdef from pg_proc where oid = 'public.task_013_custom_access_token_hook(jsonb)'::regprocedure),
  'T021-E-001 Custom Access Token Hook remains SECURITY INVOKER'
);
select ok(
  position('later_user_initial_session_coordinations' in pg_get_functiondef('public.task_013_custom_access_token_hook(jsonb)'::regprocedure)) > 0
  and position('GATE_CONSUMED' in pg_get_functiondef('public.task_013_custom_access_token_hook(jsonb)'::regprocedure)) > 0
  and position('company_memberships' in pg_get_functiondef('public.task_013_custom_access_token_hook(jsonb)'::regprocedure)) = 0
  and position('platform_users' in pg_get_functiondef('public.task_013_custom_access_token_hook(jsonb)'::regprocedure)) = 0
  and position('maintenance_companies' in pg_get_functiondef('public.task_013_custom_access_token_hook(jsonb)'::regprocedure)) = 0,
  'T021-E-002 Hook consumes platform coordination without tenant/application authority reads'
);
select ok(
  not has_table_privilege('supabase_auth_admin', 'public.maintenance_companies', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('supabase_auth_admin', 'public.platform_users', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('supabase_auth_admin', 'public.platform_user_auth_subjects', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('supabase_auth_admin', 'public.company_memberships', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('supabase_auth_admin', 'public.later_user_enrollment_intents', 'SELECT,INSERT,UPDATE,DELETE'),
  'T021-E-003 supabase_auth_admin has zero tenant/application authorization privileges'
);

select ok(
  position('for update nowait' in lower(pg_get_functiondef('private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure))) > 0
  and position('auth_subject_authority_anchors' in pg_get_functiondef('private.complete_first_admin_onboarding(text,text,uuid)'::regprocedure)) > 0,
  'T021-D-001 TASK-019 entry uses fail-fast exact-subject anchor acquisition'
);
select ok(
  position('auth_subject_authority_anchors' in pg_get_functiondef('private.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure)) > 0
  and position('p_operation = ''REINSTATE''' in pg_get_functiondef('private.apply_company_membership_lifecycle(uuid,text,text)'::regprocedure)) > 0,
  'T021-D-002 TASK-015 authority-increasing paths participate in the subject fence'
);

select lives_ok(
  $$insert into public.auth_subject_authority_anchors (auth_subject_id)
    values ('21000000-0000-4000-8000-000000000001')$$,
  'T021-A-012 a server-owned reserved UUID can have an anchor before provider confirmation'
);
select throws_ok(
  $$insert into public.auth_subject_authority_anchors (auth_subject_id)
    values ('21000000-0000-4000-8000-000000000001')$$,
  '23505',
  null,
  'T021-A-013 exact subject anchor primary key rejects duplicates'
);

select * from finish();
rollback;
