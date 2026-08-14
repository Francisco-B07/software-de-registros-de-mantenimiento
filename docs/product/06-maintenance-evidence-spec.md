# 06 — Especificación conceptual y funcional de evidencias fotográficas de mantenimiento

> **Ruta normativa/objetivo:** `docs/product/06-maintenance-evidence-spec.md`  
> **Estado:** **APROBADO — especificación conceptual y funcional del sistema de evidencias fotográficas de mantenimiento del MVP**  
> **Fase:** Fase 0 — documento derivado  
> **Estado de Fase 0:** **EN CURSO**  
> **Baseline normativa:** `docs/product/01-product-definition.md`  
> **Modelo de dominio aprobado:** `docs/product/02-domain-model.md`  
> **Estrategia de permisos/RLS aprobada:** `docs/product/03-permissions-rls-strategy.md`  
> **Estrategia offline/sync aprobada:** `docs/product/04-offline-sync-strategy.md`  
> **Form Engine aprobado:** `docs/product/05-form-engine-spec.md`  
> **Naturaleza:** contrato conceptual y funcional del sistema de evidencias fotográficas; **NO constituye implementación, modelo físico, diseño de Storage, SQL, RLS ejecutable, schema Dexie, APIs ni componentes React**

---

# 1. Propósito y alcance

Este documento define la especificación conceptual y funcional del sistema de `Evidence` fotográfica del MVP.

Su objetivo es establecer, antes de cualquier implementación:

- qué representa una `Evidence`;
- cómo se diferencia de un campo `image`;
- cómo se configura dentro de una `FormVersion`;
- cómo se vincula con `Response`, mantenimiento y revisión;
- cómo se expresan las categorías `BEFORE` y `AFTER`;
- cómo funciona la obligatoriedad de evidencia;
- qué reglas deben cumplirse durante captura offline;
- cómo se separan estado funcional y estado de sincronización;
- cómo se conserva la fotografía hasta confirmación remota válida;
- cómo deben funcionar reintentos e idempotencia;
- cómo se preservan revisiones históricas;
- cómo funcionan correcciones y reemplazos visuales;
- qué fronteras de autorización y aislamiento tenant deben mantenerse;
- qué principios UX deben regir captura, error y corrección;
- qué decisiones continúan abiertas antes de implementar evidencia.

Debe actuar como contrato para el posterior diseño de:

- configuración de evidencia dentro del Form Engine;
- captura de fotografías durante mantenimiento;
- persistencia local;
- sincronización;
- autorización remota;
- almacenamiento remoto;
- correcciones;
- reemplazos visuales;
- históricos;
- futura utilización en reporting.

## 1.1 Autoridad

Se aplica el siguiente orden de autoridad:

1. `docs/product/01-product-definition.md`;
2. `docs/product/02-domain-model.md`;
3. `docs/product/03-permissions-rls-strategy.md`;
4. `docs/product/04-offline-sync-strategy.md`;
5. `docs/product/05-form-engine-spec.md`;
6. `docs/product/00-master-product-brief.md`;
7. decisiones explícitamente aprobadas posteriormente dentro del Project que no hayan sido sustituidas.

Este documento profundiza el subsistema de Evidence sin modificar las decisiones normativas de las fuentes superiores.

## 1.2 Revisión previa de coherencia

No se detectan contradicciones bloqueantes entre `01`, `02`, `03`, `04` y `05` que impidan definir esta especificación.

Permanecen coherentes:

- `Evidence` distinta de campo `image`;
- `Evidence` vinculada a una `Response`;
- configuración versionada;
- `FormVersion` published inmutable;
- mantenimiento fijado a su `FormVersion`;
- revisiones finalizadas históricas e inmutables;
- evidencia finalizada no eliminable;
- reemplazo visual sin destrucción del original;
- ejecución inicial por `TECHNICIAN`;
- ausencia de ejecución inicial para `COMPANY_ADMIN`;
- correcciones por ambos roles conforme a su alcance;
- aislamiento tenant/client;
- local-first;
- outbox durable;
- idempotencia;
- fotografías locales hasta confirmación remota;
- separación business state / sync state;
- no Last Write Wins silencioso;
- autorización offline máxima de 7 días.

La continuidad funcional de Evidence entre distintas `MaintenanceRevision` no está definida por la baseline y se formaliza como decisión abierta en `EVID-OPEN-006`, sin resolverla en este documento.

## 1.3 Fuera del alcance

Este documento **NO define ni autoriza**:

- SQL;
- tablas PostgreSQL;
- columnas;
- claves físicas;
- índices;
- migrations;
- buckets de Supabase Storage;
- paths definitivos de Storage;
- nomenclatura definitiva de objetos remotos;
- políticas ejecutables de Storage;
- RLS ejecutable;
- funciones PostgreSQL;
- schema Dexie/IndexedDB;
- índices Dexie;
- APIs;
- endpoints;
- Server Actions;
- handlers;
- protocolo HTTP definitivo;
- librerías de cámara;
- APIs concretas de file picker;
- algoritmo o librería de compresión;
- procesamiento concreto de imágenes;
- formatos físicos definitivos;
- límites físicos definitivos de infraestructura;
- componentes React;
- implementación de PWA;
- inicialización de Supabase;
- ADRs;
- implementación mediante Codex.

Las restricciones técnicas inevitables que aparezcan posteriormente deberán documentarse como restricciones técnicas y no convertirse silenciosamente en cuotas funcionales o comerciales.

---

# 2. Terminología

## 2.1 `Evidence`

Fotografía vinculada a una `Response` concreta con función de evidencia técnica adicional.

No constituye un adjunto genérico del mantenimiento y no reemplaza el valor principal de la respuesta.

Cada instancia posee identidad conceptual propia y debe poder mantenerse históricamente identificable.

## 2.2 Evidence configuration

Configuración funcional, perteneciente a un `FormField` dentro de una `FormVersion`, que determina si esa respuesta admite o exige evidencia y con qué semántica.

Puede expresar conceptualmente:

- sin evidencia;
- `BEFORE`;
- `AFTER`;
- `BEFORE + AFTER`;
- optional;
- required;
- fuentes de captura permitidas.

Es definición, no fotografía capturada.

## 2.3 Evidence captured instance

Fotografía concreta capturada o seleccionada en el contexto de una `Response`.

Es una instancia de dominio diferente de la configuración que permitió o exigió su existencia.

## 2.4 `BEFORE`

Categoría semántica que identifica una evidencia visual del estado previo a la intervención, acción o actividad técnica relevante para la respuesta.

## 2.5 `AFTER`

Categoría semántica que identifica una evidencia visual del estado posterior a la intervención, acción o actividad técnica relevante para la respuesta.

## 2.6 `BOTH`

Configuración que habilita o exige las dos categorías diferenciadas:

- `BEFORE`;
- `AFTER`.

`BOTH` no significa que una única fotografía cambie silenciosamente de categoría ni obliga a interpretar una misma instancia simultáneamente como ambas.

## 2.7 Required evidence

Configuración que convierte la satisfacción del requisito fotográfico aplicable en una validación necesaria para finalizar localmente el mantenimiento.

La cardinalidad exacta necesaria para considerar satisfecha una categoría permanece abierta mediante `EVID-OPEN-001`.

## 2.8 Optional evidence

Configuración que permite capturar evidencia de la categoría configurada sin convertir su ausencia en bloqueo de finalización.

## 2.9 Capture source

Origen funcional desde el cual el usuario obtiene la fotografía:

- cámara;
- galería.

Es distinto de la categoría `BEFORE`/`AFTER`.

## 2.10 Local evidence

Evidence cuyo archivo y metadata necesaria existen durablemente en la réplica local de la identidad, independientemente de que exista o no confirmación remota.

## 2.11 Pending upload

Evidence cuyo contenido local todavía necesita completar y confirmar el proceso remoto correspondiente.

“Pending” no implica que el mantenimiento esté funcionalmente incompleto.

## 2.12 Remotely confirmed evidence

Evidence respecto de la cual existe confirmación autoritativa suficiente de que el efecto remoto esperado ha quedado correctamente reconocido, incluyendo la correlación entre el contenido almacenado y su identidad/asociación de dominio.

No equivale a upload iniciado.

## 2.13 Visual replacement

Relación histórica por la cual una Evidence nueva pasa a utilizarse visualmente en lugar de una Evidence anterior dentro del contexto vigente, sin eliminar, reescribir ni modificar el archivo original.

## 2.14 Superseded evidence

Evidence que ha sido sustituida visualmente por otra en un contexto posterior.

Continúa existiendo, perteneciendo a su revisión original y formando parte del histórico.

“Superseded” no significa borrada ni inválida retrospectivamente.

## 2.15 Evidence history

Conjunto históricamente reconstruible de:

- fotografías;
- categorías;
- respuestas;
- revisiones;
- relaciones de reemplazo;
- contexto de cada estado histórico.

## 2.16 Effective Evidence set

Conjunto de Evidence que debe interpretarse como parte del estado funcional de una `MaintenanceRevision` determinada.

Este concepto permite distinguir entre:

- Evidence originada en esa revisión;
- Evidence originada en revisiones anteriores que, conforme a la futura política aprobada, continúe formando parte del estado efectivo;
- Evidence superseded cuya existencia histórica se preserva aunque su presentación vigente pueda haber cambiado.

La existencia del concepto **no define** cómo se representa físicamente ni resuelve cómo se calcula. Esa semántica permanece abierta en `EVID-OPEN-006`.

---

# 3. Frontera `image` vs `Evidence`

La separación entre ambos conceptos es obligatoria.

| Aspecto | Campo `image` | `Evidence` |
|---|---|---|
| Naturaleza | `FormField` autónomo | Capacidad adicional asociada a una `Response` |
| Contenido principal | Imagen o imágenes | Fotografía complementaria |
| Reemplaza valor principal | No aplica: es el valor principal | No |
| BEFORE/AFTER inherente | No | Sí |
| Lifecycle histórico propio de Evidence | No es su semántica base | Sí |
| Vinculación | Campo y su `Response` principal | Una `Response` concreta |
| Cardinalidad | `FORM-OPEN-003` | `EVID-OPEN-001/002` |

## 3.1 Campo `image`

Un campo `image`:

- forma parte de la estructura de la `FormVersion`;
- produce una `Response` cuyo contenido principal es imagen o imágenes;
- mantiene su cardinalidad pendiente bajo `FORM-OPEN-003`;
- no obtiene automáticamente semántica `BEFORE` o `AFTER`.

## 3.2 `Evidence`

`Evidence`:

- complementa una respuesta;
- no sustituye su valor principal;
- puede expresar `BEFORE` o `AFTER`;
- posee identidad e histórico propios;
- pertenece a una `Response`.

## 3.3 Composición permitida

Un campo `image` puede tener además Evidence si la configuración de su `FormVersion` lo permite.

En ese caso coexisten dos mecanismos:

1. imagen o imágenes que constituyen la respuesta principal del campo `image`;
2. fotografías adicionales que constituyen `Evidence`.

No deben fusionarse en una lista indistinguible.

`FORM-OPEN-003` no resuelve ni limita la cardinalidad de Evidence.

---

# 4. Responsabilidades de actores

## 4.1 `TECHNICIAN`

Dentro de un cliente autorizado, `TECHNICIAN` puede:

- visualizar evidencia que se encuentre dentro de su alcance;
- capturar Evidence durante una ejecución inicial autorizada;
- hacerlo offline mientras su autorización offline siga vigente;
- agregar Evidence durante una corrección autorizada;
- participar en acciones de corrección y resolución de conflictos permitidas por la baseline;
- reintentar sincronización de trabajo perteneciente a su propia réplica cuando siga autorizado.

No adquiere administración de plantillas por utilizar Evidence.

## 4.2 `COMPANY_ADMIN`

Dentro de su tenant, `COMPANY_ADMIN` puede:

- configurar Evidence en drafts de `FormVersion`;
- leer evidencia dentro de su alcance autorizado;
- agregar o modificar la evidencia que forme parte de una nueva corrección autorizada;
- agregar o modificar evidencia como parte de una resolución de conflicto autorizada;
- establecer reemplazos visuales dentro de esos contextos cuando corresponda.

`COMPANY_ADMIN` **NO** puede:

- iniciar una ejecución inicial de mantenimiento;
- crear evidencias pertenecientes a una ejecución inicial por inferencia;
- utilizar su administración del Form Engine como puente para ejecutar mantenimientos.

## 4.3 `SUPER_ADMIN`

`SUPER_ADMIN`:

- no obtiene acceso operativo a Evidence por defecto;
- no obtiene permisos de escritura generales por ser actor global;
- requiere `SupportAccessGrant` válido con scopes suficientes para el acceso excepcional correspondiente.

Un grant de soporte no genera capacidades operativas nuevas que la baseline no haya aprobado.

---

# 5. Configuración de Evidence en `FormVersion`

Evidence configuration forma parte de la definición del campo dentro de la `FormVersion`.

Un campo susceptible de respuesta puede configurarse conceptualmente como:

- sin Evidence;
- Evidence `BEFORE`;
- Evidence `AFTER`;
- Evidence `BEFORE + AFTER`.

Cuando Evidence está habilitada, la configuración debe expresar además:

- optional o required;
- fuentes permitidas:
  - cámara;
  - galería;
  - ambas.

## 5.1 Configuración version-bound

La configuración pertenece al `FormField` exacto de una `FormVersion`.

No pertenece a una definición mutable global separada.

## 5.2 Published immutable

Una vez publicada la `FormVersion`, no pueden modificarse in place:

- habilitación/deshabilitación de Evidence;
- categorías;
- required/optional;
- fuentes permitidas;
- otra metadata funcional que cambie el significado de captura.

Modificar cualquiera de esos aspectos requiere:

**nuevo draft → nueva publicación → nueva `FormVersion`.**

## 5.3 Histórico

La configuración histórica de una `FormVersion` permanece disponible para interpretar correctamente mantenimientos que la utilizaron.

Una publicación nueva no reconfigura un mantenimiento existente.

---

# 6. Evidencia asociada a `Response`

Toda Evidence capturada debe poseer un contexto inequívoco.

Conceptualmente debe poder determinarse:

- tenant;
- `Client`;
- `Equipment`;
- `MaintenanceRecord`;
- `MaintenanceRevision` finalizada o contexto de captura previo a finalización;
- `Response`;
- `FormField` exacto;
- `FormVersion` exacta;
- categoría semántica;
- identidad de la Evidence.

El ownership no debe depender de identificadores independientes que puedan contradecirse.

La cadena real de dominio debe ser coherente.

Una Evidence mantiene **una sola identidad histórica** y conserva su `Response` y revisión de origen. Si una revisión posterior continúa considerando esa Evidence parte de su estado efectivo, esa continuidad no debe reasignar silenciosamente la Evidence a otra `Response` ni cambiar su revisión histórica de origen. La semántica exacta para representar esa continuidad permanece abierta en `EVID-OPEN-006`.

## 6.1 Durante captura inicial

Antes de existir una revisión finalizada, la Evidence puede pertenecer al contexto local de captura que posteriormente dará lugar a la revisión correspondiente.

Ese estado intermedio no elimina su obligación de permanecer inequívocamente asociada al mantenimiento, respuesta y campo correctos.

## 6.2 Después de finalización

Cuando forma parte de una revisión finalizada, debe poder identificarse sin ambigüedad qué Evidence se originó en dicho estado histórico.

La interpretación del conjunto efectivo de Evidence de revisiones posteriores debe conservar esa revisión de origen y queda sujeta a `EVID-OPEN-006`.

## 6.3 Estructuras compuestas

Cuando una `Response` pertenece a una instancia de repeatable group, fila, celda u otro contexto compuesto aprobado, la Evidence debe conservar el mismo contexto suficiente para no quedar asociada a otra instancia visualmente parecida.

No se definen claves físicas.

---

# 7. `BEFORE`

`BEFORE` representa visualmente el estado previo a la intervención o acción técnica relevante dentro del contexto del campo y su respuesta.

Su semántica proviene de la categoría declarada durante la captura conforme a la configuración del formulario.

No debe inferirse exclusivamente a partir de:

- timestamp;
- orden de upload;
- orden de sincronización;
- nombre del archivo;
- posición visual accidental.

Una fotografía capturada o subida antes que otra no se convierte automáticamente en `BEFORE`.

La UI debe hacer comprensible al usuario en qué categoría está capturando.

---

# 8. `AFTER`

`AFTER` representa visualmente el estado posterior a la acción o intervención técnica correspondiente.

Al igual que `BEFORE`, su semántica debe ser explícita dentro del contexto de captura y no inferida únicamente mediante timestamps.

La existencia de Evidence `AFTER`:

- no elimina Evidence `BEFORE`;
- no modifica la categoría de una Evidence previa;
- no constituye por sí sola un reemplazo visual.

Un before/after normal y un visual replacement son conceptos distintos.

---

# 9. `BOTH`

Cuando la configuración es `BEFORE + AFTER`:

- existen dos categorías funcionalmente distintas;
- la captura debe identificar a cuál pertenece cada Evidence;
- una Evidence no debe cambiar de categoría silenciosamente;
- la validación debe evaluar separadamente el requisito correspondiente a `BEFORE`;
- la validación debe evaluar separadamente el requisito correspondiente a `AFTER`.

Si la configuración es required, cada categoría debe satisfacer la futura regla de cardinalidad aprobada en `EVID-OPEN-001`.

La presencia de Evidence en una categoría no satisface automáticamente la otra.

---

# 10. Required vs optional

## 10.1 Optional

Cuando Evidence es optional:

- su ausencia no bloquea por sí sola la finalización;
- las evidencias capturadas sí quedan sujetas a persistencia, ownership, histórico y sincronización.

## 10.2 Required `BEFORE`

Una configuración required `BEFORE` exige que la categoría `BEFORE` satisfaga la regla de cardinalidad que finalmente se apruebe.

Cero evidencias `BEFORE` no puede considerarse cumplimiento de un requisito required.

Este documento no decide si el resultado correcto es:

- una o más;
- exactamente una;
- cantidad configurable.

## 10.3 Required `AFTER`

Se aplica el mismo principio de forma independiente a `AFTER`.

## 10.4 Required `BOTH`

Para `BEFORE + AFTER` required:

- `BEFORE` debe satisfacer su requisito;
- `AFTER` debe satisfacer su requisito;
- una categoría no compensa la ausencia de la otra.

La cantidad exacta permanece en `EVID-OPEN-001`.

## 10.5 Relación con visibilidad del Form Engine

Evidence required no debe reintroducir un bloqueo sobre un campo que el Form Engine determine como oculto/no aplicable para la finalización.

El tratamiento de una respuesta y de los datos previamente capturados cuando el campo pasa a ocultarse permanece gobernado por `FORM-OPEN-001`.

Este documento no resuelve esa decisión.

---

# 11. Cardinalidad de Evidence

La baseline permite afirmar que una `Response` puede poseer:

- cero Evidence cuando no está habilitada o cuando es optional y no se captura;
- una Evidence;
- potencialmente múltiples Evidence.

Sin embargo, no existe una regla aprobada que determine todavía:

- si siempre se admiten múltiples fotografías por categoría;
- si una categoría required exige exactamente una;
- si required significa una o más;
- si la cantidad puede ser configurable.

No existe un máximo funcional o comercial aprobado.

No deben introducirse máximos de producto bajo argumentos de Storage, UX o implementación.

Las restricciones físicas inevitables se documentarán posteriormente como restricciones técnicas.

La cardinalidad de Evidence es independiente de `FORM-OPEN-003`.

Se formaliza mediante:

- `EVID-OPEN-001`;
- `EVID-OPEN-002`.

---

# 12. Captura desde cámara

La cámara es una fuente funcional de captura.

Conceptualmente:

1. el usuario selecciona la categoría permitida;
2. obtiene una fotografía mediante cámara;
3. la fotografía debe convertirse en Evidence local;
4. debe persistirse durablemente;
5. sólo después puede considerarse capturada con éxito;
6. posteriormente puede quedar pendiente de sincronización.

Capturar desde cámara:

- no implica upload;
- no implica confirmación remota;
- no cambia permisos;
- no permite escapar de la autorización del mantenimiento;
- no altera la categoría semántica seleccionada.

Este documento no selecciona APIs, librerías ni mecanismos concretos de cámara.

---

# 13. Selección desde galería

La galería es una fuente funcional equivalente a efectos de dominio.

Una fotografía seleccionada:

- debe asociarse al contexto correcto;
- debe persistirse localmente;
- puede quedar pending;
- sigue las mismas reglas de idempotencia, histórico y autorización.

No se considera “menos válida” por provenir de galería cuando esa fuente está permitida por la `FormVersion`.

## 13.1 Metadata del origen

La baseline exige permitir cámara y galería, pero no exige que el origen de una instancia capturada se convierta en metadata histórica funcional obligatoria.

Conservarlo puede resultar útil para:

- diagnóstico;
- UX;
- soporte técnico.

Sin embargo, no cambia actualmente:

- ownership;
- categoría `BEFORE`/`AFTER`;
- required;
- histórico;
- autorización.

Por ello este documento no introduce una `EVID-OPEN-*` adicional sobre ese punto.

El diseño técnico posterior podrá conservar capture source como metadata si no modifica semántica de producto ni genera una nueva inferencia de confianza.

---

# 14. Metadata conceptual

La Evidence debe conservar conceptualmente información suficiente para mantener su significado y lifecycle.

## 14.1 Metadata funcional necesaria

Debe poder determinarse:

- identidad estable de Evidence;
- ownership tenant;
- contexto client/equipment;
- mantenimiento;
- revisión o contexto de captura;
- `Response`;
- `FormField` exacto;
- `FormVersion`;
- categoría `BEFORE`/`AFTER`;
- orden cuando exista multiplicidad;
- relación de visual replacement cuando corresponda;
- pertenencia histórica.

## 14.2 Metadata de sincronización necesaria

Debe poder conocerse conceptualmente:

- si el contenido existe sólo localmente;
- si está pendiente;
- si existe un intento en curso;
- si fue confirmado remotamente;
- si falló y puede reintentarse;
- si existe un conflicto o bloqueo relevante.

## 14.3 Metadata técnica futura

Podrá incluirse información técnica útil para:

- diagnóstico;
- almacenamiento;
- integridad;
- procesamiento;
- transferencias;
- limitaciones físicas.

Este documento no define columnas, payloads, checksums ni formatos concretos.

Metadata técnica no debe sustituir metadata funcional ni convertirse accidentalmente en fuente de autorización.

---

# 15. Timestamps y fechas

Deben distinguirse al menos tres momentos conceptuales.

## 15.1 Momento de captura conocido por el dispositivo

Representa cuándo el dispositivo considera que la fotografía fue obtenida o seleccionada.

Puede ser útil para contexto de campo, pero el reloj del dispositivo no se considera una autoridad infalible.

## 15.2 Momento de persistencia local

Representa cuándo el sistema consiguió conservar durablemente la Evidence en la réplica.

Es relevante para afirmar que la captura local fue guardada.

No sustituye necesariamente al momento real de captura.

## 15.3 Momento de confirmación remota

Representa cuándo la infraestructura remota confirmó válidamente el efecto esperado.

No debe utilizarse como sustituto del momento real de captura.

Una fotografía obtenida tres días offline no se considera capturada recién cuando finalmente se sincroniza.

## 15.4 Confianza temporal

Este documento no establece confianza absoluta en el reloj del dispositivo ni un algoritmo para corregirlo.

La posible discrepancia se registra como riesgo.

Los timestamps técnicos de Evidence tampoco deben convertirse por inferencia en el criterio mensual de reporting; `DM-OPEN-008` permanece abierta.

---

# 16. Orden de evidencias

Si la política de multiplicidad finalmente permite varias Evidence dentro de una misma combinación de:

- `Response`;
- categoría;
- revisión/contexto,

debe existir un orden determinista suficiente para:

- UX;
- reapertura;
- históricos;
- reporting posterior.

Identidad y orden son conceptos diferentes.

Reordenar visualmente una Evidence, si esa capacidad se aprobara posteriormente, no debería convertirla en otra Evidence.

Este documento no fija:

- columna;
- algoritmo;
- numeración;
- mecanismo de reordenamiento.

Mientras `EVID-OPEN-002` permanezca abierta, el requisito de orden múltiple sólo aplica en los casos en que efectivamente exista multiplicidad.

---

# 17. Lifecycle local

El lifecycle conceptual de una Evidence nueva es:

**captura o selección → persistencia local durable → asociación a `Response` → validación local → pendiente de upload → intento remoto → confirmación remota válida**

Pueden intercalarse:

- cierre de aplicación;
- reinicio;
- pérdida de conectividad;
- retry;
- espera por dependencia;
- bloqueo por autorización;
- error;
- conflicto.

Esos eventos no deben cambiar la identidad lógica de la Evidence.

La outbox de `04` continúa siendo el patrón arquitectónico general para las intenciones pendientes.

---

# 18. Persistencia antes de red

Una fotografía no puede considerarse capturada exitosamente para trabajo offline hasta que:

- el archivo necesario haya sido persistido durablemente;
- exista metadata suficiente para recuperar su contexto;
- la aplicación pueda volver a asociarla a la `Response` correcta.

No basta con:

- preview en pantalla;
- URL temporal;
- estado de React;
- memoria RAM;
- request de upload en vuelo.

Si la persistencia local falla, la UI debe informar que la captura no pudo guardarse.

El sistema no debe fingir éxito y depender de que el upload termine antes de cerrar la aplicación.

---

# 19. Estado de sincronización

Evidence necesita distinguir situaciones técnicas equivalentes a:

- local only;
- pending;
- uploading;
- remotely confirmed;
- failed/retry;
- waiting dependency;
- blocked by authorization;
- conflict, cuando corresponda.

Estos nombres no fijan un enum físico.

## 19.1 Separación de estado funcional

Los estados anteriores no indican por sí solos si la Evidence:

- satisface un requisito funcional;
- pertenece a una revisión finalizada;
- es visualmente vigente.

Son ejes distintos.

Una Evidence puede ser:

- funcionalmente válida;
- parte de un mantenimiento finalizado localmente;
- y simultáneamente estar pending.

## 19.2 No inferir sync desde negocio

“Finalizado” no significa “sincronizado”.

“Required satisfecho” no significa “remotamente confirmado”.

---

# 20. Confirmación remota válida

Una Evidence sólo puede considerarse remotamente confirmada cuando el sistema dispone de confirmación autoritativa suficiente de que el efecto remoto esperado ha quedado correctamente reconocido.

Debe ser posible correlacionar la confirmación con:

- la misma Evidence lógica;
- su contenido esperado;
- su asociación válida al recurso de dominio correspondiente.

No constituye confirmación:

- request enviado;
- conexión abierta;
- upload iniciado;
- bytes parcialmente transferidos;
- respuesta ambigua;
- éxito del binario sin poder confirmar su asociación correcta;
- éxito de metadata sin disponer del contenido remoto requerido.

Una denegación de autorización o un conflicto no constituyen confirmación exitosa.

---

# 21. Idempotencia

Toda Evidence creada localmente debe disponer de identidad estable desde su captura.

Repetir la misma intención lógica por:

- timeout;
- upload interrumpido;
- PWA cerrada;
- respuesta perdida;
- reconexión;
- retry manual;

no debe crear otra Evidence lógica silenciosamente.

La identidad estable debe mantenerse durante todos los reintentos.

Este documento no define:

- UUID;
- tipo de clave;
- algoritmo de generación;
- estructura de idempotency key.

La estrategia concreta es candidata a ADR.

---

# 22. Dependencias del outbox

La sincronización de Evidence puede depender conceptualmente de:

- existencia/aceptación del `MaintenanceRecord`;
- contexto de `MaintenanceRevision`;
- existencia/aceptación de la `Response`;
- metadata de Evidence;
- contenido binario;
- asociación válida entre contenido y Evidence;
- autorización vigente.

No se fija un DAG ni una tabla concreta.

## 22.1 Parent no confirmado

Una Evidence no debe quedar vinculada remotamente a una `Response` inexistente.

## 22.2 Archivo y metadata

La estrategia puede elegir el orden técnico que corresponda, pero debe evitar dos resultados inválidos:

- archivo remoto sin ruta recuperable hacia su Evidence de dominio;
- Evidence marcada confirmada sin contenido remoto válido.

## 22.3 Dependencia bloqueada

Si una operación parent:

- entra en conflicto;
- es rechazada;
- queda bloqueada por autorización;

las dependencias de Evidence deben preservarse y no continuar ciegamente.

---

# 23. Finalización local con Evidence pendiente

La finalización funcional y la sincronización son independientes.

Cuando:

- la respuesta cumple las validaciones del Form Engine;
- los requisitos de Evidence aplicables se satisfacen localmente;
- las fotografías requeridas están persistidas durablemente;

`Guardar` puede finalizar localmente el mantenimiento aunque exista Evidence todavía pendiente de upload.

## 23.1 Required local vs upload

Debe distinguirse:

**Evidence required presente localmente**

de:

**Evidence remotamente confirmada**.

La falta de red no debe hacer fallar un requisito required si la Evidence necesaria existe durablemente local y satisface las reglas funcionales aplicables.

## 23.2 Consecuencia

Es un estado válido:

- mantenimiento finalizado localmente;
- Evidence válida;
- upload pendiente.

La UI debe representarlo sin presentar la fotografía como subida.

---

# 24. Validación de Evidence required

La validación se ejecuta localmente antes de finalizar.

Debe considerar:

1. si el campo/respuesta es efectivamente aplicable conforme al Form Engine;
2. qué configuración de Evidence pertenece a la `FormVersion` fijada;
3. si corresponde `BEFORE`, `AFTER` o ambas;
4. si la configuración es optional o required;
5. si cada categoría required satisface la cardinalidad que se apruebe;
6. si cada Evidence considerada válida está persistida durablemente.

## 24.1 `BEFORE + AFTER`

Cada categoría se valida de forma independiente.

## 24.2 Cardinalidad pendiente

Mientras `EVID-OPEN-001` permanezca abierta:

- no se puede implementar “exactamente una” por inferencia;
- no se puede implementar “una o más” como decisión cerrada;
- no se puede introducir cantidad configurable sin aprobación.

## 24.3 Visibilidad

Un campo oculto que no bloquea finalización por las reglas del Form Engine tampoco debe quedar bloqueado indirectamente por required Evidence.

El tratamiento de datos previamente capturados al ocultarse continúa sujeto a `FORM-OPEN-001`.

## 24.4 Required durante una corrección

Una corrección puede encontrarse con Evidence originada en una revisión anterior y todavía potencialmente relevante para el estado funcional actual.

Este documento no decide si esa Evidence anterior:

- continúa satisfaciendo required en la revisión nueva;
- debe estar explícitamente incluida en el effective Evidence set;
- deja de satisfacerlo y requiere nueva captura.

La validación de required en una corrección debe quedar determinada conjuntamente por:

- la cardinalidad aprobada en `EVID-OPEN-001`;
- la política de continuidad aprobada en `EVID-OPEN-006`;
- la vigencia visual resultante de `EVID-OPEN-004`;
- la política de categorías de `EVID-OPEN-005`.

No debe obligarse por inferencia a recapturar todas las fotografías en cada corrección.

Tampoco debe declararse por inferencia que cualquier Evidence histórica satisface automáticamente el required de una revisión posterior.

---

# 25. Reapertura de aplicación

Después de cerrar y volver a abrir la aplicación, una Evidence pendiente debe conservar:

- archivo local;
- identidad;
- asociación al mantenimiento;
- asociación a la `Response`;
- categoría;
- estado de sincronización necesario;
- relación con outbox;
- posibilidad de retry.

No debe depender de referencias temporales existentes únicamente durante la sesión anterior.

La UI debe reconstruir su estado desde persistencia durable.

---

# 26. Reinicio del dispositivo

El mismo principio aplica después de reiniciar el dispositivo.

Trabajo pendiente no debe depender de:

- memoria RAM;
- proceso activo;
- temporizador en background;
- request viva.

Dentro de las garantías reales del almacenamiento local, el sistema debe poder recuperar el archivo y continuar la sincronización cuando exista una nueva oportunidad válida.

---

# 27. Logout

Logout debe integrarse con la estrategia de `04`.

Los pendientes:

- pueden preservarse cuando sea técnicamente posible;
- permanecen vinculados a la identidad propietaria;
- no pasan a pertenecer a la siguiente sesión;
- no se eliminan automáticamente por cerrar sesión;
- no deben sincronizarse utilizando otra identidad.

Logout cierra acceso activo, no transforma pendientes en datos públicos ni compartidos.

Este documento no resuelve `DO-T04`.

---

# 28. Cambio de usuario en dispositivo compartido

Si el usuario A cierra sesión y posteriormente inicia sesión B:

- Evidence de A no debe aparecer en la UI de B;
- B no debe poder abrir el archivo local de A mediante la réplica activa;
- outbox de A no debe procesarse utilizando la sesión de B;
- Evidence de A no debe asociarse a mantenimientos de B;
- compartir tenant o cliente no elimina esta separación.

La identidad propietaria de la réplica es una frontera obligatoria.

La implementación concreta de protección local permanece bajo `DO-T04`.

---

# 29. Autorización offline

`DO-075` permanece cerrada.

La autorización offline puede mantenerse durante un máximo de **7 días** desde la última validación online.

Durante una vigencia offline válida, `TECHNICIAN` puede capturar Evidence como parte de operaciones que ya tenga permitido iniciar o modificar.

Superado el máximo:

- no se inicia una operación nueva;
- se requiere conectividad y revalidación;
- Evidence ya capturada no se elimina;
- outbox no se borra;
- archivos pendientes se preservan.

No se introduce otro período ni excepción.

---

# 30. Revocación

Puede ocurrir:

1. el actor captura Evidence estando autorizado offline;
2. posteriormente se revoca su acceso en servidor;
3. el dispositivo todavía desconectado conserva el trabajo;
4. finalmente reconecta y conoce la revocación.

En ese caso:

- el archivo debe preservarse;
- el trabajo no debe desaparecer;
- la autorización local debe actualizarse;
- no debe asumirse que el servidor aceptará la operación;
- no debe intentarse eludir la revocación mediante `service-role`;
- el pendiente debe permanecer en una situación recuperable conforme a la política que finalmente se apruebe.

El destino definitivo de ese trabajo sigue gobernado por:

`OFF-OPEN-001 — ABIERTO — pendiente de aprobación`.

Este documento no lo resuelve.

---

# 31. Evidencia finalizada

Una Evidence perteneciente a una `MaintenanceRevision` finalizada:

- nunca se elimina como operación de dominio;
- nunca se sobrescribe físicamente para “corregirla”;
- permanece históricamente accesible;
- conserva su categoría y contexto;
- puede ser visualmente sustituida posteriormente sin perderse.

## 31.1 Borrado de dominio vs limpieza de cache

La prohibición de eliminar Evidence finalizada no implica que todo binario local confirmado deba permanecer para siempre en el dispositivo.

Una limpieza técnica futura de una copia local reproducible es conceptualmente distinta de borrar la Evidence histórica.

Esa limpieza sólo puede realizarse bajo una política segura y sin afectar el histórico remoto.

---

# 32. Corrección de mantenimiento

Corregir un mantenimiento finalizado crea una nueva `MaintenanceRevision`.

La corrección puede:

- conservar Evidence anterior;
- agregar Evidence nueva;
- cambiar respuestas dentro de la nueva revisión;
- establecer visual replacement cuando corresponda.

No puede:

- modificar la revisión anterior;
- reescribir sus archivos;
- eliminar Evidence histórica.

Las correcciones continúan utilizando la `FormVersion` fijada al mantenimiento.

## 32.1 Significado pendiente de “conservar Evidence anterior”

“Conservar Evidence anterior” significa que una nueva revisión debe poder representar correctamente que una Evidence ya existente continúa siendo relevante para el estado efectivo del mantenimiento cuando así lo determine la política aprobada.

La frase **NO autoriza**:

- duplicar la Evidence;
- copiar su archivo y tratar la copia como nueva Evidence;
- generar una identidad nueva para la misma fotografía;
- reasignar la Evidence a la nueva revisión;
- cambiar su `Response` o revisión de origen.

La Evidence conserva:

- su identidad histórica;
- su archivo original;
- su revisión de origen;
- su replacement lineage.

La semántica exacta mediante la cual una revisión posterior determina que esa Evidence continúa formando parte de su effective Evidence set permanece abierta en `EVID-OPEN-006`.

---

# 33. Reemplazo visual

Visual replacement expresa que una Evidence nueva debe ocupar visualmente el lugar funcional de una Evidence anterior en un contexto posterior.

No expresa:

- borrado;
- update in place;
- sustitución física del archivo;
- cambio de ownership;
- reescritura de la revisión anterior.

## 33.1 Reglas obligatorias

La nueva Evidence:

- posee identidad propia;
- pertenece a la nueva revisión/contexto autorizado;
- conserva su propio archivo;
- referencia históricamente a la Evidence sustituida.

La Evidence anterior:

- conserva su archivo;
- permanece asociada a su revisión original;
- continúa accesible históricamente.

## 33.2 Alcance de la relación

Una relación de reemplazo debe ser coherente con:

- tenant;
- cliente;
- equipo;
- mantenimiento;
- contexto de campo/respuesta correspondiente.

Nunca puede apuntar a una Evidence de:

- otro tenant;
- otro cliente;
- otro mantenimiento.

Una corrección puede atravesar revisiones del mismo mantenimiento; por ello no se exige que ambas evidencias pertenezcan a la misma revisión.

## 33.3 Auditoría histórica

Debe ser posible conocer posteriormente:

- quién era la Evidence original;
- cuál la sustituyó;
- en qué revisión apareció la sustitución;
- qué originales siguen existiendo.

## 33.4 Replacement vs continuidad entre revisiones

Visual replacement y continuidad entre revisiones son conceptos diferentes.

`EVID-OPEN-004` trata cómo se interpreta una cadena de sustituciones y cuál Evidence resulta visualmente vigente.

`EVID-OPEN-006` trata qué Evidence forman parte del estado efectivo de cada `MaintenanceRevision` y cómo Evidence anteriores pueden continuar sin duplicarse.

Una decisión no sustituye a la otra.

---

# 34. Cadena de reemplazos

Puede existir conceptualmente:

**A → reemplazada visualmente por B → reemplazada posteriormente por C**

El histórico debe poder reconstruir:

- A;
- B;
- C;
- sus revisiones;
- sus relaciones.

No se permiten relaciones cíclicas que hagan imposible interpretar el histórico.

No debe destruirse A cuando aparece B ni B cuando aparece C.

Sin embargo, la baseline no define todavía:

- si se puede apuntar directamente a una Evidence ya superseded;
- si sólo puede reemplazarse la visualmente vigente;
- cómo se determina formalmente cuál es la vigente después de reemplazos sucesivos.

Esto permanece abierto mediante `EVID-OPEN-004`.

La resolución de esa vigencia visual deberá aplicarse sobre el conjunto de Evidence que corresponda a cada revisión conforme a `EVID-OPEN-006`; no define por sí sola cómo Evidence anteriores continúan entre revisiones.

---

# 35. Reemplazo y categorías `BEFORE`/`AFTER`

La categoría de una Evidence es parte de su significado funcional.

Por ello un visual replacement no puede utilizarse para cambiar silenciosamente `BEFORE` por `AFTER` ni a la inversa.

La baseline, sin embargo, no define expresamente si una nueva Evidence de categoría diferente puede reemplazar visualmente otra bajo una acción explícita.

Las alternativas tienen consecuencias distintas para:

- semántica;
- reporting before/after;
- históricos;
- UX de corrección.

La regla definitiva permanece en `EVID-OPEN-005`.

Hasta resolverla, la implementación no puede inferir que los replacements cross-category están permitidos ni prohibidos como decisión final de producto.

---

# 36. Eliminación antes de finalización

La inmutabilidad aprobada protege Evidence perteneciente a una revisión finalizada.

No existe todavía una regla aprobada equivalente para una fotografía capturada por error mientras el mantenimiento sigue en edición antes de su primera finalización.

Debe definirse si el usuario puede:

- quitar la Evidence antes de finalizar;
- eliminar su binario local si nunca fue confirmada;
- mantener alguna marca/tombstone;
- cancelar una intención de upload ya registrada.

No debe extenderse automáticamente la inmutabilidad de históricos a una captura todavía no finalizada.

Tampoco debe permitirse una eliminación que deje:

- uploads huérfanos;
- outbox inconsistente;
- required aparentemente satisfecho sin archivo.

La política permanece abierta mediante `EVID-OPEN-003`.

---

# 37. Corrección por foto equivocada

Si una fotografía equivocada ya pertenece a una revisión finalizada, la solución conceptual no es borrarla.

El flujo es:

1. iniciar corrección autorizada;
2. crear una nueva `MaintenanceRevision`;
3. agregar la nueva Evidence correcta;
4. establecer visual replacement cuando corresponda según las reglas aprobadas;
5. mantener la fotografía original en su revisión histórica.

Así se corrige la presentación vigente sin reescribir el pasado.

---

# 38. Conflictos

Evidence se integra con el modelo general de conflictos de `04`.

No se admite Last Write Wins silencioso.

Ante una divergencia crítica:

- la información local se preserva;
- la información remota relevante se preserva;
- el sistema no sobrescribe automáticamente una revisión válida;
- Evidence no desaparece como efecto colateral;
- una resolución de conflicto de mantenimiento genera una nueva `MaintenanceRevision`.

No se diseña un algoritmo de merge binario.

Las fotografías son artefactos que deben preservarse y reconciliarse mediante decisiones de dominio y metadata, no “mezclarse”.

---

# 39. Duplicados

Deben distinguirse tres casos.

## 39.1 Retry técnico de la misma Evidence

Mismo intento lógico enviado varias veces debido a retry.

Debe ser tratado mediante idempotencia y no crear Evidence lógica duplicada.

## 39.2 Selección intencional repetida

El usuario puede seleccionar intencionalmente dos veces la misma fotografía.

Mientras la cardinalidad lo permita, son intenciones de usuario diferentes y no deben fusionarse automáticamente sólo porque el contenido sea igual.

## 39.3 Imágenes visualmente similares

Dos fotografías pueden parecer iguales o casi iguales.

El MVP no realiza:

- deduplicación perceptual;
- comparación mediante IA;
- reconocimiento de contenido.

Similitud visual no prueba duplicación lógica.

---

# 40. Archivos corruptos o inaccesibles localmente

Si una Evidence pendiente conserva metadata pero el archivo local deja de ser accesible:

- no puede considerarse sincronizada;
- el error debe quedar visible;
- el sistema debe impedir una falsa confirmación;
- debe preservarse el contexto necesario para diagnóstico o recuperación;
- la situación debe poder distinguirse de un fallo temporal de red.

El sistema no puede reconstruir por inferencia un archivo que nunca llegó al servidor.

Este escenario se registra como riesgo.

---

# 41. Espacio local insuficiente

Si el dispositivo no puede almacenar durablemente una nueva fotografía:

- la captura no puede declararse exitosa;
- la UI debe informar el fallo;
- no debe generarse una falsa Evidence guardada;
- no deben eliminarse automáticamente otras fotografías pending para liberar espacio.

Pueden limpiarse posteriormente datos reproducibles bajo políticas aprobadas, pero nunca sacrificar silenciosamente trabajo pendiente.

No se introducen:

- cuotas comerciales;
- número máximo de fotografías;
- máximo funcional de MB.

---

# 42. Fallos de upload

Los uploads deben tolerar fallos e interrupciones.

Ante un fallo:

- se conserva el archivo local;
- la Evidence mantiene su identidad;
- el estado debe ser visible;
- debe poder existir retry;
- retry no crea otra Evidence lógica;
- el mantenimiento finalizado localmente permanece finalizado;
- no se elimina trabajo para “destrabar” la sincronización.

Un fallo permanente o de autorización debe distinguirse de un fallo transitorio de conectividad.

---

# 43. Conectividad

La UX de Evidence debe integrarse con la estrategia general de conectividad de `04`.

Debe mostrar información útil sobre:

- estado de conexión relevante;
- Evidence pendiente;
- fallos;
- retry;
- operaciones que todavía no convergieron.

Evidence pendiente debe contribuir al concepto de operaciones/trabajo pendiente cuando corresponda.

`navigator.onLine` no es prueba definitiva de que:

- Supabase sea accesible;
- la sesión sea válida;
- Storage acepte el upload;
- la operación esté autorizada.

---

# 44. Limpieza local posterior a confirmación

Una vez que una Evidence está remotamente confirmada, su copia binaria local puede convertirse eventualmente en candidata a limpieza técnica.

Eso no significa que deba borrarse inmediatamente.

Antes de cualquier limpieza deben preservarse:

- metadata necesaria;
- histórico;
- asociación remota válida;
- capacidad de acceso autorizado al contenido remoto;
- dependencias locales todavía existentes.

Nunca son candidatos a limpieza automática por esta regla:

- Evidence pending;
- uploads incompletos;
- Evidence involucrada en conflicto cuando el archivo local siga siendo necesario;
- archivos cuya confirmación remota sea dudosa.

## 44.1 Revocación

La limpieza de copias sincronizadas pertenecientes a un cliente cuyo acceso fue revocado continúa sujeta a `OFF-OPEN-002`.

## 44.2 Retención

Este documento no fija:

- días de retención local;
- tamaño de cache;
- algoritmo LRU;
- umbrales de espacio.

La estrategia de cleanup posterior a confirmación es candidata a ADR.

---

# 45. Evidence y `FormVersion` histórica

La configuración de Evidence pertenece a la `FormVersion` utilizada.

Debe permanecer interpretable históricamente:

- si Evidence estaba habilitada;
- categorías permitidas;
- required/optional;
- fuentes permitidas;
- cualquier otra configuración funcional aprobada.

Una nueva publicación no modifica:

- required del mantenimiento existente;
- categorías históricas;
- fuentes configuradas;
- trabajo ya iniciado.

No existe repinning automático a una nueva `FormVersion`.

---

# 46. Evidence y `MaintenanceRevision`

Cada revisión debe permitir determinar de manera inequívoca qué Evidence forman parte de su estado histórico y, una vez aprobada la política correspondiente, cuál es su effective Evidence set.

No es suficiente mantener una única “lista actual” mutable de fotografías del mantenimiento.

## 46.1 Ambigüedad de continuidad

Ejemplo conceptual:

**Revision 1**

- `Response A`;
- `Evidence BEFORE X`.

Posteriormente se crea **Revision 2** para corregir otro campo del mantenimiento y la corrección no modifica intencionalmente esa Evidence.

La baseline no define todavía si, para interpretar Revision 2, `Evidence X`:

- forma automáticamente parte de su estado efectivo;
- debe ser referenciada explícitamente como Evidence conservada;
- se deriva recorriendo el historial de revisiones y cambios;
- o deja de formar parte del estado vigente aunque siga existiendo históricamente.

Esa ambigüedad se formaliza en `EVID-OPEN-006`.

## 46.2 Invariantes mientras la decisión permanece abierta

Aunque la semántica de continuidad no está aprobada, sí quedan prohibidas decisiones silenciosas que:

- dupliquen `Evidence X` para “copiarla” a Revision 2;
- creen una nueva identidad para la misma fotografía sin una nueva captura real;
- cambien la revisión histórica de origen de `Evidence X`;
- reasignen `Evidence X` a otra `Response`;
- ignoren `Evidence X` por defecto sin una política aprobada;
- dependan de una lista mutable global para definir el estado de todas las revisiones.

## 46.3 Origen y estado efectivo

Una Evidence debe tener una sola revisión de origen: aquella en la que fue creada como nueva Evidence.

Que pueda seguir formando parte del estado efectivo de revisiones posteriores no debe alterar ese origen histórico.

Nuevas Evidence creadas durante Revision 2 pertenecen a Revision 2.

La forma conceptual definitiva de expresar la continuidad de Evidence anteriores debe resolverse mediante `EVID-OPEN-006` antes de Fase 5.

## 46.4 Interacción con replacements

Un replacement creado en una revisión posterior puede modificar cuál Evidence se presenta como visualmente vigente desde ese contexto en adelante, conforme a `EVID-OPEN-004/005`.

Eso no reescribe el estado histórico de revisiones anteriores y tampoco resuelve por sí solo qué Evidence anteriores forman parte del effective Evidence set de la revisión posterior.

---

# 47. Evidence y reporting

Evidence puede formar parte de informes.

Esta especificación sólo fija la frontera.

El futuro reporting podrá:

- seleccionar fotografías;
- presentar `BEFORE`/`AFTER`;
- utilizar relaciones de replacement;
- incluir contexto histórico.

Pero `07-reporting-engine-spec.md` deberá definir:

- reglas de selección;
- layout;
- presentación;
- snapshots;
- tratamiento de replacement dentro del informe.

## 47.1 Consumo por revisión

Reporting deberá consumir el conjunto de Evidence correspondiente a la `MaintenanceRevision` seleccionada.

`07-reporting-engine-spec.md` no debe inventar por su cuenta cómo se determina ese conjunto.

La semántica de continuidad deberá provenir de la resolución aprobada de `EVID-OPEN-006`, combinada con las decisiones aplicables de replacements.

## 47.2 Snapshot

Una `ReportVersion` finalizada debe conservar el contexto necesario para que una corrección posterior no altere retroactivamente su resultado.

Una corrección de mantenimiento posterior no modifica un informe finalizado previo.

No se diseña PDF ni DOCX en este documento.

---

# 48. Evidence y IA

IA sobre imágenes está **FUERA DEL MVP**.

El sistema MVP no utiliza Evidence para:

- clasificación automática;
- detección de daños;
- reconocimiento de objetos;
- captions automáticos;
- comparación automática `BEFORE`/`AFTER`;
- OCR automático como feature;
- deduplicación perceptual;
- edición generativa;
- inferencia técnica;
- consumo de créditos IA por procesamiento de fotografías.

La IA del MVP continúa limitada a asistencia textual para informes.

Las fotografías no se envían a IA en el MVP.

---

# 49. Privacidad y datos sensibles

Las fotografías pueden contener información sensible o potencialmente regulada, por ejemplo:

- personas;
- rostros;
- matrículas;
- documentación;
- información industrial;
- instalaciones privadas;
- datos visibles en pantallas;
- ubicaciones sensibles;
- procedimientos internos.

Esto implica riesgos de:

- acceso no autorizado;
- permanencia local;
- exposición por dispositivo compartido;
- exposición mediante URLs;
- retención inadecuada;
- inclusión no deseada en informes.

Este documento no inventa:

- base legal;
- consentimiento;
- plazos legales de retención;
- reglas regulatorias;
- obligación de difuminar rostros o matrículas.

`DO-T07` permanece **DIFERIDO** y debe resolverse conforme a la validación legal/contractual prevista antes del piloto.

La arquitectura debe permitir aplicar posteriormente las políticas aprobadas sin destruir los invariantes históricos del sistema.

---

# 50. Seguridad

## 50.1 Tenant isolation

Toda Evidence es tenant-owned y debe mantener el aislamiento de `03`.

Un actor de tenant no puede leer ni modificar Evidence de otra empresa.

## 50.2 Client scope

Cuando el actor está limitado por cliente, el acceso a Evidence se deriva del mantenimiento/response real y no de un `client_id` suministrado de forma independiente.

## 50.3 Storage no es autorización

No constituyen autorización:

- nombre de bucket;
- path;
- UUID;
- nombre del archivo;
- URL conocida;
- URL previamente obtenida.

Conocer dónde está un archivo no concede derecho a leerlo.

## 50.4 Fronteras futuras

El acceso remoto deberá quedar protegido conceptualmente mediante:

- RLS sobre datos estructurados;
- autorización del backend cuando corresponda;
- políticas adecuadas de Storage;
- comprobación de ownership;
- scopes de soporte cuando correspondan.

No se diseñan aquí políticas ejecutables.

## 50.5 `service-role`

No debe exponerse `service-role` al cliente.

Tampoco debe utilizarse en el frontend ni como bypass de permisos de usuario, revocación o aislamiento tenant.

## 50.6 Replacements

Una relación de replacement cross-tenant es siempre inválida.

También debe rechazarse un replacement que utilice una Evidence de otro cliente o mantenimiento como objetivo.

---

# 51. Integridad referencial

Una Evidence debe considerarse conceptualmente inválida si existe incoherencia entre cualquiera de estas dimensiones:

- tenant;
- client;
- equipment;
- maintenance;
- revision/contexto;
- response;
- `FormField`;
- `FormVersion`;
- replacement target.

## 51.1 Response

La `Response` debe corresponder al mantenimiento y revisión correctos.

## 51.2 Form field

El campo debe pertenecer a la `FormVersion` exacta fijada al mantenimiento.

No se puede utilizar un campo de una versión posterior porque tenga el mismo label.

## 51.3 Replacement

El target debe pertenecer al mismo dominio autorizado de mantenimiento.

La coherencia exacta de categoría queda pendiente en `EVID-OPEN-005`.

## 51.4 Implementación futura

Estas invariantes deberán quedar protegidas mediante las defensas físicas apropiadas posteriormente.

Este documento no define foreign keys.

---

# 52. Históricos

El sistema debe conservar información suficiente para reconstruir, para cada revisión y contexto:

- qué Evidence se originaron en esa revisión;
- qué Evidence anteriores continúan formando parte de su estado efectivo conforme a la política que se apruebe en `EVID-OPEN-006`;
- qué archivo representa cada Evidence;
- categoría `BEFORE`/`AFTER`;
- `Response` y revisión de origen;
- `FormField`;
- `FormVersion`;
- orden cuando aplique;
- Evidence superseded;
- relaciones de replacement;
- replacement lineage completo;
- Evidence originales;
- cuál era visualmente vigente en cada contexto conforme a `EVID-OPEN-004/005`.

La revisión de origen de una Evidence nunca debe perderse porque la misma fotografía continúe siendo relevante en revisiones posteriores.

Además debe conservarse suficiente información para que la política aprobada de continuidad pueda reconstruir el effective Evidence set de cada revisión de manera determinista.

No debe utilizarse como única fuente histórica:

- una lista mutable actual;
- metadata sobrescrita;
- archivo reemplazado in place;
- definición actual del formulario.

---

# 53. UX de captura

La UX debe priorizar claridad sobre el estado real del trabajo.

Principios:

- distinguir visualmente `BEFORE` y `AFTER`;
- indicar cuál categoría se está capturando;
- mostrar feedback sólo después de persistencia local exitosa;
- distinguir local/pending de remotely confirmed;
- mostrar error de upload;
- permitir retry cuando corresponda;
- evitar pérdida accidental;
- informar si una fotografía no pudo persistirse;
- no afirmar “subida”, “sincronizada” o equivalente mientras sólo exista localmente;
- mantener visibles las fotografías pendientes después de reabrir la aplicación;
- evitar exponer detalles técnicos innecesarios de la outbox.

Cuando Evidence sea required, la UI debe permitir entender qué categoría continúa incumplida conforme a la cardinalidad finalmente aprobada.

---

# 54. UX de corrección

En una corrección debe quedar claro que:

- una fotografía histórica finalizada no se borra;
- agregar otra fotografía crea otra Evidence;
- la nueva Evidence pertenece a una nueva revisión;
- replacement es una acción visual/histórica;
- el original permanece disponible históricamente.

La UX no debe presentar replacement como “editar archivo” o “borrar fotografía anterior”.

Si existe una cadena de reemplazos, la presentación futura deberá respetar la política que se apruebe en `EVID-OPEN-004`.

La UX tampoco debe implicar que conservar una Evidence previa entre revisiones significa duplicarla o volver a capturarla; el comportamiento definitivo deberá seguir `EVID-OPEN-006`.

---

# 55. Accesibilidad y contexto visual

La experiencia debe ser utilizable sin depender exclusivamente de color o miniaturas.

Principios mínimos:

- acciones de cámara/galería con nombres comprensibles;
- categoría `BEFORE`/`AFTER` expresada también mediante texto;
- estados pending/sync/error expresados con texto o semántica accesible, no sólo color;
- controles de retry y corrección identificables;
- navegación y foco coherentes;
- contexto textual suficiente para relacionar la fotografía con su campo;
- thumbnails que no sean el único mecanismo para saber qué evidencia se está manipulando.

Este documento no introduce:

- dibujo sobre fotografías;
- anotación avanzada;
- cropping funcional obligatorio;
- edición fotográfica;
- filtros;
- OCR;
- captions automáticos.

---

# 56. Testing futuro obligatorio

La implementación futura deberá disponer de pruebas que cubran, como categorías mínimas:

- configuración de Evidence;
- configuración sin fotos;
- `BEFORE`;
- `AFTER`;
- `BEFORE + AFTER`;
- optional;
- required;
- required por categoría;
- cámara;
- galería;
- persistencia local durable;
- fallo de persistencia;
- cierre y reapertura de aplicación;
- reinicio del dispositivo;
- upload pending;
- upload interrumpido;
- retry;
- idempotencia;
- respuesta remota perdida;
- confirmación remota válida;
- fallo de upload;
- finalización local con Evidence pendiente;
- logout;
- aislamiento por identidad;
- cambio usuario A → B;
- revocación;
- expiración de autorización offline;
- regla de 7 días;
- correcciones;
- corrección que no cambia Evidence;
- continuidad o no de Evidence anterior conforme a la regla que se apruebe;
- no duplicación de una misma Evidence entre revisiones;
- preservación de la revisión de origen;
- Evidence nueva en una revisión posterior;
- Evidence nueva en corrección;
- visual replacement;
- replacement creado en una revisión posterior;
- preservation del original;
- replacement chain;
- reconstrucción del effective Evidence set de cada revisión;
- required en una corrección conforme a `EVID-OPEN-001/006`;
- reconstrucción histórica;
- conflictos;
- ausencia de Last Write Wins;
- tenant isolation;
- client isolation;
- rechazo cross-tenant;
- rechazo cross-maintenance;
- Storage authorization boundary;
- cleanup posterior a confirmación;
- no-cleanup de pending;
- espacio local insuficiente;
- archivo corrupto/inaccesible;
- configuración histórica de `FormVersion`;
- nueva publicación sin repinning;
- interacción con `FORM-OPEN-001` una vez resuelta;
- cardinalidad conforme a `EVID-OPEN-001/002` una vez aprobadas;
- comportamiento pre-finalización conforme a `EVID-OPEN-003`;
- cadena y vigencia visual conforme a `EVID-OPEN-004`;
- categorías de replacement conforme a `EVID-OPEN-005`;
- continuidad entre revisiones conforme a `EVID-OPEN-006`.

Esta sección define categorías de prueba, no casos ejecutables ni código.

---

# 57. Anti-patrones prohibidos

Quedan expresamente prohibidos:

- modelar Evidence como adjunto genérico del mantenimiento;
- fusionar campo `image` y Evidence;
- aplicar `FORM-OPEN-003` como cardinalidad de Evidence;
- guardar una fotografía sólo en memoria antes de upload;
- depender del upload para guardar/finalizar el mantenimiento;
- considerar preview local temporal como persistencia durable;
- eliminar archivo local antes de confirmación remota válida;
- considerar upload iniciado como confirmación remota;
- considerar bytes parcialmente transferidos como confirmación;
- generar una nueva Evidence lógica en cada retry;
- cambiar identidad de Evidence entre reintentos;
- borrar Evidence finalizada;
- reemplazar archivo finalizado in place;
- eliminar el original al realizar visual replacement;
- modificar la revisión histórica donde nació el original;
- duplicar una Evidence para “copiarla” a una revisión nueva;
- copiar el mismo binario como una nueva Evidence sólo para representar continuidad entre revisiones;
- cambiar la revisión histórica de origen de una Evidence;
- hacer desaparecer Evidence previa del estado efectivo por ausencia de una regla explícita;
- obligar a recapturar fotografías en toda corrección por falta de un modelo de continuidad;
- cross-tenant replacement;
- cross-client replacement;
- cross-maintenance replacement;
- interpretar URL, path o ID como autorización;
- exponer `service-role` en cliente;
- usar `service-role` para saltar una revocación;
- Last Write Wins silencioso;
- eliminar Evidence local al aparecer un conflicto;
- invalidar trabajo iniciado sólo porque apareció una nueva `FormVersion`;
- repinning automático del mantenimiento;
- deduplicación perceptual;
- IA sobre fotografías;
- OCR automático como feature;
- límites comerciales inventados de cantidad, tamaño o formato;
- borrar pending para liberar espacio;
- borrar outbox al logout;
- procesar archivos de una identidad con la sesión de otra;
- confiar sólo en `navigator.onLine`;
- usar el timestamp remoto como momento real de captura;
- usar metadata actual mutable como única fuente para reconstruir históricos;
- utilizar una lista mutable global como sustituto del estado de Evidence por revisión;
- inferir que una Evidence `AFTER` reemplaza una `BEFORE` por orden temporal;
- resolver silenciosamente las `EVID-OPEN-*`.

---

# 58. Riesgos

## `EVID-RSK-001` — Pérdida de archivo antes de upload

**Impacto:** metadata existente sin contenido recuperable o pérdida irreversible del trabajo.

**Tratamiento conceptual:** persistencia durable antes de éxito y conservación hasta confirmación remota.

## `EVID-RSK-002` — Duplicado por retry

**Impacto:** varias Evidence lógicas para una única intención.

**Tratamiento:** identidad estable e idempotencia extremo a extremo.

## `EVID-RSK-003` — Evidence huérfana

**Impacto:** archivo o metadata sin asociación recuperable a Response/revisión.

**Tratamiento:** dependencias explícitas y confirmación de asociación.

## `EVID-RSK-004` — Evidence asociada a `Response` equivocada

**Impacto:** histórico técnicamente válido pero semánticamente falso.

**Tratamiento:** ownership encadenado e integridad entre mantenimiento, revisión, campo y respuesta.

## `EVID-RSK-005` — Exposición cross-tenant

**Impacto:** incidente crítico de confidencialidad.

**Tratamiento:** tenant isolation, RLS futura, políticas Storage y pruebas negativas.

## `EVID-RSK-006` — Replacement destructivo

**Impacto:** imposibilidad de reconstruir la revisión original.

**Tratamiento:** relación histórica aditiva; nunca update/delete del original.

## `EVID-RSK-007` — Categoría `BEFORE`/`AFTER` incorrecta

**Impacto:** interpretación técnica y reporting incorrectos.

**Tratamiento:** categoría explícita, UX clara y prohibición de inferirla sólo por timestamps.

## `EVID-RSK-008` — Required ambiguo

**Impacto:** distintos clientes/dispositivos podrían finalizar con reglas diferentes.

**Tratamiento:** resolver `EVID-OPEN-001` antes de implementar Fase 5.

## `EVID-RSK-009` — Cardinalidad ambigua

**Impacto:** UX, validación y modelo físico inconsistentes.

**Tratamiento:** resolver `EVID-OPEN-001/002`.

## `EVID-RSK-010` — Espacio local insuficiente

**Impacto:** imposibilidad de persistir nuevas fotografías.

**Tratamiento:** fallo visible, no declarar éxito y no borrar pendientes automáticamente.

## `EVID-RSK-011` — Archivo corrupto o inaccesible

**Impacto:** Evidence pendiente imposible de sincronizar.

**Tratamiento:** estado de error recuperable y prohibición de falsa confirmación.

## `EVID-RSK-012` — Revocación con Evidence pendiente

**Impacto:** trabajo legítimamente capturado sin ruta aprobada de destino.

**Tratamiento:** preservar y aplicar `OFF-OPEN-001`; no bypass de autorización.

## `EVID-RSK-013` — Limpieza local prematura

**Impacto:** pérdida de único binario disponible.

**Tratamiento:** sólo limpiar después de confirmación válida y sin dependencias pendientes.

## `EVID-RSK-014` — Reloj de dispositivo incorrecto

**Impacto:** timestamps de captura engañosos.

**Tratamiento:** distinguir momentos, no asumir autoridad absoluta del reloj y no derivar categoría del timestamp.

## `EVID-RSK-015` — Cadena de replacement inconsistente

**Impacto:** imposibilidad de determinar presentación vigente.

**Tratamiento:** relaciones acíclicas, histórico conservado y resolución de `EVID-OPEN-004`.

## `EVID-RSK-016` — Confusión `image` / Evidence

**Impacto:** validaciones, cardinalidad y reporting incorrectos.

**Tratamiento:** separación conceptual y de dominio obligatoria.

## `EVID-RSK-017` — Privacidad de fotografías

**Impacto:** exposición de personas, documentos o información industrial sensible.

**Tratamiento:** aislamiento, minimización de accesos y deferencia a `DO-T07`.

## `EVID-RSK-018` — Upload parcial

**Impacto:** sistema cree erróneamente que el archivo remoto está completo.

**Tratamiento:** confirmación remota más fuerte que inicio/transferencia parcial.

## `EVID-RSK-019` — Usuario equivocado sincroniza Evidence

**Impacto:** fuga de datos y autoría incorrecta.

**Tratamiento:** réplica aislada por identidad y outbox procesable sólo bajo su propietario.

## `EVID-RSK-020` — Nueva FormVersion altera validación histórica

**Impacto:** mantenimiento existente cambia de requisitos retroactivamente.

**Tratamiento:** pinning de `FormVersion` y configuración histórica inmutable.

## `EVID-RSK-021` — Eliminación pre-finalización inconsistente

**Impacto:** archivo huérfano, required falso o outbox inválida.

**Tratamiento:** resolver `EVID-OPEN-003` antes de implementación.

## `EVID-RSK-022` — Replacement cross-category semánticamente incorrecto

**Impacto:** before/after deja de ser interpretable.

**Tratamiento:** resolver `EVID-OPEN-005` y validar explícitamente la política aprobada.

## `EVID-RSK-023` — Continuidad inconsistente entre revisiones

**Impacto:** una misma Evidence puede duplicarse, desaparecer del estado efectivo, perder su revisión de origen o ser interpretada de forma diferente por captura, históricos y reporting; required puede evaluarse de manera contradictoria entre revisiones.

**Tratamiento:** resolver `EVID-OPEN-006` antes de Fase 5 y exigir que la implementación conserve identidad, origen histórico y una reconstrucción inequívoca del effective Evidence set.

---

# 59. Decisiones candidatas a ADR

Este documento no genera ADRs.

Identifica los siguientes candidatos:

## `EVID-ADR-CAND-001` — Lifecycle local/remoto de Evidence

Documentar:

- persistencia local;
- outbox;
- upload;
- asociación;
- confirmación;
- retry;
- recovery.

## `EVID-ADR-CAND-002` — Identidad estable e idempotencia

Documentar cómo una Evidence conserva identidad única desde la captura local hasta su representación remota.

## `EVID-ADR-CAND-003` — Estrategia de upload

Documentar la coordinación entre:

- binario;
- metadata;
- dependencias;
- fallos parciales;
- confirmación.

Sin fijarla en este documento.

## `EVID-ADR-CAND-004` — Modelo de visual replacement histórico

Documentar la representación de replacement una vez resueltas `EVID-OPEN-004/005`.

## `EVID-ADR-CAND-005` — Storage authorization boundary

Documentar cómo metadata de dominio y Storage mantienen el mismo ownership sin usar paths como permiso.

## `EVID-ADR-CAND-006` — Cleanup posterior a confirmación

Documentar elegibilidad de binarios locales reproducibles, preservando pending, conflictos y `OFF-OPEN-002`.

## `EVID-ADR-CAND-007` — Representación de `BEFORE`/`AFTER`

Documentar cómo las categorías se representan de manera explícita y estable sin inferirse desde timestamps.

## `EVID-ADR-CAND-008` — Modelo de continuidad/membresía efectiva de Evidence entre `MaintenanceRevision`

Documentar, una vez resuelta `EVID-OPEN-006`, cómo cada revisión determina su effective Evidence set preservando identidad única, revisión de origen e histórico sin duplicar binarios ni Evidence lógicas.

No se genera ninguno de estos ADRs en Fase 0 mediante este documento.

---

# 60. Decisiones abiertas nuevas

Se identifican seis decisiones nuevas realmente necesarias para cerrar la implementación de Evidence.

Todas:

- no bloquean Fase 1;
- permanecen pendientes;
- no están aprobadas por aparecer en este documento.

## 60.1 `EVID-OPEN-001` — Cardinalidad de una categoría required

**Motivo:** la baseline define Evidence required, pero no especifica cuántas fotografías satisfacen una categoría requerida.

**Alternativas:**

1. al menos una Evidence por categoría required;
2. exactamente una Evidence;
3. cantidad mínima configurable;
4. cardinalidad configurable más amplia.

**Evaluación:** la alternativa “al menos una” mantiene la semántica required simple y evita introducir configuración adicional, pero constituye una decisión funcional que no puede aprobarse por inferencia.

**Recomendación:** preferir **al menos una Evidence por categoría required**, siempre separando `BEFORE` y `AFTER` cuando la configuración sea BOTH.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5.

---

## 60.2 `EVID-OPEN-002` — Multiplicidad de Evidence por categoría

**Motivo:** la baseline no define si una categoría puede contener múltiples fotografías. La ausencia de límite comercial no equivale por sí sola a aprobar multiplicidad funcional.

**Alternativas:**

1. máximo una Evidence por categoría;
2. múltiples Evidence por categoría sin máximo funcional de producto;
3. cantidad configurable por campo;
4. una política diferente para optional y required.

**Evaluación:** permitir múltiples fotografías ofrece flexibilidad para mantenimiento técnico sin convertir una limitación de Storage en regla de producto. La cantidad configurable agregaría complejidad al builder.

**Recomendación:** permitir **múltiples Evidence por categoría**, sin un máximo funcional/comercial propio del MVP; las restricciones físicas inevitables se documentarían técnicamente.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5.

**Relación:** independiente de `FORM-OPEN-003`, que continúa gobernando únicamente el campo `image`.

---

## 60.3 `EVID-OPEN-003` — Eliminación durante captura no finalizada

**Motivo:** la baseline prohíbe borrar Evidence finalizada, pero no define qué puede hacer el usuario ante una fotografía equivocada antes de finalizar la revisión.

**Alternativas:**

1. permitir quitarla antes de finalización y eliminar su binario/intención cuando nunca haya quedado incorporada a una revisión finalizada;
2. permitir quitarla de la UX pero conservar tombstone local;
3. prohibir toda eliminación desde el momento de captura;
4. política distinta según exista o no intento remoto previo.

**Evaluación:** prohibir toda eliminación haría costosa una equivocación común de captura; permitir eliminación sin coordinación con outbox puede producir huérfanos.

**Recomendación:** permitir **quitar Evidence antes de finalización**, preservando la consistencia del contexto y de cualquier intención de sincronización; la estrategia física de tombstone/cancelación deberá definirse posteriormente.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5.

---

## 60.4 `EVID-OPEN-004` — Cadena de replacements y determinación de vigencia visual

**Motivo:** la baseline permite visual replacement, pero no define cómo se interpreta una secuencia A → B → C.

**Alternativas:**

1. permitir reemplazar únicamente la Evidence visualmente vigente;
2. permitir target a cualquier Evidence histórica y resolver una cadena lineal;
3. permitir múltiples ramas y aplicar una regla de prioridad;
4. limitar el MVP a un solo replacement por Evidence original.

**Evaluación:** una cadena lineal reduce ambigüedad y facilita reconstrucción histórica. Las ramas introducirían una semántica adicional no requerida.

**Recomendación:** utilizar una **cadena lineal**, haciendo que una sustitución posterior parta de la Evidence visualmente vigente y preservando todos los predecesores.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5.

---

## 60.5 `EVID-OPEN-005` — Categoría en visual replacement

**Motivo:** la baseline no establece si una Evidence `AFTER` puede reemplazar visualmente una `BEFORE` o viceversa.

**Alternativas:**

1. replacement sólo entre evidencias de la misma categoría;
2. permitir cambio explícito de categoría en una corrección;
3. permitir cualquier categoría y delegar presentación a reporting.

**Evaluación:** permitir replacement cross-category debilita la interpretación de before/after y puede volver ambiguo el histórico.

**Recomendación:** exigir que un visual replacement **conserve la categoría `BEFORE`/`AFTER` de la Evidence sustituida**.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5.

---

## 60.6 `EVID-OPEN-006` — Continuidad de Evidence entre MaintenanceRevision

**Motivo:** definir cómo una nueva `MaintenanceRevision` representa Evidence ya existente que continúa siendo válida en el estado efectivo del mantenimiento sin destruir:

- identidad original;
- revisión de origen;
- histórico;
- replacement lineage.

Debe quedar claro que:

- conservar Evidence **NO** significa copiar el archivo;
- conservar Evidence **NO** significa crear una Evidence nueva;
- conservar Evidence **NO** significa reasignar su revisión histórica de origen;
- una revisión nueva debe poder determinar de manera inequívoca cuál es su effective Evidence set;
- el histórico debe seguir indicando dónde nació cada Evidence.

**Alternativas:**

### Alternativa A — continuidad/inheritance por referencia

La nueva revisión puede considerar Evidence anteriores como parte de su estado efectivo mediante una referencia o semántica de continuidad, conservando:

- la misma identidad de Evidence;
- su revisión original;
- su archivo original.

No se duplica la Evidence.

### Alternativa B — derivación mediante historial/deltas

La revisión nueva almacena únicamente cambios y el effective Evidence set se reconstruye recorriendo conceptualmente:

- revisiones anteriores;
- altas de Evidence;
- replacements;
- demás relaciones aprobadas.

No se define event sourcing concreto ni representación física.

### Alternativa C — snapshot explícito de membresía

Cada revisión define explícitamente qué Evidence forman parte de su estado efectivo, pudiendo referenciar Evidence originadas en revisiones anteriores sin duplicarlas.

La representación física de esa membresía no se define aquí.

### Alternativa D — duplicar Evidence en cada revisión

Crear otra Evidence o copiar el archivo para cada nueva revisión.

Riesgos principales:

- identidades duplicadas para la misma fotografía;
- históricos ambiguos;
- almacenamiento innecesario;
- replacement lineage más complejo;
- pérdida de trazabilidad de origen;
- posibilidad de que distintos componentes interpreten distintas copias como la “real”.

No se recomienda salvo una justificación extraordinaria futura.

**Evaluación:** la solución debe preservar una única identidad histórica por Evidence y permitir reconstruir de forma inequívoca el estado efectivo de cualquier revisión. Tanto una membresía explícita por revisión mediante referencias inmutables como una derivación histórica determinista pueden satisfacer esos principios sin duplicar Evidence.

**Recomendación — PROPUESTA PENDIENTE DE APROBACIÓN:** priorizar un modelo conceptual donde:

- una Evidence posee una sola identidad histórica;
- una Evidence conserva su revisión de origen;
- una nueva revisión puede mantener Evidence anteriores dentro de su estado efectivo **sin copiar binarios ni crear nuevas Evidence**;
- debe existir una forma inequívoca de reconstruir el effective Evidence set de cada revisión;
- nuevas Evidence pertenecen a la revisión donde fueron creadas;
- visual replacement modifica la presentación efectiva posterior pero no reescribe revisiones anteriores;
- una Evidence superseded sigue existiendo históricamente;
- no se depende de una “lista actual mutable” global;
- se prioriza **membership explícito por revisión mediante referencias inmutables** o, si el diseño posterior demuestra ventajas claras, una **derivación histórica determinista**, sin decidir todavía estructura física.

**Estado:** **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 5.

**Interacción con `EVID-OPEN-004`:** `EVID-OPEN-004` determina la cadena A → B → C y cómo conocer la Evidence visualmente vigente; `EVID-OPEN-006` determina qué Evidence forman parte del estado efectivo de cada revisión y cómo continúan Evidence anteriores sin duplicación. Interactúan, pero no se fusionan.

**Interacción con required:** una corrección sólo podrá determinar si Evidence anterior continúa satisfaciendo required una vez combinadas la cardinalidad aprobada en `EVID-OPEN-001`, la continuidad aprobada en `EVID-OPEN-006` y las reglas de replacement aprobadas en `EVID-OPEN-004/005`.

---

# 61. Decisiones previas preservadas

Este documento no reevalúa ni resuelve decisiones previas.

## 61.1 `DM-OPEN-*`

| ID | Estado preservado | Resolver antes de |
|---|---|---|
| `DM-OPEN-001` | **ABIERTA** | Fase 3 |
| `DM-OPEN-002` | **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** | Fase 4 |
| `DM-OPEN-003` | **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** | Fase 4 / antes de Fase 5 |
| `DM-OPEN-004` | **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** | Fase 4 |
| `DM-OPEN-005` | **ABIERTA** | Fase 6 |
| `DM-OPEN-006` | **ABIERTA** | Fase 6 |
| `DM-OPEN-007` | **ABIERTA** | Fase 7 |
| `DM-OPEN-008` | **ABIERTA** | Fase 6 |

No se modifican sus motivos, recomendaciones existentes ni deadlines.

## 61.2 `FORM-OPEN-*`

| ID | Tema | Estado preservado | Resolver antes de |
|---|---|---|---|
| `FORM-OPEN-001` | respuestas al ocultarse | **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** | Fase 4 / Fase 5 |
| `FORM-OPEN-002` | tablas/matrices | **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** | Fase 4 |
| `FORM-OPEN-003` | cardinalidad de `image` | **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** | Fase 4 / Fase 5 |
| `FORM-OPEN-004` | inicio offline con versión desactualizada | **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** | Fase 5 |
| `FORM-OPEN-005` | fuentes comparables de condición | **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** | Fase 4 |
| `FORM-OPEN-006` | nesting/compuestos | **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** | Fase 4 |
| `FORM-OPEN-007` | required para checkbox | **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** | Fase 4 / antes de Fase 5 |
| `FORM-OPEN-008` | multiplicidad de condiciones | **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** | Fase 4 |

`FORM-OPEN-003` continúa exclusivamente sobre el campo `image`.

Este documento no la utiliza para decidir Evidence.

## 61.3 `DO-T03`

**Estado:** **PARCIALMENTE ABIERTO**.

No se resuelve.

La propuesta técnica heredada continúa pendiente de aprobación.

## 61.4 `DO-T04`

**Estado:** **PROPUESTA PENDIENTE DE APROBACIÓN**.

No se resuelve.

La Evidence local queda sometida a la futura política aprobada de protección de persistencia por identidad.

## 61.5 `OFF-OPEN-001`

**Estado:** **ABIERTO — pendiente de aprobación**.

Tema: destino de trabajo pendiente después de una revocación.

No se resuelve.

## 61.6 `OFF-OPEN-002`

**Estado:** **ABIERTO — pendiente de aprobación**.

Tema: conservación/purga local de datos sincronizados correspondientes a alcance revocado.

No se resuelve.

## 61.7 `DO-075`

**Estado:** **RESUELTA/APROBADA**.

Se conserva:

- máximo offline de 7 días desde última validación online;
- vencido el plazo no se inician nuevas operaciones;
- se requiere revalidación;
- revocación conocida se aplica al reconectar;
- trabajo ya capturado no se elimina.

No se reabre.

---

# 62. Gate del documento

## 62.1 Contradicciones bloqueantes

**No se detectan contradicciones bloqueantes conocidas** entre:

- `01-product-definition.md`;
- `02-domain-model.md`;
- `03-permissions-rls-strategy.md`;
- `04-offline-sync-strategy.md`;
- `05-form-engine-spec.md`;

que impidan continuar la documentación de Fase 0.

En particular:

- `Evidence` permanece distinta de `image`;
- Evidence pertenece a `Response`;
- `TECHNICIAN` conserva ejecución inicial autorizada;
- `COMPANY_ADMIN` no obtiene ejecución inicial;
- ambos conservan corrección según su alcance aprobado;
- finalización local y sync permanecen independientes;
- revisiones históricas no se sobrescriben;
- Evidence finalizada no se borra;
- replacement conserva originales;
- RLS continúa como frontera primaria de aislamiento remoto;
- local replica continúa aislada por identidad;
- DO-075 continúa cerrada.

La continuidad entre revisiones no constituye una contradicción de la baseline, sino una ambigüedad funcional pendiente formalizada como `EVID-OPEN-006`.

## 62.2 Nuevas decisiones abiertas

Quedan abiertas:

- `EVID-OPEN-001` — cardinalidad required;
- `EVID-OPEN-002` — multiplicidad por categoría;
- `EVID-OPEN-003` — eliminación pre-finalización;
- `EVID-OPEN-004` — cadena y vigencia visual de replacements;
- `EVID-OPEN-005` — categoría en replacement;
- `EVID-OPEN-006` — Continuidad de Evidence entre MaintenanceRevision.

Todas se encuentran:

**ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

Ninguna bloquea Fase 1.

Deben resolverse antes de implementar la capacidad correspondiente en Fase 5.

## 62.3 Candidatos a ADR

Se identifican, sin generarlos:

- lifecycle local/remoto de Evidence;
- identidad estable e idempotencia;
- estrategia de upload;
- visual replacement histórico;
- Storage authorization boundary;
- cleanup local posterior a confirmación;
- representación de `BEFORE`/`AFTER`;
- modelo de continuidad/membresía efectiva de Evidence entre `MaintenanceRevision`.

## 62.4 Riesgos principales

Los riesgos de mayor impacto arquitectónico son:

- pérdida del único archivo local antes de upload;
- exposición cross-tenant;
- Evidence asociada a Response incorrecta;
- duplicados por retry;
- required/cardinalidad ambigua;
- replacement destructivo;
- cadena de replacement inconsistente;
- continuidad inconsistente entre revisiones;
- revocación con pendientes;
- cleanup prematuro;
- confusión `image`/Evidence;
- privacidad de fotografías;
- falso éxito ante upload parcial.

## 62.5 Estado documental

**Estado de `06-maintenance-evidence-spec.md`: APROBADO — especificación conceptual y funcional del sistema de evidencias fotográficas de mantenimiento del MVP.**

**Ruta normativa/objetivo:** `docs/product/06-maintenance-evidence-spec.md`.

## 62.6 Estado de Fase 0

**Estado de Fase 0: EN CURSO.**

Este documento no cierra la Fase 0.

## 62.7 Alcance de la aprobación

La aprobación de `06-maintenance-evidence-spec.md`:

- **NO autoriza implementación**;
- **NO autoriza Supabase Storage**;
- **NO autoriza crear buckets**;
- **NO autoriza definir paths de Storage**;
- **NO autoriza SQL**;
- **NO autoriza tablas PostgreSQL**;
- **NO autoriza migrations**;
- **NO autoriza RLS ejecutable**;
- **NO autoriza políticas Storage ejecutables**;
- **NO autoriza Dexie**;
- **NO autoriza schema IndexedDB**;
- **NO autoriza React**;
- **NO autoriza cámara/file picker concretos**;
- **NO autoriza procesamiento o compresión concreta de imágenes**;
- **NO autoriza APIs**;
- **NO autoriza Server Actions**;
- **NO autoriza Codex**;
- **NO genera ADRs**;
- **NO resuelve automáticamente `EVID-OPEN-001..006`**;
- **NO resuelve `DM-OPEN-*`**;
- **NO resuelve `FORM-OPEN-*`**;
- **NO resuelve `DO-T03`**;
- **NO resuelve `DO-T04`**;
- **NO resuelve `OFF-OPEN-001/002`**;
- **NO reabre `DO-075`**;
- **NO autoriza avanzar automáticamente a `07-reporting-engine-spec.md`**;
- **NO cierra Fase 0**.

## 62.8 Verificación final del Gate

- `DM-OPEN-001` = **ABIERTA**.
- `DM-OPEN-002` = **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-003` = **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-004` = **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-005..008` = **ABIERTAS — preservadas sin modificación**.
- `FORM-OPEN-001..008` = **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.
- `DO-T03` = **PARCIALMENTE ABIERTO**.
- `DO-T04` = **PROPUESTA PENDIENTE DE APROBACIÓN**.
- `OFF-OPEN-001` = **ABIERTO — pendiente de aprobación**.
- `OFF-OPEN-002` = **ABIERTO — pendiente de aprobación**.
- `DO-075` = **RESUELTA/APROBADA**.
- `EVID-OPEN-001..006` = **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.
- `EVID-OPEN-006 — Continuidad de Evidence entre MaintenanceRevision` = **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- **Estado de `06-maintenance-evidence-spec.md`: APROBADO — especificación conceptual y funcional del sistema de evidencias fotográficas de mantenimiento del MVP**.
- **Estado de Fase 0: EN CURSO**.

No se avanza al documento `07`.
