# ADR-0001 — Arquitectura modular del SaaS en Next.js

> **Ruta normativa:** `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`  
> **Fase:** Fase 0 — Architecture Decision Record  
> **Estado de Fase 0:** **EN CURSO**  
> **Naturaleza:** decisión arquitectónica global de estructura de aplicación; **NO constituye implementación ni resuelve decisiones funcionales o técnicas abiertas**

**ID: ADR-0001**  
**Title: Arquitectura modular del SaaS en Next.js**  
**Status: ACCEPTED**

---

# 1. ID

`ADR-0001`

# 2. Título

`Arquitectura modular del SaaS en Next.js`

# 3. Status

`ACCEPTED`

Este ADR ha sido aprobado formalmente como decisión arquitectónica global para el MVP.

El estado `ACCEPTED` aprueba únicamente la decisión arquitectónica documentada en este ADR. No autoriza implementación, uso de Codex, inicio de Fase 1, cierre de Fase 0 ni modificación del estado de decisiones `DO-*` o `*-OPEN-*`.

---

# 4. Context

El producto es un SaaS B2B multiempresa para compañías que prestan servicios de mantenimiento técnico.

Cada `MaintenanceCompany` constituye un tenant y el producto exige aislamiento multiempresa, autorización basada en identidad, pertenencia, rol y alcance, además de Row Level Security como frontera primaria de aislamiento remoto.

El sistema contiene múltiples bounded contexts y capacidades conceptuales, entre ellos:

- Identity & Authorization;
- tenant / multi-tenancy;
- clientes industriales;
- locations;
- equipment;
- Form Engine;
- Maintenance;
- Evidence;
- Offline & Sync;
- Reporting;
- AI & Credits;
- Subscription & Payments;
- Dashboard/Analytics futuro;
- Notifications futuro.

Estos límites conceptuales no implican que cada bounded context deba convertirse desde el inicio en un proceso, deployable, base de datos o servicio independiente.

La baseline tecnológica prevista incluye:

- Next.js con App Router;
- React;
- TypeScript estricto;
- Tailwind CSS;
- Supabase PostgreSQL;
- Supabase Auth;
- Supabase Storage;
- Supabase RLS;
- Supabase Realtime cuando corresponda;
- PWA / Service Worker;
- Dexie / IndexedDB para operación offline;
- OpenAI mediante ejecución server-side;
- Mercado Pago para pagos;
- Vercel como plataforma de despliegue prevista.

Este ADR no selecciona versiones concretas ni autoriza la implementación de estas integraciones.

La arquitectura debe soportar simultáneamente varias características con impacto transversal:

- aislamiento multi-tenant;
- autorización y RLS;
- reglas de dominio con históricos inmutables;
- consistencia transaccional en operaciones que lo requieran;
- operación offline-first para parte del producto;
- sincronización e idempotencia;
- generación de informes;
- integración server-side con IA;
- integración comercial con pagos;
- evolución del MVP con velocidad de desarrollo y mantenibilidad.

El MVP no dispone de una necesidad técnica demostrada que justifique asumir desde el inicio el coste operacional de una arquitectura distribuida. Al mismo tiempo, concentrar todo el sistema en un único proyecto no debe degenerar en una arquitectura accidentalmente acoplada en la que los límites de dominio desaparezcan.

La necesidad es, por tanto, conservar simplicidad operacional sin renunciar a modularidad, separación de responsabilidades, seguridad ni capacidad de evolución futura.

---

# 5. Problem

¿Cómo estructurar el SaaS para mantener límites de dominio, seguridad, mantenibilidad y capacidad de evolución sin introducir microservicios prematuramente ni convertir el único proyecto de aplicación en un sistema internamente acoplado sin fronteras claras?

---

# 6. Decision

Para el MVP se adopta una **arquitectura de monolito modular (`modular monolith`) dentro de un único proyecto/aplicación Next.js**.

En este ADR, **monolito modular** significa:

> un sistema inicialmente desplegado como una única aplicación principal, pero organizado internamente mediante módulos y fronteras conceptuales explícitas que preservan responsabilidades, contratos y dependencias controladas.

La decisión implica:

- un único deployable principal de aplicación inicialmente;
- módulos internos con responsabilidades explícitas;
- límites de dominio reconocibles;
- dependencias entre módulos controladas y comprensibles;
- contratos internos claros cuando una capacidad necesita interactuar con otra;
- separación de concerns entre UI, casos de uso, reglas de negocio e infraestructura;
- reglas de dominio que no queden dispersas arbitrariamente en componentes React, middleware o queries ad hoc;
- integraciones externas detrás de fronteras internas apropiadas;
- prevención de dependencias circulares entre bounded contexts;
- evitar imports arbitrarios que atraviesen límites internos sin una dependencia arquitectónicamente válida;
- capacidad de evolucionar o extraer partes del sistema en el futuro si aparece una necesidad técnica demostrada.

La decisión **no** implica:

- un único archivo;
- ausencia de módulos;
- ausencia de capas;
- ausencia de separación de responsabilidades;
- libre acoplamiento entre dominios;
- que toda la lógica deba vivir en componentes React;
- que frontend y backend carezcan de fronteras internas;
- una estructura física final de carpetas;
- una taxonomía definitiva de módulos técnicos;
- una obligación de convertir cada bounded context conceptual en un módulo físico independiente desde el primer día.

No se introducirán microservicios sin una necesidad técnica demostrada y una nueva decisión arquitectónica aprobada.

---

# 7. Principios de modularidad

## 7.1 Cohesión

Cada módulo debe agrupar comportamiento relacionado con una capacidad coherente.

La modularidad debe favorecer que reglas, casos de uso y responsabilidades relacionadas permanezcan próximas conceptualmente, evitando distribuir una misma capacidad de dominio entre zonas sin una frontera entendible.

La cohesión no obliga a una granularidad física determinada.

## 7.2 Encapsulación

Un módulo no debe exponer innecesariamente sus detalles internos a otros módulos.

Los consumidores deben depender, cuando corresponda, de contratos o puntos de interacción suficientemente estables y no de detalles incidentales de implementación.

La encapsulación es una propiedad de diseño interno; no requiere aislamiento por red.

## 7.3 Dependencias explícitas

La comunicación entre módulos debe poseer una dirección entendible.

Una dependencia debe existir porque una capacidad realmente necesita otra, no porque ambas residan en el mismo proyecto y por ello cualquier import sea técnicamente posible.

Las dependencias deben mantenerse visibles y revisables.

## 7.4 No circular dependencies

Las dependencias circulares entre bounded contexts deben considerarse una señal de diseño incorrecto que requiere revisión.

Una circularidad puede indicar:

- responsabilidades mal ubicadas;
- límites demasiado amplios o demasiado fragmentados;
- contratos internos insuficientes;
- reglas compartidas sin ownership claro.

Este ADR no prescribe una herramienta concreta para detectar circularidades.

## 7.5 Domain boundaries

Las reglas centrales del producto no deben vivir dispersas exclusivamente entre:

- componentes visuales;
- middleware;
- handlers;
- queries ad hoc;
- adaptadores de proveedores.

Las decisiones de negocio deben conservar una ubicación conceptual que permita comprenderlas, probarlas y reutilizarlas sin depender innecesariamente de detalles de presentación o infraestructura.

## 7.6 External adapters

OpenAI, Mercado Pago, Supabase Storage, APIs de navegador/PWA, generación documental y otros proveedores o mecanismos externos deben permanecer detrás de fronteras internas cuando el acoplamiento directo pudiera contaminar reglas de dominio o dificultar sustitución, pruebas o evolución.

Este principio no diseña adapters concretos ni selecciona contratos físicos.

---

# 8. Capas conceptuales

La arquitectura debe mantener una separación conceptual mínima entre las siguientes responsabilidades.

## 8.1 Presentation / UI

Responsable de presentar información, capturar intención del usuario y coordinar interacción de interfaz.

Incluye conceptualmente páginas, componentes y elementos de experiencia de usuario.

La UI no es autoridad de seguridad ni debe concentrar reglas de dominio que deban preservarse fuera de la interacción visual.

## 8.2 Application / use cases

Responsable de coordinar casos de uso.

Esta capa conceptual puede:

- recibir una intención válida;
- coordinar reglas de dominio;
- solicitar persistencia o integraciones;
- organizar una operación de aplicación;
- devolver un resultado apropiado al caller.

No se define aquí una forma física concreta de services, commands, handlers o Server Actions.

## 8.3 Domain / business rules

Responsable de reglas e invariantes del negocio que deben conservar significado independientemente de la UI o de un proveedor externo concreto.

La existencia de esta frontera conceptual no implica adoptar DDD completo ni exigir objetos ricos para toda entidad.

## 8.4 Infrastructure / external adapters

Responsable de detalles técnicos de acceso a persistencia, proveedores, archivos, browser APIs y otros mecanismos externos.

Entre ellos pueden existir conceptualmente:

- PostgreSQL/Supabase;
- Auth;
- Storage;
- OpenAI;
- Mercado Pago;
- Dexie/IndexedDB;
- APIs PWA/browser;
- generación PDF/DOCX;
- notificaciones futuras.

## 8.5 Naturaleza de estas capas

Estas capas son **fronteras conceptuales**, no una obligación de mantener exactamente cuatro directorios físicos ni una jerarquía rígida.

El proyecto puede materializar estas ideas de manera pragmática dentro de Next.js, siempre que preserve separación de responsabilidades y dependencias comprensibles.

Este ADR no adopta de forma dogmática:

- Clean Architecture;
- Hexagonal Architecture;
- Onion Architecture;
- DDD completo.

Se aprovechan principios compatibles de esas arquitecturas —como separación de concerns, inversión del acoplamiento hacia proveedores y explicitud de límites— sin imponer un framework arquitectónico completo que la baseline no exige.

---

# 9. Server vs Client

Dado que el producto utiliza Next.js con App Router, la arquitectura debe tratar la frontera server/client como una decisión de confianza y responsabilidad, no únicamente como una elección de renderizado.

Principios:

- debe preferirse ejecución server-side cuando una operación requiera secretos, autoridad o acceso privilegiado;
- los secretos no deben depender del cliente ni exponerse al navegador;
- Client Components deben utilizarse cuando la interacción o una browser API lo requiera;
- los controles de UI nunca sustituyen autorización de servidor ni RLS;
- una operación que llegue desde el navegador debe considerarse intención del usuario, no prueba de autorización;
- el hecho de que una capacidad se ejecute dentro del mismo proyecto Next.js no elimina la necesidad de fronteras de confianza internas.

Este ADR no define:

- Server Actions concretas;
- endpoints concretos;
- Route Handlers concretos;
- RPC concretas;
- Edge Functions concretas;
- Supabase Functions concretas.

---

# 10. Persistencia

Supabase PostgreSQL continúa siendo la **source of truth remota** del producto.

La persistencia se considera una responsabilidad de infraestructura.

Los módulos de dominio y aplicación no deben quedar innecesariamente acoplados a detalles incidentales de queries concretas cuando exista una frontera arquitectónica relevante que permita mantener reglas y casos de uso comprensibles.

Esta regla no obliga a introducir repositories físicos, interfaces genéricas o abstracciones universales.

El nivel de abstracción debe justificarse por la necesidad real del módulo.

RLS permanece como frontera primaria de aislamiento remoto conforme a `docs/product/03-permissions-rls-strategy.md` y al futuro `ADR-0002`.

Este ADR no diseña:

- tablas;
- columnas;
- relaciones físicas;
- SQL;
- migrations;
- repositories concretos;
- ORM;
- políticas RLS;
- queries.

---

# 11. Offline

La estrategia offline-first aprobada introduce una segunda representación local del estado mediante Dexie/IndexedDB.

Offline & Sync es una preocupación transversal que debe poder mantener fronteras propias dentro del monolito modular.

La arquitectura global debe permitir que esa capacidad:

- coordine datos de múltiples módulos sin apropiarse de sus reglas de negocio;
- mantenga separada la representación local del estado remoto autoritativo;
- interactúe con casos de uso que requieren persistencia local-first;
- evolucione sin forzar acoplamiento arbitrario entre todos los módulos afectados.

El estado local no se convierte en source of truth remoto.

Este ADR no diseña:

- `LocalReplica`;
- schema Dexie;
- outbox;
- `SyncOperation`;
- algoritmos de sync;
- conflictos;
- reintentos;
- protección local;
- política de revocación.

Esos detalles pertenecen principalmente a `ADR-0004` y `ADR-0005` y a las decisiones abiertas que correspondan.

---

# 12. Integraciones externas

Las integraciones externas deben tratarse como fronteras de infraestructura o adapters conceptuales cuando exista riesgo de que los contratos externos contaminen reglas de dominio o casos de uso.

Se identifican como fronteras relevantes, sin implementar ni diseñar sus contratos:

- Supabase;
- OpenAI;
- Mercado Pago;
- browser/PWA APIs;
- generación PDF/DOCX;
- notificaciones futuras.

El dominio no debe asumir como propios los modelos de datos, estados o semánticas de un proveedor externo cuando la aplicación necesite preservar significado interno distinto.

Este ADR no selecciona:

- SDK;
- endpoint;
- API concreta;
- modelo IA;
- recurso de Mercado Pago;
- librería documental;
- servicio de notificaciones;
- mecanismo físico de adapter.

---

# 13. Alternatives

## 13.1 Alternativa A — Aplicación monolítica sin modularidad explícita

### Descripción

Mantener un único proyecto y deployable sin definir fronteras internas claras entre capacidades.

### Ventajas

- máxima simplicidad estructural inicial;
- menor esfuerzo inmediato para decidir límites internos;
- navegación inicial del código potencialmente directa mientras el sistema es pequeño.

### Desventajas

- alto riesgo de acoplamiento creciente;
- reglas de negocio dispersas;
- dependencias implícitas y difíciles de revisar;
- mayor probabilidad de que la UI y la infraestructura absorban lógica de dominio;
- dificultad para probar capacidades de forma aislada;
- mayor coste futuro para separar responsabilidades;
- riesgo de degradación hacia un “big ball of mud”.

### Evaluación

Rechazada.

La simplicidad inicial no compensa la pérdida de límites necesaria para un producto con multitenancy, offline, reporting, IA, pagos e históricos inmutables.

---

## 13.2 Alternativa B — Monolito modular

### Descripción

Un único proyecto/aplicación Next.js y un deployable principal inicial, con módulos internos, responsabilidades explícitas y dependencias controladas.

### Ventajas

- simplicidad operacional;
- una única aplicación principal para desplegar inicialmente;
- menor complejidad de networking y coordinación;
- consistencia transaccional más accesible cuando varias capacidades comparten PostgreSQL;
- límites internos documentables;
- pruebas de dominio, aplicación e integración más directas;
- evolución rápida del MVP;
- posibilidad futura de extraer una capacidad si aparece evidencia suficiente.

### Desventajas

- exige disciplina arquitectónica continua;
- los límites no están protegidos físicamente por la red;
- un único deployable puede acoplar releases;
- el escalado inicial del sistema es principalmente conjunto;
- una mala disciplina puede degradarlo hacia un monolito acoplado.

### Evaluación

**Elegida.**

Es la alternativa que mejor equilibra simplicidad operacional, velocidad de desarrollo, seguridad, consistencia y mantenibilidad para el MVP sin impedir evolución posterior.

---

## 13.3 Alternativa C — Microservicios desde el MVP

### Descripción

Separar capacidades del producto en múltiples servicios independientes desde el inicio.

### Ventajas potenciales

- aislamiento de procesos;
- despliegues independientes;
- escalado independiente;
- posibilidad de aislar determinados fallos o cargas;
- ownership organizacional más explícito cuando existen equipos independientes.

### Desventajas

Introduce de forma inmediata problemas que el MVP no ha demostrado necesitar resolver:

- networking entre servicios;
- autenticación y autorización entre servicios;
- observabilidad distribuida;
- retries entre boundaries;
- consistencia eventual adicional;
- distributed transactions o compensaciones;
- mayor complejidad de despliegue;
- debugging distribuido;
- más puntos de fallo;
- versionado y compatibilidad de contratos;
- mayor coste operacional.

### Evaluación

Rechazada para el MVP.

No existe una necesidad técnica demostrada que justifique ese coste. Una futura extracción sólo podrá evaluarse con evidencia concreta y una nueva decisión arquitectónica aprobada.

---

## 13.4 Alternativa D — Backend independiente separado + frontend Next.js

### Descripción

Mantener Next.js exclusivamente como frontend y crear desde el inicio un backend de aplicación independiente como deployable separado.

### Ventajas potenciales

- frontera física clara entre frontend y backend;
- ciclos de despliegue independientes;
- capacidad de alojar lógica server-side fuera del runtime de Next.js;
- potencial reutilización del backend por múltiples clientes en el futuro.

### Desventajas

- añade otro deployable y coordinación operacional desde el inicio;
- requiere definir y versionar un contrato de red adicional;
- incrementa complejidad de autenticación, autorización, despliegue y debugging;
- puede duplicar responsabilidades que Next.js puede alojar server-side para la baseline actual;
- introduce una separación física sin necesidad técnica demostrada.

### Evaluación

No seleccionada como baseline inicial.

No se considera intrínsecamente incorrecta. Podrá reconsiderarse si Next.js deja de satisfacer una necesidad demostrada de ejecución server-side, aislamiento, escalado, seguridad u operación. La decisión actual evita introducir esa separación antes de necesitarla.

---

# 14. Consequences

## 14.1 Consecuencias positivas

- menor complejidad operativa inicial;
- deploy principal más simple;
- consistencia transaccional más fácil de preservar cuando las operaciones comparten PostgreSQL;
- desarrollo inicial más rápido;
- límites internos documentables;
- testing más directo;
- menor superficie de fallos distribuidos;
- mayor facilidad para mantener TypeScript estricto y contratos internos coherentes dentro del mismo codebase;
- capacidad de evolucionar módulos de forma independiente a nivel conceptual;
- posibilidad de extraer módulos posteriormente si aparece necesidad real.

## 14.2 Consecuencias negativas

- la disciplina modular debe mantenerse activamente;
- un único deploy puede acoplar releases de capacidades distintas;
- el escalado inicial ocurre principalmente sobre el sistema conjunto;
- existe riesgo de degradación hacia un “big ball of mud” si se permiten dependencias arbitrarias;
- los límites internos no están protegidos por una frontera de red;
- una modificación en infraestructura compartida puede afectar múltiples módulos;
- será necesario revisar dependencias internas a medida que el producto crezca.

---

# 15. Criterios futuros para considerar extracción

Un módulo sólo debería considerarse candidato a proceso o servicio independiente cuando exista evidencia concreta de que la separación resolvería una necesidad real.

Criterios de evaluación posibles:

- requerimientos de escalado materialmente distintos;
- necesidad de aislamiento operacional;
- límites de seguridad específicos;
- ciclos de despliegue realmente independientes;
- restricciones regulatorias;
- carga especializada;
- necesidad demostrada de failure isolation;
- ownership organizacional real y estable;
- limitaciones demostradas del deployable actual;
- incompatibilidad técnica demostrada con el runtime o topología actual.

La presencia de uno de estos factores no autoriza automáticamente una extracción.

Debe evaluarse:

- beneficio;
- coste;
- nueva complejidad;
- consistencia;
- seguridad;
- operaciones;
- observabilidad;
- migración;
- impacto sobre datos y contratos.

Toda extracción arquitectónicamente relevante requerirá una nueva decisión arquitectónica/ADR aprobada.

---

# 16. Security implications

La elección de un monolito modular no reduce ni sustituye ninguna regla de seguridad aprobada.

Debe preservarse:

- aislamiento estricto entre tenants;
- RLS como frontera primaria de aislamiento remoto;
- autorización basada en estado autoritativo;
- prohibición de confiar en frontend como autoridad;
- ejecución server-side para secretos o autoridad privilegiada;
- secretos únicamente en contextos confiables;
- uso restringido de `service-role`;
- validación de ownership;
- separación entre identidad autenticada y autorización efectiva;
- imposibilidad de utilizar una frontera interna de módulo como bypass de permisos.

Los módulos comparten un deployable, pero eso no significa que cualquier módulo pueda acceder libremente a cualquier dato o ejecutar cualquier operación.

Una dependencia interna nunca debe utilizarse para saltarse:

- RLS;
- reglas de autorización;
- tenant ownership;
- client scope;
- restricciones de soporte excepcional.

Este ADR no diseña RLS ni resuelve `ADR-0002` o `ADR-0003`.

---

# 17. Data implications

Supabase PostgreSQL permanece como source of truth remoto.

Utilizar una base compartida no significa que los datos carezcan de ownership.

Cada bounded context debe respetar:

- tenant ownership;
- ownership de sus recursos;
- invariantes de referencia;
- límites de responsabilidad;
- históricos e inmutabilidad cuando correspondan.

No se crean bases de datos separadas por módulo por defecto.

Una futura separación de persistencia requeriría una decisión explícita que analice, entre otros aspectos:

- ownership;
- consistencia;
- integridad;
- autorización;
- migración;
- reporting;
- sincronización;
- observabilidad.

Este ADR no diseña tablas, schemas, claves, migrations ni queries.

---

# 18. Offline implications

El monolito modular debe permitir que Offline & Sync mantenga fronteras propias y coordine con otros módulos sin absorber sus reglas de negocio.

La arquitectura global debe preservar:

- la estrategia local-first aprobada;
- separación entre estado local y source of truth remoto;
- capacidad de representar trabajo offline sin convertir la réplica local en autoridad remota;
- posibilidad de que sincronización e idempotencia evolucionen con contratos explícitos.

Los detalles permanecen fuera de este ADR y corresponden principalmente a:

- `ADR-0004` — Offline local-first y aislamiento de réplica;
- `ADR-0005` — Protocolo de sincronización, idempotencia y conflictos.

Este ADR no resuelve ningún `OFF-OPEN-*`, `FORM-OPEN-*`, `EVID-OPEN-*` ni `DO-T03/T04`.

---

# 19. Testing implications

La implementación futura deberá poder verificar no sólo comportamiento funcional sino también preservación de límites arquitectónicos.

Categorías de pruebas o verificaciones relevantes:

- module boundary tests cuando resulte útil;
- domain tests;
- application/use-case tests;
- integration tests;
- authorization/RLS tests;
- cross-module interaction tests;
- adapter contract tests;
- verificaciones destinadas a prevenir dependencias circulares;
- build;
- typecheck;
- lint.

Este ADR no selecciona un framework de testing adicional ni define casos de prueba concretos.

---

# 20. Deployment implications

La arquitectura inicial tendrá **un deployable principal de aplicación**.

Vercel permanece como plataforma de despliegue prevista para la aplicación Next.js.

No se introducen microservicios iniciales.

Este ADR no inventa:

- workers;
- jobs;
- queues;
- procesos separados;
- topologías avanzadas;
- containers;
- Kubernetes;
- Docker;
- una estrategia CI/CD concreta.

Si en el futuro aparece una necesidad real de procesos separados, deberá analizarse explícitamente y documentarse mediante la decisión arquitectónica correspondiente.

---

# 21. Observability implications

`DO-T05` y `ADR-0016` permanecen diferidos.

Este ADR no selecciona:

- proveedor de observabilidad;
- logging vendor;
- métricas concretas;
- SLO;
- throughput objetivo;
- latencias objetivo.

La única implicación arquitectónica establecida aquí es que los límites modulares deberían permitir, en el futuro, observar operaciones críticas por dominio sin que la arquitectura interna impida distinguir responsabilidades.

---

# 22. Dependencies

## 22.1 Dependencias normativas

Este ADR depende de reglas ya aprobadas en:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/10-architecture-decisions-records.md`.

También preserva restricciones y contexto desarrollados en los documentos derivados citados en References.

## 22.2 Dependencias abiertas

`ADR-0001` **no depende de ningún `DO-*` o `*-OPEN-*` pendiente para su decisión base**.

Ninguna decisión abierta es resuelta por este ADR.

## 22.3 Relación con ADR posteriores

Este ADR condiciona como marco global a los ADR posteriores, entre ellos:

- `ADR-0002` — Multi-tenancy, tenant ownership y aislamiento;
- `ADR-0003` — Autorización, client scope y soporte excepcional;
- `ADR-0004` — Offline local-first y aislamiento de réplica;
- `ADR-0005` — Protocolo de sincronización, idempotencia y conflictos;
- `ADR-0006` — Ledger de créditos IA y settlement de `AIUsageOperation`;
- `ADR-0007` — `PaymentEvent`, adapter de Mercado Pago e idempotencia comercial;
- `ADR-0008` — Form Engine: versionado, estructura y aplicabilidad;
- `ADR-0009` — Modelo de `MaintenanceRevision` e histórico de mantenimiento;
- `ADR-0010` — Evidence histórica, replacement y continuidad entre revisiones;
- `ADR-0011` — Reporting: versionado, snapshots y finalización;
- `ADR-0012` — `ReportDocumentModel` y renderizadores PDF/DOCX;
- `ADR-0013` — IA server-side, provider boundary y minimización de datos;
- `ADR-0014` — Subscription lifecycle y commercial entitlement;
- `ADR-0015` — Pricing comercial versionado.

Esto no resuelve ni aprueba las decisiones propias de esos ADR.

---

# 23. References

Referencias normativas y conceptuales:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- `docs/product/04-offline-sync-strategy.md`;
- `docs/product/05-form-engine-spec.md`;
- `docs/product/06-maintenance-evidence-spec.md`;
- `docs/product/07-reporting-engine-spec.md`;
- `docs/product/08-ai-credits-spec.md`;
- `docs/product/09-subscription-payments-spec.md`;
- `docs/product/10-architecture-decisions-records.md`.

La inclusión de estas referencias no convierte en resueltas decisiones abiertas contenidas en ellas.

---

# 24. Supersession

`Supersedes: None`

`Superseded by: None`

---

# 25. Gate del ADR

## 25.1 Resultado

- **ADR generado:** `ADR-0001`;
- **Title:** `Arquitectura modular del SaaS en Next.js`;
- **Status:** `ACCEPTED`;
- **decisión documentada:** monolito modular dentro de un único proyecto/aplicación Next.js para el MVP;
- **deployable inicial:** uno principal;
- **microservicios autorizados:** no;
- **contradicciones bloqueantes conocidas:** ninguna;
- **decisiones `DO-*` o `*-OPEN-*` resueltas por este ADR:** ninguna;
- **código generado:** no;
- **SQL generado:** no;
- **migrations diseñadas:** no;
- **estructura física final de carpetas diseñada:** no;
- **implementación autorizada:** no;
- **otro ADR generado:** no;
- **aprobación del ADR:** completada.

## 25.2 Alcance de la decisión

Este ADR registra únicamente la decisión arquitectónica global de:

- mantener una arquitectura modular dentro del mismo proyecto Next.js;
- utilizar un monolito modular para el MVP;
- favorecer un único deployable principal inicialmente;
- no introducir microservicios sin necesidad técnica demostrada y una nueva decisión arquitectónica aprobada.

No decide ni autoriza:

- estructura exacta de `/src`;
- nombres exactos de carpetas;
- naming físico de módulos;
- repositories concretos;
- ORM;
- queries;
- SQL;
- migrations;
- schemas;
- RLS;
- cache;
- queues;
- jobs;
- event bus;
- message broker;
- cron;
- retry counts;
- API REST vs RPC;
- Server Actions concretas;
- Edge Functions concretas;
- Supabase Functions concretas;
- microservices;
- containers;
- Kubernetes;
- Docker;
- CI/CD concreto;
- observability vendor;
- logging vendor;
- testing framework adicional;
- deployment topology avanzada.

## 25.3 Estado de fase

**Estado de Fase 0: EN CURSO**

La aprobación de este ADR no cierra Fase 0.

ADR-0001 queda aceptado como decisión arquitectónica global de monolito modular para el MVP. Después de este ADR todavía existen otros ADR `READY TO DRAFT` pendientes; este cierre no avanza automáticamente a ellos.

**Aprobación del ADR: COMPLETADA.**
