\set ON_ERROR_STOP on

\if :{?task_009_delete_subject_id}
\else
  \echo 'Missing psql variable: task_009_delete_subject_id'
  \quit 2
\endif

begin;

-- These assertions and the final cleanup are Development test verification and
-- test teardown only, never an application deletion flow.

select set_config(
  'task_009.delete_subject_id',
  :'task_009_delete_subject_id',
  true
);

do $$
begin
  if exists (
    select 1
    from auth.users
    where id = current_setting('task_009.delete_subject_id')::uuid
  ) then
    raise exception 'Disposable Auth subject still exists';
  end if;

  if exists (
    select 1
    from public.platform_user_auth_subjects
    where auth_subject_id = current_setting('task_009.delete_subject_id')::uuid
  ) then
    raise exception 'Auth mapping did not follow the supported delete behavior';
  end if;

  if not exists (
    select 1
    from public.platform_users
    where id = '00000000-0000-4000-8000-00000000d102'
  ) then
    raise exception 'Auth deletion destroyed PlatformUser';
  end if;

  if not exists (
    select 1
    from public.company_memberships
    where id = '00000000-0000-4000-8000-00000000d103'
  ) then
    raise exception 'Auth deletion destroyed CompanyMembership';
  end if;

  if not exists (
    select 1
    from public.maintenance_companies
    where id = '00000000-0000-4000-8000-00000000d101'
  ) then
    raise exception 'Auth deletion destroyed MaintenanceCompany';
  end if;
end
$$;

delete from public.company_memberships
where id = '00000000-0000-4000-8000-00000000d103';

delete from public.platform_users
where id = '00000000-0000-4000-8000-00000000d102';

delete from public.maintenance_companies
where id = '00000000-0000-4000-8000-00000000d101';

commit;

\echo 'TASK-009 Auth deletion preserved all domain rows: PASS'
\echo 'TASK-009 Auth-delete fixtures cleaned up: PASS'
