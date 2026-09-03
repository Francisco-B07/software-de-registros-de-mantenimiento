# CORR-018 — Sincronización documental posterior al cierre de TASK-013

## 1. Identificación

**ID:** `CORR-018`

**Título:** `CORR-018 — Sincronización documental posterior al cierre de TASK-013`

**Tipo:** `CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO`

**Naturaleza:** exclusivamente documental.

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:** `CORR-018-task-013-closure-state-sync-approved.md`

**Ruta canónica futura propuesta:** `docs/tasks/CORR-018-task-013-closure-state-sync.md`

La ruta propuesta es consistente con el patrón canónico vigente:

- `docs/tasks/CORR-010-task-008-closure-state-sync.md`
- `docs/tasks/CORR-011-task-009-closure-state-sync.md`
- `docs/tasks/CORR-012-task-010-closure-state-sync.md`
- `docs/tasks/CORR-013-task-011-closure-state-sync.md`
- `docs/tasks/CORR-014-task-012-closure-state-sync.md`

**Implementación realizada por esta especificación:** `NO`

**Repositorio modificado:** `NO`

**Supabase Cloud modificado:** `NO`

**Git add / commit / push:** `NO / NO / NO`

**TASK-014 determinada / generada / iniciada:** `NO / NO / NO`

---

## 2. Objetivo único

CORR-018 tiene como objetivo exclusivo sincronizar el estado activo de:

`docs/product/11-phase-1-scope-entry-gate.md`

después del cierre técnico, Hosted, Git y humano de TASK-013.

La futura corrección debe eliminar únicamente el drift documental activo que todavía representa TASK-013 como bloqueada, no autorizada o no implementada.

La sincronización debe registrar el resultado técnico cerrado de TASK-013 sin transformar sus foundations en capacidades funcionales completas y sin reescribir historia normativa.

Debe preservarse la regla:

**sincronizar estado activo != reescribir snapshots históricos**

CORR-018 no implementa una capability, no modifica arquitectura y no determina el siguiente incremento.

---

## 3. Contexto formal

El estado formal consumido por esta especificación es:

- `POST-TASK-013 DISCOVERY REVIEW = APPROVED`
- `CORR-018 DETERMINATION REVIEW = APPROVED`
- `CORR-018 DETERMINATION = APPROVED`
- `TASK-013 = DONE`
- `TASK-013 FINAL HUMAN CLOSURE = APPROVED`
- `TASK-013 implementation commit = d3de418a55b44678053477f3de59d24cd2119350`
- `final E2 hook enforcement = ACTIVE AND VERIFIED`
- `E2 SESSION CUTOVER = PASS`
- `cutover route = A1`
- `Phase 2 = INICIADA`
- `Phase 2 = NOT DONE`
- `Phase 3 = NOT STARTED`
- `TASK-014 = NOT DETERMINED`
- `TASK-014 = NOT GENERATED`
- `TASK-014 = NOT STARTED`

El commit de implementación presente en `main` es:

`d3de418a55b44678053477f3de59d24cd2119350 — feat(auth): implement TASK-013 verification challenge foundation`

Este cierre no convierte Auth en una capacidad funcional terminada ni autoriza TASK-014.

---

## 4. Preflight read-only verificado

El preflight realizado antes de redactar esta especificación produjo:

| Control | Resultado |
| --- | --- |
| Branch                     | `main`                                     |
| HEAD                       | `d3de418a55b44678053477f3de59d24cd2119350` |
| origin/main                | `d3de418a55b44678053477f3de59d24cd2119350` |
| Divergence                 | `0 0`                                      |
| Worktree                   | `CLEAN`                                    |
| Git operations in progress | `NONE`                                     |

Resultado:

`GIT BASELINE = PASS`

No existe `GIT BASELINE DRIFT`.

Este preflight sólo valida la base usada para redactar la especificación. La futura ejecución de CORR-018 deberá repetirlo inmediatamente antes de modificar el documento target.

---

## 5. Fuentes normativas

Se consumieron como fuentes canónicas mínimas:

- `docs/product/11-phase-1-scope-entry-gate.md`
- `docs/tasks/CORR-011-task-009-closure-state-sync.md`
- `docs/tasks/CORR-012-task-010-closure-state-sync.md`
- `docs/tasks/CORR-013-task-011-closure-state-sync.md`
- `docs/tasks/CORR-014-task-012-closure-state-sync.md`
- `docs/tasks/CORR-015-adr-0019-accepted-state-sync.md`
- `docs/tasks/CORR-016-corr-015-task-013-noncanonical-reference.md`
- `docs/tasks/CORR-017-db-regression-harness-normalization.md`
- `docs/tasks/TASK-013-verification-challenge-foundation.md`
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`

También se verificó el historial Git necesario para establecer:

- la canonicalización de TASK-013;
- la incorporación de CORR-017;
- la normalización del harness DB;
- la implementación final de TASK-013;
- el estado sincronizado de `HEAD` y `origin/main`.

### 5.1 Orden de autoridad

Para CORR-018 se aplica el siguiente orden:

1. cierre humano y determinación formal aprobados;
2. estado real de Git y commit de implementación;
3. documentos canónicos vigentes;
4. snapshots históricos, interpretados según el momento y acto de gobernanza que documentan.

Una especificación histórica que declara `TASK-013 implementada = NO` conserva validez como snapshot del momento anterior a la ejecución. No puede utilizarse como estado activo posterior al cierre.

---

## 6. Precondiciones

La futura ejecución de CORR-018 requiere:

1. especificación de CORR-018 revisada y aprobada humanamente;
2. canonicalización de esta especificación cuando corresponda;
3. revisión de la canonicalización;
4. incorporación Git de la especificación mediante Gate separado;
5. autorización humana separada para ejecutar la corrección;
6. preflight Git fresco;
7. `main`, `HEAD` y `origin/main` en el baseline expresamente autorizado;
8. worktree limpio y sin operaciones Git en progreso;
9. existencia del único target autorizado;
10. confirmación de que §7.9, §10.2, §14.2 y §17 conservan su función semántica;
11. ausencia de una superficie activa stale adicional;
12. ausencia de contradicciones materiales entre el cierre aprobado y el canon vigente.

El incumplimiento de una precondición obliga a detener la ejecución.

---

## 7. Hechos aprobados que deben sincronizarse

La futura corrección debe registrar, en las superficies donde sean semánticamente necesarios:

- `TASK-013 = COMPLETADA`
- `TASK-013 FINAL HUMAN CLOSURE = APPROVED`
- `VerificationChallenge foundation = IMPLEMENTADA`
- `VerificationChallenge lifecycle physical foundation = IMPLEMENTADA`
- `SessionGrant foundation = IMPLEMENTADA`
- `server-only technical-password bridge foundation = IMPLEMENTADA`
- `Custom Access Token Hook gate = IMPLEMENTADO`
- `final E2 hook enforcement = ACTIVE AND VERIFIED`
- `E2 SESSION CUTOVER = PASS`
- `cutover route = A1`
- `TASK-013 implementation commit = d3de418a55b44678053477f3de59d24cd2119350`

No es obligatorio repetir todos los hechos en todas las secciones.

La futura ejecución debe aplicar esta distribución mínima:

| Superficie | Hechos mínimos requeridos |
| --- | --- |
| §7.9                                | Cierre de TASK-013, foundations implementadas, enforcement E2 activo, límites funcionales y frontera TASK-014 |
| §10.2                               | TASK-013 completada y cierre humano, resultado técnico acotado, secuenciación hacia TASK-014                  |
| §14.2                               | Resultado técnico de las foundations, cutover A1 y capacidades que continúan pendientes                       |
| §17                                 | Resumen final de TASK-013, commit, cierre humano, E2 y estados de fases/TASK-014                              |

Debe evitarse duplicación que no contribuya a restaurar coherencia.

---

## 8. Capacidades que deben continuar pendientes

CORR-018 no puede representar las foundations de TASK-013 como una capacidad funcional completa.

El estado activo resultante debe preservar, donde corresponda:

- `Auth funcional = NO`
- `UI/Auth flow funcional completo = NO`
- `onboarding funcional completo = NO`
- `alta funcional completa = NO`
- `lifecycle funcional completo de usuarios/memberships = NO`
- `disable/reinstate/role-change funcional = NO`
- `route authorization funcional completa = NO`
- `resource authorization funcional completa = NO`
- `Application authorization completa = NO`
- `AuditEvent producers funcionales completos = NO`
- `auditoría funcional completa = NO`
- `UserClientAccess completo = NO`
- `SupportAccessGrant completo = NO`
- `Phase 2 = INICIADA`
- `Phase 2 = NOT DONE`
- `Phase 3 = NOT STARTED`
- `TASK-014 determinada = NO`
- `TASK-014 generada = NO`
- `TASK-014 iniciada = NO`

No se encontró evidencia canónica que autorice declarar como funcionalmente completos disable, reinstate o role change.

Debe distinguirse expresamente:

- `SessionGrant foundation = IMPLEMENTADA` de `SupportAccessGrant completo = NO`;
- `Custom Access Token Hook gate = IMPLEMENTADO` de `Auth funcional = NO`;
- sesión Auth establecida de tenant authorization;
- foundation física de lifecycle de un lifecycle funcional completo de usuarios o memberships.

---

## 9. Drift detectado

La auditoría read-only de `docs/product/11-phase-1-scope-entry-gate.md` confirmó drift activo exclusivamente en:

- §7.9;
- §10.2;
- §14.2;
- §17.

Las cuatro superficies todavía presentan, total o parcialmente:

- TASK-013 como bloqueada por decisión arquitectónica;
- TASK-013 como no autorizada para implementación;
- TASK-013 como no implementada;
- `VerificationChallenge = NO`;
- una frontera de gobernanza anterior a su cierre.

Esas declaraciones contradicen el estado aprobado posterior:

- TASK-013 está completada;
- su implementación está en `main` y `origin/main`;
- su cierre humano fue aprobado;
- el enforcement E2 final está activo y verificado;
- el cutover E2 fue aprobado por Ruta A1.

Resultado de auditoría:

- `EXPECTED ACTIVE STALE SURFACES = 4`
- `UNEXPECTED ACTIVE STALE SURFACES = 0`
- `SPECIFICATION BLOCKER — UNEXPECTED ACTIVE STALE SURFACE = NO`

Las referencias a Fase 3 fuera de estas superficies describen límites generales o historia de fases y no constituyen drift post-TASK-013.

---

## 10. Alcance

### 10.1 Único target autorizado

La futura ejecución sólo puede modificar:

`docs/product/11-phase-1-scope-entry-gate.md`

`CHANGE REQUIRED file count = 1`

### 10.2 Superficies autorizadas

Dentro del único target, el cambio debe limitarse conceptualmente a:

- §7.9;
- §10.2;
- §14.2;
- §17.

Los números de sección son localizadores semánticos. No autorizan reemplazos ciegos ni cambios basados únicamente en números de línea.

### 10.3 Naturaleza del cambio

El cambio autorizado consiste exclusivamente en:

- reemplazar estado activo stale por estado post-cierre de TASK-013;
- preservar resultados cerrados de TASK-008 a TASK-012;
- preservar ADR-0019 como antecedente arquitectónico aceptado;
- conservar como historia los estados previos de especificación y autorización;
- actualizar la frontera de gobernanza a TASK-014;
- mantener expresamente pendientes las capacidades funcionales no implementadas.

---

## 11. Fuera de alcance

Queda expresamente fuera de alcance:

- código;
- TypeScript;
- package files;
- SQL;
- migrations;
- RLS;
- policies;
- grants o revokes;
- Supabase config;
- Supabase Cloud;
- Auth configuration;
- signing keys;
- hooks Hosted;
- secrets o credenciales;
- tests técnicos de TASK-013;
- modificación de TASK-013;
- modificación de ADR-0019;
- modificación de CORR-015;
- modificación de CORR-016;
- modificación de CORR-017;
- modificación de cualquier otro documento;
- nueva decisión de producto;
- nueva decisión arquitectónica;
- nueva ADR;
- cierre de Fase 2;
- creación de un Phase 2 Exit Gate;
- inicio de Fase 3;
- determinación de TASK-014;
- especificación de TASK-014;
- implementación de TASK-014;
- priorización de la siguiente capability.

CORR-018 tampoco autoriza staging, commit ni push.

---

## 12. CHANGE REQUIRED

### 12.1 Archivo

`docs/product/11-phase-1-scope-entry-gate.md`

### 12.2 Cantidad

`1 archivo`

### 12.3 Secciones

- §7.9
- §10.2
- §14.2
- §17

### 12.4 Regla de mínima modificación

El diff debe ser el mínimo necesario para que las cuatro superficies expresen coherentemente el estado post-TASK-013.

No se autoriza:

- reestructuración general;
- reformateo lateral;
- renumeración;
- limpieza estilística no necesaria;
- cambio de terminología ajeno al drift;
- actualización oportunista de otras fases o tareas.

---

## 13. CHANGE FORBIDDEN

Está prohibido modificar cualquier path distinto de:

`docs/product/11-phase-1-scope-entry-gate.md`

En particular, permanecen inmutables:

- `docs/tasks/TASK-013-verification-challenge-foundation.md`
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`
- `docs/tasks/CORR-015-adr-0019-accepted-state-sync.md`
- `docs/tasks/CORR-016-corr-015-task-013-noncanonical-reference.md`
- `docs/tasks/CORR-017-db-regression-harness-normalization.md`
- todos los demás archivos bajo `docs/`;
- `app/`;
- `src/`;
- `tests/`;
- `supabase/`;
- `.env`;
- `.env.example`;
- `package.json`;
- `package-lock.json`;
- cualquier archivo de configuración.

También está prohibido modificar una sección distinta de las cuatro autorizadas.

Si una quinta superficie activa resulta necesaria para lograr coherencia:

`SPECIFICATION BLOCKER — UNEXPECTED ACTIVE STALE SURFACE`

La ejecución debe detenerse sin incorporar esa superficie silenciosamente.

---

## 14. Detalle por sección

### 14.1 §7.9 — Otras decisiones `DO-*`

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

**Estado actual stale:**

- registra correctamente Fase 2 iniciada y TASK-008..012 completadas;
- todavía enumera `VerificationChallenge = NO`;
- presenta TASK-013 como bloqueada por decisión arquitectónica;
- mantiene `TASK-013 implementación autorizada = NO`;
- mantiene `TASK-013 implementada = NO`;
- conserva una frontera que sólo registra TASK-014 como no determinada/no generada.

**Contradicción:**

Ese estado activo fue correcto después de ADR-0019 y antes de la ejecución de TASK-013, pero contradice el cierre técnico, Hosted, Git y humano ya aprobado.

**Estado final requerido:**

Debe registrar:

- `TASK-013 = COMPLETADA`;
- `TASK-013 FINAL HUMAN CLOSURE = APPROVED`;
- `VerificationChallenge foundation = IMPLEMENTADA`;
- `VerificationChallenge lifecycle physical foundation = IMPLEMENTADA`;
- `SessionGrant foundation = IMPLEMENTADA`;
- `server-only technical-password bridge foundation = IMPLEMENTADA`;
- `Custom Access Token Hook gate = IMPLEMENTADO`;
- `final E2 hook enforcement = ACTIVE AND VERIFIED`;
- `E2 SESSION CUTOVER = PASS`;
- `cutover route = A1`.

Puede incluir el commit de implementación si resulta necesario para mantener la misma trazabilidad usada con tareas anteriores.

**Historia que debe preservarse:**

- ADR-0019 fue la decisión arquitectónica previa;
- TASK-013 tuvo una especificación histórica inicialmente bloqueada;
- existieron Gates separados de corrección, aprobación, canonicalización, implementación y cierre;
- los resultados técnicos cerrados de TASK-008..012;
- los estados de los `DO-*` que no fueron alterados por TASK-013.

El estado bloqueado anterior sólo puede conservarse si queda inequívocamente clasificado como histórico, no como estado activo vigente.

**Capacidades que continúan pendientes:**

Auth funcional, flujo UI/Auth completo, onboarding, alta completa, lifecycle funcional de usuarios/memberships, disable/reinstate/role-change, route authorization completa, resource authorization completa, productores funcionales completos de AuditEvent, UserClientAccess completo, SupportAccessGrant completo y cierre de Fase 2.

La frontera debe quedar en:

- `TASK-014 = NOT DETERMINED`
- `TASK-014 = NOT GENERATED`
- `TASK-014 = NOT STARTED`
- `Siguiente TASK autorizada automáticamente = NO`

### 14.2 §10.2 — Requisito para entrar en Fase 2

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

**Estado actual stale:**

La sección conserva como estado activo la separación previa:

`ADR-0019 accepted/canonicalized != TASK-013 corrected != TASK-013 approved for implementation != TASK-013 implemented`

y enumera TASK-013 como bloqueada, no autorizada y no implementada.

**Contradicción:**

La secuencia histórica fue válida, pero todos los Gates de TASK-013 ya fueron atravesados hasta su cierre humano final. Presentarla como estado vigente contradice `TASK-013 = DONE`.

**Estado final requerido:**

La sección debe:

- preservar que Fase 2 está iniciada;
- registrar TASK-013 como completada;
- registrar su cierre humano final;
- resumir su resultado como foundations técnicas implementadas;
- registrar, cuando sea necesario, el enforcement E2 activo, el cutover PASS y la Ruta A1;
- mantener que Fase 2 todavía no está terminada;
- establecer que el cierre de TASK-013 no determina TASK-014.

La regla vigente debe quedar expresada como:

`TASK-013 = COMPLETADA != TASK-014 determinada automáticamente`

y, de forma inequívoca:

- `TASK-014 determinada = NO`
- `TASK-014 generada = NO`
- `TASK-014 iniciada = NO`

**Historia que debe preservarse:**

- ADR-0019 fue aceptada y canonicalizada antes de la implementación;
- la especificación original bloqueada fue un snapshot histórico;
- la corrección, aprobación, canonicalización, autorización, ejecución y cierre fueron actos separados;
- las tareas anteriores y sus resultados acotados.

**Capacidades pendientes:**

La sección no debe convertir la foundation de challenge, SessionGrant, technical-password bridge o hook en Auth funcional, onboarding, alta, lifecycle completo o autorización completa.

### 14.3 §14.2 — Condición adicional para cruzar hacia Fase 2

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

**Estado actual stale:**

El resultado activo llega hasta TASK-012 y todavía declara:

- `VerificationChallenge = NO`;
- TASK-013 bloqueada;
- TASK-013 no autorizada;
- TASK-013 no implementada.

**Contradicción:**

TASK-013 ya materializó la foundation física aprobada y completó el Gate Hosted E2. La sección ya no representa el estado técnico actual de Fase 2.

**Estado final requerido:**

Debe avanzar el resultado activo hasta TASK-013 e incorporar:

- `VerificationChallenge foundation = IMPLEMENTADA`;
- `VerificationChallenge lifecycle physical foundation = IMPLEMENTADA`;
- `SessionGrant foundation = IMPLEMENTADA`;
- `server-only technical-password bridge foundation = IMPLEMENTADA`;
- `Custom Access Token Hook gate = IMPLEMENTADO`;
- `final E2 hook enforcement = ACTIVE AND VERIFIED`;
- `E2 SESSION CUTOVER = PASS`;
- `cutover route = A1`.

**Historia que debe preservarse:**

- condiciones de entrada a Fase 2;
- separación entre Gate de salida de Fase 1, Gate de entrada de Fase 2 e inicio formal;
- resultados acotados de TASK-008..012;
- ADR-0019 como decisión arquitectónica previa;
- el blocker histórico de TASK-013, sólo si se identifica expresamente como histórico.

**Capacidades pendientes:**

Debe continuar explícito que las foundations de TASK-013 no equivalen a:

- Auth funcional;
- UI/Auth flow completo;
- onboarding o alta completos;
- lifecycle funcional completo;
- disable/reinstate/role-change funcional;
- route authorization completa;
- resource authorization completa;
- UserClientAccess completo;
- SupportAccessGrant completo;
- auditoría funcional completa.

`authenticated != authorized` debe permanecer vigente.

### 14.4 §17 — Resultado final

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

**Estado actual stale:**

La superficie final:

- termina en TASK-012;
- declara `VerificationChallenge = NO`;
- mantiene TASK-013 bloqueada, no autorizada y no implementada;
- sólo registra TASK-014 como no determinada/no generada.

**Contradicción:**

§17 es el resumen activo final del documento y debe reflejar el cierre ya aprobado de TASK-013.

**Estado final requerido:**

Debe registrar, con el formato existente cuando sea posible:

- `TASK-013 completada: sí`;
- `TASK-013 FINAL HUMAN CLOSURE: APPROVED`;
- `TASK-013 implementation commit: d3de418a55b44678053477f3de59d24cd2119350`;
- `VerificationChallenge foundation: implementada`;
- `VerificationChallenge lifecycle physical foundation: implementada`;
- `SessionGrant foundation: implementada`;
- `server-only technical-password bridge foundation: implementada`;
- `Custom Access Token Hook gate: implementado`;
- `final E2 hook enforcement: ACTIVE AND VERIFIED`;
- `E2 SESSION CUTOVER: PASS`;
- `cutover route: A1`;
- `Auth funcional: no`;
- `Fase 2 iniciada: sí`;
- `Fase 2 completada: no`;
- `Fase 3 iniciada: no`;
- `TASK-014 determinada: no`;
- `TASK-014 generada: no`;
- `TASK-014 iniciada: no`;
- `Siguiente TASK autorizada automáticamente: no`.

**Historia que debe preservarse:**

- cierre de Fase 0 y Fase 1;
- Gate e inicio formal de Fase 2;
- resultados de TASK-008..012;
- secuencia arquitectónica y documental que precedió a TASK-013;
- snapshots anteriores cuando estén claramente descritos como historia.

§17 no debe transformarse en un changelog general ni en una especificación del siguiente incremento.

---

## 15. Historia normativa inmutable

No se modificarán:

- TASK-013 canónica;
- ADR-0019;
- CORR-015;
- CORR-016;
- CORR-017;
- frases históricas o condicionales dentro de esos documentos.

Dentro del propio documento target tampoco se modernizarán retrospectivamente:

- reglas de alcance originales de Fase 1;
- restricciones que eran aplicables antes de Fase 2;
- condiciones históricas de los Gates;
- estados anteriores claramente identificados como snapshots;
- hechos sobre qué estaba o no implementado al momento de aprobar una tarea o corrección anterior.

Una declaración histórica como `TASK-013 implementación autorizada = NO` puede seguir siendo correcta dentro de la especificación canónica de TASK-013. No puede permanecer como estado activo actual de §7.9, §10.2, §14.2 o §17.

---

## 16. Arquitectura y dominio

CORR-018 registra un estado ya aprobado. No toma decisiones nuevas.

- `architecture change = NO`
- `domain change = NO`
- `Auth architecture change = NO`
- `multitenancy change = NO`
- `offline change = NO`
- `ADR nueva = NO`
- `OPEN resuelto = NINGUNO`

ADR-0019 permanece como la autoridad arquitectónica de la solución E2 implementada por TASK-013.

CORR-018 no modifica, amplía ni reinterpreta esa decisión.

---

## 17. Seguridad

- `security implementation = NONE`
- `security change = NO`
- `Auth behavior change = NONE`
- `secret handling change = NONE`

La corrección sólo describe un estado técnico y Hosted ya verificado.

Está prohibido que la redacción:

- revele secrets;
- incorpore technical passwords;
- incorpore signing keys;
- incorpore tokens, grants activos o credenciales;
- describa una sesión Auth como autorización tenant;
- transforme el hook de emisión de token en una autoridad de acceso a recursos;
- amplíe el privileged boundary;
- sugiera acceso browser a credenciales server-only.

---

## 18. RLS y multitenancy

- `RLS implementation = NONE`
- `RLS change = NO`
- `tenant isolation behavior change = NONE`
- `policy change = NO`
- `grant/revoke change = NO`

Debe preservarse:

- `tenant = MaintenanceCompany`;
- `authenticated != authorized`;
- una sesión Auth válida no implica tenant authorization;
- `CompanyMembership` conserva la autoridad de membership vigente;
- `UserClientAccess` conserva su autoridad sobre alcance a clientes cuando sea implementado;
- `SupportAccessGrant` conserva su autoridad sobre soporte excepcional cuando sea implementado;
- RLS conserva su función de frontera primaria de aislamiento remoto;
- current authoritative database state prevalece sobre claims o estado cliente stale;
- `SUPER_ADMIN` no adquiere bypass tenant ordinario.

`SessionGrant` no debe confundirse con `SupportAccessGrant`.

---

## 19. Supabase Cloud

- `Supabase Cloud change = NO`
- `Hosted hook mutation = NO`
- `Auth configuration mutation = NO`
- `session invalidation execution = NO`
- `cutover execution = NO`

CORR-018 puede documentar que el enforcement E2 está activo y verificado y que el cutover A1 resultó PASS.

No puede repetir, modificar ni reabrir esas operaciones.

Staging y Production permanecen fuera de alcance.

---

## 20. Criterios de aceptación

Cada criterio deberá evaluarse individualmente como `PASS` o `FAIL` durante la futura ejecución.

**AC-001.** El único archivo modificado es `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-002.** §7.9 queda sincronizada con el cierre aprobado de TASK-013.

**AC-003.** §10.2 queda sincronizada con el cierre aprobado de TASK-013.

**AC-004.** §14.2 queda sincronizada con el cierre aprobado de TASK-013.

**AC-005.** §17 queda sincronizada con el cierre aprobado de TASK-013.

**AC-006.** TASK-013 queda representada como `COMPLETADA`.

**AC-007.** `VerificationChallenge foundation = IMPLEMENTADA` queda representado sin declarar Auth funcional.

**AC-008.** `final E2 hook enforcement = ACTIVE AND VERIFIED`.

**AC-009.** `E2 SESSION CUTOVER = PASS`.

**AC-010.** `cutover route = A1`.

**AC-011.** `Auth funcional = NO` continúa inequívoco.

**AC-012.** Ninguna capability funcional no implementada es sobredeclarada.

**AC-013.** TASK-014 continúa `NOT DETERMINED / NOT GENERATED / NOT STARTED`.

**AC-014.** Phase 2 continúa `INICIADA` y `NOT DONE`.

**AC-015.** Phase 3 continúa `NOT STARTED`.

**AC-016.** La historia normativa no se reescribe.

**AC-017.** Ningún documento histórico es modificado.

**AC-018.** No existe cambio de arquitectura, seguridad, RLS, multitenancy o dominio.

**AC-019.** No existe cambio en Supabase Cloud.

**AC-020.** No se modifica ni crea ningún path inesperado.

**AC-021.** `git diff --check = PASS`.

**AC-022.** No se incorporan secrets ni material sensible.

**AC-023.** No se determina, genera, especifica ni inicia TASK-014.

Un único `FAIL` impide declarar la ejecución de CORR-018 como satisfactoria.

---

## 21. Verificaciones de la futura ejecución

Antes de editar, Codex deberá verificar:

1. branch exacta;
2. HEAD exacto autorizado;
3. `origin/main` exacto autorizado;
4. divergencia;
5. worktree;
6. staged changes;
7. operaciones Git en progreso;
8. existencia del target;
9. lectura íntegra del target;
10. lectura de las fuentes canónicas necesarias;
11. vigencia semántica de las cuatro superficies;
12. ausencia de superficies activas stale adicionales.

Después de editar y antes de cualquier staging deberá verificar:

- el diff contiene exactamente un archivo;
- el único archivo es el target autorizado;
- el diff se limita conceptualmente a §7.9, §10.2, §14.2 y §17;
- no hay modificaciones técnicas;
- no hay cambios bajo `app/`, `src/`, `tests/` o `supabase/`;
- no hay cambios en package files;
- no hay SQL, migrations, RLS, policies ni Supabase config;
- no hay secretos;
- no hay TASK-014 creada o modificada;
- no se modificó ningún documento histórico;
- `git diff --check = PASS`;
- el diff literal completo fue revisado.

Por ser CORR-018 exclusivamente documental, no se requieren:

- `npm test`;
- DB tests;
- Supabase tests;
- Cloud tests;
- nueva ejecución de los tests técnicos de TASK-013.

---

## 22. Instrucciones para Codex durante la futura ejecución

Cuando exista autorización humana expresa, Codex deberá:

1. repetir el preflight Git;
2. detenerse si el baseline difiere del autorizado;
3. releer íntegramente `docs/product/11-phase-1-scope-entry-gate.md`;
4. localizar semánticamente §7.9, §10.2, §14.2 y §17;
5. confirmar que no existe otra superficie activa stale inseparable;
6. modificar exclusivamente el archivo autorizado;
7. aplicar el cambio semántico mínimo;
8. representar TASK-013 como completada;
9. registrar las foundations sin convertirlas en Auth funcional;
10. preservar los límites funcionales negativos;
11. preservar la historia normativa;
12. mantener Phase 2 iniciada pero no completada;
13. mantener Phase 3 no iniciada;
14. mantener TASK-014 no determinada, no generada y no iniciada;
15. inspeccionar el diff completo;
16. ejecutar `git diff --check`;
17. verificar ausencia de secretos y cambios técnicos;
18. dejar todos los cambios unstaged;
19. devolver el diff y los resultados al Revisor Central.

Codex no deberá realizar `git add`, commit ni push sin Gates humanos posteriores y separados.

---

## 23. Blockers

### 23.1 Estado actual de esta especificación

- `GIT BASELINE DRIFT = NO`
- `UNEXPECTED ACTIVE STALE SURFACE = NO`
- `NAMING PATTERN CONTRADICTION = NO`
- `MISSING CANONICAL SOURCE = NO`
- `CURRENT SPECIFICATION BLOCKER = NONE`

### 23.2 Condiciones de blocker para la futura ejecución

La ejecución debe detenerse si:

1. branch, HEAD, `origin/main` o divergencia no coinciden con la autorización;
2. el worktree no está limpio o existe una operación Git incompatible;
3. falta una fuente canónica;
4. el target no existe;
5. cambió materialmente la función de una de las cuatro secciones;
6. aparece una superficie activa stale adicional;
7. un segundo archivo requiere modificación;
8. se necesita modificar una sección no autorizada;
9. no puede distinguirse historia de estado activo;
10. la corrección exige reescribir historia;
11. se necesita cambiar producto, dominio o arquitectura;
12. se necesita cambiar seguridad, RLS o multitenancy;
13. se necesita modificar Supabase Cloud;
14. se necesita escribir código, SQL o migrations;
15. se necesita modificar tests o configuración técnica;
16. se necesita determinar o diseñar TASK-014;
17. el diff incluye un path inesperado;
18. se detecta un secret;
19. `git diff --check` falla;
20. cualquier criterio de aceptación falla.

Para el caso de una quinta superficie activa:

`SPECIFICATION BLOCKER — UNEXPECTED ACTIVE STALE SURFACE`

Para drift Git:

`CORR-018 SPECIFICATION/EXECUTION = BLOCKER — GIT BASELINE DRIFT`

Ante un blocker:

- no ampliar scope;
- no reparar lateralmente;
- no incorporar la superficie silenciosamente;
- no hacer staging;
- no hacer commit;
- no hacer push;
- devolver el blocker exacto al Revisor Central.

---

## 24. Git governance

CORR-018 preserva la secuencia:

**specification → human review → approval → canonicalization/implementation authorization as applicable → execution → human review → staging Gate → commit Gate → push Gate → human closure**

Deben permanecer separados:

- especificación;
- revisión humana;
- aprobación;
- canonicalización;
- autorización de ejecución;
- ejecución;
- revisión del diff;
- staging;
- commit;
- push;
- cierre humano.

La aprobación formal de esta especificación no autoriza operación Git alguna.

`CORR-018 SPEC REVIEW = APPROVED` no equivale a:

- canonicalización realizada;
- ejecución autorizada;
- implementación realizada;
- cambio aprobado para staging;
- commit autorizado;
- push autorizado;
- CORR-018 completada.

---

## 25. Definition of Done de CORR-018

CORR-018 sólo podrá considerarse completada cuando:

1. esta especificación haya sido revisada humanamente;
2. `CORR-018 SPEC REVIEW = APPROVED`;
3. exista aprobación humana expresa;
4. la especificación se canonicalice cuando corresponda;
5. la canonicalización sea revisada;
6. la especificación sea incorporada mediante los Gates aplicables;
7. exista autorización humana separada de ejecución;
8. el preflight Git fresco resulte PASS;
9. la auditoría confirme exactamente cuatro superficies autorizadas;
10. se modifique exactamente un archivo;
11. §7.9 quede sincronizada;
12. §10.2 quede sincronizada;
13. §14.2 quede sincronizada;
14. §17 quede sincronizada;
15. TASK-013 quede representada como completada;
16. las foundations de TASK-013 queden representadas sin sobredeclaración funcional;
17. el enforcement E2, el cutover PASS y la Ruta A1 queden registrados donde corresponda;
18. Auth funcional continúe pendiente;
19. las capacidades funcionales restantes continúen pendientes;
20. Phase 2 continúe iniciada pero no completada;
21. Phase 3 continúe no iniciada;
22. TASK-014 continúe no determinada, no generada y no iniciada;
23. la historia normativa permanezca intacta;
24. no exista cambio técnico, arquitectónico, de seguridad, RLS, dominio o Cloud;
25. no exista un path inesperado;
26. no se incorporen secretos;
27. todos los criterios de aceptación resulten PASS;
28. `git diff --check = PASS`;
29. el diff completo sea revisado humanamente;
30. staging, commit y push ocurran únicamente mediante Gates posteriores;
31. Git final sea verificado;
32. exista cierre humano final de CORR-018.

Debe mantenerse:

`execution PASS != CORR-018 completed`

y:

`CORR-018 completed != TASK-014 determined automatically`

---

## 26. Estado de esta especificación

- `CORR-018 DETERMINATION = APPROVED`
- `CORR-018 SPECIFICATION = PASS`
- `CORR-018 estado = APPROVED FOR IMPLEMENTATION`
- `CORR-018 SPEC REVIEW = APPROVED`
- `CORR-018 aprobación humana = APPROVED`
- `CORR-018 canonicalizada = NO`
- `CORR-018 ejecución autorizada = NO`
- `CORR-018 ejecutada = NO`
- `CORR-018 completada = NO`
- `CHANGE REQUIRED = 1`
- `UNEXPECTED ACTIVE STALE SURFACES = 0`
- `implementation = NO`
- `repository modification = NO`
- `Supabase Cloud modification = NO`
- `staging = NO`
- `commit = NO`
- `push = NO`

`APPROVED FOR IMPLEMENTATION` describe el estado actual de esta especificación y no autoriza por sí solo su canonicalización ni su ejecución.

---

## 27. Gate posterior

La especificación queda formalmente aprobada en:

`CORR-018 SPEC REVIEW = APPROVED`

La aprobación documental formal no autoriza implementar CORR-018.

El siguiente acto debe ser determinado por el Revisor Central y permanecer separado. La secuencia posterior, cuando cada Gate sea expresamente autorizado, es:

1. canonicalización cuando corresponda;
2. revisión e incorporación de la especificación mediante Gates separados;
3. autorización humana separada para ejecutar CORR-018;
4. ejecución documental controlada;
5. revisión humana del diff;
6. staging Gate;
7. commit Gate;
8. push Gate;
9. verificación Git;
10. cierre humano final de CORR-018;
11. retorno al Revisor Central;
12. acto separado de discovery/determinación del siguiente incremento.

Debe permanecer:

- `TASK-014 = NOT DETERMINED`
- `TASK-014 = NOT GENERATED`
- `TASK-014 = NOT STARTED`

El cierre futuro de CORR-018 no determina automáticamente TASK-014.

Después de CORR-018 deberá existir un acto separado de discovery y determinación del siguiente incremento.

<!-- FIN DEL DOCUMENTO CORR-018-task-013-closure-state-sync.md -->