# CORR-045 — CORR-023 Targeted TASK-013 Regression Selection Compatibility

## 1. Identificación y gobernanza

- **ID:** CORR-045.
- **Tipo:** TEST / LOCAL DB REGRESSION HARNESS SCOPE-SELECTION CORRECTION SPECIFICATION.
- **Fase:** Phase 2 — Multitenancy, autenticación, roles y RLS.
- **Estado de este artefacto:** SPECIFICATION GENERATED / PENDING SPEC REVIEW.
- **Specification generation authorization:** AUTHORIZED por autorización humana explícita de 2026-10-11.
- **Specification generation:** COMPLETED (documental; no implementación).
- **Specification review:** PENDING.
- **Human specification approval:** NOT GRANTED.
- **Canonicalization / repository incorporation / implementation:** NOT AUTHORIZED.
- **Proposed repo-relative canonical target:** `docs/tasks/CORR-045-corr-023-targeted-task-013-regression-selection-compatibility.md` (propuesta documental, no ruta existente demostrada).

Esta especificación no autoriza Codex, ejecución de pruebas, Supabase Local/Hosted, modificaciones del repositorio, Git staging/commit/push ni avance de Gates. `authorization != execution != review`.

## 2. Objetivo único

Definir un mecanismo **opt-in, explícito, fail-closed** en el runner físico canónico de CORR-023 que permita ejecutar **sólo la regresión DB de TASK-013** bajo ALT-001, sin disparar la regresión DB integral, la concurrencia TASK-015, scripts npm ni `git diff --check`, y sin alterar el comportamiento **por defecto** del runner integral de CORR-023.

Esto es selección de ejecución test-only; **no** cambia las expectativas semánticas de TASK-013 ni la autorización para ejecutar §36.28. Una futura implementación y su revisión son Gates separados. Ninguna invocation está autorizada por esta specification.

## 3. Fuentes inspeccionadas e identidad física

Las siguientes fuentes fueron leídas directamente desde los bytes de archivos adjuntos de esta conversación; las rutas adjuntas son copias de fuentes repo-relative, **no** prueban el estado Git actual del repositorio real.

| Fuente (repo-relative) | SHA-256 físico verificado | Bytes | LF | CRLF | bare CR | trailing whitespace | final LF |
|---|---|---:|---:|---:|---:|---:|---:|
| `supabase/tests/database/corr_023_local_db_regression.ps1` | `5a03e76ad09abb337bbcf0018e996cfb1012c67c427e872fcbcd1140c2353f11` | 24453 | 572 | 0 | 0 | 0 | YES |
| `docs/tasks/CORR-023-task-013-local-db-regression-runner-supabase-auth-admin.md` | `2f98a2b8be4e1ff33cecb1b57c4b794041bc6531faf15a207a9c1801801d1fe6` | 53698 | 2143 | 0 | 0 | 0 | YES |
| `supabase/tests/database/task_013_verification_challenge_foundation.test.sql` | `00c804ce1117ae086fca331707fdc2bc055857e0982584e573fb666251c3eca4` | 35144 | 923 | 0 | 0 | 0 | YES |
| `docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md` | `d0106d83633b616099f6772702ee80f4700115186e938047e19a81edba865c43` | 113901 | 3725 | 0 | 0 | 0 | YES |

**Provenance boundary:** no se ha accedido ni ejecutado el repositorio real; la implementación futura deberá verificar contra su working tree real (sucio por diseño) y preservar sus cambios. Si difieren bytes o contrato, `BLOCKER → STOP → RETURN TO REVISOR CENTRAL`, sin adaptar unilateralmente esta specification.

## 4. Reproducción estática precisa del blocker

El runner actual inicia con `param()` sin parámetros. En su cuerpo principal (después del proof de target y ALT-001), invoca incondicionalmente: TASK-009 DB, TASK-010 DB, TASK-013 DB con `-UseAdminUrl`, TASK-014 DB, TASK-015 DB, TASK-015 concurrency, scripts npm disponibles (`test`, `lint`, `typecheck`, `build`, `verify`) y `git diff --check`, además de controles posteriores de identidad de fuentes, role topology y residue.

En particular, la llamada existente a TASK-013 usa el método `Invoke-Corr023DbSuite`, `-RelativePath $task013Path`, `-ExpectedTests 72` y `-UseAdminUrl`. Este mecanismo utiliza `npx supabase test db --db-url $script:AdminDbUrl <path>`; no equivale a ejecutar `supabase test db --local` ni debe sustituirse por esa variante.

El Gate de §36.28 autorizaba sólo TASK-013. Lanzar el script completo violaría la autorización, y el script actual carece de selección. La ejecución previa se detuvo antes de abrir DB; no se demuestra defecto de TASK-013, TASK-021 ni RLS.

Resultado histórico ya revisado, preservado sin reinterpretación:

```text
TASK-021 §36.28 CORR-023 CANONICAL TASK-013 DB REGRESSION RERUN REVIEW =
APPROVED AS BLOCKED
blocker validity = CONFIRMED
blocker class = TEST HARNESS / AUTHORIZED-SCOPE EXECUTION INCOMPATIBILITY
TASK-013 functional regression = NOT PROVEN
TASK-021 functional defect = NOT PROVEN
§36.28 = PENDING
rerun budget consumed = 0 / 1
rerun budget remaining = 1
```

## 5. Análisis de alternativas

**A — Selector explícito opt-in en runner canónico (SELECCIONADA).** Aprovecha la conexión ALT-001, comprobación local, prueba de roles, sanitización y el método invocador de TASK-013 ya existentes. Sólo modifica el control de selección y la ruta de postchecks compatible con ejecución targeted. Mantiene exactamente igual la ruta default integral. No requiere agregar segundo runner, conexión o estrategia de credenciales.

**B — Boundary auxiliar test-only (NO SELECCIONADA).** Un wrapper autónomo podría invocar el runner, pero el runner no expone un selector: o ejecutaría toda la batería (scope inválido), o duplicaría logic de conexión y preflight (más superficie privilegiada y riesgo de drift). Un wrapper de un selector interno igualmente necesitaría A; por tanto, no es menor en esta baseline.

**C — Ejecución directa manual `supabase test db` (NO SELECCIONADA).** `--local` ya mostró contexto de roles erróneo. Una URL manual ad hoc perdería el proof ALT-001, el target binding, la sanitización y los controles del runner; el path canónico no queda demostrado de modo equivalente. No cumple la compatibilidad exigida.

**D — Reorganización mayor/refactor de harness (NO SELECCIONADA).** Añade superficie de regresión sin necesidad demostrada.

La selección A es una **decisión local de implementación de harness**, no decisión arquitectónica/productiva transversal: ADR nuevo requerido = NO. Si la implementación encuentra incompatibilidad no detectada, detenerse; no introducir una alternativa nueva sin revisión.

## 6. Contrato de selección propuesto (no código ejecutable)

1. Añadir **un parámetro opcional único y explícito** al `param()` del runner, denominado conceptualmente `Suite`, con dos valores estrictamente permitidos: `Full` y `Task013Only`. Nombres físicos de la propuesta: `-Suite Full` y `-Suite Task013Only`.
2. Invocación **sin parámetro** conserva EXACTAMENTE la ejecución completa vigente, orden, comprobaciones, outputs y gates de CORR-023; el valor por defecto es `Full`.
3. `Task013Only` se selecciona **únicamente** mediante el parámetro explícito; no se infiere del entorno, path, CI, nombre de proyecto o estado del rerun.
4. Cualquier selector desconocido o ambiguo debe rechazarse antes de ejecutar subprocess/abrir DB. No fallback implícito a `Full` ni a `Task013Only`.
5. La selección debe fijarse antes de toda prueba y permanecer inmutable durante la invocación; no elegir suites por strings provenientes de red, respuestas DB o environment.
6. `Task013Only` **conserva** la resolución de ruta canónica del runner, validación de source A SHA, `plan(72)` y etiquetas `T013-DB-001..072`, verificación de `config.toml`/Supabase Local/Docker/localhost, CLI version pin, construcción process-only de `AdminDbUrl`, role proof ALT-001, capture de role topology baseline, límites temporales y sanitización de output.
7. En modo `Task013Only` el **único archivo SQL pgTAP ejecutado** es `supabase/tests/database/task_013_verification_challenge_foundation.test.sql` mediante la llamada preexistente con `-UseAdminUrl -ExpectedTests 72`. No se ejecutan TASK-009, TASK-010, TASK-014, TASK-015 DB, TASK-015 concurrency, npm scripts ni `git diff --check`.
8. Los preflights y validaciones estáticas no deben invocar otras suites; la validación de existencia de rutas de suites no seleccionadas y sus contratos ajenos no debe bloquear arbitrariamente `Task013Only`. Se mantiene `Full` intacto. El source B (migration TASK-013) y su SHA siguen siendo una comprobación read-only obligatoria, sin ejecutar migraciones.
9. El modo targeted retiene los postchecks read-only pertinentes: SHA A/B sin drift, role topology antes/después sin mutaciones persistentes y `TASK-013 fixture residue = 0`. El proof de target debe preceder a toda conexión privilegiada. Los outputs de estos checks no podrán declarar `full local DB regression = PASS`.
10. La salida de `Task013Only` debe distinguir inequívocamente **`CORR-045 TASK-013 TARGETED RUNNER RESULT = PASS`** de un PASS integral; marcar `TASK-013 DB PASS` sólo tras TAP PASS y todos los postchecks relevantes. El output debe indicar selector y scope, pero nunca imprimir URLs, passwords, keys ni secretos.
11. Una falla en proof, suite, TAP, postcheck, timeout, cancellation o cleanup implica **BLOCKER** y exit no-cero, sin PASS parcial final ni reintento automático. Nunca habilitar ejecución de suites omitidas como fallback.
12. La ruta integral original mantiene su etiqueta `CORR-023 RUNNER RESULT = PASS` exclusivamente cuando toda su regresión pasa. Un PASS targeted no certifica CORR-023 full regression, TASK-021 Work Item I ni §36.28 por sí mismo; sólo proporciona evidencia para revisión formal posterior.
13. No añadir runner autónomo ni flags para otras suites. No crear opción `AllExcept`, selectors arbitrarios, multipath ni ejecución concurrente.

**Detalle de implementación a verificar:** un error de vinculación de parámetros (`ParameterBindingException`) puede ocurrir antes de entrar en el cuerpo del script y en su bloque `try/finally`; por ello, no debe exigirse que el `finally` interno se ejecute ante errores previos a esa entrada. Un selector inválido debe rechazarse antes de abrir DB, cargar secretos o ejecutar subprocess, sin fallback a otra suite. Una vez dentro del `try`, las rutas normales y los errores recuperables, incluidos los fallos pre-DB ocurridos dentro de ese bloque, deben conservar el mecanismo de limpieza existente. No debe garantizarse la ejecución del `finally` ante una terminación abrupta del proceso. Ningún secreto puede persistirse en User/Machine scope, repositorio, archivos temporales ni logs; no debe modificarse la semántica de los procesos hijos de las otras suites.

## 7. ALT-001, roles y secretos: invariantes

```text
session_user/login = supabase_admin
connection-time/default role = postgres
initial current_user = postgres
options = -c role=postgres
legitimate SET LOCAL ROLE supabase_auth_admin in canonical TASK-013 = preserved
Supabase Local only
secrets = PROCESS MEMORY ONLY / NO EXPOSURE
```

La conexión del runner debe conservar el proof de `session_user/current_user`, transición y restauración por `SET ROLE` y verificación de target inequívoco. El SQL canónico usa el rol `supabase_auth_admin` en sus aserciones finales; la suite continúa idéntica. No añadir `GRANT`, `REVOKE`, role memberships ni privilegios productivos. El hook continúa `SECURITY INVOKER`.

Todas las URI con credenciales y passwords se manejan mediante memoria de proceso y se redactan de errores/logs. No persistir en scripts, archivos temporales, command transcripts, Git, User/Machine scope, logs ni mensajes de revisión. Conservación de los timeouts existentes: proof 30 s, DB suite 300 s, full 1800 s. Targeted no introduce espera no acotada ni retry automático.

## 8. Seguridad, RLS, multitenancy y alcance

- **Product / domain / UI / offline behavior:** NO CHANGE / NOT APPLICABLE (infraestructura de test local exclusivamente).
- **RLS:** NO CHANGE; no modificar ni relajar policies.
- **Multitenancy:** NO CHANGE; no habilitar acceso cross-tenant ni clients de aplicación privilegiados.
- **Database schema / migrations / grants / role membership / Auth / hook:** NO CHANGE.
- **Supabase Hosted Development / Staging / Production:** NO EXECUTION / NO MUTATION.
- **Supabase Local:** futuro target exclusivo al ejecutar tests mediante otra autorización; esta specification no autoriza ejecutarlo.
- **Repository mutation ahora:** NONE. Un eventual cambio implementador se restringe al archivo del runner canónico, salvo que revisión posterior autorice explícitamente otra fuente por blocker demostrado.
- **Dirty worktree actual:** obligatorio preservarlo. No reset, stash, checkout, restore, clean, pull, merge ni rebase, ni staging/commit/push por inferencia.
- **Service-role:** nunca usar como client de aplicación ni bypass de autorización; la prueba preexistente de transiciones de rol queda confinada al test harness.

## 9. Preflight de una futura implementación separadamente autorizada

Codex deberá inspeccionar los cuatro archivos canónicos y el working tree **real**, comparar SHA de las fuentes A/B y runner, identificar el diff existente del runner y verificar no colisiones con otros cambios en curso. Deberá leer las decisiones/correcciones posteriores aplicables; el snapshot de estos adjuntos no sustituye ese preflight. Si cualquiera de las precondiciones deja de cumplirse: BLOCKER, sin escribir ni ejecutar. La autorización futura deberá especificar paths modificables y si se permite prueba local de diseño, por separado del rerun §36.28.

## 10. Criterios de aceptación (para revisión posterior, no ejecutados)

- **AC-045-001:** Sólo el runner CORR-023 cambia en la futura implementación autorizada; ninguna migration/SQL/APP cambia.
- **AC-045-002:** Sin selector el runner sigue ejecutando exactamente el pipeline completo y conservando su resultado integral.
- **AC-045-003:** `-Suite Full` equivale al default sin side effects nuevos.
- **AC-045-004:** `-Suite Task013Only` omite todas las otras suites, concurrencia, npm y git diff; ejecuta exactamente una suite pgTAP, TASK-013.
- **AC-045-005:** Selector inválido falla cerrado **antes de abrir DB**, sin invocar el pipeline integral.
- **AC-045-006:** El targeted conserva validaciones de destino Local loopback/puerto/config/status/Docker y versión CLI.
- **AC-045-007:** El targeted conserva `supabase_admin` + `options=-c role=postgres`, proof de `session_user` y `current_user` y transiciones de role autorizadas.
- **AC-045-008:** TASK-013 SQL y migration mantienen SHA exactos y no se modifica `SECURITY INVOKER`, RLS, privileges ni roles.
- **AC-045-009:** pgTAP targeted requiere `plan=72`, `Tests=72`, `Files=1`, `Result: PASS`, fallidas=0, bad plan=NO.
- **AC-045-010:** `T013-DB-066..072` se ejecutan bajo semántica SQL original; no falsificar el PASS con mensajes estáticos si falta prueba TAP válida.
- **AC-045-011:** Role topology before/after coincide; residue fixtures TASK-013 cero; sin mutación persistente de roles.
- **AC-045-012:** Contraseñas/URLs/keys no aparecen en stdout, stderr, logs ni errores; limpieza de referencias sensibles preservada.
- **AC-045-013:** Timeouts y fallas dan BLOCKER, sin retry automático ni fallback a otra suite.
- **AC-045-014:** El output diferencia explícitamente `CORR-045 TASK-013 TARGETED RUNNER RESULT` de `CORR-023 RUNNER RESULT` full.
- **AC-045-015:** Ningún targeted PASS actualiza automáticamente §36.28, su rerun budget, F-021-I-001 o TASK-021 Work Item I.
- **AC-045-016:** No hay cambios ni llamadas Hosted/Staging/Production.
- **AC-045-017:** Validaciones estáticas ajenas a TASK-013 no fuerzan suites no autorizadas en targeted; Full conserva sus controles.
- **AC-045-018:** Worktree sucio existente preservado, sin staging/commit/push implícito.
- **AC-045-019:** Cualquier mismatch de fuentes canónicas produce BLOCKER antes de cambios, sin adaptación por inferencia.
- **AC-045-020:** El targeted FAIL/CANCEL conserva postmortem sanitizado, sin declarar PASS integral o consumo ficticio de rerun.

## 11. Plan de pruebas para Codex — sólo tras futura autorización

**Prueba de selección sin DB:** probar binding/default/selector inválido con harness de subprocess controlado y no privilegiado, sin conectar; `Task013Only` debe demostrar lista de subprocess esperada de una sola suite DB más proof read-only. Si necesita código auxiliar de prueba o segundo path, primero retornar al Revisor Central y obtener nueva autorización: no expandir el diff.

**Prueba de aislamiento de ramas:** revisión estática y/o mocks de `Invoke-Corr023DbSuite`, subprocess npm/concurrency/git y postchecks, confirmando que el modo targeted nunca alcanza bloques del pipeline full ni reporta su PASS.

**Prueba Local DB funcional:** reservada para autorización separada; comprobar CLI 2.114.0, proof ALT-001, 72 assertions, labels 066..072, SHA A/B, rol before/after, residue cero y secretos ausentes en output. No ejecutar durante especificación; tampoco consumir §36.28 rerun budget sin nueva autorización humana específica.

**Regresión Full:** autorización separada si se requiere ejecución real; comparar comportamiento default vs baseline. No arrastrar automáticamente todas las suites a la autorización targeted.

**Pruebas negativas:** selector desconocido, path distinto, CLI version drift, target no-loopback, binding Docker ambiguo, credenciales ausentes, fuente SHA drift, no `SET ROLE`, TAP failure/bad plan, timeout/interrupción y cleanup fallido: todos deben dar BLOCKER y nunca fallback o credenciales expuestas.

La aceptación requiere evidencia causal verificable; no bastan prints de PASS simulados.

## 12. Definition of Done (future, sin marcar COMPLETE)

- **DoD-045-001:** SPEC REVIEW aprobado y aprobación humana de specification separada.
- **DoD-045-002:** Artefacto aprobado/revisado/canonicalizado e incorporado mediante Gates independientes.
- **DoD-045-003:** Ejecución de implementación expresamente autorizada con preflight Git y source SHA frescos.
- **DoD-045-004:** Diff mínimo en runner canónico, sin archivos adicionales, producto, SQL, migration ni policy.
- **DoD-045-005:** AC-045-001..020 verificados con evidencia separada y reviewed.
- **DoD-045-006:** Sin cambios de roles/grants/RLS/hooks, ni Hosted/Staging/Production.
- **DoD-045-007:** Full default preservado y targeted scope verificado.
- **DoD-045-008:** Preservación de secretos, cleaning/timeout/fail-closed probada.
- **DoD-045-009:** Revisión de implementación aprobada por Revisor Central.
- **DoD-045-010:** Cualquier ejecución §36.28 se autoriza posteriormente como Gate independiente, con control explícito del budget 0/1 antes de iniciar.
- **DoD-045-011:** Cierre humano y cualquier incorporación Git posteriores no se infieren de un test PASS.

**Estado DoD:** todos pendientes; esta specification no constituye cumplimiento de DoD.

## 13. Estado autoritativo posterior a esta generación

```text
CORR-045 SPECIFICATION GENERATION AUTHORIZATION = AUTHORIZED
CORR-045 SPECIFICATION GENERATION = PASS (artifact created in conversation; no repo mutation)
CORR-045 SPEC REVIEW = PENDING
CORR-045 HUMAN SPEC APPROVAL = NOT GRANTED
CORR-045 CANONICALIZATION / IMPLEMENTATION / CODEX = NOT AUTHORIZED
TASK-021 §36 total = 31
TASK-021 §36 PASS = 18
TASK-021 §36 PENDING = 13
TASK-021 §36 FAIL = 0
§36.28 = PENDING
§36.28 rerun budget consumed = 0 / 1
§36.28 rerun budget remaining = 1
F-021-I-001 = OPEN
TASK-021 Work Item I = NOT COMPLETE
TASK-021 = NOT DONE / NOT CLOSED
Phase 2 = IN PROGRESS / NOT CLOSED
Phase 2 Exit Gate = NOT DEFINED
Phase 3 = NOT STARTED
TASK-022 = NOT DETERMINED / NOT GENERATED / NOT STARTED
```

## 14. Gate posterior separado

**NEXT GATE:** `CORR-045 SPEC REVIEW` (Revisor Central, mismo chat). Se revisará exclusivamente la specification documental física adjunta, los cuatro SHA de fuente, la minimalidad y seguridad de selector, invariantes ALT-001, testability y compatibilidad con CORR-023 / TASK-021. No constituye aprobación humana de especificación, implementación, test local ni rerun.

`DESTINO = CHATGPT — MISMO CHAT REVISOR CENTRAL`.

## 15. Registro posterior de aprobación documental formal — 2026-10-11

Este registro se añade **después** de la generación y revisión de las secciones 1–14. Esas secciones permanecen **íntegras y byte a byte idénticas** a la specification corregida que fue revisada. Sus referencias a `SPEC REVIEW = PENDING` describen el **estado histórico al generarse la specification**; no invalidan los Gates posteriores registrados aquí. Para el estado documental actual de aprobación de la specification prevalecen exclusivamente los resultados de Gate enumerados en este registro. No modifica requisitos, contratos, criterios de aceptación ni Definition of Done.

### 15.1. Identidad física exacta de la specification humanamente aprobada

- **Archivo fuente corregido:** `CORR-045-corr-023-targeted-task-013-regression-selection-compatibility-corrected.md`.
- **SHA-256 fuente:** `e14e1689e63cd3401d80994054ca7b57773d3814bd6b1a04e4aed884cc2e9d4c`.
- **Bytes fuente:** 20155.
- **LF:** 202; **CRLF:** 0; **bare CR:** 0; **líneas con trailing whitespace:** 0; **final newline:** YES.
- **Integridad del contenido técnico:** la fuente corregida constituye el prefijo exacto, conservado byte a byte, del presente artefacto; solamente se añade este registro final de aprobación.

### 15.2. Gates aprobados y alcance preciso

```text
CORR-045 CORRECTED SPEC RE-REVIEW = APPROVED
CORR-045 HUMAN SPEC APPROVAL = APPROVED
F-045-SPEC-001 = RESOLVED
CORR-045 APPROVED ARTIFACT GENERATION AUTHORIZATION = AUTHORIZED
CORR-045 APPROVED ARTIFACT REVIEW = PENDING
CORR-045 CANONICALIZATION = NOT AUTHORIZED
CORR-045 REPOSITORY INCORPORATION = NOT AUTHORIZED
CORR-045 IMPLEMENTATION = NOT AUTHORIZED
CORR-045 CODEX = NOT AUTHORIZED
```

La aprobación humana alcanza **únicamente a la specification documental corregida con la identidad física indicada**; no aprueba resultados de pruebas ni habilita ejecutar el runner. La revisión de este nuevo artefacto, su eventual canonicalización e incorporación al repositorio requieren **Gates posteriores independientes**. No se infiere implementación ni autorización para Supabase Local, Hosted Development, Staging, Production o Git.

### 15.3. Estado de TASK-021 y presupuesto de rerun preservados

```text
TASK-021 §36 total = 31
TASK-021 §36 PASS = 18
TASK-021 §36 PENDING = 13
TASK-021 §36 FAIL = 0
§36.28 = PENDING
§36.28 rerun budget consumed = 0 / 1
§36.28 rerun budget remaining = 1
automatic retry = 0
F-021-I-001 = OPEN
TASK-021 Work Item I = NOT COMPLETE
TASK-021 = NOT DONE / NOT CLOSED
Phase 2 = IN PROGRESS / NOT CLOSED
Phase 2 Exit Gate = NOT DEFINED
Phase 3 = NOT STARTED
TASK-022 = NOT DETERMINED / NOT GENERATED / NOT STARTED
```

Ningún test ha sido ejecutado por esta aprobación documental. No hay modificación de producto, dominio, Auth, SQL, schema, migration, roles, grants, hook, RLS, aislamiento multitenant ni semántica ALT-001. No hay consumo del rerun autorizado para §36.28, cierre de TASK-021 o avance de fase. `authorization != execution != review`.
