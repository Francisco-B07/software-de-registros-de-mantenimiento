# CORR-025 — Sincronización documental posterior al cierre de TASK-015

## 1. Identificación

**ID:** `CORR-025`

**Título:** `CORR-025 — Sincronización documental posterior al cierre de TASK-015`

**Tipo:** `CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO`

**Naturaleza:** exclusivamente documental.

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Archivo de specification:**

`CORR-025-task-015-closure-state-sync.md`

**Approved artifact:**

`CORR-025-task-015-closure-state-sync-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/CORR-025-task-015-closure-state-sync.md`

Debe preservarse expresamente:

```text
approved artifact
!=
canonical artifact
```

Estado de gobernanza de este canonical artifact:

```text
POST-TASK-015 DISCOVERY REVIEW = APPROVED

CLOSURE-STATE SYNC REQUIRED = YES

CORR-025 DETERMINATION = APPROVED

CORR-025 SPECIFICATION GENERATION GATE = AUTHORIZED

CORR-025 SPECIFICATION = PASS

CORR-025 SPEC REVIEW = APPROVED

CORR-025 HUMAN SPEC APPROVAL = APPROVED

CORR-025 APPROVED ARTIFACT =
GENERATED

CORR-025 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-025 canonicalized = YES

CORR-025 CANONICALIZATION REVIEW =
PENDING

CORR-025 execution authorized = NO

CORR-025 executed = NO

CORR-025 closed = NO
```

Esta specification:

```text
generated specification
!=
human-approved specification
!=
approved artifact generated
!=
approved artifact reviewed
!=
canonicalized artifact
!=
executed correction
```

y:

```text
generates CORR-025 specification
!= executes CORR-025
!= modifies target
!= authorizes Codex
!= authorizes Git
!= determines TASK-016
```

No se modifica ningún archivo del repositorio durante esta canonicalization.

---

## 2. Objetivo único

CORR-025 tiene como objetivo exclusivo sincronizar el estado activo de:

`docs/product/11-phase-1-scope-entry-gate.md`

después del cierre técnico, de seguridad, Hosted, Git y humano de TASK-015.

La futura corrección debe eliminar únicamente el drift documental activo que todavía representa el lifecycle funcional mínimo de `CompanyMembership` ejecutado por TASK-015 como pendiente o no implementado.

Debe registrar el cierre real y acotado de TASK-015 sin transformar ese incremento en:

- Auth funcional;
- lifecycle funcional completo de usuarios/memberships;
- autorización de aplicación completa;
- autorización funcional completa por rutas;
- autorización funcional completa por recursos;
- implementación de `Client`;
- implementación completa de `UserClientAccess`;
- implementación completa de `SupportAccessGrant`;
- auditoría funcional completa;
- cierre de Fase 2;
- inicio de Fase 3;
- determinación de TASK-016.

Regla obligatoria:

```text
sincronizar estado activo
!=
reescribir snapshots históricos
```

y:

```text
TASK-015 membership lifecycle capability implemented
!=
complete user/membership lifecycle
```

y:

```text
TASK-015 membership lifecycle AuditEvent producers implemented
!=
complete functional audit
```

CORR-025 no implementa ninguna capability.

---

## 3. Contexto formal consumido

Se consume como estado humano formal y cerrado:

```text
POST-TASK-015 DISCOVERY REVIEW = APPROVED

CLOSURE-STATE SYNC REQUIRED = YES

CORR-025 DETERMINATION = APPROVED

TASK-015 = DONE / CLOSED

TASK-015 FINAL HUMAN CLOSURE REVIEW = APPROVED

TASK-015 implementation commit =
e8a8cf53c76f39762d6946b5808819f5db227365
```

También se consumen como hechos cerrados:

```text
AC-015-001..120 = PASS

DoD 51..58 = PASS

Git staging review = APPROVED

Git commit review = APPROVED

Git push review = APPROVED

final remote exact commit verification = PASS
```

Resultado funcional cerrado:

```text
CompanyMembership disable capability =
IMPLEMENTED AND VERIFIED

CompanyMembership reinstate capability =
IMPLEMENTED AND VERIFIED

CompanyMembership role-change capability =
IMPLEMENTED AND VERIFIED
```

Resultado de auditoría cerrado:

```text
real membership mutation
+
required AuditEvent
=
ATOMIC / IMPLEMENTED AND VERIFIED
```

Resultado de seguridad cerrado:

```text
same-tenant invariants =
PRESERVED AND VERIFIED

RLS invariants =
PRESERVED AND VERIFIED

concurrency invariants =
PRESERVED AND VERIFIED
```

Estado de fases:

```text
Phase 2 = INICIADA / NOT DONE

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED

TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED
```

No se deriva ninguna autorización posterior de estos hechos.

---

## 4. Fuentes de verdad

### 4.1 Fuente humana posterior de cierre

Para el estado posterior a la implementación prevalece el cierre humano formal suministrado para TASK-015, dentro de su alcance exacto:

- `TASK-015 = DONE / CLOSED`;
- `TASK-015 FINAL HUMAN CLOSURE REVIEW = APPROVED`;
- commit de implementación cerrado;
- Gates Git aprobados;
- verificación remota exacta PASS;
- AC y DoD cerrados como PASS;
- capability, atomicidad e invariantes verificadas.

Los estados históricos anteriores de TASK-015 no sustituyen este estado activo posterior.

### 4.2 Producto

Se preservan como fuentes canónicas:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- `docs/product/04-offline-sync-strategy.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`.

### 4.3 Arquitectura

Se preservan dentro de su alcance:

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`;
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`;
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`.

### 4.4 Foundations y correcciones relevantes

La futura ejecución deberá consumir, como mínimo:

- `docs/tasks/TASK-009-identity-tenant-foundation.md`;
- `docs/tasks/TASK-010-audit-event-foundation.md`;
- `docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`;
- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`;
- `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`;
- `docs/tasks/CORR-018-task-013-closure-state-sync.md`;
- `docs/tasks/CORR-019-task-014-closure-state-sync.md`;
- `docs/tasks/CORR-020-task-015-product-decisions-documentation-sync.md`.

CORR-018 constituye además un precedente directo para la disciplina de sincronización de estado activo posterior al cierre de una TASK.

### 4.5 Repositorio real

Durante la futura ejecución, el repositorio será fuente de verdad para:

- existencia del target;
- contenido exacto vigente;
- estructura actual de secciones;
- branch;
- `HEAD`;
- `origin/main`;
- divergencia;
- worktree;
- staged changes;
- operaciones Git en progreso;
- presencia efectiva del commit cerrado;
- aparición de modificaciones documentales posteriores.

La specification actual no sustituye ese preflight.

### 4.6 Orden de autoridad

Para CORR-025:

1. decisiones humanas posteriores expresamente aprobadas dentro de su alcance;
2. cierre humano final de TASK-015 y evidencia de cierre aprobada;
3. baseline normativa vigente de producto;
4. documentos derivados dentro de su bounded context;
5. ADR aceptados dentro de sus decisiones arquitectónicas;
6. TASK/CORR canónicas como contratos de materialización, ejecución y estado;
7. repositorio real como fuente de verdad física en el momento de ejecutar;
8. snapshots históricos únicamente como evidencia del estado que documentaban entonces.

Debe aplicarse:

```text
later approved closure state
>
older active stale wording
```

sin convertir:

```text
implementation mechanism
```

en:

```text
new product requirement
```

---

## 5. Revisión de contradicciones

### 5.1 Resultado

No se identifica una contradicción material que impida especificar CORR-025.

Resultado:

```text
MATERIAL BLOCKING CONTRADICTIONS = 0

CORR-025 SPECIFICATION = PASS
```

### 5.2 Drift confirmado

El target conserva estado activo anterior al cierre de TASK-015.

Entre las declaraciones stale se encuentran conceptualmente:

```text
disable/reinstate/role-change funcional = NO
```

y:

```text
Productores funcionales de AuditEvent = NO
```

y:

```text
TASK-015 determinada = NO
TASK-015 generada = NO
TASK-015 iniciada = NO
```

Estas afirmaciones eran correctas después del cierre de TASK-014 y antes de la implementación de TASK-015.

Ya no son correctas como estado activo posterior a su cierre.

### 5.3 Límites de la contradicción

La contradicción no alcanza a todas las capacidades de Identity & Authorization.

Permanecen correctas como pendientes, según corresponda:

```text
Auth funcional = NO

lifecycle funcional completo de usuarios/memberships = NO

Application authorization completa = NO

route authorization funcional completa = NO

resource authorization funcional completa = NO

Client = NO

UserClientAccess completo = NO

SupportAccessGrant completo = NO

auditoría funcional completa = NO
```

Por tanto, CORR-025 debe modificar sólo la granularidad que TASK-015 realmente cerró.

---

## 6. Auditoría de superficies activas stale

La auditoría semántica del único target autorizado determina:

```text
EXPECTED ACTIVE STALE SURFACES = 4

UNEXPECTED ACTIVE STALE SURFACES = 0
```

Superficies:

1. §7.9 — `Otras decisiones DO-*`;
2. §10.2 — `Requisito para entrar en Fase 2`;
3. §14.2 — `Condición adicional para cruzar hacia Fase 2`;
4. §17 — `Resultado final`.

Los múltiples tokens o referencias a TASK-015 contenidos dentro de una misma sección no constituyen superficies independientes.

La unidad de alcance es la superficie semántica.

Resultado:

```text
SPECIFICATION BLOCKER —
UNEXPECTED ACTIVE STALE SURFACE = NO
```

No se autoriza una quinta superficie.

---

## 7. CHANGE REQUIRED

### 7.1 Archivo

Único archivo que puede requerir cambio durante la futura ejecución:

`docs/product/11-phase-1-scope-entry-gate.md`

```text
CHANGE REQUIRED file count = 1
```

### 7.2 Superficies

Dentro de ese archivo:

```text
CHANGE REQUIRED semantic surfaces = 4
```

Exactamente:

- §7.9;
- §10.2;
- §14.2;
- §17.

### 7.3 Regla de localización

Los números de sección actúan como localizadores semánticos.

No autorizan:

- reemplazo por número de línea;
- edición ciega;
- modificación de párrafos no relacionados;
- incorporación silenciosa de una quinta superficie.

---

## 8. Scope exacto

CORR-025 autoriza conceptualmente que una futura ejecución, después de todos los Gates correspondientes:

1. sustituya el estado activo pre-TASK-015 por el estado post-cierre;
2. registre TASK-015 como cerrada;
3. registre su cierre humano;
4. registre el commit de implementación cuando corresponda a la trazabilidad de la superficie;
5. represente `disable/reinstate/role-change` de `CompanyMembership` como implementado y verificado;
6. represente los productores de `AuditEvent` estrictamente asociados a esas tres mutaciones como implementados;
7. represente la atomicidad de mutación real + `AuditEvent` como implementada y verificada;
8. preserve same-tenant;
9. preserve RLS;
10. preserve las garantías verificadas de concurrencia;
11. mantenga las capacidades superiores todavía pendientes;
12. mueva la frontera de gobernanza desde TASK-015 hacia TASK-016;
13. mantenga `Siguiente TASK autorizada automáticamente = NO`;
14. mantenga Fase 2 iniciada pero no completada;
15. mantenga el Phase 2 Exit Gate no definido/no satisfecho;
16. mantenga Fase 3 no iniciada.

---

## 9. Fuera de scope

CORR-025 no autoriza:

- código;
- TypeScript;
- UI;
- React;
- Server Actions;
- endpoints;
- SQL;
- migrations;
- functions/RPC nuevas;
- modificación de functions/RPC existentes;
- policies;
- RLS nueva o modificada;
- grants/revokes;
- Supabase config;
- Supabase Cloud;
- Hosted mutation;
- JIT mutation;
- Auth configuration;
- session mutation;
- Storage;
- Realtime;
- Offline;
- Staging;
- Production;
- modificación de tests;
- nueva ejecución de los tests técnicos de TASK-015;
- modificación de la specification histórica de TASK-015;
- modificación de CORR-020;
- modificación de ADR;
- nueva decisión de producto;
- nueva decisión arquitectónica;
- nueva ADR;
- cambio de dominio;
- cambio de seguridad;
- cambio de multitenancy;
- cambio de RLS;
- alta de usuarios;
- creación de memberships;
- onboarding funcional completo;
- client scope;
- `UserClientAccess`;
- `SupportAccessGrant`;
- Auth funcional;
- route authorization funcional completa;
- resource authorization funcional completa;
- auditoría funcional completa;
- definición del Phase 2 Exit Gate;
- cierre de Fase 2;
- inicio de Fase 3;
- determinación de TASK-016;
- generación de TASK-016;
- especificación de TASK-016;
- implementación de TASK-016;
- priorización automática de la próxima capability.

Tampoco autoriza:

```text
git add
commit
push
```

---

## 10. Estado cerrado de TASK-015 que debe reflejarse

Las superficies autorizadas deben poder representar, donde sea semánticamente pertinente:

```text
TASK-015 = DONE / CLOSED

TASK-015 FINAL HUMAN CLOSURE REVIEW = APPROVED

TASK-015 implementation commit =
e8a8cf53c76f39762d6946b5808819f5db227365
```

Capability:

```text
CompanyMembership disable =
IMPLEMENTED AND VERIFIED

CompanyMembership reinstate =
IMPLEMENTED AND VERIFIED

CompanyMembership role-change =
IMPLEMENTED AND VERIFIED
```

Auditoría del slice:

```text
TASK-015 membership lifecycle AuditEvent producers =
IMPLEMENTED AND VERIFIED
```

Atomicidad:

```text
real membership mutation
IFF
required AuditEvent
```

con resultado:

```text
IMPLEMENTED AND VERIFIED
```

Seguridad:

```text
same-tenant invariants =
PRESERVED AND VERIFIED

RLS invariants =
PRESERVED AND VERIFIED

concurrency invariants =
PRESERVED AND VERIFIED
```

Debe preservarse la semántica de no-op aprobada: una petición ya satisfecha no se convierte artificialmente en una mutación real ni en un `AuditEvent` de una mutación inexistente.

---

## 11. Estado que debe permanecer pendiente

CORR-025 debe mantener inequívocamente:

```text
Auth funcional = NO
```

Debe mantener:

```text
lifecycle funcional completo de usuarios/memberships = NO
```

porque TASK-015 implementó exclusivamente operaciones posteriores sobre una `CompanyMembership` ya existente y autorizada.

Debe mantener:

```text
Application authorization completa = NO

route authorization funcional completa = NO

resource authorization funcional completa = NO
```

Debe mantener:

```text
Client = NO

UserClientAccess completo = NO

SupportAccessGrant completo = NO
```

Debe mantener:

```text
auditoría funcional completa = NO
```

La representación correcta es:

```text
AuditEvent foundation física = SÍ

+

TASK-015 membership lifecycle AuditEvent producers =
IMPLEMENTED

!=

todos los productores funcionales de AuditEvent implementados

!=

auditoría funcional completa
```

Debe mantener además, cuando aparezcan en la superficie:

```text
UI/Auth flow funcional completo = NO

onboarding funcional completo = NO

alta funcional completa = NO

SUPER_ADMIN grant funcional = NO

SUPER_ADMIN revoke funcional = NO

SUPER_ADMIN bootstrap funcional = NO

SUPER_ADMIN management funcional = NO

Storage funcional = NO

Realtime funcional = NO

Offline authorization = NO

Offline funcional = NO
```

Ninguna de estas capacidades debe cambiar de estado por inferencia.

---

## 12. Frontera final de gobernanza

Después de sincronizar TASK-015, la frontera activa debe ser:

```text
TASK-015 = DONE / CLOSED
```

pero:

```text
TASK-015 = DONE / CLOSED
!=
TASK-016 determined automatically
```

Debe quedar:

```text
TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED

Siguiente TASK autorizada automáticamente =
NO
```

Fases:

```text
Phase 2 =
INICIADA / NOT DONE

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED
```

CORR-025 no determina qué capability debe convertirse en TASK-016.

---

## 13. Invariantes preservadas

### 13.1 Tenant

```text
tenant = MaintenanceCompany
```

permanece sin cambios.

### 13.2 Authentication vs authorization

```text
authenticated != authorized
```

permanece vigente.

### 13.3 Estado autoritativo

Debe preservarse:

```text
current authoritative PostgreSQL state
>
JWT / session / cookies / frontend / caller-supplied authority
```

### 13.4 Same-tenant

Las tres operaciones implementadas no crean autoridad cross-tenant.

Debe permanecer:

```text
same-tenant enforcement =
PRESERVED AND VERIFIED
```

### 13.5 RLS

RLS continúa siendo frontera primaria de aislamiento remoto.

CORR-025 sólo documenta que TASK-015 preservó y verificó las invariantes RLS aplicables.

No modifica policies ni privileges.

### 13.6 Atomicidad

Debe permanecer como hecho cerrado del slice:

```text
CompanyMembership real mutation committed
IFF
required AuditEvent committed
```

CORR-025 no modifica ni reimplementa este mecanismo.

### 13.7 Concurrencia

Las garantías de concurrencia de TASK-015 deben quedar registradas como preservadas y verificadas, sin trasladar su mecanismo físico a nueva normativa de producto.

### 13.8 SUPER_ADMIN

TASK-015 no concede esta capability por la mera autoridad global de `SUPER_ADMIN`.

No se introduce bypass tenant ordinario.

### 13.9 Historia

Las especificaciones, blockers, Gates, decisiones y estados previos permanecen válidos como snapshots históricos.

La corrección modifica estado activo, no historia.

---

## 14. Seguridad, RLS y multitenancy

CORR-025 es documental.

Por tanto:

```text
security design change = NO

RLS change = NO

multitenancy change = NO

authorization model change = NO

privileged boundary change = NO
```

La futura ejecución debe limitarse a describir un hecho ya cerrado:

TASK-015 preservó y verificó las invariantes correspondientes.

No debe convertir esa verificación en una nueva autorización global.

En particular:

```text
target membership ID
!= authority

caller-supplied tenant
!= authority

frontend role
!= authority

stale JWT role
!= current authority
```

El target cross-tenant continúa denegado por el contrato cerrado de TASK-015.

No se amplía visibilidad ordinaria de memberships disabled ni acceso ordinario a `audit_events`.

---

## 15. Auditoría de §7.9

### 15.1 Clasificación

```text
ACTIVE STALE REFERENCE — CHANGE
```

### 15.2 Estado stale relevante

§7.9 conserva:

```text
disable/reinstate/role-change funcional = NO
```

y:

```text
Productores funcionales de AuditEvent = NO
```

y mantiene la frontera:

```text
TASK-015 determinada = NO
TASK-015 generada = NO
TASK-015 iniciada = NO
```

### 15.3 Estado final requerido

§7.9 debe representar, en forma coherente con su estilo actual:

```text
TASK-015 = DONE / CLOSED
TASK-015 FINAL HUMAN CLOSURE REVIEW = APPROVED
```

Debe representar:

```text
CompanyMembership disable/reinstate/role-change capability =
IMPLEMENTED AND VERIFIED
```

Debe sustituir la declaración global stale sobre productores por una distinción explícita:

```text
TASK-015 membership lifecycle AuditEvent producers =
IMPLEMENTED AND VERIFIED

auditoría funcional completa =
NO
```

Debe conservar:

```text
lifecycle funcional completo de usuarios/memberships = NO
```

y el resto de capacidades no implementadas.

La frontera debe avanzar a:

```text
TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED

Siguiente TASK autorizada automáticamente =
NO
```

---

## 16. Auditoría de §10.2

### 16.1 Clasificación

```text
ACTIVE STALE REFERENCE — CHANGE
```

### 16.2 Estado stale relevante

La sección reconoce correctamente el cierre de TASK-008..014 pero todavía establece:

```text
TASK-014 DONE/CLOSED
!=
TASK-015 determinada automáticamente
```

y termina manteniendo:

```text
TASK-015 determinada = NO
TASK-015 generada = NO
TASK-015 iniciada = NO
```

### 16.3 Estado final requerido

La sección debe conservar los cierres anteriores y añadir el cierre acotado de TASK-015.

Debe quedar registrado que TASK-015:

- fue especificada y aprobada;
- fue implementada;
- fue verificada;
- fue incorporada mediante los Gates Git aprobados;
- obtuvo cierre humano final;
- queda `DONE / CLOSED`.

Puede registrar el commit:

`e8a8cf53c76f39762d6946b5808819f5db227365`

Debe registrar su resultado funcional únicamente como:

- disable de `CompanyMembership`;
- reinstate de `CompanyMembership`;
- role-change de `CompanyMembership`;
- productores `AuditEvent` correspondientes a esas mutaciones;
- atomicidad mutación real + evento;
- preservación/verificación de same-tenant, RLS y concurrencia.

Debe conservar todos los negativos funcionales que no fueron resueltos.

La nueva frontera de la sección será:

```text
TASK-015 = DONE / CLOSED
!=
TASK-016 determinada automáticamente
```

---

## 17. Auditoría de §14.2

### 17.1 Clasificación

```text
ACTIVE STALE REFERENCE — CHANGE
```

### 17.2 Estado stale relevante

El resumen consolidado de Fase 2 termina actualmente en TASK-014 y conserva como pendientes:

```text
disable/reinstate/role-change funcional = NO
Productores funcionales de AuditEvent = NO
TASK-015 determinada/generada/iniciada = NO
```

### 17.3 Estado final requerido

El resumen consolidado debe añadir TASK-015 como incremento cerrado.

Dentro del párrafo consolidado debe distinguir expresamente:

```text
TASK-015 membership lifecycle operations =
IMPLEMENTED AND VERIFIED
```

de:

```text
lifecycle funcional completo de usuarios/memberships =
NO
```

y:

```text
TASK-015 membership lifecycle AuditEvent producers =
IMPLEMENTED AND VERIFIED
```

de:

```text
auditoría funcional completa =
NO
```

La sección debe conservar:

```text
Fase 2 = INICIADA / NOT DONE

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Fase 3 =
NOT STARTED
```

y cambiar exclusivamente la frontera posterior a:

```text
TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED
```

---

## 18. Auditoría de §17

### 18.1 Clasificación

```text
ACTIVE STALE REFERENCE — CHANGE
```

### 18.2 Estado stale relevante

§17 registra correctamente el cierre de TASK-014 pero su bloque final todavía declara:

```text
disable/reinstate/role-change funcional = NO
Productores funcionales de AuditEvent = NO
```

y:

```text
TASK-015 determinada = no
TASK-015 generada = no
TASK-015 iniciada = no
```

### 18.3 Estado final requerido

§17 debe incorporar en el resultado final:

```text
TASK-015: DONE / CLOSED

TASK-015 FINAL HUMAN CLOSURE REVIEW: APPROVED

TASK-015 implementation commit:
e8a8cf53c76f39762d6946b5808819f5db227365
```

Debe reflejar la capability exacta:

```text
CompanyMembership disable/reinstate/role-change capability:
IMPLEMENTED AND VERIFIED
```

y:

```text
TASK-015 membership lifecycle AuditEvent producers:
IMPLEMENTED AND VERIFIED
```

y conservar:

```text
auditoría funcional completa: no
```

El bloque final de estado deberá terminar conceptualmente con:

```text
Fase 2 completada: no

Phase 2 Exit Gate:
NOT DEFINED / NOT SATISFIED

Fase 3 iniciada: no

TASK-016 determinada: no
TASK-016 generada: no
TASK-016 iniciada: no

Siguiente TASK autorizada automáticamente: no
```

---

## 19. Historia que debe preservarse

No se modificará ningún snapshot histórico.

En particular, deben conservarse como historia:

- el estado anterior a TASK-015;
- la determinación de TASK-015;
- su specification;
- sus decisiones previas;
- sus Gates documentales;
- CORR-020;
- cualquier blocker/resolución intermedia;
- autorizaciones Hosted/JIT cuando existieron;
- staging review;
- commit review;
- push review;
- cierre humano final.

Una referencia histórica del tipo:

```text
TASK-015 implementation authorized = NO
```

puede continuar existiendo en su documento histórico original cuando describe correctamente aquel momento.

No puede continuar como estado activo actual del proyecto.

Regla:

```text
historical state at time T
!=
current active project state
```

---

## 20. Gobierno documental y Git

CORR-025 preserva obligatoriamente la secuencia documental:

```text
generated specification
→ SPEC REVIEW
→ HUMAN SPEC APPROVAL
→ APPROVED ARTIFACT GENERATION
→ APPROVED ARTIFACT REVIEW
→ canonicalization
→ canonicalization review
→ canonical incorporation
→ separate execution authorization
→ fresh Git preflight
→ controlled documentation execution
→ diff review
→ staging Gate
→ commit Gate
→ push Gate
→ final remote verification
→ human closure
```

Los siguientes actos son diferentes y deben permanecer separados:

- generación de specification;
- SPEC REVIEW;
- HUMAN SPEC APPROVAL;
- generación del approved artifact;
- revisión del approved artifact;
- canonicalization;
- canonicalization review;
- canonical incorporation;
- autorización de ejecución;
- ejecución;
- revisión del diff;
- staging;
- commit;
- push;
- verificación remota;
- cierre humano.

El approved artifact se identifica exactamente como:

`CORR-025-task-015-closure-state-sync-approved.md`

La ruta canónica futura continúa siendo:

`docs/tasks/CORR-025-task-015-closure-state-sync.md`

Debe preservarse:

```text
CORR-025-task-015-closure-state-sync-approved.md
!=
docs/tasks/CORR-025-task-015-closure-state-sync.md
```

La HUMAN SPEC APPROVAL no canonicaliza directamente la specification.

Después de HUMAN SPEC APPROVAL existe obligatoriamente un Gate separado para generar el approved artifact y otro Gate separado para revisar ese approved artifact.

El Gate de generación del approved artifact fue autorizado, el approved artifact fue generado y su revisión fue aprobada. El Gate de canonicalization fue autorizado y este canonical artifact ha sido generado; su canonicalization review permanece pendiente.

Sólo después de:

```text
CORR-025 APPROVED ARTIFACT =
GENERATED

CORR-025 APPROVED ARTIFACT REVIEW =
APPROVED
```

puede iniciarse la secuencia de canonicalization mediante su Gate correspondiente.

Esta canonicalization no autoriza canonical incorporation ni ninguno de los actos posteriores.

Debe permanecer:

```text
CORR-025 SPECIFICATION = PASS
!=
CORR-025 SPEC REVIEW = APPROVED
```

y:

```text
CORR-025 SPEC REVIEW = APPROVED
!=
CORR-025 HUMAN SPEC APPROVAL = APPROVED
```

y:

```text
CORR-025 HUMAN SPEC APPROVAL = APPROVED
!=
CORR-025 APPROVED ARTIFACT GENERATED
```

y:

```text
CORR-025 APPROVED ARTIFACT GENERATED
!=
CORR-025 APPROVED ARTIFACT REVIEW APPROVED
```

y:

```text
CORR-025 APPROVED ARTIFACT REVIEW APPROVED
!=
CORR-025 canonicalized
```

y:

```text
CORR-025 canonicalized
!=
CORR-025 execution authorized
```

y:

```text
CORR-025 EXECUTION PASS
!=
CORR-025 DONE / CLOSED
```

---

## 21. Preflight obligatorio de futura ejecución

Antes de modificar el target, Codex deberá comprobar al menos:

1. repository root;
2. branch;
3. `HEAD`;
4. `origin/main`;
5. divergence;
6. worktree;
7. staged files;
8. untracked files relevantes;
9. operaciones Git en progreso;
10. existencia del target;
11. existencia de las fuentes canónicas requeridas;
12. lectura íntegra del target vigente;
13. presencia/verificabilidad del commit de TASK-015 según el baseline autorizado para ejecución;
14. que §7.9 conserva su función semántica;
15. que §10.2 conserva su función semántica;
16. que §14.2 conserva su función semántica;
17. que §17 conserva su función semántica;
18. que siguen existiendo exactamente cuatro superficies stale;
19. que no apareció una quinta superficie activa;
20. que ningún segundo archivo necesita modificación.

La ausencia de un preflight Git durante esta generación documental no es un blocker de specification.

Sí sería blocker de una ejecución concreta.

---

## 22. Plan futuro de ejecución para Codex

Codex sólo podrá recibir esta tarea después de autorización humana separada.

### 22.1 Objetivo

Actualizar exclusivamente el estado activo post-TASK-015 del target autorizado.

### 22.2 Contexto

TASK-015 está cerrada y verificada.

El target permanece parcialmente en estado post-TASK-014.

### 22.3 Alcance

Modificar exclusivamente:

`docs/product/11-phase-1-scope-entry-gate.md`

y conceptualmente sólo:

- §7.9;
- §10.2;
- §14.2;
- §17.

### 22.4 Fuera de alcance

Todo lo definido en §9 de esta specification.

### 22.5 Cambios esperados

Codex deberá:

1. repetir preflight;
2. leer íntegramente target y fuentes relevantes;
3. confirmar exactamente las cuatro superficies;
4. detenerse si existe una quinta;
5. preservar contenido histórico;
6. mantener todos los resultados cerrados de TASK-008..014;
7. incorporar exclusivamente el estado cerrado de TASK-015;
8. sustituir `disable/reinstate/role-change funcional = NO` por la representación acotada implementada;
9. sustituir la afirmación genérica stale sobre productores por la distinción específica de TASK-015;
10. conservar `auditoría funcional completa = NO`;
11. conservar `lifecycle funcional completo de usuarios/memberships = NO`;
12. conservar Auth y authorization funcional pendiente;
13. mover la frontera a TASK-016;
14. mantener Phase 2 abierta;
15. mantener Phase 3 no iniciada;
16. inspeccionar el diff completo;
17. ejecutar `git diff --check`;
18. verificar que sólo existe un archivo modificado;
19. dejar los cambios unstaged;
20. devolver evidencia al Revisor Central.

### 22.6 Seguridad/RLS

No modificar nada técnico.

Confirmar que el texto no implique:

- nueva policy;
- nuevo privilege;
- bypass tenant;
- ampliación de SUPER_ADMIN;
- servicio privilegiado nuevo;
- client scope implementado;
- autorización completa.

### 22.7 Tests de esta corrección

Por ser exclusivamente documental, no se requiere rerun automático de:

- tests DB de TASK-015;
- tests Hosted;
- tests de concurrencia;
- tests RLS;
- tests de aplicación;
- migration apply.

Sí se requiere:

```text
git diff --check = PASS
```

además de inspección literal y semántica del diff.

---

## 23. Blockers

### 23.1 Estado actual

```text
MATERIAL CONTRADICTION = NO

EXPECTED ACTIVE STALE SURFACES = 4

UNEXPECTED ACTIVE STALE SURFACES = 0

SECOND TARGET REQUIRED = NO

NEW ARCHITECTURE DECISION REQUIRED = NO

NEW PRODUCT DECISION REQUIRED = NO

CURRENT SPECIFICATION BLOCKER = NONE
```

### 23.2 Blockers de futura ejecución

La ejecución debe detenerse si:

1. el target no existe;
2. falta una fuente canónica material;
3. el preflight Git no coincide con el baseline expresamente autorizado;
4. el worktree no está limpio cuando el Gate lo exija;
5. existe una operación Git incompatible;
6. una de las cuatro superficies cambió materialmente de función;
7. existe una quinta superficie activa stale;
8. un segundo archivo necesita modificación;
9. resulta necesario modificar producto, dominio o arquitectura;
10. resulta necesario modificar seguridad, RLS o multitenancy;
11. resulta necesario modificar Supabase Cloud;
12. resulta necesario escribir código, SQL o migrations;
13. resulta necesario modificar tests;
14. no puede preservarse la historia sin reescribirla;
15. el cierre de TASK-015 contradice una fuente posterior aprobada;
16. se requiere determinar TASK-016;
17. se requiere definir el Phase 2 Exit Gate;
18. se requiere declarar Fase 2 completada;
19. se requiere iniciar Fase 3;
20. el diff contiene un path inesperado;
21. el diff modifica una sección no autorizada;
22. aparece un secret o credencial;
23. `git diff --check` falla;
24. cualquier criterio de aceptación falla.

Labels:

```text
CORR-025 EXECUTION =
BLOCKER — GIT BASELINE DRIFT
```

cuando corresponda.

Para una quinta superficie:

```text
CORR-025 EXECUTION =
BLOCKER — UNEXPECTED ACTIVE STALE SURFACE
```

Para un segundo target:

```text
CORR-025 EXECUTION =
BLOCKER — UNEXPECTED SECOND TARGET
```

Ante blocker:

```text
NO SILENT REPAIR

NO SCOPE EXPANSION

NO GIT ADD

NO COMMIT

NO PUSH

NO TASK-016

RETURN TO REVISOR CENTRAL
```

---

## 24. Criterios de aceptación

Cada criterio debe resultar individualmente `PASS`.

**AC-025-001.** El ID es `CORR-025`.

**AC-025-002.** El título es `CORR-025 — Sincronización documental posterior al cierre de TASK-015`.

**AC-025-003.** La corrección es exclusivamente documental.

**AC-025-004.** El único target es `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-025-005.** `CHANGE REQUIRED file count = 1`.

**AC-025-006.** Las únicas superficies de cambio son §7.9, §10.2, §14.2 y §17.

**AC-025-007.** `EXPECTED ACTIVE STALE SURFACES = 4`.

**AC-025-008.** `UNEXPECTED ACTIVE STALE SURFACES = 0`.

**AC-025-009.** TASK-015 queda representada como `DONE / CLOSED`.

**AC-025-010.** `TASK-015 FINAL HUMAN CLOSURE REVIEW = APPROVED` queda representado.

**AC-025-011.** El implementation commit queda correctamente identificado cuando la superficie requiere trazabilidad.

**AC-025-012.** Disable de `CompanyMembership` queda representado como implementado y verificado.

**AC-025-013.** Reinstate de `CompanyMembership` queda representado como implementado y verificado.

**AC-025-014.** Role-change de `CompanyMembership` queda representado como implementado y verificado.

**AC-025-015.** Se elimina la declaración activa stale `disable/reinstate/role-change funcional = NO`.

**AC-025-016.** No se declara lifecycle funcional completo de usuarios/memberships.

**AC-025-017.** `lifecycle funcional completo de usuarios/memberships = NO` permanece inequívoco.

**AC-025-018.** Los productores `AuditEvent` estrictamente pertenecientes a TASK-015 quedan representados como implementados.

**AC-025-019.** No se declara que todos los productores funcionales de `AuditEvent` estén implementados.

**AC-025-020.** `auditoría funcional completa = NO` permanece inequívoco.

**AC-025-021.** La atomicidad entre mutación real y `AuditEvent` queda representada sin modificar su diseño.

**AC-025-022.** Same-tenant queda preservado.

**AC-025-023.** RLS queda preservada.

**AC-025-024.** Las garantías de concurrencia verificadas quedan preservadas.

**AC-025-025.** No se introduce bypass cross-tenant.

**AC-025-026.** No se amplía autoridad de `SUPER_ADMIN`.

**AC-025-027.** `Auth funcional = NO` permanece.

**AC-025-028.** `Application authorization completa = NO` permanece.

**AC-025-029.** `route authorization funcional completa = NO` permanece.

**AC-025-030.** `resource authorization funcional completa = NO` permanece.

**AC-025-031.** `Client = NO` permanece.

**AC-025-032.** `UserClientAccess completo = NO` permanece.

**AC-025-033.** `SupportAccessGrant completo = NO` permanece.

**AC-025-034.** El target no sobredeclara onboarding/alta/Auth UI.

**AC-025-035.** Los cierres de TASK-008..014 permanecen intactos.

**AC-025-036.** ADR-0019 permanece como antecedente arquitectónico.

**AC-025-037.** La historia normativa anterior no es reescrita.

**AC-025-038.** Ningún documento histórico es modificado.

**AC-025-039.** Phase 2 permanece `INICIADA / NOT DONE`.

**AC-025-040.** `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED`.

**AC-025-041.** Phase 3 permanece `NOT STARTED`.

**AC-025-042.** TASK-016 permanece `NOT DETERMINED`.

**AC-025-043.** TASK-016 permanece `NOT GENERATED`.

**AC-025-044.** TASK-016 permanece `NOT STARTED`.

**AC-025-045.** `Siguiente TASK autorizada automáticamente = NO`.

**AC-025-046.** CORR-025 no determina TASK-016.

**AC-025-047.** CORR-025 no define el Phase 2 Exit Gate.

**AC-025-048.** CORR-025 no cierra Fase 2.

**AC-025-049.** CORR-025 no inicia Fase 3.

**AC-025-050.** No existe cambio de arquitectura.

**AC-025-051.** No existe cambio de dominio.

**AC-025-052.** No existe cambio de seguridad.

**AC-025-053.** No existe cambio de RLS.

**AC-025-054.** No existe cambio de multitenancy.

**AC-025-055.** No existe cambio de Supabase Cloud.

**AC-025-056.** No existe Hosted mutation.

**AC-025-057.** No existe JIT mutation.

**AC-025-058.** No existe código, SQL o migration.

**AC-025-059.** No se modifica configuración técnica.

**AC-025-060.** No se ejecutan staging, commit ni push dentro de la ejecución documental salvo Gates humanos posteriores y separados.

**AC-025-061.** El diff contiene exactamente un archivo.

**AC-025-062.** El único archivo del diff es el target autorizado.

**AC-025-063.** El diff queda limitado semánticamente a las cuatro superficies autorizadas.

**AC-025-064.** No aparece una superficie stale adicional.

**AC-025-065.** No aparece un segundo target.

**AC-025-066.** `git diff --check = PASS`.

**AC-025-067.** El diff literal completo es revisado.

**AC-025-068.** No se incorpora ningún secret.

**AC-025-069.** La corrección deja los cambios unstaged al finalizar la ejecución inicial de Codex.

**AC-025-070.** La evidencia se devuelve al Revisor Central.

Un único `FAIL` impide declarar satisfactoria la ejecución de CORR-025.

---

## 25. Definition of Done

CORR-025 sólo podrá considerarse `DONE / CLOSED` cuando se cumpla todo lo siguiente:

1. esta specification haya sido generada;
2. `CORR-025 SPECIFICATION = PASS`;
3. el Revisor Central haya revisado la specification;
4. `CORR-025 SPEC REVIEW = APPROVED`;
5. exista `CORR-025 HUMAN SPEC APPROVAL = APPROVED`;
6. exista autorización/Gate separado para generar el approved artifact;
7. se genere exactamente el approved artifact `CORR-025-task-015-closure-state-sync-approved.md`;
8. `CORR-025 APPROVED ARTIFACT = GENERATED`;
9. el approved artifact sea revisado mediante Gate separado;
10. `CORR-025 APPROVED ARTIFACT REVIEW = APPROVED`;
11. sólo después de la aprobación del approved artifact exista autorización/Gate de canonicalization cuando corresponda;
12. la canonicalization sea realizada;
13. `CORR-025 canonicalized = YES`;
14. la canonicalization sea revisada;
15. `CORR-025 CANONICALIZATION REVIEW = APPROVED`;
16. el artefacto canónico sea incorporado mediante los Gates correspondientes;
17. la incorporación canónica sea revisada cuando corresponda;
18. exista autorización humana separada para ejecutar CORR-025;
19. se realice preflight Git fresco;
20. el preflight resulte PASS;
21. se confirme un único target;
22. se confirmen exactamente cuatro superficies;
23. no exista una quinta superficie;
24. se modifique exactamente un archivo;
25. §7.9 quede sincronizada;
26. §10.2 quede sincronizada;
27. §14.2 quede sincronizada;
28. §17 quede sincronizada;
29. TASK-015 quede representada como `DONE / CLOSED`;
30. el cierre humano final quede representado;
31. la capability disable/reinstate/role-change quede representada como implementada;
32. los productores de AuditEvent de TASK-015 queden representados como implementados;
33. se preserve `auditoría funcional completa = NO`;
34. se preserve `lifecycle funcional completo de usuarios/memberships = NO`;
35. se preserve `Auth funcional = NO`;
36. se preserve authorization funcional incompleta;
37. same-tenant permanezca preservado;
38. RLS permanezca preservada;
39. concurrencia permanezca preservada;
40. Phase 2 continúe `INICIADA / NOT DONE`;
41. el Phase 2 Exit Gate continúe `NOT DEFINED / NOT SATISFIED`;
42. Phase 3 continúe `NOT STARTED`;
43. TASK-016 continúe no determinada;
44. TASK-016 continúe no generada;
45. TASK-016 continúe no iniciada;
46. la siguiente TASK no quede autorizada automáticamente;
47. la historia normativa permanezca intacta;
48. no exista cambio técnico;
49. no exista cambio arquitectónico;
50. no exista cambio de seguridad;
51. no exista cambio de RLS;
52. no exista cambio de multitenancy;
53. no exista Cloud mutation;
54. no exista path inesperado;
55. no exista secret leak;
56. todos los Acceptance Criteria resulten PASS;
57. `git diff --check = PASS`;
58. el diff completo sea revisado humanamente;
59. staging sea autorizado por Gate separado;
60. commit sea autorizado por Gate separado;
61. push sea autorizado por Gate separado;
62. Git remoto final sea verificado;
63. exista cierre humano final de CORR-025.

Debe mantenerse:

```text
generated specification
→ SPEC REVIEW
→ HUMAN SPEC APPROVAL
→ APPROVED ARTIFACT GENERATION
→ APPROVED ARTIFACT REVIEW
→ canonicalization
→ canonicalization review
→ canonical incorporation
→ separate execution authorization
```

y:

```text
CORR-025 EXECUTION PASS
!=
CORR-025 DONE / CLOSED
```

y:

```text
CORR-025 DONE / CLOSED
!=
TASK-016 DETERMINED
```

---

## 26. Estado posterior requerido del target

Después de una futura ejecución satisfactoria, el estado activo del target deberá poder resumirse así:

```text
TASK-008 = COMPLETADA
TASK-009 = COMPLETADA
TASK-010 = COMPLETADA
TASK-011 = COMPLETADA
TASK-012 = COMPLETADA
TASK-013 = COMPLETADA
TASK-014 = DONE / CLOSED
TASK-015 = DONE / CLOSED
```

Con resultado adicional de TASK-015:

```text
CompanyMembership disable/reinstate/role-change capability =
IMPLEMENTED AND VERIFIED

TASK-015 membership lifecycle AuditEvent producers =
IMPLEMENTED AND VERIFIED

real mutation + required AuditEvent atomicity =
IMPLEMENTED AND VERIFIED

same-tenant / RLS / concurrency invariants =
PRESERVED AND VERIFIED
```

Mientras continúan:

```text
Auth funcional = NO

lifecycle funcional completo de usuarios/memberships = NO

Application authorization completa = NO

route authorization funcional completa = NO

resource authorization funcional completa = NO

Client = NO

UserClientAccess completo = NO

SupportAccessGrant completo = NO

auditoría funcional completa = NO

Phase 2 = INICIADA / NOT DONE

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 = NOT STARTED

TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED

Siguiente TASK autorizada automáticamente =
NO
```

---

## 27. Estado de esta specification

Resultado documental aprobado previo a la generación del approved artifact:

```text
CORR-025 DETERMINATION =
APPROVED

CORR-025 SPECIFICATION GENERATION GATE =
AUTHORIZED

CORR-025 SPECIFICATION =
PASS

CORR-025 SPEC REVIEW =
APPROVED

CORR-025 HUMAN SPEC APPROVAL =
APPROVED
```

Estado documental tras approved artifact review y canonicalization:

```text
CORR-025 APPROVED ARTIFACT =
GENERATED

CORR-025 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-025 canonicalized =
YES

CORR-025 CANONICALIZATION REVIEW =
PENDING

CORR-025 execution authorized =
NO

CORR-025 executed =
NO

CORR-025 closed =
NO
```

Identidad del approved artifact:

```text
CORR-025-task-015-closure-state-sync-approved.md
```

Ruta canónica futura:

```text
docs/tasks/CORR-025-task-015-closure-state-sync.md
```

Debe permanecer:

```text
approved artifact
!=
canonical artifact
```

Scope determinado:

```text
CHANGE REQUIRED file count =
1

EXPECTED ACTIVE STALE SURFACES =
4

UNEXPECTED ACTIVE STALE SURFACES =
0
```

Se realizó hasta este Gate:

```text
approved artifact generation = YES

approved artifact review = APPROVED

canonicalization = YES
```

No se realizó ningún acto posterior:

```text
canonicalization review = PENDING

canonical incorporation = NO

target modification = NO

repository modification = NO

Codex execution = NO

Supabase Cloud modification = NO

Hosted mutation = NO

JIT mutation = NO

staging = NO

commit = NO

push = NO

TASK-016 determination = NO
```

---

## 28. Gate posterior

El resultado autorizado y materializado en este acto es:

```text
CORR-025 APPROVED ARTIFACT = GENERATED

CORR-025 APPROVED ARTIFACT REVIEW = APPROVED

CORR-025 canonicalized = YES

CORR-025 CANONICALIZATION REVIEW = PENDING
```

El siguiente acto corresponde al Revisor Central para el Gate separado de `CORR-025 CANONICALIZATION REVIEW`.

La secuencia documental y operativa permanece estrictamente separada:

1. `CORR-025 SPEC REVIEW` — `APPROVED`;
2. HUMAN SPEC APPROVAL — `APPROVED`;
3. Gate separado de `APPROVED ARTIFACT GENERATION` — `AUTHORIZED`;
4. generación de `CORR-025-task-015-closure-state-sync-approved.md` — `GENERATED`;
5. Gate separado de `APPROVED ARTIFACT REVIEW` — `APPROVED`;
6. Gate de canonicalization — `AUTHORIZED`;
7. canonicalization — `YES`;
8. canonicalization review — `PENDING`;
9. canonical incorporation mediante los Gates correspondientes;
10. revisión de la incorporación canónica cuando corresponda;
11. autorización humana separada para ejecutar CORR-025;
12. preflight Git fresco;
13. ejecución documental controlada;
14. revisión del diff;
15. staging Gate;
16. commit Gate;
17. push Gate;
18. verificación Git remota;
19. cierre humano final de CORR-025;
20. retorno al Revisor Central;
21. discovery/determinación posterior y separada, sólo si es autorizada.

Debe preservarse exactamente:

```text
generated specification
→ SPEC REVIEW
→ HUMAN SPEC APPROVAL
→ APPROVED ARTIFACT GENERATION
→ APPROVED ARTIFACT REVIEW
→ canonicalization
→ canonicalization review
→ canonical incorporation
→ separate execution authorization
```

La aprobación humana de la specification no autoriza directamente canonicalization.

La generación del approved artifact no implica que haya sido revisado.

La revisión aprobada del approved artifact no implica que haya sido canonicalizado.

La canonicalization no equivale a incorporación canónica.

La incorporación canónica no equivale a autorización de ejecución.

Debe permanecer:

```text
TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED
```

y:

```text
Siguiente TASK autorizada automáticamente =
NO
```

El cierre futuro de CORR-025 no determinará automáticamente TASK-016.

---

# RESULTADO FINAL

```text
CORR-025 APPROVED ARTIFACT GENERATION =
PASS
```

```text
CORR-025 APPROVED ARTIFACT =
GENERATED
```

```text
CORR-025 APPROVED ARTIFACT REVIEW =
APPROVED
```

```text
CORR-025 canonicalized =
YES
```

```text
CORR-025 CANONICALIZATION REVIEW =
PENDING
```

```text
CORR-025 execution authorized =
NO
```

```text
TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED
```

```text
RETURN TO REVISOR CENTRAL
```
