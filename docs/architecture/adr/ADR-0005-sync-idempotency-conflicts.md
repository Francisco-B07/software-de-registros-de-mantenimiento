# ADR-0005 — Protocolo de sincronización, idempotencia y conflictos

> **Ruta normativa:** `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`  
> **Fase:** Fase 0 — Architecture Decision Record  
> **Estado de Fase 0:** **EN CURSO**  
> **Naturaleza:** decisión arquitectónica transversal sobre convergencia local/remota, idempotencia, concurrencia y conflictos; **NO constituye implementación, protocolo HTTP, esquema físico, SQL, RLS ejecutable, schema Dexie ni diseño de endpoints**

**ID: ADR-0005**  
**Title: Protocolo de sincronización, idempotencia y conflictos**  
**Status: ACCEPTED**

---

# 1. ID

`ADR-0005`

# 2. Título

`Protocolo de sincronización, idempotencia y conflictos`

# 3. Status

`ACCEPTED`

Este ADR ha sido aprobado formalmente como decisión arquitectónica para el protocolo conceptual de sincronización del MVP.

El estado `ACCEPTED` aprueba únicamente la decisión arquitectónica documentada en este ADR.

La aceptación de este ADR:
- no autoriza implementación;
- no autoriza uso de Codex;
- no inicia Fase 1;
- no cierra Fase 0;
- no modifica el estado de `ADR-0001` ni `ADR-0002`;
- no resuelve `ADR-0004`;
- no resuelve ninguna decisión `DO-*` o `*-OPEN-*`.

---

# 4. Context

El producto es un SaaS B2B multiempresa para compañías que realizan mantenimiento técnico y debe soportar trabajo real de campo durante períodos prolongados sin conectividad.

La baseline aprobada establece simultáneamente que:

- Supabase PostgreSQL es la **source of truth remota**;
- Dexie/IndexedDB mantiene estado operativo local;
- el modelo de trabajo de campo es **local-first**;
- una operación válida se persiste localmente antes de depender de la red;
- existe una **durable outbox** para trabajo pendiente;
- las operaciones de sincronización deben ser idempotentes;
- la aplicación puede permanecer offline durante días dentro de la autorización offline aprobada;
- la finalización funcional de un mantenimiento y su sincronización son estados independientes;
- un mantenimiento puede estar finalizado localmente y todavía pendiente de confirmación remota;
- las fotografías y archivos pendientes permanecen localmente hasta confirmación remota válida;
- no se admite silent Last Write Wins para registros críticos;
- una divergencia crítica preserva ambas versiones y requiere resolución explícita;
- una resolución de conflicto de mantenimiento produce una nueva `MaintenanceRevision`;
- problemas de conectividad o sincronización no deben hacer desaparecer trabajo capturado localmente;
- la UI debe hacer visible la conectividad y la cantidad de operaciones pendientes.

Esta combinación introduce una frontera de sistemas distribuidos aunque el producto mantenga un único deployable principal conforme a `ADR-0001`.

La PWA y PostgreSQL pueden evolucionar temporalmente de forma independiente. Entre ambos pueden existir:

- períodos largos sin comunicación;
- requests repetidos;
- respuestas perdidas;
- timeouts ambiguos;
- cierres de la aplicación entre pasos;
- orden parcial entre operaciones relacionadas;
- cambios remotos concurrentes;
- revocaciones o cambios de autorización producidos mientras el dispositivo estaba offline;
- metadata estructurada confirmada mientras un archivo todavía está pendiente;
- uploads reintentados;
- cambios remotos que hacen inválida la base sobre la que se produjo una intención local.

Por ello no es suficiente definir “enviar cambios cuando vuelve Internet”. La arquitectura necesita una semántica explícita de identidad, confirmación, repetición, concurrencia, conflicto y reconciliación.

## 4.1 Relación con `ADR-0001`

`ADR-0001 — Arquitectura modular del SaaS en Next.js` está `ACCEPTED`.

Este ADR preserva:

- monolito modular;
- un deployable principal inicial;
- fronteras internas entre dominio, aplicación e infraestructura;
- integraciones externas detrás de fronteras internas apropiadas;
- ausencia de microservicios sin una necesidad demostrada y una nueva decisión arquitectónica.

El protocolo de sincronización es una responsabilidad transversal dentro del monolito modular. No requiere introducir message brokers, microservicios ni un backend distribuido adicional para ser correcto.

## 4.2 Relación con `ADR-0002`

`ADR-0002 — Multi-tenancy, tenant ownership y aislamiento` está `ACCEPTED`.

Este ADR preserva:

- `MaintenanceCompany` como frontera primaria de tenancy;
- tenant ownership inequívoco;
- resolución autoritativa del tenant efectivo;
- RLS obligatoria como frontera primaria de aislamiento remoto;
- integridad cross-tenant;
- frontend/PWA no autoritativos;
- Supabase Storage sujeto a ownership del dominio;
- uso restringido de `service-role`;
- operaciones privilegiadas obligadas a conservar tenancy, ownership e invariantes.

Una operación originada offline puede transportar IDs y contexto local, pero esos datos **no redefinen** tenant, ownership, rol ni client scope en el servidor.

## 4.3 Relación con `ADR-0004`

`ADR-0004 — Offline local-first y aislamiento de réplica` permanece `BLOCKED BY OPEN DECISIONS`.

La separación conceptual es deliberada:

- `ADR-0004` define **dónde y bajo qué identidad vive el estado local**;
- `ADR-0005` define **cómo una intención local converge con el estado remoto**.

Por tanto, este ADR puede fijar el núcleo de identidad de operación, idempotencia, acknowledgement, retry, optimistic concurrency y conflicto sin decidir:

- apertura o cierre de una réplica;
- protección local;
- cifrado local;
- política de logout;
- purga tras revocación;
- conservación de copias sincronizadas tras revocación;
- destino final del trabajo pendiente tras revocación;
- schema Dexie.

## 4.4 `DO-075`

`DO-075` permanece `RESUELTA/APROBADA` y se consume como restricción existente:

- la autorización offline puede mantenerse como máximo 7 días desde la última validación online;
- superado ese plazo no pueden iniciarse nuevas operaciones sin revalidación;
- una revocación conocida debe aplicarse al recuperar conectividad;
- el trabajo ya capturado no se elimina por vencimiento o revocación.

Este ADR no redefine el plazo, el significado de la autorización offline ni sus mecanismos físicos.

---

# 5. Problem

¿Cómo sincronizar de forma segura operaciones creadas localmente —posiblemente durante períodos prolongados offline— con una source of truth remota, tolerando retries, respuestas perdidas, orden parcial, divergencias y archivos pendientes, sin duplicar efectos ni sobrescribir silenciosamente cambios concurrentes?

La solución debe distinguir, como mínimo, entre:

- una intención nueva y un retry de la misma intención;
- una operación enviada y una operación remotamente confirmada;
- un fallo temporal y un rechazo que no cambiará por repetir exactamente lo mismo;
- un timeout y un fallo funcional;
- un dato funcionalmente finalizado y un dato sincronizado;
- una base remota todavía válida y una base que evolucionó concurrentemente;
- un conflicto y un error transitorio;
- un archivo transferido y una Evidence remotamente reconocida en el contexto correcto;
- estado local previamente autorizado y autorización remota vigente;
- una operación del tenant correcto y una operación manipulada que intenta cruzar tenants.

Sin estas distinciones, el sistema podría:

- crear duplicados por retries;
- perder trabajo tras una respuesta perdida;
- marcar como sincronizado un efecto incierto;
- aplicar una mutación contra una revisión remota obsoleta;
- sobrescribir trabajo concurrente;
- asociar archivos al recurso incorrecto;
- continuar children después de que su parent haya fallado;
- tratar una revocación como un error de red;
- borrar trabajo local que todavía no posee confirmación suficiente;
- romper aislamiento tenant durante un replay o retry.

---

# 6. Decision

Para el MVP se adopta un **protocolo conceptual de sincronización basado en durable outbox, identidad estable de operación, idempotencia end-to-end, acknowledgements explícitos, retries seguros, optimistic concurrency y conflictos explícitos**.

La decisión se resume en los siguientes principios obligatorios:

1. toda intención sincronizable reintentable debe poseer **identidad lógica estable**;
2. el trabajo todavía no confirmado remotamente debe permanecer representado en una **durable outbox**;
3. repetir la misma intención debe ser **idempotente end-to-end**;
4. una operación sólo se considera remotamente confirmada después de un **acknowledgement suficiente** del efecto esperado o de su reconocimiento idempotente previo;
5. los errores temporales y las respuestas perdidas deben permitir **retry seguro** con la misma identidad lógica;
6. las operaciones deben poder representar **dependencias explícitas** cuando una intención requiera que otra haya convergido primero;
7. antes de aplicar remotamente trabajo offline debe respetarse el **contexto autoritativo vigente**, incluyendo autorización, tenancy, ownership y condiciones aplicables;
8. las mutaciones de recursos críticos/versionados deben usar **optimistic concurrency** contra una base conocida;
9. una divergencia incompatible que no pueda resolverse mediante una regla segura ya aprobada se convierte en **conflicto explícito**;
10. el conflicto debe **preservar ambas versiones** y la información necesaria para compararlas;
11. la resolución debe ser **explícita y ejecutada por un actor autorizado**;
12. después de una mutación confirmada debe producirse **reconciliación local** con estado remoto autoritativo suficiente;
13. queda prohibido **silent Last Write Wins** como estrategia general para registros críticos.

Esta decisión define semántica de protocolo, no transporte físico.

No prescribe:

- HTTP;
- REST;
- RPC;
- Server Actions;
- Route Handlers;
- Edge Functions;
- funciones Supabase;
- número de requests;
- payloads;
- headers;
- códigos HTTP;
- tablas;
- columnas;
- enums;
- schema Dexie;
- algoritmo concreto de scheduling.

---

# 7. Frontera del protocolo

El protocolo de sincronización transporta y reconcilia **intenciones de dominio**. No redefine las reglas funcionales de los bounded contexts que sincroniza.

En particular:

- no concede permisos nuevos;
- no cambia quién puede iniciar un mantenimiento;
- no cambia quién puede corregirlo;
- no cambia quién puede resolver un conflicto;
- no cambia la inmutabilidad de `FormVersion` published;
- no cambia la inmutabilidad de revisiones históricas;
- no cambia la semántica abierta de Evidence entre revisiones;
- no cambia las reglas de Reporting;
- no convierte la outbox en source of truth de negocio.

La sincronización puede coordinar pasos técnicos necesarios para converger, pero la validez final de un efecto remoto sigue sujeta a:

- autorización vigente;
- tenancy y ownership;
- invariantes del dominio;
- precondiciones de concurrencia;
- dependencias satisfechas;
- reglas específicas del bounded context.

---

# 8. Modelo conceptual de una operación sincronizable

Una operación sincronizable representa una **intención lógica concreta** que todavía necesita aplicación, reconocimiento o reconciliación remota.

Conceptualmente debe existir información suficiente para correlacionar:

- identidad de la operación;
- identidad del actor/replica que originó la intención;
- recurso o intención de dominio afectada;
- tenant y contexto de ownership derivables y verificables remotamente;
- dependencias cuando existan;
- base o precondición conocida cuando aplique;
- resultado remoto reconocido;
- estado de sincronización;
- errores o bloqueos relevantes;
- archivos relacionados cuando corresponda.

Esta descripción **no define un schema físico**.

La operación de sincronización tampoco equivale necesariamente a un único request. Una intención lógica puede requerir coordinación de varios efectos físicos y, a la inversa, varias mutaciones relacionadas pueden agruparse si el diseño futuro necesita preservar una unidad de dominio coherente.

La frontera arquitectónica es el **efecto lógico** que debe poder repetirse, reconocerse y reconciliarse sin ambigüedad.

---

# 9. Identidad estable de operación

Toda operación sincronizable que pueda reintentarse necesita una identidad lógica estable.

Puede denominarse conceptualmente:

- `operation ID`;
- idempotency key lógica;
- identidad de intento lógico.

El término físico definitivo no queda fijado.

## 9.1 Propósito

La identidad estable permite distinguir:

- el mismo intento lógico repetido;
- una operación nueva;
- una respuesta perdida;
- un replay;
- un retry después de reconexión;
- una PWA que se cerró después de que el servidor aplicó el efecto pero antes de registrar localmente la confirmación.

## 9.2 Invariantes

Para una misma intención lógica:

- un retry conserva su identidad;
- un replay conserva su identidad;
- una reconexión no genera una identidad nueva sólo por volver a intentar;
- una respuesta perdida no transforma la operación en una nueva intención.

Para intenciones distintas:

- deben existir identidades distintas;
- una corrección deliberadamente nueva no reutiliza la identidad de una corrección anterior;
- una nueva resolución deliberada no debe presentarse como retry de una resolución previa.

## 9.3 Prohibición de identidad por intento de transporte

Generar una identidad nueva para cada retry de transporte rompe la capacidad de reconocer el mismo efecto lógico y, por tanto, rompe la idempotencia end-to-end.

La identidad pertenece a la intención lógica, no al intento de red.

## 9.4 No se decide formato

Este ADR no decide:

- tipo físico;
- UUID version;
- longitud;
- columna;
- nombre exacto;
- header;
- serialización;
- librería de generación.

---

# 10. Durable outbox

La durable outbox es el registro local de **intenciones todavía pendientes de converger o ser reconocidas remotamente**.

No es un simple historial de requests enviados.

## 10.1 Durabilidad requerida

El trabajo pendiente debe sobrevivir, dentro de las garantías técnicas del almacenamiento local:

- refresh;
- navegación;
- cierre y reapertura de la PWA;
- terminación del proceso;
- pérdida temporal de red;
- retry;
- respuesta remota perdida;
- reconexiones sucesivas.

La estrategia debe asumir que la aplicación puede cerrarse en cualquier punto entre “intención persistida”, “request enviado”, “efecto remoto aplicado” y “acknowledgement persistido localmente”.

## 10.2 Significado

Que una intención esté en outbox significa que el cliente todavía no dispone de confirmación suficiente para eliminar su obligación de convergencia.

La outbox no significa que:

- la operación nunca haya sido enviada;
- el servidor nunca haya aplicado el efecto;
- el usuario siga autorizado;
- las dependencias sigan válidas;
- no exista un conflicto.

## 10.3 No confundir con otros históricos

La outbox no reemplaza:

- log de auditoría;
- historial de dominio;
- `MaintenanceRevision`;
- historial de Evidence;
- `ReportSnapshot`;
- ledger de créditos;
- source of truth remota.

Un item confirmado puede dejar de ser trabajo pendiente sin que desaparezca el histórico de negocio que el efecto haya producido.

## 10.4 Lifecycle conceptual

Una operación puede encontrarse conceptualmente en situaciones equivalentes a:

- `pending`;
- `in-flight`;
- `acknowledged/synced`;
- `failed retryable`;
- `conflict`;
- `blocked`;
- error permanente que requiera intervención.

Estos nombres son descriptivos. No constituyen un enum definitivo ni una state machine física.

---

# 11. Business state y sync state

El estado funcional de un recurso y su estado de sincronización son ejes independientes.

Para mantenimiento, por ejemplo:

- `FINALIZED localmente + PENDING_SYNC` es válido;
- `FINALIZED localmente + IN_FLIGHT` es válido;
- `FINALIZED localmente + CONFLICT` es válido;
- `FINALIZED + SYNCED` es válido.

La pérdida de conectividad no debe degradar un mantenimiento ya finalizado localmente a “draft”.

Del mismo modo, marcar una operación como sincronizada no debe utilizarse para inferir por sí solo un estado de negocio que el dominio no haya producido.

## 11.1 Razón

Mezclar ambos ejes en una única máquina de estados produciría ambigüedades como:

- interpretar “no sincronizado” como “no finalizado”;
- perder la capacidad de representar conflicto sobre un mantenimiento finalizado;
- hacer depender el significado funcional del recurso de la disponibilidad de red.

La arquitectura debe conservar la separación incluso si la implementación futura materializa ambos estados de forma próxima.

---

# 12. Idempotencia end-to-end

Una operación es idempotente cuando repetir la **misma intención lógica con la misma identidad estable** no produce un segundo efecto lógico.

La idempotencia requerida es end-to-end: no basta con que una capa de transporte dedupe requests si el dominio todavía puede duplicar recursos o revisiones.

## 12.1 Crear una entidad

Si una intención lógica crea un recurso:

- el primer procesamiento puede producir el recurso;
- un retry debe reconocer el mismo resultado lógico;
- no debe crear una segunda entidad equivalente por el solo hecho de repetir la entrega.

## 12.2 Guardar una revisión

Si una intención guarda una revisión válida:

- repetir la misma intención no debe producir otra revisión adicional;
- una nueva corrección deliberada sí constituye una operación diferente y requiere identidad diferente.

## 12.3 Evidence metadata

Si una intención crea o asocia metadata de Evidence:

- el retry debe reconocer la misma Evidence lógica;
- no debe crear Evidence duplicada accidentalmente por una respuesta perdida o reconnect.

## 12.4 Finalizar un mantenimiento

Si la finalización lógica ya fue aceptada remotamente:

- repetir el mismo intento no debe producir un segundo mantenimiento ni una segunda finalización histórica;
- el cliente debe poder obtener reconocimiento suficiente del efecto ya realizado.

## 12.5 Resolver un conflicto

Si una resolución de mantenimiento ya produjo la nueva `MaintenanceRevision` correspondiente:

- repetir la misma resolución por retry no debe producir revisiones adicionales;
- una decisión posterior diferente sería una nueva intención, no un retry.

## 12.6 Timeout y respuesta perdida

Un timeout sólo indica que el cliente no recibió una conclusión suficiente.

Puede haber ocurrido que:

- el servidor no recibiera la operación;
- la recibiera pero no aplicara el efecto;
- aplicara el efecto y la respuesta se perdiera;
- aplicara el efecto y el cliente se cerrara antes de persistir el acknowledgement.

El protocolo no obliga al cliente a adivinar cuál caso ocurrió. El retry con identidad estable debe permitir converger hacia el mismo efecto o su reconocimiento.

## 12.7 Reconocimiento remoto

Cuando corresponda, el servidor debe poder reconocer que una intención ya fue procesada de manera suficiente para devolver o reconstruir un resultado compatible con el efecto previamente aceptado.

Este ADR no define cómo se persiste ese reconocimiento.

---

# 13. Acknowledgement

Una request enviada **no equivale** a una operación confirmada.

Una operación local sólo puede considerarse remotamente confirmada cuando existe acknowledgement suficiente de que:

- el servidor aceptó/aplicó el efecto esperado; o
- el servidor reconoció idempotentemente que ese mismo efecto ya había sido aplicado.

## 13.1 Propiedades del acknowledgement

El acknowledgement debe ser correlacionable con:

- la misma identidad lógica de operación;
- el recurso o efecto esperado;
- el contexto autoritativo correspondiente.

Debe proporcionar información suficiente para que el cliente pueda dejar de tratar esa intención como incierta y comenzar la reconciliación de su representación local.

## 13.2 Ambigüedad de transporte

Un timeout, cierre de conexión o respuesta perdida no equivale automáticamente a fallo funcional.

Ante incertidumbre, la operación permanece pendiente de confirmación y puede reintentarse idempotentemente.

## 13.3 Salida de la outbox

Una intención no debe eliminarse como pendiente únicamente porque:

- se emitió una request;
- se abrió una conexión;
- se transfirieron bytes;
- el cliente “cree” que el efecto probablemente ocurrió.

Debe existir confirmación suficiente del efecto lógico.

## 13.4 Acknowledgement no sustituye reconciliación

El acknowledgement resuelve la incertidumbre sobre el efecto esperado. No implica que la representación local completa ya sea idéntica al estado remoto autoritativo.

Por eso el protocolo incluye reconciliación posterior.

---

# 14. Retries

Los retries son seguros porque preservan identidad lógica e idempotencia.

La estrategia distingue conceptualmente entre fallos que pueden mejorar repitiendo la misma intención y situaciones que requieren un cambio de contexto, de datos o intervención.

## 14.1 Retryable

Ejemplos generales:

- pérdida de conectividad;
- timeout;
- indisponibilidad transitoria;
- interrupción durante transferencia;
- respuesta perdida;
- resultado no concluyente de transporte.

En estos casos:

- la intención se preserva;
- la identidad lógica se preserva;
- el retry no debe producir un segundo efecto.

## 14.2 Non-retryable sin cambio

Ejemplos generales:

- autorización rechazada;
- validación funcional autoritativa no satisfecha;
- conflicto de concurrencia;
- recurso incompatible o inexistente cuando repetir exactamente lo mismo no puede corregir la situación.

Estos casos no deben entrar en un loop de retry ciego.

## 14.3 Conflicto no es timeout

Un mismatch de optimistic concurrency expresa una divergencia del estado, no una indisponibilidad temporal.

Reintentar la misma mutación sin resolver la divergencia equivaldría a insistir en sobrescribir una base que ya cambió.

Debe pasar al flujo de conflicto.

## 14.4 Autorización rechazada no es conectividad

Una operación creada cuando el usuario estaba autorizado no conserva automáticamente permiso remoto indefinido.

Un rechazo por autorización debe preservar el trabajo local y bloquear la aplicación remota hasta que exista el tratamiento permitido.

El destino final de ese trabajo continúa sujeto a `OFF-OPEN-001`.

## 14.5 No se fija política temporal

Este ADR no define:

- cantidad de retries;
- delay;
- backoff concreto;
- jitter;
- scheduler;
- periodicidad;
- límite de intentos;
- ejecución background garantizada.

---

# 15. Orden y dependencias entre operaciones

La outbox puede contener operaciones con dependencias.

La arquitectura debe poder expresar una dependencia cuando la validez de una intención requiera que otra haya sido confirmada o sea resoluble idempotentemente dentro de la misma unidad coherente.

## 15.1 Ejemplos conceptuales

Pueden existir relaciones como:

- crear una entidad antes de modificarla;
- crear/confirmar una `Response` antes de asociar Evidence metadata cuando el diseño físico futuro lo requiera;
- reconocer metadata o asociación lógica antes de considerar completado determinado paso de archivo cuando corresponda;
- crear una revisión antes de efectos dependientes de esa revisión, si el diseño posterior los materializa separadamente.

Estos ejemplos no obligan a convertir cada paso en una operación física distinta.

## 15.2 Dependencias explícitas

Cuando una dependencia sea necesaria, el sistema debe poder evitar que un child se procese ciegamente si su parent:

- todavía no está confirmado;
- entró en conflicto;
- quedó bloqueado por autorización;
- fue rechazado de forma permanente.

## 15.3 No FIFO global

Este ADR no adopta FIFO global como requisito.

El orden correcto se deriva de:

- dependencias;
- invariantes de dominio;
- elegibilidad;
- autorización;
- precondiciones.

Operaciones independientes pueden no necesitar un orden total.

## 15.4 No se diseña DAG ni scheduler

No se decide:

- estructura física de dependencias;
- DAG;
- algoritmo topológico;
- prioridades;
- concurrencia del scheduler;
- batching.

---

# 16. Revalidación de autorización y contexto

La autorización local es temporal y no reemplaza el estado remoto autoritativo.

Antes de aplicar remotamente trabajo que estuvo offline, el sistema debe respetar el contexto vigente aplicable.

Conceptualmente puede ser necesario revalidar:

- identidad;
- membership;
- rol;
- client scope;
- estado de autorización;
- tenant ownership;
- estado comercial cuando corresponda;
- vigencia derivada de `DO-075`;
- otras precondiciones autoritativas necesarias para el caso de uso.

## 16.1 Revocación

Una revocación conocida al recuperar conectividad prevalece sobre el estado local anterior.

Esto significa que una operación pendiente puede dejar de ser elegible para aplicación remota aunque haya sido creada válidamente cuando el actor estaba autorizado.

## 16.2 Preservación del trabajo

Que una operación ya no pueda aplicarse por autorización actual **no** convierte el rechazo en permiso para borrar el trabajo local.

Deben preservarse la intención y la información necesaria para su tratamiento posterior.

## 16.3 Decisión abierta preservada

Este ADR no decide qué actor, flujo o política puede rescatar, reasignar, incorporar o descartar formalmente trabajo pendiente bloqueado por revocación.

Ese destino permanece gobernado por `OFF-OPEN-001`.

Tampoco decide conservación/purga de copias sincronizadas después de revocación, que permanece en `OFF-OPEN-002`.

## 16.4 `DO-T03` y `DO-T04`

La decisión nuclear de este ADR no depende de resolver:

- mecanismo de invalidación efectiva de sesiones (`DO-T03`);
- protección local de la réplica (`DO-T04`).

Ambas decisiones condicionarán flujos específicos, pero no cambian la necesidad de revalidar antes de aplicar remotamente ni la semántica de idempotencia/conflicto.

---

# 17. Optimistic concurrency

Para recursos críticos o versionados donde una actualización concurrente pueda destruir intención válida, la mutación debe poder declarar conceptualmente contra qué **base conocida** fue producida.

Puede expresarse conceptualmente como:

- expected revision;
- base version;
- version token;
- precondición equivalente.

No se fija su representación física.

## 17.1 Propósito

La optimistic concurrency permite distinguir:

- “el remoto sigue siendo la base que yo vi”;
- “el remoto cambió desde que produje mi intención”.

## 17.2 Verificación remota

Antes de aplicar una mutación crítica, el servidor debe poder comprobar si la base esperada sigue vigente.

Si coincide, la operación puede continuar si satisface las demás reglas.

Si no coincide y no existe una regla segura ya aprobada para reconciliar automáticamente:

- no se sobrescribe silenciosamente;
- se preserva la intención local;
- se obtiene/preserva el estado remoto relevante;
- la divergencia pasa a conflicto explícito.

## 17.3 No se decide mecanismo físico

Este ADR no define:

- columna `version`;
- número de revisión físico;
- ETag;
- timestamp como token;
- locks;
- compare-and-swap concreto;
- SQL;
- transacción física.

La implementación futura puede elegir un mecanismo que preserve la semántica aprobada.

---

# 18. Conflictos

Un `SyncConflict` representa una divergencia que el sistema no puede resolver automáticamente sin riesgo de:

- perder intención válida;
- sobrescribir trabajo concurrente;
- romper un histórico;
- producir una revisión incoherente;
- violar una regla de dominio.

## 18.1 Información conceptual a preservar

Un conflicto debe conservar información suficiente para reconstruir y comparar, cuando aplique:

- recurso afectado;
- identidad de la operación local;
- actor/origen de la intención local;
- base conocida sobre la que se trabajó;
- propuesta local completa o reproducible;
- estado remoto actual relevante;
- diferencias semánticas;
- archivos locales relacionados;
- motivo de la divergencia;
- eventual resolución y actor que la realizó;
- resultado convergente posterior.

No se diseña schema de `SyncConflict`.

## 18.2 Preservación de ambas versiones

Detectar un conflicto no elimina ni modifica silenciosamente:

- la propuesta local;
- el estado remoto actual;
- archivos locales asociados;
- metadata necesaria para la resolución.

## 18.3 Diferencias semánticas

La futura experiencia de resolución debe poder presentar diferencias relevantes para el dominio, no obligar al usuario a razonar sobre JSON, blobs o detalles internos.

Este ADR no diseña la UI final.

## 18.4 No todo cambio remoto es conflicto

La existencia de una nueva copia remota no obliga a crear conflicto si el dato es sólo una copia local no modificada y no existe intención local dependiente que pueda perderse.

El conflicto se reserva para divergencias donde la aplicación automática sea insegura según las reglas del recurso.

Este ADR no inventa escrituras offline para agregados que la baseline no haya aprobado.

---

# 19. Prohibición de silent Last Write Wins

Silent Last Write Wins queda rechazado como estrategia general para registros críticos.

No se debe resolver una divergencia seleccionando automáticamente “el último valor” por:

- timestamp de dispositivo;
- hora de llegada al servidor;
- orden de retry;
- orden de reconnect;
- último request observado.

## 19.1 Motivos

Silent Last Write Wins puede:

- perder trabajo creado offline durante horas o días;
- ocultar que dos actores trabajaron sobre bases distintas;
- destruir intención válida;
- borrar correcciones legítimas;
- dificultar auditoría;
- alterar el histórico de mantenimiento;
- asociar Evidence con una versión que el actor no pretendía;
- convertir latencia de red en regla de negocio.

## 19.2 Alcance

La prohibición aplica a los registros críticos contemplados por la baseline, especialmente mantenimiento, revisiones, respuestas y Evidence vinculada a una revisión.

Una futura operación no crítica podría tener otra semántica si existe una decisión explícita que la defina. Este ADR no inventa excepciones.

---

# 20. Resolución de conflictos

La resolución de un conflicto es una **nueva acción explícita de dominio**, no un side effect silencioso del motor de sync.

Debe:

- ser iniciada/confirmada explícitamente;
- ser ejecutada por un actor autorizado;
- revalidar autorización vigente al aplicarse remotamente;
- preservar el histórico anterior;
- producir un nuevo estado convergente;
- mantener trazabilidad suficiente de la decisión;
- no borrar silenciosamente la versión que no resultó elegida.

## 20.1 Actores de mantenimiento

Sin ampliar permisos:

- `TECHNICIAN` puede resolver conflictos de mantenimiento dentro de sus clientes autorizados;
- `COMPANY_ADMIN` puede resolver conflictos dentro de su alcance aprobado.

La capacidad de `COMPANY_ADMIN` para resolver conflictos no le concede ejecución inicial de mantenimiento.

## 20.2 Resultado para Maintenance

Cuando el conflicto afecta mantenimiento, su resolución produce una **nueva `MaintenanceRevision`**.

No se sobrescriben revisiones anteriores.

La nueva revisión expresa el resultado de la resolución y permite que el sistema vuelva a converger desde un nuevo punto histórico explícito.

## 20.3 No merge automático general

Este ADR no adopta un algoritmo general de merge automático.

Tampoco define:

- merge field-by-field;
- preferencia por actor;
- preferencia por timestamp;
- CRDT;
- reglas de tres vías concretas;
- UI final de comparación.

Cualquier regla automática futura para un recurso crítico necesitará estar justificada por semántica de dominio aprobada y no podrá implicar pérdida silenciosa.

---

# 21. Reconciliación posterior a mutaciones confirmadas

Después de una mutación remotamente confirmada, el cliente debe reconciliar su representación con estado remoto autoritativo suficiente.

La reconciliación existe porque:

- el servidor puede haber reconocido un efecto previamente aplicado;
- puede haber asignado identidad/ordinal autoritativo cuando corresponda;
- puede haber normalizado o validado datos;
- puede existir una revisión remota concreta que deba convertirse en nueva base;
- pueden existir cambios adicionales relevantes para el recurso;
- el cliente no debe asumir que “lo que intentó enviar” es necesariamente una representación completa de “lo que el servidor reconoce como vigente”.

## 21.1 Objetivos

La reconciliación debe permitir conceptualmente:

- obtener identidad/estado autoritativo cuando corresponda;
- confirmar revisión o base aceptada;
- establecer la nueva base local para futuras mutaciones;
- detectar cambios remotos adicionales relevantes;
- retirar de pendientes únicamente trabajo que ya posea confirmación suficiente;
- preservar operaciones todavía inciertas, bloqueadas o en conflicto.

## 21.2 Alcance mínimo suficiente

No es requisito redescargar todo el tenant después de cada operación.

Debe reconciliarse lo suficiente para garantizar convergencia del recurso afectado y de las dependencias necesarias.

## 21.3 Transporte no decidido

Este ADR no define:

- pull protocol;
- polling;
- Supabase Realtime como mecanismo obligatorio;
- frecuencia;
- cursor;
- watermark;
- delta protocol;
- WebSocket.

---

# 22. Crash safety y recuperación

El protocolo debe asumir que la aplicación puede cerrarse o fallar entre cualquier par de pasos.

Escenarios esperables incluyen:

- la intención quedó persistida y todavía no fue enviada;
- la operación se marcó `in-flight` y la PWA se cerró;
- el servidor aplicó el efecto y el cliente no recibió respuesta;
- el cliente recibió respuesta pero se cerró antes de persistir la confirmación;
- un upload se interrumpió;
- metadata quedó confirmada y el binario todavía está pendiente;
- la red volvió mientras existen múltiples dependencias.

## 22.1 Reanudación

Al reabrir, el sistema debe poder reanudar sin:

- crear una identidad nueva para el mismo efecto;
- duplicar recursos;
- considerar sincronizado algo no confirmado;
- perder archivos pendientes;
- continuar children cuyo parent quedó bloqueado o en conflicto.

## 22.2 Persistencia antes de éxito

La UI sólo puede presentar como durable un trabajo cuya intención y datos necesarios hayan sido efectivamente persistidos localmente conforme a la estrategia offline aprobada.

Este ADR no diseña transacciones IndexedDB ni recuperación física de storage.

---

# 23. Maintenance

El protocolo debe preservar la semántica aprobada de mantenimiento.

## 23.1 Finalización local

Un mantenimiento puede quedar finalizado funcionalmente en el dispositivo aunque todavía existan:

- operaciones estructuradas pendientes;
- acknowledgements pendientes;
- fotografías pendientes;
- reconciliación pendiente.

## 23.2 Sincronización independiente

El sync state no reemplaza ni redefine el business state.

Una UI puede mostrar, por ejemplo:

- mantenimiento finalizado;
- además, estado técnico pendiente, sincronizando, bloqueado o en conflicto.

## 23.3 Revisiones históricas

La sincronización no sobrescribe una `MaintenanceRevision` histórica para “hacerla coincidir” con una revisión remota nueva.

Las correcciones y resoluciones autorizadas producen nuevas revisiones conforme a la baseline.

## 23.4 Conflicto

Si la base remota evolucionó de forma incompatible:

- se conserva la propuesta local;
- se conserva el estado remoto;
- se requiere resolución explícita;
- la resolución de mantenimiento crea una nueva `MaintenanceRevision`.

---

# 24. Forms

Un mantenimiento ya iniciado conserva exactamente la `FormVersion` utilizada al iniciarse.

La sincronización:

- no modifica una `FormVersion` published;
- no reemplaza una versión histórica por otra;
- no migra automáticamente un mantenimiento iniciado a una versión posterior;
- no reinterpreta sus respuestas utilizando fields de otra versión.

## 24.1 Publicación nueva

Una publicación posterior se trata como una nueva `FormVersion`, no como una actualización destructiva de la anterior.

Puede coexistir localmente con la versión requerida por trabajo ya iniciado.

## 24.2 `FORM-OPEN-004`

Este ADR no decide qué debe ocurrir cuando un dispositivo inicia offline un mantenimiento utilizando la última versión publicada/aplicable que conoce, pero existe remotamente una publicación más reciente que todavía no conocía.

`FORM-OPEN-004` permanece abierta.

La decisión de este ADR sólo exige que, cualquiera sea la política futura, el sync no migre silenciosamente un mantenimiento ya creado a otra versión.

---

# 25. Evidence: metadata + binario

Evidence introduce una coordinación especial porque el estado lógico y el contenido binario pueden requerir pasos técnicos distintos.

La arquitectura debe preservar simultáneamente:

- identidad lógica estable de la Evidence/intención correspondiente;
- correlación estable entre metadata y binario;
- tenant/ownership correctos;
- asociación al contexto de dominio correcto;
- retry seguro;
- conservación local del archivo mientras no exista confirmación remota suficiente.

## 25.1 Independencia técnica

La confirmación del estado estructurado de un mantenimiento no implica automáticamente confirmación de sus archivos.

Es válido que un mantenimiento esté:

- finalizado localmente;
- con parte o todo su estado estructurado remoto confirmado;
- con una o más fotografías todavía pendientes.

## 25.2 Correlación estable

Metadata y binario deben poder correlacionarse de forma estable a través de:

- retry;
- reconnect;
- respuesta perdida;
- cierre de PWA;
- conflicto.

El diseño futuro no puede depender únicamente del orden temporal accidental en el que lleguen requests o uploads.

## 25.3 Retry independiente y seguro

El protocolo debe permitir que las fases técnicas necesarias para Evidence se reintenten sin crear accidentalmente:

- una segunda Evidence lógica;
- una segunda asociación de dominio;
- un archivo tratado como perteneciente a otra Evidence;
- un efecto cross-tenant.

No se impone un orden físico único entre metadata y binario. Las dependencias concretas se definirán al diseñar la implementación, preservando las invariantes de dominio.

## 25.4 Confirmación remota válida

Una fotografía no debe eliminarse localmente sólo porque:

- se inició un upload;
- se transfirieron bytes;
- una request terminó sin que pueda correlacionarse el efecto completo.

La confirmación suficiente debe permitir establecer conceptualmente que el contenido esperado fue almacenado o reconocido idempotentemente y que su asociación válida con la Evidence/recurso correcto está reconocida conforme al protocolo.

## 25.5 Conflicto con archivos locales

Si una revisión entra en conflicto mientras existen fotografías locales:

- los archivos no se descartan;
- permanecen asociados a la propuesta local/conflicto;
- su existencia no autoriza convertirlos automáticamente en Evidence activa de otra revisión.

## 25.6 Decisiones Evidence preservadas

Este ADR no resuelve:

- `EVID-OPEN-001..006`;
- continuidad efectiva entre revisiones;
- replacement semantics;
- cardinalidad de fotografías;
- Storage paths;
- signed URLs;
- protocolo concreto de upload;
- política exacta de cleanup.

---

# 26. Tenancy e integridad cross-tenant

Toda operación sincronizada debe preservar el tenant correcto y la cadena de ownership del recurso.

Los datos locales pueden expresar intención, pero no autoridad.

## 26.1 Regla de tenant resolution

El servidor no puede aceptar como autoridad:

- un `maintenance_company_id` local;
- un `tenant_id` local;
- un client ID aislado;
- un equipment ID aislado;
- un path de Storage;
- una referencia conservada en IndexedDB.

Debe resolver y verificar el contexto efectivo mediante estado autoritativo conforme a `ADR-0002` y la estrategia de permisos/RLS.

## 26.2 Replay y retry cross-tenant

Un retry no puede relajar autorización por el hecho de que la operación haya sido válida en el pasado.

Si una operación manipulada intenta:

- cambiar tenant;
- combinar parent y child de tenants distintos;
- asociar Evidence a una Response de otro tenant;
- reutilizar un identificador remoto de otro tenant;
- subir un archivo hacia contexto de ownership ajeno,

debe ser rechazada.

## 26.3 Idempotencia no es autorización

Que el servidor reconozca una operation ID no significa que deba ignorar invariantes de seguridad.

La idempotencia evita duplicación; no convierte una intención no autorizada en autorizada.

## 26.4 Operaciones privilegiadas

Si una implementación futura utiliza capacidades privilegiadas, sigue obligada a preservar:

- tenant;
- ownership;
- integridad cross-tenant;
- reglas funcionales aplicables.

`service-role` no puede utilizarse como mecanismo para “hacer que el sync funcione” evitando autorización normal.

---

# 27. Storage

Supabase Storage debe obedecer la misma frontera de ownership del dominio aprobada en `ADR-0002`.

Para sincronización de archivos:

- conocer un path no concede acceso;
- conocer una URL anterior no concede acceso;
- un retry no puede cambiar de tenant por manipulación de contexto;
- la autorización del upload/asociación debe derivarse del recurso de dominio correspondiente;
- el uso de `service-role` no elimina la obligación de validar ownership.

Este ADR no define:

- bucket;
- path;
- naming;
- signed URLs;
- multipart upload;
- resumable upload;
- policy de Storage;
- cleanup físico.

---

# 28. Realtime

Supabase Realtime puede convertirse en una señal útil para reconciliación futura, pero no es requisito para la corrección del protocolo.

Realtime:

- no sustituye acknowledgement;
- no sustituye idempotencia;
- no sustituye optimistic concurrency;
- no sustituye reconciliación explícita;
- no amplía permisos;
- no convierte un evento recibido en autoridad suficiente para una mutación.

La sincronización debe seguir siendo correcta aunque Realtime no esté disponible.

Este ADR no diseña:

- channels;
- topics;
- subscriptions;
- WebSocket protocol;
- delivery guarantees.

---

# 29. Reporting

Reporting consolidado utiliza estado server-backed conforme a sus propias decisiones.

Este ADR sólo registra una consecuencia necesaria:

> Reporting no puede asumir que todo mantenimiento finalizado localmente ya está disponible remotamente.

Un mantenimiento puede estar funcionalmente finalizado en un dispositivo y todavía no haber convergido a PostgreSQL.

`RPT-OPEN-009` permanece abierta.

Este ADR no decide si un flujo de informe:

- espera;
- excluye temporalmente;
- bloquea;
- avisa;
- permite preparación parcial.

Tampoco cambia el estado funcional local del mantenimiento.

---

# 30. Alternatives

## 30.1 Alternativa A — Fire-and-forget sin durable outbox

### Descripción

Persistir o ejecutar la acción local y enviar una request cuando exista red, sin conservar de forma durable una intención pendiente que pueda reanudarse.

### Ventajas aparentes

- menor complejidad inicial;
- menos estado técnico local;
- implementación superficialmente directa.

### Desventajas

- una PWA cerrada puede perder el trabajo de sincronización;
- una respuesta perdida deja incertidumbre difícil de recuperar;
- no existe retry durable;
- operaciones pendientes pueden desaparecer tras refresh o crash;
- archivos pueden quedar sin coordinación;
- no existe base confiable para mostrar backlog pendiente.

### Evaluación

**Rechazada.**

Contradice la baseline local-first y la exigencia de durable outbox.

---

## 30.2 Alternativa B — Retry sin idempotencia

### Descripción

Conservar trabajo pendiente y repetir requests ante fallos, pero tratar cada retry como una nueva ejecución sin identidad lógica estable reconocible.

### Ventajas aparentes

- retry simple;
- no requiere pensar en reconocimiento de operaciones previas.

### Desventajas

- duplicación de recursos;
- revisiones duplicadas;
- Evidence duplicada;
- doble efecto tras timeout;
- imposibilidad de distinguir respuesta perdida de operación no aplicada;
- replays peligrosos después de reconnect.

### Evaluación

**Rechazada.**

Retry seguro depende de identidad estable e idempotencia end-to-end.

---

## 30.3 Alternativa C — Silent Last Write Wins

### Descripción

Ante una divergencia, aceptar automáticamente el último cambio recibido o el valor con timestamp más reciente.

### Ventajas aparentes

- no requiere flujo explícito de conflicto;
- convergencia superficialmente simple;
- menor complejidad de UI inicial.

### Desventajas

- pierde trabajo offline;
- convierte orden de red en regla de negocio;
- oculta divergencias;
- destruye intención;
- degrada auditoría;
- puede corromper historial técnico;
- puede asociar Evidence al estado equivocado;
- contradice requisitos explícitos del producto.

### Evaluación

**Rechazada para registros críticos.**

---

## 30.4 Alternativa D — Durable outbox + idempotencia + optimistic concurrency + conflictos explícitos

### Descripción

Persistir intenciones con identidad estable, reintentarlas idempotentemente, verificar base conocida para mutaciones críticas, detener divergencias incompatibles y resolverlas explícitamente.

### Ventajas

- tolera desconexión prolongada;
- tolera respuestas perdidas;
- evita duplicados lógicos;
- soporta crash/reopen;
- preserva trabajo concurrente;
- mantiene históricos;
- permite reconciliación explícita;
- separa error transitorio de conflicto;
- es compatible con tenancy/RLS;
- no necesita arquitectura distribuida adicional.

### Desventajas

- mayor complejidad de estados;
- requiere disciplina en ambos extremos;
- necesita UX de conflicto;
- requiere modelar dependencias cuando existan;
- archivos introducen confirmaciones parciales;
- debugging debe considerar estado local y remoto.

### Evaluación

**Elegida.**

Es la alternativa que preserva la baseline offline-first sin sacrificar source of truth remota, historial ni aislamiento tenant.

---

## 30.5 Alternativa E — Event sourcing completo para todo el producto

### Descripción

Representar globalmente el estado de todos los bounded contexts como una secuencia completa de eventos inmutables y reconstruir proyecciones desde ese log.

### Ventajas potenciales

- trazabilidad exhaustiva de cambios;
- historial natural;
- replay de eventos;
- proyecciones derivadas.

### Desventajas

- complejidad arquitectónica considerable;
- necesidad de definir semántica de eventos, compatibilidad y evolución;
- reconstrucción y proyecciones más complejas;
- mayor superficie operativa y de testing;
- no existe baseline que lo requiera para el MVP;
- puede introducir una arquitectura más sofisticada que el problema necesita.

### Evaluación

**No seleccionada como baseline del MVP.**

Mantener históricos inmutables, `MaintenanceRevision`, outbox o ledger no equivale a adoptar event sourcing global.

Si en el futuro una necesidad demostrada justificara event sourcing en un bounded context concreto, requeriría una decisión específica.

---

# 31. Consequences

## 31.1 Consecuencias positivas

La decisión aporta:

- tolerancia a conectividad intermitente y prolongada;
- durabilidad de trabajo local pendiente;
- retries seguros;
- menor riesgo de duplicados;
- resolución de incertidumbre después de timeout o respuesta perdida;
- detección explícita de cambios concurrentes;
- conflictos visibles y recuperables;
- preservación de ambas versiones;
- prohibición efectiva de pérdida silenciosa por LWW;
- trazabilidad del origen y resultado de una divergencia;
- convergencia explícita con la source of truth remota;
- separación clara entre business state y sync state;
- coordinación segura de metadata y archivos;
- compatibilidad con tenant isolation y RLS;
- capacidad de reanudar después de crash o cierre de PWA.

## 31.2 Consecuencias negativas

La decisión introduce costes reales:

- más estados técnicos que gestionar;
- lifecycle de outbox;
- necesidad de identidad estable en operaciones reintentables;
- disciplina de idempotencia en cliente y servidor;
- clasificación entre retryable, blocked y conflict;
- necesidad de optimistic concurrency para recursos críticos;
- necesidad de UX para conflictos;
- reconciliación después de efectos confirmados;
- casos límite por confirmación parcial de archivos;
- debugging distribuido entre local y remoto aunque exista un solo deployable principal;
- futuras migraciones de réplica deben preservar outbox, identidades y pendientes;
- pruebas más amplias de crash safety y replay.

Estas consecuencias se consideran justificadas por el requisito de operar offline durante días sin perder trabajo ni históricos.

---

# 32. Security implications

Este ADR no constituye un threat model completo, pero introduce implicaciones obligatorias.

## 32.1 Replay

Una operación puede ser reenviada de forma legítima por retry o de forma manipulada.

La identidad estable e idempotencia deben impedir duplicación, mientras la autorización remota debe impedir que replay equivalga a permiso perpetuo.

## 32.2 Operación manipulada

Los payloads locales son no confiables.

La capa autoritativa debe validar:

- actor;
- tenant;
- ownership;
- client scope;
- invariantes;
- precondiciones de concurrencia.

## 32.3 Cross-tenant retry

Un retry no puede cambiar tenant, parent o recurso para aprovechar una operation ID válida.

Debe preservarse integridad cross-tenant en cada intento.

## 32.4 Stale authorization

Una operación creada offline puede haber sido válida al originarse y no estar autorizada al reconectar.

Debe revalidarse antes de aplicación remota cuando corresponda.

## 32.5 Revocación

Una revocación conocida bloquea aplicación no autorizada, pero no autoriza borrar trabajo capturado.

El destino final permanece abierto en `OFF-OPEN-001`.

## 32.6 Efectos privilegiados duplicados

Si una operación usa una frontera privilegiada en su implementación futura, la idempotencia debe impedir que un retry produzca efectos duplicados y la autorización debe seguir verificando contexto.

## 32.7 Upload cross-tenant

La correlación metadata/binario y la autorización de Storage deben impedir que un archivo de una Evidence termine asociado a un tenant o recurso distinto.

## 32.8 Exposición de payload local

La outbox puede contener información operativa sensible y referencias a archivos.

Su protección local pertenece principalmente a `ADR-0004` / `DO-T04`. Este ADR sólo registra que no debe ampliarse innecesariamente la información transportada o persistida para sincronizar.

## 32.9 Server-side revalidation

La PWA no es autoridad de seguridad. La sincronización debe volver a atravesar controles autoritativos server-side/RLS aplicables.

---

# 33. Data implications

Esta decisión implica conceptualmente que el futuro modelo físico deberá poder representar, de alguna forma equivalente:

- identidad estable de operación;
- intención pendiente durable;
- estado de sync independiente del business state;
- relación entre operación y recurso afectado;
- dependencias cuando existan;
- precondición/base esperada para optimistic concurrency cuando aplique;
- acknowledgement/resultado suficiente;
- estado remoto relevante para reconciliación;
- preservación de propuesta local y estado remoto en conflicto;
- correlación estable entre Evidence metadata y binario;
- archivos pendientes hasta confirmación suficiente.

## 33.1 Fuente de verdad

Supabase PostgreSQL permanece source of truth remota.

La outbox no adquiere autoridad global por ser durable localmente.

## 33.2 Historial

La outbox no es historial de negocio.

Después de converger, los históricos requeridos se expresan en los modelos de dominio correspondientes, como `MaintenanceRevision`, Evidence histórica o snapshots.

## 33.3 No se diseña persistencia física

Este ADR no define:

- tablas PostgreSQL;
- tablas IndexedDB;
- columnas;
- enums;
- foreign keys;
- constraints;
- índices;
- RLS policies;
- schema Dexie;
- payloads.

---

# 34. Testing implications

La implementación futura deberá demostrar conceptualmente, mediante pruebas apropiadas en cada nivel, al menos las siguientes propiedades.

## 34.1 Idempotencia

- retry de la misma operación no duplica el efecto lógico;
- doble entrega de creación no crea dos recursos;
- doble entrega de una corrección no crea dos revisiones;
- doble entrega de una resolución no crea dos `MaintenanceRevision`.

## 34.2 Respuesta perdida

- el servidor aplica el efecto;
- el cliente no recibe acknowledgement;
- el retry con la misma identidad reconoce el efecto previo;
- no se produce duplicado.

## 34.3 Timeout incierto

- un timeout no marca automáticamente la operación como fallo funcional;
- la intención permanece recuperable;
- el retry converge con seguridad.

## 34.4 Replay después de reconnect

- una operación conservada se reintenta con la misma identidad;
- la reconexión no crea una nueva intención accidental.

## 34.5 Operación duplicada

- múltiples entregas de la misma identidad producen un único efecto lógico.

## 34.6 Dependencias

- un child no se procesa cuando su parent todavía no es válido/remotamente reconocible;
- un parent en conflicto o bloqueado preserva sus children sin ejecución ciega.

## 34.7 Orden parcial

- operaciones independientes no necesitan FIFO global;
- las dependencias necesarias sí se respetan.

## 34.8 Optimistic concurrency mismatch

- una mutación sobre base obsoleta no sobrescribe el remoto;
- se preserva propuesta local;
- se preserva estado remoto;
- se entra en conflicto explícito.

## 34.9 Resolución de conflicto

- sólo actor autorizado puede resolver;
- la resolución converge;
- para Maintenance crea nueva `MaintenanceRevision`;
- revisiones previas permanecen.

## 34.10 Evidence upload retry

- reintentar upload/asociación no crea Evidence lógica duplicada;
- el archivo local permanece hasta confirmación suficiente.

## 34.11 Metadata confirmada, binario pendiente

- el sistema puede representar confirmación parcial sin declarar todo sincronizado;
- el binario pendiente no se elimina.

## 34.12 Autorización revocada antes de sync

- una operación ya capturada se conserva;
- no se aplica como si la autorización anterior siguiera vigente;
- no se resuelve por inferencia su destino final.

## 34.13 Cross-tenant operation

- una operación manipulada que cruza tenants es rechazada;
- retry/replay no evade tenant isolation.

## 34.14 Outbox y crash safety

- la outbox sobrevive cierre/reapertura dentro de las garantías del almacenamiento;
- un `in-flight` incierto se recupera sin duplicar;
- pendientes no confirmados no desaparecen.

## 34.15 Business state independiente

- un mantenimiento puede permanecer `FINALIZED` con sync pendiente o en conflicto;
- el sync state no degrada el business state.

## 34.16 No silent Last Write Wins

- una divergencia crítica no se resuelve automáticamente por “último timestamp” o “última llegada”.

Este ADR no escribe tests ejecutables ni selecciona frameworks de testing.

---

# 35. Observability implications

La implementación futura debería permitir distinguir de forma operativamente útil, cuando corresponda:

- backlog pendiente;
- operaciones intentando sincronizar;
- retries;
- acknowledgements;
- conflictos;
- operaciones bloqueadas;
- fallos permanentes;
- cantidad de pendientes visible para el usuario.

La observabilidad debe ayudar a diagnosticar si un problema está en:

- persistencia local;
- conectividad;
- autorización;
- dependencia;
- conflicto;
- archivo;
- acknowledgement;
- reconciliación.

Este ADR no define:

- vendor;
- sistema de logging;
- métricas exactas;
- dashboards técnicos;
- tracing concreto;
- SLO;
- alert thresholds;
- objetivos de capacidad.

`DO-T05` y `ADR-0016` permanecen diferidos.

---

# 36. Dependencies

## 36.1 Depende de

Este ADR depende de:

- `ADR-0001 = ACCEPTED`;
- `ADR-0002 = ACCEPTED`;
- baseline documental aprobada `00..10`.

En particular consume reglas aprobadas de:

- producto;
- modelo de dominio;
- autorización/RLS;
- offline/sync;
- Form Engine;
- Evidence;
- Reporting.

## 36.2 No depende para su decisión base de resolver

La decisión nuclear documentada aquí no requiere resolver previamente:

- `DO-T03`;
- `DO-T04`;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `FORM-OPEN-004`;
- `EVID-OPEN-*`;
- otros `DM/FORM/EVID/RPT/AI/PAY-OPEN`.

Esas decisiones pueden modificar flujos específicos de autorización, réplica, Evidence o Reporting, pero no cambian la necesidad arquitectónica de:

- identidad estable;
- idempotencia;
- acknowledgement;
- retry seguro;
- optimistic concurrency;
- conflicto explícito;
- preservación de ambas versiones;
- reconciliación.

## 36.3 Se relaciona con

Este ADR se relaciona con:

- `ADR-0004` — Offline local-first y aislamiento de réplica;
- `ADR-0009` — Modelo de `MaintenanceRevision` e histórico de mantenimiento;
- `ADR-0010` — Evidence histórica, replacement y continuidad entre revisiones;
- `ADR-0011` — Reporting: versionado, snapshots y finalización.

No los resuelve ni modifica su estado.

---

# 37. Decisions explicitly not made

Este ADR **NO decide**:

- schema Dexie;
- tablas PostgreSQL;
- tablas IndexedDB;
- columnas;
- foreign keys;
- constraints;
- índices;
- SQL;
- migrations;
- políticas RLS;
- funciones PostgreSQL;
- endpoints;
- REST;
- RPC;
- Server Actions;
- Route Handlers;
- Edge Functions;
- Supabase Functions;
- protocolo HTTP;
- códigos HTTP;
- headers;
- payload físico;
- retry counts;
- delays;
- backoff concreto;
- jitter;
- polling interval;
- Realtime channels;
- WebSocket protocol;
- message broker;
- queue vendor;
- cron;
- scheduler físico;
- workers;
- algoritmo físico de DAG;
- upload protocol;
- signed URLs;
- buckets;
- Storage paths;
- Storage policies ejecutables;
- merge algorithm general;
- conflict UI final;
- cleanup exacto de archivos;
- retención local exacta;
- purga tras revocación;
- destino de pendientes tras revocación;
- protección o cifrado de réplica;
- apertura/cierre de réplica;
- política de logout;
- event sourcing global;
- `ADR-0004`;
- `FORM-OPEN-004`;
- `EVID-OPEN-*`;
- `RPT-OPEN-009`;
- ningún otro `DO-*` o `*-OPEN-*`.

---

# 38. References

Fuentes normativas y arquitectónicas relevantes:

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

---

# 39. Supersession

`Supersedes: None`

`Superseded by: None`

---

# 40. Gate del ADR

## 40.1 Resultado

- **ADR generado:** `ADR-0005`
- **Title:** `Protocolo de sincronización, idempotencia y conflictos`
- **Status:** `ACCEPTED`
- **Decisión:** durable outbox + idempotencia + optimistic concurrency + conflictos explícitos
- **Source of truth remota:** Supabase PostgreSQL
- **Business state separado de sync state:** sí
- **Silent Last Write Wins para registros críticos:** prohibido
- **Identidad estable de operación:** requerida
- **Retry seguro:** requerido
- **Acknowledgement remoto suficiente:** requerido
- **Dependencias explícitas cuando correspondan:** requeridas
- **Optimistic concurrency para recursos críticos/versionados:** requerida cuando corresponda
- **Conflictos preservan ambas versiones:** sí
- **Resolución de conflicto:** explícita y por actor autorizado
- **Maintenance conflict resolution:** crea nueva `MaintenanceRevision`
- **Evidence pending files:** no se eliminan antes de confirmación remota suficiente
- **Reconciliación posterior a confirmación:** requerida
- **Tenant isolation:** preservado
- **RLS:** preservada como frontera primaria remota; no diseñada aquí
- **`OFF-OPEN-*` resueltos:** ninguno
- **Otros `DO-*` / `*-OPEN-*` resueltos:** ninguno
- **Código generado:** no
- **SQL generado:** no
- **Migrations:** no
- **Dexie schema:** no
- **Endpoints/APIs:** no
- **Retry policy física:** no
- **Otro ADR generado:** no
- **Implementación autorizada:** no
- **Aprobación del ADR:** completada

## 40.2 Validación de alcance

La decisión aceptada documenta exclusivamente el protocolo conceptual de convergencia entre intención local y estado remoto.

No invade:

- aislamiento/protección de réplica de `ADR-0004`;
- modelo físico de `MaintenanceRevision` de `ADR-0009`;
- semántica histórica abierta de Evidence de `ADR-0010`;
- política de Reporting de `ADR-0011`;
- decisiones de implementación posteriores.

## 40.3 Estado de Fase 0

`Estado de Fase 0: EN CURSO`

La aceptación de `ADR-0005` no cierra Fase 0 y no autoriza avanzar a Fase 1.
