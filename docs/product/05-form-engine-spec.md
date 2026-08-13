# 05 — Especificación conceptual y funcional del motor de formularios

> **Ruta normativa/objetivo:** `docs/product/05-form-engine-spec.md`  
> **Estado:** **APROBADO — especificación conceptual y funcional del motor de formularios del MVP**  
> **Fase:** Fase 0 — documento derivado  
> **Estado de Fase 0:** **EN CURSO**  
> **Baseline normativa:** `docs/product/01-product-definition.md`  
> **Modelo de dominio aprobado:** `docs/product/02-domain-model.md`  
> **Estrategia de permisos/RLS aprobada:** `docs/product/03-permissions-rls-strategy.md`  
> **Estrategia offline/sync aprobada:** `docs/product/04-offline-sync-strategy.md`  
> **Naturaleza:** contrato funcional y arquitectónico conceptual del motor de formularios; **NO constituye implementación, esquema físico, SQL, RLS ejecutable, schema Dexie, componentes React, APIs ni JSON físico definitivo**

---

# 1. Propósito y alcance

Este documento define la especificación conceptual y funcional del motor de formularios del MVP.

Su objetivo es establecer, antes de cualquier implementación:

- el significado de un formulario lógico y de sus versiones;
- los ciclos de vida de `FormTemplate` y `FormVersion`;
- la inmutabilidad de versiones publicadas;
- los tipos de ítem y de campo soportados;
- la estructura conceptual de una versión;
- las reglas de validación;
- las condiciones simples permitidas;
- las reglas para estructuras compuestas;
- la selección del formulario aplicable a un equipo;
- el momento en que una versión queda fijada a un mantenimiento;
- la relación entre respuestas, revisiones e históricos;
- la interacción con el funcionamiento offline-first;
- la frontera entre campo `image` y `Evidence`;
- los principios UX del constructor;
- las decisiones todavía abiertas que deben resolverse antes de las fases correspondientes.

Este documento debe actuar como **contrato funcional y arquitectónico** para la futura implementación del constructor de formularios, el versionado, la publicación, la selección de formularios y la captura de respuestas durante mantenimientos.

## 1.1 Autoridad

Se aplica el siguiente orden de autoridad:

1. `docs/product/01-product-definition.md`;
2. `docs/product/02-domain-model.md`;
3. `docs/product/03-permissions-rls-strategy.md`;
4. `docs/product/04-offline-sync-strategy.md`;
5. `docs/product/00-master-product-brief.md`;
6. decisiones explícitamente aprobadas posteriormente dentro del Project que no hayan sido sustituidas.

Ante una contradicción real, prevalece la fuente de mayor autoridad y este documento debe corregirse.

## 1.2 Revisión previa de coherencia

No se detectan contradicciones bloqueantes entre `01`, `02`, `03` y `04` que impidan especificar conceptualmente el motor de formularios.

Se preservan como reglas cerradas:

- `FormTemplate` pertenece a un único tenant;
- `FormVersion` pertenece al tenant de su `FormTemplate`;
- una versión publicada es inmutable;
- editar un formulario publicado crea un nuevo draft;
- cada mantenimiento conserva la versión exacta utilizada;
- los campos de versiones diferentes son independientes;
- no existe identidad lógica estable de campo entre versiones en el MVP;
- `COMPANY_ADMIN` administra formularios;
- `TECHNICIAN` consume formularios durante mantenimientos autorizados;
- `COMPANY_ADMIN` **NO** posee ejecución inicial de mantenimiento;
- un `SupportAccessGrant` no genera capacidades nuevas por inferencia;
- el formulario específico de un equipo tiene prioridad absoluta sobre el asociado al tipo;
- los formularios publicados necesarios para trabajo técnico deben estar disponibles offline;
- una nueva publicación no muta una versión publicada antigua;
- un mantenimiento ya iniciado no se migra silenciosamente a una versión posterior.

## 1.3 Fuera del alcance

Este documento **NO define ni autoriza**:

- SQL;
- tablas PostgreSQL;
- columnas;
- claves físicas;
- índices;
- migrations;
- RLS ejecutable;
- funciones PostgreSQL;
- schema Dexie/IndexedDB;
- índices Dexie;
- JSON físico definitivo;
- payloads definitivos;
- componentes React;
- librerías concretas de form builder;
- inicialización de Next.js;
- APIs;
- endpoints;
- Server Actions;
- handlers;
- buckets o paths definitivos de Storage;
- algoritmos concretos de sincronización;
- implementación del documento 06;
- ADRs.

No contiene código ejecutable.

---

# 2. Terminología

## 2.1 `FormTemplate`

Formulario lógico perteneciente a una empresa de mantenimiento.

Representa la identidad estable del formulario a lo largo de su ciclo de vida y puede poseer varias `FormVersion`.

Su estado lógico es:

- activo;
- archivado.

No contiene por sí mismo una definición histórica mutable de campos que pueda reemplazar una versión publicada.

## 2.2 `FormVersion`

Definición concreta y autocontenida de un `FormTemplate` en un momento de su evolución.

Su estado es:

- `draft`;
- `published`.

Una versión publicada es inmutable.

Cada mantenimiento utiliza exactamente una `FormVersion`.

## 2.3 Draft

Versión todavía editable por `COMPANY_ADMIN`.

Puede encontrarse temporalmente incompleta o inválida durante su construcción.

No es consumida como definición operativa publicada por un `TECHNICIAN`.

## 2.4 Published

Versión que superó la validación de publicación y fue publicada explícitamente.

Es inmutable y puede ser utilizada por mantenimientos cuando resulte aplicable.

## 2.5 Active

Estado de un `FormTemplate` que permite que sus versiones publicadas puedan resultar candidatas para nuevos mantenimientos conforme a sus asociaciones.

Activo no significa necesariamente que exista una versión publicada utilizable.

## 2.6 Archived

Estado de un `FormTemplate` que impide utilizarlo para nuevos mantenimientos.

Archivar no elimina:

- versiones;
- respuestas;
- mantenimientos;
- referencias históricas.

## 2.7 Field

Ítem de una `FormVersion` que representa una definición de captura o una definición que participa en la estructura de la captura.

Cuando sea necesario distinguirlo, se utilizará `response-bearing field` para los campos que producen respuesta directa.

## 2.8 Structural item

Ítem cuya función principal es estructurar o presentar el formulario y que no produce una `Response` por sí mismo.

El ejemplo principal del MVP es `section`.

## 2.9 Response-bearing field

Ítem cuya captura produce un valor o contenido conceptualmente representable mediante una `Response`.

Ejemplos:

- texto;
- número;
- select;
- multiselect;
- checkbox;
- image;
- file.

Los componentes complejos requieren tratamiento adicional para representar sus hijos, celdas o instancias.

## 2.10 Condition

Regla simple que depende del valor de un campo fuente de la misma `FormVersion`.

Sólo existen en el MVP:

- `IF field = value -> show field`;
- `IF field = value -> required field`.

La multiplicidad de condiciones del mismo tipo que apuntan al mismo destino permanece abierta mediante `FORM-OPEN-008`; la implementación no puede elegir AND u OR implícitamente.

## 2.11 Validation

Regla que determina si la definición del formulario o una respuesta es coherente con las restricciones publicadas.

Existen conceptualmente dos momentos diferentes:

- validación de definición/publicación;
- validación de captura/finalización.

## 2.12 Equipment-type form

`FormTemplate` aplicable a través del `EquipmentType` asociado a un equipo.

La obligatoriedad de que todo equipo posea un `EquipmentType` permanece abierta mediante `DM-OPEN-001`.

## 2.13 Equipment override form

`FormTemplate` específicamente asociado a un `Equipment`.

Tiene prioridad absoluta sobre cualquier formulario aplicable por `EquipmentType`.

No se combina automáticamente con el formulario del tipo.

## 2.14 Applicable form

Formulario lógico que resulta seleccionado para iniciar un mantenimiento después de aplicar:

- tenant;
- equipo;
- asociación específica del equipo;
- asociación del tipo cuando corresponda;
- estado activo/archivado;
- disponibilidad de una versión publicada;
- reglas de prioridad;
- decisiones de cardinalidad pendientes.

El resultado operativo debe terminar identificando una `FormVersion` publicada concreta.

---

# 3. Responsabilidades de los actores

## 3.1 `COMPANY_ADMIN`

Dentro de su propio tenant, `COMPANY_ADMIN` puede:

- crear `FormTemplate`;
- clonar formularios;
- editar drafts;
- configurar ítems;
- configurar validaciones aprobadas;
- configurar condiciones simples;
- previsualizar drafts;
- publicar;
- archivar.

Administrar formularios **NO** concede a `COMPANY_ADMIN` capacidad para:

- iniciar un mantenimiento nuevo;
- realizar una ejecución inicial;
- finalizar una primera ejecución;
- crear respuestas o evidencias correspondientes a una ejecución inicial.

Las capacidades de corrección de mantenimientos y resolución de conflictos pertenecen a flujos distintos y no amplían la ejecución inicial.

## 3.2 `TECHNICIAN`

`TECHNICIAN` puede, dentro de sus clientes autorizados:

- leer las versiones publicadas necesarias para sus equipos;
- utilizar la versión aplicable al iniciar un mantenimiento;
- completar respuestas;
- utilizar esas definiciones offline cuando hayan sido replicadas conforme a `04`;
- consultar versiones históricas necesarias para interpretar mantenimientos autorizados.

No puede:

- crear `FormTemplate`;
- editar drafts;
- modificar versiones publicadas;
- publicar;
- archivar;
- administrar asociaciones de formularios;
- utilizar preview administrativo para producir mantenimientos.

## 3.3 `SUPER_ADMIN`

`SUPER_ADMIN` no administra formularios tenant como operación normal.

Un `SupportAccessGrant`:

- no lo convierte en `COMPANY_ADMIN`;
- no concede automáticamente CRUD administrativo;
- no concede ejecución inicial;
- sólo permite el acceso excepcional expresamente habilitado por el scope aprobado.

Se mantiene la regla:

> ausencia de permiso aprobado = no se infiere permiso.

---

# 4. Ciclo de vida de `FormTemplate`

## 4.1 Creación

Crear un formulario genera un nuevo `FormTemplate` perteneciente al tenant del `COMPANY_ADMIN` y una definición inicial editable en forma de draft.

El formulario lógico y su draft inicial son conceptos distintos.

## 4.2 Activo

Mientras el `FormTemplate` esté activo:

- puede administrarse según permisos;
- una versión publicada puede resultar aplicable a nuevos mantenimientos;
- puede evolucionar mediante nuevos drafts y publicaciones.

Estar activo no autoriza modificar versiones publicadas.

## 4.3 Archivado

Al archivarse:

- deja de ser candidato para nuevos mantenimientos;
- sus versiones publicadas permanecen;
- sus respuestas históricas permanecen;
- los mantenimientos que lo hayan utilizado permanecen interpretables.

Archivar no equivale a borrar.

Este documento no define una capacidad adicional de restauración/desarchivado que no haya sido aprobada expresamente.

## 4.4 Relación con versiones

Un `FormTemplate` representa continuidad administrativa.

Sus `FormVersion` representan definiciones concretas e históricas.

Por tanto:

- la identidad del template puede permanecer;
- la definición utilizada por mantenimiento siempre pertenece a una versión concreta.

## 4.5 Clonación

La clonación crea otro formulario lógico independiente y se desarrolla en la sección 34.

## 4.6 Histórico

Ningún cambio de estado o nueva publicación del `FormTemplate` puede cambiar retroactivamente la `FormVersion` registrada en un mantenimiento anterior.

---

# 5. Ciclo de vida de `FormVersion`

## 5.1 Flujo inicial

Conceptualmente:

**crear formulario → crear draft inicial → editar/validar → publicar → obtener versión published**

El draft puede modificarse mientras no haya sido publicado.

## 5.2 Edición posterior a una publicación

Si un formulario posee una versión publicada y `COMPANY_ADMIN` quiere modificar su definición:

**formulario publicado → crear nuevo draft → editar draft → publicar → nueva versión published**

La versión previamente publicada:

- no se modifica;
- no se sustituye físicamente;
- no pierde capacidad histórica.

## 5.3 Draft

Un draft:

- es mutable;
- puede estar incompleto durante edición;
- no debe consumirse como versión operativa publicada;
- debe validarse antes de publicar.

## 5.4 Published

Una versión `published`:

- es inmutable;
- es históricamente identificable;
- contiene la definición necesaria para interpretar sus respuestas;
- no vuelve a estado draft.

## 5.5 Nueva versión vigente

Cuando se publica un nuevo draft, esa publicación pasa a ser la definición publicada que deberá considerarse para nuevos usos del `FormTemplate`, sin alterar trabajos ya iniciados ni históricos.

La selección completa continúa subordinada a las asociaciones y a las decisiones abiertas de aplicabilidad.

---

# 6. Inmutabilidad

`published immutable` significa que una versión publicada no puede modificarse funcionalmente in place.

No se permite modificar silenciosamente en una versión publicada:

- labels;
- tipo de campo;
- opciones;
- unidad;
- mínimo;
- máximo;
- obligatoriedad;
- condiciones;
- estructura;
- jerarquía;
- configuración de evidencia;
- configuración funcional de image/file;
- orden;
- títulos de secciones;
- configuración de matrices;
- configuración de grupos repetibles;
- metadata visible que altere la interpretación funcional;
- cualquier otro atributo que modifique cómo debe capturarse o interpretarse una respuesta.

Si se necesita un cambio funcional:

> debe producirse un nuevo draft y posteriormente una nueva `FormVersion` publicada.

La corrección administrativa de un dato de negocio no puede utilizarse como argumento para reescribir una versión published histórica.

---

# 7. Identidad de campos entre versiones

## 7.1 Regla normativa

Los campos de versiones diferentes son independientes.

En el MVP **NO existe stable logical field identity entre versiones**.

No debe introducirse un concepto equivalente a:

`logical_field_id`

que intente afirmar que un campo de v1 y otro de v2 son el mismo campo lógico.

## 7.2 Consecuencia histórica

Una respuesta pertenece al campo exacto de la versión utilizada.

Por tanto, un mantenimiento de v1 debe interpretarse utilizando:

- los campos de v1;
- los labels de v1;
- las opciones de v1;
- las unidades de v1;
- las condiciones de v1.

Nunca utilizando la definición similar de v2.

## 7.3 Reporting

Un informe puede presentar datos históricos de distintas versiones.

No debe asumir que dos campos se corresponden porque:

- tienen el mismo label;
- tienen la misma posición;
- tienen el mismo tipo;
- proceden de una clonación.

Cualquier futura correlación semántica entre versiones deberá ser una capacidad distinta y aprobada, no una identidad implícita del motor MVP.

## 7.4 Comparaciones

Comparar valores de mantenimientos que utilizaron versiones diferentes puede requerir conocimiento del contexto de cada versión.

El motor no debe fabricar una equivalencia estructural automática.

## 7.5 Correcciones

Una corrección de un mantenimiento utiliza la `FormVersion` ya fijada a ese mantenimiento.

No utiliza un campo equivalente de una versión posterior.

## 7.6 Offline

Las versiones locales se conservan como definiciones independientes.

Descargar v2 no convierte ni actualiza los campos de v1.

## 7.7 IA futura sobre informes

Una capacidad futura de IA que utilice históricos deberá recibir contexto suficiente para comprender qué representa cada dato.

No puede suponerse que el mismo label significa el mismo concepto técnico en distintas versiones.

---

# 8. Estructura general de una versión

Una `FormVersion` debe poder representar conceptualmente una estructura ordenada de ítems.

La representación física podrá adoptar posteriormente:

- una lista jerárquica;
- un árbol;
- otra estructura equivalente.

Este documento no fija JSON.

La estructura conceptual debe poder expresar:

- campos simples;
- secciones;
- tablas/matrices;
- grupos repetibles;
- relaciones padre/hijo cuando correspondan;
- orden determinista.

La estructura debe ser autocontenida dentro de la versión publicada.

No se permite que una versión publicada dependa de una definición mutable externa para conocer:

- sus campos;
- sus opciones;
- su orden;
- sus condiciones;
- sus validaciones funcionales.

---

# 9. Clasificación de ítems

## 9.1 Ítems con respuesta

Producen un valor o contenido directo.

Incluyen como mínimo:

- texto corto;
- texto largo;
- entero;
- decimal;
- select;
- multiselect;
- checkbox;
- image;
- file.

## 9.2 Ítems estructurales

Organizan el formulario sin generar respuesta propia.

Incluyen:

- section.

Una sección no produce `Response`.

## 9.3 Ítems compuestos

Contienen estructura interna cuya captura necesita conservar contexto adicional.

Incluyen:

- table/matrix;
- repeatable group.

Un compuesto puede producir un conjunto estructurado de respuestas o subrespuestas, pero no debe modelarse conceptualmente como un string opaco.

## 9.4 Hijos

Cuando un ítem admite hijos:

- esos hijos pertenecen a la misma `FormVersion`;
- su orden es determinista;
- su identidad es específica de esa versión;
- no se reutilizan como definiciones mutables globales.

Los límites exactos de nesting de estructuras compuestas permanecen en `FORM-OPEN-006`.

---

# 10. Campo texto corto

Un campo de texto corto representa una respuesta textual de extensión apropiada para un valor breve.

Debe poseer conceptualmente:

- label;
- valor textual;
- configuración `required`;
- ayuda/descripción visible opcional.

Las validaciones del MVP deben mantenerse simples.

No se introduce:

- regex custom;
- scripting;
- validaciones arbitrarias;
- expresiones personalizadas.

No se fija una longitud máxima funcional de producto en este documento.

Las limitaciones técnicas inevitables se documentarán en implementación cuando corresponda.

---

# 11. Campo texto largo

Un campo de texto largo representa una respuesta textual destinada a contenido descriptivo más extenso.

Debe soportar:

- label;
- valor textual;
- `required`;
- ayuda/descripción opcional.

La diferencia con texto corto es semántica y de experiencia de captura.

No se convierte el campo en:

- editor de documentos;
- rich-text engine;
- sistema de reglas arbitrarias.

No se introduce regex custom.

---

# 12. Entero y decimal

## 12.1 Entero

Representa un valor numérico sin componente fraccionario.

Puede configurar:

- label;
- required;
- unidad;
- mínimo;
- máximo;
- ayuda.

La validación debe rechazar conceptualmente un valor que no sea entero.

## 12.2 Decimal

Representa un valor numérico que puede poseer componente fraccionario.

Puede configurar:

- label;
- required;
- unidad;
- mínimo;
- máximo;
- ayuda.

No se fija aquí precisión física, escala SQL ni representación binaria/decimal concreta.

## 12.3 Mínimo y máximo

Si se configuran:

- mínimo define el menor valor permitido;
- máximo define el mayor valor permitido;
- mínimo no puede ser conceptualmente mayor que máximo.

Estas reglas deben validarse al publicar y durante captura.

## 12.4 Unidad

La unidad es metadata funcional visible necesaria para interpretar el valor.

Una versión publicada conserva su unidad histórica.

Cambiar la unidad requiere una nueva versión.

No se define un catálogo global obligatorio de unidades en este documento.

---

# 13. Select

Un campo `select` representa selección única dentro de un conjunto definido de opciones.

Debe contemplar:

- label;
- conjunto de opciones;
- selección única;
- required;
- ayuda opcional.

## 13.1 Opciones

Las opciones forman parte de la definición de la `FormVersion`.

Una opción debe poseer conceptualmente:

- representación visible;
- un valor/identidad interpretable dentro de esa versión.

No se fija el formato físico de ese valor.

La comparación de condiciones no debe depender exclusivamente de texto visual susceptible de ambigüedad.

## 13.2 Versionado de opciones

Al crear una nueva versión pueden:

- añadirse;
- eliminarse;
- cambiarse;
- reordenarse

opciones dentro del nuevo draft.

Esos cambios no afectan versiones publicadas anteriores.

Una respuesta histórica a una opción de v1 sigue siendo interpretable con las opciones de v1 aunque v2 ya no contenga esa opción.

---

# 14. Multiselect

`multiselect` permite seleccionar varias opciones de un conjunto publicado.

Debe preservar:

- conjunto de opciones perteneciente a la versión;
- respuestas seleccionadas;
- required;
- labels necesarios para histórico.

Si no es required, puede no existir selección.

Si es required, debe existir una selección válida conforme a la definición que finalmente se adopte.

El MVP no introduce:

- pesos;
- scoring;
- fórmulas;
- condiciones complejas sobre subconjuntos.

La utilización de `multiselect` como campo fuente de una condición de igualdad presenta una ambigüedad semántica y se trata en `FORM-OPEN-005`.

---

# 15. Checkbox

`checkbox` es un tipo conceptual independiente con semántica booleana.

Su dominio conceptual de valor incluye:

- `true`;
- `false`.

No debe confundirse con:

- `multiselect`;
- un conjunto de opciones renderizado visualmente mediante varias casillas.

Un `multiselect` puede representarse visualmente con checkboxes en una UI futura, pero sigue siendo `multiselect`.

Un campo `checkbox` individual sigue representando un único valor booleano.

La baseline no define la semántica exacta de `required` para este tipo. En particular, este documento **NO resuelve** si `required` significa:

- exigir una respuesta explícita permitiendo `true` o `false`;
- exigir específicamente `true`;
- o impedir `required` sobre checkbox.

Tampoco debe confundirse `false` con “sin respuesta” por decisión implícita de UI. Un valor inicial visual no debe considerarse automáticamente respuesta explícita mientras `FORM-OPEN-007` permanezca abierta.

La decisión formal se registra en `FORM-OPEN-007 — Semántica de required para checkbox`.

---

# 16. Campo imagen

## 16.1 Naturaleza

El campo `image` es un ítem autónomo del formulario.

Su respuesta principal consiste en imagen o imágenes según la configuración funcional que finalmente sea aprobada.

## 16.2 Diferencia respecto de `Evidence`

Un campo `image`:

- existe como campo del formulario;
- tiene label propio;
- produce una respuesta cuyo contenido principal es imagen.

`Evidence`:

- es una capacidad fotográfica asociable a cualquier respuesta;
- no sustituye el valor principal;
- puede expresar semántica before/after;
- será profundizada en `06-maintenance-evidence-spec.md`.

Por ejemplo, un campo `image` llamado “Placa del equipo” utiliza la fotografía como respuesta principal.

Un campo de texto “Estado del serpentín” puede tener una respuesta textual y además evidencias fotográficas.

Son mecanismos independientes.

## 16.3 Offline

Cuando una imagen se captura offline como respuesta de un campo `image`:

- el contenido debe persistirse localmente antes de depender de la red;
- debe permanecer local mientras no exista confirmación remota válida;
- su sincronización debe ser reintentable e idempotente;
- no debe darse por sincronizada sólo porque se inició un upload.

Estas reglas son coherentes con la política general de archivos de `04`.

## 16.4 Histórico

La respuesta de `image` debe poder seguir interpretándose junto con:

- su campo;
- su versión;
- su mantenimiento;
- su revisión histórica.

## 16.5 Cardinalidad pendiente

La baseline indica que la respuesta puede consistir en una o más imágenes, pero no define la configuración exacta de multiplicidad.

Esto se registra como `FORM-OPEN-003`.

---

# 17. Campo archivo

El campo `file` representa una respuesta cuyo contenido principal es un archivo.

Debe poder conservar conceptualmente:

- vínculo con el campo;
- vínculo con la revisión;
- información necesaria para identificar e interpretar el archivo;
- estado local/remoto cuando aplique.

No debe confundirse con archivos administrativos de órdenes de trabajo, porque las órdenes de trabajo están fuera del MVP.

No se introducen límites funcionales o comerciales propios sobre:

- cantidad;
- tamaño;
- formatos.

Las limitaciones físicas inevitables del navegador, dispositivo, proveedor o infraestructura se documentarán técnicamente durante implementación y no se convertirán silenciosamente en cuotas de producto.

Un archivo capturado offline debe conservarse localmente hasta confirmación remota válida conforme a `04`.

---

# 18. Secciones

Una `section` es un ítem estructural.

Puede proporcionar:

- título;
- descripción opcional;
- agrupación visual/lógica;
- orden.

Una sección:

- no produce una `Response`;
- no debe tratarse como campo de datos;
- no debe utilizarse como fuente de condición;
- no debe requerir respuesta.

Una sección no se convierte automáticamente en:

- página;
- paso de wizard;
- etapa de workflow.

La paginación o navegación por pasos no está aprobada y no se infiere.

---

# 19. Tabla / matriz

## 19.1 Objetivo

El tipo table/matrix debe permitir capturar datos tabulares estructurados sin convertirse en un spreadsheet genérico.

Como mínimo, el concepto debe poder preservar:

- definición de columnas;
- orden de columnas;
- filas o instancias de fila;
- orden de filas;
- valores de celdas;
- tipo/semántica de cada columna o celda según el modelo finalmente aprobado;
- validaciones correspondientes;
- vínculo con la `FormVersion`.

## 19.2 Columnas

Las columnas pertenecen a la definición publicada de la matriz.

Una columna debe poder expresar conceptualmente:

- label;
- orden;
- tipo de dato permitido;
- validaciones aplicables;
- unidad cuando el tipo numérico lo permita.

Las columnas publicadas son inmutables.

## 19.3 Filas

La captura debe ser capaz de identificar inequívocamente filas y su orden.

La baseline no establece todavía si:

- todas las filas se definen previamente en el builder;
- las filas se agregan durante captura;
- se admiten ambos modelos.

Esta diferencia afecta de manera material:

- UX;
- validación;
- offline;
- históricos.

Se registra en `FORM-OPEN-002`.

## 19.4 Celdas

Cada celda debe poder interpretarse a partir de:

- matriz;
- fila;
- columna;
- definición publicada;
- valor.

Una celda no debe depender de una posición visual sin identidad/contexto suficiente.

## 19.5 Tipos de celda

El MVP no debe convertirse en una hoja de cálculo con:

- fórmulas;
- referencias entre celdas;
- cálculo automático arbitrario;
- scripting;
- macros.

El subconjunto exacto de tipos de campo que puede utilizarse como celda queda incluido en `FORM-OPEN-002`.

### Propuesta pendiente

**PROPUESTA PENDIENTE DE APROBACIÓN:** priorizar columnas de tipos simples y escalares, evitando inicialmente estructuras compuestas anidadas dentro de celdas.

Esta propuesta no se considera aprobada mientras `FORM-OPEN-002` permanezca abierta.

## 19.6 Required

Las validaciones required de celdas deben evaluarse de forma coherente con las filas que realmente formen parte de la respuesta.

No se inventa todavía:

- número mínimo de filas;
- número máximo de filas;
- filas automáticas;
- fórmula de completitud.

## 19.7 Históricos

Una matriz publicada debe conservar definición suficiente para reconstruir:

- columnas;
- labels;
- tipos;
- unidades;
- filas capturadas;
- orden;
- valores.

Una nueva versión que cambie la matriz no altera matrices históricas.

---

# 20. Grupo repetible

## 20.1 Naturaleza

Un repeatable group representa un conjunto ordenado de campos hijos que puede instanciarse más de una vez durante la captura.

Ejemplo conceptual:

- grupo “Medición”;
- campos hijos “Punto”, “Valor”, “Observación”;
- varias instancias capturadas durante el mantenimiento.

El ejemplo sólo ilustra el concepto y no impone campos concretos al producto.

## 20.2 Definición

La definición del grupo pertenece a una única `FormVersion`.

Debe preservar:

- sus campos hijos;
- el orden de esos hijos;
- metadata visible;
- validaciones internas.

## 20.3 Instancias

Durante captura pueden existir múltiples instancias.

Cada instancia necesita identidad estable dentro del mantenimiento/revisión para poder:

- editarse localmente;
- ordenarse;
- sincronizarse;
- reconciliarse;
- interpretarse históricamente.

No se fija el formato físico de esa identidad.

## 20.4 Orden

Las instancias capturadas deben mantener orden determinista.

Reordenar una instancia durante captura no puede convertirla en otra instancia distinta.

## 20.5 Validaciones internas

Dentro de cada instancia existente:

- cada campo hijo se valida según su tipo;
- required se evalúa para ese hijo cuando corresponda;
- condiciones internas sólo podrán operar si satisfacen las reglas generales del motor.

## 20.6 Límites

No se establecen máximos funcionales de repeticiones.

La baseline tampoco define una semántica de mínimo de instancias o required del contenedor.

El nesting de compuestos y la semántica avanzada del propio contenedor se mantienen en `FORM-OPEN-006`.

---

# 21. Orden de ítems

Toda `FormVersion` debe poseer orden determinista.

El orden afecta:

- captura;
- preview;
- interpretación histórica;
- reporting cuando se decida mostrar el formulario siguiendo su estructura.

Un draft puede reordenarse.

Una versión published conserva su orden histórico.

Modificar el orden después de publicar exige nueva versión.

El orden debe existir:

- entre ítems de nivel correspondiente;
- dentro de secciones;
- entre campos hijos cuando exista estructura compuesta;
- entre columnas de matrices;
- entre instancias capturadas cuando corresponda.

No se define el mecanismo físico de ordenamiento.

---

# 22. Labels, ayuda y metadata visible

El constructor debe permitir crear formularios comprensibles sin convertirse en sistema de diseño.

El mínimo conceptual incluye, cuando corresponda:

- label visible;
- título;
- descripción/ayuda opcional;
- unidad para números;
- opciones para campos de selección;
- indicación de required;
- metadata funcional necesaria para image/file/compuestos;
- orden.

La metadata visible publicada forma parte de la interpretación histórica cuando afecta al significado del dato.

No se incorporan en el motor:

- themes arbitrarios;
- CSS por campo;
- branding por campo;
- layouts visuales libres;
- HTML custom;
- JavaScript custom.

El branding avanzado pertenece a otras capacidades cuando corresponda, no al núcleo del form engine.

---

# 23. Required

Existen dos fuentes conceptuales de obligatoriedad.

## 23.1 Required estático

El campo está configurado como requerido independientemente de otra respuesta, siempre que el campo esté visible y sea aplicable.

Para `checkbox`, la semántica concreta de `required` permanece abierta en `FORM-OPEN-007`. Hasta resolverla, no debe inferirse que required equivale a `true` ni que `false` equivale a “sin respuesta”.

## 23.2 Required condicional

El campo pasa a ser requerido cuando se cumple una condición aprobada:

`IF field = value -> required field`

La multiplicidad de condiciones `required` que apuntan al mismo destino permanece abierta en `FORM-OPEN-008`; no existe AND u OR implícito aprobado.

## 23.3 Precedencia

Conceptualmente:

- required estático establece obligatoriedad base;
- required condicional puede agregar obligatoriedad cuando su condición se cumple;
- una condición no convierte un campo estáticamente required en opcional;
- un campo oculto no bloquea finalización por required mientras permanezca oculto.

Por tanto, la visibilidad efectiva se evalúa antes de utilizar required como bloqueo de finalización.

Esta precedencia general no resuelve la semántica específica de `required` para checkbox ni la multiplicidad de condiciones por destino.

---

# 24. Condición `show`

La única forma aprobada es:

`IF field = value -> show field`

## 24.1 Componentes

Toda condición debe identificar conceptualmente:

- campo fuente;
- valor esperado;
- campo destino.

Fuente y destino deben pertenecer a la misma `FormVersion`.

## 24.2 Evaluación

Cuando la igualdad se cumple:

- el campo destino se muestra.

Cuando no se cumple:

- el campo destino permanece oculto por esa regla.

No se introduce una expresión arbitraria de visibilidad.

## 24.3 Restricciones

No existen:

- AND;
- OR;
- NOT;
- expresiones anidadas;
- scripts;
- funciones custom;
- comparaciones entre dos campos;
- fórmulas.

## 24.4 Multiplicidad por destino

La baseline no define qué ocurre si más de una condición `show` apunta al mismo campo destino.

Mientras `FORM-OPEN-008` permanezca abierta:

- la implementación **NO** puede combinar silenciosamente esas condiciones mediante OR;
- la implementación **NO** puede combinarlas silenciosamente mediante AND;
- la implementación **NO** puede introducir una expresión compuesta implícita.

La recomendación pendiente prioriza como máximo una condición `show` por destino, pero no está aprobada.

## 24.5 Ítems inválidos

Una `section` no puede utilizarse como fuente de valor porque no produce respuesta.

Las reglas exactas de qué tipos pueden actuar como fuente de igualdad se desarrollan en `FORM-OPEN-005`.

---

# 25. Condición `required`

La única forma aprobada es:

`IF field = value -> required field`

## 25.1 Componentes

Debe identificar:

- campo fuente;
- valor esperado;
- campo destino.

Los campos pertenecen a la misma versión.

## 25.2 Evaluación

Si la igualdad se cumple y el campo destino está visible:

- el destino se considera required.

Si no se cumple:

- la condición no añade obligatoriedad.

La obligatoriedad estática, si existe, permanece.

## 25.3 Visibilidad

Una condición required no debe convertir en bloqueante un campo que esté oculto.

La relación entre visibilidad y required se desarrolla en sección 30.

## 25.4 Multiplicidad por destino

La baseline no define qué ocurre si varias condiciones `required` apuntan al mismo destino.

Mientras `FORM-OPEN-008` permanezca abierta:

- no existe OR implícito aprobado;
- no existe AND implícito aprobado;
- no puede resolverse mediante orden de reglas u otra prioridad inventada.

La recomendación pendiente prioriza como máximo una condición condicional `required` por destino, pero no está aprobada.

La semántica de required sobre un destino `checkbox` continúa adicionalmente sujeta a `FORM-OPEN-007`.

---

# 26. Operadores permitidos

En el MVP existe únicamente igualdad simple.

No se introducen:

- `>`;
- `<`;
- `>=`;
- `<=`;
- contains;
- starts-with;
- regex;
- NOT;
- BETWEEN;
- fórmulas;
- expresiones matemáticas;
- expresiones arbitrarias.

## 26.1 Significado de igualdad

La comparación debe utilizar la semántica del tipo del campo fuente.

Ejemplos conceptuales:

- checkbox → valor booleano;
- entero → número entero;
- decimal → valor decimal;
- select → opción de esa versión.

No debe depender de coerciones ambiguas como convertir indiscriminadamente todos los valores a texto.

## 26.2 Multiselect y compuestos

Para `multiselect`, `image`, `file`, matrices y grupos repetibles, el significado de `field = value` no está completamente definido por la baseline.

Introducir `contains` para multiselect violaría el conjunto de operadores aprobado.

La política de campos fuente comparables se registra como `FORM-OPEN-005`.

---

# 27. Dependencias entre campos

Antes de publicar una versión debe validarse que las condiciones forman una red coherente de dependencias.

## 27.1 Referencia existente

Todo campo fuente y destino debe existir en la misma versión.

Una condición no puede referenciar un campo:

- eliminado del draft;
- perteneciente a otra versión;
- perteneciente a otro template.

## 27.2 Tipo de fuente válido

El campo fuente debe poseer una semántica de igualdad soportada.

Una sección no es válida.

Otros tipos dependen de `FORM-OPEN-005`.

## 27.3 Destino válido

El destino debe ser un ítem al que la acción `show` o `required` tenga significado.

No debe utilizarse un ítem estructural como si tuviera respuesta requerida.

## 27.4 Condición posible

La condición no debe utilizar un valor esperado imposible según la definición publicada.

Ejemplos conceptuales:

- opción que no existe en un select;
- valor no booleano para checkbox;
- valor incompatible con integer;
- referencia a campo inexistente.

## 27.5 Integridad durante edición

Si el administrador cambia o elimina el campo fuente o una opción utilizada por una condición:

- el draft puede quedar temporalmente inválido;
- la UI debe indicar la dependencia afectada;
- la publicación debe bloquearse mientras continúe inválida.

No se modifica silenciosamente una condición para que “parezca” válida.

## 27.6 Multiplicidad de dependencias hacia un destino

La red puede contener un mismo campo fuente controlando distintos destinos.

También puede contener cadenas de dependencia entre campos siempre que permanezcan acíclicas.

Sin embargo, mientras `FORM-OPEN-008` siga abierta, la implementación no debe asumir qué semántica corresponde cuando varias condiciones del mismo tipo convergen sobre un único destino.

En particular, no puede convertir esa convergencia en AND u OR implícito.

---

# 28. Ciclos de condiciones

Las dependencias circulares que hagan indeterminada o autorreferencial la evaluación deben impedirse.

Ejemplo conceptual inválido:

- A controla visibilidad de B;
- B controla visibilidad de A.

También son inválidos ciclos más largos.

El builder debe detectar ciclos antes de publicación.

No se fija aquí:

- algoritmo;
- estructura de grafo física;
- librería.

La regla funcional es:

> una `FormVersion` no puede publicarse con un grafo de dependencias condicionales circular.

Una autorreferencia directa también es inválida.

Las cadenas acíclicas de dependencia no constituyen por sí mismas AND/OR. La existencia de múltiples aristas del mismo tipo hacia un mismo destino plantea una semántica diferente y permanece abierta mediante `FORM-OPEN-008`.

---

# 29. Campos ocultos y respuestas

Puede ocurrir:

1. un campo está visible;
2. el técnico captura una respuesta;
3. cambia el campo fuente;
4. la condición deja de cumplirse;
5. el campo destino queda oculto.

La baseline no define si la respuesta previamente capturada:

- debe borrarse;
- debe conservarse;
- debe conservarse pero ignorarse;
- debe restaurarse si el campo vuelve a mostrarse.

No debe inventarse esa política silenciosamente.

## `FORM-OPEN-001` — Tratamiento de respuesta al ocultarse un campo

**Motivo:** afecta pérdida de datos, UX, validación, histórico y reporting.

**Alternativas:**

1. limpiar inmediatamente la respuesta al ocultarse;
2. conservarla y seguir considerándola parte efectiva de la respuesta;
3. conservarla como valor dormido mientras el campo está oculto y excluirla de la validación/resultado efectivo;
4. conservar temporalmente durante edición y eliminarla al finalizar si continúa oculta.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — conservar el valor durante la captura como dato dormido para evitar pérdida accidental, no utilizarlo para required ni para resultado funcional mientras el campo permanezca oculto y definir antes de Fase 4 si debe persistir o descartarse al finalizar.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 4; necesariamente antes de implementar captura/finalización en Fase 5.

---

# 30. Required condicional y visibilidad

La regla obligatoria es:

> un campo oculto por una condición no debe impedir la finalización por required mientras permanezca oculto.

La evaluación conceptual es:

1. determinar visibilidad;
2. determinar required estático/condicional;
3. validar únicamente la obligatoriedad aplicable a campos visibles.

## 30.1 Campo vuelve a mostrarse

Si la condición vuelve a cumplirse:

- el campo vuelve a formar parte de la validación;
- required vuelve a aplicarse;
- el tratamiento de un valor capturado anteriormente depende de `FORM-OPEN-001`.

## 30.2 No bypass

No debe permitirse utilizar cambios de visibilidad para dejar un formulario finalizado en un estado internamente incoherente.

La semántica exacta de respuesta oculta debe estar resuelta antes de implementación.

Para checkbox, la evaluación de required deberá además respetar la decisión futura de `FORM-OPEN-007`.

---

# 31. Validación durante construcción

Un draft puede estar temporalmente incompleto.

El builder debe permitir trabajar sobre estados intermedios sin obligar a que cada operación de edición produzca una definición publicable.

## 31.1 Errores bloqueantes para publicación

Son errores que impedirían interpretar o ejecutar coherentemente el formulario.

Como mínimo:

- referencia condicional inexistente;
- condición con valor incompatible;
- ciclo;
- configuración inválida de tipo;
- min/max incoherente;
- select/multiselect con definición inválida de opciones;
- compuesto estructuralmente inconsistente;
- identificación/orden estructural incoherente;
- configuración required sin semántica válida;
- configuración que pretenda asumir una semántica de `required` para checkbox no aprobada mientras `FORM-OPEN-007` continúe abierta;
- multiplicidad de condiciones hacia un mismo destino que dependa de AND/OR no aprobado mientras `FORM-OPEN-008` continúe abierta.

Mientras las decisiones `FORM-OPEN-007/008` permanezcan abiertas, el diseño de implementación no puede cerrar esos casos silenciosamente. La especificación de Fase 4 debe incorporar primero sus resoluciones aprobadas.

## 31.2 Advertencias no bloqueantes

Pueden existir sólo cuando ayuden al administrador sin inventar requisitos.

Ejemplos potenciales:

- label poco descriptivo;
- formulario sin descripción;
- estructura inusualmente extensa.

No deben convertirse en decenas de reglas subjetivas que impidan publicar un formulario válido.

## 31.3 Draft incompleto

Guardar trabajo administrativo en draft no equivale a publicarlo.

Un draft inválido puede seguir existiendo mientras se identifica claramente que no puede publicarse.

---

# 32. Validación de publicación

La publicación debe ser una acción explícita.

Antes de publicar debe comprobarse conceptualmente:

- estructura interpretable;
- orden válido;
- campos configurados coherentemente;
- tipos válidos;
- required válido conforme a las decisiones aprobadas para cada tipo;
- semántica de checkbox compatible con la futura resolución de `FORM-OPEN-007`;
- unidades/min/max coherentes;
- opciones válidas;
- condiciones con fuentes/destinos válidos;
- valores de condición compatibles;
- ausencia de ciclos;
- multiplicidad de condiciones por destino compatible con la futura resolución de `FORM-OPEN-008`;
- configuración de matrices válida;
- configuración de grupos repetibles válida;
- configuración de image/file válida;
- configuración de Evidence referenciada de forma coherente con la frontera del documento 06 cuando corresponda.

Si existen errores bloqueantes:

> la publicación debe rechazarse.

No se publica parcialmente una definición estructuralmente inconsistente.

No se permite que la implementación “resuelva” varias condiciones convergentes seleccionando AND u OR de manera implícita.

No se permite que la implementación trate `false` como ausencia de respuesta de checkbox por conveniencia técnica mientras `FORM-OPEN-007` no esté resuelta.

Este documento no establece como requisito que un formulario contenga una cantidad mínima determinada de campos; no debe inventarse esa restricción sin aprobación.

---

# 33. Previsualización

`COMPANY_ADMIN` puede previsualizar un draft.

La preview debe utilizar las mismas reglas funcionales de la captura real en lo necesario para comprobar:

- orden;
- labels;
- tipos;
- opciones;
- visibilidad;
- condiciones;
- required;
- min/max;
- comportamiento de estructuras compuestas en el alcance aprobado.

## 33.1 Naturaleza no operativa

Preview:

- no crea `MaintenanceRecord`;
- no crea `MaintenanceRevision`;
- no crea respuestas históricas;
- no consume una ejecución;
- no concede capacidad de ejecución inicial;
- no cambia permisos del actor.

## 33.2 Simulación

Los valores introducidos en preview son datos temporales de simulación.

No deben confundirse con datos técnicos registrados.

---

# 34. Clonación

Clonar crea:

- un nuevo `FormTemplate`;
- un nuevo draft independiente;
- una copia conceptual de la definición fuente seleccionada.

El nuevo formulario:

- pertenece al mismo tenant autorizado;
- no comparte mutable state con el original;
- posee sus propios ítems de versión;
- no adquiere identidad lógica de campos compartida.

Aunque la copia visual sea idéntica, los campos del nuevo draft son conceptualmente independientes.

Las versiones published del formulario original permanecen intactas.

Si existen varias versiones candidatas para clonar, la operación debe identificar de forma clara qué versión concreta sirve como fuente; no debe combinar definiciones de varias versiones silenciosamente.

---

# 35. Archivado

Archivar un `FormTemplate` produce estos efectos:

- deja de ser aplicable a nuevos mantenimientos;
- no elimina el template;
- no elimina drafts o versiones históricas por inferencia;
- no elimina versiones publicadas;
- no elimina asociaciones históricas necesarias;
- no modifica mantenimientos existentes;
- no modifica respuestas;
- no modifica informes ya generados.

Una versión utilizada por mantenimiento debe permanecer interpretable aunque su `FormTemplate` esté archivado.

Archivar no equivale a borrado lógico de históricos.

---

# 36. Selección de formulario aplicable

La regla cerrada de prioridad es:

**equipment override > equipment type form**

No se permite fusionar automáticamente ambos formularios.

## 36.1 Información necesaria

Para determinar una definición aplicable conceptualmente se necesita conocer:

- tenant del equipo;
- equipo;
- cliente del equipo;
- asociación específica del equipo, si existe;
- `EquipmentType`, si existe;
- asociación del tipo, si existe;
- estado activo/archivado de los templates;
- existencia de versión published utilizable;
- cardinalidad aprobada en `DM-OPEN-002`.

## 36.2 Algoritmo conceptual base

Sin resolver `DM-OPEN-002/003`:

1. validar que el equipo pertenece al tenant/contexto correcto;
2. determinar si existe un override de equipo aplicable;
3. si existe un override válido, éste tiene prioridad absoluta;
4. si no existe, evaluar la asociación del `EquipmentType` cuando exista;
5. determinar la `FormVersion` published utilizable del template resultante;
6. si no puede obtenerse una definición unívoca, aplicar la política que se apruebe en `DM-OPEN-002/003`;
7. al iniciar el mantenimiento, fijar la versión elegida conforme a sección 43.

El paso no puede confiar en IDs arbitrarios aportados por frontend para cruzar tenants.

---

# 37. `DM-OPEN-002` — Cardinalidad de formularios aplicables

## 37.1 Pregunta

La baseline define:

- posible formulario por `EquipmentType`;
- posible plantilla específica por `Equipment`;
- prioridad absoluta del override.

No define completamente cuántas asociaciones activas pueden coexistir.

## 37.2 EquipmentType con múltiples formularios

Si un tipo pudiera tener varios formularios activos aplicables simultáneamente, sería necesario introducir una segunda regla como:

- selección manual;
- prioridad;
- categoría de mantenimiento;
- orden;
- combinación.

Ninguna de esas reglas está aprobada.

Permitir múltiples candidatos sin regla adicional produciría ambigüedad.

## 37.3 Equipment con múltiples overrides

Si un equipo pudiera poseer más de un override aplicable simultáneamente, tampoco existiría criterio aprobado para escoger.

La frase normativa “una plantilla específica” es compatible con una interpretación simple de cero o una asociación aplicable, pero la decisión se mantiene abierta conforme al dominio aprobado.

## 37.4 Alternativas

### Alternativa A — cero o uno por nivel

- cada `Equipment` tiene como máximo un override aplicable;
- cada `EquipmentType` tiene como máximo un `FormTemplate` aplicable;
- override gana al tipo.

Ventajas:

- selección determinista;
- UX simple;
- menor complejidad offline;
- sin selección manual;
- sin reglas nuevas de prioridad.

### Alternativa B — varios por nivel con selección manual

Requeriría que `TECHNICIAN` elija.

Introduce una decisión adicional y mayor riesgo de selección incorrecta.

### Alternativa C — varios por nivel con reglas de prioridad

Requeriría diseñar criterios adicionales no existentes en la baseline.

### Alternativa D — combinar varios formularios

Contradice la simplicidad buscada y convertiría el motor en un sistema de composición/workflow no aprobado.

## 37.5 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN**

Adoptar en el MVP:

- como máximo un `FormTemplate` activo aplicable por `EquipmentType`;
- como máximo un override activo aplicable por `Equipment`;
- el override tiene prioridad absoluta;
- no hay selección manual;
- no hay composición de templates.

Las asociaciones históricas o sustituidas pueden conservarse según el futuro modelo físico, pero sólo una asociación puede resultar vigente/aplicable por nivel.

## 37.6 Estado

**DM-OPEN-002: ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN.**

**Bloquea Fase 1:** no.

**Debe resolverse antes de:** implementación del motor en Fase 4.

---

# 38. `DM-OPEN-003` — Sin formulario aplicable

Puede ocurrir que un técnico intente iniciar mantenimiento y:

- no exista override;
- el equipo no tenga tipo;
- el tipo no tenga formulario;
- el template esté archivado;
- el template no tenga versión publicada utilizable.

## 38.1 Alternativa A — bloquear inicio

El mantenimiento no puede iniciarse hasta que exista una definición publicada aplicable.

Ventajas:

- todos los mantenimientos preservan una versión exacta;
- evita registros estructuralmente distintos sin definición;
- evita formularios “vacíos” implícitos;
- mantiene captura offline predecible.

Desventaja:

- una mala configuración administrativa puede impedir una ejecución de campo.

## 38.2 Alternativa B — mantenimiento vacío/genérico

Implicaría crear una definición implícita o permitir mantenimiento sin `FormVersion`.

Esto entraría en tensión con la regla de que cada mantenimiento conserva la versión exacta utilizada y agregaría una modalidad no aprobada.

## 38.3 Alternativa C — selección manual

Exigiría mostrar templates al técnico y concederle una decisión de aplicabilidad no presente en la baseline.

También podría exponer formularios tenant-wide innecesarios.

## 38.4 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN**

Bloquear el inicio de un nuevo mantenimiento cuando no pueda determinarse una `FormVersion` published aplicable de manera unívoca.

La UI debería explicar que falta configuración de formulario, pero no inventar un formulario genérico.

## 38.5 Estado

**DM-OPEN-003: ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN.**

**Bloquea Fase 1:** no.

**Debe resolverse antes de:** Fase 4 y necesariamente antes de implementar ejecución de mantenimiento en Fase 5.

---

# 39. `DM-OPEN-004` — Drafts simultáneos

## 39.1 Alternativa A — un único draft por `FormTemplate`

Ventajas:

- modelo mental simple;
- UX clara;
- evita ramas paralelas;
- publicación predecible;
- menos conflictos administrativos;
- menor complejidad de preview y versionado.

Desventaja:

- no permite trabajar sobre dos propuestas paralelas.

## 39.2 Alternativa B — múltiples drafts paralelos

Requeriría resolver:

- nombres/identidades de ramas;
- cuál se publica;
- qué ocurre con los otros drafts;
- comparación/merge;
- conflictos de edición;
- UX adicional.

Esto aproxima el motor a un sistema de branching de definiciones que no está requerido por el MVP.

## 39.3 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN**

Permitir como máximo **un draft editable simultáneo por `FormTemplate`**.

Una vez publicado, ese draft deja de ser editable como draft y una nueva edición futura crea el siguiente draft.

## 39.4 Estado

**DM-OPEN-004: ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN.**

**Bloquea Fase 1:** no.

**Debe resolverse antes de:** Fase 4.

---

# 40. Asociaciones con `EquipmentType`

Un `FormTemplate` puede asociarse conceptualmente a un `EquipmentType` del mismo tenant.

La asociación:

- no convierte el tipo en obligatorio;
- no modifica `DM-OPEN-001`;
- no puede conectar recursos de tenants distintos;
- determina aplicabilidad sólo para nuevos mantenimientos conforme a las reglas vigentes.

## 40.1 `DM-OPEN-001`

Permanece sin decidir si cada equipo debe poseer un tipo.

Por tanto, son conceptualmente posibles equipos para los cuales no exista `EquipmentType`, hasta que la decisión sea aprobada.

El motor no debe inventar un tipo ficticio ni asignarlo automáticamente.

**Estado:** **ABIERTA**.

## 40.2 Template y versión

La asociación conceptual es con el formulario lógico.

Al iniciar un mantenimiento se debe resolver una `FormVersion` published concreta de ese template.

Un draft no se convierte en definición operativa por estar asociado el template a un tipo.

## 40.3 Cambios

Cambiar la asociación del tipo afecta futuras selecciones.

No modifica la `FormVersion` fijada en mantenimientos ya iniciados.

---

# 41. Override por `Equipment`

Un `Equipment` puede poseer una plantilla específica.

## 41.1 Prioridad

Si existe un override aplicable:

> tiene prioridad absoluta sobre el formulario del tipo.

No se combinan.

## 41.2 Tenant

El equipo y el `FormTemplate` asociado deben pertenecer al mismo tenant.

Una referencia cross-tenant es inválida.

## 41.3 Coherencia

La asociación se interpreta en el contexto real del equipo y su cliente.

Conocer el ID de un formulario no habilita su asociación si pertenece a otro tenant.

## 41.4 Versionado

El override determina el `FormTemplate` candidato para un nuevo mantenimiento.

La `FormVersion` concreta se fija al iniciar el mantenimiento.

Cambiar posteriormente el override:

- no cambia mantenimientos existentes;
- no repunta históricos hacia el nuevo template;
- no reinterpreta respuestas previas.

---

# 42. `FormVersion` retenida por `MaintenanceRecord`

Cada mantenimiento debe conservar exactamente la versión utilizada.

La relación debe permitir reconstruir históricamente:

- campos;
- labels;
- ayudas funcionales relevantes;
- tipos;
- opciones;
- unidades;
- mínimos/máximos;
- estructura;
- orden;
- condiciones;
- configuración de compuestos;
- configuración de image/file;
- frontera/configuración de Evidence aplicable;
- respuestas.

Una nueva publicación no modifica esa relación.

El mantenimiento no guarda simplemente “el formulario actual”.

Guarda el contexto de una versión concreta e inmutable.

---

# 43. Inicio de mantenimiento y versión elegida

## 43.1 Momento conceptual

La `FormVersion` queda fijada **al crearse/iniciarse la intención de mantenimiento**, antes de que las respuestas puedan depender de esa definición.

Conceptualmente:

1. el `TECHNICIAN` inicia un mantenimiento autorizado;
2. se determina el formulario aplicable;
3. se determina una `FormVersion` published concreta;
4. la intención local de mantenimiento conserva esa versión;
5. las respuestas se capturan contra sus campos.

La fijación forma parte del nacimiento del mantenimiento, no de su finalización.

Este pinning no constituye una nueva decisión abierta: está respaldado por la estrategia offline aprobada, que establece que un mantenimiento ya creado conserva la versión exacta con la que fue iniciado y no se migra silenciosamente por una actualización de formularios.

## 43.2 Razón

Si la versión se eligiera al finalizar:

- una publicación intermedia podría cambiar la estructura;
- respuestas ya capturadas podrían no corresponder al nuevo formulario;
- offline sería indeterminado;
- el histórico perdería reproducibilidad.

## 43.3 Trabajo local-first

En offline, esa versión debe estar disponible en `LocalReplica`.

La intención de mantenimiento y la referencia a su versión deben persistirse localmente de forma durable conforme a `04`.

## 43.4 No repinning

Una vez iniciado:

- una nueva publicación no cambia la versión;
- una sincronización no sustituye la versión;
- reabrir el mantenimiento no elige nuevamente;
- una corrección posterior sigue interpretando el mantenimiento con la misma versión.

## 43.5 Falta de versión

Si no puede determinarse una versión aplicable, el comportamiento depende de `DM-OPEN-003`.

---

# 44. Correcciones de mantenimiento

Una corrección de un mantenimiento finalizado crea una nueva `MaintenanceRevision`.

## 44.1 Formulario utilizado

La corrección debe interpretar las respuestas utilizando la misma `FormVersion` fijada en el `MaintenanceRecord`.

No debe migrarse automáticamente al formulario vigente.

## 44.2 Campos editables

La regla de producto que permite modificar todos los campos en una corrección se interpreta como:

> todos los campos aplicables de la `FormVersion` original del mantenimiento.

No significa introducir automáticamente campos publicados después.

## 44.3 Histórico

La revisión anterior permanece inmutable.

La nueva revisión representa el estado corregido conforme a la misma definición histórica.

## 44.4 Versión nueva existente

Si v2 fue publicada después de un mantenimiento creado con v1:

- el mantenimiento continúa siendo v1;
- una corrección utiliza campos de v1;
- campos nuevos de v2 no se incorporan automáticamente;
- campos eliminados de v2 siguen existiendo para interpretar v1.

## 44.5 Nuevos campos en correcciones

El MVP no posee una regla aprobada para “actualizar” un mantenimiento histórico a una nueva `FormVersion`.

Debido a que:

- `MaintenanceRecord` conserva una versión exacta;
- los campos entre versiones son independientes;

permitir nuevos campos de otra versión requeriría una nueva decisión de producto sobre migración/reinterpretación.

No se infiere esa capacidad en este documento.

---

# 45. Offline

El form engine debe integrarse con `04-offline-sync-strategy.md`.

## 45.1 Versiones descargadas

`TECHNICIAN` debe disponer localmente de:

- versiones published aplicables a sus clientes/equipos autorizados;
- versiones históricas necesarias para interpretar mantenimientos accesibles;
- metadata suficiente para determinar aplicabilidad según las reglas aprobadas.

## 45.2 Drafts administrativos

Los drafts de administración no son necesarios para la operación offline del técnico.

No deben descargarse indiscriminadamente al técnico.

## 45.3 Inmutabilidad local

Una copia local de una versión published sigue representando una definición inmutable.

El sync:

- no convierte un draft local en published;
- no edita una versión antigua;
- incorpora una nueva publicación como otra `FormVersion`.

## 45.4 Coexistencia

Puede coexistir:

- v1 por históricos o trabajo iniciado;
- v2 como nueva definición aplicable.

No debe eliminarse v1 mientras exista dependencia histórica/local.

## 45.5 Autorización

El hecho de que una versión exista en `LocalReplica` no prueba autorización remota vigente.

La sincronización vuelve a revalidar:

- identidad;
- membership;
- alcance;
- estado comercial;
- ownership;
- demás reglas aplicables.

---

# 46. Cambios de formulario mientras el técnico está offline

Escenario:

1. técnico sincroniza y dispone de v1;
2. queda offline;
3. `COMPANY_ADMIN` publica v2;
4. el técnico todavía sólo conoce v1;
5. intenta iniciar un mantenimiento offline.

La baseline exige trabajo offline real y prohíbe mutar v1, pero no define de forma completamente explícita qué debe ocurrir cuando una versión más reciente fue publicada remotamente **antes** del inicio local pero el dispositivo todavía no podía conocerla.

No debe inventarse que todo trabajo local con v1 es automáticamente inválido.

Tampoco debe declararse automáticamente que el servidor debe aceptarlo sin una política aprobada.

## `FORM-OPEN-004` — Inicio offline con versión publicada desactualizada

**Motivo:** determinar si una nueva publicación desconocida por el dispositivo invalida una nueva intención iniciada offline con la última versión que la réplica conocía como aplicable.

**Alternativas:**

1. rechazar al sincronizar cualquier mantenimiento iniciado después de existir una publicación remota más reciente;
2. aceptar la versión local si era la última publicada/aplicable conocida durante una autorización offline vigente;
3. aceptar sólo dentro de una ventana o regla adicional;
4. impedir todo inicio offline si no puede probarse que el catálogo de formularios está actualizado, lo que debilitaría significativamente el offline-first.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — una publicación nueva, por sí sola, no debería invalidar retroactivamente un mantenimiento iniciado legítimamente offline con la última `FormVersion` published/aplicable conocida por una réplica autorizada y dentro de la vigencia offline. La sincronización seguiría revalidando tenant, permisos, ownership y demás causas de rechazo.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5; Fase 4 debe dejar preparado el versionado sin imponer una política contraria.

---

# 47. Respuestas

`Response` representa conceptualmente la respuesta correspondiente a un campo concreto de la `FormVersion` utilizada por un mantenimiento.

Debe conservar suficiente información para establecer inequívocamente:

- `MaintenanceRecord`;
- `MaintenanceRevision` o estado de captura correspondiente;
- campo de la versión;
- valor;
- contexto de compuesto cuando corresponda;
- evidencias asociadas cuando existan.

## 47.1 Tipado conceptual

El contenido depende del tipo:

- texto → valor textual;
- integer → valor entero;
- decimal → valor decimal;
- select → una opción publicada;
- multiselect → conjunto de opciones publicadas;
- checkbox → valor booleano cuando exista respuesta conforme a la futura resolución de `FORM-OPEN-007`;
- image → referencia/contenido de imagen según persistencia;
- file → referencia/contenido de archivo;
- compuestos → estructura interpretada mediante sus componentes.

No se fija representación JSON.

## 47.2 Histórico

Una `Response` finalizada se interpreta en el contexto de su `MaintenanceRevision`.

Una corrección produce una nueva revisión sin reescribir la anterior.

## 47.3 Campo exacto

Una respuesta nunca debe reasignarse automáticamente a un campo de otra versión porque comparta label o posición.

---

# 48. Respuestas a estructuras repetibles

## 48.1 Grupo repetible

Cada instancia capturada debe poseer un contexto estable dentro del mantenimiento/revisión.

Ese contexto permite distinguir:

- primera instancia;
- segunda instancia;
- etc.

sin depender únicamente de la posición actual.

La posición continúa existiendo para orden visual.

Identidad y orden son conceptos diferentes.

## 48.2 Matrices

Cada fila capturada debe poder distinguirse de las demás.

Cada celda debe poder relacionarse conceptualmente con:

- instancia/fila;
- columna;
- definición publicada;
- valor.

## 48.3 Offline

Identidades de instancias y filas deben ser suficientemente estables para:

- persistir localmente;
- reabrir;
- reordenar;
- sincronizar;
- reintentar;
- preservar históricos.

No se fija formato ni algoritmo de IDs.

## 48.4 Versiones

Estas identidades pertenecen a la captura de un mantenimiento.

No crean identidad lógica de campos entre versiones distintas.

---

# 49. Evidencia asociada a respuestas

Este documento define sólo la frontera conceptual.

Cualquier campo susceptible de respuesta puede habilitar `Evidence` conforme a la baseline.

`Evidence`:

- pertenece a una respuesta concreta;
- es distinta de la respuesta principal;
- puede configurarse conceptualmente como:
  - sin fotos;
  - before;
  - after;
  - before + after;
- puede ser opcional o required;
- puede capturarse desde cámara o galería;
- debe preservar histórico;
- no se elimina de una revisión finalizada.

Una nueva evidencia puede reemplazar visualmente una anterior en una corrección sin borrar la evidencia original.

La especificación completa de:

- semántica before/after;
- multiplicidad;
- reemplazos;
- UX;
- persistencia;
- validación detallada

corresponde a `06-maintenance-evidence-spec.md`.

Este documento no la duplica ni la anticipa.

---

# 50. Validación para finalización

Las reglas publicadas deben permitir determinar localmente si la captura puede finalizar.

Como mínimo deben evaluarse:

- required estáticos visibles;
- required condicionales visibles;
- semántica de required para checkbox conforme a la futura resolución de `FORM-OPEN-007`;
- distinción correcta entre `false` y ausencia de respuesta de checkbox si así lo determina esa resolución;
- valores de tipo correcto;
- mínimos/máximos numéricos;
- selección de opciones pertenecientes a la versión;
- estructura válida de matrices;
- estructura válida de grupos repetibles;
- archivos/imágenes required según las reglas aprobadas;
- requerimientos de Evidence cuando correspondan, delegando sus detalles a documento 06;
- ausencia de estados inválidos derivados de condiciones;
- evaluación de condiciones sin introducir AND/OR implícitos; la multiplicidad por destino debe ajustarse a la futura resolución de `FORM-OPEN-008`.

## 50.1 Finalización local

Cuando un `TECHNICIAN` autorizado cumple las validaciones y finaliza:

- el mantenimiento queda finalizado localmente;
- no necesita confirmación remota inmediata;
- el estado de sync puede seguir pendiente.

No debe utilizarse la falta de red como causa para convertir funcionalmente el mantenimiento en draft.

## 50.2 Sincronización

La aceptación local no elimina:

- revalidación remota;
- RLS;
- verificación de ownership;
- detección de conflicto;
- confirmación de uploads.

Finalización y sincronización continúan siendo estados independientes.

---

# 51. Compatibilidad histórica

Una `FormVersion` published debe ser autosuficiente para interpretar sus respuestas históricas aunque posteriormente:

- se publique v2, v3 o posteriores;
- se archive el `FormTemplate`;
- se cambie la asociación del `EquipmentType`;
- se cambie el override del `Equipment`;
- se cambie el tipo del equipo;
- se editen datos maestros del equipo;
- se reorganice la configuración administrativa.

Debe conservar al menos la definición funcional necesaria para reconstruir:

- campos;
- labels relevantes;
- opciones;
- estructura;
- unidades;
- reglas;
- orden;
- condiciones;
- configuraciones compuestas.

La interpretación histórica no debe depender del “formulario actual”.

---

# 52. UX del constructor

La UX debe priorizar simplicidad.

## 52.1 Principios

- acciones previsibles;
- una separación clara entre formulario lógico y versión;
- claridad sobre si se está editando un draft;
- claridad sobre cuál es la versión published;
- publicación explícita;
- preview accesible;
- advertencia de que published es inmutable;
- errores de publicación accionables;
- dependencias de condiciones visibles;
- ordenamiento comprensible;
- mínima exposición de conceptos técnicos.

## 52.2 No convertir en IDE

El administrador no debe enfrentarse a:

- JSON;
- scripts;
- expresiones;
- IDs técnicos;
- SQL;
- lógica AND/OR arbitraria;
- diagramas de workflow;
- fórmulas.

## 52.3 Edición

Las acciones de edición afectan el draft.

Nunca debe dar la impresión de que cambiar el constructor está modificando una versión ya utilizada en mantenimientos.

## 52.4 Publicación

Antes de confirmar una publicación, la UI debe comunicar que:

- la versión resultante será inmutable;
- cambios posteriores crearán otra versión;
- mantenimientos existentes conservarán su versión.

## 52.5 Aplicabilidad

La configuración de asociación debe presentar de forma clara la prioridad:

> override de equipo > formulario del tipo.

No debe ocultarse una ambigüedad de `DM-OPEN-002` detrás de selección técnica implícita.

---

# 53. Testing futuro obligatorio

La implementación futura debe incluir categorías de pruebas como mínimo para:

## 53.1 Lifecycle de `FormTemplate`

- creación;
- estado activo;
- archivado;
- histórico preservado.

## 53.2 Lifecycle de `FormVersion`

- draft editable;
- publicación;
- published immutable;
- creación de nuevo draft;
- nueva publicación.

## 53.3 Inmutabilidad

Intentos de modificar published deben ser rechazados en las fronteras autoritativas correspondientes.

## 53.4 Clonación

- nuevo template;
- draft independiente;
- campos independientes;
- original intacto.

## 53.5 Tipos de campo

Pruebas para:

- short text;
- long text;
- integer;
- decimal;
- select;
- multiselect;
- checkbox;
- image;
- file;
- section;
- matrix;
- repeatable group.

## 53.6 Validaciones

- required;
- required condicional;
- min/max;
- integer vs decimal;
- opciones válidas;
- configuraciones inválidas;
- checkbox `true`/`false`/ausencia conforme a la resolución de `FORM-OPEN-007`;
- valor inicial de UI de checkbox que no debe convertirse en respuesta explícita salvo que la resolución lo permita.

## 53.7 Condiciones

- show;
- required;
- referencia inexistente;
- opción inexistente;
- fuente incompatible;
- ciclo directo;
- ciclo indirecto;
- campo oculto y required;
- un campo fuente controlando múltiples destinos;
- cadenas acíclicas de dependencias;
- multiplicidad de condiciones `show` sobre el mismo destino conforme a `FORM-OPEN-008`;
- multiplicidad de condiciones `required` sobre el mismo destino conforme a `FORM-OPEN-008`;
- ausencia de AND/OR implícito.

## 53.8 Matrices

- definición válida;
- filas/celdas;
- orden;
- validación;
- histórico;
- comportamiento aprobado en `FORM-OPEN-002`.

## 53.9 Grupos repetibles

- múltiples instancias;
- identidad estable;
- orden;
- campos internos;
- validación;
- offline;
- comportamiento aprobado en `FORM-OPEN-006`.

## 53.10 Applicable form

- override válido;
- prioridad sobre tipo;
- fallback al tipo;
- template archivado;
- formulario sin versión published;
- cardinalidad aprobada;
- equipo sin formulario.

## 53.11 Pinning

- versión elegida al inicio;
- publicación posterior;
- mantenimiento permanece en versión original;
- corrección utiliza versión original;
- sync no repinea.

## 53.12 Offline

- versión applicable descargada;
- históricos retenidos;
- v1 y v2 coexistiendo;
- mantenimiento iniciado offline;
- sync posterior;
- política aprobada de `FORM-OPEN-004`;
- no mutación local de published.

## 53.13 Históricos

- opciones antiguas;
- campos eliminados en versión posterior;
- labels anteriores;
- unidades anteriores;
- archivo de template;
- cambio de asociación.

## 53.14 Correcciones

- nueva `MaintenanceRevision`;
- revisión previa intacta;
- mismo `FormVersion`;
- no migración automática.

## 53.15 Seguridad y tenant isolation

Pruebas negativas para impedir:

- leer template de otro tenant;
- modificar draft de otro tenant;
- asociar template cross-tenant;
- usar `FormVersion` de otro tenant;
- técnico administrando plantillas;
- `COMPANY_ADMIN` utilizando preview como ejecución;
- `COMPANY_ADMIN` iniciando mantenimiento;
- `SUPER_ADMIN` obteniendo administración por grant no suficiente.

---

# 54. Anti-patrones prohibidos

Queda expresamente prohibido:

- editar una `FormVersion` published in place;
- reutilizar identidad lógica de field entre versiones como requisito del MVP;
- introducir `logical_field_id` estable entre versiones;
- migrar respuestas históricas automáticamente a una versión nueva;
- depender del label como identidad de un field;
- asumir equivalencia de campos por posición;
- modificar opciones de una versión published;
- utilizar el formulario actual para interpretar un mantenimiento histórico;
- eliminar una versión published;
- eliminar una versión utilizada por un mantenimiento;
- hacer que archive borre históricos;
- convertir archive en borrado destructivo;
- condiciones arbitrarias;
- JavaScript custom en formularios;
- scripts de usuario;
- AND/OR complejos;
- AND/OR implícitos cuando múltiples condiciones apuntan al mismo destino;
- resolver silenciosamente múltiples `show` convergentes mediante OR;
- resolver silenciosamente múltiples `show` convergentes mediante AND;
- resolver silenciosamente múltiples `required` convergentes mediante OR;
- resolver silenciosamente múltiples `required` convergentes mediante AND;
- NOT o fórmulas no aprobadas;
- permitir ciclos;
- ignorar referencias condicionales rotas al publicar;
- tratar `false` de checkbox como “no respondido” sin una decisión aprobada;
- tratar un checkbox required como “debe ser true” sin una decisión aprobada;
- utilizar un valor inicial de UI como respuesta explícita de checkbox sin semántica aprobada;
- descargar drafts administrativos al técnico sin necesidad;
- convertir un draft local en published mediante sync;
- modificar una copia local published como mecanismo de actualización;
- permitir que `COMPANY_ADMIN` ejecute mantenimiento mediante preview;
- ampliar permisos de `COMPANY_ADMIN` por ser administrador de formularios;
- inferir operaciones nuevas para `SUPER_ADMIN` por un `SupportAccessGrant`;
- convertir Form Engine en workflow engine;
- convertir secciones en etapas de proceso por inferencia;
- convertir tabla/matriz en spreadsheet genérico;
- introducir fórmulas de celdas;
- combinar automáticamente formulario de equipo y formulario de tipo;
- seleccionar arbitrariamente uno entre varios formularios candidatos;
- repinear un mantenimiento a la última versión al sincronizar;
- utilizar una versión nueva para una corrección histórica;
- borrar una versión local histórica al descargar una nueva;
- usar datos cross-tenant para resolver aplicabilidad.

---

# 55. Riesgos

## `FORM-RSK-001` — Versionado inconsistente

**Riesgo:** modificar published o no separar claramente draft/publicación produce históricos inestables.

**Tratamiento conceptual:** inmutabilidad estricta y nuevas versiones para cambios funcionales.

## `FORM-RSK-002` — Histórico ilegible

**Riesgo:** conservar respuestas sin su definición exacta impide interpretar mantenimientos antiguos.

**Tratamiento:** `MaintenanceRecord` conserva `FormVersion` exacta y la versión published es autosuficiente.

## `FORM-RSK-003` — Condiciones circulares

**Riesgo:** una red circular hace indeterminada la visibilidad/obligatoriedad.

**Tratamiento:** ciclos bloquean publicación.

## `FORM-RSK-004` — Builder demasiado complejo

**Riesgo:** introducir scripts, branching, workflows o demasiadas reglas hace que el constructor sea difícil de usar y mantener.

**Tratamiento:** tipos delimitados, igualdad simple y UX deliberadamente limitada.

## `FORM-RSK-005` — Campo eliminado rompe respuestas

**Riesgo:** utilizar la definición vigente para interpretar históricos haría desaparecer campos antiguos.

**Tratamiento:** campos y versiones históricas inmutables.

## `FORM-RSK-006` — Opciones modificadas rompen históricos

**Riesgo:** cambiar las opciones de un select published puede alterar el significado de respuestas existentes.

**Tratamiento:** opciones versionadas con la `FormVersion`.

## `FORM-RSK-007` — Múltiples formularios aplicables ambiguos

**Riesgo:** más de un candidato sin regla produce selección no determinista.

**Tratamiento:** resolver `DM-OPEN-002`.

## `FORM-RSK-008` — Falta de formulario aplicable

**Riesgo:** iniciar un mantenimiento sin definición clara puede romper `FormVersion` pinning y validación.

**Tratamiento:** resolver `DM-OPEN-003`.

## `FORM-RSK-009` — Draft simultáneo conflictivo

**Riesgo:** múltiples drafts convierten una evolución simple en branching/merge implícito.

**Tratamiento:** resolver `DM-OPEN-004`.

## `FORM-RSK-010` — Offline utiliza versión incorrecta

**Riesgo:** publicaciones remotas durante desconexión pueden producir una diferencia entre catálogo local y remoto.

**Tratamiento:** versionado inmutable, pinning y resolución de `FORM-OPEN-004`.

## `FORM-RSK-011` — Estructuras repetibles difíciles de reconciliar

**Riesgo:** depender sólo de índices/posición puede mezclar filas o instancias tras ediciones offline.

**Tratamiento:** identidad estable de captura y orden como conceptos separados.

## `FORM-RSK-012` — Confusión entre image y Evidence

**Riesgo:** almacenar ambas capacidades como un único concepto rompe la semántica de respuestas y before/after.

**Tratamiento:** frontera conceptual explícita y documento 06 separado.

## `FORM-RSK-013` — Respuesta oculta inconsistente

**Riesgo:** conservar o borrar valores ocultos sin regla clara puede causar pérdida de datos o informes con valores no visibles.

**Tratamiento:** resolver `FORM-OPEN-001`.

## `FORM-RSK-014` — Igualdad ambigua

**Riesgo:** aplicar `=` indiscriminadamente a multiselect, archivos o compuestos introduce operadores implícitos.

**Tratamiento:** resolver `FORM-OPEN-005`.

## `FORM-RSK-015` — Matriz se convierte en spreadsheet

**Riesgo:** fórmulas, tipos arbitrarios o nesting ilimitado expanden el alcance de forma excesiva.

**Tratamiento:** resolver modelo mínimo de `FORM-OPEN-002` y mantener prohibidas fórmulas.

## `FORM-RSK-016` — Nesting de compuestos explota complejidad

**Riesgo:** repeatables dentro de repeatables y matrices anidadas complican builder, validación, offline y reporting.

**Tratamiento:** resolver `FORM-OPEN-006`.

## `FORM-RSK-017` — Corrección migra accidentalmente a formulario nuevo

**Riesgo:** utilizar la versión vigente durante corrección mezclaría campos independientes y destruiría reproducibilidad.

**Tratamiento:** corrección siempre interpreta la `FormVersion` fijada al mantenimiento.

## `FORM-RSK-018` — Asociación modificada altera históricos

**Riesgo:** recalcular el formulario de un mantenimiento histórico desde Equipment/EquipmentType actual cambiaría su interpretación.

**Tratamiento:** pinning permanente de `FormVersion`.

## `FORM-RSK-019` — Checkbox required ambiguo

**Riesgo:** confundir `false` con ausencia de respuesta o interpretar required como obligación de `true` puede alterar registros técnicos y bloquear/permitir finalizaciones incorrectamente.

**Tratamiento:** resolver `FORM-OPEN-007`; hasta entonces no inferir semántica ni usar valores iniciales de UI como respuesta explícita.

## `FORM-RSK-020` — AND/OR implícito por convergencia de condiciones

**Riesgo:** varias reglas `show` o `required` hacia un mismo destino pueden introducir lógica OR/AND no aprobada y producir resultados distintos según la implementación.

**Tratamiento:** resolver `FORM-OPEN-008`; prohibir cualquier combinación implícita hasta su aprobación.

---

# 56. Decisiones candidatas a ADR

Este documento no genera ADRs.

Las siguientes decisiones son candidatas a documentación arquitectónica posterior.

## `FORM-ADR-CAND-001` — Modelo `FormTemplate` / `FormVersion`

Documentar la separación entre:

- identidad lógica;
- draft;
- published;
- histórico.

## `FORM-ADR-CAND-002` — Published immutable

Documentar cómo la arquitectura garantiza que una publicación no se modifica in place.

## `FORM-ADR-CAND-003` — Fields independientes por versión

Documentar la ausencia intencional de stable logical field identity y sus consecuencias para persistencia/reporting.

## `FORM-ADR-CAND-004` — Representación de estructuras compuestas

Documentar la futura representación de:

- matrices;
- repeatables;
- instancias;
- filas;
- celdas.

Sólo después de aprobar las decisiones abiertas correspondientes.

## `FORM-ADR-CAND-005` — Evaluación de condiciones

Documentar:

- igualdad tipada;
- validación de dependencias;
- detección de ciclos;
- evaluación determinista;
- política aprobada de multiplicidad por destino.

## `FORM-ADR-CAND-006` — Selección de applicable form

Documentar la selección:

- override;
- tipo;
- cardinalidad aprobada;
- ausencia de formulario.

Sólo tras cerrar `DM-OPEN-002/003`.

## `FORM-ADR-CAND-007` — Pinning de `FormVersion`

Documentar que el mantenimiento fija la versión al iniciarse y no se migra por publicaciones posteriores.

## `FORM-ADR-CAND-008` — Identidad de instancias de captura

Evaluar si la estrategia de identidad estable para filas/repeatables requiere ADR por su impacto en offline, históricos y reconciliación.

---

# 57. Decisiones abiertas

## 57.1 `DM-OPEN-001` — Obligatoriedad de `EquipmentType`

**Motivo:** la baseline no exige expresamente que todo equipo posea tipo.

**Estado:** **ABIERTA**.

**Propuesta nueva en este documento:** ninguna.

**Bloquea Fase 1:** no.

**Resolver antes de:** implementación relevante de Fase 3.

## 57.2 `DM-OPEN-002` — Cardinalidad de formularios aplicables

**Motivo:** prioridad override > tipo está cerrada, pero cantidad de asociaciones vigentes no.

**Alternativas:** uno por nivel; varios con selección; varios con prioridad; composición.

**Recomendación:** máximo uno aplicable por nivel y prioridad absoluta del override.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 4.

## 57.3 `DM-OPEN-003` — Equipo sin formulario aplicable

**Motivo:** no está definido si puede iniciarse mantenimiento sin versión.

**Alternativas:** bloquear; genérico/vacío; selección manual.

**Recomendación:** bloquear inicio hasta existir una published aplicable.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 4 y necesariamente antes de Fase 5.

## 57.4 `DM-OPEN-004` — Drafts simultáneos

**Motivo:** no está fijado si un template puede tener varios drafts.

**Alternativas:** uno; múltiples ramas.

**Recomendación:** un único draft simultáneo.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 4.

## 57.5 Decisiones `DM-OPEN-005..008`

Permanecen sin modificación:

- `DM-OPEN-005` — unicidad de informe por cliente/período;
- `DM-OPEN-006` — plantilla utilizada al regenerar informe;
- `DM-OPEN-007` — créditos IA insuficientes;
- `DM-OPEN-008` — criterio temporal de inclusión en informes.

No se reevalúan ni resuelven en este documento.

## 57.6 `DO-T03`

**Tema:** invalidación técnica efectiva online.

**Estado:** **PARCIALMENTE ABIERTO** conforme a documentos previos.

Este documento no lo resuelve.

## 57.7 `DO-T04`

**Tema:** protección concreta de persistencia local.

**Estado:** **PROPUESTA PENDIENTE DE APROBACIÓN** conforme a `04`.

Este documento no lo resuelve ni modifica.

## 57.8 `OFF-OPEN-001`

**Tema:** destino de trabajo pendiente después de una revocación.

Estado: ABIERTO — pendiente de aprobación

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5.

Este documento no lo resuelve.

## 57.9 `OFF-OPEN-002`

**Tema:** conservación/purga de datos sincronizados de cliente revocado.

Estado: ABIERTO — pendiente de aprobación

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5 para implementación de limpieza; restricciones legales dependen además de DO-T07.

Este documento no lo resuelve.

## 57.10 `DO-075`

**Estado:** **RESUELTA/APROBADA**.

Se preserva:

- máximo de 7 días desde última validación online para autorización offline;
- después se requiere revalidación para iniciar nuevas operaciones;
- trabajo ya capturado no se elimina.

No se reabre.

## 57.11 `FORM-OPEN-001` — Respuesta al ocultarse un campo

**Motivo:** la baseline no define si una respuesta ya capturada se borra, conserva o ignora cuando una condición oculta el campo.

**Alternativas:** borrar; conservar efectiva; conservar dormida; conservar durante edición y descartar al finalizar.

**Recomendación:** conservar dormida durante captura, excluirla de validación/resultado efectivo mientras esté oculta y cerrar antes de implementación su persistencia al finalizar.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 4 / antes de captura de Fase 5.

## 57.12 `FORM-OPEN-002` — Modelo operativo de tabla/matriz

**Motivo:** el tipo está aprobado, pero no está definido si las filas son predefinidas, dinámicas o ambas, ni el subconjunto de tipos admitidos en celdas.

**Alternativas:**

- filas fijas;
- filas dinámicas;
- ambos modos;
- tipos de celda simples;
- tipos de celda amplios/compuestos.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — columnas publicadas fijas y ordenadas, filas capturadas como instancias ordenadas durante mantenimiento y celdas limitadas inicialmente a tipos simples compatibles; sin fórmulas ni nesting compuesto.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 4.

## 57.13 `FORM-OPEN-003` — Cardinalidad del campo `image`

**Motivo:** la baseline establece que una respuesta de image es una o más imágenes, pero no define cómo se configura la multiplicidad.

**Alternativas:**

- siempre una imagen;
- siempre múltiples;
- configuración `single/multiple`;
- otra política explícita.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — permitir configuración conceptual `single` o `multiple`, sin introducir un máximo comercial propio; required se mantendría como regla independiente.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 4, y antes de Fase 5 para captura.

## 57.14 `FORM-OPEN-004` — Inicio offline con versión desactualizada

**Motivo:** una versión nueva puede publicarse mientras el técnico está desconectado.

**Alternativas:** rechazar v1 al sincronizar; aceptar última conocida; exigir red; reglas adicionales.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — una publicación nueva por sí sola no invalida retroactivamente un mantenimiento iniciado legítimamente offline con la última versión publicada/aplicable conocida por una réplica autorizada.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5.

## 57.15 `FORM-OPEN-005` — Tipos permitidos como fuente de igualdad

**Motivo:** `=` está aprobado, pero tipos multivaluados/compuestos no poseen una semántica única obvia para igualdad.

**Alternativas:**

1. permitir todos y definir igualdad por tipo;
2. limitar fuentes a valores escalares;
3. introducir `contains`, lo que modificaría la baseline y no está aprobado.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — para el MVP permitir como fuentes sólo campos con valor escalar y comparación de igualdad no ambigua; excluir `multiselect`, image, file y compuestos como fuente salvo aprobación expresa. No introducir `contains`.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 4.

## 57.16 `FORM-OPEN-006` — Nesting y semántica de contenedores compuestos

**Motivo:** repeatable y matrix están aprobados, pero no se define si pueden contener otros compuestos ni si el contenedor posee required/minimum instances propio.

**Alternativas:**

- nesting arbitrario;
- nesting limitado;
- sólo campos simples como hijos;
- required/minimum de contenedor;
- validación sólo de instancias existentes.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — mantener el MVP simple: evitar nesting de compuestos entre sí y no introducir reglas de mínimo/máximo de instancias del contenedor salvo decisión expresa; las validaciones required se aplicarían principalmente a los campos hijos de instancias existentes.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 4.

## 57.17 `FORM-OPEN-007` — Semántica de required para checkbox

**Motivo:** un checkbox booleano puede representar `true` o `false`, pero la baseline no define qué significa `required`. Confundir `false` con “sin respuesta” puede producir errores en mantenimiento técnico.

**Alternativas:**

1. `required` exige una respuesta explícita; `true` y `false` son valores válidos;
2. `required` significa que el checkbox debe estar marcado `true`;
3. no permitir `required` sobre checkbox;
4. permitir un mecanismo simple equivalente a “respuesta explícita requerida” sin convertir el checkbox en multiselect ni introducir una máquina de estados compleja.

### Evaluación

La alternativa 1 preserva con mayor claridad la semántica booleana del tipo si la captura distingue conceptualmente entre:

- ausencia de respuesta;
- respuesta explícita `false`;
- respuesta explícita `true`.

Para que esa alternativa sea coherente, un valor inicial visual de UI no debería convertirse automáticamente en una respuesta explícita por el mero hecho de renderizar el control.

La alternativa 2 cambia la semántica de `required` desde “respuesta requerida” hacia “valor verdadero obligatorio”, lo que puede ser válido para casos de aceptación/confirmación, pero no está definido como semántica general del tipo.

La alternativa 3 elimina la ambigüedad, pero reduce una capacidad que podría ser útil para registrar una decisión técnica explícita de sí/no.

La alternativa 4 sólo sería aceptable si se mantiene simple y no crea estados funcionales adicionales innecesarios.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — preferir que `required` exija una **respuesta explícita**, considerando `true` y `false` valores válidos y diferenciando ambos de “sin respuesta”; la UI no debería registrar automáticamente su valor inicial como respuesta explícita. Esta recomendación no convierte checkbox en multiselect ni introduce una máquina de estados compleja.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 4 y necesariamente antes de implementar captura/finalización en Fase 5.

## 57.18 `FORM-OPEN-008` — Multiplicidad de condiciones por campo destino

**Motivo:** si varias condiciones `show` o varias condiciones `required` apuntan al mismo destino, la evaluación exigiría introducir una semántica de combinación. La baseline excluye AND/OR complejos y no autoriza AND/OR implícitos.

**Alternativas:**

1. permitir como máximo una condición `show` por campo destino y una condición `required` por campo destino;
2. permitir varias y combinarlas mediante OR implícito;
3. permitir varias y combinarlas mediante AND implícito;
4. introducir expresiones compuestas.

### Evaluación

La alternativa 1 mantiene cada regla simple y evita introducir un operador de combinación no aprobado.

La alternativa 2 agrega OR implícito aunque el usuario no configure expresamente ese operador.

La alternativa 3 agrega AND implícito con el mismo problema y puede generar efectos todavía menos evidentes en UX.

La alternativa 4 amplía expresamente el motor hacia lógica compuesta, en tensión directa con el alcance MVP aprobado.

Un mismo campo fuente puede controlar distintos campos destino sin introducir combinación lógica.

Las cadenas de dependencias pueden existir mientras sean acíclicas; una cadena acíclica no equivale a permitir múltiples reglas convergentes sobre el mismo destino.

**Recomendación:** **PROPUESTA PENDIENTE DE APROBACIÓN** — permitir para el MVP como máximo una condición `show` por destino y como máximo una condición condicional `required` por destino; permitir que una misma fuente controle múltiples destinos y permitir cadenas acíclicas; no introducir AND/OR implícito.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 4.

## 57.19 Resumen de decisiones abiertas

| Decisión | Estado | Bloquea Fase 1 | Resolver antes de |
|---|---|---:|---|
| `DM-OPEN-001` | ABIERTA | No | Fase 3 |
| `DM-OPEN-002` | ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN | No | Fase 4 |
| `DM-OPEN-003` | ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN | No | Fase 4 / antes de Fase 5 |
| `DM-OPEN-004` | ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN | No | Fase 4 |
| `FORM-OPEN-001` | ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN | No | Fase 4 / Fase 5 |
| `FORM-OPEN-002` | ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN | No | Fase 4 |
| `FORM-OPEN-003` | ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN | No | Fase 4 / Fase 5 |
| `FORM-OPEN-004` | ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN | No | Fase 5 |
| `FORM-OPEN-005` | ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN | No | Fase 4 |
| `FORM-OPEN-006` | ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN | No | Fase 4 |
| `FORM-OPEN-007` | ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN | No | Fase 4 / antes de Fase 5 |
| `FORM-OPEN-008` | ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN | No | Fase 4 |

Las demás decisiones de documentación previa conservan su estado y deadline.

---

# 58. Gate del documento

## 58.1 Contradicciones bloqueantes

**No se detectan contradicciones bloqueantes conocidas** entre:

- `01-product-definition.md`;
- `02-domain-model.md`;
- `03-permissions-rls-strategy.md`;
- `04-offline-sync-strategy.md`;

que impidan continuar la documentación de Fase 0.

En particular permanecen coherentes:

- administración de formularios por `COMPANY_ADMIN`;
- ausencia de ejecución inicial para `COMPANY_ADMIN`;
- ejecución inicial por `TECHNICIAN` dentro de clientes autorizados;
- published immutable;
- campos independientes entre versiones;
- `MaintenanceRecord` fijado a una `FormVersion` al iniciarse;
- no repinning por nuevas publicaciones o sync;
- correcciones mediante nueva `MaintenanceRevision` usando la misma `FormVersion`;
- versionado histórico;
- local-first;
- coexistencia de versiones published en réplica;
- separación image/Evidence.

## 58.2 `DM-OPEN-001`

**Estado:** **ABIERTA**.

No resuelta en este documento.

## 58.3 `DM-OPEN-002`

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

Propuesta: máximo un formulario activo aplicable por nivel, con prioridad absoluta del override.

No se declara resuelta.

## 58.4 `DM-OPEN-003`

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

Propuesta: bloquear inicio cuando no exista una `FormVersion` published aplicable.

No se declara resuelta.

## 58.5 `DM-OPEN-004`

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

Propuesta: un único draft simultáneo por `FormTemplate`.

No se declara resuelta.

## 58.6 `FORM-OPEN-001..008`

**Estado conjunto:** **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.

Se mantienen:

- `FORM-OPEN-001` — tratamiento de respuestas al ocultarse;
- `FORM-OPEN-002` — modelo de tablas/matrices;
- `FORM-OPEN-003` — cardinalidad de image;
- `FORM-OPEN-004` — inicio offline con versión desactualizada;
- `FORM-OPEN-005` — tipos comparables como fuente de condición;
- `FORM-OPEN-006` — nesting y semántica de compuestos;
- `FORM-OPEN-007` — semántica de required para checkbox;
- `FORM-OPEN-008` — multiplicidad de condiciones por campo destino.

Ninguna se declara aprobada.

Ninguna bloquea Fase 1.

Deben cerrarse conforme a los deadlines indicados antes de la implementación que dependa de ellas.

En particular:

- `FORM-OPEN-007` no permite asumir silenciosamente que `false` equivale a ausencia ni que required equivale a `true`;
- `FORM-OPEN-008` no permite que la implementación elija silenciosamente AND u OR cuando varias condiciones del mismo tipo apunten al mismo destino.

## 58.7 Decisiones preservadas

Se mantienen sin resolver ni modificar:

- `DM-OPEN-005`;
- `DM-OPEN-006`;
- `DM-OPEN-007`;
- `DM-OPEN-008`;
- `DO-T03` — **PARCIALMENTE ABIERTO**;
- `DO-T04` — **PROPUESTA PENDIENTE DE APROBACIÓN**;
- `OFF-OPEN-001` — **ABIERTO — pendiente de aprobación**;
- `OFF-OPEN-002` — **ABIERTO — pendiente de aprobación**.

`DO-075` permanece **RESUELTA/APROBADA**.

## 58.8 Candidatos a ADR

Quedan identificados como candidatos, sin generar ADRs:

- modelo `FormTemplate` / `FormVersion`;
- published immutable;
- identidad independiente de fields por versión;
- representación de estructuras compuestas;
- evaluación de condiciones;
- selección de applicable form;
- pinning de `FormVersion`;
- identidad de instancias/filas si su impacto arquitectónico lo justifica.

## 58.9 Estado documental

**Estado de `05-form-engine-spec.md`: APROBADO.**

**Archivo de esta entrega:** `05-form-engine-spec-approved.md`.

**Ruta normativa futura:** `docs/product/05-form-engine-spec.md`.

## 58.10 Estado de Fase 0

**Estado de Fase 0: EN CURSO.**

La generación de esta versión corregida no cierra Fase 0.

## 58.11 Alcance de la aprobación

La aprobación de este documento:

- **NO autoriza implementación**;
- **NO autoriza inicializar Next.js**;
- **NO autoriza React**;
- **NO autoriza SQL**;
- **NO autoriza tablas PostgreSQL**;
- **NO autoriza migrations**;
- **NO autoriza RLS ejecutable**;
- **NO autoriza Dexie**;
- **NO autoriza schema IndexedDB**;
- **NO autoriza Server Actions**;
- **NO autoriza APIs**;
- **NO autoriza Codex**;
- **NO genera ADRs**;
- **NO resuelve decisiones abiertas**;
- **NO autoriza avanzar automáticamente al documento 06**;
- **NO cierra Fase 0**.

## 58.12 Verificación explícita del Gate

- `DM-OPEN-001` = **ABIERTA**.
- `DM-OPEN-002` = **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-003` = **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-004` = **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `FORM-OPEN-001..008` = **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.
- `DM-OPEN-005..008` = **preservadas sin modificación**.
- `DO-T03` = **preservada — PARCIALMENTE ABIERTO**.
- `DO-T04` = **preservada — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `OFF-OPEN-001` = **preservada — ABIERTO — pendiente de aprobación**.
- `OFF-OPEN-002` = **preservada — ABIERTO — pendiente de aprobación**.
- `DO-075` = **RESUELTA/APROBADA**.
- **Estado de Fase 0: EN CURSO**.

La aprobación documental de `05` no resuelve ninguna decisión abierta ni cierra Fase 0.
