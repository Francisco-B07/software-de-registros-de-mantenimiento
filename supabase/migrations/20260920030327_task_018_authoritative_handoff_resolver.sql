create function public.resolve_first_admin_auth_handoff(
  p_intent_id uuid
)
returns table (
  intent_id uuid,
  maintenance_company_id uuid,
  target_email text,
  current_challenge_id uuid,
  handoff_session_grant_id uuid,
  handoff_ready_at timestamptz,
  challenge_consumed_at timestamptz,
  auth_bridge_credential_id uuid,
  bridge_auth_user_id uuid,
  grant_auth_user_id uuid,
  grant_purpose text,
  grant_auth_method text,
  grant_created_at timestamptz,
  grant_expires_at timestamptz,
  grant_consumed_at timestamptz,
  grant_revoked_at timestamptz,
  handoff_eligibility text,
  identity_compatibility text
)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_state record;
  v_platform_user_id uuid;
  v_is_super_admin boolean;
  v_handoff_eligibility text;
  v_identity_compatibility text;
begin
  select
    intent.id as intent_id,
    intent.maintenance_company_id,
    intent.target_email,
    intent.current_challenge_id,
    intent.handoff_session_grant_id,
    intent.handoff_ready_at,
    challenge.id as resolved_challenge_id,
    challenge.email as challenge_email,
    challenge.attempt_count as challenge_attempt_count,
    challenge.consumed_at as challenge_consumed_at,
    challenge.invalidated_at as challenge_invalidated_at,
    challenge.exhausted_at as challenge_exhausted_at,
    session_grant.id as resolved_grant_id,
    session_grant.challenge_id as grant_challenge_id,
    session_grant.auth_bridge_credential_id,
    session_grant.auth_user_id as grant_auth_user_id,
    session_grant.purpose as grant_purpose,
    session_grant.auth_method as grant_auth_method,
    session_grant.created_at as grant_created_at,
    session_grant.expires_at as grant_expires_at,
    session_grant.consumed_at as grant_consumed_at,
    session_grant.revoked_at as grant_revoked_at,
    session_grant.grant_operation_id,
    bridge.id as resolved_bridge_id,
    bridge.email as bridge_email,
    bridge.auth_user_id as bridge_auth_user_id,
    exists (
      select 1
      from public.verification_challenge_attempts as attempt
      where attempt.operation_id = session_grant.grant_operation_id
        and attempt.challenge_id = intent.current_challenge_id
        and attempt.matched
        and attempt.attempt_number = challenge.attempt_count
        and attempt.created_at = session_grant.created_at
    ) as has_correlated_matched_attempt,
    exists (
      select 1
      from public.verification_challenges as successor
      where successor.supersedes_challenge_id = intent.current_challenge_id
    ) as has_successor
  into v_state
  from public.first_admin_onboarding_intents as intent
  left join public.verification_challenges as challenge
    on challenge.id = intent.current_challenge_id
  left join public.auth_session_grants as session_grant
    on session_grant.id = intent.handoff_session_grant_id
  left join public.auth_bridge_credentials as bridge
    on bridge.id = session_grant.auth_bridge_credential_id
  where intent.id = p_intent_id;

  if not found or p_intent_id is null then
    return query
    select
      null::uuid,
      null::uuid,
      null::text,
      null::uuid,
      null::uuid,
      null::timestamptz,
      null::timestamptz,
      null::uuid,
      null::uuid,
      null::uuid,
      null::text,
      null::text,
      null::timestamptz,
      null::timestamptz,
      null::timestamptz,
      null::timestamptz,
      'FAIL_CLOSED'::text,
      'FAIL_CLOSED'::text;
    return;
  end if;

  if v_state.handoff_session_grant_id is null
    or v_state.handoff_ready_at is null
    or v_state.resolved_challenge_id is null
    or v_state.challenge_email is distinct from v_state.target_email
    or v_state.challenge_consumed_at is null
    or v_state.challenge_invalidated_at is not null
    or v_state.challenge_exhausted_at is not null
    or v_state.has_successor
    or v_state.resolved_grant_id is null
    or v_state.grant_challenge_id is distinct from v_state.current_challenge_id
    or v_state.handoff_ready_at is distinct from v_state.grant_created_at
    or v_state.challenge_consumed_at is distinct from v_state.grant_created_at
    or v_state.grant_expires_at is distinct from
      v_state.grant_created_at + interval '5 minutes'
    or not v_state.has_correlated_matched_attempt
    or v_state.resolved_bridge_id is null
    or v_state.bridge_email is distinct from v_state.target_email
    or v_state.bridge_auth_user_id is distinct from v_state.grant_auth_user_id
    or v_state.grant_purpose is distinct from 'initial_session'
    or v_state.grant_auth_method is distinct from 'password' then
    return query
    select
      null::uuid,
      null::uuid,
      null::text,
      null::uuid,
      null::uuid,
      null::timestamptz,
      null::timestamptz,
      null::uuid,
      null::uuid,
      null::uuid,
      null::text,
      null::text,
      null::timestamptz,
      null::timestamptz,
      null::timestamptz,
      null::timestamptz,
      'FAIL_CLOSED'::text,
      'FAIL_CLOSED'::text;
    return;
  end if;

  if v_state.bridge_auth_user_id is null then
    v_identity_compatibility := 'NO_APPLICATION_IDENTITY';
  else
    select
      auth_subject.platform_user_id,
      platform_user.is_super_admin
    into v_platform_user_id, v_is_super_admin
    from public.platform_user_auth_subjects as auth_subject
    join public.platform_users as platform_user
      on platform_user.id = auth_subject.platform_user_id
    where auth_subject.auth_subject_id = v_state.bridge_auth_user_id;

    if not found then
      v_identity_compatibility := 'NO_APPLICATION_IDENTITY';
    elsif v_platform_user_id is null or v_is_super_admin is null then
      v_identity_compatibility := 'FAIL_CLOSED';
    elsif v_is_super_admin
      or exists (
        select 1
        from public.company_memberships as membership
        where membership.platform_user_id = v_platform_user_id
      ) then
      v_identity_compatibility := 'INCOMPATIBLE_IDENTITY';
    else
      v_identity_compatibility := 'COMPATIBLE_EXISTING_APPLICATION_IDENTITY';
    end if;
  end if;

  if v_identity_compatibility = 'FAIL_CLOSED' then
    return query
    select
      null::uuid,
      null::uuid,
      null::text,
      null::uuid,
      null::uuid,
      null::timestamptz,
      null::timestamptz,
      null::uuid,
      null::uuid,
      null::uuid,
      null::text,
      null::text,
      null::timestamptz,
      null::timestamptz,
      null::timestamptz,
      null::timestamptz,
      'FAIL_CLOSED'::text,
      'FAIL_CLOSED'::text;
    return;
  end if;

  v_handoff_eligibility := case
    when v_state.grant_consumed_at is not null then 'GRANT_CONSUMED'
    when v_state.grant_revoked_at is not null then 'GRANT_REVOKED'
    when statement_timestamp() >= v_state.grant_expires_at then 'GRANT_EXPIRED'
    else 'ELIGIBLE'
  end;

  return query
  select
    v_state.intent_id,
    v_state.maintenance_company_id,
    v_state.target_email,
    v_state.current_challenge_id,
    v_state.handoff_session_grant_id,
    v_state.handoff_ready_at,
    v_state.challenge_consumed_at,
    v_state.auth_bridge_credential_id,
    v_state.bridge_auth_user_id,
    v_state.grant_auth_user_id,
    v_state.grant_purpose,
    v_state.grant_auth_method,
    v_state.grant_created_at,
    v_state.grant_expires_at,
    v_state.grant_consumed_at,
    v_state.grant_revoked_at,
    v_handoff_eligibility,
    v_identity_compatibility;
end;
$$;

alter function public.resolve_first_admin_auth_handoff(uuid)
owner to postgres;

revoke all on function public.resolve_first_admin_auth_handoff(uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.resolve_first_admin_auth_handoff(uuid)
to service_role;

comment on function public.resolve_first_admin_auth_handoff(uuid) is
  'TASK-018 server-only read-only resolver for one authoritative first-admin handoff; returns bounded eligibility and application-identity compatibility without verification or credential material.';
