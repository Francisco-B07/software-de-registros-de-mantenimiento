# CORR-023 — Compatibilidad del harness local de regresión de TASK-013 con `supabase_auth_admin`

## 1. Identificación

**ID:** `CORR-023`

**Título:** `CORR-023 — Compatibilidad del harness local de regresión de TASK-013 con supabase_auth_admin`

**Tipo:** `TEST HARNESS / REGRESSION CORRECTION`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Área principal:** `Supabase Local / PostgreSQL / pgTAP / regression harness`

**Estado de esta specification corregida:** `APPROVED`

**Archivo canónico:**

`CORR-023-task-013-local-db-regression-runner-supabase-auth-admin.md`

**Ruta canónica de repositorio prevista:**

`docs/tasks/CORR-023-task-013-local-db-regression-runner-supabase-auth-admin.md`

**CORR-023 DETERMINATION:** `APPROVED`

**CORR-023 DISCOVERY:** `PASS`

**CORR-023 DISCOVERY REVIEW:** `APPROVED`

**CORR-023 SPECIFICATION GENERATION GATE:** `AUTHORIZED`

**CORR-023 SPEC REVIEW:** `RETURNED FOR MINIMAL CORRECTION`

**Correction class:** `ALT-001 BASELINE EFFECTIVE-ROLE SEMANTICS NOT PRESERVED`

**CORR-023 SPECIFICATION CORRECTION:**

```text
READY FOR RE-REVIEW
```

**CORR-023 SPEC RE-REVIEW:** `APPROVED`

**CORR-023 SPEC REVIEW FINAL:** `APPROVED`

**CORR-023 HUMAN SPEC APPROVAL:** `APPROVED`

**CORR-023 APPROVED ARTIFACT REVIEW:** `RETURNED FOR MINIMAL CORRECTION`

**Approved artifact correction class:** `APPROVED ARTIFACT FILENAME IDENTITY DRIFT`

**CORR-023 APPROVED ARTIFACT CORRECTION:** `READY FOR RE-REVIEW`

**CORR-023 APPROVED ARTIFACT RE-REVIEW:** `APPROVED`

**CORR-023 APPROVED ARTIFACT REVIEW FINAL:** `APPROVED`

**CORR-023 CANONICALIZATION GATE:** `AUTHORIZED`

**CORR-023 CANONICALIZATION:** `READY FOR REVIEW`

**CORR-023 canonicalized:** `YES — PENDING CANONICAL ARTIFACT REVIEW`

Debe permanecer:

```text
production capability change = NO
product decision = NO
domain decision = NO
architecture decision = NO
new ADR required = NO

TASK-013 reopening = NO
TASK-013 production implementation change = NO
TASK-013 production migration change = NO

TASK-015 implementation change = NO

Supabase Cloud change = NO
Hosted Development change = NO
Staging change = NO
Production change = NO
```

Esta specification no constituye implementación.

No autoriza Codex.

No modifica el repositorio.

No ejecuta SQL.

No crea scripts reales.

No modifica Supabase Local ni Supabase Cloud.

---

## 2. Objetivo único

CORR-023 debe corregir exclusivamente la incompatibilidad física del **harness DB local** de TASK-013 que impide completar las últimas siete pruebas pgTAP bajo el rol runtime real `supabase_auth_admin`.

El resultado futuro debe permitir demostrar localmente:

```text
TASK-013 plan = 72
TASK-013 assertions executed = 72
TASK-013 failed assertions = 0
TASK-013 bad plan = NO
TASK-013 Result = PASS
```

incluyendo obligatoriamente:

```text
T013-DB-066 = PASS
T013-DB-067 = PASS
T013-DB-068 = PASS
T013-DB-069 = PASS
T013-DB-070 = PASS
T013-DB-071 = PASS
T013-DB-072 = PASS
```

sin cambiar la semántica productiva de TASK-013.

Principio rector:

```text
production privileges are the object under test
!=
runner privileges required to test them locally
```

CORR-023 sólo puede modificar la segunda parte.

---

## 3. Naturaleza y límites no negociables

CORR-023 es una corrección de infraestructura de prueba local.

No puede convertirse en:

- corrección de producto;
- corrección de dominio;
- corrección de RLS productiva;
- corrección del Custom Access Token Hook;
- corrección de grants productivos;
- cambio de topología de roles productiva;
- cambio de migration;
- cambio de Supabase Cloud;
- cambio de Hosted Development;
- reapertura funcional de TASK-013;
- implementación o ampliación de TASK-015.

Debe permanecer exactamente:

```text
Custom Access Token Hook = SECURITY INVOKER
supabase_auth_admin tenant privileges = NO
postgres → supabase_auth_admin production membership requirement = NO
RLS productiva = UNCHANGED
TASK-013 migration = UNCHANGED
TASK-013 production grants = UNCHANGED
TASK-013 production policies = UNCHANGED
```

---

## 4. Estado formal de entrada consumido

Se consume como estado de gobernanza:

```text
CORR-023 DETERMINATION = APPROVED
CORR-023 DISCOVERY = PASS
CORR-023 DISCOVERY REVIEW = APPROVED
CORR-023 SPECIFICATION GENERATION GATE = AUTHORIZED
```

La corrección fue determinada después de que la revisión local de TASK-015 encontrara una regresión previa/cerrada en el harness de TASK-013.

Debe mantenerse:

```text
TASK-015 specific local tests = PASS
TASK-015 production defect = NO

TASK-015 Hosted Development =
BLOCKED UNTIL CORR-023 CLOSED AND FULL LOCAL REGRESSION PASS

CORR-023 != TASK-015 implementation
CORR-023 closure != automatic Hosted Development authorization

TASK-015 DONE = NO
TASK-016 = NOT DETERMINED / NOT GENERATED / NOT STARTED
```

Baseline Git de discovery consumido como snapshot histórico de generación:

```text
branch = main
HEAD = 434618723d7a787d15a20358fe753477eca9e76e
origin/main = 434618723d7a787d15a20358fe753477eca9e76e
divergence = 0 0
staged = NONE
```

Worktree preexistente de TASK-015 observado:

```text
tracked unstaged:
src/modules/identity-authorization/server.ts

untracked:
src/modules/identity-authorization/application/apply-company-membership-lifecycle.ts
src/modules/identity-authorization/infrastructure/supabase/company-membership-lifecycle-source.ts
supabase/migrations/20260909000205_task_015_company_membership_lifecycle_audit_event_atomic.sql
supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql
supabase/tests/database/task_015_company_membership_lifecycle_concurrency.test.ps1
tests/task-015-company-membership-lifecycle.test.ts
```

Este snapshot no autoriza una futura ejecución sobre un SHA distinto.

Toda ejecución de CORR-023 deberá repetir un preflight Git fresco y comparar el worktree real con el baseline expresamente autorizado para esa ejecución.

---

## 5. Fuentes de verdad obligatorias

La futura implementación y toda revisión de CORR-023 deben releer íntegramente, como mínimo:

### 5.1 Canon de TASK-013

```text
docs/tasks/TASK-013-verification-challenge-foundation.md
```

Debe preservar especialmente:

- `SECURITY INVOKER` como modelo base del hook;
- mínimo privilegio explícito de `supabase_auth_admin`;
- grants preferentemente column-scoped;
- RLS purpose-specific;
- ausencia de privilegios tenant para `supabase_auth_admin`;
- tests runtime de la superficie Auth;
- full regression passing.

### 5.2 ADR-0019

```text
docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md
```

Debe preservar:

- Postgres Custom Access Token Hook;
- `SECURITY INVOKER`;
- explicit grants mínimos;
- `supabase_auth_admin` sin tenant bypass;
- RLS como frontera primaria para datos tenant-owned;
- ausencia de generic privileged client.

### 5.3 CORR-017

```text
docs/tasks/CORR-017-db-regression-harness-normalization.md
```

Debe preservarse su historia y su contrato no afectado:

- suites DB autónomas seleccionadas mediante paths explícitos;
- no ejecutar automáticamente `task_009_auth_delete_setup.sql`;
- no ejecutar automáticamente `task_009_auth_delete_verify.sql`;
- pgTAP real;
- `plan(N)` coherente;
- `finish()`;
- rollback;
- no assertions de relleno;
- no reducción silenciosa de cobertura;
- no Cloud.

### 5.4 Fuentes físicas del discovery

Debe verificarse contra el repositorio real autorizado que continúan correspondiendo a:

```text
supabase/tests/database/task_013_verification_challenge_foundation.test.sql
SHA-256 =
00c804ce1117ae086fca331707fdc2bc055857e0982584e573fb666251c3eca4

supabase/migrations/20260830010000_task_013_verification_challenge_foundation.sql
SHA-256 =
1d4833f38be525974d447dc0dd301211a1d6bad68edadcfe46f424f5eb4e0dbf
```

Si cualquiera de esas identidades cambia antes de la implementación autorizada:

```text
BLOCKER — REQUIRED SOURCE IDENTITY DRIFT
```

No asumir que un cambio posterior es compatible sin revisión.

### 5.5 Configuración local

Debe inspeccionarse:

```text
supabase/config.toml
```

El discovery verificó:

```text
[db].port = 54322
[db].major_version = 17

auth enabled = true
public signup = disabled
Custom Access Token Hook = enabled
hook URI = pg-functions://postgres/public/task_013_custom_access_token_hook
```

El puerto real de una futura ejecución debe leerse del archivo vigente; no se debe hardcodear `54322` dentro del runner como sustituto de esa lectura.

---

## 6. Problema físico confirmado

El archivo actual de TASK-013 contiene:

```text
BEGIN
plan(72)
...
SET LOCAL ROLE supabase_auth_admin
...
finish()
ROLLBACK
```

Su identidad confirmada durante discovery es:

```text
bytes = 35144
LF = 923
CRLF = 0
bare CR = 0
trailing-whitespace lines = 0
final newline = YES
```

El runner canónico observado:

```text
npx supabase test db supabase/tests/database/task_013_verification_challenge_foundation.test.sql
```

usa:

```text
Supabase CLI = 2.114.0
runner = pg_prove
target = Supabase PostgreSQL LOCAL
login role = postgres
```

Topología local relevante observada:

```text
postgres:
rolsuper = NO
rolinherit = YES
rolcreaterole = YES
rolcreatedb = YES
rolcanlogin = YES

supabase_admin:
rolsuper = YES

supabase_auth_admin:
rolsuper = NO
rolinherit = NO
rolcreaterole = YES
rolcreatedb = NO
rolcanlogin = YES

postgres → supabase_auth_admin membership = NONE
```

Por tanto:

```text
current canonical runner can SET ROLE supabase_auth_admin = NO
```

---

## 7. Fallo reproducible y clasificación

La ejecución actual produce:

```text
plan = 72
assertions emitted = 65
failed emitted assertions = 0

fatal SQLSTATE = 42501
fatal = permission denied to set role "supabase_auth_admin"
source line = 791

remaining assertions = 7
```

Assertions no ejecutadas:

```text
T013-DB-066
T013-DB-067
T013-DB-068
T013-DB-069
T013-DB-070
T013-DB-071
T013-DB-072
```

Salida determinante observada:

```text
Failed 7/72 subtests
Tests: 65 Failed: 0
Parse errors: Bad plan. You planned 72 tests but ran 65.
Result: FAIL
```

Clasificación cerrada por discovery:

```text
root cause classification = TASK013-B
production defect = NO
test harness defect = YES
CLI version drift = NO
historical role-topology drift = NOT PROVEN
```

Debe preservarse:

```text
historical 65/65 PASS
!=
current 72/72 runtime proof
```

No existe evidencia recuperada de un 72/72 histórico.

CORR-023 no reescribe esa historia.

---

## 8. Contradicción interna del harness

El mismo archivo afirma antes de la sección final:

```text
The CLI pgTAP connection cannot assume supabase_auth_admin.
```

pero posteriormente contiene:

```text
set local role supabase_auth_admin;
```

para ejecutar T013-DB-066..072.

La incompatibilidad es exactamente:

```text
TASK-013 test requires real supabase_auth_admin runtime
+
canonical runner login cannot assume supabase_auth_admin
```

La corrección debe resolver el segundo término.

No puede eliminar el primero.

---

## 9. Producción validada como no causante

La migration canónica de TASK-013 debe quedar byte-for-byte sin cambios.

El discovery confirmó:

```text
hook = SECURITY INVOKER
role membership changes involving supabase_auth_admin = NONE
```

La migration productiva concede a `supabase_auth_admin` exclusivamente la superficie purpose-specific requerida:

- `USAGE` mínimo de schema;
- `EXECUTE` del Custom Access Token Hook;
- `SELECT` column-scoped requerido sobre estado platform-owned;
- `UPDATE` column-scoped requerido sobre estado platform-owned;
- RLS policies purpose-specific.

Debe permanecer:

```text
supabase_auth_admin tenant privileges = NO
```

Queda prohibido resolver CORR-023 mediante:

- membership productiva `postgres → supabase_auth_admin`;
- `SECURITY DEFINER` del hook;
- grants productivos más amplios;
- policy más amplia;
- bypass RLS;
- nuevo tenant privilege;
- migration nueva que modifique la frontera TASK-013;
- edición de la migration existente.

---

## 10. Relación con CORR-017

### 10.1 Clasificación seleccionada

CORR-023 selecciona explícitamente:

```text
CORR-017 relationship = B
```

Es decir:

> CORR-023 **supersede únicamente la parte del contrato operativo de CORR-017 que utiliza el login local por defecto `postgres` para ejecutar TASK-013 y pretender demostrar la superficie runtime de `supabase_auth_admin`.**

### 10.2 Qué NO se supersede

CORR-023 conserva de CORR-017:

- uso de `npx supabase` del repositorio;
- Supabase CLI fijada por el repositorio;
- uso de `supabase test db` / pgTAP;
- selección mediante paths explícitos;
- prohibición de usar `npx supabase test db` sin paths como Gate concluyente;
- exclusión de scripts operativos históricos de Auth-delete;
- `BEGIN → plan(N) → assertions → finish() → ROLLBACK`;
- denegaciones reales de PostgreSQL;
- ausencia de assertions de relleno;
- no Cloud;
- no dependencia nueva por conveniencia.

### 10.3 Qué queda superseded

A partir de una futura canonicalización y cierre de CORR-023, deja de ser prueba concluyente actual para TASK-013:

```text
npx supabase test db \
  supabase/tests/database/task_013_verification_challenge_foundation.test.sql
```

cuando esa invocación utilice el login local por defecto `postgres`.

Asimismo:

```text
TASK-013 = 65/65 PASS
```

permanece exclusivamente como evidencia histórica de CORR-017/TASK-013.

No satisface el proof vigente de:

```text
TASK-013 = 72/72 PASS
```

### 10.4 Sincronización documental adicional

Para esta specification:

```text
C = NO, por defecto
```

La canonicalización futura de CORR-023 será la autoridad posterior que documenta la supersession acotada.

No se modifica retrospectivamente CORR-017.

Si el preflight de una futura implementación encuentra **otro documento activo vigente** que reproduzca el comando de CORR-017 como único Gate actual de TASK-013 y cuya semántica no pueda quedar correctamente interpretada mediante la autoridad posterior de CORR-023:

```text
BLOCKER — ADDITIONAL DOCUMENTATION SYNC REQUIRES SEPARATE REVIEW
```

No editar documentación adicional por conveniencia durante la implementación técnica.

---

## 11. Evaluación y decisión de alternativa

### 11.1 ALT-001 — seleccionada

Mecanismo:

```text
npx supabase test db --db-url <LOCAL_SUPABASE_ADMIN_DB_URL> \
  supabase/tests/database/task_013_verification_challenge_foundation.test.sql
```

La conexión del runner debe preservar simultáneamente:

```text
session_user / login = supabase_admin
connection-time/default role = postgres
initial current_user = postgres
```

El default role debe establecerse al conectar mediante el mecanismo PostgreSQL/libpq soportado de `options`, conceptualmente equivalente a:

```text
options = -c role=postgres
```

serializado en la connection URI con el percent-encoding requerido.

El propio archivo TASK-013 conservará sus transiciones actuales con esta semántica:

```text
SET LOCAL ROLE service_role
→ current_user = service_role
RESET ROLE
→ current_user = postgres
...
SET LOCAL ROLE supabase_auth_admin
→ current_user = supabase_auth_admin
```

Debe preservarse:

```text
supabase_admin technical session authority = SET ROLE capability only
supabase_admin != effective ordinary test role
T013-DB-001..065 baseline = postgres, salvo SET ROLE explícitos existentes
T013-DB-066..072 runtime = supabase_auth_admin
```

La razón de selección es:

```text
production DB change = NO
test-only = YES
new role topology = NO
persistent membership mutation = NO
historical postgres effective-role semantics preserved = YES
actual supabase_auth_admin runtime semantics = YES
existing Supabase CLI mechanism = YES
cleanup manual of role topology = NO
```

### 11.2 ALT-002 — no seleccionada

No se crea un test-runner role local porque ALT-001 no presenta una incompatibilidad física demostrada en el discovery.

ALT-002 introduciría:

- topología adicional;
- bootstrap de role;
- credencial adicional;
- cleanup adicional;
- más superficie de fallo.

Por tanto:

```text
ALT-002 = NOT AUTHORIZED BY CORR-023
```

Si una futura ejecución demuestra físicamente que ALT-001 no puede autenticarse o no puede ejecutar la suite con la CLI/versiones autorizadas:

```text
BLOCKER
RETURN TO REVISOR CENTRAL
```

No fallback automático a ALT-002.

### 11.3 ALT-003 — no seleccionada

No se concede temporalmente `supabase_auth_admin` a `postgres`.

Razón:

- deja una mutación de topología que debe revertirse;
- una interrupción puede dejar membership residual;
- aumenta riesgo de drift;
- no es necesaria mientras ALT-001 sea viable.

Por tanto:

```text
ALT-003 = PROHIBITED FOR CORR-023
```

---

## 12. Scope físico futuro autorizado

La implementación futura de CORR-023 queda limitada a una única superficie versionada nueva:

```text
CREATE
supabase/tests/database/corr_023_local_db_regression.ps1
```

Responsabilidad única del archivo:

- probar inequívocamente que el target es Supabase Local del repositorio;
- obtener en memoria la conexión local sin hardcodear credenciales;
- derivar la conexión local de `supabase_admin` sin imprimir secretos;
- ejecutar TASK-013 mediante `--db-url` con ese login;
- ejecutar el contrato de regresión local completo definido por esta specification;
- preservar paths explícitos;
- fallar cerradamente ante cualquier duda.

No se autoriza modificar:

```text
package.json
package-lock.json
supabase/config.toml
supabase/tests/database/task_013_verification_challenge_foundation.test.sql
```

El test TASK-013 actual no necesita adaptación persistente para ALT-001.

El `SET LOCAL ROLE supabase_auth_admin` existente constituye parte del comportamiento que debe pasar, no una línea a eliminar ni suavizar.

### 12.1 Read-only obligatorio

Deben permanecer read-only durante CORR-023:

```text
supabase/migrations/**

supabase/tests/database/task_009_identity_tenant_foundation.test.sql
supabase/tests/database/task_010_audit_event_foundation.test.sql
supabase/tests/database/task_013_verification_challenge_foundation.test.sql

cualquier suite DB existente de TASK-014

supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql
supabase/tests/database/task_015_company_membership_lifecycle_concurrency.test.ps1

tests/**
src/**
docs/**
.env*
```

### 12.2 Fuera de scope absoluto

```text
supabase/migrations/20260830010000_task_013_verification_challenge_foundation.sql
= OUT OF SCOPE / MUST NOT CHANGE

src/ production = OUT OF SCOPE
Supabase Cloud = OUT OF SCOPE
Hosted Development = OUT OF SCOPE
Staging = OUT OF SCOPE
Production = OUT OF SCOPE
```

Si el objetivo no puede cumplirse creando únicamente el runner anterior:

```text
BLOCKER / RETURN FOR REVIEW
```

No ampliar paths automáticamente.

---

## 13. Contrato del runner seleccionado

### 13.1 Herramientas

El runner debe utilizar exclusivamente tooling ya existente:

```text
PowerShell
npx
Supabase CLI del repositorio
Docker requerido por Supabase Local/CLI
PostgreSQL local existente
```

Nuevas dependencias npm:

```text
0
```

No instalar:

- módulo PowerShell externo;
- CLI alterna;
- wrapper npm adicional;
- ORM;
- framework de test nuevo.

### 13.2 No generic privileged client

El login `supabase_admin` existe exclusivamente como credencial técnica del **runner local de tests**.

No puede:

- exponerse a aplicación;
- convertirse en config de runtime productivo;
- añadirse a `.env.example`;
- añadirse a `src/`;
- usarse para requests de usuario;
- usarse contra Hosted/Cloud;
- sustituir RLS como frontera de producción.

### 13.3 Paths explícitos

El runner no debe utilizar como Gate concluyente:

```text
npx supabase test db
```

sin paths.

Cada suite autónoma debe ser invocada explícitamente.

Los scripts históricos TASK-009:

```text
task_009_auth_delete_setup.sql
task_009_auth_delete_verify.sql
```

no forman parte del Gate automático.

---

## 14. LOCAL TARGET PROOF — obligatorio y fail-closed

Ninguna conexión privilegiada `supabase_admin` puede construirse ni utilizarse para ejecutar tests antes de completar el proof local.

El proof debe usar **múltiples señales técnicas independientes**.

No basta una sola variable, project name, linked metadata ni texto suministrado por caller.

### 14.1 Paso 1 — repo/config source

El runner debe:

1. resolver el repo root desde la ubicación física del script;
2. exigir la existencia de `supabase/config.toml` bajo ese repo;
3. leer `[db].port` del archivo vigente;
4. rechazar un puerto ausente, inválido o ambiguo.

No hardcodear el puerto como prueba de identidad.

### 14.2 Paso 2 — Supabase Local status

El runner debe consultar el estado del stack mediante el `npx supabase` del repositorio.

La salida debe capturarse en memoria y **no imprimirse** porque puede contener material sensible del stack local.

Debe extraerse únicamente el DB URL local necesario.

Si el stack no está levantado:

```text
BLOCKER — LOCAL SUPABASE STACK NOT RUNNING
```

El runner no debe ejecutar `supabase start` automáticamente.

### 14.3 Paso 3 — endpoint proof

Del DB URL obtenido deben validarse obligatoriamente:

```text
scheme = postgresql | postgres
host = 127.0.0.1
port = exact [db].port from supabase/config.toml
database = postgres
```

Queda rechazado:

- hostname remoto;
- IP no loopback;
- IPv6 no verificada por esta specification;
- puerto diferente;
- URL sin puerto;
- URL suministrada manualmente por caller como sustituto del status local;
- `--linked`;
- project ref remoto.

Resultado ante cualquier duda:

```text
BLOCKER — LOCAL TARGET NOT PROVEN
```

### 14.4 Paso 4 — Docker binding proof

Antes de usar la conexión privilegiada, el runner debe confirmar mediante Docker que existe un contenedor PostgreSQL **running** del stack local y que su puerto PostgreSQL está publicado hacia el mismo endpoint/puerto local validado en §14.3.

El proof no puede basarse exclusivamente en el nombre del contenedor o `project_id`.

Debe contrastar como mínimo:

```text
container running = YES
container PostgreSQL port = 5432/tcp
published host port = [db].port
runner endpoint actually used = 127.0.0.1:[db].port
```

El binding Docker puede estar publicado por el motor en una interfaz host más amplia; eso no autoriza al runner a usarla. La URL efectiva del runner debe continuar apuntando exactamente a `127.0.0.1:[db].port`.

Si Docker no permite establecer la correspondencia inequívoca entre el contenedor PostgreSQL local y ese host port:

```text
BLOCKER — LOCAL CONTAINER BINDING NOT PROVEN
```

### 14.5 Paso 5 — construcción segura de la URL `supabase_admin`

Sólo después de §14.1..14.4 puede construirse en memoria la conexión para ALT-001.

Regla:

- reutilizar host, port, database y secreto local obtenidos del DB URL emitido por el stack local;
- sustituir exclusivamente el user/login por `supabase_admin`;
- añadir el connection parameter `options = -c role=postgres`;
- percent-encodear correctamente ese valor en la PostgreSQL connection URI, con representación equivalente a `options=-c%20role%3Dpostgres`;
- no persistir la URL;
- no escribirla en archivo;
- no añadirla a Git;
- no exportarla globalmente al proceso padre;
- no imprimirla;
- no pasarla por logs de diagnóstico.

El secreto no se hardcodea.

Si el connection-time role o su percent-encoding no pueden establecerse de forma segura:

```text
BLOCKER
RETURN TO REVISOR CENTRAL
```

### 14.6 Paso 6 — autenticación efectiva

Antes de TASK-013 debe demostrarse mediante check read-only local y sanitizado:

```text
PROOF-A
session_user = supabase_admin
initial current_user = postgres
```

También debe demostrarse que un `SET ROLE` explícito seguido de `RESET ROLE` produce:

```text
PROOF-B
current_user restored = postgres
```

Si `session_user != supabase_admin`, baseline `current_user != postgres` o `RESET ROLE` restaura `supabase_admin`:

```text
ALT-001 PHYSICAL VIABILITY = FAIL
CORR-023 IMPLEMENTATION = BLOCKER
RETURN TO REVISOR CENTRAL
```

No sustituir automáticamente por ALT-002/ALT-003.

---

## 15. Protección de secretos

El runner debe tratar como secreto cualquier URI que contenga password, así como cualquier key emitida por `supabase status`.

Reglas obligatorias:

```text
connection URL in normal stdout = NO
connection URL in stderr = NO
password in stdout/stderr = NO
JWT secret in stdout/stderr = NO
service-role key in stdout/stderr = NO
anon key dump = NO
```

Cuando un subprocess falle:

- reportar exit code;
- reportar fase lógica del fallo;
- reportar un mensaje sanitizado;
- no volcar el comando completo si contiene `--db-url`;
- no volcar variables capturadas de `supabase status`.

La evidencia no debe imprimir la URI completa, ni siquiera con password redactado.

Puede representar únicamente:

```text
sanitized local endpoint = 127.0.0.1:<local-port>
session_user = supabase_admin
baseline current_user = postgres
```

Nunca incluir el secreto real, la full DB URL ni el query string construido para `--db-url`.

---

## 16. Runtime real de `supabase_auth_admin`

El archivo TASK-013 debe permanecer intacto.

Su transición existente:

```text
SET LOCAL ROLE supabase_auth_admin;
```

sólo puede continuar si el login inicial posee autoridad PostgreSQL para asumir ese role.

Bajo ALT-001 deben demostrarse tres estados:

```text
PROOF-A
session_user = supabase_admin
initial current_user = postgres

PROOF-B
after explicit SET ROLE + RESET ROLE
current_user restored = postgres

PROOF-C
SET LOCAL ROLE supabase_auth_admin = succeeds
current_user = supabase_auth_admin
T013-DB-066..072 executed = YES
```

`session_user` debe permanecer `supabase_admin` durante toda la conexión.

La prueba runtime se considera inequívoca sólo si simultáneamente:

1. `PROOF-A = PASS`;
2. `PROOF-B = PASS`;
3. T013-DB-001..065 mantienen baseline `current_user = postgres`, salvo los `SET ROLE` explícitos existentes;
4. el statement `SET LOCAL ROLE supabase_auth_admin` no produce error;
5. no ocurre `RESET ROLE` antes de completar T013-DB-066..072;
6. T013-DB-066..072 se emiten y pasan bajo `current_user = supabase_auth_admin`;
7. la suite termina con `finish()` y el plan 72 es satisfecho.

La evidencia final debe registrar `PROOF-A`, `PROOF-B` y `PROOF-C` sin credenciales.

Si la revisión no puede demostrar esa cadena de forma inequívoca a partir del output/test/log PostgreSQL sanitizado:

```text
BLOCKER — RUNTIME ROLE PROOF INSUFFICIENT
```

No añadir una assertion TAP de relleno, cambiar el plan 72 ni modificar TASK-013 para producir esa evidencia.

---

## 17. Contrato pgTAP de TASK-013

Debe permanecer exactamente:

```text
BEGIN
→ plan(72)
→ 72 assertions reales
→ finish()
→ ROLLBACK
```

Queda prohibido:

- reducir el plan;
- eliminar T013-DB-066..072;
- convertirlas en catálogo estático;
- duplicar assertions;
- añadir `pass()` de relleno;
- atrapar permission errors y convertirlos en PASS;
- cambiar expected semantics;
- omitir el `SET LOCAL ROLE supabase_auth_admin`;
- ejecutar T013-DB-001..065 accidentalmente como `supabase_admin` superuser;
- permitir que `RESET ROLE` restaure `supabase_admin` en lugar de `postgres`.

Contexto obligatorio:

```text
T013-DB-001..065 baseline current_user = postgres, salvo SET ROLE explícitos existentes
T013-DB-066..072 current_user = supabase_auth_admin
```

Resultado obligatorio:

```text
Files = 1
Tests = 72
failed assertions = 0
bad plan = NO
Result = PASS
```

---

## 18. Rollback, cleanup e interrupción

### 18.1 Propiedad de ALT-001

ALT-001 no crea ni modifica memberships de roles.

Por tanto:

```text
persistent role-topology mutation by CORR-023 = 0
role-membership cleanup required = 0
```

Esta propiedad es una razón material para preferir ALT-001 sobre ALT-003.

### 18.2 Transacción de tests

La suite TASK-013 debe conservar:

```text
BEGIN ... ROLLBACK
```

La ejecución mediante Supabase CLI/pg_prove debe conservar además el aislamiento transaccional del test.

Después de PASS o FAIL debe verificarse que los fixtures TASK-013 no persisten.

### 18.3 Interrupción

Ante `Ctrl+C`, timeout, crash del runner o error de subprocess:

- el wrapper debe detener la secuencia;
- no debe iniciar suites posteriores;
- debe liberar variables de conexión en su scope de proceso;
- no debe intentar “reparar” la DB;
- no debe hacer GRANT/REVOKE;
- no debe ejecutar cleanup destructivo fuera de la transacción de test;
- debe finalizar con exit code no cero.

Como ALT-001 no cambia role memberships, una interrupción no puede dejar membership residual creada por CORR-023.

### 18.4 Timeout

El runner debe aplicar límites explícitos:

```text
local-target proof subprocess timeout = 30 seconds por subprocess
single DB suite timeout = 300 seconds
TASK-015 concurrency suite timeout = 300 seconds
full CORR-023 runner timeout = 1800 seconds
```

Timeout produce:

```text
FAIL / BLOCKER
```

Nunca PASS parcial.

Los valores anteriores pertenecen exclusivamente al harness local y no constituyen requisitos de producto ni timeouts de producción.

---

## 19. Regression contract posterior a CORR-023

La ejecución futura debe comprobar todas las suites relevantes sin exclusiones silenciosas.

### 19.1 TASK-009

Debe permanecer:

```text
TASK-009 DB suite = PASS
TAP parse errors = 0
plan mismatch = 0
```

Usar su runner local ordinario vigente y path explícito.

### 19.2 TASK-010

Debe permanecer:

```text
TASK-010 DB suite = PASS
TAP parse errors = 0
plan mismatch = 0
```

Usar su runner local ordinario vigente y path explícito.

### 19.3 TASK-013

Debe utilizar ALT-001:

```text
npx supabase test db --db-url <LOCAL_SUPABASE_ADMIN_DB_URL> \
  supabase/tests/database/task_013_verification_challenge_foundation.test.sql
```

Resultado:

```text
72/72 PASS
```

### 19.4 TASK-014

Debe ejecutarse la suite DB canónica vigente de TASK-014 mediante su runner local ordinario y path explícito.

La futura implementación debe resolver su path exacto desde el repositorio real antes de escribir el runner.

Si la suite canónica TASK-014 no puede identificarse de forma única:

```text
BLOCKER
```

No usar glob que pueda omitir o incorporar archivos silenciosamente.

Resultado:

```text
TASK-014 DB suite = PASS
```

### 19.5 TASK-015 DB

Mientras el slice TASK-015 autorizado continúe en el worktree, debe ejecutarse explícitamente:

```text
supabase/tests/database/task_015_company_membership_lifecycle_audit_event_atomic.test.sql
```

Resultado requerido:

```text
TASK-015 plan = 81
TASK-015 executed = 81
TASK-015 failed = 0
TASK-015 DB = PASS
```

### 19.6 TASK-015 concurrency

Debe ejecutarse el harness concurrente existente:

```text
supabase/tests/database/task_015_company_membership_lifecycle_concurrency.test.ps1
```

Resultado requerido:

```text
T015-CON-001 = PASS
T015-CON-002 = PASS
T015-CON-003 = PASS
T015-CON-004 = PASS
T015-CON-005 = PASS
T015-CON-006 = PASS
```

### 19.7 Suite DB completa seleccionada

La regresión no debe utilizar un discovery indiscriminado de todos los `.sql` del directorio.

La lista debe ser explícita y revisable.

Los scripts TASK-009 no autónomos continúan fuera del Gate automático.

### 19.8 Repository-side regression

Después de DB/concurrency debe ejecutarse, conforme a los scripts reales vigentes:

```text
npm run test
npm run lint
npm run typecheck
npm run build
npm run verify
git diff --check
```

Si un script no existe en el repo real, no se inventa.

Debe reportarse:

```text
NOT APPLICABLE / SCRIPT ABSENT IN CURRENT REPO
```

sólo después de inspección física.

Un script existente que falle por la corrección:

```text
BLOCKER
```

---

## 20. Reconstrucción local

La evidencia final de CORR-023 debe partir de una base local reproducible desde migrations versionadas.

Debe demostrarse que el estado local contiene las migrations aplicables vigentes de TASK-009..TASK-015 conforme al slice actual autorizado.

Cuando el Revisor Central autorice una reconstrucción:

```text
npx supabase db reset
```

sólo puede ejecutarse contra Supabase Local.

Nunca:

```text
--linked
remote db reset
manual Dashboard SQL
```

CORR-023 no autoriza esa ejecución durante la generación de esta specification.

Si la regresión sólo pasa gracias a SQL manual posterior al reset:

```text
BLOCKER
```

---

## 21. Seguridad, multitenancy y RLS

CORR-023 debe ser semánticamente neutra respecto de autorización productiva.

Debe permanecer:

```text
tenant = MaintenanceCompany
RLS = UNCHANGED
CompanyMembership model = UNCHANGED
SupportAccessGrant = UNCHANGED
Client scope = UNCHANGED
Auth claims authority = UNCHANGED
supabase_auth_admin tenant privileges = NO
```

El runner privilegiado local no puede convertirse en evidencia de que `supabase_admin` o `supabase_auth_admin` deban usarse como actor de aplicación.

Debe distinguirse:

```text
local test runner privilege
!=
product authorization
```

No se introduce ninguna policy nueva.

No se modifica ninguna policy existente.

No se modifica ningún GRANT/REVOKE productivo.

---

## 22. UI, PWA y offline

```text
UI impact = NONE
PWA impact = NONE
offline behavior impact = NONE
Dexie impact = NONE
Service Worker impact = NONE
```

CORR-023 no diseña ni modifica UI u offline.

---

## 23. Preflight futuro obligatorio

Antes de modificar el único path autorizado, la ejecución futura deberá verificar:

```text
repo root
branch
HEAD
origin/main
divergence
staged
tracked unstaged
untracked
Git operation in progress
```

Además debe:

1. verificar las identidades físicas de Source A y Source B;
2. releer TASK-013, ADR-0019 y CORR-017 canónicos;
3. inspeccionar `package.json` y scripts vigentes sin modificarlos;
4. inspeccionar `supabase/config.toml`;
5. identificar la suite DB canónica TASK-014 vigente;
6. verificar que el slice TASK-015 esperado continúa intacto;
7. confirmar Supabase CLI `2.114.0` mientras esa siga siendo la versión fijada por el repo;
8. confirmar que no existe ya otro runner CORR-023 equivalente;
9. confirmar que el path a crear no colisiona con un archivo existente distinto.

Operaciones Git prohibidas durante preflight:

```text
git pull
git merge
git rebase
git reset
git restore
git stash
git clean
git add
git commit
git push
```

Drift material:

```text
BLOCKER
```

No autoreparar el worktree.

---

## 24. Cambios esperados de futura implementación

### 24.1 Objetivo para Codex

Crear exclusivamente el runner local versionado de CORR-023 que implemente ALT-001, Local Target Proof y el regression contract de esta specification.

### 24.2 Contexto

La producción TASK-013 está cerrada y no es la causa del fallo.

El único defecto es que el login canónico `postgres` no puede asumir `supabase_auth_admin`; ALT-001 debe usar `session_user = supabase_admin` como autoridad técnica mientras preserva `baseline current_user = postgres` y sólo transiciona a `supabase_auth_admin` para T013-DB-066..072.

### 24.3 Alcance

```text
CREATE ONLY:
supabase/tests/database/corr_023_local_db_regression.ps1
```

### 24.4 Fuera de alcance

```text
TASK-013 test modification
TASK-013 migration modification
product SQL
RLS
policies
grants
role memberships
src/**
package.json
package-lock.json
config.toml
docs/**
Cloud
Hosted
Git staging/commit/push
```

### 24.5 Seguridad/RLS

El script sólo obtiene y utiliza una credencial local en memoria después del proof local fail-closed y debe construir `options = -c role=postgres` con percent-encoding correcto para preservar el baseline efectivo `postgres`.

No modifica privilegios de DB.

### 24.6 Criterio de ejecución

Una implementación que requiera cualquier path adicional:

```text
BLOCKER / RETURN FOR REVIEW
```

---

## 25. Criterios de aceptación

Cada criterio debe clasificarse individualmente como `PASS`, `FAIL` o `BLOCKER`.

**AC-023-001.** CORR-023 permanece exclusivamente `TEST HARNESS / REGRESSION CORRECTION`.

**AC-023-002.** Product decision nueva = `NO`.

**AC-023-003.** Domain decision nueva = `NO`.

**AC-023-004.** Architecture decision nueva = `NO` y ADR nuevo = `NO`.

**AC-023-005.** La única estrategia física seleccionada es ALT-001.

**AC-023-006.** ALT-002 no se ejecuta ni se implementa automáticamente.

**AC-023-007.** ALT-003 permanece prohibida para CORR-023.

**AC-023-008.** El target local se prueba mediante `supabase/config.toml`, Supabase Local status, endpoint loopback exacto y binding Docker consistente.

**AC-023-009.** El host efectivo del DB URL aceptado es `127.0.0.1`.

**AC-023-010.** El puerto efectivo coincide exactamente con `[db].port` del `supabase/config.toml` vigente.

**AC-023-011.** No se acepta `--linked`, hostname remoto, project ref remoto ni DB URL suministrado por caller como sustituto del proof local.

**AC-023-012.** Si el target local no puede demostrarse inequívocamente, el runner falla antes de utilizar `supabase_admin`.

**AC-023-013.** La conexión local se obtiene sin hardcodear password, key o connection string.

**AC-023-014.** El DB URL local sensible se mantiene sólo en memoria del proceso.

**AC-023-015.** Password, DB URL completo, JWT secret, service-role key y otros secretos no aparecen en stdout, stderr, logs, diff ni artefactos de evidencia.

**AC-023-016.** La conexión TASK-013 demuestra `session_user = supabase_admin` e `initial current_user = postgres` mediante connection-time/default role `postgres` correctamente percent-encoded.

**AC-023-017.** `SET LOCAL ROLE service_role` continúa funcionando; su `RESET ROLE` restaura `current_user = postgres`, y T013-DB-001..065 no adquieren privilegios `supabase_admin` salvo sus `SET ROLE` explícitos existentes.

**AC-023-018.** `SET LOCAL ROLE supabase_auth_admin` requerido por la suite funciona localmente desde `session_user = supabase_admin`.

**AC-023-019.** La cadena demuestra `PROOF-A`, `PROOF-B` y `PROOF-C`, incluyendo `current_user = supabase_auth_admin` durante T013-DB-066..072 conforme a §16.

**AC-023-020.** `task_013_verification_challenge_foundation.test.sql` permanece byte-for-byte intacto.

**AC-023-021.** El plan TASK-013 permanece exactamente `72`.

**AC-023-022.** No se elimina, reduce, duplica ni rellena ninguna assertion TASK-013.

**AC-023-023.** T013-DB-001..072 se ejecutan.

**AC-023-024.** T013-DB-001..072 pasan con `failed = 0`.

**AC-023-025.** T013-DB-066 = `PASS`.

**AC-023-026.** T013-DB-067 = `PASS`.

**AC-023-027.** T013-DB-068 = `PASS`.

**AC-023-028.** T013-DB-069 = `PASS`.

**AC-023-029.** T013-DB-070 = `PASS`.

**AC-023-030.** T013-DB-071 = `PASS`.

**AC-023-031.** T013-DB-072 = `PASS`.

**AC-023-032.** TASK-013 produce `Files = 1`, `Tests = 72`, `bad plan = NO`, `Result = PASS`.

**AC-023-033.** `SECURITY INVOKER` del Custom Access Token Hook permanece sin cambios.

**AC-023-034.** La migration `20260830010000_task_013_verification_challenge_foundation.sql` permanece byte-for-byte intacta.

**AC-023-035.** Production grants de `supabase_auth_admin` permanecen sin cambios.

**AC-023-036.** Production RLS/policies de TASK-013 permanecen sin cambios.

**AC-023-037.** `supabase_auth_admin tenant privileges = NO` continúa demostrado.

**AC-023-038.** CORR-023 no crea ni modifica role memberships locales persistentes.

**AC-023-039.** Después de PASS o FAIL no existe membership residual causada por CORR-023.

**AC-023-040.** Los fixtures transaccionales TASK-013 no persisten después de la ejecución.

**AC-023-041.** TASK-009 DB suite = `PASS`.

**AC-023-042.** TASK-010 DB suite = `PASS`.

**AC-023-043.** TASK-014 DB suite = `PASS`.

**AC-023-044.** TASK-015 DB suite = `81/81 PASS`.

**AC-023-045.** T015-CON-001..006 = `PASS` mediante concurrencia real conforme a su harness.

**AC-023-046.** No se ejecutan automáticamente los scripts históricos TASK-009 Auth-delete.

**AC-023-047.** Todos los paths DB autónomos del Gate se enumeran explícitamente; no se usa glob indiscriminado.

**AC-023-048.** Full local DB regression = `PASS`.

**AC-023-049.** `npm run test = PASS` cuando el script exista.

**AC-023-050.** `npm run lint = PASS` cuando el script exista.

**AC-023-051.** `npm run typecheck = PASS` cuando el script exista.

**AC-023-052.** `npm run build = PASS` cuando el script exista.

**AC-023-053.** `npm run verify = PASS` cuando el script exista.

**AC-023-054.** `git diff --check = PASS`.

**AC-023-055.** Nuevas dependencias = `0`.

**AC-023-056.** El diff de CORR-023 contiene exactamente el runner autorizado y ningún otro path causado por CORR-023.

**AC-023-057.** `package.json` y `package-lock.json` permanecen sin cambios.

**AC-023-058.** `supabase/config.toml` permanece sin cambios.

**AC-023-059.** `src/**` permanece sin cambios por CORR-023.

**AC-023-060.** `docs/**` permanece sin cambios durante la implementación técnica de CORR-023.

**AC-023-061.** Supabase Cloud mutation = `NO`.

**AC-023-062.** Hosted Development mutation = `NO`.

**AC-023-063.** Staging mutation = `NO`.

**AC-023-064.** Production mutation = `NO`.

**AC-023-065.** `git add = NO`, `commit = NO`, `push = NO` durante la ejecución técnica de CORR-023.

**AC-023-066.** El worktree preexistente de TASK-015 se preserva sin reset, restore, stash, clean ni edición accidental.

**AC-023-067.** CORR-023 no cambia la implementación de TASK-015.

**AC-023-068.** TASK-015 specific local tests continúan pasando.

**AC-023-069.** TASK-015 continúa `NOT DONE` después de una implementación técnica PASS de CORR-023.

**AC-023-070.** Hosted Development de TASK-015 continúa requiriendo Gate humano separado después del cierre de CORR-023.

**AC-023-071.** La relación con CORR-017 queda clasificada como `B` y no se reescribe su historia.

**AC-023-072.** El historical `65/65 PASS` permanece distinguido del current `72/72 runtime proof`.

**AC-023-073.** No se afirma evidencia histórica `72/72` inexistente.

**AC-023-074.** Timeout o interrupción produce exit no cero y no deja role membership residual.

**AC-023-075.** Una incompatibilidad real de ALT-001 produce `BLOCKER`, no fallback automático.

**AC-023-076.** El runner no convierte `supabase_admin` en client de aplicación ni config productiva.

**AC-023-077.** El runner no ejecuta SQL de reparación, GRANT, REVOKE o mutation de role topology.

**AC-023-078.** Repository mutation causada por la generación de esta specification = `NO`.

Control:

```text
AC count = 78
AC range = AC-023-001..AC-023-078
AC consecutive = YES
```

---

## 26. Definition of Done

CORR-023 sólo podrá considerarse `DONE` cuando se satisfagan todos los siguientes puntos mediante Gates separados y evidencia física:

**DoD-023-001.** Esta specification obtiene revisión técnica del Revisor Central.

**DoD-023-002.** `CORR-023 SPEC REVIEW = APPROVED`.

**DoD-023-003.** Existe aprobación humana formal de la specification.

**DoD-023-004.** La specification aprobada queda canonicalizada mediante Gate separado.

**DoD-023-005.** La canonicalización queda revisada y aprobada.

**DoD-023-006.** La specification canónica queda incorporada a Git sólo mediante Gate separado.

**DoD-023-007.** Existe autorización humana separada de implementación de CORR-023.

**DoD-023-008.** Preflight Git fresco = `PASS`.

**DoD-023-009.** Source A identity = `PASS`.

**DoD-023-010.** Source B identity = `PASS`.

**DoD-023-011.** Local Target Proof = `PASS`.

**DoD-023-012.** ALT-001: `session_user = supabase_admin` y baseline `current_user = postgres` = `PASS`.

**DoD-023-013.** `RESET ROLE` restoration = `postgres` y runtime `SET LOCAL ROLE supabase_auth_admin` = `PASS`.

**DoD-023-014.** T013-DB-001..072 = `72/72 PASS`.

**DoD-023-015.** T013-DB-066..072 = `PASS`.

**DoD-023-016.** TASK-009 DB = `PASS`.

**DoD-023-017.** TASK-010 DB = `PASS`.

**DoD-023-018.** TASK-014 DB = `PASS`.

**DoD-023-019.** TASK-015 DB = `81/81 PASS`.

**DoD-023-020.** T015-CON-001..006 = `PASS`.

**DoD-023-021.** Full local DB regression = `PASS`.

**DoD-023-022.** Repository-side quality regressions aplicables = `PASS`.

**DoD-023-023.** `git diff --check = PASS`.

**DoD-023-024.** Production migration drift = `NONE`.

**DoD-023-025.** Production grants/RLS/policies drift = `NONE`.

**DoD-023-026.** Secret leakage = `NONE`.

**DoD-023-027.** Residual local role/membership mutation caused by CORR-023 = `NONE`.

**DoD-023-028.** Implementation diff contiene únicamente el path autorizado.

**DoD-023-029.** Central implementation review = `APPROVED`.

**DoD-023-030.** Una revisión humana separada confirma que CORR-023 puede cerrarse.

**DoD-023-031.** Cierre Git, si posteriormente se autoriza, ocurre mediante Gates separados de staging/commit/push.

**DoD-023-032.** El cierre de CORR-023 devuelve el control al Revisor Central para `TASK-015 IMPLEMENTATION RE-REVIEW`.

Debe permanecer:

```text
CORR-023 IMPLEMENTATION PASS
!=
CORR-023 DONE

CORR-023 DONE
!=
TASK-015 DONE

CORR-023 DONE
!=
Hosted Development authorization
```

Control:

```text
DoD count = 32
DoD range = DoD-023-001..DoD-023-032
DoD consecutive = YES
```

---

## 27. Blockers estrictos

La implementación debe detenerse y volver al Revisor Central ante cualquiera de los siguientes casos.

### 27.1 Fuentes / Git

```text
Source A SHA mismatch
Source B SHA mismatch
required canonical source unavailable
repository material drift
unexpected staged content
unexpected Git operation in progress
runner path collision
```

### 27.2 ALT-001 / local target

```text
Supabase CLI required version unavailable
--db-url behavior incompatible with discovery
Supabase Local stack not running
db.port cannot be resolved
status DB URL cannot be obtained safely
host is not exactly proven local
port does not match config
Docker binding cannot be proven
connection-time role cannot be established safely
connection URI options cannot be encoded safely
session_user != supabase_admin
baseline current_user != postgres
RESET ROLE restores supabase_admin instead of postgres
supabase_admin authentication fails
runner cannot SET ROLE service_role
runner cannot SET ROLE supabase_auth_admin
T013-DB-001..065 require execution as supabase_admin superuser
runtime current_user for T013-DB-066..072 != supabase_auth_admin
```

Cualquier incompatibilidad de ALT-001 exige evidencia física.

No declarar ALT-001 inviable por preferencia de implementación.

### 27.3 Producción / seguridad

```text
TASK-013 migration modification required
SECURITY DEFINER required for TASK-013 hook
production GRANT expansion required
production policy/RLS change required
postgres → supabase_auth_admin production membership required
supabase_auth_admin tenant access required
remote DB required
Hosted/Cloud required
secret must be persisted or printed
```

### 27.4 Tests

```text
T013-DB-066..072 cannot execute faithfully
plan 72 must be reduced
assertion semantics must change
runtime role proof cannot be established
TASK-009 regression fails unexplained
TASK-010 regression fails unexplained
TASK-014 regression fails unexplained
TASK-015 81/81 fails unexplained
TASK-015 concurrency fails unexplained
full local DB regression fails unexplained
```

### 27.5 Tooling / scope

```text
new dependency required
package.json change required
package-lock.json change required
TASK-013 test modification required
config.toml modification required
src/ modification required
additional versioned path required
```

Un blocker no puede resolverse:

- debilitando tests;
- ocultando failures;
- ampliando scope;
- cambiando producción;
- usando Cloud;
- creando una nueva decisión arquitectónica implícita.

---

## 28. Evidencia mínima de futura ejecución

La revisión de implementación debe recibir, sin secretos:

```text
Git preflight
source hashes
Supabase CLI version
local target proof summary
sanitized local endpoint = 127.0.0.1:<port>
PROOF-A session_user = supabase_admin
PROOF-A baseline current_user = postgres
PROOF-B current_user restored after RESET ROLE = postgres
PROOF-C runtime current_user = supabase_auth_admin
PROOF-C T013-DB-066..072 executed = YES
TASK-013 plan/executed/failed/result
T013-DB-066..072 individual result
TASK-009 result
TASK-010 result
TASK-014 result
TASK-015 81/81 result
T015-CON-001..006 result
repository-side regression results
git diff --check
changed paths
staged state
Cloud/Hosted/Staging/Production state
secret leakage review
post-run fixture/cleanup verification
```

No incluir:

```text
DB password
full DB URL
JWT secret
service-role key
Supabase secret key
technical password
access token
refresh token
```

---

## 29. Gate posterior

Una futura ejecución que obtenga:

```text
CORR-023 IMPLEMENTATION EXECUTION = PASS
```

no autoriza automáticamente ninguna acción posterior.

Secuencia requerida:

```text
1. CORR-023 implementation review by Revisor Central
2. human approval of implementation
3. separate Git staging Gate when authorized
4. staged diff review
5. separate commit Gate
6. separate push Gate
7. origin/main verification
8. CORR-023 final human closure
9. TASK-015 IMPLEMENTATION RE-REVIEW
```

Sólo después de cerrar CORR-023 y verificar full local regression puede el Revisor Central reevaluar el Gate de Hosted Development de TASK-015.

Debe permanecer:

```text
CORR-023 closed
!=
TASK-015 Hosted Development authorized
```

---

## 30. Estado resultante de esta specification

```text
CORR-023 DETERMINATION = APPROVED
CORR-023 DISCOVERY = PASS
CORR-023 DISCOVERY REVIEW = APPROVED
CORR-023 SPECIFICATION GENERATION GATE = AUTHORIZED

CORR-023 selected strategy = ALT-001
CORR-017 relationship = B
additional documentation sync = NOT REQUIRED BY DEFAULT

CORR-023 SPECIFICATION = APPROVED

CORR-023 SPEC REVIEW = RETURNED FOR MINIMAL CORRECTION

CORR-023 SPECIFICATION CORRECTION = READY FOR RE-REVIEW

CORR-023 SPEC RE-REVIEW = APPROVED
CORR-023 SPEC REVIEW FINAL = APPROVED
CORR-023 HUMAN SPEC APPROVAL = APPROVED

CORR-023 APPROVED ARTIFACT REVIEW = RETURNED FOR MINIMAL CORRECTION
approved artifact correction class = APPROVED ARTIFACT FILENAME IDENTITY DRIFT
CORR-023 APPROVED ARTIFACT CORRECTION = READY FOR RE-REVIEW
CORR-023 APPROVED ARTIFACT RE-REVIEW = APPROVED
CORR-023 APPROVED ARTIFACT REVIEW FINAL = APPROVED

CORR-023 CANONICALIZATION GATE = AUTHORIZED
CORR-023 CANONICALIZATION = READY FOR REVIEW
CORR-023 canonicalized = YES — PENDING CANONICAL ARTIFACT REVIEW
CORR-023 implementation authorized = NO
CORR-023 implementation = NOT STARTED

Codex authorized = NO
repository modification authorized = NO
SQL execution authorized = NO
migration authorized = NO
RLS modification authorized = NO

Supabase Cloud = NO CHANGE
Hosted Development = NO CHANGE
Staging = NO CHANGE
Production = NO CHANGE

git add = NO
commit = NO
push = NO

TASK-013 reopening = NO
TASK-015 implementation change = NO
TASK-015 DONE = NO
TASK-016 = NOT DETERMINED / NOT GENERATED / NOT STARTED
```

El siguiente acto válido es:

```text
RETURN TO REVISOR CENTRAL
→ CORR-023 CANONICAL ARTIFACT REVIEW
```

No corresponde todavía:

```text
CORR-023 implementation
Codex
runner creation in repository
SQL execution
Supabase Local mutation
Supabase Cloud
Hosted Development
Staging
Production
git add
commit
push
TASK-015 Hosted Gate
TASK-016
```

---

## 31. Autoverificación de la generación

```text
filename =
CORR-023-task-013-local-db-regression-runner-supabase-auth-admin.md

title exact = YES

correction type = TEST HARNESS / REGRESSION CORRECTION
production capability change = NO
product decision = NO
domain decision = NO
architecture decision = NO
new ADR required = NO

selected alternative = ALT-001
ALT-002 selected = NO
ALT-003 selected = NO

CORR-017 relationship = B
historical 65/65 preserved = YES
historical 72/72 invented = NO

LOCAL TARGET PROOF defined = YES
fail-closed remote prevention = YES
no hardcoded secrets = YES
secret output prohibited = YES
connection-time role = postgres
connection URI options percent-encoding required = YES
PROOF-A session_user/baseline current_user defined = YES
PROOF-B RESET ROLE restoration defined = YES
PROOF-C runtime supabase_auth_admin defined = YES
runtime role proof defined = YES

TASK-013 plan = 72
T013-DB-066..072 preserved = YES
TASK-013 test modification authorized = NO
TASK-013 migration modification authorized = NO
SECURITY INVOKER preserved = YES
production grants/RLS preserved = YES

full local DB regression defined = YES
TASK-009 = required PASS
TASK-010 = required PASS
TASK-014 = required PASS
TASK-015 = required 81/81 PASS
T015-CON-001..006 = required PASS

UI = NONE
offline = NONE
Cloud = NO
Hosted = NO
Staging = NO
Production = NO

AC range = AC-023-001..AC-023-078
DoD range = DoD-023-001..DoD-023-032

CORR-023 APPROVED ARTIFACT REVIEW FINAL = APPROVED
CORR-023 CANONICALIZATION = READY FOR REVIEW
CORR-023 canonicalized = YES — PENDING CANONICAL ARTIFACT REVIEW
canonical repository path = docs/tasks/CORR-023-task-013-local-db-regression-runner-supabase-auth-admin.md

implementation authorized = NO
repository mutation during generation = NO
```

---

## 32. Resultado formal

```text
CORR-023 SPECIFICATION CORRECTION = READY FOR RE-REVIEW
CORR-023 SPEC RE-REVIEW = APPROVED
CORR-023 SPEC REVIEW FINAL = APPROVED
CORR-023 HUMAN SPEC APPROVAL = APPROVED
CORR-023 APPROVED ARTIFACT REVIEW FINAL = APPROVED
CORR-023 CANONICALIZATION = READY FOR REVIEW
CORR-023 CANONICAL ARTIFACT = READY FOR REVIEW
CORR-023 canonicalized = YES — PENDING CANONICAL ARTIFACT REVIEW

selected physical strategy = ALT-001

scope =
LOCAL TEST HARNESS ONLY

production migration change = NO
production RLS/grants/policies change = NO
TASK-013 production change = NO
TASK-015 implementation change = NO
new ADR = NO

next action =
RETURN TO REVISOR CENTRAL FOR CORR-023 CANONICAL ARTIFACT REVIEW
```

**FIN DE CORR-023 CANONICAL ARTIFACT**
