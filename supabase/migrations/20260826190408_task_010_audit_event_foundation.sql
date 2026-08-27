create table public.audit_events (
  id uuid primary key,
  maintenance_company_id uuid not null,
  actor_kind text not null,
  actor_platform_user_id uuid,
  actor_internal_process_key text,
  action text not null,
  occurred_at timestamptz not null default now(),
  scope_kind text not null,
  subject_platform_user_id uuid not null,
  role_before text,
  role_after text,
  constraint audit_events_maintenance_company_id_fkey
    foreign key (maintenance_company_id)
    references public.maintenance_companies (id)
    on delete restrict,
  constraint audit_events_actor_platform_user_id_fkey
    foreign key (actor_platform_user_id)
    references public.platform_users (id)
    on delete restrict,
  constraint audit_events_subject_platform_user_id_fkey
    foreign key (subject_platform_user_id)
    references public.platform_users (id)
    on delete restrict,
  constraint audit_events_actor_kind_check
    check (actor_kind in ('PLATFORM_USER', 'INTERNAL_PROCESS')),
  constraint audit_events_actor_representation_check
    check (
      (
        actor_kind = 'PLATFORM_USER'
        and actor_platform_user_id is not null
        and actor_internal_process_key is null
      )
      or
      (
        actor_kind = 'INTERNAL_PROCESS'
        and actor_platform_user_id is null
        and actor_internal_process_key is not null
        and btrim(actor_internal_process_key) <> ''
      )
    ),
  constraint audit_events_action_check
    check (
      action in (
        'USER_CREATED',
        'USER_DISABLED_OR_REVOKED',
        'USER_REINSTATED',
        'USER_ROLE_CHANGED'
      )
    ),
  constraint audit_events_scope_kind_check
    check (scope_kind = 'USER'),
  constraint audit_events_action_scope_check
    check (
      action in (
        'USER_CREATED',
        'USER_DISABLED_OR_REVOKED',
        'USER_REINSTATED',
        'USER_ROLE_CHANGED'
      )
      and scope_kind = 'USER'
    ),
  constraint audit_events_role_snapshot_check
    check (
      (
        action = 'USER_ROLE_CHANGED'
        and role_before is not null
        and role_after is not null
        and role_before in ('COMPANY_ADMIN', 'TECHNICIAN')
        and role_after in ('COMPANY_ADMIN', 'TECHNICIAN')
        and role_before <> role_after
      )
      or
      (
        action in (
          'USER_CREATED',
          'USER_DISABLED_OR_REVOKED',
          'USER_REINSTATED'
        )
        and role_before is null
        and role_after is null
      )
    )
);

alter table public.audit_events enable row level security;

revoke all privileges on table public.audit_events from anon, authenticated;
