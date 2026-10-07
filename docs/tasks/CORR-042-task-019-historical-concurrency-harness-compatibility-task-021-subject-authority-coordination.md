# CORR-042 — TASK-019 Historical Concurrency Harness Compatibility with TASK-021 Subject-Authority Coordination

## 1. Identificación y estado

**ID:** `CORR-042`
**Tipo:** `TEST HARNESS / CONCURRENCY COMPATIBILITY CORRECTION`
**Estado:** `HUMAN APPROVED / CANONICAL ARTIFACT GENERATED / PENDING CANONICALIZATION REVIEW`

```text
CORR-042 DETERMINATION =
APPROVED — HISTORICAL HARNESS COMPATIBILITY CORRECTION REQUIRED

CORR-042 SPECIFICATION GENERATION AUTHORIZATION =
APPROVED

CORR-042 SPEC REVIEW =
APPROVED

CORR-042 HUMAN SPEC APPROVAL =
APPROVED

CORR-042 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-042 CANONICALIZATION AUTHORIZATION =
APPROVED

CORR-042 canonicalization =
PASS

CORR-042 canonical artifact =
GENERATED / PENDING CANONICALIZATION REVIEW

canonical target path =
docs/tasks/CORR-042-task-019-historical-concurrency-harness-compatibility-task-021-subject-authority-coordination.md

CORR-042 specification =
HUMAN APPROVED

CORR-042 approved artifact =
APPROVED

CORR-042 repository incorporation =
NOT AUTHORIZED

root cause class =
CLASS-D

TASK-021 production defect =
NO — NOT DEMONSTRATED

TASK-019 production contract regression =
NO — NOT DEMONSTRATED

historical harness defect =
YES

production correction required =
NO

harness correction required =
YES

CORR-042 implementation =
NOT AUTHORIZED

repository mutation =
NO

Supabase mutation =
NO

Codex =
NOT USED

staging =
NO

commit =
NO

push =
NO
```

TASK-021 permanece:

```text
TASK-021 IMPLEMENTATION =
PARTIAL

TASK-021 IMPLEMENTATION REVIEW =
BLOCKED

Work Items A..G =
PRESERVED / NOT REOPENED

Work Item H =
BLOCKED PENDING CORR-042

Work Item I =
NOT AUTHORIZED TO PROCEED BY INFERENCE
```

## 2. Objetivo

Especificar una corrección bounded y exclusivamente test/harness para restaurar determinismo y cleanup completo en el harness histórico de concurrencia de TASK-019 bajo el modelo físico aprobado de TASK-021.

Único path candidato:

`supabase/tests/database/task_019_first_admin_profile_completion_concurrency.test.ps1`

CORR-042 no corrige producción, no cambia arquitectura, no cambia lock order, no amplía privilegios y no modifica RLS o multitenancy.

## 3. Fuentes y hechos autoritativos

```text
F-021-H-001 =
CONFIRMED — HISTORICAL TRANSIENT-OBSERVABILITY ASSERTION IS NON-DETERMINISTIC
UNDER CURRENT APPROVED COORDINATION MODEL

F-021-H-002 =
CONFIRMED — HISTORICAL TASK-019 HARNESS CLEANUP DOES NOT ACCOUNT FOR
TASK-021 AUTH-SUBJECT AUTHORITY ANCHOR FIXTURES

root cause class =
CLASS-D — HISTORICAL HARNESS COMPATIBILITY CORRECTION REQUIRED
```

Baseline físico:

```text
path =
supabase/tests/database/task_019_first_admin_profile_completion_concurrency.test.ps1

SHA-256 =
82573bfd40310805a6b026bbf99b47f5fc010815368a0f45cf73b74399af211b

Git state =
TRACKED / UNMODIFIED AGAINST HEAD

commit introducing current identity =
9ddaffaa4c89041640547fdef951b4e2d018dbc5
```

Referencia histórica no recuperable como baseline:

```text
historical SHA-256 =
2eccefaad900b7c15ff31e65bf3cee046e7b06c9fc8935ca2b08c7782c63e798

restore historical SHA =
PROHIBITED

historical SHA as implementation baseline =
NO
```

## 4. Evidencia de reproducción consumida

```text
controlled runs =
5

Scenario D first expected-2 readiness =
PASS IN ALL 5 RUNS

Scenario D final result =
3 FAIL / 2 PASS

failure signature =
expected '2', received '0'

SQLSTATE 40P01 =
NOT OBSERVED

bounded hang =
NOT OBSERVED

partial authority mutation =
NOT OBSERVED
```

La métrica fallida cuenta backends target + unrelated simultáneamente activos en `Timeout/PgSleep`; es una condición transitoria, no estado durable de negocio.

## 5. Scope

```text
implementation path count =
1

implementation path =
supabase/tests/database/task_019_first_admin_profile_completion_concurrency.test.ps1
```

La corrección futura puede modificar sólo lógica necesaria para:
1. hacer determinista Scenario D;
2. latchar la evidencia de overlap válido;
3. eliminar la segunda dependencia temporal de `PgSleep=2` después del denied worker;
4. limpiar exactos anchor fixtures de TASK-021;
5. preservar reporting de primary/cleanup failures.

Segundo path requerido:

```text
CORR-042 IMPLEMENTATION =
BLOCKER — SCOPE EXPANSION REQUIRED
```

## 6. Fuera de alcance

No se modifican TASK-019/TASK-021/TASK-015 production functions o migrations, Auth Admin/provider integration, Custom Access Token Hook, SessionGrant, VerificationChallenge, subject-authority production semantics, RLS, grants/revokes, roles, tenant authorization, UI, offline, Client, UserClientAccess, SupportAccessGrant, Staging ni Production.

## 7. Root cause — F-021-H-001

Scenario D actual prueba correctamente primero:

```text
target valid reaches PgSleep
→ unrelated valid reaches PgSleep
→ simultaneous valid PgSleep count = 2
```

y luego hace trabajo adicional:

```text
start denied worker
→ wait/receive denied worker
→ require simultaneous valid PgSleep count = 2 again
```

La segunda observación exige que una ventana transitoria de cinco segundos continúe viva después de trabajo auxiliar no sincronizado con esa ventana. Esa condición no es un invariant durable.

## 8. Synchronization model determinista

La corrección debe sustituir la segunda observación temporal de `PgSleep=2` por una sincronización **test-only determinista** que preserve también la prueba histórica de que el denied worker puede completar mientras las dos operaciones válidas continúan dentro de una región de overlap controlada.

### 8.1 Gate de overlap controlado

Target y unrelated deben iniciar normalmente y atravesar el production lock/coordination path aprobado hasta alcanzar, cada uno, un punto de readiness controlado exclusivamente por el harness.

La primitive concreta puede ser una harness-local PostgreSQL synchronization primitive o equivalente test-only, siempre que:

```text
all setup/teardown =
same authorized harness path

fixture identity =
exact / bounded

production instrumentation =
NONE

production lock-order change =
NONE

RLS/grant change =
NONE

product semantics =
NONE

elapsed-time-only authority =
NO
```

El gate no puede confundirse con un production lock ni convertirse en una nueva primitive reusable de aplicación.

### 8.2 Readiness dual y latch

El harness debe observar determinísticamente que **ambos** valid workers alcanzaron el gate antes de continuar:

```text
target valid at controlled gate =
YES

unrelated valid at controlled gate =
YES

dual readiness =
YES
```

Sólo después de dual readiness:

```text
scenarioDValidOverlapObserved =
TRUE
```

Una global serialization debe impedir alcanzar dual readiness dentro del timeout bounded y, por tanto, producir `FAIL`.

### 8.3 Denied-during-controlled-overlap

Después de latchar el overlap, el harness mantiene deliberadamente a **ambos** valid workers detenidos en el gate test-only.

Mientras ambos permanecen en ese estado:

1. se inicia el denied worker;
2. se espera bounded su resultado;
3. se exige exactamente `DENIED|SECURITY_CORRELATION_FAILURE|NULL|NULL|NULL`;
4. se exige durable denied state vacío;
5. se demuestra que el denied worker completó mientras target y unrelated permanecían todavía en el gate controlado.

Esto preserva explícitamente el invariant histórico:

```text
denied completion during valid controlled overlap =
REQUIRED
```

### 8.4 Release y outcomes válidos

Sólo después de verificar el denied result:

1. el harness libera el gate test-only;
2. target continúa y debe completar correctamente;
3. unrelated continúa y debe completar correctamente;
4. se ejecutan las durable-state assertions vigentes;
5. el PASS final exige que la evidencia de dual readiness y denied-during-controlled-overlap haya sido observada.

No se vuelve a exigir que una ventana `PgSleep` temporal continúe viva después del denied worker.

### 8.5 Invariants explícitos

```text
INV-C042-1 =
two valid cross-tenant operations can concurrently reach the controlled test gate

INV-C042-2 =
shared actor coordination is not a production global mutex

INV-C042-3 =
the denied operation can complete while both valid operations remain deliberately held at the test-only overlap gate

INV-C042-4 =
the denied operation obtains no authority

INV-C042-5 =
after gate release both valid operations complete correctly

INV-C042-6 =
no 40P01 / bounded hang / partial authority mutation occurs
```

### 8.6 Prohibiciones

No se permite solucionar mediante:

```text
increase pg_sleep only
increase readiness timeout only
arbitrary Start-Sleep
retry until lucky
warning-only assertion
unconditional PASS
```

La corrección no puede depender únicamente de elapsed time.

## 9. Root cause — F-021-H-002 y fixture cleanup

El harness histórico predates TASK-021 y no limpia sus exactos `AuthSubjectAuthorityAnchor` fixtures.

Cleanup requerido:
1. test-only;
2. usa sólo la lista exacta de subject IDs fixture del harness;
3. no usa global DELETE ni prefix/range;
4. se ejecuta tras finalizar/bounded-clean todos los workers/transacciones;
5. respeta dependencias reales del schema;
6. es idempotente;
7. no crea RPC o semántica productiva;
8. verifica residue cero.

PASS requiere:

```text
exact harness fixture anchor residue =
0

other harness fixture residue =
0

fixture residue =
0
```

## 10. Concurrency invariants preservados

El harness corregido debe seguir probando:
- target y unrelated-company valid operations pueden solaparse;
- shared actor coordination no es global mutex;
- no lock-order inversion nueva;
- no `40P01`;
- no bounded hang;
- denied cross-subject no obtiene autoridad;
- valid operations alcanzan durable completed state correcto;
- denied operation deja cero durable authority state;
- no partial authority mutation;
- TASK-021 subject-authority fence invariants permanecen.

## 11. Seguridad, RLS y multitenancy

```text
security change =
NONE

RLS change =
NONE

privilege expansion =
NONE

multitenancy change =
NONE

tenant authority change =
NONE

SUPER_ADMIN ordinary tenant bypass =
NO

generic Auth Admin =
NO

ordinary service-role business/data path =
NO
```

El cleanup test-only no puede convertirse en primitive privilegiada reusable.

## 12. Failure model

Primary failures incluyen readiness timeout, deterministic-gate timeout, worker timeout, SQLSTATE no esperado, worker non-zero exit, unexpected result, durable-state assertion failure y Scenario A/B/C/D failure.

Cleanup failure se registra separadamente e incluye tanto fixture cleanup como gate/synchronization release/teardown failure.

Si primary y cleanup fallan:

```text
primary failure =
REPORTED

cleanup failure =
REPORTED

overall result =
FAIL
```

El cleanup no puede ocultar el primary failure. PASS exige primary failure = NO, cleanup failure = NO, deterministic gate completamente liberado/limpiado y fixture residue = 0.

## 13. Test plan

Debe pasar:

```text
Scenario A =
PASS

Scenario B =
PASS

Scenario C =
PASS

Scenario D =
PASS

required consecutive full-harness runs =
5
```

Cada una de las cinco ejecuciones consecutivas debe terminar con:

```text
SQLSTATE 40P01 =
NOT OBSERVED

bounded hang =
NOT OBSERVED

partial authority mutation =
NOT OBSERVED

fixture residue =
0
```

También deben permanecer PASS:

```text
T021-CON-001..008
ALIAS-01..03
TASK-021 ↔ TASK-019 active-fence coverage
TASK-015 reinstate active-fence coverage
TASK-015 enabled role-change active-fence coverage
```

y los repository checks vigentes de TASK-021 Work Item H, incluyendo `git diff --check`.

## 14. Negative fail-closed validation matrix

Cada condición negativa debe mapearse a un mecanismo observable que impida `PASS`.

| Condición negativa | Observable obligatorio | Resultado |
| --- | --- | --- |
| Global serialization | target y unrelated no pueden alcanzar simultáneamente el deterministic gate dentro del timeout bounded | `FAIL` |
| Valid worker failure | target o unrelated devuelve non-success, non-zero o falla su result assertion | `FAIL` |
| Denied authority / wrong outcome | denied devuelve algo distinto del exacto `DENIED|SECURITY_CORRELATION_FAILURE|NULL|NULL|NULL` o su durable state no está vacío | `FAIL` |
| PostgreSQL deadlock | aparece `SQLSTATE 40P01` en worker/SQLSTATE reporting | `FAIL` |
| Bounded hang | worker, readiness o deterministic gate excede su timeout bounded | `FAIL` |
| Gate release / gate cleanup failure | la synchronization test-only no puede liberarse o limpiarse completamente | `FAIL` |
| Anchor cleanup failure | queda cualquier exact fixture anchor al final | `FAIL` |
| Other fixture residue | cualquier historical fixture residue esperado en cero permanece | `FAIL` |
| Timing-only workaround | el supuesto éxito depende únicamente de aumentar sleep/timeout o retry-until-lucky | `FAIL` |

La relación normativa es:

```text
negative condition present
→ harness cannot report PASS
```

No se requiere production fault injection ni un segundo source file para demostrar esta fail-closed mapping.

## 15. Implementation blockers

```text
more than one implementation path required
production path change required
migration change required
RLS/grant change required
Auth behavior change required
lock-order contract change required
new ADR required
historical SHA restoration required
deterministic synchronization cannot be achieved in test-only code
fixture cleanup requires production semantics
valid concurrency invariant must be weakened
current harness baseline SHA mismatch
unexpected Git baseline drift
```

Ante cualquiera: STOP y RETURN TO REVISOR CENTRAL.

## 16. Plan de implementación futuro

Después de todos los Gates previos:
1. preflight Git fresco;
2. verificar SHA actual del harness;
3. releer CORR-042/TASK-019/TASK-021;
4. confirmar exactamente un path;
5. crear dentro del mismo harness el deterministic test-only gate con exact fixture identity;
6. hacer que target y unrelated alcancen dual readiness en ese gate y latchar overlap;
7. mantener ambos valid workers deliberadamente held mientras se ejecuta el denied worker;
8. exigir exact denied result y durable denied state vacío mientras dual-valid overlap sigue held;
9. liberar el gate y exigir completion/durable outcomes correctos de target y unrelated;
10. eliminar/reemplazar sólo la segunda dependencia no determinista de `PgSleep=2`;
11. añadir exact-fixture anchor cleanup y gate cleanup bounded;
12. añadir residue assertion y fail-closed negative mappings;
13. preservar primary/cleanup failure reporting;
14. ejecutar A..D;
15. ejecutar cinco full-harness runs consecutivos;
16. ejecutar regressions TASK-021/ALIAS/active-fence;
17. ejecutar repository checks;
18. verificar `git diff --check`;
19. demostrar exactamente un path;
20. no stage/commit/push sin Gates posteriores.

## 17. Acceptance Criteria

**AC-042-001.** CORR-042 conserva exactamente el ID `CORR-042`.
**AC-042-002.** El título es `CORR-042 — TASK-019 Historical Concurrency Harness Compatibility with TASK-021 Subject-Authority Coordination`.
**AC-042-003.** La root-cause class consumida es `CLASS-D — HISTORICAL HARNESS COMPATIBILITY CORRECTION REQUIRED`.
**AC-042-004.** `F-021-H-001` permanece confirmado como defecto de observabilidad temporal no determinista del harness histórico.
**AC-042-005.** `F-021-H-002` permanece confirmado como incompatibilidad de cleanup del harness histórico con fixtures `AuthSubjectAuthorityAnchor` de TASK-021.
**AC-042-006.** `TASK-021 production defect = NO — NOT DEMONSTRATED` permanece vigente.
**AC-042-007.** `TASK-019 production contract regression = NO — NOT DEMONSTRATED` permanece vigente.
**AC-042-008.** La implementación futura modifica exactamente un path.
**AC-042-009.** El único path modificable es `supabase/tests/database/task_019_first_admin_profile_completion_concurrency.test.ps1`.
**AC-042-010.** Cualquier necesidad de un segundo path produce `BLOCKER — SCOPE EXPANSION REQUIRED`.
**AC-042-011.** El baseline físico exigido del harness es SHA-256 `82573bfd40310805a6b026bbf99b47f5fc010815368a0f45cf73b74399af211b`.
**AC-042-012.** El SHA histórico `2eccefaad900b7c15ff31e65bf3cee046e7b06c9fc8935ca2b08c7782c63e798` no es baseline de implementación.
**AC-042-013.** Restaurar el harness al SHA histórico está prohibido.
**AC-042-014.** Scenario D conserva una primera readiness assertion que demuestra overlap real de las dos operaciones válidas.
**AC-042-015.** Target y unrelated deben alcanzar simultáneamente un deterministic test-only gate con dual readiness bounded; ese overlap se latcha y ambos valid workers permanecen held hasta completar la denied operation.
**AC-042-016.** El PASS de Scenario D no requiere que la misma ventana `PgSleep` siga viva; requiere demostrar que el denied worker completa mientras target y unrelated permanecen held en el deterministic test-only overlap gate.
**AC-042-017.** La segunda aserción histórica `expected 2` posterior al denied worker debe eliminarse y reemplazarse por evidencia determinista de dual readiness held + denied completion durante ese overlap controlado.
**AC-042-018.** La corrección no puede basarse únicamente en aumentar `pg_sleep` o timeouts.
**AC-042-019.** La corrección no puede introducir `Start-Sleep` arbitrario, retry-until-lucky, warning-only ni unconditional PASS.
**AC-042-020.** El overlap de las dos operaciones válidas y la prueba denied-during-controlled-overlap son condiciones positivas obligatorias para PASS.
**AC-042-021.** El denied worker debe conservar el resultado exacto `DENIED|SECURITY_CORRELATION_FAILURE|NULL|NULL|NULL` y completarlo mientras ambos valid workers permanecen held en el gate test-only.
**AC-042-022.** La denied operation debe conservar cero durable authority state.
**AC-042-023.** Las dos operaciones válidas deben conservar sus durable completed outcomes autorizados.
**AC-042-024.** El harness debe continuar demostrando ausencia de global serialization mediante dual readiness simultánea en el deterministic gate; si dual readiness no se alcanza dentro del timeout bounded, el resultado es FAIL.
**AC-042-025.** El harness debe continuar demostrando ausencia de PostgreSQL deadlock y `SQLSTATE 40P01`.
**AC-042-026.** Un worker, readiness o deterministic gate que excede su timeout bounded debe hacer fallar el harness.
**AC-042-027.** Un error SQL, PowerShell job, gate release/cleanup o fixture cleanup debe hacer fallar el harness.
**AC-042-028.** El fallo primario y cualquier gate/fixture cleanup failure deben reportarse separadamente cuando coexisten, y la presencia de cualquiera impide PASS.
**AC-042-029.** El cleanup de anchors es test-only.
**AC-042-030.** El cleanup de anchors usa exclusivamente la lista exacta de Auth subjects fixture creada por el harness.
**AC-042-031.** El cleanup no puede usar `DELETE` global ni predicados por prefijo/rango.
**AC-042-032.** El cleanup ocurre sólo después de que todos los workers/transacciones hayan finalizado o hayan sido bounded-cleaned.
**AC-042-033.** El cleanup de anchors es idempotente.
**AC-042-034.** El cleanup no crea RPC productiva ni semántica productiva de delete/lifecycle.
**AC-042-035.** El harness debe verificar cero residue de anchors atribuibles a sus exactos fixture subjects.
**AC-042-036.** `fixture residue = 0` y deterministic gate residue/cleanup = 0 son condiciones de PASS.
**AC-042-037.** TASK-019 production functions/migrations permanecen sin cambios.
**AC-042-038.** TASK-021 production migration/functions permanecen sin cambios.
**AC-042-039.** TASK-015 production functions permanecen sin cambios.
**AC-042-040.** Auth Admin/provider integration, Custom Access Token Hook y SessionGrant permanecen sin cambios.
**AC-042-041.** RLS y grants/revokes permanecen sin cambios.
**AC-042-042.** Application/UI code permanece sin cambios.
**AC-042-043.** TASK-021 subject-authority fence, active-fence behavior y lock order permanecen sin cambios.
**AC-042-044.** `security change = NONE`, `RLS change = NONE`, `privilege expansion = NONE`.
**AC-042-045.** `multitenancy change = NONE` y `tenant authority change = NONE`.
**AC-042-046.** `SUPER_ADMIN ordinary tenant bypass = NO`, `generic Auth Admin = NO`, `ordinary service-role business/data path = NO` permanecen.
**AC-042-047.** El harness completo TASK-019 concurrency debe pasar después de la corrección.
**AC-042-048.** Scenario A, B, C y D deben pasar; Scenario D exige dual readiness held, denied completion durante ese overlap y release posterior de los valid workers.
**AC-042-049.** El harness completo debe pasar cinco ejecuciones consecutivas sin modificar sleeps/timeouts entre runs.
**AC-042-050.** Las cinco ejecuciones deben tener `40P01 = NOT OBSERVED`, `bounded hang = NOT OBSERVED`, `partial authority mutation = NOT OBSERVED` y `fixture residue = 0`.
**AC-042-051.** TASK-021 concurrency `T021-CON-001..008` debe permanecer PASS.
**AC-042-052.** `ALIAS-01..03` deben permanecer PASS.
**AC-042-053.** TASK-021 ↔ TASK-019 active-fence coverage debe permanecer PASS.
**AC-042-054.** TASK-015 reinstate y enabled role-change active-fence coverage deben permanecer PASS.
**AC-042-055.** Los checks de repositorio exigidos por TASK-021 Work Item H y `git diff --check` deben permanecer PASS.
**AC-042-056.** El diff futuro debe contener exactamente el único harness autorizado.
**AC-042-057.** No se requiere nuevo requisito de producto, decisión arquitectónica, ADR ni cambio de lock order.
**AC-042-058.** Si dual-valid readiness, denied-during-controlled-overlap y gate cleanup deterministas no pueden lograrse dentro del único harness test-only, la implementación debe bloquearse.
**AC-042-059.** Si la corrección sólo puede pasar debilitando invariants válidos o requiere semántica productiva nueva, debe bloquearse.
**AC-042-060.** TASK-021 Work Items A..G permanecen preservados y Work Item H permanece bloqueado hasta implementation review satisfactorio de CORR-042.
**AC-042-061.** TASK-021 Work Item I no se autoriza por inferencia y CORR-042 no cierra TASK-021.

## 18. Definition of Done

**DoD-042-001.** `CORR-042 DETERMINATION = APPROVED — HISTORICAL HARNESS COMPATIBILITY CORRECTION REQUIRED` permanece vigente.
**DoD-042-002.** `CORR-042 SPECIFICATION GENERATION AUTHORIZATION = APPROVED`.
**DoD-042-003.** Existe este artefacto corregido con estado `CORRECTED / PENDING SPEC REVIEW`.
**DoD-042-004.** `CORR-042 SPEC REVIEW = APPROVED` se obtiene mediante Gate separado.
**DoD-042-005.** Existe aprobación humana explícita mediante Gate separado.
**DoD-042-006.** Approved artifact generation y approved artifact review se completan mediante Gates separados.
**DoD-042-007.** Canonicalization y canonicalization review se completan mediante Gates separados.
**DoD-042-008.** Repository incorporation y repository incorporation review se completan mediante Gates separados.
**DoD-042-009.** Existe autorización humana separada de implementación.
**DoD-042-010.** Preflight Git fresco = PASS antes de modificar el harness.
**DoD-042-011.** El harness físico verifica SHA-256 `82573bfd40310805a6b026bbf99b47f5fc010815368a0f45cf73b74399af211b`.
**DoD-042-012.** Exactamente un implementation path cambia y es el harness autorizado.
**DoD-042-013.** No se restaura el SHA histórico no recuperable.
**DoD-042-014.** Scenario D implementa un deterministic test-only gate que mantiene ambos valid workers held durante la ejecución bounded del denied worker y reemplaza el segundo check temporal histórico.
**DoD-042-015.** El overlap válido se demuestra mediante dual readiness, se latcha y permanece controladamente held hasta demostrar denied completion durante ese overlap.
**DoD-042-016.** El denied worker completa mientras ambos valid workers permanecen held, conserva su exacto resultado esperado y deja cero durable authority state.
**DoD-042-017.** Después del release determinista del gate, los valid workers completan y conservan sus durable completed outcomes.
**DoD-042-018.** La dual readiness prueba ausencia de global mutex y el harness no observa `40P01` ni bounded hang.
**DoD-042-019.** El cleanup usa sólo exact fixture subject IDs y es idempotente.
**DoD-042-020.** El cleanup deja `auth_subject_authority_anchors` residue atribuible al harness = 0 y fixture residue total = 0.
**DoD-042-021.** Gate release/cleanup failure o fixture cleanup failure bloquean PASS, se reportan separadamente y no ocultan el primary failure.
**DoD-042-022.** El harness TASK-019 concurrency completo pasa; Scenario D demuestra dual readiness, denied-during-controlled-overlap, gate release y valid durable outcomes.
**DoD-042-023.** Cinco ejecuciones consecutivas completas del harness pasan.
**DoD-042-024.** TASK-021 `T021-CON-001..008` y `ALIAS-01..03` pasan.
**DoD-042-025.** TASK-021 ↔ TASK-019 active-fence coverage pasa.
**DoD-042-026.** TASK-015 reinstate y enabled role-change active-fence coverage pasan.
**DoD-042-027.** Security/RLS/privileges/multitenancy/tenant-authority permanecen sin cambios.
**DoD-042-028.** No cambia ningún production path.
**DoD-042-029.** `git diff --check = PASS` y el diff se limita al único path autorizado.
**DoD-042-030.** `CORR-042 IMPLEMENTATION REVIEW = APPROVED` se obtiene mediante Gate separado.
**DoD-042-031.** Staging authorization y staging review se completan mediante Gates separados.
**DoD-042-032.** Commit authorization y commit review se completan mediante Gates separados.
**DoD-042-033.** Push authorization y push non-force se completan mediante Gates separados.
**DoD-042-034.** Remote verification confirma el commit exacto y convergencia HEAD/origin.
**DoD-042-035.** `CORR-042 FINAL HUMAN CLOSURE = APPROVED` se obtiene mediante Gate separado.
**DoD-042-036.** TASK-021 Work Item H sólo puede reanudarse después del implementation review aprobado de CORR-042 y los Gates de integración requeridos.
**DoD-042-037.** TASK-021 Work Item I continúa sujeto a autorización Hosted separada; CORR-042 no la concede.

## 19. Governance

Secuencia:

```text
SPEC REVIEW
→ HUMAN SPEC APPROVAL
→ APPROVED ARTIFACT GENERATION
→ APPROVED ARTIFACT REVIEW
→ CANONICALIZATION AUTHORIZATION
→ CANONICALIZATION
→ CANONICALIZATION REVIEW
→ REPOSITORY INCORPORATION AUTHORIZATION
→ REPOSITORY INCORPORATION
→ REPOSITORY INCORPORATION REVIEW
→ IMPLEMENTATION AUTHORIZATION
→ IMPLEMENTATION
→ IMPLEMENTATION REVIEW
→ STAGING AUTHORIZATION
→ STAGING
→ STAGING REVIEW
→ COMMIT AUTHORIZATION
→ COMMIT
→ COMMIT REVIEW
→ PUSH AUTHORIZATION
→ PUSH
→ REMOTE VERIFICATION
→ FINAL HUMAN CLOSURE
```

Ningún Gate implica automáticamente el siguiente.

## 20. Estado resultante de TASK-021

```text
TASK-021 IMPLEMENTATION =
PARTIAL

TASK-021 IMPLEMENTATION REVIEW =
BLOCKED

Work Items A..G =
PRESERVED / NOT REOPENED

Work Item H =
BLOCKED PENDING CORR-042

Work Item I =
NOT AUTHORIZED TO PROCEED BY INFERENCE

staging =
NO

commit =
NO

push =
NO

Hosted Development =
NOT EXECUTED
```

## 21. Autorevisión

```text
implementation path count =
1

production path change =
NO

product requirement change =
NO

architecture change =
NO

new ADR required =
NO

lock-order contract change =
NO

security change =
NONE

RLS change =
NONE

privilege expansion =
NONE

multitenancy change =
NONE

tenant authority change =
NONE

repository mutation during specification generation =
NO

Supabase mutation =
NO

Codex used =
NO
```

## 22. Resultado formal

```text
CORR-042 SPECIFICATION GENERATION =
PASS

CORR-042 SPEC REVIEW =
RETURNED FOR CORRECTION

CORR-042 SPECIFICATION CORRECTION =
PASS

CORR-042 SPEC REVIEW =
APPROVED

CORR-042 HUMAN SPEC APPROVAL =
APPROVED

CORR-042 APPROVED ARTIFACT GENERATION =
PASS

CORR-042 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-042 CANONICALIZATION AUTHORIZATION =
APPROVED

CORR-042 CANONICALIZATION =
PASS

CORR-042 canonical artifact =
GENERATED / PENDING CANONICALIZATION REVIEW

canonical target path =
docs/tasks/CORR-042-task-019-historical-concurrency-harness-compatibility-task-021-subject-authority-coordination.md

CORR-042 approved artifact =
APPROVED

CORR-042 specification =
HUMAN APPROVED

CORR-042 repository incorporation =
NOT AUTHORIZED

CORR-042 implementation =
NOT AUTHORIZED

repository mutation =
NO

Supabase mutation =
NO

Codex =
NOT USED

staging =
NO

commit =
NO

push =
NO

TASK-021 Work Item H =
BLOCKED PENDING CORR-042

F-042-SPEC-001 =
RESOLVED

F-042-SPEC-002 =
RESOLVED

next Gate =
CORR-042 CANONICALIZATION REVIEW

DESTINO =
CHATGPT — MISMO CHAT REVISOR CENTRAL
```

```text
STOP
```
