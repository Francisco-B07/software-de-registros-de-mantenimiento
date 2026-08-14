# 07 — Especificación conceptual y funcional del Reporting Engine

> **Ruta normativa/objetivo:** `docs/product/07-reporting-engine-spec.md`  
> **Estado:** **APROBADO — especificación conceptual y funcional del Reporting Engine del MVP**  
> **Fase:** Fase 0 — documento derivado  
> **Estado de Fase 0:** **EN CURSO**  
> **Baseline normativa:** `docs/product/01-product-definition.md`  
> **Modelo de dominio aprobado:** `docs/product/02-domain-model.md`  
> **Estrategia de permisos/RLS aprobada:** `docs/product/03-permissions-rls-strategy.md`  
> **Estrategia offline/sync aprobada:** `docs/product/04-offline-sync-strategy.md`  
> **Form Engine aprobado:** `docs/product/05-form-engine-spec.md`  
> **Maintenance Evidence aprobado:** `docs/product/06-maintenance-evidence-spec.md`  
> **Naturaleza:** contrato conceptual y funcional del Reporting Engine; **NO constituye implementación, modelo físico, SQL, RLS ejecutable, pipeline documental concreto, integración OpenAI, Storage, APIs ni UI React**

---

# 1. Propósito y alcance

Este documento define la especificación conceptual y funcional del Reporting Engine del MVP.

Su propósito es fijar, antes de diseñar o implementar infraestructura física, las reglas que determinan:

- qué representa un `Report` lógico;
- cómo se identifica y comprende su período mensual;
- cómo se obtienen y revisan mantenimientos candidatos;
- cómo funciona un report draft;
- cómo se finaliza un informe;
- cómo se asigna y conserva el número oficial;
- cómo nacen y se preservan `ReportVersion` sucesivas;
- qué debe congelar un `ReportSnapshot`;
- cómo interviene un `ReportTemplate`;
- cómo se construye conceptualmente un único `ReportDocumentModel` común;
- cómo deben mantenerse consistentes PDF y DOCX;
- cómo se incorpora Evidence sin reinterpretar su histórico;
- cómo se utiliza IA exclusivamente como asistencia editorial;
- qué permisos aplican;
- cómo se preservan históricos;
- qué acciones deben ser trazables;
- qué decisiones continúan abiertas antes de Fase 6.

El Reporting Engine consume datos de otros bounded contexts, pero no modifica los hechos técnicos que consume. En particular, no altera mantenimientos, revisiones, respuestas, Evidence, equipos, clientes ni definiciones históricas de formularios.

## 1.1 Autoridad

Se aplica el siguiente orden de autoridad:

1. `docs/product/01-product-definition.md`;
2. `docs/product/02-domain-model.md`;
3. `docs/product/03-permissions-rls-strategy.md`;
4. `docs/product/04-offline-sync-strategy.md`;
5. `docs/product/05-form-engine-spec.md`;
6. `docs/product/06-maintenance-evidence-spec.md`;
7. `docs/product/00-master-product-brief.md`;
8. decisiones explícitamente aprobadas posteriormente dentro del Project que no hayan sido sustituidas.

Este documento profundiza Reporting sin modificar las reglas superiores.

## 1.2 Revisión previa de coherencia

No se detectan contradicciones bloqueantes conocidas entre `01..06` que impidan definir conceptualmente el Reporting Engine.

Se preservan como reglas cerradas:

- `Report` es el informe lógico;
- `ReportVersion` es una generación finalizada concreta;
- `ReportSnapshot` pertenece a una versión y es inmutable;
- el informe principal del MVP es mensual por cliente;
- el número oficial se asigna al finalizar por primera vez;
- el número pertenece al `Report` y no cambia al regenerar;
- regenerar crea una nueva versión y un nuevo snapshot;
- una versión anterior nunca se sobrescribe;
- las correcciones posteriores de mantenimiento no cambian versiones de informe ya finalizadas;
- al regenerar se deben utilizar las revisiones vigentes conforme a la regla temporal y de selección que se apruebe;
- PDF es el documento canónico/oficial generado por la plataforma;
- DOCX es editable y deriva del mismo `ReportDocumentModel`;
- sólo `COMPANY_ADMIN` utiliza IA;
- IA no modifica hechos técnicos ni Evidence;
- `TECHNICIAN` no administra, genera ni finaliza informes;
- `SUPER_ADMIN` no posee acceso tenant operativo por defecto;
- un `SupportAccessGrant` no genera capacidades nuevas por inferencia;
- no existe Last Write Wins silencioso para mantenimiento crítico;
- Reporting debe interpretar cada mantenimiento utilizando su `FormVersion` histórica fijada;
- Reporting no puede resolver la semántica pendiente de continuidad/replacement de Evidence.

## 1.3 Fuera del alcance

Este documento **NO define ni autoriza**:

- SQL;
- tablas PostgreSQL;
- columnas;
- claves físicas;
- índices;
- migrations;
- queries físicas;
- sequences;
- schemas físicos;
- JSON físico definitivo;
- políticas RLS ejecutables;
- políticas de Storage ejecutables;
- librerías concretas de PDF;
- librerías concretas de DOCX;
- templates físicos;
- WYSIWYG concreto;
- buckets;
- paths de Storage;
- almacenamiento físico de documentos;
- APIs;
- endpoints;
- Server Actions;
- workers;
- jobs;
- queues;
- componentes React;
- implementación de OpenAI;
- prompts productivos;
- selección de modelo OpenAI;
- protocolo físico del ledger de créditos IA;
- Mercado Pago;
- inicialización de Next.js;
- implementación mediante Codex;
- generación de ADRs.

---

# 2. Terminología

## 2.1 `Report`

Informe lógico mensual perteneciente a un tenant y referido a un cliente y período lógico concretos. Conserva su identidad a través de `v1`, `v2`, etc. Su número oficial, una vez asignado, permanece estable.

## 2.2 `ReportVersion`

Generación finalizada concreta de un `Report`, identificada conceptualmente por un ordinal `vN`. Cada versión posee su propio snapshot y sus propios documentos asociados. Una versión finalizada es histórica e inmutable.

## 2.3 `ReportSnapshot`

Representación inmutable de los datos e insumos semánticos utilizados para una `ReportVersion` concreta. Es la fuente histórica de interpretación de esa versión y no debe depender de datos actuales mutables para reconstruir su significado.

## 2.4 `ReportTemplate`

Configuración tenant-owned que define estructura, branding y presentación de informes: portada, encabezados, pie, secciones, orden, campos visibles, fotografías, tablas, textos estáticos y demás reglas de presentación aprobadas.

No es un `FormTemplate` y no define cómo se capturan mantenimientos.

## 2.5 `ReportDocumentModel`

Modelo intermedio conceptual, neutral respecto del formato de salida, que representa el contenido y la estructura semántica final de una versión antes de renderizar PDF y DOCX.

## 2.6 Reporting period

Mes lógico al que corresponde el informe. Su interpretación exacta requiere una zona temporal aprobada y un criterio temporal aprobado para determinar qué mantenimientos pertenecen al período.

## 2.7 Reporting candidate maintenance

Mantenimiento que satisface los criterios de elegibilidad necesarios para poder ser considerado en el informe: ownership correcto, cliente correcto, período correcto conforme a `DM-OPEN-008`, estado funcional adecuado y una `MaintenanceRevision` utilizable conforme a la política aprobada.

Ser candidato no equivale necesariamente a quedar incluido mientras `RPT-OPEN-004` permanezca abierta.

## 2.8 Included maintenance

Mantenimiento candidato que, conforme a la política de selección aprobada, forma parte de la versión que se finaliza. El snapshot debe congelar exactamente qué mantenimiento y qué revisión se utilizaron.

## 2.9 Excluded maintenance

Mantenimiento candidato que no forma parte de la versión finalizada conforme a la política de selección aprobada. Este término no presupone todavía si la exclusión manual está permitida ni si necesita justificación; esa decisión permanece en `RPT-OPEN-004`.

## 2.10 Report draft

Estado mutable de preparación de un `Report` antes de la primera finalización o de preparación de una posible nueva versión después de existir una versión finalizada.

El draft puede cambiar y no constituye por sí mismo una `ReportVersion` histórica finalizada.

## 2.11 Report finalization

Acción explícita de `COMPANY_ADMIN` que convierte la preparación revisada en una versión histórica, asignando el número oficial cuando corresponde a `v1`, fijando el snapshot y produciendo los documentos requeridos conforme a la política de finalización que se apruebe.

## 2.12 Official report number

Número oficial correlativo por empresa de mantenimiento, perteneciente al `Report`. Se asigna en la primera finalización, no en preview ni al crear un draft, y permanece igual en regeneraciones.

## 2.13 Regeneration

Creación de una nueva `ReportVersion` de un `Report` ya finalizado. Conserva el número oficial, incrementa la versión, crea un nuevo snapshot y utiliza las revisiones vigentes según las reglas aprobadas para la nueva generación.

## 2.14 Current report version

Versión finalizada con ordinal más alto de un `Report` en un momento determinado. “Current” no autoriza modificarla; sigue siendo inmutable.

## 2.15 Historical report version

Cualquier `ReportVersion` finalizada conservada en el histórico, incluida una versión que ya no sea la de mayor ordinal.

## 2.16 Snapshot source data

Conjunto de datos e insumos seleccionados que deben congelarse o quedar históricamente fijados para interpretar una versión: mantenimientos/revisiones, cliente, equipos, ubicaciones, formularios, respuestas, Evidence, contenido editorial y configuración de presentación aplicable, entre otros.

## 2.17 Generated document

Artefacto documental producido para una `ReportVersion` a partir de su `ReportDocumentModel`. El archivo no reemplaza al snapshot ni constituye por sí mismo la fuente de verdad histórica.

## 2.18 Canonical PDF

PDF oficial de la plataforma correspondiente a una `ReportVersion`. Representa la salida canónica del informe dentro del SaaS.

## 2.19 Editable DOCX

Documento DOCX derivado del mismo `ReportDocumentModel`, destinado a edición externa y compatibilidad práctica dentro del subconjunto portable que finalmente se apruebe.

## 2.20 AI-assisted text

Texto sugerido por una operación IA autorizada, todavía sujeto a revisión humana. No es fuente de verdad técnica ni puede convertirse automáticamente en contenido oficial.

## 2.21 Human-authored text

Contenido editorial escrito directamente por `COMPANY_ADMIN` o contenido inicialmente sugerido por IA que ha sido revisado y queda bajo control humano antes de la finalización.

## 2.22 Distinciones obligatorias

### `Report` vs `ReportVersion`

`Report` conserva identidad, cliente, período y número oficial. `ReportVersion` representa una generación histórica concreta.

### `ReportVersion` vs `ReportSnapshot`

La versión es el estado histórico del informe; el snapshot es la representación inmutable de los datos e insumos utilizados por esa versión.

### Snapshot vs PDF/DOCX

El snapshot es fuente histórica semántica. PDF/DOCX son artefactos renderizados a partir del modelo documental derivado de esa fuente.

### Draft vs finalized version

El draft es mutable y no oficial. Una versión finalizada es inmutable e histórica.

### Regeneration vs maintenance correction

Regeneration crea una nueva versión del informe. Una corrección de mantenimiento crea una nueva `MaintenanceRevision`. Ninguna de las dos acciones sobrescribe su histórico previo y una corrección de mantenimiento no modifica retrospectivamente un informe ya finalizado.

---

# 3. Ownership y tenant isolation

Todo recurso de Reporting debe poseer un tenant inequívocamente derivable.

Conceptualmente deben mantener ownership coherente:

- `Report`;
- `ReportVersion`;
- `ReportSnapshot`;
- `ReportTemplate`;
- `ReportDocumentModel` cuando se materialice temporalmente o se procese;
- documentos generados;
- operaciones IA relacionadas con informes;
- cualquier evento de auditoría relacionado.

`Report` es además client-scoped: pertenece a un cliente del mismo tenant.

Una `ReportVersion`, su snapshot y sus documentos no pueden pertenecer a un tenant o cliente distinto del `Report` padre.

Las fuentes incluidas deben satisfacer la misma cadena de ownership. No es válido construir un informe de Tenant A a partir de:

- un mantenimiento de Tenant B;
- un equipo de otro cliente;
- una `MaintenanceRevision` no perteneciente al mantenimiento seleccionado;
- una `FormVersion` no utilizada por ese mantenimiento;
- Evidence ajena al contexto permitido;
- un `ReportTemplate` de otro tenant.

La futura representación física podrá elegir distintos mecanismos, pero no podrá aceptar el tenant declarado por el navegador como autoridad.

---

# 4. Actores y permisos

## 4.1 `COMPANY_ADMIN`

Dentro de su tenant, `COMPANY_ADMIN` puede:

- crear/preparar report drafts;
- elegir cliente y período;
- revisar candidatos;
- seleccionar contenido conforme a la política aprobada;
- utilizar `ReportTemplate` de su tenant;
- editar contenido editorial permitido;
- solicitar asistencia IA;
- revisar, aceptar, rechazar o editar sugerencias IA;
- generar previews conceptuales;
- finalizar informes;
- regenerar informes ya finalizados;
- descargar PDF/DOCX;
- consultar versiones históricas;
- administrar plantillas de informe conforme a la baseline.

Estas capacidades no amplían sus permisos sobre ejecución inicial de mantenimiento.

## 4.2 `TECHNICIAN`

`TECHNICIAN` utiliza mantenimientos, revisiones, respuestas y Evidence en su trabajo operativo dentro de clientes autorizados, pero no administra Reporting.

La estrategia aprobada de permisos establece que `TECHNICIAN` no tiene acceso a `Report` como recurso de Reporting. Por tanto, este documento **NO** introduce lectura, descarga, generación, preview, finalización ni regeneración para `TECHNICIAN`.

No se crea una nueva `RPT-OPEN` sobre este punto porque la ausencia de acceso ya está determinada por la baseline de autorización y por la regla “ausencia de permiso aprobado = no se infiere permiso”.

## 4.3 `SUPER_ADMIN`

`SUPER_ADMIN` no posee acceso operativo normal a informes tenant.

Un `SupportAccessGrant` puede conceder acceso excepcional a la sección `informes` de clientes explícitamente autorizados, pero:

- no convierte a `SUPER_ADMIN` en `COMPANY_ADMIN`;
- no concede acceso a otros clientes;
- no concede administración de `ReportTemplate` tenant-wide por inferencia;
- no concede uso de IA, porque IA está reservada a `COMPANY_ADMIN`;
- no crea nuevas capacidades de escritura fuera de las ya aprobadas para soporte;
- todo acceso efectivo de soporte debe ser auditable conforme a `03`.

## 4.4 Principio de mínimo privilegio

El conocimiento de:

- un ID de Report;
- un número oficial;
- una URL de archivo;
- un nombre de archivo;
- un path;
- un identificador de snapshot

no constituye autorización.

---

# 5. `Report`

`Report` representa la identidad lógica de un informe mensual de un cliente.

Debe conservar conceptualmente:

- tenant propietario;
- cliente;
- reporting period;
- número oficial una vez asignado;
- historial ordenado de `ReportVersion`.

Antes de la primera finalización puede existir como preparación/draft sin número oficial.

Después de la primera finalización:

- conserva el mismo cliente y período lógico;
- conserva el número oficial;
- puede recibir nuevas versiones mediante regeneración;
- no se convierte en un nuevo `Report` por cada corrección posterior.

La unicidad exacta por `tenant + client + period` permanece en `DM-OPEN-005`.

---

# 6. `ReportVersion`

Cada generación finalizada:

- pertenece exactamente a un `Report`;
- posee un ordinal de versión;
- posee exactamente un snapshot histórico propio;
- produce o debe producir los documentos requeridos conforme a la política de finalización aprobada;
- permanece histórica;
- no se sobrescribe;
- comparte el número oficial del `Report`.

## 6.1 Draft previo a `v1`

La baseline ya distingue el borrador del primer acto de finalización. Por ello puede existir un report draft antes de `v1` sin constituir una `ReportVersion` finalizada.

Conceptualmente:

**preparación mutable → revisión → finalización → `v1` histórica**.

Esto evita asignar semántica de versión histórica a cada guardado de draft.

## 6.2 Draft previo a una regeneración

De forma análoga, la preparación de una posible `vN+1` puede mantenerse como draft mutable del `Report` hasta que exista una nueva finalización/regeneración válida.

No se debe etiquetar como una versión histórica finalizada algo que todavía puede cambiar.

---

# 7. `ReportSnapshot`

El snapshot es la fuente histórica de una versión.

Debe satisfacer las siguientes invariantes:

- es inmutable una vez finalizada la `ReportVersion`;
- pertenece exactamente a esa versión;
- contiene o fija históricamente la información necesaria para interpretar lo que mostró la versión;
- no consulta datos actuales para reinterpretar hechos antiguos;
- no cambia tras correcciones futuras;
- no cambia si el cliente, equipo, ubicación, formulario, Evidence o template se modifica posteriormente;
- conserva la revisión de mantenimiento utilizada;
- conserva el contexto histórico de la `FormVersion` utilizada;
- conserva la selección e interpretación de Evidence conforme a las reglas aprobadas;
- conserva el contenido editorial final;
- conserva la configuración efectiva de presentación necesaria para reproducir el significado del documento.

“Autosuficiente para interpretación” no obliga a una representación física monolítica. La implementación podrá utilizar referencias históricamente inmutables, copias congeladas u otra estrategia aprobada, siempre que una versión no dependa de datos mutables posteriores.

---

# 8. `ReportTemplate`

`ReportTemplate` es tenant-owned y configura presentación, no captura técnica.

Puede definir conceptualmente:

- branding;
- portada;
- encabezados;
- pie;
- secciones;
- orden general;
- campos o bloques visibles;
- tratamiento de valores vacíos;
- presentación de fotografías;
- tablas;
- textos estáticos;
- configuración documental compatible con el subconjunto aprobado.

No debe convertirse en:

- un `FormTemplate`;
- una fuente de verdad de respuestas;
- un workflow engine;
- un editor WYSIWYG obligatorio;
- una vía para cambiar hechos técnicos.

La identidad del `ReportTemplate` y la configuración efectiva utilizada por una versión son conceptos diferentes. El segundo debe quedar históricamente preservado para evitar que cambios posteriores de template alteren una versión finalizada.

La regla de qué template/configuración usar al regenerar permanece en `DM-OPEN-006`.

---

# 9. Ciclo de vida del `Report`

El ciclo conceptual es:

**preparación → draft → revisión → primera finalización → versiones posteriores mediante regeneración**.

## 9.1 Preparación

Se determina el cliente, período, template candidato y conjunto inicial de fuentes.

## 9.2 Draft

El contenido puede cambiar. No existe número oficial si aún no hubo primera finalización.

## 9.3 Revisión

`COMPANY_ADMIN` verifica candidatos, revisiones, datos técnicos, contenido editorial, Evidence y presentación.

## 9.4 Primera finalización

Se produce `v1`, se asigna el número oficial y se fija el snapshot conforme a la política de finalización.

## 9.5 Regeneraciones

Cada regeneración produce una nueva `ReportVersion`, conserva el número oficial y deja intactas todas las anteriores.

No se define aquí una máquina de estados física ni nombres de columnas.

---

# 10. Ciclo de vida de `ReportVersion`

Una `ReportVersion` histórica nace conceptualmente como resultado de una finalización o regeneración exitosa.

Debe distinguirse entre:

- preparación mutable para una versión futura;
- intento técnico de generar documentos;
- versión finalizada e histórica.

La versión adquiere su snapshot inmutable como parte del acto de finalización.

La baseline fija la secuencia conceptual general de primera finalización: número oficial, `v1`, snapshot, modelo documental y documentos. Sin embargo, no define completamente qué estado observable queda cuando una parte del proceso falla después de iniciarse.

Por ello, la política exacta de atomicidad funcional entre:

- asignación del número;
- fijación del snapshot;
- existencia de PDF;
- existencia de DOCX;
- declaración de la versión como finalizada

permanece en `RPT-OPEN-006`.

Un fallo técnico no debe convertir automáticamente un retry en una versión nueva.

---

# 11. Período mensual

El informe principal del MVP corresponde a un mes lógico de un cliente.

Un reporting period debe identificar de forma inequívoca:

- el mes de negocio;
- la zona temporal con la que se interpretan sus límites, una vez aprobada;
- el criterio temporal de mantenimiento que decide pertenencia, una vez aprobado.

No debe identificarse el período utilizando accidentalmente:

- fecha de generación del informe;
- fecha de upload de archivos;
- fecha de sincronización;
- `created_at` o `updated_at` técnicos.

La definición precisa depende de `DM-OPEN-008` y `RPT-OPEN-001`.

---

# 12. `DM-OPEN-008` — criterio temporal de inclusión

La baseline exige consolidar mantenimientos “del período”, pero no define todavía qué hecho temporal de negocio determina esa pertenencia.

## 12.1 Alternativa A — fecha/hora efectiva de ejecución o finalización técnica

Usar el momento de negocio que representa cuándo el trabajo fue realmente ejecutado o técnicamente completado.

**Ventajas:**

- se aproxima al significado natural de “mantenimiento realizado durante el mes”;
- puede mantenerse independiente de conectividad;
- una sincronización tardía no mueve artificialmente el trabajo a otro período.

**Riesgos:**

- debe existir una semántica inequívoca del momento efectivo;
- debe definirse qué ocurre si el trabajo cruza el límite mensual;
- no debe confundirse con un timestamp de persistencia local o remota.

## 12.2 Alternativa B — fecha de inicio

Asignar el mantenimiento al mes en que comenzó.

**Ventaja:** regla simple para trabajos iniciados en un período.

**Riesgo:** un trabajo iniciado al final de un mes y completado en el siguiente se atribuiría al mes de inicio aunque el resultado técnico se concrete después.

## 12.3 Alternativa C — fecha de primera finalización

Usar el momento en que el mantenimiento queda finalizado funcionalmente por primera vez.

**Ventajas:**

- existe un evento funcional significativo;
- es coherente con la separación entre finalización y sync;
- una corrección posterior no tendría por qué mover el trabajo de mes.

**Riesgos:**

- debe diferenciarse “fecha efectiva del trabajo” de “momento en que el usuario presionó Guardar” si no coinciden;
- el reloj/dispositivo y la semántica temporal necesitan una regla aprobada.

## 12.4 Alternativa D — fecha de la revisión vigente

Usar la fecha de la `MaintenanceRevision` que se incluye.

**Problema principal:** una corrección de marzo a un mantenimiento de enero podría mover artificialmente el mantenimiento a marzo. Contradice la expectativa de que una corrección no cambie retroactivamente el mes del trabajo por el mero hecho de corregirse.

No se recomienda.

## 12.5 Alternativa E — fecha de mantenimiento configurable

Mantener una fecha/hora de negocio explícita editable según reglas de mantenimiento.

**Ventaja:** puede representar con precisión el momento real cuando captura y registro ocurren en momentos distintos.

**Riesgos:**

- introduce una decisión funcional adicional sobre quién puede modificarla y cómo se audita;
- una corrección podría reubicar el trabajo entre períodos si no se define expresamente su semántica.

## 12.6 Alternativa F — fecha de sincronización

No es adecuada como criterio de negocio.

Un técnico puede trabajar varios días offline. La conectividad no debe decidir a qué mes pertenece el mantenimiento.

## 12.7 Criterios explícitamente rechazados como inferencia

Mientras la decisión permanezca abierta, no deben utilizarse por comodidad:

- `created_at`;
- `updated_at`;
- sync time;
- upload time de Evidence;
- fecha de generación del informe;
- fecha de una corrección como sustituto automático del momento del trabajo.

## 12.8 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** utilizar una **fecha/hora efectiva de finalización técnica del trabajo**, de naturaleza funcional y separada de sincronización, como criterio de pertenencia mensual. Para trabajo offline, el hecho de negocio debe representar cuándo se completó técnicamente el mantenimiento, no cuándo llegó al servidor. Una corrección posterior no debería mover el mantenimiento de período por el solo hecho de generar una nueva revisión; cualquier corrección del propio momento efectivo necesitaría una regla explícita y trazable.

Esta propuesta prioriza la semántica de “trabajo realizado/completado en el período” y evita que conectividad o retries alteren el mes.

**Estado de `DM-OPEN-008`: `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.**

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

---

# 13. Timezone del período

Un mes calendario depende de una zona temporal. Sin ella, un evento cercano a medianoche puede pertenecer a meses distintos según quién lo interprete.

## 13.1 Alternativas

### Zona temporal del dispositivo/usuario

No es adecuada como frontera estable: dos administradores en zonas diferentes podrían obtener conjuntos distintos para el mismo informe.

### UTC puro

Es técnicamente estable, pero puede no corresponder al mes civil en el que la empresa entiende que se realizó el trabajo.

### Zona temporal del tenant

Ofrece una regla única por empresa y una experiencia consistente para el MVP.

### Zona temporal del cliente

Puede ser semánticamente adecuada si un tenant opera clientes en zonas distintas, pero introduce configuración adicional por cliente que la baseline no define.

## 13.2 Trabajo offline

La hora de sync no debe reemplazar el momento de negocio. Una operación realizada offline debe conservar el contexto temporal necesario para interpretarse posteriormente bajo la zona de reporting aprobada.

## 13.3 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** utilizar una **zona temporal de reporting explícita y estable del tenant para el MVP**, no la zona del dispositivo ni la hora de sincronización, y congelar la zona efectiva utilizada en cada versión. Si el producto necesitara clientes en zonas distintas con semántica local propia, esa ampliación deberá aprobarse expresamente.

Esto no fija una representación técnica ni un identificador concreto de timezone.

La decisión se registra como `RPT-OPEN-001`.

---

# 14. Selección de mantenimientos candidatos

Para ser candidato, un mantenimiento debe cumplir conceptualmente:

1. pertenecer al mismo tenant que el `Report`;
2. pertenecer al cliente del `Report`;
3. caer en el reporting period conforme a `DM-OPEN-008` y `RPT-OPEN-001` una vez aprobadas;
4. poseer un estado funcional apto para reporting;
5. disponer de una `MaintenanceRevision` válida conforme a la política de selección aprobada;
6. no requerir una reinterpretación mediante Last Write Wins;
7. tener disponibles los datos históricos necesarios para construir el contenido.

La existencia de un candidato no autoriza a incluir una revisión arbitraria ni datos de otro período.

La situación de mantenimientos finalizados localmente pero aún no sincronizados queda en `RPT-OPEN-009`.

La situación de conflictos pendientes queda en `RPT-OPEN-010`.

---

# 15. Revisión de mantenimiento utilizada

Un `MaintenanceRecord` puede poseer varias `MaintenanceRevision`.

El Report debe congelar exactamente cuál se utilizó.

## 15.1 Alternativas

### Revisión vigente al preparar el draft

Hace estable el draft, pero puede quedar obsoleto antes de finalizar.

### Revisión vigente al finalizar

Maximiza actualidad y es coherente con la regla aprobada de que una regeneración utilice revisiones vigentes al momento de regenerarse.

### Revisión congelada en draft

Favorece reproducibilidad del proceso de edición, pero puede producir una versión final con datos que ya no son vigentes si ocurrió una corrección legítima.

### Selección manual de una revisión histórica

Ofrece flexibilidad, pero permitiría omitir una corrección vigente y debilitaría el significado del informe principal mensual sin una regla explícita de negocio.

## 15.2 Restricción ya aprobada para regeneración

Al regenerar, la nueva versión debe utilizar las revisiones vigentes. Lo que permanece abierto es el momento exacto del flujo en el que se fija “vigente” cuando existe un draft de regeneración que puede quedar stale.

## 15.3 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** fijar en la finalización la revisión vigente y autoritativa de cada mantenimiento incluido. El draft puede conservar la revisión con la que fue preparado para permitir revisión humana, pero si aparece una revisión posterior debe considerarse stale y aplicarse la política de `RPT-OPEN-003` antes de finalizar.

No se recomienda permitir selección arbitraria de revisiones históricas para el informe mensual principal.

Esta decisión se registra como `RPT-OPEN-002`.

---

# 16. Correcciones ocurridas mientras el informe está en draft

Escenario:

- el draft contiene Maintenance A, Revision 1;
- antes de finalizar se crea Revision 2;
- el draft todavía contiene información derivada de Revision 1.

La implementación no debe decidir silenciosamente entre:

- reemplazar automáticamente todo el contenido;
- mantener Revision 1 sin advertencia;
- bloquear el informe;
- permitir una elección manual arbitraria.

## 16.1 Principios

- el usuario debe poder saber que la fuente cambió;
- ningún refresh debe destruir silenciosamente texto editorial sin mostrar el impacto;
- la versión finalizada debe congelar la revisión finalmente aprobada;
- una corrección posterior a la finalización no cambia el informe ya finalizado.

## 16.2 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** marcar el draft como **stale** respecto de la fuente cambiada, mostrar qué mantenimiento/recurso cambió y exigir una acción explícita de refresh/revisión antes de finalizar. El sistema no debe cambiar silenciosamente el snapshot futuro mientras `COMPANY_ADMIN` revisa el informe.

La misma regla conceptual debería cubrir cambios relevantes de:

- mantenimiento/revisión;
- cliente;
- equipo;
- ubicación;
- nueva Evidence utilizable;
- configuración de template seleccionada.

Esta decisión se registra como `RPT-OPEN-003`.

---

# 17. Inclusión/exclusión manual

La baseline exige consolidar mantenimientos del período y el encargo requiere selección/revisión de contenido, pero no define el grado de discrecionalidad de `COMPANY_ADMIN`.

## 17.1 Alternativas

1. incluir automáticamente todos los candidatos sin excepción;
2. permitir excluir candidatos;
3. permitir incluir candidatos y excluir algunos;
4. permitir además incluir mantenimientos fuera del período;
5. exigir o no una justificación de exclusión.

## 17.2 Evaluación

Incluir automáticamente todo maximiza completitud, pero puede impedir resolver casos administrativos legítimos todavía no modelados.

Permitir exclusión sin trazabilidad reduce reproducibilidad.

Permitir incluir fuera del período contradice la semántica del informe mensual y puede convertir el período en meramente decorativo.

## 17.3 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:**

- todos los mantenimientos que cumplan los criterios aprobados aparecen como candidatos;
- `COMPANY_ADMIN` puede decidir no incluir un candidato, con una razón explícita conservada como parte del contexto histórico del informe;
- no puede incluir manualmente un mantenimiento que no pertenece al período según `DM-OPEN-008` ni que pertenece a otro cliente/tenant;
- la selección final queda congelada en el snapshot.

No se crea una figura de “informe extraordinario” en esta decisión.

Esta decisión se registra como `RPT-OPEN-004`.

---

# 18. Unicidad de `Report` — `DM-OPEN-005`

La pregunta es si `tenant + client + reporting period` identifica un único `Report` lógico.

## 18.1 Alternativa 1 — exactamente un `Report` lógico

Para cada tenant, cliente y período existe un único informe lógico. Correcciones posteriores se expresan como nuevas `ReportVersion`.

**Ventajas:**

- el significado del informe mensual es inequívoco;
- evita números oficiales distintos para el mismo “informe mensual principal”;
- hace que regeneración sea el mecanismo natural de corrección;
- reduce duplicados y confusión en históricos;
- simplifica UX conceptual.

**Costo:** no permite varios informes mensuales paralelos con significados diferentes sin ampliar el producto.

## 18.2 Alternativa 2 — varios `Report` independientes

Permitir varios informes para el mismo cliente/período.

**Ventaja:** flexibilidad.

**Riesgos:**

- múltiples números oficiales para el mismo período;
- difícil distinguir cuál es “el” informe mensual;
- duplicidad accidental;
- regeneración y nuevo Report pueden confundirse;
- auditoría y UX más complejas.

## 18.3 Alternativa 3 — uno principal + adicionales extraordinarios

Mantener un informe principal y permitir adicionales con otro propósito.

**Ventaja:** combina unicidad y extensibilidad.

**Riesgo:** introduce un nuevo concepto de informe extraordinario que no está aprobado en el MVP.

## 18.4 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** adoptar **exactamente un `Report` lógico por `tenant + client + reporting period`** para el informe mensual principal. Las correcciones, actualización de revisiones o cambios de contenido después de la primera finalización deben producir nuevas `ReportVersion`, no nuevos `Report`.

No se recomienda introducir informes extraordinarios en el MVP sin una decisión de producto separada.

**Estado de `DM-OPEN-005`: `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.**

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

---

# 19. Creación del primer `Report`

Conceptualmente, preparar el primer informe requiere:

1. seleccionar un `Client` del mismo tenant;
2. seleccionar el reporting period;
3. resolver el `ReportTemplate` inicial aplicable;
4. obtener mantenimientos candidatos conforme a las reglas aprobadas;
5. revisar las `MaintenanceRevision` que representan esos mantenimientos;
6. revisar datos factuales y Evidence disponibles;
7. preparar contenido editorial;
8. mantener el resultado como draft hasta una finalización explícita.

Crear este draft:

- no asigna número oficial;
- no crea todavía `v1` histórica;
- no produce un documento oficial;
- no congela definitivamente datos que todavía están en revisión.

---

# 20. Draft de informe

El draft debe ser editable antes de finalización.

Puede incluir edición de:

- selección de mantenimientos dentro de la política que se apruebe;
- textos narrativos;
- títulos editoriales cuando el template lo permita;
- introducciones;
- observaciones;
- conclusiones;
- recomendaciones redactadas;
- organización permitida por el template;
- selección de Evidence conforme a la política aprobada.

No debe permitir editar como texto libre los hechos técnicos de origen para hacer que el informe muestre un dato diferente del mantenimiento.

Si un dato técnico es incorrecto, debe corregirse mediante el flujo de mantenimiento que genera una nueva `MaintenanceRevision`; el Report sólo puede seleccionar/consumir el histórico permitido.

---

# 21. Datos técnicos vs contenido editorial

## 21.1 Factual/system-derived

Son hechos derivados de fuentes de dominio, entre otros:

- cliente;
- ubicaciones;
- equipo;
- tipo de mantenimiento;
- fechas de negocio aprobadas;
- `MaintenanceRevision`;
- `FormVersion`;
- labels históricos;
- unidades;
- respuestas;
- mediciones;
- opciones seleccionadas;
- Evidence;
- categorías `BEFORE`/`AFTER`;
- relaciones históricas relevantes.

Estos datos no pueden reescribirse desde Reporting para cambiar el registro técnico.

## 21.2 Editorial

Incluye, entre otros:

- introducción;
- resumen ejecutivo;
- síntesis mensual;
- observaciones narrativas;
- conclusiones;
- recomendaciones redactadas;
- textos explicativos.

Estos textos pueden ser escritos por `COMPANY_ADMIN` o asistidos por IA, pero deben permanecer subordinados a los hechos.

## 21.3 Frontera

Una frase editorial puede explicar un valor técnico, pero no reemplazarlo ni convertir una afirmación no respaldada en un hecho del sistema.

---

# 22. Snapshot y contenido editorial

Para preservar el significado de una versión, el snapshot debe congelar o fijar históricamente al menos:

- mantenimientos incluidos;
- revisión exacta utilizada por cada mantenimiento;
- datos técnicos presentados;
- contexto histórico de cliente, ubicación y equipo mostrado;
- `FormVersion` y definición necesaria para interpretar respuestas;
- Evidence seleccionada e interpretación conforme a las reglas aprobadas;
- contenido editorial final;
- número oficial y versión cuando correspondan;
- reporting period y zona temporal efectiva aprobada;
- configuración efectiva de presentación/template necesaria;
- metadata mínima de finalización necesaria para interpretar la versión.

El diseño físico podrá separar estas partes, siempre que no exista dependencia de datos mutables actuales para reconstruir una versión finalizada.

---

# 23. Momento de creación del snapshot

El snapshot se vuelve inmutable **como parte de la finalización de la `ReportVersion`**.

Antes de finalizar, el draft puede cambiar y no debe tratarse como snapshot histórico definitivo.

Después de finalizar:

- no puede mutarse;
- no puede reemplazarse por un snapshot “más actualizado”;
- no puede apuntar silenciosamente a revisiones posteriores.

La relación temporal exacta entre:

- obtención del número;
- congelación del snapshot;
- construcción del `ReportDocumentModel`;
- generación de PDF/DOCX;
- publicación de la versión como finalizada

permanece en `RPT-OPEN-006` porque la baseline no define el comportamiento observable ante fallos parciales.

---

# 24. Inmutabilidad

Después de finalizar una `ReportVersion`, queda prohibido:

- cambiar su snapshot;
- reemplazar contenido factual in place;
- reemplazar contenido editorial final in place;
- cambiar la `MaintenanceRevision` utilizada;
- reinterpretar respuestas mediante la `FormVersion` actual;
- reinterpretar Evidence mediante su estado actual;
- aplicar silenciosamente branding/template actual a una versión histórica;
- cambiar número oficial;
- cambiar versión;
- eliminar una versión anterior porque exista otra más nueva;
- modificarla porque un DOCX descargado fue editado externamente.

Cualquier cambio semántico posterior pertenece a una nueva `ReportVersion`.

---

# 25. Regeneración

Regenerar significa:

**`Report` existente → nueva `ReportVersion` finalizada**.

Debe:

- conservar el mismo `Report`;
- conservar el mismo número oficial;
- incrementar el ordinal de versión;
- crear snapshot nuevo;
- utilizar las revisiones vigentes conforme a la regla aprobada;
- aplicar la política de template aprobada en `DM-OPEN-006`;
- fijar nuevamente contenido editorial final para esa versión;
- producir documentos de esa versión;
- conservar intactas todas las versiones previas.

Una regeneración no “actualiza v1”.

---

# 26. Regeneración vs edición

Deben distinguirse cuatro acciones:

## 26.1 Editar draft

Modificar preparación todavía no finalizada. No crea versión histórica por cada edición.

## 26.2 Regenerar Report

Finalizar una nueva versión semántica de un Report ya finalizado. Crea `vN+1`.

## 26.3 Corregir mantenimiento

Modificar el estado técnico mediante una nueva `MaintenanceRevision`. No crea automáticamente una versión de informe.

## 26.4 Re-emisión técnica

Volver a producir un documento desde el mismo snapshot/modelo porque un archivo falló, se perdió o necesita retry técnico, sin cambio semántico intencional.

La relación exacta de la re-emisión con `ReportVersion` está en `RPT-OPEN-005`.

---

# 27. Re-emisión técnica desde el mismo snapshot

Un retry técnico no debería incrementar versiones cuando no existe cambio semántico.

## 27.1 Alternativas

1. cualquier nueva generación de archivo crea `vN+1`;
2. una re-emisión desde el mismo snapshot pertenece a la misma `ReportVersion`;
3. distinguir retry durante finalización de re-emisión posterior por pérdida de archivo.

## 27.2 Evaluación

La alternativa 1 contaminaría el historial de versiones con fallos técnicos.

La alternativa 2 preserva la semántica, pero debe impedir que un renderer o template actual cambie silenciosamente el contenido de un documento histórico.

La alternativa 3 permite distinguir con claridad un retry inmediato de una reconstrucción posterior.

## 27.3 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** una re-emisión puramente técnica debe permanecer dentro de la **misma `ReportVersion` y el mismo snapshot**, siempre que derive exactamente del mismo contenido semántico y configuración histórica. Si para producir el documento fuera necesario cambiar datos, template efectivo, editorial o interpretación, deja de ser una re-emisión y requiere una nueva `ReportVersion`.

Un archivo ya existente no debe ser reemplazado silenciosamente por otro con significado diferente.

Se registra como `RPT-OPEN-005`.

---

# 28. `DM-OPEN-006` — template en regeneración

La baseline no define qué configuración visual se usa en una nueva versión cuando el `ReportTemplate` cambió desde la versión anterior.

## 28.1 Alternativa 1 — conservar configuración histórica anterior

`v2` reutiliza la misma configuración efectiva que `v1`.

**Ventajas:** máxima continuidad visual y menor sorpresa.

**Costo:** no permite adoptar branding o mejoras de template en una regeneración salvo otro mecanismo.

## 28.2 Alternativa 2 — usar configuración vigente

Cada regeneración toma la configuración actual del template.

**Ventaja:** cambios de branding/presentación aparecen en la nueva versión.

**Riesgo:** un cambio visual podría entrar silenciosamente en una regeneración cuyo objetivo era sólo reflejar una corrección técnica.

## 28.3 Alternativa 3 — permitir elegir

`COMPANY_ADMIN` selecciona/revisa el template/configuración que desea para la nueva versión.

**Ventaja:** intención explícita.

**Costo:** añade una decisión al flujo de regeneración.

## 28.4 Alternativa 4 — snapshot de template por versión

No decide cuál template se elige, pero asegura que la configuración aplicada quede congelada por versión.

Esta propiedad es necesaria cualquiera sea la política de selección.

## 28.5 Identidad vs configuración efectiva

Debe distinguirse:

- identidad administrativa de `ReportTemplate`;
- configuración efectiva aplicada a una `ReportVersion`.

Un template mutable no puede ser la única fuente para reconstruir una versión antigua.

## 28.6 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** durante cada regeneración, tratar la selección/configuración de template como parte explícita del draft. Utilizar como candidato inicial la configuración previamente usada para minimizar cambios accidentales, pero permitir que `COMPANY_ADMIN` elija deliberadamente una configuración vigente de un `ReportTemplate` de su tenant antes de finalizar. En todos los casos, la configuración efectiva aplicada queda congelada históricamente para la nueva versión.

La elección no puede cambiar versiones anteriores.

**Estado de `DM-OPEN-006`: `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.**

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

---

# 29. Cambios de branding/template

Cambios posteriores pueden incluir:

- logo;
- nombre o datos visibles de empresa;
- encabezado;
- pie;
- portada;
- orden de secciones;
- textos estáticos;
- reglas de presentación.

Un cambio posterior no debe alterar:

- PDF ya generado de una versión histórica;
- DOCX ya generado de una versión histórica;
- snapshot;
- `ReportDocumentModel` histórico interpretable.

La nueva configuración sólo puede afectar una futura versión conforme a `DM-OPEN-006`.

---

# 30. Numeración oficial

La numeración oficial debe preservar las siguientes reglas:

- es correlativa por empresa de mantenimiento;
- se asigna al finalizar el primer informe lógico;
- pertenece al `Report`, no a cada `ReportVersion`;
- permanece estable en regeneraciones;
- no se asigna por preview;
- no se asigna por mera creación de draft;
- no cambia por retry técnico;
- no se reutiliza entre `Report` distintos;
- no depende de que el usuario conozca un path o identificador de archivo.

Este documento no define formato, sequence, locking, transacción ni SQL.

---

# 31. Fallo durante asignación/finalización

Debe contemplarse conceptualmente que un intento de finalización pueda fallar después de iniciar alguna de estas acciones:

- obtención/reserva del siguiente número;
- preparación del snapshot;
- construcción del modelo documental;
- generación de PDF;
- generación de DOCX;
- asociación de documentos.

La baseline no especifica qué debe ver el usuario si el proceso queda parcialmente completado.

Principios obligatorios:

- no debe aparecer una versión finalizada que carezca de la consistencia mínima aprobada;
- un retry técnico no debe crear una versión semántica duplicada;
- nunca debe reutilizarse un número ya reconocido como oficial para un `Report` diferente;
- una falla no debe mutar una versión histórica previa.

La política observable se concentra en `RPT-OPEN-006`, complementada por `RPT-OPEN-007` para huecos de numeración.

---

# 32. Huecos en numeración

“Correlativa” no equivale automáticamente a “sin huecos”.

La baseline no define si un número que fue reservado o alcanzó algún grado de asignación durante un fallo puede dejar un hueco.

## 32.1 Alternativas

1. garantía estricta de ausencia de huecos;
2. permitir huecos técnicos/auditables y nunca reutilizar un número consumido;
3. considerar oficial sólo el número asociado a una finalización exitosa y permitir que la estrategia técnica gestione intentos sin promesa gapless.

## 32.2 Evaluación

Una garantía “sin huecos” puede imponer restricciones técnicas y eventualmente legales/contables que no están aprobadas.

La reutilización de números tras fallos puede producir ambigüedad si existió cualquier documento o referencia externa con ese número.

## 32.3 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** no prometer numeración “sin huecos”. Mantener la regla fuerte de **no reutilizar un número que haya llegado a considerarse asignado/oficial**, y documentar/auditar cualquier hueco que resulte de fallos según el futuro diseño. La frontera exacta de “asignado” debe coordinarse con `RPT-OPEN-006`.

Se registra como `RPT-OPEN-007`.

---

# 33. `ReportDocumentModel`

El `ReportDocumentModel` debe representar conceptualmente, en forma neutral al formato:

- metadata del informe;
- número oficial;
- versión;
- cliente;
- período;
- zona temporal efectiva una vez aprobada;
- branding;
- portada;
- encabezados/pies;
- secciones;
- mantenimientos incluidos;
- equipos;
- ubicaciones relevantes;
- tipo de mantenimiento cuando corresponda;
- labels y estructura histórica de `FormVersion`;
- respuestas seleccionadas;
- unidades y opciones históricas;
- Evidence seleccionada e interpretación aprobada;
- contenido editorial final;
- tablas;
- reglas de ocultación/presentación aplicadas;
- información necesaria para producir PDF y DOCX con el mismo significado.

No se define JSON, schema, clases ni tipos físicos.

---

# 34. Pipeline conceptual

El pipeline semántico único es:

**`ReportSnapshot` + configuración histórica aplicable → `ReportDocumentModel` → PDF / DOCX**.

El contenido editorial final y la configuración efectiva deben quedar históricamente fijados como parte de los insumos inmutables de la versión, aunque su representación física pueda estar separada.

No se permite:

- construir PDF consultando una fuente distinta que DOCX;
- volver a consultar datos actuales para uno de los formatos;
- aplicar reglas de selección distintas por formato.

---

# 35. PDF canónico

El PDF:

- es el documento oficial/canónico de la plataforma;
- pertenece a una `ReportVersion` concreta;
- debe representar exactamente el contenido semántico de esa versión;
- no debe mutar porque cambien datos fuente posteriormente;
- no debe mutar porque cambie el template posteriormente;
- puede descargarse múltiples veces sin cambiar significado;
- no convierte su URL en un permiso;
- no sustituye al snapshot.

La edición externa de un PDF no altera el `Report` ni crea una nueva versión en el SaaS.

---

# 36. DOCX editable

El DOCX:

- se genera desde el mismo `ReportDocumentModel` que el PDF;
- debe conservar la misma información funcional;
- debe ser editable;
- debe buscar compatibilidad práctica con Microsoft Word, Google Docs y LibreOffice;
- puede presentar diferencias inevitables de layout respecto del PDF;
- no es el documento canónico;
- una edición externa no modifica la `ReportVersion`;
- un DOCX modificado fuera del SaaS no se convierte automáticamente en el documento oficial.

## 36.1 `DO-077` — subconjunto DOCX portable

La baseline exige definir un subconjunto de maquetación verificable antes de Fase 6.

### Propuesta

**PROPUESTA PENDIENTE DE APROBACIÓN:** limitar el DOCX del MVP a elementos de flujo documental ampliamente portables:

- párrafos y estilos de texto estándar;
- títulos/jerarquía de encabezados;
- listas simples;
- tablas estándar;
- imágenes embebidas de disposición simple;
- encabezado y pie;
- saltos de página y estructura de documento estándar;
- alineación y espaciado razonables que no dependan de posicionamiento absoluto.

Evitar como requisito del MVP:

- cajas de texto flotantes complejas;
- posicionamiento absoluto;
- layouts de publicación avanzados;
- macros;
- objetos propietarios;
- composición que dependa de un único procesador de texto.

### Criterio de verificación propuesto

Mantener un fixture representativo de informe y comprobar que:

- abre sin corrupción;
- conserva contenido, tablas e imágenes;
- mantiene una jerarquía legible;
- permanece editable;
- no pierde información funcional

al abrirse en Microsoft Word, Google Docs y LibreOffice.

No se exige equivalencia pixel-perfect entre aplicaciones.

**Estado de `DO-077`: PENDIENTE DE APROBACIÓN.**

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

---

# 37. Consistencia PDF/DOCX

Para una misma `ReportVersion`, ambos formatos deben representar:

- mismo número oficial;
- misma versión;
- mismo cliente;
- mismo período;
- mismos mantenimientos;
- mismas `MaintenanceRevision`;
- mismos hechos técnicos;
- mismo contenido editorial final;
- misma selección semántica de Evidence;
- misma estructura lógica definida por el `ReportDocumentModel`.

Se permiten diferencias inevitables de:

- paginado;
- salto de línea;
- ajuste de tabla;
- distribución de imágenes;
- métricas de tipografía.

No se exige pixel-perfect equivalence.

---

# 38. Errores de generación documental

Deben contemplarse al menos:

- PDF falla y DOCX funciona;
- DOCX falla y PDF funciona;
- ambos fallan;
- uno termina y la respuesta de confirmación se pierde;
- un retry repite una operación ya completada.

Principios:

- retry técnico no crea nueva versión por defecto;
- el estado histórico no puede depender de una respuesta de red perdida;
- PDF y DOCX deben seguir ligados al mismo snapshot;
- no debe declararse una versión finalizada de forma incoherente respecto de la política aprobada.

La baseline no define si una finalización requiere necesariamente que ambos archivos hayan quedado generados y asociados con éxito antes de considerarse completada. Esto se resuelve en `RPT-OPEN-006`.

---

# 39. Persistencia de documentos

Los documentos finalizados deben quedar conceptualmente asociados a su `ReportVersion`.

Cada asociación debe preservar:

- tenant;
- Report;
- versión;
- tipo de documento;
- pertenencia histórica.

No se diseña Storage.

Conocer un path, URL o nombre de archivo no concede acceso. La futura autorización debe derivarse del recurso de dominio.

---

# 40. Evidence en informes

Reporting puede incorporar Evidence, pero debe respetar íntegramente `06`.

En particular:

- cada Evidence conserva identidad;
- conserva su `Response` de origen;
- conserva su revisión de origen;
- conserva su categoría histórica;
- un visual replacement no elimina el original;
- replacement y continuidad entre revisiones son conceptos diferentes;
- Reporting no puede calcular por inferencia el `Effective Evidence set` de una revisión mientras `EVID-OPEN-006` siga abierta;
- Reporting no puede decidir la vigencia visual de una cadena mientras `EVID-OPEN-004` siga abierta;
- Reporting no puede inventar reglas de categoría en replacement mientras `EVID-OPEN-005` siga abierta.

La implementación de Reporting debe consumir las resoluciones futuras aprobadas de esas decisiones.

---

# 41. Selección de Evidence

La baseline permite que fotografías aparezcan en informes, pero no determina si deben incluirse:

- todas las Evidence efectivas;
- una selección automática por template;
- sólo categorías determinadas;
- una selección manual;
- una combinación de template + decisión del administrador.

No existe un límite comercial aprobado de cantidad de fotografías por informe.

## 41.1 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** el `ReportTemplate` debe definir elegibilidad y presentación general, mientras `COMPANY_ADMIN` puede seleccionar el subconjunto concreto que aparecerá en el draft entre las Evidence que pertenezcan al `Effective Evidence set` aprobado de la `MaintenanceRevision` seleccionada. La selección final queda congelada en el snapshot.

No puede seleccionarse Evidence fuera del tenant/cliente/mantenimiento/revisión permitidos.

La propuesta queda condicionada a `EVID-OPEN-004/005/006`.

Se registra como `RPT-OPEN-008`.

---

# 42. Evidence superseded

Una `ReportVersion` histórica debe conservar exactamente la selección e interpretación de Evidence utilizada al finalizar.

Si posteriormente:

- se crea una nueva Evidence;
- cambia la vigencia visual mediante replacement conforme a la política aprobada;
- aparece una nueva `MaintenanceRevision`;
- cambia el `Effective Evidence set` vigente;

la versión anterior no cambia.

Un informe nuevo/regenerado puede usar una interpretación posterior conforme a las reglas vigentes, pero nunca reescribe la anterior.

---

# 43. Fotografías y layout

Principios de presentación:

- mantener relación visible con mantenimiento/respuesta;
- preservar contexto suficiente para entender qué se fotografía;
- diferenciar claramente `BEFORE` y `AFTER` cuando corresponda;
- no presentar como comparación elementos cuya semántica no lo permite;
- no perder la revisión/origen histórico en la interpretación del snapshot;
- evitar layout que desconecte imagen y hecho técnico asociado.

No se definen grids, tamaños fijos, algoritmos de mosaico ni edición avanzada de imágenes.

---

# 44. Datos de cliente y equipo en snapshot

Nombres, descripciones, ubicaciones y demás datos maestros pueden cambiar después de finalizar un informe.

La versión histórica debe preservar lo que efectivamente mostró.

Por ello no debe depender exclusivamente de joins a datos actuales para reconstruir:

- nombre del cliente;
- identificación del equipo;
- descripción del equipo;
- ubicación mostrada;
- otros datos maestros visibles.

El snapshot debe fijar históricamente la representación necesaria.

---

# 45. `FormVersion` histórica

Cada mantenimiento se interpreta con la `FormVersion` exacta que utilizó.

Reporting debe obtener de esa versión histórica:

- labels;
- opciones;
- unidades;
- estructura;
- orden;
- metadata funcional;
- definición necesaria para interpretar matrices/repeatables;
- respuestas correspondientes.

Nunca debe usar la definición publicada actual para reinterpretar un mantenimiento antiguo.

Los campos de versiones diferentes son independientes. Reporting no debe asumir identidad lógica entre campos porque compartan label, posición o tipo.

---

# 46. Datos históricos de `Response`

Una respuesta incluida pertenece a la revisión y `FormVersion` históricas correspondientes.

Una corrección futura puede producir nuevos valores en una nueva `MaintenanceRevision`, pero no modifica lo que mostró una `ReportVersion` anterior.

Una nueva versión del Report puede reflejar la revisión posterior conforme a las reglas aprobadas.

---

# 47. Draft y datos cambiantes

Mientras un Report permanece en draft pueden cambiar:

- una `MaintenanceRevision`;
- datos del cliente;
- datos del equipo;
- ubicación;
- Evidence disponible;
- template/configuración.

El draft debe poder comunicar que su vista de fuentes quedó obsoleta.

No se define polling, realtime ni mecanismo técnico.

La política recomendada de staleness/refresh explícito está en `RPT-OPEN-003`.

---

# 48. Preview

`COMPANY_ADMIN` puede visualizar un preview antes de finalizar.

Preview:

- no asigna número oficial;
- no crea `ReportVersion` histórica finalizada;
- no crea el documento oficial;
- puede cambiar al modificar el draft;
- puede utilizar el mismo modelo semántico conceptual para anticipar el resultado, sin convertirlo en snapshot final;
- no sirve como autorización para un actor sin permisos.

---

# 49. Finalización

La finalización debe ser una acción explícita de `COMPANY_ADMIN`.

Antes de completarse debe validarse conceptualmente:

- tenant correcto;
- cliente correcto;
- período válido;
- regla temporal aprobada;
- zona temporal aprobada;
- selección de mantenimientos válida;
- `MaintenanceRevision` válida por mantenimiento;
- ausencia o tratamiento aprobado de conflictos;
- disponibilidad remota conforme a la política de Reporting;
- `ReportTemplate`/configuración válida;
- datos necesarios para snapshot;
- Evidence válida conforme a decisiones aprobadas;
- contenido editorial final;
- permisos del actor;
- decisiones bloqueantes de Fase 6 resueltas antes de implementación.

La precisión de qué constituye una finalización exitosa frente a fallos documentales permanece en `RPT-OPEN-006`.

---

# 50. Cancelar/descartar draft

La baseline no define expresamente si un report draft puede descartarse.

## 50.1 Consideraciones

Un draft no finalizado:

- no posee número oficial si es el primer draft;
- puede contener texto editorial;
- puede haber consumido operaciones IA ya ejecutadas;
- puede representar una preparación de regeneración de un Report ya numerado.

Descartar un draft no debe:

- borrar versiones históricas anteriores;
- reutilizar o cambiar el número de un Report ya finalizado;
- generar automáticamente refund de IA;
- modificar mantenimientos fuente.

## 50.2 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** permitir que `COMPANY_ADMIN` descarte un draft no finalizado. En un Report ya finalizado, descartar el draft de regeneración deja intactas todas las versiones existentes. En un primer Report todavía no finalizado, no existe número oficial que liberar. Los consumos IA ya realizados siguen la política de `08`; Reporting no inventa reembolso por descarte.

Se registra como `RPT-OPEN-012`.

---

# 51. Historial de versiones

El histórico debe permitir interpretar cada `ReportVersion` mediante, al menos:

- número oficial del Report;
- ordinal de versión;
- fecha/momento de finalización;
- actor que finalizó;
- cliente;
- período;
- snapshot asociado;
- documentos asociados;
- template/configuración efectiva utilizada;
- fuentes/revisiones congeladas.

No se diseña UI ni tabla física.

---

# 52. Auditoría

Deben identificarse como acciones sensibles para la futura estrategia de auditoría:

- primera finalización;
- regeneración;
- cambio deliberado de template/configuración entre versiones;
- operaciones IA;
- intentos y usos efectivos de soporte excepcional;
- cambios de selección que alteren el contenido final cuando la política aprobada requiera trazabilidad;
- re-emisión técnica cuando afecte artefactos históricos;
- descargas, únicamente si posteriormente se aprueba su auditoría como requisito.

El acceso efectivo de `SUPER_ADMIN` mediante soporte ya debe auditarse conforme a `03`.

Este documento no diseña `AuditEvent` ni decide retención.

---

# 53. Asistencia IA

IA sólo puede asistir en contenido editorial.

Puede proponer:

- resumen ejecutivo;
- síntesis del período;
- descripción narrativa del trabajo;
- observaciones;
- recomendaciones redactadas;
- conclusiones;
- explicación narrativa de mediciones fuera de rango basada en datos permitidos.

No debe:

- modificar respuestas;
- cambiar mediciones;
- crear mantenimientos inexistentes;
- decidir qué mantenimiento se incluye;
- modificar Evidence;
- interpretar fotografías;
- hacer OCR;
- asignar número oficial;
- finalizar el informe;
- convertir automáticamente una sugerencia en contenido oficial.

---

# 54. Contexto IA

Conceptualmente, una operación autorizada puede utilizar el subconjunto necesario de:

- datos del Report draft;
- mantenimientos seleccionados;
- respuestas;
- datos de cliente/equipo relevantes;
- históricos pertinentes del mismo equipo o cliente;
- contexto técnico suficiente para redactar.

Debe minimizar:

- identificadores innecesarios;
- datos no relacionados;
- información personal o industrial que no sea necesaria para la operación.

No se envían fotografías como contenido visual en el MVP.

No se diseña prompt, modelo, payload ni integración concreta.

---

# 55. Revisión humana de IA

Todo texto sugerido por IA debe:

- ser visible para `COMPANY_ADMIN`;
- poder editarse;
- poder rechazarse;
- poder aceptarse de forma consciente;
- quedar bajo control humano antes de finalización.

El snapshot final congela el texto editorial aceptado/editado, no una “verdad IA” separada.

La futura política de almacenamiento de prompts/respuestas debe respetar la minimización definida en `01` y `08`.

---

# 56. Créditos IA

Reporting reconoce las siguientes reglas:

- cada operación IA consume créditos conforme a la futura especificación;
- no se infiere IA gratuita;
- distintas operaciones pueden tener costos distintos;
- una nueva operación IA durante una regeneración vuelve a consumir créditos;
- un retry técnico de una misma operación no debe convertirse silenciosamente en doble cobro;
- un fallo debe compensarse/revertirse conforme a la política futura;
- `COMPANY_ADMIN` puede deshabilitar IA para el tenant;
- un Report completo debe poder producirse sin IA.

`DM-OPEN-007` — créditos insuficientes — permanece **ABIERTA** y corresponde principalmente a `08-ai-credits-spec.md`.

Este documento no define sobregiro, deuda, reserva, confirmación ni ledger físico.

---

# 57. Informe sin IA

El flujo funcional de Reporting no puede depender de IA.

`COMPANY_ADMIN` debe poder:

- preparar candidatos;
- seleccionar contenido conforme a la política aprobada;
- redactar manualmente textos editoriales;
- previsualizar;
- finalizar;
- regenerar;
- obtener PDF/DOCX

sin ejecutar ninguna operación IA.

IA es asistencia opcional, no una condición de generación.

---

# 58. Seguridad

Principios obligatorios:

- aislamiento tenant en la capa de datos mediante la futura RLS;
- ownership client-scoped para Reports;
- autorización del actor en cada operación;
- no confiar en IDs enviados por frontend como prueba de ownership;
- no usar URL/path de documento como autorización;
- no exponer `service-role` al cliente;
- no utilizar `service-role` como bypass normal de RLS;
- no permitir acceso cross-tenant a snapshots o documentos históricos;
- no incluir fuentes cross-client manipuladas;
- soporte sólo mediante scopes explícitos;
- IA sólo para `COMPANY_ADMIN`;
- documentos históricos sujetos a la misma frontera de autorización que el Report.

La generación en servidor no reemplaza autorización: un backend confiable debe volver a comprobar contexto y ownership.

---

# 59. Privacidad

Los informes pueden contener:

- datos técnicos;
- nombres empresariales o de personas cuando formen parte legítima del registro;
- ubicaciones;
- identificadores de equipos;
- fotografías;
- información industrial potencialmente sensible;
- textos narrativos.

Este documento no inventa:

- períodos legales de retención;
- bases jurídicas;
- obligaciones contractuales;
- políticas de transferencia internacional.

`DO-T07` permanece **DIFERIDO** y debe validarse antes del piloto/producción conforme a la baseline.

---

# 60. Descarga

`COMPANY_ADMIN` puede descargar PDF y DOCX de Reports de su tenant.

`TECHNICIAN` no obtiene lectura ni descarga de informes en el MVP porque la estrategia aprobada de permisos no concede acceso a `Report`.

`SUPER_ADMIN` no descarga por defecto. Cualquier acceso excepcional a documentos debe derivarse de un `SupportAccessGrant` válido para el cliente y scope `informes`, respetando las operaciones que la política de soporte permita expresamente.

El path o una URL anteriormente obtenida no mantienen acceso después de una revocación por sí solos.

---

# 61. Offline y Reporting

El subsistema de mantenimiento es offline-first. La baseline no afirma que el Reporting Engine deba generar informes offline.

No debe inferirse:

- generación PDF local;
- generación DOCX local;
- IA offline;
- snapshot tenant-wide desde `LocalReplica` de un técnico;
- coordinación cross-device sin servidor.

Para Reporting, una fuente remota consistente es especialmente relevante porque `COMPANY_ADMIN` debe consolidar información de múltiples trabajos/dispositivos.

La política propuesta de Reporting online-only y su relación con datos aún no sincronizados se concentra en `RPT-OPEN-009`.

---

# 62. Mantenimientos finalizados localmente pero no sincronizados

Un mantenimiento puede estar finalizado funcionalmente en el dispositivo y todavía no existir o no estar actualizado en la fuente remota autoritativa.

Un Report generado desde servidor no puede asumir acceso a trabajo que:

- existe únicamente en otra `LocalReplica`;
- contiene fotografías todavía locales;
- no ha superado autorización y reconciliación remotas.

Inventar un mecanismo cross-device para recoger esos datos violaría la frontera definida por `04`.

## 62.1 Alternativas

1. Reporting debe funcionar con datos locales/peer-to-peer;
2. Reporting usa únicamente datos confirmados remotamente;
3. Reporting permite preparación parcial con advertencia y bloquea finalización hasta convergencia remota.

## 62.2 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** tratar Reporting como **online/server-backed en el MVP**, utilizando la fuente remota autoritativa. Un mantenimiento finalizado sólo en local no puede incorporarse al snapshot de servidor hasta que su estado/revisión necesaria haya sido sincronizado y aceptado remotamente. El flujo de preparación debe dejar claro que la completitud del mes depende de que el trabajo de campo haya convergido al servidor; no se inventa visibilidad de pendientes existentes únicamente en otros dispositivos.

Esto preserva la regla de que el mantenimiento sí está finalizado localmente; simplemente distingue disponibilidad para Reporting consolidado.

Se registra como `RPT-OPEN-009`.

---

# 63. Conflictos

Un mantenimiento con `SyncConflict` pendiente no puede reinterpretarse usando Last Write Wins.

## 63.1 Alternativas

1. incluir la última revisión remota aunque exista conflicto pendiente;
2. incluir la versión local conocida por algún dispositivo;
3. mostrar advertencia y permitir finalizar igualmente;
4. bloquear la inclusión/finalización para ese mantenimiento hasta resolver el conflicto.

## 63.2 Evaluación

Las alternativas 1 y 2 elegirían una verdad sin resolución explícita.

La alternativa 3 puede producir un informe oficial basado en un estado que el sistema ya sabe que está disputado.

## 63.3 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** cuando el servidor conozca un conflicto pendiente que afecta a un mantenimiento candidato, el Report debe señalarlo y no debe finalizar una versión que pretenda consolidar ese mantenimiento hasta que el conflicto sea resuelto y exista una `MaintenanceRevision` autoritativa resultante. El histórico del conflicto no se elimina.

Se registra como `RPT-OPEN-010`.

---

# 64. Regeneración después de correcciones

Escenario normativo:

1. Report `v1` queda finalizado;
2. Maintenance A se corrige y obtiene una nueva `MaintenanceRevision`;
3. `v1` permanece intacto;
4. `COMPANY_ADMIN` decide regenerar el Report;
5. la nueva versión utiliza la revisión vigente conforme a las reglas aprobadas;
6. se crea un snapshot nuevo;
7. se genera `v2` conservando el mismo número oficial.

El cambio de A no actualiza `v1` en segundo plano.

La Evidence de la nueva revisión se interpreta sólo conforme a `EVID-OPEN-004/005/006` una vez resueltas.

---

# 65. Regeneración sin cambios

La baseline no define si `COMPANY_ADMIN` puede crear deliberadamente una nueva versión idéntica.

## 65.1 Alternativas

1. permitir siempre una nueva versión aunque no exista cambio semántico;
2. impedirla si no cambió ningún insumo relevante;
3. permitirla sólo con una razón explícita;
4. tratar la necesidad de “volver a generar archivo” como re-emisión técnica, no como versión nueva.

## 65.2 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** no crear una nueva `ReportVersion` cuando no existe ningún cambio semántico en fuentes seleccionadas, revisiones, editorial, Evidence o configuración de presentación. Si la necesidad es recuperar/reintentar un archivo, utilizar la política de re-emisión técnica de `RPT-OPEN-005`. Una versión nueva debe representar una generación semánticamente deliberada, no ruido técnico.

Se registra como `RPT-OPEN-011`.

---

# 66. Datos eliminados/archivados posteriormente

Una `ReportVersion` histórica debe seguir siendo interpretable aunque posteriormente:

- el cliente cambie sus datos;
- el equipo cambie sus datos;
- una ubicación se renombre o reorganice;
- un equipo se archive;
- un `FormTemplate` se archive;
- se publique una nueva `FormVersion`;
- un `ReportTemplate` cambie;
- una Evidence sea visualmente superseded en un contexto posterior.

La versión no debe depender de que esos recursos sigan presentando hoy el mismo estado.

Este documento no define hard delete ni política legal de retención.

---

# 67. Testing futuro obligatorio

La futura implementación deberá incluir categorías de pruebas para, como mínimo:

## Ownership y permisos

- ownership de `Report`;
- client isolation;
- tenant isolation;
- rechazo cross-tenant;
- `COMPANY_ADMIN` autorizado;
- `TECHNICIAN` sin acceso a Reporting;
- `SUPER_ADMIN` sin acceso normal;
- support access con client + scope `informes`;
- revocación de soporte.

## Draft y período

- primer draft;
- ausencia de número en draft/preview;
- reporting period;
- timezone una vez resuelta `RPT-OPEN-001`;
- candidatos;
- `DM-OPEN-008` una vez resuelta;
- mantenimiento en límite de mes;
- trabajo offline sincronizado tarde sin cambio artificial de período.

## Revisiones y staleness

- selección de `MaintenanceRevision`;
- corrección durante draft;
- draft stale;
- refresh explícito según regla aprobada;
- no retroactividad después de finalización.

## Selección

- inclusión/exclusión conforme a `RPT-OPEN-004`;
- no inclusión cross-client;
- no inclusión fuera de período conforme a política aprobada.

## Unicidad y versión

- `DM-OPEN-005` una vez resuelta;
- primera finalización;
- `v1`;
- regeneración;
- incremento de versión;
- mismo número oficial;
- versiones anteriores intactas;
- regeneración sin cambios conforme a `RPT-OPEN-011`.

## Template

- `DM-OPEN-006` una vez resuelta;
- cambio de branding;
- template histórico preservado;
- versión previa no afectada.

## Snapshot

- snapshot completo;
- snapshot inmutable;
- datos actuales no contaminan histórico;
- cliente/equipo/ubicación históricos;
- contenido editorial final congelado;
- `FormVersion` histórica.

## Numeración

- número asignado sólo al finalizar;
- no asignación en preview;
- no reutilización entre Reports;
- mismo número entre versiones;
- fallo durante finalización;
- huecos conforme a `RPT-OPEN-007`.

## Documentos

- PDF canónico;
- DOCX editable;
- consistencia PDF/DOCX;
- mismo `ReportDocumentModel` semántico;
- PDF falla;
- DOCX falla;
- retry;
- respuesta perdida;
- re-emisión técnica;
- DO-077 una vez resuelta;
- apertura de fixture DOCX en Word, Google Docs y LibreOffice conforme al criterio aprobado.

## Evidence

- Evidence seleccionada;
- `BEFORE`/`AFTER`;
- replacements;
- versión histórica conserva interpretación;
- `EVID-OPEN-004/005/006` una vez resueltas;
- no duplicación ni reasignación de origen por Reporting.

## Offline/sync/conflictos

- mantenimiento finalizado localmente y pending sync;
- Report server-backed conforme a política aprobada;
- conflicto pendiente;
- no Last Write Wins;
- resolución de conflicto seguida de reporting.

## IA

- Report sin IA;
- IA autorizada sólo para `COMPANY_ADMIN`;
- IA deshabilitada;
- sugerencia editable/rechazable;
- IA no modifica datos factuales;
- IA no decide inclusión;
- IA no finaliza;
- ausencia de imágenes/OCR;
- créditos insuficientes conforme a futura regla;
- retry de operación IA conforme a futura idempotencia/compensación.

No se escriben tests en este documento.

---

# 68. Anti-patrones prohibidos

Quedan expresamente prohibidos:

- generar un informe histórico desde datos actuales sin snapshot;
- sobrescribir una `ReportVersion`;
- mutar un `ReportSnapshot`;
- reutilizar un número oficial para otro `Report`;
- asignar número oficial en preview;
- incrementar versión por retry técnico;
- utilizar `updated_at` como criterio de período por comodidad;
- utilizar sync time como fecha de negocio del mantenimiento;
- utilizar upload time de Evidence como criterio mensual;
- reinterpretar una `FormVersion` histórica con la definición actual;
- correlacionar fields de distintas `FormVersion` por label como si fueran la misma identidad;
- reinterpretar Evidence histórica usando únicamente su estado actual;
- depender de una lista mutable actual para reconstruir una versión;
- tener un pipeline semántico PDF distinto del pipeline DOCX;
- utilizar DOCX como fuente canónica;
- modificar una `ReportVersion` porque alguien editó un DOCX descargado;
- permitir que IA modifique hechos técnicos;
- permitir que IA decida inclusión/exclusión;
- permitir que IA finalice;
- IA sobre imágenes;
- OCR automático como feature;
- exponer `service-role` en frontend;
- utilizar `service-role` para bypass normal de permisos;
- utilizar URL/path/ID de documento como autorización;
- Last Write Wins en mantenimiento conflictivo;
- perder versiones anteriores al regenerar;
- cambiar el número oficial al regenerar;
- inventar un límite comercial de fotografías por informe;
- mover un mantenimiento de período por una sincronización tardía;
- cambiar silenciosamente la revisión de un draft sin informar al administrador;
- duplicar una Evidence para hacerla “pertenecer” a otra revisión;
- resolver silenciosamente `DM-OPEN-*`, `FORM-OPEN-*`, `EVID-OPEN-*` o `RPT-OPEN-*`.

---

# 69. Riesgos

Los siguientes riesgos derivan de Reporting. No constituyen por sí mismos nuevos requisitos de producto.

## `RPT-RSK-001` — Período ambiguo

**Riesgo:** incluir/excluir mantenimientos en meses distintos según un timestamp elegido por implementación.

**Tratamiento:** resolver `DM-OPEN-008` antes de Fase 6.

## `RPT-RSK-002` — Timezone ambigua

**Riesgo:** el mismo mantenimiento cambia de mes según dispositivo/usuario.

**Tratamiento:** resolver `RPT-OPEN-001`.

## `RPT-RSK-003` — Revisión incorrecta de mantenimiento

**Riesgo:** finalizar con una revisión obsoleta o arbitraria.

**Tratamiento:** resolver `RPT-OPEN-002` y aplicar staleness.

## `RPT-RSK-004` — Draft stale no detectado

**Riesgo:** una corrección, cambio de equipo o nueva Evidence no aparece en la versión final sin que el usuario lo sepa.

**Tratamiento:** resolver `RPT-OPEN-003`.

## `RPT-RSK-005` — Selección manual no reproducible

**Riesgo:** informes incompletos sin poder explicar por qué se omitieron mantenimientos.

**Tratamiento:** resolver `RPT-OPEN-004`.

## `RPT-RSK-006` — Snapshot incompleto

**Riesgo:** una versión histórica depende de datos actuales y cambia de significado.

**Tratamiento:** snapshot autosuficiente para interpretación y pruebas históricas.

## `RPT-RSK-007` — Numeración duplicada

**Riesgo:** dos Reports distintos reciben el mismo número oficial.

**Tratamiento:** estrategia de numeración futura con integridad e idempotencia; ADR candidato.

## `RPT-RSK-008` — Política de huecos incorrecta

**Riesgo:** prometer gapless sin base técnica/legal o reutilizar números ambiguos.

**Tratamiento:** resolver `RPT-OPEN-007`.

## `RPT-RSK-009` — Retry crea versión duplicada

**Riesgo:** un timeout genera `v2` aunque `v1` ya se finalizó.

**Tratamiento:** idempotencia de finalización/re-emisión y `RPT-OPEN-005/006`.

## `RPT-RSK-010` — PDF/DOCX divergen

**Riesgo:** los formatos muestran hechos o selecciones diferentes.

**Tratamiento:** `ReportDocumentModel` único y pruebas de consistencia.

## `RPT-RSK-011` — Template histórico perdido

**Riesgo:** regenerar o reabrir una versión aplica branding actual a un histórico.

**Tratamiento:** congelar configuración efectiva y resolver `DM-OPEN-006`.

## `RPT-RSK-012` — Evidence incorrecta

**Riesgo:** se muestra una foto que no pertenece al estado efectivo de la revisión seleccionada.

**Tratamiento:** depender de resoluciones `EVID-OPEN-*` y `RPT-OPEN-008`.

## `RPT-RSK-013` — Replacement histórico incorrecto

**Riesgo:** una versión antigua cambia visualmente al aparecer un replacement posterior.

**Tratamiento:** snapshot fija selección/interpretación por versión; no consultar estado mutable actual.

## `RPT-RSK-014` — Datos actuales contaminan histórico

**Riesgo:** nombre de equipo, ubicación, labels o unidades actuales sustituyen lo mostrado originalmente.

**Tratamiento:** snapshot histórico y `FormVersion` exacta.

## `RPT-RSK-015` — Exposición cross-tenant

**Riesgo:** snapshot/documento incorpora o expone recursos de otro tenant.

**Tratamiento:** ownership, RLS futura, validación server-side y pruebas negativas.

## `RPT-RSK-016` — Documento accesible por URL

**Riesgo:** una URL compartida actúa como bypass de autorización.

**Tratamiento:** autorización derivada del Report, nunca del path.

## `RPT-RSK-017` — IA inventa hechos

**Riesgo:** un texto sugerido afirma trabajos o resultados inexistentes.

**Tratamiento:** IA editorial, contexto acotado y revisión humana obligatoria.

## `RPT-RSK-018` — IA altera factual

**Riesgo:** un valor técnico es reemplazado por texto generado o reinterpretado como dato fuente.

**Tratamiento:** frontera estricta factual/editorial.

## `RPT-RSK-019` — Créditos/cobro inconsistente

**Riesgo:** retry duplica consumo o fallo deja un cargo definitivo.

**Tratamiento:** futura especificación `08`, sin resolver `DM-OPEN-007` aquí.

## `RPT-RSK-020` — Mantenimiento pending sync omitido

**Riesgo:** se finaliza un informe creyendo que el mes está completo mientras existe trabajo únicamente local.

**Tratamiento:** resolver `RPT-OPEN-009` y establecer proceso operativo de convergencia antes de cierre mensual.

## `RPT-RSK-021` — Conflicto no resuelto incluido

**Riesgo:** el documento oficial elige silenciosamente una versión disputada.

**Tratamiento:** resolver `RPT-OPEN-010`; nunca Last Write Wins.

## `RPT-RSK-022` — Regeneración altera `v1`

**Riesgo:** el sistema “actualiza” una versión anterior en lugar de crear `v2`.

**Tratamiento:** inmutabilidad de version/snapshot y pruebas de regresión.

## `RPT-RSK-023` — Re-emisión cambia significado

**Riesgo:** reconstruir un archivo perdido con renderer/configuración actual produce un documento distinto bajo la misma versión.

**Tratamiento:** `RPT-OPEN-005`, configuración histórica y comparación semántica.

## `RPT-RSK-024` — Finalización parcial observable

**Riesgo:** existe número/snapshot/PDF pero no DOCX, o estado inconsistente entre componentes.

**Tratamiento:** resolver `RPT-OPEN-006` antes de Fase 6.

## `RPT-RSK-025` — Duplicidad de Reports mensuales

**Riesgo:** varios Reports independientes compiten como “informe mensual” del mismo cliente/período.

**Tratamiento:** resolver `DM-OPEN-005`.

---

# 70. Decisiones candidatas a ADR

Este documento no genera ADRs.

Se identifican como candidatas:

## `RPT-ADR-CAND-001` — Modelo `Report` / `ReportVersion` / `ReportSnapshot`

Separación entre identidad lógica, versión histórica y snapshot.

## `RPT-ADR-CAND-002` — Atomicidad conceptual de finalización

Cómo garantizar una transición coherente entre número, snapshot, documentos y estado finalizado una vez resuelta `RPT-OPEN-006`.

## `RPT-ADR-CAND-003` — Estrategia de numeración oficial

Asignación correlativa por tenant, no reutilización e idempotencia sin fijar todavía SQL.

## `RPT-ADR-CAND-004` — Snapshot strategy

Cómo preservar datos factuales, editorial y configuración efectiva sin depender de fuentes mutables.

## `RPT-ADR-CAND-005` — `ReportDocumentModel`

Modelo semántico común para renderizadores.

## `RPT-ADR-CAND-006` — Pipeline PDF/DOCX

Dos renderizadores desde un único modelo, con consistencia semántica.

## `RPT-ADR-CAND-007` — Persistencia de documentos

Asociación histórica de artefactos y frontera de autorización.

## `RPT-ADR-CAND-008` — Template snapshot/versioning

Cómo fijar configuración efectiva por `ReportVersion` después de resolver `DM-OPEN-006`.

## `RPT-ADR-CAND-009` — Selección de `MaintenanceRevision`

Cómo materializar la revisión autoritativa y detección de staleness después de resolver `RPT-OPEN-002/003`.

## `RPT-ADR-CAND-010` — Integración de Evidence

Cómo consumir el `Effective Evidence set` y replacement histórico una vez resueltas `EVID-OPEN-004/005/006` y `RPT-OPEN-008`.

## `RPT-ADR-CAND-011` — Integración IA server-side

Frontera de datos, autorización y minimización; sólo después de la especificación de IA/créditos.

## `RPT-ADR-CAND-012` — Retries e idempotencia de generación

Cómo distinguir retry, re-emisión y nueva versión.

No se crea ningún ADR en Fase 0 mediante este documento.

---

# 71. Nuevas decisiones abiertas `RPT-OPEN-*`

Todas las decisiones de esta sección permanecen **ABIERTAS — PROPUESTA PENDIENTE DE APROBACIÓN**. Ninguna bloquea Fase 1. Las que afectan implementación de Reporting deben resolverse antes de Fase 6.

## `RPT-OPEN-001` — Zona temporal del reporting period

**Motivo:** un mes necesita una zona temporal estable y la baseline no la fija.

**Alternativas:** timezone del dispositivo/usuario; UTC; tenant; cliente.

**Evaluación:** dispositivo introduce resultados variables; UTC puede no coincidir con mes civil del negocio; client agrega configuración no aprobada; tenant ofrece simplicidad y consistencia para el MVP.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — timezone explícita tenant-wide para Reporting, fijada históricamente por versión y nunca derivada del dispositivo.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

## `RPT-OPEN-002` — Momento de selección de `MaintenanceRevision`

**Motivo:** el draft puede prepararse con una revisión y existir otra al finalizar; regeneración debe usar revisión vigente.

**Alternativas:** fijar al preparar; fijar al finalizar; congelar manualmente; permitir revisión histórica manual.

**Evaluación:** fijar al preparar puede dejar datos obsoletos; selección histórica arbitraria debilita el significado del informe mensual; fijar al finalizar es coherente con regeneración y actualidad.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — fijar la revisión autoritativa vigente en finalización, con staleness explícito si cambió desde la preparación.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

## `RPT-OPEN-003` — Cambios de fuentes mientras el Report está draft

**Motivo:** mantenimiento, cliente, equipo, Evidence o template pueden cambiar durante edición.

**Alternativas:** refresh automático silencioso; mantener snapshot de preparación; advertir; exigir refresh explícito.

**Evaluación:** refresh silencioso puede cambiar contenido bajo el usuario; mantener datos stale sin aviso produce versiones obsoletas.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — detectar staleness, informar la fuente cambiada y exigir refresh/revisión explícitos antes de finalizar, preservando texto editorial hasta que el usuario revise el impacto.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

## `RPT-OPEN-004` — Inclusión/exclusión manual

**Motivo:** la baseline exige consolidar mantenimientos del período pero no define discrecionalidad del admin.

**Alternativas:** incluir todos; permitir excluir; permitir incluir fuera de período; exigir justificación.

**Evaluación:** inclusión fuera de período rompe la semántica mensual; exclusión sin trazabilidad reduce reproducibilidad.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — candidatos completos por regla; permitir excluir un candidato con razón histórica; no permitir incluir fuera del período/cliente; snapshot conserva selección.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

## `RPT-OPEN-005` — Re-emisión técnica desde el mismo snapshot

**Motivo:** un archivo puede fallar/perderse sin cambio semántico.

**Alternativas:** nueva versión por cada render; mismo version/snapshot; distinguir retry inmediato y reconstrucción posterior.

**Evaluación:** incrementar versión por fallo técnico crea historial falso; re-render histórico debe evitar usar configuración actual.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — misma `ReportVersion` para re-emisión puramente técnica desde mismo snapshot/configuración histórica; cualquier cambio semántico exige versión nueva.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

## `RPT-OPEN-006` — Atomicidad funcional de finalización y éxito documental

**Motivo:** la baseline no define el estado observable ante fallo entre número, snapshot, PDF y DOCX.

**Alternativas:** considerar finalizada al fijar snapshot aunque falte archivo; considerar finalizada cuando PDF exista; exigir PDF+DOCX; permitir versión “parcialmente finalizada”.

**Evaluación:** una versión oficial parcial puede ser ambigua; PDF es canónico, pero DOCX también es salida requerida del MVP; el usuario necesita una frontera clara de éxito.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — desde la perspectiva de negocio, declarar una `ReportVersion` finalizada sólo cuando número aplicable, snapshot inmutable, `ReportDocumentModel` y ambos documentos requeridos hayan quedado asociados coherentemente. Los pasos internos pueden prepararse antes, pero un fallo no debe exponer una versión finalizada parcial. Retries deben ser idempotentes y no crear nueva versión.

Esta propuesta no define transacciones ni orden físico.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

## `RPT-OPEN-007` — Huecos en numeración oficial

**Motivo:** “correlativa” no define garantía gapless ante fallos/cancelaciones.

**Alternativas:** cero huecos; huecos auditables; frontera de oficialidad sólo al éxito.

**Evaluación:** gapless puede imponer requisitos no aprobados; reutilización puede crear ambigüedad.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — no prometer ausencia de huecos; nunca reutilizar un número que haya sido reconocido como asignado/oficial; coordinar la frontera exacta con `RPT-OPEN-006`.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

## `RPT-OPEN-008` — Selección de Evidence

**Motivo:** no está definido si se muestran todas, algunas o selección manual.

**Alternativas:** todas; automática por template; manual; template + manual.

**Evaluación:** incluir todas puede producir documentos innecesariamente extensos; manual sin template puede ser inconsistente; cualquier opción depende del `Effective Evidence set` aprobado.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — template define elegibilidad/presentación y admin selecciona subconjunto concreto entre Evidence efectivas permitidas; snapshot congela selección. Sin límites comerciales inventados.

**Dependencias:** `EVID-OPEN-004/005/006`.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6, después de las resoluciones Evidence necesarias de Fase 5.

## `RPT-OPEN-009` — Reporting online/server-backed y mantenimientos no sincronizados

**Motivo:** el mantenimiento puede estar finalizado localmente pero no disponible remotamente; la baseline no exige Reporting offline.

**Alternativas:** generación offline/local; servidor sólo con datos remotos; preparación parcial con bloqueo hasta sync.

**Evaluación:** generación local consolidada exigiría mecanismos cross-device no aprobados; la fuente remota es la única base consistente compartida.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — Reporting online/server-backed para el MVP; sólo datos confirmados remotamente pueden formar el snapshot; trabajo únicamente local debe sincronizarse antes de incorporarse. No cambia su estado funcional local de finalizado.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

## `RPT-OPEN-010` — Mantenimiento con conflicto pendiente

**Motivo:** un conflicto conocido significa que no existe una única revisión autoritativa aceptada para esa divergencia.

**Alternativas:** incluir remoto; incluir local; advertir y permitir; bloquear hasta resolver.

**Evaluación:** elegir local/remoto unilateralmente reintroduce Last Write Wins.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — mostrar conflicto y bloquear la finalización respecto de ese mantenimiento hasta que exista resolución explícita y revisión resultante autoritativa.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

## `RPT-OPEN-011` — Regeneración sin cambios semánticos

**Motivo:** no se define si puede crearse una nueva versión idéntica.

**Alternativas:** permitir siempre; impedir; requerir razón; usar re-emisión técnica.

**Evaluación:** versiones idénticas agregan ruido y confunden auditoría; la recuperación de archivos ya tiene otra semántica.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — no crear nueva versión si no cambió ningún insumo semántico; utilizar re-emisión para archivos perdidos/fallidos.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

## `RPT-OPEN-012` — Descarte/cancelación de report draft

**Motivo:** la baseline define draft pero no su descarte.

**Alternativas:** no permitir; permitir antes de `v1`; permitir también drafts de regeneración; conservar draft indefinidamente.

**Evaluación:** prohibir descarte fuerza acumulación de trabajo accidental; permitirlo no debe borrar históricos ni refundar IA por inferencia.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — permitir descarte explícito de draft; sin número oficial en primer draft, sin cambios a versiones previas en un draft de regeneración y sin efecto automático sobre créditos IA ya consumidos.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 6.

---

# 72. Tratamiento formal de `DM-OPEN-005`

## Decisión

¿Debe existir exactamente un `Report` lógico por `tenant + client + reporting period`?

## Alternativas

1. único `Report` lógico;
2. varios Reports independientes;
3. un Report principal + Reports extraordinarios.

## Tradeoffs

- **Único:** máxima claridad, una sola numeración lógica mensual, regeneración expresa la evolución; menor flexibilidad para documentos paralelos.
- **Varios:** máxima flexibilidad; alto riesgo de duplicados, números múltiples y confusión de cuál es el mensual principal.
- **Principal + extraordinarios:** extensible, pero añade un concepto no aprobado en MVP.

## Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** exactamente un `Report` lógico por `tenant + client + reporting period`; cambios posteriores se expresan como `ReportVersion`.

## Estado

**`DM-OPEN-005 = ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.**

No se declara resuelta.

---

# 73. Tratamiento formal de `DM-OPEN-006`

## Decisión

¿Qué `ReportTemplate`/configuración se utiliza al regenerar?

## Alternativas

1. configuración histórica previa;
2. configuración vigente;
3. selección explícita;
4. cualquiera de las anteriores con configuración efectiva congelada por versión.

## Tradeoffs

- **Histórica:** continuidad; no incorpora branding nuevo.
- **Vigente:** actualiza presentación; puede introducir cambio silencioso.
- **Elegible:** expresa intención; añade un paso de decisión.
- **Snapshot efectivo:** necesario para histórico, pero no decide por sí solo la selección.

## Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** selección/revisión explícita durante draft de regeneración, partiendo de la configuración previa como candidato para evitar cambios accidentales y permitiendo elegir deliberadamente una configuración vigente tenant-owned; congelar configuración efectiva en la nueva versión.

## Estado

**`DM-OPEN-006 = ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.**

No se declara resuelta.

---

# 74. Tratamiento formal de `DM-OPEN-008`

## Decisión

¿Qué hecho temporal de negocio determina que un mantenimiento pertenece a un reporting period?

## Alternativas principales

1. fecha/hora efectiva de ejecución/finalización técnica;
2. fecha de inicio;
3. primera finalización;
4. fecha de revisión vigente;
5. fecha de mantenimiento explícitamente configurable;
6. fecha de sincronización.

## Tradeoffs

- **Finalización técnica efectiva:** representa trabajo completado y resiste sync tardío, pero requiere semántica temporal explícita.
- **Inicio:** simple, pero puede clasificar trabajos que terminan en otro mes.
- **Primera finalización:** evento funcional claro; debe distinguirse de mera hora de UI/persistencia.
- **Revisión vigente:** correcciones posteriores pueden mover el trabajo de mes; desaconsejada.
- **Fecha configurable:** flexible, pero añade reglas sobre edición/auditoría.
- **Sync:** contradice offline-first como criterio de negocio; desaconsejada.

## Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** utilizar fecha/hora efectiva de finalización técnica del trabajo, independiente de sync/upload y de timestamps técnicos. La corrección posterior no cambia el período por el mero hecho de crear una revisión nueva.

## Estado

**`DM-OPEN-008 = ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.**

No se declara resuelta.

---

# 75. Decisiones previas preservadas

Este documento no reevalúa decisiones ajenas a Reporting. Sus estados quedan:

## 75.1 `DM-OPEN-*`

- `DM-OPEN-001` — obligatoriedad de `EquipmentType`: **ABIERTA**.
- `DM-OPEN-002` — cardinalidad de formularios aplicables: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-003` — equipo sin formulario aplicable: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-004` — borradores simultáneos de formulario: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-005` — unicidad de Report por cliente/período: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-006` — configuración de template en regeneraciones: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-007` — créditos IA insuficientes: **ABIERTA**.
- `DM-OPEN-008` — criterio temporal de inclusión: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

## 75.2 `FORM-OPEN-*`

Permanecen, sin modificar recomendación ni deadline:

- `FORM-OPEN-001`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `FORM-OPEN-002`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `FORM-OPEN-003`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `FORM-OPEN-004`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `FORM-OPEN-005`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `FORM-OPEN-006`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `FORM-OPEN-007`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `FORM-OPEN-008`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

Reporting utiliza siempre la `FormVersion` histórica fijada al mantenimiento.

## 75.3 `EVID-OPEN-*`

Permanecen, sin resolver:

- `EVID-OPEN-001`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `EVID-OPEN-002`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `EVID-OPEN-003`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `EVID-OPEN-004`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `EVID-OPEN-005`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `EVID-OPEN-006`: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

En particular, Reporting queda condicionado a la futura resolución aprobada de:

- vigencia visual de replacement (`EVID-OPEN-004`);
- categoría en replacement (`EVID-OPEN-005`);
- `Effective Evidence set` por revisión (`EVID-OPEN-006`).

## 75.4 Offline/técnicas

- `DO-T03`: **PARCIALMENTE ABIERTO**.
- `DO-T04`: **PROPUESTA PENDIENTE DE APROBACIÓN**.
- `OFF-OPEN-001`: **ABIERTO — pendiente de aprobación**.
- `OFF-OPEN-002`: **ABIERTO — pendiente de aprobación**.
- `DO-075`: **RESUELTA/APROBADA**.

`DO-075` no se reabre.

## 75.5 Otras decisiones relacionadas

- `DO-077` — subconjunto DOCX portable: **PENDIENTE DE APROBACIÓN**, con propuesta conceptual en la sección 36.1; resolver antes de Fase 6.
- `DO-T07` — privacidad/legal: **DIFERIDO**, conforme a la baseline; no se inventa política legal en Reporting.

---

# 76. Gate del documento

## 76.1 Contradicciones bloqueantes

No se detectan contradicciones bloqueantes conocidas entre `01..06`.

Las decisiones abiertas detectadas no bloquean Fase 1, pero las correspondientes a Reporting deben resolverse antes de implementar Reporting en Fase 6, respetando además las dependencias previas que correspondan.

## 76.2 Estado de decisiones `DM-OPEN` relevantes

- `DM-OPEN-005` — Unicidad del Report por cliente/período: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-006` — Template/configuración utilizada en regeneración: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-007` — créditos IA insuficientes: **ABIERTA**; corresponde principalmente a `08-ai-credits-spec.md`.
- `DM-OPEN-008` — Criterio temporal de inclusión en informes: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

La aprobación documental de `07` no resuelve ninguna de estas decisiones.

## 76.3 Estado de `RPT-OPEN-001..012`

Permanecen las 12 decisiones ya registradas:

1. `RPT-OPEN-001` — zona temporal del reporting period;
2. `RPT-OPEN-002` — momento de selección de `MaintenanceRevision`;
3. `RPT-OPEN-003` — cambios de fuentes/staleness durante draft;
4. `RPT-OPEN-004` — inclusión/exclusión manual;
5. `RPT-OPEN-005` — re-emisión técnica desde mismo snapshot;
6. `RPT-OPEN-006` — atomicidad funcional de finalización y éxito documental;
7. `RPT-OPEN-007` — huecos en numeración oficial;
8. `RPT-OPEN-008` — selección de Evidence;
9. `RPT-OPEN-009` — Reporting online/server-backed y mantenimientos no sincronizados;
10. `RPT-OPEN-010` — mantenimiento con conflicto pendiente;
11. `RPT-OPEN-011` — regeneración sin cambios semánticos;
12. `RPT-OPEN-012` — descarte/cancelación de report draft.

Todas permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.

Ninguna bloquea Fase 1. Las correspondientes a Reporting deben resolverse antes de Fase 6, sin alterar las dependencias ni deadlines definidos en sus secciones individuales.

## 76.4 Estado de decisiones previas y dependencias

- `FORM-OPEN-001..008`: **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.
- `EVID-OPEN-001..006`: **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.
- `DO-077` — Subconjunto DOCX portable: **PENDIENTE DE APROBACIÓN**.
- `DO-T03`: **PARCIALMENTE ABIERTO**.
- `DO-T04`: **PROPUESTA PENDIENTE DE APROBACIÓN**.
- `OFF-OPEN-001`: **ABIERTO — pendiente de aprobación**.
- `OFF-OPEN-002`: **ABIERTO — pendiente de aprobación**.
- `DO-075`: **RESUELTA/APROBADA**.
- `DO-T07`: **DIFERIDO**.

`DO-075` no se reabre. La aprobación documental de `07` no aprueba `DO-077`, no resuelve decisiones Form/Evidence/Offline y no modifica `DO-T07`.

## 76.5 Riesgos principales

Se conservan `RPT-RSK-001..025` sin cambios semánticos. Sus tratamientos continúan siendo mitigaciones o dependencias de resolución y no se convierten por esta aprobación en nuevas reglas de producto.

## 76.6 Candidatos a ADR

Se conservan `RPT-ADR-CAND-001..012` únicamente como candidatos.

No se genera ningún ADR.

## 76.7 Estado documental y de Fase 0

**Estado de `07-reporting-engine-spec.md`: APROBADO — especificación conceptual y funcional del Reporting Engine del MVP.**

**Ruta normativa/objetivo:** `docs/product/07-reporting-engine-spec.md`.

**Estado de Fase 0: EN CURSO.**

La aprobación de `07` no cierra Fase 0.

## 76.8 Alcance de la aprobación de `07`

La aprobación de este documento **NO**:

- resuelve `DM-OPEN-*`;
- resuelve `FORM-OPEN-*`;
- resuelve `EVID-OPEN-*`;
- resuelve `RPT-OPEN-*`;
- aprueba `DO-077`;
- autoriza implementación;
- autoriza SQL;
- autoriza migrations;
- autoriza tablas;
- autoriza sequences;
- autoriza RLS ejecutable;
- autoriza generación PDF/DOCX real;
- selecciona librerías PDF/DOCX;
- autoriza Storage;
- autoriza buckets;
- autoriza paths;
- autoriza OpenAI;
- autoriza prompts productivos;
- autoriza créditos IA;
- autoriza React;
- autoriza APIs;
- autoriza Server Actions;
- autoriza jobs/queues;
- autoriza Codex;
- genera ADRs;
- autoriza avanzar automáticamente a `08-ai-credits-spec.md`;
- cierra Fase 0.

Antes de Fase 6 deberán aprobarse las decisiones de Reporting que bloqueen su implementación y consumirse las resoluciones de Form/Evidence que correspondan.
