# CORR-038 — CORR-032 Canonical ALT-001 Precondition-Gate Cancellation Harness Compatibility

## 1. Identificación

**ID:** `CORR-038`

**Título:** `CORR-038 — CORR-032 Canonical ALT-001 Precondition-Gate Cancellation Harness Compatibility`

**Tipo:** `TEST / REGRESSION HARNESS CORRECTION SPECIFICATION`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Estado de esta especificación:** `APPROVED SPECIFICATION / APPROVED ARTIFACT REVIEW APPROVED / CANONICAL ARTIFACT GENERATED / PENDING CANONICALIZATION REVIEW`

**Archivo de entrega:** `CORR-038-corr-032-canonical-alt-001-precondition-gate-cancellation-harness-compatibility-canonical.md`

**Repo-relative canonical target:** `docs/tasks/CORR-038-corr-032-canonical-alt-001-precondition-gate-cancellation-harness-compatibility.md`

**Implementación autorizada:** `NO`

**Repository incorporation authorized:** `NO`

**Canonicalización:** `GENERATED / PENDING CANONICALIZATION REVIEW`

**Staging / commit / push:** `NO / NO / NO`

**Supabase Cloud:** `NOT AUTHORIZED`

**TASK-019 Work Item F resume:** `NOT AUTHORIZED`

Esta especificación define exclusivamente la corrección mínima futura de un defecto del control path del harness de concurrencia CORR-032. No implementa la corrección, no modifica el harness, no ejecuta CORR-032, no altera roles/grants/memberships, no modifica schema, migrations, RLS, configuración Supabase ni semántica de producto.

---

## 2. Estado autoritativo consumido

Se consume exactamente:

```text
F-019-F-002 =
RESOLVED /
ROOT CAUSE ESTABLISHED AS CORR-032 HARNESS
PRECONDITION-GATE CANCELLATION AUTHORITY INCOMPATIBILITY
UNDER CANONICAL ALT-001
```

```text
F-019-F-009 =
RESOLVED
```

```text
F-019-F-010 =
OPEN /
CORR-038 CANONICAL ARTIFACT GENERATED /
PENDING CANONICALIZATION REVIEW
```

Se preserva:

```text
F-019-F-001 = RESOLVED
F-019-F-003 = RESOLVED
F-019-F-004 = RESOLVED
F-019-F-005 = RESOLVED
F-019-F-006 = RESOLVED
F-019-F-007 = RESOLVED
F-019-F-008 = RESOLVED

F-037-IMPL-001 = RESOLVED
CORR-037 = REMAINS REVIEW APPROVED
```

TASK-019 permanece:

```text
TASK-019 WORK ITEM F =
STOP — REGRESSION DETECTED / NOT COMPLETE

TASK-019 WORK ITEM F REVIEW =
BLOCKER CONFIRMED

TASK-019 Work Item F resume =
NOT AUTHORIZED
```

La representación documental canónica no cambia ninguno de esos estados salvo que `F-019-F-010` pasa a “CORR-038 CANONICAL ARTIFACT GENERATED / PENDING CANONICALIZATION REVIEW” como consecuencia documental de este artefacto. Ese cambio no equivale a resolver el finding, incorporar el artefacto al repositorio ni a autorizar implementación.

---

## 3. Objetivo único

CORR-038 debe especificar la corrección mínima futura necesaria para que:

```text
supabase/tests/database/
corr_032_task_013_auth_bridge_prebound_hook_concurrency.test.ps1
```

pueda ejecutarse correctamente bajo el connection model canónico ALT-001 de CORR-023 y conservar íntegramente el objetivo de concurrencia de CORR-032.

La futura corrección debe lograr simultáneamente:

1. conservar el canonical ALT-001: `session_user = supabase_admin`, baseline `current_user = postgres`;
2. conservar `C032-CON-001..010` y alcanzar `C032-CON-008`;
3. liberar de forma determinista el artificial precondition gate;
4. no modificar product roles, grants, memberships, RLS ni tenant authority;
5. no cambiar Custom Access Token Hook semantics;
6. no debilitar el locking/concurrency model canónico de CORR-032;
7. mantener toda espera bounded;
8. mantener cleanup obligatorio y verificable;
9. preservar evidencia causal segura ante futuros errores `psql` del control path;
10. mantener TASK-019 Work Item F bloqueado hasta review y autorización separada.

---

## 4. Fuentes obligatorias e identidad física

Las tres fuentes físicas mínimas exigidas fueron recuperadas desde paquetes de evidencia del Project y verificadas desde sus bytes reales.

### 4.1 Harness CORR-032

```text
repo-relative path =
supabase/tests/database/corr_032_task_013_auth_bridge_prebound_hook_concurrency.test.ps1

SHA-256 =
e83a0950c4c9cf5e8a92ab97ec3a88f86133e9d9ae7795d93cc9fa4991712e6b

bytes =
16326

LF =
419

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES
```

Resultado:

```text
SOURCE 1 IDENTITY = PASS
```

### 4.2 Canonical CORR-032

```text
repo-relative path =
docs/tasks/CORR-032-task-013-auth-bridge-prebound-hook-correction.md

SHA-256 =
b70dab1455d5dc6584dbd9cad6e12dea0bef8cab1a370ff7b7233d180674dd2e

bytes =
59273

LF =
1863

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES
```

Resultado:

```text
SOURCE 2 IDENTITY = PASS
```

### 4.3 Canonical CORR-023

```text
repo-relative path =
docs/tasks/CORR-023-task-013-local-db-regression-runner-supabase-auth-admin.md

SHA-256 =
2f98a2b8be4e1ff33cecb1b57c4b794041bc6531faf15a207a9c1801801d1fe6

bytes =
53698

LF =
2143

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES
```

Resultado:

```text
SOURCE 3 IDENTITY = PASS
```

### 4.4 Evidence chain aprobada

Se consume como evidencia autoritativa ya revisada:

```text
canonical ALT-001 harness rerun
+
precondition-gate cancellation diagnostic
+
diagnostic review
+
CORR-038 specification generation authorization
```

La cadena aprobada establece la identidad efectiva de target y canceller y el error PostgreSQL `42501` detallado en §6.

### 4.5 Resultado del source Gate

```text
required physical sources available = YES
required SHA-256 matches = YES
additional source required to specify correction = NO
new technical contradiction = NO
```

Por tanto:

```text
CORR-038 SOURCE GATE = PASS
```

---

## 5. Canonical boundary

La inspección física del canonical CORR-032 confirma que su contrato de producto y seguridad define:

- locking sobre el estado mutable relevante;
- same-grant concurrency con como máximo un consume exitoso;
- revalidación de precondición unbound bajo lock;
- `SECURITY INVOKER` para el Custom Access Token Hook;
- ausencia de tenant privileges para `supabase_auth_admin`;
- ausencia de RLS/grant widening;
- fail-closed ante drift de privilegios o runtime inesperado;
- cleanup obligatorio de fixtures.

La fuente canónica física no contiene ni convierte en requisito canónico:

```text
C032-CON-* implementation IDs
corr032_precondition_gate
advisory gate implementation
pg_cancel_backend
backend PID discovery mechanism
cancellation connection/session identity
application_name values del harness
```

Por tanto:

```text
product canonical semantics =
UNCHANGED

CORR-032 canonical semantic update =
NOT REQUIRED
```

CORR-038 sólo puede cambiar cómo el harness artificial libera su precondition gate y cómo preserva diagnóstico/cleanup alrededor de ese control path.

---

## 6. Root cause autoritativa

La cadena diagnóstica aprobada probó:

```text
target session/login role =
supabase_admin

target role rolsuper =
true

canceller session_user =
supabase_admin

canceller current_user =
postgres

canceller current role rolsuper =
false
```

También:

```text
postgres member of pg_signal_backend =
YES

supabase_admin member of pg_signal_backend =
YES
```

La llamada:

```sql
select pg_cancel_backend(pid)::text
from pg_stat_activity
where application_name = 'corr032_alt001_cancel_diag_target';
```

produjo:

```text
numeric psql exit code =
1

SQLSTATE =
42501

severity =
ERROR

message =
permission denied to cancel query

detail =
Only roles with the SUPERUSER attribute may cancel queries
of roles with the SUPERUSER attribute.
```

Resultado causal:

```text
root cause =
CONFIRMED HARNESS CONTROL-PATH AUTHORITY INCOMPATIBILITY
```

La causa no es una carencia de `pg_signal_backend`: la evidencia ya prueba membership tanto de `postgres` como de `supabase_admin`. El problema específico es que el target está asociado al login/session role superuser `supabase_admin`, mientras la conexión de cancelación opera con effective/current role `postgres`, que no es superuser.

---

## 7. Relación causal con el full harness

El canonical ALT-001 rerun probó antes del fallo:

```text
connection session_user =
supabase_admin

connection initial current_user =
postgres

SET LOCAL ROLE supabase_auth_admin =
PASS
```

Y produjo:

```text
C032-CON-001 = PASS
C032-CON-002 = PASS
C032-CON-003 = PASS
C032-CON-004 = PASS
C032-CON-005 = PASS
C032-CON-006 = PASS
C032-CON-007 = PASS
```

El harness físico ejecuta inmediatamente después de `C032-CON-007`:

```sql
select pg_cancel_backend(pid)::text
from pg_stat_activity
where application_name = 'corr032_precondition_gate';
```

mediante `Invoke-Corr032Psql`.

Bajo ALT-001 esa invocación abre otra conexión con:

```text
session_user = supabase_admin
initial/current_user = postgres
```

La evidencia aislada `42501` explica materialmente por qué esa llamada devuelve exit no cero y por qué `Invoke-Corr032Psql` interrumpe la ejecución con:

```text
Bounded CORR-032 psql command failed.
```

antes de evaluar:

```text
C032-CON-008
```

La relación causal queda establecida:

```text
ALT-001 effective role on canceller = postgres
+
target login role = supabase_admin / superuser
+
pg_cancel_backend superuser-target rule
→ SQLSTATE 42501
→ Invoke-Corr032Psql nonzero path
→ generic throw
→ C032-CON-008 not reached
```

---

## 8. Classification

Se fija:

```text
problem class =
CORR-032 TEST / REGRESSION HARNESS CONTROL-PATH DEFECT
```

No existe evidencia que permita clasificarlo como:

```text
product semantic defect
TASK-013 semantic defect
RLS defect
multitenancy defect
Supabase runtime defect
canonical ALT-001 defect
Custom Access Token Hook semantic defect
```

La futura implementación debe detenerse si aparece evidencia que contradiga esta clasificación.

---

## 9. Análisis físico del harness

### 9.1 Connection model heredado

El archivo CORR-032 no recibe connection parameters, DB URL ni credenciales. Invoca `psql` por PATH y depende de libpq/environment heredado.

Bajo el rerun canonical ALT-001, el proceso del harness recibió un environment controlado equivalente a:

```text
PGUSER = supabase_admin
PGOPTIONS = -c role=postgres
```

más host/port/database/password locales controlados.

La ejecución que alcanzó `C032-CON-007` prueba físicamente que los child jobs recibieron suficiente contexto para:

- localizar `psql`;
- conectarse al mismo target local;
- operar con `session_user = supabase_admin`;
- iniciar con `current_user = postgres`;
- ejecutar `SET LOCAL ROLE supabase_auth_admin` donde el SQL del Hook lo exige.

CORR-038 no necesita cambiar ese inheritance model.

### 9.2 `Invoke-Corr032Psql`

Ubicación física: líneas 42–51 del harness verificado.

Comportamiento actual:

```text
connection authority = inherited ALT-001
session_user = supabase_admin
initial current_user = postgres
statement_timeout = 30s
lock_timeout = 20s
stderr = merged into captured output
numeric exit code = available only in $LASTEXITCODE
nonzero behavior = generic throw
```

Side effects dependen exclusivamente del SQL caller.

Defecto diagnóstico probado:

```text
captured stdout/stderr + numeric exit code
→ discarded on nonzero
→ only generic message survives
```

Esto es insuficiente para futuros control-path failures.

### 9.3 `Start-Corr032ControlJob`

Ubicación física: líneas 74–89.

Abre un PowerShell background job y ejecuta `psql` con el environment heredado.

Comportamiento actual:

```text
connection authority = inherited ALT-001
baseline current_user = postgres
nonzero psql = throws generic control-worker error
job retained in corr032Jobs
```

El helper no crea una identidad DB alternativa ni una conexión privilegiada separada.

### 9.4 Gate session creation

Ubicación física: líneas 304–322.

SQL actual:

```text
set application_name = corr032_precondition_gate
pg_advisory_lock(320032)
pg_sleep(25)
pg_advisory_unlock(320032)
```

Propósito:

- crear un gate artificial test-only;
- mantener un advisory lock durante una ventana bounded;
- no tocar business data.

Authority bajo ALT-001:

```text
session_user = supabase_admin
current_user = postgres
```

No existe `SET ROLE` dentro del gate SQL.

### 9.5 Blocker session creation

Ubicación física: líneas 310–332.

El blocker:

1. comienza transacción;
2. ejecuta `SET LOCAL ROLE postgres`;
3. bloquea la bridge row `FOR UPDATE`;
4. espera el advisory gate lock;
5. al liberarse el gate, cambia la bridge precondition hacia el binding externo esperado;
6. commit.

Authority:

```text
session_user = supabase_admin
current_user during blocker transaction = postgres
```

El blocker forma parte de la choreography destinada a demostrar pérdida de precondición, no de la autoridad de cancelación.

### 9.6 Hook session creation

`New-Corr032HookSql` y `Start-Corr032HookJob` ejecutan:

```sql
begin;
set local role supabase_auth_admin;
...
perform public.task_013_custom_access_token_hook(...);
...
commit;
```

Authority:

```text
session_user = supabase_admin
current_user inside Hook transaction = supabase_auth_admin
```

La cadena canónica ALT-001 ya probó que esta transición funciona.

CORR-038 no cambia ese SQL ni el Hook.

### 9.7 Readiness polling

`Wait-Corr032SqlValue` usa `Invoke-Corr032Psql` y un deadline absoluto de 10 segundos con polling cada 100 ms.

Readiness probada:

- gate activo en `PgSleep`;
- blocker esperando `Lock` y bloqueado por gate;
- hook esperando `Lock` detrás del blocker.

Failure actual:

```text
expected value not reached before deadline
→ explicit timeout throw
```

CORR-038 preserva esta lógica.

### 9.8 `C032-CON-007` proof

El harness abre una transacción bajo `SET LOCAL ROLE postgres` e intenta `FOR UPDATE NOWAIT` sobre el SessionGrant.

Expected:

```text
lock_not_available
→ LOCKED
→ C032-CON-007 = PASS
```

El canonical rerun produjo `PASS`, demostrando que la choreography de locks previa a la cancelación estaba establecida correctamente.

### 9.9 `pg_cancel_backend` invocation

Ubicación física: líneas 382–386.

Comportamiento actual:

```text
caller helper = Invoke-Corr032Psql
caller session_user = supabase_admin
caller current_user = postgres
target identified by application_name only
expected result = true
```

Esta llamada es el único punto probado que requiere una autoridad distinta de la efectiva `postgres` para cancelar el target superuser.

### 9.10 `C032-CON-008`

Ubicación física: línea 387.

Contrato actual del harness:

```text
$gateCancelled -eq "true"
```

CORR-038 debe preservar ese contrato. No se autoriza debilitarlo a “target eventually disappeared”, “timeout elapsed” u otra condición menos fuerte.

### 9.11 `Remove-Corr032CancelledGateJob`

Ubicación física: líneas 108–124 y llamada en línea 388.

Después de una cancelación exitosa, el `psql` del gate recibe la interrupción mientras `pg_sleep` está activo. El control worker lanza y el PowerShell job debe terminar en estado:

```text
Failed
```

`Remove-Corr032CancelledGateJob` espera bounded hasta 35 segundos, consume el job y exige exactamente ese estado.

CORR-038 debe conservar esa semántica de cleanup del gate.

### 9.12 `C032-CON-009`

Después de liberar gate y completar blocker/hook, el harness exige:

```text
preconditionOutcome = DENY
```

Esto prueba que el Hook no autoriza después de perderse la precondición unbound.

CORR-038 no cambia esa assertion.

### 9.13 `C032-CON-010`

El estado final debe continuar demostrando:

```text
external binding preserved
+
SessionGrant unconsumed and not revoked
```

Expected physical state:

```text
preconditionState = 1|1
```

CORR-038 no cambia esa assertion.

### 9.14 Cleanup/finally actual

El `finally` actual:

1. detiene jobs todavía `Running`/`NotStarted`;
2. elimina todos los jobs registrados;
3. ejecuta `cleanupSql`;
4. restaura o elimina `PGCONNECT_TIMEOUT` según su estado previo.

`cleanupSql` elimina fixtures `32900000-*` de:

- `auth_session_grants`;
- `auth_bridge_credentials`;
- `verification_challenges`;
- `auth.users`.

Observación de robustez dentro del mismo path:

```text
si Invoke-Corr032Psql(cleanupSql) falla,
la restauración posterior de PGCONNECT_TIMEOUT puede no ejecutarse
```

La futura corrección debe ordenar cleanup de modo que un cleanup DB fallido no impida restaurar estado de proceso y que el error de cleanup no borre el causal failure original.

### 9.15 Bounds actuales

La fuente física fija:

```text
PGCONNECT_TIMEOUT = 5 seconds
statement_timeout = 30 seconds
lock_timeout = 20 seconds
concurrent job timeout = 35 seconds
readiness timeout = 10 seconds
readiness poll interval = 100 milliseconds
gate sleep bound = 25 seconds
```

CORR-038 no necesita modificar ninguno de esos valores.

---

## 10. Alternatives analysis

Se evaluaron físicamente las categorías requeridas.

### 10.1 Alternativa A — cambiar sólo la authority del control-path cancellation

Concepto:

Mantener target, gate, blocker, hook, advisory lock y `pg_cancel_backend`, pero ejecutar exclusivamente la cancelación bajo una transición de role explícita, temporal y test-only hacia la authority ya existente del login ALT-001 `supabase_admin`.

Forma contractual seleccionada:

```text
same ALT-001 connection
session_user = supabase_admin
baseline current_user = postgres
→ bounded transaction
→ SET LOCAL ROLE supabase_admin
→ current_user = supabase_admin
→ one pg_cancel_backend call
→ transaction end
```

No crea ni modifica role membership.

Evaluación:

```text
minimality = HIGH
preserves target identity = YES
preserves gate mechanism = YES
preserves C032-CON-008 exact boolean contract = YES
persistent privilege mutation = NONE
new credential = NONE
new product authority = NONE
race surface = MINIMAL
wait behavior = UNCHANGED
cleanup behavior = COMPATIBLE
affected repository paths = ONE
```

### 10.2 Alternativa B — cambiar sólo target gate identity/authority

Categoría evaluada:

```text
make artificial gate target non-superuser
while leaving canceller current_user = postgres
```

Posibles mecanismos físicos implicarían cambiar session authorization del gate o abrir el gate con otra login identity.

Rechazo:

- cambia la identidad de la sesión target en vez del único caller incompatible;
- una login diferente exigiría otra credential o connection path;
- `SET SESSION AUTHORIZATION` añadiría una transición de identidad de mayor impacto y menos localizada;
- amplía la superficie del artificial gate sin necesidad;
- no mejora la equivalencia semántica frente a A;
- aumenta complejidad de análisis y cleanup.

Resultado:

```text
B = REJECTED
reason = LESS MINIMAL / GREATER IDENTITY SURFACE
```

### 10.3 Alternativa C — reemplazar el artificial gate-release mechanism

Categoría evaluada:

```text
remove pg_cancel_backend and release the gate by another mechanism
```

Posibilidades observables incluyen esperar el `pg_sleep(25)` natural, rediseñar choreography o utilizar una primitive más fuerte como `pg_terminate_backend`.

Rechazo:

- esperar el sleep natural aumenta tiempo y riesgo de timing/race;
- rediseñar choreography cambia más líneas y más estados que la corrección causal;
- `pg_terminate_backend` es una primitive más fuerte y no está justificada;
- cambiar el mecanismo obligaría a reinterpretar el significado práctico de `C032-CON-008` o a reescribir su assertion;
- ninguna de esas ampliaciones es necesaria una vez conocida la causa `42501`.

Resultado:

```text
C = REJECTED
reason = LESS MINIMAL / GREATER SEMANTIC AND CLEANUP RISK
```

### 10.4 Alternativa D — grants/role topology

Cualquier variante basada en:

```text
GRANT SUPERUSER
ALTER ROLE ... SUPERUSER
new pg_signal_backend grant
postgres → supabase_admin membership
new privileged role
```

queda fuera de consideración porque la evidencia demuestra que no es necesaria y violaría el security constraint.

Resultado:

```text
D = PROHIBITED
```

### 10.5 Decisión

Se selecciona:

```text
SELECTED CORRECTION =
A — CHANGE ONLY CONTROL-PATH CANCELLATION AUTHORITY
```

---

## 11. Corrección técnica seleccionada

La futura implementación debe modificar exclusivamente el harness CORR-032 para aplicar las siguientes reglas.

### 11.1 Gate, blocker y Hook permanecen intactos

No cambiar:

- `$gateSql` salvo el control path externo de release;
- `$blockerSql`;
- `New-Corr032HookSql`;
- application names;
- advisory key `320032`;
- bridge/grant fixture semantics;
- C032-CON-001..007;
- C032-CON-009..010.

### 11.2 Bounded cancellation privilege scope

La futura implementación debe mantener la conexión canónica ALT-001 y, sólo para la llamada de cancelación:

```text
precondition before privilege transition:
session_user = supabase_admin
current_user = postgres
```

Luego debe establecer dentro de una transacción bounded:

```text
SET LOCAL ROLE supabase_admin
```

La transición debe quedar limitada a esa transacción/control operation.

Antes de ejecutar la cancelación debe poder demostrarse:

```text
current_user = supabase_admin
```

Si cualquiera de las identities no coincide con el contrato esperado:

```text
STOP / FAIL-CLOSED
pg_cancel_backend = NOT CALLED
```

No existe fallback a GRANT/ALTER ROLE/otro login.

### 11.3 Single cancellation call

Después de establecer la authority acotada se conserva una única llamada:

```sql
select pg_cancel_backend(pid)::text
from pg_stat_activity
where application_name = 'corr032_precondition_gate';
```

No automatic retry.

Expected:

```text
numeric exit code = 0
query result = true
C032-CON-008 = PASS
```

Si el target no es exactamente el esperado o el resultado no es `true`, la ejecución falla cerradamente.

### 11.4 No persistent privilege effect

El role transition de cancelación:

- no modifica `pg_auth_members`;
- no modifica role attributes;
- no cambia grants;
- no cambia RLS;
- no cambia schema;
- no persiste después de la transacción/conexión;
- no crea un product path.

### 11.5 Diagnostic preservation

`Invoke-Corr032Psql` debe dejar de reemplazar toda evidencia por un string genérico.

Ante `psql exit != 0` debe preservar, de forma segura y sin credentials:

```text
numeric exit code
safe stdout
safe stderr
```

Y, cuando PostgreSQL los emita o el mecanismo de psql elegido permita obtenerlos de forma segura:

```text
SQLSTATE
severity
message
detail
hint
```

La implementación puede elegir el mecanismo PowerShell/psql más pequeño compatible con el archivo, pero debe mantener:

```text
password output = PROHIBITED
full DB URL output = PROHIBITED
PGPASSWORD output = PROHIBITED
credential-bearing command output = PROHIBITED
```

El error final debe conservar el causal database failure; no puede reducirlo nuevamente sólo a:

```text
Bounded CORR-032 psql command failed.
```

### 11.6 Control-job diagnostics

Para control jobs inesperadamente fallidos, la futura implementación debe preservar suficiente diagnóstico sanitizado para diferenciar:

- `psql` nonzero;
- job timeout;
- unexpected PowerShell job state;
- expected gate cancellation.

El path esperado de gate cancellation puede seguir consumiendo silenciosamente el error interno del `pg_sleep` cancelado después de haber probado `pg_cancel_backend = true`, porque esa failure state es parte del contrato de `Remove-Corr032CancelledGateJob`.

Una failure de gate anterior a la cancelación no puede ser reinterpretada como una cancelación exitosa.

### 11.7 Cleanup hardening dentro del mismo archivo

La futura implementación debe asegurar que:

1. todos los jobs registrados son detenidos/removidos best-effort;
2. los fixtures se intentan limpiar incluso ante failure del main path;
3. la restauración de `PGCONNECT_TIMEOUT` se ejecuta aunque falle el cleanup SQL;
4. el causal failure principal no sea sobrescrito silenciosamente por un cleanup failure;
5. cualquier cleanup failure quede reportado y bloquee PASS;
6. no se ejecute `pg_terminate_backend` como cleanup ordinario;
7. no se dependa de una segunda ejecución del test para limpiar.

### 11.8 Residual verification

Una ejecución futura sólo puede declararse PASS si al final demuestra:

```text
residual CORR-032 fixture rows = 0
residual corr032 precondition sessions/jobs = 0
```

La verificación debe ser read-only después del cleanup.

---

## 12. Scope físico

### 12.1 Affected repository paths

La inspección física completa determina:

```text
MODIFY ONLY:
supabase/tests/database/corr_032_task_013_auth_bridge_prebound_hook_concurrency.test.ps1
```

No se requiere otro path.

### 12.2 Functions/helpers expected to change

Dentro de ese único archivo, el diff esperado se limita a:

```text
Invoke-Corr032Psql
cancellation SQL/control block immediately before C032-CON-008
control-path diagnostic propagation as needed
finally/cleanup ordering as needed to guarantee cleanup invariants
post-cleanup residual verification as needed
```

No es requisito crear un helper nuevo. Si la implementación introduce un helper purpose-specific dentro del mismo archivo para encapsular cancelación/diagnóstico, debe mantenerse estrictamente local y no ampliar comportamiento.

### 12.3 Scope expansion rule

Si implementar los requisitos exige cualquier otro repository path:

```text
CORR-038 IMPLEMENTATION = STOP
BLOCKER — ADDITIONAL PATH REQUIRED
RETURN TO REVISOR CENTRAL
```

No expandir scope silenciosamente.

---

## 13. Fuera de alcance

Queda expresamente fuera de CORR-038:

```text
production source changes
schema changes
migration changes
RLS changes
role/grant/membership product changes
TASK-013 semantic changes
TASK-013 migration changes
Custom Access Token Hook changes
CORR-032 canonical semantic rewrite
CORR-023 canonical rewrite
Supabase configuration changes
Supabase Cloud
Hosted Development
Auth configuration changes
TASK-019 feature implementation
new concurrency semantics
loosening assertions
changing C032-CON-009 meaning
changing C032-CON-010 meaning
unbounded waits
new credentials
new persistent role topology
service_role as cancellation authority
application Auth Admin credentials
pg_terminate_backend as normal release path
```

---

## 14. Seguridad y privilegios

### 14.1 Security result

```text
security model change =
NONE

product privilege expansion =
NONE

new production privilege path =
NONE
```

La solución usa exclusivamente una autoridad ya presente en la conexión técnica local ALT-001 y sólo durante una operación test-only bounded de control orchestration.

### 14.2 Prohibiciones

No puede requerir:

```text
GRANT SUPERUSER
ALTER ROLE ... SUPERUSER
new pg_signal_backend grant
expanded product privileges
service_role
application Auth Admin credentials
RLS bypass
tenant authority changes
new production privilege path
persistent SET ROLE state
persistent role membership
```

### 14.3 Least privilege interpretation

El effective role ordinario del harness continúa siendo `postgres` salvo transiciones explícitas ya existentes y la nueva transición test-only exactamente alrededor de la cancelación.

No se autoriza ejecutar setup, business assertions, bridge updates, grant consumption ni Hook semantics como `supabase_admin` superuser.

---

## 15. RLS y multitenancy

```text
RLS impact =
NONE
```

```text
multitenancy impact =
NONE
```

CORR-038 no crea, modifica, relaja ni elimina policy alguna.

No introduce tenant selector, tenant authority, CompanyMembership access, client scope, SupportAccessGrant, service-role path ni cross-tenant behavior.

La corrección no depende de relajar tenant isolation.

---

## 16. Auth / Hook / Supabase boundary

```text
Custom Access Token Hook semantics =
UNCHANGED

Hook SECURITY mode =
UNCHANGED

supabase_auth_admin grants =
UNCHANGED

Auth configuration =
UNCHANGED

Supabase configuration =
UNCHANGED

Supabase Cloud =
NOT USED / NOT AUTHORIZED
```

El harness continúa siendo test orchestration local.

---

## 17. Failure model

La futura implementación debe ser fail-closed para todos los siguientes casos.

### 17.1 Unexpected role identity

Si antes de cancelación:

```text
session_user != supabase_admin
OR
current_user != postgres
```

entonces:

```text
STOP
cancellation call = NONE
privilege repair = NONE
```

Si después del bounded role transition:

```text
current_user != supabase_admin
```

mismo resultado.

### 17.2 Gate readiness timeout

Si gate readiness no llega a `1` en 10 s:

```text
FAIL
no blocker/hook continuation beyond safe point
cleanup mandatory
```

### 17.3 Blocker readiness timeout

Si el blocker no demuestra wait detrás del gate:

```text
FAIL
no semantic reinterpretation
cleanup mandatory
```

### 17.4 Hook readiness timeout

Si el Hook no demuestra wait detrás del blocker:

```text
FAIL
no cancellation as substitute for missing proof
cleanup mandatory
```

### 17.5 Unexpected binding/count

Cualquier count distinto del esperado en readiness o final state:

```text
FAIL
no retry
```

### 17.6 Gate release failure

Si la single cancellation call:

- retorna nozero;
- retorna distinto de `true`;
- no encuentra target;
- encuentra output ambiguo;

entonces:

```text
C032-CON-008 = FAIL / NOT PASS
cleanup mandatory
no fallback mechanism
```

### 17.7 Nonzero psql exit

Debe preservar evidencia diagnóstica segura conforme a §11.5 y terminar nonzero.

No automatic retry.

### 17.8 Unexpected job state

`Receive-Corr032Job` continúa exigiendo `Completed` para blocker/hook.

`Remove-Corr032CancelledGateJob` continúa exigiendo `Failed` para el gate después de una cancelación comprobada.

Otro estado:

```text
FAIL
```

### 17.9 Worker timeout

Tras 35 s:

```text
Stop-Job best-effort
FAIL
cleanup mandatory
```

No wait unbounded.

### 17.10 Cleanup failure

Cleanup failure:

```text
CORR-038 harness result = FAIL
```

Debe reportarse sin borrar el error causal anterior.

### 17.11 Residual fixtures/session state

Si queda cualquier fixture o sesión/job CORR-032 residual después del cleanup:

```text
FAIL
CLOSURE BLOCKED
```

No reparación silenciosa mediante una segunda ejecución.

---

## 18. Bounded execution contract

Se preservan exactamente, salvo blocker posterior separado:

```text
PGCONNECT_TIMEOUT = 5 seconds
statement_timeout = 30 seconds
lock_timeout = 20 seconds
concurrent job timeout = 35 seconds
readiness timeout = 10 seconds
readiness poll interval = 100 milliseconds
gate sleep bound = 25 seconds
```

La nueva role transition de cancelación no puede eliminar `statement_timeout`/`lock_timeout` del helper ni abrir un command path unbounded.

No se autoriza modificar estos valores durante CORR-038 por conveniencia.

Si una implementación demuestra que uno debe cambiar:

```text
STOP / RETURN FOR REVIEW
```

---

## 19. Cleanup model

### 19.1 Expected jobs/sessions

En el precondition scenario existen exactamente:

```text
1 gate control job/session
1 blocker control job/session
1 Hook job/session
```

además de las conexiones cortas de readiness/proof/cancellation.

### 19.2 Expected release result

```text
pg_cancel_backend result = true
C032-CON-008 = PASS
gate PowerShell job final state = Failed
blocker job final state = Completed
Hook job final state = Completed
```

### 19.3 Cleanup ordering

Orden contractual recomendado:

```text
1. main-path job consumption when reachable
2. finally: stop leftover Running/NotStarted jobs
3. finally: remove tracked jobs
4. finally: cleanup fixture rows
5. verify fixture residue = 0
6. verify corr032 precondition session residue = 0
7. restore PGCONNECT_TIMEOUT regardless of DB cleanup outcome
8. surface primary failure + cleanup failures without secret data
```

La implementación puede estructurar try/finally interno de otro modo si demuestra las mismas garantías.

### 19.4 Secret cleanup

El harness no debe asumir ownership de la credencial ALT-001 externa más allá del child process/environment recibido.

La orchestration que crea el controlled ALT-001 environment continúa obligada a eliminar el secreto de memoria/environment al terminar.

CORR-038 no puede imprimirlo ni persistirlo durante diagnostics.

### 19.5 Forbidden cleanup shortcuts

No depender de:

```text
manual silent cleanup
second test execution
pg_terminate_backend
role/grant repair
schema reset as substitute for targeted cleanup
```

---

## 20. Diagnostic preservation contract

### 20.1 Minimum evidence on psql nonzero

Debe preservarse:

```text
numeric exit code
safe stdout
safe stderr
```

### 20.2 PostgreSQL structured fields

Cuando estén disponibles:

```text
SQLSTATE
severity
message
detail
hint
```

### 20.3 Redaction boundary

Nunca incluir:

```text
PGPASSWORD
password value
full DB URL
JWT secret
service-role key
Supabase secret key
technical password
access token
refresh token
credential-bearing command line
```

### 20.4 Diagnostic precedence

Si existe un primary failure y luego cleanup failure:

```text
primary causal failure = preserved
cleanup failure = appended / secondary
```

No sustituir uno por el otro.

### 20.5 Expected cancellation noise

La cancelación intencional del gate puede producir error en el gate worker por interrupción de `pg_sleep`.

Ese error no debe convertirse en un false failure después de:

```text
pg_cancel_backend = true
```

y del expected gate job state `Failed`.

---

## 21. Expected repository changes

Una futura implementación autorizada debe producir un diff limitado a:

```text
supabase/tests/database/corr_032_task_013_auth_bridge_prebound_hook_concurrency.test.ps1
```

Cambios esperados:

```text
1. cancellation control block:
   introduce bounded test-only effective authority for pg_cancel_backend
   using existing ALT-001 session_user supabase_admin;

2. Invoke-Corr032Psql:
   preserve sanitized numeric exit/stdout/stderr and PostgreSQL error detail
   instead of generic-only throw;

3. control-job diagnostic handling:
   preserve enough sanitized evidence for unexpected control worker failures
   while keeping expected gate-cancellation semantics;

4. cleanup/finally:
   guarantee process-state restoration even if DB cleanup fails;

5. residual checks:
   verify no CORR-032 fixture/session residue remains before PASS.
```

No change expected in:

```text
docs/**
supabase/migrations/**
supabase/config.toml
src/**
app/**
package.json
package-lock.json
RLS policies
role topology
```

---

## 22. Test plan posterior a implementación

Esta specification define el plan; no autoriza su ejecución todavía.

### 22.1 Preflight físico

Antes de editar:

- repetir Git preflight fresco;
- verificar SHA-256 del canonical CORR-038 cuando exista;
- verificar SHA-256 baseline del harness `e83a0950...1712e6b` salvo Gate posterior que autorice otro baseline;
- confirmar que el canonical CORR-032 y CORR-023 continúan con los SHAs consumidos o detenerse ante drift.

### 22.2 Controlled ALT-001 authority preflight

Antes del targeted harness debe demostrarse de nuevo, sin secretos:

```text
session_user = supabase_admin
initial current_user = postgres
SET LOCAL ROLE supabase_auth_admin = PASS
```

Si falla:

```text
harness execution = NONE
BLOCKER
```

### 22.3 Targeted CORR-032 concurrency harness

Ejecutar exactamente el harness objetivo bajo canonical ALT-001 controlado.

Resultado requerido:

```text
CORR-032 CONCURRENCY HARNESS = PASS
C032-CON-001..010 = PASS
```

Específicamente:

```text
C032-CON-007 = PASS
precondition gate release = SUCCESSFUL
C032-CON-008 = REACHED AND PASS
C032-CON-009 = PASS
C032-CON-010 = PASS
```

### 22.4 Cancellation authority proof

La evidencia de review debe demostrar, sin credenciales:

```text
canceller baseline session_user = supabase_admin
canceller baseline current_user = postgres
bounded cancellation current_user = supabase_admin
pg_cancel_backend calls = 1
result = true
persistent role-topology mutation = 0
```

### 22.5 Failure-path diagnostic verification

La implementation review debe ejecutar un probe controlado, local, no mutante y sin secretos que haga transitar el **mismo diagnostic path implementado** por un `psql` nonzero seguro.

Debe demostrar:

```text
numeric exit code preserved
safe stdout preserved
safe stderr preserved
PostgreSQL structured fields preserved when emitted
secret exposure = NO
generic-only replacement = NO
```

El mecanismo de probe no debe requerir un nuevo repository path ni mutation de producto.

### 22.6 Cleanup verification

Después del targeted harness:

```text
tracked jobs = 0 active
corr032 precondition sessions = 0
32900000-* fixture residue = 0
PGCONNECT_TIMEOUT restored = YES
cleanup result = PASS
```

### 22.7 Relevant TASK-013 / CORR-032 regression coverage

La future review debe ejecutar la regression coverage local que el repositorio real vigente utilice para demostrar:

- TASK-013 DB foundation continúa passing bajo ALT-001;
- CORR-032 functional/privilege assertions continúan passing;
- same-grant concurrency conserva at most one success;
- unbound binding path continúa válido;
- already-bound same-subject path continúa válido;
- wrong-subject/email/grant negative paths continúan fail-closed;
- negative Auth-method coverage permanece passing;
- no RLS/grant widening ni tenant access aparece.

Los nombres concretos de comandos deben derivarse del repositorio real al momento de ejecución; no se inventan en esta specification.

### 22.8 Static/project checks

Ejecutar los checks aplicables según scripts reales del repositorio:

```text
TypeScript/static checks as applicable
lint as applicable
typecheck as applicable
relevant test suites
full test/verify as required by current project gate
```

### 22.9 Repository integrity

Obligatorio:

```text
git diff --check = PASS
changed paths = exactly authorized path
unexpected diff = NONE
staged changes = NONE unless later Gate explicitly authorizes staging
```

### 22.10 No Work Item F resume

El PASS de estos tests no reanuda automáticamente TASK-019 Work Item F.

Se requiere review de implementación y Gate separado.

---

## 23. Acceptance Criteria

Cada criterio debe evaluarse individualmente como `PASS`, `FAIL` o `BLOCKER` durante una futura implementación/review.

### Root cause / boundary

**AC-038-001.** La implementación corrige exclusivamente el defect class `CORR-032 TEST / REGRESSION HARNESS CONTROL-PATH DEFECT`.

**AC-038-002.** No se modifica semántica de producto, TASK-013 ni Custom Access Token Hook.

**AC-038-003.** Canonical ALT-001 permanece `session_user = supabase_admin` y baseline `current_user = postgres`.

**AC-038-004.** CORR-032 canonical no es modificado.

**AC-038-005.** CORR-023 canonical no es modificado.

**AC-038-006.** `C032-CON-001..010` se conservan como inventory del harness y no se eliminan ni renumeran.

### Physical scope

**AC-038-007.** El único repository path modificado es `supabase/tests/database/corr_032_task_013_auth_bridge_prebound_hook_concurrency.test.ps1`.

**AC-038-008.** Ningún archivo bajo `supabase/migrations/**` cambia.

**AC-038-009.** Ningún archivo bajo `src/**`, `app/**` o `docs/**` cambia durante implementación.

**AC-038-010.** `supabase/config.toml`, `package.json` y `package-lock.json` permanecen byte-for-byte sin cambios.

### Cancellation correction

**AC-038-011.** Antes de la cancelación se verifica fail-closed `session_user = supabase_admin` y baseline `current_user = postgres`.

**AC-038-012.** La authority adicional usada para cancelar se obtiene exclusivamente mediante una transición de role temporal dentro de la misma conexión ALT-001.

**AC-038-013.** La transición seleccionada es transaction-local/bounded y no persiste después del control operation.

**AC-038-014.** Durante la cancelación se prueba `current_user = supabase_admin` antes de llamar `pg_cancel_backend`.

**AC-038-015.** Se realiza exactamente una `pg_cancel_backend` call para liberar el precondition gate por ejecución del scenario.

**AC-038-016.** No existe automatic retry de la cancellation call.

**AC-038-017.** La cancellation call devuelve psql exit code `0`.

**AC-038-018.** La cancellation call devuelve exactamente `true`.

**AC-038-019.** `C032-CON-008` es alcanzado y pasa por la misma condición booleana fuerte del harness.

**AC-038-020.** `Remove-Corr032CancelledGateJob` recibe el gate job en el expected cancellation failure state y pasa.

### Concurrency semantics

**AC-038-021.** `C032-CON-001` pasa.

**AC-038-022.** `C032-CON-002` pasa.

**AC-038-023.** `C032-CON-003` pasa.

**AC-038-024.** `C032-CON-004` pasa.

**AC-038-025.** `C032-CON-005` pasa.

**AC-038-026.** `C032-CON-006` pasa.

**AC-038-027.** `C032-CON-007` pasa antes de la gate release.

**AC-038-028.** `C032-CON-009` pasa y el precondition Hook outcome continúa siendo `DENY`.

**AC-038-029.** `C032-CON-010` pasa y demuestra external binding preservado + grant unconsumed/unrevoked.

**AC-038-030.** CORR-032 same-grant concurrency continúa demostrando como máximo un consume exitoso.

**AC-038-031.** No se debilita la revalidación de la bridge precondition bajo lock.

### Privilege/security

**AC-038-032.** No se ejecuta `GRANT SUPERUSER` ni `ALTER ROLE ... SUPERUSER`.

**AC-038-033.** No se crea ningún nuevo grant de `pg_signal_backend`.

**AC-038-034.** No se crea ni modifica role membership.

**AC-038-035.** No se usa `service_role` como cancellation authority.

**AC-038-036.** No se usan application Auth Admin credentials.

**AC-038-037.** Product privilege expansion = `NONE`.

**AC-038-038.** RLS impact = `NONE`.

**AC-038-039.** Multitenancy impact = `NONE`.

**AC-038-040.** Tenant authority changes = `NONE`.

### Bounds

**AC-038-041.** `PGCONNECT_TIMEOUT` permanece 5 segundos.

**AC-038-042.** `statement_timeout` permanece 30 segundos.

**AC-038-043.** `lock_timeout` permanece 20 segundos.

**AC-038-044.** concurrent job timeout permanece 35 segundos.

**AC-038-045.** readiness timeout permanece 10 segundos.

**AC-038-046.** readiness poll interval permanece 100 ms.

**AC-038-047.** gate sleep bound permanece 25 segundos.

**AC-038-048.** Ningún nuevo wait unbounded es introducido.

### Diagnostics

**AC-038-049.** Un psql nonzero preserva numeric exit code en evidencia segura.

**AC-038-050.** Un psql nonzero preserva safe stdout y safe stderr sin fusionarlos de modo que impida distinguirlos.

**AC-038-051.** Cuando PostgreSQL emite SQLSTATE/severity/message/detail/hint, la evidencia los conserva de forma segura.

**AC-038-052.** El helper no reduce nuevamente un database failure a sólo `Bounded CORR-032 psql command failed.`.

**AC-038-053.** Password, PGPASSWORD, full DB URL y demás secretos no aparecen en diagnostics ni evidencia.

**AC-038-054.** El expected gate cancellation error interno no produce false failure después de `pg_cancel_backend = true` y expected gate job state.

### Cleanup

**AC-038-055.** Todos los PowerShell jobs tracked terminan removidos.

**AC-038-056.** No quedan sesiones activas con los application names del precondition scenario.

**AC-038-057.** No quedan fixtures `32900000-*` en las tablas limpiadas por el harness.

**AC-038-058.** `PGCONNECT_TIMEOUT` se restaura aunque el cleanup SQL falle.

**AC-038-059.** Cleanup failure bloquea PASS.

**AC-038-060.** Primary failure y cleanup failure se reportan sin que uno borre silenciosamente al otro.

**AC-038-061.** No se utiliza `pg_terminate_backend` como cleanup ordinario.

### Regression / repository

**AC-038-062.** Targeted CORR-032 harness pasa bajo controlled canonical ALT-001.

**AC-038-063.** Relevant TASK-013/CORR-032 regression coverage pasa.

**AC-038-064.** Privilege/RLS negative regression aplicable pasa sin widening.

**AC-038-065.** Failure-path diagnostic verification pasa usando el exact diagnostic path implementado.

**AC-038-066.** `git diff --check = PASS`.

**AC-038-067.** Repository diff contiene exactamente el path autorizado y ningún otro.

**AC-038-068.** Secret leakage review = `PASS / NO EXPOSURE`.

### Governance

**AC-038-069.** Supabase Cloud no se utiliza durante implementación/review local de CORR-038.

**AC-038-070.** TASK-019 Work Item F no se reanuda como efecto automático de CORR-038.

**AC-038-071.** CORR-038 implementation review debe ser `APPROVED` antes de solicitar resume de Work Item F.

**AC-038-072.** Work Item F requiere autorización humana separada de resume después del review aprobado.

```text
AC range =
AC-038-001..AC-038-072
```

---

## 24. Definition of Done

Ningún item de esta DoD queda marcado como completado por la generación de la specification.

**DoD-038-001.** CORR-038 specification generation = `PASS`.

**DoD-038-002.** CORR-038 SPEC REVIEW = `APPROVED`.

**DoD-038-003.** Approved artifact review = `APPROVED`.

**DoD-038-004.** Canonicalization Gate = `APPROVED`.

**DoD-038-005.** Canonical artifact identity = `PASS`.

**DoD-038-006.** Canonical incorporation Gate = `APPROVED`.

**DoD-038-007.** Separate implementation authorization = `APPROVED`.

**DoD-038-008.** Fresh Git preflight = `PASS`.

**DoD-038-009.** Required source/hash preflight = `PASS`.

**DoD-038-010.** Implementation modifies exactly the authorized harness path.

**DoD-038-011.** Selected correction A is implemented without fallback to B/C/D.

**DoD-038-012.** No product role/grant/membership mutation occurs.

**DoD-038-013.** No schema/migration/RLS mutation occurs.

**DoD-038-014.** Canonical ALT-001 authority preflight = `PASS`.

**DoD-038-015.** Targeted CORR-032 harness = `PASS`.

**DoD-038-016.** `C032-CON-001..010 = PASS`.

**DoD-038-017.** `C032-CON-008 = REACHED AND PASS`.

**DoD-038-018.** Relevant TASK-013/CORR-032 regressions = `PASS`.

**DoD-038-019.** Security/privilege invariants = `PASS`.

**DoD-038-020.** RLS impact = `NONE`, verified.

**DoD-038-021.** Multitenancy impact = `NONE`, verified.

**DoD-038-022.** Bounded timeout contract = `PASS`.

**DoD-038-023.** Cleanup verification = `PASS`.

**DoD-038-024.** Residual fixtures/sessions = `0`.

**DoD-038-025.** Failure-path diagnostic verification = `PASS`.

**DoD-038-026.** Secret leakage review = `PASS / NO EXPOSURE`.

**DoD-038-027.** `git diff --check = PASS`.

**DoD-038-028.** Implementation review = `APPROVED`.

**DoD-038-029.** Any authorized staging/commit/push Gates are completed separately and explicitly.

**DoD-038-030.** Human closure of CORR-038 = `APPROVED`.

**DoD-038-031.** TASK-019 Work Item F resume remains blocked until a separate authorization after CORR-038 closure/review.

```text
DoD range =
DoD-038-001..DoD-038-031
```

---

## 25. Documentation impact

Con la evidencia física actual:

```text
new ADR =
NOT REQUIRED

CORR-032 canonical semantic update =
NOT REQUIRED

CORR-023 canonical semantic update =
NOT REQUIRED

product docs update =
NOT REQUIRED
```

La única documentación nueva requerida en este Gate es:

```text
CORR-038 specification
```

Si una futura implementación demuestra que cualquiera de esos estados deja de ser cierto:

```text
STOP
BLOCKER — NEW TECHNICAL CONTRADICTION
RETURN TO REVISOR CENTRAL
```

No editar documentación anterior silenciosamente.

---

## 26. Relationship con TASK-019 Work Item F

Se mantiene:

```text
TASK-019 WORK ITEM F =
STOP — REGRESSION DETECTED / NOT COMPLETE

TASK-019 WORK ITEM F REVIEW =
BLOCKER CONFIRMED

TASK-019 Work Item F resume =
NOT AUTHORIZED
```

Aun después de una futura implementación técnica exitosa de CORR-038 se requiere:

```text
CORR-038 IMPLEMENTATION REVIEW = APPROVED
+
SEPARATE TASK-019 WORK ITEM F RESUME AUTHORIZATION
```

CORR-038 no puede saltar ninguno de esos Gates.

---

## 27. Governance y prohibiciones activas

Durante y después de esta canonical artifact generation continúa:

```text
implementation =
NOT AUTHORIZED

repository mutation =
NOT AUTHORIZED

repository incorporation =
NOT AUTHORIZED

harness mutation =
NOT AUTHORIZED

harness execution =
NOT AUTHORIZED

database mutation =
NOT AUTHORIZED

staging =
NOT AUTHORIZED

commit =
NOT AUTHORIZED

push =
NOT AUTHORIZED

Supabase Cloud =
NOT AUTHORIZED

CORR-032 execution =
NOT AUTHORIZED BY THIS CANONICALIZATION

role/grant/membership mutation =
NOT AUTHORIZED

schema/migration/RLS mutation =
NOT AUTHORIZED

TASK-019 Work Item F resume =
NOT AUTHORIZED
```

---

## 28. Findings

### F-038-001 — Required physical sources

```text
status = RESOLVED / PASS
```

Las tres fuentes físicas obligatorias están disponibles y coinciden exactamente con los SHA-256 exigidos.

### F-038-002 — Canonical contradiction

```text
status = NONE DETECTED
```

El canonical CORR-032 no prescribe el mecanismo `pg_cancel_backend`, la identity de la cancel connection ni los IDs `C032-CON-*` como product semantics.

### F-038-003 — Root cause mapping

```text
status = CONFIRMED
```

El `42501` aislado explica el generic `Invoke-Corr032Psql` failure del full harness inmediatamente antes de C032-CON-008.

### F-038-004 — Selected correction

```text
status = A SELECTED
```

La corrección mínima es activar de forma bounded y test-only la authority de `supabase_admin` exclusivamente durante la single `pg_cancel_backend` call, conservando el resto del harness bajo baseline `postgres` o sus transiciones explícitas existentes.

### F-038-005 — Scope

```text
status = ONE PATH
```

Único path propuesto:

```text
supabase/tests/database/corr_032_task_013_auth_bridge_prebound_hook_concurrency.test.ps1
```

### F-038-006 — Documentation

```text
new ADR = NO
product docs update = NO
CORR-032 canonical update = NO
```

### F-038-007 — Work Item F

```text
status = REMAINS BLOCKED
```

---

## 29. Resultado de canonicalization

```text
CORR-038 SPECIFICATION GENERATION =
PASS

CORR-038 SPEC REVIEW =
APPROVED

CORR-038 HUMAN SPEC APPROVAL =
APPROVED

CORR-038 APPROVED ARTIFACT GENERATION =
PASS

CORR-038 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-038 CANONICALIZATION AUTHORIZATION =
APPROVED

F-038-SPEC-001 =
RESOLVED

approved specification =
YES

approved artifact review =
APPROVED

canonical artifact =
GENERATED

repo-relative canonical target =
docs/tasks/CORR-038-corr-032-canonical-alt-001-precondition-gate-cancellation-harness-compatibility.md

repository incorporation =
NOT AUTHORIZED

implementation authorized =
NO
```

Razones:

- authorization de generación existe;
- source set obligatorio fue verificado físicamente;
- no se detectó contradicción canónica nueva;
- la causa está probada;
- existe una corrección harness-only mínima y verificable;
- security/RLS/multitenancy permanecen sin cambios;
- scope físico queda limitado a un único path;
- ACs y DoD están definidos antes de implementación.

Esta declaración registra exclusivamente la generación del canonical artifact. No constituye repository incorporation ni autoriza implementación.

---

## 30. Siguiente Gate

```text
CORR-038 CANONICALIZATION REVIEW
```

```text
DESTINO:
REVISOR CENTRAL
```

No incorporar el artefacto al repositorio, implementar CORR-038 ni reanudar TASK-019 Work Item F sin ese review y los Gates humanos correspondientes.

---

## 31. Resumen para CANONICALIZATION REVIEW

```text
CORR-038 SPECIFICATION GENERATION = PASS

CORR-038 SPEC REVIEW = APPROVED

CORR-038 HUMAN SPEC APPROVAL = APPROVED

CORR-038 APPROVED ARTIFACT GENERATION = PASS

CORR-038 APPROVED ARTIFACT REVIEW = APPROVED

CORR-038 CANONICALIZATION AUTHORIZATION = APPROVED

F-038-SPEC-001 = RESOLVED

approved specification = YES

approved artifact review = APPROVED

canonical artifact = GENERATED

repository incorporation = NOT AUTHORIZED

implementation authorized = NO

artifact =
CORR-038-corr-032-canonical-alt-001-precondition-gate-cancellation-harness-compatibility-canonical.md

repo-relative canonical target =
docs/tasks/CORR-038-corr-032-canonical-alt-001-precondition-gate-cancellation-harness-compatibility.md

F-019-F-010 =
OPEN / CORR-038 CANONICAL ARTIFACT GENERATED / PENDING CANONICALIZATION REVIEW

problem class =
CORR-032 TEST / REGRESSION HARNESS CONTROL-PATH DEFECT

root cause =
CONFIRMED HARNESS CONTROL-PATH AUTHORITY INCOMPATIBILITY

selected correction =
A — CHANGE ONLY CONTROL-PATH CANCELLATION AUTHORITY

affected paths =
1

RLS impact =
NONE

multitenancy impact =
NONE

product privilege expansion =
NONE

new ADR =
NO

canonical semantic update =
NO

AC range =
AC-038-001..AC-038-072

DoD range =
DoD-038-001..DoD-038-031

implementation =
NOT AUTHORIZED

TASK-019 Work Item F resume =
NOT AUTHORIZED

next Gate =
CORR-038 CANONICALIZATION REVIEW

DESTINO =
REVISOR CENTRAL
```
