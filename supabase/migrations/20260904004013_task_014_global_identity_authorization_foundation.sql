alter table public.platform_users
add column is_super_admin boolean not null default false;

create function public.resolve_current_global_authority()
returns table (
  identity_resolved boolean,
  is_super_admin boolean,
  has_company_membership boolean
)
language sql
stable
security definer
set search_path = ''
as $function$
  with resolved_identity as materialized (
    select
      platform_user.id as platform_user_id,
      platform_user.is_super_admin
    from public.platform_user_auth_subjects as auth_subject
    join public.platform_users as platform_user
      on platform_user.id = auth_subject.platform_user_id
    where auth_subject.auth_subject_id = (select auth.uid())
  ),
  classified_identity as (
    select
      resolved_identity.is_super_admin,
      exists (
        select 1
        from public.company_memberships as membership
        where membership.platform_user_id = resolved_identity.platform_user_id
      ) as has_company_membership
    from resolved_identity
  )
  select
    count(*) = 1 as identity_resolved,
    case
      when count(*) = 1 then coalesce(bool_and(classified_identity.is_super_admin), false)
      else false
    end as is_super_admin,
    case
      when count(*) = 1 then coalesce(bool_and(classified_identity.has_company_membership), false)
      else false
    end as has_company_membership
  from classified_identity;
$function$;

revoke execute on function public.resolve_current_global_authority()
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.resolve_current_global_authority()
to authenticated;
