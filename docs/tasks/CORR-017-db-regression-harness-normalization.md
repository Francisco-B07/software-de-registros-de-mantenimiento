# CORR-017 — Normalización del harness de regresión DB heredado de TASK-009/TASK-010

## 1. Identificación

```
```

```
ID: CORR-017

Título:
Normalización del harness de regresión DB heredado de TASK-009/TASK-010

Tipo:
Corrección técnica acotada de infraestructura de pruebas

Fase:
Fase 2

Área:
Supabase local / PostgreSQL / pgTAP / regresión DB

Estado:
APPROVED FOR IMPLEMENTATION

Implementación autorizada:
NO

Canonicalización autorizada:
NO

Supabase Cloud mutation:
NO

Staging / commit / push:
NO

TASK-013:
BLOCKED pendiente de CORR-017

TASK-014 determinada:
NO

TASK-014 generada:
NO
```

---

## 2. Objetivo

Corregir exclusivamente la incompatibilidad entre el harness heredado de pruebas DB de TASK-009/TASK-010 y el runner oficial `supabase test db`, de manera que exista una regresión DB local reproducible y válida bajo pgTAP.

La corrección NO debe modificar:

-  arquitectura;
-  dominio;
-  migrations funcionales;
-  schema;
-  RLS;
-  policies;
-  grants/revokes;
-  permisos;
-  semántica de autorización;
-  semántica de AuditEvent;
-  comportamiento funcional previamente aprobado;
-  implementación abierta de TASK-013.

Resultado requerido:

```
```

```
existing TASK-009/TASK-010 DB suites remain passing
=
demostrable de forma reproducible antes de continuar TASK-013
```

---

## 3. Contexto y causa

Durante la implementación autorizada de TASK-013 se obtuvo:

```
```

```
TASK-013 dedicated DB suite = PASS

Files = 1
Tests = 65
Result = PASS
```

La reconstrucción DB local aplicó correctamente:

```
```

```
20260825234939 — TASK-009
20260826190408 — TASK-010
20260830010000 — TASK-013
```

Sin embargo, la ejecución indiscriminada de todos los SQL encontrados por `supabase test db` produjo:

```
```

```
TASK-009 setup      → No plan found in TAP output
TASK-009 verify     → No plan found in TAP output
TASK-009 foundation → No plan found in TAP output
TASK-010 foundation → No plan found in TAP output
TASK-013            → ok
```

Codex se detuvo correctamente porque corregir archivos de TASK-009/TASK-010 estaba fuera del scope de TASK-013.

---

## 4. Contradicción detectada

No existen cuatro suites pgTAP equivalentes.

Estos dos artefactos:

```
```

```
supabase/tests/database/task_009_auth_delete_setup.sql
supabase/tests/database/task_009_auth_delete_verify.sql
```

son scripts operativos históricos de un flujo:

```
```

```
setup
→ intervención humana
→ eliminación del Auth subject descartable
  mediante mecanismo oficial soportado
→ verify
```

No constituyen suites autónomas ejecutables correctamente mediante `pg_prove`.

Por tanto queda prohibido:

```
```

```
convertir ambos artificialmente a pgTAP
simular la eliminación provider-side con DELETE SQL directo
eliminar el paso humano histórico
hacerlos PASS mediante assertions vacías
marcarlos como suites automatizadas
```

CORR-017 debe preservar su semántica exactamente.

---

## 5. Fuentes normativas

La futura ejecución debe releer íntegramente como mínimo:

```
```

```
docs/tasks/TASK-009-identity-tenant-foundation.md
docs/tasks/TASK-010-audit-event-foundation.md
docs/tasks/TASK-013-verification-challenge-foundation.md

docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md
```

Y estos artefactos físicos:

```
```

```
supabase/migrations/20260825234939_task_009_identity_tenant_foundation.sql
supabase/migrations/20260826190408_task_010_audit_event_foundation.sql

supabase/tests/database/task_009_identity_tenant_foundation.test.sql
supabase/tests/database/task_009_auth_delete_setup.sql
supabase/tests/database/task_009_auth_delete_verify.sql
supabase/tests/database/task_010_audit_event_foundation.test.sql

tests/task-009-migration.test.ts
tests/task-010-migration.test.ts
```

También debe verificarse mediante documentación oficial la semántica vigente de:

```
```

```
supabase test db
pg_prove
pgTAP
plan(...)
finish()
múltiples paths explícitos en supabase test db
```

Si la CLI fijada por el repositorio contradice lo esperado:

```
```

```
BLOCKER
```

No se actualizará la dependencia para resolverlo.

---

## 6. Baseline Supabase CLI

Versión verificada:

```
```

```
npx supabase --version
2.114.0
```

Debe utilizarse exclusivamente:

```
```

```
npx supabase ...
```

Prohibido sustituirla por la instalación global histórica.

```
```

```
package.json = NO CHANGE
package-lock.json = NO CHANGE
new dependencies = 0
```

---

## 7. Decisión de corrección

### 7.1 Regresión DB automatizada

El Gate automatizado local debe ejecutar explícitamente sólo las suites autónomas:

```
```

```
supabase/tests/database/task_009_identity_tenant_foundation.test.sql
supabase/tests/database/task_010_audit_event_foundation.test.sql
supabase/tests/database/task_013_verification_challenge_foundation.test.sql
```

Comando normativo para este Gate:

```
```

```
npx supabase test db supabase/tests/database/task_009_identity_tenant_foundation.test.sql supabase/tests/database/task_010_audit_event_foundation.test.sql supabase/tests/database/task_013_verification_challenge_foundation.test.sql
```

Para este Gate queda prohibido usar como prueba concluyente:

```
```

```
npx supabase test db
```

sin paths explícitos, porque el directorio histórico también contiene scripts operativos no autónomos.

### 7.2 Auth-delete TASK-009

Estos archivos permanecen intactos:

```
```

```
task_009_auth_delete_setup.sql
task_009_auth_delete_verify.sql
```

No son parte del Gate automatizado de CORR-017.

Su verificación histórica no se sustituye ni se reabre.

### 7.3 Suite TASK-009 autónoma

Debe convertirse:

```
```

```
task_009_identity_tenant_foundation.test.sql
```

en pgTAP válido manteniendo toda su cobertura actual.

Debe admitir dos modalidades:

```
```

```
A. ejecución con:
task_009_user_a_id
task_009_user_b_id
task_009_user_c_id

→ utilizar esos subjects existentes

B. ejecución local sin variables

→ crear exclusivamente fixtures Auth locales
  descartables dentro de la transacción
```

Los fixtures del modo B deben:

```
```

```
ser exclusivamente de test
usar UUIDs inequívocos
no usar clientes reales
no usar usuarios reales
no requerir Auth Admin
no requerir service-role
no requerir Cloud
no modificar schema auth
no persistir
quedar eliminados mediante ROLLBACK
```

Las assertions RLS deben continuar ejecutándose bajo:

```
```

```
role = authenticated
```

nunca bajo un rol con `BYPASSRLS`.

### 7.4 Suite TASK-010

Debe convertirse:

```
```

```
task_010_audit_event_foundation.test.sql
```

a pgTAP real preservando 1:1 sus verificaciones de:

```
```

```
integridad
CHECK constraints
FK
RLS
zero functional policies
privilegios
SELECT denied
INSERT denied
UPDATE denied
DELETE denied
TRUNCATE denied
inmutabilidad / fail-closed
```

La migration de TASK-010 no se modifica para acomodar el test.

---

## 8. Contrato pgTAP

Las dos suites modificadas deben seguir:

```
```

```
BEGIN
→ plan(N)
→ N assertions reales
→ finish()
→ ROLLBACK
```

`N` debe coincidir con el número real de assertions.

Prohibido utilizar:

```
```

```
pass() de relleno
assertions duplicadas para completar el plan
checks que sólo comprueben que el runner funciona
silenciar tests negativos
catch-all que transforme cualquier fallo en PASS
```

Deben utilizarse primitivas pgTAP adecuadas según cada caso, como:

```
```

```
ok
is
isnt
results_eq
results_ne
lives_ok
throws_ok
has_table
has_column
```

sin modificar el resultado funcional esperado.

Las denegaciones de permisos deben continuar siendo denegaciones reales de PostgreSQL.

---

## 9. Alcance exacto

### Archivos autorizados para modificación

Exclusivamente:

```
```

```
supabase/tests/database/task_009_identity_tenant_foundation.test.sql

supabase/tests/database/task_010_audit_event_foundation.test.sql
```

### Read-only obligatorio

```
```

```
supabase/tests/database/task_009_auth_delete_setup.sql
supabase/tests/database/task_009_auth_delete_verify.sql

supabase/migrations/20260825234939_task_009_identity_tenant_foundation.sql
supabase/migrations/20260826190408_task_010_audit_event_foundation.sql

tests/task-009-migration.test.ts
tests/task-010-migration.test.ts

todos los archivos actualmente pertenecientes
al slice abierto de TASK-013
```

Si es necesario modificar cualquier otro path:

```
```

```
BLOCKER / RETURN FOR REVIEW
```

No ampliar scope automáticamente.

---

## 10. Fuera de alcance

```
```

```
migration nueva = NO
migration edit = NO
schema change = NO

RLS change = NO
policy change = NO
grant/revoke change = NO

config.toml = NO CHANGE
Auth configuration = NO CHANGE

package.json = NO CHANGE
package-lock.json = NO CHANGE
dependency install = NO

application code = NO
UI = NO
offline = NO
Storage = NO
Realtime = NO
Edge Functions = NO

ADR-0019 = NO CHANGE
TASK-013 = NO CHANGE
TASK-014 = NO

Cloud = NO
Staging = NO
Production = NO
```

Tampoco se mueven, renombran o eliminan los dos scripts Auth-delete.

---

## 11. Arquitectura

```
```

```
architecture change = NO
ADR required = NO
```

CORR-017 es una corrección del harness de pruebas existente.

Si aparece necesidad de:

```
```

```
nuevo framework
nuevo test runner
nuevo servicio
nuevo auth model
nuevo bypass
nueva frontera privilegiada
```

resultado:

```
```

```
BLOCKER
```

---

## 12. Seguridad y RLS

Se mantienen sin modificación:

```
```

```
tenant = MaintenanceCompany

authenticated != authorized

RLS = primary remote data boundary

current authoritative DB state
>
stale session / stale claims

fail closed
```

### TASK-009

No puede eliminarse ni relajarse cobertura de:

```
```

```
cross-tenant isolation
disabled membership
current role authoritative
stale role claim denied
subject without membership denied
normal writes denied
```

Las mutaciones necesarias para test setup pueden ejecutarse antes de adoptar el rol sometido a prueba.

### TASK-010

Debe mantenerse:

```
```

```
audit_events RLS = ENABLED

functional policies = 0

anon table privileges = NONE

authenticated table privileges = NONE

TRUNCATE = DENIED
```

### Datos

```
```

```
real customer data used = NO
real tenant data used = NO
real credentials used = NO
Cloud secrets used = NO
```

---

## 13. UI y offline

```
```

```
UI = NO APLICA
Offline = NO APLICA
```

No se modifica ADR-0004 ni ninguna superficie de sincronización.

---

## 14. Supabase Cloud

```
```

```
Supabase Cloud mutation = PROHIBIDA
```

No ejecutar:

```
```

```
db push
--linked
migration repair
remote db reset
Dashboard SQL
remote Auth Admin
remote service-role
```

Los scripts Auth-delete históricos tampoco se ejecutan contra Cloud durante CORR-017.

---

## 15. Preflight futuro de Codex

La ejecución futura deberá comenzar verificando:

```
```

```
repo root
branch = main

HEAD
origin/main
divergence = 0 0

staged = NONE
Git operation in progress = NONE
```

El worktree **no se espera limpio**, porque TASK-013 mantiene cambios unstaged.

Codex deberá:

```
```

```
inventariar íntegramente el slice TASK-013 existente
preservarlo
no editarlo
no resetearlo
no restaurarlo
no stashearlo
no limpiarlo
```

Cualquier drift adicional no esperado:

```
```

```
BLOCKER
```

Prohibidos:

```
```

```
pull
merge
rebase
reset
restore
stash
clean
autorepair
```

---

## 16. Reconstrucción DB

La validación debe demostrar una reconstrucción local desde migrations versionadas.

Requerido:

```
```

```
TASK-009 migration = APPLIED
TASK-010 migration = APPLIED
TASK-013 migration = APPLIED
```

No debe depender de SQL manual posterior.

Puede utilizarse:

```
```

```
npx supabase db reset
```

contra el proyecto local.

Nunca:

```
```

```
--linked
```

---

## 17. Pruebas obligatorias

### TASK-009 individual

```
```

```
npx supabase test db supabase/tests/database/task_009_identity_tenant_foundation.test.sql
```

Esperado:

```
```

```
Result: PASS
TAP parse errors = 0
plan mismatch = 0
```

### TASK-010 individual

```
```

```
npx supabase test db supabase/tests/database/task_010_audit_event_foundation.test.sql
```

Esperado:

```
```

```
Result: PASS
TAP parse errors = 0
plan mismatch = 0
```

### TASK-013 control

Sin modificar TASK-013:

```
```

```
npx supabase test db supabase/tests/database/task_013_verification_challenge_foundation.test.sql
```

Debe permanecer:

```
```

```
Files = 1
Tests = 65
Result = PASS
```

### Regresión conjunta

```
```

```
npx supabase test db supabase/tests/database/task_009_identity_tenant_foundation.test.sql supabase/tests/database/task_010_audit_event_foundation.test.sql supabase/tests/database/task_013_verification_challenge_foundation.test.sql
```

Resultado obligatorio:

```
```

```
all selected files = ok
Result = PASS
TAP parse errors = 0
plan mismatch = 0
```

Además, verificar que NO fueron ejecutados accidentalmente:

```
```

```
task_009_auth_delete_setup.sql
task_009_auth_delete_verify.sql
```

### Regresión repository-side

Después:

```
```

```
npm run test
npm run verify
git diff --check
```

Los tests estáticos de TASK-009/TASK-010 deben continuar passing **sin modificarse**.

Si requieren edición:

```
```

```
BLOCKER
```

---

## 18. Criterios de aceptación

```
```

```
AC-001
Sólo se modifican los dos paths autorizados.

AC-002
Ninguna migration es modificada.

AC-003
task_009_auth_delete_setup.sql permanece byte-for-byte intacto.

AC-004
task_009_auth_delete_verify.sql permanece byte-for-byte intacto.

AC-005
La semántica operator-driven de Auth deletion permanece intacta.

AC-006
La suite automatizada TASK-009 produce TAP válido.

AC-007
TASK-009 define plan(N) coherente.

AC-008
TASK-009 ejecuta finish() y rollback.

AC-009
No se reduce ninguna assertion heredada TASK-009.

AC-010
Las assertions RLS TASK-009 se ejecutan como authenticated.

AC-011
Los fixtures locales TASK-009 son transaccionales.

AC-012
Fixtures persistentes después de TASK-009 = 0.

AC-013
Modo local TASK-009 no requiere Cloud ni credenciales reales.

AC-014
El modo explícito con IDs externos continúa soportado.

AC-015
La suite automatizada TASK-010 produce TAP válido.

AC-016
TASK-010 define plan(N) coherente.

AC-017
TASK-010 ejecuta finish() y rollback.

AC-018
No se reduce cobertura TASK-010.

AC-019
TRUNCATE denied sigue siendo probado realmente.

AC-020
tests/task-009-migration.test.ts permanece sin cambios y passing.

AC-021
tests/task-010-migration.test.ts permanece sin cambios y passing.

AC-022
TASK-013 permanece sin cambios.

AC-023
TASK-013 = 65/65 PASS.

AC-024
La regresión conjunta enumera explícitamente las tres suites.

AC-025
Regresión DB conjunta = PASS.

AC-026
TAP parse errors = 0 y plan mismatch = 0.

AC-027
Los scripts Auth-delete no son ejecutados por el Gate automático.

AC-028
npm run test = PASS.

AC-029
npm run verify = PASS.

AC-030
git diff --check = PASS.

AC-031
new npm dependencies = 0.

AC-032
Supabase Cloud mutation = NO.

AC-033
staged = NONE al finalizar ejecución.

AC-034
commit = NONE y push = NONE.

AC-035
El slice TASK-013 preexistente permanece preservado y unstaged.

AC-036
TASK-014 no fue determinada, generada ni iniciada.
```

Control:

```
```

```
AC count = 36
AC range = AC-001..AC-036
AC consecutive = YES
AC duplicates = 0
AC missing = 0
```

---

## 19. Definition of Done

CORR-017 sólo podrá considerarse técnicamente completa cuando:

```
```

```
spec approved = YES
canonicalized = YES

Git preflight = PASS
unexpected drift = NO

authorized files changed = EXACTLY 2
other files changed by CORR-017 = 0

TASK-009 pgTAP = PASS
TASK-010 pgTAP = PASS
TASK-013 65 tests = PASS
combined DB regression = PASS

static TASK-009 tests = PASS
static TASK-010 tests = PASS

npm run test = PASS
npm run verify = PASS
git diff --check = PASS

new dependencies = 0
Cloud mutation = NO

staged = NONE
commit = NONE
push = NONE

human implementation review = APPROVED
```

---

## 20. Blockers

La implementación debe detenerse ante cualquiera de estos casos:

```
```

```
migration modification required

TASK-013 modification required

auth-delete script modification required

static test modification required

dependency/package change required

an inherited assertion cannot be represented in TAP
without semantic change

local fixtures cannot remain transactional

RLS test requires bypass

TASK-013 no longer returns 65/65

DB reset does not reproduce migrations

Cloud becomes necessary

unexpected Git drift
```

Un blocker no puede resolverse debilitando un test.

---

## 21. Instrucciones para Codex

Cuando exista autorización futura:

```
```

```
trabajar EXCLUSIVAMENTE sobre CORR-017

leer íntegramente la especificación canónica

hacer preflight fresco

preservar íntegramente TASK-013

modificar sólo:

supabase/tests/database/task_009_identity_tenant_foundation.test.sql

supabase/tests/database/task_010_audit_event_foundation.test.sql

NO modificar migrations

NO modificar Auth-delete scripts

NO modificar tests estáticos

NO modificar TASK-013

NO git add

NO commit

NO push

NO Supabase Cloud

NO TASK-014
```

Ante cualquier contradicción:

```
```

```
STOP / BLOCKER
```

---

## 22. Gate posterior

Un:

```
```

```
CORR-017 IMPLEMENTATION EXECUTION = PASS
```

no reanuda automáticamente TASK-013.

La secuencia obligatoria será:

```
```

```
1. Central Review de implementación CORR-017
2. aprobación humana
3. staging exclusivo CORR-017
4. staged diff review
5. commit Gate
6. push Gate
7. origin/main verification
8. reanudación de TASK-013 sobre nuevo baseline
```

Durante la incorporación de CORR-017:

```
```

```
TASK-013 changes remain unstaged
```

y no pueden entrar accidentalmente en el commit de CORR-017.

Una vez CORR-017 esté en `origin/main`, TASK-013 podrá reanudarse para completar:

```
```

```
DB regression
lint
typecheck
TypeScript tests
build
verify
git diff --check
final implementation review
```

---

## 23. Estado de la especificación

```
```

```
CORR-017 DETERMINATION = APPROVED

CORR-017 SPECIFICATION = APPROVED FOR IMPLEMENTATION

CORR-017 IMPLEMENTATION = NOT STARTED
CORR-017 IMPLEMENTATION EXECUTION = NOT AUTHORIZED BY THIS ACT
canonicalization = NO

git add = NO
commit = NO
push = NO

Supabase Cloud mutation = NO

TASK-013 =
BLOCKED PENDING CORR-017

TASK-014 determined = NO
TASK-014 generated = NO
TASK-014 started = NO
```
