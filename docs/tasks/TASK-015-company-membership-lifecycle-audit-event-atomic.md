# TASK-015 — Lifecycle funcional mínimo de CompanyMembership con AuditEvent atómico

## 1. Identificación

**ID:** `TASK-015`

**Título:** `TASK-015 — Lifecycle funcional mínimo de CompanyMembership con AuditEvent atómico`

**Tipo:** `IMPLEMENTATION TASK`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context principal:** `Identity & Authorization`

**Estado de esta especificación:** `APPROVED FOR IMPLEMENTATION`

**TASK-015 SPECIFICATION:**

```text
APPROVED FOR IMPLEMENTATION
```

**Archivo de entrega:**

`TASK-015-company-membership-lifecycle-audit-event-atomic-approved.md`

**TASK-015 DETERMINATION:** `APPROVED`

**TASK-015 determinada:** `SÍ`

**TASK-015 generada:** `SÍ`

**TASK-015 especificada:** `SÍ`

**TASK-015 SPEC REVIEW:** `APPROVED`

**TASK-015 HUMAN SPEC APPROVAL:** `APPROVED`

**TASK-015 aprobada:** `SÍ`

**TASK-015 canonicalizada:** `NO`

**Implementación autorizada:** `NO`

**Implementación iniciada:** `NO`

**Codex autorizado:** `NO`

**Repositorio modificado durante esta especificación:** `NO`

**Supabase Cloud modificado durante esta especificación:** `NO`

**SQL ejecutable producido:** `NO`

**Migration producida:** `NO`

**RLS ejecutable producido:** `NO`

**Staging / commit / push:** `NO / NO / NO`

**TASK-016:** `NOT DETERMINED / NOT GENERATED / NOT STARTED`

Esta especificación define exclusivamente un incremento PR-sized futuro. El estado `APPROVED FOR IMPLEMENTATION` significa exclusivamente `SPECIFICATION HUMAN-APPROVED`. No constituye autorización concreta de implementación, Codex, modificación del repositorio, Supabase Cloud, Staging o Production, ni significa que TASK-015 esté completada.

```text
APPROVED FOR IMPLEMENTATION
=
SPECIFICATION HUMAN-APPROVED

APPROVED FOR IMPLEMENTATION
!=
IMPLEMENTATION EXECUTION AUTHORIZED

APPROVED FOR IMPLEMENTATION
!=
CODEX AUTHORIZED

APPROVED FOR IMPLEMENTATION
!=
REPOSITORY MODIFICATION AUTHORIZED

APPROVED FOR IMPLEMENTATION
!=
SUPABASE CLOUD AUTHORIZED

APPROVED FOR IMPLEMENTATION
!=
DONE
```

---

## 2. Capability determinada

TASK-015 materializará exclusivamente:

```text
disable / reinstate / role-change autoritativos de CompanyMembership
por COMPANY_ADMIN autorizado del mismo tenant
con AuditEvent obligatorio y atómico para cada mutación real
```

Operaciones:

```text
OP-01 — DISABLE / REVOKE MEMBERSHIP
OP-02 — REINSTATE MEMBERSHIP
OP-03 — CHANGE MEMBERSHIP ROLE
```

La capability debe preservar:

```text
tenant = MaintenanceCompany

authenticated != authorized

current authoritative PostgreSQL state
>
JWT / session / cookies / frontend / caller-supplied authority

CompanyMembership mutation committed
IFF
required AuditEvent committed
```

TASK-015 no amplía la capability a alta de usuarios, creación de memberships, client scope, soporte excepcional, bootstrap, Auth UI, administración global ni ninguna capacidad de TASK-016.

---

## 3. Estado de gobernanza consumido

Se consume como baseline autorizado:

```text
CORR-019 = DONE / CLOSED
TASK-014 = DONE / CLOSED
Phase 2 = INICIADA / NOT DONE
Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED
Phase 3 = NOT STARTED
Auth funcional = NO
TASK-016 = NOT DETERMINED / NOT GENERATED / NOT STARTED
```

Baseline Git documental consumido:

```text
branch = main
HEAD = e2e5ed36dd51508813669f0454395ca3b6ec2de1
origin/main = e2e5ed36dd51508813669f0454395ca3b6ec2de1
divergence = 0 0
worktree = CLEAN
```

Este baseline es evidencia de especificación y no autoriza ni sustituye el preflight fresco obligatorio de una futura ejecución.

### 3.1 CORR-019

La fuente canónica recuperada fue verificada físicamente antes de reanudar TASK-015:

```text
CORR-019 canonical source integrity = PASS

SHA-256 =
6a64f327aaeff2739b734c90418a20063030a3ebb1ec3c4b528777173836c58d

bytes = 38516
LF = 1177
CRLF = 0
bare CR = 0
trailing-whitespace lines = 0
final newline = YES
```

CORR-019 confirma el cierre acotado de TASK-014 y preserva expresamente como pendientes el lifecycle funcional de `CompanyMembership`, los productores funcionales completos de `AuditEvent` y `Auth funcional`.

---

## 4. Fuentes de verdad

### 4.1 Producto

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/04-offline-sync-strategy.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md`

### 4.2 Arquitectura

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`

### 4.3 Foundations de Fase 2

- `docs/tasks/TASK-009-identity-tenant-foundation.md`
- `docs/tasks/TASK-010-audit-event-foundation.md`
- `docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`
- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`
- `docs/tasks/CORR-019-task-014-closure-state-sync.md`

TASK-011 y TASK-013 se consumen por las fronteras Auth/session ya implementadas cuando la futura ejecución inspeccione el repositorio real.

### 4.4 Orden de autoridad

Se preserva:

1. decisiones humanas posteriores explícitamente aprobadas dentro de su alcance;
2. baseline normativa de producto;
3. documentos derivados dentro de su bounded context;
4. ADR aceptados dentro de su decisión arquitectónica;
5. TASK/CORR como contratos físicos, de ejecución y de estado;
6. repositorio real como fuente de verdad de la implementación física vigente al momento de ejecutar.

No se utiliza conversación histórica como sustituto del canon.

---

## 5. Decisiones humanas posteriores consumidas

Las seis decisiones bloqueantes previas han sido resueltas y no se reabren.

### DECISION-001 — SELF-DISABLE

```text
COMPANY_ADMIN self-disable / self-revoke = PROHIBITED
```

Un `COMPANY_ADMIN` no puede deshabilitar ni revocar su propia `CompanyMembership` mediante TASK-015.

### DECISION-002 — SELF-ROLE-CHANGE

```text
COMPANY_ADMIN self-role-change = PROHIBITED
```

Un `COMPANY_ADMIN` no puede cambiar el role de su propia `CompanyMembership` mediante TASK-015, incluso cuando el requested role coincida con el role vigente.

### DECISION-003 — ADMIN CONTINUITY

Una operación TASK-015 no puede dejar a una `MaintenanceCompany` que posee administración activa sin al menos una membership que cumpla simultáneamente:

```text
is_enabled = true
role = COMPANY_ADMIN
```

Si la operación produciría cero administradores habilitados:

```text
result = DENY
membership mutation = NONE
AuditEvent = NONE
```

TASK-015 no redefine bootstrap ni creación inicial del primer administrador.

### DECISION-004 — ROLE CHANGE WHILE DISABLED

```text
role-change de CompanyMembership disabled = ALLOWED
```

Un cambio real de role sobre una membership disabled:

```text
role changes
is_enabled remains false
USER_ROLE_CHANGED is persisted atomically
```

El cambio no restaura autoridad tenant.

### DECISION-005 — ALREADY-SATISFIED REQUESTS

Después de validar actor, target, same-tenant, permiso e invariantes:

```text
disable sobre disabled
reinstate sobre enabled
role change al mismo role

→ IDEMPOTENT SUCCESS
→ changed = false
→ membership mutation = NONE
→ AuditEvent = NONE
```

No convierte en success un actor inválido, cross-tenant, self-target prohibido ni otra condición fail-closed.

### DECISION-006 — CONCURRENT OPERATIONS

Toda operación se reevalúa contra PostgreSQL vigente y debe impedir TOCTOU entre autorización, continuidad administrativa, mutación y auditoría.

No se exige expected-state/version token del cliente.

---

## 6. Precondición documental de futura implementación

Las decisiones DECISION-001..006 pueden ser consumidas por esta especificación, pero antes de autorizar cualquier implementación deben estar sincronizadas mediante un Gate documental separado en:

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
```

Contrato:

```text
TASK-015 specification may consume decisions = YES
TASK-015 implementation before documentation sync = PROHIBITED
```

TASK-015 no genera, identifica ni ejecuta esa futura corrección documental.

Si al abrir el Gate de implementación cualquiera de los tres documentos no refleja DECISION-001..006 de forma coherente:

```text
TASK-015 IMPLEMENTATION = BLOCKER — REQUIRED DOCUMENTATION SYNC NOT COMPLETE
```

---

## 7. Dominio preservado

### 7.1 Entidades

```text
MaintenanceCompany = tenant
PlatformUser = identidad de aplicación
CompanyMembership = autoridad tenant ordinaria
AuditEvent = hecho histórico de auditoría sensible
```

### 7.2 Cardinalidad

Se preserva la foundation vigente:

```text
PlatformUser → 0..1 CompanyMembership
```

### 7.3 Roles tenant

Los únicos roles válidos continúan siendo:

```text
COMPANY_ADMIN
TECHNICIAN
```

`SUPER_ADMIN` no es role de `CompanyMembership`.

### 7.4 Estado de membership

El estado físico vigente relevante es:

```text
is_enabled = true | false
```

No se introduce una state machine adicional.

### 7.5 Global authority

Se preserva:

```text
absence of CompanyMembership != SUPER_ADMIN
```

Y:

```text
is_super_admin = true
+
any CompanyMembership exists
→ inconsistent global/tenant identity
→ DENY / FAIL CLOSED
```

TASK-015 no constituye una vía de reparación de esa inconsistencia.

### 7.6 Identidad del target

El caller puede suministrar únicamente el identificador mínimo necesario de la membership target:

```text
target_company_membership_id
```

Ese ID:

```text
!= actor
!= tenant authority
!= authorization
```

El tenant, `PlatformUser`, role y `is_enabled` reales del target se resuelven desde PostgreSQL dentro de la frontera autoritativa.

---

## 8. Verificación externa — Supabase Auth

### 8.1 Fecha de verificación

```text
verification date = 2026-09-05
```

### 8.2 Fuentes oficiales consultadas

Exclusivamente documentación oficial de Supabase:

1. Supabase Auth — Signing out
   `https://supabase.com/docs/guides/auth/signout`
2. Supabase Auth — User sessions
   `https://supabase.com/docs/guides/auth/sessions`
3. Supabase JavaScript — `auth.signOut`
   `https://supabase.com/docs/reference/javascript/auth-signout`
4. Supabase JavaScript — Auth Admin overview
   `https://supabase.com/docs/reference/javascript/auth-admin`
5. Supabase JavaScript — `auth.admin.signOut`
   `https://supabase.com/docs/reference/javascript/auth-admin-signout`

No se utilizaron blogs, Stack Overflow, Reddit, GitHub source, GoTrue internals ni comportamiento observado como fuente contractual.

### 8.3 Mecanismos públicos soportados

La documentación vigente expone:

```text
supabase.auth.signOut({ scope })
```

para el usuario/sesión representados por el cliente actual, y:

```text
supabase.auth.admin.signOut(jwt, scope)
```

como método admin documentado que recibe un JWT válido y logged-in.

### 8.4 Scopes

El contrato público de sign-out define:

```text
global = todas las sesiones activas del usuario
local = sólo la sesión actual
others = todas las demás sesiones salvo la actual
```

### 8.5 Privilegio admin

Los métodos bajo `supabase.auth.admin` requieren una `secret` key y deben ejecutarse exclusivamente en un servidor confiable.

Esto no autoriza convertir esa key en cliente genérico de requests de aplicación.

### 8.6 Refresh tokens

El sign-out destruye los refresh tokens y otros objetos de sesión afectados por el scope aplicable.

### 8.7 Access JWT ya emitido

Supabase documenta expresamente que un access token de una sesión revocada continúa técnicamente válido hasta su expiración `exp`.

Por tanto:

```text
provider sign-out success
!= immediate invalidation of already-issued access JWT
```

### 8.8 Actuar sobre otro usuario

La primitive admin documentada requiere:

```text
jwt = valid logged-in JWT
```

del usuario cuya sesión se pretende terminar.

No se encontró en la documentación oficial vigente una primitive `auth.admin` de sign-out/session termination que acepte exclusivamente un `user_id` y permita terminar las sesiones renovables de ese otro usuario sin disponer de su JWT.

TASK-015 prohíbe:

- almacenar JWT de otros usuarios;
- obtener JWT de otros usuarios mediante internals;
- leer o mutar `auth.sessions` como workaround;
- usar `ban_duration` como equivalente de global sign-out;
- cambiar password como equivalente de revocación;
- crear una sesión del target para poder cerrarla.

Resultado contractual para el target de TASK-015:

```text
supported administrative termination by authoritative user_id without target JWT = NOT FOUND
provider-side termination for another user under TASK-015 constraints = UNSUPPORTED
```

### 8.9 Sesión concreta vs todas las sesiones

El sign-out público soporta scopes capaces de representar una sesión (`local`) o todas (`global`), y `others` para todas salvo la sesión representada como actual.

Sin embargo, `auth.admin.signOut` sigue requiriendo el JWT que identifica una sesión válida del target; TASK-015 no dispone contractualmente de ese JWT.

### 8.10 Timeout/error

La documentación consultada no establece una garantía contractual especial de retry, timeout ni entrega exactamente-una-vez para la operación admin de sign-out.

Si en una futura revisión aparece una primitive aplicable, un timeout/error debe tratarse como:

```text
provider-side defense failure
!= authorization restoration
!= DB rollback
```

No se deben introducir retries ciegos ni una outbox provider-side sin una revisión expresa del contrato actualizado.

### 8.11 Mutación directa de Auth internals

TASK-015 no adopta:

```text
DELETE/UPDATE auth.sessions
ban_duration workaround
password reset as revocation
JWT storage for targets
GoTrue internals
undocumented endpoint
```

### 8.12 Conclusión provider

La seguridad de TASK-015 se basa en:

```text
current authoritative PostgreSQL state = PRIMARY AUTHORIZATION AUTHORITY
provider-side termination = DEFENSE IN DEPTH
provider-side termination failure/unavailability != authorization restoration
access JWT residual != current authorization
```

---

## 9. Evaluación de ADR

### 9.1 Resultado

```text
NEW ADR REQUIRED = NO
```

### 9.2 Justificación

`ADR-0001` ya permite resolver el caso dentro del monolito modular Next.js + Supabase sin microservicios.

`ADR-0002` ya fija tenant resolution autoritativa, RLS obligatoria, integridad cross-tenant y privilegio elevado sólo cuando sea estrictamente necesario.

`ADR-0003` ya fija explícitamente:

```text
commit authoritative revocation
→ authorization DENIED
→ attempt supported provider termination when applicable
→ provider failure/unavailability does not restore authorization
```

y además establece que si no existe primitive pública y adecuada:

```text
provider-side termination = unavailable for that case
```

`ADR-0019` permanece preservado: gobierna el establecimiento de sesión/VerificationChallenge y la disciplina de fronteras server-only privilegiadas; TASK-015 no modifica su decisión E2, no reutiliza el technical-password bridge para revocación y no introduce una nueva primitive de Auth session establishment.

`TASK-010` dejó expresamente la selección de una frontera transaccional privilegiada para el futuro flow que necesite producir `AuditEvent` atómicamente.

`TASK-014` ya demostró que una función PostgreSQL purpose-specific `SECURITY DEFINER`, hardenizada, `auth.uid()`-derived y consumida por caller-scoped client puede utilizarse sin crear un `service-role` client genérico ni un bypass tenant.

TASK-015 selecciona esa misma clase arquitectónica de boundary para una capability distinta y estrictamente acotada. No introduce una decisión transversal nueva.

---

## 10. Provider-side semantics por operación

| Operación | Caso | Provider-side termination | Razón |
|---|---|---|---|
| OP-01 | disable/revoke real | `UNSUPPORTED` | Es una revocación actual, pero no existe primitive documentada por `user_id` sin JWT target bajo las restricciones del proyecto |
| OP-01 | target ya disabled | `NOT APPLICABLE` | No existe cambio de autorización; DECISION-005 produce no-op autorizado |
| OP-02 | reinstate real | `NOT APPLICABLE` | Restablece autorización tenant; no es una revocación/reducción que deba cerrar sesiones |
| OP-02 | target ya enabled | `NOT APPLICABLE` | No-op autorizado |
| OP-03 | enabled `COMPANY_ADMIN → TECHNICIAN` | `UNSUPPORTED` | Reduce autoridad actual; no existe primitive target-safe por `user_id` |
| OP-03 | enabled `TECHNICIAN → COMPANY_ADMIN` | `NOT APPLICABLE` | Aumenta autoridad; no se requiere terminar sesión |
| OP-03 | same-role | `NOT APPLICABLE` | No-op; no hay cambio de autoridad |
| OP-03 | target disabled, cualquier role-change real | `NOT APPLICABLE` | La membership permanece sin autoridad; el cambio sólo modifica autoridad futura potencial |

### 10.1 OP-01 y JWT residual

Después del commit DB:

```text
is_enabled = false
→ nuevas operaciones tenant = DENIED inmediatamente
```

Un JWT técnicamente vigente puede seguir autenticando al subject hasta `exp`, pero no conserva membership ni role autorizativo.

Como la termination target-safe es `UNSUPPORTED`, TASK-015 no hace una llamada provider-side y no convierte esa ausencia en error de la mutación.

### 10.2 OP-02 y sesión residual

TASK-015 no crea, renueva ni destruye sesiones durante reintegración.

Si existe una sesión Auth técnicamente válida, vuelve a ser sólo el mecanismo de autenticación del subject. La autorización restaurada proviene exclusivamente de:

```text
CompanyMembership.is_enabled = true
+
role actual en PostgreSQL
```

TASK-015 no inventa una obligación de reautenticación al reintegrar.

### 10.3 OP-03 demotion

Una demotion real de membership enabled produce autorización reducida inmediatamente desde el commit DB. El JWT residual no conserva `COMPANY_ADMIN` porque el role autoritativo se resuelve nuevamente desde PostgreSQL.

### 10.4 Resultado de application layer

El resultado de negocio de una mutación confirmada no depende de provider termination.

La application layer puede afirmar:

```text
membership change confirmed
current authorization state updated
```

No debe afirmar:

```text
all provider sessions destroyed
```

cuando el contrato vigente no permite demostrarlo.

---

## 11. Arquitectura de la frontera atómica

### 11.1 Alternativas evaluadas

#### A. Dos llamadas independientes desde application layer

Ejemplo conceptual:

```text
update membership
then
insert AuditEvent
```

**RECHAZADA.**

No garantiza atomicidad frente a error, timeout, crash o carrera entre ambas operaciones.

#### B. Transacción mediante nueva infraestructura/driver server-side

**NO SELECCIONADA.**

Introduciría una nueva frontera de conexión/transacción no necesaria cuando Supabase/PostgreSQL ya permite encapsular la operación en una función invocable por RPC.

#### C. Trigger de auditoría

**NO SELECCIONADA.**

Un trigger de bajo nivel conoce la mutación pero no representa por sí solo, de forma suficientemente explícita, el contrato de autorización funcional, self-target, tenant derivado, continuidad administrativa y no-op. También ampliaría la auditoría a writes no pertenecientes al caso de uso si surgieran writers privilegiados.

#### D. PostgreSQL function / RPC purpose-specific

**SELECCIONADA.**

Permite:

- una sola transacción PostgreSQL;
- actor derivado desde `auth.uid()`;
- revalidación autoritativa dentro de la misma frontera;
- acceso al target disabled aunque la RLS ordinaria lo oculte;
- serialización de concurrencia;
- mutación + `AuditEvent` atómicos;
- cero escrituras directas para `authenticated`;
- consumo mediante caller-scoped Supabase client;
- ausencia de `service-role` como writer ordinario.

### 11.2 Función/RPC seleccionada

Nombre físico propuesto para revisión:

```text
public.apply_company_membership_lifecycle
```

La futura implementación puede ajustar únicamente el identificador físico si el preflight demuestra una convención canónica incompatible, sin alterar el contrato. Un cambio semántico requiere revisión humana.

### 11.3 Inputs

Inputs máximos permitidos:

```text
target_company_membership_id
operation
requested_role  // sólo para CHANGE_ROLE
```

`operation` queda restringida conceptualmente a:

```text
DISABLE
REINSTATE
CHANGE_ROLE
```

`requested_role` queda restringido a:

```text
COMPANY_ADMIN
TECHNICIAN
```

No se acepta:

- actor ID;
- actor membership ID;
- `maintenance_company_id`;
- current role;
- current enabled state;
- target `PlatformUser` como autoridad;
- expected version;
- expected role;
- expected `is_enabled`;
- AuditEvent fields;
- occurred_at;
- actor_kind;
- role_before/after;
- tenant claim.

### 11.4 Output conceptual

La función devuelve un resultado mínimo equivalente a:

```text
outcome = APPLIED | ALREADY_SATISFIED | DENIED
changed = true | false
reason = bounded non-sensitive reason
```

Reglas:

```text
APPLIED → changed = true
ALREADY_SATISFIED → changed = false
DENIED → changed = false
```

No se devuelve tenant ID ajeno, información sobre una target cross-tenant ni detalles que creen una oracle de enumeración.

Target inexistente y target no autorizable/cross-tenant pueden mapearse al mismo resultado opaco desde application layer.

### 11.5 Trust boundary

La función es:

```text
purpose-specific
SECURITY DEFINER
caller identity = auth.uid() only
service-role client = NO
generic privileged client = NO
generic SQL mutation = NO
```

### 11.6 `search_path`

Hardening obligatorio:

- `search_path` fijo y no manipulable por caller;
- sólo schemas requeridos y seguros;
- objetos de aplicación referenciados de forma no ambigua/schema-qualified;
- no dependencia de objetos resolubles desde schemas caller-writable;
- no dynamic SQL salvo necesidad material revisada; baseline esperado = `NONE`.

### 11.7 EXECUTE

Debe preservarse:

```text
PUBLIC EXECUTE = NO
anon EXECUTE = NO
authenticated EXECUTE = mínimo necesario sobre firma exacta
```

El grant de `EXECUTE` no concede privilegios directos sobre `company_memberships` ni `audit_events`.

### 11.8 Actor derivado

Dentro de la transacción:

```text
auth.uid()
→ platform_user_auth_subjects
→ PlatformUser
→ current CompanyMembership
→ MaintenanceCompany
→ current role
```

La función exige:

```text
actor membership exists
actor membership.is_enabled = true
actor membership.role = COMPANY_ADMIN
actor PlatformUser.is_super_admin = false
```

Si `is_super_admin = true` y existe membership:

```text
INCONSISTENT
→ DENY
```

### 11.9 Target autoritativo

El target se resuelve desde `target_company_membership_id` y PostgreSQL.

Debe verificarse:

```text
target exists
actor tenant = target tenant
target PlatformUser exists
target PlatformUser is not inconsistent global+tenant identity
```

La función no confía en tenant del caller.

### 11.10 Frontera transaccional

Una ejecución de la función corresponde a una única transacción PostgreSQL para:

```text
resolve/revalidate actor
+
serialize tenant lifecycle mutation
+
resolve/revalidate target
+
check invariants
+
possibly mutate CompanyMembership
+
possibly INSERT required AuditEvent
```

No contiene llamadas HTTP, llamadas Supabase Auth provider-side ni cualquier otra I/O externa.

---
## 12. Serialización, locking y TOCTOU

### 12.1 Estrategia mínima seleccionada

Todas las mutaciones funcionales TASK-015 de una misma `MaintenanceCompany` deben coordinarse mediante un lock transaccional común sobre la fila autoritativa del tenant antes de decidir la transición final.

Secuencia conceptual:

```text
1. resolve preliminary actor from auth.uid()
2. derive preliminary actor tenant
3. acquire transaction-scoped row lock on that MaintenanceCompany
4. re-resolve actor and current authority after lock
5. resolve/lock target membership
6. re-evaluate target role/is_enabled and all invariants
7. apply DECISION-005 if already satisfied
8. apply DECISION-003 admin-continuity check
9. mutate when valid
10. insert exact AuditEvent when mutation is real
11. commit once
```

La lectura previa al lock sirve únicamente para localizar el tenant candidate. No constituye autorización final.

### 12.2 Por qué lock por tenant

Bloquear sólo el target no protege la invariante de último administrador cuando dos transacciones actúan sobre targets diferentes.

Una fila común de `MaintenanceCompany` proporciona una serialización mínima, simple y bounded por tenant:

```text
same tenant lifecycle mutations
→ same coordination row
→ ordered reevaluation
```

No se adopta lock global de plataforma.

### 12.3 Revalidación post-lock

Después de adquirir el lock del tenant debe volver a comprobarse:

- `auth.uid()` resolvible;
- `PlatformUser` vigente;
- ausencia de dual global+tenant authority;
- actor membership existente;
- actor membership enabled;
- actor role actual = `COMPANY_ADMIN`;
- actor tenant;
- target existencia;
- target tenant;
- target role;
- target `is_enabled`;
- self-target rules;
- admin continuity;
- desired state.

Ningún valor resuelto antes del lock puede utilizarse para omitir esta reevaluación.

### 12.4 Misma membership

El target debe quedar bloqueado dentro de la transacción durante la evaluación/mutación para que dos operaciones sobre la misma membership no materialicen decisiones tomadas sobre estados diferentes.

### 12.5 No expected-state token

No se añade:

```text
expected_version
expected_role
expected_is_enabled
ETag de dominio
```

El producto resolvió que la operación se reevalúa contra el estado PostgreSQL vigente.

---

## 13. Demostración de continuidad administrativa bajo concurrencia

### 13.1 Caso obligatorio

Estado inicial:

```text
Tenant T
Admin A: enabled COMPANY_ADMIN
Admin B: enabled COMPANY_ADMIN
```

Requests concurrentes:

```text
R1: actor B → disable A
R2: actor A → disable B
```

### 13.2 Ejecución válida

Ambas requests pueden resolver preliminarmente el mismo tenant, pero sólo una obtiene primero el lock de `MaintenanceCompany T`.

Supóngase R1 primero:

```text
R1 acquires tenant lock
R1 revalidates B = enabled COMPANY_ADMIN
R1 sees A enabled COMPANY_ADMIN
R1 sees enabled-admin count = 2
R1 disables A
R1 inserts USER_DISABLED_OR_REVOKED
R1 commits
```

R2 adquiere el lock después del commit y debe revalidar:

```text
actor A is now disabled
→ actor authority lost
→ DENY
→ no mutation
→ no AuditEvent
```

Resultado:

```text
B remains enabled COMPANY_ADMIN
enabled COMPANY_ADMIN count = 1
```

Si R2 gana primero, el resultado es simétrico.

### 13.3 Variante con actores distintos

En un tenant con tres o más administradores, dos operaciones destructivas ejecutadas por otro administrador también quedan serializadas. Cada transacción calcula la continuidad después de todos los commits previos y no puede confirmar una transición cuyo prospective state produzca cero administradores habilitados.

### 13.4 Propiedad verificable

Debe demostrarse con dos conexiones/transacciones realmente concurrentes. Una prueba secuencial no satisface este requisito.

---

## 14. AuditEvent mapping

TASK-015 consume sin modificar el contrato físico de TASK-010.

### 14.1 Campos canónicos

```text
id
maintenance_company_id
actor_kind
actor_platform_user_id
actor_internal_process_key
action
occurred_at
scope_kind
subject_platform_user_id
role_before
role_after
```

### 14.2 Actor

Todas las operaciones TASK-015 son user-originated:

```text
actor_kind = PLATFORM_USER
actor_platform_user_id = current authoritative actor PlatformUser
actor_internal_process_key = NULL
```

Que una función `SECURITY DEFINER` ejecute técnicamente el write no cambia el actor histórico.

### 14.3 Tenant

```text
maintenance_company_id = actor/target same tenant derived from PostgreSQL
```

Nunca se toma desde request.

### 14.4 Scope y subject

Para las tres acciones:

```text
scope_kind = USER
subject_platform_user_id = target membership PlatformUser
```

### 14.5 OP-01

Cambio real:

```text
action = USER_DISABLED_OR_REVOKED
role_before = NULL
role_after = NULL
```

### 14.6 OP-02

Cambio real:

```text
action = USER_REINSTATED
role_before = NULL
role_after = NULL
```

### 14.7 OP-03

Cambio real:

```text
action = USER_ROLE_CHANGED
role_before = authoritative previous role
role_after = authoritative new role
role_before != role_after
```

### 14.8 `occurred_at`

El caller no aporta tiempo autoritativo.

El evento utiliza el mecanismo PostgreSQL vigente aprobado por TASK-010, preferentemente su `DEFAULT` autoritativo dentro de la frontera confiable.

### 14.9 ID de evento

El identificador del `AuditEvent` se genera dentro de la frontera confiable utilizando el mecanismo UUID ya disponible y aprobado en el repositorio real.

No se acepta un AuditEvent ID desde frontend como parte del contrato TASK-015.

### 14.10 No-op y deny

```text
changed = false
→ AuditEvent = NONE

DENY
→ AuditEvent = NONE
```

TASK-015 no crea eventos falsos para intents que no produjeron una mutación real.

---

## 15. Atomicidad

### 15.1 Propiedad

Para toda transición real:

```text
membership mutation committed
IFF
required AuditEvent committed
```

### 15.2 Consecuencias

Son estados imposibles para un resultado exitoso:

```text
membership changed + AuditEvent missing
AuditEvent committed + membership mutation missing
```

### 15.3 Error al insertar auditoría

Si el `AuditEvent` no puede persistirse por FK, CHECK, privilege, error interno o cualquier otra causa:

```text
function raises/fails
→ entire transaction rolls back
→ membership remains at pre-call state
```

### 15.4 Error de mutación

Si la mutación de membership falla:

```text
AuditEvent does not survive
```

### 15.5 No external transaction participant

Supabase Auth no participa en esta transacción.

No se intenta implementar distributed transaction, saga, two-phase commit ni compensación entre PostgreSQL y Auth provider.

---

## 16. OP-01 — DISABLE / REVOKE MEMBERSHIP

### 16.1 Intención

Cambiar:

```text
target.is_enabled = true
→ false
```

sin eliminar `PlatformUser`, membership ni historial.

### 16.2 Precondiciones

- Auth subject actual validable server-side;
- actor resolvible a `PlatformUser`;
- actor no es `SUPER_ADMIN` global;
- actor no está en estado global+membership inconsistente;
- actor posee `CompanyMembership` enabled;
- actor role actual = `COMPANY_ADMIN`;
- target membership existe;
- target pertenece al mismo tenant;
- target no está en estado global+tenant inconsistente;
- target != actor membership;
- continuidad administrativa preservada si el target es un admin enabled.

### 16.3 Self-target

```text
actor_membership_id = target_membership_id
→ DENY
→ changed = false
→ no mutation
→ no AuditEvent
```

### 16.4 Already disabled

Después de todas las validaciones aplicables:

```text
target.is_enabled = false
→ ALREADY_SATISFIED
→ changed = false
→ no mutation
→ no AuditEvent
```

### 16.5 Admin continuity

Si target es:

```text
is_enabled = true
role = COMPANY_ADMIN
```

la función debe calcular el prospective enabled-admin count bajo la serialización tenant.

Si resultaría cero:

```text
DENY
→ no mutation
→ no AuditEvent
```

### 16.6 Mutación real

Si es válida:

```text
is_enabled = false
role unchanged
```

más exactamente un:

```text
USER_DISABLED_OR_REVOKED
```

en la misma transacción.

### 16.7 Authorization effect

Desde el commit:

```text
target tenant authorization = DENIED
```

sin esperar logout, token refresh o `exp`.

### 16.8 Provider effect

```text
provider-side termination = UNSUPPORTED
provider call = NONE
```

El resultado DB confirmado permanece success aunque el provider conserve técnicamente sesiones/refresh credentials.

### 16.9 Efectos ausentes

OP-01 no:

- borra user;
- borra membership;
- cambia role;
- borra historial;
- borra datos offline;
- cambia client scope;
- modifica `is_super_admin`;
- crea session;
- manipula `auth.sessions`.

---

## 17. OP-02 — REINSTATE MEMBERSHIP

### 17.1 Intención

Cambiar:

```text
target.is_enabled = false
→ true
```

conservando el role vigente en PostgreSQL.

### 17.2 Precondiciones

Mismas reglas de actor y same-tenant que OP-01, excepto que no existe prohibición general de self-target de reinstate.

Un actor disabled no puede ejecutar la operación porque falla la autorización antes de considerar target.

### 17.3 Self-reinstate

No existe bypass:

```text
disabled actor
→ cannot become authorized actor
→ DENY before mutation
```

Un actor enabled que apunta a su propia membership ya enabled cae únicamente, después de autorización, en DECISION-005:

```text
ALREADY_SATISFIED
changed = false
```

No se inventa una excepción funcional adicional.

### 17.4 Already enabled

Después de validaciones:

```text
target.is_enabled = true
→ ALREADY_SATISFIED
→ changed = false
→ no mutation
→ no AuditEvent
```

### 17.5 Mutación real

```text
is_enabled = true
role = current authoritative role, unchanged
```

más exactamente un:

```text
USER_REINSTATED
```

atómico.

### 17.6 Role vigente

La reintegración no recupera un role histórico anterior.

Usa exactamente:

```text
company_memberships.role
```

vigente al momento post-lock.

### 17.7 Provider effect

```text
provider-side termination = NOT APPLICABLE
provider call = NONE
```

OP-02 no crea ni restaura una sesión provider-side; sólo restaura autorización tenant si existe autenticación válida.

### 17.8 Efectos ausentes

OP-02 no:

- cambia role;
- crea Auth user;
- resetea password;
- envía VerificationChallenge;
- concede client scope;
- modifica global authority.

---

## 18. OP-03 — CHANGE MEMBERSHIP ROLE

### 18.1 Intención

Cambiar el role tenant entre:

```text
COMPANY_ADMIN
TECHNICIAN
```

### 18.2 Precondiciones

- actor actual autorizado como `COMPANY_ADMIN` enabled;
- actor no inconsistente global+tenant;
- target same tenant;
- target no inconsistente global+tenant;
- requested role válido;
- target != actor membership;
- admin continuity preservada cuando corresponda.

### 18.3 Self-role-change

Siempre:

```text
actor_membership_id = target_membership_id
→ DENY
```

Esto tiene precedencia sobre same-role no-op.

### 18.4 Same-role

Para target no-self y después de validaciones:

```text
requested_role = current role
→ ALREADY_SATISFIED
→ changed = false
→ no mutation
→ no AuditEvent
```

### 18.5 Enabled COMPANY_ADMIN → TECHNICIAN

Si target está enabled, esta transición reduce autoridad y debe preservar continuidad administrativa.

Si dejaría cero admins enabled:

```text
DENY
```

Si es válida:

```text
role = TECHNICIAN
is_enabled unchanged = true
USER_ROLE_CHANGED atomically
provider-side termination = UNSUPPORTED
```

### 18.6 Enabled TECHNICIAN → COMPANY_ADMIN

```text
role = COMPANY_ADMIN
is_enabled remains true
USER_ROLE_CHANGED atomically
provider-side termination = NOT APPLICABLE
```

### 18.7 Disabled COMPANY_ADMIN → TECHNICIAN

Permitido:

```text
role = TECHNICIAN
is_enabled remains false
USER_ROLE_CHANGED atomically
provider-side termination = NOT APPLICABLE
```

No restaura autoridad.

### 18.8 Disabled TECHNICIAN → COMPANY_ADMIN

Permitido:

```text
role = COMPANY_ADMIN
is_enabled remains false
USER_ROLE_CHANGED atomically
provider-side termination = NOT APPLICABLE
```

No concede autoridad hasta una futura reintegración válida.

### 18.9 Reintegration after disabled role change

Caso obligatorio:

```text
disabled COMPANY_ADMIN
→ CHANGE_ROLE TECHNICIAN
→ still disabled
→ REINSTATE
→ enabled TECHNICIAN
```

La reintegración no puede restaurar `COMPANY_ADMIN` por historia previa.

---

## 19. Authorization matrix

| Actor/target condition | OP-01 | OP-02 | OP-03 | Motivo |
|---|---|---|---|---|
| enabled `COMPANY_ADMIN`, same tenant, valid target | `ALLOW` sujeto a invariantes | `ALLOW` | `ALLOW` | capability determinada |
| enabled `TECHNICIAN` | `DENY` | `DENY` | `DENY` | role insuficiente |
| actor membership disabled | `DENY` | `DENY` | `DENY` | no current tenant authority |
| actor sin membership | `DENY` | `DENY` | `DENY` | authenticated != authorized |
| actor unresolved | `DENY` | `DENY` | `DENY` | fail-closed |
| actor `SUPER_ADMIN` global-only | `DENY` | `DENY` | `DENY` | no tenant bypass |
| actor global+membership inconsistente | `DENY` | `DENY` | `DENY` | TASK-014 fail-closed |
| target same tenant | evaluable | evaluable | evaluable | target ID no es autoridad pero puede localizar target |
| target other tenant | `DENY/opaque` | `DENY/opaque` | `DENY/opaque` | aislamiento + anti-oracle |
| target inexistente | `DENY/opaque` | `DENY/opaque` | `DENY/opaque` | fail-closed |
| target global+membership inconsistente | `DENY` | `DENY` | `DENY` | no reparación por TASK-015 |
| target enabled TECHNICIAN | real disable | no-op reinstate | role change permitido | según desired state |
| target disabled TECHNICIAN | no-op disable | real reinstate | role change permitido | DECISION-004/005 |
| target enabled COMPANY_ADMIN | disable sujeto continuidad | no-op reinstate | demotion sujeto continuidad | DECISION-003 |
| target disabled COMPANY_ADMIN | no-op disable | real reinstate | role change permitido | reinstate conserva role vigente |
| self target OP-01 | `DENY` | n/a como bypass | n/a | DECISION-001 |
| self target OP-03 | n/a | n/a | `DENY` | DECISION-002 |
| enabled actor self-target OP-02 | n/a | no-op `ALLOW` si ya enabled | n/a | DECISION-005; no privilege escalation |
| disabled actor self-target OP-02 | n/a | `DENY` | n/a | actor no autorizado |
| requested role `COMPANY_ADMIN` | n/a | n/a | válido | role tenant aprobado |
| requested role `TECHNICIAN` | n/a | n/a | válido | role tenant aprobado |
| requested role distinto | n/a | n/a | `DENY / INVALID INPUT` | no role custom |
| operation dejaría 0 admins enabled | `DENY` | no aplica | `DENY` si demotion destructiva | DECISION-003 |
| desired state ya satisfecho tras checks | no-op success | no-op success | no-op success salvo self-role-change | DECISION-005 |

No existe combinación en la que `SUPER_ADMIN` obtenga esta capability por autoridad global.

---

## 20. RLS y privilegios

### 20.1 RLS continúa obligatoria

TASK-015 no debilita la estrategia de RLS de datos tenant-owned.

### 20.2 `company_memberships`

Las policies ordinarias vigentes continúan sin conceder `INSERT`, `UPDATE` ni `DELETE` normal a `authenticated`.

TASK-015 no añade una policy general de escritura.

### 20.3 `audit_events`

Debe preservarse el contrato de TASK-010:

```text
RLS enabled
anon table privileges = NONE
authenticated table privileges = NONE
normal SELECT = NO
normal INSERT = NO
normal UPDATE = NO
normal DELETE = NO
normal TRUNCATE = NO
```

TASK-015 no abre una write policy sobre `audit_events`.

### 20.4 Controlled privileged boundary

La función `SECURITY DEFINER` posee exclusivamente el privilegio técnico necesario para leer estados normalmente ocultos y ejecutar las tres mutaciones acotadas con su auditoría.

Debe reconstruir dentro de sí:

- actor;
- membership;
- tenant;
- role;
- global inconsistency;
- target;
- same-tenant;
- transition;
- admin continuity.

### 20.5 No bypass

```text
SECURITY DEFINER
!= generic tenant bypass
!= service-role
!= authorized by caller tenant ID
```

### 20.6 Policies nuevas

```text
new RLS policy required = NO
```

Los cambios de privilege previstos se limitan al `EXECUTE` exacto de la function/RPC y sus revokes correspondientes.

---
## 21. Service-role y fronteras privilegiadas

### 21.1 Regla

TASK-015 no utiliza `service-role` ni `secret` key como cliente ordinario de aplicación para mutar `CompanyMembership` o escribir `AuditEvent`.

### 21.2 Caller-scoped invocation

La application boundary debe invocar el RPC mediante un cliente Supabase caller-scoped que preserve el Auth subject actual y permita a PostgreSQL resolver:

```text
auth.uid()
```

### 21.3 Prohibiciones

No se permite:

- server repository genérico con `service-role`;
- función genérica `update_any_membership`;
- endpoint que acepte actor/tenant/role como autoridad;
- generic audit writer;
- generic SQL executor;
- Admin Auth API como sustituto de autorización tenant;
- secret key expuesta al browser;
- route handler que ejecute writes directos fuera del RPC.

### 21.4 Supabase Auth admin secret

Aunque el contrato oficial de `auth.admin` exige secret key, TASK-015 no necesita introducirla porque la termination aplicable al target es `UNSUPPORTED` bajo el contrato vigente.

Por tanto:

```text
new Auth admin secret dependency for TASK-015 = NO
```

---

## 22. Application/use-case boundary

### 22.1 Responsabilidad

La capa de aplicación recibe una intención del caller autenticado y coordina la llamada al RPC.

Puede realizar validaciones sintácticas tempranas, pero no es la autoridad final para:

- tenant;
- actor role;
- actor enabled state;
- target tenant;
- target role;
- target enabled state;
- admin continuity.

### 22.2 TASK-012

TASK-015 reutiliza/respetará la foundation de TASK-012 para el patrón:

```text
validated Auth subject
→ current tenant authorization context
```

Sin embargo:

```text
application pre-resolution
!= final mutation authorization
```

La función vuelve a derivar y revalidar autoridad dentro de la transacción para cerrar TOCTOU.

### 22.3 TASK-014

La application boundary no puede transformar una resolución global `SUPER_ADMIN` en permiso tenant.

La función debe negar dual-authority inconsistency aun si otra capa hubiera producido estado stale.

### 22.4 Input validation

La aplicación puede rechazar antes del RPC:

- operation desconocida;
- UUID sintácticamente inválido;
- role no perteneciente a `COMPANY_ADMIN | TECHNICIAN`.

Estas validaciones son defensa/UX y no sustituyen checks internos.

### 22.5 Response mapping

Conceptualmente:

```text
APPLIED
→ success, changed=true

ALREADY_SATISFIED
→ success, changed=false

DENIED
→ failure, changed=false
```

No se fijan códigos HTTP concretos, Server Action vs Route Handler ni shape JSON definitivo en esta especificación.

---

## 23. Failure model

### 23.1 Auth subject ausente o inválido

```text
DENY
no mutation
no AuditEvent
```

### 23.2 PlatformUser no resoluble

```text
DENY
```

### 23.3 Actor sin membership

```text
DENY
```

### 23.4 Actor membership disabled

```text
DENY
```

### 23.5 Actor role TECHNICIAN

```text
DENY
```

### 23.6 Actor global-only SUPER_ADMIN

```text
DENY
```

### 23.7 Actor global+tenant inconsistent

```text
DENY / FAIL CLOSED
```

### 23.8 Target inexistente

```text
DENY / opaque target failure
```

### 23.9 Target cross-tenant

```text
DENY / same externally safe class as unavailable target
```

La respuesta no debe confirmar que el target existe en otro tenant.

### 23.10 Target inconsistent global+tenant

```text
DENY
```

TASK-015 no repara esa identidad.

### 23.11 Self-disable

```text
DENY
```

### 23.12 Self-role-change

```text
DENY
```

### 23.13 Last admin

```text
DENY
reason may be ADMIN_CONTINUITY_REQUIRED for same-tenant authorized actor
```

### 23.14 Invalid role

```text
DENY / INVALID INPUT
```

### 23.15 Already satisfied

Sólo después de autorización/invariantes:

```text
success
changed=false
no AuditEvent
```

### 23.16 DB error

Cualquier error no clasificado dentro de la transacción:

```text
fail closed
rollback
no partial state
```

### 23.17 Lock wait / transaction abort

Un lock timeout, deadlock victim, serialization-related abort o error equivalente:

```text
operation not confirmed
no partial success may be reported
```

La application layer puede permitir un retry explícito del mismo desired-state request. DECISION-005 evita duplicar el evento si la primera ejecución sí había confirmado y sólo se perdió la respuesta.

### 23.18 Provider failure

No existe provider call en el contrato vigente de TASK-015.

Si una revisión futura incorpora una primitive soportada:

```text
provider timeout/error after DB commit
→ DB success remains success
→ authorization remains based on PostgreSQL
```

---

## 24. Idempotency, retries y replay

### 24.1 No idempotency key

```text
idempotency_key = NOT REQUIRED
```

No existe necesidad independiente demostrada para introducir un campo o tabla de idempotencia.

### 24.2 Lost response

Ejemplo:

```text
request disable target
→ DB mutation + AuditEvent commit
→ network response lost
→ caller retries disable
```

Segundo intento:

```text
authorize again
target already disabled
→ changed=false
→ no second AuditEvent
```

### 24.3 Concurrent duplicate requests

La serialización tenant hace que:

```text
first valid request → changed=true + one event
second request after lock → changed=false + zero new events
```

### 24.4 Opposing intents

Requests distintas, por ejemplo:

```text
disable target
reinstate target
```

no se consideran el mismo intento lógico. Se ordenan por el lock y cada una reevalúa el estado actual. Si ambas siguen autorizadas, pueden producir dos mutaciones reales y dos eventos en orden de commit.

### 24.5 Same role after intervening change

Un retry no posee identidad durable propia. Si otra operación cambió el estado entre intentos, el nuevo request se evalúa contra el estado vigente y puede convertirse nuevamente en una mutación real.

Esto es coherente con DECISION-006 y la ausencia aprobada de expected-state token.

---

## 25. Threat model

| Amenaza | Vector | Riesgo | Control TASK-015 | Resultado esperado |
|---|---|---|---|---|
| Tenant spoofing | caller envía tenant ajeno | cross-tenant write | tenant no es input de autoridad; se deriva DB | DENY |
| Actor spoofing | caller envía actor ID | impersonation | actor sólo desde `auth.uid()` | input ignorado/no existe |
| Role spoofing | JWT/frontend afirma COMPANY_ADMIN | privilege escalation | role actual desde membership post-lock | DENY si DB no admin |
| Disabled actor stale JWT | JWT válido tras disable | revoked access | revalidación DB | DENY |
| Cross-tenant target oracle | membership UUID ajeno | enumeración | respuesta opaca + same-tenant internal check | no existencia confirmada |
| Self-disable | admin apunta a sí mismo | pérdida autoridad propia no aprobada | explicit self check | DENY |
| Self-role-change | admin demotion/promote self | authority mutation no aprobada | explicit self check | DENY |
| Last-admin race | dos admins se deshabilitan mutuamente | tenant sin admin | tenant row lock + post-lock reevaluation | sólo una destructiva puede confirmar |
| Same-target race | operaciones simultáneas | stale decision | tenant + target lock | reevaluate ordered state |
| No-op audit fabrication | request ya satisfecha | historial falso | `changed=false → no event` | zero event |
| Audit omission | mutation succeeds, event fails | loss of trace | same DB transaction | rollback mutation |
| Orphan audit | event succeeds, mutation fails | false history | same DB transaction | rollback event |
| Direct membership UPDATE | authenticated calls Data API | bypass use-case | existing no-write RLS/privileges | DENY |
| Direct audit INSERT | authenticated forges event | audit tampering | zero table privilege | DENY |
| SECURITY DEFINER confused deputy | arbitrary target/tenant/operation | privilege escalation | narrow inputs + auth.uid + same tenant + fixed operation set | DENY |
| search_path injection | shadowed object | privilege hijack | fixed safe path + qualified refs | no shadow resolution |
| PUBLIC execution | anonymous invokes RPC | unauthorized mutation | revoke PUBLIC/anon execute | DENY |
| Generic service-role client | server path bypasses RLS | transversal bypass | prohibited | absent |
| SUPER_ADMIN tenant bypass | global actor invokes lifecycle | tenant escalation | global-only DENY; dual state DENY | DENY |
| Disabled target hidden by RLS | ordinary SELECT cannot see target | incorrect no-op/error | narrow definer lookup | authoritative target resolution |
| Role change disabled then reinstate | old admin role accidentally restored | privilege resurrection | reinstate uses current role | new role preserved |
| Residual provider JWT | token remains valid to `exp` | stale authorization | current DB state primary | DENY after revocation |
| Refresh token remains viable | unsupported target termination | continuing authentication | authentication != authorization | DB still DENY |
| Replay after lost response | duplicate request | duplicate AuditEvent | desired-state no-op | one event total |
| Malformed operation/role | crafted RPC params | generic mutation | whitelist + fail-closed | DENY |
| Provider workaround | direct `auth.sessions`/ban/password | unsupported behavior | explicitly forbidden | absent |

---

## 26. Offline behavior

### 26.1 Online-only administrative write

TASK-015 does not authorize offline administrative mutation.

```text
OP-01 / OP-02 / OP-03 = ONLINE-ONLY
```

### 26.2 No outbox

No se crean:

- offline lifecycle intent;
- Dexie entity;
- outbox item;
- local optimistic authority mutation;
- offline admin conflict protocol.

### 26.3 Connectivity loss after submit

Si el cliente pierde la respuesta:

- no debe asumir success ni failure sin evidencia;
- puede refrescar/reintentar al recuperar conectividad;
- DECISION-005 proporciona retry seguro para desired state ya confirmado.

### 26.4 Revocation and local data

Deshabilitar una membership no autoriza TASK-015 a borrar trabajo o datos offline existentes.

Se preserva la estrategia general:

```text
authorization revocation != local data destruction
```

El acceso local posterior se rige por la estrategia offline general y fases futuras, no por este slice.

---

## 27. UI contract

TASK-015 no necesita crear una nueva superficie completa de administración de usuarios para satisfacer su boundary backend. Sin embargo, cualquier UI presente o futura que consuma estas operaciones debe respetar este contrato.

### 27.1 Autoridad UI

La UI:

```text
may guide
must not authorize
```

Ocultar/deshabilitar controles no sustituye el RPC.

### 27.2 Online state

Los controles de lifecycle deben requerir conectividad. No se debe presentar una mutación offline como confirmada.

### 27.3 Self target

La UI puede ocultar/deshabilitar:

- disable propio;
- role-change propio.

El servidor debe negar aunque la UI sea bypassed.

### 27.4 Last admin

La UI puede advertir si conoce el estado, pero no puede decidir autoritativamente que la operación es segura.

El servidor puede devolver una razón funcional equivalente a:

```text
ADMIN_CONTINUITY_REQUIRED
```

para un actor same-tenant ya autorizado.

### 27.5 Disabled target role change

La UI debe poder representar:

```text
role changed
membership still disabled
```

sin sugerir que el usuario fue reintegrado.

### 27.6 No-op

Ante `changed=false`, la UI debe tratar la intención como satisfecha y refrescar/usar estado autoritativo, sin mostrar un evento de auditoría ficticio.

### 27.7 Provider session wording

Tras disable o demotion, la UI puede afirmar que el acceso tenant fue retirado/cambiado.

No debe afirmar “todas las sesiones de Supabase fueron cerradas” bajo el contrato provider vigente.

### 27.8 Cross-tenant errors

La UI no debe mostrar detalles que confirmen que un UUID corresponde a una membership de otro tenant.

---

## 28. Requisitos funcionales TASK-015

**RF-015-001.** TASK-015 DEBE implementar OP-01, OP-02 y OP-03 como únicas operaciones funcionales del incremento.

**RF-015-002.** El actor DEBE derivarse exclusivamente de un Auth subject actual validado y del estado PostgreSQL vigente.

**RF-015-003.** El actor DEBE resolver a un `PlatformUser` existente.

**RF-015-004.** El actor DEBE poseer una `CompanyMembership` vigente y enabled.

**RF-015-005.** El actor DEBE poseer role vigente `COMPANY_ADMIN`.

**RF-015-006.** Una sesión Auth válida por sí sola NO DEBE autorizar ninguna operación TASK-015.

**RF-015-007.** `TECHNICIAN` NO DEBE ejecutar OP-01, OP-02 ni OP-03.

**RF-015-008.** `SUPER_ADMIN` global-only NO DEBE ejecutar las operaciones por bypass.

**RF-015-009.** Estado global+membership inconsistente DEBE fallar cerrado.

**RF-015-010.** El caller PUEDE aportar sólo un identificador de target membership y los parámetros propios de la transición.

**RF-015-011.** El tenant real del actor y target DEBE derivarse desde PostgreSQL.

**RF-015-012.** Actor y target DEBEN pertenecer al mismo tenant.

**RF-015-013.** Target inexistente o cross-tenant DEBE fallar cerrado sin oracle innecesaria.

**RF-015-014.** OP-01 DEBE prohibir self-disable/self-revoke.

**RF-015-015.** OP-03 DEBE prohibir self-role-change.

**RF-015-016.** Un actor disabled NO DEBE usar OP-02 para self-reinstate.

**RF-015-017.** OP-01 real DEBE cambiar `is_enabled` de true a false sin cambiar role.

**RF-015-018.** OP-02 real DEBE cambiar `is_enabled` de false a true sin cambiar role.

**RF-015-019.** OP-03 real DEBE cambiar exclusivamente role entre `COMPANY_ADMIN` y `TECHNICIAN`.

**RF-015-020.** OP-03 sobre target disabled DEBE estar permitido cuando las demás invariantes se cumplen.

**RF-015-021.** OP-03 sobre target disabled NO DEBE modificar `is_enabled`.

**RF-015-022.** Reintegration posterior DEBE utilizar el role vigente en PostgreSQL, no un role histórico previo.

**RF-015-023.** Ninguna operación TASK-015 DEBE dejar el tenant con cero `COMPANY_ADMIN` enabled cuando el tenant posee administración activa.

**RF-015-024.** Una operación que violaría continuidad administrativa DEBE ser denegada sin mutación ni AuditEvent.

**RF-015-025.** Disable sobre disabled, tras autorización completa, DEBE retornar idempotent success con `changed=false`.

**RF-015-026.** Reinstate sobre enabled, tras autorización completa, DEBE retornar idempotent success con `changed=false`.

**RF-015-027.** Same-role sobre target no-self, tras autorización completa, DEBE retornar idempotent success con `changed=false`.

**RF-015-028.** Un no-op autorizado NO DEBE producir AuditEvent.

**RF-015-029.** Una denegación NO DEBE producir AuditEvent.

**RF-015-030.** OP-01 real DEBE producir exactamente `USER_DISABLED_OR_REVOKED`.

**RF-015-031.** OP-02 real DEBE producir exactamente `USER_REINSTATED`.

**RF-015-032.** OP-03 real DEBE producir exactamente `USER_ROLE_CHANGED`.

**RF-015-033.** Cada mutación real DEBE producir exactamente un AuditEvent en la misma transacción.

**RF-015-034.** OP-03 DEBE registrar `role_before` y `role_after` autoritativos y distintos.

**RF-015-035.** OP-01/02 NO DEBEN poblar `role_before` ni `role_after`.

**RF-015-036.** El actor histórico DEBE ser el `PlatformUser` que originó la request, no el proceso técnico.

**RF-015-037.** `occurred_at` DEBE derivarse desde frontera PostgreSQL confiable, no desde cliente.

**RF-015-038.** Operaciones concurrentes DEBEN reevaluar actor y target después de coordinación suficiente.

**RF-015-039.** La implementación NO DEBE exigir expected-state/version token del caller.

**RF-015-040.** Provider-side termination NO DEBE ser condición para confirmar la revocación DB.

**RF-015-041.** Bajo el contrato Supabase verificado, OP-01 real DEBE clasificarse provider-side como `UNSUPPORTED`, sin workaround.

**RF-015-042.** Demotion enabled `COMPANY_ADMIN→TECHNICIAN` DEBE clasificarse provider-side como `UNSUPPORTED` bajo el contrato vigente.

**RF-015-043.** Reinstate y role promotions/no-ops/disabled role changes NO DEBEN invocar provider termination.

**RF-015-044.** TASK-015 NO DEBE eliminar identidades ni historial.

**RF-015-045.** TASK-015 NO DEBE modificar client scope.

**RF-015-046.** TASK-015 NO DEBE modificar `is_super_admin`.

**RF-015-047.** TASK-015 NO DEBE crear, resetear o mutar credenciales Auth del target.

**RF-015-048.** Las operaciones TASK-015 DEBEN ser online-only.

---
## 29. Requisitos no funcionales

**RNF-015-001.** La solución DEBE permanecer dentro del monolito modular Next.js + Supabase aprobado.

**RNF-015-002.** No DEBE introducir microservicios, queue, worker ni saga para este lifecycle.

**RNF-015-003.** La transacción PostgreSQL DEBE ser breve y no contener I/O externo.

**RNF-015-004.** La coordinación DEBE ser bounded por tenant y no bloquear globalmente todos los tenants.

**RNF-015-005.** La solución DEBE mantener TypeScript estricto en cualquier boundary de aplicación creada.

**RNF-015-006.** La solution DEBE ser purpose-specific y modular dentro de Identity & Authorization.

**RNF-015-007.** La function/RPC NO DEBE convertirse en un generic user-admin writer.

**RNF-015-008.** La semántica de success/no-op/deny DEBE ser determinista frente al mismo estado autoritativo.

**RNF-015-009.** Un retry posterior a respuesta perdida DEBE poder converger sin duplicar AuditEvent cuando el desired state ya quedó satisfecho.

**RNF-015-010.** No se añadirá un índice nuevo sin evidencia física de necesidad; la futura implementación debe inspeccionar plans/datos antes de ampliar índices.

**RNF-015-011.** La solución DEBE ser verificable mediante tests locales y Hosted Development antes de cualquier entorno posterior.

**RNF-015-012.** Mensajes de error cross-tenant DEBEN minimizar filtrado de existencia.

**RNF-015-013.** No se expondrán secrets, JWT target ni credenciales administrativas a browser/logs.

**RNF-015-014.** La provider review DEBE repetirse si al momento de implementar la documentación oficial cambió materialmente.

**RNF-015-015.** Un cambio material del contrato provider NO DEBE incorporarse silenciosamente; debe volver a revisión humana.

**RNF-015-016.** El RPC DEBE mantener output mínimo y no retornar filas arbitrarias.

**RNF-015-017.** La operación no debe depender de clock del navegador.

**RNF-015-018.** La implementación debe preservar compatibilidad con los tests DB/RLS existentes de TASK-009, TASK-010, TASK-012 y TASK-014.

---

## 30. Requisitos de seguridad

**SEC-015-001.** `authenticated != authorized` DEBE permanecer verdadero.

**SEC-015-002.** `auth.uid()` DEBE ser la única fuente de identidad caller dentro del RPC.

**SEC-015-003.** El RPC NO DEBE aceptar actor ID.

**SEC-015-004.** El RPC NO DEBE aceptar tenant ID como autoridad.

**SEC-015-005.** El RPC NO DEBE aceptar current role/is_enabled del cliente.

**SEC-015-006.** Claims JWT de role/tenant NO DEBEN ser autoridad.

**SEC-015-007.** Frontend state, cookies no validadas, path/query/body/header NO DEBEN ser autoridad.

**SEC-015-008.** Actor membership disabled DEBE denegarse aun con JWT técnicamente vigente.

**SEC-015-009.** Actor role stale `COMPANY_ADMIN` en JWT DEBE denegarse si DB vigente es `TECHNICIAN`.

**SEC-015-010.** Same-tenant DEBE comprobarse dentro del RPC.

**SEC-015-011.** Target cross-tenant DEBE denegarse.

**SEC-015-012.** Self-disable DEBE denegarse server-side.

**SEC-015-013.** Self-role-change DEBE denegarse server-side.

**SEC-015-014.** Last-admin invariant DEBE enforcement server-side y concurrency-safe.

**SEC-015-015.** `SUPER_ADMIN` global-only NO DEBE adquirir la capability.

**SEC-015-016.** Global+membership inconsistency DEBE fallar cerrado.

**SEC-015-017.** Target global+membership inconsistency DEBE fallar cerrado y no repararse.

**SEC-015-018.** `SECURITY DEFINER` DEBE utilizar search_path fijo/seguro.

**SEC-015-019.** La función DEBE usar referencias no ambiguas/schema-qualified.

**SEC-015-020.** Dynamic SQL DEBE ser `NONE` salvo nueva necesidad revisada.

**SEC-015-021.** `PUBLIC` NO DEBE poseer EXECUTE.

**SEC-015-022.** `anon` NO DEBE poseer EXECUTE.

**SEC-015-023.** `authenticated` DEBE recibir únicamente EXECUTE sobre la firma purpose-specific necesaria.

**SEC-015-024.** Ningún grant de tabla nuevo a `authenticated` DEBE derivar de TASK-015.

**SEC-015-025.** `service-role` NO DEBE ser caller ordinario del RPC.

**SEC-015-026.** No DEBE existir generic privileged server client para este flow.

**SEC-015-027.** AuditEvent DEBE reflejar actor humano real, no INTERNAL_PROCESS.

**SEC-015-028.** AuditEvent no DEBE aceptar occurred_at del cliente.

**SEC-015-029.** No-op y DENY NO DEBEN producir AuditEvent.

**SEC-015-030.** Toda mutación real DEBE producir su único AuditEvent requerido en la misma transaction.

**SEC-015-031.** Un fallo de AuditEvent DEBE revertir la mutación.

**SEC-015-032.** Un fallo de mutación NO DEBE dejar un AuditEvent confirmado.

**SEC-015-033.** Provider termination failure/unavailability NO DEBE restaurar autorización.

**SEC-015-034.** Access JWT residual NO DEBE conservar role/membership revocados.

**SEC-015-035.** TASK-015 NO DEBE mutar directamente `auth.sessions`.

**SEC-015-036.** TASK-015 NO DEBE usar `ban_duration` como logout.

**SEC-015-037.** TASK-015 NO DEBE cambiar password para simular revocación.

**SEC-015-038.** TASK-015 NO DEBE almacenar JWT de otro usuario.

**SEC-015-039.** Target not-found y cross-tenant DEBEN evitar una oracle innecesaria.

**SEC-015-040.** Lock/coordination DEBE impedir TOCTOU de actor, target y continuidad administrativa.

**SEC-015-041.** La revalidación final DEBE ocurrir después del lock tenant.

**SEC-015-042.** Role change de membership disabled NO DEBE restaurar autoridad.

**SEC-015-043.** Reinstate DEBE utilizar role vigente y no histórico.

**SEC-015-044.** Input operation y requested role DEBEN validarse contra conjuntos cerrados.

**SEC-015-045.** Una necesidad futura de ampliar outputs, targets arbitrarios o generic mutation DEBE detenerse para revisión.

---

## 31. Requisitos RLS/privilegios

**RLS-015-001.** RLS DEBE permanecer habilitada sobre las tablas tenant-owned aplicables.

**RLS-015-002.** `company_memberships` NO DEBE obtener UPDATE policy general para `authenticated`.

**RLS-015-003.** `company_memberships` NO DEBE obtener INSERT/DELETE funcional por TASK-015.

**RLS-015-004.** `audit_events` DEBE conservar RLS habilitada.

**RLS-015-005.** `audit_events` DEBE conservar cero table privileges para `anon`.

**RLS-015-006.** `audit_events` DEBE conservar cero table privileges para `authenticated`.

**RLS-015-007.** TASK-015 NO DEBE añadir SELECT policy de audit log.

**RLS-015-008.** TASK-015 NO DEBE añadir INSERT policy de audit log.

**RLS-015-009.** TASK-015 NO DEBE añadir UPDATE/DELETE policy de audit log.

**RLS-015-010.** El RPC PUEDE utilizar privilegio definer estrictamente para el caso de uso aprobado.

**RLS-015-011.** El privilegio del RPC DEBE reconstruir authorization y same-tenant internamente.

**RLS-015-012.** Conocer `target_company_membership_id` NO DEBE conceder acceso cross-tenant.

**RLS-015-013.** El RPC DEBE poder resolver target disabled sin ampliar su visibilidad por SELECT ordinario.

**RLS-015-014.** `PUBLIC EXECUTE` DEBE estar revocado.

**RLS-015-015.** El grant `authenticated EXECUTE` DEBE limitarse a la firma exacta aprobada.

**RLS-015-016.** No se debe conceder privilege directo a `authenticated` sobre `audit_events` para soportar el RPC.

**RLS-015-017.** No se debe conceder privilege directo de UPDATE sobre `company_memberships` a `authenticated` para soportar el RPC.

**RLS-015-018.** No se debe utilizar service-role para sustituir estas restricciones.

**RLS-015-019.** Existing ordinary membership read semantics para memberships disabled DEBEN permanecer sin ampliación.

**RLS-015-020.** Los tests DEBEN demostrar que bypass directo Data API continúa denegado.

---

## 32. Cambios físicos esperados en futura implementación

### 32.1 Database

Cambio esperado mínimo:

1. una nueva migration forward-only;
2. función/RPC purpose-specific `public.apply_company_membership_lifecycle` o nombre físico equivalente aprobado en revisión;
3. hardening de `SECURITY DEFINER`;
4. grants/revokes exactos de EXECUTE;
5. ninguna nueva tabla;
6. ninguna nueva columna de dominio;
7. ninguna nueva action de `AuditEvent`;
8. ninguna nueva RLS write policy;
9. ningún cambio a roles tenant permitidos;
10. ningún cambio a `auth.sessions`.

### 32.2 Application

Se espera una boundary mínima en el módulo Identity & Authorization que:

- reciba intención tipada;
- utilice caller-scoped Supabase client;
- invoque el RPC;
- mapee outcomes;
- no duplique autoridad con datos del frontend;
- no introduzca service-role.

Los paths concretos deben determinarse inspeccionando el repositorio real en el preflight, respetando ADR-0001 y convenciones existentes.

### 32.3 Types

Puede añadirse únicamente TypeScript estricto necesario para:

- operation discriminant;
- requested role permitido;
- response outcome;
- application error mapping.

No se crea framework genérico de commands ni RBAC configurable.

### 32.4 UI

`new broad user-management UI = OUT OF SCOPE`

Una superficie existente puede consumir la capability sólo si hacerlo no amplía el incremento. En caso contrario, la implementación backend sigue siendo el resultado funcional de TASK-015 y la UI completa queda para un slice posterior determinado humanamente.

### 32.5 Provider integration

```text
new Supabase Auth admin integration = NONE
new secret dependency = NONE
provider mutation = NONE
```

---

## 33. Fuera de alcance

TASK-015 no incluye:

- creación de `PlatformUser`;
- creación de `CompanyMembership`;
- alta/invite/onboarding;
- VerificationChallenge;
- login/logout UI;
- password reset;
- client scope / `UserClientAccess`;
- `SupportAccessGrant`;
- creación de `MaintenanceCompany`;
- grant/revoke/bootstrap de `SUPER_ADMIN`;
- modificación de `is_super_admin`;
- soporte excepcional;
- administración de formularios;
- mantenimiento;
- evidencia;
- reporting;
- IA/créditos;
- suscripción/pagos;
- offline admin writes;
- outbox para lifecycle de usuarios;
- provider session registry;
- direct `auth.sessions` access;
- nuevo ADR;
- microservicios;
- queue/worker;
- idempotency table/key;
- configurable roles;
- deletion de users/memberships;
- audit log UI/query capability;
- cambios de Staging/Production;
- TASK-016.

---

## 34. Estrategia de tests

La futura implementación debe combinar tests DB reales, tests de application boundary e inspección de privilegios.

### 34.1 Test fixtures

Fixtures pueden usar setup administrativo controlado exclusivamente en test/local/Development.

```text
fixture privileged mutation
!= product capability
```

Deben limpiarse/rollback y no convertirse en helper funcional.

### 34.2 Actor authorization tests

**T015-AUTH-001** — enabled COMPANY_ADMIN same tenant puede ejecutar transición válida.

**T015-AUTH-002** — enabled TECHNICIAN recibe DENY para las tres operaciones.

**T015-AUTH-003** — actor disabled recibe DENY aun con sesión/JWT válido.

**T015-AUTH-004** — actor sin membership recibe DENY.

**T015-AUTH-005** — actor unresolved recibe DENY.

**T015-AUTH-006** — global-only SUPER_ADMIN recibe DENY.

**T015-AUTH-007** — `is_super_admin=true` + membership recibe INCONSISTENT/DENY.

**T015-AUTH-008** — stale role claim COMPANY_ADMIN + DB TECHNICIAN recibe DENY.

**T015-AUTH-009** — caller-supplied tenant/role/actor no altera resultado.

### 34.3 Target isolation tests

**T015-TGT-001** — valid same-tenant target funciona.

**T015-TGT-002** — target UUID de otro tenant recibe DENY/opaque.

**T015-TGT-003** — nonexistent target recibe misma clase externa no-oracle.

**T015-TGT-004** — target global+membership inconsistent recibe DENY.

**T015-TGT-005** — disabled target es resoluble dentro del RPC sin ampliar SELECT ordinario.

### 34.4 OP-01 tests

**T015-DIS-001** — enabled TECHNICIAN target → disabled + one `USER_DISABLED_OR_REVOKED`.

**T015-DIS-002** — enabled COMPANY_ADMIN con otro admin activo → disabled + one event.

**T015-DIS-003** — self-disable → DENY, no mutation, no event.

**T015-DIS-004** — last enabled admin target → DENY, no mutation, no event.

**T015-DIS-005** — already disabled target → success `changed=false`, no event.

**T015-DIS-006** — role remains unchanged after disable.

**T015-DIS-007** — residual valid JWT del target después del commit no permite tenant access.

### 34.5 OP-02 tests

**T015-REI-001** — disabled TECHNICIAN → enabled TECHNICIAN + one `USER_REINSTATED`.

**T015-REI-002** — disabled COMPANY_ADMIN → enabled COMPANY_ADMIN + one event si continuidad no se viola.

**T015-REI-003** — already enabled target → success `changed=false`, no event.

**T015-REI-004** — disabled actor cannot self-reinstate.

**T015-REI-005** — enabled actor targeting self for reinstate returns no-op success only because state already enabled.

### 34.6 OP-03 tests

**T015-ROLE-001** — enabled TECHNICIAN → COMPANY_ADMIN, enabled remains true, one `USER_ROLE_CHANGED`.

**T015-ROLE-002** — enabled COMPANY_ADMIN → TECHNICIAN when another admin exists, one event.

**T015-ROLE-003** — enabled last admin → TECHNICIAN DENY.

**T015-ROLE-004** — self-role-change DENY even if requested role equals current role.

**T015-ROLE-005** — non-self same-role request → success changed=false, no event.

**T015-ROLE-006** — disabled COMPANY_ADMIN → TECHNICIAN changes role only, one event, remains disabled.

**T015-ROLE-007** — disabled TECHNICIAN → COMPANY_ADMIN changes role only, one event, remains disabled.

**T015-ROLE-008** — invalid custom role denied.

**T015-ROLE-009** — `role_before/role_after` exactly match authoritative DB state and are distinct.

**T015-ROLE-010** — disabled COMPANY_ADMIN → TECHNICIAN → reinstate results in enabled TECHNICIAN, not COMPANY_ADMIN.

### 34.7 AuditEvent contract tests

**T015-AUD-001** — OP-01 event uses action exacta y `role_before/after=NULL`.

**T015-AUD-002** — OP-02 event uses action exacta y role snapshots NULL.

**T015-AUD-003** — OP-03 event uses snapshots required/distinct.

**T015-AUD-004** — actor_kind = PLATFORM_USER.

**T015-AUD-005** — actor_platform_user_id = caller authoritative PlatformUser.

**T015-AUD-006** — subject = target PlatformUser.

**T015-AUD-007** — tenant = target/actor same tenant derivado.

**T015-AUD-008** — scope_kind = USER.

**T015-AUD-009** — caller cannot supply occurred_at.

**T015-AUD-010** — denied/no-op operations create zero events.

### 34.8 Atomicity tests

**T015-ATM-001** — real mutation yields exactly one matching AuditEvent.

**T015-ATM-002** — deterministic test-only failure injected on `audit_events` INSERT causes whole RPC to fail and membership remains unchanged.

El failpoint puede implementarse exclusivamente en el test harness mediante una alteración/trigger temporal dentro de una transaction de test que se revierte completamente; ningún trigger de fallo forma parte de la migration productiva.

**T015-ATM-003** — invalid/failed membership mutation leaves zero AuditEvents.

**T015-ATM-004** — DB exception produces no partial state.

### 34.9 Concurrency tests

**T015-CON-001** — dos concurrent duplicate disable requests sobre mismo target producen una mutación/evento y un no-op.

**T015-CON-002** — dos concurrent duplicate role-change same desired role producen una mutación/evento y un no-op.

**T015-CON-003** — carrera obligatoria A/B con exactamente dos admins no puede dejar cero admins.

**T015-CON-004** — concurrent demotions de dos admins en tenant con dos admins no pueden dejar cero admins.

**T015-CON-005** — actor pierde authority mientras espera el tenant lock → post-lock DENY.

**T015-CON-006** — opposing operations sobre mismo target se ordenan y cada una reevaluates current state.

Las pruebas T015-CON deben usar conexiones/transacciones realmente paralelas, no simulación secuencial.

### 34.10 RLS/privilege tests

**T015-RLS-001** — authenticated direct UPDATE `company_memberships` remains denied.

**T015-RLS-002** — authenticated direct INSERT `audit_events` remains denied.

**T015-RLS-003** — authenticated direct UPDATE/DELETE audit remains denied.

**T015-RLS-004** — anon cannot execute RPC.

**T015-RLS-005** — PUBLIC has no EXECUTE.

**T015-RLS-006** — authenticated has only expected function EXECUTE, not table write privileges.

**T015-RLS-007** — search_path hardening present.

**T015-RLS-008** — no generic overload/unexpected function grants.

### 34.11 Provider boundary tests/inspection

**T015-PROV-001** — TASK-015 implementation contains no direct `auth.sessions` mutation.

**T015-PROV-002** — no target JWT storage or transport is added.

**T015-PROV-003** — no `ban_duration` or password workaround.

**T015-PROV-004** — no `auth.admin.signOut` call is introduced for target under current unsupported contract.

**T015-PROV-005** — no new secret/service-role dependency is required by TASK-015.

### 34.12 Offline/UI tests when applicable

**T015-UI-001** — no offline outbox operation is created.

**T015-UI-002** — stale UI retry receives correct `changed=false` when state already applied.

**T015-UI-003** — UI cannot override server self-target or last-admin denial.

---
## 35. Hosted Development Gate

TASK-015 modifica una frontera PostgreSQL/privileges y por tanto requiere verificación real en Supabase Cloud Development antes de cualquier cierre técnico.

### 35.1 Precondiciones del Gate Hosted

Antes de cualquier mutación Hosted Development deben existir separadamente:

1. TASK-015 revisada humanamente;
2. TASK-015 aprobada;
3. canonicalización completada y revisada;
4. incorporación Git del artefacto canónico mediante Gates aplicables;
5. documentación sync de DECISION-001..006 completada en `01`, `02` y `03`;
6. autorización humana expresa de implementación;
7. implementación local terminada;
8. review local PASS;
9. preflight Git/CLI/entorno fresco;
10. autorización humana expresa para aplicar/verificar en Hosted Development.

### 35.2 Verificaciones Hosted obligatorias

En Development debe comprobarse como mínimo:

- migration exacta aplicada;
- function/RPC exacta presente;
- `SECURITY DEFINER` presente;
- search_path hardening presente;
- `PUBLIC EXECUTE = NO`;
- `anon EXECUTE = NO`;
- grant `authenticated EXECUTE` exacto y único esperado;
- sin table write grants inesperados;
- RLS de `company_memberships` no ampliada con write policy;
- RLS/privileges de `audit_events` preservados;
- direct Data API bypass denied;
- actor stale/disabled denied;
- TECHNICIAN denied;
- SUPER_ADMIN global-only denied;
- dual global+tenant denied;
- same-tenant positive cases PASS;
- cross-tenant negative cases PASS;
- self-disable/self-role-change denied;
- last-admin cases denied;
- role-change disabled semantics PASS;
- no-op semantics PASS sin AuditEvent;
- real mutation + exact AuditEvent PASS;
- role snapshots PASS;
- transaction rollback on injected audit failure PASS;
- actual concurrency race tests PASS;
- no provider Auth mutation required;
- schema/policy/grant diff expected-only.

### 35.3 Entornos prohibidos

Esta TASK no autoriza:

```text
Staging mutation
Production mutation
```

Cualquier paso posterior requiere Gate humano separado.

---

## 36. Preflight obligatorio de futura implementación

Antes de modificar el repositorio, Codex o el implementador autorizado deberá verificar y reportar:

### 36.1 Git

- repo root exacto;
- branch;
- HEAD;
- origin/main;
- divergence;
- worktree;
- staged;
- untracked;
- operaciones Git en progreso.

El baseline de esta especificación no sustituye este preflight.

### 36.2 Canon

Leer íntegramente las fuentes canónicas requeridas y confirmar:

- DECISION-001..006 sincronizadas en `01`, `02`, `03`;
- CORR-019 cerrado;
- TASK-014 cerrado;
- Phase 2 aún iniciada/not done;
- no TASK-016 adelantada;
- no ADR posterior que sustituya la boundary.

### 36.3 Repositorio real

Inspeccionar:

- migrations reales;
- schema actual de `company_memberships`;
- schema actual de `audit_events`;
- privileges/policies vigentes;
- función global de TASK-014 y convenciones de hardening;
- factories/clientes Supabase caller-scoped;
- resolver TASK-012 real;
- tests DB/RLS existentes;
- scripts de test;
- dependencias y versiones.

### 36.4 Supabase oficial

Reverificar documentación oficial vigente de:

- sign-out;
- Auth Admin methods;
- session semantics;
- `SECURITY DEFINER`/RPC integration cuando corresponda al stack.

Si aparece una primitive oficial por `user_id` o cambia materialmente el contrato de session termination:

```text
TASK-015 IMPLEMENTATION = BLOCKER — PROVIDER CONTRACT CHANGED, HUMAN REVIEW REQUIRED
```

No ampliar provider integration silenciosamente.

---

## 37. Blockers de futura implementación

La implementación debe detenerse si ocurre cualquiera:

1. documentación sync de DECISION-001..006 incompleta;
2. fuente canónica requerida ausente;
3. contradicción entre spec aprobada y canon vigente;
4. branch/base Git no autorizada;
5. worktree incompatible;
6. schema físico difiere materialmente de TASK-009/TASK-010 esperado;
7. actions AuditEvent esperadas no existen o cambiaron;
8. role constraints cambiaron;
9. `PlatformUser → 0..1 CompanyMembership` cambió;
10. resolver/global authority de TASK-014 cambió materialmente;
11. función purpose-specific no puede usar `auth.uid()` como identity anchor;
12. necesita aceptar tenant/actor authority del caller;
13. necesita abrir generic UPDATE policy sobre memberships;
14. necesita abrir INSERT directo de AuditEvent a authenticated;
15. necesita service-role como writer ordinario;
16. necesita generic privileged server client;
17. `PUBLIC EXECUTE` no puede revocarse;
18. search_path no puede hardenizarse;
19. no puede garantizar mutation + audit atomicity;
20. no puede garantizar admin continuity bajo concurrencia;
21. requiere expected-state token contrario a DECISION-006;
22. necesita cambiar DECISION-001..006;
23. necesita inventar una séptima regla de producto material;
24. necesita un nuevo ADR;
25. provider contract cambió materialmente;
26. requiere guardar JWT target;
27. requiere `auth.sessions` internals;
28. requiere `ban_duration`/password workaround;
29. requiere offline admin write;
30. requiere ampliar UI a un módulo no PR-sized;
31. tests de aislamiento/RLS/concurrency fallan;
32. Hosted Development diff contiene cambios inesperados;
33. cualquier Acceptance Criterion falla.

Ante blocker:

```text
no scope expansion
no silent repair
no staging
no commit
no push
no TASK-016
RETURN TO REVISOR CENTRAL
```

---

## 38. Acceptance Criteria

Cada criterio debe evaluarse individualmente como `PASS` o `FAIL`.

### Governance / scope

**AC-015-001.** TASK ID continúa siendo `TASK-015`.

**AC-015-002.** El título exacto continúa siendo `Lifecycle funcional mínimo de CompanyMembership con AuditEvent atómico`.

**AC-015-003.** La capability se limita a disable/reinstate/role-change.

**AC-015-004.** No se implementa TASK-016.

**AC-015-005.** No se amplía a creación de usuarios/memberships/client scope/support.

**AC-015-006.** `Phase 2 = INICIADA / NOT DONE` permanece coherente.

**AC-015-007.** `Auth funcional = NO` no se sobredeclara como completo por este slice.

**AC-015-008.** Antes de implementación, `01`, `02`, `03` reflejan DECISION-001..006 mediante Gate separado.

### Actor / authority

**AC-015-009.** Actor deriva de `auth.uid()`/validated subject y no de un actor ID caller-supplied.

**AC-015-010.** PlatformUser unresolved → DENY.

**AC-015-011.** Actor sin membership → DENY.

**AC-015-012.** Actor membership disabled → DENY.

**AC-015-013.** Actor TECHNICIAN → DENY.

**AC-015-014.** Enabled COMPANY_ADMIN same tenant puede ejecutar transición válida.

**AC-015-015.** JWT/custom role claim no se usa como authority.

**AC-015-016.** tenant claim/request no se usa como authority.

**AC-015-017.** SUPER_ADMIN global-only → DENY.

**AC-015-018.** Global+membership inconsistent → DENY.

### Target / multitenancy

**AC-015-019.** Input target mínimo es membership ID o equivalente inequívocamente no autoritativo.

**AC-015-020.** Target tenant deriva de DB.

**AC-015-021.** Same-tenant se verifica dentro de RPC.

**AC-015-022.** Cross-tenant target → DENY.

**AC-015-023.** Nonexistent/cross-tenant no crean oracle innecesaria.

**AC-015-024.** Disabled target puede resolverse purpose-specifically sin ampliar SELECT ordinario.

**AC-015-025.** Inconsistent global+tenant target → DENY.

### DECISION-001 / 002

**AC-015-026.** Self-disable → DENY, no mutation, no AuditEvent.

**AC-015-027.** Self-role-change → DENY, no mutation, no AuditEvent.

**AC-015-028.** Self-role-change al mismo role sigue siendo DENY.

**AC-015-029.** Disabled actor no puede self-reinstate.

### DECISION-003

**AC-015-030.** Disable del último enabled COMPANY_ADMIN → DENY.

**AC-015-031.** Demotion del último enabled COMPANY_ADMIN → DENY.

**AC-015-032.** Denial por continuidad produce cero AuditEvents.

**AC-015-033.** Dos concurrentes disable A/B con dos admins no pueden dejar count=0.

**AC-015-034.** Dos concurrentes demotions destructivas no pueden dejar count=0.

**AC-015-035.** Tenant-level serialization/coordination es verificable y bounded por tenant.

### DECISION-004

**AC-015-036.** Disabled COMPANY_ADMIN → TECHNICIAN está permitido para actor autorizado.

**AC-015-037.** Disabled TECHNICIAN → COMPANY_ADMIN está permitido para actor autorizado.

**AC-015-038.** Role-change disabled mantiene `is_enabled=false`.

**AC-015-039.** Role-change disabled real crea exactamente `USER_ROLE_CHANGED`.

**AC-015-040.** Reinstate posterior usa el role nuevo vigente.

**AC-015-041.** Disabled admin → technician → reinstate no restaura admin authority.

### DECISION-005

**AC-015-042.** Disable sobre disabled autorizado → success changed=false.

**AC-015-043.** Reinstate sobre enabled autorizado → success changed=false.

**AC-015-044.** Same-role non-self autorizado → success changed=false.

**AC-015-045.** Todo no-op autorizado produce cero mutation.

**AC-015-046.** Todo no-op autorizado produce cero AuditEvent.

**AC-015-047.** Authorization y invariants se validan antes de reconocer no-op.

**AC-015-048.** Cross-tenant/unauthorized no se convierte en idempotent success por desired state coincidente.

### DECISION-006 / TOCTOU

**AC-015-049.** Toda operación se evalúa contra DB vigente.

**AC-015-050.** Actor se revalida después de coordinación tenant.

**AC-015-051.** Target role/is_enabled se reevalúan después de coordinación.

**AC-015-052.** Admin continuity se reevalúa post-lock.

**AC-015-053.** Actor que pierde autoridad mientras espera lock → DENY.

**AC-015-054.** No existe expected-state/version token requerido.

**AC-015-055.** Concurrent duplicate request produce como máximo una mutación real/evento para el mismo estado deseado.

### OP-01

**AC-015-056.** OP-01 real cambia sólo `is_enabled true→false`.

**AC-015-057.** OP-01 real conserva role.

**AC-015-058.** OP-01 real crea exactamente `USER_DISABLED_OR_REVOKED`.

**AC-015-059.** OP-01 event role snapshots son NULL.

**AC-015-060.** Revocación authorization es efectiva desde DB commit sin esperar JWT expiration.

### OP-02

**AC-015-061.** OP-02 real cambia sólo `is_enabled false→true`.

**AC-015-062.** OP-02 conserva role vigente.

**AC-015-063.** OP-02 real crea exactamente `USER_REINSTATED`.

**AC-015-064.** OP-02 event role snapshots son NULL.

### OP-03

**AC-015-065.** OP-03 sólo acepta COMPANY_ADMIN/TECHNICIAN.

**AC-015-066.** OP-03 real cambia role sin mutar `is_enabled`.

**AC-015-067.** OP-03 real crea exactamente `USER_ROLE_CHANGED`.

**AC-015-068.** role_before/role_after son no-null, válidos y distintos.

**AC-015-069.** role_before proviene del estado autoritativo post-lock.

**AC-015-070.** role_after coincide con requested role validado.

### Audit / atomicity

**AC-015-071.** maintenance_company_id del event se deriva DB.

**AC-015-072.** actor_kind = PLATFORM_USER.

**AC-015-073.** actor_platform_user_id = actor real.

**AC-015-074.** actor_internal_process_key = NULL.

**AC-015-075.** scope_kind = USER.

**AC-015-076.** subject_platform_user_id = target user.

**AC-015-077.** occurred_at no proviene del caller.

**AC-015-078.** Mutation real y AuditEvent ocurren en una transaction PostgreSQL.

**AC-015-079.** Audit insert failure revierte membership mutation.

**AC-015-080.** Mutation failure no deja AuditEvent.

**AC-015-081.** No-op/deny no generan event.

### Function / privilege / RLS

**AC-015-082.** Existe una única boundary RPC purpose-specific o equivalente aprobado.

**AC-015-083.** Boundary es `SECURITY DEFINER` hardenizada.

**AC-015-084.** Identity dentro de RPC deriva sólo de `auth.uid()`.

**AC-015-085.** Search_path fijo/seguro verificado.

**AC-015-086.** Dynamic SQL = NONE salvo review separado.

**AC-015-087.** PUBLIC EXECUTE ausente.

**AC-015-088.** anon EXECUTE ausente.

**AC-015-089.** authenticated EXECUTE está limitado a la firma exacta.

**AC-015-090.** No existe generic privileged RPC de memberships.

**AC-015-091.** No existe service-role ordinary caller.

**AC-015-092.** No existen nuevos direct UPDATE grants/policies de membership para authenticated.

**AC-015-093.** AuditEvent conserva zero table privileges para authenticated.

**AC-015-094.** AuditEvent RLS/inmutabilidad de TASK-010 permanece intacta.

### Provider

**AC-015-095.** Provider verification date y fuentes oficiales quedan documentadas.

**AC-015-096.** `auth.signOut` scopes global/local/others quedan correctamente registrados.

**AC-015-097.** Access JWT residual hasta `exp` queda reconocido.

**AC-015-098.** Admin Auth methods se reconocen como server-only/secret-key.

**AC-015-099.** No se afirma una admin sign-out by user_id no documentada.

**AC-015-100.** OP-01 target termination = UNSUPPORTED bajo contrato vigente.

**AC-015-101.** Enabled admin→technician target termination = UNSUPPORTED bajo contrato vigente.

**AC-015-102.** No se almacena target JWT.

**AC-015-103.** No se usa auth.sessions direct mutation.

**AC-015-104.** No se usa ban/password workaround.

**AC-015-105.** Provider unavailability no restaura authorization.

### Offline/UI

**AC-015-106.** No se crea offline admin mutation/outbox.

**AC-015-107.** Connectivity loss puede resolverse con safe retry.

**AC-015-108.** UI no se trata como security boundary.

**AC-015-109.** UI no afirma provider global logout no demostrado.

### Tests / Hosted

**AC-015-110.** Tests positivos y negativos de actor pasan.

**AC-015-111.** Tests cross-tenant pasan.

**AC-015-112.** Tests self-target pasan.

**AC-015-113.** Tests last-admin secuenciales y concurrentes pasan.

**AC-015-114.** Tests no-op/no duplicate audit pasan.

**AC-015-115.** Test rollback por injected audit failure pasa.

**AC-015-116.** Tests role-change disabled + reinstate pasan.

**AC-015-117.** Direct RLS/Data API bypass tests siguen denegados.

**AC-015-118.** Hosted Development expected-only diff = PASS.

**AC-015-119.** No Staging/Production mutation ocurre sin Gate separado.

**AC-015-120.** Todos los AC anteriores resultan PASS antes de cierre técnico.

---

## 39. Definition of Done

TASK-015 sólo podrá considerarse completada cuando:

1. esta especificación haya sido revisada humanamente;
2. `TASK-015 SPEC REVIEW = APPROVED`;
3. exista aprobación humana formal;
4. se produzca el artefacto aprobado correspondiente;
5. el artefacto aprobado sea revisado;
6. la especificación se canonicalice mediante Gate separado;
7. la canonicalización sea revisada;
8. el artefacto canónico sea incorporado a Git mediante Gates separados;
9. DECISION-001..006 hayan sido sincronizadas en `01`, `02`, `03` mediante Gate documental separado;
10. esa sincronización esté revisada/cerrada;
11. exista autorización humana separada de implementación;
12. preflight Git fresco = PASS;
13. canon preflight = PASS;
14. repo/schema preflight = PASS;
15. provider contract recheck = PASS sin cambio material o review humano resuelto;
16. nueva migration forward-only creada exclusivamente para TASK-015;
17. function/RPC purpose-specific implementada;
18. `auth.uid()`-only actor identity preservada;
19. `SECURITY DEFINER` hardening verificado;
20. search_path fijo/seguro verificado;
21. PUBLIC/anon EXECUTE ausente;
22. mínimo authenticated EXECUTE verificado;
23. no service-role ordinary path verificado;
24. no generic privileged client verificado;
25. no nuevas write policies directas de memberships verificadas;
26. AuditEvent privileges/RLS originales preservados;
27. OP-01 implementada conforme a DECISION-001/003/005/006;
28. OP-02 implementada conforme a DECISION-005/006;
29. OP-03 implementada conforme a DECISION-002/003/004/005/006;
30. every real mutation + exact AuditEvent atómico verificado;
31. no-op → no event verificado;
32. deny → no event verificado;
33. role snapshots exactos verificados;
34. disabled role-change no rehabilita verificado;
35. reinstate usa current role verificado;
36. last-admin race con dos conexiones PASS;
37. actor-loses-authority race PASS;
38. duplicate retry/concurrency tests PASS;
39. atomic rollback injected failure PASS;
40. cross-tenant anti-oracle behavior PASS;
41. direct Data API bypass remains DENIED;
42. no direct auth.sessions access;
43. no target JWT storage;
44. no ban/password workaround;
45. provider call para target = NONE bajo contrato vigente;
46. local application tests PASS;
47. DB/RLS tests locales PASS;
48. lint/typecheck/tests relevantes PASS;
49. local implementation review = APPROVED;
50. autorización humana Hosted Development = otorgada;
51. Hosted migration apply = PASS;
52. Hosted function/grant inspection = PASS;
53. Hosted authorization tests = PASS;
54. Hosted audit/atomicity tests = PASS;
55. Hosted concurrency tests = PASS;
56. Hosted RLS negative tests = PASS;
57. Hosted expected-only schema/policy/grant diff = PASS;
58. Hosted Development review = APPROVED;
59. staging no ocurre sin Gate separado;
60. commit no ocurre sin Gate separado;
61. push no ocurre sin Gate separado;
62. Git final/remote exact commit se verifica cuando esos Gates sean autorizados;
63. todos los `AC-015-001..120 = PASS`;
64. no hay regression arquitectónica, de seguridad ni multitenancy;
65. no hay secret leak;
66. `Phase 2` no se declara completa por inferencia;
67. `Phase 3` no se inicia;
68. TASK-016 no se determina automáticamente;
69. existe revisión humana final de TASK-015;
70. `TASK-015 = DONE / CLOSED` sólo después de ese cierre humano.

Debe mantenerse:

```text
implementation PASS
!=
TASK-015 completed
```

Y:

```text
TASK-015 completed
!=
TASK-016 determined automatically
```

---

## 40. Plan de implementación futura para Codex

Sólo después de autorización humana expresa, Codex deberá:

1. ejecutar preflight Git completo;
2. verificar documentation sync DECISION-001..006;
3. leer íntegramente spec canónica y fuentes obligatorias;
4. inspeccionar repo/schema/privileges actuales;
5. reverificar contrato oficial Supabase Auth;
6. detenerse ante provider drift material;
7. identificar conventions exactas de migrations/functions/tests;
8. crear exclusivamente la migration TASK-015;
9. implementar RPC purpose-specific con hardening;
10. mantener caller-scoped invocation;
11. implementar application boundary mínima;
12. no introducir UI amplia;
13. no introducir provider admin call;
14. implementar actor/target/same-tenant/self checks;
15. implementar tenant-level lock y post-lock revalidation;
16. implementar admin continuity;
17. implementar DECISION-005 no-op;
18. implementar tres mutations y AuditEvent mapping;
19. preservar existing RLS/table privileges;
20. añadir tests de DB/application;
21. añadir concurrency harness real;
22. añadir atomic rollback test fixture;
23. ejecutar local checks;
24. revisar diff completo;
25. devolver evidencia sin staging;
26. esperar Gate humano para Hosted Development;
27. ejecutar Hosted sólo tras autorización;
28. devolver evidencia completa al Revisor Central;
29. no hacer git add/commit/push salvo Gates posteriores.

---

## 41. Autorevisión de especificación

### 41.1 Scope

```text
single PR-sized capability = YES
OP-01/02/03 only = YES
TASK-016 introduced = NO
```

### 41.2 Product decisions

```text
DECISION-001 consumed = YES
DECISION-002 consumed = YES
DECISION-003 consumed = YES
DECISION-004 consumed = YES
DECISION-005 consumed = YES
DECISION-006 consumed = YES
new product rule invented = NO
```

### 41.3 Provider

```text
official Supabase sources only = YES
verification date = 2026-09-05
admin signOut by user_id documented = NO
target JWT storage allowed = NO
provider-side target termination = UNSUPPORTED
provider failure restores authorization = NO
```

### 41.4 Architecture

```text
new ADR required = NO
purpose-specific PostgreSQL RPC = SELECTED
SECURITY DEFINER = JUSTIFIED
service-role ordinary path = NO
generic privileged client = NO
external call inside DB transaction = NO
```

### 41.5 Atomicity / concurrency

```text
membership mutation IFF AuditEvent = YES
tenant-level serialization = YES
post-lock reevaluation = YES
last-admin race protected = YES
expected-state token = NO
idempotency key = NO
```

### 41.6 RLS

```text
new membership write policy = NO
new audit write policy = NO
direct authenticated membership update = DENIED
direct authenticated audit insert = DENIED
PUBLIC/anon RPC execute = DENIED
```

### 41.7 Offline/UI

```text
offline administrative writes = NO
outbox = NO
UI as authority = NO
broad new user-management UI = NO
```

### 41.8 Governance

```text
implementation authorized = NO
Codex authorized = NO
repository modified = NO
Cloud modified = NO
Git operation performed = NO
TASK-016 = NOT DETERMINED / NOT GENERATED / NOT STARTED
state = APPROVED FOR IMPLEMENTATION
```

---

## 42. Estado final de esta especificación

```text
TASK-015 SPECIFICATION = APPROVED FOR IMPLEMENTATION

TASK-015 SPEC REVIEW = APPROVED
TASK-015 HUMAN SPEC APPROVAL = APPROVED

state = APPROVED FOR IMPLEMENTATION

architecture blocker = NONE
product blocker = NONE
canonical source blocker = NONE
provider contract blocker = NONE

new ADR required = NO
implementation authorized = NO
Codex authorized = NO
repository writes = NONE
Supabase Cloud writes = NONE
Staging = NONE
Production = NONE
TASK-016 = NOT DETERMINED / NOT GENERATED / NOT STARTED
```

El siguiente acto válido es exclusivamente `TASK-015 APPROVED ARTIFACT REVIEW`.

**RETURN TO REVISOR CENTRAL.**
