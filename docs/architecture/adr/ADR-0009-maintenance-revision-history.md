# ADR-0009 — Modelo de `MaintenanceRevision` e histórico de mantenimiento

> **Ruta normativa:** `docs/architecture/adr/ADR-0009-maintenance-revision-history.md`  
> **Fase:** Fase 0 — Architecture Decision Record  
> **Estado de Fase 0:** **EN CURSO**  
> **Naturaleza:** decisión arquitectónica conceptual sobre identidad estable de mantenimiento, revisiones históricas, contenido efectivo, correcciones y resolución de conflictos; **NO constituye implementación, diseño físico de datos, SQL, migrations, RLS, API, schema Dexie ni resolución de Evidence/Reporting**

**ID: ADR-0009**  
**Title: Modelo de MaintenanceRevision e histórico de mantenimiento**  
**Status: ACCEPTED**

---

# 1. ID

`ADR-0009`

# 2. Título

`Modelo de MaintenanceRevision e histórico de mantenimiento`

# 3. Status

`ACCEPTED`

Este ADR ha sido aprobado formalmente como decisión arquitectónica para el modelo de `MaintenanceRevision` e histórico de mantenimiento del MVP.

El estado `ACCEPTED` aprueba únicamente:

- `MaintenanceRecord` como identidad estable del mantenimiento;
- `MaintenanceRevision` como estado histórico completo, efectivo e inmutable;
- una única revisión conceptualmente current/vigente por `MaintenanceRecord` en el estado autoritativo normal;
- correcciones mediante nuevas `MaintenanceRevision`;
- resoluciones de conflicto mediante nuevas `MaintenanceRevision`;
- retry idempotente de la misma intención sin duplicar revisiones;
- `MaintenanceRevision → Response = 1 → 0..*`;
- ownership conceptual de cada `Response` por una revisión específica;
- preservación de la `FormVersion` histórica exacta;
- tenant constante a lo largo del historial;
- semántica `full revision / snapshot-like domain revision`.

El estado `ACCEPTED` **NO** aprueba ni define:

- tablas, columnas, PK/FK, constraints, índices, revision number, `is_current` ni triggers;
- SQL, migrations, RLS, APIs, Server Actions, Edge Functions, ORM ni repositories;
- state machine física ni delta storage físico;
- event sourcing;
- deletion policy;
- continuidad histórica de Evidence ni effective Evidence set;
- selección/inclusión/versionado de Reporting;
- migración de formularios;
- Dexie ni schema de sincronización;
- `SupportAccessGrant` ni autorización nueva;
- ningún `DO-*` ni `*-OPEN-*`;
- implementación ni uso de Codex;
- inicio de Fase 1 ni cierre de Fase 0.

---

# 4. Context

El producto debe conservar un historial técnico inmutable y trazable de los mantenimientos finalizados, permitir correcciones posteriores sin destrucción del histórico, soportar resolución explícita de conflictos offline y mantener coherencia con formularios versionados y Reporting histórico.

La baseline aprobada ya determina que:

- `MaintenanceRecord` representa la identidad lógica persistente de un mantenimiento;
- las modificaciones históricas se expresan mediante `MaintenanceRevision`;
- una corrección crea una nueva `MaintenanceRevision`;
- una resolución de conflicto de mantenimiento crea una nueva `MaintenanceRevision`;
- las revisiones anteriores no se sobrescriben;
- sólo una revisión es conceptualmente current/vigente a la vez;
- todas las revisiones permanecen históricamente accesibles conforme a permisos aplicables;
- `MaintenanceRevision → Response` es conceptualmente `1 → 0..*`;
- las `Response` representan el contenido efectivo de la revisión a la que pertenecen;
- el mantenimiento conserva la `FormVersion` exacta utilizada;
- una publicación posterior del formulario no reinterpreta respuestas históricas;
- finalización funcional y sincronización son estados distintos;
- una revisión histórica ya establecida no debe mutarse para resolver sincronización;
- las correcciones no requieren aprobación;
- `TECHNICIAN` y `COMPANY_ADMIN` pueden corregir mantenimientos finalizados dentro del scope aprobado;
- `COMPANY_ADMIN` no adquiere por ello permiso para iniciar, ejecutar o finalizar una ejecución inicial;
- no existe asignación de técnico a `MaintenanceRecord` en el MVP;
- no existen Work Orders;
- no existe recurrencia ni calendarización;
- los tipos de mantenimiento del MVP son `preventive`, `corrective`, `predictive` e `inspection`.

`ADR-0001` está `ACCEPTED` y mantiene la arquitectura como monolito modular dentro de Next.js.

`ADR-0002` está `ACCEPTED` y exige ownership tenant inequívoco, tenant resolution autoritativa e integridad cross-tenant.

`ADR-0005` está `ACCEPTED` y exige idempotencia end-to-end, optimistic concurrency para recursos críticos/versionados cuando corresponda, preservación de ambas versiones ante divergencia incompatible, prohibición de silent Last Write Wins y resolución explícita de conflictos.

El registro maestro `docs/product/10-architecture-decisions-records.md` clasificó `ADR-0009` como `READY TO DRAFT` antes de esta aprobación y separa expresamente esta decisión de `ADR-0010`, donde debe tratarse la continuidad histórica de Evidence.

---

# 5. Problem

¿Cómo representar un mantenimiento que conserva una identidad estable a lo largo del tiempo pero cuyo contenido efectivo puede evolucionar mediante finalización, correcciones posteriores y resoluciones de conflicto, sin sobrescribir historia, sin convertir cada corrección en un mantenimiento distinto y sin obligar a reconstruir semánticamente una revisión a partir de una cadena de patches?

La solución debe permitir simultáneamente:

- referencias estables al mismo mantenimiento;
- historial técnico íntegro;
- correcciones no destructivas;
- conflictos sin Last Write Wins silencioso;
- interpretación histórica contra la `FormVersion` correcta;
- respuestas asociadas a la revisión que les da significado;
- separación entre revision history y sync state;
- Reporting histórico mediante snapshots independientes;
- aislamiento tenant/client;
- trazabilidad suficiente para distinguir origen de una revisión;
- compatibilidad con trabajo local-first sin convertir identidad de operación en identidad de revisión.

La solución no debe introducir como requisito:

- event sourcing global;
- un esquema físico concreto;
- almacenamiento obligatorio por deltas;
- una política física de current revision;
- una solución de continuidad de Evidence;
- una solución de selección/versionado de Reporting.

---

# 6. Decision

Para el MVP se adopta conceptualmente el siguiente modelo:

> **`MaintenanceRecord` representa la identidad estable de un mantenimiento y `MaintenanceRevision` representa un estado histórico completo, efectivo e inmutable de ese mantenimiento en un punto determinado.**

La historia de un mismo mantenimiento se expresa como una secuencia ordenable de revisiones pertenecientes al mismo `MaintenanceRecord`.

Conceptualmente:

`MaintenanceRecord`
→ revisión inicial efectiva
→ corrección
→ corrección posterior
→ resolución de conflicto cuando corresponda

Cada nueva revisión:

- pertenece al mismo `MaintenanceRecord`;
- pertenece al mismo tenant;
- representa el contenido efectivo completo del mantenimiento en ese estado histórico;
- conserva interpretación contra la `FormVersion` exacta aplicable;
- posee sus propias `Response` conceptualmente asociadas;
- no modifica destructivamente revisiones históricas previas;
- puede pasar a ser la revisión current/vigente conforme a las reglas de dominio;
- debe poder distinguir conceptualmente el contexto que la originó.

La decisión es semántica y arquitectónica. No prescribe tablas, columnas, constraints, índices, claves físicas, triggers, SQL, migrations, ORM, repositorios ni APIs.

---

# 7. `MaintenanceRecord`

`MaintenanceRecord` representa la **identidad estable del mantenimiento**.

Su responsabilidad conceptual incluye:

- continuidad de identidad a lo largo del tiempo;
- pertenencia al tenant;
- vínculo con el contexto operativo del mantenimiento;
- relación con el equipo y cliente conforme al modelo aprobado;
- conservación de la `FormVersion` exacta utilizada;
- agrupación conceptual de su historial de `MaintenanceRevision`.

`MaintenanceRecord` no representa por sí solo el contenido mutable o corregible de una revisión concreta.

Una corrección no crea un nuevo mantenimiento lógico. Una resolución de conflicto tampoco crea un mantenimiento nuevo.

Por tanto, referencias externas o internas que necesiten referirse al trabajo lógico realizado pueden conservar una identidad de mantenimiento estable aunque el contenido efectivo cambie mediante revisiones posteriores.

---

# 8. `MaintenanceRevision`

`MaintenanceRevision` representa un **estado histórico completo del mantenimiento**.

Debe permitir interpretar conceptualmente:

- el contenido efectivo de respuestas en esa revisión;
- la `FormVersion` exacta que da significado a dicho contenido;
- el contexto histórico suficiente para distinguir cómo se originó la revisión;
- su relación con el `MaintenanceRecord` estable;
- su posición dentro de una historia ordenable;
- si es la revisión efectiva vigente en el momento considerado, sin implicar un mecanismo físico concreto.

Una `MaintenanceRevision` establecida como revisión histórica efectiva es inmutable.

No se utiliza como contenedor mutable que se reescribe cada vez que el mantenimiento cambia.

---

# 9. Identidad estable vs histórico versionado

La separación responde a dos preguntas distintas:

- `MaintenanceRecord`: **¿qué mantenimiento es?**
- `MaintenanceRevision`: **¿cuál era el estado efectivo de ese mantenimiento en este momento histórico?**

Un mismo mantenimiento puede evolucionar conceptualmente:

`MaintenanceRecord`
→ `R1`
→ `R2`
→ `R3`

sin convertirse en tres mantenimientos diferentes.

Esta separación permite:

- conservar referencias estables al mantenimiento;
- reconstruir un historial completo;
- distinguir correcciones de nuevos trabajos;
- preservar estados anteriores para auditoría funcional;
- resolver conflictos creando historia en lugar de destruirla;
- mantener Reporting basado en snapshots/versiones independientes;
- preservar la intención histórica de cada estado.

Este ADR no fija numeración física, ordinales persistidos ni formato de identificación de las revisiones.

---

# 10. Revisión current / vigente

Debe existir conceptualmente **una única revisión efectiva/current por `MaintenanceRecord` en un momento dado**.

`current` significa:

> la revisión que representa el estado efectivo vigente del mantenimiento dentro del estado autoritativo correspondiente.

No significa:

- que revisiones anteriores sean inválidas;
- que deban eliminarse;
- que pierdan valor histórico;
- que puedan mutarse para “ponerse al día”.

Cuando una corrección o resolución válida produce un nuevo estado efectivo, el cambio de revisión vigente ocurre mediante la creación/aceptación de una nueva revisión conforme al dominio.

La revisión previamente vigente permanece intacta como revisión histórica.

Este ADR no decide si la vigencia se materializa mediante:

- columna `is_current`;
- pointer;
- relación directa;
- foreign key;
- trigger;
- constraint SQL;
- ordinal físico.

---

# 11. Inmutabilidad histórica

Una `MaintenanceRevision` histórica efectiva no debe modificarse destructivamente después de haber quedado establecida.

La inmutabilidad protege:

- contenido técnico histórico;
- respuestas de esa revisión;
- interpretación contra la `FormVersion` exacta;
- trazabilidad de correcciones;
- resolución de conflictos;
- consumidores históricos como Reporting.

Una corrección debe conceptualmente:

1. partir de una revisión previa;
2. producir una nueva revisión;
3. expresar el nuevo contenido efectivo completo;
4. preservar la revisión anterior.

Una resolución de conflicto debe aplicar la misma semántica de no sobrescritura.

Los mecanismos privilegiados de infraestructura no están autorizados a romper esta invariante por conveniencia técnica.

---

# 12. Contenido efectivo completo de una revisión

La semántica adoptada es **full revision / snapshot-like domain revision**.

Esto significa que cada `MaintenanceRevision` representa conceptualmente el **estado efectivo completo del mantenimiento en ese punto histórico**.

Un consumidor autorizado debe poder razonar sobre la revisión como un estado completo y no como un patch cuyo significado sólo existe después de reproducir toda la cadena previa.

## 12.1 Full revision / snapshot-like domain revision

Semánticamente:

- la revisión representa el contenido efectivo total aplicable en ese estado;
- sus `Response` constituyen el contenido de respuestas de esa revisión;
- la revisión es interpretable contra su `FormVersion` concreta;
- la historia previa explica procedencia y evolución, pero no debe ser requisito semántico obligatorio para saber qué expresa la revisión.

## 12.2 Delta/patch history

Una alternativa sería definir cada revisión únicamente como cambios respecto de su predecesora y reconstruir el estado aplicando una secuencia de patches.

Ese enfoque no se adopta como semántica base del dominio para el MVP porque:

- acopla interpretación a toda la cadena previa;
- aumenta riesgo de reconstrucción inconsistente;
- complica consumidores históricos;
- hace más frágil la inspección aislada de una revisión;
- puede introducir dependencias innecesarias entre historial técnico y estrategia física de persistencia.

Una implementación futura podría optimizar almacenamiento internamente siempre que preserve exactamente la semántica aprobada de que **cada revisión representa un estado efectivo completo**.

Este ADR no decide compresión, deduplicación, delta storage físico ni otra optimización.

---

# 13. `Response` ownership por revisión

Se mantiene la relación conceptual:

`MaintenanceRevision → Response = 1 → 0..*`

Cada `Response` pertenece conceptualmente a una revisión específica y obtiene su significado dentro de:

- esa `MaintenanceRevision`;
- la `FormVersion` exacta del mantenimiento;
- el `FormField` correspondiente de esa versión;
- el contexto estructural aplicable del formulario.

Una `Response` histórica no cambia de significado porque exista una revisión posterior.

Una corrección que modifica el estado efectivo produce el conjunto de respuestas correspondiente a la nueva revisión sin reescribir las respuestas históricas de la revisión anterior.

Este ADR no decide IDs, claves, relaciones físicas, JSON, tablas ni constraints.

---

# 14. Relación con `FormVersion`

Cada `MaintenanceRevision` debe ser interpretable contra una `FormVersion` concreta.

Se preservan las reglas aprobadas:

- una `FormVersion` publicada es inmutable;
- el mantenimiento conserva la versión exacta utilizada;
- una nueva publicación no reinterpreta respuestas antiguas;
- los fields de versiones diferentes son independientes en el MVP;
- no existe identidad lógica estable obligatoria de field entre versiones;
- una corrección utiliza la misma `FormVersion` fijada al mantenimiento;
- una corrección no migra automáticamente al formulario vigente;
- campos de una publicación posterior no se incorporan automáticamente a una corrección histórica.

Por tanto, el historial de revisiones del mantenimiento y el versionado de formularios son históricos relacionados, pero con identidades distintas.

Este ADR no resuelve `FORM-OPEN-001..008`, no resuelve `FORM-OPEN-004` y no define migración entre versiones.

---

# 15. Creación inicial y primera revisión histórica

La creación/finalización inicial de un mantenimiento debe producir su primera revisión histórica efectiva conforme a la implementación futura.

Este ADR fija únicamente la semántica una vez que existe contenido de mantenimiento representable como revisión histórica.

No decide:

- si una representación denominada revisión existe desde un draft;
- cuándo se materializa físicamente la primera revisión;
- si el draft local comparte representación física con una revisión finalizada;
- qué número u ordinal recibe la primera revisión;
- qué state machine física representa el proceso de captura.

La arquitectura posterior deberá preservar que el primer estado histórico efectivo no sea sobrescrito por correcciones futuras.

---

# 16. Finalización funcional

La finalización inicial preserva los permisos ya aprobados:

- un `TECHNICIAN` autorizado puede iniciar, ejecutar y finalizar mantenimiento dentro de sus clientes autorizados;
- `COMPANY_ADMIN` no posee permiso aprobado para iniciar, ejecutar o finalizar una ejecución inicial;
- no existe workflow de aprobación de mantenimiento en el MVP.

La finalización funcional puede ocurrir localmente mientras el dispositivo está offline.

Por tanto:

- `finalized` pertenece al estado de negocio;
- `pending sync`, `in-flight`, `conflict` o `synced` pertenecen al estado de sincronización;
- una revisión puede representar contenido funcionalmente finalizado aunque su convergencia remota continúe pendiente.

La pérdida de conectividad no convierte una revisión finalizada en draft.

---

# 17. Correcciones

Un mantenimiento finalizado puede ser corregido conforme a los permisos aprobados.

Una corrección:

- no sobrescribe la revisión vigente anterior;
- crea una nueva `MaintenanceRevision`;
- representa el nuevo estado efectivo completo;
- preserva la revisión que corrige;
- no requiere aprobación;
- puede modificar todos los campos permitidos de la `FormVersion` original del mantenimiento;
- debe ser distinguible conceptualmente de la revisión que la antecede.

Actores aprobados:

- `TECHNICIAN` dentro de su scope autorizado;
- `COMPANY_ADMIN` dentro de su scope autorizado.

La capacidad de `COMPANY_ADMIN` para corregir no concede ejecución inicial.

Una corrección deliberadamente nueva es una nueva intención de dominio y debe producir una nueva revisión si es aceptada.

Un retry técnico de la misma corrección lógica no constituye una nueva corrección y no debe producir revisiones duplicadas.

Este ADR no diseña UI de correcciones.

---

# 18. Resolución de conflictos

Se preserva íntegramente `ADR-0005 = ACCEPTED`.

Ante un conflicto de mantenimiento:

- se preservan las versiones relevantes;
- silent Last Write Wins está prohibido;
- la resolución debe ser explícita;
- debe realizarla un actor autorizado: `TECHNICIAN` dentro de sus clientes autorizados o `COMPANY_ADMIN` dentro de su scope aprobado;
- el resultado aceptado produce una nueva `MaintenanceRevision`;
- las revisiones históricas previas permanecen;
- la revisión remota histórica no se reescribe;
- la propuesta local divergente no se transforma retroactivamente en otro estado histórico mediante mutación destructiva.

La resolución representa un nuevo estado efectivo resultante, no una edición de una revisión histórica previa.

Este ADR no diseña:

- `SyncConflict`;
- UI de comparación;
- merge automático;
- algoritmo general de merge;
- payload de resolución.

---

# 19. Historial y trazabilidad conceptual

Cada revisión debe poder distinguir conceptualmente suficiente contexto histórico para comprender su lugar dentro del mantenimiento.

Como mínimo, el modelo debe poder razonar sobre:

- el `MaintenanceRecord` al que pertenece;
- su predecesora cuando corresponda;
- el contexto que originó la revisión;
- el actor cuando corresponda;
- el momento autoritativo relevante;
- la `FormVersion` que interpreta su contenido.

Puede existir metadata conceptual equivalente a:

- origin;
- predecessor;
- actor;
- created/finalized/corrected/resolved context.

Estos términos no fijan columnas, enums, schema físico ni diseño de auditoría.

La revision history es historial funcional del mantenimiento; no es un sustituto del audit log de seguridad/operación.

---

# 20. Revision chain

La historia de un `MaintenanceRecord` debe ser ordenable y no ambigua.

Conceptualmente debe poder razonarse:

`R1 → R2 → R3`

sin necesidad de adoptar branching history general ni graph database.

La arquitectura no debe permitir dos revisiones simultáneamente current dentro del estado autoritativo normal del mismo `MaintenanceRecord`.

Puede existir una divergencia offline en la que convivan:

- una revisión autoritativa actual;
- una propuesta local divergente;
- posteriormente, una revisión resultante de resolución.

La propuesta divergente no se convierte por ello en una segunda revisión current remota.

La concurrencia debe resolverse conforme a `ADR-0005`, preservando divergencias y creando una nueva revisión cuando la resolución sea aceptada.

---

# 21. Tenancy y contexto operativo

Se preserva `ADR-0002 = ACCEPTED`.

Todo `MaintenanceRecord` y todas sus `MaintenanceRevision` pertenecen al mismo tenant.

Invariantes conceptuales:

- una revisión no puede cambiar de tenant;
- una revisión no puede transferir el mantenimiento a otro tenant;
- `Response` y `Evidence` relacionadas no pueden introducir ownership cross-tenant;
- datos enviados desde frontend no redefinen tenant ni ownership;
- una corrección o resolución debe operar sobre el mantenimiento real autorizado;
- el historial completo debe permanecer dentro del mismo contexto tenant.

El mantenimiento también debe mantener coherencia con su contexto operativo aprobado:

- `Client`;
- `Location` cuando corresponda;
- `Equipment`;
- `FormVersion`;
- `Response`;
- `Evidence`.

`Equipment` pertenece a `Client` y puede poseer `Location` opcional conforme al modelo aprobado.

Este ADR no decide si datos de cliente, ubicación, equipo o formulario se duplican físicamente como snapshots dentro de la revisión.

No se diseña denormalización ni modelo físico.

---

# 22. Frontera con Evidence

Se preserva la baseline ya aprobada:

- `Response → Evidence = 1 → 0..*`;
- Evidence pertenece a una `Response` concreta;
- Evidence puede expresar semántica `BEFORE` / `AFTER` conforme a su configuración aprobada;
- Evidence finalizada no se elimina;
- una corrección puede agregar nueva Evidence;
- una nueva Evidence puede referenciar conceptualmente como máximo una Evidence anterior en una relación de replacement (`0..1`);
- la Evidence original permanece histórica.

Sin embargo, este ADR **NO decide la continuidad histórica de Evidence entre distintas `MaintenanceRevision`**.

Permanecen abiertos `EVID-OPEN-001..006` y, especialmente, este ADR no decide:

- si una Evidence originada en una revisión forma automáticamente parte del estado efectivo de una revisión posterior;
- si debe existir referencia explícita de continuidad;
- si el effective Evidence set se deriva recorriendo historial;
- cómo se representa membresía efectiva de Evidence por revisión;
- qué Evidence satisface required en una corrección;
- semántica completa de replacement lineage;
- cómo determinar la Evidence visualmente vigente en todos los casos.

La revision history de Maintenance por sí sola no resuelve esas preguntas.

La decisión corresponde principalmente a `ADR-0010` y a la resolución previa de los `EVID-OPEN-*` aplicables.

Este ADR tampoco autoriza copiar Evidence, duplicar binarios, crear una identidad nueva para la misma fotografía ni cambiar la revisión histórica de origen de una Evidence.

---

# 23. Offline y sincronización

Se preserva `ADR-0005`.

El modelo histórico de mantenimiento debe ser compatible con:

- local-first;
- persistencia local de trabajo;
- business state separado de sync state;
- idempotencia end-to-end;
- optimistic concurrency;
- conflictos explícitos;
- resolución mediante nueva revisión.

Distinciones obligatorias:

## 23.1 Revision identity vs operation identity

La identidad de una `MaintenanceRevision` y la identidad lógica de una operación sincronizable son conceptos distintos.

Una misma operación lógica puede reintentarse varias veces sin crear varias revisiones.

## 23.2 Retry vs nueva intención

- retry técnico de la misma corrección lógica: no crea otra revisión;
- replay de la misma intención idempotente: no crea otra revisión;
- respuesta perdida: no justifica una revisión nueva;
- nueva corrección deliberada: sí constituye una nueva intención y puede producir una revisión nueva;
- nueva resolución deliberada: constituye una intención distinta de una resolución anterior.

## 23.3 Conflicto

Una divergencia incompatible no se resuelve mutando una revisión histórica.

Debe preservarse el estado relevante y producirse una resolución explícita conforme a `ADR-0005`.

Este ADR no diseña outbox, Dexie, schema local, retry policy física ni `ADR-0004`.

---

# 24. Relación con Reporting

`MaintenanceRevision history` y `ReportVersion history` son históricos separados.

Se preservan las reglas aprobadas:

- cada `ReportVersion` finalizada posee su propio `ReportSnapshot` inmutable;
- una corrección posterior del mantenimiento no modifica retroactivamente un informe finalizado;
- una regeneración futura del informe crea una nueva `ReportVersion` y un nuevo snapshot conforme a la baseline de Reporting;
- un `ReportSnapshot` histórico no debe “seguir” automáticamente la revisión current futura de un mantenimiento.

Por tanto:

- la revisión current de Maintenance puede cambiar sin alterar un Report ya finalizado;
- Reporting debe seleccionar y congelar explícitamente las revisiones que utilice conforme a sus reglas aprobadas;
- una corrección de Maintenance no equivale a regenerar Report;
- una regeneración de Report no crea ni modifica `MaintenanceRevision`.

Este ADR no resuelve:

- `RPT-OPEN-*`;
- criterio temporal;
- reglas de inclusión/exclusión;
- atomicidad de finalización;
- staleness de drafts;
- selección exacta de revisiones;
- selección de Evidence;
- implementación de `ReportSnapshot`.

Estas decisiones corresponden principalmente a `ADR-0011` y a las decisiones abiertas de Reporting.

---

# 25. Deletion

La baseline exige preservar el historial requerido de mantenimientos finalizados y sus revisiones.

Este ADR no introduce eliminación física de revisiones históricas.

Tampoco decide:

- soft delete;
- hard delete;
- retención temporal;
- eliminación de `MaintenanceRecord`;
- anonimización;
- purga.

Si una política de eliminación futura fuera necesaria, deberá preservar o modificar explícitamente las invariantes históricas mediante una decisión aprobada.

---

# 26. Revision history vs Audit log

`MaintenanceRevision` y `AuditEvent` resuelven problemas distintos.

## 26.1 Revision history

Representa cambios efectivos del estado del mantenimiento.

Permite responder qué contenido técnico era efectivo en cada revisión.

## 26.2 Audit log

Registra eventos de seguridad, operación o trazabilidad requeridos por la plataforma.

Puede registrar quién hizo qué y cuándo, pero no sustituye el contenido histórico efectivo del mantenimiento.

Por tanto:

- audit log no reemplaza `MaintenanceRevision`;
- `MaintenanceRevision` no debe convertirse en un audit log genérico;
- este ADR no diseña `AuditEvent`, su schema ni su almacenamiento.

---

# 27. Revision history no implica event sourcing

La existencia de revisiones inmutables no adopta event sourcing global.

Este modelo conserva snapshots/versiones de dominio porque el mantenimiento necesita estados históricos efectivos.

No exige:

- representar toda mutación del sistema como evento;
- reconstruir el estado global mediante replay;
- event store único;
- proyecciones universales;
- semántica de eventos versionados para todos los bounded contexts.

Un futuro uso de event sourcing requeriría una decisión arquitectónica específica y una necesidad demostrada.

---

# 28. Alternatives

## 28.1 Alternativa A — Sobrescribir un Maintenance único mutable

### Descripción

Mantener un único objeto de mantenimiento y actualizar sus respuestas/contenido in place después de correcciones o resolución de conflictos.

### Ventajas

- menor cantidad aparente de versiones;
- lectura simple del “estado actual”;
- menor almacenamiento inicial.

### Desventajas

- pérdida de histórico técnico;
- correcciones destructivas;
- imposibilidad de reconstruir estados anteriores con confianza;
- conflictos más difíciles de preservar;
- Reporting histórico vulnerable a cambios posteriores;
- trazabilidad funcional insuficiente;
- contradice la baseline aprobada de revisiones inmutables.

### Evaluación

**Rechazada.**

---

## 28.2 Alternativa B — `MaintenanceRecord` estable + `MaintenanceRevision` inmutables

### Descripción

Separar la identidad lógica persistente del mantenimiento de sus estados históricos efectivos, representados mediante revisiones inmutables.

### Ventajas

- identidad estable;
- histórico íntegro;
- correcciones no destructivas;
- compatibilidad con resolución explícita de conflictos;
- referencia estable para otros módulos;
- Reporting histórico consistente mediante snapshots independientes;
- mejor auditabilidad funcional;
- compatibilidad con local-first e idempotencia;
- permite inspeccionar el estado efectivo de una revisión.

### Desventajas

- mayor cantidad de versiones históricas;
- mayor volumen de datos;
- consultas actuales e históricas deben distinguirse;
- creación de correcciones requiere nuevo contenido de revisión;
- consumidores deben seleccionar explícitamente la revisión adecuada.

### Evaluación

**Elegida.**

Es la alternativa que preserva las invariantes ya aprobadas con una semántica de dominio clara y sin introducir event sourcing global.

---

## 28.3 Alternativa C — Duplicar Maintenance completo como nuevo Maintenance por cada corrección

### Descripción

Crear un nuevo `MaintenanceRecord` para cada corrección o resolución.

### Ventajas

- cada registro podría permanecer individualmente inmutable;
- menor necesidad aparente de un concepto de revisión.

### Desventajas

- se pierde la identidad estable del mismo trabajo lógico;
- referencias externas se vuelven ambiguas;
- una corrección se confunde con un nuevo mantenimiento;
- Reporting y navegación histórica deben inferir artificialmente qué registros pertenecen a la misma historia;
- conflictos y correcciones dejan de expresar correctamente continuidad.

### Evaluación

**Rechazada.**

---

## 28.4 Alternativa D — Event sourcing completo

### Descripción

Representar el estado del mantenimiento y potencialmente otros bounded contexts mediante secuencias de eventos y reconstrucción por replay.

### Ventajas potenciales

- trazabilidad muy detallada;
- historial natural de eventos;
- posibilidad de distintas proyecciones.

### Desventajas

- complejidad significativamente mayor;
- exige semántica de eventos, evolución y replay;
- aumenta superficie de testing y operación;
- no existe requisito del MVP que justifique event sourcing global;
- puede convertir una necesidad acotada de revisiones en una arquitectura innecesariamente sofisticada.

### Evaluación

**No seleccionada.**

Las revisiones inmutables no implican event sourcing global.

---

## 28.5 Alternativa E — Guardar obligatoriamente sólo patches/deltas

### Descripción

Cada revisión almacena únicamente diferencias respecto de una revisión previa y el estado se reconstruye aplicando la cadena.

### Ventajas potenciales

- menor almacenamiento en ciertos casos;
- cambios explícitos por revisión.

### Desventajas

- interpretación acoplada a toda la cadena;
- mayor complejidad de reconstrucción;
- riesgo de inconsistencia acumulada;
- dificultad para consumidores históricos y Reporting;
- mayor dependencia de detalles físicos para comprender el dominio.

### Evaluación

**No seleccionada como semántica base.**

Una optimización física futura puede utilizar técnicas de delta si preserva externamente la semántica de que cada `MaintenanceRevision` representa un estado efectivo completo.

---

# 29. Consequences

## 29.1 Consecuencias positivas

- `MaintenanceRecord` conserva identidad estable.
- El histórico técnico permanece íntegro.
- Las correcciones son no destructivas.
- La resolución de conflictos es compatible con `ADR-0005`.
- Silent Last Write Wins no es necesario para converger Maintenance.
- Cada revisión puede inspeccionarse como estado efectivo completo.
- La `FormVersion` histórica continúa dando significado a las respuestas.
- Los Reports finalizados quedan protegidos frente a correcciones posteriores.
- La trazabilidad funcional mejora.
- El modelo es compatible con local-first e idempotencia.
- Revision history y audit log mantienen responsabilidades separadas.

## 29.2 Consecuencias negativas

- Se acumulan más revisiones históricas.
- El almacenamiento puede ser mayor que un registro mutable único.
- Las consultas deben distinguir estado current de historial.
- Las correcciones deben producir contenido nuevo en lugar de modificar in place.
- Consumers deben seleccionar explícitamente la revisión correcta.
- Evidence entre revisiones requiere una decisión separada.
- Reporting debe seleccionar y snapshotear explícitamente su fuente histórica.
- Las pruebas deben cubrir evolución completa, no sólo CRUD del estado actual.
- Debugging puede requerir considerar a la vez revision history y sync state.

---

# 30. Security implications

La implementación futura deberá preservar, como mínimo, las siguientes invariantes de seguridad:

- una revisión no puede cambiar de tenant;
- un actor no puede crear una revisión sobre un `MaintenanceRecord` ajeno;
- revision history no puede utilizarse para bypassar client scope;
- una revisión histórica no debe hacerse mutable por una superficie privilegiada;
- `service-role` no autoriza romper ownership, scope ni invariantes de inmutabilidad;
- frontend/PWA no decide unilateralmente qué revisión es autoritativa;
- un identificador de revisión conocido no constituye autorización;
- corrección y resolución requieren autorización vigente para la operación concreta;
- una relación manipulada con `Response`, `Equipment`, `Client`, `FormVersion` o Evidence de otro tenant debe rechazarse;
- `COMPANY_ADMIN` sólo puede escribir revisiones en el contexto de corrección o resolución aprobada, no como ejecución inicial inferida.

Este ADR no diseña RLS, policies, claims, helpers, funciones SQL ni mecanismos concretos de autorización.

---

# 31. Data implications

La futura representación de datos debe preservar conceptualmente:

- identidad estable de `MaintenanceRecord`;
- pertenencia de cada `MaintenanceRevision` al mismo `MaintenanceRecord`;
- tenant constante a lo largo del historial;
- historia ordenable y no ambigua;
- una sola revisión efectiva/current a la vez en el estado autoritativo normal;
- revisiones históricas inmutables;
- `Response` perteneciente a una revisión específica;
- `FormVersion` exacta utilizada;
- corrección produciendo revisión nueva;
- resolución de conflicto produciendo revisión nueva;
- retry de una misma intención sin duplicar revisión;
- preservación de estados previos para consumidores históricos.

Este ADR no decide:

- tablas;
- columnas;
- primary keys;
- foreign keys;
- unique constraints;
- revision number físico;
- `is_current`;
- índices;
- triggers;
- schemas;
- JSON físico;
- SQL;
- migrations;
- ORM;
- repositorios.

---

# 32. Offline implications

La decisión requiere que la implementación offline/sync posterior conserve la distinción entre:

- identidad del mantenimiento;
- identidad de la revisión;
- identidad de la operación sincronizable;
- estado de negocio;
- estado de sincronización.

Debe ser posible representar conceptualmente situaciones como:

- mantenimiento finalizado localmente con revisión pendiente de sync;
- retry de la misma corrección sin revisión duplicada;
- conflicto entre base remota y propuesta local;
- resolución posterior que produce una nueva revisión.

`ADR-0004` continúa sin resolverse y este ADR no decide aislamiento de réplica, logout, protección local ni schema Dexie.

---

# 33. Testing implications

La implementación futura deberá cubrir, como mínimo, categorías conceptuales de prueba equivalentes a:

1. crear/finalizar un mantenimiento produce una historia válida;
2. una corrección crea una nueva revisión;
3. la corrección no modifica la revisión anterior;
4. una segunda corrección conserva las revisiones precedentes;
5. una resolución de conflicto produce una nueva revisión;
6. el resultado de conflicto no reescribe revisiones históricas;
7. retry idempotente de la misma corrección no crea una revisión duplicada;
8. una nueva corrección deliberada sí puede crear una revisión nueva;
9. existe una sola revisión efectiva/current en estado autoritativo normal;
10. una propuesta local divergente no se convierte por sí sola en segunda current remota;
11. una revisión histórica conserva su `FormVersion` exacta;
12. publicar una nueva `FormVersion` no altera revisiones existentes;
13. una corrección utiliza la semántica de la `FormVersion` original;
14. `Response` histórica permanece asociada a su revisión;
15. tenant no cambia entre revisiones;
16. intento de revisión cross-tenant es rechazado;
17. intento de relacionar Response/revisión con recursos cross-tenant es rechazado;
18. `COMPANY_ADMIN` puede corregir dentro del scope aprobado sin adquirir ejecución inicial;
19. `TECHNICIAN` puede corregir dentro de su scope aprobado;
20. business state y sync state permanecen independientes;
21. un `ReportSnapshot` finalizado previo no cambia después de una corrección de Maintenance;
22. revision history no depende de mutar un audit log para expresar estado efectivo.

No se definen tests ejecutables, framework de testing ni fixtures físicos.

---

# 34. Observability / audit

La implementación futura debería poder distinguir conceptualmente en trazas apropiadas:

- creación/finalización inicial;
- correction;
- conflict resolution;
- revisión vigente;
- revisión histórica.

Esta capacidad no transforma revision history en una solución completa de observabilidad.

No se diseñan:

- logs;
- métricas;
- dashboards técnicos;
- tracing vendor;
- `AuditEvent`;
- schema de auditoría.

`DO-T05` y `ADR-0016` permanecen diferidos conforme al registro maestro.

---

# 35. Dependencies

## 35.1 Depende de

- `ADR-0001 = ACCEPTED`;
- `ADR-0002 = ACCEPTED`;
- `ADR-0005 = ACCEPTED`;
- baseline documental aprobada `00..10`.

## 35.2 No depende para su decisión base de resolver

- `DM-OPEN-*`;
- `FORM-OPEN-*`;
- `EVID-OPEN-*`;
- `RPT-OPEN-*`;
- `OFF-OPEN-*`;
- `DO-T03`;
- `DO-T04`.

Estas decisiones pueden condicionar implementaciones o bounded contexts relacionados, pero no modifican la decisión base de separar identidad estable de revisiones históricas inmutables.

## 35.3 Fronteras deliberadamente diferidas

- continuidad histórica/effective set de Evidence → `ADR-0010`;
- Reporting snapshots/versionado y selección de revisiones → `ADR-0011`;
- decisiones estructurales pendientes del Form Engine → `ADR-0008`;
- réplica offline, aislamiento local y lifecycle local → `ADR-0004`.

## 35.4 Condiciona

Este ADR condiciona conceptualmente:

- `ADR-0010`;
- `ADR-0011`;
- implementación posterior del bounded context Maintenance;
- implementación posterior de sync aplicada a Maintenance;
- pruebas de históricos, correcciones y conflictos.

No resuelve ninguno de esos ADR ni autoriza su implementación.

---

# 36. Open decisions preservadas

Este ADR no resuelve ningún `DO-*` ni `*-OPEN-*`.

Permanecen fuera de su decisión, entre otros:

- `DM-OPEN-*`;
- `FORM-OPEN-001..008`;
- `EVID-OPEN-001..006`;
- `RPT-OPEN-*`;
- `OFF-OPEN-*`;
- `DO-T03`;
- `DO-T04`;
- decisiones diferidas de observabilidad/performance.

La existencia de metadata conceptual, una cadena de revisiones o una revisión current no debe utilizarse para cerrar implícitamente ninguna decisión abierta.

---

# 37. Explicit non-decisions

Este ADR no decide ni autoriza:

- tablas;
- columnas;
- PK/FK;
- constraints;
- índices;
- revision number físico;
- `is_current`;
- pointers físicos;
- triggers;
- SQL;
- migrations;
- RLS;
- ORM;
- repositories;
- API;
- Server Actions;
- Route Handlers;
- Edge Functions;
- state machine física;
- delta storage físico;
- compresión;
- deduplicación;
- event sourcing;
- audit schema;
- deletion policy;
- Evidence continuity;
- effective Evidence derivation;
- replacement semantics completas;
- Reporting inclusion;
- Report snapshot implementation;
- Form migration;
- sync schema;
- Dexie schema;
- outbox física;
- SupportAccessGrant;
- autorización nueva;
- UI de corrección;
- UI de conflictos;
- merge automático.

---

# 38. References

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/04-offline-sync-strategy.md`
- `docs/product/05-form-engine-spec.md`
- `docs/product/06-maintenance-evidence-spec.md`
- `docs/product/07-reporting-engine-spec.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`

---

# 39. Supersession

`Supersedes: None`

`Superseded by: None`

---

# 40. Gate del ADR

- ADR generado: `ADR-0009`;
- Status: `ACCEPTED`;
- decisión: `MaintenanceRecord` estable + `MaintenanceRevision` históricas inmutables;
- `MaintenanceRecord`: identidad estable;
- `MaintenanceRevision`: estado efectivo completo de una revisión;
- revisiones históricas: inmutables;
- current revision: una a la vez;
- correction: nueva revision;
- conflict resolution: nueva revision;
- retry misma operación: no duplica revision;
- `FormVersion` exacta preservada;
- `Response` pertenecen a revision;
- tenant permanece constante;
- Evidence continuity resuelta: no;
- Reporting selection/versioning resuelto: no;
- OPEN resueltos: ninguno;
- código: no;
- SQL: no;
- migrations: no;
- tablas: no;
- implementación autorizada: no;
- otro ADR generado: no;
- aprobación: completada;
- Fase 0: **EN CURSO**.
