# 1. ID

`CORR-002`

**Ruta canónica futura:** `docs/tasks/CORR-002-supabase-cloud-development.md`

**Archivo de entrega:** `CORR-002-supabase-cloud-development-approved.md`

Este documento todavía no es canónico. Define una corrección previa a implementación y no modifica por sí mismo el repositorio ni el estado de `TASK-005`.

# 2. Título

`Supabase Cloud Development sin Docker y operación remota manual`

# 3. Tipo

`CORRECCIÓN TÉCNICA Y OPERATIVA DE ESTRATEGIA DE DESARROLLO`

La corrección afecta exclusivamente el método de ejecución del `Paso 6` de Fase 1 materializado por:

`docs/tasks/TASK-005-supabase-local.md`

No cambia el proveedor tecnológico aprobado, el modelo de producto, la arquitectura de aplicación, el modelo multiempresa ni las fronteras de fases.

# 4. Estado

`APPROVED FOR IMPLEMENTATION`

La corrección:

- está formalmente aprobada para implementación;
- autoriza la implementación corregida de `TASK-005` dentro del alcance y restricciones de este documento;
- el uso de Codex queda autorizado únicamente cuando se inicie operativamente esa implementación, sin ampliar sus permisos ni fronteras;
- no crea un proyecto Supabase;
- no ejecuta comandos Supabase;
- no modifica `TASK-005`;
- no modifica el repositorio;
- no genera `TASK-006`;
- no inicia Fase 2.

# 5. Motivo de la corrección

`TASK-005 — Baseline reproducible de Supabase local` fue aprobada para implementación y posteriormente intentada mediante Codex.

La ejecución terminó correctamente en:

`BLOCKER`

El bloqueo no se originó en un cambio de producto, una contradicción de arquitectura ni un error de la especificación de seguridad. Se originó en una restricción permanente del host de desarrollo: el equipo actual no dispone de un runtime Docker-compatible utilizable de forma razonable.

La estrategia original de `TASK-005` hacía de ese runtime una precondición obligatoria porque el ciclo `supabase start / status / stop` depende del stack local en contenedores. Mantener esa exigencia impediría continuar Fase 1 en el host real sin aportar valor funcional al producto.

La corrección sustituye esa dependencia operativa por:

`repositorio local + Supabase CLI reproducible + migrations versionadas + Supabase Cloud Development operado manualmente`

El objetivo sigue siendo preparar infraestructura de desarrollo, no implementar dominio.

# 6. Contexto normativo

La corrección debe interpretarse junto con las siguientes fuentes vigentes:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`;
- `docs/tasks/TASK-001-bootstrap-nextjs.md`;
- `docs/tasks/CORR-001-typescript-tooling-compatibility.md`;
- `docs/tasks/TASK-002-tooling-base.md`;
- `docs/tasks/TASK-003-modular-skeleton.md`;
- `docs/tasks/TASK-004-environment-secrets.md`;
- `docs/tasks/TASK-005-supabase-local.md`;
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`.

Se preservan íntegramente las decisiones relevantes ya aprobadas:

- una única aplicación Next.js y un único deployable principal inicial;
- monolito modular;
- TypeScript estricto;
- Supabase como plataforma de datos prevista;
- Supabase PostgreSQL como futura fuente de verdad remota del producto;
- `MaintenanceCompany` como tenant;
- RLS obligatoria como frontera primaria de aislamiento remoto cuando exista schema de producto;
- frontend no autoritativo para tenancy;
- `service-role` restringido y nunca convertido en mecanismo ordinario de acceso tenant;
- Fase 1 como setup técnico sin bounded contexts funcionales;
- Fase 2 todavía no iniciada.

Para hechos de tooling se utilizaron exclusivamente fuentes oficiales vigentes de Supabase y el repositorio oficial `supabase/cli`, consultados el `2026-08-17`, en particular:

- `Supabase Docs — Supabase CLI`;
- `Supabase Docs — CLI Reference`;
- `Supabase Docs — Database Migrations`;
- `Supabase Docs — Managing Environments`;
- `Supabase Docs — Deployment & Branching`;
- releases/issues oficiales de `supabase/cli` cuando fue necesario verificar comportamiento de la versión estable actual.

## Coherencia con el Gate de Fase 1

Existe una discrepancia documental real que debe registrarse: `docs/product/11-phase-1-scope-entry-gate.md` expresa literalmente `Supabase local` y utiliza `Supabase local operativo/configurable/arrancable` como parte del resultado y Gate de salida de Fase 1.

`CORR-002`, si posteriormente es aprobada, constituye una decisión posterior explícita que sustituye únicamente esa condición operativa para el host actual por un proyecto Cloud exclusivo de Development y un workflow remoto manual.

No se renombra Fase 1 en esta corrección y no se modifica `00-master-product-brief.md`. Sin embargo, antes del cierre formal de Fase 1 debe realizarse una sincronización documental mínima de `docs/product/11-phase-1-scope-entry-gate.md` para que su Gate de salida no continúe exigiendo un stack Docker local imposible. Esa sincronización debe preservar todas las fronteras de Fase 1/Fase 2 y no ampliar alcance.

Esta inconsistencia documental no invalida la redacción de `CORR-002`, pero sí constituye un Gate pendiente para el cierre posterior de Fase 1.

# 7. Evidencia del BLOCKER

El intento real de `TASK-005` registró:

- Docker CLI detectada: `28.1.1`;
- servicio `com.docker.service`: detenido;
- backend/daemon Docker: no disponible;
- API Docker: sin respuesta;
- ausencia de runtime Docker-compatible utilizable en el equipo actual;
- worktree limpio durante el intento;
- ningún archivo modificado;
- ninguna dependencia instalada;
- `supabase init` no ejecutado;
- `supabase start` no ejecutado;
- ningún commit;
- ningún push.

El resultado correcto fue:

`BLOCKER`

La corrección no intenta reparar, reinstalar, sustituir ni administrar Docker. Se acepta como restricción operativa del equipo de desarrollo.

# 8. Decisión corregida

Se sustituye la estrategia obligatoria:

`Supabase local + runtime Docker-compatible + start/status/stop`

por:

`Supabase Cloud — proyecto exclusivo de Development + repositorio local + migrations Git + operaciones remotas manuales`

La decisión corregida contiene estas invariantes:

1. Supabase continúa siendo el proveedor aprobado.
2. El repositorio continúa siendo la fuente de verdad de los cambios técnicos versionables.
3. Cuando una fase futura autorice schema, las migrations Git serán la fuente de verdad de evolución de schema.
4. Existirá un único proyecto Supabase Cloud destinado exclusivamente a `Development` para este workflow.
5. `Staging` no se crea ni se requiere en `CORR-002`.
6. `Production` no se crea ni se configura en `CORR-002`.
7. Codex no recibe acceso a Supabase Cloud.
8. Codex no recibe credenciales ni ejecuta operaciones autenticadas/remotas.
9. Francisco es el único operador autorizado para acciones remotas.
10. No se presupone Supabase Branching ni ninguna capacidad de plan Pro.
11. No se crea schema funcional durante la implementación corregida de `TASK-005`.
12. La aplicación Next.js continúa sin integrarse con Supabase durante este paso.
13. `TASK-004` permanece intacta.
14. El bloqueo de Docker deja de ser condición de fallo para la implementación corregida.
15. Los comandos que requieran contenedores quedan excluidos del workflow de este equipo.

# 9. Alcance de sustitución sobre TASK-005

`docs/tasks/TASK-005-supabase-local.md` no debe borrarse, reescribirse ni modificarse silenciosamente. Se conserva como registro de la estrategia originalmente aprobada y del bloqueo que motivó esta corrección.

Una futura implementación deberá leer conjuntamente `TASK-005` y `CORR-002`. Ante conflicto directo sobre el método de infraestructura, prevalece `CORR-002` dentro del alcance expresamente corregido por este documento.

## Cláusulas de TASK-005 preservadas

Permanecen vigentes:

- Supabase CLI como tooling reproducible del proyecto;
- CLI como `devDependency`, no instalación global;
- versión exacta y lockfile reproducible;
- uso mediante `npx`;
- separación entre infraestructura y dominio;
- ausencia de schema funcional en Fase 1;
- ausencia de migrations funcionales en la implementación de `TASK-005`;
- ausencia de Auth funcional;
- ausencia de tenancy funcional;
- ausencia de RLS ejecutable;
- ausencia de Storage funcional;
- ausencia de Realtime funcional desde la aplicación;
- ausencia de `service-role` en la aplicación;
- ausencia de variables Supabase anticipadas en el contrato de `TASK-004`;
- ausencia de `@supabase/supabase-js` y `@supabase/ssr` por anticipación;
- disciplina Git;
- preservación de `/docs` durante implementación;
- TypeScript strict;
- lint/typecheck/test/build/verify;
- revisión de seguridad y diff;
- no commit ni push por Codex;
- no `TASK-006` automático;
- no Fase 2.

## Cláusulas reemplazadas

Quedan reemplazadas por `CORR-002`:

- runtime Docker-compatible como precondición obligatoria;
- Docker operativo como criterio de aceptación;
- `supabase start` como validación obligatoria;
- `supabase status` sobre stack local como validación obligatoria;
- `supabase stop` como cierre obligatorio;
- stack local saludable como Gate de `TASK-005`;
- prohibición absoluta de usar Supabase Cloud;
- prohibición absoluta de `supabase login`;
- prohibición absoluta de `supabase link`.

Las dos últimas prohibiciones se sustituyen por una frontera más estricta de operador:

- Codex continúa teniendo prohibido `login` y `link`;
- Francisco puede ejecutarlos manualmente cuando el Gate correspondiente lo autorice.

## Cláusulas inaplicables en el host actual

Quedan inaplicables:

- detección/validación de runtime para arrancar Supabase local;
- lifecycle local de contenedores;
- health checks del stack local;
- credenciales locales emitidas por `supabase start`;
- persistencia/volúmenes del stack Supabase local.

# 10. Modelo de responsabilidades Codex / Francisco

## Codex

Codex puede, con `CORR-002` formalmente aprobada, exclusivamente cuando se inicie la implementación corregida:

- leer el repositorio y la documentación autorizada;
- inspeccionar el estado real antes de modificar archivos;
- instalar la versión exacta autorizada de Supabase CLI como `devDependency`;
- actualizar coherentemente `package.json` y `package-lock.json`;
- ejecutar comandos locales no autenticados expresamente autorizados;
- ejecutar `npx supabase init` si no existe una configuración incompatible;
- inspeccionar los archivos generados;
- conservar `supabase/config.toml` cuando corresponda;
- preparar futuras migrations SQL sólo cuando una tarea de schema posterior las autorice;
- crear/modificar únicamente archivos autorizados por esa tarea futura;
- ejecutar checks puramente locales que no requieran Docker ni autenticación;
- revisar diffs;
- proporcionar a Francisco instrucciones exactas para cada operación manual.

Codex no puede:

- crear el proyecto Cloud;
- entrar al Dashboard;
- ejecutar `supabase login`;
- recibir un Personal Access Token;
- leer credential storage;
- ejecutar `supabase link`;
- recibir database password;
- ejecutar `supabase db push`;
- ejecutar `supabase db push --dry-run`;
- ejecutar `supabase migration list --linked` ni otros comandos remotos, salvo una futura decisión que cambie expresamente esta frontera;
- ejecutar Management API;
- ejecutar operaciones remotas de lectura o escritura;
- recibir o utilizar `service-role`;
- guardar credenciales;
- imprimir credenciales;
- pedir al usuario que pegue credenciales en prompts.

## Francisco

Francisco es el único operador autorizado para:

- crear el proyecto Supabase Cloud Development;
- seleccionar manualmente organización, plan y región apropiados para Development;
- autenticarse con la CLI;
- ejecutar `npx supabase login`;
- ejecutar `npx supabase link --project-ref <PROJECT_REF>`;
- introducir el `PROJECT_REF` real cuando corresponda;
- introducir la database password cuando corresponda;
- ejecutar operaciones remotas expresamente autorizadas por una tarea;
- ejecutar `npx supabase db push --dry-run` cuando exista una migration autorizada;
- revisar exclusivamente el inventario de migrations pendientes y su orden producido por el dry-run;
- ejecutar `npx supabase db push` después del Gate correspondiente;
- utilizar el Dashboard para inspección, diagnóstico u operaciones administrativas explícitamente autorizadas.

Francisco sólo comparte con ChatGPT/Codex:

- PASS/FAIL/BLOCKER;
- nombres de migrations cuando corresponda;
- mensajes de error sanitizados;
- resultados no sensibles;
- metadata técnica no secreta estrictamente necesaria.

# 11. Supabase Cloud Development

Debe existir un proyecto Supabase alojado destinado exclusivamente a:

`Development`

Reglas obligatorias:

- no es Production;
- no es Staging;
- no contiene datos reales de clientes;
- no contiene secretos productivos;
- no reutiliza credenciales productivas;
- no debe utilizarse como fuente de datos reales;
- puede ser descartable/recreable durante desarrollo, sujeto a poder reconstruir el schema autorizado desde migrations Git;
- debe comenzar limpio respecto del schema funcional propio del SaaS;
- no se realizarán cambios manuales de schema como workflow ordinario;
- puede usar el plan disponible que Francisco considere adecuado para desarrollo;
- `CORR-002` no exige plan Pro;
- `CORR-002` no presupone Branching;
- `CORR-002` no crea preview branches;
- `CORR-002` no crea Staging ni Production.

La existencia de Auth, Storage, Realtime y otros servicios administrados como capacidades nativas del proyecto Supabase no equivale a implementar esas capacidades en la aplicación.

# 12. Supabase CLI sin Docker

La CLI continúa formando parte de la baseline del proyecto aunque el host no disponga de Docker.

## Instalación aprobable para futura implementación

Se mantiene la estrategia:

- paquete npm: `supabase`;
- clasificación: `devDependency`;
- instalación global: no;
- ejecución: `npx supabase ...`;
- versión flotante `latest`: no;
- beta/prerelease: no;
- lockfile: `package-lock.json`.

A fecha de revisión de `CORR-002`, la versión estable publicada es:

`supabase 2.114.0`

Por tanto, la futura implementación corregida de `TASK-005` debe pinnear exactamente:

`2.114.0`

si al momento de ejecutar siguen cumpliéndose las precondiciones documentales de esta corrección. No debe cambiar silenciosamente a otra versión, `latest` ni beta. Si `2.114.0` ya no puede instalarse o resulta incompatible con el baseline real, la implementación debe reportar `BLOCKER` y solicitar una corrección técnica separada.

La documentación oficial vigente exige Node.js 20 o posterior para npm/npx. El baseline recibido de `TASK-005` utiliza Node.js `22.23.1`, que satisface esa condición, sujeto a nueva verificación en el preflight real.

## Verificación física de migrations futuras

Cuando una futura tarea cree una migration, debe comprobar físicamente que el archivo esperado fue creado bajo `supabase/migrations/` antes de continuar.

Esta regla aplica independientemente del sistema operativo y del mecanismo autorizado utilizado para crear el archivo. Un mensaje de éxito de una herramienta no sustituye la comprobación de que el artefacto versionable esperado existe realmente en el repositorio.

# 13. Inicialización del repositorio Supabase

La documentación oficial define `supabase init` como el comando que inicializa la configuración y crea `supabase/config.toml` en el directorio de trabajo.

No inicia el stack de contenedores y la referencia oficial del comando no declara una dependencia de Docker para esta operación.

Por tanto, en la futura implementación corregida queda autorizado, para Codex:

`npx supabase init`

sólo si:

- `CORR-002` está aprobada;
- el repositorio fue inspeccionado primero;
- no existe una configuración Supabase incompatible;
- no es necesario `--force`;
- el worktree estaba limpio en preflight.

Queda prohibido:

- `supabase init --force` por conveniencia;
- inventar manualmente `supabase/config.toml` si `init` funciona;
- ejecutar `supabase start` después de `init`;
- crear migrations funcionales como efecto adicional;
- crear seeds funcionales;
- añadir variables Supabase a la aplicación.

Después de `init`, Codex debe inspeccionar cada archivo generado y distinguir:

- configuración reproducible/versionable;
- estado temporal de CLI;
- archivos que la herramienta marque como locales/no versionables.

# 14. Operaciones manuales autenticadas

Toda operación que se comunique con Supabase Cloud mediante identidad o credenciales pertenece exclusivamente a Francisco.

Incluye, como mínimo:

- `supabase login`;
- `supabase link`;
- `db push --dry-run` contra proyecto linked;
- `db push` contra proyecto linked;
- `migration list --linked` contra proyecto linked, si una tarea futura lo autoriza;
- `migration repair`, sólo ante una futura autorización explícita y nunca como reparación improvisada;
- cualquier comando de Management API;
- cualquier operación de proyecto, secrets, branches, functions, Storage o Auth;
- cualquier otro comando remoto aunque sea de sólo lectura.

La regla es:

`remoto/autenticado = Francisco`

Codex puede redactar la instrucción exacta y explicar qué salida sanitizada necesita para validar el Gate, pero no ejecuta la operación.

# 15. Login y credenciales

`supabase login` se clasifica como operación manual de Francisco.

Comando conceptual:

`npx supabase login`

La documentación oficial vigente indica que el Personal Access Token se guarda en credential storage nativo cuando está disponible; si no lo está, la CLI puede recurrir al archivo local `~/.supabase/access-token`.

Por seguridad del proyecto:

- Codex no ejecuta login;
- ChatGPT/Codex no recibe el Personal Access Token;
- Francisco no pega el token en prompts;
- Codex no inspecciona credential storage;
- Codex no inspecciona `~/.supabase/access-token`;
- el token no entra en Git;
- el token no entra en `/docs`;
- el token no entra en logs compartidos;
- si una salida lo contiene, Francisco debe sanitizarla antes de compartirla;
- no se utilizará `SUPABASE_ACCESS_TOKEN` como variable de aplicación ni se agregará a `.env.example` en esta corrección.

# 16. Link al proyecto Development

`supabase link` se clasifica como operación manual de Francisco.

Comando conceptual:

`npx supabase link --project-ref <PROJECT_REF>`

La referencia oficial vigente define `link` como la vinculación del proyecto local con un proyecto Supabase alojado, obtiene configuración de PostgREST y permite validar ajustes de base si se proporciona la database password. La database password puede guardarse en credential storage nativo cuando está disponible.

Reglas:

- Codex no ejecuta `link`;
- Francisco introduce el `PROJECT_REF`;
- Francisco introduce la database password si corresponde;
- ChatGPT/Codex no necesita recibir el `PROJECT_REF` real para validar el workflow;
- ChatGPT/Codex nunca recibe la database password;
- `SUPABASE_DB_PASSWORD` no se agrega al contrato de aplicación;
- no se guarda la password en Git ni documentación;
- el resultado compartido debe ser sanitizado.

## Estado local producido por link

La documentación de CLI confirma credential storage para la database password. El código y salidas de la CLI oficial también utilizan estado temporal bajo `supabase/.temp/`, incluyendo la referencia del proyecto linked en implementaciones vigentes.

Por tanto, la implementación debe tratar:

- `supabase/config.toml` como configuración reproducible versionable generada por `init`;
- `supabase/.temp/` como estado local/temporal de CLI y no como fuente de verdad versionable;
- credenciales en credential storage como estado privado local;
- cualquier archivo adicional generado por la versión pinneada según su `.gitignore`/contrato oficial real, inspeccionándolo antes de decidir versionado.

No debe versionarse información sensible ni estado de vinculación temporal por conveniencia.

# 17. Workflow de migrations

`CORR-002` no crea migrations funcionales. Define únicamente el workflow obligatorio para cuando una tarea futura de Fase 2 o posterior autorice schema.

La dirección preferida será:

`Git migration -> revisión estática -> inventario remoto mediante dry-run -> revisión humana del inventario -> ejecución en Development -> comprobación posterior -> evidencia sanitizada -> Gate`

El proyecto Supabase Cloud `Development` es el **primer entorno de ejecución real de migrations** dentro de este workflow sin Docker.

La ausencia de un runtime Docker-compatible impide utilizar una base Supabase local para ejecutar previamente migrations mediante `db start`, `db reset` u otros mecanismos locales equivalentes. En consecuencia:

> `la primera validación ejecutable real de una migration ocurre al aplicarla al proyecto Supabase Cloud Development`

Esta consecuencia no convierte `Development` en Production, no autoriza Production y no crea ningún entorno adicional. `CORR-002` no crea ni configura Production.

Flujo obligatorio para una futura migration autorizada:

1. una tarea futura define requisitos, modelo físico autorizado, seguridad, RLS, criterios y pruebas;
2. Codex prepara una migration versionada bajo `supabase/migrations/` y comprueba físicamente que el archivo esperado existe;
3. Codex y/o la revisión humana realizan una **revisión estática del SQL**, incluyendo coherencia con la tarea, seguridad, RLS cuando corresponda, dependencias y riesgos evidentes; esta revisión no ejecuta la migration;
4. Codex no aplica la migration remotamente y entrega a Francisco el comando exacto y el resultado esperado a nivel de inventario;
5. Francisco ejecuta manualmente `npx supabase db push --dry-run` contra el proyecto linked de `Development`;
6. el `dry-run` se utiliza exclusivamente para identificar las migrations pendientes que la CLI intentaría aplicar, comprobar que su conjunto y orden coinciden con la tarea autorizada y detectar migrations inesperadas antes del push real;
7. la salida del `dry-run` se revisa humanamente; si el conjunto u orden no coincide con lo autorizado, se detiene el workflow y no se ejecuta `db push`;
8. Francisco ejecuta manualmente `npx supabase db push` exclusivamente contra `Development`;
9. se comprueba posteriormente el resultado real de la aplicación en `Development` y, cuando una tarea futura lo requiera, puede utilizarse una comprobación remota manual no destructiva como `npx supabase migration list --linked` para contrastar el historial;
10. Francisco comparte únicamente evidencia sanitizada suficiente para el Gate;
11. ChatGPT/Codex revisa el resultado contra la tarea autorizada y se ejecuta el Gate posterior correspondiente;
12. sólo después de un Gate satisfactorio puede continuar el workflow de esa tarea.

`supabase db push --dry-run` **NO**:

- valida sintaxis SQL;
- ejecuta la migration;
- simula transaccionalmente la aplicación;
- demuestra que la migration pueda ejecutarse correctamente;
- garantiza que un `db push` posterior tendrá éxito.

Si `npx supabase db push` falla contra `Development`:

- detener inmediatamente el workflow;
- no avanzar a ningún otro entorno;
- no intentar corregir manualmente el schema desde Dashboard o SQL Editor;
- no ejecutar `migration repair`, `db reset --linked` ni otra reparación improvisada;
- inspeccionar el estado remoto de Development mediante operaciones manuales no destructivas autorizadas;
- conservar y revisar la evidencia del fallo de forma sanitizada;
- definir la corrección mediante una migration/versionado apropiado o mediante el procedimiento formal que corresponda según el estado remoto real;
- someter esa corrección al mismo ciclo de revisión y Gate antes de volver a aplicar cambios.

Reglas adicionales:

- una migration aplicada no se sustituye silenciosamente por una edición histórica;
- el orden y naming siguen la convención oficial de `supabase/migrations`;
- no se usa Dashboard remoto como fuente principal de cambios de schema;
- no se confía en memoria humana para reconstruir cambios;
- no se ejecutan pushes simultáneos desde múltiples operadores;
- Francisco es el único operador remoto mientras esta corrección esté vigente;
- cualquier comprobación remota, incluso de sólo lectura, permanece bajo la frontera `remoto/autenticado = Francisco`.

# 18. DB push y dry-run

La documentación oficial vigente define:

- `supabase db push`: aplica migrations locales pendientes a una base remota linked;
- `--dry-run`: muestra las migrations que serían aplicadas sin aplicarlas.

Dentro de `CORR-002`, la semántica de `--dry-run` queda estrictamente limitada a **inventario previo**.

`npx supabase db push --dry-run` sirve exclusivamente para:

- identificar qué migrations locales pendientes la CLI intentaría aplicar;
- verificar que el conjunto esperado coincide con la tarea autorizada;
- verificar el orden de esas migrations antes del push real;
- detectar migrations inesperadas antes de efectuar cambios remotos.

`npx supabase db push --dry-run` **NO** constituye:

- validación de sintaxis SQL;
- prueba ejecutable de la migration;
- simulación de su aplicación contra PostgreSQL;
- simulación transaccional;
- verificación de constraints, funciones, RLS, dependencias u otros efectos en ejecución;
- garantía de que `npx supabase db push` vaya a finalizar correctamente.

La CLI no aplica las migrations durante `--dry-run`; por ello este mecanismo no sustituye una base de ejecución. En particular, `--dry-run` no realiza validación SQL client-side dentro de este workflow.

Como este equipo no dispone de Docker y no puede utilizar una base Supabase local para ejecutar migrations antes del remoto, el primer entorno donde una migration futura autorizada se ejecuta realmente es:

`Supabase Cloud Development`

Por tanto:

`revisión estática SQL != dry-run != ejecución real`

La secuencia obligatoria es:

`revisión estática -> dry-run/inventario -> revisión humana -> db push a Development -> comprobación real -> evidencia sanitizada -> Gate`

La referencia oficial no establece una dependencia de Docker para `db push` contra un proyecto linked y describe el comando como operación contra la base remota. Por tanto, el workflow corregido lo clasifica como compatible con un host sin Docker.

Clasificación:

`npx supabase db push --dry-run` -> `REMOTO / MANUAL / FRANCISCO / INVENTARIO NO EJECUTABLE`

`npx supabase db push` -> `REMOTO / MANUAL / FRANCISCO / PRIMERA EJECUCIÓN REAL EN DEVELOPMENT`

Codex:

- no ejecuta ninguno;
- no recibe password;
- no recibe token;
- no automatiza el paso;
- no convierte el push en script de CI dentro de `CORR-002`;
- no describe el `dry-run` como validación SQL ni como garantía de éxito.

En la implementación corregida de `TASK-005` no existe schema funcional ni migration funcional que aplicar, por lo que `db push` no es un criterio obligatorio de Fase 1. Esta sección establece el mecanismo para futuras tareas autorizadas.

Si una futura migration falla durante `db push` contra `Development`, el fallo constituye un Gate negativo: se detiene el workflow, se inspecciona el estado remoto sin reparaciones improvisadas y se define una corrección versionada o procedimiento formal antes de cualquier nuevo intento. No se avanza a otro entorno.

Cuando una futura tarea requiera confirmar el historial remoto después de una aplicación o un fallo, puede autorizar una comprobación manual no destructiva como `npx supabase migration list --linked`. Esa comprobación sigue siendo remota/autenticada y sólo la ejecuta Francisco.

Si una futura versión oficial de CLI cambiara y `db push` pasara a requerir Docker, la tarea que dependa de ese comando debe detenerse con `BLOCKER` y solicitar una corrección formal; no debe improvisar un canal remoto alternativo no versionable.

# 19. Comandos incompatibles con ausencia de Docker

La documentación oficial vigente confirma que los siguientes flujos dependen de contenedores o del stack local y quedan fuera del workflow normal de este equipo:

| Comando / flujo | Clasificación | Motivo |
|---|---|---|
| `supabase start` | No utilizable | Arranca los servicios locales en contenedores. |
| `supabase status` del stack local | No utilizable | Inspecciona un stack local que depende de contenedores y debe estar iniciado. |
| `supabase stop` | No utilizable | Gestiona los recursos Docker del stack local. |
| `supabase db reset` local | No utilizable | Requiere el stack local y recrea el contenedor Postgres. |
| `supabase db pull` | No utilizable | La documentación exige Docker porque inicia un Postgres local para comparar schema remoto. |
| `supabase db dump` | No utilizable | Ejecuta `pg_dump` dentro de un contenedor, incluso para base remota. |
| `supabase db diff` | No utilizable en este workflow | El motor de diff y la shadow database utilizan contenedores. |
| tests de DB locales que dependan del stack | No utilizables | Requieren base/stack local o contenedores. |
| comandos `--local` que presupongan servicios Supabase | No utilizables | No existe stack local operativo. |

## `db reset --linked`

`supabase db reset --linked` no se clasifica aquí como bloqueado por Docker. Se prohíbe por una razón distinta y más fuerte: es una operación remota destructiva que identifica y elimina entidades creadas por usuario antes de reaplicar migrations.

Por tanto:

`supabase db reset --linked = NO AUTORIZADO`

salvo una tarea futura específica, revisada y aprobada que justifique expresamente una operación destructiva sobre Development.

## Otros comandos

Ningún comando remoto o local no enumerado adquiere autorización por omisión. Si una tarea futura necesita un comando cuyo uso de Docker sea ambiguo, debe verificarse contra la documentación oficial vigente antes de autorizarlo.

# 20. Dashboard y SQL Editor

El Dashboard de Supabase puede ser utilizado manualmente por Francisco para:

- crear el proyecto Development;
- inspección;
- diagnóstico;
- comprobar estado del proyecto;
- operaciones administrativas explícitamente autorizadas;
- casos excepcionales documentados.

No debe utilizarse como workflow ordinario para crear o modificar schema funcional remoto.

Una vez que existan migrations de producto, la regla será:

`migration Git -> db push`

NO:

`Dashboard remoto -> recordar cambio -> intentar reconstruirlo después`

La documentación oficial advierte que modificar directamente el schema de una base remota mediante SQL Editor/Table Editor elude el historial de migrations y puede provocar errores de sincronización con `db push`.

Por tanto:

- no crear tablas funcionales manualmente en Dashboard durante `CORR-002`;
- no usar SQL Editor para sustituir una migration versionada;
- no depender de `db pull` para recuperar cambios remotos, dado que el host no dispone de Docker;
- cualquier excepción futura debe estar expresamente autorizada, documentada y reconciliada sin ocultar divergencia.

# 21. Seguridad

La estrategia corregida debe preservar como invariantes:

1. `Development` separado conceptualmente de `Production`.
2. Cero datos reales de clientes en Development.
3. Cero secretos productivos en Development.
4. Cero credenciales Supabase compartidas con Codex/ChatGPT.
5. Cero operaciones remotas ejecutadas por Codex.
6. Tokens y passwords controlados exclusivamente por Francisco.
7. Salidas compartidas siempre sanitizadas.
8. Git como fuente de verdad de cambios versionables.
9. Migrations como fuente de verdad de evolución de schema cuando exista schema.
10. `db push --dry-run`, cuando sea aplicable, se utiliza sólo para inventariar migrations pendientes y verificar conjunto/orden; nunca como validación SQL, prueba de ejecución, simulación transaccional ni garantía de éxito.
11. Revisión estática previa del SQL antes de cualquier operación remota autorizada.
12. Revisión humana del inventario producido por `db push --dry-run` antes de un `db push`.
13. `Development` es el primer entorno de ejecución real de migrations en este workflow sin Docker.
14. Todo `db push` autorizado se ejecuta primero y exclusivamente contra `Development`; `CORR-002` no autoriza Production.
15. Un fallo de `db push` en Development detiene el workflow y no autoriza correcciones manuales de schema ni reparaciones improvisadas.
16. Ninguna operación destructiva remota por defecto.
17. `service-role` fuera del workflow de migrations.
18. Ningún secreto en `/docs`.
19. Ningún secreto en Git.
20. Ningún secreto en `.env.example`.
21. Ningún secreto pegado en prompts.
22. Ningún token/password en informes de Codex.
23. Ninguna variable de entorno utilizada como sustituto de autorización, tenancy o RLS.
24. El proyecto Development no reduce los requisitos de aislamiento del producto futuro.
25. Toda comprobación remota, incluso no destructiva como `migration list --linked` cuando una tarea la autorice, permanece bajo `remoto/autenticado = Francisco`.

Si un comando imprime una credencial o conexión sensible, Francisco debe redactar/sanitizar esa porción antes de compartir la salida.

# 22. Relación con TASK-004

`TASK-004 — Configuración de entorno y secretos` se preserva íntegramente.

`CORR-002` no autoriza modificar:

- `.env.example`;
- la política de `.env*.local`;
- `src/infrastructure/config/`;
- la separación public/private;
- la política de acceso a `process.env`;
- la clasificación required/optional;
- la política build/runtime.

No se agregan todavía:

- `NEXT_PUBLIC_SUPABASE_URL`;
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`;
- `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`;
- `SUPABASE_SERVICE_ROLE_KEY`;
- `SUPABASE_ACCESS_TOKEN`;
- `SUPABASE_DB_PASSWORD`;
- `SUPABASE_PROJECT_ID`;
- otros valores de Supabase.

El link de la CLI es estado operativo de tooling y no equivale a integrar la aplicación Next.js.

La conexión de la aplicación con Supabase deberá introducirse únicamente mediante una tarea futura que defina expresamente sus variables, superficies pública/privada, seguridad y pruebas.

# 23. Schema y datos

`CORR-002` no crea ni autoriza schema funcional.

Durante la implementación corregida de `TASK-005` no se deben crear:

- `MaintenanceCompany` / tenants;
- usuarios de producto;
- memberships;
- roles de producto;
- clients;
- locations;
- equipment types;
- equipment;
- forms;
- form versions;
- maintenance;
- maintenance revisions;
- responses;
- evidence;
- reports;
- AI credits;
- subscriptions;
- tablas de producto;
- funciones de producto;
- triggers de producto;
- seeds funcionales.

El proyecto Cloud Development debe comenzar sin schema funcional propio del SaaS introducido manualmente.

Los schemas y objetos administrados por la propia plataforma Supabase no se consideran implementación funcional del SaaS por el mero hecho de existir en un proyecto Cloud.

# 24. Auth / Storage / Realtime

La creación de un proyecto Supabase Cloud implica que la plataforma disponga de capacidades administradas como Auth, Storage y Realtime.

`CORR-002` no autoriza utilizarlas funcionalmente.

No se debe:

- configurar Auth de usuarios del producto;
- crear flujos de login de producto;
- crear usuarios de negocio;
- crear buckets funcionales;
- subir Evidence;
- definir Storage policies;
- configurar Realtime desde la aplicación;
- crear canales de dominio;
- desplegar Edge Functions;
- instalar cliente Supabase en la aplicación;
- añadir credenciales de aplicación.

La mera existencia técnica de esos servicios en Development no adelanta Fase 2 ni fases posteriores.

# 25. Tenancy y RLS

`ADR-0002` permanece completamente vigente.

Esta corrección no cambia:

- `MaintenanceCompany = tenant`;
- base PostgreSQL compartida entre tenants para el MVP;
- tenant ownership inequívoco;
- tenant resolution autoritativa;
- frontend no autoritativo;
- integridad cross-tenant;
- RLS como frontera primaria de aislamiento remoto;
- uso restringido de `service-role`.

En `CORR-002`:

- no existe todavía schema tenant-owned de producto;
- no se implementan policies;
- no se crean helpers RLS;
- no se implementa `CompanyMembership`;
- no se implementa `UserClientAccess`;
- no se implementa `SupportAccessGrant`;
- no se resuelve `ADR-0003`;
- no se resuelve ningún `DO-*` ni `*-OPEN-*`.

Cuando una futura migration introduzca una tabla tenant-owned o cambie acceso, deberá incluir el diseño de seguridad/RLS exigido por las especificaciones de esa fase antes de poder aplicarse a Development.

# 26. CI

El `Paso 7 — CI` de Fase 1 permanece separado.

`CORR-002` no configura:

- GitHub Actions;
- Supabase GitHub Integration;
- despliegue automático de migrations;
- `SUPABASE_ACCESS_TOKEN` en CI;
- database passwords en CI;
- project refs en secrets de CI;
- pipelines de deploy;
- Staging;
- Production.

Mientras esta corrección permanezca vigente, las operaciones remotas de Supabase son manuales y ejecutadas por Francisco.

Una futura tarea de CI no puede convertir automáticamente este workflow manual en deployment remoto sin una decisión explícita que cambie la frontera aprobada.

# 27. Dentro de alcance

`CORR-002` cubre exclusivamente:

- registrar formalmente el `BLOCKER` real de Docker;
- aceptar que el host no tendrá Supabase local operativo;
- sustituir la estrategia de `TASK-005` por Supabase Cloud Development;
- definir un único proyecto remoto de Development;
- definir separación Development / Staging / Production;
- definir la frontera Codex / Francisco;
- conservar Supabase CLI reproducible sin Docker;
- autorizar `supabase init` local en futura implementación;
- definir `login` manual;
- definir `link` manual;
- definir el tratamiento seguro de credenciales y estado local de link;
- definir migrations Git como futura fuente de verdad de schema;
- definir `db push --dry-run` manual;
- definir `db push` manual;
- identificar comandos incompatibles con ausencia de Docker;
- excluir `db pull` del workflow normal;
- limitar Dashboard/SQL Editor;
- preservar `TASK-004`;
- preservar ausencia de schema funcional;
- preservar ausencia de Auth/tenancy/RLS;
- preservar Fase 1;
- preparar una futura implementación corregida de `TASK-005`.

# 28. Fuera de alcance

Queda fuera de `CORR-002` actual:

- implementar la corrección;
- ejecutar Codex;
- instalar Supabase CLI ahora;
- ejecutar `supabase init` ahora;
- crear el proyecto Supabase ahora;
- ejecutar `supabase login` ahora;
- ejecutar `supabase link` ahora;
- ejecutar `db push --dry-run` ahora;
- ejecutar `db push` ahora;
- modificar el repositorio;
- modificar `TASK-005`;
- modificar `TASK-004`;
- modificar ADRs;
- crear schema funcional;
- crear migrations funcionales;
- crear seeds funcionales;
- implementar Auth;
- implementar tenancy;
- implementar RLS;
- implementar Storage funcional;
- implementar Realtime funcional;
- Edge Functions;
- integrar la app con Supabase;
- instalar `@supabase/supabase-js`;
- instalar `@supabase/ssr`;
- variables de aplicación Supabase;
- `service-role`;
- CI;
- Supabase GitHub Integration;
- Staging;
- Production;
- Branching de Supabase;
- Fase 2+;
- `TASK-006`.

# 29. Archivos/categorías esperados

Una futura implementación corregida de `TASK-005` puede modificar únicamente las categorías siguientes, sujeto a inspección real previa:

## Esperados

- `package.json` — añadir `supabase` como `devDependency` exacta autorizada;
- `package-lock.json` — resolver de forma reproducible la misma versión;
- `supabase/` — únicamente contenido generado/esperado por `supabase init` y configuración reproducible correspondiente;
- `supabase/config.toml` — configuración generada por `init` y versionable;
- `.gitignore` — sólo si resulta estrictamente necesario para preservar estado temporal/no versionable de la CLI sin romper reglas de `TASK-004`;
- documentación técnica no normativa mínima existente o nueva, sólo si es necesaria para describir el workflow sin Docker y las fronteras manuales.

## No versionables / locales

Debe mantenerse fuera de Git:

- `supabase/.temp/` y estado temporal equivalente de la CLI;
- tokens;
- database passwords;
- credential storage;
- archivos locales con secretos;
- cualquier estado de sesión autenticada;
- outputs que contengan credenciales.

## Prohibidos como cambios de implementación

- cualquier archivo bajo `/docs`;
- `TASK-005`;
- `TASK-004`;
- ADRs;
- `.env.example`;
- `src/infrastructure/config/`;
- código de `app/`;
- código funcional bajo `src/modules/`;
- cliente Supabase de aplicación;
- schema/migrations funcionales.

La futura sincronización documental de `11-phase-1-scope-entry-gate.md` es un paso documental separado y no forma parte del diff técnico de la implementación corregida de `TASK-005`.

# 30. Dependencias

La futura implementación depende de:

- `CORR-002` formalmente aprobada para implementación;
- incorporación formal de `CORR-002` a su ruta canónica futura;
- `TASK-001`, `CORR-001`, `TASK-002`, `TASK-003` y `TASK-004` cerradas en el baseline real;
- `TASK-005` preservada como tarea original bloqueada/corregida;
- Node/npm compatibles con la CLI pinneada;
- acceso a npm para instalar la dependencia autorizada;
- capacidad de ejecutar comandos Node/npx locales;
- un navegador/cuenta Supabase controlados por Francisco para el paso manual;
- conectividad remota de Francisco para crear/linkear el proyecto Development;
- ausencia de secretos versionados preexistentes que bloqueen el trabajo;
- revisión de la documentación oficial vigente antes de cualquier operación cuyo comportamiento pueda haber cambiado.

No depende de:

- Docker;
- runtime Docker-compatible;
- plan Pro;
- Supabase Branching;
- Staging;
- Production;
- `@supabase/supabase-js`;
- `service-role`;
- CI.

# 31. Restricciones de implementación

Cuando se autorice la implementación corregida, deben cumplirse las siguientes restricciones:

1. inspeccionar el repositorio antes de cualquier cambio;
2. repetir preflight Git inmediatamente antes del primer cambio;
3. verificar branch/upstream/divergencia;
4. exigir worktree limpio;
5. registrar `HEAD` inicial;
6. preservar `/docs`;
7. preservar `TASK-005`;
8. preservar `TASK-004`;
9. preservar skeleton, aliases y boundaries;
10. preservar TypeScript strict/noEmit;
11. comprobar versiones reales de Node/npm;
12. comprobar package manager y único lockfile;
13. inspeccionar referencias Supabase existentes;
14. inspeccionar si ya existe `supabase/`;
15. detenerse si existe configuración incompatible que requiera `init --force`;
16. instalar únicamente la CLI exacta autorizada;
17. no usar `latest`;
18. no usar beta;
19. no usar `--force`;
20. no reparar Docker;
21. no ejecutar `start/status/stop` como Gate;
22. no ejecutar login;
23. no ejecutar link;
24. no ejecutar ningún comando remoto;
25. no recibir tokens/passwords;
26. no leer credential storage;
27. no instalar cliente Supabase de aplicación;
28. no añadir variables Supabase a `.env.example`;
29. no crear migrations funcionales;
30. no crear schema funcional;
31. no crear Auth/RLS/Storage/Realtime funcional;
32. revisar todos los archivos generados por `init`;
33. confirmar que estado temporal no esté trackeado;
34. ejecutar lint/typecheck/test/build/verify;
35. ejecutar `git diff --check`;
36. revisar el diff completo;
37. listar archivos creados/modificados;
38. registrar versión CLI efectiva;
39. detenerse antes del primer paso remoto y entregar instrucciones manuales a Francisco;
40. no commit;
41. no push;
42. no generar `TASK-006`;
43. informar `PASS`, `FAIL` o `BLOCKER` para la parte local y un estado separado `WAITING FOR MANUAL REMOTE STEP` cuando corresponda.

# 32. Criterios de aceptación

La futura implementación corregida sólo puede cerrarse satisfactoriamente si se cumplen todos los criterios siguientes:

1. `CORR-002` fue aprobada previamente.
2. El repositorio fue inspeccionado antes de modificarlo.
3. Preflight Git correcto.
4. Worktree limpio al inicio.
5. `HEAD` inicial registrado.
6. Tareas previas realmente cerradas.
7. `TASK-005` original preservada.
8. `/docs` intacto durante el diff técnico.
9. Node/npm compatibles.
10. Existe un único lockfile.
11. `supabase` quedó como `devDependency` exacta autorizada.
12. `package-lock.json` resuelve la misma versión.
13. No se instaló CLI global.
14. `npx supabase --version` confirma la versión pinneada.
15. `supabase init` finalizó correctamente sin Docker.
16. `supabase/config.toml` existe.
17. No se usó `--force`.
18. Se inspeccionó todo archivo generado.
19. Estado temporal de CLI permanece fuera de Git.
20. Ningún secreto fue añadido a Git.
21. `.env.example` permanece intacto.
22. `src/infrastructure/config/` permanece intacto.
23. No existe cliente Supabase en la aplicación.
24. No se creó schema funcional.
25. No se creó migration funcional.
26. No se creó seed funcional.
27. No se implementó Auth funcional.
28. No se implementó tenancy.
29. No se implementó RLS.
30. No se implementó Storage funcional.
31. No se implementó Realtime funcional desde la app.
32. No se introdujo `service-role`.
33. Codex no ejecutó login.
34. Codex no ejecutó link.
35. Codex no ejecutó comandos remotos.
36. Codex no recibió tokens/passwords/keys.
37. Codex no intentó reparar Docker.
38. No se exigió `start/status/stop`.
39. Francisco creó exactamente un proyecto Cloud exclusivo de Development durante el paso manual posterior.
40. Francisco confirmó que no se creó Production.
41. Francisco confirmó que no se creó Staging.
42. Francisco ejecutó login manual sin compartir el token.
43. Francisco ejecutó link manual sin compartir password.
44. El proyecto linked corresponde al entorno Development correcto.
45. La salida compartida del paso manual está sanitizada.
46. No se realizaron cambios de schema remotos durante el Gate de Fase 1.
47. No se ejecutó `db push` sin migration autorizada.
47.a. El workflow documentado establece que `db push --dry-run` sólo inventaría migrations pendientes y su orden, y no valida SQL ni garantiza el éxito del push.
47.b. El workflow documentado establece que, para futuras migrations autorizadas, la primera ejecución real ocurre mediante `db push` contra el proyecto `Development`.
47.c. El workflow documentado exige detenerse ante un fallo de `db push` en Development, sin correcciones manuales de schema, sin reparaciones improvisadas y sin avanzar a otro entorno.
48. lint PASS.
49. typecheck PASS.
50. test PASS.
51. build PASS.
52. verify PASS.
53. `git diff --check` PASS.
54. No hubo commit por Codex.
55. No hubo push por Codex.
56. No se configuró CI.
57. No se generó `TASK-006`.
58. No se avanzó a Fase 2.

# 33. Verificaciones obligatorias

## Verificaciones locales de Codex

Codex debe registrar, como mínimo:

- Git válido;
- branch/base;
- upstream y divergencia;
- worktree limpio inicial;
- `HEAD` inicial;
- integridad de `/docs`;
- estado de tareas previas;
- `package.json`;
- `package-lock.json`;
- único lockfile;
- Node real;
- npm real;
- TypeScript strict/noEmit;
- `.gitignore`;
- `.env*`;
- `.env.example`;
- `src/infrastructure/config/`;
- referencias Supabase preexistentes;
- existencia previa de `supabase/`;
- versión instalada de Supabase CLI;
- ejecución y resultado de `npx supabase init`;
- existencia de `supabase/config.toml`;
- inventario de archivos generados;
- tracking/ignore de estado temporal;
- ausencia de secrets;
- ausencia de schema/migrations funcionales;
- ausencia de cliente Supabase de aplicación;
- lint;
- typecheck;
- test;
- build;
- verify;
- `git diff --check`;
- diff final completo.

No debe ejecutar como verificación:

- Docker health;
- `supabase start`;
- `supabase status`;
- `supabase stop`;
- `supabase login`;
- `supabase link`;
- `db pull`;
- `db dump`;
- `db diff`;
- `db push`;
- `db push --dry-run`.

Codex puede realizar revisión estática de una migration futura únicamente cuando una tarea posterior la autorice, pero esa revisión no constituye ejecución ni validación remota.

## Verificaciones manuales de Francisco

Durante el Gate manual posterior de la implementación corregida de `TASK-005`, Francisco debe verificar:

- proyecto único destinado a Development;
- organización correcta;
- plan apropiado sin asumir Pro;
- región seleccionada deliberadamente;
- ausencia de datos reales;
- ausencia de Production y Staging creados por esta corrección;
- login manual exitoso;
- link manual exitoso al proyecto Development correcto;
- ningún token/password compartido;
- salida sanitizada suficiente para confirmar PASS/FAIL.

En Fase 1 no es obligatorio ejecutar `db push`, porque todavía no existe una migration funcional autorizada.

Cuando una tarea futura autorice una migration, las verificaciones manuales deben distinguir expresamente:

1. revisión estática previa del SQL;
2. `npx supabase db push --dry-run` para inventariar exclusivamente migrations pendientes y orden;
3. revisión humana del inventario del dry-run;
4. `npx supabase db push` contra `Development` como primera ejecución real de la migration;
5. comprobación posterior del resultado de la ejecución;
6. cuando corresponda, comprobación remota manual no destructiva del historial mediante `npx supabase migration list --linked`;
7. evidencia sanitizada;
8. Gate posterior.

Un `dry-run` satisfactorio no se registra como evidencia de validez SQL ni como PASS de ejecución. El PASS ejecutable sólo puede derivarse de la aplicación real y sus comprobaciones posteriores en `Development`.

Si el `db push` falla, la verificación debe registrar `FAIL` o `BLOCKER` según corresponda y detener el workflow sin Dashboard como reparación de schema, sin `migration repair` improvisado, sin `db reset --linked` y sin avanzar a otro entorno.

# 34. Definition of Done

La implementación corregida de `TASK-005` podrá proponerse como `DONE` únicamente cuando:

- todos los criterios de aceptación aplicables estén satisfechos;
- la parte local realizada por Codex haya finalizado con PASS;
- Codex se haya detenido antes de cualquier operación remota;
- Francisco haya completado el paso manual de creación/login/link;
- el resultado manual haya sido compartido de forma sanitizada;
- se haya confirmado que el proyecto remoto es exclusivamente Development;
- `supabase/config.toml` y el baseline reproducible estén presentes;
- no exista dependencia de Docker para continuar el workflow aprobado;
- no exista schema funcional adelantado;
- no exista migration funcional adelantada;
- no exista Auth/tenancy/RLS adelantado;
- no exista integración de aplicación;
- no exista `service-role`;
- no existan secretos versionados;
- lint/typecheck/test/build/verify y `git diff --check` pasen;
- el diff haya sido revisado desde arquitectura, seguridad y regresiones;
- `/docs` permanezca intacto durante la implementación técnica;
- no exista CI;
- no exista Fase 2+;
- no exista commit/push por Codex;
- una revisión humana posterior acepte expresamente el resultado;
- quede documentado que `db push --dry-run` es sólo inventario previo y no validación SQL ni prueba de ejecución;
- quede documentado que Development será el primer entorno de ejecución real de cualquier migration futura autorizada en este workflow sin Docker;
- quede documentado que un fallo de `db push` en Development bloquea la continuación hasta una corrección versionada o procedimiento formal, sin reparación manual improvisada del schema y sin avance a otro entorno.

Estas tres últimas condiciones documentan el workflow futuro y no autorizan migrations funcionales dentro de Fase 1.

Cerrar la implementación corregida de `TASK-005` no cierra por sí solo Fase 1: el Gate documental de Fase 1 debe sincronizarse con esta estrategia antes del cierre formal de la fase.

# 35. Instrucciones para Codex

Cuando se inicie la implementación autorizada de `TASK-005` bajo `CORR-002`, Codex debe:

1. leer íntegramente todas las fuentes obligatorias de `TASK-005` y `CORR-002`;
2. tratar `CORR-002` como override únicamente de las cláusulas expresamente sustituidas;
3. verificar documentación oficial vigente de Supabase antes de actuar;
4. inspeccionar el repositorio real primero;
5. repetir preflight Git;
6. registrar `HEAD` inicial;
7. exigir worktree limpio;
8. inspeccionar package files y lockfile;
9. inspeccionar `.gitignore`;
10. inspeccionar `.env*` y `.env.example` sin exponer valores;
11. inspeccionar `src/infrastructure/config/`;
12. inspeccionar referencias Supabase existentes;
13. inspeccionar si existe `supabase/`;
14. no inspeccionar/reparar Docker como dependencia del flujo;
15. instalar exclusivamente `supabase@2.114.0` como `devDependency` cuando siga siendo la versión aprobada por esta corrección;
16. no instalar globalmente;
17. no usar `latest`;
18. no usar beta;
19. registrar versión efectiva;
20. ejecutar `npx supabase init` sólo si no requiere `--force`;
21. inspeccionar todos los archivos generados;
22. verificar que estado temporal no sea versionado;
23. no ejecutar `supabase start`;
24. no ejecutar `supabase status`;
25. no ejecutar `supabase stop`;
26. no ejecutar `supabase login`;
27. no ejecutar `supabase link`;
28. no ejecutar `db push --dry-run`;
29. no ejecutar `db push`;
30. no ejecutar `db pull`, `db dump` ni `db diff`;
31. no ejecutar ninguna operación remota;
32. no recibir Personal Access Token;
33. no recibir database password;
34. no recibir `service-role`;
35. no leer credential storage;
36. no acceder al Dashboard;
37. no crear proyecto Cloud;
38. no instalar `@supabase/supabase-js`;
39. no instalar `@supabase/ssr`;
40. no añadir variables Supabase a la aplicación;
41. no modificar `TASK-004`;
42. no modificar `TASK-005`;
43. no modificar `/docs`;
44. no crear schema funcional;
45. no crear migrations funcionales;
46. no crear seeds funcionales;
47. no implementar Auth;
48. no implementar tenancy;
49. no implementar RLS;
50. no implementar Storage/Realtime funcional;
51. no configurar CI;
52. preservar TypeScript strict/noEmit;
53. preservar skeleton/aliases/boundaries;
54. ejecutar lint/typecheck/test/build/verify;
55. ejecutar `git diff --check`;
56. revisar el diff completo;
57. listar todos los archivos creados/modificados;
58. emitir resultado local PASS/FAIL/BLOCKER;
59. si PASS, detenerse y entregar instrucciones exactas para Francisco;
60. no continuar automáticamente después del paso manual;
61. no commit;
62. no push;
63. no generar `TASK-006`.

Ante cualquier necesidad de ampliar estos permisos, Codex debe detenerse con `BLOCKER`.

# 36. Instrucciones para Francisco

Cuando la implementación local haya finalizado con PASS y el Gate solicite la parte manual, Francisco debe:

1. crear manualmente un único proyecto Supabase destinado a `Development`;
2. confirmar que no utiliza datos reales ni secretos productivos;
3. elegir conscientemente organización, plan y región adecuados para desarrollo;
4. no crear Staging;
5. no crear Production;
6. no habilitar Branching por suposición;
7. ejecutar manualmente `npx supabase login`;
8. no compartir el Personal Access Token;
9. ejecutar manualmente `npx supabase link --project-ref <PROJECT_REF>`;
10. introducir el `PROJECT_REF` localmente;
11. introducir la database password localmente cuando la CLI lo solicite y sea necesaria;
12. no compartir la database password;
13. no compartir `service-role`, JWT secret ni claves privadas;
14. revisar que el proyecto linked sea el Development correcto;
15. sanitizar cualquier salida antes de compartirla;
16. compartir sólo PASS/FAIL/BLOCKER y errores no sensibles;
17. no ejecutar `db push` en Fase 1 si no existe migration funcional autorizada;
18. no ejecutar `db reset --linked`;
19. no crear tablas de producto en Dashboard;
20. no configurar Auth/RLS/Storage/Realtime funcional;
21. no crear variables de aplicación;
22. detener el proceso y pedir revisión si aparece una operación destructiva o una credencial inesperada.

Cuando una tarea futura autorice una migration, Francisco debe seguir exactamente esta secuencia:

1. confirmar que Codex/humano realizó la revisión estática del SQL y que la migration autorizada existe físicamente bajo `supabase/migrations/`;
2. ejecutar `npx supabase db push --dry-run` contra el proyecto linked de `Development`;
3. interpretar el `dry-run` exclusivamente como inventario de migrations pendientes y su orden, nunca como validación SQL, prueba de ejecución, simulación transaccional ni garantía de éxito;
4. revisar humanamente que el conjunto y orden inventariados coincidan exactamente con la tarea autorizada y detenerse si aparece cualquier migration inesperada;
5. ejecutar `npx supabase db push` exclusivamente contra `Development`; esta es la primera ejecución real de la migration dentro del workflow sin Docker;
6. comprobar el resultado real de la aplicación en Development;
7. cuando la tarea lo requiera, ejecutar una comprobación remota manual no destructiva como `npx supabase migration list --linked` para contrastar el historial;
8. compartir únicamente evidencia sanitizada suficiente para PASS/FAIL/BLOCKER;
9. esperar y completar el Gate posterior antes de cualquier continuación.

Si `npx supabase db push` falla en `Development`, Francisco debe:

- detener el workflow;
- no repetir ciegamente el push;
- no avanzar a otro entorno;
- no abrir Production ni aplicar allí la migration;
- no corregir manualmente el schema desde Dashboard o SQL Editor;
- no ejecutar `migration repair`, `db reset --linked` ni otro mecanismo de reparación improvisado;
- inspeccionar el estado remoto mediante las operaciones manuales no destructivas expresamente autorizadas por la tarea;
- compartir el error y estado relevante de forma sanitizada;
- esperar la definición formal de una migration correctiva/versionado apropiado o del procedimiento formal que corresponda antes de continuar.

Toda operación anterior permanece bajo la frontera:

`remoto/autenticado = Francisco`

# 37. Resultado esperado

Después de una implementación futura exitosa de `TASK-005` corregida por `CORR-002`, el baseline esperado será:

- Fase 1 todavía en progreso;
- Fase 2 no iniciada;
- `TASK-005` original preservada;
- `CORR-002` incorporada como corrección aplicable;
- Supabase CLI reproducible como `devDependency`;
- versión CLI exacta pinneada;
- `package-lock.json` coherente;
- `supabase/` inicializado mediante CLI;
- `supabase/config.toml` versionable presente;
- estado temporal de CLI fuera de Git;
- ningún stack Supabase local;
- Docker no requerido para el workflow aprobado;
- exactamente un proyecto Supabase Cloud de Development creado manualmente;
- proyecto linked manualmente por Francisco;
- Codex sin acceso Supabase;
- Codex sin tokens/passwords;
- operaciones remotas manuales;
- Git/migrations definidos como futura fuente de verdad de schema;
- `db pull` fuera del workflow normal por dependencia de Docker;
- `db push --dry-run` definido exclusivamente como inventario manual de migrations pendientes y su orden, sin semántica de validación SQL ni garantía de ejecución;
- `db push` manual reservado a futuras migrations autorizadas y ejecutado primero exclusivamente contra Development;
- Development definido como primer entorno de ejecución real de migrations en este workflow sin Docker;
- revisión estática SQL separada del dry-run y separada de la ejecución real;
- comprobación posterior y evidencia sanitizada obligatorias después de cualquier futura aplicación de migration;
- un fallo futuro de `db push` en Development bloquea el workflow hasta una corrección versionada o procedimiento formal, sin reparación manual improvisada del schema y sin avance a otro entorno;
- comprobaciones remotas no destructivas como `migration list --linked` sólo cuando una tarea las autorice y siempre ejecutadas manualmente por Francisco;
- no schema funcional;
- no migrations funcionales de Fase 1;
- no Auth funcional;
- no tenancy;
- no RLS ejecutable;
- no Storage funcional;
- no Realtime funcional desde app;
- no `service-role`;
- no variables Supabase en `TASK-004`;
- no cliente Supabase en la app;
- no CI;
- no Staging;
- no Production;
- lint/typecheck/test/build/verify PASS;
- `git diff --check` PASS;
- no commit/push por Codex;
- `TASK-006` no generada.

# 38. ADR requerido

**Decisión:**

`ADR nuevo NO requerido`

## Justificación

`CORR-002` modifica una estrategia operativa de desarrollo motivada por una restricción del host, pero no cambia:

- proveedor: continúa Supabase;
- base de datos del producto: continúa Supabase PostgreSQL;
- Auth previsto: continúa Supabase Auth;
- Storage previsto: continúa Supabase Storage;
- RLS: continúa obligatorio;
- tenant model: continúa `MaintenanceCompany`;
- arquitectura: continúa monolito modular Next.js;
- boundaries de producto;
- despliegue productivo;
- schema;
- autorización funcional;
- fases de producto.

La decisión es reversible: si posteriormente existe un host Docker-compatible aprobado, puede recuperarse un entorno local mediante otra decisión de tooling sin rediseñar el producto.

El registro maestro distingue decisiones arquitectónicas de decisiones técnicas menores/reversibles, y el Gate de Fase 1 no exige inventar ADRs para setup. La formalidad necesaria aquí se satisface mediante `CORR-002` porque se modifica una tarea ya aprobada y su Gate operativo.

## Cuándo reevaluar un ADR

Debe reevaluarse si en el futuro se pretende convertir alguna de estas condiciones en arquitectura transversal permanente, por ejemplo:

- Cloud-only como política obligatoria para todos los desarrolladores y entornos;
- automatización de migrations hacia Staging/Production;
- cambio del modelo de entornos o branching;
- gestión centralizada de credenciales para CI/CD;
- estrategia de deployment remoto que afecte producción;
- sustitución de Supabase por otro proveedor;
- una frontera nueva con impacto transversal, costosa de revertir o de seguridad material no cubierta por ADR existentes.

## Documento afectado que debe sincronizarse

Aunque no se requiere ADR, la aprobación de `CORR-002` modifica una condición anterior de `docs/product/11-phase-1-scope-entry-gate.md`.

Por tanto, antes del cierre formal de Fase 1 debe emitirse una corrección documental mínima de `11` que reemplace exclusivamente los criterios de `Supabase local operativo/arrancable` por el baseline Development corregido, preservando:

- nombre/orden de fases mientras no exista una decisión distinta;
- no schema en Fase 1;
- no Auth/tenancy/RLS en Fase 1;
- CI como paso separado;
- Gate de Fase 2;
- `ADR-0003` como requisito previo a identidad/autorización.

# 39. Gate posterior

El estado actual de este documento es:

`APPROVED FOR IMPLEMENTATION`

La aprobación documental no ejecuta Codex automáticamente.

El Gate posterior propuesto es:

`CORR-002 APPROVED FOR IMPLEMENTATION`
-> `incorporación canónica de CORR-002`
-> `autorización separada para reintentar TASK-005 bajo TASK-005 + CORR-002`
-> `Codex ejecuta exclusivamente preparación local sin Docker ni acceso remoto`
-> `Codex informa PASS/FAIL/BLOCKER y se detiene`
-> `si PASS: Francisco crea Development + login + link manual`
-> `Francisco comparte resultado sanitizado`
-> `revisión humana de arquitectura, seguridad, diff y Gate remoto`
-> `cierre formal de TASK-005 corregida`
-> `sincronización documental mínima de 11-phase-1-scope-entry-gate.md antes del cierre de Fase 1`
-> `sólo entonces evaluar el siguiente paso de Fase 1`

Queda expresamente prohibido en este Gate:

- ejecutar automáticamente `TASK-006`;
- configurar CI automáticamente;
- iniciar Fase 2;
- crear schema de producto;
- crear Auth/tenancy/RLS;
- ejecutar operaciones remotas por Codex;
- crear Production;
- crear Staging por anticipación.

**Estado final de CORR-002 en esta entrega:** `APPROVED FOR IMPLEMENTATION`.

**Codex ejecutado durante esta definición:** no.

**Repositorio modificado durante esta definición:** no.

**Proyecto Supabase creado durante esta definición:** no.
