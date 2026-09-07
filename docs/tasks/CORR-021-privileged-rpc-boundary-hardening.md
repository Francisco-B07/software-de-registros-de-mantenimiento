# CORR-021 — Hardening de fronteras RPC privilegiadas fuera de schemas expuestos previo a TASK-015

## 1. Identificación

**ID:** `CORR-021`

**Tipo:** `SECURITY / IMPLEMENTATION CORRECTION`

**Estado de esta especificación:** `APPROVED FOR EXECUTION`

**Archivo de entrega:** `CORR-021-privileged-rpc-boundary-hardening-approved.md`

**CORR-021 DETERMINATION:** `APPROVED`

**CORR-021 SPEC REVIEW:** `APPROVED`

**CORR-021 HUMAN SPEC APPROVAL:** `APPROVED`

**CORR-021 aprobada:** `SÍ`

**CORR-021 canonicalizada:** `NO`

**CORR-021 implementation authorized:** `NO`

**Codex authorized:** `NO`

**Repository modified:** `NO`

**Supabase Cloud modified:** `NO`

**Hosted Development mutation authorized:** `NO`

**Staging:** `NO CHANGE`

**Production:** `NO CHANGE`

**TASK-015 implementation:** `BLOCKED / NOT AUTHORIZED`

**TASK-016:** `NOT DETERMINED / NOT GENERATED / NOT STARTED`

**New ADR required:** `NO`

`APPROVED FOR EXECUTION` acredita exclusivamente que la specification fue revisada y aprobada humanamente.

```text
APPROVED FOR EXECUTION
=
SPECIFICATION HUMAN-APPROVED

APPROVED FOR EXECUTION
!=
CORR-021 IMPLEMENTATION AUTHORIZED

APPROVED FOR EXECUTION
!=
CODEX AUTHORIZED

APPROVED FOR EXECUTION
!=
REPOSITORY MODIFICATION AUTHORIZED

APPROVED FOR EXECUTION
!=
SUPABASE CLOUD AUTHORIZED

APPROVED FOR EXECUTION
!=
HOSTED DEVELOPMENT AUTHORIZED

APPROVED FOR EXECUTION
!=
TASK-015 IMPLEMENTATION AUTHORIZED

APPROVED FOR EXECUTION
!=
DONE
```

---

## 2. Objetivo único

CORR-021 define un incremento PR-sized con exactamente dos responsabilidades:

1. remediar la frontera RPC privilegiada ya implementada por TASK-014 sin cambiar su semántica de producto ni romper su contrato público cuando pueda preservarse de forma segura;
2. superseder prospectivamente, antes de cualquier implementación de TASK-015, únicamente las cláusulas físicas que situaban un `SECURITY DEFINER` directamente en la superficie RPC expuesta.

La corrección ya determinada es:

```text
EXPOSED RPC =
SECURITY INVOKER

PRIVILEGED INTERNAL FUNCTION =
SECURITY DEFINER

PRIVILEGED FUNCTION SCHEMA =
NOT EXPOSED THROUGH DATA API

caller identity =
auth.uid() only

caller-scoped Supabase client =
PRESERVED

service-role ordinary path =
NO

generic privileged client =
NO

direct CompanyMembership write policies =
NO

direct AuditEvent table privileges =
NO
```

CORR-021 no implementa TASK-015 y no determina TASK-016.

---

## 3. Estado de gobernanza consumido

```text
CORR-021 DETERMINATION = APPROVED

blocker class histórico =
CURRENT SUPABASE SECURITY-DEFINER / EXPOSED-SCHEMA GUIDANCE CONFLICT

CORR-020 = DONE / CLOSED

TASK-015 product documentation prerequisite = SATISFIED

TASK-015 implementation = BLOCKED / NOT AUTHORIZED

TASK-016 = NOT DETERMINED / NOT GENERATED / NOT STARTED

new ADR required = NO
```

Los blockers históricos de source availability quedaron resueltos al disponibilizar y verificar las once fuentes físicas.

La generación de esta specification no autoriza repo, Codex, SQL, migration apply, RPC/RLS execution, Supabase Cloud, Hosted Development, Staging, Production, `git add`, commit ni push.

---

## 4. Fuentes físicas y verificación de identidad

### 4.1 Fuentes canónicas leídas íntegramente

- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`;
- `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`;
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`;
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`;
- `docs/product/01-product-definition.md`, actual posterior a CORR-020;
- `docs/product/02-domain-model.md`, actual posterior a CORR-020;
- `docs/product/03-permissions-rls-strategy.md`, actual posterior a CORR-020;
- `docs/product/11-phase-1-scope-entry-gate.md`;
- `docs/tasks/CORR-020-task-015-product-decisions-documentation-sync.md`;
- `docs/tasks/TASK-010-audit-event-foundation.md`.

```text
TASK-015 SHA-256 =
c00a9018a7d3293e5beff8fa3422f930d2a62a4078aa7b25a4e7d9f519f77e20
RESULT = PASS

CORR-020 SHA-256 =
483fb591d8069ef5ae4371b80ffe768bc34b221292a2acc1f60d01a7cbd05473
RESULT = PASS
```

### 4.2 Bundle físico de implementación actual

| # | Repo-relative source | SHA-256 físico | Bytes | EOL | Identity |
| ---: | --- | --- | ---: | --- | --- |
| 1 | `supabase/migrations/20260904004013_task_014_global_identity_authorization_foundation.sql` | `7e7e95d9006dd38f104c2f17c4540350fe011941f879852e4fbea314ba3c70b1` | 1619 | LF=51; CRLF=0 | PASS |
| 2 | `supabase/tests/database/task_014_global_identity_authorization_foundation.test.sql` | `cd69c5610b05839452823299cfe4b732a375f2225547051cac92c69aeeda1c58` | 9761 | LF=326; CRLF=0 | PASS |
| 3 | `tests/task-014-global-authorization.test.ts` | `b36eefc1f04fe27aa12899ccdec238b008f19d87e5fcbaec533f4f87fc55d1ba` | 9118 | LF=257; CRLF=0 | PASS |
| 4 | `src/modules/identity-authorization/application/resolve-current-global-authorization.ts` | `b7a2504e0f7b48dbbf980ec3189963619b5ef4f575b27c45a16f2df8495caba3` | 2941 | LF=109; CRLF=0 | PASS |
| 5 | `src/modules/identity-authorization/infrastructure/supabase/current-global-authorization-source.ts` | `11cfcad75bbef7c1bafb92efe9f55ac9edd9d4eec311899fc084d1c613103dde` | 678 | LF=19; CRLF=0 | PASS |
| 6 | `src/modules/identity-authorization/server.ts` | `6f64c7ecc2da234252a8baf60cf3c5feac1cb47192411cdee402e5c7dd5154c7` | 2732 | LF=68; CRLF=0 | PASS |
| 7 | `src/infrastructure/supabase/server.ts` | `23b15a1cb34720b371de53782147f832a49a7a07ebb2c5bae4a08d266029eb0d` | 1000 | LF=37; CRLF=0 | PASS |
| 8 | `src/infrastructure/config/supabase-public.ts` | `d22e19a0983a64320237a577137d65ab97614710276c36cb5d8a614c4733151a` | 1591 | LF=60; CRLF=0 | PASS |
| 9 | `tests/supabase-factories.test.ts` | `7b5400ea99b499c38afe23eb03a2c3a4722fdd65129355cdceae03bc72dd9487` | 3757 | LF=118; CRLF=0 | PASS |
| 10 | `supabase/config.toml` | `f057978a7cc21b49539f1c3e4b810343f6318f3ad66631060921cadf295081d3` | 15616 | LF=414; CRLF=0 | PASS |
| 11 | `package.json` | `5feb2f430b9aae2e4583e16737add458c265f0071cac2c391827f83a5c2b4157` | 878 | LF=33; CRLF=33 | PASS |

Las copias de transporte de SOURCE 3 y SOURCE 7 fueron renombradas externamente, pero sus bytes coinciden exactamente con el manifest.

```text
RECOVERED SOURCE IDENTITY MISMATCH = NO
11 distinct physical sources = YES
complete read = YES
```

### 4.3 Bundle-wide secret review

Resultado:

```text
real secrets detected = 0
real DB password detected = 0
real access token/JWT detected = 0
real service-role/secret key value detected = 0
real OpenAI key detected = 0
real AWS access key detected = 0
```

`config.toml` contiene referencias `env(...)` y comentarios, no valores secretos reales. Los tests usan valores dummy y dominios `.invalid`.

### 4.4 Baseline Git del source recovery

```text
branch = main
HEAD = e46482c3980d16d4c314f3f1662622e35cfcadfa
origin/main = e46482c3980d16d4c314f3f1662622e35cfcadfa
remote main = e46482c3980d16d4c314f3f1662622e35cfcadfa
divergence = 0 0
worktree = CLEAN
```

Esta specification no revalida ese snapshot mediante un repositorio Git montado. La futura implementación debe ejecutar preflight Git fresco.

---

## 5. Precedencia normativa

1. decisiones humanas posteriores explícitamente aprobadas dentro de su alcance, incluida CORR-021;
2. baseline normativa de producto posterior a CORR-020;
3. documentos derivados dentro de su bounded context;
4. ADR aceptados dentro de su decisión arquitectónica;
5. TASK/CORR como contratos físicos, de implementación y de estado;
6. repositorio real como fuente de verdad de la implementación al ejecutar;
7. documentación oficial vigente de Supabase para detalles provider-specific.

```text
historical artifact = IMMUTABLE

superseded physical clause =
REPLACED PROSPECTIVELY BY CORR-021

product semantics =
UNCHANGED
```

---

## 6. Current physical baseline verificada

La migration recuperada materializa actualmente:

```text
public.resolve_current_global_authority()

RETURNS TABLE (
  identity_resolved boolean,
  is_super_admin boolean,
  has_company_membership boolean
)

language = sql
stable = YES
security mode = SECURITY DEFINER
search_path = ''
```

El body actual deriva `(select auth.uid())`, resuelve `public.platform_user_auth_subjects → public.platform_users`, lee `is_super_admin`, detecta cualquier `company_memberships` del PlatformUser sin filtrar `is_enabled`, acepta cero argumentos y efectúa cero writes.

Los tests versionados afirman:

```text
owner = postgres
PUBLIC EXECUTE = NO
anon EXECUTE = NO
authenticated EXECUTE = YES
service_role EXECUTE = NO
supabase_auth_admin EXECUTE = NO
```

`owner = postgres` es evidencia versionada, no prueba del runtime Hosted actual.

El caller actual:

```text
createSupabaseServerClient()
→ publishable key + request-scoped Auth cookies
→ supabase.rpc("resolve_current_global_authority")
```

No se encontró ordinary `service-role` path ni generic privileged client.

`supabase/config.toml` declara:

```text
api.schemas = ["public", "graphql_public"]
```

Por tanto repo-localmente `public = EXPOSED`.

El bundle no referencia una convención de schema interno de aplicación adecuada. El source-recovery review reporta ninguno repo-wide. La implementación debe revalidarlo; esta specification no inventa un nombre.

---

## 7. Provider verification oficial vigente

**Provider verification date:** `2026-09-07`

**Provider sources:**

- Supabase — Database Functions: `https://supabase.com/docs/guides/database/functions`
- Supabase — Row Level Security: `https://supabase.com/docs/guides/database/postgres/row-level-security`
- Supabase — Securing your API: `https://supabase.com/docs/guides/api/securing-your-api`
- Supabase — Using Custom Schemas: `https://supabase.com/docs/guides/api/using-custom-schemas`
- Supabase — JavaScript: schema: `https://supabase.com/docs/reference/javascript/schema`
- Supabase — JavaScript: rpc: `https://supabase.com/docs/reference/javascript/rpc`
- Supabase — Postgres Roles: `https://supabase.com/docs/guides/database/postgres/roles`
- Supabase — Roles, superuser access and unsupported operations: `https://supabase.com/docs/guides/database/postgres/roles-superuser`

La documentación oficial vigente confirma:

- `SECURITY INVOKER` es default/best practice para database functions;
- `SECURITY DEFINER` ejecuta con privilegios del owner y exige `search_path` seguro;
- function `EXECUTE` debe restringirse explícitamente;
- un `SECURITY DEFINER` no debe residir en un schema listado como Exposed schema;
- el patrón oficial usa helpers privilegiados en schema privado/no expuesto;
- `supabase.schema(...)` requiere que el schema esté expuesto;
- grants y RLS son controles diferentes;
- un caller puede requerir PostgreSQL `USAGE` + `EXECUTE` para invocar indirectamente una función privada;
- PostgreSQL privilege no equivale a Data API routability;
- la guía RLS documenta que `postgres` puede `bypassrls` en este patrón, y que owner/FORCE RLS deben verificarse.

```text
PROVIDER CONTRACT DRIFT = NONE
approved CORR-021 topology = COMPATIBLE
```

---

## 8. Problema de seguridad

La topología actual combina:

```text
schema = public / exposed
security mode = SECURITY DEFINER
```

El problema no es un service-role ni generic privileged client: las fuentes actuales demuestran que no existen en este path.

El problema es que una función privilegiada está directamente routable por Data API para el rol con `EXECUTE`.

Debe corregirse:

```text
caller-scoped client
→ exposed purpose-specific RPC
  SECURITY INVOKER
→ unexposed purpose-specific internal function
  SECURITY DEFINER
→ authoritative PostgreSQL state
```

No se crea un generic privileged gateway.

---

## 9. Scope

CORR-021 implementation futura puede únicamente:

1. introducir/reusar un schema interno no expuesto;
2. mover la lógica privilegiada TASK-014 a una internal function purpose-specific;
3. convertir `public.resolve_current_global_authority()` en wrapper `SECURITY INVOKER`;
4. preservar nombre, firma y output públicos;
5. establecer owner/search_path/grants/revokes mínimos;
6. actualizar/añadir tests de topología;
7. preservar el caller TypeScript o hacer sólo cambios mínimos type-safe de regresión.

Además documenta el overlay físico futuro de TASK-015, sin implementar la capability.

---

## 10. Fuera de alcance

No incluye:

- grant/revoke/bootstrap funcional de `SUPER_ADMIN`;
- cambio de `is_super_admin`;
- creación de users/memberships;
- disable/reinstate/role-change;
- nueva AuditEvent action;
- UserClientAccess/SupportAccessGrant/Client;
- Auth funcional;
- UI;
- offline admin writes;
- Dexie/Service Worker/outbox;
- provider session registry;
- `auth.sessions`;
- target JWT storage;
- `ban_duration`;
- password workaround;
- Edge Function intermedia;
- microservicio/queue/worker;
- generic privileged gateway;
- nuevo ADR;
- Staging/Production change;
- TASK-016.

---

## 11. NORMATIVE SUPERSESSION MAP

### 11.1 Regla

Sólo se sustituyen cláusulas físicas que fijaban `SECURITY DEFINER` en la superficie RPC expuesta. Semántica funcional, multitenancy, outputs, decisiones, atomicidad y RLS permanecen.

### 11.2 TASK-014

| Fuente histórica | Cláusula | Overlay CORR-021 | Semántica preservada |
| --- | --- | --- | --- |
| §6.2 | exposed RPC `security mode = SECURITY DEFINER` | public RPC INVOKER + internal DEFINER | clasificación global exacta |
| §6.3 | hardening de “la función SECURITY DEFINER” | hardening aplica a internal; wrapper INVOKER con grants explícitos | mínimo privilegio/fail-closed |
| §6.4 items 2–3 | una función/RPC + privileges | API wrapper + internal privileged function | scope PR-sized |
| §11.1 | `purpose-specific SECURITY DEFINER RPC = YES` | exposed DEFINER = NO; internal DEFINER = YES | RLS no debilitada |
| §11.4 | purpose-specific function observa membership disabled | internal observa | disabled membership cuenta |
| §11.5 | privilege de function/RPC | privilege elevado sólo internal | no arbitrary targets |
| §11.6 | hardening SECURITY DEFINER | internal; wrapper tiene tests INVOKER propios | safe search_path/grants |
| RLS-016 | function puede observar disabled membership | internal únicamente | ordinary RLS unchanged |
| RLS-018/RLS-019 | PUBLIC EXECUTE/minimum grant | verificar wrapper e internal por separado | least privilege |
| §23.1 items 14–20 | tests de una function/RPC DEFINER | two-object topology tests | output/privileges mínimos |
| §23.3 | SECURITY DEFINER negative tests | internal + no-routability + wrapper tests | cross-identity safety |
| §23.9 | Hosted verify DEFINER RPC | Hosted wrapper INVOKER + internal DEFINER + non-exposed schema | misma matriz |
| AC-084 | purpose-specific RPC `SECURITY DEFINER` | public wrapper INVOKER + internal DEFINER | purpose global classification |
| AC-085/086 | auth.uid-only / no arbitrary target | internal; wrapper no autoridad | identity unchanged |
| AC-087 | PUBLIC EXECUTE revoked | wrapper e internal | no public execution |
| AC-088 | minimum EXECUTE | wrapper exact + internal/schema mínimo técnico | least privilege |
| AC-089 | safe search_path | internal DEFINER | safe resolution |
| AC-090/091 | minimal output / zero writes | internal; wrapper preserva output | unchanged |
| AC-092 | caller-scoped consumption | caller sigue public wrapper | public contract preserved |
| AC-093 | no service-role/generic client | unchanged | trust model |
| DoD 53 | purpose-specific RPC implemented | wrapper + internal implemented | same public purpose |
| DoD 54–55 | DEFINER hardening/search_path | internal only | secure privilege |
| DoD 56–57 | PUBLIC/minimum EXECUTE | both boundaries | least privilege |
| DoD 58 | auth.uid-only | internal reconstructs identity | no wrapper trust |

TASK-014 permanece históricamente `DONE / CLOSED`.

### 11.3 TASK-015

| Fuente histórica | Cláusula | Overlay CORR-021 | Semántica preservada |
| --- | --- | --- | --- |
| §11.2 | `public.apply_company_membership_lifecycle` | preserved as public wrapper proposal | inputs/output |
| §11.5 | function = purpose-specific DEFINER | public wrapper INVOKER + internal DEFINER | purpose-specific capability |
| §11.6 | search_path hardening | internal | safe resolution |
| §11.7 | PUBLIC/anon denied, authenticated exact EXECUTE | wrapper exact + internal/schema minimum technical grants | no direct table grants |
| §11.8–11.10 | actor/target/transaction inside function | internal owns all authority/transaction | authorization/atomicity |
| §20.4–20.5 | controlled DEFINER boundary | internal only | no generic bypass |
| SEC-015-018..020 | DEFINER search_path/schema-qualified/no dynamic SQL | internal | hardening |
| SEC-015-021/022 | PUBLIC/anon no EXECUTE | wrapper + internal | unauthenticated denied |
| SEC-015-023 | authenticated exact EXECUTE | wrapper exact + internal/USAGE minimum if required | least privilege |
| SEC-015-024..026 | no table grants/service-role/generic client | unchanged | trust model |
| RLS-015-010/011 | RPC definer reconstructs auth | internal definer reconstructs all | RLS bypass acotado |
| RLS-015-014/015 | PUBLIC revoked/authenticated exact | wrapper + internal matrix | least privilege |
| RLS-015-016..020 | no direct table privilege/service-role; ordinary reads unchanged | unchanged | isolation |
| §32.1 items 2–4 | RPC + DEFINER hardening + grants | public INVOKER + internal DEFINER + exact grants | same capability |
| AC-015-082 | single purpose-specific RPC boundary | one public API boundary backed by one internal privileged function | no generic gateway |
| AC-015-083 | boundary is DEFINER | exposed boundary INVOKER; internal DEFINER | privilege internalized |
| AC-015-084..086 | auth.uid/search_path/no dynamic SQL | internal | unchanged security semantics |
| AC-015-087/088 | PUBLIC/anon execute absent | wrapper + internal | unauthenticated denied |
| AC-015-089 | authenticated exact EXECUTE | wrapper exact; internal technical EXECUTE/USAGE minimum | no direct DML |
| AC-015-090..094 | no generic RPC/service-role/direct writes; audit RLS | unchanged | isolation/atomicity |
| DoD 17 | function/RPC implemented | wrapper + internal lifecycle function | same capability |
| DoD 18 | auth.uid identity | internal | caller authority unchanged |
| DoD 19–20 | DEFINER hardening/search_path | internal | secure privilege |
| DoD 21–22 | PUBLIC/anon absent/minimum authenticated | both boundaries | least privilege |
| DoD 23–26 | no service-role/generic client/direct writes; AuditEvent RLS | unchanged | trust/RLS |
| §40 steps 8–10 | implement one hardened RPC/application caller | wrapper INVOKER + internal DEFINER; caller caller-scoped | corrected shape |

No otra cláusula de TASK-015 queda supersedida.

---

## 12. Target physical topology

### 12.1 TASK-014

```text
caller-scoped Supabase client
→ public.resolve_current_global_authority()
  EXPOSED
  SECURITY INVOKER
  zero business arguments
→ <NON_EXPOSED_INTERNAL_SCHEMA>.<purpose-specific-internal-resolver>()
  NOT EXPOSED
  SECURITY DEFINER
  auth.uid() only
→ authoritative PostgreSQL state
```

El nombre exacto de la internal function queda pendiente de implementation preflight.

### 12.2 TASK-015 futura

```text
caller-scoped Supabase client
→ public.apply_company_membership_lifecycle(...)
  EXPOSED
  SECURITY INVOKER
→ <NON_EXPOSED_INTERNAL_SCHEMA>.<purpose-specific-internal-lifecycle>(...)
  NOT EXPOSED
  SECURITY DEFINER
  reconstructs all authority
→ authoritative PostgreSQL state
```

CORR-021 no crea la función lifecycle futura.

---

## 13. Schema exposure contract

```text
privileged internal function schema
∉
Exposed schemas
```

Preflight obligatorio:

- schemas físicos existentes;
- naming conventions;
- `supabase/config.toml`;
- Exposed schemas;
- grants/USAGE;
- default privileges.

Resolución:

```text
IF existing approved non-exposed internal schema is suitable
→ REUSE IT

ELSE
→ implementation may create one minimal internal schema
→ exact name resolved only in implementation preflight
```

`<NON_EXPOSED_INTERNAL_SCHEMA>` es placeholder normativo, no nombre físico.

Authenticated puede necesitar PostgreSQL `USAGE` y `EXECUTE` sobre internal para wrapper→internal. Esto no hace routable el schema por Data API mientras no esté expuesto.

Guardrail obligatorio:

```text
internal schema unexpectedly exposed
→ BLOCKER
→ no silent config mutation
```

Debe existir test repo-local y verificación Hosted.

---

## 14. Function ownership y BYPASSRLS

El SQL test actual afirma:

```text
current public resolver owner = postgres
```

No es prueba del runtime Hosted.

Target actual esperado:

```text
TASK-014 internal resolver owner = postgres
```

porque preserva la baseline y el patrón Supabase documentado donde `postgres` puede bypass RLS. CORR-021 no crea un custom `BYPASSRLS` role.

Implementation preflight y Hosted deben verificar:

- `pg_proc.proowner`;
- `pg_roles.rolbypassrls`;
- privileges del owner;
- `relrowsecurity`;
- `relforcerowsecurity`;
- table owner cuando sea material.

No asumir que todo DEFINER bypassa RLS.

El wrapper público es INVOKER; su owner no concede autoridad al caller.

TASK-015 futura debe seguir el owner convention verificado por CORR-021, actualmente esperado `postgres`, y revalidarlo antes de implementar.

Owner incompatible con la capability requerida = `BLOCKER`.

---

## 15. Privilege matrix

| Objeto / rol | PUBLIC | anon | authenticated | service_role | owner esperado |
| --- | --- | --- | --- | --- | --- |
| TASK-014 public wrapper | EXECUTE revoked | EXECUTE revoked | exact EXECUTE | no ordinary path; preserve revoked baseline | verify; expected migration owner `postgres` |
| TASK-014 internal resolver | EXECUTE revoked | EXECUTE revoked | exact technical EXECUTE only if wrapper requires | no ordinary path | `postgres` expected, verify |
| internal schema | no broad USAGE | no USAGE | USAGE only if wrapper requires | no ordinary path | verify |
| `platform_users` | no new grant | no new grant | no new write grant | no new ordinary path | unchanged |
| `company_memberships` | no new grant | no new grant | no new write grant/policy | no new ordinary path | unchanged |
| `audit_events` | no new grant | zero privilege preserved | zero privilege preserved | no new ordinary path | unchanged |
| future TASK-015 public wrapper | revoked | revoked | exact signature EXECUTE | no ordinary path | verify later |
| future TASK-015 internal lifecycle | revoked | revoked | exact technical EXECUTE only if wrapper requires | no ordinary path | current expectation `postgres`, reverify |

No reliance on default EXECUTE. No table grant is introduced merely to make a wrapper work.

---

## 16. Search path y object resolution

Every internal `SECURITY DEFINER` must use:

```text
search_path = ''
```

or a stricter alternative justified against then-current official guidance.

All tables, functions and objects must be schema-qualified. Dynamic SQL remains `NONE`. Caller input cannot become SQL identifier/object name.

Wrapper calls to internal must also be schema-qualified.

Tests inspect `pg_proc.proconfig` and definitions.

---

## 17. RLS y multitenancy

```text
RLS =
PRIMARY REMOTE ISOLATION BOUNDARY FOR TENANT DATA
```

No:

- tenant bypass policy;
- CompanyMembership UPDATE policy for authenticated;
- AuditEvent INSERT policy;
- SUPER_ADMIN ordinary tenant bypass;
- generic privileged DML.

TASK-014 internal privilege is limited to own identity/global classification.

TASK-015 future internal privilege must reconstruct actor, tenant, role, target, same-tenant and lifecycle invariants.

Knowing IDs does not grant authority.

---

## 18. auth.uid identity y API/caller boundary

TASK-014 internal function derives caller only from `auth.uid()`. It accepts no subject/actor/PlatformUser/tenant/membership/role/global-flag argument.

TASK-015 public wrapper may receive only:

```text
target_company_membership_id
operation
requested_role // CHANGE_ROLE only
```

Those are request data, never authority.

TASK-015 internal reconstructs all actor and tenant authority from `auth.uid()` + current PostgreSQL state.

Wrapper/application authorization is not trusted by internal privilege boundary.

---

## 19. TASK-014 remediation behavior

Internal resolver must:

1. obtain auth.uid;
2. resolve unique Auth subject→PlatformUser;
3. read current `is_super_admin`;
4. detect any membership, enabled or disabled;
5. return only the three approved booleans;
6. perform zero writes.

Public wrapper must:

1. remain `public.resolve_current_global_authority()`;
2. retain zero args;
3. retain exact return shape;
4. be INVOKER;
5. call only internal resolver;
6. make no independent authority decision;
7. allow no arbitrary target;
8. preserve existing application behavior.

Application malformed/error path remains fail-closed.

---

## 20. Migration strategy de CORR-021

Future implementation uses one new CORR-021 forward-only migration.

Conceptual order:

1. revalidate schemas, exposure, defaults, overloads, owner;
2. resolve/reuse exact internal schema;
3. if needed create minimal non-exposed schema without broad grants;
4. create internal TASK-014 resolver with expected owner, DEFINER, empty/fixed search_path and qualified objects;
5. revoke default/PUBLIC/anon execution before public dependency;
6. grant only required schema USAGE/internal EXECUTE;
7. replace/alter public resolver body/security mode preserving name/signature/return shape;
8. apply explicit wrapper revokes/grants;
9. leave table RLS/grants unchanged;
10. leave TASK-015 function absent;
11. verify final definitions/overloads/owner/grants/exposure.

Internal object must be locked down before public wrapper depends on it.

No executable SQL is included in this specification.

---

## 21. Application compatibility

Current caller uses:

```text
supabase.rpc("resolve_current_global_authority")
```

without args.

Because schema/name/signature/output/authenticated-callable surface are preserved:

```text
application code change =
NONE OR MINIMAL TYPE-SAFE REGRESSION-ONLY
```

If that public contract cannot be preserved:

```text
CORR-021 IMPLEMENTATION =
BLOCKER — PUBLIC CONTRACT CHANGE REQUIRED
```

---

## 22. TASK-015 prospective corrected contract

```text
public.apply_company_membership_lifecycle(...)
=
EXPOSED
SECURITY INVOKER
purpose-specific wrapper

<NON_EXPOSED_INTERNAL_SCHEMA>.<purpose-specific-internal-lifecycle>(...)
=
NOT EXPOSED
SECURITY DEFINER
purpose-specific authority + mutation boundary
```

Internal remains responsible for:

```text
auth.uid()
→ PlatformUser actor
→ current enabled CompanyMembership actor
→ current tenant
→ current COMPANY_ADMIN role
→ authoritative target membership
→ same-tenant
→ self restrictions
→ admin continuity
→ current role/is_enabled
→ DECISION-001..006
→ real mutation when valid
→ exact AuditEvent when real mutation
```

Wrapper may validate input shape but cannot authorize.

---

## 23. Transactional behavior TASK-015

wrapper→internal must be a direct PostgreSQL function call.

No HTTP, Edge Function, second client, queue, worker, outbox, async audit or separate DB transaction.

Invariant remains:

```text
membership mutation committed
IFF
required AuditEvent committed
```

Tenant coordination/locking and post-lock reevaluation remain inside internal.

Injected AuditEvent failure must roll back membership mutation.

---

## 24. DECISION-001..006

```text
DECISION-001 =
self-disable/self-revoke PROHIBITED

DECISION-002 =
self-role-change PROHIBITED

DECISION-003 =
no zero enabled COMPANY_ADMIN for tenant with active administration

DECISION-004 =
role-change while disabled ALLOWED
is_enabled remains false
reinstate uses current role

DECISION-005 =
authorized already-satisfied request
→ IDEMPOTENT SUCCESS
→ changed=false
→ no mutation
→ no AuditEvent

DECISION-006 =
current authoritative PostgreSQL state wins under concurrency
post-coordination reevaluation required
no client expected-state/version token required
```

Unchanged.

---

## 25. AuditEvent contract

TASK-010 remains authoritative.

```text
real disable/revoke → USER_DISABLED_OR_REVOKED
real reinstate → USER_REINSTATED
real role-change → USER_ROLE_CHANGED
```

Exactly one event for a real mutation. No event for no-op/DENY. Actor/tenant/time derive authoritatively. No direct authenticated AuditEvent insert privilege or new policy.

---

## 26. Provider-side session termination

Preserve TASK-015:

```text
current authoritative PostgreSQL state =
PRIMARY AUTHORIZATION AUTHORITY

provider-side termination =
DEFENSE IN DEPTH WHEN SUPPORTED/APPLICABLE

target provider-side termination under approved constraints =
UNSUPPORTED
```

No `auth.sessions`, target JWT storage, target session fabrication, `ban_duration`, password workaround or provider internals.

---

## 27. Offline y UI

```text
CORR-021 UI = NO CHANGE
CORR-021 offline = NO CHANGE
TASK-015 lifecycle administration = ONLINE-ONLY
```

No React/Dexie/IndexedDB/Service Worker/sync/outbox change.

---

## 28. Threat model

| ID | Threat | Control | Verification |
| --- | --- | --- | --- |
| T1 | unauthenticated wrapper call | PUBLIC/anon denied; auth.uid NULL fail-closed | SQL/API negative |
| T2 | authenticated direct internal RPC | internal schema not exposed | Data API negative |
| T3 | `supabase.schema(internal)` | schema absent from Exposed schemas | JS/API negative + config guard |
| T4 | target/tenant manipulation | internal derives actor/tenant and same-tenant | cross-tenant tests |
| T5 | arbitrary global lookup | TASK-014 zero args, auth.uid-only | signature/output |
| T6 | compromised/incorrect wrapper logic | internal reconstructs all authority | negative tests |
| T7 | search-path shadowing | empty/fixed search_path + qualified objects | pg_proc/static |
| T8 | default EXECUTE leakage | explicit revokes/grants | ACL inspection |
| T9 | PUBLIC/anon inherited EXECUTE | explicit privilege tests | DB |
| T10 | cross-tenant target | internal same-tenant enforcement | future TASK-015 |
| T11 | stale JWT/app role | current DB state wins | authorization regression |
| T12 | disabled actor | enabled actor membership required | future TASK-015 |
| T13 | global+membership inconsistency | fail-closed | identity matrix |
| T14 | direct membership DML | no direct grant/write policy | RLS/API bypass |
| T15 | direct AuditEvent insert | zero authenticated privilege/no policy | DB/API bypass |
| T16 | internal schema later exposed | config guard + Hosted inspection | CI/local + Hosted Gate |

T16 is release-blocking, not advisory.

---

## 29. Failure model

| Condition | TASK-014 | TASK-015 future | Action |
| --- | --- | --- | --- |
| auth.uid NULL | deny | deny | no mutation |
| missing PlatformUser | deny | deny | no mutation |
| ambiguous mapping | deny | deny | blocker if structural |
| lookup error | deny | deny/error | no fallback |
| internal unavailable | deny/error | deny/error | no fallback |
| privilege misconfig | deny/error | deny/error | repair only in approved scope |
| internal schema exposed | blocker | blocker | no silent config mutation |
| exposure cannot be proven | blocker | blocker | reviewer |
| ambiguous overload | blocker | blocker | no best effort |
| unexpected owner | blocker/review | blocker/review | inspect RLS/privileges |
| unsafe grants/search_path | blocker | blocker | no closure |
| global+membership | inconsistent/deny | inconsistent/deny | no repair |
| cross-tenant | n/a | opaque deny | no oracle |
| AuditEvent failure | n/a | rollback | atomicity |
| authorization failure | n/a | deny | no mutation/event |
| provider termination unavailable | n/a | DB authority remains | no rollback |

No failure degrades to ALLOW, SUPER_ADMIN, tenant authority or lifecycle success.

---

## 30. Implementation preflight

Before repository modification:

1. human implementation authorization;
2. exact repo/branch/HEAD/upstream/divergence/worktree;
3. canonical CORR-021 + sources read;
4. later resolver-altering migration check;
5. schema enumeration;
6. `config.toml`/Exposed schemas;
7. default privileges;
8. overloads;
9. owner/security mode/proconfig/proacl;
10. table owner/RLS/FORCE RLS;
11. internal schema convention;
12. exact internal names resolved only here;
13. TypeScript caller contract;
14. current test harness/scripts;
15. official Supabase recheck;
16. stop on contradiction.

---

## 31. Expected changed paths

Expected implementation surface:

- **NEW:** one CORR-021 migration, exact timestamp/name by repo convention;
- **MODIFY/ADD:** SQL security/topology tests;
- **MODIFY/ADD:** static TypeScript/security tests;
- **application TypeScript:** expected no change; minimal regression-only change permitted;
- **`supabase/config.toml`:** expected `NO CHANGE`;
- **product/ADR/TASK historical Markdown:** `NO CHANGE`;
- **TASK-015 implementation files:** `NO CHANGE / NOT CREATED`.

Materially larger path set = blocker/review.

---

## 32. Cloud gates

```text
local implementation
→ local PASS
→ human implementation review
→ separate Hosted Development mutation authorization
→ Development apply/verify
→ Hosted review
→ later Git/Staging gates separately
```

Hosted verifies actual Exposed schemas, internal schema non-exposure, wrapper INVOKER, internal DEFINER, owner, search_path, ACL/USAGE, ordinary table grants, RLS/FORCE RLS, TASK-014 matrix and unexpected diff.

If Hosted exposes internal schema, block. Do not silently mutate configuration.

Staging/Production remain unchanged absent separate Gates.

---

## 33. Git governance

No Git operation is performed by specification generation.

Future repository modification, Hosted Development, staging, `git add`, commit and push remain separate approvals.

Implementation PASS does not imply commit/push approval.

---

## 34. Tests ejecutables de CORR-021 — TASK-014 remediation

**T021-DB-001** exactly one zero-arg public resolver.

**T021-DB-002** exact three-boolean output.

**T021-DB-003** public resolver = SECURITY INVOKER.

**T021-DB-004** internal resolver exists in selected non-exposed schema.

**T021-DB-005** internal resolver = SECURITY DEFINER.

**T021-DB-006** internal safe/empty search_path.

**T021-DB-007** internal owner = verified expected owner.

**T021-DB-008** internal body schema-qualified.

**T021-DB-009** no unexpected privileged overload.

**T021-DB-010** PUBLIC wrapper execute denied.

**T021-DB-011** anon wrapper execute denied.

**T021-DB-012** authenticated wrapper execute allowed.

**T021-DB-013** PUBLIC internal execute denied.

**T021-DB-014** anon internal execute denied.

**T021-DB-015** authenticated internal EXECUTE/schema USAGE only as technically required.

**T021-DB-016** no new ordinary service_role path.

**T021-DB-017** internal schema absent from repo-local Exposed schemas.

**T021-API-001** authenticated public RPC call works.

**T021-API-002** internal schema/function cannot be routed directly through Data API.

**T021-AUTH-001** missing auth.uid deny.

**T021-AUTH-002** missing PlatformUser mapping deny.

**T021-AUTH-003** DB true + no membership positive unchanged.

**T021-AUTH-004** DB false + no membership not global.

**T021-AUTH-005** DB true + enabled membership inconsistent/deny.

**T021-AUTH-006** DB true + disabled membership inconsistent/deny.

**T021-AUTH-007** DB false + enabled membership not global.

**T021-AUTH-008** DB false + disabled membership not global.

**T021-AUTH-009** caller A cannot classify B.

**T021-AUTH-010** no tenant/client/PlatformUser/Auth subject injection.

**T021-AUTH-011** no role/is_enabled/tenant/client output leak.

**T021-AUTH-012** DB/RPC error fails closed at app layer.

**T021-SEC-001** no dynamic SQL.

**T021-SEC-002** zero writes.

**T021-SEC-003** authenticated cannot update is_super_admin.

**T021-SEC-004** ordinary CompanyMembership RLS unchanged.

**T021-SEC-005** no direct membership write grant/policy.

**T021-SEC-006** AuditEvent privileges/RLS unchanged.

**T021-SEC-007** caller-scoped server client preserved.

**T021-SEC-008** no service-role key/client or generic privileged client.

**T021-SEC-009** guard fails if internal schema enters `api.schemas`.

**T021-REG-001** historical TASK-014 functional matrix remains PASS.

Fixtures remain test-only and must rollback/clean per harness.

---

## 35. Future TASK-015 test contract

**T015-C021-001** public lifecycle wrapper INVOKER.

**T015-C021-002** internal lifecycle DEFINER.

**T015-C021-003** internal schema not exposed.

**T015-C021-004** no direct Data API route to internal.

**T015-C021-005** least-privilege wrapper/internal grants.

**T015-C021-006** internal auth.uid-only actor.

**T015-C021-007** wrapper/frontend actor/tenant/role cannot authorize.

**T015-C021-008** cross-tenant opaque deny.

**T015-C021-009** disabled actor deny.

**T015-C021-010** global-only SUPER_ADMIN deny.

**T015-C021-011** global+membership inconsistency deny.

**T015-C021-012** DECISION-001 preserved.

**T015-C021-013** DECISION-002 preserved.

**T015-C021-014** DECISION-003 concurrency preserved.

**T015-C021-015** DECISION-004 preserved.

**T015-C021-016** DECISION-005 no-op/no-event preserved.

**T015-C021-017** DECISION-006 authoritative reevaluation preserved.

**T015-C021-018** wrapper→internal one DB transaction.

**T015-C021-019** mutation + AuditEvent atomic.

**T015-C021-020** injected AuditEvent failure rolls back.

**T015-C021-021** direct membership DML denied.

**T015-C021-022** direct AuditEvent insert denied.

**T015-C021-023** provider termination findings unchanged.

These are contractual, not executed by CORR-021 if they require TASK-015 implementation.

---

## 36. Regression suite

Current `package.json` defines:

```text
npm run lint
npm run typecheck
npm run test
npm run build
npm run verify
```

Required regression coverage:

- TASK-009 DB/RLS;
- TASK-010 AuditEvent;
- TASK-011 Auth SSR;
- TASK-012 authorization;
- TASK-013/E2;
- TASK-014 global authorization;
- new CORR-021 tests;
- `git diff --check`;
- Supabase local migration/reset/test harness according to repo convention.

No invented script.

---

## 37. Documentation impact

Expected:

```text
01-product-definition.md = NO CHANGE
02-domain-model.md = NO CHANGE
03-permissions-rls-strategy.md = NO CHANGE
ADR-0001 = NO CHANGE
ADR-0002 = NO CHANGE
ADR-0003 = NO CHANGE
TASK-014 historical artifact = NO CHANGE
TASK-015 historical artifact = NO CHANGE
CORR-020 = NO CHANGE
11-phase-1-scope-entry-gate.md = NO REQUIRED CHANGE
```

A later state-sync may be determined by Revisor Central after implementation, but is not pre-authorized.

If semantic change becomes necessary:

```text
BLOCKER / FOLLOW-UP CORRECTION REQUIRED
```

---

## 38. Architecture decision assessment

```text
new ADR required = NO
```

CORR-021 changes no tenant, role model, RLS primary boundary, authorization semantics, service-role policy, bounded context or application architecture.

If any must change:

```text
CORR-021 IMPLEMENTATION =
BLOCKER — NEW ARCHITECTURAL DECISION REQUIRED
```

---

## 39. Blockers de futura implementación

1. unauthorized Git drift;
2. canonical contradiction;
3. source identity mismatch;
4. later resolver migration/collision;
5. unexpected overload;
6. public contract cannot be preserved;
7. no safe non-exposed internal schema;
8. internal schema exposed local;
9. internal schema exposed Hosted;
10. unsafe search_path;
11. unqualified/ambiguous resolution unavoidable;
12. dynamic SQL requires new review;
13. owner materially unexpected;
14. owner/RLS behavior insufficient;
15. FORCE RLS or table setting blocks required behavior;
16. ordinary RLS must be weakened;
17. direct table grants/policies become necessary;
18. service-role/generic privileged client required;
19. public wrapper must remain/become DEFINER;
20. internal must be in Exposed schema;
21. auth.uid-only cannot be preserved;
22. internal would need to trust wrapper authority;
23. provider guidance drifts;
24. secret exposure;
25. tests/regressions fail;
26. Hosted unexpected diff;
27. Hosted owner/security/grant mismatch;
28. unauthorized Hosted config mutation needed;
29. scope would implement TASK-015;
30. new architectural decision required.

```text
BLOCKER
→ STOP
→ no scope expansion
→ no silent repair
→ RETURN TO REVISOR CENTRAL
```

---

## 40. Acceptance Criteria

**AC-021-001.** El artefacto conserva `ID = CORR-021`, tipo `SECURITY / IMPLEMENTATION CORRECTION` y estado `APPROVED FOR EXECUTION`.

**AC-021-002.** `APPROVED FOR EXECUTION` acredita exclusivamente aprobación humana de la specification y no equivale a ejecución real; la especificación no se marca `DONE`, `CLOSED` ni `IMPLEMENTED`.

**AC-021-003.** CORR-021 mantiene exactamente dos responsabilidades: remediación de TASK-014 y overlay prospectivo de TASK-015.

**AC-021-004.** `TASK-015 implementation = BLOCKED / NOT AUTHORIZED` permanece.

**AC-021-005.** `TASK-016 = NOT DETERMINED / NOT GENERATED / NOT STARTED` permanece.

**AC-021-006.** `new ADR required = NO` permanece.

**AC-021-007.** Las 11 fuentes físicas recuperadas han sido verificadas por SHA-256 desde bytes reales y coinciden con el manifest.

**AC-021-008.** `TASK-015` coincide con SHA-256 `c00a9018a7d3293e5beff8fa3422f930d2a62a4078aa7b25a4e7d9f519f77e20`.

**AC-021-009.** `CORR-020` coincide con SHA-256 `483fb591d8069ef5ae4371b80ffe768bc34b221292a2acc1f60d01a7cbd05473`.

**AC-021-010.** El bundle-wide secret review no detecta secretos reales; placeholders `env(...)`, claves dummy y dominios `.invalid` no se consideran secretos.

**AC-021-011.** La verificación provider se registra con fecha `2026-09-07` y usa sólo documentación oficial de Supabase.

**AC-021-012.** La documentación oficial confirma `SECURITY INVOKER` como default/best practice para database functions.

**AC-021-013.** La documentación oficial confirma que todo `SECURITY DEFINER` debe fijar `search_path` seguro.

**AC-021-014.** La documentación oficial vigente indica que un `SECURITY DEFINER` no debe residir en un schema listado como Exposed schema.

**AC-021-015.** La documentación oficial confirma que un schema debe estar expuesto para ser seleccionado directamente por `supabase.schema(...)`/Data API.

**AC-021-016.** La documentación oficial confirma que grants y RLS son controles distintos y que functions requieren `EXECUTE` explícito según el rol.

**AC-021-017.** No existe `PROVIDER CONTRACT DRIFT` respecto de la decisión ya aprobada de CORR-021.

**AC-021-018.** `public.resolve_current_global_authority()` conserva nombre, cero argumentos y output de tres booleanos.

**AC-021-019.** `public.resolve_current_global_authority()` queda definido por contrato como exposed purpose-specific `SECURITY INVOKER` wrapper.

**AC-021-020.** La función privilegiada de TASK-014 queda definida por contrato como purpose-specific `SECURITY DEFINER` en `<NON_EXPOSED_INTERNAL_SCHEMA>`.

**AC-021-021.** `<NON_EXPOSED_INTERNAL_SCHEMA>` se utiliza sólo como placeholder normativo y no como nombre físico aprobado.

**AC-021-022.** El preflight de implementación debe revalidar schemas existentes y reutilizar uno adecuado si existe.

**AC-021-023.** Si no existe schema interno adecuado, el nombre de un schema mínimo nuevo sólo puede resolverse durante implementation preflight.

**AC-021-024.** El schema de la función privilegiada interna no puede pertenecer a la lista de Exposed schemas local ni Hosted.

**AC-021-025.** Un schema interno accidentalmente expuesto produce `BLOCKER`, no una mutación silenciosa de configuración.

**AC-021-026.** El wrapper público TASK-014 deriva ninguna autoridad por sí mismo y no se convierte en trust boundary.

**AC-021-027.** La función interna TASK-014 deriva la identidad únicamente de `auth.uid()`.

**AC-021-028.** La función interna TASK-014 no acepta actor ID, PlatformUser target, tenant ID, membership ID ni client ID.

**AC-021-029.** La función interna TASK-014 resuelve el PlatformUser actual y lee el `is_super_admin` vigente.

**AC-021-030.** La función interna TASK-014 detecta existencia de cualquier CompanyMembership del caller, incluida disabled.

**AC-021-031.** El resultado `is_super_admin=true` + cualquier membership sigue siendo `INCONSISTENT / DENY`.

**AC-021-032.** Missing identity, missing PlatformUser, mapping inconsistente o lookup failure siguen siendo fail-closed.

**AC-021-033.** El output público TASK-014 permanece exactamente mínimo: `identity_resolved`, `is_super_admin`, `has_company_membership`.

**AC-021-034.** El resolver TASK-014 realiza cero writes.

**AC-021-035.** El resolver TASK-014 no expone tenant ID, role, `is_enabled`, client scope ni datos operativos.

**AC-021-036.** El caller TypeScript TASK-014 continúa siendo caller-scoped y no requiere `service-role`.

**AC-021-037.** El contrato público TASK-014 puede preservarse sin breaking change; `PUBLIC CONTRACT CHANGE REQUIRED` no aparece en esta especificación.

**AC-021-038.** El owner versionado actual del resolver TASK-014 se registra como `postgres` sólo como baseline, no como prueba runtime Hosted.

**AC-021-039.** Implementation preflight debe verificar owner local/runtime de wrapper e internal function.

**AC-021-040.** Hosted Development debe verificar owner real bajo Gate separado.

**AC-021-041.** El owner de la internal TASK-014 se espera `postgres` bajo la baseline actual, salvo contradicción material detectada en preflight.

**AC-021-042.** Si el owner real no puede proporcionar exactamente la lectura privilegiada requerida o cambia la semántica RLS esperada, la implementación se bloquea.

**AC-021-043.** No se crea un nuevo custom `BYPASSRLS` role por CORR-021.

**AC-021-044.** El wrapper TASK-014, al ser `SECURITY INVOKER`, no hereda privilegios de su owner para el caller.

**AC-021-045.** La internal `SECURITY DEFINER` sólo puede usar privilegios de owner para el caso de uso purpose-specific aprobado.

**AC-021-046.** El preflight verifica si las tablas relevantes tienen `FORCE ROW LEVEL SECURITY` u otra configuración que altere la semántica requerida.

**AC-021-047.** El `search_path` de toda internal `SECURITY DEFINER` corregida/nueva es `''` o una alternativa más restrictiva formalmente justificada.

**AC-021-048.** Todos los objetos usados dentro de una internal `SECURITY DEFINER` se referencian schema-qualified.

**AC-021-049.** Dynamic SQL permanece `NONE` salvo nueva revisión humana.

**AC-021-050.** `PUBLIC EXECUTE` sobre el wrapper TASK-014 está revocado.

**AC-021-051.** `anon EXECUTE` sobre el wrapper TASK-014 está revocado.

**AC-021-052.** `authenticated EXECUTE` sobre el wrapper TASK-014 se limita a la firma exacta.

**AC-021-053.** `service_role EXECUTE` sobre el wrapper TASK-014 no se introduce como ordinary path.

**AC-021-054.** `PUBLIC EXECUTE` sobre la internal TASK-014 está revocado.

**AC-021-055.** `anon EXECUTE` sobre la internal TASK-014 está revocado.

**AC-021-056.** El grant de `EXECUTE` y, si PostgreSQL lo exige, `USAGE` sobre el schema interno para `authenticated` se limita al mínimo técnico necesario para wrapper→internal.

**AC-021-057.** Un grant PostgreSQL mínimo a `authenticated` sobre la internal no vuelve routable esa función por Data API mientras su schema no esté expuesto.

**AC-021-058.** No se conceden privilegios directos de tabla adicionales sobre `company_memberships` a `authenticated`.

**AC-021-059.** No se conceden privilegios directos de tabla adicionales sobre `audit_events` a `authenticated`.

**AC-021-060.** No se crea nueva write policy de `company_memberships`.

**AC-021-061.** No se crea nueva application write policy de `audit_events`.

**AC-021-062.** RLS permanece habilitada y semánticamente sin cambios para los datos tenant-owned afectados.

**AC-021-063.** `SUPER_ADMIN ordinary tenant RLS bypass = NO` permanece.

**AC-021-064.** `authenticated != authorized` permanece en todos los paths corregidos.

**AC-021-065.** La migration futura de CORR-021 es nueva, forward-only, mínima y reproducible.

**AC-021-066.** La migration futura no modifica la migration histórica de TASK-014.

**AC-021-067.** La migration futura no modifica el artefacto canónico histórico TASK-014.

**AC-021-068.** La migration futura no implementa ninguna operación de TASK-015.

**AC-021-069.** La migration futura no crea una placeholder lifecycle function de TASK-015 sin necesidad funcional.

**AC-021-070.** La secuencia de migration prepara primero schema/internal function cerrados y grants mínimos antes de apuntar el wrapper público a la internal.

**AC-021-071.** La migration evita depender de default function privileges y aplica revokes/grants explícitos.

**AC-021-072.** La migration preserva una superficie pública invocable sólo cuando la topología interna segura ya está disponible.

**AC-021-073.** Después de migration, no existe `SECURITY DEFINER` corregido de TASK-014 dentro de un schema expuesto.

**AC-021-074.** La current app boundary puede permanecer sin cambios o con cambios mínimos type-safe de regresión.

**AC-021-075.** `public.apply_company_membership_lifecycle(...)` se preserva como nombre público propuesto de TASK-015 salvo el preflight histórico ya permitido por TASK-015.

**AC-021-076.** El futuro lifecycle RPC público TASK-015 es `SECURITY INVOKER` y purpose-specific.

**AC-021-077.** La futura función interna TASK-015 es `SECURITY DEFINER` y reside en schema no expuesto.

**AC-021-078.** Toda autoridad de TASK-015 se reconstruye dentro de la internal function, no en el wrapper.

**AC-021-079.** La internal TASK-015 deriva actor desde `auth.uid()` y PostgreSQL autoritativo.

**AC-021-080.** La internal TASK-015 verifica actor membership enabled y role actual `COMPANY_ADMIN`.

**AC-021-081.** La internal TASK-015 deriva tenant y target desde PostgreSQL y verifica same-tenant.

**AC-021-082.** `DECISION-001` self-disable/self-revoke prohibido permanece.

**AC-021-083.** `DECISION-002` self-role-change prohibido permanece.

**AC-021-084.** `DECISION-003` admin continuity permanece concurrency-safe.

**AC-021-085.** `DECISION-004` role-change while disabled permanece permitido sin habilitar.

**AC-021-086.** `DECISION-005` already-satisfied autorizado permanece no-op `changed=false`, sin mutación ni AuditEvent.

**AC-021-087.** `DECISION-006` current authoritative PostgreSQL state y reevaluación bajo concurrencia permanecen.

**AC-021-088.** La separación wrapper→internal de TASK-015 no introduce network hop ni nueva transaction boundary.

**AC-021-089.** Mutation real de CompanyMembership y AuditEvent requerido permanecen en la misma transacción PostgreSQL.

**AC-021-090.** Fallo de AuditEvent revierte la mutation de membership futura.

**AC-021-091.** Fallo de mutation no deja AuditEvent confirmado.

**AC-021-092.** No-op y DENY no producen AuditEvent.

**AC-021-093.** Los privilegios/RLS de AuditEvent de TASK-010 permanecen intactos.

**AC-021-094.** Provider-side target session termination permanece `UNSUPPORTED` bajo las restricciones ya aprobadas de TASK-015.

**AC-021-095.** No se introduce acceso directo a `auth.sessions`.

**AC-021-096.** No se introduce target JWT storage.

**AC-021-097.** No se introduce `ban_duration` ni password workaround.

**AC-021-098.** `UI = NO CHANGE` y lifecycle administrativo TASK-015 permanece online-only.

**AC-021-099.** No se crea Dexie/outbox/sync flow administrativo.

**AC-021-100.** Threat model cubre T1..T16 y cada amenaza tiene control o test verificable.

**AC-021-101.** La amenaza de schema interno añadido accidentalmente a Exposed schemas tiene guardrail repo-local y verificación Hosted.

**AC-021-102.** Failure model nunca degrada un error a global authority, tenant authority o lifecycle success.

**AC-021-103.** Ambiguous function overload, owner inesperado, grants inesperados o schema exposure inesperada producen fail-closed/blocker.

**AC-021-104.** Tests ejecutables CORR-021 prueban public wrapper invoker, internal definer y no-routability del internal schema.

**AC-021-105.** Tests CORR-021 preservan toda la matriz funcional histórica de TASK-014.

**AC-021-106.** Tests CORR-021 prueban `auth.uid()` propagation y ausencia de lookup arbitrario.

**AC-021-107.** Tests CORR-021 prueban ordinary CompanyMembership RLS sin regresión.

**AC-021-108.** Tests CORR-021 prueban ausencia de ordinary service-role/generic privileged client.

**AC-021-109.** El future TASK-015 test contract prueba wrapper invoker/internal definer sin implementar la capability durante CORR-021.

**AC-021-110.** El future TASK-015 test contract conserva tests de DECISION-001..006, atomicidad y concurrencia.

**AC-021-111.** La regression suite incluye TASK-009/010/011/012/013/014 y scripts reales declarados en `package.json`.

**AC-021-112.** `package.json` actual declara `lint`, `typecheck`, `test`, `build` y `verify`; no se inventan scripts adicionales.

**AC-021-113.** Supabase Local DB reset/test harness se usa conforme a las convenciones reales del repo inspeccionadas en implementation preflight.

**AC-021-114.** Hosted Development mutation requiere Gate humano separado después de local PASS y implementation review.

**AC-021-115.** Hosted Development verifica Exposed schemas reales, owner, security mode, search_path, grants y comportamiento antes de cierre.

**AC-021-116.** Si Hosted Development expone el schema interno seleccionado, la implementación queda bloqueada.

**AC-021-117.** Staging no se modifica sin Gate separado.

**AC-021-118.** Production no se modifica por CORR-021 sin Gate separado.

**AC-021-119.** Git add, commit y push permanecen Gates separados.

**AC-021-120.** El NORMATIVE SUPERSESSION MAP no reescribe documentos históricos y sólo sustituye cláusulas físicas conflictivas.

**AC-021-121.** `01-product-definition.md`, `02-domain-model.md` y `03-permissions-rls-strategy.md` requieren cero cambio semántico por CORR-021.

**AC-021-122.** ADR-0001, ADR-0002 y ADR-0003 requieren cero cambio por CORR-021.

**AC-021-123.** `11-phase-1-scope-entry-gate.md` no requiere cambio si el public resolver contract se preserva, como esta spec exige.

**AC-021-124.** Cualquier necesidad real de cambiar producto, trust model o public API produce blocker/follow-up en vez de scope creep.

**AC-021-125.** No hay blocker de generación abierto al emitir esta especificación.

**AC-021-126.** `next gate = CORR-021 APPROVED ARTIFACT REVIEW`.

---

## 41. Definition of Done

CORR-021 may be declared `DONE / CLOSED` only when all items below are satisfied:

1. CORR-021 specification review = APPROVED.
2. Human specification approval = APPROVED.
3. Se genera el artefacto formalmente aprobado sin drift respecto de esta versión revisada.
4. Approved artifact review = PASS.
5. El artefacto aprobado se canonicaliza mediante Gate separado.
6. Canonicalization review = PASS.
7. El artefacto canónico se incorpora a Git mediante Gate separado.
8. Canonical Git incorporation review = PASS.
9. Existe autorización humana separada para implementar CORR-021.
10. Implementation Git preflight fresco = PASS.
11. Implementation canon preflight = PASS.
12. Implementation repo/schema/config preflight = PASS.
13. Las fuentes físicas actuales siguen coherentes o cualquier drift ha sido revisado humanamente.
14. Provider contract recheck oficial = PASS sin drift material.
15. Se resuelve/revalida el schema interno exacto sin inventarlo fuera del preflight.
16. El schema interno seleccionado no pertenece a Exposed schemas locales.
17. El owner esperado/real se verifica localmente.
18. La semántica de owner/BYPASSRLS/FORCE RLS necesaria se verifica localmente.
19. Se crea una migration nueva, forward-only, mínima y reproducible para CORR-021.
20. La migration histórica de TASK-014 permanece inmutable.
21. El internal resolver TASK-014 purpose-specific queda creado/reubicado en schema no expuesto.
22. El internal resolver TASK-014 queda `SECURITY DEFINER`.
23. El internal resolver TASK-014 queda con `search_path` seguro/empty y referencias schema-qualified.
24. El public `resolve_current_global_authority()` conserva nombre, firma y output.
25. El public `resolve_current_global_authority()` queda `SECURITY INVOKER`.
26. Los revokes/grants del public wrapper coinciden con la matriz aprobada.
27. Los revokes/grants/USAGE mínimos de la internal coinciden con la matriz aprobada.
28. No existe `PUBLIC`/`anon` execution efectivo no autorizado en ninguna boundary corregida.
29. No existe ordinary `service-role` path ni generic privileged client.
30. CompanyMembership RLS ordinaria permanece sin cambio semántico.
31. AuditEvent privileges/RLS de TASK-010 permanecen sin cambio.
32. No se añaden direct membership write policies ni AuditEvent table privileges a `authenticated`.
33. Los tests DB de topología/security mode/grants/search_path/owner = PASS.
34. Los tests de no-routability Data API de la internal function = PASS.
35. Los tests de matriz funcional TASK-014 = PASS.
36. Los tests de disabled membership visibility/fail-closed = PASS.
37. Los tests cross-identity/caller-controlled input = PASS.
38. Los tests de cero writes = PASS.
39. Los tests de no service-role/generic privileged client = PASS.
40. TASK-009 DB/RLS regression = PASS.
41. TASK-010 AuditEvent foundation regression = PASS.
42. TASK-011 Auth SSR regression = PASS.
43. TASK-012 authorization regression = PASS.
44. TASK-013/E2 regression = PASS.
45. TASK-014 global authorization regression = PASS.
46. `npm run lint` = PASS.
47. `npm run typecheck` = PASS.
48. `npm run test` = PASS.
49. `npm run build` = PASS.
50. `npm run verify` = PASS conforme al repo real.
51. `git diff --check` = PASS.
52. Secret scan/diff review = PASS.
53. Local implementation review = APPROVED.
54. Hosted Development mutation Gate = separately APPROVED.
55. Hosted Development migration apply = PASS.
56. Hosted Development Exposed schemas verification = PASS.
57. Hosted Development internal schema remains non-exposed = PASS.
58. Hosted Development wrapper security mode = INVOKER.
59. Hosted Development internal security mode = DEFINER.
60. Hosted Development owner verification = PASS.
61. Hosted Development search_path/object-resolution verification = PASS.
62. Hosted Development privilege/grant verification = PASS.
63. Hosted Development TASK-014 behavior matrix = PASS.
64. Hosted Development RLS/isolation regression = PASS.
65. Hosted Development unexpected schema/function/grant/config diff = NONE.
66. Staging remains unchanged unless a later separate Gate authorizes it.
67. Production remains unchanged unless a later separate Gate authorizes it.
68. Commit Gate = separately APPROVED.
69. Push Gate = separately APPROVED.
70. Exact remote commit verification = PASS.
71. Final implementation diff/review confirms no TASK-015 capability was implemented.
72. Future TASK-015 corrected contract is preserved for its later implementation Gate.
73. `TASK-015 implementation authorized` remains false unless a distinct later human authorization exists.
74. `TASK-016` remains not determined/generated/started.
75. All `AC-021-001..AC-021-126` = PASS.
76. Blockers = NONE at technical closure.
77. Final human closure of CORR-021 = APPROVED.
78. `CORR-021 = DONE / CLOSED` is declared only after final human closure.
79. `CORR-021 DONE != TASK-015 implementation authorized` remains explicitly true.

---

## 42. Future Codex task shape

Codex is not authorized now.

A future implementation prompt must specify:

- objective: TASK-014 remediation only;
- context: physical source identities + provider verification + supersession map;
- scope/out-of-scope;
- expected paths;
- migration behavior;
- security/RLS;
- AC-021-001..AC-021-126;
- tests §34 + regressions §36;
- Cloud boundary;
- Git boundary;
- stop conditions §39.

No destructive command is authorized implicitly.

---

## 43. Final state

```text
CORR-021 SPECIFICATION =
APPROVED FOR EXECUTION

CORR-021 SPEC REVIEW =
APPROVED

CORR-021 HUMAN SPEC APPROVAL =
APPROVED

state =
APPROVED FOR EXECUTION

blockers =
NONE

provider contract drift =
NONE

new ADR required =
NO

implementation authorized =
NO

Codex authorized =
NO

repository writes =
NONE

Supabase Cloud writes =
NONE

Hosted Development =
NOT AUTHORIZED

Staging =
NONE

Production =
NONE

TASK-015 implementation =
BLOCKED / NOT AUTHORIZED

TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED

next gate =
CORR-021 APPROVED ARTIFACT REVIEW
```

RETURN TO REVISOR CENTRAL.
