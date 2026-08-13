# 04 — Estrategia conceptual offline-first y de sincronización del MVP

> **Ruta normativa/objetivo:** `docs/product/04-offline-sync-strategy.md`  
> **Estado:** **APROBADO — estrategia conceptual offline-first y de sincronización del MVP**  
> **Fase:** Fase 0 — documento derivado  
> **Estado de Fase 0:** **EN CURSO**  
> **Baseline normativa:** `docs/product/01-product-definition.md`  
> **Modelo de dominio aprobado:** `docs/product/02-domain-model.md`  
> **Estrategia de permisos/RLS aprobada:** `docs/product/03-permissions-rls-strategy.md`  
> **Naturaleza:** estrategia conceptual y arquitectónica offline-first y de sincronización; **NO constituye implementación, esquema físico, SQL, migraciones, endpoints ni diseño definitivo de Dexie/Service Worker**

---

# 1. Propósito y alcance

Este documento define la estrategia conceptual y arquitectónica offline-first y de sincronización del MVP del SaaS B2B multiempresa de mantenimiento.

Su objetivo es establecer, antes de implementar infraestructura offline:

- cómo se mantiene una réplica local operativa;
- cómo se separa el estado de negocio del estado técnico de sincronización;
- cómo se persiste trabajo de campo antes de depender de la red;
- cómo se representan y procesan operaciones pendientes;
- cómo se conserva evidencia fotográfica hasta su confirmación remota;
- cómo se coordinan dependencias, idempotencia y reintentos;
- cómo se revalida autorización al recuperar conectividad;
- cómo se detectan y resuelven conflictos sin Last Write Wins silencioso;
- cómo se preserva el aislamiento local por identidad;
- cómo se relacionan Service Worker, IndexedDB/Dexie, Supabase PostgreSQL, Supabase Storage, Auth y RLS;
- qué decisiones continúan abiertas antes de la implementación.

Este documento debe actuar como **contrato arquitectónico** para la futura implementación de Fase 5 y para cualquier diseño anterior que deba preparar capacidades offline sin implementarlas todavía.

Este documento **NO define ni autoriza todavía**:

- código ejecutable;
- clases concretas;
- tablas Dexie definitivas;
- claves o índices Dexie definitivos;
- SQL;
- tablas PostgreSQL;
- migraciones;
- políticas RLS ejecutables;
- funciones PostgreSQL;
- implementación concreta de Service Worker;
- configuración concreta de Workbox;
- endpoints;
- Server Actions;
- handlers;
- protocolos HTTP concretos;
- buckets o paths definitivos de Supabase Storage;
- tokens o credenciales offline concretas;
- inicialización de Next.js;
- inicialización de Supabase.

## 1.1 Autoridad

Se respeta el orden de autoridad indicado para este documento:

1. `docs/product/01-product-definition.md`;
2. `docs/product/02-domain-model.md`;
3. `docs/product/03-permissions-rls-strategy.md`;
4. `docs/product/00-master-product-brief.md`;
5. decisiones explícitamente aprobadas posteriormente dentro del Project que no hayan sido sustituidas.

Además, este documento debe respetar las reglas explícitas del encargo de generación actual, que reiteran como cerradas, entre otras, la autorización offline máxima de 7 días y la ausencia de ejecución inicial de mantenimiento para `COMPANY_ADMIN`.

## 1.2 Revisión de coherencia previa

No se detecta una contradicción que bloquee la consolidación de esta estrategia.

`01-product-definition.md`, `02-domain-model.md` y `03-permissions-rls-strategy.md` son coherentes respecto de los permisos de mantenimiento.

Se mantienen como reglas aprobadas:

- la ejecución inicial de mantenimiento corresponde exclusivamente a `TECHNICIAN` dentro de sus clientes autorizados;
- `COMPANY_ADMIN` puede realizar la lectura necesaria para sus funciones, corregir mantenimientos finalizados y resolver conflictos dentro de su alcance;
- `COMPANY_ADMIN` **NO** posee ejecución inicial de mantenimiento;
- un `SupportAccessGrant` no genera capacidades operativas nuevas por inferencia para `SUPER_ADMIN` y sólo habilita el acceso excepcional expresamente autorizado por sus scopes.

Este documento no reabre ni modifica esos permisos.

---

# 2. Principios offline-first

## 2.1 Local-first

Para las operaciones de campo aprobadas, la aplicación debe tratar la persistencia local como el primer compromiso técnico de durabilidad.

Una acción del usuario que supera las validaciones locales aplicables debe persistirse localmente antes de depender de una respuesta de red.

La red puede acelerar la convergencia con la fuente remota, pero no debe ser el requisito de durabilidad inicial de una operación de campo.

## 2.2 PostgreSQL como fuente de verdad remota

Supabase PostgreSQL continúa siendo la **fuente de verdad remota y autoritativa** para:

- estado compartido entre dispositivos;
- ownership;
- autorización vigente;
- estado comercial vigente;
- revisiones confirmadas;
- datos consolidados para otros actores;
- decisiones que dependan del estado remoto actual.

La réplica local no adquiere autoridad remota por estar disponible offline.

## 2.3 Persistencia antes de red

La secuencia conceptual obligatoria para trabajo local es:

**acción del usuario → validación local → persistencia local durable → actualización de UI → registro de intención sincronizable → intento remoto cuando corresponda.**

Si la conexión se pierde después de la persistencia local, el trabajo no debe desaparecer ni retroceder silenciosamente.

## 2.4 Tolerancia a desconexiones prolongadas

La PWA debe soportar operación durante días sin conectividad dentro de la vigencia de autorización offline aprobada.

La estrategia no depende de una conexión continua, polling continuo ni procesos en segundo plano garantizados por el sistema operativo.

## 2.5 Sincronización eventual

Los estados locales autorizados deben converger con el estado remoto cuando:

- exista conectividad funcional;
- la identidad pueda revalidarse cuando corresponda;
- la operación siga autorizada;
- sus dependencias estén satisfechas;
- no exista un conflicto que requiera resolución;
- la infraestructura remota necesaria esté disponible.

“Eventual” no significa “eventualmente sobrescribir”: una divergencia crítica puede detener la aplicación automática y convertirse en conflicto.

## 2.6 Ausencia de pérdida silenciosa

No deben perderse silenciosamente:

- respuestas;
- mantenimientos finalizados localmente;
- revisiones;
- evidencias;
- archivos pendientes;
- operaciones en outbox;
- versiones locales involucradas en conflictos.

La recuperación puede requerir intervención, pero la estrategia debe priorizar preservación antes que borrado.

## 2.7 Idempotencia

Un mismo intento lógico puede repetirse por:

- timeout;
- respuesta perdida;
- cierre de PWA;
- reinicio del dispositivo;
- reconexión repetida;
- reanudación de upload.

Repetirlo no debe crear efectos de dominio duplicados.

## 2.8 Autorización local temporal

La posibilidad de operar offline proviene de una validación online previa y tiene vigencia limitada.

La autorización local no sustituye la autorización remota ni impide que una revocación vigente prevalezca al recuperar conectividad.

## 2.9 Conflictos explícitos

No se admite Last Write Wins silencioso para datos críticos.

Cuando la precondición remota sobre la que se basó una mutación local dejó de ser válida, el sistema debe preservar ambas versiones y decidir explícitamente el tratamiento.

## 2.10 Local-first y remote source of truth no se contradicen

Estas afirmaciones responden a preguntas distintas:

- **“la operación se confirma funcionalmente primero de forma local”** responde cuándo el usuario puede considerar que su trabajo fue guardado y, cuando corresponda, finalizado en el dispositivo;
- **“PostgreSQL es fuente de verdad remota”** responde qué estado es autoritativo para compartir, autorizar, conciliar y resolver concurrencia entre dispositivos/actores.

Un mantenimiento puede estar **FINALIZADO localmente** y simultáneamente **PENDIENTE de confirmación remota**. Esa combinación es esperada, no una contradicción.

---

# 3. Fronteras conceptuales

La estrategia debe mantener dos ejes independientes.

## 3.1 Estado de negocio

Expresa el significado funcional del recurso.

Para mantenimiento, como mínimo distingue conceptualmente:

- trabajo en captura;
- finalizado.

La baseline no obliga todavía a nombres físicos concretos para todos los estados previos a la finalización.

## 3.2 Estado de sincronización

Expresa la situación técnica de convergencia remota.

Conceptualmente pueden existir situaciones equivalentes a:

- pendiente;
- intentando;
- confirmado;
- conflicto;
- bloqueado por autorización;
- bloqueado por dependencia;
- error que requiere intervención.

Los nombres definitivos, cardinalidades y representación física quedan abiertos para la implementación.

## 3.3 Regla de separación

No debe construirse una única máquina de estados que mezcle conceptos como:

- borrador/finalizado;
- sincronizando/sincronizado;
- conflicto.

Ejemplos válidos:

| Estado de negocio | Estado de sincronización | Significado |
|---|---|---|
| Finalizado | Pendiente | El trabajo está finalizado en el dispositivo y aún no fue confirmado remotamente |
| Finalizado | Intentando | Se está intentando aplicar/confirmar trabajo remoto |
| Finalizado | Conflicto | El trabajo funcional permanece finalizado localmente, pero no puede aplicarse automáticamente |
| Finalizado | Confirmado | El estado remoto aceptó o reconoció idempotentemente el efecto esperado |

---

# 4. Componentes conceptuales

## 4.1 PWA

Responsable de la experiencia de usuario instalada/navegable, coordinación de sesión activa, lectura/escritura de la réplica propia de esa identidad y presentación de estado offline/sync.

No es autoridad de autorización remota.

## 4.2 Service Worker

Responsable principalmente de disponibilidad del application shell y assets necesarios para abrir y operar la interfaz sin red.

Puede colaborar con estrategias de actualización y entrega de assets.

No debe convertirse en el almacén principal de datos operativos ni en la única garantía de ejecución de sincronización.

## 4.3 IndexedDB

Es el almacenamiento persistente local para datos operativos estructurados y metadata técnica necesaria.

Debe contener información suficiente para reconstruir la experiencia operativa sin depender de memoria de React.

## 4.4 Dexie

Dexie será la capa aprobada para organizar el acceso a IndexedDB.

En este documento se trata como mecanismo técnico de acceso/persistencia, no como fuente de reglas de dominio ni como autorización.

No se define todavía su schema.

## 4.5 `LocalReplica`

Es la copia operativa local asociada a **una identidad concreta**.

Contiene copias remotas autorizadas, trabajo local no confirmado y metadata técnica de sincronización.

No es una réplica global del tenant.

## 4.6 Outbox

Es la colección durable de intenciones locales que aún requieren aplicación o reconocimiento remoto.

Debe sobrevivir interrupciones y mantener identidad estable por intento lógico.

## 4.7 `SyncOperation`

Representa una unidad conceptual sincronizable e idempotente.

Debe permitir correlacionar:

- intención local;
- actor/identidad propietaria;
- recurso;
- dependencias;
- precondición esperada;
- intentos;
- resultado;
- errores;
- confirmación.

No se definen columnas ni payloads definitivos.

## 4.8 Sincronizador

Es la responsabilidad que:

- detecta oportunidad real de comunicación;
- revalida autorización cuando corresponde;
- selecciona operaciones elegibles;
- respeta dependencias;
- reintenta transitorios;
- detiene permanentes;
- detecta conflictos;
- confirma efectos;
- actualiza la réplica con estado autoritativo.

No se presupone un único proceso ni una única API.

## 4.9 Almacenamiento local de fotografías/archivos

Debe conservar el contenido binario necesario para uploads pendientes y la metadata que lo vincula con el dominio y la outbox.

Una referencia visual temporal no sustituye la persistencia durable del archivo.

## 4.10 Supabase PostgreSQL

Es la autoridad remota del estado estructurado compartido y de las precondiciones de concurrencia.

RLS vuelve a aplicar en cada acceso remoto normal.

## 4.11 Supabase Storage

Es el destino remoto de archivos/evidencias cuando su upload y asociación han sido autorizados y confirmados.

Conocer un path no concede autorización.

## 4.12 Auth/RLS

Auth identifica al sujeto.

RLS y las demás defensas autoritativas determinan si ese sujeto puede acceder o mutar el recurso remoto en ese momento.

## 4.13 Resolución de conflictos

Es una capacidad de dominio coordinada con sync.

En mantenimiento, una resolución autorizada genera una nueva `MaintenanceRevision`; no modifica revisiones históricas.

---

# 5. Service Worker

## 5.1 Responsabilidad mínima

El Service Worker debe permitir conceptualmente:

- disponibilidad del application shell;
- carga offline de assets estáticos necesarios;
- apertura de una experiencia offline utilizable;
- actualización controlada de assets cuando exista una nueva versión de la aplicación.

## 5.2 Estrategia conceptual de actualización

La actualización del shell debe evitar dejar una combinación incompatible entre:

- código nuevo;
- réplica local antigua;
- outbox existente;
- migraciones locales pendientes.

Una nueva versión de assets no debe activarse de forma que destruya o vuelva ilegible trabajo no sincronizado.

El detalle del ciclo install/activate, Workbox u otras APIs queda fuera de este documento.

## 5.3 Frontera con datos operativos

**Service Worker caching no equivale a almacenamiento de datos operativos.**

El cache del Service Worker es adecuado para recursos de aplicación y respuestas cacheables seleccionadas, pero los datos operativos estructurados, outbox, conflictos y metadata durable pertenecen a IndexedDB/Dexie.

Las fotografías/archivos pendientes deben utilizar una estrategia de persistencia local durable compatible con el navegador, vinculada conceptualmente a la réplica; no deben depender de que una respuesta HTTP permanezca en cache.

## 5.4 No depender de ejecución en background garantizada

La arquitectura no debe asumir que Android, el navegador o la PWA mantendrán un proceso de sincronización en segundo plano de forma indefinida.

La sincronización automática debe poder reanudarse cuando la aplicación vuelva a disponer de una oportunidad de ejecución y conectividad funcional.

---

# 6. Modelo de réplica local

`LocalReplica` representa el conjunto de datos operativos locales de una identidad.

## 6.1 Contenido conceptual

Puede contener:

- metadata de identidad y autorización offline;
- clientes autorizados;
- jerarquías de ubicaciones;
- equipos;
- información necesaria de tipos de equipos;
- formularios publicados aplicables;
- versiones históricas necesarias para interpretar mantenimientos existentes;
- mantenimientos necesarios;
- trabajo en curso;
- revisiones;
- respuestas;
- evidencias;
- outbox;
- conflictos;
- archivos pendientes;
- metadata de sincronización.

## 6.2 Clases de datos dentro de la réplica

### Copias remotas

Datos cuyo origen autoritativo es remoto y que se mantienen localmente para operación:

- clientes;
- ubicaciones;
- equipos;
- formularios/versiones;
- mantenimientos ya confirmados;
- revisiones remotas necesarias;
- autorizaciones conocidas.

### Estado local no sincronizado

Datos creados o modificados localmente cuya confirmación remota está pendiente:

- mantenimiento nuevo de un `TECHNICIAN`;
- revisión local;
- respuestas;
- evidencia;
- corrección;
- resolución de conflicto;
- metadata de archivos pendientes.

### Metadata técnica local

Información necesaria para operar la sincronización:

- identidad estable de operación;
- dependencias;
- estado de intento;
- errores;
- precondiciones;
- marcas de confirmación;
- referencias entre recursos locales.

## 6.3 Regla de autoridad

Que un dato exista en `LocalReplica` significa que fue:

- previamente descargado;
- o capturado localmente.

No significa que siga autorizado remotamente ni que el estado remoto actual sea idéntico.

---

# 7. Partición por identidad

La regla normativa es:

> **una identidad → su propia réplica**

## 7.1 Aislamiento obligatorio

La persistencia local debe impedir que una sesión abra accidentalmente:

- datos;
- outbox;
- archivos;
- conflictos;
- metadata de autorización

pertenecientes a otra identidad.

## 7.2 No compartir por tenant

Dos usuarios no comparten réplica aunque:

- pertenezcan al mismo `MaintenanceCompany`;
- tengan el mismo rol;
- tengan clientes autorizados en común;
- utilicen el mismo dispositivo.

## 7.3 Consecuencias

Una identidad distinta no puede reutilizar:

- IDs de outbox de otra identidad;
- archivos pendientes;
- credenciales/metadata local de autorización;
- conflictos pendientes;
- respuestas no sincronizadas.

La coincidencia de tenant o cliente no elimina esta frontera.

---

# 8. DO-T04 — Protección local

## 8.1 Estado

`DO-T04` permanece como **PROPUESTA PENDIENTE DE APROBACIÓN**.

Este documento desarrolla la estrategia y formula una recomendación arquitectónica, pero **NO declara DO-T04 resuelta ni aprobada**.

## 8.2 Amenazas consideradas

### Usuario diferente en el mismo dispositivo

Riesgo: que una nueva sesión vea datos de la identidad anterior por reutilización de una base local común.

### Logout seguido de login de otro usuario

Riesgo: que el cambio de sesión sólo afecte la UI, mientras IndexedDB sigue exponiendo la réplica previa.

### Inspección casual desde la aplicación

Riesgo: rutas, pantallas, selectores o caches de estado que presenten información que no corresponde a la identidad activa.

### Residuos locales

Riesgo: datos sincronizados, outbox o archivos permanezcan localmente más tiempo del esperado y sean abiertos desde un contexto equivocado.

### Archivos pendientes

Riesgo: una foto de A sea subida o asociada por B si el almacenamiento local no está particionado.

### Pérdida o robo del dispositivo

Riesgo: acceso físico al perfil del navegador o dispositivo y extracción de datos almacenados.

### IndexedDB accesible desde el mismo origin

Riesgo: cualquier código ejecutado con capacidad de operar bajo el mismo origin puede potencialmente interactuar con almacenamiento del origin, sujeto a las protecciones del navegador.

### Datos sensibles durante varios días offline

Riesgo: ampliar la ventana temporal en la que información operativa reside físicamente en el dispositivo.

## 8.3 Requisito aprobado

Está aprobado y no se reabre:

- datos offline aislados por identidad;
- una identidad distinta no puede abrir la réplica anterior;
- logout no debe eliminar automáticamente trabajo pendiente;
- conservar datos no equivale a conservar autorización.

## 8.4 Propuesta técnica

**PROPUESTA PENDIENTE DE APROBACIÓN — DO-T04**

Adoptar como baseline arquitectónica:

1. persistencia particionada por identidad;
2. resolución explícita de cuál es la réplica de la identidad activa antes de abrir datos operativos;
3. una sesión sólo puede abrir su propia réplica;
4. outbox y archivos quedan dentro de la misma frontera de identidad;
5. logout cierra el contexto activo pero no elimina automáticamente trabajo pendiente;
6. el cambio de identidad obliga a cerrar referencias en memoria a la réplica previa antes de abrir otra;
7. ninguna operación de sync puede tomar trabajo de una réplica distinta de la identidad a la que pertenece.

El particionado puede terminar siendo lógico, físico o una combinación. La forma concreta debe elegirse en diseño de implementación sin debilitar la propiedad de aislamiento.

## 8.5 Cifrado local adicional

La necesidad de cifrado adicional a nivel de aplicación **permanece abierta dentro de DO-T04** y no se presume obligatoria.

### Amenazas que podría mitigar

Dependiendo del diseño de claves, podría reducir exposición de datos ante:

- inspección del almacenamiento en reposo fuera del flujo normal de la aplicación;
- copia de archivos del perfil del navegador;
- ciertos escenarios de pérdida física del dispositivo.

### Limitaciones

No constituye seguridad absoluta porque:

- el código de la aplicación necesita acceso al material descifrable para operar;
- código malicioso ejecutado bajo el mismo origin podría intentar acceder a datos ya descifrados o a claves disponibles en runtime;
- no sustituye bloqueo de dispositivo, seguridad del sistema operativo ni higiene del perfil del navegador;
- no resuelve autorización remota;
- no impide que un usuario legítimamente autenticado vea sus propios datos.

### Gestión de claves necesaria

Si se aprueba cifrado adicional, deberá definirse antes de implementarlo:

- origen y ciclo de vida de claves;
- asociación entre clave e identidad;
- recuperación tras logout/reinstalación;
- comportamiento durante días offline;
- rotación;
- pérdida de credenciales;
- revocación;
- posibilidad o imposibilidad de recuperación de outbox pendiente.

### Impacto offline/recuperación

Un diseño que requiera contactar al servidor para obtener la clave en cada apertura podría destruir la capacidad offline.

Un diseño que guarde la clave junto con los datos puede ofrecer una protección limitada frente a ciertos atacantes.

Por tanto, cifrado adicional no debe aprobarse sin un threat model y una política de recuperación coherentes.

## 8.6 Recomendación

La recomendación de este documento es:

- **aprobar el aislamiento por identidad y apertura exclusiva de réplica como baseline DO-T04;**
- **mantener el cifrado adicional como evaluación separada pendiente de amenaza/legal, sin convertirlo aún en requisito.**

Estado de esta recomendación: **PROPUESTA PENDIENTE DE APROBACIÓN**.

---

# 9. Ciclo de vida de la réplica

## 9.1 Primera autenticación online

Una identidad sin réplica operativa debe autenticarse y validar online su:

- identidad;
- membership;
- rol;
- clientes autorizados;
- estado comercial;
- condiciones relevantes.

Sin una validación online inicial no existe base autoritativa suficiente para conceder autorización offline.

## 9.2 Bootstrap

Tras la validación, el sistema prepara la réplica con el alcance necesario y autorizado.

El bootstrap no debe marcarse como “offline preparado” hasta que el conjunto mínimo necesario para operar de forma coherente esté disponible localmente.

## 9.3 Operación offline

Durante desconexión:

- se consulta `LocalReplica`;
- se aplican validaciones locales;
- se persiste antes de red;
- se crean operaciones de outbox;
- se conserva evidencia local;
- se respeta la vigencia de autorización offline.

## 9.4 Reconexión

Al recuperar conectividad funcional:

- se revalida estado autoritativo cuando corresponda;
- se actualiza alcance;
- se procesan operaciones elegibles;
- se detectan conflictos;
- se descargan cambios;
- se actualiza la réplica.

## 9.5 Actualización incremental

Después del bootstrap, la réplica debe poder incorporar cambios remotos sin necesitar redescargar todo el tenant.

El mecanismo concreto de cursor, versión, timestamp técnico u otro queda para diseño posterior.

## 9.6 Logout

Logout:

- cierra el contexto activo;
- invalida referencias en memoria;
- no expone la réplica al siguiente usuario;
- no borra automáticamente outbox ni archivos pendientes.

## 9.7 Login posterior de la misma identidad

La misma identidad puede volver a abrir su réplica, pero:

- conservar datos no significa autorización vigente;
- debe respetarse DO-075;
- antes de operaciones remotas debe revalidarse cuando corresponda;
- una revocación conocida prevalece.

## 9.8 Login de otra identidad

Se abre exclusivamente la réplica de la nueva identidad.

La réplica anterior permanece inaccesible desde esa sesión.

## 9.9 Revocación

Una revocación conocida al reconectar:

- actualiza la autorización local;
- impide nuevas acciones no permitidas;
- impide sync de operaciones que ya no estén autorizadas;
- no elimina automáticamente trabajo capturado.

## 9.10 Expiración de 7 días

Al alcanzar el máximo de DO-075:

- no se inicia una nueva operación;
- se conservan datos, outbox y fotografías;
- se exige conectividad/revalidación para obtener nueva vigencia.

No se inventa ningún intervalo adicional.

---

# 10. Bootstrap offline

## 10.1 Objetivo

El bootstrap transforma una sesión online validada en una réplica suficientemente completa para que la identidad pueda trabajar dentro de su alcance sin conectividad.

## 10.2 Alcance mínimo para `TECHNICIAN`

Por cada cliente autorizado debe obtenerse lo necesario para operar, incluyendo:

- el cliente;
- jerarquía completa de ubicaciones;
- todos sus equipos;
- información de tipos necesaria para interpretar esos equipos;
- formularios publicados aplicables;
- versiones históricas necesarias para interpretar mantenimientos accesibles;
- información de mantenimiento necesaria para operar e interpretar el trabajo autorizado.

## 10.3 No descargar todo el tenant

La comodidad de implementación no justifica descargar:

- clientes no autorizados;
- formularios tenant-wide innecesarios;
- mantenimientos fuera de alcance;
- datos administrativos no requeridos.

El alcance offline debe derivarse del mismo ownership/autorización conceptual que el acceso remoto.

## 10.4 Integridad del bootstrap

La réplica debe poder distinguir conceptualmente:

- bootstrap completo para una porción necesaria;
- actualización incompleta;
- error de descarga.

No debe presentar como disponible offline un formulario/equipo si faltan dependencias esenciales para operarlo coherentemente.

## 10.5 `COMPANY_ADMIN`

Este documento no amplía el alcance offline de escritura administrativa ni concede ejecución inicial de mantenimiento a `COMPANY_ADMIN`.

Si futuras especificaciones permiten administración offline de módulos concretos, deberán definir sus propios requisitos y conflictos sin romper esta estrategia.

---

# 11. Actualización de datos remotos hacia local

La réplica debe poder incorporar cambios autoritativos sin destruir trabajo local pendiente.

## 11.1 Nuevos equipos

Si pertenecen a un cliente autorizado, deben poder incorporarse en una actualización posterior para quedar disponibles offline.

## 11.2 Cambios de datos maestros

Los cambios remotos deben refrescar copias locales siempre que:

- pertenezcan al alcance vigente;
- no destruyan una intención local pendiente;
- preserven la información necesaria para interpretar históricos.

## 11.3 Nuevas versiones publicadas de formularios

Deben poder descargarse cuando sean aplicables al alcance.

La versión nueva no reemplaza físicamente las versiones históricas todavía necesarias.

## 11.4 Cliente añadido

Tras revalidación, el nuevo cliente puede iniciar su propio bootstrap incremental.

## 11.5 Cliente revocado

Tras conocer la revocación:

- deja de añadirse/actualizarse información remota de ese cliente para la identidad;
- se impiden nuevas operaciones;
- el tratamiento de datos locales ya existentes sigue las reglas de conservación definidas en las secciones 26, 27 y 42.

## 11.6 Cambios de permisos/rol

El estado local debe actualizarse desde la fuente autoritativa y no continuar usando indefinidamente claims o metadata local obsoleta.

## 11.7 Cambios comerciales

La suscripción/entitlement conocido debe actualizarse al revalidar.

No se define polling periódico concreto.

---

# 12. Escritura local-first

Para las operaciones offline aprobadas se aplica la secuencia:

1. el usuario realiza una acción;
2. la aplicación valida localmente lo que puede validar con la información disponible;
3. la intención y sus datos necesarios se persisten durablemente en la réplica;
4. la UI refleja el nuevo estado local;
5. se registra una `SyncOperation` o conjunto atómico de operaciones coherente en outbox;
6. si existe conectividad y autorización válida, se intenta sincronizar;
7. si no, permanece pendiente.

## 12.1 Validación local no equivale a aceptación remota

La validación local comprueba reglas conocidas y evita errores evidentes.

La aceptación remota puede rechazar por:

- autorización revocada;
- precondición de concurrencia incumplida;
- estado comercial;
- relaciones que cambiaron;
- validaciones autoritativas.

## 12.2 Durabilidad previa

No debe dependerse de:

- React state;
- memoria del proceso;
- una request en vuelo

para preservar el trabajo.

---

# 13. Outbox durable

## 13.1 Significado

La outbox representa **intenciones locales todavía no confirmadas remotamente**.

No es un simple historial de requests HTTP.

## 13.2 Identidad estable

Cada intento lógico debe disponer de identidad estable suficiente para:

- retry;
- idempotencia;
- trazabilidad;
- correlación;
- relación con el recurso local;
- relación con dependencias;
- asociación con archivos cuando corresponda.

## 13.3 Durabilidad

Debe sobrevivir:

- navegación entre pantallas;
- cierre y reapertura de PWA;
- terminación del proceso del navegador;
- reinicio del dispositivo, dentro de las garantías del almacenamiento;
- pérdida temporal de red;
- logout cuando exista trabajo pendiente que deba conservarse.

## 13.4 Propiedad

Cada item pertenece a la identidad de su `LocalReplica`.

No puede ser procesado por la sesión de otra identidad.

## 13.5 Ciclo conceptual

Un item puede encontrarse conceptualmente:

- pendiente;
- elegible para intento;
- intentando;
- esperando dependencia;
- bloqueado por autorización;
- en conflicto;
- confirmado;
- detenido por error permanente/intervención.

Los nombres físicos no quedan fijados.

---

# 14. Tipos conceptuales de operaciones

La outbox puede contener categorías conceptuales como:

- creación de un mantenimiento inicial por `TECHNICIAN`;
- finalización/revisión inicial;
- corrección autorizada;
- resolución de conflicto autorizada;
- persistencia de respuestas;
- metadata necesaria;
- creación/asociación de evidencia;
- upload de fotografía/archivo;
- confirmación de asociación de archivo.

Esta lista no define enums físicos ni obliga a separar cada paso en un request distinto.

## 14.1 Atomicidad de dominio antes que granularidad técnica

Una acción que deba ser válida como unidad de dominio no debe dividirse de forma que el servidor pueda observar estados imposibles.

Por ejemplo, no debe quedar un mantenimiento finalizado remotamente si faltan respuestas requeridas que forman parte de esa misma revisión.

## 14.2 No ampliar capacidades

La existencia de un tipo de operación en outbox no concede el derecho a usarlo.

En particular:

- `TECHNICIAN` puede crear la ejecución inicial dentro de clientes autorizados;
- `COMPANY_ADMIN` sólo puede escribir sobre mantenimiento mediante corrección o resolución autorizada.

---

# 15. Dependencias entre operaciones

## 15.1 Necesidad

Las operaciones pueden depender de que un recurso parent exista o haya sido aceptado remotamente.

Ejemplo conceptual:

**crear mantenimiento → confirmar revisión/respuestas → asociar/subir evidencias**

La forma concreta puede agrupar varios de estos pasos en una única operación atómica, pero no puede aplicar un child remoto contra un parent inexistente.

## 15.2 Dependencia explícita

La outbox debe ser capaz de representar conceptualmente que una operación:

- depende de otra;
- depende de una identidad estable de recurso;
- no es elegible hasta que la dependencia esté confirmada o pueda resolverse idempotentemente en la misma unidad.

## 15.3 Fallo del parent

Si el parent:

- entra en conflicto;
- es rechazado por autorización;
- falla permanentemente,

los children no deben continuar ciegamente.

Deben quedar bloqueados/preservados hasta conocer el tratamiento del parent.

## 15.4 Fotografías

Un upload puede realizarse técnicamente antes o después de otras mutaciones según el protocolo futuro, pero la evidencia no debe quedar asociada a una revisión remota inexistente ni perderse si esa asociación falla.

---

# 16. Identificadores offline

## 16.1 Requisito

La aplicación debe poder crear un recurso antes de conectarse.

Por tanto, el recurso necesita una identidad estable desde su creación local.

## 16.2 Estrategia conceptual recomendada

Se recomienda utilizar una **identidad única generable localmente y reutilizable remotamente**, siempre que el futuro diseño físico lo permita.

Esto evita introducir de forma innecesaria:

- un ID local;
- otro ID remoto;
- tablas complejas de mapeo.

## 16.3 Propiedades necesarias

La identidad debe:

- poder generarse sin red;
- permanecer estable entre reintentos;
- permitir referencias locales;
- no cambiar al confirmar sync;
- permitir que el backend reconozca un retry del mismo recurso lógico.

## 16.4 No se fija tipo físico

Este documento no define:

- tipo SQL;
- formato exacto;
- librería;
- versión de UUID u otro esquema.

La decisión concreta es candidata a ADR.

---

# 17. Idempotencia

## 17.1 Definición

Una operación es idempotente para este producto cuando repetir **la misma intención lógica con la misma identidad estable**:

- no crea un segundo mantenimiento;
- no crea una segunda corrección;
- no crea una segunda resolución;
- no duplica respuestas;
- no duplica evidencia;
- no duplica un archivo remoto;
- no produce efectos de dominio adicionales.

## 17.2 Timeout

Si el cliente no sabe si el servidor aplicó una operación, debe poder repetirla con la misma identidad.

## 17.3 Respuesta perdida

Si el servidor aplicó el efecto pero la respuesta se perdió, un retry debe permitir reconocer el efecto previo como confirmado.

## 17.4 PWA cerrada durante sync

Al reabrir, el sistema debe poder determinar que la operación:

- sigue pendiente;
- o ya fue aplicada y puede confirmarse,

sin crear duplicados.

## 17.5 Reconexiones repetidas

Cada nuevo ciclo de conectividad puede reintentar operaciones elegibles sin inventar nuevas identidades.

## 17.6 Upload de fotografías

Reanudar/repetir un upload lógico no debe crear múltiples evidencias remotas indistinguibles para el mismo intento.

## 17.7 Correcciones y conflictos

Una corrección o resolución de conflicto debe disponer de identidad lógica estable. Repetir la entrega de la misma resolución no debe crear revisiones adicionales.

---

# 18. Estrategia de sincronización automática

Al recuperar una oportunidad de conectividad, la secuencia conceptual recomendada es:

1. detectar una señal de conectividad;
2. comprobar acceso remoto funcional, no sólo estado del navegador;
3. resolver/revalidar identidad y autorización cuando corresponda;
4. actualizar primero el estado autoritativo imprescindible para decidir qué operaciones siguen permitidas;
5. reclasificar operaciones pendientes según autorización, dependencias y precondiciones;
6. procesar operaciones elegibles de forma idempotente;
7. obtener la representación remota aceptada de los recursos afectados;
8. descargar cambios remotos adicionales del alcance vigente;
9. detectar conflictos/divergencias;
10. actualizar la réplica y los indicadores de UI.

## 18.1 Razón del orden

La autorización se revalida antes de empujar porque una operación creada cuando el usuario estaba autorizado no conserva automáticamente permiso para ejecutarse remotamente.

Se obtiene estado remoto necesario antes/durante push para evitar aplicar una mutación contra una revisión obsoleta.

El pull posterior permite converger con normalizaciones, revisiones o efectos realmente aceptados por el servidor.

## 18.2 `navigator.onLine`

Puede utilizarse como señal de oportunidad, pero no como prueba suficiente.

“Online” puede coexistir con:

- portal cautivo;
- DNS fallando;
- Supabase inaccesible;
- sesión vencida;
- red sin salida útil.

La conectividad funcional se confirma mediante acceso remoto útil.

## 18.3 Automatismo

La sincronización debe intentar reanudarse automáticamente cuando vuelva la conectividad y la autorización vigente lo permita.

No se fija periodicidad ni número de intentos.

---

# 19. Reintentos y errores transitorios

## 19.1 Errores reintentables

Conceptualmente incluyen fallas temporales como:

- pérdida de red;
- timeout;
- indisponibilidad transitoria;
- interrupción de upload;
- respuesta no concluyente.

Deben mantener la operación y permitir reintento.

## 19.2 Errores permanentes

Errores que no cambiarán por repetir exactamente la misma operación, por ejemplo una incompatibilidad estructural o regla de dominio definitivamente incumplida, deben detener el retry automático y requerir tratamiento.

## 19.3 Errores de autorización

No se tratan como transitorios ordinarios.

La operación debe quedar preservada y clasificada como no ejecutable/bloqueada hasta que se determine si:

- la autorización fue restaurada;
- debe intervenir un actor;
- la operación no puede aplicarse.

## 19.4 Conflictos

Un conflicto de concurrencia no debe reintentarse como si fuera un timeout.

Debe entrar al flujo de `SyncConflict`.

## 19.5 Error de validación

Si el servidor rechaza por una validación autoritativa, debe mostrarse un resultado accionable y preservarse el trabajo local.

## 19.6 Error de almacenamiento

Si falla IndexedDB o el almacenamiento local antes de confirmar durabilidad, la UI no debe declarar que el trabajo quedó guardado.

## 19.7 Backoff

Puede utilizarse backoff conceptual para reducir retries agresivos.

No se fijan:

- tiempos;
- multiplicadores;
- cantidad máxima;
- constantes.

---

# 20. Fotografías y archivos pendientes

## 20.1 Persistencia

Una fotografía seleccionada/capturada para una operación debe persistirse localmente antes de depender del upload.

## 20.2 Independencia respecto del mantenimiento

Confirmar el estado estructurado del mantenimiento no significa confirmar sus archivos.

Un mantenimiento puede estar:

- finalizado localmente;
- con datos estructurados ya confirmados;
- y con fotografías todavía pendientes.

## 20.3 Upload idempotente

El intento lógico de subir un archivo debe poder repetirse sin duplicar el efecto esperado.

## 20.4 No borrar por pérdida de red

Una interrupción no elimina el archivo local.

## 20.5 Confirmación remota del archivo

Conceptualmente existe confirmación válida sólo cuando el sistema puede establecer que:

- el contenido remoto esperado fue almacenado o reconocido idempotentemente;
- está asociado al recurso/evidencia correcto;
- la asociación fue autorizada;
- el backend reconoce el resultado como válido para esa identidad lógica.

“Se envió el request” o “se transfirieron bytes” no basta por sí solo.

## 20.6 Limpieza posterior

El archivo local no debe eliminarse antes de la confirmación remota válida.

Incluso después de confirmar, la política de limpieza puede depender de necesidades de históricos/cache y capacidad local; no se inventa una retención fija.

---

# 21. Finalización local de mantenimiento

Cuando un `TECHNICIAN` autorizado presiona `Guardar` y se cumplen las validaciones aplicables:

> **`MaintenanceRecord` queda finalizado localmente aunque no exista conectividad y aunque existan operaciones o fotografías pendientes.**

## 21.1 Consecuencias

La UI no debe degradar el mantenimiento a “borrador” sólo por falta de sincronización.

El estado funcional de finalización es independiente del estado técnico.

Ejemplos:

- `FINALIZADO + PENDIENTE`;
- `FINALIZADO + SINCRONIZANDO`;
- `FINALIZADO + CONFLICTO`;
- `FINALIZADO + CONFIRMADO`.

## 21.2 Durabilidad

La finalización local requiere que el estado necesario para reconstruir la revisión, sus respuestas y referencias de evidencia quede persistido de forma durable.

## 21.3 Permisos

Esta capacidad de ejecución/finalización inicial corresponde a `TECHNICIAN` dentro de clientes autorizados.

`COMPANY_ADMIN` no obtiene ejecución inicial mediante el mecanismo offline.

---

# 22. Sincronización de mantenimiento finalizado

Flujo conceptual:

1. el mantenimiento queda `FINALIZADO + SYNC PENDIENTE`;
2. su revisión local, respuestas y evidencias quedan persistidas;
3. la outbox conserva la intención idempotente;
4. al volver conectividad se revalida autorización;
5. se comprueba la precondición remota necesaria;
6. se aplica o reconoce la revisión de forma atómica según el dominio;
7. se procesan/asocian archivos pendientes respetando dependencias;
8. se obtiene confirmación válida del estado estructurado;
9. cada archivo sólo se considera confirmado cuando su almacenamiento/asociación remota está confirmado;
10. cuando todo el conjunto requerido para esa revisión está confirmado, la vista puede reflejar `FINALIZADO + SYNC CONFIRMADO`.

## 22.1 Confirmación parcial

Si datos estructurados están confirmados pero hay archivos pendientes:

- el mantenimiento sigue funcionalmente finalizado;
- la UI debe mostrar que aún existen elementos pendientes;
- los archivos permanecen locales.

## 22.2 Conflicto

Si el estado remoto evolucionó:

- no se sobrescribe;
- se crea un conflicto;
- se preserva la revisión local propuesta;
- la resolución autorizada crea una nueva revisión.

---

# 23. Autorización offline

## 23.1 DO-075 — RESUELTA/APROBADA

Se preserva exactamente:

- la autorización offline puede mantenerse un máximo de **7 días** desde la última validación online;
- superado ese plazo no pueden iniciarse nuevas operaciones;
- se requiere conectividad y revalidación;
- una revocación conocida por el servidor debe aplicarse al recuperar conectividad;
- el trabajo ya capturado localmente **NO** debe eliminarse.

Este documento no reabre el plazo ni propone otro.

## 23.2 `OfflineAuthorizationState`

Debe contener conceptualmente información suficiente para determinar:

- identidad a la que pertenece;
- momento de última validación online;
- vigencia calculable respecto del máximo aprobado;
- membership conocida;
- rol conocido;
- clientes autorizados conocidos;
- estado comercial conocido cuando corresponda;
- resultado/estado de la última revalidación.

No se definen tokens, claims ni credenciales concretas.

## 23.3 No es autoridad

`OfflineAuthorizationState` es evidencia local de una validación previa, no una garantía de que el servidor no haya cambiado desde entonces.

Su vigencia permite operar localmente sólo dentro de DO-075.

---

# 24. Vencimiento de los 7 días

Al vencer la autorización offline:

- no pueden iniciarse nuevas operaciones;
- se conservan datos;
- se conserva la outbox;
- se conservan fotografías/archivos;
- se conservan conflictos;
- se requiere conectividad y revalidación para obtener nueva autorización.

## 24.1 Significado conceptual de “iniciar nueva operación”

Una nueva operación es la apertura de una **nueva intención de dominio autónoma** después del vencimiento, por ejemplo:

- iniciar un mantenimiento nuevo;
- iniciar una corrección nueva;
- iniciar una resolución de conflicto nueva;
- iniciar otra acción de escritura que constituya un nuevo flujo de dominio.

No se considera “iniciar nueva operación” el mero hecho técnico de:

- reabrir la aplicación;
- leer datos ya disponibles;
- preservar trabajo existente;
- reintentar técnicamente una intención ya creada antes del vencimiento.

## 24.2 Trabajo iniciado antes del vencimiento

Una intención de dominio creada válidamente antes del vencimiento no se destruye al cumplirse los 7 días.

Sus datos permanecen asociados a la operación original.

El vencimiento no convierte automáticamente esa intención en autorizada para aplicarse remotamente: la sincronización debe esperar o efectuar la revalidación necesaria.

Este documento no crea una autorización offline indefinida mediante “operaciones abiertas”.

---

# 25. Reconexión y revalidación

Al recuperar conectividad funcional se debe comprobar estado vigente.

## 25.1 Membership deshabilitada

Impide nuevas operaciones y sync no autorizado.

El trabajo local permanece preservado.

## 25.2 Cambio de rol

El rol remoto actual prevalece.

Una identidad que dejó de ser `TECHNICIAN` no conserva capacidad de ejecución inicial sólo porque la réplica tenga el rol anterior.

## 25.3 Cliente revocado

La operación sobre ese cliente deja de ser automáticamente elegible.

No se borra trabajo pendiente.

## 25.4 Cliente nuevo

Puede incorporarse a la réplica mediante bootstrap incremental.

## 25.5 Suscripción inactiva

El acceso online del tenant queda bloqueado conforme a la baseline.

No se destruyen datos.

## 25.6 Soporte revocado

Si existen contextos locales de soporte, un grant revocado deja de permitir acceso remoto posterior.

Este documento no extiende por defecto el modelo de field-offline a `SUPER_ADMIN`.

## 25.7 Regla de precedencia

El estado remoto vigente prevalece para:

- nuevas acciones;
- nuevas lecturas remotas;
- sync;
- resolución de permisos.

El estado local previo sólo sirve para preservar y representar el trabajo ya capturado.

---

# 26. Trabajo capturado antes de una revocación

## 26.1 Baseline

Debe cumplirse simultáneamente:

- el trabajo **NO** se elimina;
- la outbox **NO** se elimina por la revocación;
- los archivos **NO** se eliminan;
- la operación **NO** se asume automáticamente todavía autorizada.

## 26.2 Categorías conceptuales

Una operación puede quedar:

- **pendiente de revalidación**: aún no se conoce el estado remoto actual;
- **bloqueada por autorización**: el estado vigente indica que el actor ya no puede aplicarla;
- **requiere intervención/resolución**: el sistema necesita una política o actor autorizado para decidir su destino;
- **autorizada para continuar**: tras revalidación positiva y satisfacción de las demás condiciones.

## 26.3 `OFF-OPEN-001` — Destino de trabajo pendiente tras revocación

**Motivo:** la baseline obliga a conservar el trabajo y prohíbe asumir que puede sincronizarse, pero no define quién o bajo qué mecanismo puede rescatar, reasignar, incorporar o descartar formalmente una operación que quedó bloqueada por revocación.

**Alternativas conceptuales:**

- permitir sincronización sólo si la misma identidad recupera autorización suficiente;
- permitir un flujo explícito de recuperación por un actor autorizado, preservando autoría original;
- mantenerlo bloqueado hasta una decisión administrativa;
- una combinación según tipo de operación.

**Recomendación:** diseñar un flujo explícito de recuperación que nunca reescriba la autoría original ni use privilegios para forzar una operación no autorizada. La semántica exacta debe aprobarse antes de implementación offline.

**Estado:** **ABIERTO — pendiente de aprobación**.

**Bloquea Fase 1:** no.

**Debe resolverse antes de:** Fase 5, antes de implementar sincronización de trabajo bloqueado por revocación.

---

# 27. Cambio de clientes autorizados

## 27.1 Cliente añadido

Tras revalidación:

- se incorpora al alcance local;
- se ejecuta bootstrap de los datos necesarios;
- queda disponible offline cuando el conjunto requerido esté completo.

## 27.2 Cliente revocado

Una vez conocida la revocación:

- no se inician nuevas operaciones;
- no se realizan nuevas lecturas remotas de ese cliente;
- no se sincronizan operaciones como si el usuario siguiera autorizado;
- no se actualiza su réplica con nuevos datos remotos.

La revocación no debe:

- borrar silenciosamente trabajo pendiente;
- borrar fotografías pendientes;
- exponer datos al siguiente usuario;
- convertir los datos en compartidos.

## 27.3 Datos ya sincronizados frente a pendientes

Debe distinguirse:

- **pendientes/no confirmados:** nunca se purgan automáticamente sólo por revocación;
- **sincronizados y reproducibles desde remoto:** pueden ser candidatos a una futura política de limpieza;
- **necesarios para interpretar históricos locales:** no deben eliminarse sin preservar coherencia;
- **conflictos:** deben conservarse hasta resolución/decisión.

## 27.4 `OFF-OPEN-002` — Conservación/purga de datos ya sincronizados de cliente revocado

**Motivo:** la baseline impide pérdida de pendientes, pero no define cuánto tiempo ni bajo qué condiciones debe conservarse en el dispositivo una copia ya sincronizada de un cliente que dejó de estar autorizado.

**Alternativas conceptuales:**

- purga segura tras confirmar que no existen pendientes/dependencias;
- conservación local hasta una limpieza explícita;
- política basada en capacidad/dispositivo y posibilidad de reconstrucción;
- combinación con una eventual política legal.

**Recomendación:** separar estrictamente la política de datos sincronizados revocables de la protección absoluta de trabajo pendiente; no adoptar purga destructiva hasta que la política sea aprobada.

**Estado:** **ABIERTO — pendiente de aprobación**.

**Bloquea Fase 1:** no.

**Debe resolverse antes de:** Fase 5 para el comportamiento de limpieza/revocación local; cualquier obligación de retención legal sigue dependiendo de DO-T07.

---

# 28. Estado comercial y offline

## 28.1 Regla online

Una empresa con suscripción inactiva pierde acceso online conforme a la baseline.

Los datos remotos permanecen.

## 28.2 Regla offline

Una autorización comercial previamente validada puede mantenerse offline únicamente dentro de DO-075.

No existe un segundo plazo comercial offline.

## 28.3 Reconexión

Si al revalidar la empresa está inactiva:

- el estado remoto vigente prevalece;
- no se aplican operaciones remotas como si siguiera activa;
- el trabajo local se conserva.

## 28.4 Reactivación

Cuando el estado comercial remoto vuelve a permitir acceso, la elegibilidad de operaciones pendientes se vuelve a evaluar junto con:

- identidad;
- membership;
- rol;
- clientes;
- conflictos;
- dependencias.

---

# 29. Logout

Logout debe:

- cerrar el contexto activo;
- liberar referencias en memoria a la réplica de la identidad;
- impedir que la siguiente sesión use esa réplica;
- impedir que la siguiente sesión use outbox de la identidad anterior;
- impedir que la siguiente sesión use archivos pendientes de la identidad anterior;
- conservar trabajo pendiente cuando técnicamente sea posible;
- no asumir que una futura sesión de la misma identidad seguirá autorizada.

Una sesión posterior de la misma identidad debe respetar:

- vigencia de DO-075;
- revalidación al recuperar conexión;
- estado remoto vigente.

---

# 30. Dispositivo compartido

Escenario:

**Usuario A logout → Usuario B login**

Usuario B no puede:

- abrir datos de A;
- listar clientes de A desde la réplica de A;
- leer mantenimientos/respuestas de A;
- sincronizar outbox de A;
- subir fotografías de A;
- resolver conflictos de A;
- reutilizar metadata de autorización de A.

Esto se mantiene aunque A y B:

- pertenezcan al mismo tenant;
- tengan el mismo cliente autorizado;
- vean remotamente recursos equivalentes.

Si B necesita esos datos, debe obtenerlos mediante su propia réplica y su propia autorización.

---

# 31. Conflictos de sincronización

`SyncConflict` representa una divergencia que no puede resolverse automáticamente sin riesgo de pérdida o sobrescritura indebida.

## 31.1 Información que debe preservar

Conceptualmente:

- recurso afectado;
- operación local;
- identidad de la operación;
- actor que originó el cambio;
- revisión/versión esperada;
- propuesta local completa o reproducible;
- estado remoto actual;
- diferencias relevantes;
- tipo/motivo de conflicto;
- actor que resuelve;
- decisión de resolución;
- nueva revisión/resultado cuando corresponda;
- trazabilidad de cierre.

## 31.2 Regla de conservación

La detección de conflicto no elimina:

- versión local;
- versión remota;
- archivos locales asociados;
- metadata necesaria para resolver.

## 31.3 Prohibición de LWW

No se selecciona automáticamente “lo último por timestamp” como resolución para registros críticos.

---

# 32. Detección de conflictos

## 32.1 Base esperada

Una operación local que modifica estado existente debe conocer conceptualmente la base sobre la que fue realizada:

- versión;
- revisión;
- precondición;
- token de concurrencia equivalente.

## 32.2 Optimistic concurrency

Al intentar aplicar el cambio, el servidor debe poder verificar que la base esperada sigue vigente.

Si no coincide:

- no sobrescribe;
- devuelve/expone estado suficiente para reconciliar;
- se crea o actualiza `SyncConflict`.

## 32.3 No se fijan columnas

Este documento no decide si la precondición se implementará mediante:

- ordinal de revisión;
- versión numérica;
- identificador de revisión;
- mecanismo equivalente.

La decisión física debe preservar el mismo principio.

---

# 33. Recursos críticos frente a no críticos

## 33.1 Mantenimiento y revisiones

Son críticos.

Deben preservar ambas versiones y requerir resolución explícita cuando exista divergencia sobre una base ya evolucionada.

## 33.2 Respuestas y evidencias

Forman parte del estado de una revisión y heredan su necesidad de preservación/consistencia.

No deben resolverse aisladamente de forma que produzcan una revisión incoherente.

## 33.3 Datos maestros

Para datos que el usuario offline sólo consume como copia remota y no modifica localmente, el refresh remoto puede reemplazar la copia cacheada siempre que:

- no exista una operación local pendiente que dependa de la versión anterior;
- se preserven históricos necesarios;
- no se destruya información requerida para interpretar trabajo local.

No todo refresh de un nombre de equipo requiere UI de conflicto.

## 33.4 Formularios publicados

Son inmutables.

Una nueva versión se incorpora como nueva definición; no se trata como actualización destructiva de la versión publicada anterior.

## 33.5 Política específica

Si en el futuro se aprueban escrituras offline de otros agregados administrativos, cada uno deberá definir si requiere conflicto explícito. Este documento no amplía el alcance funcional para crearlas.

---

# 34. Resolución de conflicto de mantenimiento

## 34.1 Actores autorizados

Puede resolver:

- `TECHNICIAN` dentro de sus clientes autorizados;
- `COMPANY_ADMIN` dentro de su alcance.

## 34.2 Resultado obligatorio

La resolución:

- es explícita;
- no sobrescribe revisiones históricas;
- crea una nueva `MaintenanceRevision`;
- preserva revisiones anteriores;
- preserva evidencia histórica.

## 34.3 `COMPANY_ADMIN`

La capacidad de resolver conflicto **NO** concede:

- iniciar un mantenimiento;
- ejecutar la primera captura;
- finalizar la ejecución inicial.

Su escritura existe únicamente dentro del flujo autorizado de resolución/corrección.

## 34.4 Revalidación

Resolver un conflicto también requiere autorización vigente al momento remoto de aplicar la resolución.

---

# 35. Diferencias mostradas al usuario

La resolución debe presentar un **diff semántico**, no un diff técnico de JSON, filas o blobs.

Conceptualmente debe permitir comparar:

- valores de campos;
- campos cambiados;
- respuestas agregadas/eliminadas cuando el modelo lo permita;
- evidencia local/remota relevante;
- revisión base;
- revisión remota;
- propuesta local;
- contexto de actor/fecha necesario para decidir.

La UI final no se diseña aquí.

El objetivo es que el actor pueda responder:

> ¿Qué cambió funcionalmente entre la base que yo vi, mi propuesta local y el estado remoto actual?

---

# 36. Conflictos con fotografías

## 36.1 Revisión remota cambió y hay fotos locales

Las fotografías locales no se descartan.

Deben permanecer asociadas a la propuesta local/conflicto hasta que exista una resolución.

## 36.2 Upload ya iniciado

Si un upload se completó técnicamente pero la revisión entra en conflicto, el sistema debe evitar convertir el archivo en evidencia activa de una revisión incorrecta.

El futuro protocolo debe poder distinguir almacenamiento de contenido y asociación autoritativa al dominio.

## 36.3 Resolución

La resolución puede determinar qué evidencias forman parte de la nueva revisión, siempre respetando:

- inmutabilidad de evidencias históricas;
- no eliminación silenciosa;
- autorización del actor;
- trazabilidad.

## 36.4 Archivos no utilizados

Si un archivo termina sin asociación remota válida, puede convertirse en candidato a limpieza posterior sólo cuando no exista dependencia, retry, conflicto o necesidad de recuperación. No se fija una retención.

---

# 37. Orden y atomicidad de sincronización

## 37.1 Invariantes de dominio

La sincronización no debe exponer estados remotos imposibles como:

- mantenimiento finalizado sin respuestas requeridas;
- revisión visible parcialmente;
- evidencia asociada a respuesta inexistente;
- child confirmado sin parent necesario;
- resolución de conflicto sin nueva revisión histórica.

## 37.2 Unidad atómica conceptual

Para mantenimiento, la creación/confirmación de una revisión y el conjunto estructurado de respuestas requerido para que esa revisión sea válida deben tratarse como una unidad de dominio coherente.

Los archivos pueden requerir un protocolo separado por su naturaleza, pero su asociación final debe respetar la coherencia de la revisión.

## 37.3 Ordenamiento

El sincronizador debe:

- respetar dependencias;
- no adelantar children;
- no continuar un grupo si el parent entró en conflicto/autorización bloqueada;
- confirmar explícitamente cada efecto.

No se escriben transacciones SQL ni scheduler.

---

# 38. Confirmación remota

Una operación puede salir de la outbox únicamente cuando exista confirmación válida de que su efecto esperado:

- fue aplicado;
- o ya había sido aplicado previamente y fue reconocido idempotentemente;
- y corresponde a la misma identidad lógica de operación/recurso.

No basta con:

- request enviado;
- conexión abierta;
- bytes transferidos;
- status ambiguo sin poder correlacionar el efecto.

## 38.1 Resultado autoritativo

La confirmación debe permitir actualizar la réplica con:

- identidad remota reconocida;
- revisión/versión aceptada;
- estado de sync;
- información autoritativa necesaria.

## 38.2 Conflicto/autorización

Una respuesta de conflicto o autorización denegada no equivale a confirmación exitosa y no elimina la operación.

---

# 39. Pull después de push

Después de una mutación confirmada, debe obtenerse o reconciliarse la representación autoritativa suficiente del recurso.

## 39.1 Motivo

El servidor puede haber:

- asignado revisión/ordinal;
- normalizado datos;
- aplicado reglas;
- rechazado parte no válida de una solicitud compuesta, si el protocolo futuro lo permitiera;
- incorporado cambios concurrentes.

La réplica no debe asumir que “lo que intenté enviar” es necesariamente “lo que el servidor aceptó”.

## 39.2 Alcance

No siempre es necesario redescargar todo el cliente.

Debe refrescarse lo suficiente para garantizar convergencia del recurso afectado y dependencias relevantes.

---

# 40. Actualizaciones de formularios

## 40.1 Inmutabilidad

Una `FormVersion` publicada es inmutable.

Una nueva publicación genera una nueva versión, no modifica la anterior.

## 40.2 Réplica

Debe poder coexistir localmente:

- versión anterior necesaria para históricos/trabajo iniciado;
- versión nueva aplicable para nuevos mantenimientos.

## 40.3 Nuevas operaciones

Las nuevas operaciones utilizan la versión aplicable según las reglas aprobadas.

## 40.4 Trabajo existente

Un mantenimiento ya creado conserva la versión exacta con la que fue iniciado; una actualización de formularios no lo migra silenciosamente.

## 40.5 Decisiones preservadas

Este documento **NO resuelve**:

- `DM-OPEN-002` — cardinalidad de formularios aplicables;
- `DM-OPEN-003` — equipo sin formulario aplicable;
- `DM-OPEN-004` — cantidad de borradores simultáneos.

Tampoco resuelve `DM-OPEN-001` sobre obligatoriedad de `EquipmentType`.

---

# 41. Evolución de la estructura local

La réplica cambiará de estructura entre versiones de la aplicación.

## 41.1 Objetivo

Una actualización local debe preservar:

- outbox;
- trabajo no sincronizado;
- revisiones locales;
- conflictos;
- fotografías/archivos pendientes;
- identidades estables;
- relaciones necesarias para retry.

## 41.2 Regla de seguridad

Una migración local no debe asumir que todo dato puede reconstruirse desde servidor.

Los datos pendientes pueden existir únicamente en el dispositivo.

## 41.3 Actualización incompatible

Si una versión nueva no puede migrar de forma segura, debe evitar una activación destructiva y conservar un camino de recuperación.

El mecanismo concreto de versionado/migración Dexie queda fuera de este documento.

## 41.4 Pruebas

Las migraciones locales futuras deben probarse con estados reales como:

- outbox no vacía;
- upload interrumpido;
- conflicto pendiente;
- autorización vencida;
- logout con trabajo pendiente.

---

# 42. Limpieza de datos locales

## 42.1 Datos sincronizados

Copias remotas reproducibles pueden ser refrescadas o descartadas bajo una política segura cuando ya no son necesarias.

## 42.2 Datos pendientes

No deben eliminarse automáticamente para liberar espacio.

## 42.3 Archivos no confirmados

No deben limpiarse antes de confirmación válida o decisión explícita de recuperación/abandono conforme a política aprobada.

## 42.4 Conflictos

No deben purgarse mientras sean necesarios para resolver o auditar la reconciliación.

## 42.5 Históricos

Las versiones de formularios y datos necesarios para interpretar trabajo local/histórico deben preservarse mientras exista esa dependencia.

## 42.6 Revocaciones

La limpieza de datos ya sincronizados de clientes revocados depende de `OFF-OPEN-002`.

## 42.7 Sin cuotas inventadas

No se fija:

- número máximo de registros;
- días de cache;
- MB;
- cantidad de fotos.

---

# 43. Presión de almacenamiento

La ausencia de cuotas funcionales/comerciales no elimina restricciones físicas reales.

## 43.1 Escenarios

La aplicación debe poder manejar:

- poco espacio disponible;
- cuota de IndexedDB alcanzada;
- storage del navegador lleno;
- almacenamiento persistente no concedido;
- archivo que no puede persistirse por capacidad técnica;
- fallo durante escritura.

## 43.2 Comportamiento

Debe tratarse como error técnico visible.

La aplicación no debe declarar que una captura quedó guardada si no pudo persistirla.

## 43.3 Prioridad

Ante presión de almacenamiento:

1. no borrar pendientes;
2. no borrar archivos no confirmados;
3. no borrar conflictos;
4. identificar primero caches/copias reproducibles candidatas a limpieza;
5. pedir intervención si no existe espacio seguro.

## 43.4 Sin nueva cuota comercial

Un límite técnico del dispositivo/proveedor no debe presentarse como una política comercial del producto.

---

# 44. Observabilidad de sincronización

La arquitectura debe conservar metadata suficiente para diagnosticar, por identidad y operación:

- operación pendiente;
- recurso afectado;
- dependencia;
- último intento;
- resultado del último intento;
- error actual;
- clasificación del error;
- conflicto asociado;
- archivo pendiente;
- estado de upload;
- reintento;
- confirmación remota;
- bloqueo por autorización;
- precondición esperada;
- momento de última revalidación relevante.

No se define stack de logging, métricas o tracing.

## 44.1 Privacidad

La observabilidad no justifica almacenar:

- contenidos sensibles innecesarios;
- blobs duplicados;
- credenciales;
- secretos.

Debe registrar contexto suficiente para diagnóstico sin ampliar exposición.

---

# 45. UX mínima offline

La UI debe comunicar como mínimo:

- online/offline;
- conectividad funcional cuando pueda determinarse;
- número de operaciones pendientes;
- sincronizando;
- operación bloqueada por autorización/revalidación;
- conflicto;
- mantenimiento finalizado aunque esté pendiente;
- fotografía/archivo pendiente;
- error de persistencia local;
- necesidad de revalidar al vencer DO-075.

## 45.1 No inducir a error

No debe mostrarse “sincronizado” sólo porque:

- `navigator.onLine` sea true;
- se envió un request;
- el mantenimiento esté finalizado localmente.

## 45.2 Finalización

La UI debe diferenciar claramente:

- “guardado/finalizado en este dispositivo”;
- “confirmado remotamente”.

No se diseña componente visual ni copy final.

---

# 46. Fallos y recuperación

## 46.1 PWA cerrada durante sync

Al reabrir:

- outbox persiste;
- operaciones con resultado incierto se reevalúan idempotentemente;
- no se crean nuevas identidades de operación.

## 46.2 Navegador terminado

El trabajo persistido debe poder reconstruirse desde almacenamiento durable.

No se depende de memoria.

## 46.3 Dispositivo reiniciado

La réplica debe reabrirse para la misma identidad conforme a las reglas de acceso local.

## 46.4 Caída de red a mitad de upload

El archivo permanece local.

El retry reutiliza la misma identidad lógica.

## 46.5 Respuesta HTTP perdida

La operación conserva estado incierto/pending y se reconcilia idempotentemente.

## 46.6 Sesión vencida

Se reautentica/revalida antes de continuar sync remoto.

No se borra outbox.

## 46.7 Usuario revocado

Se bloquean operaciones remotas no autorizadas y se preserva el trabajo.

## 46.8 Storage remoto caído

Los archivos permanecen pendientes aunque la parte estructurada del mantenimiento pueda tener otro estado de confirmación.

## 46.9 Error parcial

El sistema debe preservar suficiente información para saber qué subefectos están confirmados y cuáles no, sin repetir efectos ya confirmados.

La arquitectura debe preferir unidades atómicas de dominio para reducir parciales imposibles.

---

# 47. Seguridad de datos locales

## 47.1 Controles derivados de DO-T04

Se requiere:

- aislamiento por identidad;
- apertura exclusiva de la réplica activa;
- outbox y archivos dentro de la misma frontera;
- cierre de referencias de la identidad anterior al cambiar de sesión;
- no compartir caches operativos entre identidades;
- no usar la persistencia local como prueba de autorización remota.

## 47.2 Protección frente a otro usuario de la app

El particionado y el control de apertura deben impedir acceso accidental desde una sesión distinta.

## 47.3 Protección frente a pérdida física

El navegador por sí solo no garantiza protección total frente a un atacante con control suficiente del dispositivo/perfil.

La seguridad real puede depender de:

- bloqueo/cifrado del sistema operativo;
- aislamiento del perfil del navegador;
- políticas del dispositivo;
- posible cifrado adicional si se aprueba.

## 47.4 Cifrado potencial

Permanece pendiente de aprobación dentro de DO-T04.

No debe prometerse que cifrar IndexedDB “resuelve” por sí solo la seguridad local.

---

# 48. Relación con RLS

## 48.1 RLS vuelve a aplicar al sincronizar

Toda operación remota normal debe ser autorizada de nuevo por la frontera de datos/backend correspondiente.

## 48.2 Outbox no concede derechos

La existencia de una operación en outbox demuestra que el dispositivo preserva una intención local.

No demuestra que el usuario todavía tenga permiso.

## 48.3 IDs locales

Un ID generado offline:

- permite identidad estable;
- ayuda a idempotencia;

pero no demuestra ownership ni autorización.

## 48.4 Revocación

Una operación creada mientras el usuario estaba autorizado puede ser rechazada después si el estado vigente ya no permite aplicarla.

## 48.5 Backend privilegiado

No se puede usar `service-role` para “forzar” sync y saltar:

- membership deshabilitada;
- cliente revocado;
- rol cambiado;
- suscripción inactiva;
- ownership.

Si un proceso privilegiado participa técnicamente, debe reconstruir la autorización y respetar el mismo resultado que la política aprobada.

---

# 49. Testing obligatorio

Estas categorías deberán convertirse en pruebas antes de considerar implementada la estrategia.

## 49.1 Offline

- iniciar trabajo sin red con autorización offline vigente;
- continuar captura sin red;
- finalizar sin red;
- cerrar y abrir la PWA;
- conservar outbox;
- conservar fotografías;
- abrir una versión histórica de formulario necesaria;
- vencer autorización sin borrar trabajo.

## 49.2 Idempotencia

- procesar el mismo sync dos veces;
- simular respuesta perdida;
- retry después de timeout;
- cerrar PWA después de aplicar remoto pero antes de marcar confirmación local;
- repetir upload del mismo intento lógico;
- repetir corrección/resolución.

## 49.3 Identidad

- Usuario A trabaja y hace logout;
- Usuario B inicia sesión;
- B no puede leer réplica de A;
- B no puede procesar outbox de A;
- B no puede subir fotos de A;
- A vuelve posteriormente y encuentra su trabajo preservado.

## 49.4 Autorización

- membership revocada al reconectar;
- rol cambiado;
- cliente revocado;
- nuevo cliente concedido;
- expiración exacta de la ventana de 7 días;
- suscripción inactiva;
- operación pendiente creada antes de revocación;
- `COMPANY_ADMIN` intentando ejecución inicial debe ser rechazado;
- `TECHNICIAN` autorizado mantiene ejecución inicial dentro de cliente permitido.

## 49.5 Conflictos

- dos cambios concurrentes sobre mantenimiento;
- precondición remota inválida;
- ambas versiones conservadas;
- diff semántico disponible;
- resolución por actor autorizado;
- nueva `MaintenanceRevision`;
- revisiones previas preservadas;
- retry de resolución no duplica revisión.

## 49.6 Archivos

- upload interrumpido;
- archivo local conservado;
- respuesta perdida después de upload;
- confirmación remota antes de limpieza;
- conflicto con foto local no subida;
- storage remoto temporalmente indisponible.

## 49.7 Dependencias/atomicidad

- child bloqueado hasta parent;
- parent rechazado por autorización;
- parent en conflicto;
- no aparece revisión finalizada sin respuestas requeridas;
- no se asocia evidencia a respuesta inexistente.

## 49.8 Evolución local

- upgrade de réplica con outbox;
- upgrade con fotos pendientes;
- upgrade con conflicto;
- rollback/recuperación ante migración local fallida sin perder pendientes.

No se escriben tests en este documento.

---

# 50. Anti-patrones prohibidos

Quedan expresamente prohibidos:

- network-first para trabajo de campo crítico;
- almacenar trabajo sólo en React state antes de sync;
- borrar outbox al logout;
- compartir una IndexedDB operativa sin aislamiento entre identidades;
- usar `localStorage` como almacén principal de datos operativos;
- considerar `navigator.onLine` como prueba definitiva de conectividad;
- eliminar una fotografía antes de confirmación remota válida;
- marcar una operación como sincronizada sólo porque se envió;
- generar IDs nuevos en cada retry;
- Last Write Wins silencioso;
- sobrescribir revisión remota sin precondición;
- borrar versión local al detectar conflicto;
- permitir sync sólo porque la operación fue creada cuando el usuario estaba autorizado;
- usar `service-role` para saltar una revocación;
- mezclar estado de negocio y estado de sincronización;
- borrar trabajo al vencer los 7 días;
- descargar todo el tenant para un técnico por comodidad;
- reutilizar outbox o archivos de otra identidad;
- tratar cache de Service Worker como base operativa;
- asumir ejecución en background garantizada por Android/navegador;
- purgar datos pendientes para resolver presión de almacenamiento;
- convertir una falla de almacenamiento local en un falso “guardado correcto”.

---

# 51. Riesgos

## 51.1 Riesgos ya definidos en baseline y su tratamiento offline

| Riesgo baseline | Evaluación en esta estrategia | Tratamiento |
|---|---|---|
| Pérdida de datos offline | Crítico | persistencia local-first, outbox durable, no depender de red/memoria |
| Conflictos sobrescritos | Alto | optimistic concurrency, conservar ambas versiones, resolución explícita |
| Fotografías perdidas | Crítico | persistencia local hasta confirmación remota válida |
| Dispositivo compartido | Crítico | réplica por identidad, apertura exclusiva, no reutilización |
| Suspensión vs offline | Alto | DO-075 como única ventana offline; revalidación al reconectar |
| Almacenamiento local por fotografías/archivos | Alto | errores visibles, limpieza segura de copias reproducibles, nunca borrar pendientes |
| Revocación remota confundida con borrado local | Alto | separar autorización y conservación |
| Ampliación accidental de permisos de `COMPANY_ADMIN` | Alto | operación inicial sólo para `TECHNICIAN`; tests negativos |

## 51.2 Riesgos derivados

### `OFF-RSK-001` — Outbox corrupta

**Impacto:** pérdida de capacidad para reintentar o reconstruir intenciones.

**Tratamiento:** operaciones autocontenidas/referenciables, integridad local, migraciones seguras, diagnóstico y pruebas de recuperación.

### `OFF-RSK-002` — Dependencias rotas

**Impacto:** child aplicado sin parent o bloqueo permanente.

**Tratamiento:** dependencias explícitas y no elegibilidad hasta confirmación del parent.

### `OFF-RSK-003` — Sync duplicado

**Impacto:** mantenimientos/revisiones/evidencias duplicadas.

**Tratamiento:** identidad estable e idempotencia extremo a extremo.

### `OFF-RSK-004` — Autorización obsoleta

**Impacto:** operación remota ejecutada después de revocación.

**Tratamiento:** revalidación, RLS, no usar estado local como autoridad.

### `OFF-RSK-005` — Purga incorrecta

**Impacto:** pérdida de pendientes o datos requeridos para históricos.

**Tratamiento:** clasificar pendientes/conflictos/archivos como no purgables automáticamente; resolver `OFF-OPEN-002`.

### `OFF-RSK-006` — Migración local destruye pendientes

**Impacto:** pérdida irreversible porque los datos no existen aún en servidor.

**Tratamiento:** upgrades preservadores y pruebas con estados no sincronizados.

### `OFF-RSK-007` — Almacenamiento agotado

**Impacto:** incapacidad para capturar o finalizar de forma durable.

**Tratamiento:** detectar error de persistencia, comunicarlo, limpiar sólo datos reproducibles.

### `OFF-RSK-008` — Conflicto no resoluble

**Impacto:** operación bloqueada indefinidamente.

**Tratamiento:** preservar ambas versiones y prever intervención autorizada; no borrar.

### `OFF-RSK-009` — Archivos huérfanos

**Impacto:** consumo local/remoto y evidencia no asociada.

**Tratamiento:** identidad/correlación estable, asociación confirmada y limpieza sólo cuando no exista dependencia.

### `OFF-RSK-010` — Réplica equivocada abierta

**Impacto:** fuga de datos entre identidades.

**Tratamiento:** binding identidad→réplica, cambio de sesión seguro y pruebas A→B.

### `OFF-RSK-011` — Falso positivo de conectividad

**Impacto:** UI inconsistente, retries agresivos, operaciones aparentemente “atascadas”.

**Tratamiento:** distinguir señal de red de acceso remoto funcional.

### `OFF-RSK-012` — Estado local confirmado sin confirmación remota real

**Impacto:** pérdida posterior o divergencia silenciosa.

**Tratamiento:** confirmación correlacionada e idempotente antes de retirar outbox.

### `OFF-RSK-013` — Aplicación actualizada con réplica incompatible

**Impacto:** PWA inutilizable offline o pérdida de datos.

**Tratamiento:** coordinación de evolución local con activación de assets.

### `OFF-RSK-014` — Cifrado local mal diseñado

**Impacto:** falsa sensación de seguridad o pérdida irrecuperable de outbox.

**Tratamiento:** no aprobar cifrado sin threat model, key management y recuperación.

### `OFF-RSK-015` — Trabajo previo a revocación sin ruta de destino

**Impacto:** datos preservados pero operacionalmente bloqueados.

**Tratamiento:** resolver `OFF-OPEN-001` antes de Fase 5.

### `OFF-RSK-016` — Operación “abierta” usada para eludir DO-075

**Impacto:** autorización offline indefinida.

**Tratamiento:** identidad de operación creada dentro de vigencia y revalidación obligatoria para sync/nuevas operaciones; no permitir encadenar nuevas intenciones bajo una operación antigua.

---

# 52. Decisiones candidatas a ADR

Este documento no genera ADRs, pero identifica candidatos.

| Candidato | Motivo |
|---|---|
| Local-first + outbox durable | Define el patrón principal de escritura y recuperación offline |
| Partición local por identidad | Es frontera de seguridad local y afecta estructura de persistencia |
| Estrategia de identidad de recursos/operaciones | Condiciona idempotencia y referencias offline |
| Sincronización idempotente | Afecta protocolo cliente-servidor y recuperación |
| Optimistic concurrency + modelo de conflicto | Define cómo se evita LWW y cómo se preservan revisiones |
| Separación business state / sync state | Invariante transversal de dominio/UX |
| Protección local DO-T04 | Requiere formalizar aislamiento y eventual cifrado |
| Service Worker vs IndexedDB | Define responsabilidades y evita mezclar cache de assets con datos operativos |
| Orden push/revalidación/pull | Afecta seguridad y convergencia |
| Estrategia de archivos pendientes | Afecta persistencia local, Storage e idempotencia |
| Evolución/migración de réplica | Afecta actualización segura de PWA con trabajo pendiente |

La numeración y contenido de ADRs se definirán sólo cuando corresponda y tras aprobación del documento.

---

# 53. Decisiones abiertas

## 53.1 DO-075

**Estado:** **RESUELTA/APROBADA**.

No se reabre.

Regla preservada:

- máximo 7 días desde última validación online;
- vencido el plazo no se inician nuevas operaciones;
- se requiere conectividad/revalidación;
- revocación conocida se aplica al reconectar;
- trabajo capturado no se elimina.

## 53.2 DO-T03 — Invalidación efectiva de sesiones

**Estado:** **PARCIALMENTE ABIERTO**.

Cerrado a nivel de producto:

- revocar/deshabilitar debe cerrar sesiones;
- acceso online debe quedar bloqueado;
- DO-075 gobierna offline.

Propuesta heredada de `03`:

- corte autoritativo de datos;
- cierre efectivo de sesión/credenciales renovables.

**Estado de la propuesta:** **PENDIENTE DE APROBACIÓN**.

Este documento no la resuelve.

**Bloquea Fase 1:** no como documento, pero debe resolverse antes de implementar Fase 2; sus implicaciones offline deben estar coordinadas antes de Fase 5.

## 53.3 DO-T04 — Protección local

**Estado:** **PROPUESTA PENDIENTE DE APROBACIÓN**.

Propuesta de este documento:

- réplica particionada por identidad;
- sesión abre exclusivamente su propia réplica;
- outbox y archivos quedan en la misma frontera;
- logout no borra pendientes;
- cambio de identidad cierra acceso a la réplica anterior;
- cifrado adicional no se declara obligatorio hasta completar threat model/key management/legal.

**Bloquea Fase 1:** no.

**Debe resolverse antes de:** Fase 5.

## 53.4 DO-T05 — Escala y rendimiento objetivo

**Estado:** **DIFERIDO**.

No se inventan volúmenes, SLOs ni cifras.

**Bloquea Fase 1:** no.

**Resolver antes de:** pruebas de performance/piloto conforme a la baseline.

## 53.5 DO-T06 — Backup, RPO/RTO y restauración

**Estado:** **DIFERIDO**.

No se inventan RPO/RTO ni políticas de backup.

**Bloquea Fase 1:** no.

**Resolver antes de:** piloto/producción.

## 53.6 DO-T07 — Privacidad/legal aplicable

**Estado:** **DIFERIDO**.

No se inventan períodos de retención, obligaciones legales ni requisitos regulatorios.

**Bloquea Fase 1:** no.

**Resolver antes de:** piloto según validación legal/contractual.

## 53.7 `DM-OPEN-*` preservadas

Permanecen sin resolver:

| ID | Tema | Bloquea Fase 1 | Resolver antes de |
|---|---|---:|---|
| `DM-OPEN-001` | obligatoriedad de `EquipmentType` | No | Fase 3 |
| `DM-OPEN-002` | cardinalidad de formularios aplicables | No | Fase 4 |
| `DM-OPEN-003` | equipo sin formulario aplicable | No | Fase 4 / antes de Fase 5 |
| `DM-OPEN-004` | borradores simultáneos de formulario | No | Fase 4 |
| `DM-OPEN-005` | unicidad de informe por cliente/período | No | Fase 6 |
| `DM-OPEN-006` | plantilla usada en regeneración de informe | No | Fase 6 |
| `DM-OPEN-007` | créditos IA insuficientes | No | Fase 7 |
| `DM-OPEN-008` | criterio temporal de inclusión en informes | No | Fase 6 |

Este documento no modifica ninguna.

## 53.8 Otras decisiones de baseline preservadas

Permanecen conforme a sus plazos:

- `DO-073`;
- `DO-074`;
- `DO-076`;
- `DO-077`;
- `DO-078`;
- `DO-T01`;
- `DO-T02`.

No se reevalúan aquí.

## 53.9 Nuevas decisiones `OFF-OPEN-*`

### `OFF-OPEN-001` — Destino de trabajo pendiente tras revocación

**Motivo:** conservar no equivale a poder sincronizar.

**Alternativas:** reautorización de la misma identidad; recuperación explícita por actor autorizado; bloqueo hasta decisión; combinación por tipo.

**Recomendación:** flujo explícito de recuperación sin alterar autoría ni bypass de autorización.

**Estado:** **ABIERTO — pendiente de aprobación**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5.

### `OFF-OPEN-002` — Conservación/purga de datos sincronizados de cliente revocado

**Motivo:** no existe política aprobada para copias locales ya sincronizadas de alcance revocado.

**Alternativas:** purga segura condicionada; conservación hasta limpieza explícita; política adaptativa; combinación posterior con requisitos legales.

**Recomendación:** no purgar destructivamente hasta separar con certeza datos reproducibles de pendientes/conflictos/históricos.

**Estado:** **ABIERTO — pendiente de aprobación**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5 para implementación de limpieza; restricciones legales dependen además de DO-T07.

---

# 54. Gate del documento

## 54.1 Contradicciones bloqueantes

**No se detectan contradicciones bloqueantes ni inconsistencias documentales conocidas entre `01-product-definition.md`, `02-domain-model.md`, `03-permissions-rls-strategy.md` y esta estrategia que impidan continuar documentando Fase 0.**

Los permisos de mantenimiento permanecen coherentes: `TECHNICIAN` conserva la ejecución inicial dentro de clientes autorizados; `COMPANY_ADMIN` mantiene lectura necesaria, corrección de mantenimientos finalizados y resolución de conflictos dentro de su alcance, sin ejecución inicial; y `SupportAccessGrant` no crea capacidades operativas nuevas por inferencia para `SUPER_ADMIN`.

## 54.2 Decisiones que bloqueen continuar Fase 0

**No se identifica una decisión abierta que impida continuar la documentación de Fase 0.**

Las decisiones abiertas poseen deadlines posteriores.

## 54.3 Estado de DO-075

**DO-075: RESUELTA/APROBADA.**

Se preserva el máximo de 7 días sin modificación.

## 54.4 Estado de DO-T03

**DO-T03: PARCIALMENTE ABIERTO.**

La propuesta técnica de corte autoritativo de datos + cierre efectivo de sesión continúa:

**PENDIENTE DE APROBACIÓN.**

No se resuelve en este documento.

## 54.5 Estado de DO-T04

**DO-T04: PROPUESTA PENDIENTE DE APROBACIÓN.**

Este documento recomienda:

- partición de persistencia por identidad;
- apertura exclusiva de la réplica de la identidad activa;
- preservación de outbox/archivos al logout;
- evaluación separada de cifrado adicional.

No se declara aprobada ni resuelta.

## 54.6 Nuevas decisiones abiertas

Se introducen:

- `OFF-OPEN-001` — destino de trabajo pendiente tras revocación;
- `OFF-OPEN-002` — conservación/purga de datos sincronizados de cliente revocado.

Ninguna bloquea Fase 1.

Ambas deben resolverse antes de la implementación relevante de Fase 5.

## 54.7 Candidatos a ADR

Como mínimo:

- local-first + outbox durable;
- partición local por identidad;
- identidad offline de recursos/operaciones;
- idempotencia;
- optimistic concurrency/conflict model;
- separación business state / sync state;
- DO-T04;
- Service Worker vs IndexedDB;
- estrategia de archivos;
- evolución de réplica.

No se genera ningún ADR en este documento.

## 54.8 Estado documental

**Estado de `04-offline-sync-strategy.md`: APROBADO.**

La aprobación de este documento:

- consolidará el contrato conceptual offline/sync;
- **NO** autorizará implementación;
- **NO** autorizará inicializar Next.js;
- **NO** autorizará crear schema Dexie;
- **NO** autorizará implementar Service Worker;
- **NO** autorizará crear SQL/migraciones;
- **NO** autorizará inicializar/configurar Supabase como fase de implementación;
- **NO** autorizará Codex;
- **NO** generará ADRs automáticamente;
- **NO** autorizará avanzar al documento 05 por sí sola.

## 54.9 Estado de Fase 0

**Estado de Fase 0: EN CURSO.**

La aprobación de este documento no cierra Fase 0.

Antes de iniciar Fase 1 debe completarse y aprobarse el conjunto documental/ADRs requerido por el Gate general del proyecto.

