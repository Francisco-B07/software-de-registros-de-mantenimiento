# TASK-009 — Fundación física mínima de identidad y tenant

## 1. ID

`TASK-009`

---

## 2. Título

`Fundación física mínima de identidad y tenant`

---

## 3. Tipo

`IMPLEMENTATION TASK`

Segundo incremento PR-sized de:

`Fase 2 — Multitenancy, autenticación, roles y RLS`

Esta tarea materializa exclusivamente la fundación física mínima necesaria para representar:

- `MaintenanceCompany`;
- `PlatformUser`;
- `CompanyMembership`;
- la resolución física mínima de un Supabase Auth subject hacia `PlatformUser`;
- las invariantes mínimas de tenant y membership;
- RLS mínima para las tablas introducidas;
- pruebas de aislamiento, revocación autoritativa e integridad correspondientes exclusivamente a este slice.

TASK-009 no implementa todavía flujos funcionales de autenticación, onboarding ni administración de usuarios.

---

## 4. Estado

`TASK-009 = APPROVED FOR IMPLEMENTATION`

**Archivo de entrega propuesto:**

`TASK-009-identity-tenant-foundation-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/TASK-009-identity-tenant-foundation.md`

**Implementación autorizada:** `NO`

**Codex autorizado:** `NO`

**Ejecución concreta autorizada:** `NO`

**Repositorio modificado durante esta especificación:** `NO`

**Supabase Cloud modificado durante esta especificación:** `NO`

**Fase 2:** `INICIADA`

**Schema funcional introducido por una futura implementación:** `SÍ, exclusivamente el definido por esta TASK`

**Migration funcional autorizada por una futura implementación:** `SÍ, exclusivamente la definida por esta TASK`

**RLS ejecutable autorizada por una futura implementación:** `SÍ, exclusivamente la definida por esta TASK`

**Auth funcional:** `NO`

**UI:** `NO`

**Offline:** `NO`

Esta especificación ha sido aprobada formalmente como contrato técnico para un ciclo futuro de implementación.

El estado `APPROVED FOR IMPLEMENTATION` no autoriza por sí mismo:

- Codex;
- modificación del repositorio;
- creación real de migrations;
- ejecución SQL;
- `db push`;
- cambios en Supabase Cloud;
- creación de usuarios reales;
- generación de TASK-010.

---

# 5. Objetivo

Introducir la **fundación física mínima de identidad y tenant** sobre la frontera Supabase ya implementada por TASK-008, sin adelantar los flujos funcionales posteriores de Fase 2.

El resultado debe permitir representar físicamente y verificar:

```text
Supabase Auth subject
→ PlatformUser
→ CompanyMembership vigente
→ MaintenanceCompany
→ role vigente
```

manteniendo como invariantes:

```text
tenant = MaintenanceCompany

authenticated ≠ authorized

RLS = frontera primaria

estado autoritativo vigente > estado stale
```

TASK-009 debe dejar preparado un esquema mínimo capaz de demostrar que:

1. cada Auth subject reconocido resuelve inequívocamente a un `PlatformUser`;
2. esa resolución no fija por inferencia la cardinalidad inversa `PlatformUser → Auth subject(s)`;
3. un `PlatformUser` puede poseer como máximo una `CompanyMembership` en el MVP;
4. una membership tenant pertenece exactamente a una `MaintenanceCompany`;
5. sólo existen roles tenant `COMPANY_ADMIN` y `TECHNICIAN`;
6. `SUPER_ADMIN` no se representa como role de `CompanyMembership`;
7. una membership no habilitada no concede acceso tenant;
8. conocer o enviar un `maintenance_company_id` no concede acceso;
9. un JWT o sesión técnicamente vigente no conserva acceso tenant después de revocar la membership;
10. las tablas creadas fallan cerradas ante ausencia de autorización vigente.

El objetivo no es completar Identity & Access.

---

# 6. Contexto

## 6.1 Estado cerrado consumido

Se consume como baseline autoritativa recibida:

```text
Fase 0 = COMPLETADA
Fase 1 = COMPLETADA
Fase 2 = INICIADA

TASK-008 = COMPLETADA
CORR-010 = COMPLETADA
```

Resultado técnico cerrado de TASK-008:

```text
Supabase application boundary = IMPLEMENTADA
Browser factory = IMPLEMENTADA
Server factory no privilegiada = IMPLEMENTADA

Auth funcional = NO
Authorization ready = NO

Schema = NO
Migrations = NO
SQL = NO
RLS ejecutable = NO
Storage = NO
Offline = NO
```

TASK-008 dejó expresamente para tareas posteriores el vínculo físico Auth subject → `PlatformUser`, el modelo físico mínimo de `MaintenanceCompany` / `PlatformUser` / `CompanyMembership`, sus migrations y su RLS.

CORR-010 cerró documentalmente TASK-008 y mantuvo expresamente:

```text
Auth funcional = NO
Authorization ready = NO
Schema = NO
Migrations = NO
SQL = NO
RLS ejecutable = NO
Storage = NO
Offline = NO
```

antes de devolver al Revisor Central la determinación del siguiente incremento.

## 6.2 Snapshot Git recibido

Se consume exclusivamente como snapshot de preparación:

```text
branch = main
HEAD = 5c8f64d4f02ff81360be16b9fba57b1a4dfa74a0
origin/main = 5c8f64d4f02ff81360be16b9fba57b1a4dfa74a0
divergencia = 0 0
worktree = limpio
staged = ninguno
untracked = ninguno
```

Este SHA:

- no se revalida durante esta redacción;
- no constituye SHA obligatorio de una futura ejecución;
- no debe reutilizarse ciegamente después de aprobación/canonicalización;
- deberá sustituirse por el estado Git real obtenido durante el preflight de una futura ejecución autorizada.

---

# 7. Fuentes obligatorias

La futura implementación debe leer íntegramente y respetar como mínimo:

## 7.1 Producto

- `docs/product/01-product-definition.md` — baseline normativa del producto.
- `docs/product/02-domain-model.md` — modelo conceptual de `PlatformUser`, `MaintenanceCompany` y `CompanyMembership`.
- `docs/product/03-permissions-rls-strategy.md` — autorización vigente, zero trust y estrategia RLS.
- `docs/product/10-architecture-decisions-records.md` — clasificación de decisiones arquitectónicas.
- `docs/product/11-phase-1-scope-entry-gate.md`.

## 7.2 Arquitectura

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`.
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`.
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`.

## 7.3 Tareas y correcciones

- `docs/tasks/TASK-008-supabase-application-boundary.md`.
- `docs/tasks/CORR-010-task-008-closure-state-sync.md`.

## 7.4 Orden de autoridad

Debe preservarse el orden normativo ya aprobado:

1. decisiones posteriores explícitamente aprobadas dentro del alcance exacto que modifican;
2. `01-product-definition.md`;
3. documentos derivados dentro de su ámbito;
4. ADR aceptados dentro de la decisión arquitectónica que documentan;
5. TASK/CORR posteriores como contrato de ejecución y estado, sin utilizarlas para inventar requisitos de producto.

---

# 8. Precondiciones de una futura implementación

Antes de modificar archivos deberán satisfacerse todas:

1. TASK-009 revisada humanamente;
2. TASK-009 aprobada formalmente;
3. TASK-009 canonicalizada;
4. canonicalización revisada;
5. ejecución concreta autorizada de forma humana y separada;
6. Fase 2 continúa `INICIADA`;
7. TASK-008 continúa `COMPLETADA`;
8. ADR-0001 continúa `ACCEPTED`;
9. ADR-0002 continúa `ACCEPTED`;
10. ADR-0003 continúa `ACCEPTED`;
11. DO-T03 continúa `RESUELTO/APROBADO`;
12. `ADR-0004` continúa sin necesidad de resolverse para este slice;
13. repositorio correcto;
14. branch/base expresamente autorizada;
15. upstream correcto;
16. divergencia compatible con la autorización;
17. worktree limpio;
18. staged vacío;
19. untracked vacío salvo excepción humana explícita;
20. no existe migration funcional inesperada que colisione con TASK-009;
21. no existe schema de identidad/tenant adelantado incompatible;
22. no existe Auth funcional adelantado;
23. no existe `UserClientAccess`;
24. no existe `SupportAccessGrant`;
25. no existe uso normal de `service-role`;
26. la frontera Supabase de TASK-008 permanece coherente;
27. el workflow Supabase Cloud de Development definido por CORR-002 continúa vigente;
28. la documentación oficial vigente de Supabase debe verificarse antes de materializar el vínculo Auth subject → `PlatformUser`;
29. si esa documentación continúa soportando públicamente `auth.users(id)` como PK estable administrada por Supabase y referenciable desde el schema de aplicación, la FK `platform_user_auth_subjects.auth_subject_id → auth.users(id)` es obligatoria;
30. si la documentación oficial vigente deja de soportar esa referencia o revela una incompatibilidad material:

```text
BLOCKER — REVISIÓN HUMANA
```

31. no está permitido continuar con un UUID huérfano como fallback silencioso;
32. no está permitido inventar otro mecanismo de linking por inferencia;
33. el comportamiento `ON DELETE` exacto de esa FK debe verificarse contra la documentación oficial vigente antes de fijarse.

Cualquier incumplimiento material:

`BLOCKER`

No reparar por inferencia.

---

# 9. Modelo de dominio afectado

## 9.1 `MaintenanceCompany`

Representa:

```text
tenant = MaintenanceCompany
```

La baseline define `MaintenanceCompany` como identidad conceptual de una empresa de mantenimiento y frontera primaria de tenancy.

TASK-009 sólo materializa su identidad física mínima.

No materializa todavía:

- onboarding;
- datos comerciales;
- suscripción;
- créditos;
- configuración tenant-wide;
- clientes;
- estado comercial;
- soporte.

## 9.2 `PlatformUser`

Representa la identidad global reconocida por la plataforma, separada del proveedor Auth.

TASK-009 preserva:

```text
Supabase Auth subject ≠ PlatformUser
```

y:

```text
authenticated ≠ authorized
```

`PlatformUser` permanece global y no es tenant-owned.

## 9.3 `CompanyMembership`

Representa:

```text
PlatformUser
→ MaintenanceCompany
→ role
→ enabled/disabled
```

Es tenant-owned.

La baseline fija:

```text
PlatformUser → 0..1 CompanyMembership
```

y limita el role de una membership a:

- `COMPANY_ADMIN`;
- `TECHNICIAN`.

`SUPER_ADMIN` no posee `CompanyMembership`.

## 9.4 Auth subject

No se introduce como nueva entidad de dominio.

Es un identificador estable suministrado por Supabase Auth que actúa exclusivamente como anchor de autenticación.

ADR-0003 fija:

```text
cada Auth subject reconocido
→ exactamente un PlatformUser
```

y deja expresamente diferidos:

- `PlatformUser → Auth subject(s)`;
- account linking;
- múltiples Auth identities para un mismo `PlatformUser`;
- múltiples providers.

TASK-009 no interpreta esa decisión diferida en ninguna dirección.

---

# 10. Análisis arquitectónico — ADR requerido o no requerido

## 10.1 Pregunta

Debe determinarse si concretar:

- tablas;
- relaciones;
- PK/FK;
- vínculo Auth subject → `PlatformUser`;
- estrategia RLS mínima;

es:

**A. detalle de implementación permitido por ADR-0002/ADR-0003**

o:

**B. nueva decisión arquitectónica que necesita ADR.**

## 10.2 Resultado

`CLASIFICACIÓN = A`

`ADR NUEVO = NO REQUERIDO`

## 10.3 Justificación

ADR-0002 ya decide arquitectónicamente:

- una única infraestructura PostgreSQL compartida;
- `MaintenanceCompany` como tenant;
- ownership inequívoco;
- tenant derivation autoritativa;
- integridad cross-tenant;
- RLS como frontera primaria;
- uso restringido de `service-role`.

El mismo ADR deja expresamente para diseño físico posterior:

- qué tablas poseen tenant directo;
- foreign keys;
- constraints;
- índices;
- mecanismo físico utilizado para garantizar las invariantes.

ADR-0003 ya decide arquitectónicamente:

```text
Auth subject
→ exactamente un PlatformUser
→ autorización vigente
```

junto con:

- membership vigente;
- rol vigente;
- fail-closed;
- current authoritative state;
- rechazo de claims stale como autoridad;
- RLS como frontera primaria;
- separación de `SUPER_ADMIN`;
- ausencia de bypass normal.

El mismo ADR difiere expresamente:

- tablas;
- columnas;
- PK/FK;
- constraints;
- RLS física;
- helper functions;
- mecanismo físico de linking Auth;
- cardinalidad inversa de Auth.

El registro maestro además consolida las decisiones de identity/membership/client access dentro de ADR-0003 y las de integridad/RLS tenant dentro de ADR-0002, por lo que crear un ADR adicional para elegir cuatro tablas y sus constraints mínimos duplicaría decisiones ya clasificadas.

## 10.4 Condición que debe preservarse

Esta clasificación permanece válida únicamente mientras TASK-009 no cierre por inferencia una decisión expresamente diferida.

Por tanto TASK-009 **NO puede**:

- convertir `PlatformUser` y `auth.users` en la misma entidad;
- utilizar `platform_users.id = auth.users.id` como contrato de identidad;
- exigir `PlatformUser → exactamente un Auth subject`;
- exigir `PlatformUser → máximo un Auth subject`;
- definir `PlatformUser → 0..* Auth subjects` como contrato de producto;
- presentar la ausencia de `UNIQUE(platform_user_id)` como soporte aprobado de múltiples Auth identities;
- presentar la ausencia de `UNIQUE(platform_user_id)` como implementación de account linking;
- crear múltiples mappings para un mismo `PlatformUser` con el objetivo de demostrar una funcionalidad;
- implementar account linking funcional;
- decidir múltiples proveedores Auth;
- definir custom claims como fuente autoritativa;
- introducir un session registry;
- seleccionar el mecanismo provider-side de terminación;
- resolver ADR-0004.

La ausencia de:

```text
UNIQUE(platform_user_id)
```

en `platform_user_auth_subjects` tiene un significado estrictamente negativo y conservador:

```text
ausencia de UNIQUE(platform_user_id)
≠ soporte aprobado de múltiples Auth identities
≠ account linking
≠ PlatformUser → 0..* Auth subjects como contrato de producto
```

Se omite exclusivamente para no imponer otra decisión tampoco aprobada:

```text
PlatformUser → máximo un Auth subject
```

La cardinalidad inversa continúa:

`DIFERIDA`

Si cualquiera de esas decisiones se vuelve necesaria para implementar el slice:

`BLOCKER — REQUIERE REVISIÓN ARQUITECTÓNICA`

No crear ADR por inferencia durante la ejecución.

---

# 11. Decisiones físicas estrictamente necesarias

## 11.1 Schema PostgreSQL

TASK-009 utilizará el schema de aplicación estándar existente.

Si el repositorio no establece otro schema funcional aprobado:

```text
schema = public
```

No debe crearse una taxonomía adicional de schemas en esta tarea.

## 11.2 Tabla `maintenance_companies`

Materializa únicamente la identidad tenant.

Nombre físico:

`public.maintenance_companies`

Mínimo obligatorio:

| Campo | Semántica |
|---|---|
| `id` | PK UUID de `MaintenanceCompany` |

TASK-009 no introduce todavía columnas funcionales no necesarias para el aislamiento mínimo.

En particular no define mediante esta tabla:

- nombre legal obligatorio;
- dirección;
- teléfono;
- branding;
- plan;
- subscription status;
- período promocional;
- créditos;
- configuración;
- billing;
- onboarding status.

El ciclo comercial/suspensión no se modela aquí.

## 11.3 Tabla `platform_users`

Nombre físico:

`public.platform_users`

Mínimo obligatorio:

| Campo | Semántica |
|---|---|
| `id` | PK UUID de `PlatformUser` |

No almacenar como autoridad:

- email;
- tenant;
- role tenant;
- client scope;
- JWT;
- session token.

No introducir en TASK-009 un role `SUPER_ADMIN` físico dentro de `CompanyMembership`.

La clasificación funcional completa del actor global queda fuera de este slice.

## 11.4 Tabla `platform_user_auth_subjects`

Nombre físico:

`public.platform_user_auth_subjects`

Responsabilidad única:

```text
Supabase Auth subject
→ PlatformUser
```

Mínimo obligatorio:

| Campo | Semántica |
|---|---|
| `auth_subject_id` | identificador UUID estable del Auth subject |
| `platform_user_id` | FK a `platform_users.id` |

Constraints obligatorias:

1. `auth_subject_id` identifica de forma única el mapping Auth → `PlatformUser`;
2. antes de crear la migration debe verificarse la documentación oficial vigente de Supabase respecto de `auth.users(id)`;
3. si `auth.users(id)` continúa siendo una PK estable administrada por Supabase que puede ser referenciada públicamente desde el schema de aplicación, debe existir obligatoriamente:

```text
FK platform_user_auth_subjects.auth_subject_id
→ auth.users(id)
```

4. si esa referencia deja de estar soportada o existe una incompatibilidad material:

```text
BLOCKER — REVISIÓN HUMANA
```

5. no se permite sustituir esa FK por un UUID huérfano como fallback silencioso;
6. no se permite inventar otro mecanismo de linking durante TASK-009;
7. `platform_user_id` debe referenciar un `PlatformUser` existente;
8. **NO** debe existir una uniqueness constraint sobre `platform_user_id`.

La última regla no define una cardinalidad positiva por el lado de `PlatformUser`.

Debe interpretarse exclusivamente así:

```text
cada Auth subject reconocido
→ exactamente un PlatformUser
```

está cerrado.

En cambio:

```text
PlatformUser → Auth subject(s)
```

continúa diferido.

Por tanto:

```text
ausencia de UNIQUE(platform_user_id)
≠ soporte de múltiples Auth identities
≠ account linking
≠ múltiples providers
≠ PlatformUser → 0..* Auth subjects como contrato aprobado
```

La ausencia de esa constraint evita únicamente imponer:

```text
PlatformUser → máximo un Auth subject
```

que tampoco está aprobado.

TASK-009 no debe:

- crear múltiples mappings para un mismo `PlatformUser` como feature;
- probar account linking;
- interpretar múltiples mappings como comportamiento soportado;
- introducir provider metadata;
- introducir lógica multi-provider.

No introducir:

- provider;
- email;
- password;
- refresh token;
- access token;
- provider metadata;
- custom claims.

### 11.4.1 `ON DELETE` desde `auth.users`

El comportamiento `ON DELETE` exacto de:

```text
platform_user_auth_subjects.auth_subject_id
→ auth.users(id)
```

debe verificarse contra la documentación oficial vigente de Supabase antes de materializarse.

Cualquier comportamiento aprobado debe preservar simultáneamente:

1. una eliminación del Auth subject puede afectar como máximo al registro de mapping correspondiente;
2. nunca puede eliminar en cascada `PlatformUser`;
3. nunca puede eliminar en cascada `CompanyMembership`;
4. nunca puede eliminar en cascada `MaintenanceCompany`.

Si no puede demostrarse un comportamiento soportado que preserve estas invariantes:

`BLOCKER — REVISIÓN HUMANA`

TASK-009 no implementa triggers para resolver esta relación.

## 11.5 Tabla `company_memberships`

Nombre físico:

`public.company_memberships`

Mínimo obligatorio:

| Campo | Semántica |
|---|---|
| `id` | PK UUID de la membership |
| `platform_user_id` | FK al usuario global |
| `maintenance_company_id` | FK al tenant |
| `role` | role tenant vigente |
| `is_enabled` | estado autorizativo vigente de la membership |

Constraints mínimas:

1. `platform_user_id` no nulo;
2. `maintenance_company_id` no nulo;
3. `role` no nulo;
4. `is_enabled` no nulo;
5. FK `platform_user_id → platform_users.id`;
6. FK `maintenance_company_id → maintenance_companies.id`;
7. uniqueness de `platform_user_id`;
8. role restringido exclusivamente a:

```text
COMPANY_ADMIN
TECHNICIAN
```

La uniqueness de `platform_user_id` materializa la cardinalidad aprobada:

```text
PlatformUser → 0..1 CompanyMembership
```

e impide que un mismo usuario tenant sea miembro simultáneamente de dos `MaintenanceCompany`.

`SUPER_ADMIN` no es valor válido de `company_memberships.role`.

## 11.6 Estado de membership

TASK-009 necesita distinguir únicamente:

```text
enabled
vs
not enabled
```

para resolver autorización actual.

Se adopta por ello el mínimo:

`is_enabled`

No se introduce una state machine adicional.

La reintegración futura puede modificar el estado vigente conforme al caso de uso autorizado posterior.

La representación física mínima de `is_enabled` en TASK-009:

```text
NO satisface
NO sustituye
NO elimina
```

la obligación ya aprobada de `AuditEvent`.

La baseline canónica mantiene como eventos obligatorios de auditoría, como mínimo:

- alta de usuario;
- deshabilitación/revocación;
- reintegración;
- cambio de rol;
- cambio de clientes/permisos.

TASK-009 mantiene:

```text
AuditEvent = FUERA DE ALCANCE
```

porque no implementa los flows funcionales que originan esas operaciones.

Por tanto, ningún flujo funcional futuro que:

- cree un usuario o membership;
- deshabilite o revoque una membership;
- reintegre una membership;
- cambie el role;
- cambie client scope;

puede considerarse completo sin implementar la auditoría obligatoria correspondiente conforme a la baseline.

Las mutaciones privilegiadas de `is_enabled` o `role` realizadas exclusivamente como preparación de fixtures/pruebas en Development:

- son `test setup`;
- no son operaciones funcionales del producto;
- no constituyen implementación del flow de disable/reinstate/change-role;
- no satisfacen `AuditEvent`;
- no eliminan ni reducen la obligación futura de auditoría.

TASK-009 no introduce `AuditEvent` entre sus cuatro tablas y no amplía su scope para implementar auditoría.

## 11.7 Eliminación

Una futura migration de TASK-009 no debe configurar cascadas que permitan que eliminar un vínculo Auth destruya automáticamente:

- `PlatformUser`;
- `CompanyMembership`;
- `MaintenanceCompany`.

En particular, cualquier `ON DELETE` soportado desde:

```text
auth.users(id)
→ platform_user_auth_subjects.auth_subject_id
```

puede afectar como máximo al registro de mapping Auth correspondiente.

Nunca puede producir una cadena equivalente a:

```text
auth.users
→ PlatformUser
→ CompanyMembership
→ MaintenanceCompany
```

mediante cascada destructiva.

La baseline exige preservar identidad e historial ante deshabilitación/revocación.

TASK-009 no implementa hard-delete de estas entidades.

---

# 12. Ownership y tenant derivation

## 12.1 Recursos globales

En este slice son globales:

- `PlatformUser`;
- vínculo Auth subject → `PlatformUser`;
- registro físico de `MaintenanceCompany`.

No debe inferirse que ser global significa ser públicamente legible.

## 12.2 Recurso tenant-owned

`CompanyMembership` es tenant-owned.

Su tenant deriva directamente de:

```text
CompanyMembership.maintenance_company_id
→ MaintenanceCompany.id
```

## 12.3 Regla autoritativa

Para usuarios tenant:

```text
Auth subject
→ PlatformUser
→ enabled CompanyMembership
→ MaintenanceCompany
```

El tenant efectivo no se toma de:

- request;
- query string;
- form;
- header arbitrario;
- localStorage;
- cookie de tenant seleccionada;
- JWT custom claim;
- parámetro `maintenance_company_id`.

## 12.4 Integridad cross-tenant mínima

Con el slice actual deben ser físicamente imposibles o denegadas:

1. una membership hacia una empresa inexistente;
2. una membership hacia un usuario inexistente;
3. dos memberships simultáneas para el mismo `PlatformUser`;
4. un role `SUPER_ADMIN` dentro de una membership;
5. un role tenant distinto de los dos roles aprobados;
6. un Auth subject enlazado simultáneamente a dos `PlatformUser`;
7. un mapping hacia un Auth subject inexistente cuando la FK obligatoria soportada a `auth.users(id)` sea aplicable;
8. acceso del subject de Tenant A a la membership o empresa de Tenant B;
9. una cascada desde la eliminación de un Auth subject que destruya `PlatformUser`, `CompanyMembership` o `MaintenanceCompany`.

Todavía no existen relaciones client-scoped en TASK-009.

---

# 13. Estrategia RLS de TASK-009

## 13.1 Principio

Todas las tablas de aplicación creadas por TASK-009 deben quedar:

```text
RLS ENABLED
```

y con comportamiento:

```text
sin policy explícita suficiente
→ DENIED
```

Aunque `PlatformUser` y el vínculo Auth sean globales, no deben quedar expuestos como tablas globalmente legibles.

## 13.2 Identity anchor

La única información del JWT que puede utilizarse como autoridad primaria en este slice es el subject autenticado necesario para obtener:

```text
auth subject actual
```

Ese subject se utiliza únicamente para resolver `PlatformUser`.

No utilizar como autorización:

- tenant claim;
- role claim;
- membership claim;
- client claim;
- support claim.

Especialmente:

```text
JWT says COMPANY_ADMIN
≠ current role
```

La membership de PostgreSQL es autoritativa.

## 13.3 `platform_user_auth_subjects`

Una identidad autenticada puede como máximo observar el vínculo que corresponde a su propio Auth subject.

No existe policy normal para:

- insertar;
- modificar;
- eliminar;

vínculos Auth.

Su materialización pertenecerá a flujos futuros autorizados o a fixtures controladas de test.

La existencia física de más de un mapping para un mismo `PlatformUser` no forma parte de las pruebas funcionales de TASK-009 y no debe crearse deliberadamente para demostrar account linking o multi-identity.

## 13.4 `platform_users`

Una identidad autenticada puede como máximo leer el `PlatformUser` resuelto desde su propio Auth subject.

No puede:

- enumerar otros usuarios;
- crear usuarios;
- editar usuarios;
- borrar usuarios.

TASK-009 no implementa administración funcional de usuarios.

## 13.5 `company_memberships`

Una identidad autenticada sólo puede leer su propia membership cuando:

```text
Auth subject
→ PlatformUser de la fila
AND
membership.is_enabled = true
```

Una membership disabled/revoked no concede lectura tenant normal.

No existen policies normales para:

- insert;
- update;
- delete.

Por tanto:

```text
authenticated
≠ puede crear o modificar su propia autorización
```

## 13.6 `maintenance_companies`

Una identidad tenant puede leer exclusivamente la `MaintenanceCompany` derivada de su **membership actual habilitada**.

Conceptualmente:

```text
current Auth subject
→ PlatformUser
→ enabled CompanyMembership
→ membership.maintenance_company_id
=
maintenance_companies.id
```

No existe:

```text
request.maintenance_company_id
→ autoridad
```

No existen policies normales para:

- insert;
- update;
- delete.

## 13.7 `SUPER_ADMIN`

TASK-009 no introduce `SupportAccessGrant` ni una operación global de plataforma.

Consecuencia deliberada:

```text
authenticated subject
+
PlatformUser
+
sin enabled CompanyMembership
→ ningún acceso tenant por el camino normal
```

Esto incluye un futuro `SUPER_ADMIN` mientras no exista la operación/global authorization correspondiente.

Por tanto:

```text
ausencia de membership
≠ SUPER_ADMIN
≠ acceso global
```

TASK-009 no debe inventar una policy:

```text
if no membership → super admin
```

ni ninguna policy de bypass global.

## 13.8 Escrituras

No existe ninguna escritura user-originated autorizada en este slice.

Todas las tablas deben permanecer read-only para el usuario autenticado normal salvo que una tarea posterior amplíe expresamente la autorización.

---

# 14. Current authoritative authorization y stale JWT

ADR-0003 exige que el estado vigente prevalezca sobre claims o sesiones residuales.

TASK-009 debe demostrar físicamente al menos el caso que ya puede verificarse con estas tablas:

```text
Auth session/JWT técnicamente válido
+
CompanyMembership cambia enabled → disabled
→ nuevo acceso tenant = DENIED
```

No debe ser necesario:

- esperar expiración del JWT;
- refrescar el token;
- hacer logout;
- terminar provider-side la sesión;

para retirar el acceso de datos.

También debe preservarse:

```text
role actual en CompanyMembership
> role stale supuesto por el cliente/JWT
```

TASK-009 no necesita todavía una operación funcional role-specific para probar capacidades completas; sí debe demostrar que ninguna policy de este slice trata un role claim del JWT como fuente autoritativa.

La mutación privilegiada de `is_enabled` utilizada para esta prueba es exclusivamente `test setup` en Development y no implementa el flujo funcional de deshabilitación/revocación ni satisface su futura obligación de `AuditEvent`.

---

# 15. Separación `SUPER_ADMIN` / usuario tenant

Se preservan las siguientes reglas:

```text
SUPER_ADMIN = identidad global
```

```text
SUPER_ADMIN no posee CompanyMembership
```

```text
CompanyMembership.role ∈ { COMPANY_ADMIN, TECHNICIAN }
```

```text
sin SupportAccessGrant
→ SUPER_ADMIN no posee acceso operativo tenant
```

Como `SupportAccessGrant` está fuera de TASK-009, TASK-009 no concede ningún acceso tenant especial a `SUPER_ADMIN`.

No se necesita resolver todavía cómo se materializará físicamente la clasificación global `SUPER_ADMIN` porque esa clasificación no es necesaria para conceder ninguna operación de este slice.

Si durante implementación se considera necesario introducir:

- `is_super_admin`;
- global role table;
- platform role enum;
- bypass policy;

para poder completar TASK-009:

`BLOCKER`

Esa ampliación no es necesaria para la foundation aprobada aquí y debe revisarse separadamente.

---

# 16. `COMPANY_ADMIN` y `TECHNICIAN`

## 16.1 Roles físicos permitidos

Sólo:

```text
COMPANY_ADMIN
TECHNICIAN
```

## 16.2 `COMPANY_ADMIN`

TASK-009 no amplía sus capacidades.

Continúa vigente:

```text
COMPANY_ADMIN
→ NO initial Maintenance execution
```

No se crean:

- `MaintenanceRecord`;
- `MaintenanceRevision`;
- `Response`;
- `Evidence`;
- APIs de mantenimiento;
- policies de mantenimiento.

Por tanto no existe dentro de este slice una superficie mediante la cual convertir membership tenant-wide en ejecución inicial.

## 16.3 `TECHNICIAN`

Continúa vigente:

```text
TECHNICIAN
→ operación client-scoped sólo mediante UserClientAccess
```

Pero `UserClientAccess` está expresamente fuera de TASK-009.

Por tanto una membership `TECHNICIAN` en esta tarea:

- identifica su tenant;
- identifica su role actual;
- **no concede todavía operación sobre Client, Equipment ni Maintenance**.

No debe inferirse acceso client-scoped por pertenecer al tenant.

---

# 17. Alcance

La futura implementación de TASK-009 comprende exclusivamente:

1. una migration versionada mínima;
2. `maintenance_companies`;
3. `platform_users`;
4. `platform_user_auth_subjects`;
5. `company_memberships`;
6. PK/FK/constraints estrictamente necesarias;
7. verificación oficial previa de la referencia soportada a `auth.users(id)`;
8. FK obligatoria hacia `auth.users(id)` cuando el contrato oficial vigente la soporte;
9. comportamiento `ON DELETE` compatible con la preservación del dominio;
10. RLS de las cuatro tablas;
11. policies mínimas descritas por esta TASK;
12. prueba de resolución Auth subject → PlatformUser;
13. prueba de integridad contra Auth subject inexistente;
14. prueba de no cascada destructiva desde Auth;
15. prueba de membership única;
16. prueba de role válido;
17. prueba cross-tenant;
18. prueba de membership disabled con Auth residual;
19. prueba de ausencia de bypass normal para un subject sin membership;
20. verificación de que ninguna policy de este slice confía en tenant/role stale del JWT;
21. revisión estática;
22. aplicación manual posterior de la migration exclusivamente contra Supabase Cloud Development;
23. verificación remota sanitizada después de la aplicación;
24. checks de regresión del repositorio.

No comprende account linking ni pruebas de múltiples Auth identities para un mismo `PlatformUser`.

---

# 18. Fuera de alcance

TASK-009 no incluye ni autoriza:

- login UI;
- signup UI;
- logout UI;
- Auth SSR lifecycle completo;
- Proxy/middleware Auth funcional;
- refresh funcional de access tokens;
- onboarding;
- creación funcional de empresas;
- alta funcional del primer `COMPANY_ADMIN`;
- creación funcional de usuarios posteriores;
- `VerificationChallenge`;
- email/código de verificación;
- reenvío de códigos;
- completar perfil;
- `UserClientAccess`;
- administración de client scope;
- `SupportAccessGrant`;
- soporte excepcional;
- `AuditEvent`;
- implementación de flows funcionales de alta de usuario/membership;
- implementación de flows funcionales de disable/revoke;
- implementación de flows funcionales de reintegración;
- implementación de flows funcionales de cambio de role;
- implementación de flows funcionales de cambio de client scope;
- account linking;
- múltiples Auth identities como funcionalidad;
- múltiples providers;
- auditoría de eventos obligatorios;
- provider-side session termination;
- session registry;
- custom claims;
- Auth hooks;
- claims de tenant;
- claims de role;
- Storage;
- Storage policies;
- Realtime;
- offline;
- Dexie;
- Service Worker;
- PWA authorization;
- ADR-0004;
- DO-T04;
- OFF-OPEN-001;
- OFF-OPEN-002;
- FORM-OPEN-004;
- Client;
- Location;
- EquipmentType;
- Equipment;
- Form Engine;
- Maintenance;
- Evidence;
- Reporting;
- IA;
- créditos;
- Subscription;
- pagos;
- dashboard;
- notificaciones;
- Production;
- Staging;
- migrations posteriores no necesarias para este slice;
- `service-role` como mecanismo ordinario de aplicación;
- RPC;
- triggers de autorización;
- `SECURITY DEFINER` helpers salvo nueva revisión;
- microservicios;
- APIs/Server Actions funcionales;
- generación de TASK-010.

Mantener `AuditEvent` fuera de alcance no modifica la baseline:

```text
flows funcionales auditables futuros
→ AuditEvent obligatorio
```

TASK-009 no satisface anticipadamente esa obligación.

---

# 19. UI

`NO APLICA`

TASK-009 no introduce páginas, formularios, componentes ni navegación.

No debe aparecer UI para:

- login;
- tenant selection;
- user management;
- role management;
- company creation;
- membership management.

Las pruebas se realizan a nivel de datos/seguridad.

---

# 20. Comportamiento offline

`NO APLICA`

TASK-009 no crea:

- réplica local;
- Dexie schema;
- outbox;
- autorización offline;
- caching de membership;
- caching de tenant;
- logout local;
- purga.

Permanecen intactos:

```text
ADR-0004 = BLOCKED BY OPEN DECISIONS
```

por:

```text
DO-T04
OFF-OPEN-001
OFF-OPEN-002
FORM-OPEN-004
```

Nada de TASK-009 puede utilizarse para resolver esas decisiones.

---

# 21. Migration / schema

## 21.1 Cantidad

Objetivo:

```text
1 migration funcional
```

La migration debe abarcar el slice como unidad atómica de foundation:

```text
identity + tenant minimum schema + RLS
```

No dividir artificialmente una misma foundation en múltiples migrations salvo que una limitación técnica demostrada lo exija.

Si fueran necesarias varias migrations por una razón material:

`BLOCKER / revisión de scope antes de ampliar`

## 21.2 Nombre

La migration debe utilizar el mecanismo normal versionado del proyecto bajo:

`supabase/migrations/`

con un sufijo semántico equivalente a:

`task_009_identity_tenant_foundation`

El timestamp real se determina durante ejecución.

## 21.3 Fuente de verdad

Después de su creación:

```text
Git migration
= fuente de verdad del cambio de schema
```

No crear manualmente tablas/policies en Dashboard como sustituto de la migration.

## 21.4 Contenido autorizado

La migration puede contener exclusivamente:

- las cuatro tablas;
- PK;
- FK;
- FK soportada hacia `auth.users(id)` conforme a §11.4;
- comportamiento `ON DELETE` verificado conforme a §11.4.1;
- uniqueness;
- role constraint;
- `NOT NULL` necesarios;
- RLS enablement;
- policies definidas por esta TASK;
- grants/revokes estrictamente necesarios para que RLS tenga la semántica requerida, cuando el baseline real los haga necesarios.

## 21.5 Contenido no autorizado

No añadir:

- otras entidades;
- `AuditEvent`;
- seed funcional;
- demo tenant;
- usuarios productivos;
- triggers;
- RPC;
- views;
- materialized views;
- business functions;
- auditing;
- Storage;
- Realtime;
- custom claims;
- Auth hooks;
- profile fields no requeridos;
- timestamps por costumbre si no son necesarios para cumplir esta TASK;
- soft delete;
- billing state;
- subscription state;
- client scope;
- provider metadata;
- account-linking metadata.

---

# 22. Estrategia de aplicación en Supabase Cloud Development

La redacción de esta especificación no modifica Supabase Cloud.

Una futura implementación autorizada debe conservar la frontera operativa ya aprobada:

## 22.1 Codex

Codex puede:

- preparar la migration versionada;
- revisar estáticamente SQL;
- preparar pruebas;
- ejecutar checks locales no autenticados;
- revisar diffs.

Codex no puede:

- recibir credenciales Supabase;
- ejecutar `supabase login`;
- ejecutar `supabase link`;
- ejecutar `db push`;
- ejecutar `db push --dry-run`;
- ejecutar queries remotas;
- utilizar `service-role`;
- modificar directamente el proyecto Cloud.

## 22.2 Gate humano remoto

Después de que la implementación local haya superado revisión estática, el operador humano autorizado deberá, exclusivamente contra `Development`:

1. verificar que la migration pendiente es exactamente la de TASK-009;
2. ejecutar el dry-run autorizado como inventario, no como validación SQL;
3. revisar el inventario;
4. ejecutar la migration real contra Development;
5. comprobar el resultado;
6. comprobar el historial de migrations mediante mecanismo remoto no destructivo cuando corresponda;
7. ejecutar las pruebas RLS/integridad previstas;
8. devolver evidencia sanitizada `PASS / FAIL / BLOCKER`.

El proyecto Development:

- no puede contener datos reales;
- no es Staging;
- no es Production.

## 22.3 Fallo remoto

Si la migration falla:

```text
STOP
```

No:

- reparar schema manualmente;
- editar la migration ya aplicada parcialmente por improvisación;
- ejecutar `migration repair` sin procedimiento aprobado;
- resetear Development enlazado;
- avanzar a otro entorno.

Debe producirse una corrección versionada o revisión formal conforme al estado real.

---

# 23. Pruebas

Las pruebas negativas son obligatorias y constituyen parte del criterio de seguridad, no un complemento opcional.

## 23.1 Integridad estructural

### T009-DB-001 — Auth subject único

```text
GIVEN Auth subject S
WHEN attempting mappings S → PlatformUser A and S → PlatformUser B
THEN second mapping is rejected
```

### T009-DB-002 — Cardinalidad inversa permanece diferida

Inspeccionar schema y confirmar:

```text
platform_user_auth_subjects.platform_user_id
```

no posee una uniqueness constraint que establezca:

```text
PlatformUser → máximo un Auth subject
```

Esta prueba es exclusivamente una inspección estructural.

No debe:

- crear dos Auth subjects para un mismo `PlatformUser`;
- demostrar account linking;
- demostrar múltiples identities;
- demostrar múltiples providers;
- interpretar la ausencia de UNIQUE como feature aprobada.

Resultado esperado:

```text
ausencia de UNIQUE(platform_user_id)
→ no se impuso cardinalidad máxima inversa
```

y simultáneamente:

```text
ausencia de UNIQUE(platform_user_id)
≠ soporte aprobado de múltiples Auth identities
```

### T009-DB-003 — Membership única

```text
GIVEN PlatformUser U
AND Tenant A membership already exists
WHEN attempting second membership of U in Tenant B
THEN rejected
```

### T009-DB-004 — Tenant FK

```text
GIVEN nonexistent MaintenanceCompany
WHEN creating membership referencing it in controlled fixture setup
THEN rejected
```

### T009-DB-005 — User FK

```text
GIVEN nonexistent PlatformUser
WHEN creating membership referencing it
THEN rejected
```

### T009-DB-006 — Role inválido

Intentos equivalentes a:

```text
SUPER_ADMIN
UNKNOWN
```

en `company_memberships.role`:

```text
→ rejected
```

### T009-DB-007 — Integridad con Supabase Auth

Después de verificar que la documentación oficial vigente continúa soportando la FK hacia `auth.users(id)`:

```text
GIVEN nonexistent auth.users subject S
AND existing PlatformUser U
WHEN attempting platform_user_auth_subjects(S, U)
THEN rejected by FK integrity
```

Si la documentación oficial no soporta esa FK:

```text
BLOCKER — REVISIÓN HUMANA
```

No ejecutar un test alternativo basado en UUID huérfano.

### T009-DB-008 — Eliminación Auth no destruye dominio

Bajo un fixture controlado de Development:

```text
GIVEN Auth subject S
AND mapping S → PlatformUser U
AND CompanyMembership M belonging to U
AND MaintenanceCompany T belonging to M

WHEN the supported Auth-subject deletion behavior is exercised in the controlled test context

THEN PlatformUser U remains
AND CompanyMembership M remains
AND MaintenanceCompany T remains
AND at most the mapping for S may be removed/affected
```

La prueba debe confirmar el comportamiento `ON DELETE` realmente adoptado y soportado.

No implementa un flujo funcional de eliminación de usuarios.

## 23.2 RLS — identidad propia

### T009-RLS-001

Subject A puede leer exclusivamente su propio vínculo Auth.

### T009-RLS-002

Subject A no puede leer el vínculo Auth de Subject B.

### T009-RLS-003

Subject A puede leer exclusivamente su propio `PlatformUser`.

### T009-RLS-004

Subject A no puede enumerar `PlatformUser` ajenos.

## 23.3 RLS — tenant

Preparar:

```text
Tenant A
Tenant B
User A → enabled membership Tenant A
User B → enabled membership Tenant B
```

### T009-RLS-005

User A puede leer su propia membership habilitada.

### T009-RLS-006

User A no puede leer membership de User B.

### T009-RLS-007

User A puede leer `MaintenanceCompany A`.

### T009-RLS-008

User A no puede leer `MaintenanceCompany B`, incluso con UUID conocido.

### T009-RLS-009

Una consulta explícitamente filtrada por:

```text
maintenance_company_id = Tenant B
```

no convierte ese ID en autoridad.

Resultado para User A:

```text
Tenant B → no visible
```

## 23.4 Revocación / stale JWT

### T009-RLS-010

```text
GIVEN User A authenticated
AND current membership A is enabled
AND same Auth state remains technically usable

WHEN authoritative membership is changed to disabled

THEN subsequent tenant access with the residual Auth state is DENIED
```

Debe verificarse sin exigir como precondición:

- logout;
- token expiration;
- provider-side termination.

La modificación privilegiada de `is_enabled` realizada para esta prueba es `test setup`.

No constituye:

- flow funcional de disable/revoke;
- implementación de administración de membership;
- satisfacción de `AuditEvent`.

### T009-RLS-011

Después de la deshabilitación:

```text
MaintenanceCompany A → DENIED
tenant membership normal access → DENIED
```

## 23.5 Role vigente

### T009-RLS-012

La implementación debe demostrar que ninguna policy de TASK-009 utiliza un JWT role custom claim como autoridad tenant.

Cuando el role actual de la membership cambia en fixtures controladas:

```text
current DB role
```

es el único role tenant representado por este slice.

La modificación privilegiada del role para test setup:

- no es un flow funcional de cambio de role;
- no satisface la obligación futura de `AuditEvent`.

## 23.6 Subject sin membership

### T009-RLS-013

```text
GIVEN recognized Auth subject
AND PlatformUser exists
AND no enabled CompanyMembership

WHEN accessing any MaintenanceCompany

THEN DENIED
```

Este test representa el comportamiento fail-closed requerido tanto para:

- identidad todavía no autorizada;
- futuro actor global sin grant.

## 23.7 Escrituras normales

### T009-RLS-014

Bajo identidad `authenticated` normal no se puede crear:

- `MaintenanceCompany`;
- `PlatformUser`;
- vínculo Auth;
- `CompanyMembership`.

### T009-RLS-015

Bajo identidad `authenticated` normal no se puede modificar:

- tenant;
- mapping Auth;
- role;
- estado de membership.

### T009-RLS-016

Bajo identidad `authenticated` normal no se puede eliminar ninguna de las entidades de foundation.

## 23.8 Tests con privilegio

Los privilegios administrativos pueden utilizarse exclusivamente para:

- crear fixtures aisladas de Development;
- alterar el estado autoritativo entre pasos de una prueba;
- verificar integridad de la FK Auth;
- verificar comportamiento no destructivo ante eliminación del Auth subject;
- limpiar fixtures.

Estas acciones son:

```text
test setup / test teardown
```

No son operaciones funcionales del producto.

En particular, una mutación privilegiada de fixtures que:

- cree una membership;
- cambie `is_enabled`;
- cambie `role`;

no constituye implementación de:

- alta funcional;
- deshabilitación/revocación;
- reintegración;
- cambio funcional de role.

Tampoco satisface ni elimina la obligación futura de `AuditEvent`.

Las **assertions de autorización** deben ejecutarse bajo identidades no privilegiadas.

Un test que demuestra acceso utilizando `service-role`:

```text
NO demuestra RLS
```

y no satisface los criterios de aceptación.

No introducir `service-role` en el contrato de aplicación.

---

# 24. Datos de prueba remotos

Cuando las pruebas requieran Auth subjects reales:

- deben ser identidades descartables;
- exclusivas de Development;
- sin correos o información de clientes reales;
- creadas mediante mecanismos públicos/soportados de Supabase por el operador humano;
- no deben transformarse en onboarding funcional;
- no deben incorporarse como seed de producción;
- sus credenciales no se entregan a Codex ni se versionan.

La creación de fixtures Auth para verificación de RLS:

```text
≠ implementación de signup/login del producto
```

La creación de más de un Auth subject para el mismo `PlatformUser` con el propósito de demostrar account linking o múltiples identities:

```text
NO FORMA PARTE DE TASK-009
```

---

# 25. Cambios esperados

La futura implementación debe producir un diff pequeño y concentrado.

## 25.1 Obligatorio

- una migration bajo `supabase/migrations/`;
- pruebas/verificación reproducibles del schema y RLS de TASK-009;
- únicamente ajustes mínimos de tooling de tests si el repositorio demuestra que son imprescindibles y no añaden una nueva arquitectura.

## 25.2 Aplicación Next.js

Cambios funcionales esperados:

```text
NINGUNO
```

No deben aparecer queries de negocio desde:

- pages;
- components;
- Server Actions;
- Route Handlers.

TASK-009 crea la foundation de datos, no consumidores funcionales.

## 25.3 Documentación

La implementación técnica no debe modificar documentos normativos salvo que una autorización documental separada lo indique.

---

# 26. Criterios de aceptación

## CA-009-001

Existe una única migration versionada que representa exclusivamente la foundation de TASK-009.

## CA-009-002

Existe `maintenance_companies` con identidad tenant física mínima.

## CA-009-003

Existe `platform_users` como identidad de aplicación separada del Auth subject.

## CA-009-004

Existe un vínculo físico estable:

```text
Auth subject → PlatformUser
```

## CA-009-005

Cada Auth subject puede resolver como máximo a un único `PlatformUser`.

## CA-009-006

El schema no impone:

```text
PlatformUser → máximo un Auth subject
```

mediante `UNIQUE(platform_user_id)`.

Esta ausencia no se interpreta como decisión positiva de cardinalidad.

Debe permanecer cierto:

```text
ausencia de UNIQUE(platform_user_id)
≠ soporte aprobado de múltiples Auth identities
≠ account linking
≠ PlatformUser → 0..* Auth subjects como contrato de producto
```

La cardinalidad inversa continúa diferida.

## CA-009-007

Existe `company_memberships` con:

- usuario;
- tenant;
- role vigente;
- estado enabled/disabled.

## CA-009-008

Un `PlatformUser` no puede tener dos memberships simultáneas.

## CA-009-009

Una membership no puede apuntar a un tenant inexistente.

## CA-009-010

Una membership no puede apuntar a un PlatformUser inexistente.

## CA-009-011

Sólo son roles tenant válidos:

```text
COMPANY_ADMIN
TECHNICIAN
```

## CA-009-012

`SUPER_ADMIN` no es role válido de `CompanyMembership`.

## CA-009-013

RLS está habilitada en todas las tablas introducidas.

## CA-009-014

Un usuario autenticado sólo puede leer su propio vínculo Auth.

## CA-009-015

Un usuario autenticado sólo puede leer su propio `PlatformUser`.

## CA-009-016

Un usuario tenant sólo puede leer su membership actual habilitada.

## CA-009-017

Un usuario tenant sólo puede leer la `MaintenanceCompany` derivada de su membership habilitada.

## CA-009-018

Tenant A no puede leer Tenant B aunque conozca su UUID.

## CA-009-019

`maintenance_company_id` suministrado por caller no constituye autoridad.

## CA-009-020

Una membership disabled retira inmediatamente el acceso tenant online bajo el mismo estado Auth residual.

## CA-009-021

Las policies no dependen de tenant, membership ni role almacenados como claims stale del JWT.

## CA-009-022

Un Auth subject reconocido sin enabled membership no obtiene acceso tenant.

## CA-009-023

No existe bypass tenant normal para `SUPER_ADMIN`.

## CA-009-024

No existe ninguna policy normal de insert/update/delete para actores autenticados sobre las cuatro tablas de foundation.

## CA-009-025

No existe `service-role` en el contrato normal de aplicación.

## CA-009-026

No se implementó login/signup/logout.

## CA-009-027

No se implementó `VerificationChallenge`.

## CA-009-028

No se implementó onboarding.

## CA-009-029

No se implementó `UserClientAccess`.

## CA-009-030

No se implementó `SupportAccessGrant`.

## CA-009-031

No se implementó Storage, Realtime ni offline.

## CA-009-032

No se resolvió ADR-0004 ni ninguno de sus blockers.

## CA-009-033

`COMPANY_ADMIN` no recibió ninguna superficie de ejecución inicial de Maintenance.

## CA-009-034

`TECHNICIAN` no recibió acceso client-scoped por inferencia.

## CA-009-035

La migration fue revisada estáticamente antes de cualquier operación remota.

## CA-009-036

Codex no realizó operaciones autenticadas/remotas contra Supabase.

## CA-009-037

La migration fue aplicada primero exclusivamente a Development mediante el operador humano autorizado.

## CA-009-038

Las pruebas de integridad y RLS en Development pasan.

## CA-009-039

No se utilizaron datos reales.

## CA-009-040

No se realizó reparación manual improvisada del schema.

## CA-009-041

Los checks generales del repositorio continúan pasando.

## CA-009-042

El diff final contiene únicamente cambios necesarios para TASK-009.

## CA-009-043

No se generó TASK-010.

## CA-009-044

Antes de implementar el mapping Auth se verificó documentación oficial vigente de Supabase.

Si `auth.users(id)` continúa soportado como PK estable referenciable desde el schema de aplicación:

```text
FK platform_user_auth_subjects.auth_subject_id
→ auth.users(id)
```

está presente.

Si no continúa soportado:

```text
TASK-009 = BLOCKER — REVISIÓN HUMANA
```

## CA-009-045

Con la FK Auth soportada, un mapping hacia un Auth subject inexistente es rechazado por integridad.

## CA-009-046

El comportamiento `ON DELETE` desde `auth.users` fue verificado contra documentación oficial vigente y no puede destruir en cascada:

- `PlatformUser`;
- `CompanyMembership`;
- `MaintenanceCompany`.

## CA-009-047

TASK-009 no crea múltiples Auth subjects para un mismo `PlatformUser` con el objetivo de demostrar una feature y no implementa:

- account linking;
- multiple identities;
- multiple providers.

## CA-009-048

`AuditEvent` permanece fuera de TASK-009, pero la especificación y la implementación no presentan la foundation como satisfacción de la obligación de auditoría ya aprobada.

## CA-009-049

Las mutaciones privilegiadas realizadas para fixtures/pruebas son tratadas exclusivamente como test setup/test teardown y no como implementación de los flows funcionales auditables.

## CA-009-050

Permanece explícitamente pendiente que todo futuro flow funcional de:

- alta de usuario/membership;
- disable/revoke;
- reintegración;
- cambio de role;
- cambio de client scope;

incluya el `AuditEvent` obligatorio correspondiente antes de poder considerarse completo.

---

# 27. Verificaciones

## 27.1 Preflight Git

Una futura ejecución debe registrar al menos:

- repo root;
- branch;
- `HEAD`;
- upstream;
- `origin/main`;
- divergencia;
- worktree;
- staged;
- untracked;
- Node;
- npm.

El SHA recibido durante esta definición no reemplaza ese preflight.

## 27.2 Inspección previa

Antes de modificar:

- `package.json`;
- `package-lock.json`;
- `supabase/`;
- `supabase/config.toml`;
- `supabase/migrations/`;
- tests existentes;
- configuración de Supabase de TASK-008;
- referencias a `PlatformUser`;
- referencias a `MaintenanceCompany`;
- referencias a `CompanyMembership`;
- referencias a Auth;
- cualquier schema SQL existente;
- cualquier RLS existente.

## 27.3 Auditoría de scope

Buscar como mínimo:

```text
maintenance_companies
platform_users
company_memberships
platform_user_auth_subjects
auth_subject
auth.users
UserClientAccess
SupportAccessGrant
VerificationChallenge
AuditEvent
service_role
SECURITY DEFINER
CREATE POLICY
```

Toda implementación preexistente inesperada que cambie materialmente el diseño:

`BLOCKER`

## 27.4 Revisión de contrato oficial Auth

Antes de redactar definitivamente la FK Auth dentro de la migration:

1. consultar documentación oficial vigente de Supabase;
2. verificar que `auth.users(id)` continúa siendo una PK estable administrada por Supabase y soportada para referencia desde tablas del schema de aplicación;
3. verificar el comportamiento y restricciones soportadas para FK;
4. verificar las implicaciones documentadas de `ON DELETE`;
5. registrar la evidencia/referencia oficial utilizada durante la ejecución.

Resultado:

### Si continúa soportado

```text
FK auth_subject_id → auth.users(id) = OBLIGATORIA
```

### Si no continúa soportado o existe incompatibilidad material

```text
BLOCKER — REVISIÓN HUMANA
```

No:

- continuar con UUID sin FK;
- inventar tabla espejo;
- inventar trigger;
- inventar mecanismo de linking.

## 27.5 Revisión estática de migration

Confirmar:

- exactamente cuatro tablas de foundation;
- ninguna entidad fuera de scope;
- FK correctas;
- FK Auth presente cuando el contrato oficial la soporte;
- mapping a Auth subject inexistente rechazable por integridad;
- comportamiento `ON DELETE` Auth no destructivo sobre dominio;
- uniqueness correcta de `auth_subject_id`;
- `platform_user_id` del vínculo Auth sin uniqueness;
- ausencia de esa uniqueness documentada sólo como no imposición de cardinalidad máxima inversa;
- ninguna lógica de account linking;
- ninguna lógica multi-provider;
- uniqueness correcta de membership;
- role constraint correcta;
- RLS habilitada;
- policies fail-closed;
- ausencia de claims de tenant/role como autoridad;
- ausencia de bypass `SUPER_ADMIN`;
- ausencia de escritura normal;
- ausencia de `service-role`;
- ausencia de triggers/RPC/helpers privilegiados no autorizados;
- ausencia de `AuditEvent`;
- ausencia de flows funcionales de administración de membership.

## 27.6 Checks del repositorio

Ejecutar, conforme al baseline disponible:

```text
npm ci
npm run lint
npm run typecheck
npm run test
npm run build
npm run verify
git diff --check
```

Si algún comando aprobado ha cambiado legítimamente desde TASK-008, utilizar el contrato canónico vigente y registrar la diferencia.

## 27.7 Diff

Registrar:

```text
git diff --name-only
git diff --stat
git diff --numstat
git diff --check
```

y revisar íntegramente todos los archivos modificados.

## 27.8 Gate remoto

El resultado remoto debe registrar de forma sanitizada:

```text
official Supabase auth.users FK contract verified = PASS/FAIL
Auth FK present when supported = PASS/FAIL
nonexistent Auth subject FK test = PASS/FAIL
Auth deletion domain-preservation test = PASS/FAIL
dry-run inventory = PASS/FAIL
migration applied to Development = PASS/FAIL
migration history post-check = PASS/FAIL
RLS/integrity test suite = PASS/FAIL
real customer data used = NO
manual schema repair = NO
```

---

# 28. Blockers

La futura ejecución debe detenerse sin modificar o sin continuar, según el momento del descubrimiento, si ocurre cualquiera de estas condiciones:

1. ADR-0002 deja de estar `ACCEPTED`;
2. ADR-0003 deja de estar `ACCEPTED`;
3. TASK-008 no está realmente cerrada;
4. Fase 2 deja de estar iniciada;
5. existe una TASK-009 canónica incompatible;
6. existe schema previo incompatible;
7. existe migration previa que ya materializa estas entidades de otra forma;
8. el vínculo mínimo requiere fusionar `PlatformUser` con `auth.users`;
9. el mecanismo propuesto fija la cardinalidad inversa Auth;
10. se pretende interpretar la ausencia de `UNIQUE(platform_user_id)` como soporte de múltiples Auth identities;
11. se necesita resolver account linking;
12. se necesita modelar múltiples proveedores;
13. la documentación oficial vigente deja de soportar o vuelve materialmente incompatible la FK hacia `auth.users(id)`;
14. no puede verificarse de manera suficiente el contrato oficial vigente para `auth.users(id)`;
15. la única alternativa propuesta ante una FK Auth no soportada es mantener un UUID huérfano;
16. la única alternativa propuesta implica inventar otro mecanismo de linking;
17. el comportamiento `ON DELETE` soportado permitiría eliminar en cascada `PlatformUser`, `CompanyMembership` o `MaintenanceCompany`;
18. se necesita implementar Auth funcional para crear el schema;
19. se necesita `VerificationChallenge`;
20. se necesita onboarding;
21. se necesita `UserClientAccess`;
22. se necesita `SupportAccessGrant`;
23. se necesita `AuditEvent` para poder completar técnicamente este slice de foundation;
24. se pretende considerar las mutaciones de fixtures como implementación de un flow funcional auditable;
25. se necesita una representación física de `SUPER_ADMIN` para conceder acceso tenant;
26. se necesita `service-role` como acceso normal;
27. se necesita `SECURITY DEFINER` u otra frontera privilegiada no contemplada para que el modelo funcione;
28. no puede garantizarse membership única;
29. no puede garantizarse integridad de tenant;
30. no puede implementarse RLS fail-closed;
31. las policies necesitan confiar en custom claims stale;
32. la revocación de membership no puede surtir efecto inmediato a nivel de datos;
33. se necesita resolver ADR-0004;
34. se necesita resolver DO-T04;
35. se necesita resolver OFF-OPEN-001;
36. se necesita resolver OFF-OPEN-002;
37. se necesita resolver FORM-OPEN-004;
38. la migration requiere más entidades que las autorizadas;
39. la migration no puede revisarse estáticamente;
40. el operador humano no puede aplicar/probar el cambio exclusivamente en Development;
41. se detectan datos reales en Development;
42. `db push` falla;
43. las pruebas RLS fallan;
44. una prueba necesita usar `service-role` para que una assertion de acceso pase;
45. el diff excede materialmente el tamaño PR de esta foundation;
46. se necesita modificar producto o arquitectura para completar el slice.

Ante BLOCKER:

- no ampliar scope;
- no inventar solución;
- no generar ADR;
- no generar TASK-010;
- conservar evidencia;
- devolver TASK-009 a revisión.

---

# 29. Definition of Done

Una futura implementación podrá proponerse como completada únicamente cuando:

1. todas las precondiciones continúan satisfechas;
2. la migration versionada fue creada;
3. las cuatro tablas son exactamente las autorizadas;
4. la relación Auth subject → PlatformUser preserva ADR-0003;
5. cada Auth subject reconocido queda físicamente limitado a un único `PlatformUser`;
6. la cardinalidad inversa `PlatformUser → Auth subject(s)` continúa diferida;
7. la ausencia de `UNIQUE(platform_user_id)` no se ha tratado como soporte de múltiples identities, account linking ni multi-provider;
8. no se crearon múltiples mappings para un mismo `PlatformUser` con el propósito de demostrar una feature;
9. documentación oficial vigente de Supabase fue verificada para `auth.users(id)`;
10. si la referencia continúa soportada, existe la FK obligatoria `auth_subject_id → auth.users(id)`;
11. un mapping hacia Auth subject inexistente es rechazado;
12. el comportamiento `ON DELETE` Auth fue verificado y no puede destruir `PlatformUser`, `CompanyMembership` ni `MaintenanceCompany`;
13. membership única está físicamente garantizada;
14. role tenant está restringido;
15. `SUPER_ADMIN` permanece fuera de `CompanyMembership`;
16. RLS está habilitada;
17. las policies utilizan estado autoritativo vigente;
18. no se confía en tenant enviado desde frontend;
19. membership disabled elimina acceso tenant inmediatamente a nivel de datos;
20. pruebas cross-tenant pasan;
21. pruebas de integridad pasan;
22. pruebas de sujeto sin membership pasan;
23. pruebas de escritura denegada pasan;
24. ningún path normal utiliza `service-role`;
25. no existe Auth funcional;
26. no existe onboarding;
27. no existe `VerificationChallenge`;
28. no existe `UserClientAccess`;
29. no existe `SupportAccessGrant`;
30. no existe `AuditEvent` implementado por TASK-009;
31. TASK-009 no se presenta como satisfacción de la obligación futura de auditoría;
32. las mutaciones privilegiadas de fixtures se consideran exclusivamente test setup/test teardown;
33. permanece explícitamente vigente la obligación de `AuditEvent` para futuros flows funcionales de alta, disable/revoke, reintegración, cambio de role y cambio de client scope;
34. no existe Storage;
35. no existe Realtime;
36. no existe offline;
37. ADR-0004 y sus blockers permanecen intactos;
38. no existe capacidad Maintenance nueva;
39. checks del repositorio pasan;
40. `git diff --check` pasa;
41. diff completo fue revisado;
42. Codex no ejecutó operaciones remotas;
43. operador humano aplicó la migration exclusivamente en Development;
44. comprobación post-migration fue satisfactoria;
45. RLS fue verificada contra identidades no privilegiadas;
46. no se usaron datos reales;
47. no se realizaron reparaciones manuales de schema;
48. revisión arquitectónica confirma coherencia con ADR-0001/0002/0003;
49. revisión de seguridad confirma aislamiento y fail-closed;
50. revisión de regresión confirma que TASK-008 permanece intacta;
51. revisión humana final aprueba el resultado;
52. incorporación Git se realiza sólo después de esa aprobación;
53. branch vuelve a quedar sincronizada y limpia;
54. TASK-010 no fue generada ni determinada.

---

# 30. Instrucciones futuras para Codex

Cuando exista una autorización concreta separada, Codex deberá:

1. leer íntegramente TASK-009 canónica;
2. leer íntegramente todas las fuentes obligatorias;
3. ejecutar preflight Git;
4. inspeccionar el schema real versionado antes de proponer cambios;
5. detenerse ante cualquier contradicción;
6. no reutilizar ciegamente el SHA de preparación;
7. mantener el diff PR-sized;
8. crear únicamente la migration autorizada;
9. materializar únicamente las cuatro tablas definidas;
10. preservar separación `Auth subject ≠ PlatformUser`;
11. preservar la regla cerrada `cada Auth subject reconocido → exactamente un PlatformUser`;
12. no hacer unique `platform_user_id` en `platform_user_auth_subjects`;
13. interpretar la ausencia de `UNIQUE(platform_user_id)` exclusivamente como no imposición de `PlatformUser → máximo un Auth subject`;
14. no tratar esa ausencia como soporte de múltiples Auth identities;
15. no tratar esa ausencia como account linking;
16. no crear múltiples Auth subjects para un mismo `PlatformUser` con el objetivo de demostrar una feature;
17. no implementar múltiples providers;
18. verificar primero documentación oficial vigente de Supabase respecto de `auth.users(id)`;
19. si `auth.users(id)` continúa públicamente soportado como PK estable referenciable, implementar obligatoriamente la FK `auth_subject_id → auth.users(id)`;
20. si la referencia deja de estar soportada o presenta incompatibilidad material, detenerse con:

```text
BLOCKER — REVISIÓN HUMANA
```

21. no continuar con UUID huérfano como fallback;
22. no inventar otro mecanismo de linking;
23. verificar contra documentación oficial vigente el comportamiento `ON DELETE`;
24. garantizar que cualquier efecto de eliminación Auth alcance como máximo al mapping y nunca destruya `PlatformUser`, `CompanyMembership` ni `MaintenanceCompany`;
25. no implementar triggers para el linking Auth;
26. hacer cumplir `PlatformUser → 0..1 CompanyMembership`;
27. restringir membership role a `COMPANY_ADMIN | TECHNICIAN`;
28. no modelar `SUPER_ADMIN` como membership;
29. habilitar RLS en todas las tablas de TASK-009;
30. implementar únicamente las policies descritas;
31. usar el Auth subject sólo como identity anchor;
32. no confiar en tenant/role/client scope del request;
33. no confiar en custom claims como autorización vigente;
34. no crear policies de escritura normal;
35. no introducir `service-role`;
36. no introducir `SECURITY DEFINER`;
37. no introducir RPC;
38. no introducir triggers;
39. no implementar Auth funcional;
40. no implementar login/signup/logout;
41. no implementar onboarding;
42. no implementar `VerificationChallenge`;
43. no implementar `UserClientAccess`;
44. no implementar `SupportAccessGrant`;
45. no implementar `AuditEvent`;
46. no presentar la ausencia de `AuditEvent` como eliminación o satisfacción de la obligación de auditoría aprobada;
47. tratar las mutaciones privilegiadas de fixtures exclusivamente como test setup/test teardown;
48. no considerar la creación de membership de fixture como flow funcional de alta;
49. no considerar cambios de `is_enabled` de fixture como flows funcionales de disable/reinstate;
50. no considerar cambios de `role` de fixture como flow funcional de cambio de role;
51. preservar explícitamente que los futuros flows funcionales de alta, disable/revoke, reintegración, cambio de role y cambio de client scope requieren su `AuditEvent` obligatorio;
52. no implementar Storage;
53. no implementar Realtime;
54. no implementar offline;
55. no resolver ADR-0004 ni sus blockers;
56. preparar pruebas de integridad y RLS;
57. incluir prueba de FK Auth contra subject inexistente;
58. incluir prueba de preservación de dominio ante eliminación de Auth subject;
59. no incluir test de account linking ni test de múltiples identities para un mismo `PlatformUser`;
60. ejecutar sólo verificaciones locales/no autenticadas permitidas;
61. detenerse antes de cualquier operación remota;
62. entregar al operador humano instrucciones exactas y sanitizadas para el Gate remoto autorizado;
63. exigir aplicación primero sobre Development;
64. considerar el dry-run únicamente inventario;
65. no considerar PASS hasta la ejecución real de la migration y pruebas RLS;
66. ante fallo remoto, no reparar manualmente el schema;
67. revisar íntegramente el diff;
68. ejecutar los checks del repositorio;
69. no hacer commit;
70. no hacer push;
71. no generar TASK-010;
72. devolver `PASS`, `FAIL` o `BLOCKER` con evidencia suficiente para revisión humana.

Estas instrucciones forman parte de la especificación.

No constituyen todavía un prompt de ejecución para Codex.

---

# 31. Gate posterior

Incluso si una futura implementación obtiene:

```text
TASK-009 technical result = PASS
```

eso no equivale a:

```text
TASK-009 = COMPLETADA
```

hasta completar:

```text
implementación local
→ revisión de diff
→ aplicación manual Development
→ pruebas RLS/integridad
→ revisión arquitectónica
→ revisión de seguridad
→ revisión de regresiones
→ aprobación humana
→ incorporación Git
→ estado Git limpio/sincronizado
→ cierre humano final
```

Sólo después podrá declararse:

```text
TASK-009 = COMPLETADA
```

Y aun entonces:

```text
TASK-009 = COMPLETADA
≠
TASK-010 autorizada
≠
TASK-010 determinada
```

La determinación del siguiente incremento PR-sized de Fase 2 pertenece a un acto posterior y separado del Revisor Central.

---

# 32. Estado final de esta especificación

```text
TASK-009 = APPROVED FOR IMPLEMENTATION

Implementación autorizada = NO
Codex autorizado = NO
Ejecución concreta autorizada = NO

Repositorio modificado = NO
Supabase Cloud modificado = NO

ADR nuevo requerido = NO

Schema propuesto =
MaintenanceCompany
+ PlatformUser
+ Auth subject → PlatformUser
+ CompanyMembership

Auth subject → exactamente un PlatformUser = PRESERVADO

PlatformUser → Auth subject(s) = DIFERIDO
Account linking = NO
Múltiples Auth identities como feature = NO
Múltiples providers = NO

FK auth_subject_id → auth.users(id) =
OBLIGATORIA SI EL CONTRATO OFICIAL VIGENTE CONTINÚA SOPORTÁNDOLA
EN CASO CONTRARIO = BLOCKER — REVISIÓN HUMANA

Auth deletion cascade into domain = PROHIBIDA

AuditEvent = FUERA DE ALCANCE
Obligación futura de AuditEvent = PRESERVADA

Auth funcional = NO
Onboarding = NO
VerificationChallenge = NO
UserClientAccess = NO
SupportAccessGrant = NO

Storage = NO
Realtime = NO
Offline = NO

ADR-0004 resuelto = NO
DO-T04 resuelto = NO
OFF-OPEN-001 resuelto = NO
OFF-OPEN-002 resuelto = NO
FORM-OPEN-004 resuelto = NO

TASK-010 generada = NO
TASK-010 determinada = NO
```