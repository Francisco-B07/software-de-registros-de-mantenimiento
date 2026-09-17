alter table public.maintenance_companies
add column creation_operation_id uuid;

create unique index maintenance_companies_creation_operation_id_key
on public.maintenance_companies (creation_operation_id)
where creation_operation_id is not null;

create function public.create_maintenance_company(
  p_creation_operation_id uuid
)
returns table (
  outcome text,
  changed boolean,
  maintenance_company_id uuid,
  reason text
)
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_auth_subject_id uuid;
  v_actor_platform_user_id uuid;
  v_actor_is_super_admin boolean;
  v_has_company_membership boolean;
  v_existing_company_id uuid;
  v_created_company_id uuid;
begin
  v_auth_subject_id := auth.uid();

  if v_auth_subject_id is null then
    return query select
      'DENIED'::text,
      false,
      null::uuid,
      'AUTHORIZATION_DENIED'::text;
    return;
  end if;

  begin
    select
      actor_user.id,
      actor_user.is_super_admin
    into strict
      v_actor_platform_user_id,
      v_actor_is_super_admin
    from public.platform_user_auth_subjects as actor_subject
    join public.platform_users as actor_user
      on actor_user.id = actor_subject.platform_user_id
    where actor_subject.auth_subject_id = v_auth_subject_id
    for update of actor_subject, actor_user;
  exception
    when no_data_found or too_many_rows then
      return query select
        'DENIED'::text,
        false,
        null::uuid,
        'AUTHORIZATION_DENIED'::text;
      return;
  end;

  if not v_actor_is_super_admin then
    return query select
      'DENIED'::text,
      false,
      null::uuid,
      'AUTHORIZATION_DENIED'::text;
    return;
  end if;

  select exists (
    select 1
    from public.company_memberships as actor_membership
    where actor_membership.platform_user_id = v_actor_platform_user_id
  )
  into v_has_company_membership;

  if v_has_company_membership then
    return query select
      'DENIED'::text,
      false,
      null::uuid,
      'INCONSISTENT_AUTHORITY'::text;
    return;
  end if;

  if p_creation_operation_id is null then
    return query select
      'DENIED'::text,
      false,
      null::uuid,
      'INVALID_INPUT'::text;
    return;
  end if;

  begin
    select company.id
    into strict v_existing_company_id
    from public.maintenance_companies as company
    where company.creation_operation_id = p_creation_operation_id;

    return query select
      'ALREADY_CREATED'::text,
      false,
      v_existing_company_id,
      'ALREADY_CREATED'::text;
    return;
  exception
    when no_data_found then
      v_existing_company_id := null;
    when too_many_rows then
      raise exception using
        errcode = 'P0001',
        message = 'Maintenance company creation could not be confirmed.';
  end;

  v_created_company_id := pg_catalog.gen_random_uuid();

  begin
    insert into public.maintenance_companies (
      id,
      creation_operation_id
    )
    values (
      v_created_company_id,
      p_creation_operation_id
    );
  exception
    when unique_violation then
      begin
        select company.id
        into strict v_existing_company_id
        from public.maintenance_companies as company
        where company.creation_operation_id = p_creation_operation_id;
      exception
        when no_data_found or too_many_rows then
          raise exception using
            errcode = 'P0001',
            message = 'Maintenance company creation could not be confirmed.';
      end;

      return query select
        'ALREADY_CREATED'::text,
        false,
        v_existing_company_id,
        'ALREADY_CREATED'::text;
      return;
  end;

  return query select
    'CREATED'::text,
    true,
    v_created_company_id,
    'CREATED'::text;
end;
$$;

alter function public.create_maintenance_company(uuid)
owner to postgres;

revoke all on function public.create_maintenance_company(uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.create_maintenance_company(uuid)
to authenticated;

comment on column public.maintenance_companies.creation_operation_id is
  'Purpose-specific idempotency correlation for TASK-016 company creation; NULL is permitted for pre-TASK-016 rows.';

comment on function public.create_maintenance_company(uuid) is
  'Creates one MaintenanceCompany for a currently authoritative global SUPER_ADMIN and reconciles authorized retries.';
