# TASK-012 — Fundación mínima de autorización online autoritativa

## 1. Identificación

**ID:** `TASK-012`

**Título:** `TASK-012 — Fundación mínima de autorización online autoritativa`

**Tipo:** `IMPLEMENTATION TASK`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context principal:** `Identity & Authorization`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`TASK-012-authoritative-online-authorization-foundation-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`

**TASK-012 determinada:** `SÍ`

**TASK-012 generada:** `SÍ`

**TASK-012 especificada:** `SÍ`

**TASK-012 aprobada:** `SÍ`

**TASK-012 canonicalizada:** `NO`

**TASK-012 implementación autorizada:** `NO`

**TASK-012 implementada:** `NO`

**TASK-013 determinada:** `NO`

**TASK-013 generada:** `NO`

Esta especificación define exclusivamente el contrato de un futuro incremento PR-sized.

No constituye implementación.

No autoriza Codex.

No modifica el repositorio.

No modifica Supabase Cloud.

No autoriza Git.

No autoriza SQL, migrations ni RLS nuevas o modificadas.

---

## 2. Estado de gobernanza de entrada

Se consume como estado formal aprobado:

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

NEXT PHASE 2 INCREMENT DETERMINATION = APPROVED
TASK-012 DETERMINATION = APPROVED
```

La determinación vigente fija exactamente:

```text
TASK-012 — Fundación mínima de autorización online autoritativa
```

y no autoriza ampliar este incremento hacia otros componentes de Identity & Authorization.

Debe mantenerse:

```text
TASK-012 determinada
!=
TASK-012 aprobada
!=
TASK-012 canonicalizada
!=
TASK-012 implementación autorizada
!=
TASK-012 implementada
```

La siguiente TASK no queda determinada por este documento.

---

## 3. Resultado de revisión de contradicciones

### 3.1 Resultado

```text
contradicciones materiales bloqueantes detectadas = 0
TASK-012 SPECIFICATION = PASS
TASK-012 SPEC REVIEW = APPROVED
TASK-012 HUMAN SPEC APPROVAL = APPROVED
```

La baseline disponible es suficiente para especificar una foundation mínima de autorización online que reutilice exclusivamente:

- identidad Auth validada server-side;
- `PlatformUser`;
- mapping Auth subject → `PlatformUser`;
- `CompanyMembership`;
- `MaintenanceCompany`;
- role tenant vigente;
- RLS ya existente sobre el slice de TASK-009.

### 3.2 Límites físicos detectados y preservados

El modelo físico vigente contiene:

- `maintenance_companies.id`;
- `platform_users.id`;
- `platform_user_auth_subjects.auth_subject_id`;
- `platform_user_auth_subjects.platform_user_id`;
- `company_memberships.id`;
- `company_memberships.platform_user_id`;
- `company_memberships.maintenance_company_id`;
- `company_memberships.role`;
- `company_memberships.is_enabled`.

Por tanto:

```text
PlatformUser enabled state físico = NO EXISTE
```

TASK-012 no puede inventar:

- `platform_users.is_enabled`;
- estado equivalente;
- lógica de deshabilitación independiente de `CompanyMembership`.

La condición de vigencia tenant disponible hoy es:

```text
CompanyMembership.is_enabled
```

Asimismo:

```text
MaintenanceCompany active/commercial state físico en el slice actual = NO EXISTE
```

TASK-012 puede exigir que la `MaintenanceCompany` derivada exista y sea accesible conforme al modelo/RLS vigente, pero no puede inventar estado comercial, suspensión, entitlement ni flags de actividad.

Si una futura implementación demuestra que el objetivo mínimo no puede cumplirse sin añadir cualquiera de esos estados:

```text
BLOCKER
```

No ampliar schema por inferencia.

---

## 4. Fuentes de verdad obligatorias

Antes de implementar TASK-012, Codex deberá leer íntegramente y respetar como mínimo:

### 4.1 Producto

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

### 4.2 Arquitectura

```text
docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

### 4.3 Tareas y correcciones

```text
docs/tasks/TASK-008-supabase-application-boundary.md
docs/tasks/CORR-010-task-008-closure-state-sync.md
docs/tasks/TASK-009-identity-tenant-foundation.md
docs/tasks/CORR-011-task-009-closure-state-sync.md
docs/tasks/TASK-010-audit-event-foundation.md
docs/tasks/CORR-012-task-010-closure-state-sync.md
docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md
docs/tasks/CORR-013-task-011-closure-state-sync.md
```

### 4.4 Repositorio real

El repositorio real es fuente de verdad sobre:

- estructura de archivos;
- imports;
- aliases;
- dependencias instaladas;
- tests existentes;
- scripts;
- shape real de las factories Supabase;
- implementación real de TASK-011;
- migrations versionadas;
- policies actuales;
- estado Git.

Una futura implementación no puede sustituir esa inspección por snapshots históricos.

### 4.5 Regla ante contradicción

Ante contradicción material entre:

- esta especificación;
- documentación canónica vigente;
- ADR aceptados;
- schema versionado;
- implementación real de TASK-009/TASK-011;
- estado real del repositorio;

el resultado obligatorio es:

```text
TASK-012 IMPLEMENTATION = BLOCKER
```

No resolver por inferencia.

No autoreparar.

No ampliar scope.

---

## 5. Objetivo

TASK-012 debe materializar la **foundation request-scoped mínima de autorización online autoritativa** que, partiendo exclusivamente de una identidad Auth validada server-side, permita resolver:

```text
validated Auth subject
→ PlatformUser
→ enabled/current CompanyMembership
→ MaintenanceCompany
→ current tenant role
```

El resultado debe ser una frontera server-side reutilizable por futuros casos de uso.

Debe permitir responder de forma inequívoca:

> Dada esta identidad Auth ya validada, ¿existe en este momento un actor tenant autorizado y, si existe, cuál es su contexto tenant/role vigente?

TASK-012 no debe responder todavía:

- si puede acceder a un `Client` concreto;
- si puede operar un recurso concreto;
- si posee un `SupportAccessGrant`;
- si puede entrar a una ruta concreta;
- si puede ejecutar una acción funcional concreta;
- si existe una autorización offline vigente;
- si el tenant posee entitlement comercial;
- si debe realizarse un redirect.

Principio central:

```text
validated Auth identity
+
current authoritative tenant membership
→ minimal current authorization context
```

pero:

```text
minimal current authorization context
!=
full application authorization
```

---

## 6. Invariantes obligatorios

TASK-012 debe preservar sin reinterpretación:

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
valid Auth subject
!=
authorized PlatformUser
```

```text
PlatformUser exists
!=
current enabled CompanyMembership
```

```text
JWT claims
!=
current authorization authority
```

```text
frontend state
!=
current authorization authority
```

```text
pathname/query/body/header/cookie
!=
current authorization authority
```

```text
stale authorization cache
!=
current authorization authority
```

La prioridad obligatoria es:

```text
current authoritative database state
>
JWT/session/cookies/frontend/path/client-supplied authorization context
```

Una revocación o deshabilitación de membership debe surtir efecto en una request nueva aunque sobreviva técnicamente:

- JWT;
- sesión;
- cookie;
- claim de tenant;
- claim de role;
- estado React;
- cache de navegación;
- parámetro enviado por el cliente.

RLS continúa siendo la frontera primaria de aislamiento remoto para datos tenant-owned.

La foundation de aplicación de TASK-012:

```text
complementa RLS
```

y nunca:

```text
sustituye RLS
```

---

## 7. Alcance exacto

TASK-012 incluye exclusivamente:

1. definir y materializar un contrato server-side mínimo para una identidad Auth validada;
2. resolver esa identidad hacia el `PlatformUser` ya materializado;
3. resolver la membership tenant vigente y habilitada;
4. resolver la `MaintenanceCompany` derivada de esa membership;
5. derivar el role tenant vigente desde la membership autoritativa;
6. devolver un contexto mínimo, inmutable y request-scoped;
7. fallar cerrado ante ausencia, ambigüedad, inconsistencia o error;
8. impedir que estado stale o inputs de cliente se conviertan en autoridad;
9. exponer una frontera reutilizable dentro del módulo `Identity & Authorization`;
10. probar revocación, stale claims, tenant spoofing y fail-closed;
11. consumir RLS existente sin debilitarla ni modificarla.

No incluye capacidades posteriores.

---

## 8. Frontera de entrada: identidad Auth validada

### 8.1 Input autorizado

La foundation debe consumir conceptualmente:

```text
ValidatedAuthIdentity
```

cuyo dato mínimo necesario es:

```text
Auth subject
```

Ese subject debe haber sido validado server-side mediante la foundation técnica vigente de TASK-011.

La identidad Auth validada:

- identifica al caller ante el proveedor Auth;
- es únicamente el anchor para resolver `PlatformUser`;
- no transporta autoridad tenant;
- no transporta autoridad de role;
- no transporta client scope;
- no transporta support scope;
- no transporta permisos funcionales.

### 8.2 Valores que no son autoridad

TASK-012 no puede aceptar como autoridad:

- `maintenance_company_id` enviado por browser;
- tenant seleccionado por frontend;
- role enviado por browser;
- tenant cookie;
- role cookie;
- pathname;
- query string;
- body;
- header arbitrario;
- local storage;
- client-side state;
- ID de usuario arbitrario;
- membership ID arbitrario;
- custom tenant claim;
- custom role claim;
- session metadata con tenant/role;
- cache de autorización proveniente de una request anterior.

### 8.3 Lookup input vs authorization authority

Puede existir un dato utilizado técnicamente para localizar una fila.

Debe quedar separada la semántica:

```text
lookup input
!=
authorization authority
```

Ejemplo conceptual permitido:

```text
validated Auth subject
→ lookup del mapping correspondiente
```

Ejemplo prohibido:

```text
request.maintenance_company_id
→ seleccionar tenant autorizado
```

El tenant efectivo sólo puede derivarse desde la cadena autoritativa vigente.

### 8.4 Integración mínima con TASK-011

TASK-012 no debe crear un nuevo flujo Auth.

La composición server-side puede reutilizar la primitive de identidad ya aprobada por TASK-011 únicamente para obtener/consumir un subject validado.

Si el repositorio real no permite transportar o reutilizar de forma segura la identidad validada sin:

- crear un segundo lifecycle Auth incompatible;
- duplicar lógica material;
- implementar login/logout/OTP;
- modificar el contrato de TASK-011 materialmente;
- introducir una nueva decisión arquitectónica;

el resultado es:

```text
BLOCKER
```

Una integración técnica mínima sólo es admisible si permanece claramente separada de la autorización de producto.

---

## 9. Resolución autoritativa

La secuencia conceptual obligatoria es:

```text
Validated Auth subject
→ exact current Auth-subject mapping
→ PlatformUser
→ exact current enabled CompanyMembership
→ MaintenanceCompany
→ current role from that membership
```

### 9.1 Auth subject

Debe existir un Auth subject validado.

Ausente o inválido:

```text
DENY
```

### 9.2 Mapping Auth subject → PlatformUser

Debe resolverse exactamente un mapping vigente para el subject validado.

Con el modelo físico actual, `auth_subject_id` es clave primaria, por lo que la multiplicidad no debería ser representable.

Aun así, la frontera de aplicación debe tratar:

```text
0 mappings
→ DENY
```

```text
>1 mappings / resultado ambiguo / shape inesperado
→ DENY
```

No asumir éxito si el resultado del adapter contradice la cardinalidad esperada.

### 9.3 PlatformUser

El `PlatformUser` derivado debe existir.

El modelo físico vigente no contiene un estado `enabled` propio de `PlatformUser`.

Por tanto:

```text
PlatformUser existence = REQUIRED
PlatformUser enabled check = NO APLICA CON EL MODELO FÍSICO VIGENTE
```

No inventar estado.

### 9.4 CompanyMembership

Debe existir exactamente una membership del `PlatformUser` conforme al modelo vigente.

La membership debe estar habilitada:

```text
CompanyMembership.is_enabled = true
```

Con el modelo físico vigente, `platform_user_id` es único en `company_memberships`.

Debe tratarse:

```text
0 memberships visibles/habilitadas
→ DENY
```

```text
membership disabled/revoked
→ DENY
```

```text
resultado inesperadamente múltiple
→ DENY
```

La foundation no debe intentar distinguir públicamente entre:

- nunca tuvo membership;
- membership fue revocada;
- membership fue deshabilitada;
- membership dejó de ser visible por RLS.

Todas esas condiciones son no-autorización.

### 9.5 MaintenanceCompany

El tenant se obtiene exclusivamente desde:

```text
CompanyMembership.maintenance_company_id
```

La `MaintenanceCompany` correspondiente debe existir conforme al estado autoritativo y RLS vigentes.

Con el modelo actual no existe estado comercial o de actividad física en `maintenance_companies`.

Por tanto:

```text
tenant row existence = REQUIRED
commercial/activity entitlement check = FUERA DE ALCANCE
```

### 9.6 Role

El role debe derivarse exclusivamente de:

```text
current CompanyMembership.role
```

Los valores tenant físicamente aprobados son:

```text
COMPANY_ADMIN
TECHNICIAN
```

Cualquier valor no reconocible:

```text
DENY / DATA INCONSISTENCY
```

Aunque un JWT o cookie afirme otro role, prevalece la membership vigente.

### 9.7 SUPER_ADMIN

TASK-012 no implementa acceso tenant de `SUPER_ADMIN`.

La regla vigente permanece:

```text
PlatformUser
+
sin enabled CompanyMembership
→ no tenant authorization por el camino normal
```

No inferir:

```text
sin membership
→ SUPER_ADMIN
```

No crear bypass global.

No introducir `SupportAccessGrant`.

El soporte excepcional será tratado únicamente cuando su entidad, auditoría y scope sean implementados por tareas posteriores autorizadas.

---

## 10. Contrato conceptual de resultado

### 10.1 Separación de conceptos

Deben distinguirse:

```text
AuthIdentity
```

de:

```text
CurrentAuthorizationContext
```

`AuthIdentity` responde quién presentó una identidad Auth técnicamente válida.

`CurrentAuthorizationContext` responde qué actor tenant puede autorizarse ahora con estado vigente.

### 10.2 Contexto mínimo exitoso

El contexto mínimo de autorización debe contener exclusivamente los identificadores y role necesarios para futuras coordinaciones server-side:

```text
platformUserId
companyMembershipId
maintenanceCompanyId
role
```

Puede conservarse el Auth subject en el objeto de identidad de entrada o en un wrapper técnico de composición, pero no debe duplicarse como claim de autorización persistido.

No incluir por defecto:

- email;
- teléfono;
- perfil;
- token;
- refresh token;
- cookies;
- claims completos;
- client IDs;
- support scopes;
- permission arrays;
- feature flags;
- subscription state;
- AI credits;
- rutas;
- UI state;
- resource permissions.

### 10.3 Semántica

Un resultado exitoso significa exclusivamente:

```text
esta identidad Auth validada
→ corresponde ahora a este PlatformUser
→ posee ahora esta membership habilitada
→ pertenece ahora a este MaintenanceCompany
→ posee ahora este role tenant
```

No significa:

```text
puede ejecutar cualquier acción del role
```

ni:

```text
puede acceder a cualquier recurso del tenant
```

### 10.4 Inmutabilidad y scope

El contexto debe ser:

- inmutable para el caller;
- request-scoped;
- no compartido entre requests;
- no global;
- no mutable por UI;
- no reutilizado como autoridad futura después de finalizar la request.

---

## 11. Semántica de denegación y errores

### 11.1 Categorías conceptuales mínimas

La aplicación debe poder distinguir conceptualmente:

```text
UNAUTHENTICATED
```

de:

```text
AUTHENTICATED_BUT_UNAUTHORIZED
```

y de:

```text
AUTHORIZATION_RESOLUTION_ERROR
```

Estas categorías son conceptuales; los nombres físicos pueden adaptarse si el repositorio posee una convención ya aprobada.

### 11.2 Fail-closed

Todas las categorías negativas anteriores producen:

```text
NO authorization context
```

Nunca existe:

```text
error resolving authorization
→ allow
```

### 11.3 No enumeración sensible

La superficie que eventualmente llegue al cliente no debe revelar innecesariamente:

- si existe un `PlatformUser` concreto;
- si existe una membership concreta;
- si fue revocada o nunca existió;
- IDs internos adicionales;
- detalles de policies;
- contenido de queries;
- nombres de tablas;
- stack traces;
- secretos;
- tokens.

La observabilidad interna puede diferenciar causas técnicas de forma sanitizada cuando sea necesario para diagnóstico, sin convertir esa información en autoridad ni en respuesta pública detallada.

---

## 12. Matriz fail-closed obligatoria

La futura implementación debe negar autorización ante al menos:

| Caso | Resultado obligatorio |
|---|---|
| Request anónima | `UNAUTHENTICATED` / sin contexto |
| Auth subject ausente | sin contexto |
| Auth subject inválido/no validado | sin contexto |
| Subject sin mapping | sin contexto |
| Mapping ambiguo/múltiple | sin contexto |
| Mapping inconsistente | sin contexto |
| PlatformUser inexistente | sin contexto |
| Estado `PlatformUser` requerido por futura baseline pero no reconocible | `BLOCKER` o deny; no inventar |
| CompanyMembership inexistente | sin contexto |
| CompanyMembership no vigente | sin contexto |
| CompanyMembership disabled/revoked | sin contexto |
| Membership inesperadamente múltiple | sin contexto |
| MaintenanceCompany inexistente/no visible | sin contexto |
| Role desconocido | sin contexto |
| Error de query | sin contexto |
| Respuesta incompleta del adapter | sin contexto |
| Inconsistencia de datos | sin contexto |
| Estado no reconocible | sin contexto |
| Cualquier condición ambigua | sin contexto |

No existe fallback permisivo.

---

## 13. Revocación y estado stale

### 13.1 Requisito central

Debe cumplirse:

```text
request N autorizada
+
membership revocada/deshabilitada
+
request N+1
→ DENIED
```

aunque persistan:

- JWT válido técnicamente;
- sesión válida técnicamente;
- cookie;
- claim tenant anterior;
- claim role anterior;
- frontend state;
- objeto de contexto de una request anterior.

### 13.2 Role stale

Debe cumplirse:

```text
JWT says COMPANY_ADMIN
+
current membership role = TECHNICIAN
→ role efectivo = TECHNICIAN
```

### 13.3 Tenant stale

Debe cumplirse:

```text
client/cookie/claim says tenant B
+
current membership tenant = tenant A
→ tenant efectivo = tenant A
```

o denegación si la cadena autoritativa no puede establecerse.

Nunca tenant B por afirmación del cliente.

### 13.4 Cache stale

Una cache creada en una request anterior no puede preservar autorización.

Prohibido:

- module-level authorization cache;
- process-wide membership cache;
- singleton con contexto de usuario;
- memoización global por Auth subject;
- almacenamiento persistente del contexto para reutilización online futura.

### 13.5 Provider session termination

La terminación provider-side de sesión continúa siendo:

```text
defense in depth
```

No es la defensa primaria de TASK-012.

Su ausencia o fallo:

```text
!=
restaurar autorización
```

TASK-012 no implementa session termination.

---

## 14. Caching y request scope

### 14.1 Regla

La autorización debe resolverse para la request actual usando estado autoritativo vigente.

### 14.2 Permitido

Puede utilizarse memoización estrictamente request-scoped si el repositorio real demuestra una necesidad y la primitive utilizada garantiza que:

- no sobrevive a la request;
- no se comparte entre usuarios;
- no se comparte entre procesos;
- no convierte un estado anterior en autoridad futura;
- no impide que una request nueva observe una revocación.

### 14.3 Prohibido

```text
global cache
process cache
cross-request cache
persistent authorization context
browser authorization cache as authority
```

Si la única forma propuesta de cumplir rendimiento requiere conservar autorización entre requests sin una invalidación autoritativa demostrada:

```text
BLOCKER
```

---

## 15. Multitenancy

### 15.1 Frontera

```text
tenant = MaintenanceCompany
```

### 15.2 Resolución

El tenant efectivo se deriva únicamente de la membership vigente del `PlatformUser` resuelto desde el Auth subject validado.

### 15.3 Tenant spoofing

Debe fallar cualquier intento equivalente a:

```text
caller tenant A
+
envía UUID tenant B
→ contexto tenant B
```

El resultado permitido es:

```text
contexto tenant A derivado autoritativamente
```

o:

```text
DENY
```

Nunca el tenant B afirmado.

### 15.4 IDs conocidos

Conocer:

- UUID de otra `MaintenanceCompany`;
- UUID de otro `PlatformUser`;
- UUID de otra membership;

no concede autoridad.

### 15.5 Tenant selector

TASK-012 no implementa tenant selector.

El MVP mantiene un único tenant por usuario tenant.

Si en el futuro se aprueba selección de tenant, deberá existir una decisión y validación explícitas; un selector frontend no se convierte automáticamente en autoridad.

---

## 16. Roles

TASK-012 sólo resuelve el role tenant vigente.

No crea una permission matrix.

No crea capabilities derivadas.

No crea decorators.

No crea guards genéricos.

No crea RBAC framework.

No crea ABAC.

No crea ACL.

No crea autorización por recurso.

Los únicos roles tenant del modelo vigente son:

```text
COMPANY_ADMIN
TECHNICIAN
```

La ausencia de un permiso funcional explícito en documentos superiores continúa significando:

```text
no inferir permiso
```

En especial, TASK-012 no reinterpreta capacidades de mantenimiento ni convierte `COMPANY_ADMIN` en ejecutor inicial.

---

## 17. RLS review

```text
RLS change = NO
```

### 17.1 Policies consumidas

TASK-012 consume la foundation RLS ya implementada por TASK-009 para:

- mapping del Auth subject propio;
- lectura del `PlatformUser` propio;
- lectura de membership propia habilitada;
- lectura de `MaintenanceCompany` derivada de membership habilitada.

### 17.2 Razón para no modificar RLS

El objetivo de TASK-012 es materializar una frontera de aplicación server-side sobre un modelo físico y políticas ya aprobados.

No existe requisito nuevo de datos que justifique:

- policy nueva;
- policy modificada;
- grant;
- revoke;
- helper SQL;
- función;
- RPC;
- `SECURITY DEFINER`.

### 17.3 Defensa en profundidad

La application foundation puede resolver un contexto coherente para coordinación de casos de uso.

RLS sigue siendo obligatoria para el acceso remoto tenant-owned porque protege contra:

- bugs de application layer;
- bypass de rutas;
- inputs manipulados;
- contexto stale;
- errores de autorización de recursos.

Criterio obligatorio:

```text
TASK-012
→ no debilita RLS
→ no sustituye RLS
→ no introduce bypass RLS
```

Si la implementación necesita cambiar RLS para funcionar:

```text
BLOCKER
```

---

## 18. Privilegios y service-role

TASK-012 debe utilizar exclusivamente una frontera server-side caller-scoped y no privilegiada compatible con TASK-008/TASK-011.

Prohibido introducir como camino normal:

```text
service-role
secret key
Admin Auth API
admin client
SECURITY DEFINER
privileged RPC
bypass RLS
```

La regla:

```text
server-side
!=
privileged
!=
authorized
```

debe permanecer visible.

Si una consulta propuesta sólo funciona con service-role:

```text
BLOCKER
```

No “solucionar” RLS elevando privilegios.

---

## 19. Datos y schema

### 19.1 Entidades nuevas

```text
NINGUNA
```

### 19.2 Tablas nuevas

```text
NINGUNA
```

### 19.3 Tablas modificadas

```text
NINGUNA
```

En particular, no modificar:

```text
maintenance_companies
platform_users
platform_user_auth_subjects
company_memberships
audit_events
```

### 19.4 Cambios físicos prohibidos

```text
Schema = NO
Migration = NO
SQL nuevo = NO
RLS nueva/modificada = NO
Policy nueva/modificada = NO
Grant/revoke DB = NO
Index = NO
Constraint = NO
Enum DB = NO
Function = NO
Trigger = NO
RPC = NO
View = NO
SECURITY DEFINER = NO
```

Si alguno se vuelve necesario:

```text
BLOCKER
```

---

## 20. AuditEvent

La foundation física de `AuditEvent` ya existe.

TASK-012 no implementa una mutación de dominio ni un productor auditable.

Por tanto:

```text
AuditEvent producer = NO
```

No crear eventos para:

- resolver identidad;
- leer membership;
- leer tenant;
- derivar role;
- denegar autorización;
- ejecutar una query read-only de resolución.

`AuditEvent` tampoco puede utilizarse como fuente de autorización.

Debe mantenerse:

```text
AuditEvent history
!=
current authorization authority
```

---

## 21. Auth funcional

TASK-012 no implementa:

- login;
- signup;
- logout;
- magic link;
- OTP;
- email code;
- reenvío;
- onboarding;
- creación funcional de usuarios;
- session termination;
- password flow;
- Auth UI.

Debe permanecer:

```text
Auth funcional = NO
```

y:

```text
Auth SSR lifecycle completo de producto = NO
```

TASK-012 consume una identidad ya validada; no convierte la foundation SSR de TASK-011 en un producto Auth completo.

---

## 22. Client scope

TASK-012 no crea ni consume:

```text
Client
UserClientAccess
```

Por tanto no puede resolver:

- clientes autorizados;
- client scope;
- locations;
- equipment;
- resources client-scoped.

El contexto mínimo termina en:

```text
tenant + tenant role
```

Cualquier necesidad de client scope:

```text
BLOCKER para TASK-012
```

y debe pertenecer a otro incremento formalmente determinado.

---

## 23. SupportAccessGrant y SUPER_ADMIN

TASK-012 no crea ni consume:

```text
SupportAccessGrant
```

No implementa soporte excepcional.

No crea scopes de soporte.

No crea bypass de plataforma.

Un `SUPER_ADMIN` sin una future foundation de soporte explícita no recibe tenant context por este resolver.

Debe mantenerse:

```text
global platform identity
!=
ordinary tenant authorization
```

---

## 24. Route authorization

TASK-012 no implementa:

- protected route map;
- redirect a `/login`;
- redirect a `/forbidden`;
- matcher por role;
- middleware de autorización funcional;
- layout guards;
- route groups por role;
- navegación autorizada;
- frontend guards.

La frontera Proxy de TASK-011 continúa siendo técnica.

Debe mantenerse:

```text
Auth Proxy technical boundary
!=
route authorization
```

---

## 25. UI flow

```text
UI flow = NO APLICA EN TASK-012
```

TASK-012 es una foundation server-side.

No crear pantallas.

No crear:

- login;
- tenant selector;
- role selector;
- forbidden page;
- dashboard;
- shell autenticado;
- navegación condicional;
- mensajes de permisos.

---

## 26. Offline behavior

```text
Offline behavior = NO APLICA / FUERA DE ALCANCE
```

La autorización cubierta por TASK-012 es exclusivamente:

```text
online
+
request-scoped
+
current authoritative state
```

No implementar:

- `OfflineAuthorizationState`;
- Dexie;
- IndexedDB;
- lease de autorización;
- cache offline de membership;
- cache offline de tenant;
- outbox;
- Service Worker;
- fallback offline.

Permanecen intactos:

```text
ADR-0004 = BLOCKED BY OPEN DECISIONS
```

y sus blockers vigentes.

TASK-012 no resuelve:

- `DO-T04`;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `FORM-OPEN-004`.

---

## 27. Arquitectura y ownership de código

### 27.1 Monolito modular

TASK-012 debe permanecer dentro del monolito modular Next.js aprobado.

No se introducen:

- microservicios;
- authorization server separado;
- policy engine externo;
- gateway nuevo;
- sidecar;
- message broker.

### 27.2 Ownership

La autorización de tenant/role es una responsabilidad del bounded context:

```text
Identity & Authorization
```

No debe vivir como regla de negocio dentro de:

```text
src/infrastructure/
```

La infraestructura Supabase común puede seguir encapsulada bajo:

```text
src/infrastructure/supabase/
```

pero la coordinación de:

```text
Auth identity
→ PlatformUser
→ CompanyMembership
→ tenant
→ role
```

debe pertenecer al módulo funcional.

### 27.3 Dirección de dependencias

La forma conceptual debe respetar:

```text
application
→ contratos de dominio/aplicación
→ adapter de infraestructura del módulo
→ Supabase caller-scoped común
```

La UI no participa.

`app/` no debe contener la lógica.

La infraestructura común no debe decidir autorización funcional.

### 27.4 TypeScript

```text
TypeScript strict = OBLIGATORIO
```

No introducir:

- `any` para saltar el contrato;
- type assertions que conviertan estado ambiguo en autorizado;
- non-null assertions como sustituto de validación;
- casts de role no validado.

---

## 28. Contrato de aplicación propuesto

La implementación futura debe exponer una única capacidad pública server-side equivalente a:

```text
resolveCurrentAuthorizationContext(validatedAuthIdentity)
```

El nombre físico puede ajustarse a las convenciones reales del repositorio durante implementación siempre que conserve exactamente la semántica.

### 28.1 Input conceptual

```text
ValidatedAuthIdentity
```

mínimo:

```text
subject
```

### 28.2 Success conceptual

```text
CurrentAuthorizationContext
```

mínimo:

```text
platformUserId
companyMembershipId
maintenanceCompanyId
role
```

### 28.3 Negative result

La capacidad no debe devolver un contexto parcial.

Prohibido:

```text
tenant conocido + role desconocido
→ success parcial
```

```text
PlatformUser conocido + membership ausente
→ success parcial
```

La resolución es:

```text
all required current facts established
→ success
```

o:

```text
otherwise
→ no authorization context
```

### 28.4 No universal permission API

No introducir APIs equivalentes a:

- `can(user, action, resource)`;
- `hasPermission(...)`;
- `authorizeEverything(...)`;
- policy registry;
- generic role hierarchy.

Esas superficies ampliarían el slice.

---

## 29. Estrategia mínima de queries

La implementación debe consultar exclusivamente las tablas existentes necesarias para establecer la cadena.

No se fija SQL, query string física ni mecanismo de join definitivo en esta especificación.

La estrategia debe cumplir simultáneamente:

1. caller-scoped Supabase client;
2. RLS vigente;
3. exact-one semantics donde la cardinalidad vigente lo exige;
4. no confiar en input de tenant/role;
5. validar el role retornado;
6. tratar errores/ambigüedad como deny;
7. no usar service-role;
8. no utilizar una cache cross-request.

Puede utilizar una o varias lecturas según la API real y el diseño mínimo más seguro.

No se exige transacción compleja.

No se introduce RPC.

No se introduce función SQL.

### 29.1 Estado concurrente

El contexto representa el estado observado por la request actual.

Los accesos posteriores a datos tenant-owned continúan sujetos a RLS y, por tanto, una revocación concurrente no puede utilizar un contexto de aplicación como bypass de la capa de datos.

Una request nueva debe volver a resolver estado autoritativo.

---

## 30. Cambios físicos futuros esperados

La futura implementación deberá confirmar este mapa contra el repositorio real antes de modificar.

Con la estructura y decisiones actuales, el cambio PR-sized esperado es crear el primer módulo funcional real de `Identity & Authorization`, consumiendo la infraestructura Supabase común existente.

### 30.1 Archivos nuevos previstos

Propuesta inicial:

```text
CREATE
src/modules/identity-authorization/application/authorization-context.ts
src/modules/identity-authorization/application/resolve-current-authorization-context.ts
src/modules/identity-authorization/infrastructure/supabase/current-authorization-source.ts
src/modules/identity-authorization/server.ts
tests/authoritative-online-authorization.test.ts
```

### 30.2 Responsabilidad esperada

`src/modules/identity-authorization/application/authorization-context.ts`

- contrato mínimo de `ValidatedAuthIdentity`;
- contrato mínimo de `CurrentAuthorizationContext`;
- roles tenant permitidos;
- outcomes/fail-closed necesarios;
- cero Supabase-specific types en el contrato público.

`src/modules/identity-authorization/application/resolve-current-authorization-context.ts`

- coordinación de la cadena autoritativa;
- exact-one semantics;
- fail-closed;
- no UI;
- no routing;
- no cache global.

`src/modules/identity-authorization/infrastructure/supabase/current-authorization-source.ts`

- adapter específico del bounded context;
- utiliza el client Supabase no privilegiado caller-scoped;
- consulta exclusivamente el modelo ya existente;
- no modifica schema/RLS;
- no expone detalles Supabase al contrato de aplicación.

`src/modules/identity-authorization/server.ts`

- superficie server-side pública mínima del módulo;
- composición de dependencies;
- no exporta capacidades client-side;
- no se convierte en un framework de autorización.

`tests/authoritative-online-authorization.test.ts`

- pruebas unitarias/integración de módulo;
- mocks/fakes deterministas cuando correspondan;
- pruebas negativas de stale state, spoofing y fail-closed.

### 30.3 Archivos existentes previstos

Por defecto:

```text
MODIFY = NINGUNO
```

La preferencia es consumir:

```text
src/infrastructure/supabase/server.ts
```

sin modificarlo.

Si el repositorio real exige un cambio mínimo en una superficie pública existente para permitir composición correcta, el cambio debe:

- ser estrictamente técnico;
- no añadir Auth funcional;
- no alterar Proxy;
- no alterar RLS;
- no cambiar cookies;
- no ampliar el scope de TASK-011.

Si no puede cumplirse así:

```text
BLOCKER
```

### 30.4 Archivos que deben permanecer intactos por defecto

```text
proxy.ts
src/infrastructure/supabase/proxy.ts
src/infrastructure/supabase/browser.ts
src/infrastructure/config/**
app/**
supabase/migrations/**
supabase/tests/database/**
docs/product/**
docs/architecture/**
package.json
package-lock.json
```

Los documentos canónicos no se modifican durante implementación técnica salvo una autorización documental separada.

### 30.5 Ajuste de nombres

Si el repositorio real posee una convención de nombres/materialización equivalente ya aprobada, se puede adaptar el nombre de archivo sin cambiar:

- bounded context;
- capas;
- responsabilidades;
- alcance;
- cantidad conceptual de componentes.

Una reestructuración arquitectónica material:

```text
BLOCKER
```

---

## 31. Dependencias

### 31.1 Expectativa

```text
nuevas dependencias = 0
```

La foundation debe poder implementarse con:

- Next.js existente;
- TypeScript existente;
- `@supabase/ssr` existente;
- `@supabase/supabase-js` existente;
- Vitest existente;
- infraestructura Supabase existente.

### 31.2 Baseline técnico conocido

Snapshot técnico previo disponible:

```text
@supabase/ssr = 0.12.5
@supabase/supabase-js = 2.112.4
next = 16.3.1
react = 19.2.8
react-dom = 19.2.8
typescript = 6.0.3
vitest = 4.1.10
```

Debe verificarse de nuevo durante preflight.

Si una dependencia nueva parece necesaria:

1. detener implementación;
2. documentar el problema concreto;
3. justificar por qué el stack actual no basta;
4. evaluar impacto browser/server;
5. evaluar seguridad y mantenimiento;
6. devolver a revisión.

No instalar por conveniencia.

---

## 32. Pruebas obligatorias

La futura implementación debe cubrir al menos los siguientes casos.

### 32.1 Identidad

**T012-001 — Request anónima**

```text
no validated Auth identity
→ no authorization context
```

**T012-002 — Subject válido con mapping válido**

Debe continuar hasta resolver el contexto cuando todos los estados vigentes son válidos.

**T012-003 — Subject sin mapping**

```text
DENY
```

**T012-004 — Mapping ambiguo/múltiple**

Aunque el schema actual lo impide normalmente, el contrato del resolver debe fallar cerrado ante un adapter que entregue un resultado incompatible.

### 32.2 PlatformUser

**T012-005 — PlatformUser inexistente**

```text
DENY
```

**T012-006 — Estado de habilitación de PlatformUser**

Debe verificar explícitamente que no se inventa un check inexistente en el schema actual.

Si una futura baseline añade ese estado antes de implementación, la especificación debe volver a revisión.

### 32.3 Membership

**T012-007 — Sin membership**

```text
DENY
```

**T012-008 — Membership habilitada**

```text
success
```

si toda la cadena restante es válida.

**T012-009 — Membership disabled/revoked**

```text
DENY
```

**T012-010 — Membership múltiple/ambigua inesperada**

```text
DENY
```

### 32.4 Role

**T012-011 — Role vigente**

El role del contexto debe ser el role actual de la membership.

**T012-012 — Stale role claim**

```text
JWT says COMPANY_ADMIN
DB says TECHNICIAN
→ TECHNICIAN
```

**T012-013 — Role desconocido**

```text
DENY
```

### 32.5 Tenant

**T012-014 — Tenant claim stale**

Un claim de otro tenant no altera el tenant derivado.

**T012-015 — Tenant cookie forged**

No altera el tenant derivado.

**T012-016 — Frontend tenant ID**

No es autoridad.

**T012-017 — UUID conocido de otro tenant**

No produce contexto cross-tenant.

**T012-018 — MaintenanceCompany inexistente/no visible**

```text
DENY
```

### 32.6 Revocación

**T012-019 — Nueva request después de revocación**

```text
previous request authorized
+
membership disabled/revoked
+
new request
→ DENY
```

**T012-020 — Contexto/cache anterior**

Un contexto previo no puede restaurar autorización en una request nueva.

### 32.7 Fallos

**T012-021 — Error de lookup**

```text
DENY / resolution error
```

sin fallback.

**T012-022 — Resultado parcial/inconsistente**

```text
DENY
```

### 32.8 Privilegios

**T012-023 — Sin service-role**

La implementación no introduce service-role, secret key, admin client ni bypass RLS.

### 32.9 Dos tenants

**T012-024 — Aislamiento A/B**

Un subject/membership del tenant A no obtiene contexto de tenant B mediante IDs o datos manipulados.

### 32.10 Tooling

**T012-025 — TypeScript strict**

Tests y compilación deben conservar strictness.

**T012-026 — Regression suite**

Tests existentes siguen pasando.

**T012-027 — Lint**

```text
npm run lint = PASS
```

**T012-028 — Typecheck**

```text
npm run typecheck = PASS
```

**T012-029 — Build**

```text
npm run build = PASS
```

**T012-030 — Verify**

Si el script continúa disponible:

```text
npm run verify = PASS
```

---

## 33. Security review obligatorio

La revisión posterior a implementación debe responder explícitamente:

### Identity

- ¿El caller sólo aporta una identidad Auth validada?
- ¿Se evita confiar en claims tenant/role?
- ¿Se evita confiar en IDs arbitrarios del request?

### Authorization

- ¿La membership vigente es consultada en cada request?
- ¿`is_enabled = false` elimina autorización?
- ¿El role proviene del estado vigente?
- ¿No existe success parcial?

### Multitenancy

- ¿El tenant se deriva de la membership?
- ¿Un tenant ID externo no redefine contexto?
- ¿No existe camino cross-tenant?

### Privilegios

- ¿Se mantiene caller-scoped publishable-key client?
- ¿No aparece service-role?
- ¿No aparece Admin Auth API?
- ¿No aparece `SECURITY DEFINER`?
- ¿No aparece RPC privilegiada?

### Stale state

- ¿Una request nueva no reutiliza contexto previo?
- ¿No existe cache global?
- ¿No existe singleton por usuario?
- ¿Una revocación vigente gana a JWT/session/cookies?

### Error handling

- ¿Todos los errores fallan cerrados?
- ¿No se filtran detalles internos?
- ¿No se registran tokens/cookies completos?

### Architecture

- ¿La autorización de producto vive en `Identity & Authorization` y no en infraestructura común?
- ¿`app/` permanece delgado?
- ¿No se crea framework genérico innecesario?

---

## 34. RLS review obligatorio

La revisión debe registrar explícitamente:

```text
RLS change = NO
```

y comprobar:

1. `supabase/migrations/**` sin cambios;
2. policies existentes sin cambios;
3. grants/revokes sin cambios;
4. ningún helper SQL nuevo;
5. ningún RPC;
6. ningún bypass;
7. las queries del adapter se ejecutan con el caller-scoped client;
8. el resolver no asume que haber pasado application auth sustituye RLS;
9. las pruebas negativas continúan coherentes con RLS;
10. cualquier acceso tenant-owned posterior seguirá necesitando RLS.

Resultado requerido:

```text
TASK-012 no debilita ni sustituye RLS
```

---

## 35. Fuera de alcance

TASK-012 no puede implementar ni diseñar como capacidad funcional:

- Auth funcional;
- login;
- signup;
- logout;
- OTP;
- email verification flow;
- resend flow;
- onboarding;
- `VerificationChallenge`;
- creación/gestión funcional de usuarios;
- `Client`;
- `UserClientAccess`;
- client scope;
- `SupportAccessGrant`;
- soporte excepcional;
- Auth UI;
- tenant selector;
- route authorization completa;
- protected routes;
- authorization guards funcionales;
- functional authorization guards;
- resource authorization completa;
- generic permission framework;
- Storage;
- Realtime;
- Offline;
- PWA authorization;
- Dexie;
- IndexedDB;
- outbox;
- Service Worker;
- AuditEvent producers;
- mutaciones funcionales;
- subscription entitlement;
- AI credits;
- nuevas tablas;
- nuevas columnas;
- nuevos enums DB;
- nuevas constraints;
- nuevos índices;
- nuevas migrations;
- SQL nuevo;
- nuevas policies RLS;
- modificaciones de RLS;
- grants/revokes;
- RPC;
- triggers;
- `SECURITY DEFINER`;
- service-role normal;
- admin client;
- session termination provider-side;
- ADR-0004;
- resolución de `DO-T04`;
- resolución de `OFF-OPEN-001`;
- resolución de `OFF-OPEN-002`;
- resolución de `FORM-OPEN-004`;
- ADR nuevo;
- microservicios;
- TASK-013;
- determinación del siguiente incremento.

---

## 36. Blockers de futura implementación

Codex deberá detenerse con `BLOCKER` ante cualquiera de las siguientes condiciones.

### 36.1 Repositorio y Git

1. repositorio distinto del esperado;
2. branch/base no coincide con autorización;
3. divergencia inesperada;
4. worktree contiene drift ajeno;
5. staged changes inesperados;
6. operación Git en progreso;
7. archivos de TASK-012 ya existen con contenido incompatible.

### 36.2 Documentación

8. una fuente canónica contradice materialmente esta TASK;
9. TASK-008/009/010/011 o CORR-013 ya no pueden considerarse cerradas;
10. ADR-0002 o ADR-0003 dejan de estar `ACCEPTED`;
11. aparece una decisión posterior que modifica este contrato.

### 36.3 Datos/RLS

12. el schema real no coincide con la foundation de TASK-009;
13. se necesita tabla nueva;
14. se necesita columna nueva;
15. se necesita migration;
16. se necesita SQL nuevo;
17. se necesita cambiar RLS;
18. se necesita policy nueva;
19. se necesita grant/revoke;
20. se necesita RPC;
21. se necesita `SECURITY DEFINER`;
22. se necesita service-role como camino normal.

### 36.4 Dominio

23. se necesita `VerificationChallenge`;
24. se necesita `Client`;
25. se necesita `UserClientAccess`;
26. se necesita `SupportAccessGrant`;
27. se necesita modelar estado de habilitación de `PlatformUser`;
28. se necesita modelar estado comercial/activo de `MaintenanceCompany`;
29. se necesita autorización por recurso;
30. se necesita route authorization funcional;
31. se necesita Auth funcional;
32. se necesita AuditEvent producer.

### 36.5 Arquitectura/open decisions

33. se necesita resolver ADR-0004;
34. se necesita resolver un `OPEN`;
35. aparece nueva decisión arquitectónica material;
36. se necesita ADR nuevo;
37. cumplir el objetivo exige microservicio o servicio externo de policy.

### 36.6 Seguridad

38. no puede garantizarse fail-closed;
39. no puede evitarse confiar en tenant/role del cliente;
40. no puede evitarse authorization state stale entre requests;
41. la única implementación viable requiere cache cross-request de autorización;
42. la única implementación viable requiere bypass de RLS;
43. existe contradicción con ADR-0002;
44. existe contradicción con ADR-0003.

### 36.7 Scope/testing

45. el diff deja de ser PR-sized;
46. se necesitan dependencias nuevas no aprobadas;
47. los tests no pueden demostrar revocación/fail-closed de forma determinista;
48. lint/typecheck/test/build fallan por cambios de TASK-012;
49. `git diff --check` falla;
50. aparecen archivos fuera del scope no justificables como test equivalente.

Ante cualquier blocker:

```text
NO autorepair
NO ampliar scope
NO instalar dependencias
NO crear migration
NO cambiar RLS
NO usar service-role
NO determinar TASK-013
retornar al Revisor Central
```

---

## 37. Preflight futuro obligatorio de Codex

### 37.1 Baseline humano histórico recibido al determinar TASK-012

```text
branch = main
HEAD = 3e741533af5a4dd51b7b2d891aeb78970cb8c79b
origin/main = 3e741533af5a4dd51b7b2d891aeb78970cb8c79b
divergencia = 0 0
worktree = limpio
```

Este snapshot es histórico.

No constituye SHA inmutable para una futura ejecución.

### 37.2 Comandos/read-only checks mínimos

Antes de modificar, Codex debe verificar el estado real mediante comandos equivalentes a:

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

Además debe inspeccionar:

```text
package.json
package-lock.json
tsconfig.json
src/modules/
src/infrastructure/supabase/
proxy.ts
tests/
supabase/migrations/
supabase/tests/database/
```

y las fuentes canónicas obligatorias.

### 37.3 Operaciones Git prohibidas durante preflight

Sin autorización humana separada, no ejecutar:

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

No modificar el repositorio para “hacer coincidir” el baseline.

Drift material:

```text
BLOCKER
```

---

## 38. Criterios de aceptación

Cada criterio debe clasificarse individualmente como `PASS`, `FAIL` o `BLOCKER`.

### Identidad y contrato

**AC-012-001** — TASK-012 sigue siendo exclusivamente una foundation de autorización online autoritativa.

**AC-012-002** — La entrada parte de una identidad Auth validada server-side.

**AC-012-003** — Auth identity y authorization context están separados.

**AC-012-004** — El resultado exitoso contiene sólo el contexto mínimo aprobado.

**AC-012-005** — No se exponen tokens, cookies o claims completos en el contexto.

### Resolución

**AC-012-006** — Auth subject resuelve exactamente el mapping aplicable.

**AC-012-007** — Mapping ausente niega autorización.

**AC-012-008** — Mapping ambiguo niega autorización.

**AC-012-009** — PlatformUser inexistente niega autorización.

**AC-012-010** — No se inventa estado `PlatformUser.enabled`.

**AC-012-011** — Membership ausente niega autorización.

**AC-012-012** — Membership disabled/revoked niega autorización.

**AC-012-013** — Membership ambigua niega autorización.

**AC-012-014** — MaintenanceCompany inexistente/no visible niega autorización.

**AC-012-015** — No se inventa estado comercial/activo de MaintenanceCompany.

**AC-012-016** — Role se deriva de membership vigente.

**AC-012-017** — Role desconocido niega autorización.

### Stale state/revocation

**AC-012-018** — JWT tenant claim no determina tenant.

**AC-012-019** — JWT role claim no determina role.

**AC-012-020** — Tenant cookie no determina tenant.

**AC-012-021** — Role cookie no determina role.

**AC-012-022** — Frontend tenant ID no determina tenant.

**AC-012-023** — Path/query/body/header no determinan autorización.

**AC-012-024** — Una request nueva después de revocación queda denegada.

**AC-012-025** — Contexto/cache de una request anterior no conserva autorización.

**AC-012-026** — No existe cache global/cross-request de autorización.

### Multitenancy

**AC-012-027** — `tenant = MaintenanceCompany` permanece.

**AC-012-028** — Tenant se deriva de membership vigente.

**AC-012-029** — Conocer un tenant ID ajeno no concede acceso.

**AC-012-030** — Test A/B demuestra que tenant A no obtiene contexto de B.

**AC-012-031** — SUPER_ADMIN no obtiene tenant context por ausencia de membership.

### RLS/privilegios

**AC-012-032** — `RLS change = NO`.

**AC-012-033** — No se modifican migrations.

**AC-012-034** — No se modifican policies.

**AC-012-035** — No se modifican grants/revokes.

**AC-012-036** — No se introduce service-role.

**AC-012-037** — No se introduce secret key/admin client.

**AC-012-038** — La foundation no sustituye RLS.

### Scope

**AC-012-039** — No se crea `Client`.

**AC-012-040** — No se crea `UserClientAccess`.

**AC-012-041** — No se crea `SupportAccessGrant`.

**AC-012-042** — No se crea `VerificationChallenge`.

**AC-012-043** — No se implementa Auth funcional.

**AC-012-044** — No se implementa route authorization.

**AC-012-045** — No se implementa resource authorization.

**AC-012-046** — No se implementa Offline.

**AC-012-047** — No se implementa UI.

**AC-012-048** — No se implementan AuditEvent producers.

**AC-012-049** — No se crea ADR.

**AC-012-050** — No se determina TASK-013.

### Arquitectura

**AC-012-051** — La lógica reside bajo el módulo `Identity & Authorization`.

**AC-012-052** — `src/infrastructure/` no contiene reglas de autorización de producto.

**AC-012-053** — El adapter Supabase queda encapsulado dentro de infraestructura del módulo.

**AC-012-054** — `app/` permanece sin lógica de autorización de TASK-012.

**AC-012-055** — No existen dependencias circulares nuevas.

**AC-012-056** — TypeScript strict permanece.

### Calidad

**AC-012-057** — Tests específicos TASK-012 = PASS.

**AC-012-058** — Suite completa = PASS.

**AC-012-059** — `npm run lint = PASS`.

**AC-012-060** — `npm run typecheck = PASS`.

**AC-012-061** — `npm run build = PASS`.

**AC-012-062** — `npm run verify = PASS` si el script continúa vigente.

**AC-012-063** — `git diff --check = PASS`.

**AC-012-064** — Cero archivos inesperados.

**AC-012-065** — Cero secrets/tokens expuestos.

---

## 39. Verificación futura obligatoria

Al finalizar la implementación técnica y antes de cualquier staging, Codex deberá reportar:

### 39.1 Diff

```text
git status --short
git status --porcelain=v1 --untracked-files=all
git diff --name-only
git diff --stat
git diff --numstat
git diff --check
git diff --cached --name-only
```

Debe enumerar además cualquier archivo untracked nuevo de TASK-012.

### 39.2 Tests

Reportar:

- tests específicos TASK-012;
- tests globales;
- lint;
- typecheck;
- build;
- verify;
- resultados exactos de criterios de aceptación.

### 39.3 Seguridad

Confirmar:

```text
service-role = NO
secret key = NO
admin client = NO
RLS change = NO
schema change = NO
migration = NO
SQL nuevo = NO
UI = NO
Offline = NO
Auth funcional = NO
Client = NO
UserClientAccess = NO
SupportAccessGrant = NO
AuditEvent producer = NO
```

### 39.4 Git

Confirmar:

```text
staged = ninguno
commit = NO
push = NO
```

La implementación de Codex no debe incorporar Git por sí sola.

---

## 40. Definition of Done

TASK-012 sólo puede considerarse formalmente completada después de una secuencia equivalente a:

1. especificación `READY FOR REVIEW`;
2. revisión humana de especificación;
3. correcciones documentales, si corresponden;
4. aprobación formal de especificación;
5. canonicalización;
6. revisión humana de canonicalización;
7. autorización humana separada de implementación;
8. preflight Git fresco;
9. relectura de fuentes canónicas;
10. implementación mediante Codex dentro del scope;
11. tests específicos PASS;
12. lint PASS;
13. typecheck PASS;
14. tests globales PASS;
15. build PASS;
16. verify PASS;
17. `git diff --check` PASS;
18. revisión integral del diff;
19. revisión arquitectónica;
20. revisión de seguridad;
21. revisión de multitenancy;
22. revisión específica de RLS;
23. revisión de stale-state/revocación;
24. revisión de regresiones;
25. aprobación humana de la implementación;
26. incorporación Git mediante autorización separada;
27. verificación Git posterior;
28. cierre humano final.

Debe mantenerse:

```text
Codex PASS
!=
TASK-012 completada
```

y:

```text
implementación técnica
!=
incorporación Git autorizada
!=
cierre humano final
```

---

## 41. Gate posterior

La secuencia de governance posterior a esta entrega es:

```text
TASK-012 = APPROVED FOR IMPLEMENTATION
→ revisión humana del artefacto aprobado
→ canonicalización controlada
→ revisión de canonicalización
→ incorporación Git de la especificación mediante autorización separada
→ autorización humana separada de implementación
→ prompt exacto y separado para Codex
→ Codex implementa sin staging/commit/push
→ revisión de arquitectura/seguridad/RLS/regresiones
→ incorporación Git separadamente autorizada
→ verificación Git
→ cierre humano final de TASK-012
→ retorno al Revisor Central
```

Debe permanecer:

```text
TASK-012 completada
!=
TASK-013 determinada automáticamente
```

TASK-012 no determina ni genera TASK-013.

---

## 42. Estado resultante de esta especificación

```text
TASK-012 SPECIFICATION = PASS
TASK-012 SPEC REVIEW = APPROVED
TASK-012 HUMAN SPEC APPROVAL = APPROVED

TASK-012 estado = APPROVED FOR IMPLEMENTATION

TASK-012 determinada = SÍ
TASK-012 generada = SÍ
TASK-012 especificada = SÍ
TASK-012 aprobada = SÍ
TASK-012 canonicalizada = NO
TASK-012 implementación autorizada = NO
TASK-012 implementada = NO

cambio de producto = NO
cambio de arquitectura = NO
cambio de multitenancy = NO
cambio de schema = NO
cambio de RLS = NO

ADR nuevo requerido = NO
OPEN resuelto = NINGUNO

UI flow = NO APLICA EN TASK-012
Offline behavior = NO APLICA / FUERA DE ALCANCE
RLS change = NO

TASK-013 determinada = NO
TASK-013 generada = NO
```

---

## 43. Entrega

**Archivo generado:**

```text
TASK-012-authoritative-online-authorization-foundation-approved.md
```

**Ruta canónica futura propuesta:**

```text
docs/tasks/TASK-012-authoritative-online-authorization-foundation.md
```

**Estado:**

```text
APPROVED FOR IMPLEMENTATION
```

No se implementó TASK-012.

No se utilizó Codex.

No se modificó el repositorio.

No se modificó Supabase Cloud.

No se creó migration.

No se escribió SQL ejecutable.

No se escribió RLS ejecutable.

No se realizó `git add`.

No se realizó commit.

No se realizó push.

No se determinó TASK-013.

No se generó TASK-013.
