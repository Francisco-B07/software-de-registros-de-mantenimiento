# CORR-041 — TASK-013 ADR-0022 / TASK-021 Pre-Issuance Shared Contract Synchronization

## 1. Identificación y estado de esta specification

**ID:** `CORR-041`

**Título:** `CORR-041 — TASK-013 ADR-0022 / TASK-021 Pre-Issuance Shared Contract Synchronization`

**Tipo:** `DOCUMENTATION / STATE-MACHINE / SHARED AUTH BOUNDARY SYNCHRONIZATION`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context principal:** `Identity & Auth`

**Estado de esta entrega:** `HUMAN APPROVED / APPROVED ARTIFACT APPROVED / CANONICAL ARTIFACT GENERATED / PENDING CANONICALIZATION REVIEW`

**Ruta canónica futura propuesta:**

`docs/tasks/CORR-041-task-013-adr-0022-task-021-pre-issuance-shared-contract-sync.md`

Estado obligatorio:

```text
CORR-041 SPECIFICATION GENERATION RESUME =
PASS

CORR-041 SPEC REVIEW =
APPROVED

CORR-041 HUMAN SPEC APPROVAL =
APPROVED

CORR-041 specification =
HUMAN APPROVED

CORR-041 approved artifact =
APPROVED

CORR-041 CANONICALIZATION AUTHORIZATION =
APPROVED

CORR-041 canonical artifact =
GENERATED / PENDING CANONICALIZATION REVIEW

canonical target path =
docs/tasks/CORR-041-task-013-adr-0022-task-021-pre-issuance-shared-contract-sync.md

selected ownership model =
OWNERSHIP-SEQUENCE-02

sync impact class =
C2 — TASK-013 SHARED IMPLEMENTATION CHANGE REQUIRED WITHIN TASK-021

CORR-041 purpose =
DOCUMENTATION / STATE-MACHINE / SHARED CONTRACT SYNCHRONIZATION

separate CORR-041 implementation =
NO

TASK-021 implementation =
NOT AUTHORIZED

repository mutation =
NONE

Supabase mutation =
NONE

Codex =
NOT AUTHORIZED
```

Esta specification no constituye implementación, no autoriza Codex, no modifica el repositorio, no ejecuta SQL y no autoriza ningún cambio en Supabase.

---

## 2. Objetivo único

CORR-041 sincroniza normativamente la foundation histórica TASK-013 con la qualification posterior aprobada por ADR-0022 y consumida por TASK-021.

Su único objetivo es fijar antes de cualquier futura autorización de implementación TASK-021:

1. la qualification estricta del Auth Admin boundary para exact-subject reconciliation;
2. la diferencia entre el flow histórico TASK-013 y el flow TASK-021;
3. el shared state-machine contract del Hook/SessionGrant que TASK-021 deberá implementar;
4. el ownership físico inequívoco de TASK-021 sobre el delta;
5. las regresiones de TASK-013/CORR-023/CORR-032/CORR-038 que TASK-021 deberá preservar;
6. la conservación íntegra de RLS, multitenancy y `authenticated != authorized`.

CORR-041 no posee una implementación física separada.

---

## 3. Fuentes de verdad e identidad física consumida

Las siete fuentes obligatorias estuvieron físicamente disponibles para este Gate.

| Fuente | Path canónico | SHA-256 observado |
|---|---|---|
| ADR-0019 | `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md` | `41a2f5fcd57ca26fd52ca318fc2714c5188e9c03ab5f3d58ab55f92bd98b5e09` |
| ADR-0022 | `docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md` | `1221f653d59c44af691ea314f77660b9f66e2f691cfc4fc2afd96e3891fe7e9c` |
| TASK-013 | `docs/tasks/TASK-013-verification-challenge-foundation.md` | `08b276e2175a3f795f8a7f3ed242c6e2bf946f745c7eba1df8437810d5b07648` |
| TASK-021 | `docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md` | `d0106d83633b616099f6772702ee80f4700115186e938047e19a81edba865c43` |
| CORR-023 | `docs/tasks/CORR-023-task-013-local-db-regression-runner-supabase-auth-admin.md` | `2f98a2b8be4e1ff33cecb1b57c4b794041bc6531faf15a207a9c1801801d1fe6` |
| CORR-032 | `docs/tasks/CORR-032-task-013-auth-bridge-prebound-hook-correction.md` | `b70dab1455d5dc6584dbd9cad6e12dea0bef8cab1a370ff7b7233d180674dd2e` |
| CORR-038 | `docs/tasks/CORR-038-corr-032-canonical-alt-001-precondition-gate-cancellation-harness-compatibility.md` | `e1d0a197867ad3dac18330253749e72a5ced6f0540fccc34bef28d83180380f0` |

Las identidades críticas exigidas por el Gate pasan exactamente:

```text
CORR-023 identity = PASS
CORR-032 identity = PASS
TASK-021 identity = PASS
ADR-0022 approved/canonical identity = PASS
CORR-038 canonical identity = PASS
all mandatory canonical sources = AVAILABLE
```

No se usa memoria, summaries o conversaciones históricas como sustituto de estas fuentes físicas.

---

## 4. Preflight de identidad CORR-041

Resultado:

```text
CORR-040 =
ALREADY USED

CORR-041 =
NOT ALREADY ASSIGNED

CORR-041 collision =
NO
```

No se renumera ni se reutiliza otro ID.

---

## 5. Orden de autoridad y decisión de ownership

La decisión de ownership queda cerrada como:

```text
OWNERSHIP-SEQUENCE-02 =
CORR-041 CONTRACT/DOCUMENTATION SYNC BEFORE TASK-021;
PHYSICAL SHARED-BOUNDARY DELTA OWNED BY TASK-021
```

Clasificación:

```text
sync impact class =
C2 — TASK-013 SHARED IMPLEMENTATION CHANGE REQUIRED WITHIN TASK-021
```

Interpretación normativa:

```text
TASK-013 shared physical boundary must change =
YES

separate CORR-041 code/DB implementation =
NO

physical owner of that future change =
TASK-021

CORR-041 must close before TASK-021 implementation authorization =
YES
```

La selección C2 resuelve el blocker previo de ownership/sequencing sin reabrir ADR-0019 ni ADR-0022.

---

## 6. TASK-013 histórico permanece cerrado

Debe preservarse:

```text
TASK-013 =
DONE / CLOSED HISTORICALLY

TASK-013 historical canonical artifact =
NOT REWRITTEN
```

CORR-041 no pretende hacer parecer que TASK-013 ya conocía ADR-0022 en su fecha de cierre.

Se distinguen dos capas:

```text
TASK-013 historical E2 contract
!=
ADR-0022 / TASK-021 later qualification
```

La qualification posterior vive en CORR-041 y será materializada físicamente sólo por TASK-021.

---

## 7. ADR-0019 core E2 — sin cambio

Permanece:

```text
ADR-0019 core E2 =
APPLICATION-OWNED VERIFICATION CHALLENGE
+ ONE-TIME SESSION GRANT
+ SERVER-ONLY TECHNICAL PASSWORD BRIDGE
+ CUSTOM ACCESS TOKEN HOOK GATE
```

Pruebas separadas:

```text
business proof =
VerificationChallenge

provider proof =
technical password server-only

session authorization proof =
one-time SessionGrant
```

CORR-041 no redefine E2.

---

## 8. Qualification ADR-0022 del Auth Admin boundary

Para ADR-0022 / TASK-021 later-user pre-issuance reconciliation únicamente:

```text
auth.admin.getUserById(exact_expected_auth_subject_id)
=
AUTHORIZED PURPOSE-SPECIFIC ADMIN OPERATION
```

El exact expected subject puede derivar sólo de:

```text
bound bridge
→ AuthBridgeCredential.auth_user_id
```

o de:

```text
unbound bridge
→ server-reserved UUID
→ durable persistence by same logical operation
→ exact-ID provider reconciliation
```

Permanece prohibido:

```text
arbitrary getUserById = NO
caller-selected Auth subject = NO
browser-selected Auth subject = NO
email-derived Auth directory lookup = NO
listUsers = NO
generic email lookup = NO
full-directory scan = NO
generic auth.admin export = NO
generic privileged Supabase client = NO
ordinary service-role business/data client = NO
```

La qualification no concede tenant authority ni modifica la autoridad de `PlatformUser` o `CompanyMembership`.

---

## 9. Qualification del flow unbound TASK-021

El flow histórico TASK-013 no se reescribe para otros flows.

Para TASK-021 exclusivamente:

```text
preliminary/discovery signInWithPassword =
PROHIBITED
```

Contrato:

```text
server reserves UUID v4
→ reserved UUID is durably persisted before provider mutation
→ exact getUserById(reserved_uuid)
→ if reliably absent and all preconditions remain valid:
   createUser(id = reserved_uuid)
→ ambiguous provider result:
   exact getUserById(reserved_uuid) only
→ exact subject confirmed
→ bridge bound to exact subject
→ application compatibility/fence
→ final signInWithPassword
```

Failure constraints consumidos de TASK-021:

```text
exact-ID lookup outage
→ PROVISIONING_UNKNOWN
→ no blind create
→ no final sign-in
```

```text
duplicate/conflict
+
reserved exact UUID still absent
→ REPAIR_REQUIRED
```

No existe fallback a email lookup o directory enumeration.

---

## 10. Qualification del flow bound TASK-021

Cuando:

```text
AuthBridgeCredential.auth_user_id IS NOT NULL
```

entonces:

```text
expected_auth_subject_id =
AuthBridgeCredential.auth_user_id
```

y el único lookup permitido es:

```text
auth.admin.getUserById(expected_auth_subject_id)
```

Debe permanecer:

```text
wrong subject =
FAIL CLOSED

email =
LOCATOR / CORRELATION ONLY

email as identity authority =
NO
```

CORR-032 ya preserva que un bridge pre-bound al mismo subject puede continuar con grant válido y sin rebinding. CORR-041 no modifica esa semántica.

---

## 11. Server-side final sign-in boundary

El Auth Admin boundary y el technical sign-in boundary continúan separados.

```text
Auth Admin exact-subject reconciliation
!=
final signInWithPassword
```

Para TASK-021:

```text
signInWithPassword =
FINAL PROVIDER SESSION ISSUANCE STEP ONLY
```

No puede usarse para:

```text
subject discovery
email-directory lookup
create-response-loss discovery
```

El final sign-in permanece server-side, con la technical password server-only y sin reutilizar el Admin client.

---

## 12. Custom Access Token Hook — shared contract

Permanece:

```text
Custom Access Token Hook =
PLATFORM-OWNED AUTH GATE

SECURITY INVOKER =
PRESERVED

default-deny initial issuance =
PRESERVED
```

Para el futuro TASK-021 path, el Hook sólo puede consumir platform-owned state necesario para probar:

```text
event.user_id =
exact expected subject

authentication_method =
password

AuthBridgeCredential =
prebound to exact subject

LaterUserInitialSessionCoordination.state =
ISSUANCE_ACTIVE

SessionGrant =
matching + active + eligible
```

Consume exitoso:

```text
ISSUANCE_ACTIVE
→ GATE_CONSUMED
```

El Hook no realiza first-time TASK-021 subject discovery ni binding.

El Hook no obtiene authority de:

```text
MaintenanceCompany
PlatformUser tenant authority
CompanyMembership
tenant role
Client
UserClientAccess
SupportAccessGrant
subscription entitlement
```

---

## 13. SessionGrant — invariantes preservadas

Permanece exactamente:

```text
purpose =
initial_session

auth_method =
password

TTL =
EXACTLY 5 MINUTES

single-use =
YES

consumed =
TERMINAL

revoked =
TERMINAL

resurrection =
NO

browser bearer authority =
NO
```

CORR-041 no amplía TTL, no introduce reuse y no modifica `token_refresh`.

---

## 14. Ownership físico futuro de TASK-021

TASK-021 conserva ownership exclusivo del delta físico sobre:

```text
public.auth_subject_authority_anchors
public.later_user_initial_session_coordinations
coordination lifecycle constraints
single-active constraints/indexes
purpose-specific DB functions
minimum grants/revokes
coordination-aware Custom Access Token Hook delta
exact-subject Auth Admin adapter
bridge/session orchestration
related DB/TypeScript/concurrency regressions
```

CORR-041 no crea ni modifica ninguno de esos objetos.

---

## 15. Invariante de deployment para TASK-021

El futuro TASK-021 debe evitar:

```text
Hook requires nonexistent coordination objects
```

y también:

```text
TASK-021 orchestration activated
while required coordination-aware Hook gate is absent
```

La implementación DB futura deberá mantener una boundary coherente para:

```text
coordination schema
+ constraints/indexes
+ purpose-specific functions
+ minimum privileges
+ Hook coordination delta
```

La activación de orchestration sólo puede ocurrir contra un DB/Hook contract compatible.

CORR-041 documenta este invariante; no lo implementa.

---

## 16. CORR-032 — preservación obligatoria

CORR-032 queda consumida sin reinterpretación.

Debe permanecer:

```text
AuthBridgeCredential already-bound + same subject
+ fresh eligible SessionGrant
→ may continue

rebind =
NO

bridge auth_user_id rewrite =
NO

bound_at rewrite =
NO

SessionGrant bypass =
NO
```

Para el already-bound path, el SessionGrant permanece serialization point del consume single-use y la bridge se valida sin exigir una mutación de binding inexistente.

CORR-041 no modifica el RLS/grant model de CORR-032 ni reabre su decisión canónica A.

---

## 17. CORR-038 — harness/concurrency preservation

CORR-038 permanece autoridad posterior sobre la compatibilidad del harness CORR-032 con ALT-001.

Debe permanecer:

```text
CORR-032 concurrency semantics =
UNCHANGED

C032-CON coverage =
PRESERVED

canonical ALT-001 =
PRESERVED

bounded waits =
PRESERVED

cleanup =
PRESERVED

product role/grant/RLS mutation =
NO
```

CORR-041 no modifica ningún harness CORR-038.

---

## 18. CORR-023 — regression runner preservation

CORR-023 permanece una corrección de infraestructura de test local.

Debe permanecer:

```text
production capability change =
NO

TASK-013 production semantic change =
NO

Custom Access Token Hook production correction by CORR-023 =
NO

supabase_auth_admin tenant privileges =
NO

RLS productiva =
UNCHANGED
```

Su ALT-001 continúa distinguiendo:

```text
local test runner privilege
!=
product authorization
```

El future TASK-021 regression contract debe ejecutar las regresiones aplicables de TASK-013 mediante el harness vigente resultante de CORR-023, sin convertir `supabase_admin` o `supabase_auth_admin` en runtime clients de aplicación.

---

## 19. Multitenancy / RLS / authority

Permanece:

```text
tenant =
MaintenanceCompany

multiempresa isolation =
MANDATORY

tenant data RLS =
MANDATORY

tenant model change =
NO

tenant authority change =
NO

RLS change =
NO

RLS weakening =
NO

SUPER_ADMIN ordinary tenant bypass =
NO

service-role ordinary tenant path =
NO

authenticated != authorized =
PRESERVED

Auth session != tenant authorization =
PRESERVED
```

Una Auth session TASK-021 no crea por sí sola:

```text
PlatformUser
CompanyMembership
tenant role
Client scope
SupportAccessGrant
subscription entitlement
tenant authorization
```

---

## 20. Future TASK-021 regression obligations expuestas por CORR-041

Estas obligaciones pertenecen a la futura implementación TASK-021; no son implementación de CORR-041.

Como mínimo TASK-021 deberá demostrar:

```text
EXACT-ADMIN-01
exact expected subject getUserById succeeds through purpose-specific boundary

EXACT-ADMIN-02
arbitrary/caller-selected subject lookup is structurally rejected

EXACT-ADMIN-03
listUsers is absent

EXACT-ADMIN-04
email-directory lookup is absent

UNBOUND-01
reserved UUID persisted before provider mutation

UNBOUND-02
exact-ID lookup precedes create

UNBOUND-03
createUser uses the reserved UUID

UNBOUND-04
ambiguous create result reconciles via exact ID only

UNBOUND-05
lookup outage → PROVISIONING_UNKNOWN / no sign-in / no blind create

UNBOUND-06
duplicate/conflict + reserved UUID absent → REPAIR_REQUIRED

BOUND-01
bound bridge uses exact bound subject only

SIGNIN-01
no preliminary/discovery signInWithPassword for TASK-021

SIGNIN-02
final signInWithPassword remains server-only/nonprivileged

HOOK-01
TASK-021 issuance requires prebound bridge

HOOK-02
TASK-021 issuance requires matching ISSUANCE_ACTIVE coordination

HOOK-03
wrong/missing coordination → DENY

HOOK-04
matching grant/user/method → one GATE_CONSUMED transition

HOOK-05
Hook does not first-bind TASK-021 subject

HOOK-06
Hook reads no tenant authority

PRIV-01
supabase_auth_admin has no tenant privileges

GRANT-01
SessionGrant TTL remains exactly 5 minutes

GRANT-02
consumed/revoked grants never resurrect

REG-01
existing TASK-013 regressions pass

REG-02
CORR-023 runner remains passing

REG-03
CORR-032 concurrency semantics remain passing

REG-04
CORR-038 harness compatibility remains passing

REG-05
first-admin existing flows remain behaviorally unchanged
```

Exact commands/scripts must be resolved against the repository real during the future TASK-021 implementation preflight; CORR-041 does not invent script names.

---

## 21. Provider-contract revalidation deferred to TASK-021

Before future TASK-021 implementation, the provider/SDK behavior used by S1 must be freshly revalidated for:

```text
auth.admin.createUser with explicit custom id
auth.admin.getUserById exact UUID
signInWithPassword
Custom Access Token Hook
```

CORR-041 no performs provider mutation and does not claim a provider guarantee beyond the canon already approved.

Provider drift that invalidates S1 remains a TASK-021 blocker, not a reason to expand CORR-041.

---

## 22. Documentation impact y ausencia de implementación CORR-041

CORR-041 is the canonical later qualification artifact.

It does not modify:

```text
docs/tasks/TASK-013-verification-challenge-foundation.md
docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md
docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md
docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md
```

Implementation impact:

```text
sync impact class =
C2 — TASK-013 SHARED IMPLEMENTATION CHANGE REQUIRED WITHIN TASK-021

physical TASK-013 shared-boundary delta required =
YES

separate CORR-041 code/DB implementation =
NO

physical owner =
TASK-021
```

CORR-041 therefore has no Codex implementation decomposition of its own.

---

## 23. Blockers

CORR-041 must fail closed or return to Revisor Central if any future review establishes:

```text
required canonical source identity mismatch
CORR-041 ID collision
TASK-021 canonical identity mismatch
ADR-0019 core E2 change required
ADR-0022 contradiction
generic Auth Admin required
arbitrary getUserById required
email/listUsers directory required
SessionGrant semantic change required
tenant privilege required
RLS weakening required
service-role ordinary business/data path required
CORR-032 semantics conflict
CORR-038 bounded-wait/cleanup conflict
ownership of the physical delta cannot remain uniquely TASK-021
new architecture decision required
```

No blocker may be resolved by silent scope expansion.

---

## 24. Acceptance Criteria

**AC-041-001.** CORR-041 se limita a documentación, state-machine contract y shared Auth boundary synchronization.

**AC-041-002.** El artefacto canónico histórico de TASK-013 permanece sin modificación.

**AC-041-003.** ADR-0019 core E2 permanece sin cambio.

**AC-041-004.** ADR-0022 se consume como qualification posterior y no se modifica.

**AC-041-005.** El modelo de ownership seleccionado es OWNERSHIP-SEQUENCE-02.

**AC-041-006.** La clasificación de impacto queda fijada como C2 — TASK-013 SHARED IMPLEMENTATION CHANGE REQUIRED WITHIN TASK-021.

**AC-041-007.** CORR-041 no posee implementación code/DB separada.

**AC-041-008.** CORR-041 debe cerrar antes de cualquier TASK-021 IMPLEMENTATION AUTHORIZATION.

**AC-041-009.** TASK-021 conserva ownership físico de `public.auth_subject_authority_anchors`.

**AC-041-010.** TASK-021 conserva ownership físico de `public.later_user_initial_session_coordinations`.

**AC-041-011.** TASK-021 conserva ownership de constraints/indexes purpose-specific de coordinación.

**AC-041-012.** TASK-021 conserva ownership de funciones DB purpose-specific asociadas al flow.

**AC-041-013.** TASK-021 conserva ownership de grants/revokes mínimos requeridos por su flow.

**AC-041-014.** TASK-021 conserva ownership del delta coordination-aware del Custom Access Token Hook.

**AC-041-015.** TASK-021 conserva ownership del adapter exact-subject Auth Admin.

**AC-041-016.** TASK-021 conserva ownership de bridge/session orchestration y tests relacionados.

**AC-041-017.** `auth.admin.getUserById(exact_expected_auth_subject_id)` queda autorizado únicamente para ADR-0022/TASK-021 pre-issuance reconciliation.

**AC-041-018.** El subject de `getUserById` debe proceder de un binding autoritativo o de UUID reservado durablemente por la misma operación lógica TASK-021.

**AC-041-019.** `arbitrary getUserById` permanece prohibido.

**AC-041-020.** Caller/browser-selected Auth subject permanece prohibido.

**AC-041-021.** Email-derived Auth directory lookup permanece prohibido.

**AC-041-022.** `listUsers` y full-directory scan permanecen prohibidos.

**AC-041-023.** Generic Auth Admin export permanece prohibido.

**AC-041-024.** Generic privileged Supabase client permanece prohibido.

**AC-041-025.** Ordinary service-role business/data client permanece prohibido.

**AC-041-026.** Para TASK-021, preliminary/discovery `signInWithPassword` permanece prohibido.

**AC-041-027.** El flow unbound TASK-021 reserva un UUID server-side y lo persiste antes de cualquier provider mutation.

**AC-041-028.** El flow unbound usa exact `getUserById` sobre el UUID reservado antes de `createUser` cuando corresponda.

**AC-041-029.** `createUser` TASK-021 usa exactamente el UUID reservado de la misma operación lógica.

**AC-041-030.** Un resultado ambiguo de `createUser` se reconcilia sólo mediante exact-ID lookup del UUID reservado.

**AC-041-031.** Provider exact-ID lookup outage no autoriza blind create ni final sign-in y debe permanecer fail-closed según TASK-021.

**AC-041-032.** Duplicate/conflict con UUID reservado ausente conserva el resultado `REPAIR_REQUIRED` definido por TASK-021.

**AC-041-033.** Para bridge bound, el exact expected subject es `AuthBridgeCredential.auth_user_id`.

**AC-041-034.** El flow bound no usa email ni directory lookup como authority.

**AC-041-035.** El bridge TASK-021 debe estar prebound al exact subject antes del final `signInWithPassword`.

**AC-041-036.** El final `signInWithPassword` permanece server-side y no privilegiado, separado del Admin boundary.

**AC-041-037.** Custom Access Token Hook permanece un PLATFORM-OWNED AUTH GATE.

**AC-041-038.** El Hook TASK-021 no realiza first-time subject discovery/binding.

**AC-041-039.** El Hook TASK-021 requiere exact `user_id`, `authentication_method=password`, bridge prebound, coordinación `ISSUANCE_ACTIVE` y SessionGrant elegible.

**AC-041-040.** El consume exitoso del gate produce la transición durable `GATE_CONSUMED` conforme a TASK-021.

**AC-041-041.** `token_refresh` permanece separado y sin cambio.

**AC-041-042.** SessionGrant conserva `purpose=initial_session`.

**AC-041-043.** SessionGrant conserva `auth_method=password`.

**AC-041-044.** SessionGrant TTL permanece exactamente 5 minutos.

**AC-041-045.** SessionGrant permanece single-use.

**AC-041-046.** SessionGrant consumed/revoked permanece terminal y no resucitable.

**AC-041-047.** Una Auth session válida continúa sin equivaler a tenant authorization.

**AC-041-048.** Tenant permanece `MaintenanceCompany`.

**AC-041-049.** Multiempresa isolation permanece obligatoria.

**AC-041-050.** RLS de datos tenant permanece obligatoria y no se debilita por CORR-041.

**AC-041-051.** `SUPER_ADMIN ordinary tenant bypass = NO` permanece vigente.

**AC-041-052.** No se introduce ordinary service-role tenant path.

**AC-041-053.** CORR-032 prebound/same-subject semantics permanecen sin cambio.

**AC-041-054.** CORR-032 grant single-use/concurrency y no-rebinding permanecen sin cambio.

**AC-041-055.** CORR-038 preserva el harness de concurrencia de CORR-032 bajo ALT-001.

**AC-041-056.** CORR-038 bounded waits y cleanup permanecen obligatorios.

**AC-041-057.** CORR-023 continúa siendo sólo test-harness regression correction y no altera privilegios productivos de `supabase_auth_admin`.

**AC-041-058.** El future TASK-021 regression contract debe mantener las suites TASK-013 y CORR-023 aplicables pasando.

**AC-041-059.** El future TASK-021 regression contract debe mantener CORR-032/CORR-038 concurrency/harness semantics pasando.

**AC-041-060.** El future TASK-021 regression contract debe cubrir exact-ID positive/negative cases, ausencia de directory lookup y ausencia de preliminary sign-in discovery.

**AC-041-061.** El future TASK-021 regression contract debe cubrir Hook coordination, `ISSUANCE_ACTIVE`, `GATE_CONSUMED`, SessionGrant single-use y ausencia de tenant reads.

**AC-041-062.** CORR-041 no crea migration, SQL, código TypeScript, modificación de Hook ni modificación de tests.

**AC-041-063.** CORR-041 no modifica Supabase Local, Hosted Development, Staging ni Production.

**AC-041-064.** TASK-021 canonical correction requerida = NO.

**AC-041-065.** Nueva decisión arquitectónica requerida = NO bajo ADR-0019 + ADR-0022 y OWNERSHIP-SEQUENCE-02.

**AC-041-066.** TASK-021 implementation permanece NOT AUTHORIZED después de esta specification generation.

Control:

```text
AC count = 66
AC range = AC-041-001..AC-041-066
AC consecutive = YES
```

---

## 25. Definition of Done

CORR-041 has an exclusively documentary lifecycle.

**DoD-041-001.** La specification física CORR-041 existe con filename exacto aprobado para review.

**DoD-041-002.** Todas las siete fuentes obligatorias fueron físicamente disponibles durante la generación.

**DoD-041-003.** CORR-023 coincide con SHA-256 `2f98a2b8be4e1ff33cecb1b57c4b794041bc6531faf15a207a9c1801801d1fe6`.

**DoD-041-004.** CORR-032 coincide con SHA-256 `b70dab1455d5dc6584dbd9cad6e12dea0bef8cab1a370ff7b7233d180674dd2e`.

**DoD-041-005.** TASK-021 coincide con SHA-256 `d0106d83633b616099f6772702ee80f4700115186e938047e19a81edba865c43`.

**DoD-041-006.** ADR-0022 approved/canonical artifact coincide con SHA-256 `1221f653d59c44af691ea314f77660b9f66e2f691cfc4fc2afd96e3891fe7e9c`.

**DoD-041-007.** CORR-038 canonical coincide con SHA-256 `e1d0a197867ad3dac18330253749e72a5ced6f0540fccc34bef28d83180380f0`.

**DoD-041-008.** `CORR-041 SPEC REVIEW = APPROVED` ocurre mediante Gate separado.

**DoD-041-009.** La human spec approval ocurre mediante Gate separado.

**DoD-041-010.** El approved artifact se genera únicamente después de human spec approval.

**DoD-041-011.** El approved artifact review verifica identidad física y ausencia de drift.

**DoD-041-012.** Canonicalization authorization ocurre mediante Gate separado.

**DoD-041-013.** Canonicalization copia exclusivamente el artefacto aprobado autorizado.

**DoD-041-014.** Canonicalization review debe aprobarse antes de repository incorporation.

**DoD-041-015.** Repository incorporation authorization ocurre mediante Gate separado.

**DoD-041-016.** Repository incorporation incorpora exclusivamente el path canónico autorizado.

**DoD-041-017.** Repository incorporation review verifica scope e identidad.

**DoD-041-018.** Commit authorization ocurre mediante Gate separado.

**DoD-041-019.** El commit documental contiene exclusivamente el artefacto CORR-041 autorizado.

**DoD-041-020.** Commit review verifica parent, subject, paths y blob identity.

**DoD-041-021.** Push authorization ocurre mediante Gate separado.

**DoD-041-022.** Push normal/non-force ocurre únicamente después de autorización.

**DoD-041-023.** Remote verification confirma el commit autorizado y `origin/main` esperado.

**DoD-041-024.** Final human closure de CORR-041 ocurre mediante Gate separado.

**DoD-041-025.** CORR-041 final closure demuestra que no existió code/DB implementation propia.

**DoD-041-026.** CORR-041 final closure preserva TASK-013 histórico sin reescritura.

**DoD-041-027.** CORR-041 final closure preserva ADR-0019 y ADR-0022 sin modificación.

**DoD-041-028.** CORR-041 final closure preserva OWNERSHIP-SEQUENCE-02.

**DoD-041-029.** CORR-041 final closure preserva C2 como shared physical delta owned by TASK-021.

**DoD-041-030.** CORR-041 final closure no autoriza automáticamente TASK-021 implementation.

**DoD-041-031.** Un futuro TASK-021 IMPLEMENTATION AUTHORIZATION requiere Gate humano separado después del cierre de CORR-041.

**DoD-041-032.** No existe Gate CORR-041 de code implementation, DB implementation, Hosted mutation ni implementation staging.

**DoD-041-033.** Ningún Gate de CORR-041 implica automáticamente el siguiente.

**DoD-041-034.** Todos los AC-041 y DoD-041 permanecen consecutivos y reviewables.

Control:

```text
DoD count = 34
DoD range = DoD-041-001..DoD-041-034
DoD consecutive = YES
```

Explicitly not part of CORR-041 lifecycle:

```text
separate code implementation authorization
code implementation
DB implementation
Supabase Hosted mutation
implementation review
implementation staging
```

---

## 26. Governance lifecycle

Required sequence:

```text
specification generation
→ spec review
→ human spec approval
→ approved artifact generation
→ approved artifact review
→ canonicalization authorization
→ canonicalization
→ canonicalization review
→ repository incorporation authorization
→ repository incorporation
→ repository incorporation review
→ commit authorization
→ commit
→ commit review
→ push authorization
→ push
→ remote verification
→ final human closure
```

No Gate implies the next.

After CORR-041 final human closure, TASK-021 still requires a separate explicit implementation authorization.

---

## 27. Estado resultante

```text
CORR-041 SPECIFICATION GENERATION RESUME =
PASS

CORR-041 SPEC REVIEW =
APPROVED

CORR-041 HUMAN SPEC APPROVAL =
APPROVED

CORR-041 specification =
HUMAN APPROVED

CORR-041 approved artifact =
APPROVED

CORR-041 CANONICALIZATION AUTHORIZATION =
APPROVED

CORR-041 canonical artifact =
GENERATED / PENDING CANONICALIZATION REVIEW

canonical target path =
docs/tasks/CORR-041-task-013-adr-0022-task-021-pre-issuance-shared-contract-sync.md

selected ownership model =
OWNERSHIP-SEQUENCE-02

sync impact class =
C2 — TASK-013 SHARED IMPLEMENTATION CHANGE REQUIRED WITHIN TASK-021

CORR-041 purpose =
DOCUMENTATION / STATE-MACHINE / SHARED CONTRACT SYNCHRONIZATION

separate CORR-041 implementation =
NO

TASK-013 historical closure =
PRESERVED

TASK-021 physical implementation ownership =
YES

TASK-021 canonical correction required =
NO

ADR-0019 core E2 change =
NO

ADR-0022 qualification consumption =
YES

SessionGrant semantic change =
NO

tenant model change =
NO

tenant authority change =
NO

RLS change =
NO

new architecture decision required =
NO

TASK-021 implementation =
NOT AUTHORIZED

repository mutation =
NONE

Supabase mutation =
NONE

Codex =
NOT AUTHORIZED

staging =
NO

commit =
NO

push =
NO
```

---

## 28. Resultado formal

```text
CORR-041 SPECIFICATION GENERATION RESUME =
PASS

CORR-041 SPEC REVIEW =
APPROVED

CORR-041 HUMAN SPEC APPROVAL =
APPROVED

CORR-041 SPECIFICATION =
HUMAN APPROVED

CORR-041 APPROVED ARTIFACT =
APPROVED

CORR-041 CANONICALIZATION AUTHORIZATION =
APPROVED

CORR-041 CANONICAL ARTIFACT =
GENERATED / PENDING CANONICALIZATION REVIEW

canonical target path =
docs/tasks/CORR-041-task-013-adr-0022-task-021-pre-issuance-shared-contract-sync.md

next Gate =
CORR-041 CANONICALIZATION REVIEW
```

**FIN DE CORR-041 SPECIFICATION**
