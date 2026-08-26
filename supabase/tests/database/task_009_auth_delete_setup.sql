\set ON_ERROR_STOP on

\if :{?task_009_delete_subject_id}
\else
  \echo 'Missing psql variable: task_009_delete_subject_id'
  \quit 2
\endif

begin;

-- This disposable Development-only fixture is test setup, not a product flow.
-- It does not satisfy or remove any future AuditEvent obligation.

select count(*) = 1 as task_009_delete_subject_valid
from auth.users
where id = :'task_009_delete_subject_id'::uuid
\gset

\if :task_009_delete_subject_valid
\else
  \echo 'Expected one disposable Auth subject in Development.'
  \quit 3
\endif

insert into public.maintenance_companies (id)
values ('00000000-0000-4000-8000-00000000d101');

insert into public.platform_users (id)
values ('00000000-0000-4000-8000-00000000d102');

insert into public.platform_user_auth_subjects (
  auth_subject_id,
  platform_user_id
)
values (
  :'task_009_delete_subject_id'::uuid,
  '00000000-0000-4000-8000-00000000d102'
);

insert into public.company_memberships (
  id,
  platform_user_id,
  maintenance_company_id,
  role,
  is_enabled
)
values (
  '00000000-0000-4000-8000-00000000d103',
  '00000000-0000-4000-8000-00000000d102',
  '00000000-0000-4000-8000-00000000d101',
  'TECHNICIAN',
  true
);

commit;

\echo 'TASK-009 Auth-delete fixture prepared.'
\echo 'STOP: the authorized human operator must now delete only this disposable'
\echo 'Development Auth subject through an official supported Supabase mechanism.'
\echo 'Then run task_009_auth_delete_verify.sql with the same subject UUID.'
