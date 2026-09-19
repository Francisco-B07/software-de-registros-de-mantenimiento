create table public.first_admin_onboarding_intents (
  id uuid primary key,
  maintenance_company_id uuid not null,
  target_email text not null,
  initiated_by_platform_user_id uuid not null,
  establishment_operation_id uuid not null,
  current_challenge_id uuid not null,
  handoff_session_grant_id uuid,
  handoff_ready_at timestamptz,
  created_at timestamptz not null default clock_timestamp(),
  constraint first_admin_onboarding_intents_maintenance_company_id_fkey
    foreign key (maintenance_company_id)
    references public.maintenance_companies (id)
    on delete restrict,
  constraint first_admin_onboarding_intents_initiated_by_platform_user_id_fkey
    foreign key (initiated_by_platform_user_id)
    references public.platform_users (id)
    on delete restrict,
  constraint first_admin_onboarding_intents_current_challenge_id_fkey
    foreign key (current_challenge_id)
    references public.verification_challenges (id)
    on delete restrict,
  constraint first_admin_onboarding_intents_handoff_session_grant_id_fkey
    foreign key (handoff_session_grant_id)
    references public.auth_session_grants (id)
    on delete restrict,
  constraint first_admin_onboarding_intents_maintenance_company_id_key
    unique (maintenance_company_id),
  constraint first_admin_onboarding_intents_establishment_operation_id_key
    unique (establishment_operation_id),
  constraint first_admin_onboarding_intents_current_challenge_id_key
    unique (current_challenge_id),
  constraint first_admin_onboarding_intents_handoff_session_grant_id_key
    unique (handoff_session_grant_id),
  constraint first_admin_onboarding_intents_target_email_check
    check (btrim(target_email) <> ''),
  constraint first_admin_onboarding_intents_handoff_state_check
    check (
      (handoff_session_grant_id is null and handoff_ready_at is null)
      or
      (handoff_session_grant_id is not null and handoff_ready_at is not null)
    )
);

create index first_admin_onboarding_intents_initiated_by_platform_user_id_idx
on public.first_admin_onboarding_intents (initiated_by_platform_user_id);

alter table public.first_admin_onboarding_intents enable row level security;

revoke all privileges on table public.first_admin_onboarding_intents
from public, anon, authenticated, service_role, supabase_auth_admin;

comment on table public.first_admin_onboarding_intents is
  'Platform-owned TASK-017 binding for one company first-admin proof flow; handoff-ready is not onboarding completion or tenant authority.';

comment on column public.first_admin_onboarding_intents.target_email is
  'Immutable proof target and locator; it is not identity or tenant authority.';

comment on column public.first_admin_onboarding_intents.initiated_by_platform_user_id is
  'Historical initiating SUPER_ADMIN provenance; it is not current authority.';

comment on column public.first_admin_onboarding_intents.handoff_session_grant_id is
  'Durable correlation to the TASK-013 grant created by successful current-proof consume; it is not a browser bearer token.';

create function private.task_017_resend_verification_challenge(
  p_predecessor_challenge_id uuid,
  p_challenge_id uuid,
  p_email text,
  p_verifier bytea,
  p_verifier_key_version text,
  p_issue_operation_id uuid
)
returns table (
  challenge_id uuid,
  issued_at timestamptz,
  expires_at timestamptz
)
language plpgsql
volatile
security invoker
set search_path = ''
as $$
declare
  v_now timestamptz := clock_timestamp();
  v_predecessor public.verification_challenges%rowtype;
  v_existing public.verification_challenges%rowtype;
begin
  select * into v_existing
  from public.verification_challenges
  where issue_operation_id = p_issue_operation_id;

  if found then
    if v_existing.id <> p_challenge_id
      or v_existing.supersedes_challenge_id is distinct from p_predecessor_challenge_id
      or v_existing.email <> p_email
      or v_existing.verifier <> p_verifier
      or v_existing.verifier_key_version <> p_verifier_key_version then
      raise exception using errcode = 'P0001', message = 'Verification challenge request denied.';
    end if;
    return query select v_existing.id, v_existing.issued_at, v_existing.expires_at;
    return;
  end if;

  select * into strict v_predecessor
  from public.verification_challenges
  where id = p_predecessor_challenge_id
  for update;

  if v_predecessor.consumed_at is not null
    or v_predecessor.email <> p_email
    or p_challenge_id = p_predecessor_challenge_id then
    raise exception using errcode = 'P0001', message = 'Verification challenge request denied.';
  end if;

  select * into v_existing
  from public.verification_challenges
  where issue_operation_id = p_issue_operation_id;

  if not found then
    if exists (
      select 1 from public.verification_challenges
      where supersedes_challenge_id = p_predecessor_challenge_id
    ) then
      raise exception using errcode = 'P0001', message = 'Verification challenge request denied.';
    end if;

    if v_predecessor.exhausted_at is null
      and v_predecessor.invalidated_at is null then
      update public.verification_challenges
      set invalidated_at = v_now
      where id = p_predecessor_challenge_id;
    end if;

    insert into public.verification_challenges (
      id, email, verifier, verifier_key_version, issued_at, expires_at,
      supersedes_challenge_id, issue_operation_id
    ) values (
      p_challenge_id, p_email, p_verifier, p_verifier_key_version, v_now,
      v_now + interval '8 hours', p_predecessor_challenge_id,
      p_issue_operation_id
    );

    select * into strict v_existing
    from public.verification_challenges
    where issue_operation_id = p_issue_operation_id;
  end if;

  return query select v_existing.id, v_existing.issued_at, v_existing.expires_at;
end;
$$;

alter function private.task_017_resend_verification_challenge(uuid, uuid, text, bytea, text, uuid)
owner to postgres;

revoke all on function private.task_017_resend_verification_challenge(uuid, uuid, text, bytea, text, uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

create or replace function public.resend_verification_challenge(
  p_predecessor_challenge_id uuid,
  p_challenge_id uuid,
  p_email text,
  p_verifier bytea,
  p_verifier_key_version text,
  p_issue_operation_id uuid
)
returns table (
  challenge_id uuid,
  issued_at timestamptz,
  expires_at timestamptz
)
language plpgsql
volatile
security definer
set search_path = ''
as $$
begin
  perform intent.id
  from public.first_admin_onboarding_intents as intent
  where intent.current_challenge_id = p_predecessor_challenge_id
  for update;

  if found then
    raise exception using errcode = 'P0001', message = 'Verification challenge request denied.';
  end if;

  return query
  select result.challenge_id, result.issued_at, result.expires_at
  from private.task_017_resend_verification_challenge(
    p_predecessor_challenge_id,
    p_challenge_id,
    p_email,
    p_verifier,
    p_verifier_key_version,
    p_issue_operation_id
  ) as result;
end;
$$;

alter function public.resend_verification_challenge(uuid, uuid, text, bytea, text, uuid)
owner to postgres;

revoke all on function public.resend_verification_challenge(uuid, uuid, text, bytea, text, uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.resend_verification_challenge(uuid, uuid, text, bytea, text, uuid)
to service_role;

create function private.task_017_verify_verification_challenge(
  p_challenge_id uuid,
  p_email text,
  p_verification_operation_id uuid,
  p_matched boolean,
  p_technical_password_key_version text
)
returns table (
  outcome text,
  attempt_number smallint,
  auth_bridge_credential_id uuid,
  session_grant_id uuid
)
language plpgsql
volatile
security invoker
set search_path = ''
as $$
declare
  v_now timestamptz := clock_timestamp();
  v_challenge public.verification_challenges%rowtype;
  v_attempt public.verification_challenge_attempts%rowtype;
  v_bridge public.auth_bridge_credentials%rowtype;
  v_grant public.auth_session_grants%rowtype;
  v_attempt_number smallint;
begin
  if p_challenge_id is null
    or p_verification_operation_id is null
    or p_email is null
    or btrim(p_email) = ''
    or p_matched is null
    or p_technical_password_key_version is null
    or btrim(p_technical_password_key_version) = '' then
    raise exception using errcode = '22023', message = 'Verification attempt denied.';
  end if;

  select * into v_attempt
  from public.verification_challenge_attempts
  where operation_id = p_verification_operation_id;

  if found then
    if v_attempt.challenge_id <> p_challenge_id
      or v_attempt.matched is distinct from p_matched then
      raise exception using errcode = 'P0001', message = 'Verification attempt denied.';
    end if;
    select * into v_grant from public.auth_session_grants
    where challenge_id = p_challenge_id;
    return query select
      case
        when v_attempt.matched then 'CONSUMED'
        when v_attempt.attempt_number = 3 then 'EXHAUSTED'
        else 'INVALID'
      end,
      v_attempt.attempt_number,
      v_grant.auth_bridge_credential_id,
      v_grant.id;
    return;
  end if;

  select * into strict v_challenge
  from public.verification_challenges
  where id = p_challenge_id
  for update;

  select * into v_attempt
  from public.verification_challenge_attempts
  where operation_id = p_verification_operation_id;

  if found then
    if v_attempt.challenge_id <> p_challenge_id
      or v_attempt.matched is distinct from p_matched then
      raise exception using errcode = 'P0001', message = 'Verification attempt denied.';
    end if;
    select * into v_grant from public.auth_session_grants
    where challenge_id = p_challenge_id;
    return query select
      case
        when v_attempt.matched then 'CONSUMED'
        when v_attempt.attempt_number = 3 then 'EXHAUSTED'
        else 'INVALID'
      end,
      v_attempt.attempt_number,
      v_grant.auth_bridge_credential_id,
      v_grant.id;
    return;
  end if;

  if v_challenge.email <> p_email
    or v_challenge.consumed_at is not null
    or v_challenge.invalidated_at is not null
    or v_challenge.exhausted_at is not null
    or v_now >= v_challenge.expires_at
    or v_challenge.attempt_count >= 3 then
    raise exception using errcode = 'P0001', message = 'Verification attempt denied.';
  end if;

  v_attempt_number := (v_challenge.attempt_count + 1)::smallint;

  insert into public.verification_challenge_attempts (
    challenge_id, operation_id, attempt_number, matched, created_at
  ) values (
    p_challenge_id, p_verification_operation_id, v_attempt_number, p_matched,
    v_now
  ) returning * into v_attempt;

  if not p_matched then
    update public.verification_challenges
    set
      attempt_count = v_attempt_number,
      exhausted_at = case when v_attempt_number = 3 then v_now else null end
    where id = p_challenge_id;

    return query select
      case when v_attempt_number = 3 then 'EXHAUSTED' else 'INVALID' end,
      v_attempt_number,
      null::uuid,
      null::uuid;
    return;
  end if;

  update public.verification_challenges
  set attempt_count = v_attempt_number, consumed_at = v_now
  where id = p_challenge_id;

  insert into public.auth_bridge_credentials (
    email, technical_password_key_version
  ) values (
    p_email, p_technical_password_key_version
  )
  on conflict (email) do update set email = excluded.email
  returning * into v_bridge;

  if v_bridge.pending_key_version is not null then
    raise exception using errcode = 'P0001', message = 'Verification attempt denied.';
  end if;

  update public.auth_session_grants as session_grant
  set revoked_at = v_now
  where session_grant.auth_bridge_credential_id = v_bridge.id
    and session_grant.consumed_at is null
    and session_grant.revoked_at is null;

  insert into public.auth_session_grants (
    challenge_id,
    auth_bridge_credential_id,
    auth_user_id,
    created_at,
    expires_at,
    grant_operation_id
  ) values (
    p_challenge_id,
    v_bridge.id,
    v_bridge.auth_user_id,
    v_now,
    v_now + interval '5 minutes',
    p_verification_operation_id
  ) returning * into v_grant;

  return query select 'CONSUMED', v_attempt_number, v_bridge.id, v_grant.id;
end;
$$;

alter function private.task_017_verify_verification_challenge(uuid, text, uuid, boolean, text)
owner to postgres;

revoke all on function private.task_017_verify_verification_challenge(uuid, text, uuid, boolean, text)
from public, anon, authenticated, service_role, supabase_auth_admin;

create or replace function public.verify_verification_challenge(
  p_challenge_id uuid,
  p_email text,
  p_verification_operation_id uuid,
  p_matched boolean,
  p_technical_password_key_version text
)
returns table (
  outcome text,
  attempt_number smallint,
  auth_bridge_credential_id uuid,
  session_grant_id uuid
)
language plpgsql
volatile
security definer
set search_path = ''
as $$
begin
  perform intent.id
  from public.first_admin_onboarding_intents as intent
  where intent.current_challenge_id = p_challenge_id
  for update;

  if found then
    raise exception using errcode = 'P0001', message = 'Verification attempt denied.';
  end if;

  return query
  select
    result.outcome,
    result.attempt_number,
    result.auth_bridge_credential_id,
    result.session_grant_id
  from private.task_017_verify_verification_challenge(
    p_challenge_id,
    p_email,
    p_verification_operation_id,
    p_matched,
    p_technical_password_key_version
  ) as result;
end;
$$;

alter function public.verify_verification_challenge(uuid, text, uuid, boolean, text)
owner to postgres;

revoke all on function public.verify_verification_challenge(uuid, text, uuid, boolean, text)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.verify_verification_challenge(uuid, text, uuid, boolean, text)
to service_role;

create function private.task_017_resolve_current_global_actor()
returns table (
  platform_user_id uuid,
  authorization_reason text
)
language plpgsql
volatile
security invoker
set search_path = ''
as $$
declare
  v_auth_subject_id uuid := auth.uid();
  v_platform_user_id uuid;
  v_is_super_admin boolean;
begin
  if v_auth_subject_id is null then
    return query select null::uuid, 'AUTHORIZATION_DENIED'::text;
    return;
  end if;

  begin
    select platform_user.id, platform_user.is_super_admin
    into strict v_platform_user_id, v_is_super_admin
    from public.platform_user_auth_subjects as auth_subject
    join public.platform_users as platform_user
      on platform_user.id = auth_subject.platform_user_id
    where auth_subject.auth_subject_id = v_auth_subject_id
    for update of auth_subject, platform_user;
  exception
    when no_data_found or too_many_rows then
      return query select null::uuid, 'AUTHORIZATION_DENIED'::text;
      return;
  end;

  if not v_is_super_admin then
    return query select null::uuid, 'AUTHORIZATION_DENIED'::text;
    return;
  end if;

  if exists (
    select 1
    from public.company_memberships as membership
    where membership.platform_user_id = v_platform_user_id
  ) then
    return query select null::uuid, 'INCONSISTENT_AUTHORITY'::text;
    return;
  end if;

  return query select v_platform_user_id, 'AUTHORIZED'::text;
end;
$$;

alter function private.task_017_resolve_current_global_actor()
owner to postgres;

revoke all on function private.task_017_resolve_current_global_actor()
from public, anon, authenticated, service_role, supabase_auth_admin;

create function public.establish_first_admin_onboarding_intent(
  p_intent_id uuid,
  p_maintenance_company_id uuid,
  p_target_email text,
  p_establishment_operation_id uuid,
  p_challenge_id uuid,
  p_verifier bytea,
  p_verifier_key_version text,
  p_issue_operation_id uuid
)
returns table (
  outcome text,
  changed boolean,
  intent_id uuid,
  challenge_id uuid,
  issued_at timestamptz,
  expires_at timestamptz,
  reason text
)
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_actor record;
  v_intent public.first_admin_onboarding_intents%rowtype;
  v_challenge public.verification_challenges%rowtype;
  v_issue record;
begin
  select * into strict v_actor
  from private.task_017_resolve_current_global_actor();

  if v_actor.authorization_reason <> 'AUTHORIZED' then
    return query select
      'DENIED'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      v_actor.authorization_reason::text;
    return;
  end if;

  if p_intent_id is null
    or p_maintenance_company_id is null
    or p_target_email is null
    or btrim(p_target_email) = ''
    or p_target_email <> btrim(p_target_email)
    or p_establishment_operation_id is null
    or p_challenge_id is null
    or p_verifier is null
    or octet_length(p_verifier) <> 32
    or p_verifier_key_version is null
    or btrim(p_verifier_key_version) = ''
    or p_issue_operation_id is null then
    return query select
      'DENIED'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      'INVALID_INPUT'::text;
    return;
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(
      'task017-establish:' || p_establishment_operation_id::text,
      0
    )
  );

  perform company.id
  from public.maintenance_companies as company
  where company.id = p_maintenance_company_id
  for update;

  if not found then
    return query select
      'DENIED'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      'NOT_ELIGIBLE'::text;
    return;
  end if;

  select * into v_intent
  from public.first_admin_onboarding_intents as intent
  where intent.establishment_operation_id = p_establishment_operation_id
  for update;

  if found then
    if v_intent.maintenance_company_id <> p_maintenance_company_id
      or v_intent.target_email <> p_target_email then
      return query select
        'CONFLICT'::text, false, null::uuid, null::uuid,
        null::timestamptz, null::timestamptz,
        'IDEMPOTENCY_CONFLICT'::text;
      return;
    end if;

    with recursive challenge_chain as (
      select challenge.*
      from public.verification_challenges as challenge
      where challenge.id = v_intent.current_challenge_id

      union all

      select predecessor.*
      from public.verification_challenges as predecessor
      join challenge_chain as successor
        on successor.supersedes_challenge_id = predecessor.id
    )
    select * into v_challenge
    from challenge_chain
    where issue_operation_id = p_issue_operation_id;

    if not found
      or v_challenge.id <> p_challenge_id
      or v_challenge.supersedes_challenge_id is not null
      or v_challenge.email <> p_target_email
      or v_challenge.verifier <> p_verifier
      or v_challenge.verifier_key_version <> p_verifier_key_version then
      return query select
        'CONFLICT'::text, false, null::uuid, null::uuid,
        null::timestamptz, null::timestamptz,
        'IDEMPOTENCY_CONFLICT'::text;
      return;
    end if;

    return query select
      'ALREADY_RECONCILED'::text,
      false,
      v_intent.id,
      v_challenge.id,
      v_challenge.issued_at,
      v_challenge.expires_at,
      'ALREADY_RECONCILED'::text;
    return;
  end if;

  if exists (
    select 1
    from public.first_admin_onboarding_intents as intent
    where intent.maintenance_company_id = p_maintenance_company_id
  ) then
    return query select
      'CONFLICT'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      'COMPETING_INTENT'::text;
    return;
  end if;

  if exists (
    select 1
    from auth.users as auth_user
    join public.platform_user_auth_subjects as auth_subject
      on auth_subject.auth_subject_id = auth_user.id
    join public.platform_users as target_user
      on target_user.id = auth_subject.platform_user_id
    where auth_user.email = p_target_email
      and (
        target_user.is_super_admin
        or exists (
          select 1
          from public.company_memberships as target_membership
          where target_membership.platform_user_id = target_user.id
        )
      )
  ) then
    return query select
      'DENIED'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      'NOT_ELIGIBLE'::text;
    return;
  end if;

  if exists (
    select 1
    from public.verification_challenges as challenge
    where challenge.id = p_challenge_id
       or challenge.issue_operation_id = p_issue_operation_id
  ) then
    return query select
      'CONFLICT'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      'IDEMPOTENCY_CONFLICT'::text;
    return;
  end if;

  select * into strict v_issue
  from public.issue_verification_challenge(
    p_challenge_id,
    p_target_email,
    p_verifier,
    p_verifier_key_version,
    p_issue_operation_id
  );

  insert into public.first_admin_onboarding_intents (
    id,
    maintenance_company_id,
    target_email,
    initiated_by_platform_user_id,
    establishment_operation_id,
    current_challenge_id
  ) values (
    p_intent_id,
    p_maintenance_company_id,
    p_target_email,
    v_actor.platform_user_id,
    p_establishment_operation_id,
    v_issue.challenge_id
  )
  returning * into v_intent;

  return query select
    'ESTABLISHED'::text,
    true,
    v_intent.id,
    v_issue.challenge_id,
    v_issue.issued_at,
    v_issue.expires_at,
    'ESTABLISHED'::text;
exception
  when unique_violation then
    raise exception using
      errcode = 'P0001',
      message = 'First-admin onboarding intent establishment could not be confirmed.';
end;
$$;

alter function public.establish_first_admin_onboarding_intent(uuid, uuid, text, uuid, uuid, bytea, text, uuid)
owner to postgres;

revoke all on function public.establish_first_admin_onboarding_intent(uuid, uuid, text, uuid, uuid, bytea, text, uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.establish_first_admin_onboarding_intent(uuid, uuid, text, uuid, uuid, bytea, text, uuid)
to authenticated;

create function public.resend_first_admin_onboarding_challenge(
  p_intent_id uuid,
  p_challenge_id uuid,
  p_verifier bytea,
  p_verifier_key_version text,
  p_issue_operation_id uuid
)
returns table (
  outcome text,
  changed boolean,
  intent_id uuid,
  challenge_id uuid,
  issued_at timestamptz,
  expires_at timestamptz,
  reason text
)
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_actor record;
  v_intent public.first_admin_onboarding_intents%rowtype;
  v_existing public.verification_challenges%rowtype;
  v_successor record;
  v_predecessor_id uuid;
begin
  if p_intent_id is null
    or p_challenge_id is null
    or p_verifier is null
    or octet_length(p_verifier) <> 32
    or p_verifier_key_version is null
    or btrim(p_verifier_key_version) = ''
    or p_issue_operation_id is null then
    return query select
      'DENIED'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      'INVALID_INPUT'::text;
    return;
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(
      'task017-resend:' || p_issue_operation_id::text,
      0
    )
  );

  if not pg_catalog.pg_try_advisory_xact_lock(
    pg_catalog.hashtextextended(
      'task017-intent:' || p_intent_id::text,
      0
    )
  ) then
    return query select
      'STALE_OR_CONFLICT'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      'STALE_OR_CONFLICT'::text;
    return;
  end if;

  select * into strict v_actor
  from private.task_017_resolve_current_global_actor();

  if v_actor.authorization_reason <> 'AUTHORIZED' then
    return query select
      'DENIED'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      v_actor.authorization_reason::text;
    return;
  end if;

  select * into v_intent
  from public.first_admin_onboarding_intents as intent
  where intent.id = p_intent_id
  for update;

  if not found then
    return query select
      'DENIED'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      'NOT_ELIGIBLE'::text;
    return;
  end if;

  if v_intent.handoff_session_grant_id is not null then
    return query select
      'DENIED'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      'HANDOFF_READY'::text;
    return;
  end if;

  select * into v_existing
  from public.verification_challenges as challenge
  where challenge.issue_operation_id = p_issue_operation_id;

  if found then
    if v_existing.id = p_challenge_id
      and v_existing.id = v_intent.current_challenge_id
      and v_existing.supersedes_challenge_id is not null
      and v_existing.email = v_intent.target_email
      and v_existing.verifier = p_verifier
      and v_existing.verifier_key_version = p_verifier_key_version then
      return query select
        'ALREADY_RECONCILED'::text,
        false,
        v_intent.id,
        v_existing.id,
        v_existing.issued_at,
        v_existing.expires_at,
        'ALREADY_RECONCILED'::text;
      return;
    end if;

    return query select
      'CONFLICT'::text, false, null::uuid, null::uuid,
      null::timestamptz, null::timestamptz,
      'IDEMPOTENCY_CONFLICT'::text;
    return;
  end if;

  v_predecessor_id := v_intent.current_challenge_id;

  select * into strict v_successor
  from private.task_017_resend_verification_challenge(
    v_predecessor_id,
    p_challenge_id,
    v_intent.target_email,
    p_verifier,
    p_verifier_key_version,
    p_issue_operation_id
  );

  update public.first_admin_onboarding_intents as intent
  set current_challenge_id = v_successor.challenge_id
  where intent.id = v_intent.id
    and intent.current_challenge_id = v_predecessor_id
    and intent.handoff_session_grant_id is null;

  if not found then
    raise exception using
      errcode = 'P0001',
      message = 'First-admin onboarding challenge resend could not be confirmed.';
  end if;

  return query select
    'RESENT'::text,
    true,
    v_intent.id,
    v_successor.challenge_id,
    v_successor.issued_at,
    v_successor.expires_at,
    'RESENT'::text;
exception
  when unique_violation then
    raise exception using
      errcode = 'P0001',
      message = 'First-admin onboarding challenge resend could not be confirmed.';
end;
$$;

alter function public.resend_first_admin_onboarding_challenge(uuid, uuid, bytea, text, uuid)
owner to postgres;

revoke all on function public.resend_first_admin_onboarding_challenge(uuid, uuid, bytea, text, uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.resend_first_admin_onboarding_challenge(uuid, uuid, bytea, text, uuid)
to authenticated;

create function public.get_first_admin_onboarding_delivery_target(
  p_intent_id uuid,
  p_challenge_id uuid
)
returns table (
  target_email text,
  expires_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  select intent.target_email, challenge.expires_at
  from public.first_admin_onboarding_intents as intent
  join public.verification_challenges as challenge
    on challenge.id = intent.current_challenge_id
  where intent.id = p_intent_id
    and intent.current_challenge_id = p_challenge_id
    and intent.handoff_session_grant_id is null
    and challenge.email = intent.target_email
$$;

alter function public.get_first_admin_onboarding_delivery_target(uuid, uuid)
owner to postgres;

revoke all on function public.get_first_admin_onboarding_delivery_target(uuid, uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.get_first_admin_onboarding_delivery_target(uuid, uuid)
to service_role;

create function public.get_first_admin_onboarding_challenge_material(
  p_intent_id uuid,
  p_email text,
  p_verification_operation_id uuid
)
returns table (
  challenge_id uuid,
  verifier bytea,
  verifier_key_version text
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    challenge.id,
    challenge.verifier,
    challenge.verifier_key_version
  from public.first_admin_onboarding_intents as intent
  join public.verification_challenges as challenge
    on challenge.id = intent.current_challenge_id
  where intent.id = p_intent_id
    and intent.target_email = p_email
    and challenge.email = intent.target_email
    and challenge.invalidated_at is null
    and (
      (
        intent.handoff_session_grant_id is null
        and challenge.consumed_at is null
        and challenge.exhausted_at is null
        and challenge.attempt_count < 3
        and clock_timestamp() < challenge.expires_at
      )
      or
      exists (
        select 1
        from public.verification_challenge_attempts as attempt
        where attempt.operation_id = p_verification_operation_id
          and attempt.challenge_id = challenge.id
          and (
            (
              attempt.matched
              and challenge.consumed_at is not null
              and challenge.exhausted_at is null
              and intent.handoff_session_grant_id is not null
              and exists (
                select 1
                from public.auth_session_grants as session_grant
                where session_grant.id = intent.handoff_session_grant_id
                  and session_grant.challenge_id = challenge.id
                  and session_grant.grant_operation_id = attempt.operation_id
              )
            )
            or
            (
              not attempt.matched
              and attempt.attempt_number = 3
              and challenge.consumed_at is null
              and challenge.exhausted_at is not null
              and intent.handoff_session_grant_id is null
              and intent.handoff_ready_at is null
            )
          )
      )
    )
$$;

alter function public.get_first_admin_onboarding_challenge_material(uuid, text, uuid)
owner to postgres;

revoke all on function public.get_first_admin_onboarding_challenge_material(uuid, text, uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.get_first_admin_onboarding_challenge_material(uuid, text, uuid)
to service_role;

create function public.verify_first_admin_onboarding_challenge(
  p_intent_id uuid,
  p_expected_challenge_id uuid,
  p_email text,
  p_verification_operation_id uuid,
  p_matched boolean,
  p_technical_password_key_version text
)
returns table (
  outcome text,
  attempt_number smallint,
  handoff_ready boolean
)
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_intent public.first_admin_onboarding_intents%rowtype;
  v_attempt public.verification_challenge_attempts%rowtype;
  v_transition record;
  v_grant public.auth_session_grants%rowtype;
begin
  if p_intent_id is null
    or p_expected_challenge_id is null
    or p_email is null
    or btrim(p_email) = ''
    or p_verification_operation_id is null
    or p_matched is null
    or p_technical_password_key_version is null
    or btrim(p_technical_password_key_version) = '' then
    raise exception using errcode = '22023', message = 'First-admin verification request denied.';
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(
      'task017-intent:' || p_intent_id::text,
      0
    )
  );

  select * into strict v_intent
  from public.first_admin_onboarding_intents as intent
  where intent.id = p_intent_id
  for update;

  if v_intent.target_email <> p_email
    or v_intent.current_challenge_id <> p_expected_challenge_id then
    raise exception using errcode = 'P0001', message = 'First-admin verification request denied.';
  end if;

  if v_intent.handoff_session_grant_id is not null then
    if not p_matched then
      raise exception using errcode = 'P0001', message = 'First-admin verification request denied.';
    end if;

    select * into v_attempt
    from public.verification_challenge_attempts as attempt
    where attempt.operation_id = p_verification_operation_id;

    if not found
      or v_attempt.challenge_id <> v_intent.current_challenge_id
      or not v_attempt.matched then
      raise exception using errcode = 'P0001', message = 'First-admin verification request denied.';
    end if;

    select * into strict v_grant
    from public.auth_session_grants as session_grant
    where session_grant.id = v_intent.handoff_session_grant_id
      and session_grant.challenge_id = v_intent.current_challenge_id
      and session_grant.grant_operation_id = p_verification_operation_id;

    return query select 'CONSUMED'::text, v_attempt.attempt_number, true;
    return;
  end if;

  if not exists (
    select 1
    from public.verification_challenges as challenge
    where challenge.id = v_intent.current_challenge_id
      and challenge.email = v_intent.target_email
  ) then
    raise exception using errcode = 'P0001', message = 'First-admin verification request denied.';
  end if;

  select * into strict v_transition
  from private.task_017_verify_verification_challenge(
    v_intent.current_challenge_id,
    v_intent.target_email,
    p_verification_operation_id,
    p_matched,
    p_technical_password_key_version
  );

  if v_transition.outcome = 'CONSUMED' then
    if v_transition.session_grant_id is null then
      raise exception using errcode = 'P0001', message = 'First-admin verification request denied.';
    end if;

    select * into strict v_grant
    from public.auth_session_grants as session_grant
    where session_grant.id = v_transition.session_grant_id
      and session_grant.challenge_id = v_intent.current_challenge_id
      and session_grant.grant_operation_id = p_verification_operation_id;

    update public.first_admin_onboarding_intents as intent
    set
      handoff_session_grant_id = v_grant.id,
      handoff_ready_at = v_grant.created_at
    where intent.id = v_intent.id
      and intent.current_challenge_id = v_grant.challenge_id
      and intent.handoff_session_grant_id is null
      and intent.handoff_ready_at is null;

    if not found then
      raise exception using errcode = 'P0001', message = 'First-admin verification request denied.';
    end if;

    return query select 'CONSUMED'::text, v_transition.attempt_number, true;
    return;
  end if;

  if v_transition.session_grant_id is not null
    or v_transition.auth_bridge_credential_id is not null then
    raise exception using errcode = 'P0001', message = 'First-admin verification request denied.';
  end if;

  return query select v_transition.outcome, v_transition.attempt_number, false;
exception
  when no_data_found or too_many_rows then
    raise exception using errcode = 'P0001', message = 'First-admin verification request denied.';
end;
$$;

alter function public.verify_first_admin_onboarding_challenge(uuid, uuid, text, uuid, boolean, text)
owner to postgres;

revoke all on function public.verify_first_admin_onboarding_challenge(uuid, uuid, text, uuid, boolean, text)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.verify_first_admin_onboarding_challenge(uuid, uuid, text, uuid, boolean, text)
to service_role;

comment on function public.establish_first_admin_onboarding_intent(uuid, uuid, text, uuid, uuid, bytea, text, uuid) is
  'TASK-017 current-SUPER_ADMIN boundary: establishes one immutable intent and its first TASK-013 challenge atomically.';

comment on function public.resend_first_admin_onboarding_challenge(uuid, uuid, bytea, text, uuid) is
  'TASK-017 current-SUPER_ADMIN boundary: replaces the authoritative current challenge and rotates the intent pointer atomically.';

comment on function public.get_first_admin_onboarding_delivery_target(uuid, uuid) is
  'TASK-017 server-only exact delivery target resolver for one committed current emission; it does not select a provider or mutate lifecycle.';

comment on function public.get_first_admin_onboarding_challenge_material(uuid, text, uuid) is
  'TASK-017 server-only exact material resolver for an active current challenge or same-operation terminal reconciliation.';

comment on function public.verify_first_admin_onboarding_challenge(uuid, uuid, text, uuid, boolean, text) is
  'TASK-017 server-only transition: validates current intent binding and atomically records TASK-013 consume, SessionGrant, and durable handoff.';
