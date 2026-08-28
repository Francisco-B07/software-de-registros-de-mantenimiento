# 11 — Alcance y Gate de entrada de Fase 1

> **Ruta normativa:** `docs/product/11-phase-1-scope-entry-gate.md`  
> **Estado:** **APROBADO — alcance y Gate de entrada de Fase 1**  
> **Fase:** Fase 1 — definición de alcance y Gate de entrada  
> **Estado de Fase 0:** **COMPLETADA**  
> **Naturaleza:** definición documental del alcance, límites, Gate de entrada y Gate de salida de Fase 1; **NO constituye implementación, código, SQL, migrations, diseño de schema físico ni inicio de Fase 2**

---

# 1. Estado previo

La Fase 0 documental y arquitectónica se encuentra formalmente cerrada.

El registro canónico:

`docs/product/10-architecture-decisions-records.md`

declara:

`Estado de Fase 0: COMPLETADA`

La revisión final del Gate de Fase 0 confirma que:

- los documentos `00..10` están aprobados;
- los seis ADR requeridos por el Gate fueron creados, revisados y aprobados;
- no existe actualmente una decisión `DO-*` o `*-OPEN-*` cuyo deadline sea anterior a Fase 1;
- no quedan bloqueos documentales de Fase 0;
- no existen contradicciones materiales conocidas que impidan iniciar Fase 1;
- las decisiones y ADR con deadlines posteriores permanecen abiertos, bloqueados o diferidos según corresponda y no deben adelantarse.

Los seis ADR aceptados que cerraron el Gate de Fase 0 son:

- `ADR-0001 — Arquitectura modular del SaaS en Next.js` = `ACCEPTED`;
- `ADR-0002 — Multi-tenancy, tenant ownership y aislamiento` = `ACCEPTED`;
- `ADR-0005 — Protocolo de sincronización, idempotencia y conflictos` = `ACCEPTED`;
- `ADR-0009 — Modelo de MaintenanceRevision e histórico de mantenimiento` = `ACCEPTED`;
- `ADR-0012 — ReportDocumentModel y renderizadores PDF/DOCX` = `ACCEPTED`;
- `ADR-0013 — IA server-side, provider boundary y minimización de datos` = `ACCEPTED`.

La incorporación del cierre de Fase 0 en `main`, declarada como commiteada y sincronizada, satisface la condición documental previa para iniciar Fase 1. Inmediatamente antes de la generación de este Gate se verificó mediante `git status` que el repositorio se encontraba en branch `main`, sincronizado con `origin/main` y con resultado `nothing to commit, working tree clean`; por tanto, la condición de limpieza del worktree está satisfecha para el Gate actual. Independientemente de esta verificación, `git status` debe volver a ejecutarse como preflight operativo inmediatamente antes de la primera tarea de implementación, sin asumir que el estado actual garantiza que el worktree continuará limpio posteriormente.

Este documento queda **APROBADO** como definición del alcance, Gate de entrada y Gate de salida de Fase 1. Su incorporación formal al repositorio en la ruta normativa `docs/product/11-phase-1-scope-entry-gate.md` permanece como paso operativo previo a comenzar implementación, sin convertir decisiones de fases posteriores en trabajo de Fase 1.

---

# 2. Fuentes normativas

La definición de Fase 1 se deriva exclusivamente del baseline vigente y de los ADR aceptados.

## 2.1 Product

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/04-offline-sync-strategy.md`
- `docs/product/05-form-engine-spec.md`
- `docs/product/06-maintenance-evidence-spec.md`
- `docs/product/07-reporting-engine-spec.md`
- `docs/product/08-ai-credits-spec.md`
- `docs/product/09-subscription-payments-spec.md`
- `docs/product/10-architecture-decisions-records.md`

## 2.2 ADR aceptados revisados

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`
- `docs/architecture/adr/ADR-0009-maintenance-revision-history.md`
- `docs/architecture/adr/ADR-0012-report-document-model-renderers.md`
- `docs/architecture/adr/ADR-0013-ai-server-side-provider-boundary.md`

## 2.3 Orden de autoridad aplicado

Se conserva el orden aprobado por el baseline:

1. decisiones explícitamente aprobadas posteriormente que modifiquen una decisión previa y no hayan sido sustituidas;
2. `01-product-definition.md` como baseline normativa de producto;
3. documentos derivados `02..09` dentro de su bounded context;
4. `00-master-product-brief.md` como fuente consolidada anterior;
5. ADR aceptados como decisiones arquitectónicas dentro de su alcance, sin convertir `OPEN` en decisiones aprobadas.

No se utiliza conocimiento genérico de ciclos de desarrollo para ampliar el alcance de Fase 1.

---

# 3. Definición de Fase 1

## 3.1 Nombre

La documentación sí contiene un nombre literal para Fase 1.

**Nombre normativo:**

`Fase 1 — Setup, repositorio, CI y Supabase local`

No se propone un nombre alternativo porque `00-master-product-brief.md` define expresamente el orden del proyecto y asigna ese nombre al hito 1.

## 3.2 Posición en el orden del proyecto

El orden aprobado es:

- Fase 0: definición completa del producto y documentos maestros;
- **Fase 1: Setup, repositorio, CI y Supabase local**;
- Fase 2: Multitenancy, autenticación, roles y RLS;
- Fase 3: Clientes, ubicaciones, tipos de equipos y equipos;
- Fase 4: Constructor y versionado de formularios;
- Fase 5: Registros de mantenimiento, evidencias y offline-first;
- Fase 6: Motor de informes PDF/DOCX sin IA;
- Fase 7: IA para informes y créditos;
- Fase 8: Mercado Pago, suscripciones y compra de créditos;
- Fase 9: Notificaciones push;
- Fase 10: Dashboard;
- Fase 11: QA, hardening, performance y piloto.

Esta secuencia constituye la frontera principal para evitar que Fase 1 absorba trabajo perteneciente a módulos posteriores.

## 3.3 Propósito de Fase 1

El propósito de Fase 1 es **materializar la base técnica y operativa mínima sobre la que podrán implementarse después los módulos del producto**, respetando desde el primer cambio las decisiones arquitectónicas globales ya aceptadas.

Fase 1 debe preparar:

- el proyecto/aplicación Next.js previsto por la baseline;
- el entorno de desarrollo reproducible;
- TypeScript estricto y tooling base;
- una estructura inicial compatible con el monolito modular de `ADR-0001`;
- CI para comprobar la salud básica del repositorio;
- el baseline reproducible de Supabase para Development aprobado por `CORR-002`;
- documentación y comandos mínimos para que el desarrollo posterior sea repetible y verificable.

Fase 1 **no tiene como propósito implementar un bounded context funcional del producto**.

## 3.4 Resultado esperado

Al finalizar Fase 1 debe existir una base de desarrollo que pueda ser usada para comenzar Fase 2 sin rehacer el setup fundamental, y que:

- pueda instalarse y ejecutarse de forma reproducible;
- compile con TypeScript estricto;
- respete el marco de monolito modular;
- tenga checks automáticos básicos de calidad;
- disponga de Supabase CLI fijada, `supabase/` inicializado y `supabase/config.toml` versionado para Development;
- no contenga schema físico de producto adelantado;
- no contenga migrations de dominio adelantadas;
- no implemente autenticación, multitenancy funcional, roles o RLS de Fase 2;
- no implemente capacidades de Fase 3+.

---

# 4. Objetivos

Los objetivos de Fase 1, derivados del nombre normativo y de las restricciones arquitectónicas aprobadas, son:

1. **Establecer el baseline ejecutable del repositorio/aplicación** con Next.js, React y TypeScript estricto conforme al stack aprobado.
2. **Materializar un skeleton modular inicial** compatible con `ADR-0001`, sin convertir una organización de carpetas inicial en una taxonomía arquitectónica irreversible.
3. **Configurar la infraestructura de desarrollo** necesaria para instalar, ejecutar, validar y construir el proyecto.
4. **Configurar CI** para ejecutar los checks básicos que el método de trabajo del proyecto exige desde las primeras tareas.
5. **Configurar el baseline Supabase de Development** aprobado por `CORR-002`, sin diseñar el modelo físico de datos ni integrar todavía la aplicación.
6. **Establecer gobernanza técnica básica** para que las futuras tareas de Codex sean pequeñas, verificables, documentadas y compatibles con el baseline.
7. **Conservar la frontera de fases**, evitando implementar por anticipado cualquier capacidad cuyo ADR, `DO` u `OPEN` tenga deadline posterior.

---

# 5. Dentro de alcance

## 5.1 Configuración inicial

En Fase 1 entra la configuración necesaria para que el proyecto pueda desarrollarse y verificarse de forma reproducible.

Incluye conceptualmente:

- bootstrap de la aplicación Next.js prevista por la baseline;
- App Router, porque forma parte del stack arquitectónico aceptado;
- React y TypeScript;
- TypeScript en modo estricto;
- Tailwind CSS como parte del stack aprobado;
- definición de scripts/comandos básicos de desarrollo, build y verificación;
- configuración de variables de entorno de desarrollo mediante placeholders seguros y documentación, sin secretos reales en el repositorio;
- configuración base del package manager/toolchain que el repositorio adopte;
- configuración mínima para mantener secretos fuera del cliente y fuera del control de versiones.

Los documentos no fijan versiones concretas de runtimes, paquetes o herramientas. La selección concreta necesaria para hacer ejecutable el setup es una decisión de implementación de Fase 1 mientras sea compatible con el stack aprobado y no introduzca una decisión arquitectónica material no documentada.

## 5.2 Arquitectura base

Entra la materialización inicial de la decisión aceptada en `ADR-0001`:

- un único proyecto/aplicación Next.js;
- un único deployable principal inicial;
- monolito modular;
- separación conceptual entre presentation/UI, application/use cases, domain/business rules e infrastructure/external adapters;
- fronteras internas reconocibles;
- dependencias comprensibles;
- prevención de acoplamiento arbitrario y dependencias circulares;
- ubicación clara para futuras integraciones detrás de fronteras internas.

Fase 1 puede crear un **skeleton físico inicial** que permita expresar esas fronteras, pero no debe presentar una estructura inicial de carpetas como una decisión final que `ADR-0001` no hizo.

## 5.3 Infraestructura de desarrollo

Entra:

- instalación/configuración del entorno local requerido para desarrollar la aplicación;
- scripts de bootstrap y verificación cuando sean necesarios;
- configuración de linting;
- configuración de typecheck;
- configuración de un mecanismo de tests base;
- configuración de build verificable;
- documentación mínima de desarrollo local;
- comprobaciones para evitar que secretos se incorporen al cliente o al repositorio.

La elección exacta de herramientas no está normativamente fijada por `00..10`; por tanto, Fase 1 puede seleccionar detalles técnicos menores y reversibles, pero no debe convertir una preferencia de tooling en una nueva regla de producto.

## 5.4 Skeleton del proyecto

Entra un skeleton mínimo que demuestre que la base técnica funciona.

Puede incluir:

- estructura inicial de la aplicación;
- layout/shell técnico mínimo;
- módulos o directorios vacíos/mínimos suficientes para reflejar la modularidad aprobada;
- convenciones de importación/dependencias internas cuando sean necesarias para preservar límites;
- una superficie mínima de smoke/health de la aplicación si se utiliza únicamente para probar el setup.

No entra:

- UI funcional de administración;
- pantallas de autenticación de producto;
- gestión de tenants;
- CRUD de clientes/equipos;
- constructor de formularios;
- mantenimiento;
- evidence;
- reporting;
- IA;
- pagos;
- dashboard;
- notificaciones.

## 5.5 Baseline Supabase de Development

El nombre normativo de Fase 1 conserva literalmente `Supabase local` por trazabilidad histórica. `TASK-005` queda como antecedente histórico; `CORR-002` reemplaza su método operativo por Supabase Cloud Development y `CORR-003` sincroniza este Gate con esa corrección.

Por tanto, entra exclusivamente:

- declarar en el repositorio una versión fijada y reproducible de Supabase CLI;
- inicializar `supabase/` y versionar `supabase/config.toml`;
- mantener temporales, sesiones y credenciales fuera de Git;
- disponer de exactamente un proyecto Supabase Cloud exclusivo de Development, creado manualmente por Francisco;
- documentar que `login`, `link` y toda operación remota son manuales y responsabilidad de Francisco;
- verificar localmente la presencia y configuración del baseline sin requerir Docker ni ejecutar un ciclo local `start/status/stop`.

Codex no recibe credenciales ni acceso remoto. `db push` no es requisito de Fase 1. Tampoco entran integración de la aplicación, cliente Supabase, variables de conexión, schema, migrations, SQL, RLS, Auth, tenancy, Storage, Realtime, `service-role`, Staging ni Production.

## 5.6 Decisiones físicas permitidas

Fase 1 puede tomar decisiones físicas **sólo sobre el setup y la organización técnica base**, por ejemplo:

- organización inicial de carpetas;
- convenciones de módulos;
- configuración de TypeScript;
- configuración de lint/build/test;
- scripts de desarrollo;
- configuración reproducible de Supabase CLI y `supabase/config.toml` conforme a `CORR-002`;
- contrato de variables de entorno;
- configuración de CI;
- archivos de configuración necesarios para el toolchain.

Estas decisiones deben ser:

- compatibles con `ADR-0001`;
- simples y reversibles cuando sea razonable;
- no contradictorias con `ADR-0002` y demás ADR aceptados;
- incapaces de resolver silenciosamente un `DO-*` o `*-OPEN-*`;
- incapaces de fijar schema físico de dominio por anticipado.

No se permite en Fase 1 decidir físicamente:

- tablas;
- columnas;
- PK/FK;
- índices;
- constraints de dominio;
- policies RLS;
- funciones PostgreSQL;
- triggers;
- schemas PostgreSQL de producto;
- schema Dexie;
- buckets/paths de Evidence;
- modelo físico de Reporting;
- ledger físico IA;
- state machine física de pagos.

## 5.7 Documentación necesaria

Entra documentación operativa mínima para que el setup sea mantenible, por ejemplo:

- instrucciones de desarrollo local;
- cómo ejecutar lint/typecheck/tests/build;
- cómo verificar el baseline Supabase de Development y su frontera de operaciones remotas manuales, sin credenciales;
- variables de entorno requeridas sin secretos;
- convenciones de estructura modular adoptadas para el skeleton;
- actualización de `AGENTS.md` cuando corresponda para que Codex conozca las reglas vigentes del proyecto;
- registro de cualquier decisión arquitectónica material nueva sólo si realmente surgiera una necesidad que cumpla el criterio de ADR.

No entra reescribir los documentos normativos `00..10` ni modificar ADR aceptados para acomodar el setup.

## 5.8 Testing y governance inicial

Entra establecer una baseline mínima de verificación desde Fase 1.

Debe permitir que las tareas posteriores puedan ejecutar, según corresponda:

- lint;
- typecheck;
- tests relacionados;
- build/smoke de la aplicación;
- verificación del entorno local.

El objetivo no es ejecutar el hardening/performance/piloto de Fase 11. Fase 11 no elimina la obligación de probar cada tarea desde el inicio; representa la fase posterior de QA integral, hardening, performance y piloto.

También entra mantener la disciplina de implementación aprobada:

- una tarea `TASK-###` a la vez;
- tamaño PR;
- alcance cerrado;
- requisitos y criterios de aceptación explícitos;
- pruebas explícitas;
- revisión posterior de arquitectura, seguridad y regresiones;
- no resolver silenciosamente `DO`/`OPEN`;
- no avanzar de fase sin Gate.

---

# 6. Fuera de alcance

Fase 1 no implementa capacidades de producto posteriores aunque existan invariantes generales ya conocidas o ADR transversales ya aceptados.

## 6.1 Fase 2 — Multitenancy, autenticación, roles y RLS

Debe esperar:

- implementación de autenticación funcional;
- alta/verificación de usuarios;
- `PlatformUser` físico;
- `CompanyMembership` físico;
- roles funcionales;
- `UserClientAccess` físico;
- `SupportAccessGrant` físico;
- invalidación efectiva de sesiones;
- autorización de aplicación;
- policies RLS de producto;
- lógica de tenant resolution operativa;
- implementación de soporte excepcional.

Aunque `ADR-0002` está `ACCEPTED`, no autoriza por sí solo el diseño físico ni la implementación de autorización completa.

`DO-T03 = RESUELTO/APROBADO` y ya no constituye un blocker de `ADR-0003`. `ADR-0003 = ACCEPTED`; el requisito arquitectónico de aceptación previa a la implementación de identidad/autorización de Fase 2 está cumplido. Esta aceptación no autoriza por sí sola la implementación ni implica que el Gate de entrada a Fase 2 haya sido evaluado o satisfecho.

## 6.2 Fase 3 — Clientes, ubicaciones y equipos

Debe esperar:

- schema y CRUD de `Client`;
- jerarquía física de `Location`;
- `EquipmentType`;
- `Equipment`;
- decisiones relacionadas con `DM-OPEN-001` cuando correspondan.

No se debe crear en Fase 1 un schema “base” que silenciosamente materialice estas entidades.

## 6.3 Fase 4 — Form Engine

Debe esperar:

- implementación de `FormTemplate`;
- `FormVersion`;
- drafts/published;
- builder;
- campos;
- tablas/matrices;
- repeatables;
- condiciones;
- aplicabilidad de formularios;
- publicación/versionado físico.

`ADR-0008` permanece `BLOCKED BY OPEN DECISIONS` y debe aprobarse antes de Fase 4.

No se permite adelantar Form Engine alegando que `published immutable` ya es una invariante conocida.

## 6.4 Fase 5 — Maintenance, Evidence y Offline-first

Debe esperar:

- `MaintenanceRecord` físico;
- `MaintenanceRevision` físico;
- respuestas;
- ejecución/finalización de mantenimiento;
- correcciones;
- Evidence;
- visual replacement;
- Service Worker funcional para offline-first;
- Dexie/IndexedDB operativo;
- `LocalReplica`;
- outbox física;
- sync engine;
- conflict UI;
- políticas de réplica por identidad;
- protección local;
- schema Dexie;
- uploads/storage de Evidence.

Aunque `ADR-0005` y `ADR-0009` están `ACCEPTED`, no autorizan implementación en Fase 1.

Antes de Fase 5 deben quedar resueltos/aprobados, según el registro:

- `ADR-0004`;
- `ADR-0005`;
- `ADR-0009`;
- `ADR-0010`.

`ADR-0004` y `ADR-0010` continúan bloqueados por decisiones abiertas.

## 6.5 Fase 6 — Reporting

Debe esperar:

- `Report`;
- `ReportVersion`;
- `ReportSnapshot`;
- report drafts;
- numeración oficial;
- `ReportTemplate` físico;
- construcción efectiva de `ReportDocumentModel`;
- renderer PDF;
- renderer DOCX;
- Storage de documentos;
- flujo UI de Reporting.

`ADR-0012` está `ACCEPTED`, pero eso no autoriza implementar Reporting en Fase 1.

Antes de Fase 6:

- `ADR-0011` debe estar aprobado;
- `ADR-0012` debe estar aprobado;
- `DO-077` debe estar aprobado para la implementación DOCX.

## 6.6 Fase 7 — IA y créditos

Debe esperar:

- integración productiva con proveedor IA;
- prompts productivos;
- `AIUsageOperation` físico;
- wallet/ledger físico;
- settlement;
- reservas/consumos/liberaciones/compensaciones;
- políticas de costo;
- UI de créditos IA.

`ADR-0013` está `ACCEPTED`, pero sólo establece la frontera arquitectónica server-side/provider/minimización.

Antes de Fase 7 debe estar aprobado `ADR-0006`, que permanece bloqueado por `DO-T01` y decisiones AI/DM relacionadas.

## 6.7 Fase 8 — Subscription & Payments

Debe esperar:

- integración Mercado Pago;
- checkout;
- webhooks/handlers productivos;
- `PaymentEvent` físico;
- state machine comercial;
- subscription entitlement físico;
- ciclo promo/paid/grace/inactive/reactivation;
- pricing versionado;
- compra de créditos.

Antes de Fase 8 deben estar aprobados:

- `ADR-0014`;
- `ADR-0007`;
- `ADR-0015`;
- decisiones comerciales IA necesarias para compras.

También deben resolverse las decisiones `DO-076`, `DO-078`, `DO-T02` y `PAY-OPEN-*` aplicables conforme a sus deadlines.

## 6.8 Fases 9, 10 y 11

Debe esperar:

- Fase 9: notificaciones push; `DO-073` debe resolverse antes;
- Fase 10: dashboard; `DO-074` debe resolverse antes;
- Fase 11: QA integral, hardening, performance y piloto; `DO-T05` y `ADR-0016` se resuelven antes de pruebas de performance/piloto conforme al Gate.

## 6.9 ADR diferidos

No se adelantan en Fase 1:

- `ADR-0016 — Observabilidad, capacidad y performance`;
- `ADR-0017 — Backup, restore, RPO y RTO`;
- `ADR-0018 — Controles técnicos derivados de privacidad/legal`.

Sus dependencias (`DO-T05`, `DO-T06`, `DO-T07`) permanecen legítimamente diferidas.

---

# 7. Estado de decisiones abiertas

## 7.1 Resultado general

La expectativa del Gate de Fase 0 se confirma:

> **ninguna decisión abierta bloquea el inicio de Fase 1.**

No se cierra, aprueba ni modifica ninguna decisión en este documento.

## 7.2 `DM-OPEN-*`

Permanecen abiertas conforme al baseline:

- `DM-OPEN-001`: resolver antes de la implementación relevante de Fase 3;
- `DM-OPEN-002`: antes de Fase 4;
- `DM-OPEN-003`: antes de Fase 4 y necesariamente antes de Fase 5;
- `DM-OPEN-004`: antes de Fase 4;
- `DM-OPEN-005`: antes de Fase 6;
- `DM-OPEN-006`: antes de Fase 6;
- `DM-OPEN-007`: antes de Fase 7;
- `DM-OPEN-008`: antes de Fase 6.

Ninguna bloquea Fase 1.

## 7.3 `FORM-OPEN-*`

`FORM-OPEN-001..008` permanecen abiertas con sus estados vigentes.

Sus deadlines se concentran en Fase 4 y, para captura/offline cuando corresponda, antes de Fase 5.

Ninguna bloquea Fase 1.

## 7.4 `EVID-OPEN-*`

`EVID-OPEN-001..006` permanecen:

`ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`

Deben resolverse antes de la implementación relevante de Fase 5.

Ninguna bloquea Fase 1.

## 7.5 `RPT-OPEN-*`

`RPT-OPEN-001..012` permanecen:

`ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`

Deben resolverse antes de la implementación de Reporting en Fase 6 conforme a sus dependencias.

Ninguna bloquea Fase 1.

## 7.6 `AI-OPEN-*`

`AI-OPEN-001..008` permanecen abiertas con sus estados vigentes.

Las decisiones necesarias para IA/créditos deben resolverse antes de Fase 7; `AI-OPEN-006` además condiciona decisiones comerciales de Fase 8.

Ninguna bloquea Fase 1.

## 7.7 `PAY-OPEN-*`

`PAY-OPEN-001..008` permanecen:

`ABIERTA — PROPUESTA PENDIENTE DE APROBACIÓN`

Deben resolverse antes de Fase 8 conforme a sus deadlines.

Ninguna bloquea Fase 1.

## 7.8 `OFF-OPEN-*`

Permanecen:

- `OFF-OPEN-001 = ABIERTO — pendiente de aprobación`;
- `OFF-OPEN-002 = ABIERTO — pendiente de aprobación`.

Deben resolverse antes de la implementación offline relevante de Fase 5.

Ninguna bloquea Fase 1.

## 7.9 Otras decisiones `DO-*`

Se preservan:

- `DO-073 = DIFERIDA` — antes de Fase 9;
- `DO-074 = DIFERIDA` — antes de Fase 10;
- `DO-075 = RESUELTA/APROBADA`;
- `DO-076 = PROPUESTA PENDIENTE DE APROBACIÓN` — antes de Fase 8;
- `DO-077 = PENDIENTE DE APROBACIÓN` — antes de Fase 6 para DOCX;
- `DO-078 = PROPUESTA PENDIENTE DE APROBACIÓN` — antes de Fase 8;
- `DO-T01 = PROPUESTA PENDIENTE DE APROBACIÓN` — antes de Fase 7;
- `DO-T02 = PROPUESTA PENDIENTE DE APROBACIÓN` — antes de Fase 8;
- `DO-T03 = RESUELTO/APROBADO` — resuelta antes de Fase 2 para autorización/sesión y coordinación offline antes de Fase 5;
- `DO-T04 = PROPUESTA PENDIENTE DE APROBACIÓN` — antes de Fase 5;
- `DO-T05 = DIFERIDO` — antes de pruebas de performance/Fase 11/piloto;
- `DO-T06 = DIFERIDO` — antes de piloto/producción;
- `DO-T07 = DIFERIDO` — antes del piloto conforme a validación legal/contractual.

`DO-T03 = RESUELTO/APROBADO` y ya no constituye una decisión abierta ni un blocker de `ADR-0003`. `ADR-0003 = ACCEPTED`, por lo que el requisito arquitectónico de aceptación de ADR-0003 está cumplido. El Gate de entrada a Fase 2 fue evaluado formalmente y satisfecho mediante decisión humana separada: `Gate de entrada a Fase 2 evaluado = SÍ` y `Gate de entrada a Fase 2 satisfecho = SÍ`. El inicio formal de Fase 2 fue aprobado y revisado mediante decisión humana separada: `PHASE 2 FORMAL START = APPROVED` y `PHASE 2 FORMAL START HUMAN REVIEW = APPROVED`; por tanto, `Fase 2 = INICIADA`. `TASK-008` fue canonicalizada, implementada, incorporada a Git y aprobada en revisión humana final; por tanto, `TASK-008 = COMPLETADA`. Su resultado técnico se limita a `Supabase application boundary = IMPLEMENTADA`, `Browser factory = IMPLEMENTADA` y `Server factory no privilegiada = IMPLEMENTADA`.

`TASK-009` fue canonicalizada, implementada, aplicada y probada en Supabase Cloud Development, incorporada a Git y aprobada mediante cierre humano final; por tanto, `TASK-009 = COMPLETADA`. Materializó exclusivamente la foundation física mínima de identity/tenant: `MaintenanceCompany físico = SÍ`, `PlatformUser físico = SÍ`, `Auth subject → PlatformUser físico = SÍ` y `CompanyMembership físico = SÍ`. El estado técnico activo se limita a `Schema mínimo TASK-009 = IMPLEMENTADO`, `Migration TASK-009 = IMPLEMENTADA`, `SQL funcional del slice TASK-009 = SÍ` y `RLS TASK-009 = IMPLEMENTADA Y PROBADA EN DEVELOPMENT`.

`TASK-010` fue canonicalizada, implementada, aplicada y probada en Supabase Cloud Development, incorporada a Git y aprobada mediante cierre humano final; por tanto, `TASK-010 = COMPLETADA`. Materializó exclusivamente `AuditEvent foundation física = SÍ`, `Migration TASK-010 = IMPLEMENTADA`, `SQL test TASK-010 = PRESENTE Y PROBADO EN DEVELOPMENT` y `Static test TASK-010 = PRESENTE`. El estado técnico cerrado mantiene `RLS sobre audit_events = HABILITADA`, `application policies sobre audit_events = 0`, privilegios de tabla de `anon` y `authenticated` en `NONE`, `authenticated TRUNCATE audit_events = DENIED`, `Development Gate TASK-010 = PASS` y `fixtures TASK-010 restantes = 0`.

`TASK-011` fue canonicalizada, implementada, incorporada a Git y aprobada mediante cierre humano final; por tanto, `TASK-011 = COMPLETADA`. Su resultado técnico fue exclusivamente `Auth SSR lifecycle foundation = IMPLEMENTADA`, `SSR cookie propagation boundary = IMPLEMENTADA` y `Auth Proxy technical boundary = IMPLEMENTADA`.

Continúan `Auth funcional = NO`, `Auth SSR lifecycle completo = NO`, `Refresh funcional de access token = NO`, `Proxy/middleware Auth funcional = NO`, `Authorization ready = NO`, `VerificationChallenge = NO`, `UserClientAccess = NO`, `SupportAccessGrant = NO`, `Application authorization completa = NO`, `Client = NO`, `Storage = NO`, `Realtime = NO`, `UI = NO`, `Offline = NO` y `auditoría funcional completa = NO`. `AuditEvent foundation física = SÍ` no equivale a auditoría funcional completa ni a flows productores implementados; `Productores funcionales de AuditEvent = NO`. `TASK-011 completada` no equivale a `TASK-012 autorizada automáticamente` ni a `TASK-012 determinada`; `TASK-012 generada = NO`, `TASK-012 determinada = NO` y `Siguiente TASK autorizada automáticamente = NO`.

---

# 8. ADR requeridos

## 8.1 Deadline directo de Fase 1

El registro maestro establece expresamente:

| Hito | Requisito arquitectónico |
|---|---|
| Antes de Fase 1 | `ADR-0001` + Gate documental de Fase 0 cerrado |
| Antes de Fase 2 | `ADR-0002` + `ADR-0003` |

Por tanto:

> **`ADR-0001` es el único ADR cuyo deadline directo es “Antes de Fase 1”, además del cierre del Gate documental de Fase 0.**

`ADR-0001` está `ACCEPTED` y Fase 0 está `COMPLETADA`.

## 8.2 ADR aceptados adicionales

Los otros cinco ADR aceptados requeridos para cerrar Fase 0 no se convierten por ello en nuevos requisitos directos de Fase 1.

- `ADR-0002` ya está `ACCEPTED` y además será requisito de Fase 2;
- `ADR-0005` y `ADR-0009` tienen deadline antes de Fase 5;
- `ADR-0012` tiene deadline antes de Fase 6;
- `ADR-0013` tiene deadline antes de Fase 7.

Sus invariantes deben respetarse si el setup toca fronteras relevantes, pero no autorizan implementar anticipadamente los módulos a los que pertenecen.

## 8.3 ADR no requeridos todavía

No se inventa ningún ADR nuevo para Fase 1.

Permanecen fuera del Gate directo de Fase 1:

- `ADR-0003`;
- `ADR-0004`;
- `ADR-0006`;
- `ADR-0007`;
- `ADR-0008`;
- `ADR-0010`;
- `ADR-0011`;
- `ADR-0014`;
- `ADR-0015`;
- `ADR-0016`;
- `ADR-0017`;
- `ADR-0018`.

---

# 9. Matriz de acciones permitidas / no permitidas

La clasificación siguiente corresponde al **Gate de Fase 1 formalmente aprobado**. Este documento no ejecuta ninguna acción y su implementación queda condicionada a su incorporación formal al repositorio y al preflight operativo correspondiente.

| Acción | Clasificación | Razón normativa |
|---|---|---|
| Inicializar la aplicación Next.js dentro del repositorio existente | **PERMITIDO EN FASE 1** | Fase 1 es literalmente “Setup, repositorio, CI y Supabase local”; Fase 0 exigía no inicializar Next.js hasta cerrar su Gate, condición ya satisfecha. |
| Re-inicializar Git o sustituir la historia del repositorio | **NO PERMITIDO TODAVÍA** | El repositorio ya existe y contiene la baseline canónica; Fase 1 permite setup del repositorio, no destruir/recrear su historia ni alterar documentación aprobada por conveniencia. |
| Configurar Next.js/App Router | **PERMITIDO EN FASE 1** | App Router forma parte del stack aprobado y `ADR-0001` adopta una única aplicación Next.js. |
| Configurar TypeScript estricto | **PERMITIDO EN FASE 1** | TypeScript estricto es una regla explícita del proyecto. |
| Configurar Tailwind CSS base | **PERMITIDO EN FASE 1** | Forma parte del stack aprobado; no implica funcionalidad de dominio. |
| Instalar/configurar tooling base de lint, typecheck, tests y build | **PERMITIDO EN FASE 1** | Fase 1 incluye setup/CI y el método de trabajo exige esos checks después de las implementaciones. |
| Configurar CI | **PERMITIDO EN FASE 1** | `CI` forma parte literal del nombre de Fase 1. El proveedor concreto no está fijado por la baseline. |
| Crear skeleton modular inicial | **PERMITIDO EN FASE 1** | Materializa `ADR-0001` sin implementar módulos de negocio; la estructura física inicial no debe presentarse como taxonomía final obligatoria. |
| Configurar variables de entorno y placeholders seguros | **PERMITIDO EN FASE 1** | Necesario para setup; secretos no deben exponerse ni versionarse. |
| Configurar el baseline Supabase de Development conforme a `CORR-002` | **PERMITIDO EN FASE 1** | El nombre normativo conserva `Supabase local`, pero `CORR-002` reemplaza el método operativo por CLI/configuración reproducible y un proyecto Cloud exclusivo de Development. |
| Integrar o verificar conectividad de la app con Supabase durante este Gate | **NO PERMITIDO TODAVÍA** | El baseline aprobado no incluye cliente Supabase, variables de conexión ni integración de la aplicación. |
| Inicializar/configurar Supabase Auth funcional para usuarios del producto | **NO PERMITIDO TODAVÍA** | Autenticación funcional, roles y autorización pertenecen a Fase 2. `TASK-009 = COMPLETADA`, pero implementó exclusivamente la foundation física mínima de identity/tenant y RLS del slice; `Auth funcional = NO`, `Auth SSR lifecycle completo = NO` y `Authorization ready = NO`. Cualquier implementación de Auth requiere otra tarea formalmente especificada, revisada, aprobada, canonicalizada cuando corresponda y autorizada de forma separada para ejecución. |
| Crear migrations de producto | **NO PERMITIDO TODAVÍA** | Fase 1 no contiene diseño físico de dominio; Fase 2+ implementan los bounded contexts que requieren schema y RLS. |
| Crear una migration vacía sólo para “probar” el mecanismo | **NO PERMITIDO TODAVÍA** | No aporta una capacidad necesaria al setup y abriría prematuramente el flujo de schema/migrations de producto. La existencia de una carpeta generada por tooling no equivale a crear una migration de producto. |
| Diseñar schema PostgreSQL del SaaS | **NO PERMITIDO TODAVÍA** | `02`/`03` son conceptuales; `ADR-0002` no define tablas; Fase 2 inicia la primera capacidad que necesita diseño físico tenant/auth/RLS. |
| Diseñar policies RLS ejecutables | **NO PERMITIDO TODAVÍA** | RLS funcional pertenece a Fase 2 y debe respetar `ADR-0003`/`DO-T03` cuando corresponda. |
| Crear tablas de tenant/membership/client access | **NO PERMITIDO TODAVÍA** | Es implementación de Fase 2. |
| Diseñar buckets/paths de Storage | **NO PERMITIDO TODAVÍA** | No forma parte del setup; su ownership depende del dominio y de fases posteriores. |
| Configurar Dexie/IndexedDB operativo | **NO PERMITIDO TODAVÍA** | Offline-first se implementa en Fase 5 y `ADR-0004` continúa bloqueado. |
| Implementar Service Worker offline-first | **NO PERMITIDO TODAVÍA** | Pertenece a Fase 5; el setup no debe resolver offline anticipadamente. |
| Instalar/wirear OpenAI productivo | **NO PERMITIDO TODAVÍA** | IA pertenece a Fase 7; `ADR-0013` no autoriza implementación productiva. |
| Instalar/wirear Mercado Pago productivo | **NO PERMITIDO TODAVÍA** | Payments pertenece a Fase 8 y sus ADR/decisiones siguen pendientes. |
| Crear UI o dominio de clientes/equipos/forms/maintenance/reporting | **NO PERMITIDO TODAVÍA** | Son capacidades de Fases 3, 4, 5 y 6 respectivamente. |
| Usar Codex para implementar tareas PR-sized de setup después de aprobar este Gate | **PERMITIDO EN FASE 1** | El método aprobado define a Codex como implementador y exige tareas pequeñas/verificables después de definir alcance, criterios y pruebas. |
| Usar Codex en este paso para generar `TASK-001` o modificar el repositorio | **NO PERMITIDO TODAVÍA** | La aprobación documental no autoriza implementación inmediata: primero debe incorporarse formalmente este documento aprobado al repositorio y completarse el preflight operativo; además, `TASK-001` no se genera en este paso. |

## 9.1 Sobre “comenzar migrations”

La expresión “comenzar migrations” se clasifica como **NO PERMITIDO TODAVÍA** cuando significa crear migrations propias del producto o empezar a fijar schema.

Inicializar el baseline Supabase puede crear archivos/directorios de configuración requeridos por la herramienta, pero eso no autoriza introducir una migration de dominio, una tabla, una policy RLS o un schema físico adelantado.

## 9.2 Sobre “diseñar schema”

La clasificación es **NO PERMITIDO TODAVÍA**.

El modelo de dominio y la estrategia RLS aprobados son contratos conceptuales para un diseño físico posterior. No deben convertirse durante Fase 1 en una representación PostgreSQL concreta.

## 9.3 Sobre “usar Codex”

Normativamente, Codex puede participar en Fase 1 porque el método de trabajo lo define como implementador del repositorio una vez que existe una tarea pequeña, cerrada y verificable.

Este documento se encuentra `APROBADO — alcance y Gate de entrada de Fase 1`, pero su incorporación formal al repositorio y el preflight operativo correspondiente siguen siendo requisitos previos al primer uso de Codex.

Por tanto:

- **capacidad de usar Codex en Fase 1:** permitida;
- **uso inmediato de Codex en este paso:** no;
- **primer uso posible:** después de la incorporación formal de este documento aprobado al repositorio y del preflight correspondiente, mediante una única `TASK-###` PR-sized;
- `TASK-001` no se genera en este documento.

---

# 10. Frontera Fase 1 / Fase 2

## 10.1 Evento que marca el final funcional de Fase 1

Fase 1 termina cuando el setup aprobado está completo y verificable:

- aplicación base inicializada y ejecutable;
- configuración Next.js/TypeScript estricta establecida;
- skeleton modular compatible con `ADR-0001`;
- tooling base funcional;
- CI funcional;
- baseline Supabase de Development completo conforme a `CORR-002`, sin Docker ni ciclo de vida local;
- documentación de desarrollo suficiente;
- checks básicos pasando;
- ningún schema/migration/capacidad de Fase 2+ implementado por anticipado.

Ese evento cierra el trabajo propio de Fase 1.

## 10.2 Requisito para entrar en Fase 2

El registro maestro exige antes de Fase 2:

- `ADR-0002 = ACCEPTED`;
- `ADR-0003 = ACCEPTED`.

`ADR-0002` ya está `ACCEPTED`.

`DO-T03 = RESUELTO/APROBADO`.

`ADR-0003 = ACCEPTED`.

El requisito arquitectónico de aceptación de `ADR-0003` está cumplido.

La evaluación formal del Gate de entrada a Fase 2 fue realizada y revisada humanamente con resultado:

- `Gate de entrada a Fase 2 evaluado = SÍ`;
- `Gate de entrada a Fase 2 satisfecho = SÍ`.

El acto humano separado de inicio de Fase 2 fue realizado y revisado con resultado:

- `PHASE 2 FORMAL START = APPROVED`;
- `PHASE 2 FORMAL START HUMAN REVIEW = APPROVED`;
- `Fase 2 = INICIADA`.

Por tanto:

> **`TASK-011 = COMPLETADA` != `TASK-012 determinada` != `TASK-012 generada` != `TASK-012 autorizada`; `TASK-011 = COMPLETADA` != `Siguiente TASK autorizada automáticamente`.**

TASK-008 fue canonicalizada, implementada, incorporada a Git y aprobada en revisión humana final. Su resultado fue exclusivamente la frontera Supabase de aplicación con factories browser/server no privilegiadas.

TASK-009 fue especificada, aprobada, canonicalizada, implementada y aplicada en Supabase Cloud Development; superó el Gate remoto, las pruebas RLS/integridad y Auth delete preservation, fue incorporada a Git y obtuvo cierre humano final. Su resultado fue exclusivamente la foundation física mínima de identity/tenant —`MaintenanceCompany`, `PlatformUser`, `Auth subject → PlatformUser` y `CompanyMembership`—, una migration funcional y RLS mínima del slice probada en Development. No implementó Auth funcional, lifecycle Auth SSR completo, autorización funcional completa, `VerificationChallenge`, `UserClientAccess`, `SupportAccessGrant`, `AuditEvent`, `Client`, Storage, Realtime, UI ni Offline.

TASK-010 fue especificada, aprobada, canonicalizada, implementada y aplicada en Supabase Cloud Development; superó su Development Gate, las pruebas de integridad, RLS y privilegios, fue incorporada a Git y obtuvo cierre humano final. Su resultado fue exclusivamente la foundation física mínima de AuditEvent, con migration y pruebas, sin productores funcionales ni auditoría funcional completa. La determinación y especificación del siguiente incremento PR-sized de Fase 2 corresponde a un paso posterior separado. Toda implementación concreta continúa requiriendo especificación, revisión humana, aprobación, canonicalización cuando corresponda, autorización concreta, ejecución controlada y revisión posterior.

TASK-011 fue especificada, aprobada, canonicalizada, implementada, incorporada a Git y aprobada mediante cierre humano final. Su resultado fue exclusivamente `Auth SSR lifecycle foundation = IMPLEMENTADA`, `SSR cookie propagation boundary = IMPLEMENTADA` y `Auth Proxy technical boundary = IMPLEMENTADA`. No implementó Auth funcional, lifecycle Auth SSR completo, refresh funcional de access token, Proxy/middleware Auth funcional, autorización por ruta, tenant resolver, role resolver ni autorización funcional de aplicación.

Este documento:

- reconoce `DO-T03 = RESUELTO/APROBADO`;
- reconoce `ADR-0003 = ACCEPTED`;
- registra `Gate de entrada a Fase 2 evaluado = SÍ`;
- registra `Gate de entrada a Fase 2 satisfecho = SÍ`;
- registra `Fase 2 = INICIADA`;
- registra `TASK-008 canonicalizada = SÍ`;
- registra `TASK-008 implementada = SÍ`;
- registra `TASK-008 incorporada a Git = SÍ`;
- registra `TASK-008 revisión humana final = APROBADA`;
- registra `TASK-008 = COMPLETADA`;
- registra `TASK-009 especificada = SÍ`;
- registra `TASK-009 aprobada = SÍ`;
- registra `TASK-009 canonicalizada = SÍ`;
- registra `TASK-009 implementada = SÍ`;
- registra `TASK-009 aplicada en Development = SÍ`;
- registra `TASK-009 Gate remoto = PASS`;
- registra `TASK-009 pruebas RLS/integridad = PASS`;
- registra `TASK-009 Auth delete preservation = PASS`;
- registra `TASK-009 incorporada a Git = SÍ`;
- registra `TASK-009 cierre humano final = APROBADO`;
- registra `TASK-009 = COMPLETADA`;
- registra `TASK-010 especificada = SÍ`;
- registra `TASK-010 aprobada = SÍ`;
- registra `TASK-010 canonicalizada = SÍ`;
- registra `TASK-010 implementada = SÍ`;
- registra `TASK-010 aplicada en Development = SÍ`;
- registra `TASK-010 Development Gate = PASS`;
- registra `TASK-010 incorporada a Git = SÍ`;
- registra `TASK-010 cierre humano final = APROBADO`;
- registra `TASK-010 = COMPLETADA`;
- registra `TASK-011 incorporada a Git = SÍ`;
- registra `TASK-011 cierre humano final = APROBADO`;
- registra `TASK-011 = COMPLETADA`;
- mantiene `TASK-012 determinada = NO`;
- mantiene `TASK-012 generada = NO`;
- mantiene `TASK-012 autorizada = NO`;
- mantiene `Siguiente TASK autorizada automáticamente = NO`.

## 10.3 Separación entre cierre de Fase 1 y entrada a Fase 2

Puede ocurrir legítimamente que:

1. el setup técnico de Fase 1 esté completo;
2. Fase 1 pueda considerarse terminada en su propio alcance;
3. el proyecto permanezca detenido en el Gate de transición;
4. Fase 2 no comience hasta que `ADR-0003` esté `ACCEPTED`.

No debe utilizarse trabajo adicional de Fase 1 como excusa para implementar parcialmente autorización mientras el Gate de Fase 2 siga cerrado.

---

# 11. Entregables mínimos de Fase 1

Los siguientes entregables se proponen únicamente porque corresponden al alcance normativo `Setup, repositorio, CI y Supabase local` y a las reglas de arquitectura/gobernanza ya aprobadas.

## 11.1 Documento

- documentación de setup/desarrollo local;
- instrucciones para instalar/ejecutar/verificar el proyecto;
- documentación del baseline Supabase de Development y de la frontera operativa manual;
- contrato/documentación de variables de entorno sin secretos;
- nota de estructura modular inicial y límites de dependencia;
- `AGENTS.md` actualizado cuando corresponda para reflejar las reglas de implementación y lectura obligatoria de `/docs`.

## 11.2 Configuración

- configuración Next.js;
- configuración TypeScript estricta;
- configuración de estilos base aprobados por el stack;
- configuración de lint/typecheck/test/build;
- configuración segura de entorno;
- configuración de CI;
- configuración reproducible de Supabase CLI y `supabase/config.toml`.

## 11.3 Código

Sólo código de skeleton/setup necesario para que la aplicación:

- arranque;
- compile;
- se pueda construir;
- pueda ser verificada;
- exprese la modularidad base sin implementar dominio funcional.

No se incluyen entidades de negocio, CRUD, auth funcional ni reglas de fases posteriores.

## 11.4 Tests

- smoke test(s) del bootstrap cuando sean necesarios;
- prueba/check de que TypeScript estricto compila;
- lint;
- build;
- test runner ejecutable;
- checks suficientes para que CI detecte una rotura básica del setup.

No se incluyen suites funcionales de módulos que todavía no existen.

## 11.5 Infraestructura Supabase de Development

- versión fijada y reproducible de Supabase CLI en el repositorio;
- `supabase/` inicializado y `supabase/config.toml` versionado;
- temporales, sesiones y credenciales fuera de Git;
- exactamente un proyecto Supabase Cloud exclusivo de Development, creado y vinculado manualmente por Francisco;
- operaciones remotas manuales, sin credenciales ni acceso remoto para Codex;
- sin requisito de Docker, ciclo local `start/status/stop` ni `db push`;
- sin integración de aplicación, schema, migrations, SQL, RLS, Auth, tenancy, Storage, Realtime, `service-role`, Staging ni Production.

## 11.6 Governance

- Gate de Fase 1 formalmente aprobado antes de implementar;
- ramas/PR de alcance pequeño;
- una `TASK-###` a la vez;
- criterios de aceptación y pruebas por tarea;
- revisión arquitectónica y de seguridad tras cambios relevantes;
- protección contra scope creep hacia Fase 2+;
- repo/worktree limpio al iniciar cada tarea relevante;
- documentación actualizada cuando una decisión técnica material lo requiera.

---

# 12. Roles ChatGPT / Codex

## 12.1 ChatGPT

Durante Fase 1, ChatGPT debe continuar actuando como Product Architect, Principal/Staff Engineer, reviewer y Gate keeper.

### Como Product Architect

Debe:

- proteger el alcance de Fase 1;
- impedir que setup se convierta en implementación prematura de dominio;
- identificar cualquier intento de resolver silenciosamente una decisión `DO`/`OPEN`;
- mantener trazabilidad con `00..10`.

### Como Principal/Staff Engineer

Debe:

- definir antes de cada tarea el objetivo técnico concreto;
- revisar que la solución preserve el monolito modular de `ADR-0001`;
- evitar acoplamientos prematuros con módulos futuros;
- distinguir decisiones menores de setup de decisiones que realmente requieren ADR;
- revisar TypeScript estricto, fronteras server/client y manejo de secretos.

### Como reviewer

Después de cada implementación debe revisar, según corresponda:

- arquitectura;
- límites modulares;
- seguridad básica;
- exposición de secretos;
- regresiones;
- lint;
- typecheck;
- tests;
- build;
- coherencia documental;
- ausencia de schema/migrations/capacidades adelantadas.

### Como Gate keeper

Debe:

- no generar la siguiente tarea hasta validar la anterior;
- no permitir entrar en Fase 2 sólo porque Fase 1 compile;
- verificar `ADR-0003 = ACCEPTED` antes de autorizar implementación de identidad/autorización;
- exigir actualización documental si una decisión nueva modifica una regla previamente aprobada.

## 12.2 Codex

Codex puede comenzar a recibir tareas de implementación **sólo después de que este documento aprobado sea incorporado formalmente al repositorio y se complete el preflight operativo correspondiente**.

En Fase 1 sus tareas pueden cubrir exclusivamente:

- bootstrap de la aplicación;
- configuración del toolchain;
- configuración de TypeScript estricto;
- skeleton modular;
- CI;
- tests/smoke de setup;
- baseline Supabase de Development conforme a `CORR-002`;
- documentación operativa directamente asociada al setup.

Cada tarea futura debe:

- usar un único ID `TASK-###`;
- ser PR-sized;
- tener objetivo explícito;
- incluir contexto normativo;
- declarar alcance;
- declarar fuera de alcance;
- declarar cambios esperados;
- indicar impacto de seguridad/RLS, incluso cuando sea “no aplica todavía”;
- tener criterios de aceptación;
- tener pruebas;
- prohibir resolver silenciosamente decisiones abiertas;
- prohibir ampliar alcance hacia otra fase.

Codex no debe recibir todavía tareas para:

- schema;
- migrations;
- RLS;
- auth;
- tenancy funcional;
- Form Engine;
- Offline;
- Evidence;
- Reporting;
- IA;
- créditos;
- pagos;
- notificaciones;
- dashboard.

**`TASK-001` no se genera en este documento.**

---

# 13. GATE DE ENTRADA A FASE 1

## 13.1 Criterios

| Criterio | Estado | Evidencia / interpretación |
|---|---|---|
| Fase 0 completada | **CUMPLIDO** | `10-architecture-decisions-records.md` declara `Estado de Fase 0: COMPLETADA`. |
| Documentos `00..10` aprobados | **CUMPLIDO** | El Gate final de Fase 0 los declara aprobados documentalmente. |
| `ADR-0001 = ACCEPTED` | **CUMPLIDO** | Es el único ADR con deadline directo antes de Fase 1 y está aceptado. |
| Seis ADR requeridos por el Gate de Fase 0 aceptados | **CUMPLIDO** | `ADR-0001`, `0002`, `0005`, `0009`, `0012`, `0013` están `ACCEPTED`. |
| Cierre de Fase 0 incorporado al repositorio | **CUMPLIDO POR DECLARACIÓN DE ESTADO** | El inicio controlado parte de que el cierre está incorporado, commiteado y sincronizado en `main`. |
| Repositorio limpio antes del primer cambio | **CUMPLIDO** | El último `git status` verificado mostró branch `main`, sincronizado con `origin/main` y `nothing to commit, working tree clean`. Esta verificación satisface el Gate actual, pero debe repetirse como preflight operativo inmediatamente antes de `TASK-001`. |
| Ninguna decisión abierta bloquea Fase 1 | **CUMPLIDO** | El Gate de Fase 0 declara que ninguna `DM/FORM/EVID/RPT/AI/PAY/OFF OPEN` ni `DO-T03/T04` bloquea Fase 1. |
| No se adelantan capacidades de fases posteriores | **CUMPLIDO EN EL ALCANCE DEFINIDO** | Este documento excluye explícitamente schema, migrations y toda capacidad de Fase 2+. |
| No se genera tarea ni implementación en este paso | **CUMPLIDO** | Este documento sólo define alcance/Gates. |

## 13.2 Resultado

**GATE DE ENTRADA A FASE 1: APROBADO**

El resultado `APROBADO` significa:

- la baseline permite entrar en Fase 1;
- Fase 1 queda autorizada documentalmente por este documento aprobado;
- la implementación de Fase 1 puede comenzar únicamente después de que este documento aprobado sea incorporado formalmente al repositorio y se realice el preflight operativo correspondiente;
- la implementación queda limitada al alcance `Setup, repositorio, CI y Supabase local`;
- el primer cambio debe realizar un precheck de worktree limpio;
- no se habilita ninguna capacidad de Fase 2+;
- no se habilitan schema ni migrations de producto.

Este Gate y el documento están formalmente aprobados. La incorporación del contenido aprobado a su ruta normativa en el repositorio sigue siendo un paso operativo separado y previo a la implementación.

---

# 14. GATE DE SALIDA DE FASE 1

## 14.1 Condiciones para considerar completo el alcance propio de Fase 1

Fase 1 puede considerarse completada cuando se verifique conjuntamente:

1. la aplicación base definida por el stack aprobado está inicializada y arranca correctamente;
2. TypeScript estricto está activo y el proyecto supera typecheck;
3. el skeleton respeta `ADR-0001` y no introduce dependencias circulares o acoplamiento arbitrario evidente;
4. el proyecto dispone de lint, tests base y build verificables;
5. CI ejecuta los checks acordados para el baseline de Fase 1;
6. el baseline Supabase de Development cumple `CORR-002`: CLI fijada, `supabase/` inicializado, `supabase/config.toml` versionado y proyecto Cloud exclusivo de Development bajo operación manual de Francisco;
7. la configuración de entorno no expone secretos al cliente ni al repositorio;
8. la documentación mínima de desarrollo está actualizada;
9. no existen migrations/schema/policies RLS de producto introducidos prematuramente;
10. no existe funcionalidad de Fase 2+ adelantada;
11. las tareas implementadas fueron revisadas y sus pruebas quedaron registradas;
12. el repositorio queda en un estado coherente y verificable al cierre de la fase.

## 14.2 Condición adicional para cruzar hacia Fase 2

El Gate de salida técnica de Fase 1 no sustituye el Gate de entrada de Fase 2.

Antes de comenzar la implementación de Fase 2 debe verificarse además:

- `ADR-0002 = ACCEPTED` — ya cumplido;
- `DO-T03 = RESUELTO/APROBADO` — ya cumplido;
- `ADR-0003 = ACCEPTED` — ya cumplido.
- `Gate de entrada a Fase 2 evaluado = SÍ` — ya cumplido;
- `Gate de entrada a Fase 2 satisfecho = SÍ` — ya cumplido.

Por tanto, la salida de Fase 1, la satisfacción del Gate de entrada a Fase 2 y el inicio formal de Fase 2 son controles relacionados pero no idénticos.

**El Gate de entrada a Fase 2 está evaluado y satisfecho y el inicio formal de la fase fue aprobado y revisado mediante decisión humana separada: `Fase 2 = INICIADA`. `TASK-008 = COMPLETADA` e implementó exclusivamente `Supabase application boundary = IMPLEMENTADA`. `TASK-009 = COMPLETADA` y materializó exclusivamente `MaintenanceCompany físico = SÍ`, `PlatformUser físico = SÍ`, `Auth subject → PlatformUser físico = SÍ`, `CompanyMembership físico = SÍ`, `Schema mínimo TASK-009 = IMPLEMENTADO`, `Migration TASK-009 = IMPLEMENTADA`, `SQL funcional del slice TASK-009 = SÍ` y `RLS TASK-009 = IMPLEMENTADA Y PROBADA EN DEVELOPMENT`. `TASK-010 = COMPLETADA` y materializó exclusivamente `AuditEvent foundation física = SÍ`, `Migration TASK-010 = IMPLEMENTADA` y `RLS/privilegios TASK-010 = PROBADOS EN DEVELOPMENT`, sin productores funcionales. `TASK-011 = COMPLETADA` e implementó exclusivamente `Auth SSR lifecycle foundation = IMPLEMENTADA`, `SSR cookie propagation boundary = IMPLEMENTADA` y `Auth Proxy technical boundary = IMPLEMENTADA`. Continúan `Auth funcional = NO`, `Auth SSR lifecycle completo = NO`, `Refresh funcional de access token = NO`, `Proxy/middleware Auth funcional = NO`, `Authorization ready = NO`, `route authorization = NO`, `tenant resolver = NO`, `role resolver = NO`, `VerificationChallenge = NO`, `UserClientAccess = NO`, `SupportAccessGrant = NO`, `Application authorization completa = NO`, `Client = NO`, `Storage = NO`, `Realtime = NO`, `Offline = NO`, `Productores funcionales de AuditEvent = NO` y `auditoría funcional completa = NO`. `TASK-011 completada` no equivale a `TASK-012 autorizada automáticamente`; `TASK-012 determinada = NO`, `TASK-012 generada = NO` y `Siguiente TASK autorizada automáticamente = NO`.**

---

# 15. Orden propuesto de ejecución

La secuencia siguiente sólo debe ejecutarse después de la incorporación formal de este documento aprobado al repositorio y del preflight operativo correspondiente. Cada paso futuro puede transformarse posteriormente en una tarea `TASK-###` separada y verificable.

## Paso 1 — Preflight de repositorio y baseline

Verificar:

- branch/base correcta;
- worktree limpio;
- cierre de Fase 0 presente en `main`;
- docs y ADR relevantes accesibles;
- ausencia de cambios pendientes que puedan mezclarse con el setup.

No modificar todavía dominio ni base de datos.

## Paso 2 — Bootstrap de aplicación

Inicializar/configurar la aplicación Next.js del repositorio conforme al stack aprobado:

- App Router;
- React;
- TypeScript estricto;
- styling base aprobado.

El resultado debe ser únicamente una aplicación base ejecutable.

## Paso 3 — Tooling y comandos de calidad

Configurar el baseline de:

- lint;
- typecheck;
- tests;
- build;
- scripts de desarrollo.

No introducir tooling específico de módulos posteriores sin necesidad actual.

## Paso 4 — Skeleton modular

Materializar una estructura inicial compatible con `ADR-0001`:

- presentation/UI;
- application/use cases;
- domain/business rules;
- infrastructure/adapters;
- límites claros y dependencias comprensibles.

No implementar todavía bounded contexts funcionales.

## Paso 5 — Configuración de entorno y secretos

Definir el contrato técnico mínimo de variables de entorno y documentación de desarrollo:

- placeholders;
- archivos de ejemplo seguros;
- reglas para no versionar secretos;
- separación server/client cuando corresponda.

No añadir secretos reales ni integraciones productivas.

## Paso 6 — Supabase local

El título conserva el nombre histórico/normativo de la fase. Operativamente, este paso implementa el baseline de Supabase Cloud Development aprobado por `CORR-002`:

- versión fijada y reproducible de Supabase CLI en el repositorio;
- `supabase/` inicializado y `supabase/config.toml` versionado;
- temporales, sesiones y credenciales fuera de Git;
- exactamente un proyecto Cloud exclusivo de Development, creado y vinculado manualmente por Francisco;
- operaciones remotas manuales y sin acceso remoto ni credenciales para Codex;
- ausencia de requisito de Docker, ciclo local `start/status/stop` y `db push`.

No integrar la aplicación ni crear cliente Supabase, variables de conexión, schema, migrations, SQL, RLS, Auth, tenancy, Storage, Realtime, `service-role`, Staging o Production.

## Paso 7 — CI

Configurar CI para ejecutar el baseline de Fase 1:

- instalación reproducible;
- lint;
- typecheck;
- tests base;
- build u otros checks mínimos de setup que se aprueben en la tarea correspondiente.

No incluir pipelines de deploy, release o módulos futuros si no han sido requeridos por el alcance aprobado.

## Paso 8 — Smoke, documentación y revisión de Fase 1

Verificar:

- setup reproducible;
- aplicación ejecutable;
- baseline Supabase de Development verificado conforme a `CORR-002`;
- checks pasando;
- documentación suficiente;
- ausencia de secretos;
- ausencia de schema/migrations/capacidades adelantadas;
- coherencia con `ADR-0001`.

Con esa evidencia puede evaluarse el Gate de salida de Fase 1.

## Paso 9 — Preparar la frontera de Fase 2 sin implementarla

Sólo después de completar Fase 1:

- revisar el estado de `DO-T03`;
- realizar el proceso documental necesario para desbloquear `ADR-0003`;
- redactar/revisar/aprobar `ADR-0003` en un paso separado;
- evaluar el Gate de entrada de Fase 2.

Este paso no se ejecuta en el presente documento y no forma parte de una implementación de Fase 1.

---

# 16. Riesgos de adelantar decisiones

## `P1-RSK-001` — Convertir setup en Fase 2 encubierta

**Riesgo:** aprovechar la configuración de Supabase para empezar tablas, auth, roles o RLS.

**Control:** el baseline Supabase de Development en Fase 1 se limita a CLI/configuración reproducible y al proyecto Cloud bajo operación manual; la integración funcional de la aplicación permanece fuera de Fase 1, y schema y autorización esperan a Fase 2 y a `ADR-0003`.

## `P1-RSK-002` — Diseñar schema a partir del modelo conceptual

**Riesgo:** traducir `02-domain-model.md` directamente a tablas durante setup.

**Control:** el modelo conceptual no constituye diseño físico; Fase 1 prohíbe schema/migrations de producto.

## `P1-RSK-003` — Resolver `DO-T03` por implementación

**Riesgo:** elegir una mecánica de invalidación de sesiones dentro del bootstrap de auth.

**Control:** no existe auth funcional en Fase 1; `DO-T03` debe resolverse documentalmente antes de aprobar `ADR-0003`.

## `P1-RSK-004` — Fijar una estructura modular excesivamente rígida

**Riesgo:** interpretar `ADR-0001` como una taxonomía definitiva de carpetas o imponer abstractions sin necesidad.

**Control:** el skeleton debe ser mínimo y pragmático; las capas son conceptuales y no obligan a cuatro directorios rígidos ni DDD completo.

## `P1-RSK-005` — Acoplar módulos futuros por anticipado

**Riesgo:** instalar/configurar desde Fase 1 Dexie, OpenAI, Mercado Pago, renderizadores documentales o flujos de Evidence sin necesidad de setup.

**Control:** cada integración espera a su fase y ADR/dependencias correspondientes.

## `P1-RSK-006` — Usar ADR aceptado como autorización de implementación anticipada

**Riesgo:** interpretar `ADR-0005`, `ADR-0009`, `ADR-0012` o `ADR-0013` como permiso para implementar sus módulos en Fase 1.

**Control:** un ADR aceptado fija una decisión arquitectónica, no cambia el orden de fases ni resuelve decisiones abiertas de otros módulos.

## `P1-RSK-007` — CI insuficiente o demasiado amplia

**Riesgo:** no establecer checks básicos, o intentar construir desde Fase 1 una plataforma de QA/performance que pertenece a Fase 11.

**Control:** CI de Fase 1 cubre salud básica del repositorio; QA integral/performance permanece en su fase posterior.

## `P1-RSK-008` — Scope creep de Codex

**Riesgo:** una tarea de “setup” termine creando domain models físicos, auth, migrations o features.

**Control:** una `TASK-###` a la vez, PR-sized, con fuera de alcance explícito y revisión posterior antes de emitir la siguiente.

## `P1-RSK-009` — Empezar Fase 2 porque el setup ya funciona

**Riesgo:** confundir éxito técnico de Fase 1 con Gate de autorización de Fase 2.

**Control:** `ADR-0003` debe estar `ACCEPTED` antes de implementar Fase 2; `DO-T03` no se resuelve por inferencia.

## `P1-RSK-010` — Iniciar implementación antes de la incorporación formal

**Riesgo:** iniciar implementación basándose en el documento aprobado antes de que haya sido incorporado formalmente a su ruta normativa en el repositorio.

**Control:** el documento está aprobado, pero Codex no debe utilizarse hasta su incorporación formal al repositorio y la ejecución del preflight operativo correspondiente.

---

# 17. Resultado final

La revisión del baseline vigente determina que Fase 1 está definida normativamente como:

`Setup, repositorio, CI y Supabase local`

No existe ninguna decisión `DO-*` o `*-OPEN-*` que bloquee su inicio.

El único ADR con deadline directo antes de Fase 1 es `ADR-0001`, además del cierre documental de Fase 0. Ambos requisitos están satisfechos.

La existencia de otros ADR aceptados no amplía Fase 1: las capacidades de Fase 2+ conservan sus deadlines y bloqueos propios.

Con esta aprobación, Fase 1 queda autorizada documentalmente. La implementación limitada de Fase 1 podrá comenzar una vez que este documento aprobado sea incorporado formalmente al repositorio y se complete el preflight operativo correspondiente; a partir de entonces Codex podrá recibir una única tarea `TASK-###` PR-sized a la vez. Esa autorización comprende bootstrap/configuración, skeleton modular, CI, tooling base y el baseline Supabase de Development conforme a `CORR-002`; no comprende integración de la aplicación, schema, migrations, RLS, autenticación funcional ni ninguna capacidad de Fase 2+.

`DO-T03 = RESUELTO/APROBADO` y ya no constituye un blocker de `ADR-0003`. `ADR-0003 = ACCEPTED`, por lo que el requisito arquitectónico de aceptación previa a Fase 2 está cumplido. El Gate de entrada a Fase 2 fue evaluado formalmente y satisfecho mediante decisión humana separada: `Gate de entrada a Fase 2 evaluado = SÍ` y `Gate de entrada a Fase 2 satisfecho = SÍ`. El inicio formal de Fase 2 fue aprobado y revisado mediante decisión humana separada: `PHASE 2 FORMAL START = APPROVED`, `PHASE 2 FORMAL START HUMAN REVIEW = APPROVED` y `Fase 2 = INICIADA`. `TASK-008` fue canonicalizada, implementada, incorporada a Git y aprobada en revisión humana final; por tanto, `TASK-008 = COMPLETADA`. Su resultado técnico fue exclusivamente `Supabase application boundary = IMPLEMENTADA` con factories browser/server no privilegiadas.

`TASK-009` fue canonicalizada, implementada, aplicada y probada en Supabase Cloud Development, incorporada a Git y aprobada mediante cierre humano final; por tanto, `TASK-009 = COMPLETADA`. Su resultado técnico fue exclusivamente `MaintenanceCompany físico = SÍ`, `PlatformUser físico = SÍ`, `Auth subject → PlatformUser físico = SÍ`, `CompanyMembership físico = SÍ`, `Schema mínimo TASK-009 = IMPLEMENTADO`, `Migration TASK-009 = IMPLEMENTADA`, `SQL funcional del slice TASK-009 = SÍ` y `RLS TASK-009 = IMPLEMENTADA Y PROBADA EN DEVELOPMENT`.

`TASK-010` fue canonicalizada, implementada, aplicada y probada en Supabase Cloud Development, incorporada a Git y aprobada mediante cierre humano final; por tanto, `TASK-010 = COMPLETADA`. Su resultado técnico fue exclusivamente `AuditEvent foundation física = SÍ`, `Migration TASK-010 = IMPLEMENTADA`, `SQL test TASK-010 = PRESENTE Y PROBADO EN DEVELOPMENT`, `Static test TASK-010 = PRESENTE` y `RLS/privilegios TASK-010 = PROBADOS EN DEVELOPMENT`. No implementó productores de AuditEvent ni auditoría funcional completa.

`TASK-011` fue canonicalizada, implementada, incorporada a Git y aprobada mediante cierre humano final; por tanto, `TASK-011 = COMPLETADA`. Su resultado técnico fue exclusivamente `Auth SSR lifecycle foundation = IMPLEMENTADA`, `SSR cookie propagation boundary = IMPLEMENTADA` y `Auth Proxy technical boundary = IMPLEMENTADA`.

Continúan `Auth funcional = NO`, `Auth SSR lifecycle completo = NO`, `Refresh funcional de access token = NO`, `Proxy/middleware Auth funcional = NO`, `Authorization ready = NO`, `VerificationChallenge = NO`, `UserClientAccess = NO`, `SupportAccessGrant = NO`, `Application authorization completa = NO`, `Client = NO`, `Storage = NO`, `Realtime = NO`, `UI = NO`, `Offline = NO`, `Productores funcionales de AuditEvent = NO` y `auditoría funcional completa = NO`. `TASK-011 completada` no equivale a `TASK-012 autorizada automáticamente`; `TASK-012 determinada = NO`, `TASK-012 generada = NO` y `Siguiente TASK autorizada automáticamente = NO`.

---

**Fase 0: COMPLETADA**  
**Gate de entrada a Fase 1: APROBADO**  
**Implementación permitida en Fase 1: SÍ, una vez incorporado formalmente este documento aprobado al repositorio y realizado el preflight correspondiente, exclusivamente dentro de `Setup, repositorio, CI y Supabase local`; NO se permiten schema, migrations ni capacidades de Fase 2+**  
**Uso de Codex permitido: SÍ, después de la incorporación formal de este documento aprobado al repositorio y del preflight correspondiente, únicamente mediante una `TASK-###` PR-sized de Fase 1 a la vez; en este paso no se utiliza Codex**  
**TASK-001 generada: no**  
**Fase 1 completada: sí**
**Fase 2 iniciada: sí**
**TASK-008 completada: sí**
**TASK-009 completada: sí**
**TASK-010 completada: sí**
**TASK-011 completada: sí**
**TASK-012 determinada: no**
**TASK-012 generada: no**
**Siguiente TASK autorizada automáticamente: no**
