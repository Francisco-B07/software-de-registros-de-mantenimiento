# TASK-011 — Fundación mínima del lifecycle Auth SSR

## 1. Identificación

**ID:** `TASK-011`

**Título:** `TASK-011 — Fundación mínima del lifecycle Auth SSR`

**Tipo:** `IMPLEMENTATION TASK`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:** `TASK-011-auth-ssr-lifecycle-foundation-approved.md`

**Ruta canónica futura propuesta:** `docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md`

**TASK-011 determinada:** `SÍ`

**TASK-011 generada:** `SÍ`

**TASK-011 especificada:** `SÍ`

**TASK-011 aprobada:** `SÍ`

**Implementación autorizada:** `NO`

**Implementación realizada:** `NO`

**Codex autorizado:** `NO`

**Repositorio modificado durante esta preparación:** `NO`

**Supabase Cloud modificado durante esta preparación:** `NO`

**Git modificado durante esta preparación:** `NO`

**TASK-012 determinada:** `NO`

**TASK-012 generada:** `NO`

Esta especificación define exclusivamente el contrato técnico de un futuro incremento PR-sized. El estado `APPROVED FOR IMPLEMENTATION` significa que la especificación está aprobada para una futura implementación que requerirá una autorización humana concreta y separada. No constituye implementación, no autoriza una ejecución concreta, no autoriza Codex y no autoriza modificar el repositorio ni Supabase Cloud durante esta aprobación documental.

---

## 2. Objetivo

TASK-011 define el incremento PR-sized que debe completar exclusivamente la **foundation técnica mínima del lifecycle Auth SSR** necesaria para que una sesión Supabase Auth pueda mantenerse correctamente en Next.js/App Router mediante el patrón SSR oficial vigente.

Debe partir de la frontera implementada por TASK-008 y añadir únicamente la infraestructura técnica necesaria para:

- leer cookies de Auth desde contexto server-side;
- permitir el contrato de escritura de cookies exigido por `@supabase/ssr`;
- refrescar/validar técnicamente la identidad Auth desde Proxy conforme al patrón oficial vigente;
- propagar cookies renovadas hacia la request consumida por Server Components;
- propagar cookies renovadas hacia la response que vuelve al browser;
- conservar las directivas anti-cache asociadas a respuestas que contienen `Set-Cookie`;
- mantener los clientes Supabase caller-scoped y no privilegiados;
- probar localmente esas boundaries de forma determinista.

Principio obligatorio:

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

TASK-011 no implementa un caso de uso de producto.

Una implementación correcta de TASK-011 no habilita por sí sola:

- login;
- logout;
- signup;
- OTP;
- onboarding;
- autorización de tenant;
- autorización por rol;
- client scope;
- soporte excepcional;
- guards de rutas;
- redirects funcionales.

---

## 3. Baseline autoritativo

### 3.1 Estado cerrado consumido

Se consume como estado autoritativo:

```text
Fase 0 = COMPLETADA
Fase 1 = COMPLETADA
Fase 2 = INICIADA

TASK-008 = COMPLETADA
TASK-009 = COMPLETADA
TASK-010 = COMPLETADA
CORR-012 = COMPLETADA

Supabase application boundary = IMPLEMENTADA

Browser factory = IMPLEMENTADA
Server factory no privilegiada = IMPLEMENTADA

MaintenanceCompany físico = SÍ
PlatformUser físico = SÍ
Auth subject → PlatformUser físico = SÍ
CompanyMembership físico = SÍ

AuditEvent foundation física = SÍ
```

Continúan:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Refresh funcional de access token = NO
Proxy/middleware Auth funcional = NO

Authorization ready = NO
VerificationChallenge = NO

Client = NO
UserClientAccess = NO
SupportAccessGrant = NO
Application authorization completa = NO

Storage funcional = NO
Realtime funcional = NO
Offline funcional = NO
UI funcional de Fase 2 = NO

Productores funcionales de AuditEvent = NO
auditoría funcional completa = NO
```

### 3.2 Snapshot Git humano recibido

Se consume como evidencia histórica:

```text
branch = main
HEAD = 16ea7a061dd20721b159a16e2ff7b4d31b5820a1
origin/main = 16ea7a061dd20721b159a16e2ff7b4d31b5820a1
divergencia = 0 0
worktree = limpio
```

Este snapshot no es una precondición inmutable de una futura ejecución.

Antes de implementar TASK-011 debe ejecutarse un preflight Git fresco contra el repositorio real autorizado.

### 3.3 Estado físico previo relevante

TASK-009 ya materializó y probó la foundation mínima:

```text
Auth subject
→ PlatformUser
→ CompanyMembership vigente
→ MaintenanceCompany
```

La existencia de esa foundation física no convierte la sesión Auth en fuente de autorización.

TASK-010 materializó exclusivamente `AuditEvent foundation física = SÍ` y no implementó productores funcionales.

### 3.4 Regla de continuidad

TASK-011 consume las foundations anteriores sin reabrirlas.

No puede utilizar el lifecycle Auth SSR para modificar:

- el modelo físico de identidad;
- las reglas RLS;
- el catálogo físico de AuditEvent;
- las decisiones de autorización;
- la estrategia offline.

---

## 4. Fuentes obligatorias

La futura implementación debe leer íntegramente y respetar al menos:

### 4.1 Producto

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md`

### 4.2 Arquitectura

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`

### 4.3 Tareas y correcciones

- `docs/tasks/TASK-008-supabase-application-boundary.md`
- `docs/tasks/TASK-009-identity-tenant-foundation.md`
- `docs/tasks/TASK-010-audit-event-foundation.md`
- `docs/tasks/CORR-012-task-010-closure-state-sync.md`

### 4.4 Repositorio real

Antes de modificar debe inspeccionarse nuevamente:

- `package.json`;
- `package-lock.json`;
- `src/infrastructure/config/`;
- `src/infrastructure/supabase/`;
- `app/`;
- `tests/`;
- `supabase/`;
- cualquier `proxy.ts`;
- cualquier `middleware.ts`;
- cualquier superficie de cookies/Auth/session introducida después de esta preparación;
- estado Git real.

No debe asumirse que la estructura observada durante esta preparación continúa inmutable.

---

## 5. Fuentes técnicas externas y conclusión vigente

### 5.1 Fuentes oficiales verificadas

Fecha de verificación para esta especificación: `2026-08-27`.

Se verificaron exclusivamente fuentes oficiales para detalles técnicos cambiantes:

- Supabase — Server-Side Rendering:  
  `https://supabase.com/docs/guides/auth/server-side`
- Supabase — Creating a Supabase client for SSR / Next.js:  
  `https://supabase.com/docs/guides/auth/server-side/creating-a-client?framework=nextjs&queryGroups=framework`
- Supabase — Advanced guide:  
  `https://supabase.com/docs/guides/auth/server-side/advanced-guide`
- Supabase — `getClaims`:  
  `https://supabase.com/docs/reference/javascript/auth-getclaims`
- Supabase — `getUser`:  
  `https://supabase.com/docs/reference/javascript/auth-getuser`
- Supabase — `getSession`:  
  `https://supabase.com/docs/reference/javascript/auth-getsession`
- Next.js — Proxy file convention:  
  `https://nextjs.org/docs/app/api-reference/file-conventions/proxy`
- Next.js — `cookies`:  
  `https://nextjs.org/docs/app/api-reference/functions/cookies`

La documentación externa sólo determina detalles técnicos de integración. No redefine tenancy, roles, permisos, RLS, fases ni autorización del producto.

### 5.2 Patrón oficial vigente relevante

La documentación oficial vigente establece para Next.js/App Router:

1. browser client y server client separados;
2. `@supabase/ssr` como helper de SSR;
3. cookies mediante `getAll` / `setAll`;
4. Server Components pueden leer cookies pero no escribirlas durante render;
5. Proxy debe realizar el lifecycle técnico de refresh necesario para que Server Components reciban el token renovado y el browser reciba la cookie renovada;
6. el Proxy actual usa `supabase.auth.getClaims()` para validar/refrescar la identidad Auth;
7. las cookies actualizadas deben propagarse tanto a `request.cookies` como a `response.cookies`;
8. cuando `@supabase/ssr` entregue headers anti-cache al callback `setAll`, esos headers deben aplicarse a la response;
9. `getSession()` no es una primitive de confianza para validar identidad en server code basado en cookies.

### 5.3 Convención vigente de Next.js

La versión actual de Next.js del repositorio es `16.3.1`.

Desde Next.js 16:

```text
middleware.ts
→ convención deprecada

proxy.ts
→ convención vigente
```

El `proxy.ts` debe ubicarse al mismo nivel que `app/`. Dado que el repositorio actual utiliza `app/` en la raíz, la ubicación prevista es:

```text
/proxy.ts
```

### 5.4 Versiones reales observadas

La inspección read-only del `main` público actual muestra:

```text
@supabase/ssr = 0.12.5
@supabase/supabase-js = 2.112.4
next = 16.3.1
react = 19.2.8
react-dom = 19.2.8
typescript = 6.0.3
vitest = 4.1.10
```

`package.json` y el root package de `package-lock.json` coinciden en estas versiones.

### 5.5 Clasificación de dependencias

Para TASK-011:

```text
cambio de dependencias requerido = NO
package.json esperado modificado = NO
package-lock.json esperado modificado = NO
```

Las APIs requeridas por el patrón vigente ya están presentes en las dependencias instaladas.

TASK-011 no autoriza upgrade, downgrade ni repinning por inferencia.

Si durante la futura ejecución `npm ci`, TypeScript o la API real instalada contradicen esta conclusión:

```text
BLOCKER
```

No cambiar versiones para “hacer funcionar” TASK-011 sin revisión humana.

### 5.6 Inspección actual de la frontera Supabase

El repositorio actual contiene:

```text
src/infrastructure/supabase/browser.ts
src/infrastructure/supabase/server.ts
```

`browser.ts` ya utiliza `createBrowserClient` con configuración pública.

`server.ts` ya utiliza `createServerClient` con:

```text
cookies.getAll()
```

pero no posee actualmente:

```text
cookies.setAll()
```

Los tests existentes comprueban explícitamente ese estado read-only previo.

No existe actualmente en la raíz:

```text
proxy.ts
middleware.ts
```

La aplicación visible actual continúa siendo un bootstrap técnico y no contiene Auth UI.

### 5.7 Revisión de contradicciones

Resultado de preparación:

```text
contradicciones materiales bloqueantes detectadas = 0
```

El patrón oficial vigente puede incorporarse como detalle técnico de infraestructura dentro de ADR-0001/0002/0003 sin introducir una decisión arquitectónica nueva.

---

## 6. Frontera central de seguridad

Deben preservarse en significado exacto:

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

TASK-011 puede demostrar o mantener exclusivamente una identidad Auth válida.

No puede utilizar como fuente autoritativa de autorización:

- JWT claims;
- cookies;
- session metadata;
- frontend input;
- pathname;
- query string;
- headers elegidos por el cliente;
- local storage;
- contexto de UI.

Esos elementos no pueden determinar por sí solos:

- tenant;
- `MaintenanceCompany`;
- `CompanyMembership`;
- role;
- client scope;
- support scope;
- permiso funcional.

La jerarquía vigente continúa siendo:

```text
base de datos / estado autoritativo vigente / reglas RLS aprobadas
>
claims / session / cookies / context stale
```

En particular:

```text
getClaims() válido
!=
CompanyMembership vigente
```

y:

```text
getUser() auténtico
!=
tenant autorizado
```

---

## 7. Objetivo técnico mínimo y requisitos

### RQ-011-001 — Browser factory

La factory existente:

```text
src/infrastructure/supabase/browser.ts
```

debe preservarse dentro de la frontera aprobada por TASK-008.

No debe adquirir:

- service-role;
- configuración privada;
- tenant resolution;
- role resolution;
- authorization;
- queries de producto;
- Auth mutations funcionales.

### RQ-011-002 — Server factory

La factory existente:

```text
src/infrastructure/supabase/server.ts
```

debe continuar:

```text
server-side
+
publishable-key / caller-scoped
+
no privilegiada
```

Debe extender su cookie adapter desde el estado read-only actual hacia el contrato SSR vigente:

```text
getAll
+
setAll
```

sin convertir la factory en Auth service, authorization service ni session manager.

### RQ-011-003 — Lectura de cookies

`getAll()` debe leer exclusivamente el cookie store request-scoped proporcionado por Next.js.

No debe:

- persistir cookies en memoria global;
- construir un singleton server client;
- reutilizar cookies entre requests;
- interpretar cookies como permisos.

### RQ-011-004 — Escritura desde server client

`setAll()` debe adoptar la semántica oficial vigente de `@supabase/ssr`.

Next.js no permite mutar cookies durante render de Server Components. Por tanto:

- la factory server debe ser compatible con la limitación oficial;
- el lifecycle de refresh no debe depender de una escritura desde Server Component;
- la responsabilidad primaria de refresh/propagación de TASK-011 recae en Proxy;
- la excepción técnica esperada por intento de escritura desde un Server Component no puede reinterpretarse como “cookie propagada correctamente”;
- ningún error puede convertirse en identidad autorizada por fallback.

La tolerancia específica exigida por el patrón oficial para el contexto read-only de Server Components no autoriza silenciamiento general de errores en otras fronteras.

### RQ-011-005 — Proxy técnico

Debe introducirse la frontera de Proxy requerida por el patrón oficial actual.

Su responsabilidad exclusiva es:

```text
request
→ client Supabase caller-scoped request-scoped
→ validación/refresh técnico de identidad Auth
→ propagación de cookies a request
→ propagación de cookies a response
→ response
```

No contiene casos de uso de producto.

### RQ-011-006 — Primitive de identidad

En la baseline técnica vigente, Proxy debe invocar:

```text
supabase.auth.getClaims()
```

como primitive oficial de validación/refresh técnico.

No debe utilizar:

```text
getSession()
```

como sustituto de validación de identidad.

No debe utilizar `getClaims()` para resolver autorización de aplicación.

### RQ-011-007 — Orden crítico

La creación del client request-scoped y la llamada de validación/refresh deben mantenerse consecutivas conforme a la recomendación oficial.

No insertar entre ambas:

- queries de dominio;
- autorización;
- lógica de negocio;
- redirects;
- resolución de tenant;
- resolución de rol.

### RQ-011-008 — Propagación a Server Components

Cuando `@supabase/ssr` solicite actualizar cookies, el Proxy debe actualizar la representación de cookies de la request que continuará hacia la aplicación.

Objetivo técnico:

```text
cookie Auth renovada
→ request consumida por Server Components
```

Esto evita que una Server Component opere sobre una versión anterior del token dentro de la misma request.

### RQ-011-009 — Propagación al browser

La misma actualización debe materializarse en la response:

```text
cookie Auth renovada
→ Set-Cookie de response
→ browser
```

No devolver una nueva response que pierda las cookies establecidas por la frontera Supabase.

### RQ-011-010 — Headers anti-cache

El callback `setAll` del Proxy debe preservar y aplicar a la response los headers entregados por `@supabase/ssr` para respuestas que contienen refresh de sesión.

Como mínimo debe respetarse el contrato vigente que puede incluir:

- `Cache-Control`;
- `Expires`;
- `Pragma`.

No hardcodear una lista divergente si la API instalada suministra el conjunto autoritativo mediante el callback.

### RQ-011-011 — Request scoped

Cada request debe crear su propio server client.

Prohibido:

- singleton global de server client;
- cache de client por proceso;
- estado de sesión compartido entre requests;
- variables globales con cookies/tokens.

### RQ-011-012 — Configuración

TASK-011 reutiliza exactamente el contrato público de TASK-008:

```text
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY
```

No añade nuevas env vars.

### RQ-011-013 — Sin queries de producto

La foundation no debe ejecutar:

```text
.from(...)
.rpc(...)
storage.*
channel(...)
```

ni cualquier query a datos de producto.

### RQ-011-014 — Sin Auth mutation funcional

TASK-011 no debe ejecutar como caso de uso:

- signIn;
- signUp;
- signOut;
- OTP;
- password reset;
- magic link;
- admin user mutation.

Una operación interna de refresh gestionada por el SDK como parte del lifecycle SSR no equivale a un flow funcional de Auth.

### RQ-011-015 — Sin redirects de negocio

Proxy no debe redirigir por:

- ausencia de sesión;
- tenant;
- role;
- membership;
- client scope;
- support scope.

Una request anónima sigue siendo técnicamente válida para rutas públicas mientras no exista un guard funcional aprobado.

### RQ-011-016 — Matcher técnico mínimo

Debe existir un matcher sólo si continúa siendo necesario para evitar ejecutar Proxy sobre recursos estáticos.

El matcher permitido debe basarse únicamente en exclusiones técnicas tales como:

- `_next/static`;
- `_next/image`;
- favicon;
- assets estáticos equivalentes.

Prohibido:

```text
pathname
→ permiso
```

y:

```text
pathname
→ tenant
```

El matcher no es una lista de rutas “protegidas”.

### RQ-011-017 — Respuesta preservada

Si el helper del lifecycle crea o reemplaza un `NextResponse`, debe preservar:

- la request actualizada;
- todas las cookies Supabase ya establecidas;
- headers anti-cache suministrados;
- semántica de response requerida por el SDK.

No recrear una response posterior descartando cookies.

### RQ-011-018 — Sin estado de dominio

La foundation no persiste ni mantiene estado propio de sesión fuera de Supabase Auth cookies.

No crear:

- session registry;
- tabla de sesiones;
- cache de membership;
- tenant cookie autoritativa;
- role cookie autoritativa;
- application JWT propio.

---

## 8. Proxy

### 8.1 Archivo de convención

Con Next.js `16.3.1` y `app/` en la raíz, la futura implementación puede crear:

```text
proxy.ts
```

en la raíz del proyecto.

Ese archivo debe permanecer delgado y delegar el trabajo técnico a la frontera existente bajo:

```text
src/infrastructure/supabase/
```

### 8.2 Helper de infraestructura

La ubicación prevista para la lógica técnica reutilizable es:

```text
src/infrastructure/supabase/proxy.ts
```

Este archivo pertenece a infrastructure, no a un bounded context Auth funcional.

### 8.3 Responsabilidad

El Proxy de TASK-011 puede exclusivamente:

1. recibir `NextRequest`;
2. construir client Supabase caller-scoped con configuración pública;
3. leer request cookies mediante `getAll`;
4. permitir que `setAll` actualice request cookies;
5. reconstruir/preservar la `NextResponse` cuando el SDK lo requiera;
6. copiar cookies renovadas a response;
7. aplicar headers anti-cache recibidos;
8. invocar `getClaims()` para el lifecycle técnico;
9. devolver la response resultante.

### 8.4 Prohibiciones

Proxy no puede convertirse en:

- tenant authorization;
- role authorization;
- product authorization middleware;
- route guard;
- business redirect;
- tenant resolver;
- role resolver;
- membership resolver;
- client scope resolver;
- `SupportAccessGrant` resolver;
- subscription resolver;
- UI routing policy.

### 8.5 Ausencia de sesión

La ausencia normal de cookies/sesión representa un caller anónimo.

TASK-011 no debe convertirla en:

- error de producto;
- redirect a `/login`;
- permiso;
- tenant.

La request puede continuar como anónima porque todavía no existe route authorization.

### 8.6 Sesión inválida

Una cookie o sesión inválida:

- no produce identidad confiable;
- no produce tenant;
- no produce role;
- no produce membership;
- no produce autorización.

La frontera debe dejar que el SDK aplique la semántica técnica soportada de invalidación/refresh/limpieza cuando corresponda y no debe inventar una sesión válida.

### 8.7 Fallo técnico inesperado

Un fallo inesperado de configuración, validación o propagación no puede convertirse en “allow”.

Debe producir un fallo técnico sanitizado o propagarse a la boundary de error correspondiente sin exponer tokens ni secretos.

---

## 9. Identidad Auth: `getClaims`, `getUser`, `getSession`

### 9.1 `getClaims()`

Según la documentación oficial vigente:

- valida el JWT;
- con signing keys asimétricas puede verificar la firma contra JWKS/cache local;
- con signing keys simétricas puede requerir validación remota;
- devuelve claims derivados del JWT;
- es la primitive actual utilizada por el patrón de Proxy de Supabase para Next.js.

Dentro de TASK-011 su significado máximo es:

```text
JWT Auth técnicamente validado
```

No significa:

```text
tenant autorizado
role autorizado
membership vigente
client scope vigente
support scope vigente
```

Prohibido:

```text
getClaims()
→ tenant autorizado
```

```text
getClaims()
→ role autorizado
```

```text
getClaims()
→ membership vigente
```

### 9.2 `getUser()`

`getUser()` realiza una request al Auth server y devuelve un user record actualizado/autenticado por el proveedor.

TASK-011 no lo necesita para la foundation vigente porque el patrón oficial actual de Proxy utiliza `getClaims()`.

Aunque una fuente externa describa `getUser()` como utilizable para autorización genérica de Auth, dentro de este producto:

```text
getUser()
!=
CompanyMembership vigente
!=
tenant authorization
```

La autoridad de aplicación continúa en base de datos/RLS.

### 9.3 `getSession()`

`getSession()` devuelve el raw session desde storage y puede refrescarla técnicamente según el SDK, pero el contenido cargado desde cookies no constituye evidencia suficiente de identidad/autorización server-side.

Por tanto:

```text
getSession()
→ fuente de autorización
```

queda prohibido.

TASK-011 no requiere `getSession()` para Proxy.

### 9.4 Cambio futuro de primitive

Si antes de implementación la documentación oficial cambia y deja de recomendar `getClaims()` para este patrón:

```text
BLOCKER
```

La tarea vuelve al Revisor Central si el reemplazo introduce una decisión material no cubierta por el scope aprobado.

---

## 10. Privilegios

TASK-011 no puede introducir:

```text
service-role
secret key
Admin Auth API
admin client
SECURITY DEFINER
RPC privilegiada
bypass RLS
```

La única configuración Supabase permitida continúa siendo pública:

```text
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY
```

El server client continúa siendo:

```text
server-side
+
publishable-key / caller-scoped
+
no privilegiado
```

La mera ejecución server-side:

```text
!=
autorización
```

No crear una segunda factory privilegiada.

---

## 11. Dominio y datos

### 11.1 Entidades

**Entidades nuevas:** `NINGUNA`

**Entidades modificadas:** `NINGUNA`

### 11.2 Tablas preservadas

TASK-011 no puede modificar:

- `maintenance_companies`;
- `platform_users`;
- `platform_user_auth_subjects`;
- `company_memberships`;
- `audit_events`.

### 11.3 Entidades no creadas

No puede crear:

- `VerificationChallenge`;
- `Client`;
- `UserClientAccess`;
- `SupportAccessGrant`.

### 11.4 Persistencia

```text
Schema = NO
Migration = NO
SQL = NO
RLS nueva/modificada = NO
Policies nuevas/modificadas = NO
Grants/revokes DB = NO
```

`supabase/` debe permanecer íntegramente sin cambios durante TASK-011.

---

## 12. AuditEvent

TASK-011 no implementa una mutación sensible de dominio.

Por tanto:

```text
AuditEvent producer = NO
```

No crear AuditEvent para:

- refresh técnico;
- validación de JWT;
- lectura de sesión;
- Proxy;
- lectura de cookies;
- escritura/propagación de cookies.

Las cuatro acciones físicas actuales permanecen exactamente:

```text
USER_CREATED
USER_DISABLED_OR_REVOKED
USER_REINSTATED
USER_ROLE_CHANGED
```

Permanecen no físicamente habilitadas:

```text
USER_CLIENT_ACCESS_CHANGED
SUPPORT_ACCESS_GRANTED
SUPPORT_ACCESS_SCOPE_CHANGED
SUPPORT_ACCESS_REVOKED
SUPPORT_ACCESS_USED
```

TASK-011 no modifica catálogo, CHECK, schema, producer ni RLS de AuditEvent.

---

## 13. Auth funcional fuera de alcance

TASK-011 no implementa:

- login;
- logout;
- signup;
- OTP;
- email + code flow;
- onboarding;
- invitation;
- password reset;
- magic link funcional;
- `VerificationChallenge`;
- alta de empresa;
- alta del primer `COMPANY_ADMIN`;
- alta de usuarios posteriores.

No crear UI de Auth.

No crear:

```text
/login
```

ni shell autenticada.

Si una revisión futura de la documentación oficial demostrara que un lifecycle técnico básico exige una UI o flow funcional real:

```text
BLOCKER
```

No ampliar scope.

---

## 14. Autorización fuera de alcance

No implementar:

- tenant resolver;
- role resolver;
- membership application resolver;
- client scope resolver;
- `SupportAccessGrant` resolver;
- authorization service;
- route authorization;
- permission guards;
- access-control UI.

TASK-011 no puede declarar:

```text
Authorization ready = SÍ
```

La foundation autoritativa completa de autorización corresponde a incrementos posteriores.

---

## 15. Revocación

TASK-011 no reimplementa ni duplica las garantías RLS probadas por TASK-009.

Debe preservarse:

```text
membership revocada
+
JWT/session residual
→
NO conserva autorización tenant
```

porque la autorización de aplicación depende de estado autoritativo vigente y RLS, no de la mera existencia de una sesión Auth.

TASK-011 no implementa:

- flow funcional de disable/revoke;
- provider-side termination;
- reinstatement;
- role change;
- AuditEvent producer correspondiente.

Provider-side termination continúa siendo defensa adicional futura.

No convertir el Proxy en mecanismo de revocación de autorización.

---

## 16. UI

**UI funcional aplicable:** `NO`

No crear:

- formularios;
- login;
- logout controls;
- OTP controls;
- onboarding;
- authenticated dashboard;
- tenant selector;
- role selector;
- permission UI.

La aplicación visible actual debe permanecer funcionalmente equivalente.

La página bootstrap actual no necesita modificación para TASK-011.

Por defecto:

```text
app/** = NO CHANGE
```

Si cumplir el lifecycle exigiera modificar una superficie visible:

```text
BLOCKER
```

salvo cambio técnico no funcional demostrablemente inevitable y expresamente cubierto por revisión.

---

## 17. Offline

**Comportamiento offline aplicable:** `NO`

No implementar:

- IndexedDB;
- Dexie;
- Service Worker;
- `OfflineAuthorizationState`;
- auth offline propia;
- session offline propia;
- membership cache local;
- logout/purge offline;
- outbox.

Debe preservarse:

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

TASK-011:

```text
OPEN resuelto = NINGUNO
```

---

## 18. ADR

Debe permanecer:

```text
ADR-0001 = ACCEPTED
ADR-0002 = ACCEPTED
ADR-0003 = ACCEPTED
```

Clasificación:

```text
ADR nuevo requerido = NO
```

Justificación:

- ADR-0001 ya ubica integraciones técnicas bajo infrastructure dentro del monolito modular;
- ADR-0002 ya limita privilegio y mantiene RLS como frontera primaria;
- ADR-0003 ya separa identidad Auth de autorización vigente;
- Next.js Proxy + cookie adapter son detalles de integración reversibles dentro de esa arquitectura.

Si durante la futura ejecución aparece una decisión arquitectónica material no cubierta:

```text
TASK-011 = BLOCKER
ADR nuevo requerido = REVISIÓN HUMANA
```

No redactar ni aprobar un ADR silenciosamente.

---

## 19. Archivos y arquitectura

### 19.1 Principio

La implementación debe extender la frontera transversal existente:

```text
src/infrastructure/supabase/
```

No crear un bounded context Auth funcional.

No crear por anticipado:

```text
AuthService
AuthorizationService
SessionManager
```

### 19.2 Estado actual inspeccionado

Existen:

```text
src/infrastructure/supabase/browser.ts
src/infrastructure/supabase/server.ts
tests/supabase-factories.test.ts
```

No existen actualmente:

```text
proxy.ts
middleware.ts
src/infrastructure/supabase/proxy.ts
```

### 19.3 Archivos esperados de una futura implementación

Scope físico previsto:

**MODIFY**

```text
src/infrastructure/supabase/server.ts
tests/supabase-factories.test.ts
```

**CREATE**

```text
src/infrastructure/supabase/proxy.ts
proxy.ts
tests/supabase-auth-ssr-lifecycle.test.ts
```

Cantidad máxima prevista:

```text
5 archivos
```

La implementación puede consolidar las pruebas específicas dentro de los tests existentes únicamente si conserva cobertura equivalente y reduce el diff; no puede utilizar esa flexibilidad para modificar otras categorías.

### 19.4 Archivos esperados sin cambio

Por defecto deben permanecer intactos:

```text
src/infrastructure/supabase/browser.ts
src/infrastructure/config/**
package.json
package-lock.json
app/**
docs/product/**
docs/architecture/**
supabase/**
```

También deben permanecer intactos los módulos de dominio y aplicación.

### 19.5 Drift

Si antes de implementar ya existe Proxy/Auth/cookie infrastructure posterior que cambia materialmente este mapa:

```text
BLOCKER
```

No sobrescribir ni duplicar una frontera existente.

---

## 20. Fail-closed y manejo de errores

### 20.1 Configuración faltante o inválida

Debe preservarse la frontera de configuración de TASK-008:

```text
config ausente/inválida
→ fallo explícito sanitizado
```

Prohibido:

```text
config inválida
→ fallback a proyecto demo
```

### 20.2 Cookies ausentes

Cookies ausentes:

```text
→ caller anónimo
```

No equivalen a error de autorización porque TASK-011 no implementa route authorization.

Tampoco equivalen a tenant o role.

### 20.3 Cookies inválidas / sesión inválida

Una cookie inválida o una identidad no validable:

```text
→ identidad Auth no confiable
→ cero inferencia de autorización
```

El SDK puede limpiar/renovar su storage conforme a su contrato técnico, pero TASK-011 no puede otorgar acceso por fallback.

### 20.4 Fallo de validación/refresh

Un fallo inesperado de validación/refresh:

- no se convierte en `authorized`;
- no se convierte en tenant;
- no se silencia para fabricar una identidad;
- no expone el token en el error;
- debe producir fallo técnico sanitizado cuando no sea la condición normal de caller anónimo.

### 20.5 Escritura de cookies

La limitación conocida de Next.js que impide escribir cookies durante render de Server Components debe tratarse exclusivamente conforme al patrón oficial, porque el Proxy es el writer del lifecycle.

Fuera de esa limitación concreta:

```text
fallo de propagación
!=
éxito
```

El Proxy no puede descartar silenciosamente cookies o headers suministrados por `@supabase/ssr`.

### 20.6 Logs

Prohibido registrar:

- access token;
- refresh token;
- cookie Auth completa;
- secret key;
- service-role;
- contenido sensible de sesión.

Los errores públicos deben ser sanitizados.

### 20.7 Fallo de autorización por mal uso

Si código nuevo intenta derivar tenant/role/membership desde cookies o claims:

```text
TASK-011 = FAIL
```

No existe fallback permitido.

---

## 21. Caching

### 21.1 Riesgo

Una response que contiene `Set-Cookie` de Auth no puede ser reutilizada entre usuarios.

El riesgo a evitar es:

```text
response de Usuario A con Set-Cookie
→ cache compartida
→ response servida a Usuario B
```

### 21.2 Contrato mínimo

Desde `@supabase/ssr >= 0.10.0`, el lifecycle puede suministrar al callback `setAll` headers de control de cache.

La versión actual `0.12.5` está dentro de ese contrato.

TASK-011 debe:

- aceptar el segundo argumento de headers de `setAll` en Proxy;
- aplicar esos headers a la response;
- preservar `Set-Cookie`;
- no sobrescribir después esos headers con una response nueva;
- probar la propagación de headers anti-cache.

### 21.3 ISR

No introducir ISR en rutas donde ocurra refresh de Auth.

TASK-011 no modifica páginas ni define rutas autenticadas, por lo que no debe añadir una estrategia general de `dynamic`, revalidation o caching a `app/`.

### 21.4 Scope

TASK-011 no diseña una estrategia general de cache de aplicación.

Sólo protege la boundary que puede emitir cookies de Auth.

---

## 22. Pruebas

Las pruebas deben ser locales, reproducibles y no depender de credenciales reales.

### 22.1 Browser boundary

Verificar:

1. browser factory continúa usando configuración pública;
2. browser factory no utiliza private config;
3. browser factory no contiene service-role/secret;
4. browser factory no hace request al construirse;
5. browser factory no cambia por TASK-011.

### 22.2 Server factory

Verificar:

1. usa `createServerClient`;
2. usa URL + publishable key;
3. posee `cookies.getAll`;
4. posee `cookies.setAll`;
5. `getAll` delega al cookie store request-scoped;
6. `setAll` aplica cookies al cookie store cuando el contexto permite escritura;
7. no usa service-role;
8. no usa secret key;
9. no hace query de producto al construirse;
10. no contiene Auth mutation funcional.

### 22.3 Proxy helper

Verificar con mocks deterministas:

1. crea client server caller-scoped por request;
2. `getAll` lee `request.cookies`;
3. `setAll` actualiza request cookies;
4. `setAll` actualiza response cookies;
5. `setAll` preserva opciones de cookie;
6. `setAll` aplica headers proporcionados por `@supabase/ssr`;
7. la response final conserva cookies;
8. la response final conserva headers;
9. invoca `auth.getClaims()` exactamente como primitive técnica del lifecycle;
10. no invoca `getSession()` para validar identidad;
11. no ejecuta queries de producto;
12. no ejecuta redirects funcionales;
13. no resuelve tenant;
14. no resuelve role;
15. no resuelve membership;
16. no resuelve client scope;
17. no resuelve support scope.

### 22.4 Root Proxy

Verificar:

1. existe la convención `proxy.ts`;
2. delega en la frontera de infrastructure;
3. no contiene lógica de dominio;
4. el matcher sólo excluye recursos técnicos/estáticos;
5. matcher no expresa permisos;
6. no existe redirect a `/login`;
7. no existe pathname → permission.

### 22.5 Seguridad negativa

Buscar y fallar ante introducción de:

```text
service_role
SUPABASE_SERVICE_ROLE_KEY
SUPABASE_SECRET_KEY
admin.
auth.admin
signIn
signUp
signOut
exchangeCodeForSession
verifyOtp
.from(
.rpc(
storage.
channel(
```

Las coincidencias históricas/documentales o en dependencias deben clasificarse; el test debe centrarse en archivos de aplicación modificados por TASK-011.

### 22.6 Ausencias de dominio

Verificar que TASK-011 no:

- modifica migrations;
- modifica schema;
- modifica RLS;
- modifica AuditEvent;
- crea AuditEvent producer;
- crea `VerificationChallenge`;
- crea `Client`;
- crea `UserClientAccess`;
- crea `SupportAccessGrant`;
- crea UI;
- crea offline state.

### 22.7 Fail-closed

Probar al menos:

- config faltante → error sanitizado;
- config inválida → error sanitizado cuando corresponda al contrato existente;
- caller sin cookies → no tenant/no role/no authz;
- identity validation error → no identidad autorizada;
- cookie propagation callback → no pérdida silenciosa de cookies/headers;
- logs/test errors no contienen access/refresh tokens.

### 22.8 No red real

Los tests específicos de TASK-011:

```text
no requieren Supabase access token
no requieren password
no requieren service-role
no requieren usuario real
no requieren proyecto remoto
```

---

## 23. Development / remote Auth verification applicability

Clasificación:

```text
Development/remote Auth verification applicability = NO APLICABLE
```

### 23.1 Justificación

TASK-011 no pretende demostrar:

- login end-to-end;
- logout end-to-end;
- OTP;
- sesión real generada por un flujo de producto;
- refresh real de un access token expirado contra Supabase Cloud;
- provider-side termination;
- autorización de aplicación.

Las garantías que sí pretende declarar son boundaries técnicas deterministas:

- shape `getAll/setAll`;
- request/response propagation;
- invocación de `getClaims`;
- ausencia de privilegios;
- ausencia de authz;
- headers anti-cache;
- integración Proxy;
- fail-closed.

Todas pueden probarse localmente mediante mocks y tests de integración de módulos sin credenciales reales.

### 23.2 Consecuencia de estado

Por no existir Gate remoto y no existir flow Auth real, una implementación correcta de TASK-011 **no puede declarar**:

```text
Refresh funcional de access token = SÍ
Auth SSR lifecycle completo = SÍ
Proxy/middleware Auth funcional = SÍ
```

Sí puede declarar:

```text
Auth SSR lifecycle foundation = IMPLEMENTADA
SSR cookie propagation boundary = IMPLEMENTADA
Auth Proxy technical boundary = IMPLEMENTADA
```

### 23.3 Cambio de necesidad

Si durante implementación se descubre que una garantía incluida en TASK-011 sólo puede validarse con sesión real:

```text
BLOCKER
```

No crear fixtures remotos ni tocar Supabase Cloud sin una revisión separada.

---

## 24. Checks de repositorio

La futura implementación debe primero verificar los scripts reales de `package.json`.

Con el baseline actual existen:

```text
npm run lint
npm run typecheck
npm run test
npm run build
npm run verify
```

Además debe ejecutar:

```text
git diff --check
```

y los tests específicos de TASK-011 mediante el mecanismo real de Vitest.

### 24.1 Preflight Git mínimo

Antes de modificar:

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

No autoreparar drift mediante:

- pull;
- merge;
- rebase;
- reset;
- restore;
- stash;
- clean.

Drift material inesperado:

```text
BLOCKER
```

### 24.2 Validación del diff

Al finalizar implementación técnica, antes de cualquier Git add:

```text
git diff --name-only
git diff --stat
git diff --numstat
git diff --check
git status --short
```

El diff debe permanecer dentro del scope aprobado.

---

## 25. Criterios de aceptación

### Foundation y patrón oficial

**AC-011-001** — `TASK-011` conserva exactamente el alcance de foundation técnica de lifecycle Auth SSR.

**AC-011-002** — La implementación utiliza el patrón oficial vigente de Supabase SSR para Next.js/App Router.

**AC-011-003** — `@supabase/ssr` continúa siendo la dependencia utilizada para browser/server SSR boundary.

**AC-011-004** — No se cambia ninguna versión de dependencia como parte de TASK-011.

**AC-011-005** — La browser factory existente se preserva funcionalmente.

**AC-011-006** — La server factory continúa caller-scoped y no privilegiada.

**AC-011-007** — La server factory posee `cookies.getAll`.

**AC-011-008** — La server factory posee el contrato `cookies.setAll` requerido por el patrón oficial vigente.

**AC-011-009** — Se implementa la frontera técnica Proxy mediante la convención vigente de Next.js 16.

**AC-011-010** — Proxy utiliza `getClaims()` como primitive técnica vigente de validación/refresh.

**AC-011-011** — Proxy no utiliza `getSession()` como primitive de confianza para validar identidad.

**AC-011-012** — Cookies renovadas se propagan a la request consumida por Server Components.

**AC-011-013** — Cookies renovadas se propagan a la response consumida por el browser.

**AC-011-014** — Opciones de cookies entregadas por el SDK se preservan.

**AC-011-015** — Headers suministrados por `@supabase/ssr` en `setAll` se aplican a la response.

**AC-011-016** — La response final no descarta cookies ni headers del lifecycle.

**AC-011-017** — Cada request usa un server client request-scoped.

**AC-011-018** — No existe singleton global con estado Auth.

### Seguridad y privilegios

**AC-011-019** — `authenticated != authorized` permanece preservado.

**AC-011-020** — `valid Auth session != tenant authorization` permanece preservado.

**AC-011-021** — `valid JWT claims != current membership authorization` permanece preservado.

**AC-011-022** — `getClaims()` no resuelve tenant.

**AC-011-023** — `getClaims()` no resuelve role.

**AC-011-024** — `getClaims()` no resuelve membership.

**AC-011-025** — Cookies/session no resuelven client scope.

**AC-011-026** — Cookies/session no resuelven support scope.

**AC-011-027** — `service-role` está ausente.

**AC-011-028** — secret key está ausente.

**AC-011-029** — Admin Auth API está ausente.

**AC-011-030** — admin client está ausente.

**AC-011-031** — no se introduce bypass RLS.

**AC-011-032** — server-side no se interpreta como autorización.

**AC-011-033** — access tokens no se registran en logs.

**AC-011-034** — refresh tokens no se registran en logs.

**AC-011-035** — errores públicos quedan sanitizados.

### Autenticación y autorización fuera de alcance

**AC-011-036** — `Auth funcional = NO`.

**AC-011-037** — `Auth SSR lifecycle completo = NO`.

**AC-011-038** — `Refresh funcional de access token = NO`.

**AC-011-039** — `Proxy/middleware Auth funcional = NO`.

**AC-011-040** — `Authorization ready = NO`.

**AC-011-041** — route authorization continúa `NO`.

**AC-011-042** — tenant resolver continúa `NO`.

**AC-011-043** — role resolver continúa `NO`.

**AC-011-044** — membership application resolver continúa `NO`.

**AC-011-045** — no se crea redirect funcional de Auth.

**AC-011-046** — no se crea `/login`.

**AC-011-047** — no se implementa login.

**AC-011-048** — no se implementa logout.

**AC-011-049** — no se implementa signup.

**AC-011-050** — no se implementa OTP/email+code flow.

### Datos, dominio y auditoría

**AC-011-051** — `VerificationChallenge = NO`.

**AC-011-052** — `Client = NO`.

**AC-011-053** — `UserClientAccess = NO`.

**AC-011-054** — `SupportAccessGrant = NO`.

**AC-011-055** — schema no cambia.

**AC-011-056** — migrations no cambian.

**AC-011-057** — SQL no cambia.

**AC-011-058** — RLS no cambia.

**AC-011-059** — policies no cambian.

**AC-011-060** — grants/revokes DB no cambian.

**AC-011-061** — AuditEvent schema/catálogo no cambia.

**AC-011-062** — no se crea AuditEvent producer.

**AC-011-063** — las cuatro acciones físicas actuales permanecen sin modificación.

**AC-011-064** — las cinco acciones futuras permanecen no habilitadas.

### UI, offline y caching

**AC-011-065** — UI funcional de Fase 2 continúa ausente.

**AC-011-066** — `app/**` permanece funcionalmente equivalente.

**AC-011-067** — Offline continúa `NO`.

**AC-011-068** — no se introduce Dexie/IndexedDB/Service Worker.

**AC-011-069** — ADR-0004 continúa `BLOCKED BY OPEN DECISIONS`.

**AC-011-070** — los blockers de ADR-0004 continúan exactamente `DO-T04`, `OFF-OPEN-001`, `OFF-OPEN-002`, `FORM-OPEN-004`.

**AC-011-071** — TASK-011 no resuelve ningún OPEN.

**AC-011-072** — respuestas que refrescan Auth aplican los headers anti-cache entregados por `@supabase/ssr`.

**AC-011-073** — ninguna response con `Set-Cookie` Auth se configura deliberadamente como cache compartida.

**AC-011-074** — TASK-011 no introduce una estrategia general de caching.

### Pruebas, checks y diff

**AC-011-075** — tests específicos de browser/server boundary = `PASS`.

**AC-011-076** — tests específicos de cookie read plumbing = `PASS`.

**AC-011-077** — tests específicos de cookie write/propagation = `PASS`.

**AC-011-078** — tests específicos de Proxy/getClaims boundary = `PASS`.

**AC-011-079** — tests específicos de anti-cache headers = `PASS`.

**AC-011-080** — tests negativos de tenant/role/membership derivation = `PASS`.

**AC-011-081** — tests negativos de service-role/secret/Admin Auth = `PASS`.

**AC-011-082** — tests negativos de Auth mutations/redirects = `PASS`.

**AC-011-083** — tests no requieren red real ni credenciales reales.

**AC-011-084** — `npm run lint = PASS`.

**AC-011-085** — `npm run typecheck = PASS`.

**AC-011-086** — `npm run test = PASS`.

**AC-011-087** — `npm run build = PASS`.

**AC-011-088** — `npm run verify = PASS`.

**AC-011-089** — `git diff --check = PASS`.

**AC-011-090** — diff limitado exclusivamente al scope aprobado.

**AC-011-091** — `package.json` permanece sin cambios.

**AC-011-092** — `package-lock.json` permanece sin cambios.

**AC-011-093** — `docs/product/**` permanece sin cambios.

**AC-011-094** — `docs/architecture/**` permanece sin cambios.

**AC-011-095** — `supabase/**` permanece sin cambios.

### Estado resultante

**AC-011-096** — `Auth SSR lifecycle foundation = IMPLEMENTADA` puede declararse después de cierre técnico y humano.

**AC-011-097** — `SSR cookie propagation boundary = IMPLEMENTADA` puede declararse después de cierre.

**AC-011-098** — `Auth Proxy technical boundary = IMPLEMENTADA` puede declararse después de cierre.

**AC-011-099** — no se declara `Auth SSR lifecycle completo = SÍ`.

**AC-011-100** — no se declara `Authorization ready = SÍ`.

---

## 26. Blockers

La futura ejecución debe detenerse con `BLOCKER` si ocurre cualquiera de las siguientes condiciones.

### 26.1 Git y baseline

1. Git presenta drift material inesperado.
2. branch/upstream/divergencia no coinciden con la autorización concreta.
3. worktree contiene cambios ajenos que impiden aislar TASK-011.
4. la especificación canónica vigente contradice materialmente esta preparación.
5. TASK-008/009/010 o CORR-012 ya no pueden considerarse cerradas según autoridad vigente.

### 26.2 Patrón técnico

6. la documentación oficial Supabase deja de respaldar `@supabase/ssr` para este patrón.
7. `getAll/setAll` deja de ser la API vigente y el reemplazo implica un cambio material.
8. Next.js cambia materialmente la convención Proxy aplicable al repositorio.
9. `getClaims()` deja de ser la primitive oficial de esta frontera y el cambio exige una decisión no cubierta.
10. la API real instalada contradice el contrato asumido y resolverlo exige cambiar dependencias.

### 26.3 Scope

11. cumplir el lifecycle exige implementar Auth funcional.
12. cumplir el lifecycle exige login/logout/signup/OTP.
13. cumplirlo exige route authorization.
14. cumplirlo exige tenant resolution.
15. cumplirlo exige role resolution.
16. cumplirlo exige membership application resolution.
17. cumplirlo exige `Client`, `UserClientAccess` o `SupportAccessGrant`.
18. cumplirlo exige schema.
19. cumplirlo exige migration.
20. cumplirlo exige SQL.
21. cumplirlo exige RLS nueva/modificada.
22. cumplirlo exige service-role.
23. cumplirlo exige secret key.
24. cumplirlo exige Admin Auth API/admin client.
25. cumplirlo exige modificar AuditEvent.
26. cumplirlo exige `VerificationChallenge`.
27. cumplirlo exige Auth UI funcional.
28. cumplirlo exige comportamiento offline.
29. cumplirlo exige resolver un OPEN.
30. cumplirlo exige trabajo de Fase 3 o posterior.
31. el scope deja de ser PR-sized.

### 26.4 Arquitectura

32. aparece una nueva decisión arquitectónica material no cubierta por ADR-0001/0002/0003.
33. se requiere un nuevo ADR todavía no aprobado.
34. aparece una segunda frontera Supabase/Auth incompatible ya implementada.
35. existe un `proxy.ts`/`middleware.ts` posterior cuyo contrato no puede integrarse sin ampliar scope.

### 26.5 Validación

36. tests específicos no pueden ser deterministas sin credenciales reales.
37. una garantía pretendida sólo puede demostrarse mediante Supabase Cloud real.
38. lint/typecheck/test/build/verify no pasan por un cambio de TASK-011.
39. `git diff --check` falla.
40. el diff contiene archivos fuera del scope aprobado.

Ante cualquier BLOCKER:

```text
no ampliar scope
no implementar
no usar autorepair
retornar al Revisor Central
```

---

## 27. Cambios esperados

### 27.1 Scope físico previsto

Una futura implementación autorizada puede afectar exclusivamente, conforme al estado real actualmente inspeccionado:

```text
MODIFY
src/infrastructure/supabase/server.ts
tests/supabase-factories.test.ts

CREATE
src/infrastructure/supabase/proxy.ts
proxy.ts
tests/supabase-auth-ssr-lifecycle.test.ts
```

### 27.2 Contenido esperado

`src/infrastructure/supabase/server.ts`:

- conservar client no privilegiado;
- añadir contrato SSR de escritura de cookies;
- no añadir Auth funcional.

`src/infrastructure/supabase/proxy.ts`:

- client request-scoped;
- getAll/setAll de request/response;
- `getClaims()`;
- headers anti-cache;
- cero autorización de producto.

`proxy.ts`:

- delegación delgada;
- matcher exclusivamente técnico;
- sin lógica de dominio.

Tests:

- boundaries;
- cookie propagation;
- Proxy;
- anti-cache;
- seguridad negativa.

### 27.3 Fuera del diff previsto

No modificar por defecto:

```text
package.json
package-lock.json
.env.example
src/infrastructure/config/**
src/infrastructure/supabase/browser.ts
app/**
docs/product/**
docs/architecture/**
docs/tasks/** durante implementación
supabase/migrations/**
supabase/tests/database/**
supabase/config.toml
```

No modificar schema ni RLS.

### 27.4 Regla de diff

Si el diff necesita una categoría adicional:

```text
BLOCKER
```

salvo que se trate de un test específico equivalente consolidado dentro de la categoría `tests/` y permanezca inequívocamente dentro del scope aprobado.

---

## 28. Definition of Done

La revisión humana de la especificación y la aprobación documental ya fueron completadas. Desde `TASK-011 = APPROVED FOR IMPLEMENTATION`, TASK-011 sólo puede cerrarse después de completar, en orden, el siguiente lifecycle de governance:

1. canonicalización;
2. revisión humana de canonicalización;
3. autorización humana separada de implementación;
4. preflight Git fresco;
5. relectura de todas las fuentes obligatorias;
6. reverificación de documentación oficial vigente;
7. verificación de versiones reales y ausencia de dependency change necesario;
8. implementación exclusivamente dentro del scope mediante Codex;
9. tests específicos TASK-011 = `PASS`;
10. `npm run lint = PASS`;
11. `npm run typecheck = PASS`;
12. `npm run test = PASS`;
13. `npm run build = PASS`;
14. `npm run verify = PASS`;
15. `git diff --check = PASS`;
16. revisión integral del diff;
17. revisión arquitectónica;
18. revisión de seguridad;
19. revisión de multitenancy;
20. revisión de regresiones;
21. verificación de que Auth funcional continúa `NO`;
22. verificación de que Authorization ready continúa `NO`;
23. verificación de que schema/RLS/AuditEvent permanecen intactos;
24. Gate Development sólo si una revisión aprobada posterior cambiara su aplicabilidad;
25. incorporación Git mediante autorización humana separada;
26. verificación Git posterior;
27. cierre humano final.

La implementación técnica por sí sola:

```text
!=
TASK-011 cerrada
```

---

## 29. Gate posterior

El estado documental actual es `TASK-011 = APPROVED FOR IMPLEMENTATION`.

La secuencia posterior obligatoria es:

`canonicalización → revisión humana de canonicalización → autorización humana separada de implementación → preflight Git fresco → implementación mediante Codex → tests/checks → revisión local → Gate Development únicamente si una revisión aprobada posterior cambia su aplicabilidad → incorporación Git mediante autorización separada → verificación Git → cierre humano final`.

Debe permanecer: `aprobación documental != canonicalización != implementación autorizada != implementación realizada != cierre`.

Después del cierre humano final de TASK-011, el estado vuelve al:

```text
REVISOR CENTRAL
```

para una nueva evaluación separada.

Debe mantenerse:

```text
TASK-011 completada
!=
Auth funcional completa
```

```text
TASK-011 completada
!=
Authorization ready
```

```text
TASK-011 completada
!=
TASK-012 determinada
```

TASK-011 no determina ni genera TASK-012.

No existe autorización automática del incremento siguiente.

---

## 30. Estado resultante esperado

### 30.1 Estados que una implementación correcta puede cambiar

Después de implementación, revisión y cierre humano puede declararse:

```text
Auth SSR lifecycle foundation = IMPLEMENTADA
SSR cookie propagation boundary = IMPLEMENTADA
Auth Proxy technical boundary = IMPLEMENTADA
```

### 30.2 Estados que deben continuar en NO

Debe conservarse:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Refresh funcional de access token = NO
Proxy/middleware Auth funcional = NO

Authorization ready = NO
route authorization = NO
tenant resolver = NO
role resolver = NO

VerificationChallenge = NO
Client = NO
UserClientAccess = NO
SupportAccessGrant = NO
Application authorization completa = NO

Storage funcional = NO
Realtime funcional = NO
Offline funcional = NO
UI funcional de Fase 2 = NO

Productores funcionales de AuditEvent = NO
auditoría funcional completa = NO
```

### 30.3 Justificación de `Auth SSR lifecycle completo = NO`

TASK-011 no implementa ningún flow que produzca una sesión real ni incluye un Gate remoto con access/refresh token reales.

Por tanto, sus pruebas demuestran:

```text
infraestructura de lifecycle correcta
```

pero no demuestran:

```text
lifecycle funcional end-to-end de una sesión real de producto
```

Declarar `Auth SSR lifecycle completo = SÍ` excedería la evidencia del slice.

### 30.4 Revocación

Permanece:

```text
membership revocada
+
session/JWT residual
→
NO autorización tenant
```

por las garantías autoritativas/RLS existentes, no porque TASK-011 termine la sesión provider-side.

---

## 31. Resultado de esta aprobación documental

```text
TASK-011 = APPROVED FOR IMPLEMENTATION

TASK-011 determinada = SÍ
TASK-011 generada = SÍ
TASK-011 especificada = SÍ
TASK-011 aprobada = SÍ

Implementación autorizada = NO
implementación realizada = NO
Codex autorizado = NO
repositorio modificado = NO
Supabase Cloud modificado = NO
Git modificado = NO

Development/remote Auth verification applicability = NO APLICABLE

cambio de dependencias requerido = NO
schema = NO
migration = NO
SQL = NO
RLS nueva/modificada = NO
AuditEvent producer = NO
UI funcional = NO
Offline = NO

ADR nuevo requerido = NO
OPEN resuelto = NINGUNO

TASK-012 determinada = NO
TASK-012 generada = NO

contradicciones materiales bloqueantes detectadas = 0

TASK-011 SPECIFICATION = PASS
TASK-011 SPEC REVIEW = APPROVED
```

`TASK-011 SPECIFICATION = PASS` conserva el resultado de preparación de la especificación. `TASK-011 SPEC REVIEW = APPROVED` registra que la revisión humana de la especificación fue completada y aprobada.

La aprobación documental no autoriza la implementación actual, Codex, la modificación del repositorio ni Supabase Cloud. La implementación futura requiere una autorización humana concreta y separada.

---

## 32. Entrega

**Archivo generado:**

```text
TASK-011-auth-ssr-lifecycle-foundation-approved.md
```

**Ruta canónica futura propuesta:**

```text
docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md
```

**Estado:**

```text
APPROVED FOR IMPLEMENTATION
```

No se implementó TASK-011.

No se utilizó Codex.

No se modificó el repositorio.

No se modificó Supabase Cloud.

No se realizó Git add, commit ni push.

No se determinó TASK-012.

No se generó TASK-012.
