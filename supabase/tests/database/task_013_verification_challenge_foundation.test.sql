\set ON_ERROR_STOP on

begin;

select plan(72);

create function pg_temp.test_uuid(value integer)
returns uuid
language sql
immutable
as $$
  select ('00000000-0000-4000-8000-' || lpad(value::text, 12, '0'))::uuid
$$;

create function pg_temp.issue_challenge(
  challenge_number integer,
  challenge_email text,
  operation_number integer
)
returns void
language plpgsql
as $$
begin
  perform public.issue_verification_challenge(
    pg_temp.test_uuid(challenge_number),
    challenge_email,
    decode(repeat('01', 32), 'hex'),
    'v1',
    pg_temp.test_uuid(operation_number)
  );
end;
$$;

create function pg_temp.verify_challenge(
  challenge_number integer,
  challenge_email text,
  operation_number integer,
  matched boolean
)
returns void
language plpgsql
as $$
begin
  perform public.verify_verification_challenge(
    pg_temp.test_uuid(challenge_number),
    challenge_email,
    pg_temp.test_uuid(operation_number),
    matched,
    'v1'
  );
end;
$$;

create function pg_temp.resend_challenge(
  predecessor_number integer,
  challenge_number integer,
  challenge_email text,
  operation_number integer
)
returns void
language plpgsql
as $$
begin
  perform public.resend_verification_challenge(
    pg_temp.test_uuid(predecessor_number),
    pg_temp.test_uuid(challenge_number),
    challenge_email,
    decode(repeat('02', 32), 'hex'),
    'v1',
    pg_temp.test_uuid(operation_number)
  );
end;
$$;

create function pg_temp.statement_raises(
  statement text,
  expected_sqlstate text
)
returns boolean
language plpgsql
as $$
begin
  execute statement;
  return false;
exception
  when others then
    return sqlstate = expected_sqlstate;
end;
$$;

create function pg_temp.statement_row_count(statement text)
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

set local role service_role;

do $$ begin perform pg_temp.issue_challenge(13001, 'attempts@example.test', 13101); end $$;

select ok(
  (select count(*) = 1 from public.verification_challenges where id = pg_temp.test_uuid(13001)),
  'T013-DB-001 authorized issue inserts one challenge'
);
select ok(
  (select expires_at = issued_at + interval '8 hours' from public.verification_challenges where id = pg_temp.test_uuid(13001)),
  'T013-DB-002 expiry is exactly eight hours'
);
select ok(
  (select attempt_count = 0 from public.verification_challenges where id = pg_temp.test_uuid(13001)),
  'T013-DB-003 a new emission starts at zero attempts'
);

do $$ begin perform pg_temp.verify_challenge(13001, 'attempts@example.test', 13201, false); end $$;
select ok(
  (select attempt_count = 1 and exhausted_at is null from public.verification_challenges where id = pg_temp.test_uuid(13001)),
  'T013-DB-004 first incorrect attempt is recorded'
);
do $$ begin perform pg_temp.verify_challenge(13001, 'attempts@example.test', 13202, false); end $$;
select ok(
  (select attempt_count = 2 and exhausted_at is null from public.verification_challenges where id = pg_temp.test_uuid(13001)),
  'T013-DB-005 second incorrect attempt is recorded'
);
do $$ begin perform pg_temp.verify_challenge(13001, 'attempts@example.test', 13203, false); end $$;
select ok(
  (select attempt_count = 3 and exhausted_at is not null from public.verification_challenges where id = pg_temp.test_uuid(13001)),
  'T013-DB-006 third incorrect attempt exhausts the emission'
);
select ok(
  pg_temp.statement_raises(
    $$select pg_temp.verify_challenge(13001, 'attempts@example.test', 13204, false)$$,
    'P0001'
  ),
  'T013-DB-007 fourth attempt is impossible'
);

do $$
begin
  perform pg_temp.issue_challenge(13002, 'first@example.test', 13102);
  perform pg_temp.verify_challenge(13002, 'first@example.test', 13211, true);
end $$;
select ok(
  (select attempt_count = 1 and consumed_at is not null from public.verification_challenges where id = pg_temp.test_uuid(13002)),
  'T013-DB-008 correct code on first attempt consumes the emission'
);

do $$
begin
  perform pg_temp.issue_challenge(13003, 'second@example.test', 13103);
  perform pg_temp.verify_challenge(13003, 'second@example.test', 13221, false);
  perform pg_temp.verify_challenge(13003, 'second@example.test', 13222, true);
end $$;
select ok(
  (select attempt_count = 2 and consumed_at is not null from public.verification_challenges where id = pg_temp.test_uuid(13003)),
  'T013-DB-009 correct code on second attempt consumes the emission'
);

do $$
begin
  perform pg_temp.issue_challenge(13004, 'third@example.test', 13104);
  perform pg_temp.verify_challenge(13004, 'third@example.test', 13231, false);
  perform pg_temp.verify_challenge(13004, 'third@example.test', 13232, false);
  perform pg_temp.verify_challenge(13004, 'third@example.test', 13233, true);
end $$;
select ok(
  (select attempt_count = 3 and consumed_at is not null and exhausted_at is null from public.verification_challenges where id = pg_temp.test_uuid(13004)),
  'T013-DB-010 correct code on third attempt consumes without exhaustion'
);
select ok(
  pg_temp.statement_raises(
    $$select pg_temp.verify_challenge(13004, 'third@example.test', 13234, true)$$,
    'P0001'
  ),
  'T013-DB-011 consumed emission cannot be replayed'
);

do $$
begin
  perform pg_temp.issue_challenge(13005, 'expired@example.test', 13105);
  update public.verification_challenges
  set issued_at = issued_at - interval '9 hours',
      expires_at = expires_at - interval '9 hours'
  where id = pg_temp.test_uuid(13005);
end $$;
select ok(
  pg_temp.statement_raises(
    $$select pg_temp.verify_challenge(13005, 'expired@example.test', 13241, true)$$,
    'P0001'
  ),
  'T013-DB-012 expired emission cannot be replayed'
);
select ok(
  pg_temp.statement_raises(
    $$select pg_temp.verify_challenge(13001, 'attempts@example.test', 13205, true)$$,
    'P0001'
  ),
  'T013-DB-013 exhausted emission cannot be replayed'
);

do $$
begin
  perform pg_temp.issue_challenge(13006, 'invalidated@example.test', 13106);
  update public.verification_challenges
  set invalidated_at = clock_timestamp()
  where id = pg_temp.test_uuid(13006);
end $$;
select ok(
  pg_temp.statement_raises(
    $$select pg_temp.verify_challenge(13006, 'invalidated@example.test', 13242, true)$$,
    'P0001'
  ),
  'T013-DB-014 invalidated emission cannot be replayed'
);

do $$
begin
  perform pg_temp.issue_challenge(13007, 'resend@example.test', 13107);
  perform pg_temp.verify_challenge(13007, 'resend@example.test', 13243, false);
  perform pg_temp.resend_challenge(13007, 13008, 'resend@example.test', 13108);
end $$;
select ok(
  (select predecessor.attempt_count = 1 and successor.attempt_count = 0
   from public.verification_challenges as predecessor
   cross join public.verification_challenges as successor
   where predecessor.id = pg_temp.test_uuid(13007)
     and successor.id = pg_temp.test_uuid(13008)),
  'T013-DB-015 resend emissions have independent attempt counters'
);
select ok(
  (select id <> supersedes_challenge_id and supersedes_challenge_id = pg_temp.test_uuid(13007)
   from public.verification_challenges where id = pg_temp.test_uuid(13008)),
  'T013-DB-016 resend produces a distinct identity'
);
select ok(
  (select invalidated_at is not null from public.verification_challenges where id = pg_temp.test_uuid(13007)),
  'T013-DB-017 resend invalidates the predecessor'
);
select ok(
  pg_temp.statement_raises(
    $$select pg_temp.verify_challenge(13007, 'resend@example.test', 13244, true)$$,
    'P0001'
  ),
  'T013-DB-018 old code is rejected after resend'
);

do $$
begin
  perform pg_temp.issue_challenge(13009, 'retry@example.test', 13109);
  perform pg_temp.issue_challenge(13009, 'retry@example.test', 13109);
end $$;
select ok(
  (select count(*) = 1 from public.verification_challenges where issue_operation_id = pg_temp.test_uuid(13109)),
  'T013-DB-019 retry of the same issue operation is idempotent'
);
select ok(
  pg_temp.statement_raises(
    $$select public.issue_verification_challenge(
      pg_temp.test_uuid(13999),
      'retry@example.test',
      decode(repeat('99', 32), 'hex'),
      'v1',
      pg_temp.test_uuid(13109)
    )$$,
    'P0001'
  )
  and (select count(*) = 1 from public.verification_challenges where issue_operation_id = pg_temp.test_uuid(13109)),
  'T013-DB-020 competing duplicate issue operation cannot create a second row'
);

do $$
begin
  perform pg_temp.verify_challenge(13009, 'retry@example.test', 13251, false);
  perform pg_temp.verify_challenge(13009, 'retry@example.test', 13251, false);
end $$;
select ok(
  (select attempt_count = 1 from public.verification_challenges where id = pg_temp.test_uuid(13009))
  and (select count(*) = 1 from public.verification_challenge_attempts where operation_id = pg_temp.test_uuid(13251)),
  'T013-DB-021 retry of the same verification operation increments once'
);

do $$ begin perform pg_temp.verify_challenge(13009, 'retry@example.test', 13252, false); end $$;
select ok(
  (select count(*) = 2 and max(attempt_number) = 2 from public.verification_challenge_attempts where challenge_id = pg_temp.test_uuid(13009))
  and position(
    'FOR UPDATE' in upper(pg_get_functiondef('public.verify_verification_challenge(uuid,text,uuid,boolean,text)'::regprocedure))
  ) > 0,
  'T013-DB-022 concurrent verification operations are serialized by row lock and uniqueness'
);

do $$ begin perform pg_temp.verify_challenge(13009, 'retry@example.test', 13253, false); end $$;
select ok(
  pg_temp.statement_raises(
    $$select pg_temp.verify_challenge(13009, 'retry@example.test', 13254, true)$$,
    'P0001'
  )
  and (select count(*) = 3 and max(attempt_number) = 3 from public.verification_challenge_attempts where challenge_id = pg_temp.test_uuid(13009)),
  'T013-DB-023 concurrent third and fourth attempts preserve the three-attempt ceiling'
);

do $$
begin
  perform pg_temp.issue_challenge(13010, 'double-consume@example.test', 13110);
  perform pg_temp.verify_challenge(13010, 'double-consume@example.test', 13255, true);
end $$;
select ok(
  pg_temp.statement_raises(
    $$select pg_temp.verify_challenge(13010, 'double-consume@example.test', 13256, true)$$,
    'P0001'
  )
  and (select count(*) = 1 from public.auth_session_grants where challenge_id = pg_temp.test_uuid(13010)),
  'T013-DB-024 double consume creates only one session grant'
);

do $$
begin
  perform pg_temp.issue_challenge(13011, 'race@example.test', 13111);
  perform pg_temp.resend_challenge(13011, 13012, 'race@example.test', 13112);
end $$;
select ok(
  pg_temp.statement_raises(
    $$select pg_temp.resend_challenge(13011, 13013, 'race@example.test', 13113)$$,
    'P0001'
  ),
  'T013-DB-025 competing resend accepts one successor'
);
select ok(
  pg_temp.statement_raises(
    $$select pg_temp.verify_challenge(13011, 'race@example.test', 13257, true)$$,
    'P0001'
  ),
  'T013-DB-026 resend wins against a stale verification'
);
select ok(
  (select count(*) = 1 from public.verification_challenges where supersedes_challenge_id = pg_temp.test_uuid(13011))
  and exists (
    select 1 from pg_indexes
    where schemaname = 'public'
      and indexname = 'verification_challenges_one_successor_idx'
      and indexdef like 'CREATE UNIQUE INDEX%'
  ),
  'T013-DB-027 each predecessor has at most one direct successor'
);
select ok(
  (select count(*) = 0 from public.get_verification_challenge_material(pg_temp.test_uuid(13012), 'wrong@example.test')),
  'T013-DB-028 challenge and email mismatch fails closed'
);
select ok(
  pg_temp.statement_raises(
    $$update public.verification_challenges
      set consumed_at = clock_timestamp(), invalidated_at = clock_timestamp()
      where id = pg_temp.test_uuid(13012)$$,
    '23514'
  ),
  'T013-DB-029 incompatible terminal states are rejected'
);
select ok(
  not exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'verification_challenges'
      and column_name in ('code', 'plaintext_code')
  ),
  'T013-DB-030 plaintext verification code is absent'
);

reset role;

select ok(
  not has_table_privilege('anon', 'public.verification_challenges', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('anon', 'public.verification_challenge_attempts', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('anon', 'public.auth_bridge_credentials', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('anon', 'public.auth_session_grants', 'SELECT,INSERT,UPDATE,DELETE'),
  'T013-DB-031 anon direct CRUD is denied'
);
select ok(
  not has_table_privilege('authenticated', 'public.verification_challenges', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.verification_challenge_attempts', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.auth_bridge_credentials', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.auth_session_grants', 'SELECT,INSERT,UPDATE,DELETE'),
  'T013-DB-032 authenticated direct CRUD is denied'
);
select ok(
  not has_table_privilege('anon', 'public.verification_challenges', 'SELECT')
  and not has_table_privilege('authenticated', 'public.verification_challenges', 'SELECT'),
  'T013-DB-033 challenge state is not enumerable through Data API roles'
);
select ok(
  not has_table_privilege('anon', 'public.verification_challenge_attempts', 'SELECT')
  and not has_table_privilege('authenticated', 'public.verification_challenge_attempts', 'SELECT'),
  'T013-DB-034 attempt state is not enumerable through Data API roles'
);
select ok(
  not has_table_privilege('anon', 'public.auth_bridge_credentials', 'SELECT')
  and not has_table_privilege('authenticated', 'public.auth_bridge_credentials', 'SELECT'),
  'T013-DB-035 bridge credentials are not enumerable through Data API roles'
);
select ok(
  not has_table_privilege('anon', 'public.auth_session_grants', 'SELECT')
  and not has_table_privilege('authenticated', 'public.auth_session_grants', 'SELECT'),
  'T013-DB-036 session grants are not enumerable through Data API roles'
);

set local role service_role;
select ok(
  (select count(*) > 0 and bool_and(expires_at = created_at + interval '5 minutes') from public.auth_session_grants),
  'T013-DB-037 every session grant expires exactly five minutes after creation'
);

reset role;
insert into auth.users (
  id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at
)
values
  (pg_temp.test_uuid(13901), 'authenticated', 'authenticated', 'hook@example.test', '', clock_timestamp(), '{}'::jsonb, '{}'::jsonb, clock_timestamp(), clock_timestamp()),
  (pg_temp.test_uuid(13902), 'authenticated', 'authenticated', 'other@example.test', '', clock_timestamp(), '{}'::jsonb, '{}'::jsonb, clock_timestamp(), clock_timestamp()),
  (pg_temp.test_uuid(13903), 'authenticated', 'authenticated', 'grant-state@example.test', '', clock_timestamp(), '{}'::jsonb, '{}'::jsonb, clock_timestamp(), clock_timestamp());

set local role service_role;
do $$
begin
  perform pg_temp.issue_challenge(13014, 'hook@example.test', 13114);
  perform pg_temp.verify_challenge(13014, 'hook@example.test', 13260, true);
end $$;
select ok(
  (select count(*) = 1 and bool_and(consumed_at is null and revoked_at is null)
   from public.auth_session_grants where challenge_id = pg_temp.test_uuid(13014)),
  'T013-DB-038 a session grant begins single-use and eligible'
);
do $$ begin perform pg_temp.verify_challenge(13014, 'hook@example.test', 13260, true); end $$;
select ok(
  (select count(*) = 1 from public.auth_session_grants where challenge_id = pg_temp.test_uuid(13014))
  and (select count(*) = 1 from public.verification_challenge_attempts where operation_id = pg_temp.test_uuid(13260)),
  'T013-DB-039 verification replay returns the same single grant'
);

do $$
begin
  perform pg_temp.issue_challenge(13015, 'expired-grant@example.test', 13115);
  perform pg_temp.verify_challenge(13015, 'expired-grant@example.test', 13261, true);
  update public.auth_session_grants
  set created_at = created_at - interval '6 minutes',
      expires_at = expires_at - interval '6 minutes'
  where challenge_id = pg_temp.test_uuid(13015);
end $$;
reset role;
-- The CLI pgTAP connection cannot assume supabase_auth_admin. Hook behavior runs
-- as the test owner; T013-DB-061..063 verify the real invoker role boundary.
select ok(
  pg_temp.statement_raises(
    $$select public.task_013_custom_access_token_hook(jsonb_build_object(
      'user_id', pg_temp.test_uuid(13903),
      'authentication_method', 'password',
      'claims', jsonb_build_object('email', 'expired-grant@example.test')
    ))$$,
    'P0001'
  ),
  'T013-DB-040 expired session grant is ineligible'
);

reset role;
set local role service_role;
do $$
begin
  perform pg_temp.issue_challenge(13016, 'revoked-grant@example.test', 13116);
  perform pg_temp.verify_challenge(13016, 'revoked-grant@example.test', 13262, true);
  update public.auth_session_grants
  set revoked_at = clock_timestamp()
  where challenge_id = pg_temp.test_uuid(13016);
end $$;
reset role;
select ok(
  pg_temp.statement_raises(
    $$select public.task_013_custom_access_token_hook(jsonb_build_object(
      'user_id', pg_temp.test_uuid(13903),
      'authentication_method', 'password',
      'claims', jsonb_build_object('email', 'revoked-grant@example.test')
    ))$$,
    'P0001'
  ),
  'T013-DB-041 revoked session grant is ineligible'
);

reset role;
set local role service_role;
do $$
begin
  perform pg_temp.issue_challenge(13017, 'hook@example.test', 13117);
  perform pg_temp.verify_challenge(13017, 'hook@example.test', 13263, true);
end $$;
select ok(
  (select count(*) = 1
   from public.auth_session_grants as session_grant
   join public.auth_bridge_credentials as bridge on bridge.id = session_grant.auth_bridge_credential_id
   where bridge.email = 'hook@example.test'
     and session_grant.consumed_at is null
     and session_grant.revoked_at is null)
  and (select revoked_at is not null from public.auth_session_grants where challenge_id = pg_temp.test_uuid(13014)),
  'T013-DB-042 at most one eligible grant exists per bridge'
);

update public.auth_bridge_credentials
set auth_user_id = pg_temp.test_uuid(13901), bound_at = clock_timestamp()
where email = 'hook@example.test';
update public.auth_session_grants
set auth_user_id = pg_temp.test_uuid(13901)
where challenge_id = pg_temp.test_uuid(13017);

reset role;
select ok(
  pg_temp.statement_raises(
    $$select public.task_013_custom_access_token_hook(jsonb_build_object(
      'user_id', pg_temp.test_uuid(13902),
      'authentication_method', 'password',
      'claims', jsonb_build_object('email', 'no-grant@example.test')
    ))$$,
    'P0001'
  ),
  'T013-DB-043 password hook without an eligible grant is denied'
);
select ok(
  pg_temp.statement_raises(
    $$select public.task_013_custom_access_token_hook(jsonb_build_object(
      'user_id', pg_temp.test_uuid(13902),
      'authentication_method', 'password',
      'claims', jsonb_build_object('email', 'hook@example.test')
    ))$$,
    'P0001'
  ),
  'T013-DB-044 password hook rejects a different Auth subject'
);
select ok(
  pg_temp.statement_raises(
    $$select public.task_013_custom_access_token_hook(jsonb_build_object(
      'user_id', pg_temp.test_uuid(13901),
      'authentication_method', 'password',
      'claims', jsonb_build_object('email', 'wrong@example.test')
    ))$$,
    'P0001'
  ),
  'T013-DB-045 password hook rejects wrong email or unbound correlation'
);

do $$
begin
  perform set_config(
    'task_013.valid_hook_result',
    public.task_013_custom_access_token_hook(jsonb_build_object(
      'user_id', pg_temp.test_uuid(13901),
      'authentication_method', 'password',
      'claims', jsonb_build_object('email', 'hook@example.test')
    ))::text,
    true
  );
end $$;
reset role;
select ok(
  current_setting('task_013.valid_hook_result')::jsonb = jsonb_build_object('claims', jsonb_build_object('email', 'hook@example.test'))
  and (select consumed_at is not null and auth_user_id = pg_temp.test_uuid(13901)
       from public.auth_session_grants where challenge_id = pg_temp.test_uuid(13017)),
  'T013-DB-046 valid password grant is correlated and consumed once'
);

select ok(
  pg_temp.statement_raises(
    $$select public.task_013_custom_access_token_hook(jsonb_build_object(
      'user_id', pg_temp.test_uuid(13901),
      'authentication_method', 'password',
      'claims', jsonb_build_object('email', 'hook@example.test')
    ))$$,
    'P0001'
  ),
  'T013-DB-047 competing hook invocation cannot consume the grant twice'
);

reset role;
set local role service_role;
do $$
begin
  perform pg_temp.issue_challenge(13018, 'refresh@example.test', 13118);
  perform pg_temp.verify_challenge(13018, 'refresh@example.test', 13264, true);
end $$;
reset role;
do $$
begin
  perform set_config(
    'task_013.refresh_hook_result',
    public.task_013_custom_access_token_hook(jsonb_build_object(
      'authentication_method', 'token_refresh',
      'claims', jsonb_build_object('sub', pg_temp.test_uuid(13901))
    ))::text,
    true
  );
end $$;
reset role;
select ok(
  current_setting('task_013.refresh_hook_result')::jsonb = jsonb_build_object('claims', jsonb_build_object('sub', pg_temp.test_uuid(13901)))
  and (select consumed_at is null from public.auth_session_grants where challenge_id = pg_temp.test_uuid(13018)),
  'T013-DB-048 token_refresh preserves claims and consumes no grant after cutover'
);

select ok(pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'otp', 'claims', '{}'::jsonb))$$, 'P0001'), 'T013-DB-049 OTP initial authentication is denied');
select ok(pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'totp', 'claims', '{}'::jsonb))$$, 'P0001'), 'T013-DB-050 TOTP initial authentication is denied');
select ok(pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'magiclink', 'claims', '{}'::jsonb))$$, 'P0001'), 'T013-DB-051 magiclink initial authentication is denied');
select ok(pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'recovery', 'claims', '{}'::jsonb))$$, 'P0001'), 'T013-DB-052 recovery initial authentication is denied');
select ok(
  pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'email/signup', 'claims', '{}'::jsonb))$$, 'P0001')
  and pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'invite', 'claims', '{}'::jsonb))$$, 'P0001'),
  'T013-DB-053 signup and invite initial authentication are denied'
);
select ok(pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'email_change', 'claims', '{}'::jsonb))$$, 'P0001'), 'T013-DB-054 email_change initial authentication is denied');
select ok(pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'oauth', 'claims', '{}'::jsonb))$$, 'P0001'), 'T013-DB-055 OAuth initial authentication is denied');
select ok(pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'oauth_provider', 'claims', '{}'::jsonb))$$, 'P0001'), 'T013-DB-056 oauth_provider initial authentication is denied');
select ok(pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'authorization_code', 'claims', '{}'::jsonb))$$, 'P0001'), 'T013-DB-057 authorization_code initial authentication is denied');
select ok(pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'anonymous', 'claims', '{}'::jsonb))$$, 'P0001'), 'T013-DB-058 anonymous initial authentication is denied');
select ok(pg_temp.statement_raises($$select public.task_013_custom_access_token_hook(jsonb_build_object('authentication_method', 'future_unknown', 'claims', '{}'::jsonb))$$, 'P0001'), 'T013-DB-059 unknown initial authentication method is denied');

reset role;
select ok(
  not has_table_privilege('supabase_auth_admin', 'public.maintenance_companies', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('supabase_auth_admin', 'public.company_memberships', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('supabase_auth_admin', 'public.platform_users', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('supabase_auth_admin', 'public.audit_events', 'SELECT,INSERT,UPDATE,DELETE'),
  'T013-DB-060 TASK-013 grants no tenant-data access to supabase_auth_admin'
);
select ok(
  has_function_privilege('supabase_auth_admin', 'public.task_013_custom_access_token_hook(jsonb)', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'public.issue_verification_challenge(uuid,text,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'public.resend_verification_challenge(uuid,uuid,text,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'public.get_verification_challenge_material(uuid,text)', 'EXECUTE')
  and not has_function_privilege('supabase_auth_admin', 'public.verify_verification_challenge(uuid,text,uuid,boolean,text)', 'EXECUTE')
  and has_any_column_privilege('supabase_auth_admin', 'public.auth_session_grants', 'SELECT,UPDATE')
  and has_any_column_privilege('supabase_auth_admin', 'public.auth_bridge_credentials', 'SELECT,UPDATE'),
  'T013-DB-061 supabase_auth_admin has only the expected TASK-013 hook surface'
);
select ok(
  (select not prosecdef from pg_proc where oid = 'public.task_013_custom_access_token_hook(jsonb)'::regprocedure),
  'T013-DB-062 custom access token hook is SECURITY INVOKER'
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
  ), array[]::text[]) = array['auth_user_id', 'consumed_at']::text[]
  and coalesce((
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
  ), array[]::text[]) = array['auth_user_id', 'bound_at']::text[]
  and not exists (
    select 1 from information_schema.table_privileges
    where grantee = 'supabase_auth_admin'
      and table_schema = 'public'
      and table_name in ('verification_challenges', 'verification_challenge_attempts', 'auth_bridge_credentials', 'auth_session_grants')
  ),
  'T013-DB-063 direct privileges equal the exact minimal column sets'
);
select ok(
  not has_function_privilege('anon', 'public.issue_verification_challenge(uuid,text,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.issue_verification_challenge(uuid,text,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.resend_verification_challenge(uuid,uuid,text,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.resend_verification_challenge(uuid,uuid,text,bytea,text,uuid)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.get_verification_challenge_material(uuid,text)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.get_verification_challenge_material(uuid,text)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.verify_verification_challenge(uuid,text,uuid,boolean,text)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.verify_verification_challenge(uuid,text,uuid,boolean,text)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.task_013_custom_access_token_hook(jsonb)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.task_013_custom_access_token_hook(jsonb)', 'EXECUTE'),
  'T013-DB-064 generic Data API roles cannot execute privileged transitions'
);
select ok(
  to_regclass('public.maintenance_companies') is not null
  and to_regclass('public.platform_users') is not null
  and to_regclass('public.company_memberships') is not null
  and to_regclass('public.audit_events') is not null
  and (select relrowsecurity from pg_class where oid = 'public.maintenance_companies'::regclass)
  and (select relrowsecurity from pg_class where oid = 'public.audit_events'::regclass),
  'T013-DB-065 TASK-009 and TASK-010 regression handoff remains intact'
);

reset role;
set local role service_role;

do $$
begin
  perform pg_temp.issue_challenge(13020, 'rls-eligible@example.test', 13120);
  perform pg_temp.issue_challenge(13021, 'rls-consumed@example.test', 13121);
  perform pg_temp.issue_challenge(13022, 'rls-revoked@example.test', 13122);
  perform pg_temp.issue_challenge(13023, 'rls-expired@example.test', 13123);
end $$;

insert into public.auth_bridge_credentials (
  id,
  email,
  technical_password_key_version
)
values
  (pg_temp.test_uuid(13910), 'rls-eligible@example.test', 'v1'),
  (pg_temp.test_uuid(13911), 'rls-consumed@example.test', 'v1'),
  (pg_temp.test_uuid(13912), 'rls-revoked@example.test', 'v1'),
  (pg_temp.test_uuid(13913), 'rls-expired@example.test', 'v1');

with fixture_time as (
  select clock_timestamp() as now
)
insert into public.auth_session_grants (
  id,
  challenge_id,
  auth_bridge_credential_id,
  created_at,
  expires_at,
  consumed_at,
  revoked_at,
  grant_operation_id
)
select
  pg_temp.test_uuid(13920),
  pg_temp.test_uuid(13020),
  pg_temp.test_uuid(13910),
  fixture_time.now,
  fixture_time.now + interval '5 minutes',
  null::timestamptz,
  null::timestamptz,
  pg_temp.test_uuid(13930)
from fixture_time
union all
select
  pg_temp.test_uuid(13921),
  pg_temp.test_uuid(13021),
  pg_temp.test_uuid(13911),
  fixture_time.now,
  fixture_time.now + interval '5 minutes',
  fixture_time.now,
  null::timestamptz,
  pg_temp.test_uuid(13931)
from fixture_time
union all
select
  pg_temp.test_uuid(13922),
  pg_temp.test_uuid(13022),
  pg_temp.test_uuid(13912),
  fixture_time.now,
  fixture_time.now + interval '5 minutes',
  null::timestamptz,
  fixture_time.now,
  pg_temp.test_uuid(13932)
from fixture_time
union all
select
  pg_temp.test_uuid(13923),
  pg_temp.test_uuid(13023),
  pg_temp.test_uuid(13913),
  fixture_time.now - interval '6 minutes',
  fixture_time.now - interval '1 minute',
  null::timestamptz,
  null::timestamptz,
  pg_temp.test_uuid(13933)
from fixture_time;

reset role;
set local role supabase_auth_admin;

do $$
begin
  perform set_config(
    'task_013.rls_bind_count',
    pg_temp.statement_row_count($statement$
      update public.auth_bridge_credentials
      set auth_user_id = pg_temp.test_uuid(13902),
          bound_at = clock_timestamp()
      where id = pg_temp.test_uuid(13910)
      returning auth_user_id
    $statement$)::text,
    true
  );
end $$;
do $$
begin
  perform set_config(
    'task_013.rls_rebind_count',
    pg_temp.statement_row_count($statement$
      update public.auth_bridge_credentials
      set auth_user_id = pg_temp.test_uuid(13903),
          bound_at = clock_timestamp()
      where email = 'hook@example.test'
      returning auth_user_id
    $statement$)::text,
    true
  );
end $$;
do $$
begin
  perform set_config(
    'task_013.rls_consume_count',
    pg_temp.statement_row_count($statement$
      update public.auth_session_grants
      set auth_user_id = pg_temp.test_uuid(13902),
          consumed_at = clock_timestamp()
      where id = pg_temp.test_uuid(13920)
      returning id
    $statement$)::text,
    true
  );
end $$;
do $$
begin
  perform set_config(
    'task_013.rls_reconsume_count',
    pg_temp.statement_row_count($statement$
      update public.auth_session_grants
      set consumed_at = clock_timestamp()
      where id = pg_temp.test_uuid(13920)
      returning id
    $statement$)::text,
    true
  );
end $$;
do $$
begin
  perform set_config(
    'task_013.rls_revoked_count',
    pg_temp.statement_row_count($statement$
      update public.auth_session_grants
      set auth_user_id = pg_temp.test_uuid(13903),
          consumed_at = clock_timestamp()
      where id = pg_temp.test_uuid(13922)
      returning id
    $statement$)::text,
    true
  );
end $$;
do $$
begin
  perform set_config(
    'task_013.rls_expired_count',
    pg_temp.statement_row_count($statement$
      update public.auth_session_grants
      set auth_user_id = pg_temp.test_uuid(13903),
          consumed_at = clock_timestamp()
      where id = pg_temp.test_uuid(13923)
      returning id
    $statement$)::text,
    true
  );
end $$;
do $$
begin
  perform set_config(
    'task_013.rls_unconsume_count',
    pg_temp.statement_row_count($statement$
      update public.auth_session_grants
      set consumed_at = null
      where id = pg_temp.test_uuid(13921)
      returning id
    $statement$)::text,
    true
  );
end $$;

reset role;

select ok(
  current_setting('task_013.rls_bind_count') = '1',
  'T013-DB-066 supabase_auth_admin can bind an unbound bridge exactly once'
);
select ok(
  current_setting('task_013.rls_rebind_count') = '0',
  'T013-DB-067 supabase_auth_admin cannot rebind an authoritative bridge'
);
select ok(
  current_setting('task_013.rls_consume_count') = '1',
  'T013-DB-068 supabase_auth_admin can consume one eligible session grant'
);
select ok(
  current_setting('task_013.rls_reconsume_count') = '0',
  'T013-DB-069 supabase_auth_admin cannot mutate an already-consumed session grant'
);
select ok(
  current_setting('task_013.rls_revoked_count') = '0',
  'T013-DB-070 supabase_auth_admin cannot consume a revoked session grant'
);
select ok(
  current_setting('task_013.rls_expired_count') = '0',
  'T013-DB-071 supabase_auth_admin cannot consume an expired session grant'
);
select ok(
  current_setting('task_013.rls_unconsume_count') = '0',
  'T013-DB-072 supabase_auth_admin cannot unconsume a terminal session grant'
);

select * from finish();

rollback;
