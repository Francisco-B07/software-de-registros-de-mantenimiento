# CORR-034 — Sincronización normativa de First-Admin Profile Completion previa a TASK-019

## 1. Identificación

**ID:** `CORR-034`

**Título:** `CORR-034 — Sincronización normativa de First-Admin Profile Completion previa a TASK-019`

**Clasificación:** `DOCUMENTATION / PRODUCT DECISION SYNC`

**Naturaleza:** corrección documental controlada de producto, dominio, autorización y auditoría; no constituye implementación técnica.

**Estado de esta specification:** `APPROVED`

**Archivo de entrega:** `CORR-034-first-admin-profile-completion-product-decision-sync.md`

**Ruta canónica futura propuesta:** `docs/tasks/CORR-034-first-admin-profile-completion-product-decision-sync.md`

**CORR-034 DETERMINATION:** `APPROVED — CORRECTED`

**CORR-034 DETERMINATION MINIMAL CORRECTION:** `APPROVED`

**CORR-034 SPECIFICATION REGENERATION:** `AUTHORIZED`

**CORR-034 SPECIFICATION:** `APPROVED`

**CORR-034 PRIOR SPEC REVIEW:** `RETURNED FOR CORRECTION`

**CORR-034 SPEC REVIEW:** `APPROVED`

**CORR-034 HUMAN SPEC APPROVAL:** `APPROVED`

**CORR-034 APPROVED ARTIFACT REVIEW:** `APPROVED`

**CORR-034 approved artifact:** `GENERATED`

**CORR-034 canonicalized:** `YES`

**CORR-034 repository incorporation:** `NO`

**CORR-034 execution authorized:** `NO`

**Repositorio modificado:** `NO`

**Codex autorizado:** `NO`

**Supabase modificado:** `NO`

**Staging / Production modificados:** `NO / NO`

**Git add / commit / push:** `NO / NO / NO`

**TASK-019:** `NOT DETERMINED / NOT AUTHORIZED`

**Phase 2:** `IN PROGRESS / NOT CLOSED`

**Phase 2 Exit Gate:** `NOT DEFINED / NOT SATISFIED`

**Phase 3:** `NOT STARTED`

---

## 1.1 Aprobación formal de esta specification

```text
CORR-034 SPEC REVIEW =
APPROVED

CORR-034 HUMAN SPEC APPROVAL =
APPROVED

CORR-034 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-034 specification state =
APPROVED

CORR-034 approved artifact =
GENERATED

F-034-001 =
RESOLVED

F-034-002 =
RESOLVED

F-034-003 =
RESOLVED

F-034-004 =
RESOLVED

F-034-005 =
RESOLVED

CORR-034 canonicalized =
YES

CORR-034 repository incorporation =
NO

CORR-034 execution authorized =
NO

CORR-034 execution =
NOT PERFORMED
```

La generación previa del approved artifact:

```text
!= canonicalization
!= repository incorporation
!= execution authorization
!= documentation execution
```

---

## 2. Objetivo único

CORR-034 tiene como objetivo exclusivo sincronizar en el canon activo las decisiones de producto/dominio ya aprobadas para `First-Admin Profile Completion`, antes de cualquier determinación de TASK-019.

La futura ejecución deberá modificar exactamente:

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/11-phase-1-scope-entry-gate.md
```

para que los cuatro documentos representen de forma coherente y normativa:

```text
A — profile fields =
first_name + last_name required

B — profile persistence =
PlatformUser owns first_name, last_name, profile_completed_at

C — PlatformUser timing =
created/reconciled during authoritative profile-completion transition

D — initial CompanyMembership =
NONE pre-profile;
created during successful completion;
role = COMPANY_ADMIN;
is_enabled = true

E — ordering =
Auth/session
→ /pending-profile
→ profile validation
→ PlatformUser/profile establishment
→ enabled first-admin CompanyMembership
→ USER_CREATED
→ terminal FirstAdminOnboardingIntent completion

F — completion =
single purpose-specific authoritative atomic transition

G — completion evidence =
FirstAdminOnboardingIntent remains sole durable completion authority

H — USER_CREATED =
exactly once during successful authoritative onboarding completion

I — retry/concurrency =
idempotent;
at-most-one authoritative completion outcome

J — post-profile destination =
/onboarding-complete minimal confirmation shell
```

Debe preservarse:

```text
documentation synchronization
!= implementation

product decision resolved
!= capability implemented

CORR-034 DONE
!= TASK-019 determined automatically
```

---

## 3. Contexto formal y autoridad

La specification consume como autoridad posterior y explícita:

```text
POST-CORR-033 CONTINUITY / DISCOVERY REVIEW =
APPROVED

NEXT IMPLEMENTATION INCREMENT =
BLOCKED BY PRODUCT DECISION

FIRST-ADMIN PROFILE COMPLETION PRODUCT DECISION =
APPROVED

required human product/domain decision blocker =
RESOLVED

new ADR required =
NO

documentation synchronization required =
YES

POST-FIRST-ADMIN PROFILE COMPLETION DOCUMENTATION SYNC DETERMINATION =
APPROVED

CORR-034 DETERMINATION =
APPROVED — CORRECTED

CORR-034 DETERMINATION MINIMAL CORRECTION =
APPROVED

F-034-001 =
RESOLVED BY SCOPE CORRECTION
```

La corrección mínima incorpora exclusivamente:

```text
docs/product/11-phase-1-scope-entry-gate.md
§14.2 — Condición adicional para cruzar hacia Fase 2
```

para sincronizar `USER_CREATED producer timing` sin declarar el producer implementado.

Regla de autoridad aplicable:

```text
later explicit approved product/domain decision
>
older active wording not yet synchronized
```

pero:

```text
later decision
does not rewrite
historical snapshots
```

La synchronization debe cambiar únicamente el canon activo que necesita incorporar A–J.

No debe modificar retroactivamente documentos que registraban correctamente que esas decisiones estaban diferidas en su momento.

---

## 4. Baseline físico recuperado

La generación de esta specification utiliza el paquete físico read-only:

```text
POST-CORR-033-continuity-discovery-sources.zip
```

Identidad:

```text
SHA-256 =
12deecdfa2639599c4331311aedddeb4c67834e19e1607989e871bd747cd380c

bytes =
256312

file count =
12

all entries byte-identical to recovered HEAD sources =
YES
```

Estado Git autoritativo reportado por la recuperación:

```text
repo root =
C:/Users/Lenovo/Desktop/Software de registros de mantenimiento

branch =
main

HEAD =
33625a4e2764692fa8026471e37606883e1d75a8

origin/main =
33625a4e2764692fa8026471e37606883e1d75a8

remote main =
33625a4e2764692fa8026471e37606883e1d75a8

divergence =
0 0

worktree =
CLEAN

staged =
NONE

untracked =
NONE

Git operations in progress =
NONE
```

Este baseline es autoridad de generación documental. La futura ejecución de CORR-034 deberá repetir un preflight fresco y no podrá asumir que este estado continúa vigente.

---

## 5. Fuentes físicas verificadas

| Fuente | SHA-256 | Bytes | LF | CRLF | Bare CR | Trailing WS | Final NL |
|---|---|---:|---:|---:|---:|---:|---|
| `docs/product/00-master-product-brief.md` | `bac4d1dc9edd0fab7c22416fe70b1161a166428d60e5cc73a78fec55a2f5b808` | 22606 | 545 | 0 | 0 | 0 | YES |
| `docs/product/01-product-definition.md` | `417208bdb61ab837f2153fc542faf7ea72cc695c6feb871f799996e9fb407ca9` | 66874 | 1346 | 0 | 0 | 6 | YES |
| `docs/product/02-domain-model.md` | `5b1a25e96f758fffba4f11760f3b4effbe9e0c44030c8a532970d897cb42bed3` | 93362 | 3562 | 0 | 0 | 5 | YES |
| `docs/product/03-permissions-rls-strategy.md` | `a855146e6e6727533e1b2464bc4b553af1b9bef9576facb3939071a8b9b18f05` | 92651 | 2990 | 0 | 0 | 7 | YES |
| `docs/product/10-architecture-decisions-records.md` | `20597fc5adac727869155097cbb35833a79de7cbe0d093604744c130d70d0153` | 73085 | 1937 | 0 | 0 | 19 | YES |
| `docs/product/11-phase-1-scope-entry-gate.md` | `f32b8adf574ec260d0cd244d914438660327f48cc519cef28c98b731cf438fd8` | 94543 | 1560 | 0 | 0 | 9 | YES |
| `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md` | `3c273bc22018829fdd5c70852b6338cb95009c1b7d4dc6d291dbab9ebbed3631` | 61871 | 2804 | 0 | 0 | 0 | YES |
| `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md` | `41a2f5fcd57ca26fd52ca318fc2714c5188e9c03ab5f3d58ab55f92bd98b5e09` | 83188 | 2482 | 0 | 0 | 142 | YES |
| `docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md` | `30480be7c24a260fe4d6d8231cb83134133192e9b37f052310b9522196be1a5c` | 74803 | 1768 | 0 | 0 | 0 | YES |
| `docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md` | `f480485516dd0e9855f17f0463ec8a7c410e38ed677e75723bc93f41b2d1a4ae` | 103093 | 2534 | 0 | 0 | 0 | YES |
| `docs/tasks/CORR-029-task-018-post-auth-pending-profile-destination.md` | `f19e620f3ced35d3231cbcf3f14a6ac20d5c12931e08a9ccb4d6cb944fbf34db` | 40920 | 1850 | 0 | 0 | 0 | YES |
| `docs/tasks/CORR-033-task-018-closure-state-sync.md` | `402af14d1ccf5047a15cb4fcece288a24b2fa9718720653131813c08ac3958ce` | 50332 | 1844 | 0 | 0 | 0 | YES |

Resultado:

```text
required physical sources =
AVAILABLE

source identity verification =
PASS
```

---

## 6. Clasificación documental final

| Documento | Clasificación | Acción CORR-034 |
|---|---|---|
| `00-master-product-brief.md` | `CURRENT / NO CHANGE` | NO |
| `01-product-definition.md` | `CHANGE REQUIRED` | YES |
| `02-domain-model.md` | `CHANGE REQUIRED` | YES |
| `03-permissions-rls-strategy.md` | `CHANGE REQUIRED` | YES |
| `10-architecture-decisions-records.md` | `CURRENT / NO CHANGE` | NO |
| `11-phase-1-scope-entry-gate.md` | `CHANGE REQUIRED — §14.2 ONLY` | YES |
| `TASK-018...md` | `HISTORICAL SNAPSHOT — PRESERVE` | NO |
| `CORR-029...md` | `HISTORICAL SNAPSHOT — PRESERVE` | NO |
| `CORR-033...md` | `HISTORICAL SNAPSHOT — PRESERVE` | NO |
| `ADR-0020...md` | `CURRENT / NO CHANGE` | NO |

Resultado:

```text
CHANGE REQUIRED documents =
4

UNEXPECTED ACTIVE STALE SURFACES =
0

CANONICAL CONTRADICTIONS =
0
```

---

## 7. Scope físico exacto de futura ejecución

La futura ejecución de CORR-034 podrá modificar exclusivamente:

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/11-phase-1-scope-entry-gate.md
```

Contrato:

```text
expected modified existing paths =
EXACTLY 4

fifth modified path =
PROHIBITED

new product files =
NONE

deleted files =
NONE

renamed files =
NONE
```

No se modifica:

```text
docs/product/00-master-product-brief.md
docs/product/10-architecture-decisions-records.md

docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md
docs/tasks/CORR-029-task-018-post-auth-pending-profile-destination.md
docs/tasks/CORR-033-task-018-closure-state-sync.md

docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md
```

Tampoco se modifica ningún código, SQL, migration, test ejecutable, configuración Supabase, package file ni infraestructura.

---

## 8. Scope semántico exacto

CORR-034 sincroniza exclusivamente:

1. campos mínimos del profile first-admin;
2. ownership conceptual de esos campos;
3. timing conceptual de creación/reconciliación de `PlatformUser`;
4. ausencia de `CompanyMembership` pre-profile;
5. creación de initial membership `COMPANY_ADMIN` habilitada sólo durante completion exitosa;
6. orden lógico de RF-012 / FL-01 steps 6–8;
7. una única transición purpose-specific de onboarding completion;
8. `FirstAdminOnboardingIntent` como única autoridad durable de completion;
9. `USER_CREATED` exactamente una vez en la completion exitosa;
10. retry/reconciliation y at-most-one completion outcome;
11. `/pending-profile` como estado previo;
12. `/onboarding-complete` como shell mínima posterior;
13. separación entre sesión Auth y autoridad tenant;
14. prohibición de tenant/role caller-supplied como autoridad;
15. preservación de RLS, multitenancy y privilege boundaries.

Fuera de scope:

- schema físico exacto;
- nombre físico de RPC/function;
- migration;
- columnas SQL concretas;
- constraints concretas;
- índices;
- triggers;
- row locks;
- advisory locks;
- isolation level;
- `SECURITY DEFINER`;
- grants/revokes;
- policies RLS concretas;
- route handler;
- server action;
- component tree;
- exact validation library;
- exact string length de `first_name`/`last_name`;
- dashboard;
- client management;
- `UserClientAccess` implementation;
- `SupportAccessGrant` implementation;
- route authorization framework completo;
- resource authorization framework completo;
- offline implementation;
- TASK-019.

---

## 9. Matriz exacta de superficies activas

### 9.1 `01-product-definition.md`

Superficies autorizadas:

```text
§7.1 — Alta de empresas y usuarios / RF-012
§10 — Entidades principales del dominio
§11 — Reglas e invariantes de negocio
§12 — Flujos principales / FL-01
§22 — Auditoría
```

Cantidad:

```text
01 semantic surfaces =
5
```

### 9.2 `02-domain-model.md`

Superficies autorizadas:

```text
§4.1 — PlatformUser
§4.4 — CompanyMembership
§6 — Modelo de identidad y pertenencia
§19.4 — Eventos obligatorios actuales
§20.1 — CompanyMembership
§23.1 — Usuario tenant
```

Cantidad:

```text
02 semantic surfaces =
6
```

### 9.3 `03-permissions-rls-strategy.md`

Superficies autorizadas:

```text
§2.6 — CompanyMembership
§5 — Resolución de identidad
§6 — Resolución del tenant efectivo
§17.4 — Operaciones iniciadas por usuario
§22.1 — Alta inicial
§23 — Matriz conceptual RLS por agregado/recurso
§25.1 — Eventos mínimos obligatorios
§25.3 — Actor real
```

Cantidad:

```text
03 semantic surfaces =
8
```

### 9.4 `11-phase-1-scope-entry-gate.md`

Única superficie autorizada:

```text
§14.2 — Condición adicional para cruzar hacia Fase 2
```

Cantidad:

```text
11 semantic surfaces =
1
```

Total:

```text
authorized semantic surfaces =
20
```

No debe aparecer una vigésima primera superficie material sin retornar al Revisor Central.

---

## 10. Sincronización normativa de `01-product-definition.md`

### 10.1 §7.1 / RF-012

Estado activo actual:

```text
RF-012 =
primer COMPANY_ADMIN ingresa usando correo + código válido
y completa su perfil
```

La futura corrección deberá mantener RF-012 y precisar que el profile mínimo requerido para first-admin consiste exclusivamente en:

```text
first_name =
required

last_name =
required
```

Ambos:

```text
trimmed non-empty =
required
```

El email:

```text
email =
Auth-derived
not an editable profile-completion field
```

`profile_completed_at`:

```text
system-owned lifecycle metadata
not user-entered
```

No deben añadirse como requisitos de RF-012:

```text
phone
avatar
job title
address
government/document ID
locale
timezone
notification preferences
commercial data
client scope
```

CORR-034 no debe fijar max length, SQL type o UI component.

### 10.2 §10 — Entidades principales

Estado actual relevante:

```text
PlatformUser:
identidad autenticada de plataforma

CompanyMembership/UserProfile:
pertenencia, rol y estado
```

Este wording produce drift normativo con la decisión aprobada.

La futura corrección debe separar inequívocamente:

```text
PlatformUser =
global platform identity
+
user-owned profile data
  - first_name
  - last_name
  - profile_completed_at

CompanyMembership =
tenant membership
+
role
+
is_enabled
+
tenant-scoped relationship state
```

Debe eliminarse la equivalencia conceptual:

```text
CompanyMembership/UserProfile
```

No se crea una entidad `UserProfile`.

### 10.3 §11 — Reglas e invariantes

La corrección debe incorporar invariantes conceptuales suficientes para expresar:

```text
Auth identity/session
!=
tenant authorization
```

```text
first-admin profile completion
MUST precede
enabled first-admin CompanyMembership / tenant authority
```

```text
pre-profile first-admin CompanyMembership =
NONE
```

```text
one FirstAdminOnboardingIntent
→ at most one completed first-admin onboarding outcome
```

```text
successful first-admin onboarding completion
=
observable atomic outcome
```

No deben seleccionarse mecanismos de locking o transaction isolation.

La continuidad de `INV-028` para una empresa que ya posee administración activa no debe reinterpretarse para prohibir la creación inicial del primer `COMPANY_ADMIN`.

### 10.4 §12 / FL-01

FL-01 actual termina conceptualmente:

```text
6. administrador ingresa con correo + código
7. completa perfil
8. queda habilitado
```

Debe conservarse el flujo de negocio y precisarse sin convertirlo en diseño físico:

```text
valid verification/session
→ /pending-profile
→ first_name + last_name
→ authoritative first-admin onboarding completion
→ PlatformUser/profile established
→ first CompanyMembership established
   role = COMPANY_ADMIN
   is_enabled = true
→ USER_CREATED
→ FirstAdminOnboardingIntent terminal completion
→ /onboarding-complete
```

Reglas:

- `/pending-profile` significa profile completion pendiente;
- `/onboarding-complete` significa completion exitosa;
- `/onboarding-complete` es shell mínima;
- no implica dashboard;
- no implica route authorization completa;
- no implica Client/UserClientAccess/SupportAccessGrant;
- no implica que toda Phase 2 esté terminada.

### 10.5 §22 — Auditoría

Debe preservarse la action existente:

```text
USER_CREATED
```

Para first-admin:

```text
USER_CREATED =
exactly once
```

Timing normativo:

```text
during successful authoritative first-admin onboarding completion
```

No se produce por:

```text
challenge issue
challenge resend
challenge verify alone
Auth identity creation alone
session establishment alone
/pending-profile render
profile validation failure
```

Actor histórico:

```text
FirstAdminOnboardingIntent.initiated_by_platform_user_id
```

Tenant:

```text
FirstAdminOnboardingIntent.maintenance_company_id
```

No se crea una nueva `AuditEvent.action`.

---

## 11. Sincronización normativa de `02-domain-model.md`

### 11.1 §4.1 — `PlatformUser`

Debe conservar:

```text
global platform identity
```

y añadir conceptualmente:

```text
first_name
last_name
profile_completed_at
```

Ownership:

```text
profile ownership =
PlatformUser
```

Lifecycle first-admin:

```text
Auth identity/session may exist
before
PlatformUser profile materialization
```

y:

```text
first-admin PlatformUser
=
created/reconciled during authoritative profile-completion transition
```

No debe generalizarse este timing a todos los futuros flujos de usuario sin decisión posterior.

Una identidad `PlatformUser` ya existente compatible con la misma operación lógica se reconcilia.

Una identidad existente incompatible debe fallar cerrada; el detalle físico queda para futura TASK.

### 11.2 §4.4 — `CompanyMembership`

Debe añadir para first-admin:

```text
pre-profile CompanyMembership =
NONE
```

La primera membership se establece únicamente en successful completion:

```text
role =
COMPANY_ADMIN

is_enabled =
true
```

No introducir estados conceptuales nuevos:

```text
PENDING
PROVISIONAL
BOOTSTRAP_DISABLED
```

No debe reinterpretarse la semántica de disable/reinstate/role-change ya aprobada para memberships existentes.

### 11.3 §6 — Modelo de identidad y pertenencia

Debe distinguir:

```text
Supabase Auth identity/session
```

de:

```text
PlatformUser
```

y:

```text
CompanyMembership
```

Durante pre-profile:

```text
Auth identity/session =
may exist

PlatformUser =
may not yet exist for first-admin

CompanyMembership =
does not exist

tenant authority =
NO
```

Después de completion:

```text
PlatformUser =
exists/reconciled

CompanyMembership =
exists

role =
COMPANY_ADMIN

is_enabled =
true

tenant authority =
established subject to ordinary authorization rules
```

La relación ordinaria `PlatformUser → CompanyMembership` sigue vigente una vez completado onboarding.

### 11.4 §19.4 — Eventos obligatorios actuales

Debe conservar `USER_CREATED` y precisar el producer semántico first-admin:

```text
successful authoritative first-admin onboarding completion
→ exactly one USER_CREATED
```

Retry y reconciliation:

```text
no duplicate USER_CREATED
```

No debe crear una action específica `FIRST_ADMIN_ONBOARDING_COMPLETED`.

### 11.5 §20.1 — Aggregate `CompanyMembership`

La futura corrección debe aclarar que la initial first-admin creation:

- no es ordinary tenant-admin membership lifecycle;
- no requiere una membership actor preexistente del target;
- pertenece al onboarding purpose-specific iniciado por `SUPER_ADMIN`;
- deriva tenant, target y role desde estado autoritativo;
- termina con membership habilitada sólo después del profile completo;
- debe coordinarse con `USER_CREATED` y terminal completion evidence.

Debe expresarse una frontera de consistencia conceptual única:

```text
PlatformUser/profile establishment
+
initial enabled CompanyMembership
+
USER_CREATED
+
FirstAdminOnboardingIntent terminal completion
```

El mecanismo físico de transaction queda fuera de CORR-034.

### 11.6 §23.1 — Lifecycle usuario tenant

Debe enriquecer el lifecycle first-admin:

```text
business proof / handoff
→ Auth identity/session
→ profile pending
→ profile completed
→ PlatformUser/profile established
→ enabled COMPANY_ADMIN membership established
→ USER_CREATED
→ onboarding intent terminal completion
→ onboarding complete
```

Debe preservar:

```text
profile completed
before
enabled tenant authority
```

Y:

```text
same operation correlation
→ same logical result
```

```text
same intent
→ at most one completed first-admin outcome
```

---

## 12. Sincronización normativa de `03-permissions-rls-strategy.md`

### 12.1 §2.6 — `CompanyMembership`

Debe conservar:

```text
CompanyMembership represents tenant authorization
```

y precisar:

```text
first-admin pre-profile CompanyMembership =
NONE
```

Por tanto:

```text
Auth session present
+
no CompanyMembership
=
no tenant authority
```

La creación initial first-admin es purpose-specific y no amplía generic membership CRUD.

### 12.2 §5 — Resolución de identidad

La cadena ordinaria:

```text
Supabase Auth identity
→ PlatformUser
→ CompanyMembership
```

debe permanecer para usuarios tenant ya establecidos.

Debe añadirse la excepción de onboarding first-admin:

```text
Supabase Auth identity/session
→ authoritative first-admin onboarding correlation
→ profile-completion purpose-specific transition
→ PlatformUser
→ CompanyMembership
```

Antes de completion:

```text
missing PlatformUser or CompanyMembership
does not imply SUPER_ADMIN
does not imply tenant authority
```

La continuación se autoriza exclusivamente por el purpose-specific onboarding state ya aprobado, no por ausencia de membership.

### 12.3 §6 — Resolución del tenant efectivo

La regla ordinaria permanece:

```text
tenant user
→ tenant derived from enabled CompanyMembership
```

La excepción first-admin pre-membership debe quedar explícita:

```text
onboarding completion tenant
=
FirstAdminOnboardingIntent.maintenance_company_id
```

No deriva de:

```text
request
URL
form field
cookie tenant selector
browser state
caller-provided maintenance_company_id
```

El role target:

```text
COMPANY_ADMIN
```

también es fijo por purpose y no caller-supplied.

Una vez completada la membership, la resolución normal vuelve a depender de ella.

### 12.4 §17.4 — Operaciones iniciadas por usuario

Debe incorporarse una operación purpose-specific:

```text
complete first-admin onboarding
```

Input funcional permitido:

```text
first_name
last_name
operation_id
```

No se permite que el caller seleccione como autoridad:

```text
maintenance_company_id
tenant
role
CompanyMembership id
PlatformUser id
FirstAdminOnboardingIntent id
target email
actor SUPER_ADMIN
```

El backend/trusted boundary debe reconstruir y verificar:

- current Auth subject;
- authoritative handoff/correlation;
- current onboarding intent;
- bound tenant;
- bound target email/identity;
- fixed first-admin purpose;
- terminal completion state;
- operation correlation;
- profile validity.

No se selecciona aquí si la frontera física será RPC, Server Action, Route Handler u otra combinación.

### 12.5 §22.1 — Alta inicial

Debe expandirse conceptualmente para reflejar:

```text
MaintenanceCompany creation
+
first-admin onboarding intent
+
verification/handoff
+
Auth identity/session
+
profile completion
+
PlatformUser establishment
+
initial enabled COMPANY_ADMIN membership
+
USER_CREATED
+
terminal onboarding completion
```

No toda esta secuencia ocurre necesariamente en una sola operación desde company creation; la atomicidad exigida por A–J se refiere a la authoritative completion transition posterior al profile.

Debe permanecer prohibido:

```text
generic privileged user writer
generic service-role client
generic browser INSERT CompanyMembership
generic browser INSERT AuditEvent
caller-chosen tenant
caller-chosen role
```

### 12.6 §23 — Matriz conceptual RLS

La fila `CompanyMembership` debe aclarar:

```text
SUPER_ADMIN normal:
no ordinary tenant membership CRUD

exception:
purpose-specific initial first-admin onboarding only
```

La excepción no otorga:

- generic membership INSERT;
- generic membership UPDATE;
- ordinary tenant data access;
- client scope;
- maintenance permissions;
- SupportAccessGrant semantics.

RLS permanece frontera primaria para datos tenant-owned ordinarios.

La futura implementation puede necesitar una boundary confiable estrecha para la mutación inicial, pero no puede abrir políticas genéricas para sustituir esa boundary.

### 12.7 §25.1 — Eventos mínimos obligatorios

Debe conservar:

```text
alta de usuario
```

y precisar:

```text
first-admin successful completion
→ USER_CREATED exactly once
```

No-op/retry reconciliado no duplica evento.

Failure/deny no produce un `USER_CREATED` ficticio.

### 12.8 §25.3 — Actor real

Para first-admin:

```text
actor =
FirstAdminOnboardingIntent.initiated_by_platform_user_id
```

No:

```text
browser field
current target first-admin
free-form actor id
```

El actor del evento representa al `SUPER_ADMIN` que inició autoritativamente el onboarding.

El tenant del evento deriva del intent.

La implementación física debe impedir spoofing, pero CORR-034 no define la técnica concreta.

---

## 13. `00-master-product-brief.md` — no change

Resultado:

```text
CURRENT / NO CHANGE
```

Justificación:

- no contiene el nivel de detalle de profile fields;
- no necesita registrar pathname;
- no necesita especificar timing de membership;
- no necesita duplicar invariantes ya alojados en `01/02/03`;
- modificarlo ampliaría scope sin necesidad normativa.

---

## 14. `10-architecture-decisions-records.md` — no change

Resultado:

```text
CURRENT / NO CHANGE
```

ADR-0020 ya figura aceptado.

Las decisiones A–J permanecen dentro de las fronteras de:

```text
ADR-0002
ADR-0003
ADR-0019
ADR-0020
```

No existe una nueva decisión arquitectónica transversal requerida por la synchronization.

---

## 15. `11-phase-1-scope-entry-gate.md` — change required en §14.2 únicamente

Resultado:

```text
CHANGE REQUIRED — §14.2 ONLY
```

Finding que origina esta ampliación controlada:

```text
F-034-001 =
UNEXPECTED ACTIVE STALE SURFACE
```

El baseline físico vigente contiene en §14.2:

```text
USER_CREATED producer timing =
NOT RESOLVED
```

La decisión humana aprobada H establece:

```text
USER_CREATED =
exactly once during successful authoritative onboarding completion
```

Por tanto, la futura ejecución debe sustituir exclusivamente ese estado stale por una formulación equivalente a:

```text
USER_CREATED producer timing =
RESOLVED AT PRODUCT/DOMAIN LEVEL

USER_CREATED produced by TASK-017 =
NO

USER_CREATED produced by TASK-018 =
NO

USER_CREATED producer implemented =
NO
```

Debe quedar explícita la distinción:

```text
producer timing resolved
!=
producer implemented
```

La corrección se limita a §14.2 y no autoriza declarar como implementadas las capacidades todavía pendientes.

Deben continuar exactamente como pendientes:

```text
RF-012 =
INCOMPLETE

PlatformUser establishment for first admin =
PENDING / NO

initial CompanyMembership creation =
PENDING / NO

profile completion =
PENDING / NO

enabled tenant authority =
PENDING / NO

first-admin onboarding completion =
PENDING / NO

TASK-019 =
NOT DETERMINED / NOT AUTHORIZED
```

También permanecen:

```text
TASK-018 =
DONE / CLOSED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED
```

No se autoriza modificar otra superficie de `11-phase-1-scope-entry-gate.md`.

No se modifica §7.9, §17 ni otra sección por inferencia.


---

## 16. Snapshots históricos

### 16.1 TASK-018

```text
HISTORICAL SNAPSHOT — PRESERVE
```

Sus declaraciones de decisiones diferidas eran correctas cuando TASK-018 fue especificada y cerrada.

No reemplazar retrospectivamente:

```text
exact profile fields = deferred
profile persistence = deferred
pre-profile membership state = deferred
USER_CREATED timing = deferred
```

### 16.2 CORR-029

```text
HISTORICAL SNAPSHOT — PRESERVE
```

Continúa siendo autoritativo respecto de:

```text
successful session
→ /pending-profile
```

Sus afirmaciones de que el flujo posterior aún no estaba decidido son históricas y no deben reescribirse.

### 16.3 CORR-033

```text
HISTORICAL SNAPSHOT — PRESERVE
```

Registra correctamente el estado posterior a TASK-018 y previo a la decisión A–J.

### 16.4 ADR-0020

```text
CURRENT / NO CHANGE
```

Las decisiones A–J llenan intencionalmente detalles que ADR-0020 dejó a una futura decisión de producto/task.

No lo contradicen ni cambian su frontera.

---

## 17. Arquitectura

Resultado:

```text
new ADR required =
NO
```

CORR-034 no cambia:

- tenant boundary;
- role model;
- Auth provider boundary;
- `FirstAdminOnboardingIntent` ownership;
- RLS como frontera primaria;
- server-side purpose-specific privileged boundary;
- session semantics de ADR-0019;
- client-scope/support architecture de ADR-0003.

Si una futura ejecución documental necesita introducir una nueva frontera arquitectónica para expresar A–J:

```text
CORR-034 EXECUTION =
BLOCKER — NEW ARCHITECTURAL DECISION REQUIRED
```

No ampliar scope silenciosamente.

---

## 18. Seguridad

CORR-034 debe dejar inequívoco:

```text
authenticated != authorized

Auth session != tenant authorization
```

Antes de profile completion:

```text
Auth identity/session =
may exist

tenant authority =
NO
```

El browser sólo expresa intención.

No es autoridad sobre:

```text
tenant
role
actor
onboarding intent
membership
PlatformUser identity mapping
completion status
```

Debe preservarse fail-closed ante:

- current Auth subject incompatible;
- intent no resoluble;
- email/identity binding incompatible;
- intent ya terminal con resultado incompatible;
- operation correlation incompatible;
- cross-tenant input;
- forged role;
- stale client state.

CORR-034 no define mensajes de error concretos.

---

## 19. RLS y multitenancy

Resultado documental:

```text
RLS implementation =
NONE

RLS policy change =
NONE

multitenancy physical change =
NONE

tenant isolation weakening =
NO
```

Norma a sincronizar:

```text
first-admin completion tenant
=
authoritative FirstAdminOnboardingIntent tenant
```

Nunca:

```text
first-admin completion tenant
=
caller-supplied tenant
```

La inexistencia pre-profile de una `CompanyMembership` no habilita bypass tenant genérico.

La futura implementation deberá usar una boundary purpose-specific compatible con RLS y privilege minimization.

CORR-034 no selecciona esa técnica.

---

## 20. Atomicidad

La decisión aprobada exige atomicidad observable para la authoritative completion transition:

```text
PlatformUser/profile establishment
+
initial enabled COMPANY_ADMIN membership
+
required USER_CREATED
+
FirstAdminOnboardingIntent terminal completion
```

Resultado permitido:

```text
ALL COMMITTED
OR
NOT COMMITTED
```

Resultado prohibido durable:

```text
enabled first-admin membership
AND
profile completion not confirmed
```

También prohibido:

```text
terminal onboarding completion
without required USER_CREATED
```

o:

```text
USER_CREATED
without corresponding successful authoritative completion
```

CORR-034 no selecciona:

- SQL transaction shape;
- row lock;
- advisory lock;
- conditional update;
- isolation level.

---

## 21. Idempotencia y concurrencia

Norma:

```text
same operation_id
→ same logical result
```

Debe impedir:

```text
duplicate PlatformUser
duplicate CompanyMembership
duplicate USER_CREATED
second onboarding completion
```

Un `operation_id` diferente:

```text
!=
permission to complete same intent twice
```

Ante concurrencia:

```text
same FirstAdminOnboardingIntent
→ at most one authoritative completion winner
```

El loser:

```text
reconcile committed outcome
OR
fail closed
```

Ante timeout ambiguo:

```text
reconcile same operation first
```

No iniciar una segunda alta por inferencia.

No lock global de plataforma requerido por norma.

---

## 22. Auditoría

Action:

```text
USER_CREATED
```

permanece existente.

No action nueva.

Producer timing first-admin:

```text
successful authoritative onboarding completion
```

Actor provenance:

```text
FirstAdminOnboardingIntent.initiated_by_platform_user_id
```

Tenant provenance:

```text
FirstAdminOnboardingIntent.maintenance_company_id
```

El evento debe ser exactamente uno por alta lógica completada.

Issue/resend/verify/session establishment/profile validation no producen por sí solos `USER_CREATED`.

---

## 23. UI y navegación

Estado previo:

```text
successful TASK-018 session
→ /pending-profile
```

`/pending-profile` significa exclusivamente:

```text
PROFILE COMPLETION PENDING
```

Formulario mínimo:

```text
first_name
last_name
```

El email puede mostrarse read-only, pero no forma parte del input editable de completion.

Post-success:

```text
→ /onboarding-complete
```

Semántica:

```text
profile completed
initial COMPANY_ADMIN membership established
tenant authority established
first-admin onboarding completed
```

La pantalla es una shell mínima.

Puede comunicar conceptualmente:

```text
Perfil completado.
Tu cuenta ya está habilitada para administrar la empresa.
```

No autoriza por sí sola:

- dashboard;
- tenant administration module;
- Client CRUD;
- UserClientAccess UI;
- SupportAccessGrant UI;
- route authorization framework;
- resource authorization framework.

La ruta no es una autoridad. El acceso directo futuro deberá validarse contra estado autoritativo.

---

## 24. Distinciones obligatorias

Debe permanecer:

```text
email verification
!=
profile completion
```

```text
Auth identity
!=
PlatformUser profile
```

```text
Auth session
!=
CompanyMembership
```

```text
PlatformUser existence
!=
tenant authority
```

```text
profile validation
!=
onboarding completion
```

```text
/onboarding-complete pathname
!=
authorization authority
```

```text
SUPER_ADMIN initiated onboarding
!=
SUPER_ADMIN tenant membership
```

```text
purpose-specific first-admin creation
!=
generic user-management privilege
```

---

## 25. No cambios a otras capacidades

CORR-034 no implementa, redefine ni autoriza:

```text
Client
UserClientAccess
SupportAccessGrant
full Auth UI
logout
route authorization framework
resource authorization framework
offline
forms
maintenance
evidence
reporting
AI
credits
subscriptions
payments
dashboard
push notifications
```

Tampoco cambia lifecycle ordinario TASK-015 de memberships existentes.

---

## 26. Reglas de edición física futura

La futura ejecución debe:

1. partir de un preflight Git fresco;
2. verificar identidades físicas de los cuatro targets;
3. preservar `LF`;
4. preservar `bare CR = 0`;
5. preservar final newline;
6. no ejecutar global whitespace cleanup;
7. no normalizar trailing whitespace fuera de los fragmentos realmente editados;
8. no rewrap globalmente Markdown;
9. no renumerar requisitos/invariantes existentes salvo necesidad normativa explícita;
10. preferir adiciones/reemplazos locales y auditables;
11. no cambiar headings fuera de necesidad;
12. no modificar ningún quinto path;
13. en `11-phase-1-scope-entry-gate.md`, modificar exclusivamente §14.2 y sólo el estado de `USER_CREATED producer timing`.

Trailing whitespace actual del baseline:

```text
01-product-definition.md =
6 lines

02-domain-model.md =
5 lines

03-permissions-rls-strategy.md =
7 lines

11-phase-1-scope-entry-gate.md =
9 lines
```

Esas líneas forman parte de la identidad física actual y no deben limpiarse oportunísticamente.

---

## 27. Preflight obligatorio de futura ejecución

Antes de editar, el implementador deberá reportar:

```text
repo root
branch
HEAD
origin/main
remote main
divergence
worktree
staged
untracked
Git operations in progress
```

Baseline de esta specification:

```text
main
33625a4e2764692fa8026471e37606883e1d75a8
```

pero la futura autorización de ejecución deberá fijar el baseline exacto vigente en ese momento.

También deberá verificar:

```text
01 SHA-256 =
417208bdb61ab837f2153fc542faf7ea72cc695c6feb871f799996e9fb407ca9

02 SHA-256 =
5b1a25e96f758fffba4f11760f3b4effbe9e0c44030c8a532970d897cb42bed3

03 SHA-256 =
a855146e6e6727533e1b2464bc4b553af1b9bef9576facb3939071a8b9b18f05

11 SHA-256 =
f32b8adf574ec260d0cd244d914438660327f48cc519cef28c98b731cf438fd8
```

si la ejecución se autoriza todavía sobre este mismo baseline.

Si cualquiera cambió materialmente:

```text
CORR-034 EXECUTION =
BLOCKER — TARGET BASELINE DRIFT
```

No reparar silenciosamente.

---

## 28. Blockers

La specification/ejecución futura debe detenerse si ocurre cualquiera:

1. falta una fuente canónica necesaria;
2. baseline Git autorizado cambió materialmente;
3. uno de los cuatro targets cambió materialmente;
4. aparece un quinto documento que requiere cambio;
5. aparece una vigésima primera superficie material no cubierta;
6. A–J necesitan reabrirse para ejecutar la synchronization;
7. una decisión A–J contradice un ADR vigente;
8. se necesita modificar ADR-0020;
9. se necesita un ADR nuevo;
10. se necesita modificar `11-phase-1-scope-entry-gate.md` fuera de §14.2 o por una razón distinta de sincronizar `USER_CREATED producer timing`;
11. se necesita declarar una capability implementada;
12. se necesita determinar TASK-019;
13. se necesita definir Phase 2 Exit Gate;
14. se necesita cerrar Phase 2;
15. se necesita iniciar Phase 3;
16. se necesita agregar profile field distinto de `first_name`/`last_name`;
17. se necesita entidad `UserProfile`;
18. se necesita pre-profile membership;
19. se necesita role caller-supplied;
20. se necesita tenant caller-supplied;
21. se necesita generic privileged user writer;
22. se necesita generic membership INSERT/UPDATE policy;
23. se necesita service-role como path ordinario;
24. se necesita nueva `AuditEvent.action`;
25. se necesita producir `USER_CREATED` antes del authoritative completion;
26. se necesita una segunda completion authority distinta del intent;
27. se necesita dashboard para completar CORR-034;
28. se necesita route/resource authorization completa;
29. se necesita código;
30. se necesita SQL/migration;
31. se necesita Supabase mutation;
32. se necesita Staging/Production mutation;
33. `git diff --check` falla;
34. aparece cualquier path inesperado;
35. cualquier Acceptance Criterion falla.

Ante blocker:

```text
no scope expansion
no silent repair
no staging
no commit
no push
no TASK-019
RETURN TO REVISOR CENTRAL
```

---

## 29. Acceptance Criteria

Cada criterio debe evaluarse individualmente como `PASS` o `FAIL`.

### Governance / scope

**AC-034-001.** El ID continúa siendo `CORR-034`.

**AC-034-002.** El título continúa siendo `Sincronización normativa de First-Admin Profile Completion previa a TASK-019`.

**AC-034-003.** CORR-034 continúa siendo exclusivamente `DOCUMENTATION / PRODUCT DECISION SYNC`.

**AC-034-004.** La futura ejecución modifica exactamente cuatro documentos.

**AC-034-005.** Los cuatro documentos son exclusivamente `01`, `02`, `03` y `11`.

**AC-034-006.** No existe un quinto target modificado.

**AC-034-007.** No se crea ningún nuevo documento de producto.

**AC-034-008.** No se modifica `00-master-product-brief.md`.

**AC-034-009.** No se modifica `10-architecture-decisions-records.md`.

**AC-034-010.** `11-phase-1-scope-entry-gate.md` se modifica exclusivamente en §14.2.

**AC-034-011.** TASK-018 permanece snapshot histórico.

**AC-034-012.** CORR-029 permanece snapshot histórico.

**AC-034-013.** CORR-033 permanece snapshot histórico.

**AC-034-014.** ADR-0020 permanece sin modificación.

**AC-034-015.** `UNEXPECTED ACTIVE STALE SURFACES = 0`.

### Decision A / profile fields

**AC-034-016.** `first_name` queda requerido para first-admin profile completion.

**AC-034-017.** `last_name` queda requerido para first-admin profile completion.

**AC-034-018.** Ambos requieren valor trimmed no vacío.

**AC-034-019.** Email no se convierte en campo editable del profile completion.

**AC-034-020.** `profile_completed_at` se representa como metadata system-owned.

**AC-034-021.** No se añade teléfono como requisito.

**AC-034-022.** No se añade avatar como requisito.

**AC-034-023.** No se añade job title como requisito.

**AC-034-024.** No se añade otra PII por conveniencia.

**AC-034-025.** No se inventan restricciones físicas de longitud/tipo.

### Decision B / ownership

**AC-034-026.** `PlatformUser` posee conceptualmente `first_name`.

**AC-034-027.** `PlatformUser` posee conceptualmente `last_name`.

**AC-034-028.** `PlatformUser` posee conceptualmente `profile_completed_at`.

**AC-034-029.** `CompanyMembership` no se utiliza como profile storage.

**AC-034-030.** No se crea entidad `UserProfile`.

### Decisions C/D/E / lifecycle

**AC-034-031.** Auth identity/session puede existir antes del `PlatformUser` first-admin.

**AC-034-032.** El first-admin `PlatformUser` se crea/reconcilia durante authoritative completion.

**AC-034-033.** No existe first-admin `CompanyMembership` pre-profile.

**AC-034-034.** No se inventa membership pending/provisional/disabled para bootstrap.

**AC-034-035.** Initial membership se crea durante completion exitosa.

**AC-034-036.** Initial membership role es `COMPANY_ADMIN`.

**AC-034-037.** Initial membership se crea habilitada.

**AC-034-038.** Profile completion precede autoridad tenant observable.

**AC-034-039.** No existe estado durable soportado con enabled membership y profile no completado.

**AC-034-040.** FL-01 continúa siendo coherente con RF-012.

### Decision F / completion boundary

**AC-034-041.** Existe conceptualmente una única transition purpose-specific de first-admin completion.

**AC-034-042.** Input funcional permitido queda limitado a `first_name`, `last_name`, `operation_id`.

**AC-034-043.** Tenant no es caller-supplied authority.

**AC-034-044.** Role no es caller-supplied authority.

**AC-034-045.** `CompanyMembership id` no es authority input.

**AC-034-046.** `PlatformUser id` no es authority input.

**AC-034-047.** `FirstAdminOnboardingIntent id` no es authority input.

**AC-034-048.** Target email no es authority input.

**AC-034-049.** Actor `SUPER_ADMIN` no es caller-supplied.

**AC-034-050.** Tenant/target/purpose derivan de estado autoritativo.

### Decisions G/H / evidence and audit

**AC-034-051.** `FirstAdminOnboardingIntent` permanece única autoridad durable de completion.

**AC-034-052.** Handoff ready no equivale a onboarding completed.

**AC-034-053.** Un intent produce como máximo un completed first-admin outcome.

**AC-034-054.** La action continúa siendo `USER_CREATED`.

**AC-034-055.** No se crea nueva AuditEvent action.

**AC-034-056.** `USER_CREATED` ocurre exactamente una vez.

**AC-034-057.** `USER_CREATED` ocurre en successful authoritative completion.

**AC-034-058.** Challenge issue no produce `USER_CREATED`.

**AC-034-059.** Challenge resend no produce `USER_CREATED`.

**AC-034-060.** Challenge verify solo no produce `USER_CREATED`.

**AC-034-061.** Auth identity creation sola no produce `USER_CREATED`.

**AC-034-062.** Session establishment solo no produce `USER_CREATED`.

**AC-034-063.** Failure/deny no produce `USER_CREATED`.

**AC-034-064.** Actor histórico deriva de `initiated_by_platform_user_id`.

**AC-034-065.** Tenant de auditoría deriva del intent.

### Decision I / idempotency and concurrency

**AC-034-066.** Same `operation_id` reconcilia el mismo resultado lógico.

**AC-034-067.** Retry no duplica `PlatformUser`.

**AC-034-068.** Retry no duplica `CompanyMembership`.

**AC-034-069.** Retry no duplica `USER_CREATED`.

**AC-034-070.** Retry no produce segunda completion.

**AC-034-071.** Nuevo operation ID no evade terminal completion evidence.

**AC-034-072.** Concurrencia produce como máximo un winner autoritativo.

**AC-034-073.** Losers reconcilian o fallan cerrados.

**AC-034-074.** Timeout ambiguo reconcilia la misma operación primero.

**AC-034-075.** No se exige lock global de plataforma.

### Decision J / navigation

**AC-034-076.** `/pending-profile` conserva significado `PROFILE COMPLETION PENDING`.

**AC-034-077.** Completion exitosa conduce conceptualmente a `/onboarding-complete`.

**AC-034-078.** `/onboarding-complete` es shell mínima.

**AC-034-079.** `/onboarding-complete` no se declara dashboard.

**AC-034-080.** `/onboarding-complete` no otorga autoridad por pathname.

**AC-034-081.** No se implementa Client management por esta decisión.

**AC-034-082.** No se implementa UserClientAccess UI.

**AC-034-083.** No se implementa SupportAccessGrant UI.

**AC-034-084.** No se implementa route authorization completa.

**AC-034-085.** No se implementa resource authorization completa.

### Security / RLS / multitenancy

**AC-034-086.** `authenticated != authorized` permanece explícito.

**AC-034-087.** `Auth session != tenant authorization` permanece explícito.

**AC-034-088.** RLS continúa siendo frontera primaria de datos tenant-owned ordinarios.

**AC-034-089.** No se abre generic INSERT policy de memberships.

**AC-034-090.** No se abre generic UPDATE policy para soportar onboarding.

**AC-034-091.** No se introduce service-role como path ordinario.

**AC-034-092.** No se introduce generic privileged user writer.

**AC-034-093.** `SUPER_ADMIN` no se convierte en tenant member.

**AC-034-094.** La excepción initial onboarding permanece purpose-specific.

**AC-034-095.** No se debilita same-tenant.

### Architecture / phase / governance

**AC-034-096.** `new ADR required = NO`.

**AC-034-097.** No se modifica arquitectura mediante CORR-034.

**AC-034-098.** No se determina TASK-019.

**AC-034-099.** Phase 2 continúa `IN PROGRESS / NOT CLOSED`.

**AC-034-100.** Phase 3 continúa `NOT STARTED`.

**AC-034-101.** Phase 2 Exit Gate continúa `NOT DEFINED / NOT SATISFIED`.

**AC-034-102.** RF-012 no se declara implementado por CORR-034.

**AC-034-103.** Profile completion no se declara implementado.

**AC-034-104.** Membership establishment no se declara implementado.

**AC-034-105.** Tenant authority establishment no se declara implementado.

**AC-034-106.** Onboarding completion no se declara implementado.

### Physical/document quality

**AC-034-107.** Exactamente 20 superficies semánticas autorizadas son auditadas.

**AC-034-108.** No existe una vigésima primera superficie material.

**AC-034-109.** Line endings permanecen LF.

**AC-034-110.** No se introducen bare CR.

**AC-034-111.** Final newline permanece YES en los cuatro targets.

**AC-034-112.** No se realiza global whitespace cleanup.

**AC-034-113.** No se introduce trailing whitespace nuevo.

**AC-034-114.** `git diff --check = PASS`.

**AC-034-115.** El diff sólo contiene los cuatro paths aprobados.

**AC-034-116.** No se incorporan secrets/tokens/passwords.

**AC-034-117.** No se escribe SQL/migration/RLS ejecutable.

**AC-034-118.** No se modifica código de aplicación.

**AC-034-119.** No se modifica Supabase Cloud.

**AC-034-120.** Todos los AC anteriores deben resultar `PASS` antes de aprobar execution review.

### Corrected scope — `11 §14.2`

**AC-034-121.** §14.2 deja de declarar `USER_CREATED producer timing = NOT RESOLVED`.

**AC-034-122.** §14.2 declara `USER_CREATED producer timing = RESOLVED AT PRODUCT/DOMAIN LEVEL`.

**AC-034-123.** §14.2 preserva `USER_CREATED produced by TASK-017 = NO`.

**AC-034-124.** §14.2 preserva `USER_CREATED produced by TASK-018 = NO`.

**AC-034-125.** §14.2 declara `USER_CREATED producer implemented = NO`.

**AC-034-126.** Queda explícito `producer timing resolved != producer implemented`.

**AC-034-127.** Ninguna otra superficie de `11-phase-1-scope-entry-gate.md` es modificada.

**AC-034-128.** La synchronization de §14.2 no declara RF-012, profile completion, membership establishment, tenant authority ni onboarding completion como implementados.

**AC range:** `AC-034-001..AC-034-128`

**AC count:** `128`

---

## 30. Definition of Done

### 30.1 Specification

**DoD-034-001.** `CORR-034 DETERMINATION = APPROVED`.

**DoD-034-002.** Existe autorización humana separada para specification generation.

**DoD-034-003.** Las fuentes físicas requeridas están disponibles.

**DoD-034-004.** Source identity verification = PASS.

**DoD-034-005.** La specification identifica exactamente cuatro target documents.

**DoD-034-006.** La specification identifica exactamente 20 superficies semánticas.

**DoD-034-007.** La specification consume A–J sin reabrirlas.

**DoD-034-008.** `new ADR required = NO`.

**DoD-034-009.** `UNEXPECTED ACTIVE STALE SURFACES = 0`.

**DoD-034-010.** `CORR-034 SPECIFICATION = PASS`.

**DoD-034-011.** Artefacto specification generado fuera del repositorio.

**DoD-034-012.** Repository mutation durante specification generation = NO.

**DoD-034-013.** TASK-019 determinada durante specification generation = NO.

**DoD-034-014.** Estado del artefacto = `READY FOR REVIEW`.

### 30.2 Specification review / human approval

**DoD-034-015.** Specification review ocurre mediante Gate separado.

**DoD-034-016.** `CORR-034 SPEC REVIEW = APPROVED` antes de cualquier approval artifact.

**DoD-034-017.** Existe aprobación humana formal mediante Gate separado.

**DoD-034-018.** Spec review no autoriza ejecución.

### 30.3 Approved artifact

**DoD-034-019.** Approved artifact se genera mediante Gate separado.

**DoD-034-020.** Approved artifact supera revisión física y semántica separada.

### 30.4 Canonicalization

**DoD-034-021.** Canonicalization ocurre mediante Gate separado.

**DoD-034-022.** Canonicalization no ejecuta cambios sobre `01/02/03`.

### 30.5 Repository incorporation

**DoD-034-023.** Canonical artifact se incorpora al repositorio mediante Gate separado.

**DoD-034-024.** Repository incorporation no autoriza modificar los cuatro targets.

### 30.6 Execution authorization

**DoD-034-025.** Documentation execution requiere autorización humana separada.

**DoD-034-026.** Preflight fresco confirma baseline Git y target identities.

### 30.7 Documentation execution

**DoD-034-027.** Ejecución modifica exactamente `01`, `02`, `03` y `11`.

**DoD-034-028.** Ejecución no modifica un quinto path.

**DoD-034-029.** Las 20 superficies quedan sincronizadas sin una vigésima primera material.

**DoD-034-030.** A–J quedan reflejadas coherentemente entre los tres documentos.

**DoD-034-031.** Security/RLS/multitenancy invariants permanecen.

**DoD-034-032.** Audit/atomicity/idempotency semantics permanecen.

**DoD-034-033.** Snapshots históricos permanecen sin modificación.

**DoD-034-034.** `11-phase-1-scope-entry-gate.md` queda modificado exclusivamente en §14.2 para sincronizar `USER_CREATED producer timing`, sin declarar implementation.

**DoD-034-035.** TASK-019 continúa no determinada.

**DoD-034-036.** Todos los `AC-034-001..128 = PASS`.

**DoD-034-037.** `git diff --check = PASS`.

### 30.8 Execution review

**DoD-034-038.** Execution review valida diff completo, scope, producto, dominio, seguridad, RLS, multitenancy, auditoría, atomicidad, idempotencia, navegación e invariantes físicas.

**DoD-034-039.** Cualquier path o superficie inesperada produce blocker.

### 30.9 Staging

**DoD-034-040.** `git add` requiere Gate humano separado posterior a execution review.

### 30.10 Commit

**DoD-034-041.** Commit requiere Gate humano separado y sólo incluye scope aprobado.

### 30.11 Push

**DoD-034-042.** Push requiere Gate humano separado posterior al commit review correspondiente.

### 30.12 Remote verification

**DoD-034-043.** Remote verification confirma commit remoto, ausencia de divergence y ausencia de drift no revisado.

### 30.13 Final human closure

**DoD-034-044.** Final human closure ocurre mediante Gate separado.

**DoD-034-045.** `CORR-034 DONE != TASK-019 determined automatically`.

**DoD-034-046.** El cierre final de CORR-034 no define Phase 2 Exit Gate, no cierra Phase 2 y no inicia Phase 3.

**DoD range:** `DoD-034-001..DoD-034-046`

**DoD count:** `46`

---

## 31. Verificación futura de ejecución

Antes de devolver `CORR-034 DOCUMENTATION EXECUTION = PASS`, el implementador deberá reportar como mínimo:

### 31.1 Git

```text
repo root
branch
HEAD
origin/main
remote main
divergence
git status --porcelain=v1 --untracked-files=all
git diff --name-only
git diff --stat
git diff --numstat
git diff --check
git diff --cached --name-only
Git operations in progress
```

### 31.2 Paths

Debe resultar:

```text
execution-modified paths =
4

unexpected paths =
NONE
```

### 31.3 Surfaces

Debe reportar una matriz:

```text
01 §7.1/RF-012 = PASS
01 §10 = PASS
01 §11 = PASS
01 §12/FL-01 = PASS
01 §22 = PASS

02 §4.1 = PASS
02 §4.4 = PASS
02 §6 = PASS
02 §19.4 = PASS
02 §20.1 = PASS
02 §23.1 = PASS

03 §2.6 = PASS
03 §5 = PASS
03 §6 = PASS
03 §17.4 = PASS
03 §22.1 = PASS
03 §23 = PASS
03 §25.1 = PASS
03 §25.3 = PASS

11 §14.2 = PASS
```

y:

```text
semantic surfaces modified =
20

unexpected semantic surfaces =
NONE
```

### 31.4 Physical metrics

Para cada target después de la ejecución:

```text
SHA-256
bytes
LF
CRLF
bare CR
trailing-whitespace lines
final newline
```

No existe SHA post-execution prefijado por esta specification; debe calcularse desde los bytes realmente producidos y revisarse contra el diff autorizado.

### 31.5 Governance

Debe resultar:

```text
repository mutation =
ONLY 4 AUTHORIZED DOCUMENTS

application code change =
NONE

SQL/migration change =
NONE

RLS executable change =
NONE

Supabase mutation =
NONE

Staging mutation =
NONE

Production mutation =
NONE

TASK-019 determined =
NO

Phase 2 closed =
NO

Phase 3 started =
NO
```

---

## 32. Git governance

CORR-034 preserva la secuencia:

```text
determination
→ specification generation
→ specification review
→ human approval
→ approved artifact generation
→ approved artifact review
→ canonicalization
→ canonicalization review
→ repository incorporation
→ repository incorporation review
→ execution authorization
→ documentation execution
→ execution review
→ staging
→ staging review
→ commit
→ commit review
→ push
→ remote verification
→ final human closure
```

Cada Gate es independiente.

Ningún Gate autoriza automáticamente el siguiente.

En particular:

```text
CORR-034 SPEC REVIEW = APPROVED
!=
CORR-034 EXECUTION AUTHORIZED
```

```text
CORR-034 EXECUTION = PASS
!=
STAGING AUTHORIZED
```

```text
CORR-034 COMMIT = PASS
!=
PUSH AUTHORIZED
```

```text
CORR-034 DONE
!=
TASK-019 DETERMINED
```

---

## 33. Plan futuro de ejecución documental

Sólo después de todos los Gates documentales previos y de una autorización humana separada de ejecución, el implementador deberá:

1. ejecutar preflight Git fresco;
2. verificar las cuatro identidades target;
3. leer íntegramente `01`, `02`, `03` y `11`;
4. leer la specification canónica CORR-034;
5. confirmar que A–J siguen vigentes;
6. confirmar que no existe ADR posterior que sustituya fronteras relevantes;
7. confirmar que `11 §14.2` sigue requiriendo exclusivamente la synchronization de `USER_CREATED producer timing`;
8. confirmar que no apareció una quinta target document;
9. modificar sólo `01/02/03` y `11 §14.2`;
10. tocar sólo las 20 superficies autorizadas;
11. sincronizar RF-012;
12. separar `PlatformUser` profile de `CompanyMembership`;
13. sincronizar lifecycle first-admin;
14. sincronizar permission/tenant resolution exception purpose-specific;
15. sincronizar `USER_CREATED`;
16. sincronizar idempotency/concurrency;
17. sincronizar `/pending-profile` → `/onboarding-complete`;
18. preservar todos los límites negativos;
19. preservar snapshots históricos;
20. preservar trailing whitespace fuera de líneas editadas;
21. ejecutar revisión del diff completo;
22. ejecutar `git diff --check`;
23. dejar todo unstaged;
24. devolver evidencia al Revisor Central;
25. no determinar TASK-019.

---

## 34. Autorevisión de specification

### 34.1 Scope

```text
target documents =
4

target semantic surfaces =
20

fifth target =
NO

F-034-001 incorporated into authorized scope =
YES

new product file =
NO
```

### 34.2 Decisions

```text
A consumed =
YES

B consumed =
YES

C consumed =
YES

D consumed =
YES

E consumed =
YES

F consumed =
YES

G consumed =
YES

H consumed =
YES

I consumed =
YES

J consumed =
YES

decision reopened =
NO
```

### 34.3 Architecture

```text
new ADR required =
NO

ADR-0002 preserved =
YES

ADR-0003 preserved =
YES

ADR-0019 preserved =
YES

ADR-0020 preserved =
YES
```

### 34.4 Security

```text
authenticated != authorized =
PRESERVED

Auth session != tenant authorization =
PRESERVED

caller-supplied tenant authority =
NO

caller-supplied role authority =
NO

generic privileged writer =
NO

service-role ordinary path =
NO
```

### 34.5 RLS / multitenancy

```text
RLS executable change =
NONE

generic membership write policy =
NO

tenant boundary change =
NONE

cross-tenant expansion =
NONE
```

### 34.6 Audit

```text
new AuditEvent action =
NO

USER_CREATED =
PRESERVED

USER_CREATED first-admin timing =
successful authoritative completion

duplicate USER_CREATED allowed =
NO
```

### 34.7 Phase governance

```text
TASK-019 determined =
NO

Phase 2 closed =
NO

Phase 2 Exit Gate defined =
NO

Phase 3 started =
NO
```

Resultado:

```text
CORR-034 SPECIFICATION SELF-REVIEW =
PASS
```

---

## 35. Estado final de esta specification

```text
CORR-034 DETERMINATION =
APPROVED — CORRECTED

CORR-034 DETERMINATION MINIMAL CORRECTION =
APPROVED

CORR-034 SPECIFICATION REGENERATION =
AUTHORIZED

CORR-034 SPECIFICATION =
APPROVED

CORR-034 SPEC REVIEW =
APPROVED

CORR-034 HUMAN SPEC APPROVAL =
APPROVED

CORR-034 APPROVED ARTIFACT REVIEW =
APPROVED

approved artifact generated =
YES

artifact state =
APPROVED

CHANGE REQUIRED documents =
4

authorized semantic surfaces =
20

UNEXPECTED ACTIVE STALE SURFACES =
0

CANONICAL CONTRADICTIONS =
0

new ADR required =
NO

CORR-034 canonicalized =
YES

CORR-034 repository incorporation =
NO

CORR-034 execution authorized =
NO

CORR-034 execution =
NOT PERFORMED

repository mutation =
NO

Codex mutation =
NO

Supabase mutation =
NO

git add =
NO

commit =
NO

push =
NO

TASK-019 =
NOT DETERMINED / NOT AUTHORIZED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED
```

---

## 36. Gate posterior

La canonicalización de CORR-034 no autoriza repository incorporation ni ejecución.

El siguiente Gate es:

```text
CORR-034 CANONICALIZATION REVIEW
```

Debe ser realizado por el Revisor Central mediante acto separado.

Si se aprueba:

```text
CORR-034 CANONICALIZATION REVIEW =
APPROVED
```

seguirá siendo necesaria autorización humana separada antes de incorporar el artefacto canónico al repositorio.

No copiar todavía el artefacto a `docs/tasks/`.

No ejecutar CORR-034.

No modificar `docs/product/`.

No determinar TASK-019.

---

<!-- FIN DEL DOCUMENTO CORR-034-first-admin-profile-completion-product-decision-sync.md -->
