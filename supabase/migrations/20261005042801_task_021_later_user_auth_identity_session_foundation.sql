create table public.auth_subject_authority_anchors (
  auth_subject_id uuid primary key,
  created_at timestamptz not null default clock_timestamp()
);

create table public.later_user_initial_session_coordinations (
  id uuid primary key default gen_random_uuid(),
  later_user_enrollment_intent_id uuid not null,
  auth_bridge_credential_id uuid not null,
  auth_session_grant_id uuid not null,
  logical_operation_id uuid not null,
  expected_auth_subject_id uuid not null,
  reserved_auth_subject_id uuid,
  confirmed_auth_subject_id uuid,
  state text not null,
  expires_at timestamptz not null,
  terminal_result text,
  created_at timestamptz not null default clock_timestamp(),
  updated_at timestamptz not null default clock_timestamp(),
  constraint task_021_coordination_intent_fkey
    foreign key (later_user_enrollment_intent_id)
    references public.later_user_enrollment_intents (id)
    on delete restrict,
  constraint task_021_coordination_bridge_fkey
    foreign key (auth_bridge_credential_id)
    references public.auth_bridge_credentials (id)
    on delete restrict,
  constraint task_021_coordination_grant_fkey
    foreign key (auth_session_grant_id)
    references public.auth_session_grants (id)
    on delete restrict,
  constraint task_021_coordination_intent_key
    unique (later_user_enrollment_intent_id),
  constraint task_021_coordination_grant_key
    unique (auth_session_grant_id),
  constraint task_021_coordination_operation_key
    unique (logical_operation_id),
  constraint task_021_coordination_state_check
    check (state in (
      'PREPARING',
      'PROVISIONING_UNKNOWN',
      'SUBJECT_CONFIRMED',
      'ISSUANCE_ACTIVE',
      'GATE_CONSUMED',
      'SESSION_ESTABLISHED_NO_AUTHORITY',
      'EXPIRED',
      'ABANDONED',
      'REPAIR_REQUIRED'
    )),
  constraint task_021_coordination_reserved_subject_check
    check (
      reserved_auth_subject_id is null
      or reserved_auth_subject_id = expected_auth_subject_id
    ),
  constraint task_021_coordination_confirmed_subject_check
    check (
      confirmed_auth_subject_id is null
      or confirmed_auth_subject_id = expected_auth_subject_id
    ),
  constraint task_021_coordination_confirmed_state_check
    check (
      state not in (
        'SUBJECT_CONFIRMED',
        'ISSUANCE_ACTIVE',
        'GATE_CONSUMED',
        'SESSION_ESTABLISHED_NO_AUTHORITY'
      )
      or confirmed_auth_subject_id = expected_auth_subject_id
    ),
  constraint task_021_coordination_unknown_state_check
    check (
      state <> 'PROVISIONING_UNKNOWN'
      or (
        reserved_auth_subject_id = expected_auth_subject_id
        and confirmed_auth_subject_id is null
      )
    ),
  constraint task_021_coordination_terminal_result_check
    check (
      (state in (
        'SESSION_ESTABLISHED_NO_AUTHORITY',
        'EXPIRED',
        'ABANDONED',
        'REPAIR_REQUIRED'
      )) = (terminal_result is not null)
    ),
  constraint task_021_coordination_expiry_check
    check (expires_at > created_at),
  constraint task_021_coordination_updated_at_check
    check (updated_at >= created_at)
);

create index task_021_coordination_subject_idx
on public.later_user_initial_session_coordinations (expected_auth_subject_id);

create index task_021_coordination_bridge_idx
on public.later_user_initial_session_coordinations (auth_bridge_credential_id);

create index task_021_coordination_state_expiry_idx
on public.later_user_initial_session_coordinations (state, expires_at);

create unique index task_021_one_active_subject_fence_idx
on public.later_user_initial_session_coordinations (expected_auth_subject_id)
where state in ('ISSUANCE_ACTIVE', 'GATE_CONSUMED');

alter table public.auth_subject_authority_anchors enable row level security;
alter table public.later_user_initial_session_coordinations enable row level security;

revoke all privileges on table public.auth_subject_authority_anchors
from public, anon, authenticated, service_role, supabase_auth_admin;
revoke all privileges on table public.later_user_initial_session_coordinations
from public, anon, authenticated, service_role, supabase_auth_admin;

comment on table public.auth_subject_authority_anchors is
  'TASK-021 stable exact-subject serialization anchor. Presence does not assert that the provider Auth user exists or confer authority.';
comment on table public.later_user_initial_session_coordinations is
  'TASK-021 platform-owned initial-session coordination. It never represents tenant authority.';

create function private.task_021_coordination_bindings_immutable()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.id <> old.id
    or new.later_user_enrollment_intent_id <> old.later_user_enrollment_intent_id
    or new.auth_bridge_credential_id <> old.auth_bridge_credential_id
    or new.auth_session_grant_id <> old.auth_session_grant_id
    or new.logical_operation_id <> old.logical_operation_id
    or new.expected_auth_subject_id <> old.expected_auth_subject_id
    or new.reserved_auth_subject_id is distinct from old.reserved_auth_subject_id
    or new.created_at <> old.created_at
    or new.expires_at <> old.expires_at then
    raise exception using errcode = 'P0001', message = 'TASK-021 coordination binding is immutable.';
  end if;

  if old.state in (
    'SESSION_ESTABLISHED_NO_AUTHORITY',
    'EXPIRED',
    'ABANDONED',
    'REPAIR_REQUIRED'
  ) and new.state <> old.state then
    raise exception using errcode = 'P0001', message = 'TASK-021 terminal coordination cannot be reactivated.';
  end if;

  return new;
end;
$$;

create trigger task_021_coordination_bindings_immutable
before update on public.later_user_initial_session_coordinations
for each row execute function private.task_021_coordination_bindings_immutable();

create function private.task_021_subject_is_compatible(p_auth_subject_id uuid)
returns boolean
language plpgsql
stable
security invoker
set search_path = ''
as $$
declare
  v_mapping_count integer;
  v_is_super_admin boolean;
  v_membership_count integer;
begin
  select
    count(*),
    coalesce(bool_or(platform_user.is_super_admin), false),
    count(membership.id)
  into
    v_mapping_count,
    v_is_super_admin,
    v_membership_count
  from public.platform_user_auth_subjects as auth_subject
  join public.platform_users as platform_user
    on platform_user.id = auth_subject.platform_user_id
  left join public.company_memberships as membership
    on membership.platform_user_id = platform_user.id
  where auth_subject.auth_subject_id = p_auth_subject_id;

  return v_mapping_count = 0
    or (
      v_mapping_count = 1
      and not v_is_super_admin
      and v_membership_count = 0
    );
end;
$$;

create function public.task_021_reconcile_initial_session(
  p_later_user_enrollment_intent_id uuid
)
returns table (
  coordination_id uuid,
  auth_bridge_credential_id uuid,
  logical_operation_id uuid,
  expected_auth_subject_id uuid,
  reserved_auth_subject_id uuid,
  target_email text,
  technical_password_key_version text,
  state text,
  expires_at timestamptz
)
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_company_id uuid;
  v_intent public.later_user_enrollment_intents%rowtype;
  v_grant public.auth_session_grants%rowtype;
  v_bridge public.auth_bridge_credentials%rowtype;
  v_coord public.later_user_initial_session_coordinations%rowtype;
  v_expected_subject uuid;
  v_reserved_subject uuid;
  v_now timestamptz := clock_timestamp();
begin
  select intent.maintenance_company_id into strict v_company_id
  from public.later_user_enrollment_intents as intent
  where intent.id = p_later_user_enrollment_intent_id;

  perform 1 from public.maintenance_companies
  where id = v_company_id
  for update;

  select * into strict v_intent
  from public.later_user_enrollment_intents
  where id = p_later_user_enrollment_intent_id
  for update;

  if v_intent.handoff_session_grant_id is null
    or v_intent.handoff_ready_at is null then
    raise exception using errcode = 'P0001', message = 'TASK-021 handoff is not eligible.';
  end if;

  select * into strict v_grant
  from public.auth_session_grants
  where id = v_intent.handoff_session_grant_id;

  select * into strict v_bridge
  from public.auth_bridge_credentials
  where id = v_grant.auth_bridge_credential_id;

  select * into v_coord
  from public.later_user_initial_session_coordinations
  where later_user_enrollment_intent_id = v_intent.id;

  if found then
    if v_coord.auth_bridge_credential_id <> v_bridge.id
      or v_coord.auth_session_grant_id <> v_grant.id
      or v_coord.logical_operation_id <> v_grant.grant_operation_id
      or (v_bridge.auth_user_id is not null
        and v_coord.expected_auth_subject_id <> v_bridge.auth_user_id) then
      raise exception using errcode = 'P0001', message = 'TASK-021 coordination correlation failed.';
    end if;

    if v_now >= v_coord.expires_at
      and v_coord.state in ('PREPARING', 'PROVISIONING_UNKNOWN', 'SUBJECT_CONFIRMED') then
      update public.later_user_initial_session_coordinations
      set state = 'EXPIRED', terminal_result = 'SESSION_GRANT_EXPIRED', updated_at = v_now
      where id = v_coord.id
      returning * into v_coord;
    end if;

    return query select
      v_coord.id,
      v_coord.auth_bridge_credential_id,
      v_coord.logical_operation_id,
      v_coord.expected_auth_subject_id,
      v_coord.reserved_auth_subject_id,
      v_bridge.email,
      v_bridge.technical_password_key_version,
      v_coord.state,
      v_coord.expires_at;
    return;
  end if;

  if v_grant.purpose <> 'initial_session'
    or v_grant.auth_method <> 'password'
    or v_grant.consumed_at is not null
    or v_grant.revoked_at is not null
    or v_now >= v_grant.expires_at
    or v_grant.challenge_id <> v_intent.current_challenge_id then
    raise exception using errcode = 'P0001', message = 'TASK-021 SessionGrant is not eligible.';
  end if;

  if v_bridge.auth_user_id is null then
    v_reserved_subject := gen_random_uuid();
    v_expected_subject := v_reserved_subject;
  else
    v_expected_subject := v_bridge.auth_user_id;
    v_reserved_subject := null;
  end if;

  insert into public.auth_subject_authority_anchors (auth_subject_id)
  values (v_expected_subject)
  on conflict (auth_subject_id) do nothing;

  perform 1 from public.auth_subject_authority_anchors
  where auth_subject_id = v_expected_subject
  for update;

  perform 1 from public.auth_bridge_credentials
  where id = v_bridge.id
  for update;

  perform 1 from public.auth_session_grants
  where id = v_grant.id
  for update;

  insert into public.later_user_initial_session_coordinations (
    later_user_enrollment_intent_id,
    auth_bridge_credential_id,
    auth_session_grant_id,
    logical_operation_id,
    expected_auth_subject_id,
    reserved_auth_subject_id,
    state,
    expires_at
  ) values (
    v_intent.id,
    v_bridge.id,
    v_grant.id,
    v_grant.grant_operation_id,
    v_expected_subject,
    v_reserved_subject,
    'PREPARING',
    v_grant.expires_at
  ) returning * into v_coord;

  return query select
    v_coord.id,
    v_coord.auth_bridge_credential_id,
    v_coord.logical_operation_id,
    v_coord.expected_auth_subject_id,
    v_coord.reserved_auth_subject_id,
    v_bridge.email,
    v_bridge.technical_password_key_version,
    v_coord.state,
    v_coord.expires_at;
exception
  when no_data_found or too_many_rows then
    raise exception using errcode = 'P0001', message = 'TASK-021 handoff is not eligible.';
end;
$$;

create function public.task_021_mark_provisioning_unknown(
  p_coordination_id uuid,
  p_expected_auth_subject_id uuid
)
returns boolean
language plpgsql
volatile
security definer
set search_path = ''
as $$
begin
  update public.later_user_initial_session_coordinations
  set state = 'PROVISIONING_UNKNOWN', updated_at = clock_timestamp()
  where id = p_coordination_id
    and expected_auth_subject_id = p_expected_auth_subject_id
    and reserved_auth_subject_id = p_expected_auth_subject_id
    and confirmed_auth_subject_id is null
    and state in ('PREPARING', 'PROVISIONING_UNKNOWN');
  return found;
end;
$$;

create function public.task_021_confirm_auth_subject(
  p_coordination_id uuid,
  p_expected_auth_subject_id uuid
)
returns boolean
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_coord public.later_user_initial_session_coordinations%rowtype;
  v_bridge public.auth_bridge_credentials%rowtype;
  v_now timestamptz := clock_timestamp();
begin
  perform 1 from public.auth_subject_authority_anchors
  where auth_subject_id = p_expected_auth_subject_id
  for update;

  select coordination.* into strict v_coord
  from public.later_user_initial_session_coordinations as coordination
  where coordination.id = p_coordination_id
    and coordination.expected_auth_subject_id = p_expected_auth_subject_id;

  select * into strict v_bridge
  from public.auth_bridge_credentials
  where id = v_coord.auth_bridge_credential_id
  for update;

  perform 1 from public.later_user_initial_session_coordinations
  where id = v_coord.id
  for update;

  perform 1 from public.auth_session_grants
  where id = v_coord.auth_session_grant_id
    and consumed_at is null
    and revoked_at is null
    and v_now < expires_at
  for update;

  if v_bridge.auth_user_id is not null
    and v_bridge.auth_user_id <> p_expected_auth_subject_id then
    raise exception using errcode = 'P0001', message = 'TASK-021 subject binding failed.';
  end if;

  update public.auth_bridge_credentials
  set auth_user_id = p_expected_auth_subject_id,
      bound_at = coalesce(bound_at, v_now)
  where id = v_bridge.id
    and (auth_user_id is null or auth_user_id = p_expected_auth_subject_id);

  if not found then
    raise exception using errcode = 'P0001', message = 'TASK-021 subject binding failed.';
  end if;

  update public.auth_session_grants
  set auth_user_id = p_expected_auth_subject_id
  where id = v_coord.auth_session_grant_id
    and (auth_user_id is null or auth_user_id = p_expected_auth_subject_id)
    and consumed_at is null
    and revoked_at is null
    and v_now < expires_at;

  if not found then
    raise exception using errcode = 'P0001', message = 'TASK-021 grant binding failed.';
  end if;

  update public.later_user_initial_session_coordinations
  set confirmed_auth_subject_id = p_expected_auth_subject_id,
      state = 'SUBJECT_CONFIRMED',
      updated_at = v_now
  where id = v_coord.id
    and state in ('PREPARING', 'PROVISIONING_UNKNOWN', 'SUBJECT_CONFIRMED');

  return found;
exception
  when no_data_found or too_many_rows then
    return false;
end;
$$;

create function public.task_021_mark_repair_required(
  p_coordination_id uuid,
  p_expected_auth_subject_id uuid,
  p_reason text
)
returns boolean
language plpgsql
volatile
security definer
set search_path = ''
as $$
begin
  if p_reason not in (
    'PROVIDER_IDENTITY_CONFLICT',
    'IDENTITY_INCOMPATIBLE',
    'SECURITY_CORRELATION_FAILURE'
  ) then
    return false;
  end if;

  update public.later_user_initial_session_coordinations
  set state = 'REPAIR_REQUIRED', terminal_result = p_reason, updated_at = clock_timestamp()
  where id = p_coordination_id
    and expected_auth_subject_id = p_expected_auth_subject_id
    and state in ('PREPARING', 'PROVISIONING_UNKNOWN', 'SUBJECT_CONFIRMED');
  return found;
end;
$$;

create function public.task_021_activate_issuance(
  p_later_user_enrollment_intent_id uuid,
  p_coordination_id uuid,
  p_expected_auth_subject_id uuid
)
returns text
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_company_id uuid;
  v_intent public.later_user_enrollment_intents%rowtype;
  v_coord public.later_user_initial_session_coordinations%rowtype;
  v_now timestamptz := clock_timestamp();
begin
  select maintenance_company_id into strict v_company_id
  from public.later_user_enrollment_intents
  where id = p_later_user_enrollment_intent_id;

  perform 1 from public.maintenance_companies
  where id = v_company_id
  for update;

  select * into strict v_intent
  from public.later_user_enrollment_intents
  where id = p_later_user_enrollment_intent_id
  for update;

  perform 1 from public.auth_subject_authority_anchors
  where auth_subject_id = p_expected_auth_subject_id
  for update;

  if not private.task_021_subject_is_compatible(p_expected_auth_subject_id) then
    update public.later_user_initial_session_coordinations
    set state = 'REPAIR_REQUIRED',
        terminal_result = 'IDENTITY_INCOMPATIBLE',
        updated_at = v_now
    where id = p_coordination_id
      and expected_auth_subject_id = p_expected_auth_subject_id
      and state in ('SUBJECT_CONFIRMED', 'ISSUANCE_ACTIVE');
    return 'IDENTITY_INCOMPATIBLE';
  end if;

  perform 1 from public.auth_bridge_credentials as bridge
  where bridge.auth_user_id = p_expected_auth_subject_id
  for update;

  select * into strict v_coord
  from public.later_user_initial_session_coordinations
  where id = p_coordination_id
    and later_user_enrollment_intent_id = v_intent.id
    and expected_auth_subject_id = p_expected_auth_subject_id
    and confirmed_auth_subject_id = p_expected_auth_subject_id
  for update;

  perform 1 from public.auth_session_grants
  where id = v_coord.auth_session_grant_id
    and id = v_intent.handoff_session_grant_id
    and auth_user_id = p_expected_auth_subject_id
    and purpose = 'initial_session'
    and auth_method = 'password'
    and consumed_at is null
    and revoked_at is null
    and v_now < expires_at
  for update;

  if v_now >= v_coord.expires_at then
    update public.later_user_initial_session_coordinations
    set state = 'EXPIRED', terminal_result = 'SESSION_GRANT_EXPIRED', updated_at = v_now
    where id = v_coord.id
      and state = 'SUBJECT_CONFIRMED';
    return 'SESSION_RECOVERY_REQUIRED';
  end if;

  update public.later_user_initial_session_coordinations
  set state = 'ISSUANCE_ACTIVE', updated_at = v_now
  where id = v_coord.id
    and state in ('SUBJECT_CONFIRMED', 'ISSUANCE_ACTIVE');

  if not found then
    return 'SECURITY_CORRELATION_FAILURE';
  end if;
  return 'ISSUANCE_ACTIVE';
exception
  when no_data_found or too_many_rows or unique_violation then
    return 'SECURITY_CORRELATION_FAILURE';
end;
$$;

create function public.task_021_finalize_initial_session(
  p_coordination_id uuid,
  p_expected_auth_subject_id uuid
)
returns text
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_company_id uuid;
  v_intent_id uuid;
  v_coord public.later_user_initial_session_coordinations%rowtype;
  v_now timestamptz := clock_timestamp();
begin
  select
    coordination.later_user_enrollment_intent_id,
    intent.maintenance_company_id
  into strict v_intent_id, v_company_id
  from public.later_user_initial_session_coordinations as coordination
  join public.later_user_enrollment_intents as intent
    on intent.id = coordination.later_user_enrollment_intent_id
  where coordination.id = p_coordination_id
    and coordination.expected_auth_subject_id = p_expected_auth_subject_id;

  perform 1 from public.maintenance_companies
  where id = v_company_id
  for update;

  perform 1 from public.later_user_enrollment_intents
  where id = v_intent_id
  for update;

  perform 1 from public.auth_subject_authority_anchors
  where auth_subject_id = p_expected_auth_subject_id
  for update;

  if not private.task_021_subject_is_compatible(p_expected_auth_subject_id) then
    return 'IDENTITY_INCOMPATIBLE';
  end if;

  perform 1 from public.auth_bridge_credentials
  where auth_user_id = p_expected_auth_subject_id
  for update;

  select * into strict v_coord
  from public.later_user_initial_session_coordinations
  where id = p_coordination_id
    and expected_auth_subject_id = p_expected_auth_subject_id
    and confirmed_auth_subject_id = p_expected_auth_subject_id
  for update;

  perform 1 from public.auth_session_grants
  where id = v_coord.auth_session_grant_id
    and auth_user_id = p_expected_auth_subject_id
    and consumed_at is not null
    and revoked_at is null
  for update;

  if v_coord.state = 'SESSION_ESTABLISHED_NO_AUTHORITY'
    and v_coord.terminal_result = 'AUTHENTICATED_BUT_NOT_TENANT_AUTHORIZED' then
    return 'SESSION_ALREADY_ESTABLISHED';
  end if;

  if v_coord.state <> 'GATE_CONSUMED' then
    return 'SECURITY_CORRELATION_FAILURE';
  end if;

  update public.later_user_initial_session_coordinations
  set state = 'SESSION_ESTABLISHED_NO_AUTHORITY',
      terminal_result = 'AUTHENTICATED_BUT_NOT_TENANT_AUTHORIZED',
      updated_at = v_now
  where id = v_coord.id
    and state = 'GATE_CONSUMED';

  if not found then
    return 'SECURITY_CORRELATION_FAILURE';
  end if;
  return 'SESSION_ESTABLISHED';
exception
  when no_data_found or too_many_rows then
    return 'SECURITY_CORRELATION_FAILURE';
end;
$$;

create function public.resolve_current_later_user_pre_client_state()
returns table (state text)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_subject uuid := auth.uid();
  v_count integer;
begin
  if v_subject is null then
    return query select 'UNAVAILABLE'::text;
    return;
  end if;

  select count(*) into v_count
  from public.later_user_initial_session_coordinations as coordination
  join public.auth_bridge_credentials as bridge
    on bridge.id = coordination.auth_bridge_credential_id
  join public.auth_session_grants as session_grant
    on session_grant.id = coordination.auth_session_grant_id
  where coordination.expected_auth_subject_id = v_subject
    and coordination.confirmed_auth_subject_id = v_subject
    and coordination.state = 'SESSION_ESTABLISHED_NO_AUTHORITY'
    and coordination.terminal_result = 'AUTHENTICATED_BUT_NOT_TENANT_AUTHORIZED'
    and bridge.auth_user_id = v_subject
    and session_grant.auth_user_id = v_subject
    and session_grant.consumed_at is not null
    and session_grant.revoked_at is null
    and private.task_021_subject_is_compatible(v_subject);

  return query select case
    when v_count = 1 then 'PENDING_DOMAIN_COMPLETION'::text
    else 'UNAVAILABLE'::text
  end;
end;
$$;

create or replace function public.task_013_custom_access_token_hook(event jsonb)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_method text := event->>'authentication_method';
  v_user_id uuid;
  v_email text := event->'claims'->>'email';
  v_claims jsonb := event->'claims';
  v_coord record;
  v_grant record;
  v_bridge record;
  v_eligible_count integer;
  v_now timestamptz;
begin
  if v_claims is null or jsonb_typeof(v_claims) <> 'object' then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
  end if;

  if v_method = 'token_refresh' then
    return jsonb_build_object('claims', v_claims);
  end if;
  if v_method is distinct from 'password' then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
  end if;

  begin
    v_user_id := (event->>'user_id')::uuid;
  exception when others then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
  end;
  if v_email is null or btrim(v_email) = '' then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
  end if;

  select count(*) into v_eligible_count
  from public.later_user_initial_session_coordinations as coordination
  join public.auth_session_grants as session_grant
    on session_grant.id = coordination.auth_session_grant_id
  join public.auth_bridge_credentials as bridge
    on bridge.id = coordination.auth_bridge_credential_id
  where coordination.state = 'ISSUANCE_ACTIVE'
    and coordination.expected_auth_subject_id = v_user_id
    and coordination.confirmed_auth_subject_id = v_user_id
    and bridge.auth_user_id = v_user_id
    and bridge.email = v_email
    and session_grant.auth_user_id = v_user_id
    and session_grant.purpose = 'initial_session'
    and session_grant.auth_method = 'password'
    and session_grant.consumed_at is null
    and session_grant.revoked_at is null
    and clock_timestamp() < session_grant.expires_at
    and clock_timestamp() < coordination.expires_at;

  if v_eligible_count = 1 then
    perform 1 from public.auth_subject_authority_anchors
    where auth_subject_id = v_user_id
    for update;

    select bridge.id, bridge.email, bridge.auth_user_id into strict v_bridge
    from public.auth_bridge_credentials as bridge
    join public.later_user_initial_session_coordinations as coordination
      on coordination.auth_bridge_credential_id = bridge.id
    where coordination.state = 'ISSUANCE_ACTIVE'
      and coordination.expected_auth_subject_id = v_user_id
      and coordination.confirmed_auth_subject_id = v_user_id
      and bridge.auth_user_id = v_user_id
      and bridge.email = v_email
    for update of bridge;

    select coordination.* into strict v_coord
    from public.later_user_initial_session_coordinations as coordination
    where coordination.auth_bridge_credential_id = v_bridge.id
      and coordination.state = 'ISSUANCE_ACTIVE'
      and coordination.expected_auth_subject_id = v_user_id
      and coordination.confirmed_auth_subject_id = v_user_id
    for update;

    select session_grant.* into strict v_grant
    from public.auth_session_grants as session_grant
    where session_grant.id = v_coord.auth_session_grant_id
      and session_grant.auth_user_id = v_user_id
      and session_grant.purpose = 'initial_session'
      and session_grant.auth_method = 'password'
      and session_grant.consumed_at is null
      and session_grant.revoked_at is null
      and clock_timestamp() < session_grant.expires_at
    for update;

    v_now := clock_timestamp();
    update public.auth_session_grants
    set consumed_at = v_now
    where id = v_grant.id
      and consumed_at is null
      and revoked_at is null
      and v_now < expires_at;
    if not found then
      raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
    end if;

    update public.later_user_initial_session_coordinations
    set state = 'GATE_CONSUMED', updated_at = v_now
    where id = v_coord.id
      and state = 'ISSUANCE_ACTIVE'
      and v_now < expires_at;
    if not found then
      raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
    end if;

    return jsonb_build_object('claims', v_claims);
  elsif v_eligible_count > 1 then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
  end if;

  -- Historical TASK-013/CORR-032 path remains intact for grants without
  -- TASK-021 coordination. This path deliberately retains its established
  -- prebound-or-bind behavior and never reads tenant/application authority.
  select count(*) into v_eligible_count
  from public.auth_session_grants as session_grant
  join public.auth_bridge_credentials as bridge
    on bridge.id = session_grant.auth_bridge_credential_id
  left join public.later_user_initial_session_coordinations as coordination
    on coordination.auth_session_grant_id = session_grant.id
  where coordination.id is null
    and session_grant.purpose = 'initial_session'
    and session_grant.auth_method = 'password'
    and session_grant.consumed_at is null
    and session_grant.revoked_at is null
    and clock_timestamp() < session_grant.expires_at
    and bridge.email = v_email
    and (bridge.auth_user_id is null or bridge.auth_user_id = v_user_id)
    and (session_grant.auth_user_id is null or session_grant.auth_user_id = v_user_id);

  if v_eligible_count <> 1 then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
  end if;

  select
    session_grant.id,
    session_grant.auth_bridge_credential_id,
    session_grant.auth_user_id,
    session_grant.purpose,
    session_grant.auth_method,
    session_grant.expires_at,
    session_grant.consumed_at,
    session_grant.revoked_at
  into strict v_grant
  from public.auth_session_grants as session_grant
  join public.auth_bridge_credentials as bridge
    on bridge.id = session_grant.auth_bridge_credential_id
  left join public.later_user_initial_session_coordinations as coordination
    on coordination.auth_session_grant_id = session_grant.id
  where coordination.id is null
    and session_grant.purpose = 'initial_session'
    and session_grant.auth_method = 'password'
    and session_grant.consumed_at is null
    and session_grant.revoked_at is null
    and clock_timestamp() < session_grant.expires_at
    and bridge.email = v_email
    and (bridge.auth_user_id is null or bridge.auth_user_id = v_user_id)
    and (session_grant.auth_user_id is null or session_grant.auth_user_id = v_user_id)
  for update of session_grant;

  v_now := clock_timestamp();
  select id, email, auth_user_id into strict v_bridge
  from public.auth_bridge_credentials
  where id = v_grant.auth_bridge_credential_id;

  if v_bridge.email <> v_email
    or (v_bridge.auth_user_id is not null and v_bridge.auth_user_id <> v_user_id) then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
  end if;

  if v_bridge.auth_user_id is null then
    select id, email, auth_user_id into strict v_bridge
    from public.auth_bridge_credentials
    where id = v_grant.auth_bridge_credential_id
      and auth_user_id is null
    for update;
    if v_bridge.email <> v_email or v_bridge.auth_user_id is not null then
      raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
    end if;
    update public.auth_bridge_credentials
    set auth_user_id = v_user_id, bound_at = v_now
    where id = v_bridge.id and auth_user_id is null;
    if not found then
      raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
    end if;
  end if;

  update public.auth_session_grants
  set auth_user_id = v_user_id, consumed_at = v_now
  where id = v_grant.id
    and purpose = 'initial_session'
    and auth_method = 'password'
    and consumed_at is null
    and revoked_at is null
    and v_now < expires_at;
  if not found then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
  end if;

  return jsonb_build_object('claims', v_claims);
exception
  when no_data_found or too_many_rows then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
  when others then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
end;
$$;

alter function private.task_021_coordination_bindings_immutable() owner to postgres;
alter function private.task_021_subject_is_compatible(uuid) owner to postgres;
alter function public.task_021_reconcile_initial_session(uuid) owner to postgres;
alter function public.task_021_mark_provisioning_unknown(uuid, uuid) owner to postgres;
alter function public.task_021_confirm_auth_subject(uuid, uuid) owner to postgres;
alter function public.task_021_mark_repair_required(uuid, uuid, text) owner to postgres;
alter function public.task_021_activate_issuance(uuid, uuid, uuid) owner to postgres;
alter function public.task_021_finalize_initial_session(uuid, uuid) owner to postgres;
alter function public.resolve_current_later_user_pre_client_state() owner to postgres;
alter function public.task_013_custom_access_token_hook(jsonb) owner to postgres;

revoke all on function private.task_021_coordination_bindings_immutable() from public;
revoke all on function private.task_021_subject_is_compatible(uuid) from public;
revoke all on function public.task_021_reconcile_initial_session(uuid) from public, anon, authenticated;
revoke all on function public.task_021_mark_provisioning_unknown(uuid, uuid) from public, anon, authenticated;
revoke all on function public.task_021_confirm_auth_subject(uuid, uuid) from public, anon, authenticated;
revoke all on function public.task_021_mark_repair_required(uuid, uuid, text) from public, anon, authenticated;
revoke all on function public.task_021_activate_issuance(uuid, uuid, uuid) from public, anon, authenticated;
revoke all on function public.task_021_finalize_initial_session(uuid, uuid) from public, anon, authenticated;
revoke all on function public.resolve_current_later_user_pre_client_state() from public, anon;

grant execute on function public.task_021_reconcile_initial_session(uuid) to service_role;
grant execute on function public.task_021_mark_provisioning_unknown(uuid, uuid) to service_role;
grant execute on function public.task_021_confirm_auth_subject(uuid, uuid) to service_role;
grant execute on function public.task_021_mark_repair_required(uuid, uuid, text) to service_role;
grant execute on function public.task_021_activate_issuance(uuid, uuid, uuid) to service_role;
grant execute on function public.task_021_finalize_initial_session(uuid, uuid) to service_role;
grant execute on function public.resolve_current_later_user_pre_client_state() to authenticated;

grant select, insert on table public.auth_subject_authority_anchors to supabase_auth_admin;
grant select on table public.later_user_initial_session_coordinations to supabase_auth_admin;
grant update (state, updated_at) on table public.later_user_initial_session_coordinations to supabase_auth_admin;

create policy task_021_auth_hook_read_anchors
on public.auth_subject_authority_anchors
for select to supabase_auth_admin
using (true);

create policy task_021_auth_hook_insert_anchors
on public.auth_subject_authority_anchors
for insert to supabase_auth_admin
with check (true);

create policy task_021_auth_hook_read_coordinations
on public.later_user_initial_session_coordinations
for select to supabase_auth_admin
using (true);

create policy task_021_auth_hook_consume_coordination
on public.later_user_initial_session_coordinations
for update to supabase_auth_admin
using (
  state = 'ISSUANCE_ACTIVE'
  and confirmed_auth_subject_id = expected_auth_subject_id
  and clock_timestamp() < expires_at
)
with check (
  state = 'GATE_CONSUMED'
  and confirmed_auth_subject_id = expected_auth_subject_id
  and clock_timestamp() < expires_at
);

-- Existing exact subjects receive their stable anchor before the participating
-- authority writers below are replaced. Reserved TASK-021 subjects are added
-- by task_021_reconcile_initial_session before any provider side effect.
insert into public.auth_subject_authority_anchors (auth_subject_id)
select auth_subject.auth_subject_id
from public.platform_user_auth_subjects as auth_subject
union
select bridge.auth_user_id
from public.auth_bridge_credentials as bridge
where bridge.auth_user_id is not null
on conflict (auth_subject_id) do nothing;

create or replace function private.apply_company_membership_lifecycle(
  p_target_company_membership_id uuid,
  p_operation text,
  p_requested_role text
)
returns table (outcome text, changed boolean, reason text)
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_preliminary_auth_subject_id uuid;
  v_auth_subject_id uuid;
  v_actor_platform_user_id uuid;
  v_actor_company_membership_id uuid;
  v_maintenance_company_id uuid;
  v_actor_role text;
  v_actor_is_enabled boolean;
  v_actor_is_super_admin boolean;
  v_target_platform_user_id uuid;
  v_target_auth_subject_id uuid;
  v_target_subject_count integer;
  v_target_role text;
  v_target_is_enabled boolean;
  v_target_is_super_admin boolean;
  v_enabled_admin_count bigint;
  v_action text;
  v_requires_subject_fence boolean := false;
begin
  if p_target_company_membership_id is null
    or p_operation is null
    or p_operation not in ('DISABLE', 'REINSTATE', 'CHANGE_ROLE')
    or (p_operation = 'CHANGE_ROLE' and (
      p_requested_role is null
      or p_requested_role not in ('COMPANY_ADMIN', 'TECHNICIAN')
    ))
    or (p_operation in ('DISABLE', 'REINSTATE') and p_requested_role is not null)
  then
    return query select 'DENIED'::text, false, 'INVALID_INPUT'::text;
    return;
  end if;

  v_preliminary_auth_subject_id := auth.uid();
  if v_preliminary_auth_subject_id is null then
    return query select 'DENIED'::text, false, 'AUTHORIZATION_DENIED'::text;
    return;
  end if;

  select
    actor_user.id,
    actor_membership.id,
    actor_membership.maintenance_company_id,
    actor_membership.role,
    actor_membership.is_enabled,
    actor_user.is_super_admin
  into
    v_actor_platform_user_id,
    v_actor_company_membership_id,
    v_maintenance_company_id,
    v_actor_role,
    v_actor_is_enabled,
    v_actor_is_super_admin
  from public.platform_user_auth_subjects as actor_subject
  join public.platform_users as actor_user
    on actor_user.id = actor_subject.platform_user_id
  join public.company_memberships as actor_membership
    on actor_membership.platform_user_id = actor_user.id
  where actor_subject.auth_subject_id = v_preliminary_auth_subject_id;

  if not found or not v_actor_is_enabled
    or v_actor_role <> 'COMPANY_ADMIN' or v_actor_is_super_admin then
    return query select 'DENIED'::text, false, 'AUTHORIZATION_DENIED'::text;
    return;
  end if;

  perform 1 from public.maintenance_companies
  where id = v_maintenance_company_id
  for update;
  if not found then
    return query select 'DENIED'::text, false, 'AUTHORIZATION_DENIED'::text;
    return;
  end if;

  -- Fresh locator reads occur after the company lock but before target rows.
  select membership.platform_user_id, membership.is_enabled
  into v_target_platform_user_id, v_target_is_enabled
  from public.company_memberships as membership
  where membership.id = p_target_company_membership_id
    and membership.maintenance_company_id = v_maintenance_company_id;

  if not found then
    return query select 'DENIED'::text, false, 'TARGET_UNAVAILABLE'::text;
    return;
  end if;

  v_requires_subject_fence :=
    p_operation = 'REINSTATE'
    or (p_operation = 'CHANGE_ROLE' and v_target_is_enabled);

  if v_requires_subject_fence then
    select count(*), min(auth_subject.auth_subject_id::text)::uuid
    into v_target_subject_count, v_target_auth_subject_id
    from public.platform_user_auth_subjects as auth_subject
    where auth_subject.platform_user_id = v_target_platform_user_id;

    if v_target_subject_count <> 1 then
      return query select 'DENIED'::text, false, 'TARGET_UNAVAILABLE'::text;
      return;
    end if;

    insert into public.auth_subject_authority_anchors (auth_subject_id)
    values (v_target_auth_subject_id)
    on conflict (auth_subject_id) do nothing;

    perform 1 from public.auth_subject_authority_anchors
    where auth_subject_id = v_target_auth_subject_id
    for update;
    if not found then
      return query select 'DENIED'::text, false, 'TARGET_UNAVAILABLE'::text;
      return;
    end if;

    if exists (
      select 1
      from public.later_user_initial_session_coordinations as coordination
      where coordination.expected_auth_subject_id = v_target_auth_subject_id
        and coordination.state in ('ISSUANCE_ACTIVE', 'GATE_CONSUMED')
    ) then
      return query select 'DENIED'::text, false, 'TARGET_UNAVAILABLE'::text;
      return;
    end if;
  end if;

  v_auth_subject_id := auth.uid();
  if v_auth_subject_id is null
    or v_auth_subject_id <> v_preliminary_auth_subject_id then
    return query select 'DENIED'::text, false, 'AUTHORIZATION_DENIED'::text;
    return;
  end if;

  v_actor_platform_user_id := null;
  v_actor_company_membership_id := null;
  v_actor_role := null;
  v_actor_is_enabled := null;
  v_actor_is_super_admin := null;

  select
    actor_user.id,
    actor_membership.id,
    actor_membership.role,
    actor_membership.is_enabled,
    actor_user.is_super_admin
  into
    v_actor_platform_user_id,
    v_actor_company_membership_id,
    v_actor_role,
    v_actor_is_enabled,
    v_actor_is_super_admin
  from public.platform_user_auth_subjects as actor_subject
  join public.platform_users as actor_user
    on actor_user.id = actor_subject.platform_user_id
  join public.company_memberships as actor_membership
    on actor_membership.platform_user_id = actor_user.id
  where actor_subject.auth_subject_id = v_auth_subject_id
    and actor_membership.maintenance_company_id = v_maintenance_company_id
  for update of actor_subject, actor_user, actor_membership;

  if not found or not v_actor_is_enabled
    or v_actor_role <> 'COMPANY_ADMIN' or v_actor_is_super_admin then
    return query select 'DENIED'::text, false, 'AUTHORIZATION_DENIED'::text;
    return;
  end if;

  select
    target_membership.platform_user_id,
    target_membership.role,
    target_membership.is_enabled,
    target_user.is_super_admin
  into
    v_target_platform_user_id,
    v_target_role,
    v_target_is_enabled,
    v_target_is_super_admin
  from public.company_memberships as target_membership
  join public.platform_users as target_user
    on target_user.id = target_membership.platform_user_id
  where target_membership.id = p_target_company_membership_id
    and target_membership.maintenance_company_id = v_maintenance_company_id
  for update of target_membership, target_user;

  if not found or v_target_is_super_admin then
    return query select 'DENIED'::text, false, 'TARGET_UNAVAILABLE'::text;
    return;
  end if;

  if v_requires_subject_fence and (
    select count(*) <> 1
      or min(auth_subject.auth_subject_id::text)::uuid <> v_target_auth_subject_id
    from public.platform_user_auth_subjects as auth_subject
    where auth_subject.platform_user_id = v_target_platform_user_id
  ) then
    return query select 'DENIED'::text, false, 'TARGET_UNAVAILABLE'::text;
    return;
  end if;

  if p_target_company_membership_id = v_actor_company_membership_id
    and p_operation in ('DISABLE', 'CHANGE_ROLE') then
    return query select 'DENIED'::text, false, 'SELF_TARGET_NOT_ALLOWED'::text;
    return;
  end if;

  if (p_operation = 'DISABLE' and not v_target_is_enabled)
    or (p_operation = 'REINSTATE' and v_target_is_enabled)
    or (p_operation = 'CHANGE_ROLE' and v_target_role = p_requested_role) then
    return query select 'ALREADY_SATISFIED'::text, false, 'ALREADY_SATISFIED'::text;
    return;
  end if;

  if v_target_is_enabled and v_target_role = 'COMPANY_ADMIN'
    and (p_operation = 'DISABLE'
      or (p_operation = 'CHANGE_ROLE' and p_requested_role = 'TECHNICIAN')) then
    select count(*) into v_enabled_admin_count
    from public.company_memberships as enabled_admin
    join public.platform_users as enabled_admin_user
      on enabled_admin_user.id = enabled_admin.platform_user_id
    where enabled_admin.maintenance_company_id = v_maintenance_company_id
      and enabled_admin.is_enabled
      and enabled_admin.role = 'COMPANY_ADMIN'
      and not enabled_admin_user.is_super_admin;
    if v_enabled_admin_count <= 1 then
      return query select 'DENIED'::text, false, 'ADMIN_CONTINUITY_REQUIRED'::text;
      return;
    end if;
  end if;

  if p_operation = 'DISABLE' then
    update public.company_memberships set is_enabled = false
    where id = p_target_company_membership_id;
    v_action := 'USER_DISABLED_OR_REVOKED';
  elsif p_operation = 'REINSTATE' then
    update public.company_memberships set is_enabled = true
    where id = p_target_company_membership_id;
    v_action := 'USER_REINSTATED';
  else
    update public.company_memberships set role = p_requested_role
    where id = p_target_company_membership_id;
    v_action := 'USER_ROLE_CHANGED';
  end if;

  insert into public.audit_events (
    id, maintenance_company_id, actor_kind, actor_platform_user_id,
    actor_internal_process_key, action, scope_kind,
    subject_platform_user_id, role_before, role_after
  ) values (
    pg_catalog.gen_random_uuid(), v_maintenance_company_id, 'PLATFORM_USER',
    v_actor_platform_user_id, null, v_action, 'USER',
    v_target_platform_user_id,
    case when p_operation = 'CHANGE_ROLE' then v_target_role else null end,
    case when p_operation = 'CHANGE_ROLE' then p_requested_role else null end
  );

  return query select 'APPLIED'::text, true, 'APPLIED'::text;
end;
$$;

alter function private.apply_company_membership_lifecycle(uuid, text, text)
owner to postgres;
revoke all on function private.apply_company_membership_lifecycle(uuid, text, text)
from public, anon, authenticated, service_role, supabase_auth_admin;
grant execute on function private.apply_company_membership_lifecycle(uuid, text, text)
to authenticated;

-- Preserve the reviewed TASK-019/CORR-035 implementation as an internal
-- delegate. The new canonical entry point acquires the ADR-0022 subject fence
-- first, using the required actor -> company -> intent -> anchor order.
alter function private.complete_first_admin_onboarding(text, text, uuid)
rename to task_019_complete_first_admin_onboarding_pre_task_021;

revoke all on function private.task_019_complete_first_admin_onboarding_pre_task_021(text, text, uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

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
  v_preliminary_auth_subject_id uuid := auth.uid();
  v_current_auth_subject_id uuid;
  v_candidate_count integer;
  v_intent_id uuid;
  v_company_id uuid;
  v_initiated_by_platform_user_id uuid;
  v_pre_anchor_platform_user_id uuid;
  v_post_anchor_platform_user_id uuid;
begin
  if v_preliminary_auth_subject_id is null then
    return query select
      'DENIED'::text, 'AUTHORIZATION_DENIED'::text,
      null::uuid, null::uuid, null::timestamptz;
    return;
  end if;

  if p_operation_id is null
    or p_first_name is null
    or p_last_name is null
    or pg_catalog.btrim(p_first_name) = ''
    or pg_catalog.btrim(p_last_name) = '' then
    return query select
      'DENIED'::text, 'INVALID_INPUT'::text,
      null::uuid, null::uuid, null::timestamptz;
    return;
  end if;

  select
    count(*),
    min(intent.id::text)::uuid,
    min(intent.maintenance_company_id::text)::uuid,
    min(intent.initiated_by_platform_user_id::text)::uuid
  into
    v_candidate_count,
    v_intent_id,
    v_company_id,
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

  if v_candidate_count <> 1 then
    return query select
      'DENIED'::text, 'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid, null::uuid, null::timestamptz;
    return;
  end if;

  -- ALIAS-01: fail before waiting for the subject anchor when the historical
  -- actor row is already the exact target subject mapping.
  select auth_subject.platform_user_id
  into v_pre_anchor_platform_user_id
  from public.platform_user_auth_subjects as auth_subject
  where auth_subject.auth_subject_id = v_preliminary_auth_subject_id;

  if found and v_pre_anchor_platform_user_id = v_initiated_by_platform_user_id then
    return query select
      'DENIED'::text, 'IDENTITY_INCOMPATIBLE'::text,
      null::uuid, null::uuid, null::timestamptz;
    return;
  end if;

  perform actor.id
  from public.platform_users as actor
  where actor.id = v_initiated_by_platform_user_id
  for key share;
  if not found then
    return query select
      'DENIED'::text, 'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid, null::uuid, null::timestamptz;
    return;
  end if;

  perform company.id
  from public.maintenance_companies as company
  where company.id = v_company_id
  for update;
  if not found then
    return query select
      'DENIED'::text, 'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid, null::uuid, null::timestamptz;
    return;
  end if;

  perform 1 from public.first_admin_onboarding_intents
  where id = v_intent_id
    and maintenance_company_id = v_company_id
    and initiated_by_platform_user_id = v_initiated_by_platform_user_id
  for update;
  if not found then
    return query select
      'DENIED'::text, 'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid, null::uuid, null::timestamptz;
    return;
  end if;

  v_current_auth_subject_id := auth.uid();
  if v_current_auth_subject_id is null
    or v_current_auth_subject_id <> v_preliminary_auth_subject_id then
    return query select
      'DENIED'::text, 'AUTHORIZATION_DENIED'::text,
      null::uuid, null::uuid, null::timestamptz;
    return;
  end if;

  insert into public.auth_subject_authority_anchors (auth_subject_id)
  values (v_current_auth_subject_id)
  on conflict (auth_subject_id) do nothing;

  begin
    perform 1 from public.auth_subject_authority_anchors
    where auth_subject_id = v_current_auth_subject_id
    for update nowait;
  exception
    when lock_not_available then
      return query select
        'DENIED'::text, 'SECURITY_CORRELATION_FAILURE'::text,
        null::uuid, null::uuid, null::timestamptz;
      return;
  end;

  if not found or exists (
    select 1
    from public.later_user_initial_session_coordinations as coordination
    where coordination.expected_auth_subject_id = v_current_auth_subject_id
      and coordination.state in ('ISSUANCE_ACTIVE', 'GATE_CONSUMED')
  ) then
    return query select
      'DENIED'::text, 'SECURITY_CORRELATION_FAILURE'::text,
      null::uuid, null::uuid, null::timestamptz;
    return;
  end if;

  -- ALIAS-02/03: re-resolve after the fail-fast anchor acquisition. Any
  -- mapping to a pre-anchor retained actor row fails closed before target
  -- mapping/user/membership locks or authority mutation.
  select auth_subject.platform_user_id
  into v_post_anchor_platform_user_id
  from public.platform_user_auth_subjects as auth_subject
  where auth_subject.auth_subject_id = v_current_auth_subject_id;

  if found and v_post_anchor_platform_user_id = v_initiated_by_platform_user_id then
    return query select
      'DENIED'::text, 'IDENTITY_INCOMPATIBLE'::text,
      null::uuid, null::uuid, null::timestamptz;
    return;
  end if;

  /* CORR-035 relative-order evidence retained by the wrapper/delegate pair:
v_auth_subject_id := auth.uid()
select intent.*
  into strict v_intent
from public.platform_user_auth_subjects as auth_subject
  join public.platform_users as platform_user
    on platform_user.id = auth_subject.platform_user_id
  where auth_subject.auth_subject_id = v_auth_subject_id
  for update of auth_subject, platform_user
from public.company_memberships as membership
  where membership.maintenance_company_id = v_intent.maintenance_company_id
  for update
intent.initiated_by_platform_user_id <> v_initiated_by_platform_user_id
intent.initiated_by_platform_user_id = v_initiated_by_platform_user_id
  */

  return query
  select result.outcome, result.reason, result.platform_user_id,
    result.company_membership_id, result.completed_at
  from private.task_019_complete_first_admin_onboarding_pre_task_021(
    p_first_name,
    p_last_name,
    p_operation_id
  ) as result;
end;
$$;

alter function private.complete_first_admin_onboarding(text, text, uuid)
owner to postgres;
revoke all on function private.complete_first_admin_onboarding(text, text, uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;
grant execute on function private.complete_first_admin_onboarding(text, text, uuid)
to authenticated;

comment on function public.task_021_reconcile_initial_session(uuid) is
  'Server-only TASK-021 handoff reconciliation. Reserves exact UUIDv4 and anchor before provider mutation; creates no tenant authority.';
comment on function public.task_021_activate_issuance(uuid, uuid, uuid) is
  'Server-only TASK-021 compatibility check and ISSUANCE_ACTIVE fence activation under company->intent->subject lock order.';
comment on function public.task_021_finalize_initial_session(uuid, uuid) is
  'Server-only TASK-021 terminal compatibility recheck and authenticated-but-not-authorized terminalization.';
