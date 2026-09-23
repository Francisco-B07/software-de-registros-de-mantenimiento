# CORR-032 — Corrección de la foundation TASK-013 para AuthBridgeCredential pre-bound bajo Custom Access Token Hook

## 1. Identificación

**ID:** `CORR-032`

**Título:** `CORR-032 — Corrección de la foundation TASK-013 para AuthBridgeCredential pre-bound bajo Custom Access Token Hook`

**Tipo:** `FORWARD-ONLY IMPLEMENTATION CORRECTION SPECIFICATION`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context principal:** `Identity & Auth`

**Estado de esta especificación:** `FORMALLY APPROVED`

**CORR-032 DETERMINATION:** `APPROVED`

**CORR-032 SPECIFICATION GENERATION:** `AUTHORIZED`

**CORR-032 SPEC REVIEW:** `APPROVED`

**CORR-032 HUMAN SPEC APPROVAL:** `APPROVED`

**CORR-032 APPROVED ARTIFACT REVIEW:** `APPROVED`

**CORR-032 canonical artifact:** `GENERATED`

**Implementación autorizada:** `NO`

**Codex autorizado:** `NO`

**Repositorio modificado por esta especificación:** `NO`

**Supabase Local modificado:** `NO`

**Hosted Development modificado:** `NO`

**SQL ejecutable producido:** `NO`

**Migration creada:** `NO`

**RLS modificada físicamente:** `NO`

**git add / commit / push:** `NO / NO / NO`

**TASK-018 Hosted retry:** `NO`

**TASK-019:** `NOT DETERMINED / NOT AUTHORIZED`

Esta especificación define exclusivamente la corrección mínima, forward-only y verificable de una regresión física de TASK-013. No reabre ADR-0019, no modifica requisitos de producto, no implementa CORR-032 y no reanuda TASK-018.

---

## 2. Estado de gobernanza de entrada

Se consume sin reabrir:

```text
TASK-018 WORK ITEM E COMPATIBLE EXISTING IDENTITY
HOSTED FAILURE READ-ONLY DIAGNOSTIC REVIEW =
APPROVED

root cause =
B — TASK-013 / AUTH HOOK FOUNDATION REGRESSION

CORR-032 DETERMINATION =
APPROVED

CORR-032 SPECIFICATION GENERATION =
AUTHORIZED
```

El blocker anterior de generación fue exclusivamente:

```text
CORR-032 SPECIFICATION =
BLOCKER — REQUIRED PHYSICAL SOURCE UNAVAILABLE
```

El Revisor Central aprobó ese estado bloqueado y posteriormente aprobó la recuperación física de las dos fuentes ausentes. Esta reanudación continúa el mismo Gate; no crea una segunda especificación conceptual ni una nueva determinación.

---

## 3. Verificación física de fuentes obligatorias

### 3.1 SOURCE 1 — TASK-018 canónica recuperada

Archivo recibido:

`CORR-032-SOURCE-1-TASK-018-canonical.md`

Representación declarada:

`docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md`

Verificación desde bytes físicos:

```text
SHA-256 =
f480485516dd0e9855f17f0463ec8a7c410e38ed677e75723bc93f41b2d1a4ae

bytes = 103093
LF = 2534
CRLF = 0
bare CR = 0
trailing-whitespace lines = 0
final newline = YES
```

Resultado:

```text
TASK-018 CANONICAL IDENTITY = PASS
```

El contenido identifica exactamente `TASK-018 — Authoritative First-Admin Auth Identity Reconciliation and Session Establishment Foundation` y contiene el contrato de existing bound identity, reconciliation-first, E2 session establishment, RLS/multitenancy y Work Item E requerido por este Gate.

### 3.2 SOURCE 2 — migration física TASK-013 recuperada

Archivo recibido:

`CORR-032-SOURCE-2-TASK-013-foundation-migration.sql`

Representación declarada:

`supabase/migrations/20260830010000_task_013_verification_challenge_foundation.sql`

Verificación desde bytes físicos:

```text
SHA-256 =
1d4833f38be525974d447dc0dd301211a1d6bad68edadcfe46f424f5eb4e0dbf

bytes = 23497
LF = 696
CRLF = 0
bare CR = 0
trailing-whitespace lines = 0
final newline = YES
```

Resultado:

```text
TASK-013 MIGRATION IDENTITY = PASS
```

La migration contiene físicamente:

- `public.auth_bridge_credentials`;
- `public.auth_session_grants`;
- `public.task_013_custom_access_token_hook`;
- RLS enabled sobre las cuatro tablas técnicas TASK-013;
- grants column-scoped para `supabase_auth_admin` sobre `auth_session_grants` y `auth_bridge_credentials`;
- policies de `supabase_auth_admin` para lectura/consume/binding;
- Custom Access Token Hook `SECURITY INVOKER`.

### 3.3 Resto de fuentes mínimas obligatorias

También están físicamente disponibles y fueron leídas íntegramente:

- `docs/tasks/TASK-013-verification-challenge-foundation.md`;
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`.

No se utiliza memoria ni conversación histórica como sustituto de estas fuentes físicas.

### 3.4 Fuentes adicionales

Durante este Gate no se dispone de una copia física completa del repositorio ni de todas las suites actuales TASK-013/TASK-018. La ausencia de esas fuentes adicionales no bloquea la especificación porque las cuatro fuentes mínimas obligatorias determinan de forma inequívoca el contrato canónico, el path TASK-018 y la causa física exacta de la regresión.

La futura implementación deberá inspeccionar nuevamente el repositorio real, las suites DB/TypeScript vigentes, la implementación materializada del hook y cualquier migration posterior antes de modificar nada.

---

## 4. Orden de autoridad

Para CORR-032 se aplica:

1. autorización humana posterior y determinaciones aprobadas de CORR-032;
2. repositorio físico real durante una futura ejecución autorizada;
3. documentos canónicos vigentes;
4. ADR aceptados dentro de su alcance;
5. TASK/CORR aprobadas;
6. snapshots históricos sólo como evidencia del estado que documentaban.

Reglas obligatorias:

```text
implementation bug
!=
retroactive canonical semantic change
```

```text
later approved state
>
stale historical snapshot
```

CORR-032 no reescribe historia normativa de TASK-013.

---

## 5. Contexto y root cause consumida

El Hosted scenario aprobado como evidencia reproduce:

```text
compatible existing application identity
→ valid technical password
→ fresh eligible SessionGrant
→ AuthBridgeCredential already bound
   to the same authoritative Auth subject
→ Custom Access Token Hook
→ CURRENT RESULT:
   P0001 / HTTP 500 / no JWT-session
```

La migration física demuestra simultáneamente:

1. el hook considera elegible una bridge cuando `auth_user_id` es `NULL` **o** coincide con el Auth subject actual;
2. el grant se selecciona y bloquea bajo sus checks de purpose, method, consume, revocation y expiry;
3. después el hook ejecuta una lectura estricta de `auth_bridge_credentials` con row lock;
4. la policy de UPDATE de bridge sólo hace visible para UPDATE una fila con `auth_user_id IS NULL` y `bound_at IS NULL`;
5. una bridge ya bound queda, por tanto, fuera de la row-level qualification requerida por esa operación de locking;
6. la lectura estricta cae en `NO_DATA_FOUND` y el hook normaliza el fallo a `P0001`.

Root cause consumida:

```text
canonical same-subject pre-bound path = allowed
+
physical hook insists on bridge UPDATE-qualified row lock
+
bridge UPDATE RLS exposes only unbound rows
=
compatible pre-bound path denied by physical implementation
```

CORR-032 no reabre la clasificación del root cause como provider bug, fixture bug o TASK-018 application bug.

---

## 6. Decisión canónica obligatoria A vs B

### 6.1 Resultado

```text
CORR-032 CANONICAL DECISION = A
```

```text
A =
canonical TASK-013 already expresses the required behavior;
physical implementation was too restrictive;
no normative TASK-013 semantic change required
```

### 6.2 Evidencia canónica de TASK-013

TASK-013 §18.5 establece que cuando `auth_user_id IS NOT NULL`, ese subject es autoritativo para la bridge y no puede reasignarse silenciosamente.

TASK-013 §26.1 establece expresamente:

```text
bridge.auth_user_id = event.user_id
→ puede continuar si el grant es válido
```

Cualquier mismatch permanece `DENY`.

TASK-013 §26.2 limita el binding inicial al caso unbound con correlación inequívoca de grant, email y Auth subject, y exige que binding + grant consume ocurran en la misma transición.

TASK-013 §27.4 exige `SECURITY INVOKER`, grants mínimos y RLS sólo en la medida necesaria para el estado platform-owned del hook. El privilege de UPDATE sobre `auth_bridge_credentials` está descrito como necesario **para binding del Auth subject**, no como autorización general para mutar filas already-bound.

TASK-013 AC-082..AC-086 preservan grant obligatorio, mismatch deny, binding sólo para unbound y atomicidad de binding + consume.

### 6.3 Evidencia canónica de TASK-018

TASK-018 §11.3 exige que una `AuthBridgeCredential` ya bound:

- no ejecute `createUser`;
- use el mismo technical password;
- ejecute `signInWithPassword` server-side;
- exija exactamente el mismo `auth_user_id` en el Hook;
- falle cerrado ante mismatch.

TASK-018 §12.1/§12.2 exige además que E2 continúe mediante grant elegible bloqueado/validado, exact email/subject correlation, binding sólo si unbound y grant consume atómico.

Por tanto, TASK-018 no crea una semántica nueva: consume exactamente la rama already-bound que TASK-013 ya había autorizado.

### 6.4 Por qué no es B

No existe ambigüedad canónica sobre si la bridge bound al mismo subject puede continuar. La frase de TASK-013 §26.1 es directa y positiva.

Tampoco existe ambigüedad sobre rebinding: está prohibido salvo una reparación explícita separada.

El defecto aparece únicamente en la materialización del locking bajo RLS.

Resultado documental:

```text
TASK-013 canonical semantic modification = NONE
ADR-0019 modification = NONE
TASK-018 semantic modification = NONE
```

---

## 7. Objetivo único de CORR-032

Definir la corrección mínima, forward-only y verificable para que:

```text
AuthBridgeCredential already bound
+
same authoritative Auth subject
+
correct email/correlation
+
fresh eligible SessionGrant
+
authentication_method = password
```

pueda completar:

```text
grant eligibility validation
→ bridge/email/subject validation
→ minimum required locking
→ SessionGrant atomic consume
→ JWT/session issuance
```

sin:

- rebind de `auth_user_id`;
- rewrite de `bound_at`;
- bypass de SessionGrant;
- ampliación de tenant authority;
- ampliación de Auth Admin;
- `SECURITY DEFINER`;
- general UPDATE authority;
- cambio de schema.

---

## 8. Scope

### 8.1 In scope

1. corregir el comportamiento físico del Custom Access Token Hook para la rama pre-bound/same-subject;
2. preservar la rama unbound existente;
3. preservar grant validation, locking y single-use;
4. preservar correlación exacta de email/bridge/subject;
5. preservar atomicidad de binding + consume cuando realmente existe binding;
6. preservar `SECURITY INVOKER`;
7. preservar RLS enabled;
8. preservar grants mínimos;
9. añadir/ajustar tests de regresión estrictamente necesarios;
10. aplicar la corrección futura mediante una migration nueva, forward-only;
11. verificar Local antes de Hosted Development;
12. devolver TASK-018 a Work Item E sólo después del cierre independiente de CORR-032.

### 8.2 Out of scope

- editar la migration histórica TASK-013;
- cambiar schema de las cuatro tablas TASK-013;
- crear columnas o constraints nuevos;
- cambiar technical-password derivation;
- cambiar TTL o semántica de SessionGrant;
- permitir nuevos Auth methods;
- modificar TASK-011 SSR lifecycle;
- modificar TASK-012 authoritative authorization;
- modificar TASK-014 global authority;
- modificar TASK-015 CompanyMembership lifecycle/RLS;
- modificar TASK-017 verification/handoff;
- rediseñar TASK-018 orchestration;
- crear o modificar `PlatformUser`/`CompanyMembership`;
- conceder tenant authority;
- introducir `SECURITY DEFINER`;
- introducir generic service-role/Admin client;
- implementar reparación/rebinding;
- reanudar Hosted Development en esta especificación;
- determinar TASK-019.

---

## 9. Domain / technical ownership

`AuthBridgeCredential` permanece:

```text
platform-owned technical Auth state
```

No es:

```text
tenant-owned data
CompanyMembership
role authority
client scope
business identity proof
tenant authorization
```

`SessionGrant` permanece platform-owned technical authorization evidence para exactamente un initial session issuance attempt.

Se preserva:

```text
tenant = MaintenanceCompany
```

```text
authenticated != authorized
```

```text
Auth session != tenant authorization
```

CORR-032 no modifica ownership ni multitenancy.

---

## 10. Requisitos de CORR-032

**REQ-032-001.** La rama already-bound con `bridge.auth_user_id = current Auth subject` DEBE poder continuar cuando el SessionGrant actual es elegible y todas las correlaciones son válidas.

**REQ-032-002.** La rama already-bound NO DEBE ejecutar binding de bridge.

**REQ-032-003.** La rama already-bound NO DEBE modificar `auth_user_id` ni `bound_at`.

**REQ-032-004.** La rama already-bound DEBE consumir atómicamente el SessionGrant una sola vez.

**REQ-032-005.** La rama unbound DEBE conservar el binding inicial actual sólo bajo correlación inequívoca.

**REQ-032-006.** En la rama unbound, binding y SessionGrant consume DEBEN permanecer en una única transacción PostgreSQL del hook.

**REQ-032-007.** Wrong subject DEBE continuar fail-closed.

**REQ-032-008.** Wrong email/correlation DEBE continuar fail-closed.

**REQ-032-009.** Missing, expired, revoked o consumed grant DEBE continuar fail-closed.

**REQ-032-010.** Un bridge bound NO DEBE convertir el SessionGrant en opcional.

**REQ-032-011.** `authentication_method=password` permanece requisito del initial session path.

**REQ-032-012.** Methods iniciales no aprobados permanecen default-deny.

**REQ-032-013.** El hook DEBE permanecer `SECURITY INVOKER`.

**REQ-032-014.** RLS DEBE permanecer enabled.

**REQ-032-015.** `supabase_auth_admin` NO DEBE adquirir privilegios tenant.

**REQ-032-016.** CORR-032 NO DEBE conceder una policy general de UPDATE sobre bridge credentials.

**REQ-032-017.** Los privileges column-level de UPDATE sobre `auth_user_id`/`bound_at` sólo justifican el binding unbound; no constituyen autoridad para rebind.

**REQ-032-018.** La row-level qualification necesaria para una operación con row lock NO DEBE confundirse con el mero privilege de UPDATE de columnas.

**REQ-032-019.** El mínimo locking requerido DEBE evitar TOCTOU en el consume del grant y en el binding cuando éste ocurra.

**REQ-032-020.** Dos sign-ins concurrentes sobre el mismo SessionGrant DEBEN producir como máximo un consume exitoso.

**REQ-032-021.** La corrección NO DEBE introducir una segunda arquitectura de sesión.

**REQ-032-022.** La corrección NO DEBE ampliar Auth Admin ni usar provider repair/takeover.

**REQ-032-023.** La corrección futura DEBE ser forward-only y NO editar la migration histórica.

**REQ-032-024.** La implementación futura DEBE pasar verificación Local antes de solicitar Hosted Development.

**REQ-032-025.** El Hosted scenario compatible-existing-identity que originó CORR-032 DEBE pasar antes de devolver control a TASK-018.

---

## 11. Contrato de bridge unbound

Estado de entrada:

```text
bridge.auth_user_id IS NULL
bridge.bound_at IS NULL
```

Debe preservarse TASK-013:

1. existe exactamente un grant elegible correlacionado con la bridge;
2. `purpose = initial_session`;
3. `auth_method = password`;
4. grant no consumed;
5. grant no revoked;
6. grant no expired;
7. email provider-visible coincide con `bridge.email`;
8. el Auth subject procede del evento del Hook y no de caller input;
9. la bridge se bloquea en la medida necesaria para impedir doble binding;
10. se revalida que continúa unbound después del lock;
11. `auth_user_id` se vincula exactamente al Auth subject actual;
12. `bound_at` se establece una sola vez como parte de ese binding;
13. el grant queda correlacionado al mismo subject y consumed;
14. binding + consume se confirman o revierten juntos.

Prohibido:

```text
caller-supplied auth_user_id authority
email-only authority
locator-only authority
silent subject takeover
partial binding commit without grant consume
grant consume with failed required binding
```

El UPDATE privilege y la UPDATE RLS de bridge permanecen justificadas exclusivamente por esta rama.

---

## 12. Contrato de bridge already-bound — same subject

Estado de entrada:

```text
bridge.auth_user_id = current Auth subject
bridge.bound_at IS NOT NULL
fresh eligible SessionGrant = YES
email/correlation = VALID
```

Resultado canónico permitido:

```text
SESSION ALLOW
```

sólo si todos los checks E2 continúan válidos.

Obligaciones:

1. validar exactamente el mismo subject;
2. validar email/bridge/grant correlation;
3. bloquear el SessionGrant antes de consumirlo;
4. revalidar eligibility bajo el lock del grant;
5. consumir el grant una sola vez;
6. no ejecutar UPDATE de la bridge;
7. no escribir `auth_user_id`;
8. no escribir `bound_at`;
9. no tratar la fila bound como candidata a binding;
10. no ampliar ninguna autoridad tenant.

### 12.1 Determinación de locking mínimo

Para la rama already-bound, CORR-032 determina:

```text
minimum serialization lock = eligible SessionGrant row
```

La bridge already-bound participa en validación autoritativa por lectura, pero **no necesita un UPDATE-qualified row lock para ejecutar una mutación que no existe**.

Justificación:

- el subject bound ya es autoritativo por TASK-013 §18.5;
- el happy path no permite rebinding;
- el hook no modifica la bridge en esta rama;
- el punto mutable single-use es el SessionGrant;
- el lock del grant serializa los consumes concurrentes;
- la rama unbound conserva su bridge lock porque sí realiza binding;
- una futura operación explícita de repair/rebind permanece fuera de CORR-032 y requiere su propia revisión.

Por tanto, la corrección mínima debe dejar de exigir a una fila already-bound la row-level qualification de UPDATE necesaria exclusivamente para binding.

### 12.2 Consecuencia RLS

```text
row readable for validation
!=
row UPDATE-visible for binding
```

La fila bound puede ser leída bajo la superficie SELECT ya existente y validada contra el Auth subject actual sin convertirla en fila actualizable por `supabase_auth_admin`.

---

## 13. Wrong subject

Para:

```text
bridge.auth_user_id IS NOT NULL
AND
bridge.auth_user_id != current Auth subject
```

resultado obligatorio:

```text
DENY
```

No se permite:

- rebinding;
- auto-repair;
- password reset fallback;
- `updateUserById` fallback;
- Auth Admin takeover;
- creación de nueva bridge para eludir el mismatch;
- exposición de subject IDs al caller.

La corrección del pre-bound compatible path no modifica este comportamiento.

---

## 14. Email y correlation

El email permanece:

```text
provider locator / correlation input
!= authoritative application identity
```

La authority del Auth subject proviene de:

```text
Hook event subject
+
bridge canonical binding when present
+
SessionGrant correlation
```

Wrong email o cross-bridge correlation:

```text
DENY
```

No se introduce:

- lookup genérico de Auth users;
- email-only bridge selection;
- browser-selected bridge;
- browser-selected subject;
- tenant derivation desde email.

---

## 15. SessionGrant contract

Se preserva íntegramente:

```text
purpose = initial_session
auth_method = password
TTL = 5 minutes
single-use = YES
consumed = terminal
revoked = terminal
expired = invalid
replay = DENY
browser bearer authority = NO
```

La bridge already-bound:

```text
!= SessionGrant bypass
```

El grant continúa siendo obligatorio para initial password authentication.

`token_refresh` permanece separado conforme a TASK-013/ADR-0019 y no queda alterado por CORR-032.

---

## 16. Locking, concurrency y atomicidad

### 16.1 Principio

El lock debe aplicarse al estado mutable cuya carrera puede producir un segundo efecto autorizado.

### 16.2 Orden conceptual requerido

Sin prescribir SQL ejecutable, el hook futuro debe mantener una secuencia equivalente a:

```text
validate method / event shape
→ resolve one eligible grant + correlated bridge
→ lock eligible SessionGrant
→ revalidate grant after lock
→ read and validate current bridge state
→ if unbound: acquire binding-capable bridge lock + revalidate + bind
→ if already-bound: require exact same subject, no bridge mutation
→ atomically consume grant
→ return claims
```

### 16.3 Concurrencia del mismo grant

```text
two concurrent password sign-ins
+
same SessionGrant
→ at most one successful consume
```

La segunda transacción debe observar el estado actualizado después de esperar el lock y fallar cerrada como no elegible/replay.

### 16.4 Unbound race

En una bridge unbound, el lock de bridge continúa siendo necesario antes del binding para evitar dos bindings incompatibles o un TOCTOU entre validación y escritura.

La mutación de binding debe confirmar que la precondición unbound continúa vigente.

### 16.5 Already-bound race

En una bridge already-bound/same-subject:

- no existe binding que serializar;
- el grant es el único estado que debe consumirse exactamente una vez;
- la bridge se valida, pero no se reescribe;
- no se amplía UPDATE RLS para obtener un lock innecesario.

### 16.6 Atomicidad

Debe permanecer:

```text
unbound path:
bridge binding + SessionGrant consume = one PostgreSQL transaction
```

```text
already-bound path:
bridge validation + SessionGrant consume = one Hook transaction
bridge mutation = NONE
```

No se afirma atomicidad distribuida con Supabase Auth provider ni con entrega HTTP/cookies.

---

## 17. RLS / grants / privilege model

### 17.1 Distinción obligatoria

```text
column-level UPDATE privilege
!=
row-level visibility/qualification for UPDATE or SELECT ... FOR UPDATE
```

El grant column-level habilita qué columnas puede actualizar una role **si la fila también supera RLS**. No hace visible por sí solo una fila para una operación que requiere UPDATE qualification.

La regresión ocurrió precisamente porque ambos conceptos quedaron materializados de forma incompatible para el path already-bound.

### 17.2 Modelo que se preserva

```text
Custom Access Token Hook = SECURITY INVOKER
RLS = ENABLED
supabase_auth_admin tenant privileges = NO
browser direct CRUD = NO
PUBLIC direct CRUD = NO
generic service-role path = NO
```

### 17.3 Decisión de corrección mínima

La especificación determina que **no es necesario ampliar la policy UPDATE de `auth_bridge_credentials`** para corregir el caso probado.

La policy de binding puede continuar calificando únicamente la fila unbound porque:

- sólo la rama unbound debe modificar `auth_user_id`/`bound_at`;
- la rama already-bound sólo necesita SELECT/validation;
- el SessionGrant proporciona el serialization point del consume;
- ampliar UPDATE visibility de una fila bound crearía una superficie de privilegio que no es necesaria para el contrato canónico.

Por la misma razón:

```text
new bridge UPDATE columns = NONE
new bridge UPDATE authority = NONE
new tenant privileges = NONE
```

### 17.4 Grants existentes

El future implementation debe preservar, salvo contradicción física nueva:

- SELECT sólo de las columnas bridge necesarias para validación;
- UPDATE sólo de `auth_user_id` y `bound_at` para binding unbound;
- SELECT/UPDATE mínimos de SessionGrant para validation/consume;
- EXECUTE sólo del Hook para `supabase_auth_admin`;
- ausencia de tenant-table grants.

### 17.5 Prohibiciones

CORR-032 no autoriza:

```text
general UPDATE policy
all-row UPDATE visibility for bound bridges
new DELETE privilege
new INSERT privilege for supabase_auth_admin
tenant table access
company_memberships access
platform_users tenant-authority access
generic privileged table access
SECURITY DEFINER
```

Si la implementación real demuestra que la rama already-bound no puede funcionar bajo `SECURITY INVOKER + current minimal SELECT/UPDATE grants + current RLS` sin ampliar UPDATE authority o introducir `SECURITY DEFINER`, el resultado es blocker, no una ampliación automática.

---

## 18. Threat model

| Amenaza | Fuente de autoridad válida | Invariante / denegación requerida | Failure esperado |
|---|---|---|---|
| Wrong Auth subject | Hook event + bound bridge subject | exact equality cuando bridge está bound | deny / no session |
| Wrong email | bridge canonical email + provider claim | exact correlation | deny |
| Stolen/guessed bridge ID | DB correlation through eligible grant | ID solo no autoriza | deny |
| Caller-supplied subject | Hook event subject only | caller subject ignored/not accepted | deny |
| Caller-supplied tenant | authoritative application state outside bridge | tenant input no influye hook | deny / no tenant authority |
| Expired grant | DB clock + grant expiry | invalid | deny |
| Revoked grant | current grant state | terminal | deny |
| Consumed grant | current grant state | terminal | deny |
| Grant replay | locked grant state | one consume max | second attempt deny |
| Concurrent consume | locked eligible grant | at most one winner | one success max |
| Cross-bridge substitution | grant → bridge FK/correlation | exact bridge ID + email + subject | deny |
| Silent rebinding | bound bridge is authoritative | no bridge UPDATE in bound path | deny/blocker |
| RLS widening | canonical minimum privilege | no general bridge UPDATE visibility | review blocker |
| `supabase_auth_admin` privilege escalation | explicit grants only | no unrelated platform/tenant access | test failure/blocker |
| Tenant-access escalation | CompanyMembership/current authz state | Auth session != tenant authority | deny |
| Browser direct Data API attempt | RLS + no grants | no CRUD | deny |
| Hook runtime error | fail-closed hook | no JWT/session | `P0001`/provider failure class |
| Partial transaction failure | PostgreSQL transaction | binding/consume rollback together where binding occurs | no partial DB authorization effect |
| Wrong Auth method | event authentication method | only approved password initial flow; refresh separate | deny |
| Provider identity takeover | outside CORR-032 | no repair/rebind fallback | deny / repair-required upstream |
| Broad policy proposed as workaround | canon + CORR-032 | reject unnecessary privilege expansion | blocker |

---

## 19. Failure model

| Caso | Estado esperado | Mutación permitida | Resultado |
|---|---|---|---|
| Missing bridge | invalid/security | none | deny |
| Missing eligible grant | invalid/security | none | deny |
| Expired grant | terminal | none | deny |
| Revoked grant | terminal | none | deny |
| Consumed grant | terminal/replay | none | deny |
| Wrong subject on bound bridge | security | none | deny |
| Wrong email/correlation | security | none | deny |
| Unbound compatible bridge | valid | bind once + consume grant atomically | allow |
| Already-bound compatible bridge | valid | consume grant only; bridge unchanged | allow |
| Concurrent same-grant attempts | race | one consume maximum | one allow max, others deny |
| Bridge binding precondition lost | race/conflict | no partial consume | deny |
| RLS denies an operation canonically required | implementation drift | none | blocker/fail closed |
| Unexpected DB error | internal | transaction rollback | fail closed |
| Hook runtime error | internal/security | no JWT/session | fail closed |
| General UPDATE policy required to proceed | security design drift | none | blocker |
| `SECURITY DEFINER` required to proceed | architecture/security drift | none | blocker |
| Provider contract drift | external contract drift | none within CORR-032 | blocker |

User-facing behavior no necesita distinguir todas estas causas. Los mensajes deben permanecer bounded y no enumerar bridge, Auth identity, tenant o provider state.

---

## 20. Migration strategy y governance

La migration histórica:

`supabase/migrations/20260830010000_task_013_verification_challenge_foundation.sql`

está aplicada y permanece inmutable.

La futura implementación de CORR-032 debe utilizar:

```text
new forward-only migration
```

creada sólo después de:

1. spec review;
2. human spec approval;
3. approved artifact review;
4. canonicalization y review;
5. canonical repository incorporation;
6. implementation authorization;
7. preflight Git fresco.

Esta especificación no fija timestamp/nombre físico de la migration futura antes de inspeccionar el repositorio real.

No contiene SQL ejecutable.

---

## 21. Objetos autorizados a cambiar en futura implementación

### 21.1 Cambio físico esperado mínimo

**Objeto:** `public.task_013_custom_access_token_hook(jsonb)`

**Tipo de cambio:** reemplazo forward-only de la función mediante migration nueva, preservando firma, `SECURITY INVOKER`, default-deny y contrato E2.

**Cambio semántico físico:** separar el tratamiento de bridge unbound del already-bound para que la segunda no dependa de UPDATE-qualified row visibility cuando no existe bridge mutation.

### 21.2 Tests

Pueden modificarse o añadirse exclusivamente tests necesarios para demostrar:

- bound same-subject success;
- no bridge rewrite;
- unbound binding preservation;
- wrong-subject/email deny;
- grant single-use/concurrency;
- privilege/RLS non-expansion;
- TASK-018 compatible-existing-identity regression.

### 21.3 RLS/policies/grants

Resultado de esta especificación:

```text
required RLS policy change = NO
required direct grant change = NO
```

Si el repositorio real difiere de la migration recuperada o una migration posterior cambió estas superficies, la implementación debe detenerse y volver a revisión antes de asumir esta conclusión sobre el estado físico actual.

---

## 22. Objetos que deben permanecer intactos

Salvo contradicción física nueva aprobada, CORR-032 no modifica:

- schema de `verification_challenges`;
- schema de `verification_challenge_attempts`;
- schema de `auth_bridge_credentials`;
- schema de `auth_session_grants`;
- constraints de `auth_bridge_credentials`;
- constraints/índices de SessionGrant;
- technical-password derivation/versioning;
- challenge HMAC/verifier;
- challenge lifecycle;
- attempt lifecycle;
- resend semantics;
- SessionGrant TTL/purpose/auth_method;
- `token_refresh` semantics;
- Auth Admin purpose-specific boundary;
- public signup contract;
- ADR-0019 E2;
- TASK-011 SSR lifecycle;
- TASK-012 authoritative online authorization;
- TASK-014 global `SUPER_ADMIN` authority;
- TASK-015 CompanyMembership mutation/RLS;
- TASK-017 verification/handoff flow;
- TASK-018 application orchestration/UI;
- tenant tables;
- `CompanyMembership` RLS;
- `PlatformUser` authority;
- AuditEvent catalog;
- Storage/offline/reporting/AI/payments.

---

## 23. Security y multitenancy

CORR-032 preserva:

```text
SECURITY INVOKER = YES
RLS enabled = YES
supabase_auth_admin tenant grants = NONE
generic privileged client = NO
browser privileged path = NO
```

Una sesión emitida después de la corrección significa únicamente Auth identity/session válida. No crea:

- `PlatformUser`;
- `CompanyMembership`;
- tenant role;
- client scope;
- `SupportAccessGrant`;
- subscription entitlement;
- tenant authorization.

El authorization path vigente continúa resolviendo current PostgreSQL state conforme a TASK-012/ADR-0003 y las foundations posteriores.

---

## 24. Test plan obligatorio

### 24.1 DB / Hook functional cases

1. **Unbound + correct subject + correct email/correlation + fresh eligible grant** → PASS; bind once; consume grant.
2. **Already-bound + same subject + fresh eligible grant** → PASS; consume grant; bridge `auth_user_id`/`bound_at` unchanged.
3. **Already-bound + different subject** → DENY; no mutation.
4. **Already-bound + wrong email/correlation** → DENY.
5. **Missing grant** → DENY.
6. **Expired grant** → DENY.
7. **Revoked grant** → DENY.
8. **Consumed/replayed grant** → DENY.
9. **Two concurrent consumes** → at most one success.
10. **Unbound concurrent attempts** → at most one binding/consume result; no split-brain subject.
11. **Bridge binding precondition changed before binding** → deny/rollback; no partial consume.
12. **Already-bound same-subject path** → no UPDATE attempt required against bridge binding columns.

### 24.2 RLS / privilege tests

13. `anon` direct bridge/grant CRUD → DENY.
14. `authenticated` direct bridge/grant CRUD → DENY.
15. browser/Data API direct access → DENY according to current TASK-013 contract.
16. `supabase_auth_admin` tenant data access introduced by CORR-032 → NONE.
17. `supabase_auth_admin` direct privileges remain the exact minimal expected surface.
18. Hook remains `SECURITY INVOKER`.
19. No general bridge UPDATE policy is introduced.
20. Bound bridge remains non-rebindable by the hook role.
21. Unbound bridge remains bindable only through the approved hook transition.

### 24.3 Auth-method regression

22. password without eligible grant → DENY.
23. wrong subject → DENY.
24. wrong email/unbound correlation → DENY.
25. OTP initial auth → DENY.
26. TOTP initial auth → DENY.
27. Magic Link initial auth → DENY.
28. recovery initial auth → DENY.
29. signup/invite initial methods → DENY.
30. `email_change` → DENY.
31. OAuth / `oauth_provider` / `authorization_code` → DENY.
32. anonymous → DENY.
33. unknown method → DENY.
34. `token_refresh` regression remains governed by the existing post-cutover contract and consumes no new grant.

### 24.4 TASK-018 regression

35. fresh/new identity path remains passing.
36. compatible existing unbound provider identity remains passing.
37. compatible existing **pre-bound** application identity path passes without `createUser` and without rebinding.
38. incompatible existing identity remains fail-closed.
39. compatibility guard remains read-only.
40. session cookies remain TASK-011-compatible.
41. resulting Auth session still grants no tenant authority by itself.
42. no `AuditEvent.USER_CREATED` is introduced by CORR-032.

### 24.5 Negative scope tests

43. no new table/column/index/constraint.
44. no CompanyMembership policy change.
45. no PlatformUser authority change.
46. no Auth Admin expansion.
47. no generic service-role request path.
48. no browser token/technical-password exposure.

---

## 25. Regression plan

### 25.1 TASK-013

Debe permanecer passing:

- challenge lifecycle;
- attempts exactos;
- resend invalidation;
- verifier/HMAC semantics;
- SessionGrant 5m/single-use;
- unbound binding;
- deny matrix de Auth methods;
- hook default-deny;
- technical password server-only;
- `SECURITY INVOKER`;
- minimal grants/RLS;
- E2 cutover assumptions ya cerradas.

### 25.2 ADR-0019 / E2

Debe permanecer:

```text
application-owned challenge
+
one-time SessionGrant
+
server-only technical password
+
public signup disabled
+
Custom Access Token Hook default-deny
+
separate token_refresh
+
narrow Auth Admin boundary
```

### 25.3 TASK-017

No se modifica:

- verification proof;
- FirstAdminOnboardingIntent binding;
- handoff generation;
- email/tenant derivation;
- browser trust boundary.

### 25.4 TASK-018

La aplicación/orchestration no se rediseña. CORR-032 debe hacer que el contrato ya esperado por TASK-018 §11.3/§12 pueda ejecutarse físicamente.

### 25.5 TASK-014 / TASK-015

Debe comprobarse que la superficie de privilegio corregida no permite:

- resolver o mutar global authority de TASK-014;
- leer/mutar `CompanyMembership` por `supabase_auth_admin`;
- eludir RLS de TASK-015;
- derivar tenant authority desde la sesión.

---

## 26. Local verification futura

La implementación futura debe ejecutar primero Supabase LOCAL.

Antes de fijar comandos concretos se inspeccionarán los scripts y harness reales del repositorio.

La verificación debe cubrir, según las convenciones vigentes:

1. preflight Git;
2. inspección de migrations posteriores a TASK-013;
3. creación/aplicación de la migration forward-only autorizada;
4. reset/apply de Supabase Local según el harness real;
5. DB tests TASK-013;
6. nuevos tests CORR-032;
7. RLS/grant assertions;
8. hook functional tests;
9. concurrency tests;
10. negative Auth-method tests;
11. TASK-018 local integration/regression aplicable;
12. TASK-014/TASK-015 privilege regression cuando la suite lo permita;
13. TypeScript tests;
14. lint;
15. typecheck;
16. full tests;
17. build;
18. verify;
19. `git diff --check`;
20. revisión del diff para confirmar ausencia de cambios fuera de scope.

No se inventan nombres de scripts ni comandos exactos en esta especificación.

Local failure => no Hosted request.

---

## 27. Hosted Development verification futura

Hosted Development requiere autorización humana separada posterior a implementation review/local PASS.

Después de ese Gate, la verificación debe incluir:

1. aplicar exclusivamente la migration CORR-032 autorizada en Hosted Development;
2. verificar físicamente la definición final del Hook;
3. verificar RLS/policies/grants remotos y confirmar que no existe widening inesperado;
4. ejecutar real Custom Access Token Hook;
5. fresh identity path regression;
6. compatible existing unbound identity regression;
7. compatible existing **pre-bound same-subject** identity → session success;
8. confirmar `createUser = NO` en el pre-bound compatible path;
9. confirmar bridge binding columns unchanged en ese path;
10. wrong-subject negative case;
11. wrong-email/correlation negative case;
12. SessionGrant replay case;
13. expiry/revocation cases cuando puedan ejecutarse de forma segura;
14. one-grant / at-most-one initial-session concurrency evidence cuando el harness Hosted lo soporte;
15. confirmar Auth session established through the normal SSR boundary;
16. confirmar tenant authorization remains denied absent current membership;
17. confirmar `Require current password when changing password = enabled` permanece conforme a TASK-018/ADR-0019;
18. confirmar unexpected remote diff = NONE fuera de la migration autorizada;
19. cleanup de fixtures;
20. post-cleanup verification.

El caso 7 es el blocker original de TASK-018 y debe quedar evidenciado como PASS antes del retorno a Work Item E.

Esta specification no autoriza ninguna de esas mutations.

---

## 28. Fixture cleanup

Toda fixture Local/Hosted futura debe ser:

```text
test-only
identifiable
minimal
disposable
```

No usar datos reales.

Después del cleanup, verificar según lo efectivamente creado:

```text
unexpected test Auth identities = ZERO
unexpected test bridge credentials = ZERO
unexpected test grants = ZERO
unexpected verification test state = ZERO
unexpected tenant authority = ZERO
unexpected policy/grant drift = ZERO
```

Cleanup failure = blocker de cierre.

---

## 29. Documentation impact

Dado que §6 determina **A**:

```text
TASK-013 canonical semantic modification = NONE
```

No se modifica:

- `docs/tasks/TASK-013-verification-challenge-foundation.md`;
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`;
- `docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md`.

CORR-032 documenta y corrige exclusivamente el drift de materialización física descubierto por Hosted Development.

La documentación nueva requerida es el propio artefacto canónico de CORR-032 y, después de implementación/cierre, cualquier state-sync que el Revisor Central determine mediante Gate separado.

No se crea retroactivamente una nueva semántica en TASK-013.

---

## 30. Blockers

La futura implementación/revisión debe detenerse ante cualquiera de estas clases:

### 30.1 Fuentes / canon

- `BLOCKER — REQUIRED PHYSICAL SOURCE UNAVAILABLE`
- `BLOCKER — CANONICAL CONTRADICTION`
- `BLOCKER — TASK-013 CANONICAL IDENTITY MISMATCH`
- `BLOCKER — TASK-018 CANONICAL IDENTITY MISMATCH`
- `BLOCKER — TASK-013 MIGRATION IDENTITY MISMATCH`

### 30.2 Provider / Auth boundary

- `BLOCKER — PROVIDER CONTRACT DRIFT`
- `BLOCKER — AUTH ADMIN BOUNDARY EXPANSION REQUIRED`
- `BLOCKER — TASK-018 APPLICATION REDESIGN REQUIRED`

### 30.3 Migration / schema

- `BLOCKER — HISTORICAL MIGRATION EDIT REQUIRED`
- `BLOCKER — SCHEMA REDESIGN REQUIRED`

### 30.4 Seguridad / RLS / privilegio

- `BLOCKER — SECURITY DEFINER DEVIATION REQUIRES ARCHITECTURAL REVIEW`
- `BLOCKER — GENERIC PRIVILEGED ACCESS REQUIRED`
- `BLOCKER — TENANT PRIVILEGE REQUIRED`
- `BLOCKER — GENERAL UPDATE POLICY REQUIRED`
- `BLOCKER — SUBJECT REBINDING REQUIRED`
- `BLOCKER — SESSIONGRANT SEMANTICS WOULD NEED WEAKENING`

### 30.5 Verificación

- `BLOCKER — LOCAL REGRESSION FAILURE`
- `BLOCKER — HOSTED UNEXPECTED DIFF`
- `BLOCKER — FIXTURE CLEANUP FAILURE`
- `BLOCKER — COMPATIBLE PRE-BOUND HOSTED PATH STILL FAILS`

Ante blocker:

```text
STOP
RETURN TO REVISOR CENTRAL
NO SILENT REPAIR
NO SCOPE EXPANSION
```

---

## 31. Git governance

Gates separados obligatorios:

```text
spec generation
→ spec review
→ human spec approval
→ approved artifact generation
→ approved artifact review
→ canonicalization
→ canonicalization review
→ canonical repo incorporation
→ implementation authorization
→ local implementation
→ implementation review
→ Hosted Development authorization
→ Hosted verification
→ staging authorization
→ commit authorization
→ push authorization
→ final human closure
→ explicit return to TASK-018 Work Item E
```

No colapsar Gates.

### 31.1 Estado de esta entrega

```text
repository mutation = NO
Supabase Local mutation = NO
Hosted Development mutation = NO
Staging mutation = NO
Production mutation = NO
git add = NO
commit = NO
push = NO
```

### 31.2 Preflight futuro

Antes de una implementación autorizada:

- confirmar repo root;
- confirmar branch esperada;
- obtener HEAD;
- obtener origin/main;
- verificar divergence;
- verificar worktree clean;
- verificar ausencia de Git operation in progress;
- verificar canonical CORR-032 exacta;
- inspeccionar migrations posteriores a TASK-013;
- inspeccionar definición real actual del Hook;
- inspeccionar policies/grants actuales;
- inspeccionar tests/harness actuales;
- confirmar que no existe otra corrección que ya haya alterado la misma superficie.

Drift material => blocker, no auto-repair.

---

## 32. Acceptance Criteria

**AC-032-001.** CORR-032 conserva exactamente la identidad y determinación aprobadas.

**AC-032-002.** La especificación no implementa ni autoriza implementación.

**AC-032-003.** SOURCE 1 coincide exactamente con SHA-256 `f480485516dd0e9855f17f0463ec8a7c410e38ed677e75723bc93f41b2d1a4ae` y métricas aprobadas.

**AC-032-004.** SOURCE 2 coincide exactamente con SHA-256 `1d4833f38be525974d447dc0dd301211a1d6bad68edadcfe46f424f5eb4e0dbf` y métricas aprobadas.

**AC-032-005.** TASK-013 y ADR-0019 requeridos están físicamente disponibles y se consumen desde sus artefactos.

**AC-032-006.** La decisión canónica A/B queda determinada como `A`.

**AC-032-007.** `TASK-013 canonical semantic modification = NONE`.

**AC-032-008.** ADR-0019 no se reabre.

**AC-032-009.** TASK-018 no se rediseña.

**AC-032-010.** El root cause aprobado permanece `TASK-013 / Auth Hook foundation regression`.

**AC-032-011.** `AuthBridgeCredential` permanece platform-owned technical Auth state.

**AC-032-012.** `AuthBridgeCredential` no adquiere tenant ownership ni role authority.

**AC-032-013.** `authenticated != authorized` permanece vigente.

**AC-032-014.** `Auth session != tenant authorization` permanece vigente.

**AC-032-015.** Tenant continúa siendo `MaintenanceCompany`.

**AC-032-016.** Un bridge unbound sólo puede bindearse con grant, email, bridge y Auth subject inequívocamente correlacionados.

**AC-032-017.** El subject de binding proviene del Hook event, no de caller input.

**AC-032-018.** Binding unbound escribe `auth_user_id` exactamente una vez.

**AC-032-019.** Binding unbound establece `bound_at` exactamente como parte del binding.

**AC-032-020.** Binding unbound y grant consume permanecen atómicos.

**AC-032-021.** Una bridge already-bound al mismo subject puede continuar con grant válido.

**AC-032-022.** La rama already-bound no ejecuta `createUser` por efecto de CORR-032.

**AC-032-023.** La rama already-bound no modifica `auth_user_id`.

**AC-032-024.** La rama already-bound no modifica `bound_at`.

**AC-032-025.** La rama already-bound consume exactamente un grant elegible.

**AC-032-026.** La rama already-bound no requiere bridge UPDATE-qualified row visibility para una mutación inexistente.

**AC-032-027.** El SessionGrant row lock continúa siendo el serialization point del consume single-use.

**AC-032-028.** Wrong bound subject produce DENY.

**AC-032-029.** Subject mismatch nunca produce rebinding.

**AC-032-030.** Subject mismatch no dispara repair/password reset/Auth Admin takeover.

**AC-032-031.** Wrong email/correlation produce DENY.

**AC-032-032.** Email permanece locator/correlation y no autoridad de identidad de aplicación.

**AC-032-033.** Missing SessionGrant produce DENY.

**AC-032-034.** Expired SessionGrant produce DENY.

**AC-032-035.** Revoked SessionGrant produce DENY.

**AC-032-036.** Consumed/replayed SessionGrant produce DENY.

**AC-032-037.** SessionGrant mantiene `purpose = initial_session`.

**AC-032-038.** SessionGrant mantiene `auth_method = password`.

**AC-032-039.** SessionGrant TTL permanece cinco minutos.

**AC-032-040.** Bridge already-bound no constituye bypass de SessionGrant.

**AC-032-041.** Dos sign-ins concurrentes con el mismo grant producen como máximo un consume exitoso.

**AC-032-042.** Una carrera unbound no puede producir dos bindings incompatibles.

**AC-032-043.** La precondición unbound se revalida bajo el lock necesario antes de bindear.

**AC-032-044.** Un fallo de binding requerido revierte el consume asociado.

**AC-032-045.** El already-bound path no introduce TOCTOU sobre el estado mutable del grant.

**AC-032-046.** No se afirma 2PC ni atomicidad distribuida Auth-provider/PostgreSQL/HTTP.

**AC-032-047.** Custom Access Token Hook permanece `SECURITY INVOKER`.

**AC-032-048.** RLS permanece enabled sobre las tablas TASK-013.

**AC-032-049.** `supabase_auth_admin` mantiene cero privilegios tenant introducidos por CORR-032.

**AC-032-050.** La especificación distingue column-level UPDATE privilege de row-level RLS qualification.

**AC-032-051.** El UPDATE privilege de bridge continúa limitado conceptualmente al binding unbound.

**AC-032-052.** CORR-032 no requiere ampliar la policy UPDATE de bridge.

**AC-032-053.** CORR-032 no introduce general UPDATE policy.

**AC-032-054.** CORR-032 no introduce all-row UPDATE visibility para bridges bound.

**AC-032-055.** CORR-032 no introduce INSERT/DELETE privilege nuevo para `supabase_auth_admin`.

**AC-032-056.** CORR-032 no introduce acceso de `supabase_auth_admin` a `company_memberships`.

**AC-032-057.** CORR-032 no introduce acceso tenant general mediante service-role/secret credential.

**AC-032-058.** `anon` continúa sin CRUD directo sobre bridge/grant.

**AC-032-059.** `authenticated` continúa sin CRUD directo sobre bridge/grant.

**AC-032-060.** Browser/Data API directo no puede utilizar bridge/grant como authority.

**AC-032-061.** Initial password sin grant continúa denied.

**AC-032-062.** OTP initial auth continúa denied.

**AC-032-063.** TOTP initial auth continúa denied.

**AC-032-064.** Magic Link initial auth continúa denied.

**AC-032-065.** Recovery initial auth continúa denied.

**AC-032-066.** Signup/invite initial methods continúan denied.

**AC-032-067.** `email_change` continúa denied.

**AC-032-068.** OAuth/`oauth_provider`/`authorization_code` continúan denied.

**AC-032-069.** Anonymous initial auth continúa denied.

**AC-032-070.** Unknown initial auth methods continúan default-deny.

**AC-032-071.** `token_refresh` contract no es modificado por CORR-032.

**AC-032-072.** La migration histórica TASK-013 no se modifica.

**AC-032-073.** La implementación futura utiliza una migration nueva forward-only.

**AC-032-074.** La única función DB esperada a cambiar es `public.task_013_custom_access_token_hook(jsonb)`, salvo drift físico que obligue a bloquear.

**AC-032-075.** No se crea nueva tabla.

**AC-032-076.** No se crea nueva columna.

**AC-032-077.** No se crea nuevo constraint o índice por CORR-032.

**AC-032-078.** Technical-password derivation permanece intacta.

**AC-032-079.** Auth Admin purpose-specific boundary permanece intacta.

**AC-032-080.** TASK-011 SSR lifecycle permanece intacto.

**AC-032-081.** TASK-012 authoritative authorization permanece intacta.

**AC-032-082.** TASK-014 global authority permanece intacta.

**AC-032-083.** TASK-015 CompanyMembership/RLS permanece intacta.

**AC-032-084.** TASK-017 verification/handoff permanece intacta.

**AC-032-085.** TASK-018 orchestration/UI permanece intacta.

**AC-032-086.** Local DB/Hook tests cubren unbound success y already-bound same-subject success.

**AC-032-087.** Tests verifican que already-bound success no reescribe bridge binding columns.

**AC-032-088.** Tests cubren wrong subject y wrong email/correlation.

**AC-032-089.** Tests cubren missing/expired/revoked/consumed grant.

**AC-032-090.** Tests cubren same-grant concurrency con at most one success.

**AC-032-091.** Tests verifican ausencia de RLS/grant widening y tenant access.

**AC-032-092.** Existing TASK-013 negative Auth-method suite permanece passing.

**AC-032-093.** TASK-018 compatible-existing-identity local regression queda incluida cuando el harness lo permita.

**AC-032-094.** Local verification pasa antes de solicitar Hosted Development.

**AC-032-095.** Hosted Development requiere Gate humano separado.

**AC-032-096.** Hosted verifica fresh identity path después de la corrección.

**AC-032-097.** Hosted verifica compatible pre-bound same-subject path con session success.

**AC-032-098.** Hosted verifica wrong-subject fail-closed.

**AC-032-099.** Hosted verifica replay/expiry/revocation según fixture segura disponible.

**AC-032-100.** Hosted verifica que bridge binding no cambia en el pre-bound success path.

**AC-032-101.** Hosted verifica que no aparece tenant authority por la nueva sesión.

**AC-032-102.** Hosted verifica remote policy/grant state y `unexpected remote diff = NONE` fuera del cambio autorizado.

**AC-032-103.** Fixtures Local/Hosted son test-only, identificables, mínimas y descartables.

**AC-032-104.** Cleanup deja cero identidad/bridge/grant/authority test inesperados según fixtures creadas.

**AC-032-105.** Fixture cleanup failure bloquea cierre.

**AC-032-106.** Provider contract drift bloquea implementación.

**AC-032-107.** Necesidad inesperada de `SECURITY DEFINER` bloquea implementación.

**AC-032-108.** Necesidad de generic privileged access bloquea implementación.

**AC-032-109.** Necesidad de tenant privilege bloquea implementación.

**AC-032-110.** Necesidad de general UPDATE policy bloquea implementación.

**AC-032-111.** Necesidad de weaken SessionGrant semantics bloquea implementación.

**AC-032-112.** Necesidad de subject rebinding bloquea implementación.

**AC-032-113.** Necesidad de Auth Admin boundary expansion bloquea implementación.

**AC-032-114.** Necesidad de schema redesign bloquea implementación.

**AC-032-115.** Necesidad de TASK-018 application redesign bloquea implementación.

**AC-032-116.** Local regression failure bloquea Hosted.

**AC-032-117.** Hosted unexpected diff bloquea cierre.

**AC-032-118.** Git preflight fresco es obligatorio antes de implementación.

**AC-032-119.** Spec generation, implementation, Hosted, staging, commit, push y closure permanecen Gates separados.

**AC-032-120.** Esta especificación no autoriza staging.

**AC-032-121.** Esta especificación no autoriza commit.

**AC-032-122.** Esta especificación no autoriza push.

**AC-032-123.** CORR-032 closed no implica TASK-018 closed.

**AC-032-124.** Después del cierre de CORR-032 existe sólo retorno explícito a TASK-018 Work Item E para completar el blocker original.

**AC-032-125.** TASK-018 no se reanuda durante esta specification generation.

**AC-032-126.** TASK-019 permanece `NOT DETERMINED / NOT AUTHORIZED`.

**AC range:** `AC-032-001..AC-032-126`

**AC count:** `126`

---

## 33. Definition of Done

### 33.1 Specification generation

**DoD-032-001.** SOURCE 1 fue verificada byte-for-byte y coincide con la identidad aprobada.

**DoD-032-002.** SOURCE 2 fue verificada byte-for-byte y coincide con la identidad aprobada.

**DoD-032-003.** TASK-013 y ADR-0019 físicos estuvieron disponibles y fueron leídos.

**DoD-032-004.** Root cause aprobada fue consumida sin reabrirse.

**DoD-032-005.** Canonical decision A/B fue resuelta como A mediante evidencia física.

**DoD-032-006.** No se inventó requisito de producto.

**DoD-032-007.** No se modificó arquitectura.

**DoD-032-008.** Domain/ownership quedó definido sin modificar multitenancy.

**DoD-032-009.** Unbound path quedó especificado.

**DoD-032-010.** Already-bound same-subject path quedó especificado.

**DoD-032-011.** Wrong-subject y email/correlation denial quedaron especificados.

**DoD-032-012.** SessionGrant contract quedó preservado.

**DoD-032-013.** Locking/concurrency/atomicity quedaron especificados.

**DoD-032-014.** Se distinguieron column privilege y RLS row qualification.

**DoD-032-015.** Se determinó que no se requiere widening de bridge UPDATE policy/grants.

**DoD-032-016.** Threat model quedó definido.

**DoD-032-017.** Failure model quedó definido.

**DoD-032-018.** Forward-only migration governance quedó definido sin SQL ejecutable.

**DoD-032-019.** Objetos changed/preserved quedaron enumerados.

**DoD-032-020.** Test/regression plan quedó definido.

**DoD-032-021.** Local verification quedó definida sin inventar scripts.

**DoD-032-022.** Hosted verification futura quedó definida sin autorizarla.

**DoD-032-023.** Cleanup quedó definido.

**DoD-032-024.** Documentation impact quedó definido como `TASK-013 canonical semantic modification = NONE`.

**DoD-032-025.** AC-032-001..126 son consecutivos y verificables.

### 33.2 Central review / approval

**DoD-032-026.** `CORR-032 SPEC REVIEW = APPROVED` existe mediante Gate separado antes de aprobación humana del artefacto.

**DoD-032-027.** Correcciones solicitadas por review no amplían scope ni cambian A sin nueva evidencia física material.

**DoD-032-028.** Human spec approval requiere decisión explícita separada.

**DoD-032-029.** Approved artifact se genera sólo después del Gate correspondiente.

**DoD-032-030.** Approved artifact review verifica identidad física y ausencia de drift.

### 33.3 Canonicalization / repository incorporation

**DoD-032-031.** Canonicalization ocurre mediante Gate separado.

**DoD-032-032.** Canonical candidate preserva exactamente la specification aprobada.

**DoD-032-033.** Canonicalization review debe ser approved antes de repository incorporation.

**DoD-032-034.** Repository incorporation requiere autorización humana separada.

**DoD-032-035.** Incorporar la spec canónica no implementa la corrección.

### 33.4 Implementation authorization / local implementation

**DoD-032-036.** Existe autorización humana explícita de implementación antes de modificar repo/Supabase Local.

**DoD-032-037.** Preflight Git fresco confirma branch, HEAD, origin/main, divergence, worktree y ausencia de operación Git en progreso.

**DoD-032-038.** Se inspeccionan migrations, Hook, policies, grants y tests actuales antes de escribir.

**DoD-032-039.** Historical TASK-013 migration permanece byte-for-byte intacta.

**DoD-032-040.** Se crea exactamente la migration forward-only mínima requerida por el estado físico real autorizado.

**DoD-032-041.** Hook permanece `SECURITY INVOKER`.

**DoD-032-042.** No se amplía bridge UPDATE RLS/grants en la implementación esperada de esta specification.

**DoD-032-043.** Already-bound same-subject path pasa localmente y no reescribe bridge.

**DoD-032-044.** Unbound binding path sigue pasando localmente.

**DoD-032-045.** Wrong-subject/email/grant negative paths siguen pasando.

**DoD-032-046.** Concurrency demuestra at most one grant consume.

**DoD-032-047.** TASK-013/TASK-018 y privilege regressions aplicables pasan.

**DoD-032-048.** lint/typecheck/tests/build/verify/git diff check aplicables pasan conforme al repositorio real.

### 33.5 Implementation review / Hosted

**DoD-032-049.** Implementation review valida arquitectura, seguridad, RLS, multitenancy, scope y regresiones.

**DoD-032-050.** `CORR-032 IMPLEMENTATION PASS != HOSTED AUTHORIZED`.

**DoD-032-051.** Hosted Development recibe autorización humana separada.

**DoD-032-052.** Hosted aplica únicamente el cambio autorizado y verifica remote policies/grants.

**DoD-032-053.** Hosted compatible existing pre-bound same-subject path = PASS.

**DoD-032-054.** Hosted fresh path y negative subject/correlation paths permanecen correctos.

**DoD-032-055.** Hosted demuestra que bridge binding permanece sin cambio en el pre-bound success path.

**DoD-032-056.** Hosted demuestra ausencia de tenant authority derivada de la sesión.

**DoD-032-057.** Fixture cleanup = PASS y post-cleanup unexpected state = ZERO según fixtures creadas.

**DoD-032-058.** `HOSTED PASS != STAGING AUTHORIZED`.

### 33.6 Git / closure / return to TASK-018

**DoD-032-059.** Staging requiere Gate separado.

**DoD-032-060.** Commit requiere Gate separado.

**DoD-032-061.** Push requiere Gate separado.

**DoD-032-062.** Remote verification confirma commit autorizado y ausencia de drift.

**DoD-032-063.** Final human closure de CORR-032 ocurre mediante Gate separado.

**DoD-032-064.** `push PASS != CORR-032 closed`.

**DoD-032-065.** `CORR-032 closed != TASK-018 automatically closed`.

**DoD-032-066.** Sólo después del cierre explícito de CORR-032 se devuelve control a TASK-018 Work Item E.

**DoD-032-067.** TASK-018 debe reejecutar específicamente el compatible-existing-identity Hosted scenario que originó CORR-032.

**DoD-032-068.** TASK-019 no se determina automáticamente.

**DoD range:** `DoD-032-001..DoD-032-068`

**DoD count:** `68`

---

## 34. Autorevisión obligatoria

```text
new product requirement invented = NO

architecture changed = NO

ADR-0019 reopened = NO

tenant model changed = NO

general UPDATE authority introduced = NO

service-role ordinary path introduced = NO

SessionGrant bypass introduced = NO

silent rebinding introduced = NO

historical migration edited = NO

SQL executable included = NO

implementation performed = NO

Supabase mutation = NO

repository mutation = NO

TASK-018 resumed = NO

TASK-019 determined = NO
```

Verificación adicional:

```text
canonical decision = A
TASK-013 canonical semantic modification = NONE
expected RLS policy change = NONE
expected direct grant change = NONE
expected DB function change = task_013_custom_access_token_hook only
forward-only migration required for future implementation = YES
```

---

## 35. Resultado

```text
CORR-032 SPECIFICATION =
PASS
```

```text
implementation = NO
Codex = NO
repository mutation = NO
SQL executable = NO
new migration = NO
historical migration edit = NO
RLS mutation = NO
Supabase Local mutation = NO
Hosted Development mutation = NO
git add = NO
commit = NO
push = NO
TASK-018 Hosted retry = NO
TASK-019 determination = NO
```

```text
STOP
```

```text
DESTINO: REVISOR CENTRAL

NEXT GATE:
CORR-032 CANONICALIZATION REVIEW
```

No se determina ningún Gate posterior.
