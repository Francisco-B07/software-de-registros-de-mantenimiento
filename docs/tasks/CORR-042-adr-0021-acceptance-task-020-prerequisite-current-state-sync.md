# CORR-042 — ADR-0021 Acceptance and TASK-020 Prerequisite Current-State Sync

## 1. Identificación

**ID:** `CORR-042`

**Título:** `CORR-042 — ADR-0021 Acceptance and TASK-020 Prerequisite Current-State Sync`

**Tipo:** `CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO / CURRENT-STATE SYNCHRONIZATION`

**Naturaleza:** exclusivamente documental.

**Estado de esta specification:** `APPROVED`

**CORR-042 SPEC REVIEW:** `APPROVED`

**CORR-042 HUMAN APPROVAL:** `APPROVED`

**CORR-042 specification:** `APPROVED`

**CORR-042 APPROVED ARTIFACT REVIEW:** `APPROVED`

**Canonical artifact:** `GENERATED / PENDING CANONICALIZATION REVIEW`

**Archivo de entrega:** `CORR-042-adr-0021-acceptance-task-020-prerequisite-current-state-sync-canonical.md`

**Ruta canónica futura propuesta:**

`docs/tasks/CORR-042-adr-0021-acceptance-task-020-prerequisite-current-state-sync.md`

La ruta futura sólo podrá utilizarse después de los Gates separados de review, aprobación, canonicalización e incorporación al repositorio.

**Implementación realizada por esta specification:** `NO`

**Repositorio modificado por esta specification:** `NO`

**Supabase Local modificado:** `NO`

**Supabase Cloud modificado:** `NO`

**Codex utilizado:** `NO`

**TASK-020 specification generada:** `NO`

**TASK-020 implementación autorizada:** `NO`

---

## 2. Objetivo único

CORR-042 tiene como objetivo exclusivo sincronizar el estado activo documental producido por la combinación de:

- `ADR-0021 HUMAN APPROVAL = APPROVED`;
- incorporación/canonicalización posterior de ADR-0021;
- `ADR-0021 PUSH REVIEW / REMOTE VERIFICATION = APPROVED`;
- `ADR-0021 remote persistence = VERIFIED`;
- `CORR-041 = DONE / CLOSED`;
- `POST-ADR-0021 NEXT-TASK DETERMINATION = APPROVED`;
- `TASK-020 = DETERMINED`;
- `TASK-020 specification = NOT GENERATED`;
- `TASK-020 implementation = NOT AUTHORIZED`.

La corrección debe eliminar exclusivamente el drift de current-state que todavía:

1. no registra ADR-0021 en el registro arquitectónico vigente;
2. no registra su prerequisite de Fase 2 para la foundation ordinaria pre-Client;
3. mantiene los conteos arquitectónicos en `20 / ACCEPTED 9`;
4. mantiene en la superficie activa final de Fase 2:
   - `next TASK = NOT DETERMINED`;
   - `TASK-020 = NOT DETERMINED`;
   - ausencia del estado aceptado/persistido de ADR-0021;
   - ausencia del cierre de CORR-041;
   - ausencia del prerequisite arquitectónico resuelto para TASK-020.

Debe preservarse la regla:

```text
state synchronization
!=
TASK-020 specification
!=
TASK-020 implementation authorization
```

CORR-042 no diseña ni implementa la capability de TASK-020.

---

## 3. Estado formal consumido

Esta specification consume como estado autoritativo ya determinado:

```text
ADR-0021 architecture decision =
ACCEPTED / HUMAN APPROVED under the existing project meaning

ADR-0021 PUSH REVIEW / REMOTE VERIFICATION =
APPROVED

ADR-0021 remote persistence =
VERIFIED

ADR-0021 remote commit =
408e71ae40e8a9cf49a88b8320f629ecbe4b1b81

CORR-041 =
DONE / CLOSED

POST-ADR-0021 NEXT-TASK DETERMINATION =
APPROVED

TASK-020 =
DETERMINED

TASK-020 title =
TASK-020 — Authoritative Later-User Enrollment Intent, Verification and Handoff Foundation

TASK-020 specification =
NOT GENERATED

TASK-020 implementation =
NOT AUTHORIZED

Codex for TASK-020 =
NOT AUTHORIZED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED
```

También se preserva:

```text
Client =
Phase 3

RF-015 =
MANDATORY / UNCHANGED

zero client assignment satisfies RF-015 =
NO

ordinary later-user onboarding =
INCOMPLETE

physical UserClientAccess required before Phase 2 close =
NO

physical/full SupportAccessGrant required before Phase 2 close =
NO

pre-Client later-user onboarding foundation split =
YES

move minimal Client into Phase 2 =
NO
```

---

## 4. Fuentes normativas y de continuidad

### 4.1 Fuentes arquitectónicas y de estado

CORR-042 consume como mínimo:

- `docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md`;
- `docs/tasks/CORR-041-adr-0021-git-persistence-governance-lifecycle-sync.md`;
- `docs/tasks/CORR-039-phase-2-phase-3-client-scope-boundary-documentation-sync.md`;
- `docs/tasks/CORR-040-task-019-closure-current-state-documentation-sync.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`.

### 4.2 Precedente de governance

Se consume además:

- `docs/tasks/CORR-027-adr-0020-acceptance-documentation-state-sync.md`.

CORR-027 se utiliza exclusivamente como precedente de:

- separación entre acceptance de ADR y state synchronization;
- actualización del registro arquitectónico;
- preservación de snapshots históricos;
- disciplina de targets/superficies;
- no autorización automática de la siguiente TASK.

No se copian requisitos específicos de ADR-0020.

### 4.3 Orden de autoridad

Debe preservarse:

1. decisiones humanas explícitas posteriores y no sustituidas;
2. producto aprobado;
3. ADR aceptados dentro de su alcance;
4. current-state posterior aprobado;
5. snapshots históricos únicamente como historia.

Una referencia histórica correcta en su momento no se reescribe sólo porque exista un estado posterior.

---

## 5. Verificación física de fuentes recuperadas

### 5.1 SOURCE A — Architecture Decisions Registry

Path:

`docs/product/10-architecture-decisions-records.md`

Identidad física recuperada:

```text
SHA-256 =
20597fc5adac727869155097cbb35833a79de7cbe0d093604744c130d70d0153

bytes =
73085

LF =
1937

CRLF =
0

bare CR =
0

trailing-whitespace lines =
19

final newline =
YES
```

La SOURCE A es posterior a CORR-027 porque contiene:

- catálogo vigente de `20 ADR`;
- `ADR-0020` en el catálogo;
- `ADR-0020 = ACCEPTED`;
- mapping de Fase 2 para ADR-0020;
- distribución vigente `ACCEPTED = 9`.

Por tanto:

```text
SOURCE A =
POST-CORR-027 CURRENT ARCHITECTURE REGISTRY
```

### 5.2 SOURCE B — Active Phase / Project Current-State

Path:

`docs/product/11-phase-1-scope-entry-gate.md`

Identidad física recuperada:

```text
SHA-256 =
3aa454cd044336c9733120aa1837698c9f81093cb5759be4c37c097fd11ff8df

bytes =
100312

LF =
1615

CRLF =
0

bare CR =
0

trailing-whitespace lines =
9

final newline =
YES
```

La SOURCE B es posterior a CORR-039/CORR-040 porque su §17 activo contiene:

```text
TASK-019 =
CLOSED

TASK-019 HUMAN CLOSURE =
APPROVED

CORR-039 =
CLOSED

Client =
Phase 3

ordinary later-user onboarding =
INCOMPLETE

pre-Client later-user onboarding foundation =
INCOMPLETE

TASK-020 =
NOT DETERMINED
```

Por tanto:

```text
SOURCE B =
POST-CORR-039 / POST-CORR-040 CURRENT PHASE STATE
```

### 5.3 SOURCE CORR-027

La fuente física recuperada del precedente tiene:

```text
SHA-256 =
6f06a02301aa0a1d8372f4d7512ba384d436a94dae4a51047be96b3230907fff

bytes =
45906

LF =
1794

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES
```

### 5.4 Blocker de recuperación

```text
CORR-042 CURRENT TARGET SOURCE BLOCKER =
RESOLVED
```

No se reconstruye ninguna fuente desde memoria ni desde diffs históricos.

---

## 6. Auditoría de drift y clasificación de superficies

La auditoría se realiza sobre las fuentes físicas current recuperadas.

### 6.1 SOURCE A — `10-architecture-decisions-records.md`

#### CHANGE — `# 7. Catálogo definitivo propuesto de ADR`

Estado current stale:

```text
catalog total =
20

last catalog ADR =
ADR-0020

ADR-0021 row =
ABSENT
```

La superficie debe sincronizarse.

#### CHANGE — `# 27. Mapeo contra fases`

Estado current stale:

```text
Phase 2 contains ADR-0020 prerequisite mapping =
YES

Phase 2 contains ADR-0021 later-user prerequisite mapping =
NO
```

La superficie debe sincronizarse.

#### CHANGE — `## 37.4 Cantidad propuesta`

Estado current stale:

```text
TOTAL ADR VIGENTE =
20

ACCEPTED =
9

READY TO DRAFT =
0

BLOCKED BY OPEN DECISIONS =
8

DEFERRED =
3
```

La superficie debe sincronizarse.

#### READ / PRESERVE — `# 31. Orden recomendado de creación`

No se modifica.

Razón:

- no funciona como catálogo completo current de ADR incorporados;
- ya omite ADR-0019 y ADR-0020;
- CORR-027 no lo convirtió en current registry;
- reescribirlo para incorporar ADR-0021 sería modernización histórica/estructural no necesaria para el objetivo de CORR-042.

#### READ / PRESERVE — Gate de Fase 0 y listas históricas

No se modifica:

- qué ADR cerraron originalmente Fase 0;
- el conteo histórico original de seis ADR requeridos por ese Gate;
- snapshots de decisiones anteriores;
- estados de ADR-0001..ADR-0020 salvo los agregados numéricos globales que necesariamente cambian al incorporar ADR-0021.

### 6.2 SOURCE B — `11-phase-1-scope-entry-gate.md`

#### CHANGE — `# 17. Resultado final`

§17 es la superficie activa final de current-state.

Estado stale confirmado:

```text
ADR-0021 current-state =
ABSENT

CORR-041 current-state =
ABSENT

ADR-0021 prerequisite for TASK-020 =
ABSENT

next TASK =
NOT DETERMINED

TASK-020 =
NOT DETERMINED
```

Debe sincronizarse.

#### READ / PRESERVE — §7.9

No se modifica.

La sección conserva snapshots anteriores de continuidad de Fase 2 y no constituye la superficie final current posterior a CORR-040.

#### READ / PRESERVE — §10.2

No se modifica.

Los requisitos originales de entrada a Fase 2 y sus snapshots posteriores permanecen historia válida. ADR-0021 no es requisito retroactivo del Gate de entrada ya satisfecho.

#### READ / PRESERVE — §14.2

No se modifica.

La condición histórica de transición hacia Fase 2 no se reescribe para incorporar un prerequisite surgido posteriormente dentro de Fase 2.

#### READ / PRESERVE — §6.1

No se modifica.

Ya preserva el boundary aprobado por CORR-039:

```text
Client =
Phase 3

physical UserClientAccess required before Phase 2 close =
NO

physical/full SupportAccessGrant required before Phase 2 close =
NO

RF-015 =
MANDATORY / UNCHANGED
```

---

## 7. Scope físico exacto

### 7.1 Target count

```text
exact target file count =
2
```

### 7.2 Targets

**TARGET 1**

`docs/product/10-architecture-decisions-records.md`

**TARGET 2**

`docs/product/11-phase-1-scope-entry-gate.md`

### 7.3 Semantic surface count

```text
TARGET 1 semantic surfaces =
EXACTLY 3

TARGET 2 semantic surfaces =
EXACTLY 1

total semantic surfaces =
EXACTLY 4

third target =
FORBIDDEN

unexpected fifth semantic surface =
FORBIDDEN
```

No se crea, elimina ni renombra ningún documento producto.

---

## 8. TARGET 1 — Surface 1 — `# 7. Catálogo definitivo propuesto de ADR`

### 8.1 Current stale state

La frase vigente registra:

```text
catalog current total =
20
```

y termina en ADR-0020.

### 8.2 Required state

La futura implementación debe actualizar únicamente el significado necesario para representar:

```text
catalog original =
18 ADR

later incorporated ADRs =
ADR-0019
ADR-0020
ADR-0021

TOTAL ADR VIGENTE =
21
```

### 8.3 Nueva fila ADR-0021

Debe agregarse exactamente una fila después de ADR-0020.

La fila debe preservar como mínimo:

```text
ID =
ADR-0021

title =
Authoritative Later-User Enrollment Intent Binding

selected architecture =
dedicated LaterUserEnrollmentIntent

purpose =
ordinary later-user enrollment

ownership =
TENANT-OWNED BUSINESS STATE

RLS =
MANDATORY / PRIMARY REMOTE TENANT ISOLATION BOUNDARY

status =
ACCEPTED

phase =
Phase 2

timing =
before implementation of the ordinary later-user pre-Client enrollment foundation
```

La redacción tabular puede condensar la decisión, pero no puede degradarla a:

- generic onboarding intent;
- reuse de `FirstAdminOnboardingIntent`;
- platform-owned later-user intent;
- no-RLS business state;
- Client-dependent foundation.

Una forma semánticamente válida de la fila es:

```markdown
| `ADR-0021` | Authoritative Later-User Enrollment Intent Binding | Vincular autoritativamente tenant, target email e intended role mediante un `LaterUserEnrollmentIntent` purpose-specific, tenant-owned y separado de first-admin bootstrap, componiendo Verification/Auth hasta el boundary pre-Client aprobado | `ADR-0021`, `ADR-0019`, `CORR-039`/`CORR-040`, `TASK-017/018/019` | Ninguna que bloquee la decisión arquitectónica aceptada; las decisiones de PlatformUser/profile/membership/USER_CREATED posteriores permanecen diferidas y la implementación futura requiere Gate separado | `ACCEPTED` | Fase 2 — antes de implementar la foundation ordinaria later-user pre-Client |
```

La implementación puede ajustar redacción mínima para mantener el estilo de la tabla, pero no alterar esas semánticas.

### 8.4 No implicaciones

La nueva fila no significa:

```text
TASK-020 specification =
GENERATED

TASK-020 implementation =
AUTHORIZED

ordinary later-user onboarding =
COMPLETE

RF-015 =
SATISFIED

Client =
PHASE 2
```

---

## 9. TARGET 1 — Surface 2 — `# 27. Mapeo contra fases`

### 9.1 Regla de no retroactividad

Debe preservarse sin cambio:

```text
Antes de Fase 2 =
ADR-0002 + ADR-0003
```

ADR-0021 no se convierte retroactivamente en requisito del Gate de entrada a Fase 2.

### 9.2 Required mapping

Debe añadirse un hito dentro de Fase 2, después del hito de ADR-0020 y antes de Fase 4, con significado equivalente a:

```markdown
| **Durante Fase 2, antes de implementar la foundation ordinaria later-user pre-Client** | `ADR-0021` |
```

Debe quedar inequívoco:

```text
ADR-0021 belongs to Phase 2
AND
ADR-0021 is an architectural prerequisite for TASK-020
AND
ADR-0021 is accepted / remotely persisted
BUT
ADR-0021 was not a retroactive prerequisite for Phase 2 entry
AND
ADR-0021 was not a prerequisite for TASK-017/018/019
```

---

## 10. TARGET 1 — Surface 3 — `## 37.4 Cantidad propuesta`

### 10.1 Current stale state

```text
TOTAL ADR VIGENTE =
20

ACCEPTED =
9

READY TO DRAFT =
0

BLOCKED BY OPEN DECISIONS =
8

DEFERRED =
3
```

### 10.2 Required state

```text
TOTAL ADR VIGENTE =
21

ACCEPTED =
10

READY TO DRAFT =
0

BLOCKED BY OPEN DECISIONS =
8

DEFERRED =
3
```

Sólo cambian:

- total vigente;
- cantidad `ACCEPTED`.

No se reclasifica ningún ADR previo.

---

## 11. TARGET 2 — `# 17. Resultado final`

### 11.1 Naturaleza de la superficie

§17 es la única superficie active current-state de SOURCE B autorizada por CORR-042.

Las demás apariciones históricas de TASK/ADR previos permanecen inmutables.

### 11.2 ADR-0021 current state

§17 debe representar, con wording compatible con el documento:

```text
ADR-0021 architecture decision =
ACCEPTED / HUMAN APPROVED under existing project meaning

ADR-0021 remote persistence =
VERIFIED

ADR-0021 remote commit =
408e71ae40e8a9cf49a88b8320f629ecbe4b1b81

CORR-041 =
CLOSED

ADR-0021 architectural prerequisite for TASK-020 =
RESOLVED
```

También debe preservar sin ambigüedad:

```text
selected architecture =
dedicated LaterUserEnrollmentIntent

FirstAdminOnboardingIntent
!=
LaterUserEnrollmentIntent

LaterUserEnrollmentIntent ownership =
TENANT-OWNED BUSINESS STATE

RLS =
MANDATORY / PRIMARY REMOTE TENANT ISOLATION BOUNDARY

TASK-017/018/019 purpose-specific implementation
!=
generic later-user API
```

No es obligatorio duplicar literalmente todas estas líneas si el surrounding prose ya las expresa de manera inequívoca, pero ninguna puede quedar contradicha.

### 11.3 TASK-020 current state

La superficie debe pasar de:

```text
next TASK =
NOT DETERMINED

TASK-020 =
NOT DETERMINED
```

a un estado equivalente a:

```text
next TASK =
TASK-020 — Authoritative Later-User Enrollment Intent, Verification and Handoff Foundation

TASK-020 =
DETERMINED

TASK-020 specification =
NOT GENERATED

TASK-020 implementation =
NOT AUTHORIZED

Codex for TASK-020 =
NOT AUTHORIZED
```

Debe preservarse:

```text
Siguiente TASK autorizada automáticamente =
NO
```

La determinación humana de TASK-020 no constituye generación ni autorización de implementación.

### 11.4 Phase state

Debe permanecer:

```text
Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED
```

### 11.5 CORR-039 boundary

Debe permanecer sin debilitamiento:

```text
Client =
Phase 3

physical UserClientAccess required before Phase 2 close =
NO

physical/full SupportAccessGrant required before Phase 2 close =
NO

full Client-dependent support required before Phase 2 close =
NO

ordinary later-user onboarding remains incomplete until RF-015 can be satisfied =
YES

pre-Client later-user onboarding foundation split =
YES

move minimal Client into Phase 2 =
NO

RF-015 =
MANDATORY / UNCHANGED

zero client assignment satisfies RF-015 =
NO
```

### 11.6 Incomplete capabilities

Debe continuar siendo explícito:

```text
ordinary later-user onboarding =
INCOMPLETE

generic user creation =
INCOMPLETE

generic CompanyMembership creation =
INCOMPLETE

later-user email + code orchestration =
INCOMPLETE

later-user Auth/session composition =
INCOMPLETE

later-user initial role assignment =
INCOMPLETE

later-user profile completion =
INCOMPLETE

later-user USER_CREATED producer =
INCOMPLETE

pre-Client later-user onboarding foundation =
INCOMPLETE

ordinary later-user composition =
ABSENT
```

`TASK-020 = DETERMINED` no cambia ninguno de esos estados.

### 11.7 `new ADR required: no`

La línea preexistente:

```text
new ADR required: no
```

pertenece al contexto de la corrección/boundary previo y no puede utilizarse para negar la existencia posterior de ADR-0021.

Una futura implementación puede mantenerla byte-identical si el contexto ya evita contradicción, o calificarla mínimamente como estado del boundary CORR-039 si fuera estrictamente necesario para evitar ambigüedad.

No puede convertirla en:

```text
ADR-0021 was unnecessary
```

ni alterar retrospectivamente CORR-039.

---

## 12. Documentos y superficies READ / PRESERVE — NO CHANGE

Permanecen sin modificación:

- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- `docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md`;
- `docs/tasks/CORR-041-adr-0021-git-persistence-governance-lifecycle-sync.md`;
- `docs/tasks/CORR-039-phase-2-phase-3-client-scope-boundary-documentation-sync.md`;
- `docs/tasks/CORR-040-task-019-closure-current-state-documentation-sync.md`;
- `docs/tasks/CORR-027-adr-0020-acceptance-documentation-state-sync.md`;
- cualquier TASK-017/018/019;
- cualquier código;
- cualquier SQL;
- cualquier migration;
- cualquier test ejecutable.

Dentro de TARGET 1 permanecen READ / PRESERVE, salvo las tres superficies expresamente autorizadas:

- registro `DO-*`;
- registros `DM/FORM/EVID/RPT/AI/PAY/OFF OPEN`;
- secciones específicas de ADR-0001..ADR-0020;
- Gate de Fase 0;
- `# 31. Orden recomendado de creación`;
- cualquier histórico de ADR-0019/0020.

Dentro de TARGET 2 permanece READ / PRESERVE todo salvo `# 17. Resultado final`.

---

## 13. Arquitectura, producto, dominio y seguridad

CORR-042 debe declarar y preservar:

```text
architecture decision changed by CORR-042 =
NO

product requirement change =
NO

domain change =
NO

security model change =
NO

RLS behavior change =
NO

multitenancy change =
NO

Auth behavior change =
NO

offline behavior change =
NO

new ADR created by CORR-042 =
NO
```

CORR-042 únicamente sincroniza el estado documental de una decisión arquitectónica ya aprobada.

---

## 14. Seguridad / RLS / multitenancy

Aunque no exista cambio ejecutable, la corrección debe preservar explícitamente:

```text
tenant =
MaintenanceCompany

LaterUserEnrollmentIntent =
TENANT-OWNED BUSINESS STATE

RLS =
MANDATORY / PRIMARY REMOTE TENANT ISOLATION BOUNDARY

caller-supplied tenant authority =
NO

SUPER_ADMIN ordinary tenant bypass =
NO

generic privileged client =
NO

authenticated
!=
authorized

Auth session
!=
tenant authorization

current authoritative PostgreSQL state
>
stale claims
```

CORR-042 no crea policy, grant, function, RPC ni migration.

---

## 15. Auth / verification boundary

Debe preservarse la separación:

```text
business intent =
LaterUserEnrollmentIntent

business proof =
VerificationChallenge

initial session authorization proof =
SessionGrant

provider bridge credential =
server-only technical credential
```

Y:

```text
TASK-017/018/019 first-admin implementation
!=
generic later-user API
```

CORR-042 no diseña ni materializa ninguna superficie Auth.

---

## 16. Offline

```text
offline behavior change =
NO
```

La sincronización documental no autoriza workflow offline de enrollment.

No se modifica `04-offline-sync-strategy.md`.

---

## 17. TASK-020 boundary protegido

CORR-042 sólo registra la determinación de TASK-020.

No especifica:

- schema de `LaterUserEnrollmentIntent`;
- tabla;
- columnas;
- PK/FK;
- índices;
- enums;
- constraints;
- policies RLS;
- RPC;
- route;
- endpoint;
- payload;
- UI;
- email provider;
- resend policy;
- exact challenge TTL;
- exact retry budget;
- exact Auth Admin operation;
- exact `PlatformUser` creation timing;
- exact profile completion timing;
- exact initial `CompanyMembership` establishment timing;
- exact later-user `USER_CREATED` producer timing;
- final profile/membership/client-scope atomicity.

Si sincronizar documentación requiere decidir cualquiera de esos puntos:

```text
CORR-042 =
BLOCKER — NEW SEMANTIC DECISION REQUIRED
```

No resolver silenciosamente.

---

## 18. Decisiones diferidas que permanecen abiertas para el trabajo posterior

CORR-042 no resuelve:

```text
exact later-user PlatformUser creation/completion timing

exact later-user profile-completion timing

exact initial CompanyMembership establishment timing

exact later-user USER_CREATED producer timing

final profile/membership/client-scope atomicity
```

Estas decisiones tampoco se convierten en blockers de CORR-042 porque esta correction termina antes de diseñar TASK-020.

---

## 19. Contrato de implementación futura

Esta sección especifica una futura implementación de CORR-042; no la autoriza.

### 19.1 Fresh Git preflight

Antes de cualquier escritura futura:

1. verificar repo root;
2. verificar branch;
3. verificar HEAD;
4. verificar upstream;
5. verificar `origin/main`;
6. verificar divergence;
7. exigir worktree/index limpio;
8. verificar ausencia de operación Git en progreso;
9. verificar que ambos targets existen exactamente una vez;
10. verificar la identidad física de ambos targets.

No limpiar drift inesperado automáticamente.

### 19.2 Baseline físico esperado

TARGET 1 expected pre-edit identity:

```text
path =
docs/product/10-architecture-decisions-records.md

SHA-256 =
20597fc5adac727869155097cbb35833a79de7cbe0d093604744c130d70d0153

bytes =
73085

LF =
1937

CRLF =
0

bare CR =
0

trailing-whitespace lines =
19

final newline =
YES
```

TARGET 2 expected pre-edit identity:

```text
path =
docs/product/11-phase-1-scope-entry-gate.md

SHA-256 =
3aa454cd044336c9733120aa1837698c9f81093cb5759be4c37c097fd11ff8df

bytes =
100312

LF =
1615

CRLF =
0

bare CR =
0

trailing-whitespace lines =
9

final newline =
YES
```

Si cualquiera difiere antes de implementación:

```text
CORR-042 IMPLEMENTATION =
STOP

BLOCKER — AUTHORIZED TARGET BASELINE DRIFT
```

No aplicar el spec a una baseline desconocida.

### 19.3 Allowed changed-path inventory

```text
modified existing paths =
EXACTLY 2

new paths =
NONE

deleted paths =
NONE

renamed paths =
NONE
```

Exact paths:

```text
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

### 19.4 Allowed semantic surfaces

```text
10-architecture-decisions-records.md:
  # 7
  # 27
  ## 37.4

11-phase-1-scope-entry-gate.md:
  # 17

total =
4
```

Un hunk semántico fuera de esas superficies es blocker.

### 19.5 Minimal diff

La futura implementación debe:

- modificar sólo el estado stale requerido;
- preservar wording no relacionado;
- preservar line endings LF;
- no ejecutar reformat global;
- no normalizar trailing whitespace preexistente fuera de líneas realmente modificadas;
- no reordenar secciones;
- no modernizar snapshots históricos;
- no realizar cleanup lateral.

### 19.6 Whitespace

Las líneas preexistentes con trailing whitespace:

```text
TARGET 1 =
19

TARGET 2 =
9
```

no autorizan cleanup global.

Toda línea nueva o materialmente modificada por CORR-042 debe quedar sin trailing whitespace, salvo una necesidad Markdown estricta y revisada.

### 19.7 No Git persistence inside implementation step

La implementación futura no autoriza automáticamente:

```text
staging
commit
push
```

Cada operación requiere Gate separado.

---

## 20. Verification strategy

CORR-042 es documentation-only.

No se requieren:

- application tests;
- database tests;
- Supabase Local;
- Supabase Cloud;
- Auth mutation;
- migration execution.

La futura implementación debe aportar como mínimo:

1. fresh Git preflight;
2. identidad física pre-edit de ambos targets;
3. exact changed-path inventory;
4. complete diff;
5. revisión de todos los hunks;
6. prueba de que todos los hunks semánticos están dentro de las cuatro superficies autorizadas;
7. `git diff --check`;
8. identidades físicas post-edit;
9. ausencia de tercer path;
10. ausencia de staging/commit/push;
11. comprobación literal/semántica del catálogo de ADR;
12. comprobación literal/semántica del phase mapping;
13. comprobación de counts `21 / ACCEPTED 10`;
14. comprobación de ADR-0021/CORR-041/TASK-020 en §17;
15. comprobación de que Phase 2/Phase 3 y CORR-039 boundaries permanecen;
16. comprobación de que ordinary later-user onboarding continúa incomplete.

---

## 21. Acceptance Criteria

**AC-042-001.** El ID es exactamente `CORR-042`.

**AC-042-002.** El título es exactamente `CORR-042 — ADR-0021 Acceptance and TASK-020 Prerequisite Current-State Sync`.

**AC-042-003.** La correction es exclusivamente documental.

**AC-042-004.** CORR-042 no genera TASK-020.

**AC-042-005.** CORR-042 no especifica TASK-020.

**AC-042-006.** CORR-042 no autoriza implementación.

**AC-042-007.** CORR-042 no usa Codex durante specification generation.

**AC-042-008.** CORR-042 no modifica Supabase.

**AC-042-009.** SOURCE A queda identificada con SHA-256 `20597fc5adac727869155097cbb35833a79de7cbe0d093604744c130d70d0153`.

**AC-042-010.** SOURCE B queda identificada con SHA-256 `3aa454cd044336c9733120aa1837698c9f81093cb5759be4c37c097fd11ff8df`.

**AC-042-011.** SOURCE A se reconoce como post-CORR-027.

**AC-042-012.** SOURCE B se reconoce como post-CORR-039/post-CORR-040.

**AC-042-013.** CORR-027 se usa únicamente como precedente de governance.

**AC-042-014.** El target count futuro es exactamente 2.

**AC-042-015.** No se autoriza tercer target.

**AC-042-016.** TARGET 1 es `docs/product/10-architecture-decisions-records.md`.

**AC-042-017.** TARGET 2 es `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-042-018.** TARGET 1 posee exactamente 3 superficies semánticas autorizadas.

**AC-042-019.** TARGET 2 posee exactamente 1 superficie semántica autorizada.

**AC-042-020.** El total de superficies semánticas autorizadas es exactamente 4.

**AC-042-021.** TARGET 1 §7 cambia el catálogo vigente de 20 a 21 ADR.

**AC-042-022.** TARGET 1 §7 agrega exactamente una fila de ADR-0021.

**AC-042-023.** La fila de ADR-0021 utiliza el título `Authoritative Later-User Enrollment Intent Binding`.

**AC-042-024.** La fila representa `LaterUserEnrollmentIntent` como la arquitectura seleccionada.

**AC-042-025.** La fila no reutiliza `FirstAdminOnboardingIntent` como later-user intent.

**AC-042-026.** La fila preserva ownership tenant-owned.

**AC-042-027.** La fila preserva RLS como frontera primaria remota.

**AC-042-028.** La fila representa ADR-0021 como `ACCEPTED`.

**AC-042-029.** La fila ubica ADR-0021 en Fase 2.

**AC-042-030.** La fila no mueve Client a Fase 2.

**AC-042-031.** TARGET 1 §27 agrega un milestone de ADR-0021 dentro de Fase 2.

**AC-042-032.** §27 preserva `Antes de Fase 2 = ADR-0002 + ADR-0003`.

**AC-042-033.** ADR-0021 no se convierte en prerequisite retroactivo de entrada a Fase 2.

**AC-042-034.** ADR-0021 no se convierte en prerequisite de TASK-017/018/019.

**AC-042-035.** TARGET 1 §37.4 registra `TOTAL ADR VIGENTE = 21`.

**AC-042-036.** TARGET 1 §37.4 registra `ACCEPTED = 10`.

**AC-042-037.** `READY TO DRAFT = 0` permanece.

**AC-042-038.** `BLOCKED BY OPEN DECISIONS = 8` permanece.

**AC-042-039.** `DEFERRED = 3` permanece.

**AC-042-040.** TARGET 2 modifica exclusivamente §17.

**AC-042-041.** §17 registra ADR-0021 como `ACCEPTED / HUMAN APPROVED` conforme al meaning vigente.

**AC-042-042.** §17 registra `ADR-0021 remote persistence = VERIFIED`.

**AC-042-043.** §17 registra `CORR-041 = CLOSED`.

**AC-042-044.** §17 registra `ADR-0021 architectural prerequisite for TASK-020 = RESOLVED`.

**AC-042-045.** §17 registra `TASK-020 = DETERMINED`.

**AC-042-046.** §17 registra el título determinado de TASK-020.

**AC-042-047.** §17 registra `TASK-020 specification = NOT GENERATED`.

**AC-042-048.** §17 registra `TASK-020 implementation = NOT AUTHORIZED`.

**AC-042-049.** §17 registra `Codex for TASK-020 = NOT AUTHORIZED`.

**AC-042-050.** `Siguiente TASK autorizada automáticamente = NO` permanece.

**AC-042-051.** `Phase 2 = IN PROGRESS / NOT CLOSED` permanece.

**AC-042-052.** `Phase 2 Exit Gate = NOT YET DEFINED` permanece.

**AC-042-053.** `Phase 3 = NOT STARTED` permanece.

**AC-042-054.** `Client = Phase 3` permanece.

**AC-042-055.** `RF-015 = MANDATORY / UNCHANGED` permanece.

**AC-042-056.** Cero clients no se presenta como satisfacción de RF-015.

**AC-042-057.** Ordinary later-user onboarding permanece `INCOMPLETE`.

**AC-042-058.** Generic user creation permanece `INCOMPLETE`.

**AC-042-059.** Generic CompanyMembership creation permanece `INCOMPLETE`.

**AC-042-060.** Pre-Client later-user onboarding foundation permanece `INCOMPLETE`.

**AC-042-061.** `FirstAdminOnboardingIntent != LaterUserEnrollmentIntent` se preserva.

**AC-042-062.** TASK-017/018/019 no se reinterpretan como generic later-user APIs.

**AC-042-063.** No cambia producto.

**AC-042-064.** No cambia dominio.

**AC-042-065.** No cambia seguridad.

**AC-042-066.** No cambia RLS ejecutable.

**AC-042-067.** No cambia multitenancy.

**AC-042-068.** No cambia Auth behavior.

**AC-042-069.** No cambia offline behavior.

**AC-042-070.** No se crea nuevo ADR.

**AC-042-071.** No se modifica ADR-0021.

**AC-042-072.** No se modifica CORR-041.

**AC-042-073.** No se modifica CORR-039.

**AC-042-074.** No se modifica CORR-040.

**AC-042-075.** No se modifica CORR-027.

**AC-042-076.** No se reescriben snapshots históricos.

**AC-042-077.** `# 31. Orden recomendado de creación` de TARGET 1 permanece sin cambio.

**AC-042-078.** §7.9, §10.2 y §14.2 de TARGET 2 permanecen sin cambio.

**AC-042-079.** Una futura implementación produce complete diff de ambos targets.

**AC-042-080.** Todos los hunks semánticos quedan dentro de las cuatro superficies autorizadas.

**AC-042-081.** No se realiza whitespace cleanup global.

**AC-042-082.** Las líneas nuevas/modificadas no introducen trailing whitespace.

**AC-042-083.** `git diff --check` debe ser PASS para el delta introducido.

**AC-042-084.** No se ejecuta staging durante el implementation step.

**AC-042-085.** No se ejecuta commit durante el implementation step.

**AC-042-086.** No se ejecuta push durante el implementation step.

**AC-042-087.** TASK-020 no queda specification-generated por efecto de CORR-042.

**AC-042-088.** TASK-020 no queda implementation-authorized por efecto de CORR-042.

---

## 22. Definition of Done

**DoD-042-001.** Specification review aprobada.

**DoD-042-002.** Aprobación humana de CORR-042 realizada mediante Gate separado.

**DoD-042-003.** Approved artifact generado mediante step separado.

**DoD-042-004.** Approved artifact review aprobado.

**DoD-042-005.** Canonicalization authorization aprobada.

**DoD-042-006.** CORR-042 canonicalizada en artifact separado.

**DoD-042-007.** Canonicalization review aprobado.

**DoD-042-008.** Repository incorporation authorization aprobada.

**DoD-042-009.** Artefacto canónico incorporado a su ruta `docs/tasks/...`.

**DoD-042-010.** Repository incorporation review aprobado.

**DoD-042-011.** Implementation authorization aprobada mediante Gate separado.

**DoD-042-012.** Fresh Git preflight ejecutado antes de mutación.

**DoD-042-013.** TARGET 1 pre-edit identity coincide con esta specification o drift recibe revisión humana previa.

**DoD-042-014.** TARGET 2 pre-edit identity coincide con esta specification o drift recibe revisión humana previa.

**DoD-042-015.** Se modifican exactamente 2 paths.

**DoD-042-016.** No existe tercer path.

**DoD-042-017.** TARGET 1 sólo modifica §7, §27 y §37.4.

**DoD-042-018.** TARGET 2 sólo modifica §17.

**DoD-042-019.** ADR-0021 queda registrado como ACCEPTED.

**DoD-042-020.** Total ADR vigente queda en 21.

**DoD-042-021.** ACCEPTED queda en 10.

**DoD-042-022.** Phase mapping de ADR-0021 queda registrado sin retroactividad.

**DoD-042-023.** §17 registra ADR-0021 remote persistence verified.

**DoD-042-024.** §17 registra CORR-041 closed.

**DoD-042-025.** §17 registra prerequisite de TASK-020 resuelto.

**DoD-042-026.** §17 registra TASK-020 determined.

**DoD-042-027.** §17 mantiene TASK-020 specification not generated.

**DoD-042-028.** §17 mantiene TASK-020 implementation not authorized.

**DoD-042-029.** §17 mantiene Phase 2 not closed.

**DoD-042-030.** §17 mantiene Phase 3 not started.

**DoD-042-031.** CORR-039 boundary queda intacto.

**DoD-042-032.** Ordinary later-user onboarding permanece incomplete.

**DoD-042-033.** Complete diff revisado.

**DoD-042-034.** `git diff --check` pasa para el delta.

**DoD-042-035.** Implementation review aprobado mediante Gate separado.

**DoD-042-036.** Staging authorization aprobada mediante Gate separado.

**DoD-042-037.** Staging ejecutado sólo después de authorization.

**DoD-042-038.** Staging review aprobado.

**DoD-042-039.** Commit authorization aprobada mediante Gate separado.

**DoD-042-040.** Commit ejecutado sólo después de authorization.

**DoD-042-041.** Commit review aprobado.

**DoD-042-042.** Push authorization aprobada mediante Gate separado.

**DoD-042-043.** Push ejecutado sin force.

**DoD-042-044.** Push review / remote verification aprobado.

**DoD-042-045.** Remote content corresponde al reviewed commit.

**DoD-042-046.** CORR-042 final human closure se ejecuta mediante Gate separado.

**DoD-042-047.** El cierre de CORR-042 no genera automáticamente TASK-020 specification.

**DoD-042-048.** Un eventual `TASK-020 SPECIFICATION GENERATION AUTHORIZATION` ocurre sólo mediante nuevo Gate humano separado.

---

## 23. Blockers de futura ejecución

La futura ejecución debe detenerse si ocurre cualquiera de estas condiciones:

1. falta cualquiera de los dos targets;
2. el target aparece más de una vez;
3. el baseline físico cambió sin review;
4. worktree/index no están limpios antes de la ejecución autorizada;
5. aparece un tercer path necesario;
6. aparece una quinta superficie semántica necesaria;
7. se necesita modificar una sección histórica de TARGET 2;
8. se necesita modificar `# 31` de TARGET 1;
9. se necesita cambiar producto;
10. se necesita cambiar dominio;
11. se necesita cambiar seguridad;
12. se necesita cambiar RLS;
13. se necesita cambiar multitenancy;
14. se necesita cambiar Auth behavior;
15. se necesita cambiar offline behavior;
16. se necesita crear otro ADR;
17. se necesita modificar ADR-0021;
18. se necesita modificar CORR-039/040/041;
19. se necesita resolver una decisión diferida de later-user completion;
20. se necesita especificar TASK-020;
21. se necesita diseñar schema/API/UI;
22. se detecta contradicción material entre ADR-0021 y current product/domain canon;
23. se detecta que TASK-020 ya fue posteriormente especificada/autorizada por un Gate autoritativo más reciente;
24. se detecta que otra correction ya sincronizó estas superficies.

Ante blocker:

```text
CORR-042 IMPLEMENTATION =
STOP

no silent repair
no scope expansion
no staging
no commit
no push
RETURN TO REVISOR CENTRAL
```

---

## 24. Riesgos controlados

### `CORR-042-RSK-001` — Reescribir historia

**Riesgo:** modernizar §7.9/§10.2/§14.2 o snapshots anteriores.

**Control:** TARGET 2 autoriza exclusivamente §17.

### `CORR-042-RSK-002` — Convertir acceptance en implementación

**Riesgo:** `ADR-0021 = ACCEPTED` se interpreta como TASK-020 implementada.

**Control:** registrar explícitamente specification/implementation no autorizadas.

### `CORR-042-RSK-003` — Retroactividad de Phase 2 Gate

**Riesgo:** ADR-0021 se agrega a `Antes de Fase 2`.

**Control:** crear milestone intra-Fase 2 separado.

### `CORR-042-RSK-004` — Debilitar RF-015

**Riesgo:** considerar foundation pre-Client como onboarding completo.

**Control:** mantener `RF-015` obligatorio y onboarding ordinary incomplete.

### `CORR-042-RSK-005` — Confundir first-admin y later-user

**Riesgo:** reutilizar semánticamente `FirstAdminOnboardingIntent`.

**Control:** mantener identidad purpose-specific separada.

### `CORR-042-RSK-006` — Cleanup lateral

**Riesgo:** normalizar whitespace histórico y aumentar el diff.

**Control:** mínimo diff y `diff --check` sólo sobre líneas tocadas.

---

## 25. Lifecycle de gobernanza de CORR-042

Debe preservarse la secuencia:

```text
CORR-042 SPECIFICATION GENERATION
→ CORR-042 SPEC REVIEW
→ CORR-042 HUMAN APPROVAL
→ CORR-042 APPROVED ARTIFACT GENERATION
→ CORR-042 APPROVED ARTIFACT REVIEW
→ CORR-042 CANONICALIZATION AUTHORIZATION
→ CORR-042 CANONICALIZATION
→ CORR-042 CANONICALIZATION REVIEW
→ CORR-042 REPOSITORY INCORPORATION AUTHORIZATION
→ CORR-042 REPOSITORY INCORPORATION
→ CORR-042 REPOSITORY INCORPORATION REVIEW
→ CORR-042 IMPLEMENTATION AUTHORIZATION
→ CORR-042 IMPLEMENTATION
→ CORR-042 IMPLEMENTATION REVIEW
→ CORR-042 STAGING AUTHORIZATION
→ CORR-042 STAGING
→ CORR-042 STAGING REVIEW
→ CORR-042 COMMIT AUTHORIZATION
→ CORR-042 COMMIT
→ CORR-042 COMMIT REVIEW
→ CORR-042 PUSH AUTHORIZATION
→ CORR-042 PUSH
→ CORR-042 PUSH REVIEW / REMOTE VERIFICATION
→ CORR-042 FINAL HUMAN CLOSURE
→ separate TASK-020 SPECIFICATION GENERATION AUTHORIZATION decision
```

Cada elemento es un Gate o step separado.

Debe preservarse:

```text
spec review
!=
human approval

human approval
!=
canonicalization

repository incorporation
!=
implementation authorization

implementation
!=
staging

staging
!=
commit

commit
!=
push

push
!=
remote verification

CORR-042 closure
!=
TASK-020 specification authorization
```

---

## 26. Resultado de esta generación

```text
CORR-042 SPECIFICATION GENERATION =
PASS

CORR-042 CURRENT TARGET SOURCE BLOCKER =
RESOLVED

CORR-042 SPEC REVIEW =
APPROVED

CORR-042 HUMAN APPROVAL =
APPROVED

CORR-042 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-042 specification =
APPROVED

CORR-042 CANONICALIZATION =
PASS

CORR-042 canonical artifact =
GENERATED / PENDING REVIEW

exact target file count =
2

total semantic surfaces =
4

implementation =
NO

repository mutation =
NO

Codex =
NO

Supabase Local mutation =
NO

Supabase Cloud mutation =
NO

TASK-020 =
DETERMINED

TASK-020 specification =
NOT GENERATED

TASK-020 implementation =
NOT AUTHORIZED
```

---

## 27. Siguiente Gate

Siguiente Gate exclusivamente:

```text
CORR-042 CANONICALIZATION REVIEW
```

Destino:

```text
REVISOR CENTRAL
```

No ejecutar:

- aprobación humana;
- canonicalización;
- implementación;
- Codex;
- staging;
- commit;
- push;
- TASK-020 specification.

STOP.
