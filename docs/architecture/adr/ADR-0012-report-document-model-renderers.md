# ADR-0012 — `ReportDocumentModel` y renderizadores PDF/DOCX

> **Ruta normativa:** `docs/architecture/adr/ADR-0012-report-document-model-renderers.md`  
> **Fase:** Fase 0 — Architecture Decision Record  
> **Estado de Fase 0:** **EN CURSO**  
> **Naturaleza:** decisión arquitectónica conceptual sobre modelo documental intermedio y frontera de renderización; **NO constituye implementación, selección de librerías, diseño físico de datos, Storage, runtime de generación ni autorización de implementación DOCX**

**ID: ADR-0012**  
**Title: ReportDocumentModel y renderizadores PDF/DOCX**  
**Status: ACCEPTED**

---

# 1. ID

`ADR-0012`

# 2. Título

`ReportDocumentModel y renderizadores PDF/DOCX`

# 3. Status

`ACCEPTED`

Este ADR ha sido aprobado formalmente como decisión arquitectónica sobre el modelo documental intermedio común y la frontera de renderización del MVP.

El estado `ACCEPTED`:

- aprueba la frontera arquitectónica documentada para contenido semántico y renderización;
- no autoriza implementación;
- no autoriza uso de Codex;
- no selecciona una librería documental;
- no autoriza la implementación del renderer DOCX;
- no resuelve `DO-077`;
- no resuelve ninguna decisión `RPT-OPEN-*`, `EVID-OPEN-*`, `AI-OPEN-*` ni otro `DO-*` / `*-OPEN-*`;
- no inicia Fase 1;
- no cierra Fase 0.

---

# 4. Context

Reporting es una capacidad central del producto. El informe principal del MVP es mensual por cliente y pertenece a una `MaintenanceCompany` concreta.

La baseline aprobada distingue conceptualmente:

- `Report` como identidad lógica del informe;
- `ReportVersion` como generación histórica concreta;
- `ReportSnapshot` como representación inmutable de los datos e insumos históricos utilizados por una versión;
- `ReportTemplate` como configuración tenant-owned de estructura, branding y presentación;
- `ReportDocumentModel` como modelo intermedio común y neutral respecto del formato;
- artefactos documentales derivados, entre ellos el PDF oficial/canónico.

Cada `ReportVersion` finalizada posee su propio `ReportSnapshot`. La primera finalización asigna el número oficial correlativo por `MaintenanceCompany`; las regeneraciones conservan ese número y crean una nueva `ReportVersion`, un nuevo snapshot y nuevos artefactos derivados. Una corrección posterior de Maintenance no modifica retroactivamente una versión de informe ya finalizada.

`ADR-0001` está `ACCEPTED` y exige mantener la generación documental detrás de una frontera interna apropiada, sin contaminar el dominio con contratos de proveedores o librerías concretas.

`ADR-0002` está `ACCEPTED` y exige tenant ownership inequívoco, resolución autoritativa del tenant e integridad cross-tenant. Generar un documento que mezcle contenido de tenants distintos sería una violación de esa decisión, aunque el error ocurriera dentro de una capa de rendering.

`ADR-0009` está `ACCEPTED` y establece que `MaintenanceRevision` representa estados históricos completos e inmutables de un mantenimiento. El renderer documental no puede seleccionar revisiones, redefinir cuál es current ni seguir automáticamente correcciones futuras.

`ADR-0005` está `ACCEPTED` y aporta principios de idempotencia y retry que pueden resultar relevantes para la generación/re-emisión técnica futura, pero el protocolo offline/sync no forma parte del renderer ni se convierte en requisito de esta decisión.

El registro maestro `docs/product/10-architecture-decisions-records.md` clasifica `ADR-0012` como `READY TO DRAFT`: existe baseline suficiente para decidir la arquitectura del modelo documental común sin resolver decisiones funcionales abiertas de Reporting.

Existe, sin embargo, una decisión pendiente:

`DO-077 = PENDIENTE DE APROBACIÓN`

`DO-077` condiciona el subconjunto portable, la aceptación y la autorización de implementación concreta del renderer DOCX. No impide documentar la existencia de una única frontera semántica compartida ni preparar la arquitectura para que un renderer DOCX futuro consuma el mismo `ReportDocumentModel`.

---

# 5. Problem

¿Cómo generar el PDF oficial de una `ReportVersion` sin acoplar las reglas de Reporting a una librería o formato de salida concreto, preservando simultáneamente la posibilidad de producir en el futuro una salida DOCX editable desde la misma semántica cuando `DO-077` autorice su implementación?

La solución debe evitar que:

- el PDF contenga reglas de negocio que no existan fuera del renderer;
- un futuro DOCX necesite reconstruir por separado la semántica del informe;
- cada formato seleccione mantenimientos, revisiones, Evidence o contenido editorial de forma independiente;
- el renderer decida tenant, ownership o autorización;
- una corrección posterior de Maintenance altere retrospectivamente el contenido de una versión histórica;
- el archivo generado sustituya a `ReportSnapshot` como fuente histórica;
- la IA se convierta en renderer o autoridad documental;
- diferencias de layout entre formatos se conviertan en diferencias de significado.

La solución debe ser suficientemente neutral para permitir más de un renderer, pero no debe convertirse en un diseño físico prematuro de interfaces, schemas, clases, plantillas, HTML, Storage o runtime de generación.

---

# 6. Decision

Para el MVP se adopta una arquitectura conceptual de pipeline con **una única representación semántica intermedia**:

`ReportSnapshot / fuentes históricas autorizadas`
→ `ReportDocumentModel`
→ `Renderer`
→ `artefacto de salida`

La decisión central es:

> **La lógica semántica de Reporting construye un único `ReportDocumentModel` agnóstico del formato; los renderizadores consumen ese modelo y se limitan a materializarlo en formatos concretos sin redefinir qué información de negocio pertenece al informe.**

Para el MVP:

- `PDF = formato oficial/canónico del informe finalizado`;
- el renderer PDF debe consumir el mismo `ReportDocumentModel` semántico definido por esta frontera;
- la arquitectura debe permanecer preparada para un futuro `ReportDocumentModel → DOCX renderer`;
- la implementación concreta del renderer DOCX **NO queda autorizada por este ADR** mientras `DO-077` permanezca pendiente;
- DOCX, si posteriormente es autorizado, será un artefacto editable derivado y no se convertirá por ello en fuente de verdad ni formato oficial.

Esta decisión es conceptual. No prescribe clases, interfaces, objetos físicos, módulos concretos ni un mecanismo de serialización.

---

# 7. Pipeline conceptual

La frontera adoptada separa cuatro responsabilidades.

## 7.1 Fuentes históricas autorizadas

Reporting determina, conforme a sus reglas aprobadas y a las decisiones abiertas que deban resolverse en su propio ámbito, qué datos históricos corresponden a una `ReportVersion`.

Esto incluye el `ReportSnapshot` y cualquier configuración histórica aplicable que deba participar en la construcción documental.

El renderer no consulta fuentes actuales para decidir contenido de negocio.

## 7.2 Construcción semántica

Reporting transforma los insumos históricos autorizados en un `ReportDocumentModel` que expresa el documento a nivel semántico.

La construcción semántica decide qué representa el informe, no cómo una librería concreta dibuja cada elemento.

## 7.3 Renderización

Un renderer transforma el `ReportDocumentModel` en un formato de salida concreto.

El renderer puede aplicar adaptaciones propias del formato, siempre que no cambie el significado del modelo ni introduzca reglas de negocio independientes.

## 7.4 Artefacto derivado

El resultado del renderer es un artefacto asociado inequívocamente a la `ReportVersion` correspondiente.

El artefacto no sustituye a:

- `Report`;
- `ReportVersion`;
- `ReportSnapshot`;
- las fuentes históricas congeladas de la versión.

---

# 8. `ReportDocumentModel`

`ReportDocumentModel` es una **representación intermedia semántica y agnóstica del formato de salida**.

Su propósito es expresar todo aquello que un renderer necesita conocer sobre el contenido y estructura lógica del documento, sin incorporar detalles incidentales de una librería PDF, DOCX u otra tecnología concreta.

Conceptualmente puede representar, cuando la baseline y las decisiones de Reporting aplicables lo autoricen:

- metadata del informe;
- identidad de la `ReportVersion`;
- número oficial cuando corresponda;
- título;
- período;
- datos del cliente;
- estructura de secciones;
- headings;
- párrafos;
- listas;
- tablas;
- bloques de datos estructurados;
- referencias a Evidence/imágenes ya seleccionadas legítimamente por Reporting;
- contenido editorial final aprobado;
- firmas o espacios de firma cuando exista una regla aprobada que los requiera;
- intención conceptual de headers y footers;
- intención conceptual de numeración de página;
- elementos de branding autorizados;
- intención de salto de página cuando realmente forme parte de la estructura documental necesaria;
- metadata necesaria para preservar una renderización semánticamente consistente.

Esta enumeración describe capacidades conceptuales. No constituye un schema definitivo.

`ReportDocumentModel` no fija:

- nombres exactos de propiedades;
- interfaces TypeScript;
- clases;
- enums;
- JSON schema;
- estructura física de nodos;
- formato de serialización;
- persistencia obligatoria;
- layout físico.

---

# 9. Semántica vs presentación

La separación entre semántica y presentación es obligatoria.

## 9.1 Responsabilidad semántica

Corresponde a Reporting y a la construcción del `ReportDocumentModel` determinar:

- qué contenido existe;
- qué secciones existen;
- qué dato histórico se representa;
- qué tablas, listas y bloques forman parte del informe;
- qué contenido editorial final fue aprobado;
- qué Evidence forma parte del contenido después de aplicar las reglas de Reporting vigentes;
- qué `ReportVersion` y qué `ReportSnapshot` representa el documento;
- qué estructura lógica debe conservarse independientemente del formato final.

## 9.2 Responsabilidad de presentación/rendering

Corresponde al renderer resolver aspectos físicos propios del formato, por ejemplo:

- layout;
- paginado;
- tipografía concreta;
- medidas físicas;
- drawing;
- materialización visual de tablas;
- embedding físico de imágenes;
- materialización concreta de headers y footers;
- page numbers;
- particularidades del formato de salida.

## 9.3 Frontera

Un renderer no debe decidir:

- qué mantenimiento incluir;
- qué `MaintenanceRevision` representa el informe;
- qué Evidence es válida;
- qué Evidence reemplaza a otra;
- qué cliente o tenant corresponde;
- qué texto editorial debe considerarse aprobado;
- qué número oficial debe utilizarse;
- qué reglas de negocio aplicar.

Las primitivas de una librería documental no deben propagarse hacia el dominio de Reporting como lenguaje de negocio.

---

# 10. Una sola fuente semántica

Debe existir una sola fuente semántica para todos los formatos derivados de una misma versión:

`ReportDocumentModel`

Esto prohíbe como arquitectura base:

- construir PDF mediante una lógica documental específica del formato;
- construir DOCX mediante otra lógica semántica independiente;
- volver a consultar fuentes distintas según el renderer;
- aplicar reglas de selección distintas por formato;
- mantener dos implementaciones independientes de qué información pertenece al informe.

Los renderizadores pueden diferir en cómo materializan una misma intención, pero no en cuál es el contenido funcional de la `ReportVersion`.

---

# 11. `ReportSnapshot` vs `ReportDocumentModel`

`ReportSnapshot` y `ReportDocumentModel` son conceptos distintos y no deben fusionarse.

## 11.1 `ReportSnapshot`

`ReportSnapshot` representa los datos e insumos históricos congelados utilizados por una `ReportVersion`.

Su responsabilidad es preservar la fuente histórica de interpretación de esa versión conforme a la estrategia de Reporting aprobada.

## 11.2 `ReportDocumentModel`

`ReportDocumentModel` representa el documento semántico preparado para ser renderizado.

Es una proyección documental derivada de insumos históricos autorizados, no el sustituto de esos insumos.

## 11.3 Consecuencia

El archivo final no debe ser la única forma de reconstruir qué significaba la versión.

El renderer tampoco debe necesitar consultar datos actuales para completar información que debió quedar resuelta antes de rendering.

Este ADR no decide el schema, persistencia ni serialización de ninguno de los dos conceptos.

---

# 12. Relación con `ReportVersion`

Cada artefacto generado debe correlacionarse inequívocamente con una `ReportVersion` concreta.

Se preservan las reglas aprobadas:

- una versión finalizada es histórica e inmutable;
- la primera finalización produce `v1` conforme a la baseline;
- una regeneración crea una nueva `ReportVersion`;
- el número oficial del `Report` se conserva en regeneraciones;
- cada nueva versión posee su propio `ReportSnapshot`;
- cada nueva versión genera sus propios artefactos derivados;
- una versión anterior no se sobrescribe por regenerar.

La correlación conceptual debe impedir que un artefacto mezcle:

- snapshot de una versión;
- contenido editorial de otra;
- número o metadata pertenecientes a otra;
- Evidence seleccionada para otra versión.

Este ADR no diseña naming, paths ni almacenamiento físico de artefactos.

---

# 13. Determinismo y reproducibilidad semántica

La arquitectura debe favorecer la reproducibilidad semántica.

Dado el mismo contexto histórico relevante, incluyendo conceptualmente:

- la misma `ReportVersion`;
- el mismo `ReportSnapshot`;
- la misma configuración histórica aplicable conforme a las reglas aprobadas;
- el mismo `ReportDocumentModel`;

un renderer debe producir una salida **semánticamente equivalente**.

Esto significa preservar, entre otros aspectos:

- identidad del informe;
- número oficial;
- versión;
- cliente;
- período;
- hechos técnicos;
- contenido editorial final;
- estructura lógica;
- tablas y listas;
- Evidence ya resuelta semánticamente.

No se exige que dos ejecuciones produzcan bytes idénticos. Una librería o runtime futuro puede introducir metadata técnica, timestamps internos, ordenamientos físicos equivalentes u otras diferencias no semánticas.

Este ADR no establece hashing, firma criptográfica ni byte-for-byte reproducibility como requisito.

---

# 14. `ReportTemplate`

`ReportTemplate` permanece como concepto de Reporting tenant-owned.

Puede influir, conforme a las reglas que estén aprobadas, en:

- estructura;
- branding;
- orden;
- estilos conceptuales;
- componentes documentales;
- portada;
- headers/footers;
- tablas;
- presentación de contenido.

La frontera de este ADR exige únicamente que, antes de llegar al renderer, la información necesaria haya sido expresada en un modelo semántico independiente del formato.

Este ADR no decide:

- template language;
- HTML templates;
- JSX;
- editor visual;
- versionado físico de `ReportTemplate`;
- cómo se transforma exactamente un template en `ReportDocumentModel`;
- ninguna decisión `RPT-OPEN-*` relacionada con template, snapshot o finalización.

---

# 15. Evidence e imágenes

`ReportDocumentModel` puede representar la presencia y el contexto documental de Evidence o imágenes **únicamente después de que Reporting haya resuelto legítimamente su selección**.

El renderer recibe contenido ya autorizado semánticamente.

El renderer no debe:

- decidir cuál es el effective Evidence set;
- resolver replacement lineage;
- seleccionar Evidence para un Report;
- reinterpretar una Evidence histórica mediante estado actual;
- reasignar Evidence a otra `MaintenanceRevision`;
- inferir ownership por URL o path.

Cuando el modelo contenga una imagen autorizada, el renderer deberá intentar preservar razonablemente:

- legibilidad;
- proporción/aspect ratio;
- contexto semántico.

Este ADR no fija:

- resolución;
- DPI;
- compresión;
- tamaño máximo;
- thumbnail strategy;
- formato físico;
- descarga;
- signed URLs;
- Storage paths;
- mecanismo de embedding.

Ninguna decisión `EVID-OPEN-*` queda resuelta.

---

# 16. Maintenance history

`ADR-0009 = ACCEPTED` se preserva íntegramente.

El renderer:

- no selecciona `MaintenanceRevision`;
- no decide cuál revisión es current;
- no reconstruye una revisión a partir de datos actuales;
- no sigue automáticamente futuras correcciones;
- no muta contenido histórico por cambios posteriores del mantenimiento.

Reporting debe entregar al `ReportDocumentModel` el contenido histórico correspondiente a la `ReportVersion` y al snapshot aplicables.

Una corrección posterior de Maintenance no modifica el `ReportDocumentModel` histórico de una versión finalizada ni los artefactos oficiales asociados a esa versión. Una futura regeneración pertenece a una nueva `ReportVersion` conforme a la baseline.

Este ADR no resuelve la política de selección de `MaintenanceRevision` de Reporting.

---

# 17. AI

La IA puede asistir a `COMPANY_ADMIN` en redacción dentro de Reporting conforme a la baseline.

La frontera documental exige que:

- AI no sea un renderer;
- AI no produzca directamente el PDF oficial como autoridad documental;
- AI no decida layout físico;
- AI no decida qué snapshot histórico corresponde;
- AI no decida qué Maintenance o Evidence pertenece al informe;
- el texto sugerido por AI sólo entre al documento semántico después del tratamiento humano requerido por la baseline;
- Rendering funcione sin AI.

Una vez aceptado/revisado el contenido editorial correspondiente, el renderer no necesita conocer si el texto tuvo origen humano o fue inicialmente sugerido por AI para decidir su layout.

Este ADR no resuelve `AI-OPEN-*`, no diseña prompts y no selecciona modelos o APIs de IA.

---

# 18. Branding

El `ReportDocumentModel` puede expresar branding semántico/configurable autorizado, por ejemplo:

- nombre de la empresa;
- logo;
- datos corporativos;
- estilos conceptuales necesarios para distinguir jerarquías o intención visual.

El renderer materializa esa intención dentro de las capacidades del formato.

Este ADR no diseña:

- white-label;
- editor de marca;
- tokens CSS;
- sistema de temas;
- catálogo físico de estilos.

White-label permanece fuera del MVP conforme a la baseline vigente.

---

# 19. Headers, footers y numeración de página

El modelo puede declarar intención conceptual de:

- header;
- footer;
- numeración de página;
- datos identificatorios repetidos.

La presencia semántica de esos elementos pertenece al modelo cuando corresponda; su materialización física pertenece al renderer.

No se fijan layouts, posiciones, medidas ni capacidades específicas de un formato.

---

# 20. Tablas y datos estructurados

`ReportDocumentModel` debe ser capaz conceptualmente de representar tablas y otros bloques de datos estructurados requeridos por Reporting técnico.

Debe distinguirse:

- estructura semántica y contenido de la tabla;
- representación visual concreta de esa tabla.

El renderer puede adaptar ancho, paginado, repetición visual de encabezados o distribución física conforme a las capacidades del formato, siempre que preserve el significado de filas, columnas y datos.

Este ADR no diseña widths, CSS, XML, drawing ni otro mecanismo físico.

---

# 21. PDF oficial/canónico

La decisión preserva explícitamente:

`PDF = formato oficial/canónico del informe finalizado`

El renderer PDF debe:

- consumir el `ReportDocumentModel` correspondiente;
- producir un artefacto asociado a una `ReportVersion` concreta;
- preservar la semántica del modelo;
- no consultar fuentes de negocio alternativas para completar o reinterpretar contenido;
- no convertirse en fuente de verdad histórica.

La existencia presente o futura de otros formatos no modifica el carácter oficial/canónico del PDF.

Este ADR no selecciona:

- librería PDF;
- estrategia browser/headless;
- HTML-to-PDF;
- motor CSS;
- tipografías;
- tamaño de página;
- márgenes;
- runtime concreto.

---

# 22. DOCX condicionado por `DO-077`

La arquitectura debe quedar preparada para la frontera:

`ReportDocumentModel → DOCX renderer`

pero:

`DO-077 = PENDIENTE DE APROBACIÓN`

Por tanto, este ADR sólo documenta compatibilidad arquitectónica futura.

No autoriza:

- implementar el renderer DOCX;
- elegir librería DOCX;
- definir el subconjunto portable;
- fijar reglas de compatibilidad concretas;
- exigir paridad pixel-perfect;
- cerrar `DO-077`.

Si DOCX queda formalmente autorizado posteriormente, su objetivo conceptual será producir una versión editable tan compatible como sea razonablemente posible desde el mismo `ReportDocumentModel`, preservando la misma información funcional.

Se aceptan conceptualmente diferencias inevitables de presentación entre PDF y DOCX, por ejemplo en paginado, saltos de línea, ajuste de tablas, distribución de imágenes o métricas tipográficas, siempre que no cambie la semántica del informe.

Un DOCX derivado no será fuente de verdad, no será el formato oficial y una edición externa no modificará automáticamente la `ReportVersion` ni el PDF oficial.

---

# 23. Errores de construcción y rendering

Deben distinguirse conceptualmente dos clases de fallo.

## 23.1 Error de construcción semántica

Ocurre cuando no puede construirse un `ReportDocumentModel` válido desde los datos e insumos autorizados de la versión.

Es un fallo anterior al renderer y no debe ocultarse como problema específico de PDF o DOCX.

## 23.2 Error de renderer

Ocurre cuando el `ReportDocumentModel` es válido pero un renderer concreto no puede producir su artefacto.

Un fallo de un futuro renderer DOCX no debe, por sí mismo, redefinir la validez semántica del modelo ni la capacidad conceptual del renderer PDF. El comportamiento exacto de finalización ante combinaciones de éxito/fallo pertenece a las decisiones de Reporting aún abiertas.

## 23.3 Regla de oficialidad

Una salida parcial, corrupta, fallida o no correlacionada inequívocamente con la `ReportVersion` correspondiente no debe hacerse pasar por un documento oficial válido.

Este ADR no diseña retry policy, state machine, transacciones, rollback ni jobs.

---

# 24. Finalización y atomicidad

Este ADR no resuelve la atomicidad de Reporting.

Sólo establece las siguientes invariantes documentales:

- el artefacto oficial debe corresponder inequívocamente a la `ReportVersion` y al `ReportSnapshot` aplicables;
- nunca debe mezclar contenido de versiones distintas;
- un renderer no asigna el número oficial;
- un renderer no crea por sí mismo una nueva `ReportVersion`;
- un retry técnico no debe interpretarse automáticamente como una regeneración de negocio;
- una salida fallida no debe presentarse como artefacto oficial válido.

Permanecen fuera de esta decisión:

- momento exacto de asignación/persistencia de archivos;
- orden exacto entre número, snapshot y artefactos;
- rollback;
- transacciones;
- jobs;
- queues;
- cualquier `RPT-OPEN-*` relacionado con finalización o re-emisión.

---

# 25. Tenancy y autorización

`ADR-0002 = ACCEPTED` se preserva como restricción transversal.

`Report`, `ReportVersion`, `ReportSnapshot`, `ReportTemplate`, `ReportDocumentModel` cuando se procese/materialice y los artefactos derivados deben mantener un tenant inequívoco y coherente.

El renderer:

- no selecciona tenant;
- no decide membership ni rol;
- no decide client scope;
- no bypassa ownership;
- no convierte un ID, path o URL conocido en autorización;
- no puede mezclar contenido de tenants distintos;
- no obtiene permiso adicional por ejecutarse en un contexto privilegiado.

Los inputs del renderer deben provenir de un estado previamente autorizado y coherente.

Un `service-role` o mecanismo privilegiado futuro no autoriza a mezclar recursos cross-tenant ni a romper invariantes de Reporting.

Este ADR no diseña RLS, policies, claims ni mecanismos concretos de autorización.

---

# 26. Storage

Los artefactos finales pueden almacenarse posteriormente conforme a la arquitectura de dominio e infraestructura aprobada.

La decisión documental sólo exige que:

- cada artefacto conserve correlación con su `ReportVersion`;
- el artefacto conserve el ownership del contexto de Reporting que lo originó;
- un path no sea autoridad de tenancy;
- una URL no sea autorización;
- el renderer no defina access control.

Este ADR no diseña:

- buckets;
- paths;
- naming;
- signed URLs;
- lifecycle;
- retention;
- blob schema;
- persistencia física del `ReportDocumentModel`.

---

# 27. Server-side generation

La generación oficial debe ejecutarse en un contexto server-side controlado conforme a la baseline de seguridad.

El navegador puede iniciar una intención autorizada y presentar resultados, pero no debe convertirse en la autoridad que decide ni produce por sí sola el documento oficial saltando las verificaciones server-side y de datos aplicables.

Esta decisión no fija el runtime concreto de generación y no selecciona:

- Server Actions;
- Route Handlers;
- Edge Functions;
- workers;
- queues;
- cron;
- job systems;
- funciones específicas de plataforma.

---

# 28. Offline implications

Reporting debe operar con estado server-backed conforme a la baseline aprobada.

Este ADR no introduce generación oficial offline ni convierte el renderer en una capacidad de la `LocalReplica`.

La estrategia offline-first de Maintenance puede afectar cuándo determinados datos llegan a estar disponibles para Reporting, pero la selección de datos reportables, los mantenimientos pending sync o los conflictos pendientes pertenecen a decisiones de Reporting/Offline que este ADR no resuelve.

`ADR-0005` puede aportar principios de idempotencia o retry cuando una futura operación de generación/re-emisión lo necesite, pero el renderer no depende del protocolo de sincronización de campo para definir su semántica.

---

# 29. Alternatives

## 29.1 Alternativa A — Generar PDF directamente desde la lógica de Reporting

### Descripción

Reporting construye directamente primitivas del renderer PDF y mezcla selección semántica con layout/formato.

### Ventajas potenciales

- menos conceptos intermedios al inicio;
- camino aparentemente directo hacia el primer PDF.

### Desventajas

- fuerte acoplamiento a una tecnología o formato;
- reglas de negocio mezcladas con primitivas de presentación;
- difícil reutilización;
- un futuro DOCX requeriría duplicar o reextraer la semántica;
- tests de contenido quedarían ligados al renderer;
- reemplazar la tecnología PDF sería más costoso;
- mayor riesgo de divergencia entre formatos.

### Evaluación

**Rechazada como arquitectura base.**

---

## 29.2 Alternativa B — `ReportDocumentModel` común + renderizadores separados

### Descripción

Reporting construye un modelo semántico neutral y cada formato dispone de una frontera de renderer que consume ese mismo modelo.

### Ventajas

- una sola semántica;
- separación clara de responsabilidades;
- menor duplicación;
- mejor testabilidad del contenido;
- renderers reemplazables;
- posibilidad de múltiples formatos;
- Reporting no depende de primitivas PDF;
- permite preparar DOCX sin autorizar todavía su implementación.

### Desventajas

- introduce un modelo intermedio adicional;
- exige disciplina para mantenerlo semántico;
- necesita cubrir las primitivas documentales conceptuales realmente requeridas;
- requiere coordinación evolutiva entre modelo, templates y renderers.

### Evaluación

**Elegida.**

---

## 29.3 Alternativa C — HTML como modelo documental canónico

### Descripción

Utilizar HTML como representación intermedia canónica del documento y derivar uno o más formatos desde él.

### Ventajas potenciales

- ecosistema amplio de rendering;
- familiaridad tecnológica;
- capacidad expresiva de presentación.

### Desventajas

- HTML es principalmente una representación de presentación/markup y puede filtrar detalles de layout hacia el dominio;
- puede acoplar el modelo semántico a capacidades o limitaciones de un motor concreto;
- no necesariamente representa de forma neutral las necesidades de un DOCX editable;
- corre el riesgo de confundir una tecnología de rendering con la semántica documental.

### Evaluación

**No seleccionada como modelo canónico por este ADR.**

HTML podría ser una tecnología interna de rendering futura si una decisión de implementación lo justifica, pero no se adopta aquí como fuente semántica de verdad.

---

## 29.4 Alternativa D — PDF como fuente de verdad y conversión PDF → DOCX

### Descripción

Generar primero el PDF oficial y utilizarlo como entrada para producir una salida DOCX.

### Ventajas potenciales

- reutiliza el artefacto PDF existente;
- reduce aparentemente la necesidad de un segundo origen.

### Desventajas

- pérdida de estructura semántica;
- DOCX editable de peor calidad;
- dependencia del layout físico del PDF;
- difícil preservación de tablas, headings y estructura editable;
- convierte el formato oficial en intermediario técnico para otro formato;
- dificulta mantener compatibilidad razonable con editores de documentos.

### Evaluación

**Rechazada como estrategia base.**

---

## 29.5 Alternativa E — Dos pipelines independientes PDF y DOCX

### Descripción

Cada formato resuelve por separado contenido, estructura y presentación.

### Ventajas potenciales

- libertad total para optimizar cada formato;
- menor necesidad aparente de acordar un modelo común.

### Desventajas

- duplicación de reglas;
- divergencia semántica;
- mantenimiento doble;
- tests duplicados;
- riesgo de informes inconsistentes para la misma versión;
- correcciones de negocio que podrían aplicarse a un formato y no al otro.

### Evaluación

**Rechazada.**

---

# 30. Consequences

## 30.1 Consecuencias positivas

La decisión aporta:

- una sola representación semántica del documento;
- desacoplamiento entre Reporting y librerías de rendering;
- PDF y potencial DOCX coherentes a nivel funcional;
- testabilidad del contenido antes de renderizar;
- menor duplicación de reglas;
- renderers reemplazables;
- menor contaminación del dominio por primitivas PDF;
- posibilidad de evolucionar formatos sin reescribir la semántica;
- frontera clara para degradaciones propias de cada formato;
- mejor trazabilidad entre `ReportVersion`, modelo semántico y artefactos derivados.

## 30.2 Consecuencias negativas

La decisión introduce costes y disciplina adicionales:

- existe un modelo intermedio adicional que debe mantenerse;
- el modelo necesita cubrir suficientes primitivas documentales sin convertirse en un motor de layout físico;
- PDF y DOCX poseen capacidades diferentes y pueden requerir degradación razonable;
- habrá más pruebas de contrato y consistencia entre modelo y renderers;
- `ReportTemplate`, construcción semántica y renderers deberán evolucionar coordinadamente;
- una mala abstracción podría crear un `ReportDocumentModel` demasiado genérico o demasiado acoplado a un formato;
- existe riesgo de convertir el modelo en un pseudo-layout engine si se incorporan medidas, drawing o decisiones físicas que pertenecen al renderer.

---

# 31. Security implications

La implementación futura deberá preservar como mínimo:

- aislamiento tenant durante construcción y rendering;
- inputs del renderer provenientes de estado autorizado;
- renderer sin autoridad para decidir permisos;
- prohibición de mezclar recursos de tenants distintos;
- rechazo de imágenes/archivos obtenidos desde referencias arbitrarias no validadas;
- server-side authority para generación oficial;
- `service-role` restringido y sin capacidad conceptual para romper ownership;
- artefactos finales con ownership coherente con la `ReportVersion`;
- ningún path, URL o identificador conocido como prueba suficiente de autorización;
- contenido raw/markup equivalente, si una implementación futura lo utilizara internamente, sin convertirse en bypass de seguridad o inyección hacia el motor de rendering.

Este ADR no diseña mitigaciones específicas de una librería, sanitización concreta, RLS ejecutable ni Storage policies.

---

# 32. Data implications

La futura implementación debe preservar conceptualmente:

- `ReportSnapshot` y `ReportDocumentModel` como conceptos distintos;
- `ReportDocumentModel` dentro del contexto inequívoco de una `ReportVersion`;
- modelo semántico agnóstico del formato;
- artefactos como derivados del modelo y no como fuente histórica primaria;
- correlación entre cada artefacto y la versión que representa;
- PDF como artefacto oficial/canónico;
- DOCX, si se autoriza, como artefacto editable derivado y no oficial salvo una decisión futura explícita que modifique la baseline;
- conservación del número oficial y ordinal de versión conforme a Reporting;
- ausencia de relectura de datos actuales para reinterpretar una versión finalizada.

Este ADR no define:

- tablas;
- columnas;
- JSON schema;
- blobs;
- hashes;
- foreign keys;
- indexes;
- serialization;
- persistencia física del modelo.

---

# 33. Testing implications

La implementación futura deberá permitir verificar, mediante pruebas apropiadas, al menos las siguientes propiedades conceptuales:

- el mismo `ReportDocumentModel` conserva el mismo contenido semántico al renderizar PDF;
- el renderer no modifica datos de negocio;
- la construcción template/model produce las secciones semánticas esperadas conforme a reglas aprobadas;
- las tablas conservan su estructura y datos semánticos;
- las imágenes referenciadas corresponden al contenido autorizado;
- el PDF producido corresponde a la `ReportVersion` correcta;
- una corrección posterior de Maintenance no altera un documento histórico ya finalizado;
- Tenant A no puede producir un documento que incorpore contenido de Tenant B;
- un fallo de renderer no produce un artefacto presentado falsamente como oficial;
- un futuro renderer DOCX consume el mismo `ReportDocumentModel` si su implementación queda autorizada;
- diferencias de paginado/layout entre formatos no alteran el significado del informe;
- AI no es requisito para construir o renderizar el documento;
- el renderer no selecciona `MaintenanceRevision` ni Evidence;
- un retry técnico no debe convertirse por sí solo en una nueva versión de negocio.

Este ADR no escribe tests ejecutables ni selecciona framework de testing.

---

# 34. Observability implications

La implementación futura debería poder distinguir conceptualmente entre:

- construcción del `ReportDocumentModel`;
- render PDF;
- render DOCX si y cuando esté autorizado;
- fallo de construcción semántica;
- fallo de renderer;
- artefacto generado;
- correlación del artefacto con `ReportVersion`.

No se definen:

- métricas exactas;
- estructura de logs;
- proveedor;
- tracing;
- SLO;
- alert thresholds.

`DO-T05` y `ADR-0016` permanecen diferidos.

---

# 35. Performance implications

La generación documental puede resultar costosa en CPU y memoria dependiendo del renderer, del tamaño del informe y del volumen de recursos embebidos.

Esta observación no fija una estrategia de ejecución.

Este ADR no decide:

- límites;
- timeouts;
- workers;
- queues;
- concurrency;
- batching;
- streaming;
- número máximo de páginas;
- topología de procesamiento.

Esas decisiones pertenecen a implementación/performance posterior y, cuando corresponda, a `ADR-0016` después de resolver su baseline.

---

# 36. Dependencies

## 36.1 Depende de

- baseline documental aprobada `00..10`;
- `ADR-0001 = ACCEPTED`;
- `ADR-0002 = ACCEPTED`;
- `ADR-0009 = ACCEPTED`.

`ADR-0005 = ACCEPTED` se relaciona con esta decisión cuando una futura operación de generación/re-emisión necesite idempotencia o retry, pero no convierte el protocolo offline/sync en parte del renderer.

## 36.2 No depende para su decisión base de resolver

- `DO-077` para definir la existencia de un `ReportDocumentModel` común;
- `RPT-OPEN-*`;
- `EVID-OPEN-*`;
- `AI-OPEN-*`.

Ninguna de esas decisiones es necesaria para establecer que la semántica documental debe ser única y que los renderers no deben duplicar reglas de negocio.

Sin embargo:

> `DO-077` **sí condiciona la autorización, aceptación e implementación concreta del renderer DOCX**.

Este ADR documenta la frontera arquitectónica para DOCX sin cerrar ni superar esa decisión pendiente.

## 36.3 Se relaciona con

- `ADR-0011` — Reporting: versionado, snapshots y finalización;
- `ADR-0013` — IA server-side, provider boundary y minimización de datos.

Ambos permanecen fuera del alcance de este documento y no son resueltos aquí.

---

# 37. References

Referencias normativas y conceptuales:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- `docs/product/06-maintenance-evidence-spec.md`;
- `docs/product/07-reporting-engine-spec.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`;
- `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`;
- `docs/architecture/adr/ADR-0009-maintenance-revision-history.md`.

La inclusión de estas referencias no modifica el estado de ninguna decisión abierta contenida en ellas.

---

# 38. Decisions explicitly not made

Este ADR no decide ni autoriza:

- interfaces TypeScript;
- JSON schema;
- clases;
- enums físicos;
- librerías PDF;
- librerías DOCX;
- HTML como modelo canónico;
- CSS;
- estrategia browser/headless;
- tipografías;
- DPI;
- tamaño físico de página;
- márgenes;
- tablas físicas;
- columnas;
- SQL;
- migrations;
- RLS ejecutable;
- Storage buckets;
- paths;
- signed URLs;
- job queues;
- workers;
- Server Actions;
- Route Handlers;
- Edge Functions;
- retry policy;
- transaction model;
- finalization atomicity;
- schema exacto de `ReportSnapshot`;
- schema exacto de `ReportDocumentModel`;
- selección de Evidence;
- selección de `MaintenanceRevision`;
- prompts de AI;
- template language;
- editor visual;
- white-label;
- autorización de implementación DOCX;
- `DO-077`;
- `RPT-OPEN-*`;
- `EVID-OPEN-*`;
- `AI-OPEN-*`;
- ningún otro `DO-*` / `*-OPEN-*`.

---

# 39. Anti-patterns prohibited by this decision

Quedan prohibidos como arquitectura base:

- lógica de negocio de Reporting embebida únicamente en el renderer PDF;
- pipeline semántico PDF distinto del pipeline semántico DOCX;
- selección de `MaintenanceRevision` dentro del renderer;
- selección o reinterpretación de Evidence dentro del renderer;
- consulta de datos actuales desde el renderer para reconstruir una versión histórica;
- usar PDF como fuente histórica de verdad;
- utilizar PDF como intermediario obligatorio para producir DOCX;
- usar DOCX como fuente canónica;
- modificar una `ReportVersion` porque alguien editó externamente un DOCX;
- permitir que un renderer seleccione tenant o client scope;
- considerar una URL/path de documento como autorización;
- permitir mezcla cross-tenant por ejecutar rendering con privilegios elevados;
- generar formatos distintos desde reglas funcionales duplicadas;
- acoplar `ReportDocumentModel` a primitivas físicas de una librería concreta;
- convertir `ReportDocumentModel` en un motor de layout físico general;
- convertir AI en renderer o autoridad documental;
- presentar una salida parcial/fallida como PDF oficial válido;
- incrementar una versión de Report por un retry técnico del mismo intento lógico;
- resolver silenciosamente `RPT-OPEN-*`, `EVID-OPEN-*`, `AI-OPEN-*` o `DO-077` dentro de la implementación del renderer.

---

# 40. Supersession

`Supersedes: None`

`Superseded by: None`

---

# 41. Gate del ADR

## 41.1 Resultado

- **ADR generado:** `ADR-0012`;
- **Title:** `ReportDocumentModel y renderizadores PDF/DOCX`;
- **Status:** `ACCEPTED`;
- **decisión:** `ReportDocumentModel` común + renderizadores desacoplados;
- **PDF oficial/canónico:** sí;
- **ReportDocumentModel agnóstico de formato:** sí;
- **ReportSnapshot != ReportDocumentModel:** sí;
- **renderer decide negocio:** no;
- **renderer selecciona tenant:** no;
- **renderer selecciona MaintenanceRevision:** no;
- **DOCX architecture-ready:** sí;
- **DOCX implementation authorized:** no;
- **`DO-077` resuelta:** no;
- **PDF/DOCX desde semántica común:** sí conceptualmente;
- **HTML canónico decidido:** no;
- **librería PDF decidida:** no;
- **librería DOCX decidida:** no;
- **RPT-OPEN resueltos:** ninguno;
- **EVID-OPEN resueltos:** ninguno;
- **AI-OPEN resueltos:** ninguno;
- **otros OPEN resueltos:** ninguno;
- **código:** no;
- **SQL:** no;
- **tablas:** no;
- **Storage design:** no;
- **implementación autorizada:** no;
- **otro ADR generado:** no;
- **aprobación:** completada;
- **Estado de Fase 0:** **EN CURSO**.

## 41.2 Alcance del Gate

Este Gate verifica el cierre formal y la aprobación de `ADR-0012` dentro del alcance autorizado.

La aceptación de este ADR no autoriza implementación y no modifica el estado de `DO-077`, `ADR-0011`, `ADR-0013` ni de ninguna otra decisión abierta.
