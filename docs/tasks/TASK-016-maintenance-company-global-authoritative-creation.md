# TASK-016 — Creación global autoritativa mínima de MaintenanceCompany por SUPER_ADMIN

## 0. Identidad del artefacto

```text
TASK ID =
TASK-016

TITLE =
Creación global autoritativa mínima de MaintenanceCompany por SUPER_ADMIN

DOCUMENT TYPE =
IMPLEMENTATION SPECIFICATION

SPECIFICATION STATE =
APPROVED FOR IMPLEMENTATION

IMPLEMENTATION AUTHORIZATION =
NO

CODEX AUTHORIZED =
NO

REPOSITORY MUTATION =
NO

SUPABASE CLOUD MUTATION =
NO
```

Este documento define un único incremento PR-sized de Fase 2.

Su generación consume una determinación humana previa ya aprobada, pero no constituye por sí misma aprobación de la especificación, autorización de implementación, autorización de Codex, autorización de mutación local o remota, autorización Git ni autorización sobre Staging o Production.

Debe preservarse expresamente:

```text
TASK-016 DETERMINATION =
APPROVED

TASK-016 SPECIFICATION =
APPROVED FOR IMPLEMENTATION

TASK-016 IMPLEMENTATION =
NOT AUTHORIZED

Phase 2 =
INICIADA / NOT DONE

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED

TASK-017 =
NOT DETERMINED / NOT GENERATED / NOT STARTED
```

---

# 1. Objetivo único

TASK-016 debe hacer implementable, después de todos los Gates humanos posteriores, exclusivamente la capacidad funcional mínima:

```text
current authoritative SUPER_ADMIN
→ create MaintenanceCompany
→ MaintenanceCompany exists as an active tenant immediately
```

Esta capacidad corresponde únicamente a:

```text
RF-001
+
RF-002
+
FL-01 steps 1–2
```

No incluye ningún paso posterior del onboarding.

El resultado funcional máximo permitido es:

```text
un SUPER_ADMIN actualmente autorizado
puede crear exactamente una nueva MaintenanceCompany
mediante una intención de creación válida
con retry seguro e idempotente
sin crear todavía su primer COMPANY_ADMIN
```

---

# 2. Autoridad normativa y fuentes obligatorias

La futura revisión e implementación debe leer íntegramente, como mínimo, las versiones canónicas vigentes de:

## 2.1 Producto

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/04-offline-sync-strategy.md`
- `docs/product/09-subscription-payments-spec.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md`

## 2.2 Arquitectura

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`
- `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`

## 2.3 Incrementos y correcciones relevantes

- TASK-009 — identity/tenant foundation
- TASK-010 — AuditEvent foundation
- TASK-011 — Auth SSR lifecycle foundation
- TASK-012 — authoritative online authorization foundation
- TASK-013 — VerificationChallenge / SessionGrant physical foundation
- TASK-014 — SUPER_ADMIN global identity/authorization foundation
- TASK-015 — CompanyMembership lifecycle + AuditEvent atomic
- CORR de cierre documental posteriores hasta CORR-025 inclusive

La conversación histórica no sustituye el canon del repositorio.

Si una fuente canónica posterior contradice materialmente este documento:

```text
TASK-016 IMPLEMENTATION =
BLOCKER — CANONICAL CONTRADICTION REQUIRES HUMAN REVIEW
```

No se permite silent repair.

---

# 3. Estado previo que debe preservarse

La specification consume el estado humano aprobado:

```text
Phase 0 = COMPLETED
Phase 1 = COMPLETED
Phase 2 = INICIADA / NOT DONE
Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED
Phase 3 = NOT STARTED

TASK-013 = DONE / CLOSED
TASK-014 = DONE / CLOSED
TASK-015 = DONE / CLOSED
CORR-025 = DONE / CLOSED

TASK-016 DETERMINATION = APPROVED
TASK-016 implementation = NOT AUTHORIZED
```

Foundations relevantes ya existentes:

```text
MaintenanceCompany physical foundation = YES
PlatformUser physical foundation = YES
Auth subject → PlatformUser mapping = YES
CompanyMembership physical foundation = YES
AuditEvent physical foundation = YES
Auth SSR lifecycle foundation = YES
authoritative tenant resolver = YES
VerificationChallenge / SessionGrant security foundation = YES
global SUPER_ADMIN authority foundation = YES
CompanyMembership lifecycle operations = YES
```

Capacidades que siguen incompletas y no pueden sobredeclararse por TASK-016:

```text
Auth funcional completo = NO
onboarding funcional completo = NO
alta completa del primer COMPANY_ADMIN = NO
alta funcional completa de usuarios tenant = NO
Client = NO
UserClientAccess completo = NO
SupportAccessGrant completo = NO
route authorization completa = NO
resource authorization completa = NO
Application authorization completa = NO
auditoría funcional completa = NO
Phase 2 completa = NO
Phase 3 iniciada = NO
```

---

# 4. Decisión humana OPTION A consumida

TASK-016 consume exclusivamente:

```text
PRE-TASK-016 GLOBAL AUTHORITY BOOTSTRAP DECISION =
APPROVED — OPTION A
```

Semántica exacta:

```text
un SUPER_ADMIN pre-provisionado
puede existir como precondición operacional
```

pero:

```text
bootstrap funcional de SUPER_ADMIN =
NO

grant SUPER_ADMIN =
NO

revoke SUPER_ADMIN =
NO

admin SUPER_ADMIN =
NO

procedimiento técnico de pre-provisioning =
NOT DEFINED / NOT AUTHORIZED BY TASK-016
```

TASK-016 no crea, selecciona, promociona, repara ni modifica la identidad `SUPER_ADMIN`.

La futura implementación sólo puede comenzar si el actor requerido ya puede demostrar, mediante la foundation vigente de TASK-014, autoridad global actual y coherente.

Si esa precondición no está disponible:

```text
TASK-016 IMPLEMENTATION =
BLOCKER — REQUIRED PRE-PROVISIONED SUPER_ADMIN AUTHORITY UNAVAILABLE
```

No se permite implementar un bootstrap como reparación.

---

# 5. Mapeo exacto a requisitos de producto

## 5.1 Incluidos

TASK-016 materializa exclusivamente:

```text
RF-001
SUPER_ADMIN DEBE poder crear una empresa de mantenimiento.

RF-002
Una empresa recién creada DEBE quedar activa inmediatamente.
```

Y únicamente:

```text
FL-01 step 1 =
SUPER_ADMIN crea la empresa.

FL-01 step 2 =
La empresa queda activa.
```

## 5.2 Excluidos

El límite termina antes de RF-003.

Permanecen fuera de TASK-016:

```text
RF-003..RF-012
```

Por tanto TASK-016 no implementa:

- email del primer `COMPANY_ADMIN`;
- envío de código;
- reenvío;
- VerificationChallenge funcional del onboarding;
- verificación del código;
- consumo de challenge como caso de uso de onboarding;
- Auth user creation para el primer admin;
- `PlatformUser` creation para el primer admin;
- `CompanyMembership` creation para el primer admin;
- perfil del primer admin;
- login funcional del primer admin;
- `USER_CREATED` AuditEvent del primer admin;
- email delivery;
- UI completa de onboarding;
- transición a FL-01 step 3 o posterior.

Debe permanecer:

```text
TASK-016 DONE
!=
FL-01 DONE
```

---

# 6. Dominio

## 6.1 `MaintenanceCompany`

TASK-016 conserva:

```text
MaintenanceCompany = tenant
```

y:

```text
MaintenanceCompany
= empresa de mantenimiento usuaria del SaaS
= frontera primaria de tenancy
```

La creación en TASK-016 materializa una nueva identidad tenant.

No crea todavía datos operativos del tenant.

## 6.2 “Activa inmediatamente”

El canon establece conceptualmente:

```text
created
→ active immediately
```

La foundation física vigente de `public.maintenance_companies` materializa como mínimo la identidad mediante `id`.

TASK-016 NO inventa:

```text
status
is_active
enabled
suspended_at
subscription_status
commercial_state
```

ni otra state machine de `MaintenanceCompany`.

Para este incremento:

```text
created successfully
→ tenant identity exists
→ no inactive creation state is introduced
→ RF-002 satisfied at this slice boundary
```

La futura suspensión/reactivación comercial pertenece a capacidades posteriores y no se modela aquí.

TASK-016 tampoco resuelve decisiones comerciales abiertas del bounded context Subscription & Payments.

Debe preservarse expresamente:

```text
RF-002 active immediately
!=
promotional/commercial anchor selected

TASK-016
DOES NOT RESOLVE PAY-OPEN-001

TASK-016
DOES NOT RESOLVE PAY-OPEN-008

TASK-016
DOES NOT define created_at / activated_at
as the commercial promotional anchor

TASK-016
DOES NOT create Subscription
or promotional entitlement representation
```

Por tanto, satisfacer RF-002 en este slice no selecciona el timestamp/ancla contractual del año promocional ni determina la representación física de `Subscription` o del promotional entitlement.

## 6.3 Identidad del tenant

El `MaintenanceCompany.id`:

- debe seguir siendo UUID;
- debe generarse dentro de una frontera confiable;
- no debe ser seleccionado por el browser como autoridad;
- no concede acceso por sí mismo;
- no equivale a `Client`;
- no equivale a membership;
- no equivale a autorización tenant.

## 6.4 Ownership

TASK-016 crea sólo el registro global del tenant.

No crea:

- `Client`;
- `Location`;
- `Equipment`;
- `CompanyMembership`;
- `UserClientAccess`;
- `SupportAccessGrant`;
- datos operativos tenant-owned adicionales.

## 6.5 Agregado y atomicidad

No se convierte:

```text
MaintenanceCompany
```

en un agregado gigante.

La transacción TASK-016 abarca únicamente:

```text
current global authority verification
+
idempotency/retry correlation
+
MaintenanceCompany creation
```

No incluye onboarding del primer administrador.

---

# 7. Modelo de autoridad obligatorio

## 7.1 Actor permitido

Único actor funcional permitido:

```text
current authoritative SUPER_ADMIN
```

## 7.2 Fuente positiva de autoridad

Debe preservarse TASK-014:

```text
validated auth.uid()
→ PlatformUser
→ current platform_users.is_super_admin
→ any CompanyMembership existence
→ global classification
```

Autoridad positiva únicamente cuando:

```text
PlatformUser.is_super_admin = true
AND
no CompanyMembership exists for that PlatformUser
```

## 7.3 Estados denegados

Debe denegarse:

```text
missing auth.uid()
missing PlatformUser
ambiguous identity mapping
is_super_admin = false
is_super_admin = true + enabled CompanyMembership exists
is_super_admin = true + disabled CompanyMembership exists
authority lookup failure
unvalidated Auth identity
stale client claim without matching DB authority
```

## 7.4 Prohibiciones

Nunca constituye autoridad:

- claim JWT `SUPER_ADMIN`;
- Auth metadata;
- cookie no validada;
- estado React;
- query/body/header;
- `platform_user_id` enviado por caller;
- `maintenance_company_id` enviado por caller;
- ausencia de membership;
- una secret key;
- `service-role`;
- estar “server-side” por sí mismo.

Debe permanecer:

```text
authenticated != authorized
```

y:

```text
current authoritative PostgreSQL state
>
stale token/client state
```

---

# 8. Frontera funcional seleccionada

## 8.1 Alternativas

### A. INSERT directo desde browser/Data API

```text
authenticated → INSERT maintenance_companies
```

**RECHAZADA.**

Razones:

- convertiría autenticación en autorización;
- requeriría una policy de creación global demasiado amplia o difícil de acotar;
- trasladaría una mutación sensible a una superficie genérica;
- dificultaría encapsular idempotencia y revalidación global.

### B. Generic server client privilegiado

```text
request
→ generic service-role/admin client
→ INSERT
```

**RECHAZADA.**

Razones:

- contradice mínimo privilegio;
- introduce una superficie reutilizable transversal;
- una credencial privilegiada no demuestra autoridad;
- aumenta blast radius;
- no es necesaria.

### C. PostgreSQL function/RPC purpose-specific

**SELECCIONADA.**

Debe encapsular en una única frontera:

```text
auth.uid()
→ authoritative global authority check
→ idempotency correlation
→ create MaintenanceCompany if not already created for same operation
→ return minimal outcome
```

La función debe ejecutarse desde la application boundary mediante cliente Supabase caller-scoped.

## 8.2 Razón de selección

La frontera purpose-specific permite:

- conservar el Auth subject real;
- revalidar autoridad actual dentro de PostgreSQL;
- evitar `INSERT` ordinario para `authenticated`;
- impedir que `service-role` sea writer normal;
- resolver retry/idempotencia con estado autoritativo;
- minimizar inputs;
- hacer testable el hardening;
- preservar RLS tenant sin bypass global ordinario.

---

# 9. Función/RPC propuesta

Nombre físico propuesto para revisión:

```text
public.create_maintenance_company
```

Un nombre equivalente puede aceptarse sólo si el preflight real demuestra una convención física canónica distinta.

Un cambio semántico requiere revisión humana.

## 9.1 Security mode

Contrato:

```text
purpose-specific = YES
SECURITY DEFINER = YES
identity anchor = auth.uid() only
caller-scoped Supabase client = YES
service-role ordinary caller = NO
generic privileged server client = NO
dynamic SQL = NONE expected
```

## 9.2 Input máximo permitido

Único input funcional requerido:

```text
creation_operation_id
```

Tipo conceptual:

```text
UUID
```

No se acepta:

- actor ID;
- Auth subject ID;
- `PlatformUser` ID;
- `maintenance_company_id`;
- `is_super_admin`;
- tenant role;
- membership ID;
- client ID;
- company name;
- company status;
- subscription state;
- first admin email;
- AuditEvent payload;
- timestamps autoritativos.

## 9.3 Naturaleza de `creation_operation_id`

`creation_operation_id`:

- identifica una intención lógica de creación;
- no es autoridad;
- no es secreto;
- no es tenant ID;
- no concede acceso;
- debe ser estable en retries del mismo intento;
- debe ser nuevo para una intención distinta;
- se usa exclusivamente para reconciliar reintentos;
- puede originarse en una capa no confiable porque la autorización se reconstruye server-side;
- su conocimiento por sí solo no permite crear ni leer un tenant sin autoridad `SUPER_ADMIN`.

Debe preservarse el principio de ADR-0005 consumido por esta capability purpose-specific:

```text
same creation_operation_id
!=
automatic authorization
```

En cada request y retry, la autoridad `SUPER_ADMIN` actual y autoritativa DEBE revalidarse antes de poder devolver `CREATED` o `ALREADY_CREATED`.

## 9.4 Output conceptual

Resultado mínimo equivalente a:

```text
outcome =
CREATED
| ALREADY_CREATED
| DENIED

changed =
true | false

maintenance_company_id =
UUID | null

reason =
bounded non-sensitive reason
```

Reglas:

```text
CREATED
→ changed = true
→ exactly one MaintenanceCompany now corresponds to creation_operation_id

ALREADY_CREATED
→ changed = false
→ same previously created MaintenanceCompany is returned

DENIED
→ changed = false
→ no MaintenanceCompany created
```

Un error interno/DB no debe convertirse falsamente en `DENIED` si la aplicación no puede distinguir con seguridad un resultado no confirmado.

---

# 10. Decisión de idempotencia y retry

## 10.1 Problema

Una creación no es naturalmente idempotente.

Caso crítico:

```text
request
→ DB creates MaintenanceCompany
→ response lost
→ caller retries
```

Un retry ciego no puede crear otra empresa.

## 10.2 Decisión seleccionada

Se adopta una correlación purpose-specific persistida en la propia identidad tenant:

```text
public.maintenance_companies.creation_operation_id
```

Contrato conceptual:

```text
type = UUID
existing legacy/foundation rows = nullable allowed
rows created functionally by TASK-016 = non-null by use-case invariant
uniqueness for non-null values = REQUIRED
```

La futura migration debe materializar una restricción/índice equivalente que garantice:

```text
same non-null creation_operation_id
→ at most one MaintenanceCompany
```

No se crea una tabla genérica de idempotencia.

No se crea un framework global de commands.

## 10.3 Por qué nullable

Filas preexistentes de `maintenance_companies` pueden haber sido creadas como fixtures/foundation antes de existir TASK-016.

TASK-016 no debe:

- inventar una intención histórica;
- fabricar operation IDs históricos como si fueran requests reales;
- reescribir semánticamente datos previos;
- eliminar filas.

Por ello:

```text
pre-TASK-016 rows
→ creation_operation_id may remain NULL
```

Mientras:

```text
new functional TASK-016 creation
→ creation_operation_id must be present
```

## 10.4 Tenant ID

`maintenance_company_id` se genera dentro de la frontera confiable usando el mecanismo UUID ya aprobado/disponible en el repositorio real.

Debe permanecer:

```text
caller-selected maintenance_company_id = NO
```

## 10.5 Retry

Mismo operation ID:

```text
first valid call
→ create row
→ CREATED
```

Retry posterior con autoridad global vigente:

```text
same creation_operation_id
+
current authoritative SUPER_ADMIN authority = valid
→ locate same row
→ ALREADY_CREATED
→ same maintenance_company_id
→ no second row
```

Si la autoridad vigente ya no es válida:

```text
same creation_operation_id
+
current authoritative SUPER_ADMIN authority = invalid
→ DENY
→ no ALREADY_CREATED
→ no new row
```

La fila previamente creada no se elimina ni se duplica por esa denegación.

## 10.6 Response lost

Si la creación confirmó pero la respuesta se perdió, el retry sólo reconcilia después de revalidar con éxito la autoridad actual:

```text
retry same creation_operation_id
+
current authoritative SUPER_ADMIN authority = valid
→ reconciles
→ same company id
```

## 10.7 Distinct intents

Dos operation IDs distintos representan dos intenciones distintas.

Si ambas llamadas están autorizadas:

```text
op A != op B
→ may create two distinct MaintenanceCompany rows
```

TASK-016 no inventa deduplicación por nombre, email, dirección u otros atributos que no pertenecen al slice.

## 10.8 Reuse malicioso

Reutilizar un `creation_operation_id` ya confirmado:

```text
→ cannot create a second company
```

Conocer un operation ID:

```text
!= authority
```

Un caller no autorizado debe ser denegado antes de obtener capacidad funcional de creación.

## 10.9 No nuevo ADR

Esta decisión:

- es purpose-specific;
- queda acotada a creación de tenant;
- no define una plataforma genérica de idempotencia;
- no modifica la arquitectura modular;
- no modifica ADR-0002/0003;
- no se adopta como patrón universal.

Por ello:

```text
new ADR required = NO
```

Si la implementación real exigiera una infraestructura genérica/cross-cutting:

```text
BLOCKER — ARCHITECTURE REVIEW REQUIRED
```

---

# 11. Orden autoritativo de la operación

Dentro de la frontera DB, la secuencia conceptual debe ser:

```text
1. require auth.uid()
2. resolve Auth subject → PlatformUser
3. resolve current is_super_admin
4. determine whether any CompanyMembership exists
5. reject unresolved / non-global / inconsistent identity
6. validate creation_operation_id shape
7. check authoritative existing row for creation_operation_id
8. if already present → ALREADY_CREATED
9. otherwise create exactly one MaintenanceCompany
10. persist the same creation_operation_id on that row
11. return CREATED with the generated MaintenanceCompany.id
12. commit once
```

Ninguna decisión positiva de autoridad puede tomarse desde datos del frontend.

En particular:

```text
same creation_operation_id
→ never bypasses steps 1–6
→ ALREADY_CREATED only after current authority remains valid
```

---

# 12. TOCTOU y revalidación

## 12.1 Regla

La application layer puede realizar validaciones sintácticas preliminares, pero la autorización final ocurre dentro de la mutation boundary.

Debe permanecer:

```text
pre-check in application
!= final authority
```

## 12.2 `PlatformUser`

La function debe resolver el `PlatformUser` del `auth.uid()` vigente dentro de la operación.

No acepta un actor seleccionado por caller.

## 12.3 Estado global

Debe leer:

```text
platform_users.is_super_admin
```

vigente.

No utiliza:

- claim;
- cache;
- metadata;
- valor previamente resuelto en otra request.

## 12.4 Coexistencia con membership

Debe considerar cualquier `CompanyMembership`, enabled o disabled, exactamente como TASK-014.

```text
is_super_admin = true
+
any CompanyMembership exists
→ INCONSISTENT
→ DENY
```

No debe usar la visibilidad RLS ordinaria como prueba negativa.

## 12.5 Coordinación de actor

La implementación debe mantener una estrategia de lectura/bloqueo coherente con el schema real para impedir que la decisión se base deliberadamente en un actor distinto al observado en la transacción.

No se autoriza inventar un lock global de plataforma.

Si el repositorio real demuestra que garantizar autoridad consistente requiere modificar el modelo de authority de TASK-014:

```text
BLOCKER
```

---

# 13. Concurrencia

## 13.1 Mismo operation ID

Dos calls concurrentes con:

```text
same creation_operation_id
```

deben producir:

```text
exactly one MaintenanceCompany
```

Resultado esperado:

```text
one call may report CREATED
the other must reconcile to ALREADY_CREATED
both resolve the same maintenance_company_id
```

No se acepta:

```text
two rows
```

## 13.2 Operation IDs distintos

Dos calls concurrentes con operation IDs distintos son dos intents distintos.

No se introduce una serialización global de todas las creaciones.

## 13.3 Race de autoridad

Cada call debe verificar autoridad actual dentro de su propia transacción.

No se reutiliza un `AUTHORIZED_GLOBAL_SUPER_ADMIN` cacheado entre requests.

## 13.4 Unique conflict

Una colisión de la constraint de idempotencia para el mismo operation ID debe reconciliarse como el mismo intento, no convertirse en una segunda creación.

Una violación inesperada distinta del caso explícitamente reconciliable:

```text
→ fail closed
```

---

# 14. Atomicidad

La propiedad requerida es:

```text
MaintenanceCompany row created
IFF
creation_operation_id correlation is committed on that same row
```

No puede existir success confirmado con:

```text
company created
+
idempotency correlation missing
```

No puede existir:

```text
idempotency correlation committed elsewhere
+
company missing
```

porque la correlación seleccionada vive en la misma fila.

No hay participante externo.

No hay:

- Auth Admin call;
- email provider;
- webhook;
- distributed transaction;
- saga;
- two-phase commit.

---

# 15. RLS y aislamiento multiempresa

## 15.1 RLS sigue siendo obligatoria

TASK-016 no debilita RLS tenant.

## 15.2 `maintenance_companies`

La ordinary authenticated surface vigente debe continuar sin una capacidad general de:

```text
INSERT
UPDATE
DELETE
```

para crear tenants.

TASK-016 NO debe añadir una policy equivalente a:

```text
if is_super_admin then allow generic INSERT/UPDATE/DELETE
```

## 15.3 Creación mediante boundary controlada

La función purpose-specific puede disponer del privilegio técnico mínimo para insertar exclusivamente la fila definida por su contrato.

Debe reconstruir internamente:

- actor;
- `PlatformUser`;
- global authority;
- membership-existence inconsistency;
- idempotency state.

## 15.4 SUPER_ADMIN no obtiene tenant bypass

Después de crear el tenant:

```text
SUPER_ADMIN
!= tenant member
```

y:

```text
SUPER_ADMIN
!= ordinary access to newly created tenant data
```

No se crea `CompanyMembership`.

No se crea `SupportAccessGrant`.

No se crea una policy para que `SUPER_ADMIN` lea o escriba datos tenant operativos.

## 15.5 Tenant isolation

La creación de una nueva identidad tenant no puede:

- alterar filas de otro tenant;
- conceder acceso a tenants existentes;
- mezclar ownership;
- aceptar un tenant ID del caller como autoridad;
- crear relaciones cross-tenant.

---

# 16. Privilegios y hardening

La function/RPC debe exigir:

```text
PUBLIC EXECUTE = NO
anon EXECUTE = NO
authenticated EXECUTE = minimum required on exact signature
```

`authenticated EXECUTE`:

```text
!= permission to create a company without global authority
```

porque la function debe revalidar `SUPER_ADMIN` internamente.

Hardening obligatorio:

- fixed/safe `search_path`;
- referencias schema-qualified/no ambiguas;
- ausencia de dynamic SQL salvo nueva necesidad revisada;
- no caller-selected actor;
- no caller-selected tenant ID;
- no arbitrary table operation;
- no generic privileged helper;
- no overload inesperado con superficie más amplia;
- fail-closed ante estado imposible.

No deben concederse nuevos table write privileges a `authenticated` como sustituto de la function.

---

# 17. `service-role` y Admin boundaries

TASK-016:

```text
service-role ordinary request path = NO
generic secret-key Supabase client = NO
Auth Admin = NO
```

No se necesita Supabase Auth Admin porque TASK-016 no crea usuarios.

No se necesita secret key adicional.

No se modifica ADR-0019.

No se modifica:

- VerificationChallenge;
- SessionGrant;
- technical password bridge;
- Custom Access Token Hook;
- Auth configuration.

Si implementation concluye que sólo puede realizar el caso de uso mediante generic `service-role` request client:

```text
BLOCKER
```

---

# 18. Application/use-case boundary

Debe existir una boundary mínima en el módulo apropiado del monolito Next.js conforme a ADR-0001.

Responsabilidades:

1. aceptar intención tipada de creación;
2. validar sintácticamente `creation_operation_id`;
3. utilizar Supabase caller-scoped;
4. invocar el RPC purpose-specific;
5. mapear resultado físico a outcome de aplicación;
6. no asumir autoridad antes de la DB;
7. no exponer secretos;
8. preservar TypeScript estricto.

No debe:

- insertar directamente la tabla;
- usar service-role;
- aceptar `is_super_admin`;
- aceptar actor ID;
- aceptar tenant ID;
- duplicar reglas de autoridad como fuente final;
- implementar un generic repository privilegiado;
- introducir una command bus genérica.

---

# 19. UI / UX

## 19.1 Alcance

```text
new broad onboarding UI = OUT OF SCOPE
```

TASK-016 puede cerrarse con capability server-side verificable.

No se requiere crear una página final de producto.

## 19.2 Contrato para UI futura

Cualquier UI posterior que consuma esta capability debe:

- mantener un `creation_operation_id` estable durante retries del mismo submit lógico;
- no generar un operation ID nuevo automáticamente tras timeout ambiguo;
- no tratar un spinner, route state o cache como confirmación;
- ante respuesta perdida, reintentar/reconciliar antes de ofrecer crear otra empresa;
- no presentar al usuario un “primer admin creado”;
- no pedir todavía email del primer admin como parte de TASK-016;
- no asumir que `SUPER_ADMIN` adquirió acceso operativo al tenant creado.

## 19.3 Resultado visible mínimo

Si una superficie de prueba o interna existe, sólo puede distinguir conceptualmente:

```text
created
already created / reconciled
denied
not confirmed / error
```

Los textos exactos no pertenecen a esta specification.

---

# 20. Offline

```text
TASK-016 offline relevance =
NO
```

La creación de tenant es online-only.

No se crean:

- Dexie entities;
- IndexedDB replica;
- outbox;
- offline intent;
- background sync;
- Service Worker flow;
- optimistic local tenant creation;
- offline authorization lease.

Si no hay conectividad:

```text
operation cannot be newly confirmed
```

Si se pierde conectividad después del submit:

```text
same creation_operation_id
→ retry/reconcile after connectivity returns
```

---

# 21. AuditEvent

## 21.1 Contrato vigente

El catálogo físico actual de `AuditEvent` está acotado a acciones de usuario/membership ya aprobadas.

No existe una acción global aprobada para:

```text
MAINTENANCE_COMPANY_CREATED
```

## 21.2 Decisión TASK-016

TASK-016 no inventa un evento nuevo.

```text
MaintenanceCompany creation AuditEvent producer =
NO
```

La ausencia de ese evento:

```text
!= ausencia de idempotency
!= ausencia de authorization
!= permiso para modificar audit_events
```

## 21.3 `USER_CREATED`

```text
USER_CREATED
```

corresponde al alta de usuario, no a la creación del tenant.

Como TASK-016 no crea el primer `COMPANY_ADMIN`:

```text
USER_CREATED AuditEvent =
OUT OF SCOPE
```

## 21.4 Blocker

Si durante implementation aparece un requisito canónico posterior que exige auditar globalmente la creación de empresa:

```text
BLOCKER — AUDIT MODEL CHANGE REQUIRES HUMAN REVIEW
```

No ampliar el catálogo silenciosamente.

---

# 22. Failure model

Toda la capability es fail-closed.

## 22.1 Missing session / `auth.uid()`

```text
auth.uid() absent
→ DENY
→ no row
```

## 22.2 Missing PlatformUser

```text
Auth subject
+
no PlatformUser mapping
→ DENY
→ no row
```

## 22.3 `is_super_admin = false`

```text
→ DENY
→ no row
```

## 22.4 Dual global + membership identity

```text
is_super_admin = true
+
any CompanyMembership exists
→ INCONSISTENT
→ DENY
→ no row
```

## 22.5 Authority lookup error

```text
lookup error
→ fail closed
→ no confirmed creation
```

No fallback a claims.

## 22.6 Invalid operation ID

Malformed/invalid UUID:

```text
→ INVALID INPUT / DENY
→ no row
```

## 22.7 New operation success

```text
valid authority
+
new creation_operation_id
→ exactly one row
→ CREATED
```

## 22.8 Retry after success

```text
valid authority
+
existing creation_operation_id
→ same row
→ ALREADY_CREATED
```

## 22.9 Concurrent duplicate

```text
same op id
+
two requests
→ at most one insert
→ one logical company
```

## 22.10 DB error before commit

```text
→ rollback
→ no partial company
→ not confirmed
```

## 22.11 Response lost after commit

```text
company may already exist
→ caller must not assume failure
→ retry same op id
→ reconcile
```

## 22.12 Unexpected duplicate state

Si el schema físico presenta un estado imposible o ambiguo en el cual la correlación no identifica inequívocamente una sola empresa:

```text
→ fail closed
→ BLOCKER / investigation
```

No elegir una fila arbitraria.

---

# 23. Threat model

| Amenaza | Vector | Riesgo | Control TASK-016 | Resultado esperado |
|---|---|---|---|---|
| Fake SUPER_ADMIN claim | JWT/frontend afirma rol global | creación tenant no autorizada | DB `is_super_admin` actual + membership absence | DENY |
| Missing-membership inference | caller sin membership | escalamiento | ausencia nunca es evidencia positiva | DENY |
| Dual authority | `is_super_admin=true` + membership | estado ambiguo | fail-closed TASK-014 semantics | DENY |
| Stale authority | claim/cache antiguo | creación tras revocación | current DB lookup por call | DENY cuando DB false |
| Browser tampering | actor/company/status manipulados | confused deputy | inputs cerrados, actor desde `auth.uid()` | inputs no otorgan autoridad |
| Direct table insert | Data API contra `maintenance_companies` | bypass del caso de uso | no generic INSERT policy/grant | DENY |
| service-role misuse | generic privileged client | bypass transversal | prohibido | absent |
| PUBLIC RPC execution | anonymous/general public | invocation surface | revoke PUBLIC/anon | DENY |
| SECURITY DEFINER injection | search_path/object shadowing | privilege hijack | fixed path + qualified refs | no shadowing |
| Generic RPC expansion | parámetros arbitrarios | plataforma de administración privilegiada | purpose-specific one-operation contract | absent |
| Duplicate submit | doble click/retry | dos tenants | unique `creation_operation_id` | one tenant |
| Lost response | commit sin response | retry crea duplicado | stable operation ID | same tenant returned |
| Concurrent duplicate | two requests same op | race | DB uniqueness + reconciliation | one tenant |
| Operation ID probing | caller conoce UUID | metadata leak/create attempt | ID not authority; global auth first | no unauthorized create |
| Caller-selected tenant ID | manipula target tenant | overwrite/collision | tenant id server-generated | impossible by contract |
| Accidental tenant access | creator global intenta tenant data | cross-tenant disclosure | no membership/no bypass; RLS unchanged | DENY operational access |
| Audit schema expansion | se inventa global action | contrato no aprobado | no new AuditEvent action | absent |
| Auth Admin coupling | se crea user en mismo slice | scope creep/security | Auth provider mutations prohibited | absent |
| Secret leak | admin/service key en bundle/log | project compromise | no new secret dependency | absent |
| Global creation lock | lock global para toda plataforma | contention/DoS | no global serialization; unique per op | independent intents proceed |
| Legacy row corruption | migration rellena fake op ids | falsificación histórica | existing rows may remain NULL | preserved |
| Inactive state invention | nuevo status no canónico | requirement invention | no status column | absent |

---

# 24. Requisitos funcionales TASK-016

**RF-016-001.** TASK-016 DEBE implementar exclusivamente RF-001 y RF-002 del producto.

**RF-016-002.** El actor funcional permitido DEBE ser únicamente un `SUPER_ADMIN` actual y autoritativamente validado.

**RF-016-003.** La identidad del actor DEBE derivarse de la sesión Auth validada y `auth.uid()`.

**RF-016-004.** La autoridad global DEBE resolverse desde PostgreSQL vigente mediante la foundation de TASK-014.

**RF-016-005.** `is_super_admin = false` DEBE denegar la creación.

**RF-016-006.** `is_super_admin = true` junto con cualquier `CompanyMembership` DEBE denegar la creación como estado inconsistente.

**RF-016-007.** Una membership disabled DEBE contar como existente para la regla anterior.

**RF-016-008.** Un claim, metadata o input del caller NO DEBE poder conceder autoridad global.

**RF-016-009.** Una creación autorizada nueva DEBE producir exactamente una `MaintenanceCompany`.

**RF-016-010.** La nueva `MaintenanceCompany` DEBE estar activa inmediatamente sin introducir un estado inactive de creación.

**RF-016-011.** TASK-016 NO DEBE crear una columna de estado comercial/activo como requisito inventado.

**RF-016-012.** La identidad física de la nueva `MaintenanceCompany` DEBE generarse dentro de una frontera confiable.

**RF-016-013.** El caller NO DEBE seleccionar autoritativamente el `maintenance_company_id`.

**RF-016-014.** Cada intento lógico DEBE utilizar un `creation_operation_id` UUID estable.

**RF-016-015.** Un mismo `creation_operation_id` NO DEBE producir más de una `MaintenanceCompany`.

**RF-016-016.** Retry del mismo operation ID después de un success DEBE devolver/reconciliar la misma `MaintenanceCompany` únicamente si la autoridad `SUPER_ADMIN` actual continúa siendo válida.

**RF-016-017.** Un retry reconciliado autorizado DEBE indicar `changed=false`; si la autoridad actual ya no es válida, DEBE resultar `DENIED` sin nueva fila.

**RF-016-018.** Una creación nueva confirmada DEBE indicar `changed=true`.

**RF-016-019.** Dos operation IDs distintos PUEDEN crear dos empresas distintas si ambas intenciones están autorizadas.

**RF-016-020.** TASK-016 NO DEBE deduplicar por nombre, email, dirección ni otro atributo no aprobado.

**RF-016-021.** La creación DEBE ser online-only.

**RF-016-022.** TASK-016 NO DEBE crear el primer `COMPANY_ADMIN`.

**RF-016-023.** TASK-016 NO DEBE crear `PlatformUser`.

**RF-016-024.** TASK-016 NO DEBE crear `CompanyMembership`.

**RF-016-025.** TASK-016 NO DEBE emitir `VerificationChallenge`.

**RF-016-026.** TASK-016 NO DEBE crear Auth users.

**RF-016-027.** TASK-016 NO DEBE enviar email.

**RF-016-028.** TASK-016 NO DEBE implementar RF-003..RF-012.

**RF-016-029.** TASK-016 NO DEBE crear `Client`, `UserClientAccess` ni `SupportAccessGrant`.

**RF-016-030.** TASK-016 NO DEBE implementar bootstrap/grant/revoke de `SUPER_ADMIN`.

**RF-016-031.** TASK-016 NO DEBE crear `USER_CREATED` AuditEvent.

**RF-016-032.** TASK-016 NO DEBE inventar una nueva action global de `AuditEvent`.

**RF-016-033.** TASK-016 NO DEBE declarar onboarding completo.

**RF-016-034.** TASK-016 NO DEBE declarar Auth funcional completo.

**RF-016-035.** TASK-016 NO DEBE declarar Fase 2 completada.

---

# 25. Requisitos de seguridad

**SEC-016-001.** `authenticated != authorized` DEBE preservarse.

**SEC-016-002.** `current authoritative state > stale client/token state` DEBE preservarse.

**SEC-016-003.** `SUPER_ADMIN global != tenant bypass` DEBE preservarse.

**SEC-016-004.** El actor DEBE derivarse de `auth.uid()` y no de un ID caller-supplied.

**SEC-016-005.** Missing `auth.uid()` DEBE fallar cerrado.

**SEC-016-006.** Missing `PlatformUser` DEBE fallar cerrado.

**SEC-016-007.** Mapping ambiguo DEBE fallar cerrado.

**SEC-016-008.** DB `is_super_admin=false` DEBE prevalecer sobre claims stale.

**SEC-016-009.** DB true sin claim global PUEDE autorizar si el resto de invariantes globales se cumplen.

**SEC-016-010.** Dual authority global+tenant DEBE fallar cerrado.

**SEC-016-011.** Membership disabled DEBE participar en la detección dual.

**SEC-016-012.** La function DEBE ser purpose-specific.

**SEC-016-013.** `SECURITY DEFINER` NO DEBE convertirse en bypass genérico.

**SEC-016-014.** `search_path` DEBE ser fijo/seguro.

**SEC-016-015.** Los objetos utilizados DEBEN referenciarse de forma no ambigua.

**SEC-016-016.** Dynamic SQL DEBE ser `NONE` salvo revisión humana nueva.

**SEC-016-017.** `PUBLIC` NO DEBE poseer EXECUTE.

**SEC-016-018.** `anon` NO DEBE poseer EXECUTE.

**SEC-016-019.** `authenticated` sólo PUEDE tener EXECUTE mínimo sobre la firma exacta.

**SEC-016-020.** `authenticated` NO DEBE obtener INSERT directo sobre `maintenance_companies`.

**SEC-016-021.** El RPC NO DEBE aceptar tenant ID como autoridad.

**SEC-016-022.** El RPC NO DEBE aceptar actor ID como autoridad.

**SEC-016-023.** El RPC NO DEBE aceptar `is_super_admin` como input.

**SEC-016-024.** El tenant ID nuevo DEBE generarse server/DB-side dentro de frontera confiable.

**SEC-016-025.** `creation_operation_id` NO DEBE ser tratado como secreto ni como autoridad.

**SEC-016-026.** Conocer un operation ID NO DEBE permitir creación sin autoridad global válida.

**SEC-016-027.** Reusar un operation ID confirmado NO DEBE crear otra fila.

**SEC-016-028.** La correlación de idempotencia DEBE ser durable.

**SEC-016-029.** Existing rows NO DEBEN recibir semántica falsa de operación histórica.

**SEC-016-030.** No se debe introducir un idempotency framework genérico.

**SEC-016-031.** No se debe introducir `service-role` como caller ordinario.

**SEC-016-032.** No se debe introducir generic privileged Supabase client.

**SEC-016-033.** No se deben introducir secrets nuevos.

**SEC-016-034.** No se debe introducir Auth Admin.

**SEC-016-035.** No se deben modificar Auth hooks/config.

**SEC-016-036.** Ninguna respuesta DEBE afirmar acceso operativo tenant para el creador.

**SEC-016-037.** Error DB ambiguo NO DEBE reportarse como success.

**SEC-016-038.** Response lost DEBE resolverse mediante retry del mismo operation ID, no nueva intención automática.

**SEC-016-039.** Concurrent duplicate calls DEBEN converger en una sola fila.

**SEC-016-040.** No se debe usar lock global de plataforma como mecanismo normal.

---

# 26. Requisitos RLS / privilegios

**RLS-016-001.** RLS tenant DEBE permanecer como frontera primaria de datos tenant-owned.

**RLS-016-002.** TASK-016 NO DEBE crear una policy tenant bypass para `SUPER_ADMIN`.

**RLS-016-003.** TASK-016 NO DEBE permitir lectura operativa normal del tenant recién creado al `SUPER_ADMIN`.

**RLS-016-004.** `maintenance_companies` NO DEBE obtener una policy general de INSERT para `authenticated`.

**RLS-016-005.** `maintenance_companies` NO DEBE obtener UPDATE/DELETE global funcional por este slice.

**RLS-016-006.** El write funcional DEBE ocurrir exclusivamente por la boundary purpose-specific.

**RLS-016-007.** El privilege definer DEBE limitarse a autoridad global + idempotencia + insert de tenant.

**RLS-016-008.** `PUBLIC EXECUTE` DEBE estar revocado.

**RLS-016-009.** `anon EXECUTE` DEBE estar ausente/revocado.

**RLS-016-010.** `authenticated EXECUTE` DEBE ser el mínimo necesario.

**RLS-016-011.** No se deben conceder table write grants nuevos a `authenticated` para soportar el RPC.

**RLS-016-012.** El caller no obtiene autoridad mediante `creation_operation_id`.

**RLS-016-013.** El caller no obtiene autoridad mediante UUID de empresa.

**RLS-016-014.** Existing tenant/member RLS de TASK-009 DEBE conservarse.

**RLS-016-015.** RLS de `company_memberships` NO DEBE modificarse.

**RLS-016-016.** Detección de membership disabled DEBE reutilizar semántica segura de TASK-014 o una composición equivalente sin ampliar visibilidad ordinaria.

**RLS-016-017.** No deben aparecer overloads privilegiados inesperados.

**RLS-016-018.** Direct Data API bypass DEBE permanecer denegado.

**RLS-016-019.** `SUPER_ADMIN` sin `SupportAccessGrant` NO DEBE leer datos operativos tenant por efecto de TASK-016.

**RLS-016-020.** Las suites de aislamiento multiempresa previas DEBEN continuar PASS.

---

# 27. Cambios físicos esperados

## 27.1 Database

Cambio mínimo esperado:

1. una nueva migration forward-only;
2. nueva columna técnica nullable en `public.maintenance_companies`:
   `creation_operation_id UUID`;
3. garantía de uniqueness para valores no-null;
4. función/RPC purpose-specific `public.create_maintenance_company` o equivalente aprobado;
5. hardening `SECURITY DEFINER`;
6. grants/revokes exactos de EXECUTE;
7. ningún nuevo status de tenant;
8. ninguna nueva tabla de dominio;
9. ninguna tabla genérica de idempotencia;
10. ninguna nueva action de `AuditEvent`;
11. ninguna tenant bypass policy;
12. ningún cambio a `company_memberships`;
13. ningún cambio a `platform_users.is_super_admin`;
14. ningún cambio Auth.

Este documento no contiene SQL ejecutable.

## 27.2 Existing rows

Debe preservarse:

```text
existing maintenance_companies.id = unchanged
```

y:

```text
existing creation_operation_id
→ NULL permitted
```

No se borran/recrean tenants.

## 27.3 Application

Se espera una boundary mínima en el módulo que el preflight real identifique como propietario de Tenant Management / Identity & Authorization, respetando ADR-0001.

La boundary:

- recibe `creation_operation_id`;
- usa client caller-scoped;
- invoca el RPC;
- mapea outcomes;
- no replica autoridad como fuente final;
- mantiene TypeScript estricto.

## 27.4 Types

Sólo tipos estrictamente necesarios:

- `CreationOperationId`;
- input de create-company;
- outcome cerrado;
- result con company ID nullable según outcome;
- error mapping.

No se crea:

- framework genérico de commands;
- generic idempotency abstraction cross-module;
- configurable RBAC;
- generic admin SDK.

## 27.5 UI

Nueva UI completa:

```text
OUT OF SCOPE
```

## 27.6 Provider

```text
Supabase Auth provider mutation = NONE
new secret = NONE
email provider = NONE
```

---

# 28. Estrategia de pruebas

Las pruebas deben combinar DB real, application boundary, RLS/privileges, concurrencia y regresión.

## 28.1 Fixtures

Fixtures:

```text
test/local/Development only
```

Deben ser:

- descartables;
- no productivas;
- identificables;
- limpiadas;
- verificadas post-cleanup.

Una fixture `SUPER_ADMIN`:

```text
!= bootstrap funcional
```

## 28.2 Authorization

**T016-AUTH-001** — current valid global `SUPER_ADMIN` + no membership puede crear.

**T016-AUTH-002** — DB `is_super_admin=false` → DENY.

**T016-AUTH-003** — valid tenant `COMPANY_ADMIN` → DENY.

**T016-AUTH-004** — `TECHNICIAN` → DENY.

**T016-AUTH-005** — auth subject sin `PlatformUser` → DENY.

**T016-AUTH-006** — no `auth.uid()` → DENY.

**T016-AUTH-007** — `is_super_admin=true` + enabled membership → INCONSISTENT/DENY.

**T016-AUTH-008** — `is_super_admin=true` + disabled membership → INCONSISTENT/DENY.

**T016-AUTH-009** — stale claim global + DB false → DENY.

**T016-AUTH-010** — no global claim + DB true + no membership → ALLOW.

**T016-AUTH-011** — caller-supplied `is_super_admin`/actor/tenant-like data no altera resultado.

## 28.3 Creation

**T016-CREATE-001** — nueva operación autorizada crea exactamente una fila.

**T016-CREATE-002** — resultado = `CREATED`, `changed=true`.

**T016-CREATE-003** — tenant ID resultante es UUID válido generado dentro de frontera confiable.

**T016-CREATE-004** — `creation_operation_id` persistido coincide con input.

**T016-CREATE-005** — no se crea `CompanyMembership`.

**T016-CREATE-006** — no se crea `PlatformUser`.

**T016-CREATE-007** — no se crea `UserClientAccess`.

**T016-CREATE-008** — no se crea `SupportAccessGrant`.

**T016-CREATE-009** — no se crea `VerificationChallenge`.

**T016-CREATE-010** — no se crea `AuditEvent`.

## 28.4 Idempotencia

**T016-IDEM-001** — retry same operation ID con current authoritative `SUPER_ADMIN` authority todavía válida retorna misma company.

**T016-IDEM-002** — retry same operation ID con current authoritative `SUPER_ADMIN` authority todavía válida = `ALREADY_CREATED`, `changed=false`.

**T016-IDEM-003** — row count permanece 1.

**T016-IDEM-004** — two distinct operation IDs crean dos filas cuando ambas intents son válidas.

**T016-IDEM-005** — existing pre-TASK-016 row con `creation_operation_id=NULL` permanece válida.

**T016-IDEM-006** — migration no fabrica operation IDs históricos.

**T016-IDEM-007** — malformed operation ID no crea fila.

**T016-IDEM-008** — actor válido `SUPER_ADMIN` crea con operation ID X → `CREATED`; luego DB authority cambia a `is_super_admin=false`; retry con X por la misma identidad autenticada → `DENY`, no `ALREADY_CREATED`, row count permanece 1 y no ocurre nueva mutación.

## 28.5 Concurrency

**T016-CON-001** — dos requests realmente concurrentes con mismo operation ID producen una sola empresa.

**T016-CON-002** — ambos callers concurrentes observan/reconcilian el mismo company ID.

**T016-CON-003** — dos operation IDs distintos no requieren lock global y pueden crear dos filas.

**T016-CON-004** — unique/idempotency race no produce error que induzca a nueva creación automática.

Las pruebas concurrentes deben usar conexiones/requests realmente paralelas cuando el harness lo permita.

## 28.6 RLS / privileges

**T016-RLS-001** — direct authenticated INSERT a `maintenance_companies` remains denied.

**T016-RLS-002** — anon no ejecuta RPC.

**T016-RLS-003** — PUBLIC no posee EXECUTE.

**T016-RLS-004** — authenticated sólo posee EXECUTE esperado, no table insert grant.

**T016-RLS-005** — search_path hardening presente.

**T016-RLS-006** — no privileged overload inesperado.

**T016-RLS-007** — tenant RLS preexistente unchanged.

**T016-RLS-008** — SUPER_ADMIN no obtiene tenant operational read por crear empresa.

**T016-RLS-009** — `company_memberships` policies unchanged.

## 28.7 Security/negative

**T016-SEC-001** — caller no puede elegir company ID.

**T016-SEC-002** — caller no puede elegir actor.

**T016-SEC-003** — caller no puede seleccionar otro PlatformUser.

**T016-SEC-004** — caller no puede convertir operation ID en authority.

**T016-SEC-005** — no service-role application path.

**T016-SEC-006** — no generic privileged client.

**T016-SEC-007** — no new secret.

**T016-SEC-008** — no Auth Admin call.

**T016-SEC-009** — no Auth hook/config mutation.

**T016-SEC-010** — bundle/diff/log review sin secretos.

## 28.8 Failure

**T016-FAIL-001** — DB failure before commit deja cero nueva fila.

**T016-FAIL-002** — authority lookup failure deja cero nueva fila.

**T016-FAIL-003** — response-lost scenario se reconcilia con mismo op ID.

**T016-FAIL-004** — impossible duplicate/corrupt state falla cerrado.

## 28.9 Application boundary

**T016-APP-001** — usa caller-scoped Supabase client.

**T016-APP-002** — TypeScript strict sin `any` injustificado.

**T016-APP-003** — no table insert directo desde application boundary.

**T016-APP-004** — no endpoint generic admin.

**T016-APP-005** — outcomes físicos se mapean sin sobredeclarar success ambiguo.

## 28.10 Regression

Deben continuar pasando las suites aplicables de:

- TASK-009 identity/tenant/RLS;
- TASK-010 AuditEvent privileges;
- TASK-011 SSR Auth lifecycle;
- TASK-012 tenant authorization;
- TASK-013 Auth security foundation;
- TASK-014 global authority;
- TASK-015 membership lifecycle;
- lint;
- typecheck;
- build;
- project verify/test scripts aplicables.

---

# 29. Hosted Development Gate

TASK-016 modifica schema/privileges mediante una migration.

Por tanto:

```text
Hosted Development verification =
REQUIRED
```

## 29.1 Precondiciones

Antes de cualquier mutación Hosted Development deben existir separadamente:

1. `TASK-016 SPEC REVIEW = APPROVED`;
2. aprobación humana formal de la specification;
3. artefacto aprobado generado y revisado;
4. canonicalización completada/revisada cuando corresponda;
5. artefacto canónico incorporado a Git mediante Gates separados;
6. autorización humana expresa de implementation;
7. implementación local terminada;
8. implementation review local = PASS;
9. preflight Git/CLI/entorno fresco;
10. autorización humana expresa de Hosted Development mutation/verification.

## 29.2 Verificaciones Hosted

Como mínimo:

- migration exacta aplicada;
- `creation_operation_id` presente con shape esperado;
- existing rows preservadas;
- no fake historical operation IDs;
- uniqueness/idempotency enforcement correcto;
- RPC exacto presente;
- `SECURITY DEFINER` presente;
- safe `search_path`;
- `PUBLIC EXECUTE = NO`;
- `anon EXECUTE = NO`;
- authenticated EXECUTE exacto;
- no table insert grant inesperado;
- no tenant bypass policy;
- positive SUPER_ADMIN create = PASS;
- DB false = DENY;
- dual authority enabled membership = DENY;
- dual authority disabled membership = DENY;
- retry same op con current authority todavía válida = same company;
- authority revoked + retry same op = DENY, no `ALREADY_CREATED`, no nueva fila;
- concurrent same op = one company;
- direct Data API insert = DENY;
- no CompanyMembership creation;
- no AuditEvent creation;
- no Auth mutation;
- schema/policy/grant diff = expected-only;
- regression suites = PASS;
- fixtures cleanup = PASS;
- post-cleanup unexpected authority/data = NONE.

## 29.3 Entornos

TASK-016 no autoriza:

```text
Staging mutation
Production mutation
```

Cada entorno requiere Gate humano separado.

---

# 30. Preflight obligatorio de futura implementación

Antes de modificar repositorio, el implementador autorizado debe verificar:

## 30.1 Git

- repo root;
- branch;
- HEAD;
- origin/main;
- divergence;
- worktree;
- staged;
- unstaged;
- untracked;
- Git operations in progress.

Cualquier drift incompatible:

```text
STOP
```

## 30.2 Canon

Leer íntegramente y confirmar:

- TASK-014 cerrado;
- TASK-015 cerrado;
- CORR-025 cerrado;
- OPTION A sigue vigente;
- Phase 2 sigue `INICIADA / NOT DONE`;
- Phase 3 sigue `NOT STARTED`;
- TASK-017 no adelantada;
- ningún ADR posterior sustituye authority/RLS boundary;
- `01/02/03` siguen conteniendo RF-001/RF-002 y semántica global vigente.

## 30.3 Repositorio físico

Inspeccionar:

- schema actual de `maintenance_companies`;
- policies/grants vigentes;
- migration history;
- función/RPC de TASK-014 real;
- nombres y hardening reales;
- caller-scoped Supabase factories;
- módulos actuales;
- tests DB/RLS;
- test harness concurrency;
- scripts de verify/lint/typecheck/build;
- dependencias/versiones.

## 30.4 No asumir nombres

Los paths, timestamps de migration y nombres internos concretos se fijan sólo contra el repo real.

Si el repo contradice esta specification:

```text
BLOCKER
```

No reparar silenciosamente.

---

# 31. Blockers de futura implementación

La implementación debe detenerse si ocurre cualquiera:

1. OPTION A ya no está aprobada;
2. no existe un `SUPER_ADMIN` pre-provisionado utilizable como precondición operacional para verificación;
3. se requiere definir bootstrap de `SUPER_ADMIN`;
4. canon actual contradice RF-001/RF-002 o esta frontera;
5. branch/base Git no autorizada;
6. worktree incompatible;
7. schema de `maintenance_companies` difiere materialmente;
8. TASK-014 global resolver/authority model cambió;
9. `platform_users.is_super_admin` dejó de ser fuente autoritativa;
10. mutual exclusion global+membership cambió;
11. crear empresa requiere primer admin en la misma transacción por una decisión posterior;
12. crear empresa requiere email en el mismo slice por decisión posterior;
13. se necesita `Client`/`UserClientAccess`;
14. se necesita `SupportAccessGrant`;
15. se necesita Auth Admin;
16. se necesita modificar ADR-0019;
17. se necesita generic `service-role` request client;
18. se necesita generic privileged server client;
19. se necesita abrir INSERT general a `authenticated`;
20. se necesita tenant bypass RLS;
21. `PUBLIC EXECUTE` no puede revocarse;
22. safe `search_path` no puede garantizarse;
23. idempotency no puede garantizarse;
24. same-operation concurrent creation puede producir dos rows;
25. la solución exige caller-selected tenant ID;
26. la solución exige deduplicación por nombre/email no aprobada;
27. la solución exige tabla/framework genérico de idempotencia;
28. se necesita inventar estado activo/inactivo de tenant;
29. se necesita nueva AuditEvent action;
30. se necesita crear `USER_CREATED`;
31. se necesita crear `PlatformUser`/`CompanyMembership`;
32. se necesita offline/outbox;
33. se necesita microservicio;
34. se necesita nuevo ADR;
35. migration destruye/recrea filas existentes;
36. Hosted Development diff contiene objetos inesperados;
37. tests de RLS/global authority/idempotency fallan;
38. cualquier Acceptance Criterion falla.

Ante blocker:

```text
NO SCOPE EXPANSION
NO SILENT REPAIR
NO HOSTED MUTATION
NO STAGING
NO COMMIT
NO PUSH
NO TASK-017
RETURN TO REVISOR CENTRAL
```

---

# 32. Fuera de alcance consolidado

TASK-016 no incluye:

- RF-003..RF-012;
- primer `COMPANY_ADMIN`;
- email first-admin;
- VerificationChallenge onboarding use case;
- email sending/resending;
- code verification UI;
- Auth user creation;
- `PlatformUser` creation;
- `CompanyMembership` creation;
- membership lifecycle;
- `USER_CREATED`;
- nueva AuditEvent action;
- Client;
- Location;
- Equipment;
- UserClientAccess;
- SupportAccessGrant;
- support flows;
- tenant operational data;
- company profile/name/address/phone;
- company branding/configuration;
- subscription/payment;
- commercial suspension/reactivation;
- forms;
- maintenance;
- evidence;
- reporting;
- AI;
- credits;
- push;
- dashboard;
- offline;
- Dexie;
- IndexedDB;
- outbox;
- Service Worker;
- bootstrap/grant/revoke/admin of SUPER_ADMIN;
- generic service-role client;
- generic privileged client;
- generic admin API;
- generic idempotency framework;
- queue/worker;
- microservice;
- Staging;
- Production;
- TASK-017;
- Phase 2 Exit Gate;
- Phase 2 completion;
- Phase 3 start.

---

# 33. Acceptance Criteria

Cada AC debe evaluarse individualmente como `PASS` o `FAIL`.

## 33.1 Governance / scope

**AC-016-001.** Task ID exacto = `TASK-016`.

**AC-016-002.** Título exacto = `Creación global autoritativa mínima de MaintenanceCompany por SUPER_ADMIN`.

**AC-016-003.** Scope de producto = RF-001 + RF-002 exclusivamente.

**AC-016-004.** FL-01 se limita a steps 1–2.

**AC-016-005.** RF-003..RF-012 permanecen fuera.

**AC-016-006.** TASK-017 no se determina/genera/implementa.

**AC-016-007.** Phase 2 permanece `INICIADA / NOT DONE`.

**AC-016-008.** Phase 2 Exit Gate permanece `NOT DEFINED / NOT SATISFIED`.

**AC-016-009.** Phase 3 permanece `NOT STARTED`.

**AC-016-010.** Generación/aprobación de spec no equivale a implementation authorization.

## 33.2 OPTION A / authority

**AC-016-011.** OPTION A se consume sólo como precondición operacional.

**AC-016-012.** TASK-016 no define bootstrap de `SUPER_ADMIN`.

**AC-016-013.** TASK-016 no implementa grant/revoke/admin de `SUPER_ADMIN`.

**AC-016-014.** Actor deriva de `auth.uid()`.

**AC-016-015.** Actor debe resolver a `PlatformUser`.

**AC-016-016.** Autoridad positiva requiere DB `is_super_admin=true`.

**AC-016-017.** Missing membership no es autoridad positiva.

**AC-016-018.** Any membership + global true produce INCONSISTENT/DENY.

**AC-016-019.** Membership disabled también produce inconsistencia.

**AC-016-020.** Claims/frontend/metadata no son autoridad.

## 33.3 Creation semantics

**AC-016-021.** Valid global authority puede crear nueva `MaintenanceCompany`.

**AC-016-022.** Un success nuevo crea exactamente una fila.

**AC-016-023.** Tenant ID se genera dentro de frontera confiable.

**AC-016-024.** Caller no selecciona tenant ID.

**AC-016-025.** No se crea status/is_active.

**AC-016-026.** Tenant creado queda conceptualmente activo inmediatamente.

**AC-016-027.** No se crea first admin.

**AC-016-028.** No se crea PlatformUser.

**AC-016-029.** No se crea CompanyMembership.

**AC-016-030.** No se crea Client/UserClientAccess/SupportAccessGrant.

## 33.4 Idempotency

**AC-016-031.** Existe `creation_operation_id` purpose-specific durable.

**AC-016-032.** Tipo conceptual UUID.

**AC-016-033.** Existing rows pueden conservar NULL.

**AC-016-034.** Nuevas creaciones funcionales lo persisten non-null por contrato del use case.

**AC-016-035.** Valores non-null son únicos.

**AC-016-036.** Same operation ID produce at most one company.

**AC-016-037.** Retry con current authoritative `SUPER_ADMIN` authority todavía válida retorna same company ID.

**AC-016-038.** Retry reconciliado autorizado = `changed=false`; retry después de pérdida de autoridad = `DENIED` sin nueva fila.

**AC-016-039.** New creation = `changed=true`.

**AC-016-040.** Distinct operation IDs pueden representar intents distintos.

**AC-016-041.** No dedupe por nombre/email.

**AC-016-042.** No generic idempotency table/framework.

## 33.5 Security / RPC

**AC-016-043.** RPC purpose-specific existe.

**AC-016-044.** `SECURITY DEFINER` hardening verificado.

**AC-016-045.** Safe fixed search_path.

**AC-016-046.** Dynamic SQL esperado = NONE.

**AC-016-047.** PUBLIC EXECUTE = NO.

**AC-016-048.** anon EXECUTE = NO.

**AC-016-049.** authenticated EXECUTE = exact minimum.

**AC-016-050.** No actor ID input.

**AC-016-051.** No tenant ID input.

**AC-016-052.** No `is_super_admin` input.

**AC-016-053.** Operation ID no concede authority, incluido retry/reconciliation después de pérdida de autoridad; current authoritative `SUPER_ADMIN` authority se revalida antes de `ALREADY_CREATED`.

**AC-016-054.** Error de authority lookup fails closed.

**AC-016-055.** Generic privileged client = NONE.

**AC-016-056.** service-role ordinary path = NONE.

**AC-016-057.** new secrets = NONE.

**AC-016-058.** Auth Admin calls = NONE.

## 33.6 RLS / multitenancy

**AC-016-059.** Existing tenant RLS no se debilita.

**AC-016-060.** No new SUPER_ADMIN tenant bypass policy.

**AC-016-061.** Direct authenticated INSERT maintenance_companies sigue denegado.

**AC-016-062.** authenticated no recibe table write grant para crear empresas.

**AC-016-063.** `company_memberships` RLS unchanged.

**AC-016-064.** Crear tenant no crea membership para SUPER_ADMIN.

**AC-016-065.** Crear tenant no concede acceso operativo al mismo.

**AC-016-066.** Cross-tenant isolation regression = NONE.

## 33.7 Audit / provider / offline

**AC-016-067.** Nueva AuditEvent action = NONE.

**AC-016-068.** MaintenanceCompany creation AuditEvent producer = NONE bajo canon vigente.

**AC-016-069.** `USER_CREATED` = OUT OF SCOPE.

**AC-016-070.** VerificationChallenge mutation = NONE.

**AC-016-071.** SessionGrant mutation = NONE.

**AC-016-072.** Auth Hook/config change = NONE.

**AC-016-073.** Offline mutation/outbox = NONE.

**AC-016-074.** UI completa = OUT OF SCOPE.

## 33.8 Concurrency / failures

**AC-016-075.** Concurrent same op ID produce exactamente una empresa.

**AC-016-076.** Concurrent same op callers reconcilian same ID.

**AC-016-077.** No global platform creation lock requerido.

**AC-016-078.** DB failure no deja partial row.

**AC-016-079.** Response-lost retry same op reconcilia sólo después de revalidar con éxito current authoritative `SUPER_ADMIN` authority; si la autoridad fue revocada, el retry deniega sin nueva fila.

**AC-016-080.** Estado imposible/ambiguo fails closed.

## 33.9 Application / quality

**AC-016-081.** Application boundary usa caller-scoped Supabase.

**AC-016-082.** TypeScript strict preservado.

**AC-016-083.** No `any` injustificado.

**AC-016-084.** No direct table insert en application boundary.

**AC-016-085.** No generic admin endpoint.

**AC-016-086.** No nuevo framework/ORM/dependency sin review.

**AC-016-087.** lint PASS.

**AC-016-088.** typecheck PASS.

**AC-016-089.** tests aplicables PASS.

**AC-016-090.** build PASS.

**AC-016-091.** `git diff --check` PASS.

## 33.10 Regression / Hosted

**AC-016-092.** TASK-009 regression PASS.

**AC-016-093.** TASK-010 regression PASS.

**AC-016-094.** TASK-011 regression PASS.

**AC-016-095.** TASK-012 regression PASS.

**AC-016-096.** TASK-013 regression PASS.

**AC-016-097.** TASK-014 global authority regression PASS.

**AC-016-098.** TASK-015 lifecycle regression PASS.

**AC-016-099.** Hosted Development expected-only schema/privilege diff PASS.

**AC-016-100.** Hosted same-op retry PASS.

**AC-016-101.** Hosted concurrent duplicate PASS.

**AC-016-102.** Hosted direct bypass negative PASS.

**AC-016-103.** Hosted fixtures cleanup PASS.

**AC-016-104.** Staging unchanged.

**AC-016-105.** Production unchanged.

**AC-016-106.** Todos AC-016-001..105 PASS antes de cierre técnico/final.

---

# 34. Definition of Done

TASK-016 sólo puede considerarse DONE/CLOSED cuando:

1. esta specification haya sido generada;
2. `TASK-016 SPEC REVIEW = APPROVED`;
3. exista aprobación humana formal de la specification;
4. exista artefacto aprobado;
5. artefacto aprobado review = APPROVED;
6. canonicalización, cuando corresponda, esté completada y revisada;
7. artefacto canónico esté incorporado a Git mediante Gates separados;
8. exista autorización humana separada de implementation;
9. preflight Git fresco = PASS;
10. canon preflight = PASS;
11. repository/schema preflight = PASS;
12. no exista contradicción material;
13. migration forward-only exacta implementada;
14. `creation_operation_id` implementado sin alterar semántica histórica;
15. uniqueness/idempotency garantizada;
16. RPC purpose-specific implementado;
17. `auth.uid()`-anchored authority preservada;
18. TASK-014 global authority semantics preservadas;
19. dual authority fail-closed preservado;
20. safe `search_path` verificado;
21. PUBLIC/anon EXECUTE revocados;
22. authenticated EXECUTE mínimo verificado;
23. direct authenticated table insert sigue denegado;
24. no tenant bypass policy;
25. new creation positive path PASS;
26. same-operation retry PASS bajo current authoritative `SUPER_ADMIN` authority válida, y retry post-revocation DENY;
27. actual concurrency duplicate PASS;
28. no first admin/user/membership created;
29. no AuditEvent new action/producer;
30. no Auth provider mutation;
31. no offline implementation;
32. lint PASS;
33. typecheck PASS;
34. build PASS;
35. suites aplicables PASS;
36. local implementation review = APPROVED;
37. Hosted Development mutation Gate autorizado separadamente;
38. Hosted migration application = PASS;
39. Hosted security/RLS/idempotency verification = PASS;
40. Hosted expected-only diff = PASS;
41. fixtures cleanup/post-cleanup = PASS;
42. implementation staging Gate aprobado separadamente;
43. implementation commit Gate aprobado separadamente;
44. implementation push Gate aprobado separadamente;
45. remote exact verification = PASS;
46. todos AC-016-001..106 = PASS;
47. residual blocker = NONE;
48. architecture regression = NONE;
49. security regression = NONE;
50. RLS regression = NONE;
51. multitenancy regression = NONE;
52. scope expansion = NONE;
53. secret leak = NONE;
54. final human closure review = APPROVED.

Debe permanecer:

```text
implementation PASS
!=
TASK-016 DONE
```

y:

```text
push PASS
!=
TASK-016 DONE
```

Sólo el cierre humano final puede declarar:

```text
TASK-016 =
DONE / CLOSED
```

---

# 35. Secuencia de Gates posteriores

Después de esta generación:

```text
TASK-016 SPECIFICATION GENERATED
↓
TASK-016 SPEC REVIEW
↓
TASK-016 HUMAN SPEC APPROVAL
↓
APPROVED ARTIFACT GENERATION/REVIEW
↓
CANONICALIZATION GATE/REVIEW
↓
CANONICAL INCORPORATION GATES
↓
TASK-016 IMPLEMENTATION AUTHORIZATION GATE
↓
LOCAL IMPLEMENTATION
↓
IMPLEMENTATION REVIEW
↓
HOSTED DEVELOPMENT MUTATION GATE
↓
HOSTED VERIFICATION
↓
GIT STAGING GATE
↓
COMMIT GATE
↓
PUSH GATE
↓
REMOTE VERIFICATION
↓
FINAL HUMAN CLOSURE GATE
```

Cada Gate es separado.

Ningún Gate implica automáticamente el siguiente.

---

# 36. Prohibiciones durante la fase documental actual

La generación de esta specification NO autoriza:

- Codex;
- código;
- SQL ejecutable;
- migration;
- RLS ejecutable;
- modificación de repo;
- modificación de docs canónicos;
- Supabase Cloud;
- Hosted mutation;
- JIT mutation;
- git add;
- commit;
- push;
- Staging;
- Production;
- TASK-017;
- Phase 2 Exit Gate;
- Phase 2 completion;
- Phase 3 start.

---

# 37. Resultado formal de la specification generada

```text
TASK-016 SPECIFICATION GENERATION =
PASS

TASK-016 SPECIFICATION =
APPROVED FOR IMPLEMENTATION

TASK-016 TITLE =
Creación global autoritativa mínima de MaintenanceCompany por SUPER_ADMIN

PRODUCT SCOPE =
RF-001 + RF-002
FL-01 steps 1–2 only

OPTION A =
CONSUMED AS OPERATIONAL PRECONDITION ONLY

FIRST COMPANY_ADMIN =
NOT CREATED

VerificationChallenge onboarding =
NOT STARTED

Auth user creation =
OUT OF SCOPE

PlatformUser creation =
OUT OF SCOPE

CompanyMembership creation =
OUT OF SCOPE

Client/UserClientAccess =
OUT OF SCOPE

SupportAccessGrant =
OUT OF SCOPE

AuditEvent new action =
NONE

MaintenanceCompany creation AuditEvent =
NONE UNDER CURRENT CANON

IDEMPOTENCY =
PURPOSE-SPECIFIC creation_operation_id

GENERIC IDEMPOTENCY FRAMEWORK =
NO

RLS TENANT BYPASS =
NO

SERVICE-ROLE ORDINARY PATH =
NO

OFFLINE =
NO

NEW BROAD UI =
NO

NEW ADR REQUIRED =
NO

HOSTED DEVELOPMENT VERIFICATION =
REQUIRED AFTER SEPARATE AUTHORIZATION

TASK-016 IMPLEMENTATION =
NOT AUTHORIZED

CODEX =
NOT AUTHORIZED

Phase 2 =
INICIADA / NOT DONE

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED

TASK-017 =
NOT DETERMINED / NOT GENERATED / NOT STARTED
```

---

<!-- FIN DEL DOCUMENTO TASK-016-maintenance-company-global-authoritative-creation.md -->
