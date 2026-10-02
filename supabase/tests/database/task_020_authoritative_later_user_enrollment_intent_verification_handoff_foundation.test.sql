\set ON_ERROR_STOP on

begin;

select no_plan();

select ok(
  to_regclass('public.later_user_enrollment_intents') is not null,
  'T020-A-SCHEMA-001 dedicated later-user intent table exists'
);

select is(
  (
    select string_agg(
      column_name || ':' || data_type || ':' || is_nullable,
      ',' order by ordinal_position
    )
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'later_user_enrollment_intents'
  ),
  'id:uuid:NO,maintenance_company_id:uuid:NO,target_email:text:NO,intended_role:text:NO,initiated_by_platform_user_id:uuid:NO,establishment_operation_id:uuid:NO,current_challenge_id:uuid:NO,handoff_session_grant_id:uuid:YES,handoff_ready_at:timestamp with time zone:YES,created_at:timestamp with time zone:NO',
  'T020-A-SCHEMA-002 exact approved column set, order, types and nullability exist'
);

select ok(
  (
    select column_default ilike '%clock_timestamp%'
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'later_user_enrollment_intents'
      and column_name = 'created_at'
  ),
  'T020-A-SCHEMA-003 created_at is server authoritative'
);

select is(
  (
    select count(*)::integer
    from pg_constraint
    where conrelid = 'public.later_user_enrollment_intents'::regclass
      and contype = 'f'
  ),
  4,
  'T020-A-SCHEMA-004 exactly four approved foreign keys exist'
);

select ok(
  not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.later_user_enrollment_intents'::regclass
      and contype = 'f'
      and confdeltype <> 'r'
  ),
  'T020-A-SCHEMA-005 every intent foreign key uses ON DELETE RESTRICT'
);

select is(
  (
    select array_agg(conname order by conname)::text
    from pg_constraint
    where conrelid = 'public.later_user_enrollment_intents'::regclass
      and contype = 'u'
  ),
  '{later_user_enrollment_intents_current_challenge_id_key,later_user_enrollment_intents_establishment_operation_id_key,later_user_enrollment_intents_handoff_session_grant_id_key}',
  'T020-A-SCHEMA-006 exact approved uniqueness constraints exist'
);

select ok(
  not exists (
    select 1
    from pg_index as index_definition
    join pg_attribute as indexed_column
      on indexed_column.attrelid = index_definition.indrelid
      and indexed_column.attnum = any(index_definition.indkey)
    where index_definition.indrelid = 'public.later_user_enrollment_intents'::regclass
      and index_definition.indisunique
      and indexed_column.attname = 'target_email'
  ),
  'T020-A-SCHEMA-007 target email has no global or tenant-wide unique rule'
);

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.later_user_enrollment_intents'::regclass
      and conname = 'later_user_enrollment_intents_intended_role_check'
      and contype = 'c'
  ),
  'T020-A-SCHEMA-008 intended role constraint exists'
);

select ok(
  exists (
    select 1
    from pg_constraint
    where conrelid = 'public.later_user_enrollment_intents'::regclass
      and conname = 'later_user_enrollment_intents_handoff_state_check'
      and contype = 'c'
  ),
  'T020-A-SCHEMA-009 handoff all-or-none constraint exists'
);

select ok(
  (
    select relrowsecurity
    from pg_class
    where oid = 'public.later_user_enrollment_intents'::regclass
  ),
  'T020-A-RLS-001 RLS is enabled'
);

select is(
  (
    select count(*)::integer
    from pg_policy
    where polrelid = 'public.later_user_enrollment_intents'::regclass
  ),
  0,
  'T020-A-RLS-002 no generic tenant CRUD policy exists'
);

select ok(
  not has_table_privilege('anon', 'public.later_user_enrollment_intents', 'SELECT,INSERT,UPDATE,DELETE'),
  'T020-A-ACL-001 anon has no direct CRUD'
);

select ok(
  not has_table_privilege('authenticated', 'public.later_user_enrollment_intents', 'SELECT,INSERT,UPDATE,DELETE'),
  'T020-A-ACL-002 authenticated has no direct CRUD'
);

select ok(
  not has_table_privilege('service_role', 'public.later_user_enrollment_intents', 'SELECT,INSERT,UPDATE,DELETE'),
  'T020-A-ACL-003 service_role has no direct intent CRUD'
);

select ok(
  not has_table_privilege('supabase_auth_admin', 'public.later_user_enrollment_intents', 'SELECT,INSERT,UPDATE,DELETE'),
  'T020-A-ACL-004 supabase_auth_admin has no tenant intent CRUD'
);

select ok(
  not has_table_privilege('public', 'public.later_user_enrollment_intents', 'SELECT,INSERT,UPDATE,DELETE'),
  'T020-A-ACL-005 PUBLIC has no direct CRUD'
);

select is(
  (
    select count(*)::integer
    from pg_proc
    where pronamespace in ('public'::regnamespace, 'private'::regnamespace)
      and proname in (
        'task_020_resolve_current_company_admin',
        'task_020_initiator_authority_is_current',
        'establish_later_user_enrollment_intent',
        'resend_later_user_enrollment_challenge',
        'get_later_user_enrollment_delivery_target',
        'get_later_user_enrollment_challenge_material',
        'verify_later_user_enrollment_challenge'
      )
  ),
  7,
  'T020-BC-FUNC-001 exact purpose-specific function set exists'
);

select ok(
  not exists (
    select 1
    from pg_proc
    where pronamespace in ('public'::regnamespace, 'private'::regnamespace)
      and proname in (
        'task_020_resolve_current_company_admin',
        'task_020_initiator_authority_is_current',
        'establish_later_user_enrollment_intent',
        'resend_later_user_enrollment_challenge',
        'get_later_user_enrollment_delivery_target',
        'get_later_user_enrollment_challenge_material',
        'verify_later_user_enrollment_challenge'
      )
      and (
        pg_get_userbyid(proowner) <> 'postgres'
        or proconfig is distinct from array['search_path=""']::text[]
      )
  ),
  'T020-BC-FUNC-002 all boundaries have postgres ownership and empty fixed search_path'
);

select ok(
  has_function_privilege(
    'authenticated',
    'public.establish_later_user_enrollment_intent(uuid,text,text,uuid,uuid,bytea,text,uuid)',
    'EXECUTE'
  )
  and has_function_privilege(
    'authenticated',
    'public.resend_later_user_enrollment_challenge(uuid,uuid,bytea,text,uuid)',
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'public.establish_later_user_enrollment_intent(uuid,text,text,uuid,uuid,bytea,text,uuid)',
    'EXECUTE'
  )
  and not has_function_privilege(
    'service_role',
    'public.establish_later_user_enrollment_intent(uuid,text,text,uuid,uuid,bytea,text,uuid)',
    'EXECUTE'
  ),
  'T020-B-ACL-001 issue and resend are caller-scoped authenticated boundaries only'
);

select ok(
  has_function_privilege(
    'service_role',
    'public.get_later_user_enrollment_delivery_target(uuid,uuid)',
    'EXECUTE'
  )
  and has_function_privilege(
    'service_role',
    'public.get_later_user_enrollment_challenge_material(uuid,text,uuid)',
    'EXECUTE'
  )
  and has_function_privilege(
    'service_role',
    'public.verify_later_user_enrollment_challenge(uuid,uuid,text,uuid,boolean,text)',
    'EXECUTE'
  )
  and not has_function_privilege(
    'anon',
    'public.verify_later_user_enrollment_challenge(uuid,uuid,text,uuid,boolean,text)',
    'EXECUTE'
  )
  and not has_function_privilege(
    'authenticated',
    'public.verify_later_user_enrollment_challenge(uuid,uuid,text,uuid,boolean,text)',
    'EXECUTE'
  ),
  'T020-C-ACL-001 pre-auth verification is exposed only through the server boundary'
);

insert into auth.users (id, email)
values
  ('a2000000-0000-4000-8000-000000000001', 'task020-admin@example.test'),
  ('a2000000-0000-4000-8000-000000000002', 'task020-tech@example.test'),
  ('a2000000-0000-4000-8000-000000000003', 'task020-disabled@example.test'),
  ('a2000000-0000-4000-8000-000000000004', 'task020-other-tenant@example.test'),
  ('a2000000-0000-4000-8000-000000000005', 'task020-other-admin@example.test');

insert into public.platform_users (id)
values
  ('b2000000-0000-4000-8000-000000000001'),
  ('b2000000-0000-4000-8000-000000000002'),
  ('b2000000-0000-4000-8000-000000000003'),
  ('b2000000-0000-4000-8000-000000000004'),
  ('b2000000-0000-4000-8000-000000000005');

insert into public.platform_user_auth_subjects (auth_subject_id, platform_user_id)
values
  ('a2000000-0000-4000-8000-000000000001', 'b2000000-0000-4000-8000-000000000001'),
  ('a2000000-0000-4000-8000-000000000002', 'b2000000-0000-4000-8000-000000000002'),
  ('a2000000-0000-4000-8000-000000000003', 'b2000000-0000-4000-8000-000000000003'),
  ('a2000000-0000-4000-8000-000000000004', 'b2000000-0000-4000-8000-000000000004'),
  ('a2000000-0000-4000-8000-000000000005', 'b2000000-0000-4000-8000-000000000005');

insert into public.maintenance_companies (id)
values
  ('c2000000-0000-4000-8000-000000000001'),
  ('c2000000-0000-4000-8000-000000000002');

insert into public.company_memberships (
  id, platform_user_id, maintenance_company_id, role, is_enabled
)
values
  ('d2000000-0000-4000-8000-000000000001', 'b2000000-0000-4000-8000-000000000001', 'c2000000-0000-4000-8000-000000000001', 'COMPANY_ADMIN', true),
  ('d2000000-0000-4000-8000-000000000002', 'b2000000-0000-4000-8000-000000000002', 'c2000000-0000-4000-8000-000000000001', 'TECHNICIAN', true),
  ('d2000000-0000-4000-8000-000000000003', 'b2000000-0000-4000-8000-000000000003', 'c2000000-0000-4000-8000-000000000001', 'COMPANY_ADMIN', false),
  ('d2000000-0000-4000-8000-000000000004', 'b2000000-0000-4000-8000-000000000004', 'c2000000-0000-4000-8000-000000000002', 'COMPANY_ADMIN', true),
  ('d2000000-0000-4000-8000-000000000005', 'b2000000-0000-4000-8000-000000000005', 'c2000000-0000-4000-8000-000000000001', 'COMPANY_ADMIN', true);

create temporary table task020_issue_results (
  label text primary key,
  outcome text not null,
  changed boolean not null,
  intent_id uuid,
  challenge_id uuid,
  issued_at timestamptz,
  expires_at timestamptz,
  reason text not null
);
grant select, insert on task020_issue_results to authenticated;

set local role authenticated;
select set_config('request.jwt.claim.sub', 'a2000000-0000-4000-8000-000000000002', true);
insert into task020_issue_results
select 'technician', result.*
from public.establish_later_user_enrollment_intent(
  'e2000000-0000-4000-8000-000000000001',
  'target-one@example.test',
  'TECHNICIAN',
  'e2000000-0000-4000-8100-000000000001',
  'e2000000-0000-4000-8200-000000000001',
  decode(repeat('11', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000001'
) as result;

select set_config('request.jwt.claim.company_role', 'COMPANY_ADMIN', true);
insert into task020_issue_results
select 'stale-claim', result.*
from public.establish_later_user_enrollment_intent(
  'e2000000-0000-4000-8000-000000000002',
  'target-two@example.test',
  'TECHNICIAN',
  'e2000000-0000-4000-8100-000000000002',
  'e2000000-0000-4000-8200-000000000002',
  decode(repeat('12', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000002'
) as result;

select set_config('request.jwt.claim.sub', 'a2000000-0000-4000-8000-000000000003', true);
insert into task020_issue_results
select 'disabled', result.*
from public.establish_later_user_enrollment_intent(
  'e2000000-0000-4000-8000-000000000003',
  'target-three@example.test',
  'COMPANY_ADMIN',
  'e2000000-0000-4000-8100-000000000003',
  'e2000000-0000-4000-8200-000000000003',
  decode(repeat('13', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000003'
) as result;

select set_config('request.jwt.claim.sub', 'a2000000-0000-4000-8000-000000000001', true);
select set_config('request.jwt.claim.company_role', '', true);
insert into task020_issue_results
select 'established', result.*
from public.establish_later_user_enrollment_intent(
  'e2000000-0000-4000-8000-000000000010',
  'target-main@example.test',
  'TECHNICIAN',
  'e2000000-0000-4000-8100-000000000010',
  'e2000000-0000-4000-8200-000000000010',
  decode(repeat('21', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000010'
) as result;

insert into task020_issue_results
select 'retry', result.*
from public.establish_later_user_enrollment_intent(
  'e2000000-0000-4000-8000-000000000010',
  'target-main@example.test',
  'TECHNICIAN',
  'e2000000-0000-4000-8100-000000000010',
  'e2000000-0000-4000-8200-000000000010',
  decode(repeat('21', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000010'
) as result;

select set_config('request.jwt.claim.sub', 'a2000000-0000-4000-8000-000000000005', true);
insert into task020_issue_results
select 'other-admin-retry', result.*
from public.establish_later_user_enrollment_intent(
  'e2000000-0000-4000-8000-000000000010',
  'target-main@example.test',
  'TECHNICIAN',
  'e2000000-0000-4000-8100-000000000010',
  'e2000000-0000-4000-8200-000000000010',
  decode(repeat('21', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000010'
) as result;

select set_config('request.jwt.claim.sub', 'a2000000-0000-4000-8000-000000000001', true);
insert into task020_issue_results
select 'payload-conflict', result.*
from public.establish_later_user_enrollment_intent(
  'e2000000-0000-4000-8000-000000000010',
  'target-main@example.test',
  'COMPANY_ADMIN',
  'e2000000-0000-4000-8100-000000000010',
  'e2000000-0000-4000-8200-000000000010',
  decode(repeat('21', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000010'
) as result;

insert into task020_issue_results
select 'competing', result.*
from public.establish_later_user_enrollment_intent(
  'e2000000-0000-4000-8000-000000000011',
  'target-main@example.test',
  'TECHNICIAN',
  'e2000000-0000-4000-8100-000000000011',
  'e2000000-0000-4000-8200-000000000011',
  decode(repeat('22', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000011'
) as result;
reset role;

select ok(
  (select outcome = 'DENIED' and reason = 'AUTHORIZATION_DENIED' from task020_issue_results where label = 'technician')
  and (select outcome = 'DENIED' and reason = 'AUTHORIZATION_DENIED' from task020_issue_results where label = 'stale-claim')
  and (select outcome = 'DENIED' and reason = 'AUTHORIZATION_DENIED' from task020_issue_results where label = 'disabled'),
  'T020-B-AUTH-001 technician, stale claim and disabled membership are denied from PostgreSQL state'
);

select ok(
  (select outcome = 'ESTABLISHED' and changed from task020_issue_results where label = 'established')
  and (select outcome = 'ALREADY_RECONCILED' and not changed from task020_issue_results where label = 'retry')
  and (select outcome = 'ALREADY_RECONCILED' and not changed from task020_issue_results where label = 'other-admin-retry')
  and (select outcome = 'CONFLICT' and reason = 'IDEMPOTENCY_CONFLICT' from task020_issue_results where label = 'payload-conflict')
  and (select outcome = 'CONFLICT' and reason = 'RESTART_REPLACE_UNDEFINED' from task020_issue_results where label = 'competing'),
  'T020-B-ISSUE-001 establishment, same-operation retry by either current same-tenant admin and both conflict classes are bounded'
);

select ok(
  exists (
    select 1
    from public.later_user_enrollment_intents
    where id = 'e2000000-0000-4000-8000-000000000010'
      and maintenance_company_id = 'c2000000-0000-4000-8000-000000000001'
      and initiated_by_platform_user_id = 'b2000000-0000-4000-8000-000000000001'
      and target_email = 'target-main@example.test'
      and intended_role = 'TECHNICIAN'
      and current_challenge_id = 'e2000000-0000-4000-8200-000000000010'
  ),
  'T020-B-ISSUE-002 tenant and initiator derive from current authoritative membership'
);

select is(
  (select count(*)::integer from public.later_user_enrollment_intents),
  1,
  'T020-B-ISSUE-003 competing operation creates no second intent'
);

select is(
  (select count(*)::integer from public.verification_challenges where email = 'target-main@example.test'),
  1,
  'T020-B-ISSUE-004 competing operation creates no second challenge'
);

create temporary table task020_resend_results (
  label text primary key,
  outcome text not null,
  changed boolean not null,
  intent_id uuid,
  challenge_id uuid,
  issued_at timestamptz,
  expires_at timestamptz,
  reason text not null
);
grant select, insert on task020_resend_results to authenticated;

set local role authenticated;
select set_config('request.jwt.claim.sub', 'a2000000-0000-4000-8000-000000000004', true);
insert into task020_resend_results
select 'cross-tenant', result.*
from public.resend_later_user_enrollment_challenge(
  'e2000000-0000-4000-8000-000000000010',
  'e2000000-0000-4000-8200-000000000020',
  decode(repeat('31', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000020'
) as result;

select set_config('request.jwt.claim.sub', 'a2000000-0000-4000-8000-000000000005', true);
insert into task020_resend_results
select 'other-admin', result.*
from public.resend_later_user_enrollment_challenge(
  'e2000000-0000-4000-8000-000000000010',
  'e2000000-0000-4000-8200-000000000021',
  decode(repeat('32', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000021'
) as result;

select set_config('request.jwt.claim.sub', 'a2000000-0000-4000-8000-000000000001', true);
insert into task020_resend_results
select 'resent', result.*
from public.resend_later_user_enrollment_challenge(
  'e2000000-0000-4000-8000-000000000010',
  'e2000000-0000-4000-8200-000000000022',
  decode(repeat('33', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000022'
) as result;

insert into task020_resend_results
select 'resend-retry', result.*
from public.resend_later_user_enrollment_challenge(
  'e2000000-0000-4000-8000-000000000010',
  'e2000000-0000-4000-8200-000000000022',
  decode(repeat('33', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000022'
) as result;
reset role;

update public.company_memberships
set is_enabled = false
where id = 'd2000000-0000-4000-8000-000000000001';

set local role authenticated;
select set_config('request.jwt.claim.sub', 'a2000000-0000-4000-8000-000000000005', true);
insert into task020_resend_results
select 'initiator-authority-lost', result.*
from public.resend_later_user_enrollment_challenge(
  'e2000000-0000-4000-8000-000000000010',
  'e2000000-0000-4000-8200-000000000023',
  decode(repeat('34', 32), 'hex'),
  'v1',
  'e2000000-0000-4000-8300-000000000023'
) as result;
reset role;

update public.company_memberships
set is_enabled = true
where id = 'd2000000-0000-4000-8000-000000000001';

select ok(
  (select outcome = 'DENIED' and reason = 'NOT_ELIGIBLE' from task020_resend_results where label = 'cross-tenant')
  and (select outcome = 'RESENT' and changed from task020_resend_results where label = 'other-admin'),
  'T020-B-RESEND-001 cross-tenant access is denied while a different current same-tenant admin may resend without replacing historical provenance'
);

select ok(
  (select outcome = 'RESENT' and changed from task020_resend_results where label = 'resent')
  and (select outcome = 'ALREADY_RECONCILED' and not changed from task020_resend_results where label = 'resend-retry')
  and exists (
    select 1
    from public.later_user_enrollment_intents
    where id = 'e2000000-0000-4000-8000-000000000010'
      and current_challenge_id = 'e2000000-0000-4000-8200-000000000022'
  ),
  'T020-B-RESEND-002 resend rotates the pointer atomically and same-operation retry reconciles'
);

select ok(
  exists (
    select 1
    from public.verification_challenges
    where id = 'e2000000-0000-4000-8200-000000000010'
      and invalidated_at is not null
  )
  and (
    select count(*) = 1
    from public.verification_challenges
    where supersedes_challenge_id = 'e2000000-0000-4000-8200-000000000010'
  ),
  'T020-B-RESEND-003 predecessor invalidation and one successor preserve TASK-013 semantics'
);

select ok(
  (
    select outcome = 'CONFLICT' and reason = 'PRODUCT_DECISION_REQUIRED'
    from task020_resend_results
    where label = 'initiator-authority-lost'
  ),
  'T020-B-RESEND-004 actual loss of initiating-admin authority remains blocked for product decision'
);

set local role service_role;
select is(
  (
    select target_email
    from public.get_later_user_enrollment_delivery_target(
      'e2000000-0000-4000-8000-000000000010',
      'e2000000-0000-4000-8200-000000000022'
    )
  ),
  'target-main@example.test',
  'T020-D-DELIVERY-001 server delivery target derives exact email from committed intent state'
);

select is(
  (
    select challenge_id
    from public.get_later_user_enrollment_challenge_material(
      'e2000000-0000-4000-8000-000000000010',
      'target-main@example.test',
      'e2000000-0000-4000-8400-000000000001'
    )
  ),
  'e2000000-0000-4000-8200-000000000022'::uuid,
  'T020-C-VERIFY-001 pre-auth material resolver derives only the intent current challenge'
);

select throws_ok(
  $$select * from public.verify_verification_challenge(
    'e2000000-0000-4000-8200-000000000022',
    'target-main@example.test',
    'e2000000-0000-4000-8400-000000000090',
    true,
    'v1'
  )$$,
  'P0001',
  'Verification attempt denied.',
  'T020-C-VERIFY-002 generic TASK-013 boundary cannot bypass TASK-020 intent verification'
);

select is(
  (
    select outcome || ':' || attempt_number::text || ':' || handoff_ready::text
    from public.verify_later_user_enrollment_challenge(
      'e2000000-0000-4000-8000-000000000010',
      'e2000000-0000-4000-8200-000000000022',
      'target-main@example.test',
      'e2000000-0000-4000-8400-000000000001',
      false,
      'v1'
    )
  ),
  'INVALID:1:false',
  'T020-C-VERIFY-003 first wrong proof consumes exactly one effective attempt'
);

select is(
  (
    select outcome || ':' || attempt_number::text || ':' || handoff_ready::text
    from public.verify_later_user_enrollment_challenge(
      'e2000000-0000-4000-8000-000000000010',
      'e2000000-0000-4000-8200-000000000022',
      'target-main@example.test',
      'e2000000-0000-4000-8400-000000000002',
      false,
      'v1'
    )
  ),
  'INVALID:2:false',
  'T020-C-VERIFY-004 second wrong proof consumes exactly one effective attempt'
);

select is(
  (
    select outcome || ':' || attempt_number::text || ':' || handoff_ready::text
    from public.verify_later_user_enrollment_challenge(
      'e2000000-0000-4000-8000-000000000010',
      'e2000000-0000-4000-8200-000000000022',
      'target-main@example.test',
      'e2000000-0000-4000-8400-000000000003',
      true,
      'v1'
    )
  ),
  'CONSUMED:3:true',
  'T020-C-VERIFY-005 correct third proof atomically consumes and creates handoff'
);

select is(
  (
    select outcome || ':' || attempt_number::text || ':' || handoff_ready::text
    from public.verify_later_user_enrollment_challenge(
      'e2000000-0000-4000-8000-000000000010',
      'e2000000-0000-4000-8200-000000000022',
      'target-main@example.test',
      'e2000000-0000-4000-8400-000000000003',
      true,
      'v1'
    )
  ),
  'CONSUMED:3:true',
  'T020-C-VERIFY-006 same successful operation reconciles exactly the prior result'
);
reset role;

select ok(
  (
    select challenge.consumed_at is not null
      and challenge.attempt_count = 3
      and intent.handoff_session_grant_id is not null
      and intent.handoff_ready_at = challenge.consumed_at
      and session_grant.challenge_id = challenge.id
      and session_grant.grant_operation_id = 'e2000000-0000-4000-8400-000000000003'
      and session_grant.purpose = 'initial_session'
      and session_grant.auth_method = 'password'
      and session_grant.expires_at = session_grant.created_at + interval '5 minutes'
    from public.later_user_enrollment_intents as intent
    join public.verification_challenges as challenge
      on challenge.id = intent.current_challenge_id
    join public.auth_session_grants as session_grant
      on session_grant.id = intent.handoff_session_grant_id
    where intent.id = 'e2000000-0000-4000-8000-000000000010'
  ),
  'T020-C-HANDOFF-001 consume, grant and durable handoff are one correlated authoritative result'
);

select is(
  (
    select count(*)::integer
    from public.auth_session_grants
    where challenge_id = 'e2000000-0000-4000-8200-000000000022'
  ),
  1,
  'T020-C-HANDOFF-002 successful retry creates no second SessionGrant'
);

select is(
  (select count(*)::integer from public.platform_users),
  5,
  'T020-C-SCOPE-001 verification creates no target PlatformUser'
);

select is(
  (select count(*)::integer from public.company_memberships),
  5,
  'T020-C-SCOPE-002 verification creates no target CompanyMembership'
);

select is(
  (select count(*)::integer from public.audit_events),
  0,
  'T020-C-SCOPE-003 TASK-020 emits no AuditEvent or USER_CREATED action'
);

select * from finish();

rollback;
