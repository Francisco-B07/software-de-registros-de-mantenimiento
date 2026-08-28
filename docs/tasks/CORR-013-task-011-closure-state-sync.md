# CORR-013 — Sincronización documental posterior al cierre de TASK-011

## 1. Identificación

**ID:** `CORR-013`

**Título:** `CORR-013 — Sincronización documental posterior al cierre de TASK-011`

**Tipo:** `CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`CORR-013-task-011-closure-state-sync-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/CORR-013-task-011-closure-state-sync.md`

**Naturaleza:** exclusivamente documental.

**CORR-013 determinada:** `SÍ`

**CORR-013 generada:** `SÍ`

**CORR-013 especificada:** `SÍ`

**CORR-013 aprobada:** `SÍ`

**CORR-013 SPECIFICATION:** `PASS`

**CORR-013 SPEC REVIEW:** `APPROVED`

**Implementación realizada:** `NO`

**Ejecución concreta autorizada:** `NO`

**Codex utilizado:** `NO`

**Repositorio modificado durante esta preparación:** `NO`

**`docs/product/11-phase-1-scope-entry-gate.md` modificado durante esta preparación:** `NO`

**Supabase Cloud modificado:** `NO`

**Git modificado:** `NO`

**TASK-012 determinada:** `NO`

**TASK-012 generada:** `NO`

**TASK-012 especificada:** `NO`

**TASK-012 aprobada:** `NO`

**TASK-012 autorizada:** `NO`

Esta especificación no constituye una ejecución documental y no autoriza ninguna modificación del repositorio.

El estado documental aprobado de CORR-013 es:

```text
APPROVED FOR IMPLEMENTATION
```

Este estado significa exclusivamente que la especificación documental está aprobada para una futura ejecución separadamente autorizada.

No deben utilizarse como estado de cierre o ejecución de CORR-013:

```text
DONE
COMPLETED
```

`APPROVED FOR IMPLEMENTATION` no autoriza ejecución ahora, modificación del repositorio, uso de Codex, canonicalización, Git ni Supabase Cloud.

---

## 2. Objetivo único

CORR-013 tiene un único objetivo:

> sincronizar exclusivamente las referencias **activas y actuales** que quedaron materialmente obsoletas después del cierre humano, técnico y Git de `TASK-011`.

La regla fundamental es:

```text
sincronizar estado activo
!=
reescribir historia
```

CORR-013:

- no crea el cierre de TASK-011;
- no reevalúa TASK-011;
- no modifica TASK-011;
- no cambia producto;
- no cambia arquitectura;
- no cambia seguridad;
- no cambia multitenancy;
- no cambia RLS;
- no implementa capacidades;
- no completa Auth;
- no implementa autorización;
- no diseña `VerificationChallenge`;
- no diseña `Client`;
- no diseña `UserClientAccess`;
- no diseña `SupportAccessGrant`;
- no diseña productores funcionales de `AuditEvent`;
- no determina TASK-012;
- no genera TASK-012;
- no diseña TASK-012;
- no incorpora como decisión propia ninguna recomendación técnica sobre el siguiente incremento.

Su único efecto futuro permitido es:

```text
estado humano/técnico cerrado de TASK-011
→ sincronización mínima de referencias activas stale
→ preservación íntegra de historia
→ revisión humana
```

La corrección debe limitarse a reflejar un hecho ya cerrado. No puede utilizarse como vehículo para introducir una nueva decisión de producto, arquitectura, autorización o secuenciación técnica.

---

## 3. Estado autoritativo consumido

CORR-013 consume como estado humano y técnico ya cerrado:

```text
Fase 0 = COMPLETADA
Fase 1 = COMPLETADA
Fase 2 = INICIADA

TASK-008 = COMPLETADA
TASK-009 = COMPLETADA
TASK-010 = COMPLETADA
CORR-012 = COMPLETADA
TASK-011 = COMPLETADA
```

Para TASK-011 se consume:

```text
TASK-011 determinada = SÍ
TASK-011 generada = SÍ
TASK-011 especificada = SÍ
TASK-011 aprobada = SÍ
TASK-011 canonicalizada = SÍ
TASK-011 implementada técnicamente = SÍ
TASK-011 implementation review = APPROVED
TASK-011 implementation Git incorporation = APPROVED
TASK-011 cierre humano final = APPROVED
```

Commit de implementación recibido como evidencia histórica:

```text
3f4d0d2fab8f8b11dfff749de7df50aa560c301c
```

Último snapshot Git humano verificado recibido:

```text
branch = main
HEAD = 3f4d0d2fab8f8b11dfff749de7df50aa560c301c
origin/main = 3f4d0d2fab8f8b11dfff749de7df50aa560c301c
divergencia = 0 0
worktree = limpio
staged = ninguno
```

Ese SHA y ese snapshot documentan el cierre técnico y Git de TASK-011.

No constituyen una precondición inmutable para una futura canonicalización o ejecución de CORR-013.

La futura ejecución deberá realizar un preflight Git fresco, inspeccionar el repositorio real y reconciliar cualquier cambio posterior con tareas o correcciones aprobadas. El repositorio real manda sobre snapshots históricos.

---

## 4. Resultado técnico cerrado de TASK-011

TASK-011 materializó exclusivamente:

```text
Auth SSR lifecycle foundation = IMPLEMENTADA
SSR cookie propagation boundary = IMPLEMENTADA
Auth Proxy technical boundary = IMPLEMENTADA
```

Para sincronizar estado activo puede describirse, cuando el wording real del documento afectado lo requiera, la existencia técnica de:

- server client request-scoped;
- contrato SSR `getAll` / `setAll`;
- Proxy técnico;
- propagación request/response de cookies;
- headers anti-cache asociados a la propagación de cookies;
- validación técnica de identidad Auth dentro de la frontera implementada.

Estas expresiones sólo describen infraestructura técnica cerrada por TASK-011.

Debe preservarse obligatoriamente:

```text
Auth SSR lifecycle foundation
!=
Auth funcional
!=
autorización
!=
tenant authorization
!=
route authorization
```

También debe preservarse:

```text
Proxy técnico
!=
Proxy/middleware Auth funcional
```

La existencia de una primitive técnica para validar identidad Auth no autoriza a inferir tenant, membership, role, client scope, support scope ni permiso funcional.

CORR-013 no puede reinterpretar la evidencia técnica de TASK-011 como un cierre funcional de Identity & Access.

---

## 5. Capacidades que continúan ausentes

Después del cierre de TASK-011 continúa como estado activo:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Refresh funcional de access token = NO
Proxy/middleware Auth funcional = NO

Authorization ready = NO
route authorization = NO
tenant resolver = NO
role resolver = NO
Application authorization completa = NO

VerificationChallenge = NO

Client = NO
UserClientAccess = NO
SupportAccessGrant = NO

Storage funcional = NO
Realtime funcional = NO
Offline funcional = NO

UI funcional de Auth = NO

Productores funcionales de AuditEvent = NO
auditoría funcional completa = NO
```

En particular:

```text
foundation técnica implementada
!=
capacidad funcional implementada
```

```text
identidad Auth técnicamente validable
!=
actor autorizado para un recurso tenant-owned
```

```text
cookie propagation
!=
login funcional
!=
refresh funcional end-to-end de producto
```

CORR-013 no puede convertir una foundation técnica en capacidad funcional por redacción, simplificación o inferencia.

---

## 6. Resultado aprobado del discovery post-TASK-011

CORR-013 consume como actos formales previos ya cerrados:

```text
POST-TASK-011 DOCUMENTARY DISCOVERY = PASS
POST-TASK-011 DOCUMENTARY DISCOVERY REVIEW = APPROVED
POST-TASK-011 DOCUMENTARY CORRECTION REQUIRED = YES
```

CORR-013 consume sin reabrir la siguiente clasificación ya aprobada por el Revisor Central.

### `CHANGE REQUIRED`

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Cantidad:

```text
1
```

Superficies activas stale confirmadas:

```text
§7.9
§10.2
§14.2
§17
```

### `NO CHANGE REQUIRED`

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md

docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

### `HISTORICAL/GOVERNANCE — KEEP`

```text
docs/tasks/TASK-008-supabase-application-boundary.md
docs/tasks/CORR-010-task-008-closure-state-sync.md
docs/tasks/TASK-009-identity-tenant-foundation.md
docs/tasks/CORR-011-task-009-closure-state-sync.md
docs/tasks/TASK-010-audit-event-foundation.md
docs/tasks/CORR-012-task-010-closure-state-sync.md
docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md
```

### `UNEXPECTED — BLOCKER`

```text
0
```

CORR-013 no vuelve a decidir esta clasificación durante su preparación.

La futura ejecución debe repetir la auditoría read-only contra el repositorio real únicamente para confirmar que el resultado sigue siendo aplicable, no para ampliar automáticamente el scope aprobado.

Si esa auditoría detecta un segundo documento que materialmente requiera cambio, la ejecución debe detenerse con `BLOCKER`.

---

## 7. Fuentes de verdad

La futura ejecución debe leer íntegramente y respetar, como mínimo, las siguientes fuentes canónicas.

### 7.1 Producto

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

### 7.2 Arquitectura

```text
docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

### 7.3 Tareas y correcciones

```text
docs/tasks/TASK-008-supabase-application-boundary.md
docs/tasks/CORR-010-task-008-closure-state-sync.md
docs/tasks/TASK-009-identity-tenant-foundation.md
docs/tasks/CORR-011-task-009-closure-state-sync.md
docs/tasks/TASK-010-audit-event-foundation.md
docs/tasks/CORR-012-task-010-closure-state-sync.md
docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md
```

### 7.4 Repositorio real y evidencia Git

La futura ejecución debe inspeccionar el repositorio real y el commit:

```text
3f4d0d2fab8f8b11dfff749de7df50aa560c301c
```

La inspección del commit debe utilizarse como trazabilidad histórica del slice TASK-011, no como permiso para modificar archivos técnicos.

La futura ejecución debe comprobar que el repositorio real sigue siendo compatible con el estado autoritativo que CORR-013 pretende sincronizar.

### 7.5 Regla de autoridad

Ante una contradicción material entre:

- el repositorio real;
- documentación canónica vigente;
- el cierre humano de TASK-011;
- la especificación canónica futura de CORR-013;

el resultado debe ser:

```text
BLOCKER
```

No resolver contradicciones por inferencia, conveniencia, modernización retrospectiva ni ampliación silenciosa de scope.

---

## 8. Precedente de gobernanza: CORR-012

CORR-012 se utiliza exclusivamente como precedente de gobernanza para la secuencia:

```text
cierre de TASK
→ auditoría documental
→ corrección mínima de estado activo
→ preservación de historia
→ revisión humana
→ ninguna determinación automática de siguiente TASK
```

CORR-013 no debe copiar mecánicamente CORR-012.

Debe adaptar ese patrón al resultado real y cerrado de TASK-011.

La diferencia material es que CORR-013 debe sincronizar una foundation técnica de lifecycle Auth SSR, no una foundation física de AuditEvent.

Por ello no debe importar a CORR-013:

- detalles físicos de `audit_events`;
- acciones físicas de AuditEvent;
- privilegios o tests específicos de TASK-010;
- wording de Development Gate propio de TASK-010;
- ningún detalle que no sea necesario para reflejar el cierre real de TASK-011.

Se preserva, sin embargo, la misma separación de gobernanza:

```text
TASK cerrada
!=
siguiente TASK determinada
```

---

## 9. Taxonomía documental obligatoria

Toda coincidencia material revisada por una futura ejecución de CORR-013 debe clasificarse exclusivamente en una de estas cuatro categorías.

### 9.1 `ACTIVE STALE REFERENCE — CHANGE`

Aplica cuando una referencia:

- pretende describir el estado global o actual del proyecto;
- quedó materialmente falsa después del cierre de TASK-011;
- puede sincronizarse sin crear una decisión nueva;
- se encuentra dentro del único documento autorizado para modificación;
- su actualización es necesaria para que el estado activo refleje TASK-011 cerrada y la nueva frontera hacia TASK-012.

Sólo esta categoría autoriza una modificación dentro de CORR-013.

### 9.2 `VALID CURRENT REFERENCE — KEEP`

Aplica cuando una referencia:

- continúa siendo verdadera en el estado actual;
- expresa una regla de producto, arquitectura, seguridad o governance que no cambió por TASK-011;
- o describe correctamente una capacidad que continúa ausente.

Ejemplos obligatorios a preservar incluyen:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Authorization ready = NO
```

Una referencia current válida no se reescribe por conveniencia editorial.

### 9.3 `HISTORICAL/GOVERNANCE — KEEP`

Aplica cuando una referencia:

- documenta correctamente el estado de una TASK, CORR, ADR, Gate o acto humano en el momento en que fue aprobado;
- forma parte de un contrato histórico/normativo;
- puede utilizar wording prospectivo o pre-implementación que era correcto en ese momento;
- no pretende describir el estado global actual.

Esta categoría debe preservarse aunque el proyecto haya avanzado posteriormente.

En particular, un contrato histórico no se convierte retrospectivamente en changelog.

### 9.4 `UNEXPECTED — BLOCKER`

Aplica cuando una coincidencia material:

- requiere modificar un archivo no autorizado;
- contradice la clasificación aprobada del discovery;
- impide distinguir con seguridad estado activo de historia;
- exige una decisión nueva;
- exige modificar producto, arquitectura, seguridad, RLS o un OPEN;
- exige diseñar TASK-012;
- o hace insuficiente el scope de CORR-013.

Ante esta categoría:

```text
no inferir
no ampliar scope
no reparar automáticamente
DETENERSE
```

### 9.5 Regla central

```text
estado activo actual
→ puede sincronizarse

contrato histórico correcto en su momento
→ no se moderniza retrospectivamente
```

---

## 10. `docs/product/11` — superficies autorizadas

El único documento autorizado para una futura modificación es:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Las superficies activas detectadas por el discovery aprobado son:

```text
§7.9
§10.2
§14.2
§17
```

Estos números de sección sirven como localizadores del discovery, no como sustituto de la revisión del wording real.

La futura ejecución debe releer íntegramente `docs/product/11-phase-1-scope-entry-gate.md` antes de modificarlo.

Debe verificar que las cuatro superficies siguen teniendo la misma función semántica identificada por el discovery.

No se autoriza una reescritura general del documento.

No se autoriza modificar una sección adicional sólo para “mejorar consistencia”, “limpiar redacción” o “actualizar terminología”.

Si el wording real cambió materialmente y ya no permite aplicar la corrección mínima prevista:

```text
BLOCKER
```

---

## 11. Tratamiento de §7.9

El discovery aprobado determina que §7.9 representa un snapshot activo que termina en TASK-010 y conserva TASK-011 como no determinada/no generada.

Tratamiento:

```text
ACTIVE STALE REFERENCE — CHANGE
```

Una futura ejecución correcta deberá actualizar exclusivamente el estado activo para registrar:

```text
TASK-011 = COMPLETADA

Auth SSR lifecycle foundation = IMPLEMENTADA
SSR cookie propagation boundary = IMPLEMENTADA
Auth Proxy technical boundary = IMPLEMENTADA
```

Debe conservar simultáneamente:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Refresh funcional de access token = NO
Proxy/middleware Auth funcional = NO
Authorization ready = NO
```

Cuando el wording adyacente ya contenga otras capacidades ausentes correctamente expresadas, también deben preservarse.

La nueva frontera de governance debe quedar en:

```text
TASK-012 determinada = NO
TASK-012 generada = NO
Siguiente TASK autorizada automáticamente = NO
```

No debe diseñar TASK-012.

No debe introducir nombre, objetivo, bounded context, entidad, migration, policy, UI o criterio técnico de TASK-012.

No debe presentar el server client request-scoped o el Proxy técnico como autorización funcional.

---

## 12. Tratamiento de §10.2

La regla vigente:

```text
una TASK completada
!=
siguiente TASK autorizada automáticamente
```

continúa siendo válida y debe preservarse.

El único drift permitido en esta superficie es el sujeto stale de la frontera.

Debe avanzarse desde la relación post-TASK-010:

```text
TASK-010 / TASK-011
```

hacia la relación vigente post-TASK-011:

```text
TASK-011 / TASK-012
```

Debe quedar inequívocamente:

```text
TASK-011 = COMPLETADA
!=
TASK-012 determinada
!=
TASK-012 generada
!=
TASK-012 autorizada
```

Y además:

```text
TASK-011 = COMPLETADA
!=
Siguiente TASK autorizada automáticamente
```

Esta superficie es governance de secuenciación, no una especificación del siguiente incremento.

CORR-013 no puede utilizar §10.2 para anticipar qué debe hacerse después.

---

## 13. Tratamiento de §14.2

El discovery aprobado determina que el resultado activo de §14.2 termina en TASK-010 y omite las foundations técnicas cerradas por TASK-011.

Tratamiento:

```text
ACTIVE STALE REFERENCE — CHANGE
```

La futura ejecución debe avanzar el resultado activo hasta TASK-011 e incorporar exclusivamente:

```text
Auth SSR lifecycle foundation = IMPLEMENTADA
SSR cookie propagation boundary = IMPLEMENTADA
Auth Proxy technical boundary = IMPLEMENTADA
```

Debe preservar expresamente:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Refresh funcional de access token = NO
Proxy/middleware Auth funcional = NO
Authorization ready = NO
```

También deben permanecer ausentes, si la superficie los enumera o deriva:

```text
route authorization = NO
tenant resolver = NO
role resolver = NO
Application authorization completa = NO
VerificationChallenge = NO
Client = NO
UserClientAccess = NO
SupportAccessGrant = NO
```

No debe presentar:

```text
Proxy técnico
```

como:

```text
Proxy Auth funcional
```

No debe declarar que autorización, tenant authorization o route authorization fueron implementadas.

No debe inferir un lifecycle end-to-end completo de sesión real de producto.

---

## 14. Tratamiento de §17

El discovery aprobado determina que §17 es la superficie final activa y conserva metadata post-TASK-010 en la que TASK-011 todavía figura no determinada/no generada.

Tratamiento:

```text
ACTIVE STALE REFERENCE — CHANGE
```

La futura ejecución debe registrar como estado activo:

```text
TASK-011 completada = SÍ
```

junto con:

```text
Auth SSR lifecycle foundation = IMPLEMENTADA
SSR cookie propagation boundary = IMPLEMENTADA
Auth Proxy technical boundary = IMPLEMENTADA
```

Debe establecer la nueva frontera:

```text
TASK-012 determinada = NO
TASK-012 generada = NO
Siguiente TASK autorizada automáticamente = NO
```

Debe eliminar exclusivamente metadata activa que haya quedado materialmente stale respecto del cierre de TASK-011.

No debe alterar metadata histórica de fases o tareas anteriores.

No debe convertir la superficie final en una recomendación del siguiente incremento.

---

## 15. Historia que debe preservarse

No se modernizan retrospectivamente:

```text
TASK-008
CORR-010
TASK-009
CORR-011
TASK-010
CORR-012
TASK-011
```

Cada uno conserva su función como contrato histórico, corrección documental o snapshot de governance válido en el momento en que fue aprobado.

En particular, dentro de TASK-011 deben preservarse declaraciones pre-implementación tales como:

```text
Estado = APPROVED FOR IMPLEMENTATION
Implementación autorizada = NO
Implementación realizada = NO
Codex autorizado = NO
```

cuando forman parte del acto documental aprobado anterior a la ejecución técnica.

Esas expresiones se clasifican como:

```text
HISTORICAL/GOVERNANCE — KEEP
```

También deben preservarse:

- pasos prospectivos legítimos de TASK-011;
- Definition of Done de TASK-011;
- Gate posterior de TASK-011;
- referencias de CORR-012 que declaraban TASK-011 no determinada/no generada en el snapshot post-TASK-010;
- referencias equivalentes de TASK-010, CORR-011, TASK-009, CORR-010 y TASK-008;
- cualquier wording histórico que, en su propio contexto temporal, fuese correcto.

CORR-013 no convierte TASK-011 ni ninguna TASK/CORR previa en changelog.

La regla es:

```text
estado histórico correcto en su momento
!=
referencia activa stale
```

---

## 16. Seguridad y multitenancy

CORR-013 debe preservar íntegramente los siguientes principios:

```text
tenant = MaintenanceCompany
```

```text
authenticated != authorized
```

```text
valid Auth session
!=
tenant authorization
```

```text
valid JWT claims
!=
current membership authorization
```

```text
RLS =
frontera primaria para datos tenant-owned
```

```text
estado autoritativo vigente
>
claims/session/context stale
```

```text
service-role =
excepcional/restringido
```

```text
SUPER_ADMIN normal
!=
acceso tenant ordinario
```

```text
frontend
!=
autoridad de tenant
```

```text
AuditEvent
!=
fuente de autorización
```

```text
TASK-011 completada
!=
Authorization ready
```

La foundation SSR no cambia la jerarquía de autorización aprobada.

El Proxy técnico no puede convertirse documentalmente en un guard de autorización por ruta.

El lifecycle técnico de cookies no autoriza a confiar en contexto stale como prueba de membership o permiso vigente.

CORR-013 no crea ni modifica:

- policies;
- grants;
- revokes;
- roles de base de datos;
- permisos de tabla;
- claims;
- custom claims;
- helpers de autorización;
- lógica de membership;
- lógica de client scope;
- lógica de support scope.

---

## 17. ADR y decisiones abiertas

Debe permanecer:

```text
ADR-0001 = ACCEPTED
ADR-0002 = ACCEPTED
ADR-0003 = ACCEPTED
```

Debe continuar:

```text
ADR-0004 = BLOCKED BY OPEN DECISIONS
```

con exactamente:

```text
DO-T04
OFF-OPEN-001
OFF-OPEN-002
FORM-OPEN-004
```

Debe permanecer:

```text
DO-T03 = RESUELTO/APROBADO
```

Para CORR-013:

```text
ADR nuevo requerido = NO
OPEN resuelto = NINGUNO
```

CORR-013:

- no modifica ADR-0001;
- no modifica ADR-0002;
- no modifica ADR-0003;
- no redacta ADR-0004;
- no cambia la clasificación de ADR-0004;
- no resuelve ninguno de sus blockers;
- no reabre DO-T03;
- no modifica DO-075;
- no crea un nuevo candidato a ADR.

Si la futura ejecución concluye que la sincronización requiere una decisión arquitectónica nueva:

```text
BLOCKER
```

---

## 18. Datos, schema y RLS

CORR-013 es documental.

Debe registrar y preservar:

```text
schema change = NO
migration = NO
SQL = NO
RLS change = NO
policy change = NO
grant/revoke change = NO
```

No modificar:

```text
maintenance_companies
platform_users
platform_user_auth_subjects
company_memberships
audit_events
```

No crear ni alterar:

- tablas;
- columnas;
- constraints;
- PK/FK;
- índices;
- enums;
- functions;
- triggers;
- RPC;
- migrations;
- policies RLS;
- privilegios de tabla;
- fixtures;
- datos de Development.

El hecho de que TASK-011 haya modificado infraestructura de aplicación no autoriza ninguna modificación de persistencia dentro de CORR-013.

---

## 19. AuditEvent

Debe preservarse el estado activo:

```text
AuditEvent foundation física = SÍ
```

pero también:

```text
Productores funcionales de AuditEvent = NO
auditoría funcional completa = NO
```

CORR-013 no puede:

- ampliar acciones físicas de AuditEvent;
- reducir acciones físicas de AuditEvent;
- diseñar producers;
- implementar producers;
- vincular el Proxy técnico a AuditEvent como productor funcional por inferencia;
- convertir AuditEvent en fuente de autorización;
- utilizar la existencia de AuditEvent como prueba de permiso vigente.

La regla permanece:

```text
AuditEvent foundation física
!=
productor funcional
!=
autorización
```

---

## 20. Offline

Offline permanece completamente fuera de esta corrección.

Debe preservarse:

```text
Offline funcional = NO
```

Debe continuar:

```text
ADR-0004 = BLOCKED BY OPEN DECISIONS
```

con exactamente:

```text
DO-T04
OFF-OPEN-001
OFF-OPEN-002
FORM-OPEN-004
```

CORR-013 no puede resolver, redefinir ni adelantar ninguno de esos elementos.

La existencia de Auth SSR lifecycle foundation no resuelve autorización offline, réplica local, aislamiento local, logout offline, purga, conservación local ni Service Worker.

---

## 21. TASK-012

CORR-013 no participa en la determinación técnica del siguiente incremento.

Debe permanecer:

```text
TASK-012 determinada = NO
TASK-012 generada = NO
TASK-012 especificada = NO
TASK-012 aprobada = NO
TASK-012 autorizada = NO

Siguiente TASK autorizada automáticamente = NO
```

La corrección no puede mencionar como decisión propia:

- cuál debe ser el siguiente bounded context;
- qué entidad debe implementarse;
- qué requisito debe priorizarse;
- qué migration debe crearse;
- qué policy debe escribirse;
- qué UI debe construirse;
- qué flow de Auth debe seguir;
- qué recomendación técnica haya surgido durante el discovery post-TASK-011.

La única relación permitida con TASK-012 es preservar que todavía no ha sido determinada, generada, especificada, aprobada ni autorizada.

Se mantiene:

```text
TASK-011 = COMPLETADA
!=
TASK-012 determinada automáticamente
```

---

## 22. Alcance de futura ejecución

Una futura ejecución de CORR-013 podrá modificar exclusivamente:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Cantidad máxima de documentos modificados:

```text
1
```

El diff futuro debe limitarse a referencias activas stale dentro de las superficies identificadas por el discovery aprobado y confirmadas nuevamente contra el wording real.

No se autoriza modificar:

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md
```

Ni:

```text
docs/architecture/adr/*
docs/tasks/TASK-008-supabase-application-boundary.md
docs/tasks/CORR-010-task-008-closure-state-sync.md
docs/tasks/TASK-009-identity-tenant-foundation.md
docs/tasks/CORR-011-task-009-closure-state-sync.md
docs/tasks/TASK-010-audit-event-foundation.md
docs/tasks/CORR-012-task-010-closure-state-sync.md
docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md
```

Si para sincronizar el estado fuese necesario modificar cualquier otro archivo:

```text
BLOCKER
```

No ampliar scope automáticamente.

No crear una segunda corrección dentro de la misma ejecución.

---

## 23. Criterios de aceptación

Una futura ejecución sólo podrá considerarse semánticamente correcta si satisface todos los siguientes criterios.

**AC-001.** El discovery vigente continúa permitiendo clasificar exactamente un documento como `CHANGE REQUIRED`.

**AC-002.** El único documento modificado es `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-003.** Sólo se modifican referencias clasificadas como `ACTIVE STALE REFERENCE — CHANGE`.

**AC-004.** Las referencias `VALID CURRENT REFERENCE — KEEP` permanecen sin cambio semántico.

**AC-005.** Las referencias `HISTORICAL/GOVERNANCE — KEEP` permanecen intactas.

**AC-006.** `TASK-011 = COMPLETADA` queda registrada en las superficies activas que deban expresar el estado post-TASK-011.

**AC-007.** `Auth SSR lifecycle foundation = IMPLEMENTADA` queda registrada donde corresponda al estado activo.

**AC-008.** `SSR cookie propagation boundary = IMPLEMENTADA` queda registrada donde corresponda al estado activo.

**AC-009.** `Auth Proxy technical boundary = IMPLEMENTADA` queda registrada donde corresponda al estado activo.

**AC-010.** `Auth funcional = NO` permanece explícita o inequívocamente preservada.

**AC-011.** `Auth SSR lifecycle completo = NO` permanece explícita o inequívocamente preservada.

**AC-012.** `Refresh funcional de access token = NO` permanece explícita o inequívocamente preservada.

**AC-013.** `Proxy/middleware Auth funcional = NO` permanece explícita o inequívocamente preservada.

**AC-014.** `Authorization ready = NO` permanece explícita o inequívocamente preservada.

**AC-015.** `route authorization = NO` permanece sin contradicción.

**AC-016.** `tenant resolver = NO` permanece sin contradicción.

**AC-017.** `role resolver = NO` permanece sin contradicción.

**AC-018.** `Application authorization completa = NO` permanece sin contradicción.

**AC-019.** `VerificationChallenge = NO` permanece.

**AC-020.** `Client = NO` permanece.

**AC-021.** `UserClientAccess = NO` permanece.

**AC-022.** `SupportAccessGrant = NO` permanece.

**AC-023.** `Storage funcional = NO` permanece.

**AC-024.** `Realtime funcional = NO` permanece.

**AC-025.** `Offline funcional = NO` permanece.

**AC-026.** `UI funcional de Auth = NO` permanece.

**AC-027.** `Productores funcionales de AuditEvent = NO` permanece.

**AC-028.** `auditoría funcional completa = NO` permanece.

**AC-029.** `AuditEvent foundation física = SÍ` no es degradada ni reinterpretada.

**AC-030.** TASK-011 no es convertida retrospectivamente en changelog.

**AC-031.** `TASK-012 determinada = NO` permanece.

**AC-032.** `TASK-012 generada = NO` permanece.

**AC-033.** `TASK-012 especificada = NO` no es contradicha.

**AC-034.** `TASK-012 aprobada = NO` no es contradicha.

**AC-035.** `TASK-012 autorizada = NO` no es contradicha.

**AC-036.** `Siguiente TASK autorizada automáticamente = NO` permanece inequívoco.

**AC-037.** No se incorpora ninguna recomendación técnica sobre el siguiente incremento como decisión de CORR-013.

**AC-038.** Producto permanece sin cambios.

**AC-039.** Arquitectura permanece sin cambios.

**AC-040.** Seguridad permanece sin cambios.

**AC-041.** Multitenancy permanece sin cambios.

**AC-042.** RLS permanece sin cambios.

**AC-043.** `ADR-0001`, `ADR-0002` y `ADR-0003` permanecen `ACCEPTED`.

**AC-044.** `ADR-0004` permanece `BLOCKED BY OPEN DECISIONS`.

**AC-045.** Los blockers de ADR-0004 permanecen exactamente `DO-T04`, `OFF-OPEN-001`, `OFF-OPEN-002` y `FORM-OPEN-004`.

**AC-046.** `DO-T03 = RESUELTO/APROBADO` no se reabre.

**AC-047.** `ADR nuevo requerido = NO` permanece.

**AC-048.** `OPEN resuelto = NINGUNO` permanece.

**AC-049.** No se modifica schema.

**AC-050.** No se crea ni modifica migration.

**AC-051.** No se escribe SQL.

**AC-052.** No se crea ni modifica policy RLS.

**AC-053.** No se cambia ningún grant/revoke.

**AC-054.** No se modifica Supabase Cloud.

**AC-055.** No se modifica código de aplicación.

**AC-056.** No se modifican tests.

**AC-057.** No se modifican dependencias ni archivos de package management.

**AC-058.** `git diff --check = PASS` en la futura ejecución.

**AC-059.** `files changed = 1` en la futura ejecución.

**AC-060.** `unexpected files = 0` en la futura ejecución.

**AC-061.** La especificación actual no modifica repositorio, código, Supabase Cloud ni Git.

---

## 24. Blockers

Una futura ejecución debe detenerse con `BLOCKER` ante cualquiera de las siguientes condiciones.

### 24.1 Git y baseline

- Git real presenta drift material inesperado;
- existe una operación Git en progreso incompatible con una ejecución documental controlada;
- el worktree contiene cambios no reconciliados que impiden atribuir el diff con certeza;
- el documento activo difiere materialmente de la versión auditada y la corrección mínima ya no puede aplicarse con seguridad;
- el cierre humano/técnico de TASK-011 no puede verificarse de forma coherente contra las fuentes vigentes.

### 24.2 Scope documental

- aparece un segundo documento `CHANGE REQUIRED`;
- una referencia adicional realmente requiere modificación fuera de `docs/product/11-phase-1-scope-entry-gate.md`;
- no puede distinguirse una referencia activa de una referencia histórica;
- una de las cuatro superficies auditadas cambió de función semántica de manera material;
- la corrección exige reescribir historia para alcanzar consistencia.

### 24.3 Producto, arquitectura y seguridad

- actualizar el estado exige cambiar producto;
- actualizar el estado exige cambiar arquitectura;
- actualizar el estado exige cambiar seguridad;
- actualizar el estado exige cambiar multitenancy;
- actualizar el estado exige cambiar RLS;
- actualizar el estado exige policies nuevas o modificadas;
- actualizar el estado exige grants/revokes;
- actualizar el estado exige modificar un ADR aceptado;
- actualizar el estado exige un ADR nuevo;
- actualizar el estado exige resolver un OPEN.

### 24.4 Implementación o siguiente incremento

- actualizar el estado exige implementar una capacidad;
- actualizar el estado exige modificar código;
- actualizar el estado exige modificar tests;
- actualizar el estado exige modificar Supabase Cloud;
- actualizar el estado exige schema, migration o SQL;
- actualizar el estado exige diseñar TASK-012;
- actualizar el estado exige determinar TASK-012;
- actualizar el estado exige incorporar una recomendación técnica del siguiente incremento.

### 24.5 Verificación del diff

- `git diff --check` falla;
- el diff incluye más de un archivo;
- el diff incluye código, tests, `supabase/`, package files o cualquier archivo no autorizado;
- el diff altera una referencia `HISTORICAL/GOVERNANCE — KEEP`;
- el diff convierte una foundation técnica en capacidad funcional;
- el diff declara Authorization ready, Auth funcional o lifecycle completo como implementados.

Ante cualquier blocker:

```text
no inferir
no ampliar scope
no reparar automáticamente
no continuar
DETENERSE
```

El resultado debe volver al Revisor Central para una nueva decisión humana.

---

## 25. Verificaciones futuras

Una futura ejecución documental debe realizar, como mínimo, las siguientes verificaciones.

### 25.1 Preflight Git fresco

Registrar el estado real vigente:

```text
branch
HEAD
upstream
origin/main
divergencia
worktree
staged changes
Git operation in progress
```

No asumir que el snapshot histórico de TASK-011 continúa siendo el HEAD actual.

### 25.2 Lectura íntegra de fuentes

Leer íntegramente todas las fuentes enumeradas en §7.

No trabajar desde snippets, recuerdos, hashes antiguos o resúmenes parciales cuando el repositorio real esté disponible.

### 25.3 Auditoría de referencias

Repetir una auditoría read-only suficiente para confirmar:

- `CHANGE REQUIRED = 1`;
- el único `CHANGE REQUIRED` es `docs/product/11-phase-1-scope-entry-gate.md`;
- las superficies §7.9, §10.2, §14.2 y §17 continúan materialmente stale respecto de TASK-011;
- no apareció otra superficie activa que requiera cambio;
- historia y governance continúan clasificables sin ambigüedad.

Toda coincidencia material debe usar exclusivamente la taxonomía de §9.

### 25.4 Inspección de evidencia TASK-011

Inspeccionar el commit histórico:

```text
3f4d0d2fab8f8b11dfff749de7df50aa560c301c
```

con propósito de trazabilidad.

La inspección debe confirmar que la corrección documental no pretende atribuir a TASK-011 capacidades fuera de su slice cerrado.

### 25.5 Diff futuro

Después de la modificación documental autorizada, ejecutar y revisar:

```text
git diff --name-status
git diff --stat
git diff --check
```

Además debe revisarse el diff literal completo de:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Confirmar:

```text
files changed = 1
unexpected files = 0
```

### 25.6 Ausencia de cambios técnicos

Verificar ausencia de:

```text
app changes
src changes
tests changes
supabase changes
package changes
```

También debe comprobarse que no existan cambios en:

- `package.json`;
- `package-lock.json`;
- migrations;
- SQL tests;
- RLS;
- Supabase config;
- Auth infrastructure;
- Proxy técnico;
- factories Supabase.

### 25.7 No staging / commit / push implícito

La ejecución documental no puede realizar por sí sola:

```text
git add
git commit
git push
```

salvo autorización humana separada y posterior.

### 25.8 Definition of Done documental de futura ejecución

La futura corrección sólo podrá considerarse ejecutada y cerrada después de que se cumpla toda esta secuencia:

1. la especificación canónica de CORR-013 fue revisada y aprobada documentalmente;
2. CORR-013 fue canonicalizada;
3. la canonicalización fue revisada humanamente;
4. existe autorización humana separada para una ejecución documental concreta;
5. el preflight Git fresco resulta PASS;
6. se repite la auditoría documental integral;
7. `UNEXPECTED — BLOCKER = 0`;
8. se modifica exactamente un archivo;
9. el único archivo modificado es `docs/product/11-phase-1-scope-entry-gate.md`;
10. el estado activo post-TASK-011 queda sincronizado;
11. las tres foundations técnicas de TASK-011 quedan correctamente registradas;
12. Auth funcional continúa `NO`;
13. Auth SSR lifecycle completo continúa `NO`;
14. Authorization ready continúa `NO`;
15. TASK-012 continúa no determinada/no generada/no autorizada;
16. la historia queda preservada;
17. producto queda sin cambios;
18. arquitectura queda sin cambios;
19. seguridad y multitenancy quedan sin cambios;
20. RLS queda sin cambios;
21. no se modifica código;
22. no se escriben SQL ni migrations;
23. no se modifica Supabase Cloud;
24. `git diff --check = PASS`;
25. el diff completo es revisado humanamente;
26. la incorporación Git es autorizada mediante otro acto separado;
27. Git se incorpora y verifica conforme a la autorización recibida;
28. existe revisión humana final;
29. existe cierre humano final de CORR-013.

Un PASS técnico/documental de ejecución no equivale por sí solo al cierre humano final.

---

## 26. Gate posterior

La secuencia obligatoria es:

```text
CORR-013 = APPROVED FOR IMPLEMENTATION
→ canonicalización
→ revisión humana de canonicalización
→ autorización separada de ejecución documental
→ ejecución
→ revisión humana del diff
→ incorporación Git autorizada
→ verificación Git
→ cierre humano final
```

Debe permanecer expresamente:

```text
aprobación documental
!=
canonicalización
!=
ejecución autorizada
!=
cierre
```

Sólo después del cierre humano final el resultado vuelve al:

```text
REVISOR CENTRAL
```

para un acto nuevo y separado de determinación del siguiente incremento de Fase 2.

CORR-013 no participa en esa determinación.

Debe quedar expresamente:

```text
CORR-013 completada
!=
TASK-012 determinada automáticamente
```

Y también:

```text
TASK-011 = COMPLETADA
!=
TASK-012 determinada
!=
TASK-012 generada
!=
TASK-012 autorizada
```

No existe autorización automática del incremento siguiente.

---

## 27. Resultado de esta preparación

```text
CORR-013 = APPROVED FOR IMPLEMENTATION

CORR-013 determinada = SÍ
CORR-013 generada = SÍ
CORR-013 especificada = SÍ
CORR-013 aprobada = SÍ

CHANGE REQUIRED =
docs/product/11-phase-1-scope-entry-gate.md

cantidad CHANGE REQUIRED = 1

cambio de producto = NO
cambio de arquitectura = NO
cambio de seguridad = NO
cambio de multitenancy = NO
cambio de RLS = NO

ADR nuevo requerido = NO
OPEN resuelto = NINGUNO

implementación realizada = NO
ejecución concreta autorizada = NO
repositorio modificado = NO
Supabase Cloud modificado = NO
Git modificado = NO

TASK-012 determinada = NO
TASK-012 generada = NO
TASK-012 especificada = NO
TASK-012 aprobada = NO
TASK-012 autorizada = NO

Siguiente TASK autorizada automáticamente = NO

UNEXPECTED — BLOCKER = 0

CORR-013 SPECIFICATION = PASS
CORR-013 SPEC REVIEW = APPROVED
```

`CORR-013 SPECIFICATION = PASS` registra el resultado técnico/documental satisfactorio de la especificación.

`CORR-013 SPEC REVIEW = APPROVED` registra la aprobación humana formal de esa especificación.

Debe preservarse la separación entre ambos actos:

```text
CORR-013 SPECIFICATION = PASS
!=
CORR-013 SPEC REVIEW = APPROVED
```

Esta aprobación documental no autoriza la ejecución de CORR-013 y no modifica el estado de TASK-012.

---

## 28. Entrega

**Archivo generado:**

```text
CORR-013-task-011-closure-state-sync-approved.md
```

**Ruta canónica futura propuesta:**

```text
docs/tasks/CORR-013-task-011-closure-state-sync.md
```

**Estado:**

```text
APPROVED FOR IMPLEMENTATION
```

No se implementó CORR-013.

No se utilizó Codex.

No se modificó el repositorio.

No se modificó `docs/product/11-phase-1-scope-entry-gate.md`.

No se modificó Supabase Cloud.

No se realizó `git add`, commit ni push.

No se determinó TASK-012.

No se generó TASK-012.

No se diseñó TASK-012.

No se incorporó en CORR-013 ninguna recomendación técnica sobre el siguiente incremento.
