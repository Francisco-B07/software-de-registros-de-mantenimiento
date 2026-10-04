# ADR-0022 — Later-User Auth Subject Discovery, Application Compatibility, and Initial Session Issuance Serialization

> **Candidate canonical path:** `docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md`
> **Phase:** Fase 2 — Multitenancy, autenticación, roles y RLS
> **Type:** Architecture / Security Decision Record
> **Status:** `PROPOSED`
> **Review state:** `PENDING APPROVED ARTIFACT REVIEW`
> **Human approval:** `APPROVED`
> **Architecture decision:** `HUMAN APPROVED`
> **Approved artifact:** `GENERATED / PENDING APPROVED ARTIFACT REVIEW`
> **Generation date:** `2026-10-03`
> **Correction generation date:** `2026-10-03`
> **Second correction generation date:** `2026-10-03`
> **Nature:** decisión arquitectónica humanamente aprobada para resolver descubrimiento/reconciliación segura de Auth subject, compatibilidad de identidad de aplicación y serialización de la emisión de la sesión inicial de usuarios posteriores; **NO constituye canonicalización, incorporación al repositorio, implementación, SQL, migration, RLS ejecutable, configuración aplicada de Supabase Auth, autorización de TASK-021, autorización de Codex ni mutación del repositorio o de Supabase**.

---

# 1. Estado de gobernanza

Se consume como estado formal recibido:

```text
Phase 0 =
COMPLETED

Phase 1 =
COMPLETED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 3 =
NOT STARTED

TASK-020 =
DONE / CLOSED

TASK-020 FINAL HUMAN CLOSURE =
APPROVED

TASK-021 DETERMINATION =
APPROVED

TASK-021 specification =
BLOCKED / NOT APPROVED

TASK-021 CORRECTED SPEC REVIEW =
BLOCKER — NEW ARCHITECTURE / SECURITY DECISION REQUIRED

F-021-SPEC-004 =
OPEN

F-021-SPEC-005 =
OPEN

F-021-SPEC-006 =
OPEN / DOCUMENTAL

ADR-0022 DETERMINATION =
APPROVED

ADR-0022 GENERATION AUTHORIZATION =
APPROVED

ADR-0022 GENERATION SOURCE RECOVERY =
PASS

ADR-0022 GENERATION =
PASS

ADR-0022 REVIEW =
RETURNED FOR CORRECTION

F-0022-R-001 =
BLOCKING — CROSS-FLOW LOCK GRAPH / PRECEDENCE NOT CLOSED

F-0022-R-002 =
BLOCKING — TASK-013 AUTH ADMIN SURFACE QUALIFICATION NOT EXPLICIT

F-0022-R-003 =
DOCUMENTAL — PROVIDER UUID V4 VALIDATION CLAIM TOO STRONG

ADR-0022 CORRECTED ARTIFACT REVIEW =
RETURNED FOR CORRECTION

F-0022-R-001 REVIEW =
FAIL / BLOCKING

F-0022-R-002 REVIEW =
PASS

F-0022-R-003 REVIEW =
PASS

F-0022-R-004 =
BLOCKING — PHYSICAL PLATFORMUSER ROW ALIAS CAN REINTRODUCE LOCK CYCLE
```

Este segundo artefacto corregido se genera bajo el Gate:

```text
ADR-0022 SECOND CORRECTION GENERATION
```

La segunda corrección queda limitada exclusivamente a `F-0022-R-004`; `F-0022-R-002` y `F-0022-R-003` permanecen PASS y no se reabren. Tampoco se reabre:

- la determinación de TASK-021;
- la determinación de ADR-0022;
- la arquitectura S1 seleccionada;
- el core E2 de ADR-0019;
- el contrato de handoff de TASK-020;
- el invariant aprobado de ADR-0021;
- ningún requirement de producto ni de Fase 3.

Resultado de este segundo artefacto corregido:

```text
ADR-0022 CORRECTION GENERATION =
PASS

ADR-0022 CORRECTED ARTIFACT REVIEW =
RETURNED FOR CORRECTION

ADR-0022 SECOND CORRECTION GENERATION =
PASS

ADR-0022 second corrected artifact =
GENERATED / PENDING SECOND CENTRAL RE-REVIEW

ADR-0022 status =
PROPOSED / NOT APPROVED

F-0022-R-001 =
CORRECTED AGAIN / PENDING REVIEW

F-0022-R-002 =
PASS / PRESERVED

F-0022-R-003 =
PASS / PRESERVED

F-0022-R-004 =
CORRECTED / PENDING REVIEW
```

La revisión posterior y la aprobación humana quedaron registradas así:

```text
ADR-0022 SECOND CORRECTED ARTIFACT REVIEW =
APPROVED

ADR-0022 architecture/security second re-review =
PASS

F-0022-R-001 REVIEW =
PASS

F-0022-R-002 REVIEW =
PASS / PRESERVED

F-0022-R-003 REVIEW =
PASS / PRESERVED

F-0022-R-004 REVIEW =
PASS

ADR-0022 HUMAN APPROVAL =
APPROVED

ADR-0022 architecture decision =
HUMAN APPROVED

ADR-0022 approved artifact =
GENERATED / PENDING APPROVED ARTIFACT REVIEW
```

La aprobación humana y esta generación documental **NO** producen:

```text
ADR-0022 canonicalized =
NO

ADR-0022 repository incorporation =
NO

TASK-021 specification =
REMAINS BLOCKED / NOT APPROVED

TASK-021 implementation =
NOT AUTHORIZED

Codex =
NOT AUTHORIZED

repository mutation =
NONE

Supabase mutation =
NONE
```

---

# 2. Context

TASK-020 dejó disponible un handoff autoritativo para el alta de un usuario posterior, pero no creó todavía autoridad tenant ni completó el lifecycle de usuario.

La determinación de TASK-021 fija el siguiente boundary:

```text
START
=
authoritative TASK-020 later-user handoff exists
+
LaterUserEnrollmentIntent authoritative binding is resolvable
+
valid current VerificationChallenge has already been consumed
+
correlated SessionGrant has been created/reconciled
+
target remains without tenant authority
```

y pretende alcanzar:

```text
END
=
compatible Supabase Auth identity established or safely reconciled
+
initial Supabase Auth session established under ADR-0019
+
result safely reconcilable under approved Auth/session boundary
+
AUTHENTICATED BUT NOT TENANT-AUTHORIZED
```

La especificación corregida de TASK-021 detectó dos problemas arquitectónicos bloqueantes.

Primero, cuando:

```text
AuthBridgeCredential.auth_user_id IS NULL
```

la composición histórica de TASK-013/TASK-018 descubre materialmente el Auth subject mediante un intento técnico de `signInWithPassword`, pudiendo llegar a ejecutar el `Custom Access Token Hook` y consumir el `SessionGrant` antes de que la aplicación posea un subject autoritativo sobre el cual verificar compatibilidad de `PlatformUser`, autoridad global y `CompanyMembership`.

Segundo, aunque la compatibilidad de aplicación se verificara antes de la emisión final, existe una ventana TOCTOU:

```text
compatibility passes at T1
→ application/tenant authority changes at T2
→ initial session is issued at T3
```

Una lectura stale de T1 no demuestra el END de TASK-021.

ADR-0022 existe para resolver ambos problemas sin trasladar autorización tenant al proveedor Auth ni al `Custom Access Token Hook`.

---

# 3. Fuentes de verdad consumidas

## 3.1 Producto y seguridad

Este ADR queda restringido por el canon vigente, incluyendo:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- `docs/product/04-offline-sync-strategy.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`, interpretado con los state-sync posteriores aprobados.

## 3.2 Arquitectura

Se consumen como mínimo:

- `ADR-0001 — Arquitectura modular del SaaS en Next.js`;
- `ADR-0002 — Multi-tenancy, tenant ownership y aislamiento`;
- `ADR-0003 — Autorización, client scope y soporte excepcional`;
- `ADR-0019 — VerificationChallenge, Supabase Auth y frontera de establecimiento de sesión`;
- `ADR-0020 — Authoritative First-Admin Onboarding Intent Binding`;
- `ADR-0021`, exclusivamente dentro del invariant posterior ya aprobado que ADR-0022 no modifica.

## 3.3 Incrementos físicos relevantes

Se consumen como mínimo:

- TASK-013 — foundation física segura de `VerificationChallenge`, `SessionGrant`, `AuthBridgeCredential` y gate E2;
- TASK-014 — autoridad global `SUPER_ADMIN`;
- TASK-015 — lifecycle de `CompanyMembership`;
- TASK-018 — reconciliación Auth/session first-admin, como precedente físico del bridge;
- TASK-019 — creación/reconciliación first-admin de `PlatformUser` y `CompanyMembership`;
- `CORR-035-task-019-cross-task-actor-company-lock-graph-correction.md` — corrección aprobada/canonicalizada del lock graph cross-task de TASK-019, que fija el actor histórico antes de `MaintenanceCompany` y preserva después `MaintenanceCompany → FirstAdminOnboardingIntent`;
- TASK-020 — handoff de later-user previo a TASK-021.

## 3.4 Fuentes recuperadas específicamente para este ADR

La recuperación previa cerró como verificadas:

```text
SOURCE A =
docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md

SHA-256 =
30480be7c24a260fe4d6d8231cb83134133192e9b37f052310b9522196be1a5c
```

y:

```text
SOURCE B =
docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md

SHA-256 =
f480485516dd0e9855f17f0463ec8a7c410e38ed677e75723bc93f41b2d1a4ae
```

Se preservan de esas fuentes, entre otras, las siguientes restricciones:

```text
email =
PII / LOCATOR / NOT AUTHORITY

provider side effect =
NOT ATOMIC WITH POSTGRESQL

provider ambiguity =
NO BLIND createUser RETRY

generic listUsers/search =
NO

password takeover =
NO

PlatformUser creation in TASK-021 =
NO

CompanyMembership creation in TASK-021 =
NO

PostgreSQL lock across provider call =
NO

distributed transaction =
NO

SessionGrant =
SHORT-LIVED / SINGLE-USE

Custom Access Token Hook =
E2 PLATFORM-OWNED AUTH GATE
```

## 3.5 Regla de autoridad

No se utiliza conversación histórica como sustituto de una fuente canónica cuando una fuente física sea necesaria para implementación.

Este ADR sí consume el estado de gobernanza y los constraints explícitamente transferidos por el handoff autoritativo que reanuda el Gate actual.

---

# 4. Requisitos arquitectónicos no negociables

Debe permanecer:

```text
tenant = MaintenanceCompany

multiempresa isolation = MANDATORY

RLS = MANDATORY FOR TENANT DATA

RLS = PRIMARY REMOTE TENANT-ISOLATION BOUNDARY

authenticated != authorized

Auth session != tenant authorization

current authoritative PostgreSQL state > stale claims

SUPER_ADMIN ordinary tenant bypass = NO

email → PlatformUser authority = NO

caller-supplied tenant authority = NO

JWT/custom claims as tenant/role authority = NO

generic privileged client = NO

ordinary generic service-role request path = NO

generic listUsers/search = NO
```

Además:

```text
Custom Access Token Hook =
PLATFORM-OWNED AUTH GATE ONLY

Hook CompanyMembership/tenant-role authorization =
NO

supabase_auth_admin tenant/application-authorization privileges =
NONE

technical password =
SERVER-ONLY

business proof =
VerificationChallenge

provider proof =
technical password

session authorization proof =
SessionGrant

SessionGrant =
SHORT-LIVED / SINGLE-USE / PURPOSE-SPECIFIC

SessionGrant TTL =
EXACTLY 5 MINUTES
```

ADR-0022 no introduce una cuarta proof de usuario.

---

# 5. Problem

¿Cómo puede TASK-021 establecer o reconciliar de forma segura el Auth subject de un usuario posterior y emitir su primera sesión Supabase sólo después de demostrar compatibilidad de identidad de aplicación, garantizando que dicha compatibilidad siga vigente hasta la emisión/finalización de la sesión, sin:

- usar email como autoridad de aplicación;
- enumerar usuarios Auth;
- emitir una sesión preliminar sólo para descubrir el subject;
- conceder acceso tenant a `supabase_auth_admin`;
- convertir el `Custom Access Token Hook` en un motor de autorización tenant;
- mantener un lock PostgreSQL abierto durante una llamada al proveedor;
- crear una transacción distribuida;
- introducir un generic privileged Auth client;
- crear `PlatformUser` o `CompanyMembership` dentro de TASK-021;
- debilitar ADR-0019/E2;
- inventar un bypass de RLS?

El diseño también debe poder reconciliar:

```text
createUser committed
+
provider/application response lost or ambiguous
```

sin un segundo `createUser` ciego y sin buscar al usuario por email mediante una enumeración general.

---

# 6. Drivers

## 6.1 Seguridad

- no emitir una sesión inicial para un subject que ya posea autoridad de aplicación incompatible;
- evitar la carrera entre compatibility check y session issuance;
- mantener email como locator, nunca como identity authority;
- impedir account takeover, password takeover o identity merge implícito;
- mantener el provider admin boundary estrecho y purpose-specific;
- fallar cerrado ante ambigüedad.

## 6.2 Recuperación

- poder reconciliar un `createUser` cuyo resultado se perdió;
- conservar un identificador estable previo al side effect remoto;
- impedir retries ciegos;
- distinguir `unknown` de `definitely absent`;
- preservar idempotencia de la misma operación lógica.

## 6.3 Multitenancy

- ninguna decisión del Auth provider determina tenant;
- ninguna sesión emitida equivale a `CompanyMembership`;
- la coordinación no es tenant authority;
- futuras mutaciones de autoridad deben respetar el fence por subject.

## 6.4 Simplicidad

- permanecer en el monolito modular Next.js + Supabase;
- no introducir microservicios;
- no introducir un registry de sesiones externo;
- no requerir acceso directo a `auth.sessions`;
- reutilizar E2 para la emisión final.

---

# 7. Hallazgos oficiales actuales de Supabase Auth — verificación 2026-10-03

Esta sección distingue hechos documentados/proporcionados por el proveedor de decisiones de aplicación.

## 7.1 `auth.admin.createUser`

**OFFICIALLY DOCUMENTED PROVIDER CAPABILITY**

La referencia JavaScript vigente documenta `auth.admin.createUser` como operación server-side de creación de usuario y advierte no exponer la credencial privilegiada en browser.

La interfaz oficial vigente `AdminUserAttributes` de `@supabase/auth-js` / `@supabase/supabase-js` incluye:

```text
id?: string
```

con la semántica documentada en el SDK:

```text
allows overriding the default id set for the user
```

El código oficial actual de Supabase Auth también acepta `id` en `AdminUserParams`; el handler observado parsea el valor como UUID, rechaza un UUID inválido, rechaza `uuid.Nil` y asigna el UUID resultante a `user.ID`. Aunque el mensaje de error actual menciona formato UUID v4, la evidencia de source revisada no se interpreta como una comprobación explícita e independiente de `UUID version == 4`.

**PROVIDER-DOCUMENTED / SOURCE-VERIFIED FACT:**

```text
custom Auth user id = SUPPORTED
UUID parsing/validation as Auth user identifier = YES
nil UUID rejected = YES
explicit source-level UUID-version-4 check proven by this review = NO
```

**PROJECT ARCHITECTURE DECISION:**

ADR-0022 preasigna server-side un UUID **v4** de Auth subject antes de ejecutar `createUser`. La exigencia de versión v4 pertenece al proyecto y debe volver a verificarse contra SDK instalado + Hosted inmediatamente antes de implementación.

Ese UUID:

```text
is a provider-subject locator/reservation
!= PlatformUser authority
!= tenant authority
!= role
```

## 7.2 `auth.admin.getUserById`

**OFFICIALLY DOCUMENTED PROVIDER CAPABILITY**

`getUserById(uid)` requiere el UUID exacto del usuario y obtiene el user object por `auth.users.id`.

No constituye búsqueda por email.

**Decisión de aplicación derivada:**

si ADR-0022 conoce el UUID exacto antes de `createUser`, puede reconciliar el resultado remoto mediante ese UUID sin enumerar el directorio Auth.

## 7.3 `auth.admin.listUsers`

**OFFICIALLY DOCUMENTED PROVIDER CAPABILITY**

La operación devuelve una lista paginada de usuarios.

La documentación pública consultada no ofrece mediante `listUsers` un contrato purpose-specific de resolución autoritativa por email equivalente a `getUserById`.

**Decisión:**

```text
listUsers =
REJECTED FOR ADR-0022
```

No se utilizará para buscar un target por email.

## 7.4 `signInWithPassword`

**OFFICIALLY DOCUMENTED PROVIDER CAPABILITY**

`signInWithPassword` autentica a un usuario existente mediante email/phone + password.

La propia documentación advierte que determinados errores no distinguen entre:

- cuenta inexistente;
- combinación email/password incorrecta;
- cuenta accesible sólo mediante social login.

**Decisión:**

`signInWithPassword` no es una primitive segura de **discovery-only** porque su éxito pertenece al camino de establecimiento de sesión.

ADR-0022 lo conserva exclusivamente como provider proof final después de compatibility + fence.

## 7.5 Custom Access Token Hook

**OFFICIALLY DOCUMENTED PROVIDER CAPABILITY**

El hook se ejecuta antes de emitir un token y recibe, entre otros:

```text
user_id
claims
authentication_method
```

Los métodos incluyen `password` y `token_refresh`.

Supabase Auth utiliza `supabase_auth_admin` para ejecutar Postgres Hooks y requiere grants explícitos para cualquier objeto adicional que el hook deba tocar.

**Decisión:**

ADR-0022 conserva el Hook como E2 auth gate y le permite consultar/actualizar únicamente el estado platform-owned mínimo de:

- `SessionGrant`;
- Auth bridge;
- coordinación de emisión de sesión definida por este ADR.

No recibe privilegios de `CompanyMembership`, tenant role, `UserClientAccess`, `SupportAccessGrant` ni autorización funcional de aplicación.

## 7.6 Before User Created Hook

**OFFICIALLY DOCUMENTED PROVIDER CAPABILITY**

Supabase documenta que este hook se ejecuta inmediatamente antes de crear un usuario y recibe el user object propuesto, incluido su `id`.

ADR-0022 **no depende** de este hook para descubrir el subject porque el SDK Admin vigente ya permite preasignar `id`.

Mantenerlo fuera del camino crítico evita convertir una nueva extensibility point en dependencia de TASK-021.

## 7.7 Provider capability vs aplicación

La siguiente separación es normativa para este ADR:

```text
provider supports custom admin user id
→ provider fact

application preallocates a UUID v4
→ ADR-0022 decision

provider supports exact getUserById
→ provider fact

application uses it for lost-response reconciliation
→ ADR-0022 decision

provider supports listUsers
→ provider fact

application rejects it for subject discovery
→ ADR-0022 decision
```

No se interpreta una capacidad del proveedor como permiso de producto.

---

# 8. Alternativa 1 — conservar sin cambios el protocolo unbound de TASK-013/TASK-018

## 8.1 Mecanismo

```text
unbound bridge
→ technical signInWithPassword
→ Hook may discover/bind subject
→ possible SessionGrant consume
→ possible createUser
→ final technical signInWithPassword
```

## 8.2 Ventajas

- mínima desviación del estado físico previo;
- reutiliza el bridge existente;
- permite reconciliar algunos usuarios Auth preexistentes con technical password conocida.

## 8.3 Seguridad

El primer `signInWithPassword` puede alcanzar el token gate antes de que exista una verificación autoritativa de compatibilidad de aplicación para un subject conocido.

## 8.4 Failure/recovery

La ambigüedad del primer sign-in queda mezclada con discovery y potencial issuance.

## 8.5 TOCTOU

No resuelve F-021-SPEC-005.

## 8.6 Privilegio

No añade privilegios, pero obliga a utilizar el gate de sesión para una finalidad de discovery.

## 8.7 Relación ADR-0019/TASK-013

Es compatible con el TASK-013 histórico, pero insuficiente para el nuevo boundary de TASK-021.

## 8.8 Resultado

```text
REJECTED
```

---

# 9. Alternativa 2 — two-stage subject-discovery / final-session mediante dos password sign-ins

## 9.1 Mecanismo

Primer sign-in para descubrir subject; segundo sign-in para emitir sesión final.

## 9.2 Ventajas

- separa conceptualmente discovery de final issuance.

## 9.3 Seguridad

Supabase no documenta un modo `signInWithPassword` de “validar credencial y devolver subject sin emitir sesión”.

Un success pertenece al flujo de autenticación/session.

## 9.4 Failure/recovery

Requeriría negar el primer token y conservar efectos de discovery con garantías no documentadas.

## 9.5 TOCTOU

Aun necesitaría un fence entre compatibility y segundo sign-in.

## 9.6 Privilegio

Podría empujar lógica extra al Hook.

## 9.7 Relación ADR-0019/TASK-013

Alteraría el significado de E2 usando el token gate como discovery gate.

## 9.8 Resultado

```text
REJECTED AS STANDALONE ARCHITECTURE
```

La separación en fases sí se conserva en la arquitectura seleccionada, pero sin un sign-in preliminar.

---

# 10. Alternativa 3 — durable provisioning/subject-discovery state purpose-specific

## 10.1 Mecanismo

Persistir antes del provider side effect una operación durable que reserve:

- logical operation;
- handoff;
- bridge;
- Auth subject UUID esperado.

## 10.2 Ventajas

- permite reconciliación;
- evita depender de email como autoridad;
- da identidad a la operación antes del side effect externo;
- permite modelar `UNKNOWN` sin retry ciego.

## 10.3 Seguridad

El estado reservado no concede autoridad.

## 10.4 Failure/recovery

Puede distinguir:

```text
subject reserved
provider unknown
provider confirmed
bridge bound
compatibility fenced
gate consumed
terminal
```

## 10.5 TOCTOU

Por sí solo no basta; necesita coordinación cross-flow durante issuance.

## 10.6 Privilegio

No exige nuevos privilegios provider beyond narrow Admin create/get.

## 10.7 Relación ADR-0019/TASK-013

Complementa E2 antes de la emisión.

## 10.8 Resultado

```text
ACCEPTED AS A COMPONENT OF THE SELECTED ARCHITECTURE
```

---

# 11. Alternativa 4 — provider lookup primitive

## 11.1 `getUserById`

Existe una primitive documentada para lookup por UUID exacto.

Es aceptable cuando la aplicación ya conoce el UUID.

## 11.2 Lookup por email

No se adopta ninguna primitive genérica de lookup por email.

La documentación oficial actual examinada no convierte `getUserById` en búsqueda por email.

## 11.3 Mecanismo seleccionado

Preasignar el UUID antes de `createUser` transforma el problema de reconciliación en exact-ID lookup.

## 11.4 Ventajas

- purpose-specific;
- bounded;
- no enumeration;
- no account discovery by email.

## 11.5 Seguridad

El UUID reservado debe ser server-generated y nunca caller authority.

## 11.6 Failure/recovery

`getUserById(reserved_uuid)` reconcilia un create success cuyo acknowledgement se perdió.

## 11.7 TOCTOU

No resuelve por sí mismo application-authority TOCTOU; se combina con fence.

## 11.8 Privilegio

Requiere Auth Admin en frontera purpose-specific.

## 11.9 Relación ADR-0019/TASK-013

No modifica el gate E2.

## 11.10 Resultado

```text
ACCEPTED ONLY AS EXACT-ID LOOKUP
```

---

# 12. Alternativa 5 — generic provider enumeration

## 12.1 Mecanismo

`auth.admin.listUsers` + búsqueda application-side por email.

## 12.2 Ventajas

- puede encontrar una cuenta preexistente sin conocer su UUID.

## 12.3 Seguridad

- amplía innecesariamente exposición de identidad;
- convierte una operación purpose-specific en directorio general;
- aumenta riesgo de enumeración;
- email sigue sin ser autoridad de aplicación.

## 12.4 Failure/recovery

La paginación, concurrencia y cambios de email complican la reconciliación.

## 12.5 TOCTOU

No resuelve la carrera con application authority.

## 12.6 Privilegio

Privilegio excesivamente amplio.

## 12.7 Relación ADR-0019/TASK-013

No es requerido por E2.

## 12.8 Resultado

```text
REJECTED
```

---

# 13. Alternativa 6 — PostgreSQL lock/transaction abierta durante provider call

## 13.1 Mecanismo

Mantener un row lock/transaction mientras se ejecuta `createUser` o `signInWithPassword`.

## 13.2 Ventajas

Podría reducir carreras si todos los participantes usaran el mismo lock.

## 13.3 Seguridad / disponibilidad

- bloquea una transacción DB durante network I/O;
- acopla disponibilidad DB/proveedor;
- aumenta deadlocks/timeouts;
- no crea atomicidad distribuida real.

## 13.4 Failure/recovery

Un timeout remoto deja semántica incierta igualmente.

## 13.5 TOCTOU

Reduce una ventana local, pero no convierte el provider side effect en transacción PostgreSQL.

## 13.6 Privilegio

No mejora mínimo privilegio.

## 13.7 Relación ADR-0019/TASK-013

Contradice constraints ya preservados.

## 13.8 Resultado

```text
REJECTED
```

---

# 14. Alternativa 7 — tenant-aware Custom Access Token Hook

## 14.1 Mecanismo

Dar al Hook acceso a `PlatformUser`, `CompanyMembership`, tenant role o similares y decidir allí si emitir token.

## 14.2 Ventajas

La verificación ocurriría cerca de token issuance.

## 14.3 Seguridad

Viola la frontera aprobada:

```text
supabase_auth_admin tenant/application-authorization privileges =
NONE
```

y mezclaría:

```text
Auth token issuance
with
tenant authorization
```

## 14.4 Failure/recovery

Una indisponibilidad tenant podría convertirse en indisponibilidad global de Auth.

## 14.5 TOCTOU

Podría leer estado fresco, pero al precio de romper el privilege boundary.

## 14.6 Privilegio

Excesivo.

## 14.7 Relación ADR-0019/TASK-013

Modificación material no permitida del core E2.

## 14.8 Resultado

```text
REJECTED
```

---

# 15. Alternativa 8 — generic privileged/service-role resolver

## 15.1 Mecanismo

Crear un client server privilegiado reutilizable capaz de leer Auth + application tables y resolver identidad/autoridad.

## 15.2 Ventajas

Conveniencia de implementación.

## 15.3 Seguridad

Viola:

```text
generic privileged client = NO
ordinary service-role request path = NO
```

y debilita modularidad/mínimo privilegio.

## 15.4 Failure/recovery

Amplía blast radius.

## 15.5 TOCTOU

No resuelve la carrera por sí solo.

## 15.6 Privilegio

Inaceptable.

## 15.7 Relación ADR-0019/TASK-013

Contrario a sus fronteras.

## 15.8 Resultado

```text
REJECTED
```

---

# 16. Alternativa 9 — selected architecture

Se selecciona:

```text
S1 —
PREALLOCATED AUTH SUBJECT
+
PURPOSE-SPECIFIC EXACT-ID PROVIDER RECONCILIATION
+
DURABLE SUBJECT-AUTHORITY FENCE
+
FINAL ADR-0019 E2 SESSION ISSUANCE
```

Forma resumida:

```text
TASK-020 handoff
→ durable coordination start
→ resolve or preallocate exact Auth subject UUID
→ provider identity confirm/provision without sign-in
→ bind bridge to exact subject
→ atomic application compatibility check + subject authority fence activation
→ final technical signInWithPassword
→ Custom Access Token Hook validates exact subject + active coordination + SessionGrant
→ SessionGrant consume
→ JWT/session issuance
→ post-provider authoritative compatibility revalidation
→ terminalize/release fence
→ only then deliver session to browser
→ AUTHENTICATED BUT NOT TENANT-AUTHORIZED at terminal commit
```

```text
SELECTED
```

---

# 17. Decisión arquitectónica

ADR-0022 propone adoptar S1.

## 17.1 Regla central

Un later-user unbound bridge **NO** descubrirá su Auth subject mediante un password sign-in preliminar.

En cambio:

```text
application generates exact expected Auth subject UUID
before provider mutation
```

y utiliza ese UUID en `auth.admin.createUser`.

## 17.2 Consecuencia sobre identidades provider preexistentes

Si un bridge está unbound y `createUser` entra en conflicto porque el mismo email ya pertenece a otro Auth subject distinto del UUID reservado:

```text
DO NOT enumerate
DO NOT adopt by email
DO NOT reset password
DO NOT issue discovery session
DO NOT merge identity
```

Resultado:

```text
PROVIDER_IDENTITY_CONFLICT / REPAIR_REQUIRED
```

ADR-0022 elige fail-closed en este caso.

Un Auth user preexistente sólo puede continuar automáticamente si el bridge ya está autoritativamente bound a su exact `auth_user_id`, o si la identidad se reconcilia como resultado de la propia operación de provisioning con UUID preasignado.

## 17.3 Narrow qualification de ADR-0019 E2

ADR-0019 E2 permanece:

```text
business proof = VerificationChallenge
provider proof = technical password
session authorization proof = SessionGrant
token issuance gate = Custom Access Token Hook
```

La nueva calificación later-user es:

```text
for TASK-021 later-user initial session
unbound subject discovery by successful preliminary signInWithPassword =
NOT ALLOWED
```

No se modifica el core E2.

## 17.4 Narrow qualification del Auth Admin boundary de TASK-013

TASK-013 había definido una allowlist cerrada de Auth Admin operations. ADR-0022 la califica de forma estrecha exclusivamente para el boundary later-user pre-issuance de TASK-021:

```text
For ADR-0022 / TASK-021 later-user pre-issuance reconciliation only:

auth.admin.getUserById(exact_expected_auth_subject_id) =
AUTHORIZED PURPOSE-SPECIFIC ADMIN OPERATION
```

Esta autorización significa únicamente lookup/reconciliation por el UUID exacto ya derivado autoritativamente o reservado por la operación lógica aprobada.

Continúa expresamente:

```text
getUserById arbitrary/caller-selected ID = NO
getUserById email-derived arbitrary directory search = NO
listUsers = NO
generic email lookup = NO
full-directory scan = NO
generic auth.admin export = NO
generic privileged Supabase client = NO
ordinary service-role business/data client = NO
```

Por tanto:

```text
ADR-0019 core E2 =
UNCHANGED

TASK-013 previous privileged Auth Admin allowlist =
NARROWLY QUALIFIED BY ADR-0022
ONLY FOR THE APPROVED LATER-USER PRE-ISSUANCE BOUNDARY

TASK-013 documentation/state-machine sync =
REQUIRED BEFORE IMPLEMENTATION
```

La futura sincronización de TASK-013 no puede convertir `getUserById` en generic repair capability ni ampliar otras operaciones Admin por inferencia.

---

# 18. Dos estados durables de coordinación

La arquitectura seleccionada utiliza dos conceptos técnicos platform-owned complementarios.

## 18.1 `AuthSubjectAuthorityAnchor`

Concepto durable estable por Auth subject.

Propósito exclusivo:

```text
full-UUID subject-scoped serialization anchor
for application/global/tenant authority mutations
and TASK-021 initial-session fence
```

No es:

- `PlatformUser`;
- `CompanyMembership`;
- tenant;
- role;
- client scope;
- session;
- JWT authority.

Identidad conceptual:

```text
auth_subject_id
```

El anchor puede existir antes de que el Auth user remoto quede confirmado, porque un UUID reservado no constituye autoridad.

## 18.2 `LaterUserInitialSessionCoordination`

Registro durable por operación lógica TASK-021.

Debe vincular de forma inmutable o authoritative:

- coordinación ID;
- TASK-020 authoritative handoff / `LaterUserEnrollmentIntent`;
- `AuthBridgeCredential`;
- `SessionGrant`;
- logical operation ID;
- target email source/binding by reference, sin convertir email en autoridad;
- reserved/confirmed Auth subject;
- lifecycle state;
- expiry;
- terminal result.

No puede contener un caller-selected tenant/role como autoridad.

## 18.3 Razón de dos conceptos

El attempt record conserva handoff/recovery/history.

El subject anchor proporciona una clave estable común para serializar carreras incluso cuando:

- todavía no existe `PlatformUser`;
- no existe `CompanyMembership`;
- todavía no existe mapping de aplicación;
- otra operación de autoridad comienza concurrentemente.

---

# 19. Lifecycle de `LaterUserInitialSessionCoordination`

Estados conceptuales mínimos:

```text
PREPARING
PROVISIONING_UNKNOWN
SUBJECT_CONFIRMED
ISSUANCE_ACTIVE
GATE_CONSUMED
SESSION_ESTABLISHED_NO_AUTHORITY
EXPIRED
ABANDONED
REPAIR_REQUIRED
```

## 19.1 `PREPARING`

- handoff validado;
- SessionGrant correlacionado;
- logical operation identificada;
- subject bound existente o UUID reservado;
- no authority fence todavía.

## 19.2 `PROVISIONING_UNKNOWN`

Sólo para un provider result ambiguo.

No habilita sign-in.

La única reconciliación automática autorizada es por exact reserved subject ID.

## 19.3 `SUBJECT_CONFIRMED`

El provider user exacto existe y el bridge está autoritativamente bound al subject.

Todavía no se ha demostrado compatibility freshness para session issuance.

## 19.4 `ISSUANCE_ACTIVE`

Se alcanza únicamente mediante una transacción que:

1. serializa por `AuthSubjectAuthorityAnchor`;
2. re-resuelve el subject;
3. verifica compatibilidad autoritativa de aplicación;
4. verifica que el SessionGrant siga elegible y no expirado;
5. activa el fence.

Mientras este estado está activo, ninguna operación coordinada puede crear o habilitar autoridad incompatible para el subject.

## 19.5 `GATE_CONSUMED`

El Custom Access Token Hook consumió el SessionGrant para el exact subject y método permitido.

No equivale todavía a haber entregado una sesión al browser.

El fence permanece activo.

## 19.6 `SESSION_ESTABLISHED_NO_AUTHORITY`

Terminal success.

Sólo puede confirmarse después de:

- provider sign-in success;
- exact subject match;
- post-provider authoritative compatibility revalidation bajo el mismo anchor;
- no authority drift;
- preparación segura para entregar/propagar la sesión.

El commit que marca este estado libera el fence.

Éste es el punto temporal en el que TASK-021 puede demostrar:

```text
AUTHENTICATED BUT NOT TENANT-AUTHORIZED
```

## 19.7 `EXPIRED`

Se alcanza cuando el SessionGrant/coordination deja de ser elegible antes de completar el flujo.

No se reactiva el grant.

## 19.8 `ABANDONED`

Terminación explícita de un attempt que no produjo sesión y cuya reconciliación demostró que no existe un side effect remoto pendiente que deba seguir investigándose.

## 19.9 `REPAIR_REQUIRED`

Ambigüedad o incompatibilidad no automatizable, incluyendo provider identity preexistente por email pero con subject no autoritativamente conocido.

No permite fallback privilegiado.

---

# 20. TTL y relación con SessionGrant

ADR-0022 no cambia:

```text
SessionGrant TTL =
EXACTLY 5 MINUTES
```

La coordinación de initial session:

```text
must not authorize issuance beyond SessionGrant.expires_at
```

El fence activo tampoco debe convertirse en autorización de session más allá del grant.

Si el grant expira:

```text
initial issuance attempt =
FAIL CLOSED

grant resurrection =
NO

automatic TTL extension =
NO
```

ADR-0022 no crea un mecanismo de reemisión ilimitada de `SessionGrant`.

Cualquier recovery posterior que requiera nueva proof/grant debe utilizar el recovery aprobado por ADR-0019/TASK-020 o ser determinado separadamente; no se inventa en este ADR.

---

# 21. Ordering exacto — bound bridge

Para:

```text
AuthBridgeCredential.auth_user_id IS NOT NULL
```

el orden es exactamente:

1. resolver autoritativamente el TASK-020 handoff;
2. reconciliar/create the logical `LaterUserInitialSessionCoordination`;
3. tomar como expected subject exclusivamente `AuthBridgeCredential.auth_user_id`;
4. ensure/reconcile `AuthSubjectAuthorityAnchor` para ese subject;
5. ejecutar `auth.admin.getUserById(expected_subject)` mediante Auth Admin boundary purpose-specific;
6. requerir provider user existente y correlación de email/bridge válida;
7. bind/check coordination al exact subject;
8. entrar en transacción DB corta;
9. serializar mediante el subject anchor;
10. revalidar handoff, bridge, grant y exact subject;
11. ejecutar application compatibility check autoritativo;
12. si compatible, activar `ISSUANCE_ACTIVE`;
13. commit/release DB transaction;
14. fuera de cualquier DB lock, ejecutar `signInWithPassword` con email bound + technical password;
15. Custom Access Token Hook recibe `user_id`;
16. Hook exige exact expected subject;
17. Hook exige `authentication_method = password`;
18. Hook exige `ISSUANCE_ACTIVE` vigente;
19. Hook exige exact eligible `SessionGrant`;
20. Hook consume atómicamente el SessionGrant y marca `GATE_CONSUMED`;
21. Supabase puede emitir JWT/session conforme a ADR-0019;
22. trusted server recibe el resultado y NO lo entrega todavía al browser;
23. entrar en segunda transacción DB corta;
24. serializar por el mismo subject anchor;
25. revalidar application compatibility y coordination state;
26. marcar `SESSION_ESTABLISHED_NO_AUTHORITY`;
27. liberar el fence en el mismo commit;
28. sólo después del commit exitoso, propagar la sesión/cookies al browser;
29. converger al siguiente boundary aprobado de TASK-021.

No se mantiene un DB lock durante los pasos 14–22.

---

# 22. Ordering exacto — unbound bridge

Para:

```text
AuthBridgeCredential.auth_user_id IS NULL
```

el orden es exactamente:

1. resolver autoritativamente el TASK-020 handoff;
2. reconcile/create `LaterUserInitialSessionCoordination`;
3. generar server-side un UUID v4 nuevo como `reserved_auth_subject_id`;
4. persistir durablemente ese UUID en la misma logical coordination antes de provider mutation;
5. ensure/reconcile `AuthSubjectAuthorityAnchor` para el UUID reservado;
6. comprobar mediante `auth.admin.getUserById(reserved_uuid)` que no se está adoptando accidentalmente un subject ya existente;
7. si el reserved UUID ya existe antes del provisioning attempt, comparar únicamente para detectar colisión/inconsistencia y fallar cerrado; no adoptarlo;
8. ejecutar una única operación lógica purpose-specific `auth.admin.createUser` con:
   - `id = reserved_uuid`;
   - email bound;
   - technical password server-only;
   - demás parámetros heredados del bridge aprobado;
9. si `createUser` responde success, exigir `returned_user.id = reserved_uuid`;
10. si la respuesta es perdida/ambigua, entrar en `PROVISIONING_UNKNOWN`;
11. reconciliar exclusivamente mediante `auth.admin.getUserById(reserved_uuid)`;
12. si exact user existe y su email/provider correlation es la esperada, confirmar el subject;
13. si exact user no puede determinarse por outage, permanecer `PROVISIONING_UNKNOWN`; no sign-in y no createUser ciego;
14. si provider responde de forma confiable que el exact UUID no existe, la misma logical operation puede realizar un **guarded replay** de `createUser` sólo con el mismo reserved UUID y mismos bindings, nunca con un UUID/email alternativo;
15. si `createUser` devuelve duplicate/conflict y exact reserved UUID no existe, marcar `REPAIR_REQUIRED`;
16. una vez provider subject confirmado, bind `AuthBridgeCredential.auth_user_id = reserved_uuid` mediante la frontera autoritativa aprobada;
17. marcar coordination `SUBJECT_CONFIRMED`;
18. entrar en transacción DB corta;
19. serializar mediante `AuthSubjectAuthorityAnchor`;
20. revalidar bridge binding, handoff, exact subject y SessionGrant;
21. ejecutar application compatibility autoritativa;
22. si compatible, activar `ISSUANCE_ACTIVE`;
23. commit/release;
24. ejecutar final `signInWithPassword`;
25. Hook exige exact subject + password method + active coordination + eligible grant;
26. Hook consume SessionGrant y marca `GATE_CONSUMED`;
27. Supabase emite JWT/session conforme a ADR-0019;
28. trusted server retiene el resultado sin exponerlo todavía al browser;
29. transacción final por subject anchor;
30. revalidar compatibility;
31. marcar `SESSION_ESTABLISHED_NO_AUTHORITY` y liberar fence atómicamente;
32. sólo entonces propagar la sesión/cookies.

No existe un preliminary/discovery sign-in.

---

# 23. `createUser` ambiguous-result recovery

## 23.1 Precondition

El Auth subject UUID existe durablemente en aplicación **antes** del provider side effect.

## 23.2 Response lost after provider commit

```text
createUser(reserved_uuid) committed
+
response lost
```

se reconcilia con:

```text
getUserById(reserved_uuid)
```

Si existe el exact user esperado:

```text
provider provisioning =
RECONCILED
```

No se repite ciegamente la creación.

## 23.3 Exact subject absent

Si un provider response confiable demuestra:

```text
getUserById(reserved_uuid) =
NOT FOUND
```

la logical operation puede reintentar únicamente el mismo provisioning command con:

```text
same reserved UUID
same bound email
same purpose
same handoff
same bridge
same operation identity
```

Esto es un guarded replay, no un blind create.

## 23.4 Duplicate email / subject distinto

Si el provider rechaza creación porque existe una identidad incompatible y:

```text
getUserById(reserved_uuid) =
NOT FOUND
```

no se intenta encontrar “qué otro user tiene ese email”.

Resultado:

```text
REPAIR_REQUIRED
```

## 23.5 Prohibiciones

No usar:

- `listUsers`;
- full-directory scan;
- password reset/takeover;
- magiclink;
- OTP;
- recovery;
- update password de identidad desconocida;
- email → PlatformUser resolution;
- manual user ID caller-supplied.

---

# 24. Application compatibility

La compatibilidad se resuelve sólo después de conocer un exact Auth subject y antes de la emisión final.

## 24.1 Compatible sin application identity

```text
no Auth subject → PlatformUser mapping
→ compatible for TASK-021
```

porque TASK-021 no crea tenant authority ni `PlatformUser`.

## 24.2 Compatible application identity existente

Si existe mapping:

```text
Auth subject
→ PlatformUser
```

sólo es compatible cuando el estado autoritativo actual demuestra simultáneamente:

```text
is_super_admin = false
AND
no CompanyMembership exists for that PlatformUser
```

La inexistencia de membership debe incluir enabled y disabled memberships; no puede inferirse de una lectura RLS que oculte disabled state.

## 24.3 Incompatible

Fail closed ante:

- `is_super_admin = true`;
- cualquier `CompanyMembership`, enabled o disabled;
- mapping inconsistente;
- multiple/ambiguous identity condition;
- lookup failure;
- cross-identity correlation;
- bridge subject mismatch;
- provider subject mismatch.

## 24.4 Email

Nunca:

```text
email
→ PlatformUser
→ authority
```

El email sólo verifica correlación de la intención/bridge/provider identity esperada.

---

# 25. Freshness y subject-authority fence

## 25.1 Regla

El compatibility result no se considera suficiente hasta que, en la **misma transacción DB** que lo verifica, se active:

```text
subject authority fence =
ISSUANCE_ACTIVE
```

bajo el `AuthSubjectAuthorityAnchor`.

## 25.2 Función del fence

Mientras está activo, cualquier flow participante que pudiera:

- crear Auth subject → `PlatformUser` mapping;
- relink/mover dicho mapping;
- crear una `CompanyMembership`;
- habilitar/reintegrar una membership;
- elevar/cambiar una role de una membership enabled;
- establecer `is_super_admin = true`;
- producir otra autoridad de aplicación incompatible para ese subject;

debe serializar por el mismo anchor y:

```text
active TASK-021 fence
→ mutation must not commit
```

Puede:

- esperar boundedly y revalidar después del terminal; o
- fallar con retryable conflict;

según defina la futura task física.

No puede ignorar el fence.

La adquisición del anchor debe respetar la precedencia cross-flow normativa de §26.7. Un flow que ya deba adquirir una clase de lock anterior según §26.7 no puede tomar primero el anchor y después retroceder a esa clase.

## 25.3 No lock remoto

El fence es durable state.

No se mantiene row lock durante:

- `createUser`;
- `getUserById`;
- `signInWithPassword`;
- network I/O.

## 25.4 Terminal revalidation

Antes de liberar el fence tras session success, la aplicación vuelve a verificar bajo el mismo anchor que la compatibilidad continúa vigente.

Así:

```text
precheck
+
durable fence
+
terminal recheck
```

eliminan la ventana T1/T2/T3 dentro de los flows coordinados.

---

# 26. Cross-flow coordination

## 26.1 TASK-019

TASK-019 puede crear/reconciliar:

- `PlatformUser`;
- Auth-subject mapping;
- initial `CompanyMembership`.

Por ello es un writer material.

La corrección aprobada `CORR-035-task-019-cross-task-actor-company-lock-graph-correction.md` ya estableció para TASK-019 el suborden efectivo:

```text
historical actor PlatformUser FOR KEY SHARE
→ MaintenanceCompany FOR UPDATE
→ FirstAdminOnboardingIntent FOR UPDATE
→ target identity
→ CompanyMembership
```

ADR-0022 no revierte ese orden. Añade el subject anchor **después** de los locks actor/company/intent ya exigidos y **antes** de target identity/membership authority rows:

```text
historical actor PlatformUser FOR KEY SHARE
→ MaintenanceCompany FOR UPDATE
→ FirstAdminOnboardingIntent FOR UPDATE
→ AuthSubjectAuthorityAnchor
→ target Auth-subject / PlatformUser
→ CompanyMembership
→ authority-producing mutation
```

El exact subject de TASK-019 ya deriva de su sesión/handoff autoritativo; no se acepta del caller.

Antes de cualquier commit capaz de crear application/tenant authority para ese subject, TASK-019 debe inspeccionar el active fence bajo el mismo anchor y deny/defer ante `ISSUANCE_ACTIVE` o `GATE_CONSUMED`.

TASK-019 posee además un riesgo específico de alias físico: el `PlatformUser` histórico prebloqueado por CORR-035 puede ser físicamente la misma fila que el `PlatformUser` ya mapeado desde el exact target Auth subject. Por ello, antes de intentar el anchor debe ejecutar un alias precheck purpose-specific usando exclusivamente el exact subject ya correlacionado por handoff/session y DB state; email y caller input no participan.

Si ese precheck ya demuestra:

```text
target Auth subject → PlatformUser P
AND
historical initiating actor PlatformUser = P
```

TASK-019 falla cerrado **antes de esperar** por `AuthSubjectAuthorityAnchor`; no crea tenant authority ni intenta adoptar/relinkear identidad.

Como ese precheck puede quedar stale frente a un writer concurrente que ya sostenga el anchor, TASK-019 no puede realizar una espera bloqueante por el target anchor mientras mantiene el historical actor/company/intent locks. Para esta transición exacta debe utilizar semántica de adquisición **non-waiting / fail-fast** del anchor: si el anchor está ocupado, la transacción actual aborta/falla retryably y libera sus locks existentes; no espera formando `P → anchor(S)` y no hace unlock-and-switch dentro de la misma operación.

Si la adquisición fail-fast del anchor tiene éxito, TASK-019 re-resuelve bajo ese anchor el exact subject mapping. Si ahora el mapped `PlatformUser` coincide con cualquier `PlatformUser` row que la transacción ya mantiene como lock de una clase anterior, el resultado es fail-closed antes de adquirir target identity/membership locks. Si es distinto o no existe mapping, continúa únicamente con la precedencia de §26.7.

Este mecanismo no cambia CORR-035: actor histórico → company → intent permanece intacto. Cambia sólo la semántica de **espera** al alcanzar el anchor cuando existe una clase pre-anchor físicamente aliasable.

## 26.2 Future later-user membership creation

Cualquier futura capability que complete el later-user onboarding y cree su membership debe obedecer el mismo contrato.

Si el flow también requiere `MaintenanceCompany`/tenant serialization, debe adquirir ese lock antes del `AuthSubjectAuthorityAnchor` y no al revés.

ADR-0022 no implementa esa capability ni la adelanta.

## 26.3 TASK-015 — disable

`disable` es authority-reducing.

ADR-0022 no necesita prohibir una operación que únicamente reduce autoridad.

Sin embargo, un valid `ISSUANCE_ACTIVE` no debería coexistir con una membership preexistente porque compatibility rechaza cualquier membership.

Si aparece tal estado:

```text
coordination inconsistency =
FAIL CLOSED / REVIEW
```

## 26.4 TASK-015 — reinstate

`reinstate` habilita tenant authority.

Debe participar en ADR-0022. TASK-015 preserva primero su tenant-level serialization sobre `MaintenanceCompany`; sólo después de same-tenant authoritative revalidation puede adquirir el target `AuthSubjectAuthorityAnchor`.

Para localizar el anchor, una lectura preliminar o post-company de `target CompanyMembership → PlatformUser → platform_user_auth_subjects` puede usarse exclusivamente como **locator**, nunca como autoridad. Antes de mutar debe revalidarse bajo los locks correspondientes.

Para un participating TASK-015 writer:

```text
exactly one recognized Auth subject for target PlatformUser
→ continue

zero recognized Auth subjects
→ FAIL CLOSED / RETURN FOR REVIEW

more than one recognized Auth subject
→ FAIL CLOSED / RETURN FOR REVIEW
```

Esto no aprueba account linking, múltiples identities ni una cardinalidad inversa nueva.

## 26.5 TASK-015 — role change

Role change sobre una enabled membership cambia autoridad tenant vigente y debe respetar el mismo orden `MaintenanceCompany → AuthSubjectAuthorityAnchor → target membership` antes de commit.

Role change sobre una disabled membership no habilita autoridad inmediatamente y no se convierte por este ADR en un authority-producing writer. La existencia misma de esa membership continúa siendo incompatible con un valid `ISSUANCE_ACTIVE`; cualquier coexistencia detectada falla cerrada para session issuance.

## 26.6 `is_super_admin`

Cualquier futura capability capaz de establecer:

```text
is_super_admin = true
```

debe participar en el mismo contract antes de commit.

Si ese flow necesita además tenant/company locks, debe respetar §26.7. No se crea aquí esa capability.

## 26.7 Precedencia canónica cross-flow

La precedencia normativa para cualquier transacción participante es:

```text
0. preliminary purpose-specific locator reads
   - NO row lock required by this ADR
   - NOT authority
   - MUST be revalidated after authoritative locks

1. existing approved pre-company provenance/global-actor lock, when the flow already requires one
   - e.g. TASK-019 historical actor PlatformUser FOR KEY SHARE under CORR-035

2. MaintenanceCompany / tenant serialization lock, when the flow mutates tenant authority

3. FirstAdminOnboardingIntent or another already-approved tenant intent lock that is ordered after MaintenanceCompany in that flow
   - preserves MaintenanceCompany → FirstAdminOnboardingIntent

4. AuthSubjectAuthorityAnchor for the exact target Auth subject

5. target Auth-subject mapping / PlatformUser authority rows, when required

6. CompanyMembership authority rows, when required

7. AuthBridgeCredential, when an authoritative row lock is required

8. LaterUserInitialSessionCoordination

9. SessionGrant

10. authority mutation / coordination terminalization / commit
```

Reglas obligatorias:

```text
transaction acquires both MaintenanceCompany and AuthSubjectAuthorityAnchor
→ MaintenanceCompany MUST be first

transaction acquires AuthSubjectAuthorityAnchor without MaintenanceCompany
→ it MUST NOT later acquire MaintenanceCompany or another earlier lock class

transaction acquires both FirstAdminOnboardingIntent and AuthSubjectAuthorityAnchor
→ MaintenanceCompany → FirstAdminOnboardingIntent → AuthSubjectAuthorityAnchor

lock-order inversion
→ PROHIBITED
```

La regla evita simultáneamente:

- `tenant/company → subject anchor` en un writer y `subject anchor → tenant/company` en otro;
- reabrir el deadlock graph corregido por CORR-035;
- lockear un subject cross-tenant basándose sólo en un target ID no autorizado;
- convertir el anchor en global mutex.

### 26.7.1 Writers que comienzan desde `CompanyMembership` o `PlatformUser`

Un writer que no recibe un exact Auth subject desde una binding autoritativa aprobada puede usar sólo una resolución purpose-specific de DB como locator.

Debe quedar:

```text
caller-supplied Auth subject as authority = NO
email → Auth subject authority = NO
account-linking inference = NO
multiple-identity feature inference = NO
```

Para el contract ADR-0022, si la resolución defensiva del target produce cero o más de un mapping reconocido y la operación necesita participar en el fence:

```text
coordination target = NOT UNIQUELY RESOLVABLE
→ FAIL CLOSED / RETURN FOR REVIEW
```

No se bloquean múltiples anchors como forma silenciosa de aprobar múltiples identities.

### 26.7.2 Revalidación

Todo ID obtenido antes de su lock autoritativo es locator provisional.

Después de adquirir la secuencia aplicable, el writer debe revalidar como mínimo:

- same exact Auth subject;
- same target PlatformUser/mapping;
- same tenant/company cuando aplique;
- mismo estado de membership relevante;
- active fence state;
- cualquier invariant preexistente del flow.

Un cambio o ambigüedad produce fail-closed, no unlock-and-switch a otro subject dentro de la misma operación.

### 26.7.3 Physical-row alias closure

El orden por clases semánticas es insuficiente cuando dos clases pueden referirse a la misma fila física. ADR-0022 impone además:

```text
physical-row alias across lock classes
MUST NOT create opposite blocking wait edges
```

Regla bounded para el grafo afectado por este ADR:

1. todo flow participante identifica los aliases físicos materialmente posibles entre sus clases de lock;
2. un `PlatformUser` row adquirido antes del anchor no puede combinarse con una espera bloqueante por un anchor cuyo exact subject pueda resolver después al mismo row;
3. si un precheck autoritativamente correlacionado ya demuestra ese alias, el flow falla cerrado antes de esperar el anchor;
4. si la distinción podría cambiar concurrentemente, el flow que ya retiene el row pre-anchor debe usar adquisición non-waiting/fail-fast del anchor; anchor ocupado implica abort/retry de la transacción, no wait edge;
5. después de adquirir el anchor, el mapping exacto se revalida antes de cualquier lock post-anchor sobre target identity/authority rows; alias detectado en ese punto implica fail-closed;
6. no se bloquean múltiples anchors como workaround;
7. no se infiere account linking, múltiples identities ni una cardinalidad de producto nueva;
8. si un flow que empieza en el anchor necesita después bloquear un `PlatformUser` que podría ser una fila pre-anchor retenida por otro participating flow, esa operación sólo es válida si el otro flow aplica esta regla fail-fast o si la no-aliasing está demostrada por una invariante canónica; si ninguna condición puede probarse, STOP / RETURN FOR REVIEW.

La propiedad de concurrencia exigida es:

```text
no transaction may wait P → anchor(S)
while another participating transaction may hold anchor(S) → wait P
for the same physical P/S pair
```

Una adquisición fail-fast exitosa no crea ese ciclo: si otro writer ya mantiene el anchor, el flow pre-anchor aborta sin esperar; si el flow pre-anchor obtiene el anchor primero, el writer anchor-first espera sólo por el anchor y no puede mantener simultáneamente el mismo anchor contra ese flow.

Esta regla es purpose-specific para ADR-0022 y no crea un framework global de locking.

### 26.7.4 TASK-021 compatibility reads bajo el anchor

TASK-021 no necesita row locks sobre target `PlatformUser`, Auth-subject mapping ni `CompanyMembership` **sólo para demostrar compatibility/freshness**. Después de adquirir el exact `AuthSubjectAuthorityAnchor`, realiza lecturas purpose-specific frescas; los writers capaces de cambiar mapping, membership authority o `is_super_admin` deben participar en el mismo anchor antes de commit.

Por tanto TASK-021 no crea por sí misma un wait edge:

```text
AuthSubjectAuthorityAnchor → target PlatformUser row lock
```

para el mero compatibility check o terminal recheck. Si una futura implementación demuestra que necesita tal row lock por una razón adicional, debe probar primero row-alias safety conforme a §26.7.3 o detenerse para revisión.

## 26.8 Custom Access Token Hook dentro del grafo

El Hook no adquiere:

- `MaintenanceCompany`;
- `FirstAdminOnboardingIntent`;
- `PlatformUser` como authority row;
- `CompanyMembership`;
- tenant/application authorization locks.

Si necesita row locking platform-owned para su atomic gate, utiliza exclusivamente el sufijo compatible:

```text
AuthSubjectAuthorityAnchor
→ AuthBridgeCredential, when locked
→ LaterUserInitialSessionCoordination
→ SessionGrant
```

El Hook puede empezar en el anchor porque no adquiere después ninguna clase anterior del grafo. Tampoco adquiere target `PlatformUser`, Auth-subject mapping ni `CompanyMembership` row locks: su gate se limita al estado platform-owned indicado arriba.

## 26.9 No global mutex

La serialización es:

```text
per exact Auth subject
```

No existe un mutex global de onboarding, tenant o plataforma.

---

# 27. Custom Access Token Hook qualification

## 27.1 Preserved role

El Hook continúa siendo:

```text
PLATFORM-OWNED AUTH GATE
```

No se convierte en application authorization.

## 27.2 Inputs relevantes

Para initial password sign-in debe poder comprobar:

- `user_id` exacto;
- `authentication_method = password`;
- SessionGrant exacto;
- bridge subject binding;
- active coordination para ese subject;
- coordinación no expirada;
- grant no consumido.

## 27.3 Atomic action

En el gate final:

```text
eligible SessionGrant
+
exact subject
+
ISSUANCE_ACTIVE coordination
→ consume grant exactly once
→ mark GATE_CONSUMED
```

dentro de la frontera platform-owned.

Si necesita locks explícitos, debe seguir exclusivamente el suffix de §26.8 y nunca adquirir tenant/application authority locks después del anchor.

## 27.4 Prohibiciones de privilegio

El Hook no consulta ni autoriza mediante:

- `company_memberships`;
- tenant role;
- client scope;
- support grant;
- subscription entitlement;
- tenant operational data.

No se conceden tales privilegios a `supabase_auth_admin`.

El acceso al `AuthSubjectAuthorityAnchor`, bridge, coordination y SessionGrant es exclusivamente platform-owned y purpose-specific para E2; no concede autoridad tenant.

## 27.5 Token refresh

ADR-0019 token-refresh semantics permanecen.

Un refresh de una sesión ya establecida:

```text
!= initial session issuance
```

y no requiere repetir TASK-021 compatibility/fence.

La autorización tenant vigente continúa resolviéndose desde el estado PostgreSQL actual/RLS, no desde una claim stale.

---

# 28. Browser/session delivery boundary

## 28.1 Provider success no basta

Un `signInWithPassword` provider success devuelve tokens/session al trusted server, pero ADR-0022 exige una finalización DB antes de entregar esa autoridad de autenticación al browser.

## 28.2 Delivery ordering

```text
provider session result
→ terminal DB compatibility recheck
→ coordination terminal commit
→ browser cookie/session propagation
```

No:

```text
provider session result
→ browser receives cookies
→ later compatibility check
```

## 28.3 Lost response after grant consume

ADR-0019 continúa gobernando:

```text
grant consumed
+
tokens not proven delivered
→ fail closed
→ grant not resurrected
```

ADR-0022 añade que el subject fence permanece hasta:

- terminal recovery decision; o
- expiry/abandonment conforme al estado autoritativo.

No se usa un response perdido como autorización para crear otro grant.

---

# 29. Idempotency y retries

## 29.1 Logical operation identity

Un retry de la misma operación debe conservar:

- handoff;
- bridge;
- reserved/confirmed subject;
- coordination identity;
- SessionGrant identity;
- operation identity.

No puede seleccionar un email, subject o tenant alternativo.

## 29.2 Single active semantics

Por una combinación autoritativa de handoff + purpose:

```text
at most one active TASK-021 initial-session coordination
```

y por subject:

```text
at most one active initial-session authority fence
```

## 29.3 Same-operation retry

Reconcilia el estado existente.

No crea otro subject si ya existe un reserved/confirmed subject.

## 29.4 Different-operation concurrent attempt

No puede sustituir silenciosamente un attempt activo.

Debe conflict/fail closed hasta terminal/expiry según la futura specification.

---

# 30. Expiry, abandonment, cleanup y retention

## 30.1 Expiry

El effective issuance window no supera el SessionGrant.

Al expirar:

- Hook debe negar initial issuance;
- provider sign-in no debe crear una sesión utilizable por este grant;
- coordination deja de autorizar;
- fence se terminaliza/libera mediante transición autoritativa.

## 30.2 Abandonment

Sólo una trusted server operation puede marcar abandonment después de reconciliar que no existe un resultado que deba preservarse como `GATE_CONSUMED` o success.

## 30.3 Cleanup

Cleanup de datos técnicos no puede borrar evidencia necesaria para:

- idempotency;
- ambiguous-result reconciliation;
- security review;
- proof de terminal state.

## 30.4 Retention

ADR-0022 exige conservar al menos los facts históricos mínimos de:

- operation identity;
- handoff binding;
- subject reservation/binding;
- terminal state;
- timestamps de state transitions relevantes.

No fija aquí un período comercial/legal de retención ni autoriza un payload JSON arbitrario.

---

# 31. Failure model

## 31.1 Provider exact-ID lookup outage

```text
result =
PROVISIONING_UNKNOWN / DENY
```

No fallback a listUsers.

## 31.2 createUser timeout

```text
reserved UUID remains authoritative locator
→ getUserById(reserved UUID)
→ reconcile or remain unknown
```

## 31.3 createUser duplicate + reserved ID absent

```text
REPAIR_REQUIRED
```

No email enumeration.

## 31.4 createUser success + bridge bind DB failure

Reconcile provider by reserved ID.

Retry same application operation to bind the bridge; no new user creation.

## 31.5 compatibility lookup failure

```text
DENY
```

No session.

## 31.6 fence activation transaction failure

No sign-in.

## 31.7 provider sign-in failure before Hook consume

Si el grant sigue autoritativamente unconsumed y coordination sigue active/unexpired, el mismo logical attempt puede reintentar conforme a ADR-0019.

No se crea un nuevo grant.

## 31.8 Hook timeout/ambiguous

Reconcile SessionGrant + coordination.

Si no puede determinarse inequívocamente:

```text
DENY
```

## 31.9 Hook consumed + provider response lost

Preservar ADR-0019:

```text
grant does not reactivate
session delivery not proven
→ fail closed
```

## 31.10 Terminal recheck detects authority

Esto indica una violación del cross-flow coordination contract o mutación fuera de los writers coordinados.

Resultado:

```text
DO NOT deliver browser session
coordination = REPAIR_REQUIRED
security regression = FAIL
```

RLS/current authority sigue siendo la defensa remota primaria.

## 31.11 Coordination target no resoluble

Para un authority-producing writer que deba participar en ADR-0022:

```text
exact subject anchor cannot be resolved uniquely
→ FAIL CLOSED / RETURN FOR REVIEW
→ no authority mutation
```

No se adopta un subject desde email ni se bloquean múltiples anchors para inferir una feature de múltiples identities.

## 31.12 Deadlock / lock-order regression

Si una prueba concurrente reproduce `SQLSTATE 40P01`, hang no bounded o evidencia una inversión contra §26.7:

```text
security/concurrency regression = FAIL
implementation = STOP
RETURN TO REVISOR CENTRAL
```

No se repara introduciendo global mutex, advisory platform lock ni lock a través de provider network I/O.

## 31.13 Physical-row alias detectado

Si un exact target Auth subject ya resuelve a un `PlatformUser` que es físicamente la misma fila que un `PlatformUser` pre-anchor mantenido por la transacción, en particular el historical initiating actor de TASK-019:

```text
FAIL CLOSED BEFORE BLOCKING ANCHOR WAIT
no authority mutation
no identity relink
no partial state
```

## 31.14 Anchor ocupado durante alias-unsafe window

Si un flow ya mantiene una fila pre-anchor potencialmente aliasable y el target `AuthSubjectAuthorityAnchor` no puede adquirirse inmediatamente:

```text
current transaction = ABORT / RETRYABLE CONFLICT
blocking wait = NO
unlock-and-switch = NO
```

El retry futuro vuelve a resolver desde estado autoritativo actual. Si mapping/alias se vuelve ambiguo o cambia de forma que la safety no puede probarse, falla cerrado y vuelve a revisión.

---

# 32. Security implications

## 32.1 Positive

- elimina preliminary session issuance para subject discovery;
- elimina need de Auth enumeration;
- lost create response es reconciliable por exact ID;
- compatibility se mantiene fresca mediante durable fence;
- tenant authorization no entra al Auth Hook;
- provider admin boundary queda estrecho.

## 32.2 Tradeoffs

- introduce nuevo state platform-owned;
- introduce invariant de coordinación transversal para authority-producing flows;
- un provider account preexistente con el mismo email pero subject desconocido requiere repair/manual path;
- TASK-019 y futuras membership creators deben respetar el anchor;
- implementación y pruebas de concurrencia aumentan.

## 32.3 Residual risk

Una mutación de autoridad que ignore deliberadamente el coordination contract puede romper el invariant.

Por ello las pruebas negativas de cross-flow son obligatorias antes de aprobar implementación.

---

# 33. Data implications

## 33.1 New platform-owned state

Conceptualmente se requieren:

```text
AuthSubjectAuthorityAnchor
LaterUserInitialSessionCoordination
```

La futura specification física decidirá nombres/tablas/constraints exactos sin cambiar la semántica de este ADR.

## 33.2 No tenant ownership

Ambos son platform-owned coordination state.

Referenciar un later-user intent ligado a una `MaintenanceCompany`:

```text
!= tenant authority
```

## 33.3 No new business entity

Son arquitectura técnica de Auth/coordination.

No crean un nuevo actor, role ni requirement de usuario.

## 33.4 No schema executable here

Este ADR no contiene:

- SQL;
- migrations;
- indexes;
- RLS executable;
- grants executable;
- RPC definitions.

---

# 34. RLS / privilege implications

## 34.1 Tenant data

Tenant RLS permanece sin debilitarse.

## 34.2 Platform-owned coordination

Browser/ordinary `authenticated` no debe obtener lectura o escritura general del coordination state.

## 34.3 Hook privilege

`supabase_auth_admin` recibe únicamente el mínimo acceso purpose-specific necesario para E2 gate sobre platform-owned auth state.

```text
supabase_auth_admin → CompanyMembership privilege =
NONE
```

```text
supabase_auth_admin → tenant role privilege =
NONE
```

## 34.4 Auth Admin credential

La secret/server Admin credential sólo vive en la boundary Auth purpose-specific.

No se convierte en generic server data client.

---

# 35. Multitenancy implications

El tenant no se deriva de:

- email;
- Auth subject por sí solo;
- SessionGrant;
- browser request;
- JWT claim;
- coordination row.

TASK-021 finaliza antes de crear `CompanyMembership`.

Una futura membership sólo puede pertenecer al tenant derivado por el later-user enrollment intent y su propia future specification; ADR-0022 no autoriza ese paso.

---

# 36. Offline implications

```text
TASK-021 initial session establishment =
ONLINE-ONLY
```

No se introduce:

- Dexie state;
- outbox;
- offline Auth admin;
- offline authority fence;
- local SessionGrant;
- local technical password.

La coordinación es remota/autoritativa.

---

# 37. UI implications

No se requiere una nueva UI por ADR-0022.

Errores externos deben permanecer bounded y no enumerar:

- si existe otro Auth account con el email;
- el UUID del user conflictivo;
- si existe un `PlatformUser`;
- si existe una membership;
- tenant/role/global authority.

`REPAIR_REQUIRED` puede existir como outcome interno/operacional sin exponer identidad ajena al browser.

---

# 38. Audit implications

ADR-0022 no añade automáticamente una nueva `AuditEvent` action.

La coordinación de Auth es technical/platform-owned state y no equivale a una mutación tenant funcional.

Si una futura specification necesita auditoría histórica adicional:

```text
new exact action/shape
→ separate approved specification
```

No se reutilizan acciones existentes con semántica falsa.

---

# 39. Impacto sobre ADR-0019

```text
ADR-0019 core E2 modified =
NO
```

Se añade una calificación later-user:

```text
before initial E2 sign-in for TASK-021
exact Auth subject must already be known
+
application compatibility must already be proven
+
durable subject fence must be active
```

E2 sigue decidiendo el permiso para **emitir el token/sesión**, no el permiso tenant.

ADR-0022 no supersede ADR-0019 globalmente.

Relación:

```text
ADR-0019 =
base Auth/session gate

ADR-0022 =
narrow later-user pre-issuance qualification + serialization
```

---

# 40. Impacto sobre TASK-013

TASK-013 necesita futura adaptación física/state-machine porque su unbound branch histórico puede usar sign-in para subject binding y porque su Auth Admin boundary previo contiene una allowlist cerrada anterior a ADR-0022.

Para TASK-021:

```text
unbound preliminary signInWithPassword =
DISALLOWED
```

El bridge debe quedar bound antes del final sign-in.

El Hook debe entender la coordinación `ISSUANCE_ACTIVE`/`GATE_CONSUMED` sin obtener autoridad tenant.

ADR-0022 además introduce la siguiente qualification estrecha del privileged Auth Admin surface:

```text
auth.admin.getUserById(exact_expected_auth_subject_id) =
AUTHORIZED ONLY FOR ADR-0022 / TASK-021
PURPOSE-SPECIFIC PRE-ISSUANCE RECONCILIATION
```

Continúa:

```text
arbitrary getUserById = NO
caller-selected Auth subject lookup = NO
email-derived directory lookup = NO
listUsers = NO
generic auth.admin = NO
generic privileged client = NO
```

Por ello:

```text
ADR-0019 core E2 = UNCHANGED
TASK-013 privileged Auth Admin allowlist = NARROWLY QUALIFIED
TASK-013 documentation/state-machine sync = REQUIRED BEFORE IMPLEMENTATION
```

La futura implementación no puede modificar TASK-013 hasta que:

- ADR-0022 sea re-revisado y human-approved mediante Gates separados;
- TASK-021 corregida sea revisada/aprobada;
- la sincronización documental/state-machine requerida haya sido especificada/aprobada;
- exista autorización de implementación separada.

---

# 41. Impacto sobre TASK-020

```text
TASK-020 handoff contract impact =
NO
```

El handoff sigue demostrando business-proof completion y entrega la correlación previa requerida.

ADR-0022 no cambia:

- LaterUserEnrollmentIntent purpose;
- VerificationChallenge product contract;
- proof semantics;
- target tenant/role business binding;
- RF-013..RF-017.

La coordinación comienza **después** del handoff de TASK-020.

---

# 42. Impacto sobre TASK-019 y TASK-015

## 42.1 TASK-019

No se reabre su first-admin happy path.

Sí se establece una invariant transversal:

```text
authority-producing writer for same Auth subject
must respect active ADR-0022 subject fence
```

La futura specification deberá determinar la modificación/regression coverage exacta necesaria.

## 42.2 TASK-015

No crea memberships.

Interaction:

```text
disable =
authority reducing / not blocked merely by ADR-0022

reinstate =
authority enabling / must respect fence

enabled membership role-change =
authority changing / must respect fence
```

Cualquier coexistencia de valid `ISSUANCE_ACTIVE` con una preexisting membership indica drift/inconsistency porque compatibility debe haberla rechazado.

---

# 43. No new product requirement

ADR-0022 no cambia:

- roles;
- RF-013..RF-017;
- client assignment requirement;
- Phase 2/Phase 3 boundary;
- code validity;
- attempt count;
- resend rules;
- SessionGrant 5-minute TTL;
- first-admin semantics;
- tenant model.

Es una decisión técnica/arquitectónica necesaria para implementar con seguridad un requirement ya determinado.

---

# 44. No microservices

Toda la solución debe permanecer dentro del monolito modular Next.js + Supabase.

No se introduce:

- identity microservice;
- lock service;
- external workflow engine;
- external session registry;
- distributed queue como requisito.

---

# 45. Testing implications

La futura implementation specification debe exigir, como mínimo, pruebas deterministas para:

## 45.1 Provider subject reservation

- UUID reserved antes de provider mutation;
- UUID caller-supplied rechazado;
- reserved UUID no es authority;
- UUID reservado generado server-side como UUID v4 por decisión de proyecto;
- bridge unbound no ejecuta preliminary sign-in.

## 45.2 createUser / exact-ID reconciliation

- create with exact reserved UUID;
- success returned exact UUID;
- wrong returned subject fails closed;
- response-lost reconciliation via exact `getUserById`;
- exact lookup outage remains unknown;
- duplicate email + reserved ID absent → repair;
- no listUsers;
- no password takeover;
- no arbitrary/caller-selected `getUserById`;
- no email-derived Auth directory lookup.

## 45.3 Compatibility

- no application mapping → compatible;
- mapped non-superadmin + no membership → compatible;
- `is_super_admin=true` → deny;
- enabled membership → deny;
- disabled membership → deny;
- lookup failure → deny;
- email mismatch → deny.

## 45.4 TOCTOU / cross-flow lock graph

Real concurrency, not sequential simulation:

- compatibility/fence vs TASK-019 membership creation;
- TASK-021 ↔ TASK-019 usando el lock graph vigente de CORR-035 extendido por el anchor;
- fence vs future later-user membership creator fixture;
- fence vs TASK-015 reinstate;
- fence vs TASK-015 enabled role change;
- competing TASK-021 attempts same subject;
- terminal release vs authority writer;
- participating TASK-015 writer con zero Auth mappings → fail closed;
- participating TASK-015 writer con >1 Auth mappings → fail closed;
- preliminary locator cambia antes de anchor/revalidation → fail closed;
- `ALIAS-01`: historical actor `PlatformUser P` = mapped target subject `S` PlatformUser, concurrentemente con writer que mantiene/usa `AuthSubjectAuthorityAnchor(S)` → TASK-019 fail closed, no blocking `P → anchor(S)`, no `40P01`, no hang, no authority mutation, no partial state;
- `ALIAS-02`: mapped target PlatformUser es distinto del historical actor → canonical ordering continúa, no false alias denial, no `40P01`;
- `ALIAS-03`: mapping/alias cambia o se vuelve ambiguo durante la ventana → fail closed/abort-retry, no lock-order inversion, no unlock-and-switch;
- anchor ocupado mientras TASK-019 retiene actor/company/intent potencialmente aliasables → fail-fast acquisition aborta sin espera y libera la transacción.

Required properties:

```text
no execution can commit
initial-session terminal success
and an incompatible authority mutation
inside the protected interval
```

and:

```text
TASK-021 ↔ TASK-019 = no SQLSTATE 40P01 / no hang
TASK-021 ↔ future membership writer = no SQLSTATE 40P01 / no hang
TASK-021 ↔ participating TASK-015 authority-increasing writer = no SQLSTATE 40P01 / no hang
physical alias P/S regression = no opposite blocking wait edges / no SQLSTATE 40P01 / no hang
```

Static/behavior tests deben verificar la precedencia §26.7, prohibir cualquier branch que adquiera `AuthSubjectAuthorityAnchor → MaintenanceCompany`, y verificar que un flow con `PlatformUser` pre-anchor potencialmente aliasable nunca realice una espera bloqueante por el target anchor.

## 45.5 Hook

- wrong subject → deny;
- wrong method → deny;
- missing coordination → deny;
- expired coordination → deny;
- wrong grant → deny;
- consumed grant → deny;
- one of two concurrent valid attempts consumes;
- Hook lock suffix = anchor → bridge/coordination/grant cuando esos locks sean necesarios;
- Hook no adquiere MaintenanceCompany/PlatformUser/CompanyMembership authority locks;
- no CompanyMembership privilege needed;
- no tenant table access.

## 45.6 Browser delivery

- provider session result is not propagated before terminal DB commit;
- final compatibility failure prevents cookie/session propagation;
- response loss after grant consume does not resurrect grant.

## 45.7 RLS/security regression

- tenant RLS unchanged;
- `SUPER_ADMIN` no tenant bypass;
- generic privileged client absent;
- ordinary service-role data path absent;
- Auth session alone grants no tenant access;
- no global mutex/advisory platform lock introduced.

---

# 46. Acceptance Criteria for ADR-0022 review

Cada criterio debe revisarse individualmente.

## Governance

**AC-0022-001.** ID exacto = `ADR-0022`.

**AC-0022-002.** Título exacto = `Later-User Auth Subject Discovery, Application Compatibility, and Initial Session Issuance Serialization`.

**AC-0022-003.** Status = `PROPOSED`.

**AC-0022-004.** Review state = `PENDING SECOND CENTRAL RE-REVIEW`.

**AC-0022-005.** El artefacto no se autoaprueba.

**AC-0022-006.** TASK-021 permanece bloqueada durante generation/review.

## Canon / invariants

**AC-0022-007.** `tenant = MaintenanceCompany`.

**AC-0022-008.** `authenticated != authorized`.

**AC-0022-009.** Auth session no equivale a tenant authorization.

**AC-0022-010.** current DB state prevalece sobre claims stale.

**AC-0022-011.** RLS continúa frontera primaria tenant.

**AC-0022-012.** email no se usa como PlatformUser authority.

**AC-0022-013.** generic listUsers/search permanece prohibido.

**AC-0022-014.** generic privileged client permanece prohibido.

**AC-0022-015.** Hook tenant-aware permanece prohibido.

## Provider

**AC-0022-016.** La decisión utiliza current official `createUser` server-side capability.

**AC-0022-017.** La decisión verifica que el SDK oficial vigente permite `AdminUserAttributes.id`.

**AC-0022-018.** La implementación futura deberá confirmar que la versión instalada/Hosted mantiene ese contrato antes de mutar.

**AC-0022-019.** `getUserById` se usa sólo con exact UUID.

**AC-0022-020.** `listUsers` no se usa.

**AC-0022-021.** `signInWithPassword` se usa sólo como final provider proof, no discovery.

## Unbound subject

**AC-0022-022.** UUID reservado se genera server-side.

**AC-0022-023.** UUID reservado se persiste antes de `createUser`.

**AC-0022-024.** `createUser` recibe el exact reserved UUID.

**AC-0022-025.** lost response se reconcilia por exact ID.

**AC-0022-026.** duplicate email con reserved ID absent no produce enumeration.

**AC-0022-027.** identidad provider preexistente desconocida produce fail-closed/repair.

**AC-0022-028.** no preliminary session se emite para discovery.

## Bridge / compatibility

**AC-0022-029.** Bridge binding ocurre sólo después de provider subject confirmation.

**AC-0022-030.** Application compatibility se evalúa por exact Auth subject.

**AC-0022-031.** no mapping puede ser compatible.

**AC-0022-032.** mapped PlatformUser sólo es compatible si no es SUPER_ADMIN y no tiene membership.

**AC-0022-033.** disabled membership también cuenta como existing membership.

**AC-0022-034.** compatibility lookup failure = deny.

## Coordination

**AC-0022-035.** Existe durable `AuthSubjectAuthorityAnchor` conceptual.

**AC-0022-036.** Existe durable `LaterUserInitialSessionCoordination` conceptual.

**AC-0022-037.** Coordination no es tenant authority.

**AC-0022-038.** Single-active semantics están definidas.

**AC-0022-039.** Fence se activa en la misma DB transaction que compatibility check.

**AC-0022-040.** No DB lock cruza provider network I/O.

**AC-0022-041.** Terminal compatibility recheck ocurre antes de release.

**AC-0022-042.** Browser session delivery ocurre después del terminal commit.

## Cross-flow

**AC-0022-043.** TASK-019 se identifica como authority-producing writer.

**AC-0022-044.** Future later-user membership creation debe respetar el fence.

**AC-0022-045.** TASK-015 reinstate respeta fence.

**AC-0022-046.** Enabled role-change respeta fence.

**AC-0022-047.** No global mutex es introducido.

## E2

**AC-0022-048.** ADR-0019 core E2 permanece.

**AC-0022-049.** VerificationChallenge sigue siendo business proof.

**AC-0022-050.** technical password sigue siendo provider proof.

**AC-0022-051.** SessionGrant sigue siendo session authorization proof.

**AC-0022-052.** SessionGrant TTL sigue exactamente 5 minutos.

**AC-0022-053.** Hook consume grant single-use.

**AC-0022-054.** `supabase_auth_admin` no obtiene tenant/application authorization privilege.

## Failure

**AC-0022-055.** Provider ambiguity no genera blind create retry.

**AC-0022-056.** Hook ambiguity no reactiva grant.

**AC-0022-057.** Terminal authority drift impide browser delivery.

**AC-0022-058.** Expiry no extiende el grant.

## Scope

**AC-0022-059.** No se crea `PlatformUser`.

**AC-0022-060.** No se crea `CompanyMembership`.

**AC-0022-061.** No se implementa Client/UserClientAccess/SupportAccessGrant.

**AC-0022-062.** No se cambia offline.

**AC-0022-063.** No se introduce microservice.

**AC-0022-064.** No se autoriza TASK-021 implementation.

## Correction-specific

**AC-0022-065.** Provider/source evidence no se sobredeclara como una comprobación explícita de `UUID version == 4`; UUID v4 permanece una decisión de proyecto.

**AC-0022-066.** `auth.admin.getUserById(exact_expected_auth_subject_id)` queda autorizado sólo como operation purpose-specific de ADR-0022/TASK-021.

**AC-0022-067.** Arbitrary/caller-selected `getUserById`, email-derived lookup, `listUsers` y generic Auth Admin permanecen prohibidos.

**AC-0022-068.** TASK-013 privileged Auth Admin allowlist queda estrechamente calificada por ADR-0022 y requiere documentación/state-machine sync antes de implementación.

**AC-0022-069.** La precedencia cross-flow canónica de §26.7 está definida y no permite inversión.

**AC-0022-070.** Una transacción que adquiere `MaintenanceCompany` y `AuthSubjectAuthorityAnchor` adquiere `MaintenanceCompany` primero.

**AC-0022-071.** Una transacción que empieza en `AuthSubjectAuthorityAnchor` porque no necesita tenant/company locks no puede adquirir después una clase anterior del grafo.

**AC-0022-072.** TASK-019 preserva el lock graph de CORR-035 y añade el subject anchor después de actor/company/intent y antes de target identity/membership.

**AC-0022-073.** Participating TASK-015 authority-increasing operations resuelven el target subject purpose-specifically sólo después de tenant serialization y fallan cerradas si el mapping reconocido no es exactamente uno.

**AC-0022-074.** Preliminary target/mapping reads son locators, no authority, y se revalidan después de los locks aplicables.

**AC-0022-075.** El Hook utiliza sólo el suffix platform-owned del lock graph y no adquiere tenant/application authority locks.

**AC-0022-076.** Real concurrency debe demostrar ausencia de `SQLSTATE 40P01`/hang para TASK-021 ↔ TASK-019, future membership creation y participating TASK-015 writers.

**AC-0022-077.** Zero/multiple reverse Auth-subject mappings para un writer que necesita el fence no se reinterpretan como account linking; producen fail-closed/review.

**AC-0022-078.** Semantic lock-class ordering reconoce explícitamente que clases distintas pueden aliasar la misma physical row.

**AC-0022-079.** TASK-019 detecta `historical actor PlatformUser = target mapped PlatformUser` y falla cerrado antes de una espera bloqueante por el target anchor.

**AC-0022-080.** Cuando TASK-019 ya mantiene un `PlatformUser` pre-anchor potencialmente aliasable, la adquisición del target anchor es non-waiting/fail-fast; anchor ocupado aborta/retry sin formar `P → anchor(S)` wait edge.

**AC-0022-081.** Después de una adquisición exitosa del anchor, TASK-019 revalida el exact target mapping antes de target identity/membership locks y falla cerrado si aparece alias con cualquier pre-anchor `PlatformUser` ya retenido.

**AC-0022-082.** Ningún participating flow puede formar simultáneamente opposite blocking wait edges `P → anchor(S)` y `anchor(S) → P` para el mismo physical P/S pair.

**AC-0022-083.** CORR-035 permanece intacto: historical actor → MaintenanceCompany → FirstAdminOnboardingIntent.

**AC-0022-084.** TASK-021 compatibility y terminal recheck no requieren target PlatformUser/Auth mapping/CompanyMembership row locks sólo para freshness; utilizan fresh reads bajo exact subject anchor más mandatory writer participation.

**AC-0022-085.** El Hook no adquiere target PlatformUser/Auth mapping/CompanyMembership row locks.

**AC-0022-086.** La solución de alias no introduce global/advisory mutex, multiple-anchor workaround, generic identity search, account linking ni cross-tenant anchor oracle.

**AC-0022-087.** Real concurrency de ALIAS-01..03 debe pasar sin `SQLSTATE 40P01`, hang no bounded, authority mutation incompatible ni partial state.

---

# 47. Implementation blockers / STOP conditions

Una futura TASK-021 corregida o implementación debe detenerse si cualquiera es verdadero:

1. installed/current Supabase Admin SDK no soporta crear usuario con exact caller-chosen server UUID;
2. Hosted Auth rechaza o reinterpreta el custom `id` de forma incompatible;
3. `getUserById` no permite reconciliar exact UUID de forma soportada;
4. la solución necesita `listUsers`/enumeration;
5. necesita resolver Auth user por email como authority;
6. necesita preliminary successful sign-in para conocer subject;
7. necesita otorgar CompanyMembership/tenant access a `supabase_auth_admin`;
8. necesita mantener PostgreSQL lock durante provider call;
9. necesita distributed transaction;
10. no puede impedir una authority-producing mutation mientras `ISSUANCE_ACTIVE`;
11. algún authority-producing writer relevante no puede participar en coordination;
12. necesita generic privileged client;
13. necesita service-role como ordinary request/data client;
14. requiere cambiar SessionGrant TTL;
15. requiere reactivar consumed/expired grant;
16. requiere crear PlatformUser/CompanyMembership dentro de TASK-021;
17. requiere cambiar RF-013..RF-017;
18. requiere mover Client a Phase 2;
19. requiere nuevo product requirement no aprobado;
20. provider contract cambia materialmente;
21. no puede preservar la precedencia de §26.7 sin una inversión de locks;
22. un participating authority-producing writer no puede resolver de forma segura y única su target subject anchor;
23. algún flow necesita adquirir `AuthSubjectAuthorityAnchor` y después `MaintenanceCompany`/otra clase anterior;
24. el Hook necesita tenant/application authority locks;
25. TASK-019 no puede preservar el lock graph aprobado por CORR-035 al incorporar el anchor;
26. `getUserById` necesita convertirse en arbitrary/caller-selected lookup, email directory lookup o generic repair capability;
27. la qualification de TASK-013 requiere ampliar más allá del exact-ID purpose-specific boundary autorizado;
28. las pruebas concurrentes reproducen `SQLSTATE 40P01`, hang no bounded o una authority mutation incompatible dentro del intervalo protegido;
29. un physical-row alias no puede cerrarse sin cambiar el ordering actor → company → intent de CORR-035;
30. un flow con pre-anchor `PlatformUser` potencialmente aliasable necesita una espera bloqueante por el target anchor en vez de fail-fast/abort;
31. una solución de alias requiere global/advisory lock, multiple-anchor locking, generic account linking o identity search;
32. TASK-021 o el Hook necesitan target PlatformUser/Auth mapping/CompanyMembership row locks para freshness y no pueden probar row-alias safety;
33. las pruebas ALIAS-01..03 reproducen `40P01`, hang no bounded, unlock-and-switch o partial authority state.

Ante blocker:

```text
STOP
NO SILENT REPAIR
RETURN TO REVISOR CENTRAL
```

---

# 48. Consequences

## 48.1 Positivas

- subject conocido antes de cualquier final sign-in;
- no email authority;
- exact-ID recovery;
- no enumeration;
- no discovery session;
- TOCTOU controlado;
- E2 preservado;
- Hook mínimo;
- cross-flow coordination explícita;
- session delivery delayed until authoritative terminal proof.

## 48.2 Negativas

- nueva persistencia platform-owned;
- nuevas invariantes transversales;
- cambios futuros necesarios en writers existentes;
- algunos provider-existing/unbound states se vuelven repair-required;
- más pruebas de concurrencia;
- dependencia explícita del contract `createUser(id)` del SDK/Auth server.

## 48.3 Reversibilidad

La decisión es costosa de revertir porque afecta:

- TASK-013 state machine;
- TASK-021;
- future membership creation;
- TASK-019/TASK-015 coordination;
- provider reconciliation.

Por ello corresponde a ADR.

---

# 49. Fuentes oficiales verificadas

Verificación realizada el `2026-10-03`.

1. Supabase JavaScript — `auth.admin.createUser`
   `https://supabase.com/docs/reference/javascript/auth-admin-createuser`

2. Supabase JavaScript — `auth.admin.getUserById`
   `https://supabase.com/docs/reference/javascript/auth-admin-getuserbyid`

3. Supabase JavaScript — `auth.admin.listUsers`
   `https://supabase.com/docs/reference/javascript/auth-admin-listusers`

4. Supabase JavaScript — `signInWithPassword`
   `https://supabase.com/docs/reference/javascript/auth-signinwithpassword`

5. Supabase Auth — Custom Access Token Hook
   `https://supabase.com/docs/guides/auth/auth-hooks/custom-access-token-hook`

6. Supabase Auth — Auth Hooks / security model
   `https://supabase.com/docs/guides/auth/auth-hooks`

7. Supabase Auth — Before User Created Hook
   `https://supabase.com/docs/guides/auth/auth-hooks/before-user-created-hook`

8. Official Supabase Auth JS types — `AdminUserAttributes.id`
   `https://github.com/supabase/auth-js/blob/master/src/lib/types.ts`
   y mirror/current package source bajo `supabase/supabase-js`.

9. Official Supabase Auth server — Admin create user accepts custom `id`, parses it as UUID, rejects invalid/nil UUID and assigns it to the user
   `https://github.com/supabase/auth/blob/master/internal/api/admin.go`

La futura implementación debe volver a verificar el contract de la versión realmente instalada y el comportamiento Hosted vigente inmediatamente antes de usarlo como precondición de seguridad.

---

# 50. References de proyecto

## Producto / arquitectura

- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`
- `docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md`
- `ADR-0021` — canonical repository artifact; this ADR does not infer its exact filename when the canonical slug is not physically recovered here.

## Fase 2

- `docs/tasks/TASK-013-verification-challenge-foundation.md`
- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`
- `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`
- `docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md`
- `docs/tasks/TASK-019-authoritative-first-admin-profile-completion-onboarding-completion-foundation.md`
- `CORR-035-task-019-cross-task-actor-company-lock-graph-correction.md` — exact recovered artifact name; preserve its actor → company → intent lock-order correction
- `TASK-020` — canonical repository artifact; this ADR does not infer its exact filename when the canonical slug is not physically recovered here.
- corrected TASK-021 artifact identified by SHA-256 `5ddde8e54882f137b7e693786f1d6aea77b9dde7d087bb36db5a387c60308a11`

Las referencias con slug no recuperado literalmente en este Gate no deben convertirse en filename inventado durante canonicalización; el Revisor Central deberá contrastarlas contra el repo real antes de incorporación.

---

# 51. Impacto sobre findings de TASK-021

Después de `ADR-0022 SECOND CORRECTED ARTIFACT REVIEW = APPROVED` y de la aprobación humana formal:

```text
F-0022-R-001 REVIEW =
PASS

F-0022-R-002 REVIEW =
PASS / PRESERVED

F-0022-R-003 REVIEW =
PASS / PRESERVED

F-0022-R-004 REVIEW =
PASS

F-021-SPEC-004 =
OPEN / WAITING DOCUMENTED ADR CONSUMPTION

F-021-SPEC-005 =
OPEN / WAITING DOCUMENTED ADR CONSUMPTION

F-021-SPEC-006 =
OPEN / DOCUMENTAL
```

ADR-0022 queda humanamente aprobado como decisión arquitectónica, pero **NO** marca `F-021-SPEC-004` ni `F-021-SPEC-005` como `CLOSED` dentro de este artefacto. TASK-021 continúa bloqueada y sólo podrá reevaluar esos findings mediante un Gate posterior separado después de completar el lifecycle documental de ADR-0022.

F-021-SPEC-006 se corrige documentalmente en TASK-021, no en este ADR.

---

# 52. Estado final del artefacto

```text
ADR-0022 GENERATION =
PASS

ADR-0022 REVIEW =
RETURNED FOR CORRECTION

ADR-0022 CORRECTION GENERATION =
PASS

ADR-0022 CORRECTED ARTIFACT REVIEW =
RETURNED FOR CORRECTION

ADR-0022 SECOND CORRECTION GENERATION =
PASS

ADR-0022 SECOND CORRECTED ARTIFACT REVIEW =
APPROVED

ADR-0022 architecture/security second re-review =
PASS

ADR-0022 HUMAN APPROVAL =
APPROVED

ADR-0022 architecture decision =
HUMAN APPROVED

ADR-0022 approved artifact =
GENERATED / PENDING APPROVED ARTIFACT REVIEW

ADR-0022 status =
PROPOSED

ADR-0022 canonicalized =
NO

ADR-0022 repository incorporation =
NO

F-0022-R-001 REVIEW =
PASS

F-0022-R-002 REVIEW =
PASS / PRESERVED

F-0022-R-003 REVIEW =
PASS / PRESERVED

F-0022-R-004 REVIEW =
PASS

selected architecture =
S1 — PREALLOCATED AUTH SUBJECT
+ PURPOSE-SPECIFIC EXACT-ID PROVIDER RECONCILIATION
+ DURABLE SUBJECT-AUTHORITY FENCE
+ FINAL ADR-0019 E2 SESSION ISSUANCE

ADR-0019 core E2 modified =
NO

ADR-0019 narrow later-user qualification approved by ADR-0022 =
YES

TASK-013 privileged Auth Admin allowlist qualification approved by ADR-0022 =
YES — EXACT getUserById ONLY / LATER-USER PRE-ISSUANCE

TASK-013 documentation/state-machine sync =
REQUIRED BEFORE IMPLEMENTATION

cross-flow canonical lock precedence =
DEFINED

CORR-035 TASK-019 actor → company → intent order preserved =
YES

ADR-0021 invariant modified =
NO

TASK-013 physical/state-machine impact =
YES

TASK-020 handoff contract impact =
NO

TASK-021 specification rewrite required =
YES

new durable platform-owned coordination state =
YES

membership-creation coordination =
YES

new tenant authority =
NO

new product requirement =
NO

TASK-021 specification =
REMAINS BLOCKED / NOT APPROVED

F-021-SPEC-004 =
OPEN / WAITING DOCUMENTED ADR CONSUMPTION

F-021-SPEC-005 =
OPEN / WAITING DOCUMENTED ADR CONSUMPTION

F-021-SPEC-006 =
OPEN / DOCUMENTAL

implementation =
NOT AUTHORIZED

Codex =
NOT AUTHORIZED

repository mutation =
NONE

Supabase mutation =
NONE
```

---

# 53. Confirmation of no execution

Durante la generación, primera correction generation, second correction generation, revisiones y approved artifact generation de ADR-0022:

```text
repository modified =
NO

Supabase Local modified =
NO

Supabase Cloud modified =
NO

staging =
NO

commit =
NO

push =
NO

TASK-021 implementation =
NO
```

El siguiente Gate es exclusivamente:

```text
ADR-0022 APPROVED ARTIFACT REVIEW
```
