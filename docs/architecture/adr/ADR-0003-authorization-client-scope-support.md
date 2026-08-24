# ADR-0003 — Autorización, client scope y soporte excepcional

## 1. Identificación

**ID:** `ADR-0003`

**Título:** `Autorización, client scope y soporte excepcional`

**Tipo:** Architecture Decision Record

**Versión:** segunda versión corregida

**Status:** `ACCEPTED`

**Archivo de entrega aprobado:**

`ADR-0003-authorization-client-scope-support-approved.md`

**Ruta canónica futura:**

`docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`

**Ámbito:** identidad autenticada, autorización online, membership tenant, roles, client scope, soporte excepcional, revocación, sesiones, Storage y frontera de privilegio.

**Implementación autorizada:** `NO`

**SQL:** `NO`

**Migrations:** `NO`

**Policies RLS ejecutables:** `NO`

**Fase 2 iniciada:** `NO`

El estado `ACCEPTED` significa que el contenido arquitectónico ha completado revisión técnica, arquitectónica, de seguridad y multitenancy y ha sido aprobado formalmente mediante decisión humana.

La aprobación arquitectónica no autoriza implementación y no implica que el Gate de entrada a Fase 2 haya sido evaluado o satisfecho.

---

# 2. Estado

`ACCEPTED`

La baseline actual permitió redactar y revisar este ADR porque:

- `DO-T03 = RESUELTO/APROBADO`;
- `DO-T03` ya no constituye un blocker;
- `ADR-0003 = READY TO DRAFT` fue la clasificación previa que autorizó su preparación como documento separado;
- no existía otra open dependency conceptual conocida que debiera resolverse antes de documentar esta decisión;
- el Gate de Fase 2 exige que `ADR-0003 = ACCEPTED` antes de implementar identidad/autorización.

La segunda versión corregida completó la revisión técnica, arquitectónica, de seguridad y multitenancy y fue aprobada formalmente mediante decisión humana:

`ADR-0003 = ACCEPTED`

Esta aprobación no reabre DO-T03, no modifica DO-075 y no resuelve ADR-0004.

---

# 3. Contexto

El producto es un SaaS B2B multiempresa cuya frontera de tenant es `MaintenanceCompany`. Los tenants comparten la infraestructura PostgreSQL/Supabase del MVP, pero todo recurso tenant-owned debe mantener ownership inequívoco y aislamiento remoto. `ADR-0002 = ACCEPTED` establece RLS como frontera primaria de aislamiento remoto, tenant resolution autoritativa, integridad cross-tenant y uso restringido de credenciales privilegiadas.

La identidad, la pertenencia y el alcance funcional son conceptos separados. `PlatformUser` representa la identidad reconocida por la plataforma; `CompanyMembership` vincula un usuario tenant con exactamente una `MaintenanceCompany`, su rol y su estado; `UserClientAccess` expresa autorización explícita sobre clientes; `SupportAccessGrant` permite acceso excepcional, limitado y auditable a un `SUPER_ADMIN` global.

La estrategia de seguridad exige que la resolución conceptual siga:

```text
Supabase Auth identity
→ PlatformUser
→ actor global o CompanyMembership
→ tenant / rol / client scope
→ ownership real del recurso
→ operación autorizada o denegada
```

y prohíbe confiar en un `maintenance_company_id`, `client_id` u otro contexto afirmado por frontend como prueba de autorización.

`DO-T03 = RESUELTO/APROBADO` fija además una separación fundamental:

- autenticación residual puede continuar técnicamente;
- autorización revocada no continúa;
- el estado autoritativo vigente prevalece;
- RLS/autorización vigente es la defensa primaria;
- la terminación provider-side de sesiones y credenciales renovables es defensa adicional.

Este ADR consolida esas reglas en una arquitectura suficientemente precisa para permitir posteriormente diseñar modelo físico, policies RLS, Storage authorization y pruebas negativas sin convertir este documento en implementación.

---

# 4. Problema

¿Cómo debe construirse la frontera de autorización del MVP para que:

1. Supabase Auth identifique al sujeto pero no se convierta en fuente autoritativa de permisos;
2. un usuario tenant sólo opere dentro de su única `MaintenanceCompany`;
3. un `TECHNICIAN` sólo opere sobre clientes autorizados mediante `UserClientAccess`;
4. `COMPANY_ADMIN` conserve sus capacidades administrativas sin adquirir directa ni indirectamente ejecución inicial de mantenimiento;
5. un bypass de UI, API o superficie directa de datos no materialice operaciones que el rol no posee;
6. Evidence y documentos tenant-owned no creen una vía paralela de bypass mediante Storage;
7. `SUPER_ADMIN` no obtenga acceso operativo normal a tenants;
8. `SupportAccessGrant` habilite exclusivamente el acceso excepcional concedido sin crear capacidades funcionales nuevas;
9. una reducción o revocación de permisos tenga efecto online inmediato incluso con JWT, sesión o referencia de archivo residual;
10. RLS continúe siendo frontera primaria de datos;
11. operaciones server-side privilegiadas no se conviertan en bypass;
12. la futura solución offline pueda consumir un contrato de autorización sin que ADR-0003 diseñe ADR-0004?

---

# 5. Drivers

## 5.1 Seguridad

- aislamiento absoluto entre tenants;
- fail-closed;
- revocación efectiva inmediata;
- resistencia a JWT/claims stale;
- rechazo de bypass directo de UI, API, datos o Storage;
- mínimo privilegio;
- separación entre autenticación y autorización;
- privilegio server-side explícitamente delimitado;
- enforcement efectivo de prohibiciones de negocio críticas.

## 5.2 Multitenancy

`MaintenanceCompany` sigue siendo la única frontera tenant del MVP.

`Client` es una frontera funcional de alcance dentro del tenant, no un subtenant.

## 5.3 Coherencia de roles

La arquitectura no puede ampliar las capacidades aprobadas de un rol por comodidad técnica.

En particular:

- `COMPANY_ADMIN` puede administrar su tenant, leer mantenimientos, corregir finalizados y resolver conflictos;
- `COMPANY_ADMIN` no posee ejecución inicial;
- esa prohibición debe resistir caminos alternativos de datos o API;
- `TECHNICIAN` mantiene ejecución inicial exclusivamente dentro de sus clientes autorizados.

## 5.4 Revocación

El tiempo de vida técnico de un access JWT, sesión o referencia de archivo no puede convertirse en ventana de autorización después de una revocación.

## 5.5 Defensa en profundidad

La destrucción provider-side de sesiones es deseable cuando exista un mecanismo soportado apropiado, pero no puede ser necesaria para proteger los datos.

## 5.6 Simplicidad arquitectónica

La solución debe caber en el monolito modular Next.js + Supabase ya aprobado, sin introducir microservicios ni una infraestructura paralela de autorización.

---

# 6. Invariantes

## 6.1 Tenant

```text
tenant = MaintenanceCompany
```

Todo recurso tenant-owned pertenece directa o derivadamente a una sola `MaintenanceCompany`.

## 6.2 Autenticación no equivale a autorización

```text
authenticated ≠ authorized
```

Una sesión válida sólo demuestra una identidad Auth válida conforme al proveedor. No demuestra por sí sola:

- membership;
- tenant;
- rol;
- client scope;
- `SupportAccessGrant`;
- permiso funcional;
- estado comercial;
- ownership del recurso.

## 6.3 RLS

RLS continúa siendo la frontera primaria para acceso remoto normal a datos tenant-owned.

Esta frontera debe proteger no sólo qué filas son visibles, sino impedir que caminos alternativos materialicen estados que el actor no está autorizado a crear.

## 6.4 `COMPANY_ADMIN`

No obtiene por pertenecer al tenant:

- iniciar mantenimiento;
- ejecutar la primera intervención;
- finalizar la primera ejecución;
- crear respuestas correspondientes a esa ejecución inicial;
- crear evidencias correspondientes a esa ejecución inicial.

Sus escrituras sobre mantenimiento se limitan a contextos ya aprobados de corrección o resolución de conflicto.

La ausencia de ejecución inicial debe cumplirse aunque el actor:

- evite la UI;
- invoque directamente una API;
- utilice una superficie genérica de mutación;
- intente crear directamente registros subordinados;
- conozca IDs válidos.

## 6.5 `TECHNICIAN`

Para recursos client-scoped:

```text
membership habilitada
AND role = TECHNICIAN
AND resource.tenant = membership.tenant
AND UserClientAccess(membership, resource.client)
```

La autorización por cliente se hereda hacia la jerarquía operativa aprobada; no existen asignaciones independientes por ubicación, equipo, formulario, mantenimiento o revisión.

## 6.6 `SUPER_ADMIN`

```text
SUPER_ADMIN → acceso operativo tenant
```

es inválido.

Sin `SupportAccessGrant` suficiente, `SUPER_ADMIN` no posee acceso operativo normal a datos tenant.

## 6.7 Revocación efectiva

Una revocación, deshabilitación o reducción de alcance retira inmediatamente toda autorización online afectada según estado autoritativo vigente.

Una sesión/JWT residual:

- no conserva membership;
- no conserva rol;
- no conserva client scope;
- no conserva `SupportAccessGrant`;
- no conserva una autorización revocada.

Una referencia residual a un archivo tampoco constituye autorización.

## 6.8 Provider-side termination

La terminación provider-side es defense in depth.

Su ausencia, limitación o fallo:

- no restaura autorización;
- no habilita acceso;
- no genera rollback.

## 6.9 Mecanismos provider-side

Sólo pueden contemplarse mecanismos:

- públicos;
- soportados;
- contractualmente adecuados.

## 6.10 Prohibiciones

No se adoptan por inferencia:

- `updateUserById(...password...)` como mecanismo contractual de revocación;
- `ban_duration` como equivalente contractual de global sign-out;
- mutación directa de `auth.sessions`;
- almacenamiento de JWT de otros usuarios;
- APIs no documentadas;
- internals del proveedor;
- workarounds no aprobados.

---

# 7. Decisiones

## 7.1 Identidad Auth → `PlatformUser`

### Alternativas

**A. Utilizar email como vínculo de seguridad.**

Ventaja:

- sencillo.

Riesgos:

- email es mutable;
- puede introducir ambigüedad;
- convierte un atributo de contacto/login en identity key.

**B. Utilizar exclusivamente el usuario de Supabase Auth y no mantener `PlatformUser`.**

Ventaja:

- menos modelado.

Riesgos:

- mezcla proveedor de autenticación y dominio;
- dificulta auditoría y referencias de aplicación;
- contradice el modelo conceptual ya aprobado.

**C. Mantener un vínculo estable y no ambiguo desde cada Auth subject reconocido hacia `PlatformUser`.**

Ventajas:

- desacopla identidad del proveedor y autorización de aplicación;
- preserva identidad histórica;
- permite auditoría;
- evita utilizar email como autoridad;
- no obliga a decidir ahora la cardinalidad inversa.

### Decisión propuesta

**Seleccionar C.**

La regla obligatoria es:

```text
Cada Auth subject reconocido
→ exactamente un PlatformUser
```

Un Auth subject utilizado por la aplicación debe resolver inequívocamente a un único `PlatformUser`.

El Auth subject actúa como anchor estable de autenticación.

`PlatformUser` desacopla la identidad del proveedor Auth del dominio de autorización.

**Este ADR no afirma la cardinalidad inversa.**

No se decide que:

```text
PlatformUser
→ exactamente un Auth subject
```

### Impacto de seguridad

El Auth subject autentica al sujeto; no contiene por sí solo su autorización tenant.

Email no constituye identity key autoritativa.

### Impacto multiempresa

Ningún dato del token puede hacer que el usuario escoja libremente su tenant.

### Diferido

- cardinalidad inversa `PlatformUser → Auth subject(s)`;
- account linking;
- múltiples identidades Auth para un mismo `PlatformUser`;
- múltiples proveedores Auth para un mismo `PlatformUser`, si fueran necesarios;
- tablas, columnas y constraints físicos del vínculo.

---

## 7.2 Fuente autoritativa de autorización online

### Alternativas

**A. JWT-centric authorization.**

Tenant, rol, clientes y grants se obtienen principalmente del JWT.

Ventaja:

- pocas consultas.

Riesgo crítico:

- estado stale;
- revocaciones no inmediatas;
- cambios de rol/client scope tardíos.

**B. Application-only authorization.**

La aplicación comprueba permisos pero la capa de datos sólo aísla parcialmente.

Ventaja:

- lógica centralizada en TypeScript.

Riesgo:

- un bug o camino alternativo puede saltarse controles;
- contradice RLS como frontera primaria.

**C. Estado autoritativo vigente + application authorization + frontera de datos/RLS.**

El sujeto autenticado se utiliza como anchor; membership, rol, scope, grants y ownership se resuelven desde estado autoritativo vigente. Application layer decide reglas funcionales y la frontera de datos/RLS impide materializar accesos o estados prohibidos.

### Decisión propuesta

**Seleccionar C.**

El estado autoritativo online reside conceptualmente en los datos vigentes de aplicación/PostgreSQL:

- `PlatformUser`;
- `CompanyMembership`;
- rol;
- `UserClientAccess`;
- `SupportAccessGrant`;
- ownership;
- condiciones adicionales expresamente aprobadas cuando correspondan.

### Impacto de seguridad

Permite:

```text
old JWT + revoked membership
→ DENIED
```

sin esperar expiración.

También exige que una prohibición crítica como ejecución inicial de `COMPANY_ADMIN` no exista únicamente como convenience check de aplicación.

### Impacto multiempresa

Tenant y client scope siempre se reconcilian con ownership real.

---

## 7.3 Claims y custom claims

### Alternativas

**A. Codificar tenant, rol, clientes y support grants en custom claims como autoridad.**

Rechazada.

La información puede quedar stale durante el tiempo de vida del JWT.

**B. No utilizar absolutamente ningún claim aparte de tokens opacos.**

No se requiere imponer esta restricción: el proveedor necesita expresar identidad y puede incluir metadata técnica.

**C. Utilizar claims sólo cuando no sean autoridad suficiente para decisiones revocables.**

### Decisión propuesta

**Seleccionar C.**

ADR-0003 no requiere custom claims de autorización para la corrección del sistema.

El Auth subject puede actuar como anchor de identidad.

Tenant, rol, membership, client scope y `SupportAccessGrant` no pueden depender exclusivamente de claims/cache que puedan quedar obsoletos.

Una implementación futura podría utilizar claims como optimización o hint únicamente si:

1. una claim stale nunca convierte una operación denegada en permitida;
2. la decisión crítica se contrasta contra estado vigente;
3. la revocación inmediata se mantiene.

### Diferido

- lista concreta de claims;
- custom claims;
- hooks de emisión;
- mecanismo de refresh;
- caching derivado.

---

## 7.4 `session_id`

### Alternativas

**A. Convertir `session_id` en requisito central de toda autorización.**

Ventaja potencial:

- permite razonar sobre una sesión individual.

Riesgos:

- acopla autorización de datos al lifecycle del proveedor;
- no es necesario para resolver membership/client scope;
- convertiría revocación en un problema de sesión en vez de estado autoritativo.

**B. Ignorarlo por completo de forma irreversible.**

Prematuro.

**C. Excluirlo de la garantía primaria y permitir su uso futuro como defensa adicional cuando exista necesidad.**

### Decisión propuesta

**Seleccionar C.**

`session_id` no forma parte de la prueba primaria de autorización tenant.

No es necesario para conseguir:

```text
revocación autorizativa inmediata
```

Puede evaluarse posteriormente para:

- correlación de sesión;
- acciones particularmente sensibles;
- terminación provider-side;
- auditoría técnica;

siempre bajo mecanismos soportados.

### Diferido

- validación física de `session_id`;
- persistencia;
- consultas;
- semántica por dispositivo;
- revocación selectiva.

---

## 7.5 TTL de access JWT

### Alternativas

**A. TTL muy corto como mecanismo principal de revocación.**

Rechazada.

**B. TTL largo porque RLS lo resuelve todo.**

No se decide aquí.

**C. Tratar TTL como parámetro operativo independiente de la corrección de autorización.**

### Decisión propuesta

**Seleccionar C.**

ADR-0003 no fija un TTL exacto.

La corrección de autorización debe mantenerse para cualquier JWT todavía técnicamente válido:

```text
authorization result
≠
token age alone
```

Reducir TTL puede ser defense in depth, pero no sustituye el chequeo vigente.

---

## 7.6 Frontera server-side

### Alternativas

**A. Considerar segura cualquier operación porque corre en Server Action/Route Handler.**

Rechazada.

`server-side` no implica `authorized`.

**B. Hacer que todo el tráfico de datos use credenciales privilegiadas.**

Rechazada.

**C. Separar caminos normales sujetos a RLS de operaciones genuinamente privilegiadas.**

### Decisión propuesta

**Seleccionar C.**

La arquitectura distingue:

```text
Normal user path
→ authenticated user context
→ application authorization
→ RLS / data boundary
```

de:

```text
Privileged backend path
→ authenticated/validated trigger
→ reconstruct current authorization/context when user-originated
→ explicit tenant/resource binding
→ privileged operation narrowly scoped
```

Una superficie server-side genérica no puede utilizarse para saltar capacidades de negocio prohibidas.

En particular, un camino alternativo no puede permitir que `COMPANY_ADMIN` materialice una ejecución inicial o sus respuestas/evidencias.

La elección física entre:

- Server Action;
- Route Handler;
- RPC;
- otro adapter server-side permitido;

se difiere.

---

## 7.7 Backend privilegiado y `service-role`

### Alternativas

**A. Repositorios server-side ejecutados siempre con `service-role`.**

Rechazada.

**B. Nunca utilizar privilegio elevado.**

Demasiado restrictiva.

**C. Privilegio elevado sólo para capacidades que realmente no puedan ejecutarse correctamente bajo contexto normal + RLS.**

### Decisión propuesta

**Seleccionar C.**

Siempre que sea posible, una operación de usuario debe mantener contexto normal y RLS.

Si una operación user-originated atraviesa un contexto que evita RLS, el backend debe reconstruir explícitamente:

- actor;
- membership o grant;
- tenant;
- client scope;
- rol;
- operación;
- ownership;
- mutabilidad;
- demás condiciones aplicables.

`service-role` nunca convierte:

```text
authenticated
```

en:

```text
authorized
```

ni permite materializar capacidades funcionales que el actor no posee.

---

## 7.8 Modelo físico mínimo requerido para autorización vigente

### Alternativas

**A. No persistir autorización de aplicación y derivarla del JWT.**

Rechazada.

**B. Crear un sistema separado de autorización/policy engine.**

No existe necesidad demostrada.

**C. Persistir las relaciones autoritativas de dominio ya aprobadas y utilizarlas para autorización.**

### Decisión propuesta

**Seleccionar C.**

El diseño físico posterior debe representar de manera autoritativa, como mínimo:

1. resolución inequívoca de cada Auth subject reconocido hacia exactamente un `PlatformUser`;
2. `CompanyMembership` vigente con:
   - usuario;
   - tenant;
   - rol;
   - estado;
3. `UserClientAccess` vigente;
4. `SupportAccessGrant` vigente con tenant, sujeto y scopes;
5. ownership tenant/client suficiente de los recursos protegidos;
6. ownership suficiente de evidencias/documentos para reconciliarlos con el dominio;
7. auditoría requerida para soporte;
8. condiciones adicionales ya aprobadas cuando afecten una operación.

Esto no decide:

- número de tablas;
- nombres;
- columnas;
- PK/FK;
- índices;
- constraints;
- funciones;
- vistas;
- schemas.

---

## 7.9 Cache de autorización

### Alternativas

**A. Cache autoritativa con expiración eventual.**

Rechazada para revocaciones críticas.

**B. Ningún cache posible.**

No es necesario prohibir una optimización futura.

**C. Cache sólo si conserva semántica de revocación inmediata.**

### Decisión propuesta

**Seleccionar C.**

Ningún cache puede convertirse en fuente de verdad que permita:

```text
estado cacheado = permitido
estado vigente = revocado
→ ALLOW
```

---

## 7.10 Terminación provider-side

### Alternativas

**A. Terminación provider-side como garantía primaria.**

Rechazada.

**B. No intentar terminar sesiones nunca.**

Pierde defensa en profundidad cuando el proveedor sí lo permite.

**C. Ejecutar terminación provider-side como operación server-side adicional cuando exista una primitiva pública, soportada y contractualmente adecuada.**

### Decisión propuesta

**Seleccionar C.**

Debe preservarse como alcance arquitectónico:

> tratamiento provider-side de sesiones y credenciales renovables conforme a la semántica aprobada de DO-T03, exclusivamente mediante mecanismos públicos, soportados y contractualmente adecuados cuando corresponda;

Su éxito o fallo es independiente del resultado de autorización de datos.

---

# 8. Modelo conceptual de autorización

## 8.1 Identidad global

```text
Auth subject reconocido
→ exactamente un PlatformUser
```

Cada Auth subject reconocido por la aplicación debe resolver inequívocamente a un único `PlatformUser`.

Esto no fija la cardinalidad inversa.

No se afirma:

```text
PlatformUser
→ exactamente un Auth subject
```

La autenticación por sí sola no determina autorización tenant.

Email no es identity key autoritativa.

---

## 8.2 Usuario tenant

```text
PlatformUser
→ CompanyMembership vigente
→ MaintenanceCompany
→ role
```

En el MVP:

```text
PlatformUser
→ 0..1 CompanyMembership
```

Un usuario tenant no pertenece simultáneamente a múltiples `MaintenanceCompany`.

Esta cardinalidad de membership es independiente de la cardinalidad Auth identities ↔ `PlatformUser`.

---

## 8.3 Técnico

```text
PlatformUser
→ enabled CompanyMembership
→ role = TECHNICIAN
→ UserClientAccess
→ Client
```

`UserClientAccess` sólo puede unir membership y cliente del mismo tenant.

---

## 8.4 Administrador de empresa

```text
PlatformUser
→ enabled CompanyMembership
→ role = COMPANY_ADMIN
→ tenant-wide capabilities explicitly approved
```

`COMPANY_ADMIN` no necesita convertirse conceptualmente en técnico ni recibir `UserClientAccess` para ejercer capacidades tenant-wide aprobadas.

`UserClientAccess` se mantiene como mecanismo explícito de client scope de `TECHNICIAN`.

La autorización tenant-wide del administrador **no implica ejecución inicial de mantenimiento**.

---

## 8.5 Soporte excepcional

```text
PlatformUser
→ SUPER_ADMIN
→ current SupportAccessGrant
→ granting MaintenanceCompany
→ permitted client(s) when applicable
→ required scope(s)
→ explicitly allowed operation
```

Un grant no crea `CompanyMembership`.

Un grant no convierte al usuario global en `TECHNICIAN`.

Un grant no crea una operación funcional nueva.

---

## 8.6 Ownership

La autorización nunca se deriva sólo de IDs suministrados.

Para un recurso derivado:

```text
resource
→ authoritative parent chain
→ Client when applicable
→ MaintenanceCompany
```

debe ser coherente con el actor autorizado.

Para un archivo/evidencia:

```text
storage object reference
→ authoritative domain owner
→ Client / MaintenanceCompany
```

debe reconciliarse con la autorización vigente del dominio.

---

# 9. Flujo de autorización

## 9.1 Flujo general online

Para una operación iniciada por un usuario:

```text
1. autenticar Auth subject
2. resolver exactamente un PlatformUser
3. clasificar actor
4. resolver autorización vigente
5. resolver ownership real del recurso
6. resolver tenant efectivo
7. resolver client scope cuando corresponda
8. comprobar rol/capacidad de negocio
9. comprobar estado/mutabilidad aplicable
10. aplicar condiciones adicionales aprobadas cuando correspondan
11. ejecutar bajo frontera de datos/RLS o privilegio explícitamente controlado
12. permitir o denegar
```

Cualquier evidencia ausente o inconsistente produce:

```text
DENIED
```

---

## 9.2 Usuario tenant

Para `COMPANY_ADMIN` y `TECHNICIAN`, el tenant sale de la membership vigente, no del request.

Si:

```text
resource.tenant != membership.tenant
```

resultado:

```text
DENIED
```

---

## 9.3 `TECHNICIAN`

Para recurso client-scoped:

```text
enabled membership
AND TECHNICIAN
AND same tenant
AND UserClientAccess(current membership, resource client)
AND operation permitted
```

La ejecución inicial sólo puede llegar a `ALLOW` para `TECHNICIAN` dentro de clientes autorizados.

---

## 9.4 `COMPANY_ADMIN`

Para recursos tenant:

```text
enabled membership
AND COMPANY_ADMIN
AND same tenant
AND explicitly permitted operation
```

En mantenimiento:

```text
initial execution
→ DENIED

initial-execution responses
→ DENIED

initial-execution evidence
→ DENIED

authorized correction
→ potentially ALLOW

authorized conflict resolution
→ potentially ALLOW
```

La pertenencia al tenant nunca sustituye el chequeo de tipo de operación.

Este resultado debe mantenerse aunque el actor evite la UI o utilice un camino de datos/API alternativo.

---

## 9.5 `SUPER_ADMIN`

Sin grant:

```text
tenant operational resource
→ DENIED
```

Con grant:

```text
current grant
AND grant tenant == resource tenant
AND client allowed if client-scoped
AND all required scopes
AND operation expressly allowed for support
→ potentially ALLOW
```

El grant es necesario pero no crea por sí solo una capacidad funcional.

---

# 10. Multitenancy

## 10.1 Regla primaria

ADR-0003 consume íntegramente:

`ADR-0002 = ACCEPTED`.

No redefine tenancy.

```text
MaintenanceCompany = tenant
```

---

## 10.2 Tenant del actor no se confía al frontend

Inválido:

```text
request.maintenance_company_id
→ trusted tenant
```

Válido:

```text
subject
→ membership/grant
→ authorized tenant

resource
→ authoritative ownership
→ actual tenant

authorized tenant == actual tenant
```

---

## 10.3 Integridad cross-tenant

La autorización debe impedir:

- lectura/escritura de filas ajenas;
- creación de relaciones cruzadas inválidas;
- acceso a objetos Storage de otro tenant;
- construcción de URLs/paths hacia archivos ajenos.

Ejemplo:

```text
membership Tenant A
+
Client Tenant B
→ nunca puede formar UserClientAccess válido
```

---

## 10.4 Client scope no es subtenant

`Client` limita capacidad funcional de técnicos y grants de soporte, pero no cambia la frontera tenant.


---

# 11. RLS boundary

## 11.1 Responsabilidad

RLS y las fronteras equivalentes de persistencia deben impedir como mínimo:

- read cross-tenant;
- write cross-tenant;
- acceso del técnico a clientes no autorizados;
- relaciones manipuladas;
- escalamiento accidental;
- acceso tenant de `SUPER_ADMIN` sin grant;
- materialización de estados de negocio prohibidos mediante superficies directas o genéricas cuando la prohibición deba protegerse en la frontera de datos.

RLS sigue siendo la frontera primaria para datos tenant-owned.

---

## 11.2 RLS y application layer son complementarios

RLS no sustituye todas las reglas de negocio.

La application layer debe distinguir, por ejemplo:

```text
COMPANY_ADMIN
→ puede corregir
→ no puede ejecutar inicialmente
```

Pero la prohibición crítica de ejecución inicial **no puede existir exclusivamente en la UI ni exclusivamente en application authorization**.

El diseño físico posterior debe garantizar también en la frontera de datos que un camino alternativo no pueda materializar el resultado prohibido.

---

## 11.3 Resultado de seguridad obligatorio para `COMPANY_ADMIN`

Debe cumplirse conceptualmente:

```text
COMPANY_ADMIN
AND same tenant
AND initial maintenance execution
→ DENIED
```

y también:

```text
COMPANY_ADMIN
AND same tenant
AND response/evidence belonging to prohibited initial execution
→ DENIED
```

Esta garantía se aplica aunque el actor:

- invoque directamente una API;
- evite un Server Action de conveniencia;
- use una superficie de datos accesible directamente;
- use una mutación genérica;
- intente crear primero respuestas/evidencias y reconstruir indirectamente una ejecución;
- conozca IDs válidos del mismo tenant.

Una mutación genérica no puede utilizarse para adquirir indirectamente una capacidad que el rol no posee.

### Mecanismo físico

**Diferido.**

Este ADR no selecciona:

- policy concreta;
- helper SQL;
- RPC;
- trigger;
- constraint;
- función PostgreSQL;
- Route Handler;
- Server Action.

La implementación debe elegir una combinación física que demuestre el resultado anterior sin debilitar RLS ni ampliar capacidades.

---

## 11.4 Writes

La futura frontera de datos debe proteger:

1. visibilidad del estado existente;
2. validez del estado resultante;
3. legitimidad de la operación que crea ese estado.

Una fila visible no implica que cualquier `UPDATE`, `INSERT` o mutación derivada sea válida.

Tampoco debe ser posible dividir una operación prohibida en varias mutaciones aparentemente genéricas para reconstruir el mismo resultado.

---

## 11.5 Direct access / UI bypass

Una request construida manualmente debe producir el mismo resultado autorizativo que el flujo UI.

```text
UI hides button
```

nunca constituye control de seguridad.

Para operaciones prohibidas:

```text
direct API/data bypass
→ DENIED
```

---

## 11.6 Storage como parte de la frontera de autorización

Evidence y documentos tenant-owned siguen la autorización vigente del dominio al que pertenecen.

Storage no constituye una autoridad independiente ni una vía paralela de acceso.

Conocer cualquiera de los siguientes datos no concede autorización:

- bucket;
- path;
- object key;
- UUID;
- nombre físico;
- URL conocida previamente.

Debe cumplirse:

```text
known storage reference
≠
authorization
```

El ownership del archivo debe reconciliarse con ownership autoritativo del dominio:

```text
storage object
→ domain resource / evidence / document
→ Client when applicable
→ MaintenanceCompany
```

y posteriormente con:

- membership vigente;
- rol;
- `UserClientAccess`;
- `SupportAccessGrant`;
- operación permitida.

### Revocación de membership

```text
membership revoked
+
known URL/path/object key
→ new online access DENIED
```

### Revocación de client scope

```text
UserClientAccess revoked
+
known evidence/document URL
→ new online access DENIED
```

para objetos client-scoped del cliente revocado.

### Revocación de soporte

```text
SupportAccessGrant revoked
+
known file URL/path
→ new online access DENIED
```

Storage no puede convertirse en bypass de:

- tenant;
- client scope;
- rol;
- grant;
- revocación.

### Diferido

Este ADR no decide:

- buckets concretos;
- paths;
- naming;
- signed URL strategy;
- duración/expiración de URLs;
- Storage policies físicas;
- SQL;
- funciones;
- RLS ejecutable.

---

## 11.7 Helpers y policies

ADR-0003 define qué deben demostrar las policies y fronteras equivalentes, pero no:

- `CREATE POLICY`;
- nombres de helper functions;
- joins concretos;
- `EXISTS`;
- schemas;
- `SECURITY DEFINER`;
- índices;
- Storage policies físicas.

Eso pertenece a la especificación física posterior.

---

# 12. Roles y client scope

## 12.1 `COMPANY_ADMIN`

Autoridad:

- exactamente un tenant;
- capacidades administrativas aprobadas;
- gestión de `UserClientAccess`;
- mantenimiento sólo según capacidades específicas ya aprobadas.

No recibe ejecución inicial.

No puede materializarla indirectamente mediante:

- respuestas;
- evidencias;
- mutaciones genéricas;
- bypass de UI/API;
- acceso directo a persistencia.

---

## 12.2 `TECHNICIAN`

Autoridad:

- exactamente un tenant;
- cero o más clientes autorizados;
- acceso operativo derivado por cliente.

Un cliente autorizado incluye operativamente:

- cliente;
- ubicaciones;
- equipos;
- información de tipos necesaria;
- formularios aplicables necesarios;
- mantenimientos;
- revisiones;
- respuestas;
- evidencias;
- conflictos correspondientes.

No existen permisos adicionales por:

- Location;
- Equipment;
- MaintenanceRecord;
- MaintenanceRevision.

---

## 12.3 Cambio de rol

Un cambio de rol es autoritativo inmediatamente.

Ejemplo:

```text
TECHNICIAN → COMPANY_ADMIN
```

no significa combinar las capacidades históricas de ambos roles.

Después del cambio:

```text
authorization = capabilities of current role
```

No existe acumulación automática.

---

## 12.4 Reducción de client scope

Al revocar `UserClientAccess`:

```text
stale JWT
+
old UI state
+
old loaded client data
+
known storage reference
```

no autorizan una nueva operación online ni un nuevo acceso online a evidencias/documentos de ese cliente.

---

## 12.5 Autoescalamiento

`TECHNICIAN` no puede:

- cambiar su membership;
- cambiar su rol;
- crear/modificar sus propios `UserClientAccess`;
- usar un ID permitido como puente hacia otro cliente.

---

# 13. `SupportAccessGrant`

## 13.1 Naturaleza

`SupportAccessGrant` es una capacidad excepcional separada del acceso tenant normal.

Pertenece al tenant concedente y su sujeto es un `SUPER_ADMIN` global.

---

## 13.2 Scopes client-scoped aprobados

- información del cliente;
- ubicaciones;
- equipos;
- mantenimientos;
- formularios/respuestas;
- evidencias;
- informes.

---

## 13.3 Scopes tenant-wide aprobados

- usuarios/permisos;
- suscripción/pagos;
- créditos IA.

Un scope tenant-wide no implica acceso general a recursos client-scoped.

---

## 13.4 Composición

Una operación que requiere varias clases de acceso debe satisfacer todos los scopes relevantes.

Ejemplo:

```text
scope mantenimiento
```

no implica:

```text
scope evidencia
```

aunque se conozca el ID de la evidencia.

---

## 13.5 Semántica de capacidad

Un scope define un **máximo de acceso excepcional**, no una nueva matriz de operaciones.

Por tanto:

```text
grant + scope
```

no equivale a:

```text
CRUD general
```

ni crea ejecución inicial de mantenimiento.

Un `SupportAccessGrant` con maintenance scope:

- no convierte a `SUPER_ADMIN` en `TECHNICIAN`;
- no crea `CompanyMembership`;
- no otorga por inferencia ejecución inicial;
- no crea escrituras no aprobadas.

---

## 13.6 Vigencia

Un grant debe estar vigente.

Este ADR no inventa:

- expiración obligatoria;
- duración máxima;
- TTL de grant.

---

## 13.7 Auditoría

Son obligatoriamente auditables:

- concesión;
- modificación;
- revocación;
- uso efectivo del acceso de soporte.

El acceso efectivo debe poder atribuir al menos:

- actor;
- tenant;
- cliente cuando corresponda;
- scope;
- recurso/alcance suficiente;
- momento.

---

## 13.8 Revocación

Un grant revocado:

```text
+ residual SUPER_ADMIN Auth session
+ known resource/storage reference
→ DENIED
```

para nuevas operaciones o nuevos accesos online cubiertos por el grant revocado.

---

# 14. Revocación y sesiones

## 14.1 Regla primaria

`DO-T03 = RESUELTO/APROBADO` se consume sin reinterpretación.

Una revocación puede afectar:

- membership;
- rol;
- `UserClientAccess`;
- `SupportAccessGrant`;
- cualquier otra autorización vigente.

El efecto autorizativo online debe ser inmediato.

---

## 14.2 Sesión residual

Puede existir:

```text
Auth session = technically valid
access JWT = technically valid
authorization = DENIED
```

---

## 14.3 Membership deshabilitada

```text
membership disabled
+
stale JWT
→ DENIED
```

para:

- datos;
- APIs;
- nuevos accesos online a Storage tenant-owned.

La identidad e historial permanecen.

---

## 14.4 Reducción de rol

```text
old role in stale state
+
current role with fewer privileges
→ current role wins
```

---

## 14.5 Client access revocado

```text
UserClientAccess revoked
+
old client loaded in PWA
+
technically valid JWT
+
known object URL
→ new online operation/access DENIED
```

---

## 14.6 Grant revocado

```text
SupportAccessGrant revoked
+
residual SUPER_ADMIN Auth
+
known resource/file reference
→ DENIED
```

---

## 14.7 Fail-closed

Si el sistema no puede demostrar el estado vigente necesario para una operación sensible, debe denegarla.

No se permite:

```text
cannot verify authorization
→ trust old claim/session/URL
```

---

# 15. Provider-side session termination

## 15.1 Responsabilidad

La terminación de sesiones/credenciales renovables es una defensa independiente, adicional a la autorización de datos.

Objetivos posibles:

- reducir sesiones residuales;
- alinear UX con revocación;
- reducir exposición de credenciales renovables;
- cerrar autenticación cuando exista mecanismo soportado.

---

## 15.2 Frontera de implementación

Esta capacidad debe estar exclusivamente server-side.

El cliente no:

- almacena JWT de terceros;
- recibe credenciales administrativas;
- manipula directamente sesiones de otros usuarios.

---

## 15.3 Resultado independiente

La secuencia correcta es:

```text
1. commit authoritative revocation
2. authorization becomes DENIED
3. attempt supported provider-side termination when applicable
4. success or failure does not alter step 2
```

No:

```text
attempt provider logout
→ if success then revoke
→ if failure keep access
```

---

## 15.4 Primitiva concreta

**Diferida.**

Este ADR no selecciona:

- API Supabase concreta;
- `updateUserById(...password...)`;
- `ban_duration`;
- acceso a `auth.sessions`;
- procedimiento basado en JWT ajenos;
- API no documentada.

Si no existe una primitiva pública, soportada y contractualmente adecuada:

```text
authorization remains revoked
provider-side termination = unavailable for that case
```

---

## 15.5 `session_id`

No se requiere para la corrección de autorización.

Puede analizarse posteriormente como defensa adicional o para acciones sensibles, sin convertirlo en condición primaria de acceso tenant.

---

# 16. Offline boundary

## 16.1 No resuelve ADR-0004

Este ADR no diseña:

- IndexedDB/Dexie;
- `LocalReplica`;
- cifrado;
- purge;
- logout local;
- outbox física;
- apertura/cierre de réplica;
- destino del trabajo pendiente tras revocación.

---

## 16.2 Contrato que ADR-0003 expone al futuro offline

Para que un flujo esté autorizado a operar offline, ADR-0004 deberá poder representar semánticamente una autorización online previamente validada suficiente para conocer, según el flujo:

- identidad;
- tenant autorizado;
- membership validada;
- rol validado;
- client scope validado;
- instante/edad de la última validación;
- demás condiciones online exigidas por la baseline.

Esto define información semánticamente necesaria, no payload, token o schema concreto.

---

## 16.3 DO-075

Se mantiene íntegramente:

- máximo 7 días desde la última validación online;
- vencido ese período no pueden iniciarse nuevas operaciones sin revalidación;
- revocación conocida prevalece al recuperar conectividad;
- trabajo ya capturado no se elimina.

---

## 16.4 Reconnect

Al recuperar conectividad deben revalidarse las condiciones vigentes necesarias antes de asumir que una operación pendiente continúa autorizada.

---

## 16.5 Trabajo pendiente

ADR-0003 sólo establece:

```text
revoked authorization
≠
delete captured local work
```

No decide qué destino remoto/local recibe ese trabajo.

Eso permanece en:

- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- ADR-0004.

---

## 16.6 Relación con ADR-0005

La autorización de una operación sincronizable y su idempotencia son problemas distintos.

Una intención reintentable conserva identidad, pero la idempotencia no conserva autorización revocada.

---

# 17. Alternativas consideradas

## 17.1 Autorización centrada exclusivamente en JWT

**Resultado:** rechazada.

Riesgos:

- role stale;
- membership stale;
- client scope stale;
- grant stale;
- imposibilidad de garantizar revocación inmediata.

---

## 17.2 Autorización sólo en application layer

**Resultado:** rechazada.

Especialmente insuficiente para prohibiciones que deben resistir:

- bypass de UI;
- API alternativa;
- superficie genérica de datos;
- acceso directo permitido por una frontera demasiado amplia.

---

## 17.3 RLS genérica sólo por tenant

**Resultado:** rechazada como solución completa.

```text
same tenant
→ allow
```

es insuficiente porque existen:

- roles;
- client scope;
- grants;
- restricciones funcionales;
- estados que ciertos actores no pueden materializar.

Permitiría inferir ejecución inicial para `COMPANY_ADMIN`.

---

## 17.4 Sistema externo de policy engine

**Resultado:** no seleccionado para MVP.

No existe necesidad demostrada.

---

## 17.5 Todos los accesos mediante backend privilegiado

**Resultado:** rechazado.

Riesgos:

- RLS pierde valor;
- blast radius cross-tenant;
- bypass de restricciones funcionales.

---

## 17.6 `SUPER_ADMIN` bypass universal

**Resultado:** rechazado.

---

## 17.7 Access token muy corto como revocación

**Resultado:** rechazado como garantía primaria.

---

## 17.8 Session registry obligatorio para toda operación

**Resultado:** no seleccionado.

---

## 17.9 Storage tratado como autorización independiente

**Resultado:** rechazado.

Conocer path, bucket, object key o URL nunca puede sustituir la autorización vigente del dominio.

---

## 17.10 Arquitectura seleccionada

Se selecciona:

> **Auth para autenticar al sujeto + resolución inequívoca de cada Auth subject reconocido hacia un PlatformUser + estado autoritativo vigente para membership/rol/client scope/grants + ownership autoritativo + application authorization para reglas funcionales + frontera de datos/RLS suficientemente fuerte para impedir bypass de prohibiciones críticas + Storage subordinado a la autorización del dominio + backend privilegiado mínimo + provider-side termination como defensa adicional.**

---

# 18. Consecuencias

## 18.1 Positivas

- revocación online inmediata;
- seguridad correcta con JWT stale;
- tenant isolation consistente;
- client scope explícito;
- soporte sin bypass universal;
- roles sin acumulación accidental;
- `COMPANY_ADMIN` no puede adquirir ejecución inicial por rutas alternativas;
- Storage no crea un canal paralelo de acceso;
- RLS conserva valor ante bugs de aplicación;
- backend privilegiado tiene límites definidos;
- desacoplamiento de Auth provider y autorización;
- no se cierra innecesariamente la cardinalidad inversa Auth/PlatformUser;
- ADR-0004 recibe una frontera online clara.

---

## 18.2 Negativas

- RLS/frontera de datos futura será más compleja que un chequeo tenant;
- habrá que modelar correctamente qué estados puede materializar cada clase de actor;
- membership/client scope/grants necesitarán consultas eficientes;
- Storage deberá reconciliarse con ownership del dominio;
- tests negativos serán una parte considerable de la suite;
- operaciones privilegiadas requieren revisión rigurosa;
- performance deberá medirse sin debilitar revocación.

---

## 18.3 Trade-off aceptado

Se acepta mayor complejidad de autorización a cambio de:

```text
correctness
+ tenant isolation
+ role integrity
+ immediate revocation
+ bypass resistance
```

---

# 19. Riesgos

## 19.1 `AUTH-RSK-001` — Claims stale usados como autoridad

**Mitigación:** estado vigente prevalece.

## 19.2 `AUTH-RSK-002` — Cache stale

**Mitigación:** cache nunca puede producir ALLOW contra estado autoritativo DENIED.

## 19.3 `AUTH-RSK-003` — RLS demasiado genérica

**Riesgo:** mismo tenant se interpreta como permiso completo.

**Mitigación:** frontera futura debe representar client scope, grants y restricciones críticas de materialización.

## 19.4 `AUTH-RSK-004` — Business permissions sólo en UI/application convenience path

**Riesgo:** request directa permite capacidad prohibida.

**Mitigación:** enforcement server-side + frontera de datos + pruebas específicas de bypass.

## 19.5 `AUTH-RSK-005` — `service-role` como bypass

**Mitigación:** privilegio excepcional y reconstrucción explícita de contexto.

## 19.6 `AUTH-RSK-006` — Scope composition incorrecta

**Mitigación:** scopes explícitos y composición acumulativa cuando corresponda.

## 19.7 `AUTH-RSK-007` — Inferir escrituras de soporte

**Mitigación:** grant nunca crea operaciones no aprobadas.

## 19.8 `AUTH-RSK-008` — Manipulación cross-tenant

**Mitigación:** ownership autoritativo + integridad cross-tenant + RLS.

## 19.9 `AUTH-RSK-009` — Provider termination falla

**Mitigación:** autorización ya está denegada.

## 19.10 `AUTH-RSK-010` — Sobreacoplar autorización a `session_id`

**Mitigación:** `session_id` fuera de la prueba primaria.

## 19.11 `AUTH-RSK-011` — Offline conserva autorización antigua

**Mitigación:** DO-075 + revalidación + revocación conocida.

## 19.12 `AUTH-RSK-012` — Performance lleva a debilitar seguridad

**Mitigación:** optimizar después de medir; no cambiar invariantes.

## 19.13 `AUTH-RSK-013` — `COMPANY_ADMIN` materializa ejecución inicial indirectamente

**Riesgo:** una API o mutación genérica permite crear MaintenanceRecord/respuestas/evidencias equivalentes a una ejecución inicial prohibida.

**Mitigación:** resultado de seguridad obligatorio en frontera de datos, independientemente del mecanismo físico.

## 19.14 `AUTH-RSK-014` — Storage como bypass

**Riesgo:** un actor conserva acceso mediante URL/path conocido después de revocación o accede a otro tenant/client.

**Mitigación:** Storage subordinado a ownership y autorización vigente del dominio.

## 19.15 `AUTH-RSK-015` — Cardinalidad Auth/PlatformUser cerrada prematuramente

**Riesgo:** impedir account linking o futuros proveedores sin necesidad de producto.

**Mitigación:** decidir sólo Auth subject reconocido → exactamente un `PlatformUser`; cardinalidad inversa diferida.


---

# 20. Requisitos para implementación posterior

## 20.1 Modelo físico

Debe definir:

- representación de Auth subject → `PlatformUser`;
- garantía de resolución inequívoca de cada Auth subject reconocido;
- `CompanyMembership`;
- rol;
- estado de membership;
- `UserClientAccess`;
- `SupportAccessGrant`;
- ownership tenant;
- ownership client;
- ownership de Evidence/documentos;
- auditoría necesaria;
- constraints de integridad.

No debe asumir por este ADR cardinalidad inversa `PlatformUser → un Auth subject`.

---

## 20.2 RLS y frontera de datos

Debe especificar, por recurso:

- SELECT;
- INSERT;
- UPDATE;
- DELETE cuando aplique;
- ownership requerido;
- membership requerida;
- role constraints;
- client scope;
- support grant;
- validación de relaciones;
- reglas de inmutabilidad;
- restricciones necesarias para evitar materialización indirecta de operaciones prohibidas.

Debe demostrar específicamente que `COMPANY_ADMIN` no puede materializar ejecución inicial, respuestas o evidencias de esa ejecución por ninguna superficie autorizada.

Este ADR no decide qué combinación de:

- policy;
- constraint;
- trigger;
- RPC;
- helper;
- endpoint;
- transacción;

cumple esa obligación.

---

## 20.3 Storage

La especificación física posterior debe definir cómo Evidence/documentos tenant-owned:

- se vinculan inequívocamente con ownership del dominio;
- heredan tenant/client scope;
- respetan revocaciones vigentes;
- impiden acceso por conocimiento de path/URL.

Debe definir posteriormente, sin que este ADR lo seleccione:

- buckets;
- paths;
- policies;
- signed URLs;
- expiraciones;
- naming.

---

## 20.4 Application authorization

Debe existir una frontera modular clara para reglas que no deben reducirse a visibilidad de filas, incluyendo:

- ejecución inicial vs corrección;
- resolución de conflicto;
- mutabilidad;
- soporte excepcional;
- operaciones comerciales cuando correspondan.

La application authorization es necesaria pero no suficiente para proteger por sí sola la prohibición de ejecución inicial de `COMPANY_ADMIN`.

---

## 20.5 Backend privilegiado

Antes de implementar debe inventariarse cada caso que necesite privilegio elevado y justificar:

- por qué contexto normal + RLS no basta;
- qué actor/origen lo inicia;
- qué tenant/resource afecta;
- qué comprobaciones reconstruye;
- qué auditoría genera;
- por qué no abre una vía para materializar capacidades prohibidas.

---

## 20.6 Provider-side termination

La tarea posterior deberá:

1. verificar la capacidad pública y soportada disponible;
2. documentar su contrato;
3. decidir si cubre el caso;
4. diseñar integración server-side;
5. probar su fallo independientemente.

Si no existe mecanismo contractualmente adecuado, no se inventará uno.

---

## 20.7 Claims

Si se proponen custom claims deberá demostrarse:

- qué problema resuelven;
- por qué no son autoridad stale;
- qué ocurre durante revocación;
- cómo las pruebas negativas siguen pasando.

---

## 20.8 Performance

La implementación debe estudiar:

- índices;
- ownership chains;
- membership/client checks;
- scope composition;
- helpers RLS;
- Storage authorization;
- observabilidad segura.

No debe introducir cache autoritativa eventual.

---

## 20.9 TypeScript y módulo

La aplicación debe mantener TypeScript estricto y frontera modular acorde con `ADR-0001`.

---

# 21. Estrategia de pruebas

Las pruebas negativas son requisitos de primera clase.

## 21.1 Membership revocada

```text
GIVEN authenticated subject with stale access JWT
AND CompanyMembership is now disabled/revoked

WHEN accessing tenant-owned data

THEN DENIED
```

Debe cubrir:

- read;
- insert;
- update;
- operaciones server-side user-originated;
- nuevos accesos online a Evidence/documentos.

---

## 21.2 Client scope revocado

```text
GIVEN TECHNICIAN with stale JWT
AND UserClientAccess(Client A) was revoked

WHEN accessing Client A resource

THEN DENIED
```

---

## 21.3 Rol reducido/cambiado

```text
GIVEN residual Auth state containing prior assumptions
AND current role no longer grants operation

WHEN executing removed capability

THEN DENIED
```

---

## 21.4 Support grant revocado

```text
GIVEN SUPER_ADMIN with residual Auth session
AND SupportAccessGrant revoked

WHEN accessing tenant resource through former grant

THEN DENIED
```

---

## 21.5 UI bypass general

```text
GIVEN UI does not expose an operation

WHEN caller constructs request manually

THEN result is determined exclusively by current authorization
```

Una operación no autorizada:

```text
→ DENIED
```

---

## 21.6 Provider termination failure

```text
GIVEN authoritative revocation committed
AND provider-side session termination is unavailable or fails
AND residual session/JWT remains technically usable for authentication

WHEN affected data operation is attempted

THEN DENIED
```

---

## 21.7 Cross-tenant

```text
GIVEN actor Tenant A
WHEN resource or parent belongs Tenant B
THEN DENIED
```

Debe cubrir:

- direct read;
- direct write;
- forged client_id;
- forged equipment_id;
- parent relationship cross-tenant;
- creation of cross-tenant relation;
- Storage object belonging Tenant B.

---

## 21.8 `COMPANY_ADMIN` initial maintenance — flujo normal

```text
GIVEN COMPANY_ADMIN
AND same tenant

WHEN attempting initial maintenance execution

THEN DENIED
```

Debe verificarse aunque el administrador pueda leer ese contexto.

---

## 21.9 `COMPANY_ADMIN` initial maintenance — bypass directo

```text
GIVEN COMPANY_ADMIN
AND same tenant

WHEN bypassing UI/application convenience paths
AND attempting to materialize an initial maintenance execution
OR responses/evidence belonging to that prohibited initial execution

THEN DENIED
```

Debe cubrir conceptualmente:

- API directa;
- mutación genérica;
- superficie de datos alternativa;
- creación directa de respuestas;
- creación directa de evidencias;
- composición de varias mutaciones para obtener indirectamente el mismo resultado.

No requiere SQL en este ADR.

---

## 21.10 `TECHNICIAN` authorized maintenance

```text
GIVEN enabled TECHNICIAN membership
AND UserClientAccess to Client A
AND Equipment belongs Client A

WHEN performing approved initial maintenance operation

THEN potentially ALLOWED
```

Con Client B no autorizado:

```text
DENIED
```

---

## 21.11 `SUPER_ADMIN` — scopes de aislamiento

Probar como mínimo:

```text
grant Tenant A
→ Tenant B DENIED
```

```text
grant Client A1
→ Client A2 DENIED
```

```text
scope informes
→ equipos DENIED
```

```text
scope créditos IA tenant-wide
→ mantenimiento DENIED
```

---

## 21.12 `SupportAccessGrant` no crea ejecución inicial

```text
GIVEN SUPER_ADMIN
AND current SupportAccessGrant with maintenance scope

WHEN attempting initial maintenance execution

THEN DENIED
```

Razón:

```text
grant + maintenance scope
≠
TECHNICIAN role
```

y:

```text
grant + scope
≠
new functional capability
```

---

## 21.13 `SupportAccessGrant` no equivale a CRUD general

```text
GIVEN SupportAccessGrant permits visibility/access to a section or resource
AND no write/mutation operation for support is expressly approved

WHEN attempting that mutation

THEN DENIED
```

El grant define un máximo de acceso excepcional.

No crea escritura por inferencia.

---

## 21.14 Storage — membership revocada con URL conocida

```text
GIVEN user previously knew a valid evidence/document URL or path
AND CompanyMembership is now revoked
AND Auth session/JWT may remain technically valid

WHEN requesting new online access to that object

THEN DENIED
```

---

## 21.15 Storage — client scope revocado con URL conocida

```text
GIVEN TECHNICIAN previously knew the URL/path/object key of evidence in Client A
AND UserClientAccess(Client A) is now revoked

WHEN requesting that object online

THEN DENIED
```

---

## 21.16 Storage — SupportAccessGrant revocado

```text
GIVEN SUPER_ADMIN previously accessed a tenant file through a valid SupportAccessGrant
AND the grant is now revoked
AND the previous URL/path is still known

WHEN requesting new online access

THEN DENIED
```

---

## 21.17 Storage — cross-tenant

```text
GIVEN actor authorized for Tenant A
AND known object reference belongs to Tenant B

WHEN requesting the object

THEN DENIED
```

---

## 21.18 Claims stale

Si existen claims de optimización:

```text
claim says allowed
authoritative current state says denied
→ DENIED
```

---

## 21.19 Privileged path

Cada operación user-originated que pueda evitar RLS debe demostrar los mismos límites de:

- actor;
- tenant;
- client;
- role;
- scope;
- operación;

que el camino normal.

---

# 22. Decisiones diferidas

## 22.1 Persistencia

- tablas;
- columnas;
- PK/FK;
- índices;
- constraints;
- PostgreSQL schema;
- nombres físicos.

## 22.2 RLS física

- `CREATE POLICY`;
- helper functions;
- `SECURITY DEFINER`;
- joins;
- predicates SQL;
- funciones PostgreSQL;
- estrategia concreta por tabla;
- trigger/constraint/RPC concreto para restricciones de materialización.

## 22.3 Identidad Auth

Se difieren expresamente:

- cardinalidad inversa `PlatformUser → Auth subject(s)`;
- account linking;
- múltiples Auth identities para un mismo `PlatformUser`;
- múltiples proveedores Auth para un mismo `PlatformUser`, si alguna vez fueran necesarios;
- mecanismo físico de linking.

La única regla cerrada aquí es:

```text
cada Auth subject reconocido
→ exactamente un PlatformUser
```

## 22.4 Claims

- lista exacta de JWT claims;
- custom claims;
- Auth hooks;
- metadata física.

## 22.5 Sesiones

- TTL exacto;
- validación física de `session_id`;
- session registry;
- revocación por dispositivo;
- mecanismo provider-side concreto.

## 22.6 Next.js

- Server Action vs Route Handler por caso;
- endpoints;
- URLs;
- payloads;
- status codes;
- middleware específico.

## 22.7 Backend

- estructura exacta de módulos;
- repository pattern;
- RPC;
- Edge Functions;
- Supabase Functions.

## 22.8 Storage

- buckets;
- paths;
- object naming;
- signed URL strategy;
- expiraciones;
- Storage policies físicas;
- helpers;
- SQL.

## 22.9 Offline

- Dexie schema;
- cifrado;
- purga;
- logout;
- destino de trabajo pendiente tras revocación;
- `DO-T04`;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`.

## 22.10 Provider

- primitiva Supabase concreta de session termination.

Estas decisiones pueden concretarse posteriormente siempre que no cambien las garantías de este ADR.

---

# 23. Relación con otros ADR

## 23.1 `ADR-0001`

ADR-0003 debe implementarse dentro del monolito modular aprobado.

No introduce microservicios.

---

## 23.2 `ADR-0002 = ACCEPTED`

ADR-0003 consume:

- `MaintenanceCompany` como tenant;
- shared PostgreSQL;
- ownership inequívoco;
- tenant resolution autoritativa;
- RLS obligatoria;
- integridad cross-tenant;
- `service-role` restringido.

ADR-0003 no contradice ni sustituye ADR-0002.

---

## 23.3 `ADR-0004`

ADR-0003 condiciona ADR-0004 respecto de:

- identidad;
- membership;
- rol;
- client scope;
- revocación;
- contrato de revalidación.

No resuelve:

- réplica;
- aislamiento local físico;
- logout;
- purge;
- protección local;
- decisiones OFF-OPEN.

---

## 23.4 `ADR-0005 = ACCEPTED`

ADR-0005 define convergencia, no autorización.

```text
same idempotency key
≠
automatic authorization
```

Antes de aceptar una mutación remota siguen aplicándose las reglas de autorización vigentes.

---

## 23.5 Storage y evidencias

ADR-0003 consume la regla de que Evidence/documentos tenant-owned deben permanecer sujetos a tenant isolation y autorización vigente.

No decide la topología física de Storage ni sus policies.

---

## 23.6 ADR de dominio posteriores

Las decisiones de Form Engine, Maintenance, Evidence, Reporting, IA, créditos y pagos pueden agregar reglas funcionales, pero no pueden:

- redefinir tenant;
- saltar membership;
- saltar client scope;
- crear bypass `SUPER_ADMIN`;
- debilitar revocación;
- eludir la frontera de datos;
- convertir Storage en un bypass.

---

## 23.7 Candidatos consolidados

ADR-0003 consolida:

- identidad/membership/client access;
- acceso excepcional de `SUPER_ADMIN`;
- `Identity + membership + client access`;
- `SupportAccessGrant`;
- invalidación efectiva de sesiones;
- frontera conceptual para datos y Storage derivados de autorización.

---

# 24. Gate posterior

## 24.1 Resultado de la aprobación formal

- **ADR:** `ADR-0003`
- **Título:** `Autorización, client scope y soporte excepcional`
- **Status:** `ACCEPTED`
- **ADR-0003 ACCEPTED:** `SÍ`
- **DO-T03:** `RESUELTO/APROBADO`
- **Tenant:** `MaintenanceCompany`
- **Autenticación = autorización:** `NO`
- **Auth subject reconocido → exactamente un PlatformUser:** `SÍ`
- **Cardinalidad inversa PlatformUser → Auth subject:** `DIFERIDA`
- **Email como identity key autoritativa:** `NO`
- **Membership vigente autoritativa:** `SÍ`
- **Rol vigente autoritativo:** `SÍ`
- **UserClientAccess vigente autoritativo:** `SÍ`
- **SupportAccessGrant vigente autoritativo:** `SÍ`
- **RLS frontera primaria:** `SÍ`
- **Storage subordinado a autorización vigente del dominio:** `SÍ`
- **TECHNICIAN ejecución inicial:** sólo clientes autorizados
- **COMPANY_ADMIN ejecución inicial:** `DENIED`
- **COMPANY_ADMIN ejecución inicial por bypass:** `DENIED`
- **COMPANY_ADMIN respuestas/evidencias de ejecución inicial prohibida:** `DENIED`
- **SUPER_ADMIN bypass normal:** `NO`
- **SupportAccessGrant crea membership:** `NO`
- **SupportAccessGrant crea capacidades nuevas:** `NO`
- **SupportAccessGrant = CRUD general:** `NO`
- **Claims de autorización como autoridad única:** `NO`
- **session_id requerido para autorización primaria:** `NO`
- **TTL como garantía de revocación:** `NO`
- **Provider-side termination:** defense in depth
- **Mecanismo provider-side concreto seleccionado:** `NO`
- **Buckets/paths/signed URL strategy seleccionados:** `NO`
- **SQL:** `NO`
- **Migrations:** `NO`
- **Policies RLS ejecutables:** `NO`
- **Auth implementada:** `NO`
- **ADR-0004 resuelto:** `NO`
- **DO-075 modificada:** `NO`
- **DO-T04 resuelta:** `NO`
- **OFF-OPEN-001 resuelta:** `NO`
- **OFF-OPEN-002 resuelta:** `NO`
- **Implementación autorizada por este ADR:** `NO`
- **Gate de Fase 2 evaluado:** `NO`
- **Gate de Fase 2 satisfecho:** `NO`
- **Fase 2 iniciada:** `NO`

## 24.2 Secuencia posterior

La aprobación arquitectónica de ADR-0003 ha sido completada:

`ADR-0003 = ACCEPTED`

Esto satisface exclusivamente el requisito arquitectónico de contar con ADR-0003 aceptado.

No significa automáticamente:

`Gate de entrada a Fase 2 satisfecho = SÍ`

El Gate de entrada a Fase 2 debe evaluarse mediante un acto separado.

Por tanto, después de esta aprobación debe permanecer:

`Gate de entrada a Fase 2 evaluado = NO`

`Gate de entrada a Fase 2 satisfecho = NO`

`Fase 2 = NO INICIADA`

Este ADR no evalúa si existen otras precondiciones documentales, técnicas u operativas para cruzar el Gate.

La aprobación del ADR no constituye autorización directa de implementación.

---

**Supersedes:** `None`

**Superseded by:** `None`

---

# Correcciones incorporadas

1. **Frontera de datos reforzada para `COMPANY_ADMIN`:** la prohibición de ejecución inicial, incluidas respuestas/evidencias asociadas, debe resistir bypass de UI, API, mutaciones genéricas y caminos alternativos sin fijar todavía el mecanismo físico.

2. **Storage incorporado explícitamente a la frontera de autorización:** Evidence/documentos siguen ownership y autorización vigente del dominio; bucket/path/object key/UUID/URL conocidos no conceden acceso y las revocaciones retiran nuevos accesos online.

3. **Auth subject → exactamente un `PlatformUser`:** cada Auth subject reconocido debe resolver inequívocamente a un único `PlatformUser`; cardinalidad inversa, account linking y múltiples identidades/proveedores quedan diferidos.

4. **Pruebas negativas de `SupportAccessGrant` ampliadas:** maintenance scope no crea ejecución inicial y un grant que permite visibilidad/acceso no concede mutaciones no aprobadas ni CRUD general.

---

`ADR-0003 = ACCEPTED`

`ADR-0003 ACCEPTED = SÍ`

`DO-T03 = RESUELTO/APROBADO`

`Implementación autorizada por este ADR = NO`

`Gate de entrada a Fase 2 evaluado = NO`

`Gate de entrada a Fase 2 satisfecho = NO`

`Fase 2 = NO INICIADA`
