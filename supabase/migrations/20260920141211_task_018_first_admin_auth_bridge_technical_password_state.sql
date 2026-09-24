create function public.resolve_first_admin_auth_bridge_technical_password_state(
  p_auth_bridge_credential_id uuid
)
returns table (
  auth_bridge_credential_id uuid,
  technical_password_key_version text,
  rotation_state text
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    bridge.id as auth_bridge_credential_id,
    case
      when pg_catalog.btrim(bridge.technical_password_key_version) <> ''
        and bridge.technical_password_key_version ~ '^[A-Za-z0-9._-]+$'
        and bridge.pending_key_version is null
        and bridge.rotation_operation_id is null
        and bridge.rotation_started_at is null
      then bridge.technical_password_key_version
      else null::text
    end as technical_password_key_version,
    case
      when pg_catalog.btrim(bridge.technical_password_key_version) <> ''
        and bridge.technical_password_key_version ~ '^[A-Za-z0-9._-]+$'
        and bridge.pending_key_version is null
        and bridge.rotation_operation_id is null
        and bridge.rotation_started_at is null
      then 'READY'
      when pg_catalog.btrim(bridge.technical_password_key_version) <> ''
        and bridge.technical_password_key_version ~ '^[A-Za-z0-9._-]+$'
        and bridge.pending_key_version is not null
        and pg_catalog.btrim(bridge.pending_key_version) <> ''
        and bridge.pending_key_version ~ '^[A-Za-z0-9._-]+$'
        and bridge.pending_key_version <> bridge.technical_password_key_version
        and bridge.rotation_operation_id is not null
        and bridge.rotation_started_at is not null
      then 'PENDING_ROTATION'
      else 'FAIL_CLOSED'
    end as rotation_state
  from public.auth_bridge_credentials as bridge
  where bridge.id = p_auth_bridge_credential_id;
$$;

alter function public.resolve_first_admin_auth_bridge_technical_password_state(uuid)
owner to postgres;

revoke all on function public.resolve_first_admin_auth_bridge_technical_password_state(uuid)
from public, anon, authenticated, service_role, supabase_auth_admin;

grant execute on function public.resolve_first_admin_auth_bridge_technical_password_state(uuid)
to service_role;

comment on function public.resolve_first_admin_auth_bridge_technical_password_state(uuid) is
  'TASK-018 server-only read-only resolver for one authoritative AuthBridgeCredential technical-password key version and bounded rotation state; returns no password or secret key material.';
