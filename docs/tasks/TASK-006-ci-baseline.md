# 1. ID

`TASK-006`

# 2. Título

`CI baseline de Fase 1`

# 3. Tipo

`IMPLEMENTATION TASK`

# 4. Estado

`APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`TASK-006-ci-baseline-approved.md`

**Ruta canónica futura:**

`docs/tasks/TASK-006-ci-baseline.md`

Este documento está formalmente aprobado para implementación y su incorporación canónica futura corresponde a la ruta indicada.

La aprobación documental no autoriza automáticamente la implementación técnica. Este documento no autoriza por sí mismo a ejecutar Codex, modificar el repositorio, crear workflows, hacer commit, hacer push ni avanzar a la siguiente tarea.

# 5. Objetivo

Incorporar, en una futura implementación separada y expresamente autorizada, un baseline mínimo de Continuous Integration para Fase 1 que compruebe automáticamente la salud técnica ya existente del repositorio.

El baseline debe validar exclusivamente:

- instalación reproducible de dependencias;
- lint;
- typecheck;
- tests base;
- build.

El principio central de `TASK-006` es:

`CI como verificación automática del baseline técnico existente`

NO:

`CI/CD`

NO:

`deployment`

NO:

`automatización de Supabase`

NO:

`QA integral`

NO:

`inicio de Fase 2`

La tarea debe reutilizar los checks ya establecidos por `TASK-002` y preservados por las tareas posteriores, sin crear una segunda estrategia de calidad ni ampliar el alcance hacia funcionalidades de producto.

# 6. Contexto

La Fase 0 está cerrada y la Fase 1 continúa:

`EN PROGRESO`

El estado operativo consumido por esta especificación declara cerradas:

- `TASK-001`;
- `CORR-001`;
- `TASK-002`;
- `TASK-003`;
- `TASK-004`;
- `TASK-005`;
- `CORR-002`;
- `CORR-003`.

Los últimos commits relevantes recibidos para esta definición son:

`e4085b8 docs: add CORR-003 Phase 1 Gate Supabase Cloud correction`

`edb3531 docs: sync Phase 1 Gate with Supabase Cloud Development`

El estado recibido declara además:

- branch `main`;
- `main` sincronizada con `origin/main`;
- worktree limpio;
- Fase 2 no iniciada.

`CORR-002` sustituyó la dependencia operativa de Supabase local/Docker por un proyecto Supabase Cloud exclusivo de Development operado manualmente, manteniendo a Codex fuera de toda operación remota autenticada.

`CORR-003` sincronizó documentalmente el Gate de Fase 1 con esa corrección.

El siguiente paso técnico pendiente del orden aprobado de Fase 1 es:

`CI`

El Gate de Fase 1 autoriza expresamente configurar CI y define como baseline mínimo instalación reproducible, lint, typecheck, tests base y build. El mismo Gate prohíbe convertir esta tarea en deployment, release o implementación de módulos posteriores.

No se detecta una contradicción material que impida definir `TASK-006` con ese alcance.

## 6.1 Evidencia directa del repositorio consumida por esta corrección

Durante la corrección documental de esta especificación se incorporó evidencia directa del `HEAD` actual obtenida mediante:

```text
git show HEAD:package.json
```

Esa evidencia confirma que `package.json` contiene exactamente los siguientes scripts:

- `lint`: `eslint .`;
- `typecheck`: `tsc --noEmit`;
- `test`: `vitest run`;
- `build`: `next build`;
- `verify`: `npm run lint && npm run typecheck && npm run test && npm run build`.

Por tanto, los comandos de verificación existentes quedan directamente verificados como:

- `npm run lint`;
- `npm run typecheck`;
- `npm run test`;
- `npm run build`;
- `npm run verify`.

La misma evidencia confirma directamente estas versiones declaradas en `package.json`:

- Next.js `16.3.1`;
- React `19.2.8`;
- ESLint `9.39.2`;
- TypeScript `6.0.3`;
- Vitest `4.1.10`;
- Supabase CLI `2.114.0` como `devDependency`.

También confirma que `package.json` **no declara**:

- `engines`;
- `packageManager`;
- `devEngines`.

En consecuencia, Node `22.23.1` y npm `10.9.8` no se atribuyen a una restricción declarada por `package.json`; proceden del baseline técnico previamente verificado y registrado por las tareas anteriores.

La futura implementación debe volver a inspeccionar el `package.json` real, el runtime efectivo y el resto del repositorio durante su preflight, porque el estado del repositorio puede cambiar entre la aprobación documental y la implementación.

`AGENTS.md` no existe actualmente en el repositorio y no forma parte de `TASK-006`.

No se infiere ningún campo no presente en la evidencia directa ni se utiliza esta corrección para modificar el diseño técnico ya definido de CI.

# 7. Fuentes canónicas

`TASK-006` debe interpretarse conforme a las siguientes fuentes, en el orden de autoridad ya aprobado por el proyecto:

## 7.1 Producto y Gate

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`.

## 7.2 Tareas y correcciones previas

- `docs/tasks/TASK-001-bootstrap-nextjs.md`;
- `docs/tasks/CORR-001-typescript-tooling-compatibility.md`;
- `docs/tasks/TASK-002-tooling-base.md`;
- `docs/tasks/TASK-003-modular-skeleton.md`;
- `docs/tasks/TASK-004-environment-secrets.md`;
- `docs/tasks/TASK-005-supabase-local.md`;
- `docs/tasks/CORR-002-supabase-cloud-development.md`;
- `docs/tasks/CORR-003-phase-1-gate-supabase-cloud.md`.

## 7.3 Arquitectura

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`.

`ADR-0002` continúa vigente como restricción transversal de seguridad/multitenancy, pero `TASK-006` no implementa datos, tenancy ni RLS.

## 7.4 Repositorio real

Antes de implementación son fuentes técnicas obligatorias:

- `package.json`;
- `package-lock.json`;
- configuración actual de TypeScript;
- configuración actual de ESLint;
- configuración actual de Vitest;
- estructura actual de `.github/`, si existe;
- cualquier workflow preexistente;
- estado Git real.

Aunque `package.json` fue verificado directamente durante esta corrección, Codex debe volver a inspeccionarlo en el preflight futuro y confirmar que los scripts y versiones relevantes no cambiaron.

## 7.5 Fuentes técnicas externas permitidas

Para validar únicamente sintaxis, inputs y versiones de GitHub Actions, pueden consultarse las fuentes oficiales vigentes de GitHub y de los repositorios oficiales `actions/*`.

No deben utilizarse fuentes externas para redefinir producto, fases, arquitectura ni alcance.

# 8. Precondiciones

Antes de cualquier modificación futura, Codex debe:

1. verificar que `TASK-006` haya sido revisada, aprobada e incorporada canónicamente;
2. leer íntegramente todas las fuentes obligatorias de la sección anterior;
3. inspeccionar primero el repositorio real;
4. repetir el preflight Git inmediatamente antes del primer cambio;
5. confirmar que el repositorio sea Git válido;
6. confirmar branch `main`, salvo que una decisión posterior incorporada establezca expresamente otra base;
7. registrar el `HEAD` inicial;
8. verificar upstream y divergencia respecto de `origin/main`;
9. exigir worktree limpio;
10. confirmar que `/docs` esté presente e íntegro;
11. confirmar que `TASK-001`, `CORR-001`, `TASK-002`, `TASK-003`, `TASK-004`, `TASK-005`, `CORR-002` y `CORR-003` estén realmente cerradas/incorporadas conforme al estado vigente;
12. inspeccionar `package.json`;
13. confirmar que los scripts reales siguen siendo:
    - `lint`: `eslint .`;
    - `typecheck`: `tsc --noEmit`;
    - `test`: `vitest run`;
    - `build`: `next build`;
    - `verify`: `npm run lint && npm run typecheck && npm run test && npm run build`;
14. confirmar que `package.json` continúa sin declarar `engines`, `packageManager` ni `devEngines`, salvo que una decisión posterior aprobada haya modificado expresamente ese baseline;
15. inspeccionar `package-lock.json`;
16. confirmar que existe un único package manager efectivo;
17. confirmar que existe un único lockfile coherente;
18. confirmar la versión/estrategia real de Node utilizada por el repositorio y registrar su procedencia;
19. confirmar la versión real de npm y registrar su procedencia;
20. confirmar que TypeScript continúa en modo estricto y con `noEmit` conforme al baseline;
21. confirmar que funcionan los scripts actuales de:
    - lint;
    - typecheck;
    - test;
    - build;
    - verify;
22. inspeccionar `.github/` y `.github/workflows/`, si existen;
23. comprobar que no exista ya una CI equivalente o incompatible;
24. comprobar que no exista deployment/release automation preexistente que convierta esta tarea en una migración de CI/CD no prevista;
25. inspeccionar `.gitignore`;
26. inspeccionar `.env*` únicamente para detectar requisitos de build/configuración, sin imprimir valores;
27. inspeccionar `.env.example`;
28. inspeccionar `src/infrastructure/config/`;
29. confirmar que el build actual puede ejecutarse sin secretos reales ni variables de proveedor no autorizadas;
30. inspeccionar `supabase/` sólo lo necesario para confirmar que CI no necesita ejecutarlo;
31. confirmar que `supabase@2.114.0`, si continúa presente como devDependency, no introduce por sí sola un requisito de ejecutar Supabase CLI;
32. confirmar ausencia de funcionalidad de Fase 2+ introducida inesperadamente;
33. confirmar que el host dispone de alguna forma ya existente y no añadida al repositorio de realizar una comprobación sintáctica básica de YAML antes de commit;
34. verificar nuevamente mediante fuentes oficiales, antes de crear `.github/workflows/ci.yml`, que:
    - `3d3c42e5aac5ba805825da76410c181273ba90b1` pertenece realmente al repositorio oficial `actions/checkout`;
    - ese SHA de checkout continúa correspondiendo a `v7.0.1`;
    - `3d7870f6218881292d183093179901ae8dc2ef85` pertenece realmente al repositorio oficial `actions/setup-node`;
    - el SHA seleccionado de setup-node no ha quedado invalidado por una advisory GitHub Reviewed nueva conocida al momento de implementación;
    - si existe una nueva release oficial parcheada de setup-node que haga obsoleto este snapshot, no debe cambiarse silenciosamente: debe devolverse `BLOCKER` para revisar esta especificación;
35. no elegir automáticamente `latest` para ninguna Action;
36. no sustituir un SHA completo por un tag;
37. no asumir que el estado verificado durante esta definición sustituye el preflight real.

Debe devolverse `BLOCKER` y detenerse sin cambios si:

- el worktree no está limpio y no puede aislarse `TASK-006`;
- branch/upstream/divergencia contradicen materialmente el baseline esperado;
- una tarea previa no está realmente cerrada;
- `package.json` contradice materialmente los scripts verificados por esta especificación;
- falta alguno de los checks obligatorios y satisfacerlo requiere modificar tooling fuera de esta tarea;
- el build requiere un secreto real o credencial no autorizada;
- existe una CI previa materialmente incompatible cuya sustitución requiere una decisión más amplia;
- completar la tarea exige modificar arquitectura;
- completar la tarea exige cambiar versiones de Node, npm, dependencias o package manager;
- completar la tarea exige configurar Supabase remoto;
- completar la tarea exige Docker;
- completar la tarea exige resolver un `DO-*` o `*-OPEN-*`;
- completar la tarea exige redactar/modificar un ADR;
- completar la tarea exige implementar Fase 2+;
- no existe una forma local ya disponible de comprobar razonablemente la sintaxis YAML y satisfacer ese criterio exigiría añadir una herramienta no aprobada;
- alguno de los SHA indicados no puede verificarse como perteneciente al repositorio oficial correspondiente;
- el SHA de checkout ya no puede verificarse como correspondiente a `v7.0.1`;
- una nueva advisory GitHub Reviewed conocida al momento de implementación invalida materialmente el snapshot seleccionado de `actions/setup-node`;
- existe una nueva release oficial parcheada de `actions/setup-node` que hace obsoleto el snapshot seleccionado y, por tanto, la especificación debe revisarse antes de cambiar la referencia.

# 9. Estado actual consumido

La baseline documentada y la evidencia directa consumidas por `TASK-006` son:

- Fase 0: `COMPLETADA`;
- Fase 1: `EN PROGRESO`;
- Fase 2: no iniciada;
- `package.json`: verificado directamente contra `HEAD` durante esta corrección;
- Next.js: `16.3.1`, verificado en `package.json`;
- React: `19.2.8`, verificado en `package.json`;
- TypeScript: `6.0.3`, verificado en `package.json`;
- TypeScript `strict: true` según el baseline técnico vigente;
- TypeScript `noEmit: true` según el baseline técnico vigente;
- Tailwind CSS: `4.3.3`, verificado en `package.json`;
- ESLint: `9.39.2`, verificado en `package.json`;
- Vitest: `4.1.10`, verificado en `package.json`;
- Supabase CLI: `2.114.0` como `devDependency`, verificado en `package.json`;
- script `lint`: `eslint .`, verificado en `package.json`;
- script `typecheck`: `tsc --noEmit`, verificado en `package.json`;
- script `test`: `vitest run`, verificado en `package.json`;
- script `build`: `next build`, verificado en `package.json`;
- script `verify`: `npm run lint && npm run typecheck && npm run test && npm run build`, verificado en `package.json`;
- `package.json` no declara `engines`;
- `package.json` no declara `packageManager`;
- `package.json` no declara `devEngines`;
- Node.js: `22.23.1`, procedente del baseline técnico previamente verificado/registrado y no de una restricción declarada en `package.json`;
- npm: `10.9.8`, procedente del baseline técnico previamente verificado/registrado y no de una restricción declarada en `package.json`;
- package manager efectivo: `npm`;
- lockfile: `package-lock.json`;
- instalación reproducible basada en manifest + lockfile;
- skeleton modular incorporado;
- aliases y boundaries incorporados;
- contrato de entorno/secretos incorporado;
- `.env.example` incorporado;
- ownership de configuración bajo `src/infrastructure/config/`;
- `supabase/config.toml` incorporado conforme al baseline corregido;
- exactamente un proyecto Supabase Cloud exclusivo de Development operado manualmente;
- Codex sin acceso remoto a Supabase;
- Docker fuera del workflow aprobado;
- sin schema funcional de producto;
- sin migrations funcionales;
- sin Auth funcional;
- sin tenancy funcional;
- sin RLS ejecutable;
- sin CI todavía;
- `main` sincronizada con `origin/main` según el estado recibido;
- worktree limpio según el estado recibido.

Los valores anteriores deben verificarse nuevamente contra el repositorio real antes de implementación. En particular, Codex debe volver a inspeccionar `package.json`, Node y npm aunque hayan sido verificados o registrados previamente.

# 10. Alcance exacto

La futura implementación de `TASK-006` debe limitarse a crear un único workflow de CI que:

1. se ejecute sobre GitHub Actions;
2. responda únicamente a los eventos mínimos aprobados;
3. utilice un único job de calidad;
4. utilice un único sistema operativo;
5. configure la versión de Node aprobada;
6. instale dependencias desde `package-lock.json` de forma reproducible;
7. ejecute, como pasos separados, los scripts existentes de lint, typecheck, test y build;
8. finalice con error si cualquiera de esos pasos falla;
9. no necesite secretos reales;
10. no contacte Supabase;
11. no ejecute Docker;
12. no despliegue nada;
13. no modifique el repositorio;
14. no publique artefactos;
15. no cree releases;
16. no escriba en GitHub;
17. preserve la arquitectura y el código existentes.

No forma parte del alcance convertir `npm run verify` en el único paso remoto si eso elimina visibilidad diagnóstica de qué check falló.

El workflow debe preferir pasos explícitos separados para:

- lint;
- typecheck;
- tests;
- build.

`npm run verify` continúa siendo un check local obligatorio, pero no debe ejecutarse adicionalmente en CI después de los cuatro checks individuales porque duplicaría el mismo trabajo sin aportar un Gate nuevo.

# 11. Proveedor de CI

**Proveedor propuesto:**

`GitHub Actions`

## 11.1 Justificación

La elección es compatible con la baseline porque:

- el repositorio ya utiliza GitHub como remoto y superficie de integración;
- el Gate de Fase 1 autoriza explícitamente configurar CI;
- el proveedor concreto no está fijado por la baseline;
- no requiere introducir un servicio adicional de terceros para el objetivo actual;
- permite ejecutar exactamente el baseline técnico existente;
- no modifica la arquitectura de runtime del SaaS;
- no cambia el deployable principal aprobado;
- no crea un nuevo bounded context;
- es reemplazable posteriormente si aparece una necesidad real.

## 11.2 Clasificación

`Decisión técnica local y reversible de Fase 1`

No constituye por sí sola una decisión arquitectónica transversal, costosa de revertir o relacionada con dominio/datos/multitenancy.

## 11.3 Acciones permitidas

La implementación inicial debe utilizar exclusivamente las acciones oficiales de GitHub necesarias y fijarlas mediante full-length commit SHA verificable:

- `actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1`;
- `actions/setup-node@3d7870f6218881292d183093179901ae8dc2ef85 # security-patched snapshot after v7.0.0`.

Interpretación de las referencias humanas:

- el SHA de `actions/checkout` corresponde a la release oficial `v7.0.1` y el comentario `# v7.0.1` es únicamente contexto humano;
- el SHA de `actions/setup-node` es un snapshot oficial seleccionado por seguridad posterior a `v7.0.0`; no debe describirse como una release parcheada posterior a `v7.0.0`.

Las referencias ejecutables deben utilizar los SHA completos anteriores.

No se permite sustituirlos por:

- `@main`;
- branches;
- tags flotantes;
- tags de release como referencia ejecutable;
- SHA abreviados;
- una selección automática de `latest`.

`TASK-006` adopta únicamente para estas acciones la estrategia:

`acciones oficiales fijadas mediante full-length commit SHA verificable`

Esta decisión no crea una política global de pinning para todo el proyecto y no autoriza bots, actualización automática ni tooling adicional de supply-chain.

# 12. Eventos

El conjunto mínimo aprobado para esta tarea debe ser:

- `pull_request` con destino a `main`;
- `push` sobre `main`.

## 12.1 `pull_request`

El objetivo es comprobar el baseline antes de integrar cambios a `main`.

Debe utilizarse:

`pull_request`

No debe utilizarse:

`pull_request_target`

`TASK-006` no necesita un contexto privilegiado ni acceso a secretos, y no debe ampliar la superficie de confianza para código procedente de una PR.

## 12.2 `push`

El workflow debe ejecutarse también sobre:

`push` a `main`

Esto verifica el estado efectivamente integrado de la rama principal.

No se requiere ejecutar `push` sobre todas las ramas porque el `pull_request` ya protege el flujo de integración y ampliar todos los pushes duplicaría ejecuciones sin ser necesario para el baseline mínimo.

## 12.3 Eventos excluidos

No incluir:

- `schedule`;
- cron;
- `workflow_dispatch`;
- deployment events;
- release events;
- tag-based releases;
- `workflow_run`;
- eventos Supabase;
- webhooks de deployment;
- automatización de Staging/Production.

Una necesidad futura de ejecución manual genérica puede evaluarse separadamente; no es requisito del Gate actual.

# 13. Runtime y package manager

## 13.1 Node

Baseline técnico vigente:

`Node.js 22.23.1`

Esta versión procede del baseline técnico previamente verificado/registrado. `package.json` no la fija mediante `engines`, `devEngines` ni otro campo equivalente.

La CI debe utilizar esa versión exacta mientras una decisión posterior aprobada no establezca una estrategia distinta.

No debe utilizarse una versión flotante como:

- `node`;
- `latest`;
- `22.x`;
- `lts/*`.

La implementación debe configurar explícitamente:

`22.23.1`

Codex debe volver a verificar la versión efectiva de Node durante el preflight y reportar cualquier discrepancia material antes de modificar el workflow.

## 13.2 npm

Package manager vigente:

`npm`

Versión registrada por la baseline técnica previa:

`10.9.8`

`package.json` no declara `packageManager` ni `devEngines`; por tanto, esta versión de npm no debe presentarse como una restricción declarada por `package.json`.

`TASK-006` no actualiza npm ni instala otro package manager.

La implementación debe registrar la versión efectiva observada en el host y en el runner cuando corresponda.

Si el entorno de Node seleccionado no produce una versión de npm compatible con la baseline real y resolverlo exige instalar/cambiar npm, debe detenerse con `BLOCKER` y corregir la especificación; no debe ejecutar una actualización global silenciosa.

## 13.3 Campos de runtime ausentes en `package.json`

La evidencia directa de `HEAD:package.json` confirma que actualmente no existen:

- `engines`;
- `packageManager`;
- `devEngines`.

`TASK-006` no añade esos campos.

Su ausencia no cambia por sí sola la estrategia de CI aprobada para esta tarea.

## 13.4 Lockfile

Lockfile autorizado:

`package-lock.json`

Debe continuar existiendo un único lockfile.

No introducir:

- `yarn.lock`;
- `pnpm-lock.yaml`;
- Bun;
- otro package manager.

## 13.5 Instalación reproducible

Comando aprobado:

`npm ci`

Este comando debe ejecutarse desde el lockfile vigente.

No usar para conseguir un PASS:

- `npm install`;
- `--force`;
- `--legacy-peer-deps`;
- edición manual incoherente del lockfile;
- actualización de dependencias.

Antes de implementar, Codex debe validar nuevamente que el `package.json` real y `package-lock.json` son compatibles con `npm ci`.

## 13.6 Runner

Runner propuesto:

`ubuntu-24.04`

Se utiliza una imagen explícita en lugar de una etiqueta flotante de sistema operativo.

No se requiere:

- Windows;
- macOS;
- self-hosted runner;
- matrix multi-OS.

# 14. Checks obligatorios

Los checks de CI deben reutilizar los scripts existentes verificados directamente en `HEAD:package.json`.

Scripts exactos verificados:

```text
"lint": "eslint ."
"typecheck": "tsc --noEmit"
"test": "vitest run"
"build": "next build"
"verify": "npm run lint && npm run typecheck && npm run test && npm run build"
```

Comandos aprobados:

- lint: `npm run lint`;
- typecheck: `npm run typecheck`;
- tests base: `npm run test`;
- build: `npm run build`;
- verificación agregada local: `npm run verify`.

Antes de implementar, Codex debe inspeccionar nuevamente el `package.json` real y confirmar que esos scripts siguen vigentes. Esa reverificación es un control de preflight frente a posibles cambios posteriores, no una inferencia sobre el estado actual.

No deben crearse scripts nuevos dentro de `TASK-006`.

Si alguno de estos scripts deja de existir y satisfacer el Gate requiere modificar tooling fuera de esta tarea:

`BLOCKER`

y debe prepararse una corrección separada del tooling antes de implementar CI.

## 14.1 Lint

`npm run lint` ejecuta actualmente:

`eslint .`

CI debe ejecutar ese script existente sin relajar reglas ni introducir excepciones para CI.

## 14.2 Typecheck

`npm run typecheck` ejecuta actualmente:

`tsc --noEmit`

CI debe ejecutar ese script preservando TypeScript estricto y `noEmit`.

## 14.3 Tests

`npm run test` ejecuta actualmente:

`vitest run`

CI debe utilizar ese script base existente en modo no interactivo.

No añadir:

- E2E;
- browser tests;
- tests de Supabase;
- tests RLS;
- tests de dominio inexistente.

## 14.4 Build

`npm run build` ejecuta actualmente:

`next build`

CI debe ejecutar el build de producción existente de Next.js.

El build debe pasar sin secretos reales ni credenciales Supabase.

Si el build exige una variable que contradice `TASK-004`, no debe inventarse una credencial ficticia: debe reportarse `BLOCKER`.

## 14.5 `verify`

`npm run verify` está verificado directamente como:

```text
npm run lint && npm run typecheck && npm run test && npm run build
```

El script agregado debe seguir existiendo y pasar localmente.

No se ejecutará además de los cuatro checks individuales en CI porque los vuelve a ejecutar en secuencia y duplicaría trabajo sin añadir un Gate nuevo.

# 15. Orden de checks

El job de CI debe seguir este orden:

1. checkout del repositorio;
2. setup de Node `22.23.1`;
3. registro no sensible de versiones efectivas de Node y npm;
4. instalación reproducible mediante `npm ci`;
5. `npm run lint`;
6. `npm run typecheck`;
7. `npm run test`;
8. `npm run build`.

El orden busca:

- fallar temprano ante instalación inválida;
- detectar errores estáticos antes del build;
- mantener pasos separados y diagnósticos claros;
- evitar duplicación de `verify`.

No ejecutar Supabase CLI antes, entre ni después de estos checks.

# 16. Supabase

`CORR-002` y `CORR-003` permanecen vigentes.

CI debe ser completamente independiente de Supabase Cloud Development.

Está expresamente prohibido que el workflow ejecute:

- `npx supabase login`;
- `npx supabase link`;
- `npx supabase db push`;
- `npx supabase db push --dry-run`;
- `npx supabase db pull`;
- `npx supabase db dump`;
- `npx supabase db diff`;
- `npx supabase migration list --linked`;
- migrations;
- operaciones remotas autenticadas;
- lifecycle local de Supabase.

CI no debe:

- usar `SUPABASE_ACCESS_TOKEN`;
- usar database password;
- usar project ref remoto;
- utilizar `service-role`;
- acceder al Dashboard;
- acceder al proyecto Supabase Cloud Development;
- crear Staging;
- crear Production;
- requerir Docker;
- levantar Supabase local;
- probar Auth;
- probar Storage;
- probar Realtime;
- probar RLS.

La existencia de:

`supabase@2.114.0`

como devDependency significa únicamente que forma parte del árbol reproducible de dependencias del repositorio.

No autoriza a ejecutar la CLI dentro de CI.

El workflow manual remoto definido por `CORR-002` continúa separado y no debe convertirse en CI/CD por efecto de `TASK-006`.

# 17. Variables y secretos

`TASK-006` debe respetar íntegramente `TASK-004`.

La CI inicial debe ejecutarse con:

`0 secretos proporcionados por el proyecto`

No añadir:

- GitHub repository secrets para esta tarea;
- environment secrets;
- PAT;
- tokens personalizados;
- API keys;
- credenciales productivas;
- credenciales de Development;
- variables Supabase de aplicación;
- variables OpenAI;
- variables Mercado Pago;
- variables de otros proveedores;
- valores ficticios que aparenten ser credenciales reales.

No debe existir un bloque `env` global de aplicación salvo una necesidad técnica ya existente y no secreta que esté expresamente justificada por el repositorio real.

La expectativa aprobada es:

`ninguna variable propia de proveedor necesaria para lint/typecheck/test/build`

Si la inspección del build real contradice esa expectativa, Codex debe detenerse con `BLOCKER`.

El `GITHUB_TOKEN` gestionado internamente por GitHub Actions no se considera una credencial que el proyecto deba crear o proporcionar. Su alcance debe limitarse explícitamente mediante permisos de sólo lectura.

# 18. Permisos

Debe aplicarse mínimo privilegio.

Permisos explícitos del workflow:

`contents: read`

No otorgar permisos de escritura.

Quedan expresamente prohibidos:

- `contents: write`;
- `actions: write`;
- `checks: write` salvo una futura necesidad aprobada;
- `pull-requests: write`;
- `packages: write`;
- `deployments: write`;
- `id-token: write`;
- permisos administrativos;
- PAT;
- token personalizado.

`actions/checkout` debe configurarse para no conservar credenciales Git después del checkout cuando no son necesarias para ningún paso posterior.

Expectativa:

`persist-credentials: false`

El workflow no ejecuta:

- `git commit`;
- `git push`;
- creación de tags;
- creación de releases;
- comentarios en PR;
- modificaciones de branch.

# 19. Archivos permitidos

La futura implementación técnica está autorizada a crear únicamente:

`.github/workflows/ci.yml`

No se esperan modificaciones en:

- `package.json`;
- `package-lock.json`;
- `tsconfig.json`;
- configuración ESLint;
- configuración Vitest;
- `next.config.*`;
- `app/`;
- `src/`;
- `supabase/`;
- `.env.example`;
- `.gitignore`;
- `README.md`;
- `/docs`;
- ADR;
- código funcional.

Si implementar el baseline requiere modificar otro archivo:

- no ampliar el diff automáticamente;
- identificar la causa;
- reportar `BLOCKER`;
- preparar una corrección separada si corresponde.

La incorporación canónica de esta propia especificación a `docs/tasks/TASK-006-ci-baseline.md` es un acto documental previo y separado de la implementación técnica.

# 20. Dentro de alcance

Está dentro de `TASK-006`:

- crear un workflow mínimo de GitHub Actions;
- un único job;
- un único runner `ubuntu-24.04`;
- configurar Node `22.23.1`;
- usar npm;
- ejecutar `npm ci`;
- ejecutar lint;
- ejecutar typecheck;
- ejecutar tests base;
- ejecutar build;
- separar los checks en pasos legibles;
- ejecutar en PR hacia `main`;
- ejecutar en push a `main`;
- permisos explícitos `contents: read`;
- deshabilitar persistencia de credenciales de checkout;
- usar únicamente acciones oficiales necesarias;
- fijar las acciones oficiales mediante full-length commit SHA verificable;
- deshabilitar cache automática para este baseline;
- establecer un timeout simple a nivel de job;
- revisar sintaxis YAML con tooling ya disponible localmente;
- ejecutar todas las verificaciones locales y revisar el diff;
- permitir que GitHub ejecute el workflow después del commit/push humano correspondiente;
- obtener evidencia remota de CI exitosa antes del cierre final.

## 20.1 Cache

Para `TASK-006` no se requiere cache.

`actions/setup-node` debe configurarse para no activar cache automática:

`package-manager-cache: false`

No añadir cache manual.

La optimización de tiempos no forma parte del Gate.

## 20.2 Timeout

Se propone un timeout simple:

`20 minutos`

a nivel del único job.

No se pretende fijar un SLO ni una política de performance.

Si el baseline legítimo supera de forma recurrente ese límite, debe revisarse con evidencia antes de aumentarlo; no se debe desactivar el timeout silenciosamente para conseguir PASS.

## 20.3 Concurrency

No se configura `concurrency` en esta tarea.

No existe deployment, estado remoto mutable ni coste operacional demostrado que justifique añadir coordinación adicional al baseline mínimo.

Puede reevaluarse en una tarea futura si aparecen ejecuciones redundantes materialmente costosas.

# 21. Fuera de alcance

Queda fuera de `TASK-006`:

- deployment;
- CD;
- Vercel deploy;
- preview deployment;
- Production;
- Staging;
- release automation;
- tags/releases;
- publicación de packages;
- GitHub environments;
- approvals de deployment;
- Supabase GitHub Integration;
- Supabase remoto;
- Supabase login/link;
- migrations remotas;
- Docker;
- Supabase local;
- Supabase tests;
- Auth;
- identidad;
- onboarding;
- `PlatformUser`;
- `CompanyMembership`;
- roles;
- `UserClientAccess`;
- `SupportAccessGrant`;
- tenant resolution;
- tenancy funcional;
- RLS;
- schema de producto;
- migrations;
- tablas;
- SQL;
- clients;
- locations;
- equipment;
- Form Engine;
- Maintenance;
- Evidence;
- Offline;
- Dexie;
- IndexedDB;
- Service Worker;
- Reporting;
- PDF;
- DOCX;
- IA;
- créditos;
- pagos;
- Mercado Pago;
- notificaciones;
- Dashboard;
- observabilidad integral;
- QA integral;
- performance;
- load testing;
- E2E;
- Playwright;
- Cypress;
- coverage thresholds;
- Codecov;
- Sonar;
- SAST adicional;
- Dependabot;
- Renovate;
- matrices multi-Node;
- matrices multi-OS;
- self-hosted runners;
- caches personalizadas;
- artifact upload;
- Docker image build;
- containers;
- monorepo tooling;
- microservicios;
- creación/modificación de ADR;
- resolución de `DO-*`;
- resolución de `*-OPEN-*`;
- `ADR-0003`;
- `DO-T03`;
- Fase 2+;
- generación de la siguiente tarea.

# 22. Restricciones

La futura implementación debe respetar todas estas restricciones:

1. inspeccionar antes de modificar;
2. comenzar con worktree limpio;
3. registrar `HEAD` inicial;
4. validar branch/upstream/divergencia;
5. trabajar exclusivamente sobre `TASK-006`;
6. modificar únicamente `.github/workflows/ci.yml`;
7. preservar `/docs`;
8. preservar `package.json`;
9. preservar `package-lock.json`;
10. no cambiar Node;
11. no cambiar npm;
12. no cambiar package manager;
13. no cambiar dependencias;
14. no ejecutar updates;
15. no usar `npm install` para alterar el lockfile;
16. no usar `--force`;
17. no usar `--legacy-peer-deps`;
18. no relajar TypeScript;
19. no relajar ESLint;
20. no omitir tests para conseguir PASS;
21. no omitir build para conseguir PASS;
22. no añadir variables falsas;
23. no añadir secretos;
24. no acceder a Supabase Cloud;
25. no ejecutar Supabase CLI;
26. no necesitar Docker;
27. no crear deployment;
28. no configurar Vercel;
29. no crear Staging/Production;
30. no introducir actions de terceros innecesarias;
31. no introducir herramientas de validación YAML como dependencia sólo para esta tarea;
32. no introducir cache salvo una decisión posterior;
33. no introducir matrices;
34. no introducir concurrency;
35. no modificar runtime architecture;
36. no crear funcionalidad;
37. no crear schema/migrations/RLS;
38. no resolver `DO-T03`;
39. no redactar `ADR-0003`;
40. no avanzar a Fase 2;
41. no hacer commit desde Codex;
42. no hacer push desde Codex;
43. no crear tags;
44. no generar la siguiente tarea;
45. devolver el diff completo;
46. ejecutar checks locales después del cambio;
47. verificar los full-length SHA oficiales antes de crear el workflow;
48. no sustituir los SHA especificados por tags;
49. no elegir automáticamente `latest`;
50. no actualizar silenciosamente `actions/setup-node` aunque exista una referencia nueva;
51. si la reverificación de seguridad exige cambiar el snapshot aprobado, devolver `BLOCKER` para revisar la especificación;
52. informar `PASS`, `FAIL` o `BLOCKER`.

# 23. Seguridad

## 23.1 Principio

CI es una superficie de ejecución de código del repositorio y debe operar con privilegio mínimo.

## 23.2 Token

No se aporta PAT ni token personalizado.

El token automático de GitHub debe quedar limitado a:

`contents: read`

No debe utilizarse para mutar el repositorio ni otros recursos.

## 23.3 Pull requests

Se utiliza `pull_request`, no `pull_request_target`.

El workflow no recibe secretos del proyecto.

El código de una PR no debe obtener credenciales de Supabase, deployment ni proveedores.

## 23.4 Checkout

La implementación debe evitar persistir credenciales Git cuando no son necesarias:

`persist-credentials: false`

## 23.5 Supply chain

La superficie supply-chain de `TASK-006` debe permanecer mínima.

Sólo se permiten estas acciones oficiales:

- `actions/checkout`;
- `actions/setup-node`.

Ambas deben fijarse mediante full-length commit SHA verificable:

- `actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1`;
- `actions/setup-node@3d7870f6218881292d183093179901ae8dc2ef85 # security-patched snapshot after v7.0.0`.

No se permite:

- ninguna Action de terceros;
- ninguna referencia ejecutable mediante tag flotante;
- ningún `@main`;
- ningún SHA abreviado;
- sustituir automáticamente los SHA por `latest`;
- sustituir automáticamente los SHA por tags;
- actualizar automáticamente las Actions dentro de `TASK-006`.

Antes de implementación deben reverificarse los SHA con fuentes oficiales conforme al preflight de esta tarea.

No añadir una acción independiente para:

- YAML linting;
- caching;
- reports;
- coverage;
- notifications;
- security scanning;
- Supabase.

Tampoco introducir en esta tarea:

- Dependabot;
- Renovate;
- Scorecards;
- SLSA;
- firma manual;
- políticas organizacionales;
- nuevas herramientas de supply-chain.

Esta estrategia es local a `TASK-006` y no constituye una política global de pinning del proyecto.

## 23.6 Datos y RLS

`TASK-006` no introduce datos tenant-owned.

Impacto de datos:

`NO APLICA — CI de repositorio únicamente`

Impacto RLS:

`NO APLICA TODAVÍA — no existe schema funcional de producto introducido por TASK-006`

La ausencia de RLS en este workflow no debilita la obligación de RLS cuando existan datos tenant-owned.

# 24. Reproducibilidad

La CI debe reducir al mínimo las entradas flotantes.

Se fijan:

- runner: `ubuntu-24.04`;
- Node: `22.23.1`;
- package manager: `npm`;
- lockfile: `package-lock.json`;
- instalación: `npm ci`;
- checkout: `actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1`;
- setup de Node: `actions/setup-node@3d7870f6218881292d183093179901ae8dc2ef85 # security-patched snapshot after v7.0.0`;
- cache: deshabilitada;
- job único;
- checks explícitos existentes.

La estrategia de Actions de esta tarea es:

`acciones oficiales fijadas mediante full-length commit SHA verificable`

No se permite:

- `ubuntu-latest`;
- Node `latest`;
- Node `22.x`;
- Action `@main`;
- Action mediante tag flotante;
- Action mediante tag de release como referencia ejecutable;
- SHA abreviado;
- selección automática de `latest`;
- dependencia sin lockfile;
- `npm install` que reescriba el lockfile.

El comentario humano `# v7.0.1` de checkout documenta la release asociada al SHA sin convertir el tag en referencia ejecutable.

El comentario humano de setup-node documenta que el SHA corresponde a un snapshot oficial seleccionado por seguridad posterior a `v7.0.0`; no debe presentarse como una release parcheada posterior.

No se crea una política global de pinning, actualización automática, provenance, Scorecards, SLSA ni bot de actualización de Actions.

# 25. Comandos de implementación futura

Los siguientes comandos representan el conjunto esperado que Codex deberá ejecutar o validar durante una implementación autorizada. Deben adaptarse únicamente si el repositorio real exige un equivalente ya aprobado; no deben utilizarse para ampliar alcance.

## 25.1 Preflight Git

```text
git rev-parse --is-inside-work-tree
git branch --show-current
git rev-parse HEAD
git status --short --branch
git rev-list --left-right --count HEAD...origin/main
```

Debe registrarse el resultado sin modificar historia.

## 25.2 Runtime

```text
node --version
npm --version
```

## 25.3 Instalación reproducible

```text
npm ci
```

La ejecución local de `npm ci` debe realizarse sin alterar deliberadamente `package.json` o `package-lock.json`.

## 25.4 Checks

```text
npm run lint
npm run typecheck
npm run test
npm run build
npm run verify
git diff --check
```

`npm run verify` se ejecuta localmente como check agregado de regresión aunque no se duplique en el workflow remoto.

## 25.5 Diff

```text
git status --short
git diff -- .github/workflows/ci.yml
git diff --check
```

Codex debe devolver el diff completo del archivo creado.

## 25.6 Validación YAML

Antes de commit debe existir una comprobación sintáctica local realizada mediante una herramienta que ya esté disponible en el host y que no requiera añadir una dependencia al repositorio.

Ejemplo válido si Ruby ya está disponible:

```text
ruby -e "require 'yaml'; YAML.load_file('.github/workflows/ci.yml'); puts 'YAML syntax OK'"
```

Si el host dispone de otro parser YAML ya instalado, puede utilizarse su equivalente y debe registrarse el comando exacto.

No instalar silenciosamente:

- Prettier;
- yamllint;
- actionlint;
- PyYAML;
- otra dependencia;

únicamente para satisfacer esta comprobación.

Si no existe un parser disponible, reportar `BLOCKER` para este criterio y solicitar una corrección mínima de la estrategia de validación.

# 26. Verificación local

Antes de que una persona realice commit, Codex debe demostrar:

1. preflight Git correcto;
2. worktree limpio al inicio;
3. `HEAD` inicial registrado;
4. branch/base correctos;
5. `package.json` inspeccionado nuevamente;
6. `package-lock.json` inspeccionado;
7. scripts exactos de `package.json` confirmados contra el baseline verificado;
8. ausencia actual de `engines`, `packageManager` y `devEngines` confirmada o, si cambió legítimamente por una decisión posterior, discrepancia reportada antes de continuar;
9. Node real confirmado;
10. npm real confirmado;
11. único lockfile confirmado;
12. ninguna dependencia cambiada;
13. SHA completo de `actions/checkout` reverificado en fuente oficial y correspondencia con `v7.0.1` confirmada;
14. SHA completo de `actions/setup-node` reverificado en fuente oficial;
15. reverificación de seguridad del snapshot de `actions/setup-node` completada sin advisory GitHub Reviewed nueva conocida que lo invalide;
16. ausencia de una nueva release oficial parcheada de setup-node que haga obsoleto el snapshot seleccionado confirmada; si existe, resultado = `BLOCKER`;
17. YAML parseado sintácticamente mediante una herramienta ya disponible;
18. `npm ci` PASS;
19. `npm run lint` PASS;
20. `npm run typecheck` PASS;
21. `npm run test` PASS;
22. `npm run build` PASS;
23. `npm run verify` PASS;
24. `git diff --check` PASS;
25. diff completo revisado;
26. único archivo técnico modificado/creado: `.github/workflows/ci.yml`;
27. `/docs` intacto;
28. `package.json` intacto;
29. `package-lock.json` intacto;
30. `supabase/` intacto;
31. `.env.example` intacto;
32. ningún secreto añadido;
33. ningún acceso a Supabase;
34. ningún Docker;
35. ninguna funcionalidad de Fase 2+;
36. ningún commit;
37. ningún push.

La comprobación local de YAML valida sintaxis básica.

La comprobación semántica real de GitHub Actions se obtiene posteriormente mediante una ejecución remota del workflow en GitHub y forma parte de la Definition of Done final, no del resultado inmediato de Codex.

# 27. Criterios de aceptación

`TASK-006` sólo puede considerarse implementada correctamente cuando se cumplan todos los siguientes criterios:

1. la especificación fue aprobada e incorporada canónicamente antes de implementación;
2. Codex leyó las fuentes obligatorias;
3. se inspeccionó el repositorio antes del cambio;
4. preflight Git correcto;
5. worktree limpio inicial;
6. `HEAD` inicial registrado;
7. branch/upstream/divergencia correctos;
8. tareas/correcciones previas cerradas;
9. `package.json` fue reinspeccionado y confirmó que los scripts verificados por esta especificación continúan vigentes;
10. `package.json` continúa sin declarar `engines`, `packageManager` ni `devEngines`, salvo cambio posterior expresamente aprobado y documentado;
11. package manager efectivo continúa siendo npm;
12. `package-lock.json` continúa siendo el único lockfile;
13. Node continúa en la estrategia aprobada y CI configura `22.23.1`;
14. Node `22.23.1` no se presenta como una restricción declarada por `package.json`;
15. npm efectivo fue verificado y no se presenta como una versión fijada por `package.json`;
16. no se actualizó npm;
17. no se actualizó ninguna dependencia;
18. no se cambió TypeScript;
19. no se cambió Next.js;
20. no se cambió React;
21. no se cambió Vitest;
22. no se cambió ESLint;
23. se creó exactamente `.github/workflows/ci.yml`;
24. no se modificó otro archivo técnico;
25. proveedor = GitHub Actions;
26. runner = `ubuntu-24.04`;
27. eventos = PR hacia `main` + push a `main`;
28. no existe `pull_request_target`;
29. existe un único job;
30. timeout = 20 minutos;
31. no existe matrix;
32. no existe concurrency;
33. cache automática deshabilitada;
34. referencia ejecutable de checkout = `actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1`, con comentario humano equivalente a `# v7.0.1`;
35. referencia ejecutable de setup-node = `actions/setup-node@3d7870f6218881292d183093179901ae8dc2ef85`, con comentario humano que lo identifica como snapshot oficial seleccionado por seguridad posterior a `v7.0.0`;
36. ambos full-length SHA fueron reverificados contra los repositorios oficiales antes de crear el workflow;
37. checkout continúa correspondiendo a `v7.0.1`;
38. el snapshot seleccionado de setup-node no está invalidado por una advisory GitHub Reviewed nueva conocida al momento de implementación;
39. si existe una nueva release oficial parcheada de setup-node que hace obsoleto el snapshot, la implementación se detuvo con `BLOCKER` en vez de cambiar la referencia silenciosamente;
40. checkout no persiste credenciales;
41. permisos explícitos = `contents: read`;
42. no existen permisos de escritura;
43. instalación = `npm ci`;
44. lint se ejecuta en paso separado mediante `npm run lint`;
45. typecheck se ejecuta en paso separado mediante `npm run typecheck`;
46. tests se ejecutan en paso separado mediante `npm run test`;
47. build se ejecuta en paso separado mediante `npm run build`;
48. `verify` no duplica esos cuatro checks en CI;
49. CI no ejecuta Supabase CLI;
50. CI no accede a Supabase Cloud;
51. CI no requiere Docker;
52. CI no requiere secretos del proyecto;
53. CI no recibe PAT;
54. CI no recibe credentials de deployment;
55. CI no recibe credenciales Supabase;
56. CI no configura Staging;
57. CI no configura Production;
58. CI no despliega;
59. CI no publica releases;
60. CI no implementa Fase 2;
61. no se creó schema;
62. no se crearon migrations;
63. no se creó RLS;
64. no se implementó Auth;
65. no se resolvió `DO-T03`;
66. no se creó/modificó ADR;
67. `ADR-0003` permanece bloqueado;
68. YAML supera una comprobación sintáctica local sin dependencia nueva;
69. `npm ci` local PASS;
70. lint local PASS;
71. typecheck local PASS;
72. test local PASS;
73. build local PASS;
74. verify local PASS;
75. `git diff --check` PASS;
76. diff completo revisado;
77. Codex no realizó commit;
78. Codex no realizó push;
79. Codex no generó la siguiente tarea;
80. el informe final declara `PASS`, `FAIL` o `BLOCKER`;
81. después del commit/push humano, GitHub reconoce y ejecuta el workflow;
82. la ejecución remota de CI finaliza satisfactoriamente;
83. existe revisión humana final del resultado remoto y del estado Git.

# 28. Definition of Done

`TASK-006` sólo puede cerrarse como `DONE` cuando se haya completado todo el ciclo:

1. `TASK-006-ci-baseline-approved.md` revisada;
2. especificación aprobada formalmente;
3. especificación incorporada canónicamente como `docs/tasks/TASK-006-ci-baseline.md`;
4. implementación de CI autorizada separadamente;
5. Codex ejecutó exclusivamente el cambio técnico permitido;
6. Codex devolvió diff completo;
7. revisión técnica del diff completada;
8. revisión de arquitectura completada;
9. revisión de seguridad completada;
10. revisión de regresiones completada;
11. checks locales pasando:
    - `npm ci`;
    - lint;
    - typecheck;
    - test;
    - build;
    - verify;
    - `git diff --check`;
12. YAML comprobado sintácticamente de forma local;
13. workflow incorporado al repositorio;
14. commit realizado por el operador humano conforme al proceso del proyecto;
15. push realizado por el operador humano;
16. repositorio limpio después del commit/push;
17. branch sincronizada con `origin/main`;
18. GitHub detectó el workflow;
19. existe evidencia de una ejecución remota real de GitHub Actions;
20. esa ejecución remota finalizó satisfactoriamente;
21. ningún secreto ni permiso excesivo fue introducido;
22. no hubo acceso de CI a Supabase;
23. no hubo deployment;
24. no se adelantó Fase 2;
25. revisión humana final aprobó el cierre.

Crear el archivo YAML no equivale a completar `TASK-006`.

Un parse YAML local tampoco equivale a CI verificada.

La evidencia remota satisfactoria en GitHub es obligatoria para el cierre final.

# 29. ADR requerido

**Decisión:**

`ADR nuevo NO requerido`

## Justificación

El Gate de Fase 1:

- incluye CI de forma expresa;
- permite seleccionar el proveedor concreto como detalle de implementación;
- no fija un proveedor;
- no exige un ADR nuevo para decisiones locales/reversibles de setup.

El registro maestro distingue decisiones técnicas menores/reversibles de decisiones arquitectónicas transversales y costosas de revertir.

Elegir GitHub Actions para ejecutar checks del repositorio:

- no cambia la arquitectura modular;
- no cambia el único deployable principal;
- no cambia runtime de producción;
- no cambia base de datos;
- no cambia multitenancy;
- no cambia RLS;
- no cambia offline;
- no cambia integraciones funcionales;
- no automatiza deployment;
- no automatiza Supabase;
- es reemplazable.

Por tanto:

`GitHub Actions = decisión técnica de Fase 1`

`ADR = no requerido`

Debe reevaluarse un ADR o una decisión documental material si en el futuro CI evoluciona hacia, por ejemplo:

- CI/CD productivo;
- deployment automático;
- gestión centralizada de credenciales privilegiadas;
- automatización de migrations a entornos remotos;
- estrategia multi-entorno;
- runners propios como infraestructura crítica;
- política global de supply-chain/pinning;
- arquitectura de release transversal.

Nada de lo anterior forma parte de `TASK-006`.

# 30. Gate posterior

El Gate posterior de `TASK-006` es:

`TASK-006 APPROVED FOR IMPLEMENTATION`
→ incorporación canónica de `TASK-006`
→ autorización separada de implementación
→ preflight
→ Codex implementa sólo `.github/workflows/ci.yml`
→ Codex ejecuta verificaciones locales
→ Codex entrega diff + reporte `PASS/FAIL/BLOCKER`
→ revisión humana técnica/arquitectónica/seguridad/regresiones
→ commit/push humano
→ ejecución remota real de GitHub Actions
→ evidencia CI satisfactoria
→ revisión humana final
→ cierre de `TASK-006`

Después de cerrar `TASK-006`:

- **no generar automáticamente la siguiente tarea**;
- **no declarar Fase 1 completada**;
- continuar únicamente con los pasos restantes del Gate de Fase 1;
- revisar smoke/documentación/estado general conforme al paso posterior aprobado;
- conservar la estrategia Supabase Cloud Development de `CORR-002`/`CORR-003`;
- no convertir el workflow remoto manual de Supabase en automatización;
- no iniciar Fase 2.

`ADR-0003` continúa:

`BLOCKED BY DO-T03`

Antes de implementar Fase 2 deberá:

- resolverse/aprobarse lo necesario de `DO-T03`;
- redactarse y aprobarse `ADR-0003`;
- superarse el Gate correspondiente.

`TASK-006` no realiza ninguna de esas acciones.

# 31. Reporte esperado de Codex

Cuando la implementación sea autorizada, Codex debe entregar un reporte final estructurado que contenga como mínimo:

## 31.1 Resultado

Uno de:

- `PASS`;
- `FAIL`;
- `BLOCKER`.

## 31.2 Preflight

Registrar:

- repositorio Git válido;
- branch;
- upstream;
- divergencia con `origin/main`;
- worktree inicial;
- `HEAD` inicial;
- estado de tareas previas.

## 31.3 Baseline técnica

Registrar:

- Node real;
- npm real;
- package manager;
- lockfile;
- scripts exactos encontrados en `package.json`;
- versiones relevantes sin realizar upgrades.

## 31.4 Workflow implementado

Registrar:

- archivo creado;
- provider;
- runner;
- eventos;
- para cada Action utilizada:
  - repository/action;
  - full-length SHA utilizado;
  - referencia humana asociada;
  - resultado de la reverificación oficial previa a implementación;
  - resultado de la reverificación de seguridad previa a implementación cuando corresponda;
- para checkout, confirmar correspondencia del SHA con `v7.0.1`;
- para setup-node, confirmar que el SHA usado es `3d7870f6218881292d183093179901ae8dc2ef85` y describirlo como snapshot oficial seleccionado por seguridad posterior a `v7.0.0`, no como release parcheada;
- Node configurado;
- install command;
- checks y orden;
- timeout;
- ausencia de concurrency;
- ausencia de cache;
- permisos;
- `persist-credentials`;
- secretos usados: ninguno;
- acceso Supabase: ninguno;
- Docker: no.

## 31.5 Verificación local

Registrar separadamente:

- YAML syntax check y comando utilizado;
- `npm ci`;
- lint;
- typecheck;
- test;
- build;
- verify;
- `git diff --check`.

Cada uno debe informar:

`PASS` / `FAIL`

## 31.6 Seguridad

Confirmar:

- `contents: read`;
- ningún write permission;
- ningún PAT;
- ningún token personalizado;
- ningún secret del proyecto;
- ningún credential de deployment;
- ningún credential Supabase;
- `pull_request_target` ausente;
- ningún acceso remoto Supabase.

## 31.7 Alcance

Confirmar:

- único archivo modificado/creado;
- `/docs` intacto durante implementación técnica;
- package files intactos;
- `supabase/` intacto;
- no schema;
- no migrations;
- no Auth;
- no tenancy;
- no RLS;
- no deployment;
- no Fase 2+.

## 31.8 Diff

Devolver:

- lista completa de archivos creados/modificados;
- diff completo de `.github/workflows/ci.yml`.

## 31.9 Git

Confirmar:

- ningún commit realizado por Codex;
- ningún push realizado por Codex;
- ninguna reescritura de historia;
- ninguna siguiente tarea generada.

## 31.10 Nota de cierre

Si el resultado local es `PASS`, Codex debe detenerse.

No debe afirmar que `TASK-006` está `DONE`.

Debe indicar que todavía faltan:

- revisión humana;
- commit/push humano;
- ejecución remota real en GitHub;
- evidencia de CI satisfactoria;
- revisión humana final.

---

**Estado final de esta especificación:**

`APPROVED FOR IMPLEMENTATION`

**Codex ejecutado durante esta preparación:** `NO`

**Repositorio modificado durante esta preparación:** `NO`

**Workflow creado durante esta preparación:** `NO`

**Fase 2 iniciada:** `NO`
