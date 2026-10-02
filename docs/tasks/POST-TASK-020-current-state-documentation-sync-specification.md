# POST-TASK-020 — Current-State Documentation Sync Specification

## 1. Identificación y estado de gobernanza

```text
artifact =
POST-TASK-020-current-state-documentation-sync-specification.md

approved specification source =
POST-TASK-020-current-state-documentation-sync-specification-corrected.md

approved specification source SHA-256 =
ee8ceeeaaf60d77d25d53d9d04885e123ffc8d603702d5625c944f1f16d8822a

class =
DOCUMENTATION CORRECTION SPECIFICATION

specification correction authorization =
APPROVED

F-POST020-SPEC-001 =
RESOLVED IN THIS CORRECTED SPECIFICATION

F-POST020-SPEC-002 =
RESOLVED IN THIS CORRECTED SPECIFICATION

F-POST020-SPEC-003 =
RESOLVED IN THIS CORRECTED SPECIFICATION

source determination =
POST-TASK-020 CURRENT-STATE / NEXT-INCREMENT DETERMINATION = PASS

specification generation authorization =
APPROVED

specification generation =
PASS

POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
HUMAN SPECIFICATION APPROVAL =
APPROVED

specification =
HUMAN APPROVED

approved artifact generation authorization =
APPROVED

approved artifact =
GENERATED / REVIEW APPROVED

POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
APPROVED ARTIFACT REVIEW =
APPROVED

POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
CANONICALIZATION AUTHORIZATION =
APPROVED

POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
CANONICALIZATION =
PASS

canonicalized =
YES

canonical artifact =
GENERATED

canonical future repo-relative path =
docs/tasks/POST-TASK-020-current-state-documentation-sync-specification.md

canonical artifact filename =
POST-TASK-020-current-state-documentation-sync-specification.md

POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
CANONICALIZATION REVIEW =
PENDING

repository incorporation =
NOT AUTHORIZED

implementation authorized =
NO

Codex authorized =
NO

repository mutation authorized =
NO

Supabase mutation authorized =
NO

staging / commit / push =
NO / NO / NO

TASK ID assigned =
NO

TASK-021 generated =
NO

CORR ID assigned =
NO

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED
```

Esta specification define exclusivamente el contrato documental para sincronizar el estado activo posterior al cierre de TASK-020.

La specification fue aprobada humanamente mediante Gate separado. Este artefacto aprobado no modifica documentación canónica, no genera una nueva TASK, no asigna un TASK ID, no implementa el siguiente incremento y no autoriza ninguna mutación de repositorio o Supabase.

---

## 2. Objetivo único

El objetivo único es sincronizar el current-state activo posterior a TASK-020 para que la documentación canónica represente correctamente:

```text
TASK-020 =
DONE / CLOSED

TASK-020 authoritative later-user enrollment intent foundation =
IMPLEMENTED

TASK-020 verification/handoff foundation =
IMPLEMENTED

later-user authoritative intent/challenge/proof/handoff =
IMPLEMENTED WITHIN TASK-020 BOUNDARY
```

sin convertir ese resultado en:

```text
later-user Auth identity/session establishment =
IMPLEMENTED

later-user PlatformUser/profile completion =
IMPLEMENTED

later-user CompanyMembership creation =
IMPLEMENTED

later-user tenant role activation =
IMPLEMENTED

later-user USER_CREATED producer =
IMPLEMENTED

ordinary later-user onboarding =
COMPLETE
```

La sincronización debe registrar estado ya aprobado. No crea una capacidad nueva.

---

## 3. Fuentes de autoridad consumidas

### 3.0 Corpus canónico mínimo físicamente consumido

La corrección de esta specification se realizó únicamente después de comprobar disponibilidad física del corpus mínimo requerido.

```text
docs/product/11-phase-1-scope-entry-gate.md

docs/tasks/TASK-020-authoritative-later-user-enrollment-intent-verification-handoff-foundation.md

docs/tasks/CORR-039-phase-2-phase-3-client-scope-boundary-documentation-sync.md

docs/tasks/CORR-040-task-019-closure-current-state-documentation-sync.md

docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md

docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md
```

Estado de disponibilidad durante esta corrección:

```text
required canonical source corpus =
AVAILABLE / READ

required canonical source unavailable =
NO
```

Identidades físicas especialmente relevantes verificadas desde los bytes disponibles:

```text
docs/product/11-phase-1-scope-entry-gate.md
SHA-256 =
8d02779f7c3528bfec9dff35a20326d676a9be0237ea0aea9398c7f5400c802f

docs/tasks/TASK-020-authoritative-later-user-enrollment-intent-verification-handoff-foundation.md
SHA-256 =
dc3026883b9786509854c686063b7f673e3550d60f2d3fe56c1ec83e50687b14
```

Además se consume el estado humano aprobado de cierre de TASK-020 registrado por el Revisor Central:

```text
TASK-020 FINAL HUMAN CLOSURE =
APPROVED

TASK-020 =
DONE / CLOSED
```

Si cualquiera de estas fuentes obligatorias deja de estar físicamente disponible en un Gate posterior que necesite releerla:

```text
POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC =
BLOCKER — REQUIRED CANONICAL SOURCE UNAVAILABLE

NO reconstruir desde memoria.
NO ampliar scope.
RETURN TO REVISOR CENTRAL.
```

### 3.1 Producto

Se preserva como autoridad normativa de producto:

```text
docs/product/01-product-definition.md
```

En particular:

- RF-013 exige que un `COMPANY_ADMIN` autorizado pueda dar de alta nuevos `COMPANY_ADMIN` y `TECHNICIAN` mediante correo + código;
- RF-014 exige asignar uno de los roles fijos permitidos al crear un usuario;
- RF-015 exige poder asignar uno o más clientes del propio tenant;
- RF-016 prohíbe conceder clientes de otro tenant;
- RF-017 conserva la semántica aprobada de modificación posterior de rol y clientes.

### 3.2 Phase boundary

Se consume y preserva CORR-039:

```text
Client =
Phase 3

physical UserClientAccess required before Phase 2 close =
NO

physical/full SupportAccessGrant required before Phase 2 close =
NO

full Client-dependent support required before Phase 2 close =
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
```

### 3.3 Current-state synchronization precedent

Se consume CORR-040 como precedente de separación entre:

```text
state synchronization
!=
next capability determination
```

y como evidencia de que el current-state activo previo a TASK-020 debía distinguir:

```text
ordinary later-user onboarding =
INCOMPLETE

generic user creation =
INCOMPLETE

generic CompanyMembership creation =
INCOMPLETE

later-user Auth/session composition =
INCOMPLETE

later-user profile completion =
INCOMPLETE

later-user USER_CREATED producer =
INCOMPLETE
```

### 3.4 Arquitectura Auth

Se preserva ADR-0019 como decisión vigente para la frontera Auth/session:

```text
application-owned VerificationChallenge
+
one-time SessionGrant
+
server-only technical password bridge
+
Custom Access Token Hook gate
```

Esta specification no modifica ADR-0019.

### 3.5 TASK-020 closed state

Se consume como estado humano aprobado:

```text
TASK-020 FINAL HUMAN CLOSURE =
APPROVED

TASK-020 =
DONE / CLOSED

implementation commit =
65309909864e80c6abaf8ad88479bce07c530924

TASK-020 Hosted Development =
VERIFIED / REVIEW APPROVED

TASK-020 migration =
20261001234520 PRESENT EXACTLY ONCE

TASK-019 =
PRESERVED

F-020-HOSTED-001 =
CLOSED — GOVERNANCE INCIDENT PRESERVED IN HISTORY
```

La incidencia F-020-HOSTED-001 se conserva como antecedente histórico y no se reinterpreta como ejecución conforme.

---

## 4. Determinación de la superficie documental stale

### 4.1 Target canónico determinado

La inspección física del current canonical target disponible determina:

```text
canonical target count =
1

canonical target =
docs/product/11-phase-1-scope-entry-gate.md
```

### 4.2 Inspección física del target vigente

Fuente física inspeccionada:

```text
docs/product/11-phase-1-scope-entry-gate.md

SHA-256 =
8d02779f7c3528bfec9dff35a20326d676a9be0237ea0aea9398c7f5400c802f
```

La búsqueda física completa de referencias activas a TASK-020 / `LaterUserEnrollmentIntent` demuestra que las declaraciones stale causadas por el cierre posterior de TASK-020 están contenidas en:

```text
# 17. Resultado final
```

No se encontraron referencias activas a TASK-020 fuera de §17 en el target físico inspeccionado.

Por tanto:

```text
CHANGE REQUIRED semantic surface =
EXACTLY §17 — Resultado final
```

La superficie stale concreta dentro de §17 incluye, entre otras, las declaraciones activas que todavía representan:

```text
next TASK =
TASK-020 — Authoritative Later-User Enrollment Intent,
Verification and Handoff Foundation

TASK-020 =
DETERMINED

TASK-020 specification =
NOT GENERATED

TASK-020 implementation =
NOT AUTHORIZED

Codex for TASK-020 =
NOT AUTHORIZED
```

Ese estado fue históricamente correcto antes de la ejecución y cierre de TASK-020, pero ya no representa el current-state vigente.

### 4.3 §6.1 no debe reabrirse

```text
§6.1 — Phase 2 boundary =
NO CHANGE
```

CORR-039 ya resolvió el sequencing `Client = Phase 3`.

Esta specification no autoriza modificar §6.1.

### 4.4 Contrato cerrado de superficie

La futura implementation documental queda limitada a:

```text
modified canonical target count =
EXACTLY 1

modified canonical target =
docs/product/11-phase-1-scope-entry-gate.md

modified semantic surface =
EXACTLY §17 — Resultado final
```

Antes de editar, deberá repetirse un fresh Git/document preflight para verificar que el target físico real no sufrió drift desde esta inspección.

Ese preflight no reabre la determinación de scope. Sólo verifica identidad/baseline.

Si el current target hubiera cambiado de forma que representar correctamente el cierre de TASK-020 exigiera otro archivo o una sección distinta de §17:

```text
POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC =
BLOCKER — UNEXPECTED ACTIVE STALE SURFACE

no silent scope expansion
no mutation
RETURN TO REVISOR CENTRAL
```

---

## 5. Cambio semántico exacto requerido

La futura corrección de §17 debe incorporar como current-state activo, con redacción compatible con el documento, el siguiente significado exacto.

### 5.1 TASK-020 closure

```text
TASK-020 =
DONE / CLOSED

TASK-020 FINAL HUMAN CLOSURE =
APPROVED

TASK-020 implementation commit =
65309909864e80c6abaf8ad88479bce07c530924
```

### 5.2 Capability implementada por TASK-020

```text
TASK-020 authoritative later-user enrollment intent foundation =
IMPLEMENTED

TASK-020 verification/handoff foundation =
IMPLEMENTED

later-user authoritative intent/challenge/proof/handoff =
IMPLEMENTED WITHIN TASK-020 BOUNDARY
```

El significado incluye únicamente la foundation purpose-specific aprobada para:

- intención later-user autoritativa;
- autorización actual del `COMPANY_ADMIN` iniciador donde corresponda;
- issue/resend conforme al lifecycle aprobado;
- binding de intent/challenge;
- proof/consume autoritativo;
- `SessionGrant` / handoff durable requerido por el boundary de TASK-020;
- invariantes de multitenancy, current-state authorization y fail-closed ya revisadas.

No debe ampliarse a pasos posteriores.

### 5.3 Estado pendiente inmediatamente posterior

La misma superficie debe declarar inequívocamente:

```text
later-user Auth identity/session establishment =
NOT IMPLEMENTED

later-user PlatformUser/profile completion =
NOT IMPLEMENTED

later-user CompanyMembership creation =
NOT IMPLEMENTED

later-user tenant role activation =
NOT IMPLEMENTED

later-user USER_CREATED producer =
NOT IMPLEMENTED

ordinary later-user onboarding =
INCOMPLETE
```

### 5.4 Requisitos de producto

Debe quedar explícita la diferencia entre foundation y requisito end-to-end:

```text
full RF-013 =
NOT YET COMPLETE

RF-014 =
NOT YET COMPLETE END-TO-END

RF-015 =
MANDATORY / NOT YET SATISFIABLE BEFORE CLIENT

RF-016 =
UNCHANGED

RF-017 =
UNCHANGED
```

No se puede declarar `RF-013 = complete` sólo porque ya exista intent/verification/handoff.

No se puede declarar `RF-014 = complete` mientras no exista creación/materialización efectiva del usuario/membership con el rol fijado por el enrollment autorizado.

No se puede declarar `RF-015 = complete` ni sustituirlo por cero clientes.

### 5.5 Client-dependent state

Debe preservarse:

```text
Client =
PHASE 3

physical UserClientAccess required before Phase 2 close =
NO

physical/full SupportAccessGrant required before Phase 2 close =
NO

full Client-dependent support required before Phase 2 close =
NO

zero client assignment satisfies RF-015 =
NO
```

### 5.6 Phase state

Debe preservarse:

```text
Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED

next TASK =
NOT YET ASSIGNED
```

El cierre de TASK-020 no define por inferencia el Phase 2 Exit Gate.

---

## 6. Historia normativa que debe preservarse

La futura corrección no debe modernizar retrospectivamente artefactos históricos.

Debe aplicarse:

```text
historically correct at its documented point in time
=
PRESERVE
```

y:

```text
active current-state statement contradicted
by later approved TASK-020 closure
=
CHANGE
```

No modificar:

- TASK-020 canonical specification;
- artefactos históricos TASK-017/018/019;
- CORR-039;
- CORR-040;
- ADR-0019;
- anteriores Gate outcomes;
- autorizaciones históricas;
- evidencia del incidente F-020-HOSTED-001;
- snapshots históricos que fueran correctos en su fecha.

El único objetivo es el snapshot activo vigente.

---

## 7. Invariantes de producto, dominio, seguridad y RLS

Esta sincronización debe registrar:

```text
product requirement change =
NO

domain change =
NO

architecture change =
NO

security change =
NO

RLS change =
NO

multitenancy change =
NO

Auth architecture change =
NO

offline change =
NO

new ADR required =
NO
```

Debe preservar expresamente:

```text
tenant =
MaintenanceCompany

authenticated != authorized

Auth session != tenant authorization

current authoritative PostgreSQL state > stale claims

RLS =
primary remote tenant-isolation boundary

SUPER_ADMIN ordinary tenant bypass =
NO
```

La documentación no puede presentar un `SessionGrant`, una sesión Auth o un handoff como autoridad tenant.

---

## 8. Fuera de alcance

Esta specification no autoriza ni define:

- TASK-021;
- ningún otro TASK ID;
- specification del siguiente incremento;
- Auth identity reconciliation later-user;
- Auth user provisioning later-user;
- establishment de sesión later-user;
- PlatformUser/profile completion later-user;
- CompanyMembership creation later-user;
- role activation later-user;
- `USER_CREATED` later-user;
- `Client`;
- `UserClientAccess`;
- `SupportAccessGrant`;
- assignment de clientes;
- cierre de RF-015;
- Phase 2 Exit Gate;
- cierre de Phase 2;
- inicio de Phase 3;
- código TypeScript;
- React/UI nueva;
- SQL;
- migration;
- RLS ejecutable;
- functions/RPC;
- grants/revokes;
- Supabase Auth config;
- Supabase Cloud mutation;
- repositorio;
- Git staging;
- commit;
- push.

---

## 9. Regla sobre el siguiente incremento

Existe una determinación separada posterior a TASK-020 que identifica conceptualmente como próximo incremento:

```text
AUTHORITATIVE LATER-USER AUTH IDENTITY RECONCILIATION
AND INITIAL SESSION ESTABLISHMENT FOUNDATION
```

Pero esta documentation sync:

```text
does not assign TASK ID
does not generate TASK specification
does not authorize implementation
```

La future sync puede registrar, como máximo, que el next TASK continúa no asignado.

No debe convertir el resultado de determinación en una TASK por inferencia.

---

## 10. Acceptance Criteria

**AC-POST020-001.** El artefacto se identifica como documentation correction specification post-TASK-020.

**AC-POST020-002.** `TASK-020 FINAL HUMAN CLOSURE = APPROVED` se consume como hecho previo, no se vuelve a aprobar.

**AC-POST020-003.** `TASK-020 = DONE / CLOSED` queda requerido en el current-state activo.

**AC-POST020-004.** El implementation commit requerido es exactamente `65309909864e80c6abaf8ad88479bce07c530924`.

**AC-POST020-005.** `TASK-020 authoritative later-user enrollment intent foundation = IMPLEMENTED`.

**AC-POST020-006.** `TASK-020 verification/handoff foundation = IMPLEMENTED`.

**AC-POST020-007.** `later-user authoritative intent/challenge/proof/handoff = IMPLEMENTED WITHIN TASK-020 BOUNDARY`.

**AC-POST020-008.** La corrección no declara later-user Auth identity/session establishment implementado.

**AC-POST020-009.** La corrección no declara later-user PlatformUser/profile completion implementado.

**AC-POST020-010.** La corrección no declara later-user CompanyMembership creation implementado.

**AC-POST020-011.** La corrección no declara later-user tenant role activation implementado.

**AC-POST020-012.** La corrección no declara later-user `USER_CREATED` implementado.

**AC-POST020-013.** `ordinary later-user onboarding = INCOMPLETE`.

**AC-POST020-014.** `full RF-013 = NOT YET COMPLETE`.

**AC-POST020-015.** `RF-014 = NOT YET COMPLETE END-TO-END`.

**AC-POST020-016.** `RF-015 = MANDATORY / NOT YET SATISFIABLE BEFORE CLIENT`.

**AC-POST020-017.** RF-013..RF-017 no son redefinidos.

**AC-POST020-018.** Cero clientes no satisface RF-015.

**AC-POST020-019.** `Client = Phase 3`.

**AC-POST020-020.** No se mueve Client físico, placeholder, mínimo o temporal a Phase 2.

**AC-POST020-021.** Physical `UserClientAccess` no se convierte en requisito para cerrar Phase 2.

**AC-POST020-022.** Physical/full `SupportAccessGrant` no se convierte en requisito para cerrar Phase 2.

**AC-POST020-023.** Full Client-dependent support no se convierte en requisito para cerrar Phase 2.

**AC-POST020-024.** CORR-039 permanece sin cambios.

**AC-POST020-025.** ADR-0019 permanece sin cambios.

**AC-POST020-026.** `authenticated != authorized`.

**AC-POST020-027.** `Auth session != tenant authorization`.

**AC-POST020-028.** Current authoritative PostgreSQL state prevalece sobre stale claims.

**AC-POST020-029.** RLS continúa siendo la barrera primaria remota de aislamiento tenant.

**AC-POST020-030.** `SUPER_ADMIN ordinary tenant bypass = NO`.

**AC-POST020-031.** Exact canonical target count = 1.

**AC-POST020-032.** Exact canonical target = `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-POST020-033.** Exact semantic mutation surface = `§17 — Resultado final`.

**AC-POST020-034.** §6.1 no se reabre.

**AC-POST020-035.** Los artefactos históricos no se reescriben.

**AC-POST020-036.** No se asigna TASK ID.

**AC-POST020-037.** TASK-021 no se genera.

**AC-POST020-038.** `Phase 2 = IN PROGRESS / NOT CLOSED`.

**AC-POST020-039.** `Phase 2 Exit Gate = NOT YET DEFINED`.

**AC-POST020-040.** `Phase 3 = NOT STARTED`.

**AC-POST020-041.** `next TASK = NOT YET ASSIGNED`.

**AC-POST020-042.** Product/domain/security/RLS/multitenancy/Auth/offline semantics no cambian.

**AC-POST020-043.** `new ADR required = NO`.

**AC-POST020-044.** No se modifica repositorio durante specification generation.

**AC-POST020-045.** No se modifica Supabase durante specification generation.

**AC-POST020-046.** No se usa Codex para implementación durante specification generation.

**AC-POST020-047.** Una superficie activa inesperada adicional produce blocker; no scope expansion silencioso.

**AC-POST020-048.** Una nueva decisión material de producto o arquitectura produce blocker.

---

## 11. Definition of Done de la correction documental futura

La documentation sync sólo podrá considerarse cerrada cuando:

**DoD-POST020-001.** Esta specification recibe review separado y `APPROVED`.

**DoD-POST020-002.** Existe aprobación humana formal de la specification.

**DoD-POST020-003.** Se genera obligatoriamente un artefacto aprobado mediante Gate separado después de la aprobación humana formal de la specification.

**DoD-POST020-004.** El artefacto aprobado supera obligatoriamente un `APPROVED ARTIFACT REVIEW = APPROVED` separado antes de canonicalización.

**DoD-POST020-005.** La specification se canonicaliza mediante Gate separado.

**DoD-POST020-006.** La canonicalización supera review separado.

**DoD-POST020-007.** El artefacto canónico se incorpora al repositorio mediante autorización separada.

**DoD-POST020-008.** La incorporación canónica supera review separado.

**DoD-POST020-009.** Existe autorización humana separada para ejecutar la corrección sobre el target canónico.

**DoD-POST020-010.** Un fresh Git/document preflight verifica el baseline físico real.

**DoD-POST020-011.** El target real coincide con el scope esperado o cualquier drift es devuelto al Revisor Central.

**DoD-POST020-012.** Exact modified canonical target count = 1.

**DoD-POST020-013.** Exact modified canonical target = `docs/product/11-phase-1-scope-entry-gate.md`.

**DoD-POST020-014.** Todas las modificaciones semánticas quedan confinadas a §17 salvo autorización humana posterior.

**DoD-POST020-015.** El diff registra TASK-020 cerrado y sus foundations implementadas.

**DoD-POST020-016.** El diff mantiene explícitamente incompletos Auth/session y completion downstream.

**DoD-POST020-017.** El diff preserva CORR-039.

**DoD-POST020-018.** El diff preserva RF-013..RF-017.

**DoD-POST020-019.** El diff preserva las invariantes de multitenancy/RLS/authorization.

**DoD-POST020-020.** El diff no asigna ni genera TASK-021.

**DoD-POST020-021.** El diff no define Phase 2 Exit Gate.

**DoD-POST020-022.** El diff no cierra Phase 2.

**DoD-POST020-023.** El diff no inicia Phase 3.

**DoD-POST020-024.** `git diff --check = PASS`.

**DoD-POST020-025.** No existe whitespace cleanup, formatting refactor o line-ending normalization ajeno al cambio autorizado.

**DoD-POST020-026.** La evidencia física post-edit reporta SHA-256, bytes, LF, CRLF, bare CR, trailing-whitespace lines y final newline del target.

**DoD-POST020-027.** La implementación documental obtiene `IMPLEMENTATION REVIEW = APPROVED`.

**DoD-POST020-028.** Staging requiere Gate humano separado.

**DoD-POST020-029.** Staging review requiere Gate separado.

**DoD-POST020-030.** Commit requiere Gate humano separado.

**DoD-POST020-031.** Commit review requiere Gate separado.

**DoD-POST020-032.** Push requiere Gate humano separado.

**DoD-POST020-033.** Push review / remote verification requiere Gate separado.

**DoD-POST020-034.** Existe final human closure de la documentation sync.

**DoD-POST020-035.** El cierre de la documentation sync no equivale a determinar o generar la siguiente TASK.

---

## 12. Blockers

La futura execution debe detenerse ante cualquiera de estas condiciones:

1. el target canónico esperado no existe;
2. existe más de un target activo que requiera corrección;
3. TASK-020 no aparece realmente en el commit remoto aprobado;
4. el cierre humano de TASK-020 no puede verificarse en la evidencia de gobernanza disponible;
5. corregir el current-state exige modificar producto;
6. corregir el current-state exige modificar dominio;
7. corregir el current-state exige modificar arquitectura;
8. corregir el current-state exige modificar seguridad/RLS;
9. corregir el current-state exige modificar multitenancy;
10. corregir el current-state exige modificar ADR-0019;
11. corregir el current-state exige reabrir CORR-039;
12. se necesita declarar RF-013 completo;
13. se necesita declarar RF-014 completo end-to-end;
14. se necesita declarar RF-015 satisfecho sin Client;
15. se necesita mover Client a Phase 2;
16. se necesita inventar un Client placeholder;
17. se necesita modificar otro archivo canónico;
18. se necesita modificar una sección distinta de §17;
19. se necesita asignar TASK-021;
20. se necesita definir Phase 2 Exit Gate;
21. se necesita cerrar Phase 2;
22. se necesita iniciar Phase 3;
23. aparece una nueva decisión material de producto o arquitectura;
24. el baseline físico actual contiene drift que esta specification no puede corregir sin ampliar scope.

Resultado ante blocker:

```text
POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC =
BLOCKER

no silent repair
no scope expansion
no repository mutation
no Supabase mutation
no TASK generation

RETURN TO REVISOR CENTRAL
```

---

## 13. Estrategia de verificación documental futura

La futura implementación deberá demostrar al menos:

1. fresh Git baseline;
2. branch / HEAD / origin / divergence;
3. worktree inicialmente limpio salvo cambio expresamente autorizado;
4. SHA-256 y métricas físicas pre-edit del target;
5. exact changed path inventory;
6. diff completo;
7. prueba de que los hunks semánticos están en §17;
8. búsqueda negativa de sobredeclaraciones:
   - `ordinary later-user onboarding = complete`;
   - later-user Auth/session = implemented;
   - generic CompanyMembership creation = implemented;
   - RF-015 satisfied;
   - Client in Phase 2;
   - Phase 2 closed;
   - Phase 3 started;
   - TASK-021 assigned/generated;
9. búsqueda positiva de TASK-020 closure y implementation commit;
10. `git diff --check`;
11. métricas físicas post-edit;
12. evidencia de que no se ejecutaron application/database/Supabase tests por tratarse de un cambio documental puro, salvo que una revisión posterior los exija por una razón concreta.

---

## 14. Lifecycle documental posterior

Después de esta generación:

```text
SPECIFICATION REVIEW
```

Si se aprueba, el lifecycle posterior debe continuar mediante Gates separados, sin inferencia automática:

```text
SPEC REVIEW
→ HUMAN SPEC APPROVAL
→ APPROVED ARTIFACT GENERATION
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

Sólo después del cierre de esta synchronization podrá evaluarse un Gate separado para especificar el próximo incremento.

---

## 15. Resultado formal de esta generación

```text
POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
SPECIFICATION GENERATION =
PASS

specification =
HUMAN APPROVED

POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
HUMAN SPECIFICATION APPROVAL =
APPROVED

approved specification source =
POST-TASK-020-current-state-documentation-sync-specification-corrected.md

approved specification source SHA-256 =
ee8ceeeaaf60d77d25d53d9d04885e123ffc8d603702d5625c944f1f16d8822a

canonical target count =
1

canonical target =
docs/product/11-phase-1-scope-entry-gate.md

CHANGE REQUIRED semantic surface =
EXACTLY §17 — Resultado final

§6.1 =
NO CHANGE

new product decision =
NO

new architecture decision =
NO

new ADR required =
NO

TASK ID assigned =
NO

TASK-021 generated =
NO

repository mutation =
NO

Supabase mutation =
NO

F-POST020-SPEC-001 =
RESOLVED

F-POST020-SPEC-002 =
RESOLVED

F-POST020-SPEC-003 =
RESOLVED

open specification findings =
0

corrected specification =
HUMAN APPROVED

POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
APPROVED ARTIFACT GENERATION =
PASS

approved artifact =
GENERATED / REVIEW APPROVED

approved artifact filename =
POST-TASK-020-current-state-documentation-sync-specification-approved.md

POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
APPROVED ARTIFACT REVIEW =
APPROVED

POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
CANONICALIZATION AUTHORIZATION =
APPROVED

POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
CANONICALIZATION =
PASS

canonicalized =
YES

canonical artifact =
GENERATED

canonical future repo-relative path =
docs/tasks/POST-TASK-020-current-state-documentation-sync-specification.md

canonical artifact filename =
POST-TASK-020-current-state-documentation-sync-specification.md

POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
CANONICALIZATION REVIEW =
PENDING

repository incorporation =
NOT AUTHORIZED

semantic drift =
NONE

source artifact mutation =
NO

next gate =
POST-TASK-020 CURRENT-STATE DOCUMENTATION SYNC
CANONICALIZATION REVIEW

DESTINO =
REVISOR CENTRAL — ESTE MISMO CHAT

STOP.
```
