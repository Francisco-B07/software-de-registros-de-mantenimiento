# CORR-044 — TASK-021 / CORR-043 Current-State Documentation Sync

## 1. Identificación y estado de gobernanza

**ID:** `CORR-044`

**Título:** `CORR-044 — TASK-021 / CORR-043 Current-State Documentation Sync`

**Tipo:** `DOCUMENTATION CORRECTION SPECIFICATION`

**Naturaleza:** sincronización documental controlada de estado vigente; no constituye nueva decisión de producto, arquitectura, dominio, seguridad, RLS, multitenancy, Auth/session, offline ni fase.

**Estado de esta especificación:** `HUMAN APPROVED`

**CORR-044 SPECIFICATION GENERATION AUTHORIZATION:** `AUTHORIZED`

**CORR-044 SPECIFICATION GENERATION:** `PASS`

**CORR-044 SPEC REVIEW:** `APPROVED`

**CORR-044 HUMAN SPEC APPROVAL:** `APPROVED`

**CORR-044 specification:** `HUMAN APPROVED`

**CORR-044 approved artifact:** `GENERATED / REVIEW APPROVED`

**CORR-044 APPROVED ARTIFACT REVIEW:** `APPROVED`

**CORR-044 canonicalization authorization:** `APPROVED`

**CORR-044 canonicalization:** `PASS`

**CORR-044 canonical artifact:** `GENERATED / PENDING CANONICALIZATION REVIEW`

**CORR-044 repository incorporation:** `NOT AUTHORIZED / NOT PERFORMED`

**CORR-044 implementation:** `NOT AUTHORIZED / NOT PERFORMED`

**Codex autorizado para implementación:** `NO`

**Repositorio modificado durante esta generación:** `NO`

**Supabase Local / Hosted mutation durante esta generación:** `NO / NO`

**Staging / commit / push:** `NO / NO / NO`

**Target futuro único:**

```text
docs/product/11-phase-1-scope-entry-gate.md
```

**Superficie semántica futura única:**

```text
§17 — active current-state registry
```

**Expected future target file count:** `1`

Esta especificación define exclusivamente el contrato para una futura sincronización documental. No autoriza por sí misma ninguna edición del repositorio.

---

## 2. Objetivo único

El objetivo exclusivo de CORR-044 es sincronizar el registro activo de estado de TASK-021 y Fase 2 en:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

limitando la futura modificación a:

```text
§17 — active current-state registry
```

para que esa superficie refleje el estado ya revisado posterior a la implementación/current-source review de TASK-021 y al Hosted review aprobado de CORR-043.

La corrección debe registrar únicamente estado ya aprobado.

Debe preservarse:

```text
state synchronization
!=
new capability determination
```

y:

```text
documentation correction
!=
TASK-021 remaining Hosted execution
!=
TASK-021 closure
!=
Phase 2 Exit Gate definition
!=
Phase 2 closure
!=
Phase 3 start
```

CORR-044 no crea una capability nueva, no redefine requisitos y no determina el siguiente incremento.

---

## 3. Determinación previa consumida

La generación de esta especificación consume como autoridad inmediata el resultado aprobado de:

```text
CORR-043 POST-HOSTED DOCUMENTARY CLOSURE
CURRENT-REPOSITORY SOURCE DISCOVERY =
PASS

CORR-043 POST-HOSTED DOCUMENTARY CLOSURE
CURRENT-REPOSITORY SOURCE DISCOVERY REVIEW =
APPROVED

CORR-043 POST-HOSTED DOCUMENTARY CLOSURE
SYNC DETERMINATION =
PASS
```

La discovery física del repositorio determinó:

```text
CURRENT TASK-021 CURRENT-STATE OWNER =
docs/product/11-phase-1-scope-entry-gate.md (§17)

CURRENT PHASE-2 CURRENT-STATE OWNER =
docs/product/11-phase-1-scope-entry-gate.md (§17)

DOCUMENTS REQUIRING UPDATE =
docs/product/11-phase-1-scope-entry-gate.md

SEPARATE DOCUMENTATION CORR REQUIRED =
YES

HIGHEST CORR ID PRESENT =
CORR-043

NEXT UNUSED CORR ID =
CORR-044 — PROVEN UNUSED, NOT ASSIGNED DURING DISCOVERY

SUPERSEDING DOCUMENTS =
NONE
```

La presente autorización humana asigna ahora el ID `CORR-044` exclusivamente a esta especificación.

No se redetermina la ownership de current state ni se amplía el target set.

---

## 4. Fuentes autoritativas

La futura revisión, aprobación e implementación de CORR-044 deben preservar la jerarquía de autoridad del proyecto:

1. repositorio real y documentación canónica vigente;
2. decisiones humanas posteriores explícitamente aprobadas dentro de su alcance;
3. documentos de producto vigentes;
4. ADR aceptados dentro de su decisión;
5. TASK/CORR canónicas como contratos técnicos y de gobernanza;
6. snapshots históricos como evidencia histórica, no como current-state authority cuando existe estado posterior aprobado.

### 4.1 Target current-state

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Baseline físico observado durante la discovery autorizada:

```text
SHA-256 =
a3f60fcc59b87f98729758301f0c96dd17bb43c3d3ca0b261dc4a7a0d2c9b9f5

bytes =
103061

tracked =
YES
```

Este SHA es evidencia del momento de discovery. No sustituye el preflight físico fresco obligatorio de una futura implementación.

### 4.2 TASK-021 canonical

```text
docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md

SHA-256 =
d0106d83633b616099f6772702ee80f4700115186e938047e19a81edba865c43

tracked =
YES
```

TASK-021 es contrato canónico y no es target de CORR-044.

### 4.3 CORR-043 canonical

```text
docs/tasks/CORR-043-task-021-hosted-concurrency-harness-safety-correction.md

SHA-256 =
b20cdcf0dceb3e5c6cb072dd6433fcded7c1b4afe7ec93fc5f559d5344c35b9d

bytes =
55635

physical discovery state =
UNTRACKED
```

CORR-043 es fuente canónica de la correction contract y no es target de CORR-044.

### 4.4 Current-state predecessors

Consumir y preservar, según corresponda:

```text
docs/tasks/POST-TASK-020-current-state-documentation-sync-specification.md
docs/tasks/CORR-040-task-019-closure-current-state-documentation-sync.md
docs/tasks/CORR-042-adr-0021-acceptance-task-020-prerequisite-current-state-sync.md
```

Estos documentos establecen el patrón vigente de sincronización de §17 y son evidencia histórica/current-state previa, no targets de CORR-044.

### 4.5 Phase boundary

Consumir y preservar:

```text
docs/tasks/CORR-039-phase-2-phase-3-client-scope-boundary-documentation-sync.md
```

Debe mantenerse:

```text
Client = Phase 3

physical UserClientAccess required before Phase 2 close = NO

physical/full SupportAccessGrant required before Phase 2 close = NO

full Client-dependent support required before Phase 2 close = NO
```

### 4.6 Arquitectura aplicable

Consumir para preservación de frontera, no como target:

```text
docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md
```

y cualquier ADR previo que TASK-021 consuma normativamente.

CORR-044 no modifica decisiones arquitectónicas.

---

## 5. Estado actual consumido

El estado ya revisado que CORR-044 debe representar documentalmente es:

```text
CORR-043 technical implementation =
COMPLETE / REVIEW APPROVED

CORR-043 Hosted verification =
COMPLETE / REVIEW APPROVED

CORR-043 =
TECHNICALLY COMPLETE / HOSTED REVIEW APPROVED

F-043-H-001 =
RESOLVED

F-043-H-002 =
RESOLVED

F-021-I-006 =
RESOLVED

TASK-021 implementation/current-source review =
APPROVED
```

Al mismo tiempo continúan pendientes:

```text
F-021-I-001 =
OPEN — HOSTED §36 FUNCTIONAL VERIFICATION PENDING

TASK-021 Work Item I =
NOT COMPLETE

TASK-021 =
NOT DONE / NOT CLOSED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED
```

No existe evidencia aprobada que permita sustituir esos estados abiertos por estados cerrados.

---

## 6. Drift documental activo

La discovery read-only determinó que `docs/product/11-phase-1-scope-entry-gate.md` §17:

- contiene el estado cerrado de TASK-020;
- no contiene TASK-021;
- no contiene CORR-043;
- mantiene una representación activa de later-user Auth/session anterior a TASK-021;
- conserva correctamente `Phase 2 = IN PROGRESS / NOT CLOSED`;
- conserva correctamente `Phase 2 Exit Gate = NOT YET DEFINED`;
- conserva correctamente `Phase 3 = NOT STARTED`.

Por tanto:

```text
active stale surface count =
1

active stale document =
docs/product/11-phase-1-scope-entry-gate.md

active stale semantic surface =
§17

additional target required =
NO

superseding current-state owner =
NONE
```

El drift se limita a la ausencia del estado post-TASK-021/current-source y post-CORR-043 Hosted review.

No existe autorización para modernizar otras secciones o documentos.

---

## 7. Target físico y frontera de mutación futura

### 7.1 Target count

```text
expected modified existing paths =
EXACTLY 1
```

### 7.2 Único target permitido

```text
docs/product/11-phase-1-scope-entry-gate.md
```

### 7.3 Única superficie semántica permitida

```text
§17 — active current-state registry
```

Los números de línea futuros no son autoridad. `§17` es el locator semántico.

### 7.4 Prohibición de expansión

Una futura implementación no puede:

- modificar un segundo archivo;
- modificar otra sección activa;
- reescribir snapshots históricos;
- añadir un nuevo current-state registry;
- mover current-state ownership fuera de §17;
- modificar TASK-021;
- modificar CORR-043;
- modificar ADR-0022;
- modificar CORR-039/CORR-040/CORR-041/CORR-042;
- modificar POST-TASK-020;
- modificar código, tests, migrations, RLS, config o Supabase.

Si el estado no puede sincronizarse dentro de este único target y superficie:

```text
CORR-044 IMPLEMENTATION =
BLOCKER — ADDITIONAL DOCUMENT SURFACE OR TARGET REQUIRED
```

No se amplía scope silenciosamente.

---

## 8. Transiciones exactas que debe registrar §17

La futura implementación debe incorporar al active current-state registry, con la mínima redacción compatible con el formato vigente:

```text
CORR-043 =
TECHNICALLY COMPLETE / HOSTED REVIEW APPROVED

F-043-H-001 =
RESOLVED

F-043-H-002 =
RESOLVED

F-021-I-006 =
RESOLVED

TASK-021 implementation/current-source review =
APPROVED

TASK-021 Work Item I =
NOT COMPLETE — REMAINING HOSTED §36 VERIFICATION PENDING
```

No se exige repetir cada dato varias veces dentro de §17.

La implementación debe evitar duplicación innecesaria y conservar el estilo vigente de current-state summary.

---

## 9. Estados que deben permanecer abiertos

La futura implementación debe preservar explícita e inequívocamente:

```text
F-021-I-001 =
OPEN — HOSTED §36 FUNCTIONAL VERIFICATION PENDING

TASK-021 Work Item I =
NOT COMPLETE

TASK-021 =
NOT DONE / NOT CLOSED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED
```

También debe preservarse:

```text
next TASK =
NOT DETERMINED
```

y:

```text
TASK-022 =
NOT DETERMINED / NOT GENERATED / NOT STARTED
```

en la medida en que §17 represente el estado del siguiente incremento.

CORR-044 no puede determinar TASK-022 ni otra TASK.

---

## 10. No-implicaciones obligatorias

§17 debe quedar semánticamente compatible con todas estas distinciones:

```text
CORR-043 technical completion
!=
TASK-021 completion
```

```text
F-021-I-006 resolved
!=
F-021-I-001 resolved
```

```text
TASK-021 implementation/current-source review approved
!=
TASK-021 Work Item I complete
```

```text
CORR-043 Hosted PASS
!=
Phase 2 closure
```

```text
TASK-021 authenticated session foundation
!=
tenant authorization
```

```text
TASK-021 completion state not reached
!=
permission to start Phase 3
```

```text
CORR-044 completion
!=
TASK-021 closure
!=
Phase 2 closure
!=
Phase 3 start
```

---

## 11. Preservación de snapshots históricos

Debe permanecer:

```text
historical snapshot
!=
active current-state snapshot
```

Los siguientes documentos se consumen como evidencia histórica/canónica y no pueden ser modificados por CORR-044:

```text
docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md
docs/tasks/CORR-043-task-021-hosted-concurrency-harness-safety-correction.md
docs/tasks/POST-TASK-020-current-state-documentation-sync-specification.md
docs/tasks/CORR-039-phase-2-phase-3-client-scope-boundary-documentation-sync.md
docs/tasks/CORR-040-task-019-closure-current-state-documentation-sync.md
docs/tasks/CORR-041-adr-0021-git-persistence-governance-lifecycle-sync.md
docs/tasks/CORR-041-task-013-adr-0022-task-021-pre-issuance-shared-contract-sync.md
docs/tasks/CORR-042-adr-0021-acceptance-task-020-prerequisite-current-state-sync.md
docs/tasks/CORR-042-task-019-historical-concurrency-harness-compatibility-task-021-subject-authority-coordination.md
docs/tasks/TASK-019-authoritative-first-admin-profile-completion-onboarding-completion-foundation.md
docs/tasks/TASK-020-authoritative-later-user-enrollment-intent-verification-handoff-foundation.md
docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md
docs/product/10-architecture-decisions-records.md
```

Una frase histórica como `F-021-I-006 = OPEN` sigue siendo válida dentro del artefacto histórico que registró ese momento.

CORR-044 no hace search-and-replace global de estados previos.

---

## 12. Phase boundary preservada

CORR-044 no modifica la boundary aprobada entre Fase 2 y Fase 3.

Debe preservarse:

```text
Client =
PHASE 3

Client físico =
NO en Fase 2

physical UserClientAccess required before Phase 2 close =
NO

physical/full SupportAccessGrant required before Phase 2 close =
NO

full Client-dependent support required before Phase 2 close =
NO

move minimal Client into Phase 2 =
NO
```

También permanece:

```text
ordinary later-user onboarding remains incomplete until RF-015 can be satisfied =
YES
```

CORR-044 no decide cómo se satisfará RF-015 y no traslada Client a Fase 2.

---

## 13. Producto, dominio y arquitectura

Resultado obligatorio:

```text
product requirement change =
NO

domain change =
NO

architecture change =
NO

new ADR required =
NO
```

CORR-044 sólo registra estado técnico/gobernanza ya aprobado.

No puede:

- añadir requisito funcional;
- modificar roles;
- modificar cardinalidades;
- redefinir `MaintenanceCompany`;
- redefinir `PlatformUser`;
- redefinir `CompanyMembership`;
- redefinir `Client`;
- redefinir `UserClientAccess`;
- redefinir `SupportAccessGrant`;
- redefinir SessionGrant;
- cambiar ownership tenant;
- cambiar arquitectura de Auth/session;
- cambiar la frontera de ADR-0022.

Si la sincronización parece exigir una decisión nueva:

```text
CORR-044 SPECIFICATION / IMPLEMENTATION =
BLOCKER — NEW SEMANTIC DECISION REQUIRED
```

---

## 14. Seguridad, RLS y multitenancy

Resultado obligatorio:

```text
security change =
NO

RLS change =
NO

multitenancy change =
NO

grants/revokes change =
NO
```

Debe preservarse:

```text
tenant =
MaintenanceCompany
```

```text
authenticated
!=
authorized
```

```text
Auth session
!=
tenant authorization
```

```text
current authoritative PostgreSQL state
>
stale claims / stale frontend state
```

```text
RLS =
primary remote tenant-isolation boundary
```

```text
SUPER_ADMIN ordinary tenant bypass =
NO
```

CORR-044 no crea, modifica ni elimina:

- policies RLS;
- grants/revokes;
- RPC;
- `SECURITY DEFINER`;
- privileged clients;
- service-role paths;
- authorization resolvers;
- tenant selectors;
- client-scope rules.

---

## 15. Auth/session boundary

CORR-044 no cambia comportamiento de autenticación o sesión.

Resultado obligatorio:

```text
Auth/session behavior change =
NO
```

La representación de TASK-021 debe mantenerse acotada a lo ya aprobado por su canonical specification y reviews.

En particular, la sincronización documental no puede interpretar una sesión Auth establecida como:

- `CompanyMembership`;
- tenant authority;
- client scope;
- support scope;
- resource authorization;
- finalización del lifecycle completo de later-user;
- cierre de Fase 2.

`authenticated != authorized` permanece obligatorio.

---

## 16. Offline

Resultado obligatorio:

```text
offline behavior change =
NO
```

CORR-044 no crea ni modifica:

- IndexedDB/Dexie;
- Service Worker;
- outbox;
- offline authorization;
- offline credential state;
- retry offline;
- local tenant authority;
- aislamiento local.

La corrección es documental y no cambia ningún contrato offline vigente.

---

## 17. Supabase y Hosted

CORR-044 registra un Hosted review ya aprobado, pero no ejecuta ni reabre Hosted.

Resultado obligatorio durante specification generation y futura documentación-only implementation:

```text
Supabase Local mutation =
NO

Supabase Hosted mutation =
NO

Hosted access =
NO

Auth provider mutation =
NO

migration apply =
NO

RLS mutation =
NO

Auth configuration mutation =
NO
```

CORR-044 no autoriza:

- nueva ejecución del harness CORR-043;
- TASK-021 remaining Hosted §36;
- creación de Auth users;
- sign-in;
- SessionGrant;
- Custom Access Token Hook mutation;
- fixtures remotas;
- cleanup remoto;
- Staging;
- Production.

---

## 18. Alcance

### 18.1 Alcance documental

Una futura implementación autorizada puede:

1. repetir preflight Git/documental;
2. verificar físicamente las fuentes;
3. abrir `docs/product/11-phase-1-scope-entry-gate.md`;
4. localizar semánticamente §17;
5. confirmar que §17 continúa siendo el active current-state registry;
6. insertar/ajustar únicamente las líneas mínimas necesarias para registrar §8 y §9 de esta especificación;
7. preservar todo estado previo todavía vigente;
8. dejar el cambio unstaged;
9. devolver diff completo y evidencia física al Revisor Central.

### 18.2 Alcance de verificación

La futura implementación debe verificar:

- target count = 1;
- changed path count = 1;
- changed hunks = §17 only;
- historical artifacts = unchanged;
- state transitions exactos;
- open states preservados;
- Phase boundary preservada;
- `git diff --check = PASS`;
- ausencia de secrets;
- ausencia de cambios técnicos;
- final target physical metrics.

---

## 19. Fuera de alcance

CORR-044 no define, autoriza ni ejecuta:

- implementación de TASK-021;
- modificación de TASK-021;
- cierre de TASK-021;
- ejecución de F-021-I-001;
- resolución de F-021-I-001;
- ejecución Hosted §36 restante;
- Auth bypass tests;
- creación de usuarios;
- login/sign-in;
- creación de SessionGrant;
- tenant authorization;
- CompanyMembership nueva;
- profile completion later-user;
- `USER_CREATED` later-user;
- Client;
- UserClientAccess;
- SupportAccessGrant;
- Phase 2 Exit Gate;
- cierre de Phase 2;
- inicio de Phase 3;
- TASK-022;
- siguiente TASK;
- código;
- TypeScript;
- SQL;
- migrations;
- RLS;
- policies;
- grants/revokes;
- Supabase config;
- Auth config;
- app routes;
- tests ejecutables;
- package files;
- ADR nueva;
- Supabase Cloud;
- Staging;
- Production.

---

## 20. Preflight obligatorio de futura implementación

Antes de una futura edición, el implementador autorizado deberá ejecutar un preflight fresco y reportar:

```text
repo root
branch
HEAD
origin/main
divergence
git status --porcelain=v1 --untracked-files=all
git diff --cached --name-only
Git operations in progress
```

También deberá medir desde bytes físicos:

```text
target SHA-256
target bytes
LF
CRLF
bare CR
trailing-whitespace lines
final newline
UTF-8 BOM if applicable
```

y verificar:

```text
TASK-021 canonical SHA-256 =
d0106d83633b616099f6772702ee80f4700115186e938047e19a81edba865c43

CORR-043 canonical SHA-256 =
b20cdcf0dceb3e5c6cb072dd6433fcded7c1b4afe7ec93fc5f559d5344c35b9d
```

Baseline histórico de discovery, sólo para comparación:

```text
branch =
main

HEAD =
7ab29610935573239f552d4078a41b3c6b14c629

origin/main =
7ab29610935573239f552d4078a41b3c6b14c629

divergence =
0 0

target discovery SHA-256 =
a3f60fcc59b87f98729758301f0c96dd17bb43c3d3ca0b261dc4a7a0d2c9b9f5

target discovery bytes =
103061
```

La futura autorización de implementación deberá fijar el baseline permitido.

No se debe tratar el baseline histórico como permiso automático para escribir sobre una versión diferente.

---

## 21. Contrato de implementación futura

Una futura implementación de CORR-044, sólo después de todos los Gates previos requeridos, deberá:

1. realizar preflight fresco;
2. releer las fuentes autorizadas;
3. confirmar que no existe fuente posterior que superseda TASK-021/CORR-043/current-state ownership;
4. confirmar que no existe CORR-044 ya incorporada por otra vía;
5. confirmar que el target es exactamente uno;
6. localizar §17 semánticamente;
7. distinguir current state de snapshots históricos;
8. aplicar el mínimo cambio para registrar los estados de §8;
9. preservar los estados de §9;
10. preservar las no-implicaciones de §10;
11. preservar la Phase boundary de §12;
12. no tocar otro path;
13. revisar el diff literal completo;
14. ejecutar `git diff --check`;
15. medir identidad física final;
16. comprobar ausencia de secrets;
17. mantener cambios unstaged;
18. devolver evidencia al Revisor Central;
19. detenerse sin staging, commit ni push.

No debe auto-corregir drift adicional.

---

## 22. Estrategia de verificación documental

CORR-044 es documentation-only.

Una futura implementación no necesita ejecutar application tests, DB tests o Hosted tests sólo para demostrar el cambio documental.

La evidencia mínima requerida será:

1. preflight Git fresco;
2. source identity de TASK-021;
3. source identity de CORR-043;
4. target physical identity pre-edit;
5. complete changed-path inventory;
6. complete diff del target;
7. prueba de que los hunks se limitan a §17;
8. prueba de que los seis estados de §8 están representados;
9. prueba de que los seis estados abiertos de §9 permanecen abiertos;
10. prueba de las cuatro no-implicaciones principales;
11. prueba de que Client permanece en Phase 3;
12. prueba de que UserClientAccess/SupportAccessGrant físicos no pasan a Phase 2;
13. prueba de que no se define Phase 2 Exit Gate;
14. prueba de que no se cierra Phase 2;
15. prueba de que no se inicia Phase 3;
16. prueba de que TASK-022 no se determina;
17. prueba de que los documentos históricos permanecen byte-unchanged;
18. `git diff --check = PASS`;
19. secret review = PASS;
20. final physical target identity;
21. final worktree/index state;
22. Supabase/Hosted mutation = NONE.

Si una verificación requiere modificar código o ejecutar Hosted, el Gate debe detenerse.

---

## 23. Failure / blocker model

### 23.1 Source identity drift

Si TASK-021 o CORR-043 no coinciden con las identidades autorizadas y no existe un Gate posterior que haya aprobado el cambio:

```text
CORR-044 IMPLEMENTATION =
BLOCKER — REQUIRED SOURCE IDENTITY DRIFT
```

### 23.2 Current-state ownership drift

Si §17 deja de ser el current-state owner o aparece un registry posterior:

```text
CORR-044 IMPLEMENTATION =
BLOCKER — CURRENT-STATE OWNERSHIP SUPERSEDED
```

### 23.3 Target drift material

Si el target cambia antes de implementación de forma que la corrección ya no pueda aplicarse inequívocamente:

```text
CORR-044 IMPLEMENTATION =
BLOCKER — TARGET BASELINE DRIFT
```

No auto-merge.

### 23.4 Additional target

Si se requiere un segundo archivo:

```text
CORR-044 IMPLEMENTATION =
BLOCKER — ADDITIONAL DOCUMENT TARGET REQUIRED
```

### 23.5 Additional semantic surface

Si la corrección requiere salir de §17:

```text
CORR-044 IMPLEMENTATION =
BLOCKER — ADDITIONAL DOCUMENT SURFACE REQUIRED
```

### 23.6 New semantic decision

Si la corrección requiere cambiar producto, dominio, arquitectura, seguridad, RLS, multitenancy, Auth/session, offline o phase boundary:

```text
CORR-044 IMPLEMENTATION =
BLOCKER — NEW SEMANTIC DECISION REQUIRED
```

### 23.7 Historical rewrite

Si una propuesta pretende modernizar snapshots históricos:

```text
CORR-044 IMPLEMENTATION =
BLOCKER — HISTORICAL SNAPSHOT BOUNDARY VIOLATION
```

### 23.8 Phase overstatement

Si el diff implica cualquiera de los siguientes:

```text
F-021-I-001 = RESOLVED
TASK-021 = DONE/CLOSED
Phase 2 Exit Gate = DEFINED/SATISFIED
Phase 2 = CLOSED
Phase 3 = STARTED
TASK-022 = DETERMINED
```

sin Gate posterior separado:

```text
CORR-044 IMPLEMENTATION =
FAIL — UNAUTHORIZED STATE ADVANCEMENT
```

### 23.9 Technical-path mutation

Si cambia cualquier path bajo código/tests/supabase/config/package:

```text
CORR-044 IMPLEMENTATION =
BLOCKER — NON-DOCUMENTATION PATH MUTATION
```

---

## 24. Acceptance Criteria

Cada criterio debe poder evaluarse individualmente como `PASS` o `FAIL`.

### Identidad y gobernanza

**AC-044-001.** El ID es exactamente `CORR-044`.

**AC-044-002.** El título es exactamente `CORR-044 — TASK-021 / CORR-043 Current-State Documentation Sync`.

**AC-044-003.** La clase es `DOCUMENTATION CORRECTION SPECIFICATION`.

**AC-044-004.** Esta generación queda `GENERATED / PENDING REVIEW` y no se autoaprueba.

**AC-044-005.** La especificación no autoriza implementación por sí misma.

### Target y scope

**AC-044-006.** El future target count es exactamente `1`.

**AC-044-007.** El único target es `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-044-008.** La única superficie semántica autorizada es §17.

**AC-044-009.** No se crea un segundo current-state registry.

**AC-044-010.** Ningún documento TASK/CORR/ADR histórico se convierte en target.

### State transitions

**AC-044-011.** §17 registra `CORR-043 = TECHNICALLY COMPLETE / HOSTED REVIEW APPROVED`.

**AC-044-012.** §17 registra `F-043-H-001 = RESOLVED`.

**AC-044-013.** §17 registra `F-043-H-002 = RESOLVED`.

**AC-044-014.** §17 registra `F-021-I-006 = RESOLVED`.

**AC-044-015.** §17 registra `TASK-021 implementation/current-source review = APPROVED`.

**AC-044-016.** §17 registra `TASK-021 Work Item I = NOT COMPLETE — REMAINING HOSTED §36 VERIFICATION PENDING`.

### Open-state preservation

**AC-044-017.** `F-021-I-001` permanece `OPEN — HOSTED §36 FUNCTIONAL VERIFICATION PENDING`.

**AC-044-018.** `TASK-021 Work Item I` permanece `NOT COMPLETE`.

**AC-044-019.** `TASK-021` permanece `NOT DONE / NOT CLOSED`.

**AC-044-020.** Phase 2 permanece `IN PROGRESS / NOT CLOSED`.

**AC-044-021.** Phase 2 Exit Gate permanece `NOT YET DEFINED`.

**AC-044-022.** Phase 3 permanece `NOT STARTED`.

**AC-044-023.** TASK-022 no se determina, genera ni inicia.

### Non-implications

**AC-044-024.** CORR-043 technical completion no se representa como TASK-021 completion.

**AC-044-025.** `F-021-I-006 = RESOLVED` no se representa como `F-021-I-001 = RESOLVED`.

**AC-044-026.** TASK-021 implementation/current-source review aprobado no se representa como Work Item I completo.

**AC-044-027.** CORR-043 Hosted PASS no se representa como Phase 2 closure.

### Phase boundary

**AC-044-028.** `Client = Phase 3` permanece intacto.

**AC-044-029.** Physical UserClientAccess no se vuelve requisito para Phase 2 close.

**AC-044-030.** Physical/full SupportAccessGrant no se vuelve requisito para Phase 2 close.

**AC-044-031.** No se mueve Client mínimo/temporal/parcial a Phase 2.

**AC-044-032.** RF-015 no se declara satisfecho por zero client assignment.

### Security / architecture / domain

**AC-044-033.** Product requirement change = NO.

**AC-044-034.** Domain change = NO.

**AC-044-035.** Architecture change = NO.

**AC-044-036.** Security change = NO.

**AC-044-037.** RLS change = NO.

**AC-044-038.** Multitenancy change = NO.

**AC-044-039.** Auth/session behavior change = NO.

**AC-044-040.** Offline behavior change = NO.

**AC-044-041.** New ADR required = NO.

### Technical and Hosted boundaries

**AC-044-042.** Application code change = NO.

**AC-044-043.** Migration change = NO.

**AC-044-044.** Supabase Cloud change = NO.

**AC-044-045.** TASK-021 remaining Hosted §36 execution no se autoriza ni ejecuta mediante CORR-044.

### Historical preservation / verification

**AC-044-046.** Los documentos listados en §11 permanecen sin modificación.

**AC-044-047.** Una futura implementación demuestra changed path count = 1.

**AC-044-048.** Una futura implementación demuestra todos los hunks confinados a §17.

**AC-044-049.** `git diff --check = PASS`.

**AC-044-050.** No existe secret leakage.

### Governance sequencing

**AC-044-051.** Specification review, human approval, approved artifact, canonicalization, incorporation, implementation, staging, commit, push, remote verification y final closure permanecen Gates separados.

**AC-044-052.** Ningún Gate implica o autoriza automáticamente el siguiente.

**AC-044-053.** CORR-044 completion no determina TASK-022.

**AC-044-054.** CORR-044 completion no cierra TASK-021.

**AC-044-055.** CORR-044 completion no cierra Phase 2 ni inicia Phase 3.

---

## 25. Definition of Done

CORR-044 sólo podrá considerarse completada cuando todos los requisitos aplicables siguientes hayan sido satisfechos mediante Gates separados y evidencia revisable.

### Specification lifecycle

**DoD-044-001.** `CORR-044 SPEC REVIEW = APPROVED`.

**DoD-044-002.** Existe aprobación humana expresa de la especificación después del spec review.

**DoD-044-003.** Si el governance vigente requiere approved artifact separado, éste se genera mediante Gate separado.

**DoD-044-004.** El approved artifact obtiene review separado antes de canonicalization.

**DoD-044-005.** Canonicalization requiere autorización humana separada.

**DoD-044-006.** Canonicalization se ejecuta sobre el artefacto aprobado exacto.

**DoD-044-007.** Canonicalization obtiene review separado.

**DoD-044-008.** Repository incorporation requiere autorización separada.

**DoD-044-009.** Repository incorporation contiene exclusivamente el canonical artifact revisado.

**DoD-044-010.** Repository incorporation obtiene review separado.

### Implementation lifecycle

**DoD-044-011.** Existe implementation authorization separada.

**DoD-044-012.** La implementación realiza preflight Git/documental fresco.

**DoD-044-013.** TASK-021 canonical SHA se verifica antes de editar.

**DoD-044-014.** CORR-043 canonical SHA se verifica antes de editar.

**DoD-044-015.** Se verifica el target físico antes de editar.

**DoD-044-016.** Se confirma que §17 sigue siendo current-state owner.

**DoD-044-017.** Se confirma que no existe source posterior que superseda el estado autorizado.

**DoD-044-018.** Se modifica exactamente un archivo.

**DoD-044-019.** El único archivo modificado es `docs/product/11-phase-1-scope-entry-gate.md`.

**DoD-044-020.** Todos los hunks semánticos están confinados a §17.

**DoD-044-021.** Los estados de AC-044-011..016 quedan representados.

**DoD-044-022.** Los estados de AC-044-017..023 permanecen abiertos.

**DoD-044-023.** Las no-implicaciones AC-044-024..027 permanecen inequívocas.

**DoD-044-024.** La Phase boundary AC-044-028..032 permanece intacta.

**DoD-044-025.** Los documentos históricos/canónicos de §11 permanecen sin cambios.

**DoD-044-026.** No se modifica producto, dominio, arquitectura, seguridad, RLS, multitenancy, Auth/session ni offline.

**DoD-044-027.** No se modifica código, migration, test, package, Supabase config ni Hosted state.

**DoD-044-028.** `git diff --check = PASS`.

**DoD-044-029.** Secret leakage review = PASS.

**DoD-044-030.** La identidad física final del target es reportada desde bytes reales.

**DoD-044-031.** Implementation review del diff completo = APPROVED mediante Gate separado.

### Git lifecycle

**DoD-044-032.** Staging requiere autorización humana separada después de implementation review.

**DoD-044-033.** Staging contiene exclusivamente el cambio CORR-044 aprobado.

**DoD-044-034.** Staging review = APPROVED mediante Gate separado.

**DoD-044-035.** Commit requiere autorización humana separada.

**DoD-044-036.** Commit contiene exclusivamente el estado staged revisado.

**DoD-044-037.** Commit review = APPROVED mediante Gate separado.

**DoD-044-038.** Push requiere autorización humana separada.

**DoD-044-039.** Push contiene exclusivamente el commit autorizado.

**DoD-044-040.** Push review / remote verification = APPROVED mediante Gate separado.

### Closure and preservation

**DoD-044-041.** CORR-044 final human closure ocurre mediante Gate separado.

**DoD-044-042.** `F-021-I-001` continúa OPEN al cierre de CORR-044 salvo un Gate posterior independiente que lo haya resuelto antes y haya superseded esta especificación.

**DoD-044-043.** TASK-021 no se declara DONE/CLOSED por CORR-044.

**DoD-044-044.** Phase 2 no se declara CLOSED por CORR-044.

**DoD-044-045.** Phase 2 Exit Gate no se define ni satisface por CORR-044.

**DoD-044-046.** Phase 3 no se inicia por CORR-044.

**DoD-044-047.** TASK-022 no se determina, genera, autoriza ni inicia por CORR-044.

**DoD-044-048.** CORR-044 closure no se interpreta como autorización de TASK-021 remaining Hosted §36.

**DoD-044-049.** Todos los `AC-044-001..055 = PASS`.

---

## 26. Git governance

Se preserva estrictamente:

```text
SPECIFICATION GENERATION
→ SPEC REVIEW
→ HUMAN SPEC APPROVAL
→ APPROVED ARTIFACT GENERATION if required
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
→ PUSH REVIEW / REMOTE VERIFICATION
→ FINAL HUMAN CLOSURE
```

Cada flecha requiere el Gate aplicable.

No se permiten por inferencia:

```text
git add
git add -A
git commit
git push
git stash
git reset
git restore
git checkout over changes
git clean
git pull
git merge
git rebase
```

La generación de esta especificación no ejecuta ninguna operación Git.

---

## 27. Plan futuro de ejecución

Sólo después de aprobación, canonicalization, repository incorporation y autorización humana separada de implementación, el implementador deberá:

1. ejecutar preflight fresco;
2. verificar source identities;
3. recuperar target physical identity;
4. verificar no supersession;
5. leer §17 completo;
6. identificar las líneas activas stale relacionadas con TASK-021/CORR-043;
7. realizar el mínimo cambio documental;
8. preservar TASK-020 y estados anteriores ya correctos;
9. añadir los estados post-CORR-043 necesarios sin declarar TASK-021 cerrado;
10. conservar `F-021-I-001 = OPEN`;
11. conservar Phase 2 abierta;
12. conservar Exit Gate no definido;
13. conservar Phase 3 no iniciada;
14. conservar Client en Phase 3;
15. revisar diff completo;
16. ejecutar `git diff --check`;
17. medir target final;
18. demostrar no technical mutation;
19. demostrar no Hosted access;
20. dejar cambios unstaged;
21. devolver evidencia al Revisor Central;
22. detenerse.

---

## 28. Checklist del CORR-044 SPEC REVIEW

El Revisor Central deberá verificar como mínimo:

1. ID exacto `CORR-044`;
2. título dentro de la autorización humana;
3. class = documentation correction;
4. target count = 1;
5. target exacto correcto;
6. superficie §17 exclusivamente;
7. ownership current-state consumida correctamente;
8. state transitions exactamente acotadas a lo aprobado;
9. `F-021-I-001` permanece open;
10. TASK-021 permanece not done/not closed;
11. Work Item I permanece incomplete;
12. F-021-I-006 queda resolved;
13. F-043-H-001/H-002 quedan resolved;
14. CORR-043 queda técnicamente complete/Hosted review approved, sin inventar cierre adicional;
15. historical artifacts permanecen read-only;
16. CORR-039 phase boundary se preserva;
17. Client no se mueve a Phase 2;
18. UserClientAccess/SupportAccessGrant no se adelantan;
19. no product/domain/architecture/security/RLS/multitenancy/Auth/offline change;
20. no Hosted execution;
21. no TASK-022 determination;
22. governance lifecycle queda separado;
23. implementation continúa no autorizada.

Un `FAIL` bloquea aprobación de la especificación.

---

## 29. Estado resultante de esta generación

```text
CORR-044 ID =
CORR-044

CORR-044 SPECIFICATION GENERATION AUTHORIZATION =
AUTHORIZED

CORR-044 SPECIFICATION GENERATION =
PASS

CORR-044 specification =
HUMAN APPROVED

CORR-044 SPEC REVIEW =
APPROVED

CORR-044 HUMAN SPEC APPROVAL =
APPROVED

CORR-044 approved artifact =
GENERATED / REVIEW APPROVED

CORR-044 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-044 canonicalization authorization =
APPROVED

CORR-044 canonicalization =
PASS

CORR-044 canonical artifact =
GENERATED / PENDING CANONICALIZATION REVIEW

target =
docs/product/11-phase-1-scope-entry-gate.md

target count =
1

semantic surface =
§17

product/domain change =
NO

architecture change =
NO

security/RLS/multitenancy change =
NO

Auth/session behavior change =
NO

offline change =
NO

Hosted change =
NO

repository mutation =
NO

F-021-I-006 =
RESOLVED

F-021-I-001 =
OPEN

TASK-021 Work Item I =
NOT COMPLETE

TASK-021 =
NOT DONE / NOT CLOSED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED

TASK-022 =
NOT DETERMINED / NOT GENERATED / NOT STARTED

implementation authorized =
NO

staging =
NO

commit =
NO

push =
NO
```

---

## 30. Gate posterior

El siguiente Gate exacto es exclusivamente:

```text
CORR-044 CANONICALIZATION REVIEW
```

**DESTINO:**

```text
CHATGPT — MISMO CHAT REVISOR CENTRAL
```

Ese review no autoriza automáticamente repository incorporation ni implementación.

La secuencia posterior permanece separada y requiere autorización expresa en cada Gate.

---

<!-- FIN DEL DOCUMENTO CORR-044-task-021-corr-043-current-state-documentation-sync.md -->
