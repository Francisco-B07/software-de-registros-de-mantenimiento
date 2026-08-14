# ADR-0013 — IA server-side, provider boundary y minimización de datos

> **Ruta normativa:** `docs/architecture/adr/ADR-0013-ai-server-side-provider-boundary.md`  
> **Fase:** Fase 0 — Architecture Decision Record  
> **Estado de Fase 0:** **EN CURSO**  
> **Naturaleza:** decisión arquitectónica conceptual sobre frontera server-side de IA, desacoplamiento del proveedor, minimización de datos y relación con Reporting; **NO constituye implementación, selección de modelo/SDK/API, diseño de prompts, diseño físico del ledger, SQL, RLS ni política legal de retención**

**ID: ADR-0013**  
**Title: IA server-side, provider boundary y minimización de datos**  
**Status: ACCEPTED**

---

# 1. ID

`ADR-0013`

# 2. Título

`IA server-side, provider boundary y minimización de datos`

# 3. Status

`ACCEPTED`

Este ADR ha sido aprobado formalmente como decisión arquitectónica para la frontera de IA del MVP.

El estado `ACCEPTED` aprueba únicamente la decisión arquitectónica documentada en este ADR.

La aceptación de este ADR:

- aprueba AI server-side only, provider boundary interna, minimización obligatoria y human-in-the-loop dentro del alcance documentado;
- no autoriza implementación;
- no autoriza uso de Codex;
- no selecciona un proveedor alternativo;
- no selecciona modelo, SDK, endpoint ni protocolo de transporte;
- no diseña prompts productivos;
- no resuelve el ledger ni el settlement de créditos IA;
- no resuelve `AI-OPEN-001..008`;
- no resuelve `DO-T01`;
- no resuelve `DO-T07`;
- no resuelve ninguna decisión `DO-*` o `*-OPEN-*`;
- no inicia Fase 1;
- no cierra Fase 0.

---

# 4. Context

El producto es un SaaS B2B multiempresa para empresas de mantenimiento técnico.

La baseline aprobada establece que la IA forma parte del MVP únicamente como una capacidad de **asistencia editorial para Reporting**. No es un subsistema autónomo de decisión técnica, no sustituye al usuario y no constituye una fuente de verdad sobre los hechos de mantenimiento.

Las reglas aprobadas relevantes incluyen:

- `MaintenanceCompany` es la frontera primaria de tenancy;
- `COMPANY_ADMIN` es el actor funcional autorizado para utilizar IA en Reporting;
- `TECHNICIAN` no utiliza IA para Reports en el MVP;
- Reporting debe poder operar y finalizar informes sin IA;
- IA no modifica mantenimientos, revisiones, respuestas ni Evidence;
- IA no decide qué datos históricos son correctos;
- IA no selecciona `MaintenanceRevision`;
- IA no selecciona Evidence;
- IA no finaliza Reports;
- IA no asigna números oficiales;
- IA no produce documentos oficiales directamente;
- las llamadas al proveedor deben realizarse server-side;
- los secretos del proveedor no deben exponerse al navegador/PWA;
- deben minimizarse los datos enviados al proveedor;
- no existe IA de imágenes ni análisis de Evidence fotográfica en el MVP;
- toda salida generada requiere revisión humana;
- los créditos IA pertenecen a la `MaintenanceCompany`;
- el ledger/wallet de créditos es tenant-owned;
- Subscription y AI credits son conceptos comerciales distintos;
- los retries técnicos no deben confundirse con nuevas generaciones deliberadas.

`ADR-0001` está `ACCEPTED` y adopta un monolito modular dentro de un único proyecto Next.js. Esa decisión exige mantener integraciones externas detrás de fronteras internas cuando el acoplamiento directo pueda contaminar el dominio.

`ADR-0002` está `ACCEPTED` y exige tenant ownership inequívoco, tenant resolution autoritativa, integridad cross-tenant y RLS como frontera primaria de aislamiento remoto.

`ADR-0005` está `ACCEPTED` y establece principios de identidad lógica, idempotencia end-to-end, retries seguros y distinción entre retry y nueva intención.

`ADR-0009` está `ACCEPTED` y establece que `MaintenanceRevision` representa un estado histórico completo e inmutable de un mantenimiento. La IA no puede reinterpretar ni escoger arbitrariamente ese histórico.

`ADR-0012` está `ACCEPTED` y establece que el contenido semántico del informe debe consolidarse antes de la renderización en un único `ReportDocumentModel`, consumido después por renderizadores independientes del dominio.

El registro maestro `docs/product/10-architecture-decisions-records.md` clasificó `ADR-0013` como `READY TO DRAFT` antes de esta aprobación. El núcleo de esta decisión puede documentarse sin resolver las decisiones abiertas de IA/créditos ni las decisiones legales de retención.

En particular:

- `AI-OPEN-001..008` permanecen abiertas;
- `DO-T01` permanece pendiente de aprobación;
- `DO-T07` permanece `DIFERIDO`;
- `AI-OPEN-005` permanece abierta y gobierna junto con `DO-T07` aspectos de retención y privacidad aún no decididos.

La necesidad arquitectónica actual no es elegir un modelo o diseñar prompts. La necesidad es impedir que la integración externa se convierta en una extensión no controlada del navegador o en una dependencia física del dominio de Reporting.

---

# 5. Problem

¿Cómo integrar una capacidad de IA externa para asistencia editorial de Reporting de forma que:

- ningún secreto del proveedor llegue al navegador/PWA;
- la autorización se resuelva internamente antes de invocar IA;
- no pueda mezclarse contexto de tenants distintos;
- el proveedor no determine tenant, ownership, roles, créditos ni reglas de negocio;
- Reporting no dependa del SDK, endpoints, response shapes ni conceptos propietarios del proveedor;
- sólo se comparta con el proveedor el contexto mínimo necesario;
- la salida del proveedor permanezca bajo revisión humana y no sea autoritativa;
- el contenido aceptado pueda integrarse correctamente en la semántica de Reporting antes de `ReportDocumentModel` y rendering;
- los fallos de IA no impidan preparar o finalizar Reports manualmente;
- la futura política de créditos pueda correlacionar correctamente una operación funcional con su ejecución técnica sin que este ADR diseñe el settlement;
- una futura sustitución del proveedor pueda realizarse sin reescribir las reglas de negocio?

La solución debe evitar simultáneamente:

- exposición de provider credentials;
- invocaciones directas no controladas desde browser/PWA;
- tenant spoofing;
- filtrado accidental de contexto cross-tenant;
- acoplamiento del dominio con OpenAI u otro proveedor;
- sobrecompartición de datos;
- propagación de prompts, respuestas o metadata física del proveedor como modelo de dominio;
- tratamiento del output IA como hecho técnico;
- automatización no aprobada de estados de Reporting;
- dependencia estructural de Reporting respecto de IA.

---

# 6. Decision

Para el MVP se adopta la siguiente decisión arquitectónica:

> **Toda invocación real a un proveedor de IA ocurre exclusivamente desde una frontera server-side controlada por la aplicación; Reporting y la lógica de aplicación consumen una frontera interna de proveedor que expresa necesidades propias del producto, y todo contexto enviado al proveedor debe minimizarse antes de abandonar la aplicación.**

La arquitectura conceptual es:

`Browser / PWA`
→ `Reporting / AI application logic server-side`
→ `AI Provider Boundary`
→ `Proveedor externo`

El browser/PWA puede expresar una intención de uso de IA y recibir un resultado ya procesado por la aplicación, pero no puede convertirse en cliente oficial directo del proveedor ni en autoridad para ninguna decisión de tenancy, autorización o consumo.

La decisión contiene cuatro invariantes principales:

1. **server-side only:** toda invocación real al proveedor se realiza desde contexto server-side autorizado;
2. **provider boundary:** el dominio y los casos de uso no dependen del contrato físico del proveedor;
3. **data minimization:** el contexto externo contiene únicamente los datos autorizados y necesarios para la tarea;
4. **human-in-the-loop:** el resultado IA es contenido sugerido y sólo entra al contenido semántico del Report después de revisión humana legítima.

Esta decisión no introduce una arquitectura multi-provider activa ni un microservicio de IA. Su objetivo es impedir acoplamiento innecesario y mantener una frontera de confianza clara dentro del monolito modular aprobado.

---

# 7. Alcance funcional de IA en el MVP

La frontera de IA sólo soporta las capacidades funcionales ya aprobadas para Reporting.

Conceptualmente puede asistir en tareas editoriales tales como:

- redacción de texto de informe;
- reformulación de contenido;
- resumen textual;
- redacción técnica derivada de contexto autorizado;
- otras transformaciones editoriales que formen parte del flujo aprobado de Reporting.

Este ADR no autoriza ni incorpora al MVP:

- chatbot general;
- asistente para `TECHNICIAN`;
- clasificación automática de fotografías;
- visión o análisis multimodal de Evidence;
- OCR como capacidad IA;
- mantenimiento predictivo por IA;
- recomendaciones operativas autónomas;
- generación automática de decisiones de mantenimiento;
- embeddings;
- RAG;
- vector database;
- agentes;
- tool/function calling autónomo;
- acciones autónomas sobre el dominio.

Nada de lo anterior queda aprobado por este ADR.

---

# 8. Server-side AI boundary

Toda invocación real al proveedor debe ocurrir dentro de un contexto server-side controlado por la aplicación.

La frontera server-side es responsable conceptualmente de garantizar que, antes de contactar al proveedor:

- exista un actor autenticado cuando la operación sea iniciada por usuario;
- el actor posea la capacidad funcional aprobada;
- el tenant efectivo se haya resuelto autoritativamente;
- el alcance sobre los datos fuente sea válido;
- la IA se encuentre habilitada para la empresa cuando corresponda;
- las demás precondiciones comerciales y de autorización aplicables hayan sido satisfechas conforme a sus decisiones correspondientes;
- el contexto haya sido minimizado;
- no se incluyan secretos ni datos fuera de alcance.

El hecho de ejecutar código en servidor no convierte automáticamente una operación en autorizada. La frontera server-side debe continuar respetando las reglas de autorización y tenancy aprobadas.

---

# 9. Responsabilidad del browser/PWA

El browser/PWA es un entorno no confiable para decisiones de seguridad.

Puede:

- iniciar una solicitud funcional de asistencia IA;
- expresar la intención editorial permitida;
- enviar datos o referencias permitidas que el servidor deba validar;
- presentar al usuario el resultado procesado;
- permitir revisar, editar, aceptar o descartar una sugerencia conforme al flujo de Reporting.

No puede:

- poseer provider API keys;
- poseer otras provider credentials de plataforma;
- llamar directamente al proveedor como arquitectura oficial;
- decidir tenant efectivo;
- decidir ownership;
- decidir membership;
- decidir client scope;
- decidir si existen créditos suficientes;
- decidir settlement;
- saltar controles de autorización;
- convertirse en fuente de verdad sobre consumo o éxito de la operación.

Un parámetro, ID o flag enviado por el frontend expresa intención o contexto. No constituye autoridad.

---

# 10. Server-side secrets

Las credenciales del proveedor existen únicamente en contexto server-side autorizado.

En consecuencia:

- no deben exponerse al navegador/PWA;
- no deben incluirse en bundles cliente;
- no deben persistirse en IndexedDB;
- no deben almacenarse en Local Storage;
- no deben enviarse como parte de payloads del cliente;
- no deben aparecer innecesariamente en logs;
- no deben formar parte de `Report`, `ReportVersion`, `ReportSnapshot`, `ReportDocumentModel` ni `AIUsageOperation` como contenido de dominio.

Este ADR no selecciona:

- nombre de variables de entorno;
- secret manager;
- Supabase Vault;
- configuración de Vercel;
- estrategia de rotación;
- deployment configuration.

Esas decisiones pertenecen a implementación y operación posteriores.

---

# 11. Provider boundary

Debe existir conceptualmente una frontera interna entre la lógica de aplicación/Reporting y el proveedor externo.

La relación es:

`Reporting / AI application logic`
→ `AI Provider Boundary`
→ `Proveedor externo`

El contrato arquitectónico interno debe expresar necesidades de la aplicación, no replicar el API físico del proveedor.

La frontera puede representar conceptualmente capacidades como:

- solicitar una generación/redacción autorizada;
- recibir un resultado normalizado;
- recibir metadata técnica mínima cuando resulte necesaria;
- distinguir conceptualmente éxito, fallo técnico o resultado inutilizable;
- correlacionar la invocación con una operación interna.

La frontera no se define en este ADR mediante:

- interfaces TypeScript;
- method names;
- DTOs;
- JSON schemas;
- endpoints;
- HTTP contracts;
- response schemas;
- protocolos de streaming.

---

# 12. Proveedor operativo inicial vs contrato arquitectónico interno

La baseline actual puede utilizar OpenAI como proveedor operativo inicial.

Esta circunstancia no convierte a OpenAI en lenguaje del dominio.

Reporting y las reglas de negocio no deben depender de:

- nombres de endpoints del proveedor;
- objetos de SDK;
- response shapes físicos;
- provider request schemas;
- IDs internos del proveedor;
- nombres concretos de modelos;
- parámetros propietarios de inferencia;
- estados externos que no representen significado necesario para la aplicación.

El objetivo no es construir routing multi-provider desde el primer día.

El objetivo es que la sustitución futura del proveedor, si alguna vez se decide, afecte principalmente a la infraestructura/adaptador y no obligue a reescribir el dominio de Reporting.

Este ADR no selecciona un proveedor alternativo ni diseña failover.

---

# 13. Modelo y configuración de inferencia

La selección concreta de modelo es una decisión de configuración/implementación posterior.

El dominio no debe depender de un nombre de modelo concreto.

Este ADR no fija:

- modelo específico;
- provider model ID;
- temperature;
- top_p;
- max tokens;
- reasoning effort;
- seed;
- cualquier otro parámetro físico equivalente.

Cuando la implementación futura necesite conservar metadata técnica de ejecución para diagnóstico, auditoría operacional o reconciliación, esa metadata deberá mantenerse detrás de la frontera y no convertirse en semántica de Reporting salvo que exista una razón aprobada.

---

# 14. Prompts

Los prompts pertenecen a la responsabilidad interna server-side de la integración IA.

Principios arquitectónicos:

- no deben contener secretos;
- sólo deben utilizar contexto autorizado;
- sólo deben utilizar contexto minimizado;
- los datos capturados por usuarios deben tratarse como datos no confiables y no adquirir privilegios;
- la construcción de prompts no modifica autorización ni tenancy;
- los prompts productivos no forman parte del contrato de dominio de Reporting.

Este ADR no redacta:

- system prompts;
- prompt templates;
- instrucciones productivas;
- estrategias de few-shot;
- schemas de prompt.

---

# 15. Prompt injection y contenido no confiable

Los textos provenientes de Maintenance, Responses u otras fuentes autorizadas pueden contener contenido no confiable.

Cuando se incorporen como contexto para IA:

- no deben adquirir privilegios de sistema;
- no deben redefinir tenant;
- no deben redefinir ownership;
- no deben redefinir rol o client scope;
- no deben modificar reglas de autorización;
- no deben provocar exfiltración de secretos;
- no deben habilitar acceso a contexto de otro tenant;
- no deben convertirse automáticamente en instrucciones autoritativas.

La implementación futura deberá tratar la separación entre instrucciones internas y contenido de usuario como una preocupación de seguridad.

Este ADR no diseña filtros, parsers ni un threat model completo de prompt injection.

---

# 16. Autorización previa a una operación IA

Antes de iniciar una invocación externa, la aplicación debe resolver conceptualmente:

- identidad autenticada;
- rol/capacidad aprobada;
- tenant efectivo;
- client scope cuando corresponda;
- ownership de las fuentes;
- habilitación de IA para la empresa;
- demás precondiciones comerciales/autorizativas aplicables.

Para Reporting del MVP:

- `COMPANY_ADMIN` es el actor funcional aprobado;
- `TECHNICIAN` no obtiene capacidad de uso de IA;
- `SUPER_ADMIN` no obtiene uso tenant de IA por inferencia de su rol global ni por un `SupportAccessGrant` genérico.

La regla continúa siendo:

> ausencia de permiso aprobado = no se infiere permiso.

Este ADR no diseña RLS, claims, policies ni mecanismos físicos de autorización.

---

# 17. Tenant isolation

`ADR-0002 = ACCEPTED` permanece plenamente vigente.

Toda operación IA pertenece a un tenant inequívoco.

La frontera de IA debe preservar que:

- el tenant efectivo se resuelva desde estado autoritativo;
- un `tenant_id` enviado por frontend no sea autoridad;
- el contexto enviado al proveedor provenga exclusivamente del tenant autorizado;
- no se mezclen datos de tenants diferentes dentro de una misma provider request;
- el proveedor no decida ownership;
- provider request IDs, conversation IDs u otra metadata externa no determinen tenancy;
- retries o replays no permitan evadir tenant isolation.

Una provider request que mezcle datos cross-tenant constituye una violación de aislamiento aunque la respuesta nunca llegue al usuario.

Este ADR no diseña aislamiento físico del proveedor ni cuentas separadas por tenant.

---

# 18. Datos permitidos conceptualmente

La baseline permite utilizar información actual o histórica de:

- `Client`;
- `Equipment`;
- `Maintenance`;
- `MaintenanceRevision` ya seleccionada legítimamente por Reporting cuando corresponda;
- `Responses`;
- contexto semántico de Reporting;
- otros textos ya aprobados por la baseline como parte del informe.

La existencia de esa información dentro del sistema no implica autorización automática para enviarla al proveedor.

Para que un dato forme parte del contexto IA deben cumplirse simultáneamente:

- pertenecer al tenant correcto;
- encontrarse dentro del alcance autorizado;
- ser necesario para la tarea editorial concreta;
- haber pasado por minimización.

Se mantiene el principio:

> **disponibilidad interna de un dato != necesidad de compartirlo con el proveedor AI.**

---

# 19. Minimización de datos

La minimización de datos es una invariante arquitectónica de esta decisión.

Antes de enviar contexto al proveedor externo deben excluirse, cuando no sean necesarios para la tarea:

- identificadores internos;
- `maintenance_company_id`;
- IDs de Client;
- IDs de Equipment;
- IDs de Maintenance;
- IDs de `MaintenanceRevision`;
- IDs de Responses;
- datos personales no necesarios;
- metadata técnica irrelevante;
- URLs privadas;
- paths internos;
- tokens;
- credenciales;
- información histórica excesiva;
- campos o secciones no relacionados con la tarea.

Además:

- no deben enviarse fotografías ni archivos para análisis IA en el MVP;
- no debe enviarse automáticamente todo el snapshot o todo el histórico disponible;
- la selección de contexto debe responder a la necesidad editorial concreta.

Este ADR no define un algoritmo de minimización, una lista legal exhaustiva ni reglas físicas de redacción de payloads.

---

# 20. Evidence e imágenes

No existe IA de imágenes en el MVP.

Por tanto, esta arquitectura no autoriza:

- enviar Evidence fotográfica a modelos multimodales;
- clasificar fotografías;
- extraer conclusiones visuales;
- comparar imágenes automáticamente;
- usar OCR de imágenes como parte de la capacidad IA aprobada;
- generar decisiones técnicas a partir de imágenes.

Si Reporting ya dispone legítimamente de descripciones textuales autorizadas y necesarias, dichas descripciones pueden formar parte del contexto minimizado.

Esta posibilidad no resuelve ninguna decisión `EVID-OPEN-*`.

---

# 21. Datos que el proveedor nunca determina como autoridad

El proveedor externo nunca es autoridad para:

- tenant;
- ownership;
- membership;
- role;
- client scope;
- autorización;
- AI enabled/disabled;
- créditos disponibles;
- ledger;
- subscription entitlement;
- `ReportVersion`;
- número oficial;
- `MaintenanceRevision` current;
- selección de revisiones históricas;
- Evidence válida;
- inclusión o exclusión de mantenimientos;
- reglas de negocio;
- finalización del Report.

Esos aspectos deben quedar resueltos internamente conforme a las reglas de cada bounded context.

El proveedor puede producir contenido textual, pero no adjudicar autoridad a ese contenido.

---

# 22. Output de IA

El resultado del proveedor debe tratarse como **untrusted generated content** desde el punto de vista de negocio.

Debe:

- normalizarse antes de entrar al flujo de aplicación;
- validarse estructuralmente cuando corresponda;
- mantenerse sujeto a revisión humana;
- poder ser editado;
- poder ser aceptado o descartado;
- permanecer separado de los hechos técnicos autoritativos;
- no ejecutar acciones por sí mismo;
- no conceder permisos;
- no cambiar estados de dominio automáticamente.

La aplicación no debe asumir que una respuesta generada es correcta simplemente porque el proveedor la devolvió satisfactoriamente.

---

# 23. Human-in-the-loop

La regla funcional es:

> **AI output = sugerencia.**

No:

> **AI output = contenido oficial automáticamente.**

`COMPANY_ADMIN` debe mantener control editorial para:

- revisar;
- editar;
- aceptar;
- descartar.

Un texto sugerido por IA se convierte en contenido editorial del informe únicamente cuando el flujo autorizado de Reporting lo incorpora legítimamente.

La IA no:

- finaliza el Report;
- asigna número oficial;
- selecciona `ReportVersion`;
- decide qué `MaintenanceRevision` usar;
- selecciona Evidence;
- crea el PDF oficial como autoridad;
- crea DOCX como autoridad;
- decide tenant;
- decide permisos.

---

# 24. Relación con `ADR-0012`

`ADR-0012 = ACCEPTED` permanece preservado.

El pipeline conceptual de asistencia IA es:

`datos históricos autorizados`
→ `contexto minimizado para AI`
→ `AI suggestion`
→ `revisión humana`
→ `contenido semántico aprobado`
→ `ReportDocumentModel`
→ `Renderer`

La IA participa antes de la construcción final del contenido semántico aprobado.

No debe producir directamente:

- PDF;
- DOCX;
- layout;
- HTML canónico;
- un `ReportDocumentModel` autoritativo sin revisión humana.

Una vez que el texto ha sido revisado e incorporado legítimamente al contenido semántico, el renderer no necesita conocer si ese texto comenzó como sugerencia IA o fue escrito directamente por una persona.

El renderer permanece independiente del proveedor de IA.

---

# 25. Relación con `ReportSnapshot` e histórico

La frontera IA consume el contexto que Reporting haya resuelto legítimamente.

Si Reporting trabaja sobre una `ReportVersion` o contexto histórico ya fijado, la IA no debe sustituirlo por datos actuales arbitrarios.

La IA no decide:

- qué snapshot corresponde;
- qué revisiones de mantenimiento son candidatas;
- qué `MaintenanceRevision` se selecciona;
- qué Evidence pertenece al estado efectivo;
- qué período se utiliza;
- qué reglas de regeneración aplican.

Esas decisiones pertenecen a Reporting y a los ADR/OPEN correspondientes.

Este ADR no resuelve `ADR-0011` ni ningún `RPT-OPEN-*`.

---

# 26. Reporting sin IA

Se garantiza como regla arquitectónica:

> **IA es una mejora opcional del flujo de redacción, no una dependencia estructural de Reporting.**

Si:

- IA está deshabilitada;
- el tenant no dispone de capacidad comercial suficiente;
- el proveedor está indisponible;
- la operación falla;
- el resultado es inutilizable;
- el usuario decide descartar la sugerencia;

Reporting debe conservar la capacidad funcional aprobada de preparar y finalizar informes manualmente, salvo otras reglas independientes de Reporting.

Un fallo de IA no invalida por sí mismo un Report ni una `ReportVersion`.

---

# 27. AI disabled

`COMPANY_ADMIN` puede desactivar IA para su empresa conforme a la baseline.

Si la capacidad se encuentra deshabilitada según el estado autoritativo, una nueva operación iniciada por usuario no debe invocar al proveedor.

Este ADR no define:

- setting físico;
- columna;
- toggle UI;
- cache;
- propagación;
- semántica de una operación ya en curso cuando la configuración cambia.

`AI-OPEN-004` permanece abierta.

---

# 28. `AIUsageOperation`

Se preserva el concepto `AIUsageOperation` como operación tenant-owned de asistencia IA.

La frontera de IA debe permitir correlacionar conceptualmente:

- intención funcional;
- actor;
- tenant;
- contexto de Reporting;
- invocación técnica;
- resultado o fallo;
- retry de la misma intención;
- nueva generación deliberada;
- efecto comercial que deberá determinarse posteriormente.

Esta correlación es necesaria para que el subsistema de créditos pueda aplicar más adelante una semántica coherente de settlement.

Este ADR no define:

- schema de `AIUsageOperation`;
- estados físicos;
- tablas;
- columnas;
- enums;
- claves;
- idempotency keys comerciales;
- relación física con ledger.

Tampoco resuelve `DM-OPEN-007`, `AI-OPEN-*` ni `ADR-0006`.

---

# 29. Créditos y separación del ledger

Se preservan las reglas aprobadas:

- los créditos pertenecen al tenant;
- una operación IA tiene coste conforme a la baseline comercial;
- fallos deben poder compensarse o revertirse según la política que se apruebe;
- una nueva generación deliberada puede producir nuevo consumo;
- Subscription y AI credits permanecen separados;
- `COMPANY_ADMIN` puede deshabilitar IA.

Sin embargo, este ADR no decide:

- ledger schema;
- debit timing;
- reservation;
- settlement;
- consume/release;
- compensation mechanism;
- grants;
- admin adjustments;
- package pricing;
- balance calculation;
- equivalencias crédito/token;
- equivalencias crédito/moneda;
- idempotency keys comerciales.

Esas decisiones pertenecen principalmente a `ADR-0006` y a sus OPEN dependientes.

La frontera de IA sólo exige correlación suficiente para no impedir ese diseño posterior.

---

# 30. Subscription y entitlement

Subscription, AI credits y AI enabled/disabled son preocupaciones relacionadas pero distintas.

Este ADR no convierte Subscription en un mecanismo implícito de autorización IA ni define por sí mismo el comportamiento completo durante suspensión comercial.

Las precondiciones comerciales deberán aplicarse conforme a las decisiones aprobadas de Subscription & Payments y AI Credits.

Este ADR no resuelve:

- `ADR-0014`;
- `PAY-OPEN-*`;
- comportamiento exacto de operaciones en curso durante suspensión;
- reglas exactas de compra de créditos.

---

# 31. Idempotencia y retries

`ADR-0005 = ACCEPTED` permanece vigente.

La integración IA debe distinguir conceptualmente entre:

- **retry técnico de la misma intención:** repetición necesaria por timeout, respuesta perdida u otro fallo de transporte/ejecución;
- **nueva generación deliberada:** nueva intención editorial iniciada conscientemente por el usuario.

Un retry técnico no debe transformarse accidentalmente en una nueva intención facturable sólo porque se repita la invocación técnica.

La correlación con `AIUsageOperation` debe permitir reconocer esta diferencia.

Este ADR no define:

- retry count;
- provider retry policy;
- timeout;
- backoff;
- queue;
- worker;
- circuit breaker;
- settlement económico del retry.

---

# 32. Errores del proveedor

La arquitectura debe poder distinguir conceptualmente al menos tres clases generales de resultado sin fijar taxonomía física.

## 32.1 Error técnico

Ejemplos generales:

- timeout;
- indisponibilidad;
- respuesta inválida;
- fallo transitorio.

## 32.2 Rechazo o resultado inutilizable

Puede existir una respuesta externa que técnicamente haya sido devuelta pero no sea adecuada para incorporarse al Report.

La existencia de output no obliga a aceptarlo.

## 32.3 Fallo funcional/comercial interno

Ejemplos conceptuales:

- actor no autorizado;
- IA deshabilitada;
- precondición comercial no satisfecha conforme a las reglas vigentes.

Estos fallos deben resolverse antes de invocar al proveedor cuando sean detectables internamente.

Este ADR no fija códigos HTTP, estados físicos ni compensaciones de créditos.

---

# 33. Streaming

Este ADR no decide si una futura implementación utiliza:

- respuesta completa;
- streaming;
- SSE;
- WebSocket;
- chunked HTTP;
- otro mecanismo equivalente.

Si se adopta streaming en el futuro, deberá preservar las mismas invariantes:

- secretos no expuestos;
- autorización previa;
- tenant isolation;
- correlación con `AIUsageOperation`;
- parciales no oficiales;
- revisión humana obligatoria;
- ausencia de acciones autónomas.

La existencia de streaming no puede convertir tokens parciales en contenido oficial automáticamente.

---

# 34. Retención y privacidad

`DO-T07` permanece `DIFERIDO`.

`AI-OPEN-005 — retención de input/output/metadata` permanece `ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

Este ADR establece únicamente principios compatibles con una futura política:

- minimizar antes de enviar;
- no enviar datos innecesarios;
- no convertir provider payloads completos en requisito de persistencia arquitectónica por defecto;
- no conservar secretos en contenido de dominio;
- diseñar la implementación futura de manera que una política legal/privacidad posterior pueda aplicarse sin romper la frontera.

Este ADR no decide:

- días de retención;
- zero data retention contractual;
- políticas concretas del proveedor;
- borrado automático;
- residencia de datos;
- DPA;
- términos legales;
- opt-out contractual;
- retención exacta de logs;
- política comercial de conservación.

Los controles técnicos derivados de futuras decisiones legales podrán documentarse en `ADR-0018` cuando corresponda.

---

# 35. Logging y observabilidad

La futura implementación necesita observabilidad suficiente para diagnosticar operaciones sin convertir logs en una copia indiscriminada del contexto IA.

Debe evitarse conceptualmente registrar innecesariamente:

- prompts completos;
- respuestas completas;
- datos sensibles;
- provider credentials;
- tokens;
- URLs privadas;
- contenido cross-tenant.

Al mismo tiempo, este ADR no prohíbe observabilidad.

La implementación futura debería poder distinguir conceptualmente, cuando corresponda:

- operación solicitada;
- autorización rechazada;
- provider invocation;
- éxito/fallo;
- retry;
- correlación con `AIUsageOperation`;
- provider/model técnico utilizado cuando resulte operacionalmente necesario;
- latencia y coste técnico cuando se definan posteriormente.

Este ADR no define:

- vendor de observabilidad;
- métricas exactas;
- SLO;
- thresholds;
- formato de logs;
- política de retención.

`DO-T05` y `ADR-0016` permanecen diferidos.

---

# 36. Performance y disponibilidad

La IA es una dependencia remota.

Por lo tanto:

- puede introducir latencia;
- puede fallar;
- puede experimentar indisponibilidad;
- puede imponer límites externos;
- su degradación no debe destruir el flujo manual de Reporting.

Este ADR no decide:

- timeout;
- retry count;
- concurrency;
- queue;
- worker;
- rate limits;
- cache;
- circuit breaker;
- SLO;
- throughput objetivo.

Estas decisiones pertenecen a implementación y a futuras decisiones de performance/observabilidad.

---

# 37. Data implications

La decisión implica conceptualmente que:

- `AIUsageOperation` es tenant-owned;
- el contexto IA deriva de datos previamente autorizados;
- el contexto se minimiza antes de abandonar la aplicación;
- una provider request es una representación técnica efímera o de infraestructura, no un modelo de dominio;
- la provider response debe normalizarse antes de ingresar al flujo de aplicación;
- la salida IA no es fuente de verdad técnica;
- el texto revisado/aceptado puede incorporarse posteriormente al contenido semántico de Reporting;
- `ReportDocumentModel` recibe contenido semántico ya aprobado, no provider output crudo como autoridad;
- metadata técnica del proveedor no debe contaminar innecesariamente las entidades de Reporting.

Este ADR no diseña:

- tablas;
- columnas;
- foreign keys;
- indexes;
- JSON schema;
- prompt schema;
- response schema;
- token ledger;
- retention tables.

---

# 38. Security implications

La frontera adoptada reduce superficie de ataque, pero introduce responsabilidades server-side claras.

## 38.1 API keys y secretos

Las credenciales permanecen server-side y no deben exponerse al cliente.

## 38.2 Frontend no confiable

Toda solicitud originada en browser/PWA se valida en servidor.

## 38.3 Tenant spoofing

El tenant efectivo no se deriva de una afirmación del frontend.

## 38.4 Cross-tenant context leak

El contexto IA debe construirse únicamente con datos del tenant y scope autorizados.

## 38.5 Prompt injection

El contenido capturado por usuarios debe tratarse como no confiable y no adquirir privilegios.

## 38.6 Provider output no confiable

La respuesta no ejecuta acciones ni modifica dominio sin intervención del flujo interno autorizado.

## 38.7 Secret leakage

Prompts, logs, errores y payloads no deben incluir secretos de plataforma.

## 38.8 Over-sharing

La minimización es obligatoria antes de enviar contexto.

## 38.9 Logs sensibles

La observabilidad debe evitar copiar indiscriminadamente prompts, respuestas o datos sensibles.

## 38.10 Replay y retry

La correlación de operación debe evitar confundir un retry con una nueva intención.

## 38.11 Abuso de operaciones IA

La invocación requiere autorización server-side y precondiciones aplicables; el proveedor no es una API pública directa del browser.

## 38.12 AI disabled

Una nueva invocación de usuario no debe avanzar al proveedor cuando la capacidad esté deshabilitada según estado autoritativo.

## 38.13 Créditos y entitlement

Las precondiciones comerciales se delegan a las decisiones correspondientes. Esta frontera no inventa settlement ni reglas de Subscription.

Este apartado no constituye un threat model exhaustivo.

---

# 39. Testing implications

La futura implementación deberá demostrar conceptualmente, mediante pruebas apropiadas, al menos las siguientes propiedades.

## 39.1 Frontera cliente/proveedor

- el browser no puede obtener provider credentials de plataforma;
- el browser no necesita llamar directamente al proveedor para usar la capacidad aprobada;
- secretos no aparecen en payloads cliente.

## 39.2 Autorización

- una operación no autorizada es rechazada antes de invocar al proveedor;
- `TECHNICIAN` no obtiene IA de Reporting por inferencia;
- un `COMPANY_ADMIN` autorizado puede solicitar asistencia conforme a precondiciones aplicables;
- IA deshabilitada bloquea nuevas invocaciones iniciadas por usuario.

## 39.3 Tenancy

- Tenant A nunca envía contexto de Tenant B;
- IDs manipulados no permiten mezclar contexto cross-tenant;
- un `tenant_id` del frontend no determina el tenant efectivo.

## 39.4 Minimización

- el contexto enviado excluye identificadores internos innecesarios;
- no se envían fotografías ni archivos para análisis IA en el MVP;
- datos personales o metadata no necesarios quedan fuera del contexto.

## 39.5 Human-in-the-loop

- provider output no finaliza Report;
- provider output no asigna número oficial;
- provider output no selecciona `MaintenanceRevision`;
- provider output no selecciona Evidence;
- provider output requiere revisión humana antes de convertirse en contenido editorial aprobado.

## 39.6 Reporting

- Reporting funciona sin IA;
- un fallo del proveedor no destruye ni invalida automáticamente un Report;
- texto IA revisado y aceptado puede incorporarse al contenido semántico previo a `ReportDocumentModel`;
- el renderer no depende del proveedor de IA.

## 39.7 Idempotencia

- un retry técnico mantiene correlación con la misma intención lógica;
- una nueva generación deliberada se distingue del retry;
- retry/replay no evade autorización ni tenancy.

## 39.8 Contenido no confiable

- contenido malicioso incluido como datos no redefine instrucciones autoritativas de tenancy o autorización;
- provider output no concede permisos ni ejecuta acciones.

## 39.9 Portabilidad

- sustituir el adapter/proveedor en pruebas no obliga a modificar reglas de negocio de Reporting;
- contratos físicos del proveedor no aparecen como dependencias obligatorias del dominio.

Este ADR no define tests ejecutables, frameworks ni fixtures físicos.

---

# 40. Alternatives

## 40.1 Alternativa A — Browser/PWA llama directamente al proveedor IA

### Descripción

El navegador o la PWA integra directamente el proveedor externo y realiza las invocaciones desde el cliente.

### Ventajas

- menor cantidad aparente de lógica server-side;
- integración inicial aparentemente rápida para prototipos.

### Desventajas

- exposición o distribución indebida de secretos;
- dificultad para imponer autorización autoritativa;
- riesgo de tenant spoofing o contexto cross-tenant;
- bypass de controles comerciales;
- mayor dificultad para correlacionar `AIUsageOperation` y créditos;
- mayor riesgo de abuso;
- acoplamiento frontend-proveedor;
- dificultad de aplicar minimización centralizada;
- mayor riesgo de filtración de payloads.

### Evaluación

**Rechazada.**

Contradice la baseline server-side y las fronteras de confianza aprobadas.

---

## 40.2 Alternativa B — Server-side directo, pero Reporting acoplado al SDK/API del proveedor

### Descripción

Las invocaciones ocurren en servidor, pero los casos de uso y reglas de Reporting utilizan directamente objetos, estados y contratos físicos del SDK/API externo.

### Ventajas

- menor abstracción inicial;
- acceso inmediato a capacidades propietarias del proveedor.

### Desventajas

- contratos externos contaminan el dominio;
- testing del dominio queda ligado al proveedor;
- cambios de SDK/API pueden propagarse ampliamente;
- reemplazo futuro del proveedor se vuelve costoso;
- response shapes e IDs externos pueden filtrarse a Reporting;
- aumenta el riesgo de convertir conceptos técnicos en conceptos de negocio.

### Evaluación

**Rechazada como arquitectura base.**

La aplicación puede usar un SDK dentro del adapter futuro, pero el dominio no debe depender de él.

---

## 40.3 Alternativa C — Server-side + provider boundary + minimización

### Descripción

Toda invocación se realiza server-side mediante una frontera interna que normaliza la interacción con el proveedor y recibe únicamente contexto autorizado/minimizado.

### Ventajas

- secretos fuera del cliente;
- autorización centralizada;
- tenant isolation preservado;
- minimización aplicable de forma consistente;
- menor acoplamiento al proveedor;
- mejor testabilidad;
- mejor separación entre dominio e infraestructura;
- correlación compatible con `AIUsageOperation` y settlement futuro;
- proveedor sustituible con menor impacto;
- human-in-the-loop preservado;
- Reporting continúa siendo funcional sin IA.

### Desventajas

- requiere una frontera/adaptador adicional;
- requiere normalizar errores y resultados;
- exige mapping entre necesidades internas y contrato físico externo;
- concentra más responsabilidad en server-side.

### Evaluación

**Elegida.**

---

## 40.4 Alternativa D — Servicio/microservicio IA independiente desde el MVP

### Descripción

Crear un deployable separado dedicado a IA desde el inicio.

### Ventajas potenciales

- aislamiento operacional específico;
- capacidad futura de escalar independientemente si existiera una necesidad real.

### Desventajas actuales

- complejidad operacional adicional;
- autenticación/autorización entre servicios;
- nuevas fronteras de red;
- observabilidad distribuida;
- despliegues adicionales;
- riesgo de duplicar lógica de tenancy;
- contradice el principio de no introducir microservicios sin necesidad demostrada.

### Evaluación

**No seleccionada.**

`ADR-0001` mantiene un monolito modular y un deployable principal inicial. Si en el futuro existe una necesidad demostrada de extracción, deberá documentarse mediante una nueva decisión arquitectónica.

---

## 40.5 Alternativa E — IA genera/finaliza Reports automáticamente

### Descripción

Permitir que el proveedor genere contenido oficial, seleccione información o finalice Reports sin revisión humana obligatoria.

### Ventajas aparentes

- mayor automatización;
- menor intervención humana.

### Desventajas

- contradice la baseline funcional;
- elimina el human-in-the-loop obligatorio;
- convierte output no confiable en autoridad;
- puede introducir errores factuales como contenido oficial;
- mezcla IA con selección de históricos y reglas de Reporting;
- rompe la frontera de `ADR-0012`;
- aumenta riesgo operativo y de seguridad.

### Evaluación

**Rechazada.**

---

# 41. Consequences

## 41.1 Consecuencias positivas

La decisión aceptada aporta:

- provider credentials fuera del cliente;
- server-side authorization centralizada;
- tenant isolation preservado;
- minimización de datos como invariante;
- menor riesgo de exposición de contexto;
- desacoplamiento entre Reporting y proveedor;
- independencia frente al SDK/API concreto;
- testabilidad mediante frontera interna;
- posibilidad futura de cambiar proveedor con menor impacto;
- normalización de resultados y errores antes de entrar al dominio;
- integración compatible con el futuro ledger sin resolverlo prematuramente;
- mantenimiento de IA como capacidad opcional;
- preservación del human-in-the-loop;
- renderer independiente de IA;
- posibilidad de aplicar futuras políticas de privacidad sin contaminar el dominio con provider payloads físicos.

## 41.2 Consecuencias negativas

La decisión aceptada introduce:

- una frontera/adaptador adicional que deberá mantenerse;
- mapping entre contrato interno y proveedor;
- normalización de errores y resultados;
- mayor responsabilidad server-side;
- necesidad de pruebas contractuales de infraestructura con el proveedor;
- necesidad de equilibrar observabilidad y minimización;
- trabajo futuro para definir retención y privacidad;
- potencial divergencia entre capacidades de distintos proveedores;
- trabajo adicional si en el futuro se adopta streaming;
- necesidad de preservar correlación entre ejecución técnica y `AIUsageOperation`.

Estas consecuencias se aceptan conceptualmente porque protegen seguridad, mantenibilidad y portabilidad sin introducir infraestructura distribuida prematuramente.

---

# 42. Anti-patrones prohibidos por esta decisión

No debe adoptarse como arquitectura base:

- exponer provider credentials al browser/PWA;
- guardar provider credentials en IndexedDB;
- llamar directamente al proveedor desde el cliente;
- confiar en `tenant_id` enviado por frontend;
- construir provider requests mezclando datos de tenants distintos;
- usar provider context como autoridad de ownership;
- permitir que el proveedor decida permisos;
- usar objetos del SDK como objetos de dominio de Reporting;
- copiar response shapes del proveedor como contrato interno estable;
- enviar todo el historial disponible por conveniencia;
- enviar IDs internos innecesarios;
- enviar fotografías al modelo en el MVP;
- tratar contenido de usuario como instrucciones privilegiadas;
- tratar provider output como verdad técnica;
- insertar provider output directamente como contenido oficial sin revisión;
- permitir que IA finalice Reports;
- permitir que IA seleccione `MaintenanceRevision` o Evidence;
- hacer que el renderer dependa del proveedor;
- hacer que Reporting deje de funcionar cuando IA falla;
- persistir payloads completos del proveedor como requisito arquitectónico por defecto;
- resolver settlement de créditos dentro de esta frontera;
- introducir un microservicio IA sin una necesidad demostrada y nueva decisión aprobada.

---

# 43. Decisiones abiertas preservadas

Este ADR no resuelve ninguna decisión abierta.

Permanecen expresamente sin resolver:

- `AI-OPEN-001` — política de costo y visibilidad previa;
- `AI-OPEN-002` — respuesta parcial o inválida;
- `AI-OPEN-003` — cancelación de operación IA en curso;
- `AI-OPEN-004` — operación en curso al deshabilitar IA;
- `AI-OPEN-005` — retención de input/output/metadata;
- `AI-OPEN-006` — paquetes, expiración y origen comercial de créditos;
- `AI-OPEN-007` — grants y ajustes administrativos excepcionales;
- `AI-OPEN-008` — detalle de historial visible a `COMPANY_ADMIN`.

Todas permanecen con su estado vigente:

`ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`.

También permanecen sin resolver:

- `DM-OPEN-007`;
- `DO-T01`;
- `DO-T07`;
- `RPT-OPEN-*`;
- `EVID-OPEN-*`;
- cualquier otra decisión `DO-*` o `*-OPEN-*` existente.

`DO-T07` continúa `DIFERIDO`.

La existencia de estas decisiones abiertas puede afectar settlement, retención, metadata, disponibilidad comercial o flujos específicos, pero no cambia la decisión base aceptada de:

- server-side only;
- provider boundary;
- minimización;
- human-in-the-loop.

---

# 44. Dependencies

## 44.1 Depende de

Esta decisión depende de la baseline aprobada `00..10` y, especialmente, de:

- `ADR-0001 = ACCEPTED`;
- `ADR-0002 = ACCEPTED`;
- `ADR-0012 = ACCEPTED`.

Se relaciona además con:

- `ADR-0005 = ACCEPTED` para idempotencia/retries;
- `ADR-0009 = ACCEPTED` para históricos de Maintenance.

## 44.2 No depende para su decisión base de resolver

- `DO-T01`;
- `DO-T07`;
- `AI-OPEN-001..008`;
- `DM-OPEN-007`;
- `RPT-OPEN-*`;
- `EVID-OPEN-*`.

Estas decisiones pueden modificar detalles posteriores de settlement, retención, disponibilidad comercial, metadata y flujos específicos, pero no alteran la frontera arquitectónica aceptada.

## 44.3 Se relaciona con / condiciona

- `ADR-0006` — ledger de créditos IA y settlement de `AIUsageOperation`;
- `ADR-0011` — Reporting: versionado, snapshots y finalización;
- `ADR-0014` — Subscription lifecycle y commercial entitlement;
- `ADR-0018` — controles técnicos derivados de privacidad/legal cuando corresponda.

Este ADR no resuelve ninguno de ellos.

---

# 45. No decidido por este ADR

Quedan expresamente fuera de la decisión:

- modelo concreto;
- proveedor alternativo;
- multi-provider routing;
- failover;
- SDK;
- endpoint;
- HTTP contract;
- interfaces TypeScript;
- DTOs;
- JSON schema;
- prompt templates;
- system prompts;
- temperature;
- top_p;
- max tokens;
- reasoning effort;
- streaming;
- SSE;
- WebSocket;
- retry count;
- timeout;
- rate limit;
- queue;
- worker;
- cache;
- circuit breaker;
- tablas;
- SQL;
- migrations;
- RLS;
- secret manager;
- environment variable names;
- token prices;
- credit settlement;
- reservation/debit/compensation;
- retention days;
- provider retention policy;
- DPA;
- residency;
- embeddings;
- RAG;
- vector database;
- agents;
- tools/functions autónomos;
- vision/image AI;
- predictive AI;
- autonomous actions.

---

# 46. References

Referencias normativas y conceptuales:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- `docs/product/07-reporting-engine-spec.md`;
- `docs/product/08-ai-credits-spec.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`;
- `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`;
- `docs/architecture/adr/ADR-0009-maintenance-revision-history.md`;
- `docs/architecture/adr/ADR-0012-report-document-model-renderers.md`.

La inclusión de estas referencias no convierte en resueltas decisiones abiertas contenidas en ellas.

---

# 47. Supersession

`Supersedes: None`

`Superseded by: None`

---

# 48. Gate del ADR

## 48.1 Resultado

- **ADR generado:** `ADR-0013`;
- **Title:** `IA server-side, provider boundary y minimización de datos`;
- **Status:** `ACCEPTED`;
- **decisión:** AI server-side + provider boundary + minimización de datos;
- **AI scope MVP:** asistencia de redacción de Reports;
- **actor funcional AI Reporting:** `COMPANY_ADMIN`;
- **TECHNICIAN AI Reporting:** no;
- **browser llama directamente al provider:** no;
- **provider secrets en cliente:** no;
- **provider boundary interna:** sí;
- **dominio acoplado al SDK OpenAI:** no;
- **tenant isolation:** preservado;
- **minimización de datos:** obligatoria;
- **human review:** obligatoria;
- **AI output autoritativo:** no;
- **AI finaliza Report:** no;
- **AI selecciona MaintenanceRevision:** no;
- **AI selecciona Evidence:** no;
- **AI genera PDF oficial directamente:** no;
- **Reporting funciona sin AI:** sí;
- **AI imágenes MVP:** no;
- **provider/model concreto decidido:** no;
- **prompts concretos decididos:** no;
- **ledger/settlement resuelto:** no;
- **ADR-0006 resuelto:** no;
- **DO-T07 resuelta:** no;
- **AI-OPEN resueltos:** ninguno;
- **otros OPEN resueltos:** ninguno;
- **código:** no;
- **SQL:** no;
- **tablas:** no;
- **implementación autorizada:** no;
- **otro ADR generado:** no;
- **aprobación:** completada;
- **Estado de Fase 0:** **EN CURSO**.

## 48.2 Alcance del Gate

Este Gate verifica que `ADR-0013` ha sido aprobado formalmente dentro del alcance documentado.

La aceptación arquitectónica aprueba únicamente:

- AI server-side only;
- provider credentials sólo server-side;
- provider boundary interna;
- desacoplamiento del SDK/API física del proveedor;
- minimización obligatoria;
- tenant isolation y autorización previa;
- human-in-the-loop y AI output no autoritativo;
- IA limitada a asistencia editorial de Reporting en el MVP;
- `COMPANY_ADMIN` como actor funcional aprobado;
- Reporting funcional sin IA;
- integración del texto AI revisado antes de `ReportDocumentModel`;
- renderer independiente del provider;
- correlación conceptual con `AIUsageOperation`.

La aceptación no autoriza implementación ni resuelve decisiones fuera del alcance de este ADR.

Después de esta aprobación:

- `ADR-0013` permanece `ACCEPTED`;
- ningún `AI-OPEN-*` queda resuelto;
- ningún otro `DO-*` o `*-OPEN-*` queda resuelto por este ADR;
- `ADR-0006` permanece sin resolver;
- `DO-T01` permanece pendiente;
- `DO-T07` permanece diferido;
- Fase 0 permanece **EN CURSO**.
