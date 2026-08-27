\set ON_ERROR_STOP on

\if :{?task_010_user_a_id}
\else
  \echo 'Missing psql variable: task_010_user_a_id'
  \quit 2
\endif

\if :{?task_010_user_b_id}
\else
  \echo 'Missing psql variable: task_010_user_b_id'
  \quit 2
\endif

\if :{?task_010_user_c_id}
\else
  \echo 'Missing psql variable: task_010_user_c_id'
  \quit 2
\endif

\if :{?task_010_user_d_id}
\else
  \echo 'Missing psql variable: task_010_user_d_id'
  \quit 2
\endif

begin;

-- All mutations in this file are disposable Development test setup or teardown.
-- They implement no product flow and use no real customer data.

select count(*) = 4 and count(distinct id) = 4 as task_010_auth_fixtures_valid
from auth.users
where id in (
  :'task_010_user_a_id'::uuid,
  :'task_010_user_b_id'::uuid,
  :'task_010_user_c_id'::uuid,
  :'task_010_user_d_id'::uuid
)
\gset

\if :task_010_auth_fixtures_valid
\else
  \echo 'Expected four distinct disposable Auth subjects in Development.'
  \quit 3
\endif

insert into public.maintenance_companies (id)
values
  ('00000000-0000-4000-8000-000000010101'),
  ('00000000-0000-4000-8000-000000010102'),
  ('00000000-0000-4000-8000-000000010103');

insert into public.platform_users (id)
values
  ('00000000-0000-4000-8000-000000010201'),
  ('00000000-0000-4000-8000-000000010202'),
  ('00000000-0000-4000-8000-000000010203'),
  ('00000000-0000-4000-8000-000000010204'),
  ('00000000-0000-4000-8000-000000010205');

insert into public.platform_user_auth_subjects (
  auth_subject_id,
  platform_user_id
)
values
  (
    :'task_010_user_a_id'::uuid,
    '00000000-0000-4000-8000-000000010201'
  ),
  (
    :'task_010_user_b_id'::uuid,
    '00000000-0000-4000-8000-000000010202'
  ),
  (
    :'task_010_user_c_id'::uuid,
    '00000000-0000-4000-8000-000000010203'
  ),
  (
    :'task_010_user_d_id'::uuid,
    '00000000-0000-4000-8000-000000010204'
  );

insert into public.company_memberships (
  id,
  platform_user_id,
  maintenance_company_id,
  role,
  is_enabled
)
values
  (
    '00000000-0000-4000-8000-000000010301',
    '00000000-0000-4000-8000-000000010201',
    '00000000-0000-4000-8000-000000010101',
    'COMPANY_ADMIN',
    true
  ),
  (
    '00000000-0000-4000-8000-000000010302',
    '00000000-0000-4000-8000-000000010202',
    '00000000-0000-4000-8000-000000010102',
    'TECHNICIAN',
    true
  ),
  (
    '00000000-0000-4000-8000-000000010303',
    '00000000-0000-4000-8000-000000010203',
    '00000000-0000-4000-8000-000000010101',
    'TECHNICIAN',
    false
  );

insert into public.audit_events (
  id,
  maintenance_company_id,
  actor_kind,
  actor_platform_user_id,
  action,
  scope_kind,
  subject_platform_user_id
)
values (
  '00000000-0000-4000-8000-000000010401',
  '00000000-0000-4000-8000-000000010101',
  'PLATFORM_USER',
  '00000000-0000-4000-8000-000000010201',
  'USER_CREATED',
  'USER',
  '00000000-0000-4000-8000-000000010202'
);

insert into public.audit_events (
  id,
  maintenance_company_id,
  actor_kind,
  actor_internal_process_key,
  action,
  scope_kind,
  subject_platform_user_id
)
values (
  '00000000-0000-4000-8000-000000010402',
  '00000000-0000-4000-8000-000000010102',
  'INTERNAL_PROCESS',
  'task-010-test-worker',
  'USER_REINSTATED',
  'USER',
  '00000000-0000-4000-8000-000000010203'
);

insert into public.audit_events (
  id,
  maintenance_company_id,
  actor_kind,
  actor_platform_user_id,
  action,
  scope_kind,
  subject_platform_user_id
)
values (
  '00000000-0000-4000-8000-000000010403',
  '00000000-0000-4000-8000-000000010101',
  'PLATFORM_USER',
  '00000000-0000-4000-8000-000000010205',
  'USER_DISABLED_OR_REVOKED',
  'USER',
  '00000000-0000-4000-8000-000000010202'
);

insert into public.audit_events (
  id,
  maintenance_company_id,
  actor_kind,
  actor_internal_process_key,
  action,
  scope_kind,
  subject_platform_user_id
)
values (
  '00000000-0000-4000-8000-000000010404',
  '00000000-0000-4000-8000-000000010103',
  'INTERNAL_PROCESS',
  'task-010-fk-test-worker',
  'USER_REINSTATED',
  'USER',
  '00000000-0000-4000-8000-000000010203'
);

-- T010-DB-001: a nonexistent tenant is rejected.
do $$
begin
  begin
    insert into public.audit_events (
      id,
      maintenance_company_id,
      actor_kind,
      actor_platform_user_id,
      action,
      scope_kind,
      subject_platform_user_id
    ) values (
      '00000000-0000-4000-8000-000000010411',
      '00000000-0000-4000-8000-00000001ffff',
      'PLATFORM_USER',
      '00000000-0000-4000-8000-000000010201',
      'USER_CREATED',
      'USER',
      '00000000-0000-4000-8000-000000010202'
    );
    raise exception 'T010-DB-001 expected foreign_key_violation';
  exception when foreign_key_violation then null;
  end;
end
$$;

-- T010-DB-002: a referenced tenant is protected by ON DELETE RESTRICT.
do $$
begin
  begin
    delete from public.maintenance_companies
    where id = '00000000-0000-4000-8000-000000010103';
    raise exception 'T010-DB-002 expected foreign_key_violation';
  exception when foreign_key_violation then null;
  end;
end
$$;

-- T010-DB-003 is represented by the valid PLATFORM_USER fixture above.

-- T010-DB-004: a nonexistent PlatformUser actor is rejected.
do $$
begin
  begin
    insert into public.audit_events (
      id,
      maintenance_company_id,
      actor_kind,
      actor_platform_user_id,
      action,
      scope_kind,
      subject_platform_user_id
    ) values (
      '00000000-0000-4000-8000-000000010412',
      '00000000-0000-4000-8000-000000010101',
      'PLATFORM_USER',
      '00000000-0000-4000-8000-00000001ffff',
      'USER_CREATED',
      'USER',
      '00000000-0000-4000-8000-000000010202'
    );
    raise exception 'T010-DB-004 expected foreign_key_violation';
  exception when foreign_key_violation then null;
  end;
end
$$;

-- T010-DB-005: PLATFORM_USER requires actor_platform_user_id.
do $$
begin
  begin
    insert into public.audit_events (
      id,
      maintenance_company_id,
      actor_kind,
      action,
      scope_kind,
      subject_platform_user_id
    ) values (
      '00000000-0000-4000-8000-000000010413',
      '00000000-0000-4000-8000-000000010101',
      'PLATFORM_USER',
      'USER_CREATED',
      'USER',
      '00000000-0000-4000-8000-000000010202'
    );
    raise exception 'T010-DB-005 expected check_violation';
  exception when check_violation then null;
  end;
end
$$;

-- T010-DB-006: INTERNAL_PROCESS requires a nonempty key.
do $$
declare
  invalid_key text;
begin
  foreach invalid_key in array array[null::text, '', '   ']
  loop
    begin
      insert into public.audit_events (
        id,
        maintenance_company_id,
        actor_kind,
        actor_internal_process_key,
        action,
        scope_kind,
        subject_platform_user_id
      ) values (
        gen_random_uuid(),
        '00000000-0000-4000-8000-000000010101',
        'INTERNAL_PROCESS',
        invalid_key,
        'USER_CREATED',
        'USER',
        '00000000-0000-4000-8000-000000010202'
      );
      raise exception 'T010-DB-006 expected check_violation';
    exception when check_violation then null;
    end;
  end loop;
end
$$;

-- T010-DB-007: both actor representations together are rejected.
do $$
begin
  begin
    insert into public.audit_events (
      id,
      maintenance_company_id,
      actor_kind,
      actor_platform_user_id,
      actor_internal_process_key,
      action,
      scope_kind,
      subject_platform_user_id
    ) values (
      '00000000-0000-4000-8000-000000010414',
      '00000000-0000-4000-8000-000000010101',
      'PLATFORM_USER',
      '00000000-0000-4000-8000-000000010201',
      'invalid-second-representation',
      'USER_CREATED',
      'USER',
      '00000000-0000-4000-8000-000000010202'
    );
    raise exception 'T010-DB-007 expected check_violation';
  exception when check_violation then null;
  end;
end
$$;

-- T010-DB-008: a referenced actor is protected by ON DELETE RESTRICT.
do $$
begin
  begin
    delete from public.platform_users
    where id = '00000000-0000-4000-8000-000000010205';
    raise exception 'T010-DB-008 expected foreign_key_violation';
  exception when foreign_key_violation then null;
  end;
end
$$;

-- T010-DB-009: arbitrary actions are rejected.
do $$
begin
  begin
    insert into public.audit_events (
      id,
      maintenance_company_id,
      actor_kind,
      actor_platform_user_id,
      action,
      scope_kind,
      subject_platform_user_id
    ) values (
      '00000000-0000-4000-8000-000000010415',
      '00000000-0000-4000-8000-000000010101',
      'PLATFORM_USER',
      '00000000-0000-4000-8000-000000010201',
      'ARBITRARY_ACTION',
      'USER',
      '00000000-0000-4000-8000-000000010202'
    );
    raise exception 'T010-DB-009 expected check_violation';
  exception when check_violation then null;
  end;
end
$$;

-- T010-DB-010: all five future actions remain physically rejected.
do $$
declare
  future_action text;
begin
  foreach future_action in array array[
    'USER_CLIENT_ACCESS_CHANGED',
    'SUPPORT_ACCESS_GRANTED',
    'SUPPORT_ACCESS_SCOPE_CHANGED',
    'SUPPORT_ACCESS_REVOKED',
    'SUPPORT_ACCESS_USED'
  ]
  loop
    begin
      insert into public.audit_events (
        id,
        maintenance_company_id,
        actor_kind,
        actor_platform_user_id,
        action,
        scope_kind,
        subject_platform_user_id
      ) values (
        gen_random_uuid(),
        '00000000-0000-4000-8000-000000010101',
        'PLATFORM_USER',
        '00000000-0000-4000-8000-000000010201',
        future_action,
        'USER',
        '00000000-0000-4000-8000-000000010202'
      );
      raise exception 'T010-DB-010 expected check_violation for %', future_action;
    exception when check_violation then null;
    end;
  end loop;
end
$$;

-- T010-DB-011/012: unsupported scopes and action/scope combinations fail.
do $$
declare
  invalid_scope text;
begin
  foreach invalid_scope in array array['SUPPORT_GRANT', 'USER_CLIENT_ACCESS']
  loop
    begin
      insert into public.audit_events (
        id,
        maintenance_company_id,
        actor_kind,
        actor_platform_user_id,
        action,
        scope_kind,
        subject_platform_user_id
      ) values (
        gen_random_uuid(),
        '00000000-0000-4000-8000-000000010101',
        'PLATFORM_USER',
        '00000000-0000-4000-8000-000000010201',
        'USER_REINSTATED',
        invalid_scope,
        '00000000-0000-4000-8000-000000010202'
      );
      raise exception 'T010-DB-011/012 expected check_violation';
    exception when check_violation then null;
    end;
  end loop;
end
$$;

-- T010-DB-013: subject is mandatory.
do $$
begin
  begin
    insert into public.audit_events (
      id,
      maintenance_company_id,
      actor_kind,
      actor_platform_user_id,
      action,
      scope_kind
    ) values (
      '00000000-0000-4000-8000-000000010416',
      '00000000-0000-4000-8000-000000010101',
      'PLATFORM_USER',
      '00000000-0000-4000-8000-000000010201',
      'USER_CREATED',
      'USER'
    );
    raise exception 'T010-DB-013 expected not_null_violation';
  exception when not_null_violation then null;
  end;
end
$$;

-- T010-DB-014: subject must reference an existing PlatformUser.
do $$
begin
  begin
    insert into public.audit_events (
      id,
      maintenance_company_id,
      actor_kind,
      actor_platform_user_id,
      action,
      scope_kind,
      subject_platform_user_id
    ) values (
      '00000000-0000-4000-8000-000000010417',
      '00000000-0000-4000-8000-000000010101',
      'PLATFORM_USER',
      '00000000-0000-4000-8000-000000010201',
      'USER_CREATED',
      'USER',
      '00000000-0000-4000-8000-00000001ffff'
    );
    raise exception 'T010-DB-014 expected foreign_key_violation';
  exception when foreign_key_violation then null;
  end;
end
$$;

-- T010-DB-015: a valid role change is accepted.
insert into public.audit_events (
  id,
  maintenance_company_id,
  actor_kind,
  actor_platform_user_id,
  action,
  scope_kind,
  subject_platform_user_id,
  role_before,
  role_after
)
values (
  '00000000-0000-4000-8000-000000010418',
  '00000000-0000-4000-8000-000000010101',
  'PLATFORM_USER',
  '00000000-0000-4000-8000-000000010201',
  'USER_ROLE_CHANGED',
  'USER',
  '00000000-0000-4000-8000-000000010202',
  'TECHNICIAN',
  'COMPANY_ADMIN'
);

-- T010-DB-016/017/018: null, invalid, equal, or misplaced role snapshots fail.
do $$
declare
  test_case record;
begin
  for test_case in
    select *
    from (
      values
        ('USER_ROLE_CHANGED', null::text, 'TECHNICIAN'),
        ('USER_ROLE_CHANGED', 'TECHNICIAN', null::text),
        ('USER_ROLE_CHANGED', 'UNKNOWN', 'TECHNICIAN'),
        ('USER_ROLE_CHANGED', 'TECHNICIAN', 'TECHNICIAN'),
        ('USER_CREATED', 'TECHNICIAN', 'COMPANY_ADMIN')
    ) as cases(action, role_before, role_after)
  loop
    begin
      insert into public.audit_events (
        id,
        maintenance_company_id,
        actor_kind,
        actor_platform_user_id,
        action,
        scope_kind,
        subject_platform_user_id,
        role_before,
        role_after
      ) values (
        gen_random_uuid(),
        '00000000-0000-4000-8000-000000010101',
        'PLATFORM_USER',
        '00000000-0000-4000-8000-000000010201',
        test_case.action,
        'USER',
        '00000000-0000-4000-8000-000000010202',
        test_case.role_before,
        test_case.role_after
      );
      raise exception 'T010-DB-016/017/018 expected check_violation';
    exception when check_violation then null;
    end;
  end loop;
end
$$;

-- T010-DB-019: duplicate event identity is rejected.
do $$
begin
  begin
    insert into public.audit_events (
      id,
      maintenance_company_id,
      actor_kind,
      actor_platform_user_id,
      action,
      scope_kind,
      subject_platform_user_id
    ) values (
      '00000000-0000-4000-8000-000000010401',
      '00000000-0000-4000-8000-000000010101',
      'PLATFORM_USER',
      '00000000-0000-4000-8000-000000010201',
      'USER_CREATED',
      'USER',
      '00000000-0000-4000-8000-000000010202'
    );
    raise exception 'T010-DB-019 expected unique_violation';
  exception when unique_violation then null;
  end;
end
$$;

-- T010-DB-020/021: omitted occurred_at receives the PostgreSQL default.
do $$
begin
  if (
    select occurred_at
    from public.audit_events
    where id = '00000000-0000-4000-8000-000000010401'
  ) is null then
    raise exception 'T010-DB-020 expected PostgreSQL occurred_at default';
  end if;
end
$$;

-- The default is not asserted to be non-overridable for privileged writers.

-- RLS and exhaustive table-privilege state are inspected as administrator.
do $$
declare
  checked_role text;
  checked_privilege text;
begin
  if not (
    select relrowsecurity
    from pg_class
    where oid = 'public.audit_events'::regclass
  ) then
    raise exception 'TASK-010 expected RLS enabled';
  end if;

  if (
    select count(*)
    from pg_policy
    where polrelid = 'public.audit_events'::regclass
  ) <> 0 then
    raise exception 'TASK-010 expected zero policies';
  end if;

  foreach checked_role in array array['anon', 'authenticated']
  loop
    foreach checked_privilege in array array[
      'SELECT',
      'INSERT',
      'UPDATE',
      'DELETE',
      'TRUNCATE',
      'REFERENCES',
      'TRIGGER'
    ]
    loop
      if has_table_privilege(
        checked_role,
        'public.audit_events',
        checked_privilege
      ) then
        raise exception 'Unexpected % privilege for %', checked_privilege, checked_role;
      end if;
    end loop;
  end loop;
end
$$;

-- T010-RLS-001 through T010-RLS-010: authenticated operations are actually
-- rejected for COMPANY_ADMIN, cross-tenant known IDs, forged tenant IDs,
-- disabled membership, and recognized identity without membership.
set local role authenticated;
select set_config('request.jwt.claim.sub', :'task_010_user_a_id', true);

do $$
begin
  begin
    perform 1
    from public.audit_events
    where id = '00000000-0000-4000-8000-000000010402';
    raise exception 'authenticated SELECT/cross-tenant known-ID was allowed';
  exception when insufficient_privilege then null;
  end;

  begin
    insert into public.audit_events (
      id,
      maintenance_company_id,
      actor_kind,
      actor_platform_user_id,
      action,
      scope_kind,
      subject_platform_user_id
    ) values (
      '00000000-0000-4000-8000-000000010421',
      '00000000-0000-4000-8000-000000010101',
      'PLATFORM_USER',
      '00000000-0000-4000-8000-000000010201',
      'USER_CREATED',
      'USER',
      '00000000-0000-4000-8000-000000010202'
    );
    raise exception 'authenticated INSERT was allowed';
  exception when insufficient_privilege then null;
  end;

  begin
    insert into public.audit_events (
      id,
      maintenance_company_id,
      actor_kind,
      actor_platform_user_id,
      action,
      scope_kind,
      subject_platform_user_id
    ) values (
      '00000000-0000-4000-8000-000000010422',
      '00000000-0000-4000-8000-000000010102',
      'PLATFORM_USER',
      '00000000-0000-4000-8000-000000010201',
      'USER_CREATED',
      'USER',
      '00000000-0000-4000-8000-000000010202'
    );
    raise exception 'forged tenant INSERT was allowed';
  exception when insufficient_privilege then null;
  end;

  begin
    update public.audit_events
    set action = 'USER_REINSTATED'
    where id = '00000000-0000-4000-8000-000000010401';
    raise exception 'authenticated UPDATE was allowed';
  exception when insufficient_privilege then null;
  end;

  begin
    delete from public.audit_events
    where id = '00000000-0000-4000-8000-000000010401';
    raise exception 'authenticated DELETE was allowed';
  exception when insufficient_privilege then null;
  end;

  begin
    truncate table public.audit_events;
    raise exception 'authenticated TRUNCATE was allowed';
  exception when insufficient_privilege then null;
  end;
end
$$;

-- The reverse direction uses User B and the known, existing AuditEvent A.
select set_config('request.jwt.claim.sub', :'task_010_user_b_id', true);

do $$
begin
  begin
    perform 1
    from public.audit_events
    where id = '00000000-0000-4000-8000-000000010401';
    raise exception 'authenticated SELECT/reverse cross-tenant known-ID was allowed';
  exception when insufficient_privilege then null;
  end;
end
$$;

-- A disabled membership gains no capability.
select set_config('request.jwt.claim.sub', :'task_010_user_c_id', true);

do $$
begin
  begin
    perform 1 from public.audit_events;
    raise exception 'disabled membership SELECT was allowed';
  exception when insufficient_privilege then null;
  end;
end
$$;

-- A recognized identity with no membership gains no capability.
select set_config('request.jwt.claim.sub', :'task_010_user_d_id', true);

do $$
begin
  begin
    perform 1 from public.audit_events;
    raise exception 'identity without membership SELECT was allowed';
  exception when insufficient_privilege then null;
  end;
end
$$;

reset role;
rollback;

-- Every TASK-010 domain fixture was transaction-local and is now absent.
do $$
begin
  if exists (
    select 1
    from public.audit_events
    where id in (
      '00000000-0000-4000-8000-000000010401',
      '00000000-0000-4000-8000-000000010402',
      '00000000-0000-4000-8000-000000010403',
      '00000000-0000-4000-8000-000000010404',
      '00000000-0000-4000-8000-000000010418'
    )
  ) then
    raise exception 'TASK-010 audit event fixtures remain after rollback';
  end if;

  if exists (
    select 1
    from public.maintenance_companies
    where id in (
      '00000000-0000-4000-8000-000000010101',
      '00000000-0000-4000-8000-000000010102',
      '00000000-0000-4000-8000-000000010103'
    )
  ) then
    raise exception 'TASK-010 tenant fixtures remain after rollback';
  end if;

  if exists (
    select 1
    from public.platform_users
    where id in (
      '00000000-0000-4000-8000-000000010201',
      '00000000-0000-4000-8000-000000010202',
      '00000000-0000-4000-8000-000000010203',
      '00000000-0000-4000-8000-000000010204',
      '00000000-0000-4000-8000-000000010205'
    )
  ) then
    raise exception 'TASK-010 PlatformUser fixtures remain after rollback';
  end if;

  if exists (
    select 1
    from public.platform_user_auth_subjects
    where platform_user_id in (
      '00000000-0000-4000-8000-000000010201',
      '00000000-0000-4000-8000-000000010202',
      '00000000-0000-4000-8000-000000010203',
      '00000000-0000-4000-8000-000000010204'
    )
  ) then
    raise exception 'TASK-010 Auth mapping fixtures remain after rollback';
  end if;

  if exists (
    select 1
    from public.company_memberships
    where id in (
      '00000000-0000-4000-8000-000000010301',
      '00000000-0000-4000-8000-000000010302',
      '00000000-0000-4000-8000-000000010303'
    )
  ) then
    raise exception 'TASK-010 membership fixtures remain after rollback';
  end if;
end
$$;

\echo 'TASK-010 transactional integrity, RLS, privilege, and cleanup suite: PASS'
