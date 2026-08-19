# TASK-007 — Smoke test y revisión integral de Fase 1

# 1. ID

`TASK-007`

# 2. Título

`Smoke test y revisión integral de Fase 1`

# 3. Tipo

`VALIDATION / REVIEW TASK`

Esta tarea valida el baseline existente de Fase 1.

No es una tarea de desarrollo funcional, no introduce arquitectura nueva y no autoriza cambios correctivos dentro del mismo alcance.

# 4. Estado

`APPROVED FOR EXECUTION`

**Archivo de entrega:**

`TASK-007-phase-1-smoke-docs-review.md`

**Ruta canónica:**

`docs/tasks/TASK-007-phase-1-smoke-docs-review.md`

**Canonical commit de referencia:**

`5bde25d96fa73537ebc912115f53c55be8366db9`

Este documento fue revisado y canonicalizado en la ruta y commit de referencia indicados.

El estado `APPROVED FOR EXECUTION` significa que la especificación está aprobada para poder ser ejecutada cuando exista una autorización humana separada y explícita para una ejecución concreta.

La especificación canónica por sí sola no inicia una ejecución, no constituye una autorización concreta de uso de Codex y no modifica el repositorio.

Cada ejecución concreta de `TASK-007` requiere una autorización humana separada. Una autorización humana externa posterior puede autorizar esa ejecución sin contradecir esta especificación.

# 5. Objetivo

Ejecutar, cuando una ejecución concreta de esta especificación ya revisada, aprobada y canonicalizada haya sido autorizada de forma humana, separada y explícita, el `Paso 8 — Smoke, documentación y revisión de Fase 1` definido por el Gate canónico, mediante una validación integral, reproducible y no destructiva del estado real del repositorio.

La tarea debe determinar con evidencia si el baseline de Fase 1 continúa coherente después de `TASK-001`…`TASK-006` y `CORR-001`…`CORR-003`, cubriendo conjuntamente:

1. smoke técnico del repositorio y de la aplicación base;
2. revisión estructural y de arquitectura;
3. revisión documental de consistencia;
4. evaluación explícita de las doce condiciones del Gate de salida propio de Fase 1.

El paso 8 exige verificar expresamente:

- setup reproducible;
- aplicación ejecutable;
- baseline Supabase de Development conforme a `CORR-002`;
- checks pasando;
- documentación suficiente;
- ausencia de exposición o gestión incorrecta de secretos;
- ausencia de schema/migrations/capacidades adelantadas;
- coherencia con `ADR-0001`.

El principio central es:

`validar el estado existente`

NO:

`corregirlo dentro de TASK-007`

La evidencia de `TASK-007` permite evaluar el Gate de salida de Fase 1, pero esta tarea no realiza por sí misma el cierre formal de la fase y no autoriza iniciar Fase 2.

# 6. Contexto

## 6.1 Estado operativo recibido para redactar esta especificación

Se consume como estado operativo recibido:

- Fase 0: `COMPLETADA`;
- Fase 1: `EN PROGRESO`;
- Fase 2: `NO INICIADA`;
- `TASK-001`: cerrada;
- `CORR-001`: cerrada;
- `TASK-002`: cerrada;
- `TASK-003`: cerrada;
- `TASK-004`: cerrada;
- `TASK-005`: cerrada bajo la corrección vigente;
- `CORR-002`: cerrada e incorporada;
- `CORR-003`: cerrada e incorporada;
- `TASK-006`: `DONE`;
- commit de referencia de cierre técnico de `TASK-006`: `463c908`;
- workflow remoto de referencia: `CI`;
- GitHub Actions run de referencia: `32192116475`;
- run commit: `463c908`;
- run status: `completed`;
- run conclusion: `success`;
- branch verificada al recibir el estado: `main`;
- `HEAD` recibido: `463c908`;
- `origin/main` recibido: `463c908`;
- divergencia recibida: `0 0`;
- worktree recibido: limpio.

El commit `463c908` es evidencia histórica de implementación y ejecución remota satisfactoria de `TASK-006`, no un `HEAD` que deba permanecer inmutable durante la futura ejecución de `TASK-007`. La aprobación y canonicalización de esta propia tarea puede producir commits documentales posteriores. En ejecución deberá registrarse el `HEAD` real y reconciliar cualquier cambio posterior con tareas/correcciones aprobadas.

## 6.2 Posición en el orden canónico de Fase 1

El Gate canónico conserva este orden:

1. `Paso 1 — Preflight de repositorio y baseline`;
2. `Paso 2 — Bootstrap de aplicación`;
3. `Paso 3 — Tooling y comandos de calidad`;
4. `Paso 4 — Skeleton modular`;
5. `Paso 5 — Configuración de entorno y secretos`;
6. `Paso 6 — Supabase local` — título histórico/normativo; operativamente implementa el baseline Supabase Cloud Development aprobado por `CORR-002` y sincronizado por `CORR-003`;
7. `Paso 7 — CI`;
8. `Paso 8 — Smoke, documentación y revisión de Fase 1`;
9. `Paso 9 — Preparar la frontera de Fase 2 sin implementarla`.

Los pasos `1..7` se consideran cerrados según el estado operativo recibido.

`TASK-007` cubre exclusivamente el paso 8.

No cubre el paso 9. El paso 9 sólo puede autorizarse separadamente después de que Fase 1 haya sido formalmente considerada completada en su propio Gate.

## 6.3 Estrategia Supabase vigente

`TASK-005` permanece como registro histórico de la estrategia inicialmente aprobada. `CORR-002` sustituyó su método operativo y `CORR-003` sincronizó el Gate de Fase 1 con ese override.

El baseline Supabase vigente de Fase 1 es:

`Supabase CLI reproducible y pinneada + supabase/ inicializado + supabase/config.toml versionado + un único proyecto Supabase Cloud exclusivo de Development + operaciones remotas manuales por Francisco`

Se preservan como reglas vigentes:

1. Supabase CLI forma parte del proyecto como tooling reproducible y pinneado.
2. `supabase/` está inicializado en la raíz del repositorio.
3. `supabase/config.toml` está presente y versionado.
4. Estado temporal, sesiones y credenciales de CLI permanecen fuera de Git.
5. Existe exactamente un proyecto Supabase Cloud exclusivo de `Development` para este workflow.
6. El proyecto Development fue creado manualmente.
7. El proyecto Development fue linked manualmente por Francisco.
8. Login y link permanecen bajo operación manual de Francisco.
9. Codex no posee credenciales, tokens, passwords ni acceso remoto a Supabase.
10. Las operaciones remotas continúan siendo manuales y responsabilidad de Francisco salvo decisión posterior explícita.
11. Docker no es requisito del workflow aprobado.
12. No se exige ni utiliza lifecycle local `start/status/stop` como Gate de Fase 1.
13. No existe schema funcional del SaaS.
14. No existen migrations funcionales de producto de Fase 1.
15. `db push` no es requisito de Fase 1 y no debe ejecutarse mientras no exista una migration funcional expresamente autorizada por una tarea posterior.
16. La aplicación Next.js no está integrada funcionalmente con Supabase.
17. No existe cliente Supabase de aplicación anticipado por este Gate.
18. No existe Auth funcional.
19. No existe tenancy funcional.
20. No existe RLS ejecutable.
21. No existe Storage funcional de producto.
22. No existe Realtime funcional desde la aplicación.
23. No existe `service-role` en el contrato de aplicación.
24. No existe Staging.
25. No existe Production.
26. La existencia nativa de capacidades administradas de Supabase en Development no equivale a haber implementado esas capacidades en el producto.

Las migrations Git serán la futura fuente de verdad de evolución de schema cuando una fase posterior autorice schema. Esa regla no significa que Fase 1 deba contener migrations funcionales.

## 6.4 CI vigente

`TASK-006` define y cerró un baseline de GitHub Actions cuyo alcance es exclusivamente verificar salud técnica del repositorio.

La configuración aprobada que `TASK-007` debe auditar incluye:

- proveedor: GitHub Actions;
- archivo: `.github/workflows/ci.yml`;
- eventos: `pull_request` con destino a `main` y `push` sobre `main`;
- ausencia de `pull_request_target`;
- un único job;
- runner: `ubuntu-24.04`;
- Node: `22.23.1`;
- package manager efectivo: `npm`;
- lockfile: `package-lock.json`;
- instalación: `npm ci`;
- pasos separados: `npm run lint`, `npm run typecheck`, `npm run test`, `npm run build`;
- `npm run verify` obligatorio localmente, pero no duplicado en CI después de esos cuatro pasos;
- timeout del job: `20 minutos`;
- sin matrix;
- sin `concurrency`;
- cache automática deshabilitada mediante `package-manager-cache: false`;
- permisos explícitos: `contents: read`;
- checkout con `persist-credentials: false`;
- únicamente `actions/checkout` y `actions/setup-node` como Actions oficiales necesarias;
- `actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1`;
- `actions/setup-node@3d7870f6218881292d183093179901ae8dc2ef85`, descrito como snapshot oficial seleccionado por seguridad posterior a `v7.0.0`;
- cero secretos proporcionados por el proyecto;
- sin PAT;
- sin credenciales de deployment;
- sin credenciales Supabase;
- sin Supabase CLI;
- sin acceso Supabase Cloud;
- sin Docker;
- sin deployment, release, Staging o Production;
- sin funcionalidad de Fase 2+.

La evidencia remota recibida para ese baseline es el run `32192116475`, commit `463c908`, `completed / success`.

## 6.5 Gate de Fase 2

Permanece vigente:

`ADR-0003 = BLOCKED BY DO-T03`

El Gate canónico registra además:

`DO-T03 = PARCIALMENTE ABIERTO`

Antes de implementar Fase 2 deberán resolverse/aprobarse las dependencias necesarias de `ADR-0003`, especialmente `DO-T03`, y `ADR-0003` deberá quedar `ACCEPTED`.

`TASK-007`:

- no resuelve `DO-T03`;
- no redacta `ADR-0003`;
- no modifica ningún ADR;
- no inicia Fase 2.

## 6.6 Reconciliación de las fuentes antes faltantes

Para esta versión corregida se revisaron íntegramente y se reconciliaron:

- `docs/product/11-phase-1-scope-entry-gate.md`;
- `docs/tasks/CORR-003-phase-1-gate-supabase-cloud.md`;
- `docs/tasks/TASK-006-ci-baseline.md`.

La versión canónica actual de `11` ya refleja la sincronización de `CORR-003`: conserva el nombre histórico `Fase 1 — Setup, repositorio, CI y Supabase local`, pero sustituye la condición operativa de stack local/Docker por el baseline Supabase Cloud Development de `CORR-002`.

No se detecta una contradicción material entre estas tres fuentes; esta reconciliación forma parte de la especificación canónica de `TASK-007` aprobada para ejecución.

# 7. Fuentes canónicas

En cada ejecución concreta de `TASK-007` autorizada humanamente de forma separada, deben leerse íntegramente desde el repositorio real, como mínimo, las siguientes fuentes.

## 7.1 Producto / Gates

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`.

## 7.2 ADR aceptados relevantes para el Gate

### Relevancia directa de Fase 1

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`.

`ADR-0001` es la decisión arquitectónica directamente materializada y validada por el skeleton de Fase 1.

### Guardrails aceptados que no amplían Fase 1

El Gate de Fase 0/Fase 1 también registra como `ACCEPTED`:

- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`;
- `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`;
- `docs/architecture/adr/ADR-0009-maintenance-revision-history.md`;
- `docs/architecture/adr/ADR-0012-report-document-model-renderers.md`;
- `docs/architecture/adr/ADR-0013-ai-server-side-provider-boundary.md`.

En `TASK-007` deben utilizarse como guardrails para comprobar que su aceptación no fue interpretada como autorización de implementar anticipadamente capacidades de Fase 2+.

## 7.3 Tasks y correcciones de Fase 1

- `docs/tasks/TASK-001-bootstrap-nextjs.md`;
- `docs/tasks/CORR-001-typescript-tooling-compatibility.md`;
- `docs/tasks/TASK-002-tooling-base.md`;
- `docs/tasks/TASK-003-modular-skeleton.md`;
- `docs/tasks/TASK-004-environment-secrets.md`;
- `docs/tasks/TASK-005-supabase-local.md`;
- `docs/tasks/CORR-002-supabase-cloud-development.md`;
- `docs/tasks/CORR-003-phase-1-gate-supabase-cloud.md`;
- `docs/tasks/TASK-006-ci-baseline.md`.

Ante conflicto directo:

- una corrección aprobada posterior prevalece únicamente dentro del alcance que modifica expresamente;
- `CORR-002` prevalece sobre las cláusulas operativas de `TASK-005` que sustituyó;
- `CORR-003` debe consumirse como sincronización aprobada del Gate de Fase 1 con la estrategia Supabase Development;
- el resto de las restricciones no sustituidas de las tareas previas continúa vigente.

## 7.4 Fuente técnica real

Además de `/docs`, la ejecución debe inspeccionar el estado real del repositorio, incluyendo como mínimo:

- `package.json`;
- `package-lock.json`;
- `tsconfig.json`;
- configuración efectiva de ESLint;
- configuración efectiva de Vitest;
- `.gitignore`;
- `.env.example`;
- existencia, tracking e ignore de cualquier `.env*`; para `.env*.local` o equivalentes sensibles se inspecciona únicamente su condición de archivo local/ignorado/no trackeado, sin leer, imprimir, copiar ni registrar sus valores;
- `app/`;
- `src/modules/`;
- `src/shared/`;
- `src/infrastructure/`;
- `src/infrastructure/config/`;
- `supabase/`;
- `supabase/config.toml`;
- `.github/workflows/ci.yml`;
- documentación técnica de setup/desarrollo que exista fuera de `/docs` y haya sido incorporada por tareas anteriores.

El repositorio real determina la sintaxis concreta de scripts y archivos. Si contradice una especificación aprobada, no se normaliza silenciosamente: se reporta.

# 8. Precondiciones

Antes de ejecutar cualquier comando que altere estado local no versionado, el ejecutor futuro debe:

1. confirmar que `TASK-007` está formalmente aprobada para ejecución;
2. confirmar que `TASK-007` fue incorporada canónicamente en `docs/tasks/TASK-007-phase-1-smoke-docs-review.md`;
3. leer íntegramente todas las fuentes del apartado 7;
4. confirmar que las versiones canónicas de `CORR-003`, `TASK-006` y `11-phase-1-scope-entry-gate.md` continúan accesibles y conservan el baseline reconciliado por esta especificación;
5. verificar que `11` no haya regresado a exigir materialmente Docker, `supabase start/status/stop` o Supabase local operativo/configurable/arrancable como Gate vigente; el nombre histórico de la fase y del Paso 6 no constituyen regresión por sí mismos;
6. verificar repositorio Git válido;
7. verificar branch/base real;
8. verificar upstream real;
9. calcular divergencia con upstream;
10. exigir worktree limpio antes de la validación;
11. registrar `HEAD` real inicial;
12. comprobar que el commit `463c908` existe localmente como referencia histórica de `TASK-006`;
13. comprobar que `463c908` es ancestro del `HEAD` actual, salvo una historia posterior explícitamente aprobada que justifique otra relación;
14. inspeccionar cambios introducidos desde `463c908` hasta el `HEAD` actual y confirmar que no existe drift técnico no autorizado;
15. confirmar que las tareas/correcciones previas están incorporadas en sus rutas canónicas y reconciliar estado documental histórico frente a estado operativo actual;
16. inspeccionar `package.json` y confirmar los scripts exactos y campos de runtime/package manager esperados por `TASK-006`;
17. inspeccionar `package-lock.json` y confirmar único lockfile/coherencia con npm;
18. inspeccionar `.github/workflows/ci.yml` antes de ejecutar checks y compararlo con `TASK-006`;
19. confirmar que ningún requisito obliga a escribir código, configuración o documentación para poder completar la revisión;
20. confirmar que no se requieren credenciales Supabase ni GitHub para la parte local;
21. confirmar que la evidencia remota de GitHub Actions puede ser aportada/verificada humanamente sin compartir secretos;
22. confirmar que la evidencia del proyecto Supabase Development necesaria para evaluar el Gate puede verificarse mediante documentación/cierre humano sanitizado, sin otorgar acceso remoto a Codex.

Debe emitirse `BLOCKER` y detenerse antes del smoke si:

- falta una fuente canónica obligatoria;
- existe una contradicción de autoridad que impide determinar cuál es el baseline vigente;
- el repositorio no es Git válido;
- no puede determinarse el upstream/base autorizado;
- el worktree no está limpio y no puede aislarse la revisión;
- el commit de referencia `463c908` no puede reconciliarse con la historia actual;
- una tarea previa declarada cerrada no existe canónicamente o su cierre no puede reconciliarse;
- ejecutar los checks exige introducir, proporcionar, trackear o exponer secretos reales no aprobados; la mera existencia o uso local de un `.env*.local` correctamente ignorado, no trackeado y fuera de superficies públicas/versionadas no constituye por sí sola `BLOCKER`;
- completar `TASK-007` requiere modificar archivos versionados;
- completar la revisión exige acceso remoto Supabase por Codex;
- completar la revisión exige resolver `DO-T03`, redactar `ADR-0003` o iniciar Fase 2.

Si una fuente existe y el baseline puede determinarse, pero se detecta drift corregible respecto de ella, se clasifica conforme a la sección 13.5 en lugar de improvisar una corrección dentro de `TASK-007`.

# 9. Estado actual consumido

La futura ejecución debe tomar el estado recibido de esta especificación sólo como referencia inicial y volver a verificar el repositorio real.

Baseline técnico esperado a contrastar, salvo decisión canónica posterior aprobada:

- Next.js `16.3.1`;
- React `19.2.8`;
- TypeScript `6.0.3`;
- TypeScript `strict: true`;
- TypeScript `noEmit: true`;
- Tailwind CSS `4.3.3`;
- ESLint `9.39.2`;
- Vitest `4.1.10`;
- Supabase CLI `2.114.0` como `devDependency`;
- package manager efectivo: `npm`;
- lockfile: `package-lock.json`;
- Node.js de referencia del baseline: `22.23.1`;
- npm de referencia del baseline: `10.9.8`;
- `package.json` sin `engines`, `packageManager` ni `devEngines`, salvo decisión posterior expresamente aprobada;
- script `lint`: `eslint .`;
- script `typecheck`: `tsc --noEmit`;
- script `test`: `vitest run`;
- script `build`: `next build`;
- script `verify`: `npm run lint && npm run typecheck && npm run test && npm run build`;
- skeleton modular incorporado;
- aliases/boundaries incorporados;
- `.env.example` incorporado;
- ownership de configuración bajo `src/infrastructure/config/`;
- `supabase/` inicializado;
- `supabase/config.toml` versionado;
- estado temporal/credenciales de Supabase fuera de Git;
- exactamente un proyecto Supabase Cloud exclusivo de Development, creado y linked manualmente por Francisco;
- Docker fuera del workflow aprobado;
- sin integración funcional de la aplicación con Supabase;
- sin schema funcional de producto;
- sin migrations funcionales;
- sin Auth funcional;
- sin tenancy funcional;
- sin RLS ejecutable;
- sin Storage funcional de producto;
- sin Realtime funcional desde la aplicación;
- sin Staging;
- sin Production;
- `.github/workflows/ci.yml` incorporado;
- CI en GitHub Actions;
- runner `ubuntu-24.04`;
- eventos PR hacia `main` + push a `main`;
- un único job;
- timeout `20 minutos`;
- sin matrix;
- sin concurrency;
- cache automática deshabilitada;
- `contents: read`;
- `persist-credentials: false`;
- checkout fijado al SHA `3d3c42e5aac5ba805825da76410c181273ba90b1` con referencia humana `v7.0.1`;
- setup-node fijado al SHA `3d7870f6218881292d183093179901ae8dc2ef85`, snapshot oficial seleccionado por seguridad posterior a `v7.0.0`;
- CI ejecuta `npm ci`, lint, typecheck, test y build como pasos separados;
- CI no duplica `npm run verify`;
- CI sin secretos del proyecto, PAT, Supabase, Docker, deployment o Fase 2+;
- evidencia remota de referencia: workflow `CI`, run `32192116475`, commit `463c908`, `completed / success`.

Node `22.23.1` y npm `10.9.8` proceden del baseline técnico previamente verificado; `package.json` no los declara mediante `engines`, `packageManager` o `devEngines`.

Los valores anteriores no autorizan upgrades ni downgrades. Si el repositorio real difiere, debe buscarse primero una decisión canónica posterior. Si no existe, la diferencia debe clasificarse como drift.

# 10. Alcance exacto

`TASK-007` cubre exclusivamente:

1. preflight de validación;
2. instalación reproducible con el lockfile existente;
3. ejecución de los checks de calidad existentes;
4. smoke real de arranque de la aplicación base;
5. inspección estructural del baseline técnico;
6. inspección de arquitectura modular y boundaries;
7. inspección de configuración/secretos;
8. inspección del baseline Supabase vigente sin Docker ni acceso remoto de Codex;
9. inspección del workflow CI existente;
10. confirmación humana de la evidencia remota de `TASK-006`;
11. auditoría documental de `/docs` y documentación técnica de setup relevante;
12. construcción de una matriz explícita del Gate de Fase 1;
13. clasificación de cualquier drift sin corregirlo;
14. emisión de un resultado final único y un informe completo.

# 11. Smoke técnico

## 11.1 Git y estado del repositorio

Debe verificarse como mínimo:

- repositorio Git válido;
- branch real;
- upstream real;
- divergencia real;
- `HEAD` real;
- worktree limpio;
- commit `463c908` disponible como referencia;
- relación de ancestro de `463c908` con el `HEAD` actual;
- inventario de cambios posteriores a `463c908`;
- ausencia de cambios técnicos no explicados por tareas/correcciones aprobadas.

La canonicalización de `TASK-007` u otros cambios documentales aprobados posteriores a `463c908` no constituyen drift técnico por sí mismos.

## 11.2 Runtime y package manager

Debe registrarse:

- `node --version`;
- `npm --version`;
- package manager efectivo;
- lockfiles existentes;
- contenido relevante de `package.json`;
- coherencia de `package-lock.json`.

Debe comprobarse:

- `npm` continúa siendo el único package manager efectivo;
- existe un único lockfile autorizado: `package-lock.json`;
- no aparecieron `yarn.lock`, `pnpm-lock.yaml`, `bun.lock`, `bun.lockb` u otros lockfiles alternativos sin una decisión aprobada;
- `package.json` conserva los scripts exactos aprobados por `TASK-006`;
- `package.json` continúa sin `engines`, `packageManager` ni `devEngines`, salvo decisión posterior aprobada;
- `package-lock.json` corresponde al `package.json` y permite `npm ci`;
- Node real y npm real se registran con su procedencia y se comparan contra el baseline aprobado sin atribuir a `package.json` restricciones que no contiene.

La CI sí debe seguir configurando Node `22.23.1` mientras no exista una decisión posterior aprobada que cambie esa estrategia.

## 11.3 Instalación y checks

Deben ejecutarse, por separado, y registrarse sus códigos de salida:

```text
npm ci
npm run lint
npm run typecheck
npm run test
npm run build
npm run verify
```

`npm run verify` debe ejecutarse localmente aunque repita los cuatro checks, porque forma parte del baseline de verificación local aprobado.

No deben modificarse scripts para conseguir un `PASS`.

No deben relajarse reglas, desactivar tests, omitir build ni utilizar flags de bypass.

## 11.4 Smoke real de ejecución de Next.js

Corresponde ejecutar un smoke real de la aplicación porque el Gate exige una aplicación base inicializada y que arranque correctamente, y el Paso 8 exige verificar que la aplicación sea ejecutable.

Después de `npm run build`, el comando de smoke será:

```text
npm run start
```

Reglas:

1. el script `start` debe existir realmente en `package.json`;
2. no debe crearse ni modificarse si falta;
3. se utiliza la URL/puerto que el proceso reporte de forma efectiva;
4. debe abrirse la ruta raíz `/` en un navegador o cliente HTTP no autenticado;
5. se observa únicamente la superficie técnica mínima del bootstrap;
6. el proceso debe permanecer estable el tiempo suficiente para confirmar que la aplicación responde sin excepción de runtime inmediata;
7. debe detenerse de forma normal mediante `Ctrl+C` después de la comprobación;
8. el cierre no debe dejar cambios versionables.

### PASS del smoke de aplicación

El smoke es `PASS` sólo si:

- `npm run start` inicia correctamente el build producido;
- la ruta raíz `/` responde/carga correctamente;
- no aparece una excepción de runtime que impida servir la página;
- la página continúa siendo una superficie técnica de bootstrap y no evidencia funcionalidad de producto adelantada;
- el proceso puede detenerse limpiamente;
- el repositorio continúa limpio respecto de archivos versionables.

### No probar en este smoke

Queda expresamente fuera:

- login;
- Supabase Auth;
- onboarding;
- usuarios;
- memberships;
- roles;
- client scope;
- tenant resolution;
- RLS;
- conectividad funcional de la aplicación con Supabase;
- CRUD;
- clientes;
- ubicaciones;
- equipos;
- formularios;
- mantenimientos;
- Evidence;
- offline/PWA funcional;
- Reporting;
- IA;
- créditos;
- pagos;
- deployment.

El smoke valida que el baseline de aplicación arranca; no inventa casos funcionales de módulos inexistentes.

## 11.5 CI existente

Debe inspeccionarse `.github/workflows/ci.yml` y compararse literalmente con `TASK-006` canónica en todos los aspectos materiales.

Debe verificarse:

1. archivo único de CI en la ruta esperada para `TASK-006`;
2. proveedor GitHub Actions;
3. eventos exclusivamente `pull_request` con destino a `main` y `push` sobre `main` dentro del baseline aprobado;
4. ausencia de `pull_request_target`;
5. ausencia de `schedule`, cron, `workflow_dispatch`, release/deployment events y automatización Staging/Production;
6. un único job de calidad;
7. runner `ubuntu-24.04`;
8. Node configurado exactamente como `22.23.1`;
9. registro no sensible de versiones efectivas de Node/npm si permanece como fue aprobado;
10. package manager `npm`;
11. instalación mediante `npm ci`;
12. `npm run lint` como paso separado;
13. `npm run typecheck` como paso separado;
14. `npm run test` como paso separado;
15. `npm run build` como paso separado;
16. `npm run verify` no duplicado en CI;
17. timeout de `20 minutos` a nivel del job;
18. ausencia de matrix;
19. ausencia de `concurrency`;
20. cache automática deshabilitada mediante `package-manager-cache: false`;
21. permisos explícitos `contents: read` y ausencia de permisos de escritura;
22. checkout con `persist-credentials: false`;
23. únicas Actions oficiales necesarias: `actions/checkout` y `actions/setup-node`;
24. referencia ejecutable checkout exacta: `actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1`;
25. comentario humano de checkout equivalente a `# v7.0.1`;
26. referencia ejecutable setup-node exacta: `actions/setup-node@3d7870f6218881292d183093179901ae8dc2ef85`;
27. setup-node descrito como snapshot oficial seleccionado por seguridad posterior a `v7.0.0`, no como una release parcheada posterior;
28. ningún Action de terceros;
29. ningún tag flotante, `@main` o SHA abreviado como referencia ejecutable;
30. cero secretos proporcionados por el proyecto;
31. ningún PAT/token personalizado;
32. ninguna credencial de deployment;
33. ninguna credencial Supabase;
34. CI no ejecuta Supabase CLI;
35. CI no accede a Supabase Cloud;
36. CI no requiere Docker;
37. CI no despliega ni publica releases;
38. CI no configura Staging/Production;
39. CI no introduce schema, migrations, RLS, Auth o funcionalidad de Fase 2+.

`TASK-007` no vuelve a seleccionar Actions, no actualiza sus SHA y no crea una política global de pinning. Cualquier divergencia respecto del snapshot aprobado se reporta; no se corrige silenciosamente.

## 11.6 Evidencia remota de TASK-006

Debe confirmarse humanamente la evidencia de referencia:

- workflow: `CI`;
- run id: `32192116475`;
- commit: `463c908`;
- status: `completed`;
- conclusion: `success`.

La comprobación remota:

- no exige que Codex disponga de GitHub PAT;
- no exige compartir credenciales;
- puede realizarla el operador humano desde GitHub;
- debe registrar únicamente metadata no sensible suficiente;
- no requiere re-run del workflow para satisfacer `TASK-007`.

La evidencia debe correlacionarse con el workflow incorporado por `TASK-006`. Crear/parsear YAML localmente no sustituye esta evidencia remota, porque la DoD de `TASK-006` exigió ejecución real satisfactoria en GitHub.

Si la evidencia no puede verificarse y no existe evidencia canónica equivalente ya incorporada, la revisión queda `BLOCKER` por falta de evidencia; no se inventa un `PASS`.

# 12. Revisión estructural

Debe inspeccionarse el baseline de Fase 1 para detectar drift respecto de las tareas aprobadas.

## 12.1 Next.js / React / TypeScript

Verificar:

- una única aplicación Next.js principal;
- App Router preservado;
- Next.js `16.3.1`, salvo decisión posterior aprobada;
- React `19.2.8`, salvo decisión posterior aprobada;
- TypeScript `6.0.3`, salvo decisión posterior aprobada;
- `strict: true` efectivo;
- `noEmit: true` efectivo;
- no `any` deliberado introducido como bypass de setup;
- build de producción exitoso.

Para validar la configuración efectiva de TypeScript puede utilizarse:

```text
npx tsc --showConfig
```

La comprobación debe confirmar `strict` y `noEmit` efectivos, no sólo confiar en una lectura superficial si existen `extends` o configuración derivada.

## 12.2 Tailwind

Verificar:

- Tailwind `4.3.3` continúa presente conforme al baseline, salvo decisión posterior aprobada;
- no fue sustituido por otro stack de estilos sin decisión aprobada;
- el styling sigue limitado al baseline técnico y no evidencia UI funcional adelantada.

## 12.3 ESLint / Vitest / scripts

Verificar:

- ESLint `9.39.2` presente y operativo, salvo decisión posterior aprobada;
- Vitest `4.1.10` presente y operativo, salvo decisión posterior aprobada;
- configuración mínima preservada;
- scripts exactos:
  - `lint = eslint .`;
  - `typecheck = tsc --noEmit`;
  - `test = vitest run`;
  - `build = next build`;
  - `verify = npm run lint && npm run typecheck && npm run test && npm run build`;
- smoke test técnico base del test runner preservado cuando forme parte del baseline;
- no se introdujeron E2E, coverage gates, SAST u otro tooling de fases posteriores sin tarea aprobada.

## 12.4 Skeleton modular

Debe preservarse la estructura mínima aprobada equivalente a:

```text
app/

src/
  modules/
  shared/
  infrastructure/
```

Verificar:

- no existen bounded contexts funcionales creados por anticipación;
- `app/` continúa orientado a routing/composición;
- `src/modules/` continúa sin dominio funcional de Fase 2+;
- `src/shared/` no se convirtió en depósito genérico de dominio/helpers ambiguos;
- `src/infrastructure/` no se convirtió en un segundo `shared`;
- no se introdujeron microservicios, monorepo o deployables adicionales;
- la estructura continúa compatible con el monolito modular de `ADR-0001`.

La revisión debe respetar que `ADR-0001` define capas conceptuales, no una obligación dogmática de cuatro directorios físicos finales.

## 12.5 Aliases y boundaries/import rules

Verificar contra `TASK-003` canónica:

- aliases explícitos equivalentes a `@modules/*`, `@shared/*`, `@infrastructure/*` cuando sean los aprobados vigentes;
- alias general previo preservado cuando corresponda;
- no deep imports arbitrarios cross-module;
- regla arquitectónica `src/**` no depende de `app/**`;
- `shared` no depende de módulos funcionales;
- `shared` no depende de infraestructura común;
- infraestructura común no depende de `app/` ni de internals arbitrarios de módulos;
- enforcement ESLint proporcional preservado;
- no se añadió tooling pesado de boundaries sin una tarea aprobada.

No debe afirmarse cobertura mecánica total si `TASK-003` sólo aprobó enforcement del subconjunto estático robustamente expresable.

## 12.6 Configuración y secretos

Verificar contra `TASK-004`:

- `.env.example` existe en la ubicación aprobada;
- no contiene secretos reales;
- no contiene variables de proveedor anticipadas que sigan fuera de alcance;
- archivos `.env*.local` y equivalentes sensibles pueden contener secretos reales siempre que permanezcan correctamente ignorados, no trackeados, fuera de `.env.example`, fuera de superficies client-side y fuera de CI;
- para `.env*.local` y equivalentes sensibles se inspeccionan únicamente existencia, tracking e ignore; no deben leerse, imprimir, copiar ni registrar sus valores y no es necesario demostrar que esos archivos estén libres de secretos;
- la mera existencia de un archivo local ignorado que potencialmente contenga secretos no constituye por sí sola `BLOCKER`;
- no hay secreto real trackeado;
- ownership de configuración común permanece bajo `src/infrastructure/config/`;
- no existe `shared/env`, `shared/utils/env` ni helper equivalente sin ownership aprobado;
- separación pública/privada preservada;
- no existe barrel que mezcle configuración pública y privada;
- accesos de aplicación a `process.env` continúan restringidos conforme a la tarea aprobada;
- `NEXT_PUBLIC_*` se trata como público y no contiene secretos privados;
- no existe `SUPABASE_SERVICE_ROLE_KEY` o equivalente incorporado como contrato/configuración de aplicación.

Debe devolverse `BLOCKER` de seguridad cuando exista evidencia de exposición o gestión incorrecta de secretos, incluyendo como mínimo:

- secreto real trackeado por Git;
- secreto real presente en `.env.example`;
- secreto privado expuesto mediante `NEXT_PUBLIC_*` o cualquier otra superficie client-side;
- secreto incorporado al workflow CI;
- PAT, token o credencial sensible incorporada al repositorio;
- `service-role` incorporado al contrato/configuración de aplicación;
- cualquier valor sensible que pudiera quedar expuesto mediante una ruta versionada o pública.

Si durante una comprobación segura se descubre accidentalmente un valor sensible expuesto:

- no reproducirlo;
- no copiarlo al informe;
- detener cualquier inspección que aumente la exposición;
- devolver `BLOCKER` de seguridad;
- no rotarlo ni borrarlo silenciosamente dentro de `TASK-007`;
- registrar únicamente el archivo/superficie y la categoría del hallazgo, sin el valor;
- dejar remediación, rotación o revocación fuera de `TASK-007`.

## 12.7 Baseline Supabase de Development

La revisión debe comprobar el criterio vigente completo de `CORR-002/CORR-003`, no el lifecycle histórico de `TASK-005`.

Verificar:

1. Supabase CLI forma parte del proyecto como tooling reproducible y pinneado; la baseline esperada es `supabase@2.114.0` como `devDependency` salvo decisión posterior aprobada.
2. `package-lock.json` resuelve coherentemente esa dependencia.
3. `supabase/` está inicializado en la raíz.
4. `supabase/config.toml` está presente y versionado.
5. Estado temporal, sesiones y credenciales de CLI permanecen fuera de Git.
6. Existe exactamente un proyecto Supabase Cloud exclusivo de Development según la evidencia humana/canónica de cierre.
7. Ese proyecto fue creado manualmente.
8. Ese proyecto fue linked manualmente por Francisco.
9. Login/link permanecen bajo operación manual de Francisco.
10. Codex continúa sin credenciales, tokens, passwords ni acceso remoto.
11. Operaciones remotas continúan manuales salvo decisión posterior explícita.
12. Docker no es requisito.
13. `supabase start/status/stop` no son Gate vigente.
14. No existe schema funcional del SaaS.
15. No existen migrations funcionales de producto de Fase 1.
16. `db push` no es requisito y no debe convertirse en uno.
17. La aplicación Next.js no está integrada funcionalmente con Supabase.
18. No existe cliente Supabase de aplicación anticipado, incluyendo `@supabase/supabase-js` o `@supabase/ssr`, salvo autorización posterior explícita.
19. No existen variables de conexión Supabase de aplicación anticipadas en `.env.example`.
20. No existe Auth funcional.
21. No existe tenancy funcional.
22. No existe RLS ejecutable.
23. No existe Storage funcional de producto.
24. No existe Realtime funcional desde la aplicación.
25. No existe `service-role` en el contrato de aplicación.
26. No existe Staging.
27. No existe Production.
28. La presencia de servicios administrados nativos en el proyecto Development no se interpreta como implementación funcional del producto.

Puede registrarse localmente la versión de CLI mediante:

```text
npx supabase --version
```

Este comando se ejecuta después de `npm ci` y sólo valida la CLI instalada por el proyecto. No autoriza conexión remota.

No se ejecutan `supabase login`, `supabase link`, `db push`, `db pull`, `db dump`, `db diff`, `migration repair`, `db reset --linked` ni otra operación remota/autenticada por Codex.

## 12.8 CI baseline

Verificar que `.github/workflows/ci.yml` conserva exactamente el baseline material aprobado por `TASK-006`:

- GitHub Actions;
- PR hacia `main` + push a `main`;
- no `pull_request_target`;
- un job;
- `ubuntu-24.04`;
- Node `22.23.1`;
- npm + `package-lock.json` + `npm ci`;
- lint/typecheck/test/build como pasos separados;
- `verify` sólo como check local agregado, no duplicado en CI;
- timeout 20 minutos;
- sin matrix;
- sin concurrency;
- `package-manager-cache: false` y sin cache manual;
- `contents: read` sin write permissions;
- `persist-credentials: false`;
- sólo `actions/checkout` y `actions/setup-node`;
- checkout SHA `3d3c42e5aac5ba805825da76410c181273ba90b1` con contexto humano `v7.0.1`;
- setup-node SHA `3d7870f6218881292d183093179901ae8dc2ef85`, snapshot oficial seleccionado por seguridad posterior a `v7.0.0`;
- cero secretos del proyecto;
- ningún PAT;
- ningún secreto/credencial Supabase;
- ninguna credencial de deployment;
- no Supabase CLI/remoto;
- no Docker;
- no deployment/release;
- no Staging/Production;
- no schema/migrations/RLS/Auth/Fase 2+.

La revisión de `TASK-007` comprueba drift del workflow existente; no vuelve a aplicar el preflight de selección de SHA que `TASK-006` exigió antes de su creación y no cambia referencias por una release nueva. Si una vulnerabilidad material nueva fuese conocida durante la revisión y volviera inseguro el workflow existente, debe reportarse como hallazgo para corrección separada; no actualizarlo dentro de `TASK-007`.

# 13. Revisión documental

## 13.1 Objetivo

Auditar consistencia de `/docs` y de la documentación técnica directamente asociada a Fase 1, sin modificarla.

Cada hallazgo debe contener:

- archivo;
- ubicación/sección o línea cuando sea posible;
- texto/concepto observado, sin reproducir secretos;
- fuente canónica que lo contradice o confirma;
- severidad;
- clasificación;
- acción posterior propuesta.

## 13.2 Búsquedas obligatorias

Debe buscarse específicamente:

1. referencias activas obsoletas a Supabase local/Docker que contradigan `CORR-002/CORR-003`;
2. ocurrencias de `Supabase local` que sean legítimas por conservar el nombre normativo de Fase 1 o el título histórico del Paso 6, distinguiéndolas de una exigencia operativa obsoleta;
3. exigencias activas de runtime Docker-compatible;
4. exigencias activas de `supabase start`, `supabase status` o `supabase stop` como Gate;
5. referencias a `arrancable`, `configurable` u `operativo` aplicadas a un stack Supabase local vigente;
6. referencias históricas legítimas dentro de `TASK-005` y dentro de la explicación de `CORR-002/CORR-003`;
7. `db push` presentado incorrectamente como requisito de Fase 1;
8. estados de tareas/correcciones que confundan el estado documental histórico con el estado operativo actual;
9. referencias que hagan parecer `TASK-006` operativamente pendiente cuando el estado recibido y la evidencia remota lo sitúan `DONE`;
10. referencias que indiquen Fase 2 iniciada;
11. referencias que indiquen Staging o Production existentes;
12. referencias que conviertan el proyecto Development en Staging/Production o en nueva frontera tenant;
13. contradicciones entre el Gate de Fase 1 y `CORR-002/CORR-003`;
14. rutas canónicas rotas o nombres de tareas incompatibles con archivos reales;
15. ADR aceptados citados con estado incorrecto;
16. `ADR-0003` tratado como `ACCEPTED`, implementado o resuelto;
17. `DO-T03` tratado como resuelto/aprobado cuando el Gate lo mantiene `PARCIALMENTE ABIERTO` y bloqueando `ADR-0003`;
18. documentación que autorice integración funcional de la aplicación con Supabase dentro de Fase 1;
19. documentación que autorice schema, migrations, Auth, tenancy, RLS, Storage o Realtime funcional dentro de Fase 1;
20. documentación que introduzca `service-role` de aplicación;
21. documentación que utilice ADR aceptados de fases futuras como autorización de implementación anticipada;
22. referencias a deployment/release como capacidades de `TASK-006`;
23. documentación de CI que contradiga los eventos, runner, Node, checks, permisos, Actions/SHA, cache, timeout o restricciones de `TASK-006`;
24. documentación técnica de setup que ya no permita reproducir los comandos realmente vigentes;
25. referencias de versiones de stack que contradigan cambios canónicos posteriores;
26. enlaces/rutas internas a archivos canónicos inexistentes;
27. cualquier otra divergencia material producida por `TASK-001`…`TASK-006` y `CORR-001`…`CORR-003`.

## 13.3 No confundir historia con estado vigente

La auditoría no debe marcar automáticamente como error toda aparición de términos sustituidos.

Ejemplos normativos:

- el nombre oficial continúa siendo `Fase 1 — Setup, repositorio, CI y Supabase local`;
- el Paso 6 continúa titulado `Supabase local` por trazabilidad histórica, pero su contenido operativo vigente es Cloud Development conforme a `CORR-002`;
- `TASK-005` conserva la estrategia original como registro histórico;
- `CORR-002` y `CORR-003` explican la sustitución;
- una mención histórica correctamente contextualizada no es drift;
- una instrucción activa que vuelva a exigir Docker o `start/status/stop` sí es drift.

La clasificación debe considerar autoridad, fecha, contexto y alcance de cada corrección.

## 13.4 Estados documentales vs estados operativos

La auditoría debe distinguir:

- estado documental de una especificación, por ejemplo `APPROVED FOR IMPLEMENTATION`;
- estado operativo posterior de una tarea ejecutada/cerrada.

No debe declararse inconsistencia sólo porque una especificación histórica conserve el estado con el que fue aprobada, salvo que el documento pretenda simultáneamente describir el estado operativo actual y lo haga incorrectamente.

En particular, la ruta canónica de `TASK-006` puede conservar `APPROVED FOR IMPLEMENTATION` como estado de su especificación aunque el ciclo de implementación haya sido cerrado operativamente y exista evidencia remota satisfactoria posterior.

## 13.5 Clasificación de hallazgos

### Informativo / sin acción

Referencia histórica correcta o diferencia no material que no contradice el baseline.

No cambia el resultado global.

### `REQUIRES CORRECTION`

Drift documental o técnico concreto cuya corrección debe realizarse mediante una tarea/corrección separada antes de cerrar `TASK-007`.

Ejemplos:

- una instrucción vigente vuelve a exigir Docker como Gate;
- documentación operativa instruye `supabase start` como workflow actual;
- `TASK-006` aparece operativamente pendiente en un documento que declara estado actual;
- ruta canónica rota;
- estado de ADR/DO incorrecto en documentación vigente;
- workflow CI con drift respecto de `TASK-006`;
- documentación del paso 8 omite o contradice una condición real del Gate.

### `BLOCKER`

Contradicción o ausencia de fuente/evidencia que impide determinar el baseline autoritativo o completar la revisión con seguridad.

Ejemplos:

- fuente canónica obligatoria ausente;
- dos fuentes actuales de igual autoridad ordenan estrategias incompatibles sin override explícito;
- falta una tarea previa que se declara cerrada y no puede reconciliarse;
- evidencia esencial no puede obtenerse ni reconstruirse;
- continuar podría exponer secretos.

No se corrige nada dentro de `TASK-007`.

# 14. Revisión del Gate de Fase 1

La ejecución debe producir una matriz explícita que reproduzca sin reformulación material las doce condiciones canónicas de salida de Fase 1 y añada únicamente la evidencia concreta usada para evaluarlas.

Estados permitidos por fila:

- `PASS`;
- `FAIL`;
- `BLOCKER`;
- `NOT APPLICABLE`.

La matriz mínima obligatoria es:

| # | Requisito canónico del Gate de salida de Fase 1 | Fuente | Evidencia mínima de TASK-007 | Estado | Observación |
|---|---|---|---|---|---|
| 1 | La aplicación base definida por el stack aprobado está inicializada y arranca correctamente | `11` §14.1.1 | build + `npm run start` + `/` accesible | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | Smoke técnico, no funcional |
| 2 | TypeScript estricto está activo y el proyecto supera typecheck | `11` §14.1.2 | `tsc --showConfig` + `npm run typecheck` | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | Confirmar `strict` y `noEmit` |
| 3 | El skeleton respeta `ADR-0001` y no introduce dependencias circulares o acoplamiento arbitrario evidente | `11` §14.1.3; `ADR-0001`; `TASK-003` | inspección estructura/boundaries/imports | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | No imponer una taxonomía más rígida que la aprobada |
| 4 | El proyecto dispone de lint, tests base y build verificables | `11` §14.1.4; `TASK-002` | `npm run lint`, `npm run test`, `npm run build`; `verify` como regresión local adicional | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | `verify` no sustituye el requisito canónico ni se duplica en CI |
| 5 | CI ejecuta los checks acordados para el baseline de Fase 1 | `11` §14.1.5; `TASK-006` | auditoría exacta de `.github/workflows/ci.yml` + run `32192116475` | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | GitHub Actions; lint/typecheck/test/build separados |
| 6 | El baseline Supabase de Development cumple `CORR-002`: CLI fijada, `supabase/` inicializado, `supabase/config.toml` versionado y proyecto Cloud exclusivo de Development bajo operación manual de Francisco | `11` §14.1.6; `CORR-002`; `CORR-003` | repo + evidencia humana/canónica de Development + validación de ausencia de Docker/integración funcional | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | No usar el lifecycle histórico de TASK-005 como criterio vigente |
| 7 | La configuración de entorno no expone secretos al cliente ni al repositorio | `11` §14.1.7; `TASK-004` | `.env*`, `.env.example`, config ownership y tracking | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | Exposición o gestión incorrecta de secreto => BLOCKER de seguridad; secreto local correctamente ignorado/no trackeado no bloquea |
| 8 | La documentación mínima de desarrollo está actualizada | `11` §14.1.8 | auditoría `/docs` + documentación operativa del setup | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | Drift material => `REQUIRES CORRECTION` global |
| 9 | No existen migrations/schema/policies RLS de producto introducidos prematuramente | `11` §14.1.9; `CORR-002/CORR-003`; `ADR-0002` | inspección `supabase/`, migrations/schema/policies y código | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | RLS sigue siendo obligatoria cuando exista dato tenant-owned |
| 10 | No existe funcionalidad de Fase 2+ adelantada | `11` §14.1.10; `00`; `01` | inspección `app/`, `src/`, deps y config | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | ADR aceptado no equivale a autorización de fase |
| 11 | Las tareas implementadas fueron revisadas y sus pruebas quedaron registradas | `11` §14.1.11; `TASK-001..006`; `CORR-001..003` | trazabilidad canónica + evidencias/cierres disponibles | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | No inferir cierre por presencia de código |
| 12 | El repositorio queda en un estado coherente y verificable al cierre de la fase | `11` §14.1.12 | Git limpio, checks, smoke, CI, documentación y matriz sin drift pendiente | `PASS / FAIL / BLOCKER / NOT APPLICABLE` | TASK-007 evalúa esta condición; no ejecuta el cierre formal de fase |

La matriz no debe añadir nuevas condiciones de salida, eliminar ninguna de las doce ni convertir checks auxiliares de una tarea previa en requisitos autónomos del Gate.

## 14.1 Condición adicional para cruzar hacia Fase 2

Debe registrarse separadamente, sin mezclarla con las doce condiciones de salida de Fase 1:

| Requisito de entrada a Fase 2 | Estado esperado durante TASK-007 | Interpretación |
|---|---|---|
| `ADR-0002 = ACCEPTED` | verificar, sin modificar | ya cumplido según baseline |
| `DO-T03` | `PARCIALMENTE ABIERTO` | no resolver en TASK-007 |
| `ADR-0003 = ACCEPTED` | pendiente / no cumplido | `ADR-0003 = BLOCKED BY DO-T03` |

Por tanto:

- la salida técnica de Fase 1 y la entrada a Fase 2 son controles relacionados pero no idénticos;
- un eventual `PASS` de `TASK-007` no autoriza Fase 2;
- Fase 2 permanece `NO INICIADA` durante esta tarea.

# 15. Estrategia de ejecución

## 15.1 Decisión

La estrategia recomendada para una ejecución concreta de `TASK-007` que haya recibido autorización humana separada es:

`Codex en modo inspección/verificación local + pasos humanos de evidencia remota + revisión humana final`

El estado `APPROVED FOR EXECUTION` de esta especificación no inicia ni autoriza por sí solo una ejecución concreta. Cada ejecución requiere una autorización humana separada y explícita. Cuando esa autorización externa exista, la ejecución es compatible con esta especificación y debe respetar íntegramente sus límites.

## 15.2 Responsabilidad futura de Codex

Si posteriormente se autoriza explícitamente a Codex, sólo podrá:

- leer las fuentes canónicas;
- inspeccionar archivos del repositorio;
- ejecutar los comandos locales de validación definidos;
- iniciar/detener el proceso Next.js para smoke;
- revisar diffs/estado Git;
- producir el informe de validación;
- identificar hallazgos;
- clasificar `PASS`, `FAIL`, `BLOCKER` o `REQUIRES CORRECTION`.

Codex no podrá:

- editar archivos versionados;
- corregir drift;
- modificar `/docs`;
- hacer commit;
- hacer push;
- abrir PR;
- ejecutar operaciones autenticadas contra Supabase Cloud;
- recibir credenciales Supabase;
- recibir GitHub PAT;
- reconfigurar CI;
- re-run remoto por iniciativa propia;
- generar la tarea del paso 9;
- resolver `DO-T03`;
- redactar `ADR-0003`;
- iniciar Fase 2.

## 15.3 Responsabilidad humana

El operador humano debe:

- aportar/verificar la evidencia remota de GitHub Actions sin compartir credenciales;
- aportar, cuando sea necesario para el Gate, la evidencia sanitizada ya aprobada del estado Supabase Development;
- revisar el informe final;
- decidir si un hallazgo requiere `CORR-*` o una tarea separada;
- decidir formalmente el cierre o no de `TASK-007`;
- autorizar por separado cualquier paso posterior.

# 16. Archivos permitidos/modificables

## 16.1 Regla primaria

Archivos versionados modificables durante la ejecución:

`0`

`TASK-007` es una tarea de validación.

## 16.2 Archivos permitidos para lectura

Puede leerse todo archivo necesario para la validación dentro del repositorio, especialmente los enumerados en el apartado 7.4.

## 16.3 Artefactos locales no versionados

Se permiten únicamente artefactos técnicos inevitables y no versionados producidos por comandos aprobados, por ejemplo:

- `node_modules/` por `npm ci`;
- `.next/` por build/start;
- caches locales ignoradas producidas por tooling existente.

Reglas:

- deben estar ignorados o ser claramente no versionables conforme al baseline;
- no deben incorporarse a Git;
- si un comando genera un archivo nuevo no ignorado que debería versionarse para mantener reproducibilidad, no se corrige dentro de `TASK-007`; se reporta `REQUIRES CORRECTION`;
- no se ejecutan comandos destructivos de limpieza global para ocultar drift.

## 16.4 Informe

El informe de ejecución puede entregarse fuera del repositorio. No debe crearse automáticamente un documento canónico nuevo bajo `/docs` durante esta tarea.

# 17. Dentro de alcance

Está dentro de alcance:

- verificación Git;
- verificación de versiones;
- verificación de package manager/lockfile;
- `npm ci`;
- lint;
- typecheck;
- tests base;
- build;
- verify;
- smoke real de `npm run start`;
- inspección de Next.js/React/TypeScript/Tailwind;
- inspección ESLint/Vitest;
- inspección de skeleton/aliases/boundaries;
- inspección de entorno/secretos;
- inspección Supabase CLI/config local;
- inspección de ausencia de schema/migrations funcionales;
- inspección del workflow CI;
- verificación humana de la evidencia remota de `TASK-006`;
- auditoría documental;
- matriz del Gate;
- reporte de drift;
- clasificación final.

# 18. Fuera de alcance

Queda completamente fuera de `TASK-007`:

- implementar funcionalidad de producto;
- crear o modificar schema funcional;
- crear o modificar migrations funcionales;
- crear SQL de producto;
- implementar Supabase Auth;
- implementar RLS;
- implementar tenancy;
- implementar `MaintenanceCompany`;
- implementar `PlatformUser`;
- implementar memberships;
- implementar roles;
- implementar `UserClientAccess`;
- implementar `SupportAccessGrant`;
- implementar clientes;
- implementar locations;
- implementar equipment/equipment types;
- implementar Form Engine;
- implementar Maintenance;
- implementar Evidence;
- implementar Offline/Dexie/Service Worker/sync;
- implementar Reporting/PDF/DOCX;
- implementar OpenAI/IA;
- implementar créditos IA;
- implementar Mercado Pago/pagos/suscripción;
- implementar notificaciones;
- implementar dashboard;
- modificar ADR;
- crear ADR nuevo;
- resolver `DO-T03`;
- redactar `ADR-0003`;
- cambiar estado de `ADR-0003`;
- iniciar Fase 2;
- crear Staging;
- crear Production;
- crear Supabase Branching;
- automatizar Supabase remoto;
- ejecutar migrations remotas;
- dar credenciales Supabase a Codex;
- requerir Docker;
- reparar/configurar Docker;
- configurar deployment;
- modificar versiones de dependencias;
- actualizar Node/npm;
- cambiar package manager;
- modificar scripts para que los checks pasen;
- relajar TypeScript/ESLint/tests;
- realizar refactors;
- modificar documentación para eliminar hallazgos;
- hacer commit;
- hacer push;
- generar automáticamente una tarea del paso 9.

# 19. Restricciones

1. `/docs` del repositorio real es la fuente de verdad canónica.
2. Una corrección posterior aprobada prevalece únicamente dentro de su alcance explícito.
3. No se infiere cierre de una tarea por la presencia de código.
4. No se infiere Fase 1 completada por checks verdes.
5. No se infiere Fase 2 habilitada por Fase 1 saludable.
6. No se corrige drift dentro de una tarea de validación.
7. No se oculta un error mediante flags de bypass.
8. No se instala tooling nuevo.
9. No se actualizan dependencias.
10. No se modifica lockfile.
11. No se introducen secretos.
12. No se imprimen secretos existentes.
13. No se accede a Supabase Cloud desde Codex.
14. No se requiere Docker.
15. No se cambia CI.
16. No se reescribe historia Git.
17. No se crea ningún commit.
18. No se hace push.
19. No se genera el paso 9.
20. Cualquier contradicción material se clasifica explícitamente.

# 20. Seguridad

Impacto de seguridad de `TASK-007`:

`VALIDACIÓN DE CONTROLES EXISTENTES — SIN IMPLEMENTACIÓN DE AUTORIZACIÓN`

Debe verificarse:

- ausencia de secretos reales en Git;
- ausencia de secretos reales en `.env.example`;
- ausencia de secreto privado expuesto mediante `NEXT_PUBLIC_*` o cualquier otra superficie client-side;
- archivos `.env*.local` o equivalentes sensibles, si existen, correctamente ignorados y no trackeados; pueden contener secretos reales localmente y esa existencia no constituye por sí sola `BLOCKER`;
- para archivos locales sensibles se verifica sólo existencia, tracking e ignore, sin leer, imprimir, copiar ni registrar valores y sin exigir demostrar que no contienen secretos;
- ausencia de `service-role` en el contrato/configuración de aplicación;
- ausencia de credenciales Supabase en CI;
- ausencia de GitHub PAT o tokens personalizados para el baseline;
- ausencia de credenciales de deployment;
- permisos CI exactamente `contents: read` y ningún permiso de escritura;
- `pull_request_target` ausente;
- checkout con `persist-credentials: false`;
- sólo las Actions oficiales aprobadas y los SHA fijados por `TASK-006`;
- cero secretos proporcionados por el proyecto al workflow;
- CI sin acceso a Supabase, Docker, Staging, Production o deployment;
- configuración server/client de `TASK-004` preservada;
- frontend no tratado como autoridad de seguridad;
- ninguna implementación anticipada de tenancy/RLS.

Impacto RLS:

`NO APLICA COMO IMPLEMENTACIÓN — no existe schema funcional de producto en Fase 1`

La revisión debe confirmar que esta ausencia responde a la frontera de fase, no a una renuncia a RLS. `ADR-0002` mantiene RLS obligatoria cuando existan datos tenant-owned.

La existencia del proyecto Supabase Development tampoco constituye por sí sola autorización, tenancy ni aislamiento implementado.

Debe devolverse `BLOCKER` de seguridad cuando se detecte evidencia de exposición o gestión incorrecta, incluyendo como mínimo:

- secreto real trackeado por Git;
- secreto real presente en `.env.example`;
- secreto privado expuesto mediante `NEXT_PUBLIC_*` o superficie client-side;
- secreto incorporado al workflow CI;
- PAT, token o credencial sensible incorporada al repositorio;
- `service-role` incorporado al contrato/configuración de aplicación;
- cualquier valor sensible que pudiera quedar expuesto mediante una ruta versionada o pública.

Si durante una comprobación segura se descubre accidentalmente un valor sensible expuesto:

- no reproducirlo;
- no copiarlo al informe;
- detener cualquier inspección que aumente la exposición;
- devolver `BLOCKER`;
- dejar remediación/rotación/revocación fuera de `TASK-007`.

# 21. Supabase

## 21.1 Regla vigente

El baseline que debe validarse es el corregido por `CORR-002` y reflejado en el Gate canónico después de `CORR-003`, no el lifecycle Docker original de `TASK-005`.

El nombre normativo `Fase 1 — Setup, repositorio, CI y Supabase local` y el heading `Paso 6 — Supabase local` se conservan por trazabilidad histórica; no son una obligación de operar un stack local.

## 21.2 Criterio completo a validar

El componente Supabase sólo puede evaluarse `PASS` si la evidencia conjunta confirma:

1. CLI reproducible y pinneada en el proyecto;
2. `supabase/` inicializado;
3. `supabase/config.toml` versionado;
4. temporales/sesiones/credenciales fuera de Git;
5. exactamente un proyecto Cloud exclusivo de Development;
6. creación manual del proyecto;
7. link manual por Francisco;
8. login/link bajo operación manual de Francisco;
9. Codex sin credenciales/acceso remoto;
10. operaciones remotas manuales;
11. Docker no requerido;
12. `start/status/stop` local no requerido como Gate;
13. sin schema funcional;
14. sin migrations funcionales de producto de Fase 1;
15. `db push` no requerido;
16. app Next.js no integrada funcionalmente;
17. sin cliente Supabase de aplicación anticipado;
18. sin Auth funcional;
19. sin tenancy funcional;
20. sin RLS ejecutable;
21. sin Storage funcional de producto;
22. sin Realtime funcional desde la aplicación;
23. sin `service-role` en contrato de aplicación;
24. sin Staging;
25. sin Production;
26. capacidades nativas del proyecto Development no interpretadas como capacidades de producto implementadas.

## 21.3 Validaciones locales permitidas

Se permite:

- comprobar `supabase@2.114.0` en `package.json`;
- comprobar su resolución en `package-lock.json`;
- ejecutar `npx supabase --version` después de `npm ci`;
- inspeccionar `supabase/`;
- inspeccionar `supabase/config.toml`;
- inspeccionar tracking/ignore de `supabase/.temp/` y estado temporal equivalente;
- comprobar ausencia de migrations/schema/seed funcionales;
- comprobar ausencia de cliente/variables de integración de aplicación;
- comprobar ausencia de `service-role`.

## 21.4 Operaciones prohibidas durante TASK-007

No ejecutar:

- `supabase start`;
- `supabase status` del stack local;
- `supabase stop`;
- `supabase login`;
- `supabase link`;
- `supabase db push`;
- `supabase db push --dry-run`;
- `supabase db pull`;
- `supabase db dump`;
- `supabase db diff`;
- `supabase migration list --linked`;
- `supabase migration repair`;
- `supabase db reset --linked`;
- Management API;
- Dashboard como medio de corregir estado;
- cualquier operación remota autenticada por Codex.

## 21.5 Evidencia humana del proyecto Development

La condición de existencia del proyecto Development, su creación/link manual y la ausencia de Staging/Production se verifica mediante la trazabilidad/cierre canónico existente y, cuando sea necesario, evidencia humana sanitizada.

`TASK-007` no obliga a una nueva autenticación remota ni a repetir `login/link`.

Si una condición del Gate no puede demostrarse con evidencia disponible sin ampliar permisos, se reporta `BLOCKER` de evidencia; no se inventa un `PASS`.

# 22. Fases / ADR / DO-T03

## 22.1 Fase 1

`TASK-007` valida exclusivamente el paso 8 y produce la evidencia con la que puede evaluarse el Gate de salida de Fase 1.

Un resultado `PASS` de `TASK-007` significa:

- las validaciones del paso 8 pasaron;
- las doce condiciones canónicas del Gate pudieron evaluarse sin drift material pendiente dentro del alcance de esta tarea;
- el informe queda disponible para decisión humana de Gate.

`PASS` de `TASK-007` NO ejecuta por sí mismo la declaración formal:

`Fase 1 = COMPLETADA`

La decisión formal de cierre de Fase 1 corresponde a un Gate humano separado después de revisar la evidencia.

## 22.2 Fase 2

Fase 2 debe continuar:

`NO INICIADA`

No se autoriza ninguna capacidad de identidad, Auth, multitenancy, roles o RLS.

Completar técnicamente Fase 1 no autoriza automáticamente comenzar Fase 2.

## 22.3 ADR-0003

Durante `TASK-007` debe mantenerse:

`ADR-0003 = BLOCKED BY DO-T03`

El Gate canónico exige `ADR-0003 = ACCEPTED` antes de implementar identidad/autorización de Fase 2.

`TASK-007` no puede redactarlo, aprobarlo, modificarlo ni cambiar su estado.

## 22.4 DO-T03

El estado canónico a preservar durante esta revisión es:

`DO-T03 = PARCIALMENTE ABIERTO`

`TASK-007` no resuelve ninguna parte de `DO-T03`.

Si documentación vigente lo presenta como resuelto/aprobado sin una decisión posterior canónica, debe clasificarse como drift material.

## 22.5 Paso 9

`TASK-007` no diseña ni inicia el Paso 9.

El Gate canónico indica que el Paso 9 sólo ocurre después de completar formalmente Fase 1 y comprende, mediante autorización separada:

- revisar `DO-T03`;
- realizar el proceso documental necesario para desbloquear `ADR-0003`;
- redactar/revisar/aprobar `ADR-0003` en un paso separado;
- evaluar el Gate de entrada de Fase 2.

Nada de lo anterior forma parte de `TASK-007`.

# 23. Comandos / verificaciones futuras

Los comandos exactos mínimos de la futura ejecución son:

## 23.1 Git

```text
git rev-parse --is-inside-work-tree
git branch --show-current
git rev-parse HEAD
git rev-parse --abbrev-ref --symbolic-full-name @{u}
git rev-list --left-right --count HEAD...@{u}
git status --porcelain=v1 --untracked-files=all
git cat-file -e 463c908^{commit}
git merge-base --is-ancestor 463c908 HEAD
git diff --name-status 463c908..HEAD
```

La sintaxis de `@{u}` debe ejecutarse en un shell que la preserve correctamente; si el host requiere quoting, se utiliza el equivalente sin cambiar la semántica.

## 23.2 Runtime

```text
node --version
npm --version
```

## 23.3 Instalación y checks

```text
npm ci
npm run lint
npm run typecheck
npm run test
npm run build
npm run verify
```

## 23.4 TypeScript efectivo

```text
npx tsc --showConfig
```

Debe verificarse `strict: true` y `noEmit: true` efectivos.

## 23.5 Supabase CLI local

```text
npx supabase --version
```

No ejecutar comandos remotos ni dependientes de Docker.

## 23.6 Smoke de aplicación

Después de build:

```text
npm run start
```

Luego:

- abrir la URL indicada por el proceso;
- verificar `/`;
- registrar PASS/FAIL;
- detener con `Ctrl+C`.

## 23.7 Auditoría Git/documental sin tooling nuevo

Puede utilizarse `git grep` y `git ls-files` para búsquedas read-only, por ejemplo, adaptando los patrones sin imprimir secretos:

```text
git grep -n -E "Supabase local|Docker|supabase start|supabase status|supabase stop" -- docs
git grep -n -E "TASK-006|Fase 2|ADR-0003|DO-T03|Staging|Production" -- docs
git ls-files "docs/tasks/*" "docs/product/*" "docs/architecture/adr/*"
git ls-files "supabase/migrations/*.sql" "supabase/seed.sql" "supabase/schemas/*"
git ls-files ".env*"
```

Las coincidencias deben interpretarse por contexto. Una coincidencia no es automáticamente un error.

Para `.env*.local` o equivalentes sensibles, la comprobación debe limitarse a enumerar nombres/rutas y verificar tracking e ignore, por ejemplo mediante metadata del filesystem, `git ls-files`, `git status --ignored --short` o `git check-ignore` aplicado a cada archivo detectado. No debe utilizarse `cat`, `sed`, `grep` de contenido ni ningún comando equivalente sobre sus valores.

Para búsquedas de posibles secretos, deben preferirse comandos que no reproduzcan valores sensibles. Si una comprobación segura sobre una superficie versionada o pública descubre accidentalmente un valor expuesto, no debe copiarse al informe y debe aplicarse el `BLOCKER` de seguridad definido en las secciones 12.6 y 20.

## 23.8 Estado final

```text
git diff --check
git diff --exit-code
git diff --cached --exit-code
git status --porcelain=v1 --untracked-files=all
```

El resultado final esperado para archivos versionables es limpio.

# 24. Criterios de aceptación

`TASK-007` sólo puede obtener resultado global `PASS` si se cumplen todos los criterios siguientes:

1. la especificación fue revisada, aprobada y canonicalizada antes de ejecutar;
2. la ejecución fue autorizada separadamente;
3. todas las fuentes canónicas obligatorias estuvieron disponibles y fueron leídas;
4. `11`, `CORR-003` y `TASK-006` continúan reconciliados con el baseline de esta especificación;
5. preflight Git correcto;
6. worktree limpio al inicio;
7. `HEAD` inicial registrado;
8. branch/upstream/divergencia registrados;
9. `463c908` existe y su relación con la historia actual queda explicada;
10. cambios posteriores a `463c908` no introducen drift técnico no autorizado;
11. `package.json` válido;
12. scripts exactos `lint`, `typecheck`, `test`, `build`, `verify` preservados;
13. ausencia de `engines`, `packageManager` y `devEngines` preservada, salvo decisión posterior aprobada;
14. `package-lock.json` válido y único lockfile autorizado;
15. `npm` continúa siendo package manager efectivo;
16. Node/npm reales fueron registrados y reconciliados con el baseline sin atribuir restricciones inexistentes a `package.json`;
17. `npm ci` PASS;
18. `npm run lint` PASS;
19. `npm run typecheck` PASS;
20. `npm run test` PASS;
21. `npm run build` PASS;
22. `npm run verify` PASS;
23. `strict: true` efectivo;
24. `noEmit: true` efectivo;
25. smoke `npm run start` PASS;
26. ruta raíz técnica accesible;
27. Next.js/React/Tailwind preservados;
28. ESLint/Vitest preservados;
29. skeleton modular preservado;
30. aliases/boundaries preservados;
31. no existe bounded context funcional adelantado;
32. `.env.example` y configuración preservan `TASK-004`;
33. no existe secreto real detectado en Git o superficie client-side;
34. Supabase CLI `2.114.0` preservada como `devDependency`, salvo decisión posterior aprobada;
35. `supabase/` inicializado y `supabase/config.toml` versionado;
36. estado temporal/sesiones/credenciales Supabase fuera de Git;
37. evidencia disponible confirma exactamente un proyecto Cloud exclusivo de Development, creado/linked manualmente y bajo operación remota manual de Francisco;
38. Codex permanece sin credenciales ni acceso remoto Supabase;
39. Docker no se convirtió nuevamente en requisito;
40. `start/status/stop` no se convirtieron nuevamente en Gate;
41. `db push` no se convirtió en requisito;
42. no existen schema/migrations funcionales de producto;
43. no existe integración funcional de la app con Supabase ni cliente anticipado;
44. no existe Auth/tenancy/RLS/Storage/Realtime funcional;
45. no existe `service-role` de aplicación;
46. no existe Staging;
47. no existe Production;
48. `.github/workflows/ci.yml` existe;
49. CI continúa siendo GitHub Actions;
50. eventos = PR hacia `main` + push a `main`;
51. `pull_request_target` ausente;
52. un único job;
53. runner `ubuntu-24.04`;
54. Node CI `22.23.1`;
55. timeout 20 minutos;
56. no matrix;
57. no concurrency;
58. cache automática deshabilitada y sin cache manual;
59. checkout exacto `actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1` con contexto humano `v7.0.1`;
60. setup-node exacto `actions/setup-node@3d7870f6218881292d183093179901ae8dc2ef85`, snapshot oficial seleccionado por seguridad posterior a `v7.0.0`;
61. `persist-credentials: false`;
62. permisos `contents: read` y ningún permiso de escritura;
63. instalación CI `npm ci`;
64. lint/typecheck/test/build ejecutados como pasos separados;
65. `npm run verify` no duplicado en CI;
66. CI sin secretos del proyecto, PAT, credenciales Supabase o deployment;
67. CI sin Supabase CLI/remoto, Docker, deployment/release, Staging/Production o Fase 2+;
68. evidencia remota `32192116475` / `463c908` confirmada como `completed / success`;
69. auditoría documental completada;
70. no existe drift documental material pendiente;
71. matriz de las doce condiciones canónicas del Gate completada con evidencia y sin requisitos inventados/omitidos;
72. las doce condiciones canónicas resultan evaluables y compatibles con un resultado global `PASS`;
73. `ADR-0003` continúa `BLOCKED BY DO-T03`;
74. `DO-T03` continúa `PARCIALMENTE ABIERTO` y no fue resuelto por esta tarea;
75. Fase 2 continúa `NO INICIADA`;
76. no se modificó ningún archivo versionado;
77. no hubo commit;
78. no hubo push;
79. no se generó ni inició el Paso 9;
80. informe final completo;
81. revisión humana final del informe realizada;
82. worktree limpio al finalizar.

Si falla una validación ejecutable, el resultado no puede ser `PASS`.

Si existe drift que requiera cambio, el resultado no puede ser `PASS` aunque todos los comandos técnicos sean verdes.

Un `PASS` de `TASK-007` no declara formalmente Fase 1 completada; entrega evidencia para la decisión humana posterior del Gate.

# 25. Definition of Done

`TASK-007` puede declararse `DONE` únicamente cuando:

- su especificación fue revisada, aprobada y canonicalizada;
- la ejecución fue autorizada separadamente;
- todas las fuentes canónicas obligatorias estuvieron disponibles y fueron leídas;
- el preflight fue limpio;
- `HEAD`, branch, upstream y divergencia quedaron registrados;
- `463c908` fue reconciliado con la historia actual;
- se ejecutó `npm ci`;
- lint pasó;
- typecheck pasó;
- tests pasaron;
- build pasó;
- verify pasó localmente;
- TypeScript efectivo mantiene `strict` y `noEmit`;
- el smoke real de `npm run start` y `/` pasó;
- arquitectura/skeleton/boundaries no presentan drift material;
- configuración/secretos no presentan drift material ni exposición;
- el baseline Supabase de Development fue validado contra el criterio vigente de `CORR-002/CORR-003`;
- no se exigió Docker ni lifecycle local como Gate;
- no se ejecutó Supabase remoto por Codex;
- la aplicación continúa sin integración funcional con Supabase;
- no existen schema/migrations/Auth/tenancy/RLS/Storage/Realtime funcionales adelantados;
- CI fue auditada contra la configuración material exacta de `TASK-006`;
- la evidencia remota de `TASK-006` fue confirmada;
- documentación fue auditada completamente;
- se completó la matriz de las doce condiciones canónicas del Gate sin añadir ni omitir requisitos;
- no existe drift material pendiente ni corrección necesaria sin tramitar;
- `ADR-0003` continúa `BLOCKED BY DO-T03`;
- `DO-T03` continúa `PARCIALMENTE ABIERTO` y no fue resuelto por esta tarea;
- Fase 2 continúa `NO INICIADA`;
- no se realizó ninguna modificación funcional;
- no se realizó ninguna modificación documental silenciosa;
- no se modificó ningún archivo versionado;
- no hubo commit/push;
- no se generó ni ejecutó el Paso 9;
- el informe final fue revisado humanamente;
- el resultado final fue `PASS`;
- el repositorio quedó limpio al terminar.

Si el resultado es `FAIL`, `BLOCKER` o `REQUIRES CORRECTION`, `TASK-007` NO debe declararse `DONE`.

Si se detecta una corrección necesaria, debe definirse y aprobarse el flujo correctivo separado correspondiente; después deberá reevaluarse el punto afectado antes del cierre de `TASK-007`.

`TASK-007 = DONE` tampoco equivale por sí solo a `Fase 1 = COMPLETADA`: el cierre formal de la fase requiere la decisión humana explícita del Gate usando la evidencia resultante.

# 26. ADR requerido

**Decisión:**

`ADR nuevo NO requerido`

## Justificación

`TASK-007` no selecciona una arquitectura nueva ni modifica una decisión transversal.

Su función es:

- comprobar requisitos ya aprobados;
- detectar drift;
- reunir evidencia;
- evaluar un Gate existente.

`docs/product/10-architecture-decisions-records.md` distingue los ADR de decisiones menores/reversibles y de actividades de revisión. Un ADR se justifica cuando existe una decisión arquitectónica suficientemente determinada, transversal, costosa de revertir o con alternativas materiales que deban conservar contexto histórico.

`TASK-007` no toma una decisión de ese tipo.

Si la revisión detectara que para corregir un hallazgo es necesario cambiar una decisión arquitectónica aceptada o introducir una nueva decisión transversal, `TASK-007` debe detenerse y proponer el proceso separado correspondiente. No debe crear el ADR dentro de esta tarea.

# 27. Resultados posibles

La ejecución debe emitir exactamente uno de los siguientes resultados globales:

## `PASS`

Significa:

- todas las validaciones aplicables del paso 8 pasaron;
- no existe drift material pendiente;
- no existe inconsistencia documental que requiera corrección;
- el Gate pudo auditarse completamente;
- el repositorio permanece limpio.

`PASS` NO significa Fase 1 completada.

## `FAIL`

Significa:

- una o más validaciones ejecutables fallaron;
- la revisión pudo ejecutarse suficientemente para identificar el fallo;
- no se aplicó ningún fix dentro de `TASK-007`.

Ejemplos: lint, typecheck, test, build, verify o smoke de arranque fallan.

## `BLOCKER`

Significa:

- la revisión no puede completarse de forma autoritativa o segura.

Ejemplos:

- falta una fuente canónica obligatoria;
- existe contradicción de autoridad no resuelta;
- falta evidencia esencial;
- worktree no puede aislarse;
- se detecta evidencia de exposición o gestión incorrecta de un secreto que obliga a detener la revisión;
- continuar exigiría credenciales, cambios o decisiones fuera de alcance.

## `REQUIRES CORRECTION`

Significa:

- la revisión pudo identificar un drift concreto que requiere una tarea/corrección separada antes de cerrar el paso 8.

Ejemplos:

- documentación vigente contradictoria;
- ruta canónica rota;
- workflow CI con drift respecto de `TASK-006`;
- configuración/versiones distintas sin aprobación;
- artefacto técnico requerido ausente o inconsistente;
- Gate canónico no refleja `CORR-002/CORR-003`.

## Precedencia cuando hay varios hallazgos

El informe debe registrar todos los hallazgos, pero el resultado global sigue estas reglas:

1. `BLOCKER` si la revisión no puede completarse autoritativamente o con seguridad;
2. en ausencia de blocker, `REQUIRES CORRECTION` si existe drift material que requiere cambio separado;
3. en ausencia de lo anterior, `FAIL` si una validación ejecutable falla;
4. `PASS` únicamente si todo lo aplicable pasa y no existe corrección pendiente.

# 28. Reporte esperado

El informe de ejecución de `TASK-007` debe contener, como mínimo:

1. ID y título;
2. fecha/hora de ejecución;
3. ejecutor(es) y separación Codex/humano;
4. fuentes canónicas realmente leídas;
5. cualquier fuente faltante;
6. `HEAD` inicial;
7. branch;
8. upstream;
9. divergencia;
10. worktree inicial;
11. relación de `463c908` con el `HEAD` actual;
12. cambios posteriores a `463c908` relevantes;
13. Node real;
14. npm real;
15. package manager y lockfiles;
16. presencia/ausencia de `engines`, `packageManager`, `devEngines`;
17. scripts exactos encontrados en `package.json`;
18. versiones efectivas de Next.js, React, TypeScript, Tailwind, ESLint, Vitest y Supabase CLI;
19. `strict`/`noEmit` efectivos;
20. resultado de `npm ci`;
21. resultado de lint;
22. resultado de typecheck;
23. resultado de test;
24. resultado de build;
25. resultado de verify;
26. resultado del smoke `npm run start` y `/`;
27. resultado de revisión de skeleton/aliases/boundaries;
28. resultado de revisión de entorno/secretos;
29. resultado del baseline Supabase de Development, cubriendo los criterios de `CORR-002/CORR-003`;
30. confirmación de `supabase/`, `supabase/config.toml` y estado temporal fuera de Git;
31. confirmación de ausencia de integración funcional Supabase/schema/migrations/Auth/tenancy/RLS/Storage/Realtime/service-role/Staging/Production;
32. resultado de revisión de `.github/workflows/ci.yml`;
33. provider, eventos, runner, Node CI, job count, timeout, matrix, concurrency y cache;
34. referencias exactas/SHA de checkout y setup-node observadas;
35. permisos y `persist-credentials` observados;
36. orden y comandos de instalación/lint/typecheck/test/build observados;
37. confirmación de que `verify` no se duplica en CI;
38. resultado de la revisión de secretos/credenciales: tracking e ignore de archivos locales sensibles, ausencia de secretos en superficies versionadas/públicas/CI y cualquier evidencia de exposición o gestión incorrecta; no registrar valores sensibles;
39. confirmación de ausencia de Supabase/Docker/deployment/release/Fase 2+ en CI;
40. evidencia remota de `TASK-006`: workflow `CI`, run `32192116475`, commit `463c908`, `completed / success`;
41. hallazgos documentales con archivo/ubicación/clasificación;
42. distinción explícita entre menciones históricas legítimas de Supabase local y criterios operativos obsoletos;
43. matriz completa de las doce condiciones canónicas del Gate de salida de Fase 1;
44. estado observado de `DO-T03 = PARCIALMENTE ABIERTO`;
45. estado observado `ADR-0003 = BLOCKED BY DO-T03`;
46. listado de archivos versionados modificados — esperado: ninguno;
47. estado Git final;
48. resultado global: `PASS`, `FAIL`, `BLOCKER` o `REQUIRES CORRECTION`;
49. correcciones separadas recomendadas, sólo si corresponden, sin redactarlas ni ejecutarlas;
50. declaración explícita de que `TASK-007` no formalizó el cierre de Fase 1;
51. declaración explícita de que Fase 2 no fue iniciada;
52. declaración explícita de que no se generó ni inició el Paso 9.

El informe no debe contener secretos, tokens, passwords, claves Supabase, PAT ni valores sensibles de `.env`.

# 29. Gate posterior

Si una futura ejecución de `TASK-007` termina con `PASS` y la revisión humana acepta el informe:

- NO generar automáticamente `TASK-008` ni otra tarea;
- NO declarar automáticamente Fase 1 completada desde `TASK-007`;
- NO iniciar Fase 2;
- NO resolver `DO-T03`;
- NO redactar `ADR-0003`;
- NO iniciar ni diseñar el Paso 9 dentro de `TASK-007`.

La secuencia canónica posterior exige primero una decisión humana separada sobre el Gate de salida de Fase 1, utilizando la evidencia del paso 8 y las doce condiciones de `11`.

Sólo si esa decisión humana determina formalmente que Fase 1 está completada podrá autorizarse, en otro paso y mediante instrucción separada:

`Paso 9 — Preparar la frontera de Fase 2 sin implementarla`

Ese paso, cuando llegue a ser autorizado, deberá:

- revisar el estado de `DO-T03`;
- realizar el proceso documental necesario para desbloquear `ADR-0003`;
- redactar/revisar/aprobar `ADR-0003` en un paso separado;
- evaluar el Gate de entrada de Fase 2.

`TASK-007` reconoce esa secuencia y se detiene antes de ella.

---

**Estado de esta especificación:** `APPROVED FOR EXECUTION`

**Documento canónico:** sí.

**Ruta canónica:** `docs/tasks/TASK-007-phase-1-smoke-docs-review.md`

**Canonical commit de referencia:** `5bde25d96fa73537ebc912115f53c55be8366db9`

**Esta especificación inicia o autoriza por sí sola una ejecución concreta:** no.

**Cada ejecución concreta requiere autorización humana separada:** sí.

**Codex ejecutado por la mera aprobación/canonicalización de esta especificación:** no.

**Repositorio modificado por la mera aprobación/canonicalización de esta especificación:** no.

**Fase 1 declarada completada:** no.

**Fase 2 iniciada:** no.
