# CORR-014 — Sincronización documental posterior al cierre de TASK-012

## 1. Identificación

**ID:** `CORR-014`

**Título:** `CORR-014 — Sincronización documental posterior al cierre de TASK-012`

**Tipo:** `CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`CORR-014-task-012-closure-state-sync-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/CORR-014-task-012-closure-state-sync.md`

**Naturaleza:** exclusivamente documental.

**Implementación realizada:** `NO`

**Ejecución concreta autorizada:** `NO`

**Codex utilizado durante esta preparación:** `NO`

**Repositorio modificado durante esta preparación:** `NO`

**Supabase Cloud modificado durante esta preparación:** `NO`

**CORR-014 determinada:** `SÍ`

**CORR-014 generada:** `SÍ`

**CORR-014 especificada:** `SÍ`

**CORR-014 aprobada:** `SÍ`

**CORR-014 canonicalizada:** `NO`

**CORR-014 ejecutada:** `NO`

**CORR-014 completada:** `NO`

**TASK-013 determinada:** `NO`

**TASK-013 generada:** `NO`

Esta especificación define exclusivamente el contrato de una futura corrección documental. No implementa CORR-014, no autoriza su ejecución y no modifica por sí misma ningún archivo canónico.

---

## 2. Estado de gobernanza de entrada

CORR-014 consume como estado formal aprobado:

```text
Fase 0 = COMPLETADA
Fase 1 = COMPLETADA
Fase 2 = INICIADA

TASK-008 = COMPLETADA
CORR-010 = COMPLETADA
TASK-009 = COMPLETADA
CORR-011 = COMPLETADA
TASK-010 = COMPLETADA
CORR-012 = COMPLETADA
TASK-011 = COMPLETADA
CORR-013 = COMPLETADA
TASK-012 = COMPLETADA

TASK-012 FINAL HUMAN CLOSURE = APPROVED
```

El cierre de TASK-012 incorporó exclusivamente:

```text
Authoritative online authorization foundation = IMPLEMENTADA
Current tenant membership resolver = IMPLEMENTADO
Current tenant role resolver = IMPLEMENTADO
```

Debe permanecer:

```text
TASK-013 determinada = NO
TASK-013 generada = NO
Siguiente TASK autorizada automáticamente = NO
```

La secuencia de governance preservada es:

```text
TASK completada
!=
siguiente TASK determinada automáticamente
!=
siguiente TASK generada automáticamente
!=
siguiente TASK autorizada automáticamente
```

CORR-014 no participa en la determinación técnica de TASK-013.

---

## 3. Resultado de discovery aprobado

CORR-014 consume, sin reabrir ni reevaluar, los siguientes actos formales:

```text
POST-TASK-012 DOCUMENTARY DISCOVERY = PASS
POST-TASK-012 DOCUMENTARY DISCOVERY REVIEW = APPROVED
POST-TASK-012 DOCUMENTARY CORRECTION REQUIRED = YES
CORR-014 DETERMINATION = APPROVED
```

La clasificación aprobada es:

### `CHANGE REQUIRED`

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Cantidad:

```text
CHANGE REQUIRED = 1
```

Superficies activas stale confirmadas:

```text
§7.9
§10.2
§14.2
§17
```

Clasificación de las cuatro superficies:

```text
ACTIVE STALE REFERENCE — CHANGE
```

No se detectaron otros documentos activos que requieran modificación.

Debe permanecer:

```text
UNEXPECTED — BLOCKER = 0
```

La futura ejecución de CORR-014 debe poder permanecer limitada a un solo archivo. Si la auditoría futura contradice esta condición, no se amplía el scope: la ejecución se bloquea.

---

## 4. Objetivo único

CORR-014 tiene un único objetivo:

> sincronizar exclusivamente el estado documental activo posterior al cierre humano final de TASK-012, registrando el cierre de TASK-012 y las tres capabilities efectivamente implementadas, sin convertir esa foundation en autorización funcional completa y sin reescribir historia.

La regla central es:

```text
sincronizar estado activo
!=
reescribir historia
```

CORR-014 debe registrar exclusivamente:

```text
TASK-012 = COMPLETADA

Authoritative online authorization foundation = IMPLEMENTADA
Current tenant membership resolver = IMPLEMENTADO
Current tenant role resolver = IMPLEMENTADO
```

Debe preservar simultáneamente que:

```text
authoritative tenant/role resolution foundation
!=
full application authorization
!=
route authorization
!=
resource authorization
```

CORR-014 no crea el cierre de TASK-012, no reevalúa TASK-012 y no modifica su contrato técnico. Consume un cierre humano ya aprobado y lo sincroniza únicamente en referencias activas stale.

---

## 5. Fuentes de verdad obligatorias

El repositorio y la documentación canónica vigente son la fuente de verdad.

Antes de cualquier futura ejecución, y como baseline normativa de esta especificación, deben leerse íntegramente como mínimo:

### 5.1 Producto

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

### 5.2 Arquitectura

```text
docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

### 5.3 Tareas y correcciones

```text
docs/tasks/TASK-008-supabase-application-boundary.md
docs/tasks/CORR-010-task-008-closure-state-sync.md
docs/tasks/TASK-009-identity-tenant-foundation.md
docs/tasks/CORR-011-task-009-closure-state-sync.md
docs/tasks/TASK-010-audit-event-foundation.md
docs/tasks/CORR-012-task-010-closure-state-sync.md
docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md
docs/tasks/CORR-013-task-011-closure-state-sync.md
docs/tasks/TASK-012-authoritative-online-authorization-foundation.md
```

### 5.4 Estado humano autoritativo

La futura ejecución debe recibir y reconciliar explícitamente el cierre humano de TASK-012:

```text
TASK-012 = COMPLETADA
TASK-012 FINAL HUMAN CLOSURE = APPROVED
```

La ausencia de un documento separado para un acto humano externo no autoriza a inventar otro estado. La especificación canónica de TASK-012 continúa siendo historia de su contrato pre-implementación; el cierre posterior se consume como estado humano y técnico ya producido.

### 5.5 Regla de autoridad

No utilizar conversación histórica como sustituto del canon.

Si el repositorio real, una fuente canónica obligatoria o el cierre humano de TASK-012 presentan una contradicción material que no pueda clasificarse sin inferencia:

```text
CORR-014 EXECUTION = BLOCKER
```

No resolver la contradicción por iniciativa propia.

---

## 6. Frontera funcional que debe preservarse

Después de TASK-012 debe continuar inequívocamente:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Refresh funcional de access token = NO
Proxy/middleware Auth funcional = NO

Authorization ready = NO
Application authorization completa = NO
route authorization = NO
resource authorization = NO

VerificationChallenge = NO
Client = NO
UserClientAccess = NO
SupportAccessGrant = NO
Client authorization = NO
Support authorization = NO

Storage funcional = NO
Realtime funcional = NO
Offline authorization = NO
Offline funcional = NO
UI funcional de Auth = NO

Productores funcionales de AuditEvent = NO
auditoría funcional completa = NO
```

No se autoriza declarar simplemente:

```text
Authorization ready = SÍ
```

La implementación de TASK-012 proporciona un contexto mínimo autoritativo de tenant/role para futuras decisiones de autorización; no completa las decisiones funcionales sobre rutas, recursos, clientes, soporte ni operaciones de producto.

En caso de ambigüedad de wording durante una futura ejecución, debe conservarse el significado más restrictivo compatible con las fuentes canónicas.

---

## 7. Precisión obligatoria de tenant resolver y role resolver

Las referencias activas previas pueden contener formulaciones equivalentes a:

```text
tenant resolver = NO
role resolver = NO
```

No deben transformarse mecánicamente en:

```text
tenant resolver = SÍ
role resolver = SÍ
```

porque esas expresiones genéricas podrían sugerir una capacidad más amplia que la realmente implementada.

El estado post-TASK-012 que CORR-014 puede registrar es específicamente:

```text
Authoritative online authorization foundation = IMPLEMENTADA
Current tenant membership resolver = IMPLEMENTADO
Current tenant role resolver = IMPLEMENTADO
```

La foundation implementada:

- parte de una identidad Auth validada server-side;
- resuelve el `PlatformUser` correspondiente;
- utiliza estado autoritativo actual;
- requiere `CompanyMembership` vigente y habilitada;
- deriva la `MaintenanceCompany` desde la membership autoritativa;
- deriva el role tenant vigente desde esa membership;
- es request-scoped;
- falla cerrado ante ausencia, ambigüedad, inconsistencia o error;
- no acepta tenant o role afirmado por frontend como autoridad;
- no convierte JWT claims, cookies, path, query, body, headers o cache stale en autoridad;
- no implementa autorización por recurso;
- no implementa route authorization;
- no implementa `Client` scope;
- no implementa `UserClientAccess`;
- no implementa `SupportAccessGrant`.

Una futura edición debe usar wording que preserve esa precisión semántica.

---

## 8. Seguridad y multitenancy

CORR-014 debe preservar íntegramente:

```text
tenant = MaintenanceCompany

authenticated != authorized

valid Auth session != tenant authorization

valid Auth subject != authorized PlatformUser

PlatformUser exists != current enabled CompanyMembership

JWT claims != current authorization authority

frontend state != current authorization authority

current authoritative database state > stale authorization state

RLS = primary remote isolation boundary

service-role = exceptional/restricted
service-role normal path = NO

SUPER_ADMIN global != ordinary tenant authorization

AuditEvent != authorization authority
```

TASK-012 no creó un bypass tenant.

TASK-012 no sustituyó RLS.

TASK-012 no convirtió una sesión técnicamente válida en autorización tenant automática.

TASK-012 no convirtió `SUPER_ADMIN` en miembro implícito de un tenant.

CORR-014 no puede reinterpretar ninguno de estos límites.

---

## 9. RLS, datos y Supabase

CORR-014 es exclusivamente documental y debe registrar:

```text
schema change = NO
migration = NO
SQL = NO
RLS change = NO
policy change = NO
grant/revoke change = NO
RPC = NO
SECURITY DEFINER = NO
Supabase Cloud change = NO
```

No se autoriza modificar conceptual ni físicamente:

```text
maintenance_companies
platform_users
platform_user_auth_subjects
company_memberships
audit_events
```

TASK-012 consumió la foundation física y RLS ya existente de TASK-009.

TASK-012 no añadió ni modificó policies, grants, revokes, funciones, RPC, triggers, índices, constraints, tablas ni migrations.

La futura ejecución de CORR-014 no puede utilizar una necesidad documental como pretexto para cambiar esas superficies.

---

## 10. AuditEvent

Debe preservarse:

```text
AuditEvent foundation física = SÍ
```

pero también:

```text
AuditEvent producer TASK-012 = NO
Productores funcionales de AuditEvent = NO
auditoría funcional completa = NO
```

No se autoriza:

- crear acciones nuevas;
- ampliar el catálogo físico existente;
- documentar la resolución read-only de identidad/membership/tenant/role como productor funcional ya implementado;
- registrar denegaciones de autorización como `AuditEvent` implementadas por TASK-012;
- utilizar `AuditEvent` como fuente de autorización vigente.

La regla permanece:

```text
AuditEvent history
!=
current authorization authority
```

---

## 11. `SUPER_ADMIN`

Debe mantenerse:

```text
SUPER_ADMIN global != ordinary tenant authorization
```

TASK-012 no implementó contexto tenant ordinario para `SUPER_ADMIN` sin membership.

CORR-014 no puede:

- declarar bypass global;
- convertir el rol global en membership tenant;
- introducir `SupportAccessGrant`;
- inferir support scope;
- presentar `SUPER_ADMIN` como actor tenant autorizado por la foundation de TASK-012.

Cualquier necesidad de reinterpretar `SUPER_ADMIN` implica:

```text
CORR-014 EXECUTION = BLOCKER
```

---

## 12. ADR y decisiones abiertas

Debe permanecer exactamente:

```text
ADR-0001 = ACCEPTED
ADR-0002 = ACCEPTED
ADR-0003 = ACCEPTED
ADR-0004 = BLOCKED BY OPEN DECISIONS
```

Blockers exactos de `ADR-0004`:

```text
DO-T04
OFF-OPEN-001
OFF-OPEN-002
FORM-OPEN-004
```

Debe permanecer:

```text
DO-T03 = RESUELTO/APROBADO
ADR nuevo requerido = NO
OPEN resuelto = NINGUNO
```

CORR-014 no redacta, acepta, modifica ni resuelve ADR.

CORR-014 no resuelve decisiones `DO-*` ni `*-OPEN-*`.

Si la corrección documental necesitara resolver una decisión abierta o crear un ADR:

```text
CORR-014 EXECUTION = BLOCKER
```

---

## 13. Taxonomía documental obligatoria

Toda coincidencia material revisada durante una futura ejecución debe clasificarse exclusivamente como una de las siguientes categorías.

### 13.1 `ACTIVE STALE REFERENCE — CHANGE`

Referencia que pretende describir el estado actual del proyecto pero quedó materialmente obsoleta por el cierre posterior de TASK-012.

Sólo puede modificarse cuando además se encuentre dentro del único archivo y de las cuatro superficies expresamente autorizadas.

### 13.2 `VALID CURRENT REFERENCE — KEEP`

Referencia que sigue describiendo correctamente el estado vigente o una regla de governance todavía aplicable.

Debe conservarse.

### 13.3 `HISTORICAL/GOVERNANCE — KEEP`

Referencia que describe correctamente un estado, decisión, Gate, contrato pre-implementación o acto histórico en el momento en que fue aprobado.

No se moderniza retrospectivamente.

### 13.4 `UNEXPECTED — BLOCKER`

Coincidencia que:

- requiere modificar otro archivo;
- requiere modificar una sección no autorizada;
- contradice la clasificación aprobada del discovery;
- impide separar con seguridad estado activo de historia;
- exige una nueva decisión de producto o arquitectura;
- exige cambiar seguridad, RLS o schema;
- exige resolver un OPEN;
- exige determinar TASK-013;
- o hace insuficiente el scope documental PR-sized de CORR-014.

Ante esta clasificación:

```text
NO autorepair
NO ampliar scope
DETENERSE
```

---

## 14. Único documento futuro modificable

La futura ejecución de CORR-014 puede modificar exclusivamente:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Cantidad máxima:

```text
1 archivo
```

Está expresamente prohibido modificar:

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md
docs/architecture/**
docs/tasks/**
app/**
src/**
tests/**
supabase/**
package.json
package-lock.json
```

Si una futura auditoría demuestra que un segundo archivo necesita una modificación material para que el estado activo sea coherente:

```text
CORR-014 EXECUTION = BLOCKER
```

No ampliar scope automáticamente.

---

## 15. Superficies autorizadas en `docs/product/11`

La futura ejecución sólo puede modificar referencias activas stale dentro de:

```text
§7.9
§10.2
§14.2
§17
```

Los números de sección son localizadores del discovery aprobado, no sustituyen la lectura del wording real.

Antes de editar, la futura ejecución debe releer íntegramente:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

y confirmar que las cuatro superficies conservan la función semántica identificada.

No se autoriza:

- reescritura general del documento;
- reformateo lateral;
- limpieza estilística fuera del diff mínimo;
- cambio de headings no necesario;
- modificación de otra sección por conveniencia;
- “modernización” de Gate o historia de fases anteriores.

Si el wording real cambió materialmente y la corrección mínima ya no puede aplicarse con seguridad:

```text
CORR-014 EXECUTION = BLOCKER
```

---

## 16. Tratamiento de §7.9

Clasificación:

```text
ACTIVE STALE REFERENCE — CHANGE
```

La futura ejecución debe revisar primero el wording real existente y avanzar exclusivamente el snapshot activo post-TASK-011 al estado post-TASK-012.

Debe registrar:

```text
TASK-012 = COMPLETADA

Authoritative online authorization foundation = IMPLEMENTADA
Current tenant membership resolver = IMPLEMENTADO
Current tenant role resolver = IMPLEMENTADO
```

Debe preservar, cuando aparezcan o se deriven en la superficie, todos los límites funcionales todavía negativos, incluyendo:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Refresh funcional de access token = NO
Proxy/middleware Auth funcional = NO
Authorization ready = NO
Application authorization completa = NO
route authorization = NO
resource authorization = NO
VerificationChallenge = NO
Client = NO
UserClientAccess = NO
SupportAccessGrant = NO
Client authorization = NO
Support authorization = NO
Storage funcional = NO
Realtime funcional = NO
Offline authorization = NO
Offline funcional = NO
UI funcional de Auth = NO
Productores funcionales de AuditEvent = NO
auditoría funcional completa = NO
```

Si la superficie contiene las formulaciones genéricas:

```text
tenant resolver = NO
role resolver = NO
```

no deben cambiarse mecánicamente a `SÍ`. Debe reemplazarse o aclararse únicamente lo estrictamente necesario para expresar las capabilities específicas implementadas por TASK-012 sin sugerir autorización completa.

La frontera de governance debe avanzar exclusivamente a:

```text
TASK-013 determinada = NO
TASK-013 generada = NO
Siguiente TASK autorizada automáticamente = NO
```

No determinar TASK-013.

---

## 17. Tratamiento de §10.2

Clasificación:

```text
ACTIVE STALE REFERENCE — CHANGE
```

Debe preservarse la regla de governance:

```text
una TASK completada != siguiente TASK autorizada automáticamente
```

El único cambio semántico permitido es actualizar el sujeto stale de la frontera hacia:

```text
TASK-012 / TASK-013
```

Debe quedar inequívocamente:

```text
TASK-012 = COMPLETADA
!=
TASK-013 determinada
!=
TASK-013 generada
!=
TASK-013 autorizada
```

Y además:

```text
TASK-012 = COMPLETADA
!=
Siguiente TASK autorizada automáticamente
```

§10.2 continúa siendo governance de secuenciación. No puede convertirse en recomendación, discovery ni especificación técnica del siguiente incremento.

---

## 18. Tratamiento de §14.2

Clasificación:

```text
ACTIVE STALE REFERENCE — CHANGE
```

El resultado técnico activo debe avanzar hasta TASK-012 e incorporar exclusivamente:

```text
Authoritative online authorization foundation = IMPLEMENTADA
Current tenant membership resolver = IMPLEMENTADO
Current tenant role resolver = IMPLEMENTADO
```

Debe mantener los resultados técnicos cerrados de tareas anteriores cuando el wording real los incluya y preservar todos los límites negativos vigentes.

Especialmente, no declarar:

```text
Auth funcional = SÍ
Auth SSR lifecycle completo = SÍ
Refresh funcional de access token = SÍ
Proxy/middleware Auth funcional = SÍ
Authorization ready = SÍ
Application authorization completa = SÍ
route authorization = SÍ
resource authorization = SÍ
Client authorization = SÍ
Support authorization = SÍ
Offline authorization = SÍ
```

La existencia de un resolver actual de membership y role no autoriza a inferir acceso a un `Client`, a un recurso, a una ruta o a soporte excepcional.

---

## 19. Tratamiento de §17

Clasificación:

```text
ACTIVE STALE REFERENCE — CHANGE
```

§17 debe actualizar exclusivamente el estado final activo.

Debe registrar:

```text
TASK-012 completada: sí
```

Cuando el formato existente lo requiera, debe registrar además:

```text
Authoritative online authorization foundation = IMPLEMENTADA
Current tenant membership resolver = IMPLEMENTADO
Current tenant role resolver = IMPLEMENTADO
```

La frontera final debe quedar en:

```text
TASK-013 determinada: no
TASK-013 generada: no
Siguiente TASK autorizada automáticamente: no
```

No modificar metadata histórica de tareas o correcciones anteriores.

No convertir §17 en un changelog general ni en una recomendación de TASK-013.

---

## 20. Historia que debe preservarse

No se modernizan retrospectivamente:

```text
TASK-008
CORR-010
TASK-009
CORR-011
TASK-010
CORR-012
TASK-011
CORR-013
TASK-012
```

Los documentos canónicos de esas tareas y correcciones deben permanecer intactos.

En particular, una especificación canónica histórica puede conservar correctamente estados como:

```text
APPROVED FOR IMPLEMENTATION
Implementación autorizada = NO
Implementación realizada = NO
Codex autorizado = NO
```

cuando describen el acto documental anterior a una implementación posterior.

El cierre humano posterior de una TASK no convierte su especificación histórica en changelog.

---

## 21. TASK-013

CORR-014 no participa en la determinación del siguiente incremento.

Debe permanecer:

```text
TASK-013 determinada = NO
TASK-013 generada = NO
TASK-013 especificada = NO
TASK-013 aprobada = NO
TASK-013 autorizada = NO
Siguiente TASK autorizada automáticamente = NO
```

CORR-014 no puede:

- nombrar formalmente un candidato a TASK-013;
- realizar discovery técnica del siguiente incremento;
- determinar bounded context, entidad, flow, migration, policy, UI o objetivo de TASK-013;
- generar una especificación de TASK-013;
- introducir recomendaciones técnicas sobre qué debe implementarse después.

Se mantiene:

```text
TASK-012 = COMPLETADA
!=
TASK-013 determinada automáticamente
```

---

## 22. UI y comportamiento offline

### 22.1 UI

```text
UI flow = NO APLICA
```

CORR-014 no diseña ni implementa pantallas, rutas, formularios, navegación, redirects, guards ni Auth UI.

Debe permanecer:

```text
UI funcional de Auth = NO
```

### 22.2 Offline

CORR-014 no modifica la estrategia offline.

Debe preservar:

```text
Offline authorization = NO
Offline funcional = NO
```

No resuelve `ADR-0004` ni ninguna de sus decisiones bloqueantes.

---

## 23. Alcance exacto

### 23.1 Dentro de alcance

- sincronización documental del estado activo post-TASK-012;
- modificación futura de un único archivo activo;
- modificación futura limitada a cuatro superficies;
- registro de `TASK-012 = COMPLETADA`;
- registro de `Authoritative online authorization foundation = IMPLEMENTADA`;
- registro de `Current tenant membership resolver = IMPLEMENTADO`;
- registro de `Current tenant role resolver = IMPLEMENTADO`;
- preservación explícita de fronteras negativas de Auth/Authz;
- avance de la frontera de governance a TASK-013 todavía no determinada ni generada;
- preservación de historia.

### 23.2 Fuera de alcance

- código;
- Auth funcional;
- lifecycle Auth funcional completo;
- refresh funcional de access token;
- Proxy/middleware Auth funcional;
- `VerificationChallenge`;
- `Client`;
- `UserClientAccess`;
- `SupportAccessGrant`;
- client authorization;
- support authorization;
- route authorization;
- resource authorization;
- UI;
- Offline;
- Storage funcional;
- Realtime funcional;
- productores funcionales de `AuditEvent`;
- auditoría funcional completa;
- schema;
- migrations;
- SQL;
- RLS;
- policies;
- grants/revokes;
- RPC;
- `SECURITY DEFINER`;
- Supabase Cloud;
- ADR nuevos;
- resolución de OPEN;
- TASK-013.

---

## 24. Cambios físicos esperados en una futura ejecución

La futura ejecución debe esperar exactamente:

```text
MODIFY docs/product/11-phase-1-scope-entry-gate.md
```

y ningún otro archivo.

Esta especificación no modifica ese archivo.

Una futura ejecución correcta debe terminar con:

```text
archivos modificados = 1
archivo modificado = docs/product/11-phase-1-scope-entry-gate.md
```

Cualquier archivo adicional:

```text
CORR-014 EXECUTION = BLOCKER
```

---

## 25. Preflight Git futuro obligatorio

Antes de ejecutar CORR-014 debe realizarse un preflight Git fresco.

Último baseline humano conocido posterior a la incorporación de TASK-012:

```text
branch = main
HEAD = ad071adfbe937799808212c34e52dbf3a7e31078
origin/main = ad071adfbe937799808212c34e52dbf3a7e31078
divergencia = 0 0
worktree = limpio
```

Este snapshot es histórico.

No constituye un SHA inmutable para la ejecución futura, porque la aprobación, canonicalización e incorporación de CORR-014 producirán naturalmente estados Git posteriores.

El repositorio real futuro manda.

Como mínimo, la futura ejecución debe verificar y reportar:

```text
git rev-parse --show-toplevel
git branch --show-current
git rev-parse HEAD
git rev-parse --abbrev-ref --symbolic-full-name @{u}
git rev-parse origin/main
git rev-list --left-right --count HEAD...origin/main
git status --short
git status --porcelain=v1 --untracked-files=all
git diff --cached --name-only
```

Debe verificar además:

- repo root correcto;
- branch autorizada;
- HEAD real;
- upstream real;
- `origin/main` real;
- divergencia;
- worktree;
- staged;
- untracked;
- operaciones Git en progreso.

Ante drift material no explicado por actos documentales/autorizaciones posteriores:

```text
CORR-014 EXECUTION = BLOCKER
```

No autorizar autorepair mediante:

```text
git fetch
git pull
git merge
git rebase
git reset
git restore
git stash
git clean
```

---

## 26. Auditoría documental read-only previa a una futura ejecución

Antes de editar, Codex debe repetir una auditoría documental read-only.

Debe confirmar:

```text
CHANGE REQUIRED = docs/product/11-phase-1-scope-entry-gate.md
cantidad CHANGE REQUIRED = 1
```

Debe localizar y clasificar como mínimo referencias materiales relacionadas con:

```text
TASK-012
TASK-013
Authoritative online authorization foundation
Current tenant membership resolver
Current tenant role resolver
tenant resolver
role resolver
Authorization ready
Application authorization
route authorization
resource authorization
VerificationChallenge
Client
UserClientAccess
SupportAccessGrant
Offline authorization
AuditEvent
Siguiente TASK autorizada automáticamente
```

Toda coincidencia material debe clasificarse exclusivamente como:

```text
ACTIVE STALE REFERENCE — CHANGE
VALID CURRENT REFERENCE — KEEP
HISTORICAL/GOVERNANCE — KEEP
UNEXPECTED — BLOCKER
```

La auditoría debe confirmar que únicamente las cuatro superficies aprobadas requieren cambio.

Si aparece un segundo documento materialmente stale:

```text
CORR-014 EXECUTION = BLOCKER
```

No ampliar scope.

---

## 27. Condiciones `BLOCKER`

El resultado obligatorio será:

```text
CORR-014 EXECUTION = BLOCKER
```

si ocurre cualquiera de las siguientes condiciones:

1. existe Git drift material no reconciliado con actos autorizados posteriores;
2. falta una fuente obligatoria;
3. una fuente canónica presenta una contradicción material no resoluble sin inferencia;
4. TASK-012 no puede considerarse cerrada o `TASK-012 FINAL HUMAN CLOSURE = APPROVED` no puede sostenerse;
5. un segundo documento requiere cambio material;
6. se necesita modificar una sección distinta de `§7.9`, `§10.2`, `§14.2` o `§17`;
7. se necesita cambiar producto;
8. se necesita cambiar arquitectura;
9. se necesita cambiar seguridad o multitenancy;
10. se necesita cambiar RLS;
11. se necesita cambiar schema;
12. se necesita una migration;
13. se necesita SQL;
14. se necesita crear o modificar una policy;
15. se necesita modificar Supabase Cloud;
16. se necesita un ADR nuevo;
17. se necesita resolver un `DO-*` o `*-OPEN-*`;
18. se necesita reinterpretar `SUPER_ADMIN`;
19. se necesita implementar Auth funcional;
20. se necesita `Client`, `UserClientAccess` o `SupportAccessGrant`;
21. se necesita determinar, generar, especificar o autorizar TASK-013;
22. el diff deja de ser exclusivamente documental o deja de ser PR-sized;
23. aparece un archivo modificado inesperado;
24. `git diff --check` resulta FAIL;
25. cualquier criterio de aceptación de CORR-014 resulta FAIL.

Ante cualquier blocker:

```text
NO autorepair
NO ampliar scope
NO staging
NO commit
NO push
NO TASK-013
```

La ejecución debe detenerse y devolver el blocker exacto para revisión humana.

---

## 28. Pruebas documentales y verificaciones de seguridad

Por ser una corrección exclusivamente documental, CORR-014 no exige introducir ni modificar tests de aplicación.

La prueba del cambio es documental y negativa.

Debe verificarse como mínimo que el diff:

- modifica exactamente un archivo;
- se limita a las cuatro superficies autorizadas;
- registra TASK-012 como completada;
- registra exactamente las tres capabilities aprobadas;
- no declara Auth funcional;
- no declara autorización completa;
- no declara route authorization ni resource authorization;
- no introduce `Client`, `UserClientAccess` ni `SupportAccessGrant`;
- no modifica schema, migration, SQL, RLS ni policies;
- no modifica Supabase Cloud;
- no cambia ADR ni OPEN;
- no determina TASK-013;
- no reescribe historia.

No ejecutar tests funcionales como sustituto de estas verificaciones documentales. Si una futura ejecución decide ejecutar checks adicionales read-only del repositorio, éstos no pueden ampliar el scope ni autorizar correcciones laterales.

---

## 29. Criterios de aceptación

Cada criterio debe evaluarse individualmente como `PASS` o `FAIL` durante una futura ejecución.

### Identidad y scope

**AC-014-001** — El documento ejecutado corresponde a `CORR-014`.

**AC-014-002** — El título permanece exactamente `CORR-014 — Sincronización documental posterior al cierre de TASK-012`.

**AC-014-003** — El tipo permanece exactamente `CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO`.

**AC-014-004** — La especificación canónica utilizada para ejecutar está aprobada conforme al proceso de governance aplicable.

**AC-014-005** — La ejecución modifica exactamente un archivo.

**AC-014-006** — El único archivo modificado es `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-014-007** — El diff se limita a `§7.9`, `§10.2`, `§14.2` y `§17`.

**AC-014-008** — No existe un segundo documento `CHANGE REQUIRED`.

### Estado post-TASK-012

**AC-014-009** — `TASK-012 = COMPLETADA` queda registrado en las superficies activas donde corresponda.

**AC-014-010** — `Authoritative online authorization foundation = IMPLEMENTADA` queda registrada donde corresponda.

**AC-014-011** — `Current tenant membership resolver = IMPLEMENTADO` queda registrado con significado específico, no genérico.

**AC-014-012** — `Current tenant role resolver = IMPLEMENTADO` queda registrado con significado específico, no genérico.

**AC-014-013** — La documentación no transforma mecánicamente `tenant resolver = NO` en `tenant resolver = SÍ` sin preservar el significado exacto.

**AC-014-014** — La documentación no transforma mecánicamente `role resolver = NO` en `role resolver = SÍ` sin preservar el significado exacto.

### Fronteras funcionales negativas

**AC-014-015** — `Auth funcional = NO` permanece inequívoco.

**AC-014-016** — `Auth SSR lifecycle completo = NO` permanece inequívoco.

**AC-014-017** — `Refresh funcional de access token = NO` permanece inequívoco.

**AC-014-018** — `Proxy/middleware Auth funcional = NO` permanece inequívoco.

**AC-014-019** — `Authorization ready = NO` no es contradicho.

**AC-014-020** — `Application authorization completa = NO` permanece inequívoco.

**AC-014-021** — `route authorization = NO` permanece inequívoco.

**AC-014-022** — `resource authorization = NO` permanece inequívoco.

**AC-014-023** — `VerificationChallenge = NO` permanece inequívoco.

**AC-014-024** — `Client = NO` permanece inequívoco.

**AC-014-025** — `UserClientAccess = NO` permanece inequívoco.

**AC-014-026** — `SupportAccessGrant = NO` permanece inequívoco.

**AC-014-027** — `Client authorization = NO` permanece inequívoco.

**AC-014-028** — `Support authorization = NO` permanece inequívoco.

**AC-014-029** — `Offline authorization = NO` permanece inequívoco.

**AC-014-030** — `Offline funcional = NO` permanece inequívoco.

**AC-014-031** — `UI funcional de Auth = NO` permanece inequívoco.

**AC-014-032** — `Productores funcionales de AuditEvent = NO` permanece inequívoco.

**AC-014-033** — `auditoría funcional completa = NO` permanece inequívoco.

### Seguridad y multitenancy

**AC-014-034** — `tenant = MaintenanceCompany` permanece sin reinterpretación.

**AC-014-035** — `authenticated != authorized` permanece sin reinterpretación.

**AC-014-036** — Una sesión Auth válida no queda documentada como tenant authorization.

**AC-014-037** — Un `PlatformUser` existente no queda documentado como membership vigente automáticamente.

**AC-014-038** — JWT claims no se convierten en autoridad vigente de autorización.

**AC-014-039** — Frontend state no se convierte en autoridad vigente de autorización.

**AC-014-040** — El estado autoritativo actual de base de datos conserva prioridad frente a estado stale.

**AC-014-041** — RLS permanece como frontera primaria de aislamiento remoto.

**AC-014-042** — `service-role` permanece excepcional/restringido.

**AC-014-043** — `service-role normal path = NO` permanece sin contradicción.

**AC-014-044** — `SUPER_ADMIN` no obtiene bypass tenant ordinario.

**AC-014-045** — `AuditEvent` no se presenta como autoridad de autorización vigente.

### Datos / RLS / Supabase

**AC-014-046** — `schema change = NO`.

**AC-014-047** — `migration = NO`.

**AC-014-048** — `SQL = NO`.

**AC-014-049** — `RLS change = NO`.

**AC-014-050** — `policy change = NO`.

**AC-014-051** — `grant/revoke change = NO`.

**AC-014-052** — `RPC = NO`.

**AC-014-053** — `SECURITY DEFINER = NO`.

**AC-014-054** — `Supabase Cloud change = NO`.

**AC-014-055** — `maintenance_companies`, `platform_users`, `platform_user_auth_subjects`, `company_memberships` y `audit_events` no son modificadas.

### ADR / OPEN

**AC-014-056** — `ADR-0001 = ACCEPTED` permanece.

**AC-014-057** — `ADR-0002 = ACCEPTED` permanece.

**AC-014-058** — `ADR-0003 = ACCEPTED` permanece.

**AC-014-059** — `ADR-0004 = BLOCKED BY OPEN DECISIONS` permanece.

**AC-014-060** — Los blockers de ADR-0004 permanecen exactamente `DO-T04`, `OFF-OPEN-001`, `OFF-OPEN-002`, `FORM-OPEN-004`.

**AC-014-061** — `DO-T03 = RESUELTO/APROBADO` permanece.

**AC-014-062** — `ADR nuevo requerido = NO`.

**AC-014-063** — `OPEN resuelto = NINGUNO`.

### Governance / historia

**AC-014-064** — `TASK-013 determinada = NO` permanece.

**AC-014-065** — `TASK-013 generada = NO` permanece.

**AC-014-066** — `TASK-013 especificada = NO` no es contradicho.

**AC-014-067** — `TASK-013 aprobada = NO` no es contradicho.

**AC-014-068** — `TASK-013 autorizada = NO` no es contradicho.

**AC-014-069** — `Siguiente TASK autorizada automáticamente = NO` permanece inequívoco.

**AC-014-070** — §10.2 expresa `TASK-012 = COMPLETADA != TASK-013 determinada != TASK-013 generada != TASK-013 autorizada`.

**AC-014-071** — Los documentos canónicos de TASK-008/CORR-010/TASK-009/CORR-011/TASK-010/CORR-012/TASK-011/CORR-013/TASK-012 permanecen intactos.

**AC-014-072** — No se modernizan retrospectivamente statements históricos correctos en su momento.

**AC-014-073** — No se incorpora recomendación técnica ni nombre formal de TASK-013.

### Git y calidad documental

**AC-014-074** — `git diff --name-only` contiene exactamente `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-014-075** — `git diff --name-status` reporta exactamente un `M` para el archivo autorizado.

**AC-014-076** — `git diff --check = PASS`.

**AC-014-077** — No existe trailing whitespace accidental introducido por CORR-014.

**AC-014-078** — El line ending del archivo se preserva salvo necesidad explícita y revisada; no existe conversión global accidental.

**AC-014-079** — El full diff corresponde exclusivamente a la sincronización aprobada.

**AC-014-080** — `staged = ninguno` al finalizar la ejecución documental.

**AC-014-081** — `commit = NO` al finalizar la ejecución documental.

**AC-014-082** — `push = NO` al finalizar la ejecución documental.

**AC-014-083** — No existe archivo inesperado modificado, staged o creado por CORR-014.

**AC-014-084** — La ejecución no realiza Git implícito para incorporar el cambio.

Todos los criterios anteriores son obligatorios. Un único `FAIL` implica:

```text
CORR-014 EXECUTION = BLOCKER
```

---

## 30. Verificaciones futuras obligatorias

Al finalizar la futura ejecución documental, antes de cualquier staging, deben ejecutarse y reportarse como mínimo:

```text
git diff --name-only
git diff --name-status
git diff --stat
git diff --numstat
git diff --check
git status --short
git status --porcelain=v1 --untracked-files=all
git diff --cached --name-only
```

Y obligatoriamente:

```text
git diff --no-ext-diff -- docs/product/11-phase-1-scope-entry-gate.md
```

El full diff debe devolverse literalmente para revisión humana.

La ejecución debe confirmar:

```text
staged = ninguno
commit = NO
push = NO
```

Debe reportarse explícitamente cualquier untracked existente, aunque no pertenezca a CORR-014. Si representa drift material o hace ambiguo el scope, el resultado es `BLOCKER`.

---

## 31. Identidad post-cambio

La futura ejecución debe calcular y reportar para:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

los siguientes datos del artefacto resultante:

- SHA-256;
- bytes;
- line endings;
- trailing whitespace accidental.

El SHA-256 y el tamaño deben calcularse después de todas las ediciones autorizadas y antes de cualquier staging.

Debe quedar inequívoco si los line endings son:

```text
LF
```

o:

```text
CRLF
```

No debe producirse una conversión masiva de line endings fuera del cambio semántico previsto.

Estos valores fijarán la identidad documental para la revisión humana posterior.

---

## 32. Definition of Done

La aprobación documental de esta especificación no completa CORR-014.

Deben permanecer separados:

```text
especificación
aprobación
canonicalización
ejecución
revisión de ejecución
incorporación Git
cierre humano final
```

El estado ya cumplido al producir este artefacto aprobado es:

```text
especificación = REALIZADA
SPEC REVIEW = APPROVED
aprobación humana de especificación = APPROVED
```

Una CORR-014 sólo puede considerarse completada después de una secuencia equivalente a:

1. esta especificación fue generada;
2. el Revisor Central la revisó con resultado `CORR-014 SPEC REVIEW = APPROVED`;
3. las correcciones documentales de la especificación, si hubieran sido necesarias, precedieron a la aprobación;
4. existe aprobación humana formal con resultado `CORR-014 HUMAN SPEC APPROVAL = APPROVED`;
5. se genera el artefacto aprobado;
6. el artefacto aprobado es revisado;
7. la especificación se canonicaliza;
8. la canonicalización es revisada;
9. la especificación canónica se incorpora a Git mediante autorización separada;
10. existe autorización humana separada para una ejecución concreta;
11. existe un prompt exacto para Codex;
12. el preflight Git fresco resulta PASS;
13. la auditoría read-only resulta compatible con el scope aprobado;
14. Codex modifica exclusivamente el archivo y superficies autorizados;
15. todos los criterios de aceptación resultan PASS;
16. `git diff --check = PASS`;
17. el full diff es revisado humanamente;
18. la incorporación Git del cambio es autorizada separadamente;
19. staging/commit/push se realizan únicamente conforme a esa autorización separada;
20. Git final es verificado;
21. existe cierre humano final de CORR-014.

Debe mantenerse:

```text
Codex PASS != CORR-014 completada
```

Y también:

```text
CORR-014 completada != TASK-013 determinada automáticamente
```

---

## 33. Gate posterior

La secuencia posterior obligatoria parte del estado real posterior a esta aprobación:

1. artefacto aprobado de CORR-014 generado;
2. revisión del artefacto aprobado por el Revisor Central;
3. canonicalización;
4. revisión de canonicalización;
5. incorporación Git de la especificación mediante autorizaciones separadas;
6. autorización humana separada de ejecución;
7. prompt exacto para Codex;
8. ejecución documental sin staging/commit/push;
9. revisión humana del diff;
10. staging/commit/push mediante autorizaciones separadas;
11. verificación Git;
12. cierre humano final de CORR-014;
13. retorno al Revisor Central;
14. sólo entonces podrá realizarse la determinación del siguiente incremento.

Debe mantenerse:

```text
CORR-014 completada != TASK-013 determinada automáticamente
```

CORR-014 no determina, genera, especifica ni autoriza TASK-013.

---

## 34. Estado resultante de esta especificación

La revisión de consistencia de esta redacción no identifica una contradicción material que impida especificar CORR-014 dentro del alcance aprobado.

Resultado:

```text
CORR-014 SPECIFICATION = PASS
CORR-014 SPEC REVIEW = APPROVED
CORR-014 HUMAN SPEC APPROVAL = APPROVED

CORR-014 estado = APPROVED FOR IMPLEMENTATION

CORR-014 determinada = SÍ
CORR-014 generada = SÍ
CORR-014 especificada = SÍ

CORR-014 aprobada = SÍ
CORR-014 canonicalizada = NO
CORR-014 ejecución autorizada = NO
CORR-014 ejecutada = NO
CORR-014 completada = NO

TASK-013 determinada = NO
TASK-013 generada = NO
```

No se produce ningún efecto de implementación por este resultado.

---

## 35. Entrega

**Archivo generado:**

```text
CORR-014-task-012-closure-state-sync-approved.md
```

**Estado:**

```text
APPROVED FOR IMPLEMENTATION
```

**Ruta canónica futura propuesta:**

```text
docs/tasks/CORR-014-task-012-closure-state-sync.md
```

No se implementó CORR-014.

No se ejecutó CORR-014.

No se utilizó Codex.

No se modificó el repositorio.

No se modificó `docs/product/11-phase-1-scope-entry-gate.md`.

No se canonicalizó.

No se realizó `git add`.

No se realizó commit.

No se realizó push.

No se modificó Supabase Cloud.

No se escribió código.

No se escribió SQL.

No se creó migration.

No se escribió RLS.

No se determinó TASK-013.

No se generó TASK-013.
