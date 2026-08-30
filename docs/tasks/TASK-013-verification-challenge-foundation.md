# TASK-013 — Fundación física segura del lifecycle de VerificationChallenge

## 1. Identificación

**ID:** `TASK-013`

**Título:** `TASK-013 — Fundación física segura del lifecycle de VerificationChallenge`

**Tipo:** `IMPLEMENTATION TASK`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context principal:** `Identity & Auth`

**Estado documental:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:** `TASK-013-verification-challenge-foundation-approved.md`

**Ruta canónica futura propuesta:** `docs/tasks/TASK-013-verification-challenge-foundation.md`

**Resultado de especificación:**

```text
TASK-013 SPECIFICATION = APPROVED FOR IMPLEMENTATION
```

Esta especificación corregida ha sido aprobada documentalmente. La equivalencia de governance es:

```text
APPROVED FOR IMPLEMENTATION
=
SPECIFICATION HUMAN-APPROVED

APPROVED FOR IMPLEMENTATION
!=
IMPLEMENTATION EXECUTION AUTHORIZED

APPROVED FOR IMPLEMENTATION
!=
DONE
```

Debe quedar explícito:

```text
TASK-013 corrected specification approval = YES
TASK-013 human approval = YES

TASK-013 implementation gate = CLOSED
TASK-013 implementación autorizada = NO
TASK-013 implementada = NO

TASK-014 determinada = NO
TASK-014 generada = NO
```

No constituye implementación.

No autoriza Codex.

No autoriza modificación del repositorio.

No autoriza SQL, migration, RLS, Auth Hooks ni cambios Supabase Cloud.

---

## 2. Naturaleza de esta corrección

La especificación histórica de TASK-013 obtuvo:

```text
TASK-013 SPEC REVIEW = APPROVED AS BLOCKED

TASK-013 SPECIFICATION =
BLOCKER — ARCHITECTURE DECISION REQUIRED
```

Ese resultado histórico fue correcto en el momento de su revisión.

La especificación histórica dejó deliberadamente pendientes:

- composición provider/application;
- custodia del secreto;
- modelo físico definitivo;
- constraints e índices;
- frontera privilegiada;
- protocolo de fallos parciales;
- configuración de repositorio/Cloud;
- reevaluación de criterios de aceptación.

Posteriormente:

```text
ADR-0019 = ACCEPTED
```

con la decisión:

```text
E2 — APPLICATION-OWNED VERIFICATION CHALLENGE
+ ONE-TIME SESSION GRANT
+ SERVER-ONLY TECHNICAL PASSWORD BRIDGE
+ CUSTOM ACCESS TOKEN HOOK GATE
```

Esta versión corregida consume E2 y cierra las decisiones físicas estrictamente necesarias para que TASK-013 pueda volver a revisión humana.

No reescribe retrospectivamente la historia.

Debe distinguirse:

```text
TASK-013 historical blocked specification
!=
TASK-013 corrected specification

ADR-0019 accepted
!=
TASK-013 approved for implementation

TASK-013 specification corrected
!=
TASK-013 implementation authorized
```

---

## 3. Estado de gobernanza consumido

Se consume como estado formal cerrado:

```text
Fase 0 = COMPLETADA
Fase 1 = COMPLETADA
Fase 2 = INICIADA

TASK-008 = COMPLETADA
CORR-010 = COMPLETADA

TASK-009 = COMPLETADA
CORR-011 = COMPLETADA

TASK-010 = COMPLETADA
CORR-012 = COMPLETADA

TASK-011 = COMPLETADA
CORR-013 = COMPLETADA

TASK-012 = COMPLETADA
CORR-014 = COMPLETADA

ADR-0019 = ACCEPTED
ADR-0019 canonicalizada = SÍ
ADR-0019 incorporada a origin/main = SÍ

CORR-015 = COMPLETED
CORR-016 = COMPLETED

TASK-013 DETERMINATION = APPROVED
TASK-013 determinada = SÍ
TASK-013 generada = SÍ

TASK-013 historical SPEC REVIEW =
APPROVED AS BLOCKED

TASK-013 corrected specification =
APPROVED FOR IMPLEMENTATION

TASK-013 CORRECTED SPEC EIGHTH REVIEW =
APPROVED

TASK-013 CORRECTED SPEC HUMAN APPROVAL =
APPROVED

TASK-013 implementación autorizada = NO
TASK-013 implementada = NO

Auth funcional = NO

TASK-014 determinada = NO
TASK-014 generada = NO
```

Último baseline Git humano cerrado conocido:

```text
branch = main

HEAD =
3e7721092101db34a90a2f8dbc95c3665939cd94

origin/main =
3e7721092101db34a90a2f8dbc95c3665939cd94

divergence =
0 0

worktree =
clean
```

Este baseline es histórico.

Toda futura ejecución deberá repetir preflight completo.

---

## 4. Fuentes de verdad

La fuente de verdad de una futura implementación es:

1. repositorio real;
2. documentación canónica vigente;
3. ADR aceptados;
4. esta especificación sólo después de aprobación y canonicalización.

### 4.1 Producto

Consumir íntegramente:

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

### 4.2 Arquitectura

Consumir íntegramente:

```text
docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md
docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md
```

ADR-0012/0013 pueden utilizarse únicamente para preservar disciplina de fronteras, provider/server-side y mínimo privilegio cuando resulte pertinente.

No trasladar reglas de Reporting o IA a Auth.

### 4.3 Incrementos previos

Consumir:

```text
docs/tasks/TASK-008-supabase-application-boundary.md
docs/tasks/TASK-009-identity-tenant-foundation.md
docs/tasks/TASK-010-audit-event-foundation.md
docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md
docs/tasks/TASK-012-authoritative-online-authorization-foundation.md
docs/tasks/CORR-014-task-012-closure-state-sync.md
docs/tasks/CORR-015-adr-0019-accepted-state-sync.md
docs/tasks/CORR-016-corr-015-task-013-noncanonical-reference.md
```

### 4.4 Antecedente histórico

El artefacto histórico:

```text
TASK-013-verification-challenge-foundation.md
```

se utiliza exclusivamente como antecedente de especificación.

No es actualmente una fuente canónica independiente.

Su resultado bloqueado debe preservarse como historia, no como estado vigente de esta versión corregida.

### 4.5 Fuentes oficiales Supabase

Antes de implementar deberán reverificarse contra documentación oficial vigente, como mínimo:

- Auth Hooks;
- Custom Access Token Hook;
- error handling y timeout de hooks;
- `authentication_method`;
- `signInWithPassword`;
- `auth.admin.createUser`;
- `auth.admin.updateUserById`;
- configuración general de Auth;
- configuración local de hooks;
- password mutation;
- password policy vigente y su superficie Hosted/oficial;
- token refresh;
- sesiones y mecanismos soportados de invalidación cuando corresponda al Gate pre-E2;
- API keys/secret keys;
- RLS y Data API.

No utilizar:

```text
GitHub source
GoTrue internals
self-hosted-only behavior
observación incidental
```

como sustituto de una capacidad Hosted documentada.

---

## 5. Requisitos de producto no negociables

TASK-013 preserva literalmente:

**RF-004.** El sistema DEBE enviar un código de verificación al correo indicado.

**RF-005.** Cada código DEBE tener una vigencia de 8 horas desde su emisión.

**RF-006.** Cada código DEBE admitir como máximo 3 intentos de verificación.

**RF-007.** El actor autorizado para el alta DEBE poder reenviar el código las veces que sea necesario.

**RF-008.** Cada reenvío DEBE emitir un código nuevo.

**RF-009.** Al emitir un nuevo código, el código anterior DEBE quedar inmediatamente invalidado.

**RF-010.** Cada código nuevo DEBE disponer de sus propios 3 intentos.

**RF-011.** Un código vencido NO DEBE poder recuperarse ni reutilizarse.

También se preserva:

```text
challenge consumido
→ no reutilizable
```

Contrato:

```text
email + código

vigencia por emisión = exactamente 8 horas

máximo de intentos efectivos por emisión = 3

resend autorizado = permitido

cada resend = nueva emisión

nueva emisión
→ emisión anterior deja de ser usable inmediatamente

cada emisión
→ presupuesto de intentos independiente

expired
→ no reutilizable

consumed
→ no reutilizable

attempts exhausted
→ no reutilizable

invalidated by resend
→ no reutilizable
```

No se permite adaptar estos requisitos a defaults del proveedor.

---

## 6. Dominio preservado

### 6.1 `VerificationChallenge`

Representa una emisión concreta de un código de verificación de negocio.

```text
VerificationChallenge identity
=
una emisión concreta
```

Dos resends producen identidades distintas.

### 6.2 Ownership

```text
VerificationChallenge = platform-owned
```

No es:

- tenant-owned;
- `MaintenanceCompany`;
- `CompanyMembership`;
- `Client`;
- `UserClientAccess`;
- autorización tenant.

No contiene:

```text
maintenance_company_id
tenant_id
role
client scope
```

como autoridad.

### 6.3 Email

El email:

- es PII;
- es locator de login/provider;
- puede participar en la correlación del challenge;
- no constituye identidad autoritativa de aplicación;
- no constituye tenant;
- no constituye role;
- no constituye client scope.

```text
email
!=
PlatformUser authority
```

### 6.4 Estados conceptuales

```text
issued
consumed
expired
attempts exhausted
invalidated by resend
```

Los cuatro últimos son terminales para esa emisión.

Ningún estado terminal puede reactivarse.

---

## 7. Decisión arquitectónica consumida

TASK-013 no reabre arquitectura.

Consume exactamente:

```text
E2 — APPLICATION-OWNED VERIFICATION CHALLENGE
+ ONE-TIME SESSION GRANT
+ SERVER-ONLY TECHNICAL PASSWORD BRIDGE
+ CUSTOM ACCESS TOKEN HOOK GATE
```

Pruebas separadas:

```text
business proof
=
VerificationChallenge code

provider proof
=
technical password server-only

initial session authorization proof
=
one-time SessionGrant
```

Cadena:

```text
authorized business intent
→ application-owned VerificationChallenge
→ valid code proof
→ atomic challenge consume
→ one-time SessionGrant
→ server-only technical password proof
→ signInWithPassword
→ Custom Access Token Hook
→ atomic SessionGrant consume
→ Supabase JWT/session
```

Debe continuar:

```text
token_refresh
!=
initial authentication
```

Y:

```text
Auth session
!=
tenant authorization
```

---

## 8. Objetivo único

TASK-013 debe implementar, después de aprobación y autorización separadas, únicamente la **foundation física y de seguridad** necesaria para hacer implementable la cadena E2.

Incluye:

1. persistencia de `VerificationChallenge`;
2. persistencia técnica de intentos idempotentes;
3. verifier criptográfico keyed;
4. expiry exacta de 8 horas;
5. tres intentos exactos por emisión;
6. resend con invalidación autoritativa;
7. single-use;
8. concurrency safety;
9. `AuthBridgeCredential` técnico;
10. technical password server-only;
11. `SessionGrant`;
12. consumo atómico del grant;
13. Custom Access Token Hook default-deny;
14. frontera Auth Admin purpose-specific;
15. grants/revokes mínimos;
16. RLS/no Data API browser;
17. configuración local necesaria;
18. contrato de configuración privada;
19. pruebas de seguridad, concurrencia y bypass.

TASK-013 continúa siendo:

```text
foundation
```

y no un caso de uso completo de producto.

---

## 9. Fuera de alcance

TASK-013 NO implementa:

- endpoint funcional de alta;
- Server Action funcional de alta;
- email delivery productivo;
- integración SMTP/Resend;
- template de email;
- login UI;
- password UI;
- password elegido por usuario;
- password recovery UX;
- signup público;
- onboarding;
- creación funcional de `MaintenanceCompany`;
- creación funcional de `CompanyMembership`;
- primer `COMPANY_ADMIN`;
- altas posteriores de usuarios;
- selector tenant;
- route guards;
- autorización funcional de actor para issue/resend;
- `UserClientAccess`;
- `SupportAccessGrant`;
- `Client`;
- AuditEvent producer;
- Storage;
- Realtime;
- offline Auth;
- ADR-0004;
- Fase 3;
- Staging;
- Production;
- TASK-014.

Debe permanecer:

```text
Auth funcional = NO
UI flow = NO APLICA
Offline behavior = NO APLICA / FUERA DE ALCANCE
AuditEvent producer = NO
```

---

# 10. Slice físico autorizado

La implementación deberá ser un único slice PR-sized dentro del monolito modular.

Objetivo de schema:

```text
4 tablas técnicas platform-owned
+
purpose-specific DB transitions
+
1 Custom Access Token Hook
+
mínimo código server-side/crypto/config
+
tests
```

Tablas:

```text
public.verification_challenges
public.verification_challenge_attempts
public.auth_bridge_credentials
public.auth_session_grants
```

Estas cuatro tablas pertenecen técnicamente al bounded context `Identity & Auth`.

No constituyen cuatro nuevas entidades funcionales de producto.

---

# 11. `public.verification_challenges`

## 11.1 Responsabilidad

Persistir una emisión concreta y su lifecycle autoritativo.

## 11.2 Campos mínimos

| Campo | Semántica |
| --- | --- |
| `id` | UUID PK de la emisión |
| `email` | email asociado al challenge; PII y locator, no identity authority |
| `verifier` | verifier keyed del código; nunca plaintext |
| `verifier_key_version` | versión de key utilizada para calcular el verifier |
| `issued_at` | timestamp server-side autoritativo |
| `expires_at` | límite temporal autoritativo |
| `attempt_count` | contador monotónico `0..3` |
| `consumed_at` | timestamp nullable de consumo exitoso |
| `invalidated_at` | timestamp nullable de invalidación por successor/resend |
| `exhausted_at` | timestamp nullable al agotar el tercer intento fallido |
| `supersedes_challenge_id` | self-FK nullable hacia la emisión anterior |
| `issue_operation_id` | UUID único de idempotencia de issue/resend |

No añadir:

- tenant;
- membership;
- role;
- client scope;
- JWT;
- access token;
- refresh token;
- plaintext code;
- technical password.

## 11.3 Expiración exacta

Constraint contractual:

```text
expires_at
=
issued_at + exactly 8 hours
```

`issued_at` debe usar clock server-side autoritativo.

La condición de vigencia es:

```text
current server time < expires_at
```

En:

```text
current server time >= expires_at
```

la emisión está expirada.

No se requiere background job para marcar `expired_at`.

La expiración es terminal por condición temporal.

## 11.4 Attempts

Constraint:

```text
0 <= attempt_count <= 3
```

El contador:

- sólo aumenta;
- nunca se resetea;
- pertenece a la emisión concreta;
- no depende de rate limiting Supabase;
- no depende de frontend;
- no depende de process memory.

## 11.5 Terminalidad

Como máximo uno de:

```text
consumed_at
invalidated_at
exhausted_at
```

puede representar terminalidad persistida.

La expiración por clock es adicionalmente terminal aunque esos timestamps permanezcan `NULL`.

Un challenge no es verificable si:

```text
consumed_at IS NOT NULL
OR invalidated_at IS NOT NULL
OR exhausted_at IS NOT NULL
OR server_now >= expires_at
OR attempt_count >= 3
```

salvo que `attempt_count = 3` corresponda al mismo intento que termina exitosamente en `consumed_at`.

## 11.6 Consumo en tercer intento

Debe ser posible:

```text
attempt_count = 3
AND
consumed_at IS NOT NULL
AND
exhausted_at IS NULL
```

si el tercer intento es correcto.

Si el tercer intento es incorrecto:

```text
attempt_count = 3
AND
exhausted_at IS NOT NULL
AND
consumed_at IS NULL
```

## 11.7 Cadena de resend

Para un resend B de A:

```text
B.supersedes_challenge_id = A.id
```

Un challenge no puede ser su propio predecessor.

Debe existir como máximo un successor directo aceptado para una emisión concreta.

Una segunda intención concurrente de resend sobre el mismo predecessor no puede producir una segunda emisión simultáneamente válida.

---

# 12. `public.verification_challenge_attempts`

## 12.1 Motivo

La exactitud de RF-006 también debe sobrevivir:

- retries;
- timeouts;
- responses perdidas;
- requests concurrentes.

Sólo almacenar `attempt_count` no permite distinguir de forma robusta:

```text
retry de la misma operación
```

de:

```text
nuevo intento deliberado
```

Por ello TASK-013 incorpora persistencia técnica mínima de operaciones de intento.

## 12.2 Campos mínimos

| Campo | Semántica |
| --- | --- |
| `id` | UUID PK técnica |
| `challenge_id` | FK al challenge |
| `operation_id` | UUID idempotency key única |
| `attempt_number` | número efectivo `1..3` |
| `matched` | resultado booleano de comparación del verifier |
| `created_at` | timestamp server-side |

Prohibido almacenar:

- candidate code;
- plaintext;
- candidate verifier si no es estrictamente necesario tras completar la transición;
- secrets;
- tokens.

## 12.3 Invariantes

Debe existir uniqueness para:

```text
operation_id
```

y para:

```text
(challenge_id, attempt_number)
```

Un retry con el mismo `operation_id`:

```text
NO incrementa attempt_count de nuevo
```

y devuelve/reconcilia el resultado ya persistido.

Un `operation_id` distinto representa un nuevo intento efectivo.

Los operation IDs deben originarse en la frontera server-side.

No constituyen autoridad si son enviados por el browser.

---

# 13. Verifier criptográfico

## 13.1 Algoritmo

TASK-013 selecciona como decisión física local:

```text
HMAC-SHA-256
```

mediante la primitive criptográfica estándar del runtime Node.js.

Dependencias npm nuevas para crypto:

```text
0
```

## 13.X Representación y comparación constant-time

El digest HMAC del challenge debe utilizar una representación física de longitud fija equivalente a:

```text
32 bytes
```

para HMAC-SHA-256.

La persistencia debe enforcear que un verifier válido posea exactamente esa longitud.

La comparación entre:

```text
stored verifier
```

y:

```text
candidate verifier
```

DEBE realizarse utilizando una primitive constant-time del runtime server-side aprobado.

Para Node.js:

```text
crypto.timingSafeEqual
```

o primitive equivalente oficialmente soportada.

Prohibido utilizar como comparación autoritativa:

```text
===
==
string equality
Buffer.equals como sustitución no revisada
SQL "=" como garantía de constant-time
manual early-return byte comparison
```

La comparación debe operar sobre buffers binarios de igual longitud.

Si una representación almacenada tiene longitud inesperada:

```text
fail closed
```

No adaptar dinámicamente el candidate al tamaño corrupto.

No crear una dependencia criptográfica nueva.

### Testing

Los tests deben comprobar:

```text
equal fixed-length digest → match
different fixed-length digest → no match
invalid verifier length → fail closed
approved constant-time primitive is used
```

No se exige un benchmark estadístico de timing como criterio de aceptación.

La obligación verificable es utilizar la primitive constant-time aprobada sobre inputs fixed-length.

## 13.2 Domain separation

Conceptualmente:

```text
challenge_key =
resolveChallengeKey(verifier_key_version)

verifier =
HMAC-SHA-256(
  challenge_key,
  serialize(
    "verification-challenge:v1",
    challenge_id,
    code
  )
)
```

Debe quedar inequívocamente:

```text
verifier_key_version
=
non-secret identifier
used only to select the secret challenge key
```

y:

```text
challenge_key
=
server-only secret key material
resolved from private configuration
```

Nunca:

```text
HMAC key = verifier_key_version
```

`resolveChallengeKey(...)` es una primitive conceptual; el naming de implementación puede adaptarse a las convenciones reales sin crear una abstraction obligatoria con ese nombre.

La serialización exacta debe:

- ser determinista;
- incluir domain separation;
- no admitir concatenaciones ambiguas;
- disponer de test vectors.

No se fija un formato funcional del código.

TASK-013 no inventa:

- número de dígitos;
- alfabeto;
- UX;
- generador funcional de código.

El código se trata como input opaco del futuro flow.

## 13.3 Storage

Persistir:

```text
verifier
+
verifier_key_version
```

Nunca persistir:

```text
code
```

## 13.4 Keys

La key del challenge debe ser:

- dedicada;
- server-only;
- versionada;
- rotatable;
- no versionada en Git;
- no enviada al browser;
- no logueada.

Debe quedar explícito:

```text
verifier_key_version
!=
challenge secret key material
```

Persistencia:

```text
verification_challenges.verifier_key_version
→ identifier only
```

Configuración privada:

```text
AUTH_CHALLENGE_HMAC_KEY_<version>
→ secret key material
```

Está prohibido persistir challenge secret key material en:

```text
verification_challenges
verification_challenge_attempts
auth_bridge_credentials
auth_session_grants
```

Si una versión requerida existe en DB pero su secret material no puede resolverse desde configuración privada:

```text
fail closed
```

No usar:

- version string;
- active-version string;
- fallback key;
- another version;
- plaintext code.

Debe mantenerse:

```text
challenge HMAC key
!=
technical password key
!=
Supabase secret key
!=
access token
!=
refresh token
```

## 13.5 Rotación

Al activar una versión nueva:

- las nuevas emisiones utilizan la nueva versión;
- las versiones antiguas necesarias para challenges todavía vigentes permanecen disponibles;
- no se recomputan verifiers históricos;
- no se reactiva ningún challenge;
- una key antigua no debe eliminarse hasta que ninguna emisión que dependa de ella pueda seguir legítimamente vigente.

Remover accidentalmente una key necesaria:

```text
fail closed
```

No se hace fallback a plaintext ni a otra key.

Debe permanecer:

```text
old verifier_key_version
→ old secret key must remain resolvable
while a challenge depending on it can still be legitimately verified
```

Cambiar el identificador de versión no constituye por sí mismo material secreto.

---

# 14. Issue inicial

TASK-013 define una primitive server-side purpose-specific de foundation.

No crea endpoint.

No crea Server Action funcional.

La primitive futura recibe conceptualmente:

```text
challenge_id
email
verifier
verifier_key_version
issue_operation_id
```

## 14.1 Reglas

Dentro de una única transición autoritativa:

```text
issued_at = server clock
expires_at = issued_at + 8h
attempt_count = 0
terminal timestamps = NULL
```

Un retry con el mismo:

```text
issue_operation_id
```

debe resolver idempotentemente la misma emisión.

Un `issue_operation_id` no puede crear dos challenges distintos.

La primitive no autoriza por sí misma quién puede emitir.

La autorización funcional del actor permanece para un caso de uso posterior.

El acceso DB a la primitive sí debe ser server-only y no browser.

---

# 15. Resend e invalidación inmediata

## 15.1 Contrato

```text
challenge A
→ authorized resend
→ challenge B
```

implica:

```text
A ya no puede verificar
```

cuando B ha sido creada autoritativamente.

## 15.2 Transacción

La transición debe:

1. localizar y bloquear A;
2. resolver idempotencia por `issue_operation_id`;
3. verificar que A no fue consumida;
4. impedir un segundo successor incompatible;
5. invalidar A si todavía era active;
6. insertar B;
7. asignar a B su propio `attempt_count = 0`;
8. asignar a B su propio `issued_at`;
9. asignar a B su propio `expires_at = issued_at + 8h`;
10. completar todo en una única transacción DB.

No se permite:

```text
invalidate A
COMMIT
insert B later
```

ni:

```text
insert B
COMMIT
invalidate A later
```

## 15.3 Previous terminal challenges

Un predecessor ya:

```text
expired
```

o:

```text
attempts exhausted
```

puede originar una nueva emisión si el futuro caso de uso está autorizado.

No se reactiva el predecessor.

Un predecessor:

```text
consumed
```

no puede utilizarse para abrir de nuevo el mismo proof como simple resend.

## 15.4 Concurrencia

Dos resends distintos sobre el mismo predecessor:

```text
at most one successor accepted
```

El loser:

- no crea otra emisión usable;
- recibe outcome fail-closed/stale;
- no altera el winner.

---

# 16. Verificación atómica

## 16.1 Preparación server-side del match

La frontera server-side purpose-specific:

1. recibe `challenge_id`, email, código candidate y `verification_operation_id`;
2. obtiene mediante una primitive DB purpose-specific únicamente el material técnico mínimo necesario:
   - verifier;
   - verifier key version;
3. calcula server-side el candidate HMAC;
4. compara candidate/stored verifier mediante la primitive constant-time aprobada;
5. obtiene exclusivamente:

```text
matched = true | false
```

La primitive que recupera material de verificación:

- no es ejecutable por `anon`;
- no es ejecutable por `authenticated`;
- no se expone al browser;
- no devuelve plaintext code;
- no devuelve secrets;
- no constituye un generic table reader.

El verifier es inmutable durante la vida de una emisión.

## 16.2 Transición DB atómica

Después de calcular `matched`, la frontera server-side invoca la transition function autoritativa con:

```text
challenge_id
email
verification_operation_id
matched
```

La función DB NO confía en estado lifecycle previamente observado.

Dentro de su propia transacción debe volver a:

1. resolver retry por `verification_operation_id`;
2. bloquear el challenge;
3. validar challenge/email;
4. validar que no esté consumed;
5. validar que no esté invalidated;
6. validar que no esté exhausted;
7. validar que no esté expired;
8. validar attempt budget;
9. asignar el siguiente `attempt_number`;
10. incrementar `attempt_count` exactamente una vez;
11. persistir la attempt row;
12. aplicar `matched`.

Si `matched = false`:

```text
attempt 1/2
→ permanece active

attempt 3
→ exhausted_at = now
```

Si `matched = true`:

```text
challenge consumed
+
bridge credential resolved
+
SessionGrant created
```

en la transición atómica ya especificada.

### Race safety

Si entre la lectura del verifier y la transition function ocurre:

```text
resend
consume
expiry
exhaustion
otra transición terminal
```

la transition function debe observar el estado autoritativo más reciente y denegar.

Por tanto:

```text
constant-time comparison outside lifecycle transaction
!=
trust in stale lifecycle state
```

Debe continuar:

```text
current authoritative DB state
>
pre-comparison observation
```

## 16.3 Email mismatch

```text
challenge.email != request email
→ generic deny
```

No revelar cuál de ambos valores era correcto.

## 16.4 Missing challenge

```text
missing id
→ generic deny
```

No convertir el endpoint futuro en enumerador.

---

# 17. Resultado de un verify correcto

El éxito técnico de la transición produce únicamente:

```text
challenge consumed
+
AuthBridgeCredential resolved
+
SessionGrant created
```

No produce automáticamente:

- `MaintenanceCompany`;
- `CompanyMembership`;
- role;
- `UserClientAccess`;
- tenant authorization;
- UI session;
- onboarding completado.

Debe permanecer:

```text
business verification success
!=
tenant authorization
```

---

# 18. `public.auth_bridge_credentials`

## 18.1 Naturaleza

`AuthBridgeCredential` es estado técnico interno de E2.

No es una entidad funcional de producto.

No modifica `02-domain-model.md`.

Ownership:

```text
platform-owned
```

## 18.2 Responsabilidad

Mantener únicamente la metadata necesaria para derivar y versionar la technical password y vincularla, cuando exista, a un Supabase Auth subject.

## 18.3 Campos mínimos

| Campo | Semántica |
| --- | --- |
| `id` | UUID PK estable usada como input de derivación |
| `email` | locator de Auth asociado |
| `auth_user_id` | UUID nullable, unique, FK hacia `auth.users(id)` cuando ya se conoce |
| `technical_password_key_version` | versión actualmente confirmada |
| `pending_key_version` | versión nullable durante rotación explícita |
| `rotation_operation_id` | UUID nullable/unique para rotación idempotente |
| `created_at` | creación server-side |
| `bound_at` | momento en que se vinculó un Auth subject |
| `rotation_started_at` | inicio de rotación nullable |
| `rotated_at` | última rotación completada nullable |

No persistir:

```text
technical_password
technical_password_hash de aplicación
access token
refresh token
```

Supabase Auth continúa siendo autoridad de su password provider-side.

## 18.4 Email uniqueness

Debe existir una única bridge credential activa por locator email que el futuro flow entregue como email canónico de Auth.

TASK-013 no inventa una nueva política funcional de normalización de email.

El caller server-side debe proporcionar el mismo valor canónico utilizado con Supabase Auth.

Si el comportamiento real de normalización del proveedor hace imposible una correlación inequívoca:

```text
BLOCKER
```

No resolverlo mediante aproximación insegura.

## 18.5 Auth subject

Cuando:

```text
auth_user_id IS NOT NULL
```

ese subject es autoritativo para la bridge credential.

No puede reasignarse silenciosamente a otro Auth user.

Una reparación que exija rebinding constituye operación purpose-specific explícita y debe detenerse para revisión si excede esta TASK.

---

# 19. Technical password

## 19.1 Naturaleza

La technical password:

```text
provider proof
```

No es:

- contraseña de producto;
- contraseña elegida por usuario;
- dato de perfil;
- tenant authorization;
- business secret del challenge.

## 19.2 Derivación y compatibilidad obligatoria con password policy

La technical password continúa derivándose a partir de material criptográfico server-only y determinista.

La primitive criptográfica base es:

```text
technical_password_key =
resolveTechnicalPasswordKey(
  technical_password_key_version
)

seed =
HMAC-SHA-256(
  technical_password_key,
  serialize(
    "auth-technical-password:v1",
    auth_bridge_credential_id
  )
)
```

Debe quedar explícito:

```text
technical_password_key_version
=
non-secret identifier
```

y:

```text
technical_password_key
=
server-only secret key material
```

Nunca:

```text
HMAC key = technical_password_key_version
```

La domain separation es obligatoria y `resolveTechnicalPasswordKey(...)` es conceptual; el naming de implementación puede adaptarse a las convenciones reales.

Pero queda expresamente PROHIBIDO asumir que:

```text
base64url(seed)
```

por sí solo satisface la password policy real de Supabase.

Alta entropía:

```text
!=
compatibilidad garantizada con password policy
```

Antes de fijar o ejecutar el encoder físico debe conocerse y verificarse la password policy canónica vigente del entorno Supabase Development, incluyendo como mínimo todo requisito aplicable de:

```text
minimum length
required lowercase
required uppercase
required digits
required symbols
cualquier otra restricción documentada que afecte passwords nuevos
```

La verificación debe utilizar una superficie Hosted/oficial soportada.

No inferir la policy exclusivamente desde defaults locales.

No asumir que la policy Cloud coincide con un valor histórico.

Si la policy canónica no puede conocerse o verificarse inequívocamente:

```text
BLOCKER — SUPABASE PASSWORD POLICY UNKNOWN
```

DETENER.

No modificar silenciosamente la password policy para acomodar la construcción.

### Construcción determinista

Una vez verificada la policy, la technical password debe producirse mediante:

```text
technical_password =
encodeTechnicalPassword(seed, verifiedCanonicalPasswordPolicy)
```

El encoder debe ser determinista y garantizar, no sólo hacer probable, que la salida satisface simultáneamente:

```text
minimum required length
required lowercase class, si aplica
required uppercase class, si aplica
required digit class, si aplica
required symbol class, si aplica
provider-supported maximum/format constraints, si existen
```

Para toda clase requerida debe incorporarse determinísticamente al menos un carácter perteneciente a una charset que haya sido verificada como válida para la policy canónica.

Los restantes caracteres deben derivarse determinísticamente del `seed` utilizando un alfabeto aprobado compatible con esa misma policy.

La construcción debe preservar alta entropía global.

No puede depender de:

- aleatoriedad no reproducible;
- retry hasta que casualmente aparezca una clase;
- email;
- tenant;
- role;
- estado del browser.

Debe existir un test determinista para la policy canónica que demuestre:

```text
password satisfies canonical policy = YES
```

### Drift de policy

Si la password policy cambia posteriormente y la construcción vigente deja de garantizar compatibilidad:

```text
CONFIGURATION DRIFT = BLOCKER
```

No cambiar el encoder o la policy automáticamente.

La adaptación requiere revisión explícita y, cuando afecte credentials ya provisionadas, plan de rotación.

## 19.3 Propiedades

Debe ser:

```text
high entropy
server-only
no UX
no browser
no plaintext DB storage
no logs
no telemetry
```

## 19.4 Keys

Debe quedar explícito:

```text
technical_password_key_version
!=
technical-password secret key material
```

Debe mantenerse:

```text
technical-password secret key
!=
challenge secret key
!=
Supabase secret key
```

Persistencia:

```text
auth_bridge_credentials.technical_password_key_version
→ identifier only
```

Configuración privada:

```text
AUTH_TECHNICAL_PASSWORD_KEY_<version>
→ secret key material
```

La key:

- vive únicamente en configuración privada server-side;
- se versiona mediante identificador, no mediante valor en DB;
- es rotatable;
- nunca se exporta desde un módulo client-safe.

Si el key version requerido no puede resolverse:

```text
fail closed
```

No intentar:

```text
fallback to active version
fallback to old/new version
use version identifier as key
```

## 19.5 No password funcional

TASK-013 no crea:

- password form;
- reset-password form;
- password field de perfil;
- user-chosen password;
- documentación de password al usuario.

---

# 20. Rotación de technical password

## 20.1 No por login

Prohibido:

```text
rotate on every login
```

La rotación es una operación administrativa separada.

## 20.2 Secuencia

Una rotación explícita debe:

1. exigir `auth_user_id` conocido;
2. asignar `pending_key_version`;
3. fijar `rotation_operation_id`;
4. derivar la nueva technical password server-side;
5. llamar exclusivamente a `auth.admin.updateUserById`;
6. sólo después de confirmación inequívoca actualizar `technical_password_key_version`;
7. limpiar el pending state;
8. registrar `rotated_at`.

La rotación cambia el identificador de versión de secret key seleccionado sólo después de que la mutación correspondiente del provider haya sido confirmada.

Debe permanecer:

```text
changing key version identifier
does not itself constitute secret-key material
```

y:

```text
technical_password_key_version
→ determines which server-only secret key reproduces
the provider credential currently expected
```

## 20.3 Fallo incierto

Si el provider result es incierto:

```text
pending rotation
→ bridge sign-in fail closed
→ explicit retry/repair
```

No volver automáticamente a la password anterior.

No habilitar:

- passwordless;
- recovery;
- password de usuario.

El mismo `rotation_operation_id` debe utilizarse en retry.

La repetición de una mutación provider potencialmente disruptiva no debe ejecutarse ciegamente.

---

# 21. `public.auth_session_grants`

## 21.1 Definición

```text
SessionGrant
=
server-side evidence that exactly one
initial Supabase session issuance attempt
is authorized after a VerificationChallenge was consumed
```

Es:

```text
platform-owned
```

No es tenant-owned.

## 21.2 TTL

TASK-013 fija como decisión física local:

```text
SessionGrant TTL = 5 minutes
```

Esta duración:

- no es un requisito funcional de usuario;
- es una constante técnica de seguridad;
- limita la ventana entre business proof y initial session issuance;
- debe quedar enforceada por DB.

Constraint:

```text
expires_at
=
created_at + exactly 5 minutes
```

No puede ampliarse silenciosamente durante implementación.

Si el entorno real demuestra que cinco minutos hacen inviable el protocolo:

```text
BLOCKER
→ volver a revisión
```

## 21.3 Campos mínimos

| Campo | Semántica |
| --- | --- |
| `id` | UUID PK |
| `challenge_id` | FK unique al challenge consumido |
| `auth_bridge_credential_id` | FK a bridge credential |
| `auth_user_id` | UUID nullable hasta binding inicial cuando sea necesario |
| `purpose` | valor cerrado `initial_session` |
| `auth_method` | valor cerrado `password` |
| `created_at` | server-side |
| `expires_at` | exactamente +5 minutos |
| `consumed_at` | nullable |
| `revoked_at` | nullable |
| `grant_operation_id` | operation UUID unique |

## 21.4 Single-use

```text
consumed_at IS NOT NULL
→ grant unusable
```

No reactivar.

## 21.5 Revocation

Un grant puede quedar revocado cuando:

- una nueva prueba válida sustituye un grant todavía no usado;
- existe reparación explícita;
- el protocolo detecta inconsistencia segura.

Un grant revocado no puede reactivarse.

## 21.6 Uno por bridge en ventana activa

No puede existir más de un grant:

```text
unconsumed
AND
unrevoked
```

para la misma `auth_bridge_credential_id`.

Antes de crear un nuevo grant, la transición autoritativa debe cerrar/revocar cualquier grant anterior que ya no deba competir.

Un grant expirado que bloquee una constraint física debe cerrarse/revocarse dentro de la misma transición antes del nuevo insert.

## 21.7 Browser

El grant:

- no se entrega como bearer token;
- no es cookie de autorización;
- no se expone mediante Data API;
- no concede acceso si se conoce su UUID.

---

# 22. Provisioning Auth foundation

TASK-013 no implementa onboarding funcional, pero debe implementar la frontera técnica necesaria para que un futuro caso de uso pueda componer E2 sin abrir un Admin client genérico.

## 22.1 Usuario ya vinculado

Si:

```text
auth_bridge_credentials.auth_user_id != NULL
```

la foundation:

- deriva la technical password de la credential;
- usa `signInWithPassword` únicamente server-side;
- utiliza semantics normales de publishable key/no privilegio para el sign-in;
- deja al Custom Access Token Hook decidir la emisión del JWT.

No utilizar secret key para convertir el sign-in ordinario en un bypass privilegiado.

## 22.2 Credential no vinculada

Si la bridge credential todavía no posee `auth_user_id`, la frontera purpose-specific puede:

1. intentar reconciliar mediante un `signInWithPassword` server-side con la technical password derivada;
2. si ese sign-in no demuestra una identidad ya provisionada, ejecutar una única intención de `auth.admin.createUser`;
3. usar:
   - email autorizado;
   - technical password derivada;
   - confirmación de email únicamente porque el business challenge ya fue consumido;
4. volver a intentar el sign-in server-side;
5. permitir que el Custom Access Token Hook vincule de forma atómica el Auth subject cuando todos los checks coinciden.

## 22.3 Razón del sign-in de reconciliación

Esta secuencia permite manejar:

```text
createUser success
+
application response lost
```

sin repetir ciegamente creación de usuario.

Si el usuario había sido creado con la technical password esperada, `signInWithPassword` puede demostrarlo.

Si no:

```text
fail closed
```

No usar:

```text
listUsers
generic admin search
password reset
magic link
OTP
recovery
```

como fallback ordinario.

## 22.4 Cuenta existente incompatible

Si el email ya corresponde a un Auth user que no puede probar la technical password esperada:

```text
REPAIR REQUIRED
```

No reemplazar automáticamente la password.

No tomar posesión silenciosamente de una identidad provider preexistente.

---

# 23. Auth Admin purpose-specific boundary

## 23.1 Operaciones permitidas

Lista cerrada:

```text
auth.admin.createUser
auth.admin.updateUserById
```

Únicamente para:

- provisioning inicial;
- rotación;
- reparación explícita compatible con ADR-0019;
- confirmación de email después de business proof válido.

## 23.2 Operaciones no permitidas por el boundary ordinario

No exponer:

```text
auth.admin.listUsers
auth.admin.deleteUser
auth.admin.generateLink
generic auth.admin access
```

como capacidad reusable.

Si una futura reparación necesita ampliar la lista:

```text
BLOCKER
→ revisión humana
```

## 23.3 Credencial

La frontera utiliza exclusivamente una credencial privada backend de Supabase aprobada para Admin operations.

Debe existir un entrypoint privado específico.

Prohibido:

```text
getAdminClient()
createPrivilegedSupabaseClient()
export raw secret client
```

o equivalente genérico.

## 23.4 Browser

La credencial privilegiada:

```text
browser = NEVER
```

No debe aparecer en:

- client bundles;
- `NEXT_PUBLIC_*`;
- responses;
- logs;
- tests fixtures reales.

---

# 24. Server-side sign-in boundary

Debe distinguirse:

```text
Auth Admin privileged boundary
!=
technical sign-in boundary
```

El sign-in ordinario E2 utiliza:

```text
signInWithPassword
```

server-side con semantics no privilegiadas/publishable.

La technical password nunca se entrega al browser.

No crear un endpoint genérico que acepte una password arbitraria.

El futuro caso de uso sólo puede solicitar:

```text
establish technical session
for a previously consumed challenge/grant
```

---

# 25. Custom Access Token Hook

## 25.1 Implementación

TASK-013 incluye la foundation física de un:

```text
Postgres Function Custom Access Token Hook
```

No HTTP Hook.

Debe configurarse localmente conforme a la primitive oficial vigente.

## 25.2 Policy default-deny

El hook interpreta:

```text
event.user_id
event.claims
event.claims.email
event.authentication_method
```

### `password`

Para:

```text
authentication_method = password
```

debe:

1. localizar exactamente un grant eligible;
2. bloquearlo;
3. exigir `purpose = initial_session`;
4. exigir `auth_method = password`;
5. exigir no expirado;
6. exigir no consumed;
7. exigir no revoked;
8. resolver la bridge credential;
9. exigir correlación de email/subject;
10. vincular el `auth_user_id` sólo si todavía no estaba vinculado y la correlación es inequívoca;
11. si ya estaba vinculado, exigir igualdad exacta de `user_id`;
12. consumir el grant atómicamente;
13. preservar claims obligatorios;
14. permitir token issuance sólo si toda la transición finaliza.

### `token_refresh`

```text
authentication_method = token_refresh
```

se permite como lifecycle de una sesión ya existente únicamente después del Gate de cutover definido en §25.X.

No consume otro grant.

No requiere nuevo challenge.

Un failure/timeout del hook durante refresh:

```text
refresh fails
```

No se convierte en login alternativo.

### Otros initial methods

Debe aparecer como mínimo bajo deny explícito:

```text
otp
totp
magiclink
recovery
invite
email/signup
email_change
oauth
oauth_provider
authorization_code
oauth_provider/authorization_code
sso/saml
anonymous
```

La nomenclatura exacta debe reconciliarse con los valores oficiales realmente emitidos por la versión vigente del provider.

La intención normativa es inequívoca:

```text
todo initial authentication method
distinto del password path E2 aprobado
=
DENY
```

`totp` es explícitamente un método conocido y debe probarse como tal.

`email_change` permanece denied mientras no exista una decisión posterior que lo autorice.

`oauth_provider` / `authorization_code` permanecen denied.

Cualquier valor:

```text
nuevo
desconocido
no reconocido
```

también:

```text
DENY BY DEFAULT
```

## 25.X Pre-E2 session and access-token cutover Gate

La regla:

```text
authentication_method = token_refresh
→ allow lifecycle continuation
```

sólo es válida después de completar íntegramente el Gate de cutover E2.

ADR-0019 permite `token_refresh` para:

```text
una sesión legítima ya establecida
```

No convierte automáticamente:

```text
pre-E2 session
```

ni:

```text
pre-E2 access token
```

en credenciales legítimas bajo E2.

Debe distinguirse:

```text
refresh capability revoked
!=
already-issued access token immediately invalid
```

La terminación/revocación de una sesión puede impedir futuros refreshes sin invalidar inmediatamente un access token JWT ya emitido.

Un JWT pre-E2 todavía no expirado puede seguir siendo aceptable hasta su `exp`.

Por tanto, el cutover no termina únicamente al eliminar la capacidad de refresh.

Debe cubrir simultáneamente:

```text
A. pre-E2 refresh capability
B. pre-E2 access-token validity tail
```

Debe quedar expresamente prohibida la inferencia:

```text
Auth funcional = NO
→ no existen sesiones o access tokens pre-E2 utilizables
```

El estado real de Supabase Cloud Development es autoridad.

### 25.X.1 Definición de cutover completo

El Gate sólo puede declarar:

```text
E2 SESSION CUTOVER = PASS
```

cuando exista evidencia suficiente de que ninguna credencial pre-E2 relevante puede:

```text
1. obtener nuevos access tokens mediante refresh
OR
2. continuar siendo aceptada mediante un access token pre-E2 todavía no expirado
```

Debe cumplirse conceptualmente, cuando exista población pre-E2 relevante:

```text
pre-E2 refresh capability = NONE

AND

pre-E2 usable access-token tail = NONE
```

Mientras el cutover todavía no haya alcanzado su transición final:

```text
E2 SESSION CUTOVER = BLOCKED
```

Pero debe distinguirse:

```text
normal production-style E2 operation before cutover completion
=
NO
```

de:

```text
controlled activation of final E2 enforcement
inside the authorized cutover transition
while the temporary/continuity protection remains active
=
REQUIRED
```

Por tanto:

```text
CUTOVER PASS
```

NO es precondición para activar técnicamente el hook dentro del procedimiento controlado.

Al contrario:

```text
final E2 hook activation
+
verification of default-deny enforcement
+
verification of zero unprotected window
```

son precondiciones para:

```text
E2 SESSION CUTOVER = PASS
```

Debe quedar explícito:

```text
hook activation outside an authorized cutover transition
before cutover completion
=
PROHIBITED
```

pero:

```text
hook activation as the protected final transition step,
while prior cutover protection remains effective
=
REQUIRED
```

## 25.X.1A Invariante de no reemisión durante cutover

El cutover sólo es seguro si durante toda la transición final permanece garantizado:

```text
new pre-E2 initial session issuance = IMPOSSIBLE
```

La protección debe mantenerse hasta que:

```text
final E2 enforcement = ACTIVE AND VERIFIED
```

No termina únicamente cuando:

```text
JWT tail = closed
```

Debe cumplirse, sin hueco:

```text
absence/freeze protection
→ continuous protection
→ E2 hook activation
→ E2 hook verification
```

Debe distinguirse:

```text
public signup disabled
!=
existing-user sign-in disabled
```

Deshabilitar signup público NO constituye por sí mismo un freeze suficiente.

También debe distinguirse:

```text
application UI disabled
!=
Supabase Auth initial-session issuance disabled
```

Ocultar o bloquear la UI de la aplicación NO constituye un control suficiente si las superficies Auth externas siguen pudiendo emitir una sesión.

La protección debe cubrir cualquier initial-auth path que pueda producir una nueva sesión pre-E2 relevante.

Como mínimo debe considerarse el conjunto de métodos que E2 finalmente mantendrá bajo deny:

```text
password fuera del path E2
otp
totp
magiclink
recovery
invite
email/signup
email_change
oauth
oauth_provider
authorization_code
oauth_provider/authorization_code
sso/saml
anonymous
unknown / newly introduced methods
```

El objetivo no es necesariamente deshabilitar cada API individual mediante un switch específico.

El requisito normativo es:

```text
while final cutover transition is in progress:

no new session that bypasses E2
may become usable
```

### 25.X.2 Alternativa A — ausencia demostrada + transición zero-window

Puede utilizarse una ruta sin invalidación de sesiones únicamente si existe evidencia suficiente y verificable de que:

```text
no relevant pre-E2 sessions exist
AND
no relevant usable pre-E2 access tokens exist
```

Pero:

```text
absence proof at t0
!=
permanent absence until E2 activation
```

La prueba de ausencia NO es suficiente por sí sola.

Entre:

```text
final absence verification
```

y:

```text
final E2 enforcement active and verified
```

debe existir:

```text
ZERO UNPROTECTED WINDOW
```

La Alternativa A sólo puede completar el cutover mediante una de estas dos subrutas.

#### A1 — imposibilidad demostrada de nueva emisión

Puede utilizarse A1 si existe evidencia oficial y verificable de que durante toda la transición:

```text
new pre-E2 initial-session issuance = IMPOSSIBLE
```

sin necesidad de introducir un freeze temporal adicional.

Debe demostrarse que la propiedad aplica a TODAS las superficies relevantes de Auth y no únicamente:

- UI de aplicación;
- public signup;
- una ruta concreta de frontend.

La secuencia es:

```text
1. verify absence of relevant pre-E2 sessions
2. verify absence of relevant usable pre-E2 access tokens
3. verify no new pre-E2 initial-session issuance can occur
4. activate final E2 hook enforcement
5. verify final E2 default-deny
6. verify no initial-auth bypass exists
7. declare E2 SESSION CUTOVER = PASS
```

Si la imposibilidad de nueva emisión no puede demostrarse:

```text
A1 = NOT AVAILABLE
```

#### A2 — freeze protegido

Si la ausencia inicial puede demostrarse pero nuevas sesiones podrían nacer antes de activar E2, debe aplicarse un freeze soportado.

La secuencia es:

```text
1. identify supported issuance-freeze mechanism
2. obtain separate authorization when required
3. activate freeze
4. verify:
   new pre-E2 initial-session issuance = IMPOSSIBLE
5. re-run/finalize absence verification
6. verify:
   relevant pre-E2 sessions = NONE
7. verify:
   relevant usable pre-E2 access tokens = NONE
8. activate final E2 hook while freeze remains active
9. verify E2 default-deny
10. verify zero unprotected transition window
11. remove temporary freeze only if safe
12. verify removal does not reopen bypass
13. declare E2 SESSION CUTOVER = PASS
```

La prueba de ausencia debe realizarse o ratificarse:

```text
AFTER freeze activation
```

cuando A2 sea necesaria.

No utilizar una prueba previa al freeze como evidencia final.

#### Alternativa A blocker

Si:

```text
new session issuance can occur
```

y no existe una forma oficialmente soportada de impedirlo durante la transición:

```text
BLOCKER — ALTERNATIVE A ZERO-WINDOW CUTOVER UNAVAILABLE
```

DETENER.

No declarar cutover PASS.

No asumir:

```text
public signup disabled
=
existing-user login impossible
```

No asumir:

```text
no sessions found now
=
no sessions can exist before hook activation
```

### 25.X.3 Alternativa B — invalidación + JWT tail

Si existen o pueden haber existido sesiones pre-E2 relevantes, debe utilizarse un mecanismo oficialmente soportado para terminar/revocar esas sesiones.

Ese mecanismo:

- debe verificarse contra documentación oficial vigente;
- debe tener scope entendido;
- no debe depender de internals no soportados;
- requiere autorización humana separada antes de ejecutarse;
- debe verificarse después de aplicarse.

Pero:

```text
session/refresh invalidation completed
!=
cutover completed
```

Después de revocar/terminar las sesiones pre-E2, debe cerrarse además el tail de access tokens ya emitidos.

## 25.X.3A Pre-E2 initial-session issuance freeze

Cuando se utilice la ruta de invalidación + JWT tail, ANTES de definir:

```text
T_revoke
```

debe existir un mecanismo oficialmente soportado y verificable que impida emitir nuevas sesiones pre-E2 relevantes durante todo el cutover.

Debe cumplirse:

```text
cutover freeze active = YES
```

antes de iniciar la invalidación.

El mecanismo debe:

- pertenecer a una superficie oficialmente soportada;
- ser verificable en Supabase Development;
- tener scope y efectos conocidos;
- no depender de internals no soportados;
- no ser simplemente un bloqueo UI;
- no depender de cooperación del browser;
- impedir efectivamente que nazca una nueva sesión que evite E2;
- requerir autorización humana separada si modifica Supabase Cloud.

TASK-013 NO fija anticipadamente cuál será ese mecanismo.

Antes de utilizarlo debe existir evidencia oficial de que satisface el requisito.

La `Alternative B freeze` y la `Alternative A2 freeze` persiguen la misma propiedad:

```text
no new excluded pre-E2 session
may be issued before final E2 enforcement
is active and verified
```

No es obligatorio que el mecanismo físico sea el mismo.

TASK-013 no selecciona el mecanismo.

Si no existe un mecanismo soportado que garantice:

```text
new pre-E2 initial session issuance = IMPOSSIBLE
```

entonces:

```text
BLOCKER — PRE-E2 SESSION ISSUANCE FREEZE UNAVAILABLE
```

DETENER.

No continuar con invalidación.

No comenzar el JWT tail.

No activar parcialmente E2 por aproximación.

### 25.X.4 Canonical pre-E2 JWT maximum lifetime

Antes de realizar la invalidación debe verificarse mediante superficie oficial de Development:

```text
maximum access-token lifetime
that may apply to any still-usable pre-E2 JWT
```

No asumir:

```text
1 hour
```

No utilizar:

- default documentado como sustituto de configuración real;
- una constante inventada;
- únicamente el valor actual si existe evidencia de que una configuración anterior pudo emitir tokens con vida mayor.

La duración utilizada para el cutover debe ser un upper bound verificable sobre cualquier access token pre-E2 que razonablemente pudiera seguir existiendo.

Si hubo un cambio previo de JWT expiry, debe considerarse la configuración histórica aplicable a tokens ya emitidos.

Si no puede obtenerse un upper bound seguro:

```text
BLOCKER — PRE-E2 JWT MAXIMUM LIFETIME UNKNOWN
```

DETENER.

No activar E2.

### 25.X.5 Tail temporal

Sea:

```text
T_revoke =
instante autoritativo en que terminó la invalidación soportada
de las sesiones pre-E2 relevantes
```

y:

```text
JWT_preE2_max_lifetime =
upper bound verificado de lifetime
de cualquier access token pre-E2 potencialmente todavía válido
```

El cutover temporal no puede declararse completo antes de un instante que garantice:

```text
every access token issued before or at T_revoke
that belongs to the excluded pre-E2 population
must have reached exp
```

Como baseline conservadora, cuando no exista un mecanismo soportado más fuerte:

```text
cutover not-before
=
T_revoke + JWT_preE2_max_lifetime
```

sujeto a cualquier consideración adicional de clock/validation oficialmente documentada que resulte aplicable.

No hardcodear una duración en TASK-013.

El valor debe derivarse de la configuración real verificada.

Durante toda la ventana:

```text
T_revoke
→
JWT tail closure
```

debe permanecer:

```text
cutover freeze active = YES
```

No puede existir un intervalo donde:

```text
old sessions were revoked
BUT
new pre-E2 session issuance is possible
```

La condición:

```text
cutover not-before
=
T_revoke + JWT_preE2_max_lifetime
```

sólo es válida si:

```text
no new excluded pre-E2 access token
can be issued after T_revoke
```

mientras se espera el tail.

Si el freeze se pierde o no puede demostrarse durante la ventana:

```text
CUTOVER EVIDENCE INVALIDATED
```

y:

```text
BLOCKER
```

No reutilizar automáticamente el `T_revoke` anterior como base del cálculo.

Debe reevaluarse el cutover desde un estado seguro.

### 25.X.6 Mecanismo oficial equivalente

Si Supabase dispone de un mecanismo oficialmente soportado que pueda demostrar de forma inmediata una garantía equivalente a:

```text
pre-E2 access token can no longer be accepted
```

podrá proponerse en lugar de esperar el tail temporal.

Pero esa alternativa:

```text
REQUIRES REVIEW
```

antes de utilizarse.

TASK-013 no inventa en esta especificación:

- session-id introspection global obligatoria;
- denylist JWT propia;
- custom JWT revocation service;
- tenant-side token blacklist;
- microservice de revocación.

Cualquiera de esas alternativas sería una ampliación arquitectónica que requiere revisión previa.

### 25.X.7 Invariante general de transición zero-window

TODAS las rutas de cutover deben satisfacer:

```text
last trustworthy pre-E2 state verification
→
continuous protection against new pre-E2 session issuance
→
final E2 hook activation
→
final E2 hook verification
→
release of temporary protection, if any
```

sin ningún intervalo donde:

```text
pre-E2 session issuance = POSSIBLE
AND
final E2 enforcement = NOT VERIFIED
```

Debe ser imposible:

```text
absence proof
→ unprotected gap
→ hook activation
```

Debe ser imposible:

```text
freeze removed
→ unprotected gap
→ hook activation
```

Debe ser imposible:

```text
JWT tail closed
→ unprotected gap
→ hook activation
```

El principio normativo común es:

```text
AT EVERY MOMENT DURING FINAL CUTOVER TRANSITION:

temporary/structural pre-E2 issuance protection = ACTIVE

OR

final E2 enforcement = ACTIVE AND VERIFIED
```

No puede existir un momento donde ambas sean falsas.

#### Ruta A1

```text
absence
+
structural/officially demonstrated impossibility of new issuance
→
activate E2
→
verify E2
→
PASS
```

#### Ruta A2

```text
freeze
→
final absence verification
→
activate E2 while freeze remains active
→
verify E2
→
remove freeze
→
verify no bypass
→
PASS
```

#### Ruta B

Mantiene la secuencia:

```text
freeze
→
revoke historical sessions
→
close refresh capability
→
close JWT tail
→
activate E2 while freeze remains active
→
verify E2
→
remove freeze
→
verify no bypass
→
PASS
```

En las tres rutas:

```text
PASS
```

es el resultado FINAL, nunca la precondición de la activación controlada del enforcement.

### 25.X.8 Regla después del cutover

Sólo después de:

```text
E2 SESSION CUTOVER = PASS
```

puede aplicarse:

```text
authentication_method = token_refresh
→ lifecycle continuation allowed
```

La ruta utilizada debe haber demostrado:

```text
no excluded pre-E2 refresh capability

AND

no excluded usable pre-E2 access-token tail, when applicable

AND

no pre-E2 session re-issuance race

AND

zero unprotected transition window

AND

final E2 hook enforcement = ACTIVE AND VERIFIED
```

No se obliga a una ruta con JWT-tail si Alternativa A ha demostrado legítimamente que nunca existió población pre-E2 relevante.

Entonces:

1. ninguna sesión pre-E2 excluida conserva capacidad de refresh cuando ese requisito resulte aplicable;
2. ningún access token pre-E2 excluido continúa dentro de su ventana válida cuando haya existido población histórica aplicable;
3. no existió carrera de reemisión pre-E2 entre la última evidencia válida y el enforcement final;
4. todos los nuevos initial authentication methods distintos del password path E2 permanecen denied;
5. futuros `token_refresh` pertenecen operacionalmente a sesiones creadas después del cutover mediante paths autorizados.

`token_refresh`:

- no consume nuevo SessionGrant;
- no consume nuevo VerificationChallenge;
- no constituye initial authentication;
- sólo puede permitirse después del cutover completo.

### 25.X.9 Drift posterior

Si después del cutover se descubre evidencia de:

```text
refreshable pre-E2 session
```

o:

```text
still-usable pre-E2 access token
```

entonces:

```text
SECURITY DRIFT
→ BLOCKER
```

No continuar deliberadamente como si esa credential fuese E2-compliant.

---

# 26. Binding inicial del Auth subject

## 26.1 Caso ya vinculado

Si:

```text
bridge.auth_user_id = event.user_id
```

puede continuar si el grant es válido.

Cualquier mismatch:

```text
DENY
```

## 26.2 Caso no vinculado

Sólo puede vincularse si simultáneamente:

```text
bridge.auth_user_id IS NULL
AND
grant.auth_user_id IS NULL
AND
event.authentication_method = password
AND
event.claims.email matches bridge.email
AND
grant belongs to bridge
AND
grant is valid
```

Entonces, dentro de la misma transición de consumo:

```text
bridge.auth_user_id = event.user_id
grant.auth_user_id = event.user_id
bridge.bound_at = server time
grant.consumed_at = server time
```

Debe existir uniqueness de `auth_user_id` entre bridge credentials.

Si la correlación no es inequívoca:

```text
DENY
```

## 26.3 Email normalization

TASK-013 no crea una nueva política global de normalización de email.

Durante implementación se debe verificar que el email provider-visible utilizado por la aplicación y `event.claims.email` se correlacionan de forma estable.

Una discrepancia:

```text
DENY / BLOCKER
```

No se resuelve debilitando la comparación.

---

# 27. Permisos DB y `supabase_auth_admin`

## 27.1 Platform tables

Las cuatro tablas son platform-owned y deben:

```text
ENABLE RLS
```

No porque pertenezcan a un tenant, sino como defense-in-depth para negar Data API general.

Debe quedar:

```text
anon = no direct CRUD
authenticated = no direct CRUD
PUBLIC = no direct CRUD
```

No crear policies tenant artificiales.

## 27.2 `service_role` / secret backend role

Aunque una backend secret pueda actuar con privilegio elevado:

```text
secret key
!=
ordinary request client
```

TASK-013 debe revocar/evitar acceso directo a las tablas desde la superficie purpose-specific cuando sea viable y exponer únicamente las funciones necesarias.

El módulo no exporta un raw privileged client.

## 27.3 Purpose-specific DB functions

Las mutations de challenge/grant deben ocurrir mediante funciones estrechas equivalentes a:

```text
issue_verification_challenge
resend_verification_challenge
verify_verification_challenge
```

y helpers estrictamente necesarios.

La lectura del verifier necesaria para §16.1 debe realizarse mediante una primitive igualmente estrecha que entregue únicamente verifier y key version al boundary server-side autorizado.

No constituyen API pública.

La ejecución debe limitarse a la role server-side aprobada.

## 27.4 `supabase_auth_admin` y modelo invoker de mínimo privilegio

El Custom Access Token Hook debe usar por defecto:

```text
SECURITY INVOKER
```

No:

```text
SECURITY DEFINER
```

como preferencia.

`supabase_auth_admin` debe recibir únicamente las capabilities explícitas requeridas por el hook.

Como mínimo debe evaluarse y limitarse a:

```text
USAGE
sobre el schema estrictamente necesario

EXECUTE
sobre el Custom Access Token Hook

SELECT
sólo sobre columnas estrictamente necesarias de auth_session_grants

UPDATE
sólo sobre columnas estrictamente necesarias para consumir/vincular auth_session_grants

SELECT
sólo sobre columnas estrictamente necesarias de auth_bridge_credentials

UPDATE
sólo sobre columnas estrictamente necesarias para binding del Auth subject
```

Cuando PostgreSQL permita reducir privilegios por columna sin impedir el hook, debe preferirse esa reducción.

El hook NO necesita acceso ordinario a:

```text
verification_challenges
verification_challenge_attempts
tenant-owned tables
company_memberships
user_client_access
support_access_grants
maintenance data
```

Debe permanecer:

```text
supabase_auth_admin tenant privileges = NO
```

### RLS

Las tablas permanecen con RLS enabled.

Las policies para `supabase_auth_admin` deben existir sólo en la medida necesaria para que el hook invoker opere sobre su estado platform-owned.

Para `auth_session_grants`, las policies deben restringir, como mínimo, la superficie al propósito previsto:

```text
purpose = initial_session
auth_method = password
```

No crear una policy general que convierta `supabase_auth_admin` en tenant bypass.

Los grants efectivos y las policies deben ser inspeccionables por tests.

## 27.5 Desviación `SECURITY DEFINER`

`SECURITY DEFINER` NO forma parte del diseño base de TASK-013.

Sólo puede considerarse si durante implementación aparece una necesidad técnica concreta que demuestre que:

```text
SECURITY INVOKER
+
explicit grants
+
RLS mínimo
```

no puede implementar E2 de forma correcta y segura.

En ese caso:

```text
BLOCKER — SECURITY DEFINER DEVIATION REQUIRES REVIEW
```

DETENER.

No implementar la desviación automáticamente.

La revisión deberá documentar:

- capacidad exacta que invoker no puede satisfacer;
- por qué los grants mínimos no resuelven el caso;
- owner de la función;
- `search_path`;
- superficie EXECUTE;
- privilege escalation analysis;
- RLS impact;
- tenant impact;
- tests negativos.

Sólo una aprobación de seguridad posterior puede autorizar esa desviación.

---

# 28. Configuración privada

## 28.1 Ownership

Código de lectura/validación:

```text
src/infrastructure/config/
```

con entrypoint estrictamente server-only, separado del contrato público de Supabase.

## 28.2 Variables previstas

Nombres semánticos esperados:

```text
SUPABASE_SECRET_KEY

AUTH_CHALLENGE_HMAC_ACTIVE_VERSION
AUTH_CHALLENGE_HMAC_KEY_V1

AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION
AUTH_TECHNICAL_PASSWORD_KEY_V1
```

Semántica obligatoria:

```text
AUTH_CHALLENGE_HMAC_ACTIVE_VERSION
=
identifier / selector

AUTH_CHALLENGE_HMAC_KEY_V1
=
secret key material

AUTH_TECHNICAL_PASSWORD_ACTIVE_VERSION
=
identifier / selector

AUTH_TECHNICAL_PASSWORD_KEY_V1
=
secret key material
```

Debe mantenerse:

```text
active version
!=
key
```

Si el repositorio real ya posee una convención equivalente, puede adaptarse el naming sin cambiar la separación conceptual.

No crear un registry genérico de secretos.

## 28.3 Clasificación

| Variable | Exposición | Sensibilidad | Uso |
| --- | --- | --- | --- |
| `SUPABASE_SECRET_KEY` | server-only | SECRETO | Auth Admin purpose-specific |
| challenge active version | server-only | no secreto por sí mismo | seleccionar key |
| challenge key | server-only | SECRETO | HMAC business challenge |
| technical password active version | server-only | no secreto por sí mismo | seleccionar key |
| technical password key | server-only | SECRETO | derivación technical password |

Ninguna usa:

```text
NEXT_PUBLIC_
```

## 28.4 `.env.example`

Puede incorporar exclusivamente:

- nombres;
- placeholders inequívocamente ficticios;
- comentarios mínimos de server-only;
- sin formatos que parezcan credenciales reales.

Nunca valores reales.

## 28.5 Archivos reales

Los secretos reales permanecen en configuración local/no versionada según TASK-004.

TASK-013 no modifica la política `.gitignore` salvo que una contradicción real obligue a revisión.

---

# 29. Configuración `supabase/config.toml`

## 29.1 Public signup

La baseline local histórica mostraba:

```text
auth.enable_signup = true
auth.email.enable_signup = true
```

E2 exige:

```text
public signup = disabled
```

La implementación debe modificar las opciones oficiales vigentes necesarias para que el entorno local represente esa política.

Debe verificarse contra la versión real de Supabase CLI antes de editar.

## 29.2 Custom Access Token Hook

Debe configurarse localmente el hook Postgres mediante la syntax oficial vigente equivalente a:

```text
auth.hook.custom_access_token
enabled = true
uri = pg-functions://...
```

El nombre físico final debe ser el de la función versionada por la migration.

## 29.3 Provider OTP

TASK-013 NO utiliza provider Email OTP como business challenge.

Por tanto:

```text
auth.email.otp_expiry
```

no se cambia a 8 horas para “cumplir” RF-005.

Los 8h son autoridad de `verification_challenges`.

No intentar satisfacer RF-006/RF-009 mediante provider OTP/rate limits.

---

# 30. Supabase Cloud Development

Cambios en Cloud requieren autorización humana separada.

TASK-013 no puede aplicarlos silenciosamente como parte de una ejecución Codex ordinaria.

Antes de declarar TASK-013 completamente implementada deberá verificarse en Development:

```text
canonical password policy verified = YES

cutover route selected =
A1 | A2 | B

zero unprotected transition window verified = YES

final E2 hook enforcement = ACTIVE AND VERIFIED

public signup disabled = YES

Custom Access Token Hook configured = YES

hook points to expected Postgres function = YES

hook errors deny JWT issuance = YES

authentication_method=password observed as expected = YES

authentication_method=token_refresh distinguishable = YES

Require current password when changing password = ENABLED

public OTP/Magic Link/recovery/etc initial JWT tests = DENIED
```

Para A1 debe verificarse:

```text
absence proof = PASS
new pre-E2 session issuance structurally impossible = YES
final E2 hook enforcement = ACTIVE AND VERIFIED
```

Para A2 debe verificarse:

```text
freeze = ACTIVE before final absence proof
final absence proof = PASS
hook activated while freeze active = YES
freeze removed only after E2 verification = YES
post-removal bypass test = PASS
```

Para B deben mantenerse además:

```text
historical session invalidation = VERIFIED
pre-E2 refresh capability eliminated = YES
maximum applicable pre-E2 JWT lifetime verified = YES
pre-E2 access-token validity tail closed = YES
cutover freeze continuity verified = YES
hook activated while freeze active = YES
post-removal bypass test = PASS
```

Debe quedar explícito:

```text
E2 SESSION CUTOVER = PASS
```

sólo después de verificar el enforcement final.

La configuración:

```text
Require current password when changing password
```

es security-critical.

Si no puede verificarse mediante la superficie Hosted oficial:

```text
BLOCKER
```

No asumirla.

Debe quedar expresamente:

```text
hook activation
without password-policy verification
=
BLOCKER
```

Y, para cualquier ruta:

```text
cutover completion
without zero-window protection
=
BLOCKER
```

Para A2/B:

```text
public signup disabled
=
INSUFFICIENT AS CUTOVER FREEZE
```

Y:

```text
application UI blocked
=
INSUFFICIENT AS CUTOVER FREEZE
```

No seleccionar ni ejecutar el mecanismo Cloud dentro de esta especificación.

No cambiar silenciosamente password policy.

No ejecutar invalidación de sesiones sin autorización Cloud separada.

No requiere que exista un granular switch passwordless-only.

E2 debe continuar siendo seguro aunque endpoints passwordless puedan recibir requests, porque su JWT issuance queda denied por el hook una vez que el enforcement final E2 se encuentra activo y verificado.

Staging y Production:

```text
NO CHANGE
```

# 31. Password mutation

El usuario no conoce la technical password.

Debe verificarse que el entorno Hosted requiera la password actual al cambiar password.

Consecuencia prevista:

```text
authenticated user
+
no technical password
→ cannot replace technical bridge password
```

TASK-013 no implementa password-change UX.

Si la plataforma real permite al usuario sustituir la password sin conocer la credential técnica y no existe otro control aprobado equivalente:

```text
BLOCKER
```

No introducir un fallback passwordless.

---

# 32. Failure model

Toda la foundation es:

```text
fail closed
```

## 32.1 Verification wrong code

Intento efectivo:

```text
attempt_count += 1 exactly once
```

El tercer fallo:

```text
exhausted_at = now
```

No existe cuarto intento efectivo.

## 32.2 Verify retry tras response perdida

Mismo:

```text
verification_operation_id
```

reconcilia el intento anterior.

No consume otro intento.

Si el intento anterior fue success:

- challenge permanece consumed;
- se devuelve/reconcilia el mismo grant lógico;
- no se crea otro.

## 32.3 Concurrent verify

Dos operation IDs distintos:

- serializados por row lock/conditional transition;
- nunca superan attempt budget;
- como máximo uno puede consumir.

## 32.4 Verify vs resend

La DB define un orden serializable mediante lock/transacción.

Sólo uno puede ganar sobre el mismo estado active.

Si resend gana:

```text
old challenge verify = DENY
```

Si consume gana antes:

```text
resend of consumed challenge = DENY
```

No permitir ambos efectos incompatibles.

## 32.5 Concurrent resend

Máximo un successor directo.

No dos active successors.

## 32.6 Challenge consume + grant creation

Deben ocurrir en la misma transacción.

No existe:

```text
challenge consumed
+
grant creation silently omitted
```

por commit parcial dentro de DB.

## 32.7 Challenge consumed + Auth provisioning fail

El challenge permanece consumed.

El grant puede permanecer hasta expiry o ser revocado.

No reactivar challenge.

Una nueva interacción puede requerir una nueva emisión.

## 32.8 `createUser` response lost

No repetir creación ciegamente.

Retry:

1. intentar technical `signInWithPassword`;
2. si demuestra la identidad esperada, reconciliar;
3. si no, evaluar una única create intent compatible;
4. duplicate/incompatible state → repair required.

No Admin enumeration genérica.

## 32.9 Hook consumes grant + Auth response lost

El grant permanece consumed.

No reactivarlo.

Si la aplicación no puede demostrar entrega de tokens:

```text
fail closed
```

Un nuevo intento inicial requiere nueva autorización/grant según el flow futuro.

## 32.10 Hook timeout/error

Auth request falla.

No asumir:

```text
timeout = no effect
```

Reconciliar estado DB.

Si no es inequívoco:

```text
DENY
```

## 32.11 Wrong Auth method

Incluso con un grant activo:

```text
OTP / TOTP / magiclink / recovery / email_change / oauth / anonymous / unsupported
→ DENY
```

## 32.12 Grant race

```text
same grant
+
two password sign-ins
→ one consume max
→ other deny
```

## 32.13 Rotation failure

No fallback.

Pending rotation:

```text
fail closed
```

Debe cubrirse además:

```text
persisted key version exists
BUT
corresponding server-only secret key material unavailable
→ fail closed
```

y:

```text
key version identifier accidentally treated as secret key material
→ implementation/spec violation
→ BLOCKER
```

No existe fallback a otra versión ni al active-version selector.

## 32.14 DB unavailable

No JWT inicial autorizado por la aplicación.

El hook falla closed.

## 32.15 Password policy mismatch

Si:

```text
derived technical password
```

no puede demostrarse compatible con la policy canónica:

```text
DENY / BLOCKER
```

No retry probabilístico.

No modificar la policy automáticamente.

## 32.16 Constant-time comparison unavailable

Si el runtime aprobado no proporciona una primitive constant-time adecuada para fixed-length digest comparison:

```text
BLOCKER
```

No degradar a igualdad ordinaria.

## 32.17 Pre-E2 cutover incomplete or unprotected

El Gate permanece `BLOCKER` si la ruta elegida no demuestra:

```text
final E2 enforcement = ACTIVE AND VERIFIED
```

y:

```text
zero unprotected transition window = YES
```

Para cualquier ruta, si puede ocurrir:

```text
new pre-E2 session issuance
```

entre la última evidencia válida de estado pre-E2 y la activación/verificación de E2:

```text
CUTOVER = NOT COMPLETE
```

Para Alternativa A, si existe una carrera entre:

```text
absence proof
```

y:

```text
E2 activation
```

y no puede eliminarse mediante garantía soportada o freeze:

```text
BLOCKER — ALTERNATIVE A ZERO-WINDOW CUTOVER UNAVAILABLE
```

Para Alternativa B conserva:

```text
BLOCKER — PRE-E2 SESSION ISSUANCE FREEZE UNAVAILABLE
```

cuando no pueda mantenerse el freeze.

Conserva además:

```text
BLOCKER — PRE-E2 JWT MAXIMUM LIFETIME UNKNOWN
```

cuando corresponda a la Ruta B.

No confundir blockers específicos de B con requisitos obligatorios de A cuando no existió población histórica.

# 33. Threat model

| Riesgo | Control obligatorio |
| --- | --- |
| brute force de código | 3 intentos exactos por emisión |
| offline cracking de DB | keyed HMAC, key fuera de DB |
| challenge replay | consumed terminal |
| expired replay | server clock + 8h |
| old code after resend | predecessor terminal |
| concurrent fourth attempt | atomic attempt transition |
| duplicate attempt via retry | operation id persistence |
| duplicate resend | issue operation id + one successor |
| double consume | row lock/atomic transition |
| browser DB enumeration | no direct CRUD |
| email enumeration | generic outcomes |
| code leakage | no plaintext persistence/logs |
| secret leakage | private config isolation |
| grant theft | no browser bearer + technical password still required |
| wrong password flow | hook + active grant |
| magiclink/OTP bypass | hook default deny |
| recovery bypass | hook default deny |
| OAuth/anonymous bypass | hook default deny |
| signup bypass | signup disabled + hook |
| generic Admin abuse | closed purpose-specific operations |
| secret-key client abuse | no generic export |
| `supabase_auth_admin` tenant access | no tenant grants |
| session claim authorization | ADR-0003/current DB auth remains authoritative |
| stale membership | TASK-012/current DB resolution |
| technical-key compromise | grant still required; rotate/contain |
| combined key+grant authority compromise | trust-boundary compromise, incident response required |
| hook outage | fail closed |
| password mutation | current technical password required |
| timing oracle sobre verifier | fixed-length HMAC + constant-time runtime comparison |
| technical password incompatible con provider policy | canonical policy verification + deterministic policy-satisfying encoder |
| policy drift | blocker + explicit rotation/review |
| pre-E2 session/access-token bypass | mandatory refresh revocation/absence proof + closure of residual pre-E2 JWT validity tail before E2 activation |
| false assumption that sign-out instantly revokes JWT | distinguish refresh revocation from access-token `exp`; verify actual pre-E2 JWT maximum lifetime |
| new pre-E2 session issued during JWT tail | supported cutover freeze active before `T_revoke` and continuously maintained until final E2 enforcement is verified |
| gap between temporary freeze and final E2 enforcement | zero-unprotected-window transition; release freeze only after final hook default-deny is active and verified |
| session issuance race after clean-state proof | clean-state proof must be followed by continuous issuance protection until final E2 enforcement is active and verified |
| circular cutover dependency | controlled hook activation is a required step inside the protected cutover; CUTOVER PASS occurs only afterward |
| TOTP bypass | explicit hook deny + negative test |
| privilege escalation del hook | security invoker + explicit minimal grants + RLS |
| unjustified security-definer escalation | blocker + security review |

---

# 34. RLS, multitenancy y autorización

Debe permanecer:

```text
tenant = MaintenanceCompany
```

y:

```text
VerificationChallenge = platform-owned
VerificationChallengeAttempt = platform-owned technical state
AuthBridgeCredential = platform-owned technical state
SessionGrant = platform-owned
```

No existe:

```text
challenge tenant ownership
grant tenant ownership
```

Debe permanecer:

```text
authenticated != authorized
```

Debe permanecer:

```text
valid Auth session
!=
PlatformUser resolved
!=
current CompanyMembership
!=
tenant role
!=
Client scope
```

Debe permanecer:

```text
current authoritative state
>
stale session authorization state
```

Y:

```text
RLS tenant existente
=
primary remote isolation boundary
para datos tenant-owned
```

TASK-013 no modifica RLS de:

- `maintenance_companies`;
- `company_memberships`;
- client data;
- maintenance data.

`SUPER_ADMIN` continúa:

```text
global platform identity
!=
tenant member
!=
tenant bypass
```

---

# 35. Actor autorizado para issue/resend

RF-007 conserva:

```text
actor autorizado para el alta
```

TASK-013 no implementa todavía esa autorización funcional.

El canon contempla posteriormente, entre otros:

- primer `COMPANY_ADMIN` iniciado por `SUPER_ADMIN`;
- usuarios posteriores iniciados por `COMPANY_ADMIN` autorizado.

En esta foundation:

```text
functional issue authorization = OUT OF SCOPE

functional resend authorization = OUT OF SCOPE
```

Pero:

```text
browser direct DB mutation = PROHIBIDA
```

El futuro caso de uso debe:

1. resolver autorización actual;
2. sólo entonces invocar la purpose-specific server boundary.

TASK-013 no permite compensar la ausencia del caso de uso mediante:

```text
anon → INSERT
authenticated → INSERT
authenticated → UPDATE
```

---

# 36. AuditEvent

TASK-010 ya existe como foundation.

TASK-013:

```text
AuditEvent producer = NO
```

No anticipa events funcionales.

Los futuros flujos de:

- issue;
- resend;
- verification;
- provisioning;
- rotation;
- repair;

deberán determinar sus obligaciones de auditoría al implementar el caso de uso funcional.

No añadir productores sólo para ampliar este slice.

---

# 37. UI

```text
NO APLICA
```

No crear:

- páginas;
- formularios;
- components;
- routes funcionales;
- password field;
- OTP field;
- resend button;
- onboarding UI.

Tests a nivel de foundation.

---

# 38. Offline

```text
NO APLICA / FUERA DE ALCANCE
```

No crear:

- Dexie schema;
- outbox;
- local Auth authority;
- offline verification;
- cached grants;
- cached technical credentials.

El challenge necesita autoridad online.

ADR-0004 permanece fuera de scope.

---

# 39. Migration

## 39.1 Cantidad

Objetivo:

```text
1 migration funcional
```

Sufijo semántico equivalente:

```text
task_013_verification_challenge_foundation
```

Timestamp real durante ejecución.

## 39.2 Contenido autorizado

La migration puede contener exclusivamente:

- `verification_challenges`;
- `verification_challenge_attempts`;
- `auth_bridge_credentials`;
- `auth_session_grants`;
- PK/FK;
- checks;
- uniqueness;
- índices necesarios;
- RLS enablement;
- grants/revokes mínimos;
- policies mínimas para el hook invoker sobre estado platform-owned;
- purpose-specific transition functions;
- Custom Access Token Hook Postgres Function;
- helpers internos estrictamente necesarios.

## 39.3 No autorizado

No incluir:

- product tables adicionales;
- tenant migrations;
- changes TASK-009/010 no necesarios;
- audit producers;
- triggers de negocio generales;
- custom claims tenant;
- generalized authorization helpers;
- email sending;
- provider OTP tables;
- microservices.

Si se demuestra necesaria una segunda migration por una limitación material:

```text
BLOCKER
→ revisión de scope
```

No dividir por preferencia.

---

# 40. Índices mínimos

Sólo índices justificados por invariantes/queries del slice.

Como mínimo evaluar:

### `verification_challenges`

- PK `id`;
- unique `issue_operation_id`;
- unique no-null `supersedes_challenge_id` para un successor por predecessor;
- índice estrictamente necesario para búsqueda server-side si la implementación lo demuestra.

### `verification_challenge_attempts`

- PK;
- unique `operation_id`;
- unique `(challenge_id, attempt_number)`;
- FK index si PostgreSQL/query plan lo requiere.

### `auth_bridge_credentials`

- PK;
- unique `email`;
- unique nullable `auth_user_id`;
- unique nullable `rotation_operation_id`.

### `auth_session_grants`

- PK;
- unique `challenge_id`;
- unique `grant_operation_id`;
- índice por `auth_bridge_credential_id`;
- enforcement de un solo grant unconsumed/unrevoked por bridge.

No añadir índices “por si acaso”.

---

# 41. Constraints mínimos

Debe impedir físicamente, cuando sea expresable mediante constraints:

- `attempt_count < 0`;
- `attempt_count > 3`;
- verifier HMAC con longitud distinta de 32 bytes;
- expiry distinta de 8h;
- `attempt_number` fuera de `1..3`;
- dos attempt rows para el mismo número;
- retry op duplicada;
- self-supersede;
- dos successors directos;
- más de una terminalidad persistida incompatible;
- exhausted con menos de 3 attempts;
- grant purpose distinto de `initial_session`;
- grant auth method distinto de `password`;
- grant expiry distinta de 5 min;
- grant challenge duplicado;
- bridge Auth subject duplicado;
- empty/invalid key version identifiers según contrato tipado.

Los invariantes cross-row que no puedan expresarse limpiamente como CHECK deben vivir exclusivamente en las purpose-specific transactional functions y tener tests concurrentes.

---

# 42. Boundary de aplicación

El código debe vivir bajo:

```text
src/modules/identity-authorization/
```

sin crear otro bounded context.

Estructura conceptual esperada:

```text
src/modules/identity-authorization/
  application/
  infrastructure/
    crypto/
    supabase/
  server.ts
```

Nombres equivalentes pueden adaptarse a convenciones reales sin alterar responsabilidades.

---

# 43. Responsabilidades TypeScript esperadas

## 43.1 Application contracts

Responsabilidades equivalentes a:

```text
verification-challenge
auth-session-bridge
```

Deben definir:

- inputs server-side;
- outcomes;
- error mapping fail-closed;
- operation IDs;
- no Supabase-specific type leakage en contracts públicos cuando no sea necesario.

## 43.2 Crypto

Responsabilidades equivalentes a:

```text
challenge-verifier
technical-password
```

Deben:

- usar Node crypto existente;
- usar comparación constant-time aprobada para verifiers fixed-length;
- leer únicamente config privada;
- no loguear inputs/outputs;
- producir test vectors deterministas;
- mantener key separation;
- validar determinísticamente compatibilidad con la password policy canónica verificada.

## 43.3 Supabase challenge store

Adapter específico que:

- llama únicamente a purpose-specific RPCs;
- obtiene verifier/key-version sólo mediante la primitive estrecha definida para la comparación server-side;
- no exporta raw privileged client;
- no hace generic `.from(...)` sobre tablas arbitrarias;
- no implementa autorización tenant.

## 43.4 Auth Admin boundary

Adapter cerrado a:

```text
createUser
updateUserById
```

No reexporta:

```text
auth.admin
```

## 43.5 Technical sign-in

Debe utilizar una client boundary no privilegiada/publishable, server-side.

No reutilizar la secret-key Admin client para sign-in ordinario.

## 43.6 `server.ts`

Puede exponer sólo las capabilities server-side mínimas necesarias.

Nunca exportar secrets, keys o raw clients.

No crear client entrypoint para challenge internals.

---

# 44. Configuración común

La configuración privada transversal debe permanecer bajo:

```text
src/infrastructure/config/
```

No crear:

```text
shared/env
shared/secrets
generic config registry
```

La superficie privada no puede ser importable desde browser/client-safe code.

Tests estáticos/import-boundary deben verificarlo cuando sea razonable con el tooling existente.

---

# 45. Dependencias

Expectativa:

```text
new npm dependencies = 0
```

Usar:

- Node crypto;
- `@supabase/supabase-js` existente;
- `@supabase/ssr` existente cuando corresponda;
- Vitest existente;
- Supabase CLI existente;
- PostgreSQL/Supabase existente.

Si una dependencia nueva parece necesaria:

```text
BLOCKER
```

antes de instalarla.

No añadir:

- crypto package alternativo;
- ORM;
- validation framework;
- queue;
- microservice SDK;
- auth framework adicional.

---

# 46. Tests DB obligatorios

Debe existir una suite dedicada bajo:

```text
supabase/tests/database/
```

que cubra al menos:

1. insert válido de challenge por boundary autorizada;
2. expiry exacta 8h;
3. attempt_count inicial 0;
4. intento 1 incorrecto;
5. intento 2 incorrecto;
6. intento 3 incorrecto → exhausted;
7. intento 4 imposible;
8. correcto en intento 1;
9. correcto en intento 2;
10. correcto en intento 3;
11. consumed replay;
12. expired replay;
13. exhausted replay;
14. invalidated replay;
15. attempts independientes por emisión;
16. resend produce identidad nueva;
17. resend invalida old;
18. old code tras resend;
19. retry mismo issue operation;
20. concurrent duplicate issue operation;
21. retry mismo verification operation;
22. concurrent verification operations;
23. concurrent third/fourth attempt;
24. double consume;
25. concurrent resend;
26. resend vs verify;
27. un successor máximo;
28. challenge/email mismatch;
29. terminal states imposibles rechazados;
30. plaintext code ausente;
31. anon direct CRUD denied;
32. authenticated direct CRUD denied;
33. challenge state no enumerable por Data API;
34. attempt state no enumerable;
35. bridge credential no enumerable;
36. grant no enumerable;
37. grant exact 5m;
38. grant single-use;
39. grant replay;
40. grant expired;
41. grant revoked;
42. one eligible grant per bridge;
43. password hook without grant denied;
44. password hook wrong user denied;
45. password hook wrong email/unbound correlation denied;
46. password hook valid grant consumes once;
47. concurrent hook consumes one;
48. `token_refresh` does not consume grant, después del cutover;
49. OTP denied;
50. TOTP initial auth denied;
51. magiclink denied;
52. recovery denied;
53. signup/invite denied;
54. email_change denied;
55. OAuth denied;
56. oauth_provider denied;
57. authorization_code denied;
58. anonymous denied;
59. unknown auth method denied;
60. `supabase_auth_admin` cannot access tenant data because of TASK-013 grants;
61. `supabase_auth_admin` has only expected hook execution/data privilege surface introduced by this task;
62. Custom Access Token Hook `SECURITY INVOKER = YES`;
63. `supabase_auth_admin` direct privileges equal the exact expected minimal set;
64. no generic anon/authenticated execute on privileged transitions;
65. existing TASK-009/TASK-010 DB suites remain passing.

Debe verificarse además:

```text
supabase_auth_admin tenant access introduced by TASK-013 = NO
```

No crear un test que espere `SECURITY DEFINER`.

Si la implementación intentara utilizarlo:

```text
test/spec mismatch → BLOCKER
```

Si el test framework real necesita dividir escenarios en varios archivos por claridad, puede hacerlo sin ampliar scope conceptual.

---

# 47. Tests TypeScript obligatorios

Debe existir coverage para:

1. challenge HMAC deterministic vector;
2. domain separation;
3. challenge key-version selection resolves the persisted version identifier to the corresponding server-only secret key material and never uses identifier bytes as the HMAC secret;
4. invalid/missing/unknown challenge key version or unavailable corresponding secret material → fail closed;
5. old challenge key retained during rotation;
6. stored digest length = 32 bytes;
7. candidate digest length = 32 bytes;
8. equal fixed-length digest → true;
9. different fixed-length digest → false;
10. corrupt-length stored verifier → fail closed;
11. code review/test demonstrates wrapper based on `crypto.timingSafeEqual` o primitive equivalente aprobada;
12. technical password deterministic seed vector uses server-only secret key material selected by `technical_password_key_version`, never the version identifier itself;
13. canonical password-policy fixture/contract is known and validated;
14. deterministic technical password output = YES;
15. minimum length satisfied = YES;
16. required lowercase satisfied = YES, if required;
17. required uppercase satisfied = YES, if required;
18. required digit satisfied = YES, if required;
19. required symbol satisfied = YES, if required;
20. unknown/unverifiable policy → blocker/config failure;
21. same bridge + same key version + same policy + same secret key material → same technical password;
22. challenge key != technical key;
23. technical password output no logs;
24. challenge code no logs;
25. config error does not echo secret;
26. private config not imported by client-safe code;
27. Auth Admin boundary exposes only approved methods;
28. no generic Admin client export;
29. technical sign-in uses nonprivileged semantics;
30. operation ID contract;
31. generic denial mapping;
32. no email/challenge enumeration through errors;
33. provider errors fail closed;
34. rotation pending state maps to deny/repair;
35. no actual network in unit tests unless an integration environment is separately authorized.

Los tests anteriores deben cubrir inequívocamente, sin aumentar el count conceptual:

### Challenge key-version resolution

```text
verifier_key_version = "v1"
+
challenge key registry/config contains:
v1 → secret_A
v2 → secret_B
```

Debe probarse:

```text
v1 selects secret_A
v2 selects secret_B

version identifier bytes themselves
are NOT used as HMAC secret

unknown challenge key version
→ fail closed
```

### Technical-password key-version resolution

Debe probarse:

```text
technical_password_key_version = "v1"
→ selects technical-password secret key v1

same bridge id
+ same key version
+ same policy
+ same secret key material
→ same technical password

different secret key material
→ different seed

unknown technical-password key version
→ fail closed
```

No utilizar secretos reales en fixtures.

No realizar timing microbenchmark como criterio normativo.

No secret real en fixtures.

---

# 48. Verificación Hosted Development obligatoria

Mediante Gate separado para Supabase Cloud, antes y durante el cutover verificar como baseline común:

```text
canonical password policy known = YES
technical password encoder guaranteed compatible = YES
cutover route selected = A1 | A2 | B
zero unprotected transition window = YES
final E2 hook enforcement = ACTIVE AND VERIFIED
```

### Ruta A1

Verificar:

```text
relevant pre-E2 sessions = NONE
relevant usable pre-E2 access tokens = NONE
new pre-E2 session issuance before E2 = IMPOSSIBLE
zero unprotected transition window = YES
final E2 hook = ACTIVE AND VERIFIED
```

### Ruta A2

Verificar:

```text
freeze supported = YES
freeze authorized = YES when required
freeze active = YES
final absence proof after freeze = PASS
hook activated while freeze active = YES
default-deny tests = PASS
freeze safely removed = YES
post-removal bypass test = PASS
```

### Ruta B

Verificar:

```text
supported issuance-freeze mechanism = YES
separate human authorization = YES
freeze activation = VERIFIED
verification of no new pre-E2 issuance = PASS
supported existing-session invalidation = VERIFIED
post-invalidation refresh verification = PASS
verified pre-E2 JWT lifetime upper bound = YES
JWT validity-tail closure = PASS
freeze continuity verification = PASS
final E2 hook activation while still frozen = YES
E2 default-deny verification = PASS
freeze removal = SAFE AND VERIFIED
post-removal bypass verification = PASS
```

En TODAS las rutas:

```text
zero unprotected transition window = YES
```

Debe quedar prohibido declarar:

```text
E2 SESSION CUTOVER = PASS
```

antes de:

```text
final E2 hook enforcement = ACTIVE AND VERIFIED
```

Los negative tests del enforcement final deben cubrir:

```text
password without valid E2 grant → DENY
otp → DENY
totp → DENY
magiclink → DENY
recovery → DENY
email_change → DENY
oauth_provider / authorization_code → DENY
anonymous → DENY
unknown method → DENY
```

Además deben verificarse:

```text
hook runtime error denies JWT = YES
hook timeout denies JWT = YES
authentication_method=token_refresh distinguishable = YES
current password required for password mutation = YES
secret/admin credential absent from browser = YES
no unexpected user auto-creation = YES
existing tenant RLS regression suite remains intact = YES
```

Cuando exista freeze temporal, sólo después de los negative tests puede retirarse.

Después de retirarlo debe repetirse una verificación mínima que demuestre:

```text
no initial-auth bypass reopened = YES
```

Sólo después:

```text
E2 SESSION CUTOVER = PASS
```

y:

```text
token_refresh of an E2-established session
→ allowed without new SessionGrant
```

No realizar estas operaciones sobre Staging/Production.

# 49. Fallos parciales de Cloud

Si migration/config repo pasa pero Hosted config no puede aplicarse o verificarse:

```text
TASK-013 = NOT DONE
```

No revertir arquitectura por conveniencia.

No desactivar el hook.

No habilitar passwordless fallback.

No marcar implementación completa.

Debe reportarse:

```text
BLOCKER — HOSTED SECURITY PRECONDITION NOT SATISFIED
```

---

# 50. Logging y observabilidad

Prohibido registrar:

- business code;
- verifier completo cuando no sea necesario;
- challenge HMAC key;
- technical-password key;
- technical password;
- Supabase secret key;
- access token;
- refresh token;
- SessionGrant como bearer authority;
- full event payload si contiene información sensible.

Los errores pueden registrar:

- operation type;
- opaque operation id;
- generic outcome;
- non-sensitive identifiers estrictamente necesarios.

Email debe minimizarse/redactarse en logs.

No existe obligación en TASK-013 de introducir una plataforma nueva de observabilidad.

---

# 51. Respuestas y enumeration resistance

Outcomes externos futuros deberán converger en categorías genéricas.

La foundation debe permitir diferenciar internamente:

- missing;
- expired;
- exhausted;
- invalid;
- consumed;
- invalidated;

sin obligar al futuro browser response a revelar cuál.

No exponer:

```text
"email exists"
"user exists"
"challenge exists"
"2 attempts left"
```

como información pública salvo requisito funcional posterior explícito.

---

# 52. Supabase Auth public surfaces

E2 no depende de que todas las APIs públicas del proveedor puedan apagarse individualmente.

La defensa autoritativa es:

```text
public signup disabled
+
technical password unknown to browser
+
Custom Access Token Hook default-deny
+
SessionGrant
```

Por tanto:

```text
signInWithOtp request accepted by provider
!=
initial JWT authorized
```

```text
recovery request accepted
!=
initial JWT authorized
```

```text
OAuth flow reaches Auth
!=
initial JWT authorized
```

El test relevante es token/session issuance denial.

---

# 53. Before User Created / Send Email / Password Verification Hooks

No son requisitos de TASK-013 E2.

### Before User Created

```text
OPTIONAL DEFENSE IN DEPTH
```

No sustituye public signup disabled.

### Send Email Hook

```text
OPTIONAL DEFENSE IN DEPTH
```

No es session authority.

No es business-code delivery de TASK-013.

### Password Verification Hook

```text
OPTIONAL
NOT REQUIRED
```

No introducir dependencia Teams/Enterprise.

TASK-013 no implementa ninguno salvo que una contradicción técnica demostrada fuerce revisión.

---

# 54. Reconciliación con TASK-009/011/012

TASK-013 debe preservar:

```text
Auth subject
→ PlatformUser
```

como vínculo ya existente.

No modificar cardinalidades aprobadas.

TASK-011 continúa siendo exclusivamente SSR lifecycle técnico.

TASK-013 no cambia cookies/proxy salvo necesidad material revisada.

TASK-012 continúa siendo autoridad de:

```text
validated Auth subject
→ PlatformUser
→ current CompanyMembership
→ MaintenanceCompany
→ current tenant role
```

No duplicar esa lógica dentro del hook.

---

# 55. Archivos previstos

La implementación podrá modificar/crear exclusivamente dentro de estas categorías, sujeto a preflight real:

```text
supabase/migrations/<timestamp>_task_013_verification_challenge_foundation.sql

supabase/tests/database/<task-013-suite>.sql

supabase/config.toml

.env.example

src/infrastructure/config/<private-auth-config>.ts

src/modules/identity-authorization/application/**
src/modules/identity-authorization/infrastructure/crypto/**
src/modules/identity-authorization/infrastructure/supabase/**
src/modules/identity-authorization/server.ts

tests/<task-013-*.test.ts>
```

Los filenames TypeScript exactos pueden adaptarse a la convención real si:

- no cambia ownership;
- no se crea otro módulo;
- no se crea abstraction genérica;
- no se amplía scope.

---

# 56. Archivos fuera de alcance por defecto

No modificar:

```text
app/**
proxy.ts

src/infrastructure/supabase/browser.ts
src/infrastructure/supabase/proxy.ts
```

salvo contradicción técnica material y revisión previa.

No modificar:

```text
docs/**
```

durante implementación técnica.

No modificar tablas/migrations previas salvo necesidad inequívoca autorizada.

No modificar:

- reporting;
- forms;
- maintenance;
- evidence;
- payments;
- AI;
- offline.

No añadir microservicios.

---

# 57. Repo vs Cloud

Debe mantenerse una separación formal:

```text
repository implementation
!=
Supabase Cloud Development configuration
```

Codex puede implementar cambios versionables sólo cuando exista autorización de implementación.

Supabase Cloud:

```text
requires separate human authorization
```

Incluso con TASK-013 aprobada.

Ningún prompt de implementación puede asumir permiso implícito de modificar remoto.

Debe quedar explícito:

```text
controlled hook activation inside cutover
!=
TASK-013 implementation authorization
```

Esta especificación describe el futuro procedimiento.

NO autoriza ejecutarlo ahora.

Además:

```text
E2 SESSION CUTOVER = PASS
```

es un resultado operacional futuro del Gate Cloud.

No es el estado documental actual de TASK-013.

Debe quedar explícito:

```text
specification of cutover freeze
!=
authorization to execute cutover freeze
```

Toda mutación real en Supabase Cloud Development continúa requiriendo Gate humano separado.

Esta especificación NO autoriza:

- disabling Auth methods;
- signing users out;
- revoking sessions;
- changing JWT expiry;
- changing password policy;
- enabling/disabling hooks;
- applying Auth config.

Staging:

```text
NO CHANGE
```

Production:

```text
NO CHANGE
```

---

# 58. Preflight obligatorio de futura implementación

Antes del primer cambio:

```text
git rev-parse --is-inside-work-tree
git rev-parse --show-toplevel
git branch --show-current
git rev-parse HEAD
git rev-parse origin/main
git rev-list --left-right --count origin/main...HEAD
git status --short --branch
git status --porcelain=v1 --untracked-files=all
git diff --cached --name-only
```

Verificar además:

```text
merge = NO
rebase = NO
cherry-pick = NO
revert = NO
bisect = NO
sequencer = NO
```

Debe inspeccionarse de nuevo:

- árbol del módulo;
- migrations;
- DB tests;
- tests TypeScript;
- package versions;
- `supabase/config.toml`;
- `.env.example`;
- private config existente;
- referencias a secret/service-role;
- Auth hooks existentes;
- password policy canónica Hosted vigente;
- pre-E2 sessions potentially refreshable;
- pre-E2 access tokens potentially still valid;
- canonical JWT expiry configuration and any known prior configuration relevant to tokens already issued;
- supported session invalidation mechanism when required;
- evidence needed to establish a safe upper bound for the pre-E2 JWT tail;
- officially supported mechanism available to prevent new pre-E2 session issuance during cutover;
- whether that mechanism requires Cloud/config mutation;
- evidence that public-signup disable alone does not constitute the freeze;
- transition plan ensuring zero unprotected window between temporary freeze and final E2 hook enforcement;
- cualquier implementación paralela de challenge;
- documentación oficial Supabase vigente.

No inspeccionar contenido de tokens reales salvo que una superficie oficial y una autorización específica lo requieran.

No ejecutar ningún mecanismo de freeze durante preflight.

No loguear tokens.

Ante drift material:

```text
BLOCKER
```

No autorepair.

---
# 59. Blockers estrictos

La implementación deberá detenerse si ocurre cualquiera.

## 59.1 Git/repo

1. branch inesperada;
2. HEAD/upstream incompatible;
3. divergencia inesperada;
4. worktree dirty por cambios ajenos;
5. staged changes previos;
6. operación Git en curso;
7. TASK-013 ya materializada de forma incompatible.

## 59.2 Canon

8. ADR-0019 falta/no está `ACCEPTED`;
9. ADR-0019 presenta decisión distinta de E2;
10. RF-004…RF-011 cambiaron;
11. ADR-0002/0003 cambió materialmente;
12. CORR-015/016 dejan el canon incompatible;
13. otra decisión posterior contradice E2.

## 59.3 Challenge

14. no puede garantizarse 8h exactas;
15. no puede garantizarse tres intentos exactos;
16. no puede garantizarse retry idempotente;
17. no puede garantizarse resend invalidation;
18. no puede garantizarse un successor;
19. no puede garantizarse single-use;
20. no puede garantizarse atomicidad verify/resend;
21. requiere plaintext code;
22. requiere provider OTP/rate limits como authority.

## 59.4 SessionGrant / Hook

23. grant no puede ser single-use atómico;
24. grant debe exponerse al browser como authority;
25. hook no puede fallar closed;
26. `password`/`token_refresh` no pueden distinguirse;
27. wrong initial methods pueden emitir JWT;
28. `supabase_auth_admin` requiere privilegios tenant;
29. hook requiere generic table access no justificable, o `SECURITY INVOKER + minimal grants/RLS` no puede implementar el hook y sería necesario `SECURITY DEFINER` sin revisión aprobada.

## 59.5 Technical password

30. technical password necesita browser, o canonical Hosted password policy cannot be known/verified;
31. technical password debe persistirse plaintext, o deterministic encoder cannot guarantee canonical policy;
32. key separation no puede mantenerse, constant-time verifier comparison unavailable, challenge key version no puede resolver su secret key material, technical-password key version no puede resolver su secret key material, o la implementación propone utilizar el version identifier como HMAC key;
33. password mutation puede reemplazar la credential sin current password;
34. rotation necesita fallback passwordless;
35. se requiere password UX.

## 59.6 Auth Admin

36. se requiere generic Admin client;
37. se requiere ampliar métodos Admin fuera de `createUser`/`updateUserById`;
38. secret key debe convertirse en ordinary request client;
39. privileged credential debe alcanzar browser;
40. user creation no autorizada no puede prevenirse.

## 59.7 Arquitectura/scope

41. se necesita nuevo ADR material;
42. se necesita microservicio;
43. se necesita `Client`;
44. se necesita `UserClientAccess`;
45. se necesita `SupportAccessGrant`;
46. se necesita resolver ADR-0004;
47. se cruza Fase 3;
48. se requiere UI;
49. se requiere Auth funcional end-to-end;
50. el slice deja de ser PR-sized.

## 59.8 Cloud

51. Hosted Custom Access Token Hook no se comporta conforme al contrato oficial;
52. hook errors no niegan JWT;
53. public signup no puede permanecer disabled;
54. current-password requirement no puede verificarse;
55. Un Auth method público consigue JWT inicial sin E2; la ruta de cutover seleccionada no puede demostrar ausencia/control de sesiones y access tokens pre-E2 aplicables; puede producirse una nueva sesión pre-E2 entre la última evidencia válida y la activación/verificación E2; no puede garantizarse una transición zero-window; la Ruta A necesita freeze/protección y no existe mecanismo soportado; la Ruta B no puede invalidar sesiones, eliminar refresh capability, acotar/cerrar el JWT tail o mantener el freeze; o cualquier mutación necesaria carece de autorización separada.
56. Cloud requiere cambio no autorizado.

## 59.9 Calidad

57. dependencia nueva no aprobada;
58. TypeScript strict debe relajarse;
59. RLS tenant debe debilitarse;
60. existing regression suite debe deshabilitarse;
61. `git diff --check` falla;
62. tests críticos de concurrencia no pueden hacerse determinísticamente.

Ante cualquier blocker:

```text
NO ampliar scope
NO autorepair
NO new ADR automatically
NO fallback
volver al Revisor Central
```

---

# 60. Tests de regresión

Una futura implementación debe ejecutar como mínimo:

```text
npm run lint
npm run typecheck
npm run test
npm run build
npm run verify
git diff --check
```

Y la suite DB completa disponible.

No ocultar fallos mediante:

- skip;
- `.only`;
- casts inseguros;
- ESLint disable no justificado;
- reducción de tests;
- modificación del workflow para hacer pasar el Gate.

---

# 61. Criterios de aceptación

Los criterios históricos se reevaluaron.

La numeración corregida sustituye al conjunto histórico para esta versión.

Debe existir exactamente:

```text
AC-001 … AC-120
```

sin duplicados ni huecos.

## 61.1 Identidad, gobernanza y scope

**AC-001.** El ID continúa siendo exactamente `TASK-013`.

**AC-002.** El título continúa siendo exactamente `TASK-013 — Fundación física segura del lifecycle de VerificationChallenge`.

**AC-003.** El tipo continúa siendo `IMPLEMENTATION TASK`.

**AC-004.** La fase continúa siendo `Fase 2 — Multitenancy, autenticación, roles y RLS`.

**AC-005.** El bounded context continúa siendo `Identity & Auth`.

**AC-006.** El estado documental es `APPROVED FOR IMPLEMENTATION`.

**AC-007.** El resultado documental es `TASK-013 SPECIFICATION = APPROVED FOR IMPLEMENTATION`, después de `TASK-013 CORRECTED SPEC EIGHTH REVIEW = APPROVED` y de la aprobación humana formal.

**AC-008.** `APPROVED FOR IMPLEMENTATION` representa aprobación documental de la especificación; no declara `DONE` ni constituye autorización de ejecución técnica.

**AC-009.** ADR-0019 se consume como `ACCEPTED` y no se reabre E2.

**AC-010.** `TASK-014 determinada = NO` y `TASK-014 generada = NO`.

## 61.2 Producto y dominio

**AC-011.** RF-004…RF-011 permanecen sin debilitamiento.

**AC-012.** La vigencia contractual es exactamente 8 horas por emisión.

**AC-013.** Cada emisión admite como máximo tres intentos efectivos.

**AC-014.** Cada resend crea una nueva identidad de challenge.

**AC-015.** Un resend invalida autoritativamente la emisión anterior cuando la nueva emisión queda creada.

**AC-016.** Cada nueva emisión posee su propio attempt budget.

**AC-017.** Expired, consumed, exhausted e invalidated son terminales.

**AC-018.** `VerificationChallenge` continúa platform-owned.

**AC-019.** Email continúa siendo PII/locator y no identity/tenant authority.

**AC-020.** No se añade `SessionGrant` como requisito funcional de producto ni se modifica `02-domain-model.md`.

## 61.3 Modelo físico de challenge

**AC-021.** Existe `public.verification_challenges` con únicamente campos justificados por lifecycle/seguridad.

**AC-022.** El challenge no contiene `tenant_id` ni `maintenance_company_id`.

**AC-023.** `verifier` nunca contiene el código plaintext y su representación HMAC autoritativa posee longitud fija equivalente a 32 bytes.

**AC-024.** `verifier_key_version` se persiste explícitamente.

**AC-025.** `issued_at` utiliza clock server-side.

**AC-026.** `expires_at = issued_at + exactly 8 hours` se enforcea físicamente.

**AC-027.** `attempt_count` sólo admite `0..3`.

**AC-028.** `consumed_at`, `invalidated_at` y `exhausted_at` no pueden formar terminalidades incompatibles.

**AC-029.** Un tercer intento correcto puede producir `attempt_count=3` + consumed sin exhausted.

**AC-030.** Un tercer intento incorrecto produce exhausted.

**AC-031.** `supersedes_challenge_id` no permite self-reference.

**AC-032.** Un predecessor admite como máximo un successor directo válido.

**AC-033.** `issue_operation_id` es unique.

**AC-034.** Retry de issue/resend con el mismo operation ID no duplica emisión.

**AC-035.** Un challenge consumed no se reactiva por resend.

## 61.4 Attempts, idempotencia y concurrencia

**AC-036.** Existe persistencia técnica de intentos idempotentes.

**AC-037.** Ninguna attempt row persiste plaintext code.

**AC-038.** `operation_id` de intento es unique.

**AC-039.** `(challenge_id, attempt_number)` es unique.

**AC-040.** Retry del mismo verification operation no consume otro intento.

**AC-041.** Operation IDs distintos sobre un challenge representan intentos efectivos distintos.

**AC-042.** Dos verifies concurrentes no exceden tres intentos.

**AC-043.** Dos verifies correctos concurrentes producen como máximo un consume.

**AC-044.** Verify vs resend posee orden autoritativo y fail-closed.

**AC-045.** Dos resends concurrentes no dejan dos successors utilizables.

## 61.5 Verifier y secrets

**AC-046.** El challenge verifier utiliza HMAC-SHA-256 con material de key secreto, dedicado y server-only seleccionado mediante `verifier_key_version`; el identificador de versión nunca se utiliza como HMAC key.

**AC-047.** La serialización del challenge verifier es determinista, no ambigua y está cubierta por test vectors.

**AC-048.** La comparación autoritativa del challenge verifier utiliza una primitive constant-time aprobada sobre digests fixed-length; una igualdad ordinaria SQL/string no constituye cumplimiento.

**AC-049.** La challenge key es server-only.

**AC-050.** La challenge key no se versiona en Git.

**AC-051.** Existe key versioning donde el valor persistido identifica qué secret key server-only debe resolverse; key version identifier y secret key material son conceptos distintos.

**AC-052.** Rotación de challenge key no modifica challenges existentes.

**AC-053.** Key versions antiguas se retienen mientras exista una emisión legítimamente verificable que dependa de ellas.

**AC-054.** Challenge key y technical-password key son material distinto.

**AC-055.** Ningún error/log imprime code, verifier sensible o key.

## 61.6 AuthBridgeCredential y technical password

**AC-056.** Existe una bridge credential técnica platform-owned.

**AC-057.** La bridge credential no es tenant/member/role authority.

**AC-058.** `auth_user_id`, cuando existe, es unique.

**AC-059.** La technical password no se almacena plaintext en la aplicación.

**AC-060.** La technical password parte de un seed HMAC-SHA-256 calculado con secret key material dedicado y server-only seleccionado mediante `technical_password_key_version`, nunca utilizando el identificador de versión como HMAC key, y después aplica un encoder determinista condicionado por la password policy canónica verificada.

**AC-061.** La construcción de technical password garantiza satisfacer todas las clases y longitudes obligatorias de la password policy canónica vigente; si esa policy no puede conocerse o verificarse, TASK-013 entra en `BLOCKER`.

**AC-062.** La technical password no depende de tenant ni role.

**AC-063.** La technical password nunca llega al browser.

**AC-064.** No existe password UX ni password elegido por usuario.

**AC-065.** Technical-password key posee versioning donde la versión persistida selecciona material secreto server-only; el identificador de versión no constituye la key criptográfica.

**AC-066.** Rotation no ocurre automáticamente en cada login.

**AC-067.** `updateUserById` para rotation/repair sólo se usa mediante el boundary purpose-specific.

**AC-068.** Rotation incierta queda fail-closed sin passwordless fallback.

## 61.7 SessionGrant

**AC-069.** Existe `public.auth_session_grants` platform-owned.

**AC-070.** Cada successful challenge consume puede crear como máximo un grant asociado a ese challenge.

**AC-071.** El grant tiene `purpose = initial_session`.

**AC-072.** El grant tiene `auth_method = password`.

**AC-073.** Grant TTL es exactamente cinco minutos.

**AC-074.** Grant consumed es terminal.

**AC-075.** Grant revoked es terminal.

**AC-076.** Grant expired no puede consumirse.

**AC-077.** Existe como máximo un grant unconsumed/unrevoked por bridge credential.

**AC-078.** El grant no se entrega al browser como bearer authority.

**AC-079.** Dos password sign-ins concurrentes con el mismo grant consumen como máximo una vez.

**AC-080.** Retry después de grant consume no reactiva grant.

## 61.8 Custom Access Token Hook

**AC-081.** El Custom Access Token Hook es Postgres Function.

**AC-082.** `authentication_method=password` exige grant elegible.

**AC-083.** Password sin grant produce deny.

**AC-084.** Subject mismatch produce deny.

**AC-085.** Un bridge previamente no vinculado sólo puede bindearse mediante correlación inequívoca de grant, email y Auth subject.

**AC-086.** El binding y grant consume ocurren atómicamente.

**AC-087.** `token_refresh` no consume un nuevo SessionGrant y sólo puede permitirse después de un cutover pre-E2 completo cuya ruta seleccionada demuestre ausencia o eliminación de credenciales históricas aplicables, ausencia de carrera de reemisión pre-E2, transición zero-window y Custom Access Token Hook E2 activo y verificado; los requisitos de refresh revocation/JWT tail aplican adicionalmente cuando la Ruta B sea necesaria.

**AC-088.** OTP initial auth se deniega.

**AC-089.** Magic Link initial auth se deniega.

**AC-090.** Recovery initial auth se deniega.

**AC-091.** Signup/invite initial methods se deniegan.

**AC-092.** TOTP, OAuth/SSO, `oauth_provider`/`authorization_code`, `email_change` y anonymous initial authentication permanecen explicitly denied mientras no exista decisión posterior que los autorice.

**AC-093.** Todo authentication method nuevo, desconocido o no aprobado se deniega por default.

**AC-094.** El hook no convierte claims en tenant authorization.

## 61.9 Privilegios, RLS y configuración

**AC-095.** Public signup se configura como disabled.

**AC-096.** Auth Admin boundary expone sólo `createUser` y `updateUserById`.

**AC-097.** No existe generic Supabase Admin client exportado.

**AC-098.** El sign-in técnico usa semantics no privilegiadas/publishable y permanece server-side.

**AC-099.** `supabase_auth_admin` no recibe privilegios tenant.

**AC-100.** `supabase_auth_admin` opera bajo el modelo `SECURITY INVOKER` por defecto y recibe únicamente `USAGE`, `EXECUTE` y los privilegios SELECT/UPDATE mínimos, preferentemente column-scoped cuando sea viable, necesarios sobre estado platform-owned del hook; no recibe privilegios tenant.

**AC-101.** Las cuatro tablas TASK-013 tienen RLS enabled y cualquier policy para `supabase_auth_admin` queda limitada a las operaciones platform-owned requeridas por el Custom Access Token Hook.

**AC-102.** `anon` no posee CRUD directo sobre las tablas.

**AC-103.** `authenticated` no posee CRUD directo sobre las tablas.

**AC-104.** Las mutations de challenge/grant ocurren mediante boundaries purpose-specific; el Custom Access Token Hook no utiliza `SECURITY DEFINER` salvo desviación posteriormente justificada y aprobada por revisión de seguridad.

**AC-105.** La configuración privada está separada de configuración client-safe.

**AC-106.** `.env.example` contiene sólo placeholders ficticios y ningún secreto.

## 61.10 Failure model, tests y regresiones

**AC-107.** Challenge consume y grant creation participan en una única transacción DB.

**AC-108.** `createUser` response loss no provoca blind repeated user creation.

**AC-109.** Hook consume + response loss no reactiva grant ni challenge.

**AC-110.** Hook timeout/error produce fail-closed.

**AC-111.** Rotation failure no habilita fallback.

**AC-112.** Tests DB cubren attempts, resend, replay y concurrency crítica.

**AC-113.** Tests DB cubren SessionGrant single-use, `token_refresh`, explicit deny de OTP/TOTP/Magic Link/recovery/email_change/OAuth/anonymous/unknown methods y el privilege model `SECURITY INVOKER` de `supabase_auth_admin`.

**AC-114.** Tests TypeScript cubren crypto, constant-time verifier comparison, deterministic password-policy-compliant encoding, config privada y no leakage.

**AC-115.** Hosted Development tests verifican la ruta de cutover seleccionada (`A1`, `A2` o `B`), ausencia de ventana desprotegida desde la última evidencia válida de estado pre-E2 hasta el enforcement E2, Custom Access Token Hook activo y verificado antes de declarar `CUTOVER PASS`, y negative bypass para password/OTP/TOTP/Magic Link/recovery/email_change/OAuth/anonymous; la Ruta B verifica además invalidación, refresh removal y cierre del JWT tail.

**AC-116.** Existing regression suite continúa passing.

## 61.11 Repo, calidad y governance

**AC-117.** `new npm dependencies = 0` salvo nueva revisión explícita.

**AC-118.** TypeScript strict permanece efectivo y `lint`, `typecheck`, `test`, `build`, `verify`, DB tests y `git diff --check` deben pasar.

**AC-119.** La aprobación documental de TASK-013 no autoriza por sí misma ejecución técnica, staging, commit, push ni cambios Supabase Cloud; todos continúan sujetos a sus Gates separados.

**AC-120.** `TASK-014 determinada = NO`, `TASK-014 generada = NO` y TASK-013 sólo puede avanzar al siguiente Gate documental; canonicalización e implementación permanecen separadamente gobernadas.

Resultado obligatorio:

```text
AC count = 120
AC range = AC-001..AC-120
AC consecutive = YES
AC duplicates = 0
AC missing = 0
```

---

# 62. Definition of Done de implementación futura

TASK-013 sólo podrá considerarse `DONE` cuando, después de aprobación documental y autorización concreta:

1. preflight Git fresco fue válido;
2. no existe blocker;
3. migration única fue creada y revisada;
4. las cuatro tablas técnicas existen;
5. constraints están implementadas;
6. RLS/direct grants están fail-closed;
7. challenge keyed verifier funciona;
8. 8h exactas se enforcean;
9. tres intentos exactos se enforcean;
10. retries no duplican attempts;
11. resend invalidation es atómica;
12. single-use funciona bajo concurrencia;
13. SessionGrant es 5m/single-use;
14. hook default-deny está implementado;
15. `token_refresh` queda separado;
16. Auth Admin boundary permanece purpose-specific;
17. technical password permanece server-only;
18. key separation/versioning funciona; challenge key-version resolution = PASS; technical-password key-version resolution = PASS; persisted key-version identifiers contain no secret material = YES; version identifier used directly as HMAC key = NO;
19. no generic privileged client existe;
20. local config representa signup disabled + hook;
21. private config y `.env.example` cumplen TASK-004;
22. canonical Supabase password policy verified = YES;
23. technical password deterministic encoder guarantees canonical policy = YES;
24. constant-time challenge comparison = YES;
25. Custom Access Token Hook security invoker = YES;
26. `supabase_auth_admin` privileges reviewed = YES;
27. cutover route selected = A1 | A2 | B;
28. zero unprotected transition window = YES;
29. final E2 hook activated = YES;
30. final E2 hook default-deny verified = YES;
31. E2 SESSION CUTOVER = PASS;
32. si A1: final clean-state proof = PASS;
33. si A1: new pre-E2 session issuance impossible until E2 verification = YES;
34. si A2: freeze supported/authorized = YES cuando corresponda;
35. si A2: freeze active before final clean-state proof = YES;
36. si A2: freeze continuity = PASS;
37. si A2: hook activation while frozen = YES;
38. si A2: safe freeze removal = VERIFIED;
39. si A2: post-removal bypass verification = PASS;
40. si B: freeze supported/authorized = YES;
41. si B: existing-session invalidation = VERIFIED;
42. si B: pre-E2 refresh capability remaining = NO;
43. si B: maximum applicable pre-E2 JWT lifetime verified = YES;
44. si B: pre-E2 JWT access-token tail remaining = NO;
45. si B: freeze continuity = PASS;
46. si B: hook activation while frozen = YES;
47. si B: safe freeze removal = VERIFIED;
48. si B: post-removal bypass verification = PASS;
49. TOTP negative bypass test = PASS;
50. email_change negative bypass test = PASS;
51. oauth_provider/authorization_code negative bypass tests = PASS;
52. DB tests pasan;
53. TypeScript tests pasan;
54. full regression pasa;
55. Hosted Development fue configurado únicamente mediante autorización separada;
56. Hosted negative bypass tests pasan;
57. password mutation current-password setting fue verificado;
58. Staging/Production permanecen intactos;
59. full diff fue revisado;
60. cambios permanecieron unstaged hasta autorización separada;
61. staging/commit/push siguieron sus Gates separados;
62. revisión final humana cerró la implementación.

No se exigen requisitos de invalidación/JWT-tail propios de Ruta B si A1/A2 demuestran legítimamente que no existía población pre-E2 que invalidar.

`SECURITY DEFINER` sólo puede aparecer como:

```text
separately reviewed deviation = APPROVED
```

Si no existe esa aprobación:

```text
SECURITY DEFINER = NO
```

# 63. Estado tras aprobación documental

```text
TASK-013 CORRECTED SPEC EIGHTH REVIEW = APPROVED

TASK-013 CORRECTED SPEC HUMAN APPROVAL = APPROVED

TASK-013 DETERMINATION = APPROVED

TASK-013 historical SPEC REVIEW =
APPROVED AS BLOCKED

TASK-013 corrected specification =
APPROVED FOR IMPLEMENTATION

TASK-013 corrected specification state =
APPROVED FOR IMPLEMENTATION

TASK-013 SPECIFICATION =
APPROVED FOR IMPLEMENTATION

TASK-013 corrected specification approval = YES
TASK-013 human approval = YES

TASK-013 canonicalizada = NO

TASK-013 implementation gate = CLOSED
TASK-013 implementación autorizada = NO
TASK-013 implementada = NO

ADR-0019 = ACCEPTED
E2 changed = NO

CORR-015 = COMPLETED
CORR-016 = COMPLETED

Auth funcional = NO
VerificationChallenge foundation implementada = NO

UI = NO
Offline = NO
AuditEvent producer = NO

TASK-014 determinada = NO
TASK-014 generada = NO
```

---

# 64. Gate posterior

El único siguiente acto es:

```text
TASK-013 DOCUMENT APPROVAL REVIEW
```

NO corresponde todavía:

```text
canonicalization
Codex
implementation
SQL
migration
RLS
Auth config mutation
hook activation
session invalidation
cutover freeze
Supabase Cloud
git add
commit
push
TASK-014
```

Hasta entonces:

```text
TASK-013 implementation gate = CLOSED
```

---

# 65. Confirmación de no ejecución

```text
TASK-013 DOCUMENTAL APPROVAL = COMPLETED

TASK-013 SPECIFICATION =
APPROVED FOR IMPLEMENTATION

TASK-013 canonicalizada = NO

TASK-013 implementation authorization = NO
TASK-013 implementación autorizada = NO
TASK-013 implementada = NO

NO IMPLEMENTATION
NO CODE
NO SQL
NO MIGRATION
NO RLS EXECUTABLE
NO AUTH HOOK CREATED OR ACTIVATED
NO AUTH CONFIG MUTATION
NO SUPABASE CLOUD CHANGE
NO SESSION INVALIDATION
NO CUTOVER EXECUTION
NO REPOSITORY MODIFICATION

NO GIT ADD
NO COMMIT
NO PUSH

NO TASK-014
```
