create or replace function private.apply_company_membership_lifecycle(
  p_target_company_membership_id uuid,
  p_operation text,
  p_requested_role text
)
returns table (
  outcome text,
  changed boolean,
  reason text
)
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
  v_target_role text;
  v_target_is_enabled boolean;
  v_target_is_super_admin boolean;
  v_enabled_admin_count bigint;
  v_action text;
begin
  if p_target_company_membership_id is null
    or p_operation is null
    or p_operation not in ('DISABLE', 'REINSTATE', 'CHANGE_ROLE')
    or (
      p_operation = 'CHANGE_ROLE'
      and (
        p_requested_role is null
        or p_requested_role not in ('COMPANY_ADMIN', 'TECHNICIAN')
      )
    )
    or (
      p_operation in ('DISABLE', 'REINSTATE')
      and p_requested_role is not null
    )
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

  if not found
    or not v_actor_is_enabled
    or v_actor_role <> 'COMPANY_ADMIN'
    or v_actor_is_super_admin
  then
    return query select 'DENIED'::text, false, 'AUTHORIZATION_DENIED'::text;
    return;
  end if;

  perform 1
  from public.maintenance_companies as actor_company
  where actor_company.id = v_maintenance_company_id
  for update;

  if not found then
    return query select 'DENIED'::text, false, 'AUTHORIZATION_DENIED'::text;
    return;
  end if;

  v_auth_subject_id := auth.uid();

  if v_auth_subject_id is null
    or v_auth_subject_id <> v_preliminary_auth_subject_id
  then
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

  if not found
    or not v_actor_is_enabled
    or v_actor_role <> 'COMPANY_ADMIN'
    or v_actor_is_super_admin
  then
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

  if p_target_company_membership_id = v_actor_company_membership_id
    and p_operation in ('DISABLE', 'CHANGE_ROLE')
  then
    return query select 'DENIED'::text, false, 'SELF_TARGET_NOT_ALLOWED'::text;
    return;
  end if;

  if (p_operation = 'DISABLE' and not v_target_is_enabled)
    or (p_operation = 'REINSTATE' and v_target_is_enabled)
    or (p_operation = 'CHANGE_ROLE' and v_target_role = p_requested_role)
  then
    return query select 'ALREADY_SATISFIED'::text, false, 'ALREADY_SATISFIED'::text;
    return;
  end if;

  if v_target_is_enabled
    and v_target_role = 'COMPANY_ADMIN'
    and (
      p_operation = 'DISABLE'
      or (
        p_operation = 'CHANGE_ROLE'
        and p_requested_role = 'TECHNICIAN'
      )
    )
  then
    select count(*)
    into v_enabled_admin_count
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
    update public.company_memberships
    set is_enabled = false
    where id = p_target_company_membership_id;
    v_action := 'USER_DISABLED_OR_REVOKED';
  elsif p_operation = 'REINSTATE' then
    update public.company_memberships
    set is_enabled = true
    where id = p_target_company_membership_id;
    v_action := 'USER_REINSTATED';
  else
    update public.company_memberships
    set role = p_requested_role
    where id = p_target_company_membership_id;
    v_action := 'USER_ROLE_CHANGED';
  end if;

  insert into public.audit_events (
    id,
    maintenance_company_id,
    actor_kind,
    actor_platform_user_id,
    actor_internal_process_key,
    action,
    scope_kind,
    subject_platform_user_id,
    role_before,
    role_after
  )
  values (
    pg_catalog.gen_random_uuid(),
    v_maintenance_company_id,
    'PLATFORM_USER',
    v_actor_platform_user_id,
    null,
    v_action,
    'USER',
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

revoke usage on schema private
from public, anon, service_role, supabase_auth_admin;

grant usage on schema private to authenticated;
grant execute on function private.apply_company_membership_lifecycle(uuid, text, text)
to authenticated;

create or replace function public.apply_company_membership_lifecycle(
  p_target_company_membership_id uuid,
  p_operation text,
  p_requested_role text
)
returns table (
  outcome text,
  changed boolean,
  reason text
)
language sql
volatile
security invoker
set search_path = ''
as $$
  select
    lifecycle.outcome,
    lifecycle.changed,
    lifecycle.reason
  from private.apply_company_membership_lifecycle(
    p_target_company_membership_id,
    p_operation,
    p_requested_role
  ) as lifecycle;
$$;

alter function public.apply_company_membership_lifecycle(uuid, text, text)
owner to postgres;

revoke all on function public.apply_company_membership_lifecycle(uuid, text, text)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.apply_company_membership_lifecycle(uuid, text, text)
to authenticated;
