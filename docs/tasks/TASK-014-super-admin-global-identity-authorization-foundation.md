# TASK-014 — Fundación mínima de identidad/autorización global de SUPER_ADMIN

## 1. Identificación

**ID:** `TASK-014`

**Título:** `TASK-014 — Fundación mínima de identidad/autorización global de SUPER_ADMIN`

**Tipo:** `IMPLEMENTATION TASK`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context principal:** `Identity & Authorization`

**Estado de esta segunda especificación corregida:** `APPROVED FOR IMPLEMENTATION`

**TASK-014 SPECIFICATION:**

```text
APPROVED FOR IMPLEMENTATION
```

**Archivo de entrega:**

`TASK-014-super-admin-global-identity-authorization-foundation-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`

**TASK-014 SPEC REVIEW:** `APPROVED`

**TASK-014 HUMAN SPEC APPROVAL:** `APPROVED`

**TASK-014 aprobada:** `SÍ`

**TASK-014 canonicalizada:** `NO`

**Implementación autorizada:** `NO`

**Implementación iniciada:** `NO`

**Codex autorizado:** `NO`

**Repositorio modificado durante esta especificación:** `NO`

**Supabase Cloud modificado durante esta especificación:** `NO`

**Hosted Development mutation authorized:** `NO`

**TASK-015:** `NOT GENERATED`

**Staging / commit / push:** `NO / NO / NO`

**ADR nuevo requerido:** `NO`

**TASK-014 PHYSICAL AUTHORITY MODEL DECISION:** `APPROVED / RESOLVED`

**TASK-014 AUTHORITATIVE MEMBERSHIP VISIBILITY DECISION:** `APPROVED / RESOLVED`

**Test fixture contract:** `RESOLVED`

La iteración anterior resolvió la representación física de autoridad global mediante:

```text
public.platform_users.is_super_admin
boolean NOT NULL DEFAULT false
```

Esta segunda corrección no reabre esa decisión. Resuelve exclusivamente la visibilidad autoritativa de la existencia de cualquier `CompanyMembership` —incluidas memberships disabled que puedan quedar ocultas por la RLS ordinaria— mediante una función/RPC PostgreSQL purpose-specific `SECURITY DEFINER` derivada sólo de `auth.uid()`, y formaliza el uso controlado de fixtures descartables de prueba.

La corrección preserva capability, objetivo, secuenciación, arquitectura, dominio conceptual, multitenancy, Auth/session boundary y alcance funcional de la versión base.

---

## 2. Estado formal de entrada consumido

Se consume exactamente:

```text
TASK-014 DETERMINATION = APPROVED

TASK ID = TASK-014

candidate title =
TASK-014 — Fundación mínima de identidad/autorización global de SUPER_ADMIN

candidate type = IMPLEMENTATION TASK

candidate capability =
Fundación mínima de identidad/autorización global de SUPER_ADMIN

candidate is PR-sized = YES

Phase 2 = INICIADA / NOT DONE

Phase 3 = NOT STARTED

new ADR required before TASK-014 specification = NO

architectural decision missing = NONE

blockers = NONE

TASK-014 specification allowed = YES

TASK-014 implementation = NOT STARTED
```

La decisión humana de secuenciación seleccionó esta capability antes del slice funcional de `disable/reinstate/role-change` de `CompanyMembership` con producción atómica de `AuditEvent`.

Ese candidato diferido:

```text
permanece pendiente
!=
cancelado
```

La secuenciación no se utiliza para ampliar requisitos.

---

### 2.1 Decisión física humana posterior consumida

Se consume como decisión formal adicional:

```text
TASK-014 PHYSICAL AUTHORITY MODEL DECISION = APPROVED
```

Materialización aprobada:

```text
public.platform_users.is_super_admin
```

Contrato físico:

```text
type = boolean
nullability = NOT NULL
default = false
```

Semántica aprobada:

```text
is_super_admin = true
→ autoridad global SUPER_ADMIN explícita y vigente

is_super_admin = false
→ ausencia de autoridad SUPER_ADMIN

NULL
→ NO PERMITIDO
```

Se preserva:

```text
CompanyMembership roles = COMPANY_ADMIN | TECHNICIAN
```

No se crea tabla global de roles, enum global de roles ni role `SUPER_ADMIN` dentro de `CompanyMembership`.

La ausencia de `CompanyMembership`, JWT/custom claims, Auth metadata, cookies, estado frontend, estado cliente stale y tenant/client IDs afirmados por caller no constituyen autoridad global.

---

### 2.2 Decisión humana sobre visibilidad autoritativa de membership

Se consume exactamente:

```text
TASK-014 AUTHORITATIVE MEMBERSHIP VISIBILITY DECISION = APPROVED
```

Para la clasificación global, la existencia de cualquier `CompanyMembership` del `PlatformUser` autenticado se resolverá mediante una función/RPC PostgreSQL:

```text
purpose-specific
SECURITY DEFINER
identity = auth.uid() only
```

Su finalidad única es obtener la información mínima necesaria para clasificar la identidad autenticada actual:

```text
PlatformUser resolvable / unresolvable
current is_super_admin
any CompanyMembership exists
```

La existencia incluye:

```text
enabled membership
disabled membership
```

La función no acepta autoridad ni target identity suministrados por caller.

### 2.3 Decisión humana sobre fixtures de testing

Se consume exactamente:

```text
test fixtures may set is_super_admin = true
only as disposable test setup
```

Debe permanecer:

```text
fixture mutation
!= functional SUPER_ADMIN grant
!= SUPER_ADMIN bootstrap
!= product capability
```

Fixtures permitidos quedan limitados a test/local/Development, deben ser descartables, identificables como test data y limpiarse obligatoriamente.


---

## 3. Fuentes canónicas consumidas

La especificación se deriva de las siguientes fuentes adjuntas/canónicas y de su estado vigente dentro del alcance que cada una gobierna:

### 3.1 Producto

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/04-offline-sync-strategy.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md`

### 3.2 Arquitectura

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`

### 3.3 Foundations de Fase 2

- `docs/tasks/TASK-009-identity-tenant-foundation.md`
- `docs/tasks/TASK-010-audit-event-foundation.md`
- `docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md`
- `docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`
- `docs/tasks/TASK-013-verification-challenge-foundation.md`
- `docs/tasks/CORR-018-task-013-closure-state-sync.md`

### 3.4 Regla de autoridad

Se preserva:

1. decisiones humanas posteriores explícitamente aprobadas dentro de su alcance;
2. baseline normativa de producto;
3. documentos derivados dentro de su bounded context;
4. ADR aceptados dentro de la decisión que documentan;
5. TASK/CORR como contrato de ejecución y estado, sin convertir snapshots históricos en estado actual.

La decisión física aprobada se incorpora únicamente dentro del alcance exacto autorizado por el acto humano posterior; no se utilizan alternativas ni conocimiento general para ampliarla.

---

## 4. Hechos canónicos inequívocos

### 4.1 Identidad y dominio

El concepto de identidad de aplicación es:

```text
PlatformUser
```

La identidad Auth se vincula mediante:

```text
Auth subject
→ PlatformUser
```

`CompanyMembership` representa exclusivamente autoridad tenant ordinaria:

```text
PlatformUser
→ MaintenanceCompany
→ role tenant
→ enabled/disabled
```

Los únicos roles tenant materializados por la foundation vigente son:

```text
COMPANY_ADMIN
TECHNICIAN
```

`SUPER_ADMIN`:

```text
es global / platform-scoped
no pertenece a tenants
no posee CompanyMembership
no es un role válido de CompanyMembership
```

### 4.2 Autenticación y autorización

Debe permanecer:

```text
authenticated != authorized
```

y:

```text
valid Auth session != authorization
```

La sesión Auth identifica un subject; no concede por sí misma:

- autoridad global;
- membership;
- tenant;
- role tenant;
- client scope;
- support scope;
- permiso funcional.

### 4.3 Autoridad vigente

Debe permanecer:

```text
current authoritative state
>
JWT/session/cookies/frontend/client state
```

Claims, metadata, cache o estado cliente pueden ser hints técnicos sólo si una eventual implementación aprobada los usa sin convertirlos en autoridad.

### 4.4 `SUPER_ADMIN` y tenant

Debe permanecer:

```text
SUPER_ADMIN ordinary tenant bypass = NO
```

y:

```text
missing CompanyMembership
!=
SUPER_ADMIN
```

y:

```text
lookup failure
!=
SUPER_ADMIN
```

y:

```text
unknown tenant
!=
SUPER_ADMIN
```

y:

```text
stale claim
!=
SUPER_ADMIN authority
```

### 4.5 RLS

Para datos tenant-owned:

```text
RLS = primary remote isolation boundary
```

La autoridad global de plataforma no crea una policy ordinaria de bypass tenant.

### 4.6 Offline

TASK-014 no implementa trabajo de campo, réplica local, lease offline, outbox ni sincronización.

```text
offline relevance = NO
```

### 4.7 UI

La capability determinada es una foundation de identidad/autorización y no contiene un flujo de usuario aprobado.

```text
UI = NOT IN SCOPE
```

---

## 5. Decisión física de autoridad global resuelta

### 5.1 Hecho físico previo preservado

TASK-009 materializó:

```text
public.maintenance_companies
public.platform_users
public.platform_user_auth_subjects
public.company_memberships
```

y dejó expresamente diferida la clasificación física global `SUPER_ADMIN`.

El modelo previo conocido contiene:

```text
maintenance_companies.id

platform_users.id

platform_user_auth_subjects.auth_subject_id
platform_user_auth_subjects.platform_user_id

company_memberships.id
company_memberships.platform_user_id
company_memberships.maintenance_company_id
company_memberships.role
company_memberships.is_enabled
```

### 5.2 Decisión humana aprobada

El blocker de la primera especificación queda resuelto exactamente mediante:

```text
TASK-014 PHYSICAL AUTHORITY MODEL DECISION = APPROVED
```

Fuente PostgreSQL autoritativa actual:

```text
public.platform_users.is_super_admin
```

Contrato físico conceptual:

```text
column = is_super_admin
type = boolean
nullability = NOT NULL
default = false
```

Semántica:

```text
is_super_admin = true
→ explicit current global SUPER_ADMIN authority

is_super_admin = false
→ no global SUPER_ADMIN authority
```

No existe semántica `NULL`.

### 5.3 Existing-row semantics

La migration futura debe preservar todas las filas existentes y materializar para ellas:

```text
is_super_admin = false
```

Ninguna fila existente puede convertirse automáticamente en `SUPER_ADMIN`.

TASK-014 no identifica ni selecciona un usuario existente para elevarlo.

```text
bootstrap real de SUPER_ADMIN = OUT OF SCOPE
```

### 5.4 Exclusión mutua obligatoria

El estado:

```text
PlatformUser.is_super_admin = true
AND
CompanyMembership existente para ese PlatformUser
```

es:

```text
INCONSISTENT STATE
```

La autorización debe:

```text
FAIL CLOSED
```

No puede:

- priorizar la rama global;
- priorizar la rama tenant;
- reparar automáticamente;
- borrar la membership;
- cambiar `is_super_admin`;
- convertir la inconsistencia en autorización.

La futura implementation debe detectar autoritativamente esa coexistencia.

### 5.5 Modelo no adoptado

No se adopta:

- tabla global de roles;
- enum global de roles;
- role `SUPER_ADMIN` en `CompanyMembership`;
- autoridad por ausencia de membership;
- autoridad por JWT/custom claim;
- autoridad por Auth metadata;
- autoridad por cookie/frontend/client state;
- policy de bypass tenant.

---

### 5.6 Decisión de visibilidad autoritativa de membership resuelta

La exclusión mutua aprobada requiere conocer si existe cualquier `CompanyMembership` para el `PlatformUser`, incluso cuando la membership está disabled.

Se fija:

```text
ordinary company_memberships SELECT visibility
!=
sufficient source for global/tenant exclusion-mutuality check
```

La reason es que la RLS ordinaria vigente puede ocultar una membership disabled al caller normal.

La decisión humana aprobada establece una función/RPC purpose-specific `SECURITY DEFINER` que:

```text
deriva identity exclusivamente de auth.uid()
```

y resuelve únicamente:

```text
PlatformUser corresponding to auth.uid()
current is_super_admin
any CompanyMembership exists
```

No devuelve detalles de membership ni datos operativos tenant.

Debe permanecer:

```text
disabled CompanyMembership
→ may remain invisible through ordinary RLS
→ still counts as existing for dual-authority inconsistency detection
```

La RLS ordinaria de `company_memberships` no se modifica para resolver esta necesidad.


---

## 6. Shape exacto del incremento

TASK-014 queda completamente especificada como un único incremento PR-sized con dos componentes inseparables.

### 6.1 A. Physical Global Authority Foundation

La implementación futura debe:

- introducir una migration mínima sobre `public.platform_users`;
- añadir exclusivamente `is_super_admin` con contrato `boolean NOT NULL DEFAULT false`;
- preservar filas existentes;
- materializar `false` para filas existentes;
- no promover automáticamente ningún `PlatformUser`;
- no alterar IDs;
- no alterar el mapping Auth subject → `PlatformUser`;
- no alterar `CompanyMembership`;
- no alterar el catálogo de roles tenant;
- no crear tablas globales de roles;
- no crear enum global de roles;
- no crear tenant bypass policy.

### 6.2 B. Authoritative Server-Side SUPER_ADMIN Resolution Foundation

La implementación futura debe añadir una frontera server-side reutilizable que consuma, mediante cliente Supabase caller-scoped, una función/RPC PostgreSQL purpose-specific.

El contrato físico/security del RPC es:

```text
security mode = SECURITY DEFINER
purpose = global identity classification only
identity = auth.uid() only
caller-scoped Supabase client = YES
service-role = NO
generic privileged server client = NO
tenant operational data returned = NO
CompanyMembership details returned = NO
membership existence exposed semantically = YES
disabled membership considered for existence = YES
caller-selected PlatformUser = NO
caller-selected tenant = NO
caller-selected client = NO
```

La función puede exponer exclusivamente la información mínima necesaria para clasificar:

```text
identity resolvable / unresolvable
current is_super_admin
any CompanyMembership exists
```

No puede exponer:

- `maintenance_company_id`;
- membership role;
- `is_enabled`;
- client scope;
- tenant resources;
- `SupportAccessGrant`;
- arbitrary rows.

El resolver server-side debe distinguir semánticamente al menos:

```text
AUTHORIZED_GLOBAL_SUPER_ADMIN
NOT_GLOBAL_SUPER_ADMIN
INCONSISTENT_GLOBAL_AND_TENANT_IDENTITY
UNRESOLVABLE_IDENTITY / DENIED
```

Estos nombres son equivalentes semánticos, no nombres TypeScript obligatorios.

No se fijan endpoints, routes, códigos HTTP, nombres concretos de tipos ni paths físicos.

### 6.3 Hardening obligatorio del RPC

La función `SECURITY DEFINER` debe quedar limitada al propósito anterior y exigir:

- `search_path` fijo y seguro;
- referencias de objetos no ambiguas;
- no dependencia de un `search_path` manipulable;
- `EXECUTE` revocado de `PUBLIC`;
- `EXECUTE` mínimo sólo al rol requerido por el contrato;
- ningún grant innecesario;
- no dynamic SQL salvo necesidad canónica explícita;
- ningún identificador caller-controlled para seleccionar identidad;
- ninguna capacidad genérica de consulta privilegiada;
- fail-closed ante error;
- cero mutaciones dentro del resolver read-only.

Si la versión PostgreSQL/Supabase vigente exige hardening adicional material durante implementation, debe verificarse contra documentación oficial y detenerse ante contradicción.

### 6.4 Scope físico permitido

La futura implementation de TASK-014 queda limitada a:

1. migration de `public.platform_users.is_super_admin`;
2. función/RPC purpose-specific de clasificación global;
3. privileges estrictamente necesarios para esa función;
4. resolver server-side/application boundary que la consume con caller-scoped client;
5. tests.

Puede incluir exclusivamente grants/revokes requeridos para asegurar el contrato de ejecución de la función.

No puede incluir:

- tenant bypass policy;
- nuevas policies de acceso operativo tenant;
- generic `SECURITY DEFINER` helper;
- generic admin RPC;
- grant/revoke funcional de `SUPER_ADMIN`;
- bootstrap funcional;
- `SupportAccessGrant`;
- `Client` / `UserClientAccess`;
- UI;
- endpoints funcionales de negocio.

### 6.5 Decisión arquitectónica

```text
new ADR required = NO
```

La materialización física y la función purpose-specific no modifican ADR-0001, ADR-0002, ADR-0003 ni ADR-0019.

---

## 7. Objetivo técnico vigente

TASK-014 debe materializar exclusivamente una foundation mínima capaz de resolver:

```text
validated Auth subject
→ PlatformUser
→ current is_super_admin state
→ minimal global authorization resolution
```

sin convertirla en:

```text
tenant membership
```

ni en:

```text
ordinary tenant access
```

La boundary server-side:

- recibe una identidad Auth ya validada server-side;
- resuelve Auth subject → `PlatformUser` mediante la foundation existente;
- consulta el estado PostgreSQL autoritativo actual;
- evalúa la coexistencia con cualquier `CompanyMembership` para detectar el estado inconsistente;
- no confía en claims stale;
- no confía en metadata;
- no confía en frontend;
- no confía en ausencia de membership;
- no conserva autoridad stale entre requests;
- falla cerrado ante error.

Debe permitir responder únicamente si existe autoridad global `SUPER_ADMIN` actual y coherente para el `PlatformUser`.

No responde todavía:

- si puede acceder a un `Client`;
- si puede usar soporte excepcional;
- si puede operar un recurso tenant;
- si puede ejecutar una route funcional;
- si puede realizar una mutación tenant;
- si puede crear una `MaintenanceCompany`;
- si puede iniciar onboarding;
- si puede crear usuarios;
- si puede modificar memberships;
- si puede otorgar o revocar `SUPER_ADMIN`.

---

El objetivo incluye que una membership disabled, aunque permanezca invisible por la RLS ordinaria, sea contabilizada como existencia para detectar el estado dual inconsistente.

El resolver global no debe usar un `SELECT` ordinario sobre `company_memberships` como prueba negativa de inexistencia.


---

## 8. Dominio e invariantes obligatorias

La solución especificada debe preservar:

```text
PlatformUser = identidad reconocida por la plataforma
```

```text
CompanyMembership = ordinary tenant membership authority
```

```text
SUPER_ADMIN = explicit global/platform-scoped authority
```

```text
SUPER_ADMIN no posee CompanyMembership
```

```text
SUPER_ADMIN authority inferred from missing CompanyMembership = NO
```

```text
tenant = MaintenanceCompany
```

```text
global/platform-scoped
!=
tenant-owned
```

```text
global/platform-scoped
!=
tenant bypass
```

```text
authenticated != authorized
```

```text
current authoritative state > stale token/client state
```

```text
cannot prove authority
→ DENY
```

La representación física aprobada hace verificable la exclusión mutua. Si `is_super_admin = true` y existe cualquier `CompanyMembership` para el mismo `PlatformUser`, el estado es inconsistente y la resolución debe fallar cerrada sin seleccionar, priorizar ni reparar ninguna rama.

---

La exclusión mutua considera:

```text
CompanyMembership existente
=
enabled OR disabled
```

Por tanto:

```text
is_super_admin = true
AND disabled CompanyMembership exists
→ INCONSISTENT
→ DENY
```

La invisibilidad ordinaria de una membership disabled por RLS no cambia su existencia de dominio ni puede convertirla en evidencia de identidad global-only.


---

## 9. Interacción obligatoria con TASK-012

TASK-012 implementó exclusivamente el resolver tenant:

```text
validated Auth subject
→ PlatformUser
→ current enabled CompanyMembership
→ MaintenanceCompany
→ current tenant role
```

TASK-014 no modifica esa semántica.

En particular, está prohibido transformar:

```text
missing CompanyMembership
```

en:

```text
SUPER_ADMIN
```

La nueva foundation global permanece separada y utiliza como fuente positiva exclusiva:

```text
public.platform_users.is_super_admin = true
```

La composición semántica debe preservar:

```text
is_super_admin = true
AND no CompanyMembership
→ global SUPER_ADMIN authority resolved
```

```text
is_super_admin = false
AND valid enabled/current CompanyMembership
→ NOT global SUPER_ADMIN
→ tenant authorization puede continuar por TASK-012
```

```text
is_super_admin = false
AND no CompanyMembership
→ no global authority
→ no tenant authority por inferencia
```

```text
is_super_admin = true
AND CompanyMembership existente
→ INCONSISTENT
→ DENY / FAIL CLOSED
```

El global resolver no sustituye el tenant resolver y TASK-012 no se convierte en resolver global.

Reglas obligatorias:

```text
tenant resolver DENY
!=
global resolver ALLOW por inferencia
```

```text
missing membership
!=
global authority
```

```text
missing global authority
!=
tenant authority
```

```text
conflicting/inconsistent state
→ DENY
```

---

TASK-014 añade una boundary diferente para clasificación global y no convierte TASK-012 en un resolver global-or-tenant monolítico.

La función purpose-specific de TASK-014 puede observar la existencia de membership disabled exclusivamente para clasificar la identidad global. Ese conocimiento no modifica ni amplía el contrato ordinario de TASK-012:

```text
enabled/current CompanyMembership
→ tenant resolver
```

Una membership disabled:

```text
counts for dual-authority inconsistency detection in TASK-014
but
does not become enabled tenant authority
```


---

## 10. Auth / session boundary

TASK-014 consume, pero no rediseña:

- lifecycle SSR de TASK-011;
- Auth subject validado server-side;
- E2/ADR-0019;
- `VerificationChallenge`;
- `SessionGrant`;
- server-only technical-password bridge;
- Custom Access Token Hook gate implementado por TASK-013;
- E2 SESSION CUTOVER.

Debe permanecer:

```text
Auth session
→ identifica técnicamente al subject
```

pero:

```text
Auth session
!=
SUPER_ADMIN authority
```

La autoridad actual proviene de:

```text
public.platform_users.is_super_admin
```

consultado autoritativamente desde la boundary server-side.

No se autoriza:

- nuevo login;
- nuevo método Auth;
- cambio de E2;
- cambio de hook;
- añadir `is_super_admin` como claim requerido;
- custom claim de `SUPER_ADMIN` como fuente de verdad;
- metadata Auth como fuente autoritativa;
- cambio de JWT semantics.

Matriz claim/DB obligatoria:

```text
stale claim says SUPER_ADMIN + DB false
→ DENY global authority
```

```text
claim omits SUPER_ADMIN + DB true + no CompanyMembership
→ global authority may be recognized from authoritative DB state
```

El token no es requisito para transportar la clasificación global.

---

## 11. RLS y modelo de datos

### 11.1 Clasificación concreta del incremento

La decisión física y la decisión de visibilidad permiten cerrar:

```text
schema change = YES
application/server resolver change = YES
purpose-specific SECURITY DEFINER RPC = YES
```

Debe permanecer:

```text
new tenant bypass RLS policy = NO
modified tenant bypass RLS policy = NO
existing tenant RLS weakened = NO
ordinary authenticated write access to is_super_admin = NO
service-role ordinary resolver = NO
```

### 11.2 Modelo físico mínimo aprobado

Tabla existente:

```text
public.platform_users
```

Nueva columna:

```text
is_super_admin
```

Contrato:

```text
type = boolean
NOT NULL
default = false
```

Existing-row semantics:

```text
all existing platform_users
→ is_super_admin = false
```

Ninguna migration de TASK-014 puede marcar arbitrariamente una fila existente como `true`.

### 11.3 Migration requirements

La futura migration debe ser nueva, forward-only, gestionada por el sistema normal de migrations Supabase del repositorio y limitada al cambio físico aprobado y a la función/privileges purpose-specific autorizados por esta specification.

Debe:

- preservar todas las identidades existentes;
- preservar Auth subject → `PlatformUser`;
- preservar `CompanyMembership`;
- preservar roles tenant `COMPANY_ADMIN` / `TECHNICIAN`;
- preservar RLS tenant ordinaria;
- no crear tabla global de roles;
- no crear enum global;
- no crear bypass tenant;
- no borrar datos;
- no resetear DB como mecanismo de implementación;
- no usar SQL ad hoc repetido como sustituto del migration system.

El nombre/timestamp real debe determinarse contra el repo durante implementation preflight.

Este documento no contiene SQL ejecutable.

### 11.4 Ambigüedad de visibilidad ordinaria resuelta

TASK-009 puede ocultar a un caller normal una `CompanyMembership` disabled.

Por tanto:

```text
ordinary company_memberships SELECT visibility
!=
authoritative evidence that no CompanyMembership exists
```

La función purpose-specific puede observar la existencia física de cualquier `CompanyMembership` exclusivamente para la clasificación global del propio `auth.uid()`.

Esto NO modifica:

- policy normal de lectura de `company_memberships`;
- visibilidad ordinaria de memberships disabled;
- tenant RLS;
- tenant ownership;
- client scope;
- tenant authorization.

Debe permanecer:

```text
disabled CompanyMembership
→ may remain invisible through ordinary RLS
→ still counts as existing
→ is_super_admin=true + disabled membership = INCONSISTENT / DENY
```

### 11.5 Contrato de privilegio de la función

Debe distinguirse:

```text
purpose-specific SECURITY DEFINER
!= service-role
!= generic privileged server client
!= tenant bypass
```

La función puede elevar acceso técnico únicamente en la medida necesaria para:

```text
auth.uid()
→ PlatformUser
→ current is_super_admin
→ membership existence
```

No puede seleccionar otro `PlatformUser` por ID suministrado por caller.

No puede aceptar como autoridad:

- auth subject caller-supplied;
- `platform_user_id` caller-supplied;
- `maintenance_company_id` caller-supplied;
- tenant/client ID caller-supplied;
- role caller-supplied;
- `is_super_admin` caller-supplied.

### 11.6 Hardening obligatorio de SECURITY DEFINER

La implementation debe verificar:

- `search_path` fijo y seguro;
- referencias de objetos no ambiguas;
- ausencia de dependencia de `search_path` manipulable;
- `PUBLIC` sin `EXECUTE`;
- grant mínimo de `EXECUTE` sólo al rol requerido;
- ausencia de grants innecesarios;
- ausencia de dynamic SQL salvo razón canónica explícita;
- ausencia de target identifiers caller-controlled;
- output mínimo;
- función read-only;
- fail-closed ante error;
- ausencia de capacidad genérica reutilizable para consultas privilegiadas arbitrarias.

Si la plataforma/versión vigente exige un hardening adicional incompatible con esta specification:

```text
BLOCKER
```

No improvisar.

### 11.7 Protección de mutación

La nueva columna no puede convertirse en vía de auto-escalamiento.

```text
authenticated / normal application access
→ NO authoritative write to is_super_admin
```

La función de clasificación:

```text
performs no writes
cannot mutate is_super_admin
cannot mutate CompanyMembership
```

TASK-014 no implementa `false → true` ni `true → false`.

### 11.8 Lectura del propio `PlatformUser`

Si el modelo RLS/grants vigente permite leer la propia fila `PlatformUser`, la observación del boolean global:

```text
!= capacidad para mutarlo
!= tenant authorization
!= SupportAccessGrant
!= tenant bypass
```

La autorización server-side no debe depender de un boolean enviado de vuelta por el browser.

### 11.9 Aislamiento tenant

Debe permanecer:

```text
RLS tenant existente → NO se debilita
SUPER_ADMIN authority != ordinary tenant access
SUPER_ADMIN authority != RLS bypass
browser-provided role/tenant/client → NO authority
```

No se diseña ninguna policy tenant bypass ejecutable en este documento.

---

## 12. AuditEvent

### 12.1 Foundation existente

TASK-010 materializó `AuditEvent` como foundation tenant-owned y con catálogo físico inicial limitado a:

```text
USER_CREATED
USER_DISABLED_OR_REVOKED
USER_REINSTATED
USER_ROLE_CHANGED
```

No existe en esa foundation un `AuditEvent` global de plataforma.

### 12.2 Resolver read-only

La resolución read-only:

```text
Auth subject
→ PlatformUser
→ current is_super_admin lookup
```

no constituye una mutación de dominio y no debe producir `AuditEvent`, en coherencia con TASK-012.

```text
read-only SUPER_ADMIN resolution
→ AuditEvent producer = NO
```

### 12.3 Migration

La migration que añade el campo físico de autoridad:

```text
→ no functional AuditEvent producer
```

No se inventa una nueva `action` ni se amplía el catálogo de TASK-010.

### 12.4 Grant/revoke futuro

TASK-014 no implementa:

```text
grant SUPER_ADMIN
revoke SUPER_ADMIN
bootstrap SUPER_ADMIN
admin SUPER_ADMIN
```

Cualquier transición futura:

```text
false → true
true → false
```

requiere una specification e implementación separadas que definan actor autorizado, autorización, atomicidad y auditoría aplicable.

---

## 13. Supabase Cloud

TASK-014 introduce un cambio de schema.

Por tanto:

```text
Hosted Development verification = REQUIRED
```

La secuencia obligatoria de una futura ejecución es:

```text
local implementation/test first
→ human implementation review
→ separate Hosted Development mutation authorization
→ migration application in Development
→ remote verification
→ regression verification
→ Git closure gates separately authorized
```

La specification actual no realiza ninguna mutación Cloud.

Debe permanecer:

```text
Staging = NO CHANGE
Production = NO CHANGE
```

Toda mutación de Supabase Cloud Development requiere autorización humana separada.

No se autoriza durante esta especificación:

- `db push`;
- migration aplicada;
- policy ejecutable;
- grant/revoke funcional;
- Auth hook/config change;
- Auth config change;
- session mutation;
- secret creation;
- secret rotation.

Nunca deben aparecer en documentación, diff, logs u output:

- DB password;
- access tokens;
- secret keys;
- service-role;
- technical password;
- otros secretos.

---

Hosted Development verification debe incluir ahora también:

- existencia de la función/RPC purpose-specific esperada;
- propiedad `SECURITY DEFINER`;
- hardening de `search_path`;
- grants/EXECUTE exactos;
- ausencia de `PUBLIC EXECUTE`;
- ausencia de funciones/overloads privilegiados inesperados;
- comportamiento de matriz global con membership enabled y disabled;
- RLS ordinaria de disabled memberships sin cambios;
- fixtures de Development exclusivamente test-only;
- cleanup de fixtures;
- post-cleanup verification;
- ausencia de objetos, policies, grants o config changes inesperados.

Durante el Gate de Cloud pueden autorizarse fixtures descartables exclusivamente para verificar la foundation:

```text
real production user = NO
real tenant operational data = NO
test-only identity = YES
test-only PlatformUser = YES
test-only membership when needed = YES
cleanup after verification = REQUIRED
post-cleanup verification = REQUIRED
```

El Gate debe verificar antes y después los fixtures y artifacts temporales aplicables.

Un cleanup incompleto:

```text
→ BLOCKER
→ no cierre
```


---

## 14. Offline

```text
offline relevance = NO
```

Razón:

TASK-014 resuelve una autoridad global actual y server-side. El canon exige que autorización online sensible se base en estado autoritativo vigente, mientras la estrategia offline aplica a operación de campo aprobada y a un contrato distinto de autorización offline.

Este slice no incluye:

- IndexedDB;
- Dexie;
- local replica;
- outbox;
- sync queue;
- conflict resolution;
- offline lease;
- cache autorizativa offline;
- persistencia local de autoridad `SUPER_ADMIN`.

La estrategia offline existente permanece intacta.

---

## 15. UI / UX

```text
UI = NOT IN SCOPE
```

No existe una pantalla aprobada propia de esta foundation.

No se implementa:

- login UI;
- onboarding;
- administración de `SUPER_ADMIN`;
- asignación de autoridad;
- revocación de autoridad;
- creación de tenant;
- creación de primer `COMPANY_ADMIN`;
- route guard UI;
- dashboard global.

La futura implementation autorizada deberá limitarse a la migration física aprobada, boundaries internas server-side y tests correspondientes; no añade UI.

---

## 16. Alcance expresamente excluido

Permanece fuera de TASK-014:

1. Auth funcional completo;
2. UI/Auth flow funcional completo;
3. onboarding funcional completo;
4. alta funcional completa del primer `COMPANY_ADMIN`;
5. alta funcional completa de usuarios posteriores;
6. creación funcional completa de `MaintenanceCompany`;
7. disable/reinstate/role-change de `CompanyMembership`;
8. productores funcionales completos de `AuditEvent`;
9. auditoría funcional completa;
10. route authorization completa;
11. resource authorization completa;
12. Application authorization completa;
13. `Client`;
14. `UserClientAccess`;
15. `SupportAccessGrant`;
16. Client authorization;
17. Support authorization;
18. acceso cross-tenant funcional;
19. bypass tenant de `SUPER_ADMIN`;
20. offline;
21. Storage funcional;
22. Realtime funcional;
23. Phase 2 Exit Gate;
24. Phase 2 completion;
25. Phase 3;
26. TASK posterior a TASK-014.

Nada de este alcance se cancela por estar diferido.

---

## 17. Requisitos funcionales

**RF-001.** La foundation DEBE consumir una identidad Auth validada server-side y utilizar el Auth subject únicamente como anchor para resolver `PlatformUser`.

**RF-002.** La autoridad `SUPER_ADMIN` DEBE ser explícita, global y platform-scoped.

**RF-003.** La ausencia de `CompanyMembership` NO DEBE interpretarse como autoridad `SUPER_ADMIN`.

**RF-004.** `CompanyMembership` DEBE continuar siendo la autoridad tenant ordinaria para `COMPANY_ADMIN` y `TECHNICIAN`.

**RF-005.** Un `PlatformUser` con `is_super_admin = false` DEBE resultar no autorizado como `SUPER_ADMIN`.

**RF-006.** Un lookup fallido, vacío, ambiguo o inconsistente DEBE resultar en denegación.

**RF-007.** Claims, metadata Auth, cookies, headers, parámetros, query, body, local state o cache NO DEBEN otorgar autoridad global por sí mismos.

**RF-008.** La foundation global NO DEBE producir un contexto tenant ordinario.

**RF-009.** La foundation global NO DEBE conceder acceso operativo tenant.

**RF-010.** La foundation global NO DEBE crear `CompanyMembership`.

**RF-011.** La foundation global NO DEBE crear `SupportAccessGrant`.

**RF-012.** La foundation global NO DEBE resolver client scope.

**RF-013.** La resolución global DEBE permanecer separada semánticamente del resolver tenant de TASK-012.

**RF-014.** Un resultado denegado del resolver tenant NO DEBE convertirse automáticamente en un resultado permitido global.

**RF-015.** Un resultado denegado del resolver global NO DEBE convertirse automáticamente en un resultado permitido tenant.

**RF-016.** La mera resolución read-only de autoridad global NO DEBE producir `AuditEvent`.

**RF-017.** La mutación funcional de autoridad `SUPER_ADMIN` DEBE permanecer fuera de alcance de este slice.

**RF-018.** La implementation NO DEBE alterar E2/ADR-0019 ni el lifecycle de `VerificationChallenge`/`SessionGrant`.

**RF-019.** La autoridad global actual DEBE provenir de `public.platform_users.is_super_admin`.

**RF-020.** `is_super_admin = true` DEBE representar autoridad global `SUPER_ADMIN` explícita y vigente, siempre que no exista `CompanyMembership` para ese `PlatformUser`.

**RF-021.** `is_super_admin = false` DEBE representar ausencia de autoridad global `SUPER_ADMIN`.

**RF-022.** `is_super_admin = true` junto con cualquier `CompanyMembership` existente para el mismo `PlatformUser` DEBE producir estado inconsistente y fail-closed.

**RF-023.** La migration DEBE dejar `is_super_admin = false` para todas las filas existentes y NO DEBE promover automáticamente ninguna identidad.

**RF-024.** TASK-014 NO DEBE implementar bootstrap, grant, revoke ni administración funcional de `SUPER_ADMIN`.

**RF-025.** Un claim que omite `SUPER_ADMIN` NO DEBE impedir reconocer autoridad cuando `is_super_admin = true`, la identidad es resolvible y no existe `CompanyMembership`.

**RF-026.** El resolver global DEBE consultar estado autoritativo actual por request y NO DEBE conservar una autoridad stale entre requests.

**RF-027.** La nueva foundation DEBE distinguir semánticamente global autorizado, no-global, identidad inconsistente e identidad irresoluble/denegada sin fijar endpoints, códigos HTTP ni nombres TypeScript concretos.

---

**RF-028.** La clasificación global DEBE utilizar una función/RPC PostgreSQL purpose-specific `SECURITY DEFINER` cuya identidad derive exclusivamente de `auth.uid()`.

**RF-029.** La función DEBE resolver exclusivamente el `PlatformUser` correspondiente al `auth.uid()` actual, su `is_super_admin` vigente y si existe cualquier `CompanyMembership`.

**RF-030.** La existencia de membership DEBE incluir memberships enabled y disabled.

**RF-031.** El resolver global NO DEBE utilizar la visibilidad ordinaria de `company_memberships` como prueba suficiente de inexistencia.

**RF-032.** La función NO DEBE aceptar un `PlatformUser`, Auth subject, tenant, client, role o `is_super_admin` seleccionable por caller como autoridad.

**RF-033.** La función NO DEBE devolver detalles de membership, tenant operational data, client scope ni `SupportAccessGrant`.

**RF-034.** El resolver server-side DEBE invocar la función mediante un cliente Supabase caller-scoped y NO mediante `service-role`.

**RF-035.** `is_super_admin = true` junto con una membership disabled DEBE clasificarse como estado inconsistente y denegarse.

**RF-036.** Fixtures de test PUEDEN establecer `is_super_admin = true` exclusivamente como setup descartable de pruebas y NO constituyen grant/bootstrap funcional.

**RF-037.** Fixtures locales y Hosted Development DEBEN utilizar sólo identidades/datos de test y DEBEN limpiarse al finalizar.

**RF-038.** Un fallo de cleanup de fixtures Hosted Development DEBE bloquear el cierre de TASK-014.


---

## 18. Requisitos no funcionales

**RNF-001.** TypeScript DEBE permanecer en modo strict.

**RNF-002.** La solución DEBE permanecer dentro del monolito modular Next.js aprobado.

**RNF-003.** La lógica de autorización global DEBE pertenecer conceptualmente al módulo `Identity & Authorization`.

**RNF-004.** No se introducirán microservicios.

**RNF-005.** La boundary de resolución global DEBE ser server-only y purpose-specific; cualquier mecanismo privilegiado futuro de mutación queda fuera de TASK-014.

**RNF-006.** Ningún secreto, token administrativo o credential privilegiada DEBE exponerse al browser, documentación o logs.

---

**RNF-007.** La función privilegiada DEBE permanecer purpose-specific y no convertirse en helper genérico, admin RPC reutilizable ni segundo subsistema de identidad.


---

## 19. Requisitos de seguridad

**SEC-001.** El sistema DEBE preservar `authenticated != authorized`.

**SEC-002.** La autoridad global DEBE resolverse desde current authoritative PostgreSQL state.

**SEC-003.** Un claim stale de `SUPER_ADMIN` NO DEBE conceder autoridad cuando `is_super_admin = false`.

**SEC-004.** Un claim forjado de `SUPER_ADMIN` NO DEBE conceder autoridad.

**SEC-005.** Un `PlatformUser` sin membership NO DEBE adquirir privilegio global por inferencia.

**SEC-006.** Un usuario tenant NO DEBE escalar a `SUPER_ADMIN` modificando inputs del cliente.

**SEC-007.** Un `SUPER_ADMIN` NO DEBE adquirir ordinary tenant bypass.

**SEC-008.** Fallos de consulta DEBEN ser fail-closed.

**SEC-009.** Datos ambiguos, mappings duplicados o estados incompatibles DEBEN ser tratados como inconsistencia y denegados.

**SEC-010.** La frontera server-side NO DEBE asumir que server-side equivale a authorized.

**SEC-011.** `service-role`, secret key, Admin Auth API o bypass RLS NO DEBEN utilizarse como camino ordinario para resolver autoridad.

**SEC-012.** El browser NO DEBE recibir credenciales privilegiadas ni convertirse en fuente autoritativa manipulable de autoridad global.

**SEC-013.** La resolución DEBE consultar current authoritative state para cada request relevante y NO DEBE reutilizar autoridad stale como decisión vigente.

**SEC-014.** `is_super_admin = true` junto con cualquier `CompanyMembership` existente DEBE fallar cerrado sin priorizar, reparar ni mutar automáticamente ninguna rama.

**SEC-015.** Una Auth session inválida o una identidad Auth no validada NO DEBEN llegar a una resolución global exitosa.

**SEC-016.** TASK-014 NO DEBE inventar un estado adicional `enabled/revoked` para `PlatformUser`; el boolean aprobado es la clasificación global actual.

**SEC-017.** El acceso normal `authenticated` NO DEBE poder modificar autoritativamente `is_super_admin`.

**SEC-018.** Ninguna mutation genérica de `PlatformUser` DEBE habilitarse como sustituto de un futuro caso de uso de grant/revoke.

**SEC-019.** La migration NO DEBE marcar arbitrariamente a un usuario existente como `SUPER_ADMIN`.

**SEC-020.** La observación cliente de `is_super_admin`, si deriva de permisos de lectura ya existentes, NO DEBE convertirse en fuente de autorización ni en capacidad de mutación.

**SEC-021.** Un caller-provided tenant/company/client identifier NO DEBE alterar la resolución global.

**SEC-022.** Un estado DB `is_super_admin = true` DEBE poder ser reconocido sin exigir que el JWT/custom claim transporte esa clasificación.

**SEC-023.** Cualquier necesidad de usar un cliente server privilegiado genérico para requests ordinarias DEBE producir `BLOCKER`; no se introducirá `service-role` como boundary normal.

---

**SEC-024.** El RPC `SECURITY DEFINER` DEBE derivar identidad exclusivamente de `auth.uid()`.

**SEC-025.** El RPC NO DEBE permitir target arbitrario de otro `PlatformUser` ni aceptar IDs caller-controlled para seleccionar identidad.

**SEC-026.** El RPC DEBE utilizar `search_path` fijo/seguro y referencias no ambiguas, sin depender de un `search_path` manipulable.

**SEC-027.** `EXECUTE` DEBE estar revocado de `PUBLIC` y concedido únicamente al rol mínimo requerido por el contrato.

**SEC-028.** El RPC NO DEBE divulgar membership role, `is_enabled`, tenant ID, client scope, tenant data ni filas arbitrarias.

**SEC-029.** El RPC DEBE ser read-only y NO DEBE mutar `is_super_admin`, `CompanyMembership` ni otros datos.

**SEC-030.** El RPC NO DEBE convertirse en generic privileged SQL escape hatch ni generic admin function.

**SEC-031.** Una membership disabled oculta por RLS ordinaria DEBE seguir detectándose como existencia para la exclusión mutua global/tenant.

**SEC-032.** La aplicación DEBE consumir el RPC mediante cliente caller-scoped; `service-role` y generic privileged server client permanecen prohibidos como resolver ordinario.

**SEC-033.** Fixtures con `is_super_admin=true` DEBEN estar aislados a test/local/Development, ser descartables e identificables como test data.

**SEC-034.** Ningún fixture DEBE utilizar usuarios reales, datos productivos ni persistir autoridad accidental después de la verificación.

**SEC-035.** Cleanup de fixtures y post-cleanup assertions DEBEN completarse antes de considerar PASS la verificación Hosted Development.


---

## 20. Requisitos RLS / aislamiento

**RLS-001.** RLS DEBE continuar siendo la frontera primaria para datos tenant-owned.

**RLS-002.** TASK-014 NO DEBE introducir una policy `SUPER_ADMIN` que conceda acceso tenant ordinario por defecto.

**RLS-003.** La ausencia de membership NO DEBE utilizarse en RLS como condición de bypass.

**RLS-004.** Recursos globales como `PlatformUser` NO DEBEN volverse públicamente enumerables por ser globales.

**RLS-005.** `public.platform_users.is_super_admin` DEBE quedar protegido de escritura ordinaria por `authenticated`/acceso normal de aplicación.

**RLS-006.** `maintenance_company_id` suministrado por caller NO DEBE convertirse en autoridad.

**RLS-007.** `service-role` NO DEBE sustituir las policies y comprobaciones de autorización de negocio.

**RLS-008.** Cualquier necesidad de debilitar RLS tenant existente para implementar TASK-014 DEBE producir `BLOCKER`.

**RLS-009.** `schema change = YES` NO DEBE implicar una nueva tenant bypass policy.

**RLS-010.** `modified tenant bypass RLS policy = NO` DEBE mantenerse durante toda la implementación.

**RLS-011.** Si la policy/grant vigente permite leer la propia fila `PlatformUser`, la lectura de `is_super_admin` NO DEBE otorgar capacidad de escritura ni autorización tenant.

**RLS-012.** La implementation DEBE verificar que no exista un path normal de UPDATE de `is_super_admin` para `authenticated`.

**RLS-013.** La incorporación del campo global NO DEBE ampliar el conjunto de filas tenant-owned visibles para `SUPER_ADMIN` sin `SupportAccessGrant`.

**RLS-014.** Las suites RLS/integridad de TASK-009 y tenant isolation DEBEN permanecer sin regresiones.

---

**RLS-015.** La RLS ordinaria de `company_memberships` NO DEBE debilitarse para hacer visibles memberships disabled al caller normal.

**RLS-016.** La función purpose-specific PUEDE observar existencia de membership disabled exclusivamente para clasificación global del propio `auth.uid()`.

**RLS-017.** La función NO DEBE exponer por su output recursos o detalles tenant que la RLS ordinaria no permita.

**RLS-018.** `PUBLIC` NO DEBE conservar `EXECUTE` sobre la función de clasificación global.

**RLS-019.** El grant de `EXECUTE` DEBE limitarse al mínimo requerido y NO DEBE crear una capacidad de tenant bypass.

**RLS-020.** El comportamiento normal de `SELECT` de memberships enabled/disabled y las policies tenant existentes DEBEN permanecer sin cambios semánticos.


---

## 21. Threat model

| Amenaza | Condición | Impacto | Mitigación exigida | Prueba esperada |
|---|---|---|---|---|
| Self-escalation via `is_super_admin` | Usuario normal intenta UPDATE directo/indirecto | Control global no autorizado | Sin write ordinario; sin generic mutation path | `authenticated` no puede mutar `is_super_admin` |
| Privilege inference by missing membership | `PlatformUser` sin membership | Escalamiento global | Sólo DB `is_super_admin=true` es evidencia positiva | DB false + no membership → DENY global |
| Inconsistent dual authority | DB true + cualquier `CompanyMembership` | Ambigüedad actor/global-tenant | Fail-closed; no priorizar ni reparar | DB true + membership → INCONSISTENT/DENY |
| Stale JWT/claim authority | Token afirma SUPER_ADMIN pero DB false | Privilegio revocado/stale | PostgreSQL actual > claim | stale claim true + DB false → DENY |
| Missing claim with real DB authority | JWT no transporta SUPER_ADMIN pero DB true | Falso negativo si se confía en token | Claim no requerido; resolver DB | DB true + no membership + no claim → AUTHORIZED GLOBAL |
| Metadata forgery | Auth metadata afirma SUPER_ADMIN | Escalamiento | Metadata no autoritativa | Forged metadata + DB false → DENY |
| Browser manipulation | Payload/state modifica role/tenant/authority | Escalamiento | Inputs cliente ignorados como autoridad | Manipulación browser no cambia resultado |
| DB lookup failure | Error/timeout al resolver identidad/authority | Fail-open crítico | Error → DENY | Simular lookup failure → DENY |
| Cross-tenant access attempt | SUPER_ADMIN válido solicita tenant data sin grant | Fuga multiempresa | Global authority != tenant access; RLS unchanged | SUPER_ADMIN sin grant → tenant data DENY |
| service-role misuse | Resolver ordinario usa service-role | Bypass RLS/business | Prohibido como path ordinario | Inspection/test sin dependency ordinaria |
| Generic privileged server client misuse | Boundary genérico permite operaciones no acotadas | Escalamiento transversal | Boundary purpose-specific; no generic privileged request client | No superficie genérica privilegiada |
| Unauthorized mutation path | API/service genérico cambia `is_super_admin` | Escalamiento | Mutación funcional fuera de scope | No grant/revoke API; no generic write |
| Accidental bootstrap | Migration promociona usuario existente | SUPER_ADMIN arbitrario | Existing rows false; no selection de usuario | Todas las filas preexistentes quedan false |
| TOCTOU/stale resolver state | Authority cambia entre requests o se cachea | Decisión obsoleta | Resolver current DB state por request; no authority cache stale | Cambio DB se refleja en nueva resolución |
| Auth/session confusion | Sesión válida se equipara a authority | Escalamiento | authenticated != authorized | Valid session + DB false → DENY global |
| Browser exposure of secrets | Credencial privilegiada entra en bundle/logs | Compromiso sistémico | Server-only; no secrets | Bundle/diff/log inspection sin secrets |
| Disabled membership hidden by ordinary RLS | Membership disabled no visible by normal SELECT | Falsa clasificación global-only | Purpose-specific SECURITY DEFINER existence check | DB true + disabled membership → INCONSISTENT/DENY |
| SECURITY DEFINER confused deputy | Función permite targets/outputs amplios | Fuga privilegiada o arbitrary lookup | `auth.uid()` only, no target IDs, minimal output, fixed search_path, strict grants | Caller A no puede clasificar B ni obtener tenant data |
| PUBLIC execute surface | `PUBLIC` puede invocar función | Superficie de invocación inesperada | Revoke `PUBLIC`, explicit minimum EXECUTE grant | `PUBLIC EXECUTE` ausente |
| Fixture privilege leakage | Fixture `is_super_admin=true` sobrevive verificación | Autoridad test accidental persistente | Test-only identities + mandatory cleanup + post-cleanup assertions | Cleanup leaves zero unexpected test authority |

---

## 22. Failure model

### 22.1 Missing `PlatformUser`

```text
validated Auth subject
+
no resolvable PlatformUser
→ DENY
```

### 22.2 `is_super_admin = false`

```text
PlatformUser exists
+
is_super_admin = false
→ NOT GLOBAL SUPER_ADMIN
```

Si existe una membership tenant válida, la autorización tenant continúa únicamente por TASK-012.

Si no existe membership:

```text
→ no global authority
→ no tenant authority by inference
```

### 22.3 Dual global + tenant identity

```text
is_super_admin = true
+
CompanyMembership exists
→ INCONSISTENT
→ DENY / FAIL CLOSED
```

No autocorrección.

### 22.4 Valid global identity

```text
validated Auth subject
→ PlatformUser
→ is_super_admin = true
→ no CompanyMembership
→ global SUPER_ADMIN authority resolved
```

### 22.5 Database lookup failure

```text
database/authority lookup error
→ DENY
```

No fallback a claims, cookies, metadata o ausencia de membership.

### 22.6 Unvalidated/malformed identity

```text
unvalidated or malformed Auth identity
→ DENY
```

### 22.7 Unexpected duplicate identity mapping

```text
Auth subject resolution ambiguous/duplicated
→ DENY
```

No seleccionar una fila arbitraria.

### 22.8 Client-supplied authority

```text
caller says SUPER_ADMIN/tenant/company/client
→ ignored as authority
```

Si el estado autoritativo no permite la operación:

```text
→ DENY
```

### 22.9 Missing `CompanyMembership`

```text
missing CompanyMembership
→ NEVER positive evidence of SUPER_ADMIN
```

Sólo:

```text
is_super_admin = true
AND no CompanyMembership
```

puede resolver la autoridad global positiva.

### 22.10 Claim/DB disagreement

```text
claim SUPER_ADMIN + DB false
→ DENY global
```

```text
no claim SUPER_ADMIN + DB true + no membership
→ DB-authoritative global resolution allowed
```

No se inventan códigos HTTP.

---

### 22.11 RPC unavailable/error

```text
purpose-specific RPC unavailable/error
→ DENY
```

No fallback a un `SELECT` ordinario de memberships.

### 22.12 Missing `auth.uid()`

```text
auth.uid() absent
→ DENY
```

No se acepta subject caller-supplied como fallback.

### 22.13 Impossible/ambiguous RPC shape

```text
RPC result impossible/ambiguous
→ DENY
```

No seleccionar automáticamente una rama.

### 22.14 Global true + disabled membership

```text
is_super_admin = true
+
disabled CompanyMembership exists
→ INCONSISTENT
→ DENY
```

### 22.15 Fixture cleanup failure

En Hosted Development:

```text
fixture cleanup failure
→ BLOCKER
→ no closure
```

La verificación debe demostrar post-cleanup que no permanece autoridad test inesperada.


---

## 23. Plan de pruebas obligatorio

### 23.1 A. Database / migration tests — OBLIGATORIOS

Deben verificar:

1. existencia de `public.platform_users.is_super_admin`;
2. tipo boolean;
3. `NOT NULL`;
4. default `false`;
5. preservación de filas existentes;
6. filas preexistentes quedan `false`;
7. ninguna identidad es promovida automáticamente;
8. mapping Auth subject → `PlatformUser` permanece intacto;
9. `CompanyMembership` permanece intacta;
10. roles tenant continúan exclusivamente `COMPANY_ADMIN` / `TECHNICIAN`;
11. TASK-009 RLS/integridad continúa PASS;
12. no tenant bypass policy;
13. acceso normal `authenticated` no puede mutar `is_super_admin`;
14. función/RPC purpose-specific existe;
15. función es `SECURITY DEFINER`;
16. hardening de `search_path` está presente;
17. grants/EXECUTE coinciden con el mínimo autorizado;
18. `PUBLIC` no posee `EXECUTE`;
19. no existe overload/función privilegiada inesperada equivalente;
20. output físico/semántico es mínimo.

### 23.2 B. Identity matrix / authorization resolver tests — OBLIGATORIOS

Deben cubrir:

```text
DB true + no membership
→ AUTHORIZED GLOBAL SUPER_ADMIN
```

```text
DB true + enabled membership
→ INCONSISTENT / DENIED
```

```text
DB true + disabled membership
→ INCONSISTENT / DENIED
```

```text
DB false + no membership
→ DENIED global
```

```text
DB false + enabled membership
→ NOT global; TASK-012 tenant resolver governs tenant authorization
```

```text
DB false + disabled membership
→ NOT global; no tenant authority from TASK-014
```

Además:

```text
missing PlatformUser → DENIED
ambiguous identity mapping → DENIED
RPC/database lookup failure → DENIED
stale claim true + DB false → DENIED global
DB true + no claim + no membership → recognized from authoritative DB state
```

### 23.3 C. Cross-identity / SECURITY DEFINER negative tests — OBLIGATORIOS

Deben demostrar:

- la función no acepta target `PlatformUser`;
- caller A no puede clasificar caller B mediante IDs suministrados;
- caller no puede inyectar tenant ID;
- caller no puede inyectar Auth subject;
- caller no puede enumerar detalles de membership;
- caller no puede obtener tenant operational data;
- `PUBLIC` no puede ejecutar;
- únicamente el rol esperado puede ejecutar;
- `search_path` hardening existe;
- error path fails closed;
- función no realiza writes;
- función no puede mutar `is_super_admin`;
- función no puede mutar membership;
- función no puede convertirse en generic SQL escape hatch.

### 23.4 D. RLS regression — OBLIGATORIO

Debe probarse simultáneamente:

```text
ordinary caller disabled-membership SELECT visibility
→ remains unchanged under TASK-009 policies
```

y:

```text
purpose-specific classification
→ detects that disabled membership exists
```

Test obligatorio:

```text
DB true + disabled CompanyMembership
→ INCONSISTENT / DENY
```

Tenant isolation y normal authenticated SELECT behavior deben permanecer sin cambios.

### 23.5 E. Security tests — OBLIGATORIOS

Deben demostrar:

- browser no puede self-promote;
- normal authenticated user no puede mutar authority;
- tenant actor no puede escalar globalmente;
- global authority no implica tenant data access;
- caller-provided tenant/company/client no altera resolución;
- caller-scoped client consume la función;
- no `service-role` ordinary resolver;
- no generic privileged request client;
- no functional grant/revoke/bootstrap adelantado;
- no secrets en browser, diff, logs u output;
- resolver no conserva authority stale entre requests.

### 23.6 F. Regression — OBLIGATORIO

Debe permanecer PASS:

```text
TASK-009 database/RLS suite
TASK-010 database suite
TASK-012 authorization suite
TASK-013 verification/session suite
```

No se modifican expected semantics de esas foundations.

### 23.7 G. Local fixture tests — OBLIGATORIOS

El harness local/test puede establecer `is_super_admin=true` exclusivamente como setup descartable.

Debe cubrir fixtures para:

- true + no membership;
- true + enabled membership;
- true + disabled membership;
- false + enabled membership;
- false + disabled membership;
- false + no membership.

Reglas:

```text
fixture mutation != functional grant
fixture mutation != bootstrap
cleanup = MANDATORY
```

Los fixtures deben ser test-only e identificables.

### 23.8 H. Supabase Local — REQUERIDO CUANDO CORRESPONDA AL HARNESS VIGENTE

La futura ejecución debe inspeccionar el repo real y utilizar el harness Supabase local vigente requerido por las suites DB/RLS/function.

No se inventa un harness alternativo.

### 23.9 I. Hosted Development — REQUIRED CON GATE HUMANO SEPARADO

Después de local PASS y autorización humana separada debe verificarse:

- migration aplicada;
- column properties exactas;
- filas existentes no promovidas;
- función/RPC presente;
- `SECURITY DEFINER` y `search_path` hardening;
- privileges mínimos;
- `PUBLIC EXECUTE` ausente;
- resolver contra estado real Development;
- caso enabled membership;
- caso disabled membership;
- RLS tenant regressions intactas;
- ausencia de funciones/grants/policies/config inesperados.

Puede utilizarse exclusivamente setup controlado de fixtures test-only autorizado por el Gate.

Debe verificarse antes y después:

- identity fixture count;
- membership fixture count;
- platform test rows;
- sessions/Auth artifacts cuando aplique;
- cleanup completo;
- cero autoridad test inesperada post-cleanup.

### 23.10 J. Fixture cleanup — OBLIGATORIO

Local y Development deben ejecutar cleanup verificable.

```text
cleanup failure in Development
→ BLOCKER
→ no closure
```

No se permite usar usuarios reales ni datos operativos productivos.

### 23.11 K. Calidad general — OBLIGATORIO

La futura ejecución debe reportar, conforme a scripts vigentes del repo:

```text
npm run lint
npm run typecheck
npm run build
npm run verify
git diff --check
```

y la suite completa aplicable.

Si un script cambió, el repo real prevalece; una contradicción material produce blocker.

---

## 24. Preconditions de una futura implementación

Antes de modificar archivos deben satisfacerse todas:

1. esta specification corregida queda revisada humanamente;
2. esta specification queda aprobada formalmente;
3. queda canonicalizada en la ruta futura propuesta;
4. la canonicalización queda revisada;
5. el artefacto canónico queda incorporado a Git mediante Gate separado;
6. existe autorización humana separada de implementación;
7. Fase 2 continúa `INICIADA / NOT DONE`;
8. ADR-0001/0002/0003/0019 continúan vigentes;
9. TASK-009/010/011/012/013 continúan cerradas/coherentes según el estado canónico;
10. `TASK-014 PHYSICAL AUTHORITY MODEL DECISION = APPROVED` continúa vigente;
11. repositorio real correcto;
12. branch/base/upstream expresamente autorizados;
13. divergencia compatible con la autorización;
14. worktree limpio;
15. staged/untracked compatibles con la autorización;
16. `public.platform_users` conserva la foundation esperada de TASK-009;
17. no existe ya un modelo incompatible de autoridad global;
18. no existe migration collision;
19. no existe write privilege normal inesperado sobre una authority field equivalente;
20. RLS tenant existente puede preservarse sin bypass;
21. no se necesita modificar ADR-0019/E2;
22. no se necesita implementar bootstrap/grant/revoke;
23. no se necesita crear `Client`, `UserClientAccess` ni `SupportAccessGrant`;
24. no existe contradicción canónica material nueva.

Cualquier incumplimiento material:

```text
TASK-014 IMPLEMENTATION = BLOCKER
```

No ampliar scope ni autoreparar.

---

Además debe permanecer:

25. `TASK-014 AUTHORITATIVE MEMBERSHIP VISIBILITY DECISION = APPROVED`;
26. la function/RPC purpose-specific puede implementarse sin debilitar la RLS ordinaria de memberships disabled;
27. `auth.uid()` puede mantenerse como única selección de identidad;
28. `PUBLIC EXECUTE` puede revocarse;
29. puede establecerse `search_path` seguro;
30. no se requiere service-role como caller;
31. no existe collision inesperada con otra función privilegiada equivalente;
32. el harness permite fixtures descartables y cleanup verificable;
33. Hosted Development Gate puede aislar y limpiar fixtures test-only.


---

## 25. Catálogo de blockers para futura ejecución

Los blockers históricos quedan registrados únicamente como resueltos:

```text
PHYSICAL AUTHORITY MODEL DECISION REQUIRED
= RESOLVED BY HUMAN DECISION
```

```text
AUTHORITATIVE MEMBERSHIP-EXISTENCE VISIBILITY DECISION REQUIRED
= RESOLVED BY HUMAN DECISION
```

La futura ejecución debe detenerse ante:

1. Git baseline drift no autorizado;
2. canonical source contradiction;
3. physical schema distinto de la foundation esperada de TASK-009;
4. `platform_users` ya contiene un modelo incompatible de autoridad;
5. migration collision;
6. modelo `SUPER_ADMIN` inesperado ya introducido;
7. write privilege normal inesperado sobre `is_super_admin`;
8. necesidad de debilitar tenant RLS;
9. necesidad de ordinary tenant bypass;
10. necesidad de service-role como resolver ordinario;
11. necesidad de modificar ADR-0019/E2;
12. necesidad de bootstrap/grant/revoke funcional;
13. necesidad de capability/path fuera de scope;
14. failing regression;
15. cross-tenant regression;
16. Hosted Development unexpected diff;
17. secret exposure;
18. `SECURITY DEFINER` no puede hardenizarse conforme a esta specification;
19. contrato `auth.uid()`-only no puede mantenerse;
20. RLS ordinaria de membership disabled tendría que debilitarse;
21. función requiere target IDs arbitrarios suministrados por caller;
22. función expondría tenant operational data o membership details;
23. función requiere service-role caller;
24. `PUBLIC EXECUTE` no puede eliminarse;
25. safe/fixed `search_path` no puede establecerse;
26. unexpected privileged function/overload collision;
27. fixtures no pueden aislarse o limpiarse de forma segura;
28. Hosted Development fixture cleanup failure;
29. post-cleanup verification detecta autoridad test inesperada.

Regla:

```text
BLOCKER
→ no ampliar scope
→ no reparar silenciosamente
→ no implementar fuera del contrato
→ volver al Revisor Central
```

---

## 26. Criterios de aceptación de la specification corregida y futura implementation

**AC-001.** La autoridad `SUPER_ADMIN` está representada por `public.platform_users.is_super_admin`.

**AC-002.** Missing `CompanyMembership` no implica `SUPER_ADMIN`.

**AC-003.** `SUPER_ADMIN` no es role de `CompanyMembership`.

**AC-004.** `CompanyMembership` mantiene sólo roles tenant aprobados.

**AC-005.** `authenticated != authorized` permanece visible y probado.

**AC-006.** Valid Auth session con `is_super_admin = false` no obtiene global authority.

**AC-007.** Missing `PlatformUser` → DENY.

**AC-008.** Lookup failure → DENY.

**AC-009.** `is_super_admin = true` + cualquier `CompanyMembership` → INCONSISTENT / DENY.

**AC-010.** Claims stale no otorgan autoridad contra DB false.

**AC-011.** Claims forjados no otorgan autoridad.

**AC-012.** Frontend state no otorga autoridad.

**AC-013.** `maintenance_company_id`/client context del caller no otorga autoridad.

**AC-014.** Tenant resolver TASK-012 conserva su semántica.

**AC-015.** Tenant resolver DENY no se transforma en global ALLOW por missing membership.

**AC-016.** Global resolver DENY no se transforma en tenant ALLOW.

**AC-017.** `SUPER_ADMIN ordinary tenant bypass = NO`.

**AC-018.** `SUPER_ADMIN` sin `SupportAccessGrant` no accede a tenant operational data por esta foundation.

**AC-019.** No se crea `SupportAccessGrant`.

**AC-020.** No se crea `UserClientAccess`.

**AC-021.** No se crea `Client`.

**AC-022.** No se implementa Client authorization.

**AC-023.** No se implementa Support authorization.

**AC-024.** RLS tenant existente no se debilita.

**AC-025.** No existe policy `if no membership → super admin`.

**AC-026.** No se introduce service-role como path ordinario.

**AC-027.** No se expone secret/admin credential al browser.

**AC-028.** La boundary global es server-side y DB-authoritative.

**AC-029.** Server-side no se trata como sinónimo de authorized.

**AC-030.** TASK-011 SSR lifecycle no se rediseña.

**AC-031.** ADR-0019/E2 no cambia.

**AC-032.** TASK-013 VerificationChallenge/SessionGrant foundation no cambia fuera del consumo normal de identidad validada.

**AC-033.** Resolver read-only no produce `AuditEvent`.

**AC-034.** No se inventa un action de AuditEvent global.

**AC-035.** No se implementa disable/reinstate/role-change de membership.

**AC-036.** No se implementa onboarding.

**AC-037.** No se implementa alta funcional.

**AC-038.** No se implementa route authorization completa.

**AC-039.** No se implementa resource authorization completa.

**AC-040.** No se declara Application authorization completa.

**AC-041.** Offline implementation = NO.

**AC-042.** UI propia = NOT IN SCOPE.

**AC-043.** Staging = NO CHANGE salvo Gate futuro.

**AC-044.** Production = NO CHANGE salvo Gate futuro.

**AC-045.** Cualquier Hosted Development write ocurre sólo bajo autorización humana separada.

**AC-046.** TypeScript strict permanece.

**AC-047.** No se introducen microservicios.

**AC-048.** Tests negativos de autorización = PASS.

**AC-049.** Regressions TASK-009/010/012/013 = PASS.

**AC-050.** `npm run lint`, `npm run typecheck`, `npm run build` y suite aplicable = PASS conforme al repo real.

**AC-051.** `git diff --check = PASS`.

**AC-052.** Cero paths inesperados.

**AC-053.** Cero secrets/tokens en diff, logs o output.

**AC-054.** No se inicia Phase 3.

**AC-055.** No se genera TASK posterior.

**AC-056.** El diff de implementación se limita al alcance aprobado de TASK-014.

**AC-057.** Existe exactamente la nueva columna conceptual `public.platform_users.is_super_admin` con tipo boolean.

**AC-058.** `is_super_admin` es `NOT NULL`.

**AC-059.** El default de `is_super_admin` es `false`.

**AC-060.** Todas las filas existentes quedan `is_super_admin = false` tras la migration.

**AC-061.** Ninguna fila existente es promovida automáticamente a `SUPER_ADMIN`.

**AC-062.** No se crea tabla global de roles ni enum global de roles.

**AC-063.** No se modifica el catálogo tenant `COMPANY_ADMIN | TECHNICIAN`.

**AC-064.** Acceso normal `authenticated` no puede mutar autoritativamente `is_super_admin`.

**AC-065.** No existe API/UI/caso de uso funcional de grant/revoke/bootstrap/admin `SUPER_ADMIN`.

**AC-066.** DB true + no CompanyMembership → global `SUPER_ADMIN` reconocido.

**AC-067.** DB false + no CompanyMembership → global authority DENIED.

**AC-068.** DB false + valid tenant membership → NOT global; tenant authorization sigue TASK-012.

**AC-069.** Stale claim true + DB false → global authority DENIED.

**AC-070.** DB true + no membership + claim ausente → global authority reconocible desde DB.

**AC-071.** Caller/browser manipulated authority/tenant/client state no altera global resolution.

**AC-072.** Migration preserva IDs, Auth subject mapping y `CompanyMembership` data.

**AC-073.** No tenant bypass policy nueva ni modificada es introducida.

**AC-074.** Si el propio `PlatformUser` puede observar `is_super_admin` por reglas existentes, esa lectura no concede write ni tenant authorization.

**AC-075.** Hosted Development Gate se ejecuta sólo después de local PASS y autorización humana separada.

**AC-076.** Hosted Development verification confirma propiedades exactas de columna y existing rows no promovidas.

**AC-077.** Hosted Development verification confirma ausencia de objetos/config changes inesperados.

**AC-078.** Supabase local/harness vigente se ejecuta cuando corresponda a las suites DB/RLS del repo.

**AC-079.** Resolver no mantiene autoridad stale entre requests.

**AC-080.** No se añade `is_super_admin` como claim requerido ni se modifica Custom Access Token Hook para transportarlo.

---

**AC-081.** La existencia de una `CompanyMembership` disabled cuenta como existencia para exclusión mutua global/tenant.

**AC-082.** `is_super_admin=true` + disabled `CompanyMembership` → `INCONSISTENT / DENY`.

**AC-083.** La visibilidad ordinaria RLS de memberships disabled permanece sin cambios semánticos.

**AC-084.** Existe una función/RPC purpose-specific de clasificación global con `SECURITY DEFINER`.

**AC-085.** La función deriva identidad exclusivamente de `auth.uid()`.

**AC-086.** La función no acepta ni permite target arbitrario de `PlatformUser`, Auth subject, tenant o client.

**AC-087.** `PUBLIC EXECUTE` está revocado sobre la función.

**AC-088.** Sólo existe el grant mínimo de `EXECUTE` requerido por el contrato.

**AC-089.** La función tiene `search_path` fijo/seguro y no depende de lookup ambiguo/manipulable.

**AC-090.** La función no devuelve membership role, `is_enabled`, tenant ID, client scope ni tenant operational data.

**AC-091.** La función realiza cero writes y no puede mutar `is_super_admin` ni `CompanyMembership`.

**AC-092.** El resolver server-side consume la función mediante cliente caller-scoped.

**AC-093.** No existe path ordinario de `service-role` ni generic privileged client para esta resolución.

**AC-094.** Los fixtures locales permiten casos positivos/negativos con `is_super_admin=true` sin constituir grant/bootstrap funcional.

**AC-095.** Hosted Development fixtures sólo se utilizan bajo Gate Cloud humano separado y con identidades/datos test-only.

**AC-096.** Cleanup local y Hosted Development de fixtures = PASS.

**AC-097.** Post-cleanup verification confirma cero autoridad test inesperada y ausencia de artifacts/rows de fixture no autorizados.

**AC-098.** Hosted Development verification confirma ausencia de funciones, grants, policies o config changes inesperados.


---

## 27. Git governance

Se mantiene la secuencia obligatoria:

```text
corrected v3 specification
→ corrected v3 spec review = APPROVED
→ human specification approval = APPROVED
→ approved artifact review
→ canonicalization
→ canonicalization review
→ canonical artifact Git incorporation
→ separate implementation authorization
→ execution
→ implementation review
→ Hosted Development mutation Gate cuando corresponda
→ remote verification
→ staging Gate
→ commit Gate
→ push Gate
→ exact remote commit verification
→ final human closure
```

Para el estado actual:

```text
TASK-014 SPEC REVIEW = APPROVED
TASK-014 HUMAN SPEC APPROVAL = APPROVED
TASK-014 SPECIFICATION = APPROVED FOR IMPLEMENTATION
TASK-014 aprobada = SÍ
TASK-014 canonicalizada = NO
implementation authorization = NO
execution = NO
repository modification = NO
Cloud modification = NO
Hosted Development mutation authorized = NO
staging = NO
commit = NO
push = NO
```

La decisión física aprobada no equivale a autorización de implementación.

Antes de una futura implementación autorizada se exige preflight Git fresco contra el repositorio real.

---


## 28. Definition of Done

TASK-014 sólo podrá considerarse `DONE` cuando se cumplan todos los siguientes puntos:

1. corrected v3 spec review = APPROVED;
2. human specification approval = APPROVED;
3. queda canonicalizada en la ruta normativa futura;
4. la canonicalización queda revisada;
5. el artefacto canónico queda incorporado a Git mediante Gate separado;
6. existe autorización humana separada de implementación;
7. preflight Git exacto y fresco = PASS;
8. no existe drift material de fuentes canónicas;
9. schema físico previo coincide con la foundation esperada de TASK-009;
10. migration nueva, forward-only y mínima = PASS;
11. `public.platform_users.is_super_admin` = boolean NOT NULL DEFAULT false;
12. todas las filas existentes preservadas y `false` = PASS;
13. ninguna identidad existente promovida automáticamente = PASS;
14. IDs y Auth subject mapping preservados = PASS;
15. `CompanyMembership` y roles tenant preservados = PASS;
16. resolver server-side exacto y DB-authoritative = PASS;
17. DB true + no membership → global authority PASS;
18. DB false → no global authority PASS;
19. dual global+membership → fail-closed PASS;
20. missing PlatformUser / lookup failure / unvalidated identity → DENY PASS;
21. stale/forged claim negative tests = PASS;
22. DB true sin claim requerido = PASS;
23. browser/client manipulation negative tests = PASS;
24. normal authenticated mutation of `is_super_admin` = IMPOSSIBLE / PASS;
25. no generic `PlatformUser` mutation path para authority = PASS;
26. no bootstrap/grant/revoke/admin functional flow = PASS;
27. RLS tenant unchanged = PASS;
28. no tenant bypass = PASS;
29. cross-tenant negative tests = PASS;
30. no ordinary service-role/global privileged request boundary = PASS;
31. no secrets = PASS;
32. Auth/session regression = PASS;
33. TASK-009 regression = PASS;
34. TASK-010 regression = PASS;
35. TASK-012 regression = PASS;
36. TASK-013/E2 regression = PASS;
37. local database/RLS verification = PASS conforme al harness vigente;
38. lint/typecheck/build/verify/suite aplicable = PASS;
39. `git diff --check = PASS`;
40. AC-001…AC-098 = 100% PASS;
41. implementation diff completo = human-reviewed;
42. Hosted Development mutation Gate = separately authorized;
43. Hosted Development migration application = PASS;
44. Hosted Development column/state verification = PASS;
45. Hosted Development RLS/regression verification = PASS;
46. Hosted Development unexpected diff = NONE;
47. Staging = NO CHANGE salvo Gate separado;
48. Production = NO CHANGE;
49. staging Gate = APPROVED cuando corresponda al cierre Git;
50. commit Gate = APPROVED;
51. push Gate = APPROVED;
52. exact remote commit verification = PASS;
53. RPC purpose-specific implementado = PASS;
54. `SECURITY DEFINER` hardening verificado = PASS;
55. fixed/safe `search_path` verificado = PASS;
56. `PUBLIC EXECUTE` revocado = PASS;
57. minimum `EXECUTE` grant verificado = PASS;
58. `auth.uid()`-only identity resolution verificada = PASS;
59. disabled membership existence detection = PASS;
60. DB true + disabled membership → DENY = PASS;
61. no arbitrary user lookup = PASS;
62. no tenant data/membership detail disclosure = PASS;
63. resolver writes = NONE;
64. service-role ordinary path = NONE;
65. local fixtures cleanup = PASS;
66. Hosted Development fixtures cleanup = PASS;
67. post-cleanup verification y expected-only function/grant/policy diff = PASS;
68. final human closure = APPROVED.

Debe permanecer:

```text
implementation PASS
!=
TASK-014 DONE
```

```text
push PASS
!=
TASK-014 DONE
```

Sólo el cierre humano final puede declarar TASK-014 cerrada.

---


## 29. Gate posterior de esta segunda especificación corregida

El estado resultante es:

```text
TASK-014 DOCUMENT APPROVAL = COMPLETE

TASK-014 SPEC REVIEW = APPROVED

TASK-014 HUMAN SPEC APPROVAL = APPROVED

TASK-014 SPECIFICATION = APPROVED FOR IMPLEMENTATION

TASK-014 aprobada = SÍ

TASK-014 canonicalizada = NO

PHYSICAL AUTHORITY MODEL DECISION = RESOLVED

AUTHORITATIVE MEMBERSHIP-EXISTENCE VISIBILITY DECISION = RESOLVED

test fixture contract = RESOLVED

new ADR required = NO

Hosted Development Gate required = YES

Hosted Development mutation authorized = NO

canonicalization = NOT YET AUTHORIZED / NOT YET PERFORMED

implementation authorized = NO

implementation = NOT AUTHORIZED

repository modification = NO

Supabase Cloud modification = NO

staging = NO
commit = NO
push = NO

TASK-014 implementation = NOT STARTED

TASK-015 = NOT GENERATED
```

El siguiente acto válido es:

```text
TASK-014 APPROVED ARTIFACT REVIEW
```

Sólo después de esa revisión podrá abrirse:

```text
TASK-014 CANONICALIZATION GATE
```

No corresponde todavía:

```text
TASK-014 CANONICALIZATION GATE
TASK-014 implementation
Codex
SQL executable
migration execution
RLS executable
Supabase Cloud mutation
Hosted Development mutation
git add
commit
push
Phase 2 Exit Gate
Phase 3
TASK-015
```

---

## 30. Autoverificación

```text
filename =
TASK-014-super-admin-global-identity-authorization-foundation-approved.md

title exact = YES

TASK ID = TASK-014

TASK-014 SPEC REVIEW = APPROVED

TASK-014 HUMAN SPEC APPROVAL = APPROVED

TASK-014 SPECIFICATION = APPROVED FOR IMPLEMENTATION

TASK-014 approved = YES

TASK-014 canonicalized = NO

capability unchanged = YES

is_super_admin decision unchanged = YES

membership visibility decision represented = YES

purpose-specific SECURITY DEFINER = YES

auth.uid-only = YES

disabled membership detection = YES

ordinary membership RLS changed = NO

tenant bypass = NO

service-role = NO

generic privileged client = NO

PUBLIC execute = NO

safe search_path required = YES

test fixtures isolated = YES

Development fixture Gate separate = YES

fixture cleanup mandatory = YES

UI = NO

offline = NO

new ADR required = NO

PHYSICAL AUTHORITY MODEL DECISION REQUIRED = RESOLVED

AUTHORITATIVE MEMBERSHIP-EXISTENCE VISIBILITY DECISION REQUIRED = RESOLVED

spec status = APPROVED FOR IMPLEMENTATION

implementation authorized = NO

Codex authorized = NO

Hosted Development Gate required = YES

Hosted Development mutation authorized = NO

repository modifications = NONE

Cloud writes = NONE

final FIN comment occurrences = 1
```

---

## 31. Resultado formal

```text
TASK-014 DOCUMENT APPROVAL = PASS

base artifact =
TASK-014-super-admin-global-identity-authorization-foundation-corrected-v3.md

approved artifact =
TASK-014-super-admin-global-identity-authorization-foundation-approved.md

TASK-014 SPEC REVIEW = APPROVED

TASK-014 HUMAN SPEC APPROVAL = APPROVED

TASK-014 SPECIFICATION = APPROVED FOR IMPLEMENTATION

TASK-014 approved = YES

TASK-014 canonicalized = NO

physical authority decision = RESOLVED

membership visibility decision = RESOLVED

test fixture contract = RESOLVED

new ADR required = NO

Hosted Development Gate required = YES

Hosted Development mutation authorized = NO

TASK-014 implementation authorized = NO

TASK-014 implementation = NOT STARTED

Codex authorized = NO

repository modifications = NONE

Cloud writes = NONE

TASK-015 generated = NO

next gate = TASK-014 APPROVED ARTIFACT REVIEW
```

La aprobación documental significa exclusivamente:

```text
specification human-approved for a future separately authorized implementation
```

y mantiene:

```text
document approval
!=
implementation execution authorization
```

No se implementó TASK-014.

No se utilizó Codex.

No se modificó el repositorio.

No se escribió SQL ejecutable.

No se creó ni ejecutó migration.

No se escribió RLS ejecutable.

No se modificó Supabase Cloud.

No se autorizó Hosted Development mutation.

No se hizo `git add`.

No se hizo commit.

No se hizo push.

No se canonicalizó.

No se generó TASK-015.

<!-- FIN DEL DOCUMENTO TASK-014-super-admin-global-identity-authorization-foundation-approved.md -->
