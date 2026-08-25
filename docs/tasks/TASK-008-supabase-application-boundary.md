# TASK-008 — Frontera de integración Supabase de la aplicación

# 1. ID

`TASK-008`

# 2. Título

`Frontera de integración Supabase de la aplicación`

# 3. Tipo

`IMPLEMENTATION TASK`

Primera tarea PR-sized de:

`Fase 2 — Multitenancy, autenticación, roles y RLS`

La tarea introduce únicamente la frontera técnica mínima para que la aplicación Next.js pueda crear clientes Supabase browser/server de forma controlada.

No implementa todavía autenticación funcional, modelo físico de identidad, tenancy funcional, roles, memberships, client scope, soporte excepcional ni RLS ejecutable.

# 4. Estado

`TASK-008 = APPROVED FOR IMPLEMENTATION`

**Archivo de entrega aprobado:**

`TASK-008-supabase-application-boundary-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/TASK-008-supabase-application-boundary.md`

**Implementación autorizada:** `NO`

**Codex autorizado:** `NO`

**Ejecución concreta autorizada:** `NO`

**Repositorio modificado durante esta aprobación documental:** `NO`

**Fase 2:** `INICIADA`

**RLS ejecutable en esta TASK:** `NO`

**UI en esta TASK:** `NO`

**Comportamiento offline aplicable:** `NO`

**Auth funcional:** `NO`

**Auth SSR lifecycle completo:** `NO`

Esta especificación está aprobada como contrato para futura implementación, pero no autoriza ninguna ejecución concreta.

---

# 5. Objetivo

Introducir el **baseline mínimo de integración de aplicación con Supabase** necesario para los incrementos posteriores de Fase 2, sin adelantar Auth funcional ni el diseño físico de autorización.

TASK-008 debe dejar disponibles:

1. dependencias oficiales Supabase apropiadas para Next.js/App Router;
2. configuración pública Supabase integrada al contrato de entorno existente;
3. una factory browser/client-safe;
4. una factory server-side no privilegiada;
5. pruebas técnicas locales de configuración y boundaries;
6. placeholders no sensibles en `.env.example`.

Principio central:

```text
Supabase application boundary
≠ Supabase Auth funcional
≠ Auth SSR lifecycle completo
≠ autorización
≠ tenancy
≠ RLS
```

TASK-008 no consulta ni muta datos de producto.

---

# 6. Contexto

Estado de fase consumido:

```text
Fase 1 = COMPLETADA

Gate de entrada a Fase 2 evaluado = SÍ
Gate de entrada a Fase 2 satisfecho = SÍ

PHASE 2 FORMAL START = APPROVED
PHASE 2 FORMAL START HUMAN REVIEW = APPROVED

Fase 2 = INICIADA

CORR-009 = COMPLETADA

TASK-008 autorizada = NO
TASK-008 redactada = NO
Implementación concreta Fase 2 autorizada = NO
```

Estado Git recibido para esta definición:

```text
branch = main
HEAD = f536369df1f52e9c776aa16fa09c2e7a147ab30f
origin/main = f536369df1f52e9c776aa16fa09c2e7a147ab30f
divergencia = 0 0
worktree = limpio
```

Ese SHA es sólo baseline de **preparación**. Una futura ejecución deberá repetir el preflight contra el SHA expresamente autorizado en ese momento.

La baseline técnica ya posee Next.js, TypeScript estricto, skeleton modular, contrato de entorno/secretos, Supabase CLI y un proyecto Supabase Cloud exclusivo de Development, pero deliberadamente terminó Fase 1 sin integración funcional de la aplicación con Supabase.

## 6.1 Precondiciones ya satisfechas

Se consideran satisfechas para **definir** TASK-008:

- Fase 1 completada;
- Gate Fase 2 evaluado y satisfecho;
- Fase 2 iniciada;
- ADR-0001 aceptado;
- ADR-0002 aceptado;
- ADR-0003 aceptado;
- DO-T03 resuelto/aprobado;
- baseline Supabase Development existente;
- contrato de configuración existente;
- skeleton modular existente.

## 6.2 Decisiones arquitectónicas cerradas

Se consumen como cerradas:

```text
tenant = MaintenanceCompany
authenticated != authorized
RLS = frontera primaria
```

Además:

- estado autoritativo vigente prevalece;
- `CompanyMembership`, rol, `UserClientAccess` y `SupportAccessGrant` son fuentes conceptuales de autorización;
- `COMPANY_ADMIN` no posee ejecución inicial;
- `TECHNICIAN` opera sólo sobre clientes autorizados;
- `SUPER_ADMIN` no obtiene bypass tenant ordinario;
- revocación online debe ser inmediata;
- `service-role` es excepcional;
- provider-side termination es defense in depth.

## 6.3 Decisiones físicas todavía no tomadas

Permanecen diferidas:

- tablas;
- columnas;
- PK/FK;
- índices;
- constraints;
- schema PostgreSQL;
- RLS física;
- helper functions;
- vínculo físico Auth subject → `PlatformUser`;
- cardinalidad inversa Auth;
- claims;
- custom claims;
- Auth hooks;
- TTL;
- `session_id`;
- session registry;
- Storage;
- mecanismo provider-side concreto.

TASK-008 no las resuelve.

## 6.4 OPEN que bloquean TASK-008

`NINGUNO IDENTIFICADO`

En particular:

```text
ADR-0004 = BLOCKED BY OPEN DECISIONS
```

con:

```text
DO-T04
OFF-OPEN-001
OFF-OPEN-002
FORM-OPEN-004
```

no bloquea esta tarea porque TASK-008 no implementa réplica local, logout offline, purge, autorización offline ni Form Engine.

---

# 7. Fuentes canónicas

La futura implementación debe leer íntegramente:

## 7.1 Producto

- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/04-offline-sync-strategy.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md`

## 7.2 Arquitectura

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`

## 7.3 Governance y baseline técnica

- `docs/tasks/CORR-009-phase-2-formal-start-state-sync.md`
- `docs/tasks/TASK-003-modular-skeleton.md`
- `docs/tasks/TASK-004-environment-secrets.md`
- `docs/tasks/TASK-005-supabase-local.md`
- `docs/tasks/CORR-002-supabase-cloud-development.md`
- `docs/tasks/TASK-006-ci-baseline.md`
- `docs/tasks/TASK-007-phase-1-smoke-docs-review.md`

## 7.4 Repositorio real

Inspeccionar antes de modificar:

- `package.json`;
- `package-lock.json`;
- `.env.example`;
- `.gitignore`;
- superficies `.env*` sin revelar valores;
- `src/infrastructure/config/`;
- `src/infrastructure/`;
- `src/modules/`;
- `app/`;
- tests;
- ESLint;
- TypeScript;
- Vitest;
- referencias Supabase;
- `supabase/`;
- estado Git.

## 7.5 Fuentes técnicas externas

La futura implementación deberá verificar en documentación oficial vigente de Supabase el patrón soportado para Next.js/App Router.

La revisión humana actual confirma como patrón vigente:

- `@supabase/supabase-js`;
- `@supabase/ssr`;
- browser client;
- server client;
- `NEXT_PUBLIC_SUPABASE_URL`;
- `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`.

También confirma que un lifecycle Auth SSR completo requiere infraestructura adicional de cookies/refresh y, en particular, un Proxy para refrescar tokens cuando se implemente Auth SSR.

TASK-008 no implementa esa infraestructura adicional.

La documentación externa sólo puede determinar detalles técnicos de integración.

No puede redefinir requisitos de producto, roles, tenancy ni seguridad.

No se fijan versiones concretas de paquetes durante esta corrección documental.

---

# 8. Preconditions

Antes de implementar deben cumplirse todas:

1. TASK-008 revisada;
2. TASK-008 aprobada;
3. TASK-008 canonicalizada;
4. canonicalización revisada;
5. ejecución concreta autorizada separadamente;
6. repositorio Git válido;
7. branch/base autorizada;
8. upstream correcto;
9. divergencia conforme a autorización;
10. worktree limpio;
11. Fase 2 continúa `INICIADA`;
12. ADR-0001/0002/0003 continúan `ACCEPTED`;
13. DO-T03 continúa `RESUELTO/APROBADO`;
14. no existe Auth funcional inesperado;
15. no existe cliente Supabase incompatible preexistente;
16. no existe schema funcional inesperado;
17. no existe secreto real versionado cuya remediación exceda TASK-008;
18. el contrato de TASK-004 puede extenderse sin duplicarlo;
19. documentación oficial vigente sigue respaldando el patrón técnico especificado.

Incumplimiento material:

`BLOCKER`

---

# 9. Decisiones consumidas

TASK-008 consume:

## 9.1 Arquitectura

- monolito modular;
- infraestructura compartida sólo cuando es transversal;
- `app/` delgado;
- creación lazy de módulos;
- no microservicios.

## 9.2 Configuración

- público y privado separados;
- `NEXT_PUBLIC_*` es deliberadamente público;
- valores secretos nunca en Git/browser;
- variables env no conceden permisos;
- configuración común bajo infraestructura.

## 9.3 Seguridad

```text
browser = untrusted
server-side != authorized
```

Una identidad Supabase autenticada tampoco concede por sí sola tenant, rol o client scope.

---

# 10. Requisitos

## RQ-008-001 — Dependencias

Incorporar:

- `@supabase/supabase-js`;
- `@supabase/ssr`;

si la documentación oficial vigente continúa confirmándolas como patrón soportado.

Las versiones deberán:

- ser estables;
- no ser prerelease;
- registrarse explícitamente;
- quedar reproducibles en `package-lock.json`;
- reportarse en la ejecución.

No añadir wrappers adicionales.

## RQ-008-002 — Configuración pública

Añadir únicamente:

```text
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY
```

Ambas:

- son configuración pública;
- no son autorización;
- no determinan tenant;
- no determinan rol;
- deben poseer placeholders ficticios en `.env.example`;
- deben validarse antes de crear un cliente;
- no deben imprimir su valor en errores.

Prohibido introducir:

```text
SUPABASE_SERVICE_ROLE_KEY
SUPABASE_SECRET_KEY
```

o equivalentes privilegiados.

### RQ-008-002-A — Clasificación normativa completa de variables

La clasificación de **ambas** variables es obligatoria y forma parte del contrato de TASK-004 consumido por TASK-008.

| Dimensión | `NEXT_PUBLIC_SUPABASE_URL` | `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` |
|---|---|---|
| Exposición | `PÚBLICA` | `PÚBLICA` |
| Sensibilidad | `NO SECRETA` | `NO SECRETA` |
| Obligatoriedad | `REQUERIDA CUANDO SE INVOCA LA FRONTERA SUPABASE DE APLICACIÓN` | `REQUERIDA CUANDO SE INVOCA LA FRONTERA SUPABASE DE APLICACIÓN` |
| Ownership | `src/infrastructure/config/` | `src/infrastructure/config/` |

#### Obligatoriedad

La mera existencia del proyecto Supabase Development **NO** convierte estas variables en requisito universal para todo comando del repositorio.

Su obligatoriedad es:

```text
REQUERIDA CUANDO SE INVOCA LA FRONTERA SUPABASE DE APLICACIÓN
```

Por tanto:

- una factory que necesita construir un cliente debe fallar de forma explícita si falta la configuración;
- no debe introducirse una exigencia artificial para comandos o tests que no evalúan ningún código consumidor de esa frontera;
- TASK-008 no debe convertir todo el bootstrap del repositorio en dependiente de Supabase por simple import accidental.

#### Momento de disponibilidad

Ambas son variables:

```text
NEXT_PUBLIC_*
```

Cuando se consuman desde código cliente, Next.js puede incorporarlas al bundle durante build.

Por tanto:

- no constituyen configuración pública dinámica de runtime;
- no debe diseñarse su semántica como “runtime public config” mutable después del build;
- TASK-008 no crea endpoint, script, objeto global, bootstrap remoto ni otro mecanismo de runtime public config.

#### Ámbito

**Development**

- puede utilizar la configuración real del proyecto Supabase Cloud Development;
- esos valores sólo pueden ser provistos por el operador mediante mecanismo local/no versionado;
- TASK-008 no fija ni documenta valores reales.

**Tests**

- deben usar valores ficticios controlados;
- no deben realizar tráfico de red real.

**Staging**

`NO CONFIGURADO EN TASK-008`

**Production**

`NO CONFIGURADO EN TASK-008`

No inventar:

- proyectos;
- URLs;
- publishable keys;
- secrets;

para Staging o Production.

#### Ownership y superficie

Ownership normativo:

```text
src/infrastructure/config/
```

como configuración común pública conforme a TASK-004.

Debe cumplirse además:

- `.env.example` contiene únicamente placeholders inequívocamente ficticios;
- ningún valor real entra a Git;
- ningún mensaje de error imprime el valor recibido;
- no existe una segunda lista divergente de variables;
- no existe una segunda estrategia de `process.env`;
- la superficie de configuración pública no importa ni reexporta configuración privada;
- `NEXT_PUBLIC_*` expresa **exposición**, no autorización;
- la publishable key no determina tenant, rol, membership, client scope, support scope ni ownership;
- no se añade una dependencia nueva de validación para cumplir esta clasificación.

## RQ-008-003 — Browser factory

Debe existir una factory client-safe que:

- use exclusivamente configuración pública;
- no importe configuración privada;
- no haga queries al construirse;
- no haga login/signup/logout;
- no resuelva tenant/rol/scope;
- no contenga reglas de dominio.

## RQ-008-004 — Server factory

Debe existir una factory server-side **no privilegiada** compatible con el patrón oficial vigente de App Router.

Debe:

- utilizar URL + publishable key;
- permanecer server-side;
- no utilizar service-role/secret key;
- no hacer queries automáticamente;
- no crear usuarios;
- no implementar autorización.

Frontera normativa obligatoria:

```text
Server factory disponible ≠ Auth SSR funcional
```

y:

```text
Server factory disponible ≠ Auth SSR lifecycle completo
```

La server factory de TASK-008 es únicamente:

```text
infraestructura preparada y no utilizada funcionalmente
```

No puede declararse:

- `Auth ready`;
- `session lifecycle complete`;
- `route protection ready`;
- `authorization ready`.

La documentación oficial vigente de Supabase requiere infraestructura adicional para un lifecycle Auth SSR funcional, particularmente un Proxy para refresh de tokens y manejo coordinado de cookies cuando se implemente Auth SSR.

Esa infraestructura **NO pertenece a TASK-008**.

Queda expresamente fuera:

- refresh funcional de access token;
- Proxy de Auth;
- middleware de Auth;
- propagación completa de cookies de sesión;
- garantía de continuidad de sesión;
- route protection;
- guards;
- redirects por autenticación;
- login;
- logout;
- signup;
- OTP;
- onboarding;
- validación de usuario autenticado;
- autorización.

Si `createServerClient` necesita `cookies()` para construir la factory conforme al patrón oficial vigente, TASK-008 puede incluir **exclusivamente** el adapter/plumbing mínimo necesario para la construcción.

Ese plumbing:

- no invoca operaciones Auth;
- no implementa refresh;
- no garantiza continuidad de sesión;
- no convierte la factory en Auth SSR funcional;
- no autoriza Proxy/middleware funcional.

## RQ-008-005 — Sin acceso a producto

TASK-008 no debe añadir:

- queries `.from(...)` de producto;
- RPC;
- Storage;
- Realtime;
- Auth mutations;
- Admin Auth API.

## RQ-008-006 — Sin necesidad de red real

Las pruebas deben poder completarse con valores ficticios.

Codex no debe requerir:

- passwords;
- tokens;
- Supabase access token;
- service-role;
- secret key;
- credenciales administrativas.

---

# 11. Modelo de dominio afectado

**Entidades creadas:** `NINGUNA`

**Entidades modificadas:** `NINGUNA`

TASK-008 sólo prepara infraestructura para el futuro flujo:

```text
Supabase Auth subject
→ PlatformUser
→ autorización vigente
```

No materializa:

- `PlatformUser`;
- `VerificationChallenge`;
- `MaintenanceCompany`;
- `CompanyMembership`;
- `UserClientAccess`;
- `SupportAccessGrant`;
- `AuditEvent`.

---

# 12. Seguridad

## 12.1 Threat model mínimo

Amenazas de esta TASK:

1. exponer privilegio Supabase en browser;
2. confundir publishable key con secreto/autorización;
3. mezclar configuración pública y privada;
4. introducir cliente server privilegiado por comodidad;
5. acceder a tablas antes de RLS;
6. tratar server-side como autorización;
7. imprimir configuración sensible;
8. copiar schema/Auth/UI de quickstarts fuera de scope;
9. romper client/server boundaries;
10. interpretar una server factory existente como Auth SSR funcional o session lifecycle completo.

## 12.2 Fail-closed

Configuración faltante o inválida:

```text
factory invocation
→ explicit sanitized failure
```

Prohibido:

```text
missing config
→ fallback implícito
```

No usar valores hardcoded o proyectos demo.

## 12.3 Privilegios server-side

```text
service-role = PROHIBIDO EN TASK-008
```

No crear factory admin.

No crear variable privilegiada “para después”.

## 12.4 Bypass UI/API

Esta TASK no crea operación funcional alguna.

Por tanto no existe una UI/API autorizativa que pueda bypassarse.

Debe quedar explícitamente preservado que, cuando aparezcan casos de uso futuros:

```text
UI check ≠ security boundary
server action ≠ authorization
```

---

# 13. Multitenancy

TASK-008 no implementa tenancy funcional.

Debe preservar:

```text
tenant = MaintenanceCompany
```

La factory Supabase no debe recibir ni decidir:

- tenant;
- `maintenance_company_id`;
- rol;
- membership;
- client scope;
- support scope.

No crear:

- tenant context;
- tenant headers;
- tenant selector;
- tenant resolver.

**Cross-tenant rejection ejecutable en TASK-008:** no aplicable porque no existen datos ni operaciones tenant-owned.

La frontera para tareas posteriores es:

> ningún acceso a datos tenant-owned podrá introducirse sin ownership físico y controles RLS adecuados.

---

# 14. RLS

```text
RLS ejecutable en esta TASK = NO
```

Justificación:

- no hay tablas;
- no hay migrations;
- no hay datos tenant-owned;
- no hay queries;
- no hay Auth funcional.

Esto **no relaja** la regla:

```text
RLS obligatorio para datos tenant-owned
```

## 14.1 Negative cases de TASK-008

Verificar:

- no service-role;
- no secret key;
- browser no importa private config;
- server client no es privilegiado;
- no tabla de producto;
- no migration;
- no SQL;
- no policy;
- no tenant ID confiado desde frontend;
- no query remota funcional;
- server factory no se presenta como Auth SSR funcional;
- no existe refresh funcional de access token;
- no existe Proxy/middleware Auth funcional.

## 14.2 Negative cases reservados para tareas posteriores

No inventar entidades ficticias para probarlos todavía, pero mantener como requisitos futuros:

- cross-tenant read → DENIED;
- cross-tenant write → DENIED;
- revoked membership + stale JWT → DENIED;
- revoked client scope + stale JWT → DENIED;
- reduced role + stale Auth → DENIED;
- revoked support grant + residual Auth → DENIED;
- direct UI/API bypass → DENIED;
- `COMPANY_ADMIN` initial execution → DENIED.

---

# 15. Flujo / UI

```text
UI en esta TASK = NO
```

No crear:

- `/login`;
- `/signup`;
- `/auth/*`;
- OTP UI;
- onboarding;
- authenticated shell;
- redirects;
- guards;
- tenant selector.

Actor visible:

`NINGUNO`

Entrada de usuario:

`NINGUNA`

La página bootstrap debe permanecer funcionalmente equivalente.

---

# 16. Offline

```text
comportamiento offline aplicable = NO
```

No implementar:

- Dexie;
- IndexedDB;
- `OfflineAuthorizationState`;
- auth offline;
- local membership cache;
- logout/purge;
- outbox;
- Service Worker.

Preservar:

`DO-075 = RESUELTA/APROBADA`

y:

```text
ADR-0004 = BLOCKED BY OPEN DECISIONS
```

con:

```text
DO-T04
OFF-OPEN-001
OFF-OPEN-002
FORM-OPEN-004
```

---

# 17. Alcance

TASK-008 puede incluir exclusivamente:

1. preflight e inspección;
2. verificación oficial del patrón Supabase;
3. `@supabase/supabase-js`;
4. `@supabase/ssr`;
5. cambios reproducibles de manifest/lockfile;
6. dos variables públicas Supabase con clasificación normativa completa;
7. placeholders en `.env.example`;
8. browser factory;
9. server factory no privilegiada;
10. cookie adapter/plumbing mínimo exclusivamente si `createServerClient` lo requiere para construcción;
11. tests técnicos;
12. verificación de boundaries;
13. checks existentes;
14. revisión del diff;
15. reporte final.

No incluye un lifecycle SSR funcional de autenticación.

---

# 18. Fuera de alcance

Queda fuera:

- Auth funcional;
- Auth SSR lifecycle completo;
- refresh funcional de access token;
- Proxy de Auth;
- middleware de Auth;
- propagación completa de cookies de sesión;
- garantía de continuidad de sesión;
- login;
- logout;
- signup;
- OTP;
- `VerificationChallenge`;
- onboarding;
- validación de usuario autenticado;
- alta empresa;
- primer admin;
- usuarios posteriores;
- `PlatformUser`;
- `MaintenanceCompany`;
- `CompanyMembership`;
- roles;
- `UserClientAccess`;
- `SupportAccessGrant`;
- Audit;
- route protection;
- Auth guards;
- redirects Auth;
- claims;
- custom claims;
- hooks;
- TTL;
- `session_id`;
- session registry;
- provider termination;
- Admin Auth API;
- service-role;
- secret key;
- schema;
- tablas;
- columnas;
- PK/FK;
- índices;
- constraints;
- migrations;
- seeds;
- SQL;
- triggers;
- functions;
- helpers;
- `SECURITY DEFINER`;
- RPC;
- policies RLS;
- Storage;
- Realtime;
- queries de dominio;
- APIs de producto;
- Server Actions de producto;
- Route Handlers de producto;
- Edge Functions;
- UI;
- offline;
- resolución de ADR-0004;
- resolución de cualquier OPEN;
- Staging;
- Production;
- runtime public config;
- deployment.

---

# 19. Cambios esperados

Categorías de archivos permitidas:

1. `package.json`;
2. `package-lock.json`;
3. `.env.example`;
4. superficie existente de `src/infrastructure/config/`;
5. nueva frontera mínima bajo:
   `src/infrastructure/supabase/`;
6. tests de TASK-008.

La implementación debe extender TASK-004, no crear una segunda estrategia de env.

No crear carpetas vacías.

No crear módulos `auth`, `users`, `tenancy` o `permissions`.

No modificar `app/`.

Si cumplir TASK-008 exige modificar `app/`:

`BLOCKER`

No modificar `supabase/`.

---

# 20. Restricciones

1. TypeScript strict permanece.
2. No `any` para evitar tipos.
3. No non-null assertions para ocultar env ausente.
4. No hardcodear URL/key.
5. No añadir Zod u otra dependencia de validación por conveniencia.
6. No repositories ficticios.
7. No database types ficticios.
8. No `Database = any`.
9. No schema de ejemplo.
10. No tabla `instruments`.
11. No copiar Auth UI del quickstart.
12. No Proxy/middleware Auth funcional.
13. No presentar la server factory como `Auth ready`.
14. No presentar la server factory como session lifecycle completo.
15. No cambiar App Router.
16. No mover `app/`.
17. No segundo sistema de configuración.
18. No segunda lista divergente de env.
19. No runtime public config.
20. No loggear env values.
21. No privilegio Supabase.
22. No `supabase login`.
23. No `supabase link`.
24. No `supabase db push`.
25. No SQL remoto.
26. No commit.
27. No push.
28. No generar la siguiente TASK.

---

# 21. BLOCKERS

Resultado obligatorio:

`BLOCKER`

si:

1. TASK-008 no está aprobada/canónica/autorizada;
2. worktree no está limpio;
3. baseline Git autorizada no coincide;
4. falta fuente normativa;
5. Fase 2 deja de estar iniciada;
6. ADR-0001/0002/0003 no están ACCEPTED;
7. existe integración Supabase preexistente incompatible;
8. existe Auth funcional inesperado;
9. existe schema funcional inesperado;
10. existe secreto real versionado que requiera remediación fuera de scope;
11. documentación oficial ya no respalda el patrón elegido;
12. se necesita otra dependencia material;
13. se necesita credencial privada;
14. se necesita service-role;
15. se necesita acceso remoto autenticado;
16. se necesita schema/migration/RLS;
17. se necesita Auth funcional;
18. se necesita implementar lifecycle Auth SSR completo;
19. se necesita Proxy/middleware funcional de sesión;
20. se necesita refresh funcional de access token;
21. se necesita propagación completa de cookies de sesión;
22. se necesita decidir claims/TTL/session registry;
23. se necesita resolver un OPEN;
24. se necesita modificar ADR;
25. se necesita modificar DO-075;
26. se necesita modificar `app/`;
27. se necesita una nueva decisión arquitectónica;
28. tests requieren red real;
29. build requiere secreto;
30. existe segunda estrategia env incompatible;
31. existe segunda lista divergente de env;
32. browser factory necesita private config;
33. server factory necesita privilegio;
34. el diff excede el alcance.

No reparar por inferencia.

---

# 22. Criterios de aceptación

## Dependencias

- **AC-001** — sólo se añaden `@supabase/supabase-js` y `@supabase/ssr` como nuevas dependencias Supabase de aplicación.
- **AC-002** — versiones estables verificadas oficialmente durante la futura ejecución.
- **AC-003** — `package-lock.json` reproducible.
- **AC-004** — no se instala wrapper adicional.

## Configuración

- **AC-005** — `NEXT_PUBLIC_SUPABASE_URL` existe y está clasificada como `PÚBLICA`, `NO SECRETA`, `REQUERIDA CUANDO SE INVOCA LA FRONTERA SUPABASE DE APLICACIÓN`, con ownership `src/infrastructure/config/`.
- **AC-006** — `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` existe y está clasificada como `PÚBLICA`, `NO SECRETA`, `REQUERIDA CUANDO SE INVOCA LA FRONTERA SUPABASE DE APLICACIÓN`, con ownership `src/infrastructure/config/`.
- **AC-007** — `.env.example` contiene placeholders inequívocamente ficticios para ambas variables.
- **AC-008** — ningún valor real está versionado.
- **AC-009** — configuración faltante falla explícitamente sólo cuando se invoca la frontera que la requiere.
- **AC-010** — errores no imprimen valores.
- **AC-011** — no existe service-role.
- **AC-012** — no existe secret key.
- **AC-013** — no existe segunda estrategia ni lista divergente de env.
- **AC-014** — la superficie pública no importa ni reexporta configuración privada.
- **AC-015** — no existe runtime public config creado por TASK-008.
- **AC-016** — Development admite valores reales sólo por mecanismo no versionado; tests usan valores ficticios; Staging y Production quedan `NO CONFIGURADO EN TASK-008`.
- **AC-017** — `NEXT_PUBLIC_*` y publishable key no se interpretan como autorización ni como fuente de tenant/rol/membership/ownership.

## Factories

- **AC-018** — existe factory browser.
- **AC-019** — existe factory server.
- **AC-020** — browser usa sólo public config.
- **AC-021** — server no usa privilegio.
- **AC-022** — ninguna factory hace query automática.
- **AC-023** — ninguna factory implementa login/signup/logout.
- **AC-024** — no existe Admin Auth client.
- **AC-025** — no existe factory service-role.
- **AC-026** — no existe lógica tenant/rol/scope.
- **AC-027** — ubicación arquitectónica respeta TASK-003.
- **AC-028** — server factory disponible no se presenta como Auth SSR funcional.
- **AC-029** — `Auth SSR lifecycle completo = NO`.
- **AC-030** — no existe refresh funcional de access token.
- **AC-031** — no existe Proxy/middleware Auth funcional.
- **AC-032** — no existe garantía de continuidad de sesión.
- **AC-033** — si `createServerClient` requiere `cookies()`, sólo existe plumbing mínimo de construcción y no operaciones Auth.

## Datos / seguridad / RLS

- **AC-034** — no tablas.
- **AC-035** — no migrations.
- **AC-036** — no SQL.
- **AC-037** — no policies RLS.
- **AC-038** — no queries de producto.
- **AC-039** — no Storage.
- **AC-040** — no Realtime.
- **AC-041** — no privilegio remoto.
- **AC-042** — browser sigue siendo no confiable.
- **AC-043** — server-side no se confunde con autorización.
- **AC-044** — fail-closed de config.
- **AC-045** — futura RLS continúa obligatoria.
- **AC-046** — no tenant ID de frontend como autoridad.

## Auth / UI / offline

- **AC-047** — Auth funcional = NO.
- **AC-048** — Auth SSR lifecycle completo = NO.
- **AC-049** — no rutas Auth.
- **AC-050** — UI = NO.
- **AC-051** — bootstrap visual preservado.
- **AC-052** — no guards ni route protection.
- **AC-053** — offline = NO.
- **AC-054** — DO-075 intacta.
- **AC-055** — ADR-0004 y blockers intactos.

## Calidad / scope

- **AC-056** — lint PASS.
- **AC-057** — typecheck PASS.
- **AC-058** — tests PASS.
- **AC-059** — build PASS.
- **AC-060** — verify PASS.
- **AC-061** — `git diff --check` PASS.
- **AC-062** — tests TASK-008 sin red.
- **AC-063** — diff completo revisado.
- **AC-064** — `/docs` intacto durante implementación.
- **AC-065** — `supabase/` intacto.
- **AC-066** — workflow CI intacto.
- **AC-067** — ningún archivo fuera de categorías autorizadas.
- **AC-068** — ningún secreto.
- **AC-069** — no commit.
- **AC-070** — no push.

---

# 23. Pruebas

## 23.1 Configuración pública y clasificación

Probar/verificar:

- `NEXT_PUBLIC_SUPABASE_URL` ausente al invocar la frontera → error explícito;
- `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` ausente al invocar la frontera → error explícito;
- valores ficticios válidos → accepted;
- URL inválida → error si puede validarse sin dependencia nueva;
- error no contiene valor recibido;
- código que no invoca la frontera no debe fallar artificialmente sólo por ausencia de estas variables;
- `.env.example` contiene sólo placeholders ficticios;
- no existe segunda lista divergente de env;
- public config no importa/reexporta private config;
- no existe runtime public config;
- tests usan valores ficticios;
- no hay Staging/Production inventados.

## 23.2 Browser factory

Probar:

- se construye con config pública ficticia;
- no necesita private config;
- no hace request al construirse;
- no expone privilegio.

## 23.3 Server factory

Probar:

- se construye en contexto server apropiado/mocked;
- usa URL + publishable key;
- no requiere service-role;
- no hace request al construirse;
- no invoca login/logout/signup;
- no refresca access token;
- no implementa route protection;
- no implementa autorización;
- no garantiza continuidad de sesión.

Si `createServerClient` exige `cookies()` conforme al patrón oficial vigente:

- probar únicamente el adapter/plumbing mínimo para construcción;
- no probar ni afirmar lifecycle completo;
- no introducir Proxy/middleware para hacer pasar la prueba;
- no invocar operaciones Auth.

## 23.4 Boundary tests / inspección

Verificar:

- client-safe no importa private config;
- browser no importa server-only;
- no existe acceso Supabase desde dominio;
- no existe factory privilegiada;
- server factory no está expuesta como `Auth ready`, `authorization ready` o session lifecycle complete.

## 23.5 Inspección negativa

Buscar ausencia de:

```text
service_role
SUPABASE_SECRET_KEY
admin.createUser
signIn
signUp
refreshSession
proxy
middleware
.from(
storage.
channel(
```

Las coincidencias en archivos preexistentes/no modificados o dependencias deben distinguirse del código introducido por TASK-008 y documentarse cuando corresponda.

---

# 24. Verificaciones

## 24.1 Preflight Git

Registrar:

- repo válido;
- branch;
- HEAD;
- upstream;
- origin/main;
- divergencia;
- worktree;
- Node;
- npm.

## 24.2 Inspección

Revisar antes de modificar:

- packages;
- lockfile;
- env;
- config;
- infrastructure;
- `app/`;
- `supabase/`;
- tests;
- referencias Supabase.

## 24.3 Fuente oficial

Antes de instalar:

- confirmar patrón Next.js vigente;
- confirmar paquetes;
- confirmar versiones estables;
- confirmar tratamiento vigente de browser/server clients;
- confirmar requisitos adicionales del lifecycle Auth SSR y que quedan fuera de TASK-008;
- no usar prerelease;
- registrar evidencia.

## 24.4 Checks

Ejecutar:

```text
npm ci
npm run lint
npm run typecheck
npm run test
npm run build
npm run verify
git diff --check
```

## 24.5 Diff

Ejecutar:

```text
git diff --name-only
git diff --stat
git diff --numstat
```

y revisar íntegramente todos los diffs.

---

# 25. Instrucciones futuras para Codex

Cuando exista autorización concreta, Codex deberá:

1. leer TASK-008 completa;
2. leer fuentes obligatorias;
3. realizar preflight;
4. inspeccionar repo primero;
5. detenerse ante drift incompatible;
6. verificar documentación oficial Supabase vigente;
7. verificar explícitamente el límite entre server factory y lifecycle Auth SSR completo;
8. no copiar ejemplos fuera de scope;
9. instalar sólo dos dependencias autorizadas;
10. extender el contrato real de TASK-004;
11. clasificar ambas variables según RQ-008-002-A;
12. no duplicar config;
13. no crear runtime public config;
14. crear frontera Supabase mínima;
15. separar browser/server;
16. limitar cualquier cookie plumbing a construcción de `createServerClient`;
17. no introducir refresh funcional;
18. no introducir Proxy/middleware Auth funcional;
19. no declarar `Auth ready`;
20. no declarar session lifecycle complete;
21. no introducir secretos;
22. no introducir privilegio;
23. no ejecutar login/link/db push;
24. no usar acceso remoto autenticado;
25. no crear schema/migrations/RLS;
26. no implementar Auth;
27. no crear UI;
28. no crear queries;
29. añadir tests sin red;
30. ejecutar checks;
31. revisar diff;
32. informar dependencias y archivos;
33. devolver `PASS`, `FAIL` o `BLOCKER`;
34. no commit;
35. no push;
36. no preparar la siguiente TASK.

---

# 26. Definition of Done

TASK-008 sólo podrá cerrarse después de:

1. revisión;
2. aprobación;
3. canonicalización;
4. revisión humana de canonicalización;
5. autorización concreta;
6. implementación;
7. reporte de Codex;
8. revisión humana del diff;
9. revisión arquitectónica;
10. revisión de seguridad;
11. revisión de secretos/config;
12. revisión explícita de clasificación de env;
13. revisión explícita de la frontera server factory vs Auth SSR;
14. regresiones;
15. incorporación Git autorizada;
16. commit/push;
17. branch sincronizada;
18. worktree limpio;
19. cierre humano final.

Resultado técnico requerido:

```text
Supabase application boundary = IMPLEMENTADA

Browser factory = IMPLEMENTADA

Server factory no privilegiada = IMPLEMENTADA

Server factory disponible = SÍ

Auth funcional = NO IMPLEMENTADA

Auth SSR lifecycle completo = NO

Refresh funcional de access token = NO

Proxy/middleware Auth funcional = NO

Route protection = NO

Authorization ready = NO

Schema funcional = NO

Migrations funcionales = NO

RLS ejecutable = NO

Storage funcional = NO

TASK siguiente autorizada automáticamente = NO
```

---

# 27. Gate posterior

Un `PASS` de TASK-008 **no autoriza automáticamente** la siguiente tarea.

La revisión posterior debe confirmar:

- sólo se introdujo la frontera Supabase;
- dependencias justificadas;
- ambas variables públicas están clasificadas completamente conforme a TASK-004;
- `.env.example` sólo posee placeholders ficticios;
- ningún valor real entra a Git;
- ningún secreto;
- ningún service-role/secret key;
- no existe segunda estrategia/lista de env;
- no existe runtime public config;
- browser/server boundaries correctas;
- server factory es infraestructura preparada y no utilizada funcionalmente;
- server factory no se presenta como Auth SSR funcional;
- `Auth SSR lifecycle completo = NO`;
- no existe refresh funcional de access token;
- no existe Proxy/middleware Auth funcional;
- no existe garantía de continuidad de sesión;
- no existe route protection;
- Auth funcional ausente;
- schema ausente;
- migrations ausentes;
- RLS ejecutable ausente;
- Storage ausente;
- UI ausente;
- offline ausente;
- ADR-0001/0002/0003 preservados;
- ADR-0004 y blockers preservados;
- DO-075 preservada;
- checks pasando;
- diff revisado;
- incorporación y cierre formal completados.

Sólo entonces podrá determinarse, mediante otro acto separado, el siguiente incremento PR-sized de Fase 2.

Quedan explícitamente para tareas posteriores:

- lifecycle Auth SSR completo;
- Proxy/refresh de sesión cuando una futura tarea implemente Auth SSR;
- login/logout/signup/OTP;
- vínculo físico Auth subject → `PlatformUser`;
- modelo físico mínimo de `MaintenanceCompany` / `PlatformUser` / `CompanyMembership`;
- migrations de identidad/tenant;
- RLS de esas tablas;
- `VerificationChallenge`;
- onboarding;
- `UserClientAccess`;
- `SupportAccessGrant`;
- revocación autoritativa y negative tests;
- provider-side termination cuando corresponda;
- Storage authorization;
- offline authorization.

No se asignan IDs a esas tareas desde TASK-008.

---

# Estado final de esta especificación

```text
TASK-008 = APPROVED FOR IMPLEMENTATION

Implementación autorizada = NO

Codex autorizado = NO

Repositorio modificado = NO

RLS ejecutable en esta TASK = NO

UI en esta TASK = NO

Comportamiento offline aplicable = NO

Auth funcional = NO

Auth SSR lifecycle completo = NO
```
