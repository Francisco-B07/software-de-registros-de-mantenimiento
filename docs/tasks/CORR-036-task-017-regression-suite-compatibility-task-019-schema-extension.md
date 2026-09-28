# CORR-036 — TASK-017 Regression Suite Compatibility with Authorized TASK-019 Schema Extension

## 1. Identificación

**ID:** `CORR-036`

**Tipo:** `REGRESSION COMPATIBILITY / TEST-ONLY CORRECTION`

**Estado de esta specification:** `CANONICALIZED / PENDING CANONICALIZATION REVIEW`

**CORR-036 DETERMINATION:** `APPROVED`

**CORR-036 SPECIFICATION GENERATION AUTHORIZATION:** `APPROVED`

**CORR-036 SPEC REVIEW:** `APPROVED`

**CORR-036 HUMAN SPEC APPROVAL:** `APPROVED`

**CORR-036 specification:** `HUMAN APPROVED`

**F-036-SPEC-001:** `RESOLVED`

**CORR-036 APPROVED ARTIFACT GENERATION:** `PASS`

**CORR-036 APPROVED ARTIFACT REVIEW:** `APPROVED`

**CORR-036 approved artifact:** `REVIEW APPROVED`

**CORR-036 CANONICALIZATION:** `PASS`

**CORR-036 canonicalized:** `YES`

**CORR-036 CANONICALIZATION REVIEW:** `PENDING`

**CORR-036 repository incorporation:** `NO`

**CORR-036 implementation authorization:** `NO`

**CORR-036 implementation:** `NOT PERFORMED`

**Production defect:** `NO`

**New ADR required:** `NO`

**Candidate implementation paths:** `1`

**Production paths:** `NONE`

**Repository modified by canonicalization:** `NO`

**Supabase Cloud modified:** `NO`

**CORR-035 IMPLEMENTATION:** `BLOCKED — ADDITIONAL IMPLEMENTATION SURFACE REQUIRED`

**F-019-B-001:** `IMPLEMENTED / REVIEW BLOCKED`

**F-019-B-002:** `IMPLEMENTED / REVIEW BLOCKED`

**TASK-019 WORK ITEM A REVIEW:** `REOPENED`

**TASK-019 WORK ITEM B:** `BLOCKED / NOT COMPLETE`

**TASK-019 WORK ITEM C..F:** `NOT AUTHORIZED`

**Staging / commit / push:** `NOT AUTHORIZED`

**Phase 2:** `IN PROGRESS / NOT CLOSED`

**Phase 3:** `NOT STARTED`

---

## 2. Objetivo único

CORR-036 corrige exclusivamente una incompatibilidad histórica del regression test de TASK-017 con una extensión de schema posterior, explícitamente autorizada por TASK-019.

El único path candidato de implementación es:

```text
supabase/tests/database/task_017_first_admin_onboarding_intent_verification_handoff_foundation.test.sql
```

La corrección es estrictamente test-only.

CORR-036 no modifica producción, no cambia arquitectura, no cambia dominio, no cambia RLS, no cambia grants, no cambia autorización, no cambia multitenancy, no cambia lock order y no cambia la semántica funcional de TASK-017 ni de TASK-019.

---

## 3. Problema autoritativo

Durante la regresión requerida por CORR-035, TASK-017 produjo exactamente cuatro fallos:

```text
T017-SCHEMA-002 =
actual 13 columns / historical expected 9

T017-SCHEMA-003 =
actual 13 column types / historical expected 9

T017-SCHEMA-006 =
actual 6 foreign keys / historical expected 4

T017-SCOPE-001 =
authorized TASK-019 completion field rejected
```

Clasificación aprobada:

```text
problem class =
HISTORICAL REGRESSION TEST INCOMPATIBLE WITH LATER AUTHORIZED SCHEMA EXTENSION

TASK-017 production defect =
NO

TASK-019 schema defect =
NO
```

Los fallos no autorizan modificar production code.

---

## 4. Fuentes físicas autoritativas revisadas

### 4.1 TASK-017 canonical

```text
docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md
SHA-256 =
aa236a05162e44e083f4e75c1dc86602d55a91f454134e023b6306640370653d
```

### 4.2 TASK-017 production migration

```text
supabase/migrations/20260919153618_task_017_first_admin_onboarding_intent_verification_handoff_foundation.sql
SHA-256 =
7ef2ef48f92d632fc757527a3716978c49eb5358bd852dab1b1acd7ba437d789
```

### 4.3 TASK-017 foundation regression test

```text
supabase/tests/database/task_017_first_admin_onboarding_intent_verification_handoff_foundation.test.sql
SHA-256 =
501c0c6f0ccf9ae928ab0c4e48df8b7d7a6f76a7b79dd62de567640da03b1afe
```

### 4.4 TASK-019 canonical

```text
docs/tasks/TASK-019-authoritative-first-admin-profile-completion-onboarding-completion-foundation.md
SHA-256 =
281372051bd1fb3791b23a706c7c818da99ff21bf6aa3f70954eeafbb133c902
```

### 4.5 TASK-019 current migration after CORR-035 implementation work

```text
supabase/migrations/20260925011407_task_019_first_admin_profile_completion_onboarding_completion_foundation.sql
SHA-256 =
d74c24e18e1798ca946afd118ff94b7a468fb52e73af3347ab2657abc0f47f81
```

### 4.6 CORR-035 canonical

```text
docs/tasks/CORR-035-task-019-cross-task-actor-company-lock-graph-correction.md
SHA-256 =
bf99665f706ed1d01a972927ee8af835a82170f06e1bd89a06f4f873e5efee0a
```

No fuente externa es necesaria para decidir CORR-036.

---

## 5. Contrato físico owned por TASK-017

TASK-017 creó `public.first_admin_onboarding_intents` con nueve columnas propias:

| Campo owned por TASK-017 | Tipo PostgreSQL |
|---|---|
| `id` | `uuid` |
| `maintenance_company_id` | `uuid` |
| `target_email` | `text` |
| `initiated_by_platform_user_id` | `uuid` |
| `establishment_operation_id` | `uuid` |
| `current_challenge_id` | `uuid` |
| `handoff_session_grant_id` | `uuid` |
| `handoff_ready_at` | `timestamptz` |
| `created_at` | `timestamptz` |

En `information_schema.columns`, `timestamptz` se observa como:

```text
timestamp with time zone
```

CORR-036 preserva la existencia, nombre y tipo exacto de estos nueve campos.

---

## 6. Foreign keys owned por TASK-017

TASK-017 posee cuatro foreign keys originales:

```text
maintenance_company_id
→ public.maintenance_companies(id)
ON DELETE RESTRICT
```

```text
initiated_by_platform_user_id
→ public.platform_users(id)
ON DELETE RESTRICT
```

```text
current_challenge_id
→ public.verification_challenges(id)
ON DELETE RESTRICT
```

```text
handoff_session_grant_id
→ public.auth_session_grants(id)
ON DELETE RESTRICT
```

CORR-036 no permite eliminar, renombrar, redirigir ni debilitar ninguna de estas cuatro relaciones.

---

## 7. Contrato TASK-017 sobre completion

TASK-017 estableció expresamente:

```text
no onboarding-completion column is defined by TASK-017
```

y dejó la forma física exacta de completion para trabajo posterior de RF-012.

Por tanto:

```text
TASK-017 did not own completion representation
```

no significa:

```text
completion representation may never be added later
```

Una extensión posterior sólo es compatible cuando existe autorización canónica posterior explícita.

---

## 8. Extensión posterior autorizada por TASK-019

TASK-019 añadió a `public.first_admin_onboarding_intents` exactamente estas cuatro columnas terminales:

```text
completion_operation_id uuid
completed_platform_user_id uuid
completed_company_membership_id uuid
completed_at timestamptz
```

TASK-019 añadió además:

```text
completed_platform_user_id
→ public.platform_users(id)
ON DELETE RESTRICT
```

```text
completed_company_membership_id
→ public.company_memberships(id)
ON DELETE RESTRICT
```

La migration TASK-019 actual post-CORR-035 conserva exactamente esas adiciones de schema.

CORR-035 modificó el flujo/lock-order de completion; no revocó ni sustituyó esta extensión de schema.

---

## 9. Ownership dividido

La corrección debe distinguir dos contratos:

```text
TASK-017-owned contract
=
9 original columns
+ their exact original types
+ 4 original FKs
+ original TASK-017 invariants
```

```text
later authorized TASK-019 extension
=
4 completion columns
+ 2 completion FKs
+ TASK-019 completion invariants
```

TASK-017 regression debe proteger su propio contrato y reconocer de manera explícita la extensión autorizada.

TASK-019 regression continúa siendo la autoridad primaria para la semántica interna de sus completion fields, FKs, uniqueness y coupled terminal-state invariant.

---

## 10. Principio de compatibilidad

CORR-036 rechaza ambos extremos siguientes.

### 10.1 Schema-total freezing

Incorrecto:

```text
TASK-017 owns every future column of the table
therefore total columns must forever equal 9
```

Esto hace incompatible cualquier extensión posterior autorizada.

### 10.2 Generic allow-all

También incorrecto:

```text
TASK-017 only checks its nine fields
therefore any arbitrary extra column is acceptable
```

Esto ocultaría drift no autorizado.

### 10.3 Regla seleccionada

La regresión debe aplicar:

```text
all TASK-017-owned fields must still exist exactly
AND
any field outside TASK-017 ownership must belong to an explicit later-authorized compatibility allowlist
```

Para el baseline actual, la allowlist posterior de columnas es exactamente:

```text
completion_operation_id
completed_platform_user_id
completed_company_membership_id
completed_at
```

Para foreign keys, la regresión debe aplicar la regla equivalente:

```text
all 4 TASK-017-owned foreign keys must remain exact
AND
any foreign key outside TASK-017 ownership must belong to an explicit later-authorized compatibility set
```

Para el baseline actual, el compatibility set posterior de foreign keys es exactamente:

```text
completed_platform_user_id
→ public.platform_users(id)
ON DELETE RESTRICT

completed_company_membership_id
→ public.company_memberships(id)
ON DELETE RESTRICT
```

Estas allowlists son compatibilidad explícita con TASK-019, no transferencia de ownership a TASK-017.

Una futura columna o foreign key ajena a ambos conjuntos debe volver a producir fallo hasta existir autorización posterior y corrección documental/test separada.

---

## 11. Corrección requerida — T017-SCHEMA-002

### 11.1 Problema actual

El test actual compara el set total de columnas contra:

```text
{id,maintenance_company_id,target_email,initiated_by_platform_user_id,establishment_operation_id,current_challenge_id,handoff_session_grant_id,handoff_ready_at,created_at}
```

Esto congela el schema total en nueve columnas.

### 11.2 Contrato corregido

`T017-SCHEMA-002` debe comprobar en una sola assertion lógica o equivalente:

1. los nueve campos owned por TASK-017 existen;
2. ninguno fue renombrado;
3. ninguno fue eliminado;
4. cualquier columna adicional pertenece a la allowlist TASK-019 aprobada;
5. ninguna columna adicional desconocida queda aceptada por inferencia.

No debe exigir que TASK-017 sea responsable de validar tipos o semántica de los cuatro campos TASK-019.

### 11.3 Resultado esperado

Con el baseline actual:

```text
TASK-017-owned columns missing =
0

unauthorized extra columns =
0
```

---

## 12. Corrección requerida — T017-SCHEMA-003

### 12.1 Problema actual

El test actual agrega los tipos de todas las columnas presentes y compara un array de nueve posiciones.

Cuando TASK-019 añade columnas válidas, el array crece y la assertion falla aunque los tipos TASK-017 permanezcan intactos.

### 12.2 Contrato corregido

`T017-SCHEMA-003` debe filtrar o resolver exclusivamente los nueve campos owned por TASK-017 y comprobar sus tipos exactos:

```text
id = uuid
maintenance_company_id = uuid
target_email = text
initiated_by_platform_user_id = uuid
establishment_operation_id = uuid
current_challenge_id = uuid
handoff_session_grant_id = uuid
handoff_ready_at = timestamp with time zone
created_at = timestamp with time zone
```

Debe fallar si:

- falta uno;
- cambia el tipo de uno;
- existe duplicidad/inconsistencia que impida resolver el campo esperado.

No debe incorporar los tipos TASK-019 dentro del ownership de TASK-017.

---

## 13. Corrección requerida — T017-SCHEMA-006

### 13.1 Problema actual

El test actual exige:

```text
total FK count =
4
```

TASK-019 añade dos FKs aprobadas y eleva el total a seis.

### 13.2 Contrato corregido

`T017-SCHEMA-006` debe demostrar que las cuatro FKs owned por TASK-017 continúan presentes y exactas.

Como mínimo verificar para cada una:

```text
source table =
public.first_admin_onboarding_intents

source column =
expected TASK-017 column

target table =
expected TASK-017 table

target column =
id

delete action =
RESTRICT
```

No debe exigir:

```text
total FK count = 4
```

### 13.3 Protección fail-closed contra FKs arbitrarias

La ausencia del count total no implica que cualquier FK futura sea aprobada por TASK-017.

`T017-SCHEMA-006`, o lógica local equivalente asociada a esa superficie dentro del mismo test autorizado, debe demostrar simultáneamente:

```text
all 4 TASK-017-owned foreign keys remain exact
```

y:

```text
unauthorized additional foreign keys =
0
```

Para el baseline actual, el conjunto permitido de foreign keys es exclusivamente:

```text
4 original TASK-017 foreign keys
+
2 explicitly authorized TASK-019 foreign keys
```

Las dos FKs TASK-019 reconocidas como compatibilidad posterior son:

```text
completed_platform_user_id
→ public.platform_users(id)
ON DELETE RESTRICT

completed_company_membership_id
→ public.company_memberships(id)
ON DELETE RESTRICT
```

Una future foreign key que no pertenezca a las cuatro TASK-017 originales ni a estas dos FKs TASK-019 explícitamente autorizadas debe provocar fallo hasta existir autorización posterior separada.

La compatibilidad de FKs posteriores pertenece a su task posterior correspondiente.

Este cierre no vuelve a:

```text
total FK count = 4
```

ni permite:

```text
any extra FK is acceptable
```

CORR-036 no redefine la semántica de las dos FKs TASK-019 ni sustituye los tests TASK-019.

---

## 14. Corrección requerida — T017-SCOPE-001

### 14.1 Problema actual

La assertion histórica prohíbe:

```text
role
purpose
status
completed_at
onboarding_completed_at
```

`completed_at` dejó de ser drift después de TASK-019.

### 14.2 Contrato corregido

`T017-SCOPE-001` debe continuar rechazando como mínimo:

```text
role
purpose
status
onboarding_completed_at
```

No debe tratar como field prohibido:

```text
completed_at
```

porque ahora forma parte de una extensión posterior explícitamente autorizada.

### 14.3 Interpretación

Eliminar `completed_at` del conjunto prohibido:

```text
does not mean TASK-017 invented completed_at
does not mean TASK-017 owns completed_at
does not mean arbitrary completion fields are allowed
```

Su legitimidad proviene exclusivamente de TASK-019.

---

## 15. Assertions TASK-017 que no se corrigen

CORR-036 no autoriza cambios oportunistas sobre tests que actualmente pasan.

En particular, salvo evidencia nueva revisada por el Revisor Central, permanecen fuera del scope de corrección:

```text
T017-SCHEMA-001
T017-SCHEMA-004
T017-SCHEMA-005
T017-SCHEMA-007..014
T017-SCOPE-002..
RLS assertions
grant assertions
function assertions
authorization assertions
transaction assertions
```

La implementación debe producir un diff mínimo centrado en:

```text
T017-SCHEMA-002
T017-SCHEMA-003
T017-SCHEMA-006
T017-SCOPE-001
```

y sólo helpers/local SQL estrictamente necesarios dentro del mismo archivo.

---

## 16. Único implementation path

La implementación de CORR-036 puede modificar exclusivamente:

```text
supabase/tests/database/task_017_first_admin_onboarding_intent_verification_handoff_foundation.test.sql
```

No se permite un segundo path.

Si la implementación requiere otro archivo:

```text
CORR-036 IMPLEMENTATION =
STOP

BLOCKER — ADDITIONAL SURFACE REQUIRED
```

---

## 17. Production boundary

Production mutation por CORR-036:

```text
NONE
```

Queda prohibido modificar:

```text
supabase/migrations/20260919153618_task_017_first_admin_onboarding_intent_verification_handoff_foundation.sql

supabase/migrations/20260925011407_task_019_first_admin_profile_completion_onboarding_completion_foundation.sql

TASK-019 DB/static test

TASK-019 concurrency harness

CORR-035 canonical

RLS policies

table grants

function grants

RPC definitions

application TypeScript

HTTP routes

UI
```

---

## 18. Seguridad, RLS y multitenancy

CORR-036 es una corrección de regression test.

Debe mantenerse:

```text
security behavior change =
NO

RLS change =
NO

grant change =
NO

authorization change =
NO

multitenancy change =
NO

lock-order change =
NO

transaction behavior change =
NO

production behavior change =
NO
```

No se añade ningún writer, role, bypass, service-role path ni privilegio.

---

## 19. ADR

Resultado:

```text
new ADR required =
NO
```

Justificación:

- no cambia arquitectura;
- no cambia production behavior;
- no cambia trust boundary;
- no cambia autorización;
- no cambia persistencia;
- no cambia concurrencia productiva;
- modifica un único regression test para reconocer una extensión posterior ya aprobada.

Si durante implementación surgiera necesidad de cambiar cualquiera de esas superficies:

```text
CORR-036 IMPLEMENTATION =
STOP

BLOCKER — ARCHITECTURAL OR PRODUCTION CHANGE REQUIRED
```

---

## 20. Interlock con CORR-035

Durante CORR-036 debe mantenerse:

```text
CORR-035 IMPLEMENTATION =
BLOCKED — ADDITIONAL IMPLEMENTATION SURFACE REQUIRED

F-019-B-001 =
IMPLEMENTED / REVIEW BLOCKED

F-019-B-002 =
IMPLEMENTED / REVIEW BLOCKED

TASK-019 WORK ITEM A REVIEW =
REOPENED

TASK-019 WORK ITEM B =
BLOCKED / NOT COMPLETE
```

Los tres cambios actuales CORR-035 no deben revertirse por CORR-036 salvo finding posterior separado.

No generar todavía:

```text
CORR-035-implementation-review-evidence.zip
```

---

## 21. Baseline Git requerido para futura implementación

Antes de implementar CORR-036, Codex deberá verificar un preflight Git fresco.

El baseline esperado al momento de esta specification continúa conceptualmente:

```text
branch =
main

HEAD =
fb2a977f2be288312ae9d75fb057cd9dff8ca6f0

origin/main =
fb2a977f2be288312ae9d75fb057cd9dff8ca6f0

divergence =
0 0
```

Los artefactos TASK-019/CORR-035 existentes continúan sin staging según la evidencia previa.

CORR-036 no autoriza staging, commit, push, reset, restore, stash, rebase, merge ni amend.

Cualquier drift material debe volver al Revisor Central.

---

## 22. Estrategia de implementación futura

Sólo después de todos los Gates documentales y autorización humana específica de implementación:

1. verificar Git baseline;
2. verificar SHA del canonical CORR-036;
3. verificar SHA del test TASK-017 baseline autorizado;
4. inspeccionar nuevamente las cuatro assertions;
5. modificar exclusivamente el test TASK-017;
6. preservar el resto del archivo;
7. ejecutar TASK-017 foundation suite;
8. ejecutar TASK-017 edge-cases suite;
9. ejecutar TASK-017 concurrency;
10. reejecutar TASK-019 directed suite;
11. reejecutar TASK-019 concurrency Scenario A..D;
12. reejecutar boundedness probe;
13. verificar deadlock/timeout;
14. ejecutar DB lint;
15. ejecutar `git diff --check`;
16. revisar que sólo el path autorizado cambió;
17. devolver evidencia;
18. no realizar staging/commit/push.

---

## 23. Regression contract obligatorio

La futura implementación no puede considerarse PASS hasta obtener:

```text
TASK-017 foundation suite =
PASS

TASK-017 edge-cases suite =
PASS

TASK-017 concurrency =
PASS

TASK-019 directed suite =
PASS

TASK-019 Scenario A =
PASS

TASK-019 Scenario B =
PASS

TASK-019 Scenario C =
PASS

TASK-019 Scenario D =
PASS

TASK-019 boundedness probe =
PASS

PostgreSQL deadlock =
NO

timeout/hang =
NO

DB lint =
PASS

git diff --check =
PASS
```

Un test-only correction no puede ocultar un fallo productivo real.

Si aparece un production failure:

```text
CORR-036 IMPLEMENTATION =
STOP — PRODUCTION FAILURE DISCOVERED
```

---

## 24. Evidencia requerida para implementation review

Una futura evidencia de CORR-036 debe incluir como mínimo:

```text
baseline TASK-017 test SHA-256

corrected TASK-017 test SHA-256

physical diff of the single authorized path

TASK-017 foundation result/count

TASK-017 edge-cases result/count

TASK-017 concurrency result

TASK-019 directed suite result/count

TASK-019 Scenario A result

TASK-019 Scenario B result

TASK-019 Scenario C result

TASK-019 Scenario D result

boundedness result

deadlock classification

timeout classification

DB lint result

git diff --check result

Git status

staged paths
```

Debe demostrar:

```text
production path changes =
NONE

authorized implementation paths changed =
1
```

---

## 25. Acceptance Criteria

### Scope / governance

**AC-036-001.** CORR-036 conserva exactamente el alcance de compatibilidad de regression test de TASK-017 con la extensión posterior TASK-019.

**AC-036-002.** El problem class es `HISTORICAL REGRESSION TEST INCOMPATIBLE WITH LATER AUTHORIZED SCHEMA EXTENSION`.

**AC-036-003.** `production defect = NO`.

**AC-036-004.** `new ADR required = NO`.

**AC-036-005.** Existe exactamente un implementation path permitido.

**AC-036-006.** El único implementation path es `supabase/tests/database/task_017_first_admin_onboarding_intent_verification_handoff_foundation.test.sql`.

**AC-036-007.** Ningún production path es modificable por CORR-036.

**AC-036-008.** CORR-036 no autoriza staging, commit, push ni Supabase Cloud.

### TASK-017 ownership

**AC-036-009.** `id` continúa siendo un campo owned por TASK-017.

**AC-036-010.** `maintenance_company_id` continúa siendo un campo owned por TASK-017.

**AC-036-011.** `target_email` continúa siendo un campo owned por TASK-017.

**AC-036-012.** `initiated_by_platform_user_id` continúa siendo un campo owned por TASK-017.

**AC-036-013.** `establishment_operation_id` continúa siendo un campo owned por TASK-017.

**AC-036-014.** `current_challenge_id` continúa siendo un campo owned por TASK-017.

**AC-036-015.** `handoff_session_grant_id` continúa siendo un campo owned por TASK-017.

**AC-036-016.** `handoff_ready_at` continúa siendo un campo owned por TASK-017.

**AC-036-017.** `created_at` continúa siendo un campo owned por TASK-017.

**AC-036-018.** Los nueve campos owned por TASK-017 deben permanecer presentes.

**AC-036-019.** Ningún campo owned por TASK-017 puede renombrarse como resultado de CORR-036.

**AC-036-020.** Ningún campo owned por TASK-017 puede eliminarse como resultado de CORR-036.

### Types

**AC-036-021.** `id` conserva tipo `uuid`.

**AC-036-022.** `maintenance_company_id` conserva tipo `uuid`.

**AC-036-023.** `target_email` conserva tipo `text`.

**AC-036-024.** `initiated_by_platform_user_id` conserva tipo `uuid`.

**AC-036-025.** `establishment_operation_id` conserva tipo `uuid`.

**AC-036-026.** `current_challenge_id` conserva tipo `uuid`.

**AC-036-027.** `handoff_session_grant_id` conserva tipo `uuid`.

**AC-036-028.** `handoff_ready_at` conserva tipo `timestamptz` / `timestamp with time zone`.

**AC-036-029.** `created_at` conserva tipo `timestamptz` / `timestamp with time zone`.

**AC-036-030.** `T017-SCHEMA-003` valida sólo tipos owned por TASK-017 y no depende de la longitud del schema total.

### Original foreign keys

**AC-036-031.** La FK TASK-017 de `maintenance_company_id` hacia `maintenance_companies(id)` continúa presente.

**AC-036-032.** La FK TASK-017 de `initiated_by_platform_user_id` hacia `platform_users(id)` continúa presente.

**AC-036-033.** La FK TASK-017 de `current_challenge_id` hacia `verification_challenges(id)` continúa presente.

**AC-036-034.** La FK TASK-017 de `handoff_session_grant_id` hacia `auth_session_grants(id)` continúa presente.

**AC-036-035.** Las cuatro FKs owned por TASK-017 conservan `ON DELETE RESTRICT`.

**AC-036-036.** `T017-SCHEMA-006` deja de exigir `total FK count = 4`.

**AC-036-037.** `T017-SCHEMA-006` verifica existencia y semántica de las cuatro FKs owned por TASK-017 y rechaza cualquier FK adicional que no sea TASK-017-owned ni pertenezca al explicit TASK-019 compatibility set.

### TASK-019 extension compatibility

**AC-036-038.** `completion_operation_id uuid` se reconoce como extensión posterior autorizada por TASK-019.

**AC-036-039.** `completed_platform_user_id uuid` se reconoce como extensión posterior autorizada por TASK-019.

**AC-036-040.** `completed_company_membership_id uuid` se reconoce como extensión posterior autorizada por TASK-019.

**AC-036-041.** `completed_at timestamptz` se reconoce como extensión posterior autorizada por TASK-019.

**AC-036-042.** La FK TASK-019 `completed_platform_user_id → platform_users(id) ON DELETE RESTRICT` se reconoce como extensión posterior autorizada.

**AC-036-043.** La FK TASK-019 `completed_company_membership_id → company_memberships(id) ON DELETE RESTRICT` se reconoce como extensión posterior autorizada.

**AC-036-044.** TASK-019 continúa siendo la autoridad primaria para la semántica de sus cuatro completion fields.

**AC-036-045.** TASK-019 continúa siendo la autoridad primaria para uniqueness y coupled terminal-state invariant.

### No generic allow-all

**AC-036-046.** `T017-SCHEMA-002` deja de congelar el schema total en exactamente nueve columnas.

**AC-036-047.** `T017-SCHEMA-002` continúa fallando si falta cualquiera de los nueve campos TASK-017.

**AC-036-048.** `T017-SCHEMA-002` continúa fallando ante una columna adicional que no pertenezca a una extensión posterior explícitamente autorizada.

**AC-036-049.** La allowlist de compatibilidad actual contiene exactamente los cuatro campos TASK-019 autorizados.

**AC-036-050.** Una futura columna no documentada no queda autorizada por inferencia.

### Scope assertion

**AC-036-051.** `T017-SCOPE-001` continúa rechazando `role`.

**AC-036-052.** `T017-SCOPE-001` continúa rechazando `purpose`.

**AC-036-053.** `T017-SCOPE-001` continúa rechazando `status`.

**AC-036-054.** `T017-SCOPE-001` continúa rechazando `onboarding_completed_at`.

**AC-036-055.** `T017-SCOPE-001` deja de rechazar `completed_at`.

**AC-036-056.** Dejar de rechazar `completed_at` no transfiere ownership de ese campo a TASK-017.

### Minimal correction

**AC-036-057.** La corrección se centra en `T017-SCHEMA-002`, `T017-SCHEMA-003`, `T017-SCHEMA-006` y `T017-SCOPE-001`.

**AC-036-058.** No se modifican assertions TASK-017 que pasan salvo helper/local SQL estrictamente necesario dentro del mismo archivo.

**AC-036-059.** No se reduce cobertura de los nueve campos TASK-017.

**AC-036-060.** No se reduce cobertura de las cuatro FKs TASK-017.

### Security / architecture

**AC-036-061.** RLS policy delta = `NONE`.

**AC-036-062.** Grant delta = `NONE`.

**AC-036-063.** Authorization behavior delta = `NONE`.

**AC-036-064.** Multitenancy behavior delta = `NONE`.

**AC-036-065.** Lock-order delta = `NONE`.

**AC-036-066.** Production behavior delta = `NONE`.

### Regression

**AC-036-067.** TASK-017 foundation suite pasa después de la corrección.

**AC-036-068.** TASK-017 edge-cases suite pasa después de la corrección.

**AC-036-069.** TASK-017 concurrency pasa después de la corrección.

**AC-036-070.** TASK-019 directed suite continúa pasando.

**AC-036-071.** TASK-019 Scenario A continúa pasando.

**AC-036-072.** TASK-019 Scenario B continúa pasando.

**AC-036-073.** TASK-019 Scenario C continúa pasando sin PostgreSQL deadlock.

**AC-036-074.** TASK-019 Scenario D continúa pasando.

**AC-036-075.** TASK-019 boundedness probe continúa pasando.

**AC-036-076.** Ningún timeout/hang aparece en la regresión obligatoria.

**AC-036-077.** DB lint pasa.

**AC-036-078.** `git diff --check` pasa.

### CORR-035 interlock

**AC-036-079.** CORR-035 permanece bloqueado durante la ejecución documental/implementación de CORR-036.

**AC-036-080.** Los tres cambios actuales CORR-035 no se revierten por inferencia.

**AC-036-081.** `CORR-035-implementation-review-evidence.zip` no se genera antes de resolver CORR-036.

**AC-036-082.** F-019-B-001 no se declara resuelto por CORR-036.

**AC-036-083.** F-019-B-002 no se declara resuelto por CORR-036.

**AC-036-084.** TASK-019 Work Item A no se declara aprobado por CORR-036.

**AC-036-085.** TASK-019 Work Item B no se declara aprobado por CORR-036.

### Phase / Git

**AC-036-086.** TASK-019 Work Items C..F permanecen `NOT AUTHORIZED`.

**AC-036-087.** Staging permanece `NOT AUTHORIZED`.

**AC-036-088.** Commit permanece `NOT AUTHORIZED`.

**AC-036-089.** Push permanece `NOT AUTHORIZED`.

**AC-036-090.** Supabase Cloud permanece `NOT AUTHORIZED`.

**AC-036-091.** Phase 2 permanece `IN PROGRESS / NOT CLOSED`.

**AC-036-092.** Phase 3 permanece `NOT STARTED`.

---

## 26. Definition of Done

**DoD-036-001.** `CORR-036 DETERMINATION = APPROVED`.

**DoD-036-002.** La specification ha sido generada desde fuentes físicas autoritativas.

**DoD-036-003.** `CORR-036 SPEC REVIEW = APPROVED`.

**DoD-036-004.** Existe aprobación humana formal de la specification.

**DoD-036-005.** Se genera un approved artifact mediante Gate separado.

**DoD-036-006.** El approved artifact es revisado y aprobado mediante Gate separado.

**DoD-036-007.** CORR-036 se canonicaliza mediante Gate separado.

**DoD-036-008.** La canonicalization es revisada y aprobada.

**DoD-036-009.** El canonical se incorpora al repositorio mediante autorización separada.

**DoD-036-010.** La incorporación al repositorio es revisada y aprobada.

**DoD-036-011.** Existe autorización humana separada para implementación.

**DoD-036-012.** El preflight Git previo a implementación pasa sin drift inesperado.

**DoD-036-013.** El canonical CORR-036 coincide con su SHA autorizado.

**DoD-036-014.** El test TASK-017 baseline coincide con el SHA autorizado para implementación.

**DoD-036-015.** Se modifica exactamente un path.

**DoD-036-016.** El único path modificado es el foundation regression test de TASK-017.

**DoD-036-017.** Ningún production path cambia.

**DoD-036-018.** `T017-SCHEMA-002` cumple el ownership/compatibility model aprobado.

**DoD-036-019.** `T017-SCHEMA-003` valida exactamente los tipos owned por TASK-017.

**DoD-036-020.** `T017-SCHEMA-006` valida las cuatro FKs owned por TASK-017 sin total-count freeze.

**DoD-036-021.** `T017-SCOPE-001` preserva los campos prohibidos y deja de rechazar `completed_at`.

**DoD-036-022.** Una columna o foreign key adicional no autorizada sigue provocando fallo.

**DoD-036-023.** TASK-017 foundation suite = `PASS`.

**DoD-036-024.** TASK-017 edge-cases suite = `PASS`.

**DoD-036-025.** TASK-017 concurrency = `PASS`.

**DoD-036-026.** TASK-019 directed suite = `PASS`.

**DoD-036-027.** TASK-019 Scenario A..D = `PASS`.

**DoD-036-028.** TASK-019 boundedness probe = `PASS`.

**DoD-036-029.** PostgreSQL deadlock = `NO`.

**DoD-036-030.** timeout/hang = `NO`.

**DoD-036-031.** DB lint = `PASS`.

**DoD-036-032.** `git diff --check = PASS`.

**DoD-036-033.** RLS/grants/authorization/multitenancy/lock-order deltas = `NONE`.

**DoD-036-034.** CORR-036 implementation review = `APPROVED`.

**DoD-036-035.** CORR-035 sólo se desbloquea mediante Gate separado después del cierre técnico de CORR-036.

**DoD-036-036.** Staging no ocurre sin Gate separado.

**DoD-036-037.** Commit no ocurre sin Gate separado.

**DoD-036-038.** Push no ocurre sin Gate separado.

**DoD-036-039.** Supabase Cloud mutation = `NONE`.

**DoD-036-040.** Phase 2 no se declara cerrada por inferencia y Phase 3 no se inicia.

---

## 27. Blockers de implementación

La implementación futura debe detenerse y volver al Revisor Central si ocurre cualquiera de estos casos:

1. se necesita modificar más de un path;
2. se necesita modificar una migration;
3. se necesita modificar production SQL;
4. se necesita modificar TASK-019 test/harness;
5. se necesita cambiar RLS;
6. se necesita cambiar grants;
7. se necesita cambiar autorización;
8. se necesita cambiar multitenancy;
9. se necesita cambiar lock order;
10. se detecta que uno de los cuatro fallos originales refleja un production defect real;
11. una regression posterior revela production failure no explicado por CORR-036;
12. el test sólo puede hacerse pasar aceptando arbitrary future columns;
13. el test sólo puede hacerse pasar debilitando checks sobre los nueve campos TASK-017;
14. el test sólo puede hacerse pasar debilitando checks sobre las cuatro FKs TASK-017;
15. el baseline Git o los SHA físicos no coinciden con los autorizados.

Ante cualquiera:

```text
CORR-036 IMPLEMENTATION =
STOP / BLOCKER

no silent repair
no scope expansion
RETURN TO REVISOR CENTRAL
```

---

## 28. Governance después de canonicalization

Estado:

```text
CORR-036 DETERMINATION =
APPROVED

CORR-036 SPECIFICATION GENERATION =
PASS

CORR-036 specification =
HUMAN APPROVED

CORR-036 SPEC REVIEW =
APPROVED

CORR-036 HUMAN SPEC APPROVAL =
APPROVED

F-036-SPEC-001 =
RESOLVED

CORR-036 APPROVED ARTIFACT GENERATION =
PASS

CORR-036 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-036 approved artifact =
REVIEW APPROVED

CORR-036 CANONICALIZATION =
PASS

CORR-036 canonicalized =
YES

CORR-036 CANONICALIZATION REVIEW =
PENDING

CORR-036 repository incorporation =
NO

CORR-036 implementation authorization =
NO

CORR-036 implementation =
NOT PERFORMED

new ADR required =
NO
```

Interlock:

```text
CORR-035 IMPLEMENTATION =
BLOCKED — ADDITIONAL IMPLEMENTATION SURFACE REQUIRED

F-019-B-001 =
IMPLEMENTED / REVIEW BLOCKED

F-019-B-002 =
IMPLEMENTED / REVIEW BLOCKED

TASK-019 WORK ITEM A REVIEW =
REOPENED

TASK-019 WORK ITEM B =
BLOCKED / NOT COMPLETE

TASK-019 WORK ITEM C..F =
NOT AUTHORIZED
```

Secuencia futura separada:

```text
CORR-036 CANONICALIZATION REVIEW
→ REPOSITORY INCORPORATION AUTHORIZATION
→ REPOSITORY INCORPORATION
→ REPOSITORY INCORPORATION REVIEW
→ CORR-036 IMPLEMENTATION AUTHORIZATION
→ CORR-036 IMPLEMENTATION
→ CORR-036 IMPLEMENTATION REVIEW
→ CORR-035 RESUME GATE
```

No Gate implica el siguiente.

---

## 29. Estado final de este candidato canónico

```text
CORR-036 SPECIFICATION GENERATION =
PASS

CORR-036 specification =
HUMAN APPROVED

CORR-036 SPEC REVIEW =
APPROVED

CORR-036 HUMAN SPEC APPROVAL =
APPROVED

F-036-SPEC-001 =
RESOLVED

CORR-036 APPROVED ARTIFACT GENERATION =
PASS

CORR-036 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-036 approved artifact =
REVIEW APPROVED

CORR-036 CANONICALIZATION =
PASS

CORR-036 canonicalized =
YES

CORR-036 CANONICALIZATION REVIEW =
PENDING

problem class =
HISTORICAL REGRESSION TEST INCOMPATIBLE WITH LATER AUTHORIZED SCHEMA EXTENSION

production defect =
NO

new ADR required =
NO

candidate implementation paths =
1

production paths =
NONE

repository mutation =
NO

Supabase Cloud mutation =
NO

CORR-036 repository incorporation =
NO

CORR-036 implementation authorization =
NO

CORR-036 implementation =
NOT PERFORMED

CORR-035 =
REMAINS BLOCKED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 3 =
NOT STARTED
```
