# 03 — Estrategia conceptual de permisos, autorización y RLS

> **Ruta normativa:** `docs/product/03-permissions-rls-strategy.md`  
> **Estado:** **APROBADO — estrategia conceptual de permisos, autorización y RLS del MVP**  
> **Fase:** Fase 0 — documento derivado  
> **Estado de Fase 0:** **EN CURSO**  
> **Baseline normativa:** `docs/product/01-product-definition.md`  
> **Modelo de dominio aprobado:** `docs/product/02-domain-model.md`  
> **Naturaleza:** estrategia conceptual y arquitectónica de autorización, aislamiento multiempresa y Row Level Security; **NO constituye SQL, esquema físico, migraciones ni políticas RLS ejecutables**

---

# 1. Propósito y alcance

Este documento define la estrategia conceptual de seguridad y autorización del MVP.

Su objetivo es establecer, antes del diseño físico de PostgreSQL:

- quién puede acceder a cada clase de recurso;
- cómo se resuelve la identidad autenticada;
- cómo se determina la pertenencia a un tenant;
- cómo se determina el alcance por cliente;
- cómo se deriva el tenant real de un recurso;
- cómo debe funcionar el acceso excepcional de `SUPER_ADMIN`;
- qué responsabilidades corresponden a RLS;
- qué responsabilidades corresponden a la aplicación;
- qué responsabilidades corresponden a backend confiable;
- qué límites tiene `service-role`;
- cómo interactúan autorización, revocación, suscripción y sesiones;
- qué límites existen entre autorización online y offline;
- qué invariantes de ownership deben impedir referencias cruzadas manipuladas;
- qué pruebas de seguridad serán obligatorias cuando se implemente el esquema físico.

Este documento constituye un contrato para:

1. el futuro diseño físico de datos;
2. las futuras políticas RLS;
3. la estrategia de Supabase Storage;
4. el diseño de autorización del backend;
5. las pruebas negativas de aislamiento;
6. las especificaciones posteriores que dependan de autorización.

## 1.1 Autoridad

Se aplica el siguiente orden:

1. `docs/product/01-product-definition.md`;
2. `docs/product/02-domain-model.md`;
3. `docs/product/00-master-product-brief.md`;
4. decisiones explícitamente aprobadas posteriormente que no hayan sido sustituidas.

`01-product-definition.md` prevalece ante contradicción.

`02-domain-model.md` permanece aprobado como interpretación conceptual del dominio.

`DO-075` permanece **RESUELTA/APROBADA**.

`DM-OPEN-001` a `DM-OPEN-008` permanecen abiertas y este documento no las resuelve.

## 1.2 Fuera del alcance

Este documento:

- **NO es SQL**;
- **NO define tablas físicas**;
- **NO define columnas definitivas**;
- **NO crea migraciones**;
- **NO contiene `CREATE POLICY`**;
- **NO contiene políticas RLS ejecutables**;
- **NO define funciones PostgreSQL concretas**;
- **NO define buckets concretos de Storage**;
- **NO define endpoints o Server Actions concretos**;
- **NO define la estructura Dexie/IndexedDB**;
- **NO implementa invalidación de sesiones**;
- **NO implementa autorización offline**;
- **NO genera ADRs**.

El diseño físico posterior podrá elegir mecanismos distintos siempre que preserve esta estrategia y la baseline aprobada.

## 1.3 Revisión de coherencia previa

No se detecta una contradicción bloqueante entre `01-product-definition.md` y `02-domain-model.md` que impida definir esta estrategia.

Se mantienen como reglas cerradas:

- tenant completamente aislado;
- `SUPER_ADMIN` global y fuera de tenants;
- `COMPANY_ADMIN` y `TECHNICIAN` pertenecientes exactamente a un tenant;
- un usuario tenant no pertenece a múltiples empresas en el MVP;
- acceso del técnico definido por clientes autorizados;
- cliente autorizado implica acceso a todas sus ubicaciones y equipos;
- ausencia de asignaciones por ubicación, equipo o mantenimiento;
- ausencia de órdenes de trabajo;
- RLS como frontera primaria de aislamiento remoto;
- soporte sólo mediante concesión explícita;
- autorización offline máxima de 7 días;
- trabajo capturado offline conservado ante revocación o expiración;
- `TECHNICIAN` puede iniciar, realizar y finalizar mantenimientos dentro de sus clientes autorizados;
- `COMPANY_ADMIN` puede corregir mantenimientos finalizados y resolver conflictos dentro de su alcance;
- la baseline no concede expresamente a `COMPANY_ADMIN` capacidad para iniciar, ejecutar o finalizar una ejecución inicial de mantenimiento.

Se aplica de forma estricta la regla:

> **ausencia de permiso aprobado = no se infiere permiso.**

---

# 2. Modelo de actores y conceptos de autorización

## 2.1 Autenticación frente a autorización

**Autenticación** responde:

> ¿Qué identidad está presentando una sesión válida reconocida por Supabase Auth?

**Autorización** responde:

> Dada esa identidad, ¿puede realizar esta operación concreta sobre este recurso concreto en este momento?

Una identidad autenticada por sí sola **NO** concede acceso tenant.

La autorización debe derivarse de información autoritativa adicional.

---

## 2.2 Identidad autenticada

La identidad autenticada proviene de Supabase Auth.

Conceptualmente debe resolverse hacia un `PlatformUser`.

La identidad autenticada:

- identifica al sujeto;
- no determina unilateralmente su tenant;
- no determina unilateralmente su rol;
- no determina unilateralmente sus clientes;
- no determina unilateralmente soporte excepcional;
- no reemplaza la comprobación del estado comercial.

El correo electrónico o cualquier otro atributo editable no debe utilizarse por sí mismo como frontera de autorización.

---

## 2.3 `SUPER_ADMIN`

`SUPER_ADMIN`:

- es global;
- no pertenece a ningún tenant;
- no posee `CompanyMembership` tenant;
- puede crear empresas de mantenimiento;
- inicia el alta del primer `COMPANY_ADMIN`;
- administra capacidades globales de plataforma;
- no tiene acceso operativo normal a datos tenant.

Su condición global **NO** equivale a privilegio universal sobre todos los datos.

Para acceder excepcionalmente a datos tenant necesita un `SupportAccessGrant` válido y suficiente para la operación.

---

## 2.4 `COMPANY_ADMIN`

`COMPANY_ADMIN`:

- pertenece exactamente a un tenant mediante `CompanyMembership`;
- opera únicamente dentro de ese tenant;
- administra usuarios y permisos de su empresa;
- administra clientes, ubicaciones, tipos de equipos y equipos de su empresa;
- administra formularios;
- puede consultar mantenimientos de su tenant cuando sea necesario para sus funciones;
- puede consultar revisiones, respuestas y evidencias;
- puede corregir mantenimientos finalizados dentro de su alcance;
- como parte de una corrección autorizada, puede crear la nueva `MaintenanceRevision` resultante y crear/modificar las respuestas y evidencias que formen parte de esa nueva revisión;
- puede resolver conflictos dentro de su alcance conforme a `RF-113`, generando cuando corresponda una nueva revisión;
- puede utilizar mantenimientos autorizados como fuente para informes;
- administra y finaliza informes;
- administra plantillas de informe;
- puede utilizar IA;
- administra créditos IA;
- administra la suscripción;
- puede conceder y revocar soporte excepcional.

La baseline **NO** concede expresamente a `COMPANY_ADMIN` capacidad para:

- iniciar un mantenimiento nuevo;
- realizar o ejecutar una ejecución inicial;
- finalizar la primera ejecución de un mantenimiento;
- crear respuestas o evidencias correspondientes a una ejecución inicial.

Estas capacidades no deben inferirse.

---

## 2.5 `TECHNICIAN`

`TECHNICIAN`:

- pertenece exactamente a un tenant;
- sólo posee alcance operativo sobre clientes autorizados;
- no administra el tenant;
- no administra usuarios;
- no administra clientes;
- no administra ubicaciones;
- no administra equipos;
- no administra formularios;
- no administra informes;
- no utiliza IA.

Puede:

- consultar la información operativa necesaria de clientes autorizados;
- consultar toda la jerarquía de ubicaciones de dichos clientes;
- consultar todos sus equipos;
- obtener los formularios aplicables necesarios;
- iniciar y realizar mantenimientos dentro de sus clientes autorizados;
- capturar respuestas y evidencias de la ejecución inicial;
- finalizar esos mantenimientos;
- corregir posteriormente mantenimientos finalizados;
- crear las revisiones, respuestas y evidencias correspondientes a sus correcciones autorizadas;
- resolver conflictos de mantenimiento dentro de sus clientes autorizados.

No existe asignación adicional por ubicación, equipo o mantenimiento.

---

## 2.6 `CompanyMembership`

`CompanyMembership` representa autorización tenant.

Debe responder al menos conceptualmente:

- qué `PlatformUser` representa;
- a qué `MaintenanceCompany` pertenece;
- qué rol fijo posee;
- si está habilitada.

Una identidad tenant sin membership habilitada no posee acceso tenant online.

---

## 2.7 Cliente autorizado

`UserClientAccess` expresa autorización explícita entre una membership y un `Client`.

Para `TECHNICIAN`:

> `Membership válida` + `rol TECHNICIAN` + `UserClientAccess al cliente`  
> = acceso operativo al cliente.

Ese alcance se hereda hacia:

- toda la jerarquía `Location`;
- todos los `Equipment`;
- formularios aplicables necesarios;
- mantenimientos de esos equipos;
- revisiones correspondientes;
- respuestas correspondientes;
- evidencias correspondientes;
- conflictos de mantenimiento correspondientes.

No existen grants independientes por ubicación, equipo o mantenimiento.

---

## 2.8 Soporte excepcional

`SupportAccessGrant` representa una excepción explícita para una identidad `SUPER_ADMIN`.

No convierte a `SUPER_ADMIN` en miembro del tenant.

No modifica el modelo normal de roles tenant.

No concede automáticamente todas las operaciones sobre una sección.

Una concesión autoriza únicamente:

- el tenant concedente;
- los clientes indicados cuando el scope es client-scoped;
- las secciones indicadas;
- las operaciones que la baseline ya permita expresamente para soporte.

No deben inferirse nuevas capacidades de escritura sólo porque una sección sea visible.

---

# 3. Contexto de seguridad y fronteras de confianza

## 3.1 Navegador / PWA

El navegador y la PWA son entornos no confiables para decisiones de autorización.

El usuario puede:

- modificar JavaScript local;
- manipular requests;
- alterar parámetros;
- llamar APIs manualmente;
- utilizar DevTools;
- modificar estado local;
- intentar reutilizar identificadores obtenidos anteriormente.

La aplicación cliente puede expresar una intención, pero nunca ser la autoridad definitiva que decide si la operación está permitida.

---

## 3.2 IndexedDB / Dexie

IndexedDB contiene una réplica local operativa, no la autoridad remota.

Los datos locales:

- pueden permanecer disponibles sin conexión;
- deben estar aislados por identidad;
- pueden contener datos previamente autorizados que posteriormente hayan sido revocados;
- no pueden utilizarse como prueba autoritativa de autorización remota;
- no sustituyen la revalidación online.

La protección concreta de esa réplica pertenece a `04-offline-sync-strategy.md` y `DO-T04`.

---

## 3.3 Supabase Auth

Supabase Auth es responsable de autenticar una identidad.

No debe convertirse en la única fuente para resolver:

- tenant;
- rol vigente;
- membership vigente;
- permisos por cliente;
- soporte;
- estado comercial.

La autorización debe poder consultar estado autoritativo vigente independientemente de datos potencialmente obsoletos conservados por el cliente.

---

## 3.4 PostgreSQL

Supabase PostgreSQL es la fuente de verdad remota.

La capa de datos debe ser capaz de rechazar una operación no autorizada aunque:

- el frontend contenga un bug;
- se omita un filtro;
- se llame directamente a Supabase;
- se altere un request manualmente;
- un ID válido sea sustituido por otro.

RLS constituye la frontera primaria para acceso normal a datos tenant.

---

## 3.5 Supabase Storage

Storage debe respetar el mismo modelo de ownership.

El conocimiento de:

- nombre de bucket;
- path;
- nombre de archivo;
- UUID;
- URL anteriormente obtenida;

no debe ser suficiente para acceder a evidencia privada.

La autorización sobre un objeto debe derivarse del recurso de dominio al que pertenece.

---

## 3.6 Backend confiable

Server Actions, handlers o endpoints ejecutados en servidor constituyen un límite de confianza superior al navegador, pero **no son automáticamente autorización**.

Cuando reciben una solicitud de usuario deben:

- autenticar identidad;
- resolver autorización;
- validar ownership;
- validar las transiciones del dominio;
- minimizar privilegios;
- evitar depender de parámetros de autoridad proporcionados por el navegador.

---

## 3.7 `service-role`

`service-role` posee capacidad privilegiada y puede evitar las protecciones normales destinadas a usuarios finales.

Por ello su uso debe ser excepcional.

No debe transformarse en la forma normal de consultar o mutar datos tenant.

---

## 3.8 OpenAI

OpenAI es un servicio externo.

Las llamadas:

- se realizan exclusivamente server-side;
- sólo pueden ser iniciadas por una operación IA autorizada de `COMPANY_ADMIN`;
- deben recibir únicamente datos permitidos;
- no pueden utilizarse para derivar permisos;
- no reciben fotografías en el MVP.

---

## 3.9 Mercado Pago

Mercado Pago es un proveedor externo y no constituye directamente autoridad interna de acceso.

Sus eventos:

- deben verificarse;
- deben procesarse idempotentemente;
- deben reconciliarse con el tenant correcto;
- sólo después pueden producir cambios en la fuente interna de verdad comercial.

---

# 4. Principio Zero Trust del cliente

Todo valor recibido desde navegador/PWA debe tratarse como no confiable hasta ser verificado.

## 4.1 Datos que el cliente nunca determina unilateralmente

No debe aceptarse como autoridad un valor enviado por frontend para:

- `maintenance_company_id`;
- tenant efectivo;
- rol;
- estado de membership;
- clientes autorizados;
- ownership de un recurso;
- ownership de una relación;
- acceso excepcional;
- scopes de soporte;
- estado comercial;
- saldo de créditos;
- estado de inmutabilidad;
- número oficial de informe;
- actor real de auditoría.

---

## 4.2 Parámetros permitidos como intención

El frontend puede solicitar, por ejemplo:

- abrir un cliente;
- crear un mantenimiento sobre un equipo cuando el actor esté expresamente autorizado para ejecutar esa operación;
- corregir un mantenimiento;
- asociar una fotografía;
- crear una ubicación hija;
- generar un informe.

Los IDs enviados identifican recursos deseados.

No prueban autorización sobre esos recursos.

---

## 4.3 Regla general

Debe rechazarse conceptualmente:

```text
request afirma tenant X
→ sistema acepta tenant X
```

El patrón requerido es:

```text
identidad autenticada
→ autorización autoritativa
→ ownership real de recursos
→ tenant efectivo comprobado
→ operación permitida o rechazada
```

---

# 5. Resolución de identidad

La resolución conceptual es:

```text
Supabase Auth identity
→ PlatformUser
```

Posteriormente:

```text
PlatformUser
→ identidad global SUPER_ADMIN
```

o, para usuarios tenant:

```text
PlatformUser
→ CompanyMembership
→ MaintenanceCompany
→ rol
```

Cuando sea necesario para un técnico:

```text
CompanyMembership
→ UserClientAccess
→ Client
```

## 5.1 Reglas

Una identidad autenticada puede operar como usuario tenant únicamente si:

- corresponde a un `PlatformUser`;
- posee una membership válida;
- esa membership está habilitada;
- el rol es uno de los permitidos;
- la operación pertenece al tenant de la membership;
- se satisfacen los demás controles aplicables.

`SUPER_ADMIN` sigue un flujo diferente porque no posee membership tenant.

---

# 6. Resolución del tenant efectivo

## 6.1 Usuario tenant

Para `COMPANY_ADMIN` y `TECHNICIAN`, el tenant autorizado debe derivarse de la `CompanyMembership` vigente.

No del request.

Un parámetro `maintenance_company_id` puede existir eventualmente como dato técnico, pero nunca debe ser aceptado sin comparación contra la membership y el recurso.

---

## 6.2 Recursos existentes

Cuando se opera sobre un recurso existente:

1. se resuelve el actor;
2. se determina su contexto autorizado;
3. se obtiene el ownership real del recurso;
4. se deriva el tenant real;
5. se compara con el tenant autorizado;
6. se aplican restricciones adicionales de cliente, rol y estado.

---

## 6.3 Creaciones

Cuando se crea un recurso tenant-owned, el tenant resultante debe provenir del contexto autorizado y/o de las entidades parent válidas.

Ejemplo conceptual para la ejecución inicial aprobada de un técnico:

```text
TECHNICIAN crea mantenimiento para Equipment E
→ E determina Client C
→ C determina MaintenanceCompany T
→ membership del técnico debe pertenecer a T
→ técnico debe tener UserClientAccess a C
```

El frontend no puede elegir un tenant diferente.

---

## 6.4 Prohibición expresa

Queda prohibido:

```text
frontend envía maintenance_company_id
→ backend confía en ese valor
→ INSERT/UPDATE
```

---

# 7. Matriz conceptual de permisos

Leyenda:

- **Leer:** consultar información autorizada.
- **Crear/Modificar/Administrar:** capacidad de gestión aprobada.
- **Ejecutar:** realizar una operación de mantenimiento inicial cuando la baseline la conceda.
- **Corregir:** crear una revisión correctiva.
- **Resolver:** resolver un conflicto.
- **Soporte limitado:** sólo cuando existe grant y scope suficiente.
- **No definido:** la baseline no concede una capacidad general y no debe inferirse.

| Recurso/capacidad | `SUPER_ADMIN` normal | `COMPANY_ADMIN` | `TECHNICIAN` | `SUPER_ADMIN` con grant |
|---|---|---|---|---|
| Empresas de mantenimiento | Crear y administrar aspectos globales | Leer/administrar su propia empresa según capacidades tenant | Sólo contexto mínimo necesario | No amplía por grant la administración global |
| Alta primer admin | Sí, durante onboarding | No aplica al primer alta | No | No cambia |
| Usuarios/memberships posteriores | No dar de alta salvo primer admin | Crear, cambiar rol, cambiar clientes, deshabilitar, reintegrar | Leer su contexto propio cuando sea necesario | Scope `usuarios/permisos` permite soporte/acceso; no se infiere alta ordinaria de usuarios |
| `UserClientAccess` | No normal | Administrar dentro de su tenant | No modificar; sólo consumir su propio alcance | Scope `usuarios/permisos`; no permite ampliar arbitrariamente privilegios |
| Clientes | No | Administrar todos los clientes de su tenant | Leer clientes autorizados | Leer únicamente clientes concedidos con scope de información |
| Ubicaciones | No | Administrar dentro del tenant | Leer todas las de clientes autorizados | Acceso sólo a clientes concedidos con scope `ubicaciones` |
| Tipos de equipos | No | Administrar dentro del tenant | Leer sólo información necesaria para equipos autorizados | Sólo acceso derivado necesario para scopes concedidos; no administración inferida |
| Equipos | No | Administrar dentro del tenant | Leer todos los de clientes autorizados | Acceso sólo a clientes concedidos con scope `equipos` |
| Formularios | No | Crear, clonar, editar borrador, publicar, archivar | Leer versiones aplicables/históricas necesarias para operar | Scope `formularios/respuestas`: acceso necesario; no se infiere administración de plantillas tenant-wide |
| Mantenimientos | No | Leer y corregir finalizados; resolver conflictos dentro de su alcance; usar como fuente autorizada de informes | Leer, iniciar/realizar, finalizar y corregir en clientes autorizados; resolver conflictos de mantenimiento | Sólo con grant del cliente y scope `mantenimientos`; operaciones únicamente conforme a la baseline |
| Revisiones | No | Leer; crear una nueva revisión únicamente por corrección autorizada o resolución de conflicto | Leer; crear revisión inicial/futuras revisiones conforme a ejecución, corrección o resolución autorizadas | Acceso derivado del scope de mantenimiento; revisiones históricas nunca se editan |
| Respuestas | No | Leer; crear/modificar únicamente dentro de una corrección autorizada o resolución de conflicto | Crear/modificar durante ejecución inicial, corrección o resolución autorizadas; leer históricas | Requiere scope `formularios/respuestas` y contexto de mantenimiento permitido |
| Evidencias | No | Leer; crear únicamente dentro de una corrección autorizada o resolución de conflicto; reemplazo visual sin borrado histórico | Crear durante ejecución inicial/corrección/resolución autorizadas; leer; reemplazo visual sin borrado histórico | Requiere scope `evidencias` y recurso autorizado |
| Conflictos de mantenimiento | No definido | Resolver dentro de su alcance conforme a `RF-113` | Resolver en clientes autorizados | No se infiere capacidad de resolución |
| Informes | No | Crear, administrar, finalizar y regenerar | No | Sólo clientes con scope `informes`; la baseline permite soporte expresamente habilitado |
| Plantillas de informe | No | Administrar | No | No se infiere modificación de plantilla tenant-wide desde un grant por cliente |
| IA | No | Utilizar para informes | No | No; `RF-142` limita IA a `COMPANY_ADMIN` |
| Créditos IA | No normal | Administrar | No | Sólo scope tenant-wide `créditos IA` |
| Suscripción/pagos | No normal | Administrar | No | Sólo scope tenant-wide `suscripción/pagos` |
| Auditoría | Genera eventos por acciones globales/soporte según corresponda | Sus acciones sensibles generan eventos | Sus acciones auditables generan eventos cuando corresponda | Cada uso efectivo de soporte genera evento |
| Eliminación de auditoría | No | No | No | No |

## 7.1 Regla conservadora para soporte y permisos no expresos

Un `SupportAccessGrant` es un permiso excepcional de acceso, no un generador de capacidades nuevas.

Asimismo, una capacidad administrativa sobre el tenant no crea por sí sola permisos operativos no aprobados sobre mantenimiento.

Se aplica:

> **ausencia de permiso aprobado = no se infiere permiso.**

Por ello, la capacidad de `COMPANY_ADMIN` para corregir un mantenimiento finalizado y resolver conflictos no debe interpretarse como autorización para realizar la ejecución inicial.

---

# 8. Alcance de `COMPANY_ADMIN`

`COMPANY_ADMIN` opera dentro de exactamente un tenant.

Su contexto conceptual es:

```text
identidad válida
+ membership habilitada
+ rol COMPANY_ADMIN
+ tenant de membership
+ estado comercial aplicable
= acceso administrativo al tenant
```

Según la baseline puede:

- administrar usuarios de su empresa;
- administrar roles fijos y clientes autorizados;
- administrar clientes;
- administrar ubicaciones;
- administrar tipos de equipos;
- administrar equipos;
- administrar formularios;
- consultar mantenimientos de su tenant cuando sea necesario para sus funciones;
- consultar revisiones, respuestas y evidencias;
- corregir mantenimientos finalizados;
- crear la nueva revisión derivada de una corrección autorizada;
- crear/modificar respuestas y evidencias únicamente dentro de una corrección autorizada o resolución de conflicto;
- resolver conflictos dentro de su alcance conforme a `RF-113`;
- utilizar mantenimientos autorizados como fuente para informes;
- administrar informes;
- finalizar informes;
- administrar plantillas de informe;
- utilizar IA;
- administrar créditos;
- administrar suscripción;
- administrar acceso de soporte.

No puede:

- administrar otro tenant;
- conceder clientes de otro tenant;
- crear roles personalizados;
- concederse capacidad global;
- convertir una relación tenant en una relación cross-tenant;
- iniciar una ejecución nueva de mantenimiento por inferencia;
- realizar la ejecución inicial de un mantenimiento por inferencia;
- finalizar la primera ejecución de un mantenimiento por inferencia;
- crear respuestas o evidencias de una ejecución inicial por inferencia.

Si el producto requiriera en el futuro que `COMPANY_ADMIN` también realice ejecuciones iniciales, esa capacidad deberá aprobarse explícitamente en la baseline antes de incorporarse a autorización o RLS.

---

# 9. Alcance de `TECHNICIAN`

La regla central es:

> **Membership válida + rol `TECHNICIAN` + `UserClientAccess` al cliente = acceso operativo al cliente.**

El acceso incluye:

- `Client`;
- toda su jerarquía `Location`;
- todos sus `Equipment`;
- información de `EquipmentType` necesaria para interpretar esos equipos;
- `FormVersion` aplicables necesarias para operar;
- mantenimientos del cliente;
- revisiones correspondientes;
- respuestas;
- evidencias;
- conflictos de mantenimiento.

## 9.1 Herencia descendente

La autorización se expresa a nivel `Client`.

No existen permisos independientes por:

- ubicación;
- equipo;
- formulario individual;
- mantenimiento;
- revisión.

El alcance se deriva mediante ownership.

## 9.2 Ejecución de mantenimiento

Dentro de un cliente autorizado, `TECHNICIAN` conserva íntegramente las capacidades aprobadas para:

- iniciar un mantenimiento sin asignación previa;
- realizar la captura;
- crear/modificar las respuestas necesarias durante la ejecución;
- capturar evidencias;
- finalizar el mantenimiento;
- corregirlo posteriormente;
- crear nuevas revisiones correctivas;
- resolver conflictos de mantenimiento dentro de su alcance.

## 9.3 Formularios tenant-wide

Como `FormTemplate` y `FormVersion` pertenecen conceptualmente al tenant y pueden estar relacionados con equipos/tipos, el técnico no recibe por ello acceso administrativo a todos los formularios del tenant.

Su acceso de lectura debe limitarse a las definiciones necesarias para:

- operar equipos de clientes autorizados;
- interpretar mantenimientos históricos autorizados.

El mecanismo físico para expresar eficientemente esa autorización se definirá posteriormente sin modificar `DM-OPEN-002` ni `DM-OPEN-003`.

## 9.4 Prohibición de autoampliación

`TECHNICIAN` nunca puede:

- crear `UserClientAccess`;
- modificar su propio rol;
- cambiar su tenant;
- asociar un mantenimiento a un equipo fuera de su alcance para obtener acceso indirecto;
- utilizar un ID permitido como puente hacia otro cliente.

---

# 10. Acceso excepcional de `SUPER_ADMIN`

## 10.1 Principio general

Sin un `SupportAccessGrant` válido:

> `SUPER_ADMIN` no posee acceso operativo a los datos tenant.

La condición `SUPER_ADMIN` no debe ser una excepción universal dentro de las políticas RLS.

---

## 10.2 Propiedad del grant

`SupportAccessGrant`:

- pertenece al tenant concedente;
- identifica al sujeto global autorizado;
- define scopes;
- puede modificarse;
- puede revocarse;
- debe estar vigente para producir acceso;
- no transforma al sujeto en miembro del tenant.

"Vigente" significa que la concesión continúa autorizada conforme a su estado y reglas aprobadas. Este documento no inventa una caducidad temporal obligatoria que la baseline no haya definido.

---

## 10.3 Scopes por cliente

Son scopes aprobados:

- información del cliente;
- ubicaciones;
- equipos;
- mantenimientos;
- formularios/respuestas;
- evidencias;
- informes.

Cada scope debe evaluarse contra un cliente concreto autorizado.

Ejemplo:

```text
Grant:
Tenant A
Client 1: equipos + mantenimientos
Client 2: informes
```

No implica:

- acceso a Client 3;
- evidencias de Client 1 si no fueron concedidas;
- equipos de Client 2;
- acceso general al tenant.

---

## 10.4 Scopes tenant-wide

Son scopes aprobados:

- usuarios/permisos;
- suscripción/pagos;
- créditos IA.

Estos scopes no dependen de un cliente específico.

No habilitan por extensión:

- clientes;
- mantenimientos;
- equipos;
- informes;
- IA.

---

## 10.5 Composición de scopes

Las operaciones que toquen varias clases de recurso deben satisfacer los scopes necesarios para cada recurso.

Por ejemplo, tener scope `mantenimientos` sobre un cliente no debe servir como acceso genérico a todas sus evidencias si no existe scope `evidencias`.

El conocimiento de un ID encontrado legítimamente bajo un scope tampoco debe ampliar los demás scopes.

---

## 10.6 Revocación

Cuando un grant se revoca:

- deja de autorizar nuevos accesos remotos;
- las solicitudes posteriores deben fallar;
- una sesión existente de `SUPER_ADMIN` no debe conservar acceso sólo por haber cargado anteriormente el grant;
- la revocación debe quedar auditada.

---

## 10.7 Auditoría obligatoria

Debe auditarse:

- concesión;
- modificación;
- revocación;
- acceso efectivo realizado mediante soporte.

El evento de acceso debe poder identificar:

- actor;
- tenant;
- cliente cuando corresponda;
- scope utilizado;
- recurso/alcance suficiente para trazabilidad;
- momento.

No se exige registrar indiscriminadamente cada lectura normal de usuarios tenant como evento de auditoría.

---

# 11. Propiedad de datos

## 11.1 Globales

Conceptos globales:

- `PlatformUser`;
- identidad `SUPER_ADMIN`;
- registro de `MaintenanceCompany`;
- infraestructura global necesaria para autenticación/onboarding.

Estos recursos no deben confundirse con datos tenant-owned.

---

## 11.2 Tenant-owned

Deben poseer un tenant inequívocamente derivable:

- `CompanyMembership`;
- `UserClientAccess`;
- `SupportAccessGrant`;
- `Client`;
- `Location`;
- `EquipmentType`;
- `Equipment`;
- `FormTemplate`;
- `FormVersion`;
- `FormSection`;
- `FormField`;
- `MaintenanceRecord`;
- `MaintenanceRevision`;
- `Response`;
- `Evidence`;
- `EvidenceReplacementRelation`;
- `ReportTemplate`;
- `Report`;
- `ReportVersion`;
- `ReportSnapshot`;
- `ReportFileArtifact`;
- `AIUsageOperation`;
- `AICreditLedgerEntry`;
- `Subscription`;
- efectos tenant de `PaymentEvent`;
- `AuditEvent` tenant;
- `PushNotification` tenant.

---

## 11.3 Client-scoped

Son además client-scoped:

- `Location`;
- `Equipment`;
- `MaintenanceRecord`;
- `MaintenanceRevision`;
- `Response`;
- `Evidence`;
- `Report`;
- `ReportVersion`;
- `ReportSnapshot`.

La cadena de ownership debe permitir comprobar:

```text
recurso
→ Client
→ MaintenanceCompany
```

---

## 11.4 Recursos derivados

Un recurso derivado no puede confiar en un `client_id` independiente si su parent real determina otro cliente.

Ejemplo:

```text
Response
→ MaintenanceRevision
→ MaintenanceRecord
→ Equipment
→ Client
→ MaintenanceCompany
```

La autorización se basa en la cadena real y coherente.

---

## 11.5 Datos locales

`LocalReplica`, outbox, fotografías pendientes y autorización offline:

- pertenecen técnicamente a una identidad local;
- representan datos tenant/client previamente autorizados;
- no cambian ownership;
- no constituyen autoridad remota.

---

# 12. Estrategia RLS

## 12.1 Responsabilidad principal

RLS debe ser la barrera primaria contra:

- lectura cross-tenant;
- escritura cross-tenant;
- acceso de técnico a clientes no autorizados;
- manipulación de relaciones;
- escalamiento accidental;
- acceso operativo de `SUPER_ADMIN` sin grant.

Un bug de aplicación no debe convertir un recurso ajeno en visible.

---

## 12.2 Patrón de usuario tenant

Conceptualmente, para una operación tenant:

1. identidad autenticada;
2. `PlatformUser` válido;
3. `CompanyMembership` habilitada;
4. tenant de membership;
5. rol;
6. ownership del recurso;
7. client scope cuando corresponda;
8. estado comercial online cuando corresponda;
9. reglas de mutabilidad y de operación autorizada para ese rol.

---

## 12.3 `COMPANY_ADMIN`

Una operación de `COMPANY_ADMIN` debe demostrar:

```text
membership habilitada
AND role = COMPANY_ADMIN
AND resource.tenant = membership.tenant
AND operación concreta expresamente permitida por la baseline
```

Para mantenimiento, pertenecer al tenant no concede ejecución inicial.

Las escrituras de `COMPANY_ADMIN` sobre revisiones, respuestas o evidencias deben estar ligadas a:

- una corrección autorizada de un mantenimiento finalizado; o
- una resolución de conflicto autorizada.

---

## 12.4 `TECHNICIAN`

Para un recurso client-scoped:

```text
membership habilitada
AND role = TECHNICIAN
AND resource.tenant = membership.tenant
AND UserClientAccess(membership, resource.client)
```

El acceso a recursos derivados debe comprobarse por su ownership, no por IDs afirmados por frontend.

La ejecución inicial de mantenimiento corresponde a `TECHNICIAN` dentro de este alcance aprobado.

---

## 12.5 Recursos tenant-wide consumidos por técnico

Para tipos/formularios necesarios en operaciones autorizadas, la lectura debe derivarse de la relación real con recursos de clientes permitidos.

No debe aplicarse como atajo:

```text
TECHNICIAN pertenece al tenant
→ puede leer todos los formularios tenant
```

si esos datos no son necesarios para sus clientes autorizados.

---

## 12.6 `SUPER_ADMIN`

La lógica conceptual debe ser:

```text
SUPER_ADMIN
AND grant vigente
AND grant.tenant = resource.tenant
AND client incluido cuando corresponda
AND scope requerido concedido
```

No:

```text
SUPER_ADMIN
→ true
```

---

## 12.7 Ownership encadenado

Las políticas futuras deben poder seguir ownership suficiente para verificar relaciones.

Ejemplos:

```text
Evidence
→ Response
→ MaintenanceRevision
→ MaintenanceRecord
→ Equipment
→ Client
```

```text
ReportVersion
→ Report
→ Client
```

---

## 12.8 Lecturas y escrituras

RLS deberá controlar tanto:

- visibilidad del estado existente;
- como validez del estado resultante.

Una autorización de lectura no debe implicar automáticamente autorización de escritura.

Tampoco una autorización para corregir debe implicar autorización para iniciar una ejecución.

---

## 12.9 RLS no reemplaza otras invariantes

RLS responde principalmente:

> ¿Puede este actor operar sobre estas filas y mediante esta clase de operación?

No sustituye:

- reglas de dominio;
- integridad referencial;
- inmutabilidad;
- idempotencia;
- serialización de operaciones críticas;
- verificación de webhooks;
- aislamiento local offline.

Estas defensas deben complementarse.

---

# 13. Defensa ante referencias cruzadas

## 13.1 Cambio manual de `client_id`

Ataque:

> técnico autorizado para Client A intenta enviar `client_id = Client B`.

Defensas:

- RLS verifica `UserClientAccess` sobre el cliente real;
- ownership parent debe ser coherente;
- backend valida relaciones;
- el frontend puede prevenir la acción por UX, pero no constituye control de seguridad.

---

## 13.2 `equipment_id` de otro cliente

Ataque:

> request aparenta crear mantenimiento para Client A, pero usa un `Equipment` de Client B.

La autorización debe derivar el cliente desde `Equipment`.

No debe confiarse en dos IDs independientes y asumir que coinciden.

La creación de una ejecución inicial sólo debe ser aceptada para un actor cuya baseline autorice esa operación, como `TECHNICIAN` dentro de su cliente autorizado.

---

## 13.3 Ubicación cruzada

Ataque:

> asociar un equipo de Client A a una `Location` de Client B.

Debe rechazarse aunque ambos clientes pertenezcan al mismo tenant.

También debe rechazarse si pertenecen a tenants diferentes.

---

## 13.4 `FormVersion` de otro tenant

Una versión utilizada por mantenimiento debe pertenecer al tenant compatible.

No puede utilizarse una versión arbitraria conocida por UUID.

La futura validación de aplicabilidad debe respetar las decisiones aún abiertas `DM-OPEN-002` y `DM-OPEN-003`.

---

## 13.5 Evidencia sobre respuesta ajena

Ataque:

> subir un archivo y asociarlo al ID de una respuesta fuera del alcance.

Debe comprobarse:

- ownership de `Response`;
- maintenance/client derivados;
- actor autorizado;
- estado mutable aplicable;
- tipo de operación autorizada para ese actor;
- ownership del objeto Storage.

Para `COMPANY_ADMIN`, una escritura de evidencia sólo puede ocurrir dentro de una corrección o resolución de conflicto autorizada.

---

## 13.6 Informe de otro tenant/cliente

Un request de generación no determina el tenant ni el cliente.

El `Report` y sus fuentes deben ser compatibles con:

- tenant del actor;
- cliente autorizado;
- período y reglas de reporting aprobadas posteriormente.

---

## 13.7 Manipulación con DevTools

Modificar selects, campos ocultos, rutas, IDs o payloads no debe cambiar el resultado de autorización.

Los controles de seguridad deben seguir funcionando fuera de la UI.

---

# 14. Inserts y updates

## 14.1 Creación

Antes de aceptar una creación deben verificarse conceptualmente:

- actor;
- tenant efectivo;
- rol;
- que el rol tenga expresamente permitida esa clase de creación;
- client scope;
- ownership de cada referencia;
- compatibilidad entre referencias;
- estado actual de las entidades parent;
- reglas de mutabilidad;
- transición permitida.

En mantenimiento, la posibilidad de crear una ejecución inicial no se deriva de la mera capacidad administrativa sobre el tenant.

---

## 14.2 Actualización

Una actualización debe validar:

1. que el actor puede acceder al recurso actual;
2. que puede realizar esa clase concreta de modificación;
3. que el estado resultante sigue perteneciendo al mismo ownership válido;
4. que no introduce referencias cruzadas;
5. que no modifica atributos conceptualmente inmutables.

Para `COMPANY_ADMIN`, una modificación de respuestas/evidencias de mantenimiento debe estar contextualizada en una corrección autorizada o resolución de conflicto, nunca en una ejecución inicial no aprobada.

---

## 14.3 Cambio de ownership

No debe permitirse mover un recurso entre tenants mediante un update normal.

Tampoco debe permitirse utilizar un update para mover silenciosamente recursos client-scoped entre clientes si la operación no forma parte explícita del dominio.

La administración de un recurso no implica derecho a romper su ownership histórico.

---

## 14.4 UI

Ocultar:

- botón;
- link;
- ruta;
- menú;
- formulario;

nunca es suficiente para autorizar.

La UI debe reflejar permisos para mejorar UX, pero la fuente remota debe rechazar solicitudes no autorizadas de todos modos.

En particular, aunque una UI defectuosa mostrara a `COMPANY_ADMIN` controles de ejecución inicial, la capa autoritativa debe rechazar esa operación mientras no exista permiso aprobado.

---

# 15. Inmutabilidad y autorización

Autorización y mutabilidad son dimensiones distintas.

Que un actor pueda leer o administrar un agregado no significa que pueda modificar cualquier estado histórico ni ejecutar operaciones no concedidas.

## 15.1 `FormVersion`

Una versión publicada es inmutable.

`COMPANY_ADMIN` autorizado:

- puede leerla;
- puede crear evolución mediante un nuevo borrador;
- no puede modificar la versión publicada.

---

## 15.2 `MaintenanceRevision`

Una revisión finalizada es inmutable.

Para `COMPANY_ADMIN`, la capacidad aprobada consiste en:

- consultar revisiones;
- iniciar una corrección sobre un mantenimiento finalizado;
- producir una nueva revisión como resultado de esa corrección;
- producir una nueva revisión como resultado de una resolución de conflicto autorizada.

Esto **NO** debe interpretarse como permiso para ejecutar o finalizar la primera ejecución del mantenimiento.

Para `TECHNICIAN`, la creación de la revisión correspondiente a la ejecución inicial y las revisiones posteriores permitidas se mantiene dentro de su alcance aprobado.

---

## 15.3 Evidencias

Una evidencia incluida en mantenimiento finalizado:

- no se elimina;
- no se sobrescribe.

Una corrección autorizada puede crear evidencia nueva y una relación de reemplazo visual.

Para `COMPANY_ADMIN`, esa escritura sólo existe dentro de una corrección o resolución de conflicto autorizada.

---

## 15.4 `ReportSnapshot`

Es inmutable.

Una regeneración crea snapshot nuevo.

---

## 15.5 `ReportVersion`

Una versión finalizada no se modifica.

Una regeneración crea otra versión.

---

## 15.6 Ledger IA

`AICreditLedgerEntry` es inmutable.

Compensar una operación no debe significar editar un movimiento histórico.

El protocolo exacto continúa abierto mediante `DO-T01`.

---

## 15.7 Auditoría

`AuditEvent` no puede eliminarse mediante operación normal.

Ni `COMPANY_ADMIN` ni soporte excepcional deben poseer una capacidad general de borrar historial de auditoría.

---

# 16. Supabase Storage

## 16.1 Principio

Un path es una organización técnica, no una autorización.

Nombres como:

```text
tenant-a/client-b/...
```

pueden facilitar organización, pero no sustituyen controles de acceso.

---

## 16.2 Ownership de archivos

Todo archivo privado debe poder vincularse a un recurso de dominio autorizado.

Por ejemplo:

```text
fotografía
→ Evidence/Response
→ MaintenanceRevision
→ MaintenanceRecord
→ Client
→ Tenant
```

o:

```text
PDF/DOCX
→ ReportVersion
→ Report
→ Client
→ Tenant
```

---

## 16.3 Lectura

Conocer el path o identificador de una evidencia de otro tenant no debe permitir leerla.

La autorización debe comprobar tenant, cliente y recurso.

---

## 16.4 Upload

Un usuario sólo puede confirmar/uploadear un archivo contra un recurso para el cual posee autorización y para una clase de operación que su rol pueda realizar.

No debe ser posible:

1. subir un archivo legítimamente;
2. enviar después un ID de respuesta ajena;
3. convertir ese upload en evidencia de otro tenant.

Para `COMPANY_ADMIN`, la asociación de evidencia a mantenimiento debe corresponder exclusivamente a una corrección o resolución de conflicto autorizada.

---

## 16.5 URLs

Una URL previamente obtenida no debe tratarse como prueba permanente de autorización.

La estrategia concreta de acceso temporal o privado se definirá junto con Storage sin crear buckets públicos para evidencias privadas.

---

## 16.6 Archivos offline

Antes de confirmación remota:

- la fotografía sigue siendo parte de la réplica local;
- permanece aislada por identidad;
- no se considera almacenada remotamente;
- su posterior sincronización vuelve a someterse a las reglas de autorización vigentes aplicables.

El protocolo exacto pertenece a `04-offline-sync-strategy.md`.

---

# 17. `service-role`

## 17.1 Restricciones absolutas

`service-role`:

- sólo puede utilizarse server-side;
- nunca debe llegar al navegador;
- nunca debe incluirse en la PWA;
- nunca debe almacenarse en IndexedDB;
- nunca debe formar parte de código público;
- nunca debe utilizarse como mecanismo rutinario para que usuarios tenant accedan a sus datos.

---

## 17.2 Principio de mínimo privilegio

Siempre que una operación pueda ejecutarse de forma segura bajo el contexto normal del usuario y RLS, debe preferirse ese camino.

Usar backend confiable no implica necesariamente usar `service-role`.

---

## 17.3 Usos conceptualmente legítimos

Puede existir necesidad de privilegio elevado para procesos como:

- alta inicial de un tenant;
- coordinación del alta del primer administrador;
- operaciones internas de identidad que requieran privilegios administrativos;
- cierre/revocación efectiva de sesiones;
- procesamiento verificado de webhooks;
- reconciliación comercial interna;
- operaciones transaccionales especiales del ledger IA;
- procesos internos de numeración oficial de informes cuando el diseño físico lo requiera;
- procesos de plataforma claramente independientes de una sesión tenant.

Esta lista no obliga a usar `service-role` en todos esos casos.

---

## 17.4 Operaciones iniciadas por usuario

Si una operación de usuario pasa por un contexto que evita RLS, el backend debe reconstruir y verificar explícitamente:

- identidad;
- membership/grant;
- tenant;
- cliente;
- scope;
- rol;
- operación concreta autorizada;
- mutabilidad;
- estado comercial cuando corresponda.

`service-role` nunca puede transformar:

```text
request autenticado
```

en:

```text
request autorizado
```

por sí solo.

Para `COMPANY_ADMIN`, un backend privilegiado tampoco puede ampliar silenciosamente el alcance hacia ejecución inicial de mantenimiento.

## 17.5 Frontera Auth purpose-specific de ADR-0019

ADR-0019, con estado `ACCEPTED`, aprueba una excepción Auth estrecha para el lifecycle Identity/Auth:

```text
VerificationChallenge = platform-owned
SessionGrant = platform-owned

Postgres Custom Access Token Hook
+ minimum explicit permissions to supabase_auth_admin
+ purpose-specific Auth Admin
```

`supabase_auth_admin` sólo puede recibir acceso mínimo, explícito y purpose-specific al estado platform-owned estrictamente necesario para el hook. Esos permisos no son privilegios tenant, no convierten a `supabase_auth_admin` en actor tenant y no habilitan reads/writes tenant ordinarios ni bypass de RLS tenant.

Auth Admin permanece server-side, purpose-specific y limitado a las operaciones aprobadas por ADR-0019. No existe un Supabase Admin client genérico reutilizable por módulos arbitrarios, ninguna credencial privilegiada llega al browser/PWA y una secret key o backend credential nunca se convierte en client ordinario de requests.

Esta frontera Auth no puede utilizarse para inferir `CompanyMembership`, tenant role o Client scope; convertir `SUPER_ADMIN` en tenant member; sustituir ADR-0003 por claims o sesión Auth; ni obtener lectura o escritura genérica sobre datos tenant-owned. RLS continúa siendo la frontera primaria de aislamiento remoto para datos tenant-owned y una sesión Auth válida no equivale a autorización tenant.

---

# 18. Estado comercial de la suscripción

## 18.1 Separación conceptual

El acceso online de un usuario tenant requiere combinar:

```text
identidad válida
+ membership habilitada
+ rol/permisos
+ tenant/client scope
+ estado comercial que permita acceso
```

El estado comercial es una condición adicional.

No reemplaza el aislamiento tenant.

---

## 18.2 Suscripción inactiva

Cuando la suscripción está inactiva:

- los usuarios del tenant pierden acceso online;
- los datos no se eliminan;
- ownership no cambia;
- memberships no desaparecen;
- historiales se conservan.

---

## 18.3 Período de gracia

Durante el período de gracia de 20 días aplicable según la baseline, la empresa conserva acceso.

La cuestión `DO-076` sobre la primera obligación paga tras el año promocional permanece abierta.

---

## 18.4 Comprobación dinámica

El derecho comercial para operaciones online debe basarse en estado autoritativo vigente.

No debe depender exclusivamente de:

- UI;
- valor almacenado en navegador;
- dato local sin revalidar;
- una afirmación enviada por frontend.

El diseño físico podrá integrar esta comprobación en la frontera de datos y/o backend, pero debe impedir que una llamada manual directa evite la suspensión.

---

## 18.5 Separación de procesos internos

Los procesos internos necesarios para:

- reconocer pagos;
- reactivar un tenant;
- procesar webhooks;

no pueden quedar bloqueados por el mismo gate que suspende a usuarios tenant, porque son precisamente los que pueden modificar el estado comercial.

Esto no concede acceso tenant operativo a esos procesos más allá de su función interna.

---

# 19. Revocación de usuarios y permisos

## 19.1 Membership deshabilitada

Una membership deshabilitada debe perder acceso online.

No se elimina:

- `PlatformUser`;
- historial;
- auditoría;
- datos técnicos creados anteriormente.

---

## 19.2 Revocación de cliente

Cuando se elimina un `UserClientAccess` de un técnico:

- deja de poder leer remotamente ese cliente;
- deja de poder iniciar nuevas operaciones online contra el cliente;
- deja de poder sincronizar operaciones nuevas como si siguiera autorizado;
- la existencia previa de un ID o copia local no reautoriza el acceso.

El tratamiento exacto de trabajo ya capturado y pendiente se definirá en la estrategia offline preservando DO-075.

---

## 19.3 Cambio de rol

Un cambio de rol debe aplicarse desde el estado autoritativo vigente.

No debe bastar con que una sesión conserve un rol antiguo en memoria o UI.

---

## 19.4 Revocación de soporte

Un `SupportAccessGrant` revocado deja de ser válido para solicitudes posteriores.

Los accesos anteriormente efectuados permanecen auditados.

---

## 19.5 Revocación efectiva de autorización y sesiones provider-side

La baseline reformulada distingue dos defensas complementarias con garantías diferentes.

### Defensa primaria — revocación efectiva de autorización

Una revocación, deshabilitación o reducción de alcance debe retirar inmediatamente toda autorización online afectada mediante estado autoritativo vigente.

Toda operación online sensible debe evaluar según estado vigente, cuando corresponda:

- membership;
- rol;
- `UserClientAccess`;
- `SupportAccessGrant`;
- tenant y ownership;
- demás condiciones autoritativas aplicables.

Una sesión Auth o access JWT residual no conserva autorización revocada. La seguridad no puede depender de esperar logout, refresh o `exp`.

### Defensa adicional — terminación provider-side

Las sesiones y credenciales renovables afectadas deben terminarse mediante mecanismos públicos, soportados y contractualmente adecuados cuando exista una primitiva apropiada para el caso.

Esta segunda defensa:

- no es la frontera primaria de datos;
- no puede reemplazar RLS/autorización vigente;
- no puede provocar rollback de una revocación si falla o no está disponible;
- no autoriza utilizar `updateUserById(...password...)`, mutación directa de `auth.sessions`, almacenamiento de JWT ajenos, APIs no documentadas ni internals por inferencia;
- no permite tratar `ban_duration` como equivalente contractual de global sign-out sin una decisión posterior basada en un contrato soportado.

La reformulación de producto/seguridad fue aprobada humanamente y, después de completar CORR-005 y su revisión humana posterior, `DO-T03` fue cerrado mediante decisión humana separada: `DO-T03 = RESUELTO/APROBADO`. Las decisiones físicas de implementación permanecen para `ADR-0003` y/o tareas posteriores según corresponda.

---

# 20. Autorización offline

## 20.1 DO-075 permanece cerrada

Se mantiene exactamente:

- autorización offline máxima de 7 días desde la última validación online;
- superado el máximo, no pueden iniciarse nuevas operaciones;
- se requiere conexión y revalidación;
- una revocación conocida por el servidor debe aplicarse al recuperar conectividad;
- trabajo ya capturado no se elimina.

---

## 20.2 Límite de RLS

RLS protege la fuente remota.

No puede retirar mágicamente información que:

- ya fue descargada;
- permanece en IndexedDB;
- está en un dispositivo sin conexión.

Por ello:

> aislamiento remoto y protección local son controles diferentes.

---

## 20.3 Autorización local

La autorización local debe representar una validación online previa y su vigencia.

No convierte el dispositivo en autoridad.

Vencidos los 7 días:

- se bloquea el inicio de nuevas operaciones;
- los datos ya capturados se conservan.

---

## 20.4 Reconexión

Al reconectar se debe revalidar:

- identidad;
- membership;
- rol;
- clientes autorizados;
- estado comercial;
- demás condiciones relevantes.

Una revocación vigente prevalece sobre el estado local anterior.

---

## 20.5 Trabajo pendiente

Que una autorización haya expirado o sido revocada no significa que el sistema deba borrar datos.

También implica que el dispositivo no puede asumir automáticamente que toda operación pendiente todavía puede aplicarse remotamente.

La política concreta para:

- presentar;
- retener;
- revalidar;
- sincronizar;
- rechazar;
- reconciliar

trabajo capturado antes de la revocación pertenece a `04-offline-sync-strategy.md`.

---

# 21. Logout y dispositivo compartido

## 21.1 Aislamiento por identidad

Los datos locales deben estar asociados a la identidad que los obtuvo o creó.

Otro usuario del mismo dispositivo no puede reutilizar:

- clientes;
- equipos;
- formularios;
- mantenimientos;
- respuestas;
- fotografías;
- outbox

de la identidad anterior.

Esto aplica aunque ambos usuarios pertenezcan al mismo tenant o tengan clientes comunes.

---

## 21.2 Logout

Logout:

- finaliza el contexto activo del usuario;
- no convierte su réplica en datos compartidos;
- no habilita al siguiente usuario a abrirla;
- no debe eliminar automáticamente trabajo pendiente si conservarlo es técnicamente necesario.

---

## 21.3 Datos pendientes

Conservar datos localmente no equivale a mantener autorización activa.

Una futura sesión de la misma identidad debe volver a satisfacer las reglas de autorización necesarias antes de operar remotamente.

La estructura Dexie concreta queda fuera de este documento.

---

# 22. Operaciones privilegiadas

Algunas operaciones requieren coordinación en backend confiable, autoridad de plataforma o consistencia transaccional superior a una mutación directa normal.

## 22.1 Alta inicial

- creación de `MaintenanceCompany`;
- alta del primer `COMPANY_ADMIN`;
- coordinación del desafío de verificación.

Son operaciones de plataforma.

---

## 22.2 Sesiones

El cierre forzado/revocación de sesiones probablemente requiere una operación server-side privilegiada.

`DO-T03 = RESUELTO/APROBADO` fija la semántica conceptual de seguridad y revocación. El mecanismo físico concreto de terminación provider-side, cuando corresponda, queda para `ADR-0003` y/o tareas posteriores de implementación, sin seleccionar aquí una primitiva concreta.

---

## 22.3 Informes

La asignación del número oficial correlativo debe protegerse contra concurrencia.

El mecanismo físico se definirá en reporting/esquema, no aquí.

---

## 22.4 Webhooks

Procesamiento de Mercado Pago:

- se inicia server-side;
- verifica autenticidad;
- debe ser idempotente;
- no depende de una sesión de usuario tenant.

---

## 22.5 Créditos IA

Reserva, confirmación o compensación de créditos pueden necesitar una operación transaccional confiable.

El protocolo exacto depende de `DO-T01`.

---

## 22.6 IA

La llamada a OpenAI:

- siempre es server-side;
- requiere autorización previa de `COMPANY_ADMIN`;
- requiere contexto tenant correcto;
- no debe delegarse al navegador.

---

## 22.7 Soporte

Si una operación excepcional de soporte requiere backend privilegiado, el backend debe volver a comprobar el `SupportAccessGrant`.

La presencia de credenciales privilegiadas no sustituye el grant.

---

# 23. Matriz conceptual RLS por agregado/recurso

| Recurso | Tenant-owned | Client-scoped | `COMPANY_ADMIN` | `TECHNICIAN` | `SUPER_ADMIN` normal | `SUPER_ADMIN` con grant | Inmutabilidad especial |
|---|---:|---:|---|---|---|---|---|
| `MaintenanceCompany` | No como dato tenant normal | No | Su tenant | Contexto mínimo | Gestión global autorizada | N/A | No |
| `CompanyMembership` | Sí | No | Administra su tenant | Sólo contexto propio | Sólo onboarding inicial donde aplique | Scope usuarios/permisos, sin CRUD extra inferido | Historial conservado |
| `UserClientAccess` | Sí | Relaciona cliente | Administra dentro del tenant | Lee/consume propio alcance | No | Scope usuarios/permisos | Cambios auditados |
| `SupportAccessGrant` | Sí | Parcialmente | Concede/modifica/revoca | No | No acceso por defecto | Consume su propio grant | Cambios auditados |
| `Client` | Sí | Sí | Administrar | Leer autorizado | No | Sólo clientes concedidos + scope | No |
| `Location` | Sí | Sí | Administrar | Leer por cliente autorizado | No | Cliente + scope ubicaciones | Coherencia jerárquica |
| `EquipmentType` | Sí | No | Administrar | Lectura derivada necesaria | No | Lectura derivada cuando corresponda | No |
| `Equipment` | Sí | Sí | Administrar | Leer por cliente autorizado | No | Cliente + scope equipos | Relaciones coherentes |
| `FormTemplate` | Sí | No | Administrar | Lectura operativa derivada | No | Acceso derivado del scope; no administración inferida | Archivo preserva históricos |
| `FormVersion` | Sí | No directamente | Administrar borradores/publicar | Leer aplicables/históricas necesarias | No | Scope formularios/respuestas cuando corresponda | Publicada inmutable |
| `FormField` | Sí | No directamente | Mediante versión borrador | Leer versión autorizada | No | Scope formulario correspondiente | Inmutable tras publicación |
| `MaintenanceRecord` | Sí | Sí | Leer; corregir finalizados mediante nueva revisión; resolver conflictos dentro de su alcance; no ejecución inicial inferida | Leer; iniciar/realizar/finalizar dentro de clientes autorizados; corregir; resolver conflictos | No | Cliente + scope mantenimientos | Historia por revisiones |
| `MaintenanceRevision` | Sí | Sí | Leer; crear sólo como resultado de corrección autorizada o resolución de conflicto | Leer; crear conforme a ejecución inicial, corrección o resolución autorizadas | No | Derivado del maintenance scope | Finalizada inmutable |
| `Response` | Sí | Sí | Leer; crear/modificar sólo dentro de corrección autorizada o resolución de conflicto | Crear/modificar en ejecución inicial, corrección o resolución autorizadas; leer históricas | No | Scope formularios/respuestas + mantenimiento autorizado | Histórica preservada |
| `Evidence` | Sí | Sí | Leer; crear sólo dentro de corrección autorizada o resolución de conflicto; reemplazo visual permitido en ese contexto | Crear en ejecución inicial/corrección/resolución autorizadas; leer; reemplazo visual | No | Scope evidencias + recurso autorizado | Finalizada no eliminable |
| `EvidenceReplacementRelation` | Sí | Sí | Crear sólo dentro de corrección o resolución autorizada | Crear dentro de corrección/resolución autorizada | No | Sólo cuando scopes necesarios lo permitan | Original siempre preservada |
| `SyncConflict` remoto | Sí | Derivado | Resolver dentro de su alcance | Resolver mantenimiento en cliente autorizado | No | No se infiere resolución | Historial de resolución |
| `ReportTemplate` | Sí | No | Administrar | No | No | No se infiere administración | Según especificación futura |
| `Report` | Sí | Sí | Crear/administrar/finalizar/regenerar informes usando fuentes autorizadas | No | No | Cliente + scope informes | Número estable tras asignación |
| `ReportVersion` | Sí | Sí | Crear mediante finalización/regeneración de informe | No | No | Scope informes | Finalizada inmutable |
| `ReportSnapshot` | Sí | Sí | Crear mediante generación de informe | No | No | Scope informes | Inmutable |
| `ReportFileArtifact` | Sí | Sí | Acceso por informe | No | No | Scope informes | Asociado a versión |
| `AIUsageOperation` | Sí | Derivado del informe/tenant | Crear/usar | No | No | No | IA no modifica datos técnicos |
| `AICreditLedgerEntry` | Sí | No | Administrar mediante operaciones aprobadas | No | No | Scope créditos IA | Inmutable |
| `Subscription` | Sí | No | Administrar | No administrar | No normal | Scope suscripción/pagos | No elimina tenant |
| `PaymentEvent` conciliado | Sí | No | Consulta/admin según futura spec | No | Proceso plataforma según función | Scope suscripción/pagos para soporte | Procesamiento idempotente |
| `AuditEvent` tenant | Sí | Depende del evento | Generación automática de eventos | Generación cuando corresponda | Eventos globales/soporte | Uso efectivo siempre auditable | No eliminable por operación normal |

---

# 24. Reglas de referencia entre entidades

Estas reglas deben preservarse independientemente de cómo se diseñen físicamente las tablas.

## 24.1 Membership y clientes

`UserClientAccess` requiere:

```text
CompanyMembership.tenant
=
Client.tenant
```

Un `COMPANY_ADMIN` no puede introducir un acceso cross-tenant.

---

## 24.2 Ubicaciones

`Location.client` pertenece al mismo tenant que la ubicación.

Si existe parent:

```text
Location.client
=
ParentLocation.client
```

y, por consecuencia, el tenant también coincide.

---

## 24.3 Equipos

Un `Equipment` pertenece a un `Client`.

Si existe `Location`:

```text
Equipment.client
=
Location.client
```

`EquipmentType`, si existe según las cardinalidades que finalmente se aprueben, debe pertenecer al mismo tenant.

`DM-OPEN-001` permanece abierta.

---

## 24.4 Formularios y equipos

Un formulario asociado a un tipo/equipo debe pertenecer al mismo tenant.

La cardinalidad exacta continúa abierta mediante `DM-OPEN-002`.

El comportamiento cuando no existe formulario aplicable continúa abierto mediante `DM-OPEN-003`.

---

## 24.5 Mantenimiento

Debe existir coherencia entre:

- tenant;
- cliente;
- equipo;
- versión de formulario.

El cliente debe derivarse del equipo, no de un parámetro independiente no verificado.

La `FormVersion` debe pertenecer al tenant correcto y satisfacer las reglas de aplicabilidad que se aprueben posteriormente.

La clase de operación también debe corresponder al actor:

- `TECHNICIAN` puede ejecutar la operación inicial dentro de clientes autorizados;
- `COMPANY_ADMIN` puede consultar, corregir finalizados y resolver conflictos, pero no se le infiere ejecución inicial.

---

## 24.6 Respuestas

Una `Response` debe corresponder:

- al mantenimiento/revisión correcta;
- a un `FormField` de la versión exacta utilizada por ese mantenimiento;
- al contexto correcto de repeatable/matriz cuando corresponda.

No puede utilizarse un `FormField` de otra versión sólo porque tenga igual etiqueta.

Para `COMPANY_ADMIN`, crear/modificar una respuesta de mantenimiento sólo es válido dentro de una corrección autorizada o resolución de conflicto.

---

## 24.7 Evidencias

Una `Evidence` debe pertenecer a una `Response` autorizada.

Una relación de reemplazo visual debe conservar una cadena de ownership coherente y nunca servir como enlace hacia evidencia de otro tenant/cliente.

Para `COMPANY_ADMIN`, la creación de evidencia o relación de reemplazo debe formar parte de una corrección o resolución autorizada.

---

## 24.8 Informes

Un `Report` pertenece a:

- un tenant;
- un cliente.

Todas sus versiones y snapshots heredan ese ownership.

Los datos incorporados al snapshot deben pertenecer al cliente/tenant correspondientes.

Este documento no resuelve:

- `DM-OPEN-005`;
- `DM-OPEN-006`;
- `DM-OPEN-008`.

---

## 24.9 IA y créditos

Una `AIUsageOperation` sólo puede iniciarse:

- por `COMPANY_ADMIN`;
- para su tenant;
- en contexto de informes.

Los movimientos asociados deben corresponder al mismo tenant.

El protocolo exacto continúa bajo `DO-T01`.

---

## 24.10 Pagos

Un `PaymentEvent` externo no debe producir cambios tenant hasta determinar y verificar inequívocamente la entidad comercial correspondiente.

La state machine exacta permanece bajo `DO-T02`.

---

# 25. Auditoría de seguridad

## 25.1 Eventos mínimos obligatorios

Deben dejar traza:

- alta de usuario;
- deshabilitación/revocación;
- reintegración;
- cambio de rol;
- cambio de clientes autorizados;
- concesión de soporte;
- modificación de soporte;
- revocación de soporte;
- uso efectivo del acceso excepcional.

---

## 25.2 Contenido mínimo

Cada evento debe permitir identificar:

- actor;
- empresa afectada;
- acción;
- momento;
- alcance.

Cuando corresponda debe además identificar:

- cliente;
- scope de soporte;
- sujeto afectado;
- recurso suficiente para trazabilidad.

---

## 25.3 Actor real

El actor no debe aceptarse desde un campo libre enviado por frontend.

Debe derivarse del contexto autenticado o del proceso interno que ejecutó la operación.

---

## 25.4 No eliminable

Los eventos no son eliminables mediante operación normal.

No debe existir un permiso de convenience para que un admin borre su propia auditoría.

---

## 25.5 Auditoría frente a historia de dominio

No deben confundirse:

- `AuditEvent`;
- `MaintenanceRevision`;
- `FormVersion`;
- `ReportVersion`;
- `ReportSnapshot`;
- `AICreditLedgerEntry`;
- `PaymentEvent`.

Cada uno conserva historia por razones distintas.

---

# 26. Pruebas RLS obligatorias

Toda migración futura que modifique acceso debe incorporar pruebas RLS relevantes.

No basta con probar caminos positivos.

## 26.1 Actores mínimos para fixtures

Las suites futuras deberían disponer conceptualmente de:

- `COMPANY_ADMIN` tenant A;
- `TECHNICIAN` tenant A con Client A1;
- otro `TECHNICIAN` tenant A con alcance distinto;
- `COMPANY_ADMIN` tenant B;
- `TECHNICIAN` tenant B;
- `SUPER_ADMIN` sin grant;
- `SUPER_ADMIN` con grant limitado a tenant A;
- grant limitado a Client A1;
- grant con scopes parciales;
- usuario tenant deshabilitado.

Cuando se implemente suscripción deberá incluirse además un tenant inactivo.

---

## 26.2 Positivas

Verificar que:

- `COMPANY_ADMIN` puede operar las capacidades administrativas aprobadas de su tenant;
- `COMPANY_ADMIN` puede leer mantenimientos de su tenant cuando corresponda;
- `COMPANY_ADMIN` puede corregir un mantenimiento finalizado dentro de su alcance y producir una nueva revisión con sus respuestas/evidencias correspondientes;
- `COMPANY_ADMIN` puede resolver conflictos dentro de su alcance conforme a `RF-113`;
- `TECHNICIAN` puede leer clientes autorizados;
- `TECHNICIAN` puede leer todas las ubicaciones/equipos de cliente autorizado;
- `TECHNICIAN` puede iniciar/realizar/finalizar mantenimiento autorizado;
- `TECHNICIAN` puede capturar respuestas/evidencias en la ejecución inicial;
- `TECHNICIAN` puede corregir mantenimiento autorizado;
- `TECHNICIAN` puede resolver conflictos autorizados;
- admin puede gestionar formularios;
- admin puede gestionar informes;
- `SUPER_ADMIN` con grant puede acceder exactamente a los scopes concedidos.

---

## 26.3 Negativas de capacidad de `COMPANY_ADMIN`

Verificar expresamente que, mientras la baseline no lo autorice:

- `COMPANY_ADMIN` no puede iniciar un mantenimiento nuevo;
- `COMPANY_ADMIN` no puede realizar/ejecutar la primera ejecución de un mantenimiento;
- `COMPANY_ADMIN` no puede finalizar la ejecución inicial;
- `COMPANY_ADMIN` no puede crear respuestas/evidencias como parte de una ejecución inicial;
- la pertenencia al tenant y el rol administrativo no bastan para superar estas denegaciones.

Estas pruebas deben coexistir con las positivas de corrección y resolución, evitando confundir una nueva `MaintenanceRevision` correctiva con una ejecución inicial.

---

## 26.4 Negativas cross-tenant

Verificar que:

- admin tenant A no lee tenant B;
- admin tenant A no actualiza tenant B;
- técnico tenant A no lee tenant B;
- tenant A no inserta referencias hacia tenant B;
- IDs válidos de tenant B no producen acceso.

---

## 26.5 Negativas por cliente

Verificar que:

- técnico con Client A1 no lee Client A2;
- no lee locations de A2;
- no lee equipment de A2;
- no lee maintenance de A2;
- no lee responses/evidence de A2;
- no crea mantenimiento para equipment de A2;
- no corrige mantenimiento de A2;
- no resuelve conflicto de A2.

---

## 26.6 Autoescalamiento

Verificar que técnico:

- no modifica su membership;
- no cambia su rol;
- no crea `UserClientAccess`;
- no amplía clientes autorizados;
- no introduce IDs cross-client para obtener acceso indirecto.

---

## 26.7 `SUPER_ADMIN`

Verificar que:

- sin grant no lee datos operativos tenant;
- grant Tenant A no habilita Tenant B;
- grant Client A1 no habilita Client A2;
- scope `informes` no habilita equipos;
- scope `equipos` no habilita evidencias;
- scope tenant-wide de créditos no habilita mantenimientos;
- un grant revocado deja de autorizar.

---

## 26.8 Usuarios deshabilitados

Verificar que una membership deshabilitada:

- no lee;
- no inserta;
- no actualiza;
- no mantiene acceso por poseer una sesión todavía presentada al backend.

La revocación efectiva de autorización debe probarse aunque una sesión Auth o access JWT residual continúe técnicamente presente. Cuando exista y se adopte posteriormente un mecanismo provider-side público y soportado para terminar sesiones/credenciales renovables, su comportamiento debe probarse por separado como defensa adicional; su fallo o indisponibilidad no puede convertir una operación revocada en autorizada.

---

## 26.9 Suscripción

Cuando se implemente:

- tenant activo opera normalmente;
- período de gracia aplicable conserva acceso;
- tenant inactivo pierde acceso online de usuario tenant;
- suspensión no elimina datos;
- procesos internos de reactivación siguen pudiendo producir el cambio autorizado.

---

## 26.10 Relaciones manipuladas

Probar intentos como:

- `client_id` manual;
- `equipment_id` cross-client;
- `location_id` cross-client;
- `parent_location_id` de otro cliente;
- `FormVersion` de otro tenant;
- `Response` sobre field incorrecto;
- `Evidence` sobre response ajena;
- `Report` sobre cliente ajeno;
- payload ejecutado fuera de la UI.

---

# 27. Estrategia de testing de seguridad

## 27.1 Tests unitarios

Cubrirán lógica pura de autorización/dominio cuando exista:

- interpretación de scopes;
- transiciones permitidas;
- derivación conceptual de permisos;
- reglas de mutabilidad;
- diferenciación entre ejecución inicial y corrección/resolución.

No sustituyen tests reales de RLS.

---

## 27.2 Tests RLS contra PostgreSQL/Supabase local

Son obligatorios para comprobar la frontera real.

Deben ejecutar operaciones bajo identidades distintas y verificar:

- filas visibles;
- filas invisibles;
- writes aceptados;
- writes rechazados;
- manipulación de relaciones;
- denegación de ejecución inicial a actores sin permiso expreso.

---

## 27.3 Tests de integración

Deben comprobar flujos completos:

```text
Auth
→ backend/Supabase
→ RLS
→ Storage cuando corresponda
```

Especial atención a:

- ejecución inicial por `TECHNICIAN`;
- corrección por `COMPANY_ADMIN` y `TECHNICIAN`;
- resolución de conflictos;
- evidencias;
- soporte;
- revocaciones;
- suscripción;
- operaciones privilegiadas.

---

## 27.4 Tests negativos

Los casos de denegación son requisitos de primera clase.

Una suite que sólo prueba:

> actor autorizado funciona

es insuficiente.

Debe incluir asimismo:

> actor administrativo no obtiene por inferencia una capacidad operativa no aprobada.

---

## 27.5 Regresión

Toda modificación de:

- membership;
- client access;
- ownership;
- RLS;
- Storage;
- soporte;
- suscripción;
- backend privilegiado;

debe ejecutar regresión de aislamiento cross-tenant, cross-client y de límites de capacidad por rol.

---

# 28. Anti-patrones prohibidos

Quedan expresamente prohibidos:

- desactivar RLS para simplificar desarrollo;
- confiar en filtros frontend;
- confiar únicamente en middleware;
- confiar en un `maintenance_company_id` enviado por navegador;
- confiar en `client_id` sin validar ownership;
- utilizar `service-role` para operaciones tenant normales;
- exponer `service-role` al cliente;
- exponer secretos de OpenAI;
- exponer credenciales privilegiadas de Mercado Pago;
- crear datos tenant-owned cuyo tenant no pueda derivarse inequívocamente;
- aceptar relaciones cross-tenant porque los UUID sean válidos;
- políticas equivalentes a permitir todo de manera indiscriminada;
- usar un `SUPER_ADMIN` omnipotente por comodidad;
- hacer que `SUPER_ADMIN` pase RLS simplemente por su rol global;
- confiar únicamente en claims/cache que puedan quedar obsoletos para revocaciones críticas;
- utilizar buckets públicos para evidencias privadas;
- tratar un path de Storage como autorización;
- codificar permisos únicamente en botones/UI;
- permitir a técnico modificar su propio alcance;
- permitir que una corrección sobrescriba historia;
- permitir que un proceso con `service-role` omita el tenant de una operación;
- asumir que estar autenticado equivale a tener suscripción activa;
- asumir que RLS puede proteger datos ya replicados offline;
- inferir que `COMPANY_ADMIN` puede ejecutar una primera intervención de mantenimiento sólo por administrar el tenant;
- reutilizar permisos de corrección/resolución para habilitar una ejecución inicial no aprobada.

---

# 29. Relación con documentos posteriores

## 29.1 Esquema físico

El futuro diseño físico deberá concretar:

- representación de ownership;
- referencias;
- integridad cross-tenant;
- estrategia para comprobar membership;
- estrategia para comprobar client scope;
- estrategia para diferenciar operaciones iniciales de correcciones/resoluciones cuando afecte a autorización;
- representación de support grants;
- índices necesarios;
- políticas RLS;
- pruebas.

No debe alterar esta estrategia sin actualizar primero la documentación y, si corresponde, un ADR.

---

## 29.2 `04-offline-sync-strategy.md`

Debe concretar:

- partición local por identidad;
- estado de autorización offline;
- fecha de última validación;
- revalidación;
- revocación conocida;
- tratamiento de outbox tras revocación;
- sincronización de trabajo capturado;
- logout;
- protección local;
- `DO-T04`.

No puede modificar DO-075.

---

## 29.3 `05-form-engine-spec.md`

Debe concretar:

- aplicabilidad de formularios;
- permisos de administración;
- datos requeridos por técnico;
- inmutabilidad de versiones;
- `DM-OPEN-002`;
- `DM-OPEN-003`;
- `DM-OPEN-004`.

---

## 29.4 `06-maintenance-evidence-spec.md`

Debe concretar:

- ejecución inicial aprobada para `TECHNICIAN`;
- finalización;
- corrección;
- capacidades específicas de `COMPANY_ADMIN` en correcciones y conflictos;
- ownership de respuestas;
- ownership de evidencias;
- reemplazo visual;
- reglas Storage;
- permisos de conflicto.

No podrá otorgar a `COMPANY_ADMIN` ejecución inicial sin una decisión explícita de producto que modifique la baseline.

---

## 29.5 `07-reporting-engine-spec.md`

Debe concretar:

- ownership de informes;
- plantillas;
- snapshots;
- numeración;
- generación de archivos;
- uso autorizado de mantenimientos como fuente;
- `DM-OPEN-005`;
- `DM-OPEN-006`;
- `DM-OPEN-008`;
- `DO-077`.

---

## 29.6 `08-ai-credits-spec.md`

Debe concretar:

- autorización exclusiva de `COMPANY_ADMIN`;
- ledger;
- idempotencia;
- compensación;
- `DO-T01`;
- `DM-OPEN-007`.

---

## 29.7 `09-subscriptions-payments-spec.md`

Debe concretar:

- entitlement;
- pagos;
- estado activo/inactivo;
- gracia;
- reactivación;
- webhooks;
- `DO-076`;
- `DO-078`;
- `DO-T02`.

---

## 29.8 ADRs

Las decisiones arquitectónicas aprobadas que afecten de forma duradera la estructura del sistema deben formalizarse posteriormente mediante ADR.

Este documento no crea esos ADRs.

---

# 30. Decisiones candidatas a ADR

## `ADR-CAND-SEC-01` — RLS como frontera primaria de datos tenant

**Motivo:** afecta de forma transversal todo el modelo de persistencia y seguridad.

**Candidata a ADR:** sí.

---

## `ADR-CAND-SEC-02` — Identidad + membership + acceso por cliente

**Motivo:** define la arquitectura de autorización normal de usuarios tenant y la ausencia de permisos por equipo/mantenimiento.

**Candidata a ADR:** sí.

---

## `ADR-CAND-SEC-03` — Soporte excepcional mediante `SupportAccessGrant`

**Motivo:** evita convertir `SUPER_ADMIN` en bypass global y define scopes excepcionales.

**Candidata a ADR:** sí.

---

## `ADR-CAND-SEC-04` — Separación de autorización online y offline

**Motivo:** RLS sólo controla fuente remota mientras la PWA conserva datos y permisos temporalmente offline.

**Candidata a ADR:** sí.

Debe respetar DO-075 sin reabrirla.

---

## `ADR-CAND-SEC-05` — Uso restringido de `service-role`

**Motivo:** un bypass privilegiado mal utilizado anularía la arquitectura de aislamiento.

**Candidata a ADR:** sí.

---

## `ADR-CAND-SEC-06` — Invalidación efectiva de sesiones

**Motivo:** afecta Auth, RLS, revocación, UX y sincronización.

**Candidata a ADR:** sí, una vez resuelto `DO-T03`.

---

## `ADR-CAND-SEC-07` — Defensa de integridad cross-tenant

**Motivo:** el futuro esquema deberá combinar RLS e integridad relacional para impedir relaciones manipuladas.

**Candidata a ADR:** evaluar al realizar el diseño físico. Si la solución resulta una convención transversal no trivial, debe documentarse.

---

# 31. Riesgos

## 31.1 Riesgos ya definidos en `01-product-definition.md`

### `RSK-001` — Fuga entre tenants

Tratamiento:

- RLS;
- ownership inequívoco;
- tests cross-tenant.

### `RSK-002` — Permisos de cliente mal derivados

Tratamiento:

- `UserClientAccess`;
- herencia desde cliente;
- pruebas negativas cross-client.

### `RSK-003` — Soporte convertido en bypass

Tratamiento:

- grants explícitos;
- scopes;
- revocación;
- auditoría;
- ausencia de regla universal para `SUPER_ADMIN`.

### `RSK-004` — Revocación no corta autorización efectivamente

Tratamiento:

- membership, rol, client access y grants vigentes como estado autoritativo online;
- RLS/autorización vigente como frontera primaria de datos;
- una sesión Auth o access JWT residual no conserva autorización revocada;
- terminación provider-side únicamente mediante mecanismos públicos soportados cuando sean aplicables;
- fallo o inexistencia de esa segunda defensa no produce rollback de autorización;
- `DO-T03`;
- DO-075 para offline.

### `RSK-008` — Dispositivo compartido

Tratamiento:

- aislamiento local por identidad;
- coordinación con `DO-T04`.

### `RSK-015` — Suscripción versus offline

Tratamiento:

- entitlement online separado;
- autorización offline limitada a 7 días.

---

## 31.2 Riesgos derivados de esta estrategia

### `SEC-RSK-001` — Confiar en estado de autorización obsoleto

Si rol, membership, client access o grant se copian a un contexto que no se revalida, una revocación podría tardar en hacerse efectiva.

**Tratamiento:** la frontera de datos debe utilizar estado autoritativo vigente para autorización sensible.

---

### `SEC-RSK-002` — Bypass por `service-role`

Un handler server-side podría introducir fugas aunque RLS esté correctamente diseñado.

**Tratamiento:** mínimo privilegio, comprobación manual obligatoria en operaciones iniciadas por usuario y tests específicos.

---

### `SEC-RSK-003` — Referencias cross-tenant válidas individualmente

Dos UUID pueden existir y ser válidos pero pertenecer a tenants/clientes incompatibles.

**Tratamiento:** validar relación, no sólo existencia.

---

### `SEC-RSK-004` — Fuga por recursos tenant-wide usados por clientes

`EquipmentType`, `FormTemplate` y `FormVersion` pueden ser tenant-wide mientras el técnico tiene alcance por cliente.

Una política excesivamente amplia podría revelar definiciones innecesarias del tenant.

**Tratamiento:** lectura derivada desde recursos autorizados cuando corresponda.

---

### `SEC-RSK-005` — Composición incorrecta de scopes de soporte

Un scope de mantenimiento podría convertirse accidentalmente en acceso a respuestas, evidencias o informes.

**Tratamiento:** cada recurso comprueba su propio scope.

---

### `SEC-RSK-006` — URL de Storage como capability permanente

Un path o URL filtrado podría evitar futuras revocaciones si se trata como acceso público.

**Tratamiento:** Storage privado y autorización asociada a ownership.

---

### `SEC-RSK-007` — Suspensión aplicada sólo en UI

Un usuario podría continuar llamando APIs manualmente.

**Tratamiento:** entitlement autoritativo en la frontera de acceso online.

---

### `SEC-RSK-008` — Revocación remota confundida con borrado local

Intentar solucionar revocación eliminando datos offline podría provocar pérdida de trabajo.

**Tratamiento:** separar autorización de conservación local; respetar DO-075.

---

### `SEC-RSK-009` — Auditoría incompleta del soporte

Un grant correctamente registrado sin registrar su uso efectivo no cumple la baseline.

**Tratamiento:** evento de acceso efectivo obligatorio.

---

### `SEC-RSK-010` — Proceso privilegiado sin contexto tenant

Webhooks, IA, créditos o procesos internos podrían modificar el tenant equivocado.

**Tratamiento:** tenant objetivo explícitamente resuelto desde fuentes autoritativas y operaciones idempotentes/transaccionales cuando corresponda.

---

### `SEC-RSK-011` — Ampliación accidental de permisos de `COMPANY_ADMIN` en mantenimiento

Una implementación podría interpretar su acceso administrativo al tenant o su capacidad de corrección como autorización para ejecutar mantenimientos nuevos.

**Tratamiento:** pruebas negativas explícitas y separación de las operaciones de ejecución inicial respecto de corrección/resolución.

Este riesgo no crea una nueva decisión de producto; aplica la baseline vigente.

---

# 32. Decisiones abiertas

Este documento no reabre decisiones aprobadas.

`DO-075` permanece **RESUELTA/APROBADA**.

## 32.1 Decisiones técnicas relevantes ya existentes

### `DO-T03` — Invalidación efectiva de sesiones

**Estado:** RESUELTO/APROBADO.

**Reformulación de producto/seguridad aprobada:**

- una revocación, deshabilitación o reducción de alcance debe retirar inmediatamente toda autorización online afectada mediante estado autoritativo vigente;
- una sesión Auth o access JWT residual no conserva membership, rol, client scope, `SupportAccessGrant` ni ninguna otra autorización revocada;
- RLS/autorización vigente permanece como frontera primaria de datos;
- la seguridad no puede depender de esperar logout, refresh o `exp`;
- la terminación provider-side de sesiones y credenciales renovables permanece como defensa adicional y debe utilizar mecanismos públicos, soportados y contractualmente adecuados cuando exista una primitiva apropiada;
- ausencia, limitación o fallo de esa segunda defensa no restaura autorización;
- no se adoptan por inferencia `updateUserById(...password...)`, mutación directa de `auth.sessions`, almacenamiento de JWT ajenos, APIs no documentadas ni internals;
- `ban_duration` no se trata como equivalente contractual de global sign-out;
- DO-075 continúa definiendo el comportamiento offline.

**Cierre formal de DO-T03:**

- CORR-005 completó la sincronización de la reformulación aprobada;
- el diff y la coherencia de las fuentes afectadas fueron verificados;
- la revisión humana posterior de CORR-005 fue aprobada;
- una decisión humana separada declaró `DO-T03 = RESUELTO/APROBADO`.

El TTL exacto, la validación física de `session_id`, el diseño de RLS/SQL, la estructura física del backend y la selección futura de primitivas provider-side permanecen fuera del cierre conceptual de DO-T03 y quedan para `ADR-0003` y/o posteriores tareas de implementación según corresponda; no se resuelven por inferencia.

**Bloquea el siguiente documento `04`:** no.

**Deadline:** DO-T03 quedó resuelto antes de Fase 2 para identidad/autorización online; coordinación offline antes de Fase 5.

---

### `DO-T04` — Protección local

Permanece abierta.

No se resuelve aquí.

Debe abordarse en `04-offline-sync-strategy.md`.

---

## 32.2 `DM-OPEN-*` preservadas

### `DM-OPEN-001` — Obligatoriedad de `EquipmentType`

Sin cambios.

Resolver antes de Fase 3.

### `DM-OPEN-002` — Cardinalidad de formularios aplicables

Sin cambios.

Resolver antes de Fase 4.

### `DM-OPEN-003` — Equipo sin formulario aplicable

Sin cambios.

Resolver antes de Fase 4/Fase 5.

### `DM-OPEN-004` — Borradores simultáneos

Sin cambios.

Resolver antes de Fase 4.

### `DM-OPEN-005` — Unicidad del informe por cliente/período

Sin cambios.

Resolver antes de Fase 6.

### `DM-OPEN-006` — Plantilla usada en regeneración

Sin cambios.

Resolver antes de Fase 6.

### `DM-OPEN-007` — Créditos insuficientes

Sin cambios.

Resolver antes de Fase 7.

### `DM-OPEN-008` — Criterio temporal de inclusión en informes

Sin cambios.

Resolver antes de Fase 6.

---

## 32.3 Otras decisiones abiertas de baseline

También continúan con sus plazos aprobados:

- `DO-073`;
- `DO-074`;
- `DO-076`;
- `DO-077`;
- `DO-078`;
- `DO-T01`;
- `DO-T02`;
- `DO-T05`;
- `DO-T06`;
- `DO-T07`.

Este documento no modifica su estado.

---

## 32.4 Nuevas decisiones abiertas de seguridad

No se identifica en esta revisión una nueva decisión de producto que necesite introducirse como `SEC-OPEN-*`.

La corrección de alcance de `COMPANY_ADMIN` no constituye una nueva decisión abierta: aplica de forma restrictiva la baseline vigente.

Las zonas en las que la baseline no concede una capacidad concreta se interpretan de forma restrictiva:

> ausencia de permiso aprobado = no se infiere permiso.

Si posteriormente se desea que `COMPANY_ADMIN` pueda realizar la ejecución inicial de mantenimientos, deberá aprobarse explícitamente como decisión de producto y actualizarse la baseline antes de modificar esta estrategia.

---

# 33. Gate del documento

## 33.1 Contradicciones bloqueantes

**No se detectan contradicciones bloqueantes** entre `01-product-definition.md`, `02-domain-model.md` y esta estrategia que impidan continuar documentando Fase 0.

La ampliación accidental de permisos detectada en la versión anterior queda corregida mediante la interpretación restrictiva de la baseline.

---

## 33.2 Decisiones de seguridad que bloqueen la continuación de Fase 0

**No se identifica una decisión de seguridad que impida continuar con los demás documentos derivados de Fase 0.**

`DO-T03` debe resolverse antes de implementar Fase 2, pero no impide continuar la especificación documental.

---

## 33.3 Decisiones abiertas

Permanecen abiertas:

- `DO-T03` en su mecanismo técnico exacto;
- `DO-T04`;
- las demás `DO-T*` conforme a sus plazos;
- `DM-OPEN-001` a `DM-OPEN-008`;
- las decisiones de producto diferidas registradas en `01-product-definition.md`.

DO-075 permanece cerrada.

No se introducen nuevas `SEC-OPEN-*`.

---

## 33.4 Estado documental

**Estado de 03-permissions-rls-strategy.md: APROBADO**

**Ruta normativa:** `docs/product/03-permissions-rls-strategy.md`.

Su aprobación:

- consolida esta estrategia como contrato para el futuro esquema físico y RLS;
- **NO** autoriza todavía SQL;
- **NO** autoriza migraciones;
- **NO** autoriza implementación;
- **NO** equivale al cierre de Fase 0.

---

## 33.5 Estado de Fase 0

**Estado de Fase 0: EN CURSO.**

La aprobación de este documento no sustituye la creación, revisión y aprobación de los demás documentos derivados y ADRs necesarios.

Hasta cerrar el Gate completo de Fase 0, no corresponde iniciar Fase 1 ni implementar la arquitectura aquí descrita.
