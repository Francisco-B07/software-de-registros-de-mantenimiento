# TASK-021 — Authoritative Later-User Auth Identity Reconciliation and Initial Session Establishment Foundation

## 1. Identificación

**TASK ID:** `TASK-021`

**Título:** `Authoritative Later-User Auth Identity Reconciliation and Initial Session Establishment Foundation`

**Tipo:** `IMPLEMENTATION TASK / IDENTITY & AUTH FOUNDATION`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context principal:** `Identity & Authorization / Identity & Auth`

**Artefacto de specification base:** `TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation-corrected.md`

**Artefacto corrected-v2 human-approved:** `TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation-corrected-v2.md`

**Artefacto approved generado:** `TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation-approved.md`

**Ruta canónica candidata futura, sólo después de aprobación, canonicalización y repository-incorporation authorization:**

`docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md`

Estado de este artefacto:

```text
TASK-021 SPECIFICATION GENERATION =
PASS

TASK-021 SPEC REVIEW =
RETURNED FOR CORRECTION

TASK-021 SPECIFICATION CORRECTION =
PASS

F-021-SPEC-001 =
CORRECTED

F-021-SPEC-002 =
CORRECTED

F-021-SPEC-003 =
CORRECTED

ADR-0022 FINAL HUMAN CLOSURE =
APPROVED

ADR-0022 =
DONE / CLOSED

ADR-0022 canonical commit =
3bb6b34299eb512d93f2478306f1095d768b8233

TASK-021 POST-ADR-0022 SPECIFICATION REEVALUATION =
APPROVED FOR CORRECTION

TASK-021 POST-ADR-0022 SPECIFICATION CORRECTION GENERATION =
PASS

TASK-021 CORRECTED SPEC REVIEW =
APPROVED

TASK-021 HUMAN SPEC APPROVAL =
APPROVED

F-021-SPEC-004 =
RESOLVED

F-021-SPEC-005 =
RESOLVED

F-021-SPEC-006 =
RESOLVED

new architecture decision required =
NO

TASK-021 specification =
HUMAN APPROVED

TASK-021 corrected-v2 artifact =
HUMAN APPROVED

TASK-021 approved artifact generation =
PASS

TASK-021 approved artifact =
GENERATED / PENDING APPROVED ARTIFACT REVIEW

TASK-021 =
DETERMINED / SPECIFICATION HUMAN APPROVED / NOT IMPLEMENTATION AUTHORIZED

TASK-013 documentation/state-machine sync =
REQUIRED BEFORE TASK-021 IMPLEMENTATION

TASK-013 modification by this artifact =
NONE

implementation =
NOT AUTHORIZED

Codex =
NOT AUTHORIZED

repository mutation =
NONE

Supabase mutation =
NONE

staging =
NO

commit =
NO

push =
NO

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED
```

Este artefacto representa una specification **ya aprobada humanamente**; no se autoaprueba, no canonicaliza su contenido, no autoriza implementación, no autoriza Codex, no modifica TASK-013, no modifica el repositorio, no modifica Supabase y no implica ningún Gate posterior.

---

## 2. Objetivo único

TASK-021 especifica una foundation PR-sized cuyo objetivo único es continuar el handoff autoritativo ya implementado por TASK-020 hasta establecer o reconciliar de forma segura una identidad Supabase Auth compatible y una sesión Auth inicial, terminando antes de toda creación/completitud de identidad de aplicación, membership, autoridad tenant o client scope.

Boundary nominal:

```text
TASK-020 authoritative handoff
→ authoritative later-user continuation resolution
→ compatible Supabase Auth identity resolution/reconciliation
→ purpose-specific privileged Auth provisioning only where authorized
→ ADR-0019 technical-password bridge
→ SessionGrant-authorized initial session issuance
→ initial Supabase Auth session established
→ bounded reconciliation after ambiguous provider/browser outcomes
→ AUTHENTICATED BUT NOT TENANT-AUTHORIZED
→ TASK-021 END
```

TASK-021 no completa el onboarding de producto.

---

## 3. START y END obligatorios

### 3.1 START

TASK-021 comienza únicamente cuando existen simultáneamente:

```text
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

El browser no convierte un `intent_id`, email, route segment, role, grant ID ni challenge ID en autoridad.

### 3.2 END

TASK-021 termina únicamente cuando:

```text
compatible Supabase Auth identity established or safely reconciled
+
initial Supabase Auth session established under ADR-0019
+
result safely reconcilable under approved Auth/session boundary
+
target state =
AUTHENTICATED BUT NOT TENANT-AUTHORIZED
```

### 3.3 END no implica

```text
PlatformUser application completion = YES
profile completion = YES
CompanyMembership creation = YES
membership enablement = YES
tenant role activation = YES
USER_CREATED = YES
Client = YES
UserClientAccess = YES
SupportAccessGrant = YES
RF-015 satisfied = YES
ordinary later-user onboarding complete = YES
Phase 2 closed = YES
Phase 3 started = YES
```

---

## 4. Fuentes de verdad

La futura implementación sólo será válida si consume las fuentes canónicas físicas vigentes y el repositorio real.

### 4.1 Producto

- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/11-phase-1-scope-entry-gate.md`

### 4.2 Arquitectura

- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`
- `docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md`
- `docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md`

### 4.3 Foundations Phase 2

- `docs/tasks/TASK-009-identity-tenant-foundation.md`
- `docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md`
- `docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`
- `docs/tasks/TASK-013-verification-challenge-foundation.md`
- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`
- `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`
- `docs/tasks/TASK-020-authoritative-later-user-enrollment-intent-verification-handoff-foundation.md`

### 4.4 Precedentes purpose-specific

TASK-017, TASK-018 y TASK-019 sólo son precedentes para seguridad, provider boundary, SSR/session, reconciliation, testing y separación de responsabilidades.

Regla obligatoria:

```text
first-admin purpose-specific implementation
!=
generic later-user API
```

No se copian automáticamente rutas, RPC/functions, payloads, state machines, identificadores, UI ni semánticas de reconciliation.

---

## 5. Estado vigente consumido

Debe preservarse:

```text
TASK-020 =
DONE / CLOSED

TASK-020 FINAL HUMAN CLOSURE =
APPROVED

TASK-020 implementation commit =
65309909864e80c6abaf8ad88479bce07c530924

TASK-020 authoritative later-user enrollment intent foundation =
IMPLEMENTED

TASK-020 verification/handoff foundation =
IMPLEMENTED

later-user authoritative intent/challenge/proof/handoff =
IMPLEMENTED WITHIN TASK-020 BOUNDARY

later-user Auth identity/session establishment =
NOT IMPLEMENTED

later-user PlatformUser/profile completion =
NOT IMPLEMENTED

later-user CompanyMembership creation =
NOT IMPLEMENTED

later-user tenant role activation =
NOT IMPLEMENTED

later-user USER_CREATED producer =
NOT IMPLEMENTED

ordinary later-user onboarding =
INCOMPLETE

full RF-013 =
NOT YET COMPLETE

RF-014 =
NOT YET COMPLETE END-TO-END

RF-015 =
MANDATORY / NOT YET SATISFIABLE BEFORE CLIENT

RF-016 =
UNCHANGED

RF-017 =
UNCHANGED

Client =
PHASE 3

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED
```

---

## 6. Requisitos de producto aplicables

### 6.1 RF-013

TASK-021 avanza RF-013 al permitir que el target cuya posesión del correo ya fue probada por TASK-020 alcance una identidad/sesión Auth compatible.

```text
RF-013 =
ADVANCED BY TASK-021 / NOT COMPLETE END-TO-END
```

TASK-021 no puede declarar “usuario dado de alta completamente” porque no crea/completa `PlatformUser`, membership ni Client scope.

### 6.2 RF-014

El `intended_role` ya fue fijado autoritativamente por TASK-020.

TASK-021 lo conserva únicamente como binding histórico/intent semantics.

```text
LaterUserEnrollmentIntent.intended_role
!=
current tenant role authority
```

Por tanto:

```text
RF-014 =
PRESERVED / NOT COMPLETE END-TO-END
```

### 6.3 RF-015

```text
RF-015 =
MANDATORY / UNCHANGED / NOT SATISFIED
```

```text
zero client assignment satisfies RF-015 =
NO
```

### 6.4 RF-016

TASK-021 no introduce ninguna superficie de `Client` o `UserClientAccess`.

```text
RF-016 =
UNCHANGED
```

### 6.5 RF-017

TASK-021 no implementa cambio posterior de role ni client scope.

```text
RF-017 =
UNCHANGED
```

---

## 7. Fuera de alcance absoluto

TASK-021 NO implementa ni presenta como implementado:

- `PlatformUser` application completion;
- profile completion;
- `CompanyMembership` creation;
- membership enablement;
- tenant role activation;
- `USER_CREATED`;
- `Client`;
- `UserClientAccess`;
- `SupportAccessGrant`;
- client assignment;
- RF-015 satisfaction;
- ordinary later-user onboarding completion;
- generic signup;
- generic invitation framework;
- generic enrollment framework;
- generic privileged Supabase client;
- ordinary service-role request client;
- microservice;
- Phase 2 Exit Gate;
- Phase 2 closure;
- Phase 3 start.

Prohibido crear:

```text
placeholder Client
fake Client
wildcard Client
empty client scope treated as valid
pending UserClientAccess treated as RF-015 satisfaction
placeholder CompanyMembership
enabled membership with zero Clients
tenant authority derived from intended_role
tenant authority derived from Auth session
tenant authority derived from JWT/custom claims
```

---

## 8. Modelo de dominio y ownership

### 8.1 `MaintenanceCompany`

Continúa siendo el tenant.

### 8.2 `LaterUserEnrollmentIntent`

Continúa siendo:

```text
TENANT-OWNED BUSINESS STATE
```

Sus bindings de tenant/email/intended-role permanecen autoritativos e inmutables dentro del enrollment aprobado.

TASK-021 no agrega a la intención:

- target `platform_user_id`;
- target `company_membership_id`;
- `client_id`;
- `user_client_access_id`;
- `support_access_grant_id`;
- profile fields;
- authority claims.

### 8.3 `VerificationChallenge`

Continúa siendo platform-owned Identity/Auth state.

### 8.4 `AuthBridgeCredential`

Continúa siendo platform-owned technical state de ADR-0019/TASK-013.

No es entidad funcional de producto.

### 8.5 `SessionGrant`

Continúa siendo platform-owned Identity/Auth state.

Su TTL permanece exactamente en 5 minutos, es single-use y purpose-specific.

### 8.6 `AuthSubjectAuthorityAnchor`

TASK-021 consume de ADR-0022 un concepto técnico durable platform-owned estable por exact Auth subject.

Propósito exclusivo:

```text
subject-scoped serialization anchor
for authority-producing writers
and TASK-021 initial-session fence
```

No es `PlatformUser`, `CompanyMembership`, tenant, role, Client scope, sesión ni JWT authority.

El anchor puede existir para un UUID reservado antes de que el Auth user remoto quede confirmado; la reserva de UUID no crea autoridad.

### 8.7 `LaterUserInitialSessionCoordination`

TASK-021 materializa un registro durable platform-owned por operación lógica de initial-session establishment.

Debe vincular autoritativamente:

- coordination ID;
- TASK-020 handoff / `LaterUserEnrollmentIntent`;
- `AuthBridgeCredential`;
- `SessionGrant`;
- logical operation ID;
- target email source/binding por referencia;
- expected/reserved/confirmed exact Auth subject;
- lifecycle state;
- expiry;
- terminal result.

No contiene tenant/role caller-selected como autoridad y no es entidad funcional de producto.

### 8.8 Supabase Auth identity

Es provider Auth state.

No equivale a `PlatformUser`.

### 8.9 `PlatformUser`

Continúa siendo identidad de aplicación/plataforma.

TASK-021 puede observar su existencia para clasificar compatibilidad, pero:

```text
TASK-021 PlatformUser INSERT/UPDATE =
NO
```

### 8.10 `CompanyMembership`

Continúa siendo autoridad tenant ordinaria.

TASK-021 puede observar su existencia/estado únicamente para clasificación fail-closed.

```text
TASK-021 CompanyMembership INSERT/UPDATE =
NO
```

### 8.11 Ownership summary

```text
LaterUserEnrollmentIntent = TENANT-OWNED
VerificationChallenge = PLATFORM-OWNED
AuthBridgeCredential = PLATFORM-OWNED
SessionGrant = PLATFORM-OWNED
AuthSubjectAuthorityAnchor = PLATFORM-OWNED
LaterUserInitialSessionCoordination = PLATFORM-OWNED
Supabase Auth identity = PROVIDER AUTH STATE
PlatformUser = APPLICATION IDENTITY
CompanyMembership = TENANT AUTHORITY
```

---

## 9. Arquitectura reutilizada

```text
ADR-0019 reuse =
YES / CORE E2 UNCHANGED

ADR-0021 reuse =
YES

ADR-0022 reuse =
YES / CLOSED ARCHITECTURE CONSUMED

ADR-0022 decision =
S1 — PREALLOCATED AUTH SUBJECT
+ PURPOSE-SPECIFIC EXACT-ID PROVIDER RECONCILIATION
+ DURABLE SUBJECT-AUTHORITY FENCE
+ FINAL ADR-0019 E2 SESSION ISSUANCE

new ADR required after ADR-0022 consumption =
NO
```

TASK-021 debe implementar S1 sin reinterpretarla.

Si durante future implementation aparece una necesidad arquitectónica transversal no cubierta por ADR-0019/0021/0022, o una contradicción que obligue a cambiar S1:

```text
TASK-021 IMPLEMENTATION =
STOP

BLOCKER — NEW ARCHITECTURE DECISION REQUIRED
```

---

## 10. Invariantes ADR-0019 obligatorias

Debe preservarse:

```text
business proof =
VerificationChallenge

provider proof =
technical password server-only

session authorization proof =
one-time SessionGrant
```

Cadena E2:

```text
authorized business intent
→ consumed VerificationChallenge
→ SessionGrant
→ server-only technical password
→ signInWithPassword
→ Custom Access Token Hook
→ atomic SessionGrant consume
→ Supabase session
```

### 10.1 `SessionGrant`

Debe permanecer:

```text
SHORT-LIVED
SINGLE-USE
PURPOSE-SPECIFIC
SERVER-SIDE
NON-ENUMERABLE BY BROWSER
NOT BEARER AUTHORITY
FAIL-CLOSED
IDEMPOTENT / RECONCILABLE
```

TTL vigente:

```text
exactly 5 minutes
```

No ampliar TTL silenciosamente.

### 10.2 Technical password

Debe permanecer:

```text
high entropy
server-only
no UX
no browser
no plaintext DB storage
no logs
no telemetry
```

La future implementation debe reverificar la password policy Hosted canónica vigente antes de usar el encoder físico.

### 10.3 Initial-session methods

```text
public signup =
DENY

OTP / magiclink initial session =
DENY

recovery as initial enrollment session =
DENY

unsupported initial Auth method =
DEFAULT DENY
```

### 10.4 Privileged Auth boundary

ADR-0019 core E2 permanece sin cambios.

Para TASK-021, la Auth Admin surface queda cerrada y purpose-specific:

```text
auth.admin.createUser =
AUTHORIZED ONLY AFTER AUTHORITATIVE TASK-020 HANDOFF/PROOF
AND ONLY WITH THE EXACT RESERVED SUBJECT FOR THE SAME LOGICAL OPERATION

auth.admin.getUserById(exact_expected_auth_subject_id) =
AUTHORIZED PURPOSE-SPECIFIC ADMIN OPERATION
ONLY FOR ADR-0022 / TASK-021 LATER-USER PRE-ISSUANCE RECONCILIATION

auth.admin.updateUserById =
NOT ORDINARY TASK-021 HAPPY PATH
/ RETAINS ONLY THE SEPARATELY REVIEWED ADR-0019 REPAIR/ROTATION BOUNDARY
```

`getUserById` sólo puede recibir el UUID exacto ya derivado autoritativamente de un bound `AuthBridgeCredential` o reservado durablemente por la misma `LaterUserInitialSessionCoordination`.

Continúa prohibido:

```text
arbitrary/caller-selected getUserById = NO
email-derived Auth directory lookup = NO
listUsers = NO
generic email lookup = NO
full-directory scan = NO
generic auth.admin export = NO
generic privileged Supabase client = NO
ordinary service-role business/data client = NO
```

La qualification de `getUserById` exige una futura sincronización documental/state-machine de TASK-013 antes de implementar TASK-021; no modifica por inferencia el core E2 ni concede privilegios tenant/application a `supabase_auth_admin`.

---

## 11. Security / multitenancy invariants

Debe permanecer:

```text
tenant =
MaintenanceCompany

authenticated != authorized

Auth session != tenant authorization

current authoritative PostgreSQL state > stale claims

RLS =
PRIMARY REMOTE TENANT-ISOLATION BOUNDARY

SUPER_ADMIN ordinary tenant bypass =
NO

generic service-role request path =
NO

generic privileged client =
NO

caller-supplied tenant authority =
NO

JWT/custom claims as tenant or role authority =
NO
```

Una sesión Auth válida sólo demuestra identidad Auth válida.

No demuestra:

- `PlatformUser` completo;
- membership;
- tenant;
- role;
- client scope;
- `SupportAccessGrant`;
- permiso funcional;
- estado comercial.

---

## 12. Trust boundaries

### 12.1 Browser / pre-session target

Untrusted.

Puede aportar como máximo el locator purpose-specific ya aprobado y el material de proof requerido por TASK-020 mientras la verificación ocurre.

No puede aportar autoridad de tenant, role, membership, user, grant, Client ni Auth subject.

### 12.2 Application server

Trusted orchestration boundary.

Responsable de:

- resolver el handoff autoritativo;
- no confiar en browser state;
- custodiar technical password;
- crear/reconciliar `LaterUserInitialSessionCoordination`;
- reservar el exact Auth subject UUID server-side cuando el bridge está unbound;
- invocar Auth Admin sólo mediante adapters purpose-specific;
- retener un provider session result hasta completar terminal revalidation;
- propagar cookies sólo después del terminal coordination commit.

### 12.3 PostgreSQL tenant-owned state

`LaterUserEnrollmentIntent` permanece protegido por RLS y boundaries purpose-specific.

No se expande acceso tenant por TASK-021.

### 12.4 Platform-owned Auth state

`VerificationChallenge`, `AuthBridgeCredential`, `SessionGrant`, `AuthSubjectAuthorityAnchor` y `LaterUserInitialSessionCoordination` son platform-owned.

No se convierten en tenant-owned ni en autoridad de producto.

### 12.5 Subject-authority serialization boundary

`AuthSubjectAuthorityAnchor` es la única clave durable común de serialización subject-scoped definida por ADR-0022.

No es un global mutex y no autoriza por sí mismo ninguna operación.

Los authority-producing writers participantes deben respetar el active TASK-021 fence antes de commit.

### 12.6 Privileged Auth Admin boundary

Server-only, purpose-specific, minimum privilege.

Permitido para TASK-021 únicamente en las operaciones exactas de §10.4.

No lee/escribe datos tenant ordinarios como bypass y no exporta un Admin client genérico.

### 12.7 Caller-scoped sign-in boundary

El `signInWithPassword` final usa semántica no privilegiada/publishable y ocurre sólo después de exact-subject confirmation + compatibility/fence activation.

No se reutiliza el Admin client.

### 12.8 Custom Access Token Hook

Permanece un platform-owned Auth gate.

Puede validar únicamente el state platform-owned necesario para E2/ADR-0022:

```text
exact user_id
authentication_method = password
AuthBridgeCredential
LaterUserInitialSessionCoordination
ISSUANCE_ACTIVE
SessionGrant
GATE_CONSUMED transition
```

No obtiene autoridad de `MaintenanceCompany`, `PlatformUser`, `CompanyMembership`, tenant role, Client scope, `SupportAccessGrant` ni subscription entitlement.

### 12.9 Supabase Auth session

Prueba identidad Auth.

No prueba tenant authorization.

### 12.10 PostgreSQL authoritative application state

Fuente de verdad para `PlatformUser`, global authority y `CompanyMembership`.

Current authoritative PostgreSQL state prevalece sobre claims/session stale.

---

## 13. Compatibilidad de identidad — clasificación obligatoria

TASK-021 define una clasificación purpose-specific que sólo puede evaluarse autoritativamente después de conocer el **exact Auth subject** de la operación.

Conceptualmente:

```text
NO_APPLICATION_IDENTITY
COMPATIBLE_EXISTING_APPLICATION_IDENTITY
INCOMPATIBLE_IDENTITY
FAIL_CLOSED
```

### 13.1 Exact subject prerequisite

La clasificación nunca comienza desde email como authority.

Exact subject deriva únicamente de:

```text
bound bridge
→ AuthBridgeCredential.auth_user_id
```

o:

```text
unbound bridge
→ server-reserved UUID persisted before provider mutation
→ exact-ID provider confirmation
→ bridge binding
```

### 13.2 `NO_APPLICATION_IDENTITY`

```text
exact Auth subject
+
no platform_user_auth_subjects mapping
→ compatible for TASK-021 Auth/session only
```

No crea `PlatformUser`.

### 13.3 `COMPATIBLE_EXISTING_APPLICATION_IDENTITY`

```text
exact Auth subject
→ exactly one mapped PlatformUser
+
is_super_admin = false
+
zero CompanyMembership rows, enabled or disabled
→ compatible
```

No completa profile ni membership.

### 13.4 `INCOMPATIBLE_IDENTITY`

Cualquiera:

```text
mapped PlatformUser with is_super_admin = true
OR
mapped PlatformUser with any CompanyMembership
OR
bridge/provider exact-subject mismatch
OR
cross-identity correlation
```

Resultado:

```text
FAIL CLOSED
NO FINAL TASK-021 SIGN-IN / SESSION DELIVERY
NO MEMBERSHIP MUTATION
NO TENANT AUTHORITY
NO ACCOUNT TAKEOVER
NO SILENT ROLE REPAIR
```

Same-tenant enabled/disabled membership debe usar el lifecycle existente, no re-enrollment.

Cross-tenant membership se deniega.

Global `SUPER_ADMIN` se deniega.

### 13.5 `FAIL_CLOSED`

Ambigüedad, zero/>1 mapping cuando una cardinalidad exacta es requerida, mapping corrupto, lookup failure, provider outage no resuelto, bridge/provider mismatch o correlación no inequívoca.

No repair automático.

### 13.6 Email

Email continúa siendo PII/locator/correlation.

Nunca:

```text
email
→ PlatformUser
→ authority
```

Tampoco se usa para descubrir un Auth subject mediante directory enumeration.

---

## 14. Exact-subject compatibility + durable issuance fence

La corrected-v2 elimina la semántica anterior de un simple pre-provider compatibility result capaz de quedar stale.

### 14.1 Regla central

Antes del **final `signInWithPassword`** debe existir un exact Auth subject confirmado y una transacción DB corta que:

```text
acquire/serialize through AuthSubjectAuthorityAnchor
→ re-resolve exact subject/bridge/handoff/grant
→ run fresh application compatibility check
→ activate LaterUserInitialSessionCoordination = ISSUANCE_ACTIVE
→ commit
```

El compatibility result y la activación del fence pertenecen a la misma transacción.

### 14.2 Unbound provisioning no equivale a final issuance

Para un bridge unbound, `createUser(id = reserved_uuid)` puede ocurrir antes de application compatibility porque su única finalidad es confirmar el exact provider subject reservado por la operación.

Ese provisioning:

```text
does not create PlatformUser
and does not create CompanyMembership
and does not grant tenant authority
and does not authorize final sign-in by itself
```

Una vez confirmado/bound el subject, la compatibility/fence transaction es obligatoria antes del final sign-in.

### 14.3 Fence semantics

Mientras `ISSUANCE_ACTIVE` o `GATE_CONSUMED` estén activos, cualquier flow participante que pudiera crear/habilitar autoridad incompatible para el exact subject debe serializar por el mismo anchor y no puede committear esa autoridad.

Puede fallar/retry boundedly según su specification física, pero nunca ignorar el fence.

### 14.4 No remote lock

Ningún row lock de PostgreSQL se mantiene durante:

- `createUser`;
- `getUserById`;
- `signInWithPassword`;
- provider network I/O.

### 14.5 Terminal revalidation

Provider sign-in success y `GATE_CONSUMED` no autorizan browser delivery.

Trusted server debe:

```text
retain provider result
→ reacquire same AuthSubjectAuthorityAnchor
→ fresh terminal compatibility recheck
→ verify coordination state
→ mark SESSION_ESTABLISHED_NO_AUTHORITY
→ release fence in same commit
→ only then propagate session/cookies to browser
```

Si la terminal recheck detecta autoridad incompatible:

```text
NO browser session delivery
FAIL CLOSED
```

### 14.6 Hook scope

El Hook no ejecuta la application compatibility check y no consulta tenant/application-authority state para decidir el JWT.

Su scope continúa limitado a platform-owned E2/coordination state.

---

## 15. Diseño físico mínimo esperado — database

La future implementation debe realizar fresh repository/schema preflight antes de generar SQL, pero ADR-0022 ya obliga a materializar durable platform-owned coordination state. Esta corrected-v2 fija el contrato físico mínimo; la migration ejecutable se difiere a implementación.

### 15.1 Nueva tabla platform-owned — `auth_subject_authority_anchors`

Nombre físico esperado:

```text
public.auth_subject_authority_anchors
```

Purpose:

```text
stable exact-subject row used only as a serialization anchor
```

Campos mínimos conceptuales:

```text
auth_subject_id uuid PRIMARY KEY
created_at timestamptz NOT NULL
```

No necesita tenant ID, role, PlatformUser ID, membership ID, session ID ni claims.

No representa que el provider Auth user exista. Un UUID reservado puede tener anchor antes de provider confirmation.

Retention:

```text
anchor is durable/stable for the subject identity space
no ordinary browser cleanup/delete surface
```

### 15.2 Nueva tabla platform-owned — `later_user_initial_session_coordinations`

Nombre físico esperado:

```text
public.later_user_initial_session_coordinations
```

Campos mínimos conceptuales:

```text
id uuid PRIMARY KEY
later_user_enrollment_intent_id uuid NOT NULL
auth_bridge_credential_id uuid NOT NULL
auth_session_grant_id uuid NOT NULL
logical_operation_id uuid NOT NULL
expected_auth_subject_id uuid NOT NULL
reserved_auth_subject_id uuid NULL
confirmed_auth_subject_id uuid NULL
state text NOT NULL
expires_at timestamptz NOT NULL
terminal_result text NULL
created_at timestamptz NOT NULL
updated_at timestamptz NOT NULL
```

`later_user_enrollment_intent_id` sirve como handoff/email-source binding por referencia; no convierte email en authority.

`expected_auth_subject_id` es el exact subject bajo el cual se coordina la operación:

- bound flow: igual al subject del bridge;
- unbound flow: igual al UUID server-reserved persistido antes de provider mutation.

`reserved_auth_subject_id` sólo se usa cuando la operación realizó preallocation; `confirmed_auth_subject_id` sólo se rellena después de exact provider confirmation.

### 15.3 Lifecycle constraint

`state` admite exactamente:

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

Estados terminales:

```text
SESSION_ESTABLISHED_NO_AUTHORITY
EXPIRED
ABANDONED
REPAIR_REQUIRED
```

No existe transición que resurrecte un terminal `SessionGrant`.

### 15.4 Integrity / immutable bindings

Una coordinación no puede cambiar silenciosamente de:

- handoff/intent;
- bridge;
- SessionGrant;
- logical operation;
- expected subject;
- reserved subject una vez fijado.

`confirmed_auth_subject_id`, cuando aparece, debe ser igual al exact expected subject de esa logical operation.

State-dependent integrity mínimo:

```text
reserved_auth_subject_id IS NOT NULL
→ reserved_auth_subject_id = expected_auth_subject_id

state IN (SUBJECT_CONFIRMED, ISSUANCE_ACTIVE, GATE_CONSUMED, SESSION_ESTABLISHED_NO_AUTHORITY)
→ confirmed_auth_subject_id IS NOT NULL
→ confirmed_auth_subject_id = expected_auth_subject_id

state = PROVISIONING_UNKNOWN
→ reserved_auth_subject_id IS NOT NULL
→ confirmed_auth_subject_id IS NULL

state IN (SESSION_ESTABLISHED_NO_AUTHORITY, EXPIRED, ABANDONED, REPAIR_REQUIRED)
→ terminal_result IS NOT NULL
```

Las transiciones de lifecycle sólo pueden ocurrir mediante boundaries purpose-specific autorizadas; direct arbitrary state UPDATE no es una superficie soportada.

No se admite cambio a otro subject/email/tenant en retry.

### 15.5 Single-active semantics

La migration futura debe imponer físicamente:

```text
at most one active TASK-021 coordination
per authoritative handoff/purpose
```

y:

```text
at most one active initial-session authority fence
per expected Auth subject
```

Los estados activos/fence-bearing son al menos:

```text
ISSUANCE_ACTIVE
GATE_CONSUMED
```

`PREPARING`/`PROVISIONING_UNKNOWN`/`SUBJECT_CONFIRMED` deben además ser reconciliables por la misma logical operation sin crear un segundo active attempt incompatible.

El mecanismo físico exacto puede ser unique/partial unique constraints/indexes, pero debe ser demostrable en PostgreSQL y quedar cubierto por tests de concurrencia.

### 15.6 Minimum indexes

Además de PK/unique constraints, se esperan sólo índices justificados por:

- exact subject coordination lookup;
- exact handoff/intent reconciliation;
- exact grant/bridge correlation;
- state/expiry cleanup cuando sea necesario.

No introducir índices de búsqueda por email como identity directory.

### 15.7 Foreign-key / correlation posture

Las referencias a intent, bridge y SessionGrant deben usar las identidades físicas canónicas vigentes observadas en fresh repo/schema preflight.

Si el schema real impide establecer una FK segura sin violar ownership/boundary, la implementation debe STOP/RETURN en lugar de inventar una relación distinta.

### 15.8 New product schema

```text
new product/domain tables =
0

new product/domain columns =
0

new tenant-owned tables =
0
```

Las dos tablas nuevas son exclusivamente platform-owned technical coordination state.

### 15.9 Purpose-specific DB boundaries

La migration futura puede introducir/ajustar funciones purpose-specific para:

- coordination start/reconciliation;
- exact-subject compatibility + fence activation;
- Hook gate consume against platform-owned coordination/grant state;
- terminal compatibility recheck + terminalization;
- pending post-session state.

No se autoriza SQL genérico ni una API privileged browser-callable.

`SECURITY DEFINER`, si es necesario, debe ser narrow, schema-qualified, hardened, con safe `search_path`, `PUBLIC EXECUTE = REVOKED` y grants exactos.

### 15.10 Cleanup / retention

`LaterUserInitialSessionCoordination` puede expirar/terminalizarse y ser objeto de cleanup técnico según política de retención definida por implementación sin eliminar evidencia necesaria para reconciliación/auditoría técnica.

`AuthSubjectAuthorityAnchor` es estable y no se elimina como side effect ordinario del cleanup de attempts.

Cleanup nunca reactiva grants ni libera authority sin terminalization autoritativa.

---

## 16. RLS / privilege implications

### 16.1 `LaterUserEnrollmentIntent`

```text
TENANT-OWNED / RLS PROTECTED
```

No abrir direct CRUD a browser.

### 16.2 Platform-owned Auth/coordination state

```text
VerificationChallenge
AuthBridgeCredential
SessionGrant
AuthSubjectAuthorityAnchor
LaterUserInitialSessionCoordination
```

continúan o se materializan como platform-owned Identity/Auth state.

No son tenant-owned y no se usan como sustituto de RLS sobre datos tenant.

### 16.3 Direct Data API

Debe mantenerse:

```text
anon direct LaterUserEnrollmentIntent CRUD = DENY
authenticated direct LaterUserEnrollmentIntent CRUD = DENY
anon direct coordination CRUD = DENY
authenticated direct coordination CRUD = DENY
anon direct subject-anchor CRUD = DENY
authenticated direct subject-anchor CRUD = DENY
```

### 16.4 `supabase_auth_admin`

Continúa con:

```text
tenant/application-authorization privileges = NONE
```

Para el Custom Access Token Hook puede recibir únicamente el mínimo acceso platform-owned necesario para:

- exact bridge correlation;
- active coordination check;
- eligible SessionGrant check/consume;
- `GATE_CONSUMED` transition.

No acceso a `MaintenanceCompany`, `PlatformUser` authority, `CompanyMembership`, tenant role, Client scope ni subscription entitlement.

### 16.5 Application-server DB boundary

Cualquier operación server-only que cruce tenant-owned handoff + platform-owned coordination debe usar una boundary purpose-specific ya aprobada/hardened; no generic service-role request client.

### 16.6 RLS invariant

```text
valid Auth session
without current enabled CompanyMembership
→ no tenant data access
```

TASK-021 no debilita ni sustituye RLS.

---

## 17. AuthBridgeCredential / technical password contract

TASK-021 consume la foundation TASK-013 y la qualification estrecha de ADR-0022; no crea otro Auth proof.

### 17.1 Bound bridge

Si:

```text
auth_bridge_credentials.auth_user_id != NULL
```

orden obligatorio:

1. resolver el TASK-020 handoff;
2. reconcile/create `LaterUserInitialSessionCoordination`;
3. tomar como `expected_auth_subject_id` exclusivamente `AuthBridgeCredential.auth_user_id`;
4. ensure/reconcile `AuthSubjectAuthorityAnchor`;
5. ejecutar purpose-specific `auth.admin.getUserById(expected_subject)`;
6. exigir exact provider subject + email/bridge correlation;
7. bind/check coordination al exact subject;
8. ejecutar la compatibility/fence transaction de §14;
9. sólo con `ISSUANCE_ACTIVE`, derivar technical password server-side;
10. ejecutar final `signInWithPassword`;
11. Hook exige exact subject + password method + active coordination + eligible grant;
12. Hook consume grant y marca `GATE_CONSUMED`;
13. trusted server retiene el provider result;
14. terminal revalidation/terminalization bajo el mismo anchor;
15. sólo después propagar session/cookies.

### 17.2 Unbound bridge

Unbound discovery mediante preliminary `signInWithPassword` queda eliminado.

Secuencia obligatoria:

```text
1. resolve authoritative TASK-020 handoff
2. reconcile/create LaterUserInitialSessionCoordination
3. generate server-side UUID v4 as reserved Auth subject
4. persist reserved/expected subject before provider mutation
5. ensure/reconcile AuthSubjectAuthorityAnchor
6. auth.admin.getUserById(reserved_uuid) exact collision check
7. execute one logical createUser with id = reserved_uuid when authorized
8. reconcile ambiguous result only by exact getUserById(reserved_uuid)
9. confirm exact provider subject
10. bind AuthBridgeCredential.auth_user_id = reserved_uuid
11. mark SUBJECT_CONFIRMED
12. run compatibility/fence transaction
13. final signInWithPassword
14. Hook exact-subject/grant gate
15. terminal recheck and browser delivery only after terminal commit
```

### 17.3 Preallocation

El UUID reservado:

- se genera server-side;
- es UUID v4 por decisión de proyecto;
- se persiste antes del provider side effect;
- no es caller-supplied;
- no constituye authority;
- no cambia en same-operation retry.

La implementación debe reverificar el SDK instalado y Hosted provider contract para custom `id` antes de mutar.

### 17.4 Exact-ID collision check

Si `getUserById(reserved_uuid)` demuestra que el UUID ya existe **antes** del provisioning attempt:

```text
FAIL CLOSED / REPAIR_REQUIRED
```

No adoptarlo automáticamente.

### 17.5 Guarded replay

Después de un create result ambiguo:

```text
getUserById(reserved_uuid) = exact expected user
→ provisioning reconciled
```

Si un provider response confiable demuestra exact UUID absent:

```text
guarded replay allowed
ONLY with same UUID + same email binding + same handoff + same bridge + same operation identity
```

No es blind create retry.

### 17.6 Duplicate/conflict con exact UUID absent

```text
REPAIR_REQUIRED
```

No buscar qué otro subject posee el email.

### 17.7 Provider outage

Si el exact UUID no puede resolverse por outage:

```text
PROVISIONING_UNKNOWN
NO sign-in
NO blind create
```

### 17.8 Existing provider account / takeover controls

No:

- `listUsers`;
- generic admin search;
- email directory lookup;
- arbitrary `getUserById`;
- password reset;
- magic link;
- OTP;
- recovery;
- silent `updateUserById(password=...)`;
- account linking;
- manual Auth user ID caller-supplied.

---

## 18. Auth Admin partial failure model

### 18.1 `createUser` success + response lost

La coordinación entra en:

```text
PROVISIONING_UNKNOWN
```

Retry/reconciliation:

```text
auth.admin.getUserById(reserved_uuid)
```

Si devuelve exact expected user + expected correlation:

```text
provider provisioning = RECONCILED
→ bind bridge
→ SUBJECT_CONFIRMED
```

No se repite ciegamente la creación.

### 18.2 Exact-ID lookup outage

```text
state = PROVISIONING_UNKNOWN
NO sign-in
NO create replay until exact absence/existence is reliably known
```

### 18.3 Exact-ID absent after reliable check

La misma logical operation puede realizar guarded replay sólo con los mismos bindings/UUID.

### 18.4 Duplicate/conflict + reserved UUID absent

```text
REPAIR_REQUIRED
NO email enumeration
NO takeover
```

### 18.5 Wrong subject returned

Si provider response retorna un subject distinto del exact expected UUID:

```text
FAIL CLOSED / REPAIR_REQUIRED
```

No bind.

### 18.6 Bridge bind DB failure after provider success

Provider exact subject se conserva como reconciliable state por exact UUID.

No emitir sesión hasta que el bridge y coordination hayan sido autoritativamente reconciliados.

No crear otro Auth user.

### 18.7 Definitive provider failure before creation

No session, no app-domain mutation, coordinación terminal/retryable según evidencia exacta.

### 18.8 Incompatible application identity after subject confirmation

No final sign-in, no password overwrite, no membership mutation, no browser session delivery.

---

## 19. SessionGrant + LaterUserInitialSessionCoordination contract y recovery

### 19.1 SessionGrant invariant

TASK-020 produce/reconcilia el grant y TASK-021 debe consumirlo dentro del window ADR-0019.

```text
TTL = EXACTLY 5 MINUTES
SINGLE-USE
PURPOSE-SPECIFIC
SERVER-SIDE
```

La coordinación nunca extiende `SessionGrant.expires_at`.

### 19.2 Coordination lifecycle

Estados mínimos:

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

### 19.3 `PREPARING`

Handoff/grant/operation/subject expectation están fijados durablemente; no existe authority fence todavía.

### 19.4 `PROVISIONING_UNKNOWN`

Sólo provider ambiguity exact-ID.

No habilita sign-in.

### 19.5 `SUBJECT_CONFIRMED`

Exact provider user confirmado + bridge bound.

Todavía no existe session issuance authority.

### 19.6 `ISSUANCE_ACTIVE`

Sólo mediante la misma transaction que fresh-checks compatibility bajo `AuthSubjectAuthorityAnchor`.

Mientras está activo, participating authority-producing writers no pueden committear autoridad incompatible.

### 19.7 `GATE_CONSUMED`

Hook consumió exactamente el SessionGrant para exact subject/method.

No equivale a browser session delivery.

Fence permanece activo.

### 19.8 `SESSION_ESTABLISHED_NO_AUTHORITY`

Terminal success sólo después de provider success + exact subject + terminal compatibility recheck + terminal commit.

Este estado demuestra únicamente:

```text
AUTHENTICATED BUT NOT TENANT-AUTHORIZED
```

### 19.9 `EXPIRED`

Grant/coordination dejó de ser elegible.

No grant resurrection, no TTL extension.

### 19.10 `ABANDONED`

Attempt terminado sin side effect remoto pendiente después de reconciliación segura.

### 19.11 `REPAIR_REQUIRED`

Provider/application ambiguity o incompatibility no automatizable.

No fallback privileged.

### 19.12 Missing/expired/revoked grant

```text
NO INITIAL SESSION
```

y, según el caso, `SESSION_RECOVERY_REQUIRED` sin inventar fresh authorization.

### 19.13 Concurrent sign-in

```text
at most one successful SessionGrant consume
```

### 19.14 Lost session response

Una current session sólo puede reconciliarse como already-established si exact correlation demuestra simultáneamente:

```text
current Auth subject
↔ exact expected/confirmed subject
↔ AuthBridgeCredential
↔ GATE_CONSUMED coordination
↔ consumed SessionGrant
↔ authoritative LaterUserEnrollmentIntent handoff
```

No utilizar tenant/role/client claims como authority.

Si no puede demostrarse:

```text
SECURITY_CORRELATION_FAILURE
```

TASK-021 no almacena JWT/refresh token para reparación.

---

## 20. Idempotency / operation identity

TASK-021 no introduce browser-controlled idempotency authority.

### 20.1 Logical operation identity

Una logical operation conserva de forma estable:

```text
authoritative TASK-020 handoff
AuthBridgeCredential
LaterUserInitialSessionCoordination.id
logical_operation_id
expected/reserved/confirmed Auth subject
SessionGrant
```

Same-operation retry no selecciona nuevo subject, email, tenant, grant o bridge.

### 20.2 Single-active semantics

Debe existir físicamente:

```text
at most one active TASK-021 coordination per authoritative handoff/purpose
```

y:

```text
at most one active initial-session authority fence per exact Auth subject
```

### 20.3 Same-operation retry

Re-resuelve current authoritative coordination/provider/application state.

Puede reconciliar una operación ambigua por exact UUID; no puede iniciar una nueva identidad lógica para ocultar ambiguity.

### 20.4 Different-operation replay

No puede adoptar un grant/coordination consumed, revoked, expired o terminal.

### 20.5 Guarded provisioning replay

Sólo permitido cuando exact-ID lookup confiable demuestra absent y se preservan:

```text
same reserved UUID
same email binding
same handoff
same bridge
same operation identity
```

### 20.6 Payload mismatch

No existe payload caller-supplied de tenant/role/client/Auth user ID aceptado como session authority.

---

## 21. Concurrency model / cross-flow serialization

TASK-021 consume íntegramente la precedencia canónica de ADR-0022.

### 21.1 Lock precedence

```text
0. preliminary purpose-specific locator reads
1. existing approved pre-company provenance/global-actor lock
2. MaintenanceCompany / tenant serialization lock
3. FirstAdminOnboardingIntent or already-approved tenant intent lock
4. AuthSubjectAuthorityAnchor for exact target Auth subject
5. target Auth-subject mapping / PlatformUser authority rows, when required
6. CompanyMembership authority rows, when required
7. AuthBridgeCredential, when row lock is required
8. LaterUserInitialSessionCoordination
9. SessionGrant
10. authority mutation / coordination terminalization / commit
```

Reglas:

```text
MaintenanceCompany + AuthSubjectAuthorityAnchor
→ MaintenanceCompany first

AuthSubjectAuthorityAnchor acquired without MaintenanceCompany
→ MUST NOT later acquire MaintenanceCompany/earlier class

MaintenanceCompany + FirstAdminOnboardingIntent + anchor
→ MaintenanceCompany → intent → anchor
```

No DB row lock se mantiene durante provider network I/O.

No global mutex/advisory platform lock.

### 21.2 TASK-021 compatibility reads

Para compatibility/freshness únicamente:

```text
target PlatformUser row lock = NOT REQUIRED
target Auth mapping row lock = NOT REQUIRED
target CompanyMembership row lock = NOT REQUIRED
```

TASK-021 usa fresh reads bajo exact subject anchor; todos los authority-producing writers incompatibles deben participar en el mismo anchor antes de commit.

Si implementación necesitara esos row locks por otra razón:

```text
prove physical-row alias safety
OR
STOP / RETURN FOR REVIEW
```

### 21.3 TASK-019 / CORR-035 preservation

Se preserva:

```text
historical actor PlatformUser FOR KEY SHARE
→ MaintenanceCompany FOR UPDATE
→ FirstAdminOnboardingIntent FOR UPDATE
```

El subject anchor se añade después de esas clases y antes de target identity/membership authority rows.

### 21.4 Physical-row alias closure

El historical actor `PlatformUser P` puede ser físicamente la misma fila que el PlatformUser mapeado desde target Auth subject `S`.

Antes del anchor, TASK-019 debe hacer purpose-specific alias precheck usando el exact subject derivado de handoff/session, nunca email/caller input.

Known alias:

```text
FAIL CLOSED BEFORE WAITING FOR ANCHOR
```

Como el precheck puede quedar stale, mientras TASK-019 retenga actor/company/intent potencialmente aliasables, la adquisición del target anchor debe ser:

```text
NON-WAITING / FAIL-FAST
```

Anchor ocupado:

```text
abort/retry transaction
release existing locks
NO blocking P → anchor(S) wait
NO unlock-and-switch
```

Si fail-fast acquire tiene éxito, re-resolver exact mapping bajo anchor. Si mapea a cualquier PlatformUser row ya retenida como clase pre-anchor:

```text
FAIL CLOSED BEFORE TARGET AUTHORITY LOCKS
```

Propiedad universal:

```text
NO transaction may wait P → anchor(S)
while another may hold anchor(S) → wait P
for the same physical pair
```

### 21.5 Participating authority-producing writers

Debe participar en subject fence:

```text
future later-user membership creation = YES
TASK-015 reinstate = YES
TASK-015 enabled membership role-change = YES
future is_super_admin=true writer = YES
```

Authority-reducing TASK-015 disable no se bloquea meramente por ADR-0022.

Disabled membership role-change no habilita authority inmediatamente, pero la existencia de cualquier membership sigue siendo incompatible con valid TASK-021 issuance.

### 21.6 Reverse mapping rule for participating writers

Cuando un writer parte de PlatformUser/CompanyMembership y necesita localizar subject anchor:

```text
exactly one recognized Auth subject → continue
zero → FAIL CLOSED / RETURN FOR REVIEW
more than one → FAIL CLOSED / RETURN FOR REVIEW
```

No aprueba account linking ni multiple Auth identities.

### 21.7 Required concurrency coverage

Real concurrency, no simulación secuencial, debe cubrir:

- two TASK-021 attempts same subject;
- compatibility/fence vs future later-user membership creation;
- fence vs TASK-015 reinstate;
- fence vs TASK-015 enabled role change;
- TASK-021 ↔ TASK-019;
- terminal release vs authority writer;
- preliminary locator changes before anchor/revalidation;
- `ALIAS-01`, `ALIAS-02`, `ALIAS-03`;
- anchor occupied during alias-unsafe window.

Debe demostrarse:

```text
no SQLSTATE 40P01
no bounded hang
no unlock-and-switch
no partial authority mutation
no incompatible authority commit inside protected interval
```

---

## 22. Application/server flow

### 22.1 Precondition

Una trusted server orchestration recibe el resultado autoritativo de TASK-020, no un `SessionGrant` bearer del browser.

### 22.2 Resolve handoff / coordination

Resolver server-side:

- `LaterUserEnrollmentIntent`;
- target email source/binding;
- handoff grant;
- bridge credential;
- current grant lifecycle;
- existing/reconcilable `LaterUserInitialSessionCoordination`.

No confiar en tenant ID, role, Client ID o Auth user ID del browser.

### 22.3 Exact subject resolution

Bound bridge:

```text
expected subject = AuthBridgeCredential.auth_user_id
→ exact getUserById
```

Unbound bridge:

```text
server-reserved UUID persisted first
→ exact getUserById collision check
→ createUser(id = reserved_uuid)
→ exact-ID reconciliation
→ bridge binding
```

No preliminary/discovery sign-in.

### 22.4 Compatibility/fence activation

Con exact subject confirmado:

```text
anchor transaction
→ fresh compatibility
→ grant eligibility
→ ISSUANCE_ACTIVE
→ commit
```

### 22.5 Final identity/session service

Debe existir un application service purpose-specific conceptualmente equivalente a:

```text
establishLaterUserInitialSession(...)
```

No se crea:

```text
generic createUser(...)
generic signInAnyUser(...)
generic admin auth adapter
generic getUserById(...)
```

### 22.6 Final provider proof + Hook

Fuera de DB locks:

```text
final signInWithPassword
→ Hook exact user_id + password method + ISSUANCE_ACTIVE + eligible SessionGrant
→ atomic grant consume + GATE_CONSUMED
→ provider may issue session
```

Hook no lee tenant/application authorization state.

### 22.7 Terminalization before transport

Trusted server NO entrega todavía la sesión.

```text
reacquire same anchor
→ terminal compatibility recheck
→ SESSION_ESTABLISHED_NO_AUTHORITY
→ release fence in same commit
→ then SSR cookie/session propagation
```

### 22.8 Session transport

Usa boundary SSR/cookie existente de TASK-011.

Debe preservarse:

- caller-scoped/nonprivileged Supabase client para final sign-in/session;
- cookie propagation server→browser sólo después del terminal commit;
- anti-cache behavior;
- server identity validation conforme primitive vigente.

### 22.9 Terminal outcome

Internamente puede distinguir:

```text
SESSION_ESTABLISHED
SESSION_ALREADY_ESTABLISHED
SESSION_RECOVERY_REQUIRED
IDENTITY_INCOMPATIBLE
PROVIDER_IDENTITY_CONFLICT
PROVISIONING_UNKNOWN
REPAIR_REQUIRED
SECURITY_CORRELATION_FAILURE
RETRYABLE_FAILURE
PROVIDER_FAILURE
```

Browser projection permanece más acotada y no funciona como oracle.

---

## 23. HTTP boundary

### 23.1 No generic continuation endpoint

TASK-021 no debe crear una API pública que acepte:

```text
intentId
+
grantId
+
authUserId
```

para “crear sesión”.

La continuación Auth/session debe permanecer unida a una server-side orchestration autorizada por el handoff.

### 23.2 Existing verification flow integration

La future implementation debe inspeccionar la route real de verificación later-user de TASK-020.

Si esa route puede componer TASK-021 sin mezclar responsibilities ni duplicar provider logic, debe preferirse:

```text
verify/handoff authoritative success
→ server-only TASK-021 continuation
→ one bounded browser result
```

Si sólo es posible mediante un segundo public continuation endpoint bearer-like:

```text
TASK-021 IMPLEMENTATION =
STOP

BLOCKER — UNSAFE CONTINUATION BOUNDARY
```

### 23.3 HTTP protections

Para cualquier route modificada:

- same-origin request check conforme convenciones vigentes;
- exact content-type/input shape;
- private/no-store response;
- bounded errors;
- no raw provider error;
- no secrets;
- no authority-bearing IDs añadidos a success response;
- cookies manejadas por la boundary SSR aprobada.

---

## 24. UI / routing

### 24.1 Verification UI

La superficie de TASK-020 continúa siendo responsable de proof input.

TASK-021 no agrega:

- tenant selector;
- invitee role selector;
- Client selector;
- profile fields;
- membership controls.

### 24.2 Success destination

TASK-021 define una surface purpose-specific posterior a session establishment y anterior a domain completion.

```text
post-session destination =
purpose-specific later-user pending-completion surface

state =
AUTHENTICATED BUT NOT TENANT-AUTHORIZED

exact pathname =
DEFERRED TO FRESH REPOSITORY PREFLIGHT
```

El pathname exacto no queda fijado por esta specification corregida.

El fresh repository preflight debe identificar una route coherente con las convenciones físicas reales sin convertir rutas/componentes first-admin en API/UI genérica.

No debe reutilizar `/pending-profile` de first-admin por inferencia.

### 24.3 URL minimization

La success URL no contiene:

- intent ID;
- email;
- company/tenant ID;
- intended role;
- PlatformUser ID;
- membership ID;
- SessionGrant ID;
- challenge ID;
- auth user ID;
- tokens;
- technical password.

### 24.4 Server-rendered pending shell

Antes de mostrar la shell, resolver:

```text
resolve_current_later_user_pre_client_state()
```

o equivalente purpose-specific.

```text
PENDING_DOMAIN_COMPLETION
→ render bounded shell

UNAVAILABLE
→ fail closed to safe entry surface
```

### 24.5 Copy semantics

Puede comunicar únicamente hechos como:

```text
Sesión establecida.
Tu alta todavía no está completa.
Aún no tienes acceso a datos de la empresa.
```

El copy exacto no queda fijado como requisito cross-task.

No puede afirmar:

- “usuario creado completamente”;
- “acceso habilitado”;
- “rol activado”;
- “clientes asignados”;
- “onboarding completo”;
- dashboard disponible.

---

## 25. Offline behavior

```text
ordinary later-user Auth/session continuation =
ONLINE-ONLY
```

Prohibido:

- Dexie authority;
- IndexedDB authority;
- offline Auth provisioning;
- offline `SessionGrant` consume;
- outbox de Auth Admin operations;
- Service Worker authority;
- optimistic local session authorization.

Timeout/retry se resuelve online contra estado autoritativo.

---

## 26. Audit / observability

### 26.1 Functional `AuditEvent`

```text
new AuditEvent action =
NO

USER_CREATED =
NO
```

TASK-021 no completa usuario/membership.

### 26.2 Technical observability

Puede registrar clasificación técnica segura necesaria para operar, pero nunca:

- technical password;
- technical password secret key;
- raw `SessionGrant` authority;
- verification code;
- verifier;
- Auth Admin credential;
- access token;
- refresh token;
- full privileged provider response;
- cross-tenant membership details;
- raw enumeration-sensitive identity state.

PII email debe minimizarse.

---

## 27. Provider/Supabase contract verification

Antes de future implementation, reverificar fuentes oficiales vigentes, versión instalada del SDK y comportamiento Hosted necesario para:

- `auth.admin.createUser` con custom `id`;
- `auth.admin.getUserById` por exact UUID;
- `signInWithPassword`;
- Custom Access Token Hook;
- `authentication_method`;
- `token_refresh`;
- email confirmation behavior;
- password policy;
- public signup state;
- current-password requirement;
- SSR cookie/session transport.

### 27.1 Custom Auth subject ID

El proyecto reserva server-side un UUID v4.

Antes de implementación debe demostrarse que la versión instalada/Hosted mantiene el contrato necesario para pasar un custom Auth user ID en `createUser` y recuperar exactamente ese ID mediante `getUserById`.

No afirmar que el provider valida explícitamente UUID version 4 si la evidencia sólo demuestra parsing/valid UUID. La generación v4 es requisito del proyecto.

### 27.2 Exact-ID lookup qualification

```text
auth.admin.getUserById(exact_expected_auth_subject_id)
```

sólo se permite dentro de la boundary purpose-specific ADR-0022/TASK-021.

No usar:

- caller-selected arbitrary ID;
- email-derived ID discovery;
- `listUsers`;
- directory scan.

### 27.3 Provider drift

Si cualquiera de estas dependencias deja de ser demostrable o cambia materialmente:

```text
TASK-021 IMPLEMENTATION =
BLOCKER — PROVIDER CONTRACT / ARCHITECTURE REVIEW REQUIRED
```

No cambiar Auth method, subject-discovery strategy ni privilege surface silenciosamente.

---

## 28. TASK-018 precedent — permitido y prohibido

### 28.1 Permitido reutilizar como precedente

- security structure;
- provider boundary;
- “verify/handoff before session” ordering;
- reconciliation-before-blind-create;
- bounded application outcomes;
- same success semantics for new-compatible vs existing-compatible identity;
- SSR/session cookie transport;
- online-only behavior;
- testing patterns.

### 28.2 No copiar automáticamente

- `/first-admin/...` routes;
- `/pending-profile`;
- first-admin intent assumptions;
- first-admin actor/purpose;
- first-admin payloads;
- first-admin schema;
- exact RPC names;
- exact UI copy;
- profile-completion composition;
- first-admin completion semantics.

---

## 29. Threat model

| Threat | Riesgo | Control | Resultado esperado |
|---|---|---|---|
| Browser supplies foreign tenant/role/Auth user ID | cross-tenant or identity takeover | no caller authority inputs | DENY/no effect |
| Email used as identity directory | account takeover/enumeration | email locator only; exact subject preallocation/binding | absent |
| Existing provider account owns same email under different subject | accidental adoption/takeover | reserved exact UUID + no enumeration | `REPAIR_REQUIRED` |
| Preliminary password sign-in used to discover subject | unauthorized/discovery session | explicitly prohibited by ADR-0022 | absent |
| Blind `createUser` retry after timeout | duplicate/unknown provider state | durable reserved UUID + exact-ID reconciliation | no blind retry |
| Wrong provider subject returned | bridge misbinding | returned/exact ID must equal expected subject | FAIL CLOSED |
| Arbitrary `getUserById` | generic provider directory | exact expected UUID only | absent |
| `listUsers` / email search | enumeration/broad privilege | prohibited | absent |
| Existing same-tenant/disabled/cross-tenant membership | re-enrollment authority bypass | fresh exact-subject compatibility | DENY final issuance |
| Existing SUPER_ADMIN | global/tenant role confusion | compatibility deny | DENY |
| Compatibility changes after T1 | stale precheck permits session | durable subject fence + writer participation + terminal recheck | no incompatible success |
| Authority writer ignores fence | TOCTOU | shared anchor mandatory before authority-increasing commit | commit denied/deferred |
| TASK-019 physical-row alias | deadlock `P ↔ anchor(S)` | alias precheck + fail-fast anchor + revalidation | no 40P01/hang |
| Opposite lock ordering | deadlock | canonical precedence | no 40P01/hang |
| DB lock held over provider call | availability/deadlock | prohibited; durable state instead | absent |
| Hook becomes tenant-aware | privilege escalation | platform-owned state only | prohibited |
| `supabase_auth_admin` gains tenant privileges | RLS bypass | zero tenant/application authorization privilege | absent |
| Session returned before terminal recheck | stale compatibility/browser authority confusion | server retains provider result until terminal commit | no delivery |
| Grant consumed + response lost | grant resurrection | `GATE_CONSUMED` durable + exact reconciliation | no resurrection |
| Concurrent initial sign-ins | double issuance | single-active coordination + single-use grant | at most one consume |
| Session conveys intended role | tenant escalation | authenticated != authorized | no authority |
| Stale JWT/custom claim | stale authz | current DB state + RLS | DENY |
| Offline replay | stale privileged effect | online-only | DENY |
| Global mutex/advisory lock introduced | over-serialization/fragility | explicitly prohibited | absent |

---

## 30. Failure and recovery model

| Failure | Authoritative behavior | External behavior |
|---|---|---|
| no TASK-020 handoff | no coordination/provider call | bounded unavailable |
| malformed/foreign locator | no authority/provider call | generic failure |
| grant missing/expired/revoked | no initial issuance | recovery required |
| reserved UUID collides before provisioning | no adoption | repair required |
| exact `getUserById` outage | `PROVISIONING_UNKNOWN`; no sign-in/create replay | retry/unavailable |
| `createUser` success + response lost | exact-ID reconciliation only | retry/reconcile |
| exact reserved UUID absent after reliable lookup | same-operation guarded replay may occur | bounded retry |
| duplicate/conflict + reserved UUID absent | no email search | repair required |
| provider returns wrong subject | no bridge bind | repair/security failure |
| provider exact subject confirmed + bridge bind DB fail | reconcile same UUID later; no second user | retry/reconcile |
| application compatibility lookup failure | fail closed under anchor | generic terminal |
| compatibility incompatible | no `ISSUANCE_ACTIVE`; no final sign-in | identity unavailable |
| fence activation tx failure | no final sign-in | retryable |
| authority writer encounters active fence | writer cannot commit incompatible authority | retry/defer/fail per writer spec |
| alias detected pre-anchor | fail closed before waiting | bounded conflict |
| anchor occupied in alias-unsafe window | fail-fast abort/retry; no wait | retryable |
| final `signInWithPassword` failure before Hook consume | fence must terminalize/reconcile safely; grant state authoritative | bounded provider/retry outcome |
| Hook timeout/ambiguous | reconcile coordination/grant; no inferred success | retry/recovery |
| Hook consumed + provider response lost | grant stays consumed; exact-session correlation only | recovery/already-established if proven |
| provider success + terminal recheck detects authority | no browser cookie/session propagation | fail closed |
| terminal DB commit fails | no browser propagation; reconcile same coordination | retry/recovery |
| current session exists + exact TASK-021 correlation proven | no second initial authorization | already established |
| current session uncorrelated | do not adopt | security correlation failure |
| SessionGrant consumed + no recoverable session | no resurrection | recovery required |
| new product/architecture decision required | STOP | blocker |
| provider contract drift | STOP | blocker |
| SQLSTATE 40P01 / bounded hang in required concurrency tests | STOP / architecture regression | blocker |

Raw database/provider errors no cruzan browser boundary.

---

## 31. Result vocabulary

### 31.1 Coordination states

Canonical internal durable states:

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

### 31.2 Internal application outcomes

Allowed conceptual outcomes:

```text
SESSION_ESTABLISHED
SESSION_ALREADY_ESTABLISHED
SESSION_RECOVERY_REQUIRED
IDENTITY_INCOMPATIBLE
PROVIDER_IDENTITY_CONFLICT
PROVISIONING_UNKNOWN
REPAIR_REQUIRED
SECURITY_CORRELATION_FAILURE
RETRYABLE_FAILURE
PROVIDER_FAILURE
```

No se exige que todos crucen HTTP literalmente.

### 31.3 Browser-visible projection

Browser-visible vocabulary debe ser menos informativo que la interna.

Debe impedir distinguir innecesariamente:

- nonexistent email;
- existing provider user;
- reserved UUID collision;
- existing PlatformUser;
- same-tenant membership;
- disabled membership;
- cross-tenant membership;
- global SUPER_ADMIN;
- foreign intent;
- bridge/coordination state.

---

## 32. Expected implementation paths — bounded candidate set

La implementación real requiere fresh repository preflight antes de autorizarse.

Candidate new paths:

```text
supabase/migrations/<timestamp>_task_021_later_user_auth_identity_session_foundation.sql

src/modules/identity-authorization/application/later-user-auth-session.ts
src/modules/identity-authorization/application/later-user-auth-session-service.ts
src/modules/identity-authorization/infrastructure/supabase/later-user-auth-session-source.ts

purpose-specific later-user pending page under app/ — exact pathname deferred to fresh repository preflight

supabase/tests/database/task_021_later_user_auth_identity_session_foundation.test.sql
supabase/tests/database/task_021_later_user_auth_identity_session_concurrency.test.ps1

tests/task-021-later-user-auth-session.test.ts
tests/task-021-later-user-ui-integration.test.ts
```

La migration debe materializar exclusivamente el mínimo physical contract aprobado para:

```text
public.auth_subject_authority_anchors
public.later_user_initial_session_coordinations
purpose-specific functions/grants/indexes/constraints required by §15
```

Candidate modified paths, exact physical names to be confirmed by preflight:

```text
existing TASK-013 Custom Access Token Hook migration/function only for the strictly platform-owned coordination/grant delta approved by ADR-0022
existing TASK-020 later-user verification server orchestration / route
existing TASK-020 target verification UI
src/modules/identity-authorization/server.ts
participating TASK-019 / TASK-015 production paths only if the approved subject-fence participation cannot be achieved without their bounded modification
```

Any TASK-019/TASK-015 modification must be explicitly enumerated by fresh implementation preflight and remain strictly within ADR-0022 cross-flow participation; no product behavior expansion.

Historical migrations are never edited.

If a material production path outside the reviewed bounded set becomes necessary:

```text
STOP
RETURN TO REVISOR CENTRAL
```

---

## 33. Application contracts

Conceptual strict TypeScript contracts:

```text
LaterUserAuthSessionOutcome
LaterUserAuthSessionService
LaterUserAuthSessionSource
LaterUserPreClientState
LaterUserInitialSessionCoordinationState
ExactAuthSubjectId
```

`LaterUserAuthSessionSource` must expose purpose-specific primitives only, conceptually equivalent to:

```text
resolveAuthoritativeHandoff(...)
reconcileInitialSessionCoordination(...)
lookupExpectedAuthSubjectByExactId(...)
provisionReservedAuthSubject(...)
bindConfirmedAuthSubject(...)
activateIssuanceFence(...)
finalizeInitialSessionNoAuthority(...)
```

No raw Supabase Admin client.

No generic `getUserById` wrapper callable with arbitrary input.

No generic user provisioning interface.

Input to the core continuation must be server-derived handoff context or an opaque locator re-resolved authoritatively; it must not contain caller tenant/role/client/Auth subject authority.

Reserved Auth subject UUID is generated inside trusted server/application boundary and remains tied to the logical coordination.

Strict TypeScript remains mandatory; no `any`/unsafe casts to turn ambiguous state into success.

---

## 34. UI / API non-effects

TASK-021 does NOT create:

- dashboard authorization;
- tenant dashboard;
- profile form;
- user admin completion UI;
- Client selector;
- role editor;
- membership editor;
- offline state;
- subscription UI;
- support grant UI.

---

## 35. Test strategy

### 35.1 Static/spec-contract tests

Verify:

- no generic Admin client export;
- no generic `getUserById`;
- no `listUsers`;
- no service-role ordinary client;
- no Client/UserClientAccess code;
- no `USER_CREATED`;
- no profile/membership mutation;
- no tenant/role authority inputs;
- TypeScript strict;
- no preliminary/discovery `signInWithPassword` for unbound subject;
- no global/advisory platform mutex.

### 35.2 Physical coordination / DB tests

At minimum:

1. `auth_subject_authority_anchors` exact-subject PK behavior;
2. coordination exact immutable handoff/bridge/grant/operation bindings;
3. lifecycle constraint admits only approved states;
4. reserved subject persists before provider mutation fixture boundary;
5. confirmed subject must equal expected subject;
6. single-active handoff/purpose semantics;
7. single-active subject-fence semantics;
8. terminal state cannot be silently reactivated;
9. anon/authenticated direct coordination CRUD denied;
10. `supabase_auth_admin` cannot read tenant/application authority state;
11. Hook platform-owned minimum privileges only.

### 35.3 Exact-subject provider/application tests

- bound bridge uses exact `getUserById(bound_subject)`;
- unbound reserves UUID server-side before provider mutation;
- UUID caller-supplied rejected/ignored as authority;
- `createUser(id = reserved_uuid)`;
- provider success must return exact expected subject;
- wrong returned subject fails closed;
- ambiguous create → exact `getUserById(reserved_uuid)`;
- exact lookup outage → `PROVISIONING_UNKNOWN`;
- reliable exact absent → guarded replay only same UUID/bindings/operation;
- duplicate/conflict + reserved ID absent → `REPAIR_REQUIRED`;
- no listUsers/email directory/password takeover;
- no preliminary discovery sign-in;
- bound/unbound exact email/provider correlation;
- no automatic `updateUserById` takeover.

### 35.4 Compatibility/fence tests

- no application mapping → compatible;
- mapped non-superadmin + zero membership → compatible;
- SUPER_ADMIN → deny;
- enabled membership → deny;
- disabled membership → deny;
- cross-tenant membership → deny;
- ambiguous/multiple mapping → deny;
- lookup failure → deny;
- compatibility check + `ISSUANCE_ACTIVE` activation atomic;
- provider call occurs with no DB lock held;
- active fence blocks/defer/retries authority-producing writer before commit;
- terminal compatibility recheck required;
- terminal failure prevents browser session propagation.

### 35.5 Real concurrency / lock-graph tests

Must include real concurrent transactions/processes:

- two TASK-021 attempts same subject;
- compatibility/fence vs future membership writer fixture;
- fence vs TASK-015 reinstate;
- fence vs TASK-015 enabled role change;
- TASK-021 ↔ TASK-019 with CORR-035 ordering;
- terminal release vs authority writer;
- reverse mapping exactly-one/zero/>1 cases;
- locator changes before anchor revalidation;
- `ALIAS-01`: historical actor P equals mapped target subject PlatformUser;
- `ALIAS-02`: mapped target differs from historical actor;
- `ALIAS-03`: mapping/alias changes or becomes ambiguous during window;
- anchor occupied while actor/company/intent locks are held.

Required assertions:

```text
no SQLSTATE 40P01
no bounded hang
no blocking P → anchor(S) opposite edge
no unlock-and-switch
no partial authority mutation
no incompatible authority commit inside protected interval
```

### 35.6 Hook / SessionGrant tests

- wrong subject → deny;
- wrong method → deny;
- missing coordination → deny;
- non-`ISSUANCE_ACTIVE` coordination → deny;
- expired coordination/grant → deny;
- wrong grant → deny;
- consumed/revoked grant → deny;
- exactly one concurrent grant consume;
- successful consume transitions coordination to `GATE_CONSUMED`;
- Hook does not acquire/read MaintenanceCompany/PlatformUser/CompanyMembership authority state;
- zero tenant/application authorization privileges for `supabase_auth_admin`;
- token refresh remains ADR-0019 lifecycle, not fresh initial authorization.

### 35.7 Browser/session-delivery tests

- provider sign-in result not propagated before terminal DB commit;
- cookies absent if terminal compatibility fails;
- `SESSION_ESTABLISHED_NO_AUTHORITY` precedes browser delivery;
- response loss after grant consume does not resurrect grant;
- exact correlated existing session → already-established behavior;
- uncorrelated/mismatched session → fail closed;
- valid session without membership cannot access tenant data.

### 35.8 Security / multitenancy tests

- session exists but no PlatformUser → tenant RLS denied;
- session + compatible PlatformUser but no membership → tenant RLS denied;
- intended role/claims do not grant authority;
- forged tenant/role/Auth subject inputs do not grant access;
- global-only SUPER_ADMIN does not become tenant user;
- no Client/UserClientAccess/SupportAccessGrant;
- tenant RLS policies remain effective;
- email never functions as PlatformUser authority.

### 35.9 UI tests

- success destination remains purpose-specific later-user pending surface;
- URL has no authority-bearing query/fragment;
- pending page server-gated;
- no profile/tenant/role/Client fields;
- copy does not claim full creation/access;
- online-only;
- no localStorage/sessionStorage/IndexedDB/Dexie/outbox/Service Worker authority.

### 35.10 Regression tests

At minimum:

- TASK-009 identity/tenant regressions;
- TASK-011 SSR/cookie regressions;
- TASK-012 authz regressions;
- TASK-013 challenge/E2/Hook regressions;
- TASK-014 SUPER_ADMIN regressions;
- TASK-015 lifecycle regressions including participating writer coverage;
- TASK-019/CORR-035 lock-order regressions;
- TASK-020 later-user handoff regressions;
- relevant TASK-018 precedent security/session tests.

### 35.11 Project checks

- lint;
- strict typecheck;
- application/unit/integration tests;
- DB/RLS tests;
- real concurrency harness;
- build/verify commands required by repository conventions;
- `git diff --check`.

### 35.12 Hosted Development

Hosted Development verification remains mandatory after local implementation review and requires a separate human Gate.

No Staging/Production by inference.

---

## 36. Hosted Development verification contract

When separately authorized, Hosted Development must verify:

1. migration applied exactly once;
2. `public.auth_subject_authority_anchors` physical contract;
3. `public.later_user_initial_session_coordinations` physical contract;
4. expected PK/unique/single-active constraints/indexes only;
5. lifecycle/terminal constraints only;
6. expected grants/revokes only;
7. no unexpected tenant-owned table/column/RLS policy;
8. zero tenant/application-authorization privilege expansion for `supabase_auth_admin`;
9. custom `createUser(id=...)` contract works with installed/Hosted SDK/provider;
10. exact `getUserById(expected_uuid)` works for purpose-specific reconciliation;
11. unbound subject reservation/reconciliation path;
12. duplicate/conflict + exact ID absent → repair, no directory enumeration;
13. exact provider subject/bridge binding;
14. compatibility + `ISSUANCE_ACTIVE` atomic activation;
15. no DB lock held across provider network I/O;
16. SessionGrant single-use concurrency;
17. Hook platform-owned coordination/grant checks only;
18. terminal compatibility recheck before browser propagation;
19. incompatible same-tenant/disabled/cross-tenant membership denied;
20. SUPER_ADMIN denied;
21. direct Data API tenant isolation;
22. valid session still lacks tenant authorization without membership;
23. TASK-019/CORR-035 cross-flow concurrency including alias cases where runnable Hosted harness is approved;
24. participating TASK-015 authority-increasing writer behavior;
25. no `SQLSTATE 40P01`/hang in required concurrency coverage;
26. public Auth bypass negative tests;
27. technical password policy compatibility;
28. TASK-013 regressions;
29. TASK-020 regressions;
30. cleanup of test fixtures without deleting stable subject anchors required by live/reference state;
31. no Staging/Production mutation.

Remote mutation requires a separate human Gate.

---

## 37. Acceptance Criteria

Un solo `FAIL` impide declarar TASK-021 implementable/complete.

### Governance / scope

**AC-021-001.** TASK ID exacto = `TASK-021`.
**AC-021-002.** Título exacto = `Authoritative Later-User Auth Identity Reconciliation and Initial Session Establishment Foundation`.
**AC-021-003.** Phase = Phase 2.
**AC-021-004.** Specification state after ADR-0022 correction = `CORRECTED-V2 / PENDING CORRECTED SPEC REVIEW`.
**AC-021-005.** Implementation permanece no autorizada durante specification generation.
**AC-021-006.** Codex permanece no autorizado.
**AC-021-007.** Repository mutation = NONE.
**AC-021-008.** Supabase mutation = NONE.
**AC-021-009.** No staging/commit/push ocurre.
**AC-021-010.** Phase 2 permanece IN PROGRESS / NOT CLOSED.
**AC-021-011.** Phase 2 Exit Gate permanece NOT YET DEFINED.
**AC-021-012.** Phase 3 permanece NOT STARTED.

### START / END

**AC-021-013.** START exige handoff TASK-020 autoritativo.
**AC-021-014.** START exige LaterUserEnrollmentIntent autoritativamente resoluble.
**AC-021-015.** START exige VerificationChallenge ya consumido.
**AC-021-016.** START exige SessionGrant correlacionado.
**AC-021-017.** START exige ausencia de tenant authority target.
**AC-021-018.** END exige Auth identity compatible establecida/reconciliada.
**AC-021-019.** END exige initial Supabase Auth session.
**AC-021-020.** END exige estado `AUTHENTICATED BUT NOT TENANT-AUTHORIZED`.
**AC-021-021.** END no crea PlatformUser.
**AC-021-022.** END no crea CompanyMembership.
**AC-021-023.** END no activa tenant authority.

### Product boundaries

**AC-021-024.** RF-013 queda advanced, no complete end-to-end.
**AC-021-025.** RF-014 binding queda preservado sin role authority.
**AC-021-026.** RF-015 permanece mandatory/not satisfied.
**AC-021-027.** Zero clients no satisface RF-015.
**AC-021-028.** RF-016 permanece unchanged.
**AC-021-029.** RF-017 permanece unchanged.
**AC-021-030.** Client permanece Phase 3.
**AC-021-031.** Ordinary later-user onboarding permanece incomplete.

### Domain / identity

**AC-021-032.** PlatformUser != CompanyMembership permanece.
**AC-021-033.** Supabase Auth identity != PlatformUser permanece.
**AC-021-034.** Session != tenant authorization permanece.
**AC-021-035.** No application mapping se clasifica compatible para Auth/session-only.
**AC-021-036.** Mapped non-superadmin sin membership se clasifica compatible.
**AC-021-037.** Existing SUPER_ADMIN se clasifica incompatible.
**AC-021-038.** Any existing membership se clasifica incompatible para new enrollment.
**AC-021-039.** Disabled same-tenant membership no se re-enrolla.
**AC-021-040.** Cross-tenant membership se deniega.
**AC-021-041.** Ambiguous/corrupt mapping falla cerrado.
**AC-021-042.** Existing provider identity no es autoridad.
**AC-021-043.** No account takeover.
**AC-021-044.** No generic user search endpoint.

### SessionGrant / E2

**AC-021-045.** SessionGrant permanece server-side.
**AC-021-046.** SessionGrant no es bearer authority.
**AC-021-047.** SessionGrant TTL permanece exactamente 5 minutos.
**AC-021-048.** SessionGrant consumed es terminal.
**AC-021-049.** SessionGrant revoked es terminal.
**AC-021-050.** SessionGrant expired no consume.
**AC-021-051.** At most one successful initial grant consume bajo concurrencia.
**AC-021-052.** Missing grant niega initial session.
**AC-021-053.** No grant reactivation.
**AC-021-054.** No unlimited grant reissue from browser.

### Technical password

**AC-021-055.** Technical password permanece server-only.
**AC-021-056.** Technical password nunca cruza response/browser/URL/log.
**AC-021-057.** Technical password no se persiste plaintext.
**AC-021-058.** Secret key material permanece separado del key-version identifier.
**AC-021-059.** Password policy Hosted se reverifica antes de implementation.
**AC-021-060.** Unknown/incompatible password policy produce blocker.

### Auth Admin

**AC-021-061.** Admin credential es server-only.
**AC-021-062.** No generic Admin client export.
**AC-021-063.** No ordinary service-role request path.
**AC-021-064.** `createUser` sólo ocurre después de authoritative handoff/proof.
**AC-021-065.** Blind duplicate `createUser` retry está prohibido.
**AC-021-066.** Ambiguous create response reconcilia antes de otro create.
**AC-021-067.** No `listUsers` fallback.
**AC-021-068.** No automatic password-reset takeover.
**AC-021-069.** No ordinary silent `updateUserById` repair de incompatible account.

### Application compatibility + Custom Access Token Hook

**AC-021-070.** Later-user application compatibility se resuelve por exact Auth subject y activa `ISSUANCE_ACTIVE` en la misma DB transaction antes del final `signInWithPassword`; unbound exact-ID provisioning puede preceder esta compatibility porque no concede application/tenant authority.
**AC-021-071.** Custom Access Token Hook no resuelve `LaterUserEnrollmentIntent`, `CompanyMembership`, tenant role ni tenant authorization.
**AC-021-072.** Incompatible application identity produce DENY antes de provider provisioning/sign-in.
**AC-021-073.** Fail-closed classifier produce DENY antes de provider work.
**AC-021-074.** Compatible no-app identity puede continuar a Auth/session-only.
**AC-021-075.** Compatible existing PlatformUser no-SUPER_ADMIN y sin membership puede continuar a Auth/session-only.
**AC-021-076.** Hook no convierte intended_role en claim de authority.
**AC-021-077.** Hook no concede tenant authority ni recibe privilegios tenant/application-authorization.
**AC-021-078.** Compatibility deny ocurre antes del technical sign-in y no puede terminar como successful grant consume.

### Bypass prevention

**AC-021-079.** Public signup initial path permanece denied.
**AC-021-080.** OTP initial path permanece denied.
**AC-021-081.** Magiclink initial path permanece denied.
**AC-021-082.** Recovery initial path permanece denied.
**AC-021-083.** Unsupported auth method = default deny.
**AC-021-084.** Token refresh permanece separado de initial auth.

### RLS / multitenancy

**AC-021-085.** LaterUserEnrollmentIntent RLS permanece enabled.
**AC-021-086.** No anon direct CRUD.
**AC-021-087.** No authenticated direct CRUD.
**AC-021-088.** No generic tenant bypass.
**AC-021-089.** No caller-supplied tenant authority.
**AC-021-090.** No stale JWT role/tenant authority.
**AC-021-091.** Session sin PlatformUser no accede a tenant data.
**AC-021-092.** Session + PlatformUser sin membership no accede a tenant data.
**AC-021-093.** SUPER_ADMIN ordinary tenant bypass = NO.
**AC-021-094.** Cross-tenant data remains denied.

### DB/function hardening

**AC-021-095.** New platform-owned coordination table count expected = 2: `auth_subject_authority_anchors` + `later_user_initial_session_coordinations`; new tenant/product table count = 0.
**AC-021-096.** New product/domain column count expected = 0; new columns are limited to approved platform-owned coordination state.
**AC-021-097.** Historical migrations no se modifican.
**AC-021-098.** New DB functions are purpose-specific only.
**AC-021-099.** SECURITY DEFINER, si se usa, tiene safe search_path.
**AC-021-100.** SQL references are schema-qualified where hardening requires it.
**AC-021-101.** PUBLIC EXECUTE absent where applicable.
**AC-021-102.** anon EXECUTE absent.
**AC-021-103.** Compatibility helper/function, si existe, no queda como generic browser-executable privileged surface y no es invocable por el Hook para resolver tenant/application authorization.
**AC-021-104.** Post-session resolver accepts no authority parameters.
**AC-021-105.** Post-session resolver exposes bounded state only.

### Idempotency / concurrency

**AC-021-106.** SessionGrant/handoff es stable logical authorization correlation.
**AC-021-107.** Same retry re-resolves authoritative state.
**AC-021-108.** Different replay cannot reactivate terminal grant.
**AC-021-109.** Concurrent sign-ins produce at most one initial grant consume.
**AC-021-110.** Provider timeout does not cause blind duplicate create.
**AC-021-111.** Lost response prefers reconciliation.
**AC-021-112.** Existing valid session yields already-established behavior sólo tras demostrar exact authoritative correlation con el mismo TASK-021 handoff; uncorrelated session falla cerrado.
**AC-021-113.** No global lock is required.

### Failure / enumeration

**AC-021-114.** Browser errors do not enumerate provider-user existence.
**AC-021-115.** Browser errors do not enumerate PlatformUser existence.
**AC-021-116.** Browser errors do not disclose other-tenant membership.
**AC-021-117.** Browser errors do not disclose SUPER_ADMIN classification.
**AC-021-118.** Raw provider errors do not cross route boundary.
**AC-021-119.** Raw DB errors do not cross route boundary.
**AC-021-120.** Incompatible identity produces no account repair by inference.

### Application / UI

**AC-021-121.** No generic public continuation endpoint bearer-like.
**AC-021-122.** TASK-020 authoritative handoff precedes TASK-021 provider work.
**AC-021-123.** Caller-scoped/nonprivileged sign-in client is separate from Admin client.
**AC-021-124.** Session cookies use approved SSR boundary.
**AC-021-125.** Success destination is a purpose-specific later-user pending state whose exact pathname is deferred to fresh repository preflight.
**AC-021-126.** Success URL contains no authority-bearing query/fragment.
**AC-021-127.** No profile form is introduced.
**AC-021-128.** No tenant selector.
**AC-021-129.** No role selector for invitee.
**AC-021-130.** No Client selector.
**AC-021-131.** UI does not claim full user creation.
**AC-021-132.** UI does not claim tenant access.
**AC-021-133.** Post-session shell is authoritatively server-gated.

### Offline

**AC-021-134.** TASK-021 is online-only.
**AC-021-135.** No IndexedDB/Dexie authority.
**AC-021-136.** No offline Auth provisioning.
**AC-021-137.** No outbox replay of Admin operations.
**AC-021-138.** No Service Worker authority.
**AC-021-139.** Timeout recovery uses online reconciliation.

### Audit / explicit non-effects

**AC-021-140.** No new AuditEvent action.
**AC-021-141.** `USER_CREATED` not emitted.
**AC-021-142.** No PlatformUser mutation.
**AC-021-143.** No CompanyMembership mutation.
**AC-021-144.** No Client creation.
**AC-021-145.** No UserClientAccess creation.
**AC-021-146.** No SupportAccessGrant creation.
**AC-021-147.** No subscription/entitlement effect.
**AC-021-148.** No Phase 2 closure.

### Tests / Hosted / Git

**AC-021-149.** Happy-path new compatible Auth identity test passes.
**AC-021-150.** Happy-path existing compatible Auth identity test passes.
**AC-021-151.** Invalid handoff test passes.
**AC-021-152.** Same/cross-tenant incompatibility tests pass.
**AC-021-153.** SUPER_ADMIN incompatibility test passes.
**AC-021-154.** Enumeration resistance tests pass.
**AC-021-155.** SessionGrant lifecycle/race tests pass.
**AC-021-156.** Public Auth bypass tests pass.
**AC-021-157.** Lost-response reconciliation tests pass.
**AC-021-158.** Tenant RLS post-session negative tests pass.
**AC-021-159.** TASK-013 regressions pass.
**AC-021-160.** TASK-020 regressions pass.
**AC-021-161.** Relevant TASK-011/012/014/015 regressions pass.
**AC-021-162.** Lint passes.
**AC-021-163.** Strict typecheck passes.
**AC-021-164.** Repository build/verify required checks pass.
**AC-021-165.** `git diff --check = PASS`.
**AC-021-166.** Hosted Development verification is performed only after separate authorization.
**AC-021-167.** Hosted expected-only diff = PASS.
**AC-021-168.** No Staging/Production mutation occurs by inference.
**AC-021-169.** No Codex execution occurs before implementation authorization.
**AC-021-170.** All pre-ADR-0022 valid AC-021-001..169 remain preserved subject to the explicit corrected wording above; ADR-0022-specific criteria continue below.

### ADR-0022 exact-subject / coordination

**AC-021-171.** ADR-0022 se consume como `DONE / CLOSED` y S1 no se reabre.
**AC-021-172.** `AuthSubjectAuthorityAnchor` se materializa como platform-owned exact-subject serialization anchor.
**AC-021-173.** `LaterUserInitialSessionCoordination` se materializa como platform-owned durable logical-operation state.
**AC-021-174.** Unbound bridge no usa preliminary/discovery `signInWithPassword`.
**AC-021-175.** Unbound bridge reserva server-side un UUID v4 antes de provider mutation.
**AC-021-176.** Reserved UUID se persiste durablemente antes de `createUser`.
**AC-021-177.** Reserved UUID no es caller-selected ni authority.
**AC-021-178.** `createUser` recibe exactamente `id = reserved_uuid`.
**AC-021-179.** Provider success debe confirmar exactamente el expected subject.
**AC-021-180.** Ambiguous `createUser` se reconcilia sólo por `getUserById(reserved_uuid)`.
**AC-021-181.** Exact-ID outage conserva `PROVISIONING_UNKNOWN` y no permite sign-in/blind create.
**AC-021-182.** Reliable exact-ID absence permite sólo guarded replay con same UUID/bindings/operation.
**AC-021-183.** Duplicate/conflict + reserved UUID absent produce `REPAIR_REQUIRED` sin email search.
**AC-021-184.** Bound bridge usa `getUserById(AuthBridgeCredential.auth_user_id)` antes de final issuance.
**AC-021-185.** Arbitrary/caller-selected `getUserById` permanece prohibido.
**AC-021-186.** Email-derived provider directory lookup y `listUsers` permanecen prohibidos.
**AC-021-187.** Application compatibility se evalúa sólo por exact Auth subject.
**AC-021-188.** Compatibility check + `ISSUANCE_ACTIVE` activation son atómicos en la misma DB transaction.
**AC-021-189.** No DB row lock permanece abierto durante provider network I/O.
**AC-021-190.** Hook consume sólo exact subject/password/active coordination/eligible SessionGrant y marca `GATE_CONSUMED`.
**AC-021-191.** Provider session result se retiene server-side hasta terminal compatibility recheck.
**AC-021-192.** Browser cookie/session propagation ocurre sólo después de `SESSION_ESTABLISHED_NO_AUTHORITY` terminal commit.
**AC-021-193.** SessionGrant TTL continúa exactamente 5 minutos y la coordinación nunca lo extiende.
**AC-021-194.** At most one active coordination existe por authoritative handoff/purpose.
**AC-021-195.** At most one active initial-session fence existe por exact subject.
**AC-021-196.** Future later-user membership creation debe respetar active subject fence.
**AC-021-197.** TASK-015 reinstate y enabled membership role-change respetan subject fence antes de authority-increasing commit.
**AC-021-198.** Future `is_super_admin=true` writer respeta subject fence.
**AC-021-199.** Participating reverse PlatformUser→subject mapping exige exactamente un recognized subject; zero/>1 fail closed/return for review.
**AC-021-200.** Canonical lock precedence de ADR-0022 se preserva sin `anchor → MaintenanceCompany` inversion.
**AC-021-201.** CORR-035 actor→company→intent ordering permanece intacto.
**AC-021-202.** Alias-sensitive pre-anchor acquisition usa non-waiting/fail-fast semantics y nunca bloqueo `P → anchor(S)`.
**AC-021-203.** `ALIAS-01/02/03` real concurrency tests demuestran no `40P01`, no hang, no unlock-and-switch y no partial authority mutation.
**AC-021-204.** TASK-021 compatibility reads no requieren target PlatformUser/Auth mapping/CompanyMembership row locks; cualquier lock futuro exige alias-safety proof o STOP.
**AC-021-205.** Hook no adquiere tenant/application-authority locks y `supabase_auth_admin` conserva cero privilegios tenant/application authorization.
**AC-021-206.** New tables remain platform-owned technical state and create no product entity/tenant authority.
**AC-021-207.** TASK-013 documentation/state-machine sync is required before TASK-021 implementation.
**AC-021-208.** TASK-013 privileged Auth Admin allowlist queda narrowly qualified only for exact-ID TASK-021 pre-issuance reconciliation.
**AC-021-209.** Installed SDK + Hosted contracts for custom `createUser(id)` and exact `getUserById` are reverified before implementation.
**AC-021-210.** Provider UUID v4 behavior is described as project-side generation; no unsupported claim that provider independently validates UUID version 4.
**AC-021-211.** No account linking/multiple Auth identities feature is introduced.
**AC-021-212.** No global mutex or distributed transaction is introduced.
**AC-021-213.** All applicable AC-021-001..212 are PASS before technical completion.


---

## 38. Definition of Done

Ningún Gate implica automáticamente el siguiente.

**DoD-021-001.** `TASK-021 SPECIFICATION GENERATION = PASS`.
**DoD-021-002.** Corrected specification artifact exists in `CORRECTED / PENDING CENTRAL REVIEW` after the explicit correction Gate.
**DoD-021-003.** `TASK-021 CORRECTED SPEC REVIEW = APPROVED` in separate Gate.
**DoD-021-004.** Any review correction is applied through an explicit correction Gate.
**DoD-021-005.** Human specification approval is obtained separately.
**DoD-021-006.** Approved artifact is generated only after human approval.
**DoD-021-007.** Approved artifact receives separate review approval.
**DoD-021-008.** Canonicalization receives separate explicit authorization.
**DoD-021-009.** Canonicalization is executed separately.
**DoD-021-010.** Canonicalization review is approved.
**DoD-021-011.** Repository incorporation receives separate authorization.
**DoD-021-012.** Canonical artifact is incorporated only after that authorization.
**DoD-021-013.** Repository incorporation review is approved.
**DoD-021-014.** Implementation receives separate explicit human authorization.
**DoD-021-015.** Fresh Git preflight passes immediately before implementation.
**DoD-021-016.** Canonical sources are reread physically before implementation.
**DoD-021-017.** Repository physical contracts are inspected before mutation.
**DoD-021-018.** Supabase official provider contracts are reverified before provider work.
**DoD-021-019.** No material canonical/provider contradiction remains.
**DoD-021-020.** Implementation stays inside the approved bounded path/scope set.
**DoD-021-021.** Historical migrations remain unmodified.
**DoD-021-022.** Expected forward-only migration, if required, is the only schema migration for TASK-021.
**DoD-021-023.** Exact-subject application compatibility and `ISSUANCE_ACTIVE` fence activation are implemented atomically before final `signInWithPassword`; unbound exact-ID provisioning follows ADR-0022 and the Hook remains platform-owned.
**DoD-021-024.** No-app-identity compatibility path passes.
**DoD-021-025.** Compatible existing PlatformUser/no-membership path passes.
**DoD-021-026.** SUPER_ADMIN path fails closed.
**DoD-021-027.** Same-tenant existing membership path fails new enrollment.
**DoD-021-028.** Disabled membership path routes away from new enrollment semantics.
**DoD-021-029.** Cross-tenant existing membership path fails closed.
**DoD-021-030.** Ambiguous/corrupt identity fails closed.
**DoD-021-031.** Auth Admin adapter remains purpose-specific/server-only.
**DoD-021-032.** No generic Admin/service-role client exists.
**DoD-021-033.** Technical password remains server-only.
**DoD-021-034.** Canonical Hosted password policy compatibility is verified.
**DoD-021-035.** No blind duplicate createUser retry.
**DoD-021-036.** Ambiguous provider response reconciliation passes.
**DoD-021-037.** SessionGrant exact TTL/single-use/revocation semantics remain.
**DoD-021-038.** Hook concurrency proves at most one initial grant consume.
**DoD-021-039.** Public signup bypass denied.
**DoD-021-040.** OTP/magiclink/recovery initial bypass denied.
**DoD-021-041.** Post-session state is authenticated but not tenant-authorized.
**DoD-021-042.** Tenant RLS remains deny without membership despite valid session.
**DoD-021-043.** No PlatformUser/profile mutation occurs.
**DoD-021-044.** No CompanyMembership mutation occurs.
**DoD-021-045.** No `USER_CREATED` occurs.
**DoD-021-046.** No Client/UserClientAccess/SupportAccessGrant occurs.
**DoD-021-047.** RF-015 remains unsatisfied.
**DoD-021-048.** Online-only boundary preserved.
**DoD-021-049.** Pending UI is server-gated and bounded, with exact pathname selected only after fresh repository preflight.
**DoD-021-050.** No authority-bearing URL/session metadata is added.
**DoD-021-051.** Relevant static/application tests pass.
**DoD-021-052.** Relevant DB/RLS tests pass.
**DoD-021-053.** Real concurrency tests pass where required.
**DoD-021-054.** Relevant TASK-009/011/012/013/014/015/020 regressions pass.
**DoD-021-055.** Relevant TASK-018 security/session precedent regressions remain passing or any historical compatibility issue is separately corrected.
**DoD-021-056.** Lint passes.
**DoD-021-057.** Strict typecheck passes.
**DoD-021-058.** Build/verify passes.
**DoD-021-059.** Implementation review is approved.
**DoD-021-060.** Hosted Development authorization is granted separately before remote mutation.
**DoD-021-061.** Hosted Development implementation/verification passes exactly expected scope.
**DoD-021-062.** Hosted review is approved.
**DoD-021-063.** Staging authorization is separate and approved.
**DoD-021-064.** Staging contains only reviewed paths.
**DoD-021-065.** Staging review is approved.
**DoD-021-066.** Commit authorization is separate and approved.
**DoD-021-067.** Commit contains only reviewed paths.
**DoD-021-068.** Commit review is approved.
**DoD-021-069.** Push authorization is separate and approved.
**DoD-021-070.** Push is normal/non-force and limited to approved commit.
**DoD-021-071.** Push review/remote verification is approved.
**DoD-021-072.** Final human closure is a separate mandatory Gate.
**DoD-021-073.** TASK-021 final closure does not imply Phase 2 closure.
**DoD-021-074.** TASK-021 final closure does not define Phase 2 Exit Gate.
**DoD-021-075.** TASK-021 final closure does not start Phase 3.
**DoD-021-076.** No next TASK is determined automatically.


**DoD-021-077.** ADR-0022 is consumed as `DONE / CLOSED` without reopening S1.
**DoD-021-078.** `auth_subject_authority_anchors` is implemented as exact-subject platform-owned serialization state.
**DoD-021-079.** `later_user_initial_session_coordinations` is implemented with the approved lifecycle and immutable bindings.
**DoD-021-080.** Single-active handoff/purpose and subject-fence constraints are enforced physically.
**DoD-021-081.** Unbound subject UUID is generated/persisted before provider mutation and is never caller authority.
**DoD-021-082.** Unbound flow has no preliminary/discovery sign-in.
**DoD-021-083.** `createUser(id=reserved_uuid)` + exact-ID reconciliation pass all success/ambiguous/conflict cases.
**DoD-021-084.** `getUserById` is exact-ID/purpose-specific only; arbitrary lookup/listUsers/email-directory paths are absent.
**DoD-021-085.** Compatibility + `ISSUANCE_ACTIVE` activation are atomic under `AuthSubjectAuthorityAnchor`.
**DoD-021-086.** No DB row lock spans provider network I/O.
**DoD-021-087.** Hook consumes eligible grant and transitions coordination to `GATE_CONSUMED` without tenant/application-authority reads.
**DoD-021-088.** Terminal compatibility recheck passes under the same subject anchor before browser session propagation.
**DoD-021-089.** `SESSION_ESTABLISHED_NO_AUTHORITY` terminal commit precedes cookie/session delivery.
**DoD-021-090.** Participating authority-producing writers respect the subject fence.
**DoD-021-091.** Canonical lock precedence and CORR-035 ordering are preserved.
**DoD-021-092.** Physical-row alias concurrency coverage `ALIAS-01/02/03` passes without `40P01`, hang, unlock-and-switch or partial mutation.
**DoD-021-093.** Reverse PlatformUser→subject participating-writer rule fails closed on zero/>1 mappings.
**DoD-021-094.** SessionGrant remains exactly 5 minutes, single-use, non-resurrectable.
**DoD-021-095.** TASK-013 documentation/state-machine sync is approved before TASK-021 implementation authorization.
**DoD-021-096.** Installed SDK/Hosted provider contract for custom ID + exact-ID lookup is verified before mutation.
**DoD-021-097.** No account linking, multiple-identities feature, global mutex, distributed transaction, product-role/client/offline scope expansion is introduced.


---

## 39. Implementation blockers

Future implementation must STOP and return to Revisor Central if any occurs:

1. required canonical source missing;
2. ADR-0022 physical/canonical identity cannot be verified;
3. canon contradiction or S1 would require reinterpretation;
4. repository physical contracts drift materially;
5. ADR-0019 dependency no longer demonstrable;
6. ADR-0021 boundary would require reinterpretation;
7. TASK-013 documentation/state-machine sync is not approved;
8. new product decision becomes necessary;
9. new architectural decision becomes necessary;
10. custom `createUser(id)` contract cannot be demonstrated with installed SDK/Hosted;
11. exact `getUserById` contract cannot be demonstrated;
12. provider requires email-directory/listUsers lookup to reconcile identity;
13. unbound flow would require preliminary/discovery sign-in;
14. provider preexisting account would require account linking/password takeover;
15. reserved subject cannot be persisted before provider mutation;
16. ambiguous provider result cannot be reconciled by exact reserved UUID;
17. new durable coordination state cannot enforce single-active semantics;
18. `AuthSubjectAuthorityAnchor` cannot be used as stable subject-scoped serialization anchor;
19. compatibility + `ISSUANCE_ACTIVE` cannot be atomic in one DB transaction;
20. implementation requires DB row lock across provider network I/O;
21. authority-producing writer cannot participate in same subject fence before commit;
22. future membership creation/reinstate/enabled-role-change/is_super_admin writer can ignore fence;
23. participating reverse PlatformUser→subject lookup yields zero/>1 and code attempts to guess/relink;
24. CORR-035 actor→company→intent order would need reversal;
25. alias-sensitive TASK-019 path requires blocking wait on target anchor while pre-anchor PlatformUser/company/intent locks are held;
26. implementation requires unlock-and-switch to avoid alias deadlock;
27. required alias-safety proof cannot be established for any new anchor→PlatformUser row lock;
28. real concurrency shows `SQLSTATE 40P01` or bounded hang;
29. generic privileged client becomes necessary;
30. ordinary service-role request client becomes necessary;
31. `supabase_auth_admin` would need tenant/application-authorization privileges;
32. Hook would need MaintenanceCompany/PlatformUser/CompanyMembership authority state;
33. tenant authority would derive from Auth/session/JWT/intended_role;
34. PlatformUser/profile/membership mutation by TASK-021 becomes necessary;
35. Client/UserClientAccess/SupportAccessGrant becomes necessary;
36. USER_CREATED would need emission;
37. RF-015 would need to be treated as satisfied;
38. SessionGrant cannot remain single-use/exactly 5 minutes;
39. consumed VerificationChallenge or SessionGrant would need resurrection;
40. technical password cannot remain server-only;
41. public Auth bypass cannot remain denied;
42. RLS tenant isolation cannot be preserved;
43. direct browser intent/coordination CRUD becomes necessary;
44. browser-visible provider/account enumeration becomes necessary;
45. offline privileged replay becomes necessary;
46. global mutex/advisory platform lock becomes necessary;
47. distributed transaction/provider+DB open transaction becomes necessary;
48. tests fail;
49. Hosted expected-only verification fails;
50. unexpected Git/Supabase drift exists;
51. implementation requires unreviewed production path expansion;
52. any Acceptance Criterion fails.

Rule:

```text
STOP
NO SCOPE EXPANSION
NO SILENT REPAIR
NO FALLBACK TO EMAIL DIRECTORY OR PRELIMINARY SIGN-IN
RETURN TO REVISOR CENTRAL
```

---

## 40. Future implementation decomposition for Codex

Implementation is NOT authorized by this specification.

If later explicitly authorized, execution must remain in small verifiable work items and must not advance to the next item until the previous item is reviewed/passing.

### Work Item A — Physical coordination foundation

**Objective**

Materialize `AuthSubjectAuthorityAnchor` + `LaterUserInitialSessionCoordination` exactly as approved.

**Context**

Consumes ADR-0022 §§18–20/33–34 and current TASK-013/020 physical schema.

**Scope**

- fresh schema preflight;
- two platform-owned tables;
- lifecycle/integrity/single-active constraints;
- minimum indexes;
- exact grants/revokes;
- no browser direct CRUD.

**Out of scope**

Provider calls, UI, PlatformUser/membership mutation, tenant authority.

**Security/RLS**

No tenant-owned RLS weakening; no generic privileged client; `supabase_auth_admin` gets no tenant/application-authority privilege.

**Acceptance/tests**

Physical §15/§16 + relevant AC-171..173/193..195/206.

### Work Item B — Exact-subject provider reconciliation adapter

**Objective**

Implement bound/unbound exact-subject resolution without preliminary sign-in or provider directory enumeration.

**Scope**

- server UUID v4 reservation;
- persist before provider mutation;
- exact `getUserById`;
- `createUser(id=reserved_uuid)`;
- ambiguous-result reconciliation;
- guarded replay;
- bridge exact-subject binding.

**Out of scope**

Final sign-in, compatibility/fence, UI.

**Security**

No listUsers/email directory/arbitrary ID/password takeover/account linking.

**Acceptance/tests**

AC-174..186/209..210.

### Work Item C — Exact-subject compatibility + issuance fence

**Objective**

Implement fresh compatibility + `ISSUANCE_ACTIVE` atomic activation under `AuthSubjectAuthorityAnchor`.

**Scope**

- exact-subject mapping classification;
- SUPER_ADMIN/membership fail-closed;
- no target authority row locks solely for freshness;
- purpose-specific short DB transaction.

**Out of scope**

Provider network work while DB lock held.

**Security/RLS**

Current DB state authoritative; no tenant authority created.

**Acceptance/tests**

AC-187..189/204.

### Work Item D — Cross-flow writer participation + alias safety

**Objective**

Extend existing authority-producing writers only as required to respect ADR-0022 subject fence and canonical lock graph.

**Scope**

- TASK-019 CORR-035-compatible anchor participation;
- alias precheck + fail-fast anchor;
- TASK-015 reinstate/enabled-role-change participation;
- future-writer fixtures/contracts as applicable;
- reverse mapping exactly-one rule.

**Out of scope**

New membership capability, product rule changes, account linking.

**Security/RLS**

No lock inversion; no authority mutation when fence active.

**Acceptance/tests**

AC-196..203 plus real ALIAS-01/02/03 concurrency.

### Work Item E — Hook coordination + final session issuance

**Objective**

Integrate platform-owned coordination state into ADR-0019 E2 Hook and final sign-in without tenant-aware Hook behavior.

**Scope**

- final `signInWithPassword` after `ISSUANCE_ACTIVE`;
- Hook exact subject/method/coordination/grant check;
- `GATE_CONSUMED` atomic transition;
- no tenant/application-authority reads.

**Out of scope**

Browser delivery before terminal recheck.

**Security/RLS**

Zero tenant/application privilege expansion for `supabase_auth_admin`.

**Acceptance/tests**

AC-190/205 plus Hook/SessionGrant regression set.

### Work Item F — Terminal revalidation + SSR delivery

**Objective**

Ensure provider success is not browser-visible until same-subject terminal compatibility recheck succeeds.

**Scope**

- retain provider result server-side;
- reacquire same anchor;
- terminal compatibility check;
- `SESSION_ESTABLISHED_NO_AUTHORITY`;
- release fence + commit;
- then propagate SSR cookies.

**Out of scope**

Tenant dashboard/domain completion.

**Acceptance/tests**

AC-191..192 and lost-response/cookie negative coverage.

### Work Item G — TASK-020 orchestration integration + pending UI

**Objective**

Compose TASK-021 after authoritative TASK-020 handoff and retain bounded authenticated-not-authorized UX.

**Scope**

- exact existing later-user verification orchestration after fresh preflight;
- no second bearer continuation API;
- purpose-specific pending page;
- authoritative pending resolver;
- bounded copy.

**Out of scope**

Profile, membership, role/client selectors, dashboard.

**Security/RLS**

No authority-bearing URL/state; valid session alone cannot access tenant data.

### Work Item H — Regression / concurrency / evidence package

**Objective**

Prove full TASK-021 boundary before Hosted.

**Scope**

- §35 complete;
- real concurrency + alias cases;
- provider exact-ID tests;
- RLS/bypass tests;
- lint/typecheck/build/verify;
- evidence inventory.

**Out of scope**

New feature work.

### Work Item I — Hosted Development verification

**Objective**

Verify exactly reviewed TASK-021 implementation in Hosted Development.

**Precondition**

Separate human authorization and TASK-013 documentation/state-machine sync already approved.

**Scope**

§36 only.

**Out of scope**

Staging, Production, Git persistence by inference.

---

## 41. Future implementation preflight

Immediately before implementation, Codex must inspect and report:

### 41.1 Git

- repo root;
- branch;
- HEAD;
- origin/main;
- divergence;
- worktree;
- staged/untracked;
- Git operations in progress.

### 41.2 Canon

Read physically and verify no superseding decision:

- product/RLS canon;
- ADR-0019;
- ADR-0021;
- ADR-0022 canonical SHA/commit;
- TASK-013 canonical + approved documentation/state-machine sync consuming ADR-0022;
- TASK-015;
- TASK-019/CORR-035;
- TASK-020;
- this canonical TASK-021 specification once approved.

If TASK-013 sync is absent:

```text
TASK-021 IMPLEMENTATION = BLOCKER
```

### 41.3 Repository/schema

Inspect real:

- TASK-020 later-user implementation paths;
- TASK-019/CORR-035 lock implementation;
- TASK-015 membership lifecycle writer implementation;
- current Auth/session service patterns;
- Custom Access Token Hook function;
- `auth_bridge_credentials`;
- `auth_session_grants`;
- `later_user_enrollment_intents`;
- `platform_user_auth_subjects`;
- `platform_users`;
- `company_memberships`;
- grants/RLS/policies;
- existing transaction/lock helpers;
- test harnesses/concurrency conventions;
- package/dependency versions;
- Next.js/Supabase integration.

### 41.4 Provider / installed SDK / Hosted

Reverify with official/current contracts and installed version:

```text
auth.admin.createUser with custom id
auth.admin.getUserById exact UUID
signInWithPassword
Custom Access Token Hook
SSR session/cookie transport
password policy/current-password configuration
```

Project requirement:

```text
reserved UUID generation = UUID v4 server-side
```

Do not claim provider independently enforces UUID version 4 unless explicitly proven.

### 41.5 Lock graph / alias preflight

Map current physical lock acquisition for TASK-019/TASK-015 and prove that inserting `AuthSubjectAuthorityAnchor` can preserve:

```text
actor/provenance
→ MaintenanceCompany
→ tenant intent
→ subject anchor
→ target authority rows
```

Identify every potentially aliasable PlatformUser row before coding.

Any material drift/contradiction:

```text
STOP
RETURN TO REVISOR CENTRAL
```

---

## 42. Security review checklist

Central Review must verify at least:

- ADR-0022 S1 consumed without reinterpretation;
- no Auth session is treated as tenant authority;
- unbound subject is server-preallocated/persisted before provider mutation;
- no preliminary/discovery sign-in;
- exact-ID `getUserById` only;
- no listUsers/email-directory/arbitrary subject lookup;
- no provider identity takeover/account linking;
- exact provider subject confirmed before bridge binding;
- application compatibility is evaluated by exact subject;
- compatibility + `ISSUANCE_ACTIVE` activation are atomic;
- no DB lock spans provider network I/O;
- active subject fence is respected by authority-producing writers;
- CORR-035 order is preserved;
- alias-sensitive anchor acquisition is fail-fast/non-waiting;
- no opposite blocking wait `P ↔ anchor(S)`;
- reverse PlatformUser→subject lookup fails closed on zero/>1;
- terminal compatibility recheck occurs before browser delivery;
- Hook remains platform-owned and not tenant-aware;
- `supabase_auth_admin` has zero tenant/application authority privileges;
- any membership, including disabled, blocks TASK-021 issuance;
- SUPER_ADMIN blocks ordinary later-user enrollment;
- no PlatformUser/membership mutation slipped into TASK-021;
- SessionGrant remains single-use/exactly 5m;
- no consumed challenge/grant resurrection;
- technical password server-only;
- no Client placeholder/RF-015 overclaim;
- no first-admin route/API genericization;
- no offline authority;
- no global mutex/distributed transaction;
- Hosted verification remains gated separately.

---

## 43. Specification review checklist

The Revisor Central should verify:

1. identification/title/task number;
2. corrected-v2 governance state;
3. START exact;
4. END exact = authenticated but not tenant-authorized;
5. all out-of-scope boundaries;
6. product RF impact unchanged;
7. ADR-0019 reuse/core E2 unchanged;
8. ADR-0021 reuse unchanged;
9. ADR-0022 S1 complete consumption;
10. TASK-013 sync prerequisite explicit;
11. platform-owned `AuthSubjectAuthorityAnchor` physical contract;
12. platform-owned `LaterUserInitialSessionCoordination` physical contract;
13. lifecycle/single-active/integrity constraints;
14. exact-subject bound flow;
15. unbound preallocated subject flow;
16. no preliminary discovery sign-in;
17. exact-ID Auth Admin qualification/no listUsers;
18. ambiguous create/guarded replay/repair model;
19. exact-subject application compatibility;
20. durable fence + terminal recheck;
21. no remote DB lock;
22. cross-flow lock precedence;
23. CORR-035 preservation;
24. physical-row alias closure + fail-fast acquisition;
25. TASK-015/future-writer participation;
26. Hook platform-owned boundary + zero tenant privilege;
27. SessionGrant expiry/recovery semantics exactly 5m;
28. browser session delivery after terminal commit only;
29. RLS/grant posture;
30. application/server orchestration;
31. pending UI semantics unchanged;
32. no first-admin genericization;
33. online-only;
34. AuditEvent non-effects;
35. exhaustive real concurrency/security tests;
36. AC-021-001..213 completeness/uniqueness;
37. DoD sequential governance;
38. F-021-SPEC-006 corrected Gate label;
39. blockers;
40. Codex work-item decomposition;
41. no repo/Supabase/TASK-013 mutation by this document.

---

## 44. Final specification state

```text
TASK-021 SPECIFICATION GENERATION =
PASS

TASK-021 SPEC REVIEW =
RETURNED FOR CORRECTION

TASK-021 SPECIFICATION CORRECTION =
PASS

F-021-SPEC-001 =
CORRECTED

F-021-SPEC-002 =
CORRECTED

F-021-SPEC-003 =
CORRECTED

ADR-0022 FINAL HUMAN CLOSURE =
APPROVED

ADR-0022 =
DONE / CLOSED

TASK-021 POST-ADR-0022 SPECIFICATION REEVALUATION =
APPROVED FOR CORRECTION

TASK-021 POST-ADR-0022 SPECIFICATION CORRECTION GENERATION =
PASS

TASK-021 CORRECTED SPEC REVIEW =
APPROVED

TASK-021 HUMAN SPEC APPROVAL =
APPROVED

F-021-SPEC-004 =
RESOLVED

F-021-SPEC-005 =
RESOLVED

F-021-SPEC-006 =
RESOLVED

TASK-021 specification =
HUMAN APPROVED

TASK-021 corrected-v2 artifact =
HUMAN APPROVED

TASK-021 approved artifact generation =
PASS

TASK-021 approved artifact =
GENERATED / PENDING APPROVED ARTIFACT REVIEW

TASK-021 =
DETERMINED / SPECIFICATION HUMAN APPROVED / NOT IMPLEMENTATION AUTHORIZED

TASK-021 START =
AUTHORITATIVE TASK-020 HANDOFF / VALID CONSUMED PROOF / CORRELATED SESSION GRANT

TASK-021 END =
COMPATIBLE AUTH IDENTITY + INITIAL AUTH SESSION
/ AUTHENTICATED BUT NOT TENANT-AUTHORIZED

ADR-0019 reuse =
YES / CORE E2 UNCHANGED

ADR-0021 reuse =
YES

ADR-0022 reuse =
YES / S1 CONSUMED

new architecture decision required =
NO

TASK-013 privileged Auth Admin allowlist =
NARROWLY QUALIFIED BY ADR-0022

TASK-013 documentation/state-machine sync =
REQUIRED BEFORE TASK-021 IMPLEMENTATION

TASK-013 modification by this artifact =
NONE

implementation =
NOT AUTHORIZED

Codex =
NOT AUTHORIZED

repository mutation =
NONE

Supabase mutation =
NONE

staging =
NO

commit =
NO

push =
NO

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED

next Gate =
TASK-021 APPROVED ARTIFACT REVIEW

DESTINO =
REVISOR CENTRAL — ESTE MISMO CHAT
```

STOP
