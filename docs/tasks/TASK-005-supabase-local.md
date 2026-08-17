# 1. ID

`TASK-005`

# 2. Título

`Baseline reproducible de Supabase local`

# 3. Fase

`Fase 1 — Setup, repositorio, CI y Supabase local`

Correspondencia dentro del orden vigente de Fase 1:

`Paso 6 — Supabase local`

Esta tarea cubre exclusivamente la infraestructura local reproducible de Supabase necesaria para desarrollo.

No incluye `Paso 7 — CI` ni ninguna capacidad funcional de Fase 2 o posterior.

# 4. Estado

`APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`TASK-005-supabase-local-approved.md`

**Ruta canónica futura:**

`docs/tasks/TASK-005-supabase-local.md`

Este documento constituye una definición previa a implementación.

Este documento está formalmente aprobado para implementación y su incorporación canónica futura corresponde a la ruta indicada.

# 5. Objetivo

Incorporar una baseline mínima, segura y reproducible de Supabase para desarrollo local, de modo que un desarrollador pueda clonar el repositorio, instalar las dependencias autorizadas, disponer de un runtime de contenedores compatible con la API de Docker y ejecutar de forma repetible el ciclo local de Supabase.

El resultado futuro de `TASK-005` debe permitir:

- disponer de Supabase CLI como tooling del proyecto y no como dependencia global asumida;
- reproducir la versión de la CLI mediante `package.json` y `package-lock.json`;
- inicializar la configuración local mediante el flujo oficial de Supabase;
- disponer de `supabase/` en la raíz del repositorio cuando la inicialización oficial lo genere;
- conservar `supabase/config.toml` como configuración local versionable;
- iniciar el stack local con los servicios que el baseline oficial habilite por defecto;
- comprobar el estado y salud del stack mediante la CLI;
- detener el stack limpiamente al finalizar la validación;
- documentar los comandos mínimos de uso local;
- preservar íntegramente el baseline de calidad, arquitectura y configuración ya incorporado.

El principio central es:

`infraestructura local reproducible de Supabase`

NO:

`modelo de datos del producto`

La existencia de PostgreSQL, Auth, Storage, Realtime u otros servicios dentro del stack local no autoriza implementar ninguna capacidad funcional del SaaS.

# 6. Contexto normativo

Esta tarea se encuentra restringida por las siguientes fuentes obligatorias:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`;
- `docs/tasks/TASK-001-bootstrap-nextjs.md`;
- `docs/tasks/CORR-001-typescript-tooling-compatibility.md`;
- `docs/tasks/TASK-002-tooling-base.md`;
- `docs/tasks/TASK-003-modular-skeleton.md`;
- `docs/tasks/TASK-004-environment-secrets.md`;
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`.

Para hechos operativos de Supabase CLI y desarrollo local, esta definición consume además la documentación oficial vigente de Supabase consultada el `2026-08-17`, en particular:

- `Supabase Docs — Local Development — Supabase CLI`;
- `Supabase Docs — Local development workflow`;
- `Supabase Docs — CLI Reference`;
- `Supabase Docs — Supabase CLI config`.

Las fuentes oficiales vigentes establecen, dentro del alcance relevante para esta tarea, que:

- la CLI puede instalarse como dependencia de desarrollo del proyecto mediante npm;
- cuando se instala como dependencia del proyecto se ejecuta mediante el package runner, por ejemplo `npx supabase <command>`;
- la versión debe pinnearse en `package.json` para que el equipo utilice una versión común;
- la CLI requiere Node.js `20` o posterior cuando se ejecuta mediante `npx` o npm;
- el flujo local básico utiliza `supabase init` seguido de `supabase start`;
- `supabase init` crea `supabase/config.toml` y el directorio `supabase/` es apto para versionado, excluyendo estado temporal interno;
- el stack local utiliza contenedores y requiere Docker o un runtime con APIs compatibles con Docker;
- `supabase start` arranca por defecto los servicios del stack y aplica health checks;
- `supabase status` permite inspeccionar el estado local;
- `supabase stop` detiene el stack y conserva los recursos/datos locales por defecto;
- el stack local es sólo para desarrollo, no está endurecido para producción y no debe exponerse a tráfico externo.

El baseline de proyecto vigente consumido por esta tarea es:

- Fase 0: `COMPLETADA`;
- Gate de entrada a Fase 1: vigente;
- `TASK-001`: `DONE`;
- `CORR-001`: `DONE`;
- `TASK-002`: `DONE`;
- `TASK-003`: `DONE`;
- `TASK-004`: `DONE`;
- commit de implementación de `TASK-004`: `8fdaf11`;
- Next.js `16.3.1`;
- React `19.2.8`;
- TypeScript `6.0.3`;
- TypeScript `strict: true`;
- `noEmit: true`;
- Tailwind CSS `4.3.3`;
- ESLint `9.39.2`;
- Vitest `4.1.10`;
- lint, typecheck, tests base, build y verify operativos;
- skeleton modular incorporado;
- contrato de configuración/secretos incorporado;
- `.env.example` incorporado;
- ownership de configuración reservado en `src/infrastructure/config/`;
- acceso directo a `process.env` restringido fuera de esa zona;
- package manager: `npm`;
- Node.js `22.23.1`;
- repositorio en `main`;
- `origin/main` sincronizado según el último estado recibido;
- worktree limpio según el último estado recibido;
- Fase 1 en progreso;
- Fase 2 no iniciada.

Node.js `22.23.1` satisface el requisito vigente de Node.js `20+` de Supabase CLI ejecutada mediante npm/npx. La implementación debe verificar nuevamente la documentación oficial y el runtime real antes de instalar la CLI, porque esta especificación no sustituye el preflight.

`docs/product/11-phase-1-scope-entry-gate.md` permite Supabase local como infraestructura de Fase 1 y prohíbe convertir ese setup en schema, migrations o RLS de producto. Aunque el Gate permite una comprobación técnica de conectividad de la aplicación con Supabase local sin dominio, esa capacidad es permisiva y no obligatoria. `TASK-005` adopta deliberadamente el alcance más estrecho:

`Supabase local operativo, pero aplicación todavía no integrada`.

`ADR-0001` permanece intacto: una única aplicación Next.js, un único deployable principal y fronteras internas claras.

`ADR-0002` permanece intacto: la futura base compartida, tenant ownership, tenant resolution autoritativa, RLS obligatoria y uso restringido de credenciales privilegiadas no se implementan en esta tarea.

No se detecta una contradicción material entre las fuentes obligatorias que bloquee la definición de `TASK-005`.

La elección de Supabase CLI como `devDependency` exacta, estable y reproducible es una decisión técnica local y reversible dentro de Fase 1. No requiere un ADR nuevo.

# 7. Precondiciones

Antes de realizar cualquier cambio de implementación, Codex debe:

1. verificar que `TASK-005` haya sido revisada y formalmente autorizada para implementación;
2. leer íntegramente todas las fuentes obligatorias indicadas en esta tarea;
3. verificar nuevamente la documentación oficial vigente de Supabase para CLI y desarrollo local;
4. inspeccionar el repositorio real antes de modificar archivos;
5. repetir el preflight Git inmediatamente antes del primer cambio;
6. verificar que el repositorio sea Git válido;
7. verificar branch `main`, salvo que una decisión posterior formalmente incorporada establezca otra base;
8. verificar upstream esperado y divergencia con `origin/main`;
9. verificar worktree limpio;
10. registrar el `HEAD` inicial como evidencia de preflight;
11. verificar que `/docs` esté presente e íntegro;
12. verificar que `TASK-001`, `CORR-001`, `TASK-002`, `TASK-003` y `TASK-004` estén efectivamente incorporadas y cerradas;
13. confirmar las versiones reales de Next.js, React, TypeScript, Node.js y npm;
14. confirmar `strict: true` y `noEmit: true` efectivos;
15. confirmar que `npm run lint`, `npm run typecheck`, `npm run test`, `npm run build` y `npm run verify` existen y están operativos;
16. inspeccionar `package.json`;
17. inspeccionar `package-lock.json` y confirmar que continúa existiendo un único lockfile;
18. inspeccionar `tsconfig.json`;
19. inspeccionar `eslint.config.*` o configuración equivalente;
20. inspeccionar la configuración de Vitest;
21. inspeccionar `.gitignore`;
22. localizar e inspeccionar todos los `.env*` existentes y determinar cuáles están trackeados;
23. inspeccionar `.env.example`;
24. inspeccionar `src/infrastructure/config/`;
25. localizar referencias existentes a `process.env` y `NEXT_PUBLIC_`;
26. localizar cualquier referencia existente a Supabase, `supabase`, `@supabase/*`, URLs/keys de Supabase o configuración equivalente;
27. comprobar si ya existe `supabase/`;
28. comprobar si ya existe `supabase/config.toml`;
29. comprobar si existe configuración parcial, migrations, seeds, schemas, functions o tests Supabase previos;
30. inspeccionar si existen contenedores o proyectos Supabase locales potencialmente relacionados con este repositorio;
31. identificar un runtime compatible con la API de Docker sin asumir de antemano cuál utiliza el host;
32. registrar el runtime detectado y su versión cuando pueda determinarse de forma segura;
33. comprobar que el runtime esté operativo y acepte las operaciones necesarias para Supabase local;
34. comprobar que no haya conflictos de puertos o recursos que requieran afectar contenedores/proyectos ajenos;
35. comprobar que no exista un proyecto Supabase remoto vinculado como parte del estado del repositorio;
36. comprobar que no exista funcionalidad de Fase 2+ incorporada inesperadamente;
37. no asumir que el último estado recibido sustituye la inspección del repositorio real.

Debe reportarse `BLOCKER` y detenerse la implementación si:

- el worktree no está limpio y no puede aislarse `TASK-005`;
- el branch/upstream real contradice materialmente el baseline esperado;
- alguna tarea previa no está realmente cerrada;
- el repositorio contradice materialmente el stack declarado;
- existe una configuración Supabase previa incompatible cuya sustitución requiera sobrescritura destructiva o una decisión fuera de alcance;
- completar la tarea exige `supabase init --force`;
- no existe un runtime Docker-compatible operativo;
- el runtime no puede iniciar los servicios requeridos por el baseline oficial;
- existe un conflicto de puertos que no puede resolverse dentro de alcance sin afectar recursos ajenos;
- existe un proyecto remoto enlazado y continuar exigiría modificar o utilizar esa vinculación;
- completar la tarea exige `supabase login`, `supabase link` o cualquier operación contra Supabase Cloud;
- completar la tarea exige introducir una dependencia material distinta de `supabase` CLI;
- completar la tarea exige `@supabase/supabase-js`, `@supabase/ssr` u otro cliente de aplicación;
- completar la tarea exige añadir variables Supabase al contrato de la aplicación;
- completar la tarea exige introducir `SUPABASE_SERVICE_ROLE_KEY` o equivalente en la aplicación;
- completar la tarea exige schema, migrations o seeds funcionales;
- completar la tarea exige Auth funcional, tenancy, RLS, Storage funcional o Realtime funcional;
- completar la tarea exige modificar un ADR aceptado o resolver un `DO-*` / `*-OPEN-*`;
- completar la tarea exige cambiar framework, package manager o arquitectura;
- completar la tarea exige avanzar a Fase 2 o posterior;
- existe un secreto real versionado o expuesto cuya remediación exceda el alcance de esta tarea.

Un `BLOCKER` relacionado con secretos debe describir la categoría y ubicación sin copiar el valor secreto.

# 8. Principios de Supabase local

`TASK-005` debe preservar los siguientes principios:

1. **Infraestructura, no dominio.** El stack local existe para habilitar desarrollo posterior; no contiene modelo físico del SaaS introducido por esta tarea.
2. **Reproducibilidad desde el repositorio.** La configuración versionable y la versión de CLI deben permitir repetir el setup en otra máquina compatible.
3. **CLI del proyecto.** No se depende de una instalación global de Supabase CLI.
4. **Runtime externo.** Docker o un runtime compatible es una precondición del host, no una dependencia que la tarea instala o repara.
5. **Baseline oficial mínima.** Se conserva la configuración generada por la CLI y sus defaults salvo necesidad concreta documentada.
6. **Servicios disponibles no equivalen a features.** Que Auth, Storage, Realtime u otros servicios estén levantados localmente no implementa producto.
7. **No conexión remota.** Toda operación de `TASK-005` debe permanecer local.
8. **No credenciales de producto.** Las credenciales emitidas por el stack son credenciales locales de desarrollo y no se incorporan al contrato Next.js.
9. **No schema artificial.** No se crean tablas, migrations o seeds únicamente para demostrar que PostgreSQL funciona.
10. **No bypass de salud.** Los health checks del CLI forman parte de la validación; no se ignoran para conseguir un falso `PASS`.
11. **No limpieza global.** La tarea no administra el runtime de contenedores como recurso global del host.
12. **Final limpio.** Tras validar el ciclo, el stack debe quedar detenido salvo un motivo material documentado.
13. **TASK-004 preservada.** El contrato de entorno existente no se amplía preventivamente por el hecho de que la CLI muestre URLs o keys locales.
14. **RLS futura intacta.** No implementar RLS ahora no debilita su obligatoriedad futura sobre datos tenant-owned.
15. **Sin resolución implícita de decisiones.** Ningún detalle del stack local resuelve decisiones funcionales o arquitectónicas abiertas de fases posteriores.

# 9. Supabase CLI y estrategia de versionado

La estrategia propuesta para `TASK-005` es:

- paquete npm: `supabase`;
- clasificación: `devDependency`;
- versión: una versión **estable** vigente, verificada contra la documentación oficial al momento de implementación;
- pin: versión exacta en `package.json`, sin `^`, `~`, `latest` flotante ni tag `beta`;
- lock: resolución reproducible en `package-lock.json`;
- ejecución: `npx supabase <command>` desde el proyecto;
- instalación global asumida: no;
- `npm install -g supabase`: prohibido;
- beta/pre-release: prohibida salvo una nueva necesidad material revisada separadamente.

La implementación debe preferir una instalación conceptualmente equivalente a:

`npm install --save-dev --save-exact supabase@<VERSION_ESTABLE_VERIFICADA>`

La versión concreta debe decidirse durante la implementación después de verificar:

- que es estable;
- que corresponde al canal estable oficial;
- que soporta la plataforma/runtime real;
- que Node.js del repositorio cumple los requisitos vigentes;
- que no requiere forzar dependencias;
- que no obliga a actualizar paquetes ajenos.

La implementación debe registrar:

- versión exacta instalada;
- versión efectiva devuelta por la CLI;
- cambios inevitables de lockfile;
- ausencia de actualización deliberada de otras dependencias.

No se debe usar una invocación efímera como `npx supabase@latest ...` sin haber incorporado primero la dependencia pinneada al proyecto, porque rompería la intención de reproducibilidad de esta tarea.

# 10. Runtime de contenedores

Supabase local requiere un runtime de contenedores disponible y operativo.

`TASK-005` lo clasifica como:

`precondición externa de desarrollo`

La implementación debe:

- detectar qué runtime compatible con la API de Docker está disponible en el host;
- comprobar que su daemon/servicio o mecanismo equivalente está operativo;
- registrar el nombre del runtime y su versión cuando pueda obtenerse sin alterar el host;
- verificar que puede ejecutar las operaciones necesarias para `npx supabase start`;
- no imponer Docker Desktop cuando otro runtime oficialmente compatible ya satisface el requisito;
- no asumir particularidades de Windows, WSL, Hyper-V, Podman u otra tecnología sin inspección real;
- no instalar el runtime;
- no repararlo;
- no habilitar componentes globales del sistema operativo;
- no cambiar settings globales del runtime;
- no ejecutar mantenimiento general del host.

La documentación oficial vigente recomienda al menos `7 GB` de RAM para arrancar todos los servicios. Esta cifra se trata como recomendación operativa, no como un requisito de producto. El criterio efectivo de esta tarea es que el stack pueda iniciar y superar sus health checks sin modificar la máquina fuera de alcance.

Queda prohibido ejecutar como mecanismo de resolución:

- `docker system prune`;
- eliminación masiva de imágenes;
- eliminación de contenedores ajenos;
- eliminación de volúmenes ajenos;
- detención global de proyectos Supabase locales;
- cualquier operación equivalente sobre otro runtime que afecte recursos fuera de este repositorio.

Si el runtime está ausente, inoperativo o no puede ejecutar el stack, el resultado es `BLOCKER`.

# 11. Inicialización y estructura supabase/

La baseline propuesta incluye:

`supabase/` en la raíz del repositorio: **sí**.

La implementación debe, después del preflight y de instalar/verificar la CLI:

1. confirmar nuevamente que no existe una inicialización previa incompatible;
2. ejecutar el flujo oficial local equivalente a `npx supabase init` desde la raíz del repositorio;
3. no utilizar `--force`;
4. inspeccionar inmediatamente todos los archivos y directorios generados por la versión real de CLI;
5. clasificar cada artefacto como:
   - configuración reproducible/versionable;
   - infraestructura vacía o baseline generada;
   - estado local/temporal no versionable;
   - artefacto inesperado que requiere revisión;
6. preservar el output oficial sin personalización manual innecesaria;
7. no crear archivos adicionales únicamente para aproximar ejemplos de documentación.

La documentación oficial establece que `supabase init` crea `supabase/config.toml`; otros objetos como `migrations`, `functions`, `tests`, `schemas`, estado temporal u otros pueden aparecer según la versión, configuración y comandos utilizados.

Por ello esta especificación no inventa un listado rígido adicional. La implementación debe registrar exactamente lo que genere la versión instalada y justificar cualquier modificación manual posterior.

No debe utilizarse `supabase bootstrap`, porque ese flujo puede scaffoldar aplicación, schema y migrations y excede el alcance mínimo de esta tarea.

# 12. Configuración local

`supabase/config.toml` forma parte de la baseline local versionable.

La regla es:

`configuración oficial mínima + sólo cambios estrictamente necesarios para que el stack local funcione en este repositorio`.

La implementación debe:

- conservar puertos default si están disponibles;
- no cambiar puertos por preferencia;
- no deshabilitar servicios por anticipación;
- no configurar OAuth providers;
- no configurar SMTP externo;
- no configurar URLs productivas;
- no añadir API keys o secretos externos;
- no configurar proveedores de terceros;
- no configurar Edge Functions de producto;
- no configurar Storage de producto;
- no configurar Realtime de producto;
- no incorporar IDs de proyecto remoto;
- no enlazar Supabase Cloud.

La propiedad `project_id` que la CLI local genere o requiera en `config.toml` es un identificador local utilizado para distinguir proyectos Supabase en el mismo host. Puede conservarse como parte de la configuración generada y no debe confundirse con un `project-ref` de Supabase Cloud.

Si los puertos default están ocupados por recursos ajenos, la implementación no debe detener dichos recursos. Un cambio de puerto sólo podría evaluarse si:

- afecta exclusivamente a este proyecto;
- no introduce configuración arbitraria o difícil de reproducir;
- no debilita otras restricciones;
- queda documentado y justificado.

Si no puede resolverse dentro de esos límites, debe reportarse `BLOCKER`.

# 13. Lifecycle start / status / stop

La implementación debe demostrar un ciclo local real y completo mediante comandos oficiales de la CLI instalada en el proyecto.

Secuencia mínima:

1. `npx supabase start`;
2. `npx supabase status`;
3. `npx supabase stop`.

Reglas de `start`:

- usar el baseline de servicios default;
- no excluir Auth, Storage, Realtime u otros servicios sólo porque todavía no se utilicen funcionalmente;
- no usar `--ignore-health-check`;
- no reducir el stack por optimización anticipada;
- permitir la descarga normal de imágenes requerida por la CLI;
- no interpretar la creación de infraestructura interna de Supabase como schema de producto.

Reglas de `status`:

- comprobar que el stack se declara en ejecución;
- registrar servicios/endpoints disponibles sin copiar valores sensibles al informe;
- no utilizar `status -o env` para exportar credenciales a archivos de aplicación;
- no copiar `SERVICE_ROLE_KEY`, JWT secret, anon/publishable keys u otros valores generados al documento normativo, `.env.example` o configuración Next.js.

Reglas de `stop`:

- usar `npx supabase stop` para el proyecto actual;
- no usar `--all`;
- no usar `--no-backup` por preferencia;
- no borrar volúmenes sólo para dejar el host “limpio”;
- no afectar instancias Supabase de otros repositorios.

Estado final esperado:

`stack local detenido`

La tarea sólo puede obtener `PASS` si `start` alcanza un estado saludable, `status` confirma el stack y `stop` finaliza correctamente.

# 14. Seguridad del entorno local

El entorno generado por `TASK-005` es exclusivamente de desarrollo.

Queda prohibido:

- tratarlo como producción;
- tratarlo como staging compartido;
- exponerlo deliberadamente a Internet o tráfico externo;
- usarlo para datos reales de clientes;
- importar dumps reales de clientes;
- usar secretos de producción;
- usar credenciales productivas de Supabase;
- reutilizar un service-role productivo;
- copiar credenciales locales hacia servicios remotos;
- enlazarlo con un proyecto Supabase Cloud dentro de esta tarea;
- confiar en defaults locales como controles de producción.

Las credenciales y defaults generados por el stack deben tratarse como:

`credenciales locales de desarrollo emitidas por tooling`

No como:

`secretos o credenciales de aplicación productiva`.

La documentación oficial advierte que el stack local no está endurecido para producción, utiliza defaults de desarrollo y no debe exponerse externamente. `TASK-005` conserva esa frontera como requisito de seguridad.

# 15. Relación con TASK-004 y variables de entorno

`TASK-004` debe permanecer íntegramente preservada.

`TASK-005` no modifica:

- `.env.example`;
- política de `.env*.local`;
- ownership de `src/infrastructure/config/`;
- separación pública/privada;
- clasificación de secretos;
- restricciones de acceso directo a `process.env`;
- reglas de build/runtime;
- prohibición de secretos reales.

Decisión explícita de `TASK-005`:

`no integrar todavía la aplicación Next.js con Supabase local`.

Por tanto, esta tarea no debe añadir al contrato de aplicación:

- `NEXT_PUBLIC_SUPABASE_URL`;
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`;
- `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`;
- `SUPABASE_SERVICE_ROLE_KEY`;
- claves equivalentes;
- URL local de base de datos;
- JWT secret local;
- otros valores emitidos por `supabase status`.

`SUPABASE_SERVICE_ROLE_KEY` o cualquier equivalente privilegiado permanece:

`FUERA DE ALCANCE DEL CONTRATO DE APLICACIÓN`.

No debe:

- agregarse a `.env.example`;
- agregarse a `src/infrastructure/config/`;
- utilizarse desde Next.js;
- utilizarse para preparar Auth;
- utilizarse para tenancy;
- utilizarse para schema o RLS.

Si la CLI necesita estado o credenciales internas para operar localmente, deben permanecer dentro de los mecanismos de la propia CLI/runtime y no convertirse en configuración de la aplicación.

La ausencia de variables Supabase de aplicación en `TASK-005` no contradice el Gate de Fase 1: el Gate permite variables necesarias para conexión de desarrollo, pero no exige conectar la aplicación en este paso. La validación del stack por CLI es suficiente para el alcance definido aquí.

# 16. Schema, migrations y seeds

`TASK-005` no implementa schema funcional del producto.

Queda prohibido crear o diseñar:

- `MaintenanceCompany`;
- usuarios de producto;
- memberships;
- clients;
- locations;
- equipment;
- forms;
- maintenance;
- Evidence;
- reports;
- subscriptions;
- AI credits;
- cualquier otra entidad de dominio;
- columnas funcionales;
- PK/FK funcionales;
- índices funcionales;
- constraints funcionales;
- triggers de producto;
- funciones PostgreSQL de producto.

## Migrations

La infraestructura de migrations puede quedar disponible como capacidad de la CLI, pero esta tarea no debe crear una migration funcional ni una migration vacía para “probar” el mecanismo.

Reglas:

- si `supabase init` no crea `supabase/migrations/`, no crearla manualmente por ceremonia;
- si la versión instalada crea una carpeta vacía o un artefacto de baseline, preservarlo sólo conforme a la clasificación generada por la CLI;
- no crear `initial_schema.sql`;
- no ejecutar `supabase migration new`;
- no ejecutar `supabase db diff` para producir schema;
- no ejecutar `supabase db reset` como requisito de esta tarea;
- no introducir SQL propio del SaaS.

## Seeds

No crear seed funcional.

Queda prohibido:

- crear usuarios fake;
- insertar tenants;
- insertar clientes;
- insertar datos demo del dominio;
- usar datos reales.

Si la versión de `supabase init` genera automáticamente un `seed.sql` vacío, comentado o de baseline, la implementación debe inspeccionarlo y puede conservar el artefacto exacto sólo si forma parte de la inicialización oficial reproducible. No debe agregar datos de producto.

# 17. Auth, Storage y Realtime

La distinción obligatoria es:

`servicio disponible localmente ≠ capacidad funcional implementada`.

## Auth

Auth puede iniciarse como parte del stack default.

Eso no autoriza:

- login;
- signup;
- usuarios de producto;
- códigos de verificación;
- providers OAuth;
- callbacks;
- email de producto;
- sesiones;
- roles;
- memberships;
- invalidación de sesión;
- autorización.

Impacto funcional Auth:

`NO IMPLEMENTADO TODAVÍA`.

## Storage

Storage puede iniciarse como parte del stack default.

Eso no autoriza:

- buckets de producto;
- paths de producto;
- policies;
- uploads;
- Evidence;
- fotografías;
- signed URLs de producto.

Impacto funcional Storage:

`NO IMPLEMENTADO TODAVÍA`.

## Realtime

Realtime puede iniciarse como parte del stack default.

Eso no autoriza:

- channels de producto;
- subscriptions;
- presence;
- broadcasts;
- sincronización de aplicación.

Impacto funcional Realtime:

`NO IMPLEMENTADO TODAVÍA`.

La misma regla aplica a otros servicios que el baseline local pueda levantar: su disponibilidad técnica no implementa un bounded context ni una feature.

# 18. Conexión remota

`TASK-005` debe ser completamente local.

Queda prohibido ejecutar:

- `supabase login`;
- `supabase link`;
- `supabase db pull`;
- `supabase db push`;
- `supabase projects ...` contra la plataforma;
- creación de proyecto Supabase Cloud;
- operaciones de secrets remotos;
- deploy de Edge Functions;
- cualquier otro comando cuyo objetivo sea operar contra un proyecto remoto.

No debe pedirse ni utilizarse:

- Personal Access Token;
- project ref remoto;
- password de base remota;
- credencial de producción/staging.

No debe ejecutarse una operación cuyo default pueda actuar sobre un proyecto `--linked` sin que sea estrictamente local y necesaria para esta tarea.

No existe conexión a producción ni staging dentro de `TASK-005`.

# 19. Scripts y ergonomía

Decisión de `TASK-005`:

`no añadir wrappers npm para Supabase por defecto`.

Los comandos canónicos de esta tarea son suficientemente explícitos:

- `npx supabase start`;
- `npx supabase status`;
- `npx supabase stop`.

La CLI queda ya reproducible por ser una `devDependency` exacta del proyecto. Añadir wrappers equivalentes no aporta por sí solo una frontera, validación o comportamiento adicional y aumentaría superficie de mantenimiento.

Por tanto:

- `npm run verify` permanece sin cambios;
- no se integra el arranque de Docker/Supabase dentro de `verify`;
- no se fuerza a todos los checks de aplicación a depender de un runtime de contenedores externo;
- no se crean scripts `supabase:*` sólo por conveniencia estética.

Si el repositorio real contiene una convención previa material que haga necesario un wrapper para preservar consistencia, Codex no debe introducirlo silenciosamente: debe justificarlo en el informe y, si cambia el alcance material, reportar `BLOCKER` para revisión.

La documentación técnica mínima debe indicar los tres comandos `npx` y la precondición del runtime.

# 20. Dentro de alcance

`TASK-005` puede realizar exclusivamente:

- inspección de precondiciones;
- preflight Git y registro de `HEAD`;
- verificación de Node.js/npm;
- verificación de un runtime Docker-compatible;
- registro del runtime y versión cuando sea posible;
- incorporación de `supabase` CLI como `devDependency` estable y exacta;
- cambios inevitables en `package.json` y `package-lock.json` derivados de esa dependencia;
- ejecución de `npx supabase init` sin `--force`;
- creación del baseline `supabase/` generado oficialmente;
- versionado de `supabase/config.toml` y otros artefactos reproducibles que la CLI genere y corresponda conservar;
- preservación/ajuste mínimo de ignores sólo cuando la CLI o la clasificación de archivos lo requiera;
- `npx supabase start`;
- comprobación de salud y `npx supabase status`;
- `npx supabase stop`;
- documentación técnica no normativa mínima de uso local;
- registro de servicios levantados sin registrar credenciales;
- verificación de lint, typecheck, tests, build y verify;
- `git diff --check`;
- informe final de implementación;
- estado final del stack detenido.

# 21. Fuera de alcance

Queda explícitamente fuera de `TASK-005`:

- Supabase Cloud;
- creación de proyecto remoto;
- `supabase login`;
- `supabase link`;
- `supabase db pull`;
- `supabase db push`;
- `supabase bootstrap`;
- producción;
- staging;
- deploy;
- secretos productivos;
- service-role en la aplicación;
- variables Supabase en `.env.example`;
- variables Supabase en `src/infrastructure/config/`;
- conexión Next.js → Supabase;
- `@supabase/supabase-js`;
- `@supabase/ssr`;
- cliente SSR/browser de Supabase;
- persistencia de aplicación;
- schema funcional;
- tablas de producto;
- migrations funcionales;
- migration vacía de prueba;
- seeds funcionales;
- SQL de producto;
- Auth funcional;
- login;
- signup;
- sesiones;
- roles;
- tenancy;
- tenant resolution;
- support grants;
- RLS;
- policies;
- helper functions de autorización;
- pruebas funcionales de RLS;
- Storage funcional;
- buckets;
- paths;
- policies de Storage;
- Realtime funcional;
- Edge Functions;
- Database Functions de producto;
- triggers;
- formularios;
- clientes;
- ubicaciones;
- equipos;
- mantenimientos;
- Evidence;
- Offline;
- Dexie;
- IndexedDB;
- Service Worker;
- Reporting;
- PDF/DOCX;
- OpenAI;
- créditos IA;
- Mercado Pago;
- Subscription;
- Resend;
- CI;
- GitHub Actions;
- Vercel;
- E2E;
- Playwright;
- Cypress;
- Fase 2+;
- `TASK-006`.

# 22. Archivos/categorías de archivos esperados

La futura implementación puede modificar o crear únicamente las siguientes categorías, sujetas a inspección real:

## Package manifest y lockfile

- `package.json` — únicamente para incorporar `supabase` como `devDependency` exacta;
- `package-lock.json` — únicamente para la resolución reproducible de esa dependencia y cambios transitivos inevitables.

No deben existir upgrades deliberados de dependencias no relacionadas.

## Baseline Supabase generado

- `supabase/config.toml` — esperado y versionable;
- otros archivos/directorios que `npx supabase init` genere realmente en la versión instalada — deben inspeccionarse antes de decidir si son versionables;
- `supabase/.temp/`, `supabase/.branches/` o equivalentes de estado interno — no deben versionarse cuando la CLI los clasifique como temporales/locales;
- `supabase/migrations/`, `supabase/seed.sql`, `supabase/schemas/`, `supabase/functions/` o `supabase/tests/` — no deben crearse manualmente por esta tarea; si algún artefacto vacío/de baseline aparece automáticamente, debe inspeccionarse y conservarse sólo cuando corresponda al output oficial reproducible, sin contenido funcional.

## Ignore rules

- `.gitignore` raíz — sólo si es estrictamente necesario y sin debilitar reglas existentes;
- ignore local generado bajo `supabase/`, si la CLI lo crea — inspeccionar y preservar conforme al output oficial;
- reglas `.env*` de `TASK-004` — no debilitar ni sustituir.

## Documentación técnica no normativa

- preferentemente un archivo técnico ya existente, por ejemplo `README.md`, si necesita incorporar una sección mínima de Supabase local;
- si no existe una ubicación adecuada, puede crearse un único documento técnico no normativo mínimo, sin modificar `/docs`.

## Archivos que no deben modificarse

Salvo un `BLOCKER` que detenga la tarea antes de hacerlo, deben permanecer intactos:

- `app/`;
- `src/modules/`;
- `src/shared/`;
- `src/infrastructure/config/`;
- `.env.example`;
- `tsconfig.json`;
- configuración de ESLint;
- configuración de Vitest;
- documentación normativa bajo `/docs`;
- tareas canónicas previas;
- ADR aceptados.

# 23. Dependencias

La única dependencia nueva autorizada por defecto es:

`supabase`

Clasificación:

`devDependency`

Estrategia:

`versión estable exacta + package-lock.json + ejecución npx`.

No se autoriza automáticamente:

- `@supabase/supabase-js`;
- `@supabase/ssr`;
- Zod;
- dotenv;
- Docker SDKs;
- PostgreSQL client libraries;
- wrappers de PostgreSQL;
- Prisma;
- Drizzle;
- ORM alguno;
- librerías de migrations adicionales;
- librerías de Auth;
- ninguna otra dependencia.

Si una dependencia distinta de `supabase` parece necesaria para completar el alcance mínimo, Codex debe detenerse con `BLOCKER` o presentar la necesidad para aprobación separada. No debe ampliarla silenciosamente.

# 24. Restricciones de implementación

La futura implementación debe cumplir todas las siguientes restricciones:

- trabajar únicamente sobre `TASK-005`;
- no implementar antes de autorización humana de la tarea;
- inspeccionar antes de modificar;
- no asumir instalación global de CLI;
- no usar `npm install -g supabase`;
- no usar `npx supabase@latest` como sustituto de una dependencia pinneada;
- no usar beta/pre-release;
- no usar `supabase init --force`;
- no usar `supabase start --ignore-health-check`;
- no usar `supabase stop --all`;
- no usar `supabase stop --no-backup` por preferencia;
- no ejecutar login/link/operaciones remotas;
- no instalar ni reparar Docker/runtime;
- no modificar configuración global del SO;
- no limpiar recursos Docker globalmente;
- no detener recursos ajenos;
- no modificar puertos por preferencia;
- no excluir servicios default por preferencia;
- no personalizar `config.toml` sin necesidad concreta;
- no crear schema/migrations/seeds de producto;
- no crear tablas sólo para comprobar PostgreSQL;
- no crear Auth funcional;
- no crear tenancy;
- no crear RLS;
- no crear Storage funcional;
- no crear Realtime funcional;
- no introducir service-role en la aplicación;
- no introducir variables Supabase en la aplicación;
- no instalar cliente Supabase para Next.js;
- no modificar el skeleton modular;
- no modificar aliases/boundaries;
- no relajar TypeScript strict;
- no modificar el baseline de tooling salvo cambios inevitables por la dependencia CLI;
- no incorporar el lifecycle Supabase a `npm run verify`;
- no configurar CI;
- no resolver decisiones de fases posteriores;
- no crear ADR;
- no modificar ADR aceptados;
- no modificar `/docs` durante la implementación;
- no commit;
- no push;
- no generar `TASK-006`.

# 25. Seguridad

Impacto de seguridad de `TASK-005`:

`INFRAESTRUCTURA LOCAL DE DESARROLLO — SIN AUTORIZACIÓN FUNCIONAL DE PRODUCTO`.

Controles obligatorios:

- ningún secreto real en Git;
- ningún secreto real en documentación;
- ningún secreto productivo utilizado por el stack local;
- ninguna credencial productiva copiada a archivos del repositorio;
- ningún valor privilegiado local convertido en configuración Next.js;
- ningún `SUPABASE_SERVICE_ROLE_KEY` de aplicación;
- ningún acceso remoto;
- ninguna exposición deliberada a Internet;
- ningún dato real de clientes;
- ninguna dependencia nueva distinta de la CLI sin revisión;
- ningún cambio de seguridad global del host;
- ninguna interpretación de credenciales locales como autorización de producto.

La salida de `supabase start/status` puede mostrar credenciales locales. El informe de Codex debe registrar únicamente que fueron emitidas por el stack cuando corresponda, nunca sus valores.

Si se detecta una credencial real existente en archivos versionados o superficies client-side, Codex debe evitar reproducirla y aplicar la política de `BLOCKER` definida por esta tarea.

# 26. Impacto de datos / migrations

Impacto de datos de producto:

`NINGUNO`.

Impacto de migrations de producto:

`NINGUNO`.

La tarea puede producir infraestructura interna propia del stack local y volúmenes Docker del proyecto, pero eso no constituye un modelo físico del SaaS.

No se crean:

- tablas de dominio;
- migrations de dominio;
- seed de dominio;
- constraints de dominio;
- índices de dominio;
- triggers de dominio;
- funciones de dominio;
- datos demo del dominio.

La persistencia local que `supabase stop` conserve por defecto pertenece al entorno técnico local. No justifica utilizar flags destructivos ni crear una política de backup de producto en esta tarea.

# 27. Impacto RLS

Impacto RLS:

`NO APLICA TODAVÍA — no existe schema funcional del producto introducido por TASK-005`.

`TASK-005` no crea:

- policies RLS de producto;
- helper functions de autorización;
- pruebas funcionales RLS;
- bypass de RLS;
- tenancy;
- membership;
- client scope;
- support grants.

Las tablas internas que Supabase necesite para operar sus servicios locales pertenecen al stack de infraestructura y no deben reinterpretarse como implementación del modelo RLS del SaaS.

La obligación futura de RLS para datos tenant-owned permanece íntegramente preservada conforme a la baseline y `ADR-0002`.

# 28. Criterios de aceptación

`TASK-005` sólo puede considerarse implementada satisfactoriamente si se cumplen todos los siguientes criterios:

1. hubo autorización humana previa de esta especificación;
2. todas las fuentes obligatorias fueron leídas antes de implementar;
3. la documentación oficial vigente de Supabase fue verificada;
4. el repositorio fue inspeccionado antes de modificarlo;
5. el preflight confirmó repositorio Git válido;
6. el preflight confirmó branch/base esperada;
7. el preflight confirmó upstream y divergencia esperados;
8. el preflight confirmó worktree limpio;
9. se registró el `HEAD` inicial;
10. `TASK-001`, `CORR-001`, `TASK-002`, `TASK-003` y `TASK-004` permanecen cerradas e intactas;
11. se confirmaron versiones reales de Next.js, React, TypeScript, Node.js y npm;
12. TypeScript `strict: true` permanece efectivo;
13. `noEmit: true` permanece efectivo;
14. se identificó un runtime Docker-compatible;
15. se registró su nombre y versión cuando fue posible;
16. el runtime estaba operativo;
17. no se instaló ni reparó el runtime automáticamente;
18. no se alteró configuración global del host;
19. se verificó la estrategia oficial de CLI como dependencia de proyecto;
20. `supabase` quedó incorporado como única dependencia nueva deliberada;
21. `supabase` quedó en `devDependencies`;
22. la versión de CLI quedó estable y exacta en `package.json`;
23. `package-lock.json` quedó coherente y reproducible;
24. no se actualizó deliberadamente ninguna dependencia no relacionada;
25. la versión efectiva de Supabase CLI fue registrada;
26. no se utilizó instalación global de Supabase CLI;
27. se ejecutó `npx supabase init` sin `--force`;
28. `supabase/` quedó inicializado en la raíz;
29. `supabase/config.toml` quedó presente;
30. todo artefacto generado por `init` fue inspeccionado y clasificado;
31. la configuración local se mantuvo mínima;
32. no se cambió un puerto por preferencia;
33. no se configuró OAuth;
34. no se configuró SMTP externo;
35. no se configuró un proveedor externo;
36. no se enlazó un proyecto remoto;
37. no se ejecutó `supabase login`;
38. no se ejecutó `supabase link`;
39. no se ejecutó `supabase db pull`;
40. no se ejecutó `supabase db push`;
41. no se utilizó un token o password remoto;
42. no se creó proyecto Supabase Cloud;
43. no se añadió `@supabase/supabase-js`;
44. no se añadió `@supabase/ssr`;
45. `.env.example` no recibió variables Supabase;
46. `src/infrastructure/config/` no recibió configuración Supabase;
47. no se introdujo service-role en la aplicación;
48. no se creó schema funcional;
49. no se creó migration funcional;
50. no se creó migration vacía de prueba;
51. no se creó seed funcional;
52. no se creó tabla de producto;
53. no se creó SQL de producto;
54. no se implementó Auth funcional;
55. no se implementó tenancy;
56. no se implementó RLS funcional;
57. no se implementó Storage funcional;
58. no se implementó Realtime funcional desde la aplicación;
59. no se implementaron Edge Functions;
60. no se modificaron módulos funcionales;
61. `npx supabase start` alcanzó estado saludable sin ignorar health checks;
62. `npx supabase status` confirmó el stack local;
63. el informe registró los servicios levantados sin copiar credenciales;
64. `npx supabase stop` detuvo limpiamente el proyecto actual;
65. no se utilizó `--all`;
66. no se utilizó `--no-backup` por preferencia;
67. el stack quedó detenido al finalizar;
68. no se borraron recursos ajenos;
69. lint finalizó en `PASS`;
70. typecheck finalizó en `PASS`;
71. tests base finalizaron en `PASS`;
72. build finalizó en `PASS`;
73. verify finalizó en `PASS`;
74. `git diff --check` finalizó en `PASS`;
75. no se incorporó lifecycle Supabase a `npm run verify`;
76. no se configuró CI;
77. `/docs` permaneció intacto durante implementación;
78. skeleton, aliases y boundaries permanecieron intactos;
79. no se modificó un ADR aceptado;
80. no se resolvió ningún `DO-*` o `*-OPEN-*`;
81. no se implementó Fase 2+;
82. no se hizo commit;
83. no se hizo push;
84. no se generó `TASK-006`;
85. el informe final identificó todos los archivos creados/modificados;
86. el informe final identificó la dependencia añadida y su versión;
87. el informe final identificó el runtime y su versión cuando fue posible;
88. el informe final registró `start/status/stop`;
89. el resultado final se declaró explícitamente `PASS`, `FAIL` o `BLOCKER`.

# 29. Pruebas/verificaciones obligatorias

La futura implementación debe ejecutar y registrar como mínimo las siguientes verificaciones.

## Preflight Git

Verificar:

- repositorio válido;
- branch actual;
- upstream;
- divergencia con `origin/main`;
- worktree limpio;
- `HEAD` inicial;
- `/docs` presente;
- tareas previas presentes;
- ausencia de cambios pendientes mezclados.

## Baseline técnica

Verificar:

- `node --version`;
- `npm --version`;
- package manager real;
- un único lockfile;
- `strict: true`;
- `noEmit: true`;
- scripts de lint/typecheck/test/build/verify;
- ausencia de `@supabase/supabase-js` y `@supabase/ssr` salvo un estado previo inesperado que deba reportarse.

## Configuración y secretos

Inspeccionar:

- `.gitignore`;
- `.env*`;
- `.env.example`;
- `src/infrastructure/config/`;
- referencias a `process.env`;
- referencias a `NEXT_PUBLIC_`;
- referencias Supabase existentes;
- secretos/keys potencialmente trackeados sin imprimir sus valores.

## Estado Supabase previo

Inspeccionar:

- `supabase/`;
- `supabase/config.toml`;
- migrations;
- seeds;
- schemas;
- functions;
- tests;
- estado temporal;
- contenedores/instancias Supabase locales relacionadas;
- posible vinculación remota.

## Runtime

Registrar y verificar:

- runtime Docker-compatible detectado;
- versión;
- disponibilidad del daemon/API compatible;
- capacidad de ejecutar el stack;
- conflictos de puertos relevantes;
- ausencia de necesidad de afectar recursos ajenos.

## CLI

Después de la instalación autorizada:

- comprobar versión instalada mediante un comando equivalente a `npx supabase --version`;
- comprobar que la versión es la exacta declarada en `package.json`;
- comprobar que el lockfile la resuelve coherentemente;
- comprobar que no se actualizó otra dependencia deliberadamente.

## Inicialización

Después de `npx supabase init`:

- inspeccionar `supabase/` completo;
- confirmar `supabase/config.toml`;
- inspeccionar ignores generados;
- confirmar ausencia de schema/migration/seed funcional;
- confirmar ausencia de secretos reales;
- confirmar ausencia de remote project ref.

## Lifecycle local

Ejecutar:

- `npx supabase start`;
- `npx supabase status`;
- `npx supabase stop`.

Validar:

- `start` sin `--ignore-health-check`;
- salud de los servicios;
- `status` exitoso;
- ningún valor sensible persistido en archivos de aplicación;
- `stop` del proyecto actual sin `--all` ni limpieza destructiva;
- estado final detenido.

## Calidad del repositorio

Ejecutar y exigir `PASS`:

- `npm run lint`;
- `npm run typecheck`;
- `npm run test`;
- `npm run build`;
- `npm run verify`;
- `git diff --check`.

## Inspección final

Verificar:

- archivos creados/modificados dentro de alcance;
- diff limitado a `TASK-005`;
- ningún cambio en `/docs` durante implementación;
- `.env.example` intacto;
- `src/infrastructure/config/` intacto;
- app/skeleton/aliases/boundaries intactos;
- ninguna dependencia no autorizada;
- ningún schema/migration/seed funcional;
- ningún Auth/tenancy/RLS/Storage/Realtime funcional;
- ninguna conexión remota;
- no CI;
- no Fase 2+;
- no commit;
- no push;
- no `TASK-006`.

# 30. Definition of Done

`TASK-005` alcanza Definition of Done únicamente cuando:

- la tarea había sido autorizada antes de implementar;
- la inspección y preflight fueron satisfactorios;
- no existe un `BLOCKER` abierto;
- Supabase CLI está incorporada como `devDependency` estable, exacta y reproducible;
- Node.js real cumple los requisitos vigentes de la CLI;
- el runtime Docker-compatible está identificado y operativo;
- `supabase/` fue inicializado mediante la CLI sin sobrescritura forzada;
- `supabase/config.toml` existe y conserva una configuración mínima;
- los artefactos versionables/no versionables fueron clasificados correctamente;
- no existe vinculación a Supabase Cloud;
- no existen variables Supabase de aplicación añadidas;
- no existe cliente Supabase de aplicación;
- no existe service-role en el contrato de aplicación;
- no existe schema funcional;
- no existen migrations funcionales;
- no existe seed funcional;
- no existe Auth funcional;
- no existe tenancy;
- no existe RLS funcional;
- no existe Storage funcional;
- no existe Realtime funcional desde la aplicación;
- `start → status → stop` se completó correctamente;
- el stack quedó detenido al finalizar;
- lint, typecheck, tests, build y verify permanecen operativos;
- `git diff --check` pasa;
- TypeScript strict y noEmit permanecen efectivos;
- skeleton, aliases, boundaries y `TASK-004` permanecen intactos;
- `/docs` no fue modificado por la implementación;
- no se configuró CI;
- no se implementó Fase 2+;
- no se creó ADR;
- no se resolvió ningún `DO-*` / `*-OPEN-*`;
- no se hizo commit;
- no se hizo push;
- no se generó `TASK-006`;
- el informe final declara `PASS` y contiene la evidencia requerida sin secretos.

Si alguna condición obligatoria no puede cumplirse dentro del alcance, el estado de ejecución debe ser `FAIL` o `BLOCKER`, nunca un `PASS` parcial.

# 31. Instrucciones para Codex

Con esta tarea formalmente autorizada para implementación, Codex debe:

1. leer íntegramente todas las fuentes obligatorias;
2. verificar la documentación oficial vigente de Supabase;
3. trabajar únicamente sobre `TASK-005`;
4. inspeccionar el repositorio primero;
5. repetir el preflight Git antes del primer cambio;
6. registrar el `HEAD` inicial;
7. verificar branch, upstream, divergencia y worktree limpio;
8. inspeccionar `package.json` y `package-lock.json`;
9. confirmar un único lockfile;
10. inspeccionar `.gitignore`;
11. inspeccionar todos los `.env*` y su tracking;
12. inspeccionar `.env.example`;
13. inspeccionar `src/infrastructure/config/`;
14. inspeccionar referencias a `process.env` y `NEXT_PUBLIC_`;
15. inspeccionar referencias Supabase existentes;
16. inspeccionar si existe `supabase/` y todo contenido parcial;
17. inspeccionar contenedores/instancias Supabase potencialmente relacionadas con el repo;
18. inspeccionar el runtime Docker-compatible real;
19. registrar runtime y versión cuando sea posible;
20. comprobar que esté operativo;
21. no instalar ni reparar Docker/runtime automáticamente;
22. no modificar configuración global del host;
23. verificar Node.js/npm reales y compatibilidad vigente de Supabase CLI;
24. instalar únicamente `supabase` CLI estable como `devDependency` exacta si el preflight sigue siendo válido;
25. no instalar una beta/pre-release;
26. no instalar `@supabase/supabase-js`;
27. no instalar `@supabase/ssr`;
28. no instalar otra dependencia;
29. registrar la versión exacta de CLI;
30. comprobar la versión efectiva con `npx supabase --version` o equivalente oficial;
31. no ejecutar `supabase login`;
32. no ejecutar `supabase link`;
33. no interactuar con Supabase Cloud;
34. no pedir access token, project ref ni password remoto;
35. ejecutar la inicialización local autorizada mediante `npx supabase init`;
36. no usar `--force`;
37. inspeccionar todo archivo/directorio generado por `init` antes de modificarlo;
38. clasificar archivos versionables y temporales según la versión real de CLI;
39. preservar `config.toml` mínimo;
40. no cambiar puertos por preferencia;
41. no personalizar servicios por preferencia;
42. no configurar OAuth;
43. no configurar SMTP externo;
44. no crear schema funcional;
45. no crear migration funcional;
46. no crear migration vacía de prueba;
47. no crear seed funcional;
48. no crear tablas;
49. no crear SQL de producto;
50. no crear Auth funcional;
51. no crear usuarios de producto;
52. no crear tenancy;
53. no crear RLS;
54. no crear policies ficticias;
55. no crear Storage funcional/buckets;
56. no crear Realtime funcional desde la aplicación;
57. no crear Edge Functions;
58. no introducir service-role en la aplicación;
59. no añadir variables Supabase a `.env.example`;
60. no modificar `src/infrastructure/config/` para Supabase;
61. no conectar Next.js con Supabase;
62. iniciar el stack mediante `npx supabase start`;
63. no usar `--ignore-health-check`;
64. registrar servicios levantados sin copiar credenciales;
65. verificar estado/salud mediante `npx supabase status`;
66. no exportar las credenciales de status a configuración de aplicación;
67. detener limpiamente mediante `npx supabase stop`;
68. no usar `--all`;
69. no usar `--no-backup` por preferencia;
70. no borrar recursos Docker ajenos;
71. dejar el stack detenido al finalizar;
72. preservar `TASK-001`;
73. preservar `CORR-001`;
74. preservar `TASK-002`;
75. preservar `TASK-003`;
76. preservar `TASK-004`;
77. preservar la propia `TASK-005`;
78. preservar `/docs` durante la implementación;
79. preservar skeleton modular;
80. preservar aliases y boundaries;
81. preservar `TASK-004` y `.env.example`;
82. preservar TypeScript strict y noEmit;
83. preservar lint/typecheck/test/build/verify;
84. no incorporar Supabase lifecycle a `verify`;
85. no configurar CI;
86. ejecutar `npm run lint`;
87. ejecutar `npm run typecheck`;
88. ejecutar `npm run test`;
89. ejecutar `npm run build`;
90. ejecutar `npm run verify`;
91. ejecutar `git diff --check`;
92. inspeccionar el diff final;
93. registrar todos los archivos creados/modificados;
94. registrar dependencias añadidas y versión exacta;
95. registrar runtime y versión;
96. registrar `start/status/stop` y resultado;
97. informar `PASS`, `FAIL` o `BLOCKER`;
98. no hacer commit;
99. no hacer push;
100. no generar `TASK-006`.

Ante una contradicción material o necesidad fuera de alcance, Codex debe detenerse y reportar `BLOCKER`; no debe resolverla por inferencia.

# 32. Resultado esperado

Después de una implementación satisfactoria de `TASK-005`, el repositorio debe conservar todo el baseline previo y añadir únicamente la capacidad técnica de ejecutar Supabase local de forma reproducible.

El estado esperado es:

- una única aplicación Next.js sin integración Supabase todavía;
- `supabase` CLI estable y exacta como `devDependency`;
- `package-lock.json` reproducible;
- `supabase/` inicializado en la raíz;
- `supabase/config.toml` mínimo y versionable;
- artefactos temporales de CLI correctamente ignorados;
- runtime de contenedores tratado como precondición externa;
- stack local capaz de iniciar y superar health checks;
- servicios default disponibles localmente sin convertirse en features de producto;
- stack local capaz de reportar estado;
- stack local capaz de detenerse limpiamente;
- stack detenido al finalizar;
- ninguna conexión a Supabase Cloud;
- ningún login/link;
- ninguna variable Supabase añadida al contrato Next.js;
- ningún cliente Supabase de aplicación;
- ningún service-role de aplicación;
- ningún schema funcional;
- ninguna migration funcional;
- ningún seed funcional;
- ningún Auth funcional;
- ninguna tenancy;
- ningún RLS funcional;
- ningún Storage funcional;
- ningún Realtime funcional desde la aplicación;
- ningún cambio de Fase 2+;
- TypeScript strict y noEmit preservados;
- lint/typecheck/tests/build/verify operativos;
- skeleton, aliases, boundaries y `TASK-004` preservados;
- documentación técnica mínima suficiente para reproducir `start/status/stop`;
- ningún commit ni push realizado por Codex.

# 33. Gate posterior

Esta especificación está formalmente autorizada para implementación.

La revisión humana previa a implementación ya ocurrió y el estado documental vigente es:

`APPROVED FOR IMPLEMENTATION`.

Después de una futura implementación de `TASK-005`, no debe generarse ni ejecutarse automáticamente `TASK-006`.

El Gate posterior exige primero:

1. informe de Codex con resultado `PASS`, `FAIL` o `BLOCKER`;
2. revisión técnica de los cambios reales;
3. revisión de arquitectura para confirmar que sólo se incorporó infraestructura local;
4. revisión de seguridad para confirmar ausencia de secretos, service-role de aplicación y conexión remota;
5. revisión de datos para confirmar ausencia de schema/migrations/seeds funcionales;
6. revisión RLS para confirmar que no se adelantó ninguna policy ni helper de autorización;
7. revisión de regresiones para confirmar lint/typecheck/test/build/verify;
8. revisión del lifecycle local y estado final detenido;
9. revisión documental para confirmar que `/docs` y tareas previas no fueron modificadas durante implementación;
10. confirmación humana de cierre de `TASK-005`.

Sólo después de cerrar formalmente `TASK-005` podrá prepararse en un paso separado la siguiente tarea de Fase 1.

`TASK-006` no se genera en este documento.

Estado de esta especificación:

`APPROVED FOR IMPLEMENTATION`.
