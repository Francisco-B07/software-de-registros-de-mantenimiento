# CORR-035 — TASK-019 Cross-Task Actor/Company Lock-Graph Correction

## 1. Identificación

**ID:** `CORR-035`

**Tipo:** `CONCURRENCY / IMPLEMENTATION CORRECTION`

**Estado de esta specification:** `CANONICALIZED`

**CORR-035 DETERMINATION:** `APPROVED`

**CORR-035 SPECIFICATION GENERATION AUTHORIZATION:** `APPROVED`

**CORR-035 SPEC REVIEW:** `APPROVED`

**CORR-035 HUMAN SPEC APPROVAL:** `APPROVED`

**CORR-035 APPROVED ARTIFACT REVIEW:** `APPROVED`

**CORR-035 approved artifact:** `APPROVED`

**CORR-035 canonicalized:** `YES`

**CORR-035 repository incorporation:** `NO`

**CORR-035 implementation authorization:** `NO`

**CORR-035 implementation:** `NOT PERFORMED`

**Repository modified by this canonicalization:** `NO`

**Supabase Cloud modified:** `NO`

**New ADR required:** `NO`

**TASK-019 WORK ITEM A REVIEW:** `REOPENED — NEW CROSS-TASK CONCURRENCY EVIDENCE`

**TASK-019 WORK ITEM B:** `BLOCKED / NOT COMPLETE`

**TASK-019 WORK ITEM C..F:** `NOT AUTHORIZED`

**Staging / commit / push:** `NOT AUTHORIZED`

**Phase 2:** `IN PROGRESS / NOT CLOSED`

**Phase 2 Exit Gate:** `NOT DEFINED / NOT SATISFIED`

**Phase 3:** `NOT STARTED`

---

## 2. Objetivo único

CORR-035 corrige exclusivamente dos defects confirmados durante TASK-019 Work Item B:

```text
F-019-B-001 =
HIGH — CROSS-TASK LOCK GRAPH CONTRADICTION / POSTGRESQL 40P01

F-019-B-002 =
MEDIUM — SQLSTATE CLASSIFICATION PARSER IS NOT ROBUST
```

La corrección redefine de forma bounded el orden de coordinación de TASK-019 para evitar el ciclo actor/company con TASK-017 y endurece la clasificación del harness de concurrencia.

CORR-035 no cambia requisitos funcionales de onboarding, identidad, memberships, auditoría, RLS, multitenancy, UI u offline.

---

## 3. Estado de gobernanza consumido

```text
TASK-019 IMPLEMENTATION AUTHORIZATION =
APPROVED

TASK-019 WORK ITEM A =
DONE / REVIEW APPROVED
then
REOPENED — NEW CROSS-TASK CONCURRENCY EVIDENCE

TASK-019 WORK ITEM B AUTHORIZATION =
APPROVED

TASK-019 WORK ITEM B =
STOP — IMPLEMENTATION DEFECT DISCOVERED

TASK-019 WORK ITEM B REVIEW =
BLOCKER — CROSS-TASK DEADLOCK CONFIRMED

F-019-A-001 =
RESOLVED

F-019-A-002 =
RESOLVED

F-019-A-003 =
RESOLVED

F-019-B-001 =
CONFIRMED

F-019-B-002 =
CONFIRMED
```

La apertura de CORR-035 no reabre TASK-017 ni TASK-010.

---

## 4. Fuentes físicas autoritativas revisadas

### 4.1 Fuentes de producto/canon

- `docs/tasks/TASK-019-authoritative-first-admin-profile-completion-onboarding-completion-foundation.md`
  - SHA-256: `281372051bd1fb3791b23a706c7c818da99ff21bf6aa3f70954eeafbb133c902`
- `docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md`
  - SHA-256: `aa236a05162e44e083f4e75c1dc86602d55a91f454134e023b6306640370653d`
- `docs/tasks/TASK-010-audit-event-foundation.md`
- `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`
- `docs/tasks/CORR-021-privileged-rpc-boundary-hardening.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`
- `docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md`

### 4.2 Fuentes físicas de implementación

- TASK-017 migration:
  - `supabase/migrations/20260919153618_task_017_first_admin_onboarding_intent_verification_handoff_foundation.sql`
  - SHA-256: `7ef2ef48f92d632fc757527a3716978c49eb5358bd852dab1b1acd7ba437d789`
- TASK-019 Work Item A migration:
  - `supabase/migrations/20260925011407_task_019_first_admin_profile_completion_onboarding_completion_foundation.sql`
  - SHA-256: `bec02a96cfad9ce91a459f1e69fd089dd69b974d5d7f45015a79c471e86c0c90`
- TASK-019 Work Item A DB/static test:
  - `supabase/tests/database/task_019_first_admin_profile_completion_onboarding_completion_foundation.test.sql`
  - SHA-256: `3503a10e7ad50f636040bafe06867c69b081c1af3f7cf9dea82631f9be67ca97`
- TASK-017 concurrency runner:
  - `supabase/tests/database/task_017_first_admin_onboarding_concurrency.test.ps1`
  - SHA-256: `7446ccfb597c5e92a9ee1759faabe78e8fb849471ffb0404ef5e63bbd3530c29`
- TASK-019 concurrency runner:
  - `supabase/tests/database/task_019_first_admin_profile_completion_concurrency.test.ps1`
  - SHA-256: `2eccefaad900b7c15ff31e65bf3cee046e7b06c9fc8935ca2b08c7782c63e798`
- TASK-010 AuditEvent migration:
  - `supabase/migrations/20260826190408_task_010_audit_event_foundation.sql`
  - SHA-256: `9e3e324e8adde3af4845f895640f0b86e551d4e11427863aa1f8f2b761511a66`

### 4.3 Verificación externa limitada

Para la semántica del modo de row lock se verificó documentación oficial de PostgreSQL 17, §13.3 Explicit Locking.

Esta fuente externa se usa únicamente para confirmar la matriz de conflictos de row-level locks:

```text
FOR KEY SHARE
conflicts with
FOR UPDATE
```

y que `FOR KEY SHARE` es más débil que `FOR SHARE` / `FOR UPDATE`.

No se deriva de esa documentación ningún requisito de producto.

---

## 5. Hecho físico reproducido

Scenario C produjo un deadlock PostgreSQL real:

```text
SQLSTATE =
40P01

TASK-017/TASK-019 cross-task concurrency =
FAIL — DEADLOCK
```

Diagnóstico físico:

```text
TASK-017:
holds actor PlatformUser
→ waits MaintenanceCompany

TASK-019:
holds MaintenanceCompany
→ waits actor PlatformUser

→ cycle
→ 40P01
```

El delay de test utilizado para volver determinista el solapamiento no introdujo un production lock y no constituye la causa del deadlock.

---

## 6. Causa raíz física

### 6.1 TASK-017

La ruta física relevante de TASK-017:

1. resuelve el current Auth subject;
2. resuelve y bloquea el `PlatformUser` actor global mediante `FOR UPDATE`;
3. valida `is_super_admin`;
4. después adquiere coordinación de establishment operation;
5. bloquea `MaintenanceCompany`;
6. bloquea `FirstAdminOnboardingIntent`.

Para el grafo cross-task relevante:

```text
actor PlatformUser FOR UPDATE
→ MaintenanceCompany FOR UPDATE
→ FirstAdminOnboardingIntent FOR UPDATE
```

### 6.2 TASK-019 antes de CORR-035

TASK-019 Work Item A vigente:

```text
MaintenanceCompany FOR UPDATE
→ FirstAdminOnboardingIntent FOR UPDATE
→ target Auth-subject / PlatformUser FOR UPDATE
→ CompanyMembership FOR UPDATE
→ USER_CREATED
```

`USER_CREATED.actor_platform_user_id` referencia:

```text
intent.initiated_by_platform_user_id
```

y `audit_events.actor_platform_user_id` tiene FK a `public.platform_users(id)`.

### 6.3 Inversión

Cuando el actor histórico del intent es el mismo actor que TASK-017 está revalidando:

```text
TASK-017 actor → company

TASK-019 company → actor
```

El orden es inverso.

Por tanto la afirmación anterior de TASK-019 de que:

```text
MaintenanceCompany
→ FirstAdminOnboardingIntent
```

“matches TASK-017” era incompleta: preservaba solamente un suborden, no el grafo compartido completo.

---

## 7. Decisión de corrección

### 7.1 Alternativa seleccionada

Seleccionada:

```text
A. TASK-019 pre-locks the historical actor row before company
```

No seleccionada:

```text
B. modify TASK-017 lock ordering
```

porque reabriría innecesariamente una foundation cerrada y ampliaría la superficie de regresión.

No seleccionada:

```text
C. global/advisory platform coordination
   FK/audit redesign
   generic synchronization primitive
```

porque el defecto puede resolverse con un row lock bounded dentro de la misma transacción y boundary.

### 7.2 ADR

```text
new ADR required =
NO
```

CORR-035 no cambia arquitectura. Cambia únicamente el orden de row locking de una operación purpose-specific ya existente.

Si para implementar esta specification apareciera necesidad de global lock, nueva boundary, generic privileged writer, service-role writer o cambio de RLS:

```text
CORR-035 IMPLEMENTATION =
STOP

BLOCKER — ADR REQUIRED
```

---

## 8. Lock mode elegido

El lock preliminar del actor histórico será:

```text
SELECT ...
FROM public.platform_users
WHERE id = <provisional initiated_by_platform_user_id>
FOR KEY SHARE
```

Razonamiento:

1. debe entrar en conflicto con TASK-017 `FOR UPDATE` sobre la misma fila;
2. debe adquirirse antes de `MaintenanceCompany`;
3. no necesita convertir TASK-019 en owner exclusivo del actor row;
4. `FOR KEY SHARE` es el modo explícito mínimo seleccionado para esta coordinación;
5. dos completions TASK-019 que sólo necesitan key-share sobre el mismo historical actor no quedan serializadas exclusivamente entre sí.

No usar `FOR UPDATE` para este prelock salvo nueva evidencia física y Gate separado.

---

## 9. Semántica del actor histórico

`initiated_by_platform_user_id` continúa siendo:

```text
historical provenance
```

No es:

```text
caller input
current tenant authority
current browser authority
new authorization grant
```

La resolución preliminar del actor existe sólo para coordinar locks.

```text
preliminary actor resolution != authority
```

CORR-035 no redefine los requisitos de elegibilidad o provenance del actor de TASK-019.

---

## 10. Correlación preliminar corregida

Antes de adquirir locks autoritativos TASK-019 debe:

1. leer preliminary `auth.uid()`;
2. aplicar la exact-one candidate correlation vigente;
3. resolver provisionalmente:
   - `intent.id`;
   - `intent.maintenance_company_id`;
   - `intent.initiated_by_platform_user_id`.

La query preliminar debe seguir consumiendo las reglas ya aprobadas:

- handoff presente;
- handoff ready;
- grant/challenge correlation;
- bridge email igual a target email;
- Auth subject igual en grant y bridge;
- `purpose = initial_session`;
- `auth_method = password`;
- grant consumed;
- grant not revoked.

El resultado preliminar es locator/coordinación, no autoridad final.

---

## 11. Nuevo orden autoritativo de locks de TASK-019

Orden requerido:

```text
1. preliminary auth/correlation read

2. provisionally resolve:
   intent.id
   maintenance_company_id
   initiated_by_platform_user_id

3. lock provisional historical actor PlatformUser
   FOR KEY SHARE

4. lock MaintenanceCompany
   FOR UPDATE

5. lock same FirstAdminOnboardingIntent
   FOR UPDATE

6. re-read auth.uid()

7. re-resolve/revalidate complete authoritative correlation

8. prove final locked intent.initiated_by_platform_user_id
   equals provisional locked actor id

9. revalidate required historical actor existence/correlation
   without treating the preliminary lock as authority

10. terminal same/different-operation reconciliation

11. lock target Auth-subject / PlatformUser when present

12. inspect/lock CompanyMembership rows

13. create/reconcile identity/profile

14. create initial enabled COMPANY_ADMIN membership

15. insert USER_CREATED

16. persist terminal intent evidence

17. return/commit
```

---

## 12. Cross-task lock graph resultante

### TASK-017

```text
actor PlatformUser FOR UPDATE
→ MaintenanceCompany FOR UPDATE
→ FirstAdminOnboardingIntent FOR UPDATE
```

### TASK-019

```text
historical actor PlatformUser FOR KEY SHARE
→ MaintenanceCompany FOR UPDATE
→ FirstAdminOnboardingIntent FOR UPDATE
→ target Auth-subject / PlatformUser
→ CompanyMembership
→ mutation
```

Regla:

```text
shared actor row
must be coordinated
before
shared company row
```

No volver a describir company→intent como el grafo completo de TASK-017.

---

## 13. Revalidación post-lock

Después de actor+company+intent locking, TASK-019 debe:

- re-read `auth.uid()`;
- exigir igualdad con preliminary subject;
- volver a comprobar exact-one current correlation;
- exigir que el intent bloqueado sigue siendo el candidate intent;
- exigir que el company del intent bloqueado sigue siendo el company provisional;
- exigir que el actor histórico del intent bloqueado sigue siendo el actor provisional ya locked;
- verificar existencia/correlación del actor histórico conforme al contrato canónico vigente;
- continuar sólo después de estas verificaciones.

Si cualquier identidad cambió o no puede demostrarse:

```text
DENIED
+
SECURITY_CORRELATION_FAILURE
+
no mutation
```

CORR-035 no crea un mecanismo para soltar locks y reintentar con otro actor dentro de la misma llamada.

---

## 14. Terminal reconciliation precedence

Se preserva:

```text
authoritative revalidation
→ terminal reconciliation
→ target identity/membership compatibility
→ mutation
```

Same-operation terminal state:

```text
ALREADY_COMPLETED
no second mutation
no second USER_CREATED
```

Different-operation terminal state:

```text
DENIED
ONBOARDING_ALREADY_COMPLETED
```

El actor prelock no altera estas semánticas.

---

## 15. Atomicidad

CORR-035 no cambia la frontera transaccional:

```text
PlatformUser/profile
+
Auth-subject mapping when required
+
enabled COMPANY_ADMIN membership
+
USER_CREATED
+
terminal FirstAdminOnboardingIntent evidence
=
ALL COMMIT OR NONE COMMIT
```

No application-side compensation.

---

## 16. Security / RLS / multitenancy

Debe permanecer:

```text
authenticated != authorized

Auth session != tenant authority

RLS =
MANDATORY

multi-tenant isolation =
MANDATORY

browser-supplied tenant =
NOT AUTHORITY

browser-supplied actor =
NOT AUTHORITY

cross-tenant completion =
PROHIBITED

generic privileged writer =
NO

service-role completion path =
NO
```

El nuevo actor prelock:

```text
!= RLS bypass
!= tenant selector
!= authorization
```

No se añaden ordinary table policies ni table grants.

---

## 17. Boundedness / ausencia de global serialization

CORR-035 no autoriza:

- global advisory lock;
- platform-wide mutex;
- singleton lock row;
- lock de todos los SUPER_ADMIN;
- lock de todos los tenants.

La coordinación se limita a:

```text
one provisional historical actor row
+
one MaintenanceCompany row
+
one FirstAdminOnboardingIntent row
+
target identity/membership rows
```

Una regression debe demostrar que tenants no relacionados no quedan serializados mediante un lock global introducido por CORR-035.

El uso de `FOR KEY SHARE` también debe permitir que múltiples TASK-019 transactions mantengan key-share simultáneo sobre un actor histórico común cuando no exista un `FOR UPDATE` competidor.

---

## 18. Superficies canónicas supersedidas

CORR-035 supersede exclusivamente las siguientes afirmaciones de TASK-019.

### 18.1 §8.3 Lock/recheck rule

La secuencia anterior company→intent como primeros locks queda reemplazada por:

```text
historical actor FOR KEY SHARE
→ MaintenanceCompany FOR UPDATE
→ FirstAdminOnboardingIntent FOR UPDATE
→ authoritative revalidation
→ terminal reconciliation
→ target identity
→ membership
```

### 18.2 §14 Transaction and locking model

El lock order completo debe usar §11 de CORR-035.

La frase que afirmaba que company→intent “intentionally matches TASK-017” queda supersedida.

### 18.3 §27 Work Item A

Work Item A queda reabierto exclusivamente para:

- modificar la migration TASK-019 aún no staged/committed;
- añadir/corregir static DB lock-order tests;
- reejecutar database behavior regression;
- demostrar que F-019-B-001 queda corregido a nivel de production SQL.

No se reabre schema/domain funcional.

### 18.4 §27 Work Item B

Work Item B queda bloqueado hasta que Work Item A vuelva a review APPROVED.

Después debe reanudarse desde los escenarios de concurrencia, no desde assumptions previas.

### 18.5 §28.1

Static tests deben verificar:

```text
historical actor FOR KEY SHARE
<
MaintenanceCompany FOR UPDATE
<
FirstAdminOnboardingIntent FOR UPDATE
<
target identity lock
<
CompanyMembership lock
```

### 18.6 §28.3

La suite cross-task debe reproducir el overlap que produjo `40P01` y demostrar su desaparición.

### 18.7 AC-019-058

Semántica corregida:

```text
TASK-019 coordinates the historical initiating actor row before the tenant company row;
the tenant company is then locked before the correlated intent;
this preserves the effective shared actor→company→intent ordering with TASK-017.
```

### 18.8 AC-019-082

Semántica corregida:

```text
TASK-017 and TASK-019 share a compatible actor→company→intent lock graph;
cross-task reconciliation/completion must finish without PostgreSQL deadlock.
```

### 18.9 DoD-019-039 / DoD-019-048

No se renumeran ni sustituyen.

Deben revalidarse después de la corrección:

```text
DoD-019-039 =
TASK-019 corrected concurrency suite passes

DoD-019-048 =
TASK-017 regression and concurrency tests pass after CORR-035
```

---

## 19. Implementation correction boundary

Una futura ejecución, sólo después de todos los Gates de CORR-035, podrá modificar:

```text
supabase/migrations/20260925011407_task_019_first_admin_profile_completion_onboarding_completion_foundation.sql

supabase/tests/database/task_019_first_admin_profile_completion_onboarding_completion_foundation.test.sql

supabase/tests/database/task_019_first_admin_profile_completion_concurrency.test.ps1
```

El último path existe actualmente como Work Item B untracked harness.

No modificar:

```text
TASK-017 production migration
TASK-010 AuditEvent migration/schema
application TypeScript
Next.js routes
UI
product docs
ADR
RLS policy model
```

Si la migration TASK-019 continúa untracked/unstaged/uncommitted, corregir ese mismo archivo es la vía prevista; no crear segunda migration sólo para corregir un artefacto aún no integrado.

---

## 20. F-019-B-001 resolution contract

`F-019-B-001` no se considera resuelto por inspección estática solamente.

Debe existir:

1. migration corregida;
2. static lock-order evidence;
3. local DB reset desde bytes corregidos;
4. Work Item A DB suite PASS;
5. Scenario C real concurrente;
6. `40P01 = NONE`;
7. timeout/hang = NO;
8. durable state coherent;
9. TASK-017 regressions PASS.

Sólo entonces:

```text
F-019-B-001 =
RESOLVED
```

---

## 21. F-019-B-002 — harness SQLSTATE correction

El parser actual puede capturar el prefijo textual:

```text
ERROR:
```

antes del SQLSTATE real:

```text
40P01
```

porque una regex genérica de cinco caracteres también acepta `ERROR`.

La corrección debe aplicar precedencia explícita:

```text
if output contains 40P01
→ POSTGRES_DEADLOCK

else if output contains 55P03 or 57014
→ TIMEOUT_OR_HANG

else if worker exit code != 0
→ UNEXPECTED_SQL_FAILURE

else
→ PASS
```

El campo de evidencia SQLSTATE debe reflejar el código conocido cuando esté presente y no reportar `ERROR` como SQLSTATE.

No es necesario diseñar un parser SQLSTATE universal para resolver CORR-035.

---

## 22. Required concurrency regression

### Scenario A — same operation

Dos TASK-019 completions concurrentes:

```text
same subject
same intent
same operation_id
```

Post-state:

```text
one logical completion
one PlatformUser
one mapping
one enabled COMPANY_ADMIN membership
one USER_CREATED
one coherent terminal tuple
no partial profile
```

`COMPLETED + ALREADY_COMPLETED` o equivalente lógico aceptado por el contrato.

### Scenario B — different operations

Dos completions concurrentes:

```text
operation A != operation B
```

Post-state:

```text
at most one completion winner
terminal operation id not overwritten
one PlatformUser
one mapping
one membership
one USER_CREATED
```

### Scenario C — TASK-017 / TASK-019

Debe ejecutar solapamiento real entre:

```text
TASK-017 same-establishment-operation reconciliation
and
TASK-019 completion
```

sobre el mismo company/intent/actor graph.

Pass obligatorio:

```text
PostgreSQL deadlock =
NO

timeout/hang =
NO

unexpected SQL failure =
NO
```

Post-state cuando completion resulta válida:

```text
PlatformUser target count =
1

enabled COMPANY_ADMIN membership count =
1

USER_CREATED count =
1

terminal intent =
COHERENT
```

No imponer cuál worker obtiene primero el actor lock.

### Scenario D — denied isolation concurrency

Debe cubrir los casos cross-subject/cross-tenant aplicables sin permitir que una carrera convierta un denied caller en autorizado.

### Boundedness probe

Agregar evidencia de que tenants no relacionados no quedan serializados por un lock global.

---

## 23. Scenario C overlap proof

El harness puede usar test-only instrumentation para volver determinista el overlap si:

- no introduce production lock;
- se instala sólo en fixture local;
- se elimina al finalizar;
- el resultado demuestra espera real sobre las filas/transactions bajo prueba;
- no convierte una prueba secuencial en aparente concurrencia.

Debe conservar evidencia de:

```text
worker start
worker overlap/readiness
worker exit
stdout
stderr
SQLSTATE classification
elapsed/timeout
post-state
fixture cleanup
```

---

## 24. Regression matrix

Después de la correction, antes de reautorizar Work Item C:

```text
TASK-019 Work Item A DB/static suite =
PASS

TASK-019 Scenario A =
PASS

TASK-019 Scenario B =
PASS

TASK-019 Scenario C =
PASS

TASK-019 Scenario D =
PASS

boundedness probe =
PASS

TASK-017 DB/regression/concurrency =
PASS

DB lint =
PASS

git diff --check =
PASS
```

Si cualquier test revela necesidad de modificar TASK-017 production foundation:

```text
STOP
RETURN TO REVISOR CENTRAL
```

---

## 25. Failure model

### 25.1 Provisional actor disappears

```text
fail closed
no mutation
```

### 25.2 Locked intent actor differs from provisional actor

```text
fail closed
SECURITY_CORRELATION_FAILURE
no mutation
```

### 25.3 Current auth subject changes during wait

```text
fail closed
AUTHORIZATION_DENIED
no mutation
```

### 25.4 Correlation becomes zero/ambiguous after wait

```text
fail closed
SECURITY_CORRELATION_FAILURE
no mutation
```

### 25.5 Deadlock still reproduces after correction

```text
CORR-035 IMPLEMENTATION =
FAIL / BLOCKER
```

No Work Item C.

### 25.6 Global lock appears necessary

```text
STOP
BLOCKER — ADR REQUIRED
```

### 25.7 TASK-017 production change appears necessary

```text
STOP
RETURN TO REVISOR CENTRAL
```

No silent repair.

---

## 26. Migration / repository strategy

CORR-035 is being specified before TASK-019 staging/commit/push.

Therefore, if future preflight confirms:

```text
TASK-019 migration =
untracked or otherwise not integrated

migration SHA =
expected current reviewed baseline
```

the correction applies to that same migration.

No second migration is required merely to correct an unintegrated implementation artifact.

If future repository state differs, this assumption must be revalidated before mutation.

---

## 27. Codex implementation decomposition after future approval

This section is planning only.

### Work Item CORR-035-A — production lock graph correction

**Objective**

Correct TASK-019 production lock order.

**Expected path**

- TASK-019 migration only.

**Changes**

- preliminary candidate includes historical actor ID;
- actor `FOR KEY SHARE` before company;
- company then intent;
- post-lock actor equality/correlation revalidation.

**Out of scope**

- TASK-017 modification;
- application/UI;
- harness parser.

**STOP**

Any need for global lock, TASK-017 mutation, RLS change or new boundary.

### Work Item CORR-035-B — static/database regression

**Objective**

Revalidate Work Item A.

**Expected path**

- TASK-019 DB/static test.

**Tests**

- exact lock order;
- existing 73-test behavior baseline or superseding count;
- no security/RLS regression.

**Gate**

TASK-019 Work Item A REVIEW must return to APPROVED.

### Work Item CORR-035-C — concurrency harness correction and rerun

**Objective**

Resolve F-019-B-002 and rerun Work Item B.

**Expected path**

- TASK-019 PowerShell concurrency harness only unless Revisor Central approves another test-only path.

**Tests**

- parser known SQLSTATE precedence;
- Scenarios A–D;
- boundedness probe;
- TASK-017 regression/concurrency.

**Gate**

TASK-019 Work Item B REVIEW must become APPROVED before Work Item C.

---

## 28. Security review checklist

Future review must verify:

```text
historical actor lock bounded to one row
company lock bounded to one tenant
intent lock bounded to one intent
no global advisory lock added
no RLS policy delta
no ordinary table GRANT delta
no service-role writer
no generic privileged writer
no cross-tenant locator from caller
no actor ID from caller
public/private RPC security posture unchanged
TASK-017 production bytes unchanged
TASK-010 production bytes unchanged
```

---

## 29. Architecture conclusion

CORR-035 remains within existing architecture:

```text
PostgreSQL transaction
+
row-level lock ordering
+
existing purpose-specific RPC
+
existing multi-tenant/RLS boundaries
```

It does not introduce a new component, service, trust boundary, authority source or persistence model.

```text
new ADR required =
NO
```

---

## 30. Acceptance Criteria

**AC-035-001.** CORR-035 corrige exclusivamente el deadlock cross-task confirmado entre TASK-017 y TASK-019 y el parser SQLSTATE del harness TASK-019.
**AC-035-002.** La causa física autoritativa del deadlock se registra como una inversión entre el lock previo del actor `PlatformUser` de TASK-017 y el lock previo de `MaintenanceCompany` de TASK-019.
**AC-035-003.** La specification registra que TASK-017 adquiere el actor `PlatformUser` antes de `MaintenanceCompany` y `FirstAdminOnboardingIntent` en el flujo físico relevante.
**AC-035-004.** La specification registra que TASK-019 vigente adquiere `MaintenanceCompany` y `FirstAdminOnboardingIntent` antes de alcanzar el lock/referencia del actor histórico usado por `USER_CREATED`.
**AC-035-005.** El SQLSTATE `40P01` reproducido por Scenario C se trata como evidencia válida de deadlock PostgreSQL.
**AC-035-006.** El delay de test que hace determinista el overlap no se interpreta como lock de producción ni como causa del ciclo.
**AC-035-007.** La corrección no modifica TASK-017 production migration.
**AC-035-008.** La corrección no modifica TASK-010 `AuditEvent` schema ni sus FKs.
**AC-035-009.** La corrección no introduce un global advisory lock.
**AC-035-010.** La corrección no introduce un platform-global mutex.
**AC-035-011.** TASK-019 debe resolver provisionalmente `FirstAdminOnboardingIntent`, `maintenance_company_id` e `initiated_by_platform_user_id` antes de adquirir locks autoritativos.
**AC-035-012.** La resolución preliminar del actor histórico no concede actor authority, tenant authority ni autorización.
**AC-035-013.** La resolución preliminar de tenant/intent continúa sin ser autoridad final.
**AC-035-014.** TASK-019 debe adquirir `FOR KEY SHARE` sobre el `PlatformUser` histórico provisional antes de adquirir el lock de `MaintenanceCompany`.
**AC-035-015.** El actor row lock se limita a la fila identificada por el `initiated_by_platform_user_id` provisional del único candidate intent.
**AC-035-016.** Ausencia o ambigüedad del actor provisional requerido por la correlación falla cerrada sin adquirir authority.
**AC-035-017.** Después del actor lock, TASK-019 adquiere `MaintenanceCompany FOR UPDATE`.
**AC-035-018.** Después del company lock, TASK-019 adquiere el mismo `FirstAdminOnboardingIntent FOR UPDATE`.
**AC-035-019.** TASK-019 vuelve a leer `auth.uid()` después de company+intent locking.
**AC-035-020.** TASK-019 re-resuelve y revalida la correlación autoritativa completa después de adquirir company+intent locks.
**AC-035-021.** La revalidación exige que el intent final bloqueado conserve el mismo `initiated_by_platform_user_id` cuya fila fue prebloqueada.
**AC-035-022.** Si el actor final del intent difiere del actor provisional prebloqueado, la operación falla cerrada sin mutación.
**AC-035-023.** La revalidación del actor histórico preserva la semántica canónica de provenance y no convierte el lock preliminar en una nueva fuente de autoridad actual.
**AC-035-024.** Terminal same-operation/different-operation reconciliation ocurre sólo después de la revalidación autoritativa post-lock.
**AC-035-025.** Los locks del target Auth-subject/PlatformUser permanecen después de actor→company→intent y después de terminal reconciliation.
**AC-035-026.** Los locks de `CompanyMembership` permanecen después de target identity locking.
**AC-035-027.** El orden completo corregido de TASK-019 es actor histórico `FOR KEY SHARE` → company → intent → target identity → memberships → mutation.
**AC-035-028.** El orden físico relevante de TASK-017 se documenta como actor `PlatformUser FOR UPDATE` → company → intent para el análisis cross-task.
**AC-035-029.** `FOR KEY SHARE` de TASK-019 debe entrar en conflicto con `FOR UPDATE` de TASK-017 sobre la misma fila de actor.
**AC-035-030.** `FOR KEY SHARE` no se sustituye por `FOR UPDATE` salvo nueva evidencia física que demuestre necesidad estricta y nuevo Gate del Revisor Central.
**AC-035-031.** La corrección elimina el camino TASK-019 company-held → actor-wait que formaba el ciclo con TASK-017.
**AC-035-032.** Si TASK-017 obtiene primero el actor, TASK-019 espera antes de adquirir company; si TASK-019 obtiene primero su actor key-share, puede adquirir company sin haber invertido el actor/company order.
**AC-035-033.** Dos TASK-019 de tenants no relacionados no se serializan mediante un lock global.
**AC-035-034.** Dos TASK-019 que comparten el mismo actor histórico pueden coexistir en `FOR KEY SHARE`; CORR-035 no convierte esa fila en mutex exclusivo entre completions TASK-019.
**AC-035-035.** La corrección preserva `authenticated != authorized`.
**AC-035-036.** La corrección preserva RLS obligatoria y no añade broad table policies.
**AC-035-037.** La corrección preserva aislamiento multiempresa y no acepta tenant desde browser como autoridad.
**AC-035-038.** La corrección no añade generic privileged writer ni service-role completion path.
**AC-035-039.** La corrección preserva el patrón público `SECURITY INVOKER` / privado `SECURITY DEFINER` ya aprobado.
**AC-035-040.** La corrección preserva la atomicidad de PlatformUser/profile + mapping cuando corresponda + initial membership + USER_CREATED + terminal intent.
**AC-035-041.** La corrección preserva `USER_CREATED.actor_platform_user_id = intent.initiated_by_platform_user_id`.
**AC-035-042.** La corrección preserva las semánticas same-operation `ALREADY_COMPLETED` y different-operation denial.
**AC-035-043.** La migration TASK-019 existente sólo puede corregirse después de los Gates documentales de CORR-035.
**AC-035-044.** Si la migration TASK-019 continúa unstaged/uncommitted, CORR-035 no requiere una segunda migration para esta corrección.
**AC-035-045.** TASK-019 static tests deben probar físicamente actor `FOR KEY SHARE` antes de company, company antes de intent, target identity antes de memberships.
**AC-035-046.** Los static tests deben impedir regresión al orden company→actor.
**AC-035-047.** Scenario A vuelve a probar same-operation TASK-019 concurrency y durable exactly-once state.
**AC-035-048.** Scenario B vuelve a probar different-operation TASK-019 concurrency sin overwrite terminal.
**AC-035-049.** Scenario C vuelve a ejecutar TASK-017 same-establishment-operation reconciliation concurrente con TASK-019 completion.
**AC-035-050.** Scenario C pasa sólo si PostgreSQL deadlock = NO y timeout/hang = NO.
**AC-035-051.** Scenario C verifica estado durable: un target PlatformUser, una enabled COMPANY_ADMIN membership, un USER_CREATED y terminal intent coherente cuando completion válida ocurre.
**AC-035-052.** Scenario D vuelve a probar denied cross-subject/cross-tenant isolation concurrente donde el harness lo hace físicamente aplicable.
**AC-035-053.** Una boundedness regression debe demostrar ausencia de serialización global entre tenants no relacionados.
**AC-035-054.** El harness debe buscar/priorizar `40P01` antes de clasificar texto genérico `ERROR:`.
**AC-035-055.** El harness clasifica `40P01` como `POSTGRES_DEADLOCK`.
**AC-035-056.** El harness clasifica `55P03` o `57014` como `TIMEOUT_OR_HANG` cuando esos SQLSTATE están físicamente presentes.
**AC-035-057.** Un worker nonzero sin SQLSTATE conocido se clasifica como `UNEXPECTED_SQL_FAILURE`, no como PASS.
**AC-035-058.** El harness conserva stdout, stderr, exit code, SQLSTATE detectado, timeout state, evidencia de overlap y post-state assertions.
**AC-035-059.** `F-019-B-001` sólo se considera resuelto cuando la migration corregida y Scenario C demuestran ausencia del deadlock reproducido.
**AC-035-060.** `F-019-B-002` sólo se considera resuelto cuando una prueba del parser demuestra clasificación correcta del SQLSTATE real.
**AC-035-061.** TASK-019 §8.3 queda supersedido únicamente en su lock/recheck sequence por CORR-035.
**AC-035-062.** TASK-019 §14 queda supersedido únicamente en su transaction/locking order por CORR-035.
**AC-035-063.** TASK-019 §27 Work Item A se amplía sólo para permitir la corrección de migration/static tests requerida por CORR-035.
**AC-035-064.** TASK-019 §27 Work Item B se mantiene como concurrency regression, ahora consumiendo el actor-first lock graph corregido.
**AC-035-065.** TASK-019 §28.1 debe incluir verificación estática del actor-first ordering.
**AC-035-066.** TASK-019 §28.3 debe tratar explícitamente el ciclo actor/company demostrado y su no reproducción.
**AC-035-067.** AC-019-058 deja de afirmar que company→intent representa por sí solo el order completo relevante de TASK-017.
**AC-035-068.** AC-019-082 queda corregido para exigir compatibilidad del grafo actor→company→intent entre TASK-017 y TASK-019.
**AC-035-069.** DoD-019-039 debe revalidarse con la suite de concurrencia corregida completa.
**AC-035-070.** DoD-019-048 debe revalidarse con regresión/concurrency TASK-017 posterior a la corrección.
**AC-035-071.** TASK-017 production code y canonical contract no son modificados por CORR-035.
**AC-035-072.** TASK-010 production code/schema no son modificados por CORR-035.
**AC-035-073.** CORR-035 no modifica roles, membership semantics, profile semantics, audit action catalog ni offline behavior.
**AC-035-074.** CORR-035 no crea un ADR nuevo.
**AC-035-075.** Si la implementación requiere global lock, nueva boundary, generic privileged writer, service-role writer o cambio RLS, CORR-035 se bloquea y requiere nueva decisión arquitectónica.
**AC-035-076.** Work Item C no puede iniciarse hasta que Work Item A sea re-revisado y Work Item B pase después de CORR-035.

---

## 31. Definition of Done

**DoD-035-001.** Existe specification CORR-035 generada y físicamente identificada.
**DoD-035-002.** CORR-035 SPEC REVIEW pasa mediante Gate separado.
**DoD-035-003.** Existe aprobación humana explícita de CORR-035 antes de cualquier corrección de implementación.
**DoD-035-004.** Se genera approved artifact mediante Gate separado.
**DoD-035-005.** Approved artifact review pasa.
**DoD-035-006.** CORR-035 se canonicaliza mediante Gate separado.
**DoD-035-007.** Canonicalization review pasa.
**DoD-035-008.** CORR-035 se incorpora al repositorio mediante Gate separado.
**DoD-035-009.** Repository incorporation review pasa.
**DoD-035-010.** Existe autorización humana explícita para ejecutar la corrección.
**DoD-035-011.** Preflight Git confirma baseline autorizado y paths esperados antes de mutar.
**DoD-035-012.** Canonical TASK-019, migration TASK-019, migration TASK-017 y harness identities se revalidan antes de corregir.
**DoD-035-013.** TASK-017 production migration permanece byte-identical.
**DoD-035-014.** TASK-010 AuditEvent migration/schema permanece sin cambios.
**DoD-035-015.** TASK-019 migration implementa historical actor `FOR KEY SHARE` antes de company lock.
**DoD-035-016.** TASK-019 revalida actor/intent/correlation después de company+intent locks sin convertir el prelock en autoridad.
**DoD-035-017.** Static DB tests prueban el lock order completo corregido.
**DoD-035-018.** Work Item A database suite pasa nuevamente.
**DoD-035-019.** `F-019-B-002` parser correction tiene prueba reproducible.
**DoD-035-020.** Scenario A same-operation concurrency pasa.
**DoD-035-021.** Scenario B different-operation concurrency pasa.
**DoD-035-022.** Scenario C TASK-017/TASK-019 concurrency pasa sin `40P01` ni hang.
**DoD-035-023.** Scenario D denied isolation concurrency pasa.
**DoD-035-024.** Boundedness regression demuestra que no se introdujo serialización global entre tenants no relacionados.
**DoD-035-025.** Durable post-state invariants pasan para todos los escenarios aplicables.
**DoD-035-026.** TASK-017 regression/concurrency pasa después de la corrección.
**DoD-035-027.** DB lint y `git diff --check` pasan.
**DoD-035-028.** Review físico confirma no RLS weakening, no privilege expansion y no cross-tenant leakage.
**DoD-035-029.** Review físico confirma que no se introdujo nuevo ADR material.
**DoD-035-030.** Work Item A REVIEW vuelve a APPROVED después de la migration corregida.
**DoD-035-031.** Work Item B REVIEW queda APPROVED después de la regression corregida.
**DoD-035-032.** Work Item C permanece bloqueado hasta DoD-035-030 y DoD-035-031.
**DoD-035-033.** Staging, commit y push permanecen sujetos a Gates humanos separados.
**DoD-035-034.** Supabase Cloud permanece sin mutación salvo Gate remoto futuro separado.
**DoD-035-035.** Phase 2 permanece IN PROGRESS / NOT CLOSED y Phase 3 NOT STARTED al cerrar CORR-035, salvo decisión futura separada.

---

## 32. Governance after canonicalization

Current state:

```text
CORR-035 DETERMINATION =
APPROVED

CORR-035 SPECIFICATION GENERATION =
PASS

CORR-035 SPEC REVIEW =
APPROVED

CORR-035 HUMAN SPEC APPROVAL =
APPROVED

CORR-035 specification =
HUMAN APPROVED

CORR-035 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-035 approved artifact =
APPROVED

CORR-035 canonicalized =
YES

CORR-035 repository incorporation =
NO

CORR-035 implementation authorization =
NO

CORR-035 implementation =
NOT PERFORMED

TASK-019 WORK ITEM A REVIEW =
REOPENED

TASK-019 WORK ITEM B =
BLOCKED / NOT COMPLETE

TASK-019 WORK ITEM C..F =
NOT AUTHORIZED
```

Required future sequence remains separate:

```text
CORR-035 CANONICALIZATION REVIEW
→ REPOSITORY INCORPORATION AUTHORIZATION
→ REPOSITORY INCORPORATION
→ REPOSITORY INCORPORATION REVIEW
→ CORR-035 IMPLEMENTATION AUTHORIZATION
→ CORR-035 IMPLEMENTATION
→ CORR-035 IMPLEMENTATION REVIEW
→ TASK-019 WORK ITEM A RE-REVIEW
→ TASK-019 WORK ITEM B RESUME / REVIEW
```

No Gate implies the next.

Staging, commit and push remain separate later Gates.

---

## 33. Final specification state

```text
CORR-035 SPECIFICATION GENERATION =
PASS

CORR-035 SPEC REVIEW =
APPROVED

CORR-035 HUMAN SPEC APPROVAL =
APPROVED

CORR-035 specification =
HUMAN APPROVED

CORR-035 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-035 approved artifact =
APPROVED

CORR-035 CANONICALIZATION =
PASS

CORR-035 canonicalized =
YES

CORR-035 repository incorporation =
NO

CORR-035 implementation authorization =
NO

CORR-035 implementation =
NOT PERFORMED

F-019-B-001 =
CONFIRMED / OPEN

F-019-B-002 =
CONFIRMED / OPEN

new ADR required =
NO

repository mutation =
NO

Supabase Cloud mutation =
NO

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED
```
