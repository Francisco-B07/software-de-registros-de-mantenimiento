create table public.maintenance_companies (
  id uuid primary key
);

create table public.platform_users (
  id uuid primary key
);

create table public.platform_user_auth_subjects (
  auth_subject_id uuid primary key,
  platform_user_id uuid not null,
  constraint platform_user_auth_subjects_auth_subject_id_fkey
    foreign key (auth_subject_id)
    references auth.users (id)
    on delete cascade,
  constraint platform_user_auth_subjects_platform_user_id_fkey
    foreign key (platform_user_id)
    references public.platform_users (id)
    on delete restrict
);

create table public.company_memberships (
  id uuid primary key,
  platform_user_id uuid not null unique,
  maintenance_company_id uuid not null,
  role text not null,
  is_enabled boolean not null,
  constraint company_memberships_platform_user_id_fkey
    foreign key (platform_user_id)
    references public.platform_users (id)
    on delete restrict,
  constraint company_memberships_maintenance_company_id_fkey
    foreign key (maintenance_company_id)
    references public.maintenance_companies (id)
    on delete restrict,
  constraint company_memberships_role_check
    check (role in ('COMPANY_ADMIN', 'TECHNICIAN'))
);

alter table public.maintenance_companies enable row level security;
alter table public.platform_users enable row level security;
alter table public.platform_user_auth_subjects enable row level security;
alter table public.company_memberships enable row level security;

revoke all privileges on table public.maintenance_companies from anon, authenticated;
revoke all privileges on table public.platform_users from anon, authenticated;
revoke all privileges on table public.platform_user_auth_subjects from anon, authenticated;
revoke all privileges on table public.company_memberships from anon, authenticated;

grant select on table public.maintenance_companies to authenticated;
grant select on table public.platform_users to authenticated;
grant select on table public.platform_user_auth_subjects to authenticated;
grant select on table public.company_memberships to authenticated;

create policy "task_009_read_own_auth_subject_mapping"
on public.platform_user_auth_subjects
for select
to authenticated
using (
  (select auth.uid()) is not null
  and auth_subject_id = (select auth.uid())
);

create policy "task_009_read_own_platform_user"
on public.platform_users
for select
to authenticated
using (
  (select auth.uid()) is not null
  and exists (
    select 1
    from public.platform_user_auth_subjects as auth_subject
    where auth_subject.auth_subject_id = (select auth.uid())
      and auth_subject.platform_user_id = platform_users.id
  )
);

create policy "task_009_read_own_enabled_membership"
on public.company_memberships
for select
to authenticated
using (
  is_enabled
  and (select auth.uid()) is not null
  and exists (
    select 1
    from public.platform_user_auth_subjects as auth_subject
    where auth_subject.auth_subject_id = (select auth.uid())
      and auth_subject.platform_user_id = company_memberships.platform_user_id
  )
);

create policy "task_009_read_own_maintenance_company"
on public.maintenance_companies
for select
to authenticated
using (
  (select auth.uid()) is not null
  and exists (
    select 1
    from public.company_memberships as membership
    join public.platform_user_auth_subjects as auth_subject
      on auth_subject.platform_user_id = membership.platform_user_id
    where membership.maintenance_company_id = maintenance_companies.id
      and membership.is_enabled
      and auth_subject.auth_subject_id = (select auth.uid())
  )
);
