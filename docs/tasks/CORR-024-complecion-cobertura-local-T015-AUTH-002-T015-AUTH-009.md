# CORR-024 — Compleción de cobertura local T015-AUTH-002 y T015-AUTH-009 previa a Hosted authorization tests

## 1. Identificación

**ID:** `CORR-024`

**Título:** `CORR-024 — Compleción de cobertura local T015-AUTH-002 y T015-AUTH-009 previa a Hosted authorization tests`

**Tipo:** `TEST-ONLY CORRECTION / LOCAL AUTHORIZATION COVERAGE CORRECTION`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context:** `Identity & Authorization`

**Generation Gate:** `AUTHORIZED`

**Estado de esta generación:** `SPECIFICATION APPROVED / DOCUMENT APPROVAL GENERATED`

```text
CORR-024 SPEC REVIEW = APPROVED
CORR-024 HUMAN SPEC APPROVAL = APPROVED
CORR-024 APPROVED ARTIFACT REVIEW = APPROVED
CORR-024 CANONICALIZATION GATE = AUTHORIZED
CORR-024 CANONICALIZATION = READY FOR REVIEW
CORR-024 canonicalized = YES — PENDING CANONICAL ARTIFACT REVIEW
CORR-024 IMPLEMENTATION AUTHORIZED = NO

canonical repository path =
docs/tasks/CORR-024-complecion-cobertura-local-T015-AUTH-002-T015-AUTH-009.md
```

La canonicalización documental no equivale a incorporación física al repositorio. La incorporación al repository path previsto permanece no autorizada y no realizada.

**Implementación realizada:** `NO`

**Codex autorizado:** `NO`

**Repositorio modificado:** `NO`

**Test SQL modificado:** `NO`

**Test execution:** `NO`

**Supabase Cloud / Hosted Development modificado:** `NO`

**PAT / JIT:** `NO / NO`

**Migration / RLS / grants modificados:** `NO / NO / NO`

**Git add / staging / commit / push:** `NO / NO / NO / NO`

**TASK-016:** `NOT DETERMINED / NOT GENERATED / NOT STARTED`

---

## 2. Resultado de la reanudación

El blocker aprobado de fuentes repository-current queda resuelto para análisis read-only.

Verificación desde bytes físicos reales:

| Source | Filename físico | SHA-256 físico | Byte size | Resultado |
|---|---|---|---:|---|
| SOURCE 1 | `task_015_company_membership_lifecycle_audit_event_atomic.test.sql` | `7231294f77d0a855c7d965019385ddf232a9a459243a932718dd7001f5d8fd05` | `28361` | `MATCH / PASS` |
| SOURCE 2 | `20260909000205_task_015_company_membership_lifecycle_audit_event_atomic.sql` | `358e1f8d71366111d8230e6e1b5515a9e9a1660c29590ff685b88977eb4aa434` | `8609` | `MATCH / PASS` |
| SOURCE 3 | `corr_023_local_db_regression.ps1` | `6fdf38b9c784a93b9832a5c38465a536ecb28a1dd71556ba09bfed8af1e2c562` | `24453` | `MATCH / PASS` |
| BASE CORR-024 | `CORR-024-complecion-cobertura-local-T015-AUTH-002-T015-AUTH-009.md` | `422e96fcfa3e92185e29bc2d71132e8406a9efb3a4320de52897005624ced873` | `33676` | `MATCH / PASS` |

Por tanto:

```text
REQUIRED CURRENT IMPLEMENTATION SOURCE UNAVAILABLE = RESOLVED
REQUIRED CURRENT SOURCE IDENTITY MISMATCH = NO
```

La inspección física permite cerrar los puntos A–H y confirma:

```text
AUTH-009 completion = TEST-ONLY
PRODUCT CONTRACT CHANGE REQUIRED = NO
product migration mutation = NONE
production TypeScript mutation = NONE
schema/RLS/grant mutation = NONE
Hosted mutation = NONE
```

La misma inspección demuestra que el regression runner repository-current debe permanecer compatible con el nuevo plan TASK-015:

```text
SOURCE 1 current plan = 81
required new assertion delta = +12
required new plan = 93

SOURCE 3 current hard-coded TASK-015 plan contract = 81
SOURCE 3 current hard-coded ExpectedTests = 81
```

SOURCE 3 contiene físicamente:

- un guard que exige exactamente `select plan(81);`;
- una ejecución de TASK-015 con `-ExpectedTests 81`;
- una línea de evidencia que declara `plan=81; executed=81; ... Tests=81`.

El Revisor Central ha resuelto esta necesidad a nivel de specification scope autorizando exactamente dos mutable paths test-only:

```text
supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql
supabase/tests/database/corr_023_local_db_regression.ps1
```

La futura mutación permitida de SOURCE 3 queda limitada exactamente a mantener compatibilidad con el nuevo plan TASK-015:

```text
plan(81) contract guard → plan(93) contract guard
-ExpectedTests 81 → -ExpectedTests 93
PASS evidence plan/executed/Tests 81 → 93
```

No se autoriza ningún refactor, cleanup ni cambio lógico adicional en SOURCE 3. Cualquier tercer path requiere `STOP + RETURN TO REVISOR CENTRAL`.

Resultado de la reanudación:

```text
specification source blocker = RESOLVED
product contract blocker = NO
AUTH-009 test-only feasibility = CONFIRMED
A–H = RESOLVED
SECOND MUTABLE PATH REQUIRED = YES
SECOND PATH APPROVED IN SPECIFICATION SCOPE = YES
CORR-024 IMPLEMENTATION AUTHORIZED = NO
```

Esta decisión amplía exclusivamente el specification scope test-only. No autoriza implementación, no reabre CORR-023 y no crea CORR-025.

---

## 3. Contexto autoritativo consumido

### 3.1 TASK-015 canonical specification

Fuente física disponible:

```text
docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md
```

Archivo disponible en este Gate:

```text
TASK-015-company-membership-lifecycle-audit-event-atomic.md
```

SHA-256 verificado desde bytes físicos:

```text
c00a9018a7d3293e5beff8fa3422f930d2a62a4078aa7b25a4e7d9f519f77e20
```

Resultado:

```text
TASK-015 CANONICAL SOURCE INTEGRITY = PASS
```

La fuente canónica fija la capability exclusivamente como:

```text
disable / reinstate / role-change autoritativos de CompanyMembership
por COMPANY_ADMIN autorizado del mismo tenant
con AuditEvent obligatorio y atómico para cada mutación real
```

Operaciones:

```text
DISABLE
REINSTATE
CHANGE_ROLE
```

La autoridad vigente debe provenir de PostgreSQL y prevalecer sobre:

```text
JWT / session / cookies / frontend / caller-supplied authority
```

### 3.2 Estado humano recibido para CORR-024

Se consume como determinación humana de entrada:

```text
CORR-024 DETERMINATION = REQUIRED
```

Se consume además como estado de Gate:

```text
DoD 51 Hosted migration apply = PASS
DoD 52 Hosted function/grant inspection = PASS
DoD 53 Hosted authorization tests = PENDING / NOT AUTHORIZED

historical local DB test execution = 81/81 PASS

DoD 47 DB/RLS tests locales = REOPENED FOR REVALIDATION
DoD 49 local implementation review = REOPENED FOR REVALIDATION

Hosted rollback required = NO
```

Este documento no revalida esos resultados mediante ejecución; los consume como estado formal recibido para el Generation Gate.

### 3.3 Discovery que origina CORR-024

Se consume como discovery humano aprobado para esta determinación:

```text
T015-AUTH-002 = INCOMPLETE COVERAGE
T015-AUTH-009 = INCOMPLETE COVERAGE
```

La corrección buscada debe ser `TEST-ONLY` y no puede utilizar el discovery como sustituto de la inspección del test físico cuando se requiere exactitud sobre fixtures, assertions, `plan()` o contexto de sesión.

---

## 4. Objetivo único de CORR-024

CORR-024 debe completar exclusivamente la cobertura local canónica de:

```text
T015-AUTH-002
T015-AUTH-009
```

antes de que pueda reconsiderarse la autorización de:

```text
DoD 53 Hosted authorization tests
```

La finalidad es restaurar evidencia local confiable de que:

1. un `TECHNICIAN` habilitado no puede ejecutar ninguna de las tres operaciones TASK-015; y
2. tenant/role/actor state afirmados por el caller no sustituyen la autoridad derivada de `auth.uid()` + PostgreSQL vigente.

CORR-024 no cambia comportamiento de producto.

---

## 5. Fuentes obligatorias y disponibilidad

### 5.1 Fuente canónica A — TASK-015

```text
AVAILABLE / VERIFIED
```

La fuente canónica fija la semántica, límites, autoridad e inputs máximos del RPC.

### 5.2 SOURCE 1 — current TASK-015 DB test

Repo-relative path autoritativo:

```text
supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql
```

Archivo físico inspeccionado:

```text
task_015_company_membership_lifecycle_audit_event_atomic.test.sql
```

Identidad física:

```text
SHA-256 =
7231294f77d0a855c7d965019385ddf232a9a459243a932718dd7001f5d8fd05

bytes =
28361
```

Resultado:

```text
SOURCE 1 IDENTITY = PASS
```

Hechos físicos relevantes:

- top-level transaction: `begin;` en línea física 3;
- current pgTAP plan: `select plan(81);` en línea física 5;
- fixtures de `CompanyMembership`: líneas físicas 59–76;
- context de identidad: `request.jwt.claim.sub`;
- metadata de role ya existente: `request.jwt.claim.company_role`;
- `finish()` en línea física 833;
- final `rollback;` en línea física 835;
- `COMMIT` top-level nuevo: inexistente.

### 5.3 SOURCE 2 — current TASK-015 migration

Repo-relative path autoritativo:

```text
supabase/migrations/20260909000205_task_015_company_membership_lifecycle_audit_event_atomic.sql
```

Archivo físico inspeccionado:

```text
20260909000205_task_015_company_membership_lifecycle_audit_event_atomic.sql
```

Identidad física:

```text
SHA-256 =
358e1f8d71366111d8230e6e1b5515a9e9a1660c29590ff685b88977eb4aa434

bytes =
8609
```

Resultado:

```text
SOURCE 2 IDENTITY = PASS
```

Hechos físicos relevantes:

- firma private: tres parámetros exactos `uuid,text,text`;
- firma public: tres parámetros exactos `uuid,text,text`;
- actor identity se obtiene mediante `auth.uid()` en líneas físicas 50 y 97;
- actor tenant, role e `is_enabled` se leen de PostgreSQL;
- target queda limitado a `target_membership.maintenance_company_id = v_maintenance_company_id`;
- no existen referencias a `request.jwt.*`;
- no existe `current_setting(...)`;
- no existe input de actor ID, tenant ID, current role o current enabled state.

### 5.4 SOURCE 3 — current local regression command authority

Repo-relative path autoritativo:

```text
supabase/tests/database/corr_023_local_db_regression.ps1
```

Archivo físico inspeccionado:

```text
corr_023_local_db_regression.ps1
```

Identidad física:

```text
SHA-256 =
6fdf38b9c784a93b9832a5c38465a536ecb28a1dd71556ba09bfed8af1e2c562

bytes =
24453
```

Resultado:

```text
SOURCE 3 IDENTITY = PASS
```

SOURCE 3 es autoridad física para:

- paths de suites DB actuales;
- forma de invocar `npx supabase test db`;
- caso especial TASK-013 con admin URL derivada por el runner;
- suite de concurrencia TASK-015;
- broader regression `npm run test|lint|typecheck|build|verify` cuando el script existe;
- `git diff --check`;
- current TASK-015 plan contract `81`.

No se inventan comandos externos a esa superficie.

---

## 6. Revisión de contradicciones

### 6.1 Contradicción de producto

```text
DETECTED = NO
```

El canon exige `T015-AUTH-002` y `T015-AUTH-009`; completar cobertura negativa no cambia producto.

### 6.2 Contradicción arquitectónica

```text
DETECTED = NO
```

La corrección preserva `auth.uid()` como identity anchor, PostgreSQL vigente como autoridad, same-tenant dentro del RPC y RLS existente.

### 6.3 Necesidad demostrada de cambiar contrato RPC

```text
DETECTED = NO
```

SOURCE 2 confirma físicamente que las únicas entradas de negocio son:

```text
p_target_company_membership_id
p_operation
p_requested_role
```

y que actor/tenant/current role no son inputs. `AUTH-009` puede completarse sin modificar esa firma.

### 6.4 Resolución física de scope de implementación

```text
SECOND MUTABLE PATH REQUIRED = YES
SECOND PATH APPROVED IN SPECIFICATION SCOPE = YES
CORR-024 IMPLEMENTATION AUTHORIZED = NO
```

SOURCE 1 confirma `plan(81)`. El diseño mínimo source-backed de CORR-024 añade `12` pgTAP assertions, por lo que el nuevo plan exacto debe ser `93`.

SOURCE 3, simultáneamente:

1. exige físicamente que SOURCE 1 contenga exactamente `select plan(81);`;
2. invoca TASK-015 con `-ExpectedTests 81`;
3. reporta evidencia fija `plan=81; executed=81; failed=0; Tests=81`.

Por decisión del Revisor Central, el specification scope físico queda limitado exactamente a:

```text
supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql
supabase/tests/database/corr_023_local_db_regression.ps1
```

La inclusión del segundo path deja de ser blocker documental/de governance. Su futura mutación queda restringida exclusivamente a los tres ajustes de contrato `81 → 93` definidos en CORR-024. Cualquier tercer path requiere `STOP + RETURN TO REVISOR CENTRAL`.

Esta resolución no autoriza implementación.

---

## 7. Análisis obligatorio A–H — reanudado con evidencia física

### A. Fixtures físicos existentes adecuados para AUTH-002

SOURCE 1 contiene el actor reutilizable exacto:

```text
auth subject =
95000000-0000-4000-8000-000000000005

PlatformUser =
15000000-0000-4000-8000-000000000105

CompanyMembership =
15000000-0000-4000-8000-000000001105

maintenance_company_id =
15000000-0000-4000-8000-000000000001

role =
TECHNICIAN

is_enabled =
true
```

Evidencia física:

- mapping subject → PlatformUser en SOURCE 1 línea 51;
- membership en SOURCE 1 línea 71;
- el mismo actor ya se utiliza para `T015-AUTH-008` en líneas 289–296.

Por tanto:

```text
AUTH-002 actor fixture =
membership 15000000-0000-4000-8000-000000001105
```

Targets existentes adecuados, sin fixture nuevo:

**DISABLE target**

```text
CompanyMembership =
15000000-0000-4000-8000-000000001103

tenant =
15000000-0000-4000-8000-000000000001

role =
TECHNICIAN

is_enabled =
true

PlatformUser.is_super_admin =
false
```

**REINSTATE target**

```text
CompanyMembership =
15000000-0000-4000-8000-000000001104

tenant =
15000000-0000-4000-8000-000000000001

role =
TECHNICIAN

is_enabled =
false

PlatformUser.is_super_admin =
false
```

**CHANGE_ROLE target**

```text
CompanyMembership =
15000000-0000-4000-8000-000000001103

requested_role =
COMPANY_ADMIN
```

Estos targets son same-tenant, existentes, non-self, no global+tenant inconsistent y usan un requested role válido.

SOURCE 2 demuestra además que la validación del actor ocurre antes de resolver target: role actual distinto de `COMPANY_ADMIN` retorna `AUTHORIZATION_DENIED` antes del lookup de target. Con los targets anteriores, la causalidad queda igualmente limpia y no depende de una segunda denegación accidental.

Fixture adicional requerido:

```text
NONE
```

### B. Assertions físicas mínimas exactas para AUTH-002

Ubicación propuesta dentro de SOURCE 1:

```text
después del bloque de invalid-input que termina actualmente en línea 287
y antes del current T015-AUTH-008 que comienza en línea 289
```

Antes del primer caso se debe:

```text
set local role authenticated
request.jwt.claim.sub = 95000000-0000-4000-8000-000000000005
request.jwt.claim.company_role = empty/reset
```

El reset de `company_role` utiliza el mismo campo físico ya existente; no crea una claim nueva.

Se requieren exactamente **9 nuevas pgTAP assertions** para AUTH-002:

**NEW-001 — `T015-AUTH-002.a`**

```text
actor = enabled TECHNICIAN 001105
operation = DISABLE
target = 001103
expected =
outcome DENIED
changed false
reason AUTHORIZATION_DENIED
```

**NEW-002 — `T015-AUTH-002.b`**

Después de `reset role`, inspección autoritativa directa:

```text
target 001103 remains:
role = TECHNICIAN
is_enabled = true
```

**NEW-003 — `T015-AUTH-002.c`**

```text
matching AuditEvent count = 0
actor_platform_user_id = 000105
subject_platform_user_id = 000103
action = USER_DISABLED_OR_REVOKED
```

**NEW-004 — `T015-AUTH-002.d`**

```text
actor = enabled TECHNICIAN 001105
operation = REINSTATE
target = 001104
expected =
outcome DENIED
changed false
reason AUTHORIZATION_DENIED
```

**NEW-005 — `T015-AUTH-002.e`**

Después de `reset role`:

```text
target 001104 remains:
role = TECHNICIAN
is_enabled = false
```

**NEW-006 — `T015-AUTH-002.f`**

```text
matching AuditEvent count = 0
actor_platform_user_id = 000105
subject_platform_user_id = 000104
action = USER_REINSTATED
```

**NEW-007 — `T015-AUTH-002.g`**

```text
actor = enabled TECHNICIAN 001105
operation = CHANGE_ROLE
target = 001103
requested_role = COMPANY_ADMIN
expected =
outcome DENIED
changed false
reason AUTHORIZATION_DENIED
```

**NEW-008 — `T015-AUTH-002.h`**

Después de `reset role`:

```text
target 001103 remains:
role = TECHNICIAN
is_enabled = true
```

**NEW-009 — `T015-AUTH-002.i`**

```text
matching AuditEvent count = 0
actor_platform_user_id = 000105
subject_platform_user_id = 000103
action = USER_ROLE_CHANGED
```

Los checks de `AuditEvent` son parte expresa del contrato previo válido de CORR-024 para denials locales; no constituyen ejecución de Hosted DoD 54.

### C. Significado canónico exacto de AUTH-009

Se preserva sin cambio el significado del artefacto base:

```text
caller-supplied tenant/role/actor state
must not replace
auth.uid() + current PostgreSQL authority
```

Con SOURCE 1 y SOURCE 2 disponibles, ese significado se concreta así:

```text
actor identity =
request.jwt.claim.sub only insofar as auth.uid() resolves it
→ authoritative PlatformUser mapping in DB

actor role =
current CompanyMembership.role in DB

actor enabled =
current CompanyMembership.is_enabled in DB

actor tenant =
current CompanyMembership.maintenance_company_id in DB

target tenant =
current target CompanyMembership.maintenance_company_id in DB

caller role metadata =
non-authoritative
```

AUTH-009 no exige que exista un fake actor field o tenant field. Si el contrato no ofrece esos canales, su ausencia forma parte de la prueba de que el caller no puede suministrar esa authority.

### D. Campos JWT/request/context reales utilizables

Inspección física de SOURCE 1:

```text
existing identity context =
request.jwt.claim.sub

existing non-authoritative role metadata =
request.jwt.claim.company_role
```

No se encontró en SOURCE 1:

```text
request.jwt.claim.tenant_id
request.jwt.claim.maintenance_company_id
request.jwt.claim.actor_id
request.jwt.claim.platform_user_id
actor_id request GUC
tenant request GUC
```

No se encontró en SOURCE 2:

```text
request.jwt.*
current_setting(...)
```

SOURCE 2 usa `auth.uid()` directamente en dos puntos de revalidación.

Clasificación exacta:

**Role influence attempt**

```text
VALID PHYSICAL REPRESENTATION =
request.jwt.claim.company_role

misleading value already used by current harness =
COMPANY_ADMIN
```

**Tenant influence attempt**

```text
SEPARATE PHYSICAL CALLER FIELD =
NONE
```

No se inventa una claim tenant. La cobertura se obtiene mediante:

- `T015-DB-STATIC-008A`: la firma sólo posee los tres business inputs;
- `T015-TGT-002`: un target cross-tenant no se vuelve accesible por conocer su ID;
- SOURCE 2: same-tenant se deriva de `v_maintenance_company_id` de la membership del actor y se aplica al lookup del target.

**Actor influence attempt**

```text
SEPARATE PHYSICAL FAKE ACTOR FIELD =
NONE
```

`request.jwt.claim.sub` no es un fake caller actor field; es la representación física usada por `auth.uid()` y cambiarla cambia la identidad autenticada efectiva.

La cobertura se obtiene mediante:

- `T015-DB-STATIC-008A`: no existe actor ID input;
- `T015-DB-STATIC-019`: la implementación contiene `auth.uid()`;
- SOURCE 2: `auth.uid()` se resuelve y revalida dos veces contra `platform_user_auth_subjects`.

Distinción obligatoria preservada:

```text
request.jwt.claim.sub / auth.uid()
!=
fake caller-supplied actor authority
```

### E. Determinación definitiva de AUTH-009

Resultado:

```text
AUTH-009 completion = TEST-ONLY
PRODUCT CONTRACT CHANGE WOULD BE REQUIRED = NO
```

No se requiere:

- cambiar firma RPC;
- añadir `actor_id`;
- añadir `tenant_id`;
- añadir `current_role`;
- aceptar authority desde caller;
- cambiar migration;
- cambiar RLS;
- cambiar grants;
- inventar claim semantics.

La cobertura integral de AUTH-009 debe componerse de evidencia ya existente + 3 nuevas assertions dedicadas.

Evidencia existente reutilizada:

```text
T015-DB-STATIC-008A
RPC has only the three approved business inputs

T015-AUTH-008
stale admin claim does not override DB TECHNICIAN authority

T015-TGT-002
cross-tenant target receives opaque denial

T015-DB-STATIC-019
implementation has ... auth.uid ... and no dynamic SQL
```

Baseline comparativo:

```text
AUTH-002 DISABLE baseline
actor sub = 000005
DB actor = enabled TECHNICIAN
company_role metadata = empty/reset
target = 001103
result = DENIED / changed=false / AUTHORIZATION_DENIED
```

Contexto engañoso:

```text
same request.jwt.claim.sub = 000005
same PostgreSQL state
same target = 001103
same operation = DISABLE
request.jwt.claim.company_role = COMPANY_ADMIN
```

Nuevas assertions dedicadas:

**NEW-010 — `T015-AUTH-009.a`**

```text
misleading existing company_role metadata
→ outcome DENIED
→ changed false
→ reason AUTHORIZATION_DENIED
```

El resultado debe ser idéntico al baseline AUTH-002 para el mismo actor/target/estado DB.

**NEW-011 — `T015-AUTH-009.b`**

Después de `reset role`:

```text
target 001103 remains:
role = TECHNICIAN
is_enabled = true
```

**NEW-012 — `T015-AUTH-009.c`**

```text
matching AuditEvent count remains 0
actor_platform_user_id = 000105
subject_platform_user_id = 000103
action = USER_DISABLED_OR_REVOKED
```

Después del escenario se debe limpiar `request.jwt.claim.company_role` usando el mismo key ya existente antes de continuar con el siguiente actor del archivo.

### F. Preservación exacta single-transaction + ROLLBACK

SOURCE 1 confirma:

```text
line 3   = begin;
line 5   = select plan(81);
line 833 = select * from finish();
line 835 = rollback;
```

La corrección debe insertar las assertions dentro de esa misma transacción.

Mecanismo exacto:

1. no añadir `BEGIN`;
2. no añadir `COMMIT`;
3. utilizar los `set local role authenticated` / `reset role` ya usados por el harness;
4. utilizar `set_config(..., true)` para contexto transaction-local, igual que el archivo vigente;
5. realizar outcome checks bajo `authenticated`;
6. realizar state/audit postchecks después de `reset role`, igual que los bloques actuales que necesitan visibilidad directa;
7. restablecer/limpiar `request.jwt.claim.company_role` después de AUTH-009;
8. conservar `finish()` y el `rollback;` final sin cambio semántico;
9. no crear fixtures persistentes ni helpers productivos.

No se requiere savepoint adicional.

### G. Impacto exacto de pgTAP `plan()`

SOURCE 1 confirma físicamente:

```text
current physical plan =
81
```

Nueva assertions enumeradas:

```text
AUTH-002 =
NEW-001
NEW-002
NEW-003
NEW-004
NEW-005
NEW-006
NEW-007
NEW-008
NEW-009
= 9

AUTH-009 =
NEW-010
NEW-011
NEW-012
= 3
```

Por tanto:

```text
exact assertion delta =
12

old physical plan =
81

new exact plan =
81 + 12 = 93
```

Contrato futuro exacto:

```text
select plan(93);
```

No se elimina ni reemplaza ninguna de las 81 assertions vigentes para obtener ese número.

### H. Comandos repository-current exactos y efecto de SOURCE 3

SOURCE 3 construye las suites DB mediante:

```text
npx supabase test db <relative-path>
```

salvo TASK-013, para la cual añade:

```text
--db-url <runner-derived AdminDbUrl>
```

#### H.1 Corrected TASK-015 DB test

Comando exacto derivado de `Invoke-Corr023DbSuite` + `$task015Path`:

```text
npx supabase test db supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql
```

Resultado requerido después de una futura implementación autorizada:

```text
Files = 1
Result: PASS
Tests = 93
bad plan = NO
failed test = NO
```

#### H.2 Complete applicable local DB/RLS regression

SOURCE 3 fija el orden:

```text
npx supabase test db supabase/tests/database/task_009_identity_tenant_foundation.test.sql

npx supabase test db supabase/tests/database/task_010_audit_event_foundation.test.sql

npx supabase test db --db-url <runner-derived AdminDbUrl> supabase/tests/database/task_013_verification_challenge_foundation.test.sql

npx supabase test db supabase/tests/database/task_014_global_identity_authorization_foundation.test.sql

npx supabase test db supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql
```

SOURCE 3 ejecuta además TASK-015 concurrency mediante `pwsh.exe` con arguments exactos:

```text
-NoLogo
-NoProfile
-NonInteractive
-File <repo-root>\supabase\tests\database\task_015_company_membership_lifecycle_concurrency.test.ps1
```

y con `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD` suministrados internamente por el runner. CORR-024 no materializa ni imprime el password.

Resultado requerido:

```text
TASK-015 CONCURRENCY HARNESS = PASS
T015-CON-001..006 = PASS
full local DB regression = PASS
```

#### H.3 Broader applicable regression

SOURCE 3 itera exactamente, cuando cada script existe en `package.json`:

```text
npm run test
npm run lint
npm run typecheck
npm run build
npm run verify
```

Un script ausente se reporta por el runner como:

```text
NOT APPLICABLE / SCRIPT ABSENT IN CURRENT REPO
```

CORR-024 no afirma cuál de esos scripts existe sin una fuente adicional; preserva la selección dinámica de SOURCE 3.

#### H.4 Diff / quality check

SOURCE 3 ejecuta exactamente:

```text
git diff --check
```

CORR-024 conserva además el requisito de governance ya aprobado de verificar expected-only paths antes de staging. La presente reanudación no ejecuta ningún comando.

#### H.5 Incompatibilidad física del runner

SOURCE 3 contiene hoy:

```text
plan(81) contract guard
ExpectedTests 81
PASS evidence hard-coded to plan/executed/Tests 81
```

Con SOURCE 1 futuro en `plan(93)`, SOURCE 3 sin cambios falla antes de certificar la regresión completa.

La futura mutación permitida de SOURCE 3 queda limitada exactamente a:

```text
plan(81) contract guard → plan(93) contract guard
-ExpectedTests 81 → -ExpectedTests 93
PASS evidence plan/executed/Tests 81 → 93
```

No se autoriza refactor, cleanup ni cambio lógico adicional. Esto no se implementa en este Gate.

Conclusión H:

```text
commands = RESOLVED / SOURCE-BACKED
full runner compatibility after plan change = SECOND MUTABLE PATH REQUIRED
SECOND PATH APPROVED IN SPECIFICATION SCOPE = YES
CORR-024 IMPLEMENTATION AUTHORIZED = NO
```

---

## 8. Diseño de corrección permitido por specification scope

Esta sección fija límites, no implementación ejecutable.

### 8.1 Mutable paths aprobados en specification scope

Exactamente dos paths:

```text
supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql
supabase/tests/database/corr_023_local_db_regression.ps1
```

No existe tercer path autorizado.

### 8.2 Restricción exacta de SOURCE 3

La inspección física demostró necesidad del segundo path para conservar compatible el regression runner repository-current:

```text
SOURCE 1 required plan = 93
SOURCE 3 hard-coded plan contract = 81
```

La futura mutación permitida de SOURCE 3 se limita exactamente a:

```text
1. plan(81) contract guard → plan(93) contract guard
2. -ExpectedTests 81 → -ExpectedTests 93
3. PASS evidence plan/executed/Tests 81 → 93
```

No se autoriza refactor, cleanup ni cambio lógico adicional en SOURCE 3.

Estado:

```text
SECOND MUTABLE PATH REQUIRED = YES
SECOND PATH APPROVED IN SPECIFICATION SCOPE = YES
CORR-024 IMPLEMENTATION AUTHORIZED = NO
```

Cualquier tercer path requiere `STOP + RETURN TO REVISOR CENTRAL`. CORR-023 no se reabre y no se crea CORR-025.

### 8.3 Migration

```text
mutation = NONE
```

### 8.4 Production TypeScript

```text
mutation = NONE
```

### 8.5 Schema / RLS / grants / policies

```text
mutation = NONE
```

### 8.6 Hosted

```text
mutation = NONE
```

### 8.7 Test setup

Sólo se permite reutilizar fixtures ya existentes o añadir el fixture mínimo estrictamente necesario dentro del test si, después de inspección física, no existe un fixture válido reutilizable.

Una fixture addition:

```text
test-only disposable setup
!= product capability
```

y debe quedar cubierta por el mismo `ROLLBACK` final.

---

## 9. Contrato de cobertura futuro — AUTH-002

La especificación reanudada deberá nombrar físicamente el fixture exacto y demostrar los tres casos:

```text
TECHNICIAN enabled + DISABLE     → DENIED / changed=false
TECHNICIAN enabled + REINSTATE   → DENIED / changed=false
TECHNICIAN enabled + CHANGE_ROLE → DENIED / changed=false
```

Para cada caso debe comprobarse, con la granularidad pgTAP ya utilizada por el archivo:

```text
target membership unauthorized state mutation = NONE
new matching AuditEvent = 0
```

No se utilizará cross-tenant, self-target, target inexistente ni role inválido como sustituto del denial por actor `TECHNICIAN`.

---

## 10. Contrato de cobertura futuro — AUTH-009

La implementación test-only futura debe construir una prueba comparativa contra el mismo actor autenticado real y el mismo estado PostgreSQL autoritativo.

Patrón semántico requerido:

```text
baseline request context
→ authoritative result R

same auth.uid() / same PostgreSQL state
+ misleading caller-supplied non-authoritative context already supported by harness
→ same authoritative result R
```

Debe incluir únicamente representaciones físicas existentes y justificadas para:

```text
role influence attempt
tenant influence attempt
actor influence attempt
```

La prueba no puede convertir un claim sintético nuevo en requisito de producto.

Debe quedar demostrado que:

```text
current DB actor identity/tenant/role/state wins
```

Y que el contexto manipulado no puede producir:

```text
unauthorized APPLIED
unauthorized ALREADY_SATISFIED
cross-tenant mutation
wrong actor audit attribution
wrong tenant audit attribution
```

Cuando el outcome autoritativo esperado sea `DENIED`, debe comprobarse además ausencia de mutation y de `AuditEvent`.

Cuando la prueba comparativa utilice un caso permitido/no-op para demostrar invariancia, el baseline y el contexto manipulado deben producir exactamente la misma clase de outcome y el mismo estado final autoritativo.

La selección concreta del escenario debe derivarse del archivo físico para no duplicar o interferir con fixtures existentes.

---

## 11. Seguridad y multitenancy

CORR-024 debe preservar sin modificación:

```text
tenant = MaintenanceCompany
authenticated != authorized
auth.uid() = identity anchor
current PostgreSQL state = authority
RLS = primary remote isolation boundary
same-tenant enforcement = inside RPC
service-role ordinary caller = NO
provider Auth mutation = NO
direct auth.sessions access = NO
new table-write grants = 0
```

No se autoriza que un test “facilite” AUTH-009 introduciendo un nuevo camino que el producto pueda interpretar como autoridad.

Los datos de request/JWT manipulados por el test son adversarial inputs; su función es demostrar que no gobiernan tenant authorization.

---

## 12. Offline / UI / provider behavior

```text
offline behavior change = NONE
UI change = NONE
provider Auth change = NONE
```

CORR-024 no crea outbox, no modifica sesiones y no introduce un nuevo flow de autenticación.

---

## 12.1 Resultado de readiness tras reanudación

Los requisitos válidos de seguridad, multitenancy, offline/UI/provider y governance permanecen sin cambios.

La necesidad física del segundo path ha sido resuelta por decisión del Revisor Central a nivel de specification scope:

```text
SECOND MUTABLE PATH REQUIRED = YES
SECOND PATH APPROVED IN SPECIFICATION SCOPE = YES
CORR-024 IMPLEMENTATION AUTHORIZED = NO
```

El specification scope queda limitado exactamente a los dos paths test-only autorizados. Cualquier tercer path requiere revisión humana previa.

El estado operativo permanece:

```text
CORR-024 implementation authorization = NO
DoD 47 = REOPENED FOR REVALIDATION
DoD 49 = REOPENED FOR REVALIDATION
DoD 53 = PENDING / NOT AUTHORIZED
```

---

## 13. Acceptance Criteria de CORR-024

Todos los criterios deberán evaluarse individualmente como `PASS` o `FAIL` después de aprobar/canonicalizar cuando corresponda y autorizar separadamente la implementación.

### Governance / sources

**AC-024-001.** El ID permanece `CORR-024`.

**AC-024-002.** La corrección se limita a `T015-AUTH-002` y `T015-AUTH-009`.

**AC-024-003.** Antes de autorizar implementación se inspeccionan los bytes físicos del current TASK-015 DB test con SHA esperado `7231294f77d0a855c7d965019385ddf232a9a459243a932718dd7001f5d8fd05` o se retorna a revisión ante drift.

**AC-024-004.** Antes de autorizar implementación se inspecciona la migration current con SHA esperado `358e1f8d71366111d8230e6e1b5515a9e9a1660c29590ff685b88977eb4aa434` o se retorna a revisión ante drift.

**AC-024-005.** Se identifican por nombre/identidad física los fixtures exactos reutilizados por AUTH-002.

**AC-024-006.** Cualquier fixture adicional queda justificado como mínimo, test-only, disposable y rollback-cleaned.

### AUTH-002

**AC-024-007.** Un enabled `TECHNICIAN` recibe `DENIED` para `DISABLE`.

**AC-024-008.** Un enabled `TECHNICIAN` recibe `DENIED` para `REINSTATE`.

**AC-024-009.** Un enabled `TECHNICIAN` recibe `DENIED` para `CHANGE_ROLE`.

**AC-024-010.** Los tres casos prueban la denegación por autoridad insuficiente del actor y no por una precondición ajena seleccionada accidentalmente.

**AC-024-011.** Ninguno de los tres casos produce mutación no autorizada sobre `CompanyMembership`.

**AC-024-012.** Ninguno de los tres casos produce `AuditEvent`.

### AUTH-009

**AC-024-013.** Se documenta exactamente qué campos de JWT/request/context existentes representan el intento caller-supplied de role influence.

**AC-024-014.** Se documenta exactamente qué campo existente representa tenant influence, si existe.

**AC-024-015.** Se documenta exactamente qué representación existente corresponde a actor influence, si existe, distinguiéndola de `auth.uid()`.

**AC-024-016.** No se inventa un claim/request field nuevo sólo para satisfacer AUTH-009.

**AC-024-017.** El mismo `auth.uid()` y el mismo estado PostgreSQL producen el mismo resultado autoritativo con y sin metadata caller-supplied engañosa.

**AC-024-018.** JWT/custom role claim no cambia la autoridad DB.

**AC-024-019.** La ausencia de tenant authority input se preserva; el tenant efectivo se deriva desde PostgreSQL, el cross-tenant target denial existente continúa siendo la evidencia aplicable y se crean cero synthetic tenant claims.

**AC-024-020.** La ausencia de caller actor-id authority input se preserva; `request.jwt.claim.sub` / `auth.uid()` continúa siendo exclusivamente el identity anchor, PlatformUser se resuelve desde PostgreSQL y se crean cero synthetic actor claims.

**AC-024-021.** Si la cobertura integral exige modificar la firma RPC o añadir authority input, CORR-024 se detiene con blocker de product contract change.

### Scope / no production drift

**AC-024-022.** Los únicos mutable paths autorizados en specification scope son `supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql` y `supabase/tests/database/corr_023_local_db_regression.ps1`.

**AC-024-023.** Cualquier TERCER path fuera de los dos autorizados requiere revisión humana previa y no se incorpora silenciosamente.

**AC-024-024.** TASK-015 migration change = `NONE`.

**AC-024-025.** Production TypeScript change = `NONE`.

**AC-024-026.** Schema change = `NONE`.

**AC-024-027.** RLS/policy change = `NONE`.

**AC-024-028.** Grant/revoke change = `NONE`.

**AC-024-029.** Audit model/action change = `NONE`.

**AC-024-030.** Provider/Auth mutation = `NONE`.

**AC-024-031.** Hosted mutation = `NONE` durante CORR-024 local correction.

### Harness / plan

**AC-024-032.** El existing single-transaction harness queda preservado.

**AC-024-033.** El final `ROLLBACK` queda preservado.

**AC-024-034.** No existe `COMMIT` nuevo.

**AC-024-035.** Los context/GUC/JWT cambios de cada nuevo escenario no contaminan escenarios posteriores.

**AC-024-036.** El current physical `plan()` se lee desde Source B.

**AC-024-037.** Cada nueva pgTAP assertion se enumera exactamente.

**AC-024-038.** El nuevo `plan()` equivale exactamente al plan físico anterior + el número real de assertions nuevas.

**AC-024-039.** `plan()` y assertions ejecutadas quedan internamente consistentes.

### Local verification

**AC-024-040.** El corrected TASK-015 DB test PASS.

**AC-024-041.** La completa regresión local TASK-015 DB/RLS aplicable PASS.

**AC-024-042.** El broader regression aplicable definido por el repositorio actual PASS.

**AC-024-043.** DoD 47 DB/RLS tests locales queda revalidado `PASS`.

**AC-024-044.** DoD 49 local implementation review queda revalidado `APPROVED`.

**AC-024-045.** Los comandos exactos usados son los repository-current, documentados literalmente después de inspección física y no inventados en esta especificación.

### Git / governance

**AC-024-046.** `git diff --name-only` contiene exactamente `supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql` y `supabase/tests/database/corr_023_local_db_regression.ps1`, y ningún tercer path.

**AC-024-047.** `git diff --check = PASS`.

**AC-024-048.** Diff review demuestra `TEST-ONLY` sin product behavior drift.

**AC-024-049.** No existe staging sin Gate posterior.

**AC-024-050.** No existe commit sin Gate posterior.

**AC-024-051.** No existe push sin Gate posterior.

**AC-024-052.** DoD 53 Hosted authorization tests continúa no autorizado hasta un Gate humano posterior a la revalidación local.

**AC-024-053.** TASK-016 no se determina, genera ni inicia.

**AC-024-054.** Todos `AC-024-001..053` aplicables resultan `PASS` antes del cierre técnico de CORR-024.

---

## 14. Definition of Done de CORR-024

CORR-024 sólo podrá considerarse cerrada cuando se cumpla toda la secuencia de governance aplicable:

**DoD-024-001.** El blocker de fuentes actuales queda resuelto mediante disponibilidad física verificable de las fuentes requeridas.

**DoD-024-002.** Se reanuda la especificación desde el mismo Generation Gate sin inventar requisitos.

**DoD-024-003.** La especificación reanudada determina A–H de forma exacta y source-backed.

**DoD-024-004.** Se fija el fixture exacto de AUTH-002.

**DoD-024-005.** Se fijan las assertions físicas mínimas de AUTH-002.

**DoD-024-006.** Se fijan los campos existentes exactos de AUTH-009.

**DoD-024-007.** Se confirma `AUTH-009 completion = TEST-ONLY` o se retorna blocker de product contract change.

**DoD-024-008.** Se fija el delta exacto de pgTAP assertions y el nuevo `plan()` exacto.

**DoD-024-009.** Se fijan los comandos exactos de regresión local vigentes.

**DoD-024-010.** `CORR-024 SPEC REVIEW = APPROVED`.

**DoD-024-011.** Existe aprobación humana formal de la especificación.

**DoD-024-012.** Se genera/revisa el artefacto aprobado cuando la governance del proyecto lo requiera.

**DoD-024-013.** Se canonicaliza mediante Gate separado cuando corresponda.

**DoD-024-014.** La canonicalización supera revisión.

**DoD-024-015.** Existe autorización humana separada para implementar CORR-024.

**DoD-024-016.** La implementación modifica exclusivamente `supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql` y `supabase/tests/database/corr_023_local_db_regression.ps1`, y permanece test-only.

**DoD-024-017.** Review del diff test-only = `APPROVED`.

**DoD-024-018.** Corrected TASK-015 DB test = `PASS`.

**DoD-024-019.** Complete local TASK-015 DB/RLS regression = `PASS`.

**DoD-024-020.** Applicable broader regression = `PASS`.

**DoD-024-021.** DoD 47 = revalidated `PASS`.

**DoD-024-022.** DoD 49 = revalidated `APPROVED`.

**DoD-024-023.** Product migration mutation = `NONE`.

**DoD-024-024.** Production TypeScript mutation = `NONE`.

**DoD-024-025.** Schema/RLS/grant mutation = `NONE`.

**DoD-024-026.** Product behavior drift = `NONE`.

**DoD-024-027.** Hosted mutation durante CORR-024 = `NONE`.

**DoD-024-028.** DoD 53 permanece sujeto a un Gate humano posterior y separado.

**DoD-024-029.** Staging/commit/push ocurren únicamente si Gates posteriores los autorizan.

**DoD-024-030.** Existe cierre humano final de CORR-024.

**DoD-024-031.** El cierre de CORR-024 no determina automáticamente TASK-016.

---

## 15. Blockers de futura reanudación/implementación

La futura implementación deberá detenerse si ocurre cualquiera de los siguientes casos:

1. SHA del DB test físico no coincide con el baseline esperado sin revisión humana;
2. SHA de la migration física no coincide con el baseline esperado sin revisión humana;
3. AUTH-002 no puede cubrirse con fixtures test-only mínimos;
4. AUTH-009 exige modificar la firma RPC;
5. AUTH-009 exige aceptar tenant authority desde caller;
6. AUTH-009 exige aceptar actor authority desde caller;
7. AUTH-009 exige aceptar role authority desde caller;
8. AUTH-009 exige inventar un custom claim con nueva semántica de producto;
9. se necesita migration;
10. se necesita cambiar SQL productivo;
11. se necesita cambiar RLS/policies;
12. se necesita cambiar grants;
13. se necesita production TypeScript;
14. se necesita cambiar AuditEvent model/actions;
15. se necesita service-role ordinary caller;
16. se necesita `auth.sessions` access;
17. se necesita provider/Auth mutation;
18. se necesita Hosted mutation para completar la corrección local;
19. se necesita cualquier TERCER path fuera de `supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql` y `supabase/tests/database/corr_023_local_db_regression.ps1`;
20. el single-transaction + rollback harness no puede preservarse;
21. no puede establecerse un `plan()` exacto y consistente;
22. cualquier regresión aplicable falla;
23. el diff muestra product behavior drift;
24. cualquier AC obligatorio falla.

Ante blocker:

```text
no silent repair
no scope expansion
no migration mutation
no RLS mutation
no Hosted
no staging
no commit
no push
no TASK-016
RETURN TO REVISOR CENTRAL
```

---

## 16. Evidencia física recibida para la reanudación

Las tres fuentes requeridas están disponibles y verificadas:

```text
SOURCE 1 =
supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql
SHA-256 =
7231294f77d0a855c7d965019385ddf232a9a459243a932718dd7001f5d8fd05
bytes =
28361
identity =
PASS
```

```text
SOURCE 2 =
supabase/migrations/20260909000205_task_015_company_membership_lifecycle_audit_event_atomic.sql
SHA-256 =
358e1f8d71366111d8230e6e1b5515a9e9a1660c29590ff685b88977eb4aa434
bytes =
8609
identity =
PASS
```

```text
SOURCE 3 =
supabase/tests/database/corr_023_local_db_regression.ps1
SHA-256 =
6fdf38b9c784a93b9832a5c38465a536ecb28a1dd71556ba09bfed8af1e2c562
bytes =
24453
identity =
PASS
```

El blocker anterior:

```text
REQUIRED CURRENT IMPLEMENTATION SOURCE UNAVAILABLE
```

queda resuelto.

No se requirieron PAT, JIT, database password, service-role key, Hosted access ni secrets para esta reanudación read-only.

---

## 17. Estado de Gates

Debe permanecer:

```text
CORR-024 determination = REQUIRED
CORR-024 generation gate = AUTHORIZED
CORR-024 source blocker = RESOLVED
CORR-024 specification = READY FOR REVIEW
CORR-024 implementation authorized = NO
Codex authorized = NO
repository mutation = NO
Hosted mutation = NO
DoD 47 = REOPENED FOR REVALIDATION
DoD 49 = REOPENED FOR REVALIDATION
DoD 53 = PENDING / NOT AUTHORIZED
TASK-016 = NOT DETERMINED
```

Resolución del scope físico por decisión del Revisor Central:

```text
SECOND MUTABLE PATH REQUIRED = YES
SECOND PATH APPROVED IN SPECIFICATION SCOPE = YES

specification scope =
TWO TEST-ONLY PATHS APPROVED

implementation authorization =
NO

product behavior change =
NO

migration / production TypeScript / schema / RLS / grants / Hosted =
NONE
```

La mutación futura de SOURCE 3 queda limitada exclusivamente a los tres ajustes de contrato `81 → 93` definidos en esta especificación. Cualquier tercer path requiere `STOP + RETURN TO REVISOR CENTRAL`.

---

## 18. Conclusión

La reanudación resuelve físicamente A–H.

Resultado técnico:

```text
AUTH-002 exact actor fixture =
001105 / enabled TECHNICIAN

AUTH-002 exact new assertions =
9

AUTH-009 completion =
TEST-ONLY

AUTH-009 existing runtime metadata =
request.jwt.claim.company_role

separate tenant caller field =
NONE

separate fake actor caller field =
NONE

request.jwt.claim.sub =
auth.uid identity anchor, not fake actor authority

AUTH-009 exact new assertions =
3

current plan =
81

assertion delta =
12

required new plan =
93

migration mutation =
NONE

production TypeScript mutation =
NONE

schema/RLS/grant mutation =
NONE

Hosted mutation =
NONE
```

No se requiere cambio del contrato RPC ni nueva semántica de producto.

SOURCE 3 hace físicamente necesario un segundo path para que el regression runner repository-current acepte `plan(93)` y `Tests=93`; esa necesidad ya ha sido resuelta por decisión del Revisor Central a nivel de specification scope.

Estado final de scope y autorización:

```text
specification scope =
TWO TEST-ONLY PATHS APPROVED

implementation authorization =
NO

product behavior change =
NO

migration / production TypeScript / schema / RLS / grants / Hosted =
NONE
```

Los dos únicos mutable paths aprobados en specification scope son:

```text
supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql
supabase/tests/database/corr_023_local_db_regression.ps1
```

Cualquier tercer path requiere `STOP + RETURN TO REVISOR CENTRAL`. La futura mutación de SOURCE 3 queda limitada exactamente a los tres ajustes de contrato `81 → 93`; no se autoriza refactor, cleanup ni cambio lógico adicional.

La especificación reanudada corregida queda formalmente aprobada. La implementación continúa no autorizada.

No se implementó.
No se modificó el repositorio.
No se ejecutaron tests.
No se ejecutó psql.
No se modificó Supabase Cloud.
No se hizo staging, commit ni push.
TASK-016 permanece no determinada.

CORR-024 APPROVED ARTIFACT REVIEW = APPROVED
CORR-024 CANONICALIZATION GATE = AUTHORIZED
CORR-024 CANONICALIZATION = READY FOR REVIEW
CORR-024 canonicalized = YES — PENDING CANONICAL ARTIFACT REVIEW
CORR-024 IMPLEMENTATION AUTHORIZED = NO

canonical repository path =
docs/tasks/CORR-024-complecion-cobertura-local-T015-AUTH-002-T015-AUTH-009.md

La canonicalización documental no equivale a incorporación física al repositorio. No se autoriza todavía copiar este artefacto a `docs/tasks/`.

CORR-024 CANONICAL ARTIFACT = READY FOR REVIEW

next action =
RETURN TO REVISOR CENTRAL FOR CORR-024 CANONICAL ARTIFACT REVIEW
