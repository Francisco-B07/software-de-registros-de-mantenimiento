# ADR-0002 — Multi-tenancy, tenant ownership y aislamiento

> **Ruta normativa:** `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`  
> **Fase:** Fase 0 — Architecture Decision Record  
> Estado de Fase 0: EN CURSO  
> **Naturaleza:** decisión arquitectónica transversal de multi-tenancy, ownership e aislamiento remoto; **NO constituye implementación, diseño físico de datos, SQL, políticas RLS ejecutables ni autorización funcional completa**

**ID: ADR-0002**  
**Title: Multi-tenancy, tenant ownership y aislamiento**  
**Status: ACCEPTED**

---

# 1. ID

`ADR-0002`

# 2. Título

`Multi-tenancy, tenant ownership y aislamiento`

# 3. Status

`ACCEPTED`

Este ADR ha sido aprobado formalmente como decisión arquitectónica de multi-tenancy, tenant ownership y aislamiento remoto para el MVP.

El estado `ACCEPTED` aprueba:

- `MaintenanceCompany` como tenant;
- una base Supabase PostgreSQL compartida entre tenants para el MVP;
- ownership tenant inequívoco para todos los recursos tenant-owned;
- tenant resolution autoritativa;
- RLS obligatoria como frontera primaria de aislamiento remoto;
- integridad cross-tenant;
- uso restringido de `service-role`;
- Supabase Storage sujeto a ownership del dominio;
- Realtime sin ampliación de permisos.

El estado `ACCEPTED` **NO**:

- define tablas;
- define columnas;
- define foreign keys;
- define índices;
- define SQL;
- define policies RLS ejecutables;
- define JWT claims ni custom claims;
- define schemas PostgreSQL;
- define buckets de Storage;
- define Storage paths;
- define estrategia de signed URLs;
- define channels/topics Realtime;
- define casos de uso definitivos de `service-role`;
- define la autorización funcional completa;
- resuelve `ADR-0003`;
- define invalidación de sesiones;
- define la mecánica de `SupportAccessGrant`;
- define IndexedDB/Dexie;
- define sincronización;
- resuelve decisiones `DO-*` o `*-OPEN-*`;
- autoriza implementación;
- autoriza Codex;
- inicia Fase 1;
- cierra Fase 0.

---

# 4. Context

El producto es un SaaS B2B multiempresa para compañías que prestan servicios de mantenimiento técnico.

La baseline normativa establece que cada `MaintenanceCompany` constituye un tenant completamente aislado. Los clientes industriales administrados por esa empresa no son tenants ni usuarios SaaS del MVP. `SUPER_ADMIN` es una identidad global de plataforma que no pertenece a tenants, mientras que `COMPANY_ADMIN` y `TECHNICIAN` pertenecen exactamente a una `MaintenanceCompany`.

Supabase PostgreSQL es la source of truth remota del producto y Row Level Security es obligatoria como frontera primaria de aislamiento remoto. El navegador, la PWA, el middleware, los filtros visuales y otros controles de aplicación pueden mejorar UX y defensa en profundidad, pero no constituyen por sí solos una frontera de seguridad suficiente.

`ADR-0001` está `ACCEPTED` y adopta un monolito modular en un único proyecto Next.js, con un deployable principal inicial y una base PostgreSQL compartida como infraestructura central de datos. Esa decisión evita microservicios, bases separadas por módulo y distribución prematura sin eliminar las fronteras internas de dominio o de seguridad.

Para multi-tenancy aparece, por tanto, una necesidad transversal: varios tenants compartirán inicialmente la misma infraestructura física, pero sus datos y operaciones deben conservar ownership inequívoco, autorización autoritativa e integridad cross-tenant en todos los bounded contexts relevantes.

La amenaza no se limita a leer datos ajenos. Un aislamiento correcto también debe impedir que una request manipulada cree relaciones entre recursos de tenants diferentes, consuma recursos económicos de otro tenant, produzca documentos mezclando información ajena o utilice archivos de Storage fuera del ownership autorizado.

Además, Supabase introduce capacidades con fronteras de privilegio distintas —PostgreSQL/RLS, Storage, Realtime y credenciales privilegiadas como `service-role`— que deben obedecer una misma estrategia de tenancy aunque sus mecanismos físicos se definan posteriormente.

Este ADR documenta esa estrategia común sin diseñar tablas, columnas, foreign keys, policies, claims, buckets, paths, APIs ni mecanismos exactos de autorización funcional.

---

# 5. Problem

¿Cómo preservar un aislamiento tenant autoritativo, uniforme y verificable en un SaaS que comparte inicialmente una única infraestructura PostgreSQL/Supabase entre múltiples `MaintenanceCompany`, evitando que el frontend determine el tenant efectivo y evitando tanto acceso cross-tenant como relaciones cross-tenant inválidas, sin introducir una base o un proyecto Supabase independiente por tenant?

La solución debe ser compatible con:

- el monolito modular aprobado en `ADR-0001`;
- Supabase PostgreSQL como source of truth remota;
- RLS obligatoria;
- recursos globales y recursos tenant-owned;
- recursos tenant-wide y client-scoped;
- Storage y Realtime;
- operaciones server-side privilegiadas;
- futura operación offline;
- Reporting;
- IA y créditos;
- Subscription & Payments;
- evolución posterior sin impedir una separación física si alguna necesidad real la justifica.

---

# 6. Decision

Para el MVP se adopta la siguiente decisión arquitectónica:

> **Utilizar una base Supabase PostgreSQL compartida entre tenants, con `MaintenanceCompany` como frontera primaria de tenancy, ownership tenant inequívoco para todos los recursos tenant-owned, resolución autoritativa del tenant efectivo y Row Level Security como frontera primaria de aislamiento remoto.**

La decisión se apoya en cuatro controles complementarios:

1. **tenant ownership inequívoco:** todo recurso tenant-owned debe pertenecer directa o derivadamente a una única `MaintenanceCompany`;
2. **tenant resolution autoritativa:** el tenant efectivo se determina desde identidad, membership/ownership y relaciones autoritativas, no desde una afirmación del frontend;
3. **authorization en application layer:** los casos de uso validan las reglas funcionales y de autorización aplicables antes o además del acceso a persistencia;
4. **RLS como frontera primaria remota:** el acceso normal a datos tenant debe ser rechazado por la capa de datos cuando no satisface las reglas de aislamiento, incluso ante requests manipuladas o bugs de aplicación.

Esta decisión también exige:

- preservar integridad cross-tenant, no sólo confidencialidad;
- restringir severamente `service-role`;
- derivar autorización de Supabase Storage desde ownership del dominio y no únicamente desde path, nombre de archivo o URL;
- impedir que Realtime amplíe permisos;
- diferenciar aislamiento remoto de aislamiento de réplica local offline.

La decisión **NO** define el mecanismo exacto mediante el cual se materializará cada comprobación ni qué recurso tendrá ownership directo frente a ownership derivado.

---

# 7. Frontera primaria de tenancy

`MaintenanceCompany` es la frontera primaria de tenancy del MVP.

Una `MaintenanceCompany` representa una empresa de mantenimiento usuaria del SaaS y constituye la unidad lógica principal de ownership y aislamiento multiempresa.

La frontera tenant **NO** equivale a:

- `Client`;
- `Location`;
- `Equipment`;
- un usuario;
- `Subscription`;
- una carpeta, prefijo o path de Storage;
- un módulo de aplicación;
- un deployable;
- un schema PostgreSQL.

En particular:

- un `Client` pertenece a una `MaintenanceCompany`, pero no constituye un tenant;
- una `Location` pertenece al contexto de un cliente y hereda su tenant;
- un `Equipment` pertenece a un cliente del tenant;
- un usuario tenant pertenece exactamente a una `MaintenanceCompany`, pero el usuario no es la frontera tenant;
- `Subscription` es un recurso comercial tenant-owned y no la identidad del tenant;
- un path de Storage puede codificar contexto, pero no constituye autoridad de tenancy.

No existen branches o sucursales de la empresa de mantenimiento en el MVP. Por ello no se introduce una segunda frontera interna equivalente a un subtenant de empresa.

---

# 8. Clases conceptuales de recursos

A efectos de razonamiento arquitectónico, el sistema puede contener recursos con distinta relación respecto de tenancy:

- **globales**, pertenecientes al ámbito de plataforma y no a un tenant operativo;
- **tenant-owned**, pertenecientes inequívocamente a una `MaintenanceCompany`;
- **tenant-wide**, tenant-owned cuyo alcance funcional no depende de un `Client` concreto;
- **client-scoped**, tenant-owned cuya operación además está acotada a un `Client` dentro del tenant;
- **derivados**, cuyo tenant se determina mediante relaciones autoritativas con otros recursos tenant-owned.

Esta clasificación es conceptual y no prescribe:

- tablas específicas;
- columnas específicas;
- schemas;
- prefijos físicos;
- módulos físicos obligatorios;
- una taxonomía SQL cerrada.

Un mismo recurso puede necesitar controles adicionales de rol, estado o alcance funcional. Esos controles no se resuelven por el hecho de conocer su tenant.

---

# 9. Tenant ownership

Todo recurso tenant-owned debe mantener una relación de ownership **inequívoca** hacia exactamente una `MaintenanceCompany`.

Ese ownership puede ser:

- **directo**, cuando el recurso se asocia conceptualmente de forma inmediata al tenant;
- **derivado**, cuando el tenant se obtiene mediante una cadena autoritativa de relaciones de dominio.

La regla arquitectónica es que el tenant siempre debe ser determinable sin ambigüedad y sin depender de una afirmación no verificada del caller.

Ejemplos conceptuales de ownership:

- `Client` pertenece a una `MaintenanceCompany`;
- `Location` pertenece a un `Client` y, por esa relación, al mismo tenant;
- `Equipment` pertenece a un `Client` y, por esa relación, al mismo tenant;
- `FormTemplate` pertenece a una `MaintenanceCompany`;
- un mantenimiento debe poder derivar su tenant desde sus relaciones autoritativas;
- `Evidence` deriva su contexto tenant mediante `Response` y mantenimiento;
- `Report`, `ReportVersion` y `ReportSnapshot` son tenant-owned;
- la wallet conceptual y el ledger de créditos IA son tenant-owned;
- `AIUsageOperation` es tenant-owned;
- `Subscription` es tenant-owned;
- un `PaymentEvent`, antes de producir efectos tenant, debe quedar correlacionado inequívocamente con el tenant correcto.

Estos ejemplos no deciden foreign keys, columnas ni constraints físicos.

## 9.1 No ambigüedad

No es válido que un recurso pueda aparecer coherentemente como perteneciente a dos tenants distintos según qué relación se consulte.

Si el diseño físico posterior mantiene un identificador tenant directo además de relaciones capaces de derivar el tenant, ambas fuentes deben ser consistentes.

El sistema no debe duplicar `maintenance_company_id` arbitrariamente si esa duplicación crea múltiples fuentes contradictorias de verdad.

## 9.2 Ownership no equivale a autorización completa

Conocer el tenant real de un recurso es necesario para aislamiento, pero no concede automáticamente permiso funcional para operar sobre él.

La autorización completa puede depender posteriormente de:

- identidad;
- membership;
- rol;
- client scope;
- estado del recurso;
- soporte excepcional;
- entitlement comercial;
- otras reglas aprobadas.

Esas reglas corresponden principalmente a `ADR-0003` y a ADR de dominio posteriores.

---

# 10. Tenant resolution

El tenant efectivo de una operación debe resolverse mediante **estado autoritativo**.

Una request originada en navegador/PWA puede incluir:

- IDs;
- rutas;
- referencias;
- contexto de navegación;
- identificadores de recursos;
- un `maintenance_company_id` o equivalente por razones técnicas.

Esos valores expresan intención o contexto. **No constituyen prueba de autorización ni autoridad para seleccionar el tenant efectivo.**

## 10.1 Regla de no confianza en frontend

Un `maintenance_company_id`, `tenant_id` o equivalente enviado por frontend:

- no prueba membership;
- no prueba ownership;
- no prueba client scope;
- no prueba permiso funcional;
- no puede permitir a un usuario escoger arbitrariamente otro tenant.

El backend y/o RLS deben validar el ownership real y el contexto autoritativo aplicable.

## 10.2 Parámetros no autoritativos

No deben utilizarse como control primario de tenancy:

- parámetros ocultos de formularios;
- query params;
- rutas;
- cookies custom;
- local storage;
- estado React;
- filtros visuales;
- selección de tenant mantenida únicamente en UI.

Esos mecanismos pueden transportar contexto, pero no reemplazan la comprobación autoritativa.

## 10.3 Relaciones manipuladas

Si una request intenta combinar identificadores válidos que pertenecen a tenants distintos, la operación debe fallar.

La validez individual de dos IDs no vuelve válida su relación.

Este ADR no decide el mecanismo exacto de tenant resolution, ni claims, helpers, funciones, joins o APIs concretas.

---

# 11. Row Level Security

Row Level Security es **obligatoria** y constituye la **frontera primaria de aislamiento remoto** para el acceso normal a datos tenant en Supabase PostgreSQL.

La estrategia debe preservar que RLS siga siendo efectiva aunque:

- el frontend contenga un bug;
- falte un filtro de UI;
- se manipule un request;
- se altere un ID;
- se invoque directamente una superficie de datos permitida al cliente;
- el navegador/PWA se considere comprometido dentro del modelo normal de amenazas.

Todas las tablas tenant-owned que, conforme al diseño físico posterior, requieran protección RLS deberán quedar cubiertas por políticas coherentes con esta baseline.

Toda migration que modifique acceso o aislamiento deberá incorporar las pruebas de RLS/regresión exigidas por la baseline del proyecto.

Este ADR **NO** define:

- sentencias de creación de políticas RLS;
- expresiones de policy;
- funciones SQL;
- helper functions;
- claims;
- JWT schema;
- custom claims;
- migrations;
- nombres de tablas o columnas.

---

# 12. Application authorization vs RLS

Application authorization y RLS son controles complementarios. Ninguno sustituye al otro.

## 12.1 Application authorization

La capa de aplicación puede y debe, según el caso de uso:

- autenticar/resolver el actor;
- validar el caso de uso;
- verificar rol;
- verificar client scope;
- verificar estado o transición de dominio;
- devolver errores funcionalmente útiles;
- impedir operaciones inválidas antes de llegar a persistencia;
- coordinar operaciones que involucren varias capacidades.

Este ADR no define la matriz completa de permisos ni la semántica final de `SupportAccessGrant`.

## 12.2 RLS

RLS debe actuar como:

- frontera autoritativa de acceso remoto normal a datos;
- defensa ante requests manipuladas;
- defensa ante bugs u omisiones de application layer;
- defensa contra acceso cross-tenant;
- control que no depende de que la UI haya filtrado correctamente.

## 12.3 Defensa en profundidad

La aplicación debe procurar bloquear una operación inválida tempranamente, pero una omisión de esa validación no debe convertir automáticamente la operación en autorizada en la capa de datos.

A la inversa, que RLS impida acceso cross-tenant no elimina la necesidad de validar reglas funcionales más específicas en la aplicación.

Las reglas completas de rol, `UserClientAccess`, soporte excepcional, revocación y sesiones pertenecen principalmente a `ADR-0003`.

---

# 13. Cross-tenant integrity

El aislamiento tenant incluye **confidencialidad, modificación e integridad relacional**.

No es suficiente impedir que Tenant A lea filas de Tenant B. El sistema también debe impedir que Tenant A cree o modifique relaciones que incorporen recursos de Tenant B.

Ejemplos conceptuales que deben rechazarse:

- `Equipment` de Tenant A asociado a `Client` de Tenant B;
- mantenimiento de Tenant A que referencie `Equipment` de Tenant B;
- mantenimiento que combine un equipo de un tenant con una `FormVersion` de otro;
- `Evidence` que termine vinculada a una `Response` o mantenimiento de otro tenant;
- `Report` o snapshot que incorpore mantenimientos, Evidence o templates de otro tenant;
- una `AIUsageOperation` de Tenant A que consuma wallet o ledger de Tenant B;
- un `PaymentEvent` correlacionado con Tenant A que produzca entitlement o acreditación en Tenant B.

La regla aplica tanto a relaciones creadas desde application layer como a operaciones privilegiadas.

Este ADR no decide el mecanismo físico concreto mediante el cual se preservará esa integridad.

---

# 14. Shared PostgreSQL

Para el MVP se utilizará **una base PostgreSQL compartida entre tenants** dentro de la plataforma Supabase prevista.

La decisión implica que inicialmente:

- no se crea una base de datos independiente por tenant;
- no se crea un schema PostgreSQL independiente por tenant;
- no se crea un proyecto Supabase independiente por tenant;
- no se crean bases separadas por módulo por defecto;
- los tenants comparten infraestructura física de datos;
- el aislamiento se implementa lógicamente mediante ownership, autorización, integridad y RLS.

Una base compartida **NO** significa ausencia de aislamiento.

El límite de seguridad es lógico y autoritativo aunque la infraestructura física sea común.

## 14.1 Motivos

Esta estrategia ofrece para el MVP:

- simplicidad operacional;
- migraciones centralizadas;
- una única plataforma de datos;
- menor coste de provisioning;
- menor complejidad de conexiones;
- administración más manejable;
- reporting global autorizado técnicamente más viable;
- consistencia transaccional más accesible cuando varias capacidades comparten PostgreSQL;
- alineación con el monolito modular de `ADR-0001`.

## 14.2 Obligaciones introducidas

La simplicidad física incrementa la importancia de:

- RLS correcta;
- ownership inequívoco;
- integridad cross-tenant;
- testing negativo;
- disciplina en operaciones privilegiadas;
- revisión de migrations que alteren acceso.

## 14.3 No bloqueo de evolución futura

Esta decisión no prohíbe una futura separación física.

Una estrategia database-per-tenant o equivalente sólo podrá adoptarse si aparece una necesidad real y deberá documentarse mediante un nuevo ADR que sustituya o modifique esta decisión.

---

# 15. Uso de `service-role`

`service-role` bypassa las protecciones RLS destinadas al acceso normal y, por ello, debe tratarse como una credencial **altamente privilegiada**.

Reglas arquitectónicas:

- no debe utilizarse como mecanismo ordinario para procesar requests de usuarios tenant;
- no debe trasladarse ni exponerse al navegador/PWA;
- no debe utilizarse para simplificar autorización evitando RLS;
- su uso debe restringirse a contextos explícitamente privilegiados que realmente lo requieran;
- el hecho de usar `service-role` no elimina la obligación de validar tenant, ownership e invariantes cross-tenant;
- una operación privilegiada debe minimizar su alcance y preservar las mismas fronteras de dominio relevantes.

El mal uso de `service-role` aumenta el blast radius porque elimina una defensa primaria del acceso normal.

Este ADR no enumera ni aprueba todos los casos de uso concretos en los que `service-role` podrá utilizarse.

---

# 16. `SUPER_ADMIN`

`SUPER_ADMIN` es una identidad global de plataforma y no pertenece a ningún tenant.

Su existencia no modifica las reglas de tenancy.

Por tanto:

- no posee acceso operacional normal a todos los tenants;
- no puede considerarse miembro implícito de cada `MaintenanceCompany`;
- no invalida RLS;
- no autoriza un bypass universal;
- no debe obtener acceso tenant simplemente por conocer un ID o por utilizar una UI global;
- el soporte excepcional depende de un `SupportAccessGrant` válido.

Los detalles de:

- grants;
- scopes;
- revocación;
- sesiones;
- auditoría de soporte;
- operaciones concretamente permitidas;

pertenecen principalmente a `ADR-0003` y no se resuelven en este ADR.

Se mantiene la regla normativa:

> **ausencia de permiso aprobado = no se infiere permiso.**

---

# 17. Supabase Storage

Supabase Storage debe respetar la misma frontera de tenancy que los recursos de dominio que representa o complementa.

El conocimiento de cualquiera de los siguientes datos no concede autorización:

- bucket;
- path;
- nombre de archivo;
- UUID;
- URL conocida previamente;
- URL obtenida por otro contexto;
- patrón de naming.

El acceso a Evidence, documentos generados y otros archivos tenant-owned debe derivarse del ownership del recurso de dominio correspondiente y de la autorización aplicable.

Un path puede colaborar con organización, lookup o implementación de policies, pero **el naming por sí solo no constituye aislamiento**.

Una manipulación de path nunca debe permitir acceder a archivos de otro tenant.

Este ADR no define:

- buckets;
- paths;
- signed URLs;
- estrategia de URLs;
- policies ejecutables de Storage;
- naming conventions físicas.

---

# 18. Supabase Realtime

Supabase Realtime puede utilizarse cuando una capacidad futura lo requiera, pero no puede ampliar permisos.

Reglas:

- una subscription Realtime debe respetar la misma frontera de tenancy que el acceso ordinario al dato;
- los datos emitidos no deben revelar recursos que el actor no pueda obtener por los mecanismos autorizados;
- conocer un channel, topic, nombre o identificador no constituye autorización;
- Realtime no reemplaza RLS ni ownership.

Este ADR no diseña channels, topics, payloads ni estrategia de suscripción.

---

# 19. Offline y frontera local

La operación offline introduce una réplica local de datos previamente autorizados y trabajo todavía no convergido con la source of truth remota.

Este ADR establece únicamente la frontera de aislamiento **remoto**.

Se reconoce que:

- la réplica local contiene datos derivados del alcance autorizado de una identidad;
- el aislamiento remoto entre tenants y el aislamiento local entre identidades son problemas relacionados pero distintos;
- que dos identidades pertenezcan al mismo tenant no autoriza compartir automáticamente su réplica local;
- la réplica local no se convierte en autoridad para tenancy remota.

El aislamiento de réplica local por identidad corresponde a `ADR-0004`.

El protocolo de sincronización, idempotencia y conflictos corresponde a `ADR-0005`.

Este ADR no diseña IndexedDB, Dexie, outbox ni algoritmos de sync.

---

# 20. Reporting

Reporting debe preservar tenancy de extremo a extremo.

Reglas aplicables en este ADR:

- `Report` es tenant-owned;
- `ReportVersion` y `ReportSnapshot` pertenecen al mismo tenant del `Report`;
- una generación no puede mezclar datos de tenants distintos;
- las fuentes incluidas deben mantener ownership coherente;
- la numeración oficial de informes es correlativa por `MaintenanceCompany` conforme a la baseline;
- un acceso de soporte futuro a Reporting no puede convertirse en bypass de tenancy.

Este ADR no resuelve `RPT-OPEN-*`, ni snapshot strategy, finalización, selección de mantenimientos, Evidence efectiva o atomicidad de numeración.

---

# 21. IA y créditos

El bounded context de IA y créditos debe preservar tenant ownership independientemente del proveedor externo.

Reglas:

- la wallet conceptual de créditos es tenant-owned;
- el ledger de créditos es tenant-owned;
- `AIUsageOperation` pertenece a exactamente un tenant;
- una operación IA de un tenant no puede reservar, consumir, liberar ni compensar créditos de otro tenant;
- cualquier vínculo entre IA y Reporting debe conservar el mismo tenant;
- OpenAI no constituye autoridad de tenancy;
- identificadores o estados devueltos por el proveedor no pueden redefinir el tenant efectivo.

Este ADR no resuelve:

- `DO-T01`;
- `DM-OPEN-007`;
- `AI-OPEN-*`;
- settlement;
- balance físico;
- concurrencia del ledger;
- proveedor/modelo concreto.

---

# 22. Subscription & Payments

El bounded context de Subscription & Payments debe preservar tenant ownership antes de producir cualquier efecto comercial.

Reglas:

- `Subscription` pertenece a una `MaintenanceCompany`;
- un `PaymentEvent` debe correlacionarse inequívocamente con el tenant correcto antes de producir efectos tenant;
- ningún pago puede activar, reactivar, acreditar o modificar el entitlement de otro tenant;
- un identificador externo del proveedor no prueba por sí solo ownership;
- el proveedor externo no determina unilateralmente el tenant efectivo;
- el estado externo debe reconciliarse con estado interno autoritativo antes de producir efectos permitidos.

Este ADR no resuelve:

- `DO-T02`;
- `DO-076`;
- `DO-078`;
- `PAY-OPEN-*`;
- state machine comercial;
- adapter de Mercado Pago;
- checkout;
- webhooks ejecutables.

---

# 23. Relación con `ADR-0001`

`ADR-0001 — Arquitectura modular del SaaS en Next.js` está `ACCEPTED`.

Este ADR es compatible y subordinado a esa decisión global.

La combinación de ambos ADR significa:

- un único deployable principal inicial;
- módulos internos dentro del monolito modular;
- una base PostgreSQL compartida inicialmente;
- ausencia de microservicios en el MVP salvo futura necesidad demostrada y nuevo ADR;
- ausencia de base de datos separada por bounded context por defecto;
- aislamiento tenant lógico y autoritativo dentro de infraestructura compartida.

Compartir aplicación y base de datos no habilita imports, queries u operaciones cross-tenant sin autorización.

Los módulos internos deben respetar ownership y tenancy aunque residan en el mismo codebase y proceso.

---

# 24. Alternatives

## 24.1 Alternativa A — Shared database + RLS + tenant ownership

### Descripción

Utilizar una única plataforma PostgreSQL compartida entre tenants, con ownership tenant inequívoco, resolución autoritativa, application authorization y RLS como frontera primaria de aislamiento remoto.

### Ventajas

- simplicidad operacional;
- una sola plataforma de datos;
- consistencia más manejable;
- migrations centralizadas;
- provisioning de tenant más simple;
- reporting global autorizado más manejable;
- administración y observabilidad operacional centralizadas;
- menor coste operacional inicial;
- alineación con el monolito modular;
- menor complejidad de pools/connections;
- permite transacciones consistentes entre capacidades que comparten PostgreSQL cuando corresponda.

### Desventajas

- RLS se vuelve crítica;
- un ownership mal modelado puede producir vulnerabilidades severas;
- un bug cross-tenant es de alta severidad;
- requiere disciplina fuerte en diseño y review;
- las operaciones privilegiadas aumentan el blast radius;
- la infraestructura física compartida conserva un blast radius operacional común.

### Evaluación

**Elegida para el MVP.**

Es la alternativa que mejor equilibra simplicidad operativa, coste, consistencia y capacidad de aislamiento para la escala y necesidades actualmente aprobadas.

---

## 24.2 Alternativa B — Database per tenant

### Descripción

Proveer una base de datos independiente por `MaintenanceCompany`.

### Ventajas

- aislamiento físico fuerte;
- blast radius de determinados errores de datos más acotado;
- posibilidad de políticas operativas distintas por tenant;
- separación potencialmente útil ante requisitos regulatorios o contractuales especiales.

### Desventajas

- provisioning más complejo;
- coordinación de migrations por tenant;
- administración de múltiples conexiones/pools;
- backups y restore más complejos;
- reporting global autorizado mucho más costoso;
- reconciliación de versiones de schema;
- observabilidad operacional distribuida;
- mayores costes de infraestructura y mantenimiento;
- mayor superficie de fallos operativos;
- mayor complejidad para un MVP sin necesidad demostrada.

### Evaluación

**No seleccionada para el MVP.**

El aislamiento adicional no justifica actualmente el coste operacional y de evolución.

Una adopción futura requeriría nueva evidencia y un nuevo ADR.

---

## 24.3 Alternativa C — Schema per tenant

### Descripción

Mantener una base compartida, pero crear un schema PostgreSQL separado por tenant.

### Ventajas potenciales

- separación física/lógica más visible que tablas compartidas;
- posibilidad de limitar ciertos errores de consulta cuando el schema se seleccione correctamente;
- organización por tenant aparentemente explícita.

### Desventajas

- proliferación de schemas;
- migrations repetidas o coordinadas por tenant;
- mayor complejidad de provisioning;
- mayor complejidad de búsquedas/reporting global autorizado;
- manejo de conexiones y search path más delicado;
- riesgo de convertir selección de schema en otra frontera de autorización susceptible de error;
- operación y tooling más complejos;
- no elimina la necesidad de autorización correcta;
- poco beneficio frente al coste para la baseline actual.

### Evaluación

**No seleccionada para el MVP.**

No existe una necesidad demostrada que justifique esa complejidad.

---

## 24.4 Alternativa D — Aislamiento sólo en application layer, sin RLS

### Descripción

Confiar exclusivamente en filtros, middleware, handlers o validaciones de la aplicación para asegurar que cada request sólo acceda a su tenant.

### Ventajas aparentes

- menor complejidad inicial de policies de base de datos;
- reglas de acceso concentradas aparentemente en aplicación;
- debugging inicial potencialmente más directo.

### Desventajas

- un filtro olvidado puede causar fuga cross-tenant;
- un bug en middleware puede ampliar acceso;
- una request manual puede intentar acceder directamente a otro recurso;
- un ID válido de otro tenant puede provocar IDOR si la aplicación omite una validación;
- no existe una última frontera autoritativa en la capa de datos;
- aumenta el impacto de errores de application layer;
- contradice la baseline aprobada que exige RLS.

### Evaluación

**Rechazada.**

Frontend, middleware y filtros de aplicación no constituyen una frontera suficiente para un SaaS multiempresa con datos sensibles e históricos técnicos.

---

# 25. Consequences

## 25.1 Consecuencias positivas

- modelo uniforme de tenancy en todos los bounded contexts;
- `MaintenanceCompany` como frontera clara y estable;
- base PostgreSQL compartida operativamente simple;
- defensa en profundidad mediante application authorization + RLS;
- menor probabilidad de fugas por filtros olvidados;
- tenant resolution no controlada por frontend;
- integridad cross-tenant explícita;
- mejor trazabilidad conceptual del ownership;
- Storage alineado con dominio en lugar de seguridad basada sólo en paths;
- menor complejidad inicial que database-per-tenant o schema-per-tenant;
- infraestructura manejable para el MVP;
- coherencia con `ADR-0001` y el monolito modular.

## 25.2 Consecuencias negativas

- RLS aumenta complejidad de diseño, review y testing;
- queries y relaciones deben respetar ownership de forma consistente;
- ownership derivado puede exigir razonamiento cuidadoso en operaciones complejas;
- operaciones privilegiadas requieren especial cuidado;
- `service-role` incrementa significativamente el blast radius si se usa mal;
- cambios de acceso requieren regression tests;
- Storage y Realtime deben mantener coherencia con la frontera de datos;
- una base compartida conserva blast radius operacional común para fallos de infraestructura;
- errores de tenant ownership son defectos de alta severidad;
- optimizaciones futuras no pueden degradar la capacidad de derivar tenancy inequívocamente.

---

# 26. Security implications

Este ADR considera las siguientes implicaciones de seguridad como especialmente relevantes para la decisión, sin pretender definir un threat model completo.

## 26.1 Cross-tenant data leak

Una fuga de datos entre tenants se considera un riesgo crítico.

La arquitectura debe priorizar controles que impidan que un error de filtrado de aplicación se transforme directamente en una exposición cross-tenant.

## 26.2 Tenant spoofing

Un caller no puede declarar o elegir el tenant efectivo mediante un `tenant_id`, `maintenance_company_id`, path, cookie custom o estado de UI.

## 26.3 IDOR

Conocer o adivinar un identificador de recurso no concede acceso.

Un ID válido debe ser validado contra ownership y autorización reales.

## 26.4 `service-role` misuse

El uso indebido de `service-role` puede eliminar la protección RLS y ampliar el blast radius de un bug o compromiso.

Debe permanecer fuera del navegador y fuera del flujo ordinario de requests de usuarios.

## 26.5 Storage bypass

Un objeto no debe volverse accesible por conocer o manipular su path o URL.

La autorización debe relacionarse con ownership de dominio.

## 26.6 Realtime leakage

Realtime no puede emitir datos que el actor no tenga autorización para obtener.

Conocer un channel/topic no constituye acceso.

## 26.7 Ownership inconsistente

Duplicar o mantener fuentes de tenant contradictorias puede crear rutas de autorización divergentes.

Toda representación debe conservar una única respuesta autoritativa sobre el tenant de un recurso.

## 26.8 Privileged operations

Las operaciones que utilicen privilegios superiores deben validar explícitamente tenant e invariantes, aun cuando no dependan de RLS para ese acceso concreto.

## 26.9 Pruebas negativas

Las pruebas cross-tenant negativas son obligatorias para demostrar que el aislamiento falla de manera segura ante IDs y relaciones manipuladas.

---

# 27. Data implications

La decisión impone las siguientes propiedades de datos:

- PostgreSQL compartido entre tenants;
- ownership tenant inequívoco;
- tenant derivable para todo recurso tenant-owned;
- diferenciación explícita entre recursos globales y tenant-owned;
- rechazo de relaciones cross-tenant inválidas;
- consistencia entre tenant directo y relaciones autoritativas cuando ambos existan;
- ausencia de duplicación arbitraria de `maintenance_company_id` que cree fuentes contradictorias de verdad;
- capacidad de verificar que recursos relacionados pertenecen al mismo tenant cuando la relación lo exige.

Este ADR **NO decide**:

- qué tablas tendrán una columna tenant directa;
- qué recursos derivarán tenant mediante joins;
- qué constraints físicas se utilizarán;
- qué foreign keys se crearán;
- qué índices existirán;
- cómo se materializará cada invariantes.

Esas decisiones pertenecen al diseño físico posterior y deberán preservar esta arquitectura.

---

# 28. Testing implications

La implementación futura deberá cubrir, como categorías mínimas, pruebas que demuestren:

- Tenant A no puede leer recursos de Tenant B;
- Tenant A no puede modificar recursos de Tenant B;
- Tenant A no puede eliminar o alterar relaciones de Tenant B cuando exista una operación equivalente autorizada en su propio tenant;
- Tenant A no puede crear relaciones que incorporen recursos de Tenant B;
- manipular IDs no permite saltar ownership;
- omitir o intentar bypass del application layer no elimina la protección RLS;
- acceso directo sujeto a RLS respeta aislamiento;
- operaciones privilegiadas con `service-role` validan tenant/ownership conforme a su contexto;
- Storage impide acceso cross-tenant por manipulación de path/URL;
- Realtime no emite datos cross-tenant;
- migrations que alteren acceso preservan las invariantes anteriores mediante regression tests.

Este ADR no define framework, fixtures, SQL de tests ni casos ejecutables concretos.

---

# 29. Observability / Audit implications

Los eventos de seguridad relevantes deberían permitir investigar intentos o fallos cross-tenant cuando corresponda, especialmente en operaciones privilegiadas o rechazos de integridad con valor forense.

Este ADR no define:

- vendor de observabilidad;
- logging schema;
- formato de AuditEvent;
- retención;
- alerting concreto;
- SLO;
- métricas de capacidad.

`DO-T05` y `ADR-0016` permanecen diferidos y no son resueltos aquí.

---

# 30. Future evolution

La separación física por tenant sólo debería reconsiderarse si aparece evidencia objetiva que cambie el balance actual, por ejemplo:

- requisitos regulatorios específicos;
- obligaciones contractuales de aislamiento especial;
- requisitos de residencia de datos;
- perfiles de escalado materialmente distintos;
- necesidad de limitar blast radius físico;
- operación empresarial que justifique infraestructura dedicada;
- requisitos técnicos demostrados que una base compartida no pueda satisfacer razonablemente.

La mera posibilidad futura de crecimiento no autoriza database-per-tenant.

Cualquier modificación relevante de la estrategia de tenancy —incluyendo database-per-tenant, schema-per-tenant o proyectos Supabase dedicados— requerirá un nuevo ADR que documente contexto, migración, consecuencias y supersession aplicable.

---

# 31. Dependencies

## 31.1 Depende de

- `ADR-0001 = ACCEPTED`;
- baseline documental aprobada `00..10`.

En particular, consume las reglas normativas de producto, dominio, autorización/RLS, offline, Evidence, Reporting, IA/créditos y Subscription/Payments sin modificar sus decisiones abiertas.

## 31.2 No depende para su decisión base de

- `DO-T03`;
- `DO-T04`;
- `DM-OPEN-*`;
- `FORM-OPEN-*`;
- `EVID-OPEN-*`;
- `RPT-OPEN-*`;
- `AI-OPEN-*`;
- `PAY-OPEN-*`;
- `OFF-OPEN-*`.

Ninguna de esas decisiones abiertas es necesaria para determinar `MaintenanceCompany` como tenant, shared PostgreSQL, ownership inequívoco, RLS obligatoria, tenant resolution autoritativa, integridad cross-tenant o uso restringido de `service-role`.

## 31.3 Condiciona

Este ADR establece restricciones arquitectónicas que deberán respetar:

- `ADR-0003` — autorización, client scope y soporte excepcional;
- `ADR-0004` — offline local-first y aislamiento de réplica;
- `ADR-0005` — protocolo de sincronización, idempotencia y conflictos;
- `ADR-0008` — Form Engine: versionado, estructura y aplicabilidad;
- `ADR-0009` — modelo de `MaintenanceRevision` e histórico;
- `ADR-0010` — Evidence histórica, replacement y continuidad;
- `ADR-0011` — Reporting: versionado, snapshots y finalización;
- `ADR-0013` — IA server-side, provider boundary y minimización;
- `ADR-0014` — Subscription lifecycle y commercial entitlement;
- `ADR-0006` — ledger de créditos IA y settlement;
- `ADR-0007` — `PaymentEvent`, adapter de Mercado Pago e idempotencia comercial.

Este ADR no resuelve ninguno de ellos.

---

# 32. Decisions explicitly not made

Este ADR no decide ni autoriza:

- tablas físicas;
- columnas;
- foreign keys;
- índices;
- SQL;
- policies RLS ejecutables;
- helper functions;
- JWT claims;
- custom claims;
- schemas PostgreSQL;
- buckets de Storage;
- Storage paths;
- estrategia de signed URLs;
- channels/topics Realtime;
- casos de uso definitivos de `service-role`;
- estructura exacta de módulos;
- repository pattern;
- ORM;
- caching;
- Edge Functions;
- Server Actions;
- RPC;
- diseño de APIs;
- invalidación de sesiones;
- mecánica de `SupportAccessGrant`;
- protección o schema de réplica local;
- IndexedDB/Dexie;
- protocolo de sincronización;
- algoritmos de conflictos;
- implementación de Supabase;
- implementación de Auth;
- implementación de Storage;
- implementación de Realtime.

Tampoco resuelve ninguna decisión `DO-*` o `*-OPEN-*` pendiente.

---

# 33. References

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/04-offline-sync-strategy.md`
- `docs/product/06-maintenance-evidence-spec.md`
- `docs/product/07-reporting-engine-spec.md`
- `docs/product/08-ai-credits-spec.md`
- `docs/product/09-subscription-payments-spec.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`

---

# 34. Supersession

`Supersedes: None`

`Superseded by: None`

---

# 35. Gate del ADR

- **ADR generado:** `ADR-0002`
- **Status:** `ACCEPTED`
- **Decisión:** shared PostgreSQL + tenant ownership + RLS
- **Tenant:** `MaintenanceCompany`
- **RLS obligatoria:** sí
- **Tenant enviado por frontend autoritativo:** no
- **Tenant resolution:** autoritativa mediante identidad/ownership/relaciones válidas
- **Cross-tenant integrity:** obligatoria
- **`service-role`:** restringido; no uso ordinario para requests de usuarios
- **Storage:** sujeto a ownership del dominio; path/URL no constituyen autorización
- **Realtime:** no amplía permisos
- **Microservicios:** no
- **Database-per-tenant:** no para el MVP
- **Schema-per-tenant:** no para el MVP
- **OPEN resueltos:** ninguno
- **Código:** no
- **SQL:** no
- **RLS ejecutable:** no
- **Storage policies ejecutables:** no
- **Implementación autorizada:** no
- **Otro ADR generado:** no
- **Aprobación:** completada
- **Estado de Fase 0:** `EN CURSO`

La aprobación de `ADR-0002` completa únicamente la aceptación formal de la decisión arquitectónica documentada. No autoriza implementación, no resuelve ningún `DO-*` o `*-OPEN-*`, no genera otro ADR, no inicia Fase 1 y no cierra Fase 0.
