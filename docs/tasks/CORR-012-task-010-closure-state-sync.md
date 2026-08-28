# CORR-012 — Sincronización documental posterior al cierre de TASK-010

## 1. Identificación

**ID:** `CORR-012`

**Título:** `CORR-012 — Sincronización documental posterior al cierre de TASK-010`

**Tipo:** `CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO`

**Estado:** `APPROVED FOR IMPLEMENTATION`

Este estado significa exclusivamente que la especificación documental está aprobada para una futura ejecución separadamente autorizada. No autoriza ahora la ejecución, la modificación del repositorio ni el uso de Codex.

**Archivo de entrega:**

`CORR-012-task-010-closure-state-sync-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/CORR-012-task-010-closure-state-sync.md`

**Naturaleza:** exclusivamente documental.

**CORR-012 determinada:** `SÍ`

**CORR-012 generada:** `SÍ`

**CORR-012 especificada:** `SÍ`

**CORR-012 aprobada:** `SÍ`

**Implementación realizada:** `NO`

**Ejecución concreta autorizada:** `NO`

**Codex utilizado:** `NO`

**Repositorio modificado:** `NO`

**`docs/product/11-phase-1-scope-entry-gate.md` modificado:** `NO`

**Supabase Cloud modificado:** `NO`

**Git modificado:** `NO`

**TASK-011 determinada:** `NO`

**TASK-011 generada:** `NO`

Esta especificación no constituye una ejecución documental y no autoriza ninguna modificación del repositorio.

---

## 2. Objetivo único

CORR-012 tiene un único objetivo:

> sincronizar exclusivamente las referencias **activas y actuales** que quedaron materialmente obsoletas después del cierre humano, técnico, Development y Git de `TASK-010`.

La regla fundamental es:

```text
sincronizar estado activo
!=
reescribir historia
```

CORR-012:

- no crea el cierre de TASK-010;
- no reevalúa TASK-010;
- no modifica TASK-010;
- no cambia producto;
- no cambia arquitectura;
- no cambia seguridad;
- no cambia multitenancy;
- no cambia RLS;
- no implementa capacidades;
- no diseña Auth;
- no diseña Client;
- no diseña UserClientAccess;
- no diseña SupportAccessGrant;
- no diseña productores de AuditEvent;
- no determina TASK-011;
- no genera TASK-011.

Su único efecto futuro permitido es:

```text
estado humano/técnico cerrado de TASK-010
→ auditoría de referencias documentales activas
→ corrección mínima del estado stale
→ preservación íntegra de historia
→ revisión humana
```

---

## 3. Estado autoritativo consumido

CORR-012 consume como estado humano y técnico ya cerrado:

```text
Fase 0 = COMPLETADA
Fase 1 = COMPLETADA
Fase 2 = INICIADA

TASK-008 = COMPLETADA
TASK-009 = COMPLETADA
CORR-011 = COMPLETADA
TASK-010 = COMPLETADA
```

Para TASK-010 se consume:

```text
TASK-010 determinada = SÍ
TASK-010 especificada = SÍ
TASK-010 aprobada = SÍ
TASK-010 canonicalizada = SÍ
TASK-010 implementada localmente = SÍ
TASK-010 revisión local = APPROVED
TASK-010 Development Gate = PASS
TASK-010 incorporación Git = SÍ
TASK-010 cierre humano final = APPROVED
```

Commit de implementación recibido como evidencia histórica:

```text
a82daafffddf88987db1185e7335e57e59210d76
```

Último snapshot Git humano verificado recibido:

```text
branch = main
HEAD = a82daafffddf88987db1185e7335e57e59210d76
origin/main = a82daafffddf88987db1185e7335e57e59210d76
divergencia = 0 0
worktree = limpio
staged = ninguno
```

Ese SHA y ese snapshot documentan el cierre de TASK-010.

No constituyen una precondición inmutable de una futura canonicalización o ejecución de CORR-012.

La futura ejecución deberá verificar nuevamente el repositorio real y registrar el estado Git vigente en ese momento.

---

## 4. Resultado técnico cerrado de TASK-010

TASK-010 materializó exclusivamente la **foundation física mínima de AuditEvent**.

El estado físico posterior consumido por CORR-012 es:

```text
MaintenanceCompany físico = SÍ
PlatformUser físico = SÍ
Auth subject → PlatformUser físico = SÍ
CompanyMembership físico = SÍ

AuditEvent foundation física = SÍ
Migration TASK-010 = IMPLEMENTADA
SQL test TASK-010 = PRESENTE Y PROBADO EN DEVELOPMENT
Static test TASK-010 = PRESENTE

RLS sobre audit_events = HABILITADA
application policies sobre audit_events = 0

table privileges anon sobre audit_events = NONE
table privileges authenticated sobre audit_events = NONE

authenticated TRUNCATE audit_events = DENIED

Development Gate TASK-010 = PASS
fixtures TASK-010 restantes = 0
```

Debe preservarse expresamente:

```text
AuditEvent foundation física = SÍ
!=
auditoría funcional completa = SÍ
```

TASK-010 no implementó productores funcionales de AuditEvent.

La existencia de `public.audit_events`, sus constraints, RLS y pruebas no convierte por inferencia ninguna operación funcional en implementada.

---

## 5. Capacidades que continúan ausentes

Después del cierre de TASK-010 continúa como estado activo:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Authorization ready = NO
VerificationChallenge = NO

Client = NO
UserClientAccess = NO
SupportAccessGrant = NO

Application authorization completa = NO

Storage = NO
Realtime = NO
Offline = NO

auditoría funcional completa = NO
```

CORR-012 no puede afirmar ni insinuar:

```text
alta funcional de usuarios = SÍ
disable/revoke funcional = SÍ
reintegración funcional = SÍ
cambio funcional de role = SÍ
client access funcional = SÍ
support funcional = SÍ
```

La regla vigente es:

```text
foundation física de AuditEvent
!=
flow productor
!=
capacidad funcional
```

---

## 6. Acciones físicas de TASK-010

El CHECK físico inicial de TASK-010 admite exclusivamente:

```text
USER_CREATED
USER_DISABLED_OR_REVOKED
USER_REINSTATED
USER_ROLE_CHANGED
```

Su significado es únicamente:

```text
acciones representables físicamente por la foundation
```

No significa:

```text
flows funcionales implementados
```

Continúan como obligaciones futuras de producto, pero **NO físicamente habilitadas por TASK-010**:

```text
USER_CLIENT_ACCESS_CHANGED
SUPPORT_ACCESS_GRANTED
SUPPORT_ACCESS_SCOPE_CHANGED
SUPPORT_ACCESS_REVOKED
SUPPORT_ACCESS_USED
```

CORR-012 no puede:

- ampliar el CHECK;
- reducirlo;
- reinterpretar una acción física como flow existente;
- habilitar las cinco acciones futuras;
- diseñar la extensión futura necesaria para Client, UserClientAccess o SupportAccessGrant.

Se preserva:

```text
obligación futura de auditar
!=
acción físicamente habilitada prematuramente
```

---

## 7. Fuentes de verdad

La especificación se apoya en el estado canónico, el contrato aprobado de TASK-010, los artefactos técnicos del slice y el discovery read-only posterior al cierre.

### 7.1 Product

Revisar y contrastar íntegramente en una futura ejecución:

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
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
docs/tasks/CORR-010-task-008-closure-state-sync.md
docs/tasks/TASK-009-identity-tenant-foundation.md
docs/tasks/CORR-011-task-009-closure-state-sync.md
docs/tasks/TASK-010-audit-event-foundation.md
```

### 7.4 Artefactos técnicos

```text
supabase/migrations/20260825234939_task_009_identity_tenant_foundation.sql
supabase/migrations/20260826190408_task_010_audit_event_foundation.sql
supabase/tests/database/task_010_audit_event_foundation.test.sql
tests/task-010-migration.test.ts
```

### 7.5 Evidencia posterior al cierre

Debe consumirse además el discovery read-only posterior al cierre de TASK-010 que fue revisado y aprobado por el Revisor Central.

### 7.6 Regla de contradicción

Si en una futura revisión el repositorio real, las fuentes canónicas o los artefactos técnicos contradicen materialmente el estado autoritativo consumido por esta especificación:

```text
CORR-012 SPECIFICATION = BLOCKER
```

No se debe resolver una contradicción por inferencia, conveniencia ni ampliación silenciosa del scope.

---

## 8. Revisión de coherencia para esta preparación

### 8.1 Resultado

```text
contradicciones materiales bloqueantes detectadas = 0
```

La información disponible es coherente en los puntos que CORR-012 necesita sincronizar:

- el producto exige AuditEvent para acciones sensibles;
- el modelo conceptual mantiene AuditEvent como evento histórico tenant-owned cuando corresponde;
- ADR-0002 exige ownership tenant inequívoco y RLS;
- ADR-0003 mantiene autenticación separada de autorización;
- TASK-009 dejó AuditEvent fuera de alcance;
- CORR-011 sincronizó correctamente el estado activo posterior a TASK-009;
- TASK-010 aprobó una foundation fail-closed, no productores funcionales;
- el test estático de TASK-010 exige exactamente las cuatro acciones físicas aprobadas y la ausencia de las cinco acciones futuras;
- el cierre recibido de TASK-010 registra Development Gate PASS, privilegios de tabla cerrados, TRUNCATE denegado y fixtures en cero;
- el discovery posterior determina un único documento activo que requiere sincronización.

### 8.2 Resultado de especificación

```text
CORR-012 SPECIFICATION = PASS
```

Este PASS significa únicamente que existe baseline suficiente y no contradictoria para la especificación.

Este PASS, por sí solo, no significa ejecución ni aprobación de CORR-012. La aprobación documental actual se registra separadamente como `CORR-012 SPEC REVIEW = APPROVED`.

---

## 9. Resultado aprobado del discovery post-TASK-010

CORR-012 consume sin reabrirlo el siguiente resultado ya aprobado.

### `CHANGE REQUIRED`

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Cantidad:

```text
1
```

### `NO CHANGE REQUIRED`

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/10-architecture-decisions-records.md
docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

### `HISTORICAL/GOVERNANCE — KEEP`

```text
docs/tasks/TASK-009-identity-tenant-foundation.md
docs/tasks/CORR-011-task-009-closure-state-sync.md
docs/tasks/TASK-010-audit-event-foundation.md
```

### `UNEXPECTED — BLOCKER`

```text
0
```

CORR-012 no vuelve a decidir esta clasificación durante su preparación.

La futura ejecución debe repetir la auditoría read-only contra el repositorio real para comprobar que el resultado continúa siendo aplicable.

---

## 10. Taxonomía documental obligatoria

Toda coincidencia material revisada por CORR-012 debe clasificarse exclusivamente en una de estas cuatro categorías:

### 10.1 `ACTIVE STALE REFERENCE — CHANGE`

Aplica cuando una referencia:

- pretende describir el estado global o actual del proyecto;
- quedó materialmente falsa después del cierre de TASK-010;
- puede actualizarse sin crear una decisión nueva;
- se encuentra dentro del único documento autorizado para modificación.

### 10.2 `VALID CURRENT REFERENCE — KEEP`

Aplica cuando una referencia:

- continúa siendo verdadera;
- expresa una regla vigente;
- mantiene una frontera de seguridad o multitenancy;
- mantiene una ausencia funcional todavía real;
- mantiene una separación de governance vigente.

### 10.3 `HISTORICAL/GOVERNANCE — KEEP`

Aplica cuando una referencia:

- describe correctamente el estado de una TASK, CORR, ADR o Gate en el momento correspondiente;
- pertenece al contrato histórico aprobado de una tarea;
- conserva una prohibición válida para una fase anterior;
- describe correctamente qué estaba o no estaba autorizado durante un acto pasado;
- utiliza lenguaje prospectivo legítimo dentro de un contrato histórico.

### 10.4 `UNEXPECTED — BLOCKER`

Aplica cuando:

- aparece una referencia activa stale fuera del scope aprobado;
- no puede distinguirse con seguridad si una referencia es histórica o activa;
- corregirla exigiría modificar producto, arquitectura, seguridad o RLS;
- corregirla exigiría una capacidad futura no definida;
- corregirla exigiría determinar TASK-011;
- aparece drift técnico o documental material incompatible con el cierre recibido.

No se permiten categorías adicionales.

---

## 11. Scope documental

### 11.1 Único documento modificable en una futura ejecución

```text
docs/product/11-phase-1-scope-entry-gate.md
```

### 11.2 Máximo de archivos modificables

```text
1
```

### 11.3 Regla de scope

Si la auditoría futura descubre otra referencia activa stale que materialmente requiera modificar otro archivo:

```text
UNEXPECTED — BLOCKER
```

No se debe:

- ampliar el scope automáticamente;
- agregar el segundo archivo;
- “aprovechar” CORR-012 para actualizar documentación lateral;
- reparar silenciosamente la inconsistencia.

El resultado debe volver al Revisor Central.

### 11.4 Naturaleza del cambio

El cambio futuro debe ser mínimo y semántico.

CORR-012 no autoriza una reescritura general de `11`.

No autoriza reformatear secciones no relacionadas ni modernizar referencias históricas por conveniencia.

---

## 12. Superficies activas stale detectadas

El discovery aprobado localizó como mínimo las siguientes superficies activas de `docs/product/11-phase-1-scope-entry-gate.md`.

Los números de sección son evidencia de localización del snapshot revisado, no un contrato de números de línea ni una autorización para reemplazos ciegos.

La futura ejecución debe volver a localizar semánticamente cada bloque en el archivo real.

### 12.1 §7.9 — snapshot activo de Fase 2

Estado stale detectado:

- el snapshot activo termina en TASK-009;
- declara `AuditEvent = NO`;
- conserva TASK-010 como no determinada/no generada.

Tratamiento:

`ACTIVE STALE REFERENCE — CHANGE`

Debe evolucionar semánticamente para registrar:

```text
TASK-010 = COMPLETADA
AuditEvent foundation física = SÍ
```

sin afirmar auditoría funcional completa ni ningún flow productor.

La frontera de governance debe pasar a TASK-011:

```text
TASK-011 determinada = NO
TASK-011 generada = NO
Siguiente TASK autorizada automáticamente = NO
```

### 12.2 §10.2 — frontera posterior al último incremento

Estado stale detectado:

- TASK-009 continúa presentado como último incremento cerrado;
- TASK-010 continúa presentado como no determinado/no generado.

Tratamiento:

`ACTIVE STALE REFERENCE — CHANGE`

Debe registrar el lifecycle ya cerrado de TASK-010 y mantener que su cierre no determina el incremento siguiente.

No debe convertir esta sección en diseño de TASK-011.

### 12.3 §14.2 — resultado activo de transición

Estado stale detectado:

- `AuditEvent = NO` como estado técnico global actual;
- la frontera activa termina en TASK-009.

Tratamiento:

`ACTIVE STALE REFERENCE — CHANGE`

Debe distinguir inequívocamente:

```text
AuditEvent foundation física = SÍ
```

frente a:

```text
auditoría funcional completa = NO
```

Debe mantener Auth, autorización, Client, UserClientAccess y SupportAccessGrant como no implementados.

### 12.4 §17 — resultado final activo

Estado stale detectado:

- omite el cierre de TASK-010;
- conserva `AuditEvent = NO`;
- mantiene metadata activa de TASK-010 como no determinada/no generada.

Tratamiento:

`ACTIVE STALE REFERENCE — CHANGE`

Debe incorporar el cierre de TASK-010, la foundation física de AuditEvent y la nueva frontera de governance respecto de TASK-011.

### 12.5 Regla de ejecución

CORR-012 no define aquí un diff literal ejecutable.

La futura ejecución deberá:

- releer el wording real vigente;
- clasificar la coincidencia concreta;
- realizar el cambio mínimo necesario;
- preservar el texto histórico adyacente;
- detenerse si el documento real difiere materialmente de la estructura auditada.

---

## 13. Estado activo requerido después de una futura ejecución correcta

Las superficies activas cubiertas por CORR-012 deben permitir derivar inequívocamente:

```text
Fase 0 = COMPLETADA
Fase 1 = COMPLETADA
Fase 2 = INICIADA

TASK-008 = COMPLETADA
TASK-009 = COMPLETADA
TASK-010 = COMPLETADA

Supabase application boundary = IMPLEMENTADA

MaintenanceCompany físico = SÍ
PlatformUser físico = SÍ
Auth subject → PlatformUser físico = SÍ
CompanyMembership físico = SÍ

AuditEvent foundation física = SÍ
Migration TASK-010 = IMPLEMENTADA
RLS/privilegios TASK-010 = PROBADOS EN DEVELOPMENT
```

Debe conservarse simultáneamente:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Authorization ready = NO
VerificationChallenge = NO

Client = NO
UserClientAccess = NO
SupportAccessGrant = NO
Application authorization completa = NO

Storage = NO
Realtime = NO
Offline = NO

auditoría funcional completa = NO
```

Y además:

```text
TASK-011 determinada = NO
TASK-011 generada = NO
Siguiente TASK autorizada automáticamente = NO
```

### 13.1 Estado físico de AuditEvent que puede declararse

Dentro del alcance de estado activo sí puede registrarse:

```text
RLS sobre audit_events = HABILITADA
application policies sobre audit_events = 0

table privileges anon sobre audit_events = NONE
table privileges authenticated sobre audit_events = NONE

authenticated TRUNCATE audit_events = DENIED
```

si el wording activo necesita resumir la seguridad cerrada de TASK-010.

No debe utilizarse esa información para abrir permisos ni reinterpretar autorización.

### 13.2 Estado funcional que no puede declararse

No puede aparecer como resultado de CORR-012:

```text
Auth funcional = SÍ
Authorization ready = SÍ
Client = SÍ
UserClientAccess = SÍ
SupportAccessGrant = SÍ
auditoría funcional completa = SÍ
```

---

## 14. Preservación de historia

CORR-012 debe preservar íntegramente la diferencia entre estado actual e historia.

### 14.1 Fase 1 histórica

No se modernizan retrospectivamente:

- propósito original de Fase 1;
- alcance permitido durante Fase 1;
- prohibiciones de schema/migrations/RLS propias de aquella fase;
- Paso 9 histórico;
- riesgos históricos de adelantar Fase 2;
- Gates que documentan correctamente el estado existente cuando fueron aprobados.

Que ahora existan migrations y RLS de Fase 2 no vuelve falsos los textos que decían que no debían existir durante Fase 1.

### 14.2 Tareas y correcciones históricas

No se reescriben retrospectivamente:

```text
docs/tasks/TASK-009-identity-tenant-foundation.md
docs/tasks/CORR-011-task-009-closure-state-sync.md
docs/tasks/TASK-010-audit-event-foundation.md
```

Las declaraciones históricas de TASK-010 como:

```text
Implementación realizada = NO
Repositorio modificado = NO
Supabase Cloud modificado = NO
```

son correctas dentro del acto documental en que fueron escritas y no se convierten en stale por el hecho de que la ejecución haya ocurrido después.

Clasificación obligatoria:

`HISTORICAL/GOVERNANCE — KEEP`

### 14.3 Lenguaje prospectivo legítimo

Expresiones como:

```text
una futura implementación...
un futuro productor...
una futura extensión...
```

se conservan cuando forman parte del contrato técnico aprobado y no pretenden describir el estado global actual.

### 14.4 Prohibición de changelog retrospectivo

TASK-010 no debe transformarse en un changelog de ejecución.

CORR-012 sincroniza el documento maestro activo; no reescribe los contratos históricos para que parezcan haber nacido después del cierre.

---

## 15. Seguridad y multitenancy preservados

CORR-012 no modifica ninguna decisión de seguridad.

Deben continuar íntegramente:

```text
tenant = MaintenanceCompany

authenticated != authorized

RLS = frontera primaria para datos tenant-owned

estado autoritativo vigente
>
claims, sesión o contexto stale
```

También se preservan:

```text
service-role = excepcional/restringido
SUPER_ADMIN normal != acceso operativo tenant
frontend != autoridad de tenant
audit event != fuente de autorización
existencia de AuditEvent != permiso vigente
```

### 15.1 AuditEvent no autoriza

Un AuditEvent histórico:

- no crea membership;
- no crea rol;
- no crea client scope;
- no crea SupportAccessGrant;
- no restaura un permiso revocado;
- no reemplaza la consulta del estado vigente;
- no convierte a SUPER_ADMIN en actor tenant ordinario.

### 15.2 RLS

CORR-012 no puede:

- crear policies;
- modificar policies;
- agregar grants;
- cambiar privileges;
- diseñar una futura apertura de `audit_events`;
- introducir bypass.

Los valores de RLS/policies/privileges se registran únicamente como **resultado técnico ya cerrado de TASK-010**.

---

## 16. Estado arquitectónico y decisiones abiertas

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

CORR-012:

```text
ADR nuevo requerido = NO
OPEN resuelto = NINGUNO
ADR modificado = NO
```

No puede utilizar el cierre de TASK-010 para:

- desbloquear ADR-0004;
- modificar sus blockers;
- resolver decisiones offline;
- modificar DO-075;
- reabrir DO-T03;
- crear una nueva decisión arquitectónica.

---

## 17. Fuera de alcance

CORR-012 no puede implementar, diseñar ni modificar:

### 17.1 Código y aplicación

- código TypeScript;
- componentes React;
- rutas;
- Server Actions;
- Route Handlers;
- APIs;
- repositories;
- services funcionales;
- UI.

### 17.2 Datos

- schema;
- tablas;
- columnas;
- constraints;
- índices;
- SQL;
- migrations;
- seeds;
- fixtures;
- functions;
- triggers;
- RPC;
- `SECURITY DEFINER`;
- policies RLS;
- grants/revokes.

### 17.3 Capacidades

- Auth funcional;
- lifecycle Auth SSR;
- VerificationChallenge;
- onboarding;
- Client;
- UserClientAccess;
- SupportAccessGrant;
- productores funcionales de AuditEvent;
- ampliación del catálogo de AuditEvent;
- Storage;
- Realtime;
- Offline.

### 17.4 Infraestructura y operación

- Supabase Cloud;
- operaciones remotas;
- cambios de configuración;
- Git add;
- commit;
- push.

### 17.5 Governance posterior

- determinar TASK-011;
- generar TASK-011;
- autorizar TASK-011;
- decidir el siguiente bounded context;
- seleccionar el siguiente incremento PR-sized.

---

## 18. Procedimiento obligatorio de una futura ejecución

Una ejecución futura, sólo después de aprobación documental, canonicalización, revisión correspondiente y autorización humana separada, deberá seguir este orden.

### 18.1 Preflight Git fresco

Verificar y registrar como mínimo:

```text
git rev-parse --show-toplevel
git branch --show-current
git rev-parse HEAD
git rev-parse --abbrev-ref --symbolic-full-name @{u}
git rev-parse origin/main
git rev-list --left-right --count HEAD...origin/main
git status --short
git status --porcelain=v1 --untracked-files=all
```

El snapshot histórico de TASK-010 no sustituye este preflight.

Ante drift material inesperado:

`BLOCKER`

No realizar autorepair mediante pull, merge, rebase, reset, restore, stash o clean.

### 18.2 Relectura de autoridad

Leer íntegramente:

- la versión canónica aprobada de CORR-012;
- `docs/product/11-phase-1-scope-entry-gate.md` real;
- las fuentes canónicas y artefactos necesarios para confirmar que TASK-010 continúa cerrada conforme al baseline.

### 18.3 Auditoría documental

Buscar integralmente referencias materiales equivalentes a:

```text
TASK-010
TASK siguiente
TASK-011
AuditEvent
AuditEvent = NO
AuditEvent foundation
Migration TASK-010
RLS audit_events
Auth funcional
Authorization ready
Client
UserClientAccess
SupportAccessGrant
Storage
Realtime
Offline
```

Cada coincidencia material debe clasificarse exclusivamente con la taxonomía de §10.

### 18.4 Gate previo a editar

Antes de modificar, debe confirmarse:

```text
CHANGE REQUIRED = exactamente 1 archivo
UNEXPECTED — BLOCKER = 0
```

Si no se cumple:

`BLOCKER`

### 18.5 Edición

Modificar exclusivamente:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Aplicar cambios mínimos únicamente sobre las referencias activas stale cubiertas por CORR-012.

No reescribir el documento completo.

### 18.6 Validación del diff

Ejecutar al menos:

```text
git diff --name-only
git diff -- docs/product/11-phase-1-scope-entry-gate.md
git diff --check
git diff --stat
git diff --numstat
git status --short
git status --porcelain=v1 --untracked-files=all
```

`git diff --name-only` debe contener exactamente:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Cualquier otro archivo:

`BLOCKER`

### 18.7 Estado de los cambios

Después de una ejecución documental correcta y antes de revisión humana:

- el cambio debe quedar unstaged;
- `git add = NO`;
- commit = `NO`;
- push = `NO`;
- Supabase Cloud modificado = `NO`.

La incorporación Git exige un acto posterior separado después de revisar el diff.

---

## 19. Verificaciones de la futura ejecución

La ejecución deberá reportar evidencia suficiente de los siguientes controles.

### 19.1 Scope

```text
archivos modificados = 1
archivo modificado = docs/product/11-phase-1-scope-entry-gate.md
```

### 19.2 Estado de TASK-010

Confirmar que las referencias activas cubiertas registran:

```text
TASK-010 = COMPLETADA
AuditEvent foundation física = SÍ
```

sin declarar productores funcionales.

### 19.3 Seguridad

Confirmar que continúan:

```text
RLS sobre audit_events = HABILITADA
application policies sobre audit_events = 0
table privileges anon = NONE
table privileges authenticated = NONE
authenticated TRUNCATE = DENIED
```

cuando esos detalles formen parte del snapshot activo actualizado, y que ninguna policy o privilege haya sido alterada por CORR-012.

### 19.4 Capacidad funcional

Confirmar:

```text
Auth funcional = NO
Authorization ready = NO
Client = NO
UserClientAccess = NO
SupportAccessGrant = NO
auditoría funcional completa = NO
```

### 19.5 Catálogo de acciones

Confirmar que la documentación no transforma las cuatro acciones físicas en flows:

```text
USER_CREATED
USER_DISABLED_OR_REVOKED
USER_REINSTATED
USER_ROLE_CHANGED
```

Y que siguen no habilitadas físicamente:

```text
USER_CLIENT_ACCESS_CHANGED
SUPPORT_ACCESS_GRANTED
SUPPORT_ACCESS_SCOPE_CHANGED
SUPPORT_ACCESS_REVOKED
SUPPORT_ACCESS_USED
```

### 19.6 Historia

Confirmar que ninguna referencia histórica fue modernizada para reflejar retrospectivamente el cierre de TASK-010.

### 19.7 Governance posterior

Confirmar:

```text
TASK-011 determinada = NO
TASK-011 generada = NO
Siguiente TASK autorizada automáticamente = NO
```

### 19.8 Diff

Resultado obligatorio:

```text
git diff --check = PASS
```

---

## 20. Criterios de aceptación

Una futura ejecución de CORR-012 sólo puede considerarse correcta si todos los criterios siguientes se verifican individualmente.

### Scope y gobernanza

**AC-012-001** — El identificador utilizado es exactamente `CORR-012`.

**AC-012-002** — La corrección conserva naturaleza exclusivamente documental.

**AC-012-003** — El único `CHANGE REQUIRED` es `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-012-004** — La cantidad de archivos `CHANGE REQUIRED` es exactamente `1`.

**AC-012-005** — El diff futuro contiene exactamente un archivo modificado.

**AC-012-006** — Ningún documento `NO CHANGE REQUIRED` es modificado.

**AC-012-007** — TASK-009, CORR-011 y TASK-010 se preservan como historia/governance.

**AC-012-008** — CORR-012 no determina TASK-011.

**AC-012-009** — CORR-012 no genera TASK-011.

**AC-012-010** — La siguiente TASK continúa sin autorización automática.

### Estado activo de TASK-010

**AC-012-011** — Las superficies activas cubiertas registran `TASK-010 = COMPLETADA`.

**AC-012-012** — Las superficies activas cubiertas registran `AuditEvent foundation física = SÍ`.

**AC-012-013** — La migration TASK-010 se presenta únicamente como resultado técnico ya implementado.

**AC-012-014** — El SQL test TASK-010 se presenta como presente y probado en Development.

**AC-012-015** — El test estático TASK-010 se presenta como presente.

**AC-012-016** — Development Gate TASK-010 permanece `PASS` como evidencia del cierre recibido.

**AC-012-017** — `fixtures TASK-010 restantes = 0` se preserva cuando el snapshot técnico activo lo detalla.

### AuditEvent y frontera funcional

**AC-012-018** — `AuditEvent foundation física = SÍ` no se interpreta como `auditoría funcional completa = SÍ`.

**AC-012-019** — `auditoría funcional completa = NO` permanece explícita o inequívocamente derivable.

**AC-012-020** — No se afirma que exista flow funcional de alta de usuarios.

**AC-012-021** — No se afirma que exista flow funcional de disable/revoke.

**AC-012-022** — No se afirma que exista flow funcional de reintegración.

**AC-012-023** — No se afirma que exista flow funcional de cambio de role.

**AC-012-024** — No se afirma que exista flow funcional de client access.

**AC-012-025** — No se afirma que exista flow funcional de soporte.

### Catálogo físico

**AC-012-026** — Las acciones físicas de TASK-010 continúan siendo exactamente cuatro.

**AC-012-027** — `USER_CREATED` continúa representable físicamente.

**AC-012-028** — `USER_DISABLED_OR_REVOKED` continúa representable físicamente.

**AC-012-029** — `USER_REINSTATED` continúa representable físicamente.

**AC-012-030** — `USER_ROLE_CHANGED` continúa representable físicamente.

**AC-012-031** — Las cuatro acciones no son descritas como flows funcionales implementados.

**AC-012-032** — `USER_CLIENT_ACCESS_CHANGED` continúa no físicamente habilitada.

**AC-012-033** — `SUPPORT_ACCESS_GRANTED` continúa no físicamente habilitada.

**AC-012-034** — `SUPPORT_ACCESS_SCOPE_CHANGED` continúa no físicamente habilitada.

**AC-012-035** — `SUPPORT_ACCESS_REVOKED` continúa no físicamente habilitada.

**AC-012-036** — `SUPPORT_ACCESS_USED` continúa no físicamente habilitada.

**AC-012-037** — CORR-012 no amplía el catálogo físico.

### Seguridad y multitenancy

**AC-012-038** — `tenant = MaintenanceCompany` permanece intacto.

**AC-012-039** — `authenticated != authorized` permanece intacto.

**AC-012-040** — RLS continúa siendo frontera primaria para datos tenant-owned.

**AC-012-041** — `AuditEvent` no se convierte en fuente de autorización.

**AC-012-042** — La existencia de AuditEvent no se convierte en permiso vigente.

**AC-012-043** — `service-role` continúa excepcional/restringido.

**AC-012-044** — `SUPER_ADMIN` no obtiene acceso tenant ordinario por el cierre de TASK-010.

**AC-012-045** — El frontend no se convierte en autoridad de tenant.

**AC-012-046** — RLS sobre `audit_events` continúa habilitada como estado técnico cerrado.

**AC-012-047** — Las policies funcionales de aplicación sobre `audit_events` continúan en `0`.

**AC-012-048** — Los privilegios de tabla de `anon` continúan `NONE`.

**AC-012-049** — Los privilegios de tabla de `authenticated` continúan `NONE`.

**AC-012-050** — `authenticated TRUNCATE audit_events` continúa `DENIED`.

**AC-012-051** — CORR-012 no cambia ninguna policy, privilege, grant o regla RLS.

### Capacidades todavía ausentes

**AC-012-052** — `Auth funcional = NO`.

**AC-012-053** — `Auth SSR lifecycle completo = NO`.

**AC-012-054** — `Authorization ready = NO`.

**AC-012-055** — `VerificationChallenge = NO`.

**AC-012-056** — `Client = NO`.

**AC-012-057** — `UserClientAccess = NO`.

**AC-012-058** — `SupportAccessGrant = NO`.

**AC-012-059** — `Application authorization completa = NO`.

**AC-012-060** — `Storage = NO`.

**AC-012-061** — `Realtime = NO`.

**AC-012-062** — `Offline = NO`.

### Arquitectura e historia

**AC-012-063** — ADR-0001 permanece `ACCEPTED`.

**AC-012-064** — ADR-0002 permanece `ACCEPTED`.

**AC-012-065** — ADR-0003 permanece `ACCEPTED`.

**AC-012-066** — ADR-0004 permanece `BLOCKED BY OPEN DECISIONS`.

**AC-012-067** — ADR-0004 conserva exactamente `DO-T04`, `OFF-OPEN-001`, `OFF-OPEN-002`, `FORM-OPEN-004`.

**AC-012-068** — No se crea ADR nuevo.

**AC-012-069** — No se resuelve ningún OPEN.

**AC-012-070** — Las referencias históricas de Fase 1 permanecen intactas.

**AC-012-071** — Las referencias históricas de TASK-009 permanecen intactas.

**AC-012-072** — Las referencias históricas de CORR-011 permanecen intactas.

**AC-012-073** — Las referencias históricas de TASK-010 permanecen intactas.

**AC-012-074** — Una declaración histórica `Implementación realizada = NO` dentro de TASK-010 no es modernizada.

### Ejecución y diff

**AC-012-075** — No se modifica código.

**AC-012-076** — No se escribe SQL.

**AC-012-077** — No se crea ni modifica migration.

**AC-012-078** — No se crea ni modifica RLS ejecutable.

**AC-012-079** — No se modifica Supabase Cloud.

**AC-012-080** — El diff futuro queda limitado a `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-012-081** — `git diff --check = PASS`.

**AC-012-082** — Los cambios quedan unstaged después de la ejecución documental.

**AC-012-083** — No se ejecuta `git add` durante la ejecución documental.

**AC-012-084** — No se realiza commit durante la ejecución documental.

**AC-012-085** — No se realiza push durante la ejecución documental.

**AC-012-086** — El diff completo es revisado antes de cualquier incorporación Git.

---

## 21. Blockers

La futura ejecución debe detenerse con `BLOCKER` si ocurre cualquiera de las siguientes condiciones.

### 21.1 Git y baseline

1. el estado Git real presenta drift material inesperado;
2. branch/upstream/divergencia no permiten reconciliar de forma segura el baseline;
3. el worktree contiene cambios ajenos que impiden aislar CORR-012;
4. TASK-010 ya no puede considerarse cerrada conforme a la autoridad vigente.

### 21.2 Técnica

5. la migration física de TASK-010 no coincide materialmente con el baseline cerrado;
6. el test SQL de TASK-010 falta o contradice el cierre recibido;
7. el test estático de TASK-010 falta o contradice el contrato de cuatro acciones;
8. el estado real permite una de las cinco acciones futuras que debían continuar bloqueadas;
9. el estado real contradice RLS/policies/privileges/TRUNCATE del cierre recibido.

### 21.3 Documentación

10. aparece un documento adicional `CHANGE REQUIRED`;
11. actualizar el estado requiere modificar más de un archivo;
12. no puede distinguirse una referencia histórica de una referencia activa;
13. el wording real del documento 11 difiere materialmente de lo auditado y no puede corregirse sin ampliar scope;
14. el diff futuro altera historia;
15. el diff futuro modifica una regla todavía vigente.

### 21.4 Producto, arquitectura y seguridad

16. actualizar el estado exige cambiar producto;
17. actualizar el estado exige cambiar un ADR;
18. actualizar el estado exige cambiar seguridad o RLS;
19. actualizar el estado exige resolver un OPEN;
20. actualizar el estado exige diseñar una capability futura.

### 21.5 Governance posterior

21. para completar CORR-012 se necesita determinar TASK-011;
22. para completar CORR-012 se necesita generar TASK-011;
23. se intenta usar CORR-012 para autorizar la siguiente implementación.

### 21.6 Validación

24. `git diff --check` falla;
25. `git diff --name-only` contiene más de `docs/product/11-phase-1-scope-entry-gate.md`;
26. la ejecución produce cualquier cambio Supabase, código, SQL, migration o RLS.

Ante cualquier BLOCKER:

```text
no ampliar scope
no reparar silenciosamente
no continuar
retornar al Revisor Central
```

---

## 22. Definition of Done documental

La futura corrección sólo podrá considerarse ejecutada y cerrada después de que se cumpla toda la siguiente secuencia:

1. la especificación canónica de CORR-012 fue revisada y aprobada documentalmente;
2. CORR-012 fue canonicalizada;
3. la canonicalización fue revisada humanamente;
4. existe autorización humana separada para una ejecución documental concreta;
5. el preflight Git fresco resulta PASS;
6. se repite la auditoría documental integral;
7. `UNEXPECTED — BLOCKER = 0`;
8. se modifica exactamente un archivo;
9. el único archivo modificado es `docs/product/11-phase-1-scope-entry-gate.md`;
10. el estado activo post-TASK-010 queda sincronizado;
11. la historia queda preservada;
12. producto queda sin cambios;
13. arquitectura queda sin cambios;
14. seguridad y multitenancy quedan sin cambios;
15. RLS queda sin cambios;
16. no se modifica código;
17. no se escribe SQL;
18. no se modifica ninguna migration;
19. no se modifica Supabase Cloud;
20. `git diff --check = PASS`;
21. el diff completo es revisado humanamente;
22. la incorporación Git es autorizada mediante otro acto separado;
23. Git se incorpora y verifica conforme a la autorización recibida;
24. existe revisión humana final;
25. existe cierre humano final de CORR-012.

Un PASS de ejecución documental no equivale por sí solo al cierre humano final.

---

## 23. Gate posterior

La secuencia obligatoria es:

```text
CORR-012 = APPROVED FOR IMPLEMENTATION
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

`aprobación documental != canonicalización != ejecución autorizada != cierre`

Sólo después del cierre humano final el resultado vuelve al:

`REVISOR CENTRAL`

para un acto nuevo y separado que podrá evaluar cuál debe ser el siguiente incremento PR-sized de Fase 2.

CORR-012 no participa en esa determinación.

Debe quedar expresamente:

```text
TASK-010 = COMPLETADA
!=
TASK-011 determinada
!=
TASK-011 generada
!=
TASK-011 autorizada
```

Y también:

```text
TASK-010 = COMPLETADA
!=
Siguiente TASK autorizada automáticamente
```

---

## 24. Resultado de esta preparación

```text
CORR-012 = APPROVED FOR IMPLEMENTATION

CORR-012 determinada = SÍ
CORR-012 generada = SÍ
CORR-012 especificada = SÍ
CORR-012 aprobada = SÍ

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
repositorio modificado = NO
Supabase Cloud modificado = NO
Git modificado = NO

TASK-011 determinada = NO
TASK-011 generada = NO

UNEXPECTED — BLOCKER = 0
CORR-012 SPECIFICATION = PASS
CORR-012 SPEC REVIEW = APPROVED
```

---

## 25. Metadata final

**ID:** `CORR-012`

**Título:** `CORR-012 — Sincronización documental posterior al cierre de TASK-010`

**Tipo:** `CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:** `CORR-012-task-010-closure-state-sync-approved.md`

**Ruta canónica futura propuesta:** `docs/tasks/CORR-012-task-010-closure-state-sync.md`

**Naturaleza:** exclusivamente documental.

**Documento `CHANGE REQUIRED`:**

```text
docs/product/11-phase-1-scope-entry-gate.md
```

**Cantidad de archivos `CHANGE REQUIRED`:** `1`

**Documentos `NO CHANGE REQUIRED`:**

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/10-architecture-decisions-records.md
docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

**Documentos `HISTORICAL/GOVERNANCE — KEEP`:**

```text
docs/tasks/TASK-009-identity-tenant-foundation.md
docs/tasks/CORR-011-task-009-closure-state-sync.md
docs/tasks/TASK-010-audit-event-foundation.md
```

**`UNEXPECTED — BLOCKER`:** `0`

**Cambio de producto:** `NO`

**Cambio de arquitectura:** `NO`

**Cambio de seguridad:** `NO`

**Cambio de multitenancy:** `NO`

**Cambio de RLS:** `NO`

**ADR nuevo requerido:** `NO`

**Implementación realizada:** `NO`

**Repositorio modificado:** `NO`

**Supabase Cloud modificado:** `NO`

**Git modificado:** `NO`

**TASK-011 determinada:** `NO`

**TASK-011 generada:** `NO`

**CORR-012 SPEC REVIEW:** `APPROVED`

Estado de esta especificación:

```text
CORR-012 = APPROVED FOR IMPLEMENTATION
```
