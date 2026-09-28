# CORR-039 — Phase 2 / Phase 3 Client-Scope Boundary Documentation Sync

## 1. Identidad y estado

**ID:** `CORR-039`

**Título:** `CORR-039 — Phase 2 / Phase 3 Client-Scope Boundary Documentation Sync`

**Tipo:** `DOCUMENTATION CORRECTION SPECIFICATION`

**Naturaleza:** corrección documental controlada de sequencing/boundary entre Fase 2 y Fase 3.

**Estado de esta specification:** `HUMAN APPROVED`

**Archivo de entrega aprobado:**

`CORR-039-phase-2-phase-3-client-scope-boundary-documentation-sync-approved.md`

**Target canónico futuro único:**

`docs/product/11-phase-1-scope-entry-gate.md`

**Superficie semántica activa stale:**

`§6.1 — Fase 2 — Multitenancy, autenticación, roles y RLS`

**CORR-039 DETERMINATION:** `APPROVED`

**CORR-039 SPECIFICATION GENERATION AUTHORIZATION:** `APPROVED`

**CORR-039 HUMAN SPEC APPROVAL:** `APPROVED`

**CORR-039 specification:** `HUMAN APPROVED`

**CORR-039 implementación autorizada:** `NO`

**Repositorio modificado durante esta generación:** `NO`

**Documentos canónicos modificados durante esta generación:** `NO`

**Codex autorizado:** `NO`

**Staging / commit / push:** `NO / NO / NO`

**Supabase Local mutation:** `NO`

**Supabase Cloud mutation:** `NO`

**Fase 2:** `INICIADA / NOT CLOSED`

**Phase 2 Exit Gate:** `NOT YET DEFINED`

**Fase 3:** `NOT STARTED`

**Next TASK:** `NOT DETERMINED`

**New ADR required:** `NO`

Esta specification define exclusivamente el contrato para una futura corrección documental. No constituye ejecución de CORR-039, no autoriza modificar el target canónico y no autoriza ningún avance de fase.

---

## 2. Propósito

CORR-039 debe corregir un único drift semántico activo de sequencing en `docs/product/11-phase-1-scope-entry-gate.md`.

El documento target mantiene en `§6.1` una representación de Fase 2 que incluye como capacidades físicas de esa fase:

- `UserClientAccess` físico;
- `SupportAccessGrant` físico;
- implementación de soporte excepcional en una formulación que no distingue sus prerequisites dependientes de `Client`.

Esa representación debe sincronizarse con la decisión de boundary ya aprobada:

```text
Client =
Phase 3

UserClientAccess required before Phase 2 close =
NO

SupportAccessGrant required before Phase 2 close =
NO

Phase 2 may close before Client-dependent authorization =
YES
```

La corrección es exclusivamente de sequencing/boundary.

No modifica producto, dominio, seguridad, RLS, multitenancy, roles, client-scope semantics, soporte excepcional ni arquitectura.

---

## 3. Authoritative inputs

### 3.1 Determinación formal consumida

Se consume como autoridad específica de CORR-039:

```text
CORR-039 DETERMINATION =
APPROVED

CHANGE REQUIRED file count =
1

exact target =
docs/product/11-phase-1-scope-entry-gate.md

active stale semantic surface =
§6.1 —
Fase 2 — Multitenancy, autenticación, roles y RLS
```

No se redetermina el alcance.

### 3.2 Decisión de phase boundary consumida

Se preserva exactamente:

```text
Client =
Phase 3

UserClientAccess required before Phase 2 close =
NO

SupportAccessGrant required before Phase 2 close =
NO

Phase 2 may close before Client-dependent authorization =
YES

ordinary later-user onboarding remains incomplete
until RF-015 can be satisfied =
YES

pre-Client later-user onboarding foundation split =
YES

move minimal Client into Phase 2 =
NO

complete SupportAccessGrant waits for Client/resources =
YES
```

### 3.3 Producto y dominio leídos / preservados

Las siguientes fuentes son autoridad dentro de sus ámbitos, pero **NO son targets** de CORR-039:

```text
READ / PRESERVE — NO CHANGE

docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/10-architecture-decisions-records.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

Todos los `TASK-*` y `CORR-*` históricos permanecen:

```text
READ-ONLY / PRESERVE HISTORY
```

### 3.4 Regla de autoridad aplicada

Para esta corrección:

1. la determinación humana aprobada de CORR-039 gobierna el target y la superficie exacta;
2. la decisión humana aprobada de phase boundary gobierna el sequencing Fase 2 / Fase 3;
3. `01-product-definition.md` conserva los requisitos normativos del producto;
4. `02-domain-model.md` conserva el significado de las entidades y relaciones;
5. `03-permissions-rls-strategy.md`, ADR-0002 y ADR-0003 conservan las invariantes de autorización, RLS, multitenancy y soporte;
6. los TASK/CORR históricos conservan su función de evidencia y snapshots de su momento;
7. CORR-039 no utiliza una corrección documental para introducir una nueva decisión de producto o arquitectura.

---

## 4. Problem statement

El orden macro aprobado ubica:

```text
Fase 2 =
Multitenancy, autenticación, roles y RLS

Fase 3 =
Clientes, ubicaciones, tipos de equipos y equipos
```

y `Client` pertenece a Fase 3.

Sin embargo, `§6.1` del target enumera `UserClientAccess` físico y `SupportAccessGrant` físico dentro de la superficie atribuida a Fase 2.

La dependencia conceptual de `UserClientAccess` es:

```text
UserClientAccess
→ CompanyMembership + Client
```

y la relación debe preservar:

```text
membership.tenant
=
Client.tenant
```

Por tanto, su materialización física completa no puede convertirse en requisito de cierre de Fase 2 si `Client` aún pertenece a Fase 3.

`SupportAccessGrant` contiene conjuntamente semánticas:

```text
tenant-wide support scopes
+
client-scoped support scopes
```

La capability completa requiere respetar sus prerequisites reales. CORR-039 no puede resolver esta dependencia inventando un `SupportAccessGrant` parcial de Fase 2 ni trasladando un `Client` mínimo a Fase 2.

El problema documental es únicamente que la superficie de sequencing de `§6.1` no expresa todavía esa frontera.

---

## 5. Exact target

La futura ejecución de CORR-039 podrá modificar conceptualmente **un único archivo**:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

No existe segundo target autorizado.

Dentro de ese archivo, la superficie primaria y suficiente es:

```text
§6.1 —
Fase 2 — Multitenancy, autenticación, roles y RLS
```

La futura ejecución debe aplicar el cambio mínimo suficiente dentro de esa sección.

No debe utilizar CORR-039 para reescribir otras secciones por consistencia editorial, estilo, limpieza histórica o actualización general de estados.

---

## 6. Active stale surface

La superficie stale es exclusivamente la representación de sequencing de Fase 2 en `§6.1`.

El drift consiste en tratar o poder interpretar como pertenecientes al conjunto físico requerido antes del cierre de Fase 2:

```text
UserClientAccess físico
SupportAccessGrant físico
full Client-dependent support
```

cuando sus prerequisites completos dependen de `Client` y/o recursos cuya fase comienza en Fase 3 o posterior.

La corrección no declara incorrecta la existencia conceptual de esas capacidades ni modifica su obligatoriedad dentro del MVP.

Debe distinguirse:

```text
capability remains required by product
!=
capability is required to close Phase 2
```

y:

```text
deferred by physical prerequisite
!=
removed from MVP
!=
made optional
```

---

## 7. Required semantic correction

La futura modificación de `§6.1` debe expresar simultáneamente las siguientes reglas.

### 7.1 Boundary de Fase 2

Fase 2 debe quedar descrita como el conjunto de capacidades **no dependientes de `Client`** dentro de:

```text
multitenancy
identity
authentication
CompanyMembership
roles
authoritative online authorization
application authorization foundations
RLS
tenant resolution
```

La corrección no necesita declarar que todas esas capacidades están completadas.

Sólo define qué clase de capacidad puede pertenecer al boundary de Fase 2.

### 7.2 `Client` no se mueve

Debe permanecer:

```text
Client =
Phase 3
```

Queda prohibido resolver el sequencing mediante:

```text
minimal Client in Phase 2
temporary Client in Phase 2
placeholder Client in Phase 2
partial Client in Phase 2
```

si cualquiera de esas fórmulas materializa `Client` antes de Fase 3.

### 7.3 `UserClientAccess`

Debe quedar inequívoco:

```text
physical UserClientAccess
is not required
before Phase 2 close
```

porque su semántica requiere:

```text
CompanyMembership
+
Client
```

y ambos extremos deben pertenecer al mismo tenant.

Esto no modifica `UserClientAccess`.

No cambia:

- su identidad;
- su ownership;
- su relación membership-cliente;
- la regla same-tenant;
- la semántica de client scope;
- la herencia autorizada hacia recursos del cliente;
- las reglas de revocación;
- las obligaciones de auditoría aplicables.

### 7.4 `SupportAccessGrant`

Debe quedar inequívoco:

```text
physical/full SupportAccessGrant
is not required
before Phase 2 close
```

cuando su capability completa todavía depende de `Client` y/o de recursos posteriores.

No se autoriza:

```text
partial Phase 2 SupportAccessGrant
```

ni una entidad temporal con semántica reducida que pretenda representar la capability completa.

Debe preservarse conjuntamente:

```text
tenant-wide support semantics
+
client-scoped support semantics
```

La capability física completa continúa cuando sus prerequisites reales existan.

### 7.5 Later-user onboarding

La corrección puede distinguir conceptualmente:

```text
pre-Client later-user onboarding foundation
```

de:

```text
complete later-user onboarding
```

pero debe preservar:

```text
pre-Client onboarding foundation
!=
complete user creation

pre-Client onboarding foundation
!=
complete membership onboarding

pre-Client onboarding foundation
!=
complete later-user onboarding
```

El onboarding ordinario de usuarios posteriores permanece incompleto mientras no pueda satisfacerse el requisito de asignación de clientes aplicable.

### 7.6 No reinterpretar completion status

La corrección de sequencing no convierte automáticamente ninguna capability en implementada, completa, satisfecha o cerrada.

En particular:

```text
boundary correction
!=
implementation status correction
```

---

## 8. Preserved product requirements

CORR-039 debe preservar sin modificación:

```text
RF-013 =
UNCHANGED

RF-014 =
UNCHANGED

RF-015 =
MANDATORY / UNCHANGED

RF-016 =
UNCHANGED

RF-017 =
UNCHANGED
```

### 8.1 Consecuencia obligatoria de RF-015

Debe prohibirse expresamente la interpretación:

```text
zero client assignment
=
RF-015 satisfied
```

La ausencia temporal de `Client` físico no satisface RF-015.

Debe mantenerse:

```text
RF-015 remains mandatory
```

La corrección sólo reconoce que la satisfacción física completa del requisito depende del momento en que `Client` exista.

### 8.2 RF-013 / RF-014

La posibilidad de preparar foundations previas a `Client` no autoriza declarar completo el alta ordinaria de un usuario posterior.

La creación por correo + código y la asignación de rol permanecen requisitos vigentes, pero no sustituyen la asignación de clientes exigida para completar el lifecycle aplicable.

### 8.3 RF-016 / RF-017

Debe preservarse:

- prohibición de conceder acceso a clientes de otro tenant;
- posibilidad posterior de modificar rol y clientes autorizados conforme a las reglas vigentes;
- semántica actual de cambio de rol;
- semántica actual de clientes autorizados.

CORR-039 no redefine ninguno de esos comportamientos.

---

## 9. Preserved domain model

### 9.1 `CompanyMembership`

Permanece la relación tenant de un `PlatformUser` con una única `MaintenanceCompany`, con rol y estado vigentes conforme al modelo aprobado.

CORR-039 no cambia:

- cardinalidad;
- roles permitidos;
- lifecycle;
- invariantes;
- authority model;
- historial;
- reglas de continuidad administrativa.

### 9.2 `UserClientAccess`

Permanece:

```text
UserClientAccess
→ one CompanyMembership
→ one Client
```

con:

```text
membership.tenant
=
Client.tenant
```

Su diferimiento físico por prerequisite no crea una variante conceptual distinta.

### 9.3 `SupportAccessGrant`

Permanece una concesión:

```text
explicit
limited
revocable
auditable
```

para `SUPER_ADMIN`, perteneciente al tenant concedente.

Conserva:

- scopes por cliente;
- scopes tenant-wide;
- separación del acceso tenant normal;
- ausencia de bypass general;
- auditoría de concesión/uso conforme a las reglas vigentes.

### 9.4 `Client`

Permanece una organización atendida por una `MaintenanceCompany`.

No es tenant.

No es usuario del SaaS.

No se mueve de Fase 3.

---

## 10. Security / RLS / multitenancy

CORR-039 debe ser security-neutral.

### 10.1 Tenant

Debe permanecer:

```text
tenant =
MaintenanceCompany
```

Todo recurso tenant-owned conserva ownership inequívoco.

### 10.2 Authentication vs authorization

Debe permanecer:

```text
authenticated != authorized
```

Una sesión válida no prueba por sí sola:

- membership;
- tenant;
- rol;
- client scope;
- `SupportAccessGrant`;
- permiso funcional;
- ownership.

### 10.3 Estado autoritativo

Debe permanecer:

```text
current authoritative state
>
stale session / stale client state
```

CORR-039 no autoriza reemplazar estado autoritativo por claims, frontend state, cookies, parámetros caller-supplied ni caches stale.

### 10.4 RLS

Debe permanecer:

```text
RLS =
primary remote tenant-isolation boundary
```

La corrección documental no cambia:

- políticas RLS;
- estrategia RLS;
- relación entre application authorization y RLS;
- integridad cross-tenant;
- tenant resolution.

### 10.5 `SUPER_ADMIN`

Debe permanecer:

```text
SUPER_ADMIN ordinary tenant bypass =
NO
```

La identidad global no crea membership ni acceso tenant ordinario.

### 10.6 Privileged path / `service-role`

CORR-039 no modifica:

- privileged-path semantics;
- restricciones de `service-role`;
- mínimo privilegio;
- obligación de reconstruir autorización cuando una operación genuinamente privilegiada evita RLS.

Queda prohibido utilizar el cambio de fase como justificación para ampliar privilegios.

---

## 11. Phase-boundary result

Después de una futura ejecución correcta de CORR-039, la interpretación documental debe ser:

### 11.1 Phase 2

```text
Phase 2 boundary =
Client-independent foundations/capabilities within
multitenancy
identity
authentication
CompanyMembership
roles
authoritative online authorization
application authorization foundations
RLS
tenant resolution
```

Y:

```text
physical UserClientAccess required before Phase 2 close =
NO

physical/full SupportAccessGrant required before Phase 2 close =
NO

full Client-dependent support required before Phase 2 close =
NO
```

Esto no define todavía el `Phase 2 Exit Gate`.

### 11.2 Phase 3

Permanece:

```text
Client =
Phase 3
```

Después de que `Client` exista físicamente podrán continuar, en tareas separadas y con sus Gates propios:

```text
UserClientAccess
required client assignment
completion of ordinary later-user onboarding
client-scope modification
client-dependent authorization
SupportAccessGrant capability
```

sin adelantar recursos de fases posteriores.

### 11.3 Macro order

Permanece sin cambios:

```text
Phase 2
→ Multitenancy, authentication, roles, RLS

Phase 3
→ Clients, locations, equipment types, equipment
```

CORR-039 no reordena el proyecto.

---

## 12. Historical surfaces preserved

Todos los TASK/CORR históricos permanecen read-only.

No deben reescribirse snapshots pasados para que parezcan haber contenido la boundary decision actual.

Dentro de `docs/product/11-phase-1-scope-entry-gate.md`, esta sola corrección no debe tratar como stale ni alterar por sí misma estados actuales como:

```text
Client = NO
UserClientAccess completo = NO
SupportAccessGrant completo = NO
Phase 2 = INICIADA / NOT DONE
Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED
```

La future correction debe preservar la distinción:

```text
historical/current implementation status
!=
phase sequencing definition
```

La correction no transforma:

```text
NO
```

en:

```text
DONE
```

ni transforma una foundation existente en una capability completa.

---

## 13. Out of scope

CORR-039 no autoriza ni debe incluir:

- modificación de `docs/product/00-master-product-brief.md`;
- modificación de `docs/product/01-product-definition.md`;
- modificación de `docs/product/02-domain-model.md`;
- modificación de `docs/product/03-permissions-rls-strategy.md`;
- modificación de `docs/product/10-architecture-decisions-records.md`;
- modificación de ADR-0002;
- modificación de ADR-0003;
- modificación de TASK/CORR históricos;
- modificación física del target durante esta specification;
- implementación funcional;
- SQL;
- migrations;
- RLS ejecutable;
- schema;
- `Client`;
- `UserClientAccess`;
- `SupportAccessGrant`;
- partial `SupportAccessGrant`;
- Auth implementation;
- UI;
- API;
- Server Actions;
- privileged functions;
- `service-role` changes;
- Supabase Local mutation;
- Supabase Cloud mutation;
- Codex;
- staging;
- commit;
- push;
- cierre de Fase 2;
- definición o satisfacción del Phase 2 Exit Gate;
- inicio de Fase 3;
- determinación de la siguiente TASK;
- nuevo ADR.

---

## 14. Failure / blocker model

### 14.1 Path expansion blocker

Si durante la futura revisión de esta specification o durante la ejecución autorizada se demuestra que la corrección no puede completarse sin modificar otro documento:

```text
CORR-039 =
STOP / BLOCKER — ADDITIONAL DOCUMENT TARGET REQUIRED
```

Debe reportarse únicamente:

```text
additional path
exact stale statement
why §6.1-only correction is insufficient
```

No se añade el path automáticamente.

No se corrige silenciosamente.

### 14.2 ADR blocker

El estado consumido es:

```text
new ADR required =
NO
```

Si para completar CORR-039 fuera necesario cambiar cualquiera de los siguientes elementos:

```text
ADR-0002
ADR-0003
tenant isolation
RLS architecture
UserClientAccess meaning
SupportAccessGrant meaning
support trust boundary
```

el resultado obligatorio será:

```text
CORR-039 =
STOP / BLOCKER — ADR DETERMINATION REQUIRED
```

No se redactará ni modificará un ADR por inferencia.

### 14.3 Product-requirement blocker

Si una implementación propuesta de CORR-039 exigiera debilitar, reinterpretar o suspender RF-013..RF-017 —especialmente RF-015—, la ejecución debe detenerse.

No puede utilizarse el boundary de fases para convertir un requisito obligatorio en opcional.

### 14.4 Scope blocker

Si la futura ejecución necesita modificar una superficie distinta de `§6.1` para producir el significado requerido, debe detenerse y devolver evidencia al Revisor Central antes de ampliar el alcance.

La existencia de otra frase editorialmente mejorable no autoriza scope expansion.

---

## 15. Acceptance Criteria

### AC-039-001

```text
exact target file count = 1
```

### AC-039-002

```text
exact target =
docs/product/11-phase-1-scope-entry-gate.md
```

### AC-039-003

```text
active stale semantic surface =
§6.1 Phase 2 sequencing
```

### AC-039-004

```text
Client remains Phase 3
```

### AC-039-005

```text
macro phase order remains unchanged
```

### AC-039-006

```text
physical UserClientAccess is not a Phase 2 Exit requirement
```

### AC-039-007

```text
physical/full SupportAccessGrant is not a Phase 2 Exit requirement
```

### AC-039-008

```text
full Client-dependent support is not a Phase 2 Exit requirement
```

### AC-039-009

```text
RF-013..RF-017 remain unchanged
```

### AC-039-010

```text
RF-015 remains mandatory
```

### AC-039-011

```text
zero client assignment != RF-015 satisfaction
```

### AC-039-012

```text
pre-Client onboarding foundation may be distinguished
```

### AC-039-013

```text
pre-Client foundation != complete user/onboarding lifecycle
```

### AC-039-014

```text
complete later-user onboarding waits for required client assignment
```

### AC-039-015

```text
no partial Phase 2 SupportAccessGrant is invented
```

### AC-039-016

```text
UserClientAccess domain semantics remain unchanged
```

### AC-039-017

```text
SupportAccessGrant semantics remain unchanged
```

### AC-039-018

```text
authenticated != authorized remains unchanged
```

### AC-039-019

```text
RLS remains primary remote tenant-isolation boundary
```

### AC-039-020

```text
SUPER_ADMIN ordinary tenant bypass remains NO
```

### AC-039-021

```text
ADR-0002 unchanged
```

### AC-039-022

```text
ADR-0003 unchanged
```

### AC-039-023

```text
historical TASK/CORR artifacts untouched
```

### AC-039-024

```text
current implementation-status statements are not rewritten merely due to sequencing
```

### AC-039-025

```text
Phase 2 remains IN PROGRESS / NOT CLOSED
```

### AC-039-026

```text
Phase 2 Exit Gate remains NOT YET DEFINED
```

### AC-039-027

```text
Phase 3 remains NOT STARTED
```

### AC-039-028

```text
next TASK remains NOT DETERMINED
```

### AC-039-029

```text
specification does not authorize implementation/repository/Supabase mutation
```

### AC-039-030

```text
new ADR required = NO
```

---

## 16. Definition of Done

CORR-039 podrá considerarse ejecutada documentalmente sólo cuando un Gate posterior autorizado demuestre todos los siguientes puntos:

### DoD-039-001 — One target only

Exactamente un archivo canónico fue modificado:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

### DoD-039-002 — One semantic sequencing correction

El diff demuestra una corrección limitada al boundary Fase 2 / Fase 3 de `§6.1`, sin refactor editorial colateral.

### DoD-039-003 — Product requirements unchanged

RF-013, RF-014, RF-015, RF-016 y RF-017 permanecen sin cambios.

### DoD-039-004 — RF-015 preserved

La corrección no afirma ni permite inferir que cero clientes asignados satisfacen RF-015.

### DoD-039-005 — Domain unchanged

`CompanyMembership`, `Client`, `UserClientAccess` y `SupportAccessGrant` conservan su significado, ownership, relaciones e invariantes aprobadas.

### DoD-039-006 — Authorization unchanged

No se modifica authority resolution, roles, client scope, support authorization ni revocation semantics.

### DoD-039-007 — RLS unchanged

No se modifica la arquitectura RLS ni su condición de frontera primaria de aislamiento remoto.

### DoD-039-008 — Multitenancy unchanged

`MaintenanceCompany` permanece como tenant y se mantiene la integridad same-tenant.

### DoD-039-009 — ADR unchanged

ADR-0002 y ADR-0003 permanecen byte-for-byte fuera del cambio de CORR-039.

### DoD-039-010 — Historical record preserved

Ningún TASK/CORR histórico se modifica.

### DoD-039-011 — Status preserved

No se reescriben estados actuales de implementación únicamente por la decisión de sequencing.

### DoD-039-012 — No phase advancement

Fase 2 no se cierra y Fase 3 no se inicia.

### DoD-039-013 — No Exit Gate invention

CORR-039 no define ni satisface el Phase 2 Exit Gate.

### DoD-039-014 — No implementation authorization

La ejecución documental de CORR-039 no autoriza una TASK funcional posterior ni una mutation de repositorio/Supabase fuera de la corrección documental expresamente autorizada por su Gate propio.

### DoD-039-015 — Reviewable evidence

La evidencia física y semántica requerida por §17 está completa y permite al Revisor Central confirmar el alcance sin inferencias.

---

## 17. Review evidence required

La futura ejecución autorizada de CORR-039 deberá producir evidencia suficiente para revisión independiente.

### 17.1 Baseline / target identity

Reportar antes de modificar:

- branch;
- `HEAD`;
- `origin/main`;
- divergence;
- worktree state;
- operaciones Git en progreso;
- existencia del target exacto;
- identidad física del target cuando el Gate de ejecución la exija.

La specification actual no fija un SHA Git futuro.

### 17.2 Changed-path evidence

Demostrar:

```text
changed path count =
1

changed path =
docs/product/11-phase-1-scope-entry-gate.md
```

Cualquier segundo path produce fallo del alcance.

### 17.3 Semantic diff evidence

El diff debe permitir identificar de forma directa:

- que la corrección está limitada a `§6.1`;
- que Fase 2 queda expresada sin requerir capabilities físicas dependientes de `Client`;
- que `Client` no se mueve a Fase 2;
- que no se inventa `SupportAccessGrant` parcial;
- que la corrección distingue foundation previa de onboarding completo;
- que no se toca semántica de autorización.

### 17.4 Preservation evidence

Debe verificarse expresamente:

```text
docs/product/00-master-product-brief.md = unchanged
docs/product/01-product-definition.md = unchanged
docs/product/02-domain-model.md = unchanged
docs/product/03-permissions-rls-strategy.md = unchanged
docs/product/10-architecture-decisions-records.md = unchanged
ADR-0002 = unchanged
ADR-0003 = unchanged
historical TASK/CORR = unchanged
```

### 17.5 Phase-state evidence

La revisión debe confirmar que el cambio no declara:

```text
Phase 2 = CLOSED
Phase 2 Exit Gate = DEFINED
Phase 2 Exit Gate = SATISFIED
Phase 3 = STARTED
next TASK = DETERMINED
```

### 17.6 Formatting / physical integrity evidence

La futura ejecución debe demostrar que el target continúa siendo Markdown válido y no introduce ruido accidental de serialización, whitespace o line endings fuera del cambio autorizado.

La forma exacta de las métricas físicas deberá seguir el Gate de ejecución que autorice la modificación.

---

## 18. Governance and next Gate

Esta specification queda en:

```text
CORR-039 HUMAN SPEC APPROVAL =
APPROVED

CORR-039 specification =
HUMAN APPROVED
```

El siguiente Gate es exclusivamente:

```text
CORR-039 APPROVED ARTIFACT REVIEW
```

Destino:

```text
REVISOR CENTRAL
```

Hasta que ese Gate sea aprobado, permanece:

```text
CORR-039 execution authorized =
NO

target document modification authorized =
NO

Codex authorized =
NO

repository mutation authorized =
NO

Supabase mutation authorized =
NO
```

La aprobación humana de la specification no constituye autorización de ejecución. La ejecución documental requerirá el Gate humano separado que corresponda.

---

## 19. Formal result

No se detectó durante esta generación una necesidad de segundo target ni una modificación de ADR-0002/ADR-0003 o de las invariantes que gobiernan.

Por tanto:

```text
CORR-039 HUMAN SPEC APPROVAL =
APPROVED

CORR-039 specification =
HUMAN APPROVED

CORR-039 APPROVED ARTIFACT GENERATION =
PASS

CORR-039 approved artifact =
GENERATED / PENDING REVIEW
```

Siguiente Gate:

```text
CORR-039 APPROVED ARTIFACT REVIEW

DESTINO:
REVISOR CENTRAL
```

No implementation.

STOP.
