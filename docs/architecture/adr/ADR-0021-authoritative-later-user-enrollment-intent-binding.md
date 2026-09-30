# ADR-0021 — Authoritative Later-User Enrollment Intent Binding

## 0. Identidad documental y estado de gobernanza

**ID:** `ADR-0021`

**Título:** `ADR-0021 — Authoritative Later-User Enrollment Intent Binding`

**Tipo:** `ARCHITECTURE DECISION RECORD`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context principal:** `Identity & Authorization / Identity & Auth`

**Archivo de entrega:** `ADR-0021-authoritative-later-user-enrollment-intent-binding-canonical.md`

**Ruta canónica futura propuesta, sólo después de revisión/aprobación/canonicalización mediante Gates separados:**

`docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md`

**Status del ADR:** `HUMAN APPROVED`

**Resultado de esta generación:**

```text
ADR-0021 SPEC REVIEW =
APPROVED

ADR-0021 SPEC RE-REVIEW =
APPROVED

F-0021-SPEC-001 =
RESOLVED

ADR-0021 HUMAN APPROVAL =
APPROVED

ADR-0021 architecture decision =
HUMAN APPROVED

ADR-0021 APPROVED ARTIFACT GENERATION =
PASS

ADR-0021 APPROVED ARTIFACT REVIEW =
APPROVED

ADR-0021 CANONICALIZATION AUTHORIZATION =
APPROVED

ADR-0021 CANONICALIZATION =
PASS

ADR-0021 canonicalized =
YES

ADR-0021 CANONICALIZATION REVIEW =
PENDING

ADR-0021 REPOSITORY INCORPORATION AUTHORIZATION =
NOT AUTHORIZED

ADR-0021 REPOSITORY INCORPORATION =
NOT PERFORMED

ADR-0021 REPOSITORY INCORPORATION REVIEW =
NOT AUTHORIZED / NOT PERFORMED

repository mutation =
NO

implementation =
NOT AUTHORIZED

Codex =
NOT AUTHORIZED

TASK-020 =
NOT DETERMINED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED
```

Este artefacto documenta una **decisión arquitectónica human-approved** y su canonical candidate generado mediante el step autorizado de canonicalization. `ADR-0021 CANONICALIZATION = PASS` no implica `ADR-0021 CANONICALIZATION REVIEW = APPROVED`, incorporación al repositorio, determinación de una TASK posterior ni autorización de implementación. No autoriza Codex, no modifica repositorio, no modifica Supabase, no determina una TASK posterior y no cierra Fase 2.

---

## 1. Autorización y continuidad formal consumida

Se consume como determinación previa del Revisor Central:

```text
POST-CORR-040 PHASE 2 CONTINUITY DETERMINATION =
APPROVED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED

TASK-019 =
CLOSED

CORR-040 =
CLOSED

Phase 2 remaining non-Client-dependent capability =
PRE-CLIENT ORDINARY LATER-USER ONBOARDING FOUNDATION

reusable primitives already implemented =
PRESENT

ordinary later-user composition =
ABSENT

Client-dependent completion deferred to Phase 3 =
YES

new TASK required =
YES

next TASK ID =
NOT YET DETERMINED

TASK-020 =
NOT DETERMINED / NOT AUTHORIZED

ADR prerequisite =
YES

ADR prerequisite ID =
ADR-0021

documentation correction prerequisite =
NO

new contradiction =
NO
```

Esta continuidad autoriza exclusivamente la generación y revisión de ADR-0021. No autoriza el incremento de implementación que eventualmente consuma este ADR.

---

## 2. Fuentes de verdad y orden de autoridad

ADR-0021 consume las reglas vigentes de producto, dominio, autorización, RLS, Auth y estado de Fase 2. En particular:

### 2.1 Producto y dominio

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/04-offline-sync-strategy.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md`, interpretado junto con las sincronizaciones posteriores aprobadas

### 2.2 Arquitectura

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`
- `docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md`

### 2.3 Foundations e incrementos de Fase 2

- `docs/tasks/TASK-009-identity-tenant-foundation.md`
- `docs/tasks/TASK-010-audit-event-foundation.md`
- `docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md`
- `docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`
- `docs/tasks/TASK-013-verification-challenge-foundation.md`
- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`
- `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`
- `docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md`
- `docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md`
- `docs/tasks/TASK-019-authoritative-first-admin-profile-completion-onboarding-completion-foundation.md`
- `docs/tasks/CORR-039-phase-2-phase-3-client-scope-boundary-documentation-sync.md`
- `docs/tasks/CORR-040-task-019-closure-current-state-documentation-sync.md`

### 2.4 Orden de autoridad

Se conserva:

1. decisiones humanas posteriores explícitamente aprobadas dentro de su alcance;
2. `01-product-definition.md` como baseline normativa de producto;
3. documentos derivados de producto dentro de su bounded context;
4. ADR aceptados dentro de la decisión arquitectónica que gobiernan;
5. TASK/CORR como contratos físicos, de implementación y de estado, sin convertir mecanismos purpose-specific en reglas genéricas por inferencia;
6. repositorio real como fuente de verdad de nombres, firmas, migraciones, policies, tests y código físico durante una futura ejecución autorizada.

Regla obligatoria:

```text
first-admin purpose-specific implementation
!=
generic later-user API
```

TASK-017, TASK-018 y TASK-019 pueden aportar **primitivas, invariantes y precedentes de seguridad**, pero no se convierten silenciosamente en APIs genéricas ni en decisiones funcionales aplicables a usuarios posteriores.

---

## 3. Revisión de contradicciones y blocker funcional

### 3.1 Resultado

No se detecta una contradicción material que impida decidir la arquitectura de la foundation pre-Client.

```text
new contradiction =
NO

ADR-0021 SPECIFICATION BLOCKER =
NONE
```

### 3.2 Decisión funcional que ADR-0021 deliberadamente NO cruza

Las fuentes no autorizan generalizar desde el first-admin el punto exacto en que un later-user debe:

- convertirse o reconciliarse como `PlatformUser` de aplicación;
- completar perfil;
- recibir una `CompanyMembership` inicial;
- producir `USER_CREATED`;
- adquirir autoridad tenant habilitada;
- quedar compuesto con el `UserClientAccess` obligatorio de RF-015.

La arquitectura puede cerrarse sin decidir esos puntos porque el alcance aprobado es una **foundation pre-Client** cuyo boundary terminal se fija antes de esas transiciones.

Por tanto:

```text
exact later-user PlatformUser creation/completion timing =
NOT DECIDED BY ADR-0021

exact later-user profile-completion timing =
NOT DECIDED BY ADR-0021

exact initial CompanyMembership establishment timing =
NOT DECIDED BY ADR-0021

exact later-user USER_CREATED producer timing =
NOT DECIDED BY ADR-0021
```

Si un futuro TASK necesitara cruzar cualquiera de esos puntos antes de que exista definición suficiente para preservar RF-013..RF-017 —especialmente RF-015— deberá volver a revisión de producto/arquitectura en lugar de copiar las decisiones A–J purpose-specific de TASK-019.

---

## 4. Requisitos de producto inmutables

ADR-0021 no modifica los siguientes requisitos:

```text
RF-013 =
AUTHORIZED COMPANY_ADMIN CAN ENROLL NEW COMPANY_ADMIN OR TECHNICIAN
USING EMAIL + CODE

RF-014 =
ONE FIXED ROLE MUST BE ASSIGNED AT USER CREATION

RF-015 =
ONE OR MORE CLIENTS OF THE SAME TENANT MUST BE ASSIGNABLE

RF-016 =
CROSS-TENANT CLIENT ASSIGNMENT IS FORBIDDEN

RF-017 =
ROLE AND AUTHORIZED CLIENTS MAY LATER BE MODIFIED
WITHIN THE SAME TENANT UNDER THE APPROVED RULES
```

La secuencia funcional aprobada de alta ordinaria permanece conceptualmente:

```text
COMPANY_ADMIN registers email
→ fixed role is defined
→ authorized Clients are defined
→ code is sent under the approved lifecycle
→ target verifies access and completes profile
→ effective scope is tenant + role + authorized Clients
```

La decisión de phase boundary posterior preserva simultáneamente:

```text
Client =
Phase 3

physical UserClientAccess required before Phase 2 close =
NO

ordinary later-user onboarding remains incomplete
until RF-015 can be satisfied =
YES

pre-Client later-user onboarding foundation split =
YES

move minimal Client into Phase 2 =
NO
```

En consecuencia:

```text
zero client assignment satisfies RF-015 =
NO

pre-Client foundation =
NOT complete user creation

pre-Client foundation =
NOT complete membership onboarding

pre-Client foundation =
NOT complete later-user onboarding
```

ADR-0021 no diseña `Client`, `UserClientAccess`, `SupportAccessGrant`, un `Client` temporal, un placeholder de Client ni una representación ficticia de client assignment.

---

## 5. Problema arquitectónico

El sistema necesita una cadena de enrollment de usuario posterior que preserve autoritativamente la decisión tomada por un `COMPANY_ADMIN` acerca de:

- qué tenant origina el alta;
- qué correo constituye el target;
- qué rol fijo fue elegido;
- qué challenge vigente demuestra posesión del correo;
- qué proof fue consumido;
- qué autorización puntual permite establecer la identidad/sesión Auth inicial;
- qué estado puede reintentarse/reconciliarse de forma segura.

El challenge de negocio por sí solo no representa suficientemente esta intención, porque su responsabilidad es demostrar una prueba de correo con lifecycle 8h/3 intentos/resend, no conservar la decisión de tenant + role ni coordinar el workflow completo.

A su vez, una sesión Supabase Auth no puede convertirse en autoridad de tenant ni de role.

El problema se resume como:

```text
current authorized COMPANY_ADMIN
→ authoritative same-tenant enrollment decision
→ durable immutable tenant/email/role binding
→ current VerificationChallenge lifecycle
→ valid proof consume
→ one-time SessionGrant
→ controlled Auth identity/session handoff
→ PRE-CLIENT BOUNDARY
```

sin permitir:

```text
frontend tenant authority
frontend role authority
JWT role authority
public signup bypass
public invite-session bypass
challenge-only ambiguous enrollment
pre-proof membership/user authority
cross-tenant enrollment
silent role rebinding
silent duplicate identity repair
RF-015 bypass
```

---

## 6. Architectural drivers

### 6.1 Product fit

La arquitectura debe soportar RF-013 y RF-014 ahora como foundation, sin declarar satisfecho RF-015 ni completar RF-013 end-to-end antes de Fase 3.

### 6.2 Tenant isolation

`MaintenanceCompany` continúa siendo el tenant. El tenant efectivo debe derivarse de la autoridad actual del actor, nunca de `maintenance_company_id` recibido del frontend.

### 6.3 Role integrity

El rol intended debe quedar ligado a la intención autorizada y no ser una selección del usuario invitado ni un valor libre en verificación o continuación de sesión.

### 6.4 Auth/business-proof separation

Se preserva ADR-0019:

```text
business proof =
application-owned VerificationChallenge

initial session authorization proof =
one-time SessionGrant

provider proof =
technical password server-only
```

### 6.5 Idempotency and concurrency

Retries, double-clicks, timeouts y concurrencia no deben producir intent duplicado, challenge ambiguo, roles cambiados silenciosamente, múltiples session grants consumibles ni identidades Auth duplicadas.

### 6.6 Purpose separation

First-admin bootstrap y ordinary later-user enrollment tienen actores, cardinalidades, roles y precondiciones distintas. La arquitectura debe conservar esa separación.

### 6.7 Phase boundary

La foundation debe terminar antes de cualquier dependencia real de `Client` y, al mismo tiempo, dejar un handoff seguro para que Fase 3 componga RF-015 sin rehacer Auth/Verification.

---

## 7. Decisión arquitectónica human-approved — resumen

ADR-0021 selecciona, mediante human approval, la alternativa **B — dedicated `LaterUserEnrollmentIntent`**.

La decisión arquitectónica human-approved es:

> **Modelar el alta ordinaria de usuarios posteriores mediante una identidad de intención durable y purpose-specific, `LaterUserEnrollmentIntent`, separada de `FirstAdminOnboardingIntent`, tenant-owned y protegida como dato de negocio del tenant; vincular autoritativamente tenant, target email e intended role de forma inmutable; componer el lifecycle existente de `VerificationChallenge`, `SessionGrant` y la frontera Auth Admin de ADR-0019 mediante casos de uso later-user purpose-specific; y detener la foundation de Fase 2 en un handoff pre-Client autenticado pero no tenant-authorized, antes de `PlatformUser`/perfil/`CompanyMembership`/`USER_CREATED`/`UserClientAccess`.**

Esta decisión arquitectónica está `HUMAN APPROVED`. Este estado no implica approved artifact review, canonicalización, incorporación al repositorio, next-task determination ni autorización de implementación.

---

## 8. Nueva identidad conceptual: `LaterUserEnrollmentIntent`

### 8.1 Responsabilidad

`LaterUserEnrollmentIntent` representa una decisión de negocio durable tomada por un `COMPANY_ADMIN` actualmente autorizado para iniciar el enrollment de un usuario posterior dentro de su propio tenant.

No representa:

- una sesión Auth;
- un challenge;
- un `PlatformUser`;
- una `CompanyMembership`;
- un `UserClientAccess`;
- un `Client`;
- un `SupportAccessGrant`;
- tenant authority del invitado;
- onboarding completado.

### 8.2 Identidad separada

Su identidad conceptual es distinta de:

```text
FirstAdminOnboardingIntent.id
MaintenanceCompany.id
VerificationChallenge.id
SessionGrant.id
target email
Auth subject
PlatformUser.id
CompanyMembership.id
```

### 8.3 Purpose

El tipo conceptual fija:

```text
purpose =
ordinary later-user enrollment
```

El purpose no es caller-selectable.

### 8.4 Por qué no es `FirstAdminOnboardingIntent`

`FirstAdminOnboardingIntent` conserva semántica purpose-specific de bootstrap:

- actor global `SUPER_ADMIN`;
- tenant ya creado pero todavía sin first-admin operativo;
- intended role fijo a `COMPANY_ADMIN`;
- cardinalidad bootstrap por empresa;
- constraints y provenance propios de first-admin.

`LaterUserEnrollmentIntent` posee semántica diferente:

- actor tenant `COMPANY_ADMIN`;
- tenant ya operativo;
- target later-user;
- intended role variable dentro del conjunto cerrado permitido;
- repetición para múltiples usuarios a lo largo de la vida del tenant;
- futura composición obligatoria con `UserClientAccess`.

Por tanto:

```text
FirstAdminOnboardingIntent
!=
LaterUserEnrollmentIntent
```

Y:

```text
TASK-017/018/019 implementation surfaces
!=
generic later-user APIs
```

---

## 9. Ownership, RLS y clasificación de datos

### 9.1 Ownership human-approved

`LaterUserEnrollmentIntent` se clasifica como **tenant-owned business state**.

Razones:

- nace de una decisión administrativa del tenant;
- su tenant existe y posee un `COMPANY_ADMIN` actual capaz de autorizarla;
- target email e intended role pertenecen al proceso de administración de usuarios de esa empresa;
- a diferencia de first-admin bootstrap, no existe ausencia de membership administrativa que obligue a situar la intención fuera del tenant boundary.

### 9.2 RLS

Por ser tenant-owned:

```text
RLS =
MANDATORY / PRIMARY REMOTE TENANT ISOLATION BOUNDARY
```

La policy física no se define en este ADR, pero la implementación futura debe demostrar que:

- un tenant no puede listar intents de otro tenant;
- un `TECHNICIAN` no puede crear, reenviar, cambiar ni administrar intents;
- un `COMPANY_ADMIN` sólo actúa sobre intents de su tenant y con autoridad vigente;
- `anon` no obtiene lectura general;
- un target pre-auth no obtiene SELECT directo por conocer un intent ID;
- `authenticated` no obtiene CRUD general sobre la entidad;
- un actor deshabilitado no conserva capacidad por una sesión/JWT stale;
- `SUPER_ADMIN` no obtiene un bypass tenant ordinario.

### 9.3 Pre-auth verification boundary

Que la intención sea tenant-owned no obliga a exponerla al target mediante RLS pública.

La verificación pre-auth debe atravesar una frontera purpose-specific que reciba únicamente locators/proof material mínimos y que resuelva server-side:

```text
opaque intent locator
→ authoritative LaterUserEnrollmentIntent
→ bound tenant/email/role
→ current VerificationChallenge
```

El target no recibe autoridad para consultar arbitrariamente la tabla tenant-owned.

### 9.4 Platform-owned primitives permanecen platform-owned

Se preserva ADR-0019:

- `VerificationChallenge` = platform-owned Identity/Auth state;
- `SessionGrant` = platform-owned Identity/Auth state;
- technical bridge credential = server-only;
- Auth Admin credential = server-only.

No se convierten en tenant-owned para reutilizar las policies de la nueva intención.

---

## 10. Bindings autoritativos

Cada `LaterUserEnrollmentIntent` debe conservar conceptualmente, como mínimo:

```text
stable intent identity
+
one authoritative MaintenanceCompany binding
+
one target email binding
+
one intended fixed role binding
+
purpose = ordinary later-user enrollment
+
historical initiating PlatformUser provenance
+
exactly one current VerificationChallenge correlation at a time
+
idempotency/reconciliation identity sufficient for logical operations
+
durable proof/Auth-handoff facts sufficient for future continuation
```

Este ADR no decide nombres de tabla, columnas, FKs, índices, enums, RPCs ni payloads físicos.

### 10.1 Tenant binding

El tenant se deriva **antes de persistir la intención** desde:

```text
validated Auth subject
→ PlatformUser
→ current enabled CompanyMembership
→ MaintenanceCompany
→ current role = COMPANY_ADMIN
```

`maintenance_company_id` del frontend no puede constituir autoridad.

Una vez creada, la intención queda vinculada al tenant derivado y esa vinculación es inmutable.

### 10.2 Target email binding

El email es:

- dato personal;
- locator del target;
- proof target del challenge;
- no tenant authority;
- no role authority;
- no autorización por sí mismo.

El email bound debe utilizar una representación consistentemente correlacionable con las primitives actuales de Verification/Auth. ADR-0021 no crea una nueva política global de normalización ni unicidad de email.

### 10.3 Intended role binding

Los únicos valores válidos son:

```text
COMPANY_ADMIN
TECHNICIAN
```

El role solicitado inicialmente por la UI del `COMPANY_ADMIN` es **input**, no autoridad por sí mismo. Sólo se transforma en intended role autoritativo después de:

1. validar identidad Auth del actor;
2. resolver membership vigente;
3. derivar tenant vigente;
4. demostrar `role = COMPANY_ADMIN`;
5. validar el valor contra el conjunto fijo permitido;
6. persistirlo como parte del intent autorizado.

Después del commit:

```text
LaterUserEnrollmentIntent.intended_role
=
authoritative enrollment role binding
```

hasta el boundary pre-Client definido por este ADR.

No se confía en:

```text
role caller-supplied during verification
role caller-supplied during session continuation
JWT role claim
Auth metadata role
frontend role state
URL role value
cookie role value
```

### 10.4 Bindings inmutables

Para un intent ya establecido:

```text
tenant binding = IMMUTABLE

target email binding = IMMUTABLE

intended role binding = IMMUTABLE

purpose = IMMUTABLE
```

Cambiar email, tenant o intended role no puede mutar silenciosamente una intención que ya tiene challenge/proof history.

Si el producto necesita cambiar alguno de esos bindings durante un enrollment en curso, la futura TASK deberá utilizar una semántica explícita de reemplazo/supersession/restart compatible con este ADR y con el lifecycle de challenge. ADR-0021 no selecciona su UI ni su representación física.

Después de creación real de la membership, los cambios de role dejan de ser enrollment y se rigen por RF-017/TASK-015.

---

## 11. Actor y autorización tenant

### 11.1 Invariante principal

```text
authenticated != authorized

Auth session != tenant authorization

current authoritative PostgreSQL state
>
stale JWT / cookies / frontend state / cached role
```

### 11.2 Actor permitido para operaciones administrativas de enrollment

Una operación privilegiada de establecimiento o reintento administrativo requiere:

```text
resolved PlatformUser
AND
current enabled CompanyMembership
AND
membership.role = COMPANY_ADMIN
AND
derived MaintenanceCompany = intent tenant
```

### 11.3 Casos obligatoriamente denegados

Debe fallar cerrado, sin mutación de negocio, cuando exista:

- actor Auth no resuelto;
- `PlatformUser` del actor no resuelto;
- `CompanyMembership` ausente;
- membership deshabilitada;
- actor `TECHNICIAN`;
- intent de otro tenant;
- tenant target intentado desde un ID supplied por frontend que no coincide con el tenant derivado;
- pérdida de autoridad antes del commit de una operación privilegiada;
- estado incompatible de target demostrado autoritativamente;
- operación que intenta modificar bindings inmutables de un intent ya establecido.

### 11.4 Revocación del actor entre intentos

Cada operación que requiera autoridad administrativa actual —por ejemplo establecer un intent o emitir/reemitir un challenge— debe revalidar al actor con estado vigente dentro de su boundary transaccional.

Si el actor pierde autoridad antes del commit:

```text
result = DENY
new privileged mutation = NONE
```

Una autoridad perdida **después** de una emisión ya committeada no invalida retroactivamente por inferencia el intent ni el proof ya emitido.

Se preserva la distinción:

```text
historical initiating actor provenance
!=
current authority for a new admin operation
```

ADR-0021 no inventa una regla de producto según la cual revocar al admin revoca automáticamente todas las invitaciones previamente autorizadas. Si se desea esa capacidad, requerirá decisión explícita posterior.

### 11.5 Self-target y re-enrollment

La arquitectura no utiliza igualdad textual de email como única prueba de self-target.

Si el estado autoritativo demuestra que el target corresponde al mismo `PlatformUser`/membership del actor o a una membership ya existente, no se crea un nuevo later-user enrollment para “recrear” esa identidad.

Los estados existentes deben utilizar sus flows correspondientes:

```text
enabled membership
→ existing user, not new enrollment

disabled membership
→ reinstate path, not new enrollment

existing membership role change
→ TASK-015 / RF-017 path, not new enrollment
```

---

## 12. VerificationChallenge composition

### 12.1 Reuse boundary

ADR-0021 reutiliza las primitives de TASK-013/ADR-0019, pero no convierte TASK-017 en API genérica.

La composición later-user debe poseer casos de uso purpose-specific propios.

### 12.2 Exactly one current challenge

Para cada intent sólo puede existir una correlación autoritativa con **un current challenge a la vez**.

La implementación futura debe poder demostrar:

```text
intent
→ exactly one current challenge
```

cuando existe una emisión vigente.

### 12.3 Initial issue

La emisión inicial debe establecer de forma consistente:

```text
immutable intent bindings
+
current challenge
```

sin una ventana en la que un challenge pueda quedar desvinculado de tenant/email/role o donde el role pueda cambiar entre autorización e issue.

### 12.4 Resend

Se conservan las reglas aprobadas del código:

- vigencia de 8 horas por emisión;
- máximo 3 intentos por emisión;
- resend autorizado;
- cada resend crea una nueva emisión;
- nueva emisión invalida inmediatamente la anterior;
- cada emisión tiene su propio presupuesto de 3 intentos;
- una emisión vencida no se recupera ni reutiliza.

El resend debe revalidar current `COMPANY_ADMIN` authority y el tenant bound.

### 12.5 Verify

La verificación es realizada por el target pre-auth y no utiliza una membership tenant del target.

El boundary recibe únicamente material mínimo, conceptualmente equivalente a:

```text
opaque intent locator
+
target email proof locator
+
candidate code
+
logical operation identity
```

El servidor resuelve:

```text
intent locator
→ LaterUserEnrollmentIntent
→ authoritative target email / tenant / intended role
→ current challenge
```

El role y tenant no vuelven a ser inputs de autoridad durante verify.

### 12.6 Old challenge

Después de un resend:

```text
previous challenge
→ invalid / not current
→ cannot produce handoff
```

No se admite race winner ambiguo entre old/new challenge.

---

## 13. Idempotency, concurrencia y safe retry

### 13.1 Principio

Toda operación lógica susceptible de retry debe poseer una identidad de operación suficiente para distinguir:

- retry de la misma operación;
- operación nueva;
- payload incompatible bajo la misma identidad;
- concurrencia legítima;
- replay.

La operation identity no es autorización.

### 13.2 Establish intent

Para el mismo logical operation:

```text
same operation + same authoritative bindings
→ same logical result / reconciliation
```

No debe crear un segundo intent.

```text
same operation + different email/role/tenant binding
→ conflict / deny
```

No debe reinterpretar el operation ID como permiso para cambiar el intent.

### 13.3 Concurrent establishment for same tenant + target

La arquitectura requiere como máximo una intención activa/corriente que pueda avanzar para un mismo target email dentro del mismo tenant.

Dos intentos concurrentes equivalentes deben:

- converger al mismo intent; o
- producir un único winner y una salida reconciliable para el otro.

Dos intentos concurrentes con roles diferentes no pueden resolverse mediante Last Write Wins.

Resultado obligatorio:

```text
role conflict
→ explicit conflict / deny
→ no silent role replacement
```

ADR-0021 no impone unicidad global de email entre tenants.

### 13.4 Resend concurrency

Dos resend concurrentes no pueden dejar dos challenges current.

Debe existir:

```text
at most one successor current challenge
```

El loser debe reconciliar el successor ya confirmado o fallar como stale/conflict, sin reactivar el anterior.

### 13.5 Verify concurrency

El consume del current challenge es single-use.

Dos verifies concurrentes sobre la misma emisión deben producir como máximo un consume autoritativo.

Un retry de la misma operación lógica puede reconciliar el resultado ya committeado; una operación distinta no puede producir un segundo consume.

### 13.6 SessionGrant concurrency

Se preserva ADR-0019:

```text
same SessionGrant
+
two initial auth attempts
→ at most one consume
→ remaining attempt denied
```

### 13.7 Lost response

Si una operación committea y la respuesta se pierde:

- el cliente no debe repetir con una identidad de operación distinta para “forzar” progreso;
- el retry con la misma identidad debe reconciliar el estado ya confirmado;
- no debe crear un segundo intent, challenge, grant o identidad Auth.

---

## 14. Proof consume y handoff

### 14.1 Valid consume

Sólo el current challenge correlacionado con el intent puede producir proof válido.

El consume debe verificar autoritativamente al menos:

- intent existente y utilizable;
- intent purpose correcto;
- target email correlacionado;
- challenge exacto current;
- challenge no vencido;
- challenge no invalidado;
- challenge no consumido;
- attempts budget vigente;
- operation correlation válida;
- ausencia de identidad/application state incompatible conocida.

### 14.2 Resultado

Un consume válido puede producir/reconciliar el handoff necesario para ADR-0019:

```text
consumed business proof
→ one-time SessionGrant
```

El intended role sigue perteneciendo al `LaterUserEnrollmentIntent`; no se convierte en claim de autorización de sesión.

### 14.3 Handoff durability

Debe existir evidencia durable suficiente para que un timeout o pérdida de response después del consume no obligue a:

- reactivar el código;
- consumirlo otra vez;
- emitir una segunda identidad Auth;
- depender de estado volátil del browser.

El detalle físico del handoff pertenece al futuro TASK.

---

## 15. SessionGrant y Auth handoff

### 15.1 ADR-0019 remains authoritative

Se preservan las invariantes:

```text
SessionGrant =
short-lived
single-use
purpose-specific
server-side
non-enumerable by browser
not bearer authority
fail-closed
idempotent/reconcilable
```

### 15.2 Binding

El grant debe quedar correlacionado con una identidad de enrollment later-user suficiente para demostrar que proviene de:

```text
valid LaterUserEnrollmentIntent
+
consumed current VerificationChallenge
+
compatible Auth identity target
```

No es obligatorio duplicar físicamente tenant/role si pueden re-resolverse inequívocamente desde la correlación autoritativa. El futuro TASK definirá el mecanismo mínimo.

### 15.3 Auth identity/session may precede application identity completion

El boundary pre-Client puede terminar con:

```text
Supabase Auth identity established/reconciled
+
initial Auth session established
```

sin implicar:

```text
PlatformUser created/completed
CompanyMembership created
tenant role authority granted
UserClientAccess created
USER_CREATED emitted
later-user onboarding completed
```

Principio obligatorio:

```text
Auth identity/session
!=
PlatformUser domain completion
!=
CompanyMembership
!=
tenant authorization
```

### 15.4 Post-session state

Después de establecer la sesión, cualquier UI de continuación debe tratar al target como **authenticated but not tenant-authorized** hasta que un futuro flow autoritativo complete las transiciones de dominio y client scope exigidas.

No se puede utilizar `intended_role` del intent como permiso operativo mientras no exista la autoridad tenant correspondiente aprobada.

---

## 16. Privileged Auth Admin boundary

### 16.1 Regla

La frontera privilegiada de ADR-0019 sólo puede activarse después de demostrar un enrollment later-user autoritativo suficiente.

### 16.2 Operaciones permitidas conceptualmente

Se conserva la lista cerrada ya aceptada por ADR-0019 para provisioning/reconciliation estrictamente necesario:

- crear identidad Auth cuando no exista y el enrollment esté autorizado;
- actualizar la identidad Auth únicamente para provisioning/rotation/repair de la technical credential y confirmación permitida por el business proof.

ADR-0021 no amplía esa lista.

### 16.3 Prohibiciones

Continúa prohibido:

```text
generic Supabase admin client reusable from arbitrary modules

service-role / secret key as ordinary tenant request client

admin credential used for normal tenant reads/writes

browser-visible Admin credential
```

La credencial privilegiada no obtiene permiso genérico para leer o escribir `LaterUserEnrollmentIntent` como sustituto de RLS tenant.

### 16.4 Separate sign-in boundary

La obtención de sesión del target utiliza la frontera Auth caller-scoped/publishable correspondiente. No se reutiliza el Admin client para “loggear” al usuario.

---

## 17. Prevención de bypass

Debe preservarse el cierre E2 de ADR-0019:

```text
public signup = DENIED

public invite Auth session path = DENIED

OTP / magiclink initial-session bypass = DENIED

recovery as initial enrollment session = DENIED

unsupported future auth methods = DEFAULT DENY

initial session without valid consumed SessionGrant = DENIED
```

Para later-user se agrega la invariance:

```text
valid SessionGrant
must be traceable to
valid LaterUserEnrollmentIntent
+
consumed current business challenge
```

Un target no puede crear una sesión autorizada cambiando:

- role en URL;
- role en frontend state;
- tenant ID;
- intent ID de otro tenant;
- challenge ID;
- Auth metadata;
- JWT claims.

Un locator conocido no es bearer authority.

---

## 18. Duplicate / incompatible identity boundary

ADR-0021 no crea una política de account takeover ni un buscador genérico de usuarios por email.

### 18.1 Existing same-tenant membership

Si el estado autoritativo demuestra que el target ya posee una `CompanyMembership` del mismo tenant:

```text
new enrollment =
INCOMPATIBLE
```

Debe utilizarse el lifecycle existente:

- membership habilitada → usuario existente;
- membership deshabilitada → reinstate;
- role diferente → role-change conforme RF-017/TASK-015.

### 18.2 Existing cross-tenant membership

Si el target ya posee `CompanyMembership` de otro tenant:

```text
later-user enrollment into second tenant =
DENIED
```

Se preserva la cardinalidad MVP `PlatformUser → at most one CompanyMembership` y el aislamiento multiempresa.

### 18.3 Existing global SUPER_ADMIN

Una identidad autoritativamente clasificada como `SUPER_ADMIN` es incompatible con ordinary tenant enrollment bajo el modelo vigente.

No se la convierte silenciosamente en tenant user.

### 18.4 Existing provider/Auth identity without incompatible application authority

Una identidad Auth existente no es por sí misma incompatible ni autorizada.

La frontera server-side puede reconciliarla únicamente si:

- existe correlación inequívoca con el target email/proof;
- no existe autoridad global incompatible;
- no existe `CompanyMembership` incompatible;
- no se realiza account takeover;
- no se expone enumeración al browser;
- la operación sigue el boundary de ADR-0019.

ADR-0021 no decide aquí la creación/reconciliación futura de `PlatformUser` ni de membership.

### 18.5 Enumeration resistance

Los errores externos no deben permitir distinguir innecesariamente:

- email inexistente;
- Auth user existente;
- PlatformUser existente;
- membership de otro tenant;
- global SUPER_ADMIN;
- intent de otro tenant.

El servidor puede registrar una clasificación interna segura para diagnóstico/auditoría técnica sin devolver información sensible al caller no autorizado.

---

## 19. Pre-Client terminal boundary

### 19.1 Boundary de Fase 2

El máximo funcional que ADR-0021 autoriza conceptualmente para un futuro incremento pre-Client es:

```text
current authoritative COMPANY_ADMIN
→ dedicated LaterUserEnrollmentIntent established
→ tenant/email/intended-role immutable binding
→ current VerificationChallenge lifecycle
→ valid current proof consumed
→ one-time SessionGrant created/reconciled
→ Auth identity/session established or safely reconciled
→ durable later-user pre-Client handoff ready
→ [ADR-0021 PRE-CLIENT BOUNDARY ENDS]
```

### 19.2 Lo que NO existe al cruzar ese boundary

El boundary anterior no significa:

```text
PlatformUser application completion = YES
profile completion = YES
CompanyMembership creation = YES
membership enabled = YES
tenant authority = YES
UserClientAccess = YES
USER_CREATED = YES
ordinary later-user onboarding complete = YES
RF-015 satisfied = YES
```

### 19.3 Terminal sólo para el stage pre-Client

El estado final puede ser durable y terminal respecto del **stage de verification/Auth handoff de Fase 2**, pero no es el estado terminal del onboarding de producto.

```text
pre-Client handoff complete
!=
later-user onboarding complete
```

### 19.4 No fake client scope

No se crean:

- client IDs placeholder;
- lista vacía tratada como cumplimiento;
- scope “all future clients”;
- wildcard tenant client access;
- pending ficticio de `UserClientAccess` que se considere RF-015 satisfecho.

---

## 20. Continuación obligatoria en Fase 3

### 20.1 RF-015 remains mandatory

La composición final en Fase 3 deberá exigir uno o más `Client` reales del mismo tenant antes de declarar completed ordinary later-user onboarding.

### 20.2 Cross-tenant client assignment

RF-016 continúa obligatorio:

```text
Client.maintenance_company_id
must equal
authoritative enrollment tenant
```

No se confía en client IDs enviados por frontend sin ownership/authorization revalidation.

### 20.3 Final composition must revalidate current state

La futura completion deberá volver a comprobar, con estado vigente:

- intent/handoff correlacionado;
- Auth subject correcto;
- target email correlation;
- intended role binding;
- target identity compatibility;
- Client ownership same-tenant;
- client count >= 1;
- invariantes de membership;
- cualquier decisión funcional adicional aprobada para perfil/completion.

### 20.4 No silent sequencing change

ADR-0021 no modifica FL-02.

La existencia de primitives pre-Client implementadas internamente en Fase 2 no autoriza una UI final que omita la selección obligatoria de clients ni una success state que declare usuario completamente creado.

La orquestación de Fase 3 deberá preservar la secuencia de producto aprobada o, si una necesidad real exige cambiarla, volver a decisión de producto antes de implementación.

---

## 21. `PlatformUser`, `CompanyMembership`, profile y `USER_CREATED`

### 21.1 `PlatformUser`

ADR-0021 no decide cuándo se crea/completa un `PlatformUser` para later-user.

Puede existir Auth identity/session antes de esa transición, siempre que no se interprete como tenant authority.

### 21.2 Profile completion

El producto exige profile completion dentro del onboarding, pero ADR-0021 no copia automáticamente la solución purpose-specific de first-admin.

Los campos ya normativos de perfil continúan siendo los que la baseline vigente defina; este ADR no agrega campos.

### 21.3 `CompanyMembership`

ADR-0021 no crea ni habilita una membership pre-Client.

No se inventa:

```text
disabled placeholder membership
pending membership as RF-015 substitute
enabled membership with zero Clients
```

### 21.4 Intended role is not current role authority

Hasta que exista una future authoritative membership transition:

```text
LaterUserEnrollmentIntent.intended_role
!=
current tenant role authority
```

### 21.5 `USER_CREATED`

La foundation física de `AuditEvent` ya reconoce `USER_CREATED` como acción disponible para alta de usuario.

ADR-0021 no lo produce porque su boundary no crea/completa el usuario de aplicación ni su membership.

El futuro completion flow deberá decidir y documentar el producer timing exacto de `USER_CREATED` antes de implementación, sin inferirlo automáticamente de first-admin.

---

## 22. AuditEvent implications

### 22.1 No new audit action by inference

ADR-0021 no inventa nuevos nombres como:

- `USER_INVITED`;
- `ENROLLMENT_ISSUED`;
- `ENROLLMENT_VERIFIED`;
- `ENROLLMENT_RESENT`.

No existe baseline que exija esos AuditEvent funcionales.

### 22.2 Provenance

El intent debe preservar historical initiating actor provenance suficiente para que la futura creación/completion pueda explicar quién originó el enrollment.

```text
historical actor provenance
!=
AuditEvent by itself
```

### 22.3 Future user creation

Cuando el producto alcance la transición de alta efectiva, deberá producir la auditoría de creación requerida conforme al contrato vigente y dentro de la atomicidad que la future specification apruebe.

### 22.4 Future client access

La obligación futura `USER_CLIENT_ACCESS_CHANGED` permanece ligada a la materialización de `Client`/`UserClientAccess` y deberá estar físicamente soportada antes de liberar mutaciones que requieran esa trazabilidad.

ADR-0021 no adelanta esa extensión.

---

## 23. UI / flow implications arquitectónicas

ADR-0021 no diseña UI visual, rutas definitivas ni componentes React.

Sí impone las siguientes fronteras:

### 23.1 Admin initiation

La UI de administración puede solicitar conceptualmente:

```text
target email
requested fixed role
```

No necesita ni debe utilizar `maintenance_company_id` como autoridad.

El backend devuelve un resultado bounded; el tenant deriva del actor.

### 23.2 Invitee verification

El target puede utilizar:

- un locator opaco del intent obtenido por navegación/link;
- email;
- código.

El locator no es proof ni authorization.

### 23.3 Role display

Si la UI muestra el intended role al target, es display-only. El target no puede editarlo ni reenviarlo como autoridad.

### 23.4 Post-session UI

Después del Auth handoff y antes de future completion, la UI debe representar un estado pendiente/no autorizado para datos tenant.

No debe mostrar una success state equivalente a:

- “usuario creado completamente”;
- “acceso al tenant habilitado”;
- “clientes asignados”.

### 23.5 No generic first-admin reuse

Rutas/componentes/handlers first-admin pueden aportar patrones, pero no se reutilizan como API genérica si esa reutilización mezcla purpose, actor o cardinalidad.

---

## 24. Offline behavior

```text
ordinary later-user enrollment =
ONLINE-ONLY
```

Razones:

- actor authority debe revalidarse online;
- tenant debe resolverse desde PostgreSQL authoritative state;
- challenge expiry/attempts/current status son remotos;
- resend debe invalidar autoritativamente la emisión anterior;
- proof consume es single-use remoto;
- SessionGrant es server-side y short-lived;
- Auth Admin es privilegiado y server-only;
- session establishment requiere Supabase Auth.

Queda fuera:

- Dexie entity de enrollment;
- IndexedDB como autoridad;
- outbox de issue/resend/verify;
- optimistic local enrollment;
- cached role/tenant authority;
- offline Auth Admin operation;
- offline challenge consume.

Si se pierde conectividad después de enviar una request, la recuperación es online mediante idempotency/reconciliation, no mediante replay offline independiente.

---

## 25. Trust boundaries

### 25.1 Browser del `COMPANY_ADMIN`

Untrusted input source.

Puede aportar target email, requested role e operation correlation, pero no autoridad de tenant/role propia.

### 25.2 Authoritative tenant authorization boundary

Server-side/DB-authoritative boundary que resuelve actor, enabled membership, tenant y role vigente.

### 25.3 Tenant-owned intent persistence

`LaterUserEnrollmentIntent` se protege con RLS y constraints/invariants que impidan cross-tenant tampering y silent rebinding.

### 25.4 Pre-auth target boundary

Acepta locator/email/code mínimos. No concede SELECT general ni tenant authority.

### 25.5 Platform-owned Verification boundary

Custodia challenge state, attempts, expiry, current/consumed/invalidation semantics.

### 25.6 SessionGrant / token issuance boundary

Permite un único initial session issuance después de consumed proof.

### 25.7 Privileged Auth Admin boundary

Server-only, purpose-specific, mínimo privilegio. No lee/escribe datos tenant ordinarios como bypass.

### 25.8 Supabase Auth session

Prueba identidad Auth, no membership, tenant, role ni client scope.

---

## 26. Browser-visible vs server-only data

### 26.1 Browser-visible como máximo según necesidad

Puede ser visible/transitar:

- target email que el actor está registrando o que el target debe probar;
- requested role en la UI del actor antes del commit;
- intended role como display-only cuando corresponda;
- locator opaco de intent;
- verification code introducido por el target;
- bounded success/error state;
- operation correlation no secreta cuando la implementación lo requiera.

### 26.2 Server-only / non-enumerable

Debe permanecer server-only o protegido por fronteras purpose-specific:

- Auth Admin credential;
- technical password;
- SessionGrant internals;
- challenge verifier/key material;
- authoritative tenant resolution internals;
- identity enumeration/reconciliation details;
- incompatible cross-tenant membership details;
- privileged provider responses;
- raw DB state que permita enumerar intents/challenges/grants.

---

## 27. Threat model

| Threat | Riesgo | Control arquitectónico requerido |
|---|---|---|
| Caller manipula `maintenance_company_id` | Cross-tenant enrollment | Tenant derivado exclusivamente de current actor membership; intent bound immutable |
| Caller manipula role | Escalación de privilegio | Role validado bajo current COMPANY_ADMIN authority y persistido en intent; no role authority posterior desde browser/JWT |
| Target cambia role durante verify | Escalación | Verify no acepta role como autoridad |
| Intent ID leaked | Enrollment hijack | Locator no es bearer proof; requiere email/code/current challenge y server-side correlation |
| Old code después de resend | Replay | Old challenge invalidado y ya no current |
| Code replay | Account takeover | Single-use consume + durable reconciliation |
| Double verify | Doble handoff/session | Atomic consume + idempotency + single-use SessionGrant |
| Admin disabled after page load | Stale-authority write | Revalidation dentro de mutation boundary antes de commit |
| TECHNICIAN llama admin flow | Unauthorized enrollment | Current role resolved from DB, fail closed |
| Cross-tenant target/intent manipulation | Data leak / unauthorized provisioning | RLS + tenant-bound intent + purpose-specific server boundary |
| Existing user reinvited | Duplicate/authority confusion | Authoritative identity/membership compatibility check; existing lifecycle instead |
| Existing user from another tenant | Multi-tenant breach | Deny; preserve one-membership invariant |
| Existing SUPER_ADMIN target | Global/tenant role confusion | Deny incompatible classification |
| Auth identity exists | Enumeration/account takeover | Server-only reconciliation, bounded external errors, no generic search endpoint |
| Public signup/invite/OTP path | Bypass business proof | ADR-0019 E2 gates remain mandatory |
| Generic service-role client | RLS bypass | Prohibited; narrow privileged Auth boundary only |
| Session carries intended role | Authorization bypass | Auth session not tenant authorization; role claim ignored as authority |
| Concurrent intents with conflicting roles | Silent privilege drift | One current intent per tenant+target; explicit conflict, no LWW |
| Timeout after remote Auth mutation | Duplicate Auth identity | Stable correlation and reconciliation; no blind create retry |
| Offline replay | Stale authority / duplicated effects | Enrollment online-only; no outbox authority |

---

## 28. Failure and recovery model

### 28.1 Actor failures

| Failure | Required behavior |
|---|---|
| actor unresolved | deny, no enrollment mutation |
| membership missing | deny |
| membership disabled | deny |
| actor TECHNICIAN | deny |
| authority revoked before commit | deny, no new privileged mutation |
| cross-tenant intent access | deny without leaking target details |

### 28.2 Challenge failures

| Failure | Required behavior |
|---|---|
| wrong code | consume attempt according to existing challenge rules; no handoff |
| attempt budget exhausted | terminal failure for that emission; no handoff |
| expired code | deny; no resurrection |
| old code after resend | deny as non-current/invalid |
| duplicate consume | same-operation reconciliation only; no second effect |

### 28.3 Email delivery failure

Authoritative business-code issue y external delivery son responsabilidades diferentes.

Si la DB confirma issue pero la entrega externa falla:

- el challenge emitido no se “desconfirma” silenciosamente;
- no se revive el challenge anterior;
- la recuperación utiliza resend/replacement autorizado o la política de delivery aprobada;
- el detalle de provider/delivery queue permanece fuera de ADR-0021.

### 28.4 Auth Admin partial failure

Si la operación privilegiada crea/reconcilia Auth state pero la respuesta se pierde:

- retry no ejecuta blind `createUser`;
- se re-resuelve el estado mediante correlación autoritativa;
- se evita duplicate Auth identity;
- no se transforma una identidad incompatible en compatible por reparación silenciosa.

### 28.5 SessionGrant failure

Si un grant expira/no llega a consumirse:

- no se reactiva el VerificationChallenge consumido;
- no se emiten grants ilimitados desde browser;
- la recuperación debe ser purpose-specific, server-side y reconciliable bajo ADR-0019;
- el futuro TASK definirá el mecanismo físico mínimo sin permitir múltiples grants simultáneamente utilizables para el mismo handoff.

### 28.6 Lost session response

Si Auth confirma sesión pero la response/browser transition se pierde, la recuperación debe preferir el lifecycle SSR/Auth vigente y reconciliar la sesión existente. No debe emitir una segunda autorización inicial sólo porque la UI no vio el éxito.

### 28.7 Incompatible identity

Resultado:

```text
fail closed
+
no membership mutation
+
no tenant authority
+
no account takeover
+
no silent role repair
```

---

## 29. Alternativas consideradas

### 29.1 A — Genericize/reuse `FirstAdminOnboardingIntent`

**Product fit:** deficiente. First-admin tiene purpose, actor global, cardinalidad bootstrap y role fijo diferentes.

**Security:** mezclaría dos trust models: `SUPER_ADMIN` global y `COMPANY_ADMIN` tenant. Aumentaría el riesgo de branches de autorización ambiguos.

**Tenant binding:** first-admin deriva tenant desde un company ya creado antes de que exista first-admin membership; later-user puede y debe derivarlo desde current tenant membership.

**Role binding:** first-admin fija siempre `COMPANY_ADMIN`; later-user necesita `COMPANY_ADMIN | TECHNICIAN`.

**Idempotency/concurrency:** una misma entidad tendría uniqueness/cardinality incompatibles: one-first-admin-per-company vs múltiples later-users.

**Reuse:** reutilizaría más código superficialmente, pero a costa de convertir contracts purpose-specific en un framework genérico no aprobado.

**Failure recovery:** tendría que distinguir semánticas distintas dentro del mismo state machine y aumentaría riesgo de reintentos cruzados.

**Migration/data:** requeriría generalizar schema y constraints de first-admin, arriesgando regresiones sobre una capability cerrada.

**Future Phase 3:** complicaría agregar mandatory client scope sólo para later-users.

**Resultado:** `NOT SELECTED`.

---

### 29.2 B — Dedicated `LaterUserEnrollmentIntent`

**Product fit:** preserva el significado distinto de ordinary later-user enrollment y permite bindear intended role sin alterar first-admin.

**Security:** separa actor/authorization paths y permite tenant-derived RLS, immutable bindings y fail-closed compatibility checks.

**Tenant binding:** derivado de current enabled `CompanyMembership` del actor y persistido como ownership del intent.

**Role binding:** valor cerrado `COMPANY_ADMIN | TECHNICIAN`, autorizado al establish y luego inmutable.

**Idempotency/concurrency:** permite constraints y operation identities específicas para múltiples usuarios por tenant sin tocar cardinalidad first-admin.

**Reuse:** reutiliza `VerificationChallenge`, `SessionGrant`, token gate y Auth Admin boundary como primitives, no como APIs first-admin genéricas.

**Failure recovery:** durable intent + current challenge + handoff correlation permiten retries explícitos.

**Migration/data:** requerirá materialización futura propia, sin migrar `first_admin_onboarding_intents` a una abstracción genérica.

**Future Phase 3:** ofrece un handoff claro sobre el cual componer mandatory `UserClientAccess` antes de completion.

**Resultado:** `SELECTED BY THIS HUMAN-APPROVED ADR`.

---

### 29.3 C — Challenge-only without durable business intent

**Product fit:** insuficiente; el challenge prueba email, no la decisión de tenant+role.

**Security:** obligaría a recuperar tenant/role desde browser, payload previo o estado lateral ambiguo.

**Tenant binding:** no existe identidad durable que preserve la decisión del admin.

**Role binding:** vulnerable a rebinding entre issue y verify.

**Idempotency/concurrency:** difícil distinguir resend/retry de un enrollment diferente con mismo email.

**Reuse:** aparenta reutilizar TASK-013 directamente, pero sobrecarga `VerificationChallenge` con responsabilidades de negocio que no le pertenecen.

**Failure recovery:** response loss y retries no disponen de una business identity estable.

**Migration/data:** menos datos inmediatos, pero trasladaría complejidad a challenge/Auth y probablemente requeriría posteriores correcciones.

**Future Phase 3:** no ofrece un handoff estable para client assignment.

**Resultado:** `NOT SELECTED`.

---

### 29.4 D — Create membership/user before proof

**Product fit:** contradice el patrón email+code como prueba previa al alta autorizada y adelanta un estado que la baseline no define.

**Security:** crea identidad/membership/role antes de demostrar posesión del email y aumenta superficie de cuentas huérfanas o privilegio accidental.

**Tenant binding:** podría crear filas tenant-owned para un target no probado.

**Role binding:** el role se materializaría como autoridad antes de verification.

**Idempotency/concurrency:** aumenta riesgo de duplicates y estados parcialmente creados.

**Reuse:** evita el handoff correcto de ADR-0019 en vez de reutilizarlo.

**Failure recovery:** exigiría rollback/cleanup de users/memberships si el target nunca verifica.

**Migration/data:** introduciría estados intermedios no aprobados como disabled/pending membership.

**Future Phase 3:** podría dejar enabled/disabled membership sin mandatory client scope y presionar a considerar cero Clients como válido.

**Resultado:** `NOT SELECTED`.

---

### 29.5 E — Defer all later-user work until `Client` exists

**Product fit:** preservaría RF-015 al esperar Fase 3, pero ignoraría la determinación aprobada que identifica una capability pre-Client no dependiente todavía pendiente en Fase 2.

**Security:** no presenta una ventaja necesaria; las primitives de Auth/Verification pueden prepararse ahora con un boundary estricto.

**Tenant binding / role binding:** se pospondrían sin necesidad técnica.

**Idempotency/concurrency:** también se pospondrían, aumentando el tamaño y riesgo del futuro incremento de Fase 3.

**Reuse:** desperdicia la oportunidad de componer foundations ya presentes dentro de Fase 2.

**Failure recovery:** concentraría challenge, Auth, client assignment, profile y membership completion en un slice mayor.

**Migration/data:** posterga todo el modelado, no lo simplifica necesariamente.

**Future Phase 3:** haría que Fase 3 absorba trabajo explícitamente determinado como remaining non-Client-dependent Phase 2 capability.

**Resultado:** `NOT SELECTED`.

---

## 30. Consecuencias de la decisión human-approved

### 30.1 Consecuencias positivas

- separa first-admin y later-user sin duplicar las primitives criptográficas/Auth;
- convierte tenant/email/role en bindings durables y revisables;
- impide que role/tenant vuelvan a depender del browser durante verification;
- preserva RLS para la nueva data tenant-owned;
- permite safe retries y concurrencia explícita;
- conserva una frontera Auth privilegiada estrecha;
- permite continuar en Fase 3 con un handoff claro;
- evita crear membership/user authority antes de resolver RF-015;
- no requiere microservicios ni infraestructura paralela.

### 30.2 Costes / tradeoffs

- introduce una nueva identidad conceptual y, en futura implementación, persistencia adicional;
- requiere coordinación explícita entre estado tenant-owned del intent y primitives platform-owned de Auth;
- exige tests de concurrencia y seguridad adicionales;
- obliga a mantener dos workflows purpose-specific —first-admin y later-user— en vez de una tabla/API “genérica”;
- Fase 3 deberá componer el handoff con Client/UserClientAccess y todavía resolver el punto funcional exacto de completion si no está definido por el canon al momento de especificar.

### 30.3 Consecuencia intencional

La duplicación semántica limitada entre first-admin/later-user se acepta cuando preserva trust boundaries y responsabilidades. No se crea una abstracción genérica sólo para reducir líneas de código.

---

## 31. Impacto arquitectónico

### 31.1 Application architecture

La capability permanece dentro del monolito modular Next.js aprobado.

Debe vivir detrás de un módulo/contract de Identity & Authorization suficientemente separado para no exponer directamente:

- tabla de intent;
- VerificationChallenge internals;
- Auth Admin client;
- SessionGrant internals.

No se justifican microservicios.

### 31.2 Domain boundary

Se incorpora el concepto `LaterUserEnrollmentIntent` como coordinador purpose-specific de ordinary later-user enrollment pre-Client.

No modifica el significado de:

- `PlatformUser`;
- `CompanyMembership`;
- `MaintenanceCompany`;
- `Client`;
- `UserClientAccess`;
- `FirstAdminOnboardingIntent`.

### 31.3 Security impact

Se agrega una nueva superficie sensible de PII/authorization intent que exige:

- RLS tenant;
- purpose-specific mutation boundaries;
- pre-auth non-enumerable verification boundary;
- immutable bindings;
- concurrency controls;
- no generic privileged client.

### 31.4 RLS impact

Una futura implementación deberá crear/ajustar RLS únicamente para la nueva entidad tenant-owned y cualquier vista/function estrictamente necesaria.

No se debilitan policies existentes de otros recursos.

### 31.5 Auth impact

No cambia E2 de ADR-0019. Se agrega un nuevo consumer purpose-specific de sus primitives.

### 31.6 Offline impact

Ninguno: enrollment permanece online-only.

### 31.7 Phase 3 impact

Fase 3 recibe un durable pre-Client handoff y conserva ownership sobre:

- `Client`;
- `UserClientAccess`;
- mandatory RF-015 composition;
- cross-tenant client ownership validation;
- completion de ordinary later-user onboarding.

---

## 32. Data and migration implications

### 32.1 Durable persistence required

La decisión seleccionada requiere persistencia durable para `LaterUserEnrollmentIntent`.

Una futura TASK deberá proponer el modelo físico mínimo que soporte:

- stable ID;
- tenant ownership;
- target email;
- intended role;
- initiator provenance;
- current challenge correlation;
- operation idempotency;
- proof/Auth handoff facts;
- terminal/reconciliation evidence necesaria;
- timestamps autoritativos estrictamente necesarios.

### 32.2 No physical schema selected here

ADR-0021 no decide:

- table name;
- column names;
- indexes;
- constraints exactas;
- enum vs text+check;
- RPC/function names;
- trigger;
- lock syntax;
- transaction SQL;
- RLS executable;
- grants.

### 32.3 Migration implication

Si ADR-0021 se acepta, el futuro incremento de implementación necesitará al menos una migration revisada para materializar la nueva state identity y su RLS/constraints.

No se autoriza esa migration mediante este ADR.

### 32.4 Existing first-admin data

No se migra ni generaliza `first_admin_onboarding_intents` por conveniencia.

No existe obligación de transformar datos históricos first-admin al nuevo modelo.

---

## 33. Testing implications

Una futura implementación deberá incluir, como mínimo, pruebas positivas y negativas de las siguientes clases.

### 33.1 Actor authorization

- enabled same-tenant `COMPANY_ADMIN` puede iniciar;
- `TECHNICIAN` no puede;
- disabled membership no puede;
- missing membership no puede;
- actor stale después de revocación no puede confirmar nueva privileged mutation;
- caller-supplied tenant distinto no cambia el tenant derivado.

### 33.2 Tenant isolation / RLS

- admin tenant A no lee intent tenant B;
- admin tenant A no muta intent tenant B;
- anon no lista intents;
- target pre-auth no usa direct SELECT como verificación;
- `SUPER_ADMIN` no obtiene ordinary tenant CRUD por ser global;
- no generic service-role bypass.

### 33.3 Role binding

- sólo `COMPANY_ADMIN` y `TECHNICIAN` son válidos;
- role queda bound al commit inicial;
- verify no acepta role override;
- SessionGrant/Auth continuation no acepta role override;
- same intent no puede mutarse silenciosamente de role;
- concurrent different-role establishment no usa LWW.

### 33.4 Challenge lifecycle

- 8h;
- 3 attempts por emisión;
- resend successor;
- previous challenge invalidado;
- current challenge único;
- expired/replayed challenge denied;
- concurrent consume at most once.

### 33.5 Idempotency/retry

- duplicate establish same operation;
- same operation mismatched payload;
- lost response after establish;
- duplicate resend;
- lost response after resend;
- duplicate verify;
- lost response after consume;
- SessionGrant double consume;
- Auth Admin response loss + reconciliation.

### 33.6 Identity compatibility

- existing same-tenant enabled membership;
- existing same-tenant disabled membership;
- existing cross-tenant membership;
- current SUPER_ADMIN identity;
- compatible existing Auth identity without tenant authority;
- unknown/nonexistent identity;
- no account enumeration in external responses.

### 33.7 Bypass tests

- public signup denied;
- public invite-session path denied;
- OTP/magiclink initial-session path denied;
- recovery initial-session bypass denied;
- password sign-in without grant denied;
- reused grant denied;
- leaked intent locator insufficient;
- JWT/frontend role ignored as authority.

### 33.8 Pre-Client boundary tests

After successful pre-Client handoff, assert:

```text
Client rows created = NO
UserClientAccess rows created = NO
CompanyMembership created by this foundation = NO
PlatformUser completion by this foundation = NO
USER_CREATED produced by this foundation = NO
tenant operational authorization = NO
```

### 33.9 Offline tests

Verify absence of enrollment outbox/offline authority and safe online recovery after interrupted requests.

---

## 34. Dependencies

### 34.1 Required existing dependencies

- authoritative Auth SSR/session lifecycle;
- Auth subject → PlatformUser foundation;
- authoritative online actor resolution;
- `CompanyMembership` role/enabled state;
- `VerificationChallenge` foundation;
- `SessionGrant` foundation;
- Custom Access Token gate;
- purpose-specific privileged Auth Admin boundary;
- AuditEvent foundation;
- TASK-015 membership lifecycle semantics;
- RLS/multitenancy architecture.

### 34.2 Deferred dependencies

- physical `Client`;
- `UserClientAccess`;
- future physical audit support for client-access changes;
- final later-user profile/membership/onboarding-completion composition.

### 34.3 Non-dependency

ADR-0021 does not depend on:

- forms;
- maintenance;
- evidence;
- reporting;
- AI credits;
- subscription/payments;
- offline engine implementation.

---

## 35. Out of scope

ADR-0021 no diseña ni autoriza:

- SQL;
- migrations;
- RLS executable;
- table/column/index names;
- RPC/function signatures;
- Auth Hook changes ejecutables;
- Supabase configuration changes;
- production email provider;
- email queue/retry worker;
- UI visual final;
- routes definitivas;
- `Client`;
- `UserClientAccess`;
- `SupportAccessGrant`;
- placeholder/minimal Client;
- client wildcard;
- profile field changes;
- exact later-user profile completion timing;
- `PlatformUser` creation/completion timing;
- initial `CompanyMembership` creation timing;
- later-user `USER_CREATED` producer timing;
- full later-user onboarding completion;
- generic invitation framework;
- generic enrollment engine;
- generic idempotency framework;
- generic Supabase Admin client;
- service-role ordinary request path;
- offline enrollment;
- Dexie/IndexedDB enrollment state;
- microservice;
- TASK-020;
- Phase 2 Exit Gate;
- Phase 2 closure;
- Phase 3 start.

---

## 36. Blockers and deferred decisions

### 36.1 Blockers for this ADR

```text
BLOCKERS =
NONE
```

La decisión arquitectónica puede revisarse independientemente de Client porque su terminal boundary está antes de las transiciones Client-dependent.

### 36.2 Deferred product/composition decisions

No bloquean ADR-0021, pero sí bloquean cualquier future task que pretenda completar ordinary later-user onboarding sin una resolución suficiente:

1. punto exacto de creación/reconciliación de `PlatformUser` para later-user;
2. punto exacto y UI de profile completion para later-user;
3. punto exacto de creación de initial `CompanyMembership`;
4. atomicidad final entre profile/membership/client scope/audit;
5. exact later-user `USER_CREATED` producer timing;
6. cualquier semántica de cancel/restart/replace user-visible que exceda immutable bindings + safe retry;
7. cualquier política explícita que quiera invalidar automáticamente un enrollment committeado por posterior revocación del initiating admin;
8. cualquier cambio a FL-02 sequencing.

Si una futura specification necesita seleccionar alguno de esos comportamientos y el canon no lo resuelve, el resultado debe ser:

```text
BLOCKER — PRODUCT DECISION REQUIRED
```

No debe inferirse desde first-admin.

---

## 37. Documentación impactada si ADR-0021 es aceptada

### 37.1 Product/domain baseline

La decisión human-approved **no modifica**:

- RF-013;
- RF-014;
- RF-015;
- RF-016;
- RF-017;
- modelo conceptual de `PlatformUser`;
- modelo conceptual de `CompanyMembership`;
- `MaintenanceCompany = tenant`;
- estrategia RLS;
- offline strategy;
- Client = Phase 3.

Por tanto:

```text
mandatory product/domain correction caused by ADR-0021 =
NO
```

### 37.2 Architecture/current-state synchronization

La `ADR-0021 HUMAN APPROVAL = APPROVED` resuelve la decisión arquitectónica conforme al lifecycle vigente, sin implicar canonicalización ni incorporación al repositorio. La gobernanza podrá requerir un Gate documental separado para reflejar:

- ADR-0021 = ACCEPTED en el registro/índice arquitectónico vigente, conforme al meaning de `ACCEPTED` ya vigente;
- prerequisite architectural state de la siguiente future TASK;
- current Phase 2 state.

No se autoriza ninguna de esas modificaciones mediante este documento.

### 37.3 ADR-0020

```text
ADR-0020 modification required =
NO
```

First-admin permanece purpose-specific.

---

## 38. Acceptance Criteria

Cada criterio deberá poder revisarse como `PASS` o `FAIL`.

**AC-0021-001.** El ID es exactamente `ADR-0021`.

**AC-0021-002.** El título es exactamente `ADR-0021 — Authoritative Later-User Enrollment Intent Binding`.

**AC-0021-003.** El status refleja `HUMAN APPROVED` sin afirmar Gates documentales posteriores no realizados.

**AC-0021-004.** `ADR-0021 SPEC REVIEW = APPROVED`, `ADR-0021 SPEC RE-REVIEW = APPROVED`, `F-0021-SPEC-001 = RESOLVED` y `ADR-0021 HUMAN APPROVAL = APPROVED`; `ADR-0021 APPROVED ARTIFACT REVIEW = APPROVED`, `ADR-0021 CANONICALIZATION AUTHORIZATION = APPROVED` y `ADR-0021 CANONICALIZATION = PASS`, sin afirmar `ADR-0021 CANONICALIZATION REVIEW = APPROVED` ni repository incorporation.

**AC-0021-005.** Implementation permanece `NOT AUTHORIZED`.

**AC-0021-006.** `TASK-020` permanece `NOT DETERMINED`.

**AC-0021-007.** Fase 2 permanece `IN PROGRESS / NOT CLOSED`.

**AC-0021-008.** Fase 3 permanece `NOT STARTED`.

**AC-0021-009.** No se define Phase 2 Exit Gate.

**AC-0021-010.** RF-013..RF-017 permanecen sin modificación.

**AC-0021-011.** RF-015 permanece mandatory.

**AC-0021-012.** Zero client assignment no se trata como satisfacción de RF-015.

**AC-0021-013.** `Client` permanece en Fase 3.

**AC-0021-014.** No se diseña minimal/temporary/placeholder Client.

**AC-0021-015.** La alternativa seleccionada human-approved es un dedicated `LaterUserEnrollmentIntent`.

**AC-0021-016.** `FirstAdminOnboardingIntent` no se genericiza.

**AC-0021-017.** TASK-017/018/019 no se transforman silenciosamente en APIs genéricas.

**AC-0021-018.** `LaterUserEnrollmentIntent` se clasifica como tenant-owned business state.

**AC-0021-019.** RLS permanece primary remote isolation boundary para el intent tenant-owned.

**AC-0021-020.** El tenant inicial se deriva del current authoritative actor, no de frontend input.

**AC-0021-021.** Actor válido requiere current enabled `COMPANY_ADMIN` membership.

**AC-0021-022.** Actor `TECHNICIAN` es denegado.

**AC-0021-023.** Missing/disabled membership es denegada.

**AC-0021-024.** Authority loss antes del commit de una privileged admin operation impide la mutación.

**AC-0021-025.** Historical initiator provenance no sustituye current authority para una nueva admin operation.

**AC-0021-026.** Revocación posterior del initiator no invalida retroactivamente el intent/proof por inferencia.

**AC-0021-027.** Target email queda autoritativamente bound al intent.

**AC-0021-028.** Intended role queda autoritativamente bound al intent.

**AC-0021-029.** Sólo `COMPANY_ADMIN` y `TECHNICIAN` son roles intended válidos.

**AC-0021-030.** Tenant/email/role/purpose son inmutables dentro de un intent establecido.

**AC-0021-031.** Role de verify/session continuation no se confía al caller.

**AC-0021-032.** JWT/frontend/URL/cookies no constituyen role authority.

**AC-0021-033.** Existe exactamente un current `VerificationChallenge` por intent cuando hay una emisión vigente.

**AC-0021-034.** Resend invalida previous challenge y deja un único successor current.

**AC-0021-035.** Se preservan 8h y 3 attempts por emisión.

**AC-0021-036.** Sólo el current challenge puede producir proof/handoff.

**AC-0021-037.** Challenge consume es single-use y reconciliable.

**AC-0021-038.** `SessionGrant` conserva las invariantes de ADR-0019.

**AC-0021-039.** SessionGrant sólo deriva de consumed business proof correlacionado a valid later-user intent.

**AC-0021-040.** Public signup continúa denegado.

**AC-0021-041.** Public invite/session bypass continúa denegado.

**AC-0021-042.** OTP/magiclink/recovery no pueden bypass initial-session gate.

**AC-0021-043.** Generic privileged Supabase client permanece prohibido.

**AC-0021-044.** Service-role como ordinary tenant request path permanece prohibido.

**AC-0021-045.** Privileged Auth Admin boundary sólo actúa después de enrollment/proof suficiente.

**AC-0021-046.** Existing same-tenant membership no se duplica mediante new enrollment.

**AC-0021-047.** Disabled same-tenant membership utiliza reinstate semantics, no re-enrollment.

**AC-0021-048.** Existing cross-tenant membership es incompatible y se deniega.

**AC-0021-049.** Existing SUPER_ADMIN identity no se convierte silenciosamente en tenant user.

**AC-0021-050.** Existing Auth identity no se usa como authority y se reconcilia sólo server-side si es compatible.

**AC-0021-051.** Browser no obtiene generic identity enumeration.

**AC-0021-052.** Establish/resend/verify/Auth handoff poseen idempotency/reconciliation requirements.

**AC-0021-053.** Concurrent conflicting-role intents no se resuelven por Last Write Wins.

**AC-0021-054.** Retry after lost response no produce duplicate intent/challenge/grant/Auth identity.

**AC-0021-055.** El pre-Client terminal boundary puede llegar a Auth identity/session establishment.

**AC-0021-056.** Auth identity/session no equivale a `PlatformUser` completion.

**AC-0021-057.** Auth identity/session no equivale a `CompanyMembership`.

**AC-0021-058.** Auth identity/session no equivale a tenant authorization.

**AC-0021-059.** Pre-Client foundation no crea `UserClientAccess`.

**AC-0021-060.** Pre-Client foundation no declara `USER_CREATED` producido.

**AC-0021-061.** Pre-Client foundation no declara ordinary later-user onboarding complete.

**AC-0021-062.** Exact `PlatformUser` creation/completion timing queda fuera de ADR-0021.

**AC-0021-063.** Exact initial `CompanyMembership` establishment timing queda fuera de ADR-0021.

**AC-0021-064.** Exact later-user `USER_CREATED` producer timing queda fuera de ADR-0021.

**AC-0021-065.** Si un future TASK requiere decidir esos puntos sin baseline suficiente, debe declarar `BLOCKER — PRODUCT DECISION REQUIRED`.

**AC-0021-066.** Enrollment permanece online-only.

**AC-0021-067.** No se introduce Dexie/outbox/offline authority para enrollment.

**AC-0021-068.** No se inventan nuevos AuditEvent action names.

**AC-0021-069.** Historical initiator provenance se preserva sin confundirla con current authority o AuditEvent.

**AC-0021-070.** Future Phase 3 composition debe validar uno o más Clients reales del same tenant antes de declarar onboarding completo.

**AC-0021-071.** Future client assignment debe preservar RF-016.

**AC-0021-072.** ADR-0021 no modifica ADR-0020.

**AC-0021-073.** No se genera SQL, migration ni RLS executable.

**AC-0021-074.** No se modifica Supabase.

**AC-0021-075.** No se modifica repositorio.

**AC-0021-076.** No se usa Codex.

**AC-0021-077.** No se hace staging, commit ni push.

**AC-0021-078.** No se genera ni determina TASK-020.

**AC-0021-079.** No se cierra Fase 2.

**AC-0021-080.** No se inicia Fase 3.

---

## 39. Definition of Done de la specification

ADR-0021 canonical candidate está completo para `ADR-0021 CANONICALIZATION REVIEW` cuando:

- [ ] identidad/título/status son correctos;
- [ ] se conserva el estado de Fase 2/Fase 3;
- [ ] RF-013..RF-017 se preservan sin reinterpretación;
- [ ] RF-015 mandatory y Client Phase 3 quedan explícitos;
- [ ] la separación first-admin/later-user queda explícita;
- [ ] se decide conceptualmente dedicated `LaterUserEnrollmentIntent`;
- [ ] se decide su ownership tenant-owned y su RLS boundary;
- [ ] se fijan tenant/email/role/purpose bindings e inmutabilidad;
- [ ] se define actor authorization current-state;
- [ ] se define challenge issue/resend/verify/consume composition;
- [ ] se define idempotency/concurrency/safe retry;
- [ ] se preserva SessionGrant/E2 de ADR-0019;
- [ ] se preserva privileged Auth boundary;
- [ ] se documenta prevention of public bypass;
- [ ] se documenta duplicate/incompatible identity handling;
- [ ] se fija el pre-Client terminal boundary;
- [ ] se preserva que Auth session no es tenant authorization;
- [ ] se excluyen `PlatformUser`/membership/profile/USER_CREATED timing no resueltos;
- [ ] se documenta relación con futura RF-015/Phase 3;
- [ ] se documentan amenazas, fallos y recovery;
- [ ] se documentan AuditEvent implications;
- [ ] se conserva online-only;
- [ ] se evalúan alternativas A..E sin score arbitrario;
- [ ] se documentan consecuencias e impactos;
- [ ] se documentan testing implications;
- [ ] no existe implementación ni mutación física;
- [x] `ADR-0021 SPEC REVIEW = APPROVED` y permanece un Gate separado;
- [x] `ADR-0021 HUMAN APPROVAL = APPROVED` y permanece un Gate separado;
- [x] `ADR-0021 APPROVED ARTIFACT GENERATION = PASS` y permanece un step separado;
- [x] `ADR-0021 APPROVED ARTIFACT REVIEW = APPROVED` y permanece un Gate separado;
- [x] `ADR-0021 CANONICALIZATION AUTHORIZATION = APPROVED` y permanece un Gate explícito separado;
- [x] `ADR-0021 CANONICALIZATION = PASS` y permanece un step separado;
- [ ] `ADR-0021 CANONICALIZATION REVIEW = PENDING` y permanece un Gate separado;
- [ ] `ADR-0021 REPOSITORY INCORPORATION AUTHORIZATION` permanece un Gate explícito separado;
- [ ] `ADR-0021 REPOSITORY INCORPORATION` permanece un step separado;
- [ ] `ADR-0021 REPOSITORY INCORPORATION REVIEW` permanece un Gate separado;
- [ ] `ADR-0021 STAGING AUTHORIZATION` permanece un Gate explícito separado;
- [ ] `ADR-0021 STAGING` permanece un step separado;
- [ ] `ADR-0021 STAGING REVIEW` permanece un Gate separado;
- [ ] `ADR-0021 COMMIT AUTHORIZATION` permanece un Gate explícito separado;
- [ ] `ADR-0021 COMMIT` permanece un step separado;
- [ ] `ADR-0021 COMMIT REVIEW` permanece un Gate separado;
- [ ] `ADR-0021 PUSH AUTHORIZATION` permanece un Gate explícito separado;
- [ ] `ADR-0021 PUSH` permanece un step separado;
- [ ] `ADR-0021 PUSH REVIEW / REMOTE VERIFICATION` permanece un Gate separado;
- [ ] `NEXT-TASK DETERMINATION BY REVISOR CENTRAL` permanece un Gate separado;
- [ ] `next Gate = ADR-0021 CANONICALIZATION REVIEW`.

`F-0021-CANON-001 = RESOLVED`.

Esta checklist no autoriza, ejecuta, aprueba o satisface automáticamente ningún Gate posterior; `ADR-0021 CANONICALIZATION = PASS` no implica `ADR-0021 CANONICALIZATION REVIEW = APPROVED`.

---


## 40. Governance lifecycle

Estado actual del canonical candidate generado:

```text
ADR-0021 MINIMAL SPECIFICATION CORRECTION =
PASS

ADR-0021 SPEC REVIEW =
APPROVED

ADR-0021 SPEC RE-REVIEW =
APPROVED

F-0021-SPEC-001 =
RESOLVED

ADR-0021 HUMAN APPROVAL =
APPROVED

ADR-0021 architecture decision =
HUMAN APPROVED

ADR-0021 APPROVED ARTIFACT GENERATION =
PASS

ADR-0021 APPROVED ARTIFACT REVIEW =
APPROVED

ADR-0021 CANONICALIZATION AUTHORIZATION =
APPROVED

ADR-0021 CANONICALIZATION =
PASS

ADR-0021 canonicalized =
YES

ADR-0021 CANONICALIZATION REVIEW =
PENDING

ADR-0021 REPOSITORY INCORPORATION AUTHORIZATION =
NOT AUTHORIZED

ADR-0021 REPOSITORY INCORPORATION =
NOT PERFORMED

ADR-0021 REPOSITORY INCORPORATION REVIEW =
NOT AUTHORIZED / NOT PERFORMED

implementation =
NOT AUTHORIZED

Codex =
NOT AUTHORIZED

repository mutation =
NO

Supabase mutation =
NO

staging / commit / push =
NO / NO / NO

TASK-020 =
NOT DETERMINED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED
```

La secuencia de gobernanza obligatoria es exactamente:

```text
ADR-0021 SPEC REVIEW
→ ADR-0021 HUMAN APPROVAL
→ ADR-0021 APPROVED ARTIFACT GENERATION
→ ADR-0021 APPROVED ARTIFACT REVIEW
→ ADR-0021 CANONICALIZATION AUTHORIZATION
→ ADR-0021 CANONICALIZATION
→ ADR-0021 CANONICALIZATION REVIEW
→ ADR-0021 REPOSITORY INCORPORATION AUTHORIZATION
→ ADR-0021 REPOSITORY INCORPORATION
→ ADR-0021 REPOSITORY INCORPORATION REVIEW
→ ADR-0021 STAGING AUTHORIZATION
→ ADR-0021 STAGING
→ ADR-0021 STAGING REVIEW
→ ADR-0021 COMMIT AUTHORIZATION
→ ADR-0021 COMMIT
→ ADR-0021 COMMIT REVIEW
→ ADR-0021 PUSH AUTHORIZATION
→ ADR-0021 PUSH
→ ADR-0021 PUSH REVIEW / REMOTE VERIFICATION
→ NEXT-TASK DETERMINATION BY REVISOR CENTRAL
```

Cada elemento de esa secuencia es un Gate o step separado conforme a su naturaleza. Ningún Gate o step implica, autoriza, ejecuta, aprueba ni satisface automáticamente el siguiente.

Debe preservarse explícitamente:

```text
SPEC REVIEW approval
!= HUMAN APPROVAL

HUMAN APPROVAL
!= APPROVED ARTIFACT GENERATION

APPROVED ARTIFACT GENERATION
!= APPROVED ARTIFACT REVIEW

APPROVED ARTIFACT REVIEW
!= CANONICALIZATION AUTHORIZATION

CANONICALIZATION AUTHORIZATION
!= CANONICALIZATION

CANONICALIZATION
!= CANONICALIZATION REVIEW

CANONICALIZATION REVIEW
!= REPOSITORY INCORPORATION AUTHORIZATION

REPOSITORY INCORPORATION AUTHORIZATION
!= REPOSITORY INCORPORATION

REPOSITORY INCORPORATION
!= REPOSITORY INCORPORATION REVIEW

REPOSITORY INCORPORATION REVIEW
!= STAGING AUTHORIZATION

STAGING AUTHORIZATION
!= STAGING

STAGING
!= STAGING REVIEW

STAGING REVIEW
!= COMMIT AUTHORIZATION

COMMIT AUTHORIZATION
!= COMMIT

COMMIT
!= COMMIT REVIEW

COMMIT REVIEW
!= PUSH AUTHORIZATION

PUSH AUTHORIZATION
!= PUSH

PUSH
!= PUSH REVIEW / REMOTE VERIFICATION

PUSH REVIEW / REMOTE VERIFICATION
!= NEXT-TASK DETERMINATION
```

Debe preservarse además:

```text
repository incorporation
!= Git staging

Git staging
!= Git commit

Git commit
!= remote persistence

local commit
!= push

push attempt
!= remote verification
```

La persistencia remota sólo puede considerarse demostrada después de `ADR-0021 PUSH REVIEW / REMOTE VERIFICATION`.

Este lifecycle no redefine el significado vigente de `ACCEPTED`. Una futura aprobación humana puede resolver semánticamente la decisión arquitectónica conforme al lifecycle vigente, pero debe preservarse:

```text
ADR accepted semantically
!=
canonicalized

ADR accepted semantically
!=
incorporated into repository

ADR accepted semantically
!=
next TASK determined
```

La siguiente TASK no puede determinarse automáticamente por `HUMAN APPROVAL`, `APPROVED ARTIFACT GENERATION`, `CANONICALIZATION`, `REPOSITORY INCORPORATION`, `STAGING`, `COMMIT`, `PUSH` ni `PUSH REVIEW / REMOTE VERIFICATION`. Después de completar la verificación remota debe existir un Gate separado de `NEXT-TASK DETERMINATION BY REVISOR CENTRAL`.

El siguiente Gate de ADR-0021 después de este step de canonicalization es exclusivamente:

```text
ADR-0021 CANONICALIZATION REVIEW

DESTINO =
REVISOR CENTRAL
```

---

## 41. Resultado y siguiente Gate

```text
ADR-0021 CANONICALIZATION =
PASS

ADR-0021 canonicalized =
YES

ADR-0021 CANONICALIZATION REVIEW =
PENDING

repository incorporation =
NOT AUTHORIZED

implementation =
NOT AUTHORIZED

TASK-020 =
NOT DETERMINED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 3 =
NOT STARTED
```

Este resultado no autoriza ni satisface automáticamente ningún paso Git posterior. Debe preservarse:

```text
ADR-0021 REPOSITORY INCORPORATION REVIEW
!= ADR-0021 STAGING AUTHORIZATION

ADR-0021 STAGING AUTHORIZATION
→ ADR-0021 STAGING
→ ADR-0021 STAGING REVIEW
→ ADR-0021 COMMIT AUTHORIZATION
→ ADR-0021 COMMIT
→ ADR-0021 COMMIT REVIEW
→ ADR-0021 PUSH AUTHORIZATION
→ ADR-0021 PUSH
→ ADR-0021 PUSH REVIEW / REMOTE VERIFICATION
→ NEXT-TASK DETERMINATION BY REVISOR CENTRAL
```

Cada elemento de esa secuencia requiere su autorización, ejecución o revisión separada, según corresponda. Un push intentado no demuestra persistencia remota; sólo `ADR-0021 PUSH REVIEW / REMOTE VERIFICATION` puede demostrarla, y aun entonces no determina automáticamente la siguiente TASK.

Siguiente Gate exclusivamente:

```text
ADR-0021 CANONICALIZATION REVIEW

DESTINO =
REVISOR CENTRAL
```

**STOP.**
