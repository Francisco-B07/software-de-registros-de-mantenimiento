\set ON_ERROR_STOP on

begin;

select plan(75);

select ok(
  to_regclass('public.first_admin_onboarding_intents') is not null,
  'T017-SCHEMA-001 intent table exists'
);

select is(
  (
    select array_agg(column_name order by ordinal_position)::text
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'first_admin_onboarding_intents'
  ),
  '{id,maintenance_company_id,target_email,initiated_by_platform_user_id,establishment_operation_id,current_challenge_id,handoff_session_grant_id,handoff_ready_at,created_at}',
  'T017-SCHEMA-002 exact approved column set exists'
);

select is(
  (
    select array_agg(data_type order by ordinal_position)::text
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'first_admin_onboarding_intents'
  ),
  '{uuid,uuid,text,uuid,uuid,uuid,uuid,"timestamp with time zone","timestamp with time zone"}',
  'T017-SCHEMA-003 exact column types exist'
);

select is(
  (
    select array_agg(column_name order by ordinal_position)::text
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'first_admin_onboarding_intents'
      and is_nullable = 'NO'
  ),
  '{id,maintenance_company_id,target_email,initiated_by_platform_user_id,establishment_operation_id,current_challenge_id,created_at}',
  'T017-SCHEMA-004 only handoff pair is nullable'
);

select ok(
  (
    select column_default ilike '%clock_timestamp%'
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'first_admin_onboarding_intents'
      and column_name = 'created_at'
  ),
  'T017-SCHEMA-005 created_at is server authoritative'
);

select ok(
  (select relrowsecurity from pg_class where oid = 'public.first_admin_onboarding_intents'::regclass),
  'T017-RLS-001 RLS is enabled'
);

select is(
  (select count(*)::integer from pg_policy where polrelid = 'public.first_admin_onboarding_intents'::regclass),
  0,
  'T017-RLS-002 platform-owned intent has no artificial tenant policy'
);

select ok(
  not has_table_privilege('anon', 'public.first_admin_onboarding_intents', 'SELECT,INSERT,UPDATE,DELETE'),
  'T017-RLS-003 anon has no direct CRUD'
);

select ok(
  not has_table_privilege('authenticated', 'public.first_admin_onboarding_intents', 'SELECT,INSERT,UPDATE,DELETE'),
  'T017-RLS-004 authenticated has no direct CRUD'
);

select ok(
  not has_table_privilege('public', 'public.first_admin_onboarding_intents', 'SELECT,INSERT,UPDATE,DELETE'),
  'T017-RLS-005 PUBLIC has no direct CRUD'
);

select ok(
  not has_table_privilege('service_role', 'public.first_admin_onboarding_intents', 'SELECT,INSERT,UPDATE,DELETE'),
  'T017-RLS-006 service_role has no direct intent CRUD'
);

select ok(
  not has_table_privilege('supabase_auth_admin', 'public.first_admin_onboarding_intents', 'SELECT,INSERT,UPDATE,DELETE'),
  'T017-RLS-007 supabase_auth_admin has no intent CRUD'
);

select is(
  (
    select count(*)::integer
    from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and contype = 'f'
  ),
  4,
  'T017-SCHEMA-006 all four approved foreign keys exist'
);

select ok(
  not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and contype = 'f'
      and confdeltype <> 'r'
  ),
  'T017-SCHEMA-007 every intent foreign key uses ON DELETE RESTRICT'
);

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and conname = 'first_admin_onboarding_intents_maintenance_company_id_key'
      and contype = 'u'
  ),
  'T017-SCHEMA-008 one intent per company is database-enforced'
);

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and conname = 'first_admin_onboarding_intents_establishment_operation_id_key'
      and contype = 'u'
  ),
  'T017-SCHEMA-009 establishment operation is unique'
);

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and conname = 'first_admin_onboarding_intents_current_challenge_id_key'
      and contype = 'u'
  ),
  'T017-SCHEMA-010 current challenge cannot be shared'
);

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and conname = 'first_admin_onboarding_intents_handoff_session_grant_id_key'
      and contype = 'u'
  ),
  'T017-SCHEMA-011 handoff grant cannot be shared'
);

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and conname = 'first_admin_onboarding_intents_target_email_check'
      and contype = 'c'
  ),
  'T017-SCHEMA-012 blank target email is rejected'
);

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.first_admin_onboarding_intents'::regclass
      and conname = 'first_admin_onboarding_intents_handoff_state_check'
      and contype = 'c'
  ),
  'T017-SCHEMA-013 handoff pair invariant exists'
);

select ok(
  exists (
    select 1
    from pg_index
    where indrelid = 'public.first_admin_onboarding_intents'::regclass
      and indexrelid = 'public.first_admin_onboarding_intents_initiated_by_platform_user_id_idx'::regclass
  ),
  'T017-SCHEMA-014 initiator foreign key is indexed'
);

select ok(
  not exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'first_admin_onboarding_intents'
      and column_name in ('role', 'purpose', 'status', 'completed_at', 'onboarding_completed_at')
  ),
  'T017-SCOPE-001 no role purpose status or completion field was invented'
);

select ok(
  not exists (
    select 1
    from pg_index as index_definition
    join pg_attribute as attribute
      on attribute.attrelid = index_definition.indrelid
      and attribute.attnum = any(index_definition.indkey)
    where index_definition.indrelid = 'public.first_admin_onboarding_intents'::regclass
      and index_definition.indisunique
      and attribute.attname = 'target_email'
  ),
  'T017-SCOPE-002 target email is not globally unique'
);

select ok(
  not exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'verification_challenges'
      and column_name in ('maintenance_company_id', 'role', 'purpose')
  ),
  'T017-SCOPE-003 VerificationChallenge received no tenant role or purpose fields'
);

select is(
  (select count(*)::integer from public.first_admin_onboarding_intents),
  0,
  'T017-SCOPE-004 migration performs no historical intent backfill'
);

insert into public.maintenance_companies (id)
values
  ('17000000-0000-4000-8000-000000000001'),
  ('17000000-0000-4000-8000-000000000002');

insert into public.platform_users (id, is_super_admin)
values ('17000000-0000-4000-8000-000000000010', true);

insert into public.verification_challenges (
  id, email, verifier, verifier_key_version, issued_at, expires_at, issue_operation_id
)
values
  ('17000000-0000-4000-8000-000000000101', 'first-admin@example.test', decode(repeat('11', 32), 'hex'), 'v1', statement_timestamp(), statement_timestamp() + interval '8 hours', '17000000-0000-4000-8000-000000000201'),
  ('17000000-0000-4000-8000-000000000102', 'first-admin@example.test', decode(repeat('22', 32), 'hex'), 'v1', statement_timestamp(), statement_timestamp() + interval '8 hours', '17000000-0000-4000-8000-000000000202');

insert into public.first_admin_onboarding_intents (
  id,
  maintenance_company_id,
  target_email,
  initiated_by_platform_user_id,
  establishment_operation_id,
  current_challenge_id
)
values (
  '17000000-0000-4000-8000-000000000301',
  '17000000-0000-4000-8000-000000000001',
  'first-admin@example.test',
  '17000000-0000-4000-8000-000000000010',
  '17000000-0000-4000-8000-000000000401',
  '17000000-0000-4000-8000-000000000101'
);

select is(
  (select count(*)::integer from public.first_admin_onboarding_intents),
  1,
  'T017-SCHEMA-015 valid pending-handoff intent is accepted'
);

select throws_ok(
  $$insert into public.first_admin_onboarding_intents (id, maintenance_company_id, target_email, initiated_by_platform_user_id, establishment_operation_id, current_challenge_id, handoff_ready_at) values ('17000000-0000-4000-8000-000000000302', '17000000-0000-4000-8000-000000000002', 'first-admin@example.test', '17000000-0000-4000-8000-000000000010', '17000000-0000-4000-8000-000000000402', '17000000-0000-4000-8000-000000000102', statement_timestamp())$$,
  '23514',
  null,
  'T017-SCHEMA-016 handoff timestamp without grant is rejected'
);

insert into public.auth_bridge_credentials (
  id, email, technical_password_key_version
)
values (
  '17000000-0000-4000-8000-000000000501',
  'other-first-admin@example.test',
  'v1'
);

insert into public.auth_session_grants (
  id, challenge_id, auth_bridge_credential_id, created_at, expires_at, grant_operation_id
)
values (
  '17000000-0000-4000-8000-000000000601',
  '17000000-0000-4000-8000-000000000102',
  '17000000-0000-4000-8000-000000000501',
  statement_timestamp(),
  statement_timestamp() + interval '5 minutes',
  '17000000-0000-4000-8000-000000000701'
);

select throws_ok(
  $$update public.first_admin_onboarding_intents set handoff_session_grant_id = '17000000-0000-4000-8000-000000000601' where id = '17000000-0000-4000-8000-000000000301'$$,
  '23514',
  null,
  'T017-SCHEMA-017 handoff grant without timestamp is rejected'
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
values (
  '17000000-0000-4000-8000-000000000303',
  '17000000-0000-4000-8000-000000000002',
  'first-admin@example.test',
  '17000000-0000-4000-8000-000000000010',
  '17000000-0000-4000-8000-000000000403',
  '17000000-0000-4000-8000-000000000102',
  '17000000-0000-4000-8000-000000000601',
  statement_timestamp()
);

select is(
  (select count(*)::integer from public.first_admin_onboarding_intents where target_email = 'first-admin@example.test'),
  2,
  'T017-SCHEMA-018 same target email can be bound to distinct companies'
);

select throws_ok(
  $$delete from public.maintenance_companies where id = '17000000-0000-4000-8000-000000000001'$$,
  '23503',
  null,
  'T017-SCHEMA-019 company deletion is restricted by historical intent state'
);

select throws_ok(
  $$delete from public.verification_challenges where id = '17000000-0000-4000-8000-000000000101'$$,
  '23503',
  null,
  'T017-SCHEMA-020 current challenge deletion is restricted'
);

select ok(
  not exists (
    select 1 from information_schema.table_privileges
    where table_schema = 'public'
      and table_name = 'first_admin_onboarding_intents'
      and grantee in ('anon', 'authenticated', 'PUBLIC', 'service_role', 'supabase_auth_admin')
      and privilege_type in ('SELECT', 'INSERT', 'UPDATE', 'DELETE')
  ),
  'T017-RLS-008 catalog contains no direct CRUD grants for runtime roles'
);

insert into auth.users (id, email)
values
  ('97000000-0000-4000-8000-000000000001', 'actor-super@example.test'),
  ('97000000-0000-4000-8000-000000000002', 'actor-ordinary@example.test'),
  ('97000000-0000-4000-8000-000000000003', 'actor-enabled@example.test'),
  ('97000000-0000-4000-8000-000000000004', 'actor-disabled@example.test'),
  ('97000000-0000-4000-8000-000000000005', 'known-super@example.test'),
  ('97000000-0000-4000-8000-000000000006', 'known-member@example.test');

insert into public.platform_users (id, is_super_admin)
values
  ('17000000-0000-4000-8000-000000000901', true),
  ('17000000-0000-4000-8000-000000000902', false),
  ('17000000-0000-4000-8000-000000000903', true),
  ('17000000-0000-4000-8000-000000000904', true),
  ('17000000-0000-4000-8000-000000000905', true),
  ('17000000-0000-4000-8000-000000000906', false);

insert into public.platform_user_auth_subjects (auth_subject_id, platform_user_id)
values
  ('97000000-0000-4000-8000-000000000001', '17000000-0000-4000-8000-000000000901'),
  ('97000000-0000-4000-8000-000000000002', '17000000-0000-4000-8000-000000000902'),
  ('97000000-0000-4000-8000-000000000003', '17000000-0000-4000-8000-000000000903'),
  ('97000000-0000-4000-8000-000000000004', '17000000-0000-4000-8000-000000000904'),
  ('97000000-0000-4000-8000-000000000005', '17000000-0000-4000-8000-000000000905'),
  ('97000000-0000-4000-8000-000000000006', '17000000-0000-4000-8000-000000000906');

insert into public.maintenance_companies (id)
values
  ('17000000-0000-4000-8000-000000001001'),
  ('17000000-0000-4000-8000-000000001002'),
  ('17000000-0000-4000-8000-000000001003'),
  ('17000000-0000-4000-8000-000000001004'),
  ('17000000-0000-4000-8000-000000001005'),
  ('17000000-0000-4000-8000-000000001006'),
  ('17000000-0000-4000-8000-000000001007'),
  ('17000000-0000-4000-8000-000000001008');

insert into public.company_memberships (
  id, platform_user_id, maintenance_company_id, role, is_enabled
)
values
  ('17000000-0000-4000-8000-000000001103', '17000000-0000-4000-8000-000000000903', '17000000-0000-4000-8000-000000001001', 'COMPANY_ADMIN', true),
  ('17000000-0000-4000-8000-000000001104', '17000000-0000-4000-8000-000000000904', '17000000-0000-4000-8000-000000001001', 'TECHNICIAN', false),
  ('17000000-0000-4000-8000-000000001106', '17000000-0000-4000-8000-000000000906', '17000000-0000-4000-8000-000000001001', 'COMPANY_ADMIN', true);

create temporary table task017_issue_results (
  label text primary key,
  outcome text not null,
  changed boolean not null,
  intent_id uuid,
  challenge_id uuid,
  issued_at timestamptz,
  expires_at timestamptz,
  reason text not null
);
grant select, insert on task017_issue_results to authenticated;

set local role authenticated;

select set_config('request.jwt.claim.sub', '', true);
insert into task017_issue_results
select 'missing-session', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000001',
  '17000000-0000-4000-8000-000000001001',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000101',
  '17100000-0000-4000-8000-000000000201',
  decode(repeat('31', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000301'
) as result;

select set_config('request.jwt.claim.sub', '97000000-0000-4000-8000-000000000099', true);
insert into task017_issue_results
select 'unknown-subject', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000002',
  '17000000-0000-4000-8000-000000001001',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000102',
  '17100000-0000-4000-8000-000000000202',
  decode(repeat('32', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000302'
) as result;

select set_config('request.jwt.claim.sub', '97000000-0000-4000-8000-000000000002', true);
insert into task017_issue_results
select 'not-super', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000003',
  '17000000-0000-4000-8000-000000001001',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000103',
  '17100000-0000-4000-8000-000000000203',
  decode(repeat('33', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000303'
) as result;

select set_config('request.jwt.claim.sub', '97000000-0000-4000-8000-000000000003', true);
insert into task017_issue_results
select 'enabled-membership', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000004',
  '17000000-0000-4000-8000-000000001001',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000104',
  '17100000-0000-4000-8000-000000000204',
  decode(repeat('34', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000304'
) as result;

select set_config('request.jwt.claim.sub', '97000000-0000-4000-8000-000000000004', true);
insert into task017_issue_results
select 'disabled-membership', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000005',
  '17000000-0000-4000-8000-000000001001',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000105',
  '17100000-0000-4000-8000-000000000205',
  decode(repeat('35', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000305'
) as result;

select set_config('request.jwt.claim.role', 'SUPER_ADMIN', true);
select set_config('request.jwt.claim.sub', '97000000-0000-4000-8000-000000000002', true);
insert into task017_issue_results
select 'stale-claim', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000006',
  '17000000-0000-4000-8000-000000001001',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000106',
  '17100000-0000-4000-8000-000000000206',
  decode(repeat('36', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000306'
) as result;

select set_config('request.jwt.claim.role', '', true);
select set_config('request.jwt.claim.sub', '97000000-0000-4000-8000-000000000001', true);
insert into task017_issue_results
select 'established', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000010',
  '17000000-0000-4000-8000-000000001001',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000110',
  '17100000-0000-4000-8000-000000000210',
  decode(repeat('41', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000310'
) as result;

insert into task017_issue_results
select 'established-retry', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000010',
  '17000000-0000-4000-8000-000000001001',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000110',
  '17100000-0000-4000-8000-000000000210',
  decode(repeat('41', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000310'
) as result;

insert into task017_issue_results
select 'established-conflict', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000010',
  '17000000-0000-4000-8000-000000001001',
  'different@example.test',
  '17100000-0000-4000-8000-000000000110',
  '17100000-0000-4000-8000-000000000210',
  decode(repeat('41', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000310'
) as result;

insert into task017_issue_results
select 'competing-intent', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000011',
  '17000000-0000-4000-8000-000000001001',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000111',
  '17100000-0000-4000-8000-000000000211',
  decode(repeat('42', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000311'
) as result;

insert into task017_issue_results
select 'known-super-target', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000012',
  '17000000-0000-4000-8000-000000001002',
  'known-super@example.test',
  '17100000-0000-4000-8000-000000000112',
  '17100000-0000-4000-8000-000000000212',
  decode(repeat('43', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000312'
) as result;

insert into task017_issue_results
select 'known-member-target', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000013',
  '17000000-0000-4000-8000-000000001003',
  'known-member@example.test',
  '17100000-0000-4000-8000-000000000113',
  '17100000-0000-4000-8000-000000000213',
  decode(repeat('44', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000313'
) as result;

reset role;

select is((select outcome from task017_issue_results where label = 'missing-session'), 'DENIED', 'T017-AUTH-001 missing session is denied');
select is((select outcome from task017_issue_results where label = 'unknown-subject'), 'DENIED', 'T017-AUTH-002 unknown subject is denied');
select is((select outcome from task017_issue_results where label = 'not-super'), 'DENIED', 'T017-AUTH-003 DB non-SUPER_ADMIN is denied');
select is((select reason from task017_issue_results where label = 'enabled-membership'), 'INCONSISTENT_AUTHORITY', 'T017-AUTH-004 enabled membership invalidates global authority');
select is((select reason from task017_issue_results where label = 'disabled-membership'), 'INCONSISTENT_AUTHORITY', 'T017-AUTH-005 disabled membership invalidates global authority');
select is((select outcome from task017_issue_results where label = 'stale-claim'), 'DENIED', 'T017-AUTH-006 stale SUPER_ADMIN claim grants no authority');
select is((select outcome from task017_issue_results where label = 'established'), 'ESTABLISHED', 'T017-ISSUE-001 current authoritative SUPER_ADMIN establishes intent');
select ok((select changed from task017_issue_results where label = 'established'), 'T017-ISSUE-002 first establishment reports changed');
select is((select outcome from task017_issue_results where label = 'established-retry'), 'ALREADY_RECONCILED', 'T017-IDEM-001 same establishment operation reconciles');
select ok(not (select changed from task017_issue_results where label = 'established-retry'), 'T017-IDEM-002 establishment reconciliation creates no duplicate');
select is((select outcome from task017_issue_results where label = 'established-conflict'), 'CONFLICT', 'T017-IDEM-003 same establishment operation with different email conflicts');
select is((select reason from task017_issue_results where label = 'competing-intent'), 'COMPETING_INTENT', 'T017-IDEM-004 distinct establishment cannot compete for one company');
select is((select outcome from task017_issue_results where label = 'known-super-target'), 'DENIED', 'T017-AUTH-007 known target SUPER_ADMIN state is ineligible');
select is((select outcome from task017_issue_results where label = 'known-member-target'), 'DENIED', 'T017-AUTH-008 known target membership state is ineligible');
select ok(
  exists (
    select 1
    from public.first_admin_onboarding_intents as intent
    join public.verification_challenges as challenge on challenge.id = intent.current_challenge_id
    where intent.id = '17100000-0000-4000-8000-000000000010'
      and intent.maintenance_company_id = '17000000-0000-4000-8000-000000001001'
      and intent.target_email = challenge.email
      and challenge.issue_operation_id = '17100000-0000-4000-8000-000000000310'
  ),
  'T017-ISSUE-003 intent challenge and current pointer commit together'
);
select ok(
  exists (
    select 1 from public.verification_challenges
    where id = '17100000-0000-4000-8000-000000000210'
      and expires_at = issued_at + interval '8 hours'
      and attempt_count = 0
      and num_nonnulls(consumed_at, invalidated_at, exhausted_at) = 0
  ),
  'T017-ISSUE-004 first challenge preserves TASK-013 8h zero-attempt lifecycle'
);
select is(
  (select count(*)::integer from public.company_memberships where platform_user_id = '17000000-0000-4000-8000-000000000901'),
  0,
  'T017-ISSUE-005 initiating SUPER_ADMIN receives no membership'
);

update public.platform_users
set is_super_admin = false
where id = '17000000-0000-4000-8000-000000000901';

set local role authenticated;
select set_config('request.jwt.claim.sub', '97000000-0000-4000-8000-000000000001', true);
insert into task017_issue_results
select 'revoked-retry', result.*
from public.establish_first_admin_onboarding_intent(
  '17100000-0000-4000-8000-000000000010',
  '17000000-0000-4000-8000-000000001001',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000110',
  '17100000-0000-4000-8000-000000000210',
  decode(repeat('41', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000310'
) as result;
reset role;

select is((select outcome from task017_issue_results where label = 'revoked-retry'), 'DENIED', 'T017-AUTH-009 authority is revalidated before positive reconciliation');

update public.platform_users
set is_super_admin = true
where id = '17000000-0000-4000-8000-000000000901';

create temporary table task017_resend_results (
  label text primary key,
  outcome text not null,
  changed boolean not null,
  intent_id uuid,
  challenge_id uuid,
  issued_at timestamptz,
  expires_at timestamptz,
  reason text not null
);
grant select, insert on task017_resend_results to authenticated;

set local role authenticated;
select set_config('request.jwt.claim.sub', '97000000-0000-4000-8000-000000000001', true);
insert into task017_resend_results
select 'active', result.*
from public.resend_first_admin_onboarding_challenge(
  '17100000-0000-4000-8000-000000000010',
  '17100000-0000-4000-8000-000000000220',
  decode(repeat('51', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000320'
) as result;

insert into task017_resend_results
select 'active-retry', result.*
from public.resend_first_admin_onboarding_challenge(
  '17100000-0000-4000-8000-000000000010',
  '17100000-0000-4000-8000-000000000220',
  decode(repeat('51', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000320'
) as result;
reset role;

select is((select outcome from task017_resend_results where label = 'active'), 'RESENT', 'T017-RESEND-001 active current challenge can be replaced');
select is((select outcome from task017_resend_results where label = 'active-retry'), 'ALREADY_RECONCILED', 'T017-RESEND-002 same resend operation reconciles one successor');
select ok(
  exists (
    select 1
    from public.verification_challenges as predecessor
    join public.verification_challenges as successor on successor.supersedes_challenge_id = predecessor.id
    join public.first_admin_onboarding_intents as intent on intent.current_challenge_id = successor.id
    where predecessor.id = '17100000-0000-4000-8000-000000000210'
      and predecessor.invalidated_at is not null
      and successor.id = '17100000-0000-4000-8000-000000000220'
      and successor.attempt_count = 0
      and successor.expires_at = successor.issued_at + interval '8 hours'
      and intent.id = '17100000-0000-4000-8000-000000000010'
  ),
  'T017-RESEND-003 predecessor successor and pointer rotate atomically'
);
select is(
  (select count(*)::integer from public.verification_challenges where supersedes_challenge_id = '17100000-0000-4000-8000-000000000210'),
  1,
  'T017-RESEND-004 predecessor has at most one successor'
);

create temporary table task017_verify_results (
  label text primary key,
  outcome text not null,
  attempt_number smallint not null,
  handoff_ready boolean not null
);
grant select, insert on task017_verify_results to service_role;

set local role service_role;
select is(
  (select target_email from public.get_first_admin_onboarding_delivery_target('17100000-0000-4000-8000-000000000010', '17100000-0000-4000-8000-000000000220')),
  'admin-one@example.test',
  'T017-DELIVERY-001 server-only delivery target derives email from committed current intent state'
);
select is(
  (select challenge_id from public.get_first_admin_onboarding_challenge_material('17100000-0000-4000-8000-000000000010', 'admin-one@example.test', '17100000-0000-4000-8000-000000000409')),
  '17100000-0000-4000-8000-000000000220'::uuid,
  'T017-VERIFY-001 server-only material resolver returns only current bound challenge'
);
select is_empty(
  $$select * from public.get_first_admin_onboarding_challenge_material('17100000-0000-4000-8000-000000000010', 'wrong@example.test', '17100000-0000-4000-8000-000000000409')$$,
  'T017-VERIFY-002 mismatched email reveals no material'
);

insert into task017_verify_results
select 'wrong-one', result.*
from public.verify_first_admin_onboarding_challenge(
  '17100000-0000-4000-8000-000000000010',
  '17100000-0000-4000-8000-000000000220',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000410',
  false,
  'v1'
) as result;

insert into task017_verify_results
select 'wrong-one-retry', result.*
from public.verify_first_admin_onboarding_challenge(
  '17100000-0000-4000-8000-000000000010',
  '17100000-0000-4000-8000-000000000220',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000410',
  false,
  'v1'
) as result;

insert into task017_verify_results
select 'correct-two', result.*
from public.verify_first_admin_onboarding_challenge(
  '17100000-0000-4000-8000-000000000010',
  '17100000-0000-4000-8000-000000000220',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000411',
  true,
  'v1'
) as result;

insert into task017_verify_results
select 'correct-two-retry', result.*
from public.verify_first_admin_onboarding_challenge(
  '17100000-0000-4000-8000-000000000010',
  '17100000-0000-4000-8000-000000000220',
  'admin-one@example.test',
  '17100000-0000-4000-8000-000000000411',
  true,
  'v1'
) as result;

select throws_ok(
  $$select * from public.verify_first_admin_onboarding_challenge('17100000-0000-4000-8000-000000000010', '17100000-0000-4000-8000-000000000220', 'admin-one@example.test', '17100000-0000-4000-8000-000000000412', true, 'v1')$$,
  'P0001',
  'First-admin verification request denied.',
  'T017-VERIFY-003 different-operation replay of consumed current is denied'
);
select throws_ok(
  $$select * from public.verify_verification_challenge('17100000-0000-4000-8000-000000000220', 'admin-one@example.test', '17100000-0000-4000-8000-000000000413', true, 'v1')$$,
  'P0001',
  'Verification attempt denied.',
  'T017-VERIFY-004 generic TASK-013 consume cannot bypass TASK-017 handoff composition'
);
select throws_ok(
  $$select * from public.resend_verification_challenge('17100000-0000-4000-8000-000000000220', '17100000-0000-4000-8000-000000000221', 'admin-one@example.test', decode(repeat('52', 32), 'hex'), 'v1', '17100000-0000-4000-8000-000000000321')$$,
  'P0001',
  'Verification challenge request denied.',
  'T017-VERIFY-005 generic TASK-013 resend cannot bypass TASK-017 current pointer'
);
reset role;

select is((select attempt_number from task017_verify_results where label = 'wrong-one'), 1::smallint, 'T017-VERIFY-006 wrong proof consumes exactly one attempt');
select is((select attempt_number from task017_verify_results where label = 'wrong-one-retry'), 1::smallint, 'T017-IDEM-005 same wrong verification operation consumes no second attempt');
select ok(
  (select outcome = 'CONSUMED' and attempt_number = 2 and handoff_ready from task017_verify_results where label = 'correct-two'),
  'T017-VERIFY-007 correct proof on attempt two consumes and makes handoff ready'
);
select ok(
  (select outcome = 'CONSUMED' and attempt_number = 2 and handoff_ready from task017_verify_results where label = 'correct-two-retry'),
  'T017-IDEM-006 same successful verification operation reconciles'
);
select ok(
  exists (
    select 1
    from public.first_admin_onboarding_intents as intent
    join public.auth_session_grants as session_grant on session_grant.id = intent.handoff_session_grant_id
    join public.verification_challenges as challenge on challenge.id = session_grant.challenge_id
    where intent.id = '17100000-0000-4000-8000-000000000010'
      and session_grant.challenge_id = intent.current_challenge_id
      and session_grant.grant_operation_id = '17100000-0000-4000-8000-000000000411'
      and session_grant.purpose = 'initial_session'
      and session_grant.auth_method = 'password'
      and session_grant.expires_at = session_grant.created_at + interval '5 minutes'
      and intent.handoff_ready_at = session_grant.created_at
      and challenge.consumed_at is not null
  ),
  'T017-HANDOFF-001 consume SessionGrant and durable handoff facts are correlated atomically'
);
select is(
  (select count(*)::integer from public.auth_session_grants where challenge_id = '17100000-0000-4000-8000-000000000220'),
  1,
  'T017-HANDOFF-002 successful retry creates no second grant or handoff'
);
select is(
  (select count(*)::integer from public.company_memberships where maintenance_company_id = '17000000-0000-4000-8000-000000001001'),
  3,
  'T017-HANDOFF-003 proof and handoff create no CompanyMembership'
);
select ok(
  not exists (
    select 1 from public.platform_user_auth_subjects
    where platform_user_id not in (
      '17000000-0000-4000-8000-000000000901',
      '17000000-0000-4000-8000-000000000902',
      '17000000-0000-4000-8000-000000000903',
      '17000000-0000-4000-8000-000000000904',
      '17000000-0000-4000-8000-000000000905',
      '17000000-0000-4000-8000-000000000906'
    )
  ),
  'T017-HANDOFF-004 proof and handoff create no PlatformUser/Auth mapping'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '97000000-0000-4000-8000-000000000001', true);
insert into task017_resend_results
select 'consumed', result.*
from public.resend_first_admin_onboarding_challenge(
  '17100000-0000-4000-8000-000000000010',
  '17100000-0000-4000-8000-000000000222',
  decode(repeat('53', 32), 'hex'),
  'v1',
  '17100000-0000-4000-8000-000000000322'
) as result;
reset role;

select is((select reason from task017_resend_results where label = 'consumed'), 'HANDOFF_READY', 'T017-RESEND-005 ordinary resend after consumed handoff is denied');

select ok(
  has_function_privilege('authenticated', 'public.establish_first_admin_onboarding_intent(uuid,uuid,text,uuid,uuid,bytea,text,uuid)', 'EXECUTE')
  and has_function_privilege('authenticated', 'public.resend_first_admin_onboarding_challenge(uuid,uuid,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.establish_first_admin_onboarding_intent(uuid,uuid,text,uuid,uuid,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.resend_first_admin_onboarding_challenge(uuid,uuid,bytea,text,uuid)', 'EXECUTE'),
  'T017-RLS-009 only authenticated receives exact issue and resend EXECUTE'
);
select ok(
  has_function_privilege('service_role', 'public.get_first_admin_onboarding_delivery_target(uuid,uuid)', 'EXECUTE')
  and has_function_privilege('service_role', 'public.get_first_admin_onboarding_challenge_material(uuid,text,uuid)', 'EXECUTE')
  and has_function_privilege('service_role', 'public.verify_first_admin_onboarding_challenge(uuid,uuid,text,uuid,boolean,text)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.get_first_admin_onboarding_delivery_target(uuid,uuid)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.get_first_admin_onboarding_delivery_target(uuid,uuid)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.get_first_admin_onboarding_challenge_material(uuid,text,uuid)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.get_first_admin_onboarding_challenge_material(uuid,text,uuid)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.verify_first_admin_onboarding_challenge(uuid,uuid,text,uuid,boolean,text)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.verify_first_admin_onboarding_challenge(uuid,uuid,text,uuid,boolean,text)', 'EXECUTE'),
  'T017-RLS-010 raw pre-auth verify surface is server-only'
);
select ok(
  not has_function_privilege('supabase_auth_admin', 'public.establish_first_admin_onboarding_intent(uuid,uuid,text,uuid,uuid,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'public.resend_first_admin_onboarding_challenge(uuid,uuid,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'public.get_first_admin_onboarding_delivery_target(uuid,uuid)', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'public.get_first_admin_onboarding_challenge_material(uuid,text,uuid)', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'public.verify_first_admin_onboarding_challenge(uuid,uuid,text,uuid,boolean,text)', 'EXECUTE'),
  'T017-RLS-011 supabase_auth_admin receives no TASK-017 function access'
);
select ok(
  not has_function_privilege('public', 'public.establish_first_admin_onboarding_intent(uuid,uuid,text,uuid,uuid,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('public', 'public.resend_first_admin_onboarding_challenge(uuid,uuid,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('public', 'public.get_first_admin_onboarding_delivery_target(uuid,uuid)', 'EXECUTE')
  and not has_function_privilege('public', 'public.get_first_admin_onboarding_challenge_material(uuid,text,uuid)', 'EXECUTE')
  and not has_function_privilege('public', 'public.verify_first_admin_onboarding_challenge(uuid,uuid,text,uuid,boolean,text)', 'EXECUTE'),
  'T017-RLS-012 PUBLIC has no TASK-017 EXECUTE'
);
select ok(
  not exists (
    select 1
    from pg_proc
    where oid in (
      'public.establish_first_admin_onboarding_intent(uuid,uuid,text,uuid,uuid,bytea,text,uuid)'::regprocedure,
      'public.resend_first_admin_onboarding_challenge(uuid,uuid,bytea,text,uuid)'::regprocedure,
      'public.get_first_admin_onboarding_delivery_target(uuid,uuid)'::regprocedure,
      'public.get_first_admin_onboarding_challenge_material(uuid,text,uuid)'::regprocedure,
      'public.verify_first_admin_onboarding_challenge(uuid,uuid,text,uuid,boolean,text)'::regprocedure
    )
      and proconfig is distinct from array['search_path=""']::text[]
  ),
  'T017-RLS-013 every TASK-017 SECURITY DEFINER has empty search_path'
);
select ok(
  not has_table_privilege('supabase_auth_admin', 'public.maintenance_companies', 'INSERT,UPDATE,DELETE')
  and not has_table_privilege('supabase_auth_admin', 'public.company_memberships', 'INSERT,UPDATE,DELETE'),
  'T017-RLS-014 supabase_auth_admin tenant privileges remain unexpanded'
);

select * from finish();

rollback;
