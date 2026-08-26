\set ON_ERROR_STOP on

\if :{?task_009_user_a_id}
\else
  \echo 'Missing psql variable: task_009_user_a_id'
  \quit 2
\endif

\if :{?task_009_user_b_id}
\else
  \echo 'Missing psql variable: task_009_user_b_id'
  \quit 2
\endif

\if :{?task_009_user_c_id}
\else
  \echo 'Missing psql variable: task_009_user_c_id'
  \quit 2
\endif

begin;

-- Every privileged mutation in this file is isolated Development test setup or
-- test teardown. It implements no product flow and satisfies no AuditEvent duty.
-- Future functional create, disable/revoke, reinstate, role-change, and
-- client-scope-change flows still require their corresponding AuditEvent.

select count(*) = 3 and count(distinct id) = 3 as task_009_auth_fixtures_valid
from auth.users
where id in (
  :'task_009_user_a_id'::uuid,
  :'task_009_user_b_id'::uuid,
  :'task_009_user_c_id'::uuid
)
\gset

\if :task_009_auth_fixtures_valid
\else
  \echo 'Expected three distinct disposable Auth subjects in Development.'
  \quit 3
\endif

insert into public.maintenance_companies (id)
values
  ('00000000-0000-4000-8000-00000000c001'),
  ('00000000-0000-4000-8000-00000000c002');

insert into public.platform_users (id)
values
  ('00000000-0000-4000-8000-00000000a001'),
  ('00000000-0000-4000-8000-00000000b001'),
  ('00000000-0000-4000-8000-00000000c001');

insert into public.platform_user_auth_subjects (
  auth_subject_id,
  platform_user_id
)
values
  (
    :'task_009_user_a_id'::uuid,
    '00000000-0000-4000-8000-00000000a001'
  ),
  (
    :'task_009_user_b_id'::uuid,
    '00000000-0000-4000-8000-00000000b001'
  ),
  (
    :'task_009_user_c_id'::uuid,
    '00000000-0000-4000-8000-00000000c001'
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
    '00000000-0000-4000-8000-00000000a002',
    '00000000-0000-4000-8000-00000000a001',
    '00000000-0000-4000-8000-00000000c001',
    'COMPANY_ADMIN',
    true
  ),
  (
    '00000000-0000-4000-8000-00000000b002',
    '00000000-0000-4000-8000-00000000b001',
    '00000000-0000-4000-8000-00000000c002',
    'TECHNICIAN',
    true
  );

-- Make the psql value available to the anonymous integrity blocks only.
select set_config('task_009.user_a_id', :'task_009_user_a_id', true);

-- T009-DB-001: an Auth subject cannot map to two PlatformUsers.
do $$
begin
  begin
    insert into public.platform_user_auth_subjects (
      auth_subject_id,
      platform_user_id
    )
    values (
      current_setting('task_009.user_a_id')::uuid,
      '00000000-0000-4000-8000-00000000b001'
    );
    raise exception 'T009-DB-001 expected unique_violation';
  exception
    when unique_violation then null;
  end;
end
$$;

-- T009-DB-002: the inverse PlatformUser cardinality remains intentionally open.
do $$
begin
  if exists (
    select 1
    from pg_constraint as constraint_definition
    join pg_attribute as constrained_column
      on constrained_column.attrelid = constraint_definition.conrelid
     and constrained_column.attnum = any (constraint_definition.conkey)
    where constraint_definition.conrelid =
      'public.platform_user_auth_subjects'::regclass
      and constraint_definition.contype in ('p', 'u')
      and constrained_column.attname = 'platform_user_id'
  ) then
    raise exception 'T009-DB-002 inverse uniqueness must remain absent';
  end if;
end
$$;

-- T009-DB-003: a PlatformUser cannot have two memberships.
do $$
begin
  begin
    insert into public.company_memberships (
      id,
      platform_user_id,
      maintenance_company_id,
      role,
      is_enabled
    )
    values (
      '00000000-0000-4000-8000-00000000a003',
      '00000000-0000-4000-8000-00000000a001',
      '00000000-0000-4000-8000-00000000c002',
      'TECHNICIAN',
      true
    );
    raise exception 'T009-DB-003 expected unique_violation';
  exception
    when unique_violation then null;
  end;
end
$$;

-- T009-DB-004: a membership cannot reference a nonexistent tenant.
do $$
begin
  begin
    insert into public.company_memberships (
      id,
      platform_user_id,
      maintenance_company_id,
      role,
      is_enabled
    )
    values (
      '00000000-0000-4000-8000-00000000c002',
      '00000000-0000-4000-8000-00000000c001',
      '00000000-0000-4000-8000-00000000ffff',
      'TECHNICIAN',
      true
    );
    raise exception 'T009-DB-004 expected foreign_key_violation';
  exception
    when foreign_key_violation then null;
  end;
end
$$;

-- T009-DB-005: a membership cannot reference a nonexistent PlatformUser.
do $$
begin
  begin
    insert into public.company_memberships (
      id,
      platform_user_id,
      maintenance_company_id,
      role,
      is_enabled
    )
    values (
      '00000000-0000-4000-8000-00000000c003',
      '00000000-0000-4000-8000-00000000ffff',
      '00000000-0000-4000-8000-00000000c001',
      'TECHNICIAN',
      true
    );
    raise exception 'T009-DB-005 expected foreign_key_violation';
  exception
    when foreign_key_violation then null;
  end;
end
$$;

-- T009-DB-006: SUPER_ADMIN and UNKNOWN are not tenant roles.
do $$
declare
  invalid_role text;
begin
  foreach invalid_role in array array['SUPER_ADMIN', 'UNKNOWN']
  loop
    begin
      insert into public.company_memberships (
        id,
        platform_user_id,
        maintenance_company_id,
        role,
        is_enabled
      )
      values (
        '00000000-0000-4000-8000-00000000e001',
        '00000000-0000-4000-8000-00000000c001',
        '00000000-0000-4000-8000-00000000c001',
        invalid_role,
        true
      );
      raise exception 'T009-DB-006 expected check_violation for %', invalid_role;
    exception
      when check_violation then null;
    end;
  end loop;
end
$$;

-- T009-DB-007: a nonexistent Auth subject is rejected by the FK.
do $$
begin
  begin
    insert into public.platform_user_auth_subjects (
      auth_subject_id,
      platform_user_id
    )
    values (
      '00000000-0000-4000-8000-00000000ffff',
      '00000000-0000-4000-8000-00000000c001'
    );
    raise exception 'T009-DB-007 expected foreign_key_violation';
  exception
    when foreign_key_violation then null;
  end;
end
$$;

-- T009-RLS-001 through T009-RLS-009: own identity and own tenant only.
set local role authenticated;
select set_config('request.jwt.claim.sub', :'task_009_user_a_id', true);

do $$
begin
  if (select count(*) from public.platform_user_auth_subjects) <> 1 then
    raise exception 'T009-RLS-001/002 expected only the current mapping';
  end if;
  if (select count(*) from public.platform_users) <> 1 then
    raise exception 'T009-RLS-003/004 expected only the current PlatformUser';
  end if;
  if (select count(*) from public.company_memberships) <> 1 then
    raise exception 'T009-RLS-005/006 expected only the current enabled membership';
  end if;
  if (select count(*) from public.maintenance_companies) <> 1 then
    raise exception 'T009-RLS-007/008 expected only the current tenant';
  end if;
  if exists (
    select 1
    from public.maintenance_companies
    where id = '00000000-0000-4000-8000-00000000c002'
  ) then
    raise exception 'T009-RLS-008 known foreign tenant UUID became authority';
  end if;
  if exists (
    select 1
    from public.company_memberships
    where maintenance_company_id =
      '00000000-0000-4000-8000-00000000c002'
  ) then
    raise exception 'T009-RLS-009 tenant filter became authority';
  end if;
end
$$;

-- T009-RLS-014/015/016: real write attempts fail for authenticated.
do $$
begin
  begin
    insert into public.maintenance_companies (id)
    values ('00000000-0000-4000-8000-00000000d001');
    raise exception 'authenticated INSERT maintenance_companies was allowed';
  exception when insufficient_privilege then null;
  end;
  begin
    insert into public.platform_users (id)
    values ('00000000-0000-4000-8000-00000000d002');
    raise exception 'authenticated INSERT platform_users was allowed';
  exception when insufficient_privilege then null;
  end;
  begin
    insert into public.platform_user_auth_subjects (
      auth_subject_id,
      platform_user_id
    )
    values (
      current_setting('request.jwt.claim.sub')::uuid,
      '00000000-0000-4000-8000-00000000a001'
    );
    raise exception 'authenticated INSERT mapping was allowed';
  exception when insufficient_privilege then null;
  end;
  begin
    insert into public.company_memberships (
      id,
      platform_user_id,
      maintenance_company_id,
      role,
      is_enabled
    )
    values (
      '00000000-0000-4000-8000-00000000d003',
      '00000000-0000-4000-8000-00000000c001',
      '00000000-0000-4000-8000-00000000c001',
      'TECHNICIAN',
      true
    );
    raise exception 'authenticated INSERT membership was allowed';
  exception when insufficient_privilege then null;
  end;

  begin
    update public.maintenance_companies
    set id = id
    where id = '00000000-0000-4000-8000-00000000c001';
    raise exception 'authenticated UPDATE maintenance_companies was allowed';
  exception when insufficient_privilege then null;
  end;
  begin
    update public.platform_users
    set id = id
    where id = '00000000-0000-4000-8000-00000000a001';
    raise exception 'authenticated UPDATE platform_users was allowed';
  exception when insufficient_privilege then null;
  end;
  begin
    update public.platform_user_auth_subjects
    set platform_user_id = platform_user_id
    where auth_subject_id = current_setting('request.jwt.claim.sub')::uuid;
    raise exception 'authenticated UPDATE mapping was allowed';
  exception when insufficient_privilege then null;
  end;
  begin
    update public.company_memberships
    set role = 'TECHNICIAN', is_enabled = false
    where id = '00000000-0000-4000-8000-00000000a002';
    raise exception 'authenticated UPDATE membership was allowed';
  exception when insufficient_privilege then null;
  end;

  begin
    delete from public.maintenance_companies
    where id = '00000000-0000-4000-8000-00000000c001';
    raise exception 'authenticated DELETE maintenance_companies was allowed';
  exception when insufficient_privilege then null;
  end;
  begin
    delete from public.platform_users
    where id = '00000000-0000-4000-8000-00000000a001';
    raise exception 'authenticated DELETE platform_users was allowed';
  exception when insufficient_privilege then null;
  end;
  begin
    delete from public.platform_user_auth_subjects
    where auth_subject_id = current_setting('request.jwt.claim.sub')::uuid;
    raise exception 'authenticated DELETE mapping was allowed';
  exception when insufficient_privilege then null;
  end;
  begin
    delete from public.company_memberships
    where id = '00000000-0000-4000-8000-00000000a002';
    raise exception 'authenticated DELETE membership was allowed';
  exception when insufficient_privilege then null;
  end;
end
$$;

-- T009-RLS-010/011: the same Auth subject loses tenant access immediately.
reset role;
update public.company_memberships
set is_enabled = false
where id = '00000000-0000-4000-8000-00000000a002';

set local role authenticated;
select set_config('request.jwt.claim.sub', :'task_009_user_a_id', true);

do $$
begin
  if exists (select 1 from public.company_memberships) then
    raise exception 'T009-RLS-010 disabled membership remained visible';
  end if;
  if exists (select 1 from public.maintenance_companies) then
    raise exception 'T009-RLS-011 tenant access survived authoritative disable';
  end if;
end
$$;

-- T009-RLS-012: a stale custom role claim cannot override current DB state.
reset role;
update public.company_memberships
set role = 'TECHNICIAN', is_enabled = true
where id = '00000000-0000-4000-8000-00000000a002';

set local role authenticated;
select set_config('request.jwt.claim.sub', :'task_009_user_a_id', true);
select set_config('request.jwt.claim.tenant_role', 'COMPANY_ADMIN', true);

do $$
begin
  if (
    select role
    from public.company_memberships
    where id = '00000000-0000-4000-8000-00000000a002'
  ) <> 'TECHNICIAN' then
    raise exception 'T009-RLS-012 current DB role was not authoritative';
  end if;
end
$$;

-- T009-RLS-013: a recognized subject with no membership fails closed.
select set_config('request.jwt.claim.sub', :'task_009_user_c_id', true);

do $$
begin
  if exists (select 1 from public.maintenance_companies) then
    raise exception 'T009-RLS-013 subject without membership gained tenant access';
  end if;
end
$$;

reset role;
rollback;

\echo 'TASK-009 transactional integrity and RLS suite: PASS'
