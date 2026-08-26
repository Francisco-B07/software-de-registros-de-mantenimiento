# TASK-010 — Fundación física mínima de AuditEvent

## 1. Identificación

**ID:** `TASK-010`

**Título:** `TASK-010 — Fundación física mínima de AuditEvent`

**Tipo:** `PHYSICAL DATA FOUNDATION / SECURITY FOUNDATION`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`TASK-010-audit-event-foundation-approved.md`

**Ruta canónica futura:**

`docs/tasks/TASK-010-audit-event-foundation.md`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Implementación realizada:** `NO`

**Implementación concreta autorizada:** `NO`

**Codex autorizado:** `NO`

**Repositorio modificado:** `NO`

**Supabase Cloud modificado:** `NO`

**Git modificado:** `NO`

**Canonicalización realizada:** `NO`

**TASK-011 determinada:** `NO`

**TASK-011 generada:** `NO`

La aprobación documental establece:

```text
APPROVED FOR IMPLEMENTATION
!=
Codex autorizado ahora
```

y preserva la separación obligatoria:

```text
aprobación documental
!=
canonicalización realizada
!=
autorización humana concreta de ejecución
!=
operación remota Development
```

---

## 2. Objetivo único

TASK-010 define un incremento PR-sized cuyo único objetivo futuro será materializar la **foundation física mínima de `AuditEvent`**.

La tarea debe permitir disponer de una frontera persistente de auditoría que preserve:

- identidad histórica estable del evento;
- ownership tenant inequívoco;
- actor identificable;
- acción identificable;
- momento autoritativo;
- alcance mínimo estructurado;
- sujeto afectado cuando corresponda;
- datos históricos mínimos que no puedan reconstruirse correctamente desde relaciones vivas posteriores;
- RLS obligatoria;
- comportamiento append-only para operaciones normales;
- aislamiento cross-tenant verificable.

TASK-010 **NO implementa los flows que producen auditoría**.

Por tanto:

```text
AuditEvent foundation implementada
≠
alta de usuarios implementada
≠
disable/revoke implementado
≠
reintegración implementada
≠
cambio de role implementado
≠
UserClientAccess implementado
≠
SupportAccessGrant implementado
≠
auditoría funcional completa
```

La obligación de los futuros flows auditables continúa siendo:

```text
mutación o acceso sensible autorizado
→ AuditEvent correspondiente obligatorio
```

TASK-010 sólo prepara la persistencia necesaria para que los flows físicamente representables con las foundations actuales puedan cumplir posteriormente esa obligación sin rediseñar la frontera fundamental de auditoría.

Las obligaciones futuras cuya trazabilidad completa depende de entidades todavía inexistentes permanecen como requisitos de producto, pero **NO quedan habilitadas prematuramente como acciones físicamente persistibles por TASK-010**.

---

## 3. Fuentes de verdad revisadas

La especificación se deriva de la documentación canónica y del estado físico posterior a TASK-009/CORR-011.

Fuentes mínimas contrastadas:

### Product

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md`

La baseline conceptual define `AuditEvent` como evento histórico individual, tenant-owned cuando corresponde a un tenant, que debe identificar actor, empresa, acción, momento y alcance y que no puede eliminarse mediante operación normal.

La estrategia de seguridad mantiene RLS como frontera primaria para datos tenant-owned y aplica estrictamente:

> ausencia de permiso aprobado = no se infiere permiso.

### Architecture

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`

`ADR-0002` exige ownership tenant inequívoco, RLS, integridad cross-tenant, frontend no autoritativo y uso excepcional/restringido de `service-role`; además, `SUPER_ADMIN` no obtiene acceso tenant normal por su identidad global.

### Tasks y correcciones previas

- `docs/tasks/TASK-008-supabase-application-boundary.md`
- `docs/tasks/TASK-009-identity-tenant-foundation.md`
- `docs/tasks/CORR-010-task-008-closure-state-sync.md`
- `docs/tasks/CORR-011-task-009-closure-state-sync.md`

TASK-009 materializó exclusivamente:

```text
public.maintenance_companies
public.platform_users
public.platform_user_auth_subjects
public.company_memberships
```

con RLS habilitada, lecturas mínimas del propio sujeto/tenant y ausencia de escrituras normales para `authenticated`.

TASK-009 dejó expresamente pendiente `AuditEvent` y mantuvo que todo futuro flow de alta, disable/revoke, reintegración, cambio de rol o client scope deberá producir su auditoría obligatoria.

CORR-011 preserva como estado actual:

```text
Fase 0 = COMPLETADA
Fase 1 = COMPLETADA
Fase 2 = INICIADA

TASK-008 = COMPLETADA
TASK-009 = COMPLETADA

MaintenanceCompany físico = SÍ
PlatformUser físico = SÍ
Auth subject → PlatformUser físico = SÍ
CompanyMembership físico = SÍ

Auth funcional = NO
Authorization ready = NO
VerificationChallenge = NO
UserClientAccess = NO
SupportAccessGrant = NO
AuditEvent = NO
Client = NO
Storage = NO
Realtime = NO
Offline = NO
```

### Discovery read-only posterior al cierre de CORR-011

El discovery posterior verificó:

```text
branch = main
HEAD = eb9972407785d997fc8646106d79e6abd363f386
origin/main = eb9972407785d997fc8646106d79e6abd363f386
divergencia = 0 0
worktree = limpio
staged = ninguno
```

y confirmó que la única migration funcional existente continúa siendo TASK-009, que no existe TASK-010 física y que `AuditEvent` es un candidato PR-sized sin `OPEN` directo ni ADR nuevo requerido.

El mismo discovery determinó que `UserClientAccess` y `SupportAccessGrant` presentan dependencias reales con `Client`, mientras que una foundation mínima de `AuditEvent` depende sólo de foundations físicas ya existentes.

---

## 4. Revisión de contradicciones

### 4.1 Resultado

```text
contradicciones bloqueantes = 0
```

No se detecta contradicción material entre:

- el contrato obligatorio de auditoría;
- el modelo conceptual de `AuditEvent`;
- ADR-0001;
- ADR-0002;
- ADR-0003;
- el schema físico de TASK-009;
- el estado activo posterior a CORR-011;
- el discovery read-only posterior;
- la delimitación corregida entre obligaciones futuras de auditoría y acciones físicamente habilitadas por TASK-010.

### 4.2 Dependencias que no bloquean la foundation mínima

Actualmente no existen:

```text
Client
UserClientAccess
SupportAccessGrant
```

Esto **sí bloquea** la representación semánticamente completa de:

- qué clientes cambiaron en un evento `USER_CLIENT_ACCESS_CHANGED`;
- qué grant concreto fue concedido/modificado/revocado;
- qué clientes y scopes exactos componían un soporte excepcional;
- qué recurso client-scoped fue accedido mediante soporte.

Por tanto, TASK-010 **NO admite físicamente** esas acciones en su CHECK inicial.

TASK-010 debe resolver esa ausencia mediante delimitación de scope, no mediante:

- crear `Client`;
- crear `UserClientAccess`;
- crear `SupportAccessGrant`;
- almacenar UUID de `Client` sin FK;
- almacenar UUID de `SupportAccessGrant` inexistente;
- inventar JSON genérico;
- fingir integridad física inexistente.

Los futuros slices dependientes de esas entidades deberán extender la trazabilidad física de `AuditEvent` **antes de liberar sus flows**.

Regla obligatoria:

```text
obligación futura de auditar
!=
acción físicamente habilitada prematuramente
```

---

## 5. Baseline que TASK-010 debe preservar

Debe permanecer:

```text
Fase 0 = COMPLETADA
Fase 1 = COMPLETADA
Fase 2 = INICIADA

TASK-008 = COMPLETADA
TASK-009 = COMPLETADA
CORR-011 = COMPLETADA

Supabase application boundary = IMPLEMENTADA

MaintenanceCompany físico = SÍ
PlatformUser físico = SÍ
Auth subject → PlatformUser físico = SÍ
CompanyMembership físico = SÍ

RLS TASK-009 = IMPLEMENTADA Y PROBADA EN DEVELOPMENT
```

Debe continuar:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Authorization ready = NO
VerificationChallenge = NO
UserClientAccess = NO
SupportAccessGrant = NO
Client = NO
Storage = NO
Realtime = NO
Offline = NO
```

Una futura implementación correcta de TASK-010 podrá cambiar exclusivamente:

```text
AuditEvent físico = NO
```

a:

```text
AuditEvent foundation física = SÍ
```

No podrá declarar:

```text
auditoría funcional completa = SÍ
```

---

## 6. Contrato funcional de auditoría preservado

Como mínimo deben ser auditables en el producto:

1. alta de usuario;
2. deshabilitación/revocación;
3. reintegración;
4. cambio de rol;
5. cambio de clientes/permisos autorizados;
6. concesión de soporte a `SUPER_ADMIN`;
7. modificación del alcance de soporte;
8. revocación del soporte;
9. acceso excepcional efectivamente realizado por `SUPER_ADMIN`.

La baseline exige que el evento permita identificar al menos:

- actor;
- empresa afectada;
- acción;
- momento;
- alcance.

Cuando corresponda, el histórico también debe conservar suficiente trazabilidad de:

- cliente;
- scope de soporte;
- sujeto afectado;
- recurso.

### 6.1 Acciones físicamente habilitadas por TASK-010

Con las foundations físicas actuales, TASK-010 admite persistir exclusivamente:

```text
USER_CREATED
USER_DISABLED_OR_REVOKED
USER_REINSTATED
USER_ROLE_CHANGED
```

Estas cuatro acciones pueden representarse íntegramente mediante:

- tenant;
- actor;
- acción;
- momento;
- scope de usuario;
- sujeto `PlatformUser`;
- snapshot de role cuando corresponde.

### 6.2 Obligaciones futuras no físicamente habilitadas por TASK-010

Permanecen como obligaciones futuras de producto:

```text
USER_CLIENT_ACCESS_CHANGED
SUPPORT_ACCESS_GRANTED
SUPPORT_ACCESS_SCOPE_CHANGED
SUPPORT_ACCESS_REVOKED
SUPPORT_ACCESS_USED
```

TASK-010 **NO permite persistir filas con esas acciones**.

Los futuros slices que materialicen `Client`, `UserClientAccess` y/o `SupportAccessGrant` deberán extender `AuditEvent` con la trazabilidad íntegra requerida antes de liberar esos flows.

La obligación no convierte cada cambio del producto en un evento global.

Se preserva:

```text
Revision history != Audit log

AuditEvent != MaintenanceRevision
AuditEvent != FormVersion
AuditEvent != ReportVersion
AuditEvent != ReportSnapshot
AuditEvent != AICreditLedgerEntry
AuditEvent != PaymentEvent
```

No se adopta:

- event store global;
- replay global;
- proyecciones universales;
- event sourcing;
- toda mutación como evento;
- observability platform genérica.

---

## 7. Dominio de `AuditEvent`

### 7.1 Significado

`AuditEvent` representa un **hecho histórico de auditoría relativo a una acción sensible cuya trazabilidad ha sido requerida expresamente**.

No representa el estado vigente del dominio.

Un `AuditEvent` responde:

> ¿Qué acción sensible ocurrió, bajo qué tenant, quién fue su actor, cuándo ocurrió y cuál era el alcance histórico relevante?

No responde por sí mismo:

- cuál es el estado actual de una membership;
- cuál es el role actual;
- cuáles son actualmente los clientes autorizados;
- cuál es el grant de soporte vigente;
- cuál es la revisión actual de un mantenimiento;
- cuál es el saldo vigente de créditos;
- cuál es el estado vigente de un pago.

### 7.2 Ownership

Todo `AuditEvent` comprendido por TASK-010 es:

```text
tenant-owned
```

y pertenece directa e inequívocamente a exactamente una:

```text
MaintenanceCompany
```

`AuditEvent` no es un recurso global en esta foundation.

### 7.3 Identidad histórica

Cada evento posee identidad propia e independiente.

Dos acciones sensibles distintas:

```text
→ dos AuditEvent distintos
```

Una corrección posterior del dominio:

```text
≠ reescribir AuditEvent anterior
```

### 7.4 Lifecycle

El lifecycle físico mínimo es:

```text
creado de forma autoritativa
→ histórico
→ permanece histórico
```

No existe en TASK-010:

- draft;
- published;
- active;
- archived;
- cancelled;
- deleted;
- superseded;
- corrected;
- mutable state machine.

### 7.5 Mutabilidad

Una vez creado correctamente:

```text
normal UPDATE = DENIED
normal DELETE = DENIED
```

El evento no es una fila mutable de estado operativo.

### 7.6 Referencia viva vs snapshot histórico

TASK-010 distingue dos tipos de dato:

**Referencia estable físicamente existente**

Se utiliza cuando existe una entidad estable que debe seguir siendo identificable:

- `MaintenanceCompany`;
- `PlatformUser` actor;
- `PlatformUser` sujeto afectado.

Estas referencias se materializan mediante FK.

**Snapshot histórico**

Se utiliza cuando consultar el estado vivo posterior produciría una interpretación histórica incorrecta.

En TASK-010 el caso aprobado y materializable es:

- role anterior;
- role posterior;

para `USER_ROLE_CHANGED`.

El evento debe seguir indicando qué cambio de role ocurrió aunque la membership cambie nuevamente después.

No se utiliza JSON para ello.

---

## 8. Modelo físico propuesto

### 8.1 Única entidad nueva

Nombre conceptual:

`AuditEvent`

Nombre físico:

`public.audit_events`

TASK-010 no crea ninguna segunda entidad funcional.

### 8.2 Campos

| Campo | Tipo físico conceptual | Nullability | Responsabilidad |
|---|---|---:|---|
| `id` | `uuid` | `NOT NULL` | identidad histórica estable del evento |
| `maintenance_company_id` | `uuid` | `NOT NULL` | ownership tenant inequívoco |
| `actor_kind` | `text` restringido | `NOT NULL` | discrimina actor humano/plataforma de proceso interno |
| `actor_platform_user_id` | `uuid` | nullable | referencia al `PlatformUser` actor cuando `actor_kind = PLATFORM_USER` |
| `actor_internal_process_key` | `text` restringido | nullable | identidad histórica de proceso interno cuando no existe actor `PlatformUser` |
| `action` | `text` restringido | `NOT NULL` | código estable de la acción auditada físicamente representable |
| `occurred_at` | `timestamptz` | `NOT NULL` | momento autoritativo del evento |
| `scope_kind` | `text` restringido | `NOT NULL` | categoría estructurada del alcance físicamente representable |
| `subject_platform_user_id` | `uuid` | `NOT NULL` | sujeto `PlatformUser` afectado por las acciones admitidas por TASK-010 |
| `role_before` | `text` restringido | nullable | snapshot histórico del role anterior |
| `role_after` | `text` restringido | nullable | snapshot histórico del role posterior |

No se añaden otros campos en TASK-010.

---

## 9. Decisiones de cada campo

### 9.1 `id`

**Decisión:** UUID como PK.

Justificación:

- el dominio exige identidad histórica individual;
- es coherente con las foundations físicas existentes;
- permite referencias futuras estables;
- no implica correlación de requests ni event sourcing.

La migration no necesita introducir una obligación de idempotency key.

Como TASK-010 no implementa productor funcional, fixtures y futuros productores confiables pueden aportar la identidad dentro de su frontera controlada.

Un ID suministrado desde frontend:

```text
≠ autorización
≠ tenant
≠ actor
```

No se añade:

- `request_id`;
- `trace_id`;
- `correlation_id`;
- `operation_id`;
- `idempotency_key`.

Esas identidades sólo podrán añadirse cuando un flow concreto demuestre que son necesarias.

### 9.2 `maintenance_company_id`

**Decisión:** FK directa y obligatoria a:

```text
public.maintenance_companies(id)
```

Semántica:

```text
AuditEvent.maintenance_company_id
→ tenant afectado
```

No significa:

```text
request.maintenance_company_id
→ autoridad
```

El futuro productor deberá derivar el tenant desde identidad, ownership y contexto autoritativo de la operación.

### 9.3 `actor_kind`

Valores físicos permitidos:

```text
PLATFORM_USER
INTERNAL_PROCESS
```

Se utiliza `text + CHECK`.

No se crea:

- enum PostgreSQL global;
- actor catalog;
- configurable actor type table.

### 9.4 `actor_platform_user_id`

FK nullable a:

```text
public.platform_users(id)
```

Debe estar presente exclusivamente cuando:

```text
actor_kind = PLATFORM_USER
```

Una request iniciada por un usuario autenticado conserva como actor al `PlatformUser` autoritativamente resuelto.

El hecho de que código server-side ejecute técnicamente la operación:

```text
≠ convertir actor en INTERNAL_PROCESS
```

si existe un usuario responsable de la intención.

### 9.5 `actor_internal_process_key`

Se utiliza únicamente cuando la acción es genuinamente originada por un proceso interno sin `PlatformUser` responsable.

Debe ser:

- no nulo en ese caso;
- no vacío;
- estable;
- definido por código confiable;
- no recibido como autoridad desde browser/PWA.

No representa:

- nombre visible libre;
- email;
- UUID falso;
- `PlatformUser` sintético;
- configurable process catalog.

No existe actualmente un productor funcional que utilice esta variante.

La columna únicamente preserva una representación correcta de la categoría cuando un caso aprobado la necesite en el futuro.

### 9.6 Constraint XOR del actor

Debe ser físicamente imposible persistir:

```text
PLATFORM_USER + actor_platform_user_id NULL
```

o:

```text
PLATFORM_USER + actor_internal_process_key presente
```

o:

```text
INTERNAL_PROCESS + actor_platform_user_id presente
```

o:

```text
INTERNAL_PROCESS + actor_internal_process_key NULL/vacío
```

La regla física es conceptualmente:

```text
exactamente una representación de actor válida
```

### 9.7 `action`

Se adopta:

```text
text + CHECK
```

en lugar de:

- PostgreSQL enum;
- tabla catálogo;
- texto arbitrario sin validación.

Valores físicos iniciales admitidos por TASK-010:

```text
USER_CREATED
USER_DISABLED_OR_REVOKED
USER_REINSTATED
USER_ROLE_CHANGED
```

No son valores físicamente admitidos por TASK-010:

```text
USER_CLIENT_ACCESS_CHANGED
SUPPORT_ACCESS_GRANTED
SUPPORT_ACCESS_SCOPE_CHANGED
SUPPORT_ACCESS_REVOKED
SUPPORT_ACCESS_USED
```

Estas cinco acciones permanecen como **obligaciones futuras de auditoría** y deberán incorporarse mediante extensiones futuras de `AuditEvent` sólo cuando puedan preservarse íntegramente sus referencias y alcance histórico.

Regla:

```text
obligación futura de auditar
!=
valor físico habilitado en TASK-010
```

Una futura nueva acción físicamente representable:

```text
→ migration revisada que amplíe el CHECK
```

No:

```text
→ insertar un nombre nuevo arbitrario desde UI
```

Esto permite evolución explícita sin crear una feature de catálogo configurable.

### 9.8 `occurred_at`

Debe representar el momento autoritativo del evento.

Decisión:

```text
timestamptz NOT NULL
+
DEFAULT derivado por PostgreSQL
```

La garantía de TASK-010 es deliberadamente limitada y precisa:

- TASK-010 no posee INSERT funcional de aplicación;
- ningún frontend/caller obtiene autoridad para definir `occurred_at`;
- los fixtures de test deben preferir el `DEFAULT`, salvo que un test concreto necesite controlar expresamente el timestamp para verificar una propiedad;
- todo futuro productor funcional deberá obtener o derivar el momento desde su frontera confiable y no aceptar como autoridad un timestamp del browser/PWA;
- el `DEFAULT` por sí solo **NO** se interpreta como garantía de que un escritor privilegiado no pueda suministrar explícitamente otro valor;
- TASK-010 no introduce trigger, RPC ni `SECURITY DEFINER` sólo para volver `occurred_at` físicamente no-overridable.

No debe confiarse en:

- reloj del navegador;
- timestamp enviado por frontend como autoridad;
- timezone local del usuario;
- `updated_at` de otra entidad.

TASK-010 no añade:

- `created_at`;
- `updated_at`;
- `deleted_at`.

`occurred_at` satisface el requisito temporal del evento.

`updated_at` sería incompatible con la semántica inmutable.

`deleted_at` introduciría un lifecycle de eliminación no aprobado.

### 9.9 `scope_kind`

Se adopta:

```text
text + CHECK
```

con un único valor físicamente representable por TASK-010:

```text
USER
```

Mapeo obligatorio:

| `action` | `scope_kind` |
|---|---|
| `USER_CREATED` | `USER` |
| `USER_DISABLED_OR_REVOKED` | `USER` |
| `USER_REINSTATED` | `USER` |
| `USER_ROLE_CHANGED` | `USER` |

Debe existir un CHECK que impida cualquier combinación action/scope incompatible.

TASK-010 no admite todavía:

```text
USER_CLIENT_ACCESS
SUPPORT_GRANT
SUPPORT_ACCESS
```

como valores físicos de `scope_kind`, porque hacerlo permitiría persistir eventos cuyo alcance histórico requerido todavía no puede representarse íntegramente.

### 9.10 `subject_platform_user_id`

FK obligatoria a:

```text
public.platform_users(id)
```

Debe estar presente para las cuatro acciones admitidas por TASK-010:

```text
USER_CREATED
USER_DISABLED_OR_REVOKED
USER_REINSTATED
USER_ROLE_CHANGED
```

Identifica el usuario afectado.

No se habilitan en TASK-010 reglas de sujeto para:

```text
USER_CLIENT_ACCESS_CHANGED
SUPPORT_ACCESS_GRANTED
SUPPORT_ACCESS_SCOPE_CHANGED
SUPPORT_ACCESS_REVOKED
SUPPORT_ACCESS_USED
```

porque esas acciones no son físicamente persistibles en esta foundation.

### 9.11 `role_before` y `role_after`

Sólo se utilizan para:

```text
USER_ROLE_CHANGED
```

Valores permitidos:

```text
COMPANY_ADMIN
TECHNICIAN
```

Para `USER_ROLE_CHANGED`:

```text
role_before IS NOT NULL
role_after IS NOT NULL
role_before != role_after
```

Para las otras tres acciones admitidas:

```text
role_before IS NULL
role_after IS NULL
```

Justificación:

consultar posteriormente `CompanyMembership.role` sólo mostraría el role actual y destruiría el significado histórico del cambio.

Estos campos son snapshots históricos intencionales.

No son una copia general de `CompanyMembership`.

---

## 10. FK y comportamiento `ON DELETE`

### 10.1 FK obligatorias ahora

TASK-010 utiliza exclusivamente entidades que físicamente existen:

```text
audit_events.maintenance_company_id
→ maintenance_companies.id

audit_events.actor_platform_user_id
→ platform_users.id

audit_events.subject_platform_user_id
→ platform_users.id
```

### 10.2 `ON DELETE`

Las tres relaciones deben utilizar semántica:

```text
ON DELETE RESTRICT
```

Motivo:

- borrar un tenant referenciado no puede destruir auditoría;
- borrar un actor referenciado no puede destruir su trazabilidad;
- borrar un sujeto referenciado no puede volver anónimo un evento histórico;
- la baseline ya preserva identidad/historia ante disable/revoke.

No se permite:

```text
ON DELETE CASCADE
```

para estas relaciones.

No se utiliza:

```text
ON DELETE SET NULL
```

porque eliminaría identidad histórica del actor/sujeto.

### 10.3 Referencias que NO existen todavía

TASK-010 no crea columnas físicas para:

```text
client_id
user_client_access_id
support_access_grant_id
location_id
equipment_id
maintenance_record_id
maintenance_revision_id
report_id
resource_id genérico
```

cuando la entidad requerida todavía no forma parte del slice o cuando una relación polimórfica no podría preservar integridad.

En particular:

```text
Client = NO
SupportAccessGrant = NO
UserClientAccess = NO
```

por lo que no deben existir UUID huérfanos que pretendan representar esas relaciones.

---

## 11. Alcance histórico y evolución futura

### 11.1 Lo que TASK-010 puede preservar completamente

Con las entidades físicas actuales, la foundation permite expresar de manera íntegra para las cuatro acciones admitidas:

- tenant afectado;
- actor `PlatformUser`;
- actor interno;
- acción;
- momento;
- sujeto `PlatformUser`;
- scope `USER`;
- role anterior/posterior cuando cambia un role.

### 11.2 `USER_CLIENT_ACCESS_CHANGED`

Permanece como obligación futura de auditoría.

Actualmente:

```text
Client físico = NO
UserClientAccess físico = NO
```

Por tanto TASK-010 no puede registrar de forma referencialmente íntegra qué clientes fueron añadidos o retirados.

Consecuencia física:

```text
USER_CLIENT_ACCESS_CHANGED
→ NO admitido por CHECK de action en TASK-010
```

Regla:

> Un futuro slice que implemente `Client`/`UserClientAccess` deberá extender `AuditEvent` con el alcance histórico exacto requerido antes de liberar el flow `USER_CLIENT_ACCESS_CHANGED`.

### 11.3 Support

Permanecen como obligaciones futuras:

```text
SUPPORT_ACCESS_GRANTED
SUPPORT_ACCESS_SCOPE_CHANGED
SUPPORT_ACCESS_REVOKED
SUPPORT_ACCESS_USED
```

TASK-010 no puede representar todavía íntegramente:

- `SupportAccessGrant` concreto;
- clientes del grant;
- scopes client-scoped;
- scopes tenant-wide efectivos del grant;
- recurso concreto accedido.

Consecuencia física:

```text
SUPPORT_ACCESS_GRANTED
SUPPORT_ACCESS_SCOPE_CHANGED
SUPPORT_ACCESS_REVOKED
SUPPORT_ACCESS_USED
→ NO admitidos por CHECK de action en TASK-010
```

Antes de liberar esos flows debe existir la extensión física necesaria de `AuditEvent`.

### 11.4 Evolución sin rediseño fundamental

Las extensiones posteriores deberán preservar:

```text
AuditEvent.id
AuditEvent.tenant
AuditEvent.actor
AuditEvent.action
AuditEvent.occurred_at
```

y podrán añadir trazabilidad referencial/histórica específica cuando existan:

- `Client`;
- `UserClientAccess`;
- `SupportAccessGrant`;
- otros recursos concretos aprobados.

TASK-010 no decide anticipadamente si esas extensiones utilizarán:

- FK adicional;
- relación subordinada específica;
- snapshot histórico estructurado.

Esa decisión debe tomarse con las entidades reales disponibles y sus requisitos definitivos.

---

## 12. Decisión sobre JSON / JSONB

TASK-010 no introduce:

```text
json
jsonb
metadata
payload
details
context
```

Motivo:

1. los datos necesarios ahora pueden modelarse mediante columnas y FK reales;
2. `Client` y `SupportAccessGrant` todavía no existen;
3. JSON con IDs de entidades inexistentes ocultaría la ausencia de integridad;
4. un objeto libre convertiría `AuditEvent` en una bolsa arbitraria;
5. no existe requisito aprobado para almacenar payload completo de requests o cambios;
6. no existe event sourcing.

Si una futura necesidad histórica requiere un snapshot JSON/JSONB:

```text
→ nueva especificación
→ shape exacto
→ validación exacta
→ finalidad histórica explícita
→ prohibición de usarlo como autoridad
```

TASK-010 no adelanta esa decisión.

---

## 13. Actor real y autoridad

### 13.1 Regla central

```text
actor != campo libre confiado al frontend
```

### 13.2 Actor autenticado

Un futuro flow iniciado por usuario deberá seguir conceptualmente:

```text
Auth subject autenticado
→ PlatformUser autoritativamente resuelto
→ autorización vigente
→ actor_platform_user_id
```

El caller no selecciona libremente:

```text
actor_platform_user_id
```

### 13.3 Proceso interno

Sólo se utilizará:

```text
actor_kind = INTERNAL_PROCESS
```

si realmente no existe un usuario responsable de la acción.

Un Route Handler, Server Action o servidor que ejecuta código en nombre de un usuario:

```text
≠ INTERNAL_PROCESS
```

por el mero hecho de ser server-side.

### 13.4 No fake users

Queda prohibido:

- crear `PlatformUser` falso para cron/job/proceso;
- crear `CompanyMembership` falsa para proceso;
- usar email ficticio;
- utilizar UUID reservado como pseudoactor.

### 13.5 Enforcement de TASK-010

TASK-010 preserva la integridad del actor mediante:

- discriminador `actor_kind`;
- XOR físico de las dos representaciones;
- FK cuando el actor es `PlatformUser`;
- proceso interno no vacío cuando corresponde;
- ausencia de INSERT normal para callers.

La autorización real del actor pertenece al futuro flow productor y no se reemplaza con una FK.

---

## 14. Multitenancy

### 14.1 Frontera tenant

```text
tenant = MaintenanceCompany
```

### 14.2 Ownership directo

Cada evento posee:

```text
maintenance_company_id NOT NULL
→ maintenance_companies.id
```

No existe evento tenant de TASK-010 sin tenant.

### 14.3 Caller no autoritativo

Queda prohibido el patrón:

```text
browser sends maintenance_company_id
→ server trusts it
→ AuditEvent created
```

El futuro productor debe derivar el tenant desde el recurso/operación y estado autoritativo aplicable.

### 14.4 Cross-tenant

Debe demostrarse a nivel de datos que:

```text
Tenant A
→ no puede observar AuditEvent de Tenant B
→ no puede modificar AuditEvent de Tenant B
→ no puede eliminar AuditEvent de Tenant B
→ no puede crear AuditEvent atribuyéndolo a Tenant B
```

Con TASK-010 la política es incluso más restrictiva:

```text
authenticated normal
→ no obtiene lectura funcional de AuditEvent
→ no obtiene escritura funcional de AuditEvent
```

---

## 15. RLS y autorización

### 15.1 RLS

La migration debe:

```text
ENABLE ROW LEVEL SECURITY
```

sobre:

```text
public.audit_events
```

### 15.2 Lectura

La revisión de baseline no identifica un permiso normal explícito para consultar el audit log.

El modelo exige que los eventos existan y sean trazables, pero no concede por sí mismo una operación de consulta a `COMPANY_ADMIN`, `TECHNICIAN` o `SUPER_ADMIN`.

Por tanto:

```text
SELECT policy funcional = NO
```

TASK-010 no crea UI ni API de consulta.

### 15.3 INSERT

No existe autorización general equivalente a:

```text
authenticated
→ INSERT audit_events
```

Que un usuario sea actor de la acción auditada:

```text
≠ permiso para redactar su propio AuditEvent
```

Por tanto:

```text
INSERT policy authenticated = NO
```

### 15.4 UPDATE

Un evento histórico no debe reescribirse mediante operación normal.

Por tanto:

```text
UPDATE policy = NO
```

### 15.5 DELETE

La baseline exige no eliminación por operación normal.

Por tanto:

```text
DELETE policy = NO
```

### 15.6 Cierre exhaustivo de privilegios de tabla

Estado obligatorio:

```text
anon
→ cero privilegios de tabla sobre public.audit_events

authenticated
→ cero privilegios de tabla sobre public.audit_events
```

La futura migration debe aplicar semántica equivalente a **revocar todos los privilegios de tabla** sobre `public.audit_events` para ambos roles, siguiendo el patrón ya utilizado por TASK-009.

No es suficiente revocar únicamente CRUD.

La regla debe cubrir expresamente, como mínimo:

```text
SELECT = NO
INSERT = NO
UPDATE = NO
DELETE = NO
TRUNCATE = NO
REFERENCES = NO
TRIGGER = NO
```

La semántica requerida es:

```text
ALL TABLE PRIVILEGES para anon = NONE
ALL TABLE PRIVILEGES para authenticated = NONE
```

Esto incluye cualquier privilegio lateral de tabla heredado/default que pudiera existir, no sólo los siete privilegios enumerados como casos explícitos.

Después del cierre inicial:

```text
GRANT posterior a anon sobre audit_events = NINGUNO
GRANT posterior a authenticated sobre audit_events = NINGUNO
```

TASK-010 no introduce ningún grant alternativo para esos roles.

### 15.7 RLS habilitada vs policies autorizadas

Resultado deliberado:

```text
RLS = ENABLED

application SELECT policies = 0
application INSERT policies = 0
application UPDATE policies = 0
application DELETE policies = 0
```

No se crea ninguna policy para `TRUNCATE`.

Regla de seguridad obligatoria:

```text
RLS
!=
protección frente a TRUNCATE
```

`TRUNCATE` no depende de una policy RLS fila a fila. En TASK-010, su denegación deriva de que `anon` y `authenticated` poseen **cero privilegios de tabla** sobre `public.audit_events`, incluido el privilegio `TRUNCATE`.

RLS sigue siendo obligatoria como frontera primaria para futuras operaciones row-level que una tarea posterior autorice expresamente.

Esto no significa que RLS sea innecesaria.

Significa que la tabla nace fail-closed y que cualquier futura apertura deberá requerir una tarea que defina explícitamente:

- actor;
- operación;
- ownership;
- tenant;
- autorización;
- privilegios de tabla necesarios;
- policies row-level necesarias cuando correspondan;
- pruebas negativas.

---

## 16. Frontera futura de escritura

TASK-010 no implementa productor.

No crea:

- Server Action;
- Route Handler;
- API;
- repository funcional;
- RPC;
- trigger;
- `SECURITY DEFINER`;
- generic audit service privilegiado;
- write policy `authenticated`;
- `service-role` ordinario.

### 16.1 Regla futura

Cuando una mutación de dominio requiera auditoría, la operación futura deberá asegurar conceptualmente:

```text
autorización vigente
+
tenant autoritativo
+
actor autoritativo
+
momento derivado desde frontera confiable
+
mutación válida
+
AuditEvent válido
```

### 16.2 Atomicidad

Cuando el evento auditado describe una mutación de estado, el diseño del flow deberá garantizar que la mutación y su auditoría no puedan quedar silenciosamente desincronizadas.

La propiedad requerida es:

```text
mutación autoritativa confirmada
→ AuditEvent correspondiente confirmado
```

preferentemente dentro de la misma frontera transaccional cuando la operación concreta lo permita.

TASK-010 no selecciona prematuramente:

- RPC;
- database function;
- transaction adapter;
- server-side driver;
- trigger.

Si un futuro flow necesita introducir una frontera privilegiada nueva para lograr atomicidad:

```text
→ revisión específica de ese flow
```

No se justifica introducirla en la foundation vacía.

### 16.3 `service-role`

No se adopta:

```text
service-role
→ escritor ordinario del audit log
```

`service-role` permanece excepcional/restringido conforme a ADR-0002.

### 16.4 Test setup

Fixtures SQL controladas ejecutadas mediante un rol administrativo de test pueden crear y eliminar eventos para verificar constraints.

Esas operaciones:

```text
= test setup / teardown
≠ flow de producto
≠ autorización funcional
```

Los fixtures deben preferir el `DEFAULT` de `occurred_at`, salvo que un test concreto necesite un valor controlado.

---

## 17. Inmutabilidad

### 17.1 Semántica

Una vez persistido:

```text
AuditEvent
→ no posee edición normal
→ no posee eliminación normal
→ no admite vaciado normal de tabla
```

Por tanto:

```text
UPDATE normal = DENIED
DELETE normal = DENIED
TRUNCATE normal = DENIED
```

### 17.2 Enforcement físico de la foundation

Se protege mediante controles complementarios:

1. `anon` y `authenticated` poseen cero privilegios de tabla sobre `public.audit_events`, incluidos UPDATE, DELETE y TRUNCATE;
2. no existen policies RLS de UPDATE/DELETE;
3. RLS permanece habilitada para el enforcement row-level futuro, pero no se presenta como protección frente a TRUNCATE.

Debe verificarse mediante intentos reales en Supabase Cloud Development.

No basta comprobar que un UPDATE o DELETE afecta cero filas, ni que la tabla ya estaba vacía antes de intentar TRUNCATE.

Los tests deben distinguir:

```text
operación realmente denegada por falta de privilegio/autorización
```

de:

```text
operación técnicamente permitida sin efecto observable
```

### 17.3 Alcance de la garantía

TASK-010 garantiza:

```text
no modificación/eliminación/vaciado mediante operación normal de aplicación
```

No pretende convertir PostgreSQL en un sistema criptográficamente tamper-proof frente al owner administrativo de la base.

No introduce para ello:

- trigger anti-update;
- trigger anti-delete;
- WORM storage;
- firma criptográfica;
- hash chain;
- append-only extension;
- ledger blockchain;
- rol administrativo nuevo.

No existe requisito aprobado que justifique esas capacidades.

### 17.4 Retención

TASK-010 no define:

- duración;
- purge;
- expiración;
- eliminación legal;
- archival storage.

`DO-T07` continúa diferido y no se resuelve mediante esta tarea.

---

## 18. Seguridad

Debe preservarse:

```text
authenticated != authorized

current authoritative authorization
>
stale JWT / stale claims / stale client state

RLS = frontera primaria para tenant-owned

fail closed

service-role = excepcional/restringido

SUPER_ADMIN normal
!=
acceso tenant
```

TASK-010 no puede:

- crear acceso tenant para `SUPER_ADMIN`;
- crear `CompanyMembership` para `SUPER_ADMIN`;
- interpretar ausencia de membership como super admin;
- crear global role;
- crear `SupportAccessGrant`;
- habilitar soporte;
- ampliar capabilities de `COMPANY_ADMIN`;
- ampliar capabilities de `TECHNICIAN`;
- utilizar auditoría como bypass de autorización.

Un `AuditEvent` tampoco es fuente de autorización.

```text
existencia de AuditEvent
≠ permiso vigente
```

---

## 19. UI

```text
UI = NO APLICA PARA TASK-010
```

No se crea:

- página de auditoría;
- tabla;
- timeline;
- filtros;
- búsqueda;
- export;
- dashboard;
- navegación;
- componentes React;
- route de audit log.

La baseline no concede todavía una operación funcional de lectura, por lo que diseñar una UI de auditoría adelantaría permisos no aprobados.

---

## 20. Offline

```text
Offline = NO APLICA PARA TASK-010
```

TASK-010 no modifica:

```text
ADR-0004
DO-T04
OFF-OPEN-001
OFF-OPEN-002
FORM-OPEN-004
```

No crea:

- Dexie table;
- LocalReplica;
- outbox;
- SyncOperation;
- sync de AuditEvent;
- Service Worker;
- cache local;
- offline audit viewer.

### 20.1 Futuros flows offline

Si una futura operación iniciada offline requiere auditoría, la relación entre:

- intención local;
- sincronización;
- autorización revalidada;
- mutación autoritativa;
- momento del AuditEvent;
- idempotencia;

deberá especificarse junto con ese flow y con la estrategia offline vigente.

TASK-010 no resuelve ese problema anticipadamente.

---

## 21. Alcance exacto de futura implementación

La futura implementación de TASK-010 queda limitada a:

1. una migration funcional versionada;
2. creación de `public.audit_events`;
3. campos definidos en §8;
4. PK;
5. tres FK permitidas;
6. `ON DELETE RESTRICT`;
7. CHECKs de actor;
8. CHECK físico de `action` limitado a las cuatro acciones representables;
9. CHECK físico de `scope_kind` limitado a `USER`;
10. CHECK action/scope;
11. CHECK de sujeto obligatorio;
12. CHECK de role snapshot;
13. RLS habilitada;
14. cierre exhaustivo de todos los privilegios de tabla de `anon`/`authenticated` sobre `public.audit_events`;
15. ausencia de cualquier GRANT posterior sobre `public.audit_events` para `anon`/`authenticated`;
16. cero policies funcionales de aplicación;
17. prueba SQL reproducible de integridad/RLS/inmutabilidad, incluyendo denegación real de TRUNCATE, para ejecutar en Supabase Cloud Development;
18. test estático reproducible y obligatorio de la migration;
19. documentación estrictamente necesaria de ejecución/revisión de la propia tarea.

### 21.1 Archivos futuros esperados

La futura implementación debe incluir exactamente las superficies equivalentes a:

```text
supabase/migrations/<timestamp>_task_010_audit_event_foundation.sql

supabase/tests/database/task_010_audit_event_foundation.test.sql

tests/task-010-migration.test.ts
```

`tests/task-010-migration.test.ts` es **obligatorio**.

Debe complementar, no sustituir:

- tests PostgreSQL de integridad;
- tests RLS;
- tests de inmutabilidad;

que se ejecutarán contra Supabase Cloud Development después de autorización humana y aplicación de la migration.

No se modifica aplicación Next.js para completar TASK-010.

### 21.2 Entidades nuevas

```text
entidades funcionales nuevas = 1
```

Exclusivamente:

```text
AuditEvent
```

---

## 22. Migration y schema

### 22.1 Cantidad

Objetivo:

```text
1 migration funcional
```

Si la implementation necesitara más de una migration por una razón no meramente mecánica:

```text
BLOCKER / revisión de scope
```

### 22.2 Nombre semántico

Sufijo esperado:

```text
task_010_audit_event_foundation
```

El timestamp real se determina al ejecutar.

### 22.3 Fuente de verdad

Después de una futura incorporación aprobada:

```text
migration Git
=
fuente de verdad del schema de TASK-010
```

No se crean objetos manualmente en Dashboard como sustituto de la migration.

### 22.4 PK

```text
audit_events.id
→ UUID PK
```

No existe otra clave candidata necesaria.

### 22.5 FK

Exclusivamente:

```text
maintenance_company_id
→ maintenance_companies.id
→ RESTRICT

actor_platform_user_id
→ platform_users.id
→ RESTRICT

subject_platform_user_id
→ platform_users.id
→ RESTRICT
```

### 22.6 UNIQUE

No se añade ninguna constraint `UNIQUE` adicional.

No existe requisito que prohíba:

- dos eventos de igual acción;
- dos eventos del mismo actor;
- dos eventos en el mismo instante;
- múltiples eventos sobre el mismo sujeto.

La PK ya garantiza identidad.

### 22.7 Índices

Índices adicionales requeridos por TASK-010:

```text
0
```

La PK crea su índice correspondiente.

No se añaden índices sobre:

- tenant;
- actor;
- action;
- `occurred_at`;
- subject;

porque TASK-010 no autoriza consultas funcionales y no existe workload aprobado que los justifique.

Los futuros patrones de consulta/RLS podrán añadir índices con evidencia real.

### 22.8 Defaults

Único default funcionalmente justificado:

```text
occurred_at
→ timestamptz NOT NULL
→ DEFAULT derivado por PostgreSQL
```

La existencia del `DEFAULT` no se interpreta como prohibición física absoluta de override por un escritor privilegiado.

TASK-010 garantiza que:

- no existe INSERT funcional de aplicación;
- ningún frontend/caller posee autoridad para suministrar el timestamp;
- futuros productores confiables deberán derivar/obtener el momento desde su frontera de confianza;
- no se crea trigger/RPC/`SECURITY DEFINER` para impedir override privilegiado.

No se añaden defaults de negocio a:

- tenant;
- actor;
- action;
- scope;
- subject;
- roles.

### 22.9 Mutabilidad

```text
INSERT normal = no autorizado
SELECT normal = no autorizado
UPDATE normal = no autorizado
DELETE normal = no autorizado
TRUNCATE normal = no autorizado
```

La tabla queda preparada para futuras escrituras confiables explícitamente diseñadas.

---

## 23. CHECKs mínimos obligatorios

La migration futura debe materializar checks equivalentes a:

### 23.1 Actor

```text
actor_kind ∈ {
  PLATFORM_USER,
  INTERNAL_PROCESS
}
```

y exactamente una representación válida conforme a §9.6.

### 23.2 Action

El CHECK físico inicial admite exclusivamente:

```text
action ∈ {
  USER_CREATED,
  USER_DISABLED_OR_REVOKED,
  USER_REINSTATED,
  USER_ROLE_CHANGED
}
```

Debe rechazar, entre otros, los valores todavía reservados como obligaciones futuras:

```text
USER_CLIENT_ACCESS_CHANGED
SUPPORT_ACCESS_GRANTED
SUPPORT_ACCESS_SCOPE_CHANGED
SUPPORT_ACCESS_REVOKED
SUPPORT_ACCESS_USED
```

### 23.3 Scope

El CHECK físico inicial admite exclusivamente:

```text
scope_kind = USER
```

No admite todavía:

```text
USER_CLIENT_ACCESS
SUPPORT_GRANT
SUPPORT_ACCESS
```

### 23.4 Action/scope consistency

Las cuatro acciones físicamente habilitadas por TASK-010 requieren:

```text
scope_kind = USER
```

Cualquier otra combinación debe ser rechazada.

### 23.5 Subject

Para toda fila válida de TASK-010:

```text
subject_platform_user_id IS NOT NULL
```

y debe referenciar un `PlatformUser` existente.

### 23.6 Role snapshots

Si:

```text
action = USER_ROLE_CHANGED
```

entonces:

```text
role_before ∈ {COMPANY_ADMIN, TECHNICIAN}
role_after ∈ {COMPANY_ADMIN, TECHNICIAN}
role_before != role_after
```

En cualquier otra acción admitida:

```text
role_before = NULL
role_after = NULL
```

---

## 24. Datos expresamente no incluidos

No se agregan:

- `created_at`;
- `updated_at`;
- `deleted_at`;
- `created_by`;
- `updated_by`;
- `ip`;
- `user_agent`;
- `device_id`;
- `session_id`;
- `request_id`;
- `trace_id`;
- `correlation_id`;
- `idempotency_key`;
- `provider`;
- `provider_metadata`;
- `metadata`;
- `payload`;
- `details`;
- `json`;
- `jsonb`;
- texto descriptivo libre;
- message;
- reason;
- diff genérico;
- old_value/new_value genéricos.

Ninguno es necesario para cumplir la foundation aprobada.

---

## 25. Pruebas futuras

Las pruebas deben ser reproducibles y utilizar exclusivamente fixtures descartables de Development.

No deben utilizar datos reales.

Se distinguen dos capas de validación:

```text
LOCAL
→ lint/typecheck/test generales cuando correspondan
→ Vitest estático obligatorio de migration
→ git diff/check
→ inspección de artefactos

SUPABASE CLOUD DEVELOPMENT
→ aplicación de migration después de autorización humana
→ tests PostgreSQL de integridad
→ tests RLS
→ tests de inmutabilidad
→ cleanup
→ migration list
```

TASK-010 no exige una base PostgreSQL/Supabase local.

Docker y Supabase local no forman parte del workflow aprobado.

### 25.1 Integridad tenant — Supabase Cloud Development

**T010-DB-001**

Un `AuditEvent` con `maintenance_company_id` inexistente:

```text
→ FK rejection
```

**T010-DB-002**

Un tenant referenciado por un `AuditEvent` no puede eliminarse mediante cascada.

### 25.2 Actor — Supabase Cloud Development

**T010-DB-003**

`PLATFORM_USER` con actor existente:

```text
→ estructura válida
```

**T010-DB-004**

`PLATFORM_USER` con actor inexistente:

```text
→ FK rejection
```

**T010-DB-005**

`PLATFORM_USER` sin `actor_platform_user_id`:

```text
→ CHECK rejection
```

**T010-DB-006**

`INTERNAL_PROCESS` sin key válida:

```text
→ CHECK rejection
```

**T010-DB-007**

Actor con ambas representaciones simultáneas:

```text
→ CHECK rejection
```

**T010-DB-008**

Un `PlatformUser` referenciado como actor no puede borrarse mediante cascade/set-null.

### 25.3 Action/scope — Supabase Cloud Development

**T010-DB-009**

Action arbitraria fuera del catálogo físico:

```text
→ CHECK rejection
```

**T010-DB-010**

Cada una de las acciones futuras todavía no habilitadas:

```text
USER_CLIENT_ACCESS_CHANGED
SUPPORT_ACCESS_GRANTED
SUPPORT_ACCESS_SCOPE_CHANGED
SUPPORT_ACCESS_REVOKED
SUPPORT_ACCESS_USED
```

debe producir:

```text
→ CHECK rejection
```

**T010-DB-011**

`scope_kind` distinto de `USER`:

```text
→ CHECK rejection
```

**T010-DB-012**

Combinación incompatible entre una acción admitida y un scope distinto de `USER`:

```text
→ CHECK rejection
```

### 25.4 Subject — Supabase Cloud Development

**T010-DB-013**

Una acción admitida sin sujeto:

```text
→ NOT NULL / constraint rejection
```

**T010-DB-014**

Sujeto inexistente:

```text
→ FK rejection
```

### 25.5 Role history — Supabase Cloud Development

**T010-DB-015**

`USER_ROLE_CHANGED` con `role_before`/`role_after` válidos y distintos:

```text
→ accepted fixture
```

**T010-DB-016**

Role inválido:

```text
→ CHECK rejection
```

**T010-DB-017**

Role anterior = role posterior:

```text
→ CHECK rejection
```

**T010-DB-018**

Role snapshot presente en `USER_CREATED`, `USER_DISABLED_OR_REVOKED` o `USER_REINSTATED`:

```text
→ CHECK rejection
```

### 25.6 Event identity — Supabase Cloud Development

**T010-DB-019**

Duplicar la misma PK:

```text
→ PK rejection
```

Demuestra identidad estable sin introducir idempotency key.

### 25.7 `occurred_at` — Supabase Cloud Development

**T010-DB-020**

Una fixture creada sin suministrar `occurred_at`:

```text
→ obtiene valor mediante DEFAULT de PostgreSQL
```

**T010-DB-021**

Los tests no deben interpretar el `DEFAULT` como garantía de no-overridable frente a un escritor privilegiado.

La ausencia de INSERT funcional y la futura derivación desde frontera confiable constituyen la garantía de autoridad de TASK-010.

### 25.8 RLS y permisos — Supabase Cloud Development

Preparar:

```text
Tenant A
Tenant B
User A
User B
AuditEvent A
AuditEvent B
```

mediante setup privilegiado exclusivamente de test.

Después ejecutar como `authenticated`.

**T010-RLS-001**

Tenant A conoce ID de evento B e intenta SELECT:

```text
→ DENIED
```

**T010-RLS-002**

Tenant B conoce ID de evento A:

```text
→ DENIED
```

**T010-RLS-003**

Authenticated intenta INSERT con su tenant real:

```text
→ DENIED
```

**T010-RLS-004**

Authenticated intenta INSERT con `maintenance_company_id` forjado de otro tenant:

```text
→ DENIED
```

Esto demuestra:

```text
caller maintenance_company_id
≠ autoridad
```

**T010-RLS-005**

Authenticated intenta UPDATE:

```text
→ DENIED
```

**T010-RLS-006**

Authenticated intenta DELETE:

```text
→ DENIED
```

El test debe fallar si la sentencia fue autorizada incluso cuando afecte cero filas.

### 25.9 `COMPANY_ADMIN` — Supabase Cloud Development

**T010-RLS-007**

Una membership habilitada `COMPANY_ADMIN`:

```text
→ no adquiere DELETE sobre AuditEvent
```

**T010-RLS-008**

La misma identidad:

```text
→ no adquiere UPDATE
→ no adquiere INSERT directo
→ no adquiere SELECT funcional
```

TASK-010 no interpreta “administra usuarios” como permiso sobre la tabla de auditoría.

### 25.10 Membership disabled — Supabase Cloud Development

**T010-RLS-009**

Un Auth subject reconocido cuyo `CompanyMembership.is_enabled` pase a `false`:

```text
→ no adquiere ninguna capacidad sobre audit_events
```

Un JWT técnicamente válido no altera ese resultado.

**T010-RLS-010**

GIVEN role `authenticated`  
WHEN attempting `TRUNCATE` sobre `public.audit_events`  
THEN la operación debe ser rechazada por privilegio insuficiente.

La evidencia válida es una denegación real de la operación.

No se acepta como evidencia:

- tabla ya vacía;
- `0 rows`;
- filtrado RLS;
- ausencia casual de datos observables.

No es necesario ni está permitido introducir un `TRUNCATE` exitoso como parte de la prueba.

### 25.11 `SUPER_ADMIN` / soporte — Supabase Cloud Development

No se crean fixtures de `SupportAccessGrant`, porque la entidad no existe.

Debe verificarse estática y dinámicamente que:

```text
PlatformUser reconocido
+
sin enabled CompanyMembership
→ ninguna capacidad sobre audit_events
```

y que la migration no contiene:

- support bypass;
- global bypass;
- DELETE de soporte;
- policy especial para ausencia de membership.

Esto preserva:

```text
futuro SupportAccessGrant
≠ permiso de borrar auditoría
```

sin fingir que soporte ya está implementado.

### 25.12 Actor no confiado desde caller

Como TASK-010 no crea flow productor, esta propiedad se demuestra mediante:

1. ausencia de INSERT normal;
2. ausencia de write policy;
3. ausencia de API/Server Action;
4. ausencia de `service-role` ordinario;
5. checks/FK de estructura.

La prueba definitiva de derivación del actor deberá formar parte de cada futuro productor funcional.

### 25.13 Separación de históricos — local, test estático obligatorio

`tests/task-010-migration.test.ts` debe confirmar que la migration crea exclusivamente:

```text
audit_events
```

y no crea/modifica:

- MaintenanceRevision;
- FormVersion;
- ReportVersion;
- ReportSnapshot;
- AICreditLedgerEntry;
- PaymentEvent.

### 25.14 No Client fixtures

Las pruebas de TASK-010 no crean:

```text
Client
UserClientAccess
SupportAccessGrant
```

ni UUID huérfanos para simularlos.

### 25.15 Cleanup — Supabase Cloud Development

Todos los fixtures creados mediante privilegio de test deben eliminarse al finalizar.

Resultado obligatorio:

```text
fixtures TASK-010 restantes = 0
```

El teardown privilegiado no representa una operación normal de producto.

---

## 26. Test estático reproducible obligatorio

TASK-010 requiere obligatoriamente:

```text
tests/task-010-migration.test.ts
```

Debe ejecutarse localmente como parte de los tests generales del repositorio y validar como mínimo:

- exactamente una tabla pública nueva: `audit_events`;
- lista exacta de columnas;
- ausencia de columnas no autorizadas;
- `subject_platform_user_id` obligatorio;
- FK exactas;
- `ON DELETE RESTRICT`;
- CHECK exacto de `actor_kind`;
- CHECK XOR de actor;
- CHECK exacto de `action` limitado a:
  - `USER_CREATED`;
  - `USER_DISABLED_OR_REVOKED`;
  - `USER_REINSTATED`;
  - `USER_ROLE_CHANGED`;
- ausencia física en el catálogo de:
  - `USER_CLIENT_ACCESS_CHANGED`;
  - `SUPPORT_ACCESS_GRANTED`;
  - `SUPPORT_ACCESS_SCOPE_CHANGED`;
  - `SUPPORT_ACCESS_REVOKED`;
  - `SUPPORT_ACCESS_USED`;
- CHECK exacto de `scope_kind = USER`;
- CHECK action/scope;
- CHECK de role snapshots;
- `occurred_at timestamptz NOT NULL` con default PostgreSQL;
- RLS habilitada;
- ausencia de policies funcionales;
- semántica equivalente a revocar **todos los privilegios de tabla** sobre `public.audit_events` para `anon` y `authenticated`;
- fallo obligatorio si la migration revoca solamente SELECT/INSERT/UPDATE/DELETE y deja abiertos privilegios laterales de tabla;
- ausencia de cualquier GRANT posterior sobre `public.audit_events` para `anon` o `authenticated`;
- verificación de que el resultado contractual para ambos roles es `table privileges = NONE`, incluidos explícitamente SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES y TRIGGER;
- ausencia de JSON/JSONB;
- ausencia de triggers;
- ausencia de RPC;
- ausencia de `SECURITY DEFINER`;
- ausencia de `service-role`;
- ausencia de índices adicionales no aprobados;
- ausencia de tablas o entidades funcionales adicionales.

El test estático:

```text
complementa
!=
sustituye
```

los tests PostgreSQL reales de integridad, RLS e inmutabilidad que se ejecutarán en Supabase Cloud Development.

No se exige ni se autoriza una base PostgreSQL/Supabase local para TASK-010.

---

## 27. Development Gate de futura implementación

TASK-010 modifica schema/RLS; por tanto, una futura ejecución deberá superar un Gate explícito de Supabase Cloud Development.

Este documento **NO autoriza ejecutarlo ahora**.

### 27.1 Etapa A — preflight Git

Antes de implementar:

- repositorio correcto;
- branch autorizada;
- HEAD real registrado;
- upstream;
- origin/main;
- divergencia;
- worktree;
- staged;
- untracked;
- inventario de migrations actual.

Resultado inesperado:

```text
BLOCKER
```

No reparar mediante:

- reset;
- rebase;
- merge;
- restore;
- clean;
- stash;
- pull automático.

### 27.2 Etapa B — revisión de fuentes

Releer íntegramente:

- TASK-010 canónica aprobada;
- migration TASK-009;
- tests TASK-009;
- ADR-0002;
- ADR-0003;
- fuentes de producto de AuditEvent.

Confirmar que siguen materialmente vigentes.

### 27.3 Etapa C — implementación local

Crear exclusivamente el scope aprobado.

No tocar Supabase Cloud.

No levantar ni requerir Supabase local.

### 27.4 Etapa D — revisión y tests locales

Antes de cualquier operación remota:

- revisar migration completa;
- revisar tests completos;
- ejecutar lint/typecheck/test generales cuando correspondan;
- ejecutar obligatoriamente `tests/task-010-migration.test.ts`;
- comprobar número de tablas;
- comprobar RLS declarada;
- comprobar grants;
- comprobar ausencia de policies no autorizadas;
- comprobar ausencia de SQL lateral;
- ejecutar `git diff --check`;
- inspeccionar los artefactos generados/modificados.

Esta etapa no ejecuta la suite SQL contra una base local.

### 27.5 Etapa E — migration dry-run

Realizar el mecanismo de dry-run remoto/no destructivo soportado por el workflow vigente, si corresponde dentro de las operaciones manuales aprobadas.

Si el dry-run requiere modificar datos o infraestructura no autorizada:

```text
BLOCKER
```

No se sustituye por un stack local obligatorio.

### 27.6 Etapa F — autorización humana remota

La aplicación a:

```text
Supabase Cloud Development
```

requiere acto humano separado.

Codex no recibe credenciales remotas.

No aplicar en:

```text
Staging
Production
```

### 27.7 Etapa G — aplicación en Development

El operador humano autorizado aplica exclusivamente la migration revisada.

Verificar migration list inmediatamente después.

### 27.8 Etapa H — tests PostgreSQL de integridad en Development

Ejecutar la suite SQL TASK-010 contra Supabase Cloud Development.

Todos los checks de integridad deben pasar.

No se exige ejecutar esta suite contra una base local.

### 27.9 Etapa I — tests RLS negativos en Development

Verificar:

- no SELECT funcional;
- no INSERT normal;
- no UPDATE normal;
- no DELETE normal;
- `authenticated TRUNCATE = DENIED` por privilegio insuficiente;
- conocido ID cross-tenant no concede acceso;
- tenant forjado no concede autoridad;
- sujeto disabled no adquiere capacidad;
- sujeto sin membership no adquiere capacidad.

### 27.10 Etapa J — inmutabilidad en Development

Verificar mediante operaciones reales:

```text
authenticated UPDATE = DENIED
authenticated DELETE = DENIED
authenticated TRUNCATE = DENIED
```

### 27.11 Etapa K — cleanup en Development

Eliminar fixtures de test mediante el procedimiento de test autorizado.

Confirmar:

```text
fixtures restantes = 0
```

### 27.12 Etapa L — revisión humana Development

Antes de Git final:

- schema esperado;
- migration aplicada;
- migration list correcta;
- tests PostgreSQL de integridad PASS;
- tests RLS PASS;
- inmutabilidad PASS;
- cleanup PASS;
- sin recursos inesperados.

### 27.13 Etapa M — Git

Sólo después del Gate Development y autorización correspondiente:

- revisar diff completo;
- `git diff --check`;
- checks generales;
- worktree esperado;
- revisión de arquitectura;
- revisión de seguridad;
- revisión de regresiones.

Commit/push no quedan autorizados por esta especificación.

---

## 28. Fuera de alcance

TASK-010 excluye expresamente:

### Auth

- login;
- signup;
- logout;
- Auth callback;
- Auth SSR lifecycle;
- refresh;
- proxy/middleware Auth;
- VerificationChallenge;
- onboarding;
- invitation flow;
- session termination;
- session registry;
- claims;
- custom claims;
- Auth hooks.

### Usuarios

- administración funcional de usuarios;
- alta funcional;
- disable/revoke funcional;
- reintegración funcional;
- cambio funcional de roles;
- edición de membership.

### Client scope

- `Client`;
- `UserClientAccess`;
- asignación de clientes;
- cambio real de client scope;
- persistencia física de `USER_CLIENT_ACCESS_CHANGED`.

### Soporte

- `SupportAccessGrant`;
- representación física completa de `SUPER_ADMIN`;
- support scopes;
- support authorization;
- grant/revoke flow;
- soporte client-scoped;
- acceso excepcional funcional;
- persistencia física de:
  - `SUPPORT_ACCESS_GRANTED`;
  - `SUPPORT_ACCESS_SCOPE_CHANGED`;
  - `SUPPORT_ACCESS_REVOKED`;
  - `SUPPORT_ACCESS_USED`.

### Authorization

- tenant resolver de aplicación;
- authorization layer completa;
- nueva policy sobre tablas TASK-009;
- RLS helper;
- privileged generic backend;
- `SECURITY DEFINER`;
- RPC;
- trigger de autorización.

### Infraestructura

- Storage;
- Realtime;
- Offline;
- Dexie;
- outbox;
- Service Worker;
- Supabase local;
- Docker como requisito.

### Otros dominios

- Client;
- Location;
- Equipment;
- Form Engine;
- Maintenance;
- Evidence;
- Reporting;
- AI;
- credits;
- Subscription;
- Payments;
- Push Notifications.

### Audit UX / plataforma de logs

- UI de auditoría;
- búsqueda;
- filtros;
- export;
- dashboards;
- observability vendor;
- logging platform;
- SIEM;
- event bus;
- event sourcing;
- generic audit API.

### Producers

TASK-010 no produce automáticamente `AuditEvent` desde ningún flow.

### Governance

- TASK-011;
- determinación de TASK-011;
- generación de TASK-011.

---

## 29. ADR

### 29.1 Resultado

```text
ADR nuevo requerido = NO
ADR review required = NO
```

### 29.2 Justificación

La foundation utiliza decisiones arquitectónicas ya aceptadas:

- monolito modular — ADR-0001;
- tenant ownership/RLS — ADR-0002;
- identidad/autorización/soporte — ADR-0003.

Las decisiones físicas de TASK-010:

- una tabla;
- FK a entidades existentes;
- discriminated actor representation;
- CHECKs locales;
- RLS fail-closed;
- ausencia de policies;
- ausencia de mutabilidad normal;

son decisiones locales, reversibles y limitadas al slice.

No introducen:

- nuevo deployable;
- nueva frontera de confianza;
- nuevo mecanismo general de autorización;
- nuevo sistema de privilegios;
- nuevo protocolo distribuido;
- nuevo patrón transversal de persistencia.

Por tanto no justifican un ADR nuevo.

---

## 30. Condiciones BLOCKER

El resultado obligatorio será:

```text
TASK-010 SPECIFICATION/IMPLEMENTATION = BLOCKER
```

según la etapa, si ocurre cualquiera de las siguientes condiciones.

### Fuentes / gobernanza

1. una fuente canónica posterior contradice el contrato usado por TASK-010;
2. Fase 2 deja de estar formalmente iniciada;
3. TASK-009 deja de estar cerrada o su migration no corresponde al baseline esperado;
4. CORR-011 deja de estar cerrada;
5. aparece una TASK-010 canónica incompatible;
6. el Revisor Central modifica la determinación del incremento;
7. se necesita modificar producto para completar la foundation;
8. se necesita modificar un ADR aceptado;
9. aparece un `DO-*` o `*-OPEN-*` que bloquee directamente AuditEvent.

### Scope

10. se necesita crear más de una entidad funcional;
11. se necesita `Client`;
12. se necesita `UserClientAccess`;
13. se necesita `SupportAccessGrant`;
14. se necesita materializar global role/SUPER_ADMIN;
15. se necesita Auth funcional;
16. se necesita UI;
17. se necesita Offline;
18. el incremento deja de ser PR-sized;
19. se necesita habilitar físicamente en TASK-010 cualquiera de las cinco acciones futuras todavía no representables íntegramente.

### Actor / tenancy

20. actor sólo puede representarse confiando un campo libre del frontend;
21. tenant sólo puede resolverse confiando `maintenance_company_id` del caller;
22. no puede garantizarse ownership directo de una `MaintenanceCompany`;
23. es necesario crear un fake `PlatformUser` para proceso interno;
24. una FK necesaria permitiría relación destructiva incompatible con histórico;
25. no puede rechazarse una referencia a tenant/actor/sujeto inexistente.

### RLS / permisos

26. es necesario inventar un permiso SELECT de AuditEvent;
27. es necesario conceder INSERT directo a `authenticated`;
28. es necesario conceder UPDATE normal;
29. es necesario conceder DELETE normal;
30. se necesita bypass de RLS;
31. se necesita `service-role` como mecanismo ordinario;
32. se necesita un `SECURITY DEFINER` no aprobado;
33. se necesita una RPC no aprobada;
34. se necesita trigger genérico;
35. se necesita backend privilegiado reutilizable como bypass.

### Histórico

36. la solution exige permitir UPDATE normal del evento;
37. la solution exige DELETE normal;
38. la historia sólo puede preservarse almacenando un JSON arbitrario;
39. la solution necesita IDs huérfanos de `Client`;
40. la solution necesita IDs huérfanos de `SupportAccessGrant`;
41. no puede preservarse la identidad del actor/sujeto referenciado.

### Workflow / Development / Git

42. la implementación exige una base Supabase/PostgreSQL local;
43. la implementación exige Docker como requisito;
44. preflight Git incompatible;
45. worktree inesperadamente sucio;
46. migration existente conflictiva;
47. dry-run muestra drift inesperado;
48. Development posee schema distinto del esperado;
49. cualquier test PostgreSQL de integridad falla en Development;
50. cualquier prueba RLS negativa falla en Development;
51. UPDATE normal es permitido;
52. DELETE normal es permitido;
53. el test estático obligatorio falta o falla;
54. quedan fixtures después de las pruebas;
55. el diff contiene archivos fuera del scope;
56. `git diff --check` falla.

### Cierre exhaustivo de privilegios

57. queda cualquier privilegio de tabla residual sobre `public.audit_events` para `anon` o `authenticated`;
58. `TRUNCATE` resulta permitido para `authenticated`;
59. la migration revoca solamente CRUD y deja abiertos privilegios laterales de tabla;
60. existe cualquier `GRANT` sobre `public.audit_events` a `anon` o `authenticated` dentro de TASK-010.

Ante cualquier BLOCKER:

- no ampliar scope;
- no corregir silenciosamente;
- no inventar requisito;
- no continuar a operación remota;
- devolver TASK-010 a revisión humana.

---

## 31. Criterios de aceptación

### Requisitos y dominio

**AC-010-001** — Existe exactamente una entidad nueva denominada físicamente `public.audit_events`.

**AC-010-002** — `AuditEvent` continúa siendo distinto de las historias/versiones de Maintenance, Form, Reporting, AI credits y Payments.

**AC-010-003** — La implementation no introduce event sourcing.

**AC-010-004** — El catálogo físico inicial de `action` contiene exactamente cuatro acciones:
- `USER_CREATED`;
- `USER_DISABLED_OR_REVOKED`;
- `USER_REINSTATED`;
- `USER_ROLE_CHANGED`.

**AC-010-005** — Las obligaciones futuras:
- `USER_CLIENT_ACCESS_CHANGED`;
- `SUPPORT_ACCESS_GRANTED`;
- `SUPPORT_ACCESS_SCOPE_CHANGED`;
- `SUPPORT_ACCESS_REVOKED`;
- `SUPPORT_ACCESS_USED`;

permanecen documentadas, pero son rechazadas por el CHECK físico de TASK-010.

### Identidad y tenant

**AC-010-006** — `id` es UUID PK y conserva identidad estable.

**AC-010-007** — `maintenance_company_id` es obligatorio y FK a `maintenance_companies(id)`.

**AC-010-008** — `maintenance_company_id` utiliza `ON DELETE RESTRICT`.

**AC-010-009** — Un tenant inexistente es rechazado por integridad.

**AC-010-010** — Conocer o enviar un `maintenance_company_id` no concede autoridad sobre AuditEvent.

### Actor

**AC-010-011** — `actor_kind` sólo admite `PLATFORM_USER` o `INTERNAL_PROCESS`.

**AC-010-012** — Un actor `PLATFORM_USER` requiere un `actor_platform_user_id` válido.

**AC-010-013** — Un actor `INTERNAL_PROCESS` requiere una key interna estable no vacía.

**AC-010-014** — Las dos representaciones de actor son mutuamente excluyentes.

**AC-010-015** — No se crea `PlatformUser` ficticio para procesos internos.

**AC-010-016** — `actor_platform_user_id` es FK con `ON DELETE RESTRICT`.

**AC-010-017** — No existe superficie funcional donde el frontend pueda seleccionar autoritativamente el actor.

### Momento, acción y alcance

**AC-010-018** — `occurred_at` es `timestamptz NOT NULL` con default derivado por PostgreSQL.

**AC-010-019** — TASK-010 no afirma que el DEFAULT vuelva físicamente imposible el override por un escritor privilegiado.

**AC-010-020** — No existe INSERT funcional y ningún frontend/caller obtiene autoridad para definir `occurred_at`.

**AC-010-021** — Todo futuro productor funcional deberá derivar/obtener el momento desde su frontera confiable y no aceptar un timestamp de browser/PWA como autoridad.

**AC-010-022** — TASK-010 no introduce trigger, RPC ni `SECURITY DEFINER` sólo para volver `occurred_at` no-overridable.

**AC-010-023** — La migration no añade `created_at`, `updated_at` ni `deleted_at`.

**AC-010-024** — `action` utiliza `text + CHECK` y no enum/catálogo configurable.

**AC-010-025** — `scope_kind` utiliza `text + CHECK` y admite exclusivamente `USER`.

**AC-010-026** — Las cuatro acciones admitidas requieren `scope_kind = USER`.

**AC-010-027** — Valores de scope futuros como `USER_CLIENT_ACCESS`, `SUPPORT_GRANT` o `SUPPORT_ACCESS` no son físicamente admitidos.

### Subject / histórico

**AC-010-028** — `subject_platform_user_id` es obligatorio y FK a `platform_users(id)` con `ON DELETE RESTRICT`.

**AC-010-029** — Las cuatro acciones físicamente admitidas no permiten sujeto nulo.

**AC-010-030** — `USER_ROLE_CHANGED` conserva `role_before` y `role_after`.

**AC-010-031** — Ambos roles sólo admiten `COMPANY_ADMIN` o `TECHNICIAN`.

**AC-010-032** — Un cambio de role con valores iguales es rechazado.

**AC-010-033** — Las otras tres acciones no pueden almacenar role snapshots arbitrarios.

### Dependencias diferidas

**AC-010-034** — No se crea `Client`.

**AC-010-035** — No se crea `UserClientAccess`.

**AC-010-036** — No se crea `SupportAccessGrant`.

**AC-010-037** — No existe `client_id` huérfano en `audit_events`.

**AC-010-038** — No existe `support_access_grant_id` huérfano.

**AC-010-039** — Los futuros slices de client scope y support deben extender `AuditEvent` antes de liberar sus flows auditables.

### JSON / metadata

**AC-010-040** — `audit_events` no contiene JSON/JSONB.

**AC-010-041** — No existe columna genérica `metadata`, `payload`, `details` o equivalente.

**AC-010-042** — No se añaden request IDs, trace IDs, IP, user-agent o device metadata sin requisito.

### RLS / autorización

**AC-010-043** — RLS está habilitada sobre `public.audit_events`.

**AC-010-044** — `anon` posee cero privilegios de tabla sobre `public.audit_events`, incluidos SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES y TRIGGER.

**AC-010-045** — `authenticated` posee cero privilegios de tabla sobre `public.audit_events`, incluidos SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES y TRIGGER.

**AC-010-046** — No existe policy SELECT funcional.

**AC-010-047** — No existe policy INSERT funcional.

**AC-010-048** — No existe policy UPDATE funcional.

**AC-010-049** — No existe policy DELETE funcional.

**AC-010-050** — Tenant A no puede observar el evento de Tenant B por conocer su ID.

**AC-010-051** — Una membership `COMPANY_ADMIN` no obtiene permiso de DELETE sobre auditoría.

**AC-010-052** — Un `PlatformUser` sin membership no obtiene acceso tenant sobre auditoría.

**AC-010-053** — Una membership disabled no obtiene una capacidad nueva mediante AuditEvent.

### Inmutabilidad

**AC-010-054** — UPDATE normal de `audit_events` es denegado físicamente en Supabase Cloud Development.

**AC-010-055** — DELETE normal es denegado físicamente en Supabase Cloud Development.

**AC-010-056** — Los tests distinguen denegación real de UPDATE/DELETE/TRUNCATE de una operación técnicamente permitida sin efecto observable.

**AC-010-057** — No se introduce purge/retention.

### Privilegio

**AC-010-058** — No se utiliza `service-role` como mecanismo ordinario de escritura.

**AC-010-059** — No se crea `SECURITY DEFINER`.

**AC-010-060** — No se crea RPC.

**AC-010-061** — No se crea trigger.

**AC-010-062** — No se crea API/Server Action/Route Handler productor.

### Scope técnico

**AC-010-063** — Existe exactamente una migration funcional TASK-010.

**AC-010-064** — Existe obligatoriamente `tests/task-010-migration.test.ts`.

**AC-010-065** — El test estático obligatorio valida la estructura, constraints y ausencias definidas en §26.

**AC-010-066** — Localmente se ejecutan lint/typecheck/test generales cuando correspondan, el Vitest estático obligatorio, `git diff --check` e inspección de artefactos; no se exige una base Supabase/PostgreSQL local.

**AC-010-067** — Los tests PostgreSQL de integridad, RLS e inmutabilidad se ejecutan exclusivamente contra Supabase Cloud Development después de autorización humana y aplicación de la migration.

**AC-010-068** — No se modifica la migration de TASK-009.

**AC-010-069** — No se crean índices adicionales distintos del derivado de la PK.

**AC-010-070** — No se modifica `app/`.

**AC-010-071** — No se implementa UI.

**AC-010-072** — No se implementa Offline, Storage ni Realtime.

### Tests / Development

**AC-010-073** — Los checks locales definidos en AC-010-066 pasan.

**AC-010-074** — Los tests PostgreSQL de integridad pasan en Supabase Cloud Development.

**AC-010-075** — Las pruebas RLS negativas pasan en Supabase Cloud Development.

**AC-010-076** — Las pruebas de inmutabilidad pasan en Supabase Cloud Development.

**AC-010-077** — Las cinco acciones futuras todavía no habilitadas son rechazadas por el CHECK físico en Development.

**AC-010-078** — Los fixtures de test prefieren el default de `occurred_at` salvo necesidad concreta del test.

**AC-010-079** — No se utilizan fixtures `Client`.

**AC-010-080** — No se utilizan datos reales.

**AC-010-081** — Los fixtures restantes después del test son exactamente cero.

**AC-010-082** — La migration supera revisión y test estático local antes de cualquier aplicación remota.

**AC-010-083** — El dry-run autorizado pasa cuando forme parte del workflow remoto vigente.

**AC-010-084** — La migration se aplica primero y exclusivamente a Development mediante acto humano autorizado.

**AC-010-085** — Codex no recibe ni utiliza credenciales Supabase remotas.

**AC-010-086** — La migration list remota coincide con la esperada después de la aplicación.

### Arquitectura / regresiones / Git

**AC-010-087** — ADR-0001 permanece respetado.

**AC-010-088** — ADR-0002 permanece respetado.

**AC-010-089** — ADR-0003 permanece respetado.

**AC-010-090** — ADR-0004 y sus blockers permanecen intactos.

**AC-010-091** — `ADR nuevo requerido = NO`.

**AC-010-092** — Auth funcional continúa `NO`.

**AC-010-093** — Authorization ready continúa `NO`.

**AC-010-094** — `VerificationChallenge`, `UserClientAccess`, `SupportAccessGrant` y `Client` continúan `NO`.

**AC-010-095** — Los checks generales del repositorio continúan pasando.

**AC-010-096** — `git diff --check` finaliza sin errores.

**AC-010-097** — El diff final contiene exclusivamente cambios necesarios para TASK-010.

**AC-010-098** — El worktree final previo a incorporación contiene únicamente el diff revisado de TASK-010.

**AC-010-099** — La incorporación Git sólo ocurre después de autorización humana separada.

**AC-010-100** — TASK-011 no es determinada ni generada durante TASK-010.

**AC-010-101** — `authenticated TRUNCATE public.audit_events` es rechazado en Supabase Cloud Development con privilegio insuficiente; tabla vacía, `0 rows` o filtrado RLS no constituyen evidencia suficiente.

**AC-010-102** — Después del cierre de privilegios no existe ningún GRANT posterior sobre `public.audit_events` para `anon` o `authenticated`.

**AC-010-103** — `tests/task-010-migration.test.ts` exige semántica equivalente a revocar todos los privilegios de tabla de `anon` y `authenticated` y falla si la migration revoca únicamente CRUD.

**AC-010-104** — La especificación y los tests no presentan RLS como protección frente a `TRUNCATE`; la denegación de `TRUNCATE` deriva de la ausencia del privilegio de tabla correspondiente.

**AC-010-105** — El estado final verificable de privilegios es `table privileges anon = NONE` y `table privileges authenticated = NONE` sobre `public.audit_events`.

---

## 32. Definition of Done de una futura implementación

TASK-010 sólo podrá considerarse técnicamente completada cuando se cumpla simultáneamente:

### Schema

- existe exactamente una migration TASK-010;
- existe `public.audit_events`;
- no existe una segunda entidad funcional;
- las columnas coinciden exactamente con esta especificación;
- PK/FK/CHECK/ON DELETE coinciden;
- el CHECK de `action` admite exclusivamente:
  - `USER_CREATED`;
  - `USER_DISABLED_OR_REVOKED`;
  - `USER_REINSTATED`;
  - `USER_ROLE_CHANGED`;
- las cinco acciones futuras todavía no representables son rechazadas;
- `scope_kind` admite exclusivamente `USER`;
- `subject_platform_user_id` es obligatorio;
- no existe JSON/JSONB genérico;
- no existen campos laterales no aprobados;
- no existen índices especulativos.

### Seguridad

- RLS está habilitada;
- no existen policies funcionales;
- `table privileges anon = NONE` sobre `public.audit_events`;
- `table privileges authenticated = NONE` sobre `public.audit_events`;
- no existe ningún GRANT posterior sobre `public.audit_events` para `anon` o `authenticated`;
- RLS no se utiliza ni se documenta como protección frente a TRUNCATE;
- `anon` no obtiene acceso;
- `authenticated` no obtiene acceso;
- no existe write path de aplicación;
- no existe bypass global;
- no existe `service-role` ordinario;
- no existe RPC/trigger/`SECURITY DEFINER`.

### Histórico

- actor válido garantizado estructuralmente;
- tenant válido garantizado;
- subject válido garantizado;
- role snapshot preservado;
- `occurred_at` es `timestamptz NOT NULL` con default PostgreSQL;
- la documentación no confunde ese default con garantía absoluta de no-overridable privilegiado;
- futuros productores quedan obligados a derivar el momento desde frontera confiable;
- UPDATE normal denegado;
- DELETE normal denegado;
- TRUNCATE normal denegado;
- cascadas destructivas impedidas.

### Multitenancy

- tenant ownership directo probado en Development;
- cross-tenant negativo probado en Development;
- tenant ID forjado no concede capacidad;
- membership disabled no gana capacidad;
- identidad sin membership no gana acceso tenant.

### Validación local

- lint/typecheck/test generales pasan cuando correspondan;
- `tests/task-010-migration.test.ts` existe y pasa;
- el test estático valida todos los puntos de §26;
- `git diff --check = PASS`;
- inspección de migration/tests/artefactos = PASS;
- no se utilizó ni requirió Supabase/PostgreSQL local;
- Docker no fue requisito.

### Supabase Cloud Development

- revisión estática local previa realizada;
- dry-run remoto/no destructivo PASS cuando corresponda al workflow vigente;
- aplicación sólo en Development;
- aplicación remota realizada exclusivamente por operador humano autorizado;
- migration list verificada;
- tests PostgreSQL de integridad PASS;
- tests RLS PASS;
- inmutabilidad PASS;
- `authenticated TRUNCATE = DENIED` por privilegio insuficiente;
- `table privileges anon/authenticated = NONE` verificado;
- las acciones futuras no habilitadas son rechazadas;
- cleanup PASS;
- fixtures restantes = 0;
- revisión humana Development = APPROVED.

### Arquitectura y regresión

- ADR-0001 respetado;
- ADR-0002 respetado;
- ADR-0003 respetado;
- ADR-0004 no modificado;
- no se resolvió ningún OPEN;
- Auth continúa fuera de alcance;
- Client continúa fuera de alcance;
- UserClientAccess continúa fuera de alcance;
- SupportAccessGrant continúa fuera de alcance;
- Offline continúa fuera de alcance;
- no existe regresión de TASK-008/TASK-009.

### Git / gobernanza

- diff completo revisado;
- `git diff --check = PASS`;
- no existen cambios laterales;
- cierre técnico revisado humanamente;
- cualquier `git add`, commit o push ocurre sólo mediante autorización explícita;
- cierre humano final realizado;
- TASK-011 continúa fuera de scope.

---

## 33. Gate posterior

La secuencia obligatoria desde esta especificación es:

```text
TASK-010 = APPROVED FOR IMPLEMENTATION
→ canonicalización
→ revisión humana de canonicalización
→ incorporación canónica correspondiente
→ autorización humana separada de ejecución
→ Codex
→ implementación local de artefactos Git
→ revisión y tests locales estáticos
→ autorización humana para Development
→ aplicación manual en Supabase Cloud Development
→ tests PostgreSQL/RLS/inmutabilidad en Development
→ cleanup
→ revisión humana Development
→ autorización de incorporación Git
→ incorporación Git
→ verificación Git
→ cierre humano final
```

No se puede saltar:

```text
APPROVED FOR IMPLEMENTATION
→ Codex
```

ni:

```text
APPROVED
→ operación remota automática
```

ni:

```text
TASK-010 completada
→ TASK-011 automáticamente
```

La determinación de cualquier siguiente incremento pertenece a otro acto separado del Revisor Central.

---

## 34. Resultado de esta aprobación

```text
TASK-010 = APPROVED FOR IMPLEMENTATION

TASK-010 determinada = SÍ
TASK-010 especificada = SÍ
TASK-010 aprobada = SÍ

Fase 0 = COMPLETADA
Fase 1 = COMPLETADA
Fase 2 = INICIADA

TASK-008 = COMPLETADA
TASK-009 = COMPLETADA
CORR-011 = COMPLETADA

Supabase application boundary = IMPLEMENTADA

MaintenanceCompany físico = SÍ
PlatformUser físico = SÍ
Auth subject → PlatformUser físico = SÍ
CompanyMembership físico = SÍ
RLS TASK-009 = IMPLEMENTADA Y PROBADA EN DEVELOPMENT

AuditEvent foundation propuesta = SÍ
AuditEvent implementada = NO

Acciones físicas TASK-010:
- USER_CREATED
- USER_DISABLED_OR_REVOKED
- USER_REINSTATED
- USER_ROLE_CHANGED

Obligaciones futuras no físicamente habilitadas:
- USER_CLIENT_ACCESS_CHANGED
- SUPPORT_ACCESS_GRANTED
- SUPPORT_ACCESS_SCOPE_CHANGED
- SUPPORT_ACCESS_REVOKED
- SUPPORT_ACCESS_USED

Auth funcional = NO
Auth SSR lifecycle completo = NO
Authorization ready = NO
VerificationChallenge = NO
UserClientAccess = NO
SupportAccessGrant = NO
Client = NO
Application authorization completa = NO
Storage = NO
Realtime = NO
Offline = NO

UI TASK-010 = NO APLICA
Offline TASK-010 = NO APLICA

Supabase local requerido = NO
Docker requerido = NO
Test estático TASK-010 = OBLIGATORIO
Tests PostgreSQL/RLS/inmutabilidad = SUPABASE CLOUD DEVELOPMENT

Table privileges anon sobre audit_events = NONE
Table privileges authenticated sobre audit_events = NONE
authenticated TRUNCATE = DENIED
GRANT posterior anon/authenticated sobre audit_events = NINGUNO
RLS protege TRUNCATE = NO

ADR nuevo requerido = NO
ADR review required = NO

Implementación realizada = NO
Implementación concreta autorizada = NO
Codex autorizado = NO

Canonicalización realizada = NO
Repositorio modificado = NO
Supabase Cloud modificado = NO
Git modificado = NO

TASK-011 determinada = NO
TASK-011 generada = NO
```

---

TASK-010 = APPROVED FOR IMPLEMENTATION

TASK-010 THIRD SPEC REVIEW = APPROVED
