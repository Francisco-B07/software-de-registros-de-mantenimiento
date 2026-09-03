create table public.verification_challenges (
  id uuid primary key,
  email text not null,
  verifier bytea not null,
  verifier_key_version text not null,
  issued_at timestamptz not null default clock_timestamp(),
  expires_at timestamptz not null,
  attempt_count smallint not null default 0,
  consumed_at timestamptz,
  invalidated_at timestamptz,
  exhausted_at timestamptz,
  supersedes_challenge_id uuid,
  issue_operation_id uuid not null unique,
  constraint verification_challenges_email_check
    check (btrim(email) <> ''),
  constraint verification_challenges_verifier_length_check
    check (octet_length(verifier) = 32),
  constraint verification_challenges_verifier_key_version_check
    check (
      btrim(verifier_key_version) <> ''
      and verifier_key_version ~ '^[A-Za-z0-9._-]+$'
    ),
  constraint verification_challenges_expiry_check
    check (expires_at = issued_at + interval '8 hours'),
  constraint verification_challenges_attempt_count_check
    check (attempt_count between 0 and 3),
  constraint verification_challenges_terminal_state_check
    check (num_nonnulls(consumed_at, invalidated_at, exhausted_at) <= 1),
  constraint verification_challenges_exhausted_attempts_check
    check (exhausted_at is null or attempt_count = 3),
  constraint verification_challenges_self_supersede_check
    check (supersedes_challenge_id is null or supersedes_challenge_id <> id),
  constraint verification_challenges_supersedes_challenge_id_fkey
    foreign key (supersedes_challenge_id)
    references public.verification_challenges (id)
    on delete restrict
);

create unique index verification_challenges_one_successor_idx
on public.verification_challenges (supersedes_challenge_id)
where supersedes_challenge_id is not null;

create table public.verification_challenge_attempts (
  id uuid primary key default gen_random_uuid(),
  challenge_id uuid not null,
  operation_id uuid not null unique,
  attempt_number smallint not null,
  matched boolean not null,
  created_at timestamptz not null default clock_timestamp(),
  constraint verification_challenge_attempts_challenge_id_fkey
    foreign key (challenge_id)
    references public.verification_challenges (id)
    on delete restrict,
  constraint verification_challenge_attempts_attempt_number_check
    check (attempt_number between 1 and 3),
  constraint verification_challenge_attempts_challenge_attempt_key
    unique (challenge_id, attempt_number)
);

create index verification_challenge_attempts_challenge_id_idx
on public.verification_challenge_attempts (challenge_id);

create table public.auth_bridge_credentials (
  id uuid primary key default gen_random_uuid(),
  email text not null unique,
  auth_user_id uuid unique,
  technical_password_key_version text not null,
  pending_key_version text,
  rotation_operation_id uuid unique,
  created_at timestamptz not null default clock_timestamp(),
  bound_at timestamptz,
  rotation_started_at timestamptz,
  rotated_at timestamptz,
  constraint auth_bridge_credentials_auth_user_id_fkey
    foreign key (auth_user_id)
    references auth.users (id)
    on delete restrict,
  constraint auth_bridge_credentials_email_check
    check (btrim(email) <> ''),
  constraint auth_bridge_credentials_key_version_check
    check (
      btrim(technical_password_key_version) <> ''
      and technical_password_key_version ~ '^[A-Za-z0-9._-]+$'
    ),
  constraint auth_bridge_credentials_pending_key_version_check
    check (
      pending_key_version is null
      or (
        btrim(pending_key_version) <> ''
        and pending_key_version ~ '^[A-Za-z0-9._-]+$'
        and pending_key_version <> technical_password_key_version
      )
    ),
  constraint auth_bridge_credentials_binding_check
    check (
      (auth_user_id is null and bound_at is null)
      or (auth_user_id is not null and bound_at is not null)
    ),
  constraint auth_bridge_credentials_rotation_state_check
    check (
      (
        pending_key_version is null
        and rotation_operation_id is null
        and rotation_started_at is null
      )
      or (
        pending_key_version is not null
        and rotation_operation_id is not null
        and rotation_started_at is not null
      )
    )
);

create table public.auth_session_grants (
  id uuid primary key default gen_random_uuid(),
  challenge_id uuid not null unique,
  auth_bridge_credential_id uuid not null,
  auth_user_id uuid,
  purpose text not null default 'initial_session',
  auth_method text not null default 'password',
  created_at timestamptz not null default clock_timestamp(),
  expires_at timestamptz not null,
  consumed_at timestamptz,
  revoked_at timestamptz,
  grant_operation_id uuid not null unique,
  constraint auth_session_grants_challenge_id_fkey
    foreign key (challenge_id)
    references public.verification_challenges (id)
    on delete restrict,
  constraint auth_session_grants_bridge_credential_id_fkey
    foreign key (auth_bridge_credential_id)
    references public.auth_bridge_credentials (id)
    on delete restrict,
  constraint auth_session_grants_auth_user_id_fkey
    foreign key (auth_user_id)
    references auth.users (id)
    on delete restrict,
  constraint auth_session_grants_purpose_check
    check (purpose = 'initial_session'),
  constraint auth_session_grants_auth_method_check
    check (auth_method = 'password'),
  constraint auth_session_grants_expiry_check
    check (expires_at = created_at + interval '5 minutes'),
  constraint auth_session_grants_terminal_state_check
    check (num_nonnulls(consumed_at, revoked_at) <= 1)
);

create index auth_session_grants_bridge_credential_id_idx
on public.auth_session_grants (auth_bridge_credential_id);

create unique index auth_session_grants_one_eligible_per_bridge_idx
on public.auth_session_grants (auth_bridge_credential_id)
where consumed_at is null and revoked_at is null;

alter table public.verification_challenges enable row level security;
alter table public.verification_challenge_attempts enable row level security;
alter table public.auth_bridge_credentials enable row level security;
alter table public.auth_session_grants enable row level security;

revoke all privileges on table public.verification_challenges
from public, anon, authenticated, service_role, supabase_auth_admin;
revoke all privileges on table public.verification_challenge_attempts
from public, anon, authenticated, service_role, supabase_auth_admin;
revoke all privileges on table public.auth_bridge_credentials
from public, anon, authenticated, service_role, supabase_auth_admin;
revoke all privileges on table public.auth_session_grants
from public, anon, authenticated, service_role, supabase_auth_admin;

grant select, insert, update on table public.verification_challenges to service_role;
grant select, insert on table public.verification_challenge_attempts to service_role;
grant select, insert, update on table public.auth_bridge_credentials to service_role;
grant select, insert, update on table public.auth_session_grants to service_role;

create or replace function public.issue_verification_challenge(
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
security invoker
set search_path = ''
as $$
declare
  v_now timestamptz := clock_timestamp();
  v_row public.verification_challenges%rowtype;
begin
  if p_challenge_id is null
    or p_issue_operation_id is null
    or p_email is null
    or btrim(p_email) = ''
    or p_verifier is null
    or octet_length(p_verifier) <> 32
    or p_verifier_key_version is null
    or btrim(p_verifier_key_version) = '' then
    raise exception using errcode = '22023', message = 'Verification challenge request denied.';
  end if;

  insert into public.verification_challenges (
    id, email, verifier, verifier_key_version, issued_at, expires_at,
    issue_operation_id
  ) values (
    p_challenge_id, p_email, p_verifier, p_verifier_key_version, v_now,
    v_now + interval '8 hours', p_issue_operation_id
  )
  on conflict (issue_operation_id) do nothing;

  select * into strict v_row
  from public.verification_challenges
  where issue_operation_id = p_issue_operation_id;

  if v_row.id <> p_challenge_id
    or v_row.email <> p_email
    or v_row.verifier <> p_verifier
    or v_row.verifier_key_version <> p_verifier_key_version then
    raise exception using errcode = 'P0001', message = 'Verification challenge request denied.';
  end if;

  return query select v_row.id, v_row.issued_at, v_row.expires_at;
end;
$$;

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

create or replace function public.get_verification_challenge_material(
  p_challenge_id uuid,
  p_email text
)
returns table (
  verifier bytea,
  verifier_key_version text
)
language sql
stable
security invoker
set search_path = ''
as $$
  select challenge.verifier, challenge.verifier_key_version
  from public.verification_challenges as challenge
  where challenge.id = p_challenge_id
    and challenge.email = p_email
    and challenge.consumed_at is null
    and challenge.invalidated_at is null
    and challenge.exhausted_at is null
    and challenge.attempt_count < 3
    and clock_timestamp() < challenge.expires_at
$$;

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
    if v_attempt.challenge_id <> p_challenge_id then
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
    if v_attempt.challenge_id <> p_challenge_id then
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
  v_grant record;
  v_bridge record;
  v_eligible_count integer;
  v_now timestamptz := clock_timestamp();
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
  from public.auth_session_grants as session_grant
  join public.auth_bridge_credentials as bridge
    on bridge.id = session_grant.auth_bridge_credential_id
  where session_grant.purpose = 'initial_session'
    and session_grant.auth_method = 'password'
    and session_grant.consumed_at is null
    and session_grant.revoked_at is null
    and v_now < session_grant.expires_at
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
    session_grant.expires_at,
    session_grant.consumed_at,
    session_grant.revoked_at
  into strict v_grant
  from public.auth_session_grants as session_grant
  join public.auth_bridge_credentials as bridge
    on bridge.id = session_grant.auth_bridge_credential_id
  where session_grant.purpose = 'initial_session'
    and session_grant.auth_method = 'password'
    and session_grant.consumed_at is null
    and session_grant.revoked_at is null
    and v_now < session_grant.expires_at
    and bridge.email = v_email
    and (bridge.auth_user_id is null or bridge.auth_user_id = v_user_id)
    and (session_grant.auth_user_id is null or session_grant.auth_user_id = v_user_id)
  for update of session_grant;

  select id, email, auth_user_id into strict v_bridge
  from public.auth_bridge_credentials
  where id = v_grant.auth_bridge_credential_id
  for update;

  if v_bridge.email <> v_email
    or (v_bridge.auth_user_id is not null and v_bridge.auth_user_id <> v_user_id)
    or (v_grant.auth_user_id is not null and v_grant.auth_user_id <> v_user_id) then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
  end if;

  if v_bridge.auth_user_id is null then
    update public.auth_bridge_credentials
    set auth_user_id = v_user_id, bound_at = v_now
    where id = v_bridge.id and auth_user_id is null;
  end if;

  update public.auth_session_grants
  set auth_user_id = v_user_id, consumed_at = v_now
  where id = v_grant.id
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

revoke execute on function public.issue_verification_challenge(uuid, text, bytea, text, uuid)
from public, anon, authenticated;
revoke execute on function public.resend_verification_challenge(uuid, uuid, text, bytea, text, uuid)
from public, anon, authenticated;
revoke execute on function public.get_verification_challenge_material(uuid, text)
from public, anon, authenticated;
revoke execute on function public.verify_verification_challenge(uuid, text, uuid, boolean, text)
from public, anon, authenticated;
revoke execute on function public.task_013_custom_access_token_hook(jsonb)
from public, anon, authenticated, service_role;

grant execute on function public.issue_verification_challenge(uuid, text, bytea, text, uuid)
to service_role;
grant execute on function public.resend_verification_challenge(uuid, uuid, text, bytea, text, uuid)
to service_role;
grant execute on function public.get_verification_challenge_material(uuid, text)
to service_role;
grant execute on function public.verify_verification_challenge(uuid, text, uuid, boolean, text)
to service_role;

grant usage on schema public to supabase_auth_admin;
grant execute on function public.task_013_custom_access_token_hook(jsonb)
to supabase_auth_admin;

grant select (
  id,
  auth_bridge_credential_id,
  auth_user_id,
  purpose,
  auth_method,
  expires_at,
  consumed_at,
  revoked_at
) on public.auth_session_grants to supabase_auth_admin;
grant update (
  auth_user_id,
  consumed_at
) on public.auth_session_grants to supabase_auth_admin;

grant select (
  id,
  email,
  auth_user_id
) on public.auth_bridge_credentials to supabase_auth_admin;
grant update (
  auth_user_id,
  bound_at
) on public.auth_bridge_credentials to supabase_auth_admin;

create policy task_013_auth_hook_read_session_grants
on public.auth_session_grants
for select
to supabase_auth_admin
using (purpose = 'initial_session' and auth_method = 'password');

create policy task_013_auth_hook_consume_session_grants
on public.auth_session_grants
for update
to supabase_auth_admin
using (
  purpose = 'initial_session'
  and auth_method = 'password'
  and consumed_at is null
  and revoked_at is null
  and clock_timestamp() < expires_at
)
with check (
  purpose = 'initial_session'
  and auth_method = 'password'
  and consumed_at is not null
  and revoked_at is null
  and clock_timestamp() < expires_at
);

create policy task_013_auth_hook_read_bridge_credentials
on public.auth_bridge_credentials
for select
to supabase_auth_admin
using (true);

create policy task_013_auth_hook_bind_bridge_credentials
on public.auth_bridge_credentials
for update
to supabase_auth_admin
using (auth_user_id is null and bound_at is null)
with check (auth_user_id is not null and bound_at is not null);
