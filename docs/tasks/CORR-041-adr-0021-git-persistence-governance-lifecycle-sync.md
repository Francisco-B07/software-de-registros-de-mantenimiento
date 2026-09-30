# CORR-041 — ADR-0021 Git Persistence Governance Lifecycle Sync

## 1. Identificación

**ID:** `CORR-041`

**Título:** `CORR-041 — ADR-0021 Git Persistence Governance Lifecycle Sync`

**Tipo:** `DOCUMENTATION CORRECTION — GOVERNANCE / GIT PERSISTENCE LIFECYCLE SYNC`

**Naturaleza:** corrección documental controlada, exclusivamente de governance.

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Estado de esta specification:**

```text
CORR-041 SPECIFICATION GENERATION =
PASS

CORR-041 SPEC REVIEW =
APPROVED

CORR-041 SPEC RE-REVIEW =
APPROVED

CORR-041 HUMAN SPEC APPROVAL =
APPROVED

CORR-041 APPROVED ARTIFACT GENERATION =
PASS

CORR-041 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-041 CANONICALIZATION AUTHORIZATION =
APPROVED

CORR-041 CANONICALIZATION =
PASS

CORR-041 CANONICALIZATION REVIEW =
PENDING

F-041-SPEC-001 =
RESOLVED

F-041-SPEC-002 =
RESOLVED

open specification findings =
0
```

**Archivo de entrega:**

```text
CORR-041-adr-0021-git-persistence-governance-lifecycle-sync-canonical.md
```

**Target documental único de futura implementación:**

```text
docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md
```

**Implementación de CORR-041 autorizada:** `NO`

**Implementación realizada:** `NO`

**Repositorio modificado durante esta specification generation:** `NO`

**Codex autorizado:** `NO`

**Staging / commit / push:** `NO / NO / NO`

**Supabase Local mutation:** `NO`

**Supabase Cloud mutation:** `NO`

**TASK-020:** `NOT DETERMINED`

**Phase 2:** `IN PROGRESS / NOT CLOSED`

**Phase 2 Exit Gate:** `NOT YET DEFINED`

**Phase 3:** `NOT STARTED`

Esta specification define exclusivamente el contrato para una futura corrección documental de ADR-0021. No ejecuta la corrección, no modifica ADR-0021, no modifica el repositorio y no autoriza ningún Gate posterior.

---

## 2. Autorización y determinación consumidas

Se consume como autorización formal vigente:

```text
CORR-041 SPECIFICATION GENERATION AUTHORIZATION =
APPROVED
```

Se consume como determinación autoritativa:

```text
POST-ADR-0021 GOVERNANCE LIFECYCLE CORRECTION DETERMINATION =
APPROVED

documentation correction required =
YES

correction class =
DOCUMENTATION CORRECTION — GOVERNANCE / GIT PERSISTENCE LIFECYCLE SYNC

new CORR required =
YES

CORR ID =
CORR-041

affected document =
docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md

affected semantic surface =
GOVERNANCE LIFECYCLE ONLY — §39 / §40 / §41 AS STRICTLY REQUIRED

architecture change =
NO

product change =
NO

security/RLS change =
NO
```

La autorización de generación de esta specification no equivale a aprobación de la specification ni a autorización de implementación.

Debe preservarse:

```text
SPECIFICATION GENERATION AUTHORIZATION
!=
SPEC REVIEW APPROVAL

SPEC REVIEW APPROVAL
!=
HUMAN SPEC APPROVAL

HUMAN SPEC APPROVAL
!=
IMPLEMENTATION AUTHORIZATION
```

---

## 3. Objetivo único

CORR-041 debe definir exclusivamente la corrección documental necesaria para reconciliar el lifecycle de governance de ADR-0021 con la governance Git general del proyecto.

La corrección futura debe eliminar la ambigüedad por la cual el texto actual de ADR-0021 permite leer:

```text
ADR-0021 REPOSITORY INCORPORATION REVIEW
→ NEXT-TASK DETERMINATION BY REVISOR CENTRAL
```

como si `REPOSITORY INCORPORATION REVIEW` cerrara implícitamente la persistencia Git del ADR.

La corrección debe hacer explícito que:

```text
repository incorporation review
!= staged

repository incorporation review
!= committed

repository incorporation review
!= pushed

repository incorporation review
!= remotely durable

repository incorporation review
!= next TASK authorization
```

CORR-041 no debe modificar ninguna decisión arquitectónica, requisito de producto, modelo de seguridad, RLS, Auth, multitenancy, dominio, offline, implementación o phase boundary.

---

## 4. Causa autoritativa

ADR-0021 fue canonicalizado e incorporado físicamente al worktree y su `REPOSITORY INCORPORATION REVIEW` fue aprobado.

Sin embargo, el estado de persistencia Git consumido por esta specification es:

```text
repository artifact state =
UNTRACKED

staging =
NO

commit =
NO

push =
NO

remote persistence =
NO
```

La incorporación física al worktree y su revisión no constituyen persistencia Git.

La governance general exige Gates separados para staging, commit, push y verificación remota.

Por tanto, el lifecycle documentado en ADR-0021 debe ser sincronizado para impedir que el siguiente paso se interprete como `NEXT-TASK DETERMINATION` antes de completar el lifecycle Git requerido.

---

## 5. Target documental único

La futura implementación de CORR-041 puede modificar exactamente un path:

```text
docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md
```

No se autoriza:

- modificar otro documento;
- crear un segundo target;
- actualizar documentos de producto;
- actualizar otra ADR;
- actualizar TASK/CORR;
- modificar código;
- modificar SQL;
- modificar migrations;
- modificar RLS;
- modificar configuración;
- modificar Supabase;
- modificar archivos de tests.

Debe preservarse:

```text
authorized changed-path count =
1
```

Si la corrección necesita un segundo path:

```text
STOP / BLOCKER — ADDITIONAL PATH REQUIRED
```

No ampliar scope silenciosamente.

---

## 6. Superficie semántica máxima

La futura corrección queda limitada a:

```text
§39
§40
§41
```

y únicamente a los fragmentos estrictamente necesarios para reconciliar el governance lifecycle de ADR-0021 con la secuencia Git obligatoria.

No se autoriza cambio semántico fuera de esa superficie.

Si durante la futura ejecución se demuestra que una referencia fuera de §39/§40/§41 debe cambiar para evitar una contradicción interna real:

```text
STOP / BLOCKER — ADDITIONAL DOCUMENT SURFACE REQUIRED
```

La implementación debe detenerse y devolver el hallazgo al Revisor Central.

No se autoriza editar preventivamente otras secciones por consistencia estilística, limpieza, reformulación o mejora editorial.

---

## 7. Disponibilidad e identidad física del source

La futura implementación requiere acceso físico al target real:

```text
docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md
```

Antes de mutarlo debe verificarse desde sus bytes físicos reales, como mínimo:

```text
path
SHA-256
bytes
LF
CRLF
bare CR
trailing-whitespace line count
final newline
```

La identidad física observada debe registrarse como evidencia de pre-mutation.

La implementación no debe reconstruir el archivo desde una copia textual histórica si el target físico real no está disponible.

Si el source físico requerido no está disponible:

```text
BLOCKER — REQUIRED PHYSICAL SOURCE UNAVAILABLE
```

Si existe un archivo con el mismo nombre pero no puede demostrarse que corresponde al target autoritativo esperado:

```text
BLOCKER — REQUIRED PHYSICAL SOURCE IDENTITY UNRESOLVED
```

La ausencia de inspección física durante esta specification generation no autoriza a omitir esta verificación en la futura ejecución.

---

## 8. Baseline Git de contexto

Se consume como evidencia histórica del Gate anterior:

```text
branch =
main

HEAD =
2e0211c6650948754b6cb9b2a5dbb44b34025357

origin/main =
2e0211c6650948754b6cb9b2a5dbb44b34025357

divergence =
0 0

ADR-0021 repository artifact =
UNTRACKED

unexpected paths =
0

staging =
NO

commit =
NO

push =
NO
```

Esta baseline es histórica.

No constituye un baseline ejecutable permanente.

Una futura implementación debe ejecutar fresh Git preflight inmediatamente antes de cualquier modificación y no debe asumir que el repositorio conserva este estado.

---

## 9. Fresh Git preflight obligatorio

Antes de una futura implementación de CORR-041 debe verificarse y registrarse, como mínimo:

```text
repo root
branch
HEAD
origin/main
upstream
divergence
git status --porcelain=v1 --untracked-files=all
staged paths
unstaged paths
untracked paths
ongoing Git operations
```

Debe comprobarse que el estado permite distinguir inequívocamente:

- el ADR-0021 ya incorporado físicamente;
- cualquier cambio previo legítimo;
- el diff exclusivo de CORR-041;
- la inexistencia de paths inesperados.

Si aparece drift Git inesperado que impida demostrar el alcance exacto de la corrección:

```text
BLOCKER — UNEXPECTED GIT DRIFT
```

No limpiar, resetear, descartar, stashar, stagear, commitear ni pushear automáticamente para resolverlo.

---

## 10. Required governance result de ADR-0021

La futura corrección debe exigir que ADR-0021 represente finalmente, de forma inequívoca, el siguiente lifecycle:

```text
ADR-0021 SPEC REVIEW
→ ADR-0021 HUMAN APPROVAL
→ ADR-0021 APPROVED ARTIFACT GENERATION
→ ADR-0021 APPROVED ARTIFACT REVIEW
→ ADR-0021 CANONICALIZATION AUTHORIZATION
→ ADR-0021 CANONICALIZATION
→ ADR-0021 CANONICALIZATION REVIEW
→ ADR-0021 REPOSITORY INCORPORATION AUTHORIZATION
→ ADR-0021 REPOSITORY INCORPORATION
→ ADR-0021 REPOSITORY INCORPORATION REVIEW
→ ADR-0021 STAGING AUTHORIZATION
→ ADR-0021 STAGING
→ ADR-0021 STAGING REVIEW
→ ADR-0021 COMMIT AUTHORIZATION
→ ADR-0021 COMMIT
→ ADR-0021 COMMIT REVIEW
→ ADR-0021 PUSH AUTHORIZATION
→ ADR-0021 PUSH
→ ADR-0021 PUSH REVIEW / REMOTE VERIFICATION
→ NEXT-TASK DETERMINATION BY REVISOR CENTRAL
```

Cada Gate y cada step permanece independiente.

Ningún Gate autoriza, ejecuta, aprueba ni satisface automáticamente el siguiente.

---

## 11. Separaciones obligatorias del lifecycle Git

La futura corrección debe dejar explícitas, como mínimo, las siguientes separaciones:

```text
REPOSITORY INCORPORATION REVIEW
!= STAGING AUTHORIZATION

STAGING AUTHORIZATION
!= STAGING

STAGING
!= STAGING REVIEW

STAGING REVIEW
!= COMMIT AUTHORIZATION

COMMIT AUTHORIZATION
!= COMMIT

COMMIT
!= COMMIT REVIEW

COMMIT REVIEW
!= PUSH AUTHORIZATION

PUSH AUTHORIZATION
!= PUSH

PUSH
!= PUSH REVIEW / REMOTE VERIFICATION

PUSH REVIEW / REMOTE VERIFICATION
!= NEXT-TASK DETERMINATION
```

Debe quedar igualmente inequívoco:

```text
repository incorporation
!= Git staging

Git staging
!= Git commit

Git commit
!= remote persistence

local commit
!= push

push attempt
!= remote verification
```

La persistencia remota sólo queda demostrada después del Gate explícito de:

```text
PUSH REVIEW / REMOTE VERIFICATION
```

---

## 12. Semántica de repository incorporation

Dentro de CORR-041, `REPOSITORY INCORPORATION` conserva el significado ya consumido por la determinación autoritativa: incorporación física del artefacto al worktree/ruta correspondiente.

No debe redefinirse como:

- `git add`;
- staging;
- commit;
- push;
- merge;
- remote persistence;
- next-task authorization.

Debe preservarse:

```text
REPOSITORY INCORPORATION
=
physical repository/worktree incorporation under its authorized path/process

REPOSITORY INCORPORATION
!=
Git persistence completion
```

CORR-041 no crea una nueva definición general de repository incorporation fuera del alcance necesario para corregir ADR-0021.

---

## 13. Arquitectura a preservar

CORR-041 no puede cambiar:

```text
selected architecture =
dedicated LaterUserEnrollmentIntent

ownership =
TENANT-OWNED BUSINESS STATE

RLS =
MANDATORY / PRIMARY REMOTE TENANT ISOLATION BOUNDARY
```

Debe preservarse:

```text
FirstAdminOnboardingIntent
!=
LaterUserEnrollmentIntent
```

Debe preservarse:

```text
TASK-017/018/019 purpose-specific implementation
!=
generic later-user API
```

La corrección de governance no puede reinterpretar la arquitectura de intent binding, ownership, tenant isolation ni la frontera RLS.

Si completar la corrección exigiera cambiar una decisión arquitectónica:

```text
BLOCKER — NEW TECHNICAL CONTRADICTION
```

No resolver la contradicción dentro de CORR-041.

---

## 14. Product / phase boundary a preservar

CORR-041 debe preservar íntegramente:

```text
Client =
Phase 3

RF-015 =
MANDATORY / UNCHANGED

zero client assignment satisfies RF-015 =
NO

pre-Client foundation
!=
complete later-user onboarding

ordinary later-user onboarding =
INCOMPLETE
```

Debe permanecer:

```text
Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED

TASK-020 =
NOT DETERMINED
```

La corrección de governance no puede utilizarse para cerrar funcionalidad de onboarding, anticipar Client, satisfacer RF-015, definir el Gate de salida de Fase 2, cerrar Fase 2, iniciar Fase 3 ni determinar TASK-020.

---

## 15. Deferred product decisions que permanecen abiertas

CORR-041 no puede resolver, precisar ni fijar por inferencia:

```text
exact later-user PlatformUser creation/completion timing
exact later-user profile-completion timing
exact initial CompanyMembership establishment timing
exact later-user USER_CREATED producer timing
final profile/membership/client-scope atomicity
```

Estas decisiones permanecen fuera del alcance de CORR-041.

La corrección no puede convertir wording de governance en una decisión de producto.

---

## 16. Seguridad, RLS y Auth a preservar

Debe preservarse sin cambio:

```text
authenticated != authorized

Auth session != tenant authorization

current authoritative PostgreSQL state
>
stale JWT / cookie / frontend state
```

CORR-041 no puede cambiar:

```text
tenant isolation
RLS model
Auth Admin boundary
VerificationChallenge
SessionGrant
role binding
tenant binding
email binding
purpose binding
idempotency/concurrency
threat model
failure model
offline behavior
```

No se autoriza:

- añadir bypass tenant;
- debilitar RLS;
- introducir autoridad basada en estado frontend;
- modificar la frontera Auth Admin;
- reabrir ADR-0019;
- cambiar VerificationChallenge;
- cambiar SessionGrant;
- cambiar bindings;
- alterar threat/failure models;
- alterar comportamiento offline.

Si la corrección documental necesitara cualquiera de esos cambios:

```text
BLOCKER — NEW TECHNICAL CONTRADICTION
```

---

## 17. Multitenancy a preservar

Debe permanecer:

```text
tenant =
MaintenanceCompany
```

Todo estado tenant-owned sigue sujeto a ownership inequívoco y RLS como frontera primaria remota.

`LaterUserEnrollmentIntent` continúa siendo `TENANT-OWNED BUSINESS STATE`.

CORR-041 no puede:

- cambiar ownership;
- convertir el intent en estado global;
- introducir tenant selection desde frontend;
- introducir cross-tenant access;
- ampliar capacidades de `SUPER_ADMIN`;
- modificar client scope;
- modificar SupportAccessGrant.

---

## 18. Alcance de implementación futura

Una futura implementación de CORR-041 podrá realizar exclusivamente una modificación documental sobre:

```text
docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md
```

y únicamente dentro de:

```text
§39
§40
§41
```

según resulte estrictamente necesario para expresar el lifecycle correcto.

Expected implementation semantic class:

```text
documentation-only
governance-only
no architecture change
no product change
no security/RLS change
```

La implementación no debe:

- reescribir ADR-0021 desde cero;
- reformular secciones no afectadas;
- hacer cleanup estilístico;
- renumerar secciones ajenas;
- modificar ejemplos técnicos no relacionados;
- actualizar estados de implementación;
- determinar TASK-020;
- ejecutar Git persistence del ADR.

---

## 19. Resultado semántico esperado por superficie

### 19.1 §39

La futura implementación sólo podrá modificar §39 si es necesario para eliminar una afirmación o implicación de governance incompatible con la separación de Gates Git exigida.

Debe preservarse todo contenido arquitectónico, funcional, de seguridad y dominio de §39.

Si §39 no requiere cambio para lograr coherencia interna, debe permanecer byte-for-byte salvo efectos inevitables directamente ligados al hunk autorizado y expresamente revisados.

### 19.2 §40

§40 debe representar el lifecycle completo de ADR-0021 sin saltar desde:

```text
ADR-0021 REPOSITORY INCORPORATION REVIEW
```

directamente a:

```text
NEXT-TASK DETERMINATION BY REVISOR CENTRAL
```

Debe insertar explícitamente los Gates y steps de:

```text
STAGING AUTHORIZATION
STAGING
STAGING REVIEW
COMMIT AUTHORIZATION
COMMIT
COMMIT REVIEW
PUSH AUTHORIZATION
PUSH
PUSH REVIEW / REMOTE VERIFICATION
```

antes de `NEXT-TASK DETERMINATION BY REVISOR CENTRAL`.

### 19.3 §41

§41 debe quedar coherente con el lifecycle corregido y no puede declarar, implicar o permitir interpretar que la aprobación del repository incorporation review:

- autoriza staging;
- significa staged;
- autoriza commit;
- significa committed;
- autoriza push;
- significa pushed;
- prueba remote persistence;
- autoriza NEXT-TASK DETERMINATION.

Si §41 contiene estado o Gate wording incompatible con esa separación, podrá corregirse exclusivamente en la medida necesaria.

---

## 20. Prohibición de expansión semántica

CORR-041 no es una oportunidad para actualizar ADR-0021 a un estado posterior distinto de la corrección de governance determinada.

No debe utilizarse para:

- registrar nuevas decisiones;
- completar decisiones deferred;
- actualizar implementación de TASK-017/018/019 fuera de lo estrictamente necesario para preservar contexto;
- anticipar TASK-020;
- definir una nueva arquitectura;
- introducir un nuevo ADR;
- sincronizar documentos externos;
- modificar Phase 2 Exit Gate;
- cambiar el scope de Phase 3.

Cualquier necesidad de ese tipo debe detener esta corrección.

---

## 21. Acceptance Criteria

**AC-041-001.** El artefacto de specification se identifica como `CORR-041`.

**AC-041-002.** El título es exactamente `CORR-041 — ADR-0021 Git Persistence Governance Lifecycle Sync`.

**AC-041-003.** La correction class permanece `DOCUMENTATION CORRECTION — GOVERNANCE / GIT PERSISTENCE LIFECYCLE SYNC`.

**AC-041-004.** La specification declara exactamente un target documental.

**AC-041-005.** El target único es `docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md`.

**AC-041-006.** No se autoriza ningún path adicional.

**AC-041-007.** La superficie semántica máxima queda limitada a §39/§40/§41.

**AC-041-008.** Cualquier necesidad de un path adicional produce `STOP / BLOCKER — ADDITIONAL PATH REQUIRED`.

**AC-041-009.** Cualquier necesidad de una superficie documental adicional produce `STOP / BLOCKER — ADDITIONAL DOCUMENT SURFACE REQUIRED`.

**AC-041-010.** La arquitectura seleccionada `dedicated LaterUserEnrollmentIntent` permanece sin cambios.

**AC-041-011.** `LaterUserEnrollmentIntent` permanece `TENANT-OWNED BUSINESS STATE`.

**AC-041-012.** RLS permanece `MANDATORY / PRIMARY REMOTE TENANT ISOLATION BOUNDARY`.

**AC-041-013.** `FirstAdminOnboardingIntent != LaterUserEnrollmentIntent` permanece sin cambios.

**AC-041-014.** `TASK-017/018/019 purpose-specific implementation != generic later-user API` permanece sin cambios.

**AC-041-015.** No se modifica ningún requisito de producto.

**AC-041-016.** `Client = Phase 3` permanece sin cambios.

**AC-041-017.** `RF-015 = MANDATORY / UNCHANGED`.

**AC-041-018.** `zero client assignment satisfies RF-015 = NO`.

**AC-041-019.** `pre-Client foundation != complete later-user onboarding`.

**AC-041-020.** `ordinary later-user onboarding = INCOMPLETE`.

**AC-041-021.** `Phase 2 = IN PROGRESS / NOT CLOSED`.

**AC-041-022.** `Phase 2 Exit Gate = NOT YET DEFINED`.

**AC-041-023.** `Phase 3 = NOT STARTED`.

**AC-041-024.** `TASK-020 = NOT DETERMINED`.

**AC-041-025.** Ninguna deferred product decision enumerada por CORR-041 es resuelta.

**AC-041-026.** `authenticated != authorized` permanece sin cambios.

**AC-041-027.** `Auth session != tenant authorization` permanece sin cambios.

**AC-041-028.** `current authoritative PostgreSQL state > stale JWT / cookie / frontend state` permanece sin cambios.

**AC-041-029.** Tenant isolation permanece sin cambios.

**AC-041-030.** El modelo RLS permanece sin cambios.

**AC-041-031.** Auth Admin boundary permanece sin cambios.

**AC-041-032.** VerificationChallenge y SessionGrant permanecen sin cambios.

**AC-041-033.** Role, tenant, email y purpose binding permanecen sin cambios.

**AC-041-034.** Idempotency/concurrency, threat model, failure model y offline behavior permanecen sin cambios.

**AC-041-035.** `REPOSITORY INCORPORATION REVIEW != STAGING AUTHORIZATION`.

**AC-041-036.** `STAGING AUTHORIZATION != STAGING`.

**AC-041-037.** `STAGING != STAGING REVIEW`.

**AC-041-038.** `STAGING REVIEW != COMMIT AUTHORIZATION`.

**AC-041-039.** `COMMIT AUTHORIZATION != COMMIT`.

**AC-041-040.** `COMMIT != COMMIT REVIEW`.

**AC-041-041.** `COMMIT REVIEW != PUSH AUTHORIZATION`.

**AC-041-042.** `PUSH AUTHORIZATION != PUSH`.

**AC-041-043.** `PUSH != PUSH REVIEW / REMOTE VERIFICATION`.

**AC-041-044.** `PUSH REVIEW / REMOTE VERIFICATION != NEXT-TASK DETERMINATION`.

**AC-041-045.** Repository incorporation review no se presenta como staged.

**AC-041-046.** Repository incorporation review no se presenta como committed.

**AC-041-047.** Repository incorporation review no se presenta como pushed.

**AC-041-048.** Repository incorporation review no se presenta como remotely durable.

**AC-041-049.** Repository incorporation review no se presenta como next TASK authorization.

**AC-041-050.** El staging Gate queda explícito.

**AC-041-051.** El commit Gate queda explícito.

**AC-041-052.** El push Gate queda explícito.

**AC-041-053.** El remote verification Gate queda explícito.

**AC-041-054.** `NEXT-TASK DETERMINATION BY REVISOR CENTRAL` permanece como Gate separado y posterior a remote verification.

**AC-041-055.** La futura ejecución realiza fresh Git preflight.

**AC-041-056.** La futura ejecución verifica la identidad física del target antes de mutarlo.

**AC-041-057.** La futura implementación produce exactamente un changed path.

**AC-041-058.** El diff completo del target es inspeccionado.

**AC-041-059.** Los hunks semánticos quedan confinados a la superficie autorizada.

**AC-041-060.** La verificación de whitespace/errors debe ejecutarse sobre el delta real completo entre la baseline física pre-mutation y el ADR-0021 post-mutation; un `git diff --check` ordinario que no inspeccione el target `UNTRACKED` no satisface este criterio. Cuando se utilice `git diff --no-index --check`, un exit status no cero causado exclusivamente por diferencias entre los archivos no constituye por sí mismo un fallo de whitespace/errors; la aceptación debe basarse en la ausencia de diagnostics de whitespace/error reportados por Git, o en un mecanismo comprobable equivalente que inspeccione el delta real completo.

**AC-041-061.** No existen unexpected paths.

**AC-041-062.** Fuera de la superficie governance autorizada no existe drift semántico.

**AC-041-063.** La futura review confirma ausencia de architecture drift.

**AC-041-064.** La futura review confirma ausencia de product drift.

**AC-041-065.** La futura review confirma ausencia de security/RLS/Auth drift.

**AC-041-066.** Durante esta specification generation no se modifica el repositorio.

**AC-041-067.** Durante esta specification generation no se usa Codex.

**AC-041-068.** Durante esta specification generation no se implementa CORR-041.

**AC-041-069.** Durante esta specification generation no se modifica físicamente ADR-0021.

**AC-041-070.** Durante esta specification generation no se realiza staging.

**AC-041-071.** Durante esta specification generation no se realiza commit.

**AC-041-072.** Durante esta specification generation no se realiza push.

**AC-041-073.** Durante esta specification generation no se modifica Supabase Local.

**AC-041-074.** Durante esta specification generation no se modifica Supabase Cloud.

**AC-041-075.** Esta specification no determina TASK-020.

**AC-041-076.** Esta specification no autoriza next TASK.

**AC-041-077.** Esta specification no define Phase 2 Exit Gate.

**AC-041-078.** Esta specification no cierra Phase 2.

**AC-041-079.** Esta specification no inicia Phase 3.

**AC-041-080.** El siguiente Gate después de esta generation es exclusivamente `CORR-041 SPEC REVIEW`.

**AC-041-081.** Antes de cualquier futura mutación de ADR-0021, sus bytes físicos reales se capturan como una baseline temporal e inmutable de review, registrando SHA-256, bytes y métricas de line endings; esa baseline no se crea como segundo path dentro del repositorio, no modifica Git state y no puede reconstruirse desde memoria.

**AC-041-082.** Para el ADR-0021 actualmente `UNTRACKED`, la futura implementación/review produce un delta completo y revisable entre la baseline pre-mutation y el target post-mutation mediante `git diff --no-index` o mecanismo byte/text equivalente; todos los hunks son revisables y permiten demostrar `changed semantic surfaces = §39 / §40 / §41 ONLY`.

**AC-041-083.** Un `git diff` ordinario contra `HEAD` vacío o incompleto como consecuencia del estado `UNTRACKED` de ADR-0021 es evidencia insuficiente y no puede satisfacer implementation review.

**AC-041-084.** La baseline temporal usada sólo para comparación permanece fuera del repository working tree o se elimina sin alterar el scope autorizado; no se stagea, no se commitea y no se pushea.

**AC-041-085.** `non-zero exit caused solely by detected file differences != whitespace/error failure`; la futura implementation/review no exige ingenuamente exit code `0` de `git diff --no-index --check` cuando el delta legítimamente contiene diferencias.

**AC-041-086.** Si se utiliza `git diff --no-index --check`, `whitespace/error verification = PASS` sólo cuando no existen whitespace/error diagnostics reportados por Git sobre el delta real completo; puede utilizarse un mecanismo comprobable equivalente con la misma cobertura.

---

## 22. Test / review strategy para futura implementación

La futura implementación y su review deben incluir, como mínimo, las siguientes verificaciones.

### 22.1 Pre-mutation

Registrar:

```text
fresh Git preflight
target existence
target physical identity
target SHA-256
target byte size
target LF count
target CRLF count
target bare CR count
target trailing-whitespace line count
target final newline
pre-mutation physical target bytes =
CAPTURED AS IMMUTABLE REVIEW BASELINE
```

La baseline pre-mutation debe derivarse exclusivamente de los bytes físicos reales del target antes de cualquier mutación. Debe conservar exactamente el contenido necesario para una comparación completa posterior y registrar la identidad física indicada arriba.

La baseline es temporal y sólo sirve como evidencia de comparación. Debe permanecer fuera del repository working tree o ser eliminada después de obtener y preservar la evidencia necesaria. No puede:

- crearse como segundo path dentro del repositorio;
- modificar Git state;
- ser staged;
- ser committed;
- ser pushed;
- sustituirse por contenido reconstruido desde memoria, conversación o una representación regenerada.

Confirmar que el target es el único path autorizado.

### 22.2 Diff inspection

Después de la mutación documental:

1. comparar la baseline física pre-mutation contra el ADR-0021 post-mutation;
2. producir el delta completo y revisable mediante `git diff --no-index <pre-mutation-baseline> <post-mutation-target>` o mecanismo byte/text equivalente que incluya el contenido del target aunque ADR-0021 permanezca `UNTRACKED`;
3. conservar evidencia suficiente para revisar todos los hunks del delta real;
4. contar changed paths y confirmar `changed-path count = 1`;
5. revisar cada hunk;
6. confirmar que cada cambio semántico cae dentro de §39/§40/§41;
7. confirmar que el cambio se limita a governance lifecycle;
8. confirmar ausencia de rewording no necesario;
9. verificar whitespace/errors sobre ese mismo delta real completo, mediante `git diff --no-index --check <pre-mutation-baseline> <post-mutation-target>` o mecanismo comprobable equivalente; si se utiliza `git diff --no-index --check`, interpretar separadamente el exit status asociado a diferencias del contenido y los diagnostics de whitespace/error: un exit status no cero causado exclusivamente porque los archivos difieren no equivale a fallo de whitespace/errors, y la aceptación se determina por la ausencia de whitespace/error diagnostics reportados por Git sobre el delta real completo;
10. registrar `git status --porcelain=v1 --untracked-files=all`;
11. confirmar que no aparecieron unexpected paths;
12. confirmar que la baseline temporal no se convirtió en repository path, no fue staged, committed ni pushed.

Debe quedar explícito:

```text
ordinary git diff against HEAD
while ADR-0021 is untracked
=
INSUFFICIENT IMPLEMENTATION EVIDENCE
```

Por tanto:

```text
ordinary empty git diff caused by untracked status
cannot satisfy implementation review =
YES
```

y:

```text
untracked ADR-0021 mutation has a complete pre/post diff =
YES
```

No puede aceptarse:

```text
git diff --check =
PASS
```

como evidencia suficiente si el comando no inspeccionó el target `UNTRACKED` y no verificó el delta real pre/post.

La futura implementation/review no debe aplicar la regla ingenua `process exit code != 0 → whitespace/error verification FAIL` a `git diff --no-index --check`. Debe distinguir un non-zero exit causado únicamente por diferencias legítimas entre baseline y target de un diagnóstico real de whitespace/error. Un delta legítimamente distinto puede producir exit status no cero sin que exista whitespace/error failure.

### 22.3 Semantic preservation review

Debe verificarse expresamente:

```text
architecture unchanged
product requirements unchanged
domain unchanged
security unchanged
RLS unchanged
multitenancy unchanged
Auth architecture unchanged
offline behavior unchanged
Client phase unchanged
RF-015 unchanged
deferred decisions unresolved
TASK-020 not determined
Phase 2 not closed
Phase 3 not started
```

### 22.4 Governance review

Debe comprobarse que el texto resultante de ADR-0021 representa el lifecycle completo y que no existe ningún salto indebido entre:

```text
REPOSITORY INCORPORATION REVIEW
```

y:

```text
NEXT-TASK DETERMINATION BY REVISOR CENTRAL
```

Los nueve steps/Gates Git intermedios deben estar representados explícitamente en el orden autorizado.

---

## 23. Criterio de semantic hunk confinement

Un hunk se considera dentro de alcance sólo si su efecto semántico es necesario para una de estas finalidades:

1. separar repository incorporation review de staging;
2. añadir o hacer explícito staging authorization;
3. añadir o hacer explícito staging;
4. añadir o hacer explícito staging review;
5. añadir o hacer explícito commit authorization;
6. añadir o hacer explícito commit;
7. añadir o hacer explícito commit review;
8. añadir o hacer explícito push authorization;
9. añadir o hacer explícito push;
10. añadir o hacer explícito push review / remote verification;
11. mantener next-task determination como Gate posterior e independiente;
12. eliminar una contradicción interna directa causada por el lifecycle anterior dentro de §39/§40/§41.

No se considera dentro de alcance un cambio cuyo propósito principal sea estilo, claridad general, reformatting, actualización técnica, actualización funcional o sincronización de otro estado.

---

## 24. Blockers obligatorios

### 24.1 Source físico no disponible

Si el target físico no puede leerse:

```text
BLOCKER — REQUIRED PHYSICAL SOURCE UNAVAILABLE
```

### 24.2 Git drift inesperado

Si el preflight muestra drift que impide aislar con certeza el diff autorizado:

```text
BLOCKER — UNEXPECTED GIT DRIFT
```

### 24.3 Path adicional requerido

Si completar correctamente la corrección exige modificar otro path:

```text
STOP / BLOCKER — ADDITIONAL PATH REQUIRED
```

### 24.4 Superficie documental adicional requerida

Si completar correctamente la corrección exige un cambio semántico fuera de §39/§40/§41:

```text
STOP / BLOCKER — ADDITIONAL DOCUMENT SURFACE REQUIRED
```

### 24.5 Cambio arquitectónico, de producto o seguridad requerido

Si la corrección revela que el lifecycle no puede reconciliarse sin cambiar arquitectura, producto, dominio, seguridad, RLS, Auth, multitenancy u offline:

```text
BLOCKER — NEW TECHNICAL CONTRADICTION
```

### 24.6 TASK-020 requerido para completar la corrección

Si la corrección pareciera necesitar determinar TASK-020:

```text
BLOCKER — TASK-020 DETERMINATION WOULD BE REQUIRED
```

CORR-041 no puede determinar TASK-020.

### 24.7 Contradicción con decisión canónica

Si aparece una decisión canónica vigente que contradice materialmente el lifecycle exigido por la determinación de CORR-041:

```text
BLOCKER — CANONICAL DECISION CONTRADICTION
```

No resolver por inferencia.

### 24.8 Target identity no demostrable

Si el archivo existe pero su identidad o autoridad no puede establecerse:

```text
BLOCKER — REQUIRED PHYSICAL SOURCE IDENTITY UNRESOLVED
```

### 24.9 Evidencia pre/post completa del target untracked no demostrable

Si antes de mutar ADR-0021 no se capturó desde sus bytes físicos reales una baseline inmutable apta para review, si esa baseline modificó Git state o fue creada como segundo path dentro del repositorio, o si después de la mutación no puede producirse y revisarse el delta completo baseline-vs-target por el estado `UNTRACKED`, el resultado obligatorio es:

```text
BLOCKER — UNTRACKED TARGET COMPLETE DIFF EVIDENCE UNAVAILABLE
```

Un `git diff` ordinario contra `HEAD` vacío por tratarse de un archivo `UNTRACKED`, o un `git diff --check` que no haya inspeccionado el delta real pre/post, no resuelve este blocker. Tampoco constituye blocker ni whitespace/error failure un exit status no cero de `git diff --no-index --check` cuando dicho status se debe exclusivamente a que baseline y target contienen diferencias; el blocker sólo puede derivarse de diagnostics reales de whitespace/error o de la imposibilidad de verificarlos sobre el delta completo mediante Git o mecanismo comprobable equivalente.

---

## 25. Failure behavior

Ante cualquier blocker:

1. detener la ejecución;
2. no ampliar alcance;
3. no modificar otro path;
4. no corregir decisiones no autorizadas;
5. no realizar staging;
6. no realizar commit;
7. no realizar push;
8. no determinar TASK-020;
9. reportar evidencia suficiente al Revisor Central.

Una ejecución bloqueada no debe intentar “completar parcialmente” el lifecycle Git del ADR.

---

## 26. Governance lifecycle de CORR-041

La secuencia mínima obligatoria de CORR-041 es:

```text
CORR-041 SPEC REVIEW
→ CORR-041 HUMAN SPEC APPROVAL
→ CORR-041 APPROVED ARTIFACT GENERATION
→ CORR-041 APPROVED ARTIFACT REVIEW
→ CORR-041 CANONICALIZATION AUTHORIZATION
→ CORR-041 CANONICALIZATION
→ CORR-041 CANONICALIZATION REVIEW
→ CORR-041 REPOSITORY INCORPORATION AUTHORIZATION
→ CORR-041 REPOSITORY INCORPORATION
→ CORR-041 REPOSITORY INCORPORATION REVIEW
→ CORR-041 IMPLEMENTATION AUTHORIZATION
→ CORR-041 IMPLEMENTATION
→ CORR-041 IMPLEMENTATION REVIEW
→ ADR-0021 STAGING AUTHORIZATION
```

Ninguno de estos Gates se ejecuta dentro de esta specification generation.

Cada Gate requiere acto separado.

Debe preservarse:

```text
CORR-041 REPOSITORY INCORPORATION REVIEW
!=
CORR-041 IMPLEMENTATION AUTHORIZATION

CORR-041 IMPLEMENTATION REVIEW
!=
ADR-0021 STAGING AUTHORIZATION
```

---

## 27. Reanudación del lifecycle Git de ADR-0021

La futura implementación de CORR-041 corrige el documento ADR-0021.

Sólo después de:

```text
CORR-041 IMPLEMENTATION REVIEW =
APPROVED
```

puede el Revisor Central considerar el siguiente Gate:

```text
ADR-0021 STAGING AUTHORIZATION
```

CORR-041 no autoriza por sí misma staging de ADR-0021.

Luego deben permanecer separados:

```text
ADR-0021 STAGING AUTHORIZATION
→ ADR-0021 STAGING
→ ADR-0021 STAGING REVIEW
→ ADR-0021 COMMIT AUTHORIZATION
→ ADR-0021 COMMIT
→ ADR-0021 COMMIT REVIEW
→ ADR-0021 PUSH AUTHORIZATION
→ ADR-0021 PUSH
→ ADR-0021 PUSH REVIEW / REMOTE VERIFICATION
→ NEXT-TASK DETERMINATION BY REVISOR CENTRAL
```

---

## 28. Explicit non-implications

Debe quedar normativamente claro:

```text
CORR-041 SPEC REVIEW = APPROVED
!=
CORR-041 HUMAN SPEC APPROVAL

CORR-041 HUMAN SPEC APPROVAL = APPROVED
!=
CORR-041 APPROVED ARTIFACT GENERATED

CORR-041 APPROVED ARTIFACT GENERATION = PASS
!=
CORR-041 APPROVED ARTIFACT REVIEW = APPROVED

CORR-041 APPROVED ARTIFACT REVIEW = APPROVED
!=
CORR-041 CANONICALIZATION AUTHORIZATION

CORR-041 CANONICALIZATION = PASS
!=
CORR-041 CANONICALIZATION REVIEW = APPROVED

CORR-041 CANONICALIZATION REVIEW = APPROVED
!=
CORR-041 REPOSITORY INCORPORATION AUTHORIZATION

CORR-041 REPOSITORY INCORPORATION REVIEW = APPROVED
!=
CORR-041 IMPLEMENTATION AUTHORIZATION

CORR-041 IMPLEMENTATION REVIEW = APPROVED
!=
ADR-0021 STAGING AUTHORIZATION

ADR-0021 PUSH REVIEW / REMOTE VERIFICATION = APPROVED
!=
NEXT-TASK DETERMINATION automatically
```

La determinación del siguiente TASK continúa perteneciendo exclusivamente al Revisor Central mediante Gate separado.

---

## 29. Definition of Done

CORR-041 sólo puede considerarse completada cuando todos los pasos siguientes hayan ocurrido mediante Gates separados y aprobados:

**DoD-041-001.** `CORR-041 SPEC REVIEW = APPROVED`.

**DoD-041-002.** `CORR-041 HUMAN SPEC APPROVAL = APPROVED`.

**DoD-041-003.** Se genera un artefacto aprobado de CORR-041 a partir de la specification human-approved.

**DoD-041-004.** `CORR-041 APPROVED ARTIFACT REVIEW = APPROVED`.

**DoD-041-005.** `CORR-041 CANONICALIZATION AUTHORIZATION = APPROVED`.

**DoD-041-006.** CORR-041 es canonicalizada mediante step separado.

**DoD-041-007.** `CORR-041 CANONICALIZATION REVIEW = APPROVED`.

**DoD-041-008.** `CORR-041 REPOSITORY INCORPORATION AUTHORIZATION = APPROVED`.

**DoD-041-009.** El artefacto canónico de CORR-041 es incorporado al repositorio mediante step separado.

**DoD-041-010.** `CORR-041 REPOSITORY INCORPORATION REVIEW = APPROVED`.

**DoD-041-011.** `CORR-041 IMPLEMENTATION AUTHORIZATION = APPROVED`.

**DoD-041-012.** Se realiza fresh Git preflight antes de mutar ADR-0021.

**DoD-041-013.** Se verifica la identidad física de ADR-0021 antes de mutarlo y sus bytes físicos pre-mutation se capturan como baseline temporal e inmutable de review, con SHA-256, bytes y métricas de line endings, sin crear un segundo repository path ni modificar Git state.

**DoD-041-014.** La implementación modifica exactamente un path.

**DoD-041-015.** El único path modificado es `docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md`.

**DoD-041-016.** Todos los cambios semánticos están confinados a §39/§40/§41.

**DoD-041-017.** El lifecycle de ADR-0021 incluye todos los Gates Git requeridos antes de next-task determination.

**DoD-041-018.** `REPOSITORY INCORPORATION REVIEW != STAGING AUTHORIZATION` queda inequívoco.

**DoD-041-019.** Staging authorization, staging y staging review quedan separados.

**DoD-041-020.** Commit authorization, commit y commit review quedan separados.

**DoD-041-021.** Push authorization, push y push review / remote verification quedan separados.

**DoD-041-022.** `PUSH REVIEW / REMOTE VERIFICATION != NEXT-TASK DETERMINATION` queda inequívoco.

**DoD-041-023.** La verificación de whitespace/errors pasa sobre el delta real completo baseline-pre-mutation vs ADR-0021-post-mutation mediante `git diff --no-index --check` o mecanismo comprobable equivalente; un `git diff --check` ordinario que no inspeccione el target `UNTRACKED` es insuficiente. Si se utiliza `git diff --no-index --check`, un exit status no cero causado exclusivamente por diferencias entre baseline y target no se interpreta como whitespace/error failure; el PASS se determina por ausencia de whitespace/error diagnostics reportados por Git sobre el delta real completo, o por evidencia equivalente comprobable.

**DoD-041-024.** No existen unexpected paths.

**DoD-041-025.** La implementation review verifica el diff completo baseline-vs-post-mutation del ADR-0021 `UNTRACKED` y revisa todos sus hunks.

**DoD-041-026.** La implementation review confirma ausencia de architecture drift.

**DoD-041-027.** La implementation review confirma ausencia de product drift.

**DoD-041-028.** La implementation review confirma ausencia de security/RLS/Auth drift.

**DoD-041-029.** Client permanece Phase 3.

**DoD-041-030.** RF-015 permanece obligatorio e inalterado.

**DoD-041-031.** Zero client assignment no satisface RF-015.

**DoD-041-032.** Ordinary later-user onboarding permanece incomplete.

**DoD-041-033.** Todas las deferred product decisions de esta specification permanecen sin resolver.

**DoD-041-034.** `Phase 2 = IN PROGRESS / NOT CLOSED`.

**DoD-041-035.** `Phase 2 Exit Gate = NOT YET DEFINED`.

**DoD-041-036.** `Phase 3 = NOT STARTED`.

**DoD-041-037.** `TASK-020 = NOT DETERMINED`.

**DoD-041-038.** `CORR-041 IMPLEMENTATION REVIEW = APPROVED`.

**DoD-041-039.** El siguiente Gate tras implementation review es únicamente `ADR-0021 STAGING AUTHORIZATION`.

**DoD-041-040.** No se ejecuta staging de ADR-0021 sin autorización explícita separada.

**DoD-041-041.** No se ejecuta commit de ADR-0021 sin autorización explícita separada y staging review aprobado.

**DoD-041-042.** No se ejecuta push de ADR-0021 sin autorización explícita separada y commit review aprobado.

**DoD-041-043.** No se considera remote persistence demostrada antes de `PUSH REVIEW / REMOTE VERIFICATION`.

**DoD-041-044.** No se determina el siguiente TASK automáticamente después de remote verification.

**DoD-041-045.** `untracked ADR-0021 mutation has a complete pre/post diff = YES`.

**DoD-041-046.** `ordinary empty git diff caused by untracked status cannot satisfy implementation review = YES`.

**DoD-041-047.** La baseline temporal de comparación no se convierte en repository path, no se stagea, no se commitea y no se pushea; al finalizar la comparación queda eliminada o permanece fuera del repository working tree.

**DoD-041-048.** La evidencia del delta completo permite demostrar `changed semantic surfaces = §39 / §40 / §41 ONLY`, `architecture drift = NO`, `product drift = NO` y `security/RLS/Auth drift = NO`.

**DoD-041-049.** `non-zero exit caused solely by detected file differences != whitespace/error failure` queda aplicado explícitamente a `git diff --no-index --check`; no se exige ingenuamente exit code `0` cuando el delta contiene diferencias legítimas.

**DoD-041-050.** La review conserva evidencia de que la verificación de whitespace/errors inspeccionó el delta real completo y fue evaluada por absence of whitespace/error diagnostics de Git o mecanismo comprobable equivalente.

Current minimal specification correction state:

```text
CORR-041 MINIMAL SPECIFICATION CORRECTION =
PASS

F-041-SPEC-001 =
RESOLVED

F-041-SPEC-002 =
RESOLVED

CORR-041 SPEC REVIEW =
APPROVED

CORR-041 SPEC RE-REVIEW =
APPROVED

CORR-041 HUMAN SPEC APPROVAL =
APPROVED

CORR-041 APPROVED ARTIFACT GENERATION =
PASS

CORR-041 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-041 CANONICALIZATION AUTHORIZATION =
APPROVED

CORR-041 CANONICALIZATION =
PASS

CORR-041 CANONICALIZATION REVIEW =
PENDING

open specification findings =
0
```

---

## 30. Prohibiciones durante specification generation

Durante la generación de esta specification:

- NO modificar repositorio.
- NO usar Codex.
- NO implementar CORR-041.
- NO modificar físicamente ADR-0021.
- NO hacer staging.
- NO hacer commit.
- NO hacer push.
- NO modificar Supabase Local.
- NO modificar Supabase Cloud.
- NO determinar TASK-020.
- NO autorizar next TASK.
- NO definir Phase 2 Exit Gate.
- NO cerrar Phase 2.
- NO iniciar Phase 3.
- NO crear un nuevo ADR.
- NO resolver deferred product decisions.
- NO ampliar target.
- NO ampliar superficie semántica.

Estas prohibiciones permanecen satisfechas por esta generation.

---

## 31. Estado al finalizar esta canonicalization

```text
CORR-041 SPECIFICATION GENERATION =
PASS

CORR-041 SPEC REVIEW =
APPROVED

CORR-041 SPEC RE-REVIEW =
APPROVED

CORR-041 HUMAN SPEC APPROVAL =
APPROVED

CORR-041 APPROVED ARTIFACT GENERATION =
PASS

CORR-041 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-041 CANONICALIZATION AUTHORIZATION =
APPROVED

CORR-041 CANONICALIZATION =
PASS

CORR-041 CANONICALIZATION REVIEW =
PENDING

F-041-SPEC-001 =
RESOLVED

F-041-SPEC-002 =
RESOLVED

open specification findings =
0

approved artifact =
CORR-041-adr-0021-git-persistence-governance-lifecycle-sync-approved.md

canonical artifact =
CORR-041-adr-0021-git-persistence-governance-lifecycle-sync-canonical.md

CORR-041 CANONICALIZATION = PASS
!=
CORR-041 CANONICALIZATION REVIEW = APPROVED

CORR-041 repository incorporation =
NOT AUTHORIZED / NOT PERFORMED

CORR-041 implementation =
NOT AUTHORIZED / NOT PERFORMED

ADR-0021 staging =
NO

ADR-0021 commit =
NO

ADR-0021 push =
NO

ADR-0021 remote persistence =
NO

repository modified =
NO

Codex =
NOT USED

Supabase Local mutation =
NO

Supabase Cloud mutation =
NO

TASK-020 =
NOT DETERMINED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED
```

---

## 32. Siguiente Gate exclusivo

El único siguiente Gate posterior a esta canonicalization es:

```text
CORR-041 CANONICALIZATION REVIEW

DESTINO =
REVISOR CENTRAL
```

No se autoriza ningún otro paso.

STOP.
