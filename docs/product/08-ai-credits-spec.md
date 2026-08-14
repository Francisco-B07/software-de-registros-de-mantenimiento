# 08 — Especificación conceptual y funcional del subsistema de IA y créditos

> **Ruta normativa/objetivo:** `docs/product/08-ai-credits-spec.md`  
> **Estado:** **APROBADO — especificación conceptual y funcional del subsistema de IA y créditos del MVP**  
> **Fase:** Fase 0 — documento derivado  
> **Estado de Fase 0:** **EN CURSO**  
> **Baseline normativa:** `docs/product/01-product-definition.md`  
> **Modelo de dominio aprobado:** `docs/product/02-domain-model.md`  
> **Estrategia de permisos/RLS aprobada:** `docs/product/03-permissions-rls-strategy.md`  
> **Estrategia offline/sync aprobada:** `docs/product/04-offline-sync-strategy.md`  
> **Form Engine aprobado:** `docs/product/05-form-engine-spec.md`  
> **Maintenance Evidence aprobado:** `docs/product/06-maintenance-evidence-spec.md`  
> **Reporting Engine aprobado:** `docs/product/07-reporting-engine-spec.md`  
> **Naturaleza:** contrato conceptual y funcional del subsistema de IA y créditos; **NO constituye implementación, modelo físico, SQL, ledger físico, integración concreta de proveedor IA, integración de pagos, APIs, UI ni autorización para Codex**

---

# 1. Propósito y alcance

Este documento define la especificación conceptual y funcional del subsistema de IA y créditos del MVP.

Su objetivo es fijar, antes de cualquier implementación de Fase 7 o Fase 8, las reglas que determinan:

- qué representa una `AIUsageOperation`;
- cómo se autoriza una operación IA;
- cómo se relaciona exclusivamente con Reporting;
- qué representa la wallet conceptual de créditos de un tenant;
- qué representa el ledger inmutable;
- cómo se distinguen créditos disponibles, reservados, consumidos, liberados y compensados;
- cómo debe tratarse conceptualmente la reserva previa a una ejecución;
- cómo se confirma un consumo;
- cómo se libera una reserva;
- cómo se compensa un efecto económico de créditos ya reconocido;
- cómo se preserva idempotencia frente a retries, doble click y respuestas perdidas;
- cómo se evita sobreconsumo por concurrencia;
- cómo se tratan fallos previos, durante o posteriores a la llamada al proveedor;
- qué datos pueden enviarse a una capacidad IA;
- cómo se minimizan datos e identificadores;
- cómo se mantiene revisión humana obligatoria;
- cómo se relacionan operaciones históricas con modelo/proveedor sin fijar una integración concreta;
- cómo se conceptualiza la compra separada de créditos;
- cómo se preserva la independencia entre créditos IA y suscripción SaaS;
- qué información debe ser auditable y reconciliable;
- qué decisiones continúan abiertas antes de implementar IA y créditos.

Este documento debe actuar posteriormente como contrato funcional y arquitectónico para:

- autorización de uso IA;
- integración server-side de IA;
- diseño físico de `AIUsageOperation`;
- diseño físico del ledger;
- política de costos;
- mecanismos de reserva, consumo, liberación y compensación;
- idempotencia;
- concurrencia;
- reconciliación;
- integración futura con compras de créditos;
- observabilidad;
- pruebas de seguridad y dominio.

## 1.1 Autoridad

Se aplica el siguiente orden de autoridad:

1. `docs/product/01-product-definition.md`;
2. `docs/product/02-domain-model.md`;
3. `docs/product/03-permissions-rls-strategy.md`;
4. `docs/product/04-offline-sync-strategy.md`;
5. `docs/product/05-form-engine-spec.md`;
6. `docs/product/06-maintenance-evidence-spec.md`;
7. `docs/product/07-reporting-engine-spec.md`;
8. `docs/product/00-master-product-brief.md`;
9. decisiones explícitamente aprobadas posteriormente dentro del Project que no hayan sido sustituidas.

Este documento profundiza exclusivamente IA y créditos. No reinterpreta ni reabre decisiones de Reporting, Form Engine, Evidence, Offline, mantenimiento, suscripción o pagos que pertenezcan a otros bounded contexts.

## 1.2 Revisión previa de coherencia

No se detectan contradicciones bloqueantes conocidas entre `01..07` que impidan definir conceptualmente este subsistema.

Se preservan como reglas cerradas:

- IA se limita a asistencia textual/editorial dentro de Reporting;
- sólo `COMPANY_ADMIN` inicia operaciones IA;
- `TECHNICIAN` no utiliza IA;
- `SUPER_ADMIN` no utiliza IA tenant por defecto;
- `SupportAccessGrant` no crea capacidad de uso IA por inferencia;
- Reporting puede funcionar completamente sin IA;
- IA no modifica mantenimientos, revisiones, respuestas, Evidence ni hechos técnicos;
- IA no decide inclusión/exclusión de mantenimientos;
- IA no asigna número oficial;
- IA no finaliza Report;
- IA sobre imágenes y OCR están fuera del MVP;
- las llamadas de IA son exclusivamente server-side;
- los secretos no se exponen al navegador;
- cada tenant posee sus propios créditos;
- los créditos se compran separadamente de la suscripción;
- la suscripción no incluye créditos automáticamente;
- no existen créditos ni límites IA por usuario;
- cada operación IA autorizada consume créditos conforme a la política de costo aplicable;
- una operación nueva durante regeneración vuelve a consumir créditos;
- un retry técnico de la misma operación lógica no puede generar doble consumo silencioso;
- los fallos deben liberar o compensar el efecto económico según el protocolo aprobado;
- `AICreditLedgerEntry` es inmutable;
- el saldo no puede depender únicamente de un campo mutable sin historia;
- `DM-OPEN-007` continúa abierta;
- `DO-T01` continúa no aprobada.

La baseline normativa menciona OpenAI como integración inicial y obliga a realizar las llamadas desde servidor. Este documento no selecciona modelo, endpoint, API, SDK ni contrato concreto y define una frontera conceptual que no acopla las reglas de créditos e histórico a un modelo específico. No se considera una contradicción bloqueante.

## 1.3 Fuera del alcance

Este documento **NO define ni autoriza**:

- SQL;
- tablas físicas;
- columnas;
- claves físicas;
- índices;
- migrations;
- enums físicos;
- triggers;
- RPC;
- locks concretos;
- transacciones SQL;
- ledger físico;
- funciones PostgreSQL;
- jobs;
- queues;
- workers;
- cron;
- webhooks;
- APIs;
- endpoints;
- Server Actions;
- componentes React;
- UX visual definitiva;
- modelo OpenAI concreto;
- endpoint OpenAI concreto;
- Responses API, Chat Completions u otra API concreta;
- SDK concreto;
- prompts productivos;
- tool calling;
- streaming;
- parámetros de inferencia;
- proveedor alternativo concreto;
- Mercado Pago concreto;
- checkout;
- state machine física de pagos;
- paquetes comerciales reales;
- cantidades de créditos por paquete;
- precios;
- equivalencia crédito/token;
- equivalencia crédito/ARS;
- margen comercial;
- expiración de créditos;
- promociones o créditos gratuitos;
- implementación mediante Codex;
- ADRs.

---

# 2. Terminología

Los siguientes términos constituyen el lenguaje ubicuo de este subsistema.

| Término | Definición conceptual |
|---|---|
| **`AIUsageOperation`** | Solicitud lógica, tenant-owned e idempotentemente identificable de asistencia editorial mediante IA, iniciada por un `COMPANY_ADMIN` en el contexto permitido de Reporting. |
| **AI-assisted text** | Texto sugerido por IA y todavía sujeto a revisión humana. No es fuente de verdad técnica ni contenido oficial por sí mismo. |
| **AI credit** | Unidad comercial interna utilizada para representar capacidad de consumo de operaciones IA. No equivale por definición a un token, unidad monetaria ni costo de proveedor. |
| **Tenant credit wallet** | Posición conceptual tenant-wide de créditos IA, derivable de movimientos históricos y sus efectos. No existe wallet por usuario. |
| **`AICreditLedgerEntry`** | Movimiento individual inmutable que registra un efecto autorizado sobre la posición de créditos del tenant. |
| **Available credits** | Créditos que, conforme al ledger y las reservas vigentes, pueden ser admitidos para nuevas operaciones. |
| **Reserved credits** | Créditos temporalmente comprometidos para operaciones admitidas pero todavía no asentadas como consumo final o liberadas. |
| **Consumed credits** | Créditos cuyo consumo quedó confirmado para una operación IA según la política aprobada. |
| **Released credits** | Créditos previamente reservados cuyo compromiso fue deshecho de manera trazable sin convertirlos en consumo final. |
| **Compensation** | Movimiento técnico posterior que corrige el efecto económico en créditos de una operación IA previamente consumida o asentada de forma que deba neutralizarse. No edita el movimiento original. |
| **Credit purchase** | Hecho comercial tenant-owned por el cual una compra confirmada válidamente puede originar un incremento de créditos. Su procesamiento físico pertenece al subsistema de pagos. |
| **Credit grant** | Otorgamiento no derivado de una compra, si en el futuro se aprueba una política expresa para ello. No existe promoción/grant aprobada por esta especificación. |
| **Credit adjustment** | Movimiento excepcional de corrección administrativa, si en el futuro se aprueba una capacidad y autoridad explícitas para realizarlo. |
| **Idempotency** | Propiedad por la cual repetir la misma intención lógica no produce una segunda operación facturable ni efectos económicos duplicados. |
| **Retry** | Nuevo intento técnico de completar u obtener el resultado de la misma operación lógica. Conserva identidad idempotente. |
| **Duplicate request** | Solicitud repetida que representa la misma intención lógica, por ejemplo doble click o reenvío por pérdida de respuesta. Debe resolverse hacia la misma operación, no crear otra facturable. |
| **Operation cost** | Cantidad de créditos que una política de costos asigna a una operación lógica. Debe quedar determinada conforme a la política aprobada antes de la confirmación de la operación. |
| **Usage result** | Resultado generado por una operación IA que el sistema puede presentar para revisión humana, sujeto a validación funcional mínima. |
| **AI disabled** | Estado tenant-wide en el que no se admiten nuevas operaciones IA iniciadas por usuarios. No elimina saldo, histórico ni Reporting manual. |
| **Insufficient credits** | Situación en la que el tenant no dispone de créditos reservables suficientes para admitir una operación bajo la política aprobada. |

## 2.1 Operación IA vs movimiento de ledger

`AIUsageOperation` representa la intención y ejecución funcional.

`AICreditLedgerEntry` representa un efecto económico en créditos.

Una operación puede relacionarse con varios movimientos a lo largo de su ciclo, por ejemplo reserva, consumo, liberación o compensación, según el protocolo que finalmente se apruebe.

No deben fusionarse ambos conceptos en una única entidad mutable.

## 2.2 Balance vs ledger

El ledger es historia inmutable.

El balance es una posición calculada o proyectada a partir de esa historia y de la semántica aprobada de los movimientos.

Un balance materializado puede existir en el futuro como optimización, pero no reemplaza la historia ni puede ser la única fuente sin reconciliación.

## 2.3 Reserva vs consumo

Reservar significa comprometer capacidad disponible para una operación admitida.

Consumir significa reconocer el cargo final de créditos según la política de uso.

Una reserva no debe interpretarse automáticamente como consumo final.

## 2.4 Refund comercial vs compensación técnica

Un refund comercial revierte o devuelve dinero relacionado con una compra y pertenece al bounded context de pagos.

Una compensación técnica de créditos corrige el efecto de una operación IA fallida o incorrectamente asentada.

No son equivalentes y pueden ocurrir por causas distintas.

## 2.5 Retry vs nueva operación

Retry técnico = misma intención lógica, misma identidad idempotente, sin nuevo cargo.

Nueva solicitud deliberada = nueva intención de generar/reformular/reintentar editorialmente un contenido y puede constituir una nueva operación facturable.

## 2.6 Compra de créditos vs suscripción

Comprar créditos aumenta capacidad de uso IA conforme a la confirmación comercial correspondiente.

La suscripción determina derecho comercial de acceso al SaaS.

Tener una no sustituye a la otra.

---

# 3. Ownership

Toda información y todo efecto económico de este bounded context debe pertenecer inequívocamente a un tenant.

Son tenant-owned, como mínimo conceptualmente:

- `AIUsageOperation`;
- `AICreditLedgerEntry`;
- tenant credit wallet;
- credit purchase;
- credit grant, si se aprueba;
- credit adjustment, si se aprueba;
- configuración tenant-wide de habilitación/deshabilitación de IA;
- cualquier relación entre una operación IA y un Report;
- metadata de costo aplicada a una operación;
- resultados IA persistidos cuando corresponda.

La cadena de ownership debe ser coherente con el Report y los datos fuente utilizados.

No es válido que:

- una operación de Tenant A consuma créditos de Tenant B;
- un ledger entry de Tenant A se relacione con una operación de Tenant B;
- un Report de Tenant A utilice una wallet de otro tenant;
- una compra confirmada para un tenant acredite otro tenant;
- el navegador elija el tenant efectivo mediante un `tenant_id` no verificado.

Este documento no diseña claves físicas ni relaciones SQL.

---

# 4. Actores y permisos

## 4.1 `COMPANY_ADMIN`

Dentro de su propio tenant y sujeto al estado comercial aplicable, `COMPANY_ADMIN` puede:

- consultar si IA está habilitada;
- habilitar o deshabilitar IA para su empresa;
- utilizar IA en Reporting cuando esté habilitada;
- solicitar operaciones IA autorizadas;
- consultar el saldo de créditos de su tenant;
- consultar el historial de movimientos conforme al nivel de detalle aprobado;
- iniciar el futuro flujo comercial de compra de créditos;
- revisar una sugerencia IA;
- editarla;
- rechazarla;
- aceptarla conscientemente;
- continuar Reporting sin IA.

La capacidad de administrar créditos no autoriza:

- editar movimientos históricos;
- fabricar saldo;
- modificar el tenant de una operación;
- forzar sobregiro;
- saltar autorización o estado comercial;
- acceder a créditos de otro tenant.

## 4.2 `TECHNICIAN`

`TECHNICIAN`:

- no utiliza IA;
- no inicia `AIUsageOperation`;
- no compra créditos;
- no administra wallet;
- no habilita/deshabilita IA;
- no consulta ledger por inferencia;
- no recibe límites ni créditos por usuario porque ese concepto está fuera del MVP.

Su acceso a mantenimientos no se transforma en acceso a IA ni Reporting.

## 4.3 `SUPER_ADMIN`

`SUPER_ADMIN`:

- no utiliza IA tenant por defecto;
- no consume créditos de tenants por defecto;
- no dispone de una wallet tenant propia por ser actor global;
- no obtiene automáticamente capacidad de ajuste de créditos;
- no obtiene capacidad de ejecutar IA por recibir soporte excepcional.

La baseline permite que un `SupportAccessGrant` incluya el scope tenant-wide `créditos IA`. Ese scope puede habilitar el acceso excepcional de soporte expresamente concedido a la sección correspondiente, pero **no crea por inferencia**:

- capacidad de generar texto con IA;
- capacidad de consumir créditos;
- capacidad de comprar en nombre del tenant;
- capacidad de otorgar créditos;
- capacidad de ajustar saldo;
- capacidad de editar ledger.

Cualquier capacidad global excepcional de otorgamiento o ajuste debe aprobarse expresamente y se trata en `AI-OPEN-007`.

## 4.4 Principio conservador

Se mantiene la regla de autorización ya aprobada:

> ausencia de permiso aprobado = no se infiere permiso.

---

# 5. `AIUsageOperation`

`AIUsageOperation` representa una solicitud lógica de asistencia IA.

Debe poder preservar conceptualmente, sin fijar columnas:

- tenant propietario;
- actor que inició la intención;
- contexto de Report autorizado;
- tipo funcional de operación;
- identidad idempotente estable;
- política/costo aplicable a esa operación;
- estado conceptual de admisión;
- estado conceptual de ejecución;
- resultado, fallo o incertidumbre de ejecución;
- vínculo con movimientos de ledger asociados;
- metadata mínima de proveedor/modelo necesaria para trazabilidad futura;
- información suficiente para reconciliación y troubleshooting sin almacenar datos innecesarios.

## 5.1 Invariantes

Una `AIUsageOperation`:

- pertenece a exactamente un tenant;
- sólo puede iniciarse por `COMPANY_ADMIN`;
- sólo puede existir en contexto permitido de Reporting;
- no puede modificar datos técnicos;
- no puede modificar Evidence;
- no puede decidir candidatos de Report;
- no puede asignar número oficial;
- no puede finalizar el Report;
- no debe ejecutarse desde el navegador contra el proveedor;
- debe ser idempotentemente reconocible;
- debe poder conciliarse con sus efectos de créditos.

## 5.2 Resultado no oficial

Completar una `AIUsageOperation` no convierte automáticamente su salida en contenido oficial.

La salida continúa siendo AI-assisted text hasta que `COMPANY_ADMIN` la revise y decida conscientemente cómo incorporarla o descartarla.

---

# 6. Tipos de operación IA

El subsistema debe permitir clasificar conceptualmente operaciones editoriales de Reporting.

Categorías razonables incluyen, sin convertirlas todas en funcionalidades obligatorias:

- resumen ejecutivo;
- síntesis del período;
- observaciones narrativas;
- conclusiones;
- recomendaciones redactadas;
- descripción narrativa de trabajos;
- explicación textual basada en mediciones permitidas;
- reescritura o mejora textual de contenido editorial.

Estas categorías describen familias de intención. La implementación futura puede aprobar sólo un subconjunto.

## 6.1 Costo por tipo

La baseline permite que distintas funcionalidades consuman cantidades diferentes de créditos.

Por ello, el tipo de operación debe ser suficiente para participar en la determinación del costo cuando la política aprobada así lo establezca.

No se fijan valores ni una tabla física de costos.

La política exacta queda en `AI-OPEN-001`.

---

# 7. Wallet conceptual

Cada tenant posee una única posición conceptual tenant-wide de créditos IA.

No existen:

- wallets por usuario;
- créditos asignados a `COMPANY_ADMIN` individuales;
- límites de créditos por usuario.

La wallet debe permitir comprender al menos:

- créditos disponibles;
- créditos actualmente reservados;
- consumos históricos;
- incrementos provenientes de compras confirmadas;
- liberaciones;
- compensaciones;
- grants o ajustes sólo si se aprueban posteriormente.

## 7.1 Wallet como vista, no como historia

La wallet es una representación de posición.

No debe ser tratada como un único número mutable que pueda incrementarse/decrementarse sin historia.

Su valor debe ser derivable del ledger y de la semántica de los movimientos aprobados.

Este documento no define si se materializa físicamente una proyección de balance.

---

# 8. Ledger inmutable

Todo cambio relevante de la posición de créditos debe dejar historia inmutable.

No se corrige el pasado modificando un movimiento anterior.

Conceptualmente pueden existir movimientos equivalentes a:

- compra confirmada;
- reserva;
- consumo;
- liberación;
- compensación;
- grant, si se aprueba;
- ajuste administrativo, si se aprueba;
- reversión comercial reflejada en créditos, cuando el subsistema de pagos la defina.

Esta lista **no fija un enum físico**.

## 8.1 Semántica de posición

El diseño conceptual debe distinguir entre:

- movimientos que incrementan capacidad disponible;
- movimientos que comprometen disponible como reservado;
- movimientos que convierten reserva en consumo;
- movimientos que liberan reserva;
- movimientos que restauran capacidad por compensación.

No se exige aquí un modelo contable de partida doble ni una estructura física específica.

## 8.2 Inmutabilidad

Una vez creado, un movimiento histórico no se edita para cambiar:

- tenant;
- cantidad;
- motivo;
- operación asociada;
- tipo funcional;
- efecto económico.

Una corrección posterior se representa mediante otro movimiento autorizado y trazable.

---

# 9. Fuente de verdad del saldo

El ledger es la fuente histórica autoritativa de los efectos de créditos.

El balance puede ser:

- calculado directamente a partir del ledger;
- materializado como proyección;
- cacheado como optimización;
- mantenido mediante otra estrategia técnica futura.

Cualquiera de esas optimizaciones debe ser reconciliable con el ledger.

Queda prohibido conceptualmente:

- utilizar un campo mutable `balance` como única fuente de verdad sin historia;
- modificar ese campo para “arreglar” inconsistencias sin movimientos correspondientes;
- aceptar que una caché divergente prevalezca sobre el ledger sin reconciliación.

## 9.1 Disponibilidad

Los créditos disponibles deben considerar las reservas vigentes.

Por tanto, “saldo total histórico” y “capacidad disponible para una nueva operación” no son necesariamente el mismo valor durante operaciones en curso.

---

# 10. Costos en créditos

La baseline permite costos distintos por funcionalidad.

El costo funcional de una operación debe ser determinable antes de confirmar su admisión y debe quedar preservado para esa `AIUsageOperation` aunque una configuración global cambie posteriormente.

No se inventan valores.

## 10.1 Alternativas conceptuales

### Costo fijo por operación

Cada tipo implementado posee una cantidad fija de créditos.

Ventajas:

- simple de explicar;
- costo conocido antes de ejecutar;
- reserva exacta simple;
- experiencia predecible.

Riesgos:

- el costo real del proveedor puede variar;
- operaciones muy desiguales pueden compartir precio interno si la taxonomía es demasiado gruesa.

### Costo configurable por tipo

Cada tipo tiene un costo funcional configurable por plataforma.

Ventajas:

- conserva previsibilidad para el cliente;
- permite adaptar costos comerciales sin cambiar código conceptual;
- permite diferencias entre funcionalidades.

Riesgos:

- requiere versionar/recordar el costo aplicado a cada operación;
- requiere controles para que un cambio de configuración no altere retrospectivamente operaciones admitidas.

### Costo variable según uso real

El costo final depende de consumo real del proveedor, tokens u otra métrica.

Ventajas:

- puede aproximar mejor costo interno.

Riesgos:

- dificulta mostrar costo exacto antes de ejecutar;
- complica reserva;
- mezcla métrica de proveedor con unidad comercial;
- puede producir sorpresa al usuario;
- aumenta complejidad de conciliación.

### Modelo combinado

Puede existir precio base, tope o bandas.

Ventaja: flexibilidad.

Riesgo: mayor complejidad funcional y comercial para el MVP.

La decisión se formaliza en `AI-OPEN-001`.

---

# 11. Visibilidad del costo

Antes de iniciar una operación facturable, `COMPANY_ADMIN` necesita una experiencia suficientemente transparente para comprender el efecto en créditos.

Posibles niveles de información:

- costo exacto;
- costo máximo;
- estimación;
- saldo disponible actual;
- saldo disponible esperado después de reservar/consumir;
- indicación de créditos insuficientes.

La visibilidad está ligada a la política de costo.

Si el costo es fijo/configurable por tipo, puede conocerse exactamente antes de ejecutar.

Si el costo fuera variable por uso real, sólo podrían conocerse estimaciones o topes salvo una política adicional.

La decisión se integra en `AI-OPEN-001`.

---

# 12. `DM-OPEN-007` — créditos insuficientes

`DM-OPEN-007` continúa abierta y este documento no la resuelve.

## 12.1 Alternativa A — rechazar antes de ejecutar

La operación no se admite si no existe capacidad disponible/reservable suficiente.

Ventajas:

- evita deuda accidental;
- evita saldo negativo;
- simplifica conciliación;
- hace el costo predecible;
- evita asumir riesgo comercial no aprobado.

Desventaja:

- interrumpe la acción hasta que el tenant adquiera créditos.

## 12.2 Alternativa B — permitir sobregiro

La operación se ejecuta aunque el saldo disponible sea menor al costo.

Ventaja:

- continuidad inmediata de UX.

Riesgos:

- crea deuda implícita;
- requiere política de cobranza;
- permite saldo negativo;
- complica límites y conciliación;
- no existe aprobación comercial para ello.

## 12.3 Alternativa C — reservar hasta cero y cobrar después

Se consume lo disponible y queda un remanente pendiente.

Riesgos:

- mezcla créditos prepagos con deuda;
- rompe la idea de reserva suficiente;
- requiere un bounded context de deuda no aprobado.

## 12.4 Alternativa D — permitir deuda explícita

Se registra un saldo negativo/deuda que deberá regularizarse.

Riesgos:

- introduce crédito financiero/comercial no definido;
- requiere reglas de cobranza, suspensión y posible límite;
- complejidad desproporcionada para el MVP.

## 12.5 Alternativa E — rechazar y ofrecer compra

Se rechaza la admisión y la UI puede orientar al futuro flujo de compra de créditos.

Ventajas:

- mantiene contabilidad simple;
- conserva separación entre ejecución IA y compra;
- no ejecuta proveedor sin capacidad de pago en créditos.

## 12.6 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:** combinar A + E:

- rechazar la nueva operación antes de ejecutar si el tenant no dispone de créditos disponibles/reservables suficientes;
- no permitir deuda ni sobregiro implícito;
- no permitir saldo negativo accidental;
- ofrecer acceso al futuro flujo de compra de créditos;
- no comenzar una llamada al proveedor mientras no se haya asegurado conceptualmente la capacidad de consumo conforme a `DO-T01`.

**Estado:** `DM-OPEN-007 = ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 7.

---

# 13. `DO-T01` — protocolo conceptual del ledger IA

`DO-T01` continúa no aprobado.

Este documento profundiza la propuesta existente sin definir implementación física.

## 13.1 Secuencia nominal propuesta

La secuencia conceptual recomendada es:

1. recibir la intención;
2. autenticar al actor;
3. resolver su tenant y autorización;
4. comprobar que IA esté habilitada y que el tenant pueda operar online;
5. identificar idempotentemente la operación lógica;
6. determinar y congelar el costo funcional aplicable;
7. admitir/reservar créditos de manera conceptualmente atómica respecto de la disponibilidad;
8. iniciar ejecución con el proveedor;
9. validar/persistir el resultado de uso cuando corresponda;
10. confirmar consumo;
11. entregar/reentregar el resultado al cliente sin volver a cobrar.

Representación resumida:

**request → autorización → identidad idempotente → costo → reserva → ejecución → resultado persistido → confirmación de consumo → respuesta**.

## 13.2 Fallo antes de ejecución

Si se reservó capacidad pero no comenzó la ejecución del proveedor:

**reserva → fallo pre-ejecución → liberación**.

No existe razón funcional para conservar un consumo final.

## 13.3 Fallo durante ejecución con resultado no utilizable

Cuando puede determinarse que la operación no produjo un `usage result` utilizable conforme a la política aprobada:

**reserva → ejecución fallida → liberación**, si aún no existió consumo final;

o:

**consumo ya asentado → compensación posterior**, si el efecto económico ya se confirmó y necesita neutralizarse.

## 13.4 Ejecución completada

Una ejecución válida debe persistir suficiente estado/resultado antes de depender de que el navegador reciba la respuesta.

Luego se confirma el consumo.

La pérdida de la respuesta HTTP al navegador no debe deshacer el hecho de que la operación se completó ni crear una nueva operación facturable.

## 13.5 Resultado ambiguo del proveedor

Un timeout o corte de red después de enviar la solicitud puede dejar incierto si el proveedor procesó la operación.

No debe asumirse automáticamente:

- que no ejecutó;
- que sí ejecutó;
- que es seguro repetir la llamada creando una operación nueva.

La operación debe permanecer identificable y reconciliable dentro del mismo intento lógico.

La política técnica de retry del proveedor dependerá de las garantías reales de la integración que se seleccione posteriormente. Este documento no presupone idempotencia externa del proveedor.

## 13.6 Respuesta de red perdida al cliente

Si servidor/proveedor completaron pero el navegador no recibió respuesta:

- el retry debe resolver la misma identidad idempotente;
- si existe resultado persistido, debe poder reentregarse;
- no se crea una segunda operación facturable;
- no se duplica el consumo.

## 13.7 Concurrencia

La admisión/reserva debe impedir que dos operaciones concurrentes utilicen simultáneamente la misma capacidad disponible si la política no permite saldo negativo.

No se define lock ni transacción física.

## 13.8 Reservas huérfanas

Toda reserva que quede sin consumo ni liberación debe ser detectable y reconciliable.

No se permite que una reserva permanezca abandonada indefinidamente como único resultado de un fallo técnico.

## 13.9 Inmutabilidad

Liberar o compensar no modifica el movimiento histórico original.

La corrección se expresa mediante nuevos efectos conciliables.

## 13.10 Estado

**`DO-T01 = PROPUESTA PENDIENTE DE APROBACIÓN`.**

No se declara resuelta ni aprobada.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 7 y antes del diseño físico del ledger.

---

# 14. Reserva de créditos

La reserva tiene dos propósitos principales:

1. no ejecutar una operación que luego no pueda pagarse en créditos conforme a la política aprobada;
2. reducir carreras concurrentes sobre la misma capacidad disponible.

Una reserva:

- pertenece al mismo tenant que la operación;
- debe vincularse a una intención idempotente;
- compromete créditos disponibles;
- no es todavía consumo final;
- debe terminar en consumo, liberación o tratamiento reconciliado;
- no puede permanecer huérfana indefinidamente.

No se define su mecanismo físico.

---

# 15. Consumo

El consumo representa el reconocimiento definitivo de créditos utilizado por una operación IA conforme a la política aprobada.

Debe cumplir:

- misma operación lógica = no más de un consumo económico final no compensado;
- mismo tenant entre operación y ledger;
- costo aplicado preservado;
- resultado de la operación suficientemente determinado;
- conciliación posible con la reserva cuando el protocolo la utilice.

El consumo **no depende** de que el navegador haya recibido correctamente la respuesta.

Una vez completada la operación y asentado el consumo, un retry de entrega no constituye un nuevo consumo.

---

# 16. Liberación

La liberación devuelve a disponibilidad créditos reservados que no deben convertirse en consumo.

Puede corresponder, por ejemplo, cuando:

- la ejecución no comenzó;
- la operación fue rechazada después de una reserva por una condición validada antes de llamar al proveedor;
- existió un fallo determinista que impide producir un resultado utilizable y aún no se había confirmado consumo.

La liberación debe ser:

- trazable;
- tenant-consistente;
- idempotente respecto del mismo efecto;
- conciliable con la reserva;
- representada sin editar historia previa.

---

# 17. Compensación

La compensación es distinta de la liberación.

Se utiliza cuando ya existe un efecto de consumo reconocido que debe neutralizarse o corregirse por una causa técnica autorizada.

Ejemplos conceptuales:

- operación asentada como consumida y posteriormente determinada como fallida según la política aprobada;
- incidente de conciliación que requiere restaurar créditos sin borrar el consumo histórico.

Una compensación:

- no es un refund monetario;
- no revierte una compra comercial por sí misma;
- no es una promoción;
- no borra el movimiento original;
- debe incluir motivo suficiente;
- debe ser auditable y reconciliable.

---

# 18. Estados conceptuales de `AIUsageOperation`

La entidad debe poder representar el lifecycle necesario para admisión, ejecución, retries y reconciliación.

Estados o situaciones conceptuales relevantes incluyen:

- requested;
- reserved/admitted;
- executing;
- completed;
- failed;
- execution outcome unknown;
- cancelled, si se aprueba la capacidad;
- reconciliation required.

En paralelo, el efecto de créditos puede encontrarse conceptualmente como:

- no reservado;
- reservado;
- consumido;
- liberado;
- compensado;
- pendiente de reconciliación.

## 18.1 No fijar un único enum físico

No se exige que ejecución y settlement formen una sola state machine física.

Mantenerlos conceptualmente separables evita estados ambiguos como “failed” sin saber si los créditos quedaron reservados, consumidos o compensados.

La representación física se definirá después de aprobar `DO-T01`.

---

# 19. Idempotencia

Toda operación IA debe poseer identidad idempotente estable durante su intención lógica.

La misma operación reintentada por:

- timeout;
- pérdida de respuesta;
- doble click;
- retry automático;
- reenvío del navegador;
- reanudación después de una interrupción;

no debe producir:

- dos `AIUsageOperation` facturables;
- dos reservas independientes;
- dos consumos definitivos;
- dos ejecuciones del proveedor por defecto si el sistema ya conoce una ejecución válida.

## 19.1 Alcance

La identidad idempotente debe permitir distinguir:

- misma intención técnica reintentada;
- nueva solicitud deliberada del usuario.

No se define formato UUID, header, clave física ni mecanismo de transporte.

## 19.2 Idempotencia interna vs proveedor

La idempotencia del sistema propio debe existir independientemente de que el proveedor externo ofrezca o no una garantía equivalente.

Una futura integración deberá documentar cómo evita o trata doble ejecución externa en resultados ambiguos.

---

# 20. Nueva operación vs retry

## 20.1 Retry técnico

Es la continuidad de la misma intención lógica.

Ejemplos:

- el usuario no recibió la respuesta;
- el cliente reenvía automáticamente;
- el servidor reintenta una operación cuyo resultado técnico es recuperable;
- la aplicación reconsulta una operación en progreso.

Consecuencias:

- conserva identidad idempotente;
- no crea un nuevo cargo;
- debe reutilizar/reconciliar el estado existente.

## 20.2 Nueva solicitud deliberada

Es una nueva intención editorial.

Ejemplos:

- “generar otra versión”;
- “reescribir nuevamente”;
- “probar una recomendación diferente”;
- solicitar de nuevo una síntesis después de haber recibido la anterior.

Consecuencias:

- puede crear una nueva `AIUsageOperation`;
- puede requerir una nueva reserva;
- puede consumir créditos nuevamente.

La UI futura debe evitar confundir “reintentar porque falló la red” con “generar otra respuesta”.

---

# 21. Regeneración de Report

Una regeneración de Report no obliga a utilizar IA.

Si `COMPANY_ADMIN` decide realizar una **nueva operación IA** durante la preparación de una regeneración:

- constituye una nueva intención;
- puede consumir nuevamente créditos;
- no recibe crédito gratuito por haberse usado IA en una versión anterior.

Si lo que ocurre es un retry técnico de la misma operación IA ya iniciada dentro de esa regeneración:

- no constituye nueva operación;
- no debe duplicar el cargo.

Este documento no modifica `RPT-OPEN-011` ni ninguna regla de regeneración de Reporting.

---

# 22. Concurrencia

Escenario de referencia:

- créditos disponibles = 10;
- Admin A inicia una operación de costo 8;
- Admin B inicia simultáneamente otra operación de costo 8.

Si la política aprobada no permite sobregiro, ambas no pueden ser admitidas.

El sistema debe garantizar conceptualmente que la verificación de disponibilidad y la reserva/admisión se coordinen de forma suficientemente atómica/serializable para evitar doble uso de la misma capacidad.

No se diseña:

- lock concreto;
- aislamiento SQL;
- RPC;
- transacción;
- cola.

## 22.1 Resultado esperado bajo la propuesta de `DM-OPEN-007`

Una operación puede reservar 8.

La otra debe observar que ya no existen 8 créditos reservables y ser rechazada como insuficiente, sin llamar al proveedor.

---

# 23. Saldo insuficiente durante concurrencia

La comprobación de créditos no puede residir únicamente en frontend.

Una UI puede mostrar “saldo 10” y quedar obsoleta milisegundos después.

La autoridad de admisión debe evaluar el estado autoritativo actual de la wallet/ledger y reservas vigentes dentro de una frontera confiable.

El comportamiento final depende de `DM-OPEN-007`.

No se permite aceptar ambas operaciones por haber superado previamente una validación visual local.

---

# 24. Fallo antes de llamar al proveedor

Puede ocurrir que una operación haya sido autorizada y reservada pero falle antes de comenzar la ejecución externa.

Ejemplos conceptuales:

- fallo interno al preparar el contexto;
- validación final de payload no superada;
- configuración de proveedor no disponible;
- error interno previo a enviar la solicitud.

La reserva debe poseer una vía conciliable de liberación.

No se debe:

- dejar consumo final;
- dejar la reserva indefinidamente;
- crear una operación nueva sólo para liberar.

---

# 25. Fallo del proveedor

El subsistema debe tratar como clases distintas de fallo, sin inventar códigos concretos:

- timeout;
- error HTTP;
- error explícito del proveedor;
- rate limit;
- respuesta inválida o no interpretable;
- fallo interno de integración;
- conexión interrumpida;
- resultado ambiguo después de enviar la solicitud.

## 25.1 Fallo determinista sin resultado utilizable

Si se conoce que no existe un resultado utilizable:

- no debe quedar un consumo final no compensado bajo la política recomendada;
- la reserva se libera o el consumo se compensa, según la etapa alcanzada.

## 25.2 Fallo ambiguo

Si no se sabe si el proveedor ejecutó:

- no se debe asumir éxito o fracaso arbitrariamente;
- no se debe crear otra operación facturable;
- se debe conservar estado suficiente para reconciliación;
- un retry externo sólo debe realizarse conforme a las garantías de la integración futura.

---

# 26. Respuesta perdida después de ejecución

Escenario crítico:

1. el proveedor ejecuta;
2. el servidor recibe y persiste un resultado válido;
3. el consumo queda confirmado o encaminado a confirmación;
4. la respuesta al navegador se pierde;
5. el usuario reintenta.

La solución conceptual debe ser:

- resolver la identidad idempotente existente;
- devolver el resultado persistido o el estado actual;
- no llamar nuevamente al proveedor por defecto;
- no crear una nueva operación;
- no consumir nuevamente créditos.

El click o la recepción del navegador no constituyen prueba de consumo.

---

# 27. Resultado parcial

La baseline no define si una respuesta parcial/incompleta debe considerarse consumida.

Posibles políticas:

### A — consumir siempre que el proveedor haya incurrido en trabajo

Ventaja: alinea mejor con costo interno.

Riesgo: el cliente paga por un resultado que el producto considera no utilizable.

### B — consumir sólo si existe resultado válido/utilizable

Ventaja: UX simple y orientada a valor recibido.

Riesgo: la plataforma absorbe costos internos de fallos parciales.

### C — consumo parcial/proporcional

Riesgo: aumenta considerablemente complejidad y hace menos predecible el sistema de créditos.

La decisión se registra en `AI-OPEN-002`.

---

# 28. Cancelación por usuario

La baseline no aprueba una capacidad de cancelación de una operación IA ya iniciada.

Introducirla afecta:

- proveedor;
- idempotencia;
- reserva;
- consumo;
- resultado parcial;
- carreras entre cancelación y finalización.

Alternativas:

- no ofrecer cancelación una vez admitida la operación;
- permitir cancelación sólo antes de comenzar ejecución externa;
- intentar cancelación best-effort durante ejecución y aplicar política de cobro según resultado.

Se registra `AI-OPEN-003`.

Hasta su resolución no debe inventarse un botón o semántica de cancelación.

---

# 29. Deshabilitación de IA

`COMPANY_ADMIN` puede deshabilitar IA para su tenant.

Cuando IA está deshabilitada:

- no se admiten nuevas `AIUsageOperation` iniciadas por usuarios;
- Reporting manual continúa funcionando;
- el saldo permanece;
- el ledger permanece;
- operaciones históricas permanecen;
- textos ya aceptados en Reports permanecen;
- no se eliminan compras ni movimientos.

## 29.1 Operación ya en curso

La baseline no define si una operación ya reservada/ejecutándose debe:

- continuar hasta settlement;
- cancelarse antes de llamar al proveedor si todavía no comenzó;
- intentar detenerse durante ejecución.

La decisión se registra en `AI-OPEN-004`.

En cualquier alternativa, la deshabilitación no puede dejar una reserva huérfana ni un ledger inconsistente.

---

# 30. Rehabilitación de IA

Rehabilitar IA:

- permite nuevamente admitir operaciones futuras, sujeto a autorización y créditos;
- no modifica el saldo;
- no elimina ni recrea movimientos;
- no reactiva automáticamente operaciones fallidas/canceladas;
- no cambia resultados históricos;
- no altera Reports finalizados.

Debe ser una acción auditable.

---

# 31. Datos enviados al proveedor IA

Toda operación debe aplicar minimización de datos.

Sólo puede enviarse la información necesaria para la intención editorial autorizada.

El contexto puede incluir, según necesidad:

- contenido relevante del Report draft;
- mantenimientos seleccionados conforme a Reporting;
- respuestas pertinentes;
- datos relevantes de cliente/equipo;
- históricos pertinentes;
- contexto técnico necesario.

No se debe enviar:

- credenciales;
- secretos;
- API keys;
- datos de otros tenants;
- fotografías;
- archivos visuales de Evidence;
- información no relacionada;
- datos personales o industriales innecesarios;
- identificadores internos sin valor semántico para la tarea.

## 31.1 Menor conjunto suficiente

La frontera de contexto debe preferir un subconjunto suficiente antes que “enviar todo el Report/tenant por comodidad”.

El hecho de que `COMPANY_ADMIN` pueda leer cierta información no implica que toda esa información deba enviarse al proveedor.

---

# 32. Identificadores

Los identificadores internos deben excluirse del contexto IA cuando no aporten significado editorial.

No deben enviarse por comodidad:

- `maintenance_company_id`;
- UUID internos;
- claves de base de datos;
- IDs de ledger;
- IDs de usuario;
- paths internos de Storage.

Si un identificador funcional visible fuese necesario para redactar o distinguir elementos, debe evaluarse por necesidad real y no por facilidad técnica.

La identidad tenant para autorización se mantiene dentro del sistema propio y no necesita ser comunicada al modelo para que el aislamiento funcione.

---

# 33. Información industrial sensible

El contexto de mantenimiento puede contener información sensible para el negocio, incluyendo:

- ubicación;
- identificación o características de equipos;
- mediciones;
- descripciones de incidentes;
- nombres de clientes;
- observaciones operativas;
- históricos técnicos;
- detalles de fallas.

El sistema debe minimizar esta información según la tarea.

Este documento no inventa:

- base legal;
- consentimiento;
- transferencia internacional autorizada;
- DPA;
- retención obligatoria;
- clasificación jurídica.

`DO-T07` permanece **DIFERIDO**.

---

# 34. Evidence

El MVP no envía fotografías de Evidence a IA.

Queda fuera del MVP:

- visión;
- análisis de imagen;
- OCR automático;
- clasificación visual;
- extracción de texto desde fotografías;
- inferencia técnica basada en píxeles.

Datos textuales legítimamente existentes en el dominio y permitidos para Reporting pueden utilizarse si forman parte del contexto autorizado.

No debe transformarse metadata fotográfica en un análisis de imagen implícito.

La IA no reinterpreta ni resuelve `EVID-OPEN-*`.

---

# 35. Fuente factual

IA nunca es fuente de verdad técnica.

Toda afirmación que el producto presente como dato factual debe derivar de:

- mantenimiento;
- revisión;
- respuesta;
- equipo;
- cliente;
- formulario histórico;
- otra fuente de dominio aprobada.

La IA puede redactar una narrativa sobre esos hechos, pero no crear nuevos hechos que el sistema trate como registrados.

No debe convertirse texto generado en:

- medición;
- respuesta técnica;
- estado de equipo;
- Evidence;
- fecha de mantenimiento;
- selección de Report;
- número oficial.

---

# 36. Hallucinations

Toda salida IA debe tratarse como potencialmente incorrecta, incompleta o inventada.

El producto no debe asumir que una frase es cierta porque el proveedor la generó.

Mitigaciones conceptuales obligatorias:

- contexto acotado;
- separación entre hechos estructurados y narrativa;
- revisión humana;
- posibilidad de editar/rechazar;
- no auto-finalización;
- no escritura de datos técnicos desde la salida.

Las futuras pruebas deben incluir casos donde el texto contradiga, exagere o invente hechos.

---

# 37. Revisión humana

Todo `usage result` presentado como sugerencia editorial debe ser:

- visible;
- editable;
- rechazable;
- aceptable conscientemente.

No debe:

- insertarse silenciosamente como contenido oficial;
- finalizar un Report;
- aprobarse automáticamente por haber sido generado;
- bloquear el flujo manual si el usuario decide no utilizarlo.

La responsabilidad editorial final permanece bajo control humano de `COMPANY_ADMIN`.

---

# 38. Persistencia del resultado IA

El sistema necesita preservar suficiente información para:

- resolver retries;
- reentregar una respuesta perdida;
- distinguir operación completada de una nueva solicitud;
- conciliar créditos;
- investigar fallos;
- auditar el uso;
- mantener trazabilidad mínima de modelo/proveedor/configuración cuando cambien posteriormente.

Esto no implica almacenar indefinidamente:

- prompt completo;
- contexto completo;
- salida bruta completa.

La política de retención exacta permanece abierta en `AI-OPEN-005`.

## 38.1 Requisito mínimo funcional

Si una operación se completó y la respuesta al cliente se perdió, debe existir suficiente persistencia para evitar volver a ejecutar/cobrar por defecto.

Por tanto, “no almacenar nada de la operación una vez que el proveedor responde” es incompatible con la idempotencia y troubleshooting requeridos.

---

# 39. Prompt/input retention

La baseline exige métricas mínimas para conciliación sin almacenar innecesariamente prompts o respuestas completas.

Alternativas:

### Almacenar prompt completo

Ventajas:

- troubleshooting detallado;
- reproducibilidad aproximada.

Riesgos:

- mayor exposición de información industrial/personal;
- aumenta superficie de acceso y retención;
- puede duplicar datos del dominio.

### Almacenar sólo metadata y huella/context hash

Ventajas:

- minimiza contenido sensible;
- permite correlación técnica.

Riesgo:

- menor capacidad de reconstruir exactamente un incidente.

### Almacenar un subset sanitizado

Ventaja: equilibrio entre diagnóstico y minimización.

Riesgo: requiere definir qué se considera necesario y cómo se sanitiza.

### No almacenar input, conservar sólo resultado aceptado en Report

Ventaja: minimización máxima.

Riesgo: insuficiente para retries/diagnóstico si tampoco se conserva temporalmente estado de operación.

La decisión se registra en `AI-OPEN-005`.

No se aprueba una retención legal ni un plazo.

---

# 40. Resultado aceptado vs resultado bruto

Deben distinguirse tres conceptos:

## 40.1 Salida IA bruta

Contenido devuelto por la operación antes de revisión humana.

Puede ser incorrecto y no es oficial.

## 40.2 Texto editado/aceptado

Contenido que `COMPANY_ADMIN` ha revisado y decide incorporar, posiblemente después de modificarlo.

Ya no debe tratarse en UX como una “verdad del modelo”, sino como contenido editorial bajo control humano.

## 40.3 Contenido final de `ReportSnapshot`

El snapshot final debe congelar el contenido editorial finalmente aceptado.

No debe depender de:

- volver a ejecutar IA;
- conservar acceso al proveedor;
- reconstruir el prompt;
- consultar la salida bruta histórica.

Un Report finalizado sigue siendo interpretable aunque el modelo/proveedor cambie o deje de existir.

---

# 41. Modelo/proveedor

Este documento no selecciona:

- GPT concreto;
- versión concreta de modelo;
- endpoint;
- API;
- SDK;
- proveedor alternativo;
- streaming;
- tool calling.

La integración debe respetar una frontera conceptual en la que:

- el dominio crea una `AIUsageOperation` autorizada;
- una capa de integración recibe contexto minimizado;
- el proveedor devuelve un resultado o fallo;
- el dominio decide settlement de créditos conforme a `DO-T01`;
- las reglas de permisos, ledger e histórico no dependen de un nombre de modelo concreto.

La baseline puede utilizar OpenAI inicialmente sin convertir su API particular en el modelo de dominio.

---

# 42. Cambio futuro de modelo

Una operación histórica debe conservar metadata suficiente para comprender con qué configuración de proveedor/modelo se produjo el resultado cuando esa información sea necesaria para:

- troubleshooting;
- conciliación interna;
- auditoría técnica;
- análisis de cambios de calidad/costo.

No se define el nivel exacto de metadata.

Como mínimo conceptual, la arquitectura debe evitar que cambiar de modelo haga imposible distinguir operaciones históricas de operaciones nuevas.

La política de retención de esta metadata se coordina con `AI-OPEN-005`.

---

# 43. Tokens y costos monetarios del proveedor

Deben separarse dos magnitudes:

1. costo interno real de proveedor;
2. costo comercial en créditos cobrado al tenant.

No se asume:

- 1 crédito = 1 token;
- 1 crédito = 1 llamada;
- 1 crédito = ARS X;
- créditos idénticos al costo marginal del proveedor.

Los tokens u otra métrica externa pueden ser parte de observabilidad/conciliación interna cuando la integración lo permita, pero no se convierten por inferencia en la unidad comercial.

---

# 44. Margen comercial

La definición de margen, pricing y rentabilidad queda fuera del alcance de este documento.

Este subsistema sólo requiere que:

- exista una unidad de créditos;
- el costo funcional aplicado sea trazable;
- pueda distinguirse costo del proveedor de créditos cobrados al cliente.

No se fijan precios ni fórmulas de margen.

---

# 45. Compra de créditos

Una compra de créditos es un evento comercial tenant-owned separado de la operación IA.

Reglas conceptuales:

- pertenece inequívocamente a un tenant;
- puede iniciarse desde una experiencia autorizada de `COMPANY_ADMIN`;
- sólo incrementa créditos cuando existe confirmación comercial válida;
- no depende de un callback del navegador como prueba de pago;
- debe poder conciliarse con el proveedor de pagos;
- debe ser idempotente respecto del evento/confirmación comercial;
- no debe acreditar dos veces por el mismo pago.

Este documento no implementa Mercado Pago ni resuelve `DO-T02`.

## 45.1 Compra pendiente o fallida

Una compra iniciada pero no confirmada no debe incrementar la wallet por inferencia.

Una compra fallida no genera créditos comprados.

La UX y state machine concretas pertenecen al documento de pagos posterior.

---

# 46. Paquetes de créditos

La baseline establece que los créditos se compran separadamente mediante paquetes, pero no define:

- tamaños;
- precios;
- bonus;
- catálogo;
- versionado comercial;
- disponibilidad temporal;
- expiración.

Conceptualmente puede ser razonable que exista configuración global de paquetes para mantener una oferta comercial coherente y no duplicada por tenant.

Sin embargo, aprobar esa configuración y sus reglas pertenece a una decisión funcional/comercial pendiente.

Se trata en `AI-OPEN-006`.

No se inventan paquetes reales.

---

# 47. Expiración de créditos

La baseline no establece expiración.

Alternativas:

### Sin expiración

Ventajas:

- simple para el cliente;
- evita reglas de prioridad entre lotes;
- evita pérdida silenciosa de saldo;
- simplifica ledger.

Riesgo:

- la empresa mantiene una obligación comercial de servicio futura sobre créditos vendidos.

### Expiración por compra/lote

Ventaja comercial potencial: limita pasivos de largo plazo.

Riesgos:

- requiere tracking de lotes/origen;
- reglas FIFO/consumo;
- notificaciones;
- tratamiento de refunds;
- mayor complejidad y posibles disputas.

### Expiración sólo de promociones

Podría ser diferente de créditos comprados, pero promociones no están aprobadas.

La decisión se integra en `AI-OPEN-006`.

Hasta su resolución no debe existir expiración por defecto.

---

# 48. Créditos comprados vs promocionales/grants

Puede resultar útil distinguir el origen histórico de un incremento:

- purchased;
- grant/promotional, si se aprueba;
- administrative adjustment, si se aprueba;
- technical compensation.

La distinción tiene valor para:

- auditoría;
- conciliación comercial;
- refunds futuros;
- explicar el ledger;
- evitar tratar una compensación como una compra.

Sin embargo:

- no se aprueban promociones;
- no se aprueban grants automáticos;
- no se aprueban bonus del año promocional.

La política de grants se trata en `AI-OPEN-006` y la autoridad de ajustes excepcionales en `AI-OPEN-007`.

---

# 49. Ajustes administrativos

Puede existir una necesidad operacional futura de:

- corregir un error de acreditación;
- compensar un incidente de plataforma;
- otorgar créditos excepcionales;
- regularizar una inconsistencia validada.

La baseline **no otorga** esa capacidad a `SUPER_ADMIN` ni a otro actor global de forma automática.

Una capacidad de ajuste, si se aprueba, debe exigir conceptualmente:

- autoridad explícita;
- tenant inequívoco;
- motivo obligatorio;
- movimiento inmutable;
- auditoría;
- prohibición de editar ledger anterior;
- controles contra uso arbitrario.

Se registra `AI-OPEN-007`.

---

# 50. Reversión de compra

Debe distinguirse:

- compensación técnica de una `AIUsageOperation`;
- refund monetario o reversión comercial de una compra.

El segundo caso pertenece al bounded context Subscription & Payments y depende de:

- estado comercial;
- verificación de pago;
- policy de refund;
- state machine de `PaymentEvent`;
- tratamiento de créditos ya utilizados, si se define.

Este documento no resuelve `DO-T02` ni una política de refunds.

No se debe utilizar “compensación IA” como sustituto de una reversión comercial.

---

# 51. Suscripción

Créditos y suscripción son bounded contexts separados.

Reglas:

- un tenant puede tener suscripción válida y saldo IA igual a cero;
- saldo cero no elimina el acceso al SaaS, sólo impide nuevas operaciones IA bajo la política de insuficiencia;
- tener créditos no sustituye una suscripción válida;
- los créditos no constituyen entitlement general del SaaS;
- la suscripción no incluye créditos automáticamente;
- comprar créditos no reactiva por sí mismo una suscripción inactiva.

---

# 52. Año promocional

El primer año del SaaS a precio de suscripción $0 no implica:

- créditos IA gratuitos;
- paquete inicial de créditos;
- bonus;
- grant;
- uso ilimitado de IA.

Los créditos siguen comprándose por separado conforme a la baseline.

No se introduce una promoción de IA por inferencia.

---

# 53. Tenant suspendido comercialmente

La baseline establece que una suscripción inactiva provoca pérdida de acceso online para los usuarios del tenant.

Consecuencias conceptuales para IA/créditos:

- no pueden iniciarse nuevas operaciones IA de usuario mientras no exista acceso online válido;
- la wallet y el ledger no se eliminan;
- los créditos existentes no se convierten automáticamente en cero;
- el histórico permanece;
- reactivar la suscripción no debe recrear el saldo, sino continuar desde la historia existente;
- reconciliaciones técnicas necesarias para cerrar operaciones ya iniciadas pueden necesitar completarse en backend para preservar consistencia, sin interpretarse como nuevo acceso del usuario suspendido.

Este documento no decide:

- refunds por suspensión;
- vencimiento de créditos durante suspensión;
- compras permitidas estando suspendido;
- reglas comerciales adicionales.

Esas cuestiones dependen de la futura especificación de pagos/comercial y de `AI-OPEN-006` cuando corresponda.

---

# 54. Historial de ledger

El ledger debe permitir interpretar históricamente:

- qué ocurrió;
- cuándo ocurrió;
- qué tenant fue afectado;
- actor o fuente cuando aplique;
- motivo;
- efecto en créditos;
- `AIUsageOperation` relacionada cuando corresponda;
- compra relacionada cuando corresponda;
- reserva relacionada;
- consumo;
- liberación;
- compensación;
- relación entre movimientos que corrigen o neutralizan efectos anteriores;
- origen de un incremento si esa taxonomía se aprueba.

El historial no debe depender de reconstruir significado desde texto libre únicamente.

No se diseña UI ni estructura física.

---

# 55. Historial visible para `COMPANY_ADMIN`

La baseline establece que `COMPANY_ADMIN` administra créditos y puede consultar saldo. El nivel exacto de detalle del historial visible no está completamente definido.

Información potencialmente útil:

- fecha/hora;
- clase de movimiento;
- cantidad/efecto;
- Report u operación relacionada cuando aplique;
- motivo legible;
- estado conciliado;
- saldo resultante o posición derivada.

No todo dato interno debe exponerse, por ejemplo:

- secretos;
- payloads de proveedor;
- costos internos sensibles;
- metadata técnica sin utilidad para el administrador.

Se registra `AI-OPEN-008`.

---

# 56. Balance negativo

No se asume que el balance negativo esté permitido.

Su existencia depende directamente de `DM-OPEN-007`.

Bajo la recomendación de este documento:

- no existe sobregiro implícito;
- la admisión falla antes de ejecutar si no puede reservarse el costo;
- un balance negativo sólo podría aparecer como inconsistencia a reconciliar, no como comportamiento normal.

No se declara esta política aprobada hasta resolver `DM-OPEN-007`.

---

# 57. Atomicidad conceptual

El diseño futuro debe evitar estados imposibles o no conciliables como:

- IA ejecutada exitosamente sin efecto de créditos determinable;
- créditos consumidos sin `AIUsageOperation` válida;
- dos consumos por la misma identidad idempotente;
- reserva creada sin operación atribuible;
- consumo de Tenant A asociado a Report de Tenant B;
- compra acreditada dos veces;
- balance actualizado sin movimiento histórico;
- operación fallida con reserva abandonada para siempre.

## 57.1 Fronteras mínimas

Sin definir transacciones SQL, deben existir fronteras conceptuales donde ciertas decisiones se comporten como una única admisión coherente:

- autorización + tenant efectivo;
- costo aplicado + reserva suficiente;
- identidad idempotente + no duplicación;
- settlement + ledger conciliable.

---

# 58. Reconciliación

El subsistema debe poder detectar y tratar inconsistencias entre:

- operación IA;
- estado de ejecución;
- reserva;
- consumo;
- liberación;
- compensación;
- balance derivado;
- compra confirmada;
- ledger.

La reconciliación puede requerir procesos automáticos o manuales futuros, pero este documento no selecciona cron/job/queue.

## 58.1 Casos a detectar

- operación `completed` sin consumo ni settlement explicable;
- operación `failed` con reserva todavía vigente;
- ledger entry sin fuente válida;
- compra confirmada sin acreditación;
- acreditación sin confirmación comercial válida;
- duplicado de movimiento;
- balance materializado divergente del ledger;
- resultado ambiguo del proveedor pendiente por demasiado tiempo según la futura política técnica.

---

# 59. Reservas huérfanas

Una reserva huérfana es una reserva sin settlement final coherente.

Puede originarse por:

- crash del servidor;
- timeout;
- pérdida de respuesta;
- fallo de persistencia posterior;
- despliegue/reinicio;
- error de integración;
- estado ambiguo del proveedor.

Debe ser:

- detectable;
- atribuible a una operación;
- revisable/reconciliable;
- liberable o consumible únicamente según evidencia suficiente del estado real.

No debe corregirse borrando historia.

Se registra riesgo específico en `AI-RSK-003`.

---

# 60. Ledger entries huérfanas

No debe existir un movimiento sin motivo y fuente válidos.

Todo movimiento debe poder atribuirse conceptualmente a una de las causas aprobadas:

- operación IA;
- compra confirmada;
- liberación/compensación;
- grant futuro aprobado;
- ajuste futuro autorizado;
- reversión comercial futura definida.

Un movimiento sin operación/compra/motivo autorizable constituye una inconsistencia de integridad y debe ser investigable.

---

# 61. Auditoría

Deben considerarse acciones sensibles y auditables, sin diseñar `AuditEvent`:

- habilitar IA;
- deshabilitar IA;
- iniciar una operación IA;
- resultado/settlement de una operación cuando sea necesario para trazabilidad;
- compra de créditos;
- acreditación de compra confirmada;
- compensación excepcional;
- grant, si se aprueba;
- ajuste administrativo, si se aprueba;
- acceso excepcional de soporte a créditos IA;
- cualquier uso futuro de capacidad global excepcional.

La auditoría debe permitir identificar al menos conceptualmente:

- actor o fuente;
- tenant;
- acción;
- momento;
- recurso/alcance afectado;
- motivo cuando corresponda.

El ledger no sustituye la auditoría y la auditoría no sustituye el ledger.

---

# 62. Seguridad

Principios obligatorios:

- aislamiento tenant;
- RLS obligatorio para datos tenant en el diseño físico futuro;
- IA server-side only;
- secretos nunca en frontend;
- `service-role` no es bypass normal;
- autorización antes de reservar/consumir/ejecutar;
- no confiar en `tenant_id` del navegador;
- derivar tenant desde identidad/ownership autoritativo;
- wallet/ledger cross-tenant imposible;
- operación y movimientos asociados del mismo tenant;
- no modificar ledger histórico desde UI;
- no confiar en saldo enviado por frontend;
- no permitir al cliente fijar costo aplicado;
- no permitir al cliente declarar que una compra está pagada;
- no permitir al cliente marcar una operación como consumida/compensada.

## 62.1 Frontera del proveedor

El proveedor IA es externo y no participa en autorización.

No debe recibir:

- secretos internos;
- contexto cross-tenant;
- autoridad para modificar datos;
- acceso directo a PostgreSQL/Storage por necesidad de generar texto.

---

# 63. Rate limiting

Deben distinguirse:

- créditos disponibles: control comercial de capacidad IA;
- rate limiting técnico: protección contra abuso, saturación o límites del proveedor;
- límites comerciales: reglas de producto, que no deben inventarse.

La baseline establece que no existen límites IA por usuario en el MVP.

Por tanto:

- un rate limit técnico no debe presentarse como “cuota mensual por usuario”;
- no debe descontar créditos por sí mismo si la operación no se ejecutó conforme a la política;
- no debe crear un entitlement comercial nuevo.

La estrategia técnica concreta de rate limiting puede requerir ADR/diseño posterior.

---

# 64. Abuse prevention

El diseño futuro debe considerar:

- doble click;
- automatización accidental;
- múltiples tabs;
- retries repetidos;
- requests deliberadamente duplicados;
- payload desproporcionado;
- actor no autorizado;
- intento de cambiar tenant;
- intento de manipular costo;
- intento de consumir sin saldo;
- intento de llamar proveedor directamente;
- reuso malicioso de una identidad idempotente para otra intención.

Mitigaciones conceptuales:

- autorización server-side;
- idempotencia;
- validación de contexto;
- minimización;
- límites técnicos razonables a definir sin convertirlos en cuotas de producto;
- observabilidad;
- auditoría.

No se fijan números.

---

# 65. Observabilidad

Debe poder investigarse conceptualmente:

- latencia total;
- latencia de proveedor;
- tipo de operación;
- fallos por clase;
- provider errors;
- rate limits;
- reserva;
- consumo;
- liberación;
- compensación;
- retries;
- duplicados detectados;
- operaciones ambiguas;
- reconciliaciones;
- costo interno cuando la integración lo permita;
- costo funcional en créditos;
- versión/configuración de proveedor/modelo necesaria para diagnóstico.

No se fija herramienta de logs, tracing, métricas ni alertas.

La observabilidad debe respetar minimización y no convertirse en almacenamiento accidental de prompts o datos sensibles.

---

# 66. Privacidad y legal

`DO-T07` permanece **DIFERIDO**.

Este documento no aprueba:

- períodos de retención;
- transferencia internacional de datos;
- DPA;
- consentimiento;
- base legal;
- clasificación legal de información industrial;
- requisitos contractuales específicos del proveedor.

Antes de piloto/producción deben validarse los requisitos legales/contractuales aplicables a:

- datos de clientes;
- información industrial;
- proveedores IA;
- retención;
- logs;
- soporte;
- eventuales transferencias.

La implementación de Fase 7 no debe ignorar esa validación para producción.

---

# 67. Testing futuro obligatorio

La futura implementación debe incluir, como mínimo, categorías de pruebas para:

## Autorización y aislamiento

- `COMPANY_ADMIN` autorizado puede iniciar IA;
- `TECHNICIAN` es rechazado;
- `SUPER_ADMIN` normal es rechazado;
- `SUPER_ADMIN` con grant no obtiene uso IA por inferencia;
- tenant isolation de operaciones;
- intento cross-tenant sobre wallet/ledger;
- `tenant_id` manipulado desde frontend no cambia ownership;
- IA disabled rechaza nuevas operaciones.

## Reporting

- Report puede completarse sin IA;
- IA no modifica datos técnicos;
- IA no decide candidatos;
- IA no finaliza;
- nueva operación IA durante regeneración consume nuevamente conforme a política;
- retry técnico durante regeneración no duplica cargo.

## Créditos y ledger

- saldo suficiente;
- créditos insuficientes según `DM-OPEN-007` una vez resuelta;
- reserva;
- consumo;
- liberación;
- compensación;
- ledger inmutable;
- balance derivable;
- balance materializado reconciliable si existiera;
- no balance negativo accidental;
- movimientos tenant-consistentes.

## Idempotencia

- doble click;
- duplicate request;
- mismo idempotency intent;
- retry después de timeout;
- respuesta perdida al cliente;
- reentrega de resultado persistido;
- nueva operación deliberada produce nueva identidad/cargo;
- no doble consumo.

## Concurrencia

- dos operaciones compitiendo por saldo insuficiente;
- una sola puede reservar cuando corresponda;
- no sobreventa de créditos;
- no carrera entre reserve/release/consume.

## Fallos

- fallo antes de proveedor;
- provider timeout;
- error de proveedor;
- malformed response;
- respuesta parcial según `AI-OPEN-002` una vez resuelta;
- estado de ejecución ambiguo;
- reserva huérfana reconciliada;
- operación completada sin settlement detectada;
- ledger entry huérfana detectada.

## Compras

- compra confirmada conceptualmente acredita una sola vez;
- compra no confirmada no acredita;
- compra fallida no acredita;
- evento duplicado no duplica créditos;
- suscripción y créditos independientes;
- año promocional no regala créditos.

## Privacidad

- minimización de contexto;
- no envío cross-tenant;
- no fotografías;
- no OCR;
- no secretos;
- IDs internos omitidos cuando no son necesarios;
- logs no capturan contenido sensible innecesario.

## Revisión humana

- resultado visible;
- editable;
- rechazable;
- aceptación consciente;
- no auto-finalización.

No se escriben tests en este documento.

---

# 68. Anti-patrones prohibidos

Quedan expresamente prohibidos:

- llamar OpenAI/proveedor IA directamente desde navegador;
- exponer API keys o secretos;
- usar `service-role` como bypass normal;
- confiar en `tenant_id` enviado por frontend;
- confiar en saldo enviado por frontend;
- wallet mutable sin ledger;
- editar un movimiento histórico;
- borrar una compensación previa para “arreglar” saldo;
- consumir dos veces por retry;
- usar el click del frontend como prueba de consumo;
- cobrar/reservar antes de autenticar y autorizar;
- ejecutar con saldo insuficiente por carrera silenciosa;
- permitir saldo negativo por accidente;
- confundir refund monetario con compensación técnica;
- crear una nueva `AIUsageOperation` para cada retry;
- reintentar ciegamente al proveedor cuando el resultado de una ejecución previa es ambiguo;
- hacer IA obligatoria para crear/finalizar Report;
- permitir IA a `TECHNICIAN`;
- permitir uso IA a `SUPER_ADMIN` por inferencia;
- permitir que un scope de soporte cree permisos operativos nuevos;
- IA que modifica datos técnicos;
- IA que modifica Evidence;
- IA que decide candidatos de Reporting;
- IA que asigna número oficial;
- IA que finaliza;
- IA sobre fotografías;
- OCR automático;
- enviar datos cross-tenant;
- enviar datos innecesarios al proveedor;
- enviar IDs internos por comodidad;
- asumir que la salida IA es correcta;
- convertir salida IA en hecho técnico;
- guardar sólo balance sin historia;
- eliminar ledger para corregir saldo;
- usar créditos como sustituto de suscripción;
- asumir que el año promocional incluye créditos;
- inventar expiración;
- inventar promociones;
- inventar precios;
- inventar paquetes;
- asumir equivalencia crédito/token;
- acreditar compra por callback frontend;
- resolver silenciosamente `DM-OPEN-*`, `DO-*`, `RPT-OPEN-*`, `FORM-OPEN-*`, `EVID-OPEN-*`, `OFF-OPEN-*` o `AI-OPEN-*`.

---

# 69. Riesgos

## `AI-RSK-001` — Doble consumo por retry

**Riesgo:** un timeout o doble click crea dos operaciones/cargos.

**Tratamiento:** identidad idempotente estable y settlement asociado a la misma operación.

## `AI-RSK-002` — Saldo incorrecto por concurrencia

**Riesgo:** dos operaciones reservan el mismo saldo disponible.

**Tratamiento:** admisión/reserva conceptualmente atómica; diseño físico posterior.

## `AI-RSK-003` — Reserva huérfana

**Riesgo:** créditos quedan bloqueados después de crash/fallo.

**Tratamiento:** lifecycle reconciliable y detección de reservas sin settlement.

## `AI-RSK-004` — Operación completada sin ledger conciliado

**Riesgo:** IA se ejecuta pero no existe efecto de créditos explicable.

**Tratamiento:** fronteras de settlement y reconciliación.

## `AI-RSK-005` — Ledger sin operación/fuente válida

**Riesgo:** movimiento no atribuible a una causa autorizada.

**Tratamiento:** invariantes de ownership/source y auditoría.

## `AI-RSK-006` — Créditos insuficientes mal tratados

**Riesgo:** se ejecuta proveedor sin capacidad de consumo.

**Tratamiento:** resolver `DM-OPEN-007`; recomendación de rechazo pre-ejecución.

## `AI-RSK-007` — Balance negativo accidental

**Riesgo:** carrera o bug produce deuda no aprobada.

**Tratamiento:** reserva suficiente, invariantes y reconciliación.

## `AI-RSK-008` — Doble ejecución del proveedor

**Riesgo:** timeout ambiguo provoca reenvío y dos ejecuciones externas.

**Tratamiento:** idempotencia interna, persistencia de estado y política específica según garantías del proveedor futuro.

## `AI-RSK-009` — Respuesta perdida

**Riesgo:** operación válida se repite porque el navegador no recibió resultado.

**Tratamiento:** persistir resultado/estado suficiente y reentregar por misma identidad.

## `AI-RSK-010` — Provider timeout

**Riesgo:** no se sabe si el proveedor ejecutó.

**Tratamiento:** estado ambiguo/reconciliable; no asumir fallo seguro.

## `AI-RSK-011` — Salida inválida o parcial

**Riesgo:** se cobra por contenido no utilizable o se presenta contenido corrupto.

**Tratamiento:** resolver `AI-OPEN-002`; validación mínima de resultado.

## `AI-RSK-012` — Hallucination

**Riesgo:** salida inventa hechos.

**Tratamiento:** IA editorial, contexto acotado, revisión humana y separación factual.

## `AI-RSK-013` — Texto IA presentado como hecho

**Riesgo:** una sugerencia se confunde con dato técnico.

**Tratamiento:** fronteras UI/dominio, snapshot con editorial aceptada, no escritura técnica.

## `AI-RSK-014` — Exposición de secretos

**Riesgo:** API key o credencial llega a frontend/log.

**Tratamiento:** server-side only, secret management futuro y sanitización de observabilidad.

## `AI-RSK-015` — Envío cross-tenant

**Riesgo:** contexto de otro tenant se incluye en una operación.

**Tratamiento:** ownership autoritativo, RLS y construcción server-side del contexto.

## `AI-RSK-016` — Exceso de datos sensibles

**Riesgo:** se envía más información industrial/personal de la necesaria.

**Tratamiento:** data minimization boundary y revisión legal `DO-T07`.

## `AI-RSK-017` — Almacenamiento excesivo de prompts

**Riesgo:** se duplican datos sensibles innecesariamente.

**Tratamiento:** resolver `AI-OPEN-005`; minimización por defecto.

## `AI-RSK-018` — Falta de trazabilidad de modelo

**Riesgo:** no puede investigarse una operación histórica tras cambiar configuración.

**Tratamiento:** metadata mínima de proveedor/modelo/configuración.

## `AI-RSK-019` — Compra acreditada sin pago confirmado

**Riesgo:** créditos se crean desde estado de frontend o evento no verificado.

**Tratamiento:** sólo confirmación comercial válida; `DO-T02` posterior.

## `AI-RSK-020` — Pago confirmado sin crédito

**Riesgo:** cliente paga pero wallet no se actualiza.

**Tratamiento:** idempotencia y reconciliación PaymentEvent → ledger a definir en Fase 8.

## `AI-RSK-021` — Refund confundido con compensación

**Riesgo:** se corrige dinero mediante un movimiento técnico incorrecto o viceversa.

**Tratamiento:** bounded contexts separados.

## `AI-RSK-022` — IA deshabilitada pero operación nueva iniciada

**Riesgo:** carrera/estado obsoleto permite uso después de deshabilitar.

**Tratamiento:** comprobación autoritativa server-side antes de admisión; resolver in-flight en `AI-OPEN-004`.

## `AI-RSK-023` — Saldo mutable sin historia

**Riesgo:** inconsistencias no auditables.

**Tratamiento:** ledger inmutable como fuente histórica.

## `AI-RSK-024` — Costo cambia durante una operación

**Riesgo:** una configuración global nueva altera retroactivamente lo que debe cobrarse.

**Tratamiento:** preservar costo aplicable al admitir la operación.

## `AI-RSK-025` — Observabilidad filtra contenido sensible

**Riesgo:** prompts/respuestas aparecen en logs o traces.

**Tratamiento:** logging minimizado, redacción y política `AI-OPEN-005`.

## `AI-RSK-026` — Ajuste administrativo abusivo

**Riesgo:** una futura capacidad global permite fabricar/eliminar créditos sin controles.

**Tratamiento:** no aprobar por inferencia; `AI-OPEN-007`, auditoría y motivo obligatorio si se aprueba.

---

# 70. ADR candidates

Los siguientes son candidatos a ADR. **No se genera ningún ADR en este documento.**

## `AI-ADR-CAND-001` — Lifecycle de `AIUsageOperation`

Separación entre estado de ejecución, resultado y settlement de créditos.

## `AI-ADR-CAND-002` — Ledger inmutable de créditos IA

Representación física de movimientos, invariantes y reconciliación.

## `AI-ADR-CAND-003` — Reserva / consumo / liberación / compensación

Implementación física posterior de `DO-T01` una vez aprobado.

## `AI-ADR-CAND-004` — Cálculo y lectura de balance

Ledger directo vs proyección/materialización y estrategia de reconciliación.

## `AI-ADR-CAND-005` — Idempotencia de operaciones IA

Identidad lógica, retries, duplicate requests y reentrega.

## `AI-ADR-CAND-006` — Concurrencia sobre créditos

Frontera transaccional/serialización para evitar sobreconsumo.

## `AI-ADR-CAND-007` — Provider abstraction

Frontera entre dominio y proveedor/modelo/API concreta.

## `AI-ADR-CAND-008` — Data minimization boundary

Construcción de contexto, sanitización y exclusión de IDs/datos innecesarios.

## `AI-ADR-CAND-009` — Prompt/output retention

Política técnica derivada de `AI-OPEN-005` y `DO-T07`.

## `AI-ADR-CAND-010` — Reconciliación IA/ledger

Detección y reparación controlada de operaciones/reservas inconsistentes.

## `AI-ADR-CAND-011` — Integración futura con `PaymentEvent`

Acreditación de compra confirmada sin acoplar ledger a Mercado Pago.

## `AI-ADR-CAND-012` — Configuración de costos en créditos

Versionado de políticas/costos y preservación del costo aplicado.

No se aprueba arquitectura física mediante esta lista.

---

# 71. Nuevas decisiones abiertas `AI-OPEN-*`

Se crean únicamente decisiones funcionales necesarias para cerrar el contrato antes de Fase 7/Fase 8.

## `AI-OPEN-001` — Política de costo y visibilidad previa

**Motivo:** la baseline permite costos distintos, pero no define si son fijos/configurables/variables ni qué información ve el administrador antes de ejecutar.

**Alternativas:**

1. costo fijo por tipo;
2. costo configurable por tipo;
3. costo variable por uso real/tokens;
4. modelo combinado;
5. mostrar costo exacto, máximo o estimado.

**Evaluación:** para un sistema prepago con reserva previa, conocer el costo exacto antes de ejecutar simplifica autorización, UX, concurrencia e insuficiencia. Hacerlo variable por tokens acopla créditos a proveedor y dificulta reserva.

**Recomendación — PROPUESTA PENDIENTE DE APROBACIÓN:** utilizar en el MVP **costo configurable por tipo de operación con valor exacto conocido antes de admitir la operación**, preservando el costo aplicado en la `AIUsageOperation`. Mostrar a `COMPANY_ADMIN` al menos costo exacto y saldo disponible; la UI puede mostrar también el saldo esperado posterior sin convertirlo en autoridad. No atar créditos a tokens.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 7.

---

## `AI-OPEN-002` — Tratamiento de respuesta parcial o inválida

**Motivo:** no está definido si una ejecución que incurrió en costo de proveedor pero no produce resultado utilizable consume créditos del cliente.

**Alternativas:**

1. consumir siempre si el proveedor ejecutó;
2. no consumir si el producto no puede presentar un resultado válido/utilizable;
3. consumo parcial/proporcional.

**Evaluación:** cobrar por resultados no utilizables genera una UX difícil de justificar; consumo proporcional añade complejidad y no existe unidad comercial aprobada para prorratearlo.

**Recomendación — PROPUESTA PENDIENTE DE APROBACIÓN:** en el MVP, confirmar consumo sólo cuando exista un `usage result` funcionalmente válido que pueda presentarse para revisión. Si la respuesta es inválida/incompleta de forma que el producto no puede ofrecerla como resultado utilizable, liberar o compensar créditos según la etapa alcanzada. La plataforma absorbe el eventual costo interno del proveedor en esos fallos.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 7.

---

## `AI-OPEN-003` — Cancelación de una operación IA en curso

**Motivo:** cancelar después de reservar o llamar al proveedor introduce carreras y reglas de settlement no definidas.

**Alternativas:**

1. no permitir cancelación una vez admitida;
2. permitir sólo antes de ejecución externa;
3. cancelación best-effort durante ejecución.

**Evaluación:** para el MVP, una cancelación durante ejecución añade complejidad desproporcionada y puede no detener costo del proveedor. El usuario ya puede rechazar el resultado editorial.

**Recomendación — PROPUESTA PENDIENTE DE APROBACIÓN:** no ofrecer cancelación funcional de usuario una vez que la operación ha sido admitida/reservada para ejecución en el MVP. Antes de la admisión no existe operación a cancelar. El usuario conserva la capacidad de ignorar/rechazar el resultado. Fallos técnicos previos a ejecución liberan reserva conforme a `DO-T01`.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 7.

---

## `AI-OPEN-004` — Operación en curso cuando IA se deshabilita

**Motivo:** la baseline sólo define que no deben existir nuevas operaciones con IA deshabilitada, no el efecto sobre una ya admitida.

**Alternativas:**

1. dejar finalizar toda operación ya admitida;
2. cancelar si aún no comenzó proveedor y dejar finalizar las que ya ejecutan;
3. intentar cancelar incluso durante proveedor.

**Evaluación:** deshabilitar IA debe ser efectivo para nuevas intenciones sin crear inconsistencias económicas. Intentar detener una ejecución externa ya iniciada puede ser imposible o ambiguo.

**Recomendación — PROPUESTA PENDIENTE DE APROBACIÓN:** el cambio a disabled bloquea inmediatamente **nuevas admisiones**. Una operación ya admitida/reservada continúa hasta un settlement coherente; si el sistema conoce de forma segura que aún no comenzó ejecución externa y puede abortarla sin ambigüedad, puede liberarse conforme al protocolo técnico aprobado. No se interrumpe una ejecución ya enviada al proveedor por simple cambio de flag.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 7.

---

## `AI-OPEN-005` — Retención de input/prompt, salida bruta y metadata de operación

**Motivo:** idempotencia y troubleshooting requieren persistencia, pero la baseline exige no guardar prompts/respuestas completas innecesariamente.

**Alternativas:**

1. guardar prompt y output completos;
2. guardar sólo metadata/hash;
3. guardar subset sanitizado;
4. guardar resultado bruto sólo durante su lifecycle de revisión y luego minimizar;
5. conservar únicamente texto aceptado en ReportSnapshot a largo plazo.

**Evaluación:** almacenar todo aumenta exposición; almacenar nada impide reentrega de respuesta perdida y troubleshooting. Debe diferenciarse retención operacional mínima de retención histórica/legal.

**Recomendación — PROPUESTA PENDIENTE DE APROBACIÓN:** no persistir prompt completo por defecto. Persistir metadata operacional mínima, referencias/huellas de contexto cuando sean útiles, costo aplicado y trazabilidad de proveedor/modelo. Conservar el resultado generado lo suficiente para resolver idempotencia, respuesta perdida y revisión humana; una vez resuelto su lifecycle, minimizarlo conforme a una política de retención que debe coordinarse con `DO-T07`. El `ReportSnapshot` conserva únicamente el contenido editorial final aceptado, no depende del output bruto.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 7 para retención operacional; validación legal antes de piloto/producción conforme a `DO-T07`.

---

## `AI-OPEN-006` — Paquetes, expiración y origen comercial de créditos

**Motivo:** la baseline exige compra por paquetes, pero no define catálogo, tamaños, precios, bonus, expiración ni grants/promociones.

**Alternativas:**

1. paquetes globales configurables sin expiración;
2. paquetes tenant-specific;
3. expiración por lote;
4. créditos comprados sin expiración y promociones con reglas separadas;
5. grants/promociones habilitados o inexistentes.

**Evaluación:** tenant-specific añade complejidad comercial no requerida. Expiración por lote complica ledger y UX. La baseline no aprueba promociones ni expiración.

**Recomendación — PROPUESTA PENDIENTE DE APROBACIÓN:** definir en Fase 8 un catálogo comercial global/versionable de paquetes, sin asumir valores. Mantener como propuesta que **créditos comprados no expiren en el MVP salvo decisión comercial expresa posterior**. No crear promociones/grants por defecto; si en el futuro se aprueban, deben distinguirse históricamente de compras y compensaciones.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 8 para catálogo/expiración comercial; cualquier grant necesario para Fase 7 debe aprobarse antes de implementarlo.

---

## `AI-OPEN-007` — Grants y ajustes administrativos excepcionales

**Motivo:** pueden ser necesarios para incidentes/correcciones, pero la baseline no otorga esa autoridad a `SUPER_ADMIN` ni define actor global autorizado.

**Alternativas:**

1. no permitir ajustes manuales;
2. permitir grants/ajustes a `SUPER_ADMIN`;
3. crear una capacidad global específica separada del rol ordinario;
4. limitarse a compensaciones automáticas ligadas a operaciones.

**Evaluación:** otorgarlo automáticamente a `SUPER_ADMIN` violaría la regla de no inferir permisos. Prohibir toda corrección puede dificultar incidentes reales.

**Recomendación — PROPUESTA PENDIENTE DE APROBACIÓN:** no conceder ajustes por rol `SUPER_ADMIN` de forma implícita. Si el piloto/operación necesita esta capacidad, aprobar una **capacidad excepcional explícita de plataforma**, fuertemente auditada, tenant-scoped, con motivo obligatorio y sólo mediante nuevos movimientos inmutables. Distinguir grant comercial de compensación técnica.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 7 si se requiere capacidad de ajuste para operación; de lo contrario antes del piloto.

---

## `AI-OPEN-008` — Nivel de detalle del historial visible a `COMPANY_ADMIN`

**Motivo:** el administrador necesita comprender saldo/movimientos, pero no se ha definido exactamente qué metadata se expone.

**Alternativas:**

1. sólo saldo y movimientos agregados;
2. detalle por movimiento con fecha, tipo, cantidad, Report/operación y motivo;
3. incluir además metadata técnica/proveedor y costos internos.

**Evaluación:** muy poco detalle dificulta soporte y confianza; exponer metadata técnica/costos internos no aporta necesariamente valor y puede revelar información sensible.

**Recomendación — PROPUESTA PENDIENTE DE APROBACIÓN:** mostrar a `COMPANY_ADMIN` un historial funcional con fecha, clase de movimiento, efecto en créditos, Report/operación relacionada cuando aplique, motivo legible y posición resultante/derivable. No exponer secretos, payloads, prompts ni costos internos del proveedor por defecto.

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 7 para experiencia de wallet/ledger.

---

# 72. Tratamiento formal de `DM-OPEN-007`

## 72.1 Pregunta

¿Qué ocurre cuando un `COMPANY_ADMIN` solicita una operación IA y el tenant no dispone de créditos suficientes?

## 72.2 Alternativas consideradas

1. rechazo antes de ejecutar;
2. sobregiro;
3. consumir hasta cero y cobrar después;
4. deuda explícita;
5. rechazo + flujo de compra.

## 72.3 Tradeoffs

El sobregiro/deuda mejora continuidad inmediata, pero introduce reglas comerciales nuevas, saldo negativo, cobranza y reconciliación más compleja.

Reservar sólo parte del costo deja una deuda implícita y rompe la garantía de admisión.

Rechazar antes de ejecutar mantiene:

- contabilidad predecible;
- no deuda;
- no balance negativo normal;
- separación entre IA y pagos;
- menor riesgo de llamar al proveedor sin capacidad de cobro en créditos.

## 72.4 Recomendación

**PROPUESTA PENDIENTE DE APROBACIÓN:**

- exigir créditos disponibles/reservables suficientes antes de ejecución;
- rechazar la operación si no alcanzan;
- no permitir deuda ni sobregiro implícito;
- ofrecer el futuro flujo de compra de créditos;
- ninguna llamada al proveedor debe comenzar si no se aseguró la capacidad de consumo conforme al protocolo aprobado;
- la comprobación es server-side/autoritativa y no sólo UI.

## 72.5 Estado formal

**`DM-OPEN-007 = ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.**

No se aprueba en este documento.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 7.

---

# 73. Tratamiento formal de `DO-T01`

## 73.1 Pregunta

¿Cuál es el protocolo conceptual que garantiza que una operación IA, su costo y su ledger permanezcan idempotentes, concurrentemente seguros y reconciliables frente a fallos?

## 73.2 Propuesta

**PROPUESTA PENDIENTE DE APROBACIÓN:**

**reserva idempotente → ejecución → confirmación de consumo / liberación o compensación**.

Secuencia ampliada:

1. autenticar y autorizar;
2. derivar tenant real;
3. comprobar estado comercial e IA enabled;
4. resolver la identidad idempotente;
5. determinar y congelar costo;
6. reservar capacidad suficiente de forma conceptualmente atómica;
7. ejecutar proveedor;
8. persistir estado/resultado suficiente;
9. confirmar consumo si existe resultado facturable válido;
10. liberar si la ejecución no corresponde a consumo y aún sólo había reserva;
11. compensar mediante movimiento posterior si un consumo ya asentado debe neutralizarse;
12. reentregar resultado en retries sin nuevo cargo;
13. reconciliar reservas/operaciones ambiguas.

## 73.3 Retries

- misma intención = misma operación;
- no crear nueva reserva/cargo;
- devolver estado/resultado existente;
- retry del proveedor sólo conforme a garantías de integración futura;
- timeout ambiguo no autoriza doble ejecución ciega.

## 73.4 Pérdida de respuesta

- resultado persistido antes de depender del cliente;
- consumo no depende de recepción del navegador;
- retry recupera la misma operación.

## 73.5 Concurrencia

La reserva debe impedir sobreasignar créditos disponibles.

El diseño físico posterior debe elegir una técnica de atomicidad/serialización; este documento no la fija.

## 73.6 Reserva huérfana

Toda reserva sin settlement debe ser detectable y reconciliable.

No puede quedar bloqueada para siempre.

## 73.7 Inmutabilidad

- reserva, consumo, liberación y compensación dejan historia;
- ningún movimiento previo se edita;
- la compensación es posterior;
- el balance deriva de esa historia.

## 73.8 Estado formal

**`DO-T01 = PROPUESTA PENDIENTE DE APROBACIÓN`.**

No se marca `RESUELTA/APROBADA`.

**Bloquea Fase 1:** no.

**Resolver antes de:** Fase 7.

---

# 74. Decisiones previas preservadas

Este documento no reevalúa decisiones ajenas a IA/créditos. Se preservan sus estados normativos vigentes.

## 74.1 `DM-OPEN-001..008`

- `DM-OPEN-001` — obligatoriedad de `EquipmentType`: **ABIERTA**.
- `DM-OPEN-002` — cardinalidad de formularios aplicables: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-003` — equipo sin formulario aplicable: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-004` — borradores simultáneos de formulario: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-005` — unicidad de Report por cliente/período: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-006` — configuración de template en regeneraciones: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.
- `DM-OPEN-007` — créditos IA insuficientes: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN** por la propuesta formulada en este documento; **NO aprobada**.
- `DM-OPEN-008` — criterio temporal de inclusión: **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**.

`DM-OPEN-005`, `DM-OPEN-006` y `DM-OPEN-008` no se modifican ni resuelven aquí.

## 74.2 `FORM-OPEN-001..008`

Permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**:

- `FORM-OPEN-001` — tratamiento de respuesta al ocultarse un campo;
- `FORM-OPEN-002` — modelo operativo de tabla/matriz;
- `FORM-OPEN-003` — cardinalidad del campo `image`;
- `FORM-OPEN-004` — inicio offline con versión publicada desactualizada;
- `FORM-OPEN-005` — tipos permitidos como fuente de igualdad;
- `FORM-OPEN-006` — nesting y semántica de contenedores compuestos;
- `FORM-OPEN-007` — semántica de required para checkbox;
- `FORM-OPEN-008` — multiplicidad de condiciones por campo destino.

No se reevalúan.

## 74.3 `EVID-OPEN-001..006`

Permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**:

- `EVID-OPEN-001` — cardinalidad de una categoría required;
- `EVID-OPEN-002` — multiplicidad de Evidence por categoría;
- `EVID-OPEN-003` — eliminación durante captura no finalizada;
- `EVID-OPEN-004` — cadena de replacements y vigencia visual;
- `EVID-OPEN-005` — categoría en visual replacement;
- `EVID-OPEN-006` — continuidad de Evidence entre `MaintenanceRevision`.

No se reevalúan.

## 74.4 `RPT-OPEN-001..012`

Todas permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**:

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

No se resuelve período, selección de revisión, staleness, inclusión/exclusión, re-emisión, finalización, numeración, Evidence, Reporting online, conflictos, regeneración ni descarte.

## 74.5 Decisiones `DO-*`

- `DO-073` — alcance de notificaciones push: **DIFERIDA**; resolver antes de Fase 9.
- `DO-074` — métricas del dashboard: **DIFERIDA**; resolver antes de Fase 10.
- `DO-076` — gracia al finalizar el primer año $0: **propuesta no aprobada / requiere aprobación antes de Fase 8**; no se modifica.
- `DO-077` — subconjunto DOCX portable: **PENDIENTE DE APROBACIÓN**; resolver antes de Fase 6.
- `DO-078` — renovación/cancelación/prorrateo: **pendiente de definición antes de Fase 8**; no se modifica.
- `DO-T01` — protocolo del ledger IA: **PROPUESTA PENDIENTE DE APROBACIÓN**; este documento la profundiza sin aprobarla.
- `DO-T02` — state machine de Mercado Pago: **PROPUESTO**; resolver antes de Fase 8; no se modifica.
- `DO-T03` — invalidación efectiva de sesiones: **PARCIALMENTE ABIERTO**; no se modifica.
- `DO-T04` — protección local: **PROPUESTA PENDIENTE DE APROBACIÓN**; no se modifica.
- `DO-T05` — escala y rendimiento objetivo: **DIFERIDO**.
- `DO-T06` — backup, RPO/RTO y restauración: **DIFERIDO**.
- `DO-T07` — privacidad/legal aplicable: **DIFERIDO**.
- `DO-075` — autorización offline máxima de 7 días y revalidación: **RESUELTA/APROBADA**; no se reabre.

## 74.6 Decisiones `OFF-OPEN-*`

- `OFF-OPEN-001` — destino de trabajo pendiente tras revocación: **ABIERTO — pendiente de aprobación**.
- `OFF-OPEN-002` — conservación/purga de datos sincronizados de cliente revocado: **ABIERTO — pendiente de aprobación**.

No se modifican.

## 74.7 Preservación explícita de fronteras

Este documento:

- no reabre `DO-075`;
- no resuelve `DO-T02`;
- no modifica autorización offline;
- no modifica Form Engine;
- no modifica Evidence;
- no modifica Reporting;
- no modifica reglas de mantenimiento;
- no define Mercado Pago;
- no define suscripción comercial más allá de preservar su independencia de créditos.

---

# 75. Gate del documento

## 75.1 Contradicciones bloqueantes

**No se detectan contradicciones bloqueantes conocidas** entre `01..07` y esta especificación conceptual.

La mención de OpenAI como integración inicial en la baseline no obliga a seleccionar aquí modelo, endpoint, SDK ni API concreta. Este documento conserva únicamente la obligación server-side y una frontera desacoplada.

## 75.2 `DM-OPEN-007`

**Estado:** `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

**Propuesta:** rechazar antes de ejecutar si no existen créditos reservables suficientes; no deuda/sobregiro; ofrecer compra; no llamar proveedor antes de asegurar capacidad de consumo.

No aprobada.

## 75.3 `DO-T01`

**Estado:** `PROPUESTA PENDIENTE DE APROBACIÓN`.

**Propuesta:** reserva idempotente → ejecución → confirmación de consumo / liberación o compensación, con retries, pérdida de respuesta, concurrencia, reservas huérfanas, reconciliación e inmutabilidad.

No resuelta ni aprobada.

## 75.4 Nuevas decisiones `AI-OPEN-*`

Se crean ocho decisiones:

- `AI-OPEN-001` — política de costo y visibilidad previa;
- `AI-OPEN-002` — respuesta parcial o inválida;
- `AI-OPEN-003` — cancelación de operación en curso;
- `AI-OPEN-004` — operación en curso al deshabilitar IA;
- `AI-OPEN-005` — retención de input/output/metadata;
- `AI-OPEN-006` — paquetes, expiración y origen comercial de créditos;
- `AI-OPEN-007` — grants y ajustes administrativos excepcionales;
- `AI-OPEN-008` — detalle de historial visible a `COMPANY_ADMIN`.

Todas están **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**.

Ninguna bloquea Fase 1.

Las necesarias para IA/créditos deben resolverse antes de Fase 7; las comerciales de paquetes/expiración antes de Fase 8 según se indica en cada decisión.

## 75.5 Riesgos

Se registran `AI-RSK-001..026`.

Los riesgos principales se concentran en:

- doble consumo;
- concurrencia;
- reservas huérfanas;
- ejecución/ledger no conciliados;
- doble ejecución externa;
- fallos ambiguos;
- hallucinations;
- privacidad;
- cross-tenant;
- compras/acreditaciones inconsistentes;
- ajustes administrativos;
- saldo mutable sin historia.

## 75.6 ADR candidates

Se registran `AI-ADR-CAND-001..012` únicamente como candidatos.

No se genera ningún ADR.

## 75.7 Decisiones previas

Permanecen preservadas con sus estados vigentes:

- `DM-OPEN-001..008`;
- `FORM-OPEN-001..008`;
- `EVID-OPEN-001..006`;
- `RPT-OPEN-001..012`;
- `DO-073`;
- `DO-074`;
- `DO-076`;
- `DO-077`;
- `DO-078`;
- `DO-T01..07`;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `DO-075`.

La única ampliación de estado propia de este documento es formular propuestas pendientes para `DM-OPEN-007`, `DO-T01` y `AI-OPEN-*`, sin aprobarlas.

## 75.8 Estado documental

**Estado de `08-ai-credits-spec.md`: APROBADO.**

**Estado formal:** `APROBADO — especificación conceptual y funcional del subsistema de IA y créditos del MVP`.

La aprobación documental de este documento:

- **NO aprueba `DM-OPEN-007`**;
- **NO aprueba `DO-T01`**;
- **NO resuelve `AI-OPEN-001..008`**;
- **NO resuelve decisiones previas**;
- **NO autoriza implementación**;
- **NO autoriza OpenAI concreto**;
- **NO selecciona modelo**;
- **NO selecciona endpoint, API ni SDK**;
- **NO autoriza prompts productivos**;
- **NO autoriza SQL**;
- **NO autoriza migrations**;
- **NO autoriza tablas físicas**;
- **NO autoriza ledger físico**;
- **NO autoriza transacciones, locks ni RPC**;
- **NO autoriza jobs ni queues**;
- **NO autoriza pricing**;
- **NO autoriza paquetes comerciales reales**;
- **NO autoriza expiración de créditos**;
- **NO autoriza grants ni promociones**;
- **NO autoriza ajustes administrativos**;
- **NO autoriza Mercado Pago**;
- **NO autoriza checkout**;
- **NO autoriza webhooks**;
- **NO autoriza React**;
- **NO autoriza APIs**;
- **NO autoriza Server Actions**;
- **NO autoriza Codex**;
- **NO genera ADRs**;
- **NO autoriza avanzar automáticamente al documento 09**;
- **NO cierra Fase 0**.

## 75.9 Verificación de decisiones abiertas y preservadas

Se confirma para el cierre documental:

- no existen contradicciones bloqueantes conocidas con `01..07`;
- `DM-OPEN-007` permanece **ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN**;
- `DO-T01` permanece **PROPUESTA PENDIENTE DE APROBACIÓN**;
- `AI-OPEN-001..008` permanecen **ABIERTAS — PROPUESTAS PENDIENTES DE APROBACIÓN**;
- ninguna `AI-OPEN-*` bloquea Fase 1;
- las decisiones necesarias para IA/créditos deben resolverse antes de Fase 7 conforme a los plazos indicados en cada decisión;
- `AI-OPEN-006` contiene además decisiones comerciales a resolver antes de Fase 8;
- `FORM-OPEN-001..008` permanecen con sus estados vigentes;
- `EVID-OPEN-001..006` permanecen con sus estados vigentes;
- `RPT-OPEN-001..012` permanecen con sus estados vigentes;
- las decisiones `DO-*` y `OFF-OPEN-*` conservan sus estados vigentes;
- `DO-075` permanece **RESUELTA/APROBADA**.

La aprobación documental de `08-ai-credits-spec.md` no convierte los tratamientos de riesgo, recomendaciones ni ADR candidates en decisiones aprobadas.

## 75.10 Estado de Fase 0

**Estado de Fase 0: EN CURSO.**

La aprobación documental de `08-ai-credits-spec.md` no cierra por sí sola Fase 0 ni resuelve automáticamente las decisiones abiertas aquí registradas.
