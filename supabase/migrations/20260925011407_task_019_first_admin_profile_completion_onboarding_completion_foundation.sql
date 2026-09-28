alter table public.platform_users
add column first_name text,
add column last_name text,
add column profile_completed_at timestamptz,
add constraint platform_users_profile_completion_state_check
  check (
    (
      first_name is null
      and last_name is null
      and profile_completed_at is null
    )
    or
    (
      first_name is not null
      and last_name is not null
      and profile_completed_at is not null
      and first_name = pg_catalog.btrim(first_name)
      and last_name = pg_catalog.btrim(last_name)
      and pg_catalog.btrim(first_name) <> ''
      and pg_catalog.btrim(last_name) <> ''
    )
  );

comment on column public.platform_users.first_name is
  'TASK-019 completed profile first name; null only while the coupled profile state is incomplete.';

comment on column public.platform_users.last_name is
  'TASK-019 completed profile last name; null only while the coupled profile state is incomplete.';

comment on column public.platform_users.profile_completed_at is
  'TASK-019 database-trusted timestamp for the coupled completed profile state.';

alter table public.first_admin_onboarding_intents
add column completion_operation_id uuid,
add column completed_platform_user_id uuid,
add column completed_company_membership_id uuid,
add column completed_at timestamptz,
add constraint first_admin_onboarding_intents_completed_platform_user_id_fkey
  foreign key (completed_platform_user_id)
  references public.platform_users (id)
  on delete restrict,
add constraint first_admin_onboarding_intents_completed_company_membership_id_fkey
  foreign key (completed_company_membership_id)
  references public.company_memberships (id)
  on delete restrict,
add constraint first_admin_onboarding_intents_completion_operation_id_key
  unique (completion_operation_id),
add constraint first_admin_onboarding_intents_completion_state_check
  check (
    (
      completion_operation_id is null
      and completed_platform_user_id is null
      and completed_company_membership_id is null
      and completed_at is null
    )
    or
    (
      completion_operation_id is not null
      and completed_platform_user_id is not null
      and completed_company_membership_id is not null
      and completed_at is not null
    )
  );

comment on column public.first_admin_onboarding_intents.completion_operation_id is
  'TASK-019 terminal idempotency key; handoff_ready does not mean onboarding completed.';

comment on column public.first_admin_onboarding_intents.completed_platform_user_id is
  'TASK-019 terminal evidence: the authoritative completed PlatformUser.';

comment on column public.first_admin_onboarding_intents.completed_company_membership_id is
  'TASK-019 terminal evidence: the authoritative initial enabled COMPANY_ADMIN membership.';

comment on column public.first_admin_onboarding_intents.completed_at is
  'TASK-019 terminal evidence timestamp. Onboarding completion requires operation, PlatformUser, membership, and timestamp together.';

create function private.resolve_current_first_admin_onboarding_state()
returns table (
  state text,
  completed_at timestamptz
)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_auth_subject_id uuid;
  v_candidate_count bigint;
  v_mapping_count bigint;
  v_intent public.first_admin_onboarding_intents%rowtype;
begin
  v_auth_subject_id := auth.uid();

  if v_auth_subject_id is null then
    return query select 'UNAVAILABLE'::text, null::timestamptz;
    return;
  end if;

  select pg_catalog.count(*)
  into v_candidate_count
  from public.first_admin_onboarding_intents as intent
  join public.auth_session_grants as session_grant
    on session_grant.id = intent.handoff_session_grant_id
  join public.auth_bridge_credentials as bridge
    on bridge.id = session_grant.auth_bridge_credential_id
  where intent.handoff_session_grant_id is not null
    and intent.handoff_ready_at is not null
    and session_grant.challenge_id = intent.current_challenge_id
    and intent.handoff_ready_at = session_grant.created_at
    and intent.target_email = bridge.email
    and session_grant.auth_user_id = v_auth_subject_id
    and bridge.auth_user_id = v_auth_subject_id
    and session_grant.purpose = 'initial_session'
    and session_grant.auth_method = 'password'
    and session_grant.consumed_at is not null
    and session_grant.revoked_at is null;

  if v_candidate_count <> 1 then
    return query select 'UNAVAILABLE'::text, null::timestamptz;
    return;
  end if;

  select intent.*
  into strict v_intent
  from public.first_admin_onboarding_intents as intent
  join public.auth_session_grants as session_grant
    on session_grant.id = intent.handoff_session_grant_id
  join public.auth_bridge_credentials as bridge
    on bridge.id = session_grant.auth_bridge_credential_id
  where intent.handoff_session_grant_id is not null
    and intent.handoff_ready_at is not null
    and session_grant.challenge_id = intent.current_challenge_id
    and intent.handoff_ready_at = session_grant.created_at
    and intent.target_email = bridge.email
    and session_grant.auth_user_id = v_auth_subject_id
    and bridge.auth_user_id = v_auth_subject_id
    and session_grant.purpose = 'initial_session'
    and session_grant.auth_method = 'password'
    and session_grant.consumed_at is not null
    and session_grant.revoked_at is null;

  if v_intent.completion_operation_id is not null then
    if exists (
      select 1
      from public.platform_user_auth_subjects as auth_subject
      join public.platform_users as platform_user
        on platform_user.id = auth_subject.platform_user_id
      join public.company_memberships as membership
        on membership.id = v_intent.completed_company_membership_id
      where auth_subject.auth_subject_id = v_auth_subject_id
        and auth_subject.platform_user_id = v_intent.completed_platform_user_id
        and not platform_user.is_super_admin
        and platform_user.first_name is not null
        and platform_user.last_name is not null
        and platform_user.profile_completed_at = v_intent.completed_at
        and platform_user.first_name = pg_catalog.btrim(platform_user.first_name)
        and platform_user.last_name = pg_catalog.btrim(platform_user.last_name)
        and pg_catalog.btrim(platform_user.first_name) <> ''
        and pg_catalog.btrim(platform_user.last_name) <> ''
        and membership.platform_user_id = platform_user.id
        and membership.maintenance_company_id = v_intent.maintenance_company_id
        and membership.role = 'COMPANY_ADMIN'
        and membership.is_enabled
        and (
          select pg_catalog.count(*)
          from public.audit_events as audit_event
          where audit_event.maintenance_company_id = v_intent.maintenance_company_id
            and audit_event.actor_kind = 'PLATFORM_USER'
            and audit_event.actor_platform_user_id = v_intent.initiated_by_platform_user_id
            and audit_event.actor_internal_process_key is null
            and audit_event.action = 'USER_CREATED'
            and audit_event.scope_kind = 'USER'
            and audit_event.subject_platform_user_id = platform_user.id
            and audit_event.role_before is null
            and audit_event.role_after is null
        ) = 1
    ) then
      return query select 'COMPLETED'::text, v_intent.completed_at;
      return;
    end if;

    return query select 'UNAVAILABLE'::text, null::timestamptz;
    return;
  end if;

  select pg_catalog.count(*)
  into v_mapping_count
  from public.platform_user_auth_subjects as auth_subject
  where auth_subject.auth_subject_id = v_auth_subject_id;

  if v_mapping_count = 0 then
    return query select 'PENDING_PROFILE'::text, null::timestamptz;
    return;
  end if;

  if v_mapping_count = 1 and exists (
    select 1
    from public.platform_user_auth_subjects as auth_subject
    join public.platform_users as platform_user
      on platform_user.id = auth_subject.platform_user_id
    where auth_subject.auth_subject_id = v_auth_subject_id
      and not platform_user.is_super_admin
      and platform_user.first_name is null
      and platform_user.last_name is null
      and platform_user.profile_completed_at is null
      and not exists (
        select 1
        from public.company_memberships as membership
        where membership.platform_user_id = platform_user.id
      )
  ) then
    return query select 'PENDING_PROFILE'::text, null::timestamptz;
    return;
  end if;

  return query select 'UNAVAILABLE'::text, null::timestamptz;
exception
  when no_data_found or too_many_rows then
    return query select 'UNAVAILABLE'::text, null::timestamptz;
end;
$$;

alter function private.resolve_current_first_admin_onboarding_state()
owner to postgres;

revoke all on function private.resolve_current_first_admin_onboarding_state()
from public, anon, authenticated, service_role, supabase_auth_admin;

grant usage on schema private to authenticated;

grant execute on function private.resolve_current_first_admin_onboarding_state()
to authenticated;

create function public.resolve_current_first_admin_onboarding_state()
returns table (
  state text,
  completed_at timestamptz
)
language sql
stable
security invoker
set search_path = ''
as $$
  select resolver.state, resolver.completed_at
  from private.resolve_current_first_admin_onboarding_state() as resolver;
$$;

alter function public.resolve_current_first_admin_onboarding_state()
owner to postgres;

revoke all on function public.resolve_current_first_admin_onboarding_state()
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.resolve_current_first_admin_onboarding_state()
to authenticated;

create function private.complete_first_admin_onboarding(
  p_first_name text,
  p_last_name text,
  p_operation_id uuid
)
returns table (
  outcome text,
  reason text,
  platform_user_id uuid,
  company_membership_id uuid,
  completed_at timestamptz
)
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_preliminary_auth_subject_id uuid;
  v_auth_subject_id uuid;
  v_candidate_count bigint;
  v_result_count bigint;
  v_intent_id uuid;
  v_maintenance_company_id uuid;
  v_initiated_by_platform_user_id uuid;
  v_intent public.first_admin_onboarding_intents%rowtype;
  v_platform_user_id uuid;
  v_company_membership_id uuid;
  v_is_super_admin boolean;
  v_normalized_first_name text;
  v_normalized_last_name text;
  v_existing_first_name text;
  v_existing_last_name text;
  v_profile_completed_at timestamptz;
  v_now timestamptz;
begin
  v_preliminary_auth_subject_id := auth.uid();

  if v_preliminary_auth_subject_id is null then
    return query select
      'DENIED'::text,
      'AUTHORIZATION_DENIED'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
    return;
  end if;

  if p_operation_id is null
    or p_first_name is null
    or p_last_name is null
    or pg_catalog.btrim(p_first_name) = ''
    or pg_catalog.btrim(p_last_name) = '' then
    return query select
      'DENIED'::text,
      'INVALID_INPUT'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
    return;
  end if;

  v_normalized_first_name := pg_catalog.btrim(p_first_name);
  v_normalized_last_name := pg_catalog.btrim(p_last_name);

  select pg_catalog.count(*)
  into v_candidate_count
  from public.first_admin_onboarding_intents as intent
  join public.auth_session_grants as session_grant
    on session_grant.id = intent.handoff_session_grant_id
  join public.auth_bridge_credentials as bridge
    on bridge.id = session_grant.auth_bridge_credential_id
  where intent.handoff_session_grant_id is not null
    and intent.handoff_ready_at is not null
    and session_grant.challenge_id = intent.current_challenge_id
    and intent.handoff_ready_at = session_grant.created_at
    and intent.target_email = bridge.email
    and session_grant.auth_user_id = v_preliminary_auth_subject_id
    and bridge.auth_user_id = v_preliminary_auth_subject_id
    and session_grant.purpose = 'initial_session'
    and session_grant.auth_method = 'password'
    and session_grant.consumed_at is not null
    and session_grant.revoked_at is null;

  if v_candidate_count <> 1 then
    return query select
      'DENIED'::text,
      'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
    return;
  end if;

  select
    intent.id,
    intent.maintenance_company_id,
    intent.initiated_by_platform_user_id
  into strict
    v_intent_id,
    v_maintenance_company_id,
    v_initiated_by_platform_user_id
  from public.first_admin_onboarding_intents as intent
  join public.auth_session_grants as session_grant
    on session_grant.id = intent.handoff_session_grant_id
  join public.auth_bridge_credentials as bridge
    on bridge.id = session_grant.auth_bridge_credential_id
  where intent.handoff_session_grant_id is not null
    and intent.handoff_ready_at is not null
    and session_grant.challenge_id = intent.current_challenge_id
    and intent.handoff_ready_at = session_grant.created_at
    and intent.target_email = bridge.email
    and session_grant.auth_user_id = v_preliminary_auth_subject_id
    and bridge.auth_user_id = v_preliminary_auth_subject_id
    and session_grant.purpose = 'initial_session'
    and session_grant.auth_method = 'password'
    and session_grant.consumed_at is not null
    and session_grant.revoked_at is null;

  perform actor.id
  from public.platform_users as actor
  where actor.id = v_initiated_by_platform_user_id
  for key share;

  if not found then
    return query select
      'DENIED'::text,
      'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
    return;
  end if;

  perform company.id
  from public.maintenance_companies as company
  where company.id = v_maintenance_company_id
  for update;

  if not found then
    return query select
      'DENIED'::text,
      'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
    return;
  end if;

  select intent.*
  into strict v_intent
  from public.first_admin_onboarding_intents as intent
  where intent.id = v_intent_id
    and intent.maintenance_company_id = v_maintenance_company_id
  for update;

  if v_intent.id <> v_intent_id
    or v_intent.maintenance_company_id <> v_maintenance_company_id
    or v_intent.initiated_by_platform_user_id <> v_initiated_by_platform_user_id then
    return query select
      'DENIED'::text,
      'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
    return;
  end if;

  v_auth_subject_id := auth.uid();

  if v_auth_subject_id is null
    or v_auth_subject_id <> v_preliminary_auth_subject_id then
    return query select
      'DENIED'::text,
      'AUTHORIZATION_DENIED'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
    return;
  end if;

  select pg_catalog.count(*)
  into v_candidate_count
  from public.first_admin_onboarding_intents as intent
  join public.auth_session_grants as session_grant
    on session_grant.id = intent.handoff_session_grant_id
  join public.auth_bridge_credentials as bridge
    on bridge.id = session_grant.auth_bridge_credential_id
  where intent.handoff_session_grant_id is not null
    and intent.handoff_ready_at is not null
    and session_grant.challenge_id = intent.current_challenge_id
    and intent.handoff_ready_at = session_grant.created_at
    and intent.target_email = bridge.email
    and session_grant.auth_user_id = v_auth_subject_id
    and bridge.auth_user_id = v_auth_subject_id
    and session_grant.purpose = 'initial_session'
    and session_grant.auth_method = 'password'
    and session_grant.consumed_at is not null
    and session_grant.revoked_at is null;

  if v_candidate_count <> 1 or not exists (
    select 1
    from public.first_admin_onboarding_intents as intent
    join public.auth_session_grants as session_grant
      on session_grant.id = intent.handoff_session_grant_id
    join public.auth_bridge_credentials as bridge
      on bridge.id = session_grant.auth_bridge_credential_id
    where intent.id = v_intent_id
      and intent.maintenance_company_id = v_maintenance_company_id
      and intent.initiated_by_platform_user_id = v_initiated_by_platform_user_id
      and intent.handoff_session_grant_id is not null
      and intent.handoff_ready_at is not null
      and session_grant.challenge_id = intent.current_challenge_id
      and intent.handoff_ready_at = session_grant.created_at
      and intent.target_email = bridge.email
      and session_grant.auth_user_id = v_auth_subject_id
      and bridge.auth_user_id = v_auth_subject_id
      and session_grant.purpose = 'initial_session'
      and session_grant.auth_method = 'password'
      and session_grant.consumed_at is not null
      and session_grant.revoked_at is null
  ) then
    return query select
      'DENIED'::text,
      'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
    return;
  end if;

  if not exists (
    select 1
    from public.platform_users as actor
    where actor.id = v_initiated_by_platform_user_id
      and v_intent.initiated_by_platform_user_id = v_initiated_by_platform_user_id
      and actor.is_super_admin
  ) then
    return query select
      'DENIED'::text,
      'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
    return;
  end if;

  if v_intent.completion_operation_id is not null then
    if v_intent.completion_operation_id <> p_operation_id then
      return query select
        'DENIED'::text,
        'ONBOARDING_ALREADY_COMPLETED'::text,
        null::uuid,
        null::uuid,
        null::timestamptz;
      return;
    end if;

    select pg_catalog.count(*)
    into v_result_count
    from public.platform_user_auth_subjects as auth_subject
    join public.platform_users as platform_user
      on platform_user.id = auth_subject.platform_user_id
    join public.company_memberships as membership
      on membership.id = v_intent.completed_company_membership_id
    where auth_subject.auth_subject_id = v_auth_subject_id
      and auth_subject.platform_user_id = v_intent.completed_platform_user_id
      and not platform_user.is_super_admin
      and platform_user.first_name is not null
      and platform_user.last_name is not null
      and platform_user.profile_completed_at = v_intent.completed_at
      and membership.platform_user_id = platform_user.id
      and membership.maintenance_company_id = v_intent.maintenance_company_id
      and membership.role = 'COMPANY_ADMIN'
      and membership.is_enabled
      and (
        select pg_catalog.count(*)
        from public.audit_events as audit_event
        where audit_event.maintenance_company_id = v_intent.maintenance_company_id
          and audit_event.actor_kind = 'PLATFORM_USER'
          and audit_event.actor_platform_user_id = v_intent.initiated_by_platform_user_id
          and audit_event.actor_internal_process_key is null
          and audit_event.action = 'USER_CREATED'
          and audit_event.scope_kind = 'USER'
          and audit_event.subject_platform_user_id = platform_user.id
          and audit_event.role_before is null
          and audit_event.role_after is null
      ) = 1;

    if v_result_count <> 1 then
      return query select
        'DENIED'::text,
        'SECURITY_CORRELATION_FAILURE'::text,
        null::uuid,
        null::uuid,
        null::timestamptz;
      return;
    end if;

    return query select
      'ALREADY_COMPLETED'::text,
      'ALREADY_COMPLETED'::text,
      v_intent.completed_platform_user_id,
      v_intent.completed_company_membership_id,
      v_intent.completed_at;
    return;
  end if;

  if exists (
    select 1
    from public.first_admin_onboarding_intents as other_intent
    where other_intent.completion_operation_id = p_operation_id
      and other_intent.id <> v_intent.id
  ) then
    return query select
      'DENIED'::text,
      'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
    return;
  end if;

  select
    platform_user.id,
    platform_user.is_super_admin,
    platform_user.first_name,
    platform_user.last_name,
    platform_user.profile_completed_at
  into
    v_platform_user_id,
    v_is_super_admin,
    v_existing_first_name,
    v_existing_last_name,
    v_profile_completed_at
  from public.platform_user_auth_subjects as auth_subject
  join public.platform_users as platform_user
    on platform_user.id = auth_subject.platform_user_id
  where auth_subject.auth_subject_id = v_auth_subject_id
  for update of auth_subject, platform_user;

  perform membership.id
  from public.company_memberships as membership
  where membership.maintenance_company_id = v_intent.maintenance_company_id
  for update;

  if found then
    return query select
      'DENIED'::text,
      'INITIAL_MEMBERSHIP_CONFLICT'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
    return;
  end if;

  v_now := pg_catalog.clock_timestamp();

  if v_platform_user_id is null then
    v_platform_user_id := pg_catalog.gen_random_uuid();

    insert into public.platform_users (
      id,
      is_super_admin,
      first_name,
      last_name,
      profile_completed_at
    ) values (
      v_platform_user_id,
      false,
      v_normalized_first_name,
      v_normalized_last_name,
      v_now
    );

    insert into public.platform_user_auth_subjects (
      auth_subject_id,
      platform_user_id
    ) values (
      v_auth_subject_id,
      v_platform_user_id
    );
  else
    if v_is_super_admin
      or v_existing_first_name is not null
      or v_existing_last_name is not null
      or v_profile_completed_at is not null then
      return query select
        'DENIED'::text,
        'IDENTITY_INCOMPATIBLE'::text,
        null::uuid,
        null::uuid,
        null::timestamptz;
      return;
    end if;

    perform membership.id
    from public.company_memberships as membership
    where membership.platform_user_id = v_platform_user_id
    for update;

    if found then
      return query select
        'DENIED'::text,
        'INITIAL_MEMBERSHIP_CONFLICT'::text,
        null::uuid,
        null::uuid,
        null::timestamptz;
      return;
    end if;

    update public.platform_users as platform_user
    set
      first_name = v_normalized_first_name,
      last_name = v_normalized_last_name,
      profile_completed_at = v_now
    where platform_user.id = v_platform_user_id;

    if not found then
      raise exception using
        errcode = 'P0001',
        message = 'TASK-019 profile completion target disappeared.';
    end if;
  end if;

  perform membership.id
  from public.company_memberships as membership
  where membership.platform_user_id = v_platform_user_id
  for update;

  if found then
    raise exception using
      errcode = 'P0001',
      message = 'TASK-019 initial membership state changed unexpectedly.';
  end if;

  v_company_membership_id := pg_catalog.gen_random_uuid();

  insert into public.company_memberships (
    id,
    platform_user_id,
    maintenance_company_id,
    role,
    is_enabled
  ) values (
    v_company_membership_id,
    v_platform_user_id,
    v_intent.maintenance_company_id,
    'COMPANY_ADMIN',
    true
  );

  insert into public.audit_events (
    id,
    maintenance_company_id,
    actor_kind,
    actor_platform_user_id,
    actor_internal_process_key,
    action,
    occurred_at,
    scope_kind,
    subject_platform_user_id,
    role_before,
    role_after
  ) values (
    pg_catalog.gen_random_uuid(),
    v_intent.maintenance_company_id,
    'PLATFORM_USER',
    v_intent.initiated_by_platform_user_id,
    null,
    'USER_CREATED',
    v_now,
    'USER',
    v_platform_user_id,
    null,
    null
  );

  update public.first_admin_onboarding_intents as intent
  set
    completion_operation_id = p_operation_id,
    completed_platform_user_id = v_platform_user_id,
    completed_company_membership_id = v_company_membership_id,
    completed_at = v_now
  where intent.id = v_intent.id
    and intent.completion_operation_id is null
    and intent.completed_platform_user_id is null
    and intent.completed_company_membership_id is null
    and intent.completed_at is null;

  if not found then
    raise exception using
      errcode = 'P0001',
      message = 'TASK-019 terminal completion state changed unexpectedly.';
  end if;

  return query select
    'COMPLETED'::text,
    'COMPLETED'::text,
    v_platform_user_id,
    v_company_membership_id,
    v_now;
exception
  when no_data_found or too_many_rows then
    return query select
      'DENIED'::text,
      'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid,
      null::uuid,
      null::timestamptz;
end;
$$;

alter function private.complete_first_admin_onboarding(text, text, uuid)
owner to postgres;

revoke all on function private.complete_first_admin_onboarding(text, text, uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function private.complete_first_admin_onboarding(text, text, uuid)
to authenticated;

create function public.complete_first_admin_onboarding(
  p_first_name text,
  p_last_name text,
  p_operation_id uuid
)
returns table (
  outcome text,
  reason text,
  platform_user_id uuid,
  company_membership_id uuid,
  completed_at timestamptz
)
language sql
volatile
security invoker
set search_path = ''
as $$
  select
    completion.outcome,
    completion.reason,
    completion.platform_user_id,
    completion.company_membership_id,
    completion.completed_at
  from private.complete_first_admin_onboarding(
    p_first_name,
    p_last_name,
    p_operation_id
  ) as completion;
$$;

alter function public.complete_first_admin_onboarding(text, text, uuid)
owner to postgres;

revoke all on function public.complete_first_admin_onboarding(text, text, uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.complete_first_admin_onboarding(text, text, uuid)
to authenticated;

comment on function private.resolve_current_first_admin_onboarding_state() is
  'TASK-019 narrow privileged current-session resolver; returns only PENDING_PROFILE, COMPLETED, or UNAVAILABLE plus the trusted completion timestamp.';

comment on function public.resolve_current_first_admin_onboarding_state() is
  'TASK-019 SECURITY INVOKER wrapper for the bounded current-session onboarding-state resolver.';

comment on function private.complete_first_admin_onboarding(text, text, uuid) is
  'TASK-019 purpose-specific privileged completion boundary deriving all authority from auth.uid() and durable handoff correlation.';

comment on function public.complete_first_admin_onboarding(text, text, uuid) is
  'TASK-019 SECURITY INVOKER wrapper accepting only first name, last name, and completion operation ID.';
