# TASK-018 — Authoritative First-Admin Auth Identity Reconciliation and Session Establishment Foundation

## 1. Identificación

**ID:** `TASK-018`

**Título:** `TASK-018 — Authoritative First-Admin Auth Identity Reconciliation and Session Establishment Foundation`

**Clase:** `FUNCTIONAL FOUNDATION / RF-012 CONTINUATION`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Estado de esta specification:**

```text
TASK-018 CENTRAL SPEC REVIEW =
APPROVED

TASK-018 CENTRAL SPEC REVIEW FINAL =
APPROVED

TASK-018 HUMAN SPECIFICATION APPROVAL =
APPROVED

TASK-018 SPECIFICATION =
APPROVED
```

**Specification generation Gate:**

```text
TASK-018 SPECIFICATION GENERATION GATE =
AUTHORIZED / REMAINS AUTHORIZED
```

**Implementación autorizada:** `NO`

**Codex autorizado:** `NO`

**Repositorio modificado por esta specification:** `NO`

**Supabase / Hosted / JIT modificado por esta specification:** `NO / NO / NO`

**Staging / commit / push:** `NO / NO / NO`

**TASK-019:** `NOT DETERMINED / NOT AUTHORIZED`

Esta specification define exclusivamente el contrato de un futuro incremento acotado de Fase 2. No implementa TASK-018, no autoriza ejecución, no autoriza Codex y no convierte la aprobación de esta specification en autorización automática para modificar repositorio o Supabase.

---

## 2. Recovered canonical source verification

### 2.1 Package físico recibido

Package:

`TASK-018-canonical-source-recovery.zip`

Verificación efectuada directamente sobre los bytes físicos recibidos:

```text
expected SHA-256 =
5cb77359da54aa20bd4e3bd96da03a6b517cac411247640ce0923bac4cb1cc76

actual SHA-256 =
5cb77359da54aa20bd4e3bd96da03a6b517cac411247640ce0923bac4cb1cc76

expected bytes = 72614
actual bytes   = 72614

expected entry count = 3
actual entry count   = 3
```

No existen entries adicionales.

### 2.2 SOURCE 1

`SOURCE-01-ADR-0020-authoritative-first-admin-onboarding-intent-binding.md`

```text
SHA-256 = 30480be7c24a260fe4d6d8231cb83134133192e9b37f052310b9522196be1a5c
bytes = 74803
LF = 1768
CRLF = 0
bare CR = 0
trailing-whitespace lines = 0
final newline = YES
```

Resultado: `PASS`.

La entry recuperada representa físicamente la fuente canónica requerida:

`docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md`.

### 2.3 SOURCE 2

`SOURCE-02-TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md`

```text
SHA-256 = 6d70b742045537ff5accec07af50b1dbd316301ea1ddf8516c9e2fe040bacad6
bytes = 101908
LF = 2911
CRLF = 0
bare CR = 0
trailing-whitespace lines = 0
final newline = YES
```

Resultado: `PASS`.

La entry recuperada representa físicamente la fuente canónica requerida:

`docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md`.

### 2.4 SOURCE 3

`SOURCE-03-CORR-028-task-017-closure-state-sync.md`

```text
SHA-256 = 012a7517ce5fa8eb7720d64acdd67eed16970ebbe56b68ab9195f8f982eb6553
bytes = 60264
LF = 2711
CRLF = 0
bare CR = 0
trailing-whitespace lines = 0
final newline = YES
```

Resultado: `PASS`.

La entry recuperada representa físicamente la fuente canónica requerida:

`docs/tasks/CORR-028-task-017-closure-state-sync.md`.

### 2.5 Resultado de recuperación

```text
TASK-018 RECOVERED SOURCE VERIFICATION = PASS
TASK-018 REQUIRED CANONICAL SOURCE AVAILABILITY = SATISFIED
```

Se reanuda el mismo Gate original. No se inicia un Gate nuevo y no se cambia la identidad ni el scope de TASK-018.

---

## 3. Governance de entrada

Se consume como estado vigente de entrada:

```text
CORR-028 = DONE / CLOSED

repository baseline =
710c15b780619622a2bf76b2321f3b628d08fbea

origin/main =
710c15b780619622a2bf76b2321f3b628d08fbea

repository = CLEAN / SYNCHRONIZED

Phase 2 = IN PROGRESS / NOT CLOSED
Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED
Phase 3 = NOT STARTED

RF-004 = PARTIAL / NOT END-TO-END
RF-012 = INCOMPLETE

TASK-017 = DONE / CLOSED
TASK-018 = DETERMINED
TASK-019 = NOT DETERMINED / NOT AUTHORIZED
```

El registro histórico de CORR-028 contiene el estado anterior `TASK-018 = NOT DETERMINED / NOT AUTHORIZED` porque CORR-028 precede a la determinación y autorización humana de generación de TASK-018. Ese snapshot histórico no contradice el Gate posterior vigente y no lo sobreescribe.

Debe permanecer durante toda TASK-018:

```text
TASK-018 specification approval
!=
TASK-018 implementation authorization

TASK-018 implementation PASS
!=
TASK-018 DONE / CLOSED

TASK-018 DONE / CLOSED
!=
TASK-019 determined automatically
```

---

## 4. Fuentes canónicas y source-of-truth hierarchy

### 4.1 Fuentes mínimas obligatorias consumidas

1. `docs/product/00-master-product-brief.md`
2. `docs/product/01-product-definition.md`
3. `docs/product/02-domain-model.md`
4. `docs/product/03-permissions-rls-strategy.md`
5. `docs/product/11-phase-1-scope-entry-gate.md`
6. `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`
7. `docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md`
8. `docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md`
9. `docs/tasks/TASK-013-verification-challenge-foundation.md`
10. `docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md`
11. `docs/tasks/CORR-028-task-017-closure-state-sync.md`

Las once fuentes están físicamente disponibles para esta generación.

### 4.2 Dependencia material adicional justificada

Se consume además:

`docs/tasks/TASK-010-audit-event-foundation.md`

Justificación estricta:

- **motivo:** el prompt original de TASK-018 obliga a determinar exactamente qué `AuditEvent` requiere el incremento y prohíbe inventar action names;
- **dimensión gobernada:** catálogo físico vigente y semántica de `AuditEvent`;
- **por qué las fuentes mínimas no bastan:** las fuentes mínimas preservan `USER_CREATED` como acción existente y difieren su timing, pero no enumeran por sí solas todo el catálogo físico admitido ni la obligación física de `subject_platform_user_id` para las acciones actualmente representables;
- **uso limitado:** TASK-010 se consume exclusivamente para responder la dimensión de auditoría. No se amplía el scope de identidad, tenant, sesión o onboarding.

No se añade ninguna otra fuente material.

### 4.3 Jerarquía por dimensión

| Dimensión | Fuente de verdad aplicable | Regla de precedencia |
|---|---|---|
| Requisitos de producto | `01-product-definition.md`, con `00-master-product-brief.md` como consolidado anterior | decisión posterior aprobada > wording histórico |
| Semántica de dominio | `02-domain-model.md` | no convertir diseño físico en requisito de dominio |
| Seguridad / RLS / multitenancy | `03-permissions-rls-strategy.md` + ADR aplicables | current PostgreSQL authority > caller state |
| Auth/session architecture | ADR-0019 + TASK-011 | E2 y lifecycle SSR se preservan, no se rediseñan |
| Verification/proof semantics | TASK-013 + TASK-017 | challenge/attempt/grant/handoff vigentes gobiernan la continuación |
| First-admin handoff semantics | ADR-0020 + TASK-017 | tenant/email/purpose derivan del intent, no del browser |
| AuditEvent físico | TASK-010, limitado a auditoría | no inventar acciones ni subjects incompatibles |
| Current governance state | CORR-028 + Gate humano vigente de TASK-018 | snapshot histórico no sobreescribe autorización posterior |
| Estado físico futuro | repositorio real en preflight de implementación | esta specification no sustituye inspección del repositorio |

### 4.4 Regla temporal

Una declaración histórica correcta en el momento en que fue escrita no prevalece contra un estado posterior aprobado.

En particular:

```text
CORR-028: TASK-018 not determined
<
posterior TASK-018 determination + specification generation authorization
```

Esto no constituye contradicción de fuente.

---

## 5. Revisión de contradicciones y blockers de generación

Resultado de esta generación:

```text
required canonical sources available = YES
recovered source identity drift = NO
material source contradiction = NO
product decision required before this bounded slice = NO
domain decision required before this bounded slice = NO
new ADR required before TASK-018 = NO
security/RLS/multitenancy decision missing = NO
auth boundary unspecified = NO
audit semantics unspecified = NO
external atomicity falsely assumed = NO
scope expansion required = NO

TASK-018 SPECIFICATION BLOCKER = NONE
```

La specification puede completarse porque el canon ya determina la arquitectura E2 necesaria para crear/reconciliar una identidad Auth y establecer exactamente una sesión inicial desde un `SessionGrant` válido. Las decisiones todavía abiertas sobre `PlatformUser`, `CompanyMembership`, perfil y habilitación tenant quedan fuera del END de TASK-018 y no son necesarias para materializar esta frontera.

---

## 6. Objetivo

TASK-018 define el siguiente incremento funcional acotado después de TASK-017:

> Consumir un `authoritative first-admin onboarding handoff` válido y todavía utilizable, derivar exclusivamente desde estado autoritativo el email/purpose/contexto correspondientes, crear o reconciliar de forma determinista la identidad Supabase Auth requerida por E2 y establecer una sesión Supabase inicial mediante el `SessionGrant` single-use, sin crear ni completar `PlatformUser`, `CompanyMembership`, perfil, tenant authority ni onboarding completion.

Debe implementar conceptualmente la continuación:

```text
TASK-017 durable handoff
→ validate current handoff / grant / binding
→ reconcile or provision Supabase Auth identity
→ server-only technical-password sign-in
→ Custom Access Token Hook
→ atomic SessionGrant consume + Auth subject bridge binding
→ Supabase session
→ TASK-011-compatible SSR cookie propagation
```

Debe conservar:

```text
Auth identity != PlatformUser
Auth identity != CompanyMembership
Auth identity != tenant authority
Auth session != tenant authorization
handoff != identity
handoff != membership
```

---

## 7. START / END exactos

### 7.1 START

START de TASK-018 existe únicamente cuando el servidor puede resolver autoritativamente un `FirstAdminOnboardingIntent` que satisface simultáneamente:

1. el intent existe;
2. `handoff_ready_at` está presente;
3. `handoff_session_grant_id` está presente;
4. el grant referenciado corresponde al challenge current que produjo el handoff;
5. ese challenge está consumido válidamente;
6. `MaintenanceCompany` deriva del intent;
7. target email deriva del intent;
8. purpose es implícitamente `first-admin onboarding`;
9. intended role es implícitamente `COMPANY_ADMIN`, sólo como contexto futuro y no como authority;
10. no existe evidencia de onboarding completion;
11. el caller no ha elegido tenant, role, email, challenge, Auth subject ni grant como autoridad.

El START no es un objeto bearer enviado al browser. Un `intent_id` puede ser locator, pero `intent_id` por sí solo nunca autoriza TASK-018.

### 7.2 Frontera de invocación

La continuación ordinaria DEBE ser invocada desde una frontera server-side que ya posee un resultado TASK-017 verificado/reconciliado. La aplicación no expone un endpoint público cuya única prueba para “continuar” sea un `intent_id`.

La transición preferida es:

```text
browser submits business proof to TASK-017 boundary
→ TASK-017 returns trusted server-side handoff result
→ same trusted server orchestration invokes TASK-018
→ browser receives only final bounded outcome / Auth cookies
```

Si una implementación futura necesita desacoplar TASK-017 y TASK-018 entre requests mediante una nueva credencial de continuación browser-held, ello constituye un cambio de Auth boundary no aprobado por esta specification y debe detenerse para revisión.

### 7.3 END — durable technical evidence

La parte durable y autoritativa del END queda demostrada cuando:

```text
auth_bridge_credentials.auth_user_id = resolved Auth subject
AND
auth_session_grants.auth_user_id = same Auth subject
AND
auth_session_grants.consumed_at IS NOT NULL
AND
grant remains correlated to the TASK-017 handoff
```

El binding/consume debe haber sido producido por el Custom Access Token Hook E2 bajo sus checks vigentes.

### 7.4 END — request success

El happy path de TASK-018 sólo se reporta como éxito al browser cuando además:

1. `signInWithPassword` terminó con una sesión válida para el Auth subject esperado;
2. el server realizó el compatibility guard final definido en esta specification;
3. ninguna identidad/membership incompatible fue detectada;
4. las cookies de sesión se propagaron utilizando la boundary SSR de TASK-011;
5. los headers anti-cache requeridos se preservaron;
6. no se expusieron technical password, Admin credential, `SessionGrant`, access token o refresh token por una superficie propia de aplicación.

### 7.5 Distinción obligatoria de durabilidad

La entrega física de cookies al navegador no es un hecho PostgreSQL durable y no debe presentarse falsamente como atomicidad distribuida.

Por tanto:

```text
durable E2 grant consume + Auth subject binding
!=
provable browser receipt of response bytes
```

Una pérdida de response después del consume se trata explícitamente en el failure model.

### 7.6 Lo que NO constituye END

TASK-018 no termina creando ni completando:

- `PlatformUser`;
- mapping Auth subject → `PlatformUser` nuevo;
- `CompanyMembership` inicial;
- enabled membership;
- profile persistence;
- profile completion;
- tenant authorization;
- onboarding completion;
- `USER_CREATED`;
- RF-012 completo;
- RF-004 end-to-end.

---

## 8. Requirements y clasificación

### 8.1 Canonical requirements

**CR-018-001.** RF-012 exige que el primer `COMPANY_ADMIN` ingrese usando correo + código válido y complete su perfil; TASK-018 implementa sólo la porción identity/session posterior al proof válido.

**CR-018-002.** `MaintenanceCompany` es el tenant.

**CR-018-003.** RLS permanece la barrera primaria de aislamiento remoto para datos tenant-owned.

**CR-018-004.** El browser no es autoridad para tenant, role, email, membership, ownership ni actor.

**CR-018-005.** Autenticación no equivale a autorización.

**CR-018-006.** Profile completion precede enabled first-admin tenant authority.

**CR-018-007.** La identidad e historial de usuario no deben confundirse con el estado de membership.

### 8.2 Architectural invariants

**AI-018-001.** Se preserva E2 de ADR-0019: application-owned challenge + one-time `SessionGrant` + server-only technical password + Custom Access Token Hook.

**AI-018-002.** Initial session method permitido = `password` técnico server-side + grant activo; otros initial methods permanecen default-deny.

**AI-018-003.** Public signup permanece disabled.

**AI-018-004.** Auth Admin permanece server-only, purpose-specific y sin client genérico.

**AI-018-005.** `SessionGrant` permanece platform-owned, 5 minutos, single-use y no bearer.

**AI-018-006.** `FirstAdminOnboardingIntent` permanece platform-owned y es la autoridad de tenant/email/purpose.

**AI-018-007.** Ningún side effect de Supabase Auth participa en una transacción atómica PostgreSQL.

**AI-018-008.** El lifecycle SSR de TASK-011 se reutiliza, no se rediseña.

**AI-018-009.** TASK-018 preserva la configuración Hosted security-critical de ADR-0019: `Require current password when changing password = enabled`. Su propósito es impedir que una sesión autenticada pueda sustituir la technical password server-only por una password elegida por el usuario. Esta invariant pertenece a ADR-0019 y no constituye un requisito nuevo de TASK-018.

### 8.3 Task-level design decisions de TASK-018

Estas decisiones son diseño de este slice, no requisitos históricos de producto:

**TD-018-001.** TASK-018 no crea ni muta `PlatformUser` o `CompanyMembership`.

**TD-018-002.** TASK-018 puede leer de forma purpose-specific el mapping/application state estrictamente necesario para detectar una identidad existente incompatible antes de entregar cookies.

**TD-018-003.** El authoritative correlation identity del flujo es el handoff ya persistido, principalmente `FirstAdminOnboardingIntent.id + handoff_session_grant_id`; no se introduce un bearer token de continuación.

**TD-018-004.** El email de Auth proviene exclusivamente de `FirstAdminOnboardingIntent.target_email` y debe correlacionar con challenge/bridge según TASK-013/017.

**TD-018-005.** La ruta ordinaria de reconciliación intenta primero `signInWithPassword` con la technical password esperada; `createUser` sólo se intenta cuando no existe binding conocido y el intento de reconciliación no demostró una identidad compatible.

**TD-018-006.** `auth.admin.updateUserById` no pertenece al happy path de TASK-018. Rotación, takeover o reparación de password quedan fuera de scope.

**TD-018-007.** Una duplicate/conflict response de `createUser` se reconcilia mediante un nuevo technical sign-in; no mediante `listUsers`.

**TD-018-008.** La sesión no se considera entregada hasta que el compatibility guard final haya pasado y las cookies TASK-011 se hayan preparado para la response.

**TD-018-009.** Cuando el grant ya fue consumido y el browser no presenta una sesión legítima derivada de ese resultado, TASK-018 no reactiva grant/challenge y no crea un segundo grant. El resultado es recovery-required/fresh-proof-required.

**TD-018-010.** TASK-018 no produce `AuditEvent`; los cambios técnicos Auth se observan mediante estado E2 y logs server-side estructurados. `USER_CREATED` sigue diferido.

### 8.4 Deferred decisions

Se preservan como diferidas y no se convierten en task-level design:

- exact profile fields;
- profile persistence;
- exact `PlatformUser` creation timing;
- exact initial `CompanyMembership` creation timing;
- ordering `PlatformUser` / `CompanyMembership` / profile cuando se implemente esa continuación;
- cualquier pre-profile membership state;
- exact transition enabling tenant authority;
- eventual onboarding-completion evidence shape;
- `USER_CREATED` producer timing;
- concrete email provider;
- RF-004 provider retry/backoff;
- target-email change/cancel/restart;
- PII retention policy adicional;
- post-failure fresh-verification orchestration más allá del bounded error definido aquí;
- Phase 2 Exit Gate;
- TASK-019.

---

## 9. Domain model impact

### 9.1 `FirstAdminOnboardingIntent`

**Afectado:** `READ / CORRELATION ONLY`.

TASK-018 consume:

- `id`;
- `maintenance_company_id`;
- `target_email`;
- `current_challenge_id`;
- `handoff_session_grant_id`;
- `handoff_ready_at`.

TASK-018 no agrega completion state al intent.

### 9.2 `VerificationChallenge`

**Afectado:** `READ / HISTORICAL CORRELATION ONLY`.

Debe permanecer consumed. No se reactiva, no se cambian attempts, no se cambia expiry y no se crea successor dentro de TASK-018.

### 9.3 `SessionGrant`

**Afectado:** `YES — existing E2 consume path`.

TASK-018 utiliza el grant ya creado por TASK-017. El Custom Access Token Hook lo consume atómicamente durante el initial password sign-in.

No se extiende TTL, no se reactiva y no se crea un segundo grant para el mismo challenge.

### 9.4 `AuthBridgeCredential`

**Afectado:** `YES — existing E2 binding path`.

Su `auth_user_id` puede quedar vinculado por el Hook cuando era `NULL`, o debe coincidir exactamente cuando ya estaba vinculado.

No se almacena technical password en plaintext.

### 9.5 Supabase Auth user / Auth identity

**Afectado:** `YES`.

Puede ser:

- reconciliado/reutilizado si demuestra la technical password esperada y la correlación E2;
- creado mediante `auth.admin.createUser` en el new-user path;
- rechazado como incompatible si el provider state no puede reconciliarse de manera inequívoca.

### 9.6 `PlatformUser`

**Afectado:** `READ-ONLY COMPATIBILITY GUARD WHEN MATERIAL`.

TASK-018 no crea, actualiza ni completa `PlatformUser`.

La lectura mínima existe sólo para preservar ADR-0020: una identidad global `SUPER_ADMIN` no se reutiliza como first tenant admin y una identidad con membership existente incompatible falla cerrada.

### 9.7 `CompanyMembership`

**Afectado:** `READ-ONLY COMPATIBILITY GUARD WHEN MATERIAL`.

TASK-018 no crea, habilita, deshabilita, reintegra ni cambia role de ninguna membership.

### 9.8 `MaintenanceCompany`

**Afectado:** `READ/CORRELATION ONLY`.

El tenant se deriva del intent. No existe tenant caller-supplied como authority y no se modifica la empresa.

### 9.9 `AuditEvent`

**Afectado:** `NO WRITE`.

No se crea action nueva y no se produce `USER_CREATED`.

---

## 10. Scope

### 10.1 In scope

1. resolución server-side del handoff TASK-017;
2. validación del grant y binding E2;
3. derivación autoritativa de email/purpose/company context;
4. creación purpose-specific de Auth user cuando corresponda;
5. reconciliación de Auth user compatible existente;
6. technical password derivation mediante foundation TASK-013;
7. `signInWithPassword` exclusivamente server-side;
8. consumo del `SessionGrant` vía Custom Access Token Hook;
9. binding inicial `AuthBridgeCredential.auth_user_id` cuando corresponda;
10. compatibility guard read-only de identidad application-side cuando material;
11. propagación de Auth session mediante lifecycle TASK-011;
12. idempotencia y concurrency del continuation slice;
13. failure model y partial provisioning;
14. UI mínima para pending/success/error;
15. tests locales y plan Hosted Development futuro.

### 10.2 Out of scope

- crear o completar `PlatformUser`;
- crear mapping nuevo Auth subject → `PlatformUser`;
- crear o habilitar initial `CompanyMembership`;
- profile form;
- profile persistence;
- profile completion;
- client scope;
- tenant authority enablement;
- first-admin onboarding completion;
- ordinary later-user onboarding;
- target email change;
- cancellation/restart de onboarding;
- concrete email provider;
- resend posterior al handoff dentro de TASK-018;
- `USER_CREATED`;
- nuevas acciones `AuditEvent`;
- password UX;
- password recovery;
- OAuth/SSO/TOTP/magic link/OTP como initial Auth methods;
- generic Auth Admin;
- generic service-role client;
- Offline/Dexie/outbox;
- Phase 2 Exit Gate;
- TASK-019.

---

## 11. Auth identity creation / reconciliation

### 11.1 Authoritative inputs

La boundary interna de TASK-018 acepta exclusivamente contexto ya resuelto por servidor. Conceptualmente:

```text
stable intent id
+ authoritative handoff correlation
```

El servidor deriva:

```text
email = FirstAdminOnboardingIntent.target_email
company = FirstAdminOnboardingIntent.maintenance_company_id
purpose = first-admin onboarding
intended future role = COMPANY_ADMIN
challenge = SessionGrant.challenge_id / intent current binding
grant = FirstAdminOnboardingIntent.handoff_session_grant_id
bridge credential = SessionGrant.auth_bridge_credential_id
```

Nunca acepta como authority desde browser:

- email;
- tenant ID;
- role;
- membership ID;
- Auth user ID;
- challenge ID elegible;
- grant ID;
- `is_super_admin`;
- claims de autorización.

### 11.2 Precondition del grant

Antes de cualquier nueva mutación Auth Admin:

- el handoff debe ser válido;
- el grant debe corresponder al handoff;
- `purpose = initial_session`;
- `auth_method = password`;
- grant no debe estar revoked;
- grant no debe estar consumed, salvo rama idempotente posterior que ya trae una sesión legítima;
- current server time debe ser anterior a `expires_at`;
- bridge credential y email deben correlacionar exactamente según TASK-013.

Un grant expirado no autoriza crear un Auth user que ya no puede completar este boundary.

### 11.3 Existing bound identity path

Si `AuthBridgeCredential.auth_user_id` ya está presente:

1. no ejecutar `createUser`;
2. ejecutar compatibility guard read-only sobre ese subject cuando pueda resolverse application state;
3. si el subject está clasificado como `SUPER_ADMIN` global vigente, `DENY / INCOMPATIBLE_IDENTITY`;
4. si el `PlatformUser` asociado posee cualquier `CompanyMembership`, `DENY / INCOMPATIBLE_IDENTITY` para initial first-admin bootstrap;
5. si existe `PlatformUser` sin membership y sin global authority incompatible, no se crea ni modifica; puede continuar;
6. derivar technical password desde la bridge credential;
7. ejecutar `signInWithPassword(authoritative_email, technical_password)` server-side;
8. el Hook debe exigir exactamente el mismo `auth_user_id`;
9. cualquier subject mismatch falla cerrado.

### 11.4 Unbound bridge — reconciliation-first path

Si `AuthBridgeCredential.auth_user_id IS NULL`:

1. derivar technical password;
2. intentar primero `signInWithPassword` server-side contra el authoritative email;
3. si el provider demuestra una identidad ya provisionada con esa technical password, el Hook vincula subject + grant atómicamente y no se crea usuario nuevo;
4. si el sign-in demuestra con certeza que no pudo autenticarse y el grant continúa eligible, se habilita el new-user attempt;
5. errores ambiguos de red/provider no autorizan un `createUser` ciego en la misma request.

### 11.5 New-user path

El único create permitido por TASK-018 es:

```text
purpose-specific Auth Admin
→ auth.admin.createUser
```

Inputs derivados exclusivamente por servidor:

- authoritative target email;
- technical password derivada;
- email confirmado porque el business proof ya fue consumido.

No se inyecta como autoridad en Auth metadata:

- tenant;
- role;
- membership;
- client scope;
- support scope;
- commercial state.

Después de `createUser` confirmado, el servidor vuelve a ejecutar el technical `signInWithPassword`; la sesión sólo existe si el Hook E2 permite emisión.

### 11.6 Existing email / duplicate create

Si `createUser` indica que la identidad/email ya existe o existe una colisión compatible con una carrera:

1. no usar `listUsers`;
2. no hacer password reset;
3. no hacer magic link/OTP/recovery;
4. no reemplazar password;
5. volver a intentar technical `signInWithPassword` una vez dentro de la reconciliación de esa operación;
6. si el sign-in resulta compatible, se trata como reconciliación idempotente/concurrente;
7. si continúa sin demostrar la technical password esperada, resultado = `INCOMPATIBLE_EXISTING_AUTH_IDENTITY / REPAIR REQUIRED`.

### 11.7 Provider-only incompatible identity

Un Auth user preexistente que posee el authoritative email pero no demuestra la technical password esperada no puede ser tomado por TASK-018.

```text
existing email
+
expected technical password not proven
→ fail closed
→ no updateUserById
→ no takeover
```

### 11.8 `updateUserById`

Aunque ADR-0019 permite `auth.admin.updateUserById` para rotación/reparación explícita, TASK-018 no lo utiliza en el happy path ni como fallback automático.

Cualquier necesidad de cambiar password o rebindear una identidad incompatible requiere una operación de reparación explícita separada y, si excede el canon existente, revisión humana.

---

## 12. Session establishment

### 12.1 Mechanism autorizado

El único initial session mechanism de TASK-018 es el E2 aprobado:

```text
server derives technical password
→ non-privileged/publishable server-side Supabase Auth client
→ signInWithPassword
→ Custom Access Token Hook
→ eligible SessionGrant locked/validated
→ Auth subject/email correlation
→ bridge binding if unbound
→ grant consume atomically
→ token/session issuance
```

No se usa Admin credential para el sign-in ordinario.

### 12.2 SessionGrant validation

El Hook conserva exactamente TASK-013:

- `purpose = initial_session`;
- `auth_method = password`;
- no expiry;
- no consume previo;
- no revocation;
- bridge correlation;
- exact email/subject correlation;
- same subject si bridge ya estaba bound;
- atomic consume;
- default deny para methods no aprobados.

### 12.3 Browser material

El browser nunca recibe mediante contratos propios de TASK-018:

- technical password;
- Supabase secret key;
- raw Auth Admin client;
- `SessionGrant` como bearer;
- challenge verifier/HMAC key;
- access token en JSON de aplicación;
- refresh token en JSON de aplicación.

La sesión se entrega mediante el lifecycle normal de cookies Supabase/SSR establecido por TASK-011.

### 12.4 Cookie lifecycle y TASK-011

La implementación debe reutilizar:

- server Supabase client caller-scoped;
- `getAll` / `setAll` cookie contract vigente;
- propagación de cookies hacia response;
- headers anti-cache asociados a `Set-Cookie`;
- Proxy/refresh lifecycle de TASK-011;
- validación server-side compatible con la foundation existente.

No se crea una segunda estrategia de sesión.

### 12.5 Compatibility guard antes de entregar cookies

Para preservar el fail-closed de ADR-0020 frente a identidad existente incompatible:

1. el resultado Auth subject del sign-in se compara con `AuthBridgeCredential.auth_user_id` después del Hook;
2. se ejecuta/repite el compatibility guard read-only contra current application state;
3. si el subject es global `SUPER_ADMIN` vigente o ya posee una `CompanyMembership`, el flujo first-admin se considera incompatible;
4. ante incompatibilidad no se finaliza el response como login first-admin exitoso ni se reutiliza esa identidad para crear membership;
5. el servidor no deriva tenant authority de la sesión;
6. cualquier provider session creada pero no entregada al browser se trata como partial failure seguro, no como onboarding success.

La implementación debe evitar comprometer las cookies al browser antes de terminar este guard. Puede utilizar buffering de la mutación de cookies dentro de la boundary server-side existente; no se autoriza una nueva arquitectura de sesión.

### 12.6 Preexisting browser session

Una sesión que el browser ya posea al entrar al flow:

```text
!= proof del handoff
!= tenant selector
!= identity selector para el first-admin target
```

No se usa para decidir qué Auth identity reconciliar. El initial sign-in autorizado por E2 es quien determina la identidad resultante.

### 12.7 Token refresh

Después de una sesión E2 legítimamente establecida y dado que el E2 cutover ya fue cerrado como `PASS`, `token_refresh` pertenece al lifecycle ordinario de esa sesión y no consume un nuevo grant.

Refresh:

- no revalida business code;
- no concede tenant authority;
- no reemplaza la autorización vigente en PostgreSQL;
- sigue sujeto a fail-closed del Hook y al lifecycle TASK-011.

### 12.8 Session revocation implications

TASK-018 no crea membership y, por tanto, no implementa una revocación tenant nueva.

Si una sesión residual existe después de un failure:

- no implica tenant authorization;
- tokens no entregados al browser no se consideran recuperación exitosa;
- una future membership revocation seguirá siendo gobernada por current DB state/RLS;
- no se reactiva el `SessionGrant` para “compensar”.

### 12.9 Technical-password mutation boundary

TASK-018 no introduce password UX.

```text
no password UX
!=
password mutation technically impossible
```

Por tanto, permanece obligatoria la configuración Hosted security-critical de ADR-0019:

```text
Require current password when changing password = enabled
```

TASK-018 no cambia la technical password mediante `updateUserById` ni permite que el usuario la sustituya. La rotación o reparación explícita permanece fuera del happy path y bajo las boundaries ya aprobadas. La ausencia de password UI, el ocultamiento de controles o assumptions de comportamiento del usuario no sustituyen esta configuración.

Si durante la futura implementación/Hosted verification no puede demostrarse que esta configuración está habilitada, o se detecta drift/disabled, la implementación no puede cerrarse.

---

## 13. Auth Admin / privileged boundary

### 13.1 Operaciones requeridas por TASK-018

Happy path permitido:

```text
auth.admin.createUser
```

No se necesita `updateUserById` para la operación ordinaria de TASK-018.

### 13.2 Ubicación arquitectónica

Debe residir dentro del módulo/bounded context `Identity & Auth` detrás de un adapter purpose-specific existente o equivalente que exponga únicamente una capability semántica del tipo:

```text
provision first-admin auth identity for verified handoff
```

No expone un Auth Admin client.

### 13.3 Caller permitido

Sólo el caso de uso server-side TASK-018 después de demostrar:

- handoff TASK-017 autoritativo;
- grant correlation;
- authoritative email;
- purpose fijo;
- idempotent correlation;
- ausencia de incompatibilidad conocida en el punto en que pueda comprobarse.

### 13.4 Inputs nunca authority

La boundary privilegiada no acepta como authority:

- tenant ID del browser;
- email del browser;
- role del browser;
- auth_user_id elegido por caller;
- password del browser;
- `PlatformUser` ID elegido por caller;
- membership ID;
- claims stale.

### 13.5 Limitación de privilege

Se preserva:

```text
generic Supabase Admin client = PROHIBITED
generic service-role request client = PROHIBITED
raw secret client export = PROHIBITED
browser Admin credential = NEVER
```

### 13.6 Auditoría operativa del privileged path

Cada invocación puede producir logs server-side estructurados con:

- operation category;
- intent ID;
- grant/bridge correlation IDs no secretos;
- provider operation class;
- result category;
- duration/error class;
- auth_user_id sólo después de existir y con acceso restringido de logs.

No se loguean secrets, codes, technical passwords, access/refresh tokens ni raw provider payloads sensibles.

---

## 14. Security / threat model

| Threat | Riesgo | Control requerido | Resultado ante fallo |
|---|---|---|---|
| Email substitution | crear/login de otra identidad | email sólo desde intent + challenge/bridge correlation | deny |
| Tenant substitution | confused deputy cross-tenant | tenant sólo desde intent; no tenant input en continuation | deny |
| Role substitution | habilitar role arbitrario | purpose fija intended role; TASK-018 no crea membership | impossible/deny |
| Handoff locator replay | usar `intent_id` como bearer | no standalone public continuation por locator | deny |
| Challenge replay | reutilizar proof | consumed challenge nunca se reactiva | deny/reconcile same upstream operation only |
| Grant replay | emitir segunda sesión inicial | atomic single-use consume | second initial sign-in denied |
| Stale grant | usar grant expired/revoked | server/Hook authoritative checks | recovery required |
| Mismatched handoff | intent/grant/challenge incorrectos | exact FK/correlation checks | deny |
| Session fixation | mantener/inyectar sesión caller | preexisting session no authority; technical sign-in determines result; cookie commit after final guard | replace/deny |
| Identity collision | dos Auth users/flows compiten | bridge email uniqueness + reconciliation-first + provider duplicate reconciliation | one compatible result or conflict |
| Existing-user takeover | sobrescribir password ajeno | no automatic update/reset/listUsers; wrong technical password = repair required | terminal conflict |
| Authenticated user changes own Auth password | la technical password deja de ser exclusivamente server-held y aparece una password conocida por el usuario que rompe E2 | Hosted `Require current password when changing password = enabled` + preservación del technical-password boundary de ADR-0019 | implementation blocker ante drift/no verificación |
| Enumeration leakage | revelar Auth account existence | same bounded UI outcome; no list/search; sanitize provider errors | generic error |
| Privileged path abuse | secret key becomes generic | purpose-specific adapter + static import boundary | blocker |
| Race createUser | double create | sign-in-first, provider uniqueness, duplicate→re-sign-in | reconcile or conflict |
| Race sign-in | two consume same grant | Hook lock + atomic consume | one winner max |
| Partial provisioning | Auth user exists, no session | reconcile on retry; no tenant authority; no delete/takeover | retry or recovery-required |
| Stale application identity state | subject became incompatible | final read-only compatibility guard before cookie commit | deny/no successful first-admin login response |
| Auth subject mismatch | bridge bound to another subject | Hook exact subject equality | deny |
| Browser claims stale | false role/tenant | ignored; DB current state governs | deny/no authority |
| Provider response ambiguity | repeated side effects | never blind-repeat create after ambiguous outcome; next attempt sign-in-first | retryable reconciliation |
| Cookie delivery loss | grant consumed but browser unsure | current-session reconciliation only; never regrant | idempotent success or fresh-proof-required |

### 14.1 Existing-user takeover invariant

```text
provider identity exists
AND
technical password expected by this bridge is not proven
→ TASK-018 must not take ownership
```

### 14.2 Session fixation invariant

The server does not “upgrade” whatever session the browser already has. It establishes the target Auth identity through E2, then only delivers the resulting session if all TASK-018 checks succeed.

---

## 15. RLS / multitenancy

### 15.1 Global/platform-owned state

Estas estructuras son platform-owned:

- `FirstAdminOnboardingIntent`;
- `VerificationChallenge`;
- `VerificationChallengeAttempt`;
- `AuthBridgeCredential`;
- `SessionGrant`.

Platform-owned no significa public/readable/writable by browser.

### 15.2 Tenant-owned state

`MaintenanceCompany`, `PlatformUser` relationships and `CompanyMembership` remain governed by their existing ownership/authorization model. TASK-018 does not create new tenant-owned rows.

### 15.3 RLS

RLS permanece enabled y obligatorio donde el canon ya lo exige.

TASK-018 no añade una tenant RLS policy artificial a platform-owned Auth state.

No direct browser CRUD se concede sobre handoff/grant/bridge state.

### 15.4 Privileged traversal

Un narrow server-side boundary puede leer el platform-owned Auth state requerido para resolver el handoff y puede efectuar el Auth Admin operation externa aprobada.

Ese privilegio:

- no concede tenant data access general;
- no convierte `supabase_auth_admin` en tenant actor;
- no altera ordinary `CompanyMembership` RLS;
- no permite normal tenant reads/writes mediante secret/service credentials.

### 15.5 Authoritative tenant derivation

```text
MaintenanceCompany.id
=
FirstAdminOnboardingIntent.maintenance_company_id
```

No se deriva desde email, JWT, query string, form field o local state.

### 15.6 New Auth session and tenant authority

Una sesión recién establecida por TASK-018 no crea autoridad tenant.

Para un target sin `PlatformUser`/membership:

```text
valid Auth session
→ authenticated identity only
→ current tenant resolver finds no enabled membership
→ tenant authorization = DENY
```

Si existe estado application-side incompatible, TASK-018 falla el first-admin continuation y no crea una nueva membership.

### 15.7 Enabled membership

```text
TASK-018 creates enabled CompanyMembership = NO
TASK-018 enables tenant authority = NO
```

La frontera de autoridad tenant continúa siendo la `CompanyMembership` habilitada, combinada con current authoritative state y demás checks aplicables.

---

## 16. PlatformUser / CompanyMembership / profile / tenant authority

### 16.1 Determinación A/B requerida por el prompt

Resultado:

```text
B — minimal interaction is required only as READ-ONLY compatibility checking.
```

TASK-018 no crea ni muta `PlatformUser` ni `CompanyMembership`.

La interacción read-only se justifica porque ADR-0020 exige fail-closed ante identidad existente incompatible y prohíbe reutilizar silenciosamente un `SUPER_ADMIN` global como first tenant admin o una identidad ya perteneciente a otro tenant.

### 16.2 Qué puede leer

Sólo lo necesario para clasificar el Auth subject resultante:

- si existe mapping Auth subject → `PlatformUser`;
- si ese `PlatformUser` conserva global `SUPER_ADMIN` authority incompatible;
- si existe cualquier `CompanyMembership` para ese `PlatformUser`.

### 16.3 Qué no puede hacer

- INSERT `PlatformUser`;
- INSERT mapping Auth subject → `PlatformUser`;
- INSERT `CompanyMembership`;
- setear `is_enabled`;
- cambiar role;
- persistir profile;
- decidir profile completeness;
- marcar onboarding complete.

### 16.4 Profile-first invariant

Debe permanecer:

```text
valid verification
→ Auth identity/session continuation may occur
→ profile completion still pending
→ enabled first-admin tenant authority only in future approved transition
```

TASK-018 no inventa la transición final.

---

## 17. Audit

### 17.1 Catálogo existente revisado

TASK-010 habilita físicamente en su foundation:

```text
USER_CREATED
USER_DISABLED_OR_REVOKED
USER_REINSTATED
USER_ROLE_CHANGED
```

El shape físico vigente requiere un `subject_platform_user_id` para estas acciones.

### 17.2 AuditEvent requerido por TASK-018

Resultado:

```text
new functional AuditEvent = NO
USER_CREATED produced by TASK-018 = NO
new AuditEvent action = NO
```

Razones:

1. TASK-018 crea/reconcilia una identidad provider-side, no un `PlatformUser` ni una membership;
2. `USER_CREATED` está reservado por el canon para la futura authoritative user/membership creation transition;
3. TASK-018 no posee `subject_platform_user_id` nuevo que permita representar correctamente `USER_CREATED`;
4. inventar `AUTH_IDENTITY_CREATED` u otra action ampliaría el catálogo físico sin requisito aprobado.

### 17.3 Actor / subject / tenant correlation

No se fabrica un `AuditEvent` técnico con actor o subject artificiales.

La provenance histórica del actor que inició onboarding permanece en `FirstAdminOnboardingIntent.initiated_by_platform_user_id` y puede ser consumida por la futura transición que realmente produzca `USER_CREATED`.

### 17.4 Evidencia de identity creation/reconciliation

No existe un `AuditEvent` de TASK-018 que “demuestre” el provisioning.

La evidencia técnica autoritativa es:

- provider result reconciliado;
- `AuthBridgeCredential.auth_user_id` bound;
- `SessionGrant.auth_user_id` correlated;
- `SessionGrant.consumed_at`;
- structured server diagnostics.

### 17.5 Failure audit boundary

Failures de Auth Admin/session establishment se registran como observability/security logs, no como `AuditEvent` de dominio.

No se inventa action para failure.

---

## 18. Idempotency / concurrency / external atomicity

### 18.1 Authoritative correlation identity

La misma continuación lógica queda identificada por el handoff ya durable:

```text
FirstAdminOnboardingIntent.id
+
FirstAdminOnboardingIntent.handoff_session_grant_id
```

El `SessionGrant` es unique por challenge y el intent no puede compartir ese handoff grant con otro intent.

Un request/trace ID adicional puede existir para observability, pero no es authority ni cambia la logical operation identity.

### 18.2 Same handoff twice — before consume

Dos continuations concurrentes del mismo handoff pueden alcanzar provider reconciliation/provisioning, pero:

- sólo una puede consumir el grant;
- sólo una initial token issuance puede vencer el Hook;
- la otra debe observar consume/no-eligibility y no crear un segundo grant.

### 18.3 Same handoff after successful delivery

Si un retry llega con una sesión Supabase vigente cuyo subject coincide exactamente con el bound `auth_user_id` del mismo handoff y el compatibility guard sigue válido:

```text
result = IDEMPOTENT SUCCESS
new createUser = NO
new SessionGrant = NO
new grant consume = NO
```

### 18.4 Same handoff after consume but without demonstrable browser session

Si el grant está consumed pero la request no puede demostrar una sesión legítima ya entregada:

```text
result = SESSION_RECOVERY_REQUIRED / FRESH_PROOF_REQUIRED
```

No se reactiva challenge/grant y no se fabrica un segundo grant para el mismo challenge.

### 18.5 Concurrent createUser

Cuando dos requests llegan al create path:

- provider uniqueness puede hacer que una gane y otra reciba duplicate/conflict;
- la request perdedora vuelve a technical sign-in;
- si demuestra la misma technical identity, continúa/reconcilia;
- si no, `INCOMPATIBLE_EXISTING_AUTH_IDENTITY`.

### 18.6 Concurrent reconciliation

Dos technical sign-ins contra un grant activo:

```text
one grant
→ at most one successful Hook consume
```

No se permite convertir el segundo Hook denial en una nueva sesión.

### 18.7 Database locking / uniqueness assumptions

Se reutilizan constraints/invariantes existentes:

- unique bridge email contract;
- unique bridge `auth_user_id` cuando bound;
- unique grant per consumed challenge;
- one active/unconsumed/unrevoked grant per bridge according to TASK-013;
- single-use grant consume under Hook lock/atomic transition;
- unique handoff grant per first-admin intent.

TASK-018 no introduce lock global de plataforma.

### 18.8 PostgreSQL vs Auth provider boundary

```text
PostgreSQL transaction
!=
Supabase Auth Admin transaction
!=
HTTP response delivery
```

No existe 2PC ni distributed transaction.

No se mantienen locks PostgreSQL mientras se espera a `auth.admin.createUser` o al provider sign-in.

### 18.9 Reconciliation strategy

Ante side effect Auth ambiguo:

1. no repetir `createUser` ciegamente;
2. volver por reconciliation-first con technical sign-in;
3. usar bound bridge subject cuando exista;
4. mantener tenant/email/purpose originales;
5. no crear un nuevo first-admin intent;
6. no crear tenant authority;
7. fail closed si el resultado no es inequívoco.

### 18.10 Compensation

No se usa delete-user automático como compensación.

Un Auth user huérfano de aplicación permanece sin tenant authority y se reconcilia o repara explícitamente en un flujo posterior. Borrar automáticamente podría destruir una identidad preexistente o convertir ambigüedad en pérdida de datos.

---

## 19. Failure model

| Failure | Clase | Estado autoritativo / acción | Resultado externo |
|---|---|---|---|
| Missing handoff | terminal/security | no Auth side effect | generic unavailable |
| Intent not handoff-ready | terminal/conflict | no side effect | generic unavailable |
| Handoff mismatch | security | no side effect | deny |
| Company correlation missing | terminal/security | no side effect | deny/internal |
| Missing SessionGrant | terminal | no side effect | recovery required |
| Grant expired | terminal/recovery | no createUser; no sign-in | fresh proof required |
| Grant revoked | terminal/security | no side effect | fresh proof/security outcome |
| Grant already consumed + matching current session | idempotent success | no new side effect | success |
| Grant already consumed + no matching current session | terminal/recovery | no reactivation | session recovery/fresh proof required |
| Bridge/email mismatch | security | no side effect | deny |
| Missing technical key material | terminal/config | fail closed | internal unavailable |
| Bound subject incompatible with application state | terminal/security | no create/membership | incompatible identity |
| Initial technical sign-in network ambiguity | retryable | do not immediately createUser | retry same logical continuation while grant valid |
| Initial technical sign-in definite credential failure | branch | may attempt createUser if bridge unbound and grant valid | continue provisioning |
| createUser success | branch | Auth user exists; no app authority | technical sign-in next |
| createUser definite failure unrelated to duplicate | retryable/terminal by class | no DB authority mutation | sanitized provider unavailable/conflict |
| createUser response lost/timeout | retryable ambiguous | never blind-repeat; next attempt starts sign-in-first | not confirmed |
| createUser duplicate/conflict | conflict/reconcile | retry technical sign-in | reconcile or incompatible |
| Existing user wrong technical password | terminal/security | no takeover/reset | repair required |
| signIn provider password success + Hook denies | terminal/security/conflict | no valid initial session; inspect grant/bridge current state | deny/recovery |
| Hook timeout/error before known consume | retryable/ambiguous | reconcile grant current state | retry only if unequivocally unconsumed+valid |
| Hook consumed + Auth returns session | success candidate | durable END achieved | compatibility guard then cookie delivery |
| Hook consumed + later provider/response failure | terminal/recovery | grant stays consumed | no reactivation; fresh proof may be required |
| Final compatibility guard fails | terminal/security | no membership mutation; do not commit first-admin login cookies | incompatible identity |
| DB read failure after Auth success | retryable/ambiguous | do not commit cookies as success | safe retry/recovery |
| Client disconnect before grant consume | retryable | state decides next attempt | retry same logical continuation |
| Client disconnect after grant consume | ambiguous delivery | grant stays consumed | matching session→idempotent success; otherwise fresh proof required |
| Repeated browser submit | reconciliation | browser does not gain authority by repeat | bounded result |

### 19.1 Retryable

Retry es permitido sólo cuando el servidor puede demostrar que repetir no viola single-use ni duplica provider side effects. Un retry no significa automáticamente repetir `createUser`.

### 19.2 Terminal

Incompatibilidad de identidad, grant consumed sin sesión demostrable, grant expired/revoked y subject mismatch no se “reparan” dentro del happy path.

### 19.3 Security-relevant

Señales que deben producir diagnostics elevados:

- bridge subject mismatch;
- intent/grant/challenge mismatch;
- known `SUPER_ADMIN` reuse attempt;
- existing membership incompatible;
- impossible cross-intent correlation;
- raw privileged boundary misuse;
- unexpected Hook method/state.

### 19.4 Partial provisioning

Puede existir legítimamente:

```text
Auth user created
+
no delivered session
+
no PlatformUser/membership
```

Eso es partial provisioning, no onboarding completion. La identidad se conserva y se reconcilia; no se borra ni se habilita tenant authority por inferencia.

---

## 20. UI flow mínimo

### 20.1 Entry

La UI continúa desde el mismo flujo que presentó el proof a TASK-017. El browser puede conservar un locator opaco y estado visual, pero el server-side orchestration debe recibir el handoff autoritativo desde la boundary TASK-017, no reconstruirlo desde browser inputs.

### 20.2 Pending

Mientras se ejecuta identity/session continuation:

- bloquear double-submit visualmente como UX, sin confiar en ello para concurrency;
- mostrar estado genérico de “estableciendo acceso”;
- no mostrar si la cuenta Auth ya existía;
- no mostrar tenant/role provenientes del browser.

### 20.3 Success

Outcome visible único para new-user y existing-compatible-user:

```text
SESSION ESTABLISHED
NEXT STEP = PROFILE COMPLETION REQUIRED

POST_AUTH_SUCCESS_DESTINATION =
/pending-profile

SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

Ambos outcomes convergen al mismo pathname y a la misma shell visible. No revelar al usuario si provider creation o reconciliation ocurrió ni transportar metadata que permita diferenciarlos.

`/pending-profile` significa exclusivamente:

```text
Supabase Auth session established
+
first-admin profile completion pending
```

### 20.4 Retryable failure

Mostrar una acción segura de retry sólo cuando el server clasifique el estado como retryable y el grant todavía pueda reconciliarse sin resurrectar terminal state.

### 20.5 Terminal/security failure

Mostrar un mensaje bounded que no exponga:

- existencia de otra cuenta;
- otra empresa;
- Auth subject;
- membership;
- exact provider reason.

Puede indicar que el acceso no pudo completarse y que debe reiniciarse/verificarse nuevamente cuando el flujo autorizado lo permita.

### 20.6 Existing-user reconciliation outcome

No es visible como variante funcional. La UI de éxito es deliberadamente idéntica a la creación nueva para reducir enumeration y evitar que provider state se convierta en UX authority.

### 20.7 Navigation posterior

Después de `SESSION_ESTABLISHED` o `SESSION_ALREADY_ESTABLISHED`, la navegación de success continúa exactamente a `/pending-profile`.

TASK-018 no define los campos del perfil ni una tenant dashboard autorizada.

Work Item D sólo puede crear una shell mínima de continuación pendiente en `/pending-profile`, sin mostrar datos tenant ni habilitar administración.

La navegación no requiere ni transporta en URL, query, fragment, body o estado controlado por browser: `intentId`, email, `maintenanceCompanyId`, tenant, role, Auth user ID, `PlatformUser` ID, `CompanyMembership` ID, grant ID, challenge ID, provider state, technical password, access token, refresh token ni reconciliation outcome. El trusted post-verification handoff permanece server-internal y `intentId` continúa siendo locator, no bearer.

### 20.8 Frontera de la shell `/pending-profile`

La shell mínima sólo puede representar genéricamente:

- sesión establecida;
- configuración de perfil pendiente.

No implementa ni especifica físicamente profile form, profile fields, profile persistence, dashboard, tenant UI, membership UI, route authorization framework, logout nuevo ni navegación funcional posterior.

Llegar o renderizar `/pending-profile` no significa:

- `PlatformUser` created;
- `PlatformUser` profile persisted;
- `CompanyMembership` created;
- `CompanyMembership` enabled;
- `COMPANY_ADMIN` authority granted;
- first-admin onboarding completed;
- RF-012 complete;
- RF-004 complete;
- tenant authorization ready;
- dashboard access authorized.

---

## 21. Online / offline

```text
TASK-018 online requirement = YES
```

Razones:

- requiere Supabase Auth provider;
- puede requerir `auth.admin.createUser`;
- requiere `signInWithPassword`;
- requiere ejecución del Custom Access Token Hook;
- requiere current authoritative PostgreSQL state;
- requiere propagación de sesión/cookies.

Por tanto:

```text
offline Auth provisioning = PROHIBITED
offline session establishment = PROHIBITED
queued privileged identity creation = PROHIBITED
Dexie/IndexedDB as identity authority = PROHIBITED
```

Ante falta de conectividad, la UI conserva sólo estado visual no autoritativo y solicita reintento online. No se persiste technical password, grant ni provider secret localmente.

---

## 22. Observability / error handling

### 22.1 Server-side logs

Logs estructurados deben distinguir al menos:

- handoff resolution started/result;
- bridge state `bound/unbound` sin secret;
- reconciliation sign-in result category;
- createUser attempted/result category;
- Hook/session result category;
- final compatibility guard result;
- cookie-delivery response preparation;
- failure taxonomy.

### 22.2 Correlation identifiers permitidos

Preferir:

- request/trace identifier no autoritativo;
- intent ID;
- handoff grant ID;
- bridge credential ID;
- auth_user_id sólo cuando ya exista y sea necesario;
- provider operation category.

No usar full target email en logs ordinarios; aplicar minimización/redacción.

### 22.3 Secret deny-list

Nunca loguear:

- business code;
- challenge verifier;
- challenge HMAC key;
- technical password;
- technical password key;
- Supabase secret/service credential;
- access token;
- refresh token;
- raw cookies;
- raw provider response que contenga secretos.

### 22.4 Error taxonomy

Internamente como mínimo:

- `HANDOFF_INVALID`;
- `GRANT_UNAVAILABLE`;
- `GRANT_EXPIRED`;
- `GRANT_CONSUMED`;
- `IDENTITY_INCOMPATIBLE`;
- `AUTH_RECONCILIATION_NOT_CONFIRMED`;
- `AUTH_PROVISIONING_NOT_CONFIRMED`;
- `SESSION_NOT_CONFIRMED`;
- `SESSION_RECOVERY_REQUIRED`;
- `SECURITY_CORRELATION_FAILURE`;
- `INTERNAL_CONFIGURATION_FAILURE`.

Los nombres exactos de tipos/códigos internos pueden adaptarse a las convenciones del repositorio; no constituyen nuevos requisitos de producto.

### 22.5 User-facing errors

La UI puede distinguir:

- retry later;
- verification/access must be restarted;
- access could not be completed.

No debe distinguir “email exists” vs “email does not exist” para cuentas ajenas.

### 22.6 Telemetry provider

No se selecciona ni introduce ningún telemetry provider por esta specification.

---

## 23. Expected implementation envelope and future Codex decomposition

La futura ejecución debe inspeccionar el repositorio real antes de fijar paths. No se inventan carpetas que no existan. Dentro del monolito modular aprobado, el trabajo debe permanecer en `Identity & Auth` y en la mínima UI/server integration necesaria.

### Work item A — Authoritative handoff resolver and compatibility guard

**Objetivo:** resolver server-side el handoff TASK-017 y clasificar current identity compatibility sin mutar `PlatformUser`/membership.

**Contexto:** `FirstAdminOnboardingIntent` es platform-owned; intent ID no es bearer; current DB state prevalece.

**Alcance:** resolver intent/grant/bridge; derivar email/company/purpose; read-only compatibility checks; typed result.

**Fuera de alcance:** Auth Admin, sign-in, cookies, profile, membership creation.

**Cambios esperados:** use case/store adapter estrecho; reutilización de boundaries TASK-017; sólo si el repositorio carece de una primitive segura de lectura, función DB purpose-specific aditiva sin nuevas tablas/columnas y sin ampliar authority.

**Seguridad/RLS:** no direct browser CRUD; no generic service-role; caller inputs no son authority.

**Criterios:** AC-018-011..028, AC-018-057..066.

**Pruebas:** invalid locator, cross-intent, stale/mismatch, compatible/uncompatible application identity, privilege boundary.

### Work item B — Auth identity reconciliation/provisioning

**Objetivo:** implementar reconciliation-first + new-user path bajo E2.

**Contexto:** TASK-013 ya define bridge credential y technical password.

**Alcance:** technical password derivation; server-only sign-in attempt; purpose-specific `createUser`; duplicate reconciliation.

**Fuera de alcance:** `updateUserById` repair, password UX/recovery, PlatformUser/membership.

**Cambios esperados:** application service + narrow Auth Admin adapter reuse/extension; no generic admin client.

**Seguridad/RLS:** no browser secret; no listUsers; no tenant metadata authority.

**Criterios:** AC-018-029..049, AC-018-067..073.

**Pruebas:** new identity, compatible identity, duplicate race, incompatible identity, ambiguous provider result.

### Work item C — E2 session establishment and SSR delivery

**Objetivo:** completar technical sign-in, Hook consume, final guard y TASK-011 cookie propagation.

**Contexto:** SessionGrant 5m/single-use; Custom Access Token Hook default-deny; E2 cutover PASS.

**Alcance:** sign-in, buffered cookie delivery until final guard, idempotent existing-session reconciliation, retry/failure handling.

**Fuera de alcance:** route authorization, tenant authorization, profile.

**Cambios esperados:** server orchestration integrating existing Supabase SSR factory; no second session architecture.

**Seguridad/RLS:** Admin client never used for sign-in; no token JSON; no grant bearer.

**Criterios:** AC-018-050..066, AC-018-074..083.

**Pruebas:** Hook success/failure, concurrent sign-ins, cookie propagation, response loss, no tenant authority.

### Work item D — Minimal UI integration

**Objetivo:** conectar post-verification server orchestration a pending/success/failure UI sin exponer provider state.

**Contexto:** same server flow should carry trusted handoff internally.

**Alcance:** loading, bounded retry, terminal error y success navigation con contrato exacto:

```text
POST_AUTH_SUCCESS_DESTINATION =
/pending-profile

SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

Ambos outcomes deben producir el mismo success visible, el mismo pathname y la misma shell, sin metadata diferenciadora.

**Fuera de alcance:** profile form, profile persistence, tenant admin UI, tenant authority, dashboard, route authorization framework y full onboarding.

**Cambios esperados:** mínima surface UI/handler conforme estructura real del repositorio y minimal pending-profile shell only en `/pending-profile`.

**Seguridad/RLS:** no authority from browser email/tenant/role; intent locator not bearer; trusted post-verification handoff server-internal; no secrets, tokens, technical password ni identificadores de autoridad transportados por browser hacia `/pending-profile`.

**Criterios:** AC-018-084..090.

**Pruebas:** double-submit, offline, generic error, no account enumeration; pathname exacto `/pending-profile`; convergencia de `SESSION_ESTABLISHED` y `SESSION_ALREADY_ESTABLISHED`; misma shell visible; ausencia de metadata diferenciadora; no profile form; no tenant authority; no secrets/tokens/browser authority transport.

### Work item E — Regression + Hosted Development evidence

**Objetivo:** probar localmente y, tras Gate separado, verificar E2 real en Hosted Development.

**Contexto:** Auth Admin y Hook son provider-integrated boundaries que requieren evidencia Hosted antes del cierre.

**Alcance:** local suite, security tests, concurrency, hosted disposable fixtures, evidence package.

**Fuera de alcance:** Staging/Production, TASK-019.

**Cambios esperados:** tests y documentación/evidence necesaria; no product scope expansion.

**Seguridad/RLS:** fixtures descartables; no secrets in logs; cleanup obligatorio.

**Criterios:** AC-018-091..100.

**Pruebas:** plan completo de §24.

---

## 24. Verification / test plan

### 24.1 Unit / application integration

1. handoff resolver derives email/company/purpose from intent only;
2. new Auth identity path;
3. existing compatible bound identity path;
4. existing compatible unbound provider identity path;
5. incompatible existing identity path;
6. duplicate create followed by successful reconciliation;
7. duplicate create followed by incompatible result;
8. provider timeout before confirmed create;
9. retry begins reconciliation-first;
10. no `updateUserById` on ordinary failure;
11. invalid handoff;
12. stale/mismatched handoff;
13. grant expired/revoked/consumed;
14. session establishment success;
15. Hook deny/failure;
16. cookie propagation contract;
17. final compatibility guard;
18. response loss classifications;
19. preexisting browser session not used as target authority;
20. no visible distinction new-vs-existing user;
21. `SESSION_ESTABLISHED` navigates to the exact pathname `/pending-profile`;
22. `SESSION_ALREADY_ESTABLISHED` navigates to the exact pathname `/pending-profile`;
23. both success outcomes render the same visible shell without differentiating metadata or copy;
24. `/pending-profile` renders only session-established + profile-completion-pending state;
25. `/pending-profile` contains no profile form and grants no tenant authority.

### 24.2 Concurrency tests

1. two requests before create;
2. two concurrent `createUser` attempts via controlled adapter race;
3. duplicate provider result then re-sign-in;
4. two concurrent technical sign-ins for same grant;
5. at most one grant consume;
6. no second initial session from same grant;
7. retry after successful session with matching cookies = idempotent success;
8. retry after consume without matching session = recovery-required.

### 24.3 Database/security tests

1. `FirstAdminOnboardingIntent`, challenge, bridge and grant remain non-CRUD from browser roles according to existing contract;
2. no tenant RLS policy is weakened;
3. no membership is inserted or enabled;
4. no `PlatformUser` is inserted by TASK-018;
5. no new Auth-subject application mapping is inserted by TASK-018;
6. current DB compatibility state overrides stale browser/session claims;
7. a known global `SUPER_ADMIN` target is rejected;
8. a target with any existing membership is rejected for first-admin bootstrap;
9. target tenant is derived from intent only;
10. arbitrary tenant/role/email inputs cannot influence result;
11. no raw privileged client is accessible from browser/client-safe imports;
12. no new AuditEvent row/action is created by TASK-018.

### 24.4 Regression tests

Must preserve:

- TASK-011 cookie/SSR lifecycle and caller-scoped server client;
- TASK-013 challenge/grant/technical-password/Hook semantics;
- TASK-014 global identity authorization invariants where exercised indirectly by compatibility classification;
- TASK-017 handoff semantics and intent binding;
- existing `CompanyMembership`/RLS foundations;
- public signup disabled and unsupported initial methods denied;
- `authenticated != authorized`;
- `SessionGrant` TTL/single-use unchanged.

### 24.5 Negative security tests

At least:

- substitute email in body/query;
- substitute tenant;
- substitute role;
- submit grant UUID as if bearer;
- submit foreign intent ID;
- replay consumed handoff from a new browser without session;
- direct public password sign-in without active grant;
- OTP/magiclink/recovery initial method remains denied;
- inspect bundle for Admin secret/technical password imports;
- provider duplicate account does not trigger password takeover;
- provider error does not leak account existence;
- concurrent race cannot create tenant authority;
- `/pending-profile` navigation contains no `intentId`, email, tenant, role, identity/membership/grant/challenge identifiers, provider state, technical password, access token, refresh token or reconciliation outcome in browser-controlled transport;
- direct rendering of `/pending-profile` cannot create profile/membership state, grant authority or authorize dashboard access.

### 24.6 Hosted Development verification — future, separately authorized

Hosted verification **is required before final implementation closure**, because real Supabase Auth Admin behavior, Custom Access Token Hook execution, provider identity uniqueness and cookie/session behavior are material to this task.

After separate authorization, verify in Hosted Development with disposable fixtures:

1. fresh handoff + new Auth user → session success;
2. Auth user created but app acknowledgement simulated lost → same continuation reconciles by sign-in-first while grant remains eligible;
3. compatible existing technical identity → session success without duplicate user;
4. incompatible email identity → no takeover;
5. wrong/public password path without grant → no session;
6. one grant → at most one initial session;
7. bridge subject binding and grant consume match session subject;
8. cookies are established through SSR boundary;
9. current tenant authorization remains denied because no membership was created;
10. no `AuditEvent.USER_CREATED` appears;
11. cleanup disposable Auth/DB fixtures under approved test procedure;
12. Hosted Auth configuration demuestra `Require current password when changing password = enabled`;
13. un authenticated user no puede reemplazar la technical password sin presentar la current technical password;
14. cualquier current-password requirement drift, estado disabled o imposibilidad de verificación produce implementation closure blocker.

No Hosted mutation is authorized by this specification generation.

---

## 25. Requirements traceability

| Requirement / invariant | Type | Source | TASK-018 consequence | Acceptance Criteria | Tests |
|---|---|---|---|---|---|
| RF-012 email+valid-code login, profile later | canonical requirement | `01-product-definition.md` | consume TASK-017 proof handoff; stop before profile | AC-018-001..010, 084..090 | UI/integration |
| Tenant = MaintenanceCompany | canonical invariant | `01`, `02`, `03` | derive company only from intent | AC-018-015, 060..062 | security DB |
| RLS primary remote boundary | canonical invariant | `01`, `03` | no tenant RLS bypass/new authority | AC-018-057..066 | RLS regression |
| Browser untrusted | canonical invariant | `03` | no browser authority over email/tenant/role | AC-018-016..020, 063..066 | negative security |
| E2 Auth chain | architectural invariant | ADR-0019 | technical password + grant + Hook + session | AC-018-029..056 | integration/Hosted |
| Technical-password server-only / current-password mutation gate | architectural / security invariant | ADR-0019 | Hosted `Require current password when changing password = enabled`; no password UX ni `updateUserById` happy-path sustituyen este control | AC-018-097 | negative security / Hosted verification |
| SSR lifecycle | architectural invariant | TASK-011 | standard cookie propagation/refresh | AC-018-050..056, 080..083 | SSR regression |
| SessionGrant 5m/single-use | physical architectural invariant | TASK-013 | validate/consume existing grant; no regrant | AC-018-021..028, 050..052 | DB/concurrency |
| Reconciliation-first | physical architectural invariant | TASK-013 | signIn before create for unbound bridge | AC-018-031..039 | integration |
| No takeover of incompatible existing user | security invariant | TASK-013 / ADR-0020 | wrong technical password => repair | AC-018-040..049 | negative security |
| FirstAdminOnboardingIntent authority | architectural invariant | ADR-0020 | email/tenant/purpose from intent | AC-018-011..020 | handoff tests |
| Handoff not completion | canonical architectural invariant | ADR-0020 / TASK-017 | no profile/membership/authority | AC-018-001..010, 074..079 | regression |
| Handoff locator not bearer | security invariant | TASK-017 | no intent-only public continuation | AC-018-017..020 | negative API |
| Existing incompatible app identity fails closed | architectural invariant | ADR-0020 / TASK-017 | read-only compatibility guard | AC-018-044..049, 076..079 | identity-state tests |
| No distributed atomicity | architectural invariant | ADR-0020 | reconciliable steps, no 2PC | AC-018-067..073 | forced-failure tests |
| USER_CREATED future timing | deferred canonical state | TASK-017 / CORR-028 | TASK-018 produces no USER_CREATED | AC-018-074..079 | audit regression |
| Audit action catalog | physical contract | TASK-010 | no new action, no invalid subject | AC-018-074..079 | DB/audit tests |
| RF-004 partial | governance/product state | TASK-017 / CORR-028 | no delivery-provider claim | AC-018-096 | self-verification |
| Phase 2 remains open | governance | current Gate / CORR-028 | no Phase 2 close | AC-018-097..100 | governance review |
| Offline not authorized for Auth provisioning | task design from provider boundary | ADR-0019/TASK-013 | online-only | AC-018-087..090 | network/offline UI |
| No generic Auth Admin | architectural invariant | ADR-0019/TASK-013 | narrow createUser only | AC-018-053..056, 067 | static/security |

---

## 26. Blockers

### 26.1 Current blockers

```text
TASK-018 SPECIFICATION BLOCKER = NONE
```

### 26.2 Mandatory blocker classes

A future review/implementation must stop with the exact applicable class when any condition below occurs.

#### REQUIRED CANONICAL SOURCE UNAVAILABLE

A required source cannot be read from its authoritative artifact during implementation/review.

#### SOURCE CONTRADICTION

Two authoritative current sources impose incompatible requirements that cannot be resolved by scope/temporal precedence.

#### PRODUCT DECISION REQUIRED

The implementation becomes impossible without deciding profile fields, profile persistence, target-email change, onboarding completion behavior or another unresolved product rule.

#### DOMAIN DECISION REQUIRED

The slice would require defining a new lifecycle/entity relationship not already supported by current domain/canon.

#### NEW ADR REQUIRED

A new session mechanism, continuation bearer, generic privileged pattern, cross-cutting identity model or material change to ADR-0019/0020 becomes necessary.

#### SECURITY/RLS/MULTITENANCY DECISION REQUIRED

The implementation would need broader tenant privileges, weakened RLS, generic service-role, cross-tenant authority or a new privilege pattern.

#### AUTH BOUNDARY UNSPECIFIED

The implementation cannot preserve a server-only transition from verified handoff to E2 without exposing a new bearer/secret or trusting intent ID alone.

#### AUDIT SEMANTICS UNSPECIFIED

A correct implementation unexpectedly requires a new `AuditEvent` action or needs to emit `USER_CREATED` before `PlatformUser`/membership transition is defined.

#### REQUIRED HOSTED AUTH SECURITY CONFIG NOT VERIFIED

Si durante la futura implementación/Hosted verification no puede demostrarse `Require current password when changing password = enabled`, o se detecta disabled/config drift:

```text
TASK-018 IMPLEMENTATION =
BLOCKER — REQUIRED HOSTED AUTH SECURITY CONFIG NOT VERIFIED
```

Este blocker preserva la invariant arquitectónica/security de ADR-0019; no constituye decisión nueva de producto ni exige un ADR nuevo por sí mismo.

#### EXTERNAL ATOMICITY ASSUMPTION INVALID

An implementation relies on Auth Admin/provider success being transactionally atomic with PostgreSQL or response delivery.

#### SCOPE EXPANSION REQUIRED

The slice cannot work without implementing profile, `PlatformUser` creation, membership, tenant authority, new verification/resend semantics, TASK-019 or another excluded capability.

### 26.3 Blocker behavior

Ante cualquier blocker:

```text
NO SILENT REPAIR
NO INVENTED REQUIREMENT
NO SCOPE EXPANSION
STOP
RETURN TO REVISOR CENTRAL
```

---

## 27. Acceptance Criteria

**AC-018-001.** La specification conserva `TASK-018 = Authoritative First-Admin Auth Identity Reconciliation and Session Establishment Foundation` sin redefinir su identidad.

**AC-018-002.** START está definido como handoff autoritativo durable producido por TASK-017 y no como un payload browser-trusted.

**AC-018-003.** END técnico durable está definido mediante bridge Auth subject binding + SessionGrant subject correlation + consumed grant.

**AC-018-004.** END de request exige además una sesión Auth válida y cookie propagation compatible con TASK-011.

**AC-018-005.** La specification distingue durable provider/DB state de entrega efectiva de response al browser.

**AC-018-006.** TASK-018 no declara `PlatformUser` completion.

**AC-018-007.** TASK-018 no crea initial `CompanyMembership` ni enabled tenant authority.

**AC-018-008.** TASK-018 no implementa profile completion ni onboarding completion.

**AC-018-009.** RF-012 permanece `INCOMPLETE` al terminar TASK-018.

**AC-018-010.** RF-004 permanece `PARTIAL / NOT END-TO-END`.

**AC-018-011.** Authoritative email se deriva exclusivamente de `FirstAdminOnboardingIntent.target_email`.

**AC-018-012.** Purpose se deriva del tipo first-admin intent y no es caller-selectable.

**AC-018-013.** Intended future role queda fijo en `COMPANY_ADMIN` sin crear authority.

**AC-018-014.** Current challenge/grant se deriva del handoff persistido, no de una selección arbitraria del browser.

**AC-018-015.** `MaintenanceCompany` target se deriva exclusivamente del intent.

**AC-018-016.** Browser-supplied email nunca determina Auth target.

**AC-018-017.** Browser-supplied tenant nunca determina tenant target.

**AC-018-018.** Browser-supplied role nunca determina role o membership.

**AC-018-019.** `intent_id` por sí solo no concede continuation authority.

**AC-018-020.** No existe endpoint ordinario que establezca sesión sólo porque el caller conoce `intent_id` o `SessionGrant.id`.

**AC-018-021.** SessionGrant mantiene `purpose = initial_session`.

**AC-018-022.** SessionGrant mantiene `auth_method = password`.

**AC-018-023.** SessionGrant expira exactamente conforme a TASK-013 y TASK-018 no extiende TTL.

**AC-018-024.** Un grant revoked no puede establecer sesión.

**AC-018-025.** Un grant consumed no se reactiva.

**AC-018-026.** Un grant expired no dispara creación nueva de Auth user dentro de TASK-018.

**AC-018-027.** TASK-018 no crea un segundo grant para el mismo challenge consumido.

**AC-018-028.** Un grant UUID conocido por browser no funciona como bearer authority.

**AC-018-029.** Un bridge ya bound nunca ejecuta `createUser` como path ordinario.

**AC-018-030.** Un bridge bound sólo acepta exactamente el mismo Auth subject en el Hook.

**AC-018-031.** Un bridge unbound intenta technical `signInWithPassword` antes de `createUser`.

**AC-018-032.** Un technical sign-in compatible puede reconciliar una identidad Auth preexistente sin nueva creación.

**AC-018-033.** `createUser` sólo se intenta con bridge unbound, handoff válido y grant eligible.

**AC-018-034.** `createUser` usa exclusivamente authoritative email + technical password derivada + email confirmation autorizada por proof consumido.

**AC-018-035.** `createUser` no recibe tenant authority metadata desde browser.

**AC-018-036.** `createUser` no recibe role authority metadata desde browser.

**AC-018-037.** `createUser` success es seguido por technical sign-in E2 y no equivale por sí solo a session success.

**AC-018-038.** `createUser` response loss no provoca blind repeated creation.

**AC-018-039.** Retry después de provisioning ambiguo comienza por reconciliation-first.

**AC-018-040.** Provider duplicate/conflict produce un nuevo technical sign-in de reconciliación antes de declarar incompatibilidad.

**AC-018-041.** Un existing user que no demuestra la technical password esperada no es tomado por TASK-018.

**AC-018-042.** TASK-018 no usa `auth.admin.listUsers` como fallback.

**AC-018-043.** TASK-018 no usa password reset, magic link, OTP o recovery para reconciliar.

**AC-018-044.** TASK-018 no ejecuta `updateUserById` automáticamente ante identidad incompatible.

**AC-018-045.** Un Auth subject global `SUPER_ADMIN` vigente es incompatible con first-admin tenant bootstrap.

**AC-018-046.** Un `PlatformUser` con cualquier `CompanyMembership` existente es incompatible con initial first-admin bootstrap.

**AC-018-047.** Un `PlatformUser` sin membership y sin global authority incompatible no es mutado por TASK-018.

**AC-018-048.** Compatibility check usa current authoritative application state, no stale claims.

**AC-018-049.** Final compatibility check ocurre antes de finalizar cookie delivery como success.

**AC-018-050.** Initial session se obtiene exclusivamente mediante server-side `signInWithPassword` con semantics no privilegiadas/publishable.

**AC-018-051.** Custom Access Token Hook conserva atomic single-use grant consume.

**AC-018-052.** Dos concurrent initial sign-ins consumen como máximo un grant exitosamente.

**AC-018-053.** Auth Admin boundary de TASK-018 expone sólo la capability purpose-specific necesaria para `createUser`.

**AC-018-054.** No se exporta generic Supabase Admin client.

**AC-018-055.** Admin credential nunca llega al browser, logs, URLs ni client bundle.

**AC-018-056.** Admin credential nunca se usa como ordinary tenant request client ni como sign-in client.

**AC-018-057.** Platform-owned Auth state conserva RLS/denial de Data API general conforme al canon.

**AC-018-058.** TASK-018 no debilita ninguna policy RLS tenant existente.

**AC-018-059.** TASK-018 no concede privilegios tenant a `supabase_auth_admin`.

**AC-018-060.** Ningún `maintenance_company_id` browser-supplied puede cambiar el tenant del handoff.

**AC-018-061.** Una sesión Auth recién creada no produce una `CompanyMembership`.

**AC-018-062.** Una sesión Auth recién creada no produce enabled tenant authority.

**AC-018-063.** Claims/JWT/session metadata no sustituyen current PostgreSQL authorization.

**AC-018-064.** Browser state/cache/local storage no constituye authority.

**AC-018-065.** Auth identity, session, handoff y grant permanecen conceptualmente distintos de tenant authorization.

**AC-018-066.** `SUPER_ADMIN` global no obtiene ordinary tenant bypass por TASK-018.

**AC-018-067.** `auth.admin.createUser` no se representa como participante de una PostgreSQL transaction atómica.

**AC-018-068.** La implementación no introduce distributed lock, 2PC ni microservice coordinator para Auth + DB.

**AC-018-069.** Concurrent create produce un solo provider identity compatible o un conflicto fail-closed; nunca dos first-admin outcomes.

**AC-018-070.** Same handoff + already-delivered matching session retorna idempotent success sin nuevo grant.

**AC-018-071.** Same handoff + consumed grant + no matching session no emite una segunda sesión inicial por inferencia.

**AC-018-072.** Provider/Auth side effect ambiguo se reconcilia antes de repetir mutación.

**AC-018-073.** No se elimina automáticamente un Auth user como compensación de partial provisioning.

**AC-018-074.** TASK-018 no crea `PlatformUser`.

**AC-018-075.** TASK-018 no crea mapping Auth subject → `PlatformUser`.

**AC-018-076.** TASK-018 no crea ni modifica `CompanyMembership`.

**AC-018-077.** TASK-018 no produce `AuditEvent.USER_CREATED`.

**AC-018-078.** TASK-018 no inventa una nueva action `AuditEvent`.

**AC-018-079.** Identity/session technical success se demuestra mediante E2 state y diagnostics, no mediante un AuditEvent ficticio.

**AC-018-080.** Auth session cookies se propagan mediante la boundary SSR de TASK-011.

**AC-018-081.** Headers anti-cache asociados a `Set-Cookie` se preservan conforme a TASK-011.

**AC-018-082.** Access/refresh tokens no se retornan en un JSON propio de TASK-018.

**AC-018-083.** `token_refresh` no consume nuevo SessionGrant y no concede tenant authority.

**AC-018-084.** UI post-verification ofrece pending/loading sin depender de double-submit prevention para seguridad.

**AC-018-085.** Success visible no diferencia “Auth user creado” de “Auth user reconciliado”; `SESSION_ESTABLISHED` y `SESSION_ALREADY_ESTABLISHED` convergen al mismo destino visible `/pending-profile`, sin diferenciación visible.

**AC-018-086.** Error visible no enumera cuentas, tenants, memberships ni provider details sensibles.

**AC-018-087.** TASK-018 se declara online-only.

**AC-018-088.** No existe queued/offline Auth provisioning.

**AC-018-089.** Dexie/IndexedDB no almacena grant, technical password ni autoridad TASK-018.

**AC-018-090.** Falta de conectividad produce bounded retry UX, no optimistic identity creation.

**AC-018-091.** Unit/integration tests cubren new-user path.

**AC-018-092.** Unit/integration tests cubren compatible existing-user path e incompatible identity path.

**AC-018-093.** Tests cubren idempotent retry y concurrent retry.

**AC-018-094.** Tests cubren invalid/stale handoff y invalid/expired/consumed SessionGrant.

**AC-018-095.** Tests demuestran que browser no controla tenant/email/role y que privileged boundary no es client-accessible.

**AC-018-096.** Regression suite preserva TASK-011, TASK-013, TASK-017, existing CompanyMembership/RLS y `RF-004 = PARTIAL`.

**AC-018-097.** Hosted Development verification queda requerido para future implementation closure pero no se ejecuta ni autoriza por esta specification; esa verificación debe demostrar `Require current password when changing password = enabled`, y cualquier drift, estado disabled o imposibilidad de verificación impide cerrar la implementación TASK-018.

**AC-018-098.** Phase 2 permanece `IN PROGRESS / NOT CLOSED` y Phase 2 Exit Gate permanece `NOT DEFINED / NOT SATISFIED`.

**AC-018-099.** Phase 3 permanece `NOT STARTED`.

**AC-018-100.** TASK-019 permanece `NOT DETERMINED / NOT AUTHORIZED` sin determinación automática por TASK-018.

**AC range:** `AC-018-001..AC-018-100`

**AC count:** `100`

---

## 28. Definition of Done

### 28.1 Specification generation

**DoD-018-001.** Las tres fuentes recuperadas fueron verificadas físicamente y coinciden exactamente con sus identidades aprobadas.

**DoD-018-002.** Las once fuentes mínimas obligatorias estuvieron disponibles para la generación.

**DoD-018-003.** La dependencia adicional TASK-010 quedó justificada exclusivamente por la dimensión AuditEvent.

**DoD-018-004.** Source-of-truth hierarchy por dimensión quedó documentada.

**DoD-018-005.** START y END exactos quedaron definidos sin ampliar scope.

**DoD-018-006.** Auth identity creation/reconciliation quedó especificada para new/existing/mismatch paths.

**DoD-018-007.** Session establishment E2 y lifecycle TASK-011 quedaron especificados.

**DoD-018-008.** Privileged boundary quedó limitada y no genérica.

**DoD-018-009.** RLS/multitenancy y browser trust boundary quedaron especificados.

**DoD-018-010.** Audit determinó `new AuditEvent = NO` y preservó `USER_CREATED` diferido.

**DoD-018-011.** Concurrency, idempotency, partial failure y external atomicity quedaron definidos.

**DoD-018-012.** UI, online-only, observability y test plan quedaron definidos.

**DoD-018-013.** Traceability matrix quedó incluida.

**DoD-018-014.** AC-018-001..100 quedaron continuos y objetivamente verificables.

**DoD-018-015.** DoD continuo quedó incluido.

### 28.2 Central review / approval

**DoD-018-016.** `TASK-018 CENTRAL SPEC REVIEW = APPROVED` mediante Gate separado.

**DoD-018-017.** Cualquier corrección solicitada por revisión se incorpora sin alterar scope no autorizado.

**DoD-018-018.** `TASK-018 HUMAN SPECIFICATION APPROVAL = APPROVED` mediante autorización humana explícita.

**DoD-018-019.** Se genera approved artifact sólo después de la aprobación humana correspondiente.

**DoD-018-020.** Approved artifact review verifica identidad y ausencia de drift documental.

### 28.3 Canonicalization / repository incorporation

**DoD-018-021.** Canonicalization ocurre mediante Gate separado.

**DoD-018-022.** Canonical candidate conserva exactamente la specification aprobada.

**DoD-018-023.** Canonicalization review = approved antes de repository incorporation.

**DoD-018-024.** Repository incorporation de la specification requiere autorización humana separada.

**DoD-018-025.** Canonical specification queda en la ruta aprobada de `docs/tasks/` sin implementar producto.

### 28.4 Implementation authorization / implementation

**DoD-018-026.** `TASK-018 IMPLEMENTATION EXECUTION AUTHORIZED` existe antes de modificar código/schema/config.

**DoD-018-027.** Preflight Git fresco valida branch, HEAD, origin/main, divergence, clean worktree y ausencia de operaciones Git en progreso.

**DoD-018-028.** Codex recibe work items pequeños con objetivo, contexto, scope, out-of-scope, expected changes, security/RLS, AC y tests.

**DoD-018-029.** Implementación no crea ni modifica PlatformUser/CompanyMembership salvo read-only compatibility checks autorizados.

**DoD-018-030.** Implementación no amplía Auth Admin ni introduce generic privileged client.

**DoD-018-031.** Implementación no crea AuditEvent nuevo ni `USER_CREATED`.

**DoD-018-032.** Implementación no simula atomicidad entre provider Auth y PostgreSQL.

### 28.5 Local verification

**DoD-018-033.** TypeScript strict y build/lint/tests aplicables pasan sin relajaciones.

**DoD-018-034.** New/existing/incompatible identity tests pasan.

**DoD-018-035.** Idempotency/concurrency/response-loss tests pasan.

**DoD-018-036.** Security/RLS/browser-authority negative tests pasan.

Para Work Item D, `DoD-018-033` y `DoD-018-036` exigen conjuntamente que:

- exista `/pending-profile`;
- `SESSION_ESTABLISHED` y `SESSION_ALREADY_ESTABLISHED` converjan al mismo destino y a la misma shell visible;
- la route sea únicamente una shell mínima de sesión establecida + configuración de perfil pendiente;
- no implemente profile form, persistencia, tenant authority, dashboard ni capacidades posteriores;
- pasen las pruebas de pathname exacto, uniformidad visible, ausencia de metadata diferenciadora y ausencia de secrets/tokens/browser authority transport.

**DoD-018-037.** TASK-011/TASK-013/TASK-017 regressions pasan.

### 28.6 Hosted verification

**DoD-018-038.** Hosted Development mutation/verification recibe autorización humana separada antes de ejecutarse.

**DoD-018-039.** Hosted verifies real Auth Admin create/reconcile, Hook consume, session/cookies, no tenant authority y `Require current password when changing password = enabled`; el cierre Hosted no pasa ante drift, estado disabled o falta de verificación de esa configuración.

**DoD-018-040.** Disposable fixtures se limpian conforme al procedimiento autorizado y no dejan secrets/elevated state.

### 28.7 Implementation review / Git

**DoD-018-041.** Implementation review valida arquitectura, security, RLS, multitenancy, regressions y scope.

**DoD-018-042.** `TASK-018 IMPLEMENTATION PASS` no se interpreta como `DONE / CLOSED`.

**DoD-018-043.** Staging (`git add`) requiere Gate separado y no está autorizado por esta specification.

**DoD-018-044.** Commit requiere Gate separado y no está autorizado por esta specification.

**DoD-018-045.** Push requiere Gate separado y no está autorizado por esta specification.

### 28.8 Remote/final closure

**DoD-018-046.** Remote verification confirma que el commit autorizado está sincronizado y que no existe drift no revisado.

**DoD-018-047.** Final human implementation review = approved mediante Gate separado.

**DoD-018-048.** Final human closure = approved mediante Gate separado.

**DoD-018-049.** El cierre final mantiene RF-012 incompleto mientras profile/membership/tenant-authority/onboarding completion sigan pendientes.

**DoD-018-050.** El cierre final no determina TASK-019 automáticamente.

**DoD range:** `DoD-018-001..DoD-018-050`

**DoD count:** `50`

---

## 29. Git / Hosted governance

### 29.1 Estado durante specification generation

```text
repository mutation = NO
Supabase mutation = NO
Hosted mutation = NO
JIT mutation = NO
Staging environment mutation = NO
Production mutation = NO
git add = NO
commit = NO
push = NO
```

### 29.2 Baseline recibido

```text
branch expectation = main
repository baseline = 710c15b780619622a2bf76b2321f3b628d08fbea
origin/main = 710c15b780619622a2bf76b2321f3b628d08fbea
repository = CLEAN / SYNCHRONIZED
```

Ese baseline pertenece al Gate de generación y no sustituye el preflight fresco de una futura ejecución.

### 29.3 Future implementation preflight

Antes de cualquier cambio:

- confirmar repo root;
- confirmar branch;
- obtener HEAD;
- obtener origin/main;
- verificar divergence;
- verificar clean worktree;
- verificar no Git operation in progress;
- verificar canonical TASK-018 exacta;
- inspeccionar implementación real de TASK-011, TASK-013 y TASK-017;
- inspeccionar boundaries Auth Admin/technical sign-in reales;
- inspeccionar tests existentes y migrations/policies vigentes.

Drift material => `BLOCKER`, no auto-repair.

### 29.4 Hosted

La futura implementación requerirá Hosted Development verification por la naturaleza provider-integrated de esta task, pero cada mutation/fixture/config verification debe estar bajo autorización separada.

No se autoriza Staging ni Production por inferencia.

---

## 30. Deferred decisions preservadas

Permanecen explícitamente sin resolver:

1. exact profile fields;
2. profile persistence contract;
3. profile completion implementation;
4. exact `PlatformUser` creation timing;
5. exact initial `CompanyMembership` creation timing;
6. pre-profile membership state, si alguna futura decisión la introduce;
7. exact ordering entre PlatformUser/profile/membership cuando se complete RF-012;
8. exact transition que habilita first-admin tenant authority;
9. eventual onboarding completion evidence shape;
10. exact `USER_CREATED` producer timing;
11. atomic completion transition posterior al profile;
12. concrete email provider;
13. RF-004 provider retry/backoff;
14. target-email change/cancel/restart;
15. target-email retention period adicional;
16. full post-failure fresh-verification orchestration después de un grant consumido/no entregado;
17. ordinary later-user onboarding;
18. Phase 2 Exit Gate;
19. TASK-019.

La clasificación de failure `SESSION_RECOVERY_REQUIRED / FRESH_PROOF_REQUIRED` no resuelve ni implementa el mecanismo upstream de nueva emisión. Sólo impide que TASK-018 debilite single-use o invente un second grant.

---

## 31. Final self-verification

### 31.1 Scope

```text
START = TASK-017 authoritative durable handoff
END = Auth identity reconciled/provisioned + E2 initial session established/delivered under TASK-011

PlatformUser creation = NO
CompanyMembership creation = NO
profile completion = NO
enabled tenant authority = NO
onboarding completion = NO
```

### 31.2 Security

```text
authenticated != authorized
Auth identity != tenant authority
Auth session != tenant authority
handoff != membership
browser = UNTRUSTED
current PostgreSQL state > stale caller state
technical password server-only = PRESERVED
Require current password when changing password = REQUIRED / FUTURE HOSTED VERIFICATION
password UX = NO
authenticated session may replace technical password without current technical password = NO
```

### 31.3 Privilege

```text
purpose-specific Auth Admin = YES
generic Admin client = NO
technical password browser exposure = NO
service-role ordinary request client = NO
```

### 31.4 Audit

```text
new AuditEvent action = NO
USER_CREATED = NOT PRODUCED BY TASK-018
USER_CREATED timing = DEFERRED
```

### 31.5 Atomicity

```text
PostgreSQL/Auth/HTTP distributed atomicity claimed = NO
partial provisioning modeled = YES
reconciliation-first retry = YES
grant resurrection = NO
```

### 31.6 Governance

```text
Phase 2 = IN PROGRESS / NOT CLOSED
Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED
Phase 3 = NOT STARTED
RF-004 = PARTIAL / NOT END-TO-END
RF-012 = INCOMPLETE
TASK-019 = NOT DETERMINED / NOT AUTHORIZED
```

### 31.7 Counts

```text
AC range = AC-018-001..AC-018-100
AC count = 100

DoD range = DoD-018-001..DoD-018-050
DoD count = 50
```

---

## 32. Resultado final

```text
TASK-018 RECOVERED SOURCE VERIFICATION =
PASS

TASK-018 REQUIRED CANONICAL SOURCE AVAILABILITY =
SATISFIED

TASK-018 SPECIFICATION GENERATION =
PASS

TASK-018 SPECIFICATION CORRECTION =
PASS

correction scope =
ADR-0019 CURRENT-PASSWORD SECURITY INVARIANT ONLY

TASK-018 CENTRAL SPEC REVIEW =
APPROVED

TASK-018 CENTRAL SPEC REVIEW FINAL =
APPROVED

TASK-018 HUMAN SPECIFICATION APPROVAL =
APPROVED

TASK-018 SPECIFICATION =
APPROVED

TASK-018 APPROVED ARTIFACT GENERATION =
PASS

TASK-018 APPROVED ARTIFACT =
GENERATED — PENDING CENTRAL REVIEW

artifact =
TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation-approved.md

blockers =
NONE

implementation =
NOT AUTHORIZED

Codex =
NOT AUTHORIZED

repository mutation =
NO

Supabase mutation =
NO

Hosted mutation =
NO

TASK-019 =
NOT DETERMINED / NOT AUTHORIZED
```

`STOP.`

`RETURN TO REVISOR CENTRAL.`
