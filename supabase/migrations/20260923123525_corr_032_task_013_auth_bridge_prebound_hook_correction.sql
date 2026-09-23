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
  from public.auth_session_grants as session_grant
  join public.auth_bridge_credentials as bridge
    on bridge.id = session_grant.auth_bridge_credential_id
  where session_grant.purpose = 'initial_session'
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
  where session_grant.purpose = 'initial_session'
    and session_grant.auth_method = 'password'
    and session_grant.consumed_at is null
    and session_grant.revoked_at is null
    and clock_timestamp() < session_grant.expires_at
    and bridge.email = v_email
    and (bridge.auth_user_id is null or bridge.auth_user_id = v_user_id)
    and (session_grant.auth_user_id is null or session_grant.auth_user_id = v_user_id)
  for update of session_grant;

  v_now := clock_timestamp();

  if v_grant.purpose <> 'initial_session'
    or v_grant.auth_method <> 'password'
    or v_grant.consumed_at is not null
    or v_grant.revoked_at is not null
    or v_now >= v_grant.expires_at
    or (v_grant.auth_user_id is not null and v_grant.auth_user_id <> v_user_id) then
    raise exception using errcode = 'P0001', message = 'Auth token issuance denied.';
  end if;

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
    where id = v_bridge.id
      and auth_user_id is null;

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
