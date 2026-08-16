# 1. ID

`TASK-002`

# 2. Título

`Tooling y comandos base de calidad`

# 3. Fase

`Fase 1 — Setup, repositorio, CI y Supabase local`

Correspondencia dentro del orden aprobado de Fase 1:

`Paso 3 — Tooling y comandos de calidad`

Esta tarea cubre exclusivamente el baseline local y reproducible de verificación posterior al bootstrap de `TASK-001`.

No incluye el `Paso 4 — Skeleton modular`, Supabase local, configuración de CI ni capacidades de fases posteriores.

# 4. Estado

`APPROVED FOR IMPLEMENTATION`

Ruta propuesta futura:

`docs/tasks/TASK-002-tooling-base.md`

Este documento queda aprobado para implementación. Su incorporación canónica futura corresponde a la ruta indicada.

# 5. Objetivo

Establecer el baseline mínimo, explícito y reproducible de tooling y comandos locales de calidad del repositorio después del bootstrap de `TASK-001`, de modo que cualquier cambio posterior pueda comprobar como mínimo:

- lint;
- typecheck;
- tests base;
- build;
- verificación local básica.

El resultado debe permitir ejecutar checks homogéneos mediante scripts de `package.json`, manteniendo el bootstrap existente y sin avanzar hacia arquitectura modular física, Supabase, CI o funcionalidad de producto.

`TASK-002` no define una plataforma integral de QA. Su propósito es únicamente crear la base técnica de verificación que las tareas posteriores de Fase 1 podrán reutilizar.

# 6. Contexto normativo

Esta tarea se encuentra restringida por las siguientes fuentes obligatorias:

- `docs/product/00-master-product-brief.md`: establece el stack base del proyecto y el método de trabajo mediante tareas pequeñas, verificables y revisadas antes de avanzar.
- `docs/product/01-product-definition.md`: mantiene TypeScript estricto, una arquitectura simple y modular dentro de un único proyecto Next.js y la separación de capacidades funcionales por fases.
- `docs/product/10-architecture-decisions-records.md`: distingue decisiones técnicas menores y reversibles de decisiones arquitectónicas que justifican ADR; prohíbe resolver decisiones `DO-*` o `*-OPEN-*` por inferencia.
- `docs/product/11-phase-1-scope-entry-gate.md`: define Fase 1 como `Setup, repositorio, CI y Supabase local` y establece para el `Paso 3 — Tooling y comandos de calidad` el baseline de lint, typecheck, tests, build y scripts de desarrollo, sin tooling específico de módulos posteriores.
- `docs/tasks/TASK-001-bootstrap-nextjs.md`: define el bootstrap previo y dejó expresamente fuera el test runner adicional, la configuración específica de tests, linting ampliado, CI, Supabase y skeleton modular, reservando el tooling de calidad para el Paso 3.
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`: mantiene un único proyecto/aplicación Next.js y un monolito modular, pero no prescribe una estructura física final ni exige tooling arquitectónico específico en esta tarea.

Estado operativo consumido como precondición de esta especificación:

- Fase 0: `COMPLETADA`;
- Gate de entrada a Fase 1: `APROBADO`;
- `TASK-001`: implementada, revisada y cerrada satisfactoriamente;
- bootstrap Next.js integrado;
- App Router operativo;
- React operativo;
- TypeScript strict operativo;
- Tailwind CSS base operativo;
- build exitoso;
- package manager: `npm`;
- Fase 1 en progreso;
- Fase 2 no iniciada.

Estado técnico esperado heredado de `TASK-001`:

- Next.js 16.x;
- React 19.x;
- TypeScript strict;
- Tailwind CSS 4.x;
- App Router;
- página técnica mínima;
- ningún test runner adicional;
- ninguna CI;
- ningún Supabase.

Durante la implementación futura, el repositorio real y sus archivos instalados son la fuente técnica de verdad. Si las versiones reales difieren, Codex debe inspeccionarlas antes de elegir versiones o configuración de tooling.

No se detecta en la baseline documental una contradicción material que bloquee la definición de `TASK-002`.

# 7. Precondiciones

Antes de realizar cualquier cambio de implementación, Codex debe:

1. leer íntegramente:
   - `docs/product/00-master-product-brief.md`;
   - `docs/product/01-product-definition.md`;
   - `docs/product/10-architecture-decisions-records.md`;
   - `docs/product/11-phase-1-scope-entry-gate.md`;
   - `docs/tasks/TASK-001-bootstrap-nextjs.md`;
   - `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
2. inspeccionar primero el repositorio real;
3. repetir el preflight operativo inmediatamente antes del primer cambio;
4. verificar:
   - repositorio Git válido;
   - branch `main`, salvo que el estado real aprobado indique expresamente otra base;
   - sincronización esperada con `origin/main`;
   - worktree limpio;
   - documentación normativa accesible;
   - `TASK-001` efectivamente integrada y cerrada;
   - ausencia de cambios pendientes que puedan mezclarse con `TASK-002`;
5. registrar el `HEAD` inicial únicamente como evidencia de preflight, sin crear commits;
6. inspeccionar como mínimo:
   - `package.json`;
   - `package-lock.json` o el lockfile real;
   - versiones reales de Next.js, React, TypeScript y Node;
   - `tsconfig.json`;
   - configuración existente de linting, si hubiera alguna;
   - scripts existentes;
   - estructura actual de tests, si hubiera alguna;
   - archivos del bootstrap de `TASK-001`;
7. confirmar que `strict: true` continúa efectivo;
8. confirmar que no existe ya una solución de tooling materialmente distinta que convierta esta tarea en una migración no prevista;
9. preservar `/docs` sin modificaciones;
10. no asumir que el estado descrito en esta especificación sustituye la inspección del repositorio.

Debe reportarse `BLOCKER` y detener la implementación si:

- el worktree no está limpio y no puede aislarse `TASK-002`;
- `TASK-001` no está realmente integrada/cerrada;
- el repositorio real contradice materialmente el stack declarado;
- ya existe un baseline de tooling incompatible cuya sustitución requiera una decisión arquitectónica material;
- completar el tooling exige alterar fases;
- completar el tooling exige resolver un `DO-*` o `*-OPEN-*`;
- completar el tooling exige introducir CI, Supabase, schema, migrations, RLS, Auth o capacidades de Fase 2+;
- completar el tooling exige una decisión transversal, costosa de revertir o no cubierta por la baseline.

Las elecciones locales y reversibles necesarias para configurar lint, typecheck o tests base no constituyen `BLOCKER` por sí mismas y no requieren ADR.

# 8. Dentro de alcance

`TASK-002` puede realizar exclusivamente lo necesario para establecer un baseline local reproducible de calidad:

- añadir o ajustar scripts de `package.json` para:
  - lint;
  - typecheck;
  - tests base;
  - build;
  - verificación local básica;
- conservar los scripts de desarrollo y arranque existentes de `TASK-001`;
- configurar linting mínimo para Next.js, React y TypeScript;
- configurar un test runner unitario/base mínimo;
- añadir un único smoke test técnico mínimo, o el mínimo equivalente necesario para demostrar que el runner ejecuta y finaliza correctamente;
- añadir únicamente las dependencias de desarrollo estrictamente necesarias para linting y tests base;
- utilizar el compilador TypeScript ya adoptado para el typecheck;
- mantener el build de Next.js existente como check explícito;
- añadir una configuración mínima del test runner sólo si realmente es necesaria;
- añadir documentación técnica mínima fuera de `/docs` únicamente si es necesaria para explicar cómo ejecutar los comandos;
- realizar correcciones técnicas mínimas sobre archivos del bootstrap únicamente si un check de esta tarea detecta un problema real y la corrección no cambia funcionalidad ni alcance de producto;
- mantener instalación reproducible mediante el `package.json` y lockfile existentes.

El baseline debe exponer conceptualmente comandos equivalentes a:

- `npm run lint`;
- `npm run typecheck`;
- `npm run test`;
- `npm run build`;
- `npm run verify` o un único comando equivalente de verificación local que ejecute los checks anteriores en secuencia.

Los nombres anteriores forman parte de la propuesta de esta tarea. Codex debe validar su compatibilidad con el estado real antes de modificar archivos.

# 9. Fuera de alcance

Queda explícitamente fuera de `TASK-002`:

- skeleton modular;
- bounded contexts;
- arquitectura física definitiva;
- creación de directorios de dominio “por si acaso”;
- reglas avanzadas de dependencias entre módulos;
- aliases arquitectónicos nuevos;
- microservicios;
- Supabase;
- Supabase CLI;
- Supabase local;
- Supabase Auth;
- Supabase Storage;
- Supabase Realtime;
- schema;
- migrations;
- SQL;
- tablas;
- columnas;
- PK/FK;
- índices;
- constraints;
- funciones PostgreSQL;
- triggers;
- RLS;
- policies;
- autenticación;
- tenancy;
- roles;
- clientes;
- ubicaciones;
- tipos de equipos;
- equipos;
- formularios;
- `FormTemplate`;
- `FormVersion`;
- Maintenance;
- `MaintenanceRecord`;
- `MaintenanceRevision`;
- Evidence;
- Offline;
- Dexie;
- IndexedDB;
- Service Worker;
- outbox;
- sync;
- Reporting;
- PDF;
- DOCX;
- OpenAI;
- IA;
- créditos IA;
- Mercado Pago;
- Subscription;
- pagos;
- notificaciones;
- Dashboard;
- CI;
- GitHub Actions;
- pipelines;
- deploy;
- release;
- Vercel;
- observabilidad;
- performance;
- E2E;
- browser automation;
- Playwright;
- Cypress;
- visual regression;
- snapshot testing como estrategia de producto;
- coverage thresholds avanzados;
- plataforma de cobertura;
- mutation testing;
- fixtures de producto;
- mocks de servicios futuros;
- tests de dominio inexistente;
- tests de Supabase;
- tests RLS;
- reglas corporativas extensas de estilo;
- Prettier;
- formatter alternativo;
- hooks Git;
- pre-commit hooks;
- Husky;
- lint-staged;
- commitlint;
- monorepo tooling;
- dependencias destinadas a tareas futuras;
- secrets;
- `.env` con valores reales;
- cualquier funcionalidad de Fase 2+;
- creación o modificación de ADR;
- resolución de cualquier `DO-*` o `*-OPEN-*`;
- commits;
- push;
- generación de `TASK-003`.

No instalar herramientas futuras “por si acaso”.

# 10. Tooling propuesto

El tooling propuesto para `TASK-002` es deliberadamente mínimo:

- **Lint:** ESLint ejecutado mediante CLI. No se utilizará `next lint`. Se utilizará la configuración oficial de Next.js compatible con la versión real instalada: para Next.js/React, `eslint-config-next/core-web-vitals` o la configuración oficial equivalente vigente; y para reglas específicas de TypeScript, `eslint-config-next/typescript` o la configuración oficial equivalente vigente. Codex debe validar la forma exacta de composición/importación contra la versión real instalada antes de escribir o modificar `eslint.config.*`, sin fijar versiones concretas de ESLint o `eslint-config-next`, sin añadir reglas arbitrarias de estilo, sin añadir Prettier y sin duplicar plugins, parsers o configuraciones de forma que generen conflictos.
- **Typecheck:** compilador TypeScript existente mediante un script explícito equivalente a `tsc --noEmit`.
- **Tests base:** Vitest como test runner unitario/base, ejecutado en modo no interactivo para el script reproducible de verificación.
- **Smoke test:** un test técnico mínimo sin dominio, sin navegador, sin servicios externos y sin fixtures de producto, suficiente para demostrar que Vitest descubre, ejecuta y reporta al menos un test exitoso.
- **Build:** conservar el build de producción de Next.js ya existente y exponerlo mediante el script `build`.
- **Verificación local básica:** un script agregador equivalente a `verify` que ejecute secuencialmente lint, typecheck, tests y build y falle si cualquiera de los checks falla.
- **Package manager:** conservar `npm` y el lockfile existente.
- **Formatter:** no incorporar Prettier ni otro formatter en `TASK-002`.

Para Next.js 16.x, el lint propuesto debe usar ESLint CLI directamente y no depender de `next lint`.

La configuración debe ser la mínima necesaria para detectar problemas relevantes del stack actual. La forma exacta de las configuraciones oficiales debe validarse contra la versión real instalada antes de escribir `eslint.config.*`. No debe introducir una política extensa de estilo, reglas arbitrarias, Prettier ni duplicaciones conflictivas de plugins, parsers o configuraciones.

El smoke test debe priorizar un entorno Node/puro de TypeScript para no introducir `jsdom`, React Testing Library o browser tooling cuando no son necesarios para demostrar el funcionamiento del runner.

No debe añadirse configuración de Vitest si el caso mínimo puede funcionar correctamente sin ella. Si el estado real exige una configuración mínima, debe limitarse a lo estrictamente necesario.

# 11. Decisiones técnicas menores

Se consideran decisiones técnicas menores, locales y reversibles permitidas dentro de `TASK-002`:

- seleccionar versiones concretas de ESLint, `eslint-config-next` y Vitest compatibles con las versiones reales del repositorio;
- utilizar ESLint CLI como mecanismo de linting para Next.js 16.x;
- utilizar una configuración ESLint plana o el formato oficialmente compatible con la versión real instalada;
- definir `lint` como un script equivalente a `eslint .`, sujeto a validación contra la versión real y exclusiones técnicas necesarias;
- definir `typecheck` como un script equivalente a `tsc --noEmit`;
- definir `test` como un script no interactivo equivalente a `vitest run`;
- definir `verify` como composición secuencial de los checks ya existentes;
- ubicar un smoke test técnico en una carpeta de tests neutral, sin convertir esa ubicación en una taxonomía definitiva para futuras suites;
- omitir `jsdom` y librerías de testing de componentes mientras el smoke test no las necesite;
- omitir Prettier porque no es necesario para satisfacer el objetivo normativo;
- no añadir un archivo de configuración si la herramienta funciona correctamente con configuración mínima embebida o autodetectada;
- conservar las versiones y convenciones ya válidas del repositorio cuando no exista razón técnica para sustituirlas.

Estas decisiones no requieren ADR porque no alteran fronteras de dominio, seguridad, datos, offline, integraciones o arquitectura global y son reemplazables posteriormente.

Si una elección aparentemente menor adquiere impacto transversal material o exige una decisión costosa de revertir, debe dejar de tratarse como decisión menor y reportarse `BLOCKER`.

# 12. Archivos/categorías de archivos esperados

La futura implementación puede crear o modificar únicamente categorías equivalentes a las siguientes:

- `package.json`;
- `package-lock.json`, únicamente como consecuencia reproducible de dependencias realmente añadidas o actualizadas para esta tarea;
- `eslint.config.*` o archivo equivalente compatible con la versión real de ESLint/Next.js, si no existe ya una configuración válida;
- `vitest.config.*`, únicamente si el runner mínimo lo requiere;
- un archivo de smoke test técnico, por ejemplo bajo una ubicación neutral equivalente a `tests/`;
- documentación técnica no normativa existente, como `README.md`, sólo si es necesario documentar los comandos;
- archivos del bootstrap de `TASK-001` únicamente cuando una corrección técnica mínima sea imprescindible para que los checks legítimos pasen y sin cambio funcional.

No se espera modificar `tsconfig.json` salvo que Codex demuestre que existe una necesidad técnica mínima compatible con la baseline. En ningún caso puede relajarse `strict: true`.

No se esperan y no deben crearse:

- archivos bajo `.github/workflows/`;
- `supabase/`;
- migrations;
- SQL;
- schema de producto;
- archivos RLS;
- `.env` con secretos;
- directorios de bounded contexts;
- archivos de Fase 2+.

`/docs` debe permanecer intacto durante la implementación.

# 13. Restricciones de implementación

La implementación futura debe respetar todas las restricciones siguientes:

- inspeccionar antes de modificar;
- ejecutar preflight antes del primer cambio;
- trabajar exclusivamente sobre `TASK-002`;
- preservar íntegramente el bootstrap de `TASK-001`;
- preservar App Router;
- preservar React;
- preservar Tailwind CSS base;
- preservar TypeScript strict;
- no rebajar errores de TypeScript mediante configuración más permisiva;
- no introducir `any` deliberados para hacer pasar checks;
- no desactivar reglas relevantes únicamente para obtener un resultado verde;
- no convertir warnings o errores reales en exclusiones globales arbitrarias;
- no sustituir la funcionalidad actual por boilerplate nuevo;
- no ejecutar scaffolding que regenere la aplicación;
- no cambiar de package manager;
- no crear un segundo lockfile;
- no instalar dependencias futuras;
- no añadir formatter;
- no añadir E2E;
- no añadir browser automation;
- no añadir coverage thresholds;
- no añadir CI;
- no añadir Supabase;
- no modificar `/docs`;
- no crear ni modificar ADR;
- no resolver `DO-*` ni `*-OPEN-*`;
- no ejecutar `git init`;
- no reescribir historia Git;
- no hacer commit;
- no hacer push;
- no generar `TASK-003`.

Si un check descubre un defecto previo de `TASK-001`, Codex debe distinguir:

- **corrección técnica mínima permitida:** cambio estrictamente necesario, sin nueva funcionalidad y claramente atribuible al baseline técnico;
- **cambio fuera de alcance:** refactor, rediseño, feature o modificación material que debe reportarse como `BLOCKER` o quedar para otra tarea.

No deben relajarse los checks para ocultar un problema real.

# 14. Seguridad

Impacto de seguridad de `TASK-002`:

- no introduce nuevas fronteras de seguridad del producto;
- no introduce autenticación;
- no introduce autorización;
- no introduce tenancy;
- no introduce persistencia de producto;
- no introduce integraciones externas;
- no introduce secretos;
- no introduce credenciales.

Está prohibido:

- crear `.env` con valores reales;
- añadir Supabase keys;
- añadir OpenAI keys;
- añadir credenciales de Mercado Pago;
- incluir tokens o secretos en configuraciones de tooling;
- registrar secretos en documentación o tests.

Las dependencias añadidas deben limitarse al tooling necesario y quedar registradas en el informe de implementación.

La configuración de lint/tests no debe requerir acceso a red ni servicios externos para ejecutar el baseline normal.

# 15. Impacto de datos / migrations

`NO APLICA TODAVÍA — TASK-002 no introduce persistencia de producto`

No se crean ni modifican:

- schema de producto;
- tablas;
- columnas;
- relaciones;
- índices;
- constraints;
- migrations;
- seeds;
- SQL;
- datos de tenant;
- almacenamiento local de dominio.

No debe existir ninguna migration nueva como resultado de `TASK-002`.

# 16. Impacto RLS

`NO APLICA TODAVÍA — no existe schema de producto`

`TASK-002` no crea, diseña ni modifica:

- policies RLS;
- helpers RLS;
- funciones de autorización PostgreSQL;
- tenant resolution;
- claims;
- roles físicos;
- permisos de datos.

La ausencia de RLS en esta tarea no modifica su obligatoriedad futura. Simplemente no existe todavía un schema de producto sobre el cual aplicarla.

# 17. Criterios de aceptación

`TASK-002` sólo puede considerarse implementada correctamente si se cumplen todos los criterios siguientes:

1. Codex leyó las fuentes obligatorias antes de modificar el repositorio.
2. El repositorio real fue inspeccionado antes de seleccionar versiones o configuración.
3. Se repitió el preflight Git inmediatamente antes del primer cambio.
4. El worktree estaba limpio al comenzar.
5. El repositorio Git existente fue preservado.
6. No se ejecutó `git init`.
7. No se reescribió historia Git.
8. `/docs` permaneció intacto.
9. `TASK-001` y su bootstrap permanecieron funcionalmente preservados.
10. App Router continúa operativo.
11. React continúa operativo.
12. Tailwind CSS base continúa operativo.
13. TypeScript continúa con `strict: true` efectivo.
14. No se añadió deliberadamente `any` para hacer pasar checks.
15. Existe un script explícito `lint` o equivalente aprobado.
16. El lint cubre Next.js/React y TypeScript mediante ESLint CLI compatible con la versión real, utilizando las configuraciones oficiales correspondientes de Next.js para `core-web-vitals` y TypeScript —o sus equivalentes oficiales vigentes—, sin reglas arbitrarias de estilo.
17. El lint finaliza exitosamente.
18. Existe un script explícito `typecheck` o equivalente aprobado.
19. El typecheck comprueba TypeScript sin emitir archivos.
20. El typecheck finaliza exitosamente.
21. Existe un test runner base configurado.
22. El test runner elegido es Vitest salvo `BLOCKER` técnico documentado antes de sustituirlo.
23. Existe al menos un smoke test técnico mínimo y no funcional.
24. Los tests base finalizan exitosamente en modo reproducible/no interactivo.
25. No se añadieron tests de dominio inexistente.
26. No se añadieron tests de Supabase ni RLS.
27. No se añadió E2E ni browser automation.
28. El script `build` continúa ejecutando el build de producción de Next.js.
29. El build finaliza exitosamente.
30. Existe un comando agregador `verify` o equivalente que ejecuta lint, typecheck, tests y build en secuencia.
31. El comando agregador finaliza exitosamente.
32. La instalación desde `package.json` y lockfile permanece reproducible.
33. Existe un único package manager efectivo: `npm`.
34. Existe un único lockfile coherente.
35. Sólo se añadieron dependencias estrictamente necesarias para el tooling de esta tarea.
36. Las dependencias añadidas quedaron registradas en el informe.
37. Las decisiones técnicas menores quedaron registradas en el informe.
38. No se añadió Prettier ni otro formatter.
39. No se añadió skeleton modular.
40. No se configuró CI.
41. No se creó GitHub Actions.
42. No se configuró Supabase.
43. No se creó schema.
44. No se crearon migrations.
45. No se creó SQL.
46. No se creó RLS.
47. No se implementó Auth.
48. No se implementó tenancy.
49. No se implementó ningún bounded context.
50. No se implementó ninguna capacidad de Fase 2+.
51. No se añadieron secrets.
52. No se creó ni modificó ningún ADR.
53. No se resolvió ningún `DO-*` ni `*-OPEN-*`.
54. No se realizó commit.
55. No se realizó push.
56. No se generó `TASK-003`.
57. El resultado final de Codex fue informado como `PASS`, `FAIL` o `BLOCKER`.

# 18. Pruebas/verificaciones obligatorias

Durante la futura implementación, Codex debe ejecutar y registrar como mínimo:

- versión de Node utilizada;
- versión de npm utilizada;
- versiones reales de Next.js, React y TypeScript detectadas;
- `git status` antes de cambios;
- identificación del `HEAD` inicial;
- instalación reproducible mediante el mecanismo correspondiente al lockfile, preferentemente `npm ci` cuando el estado real lo permita;
- `npm run lint`;
- `npm run typecheck`;
- `npm run test`;
- `npm run build`;
- `npm run verify` o comando agregador equivalente;
- comprobación explícita de que `strict: true` permanece efectivo;
- comprobación explícita de que el smoke test fue descubierto y ejecutado;
- comprobación de que no se generaron archivos emitidos por el typecheck;
- comprobación de que no existen archivos nuevos de CI;
- comprobación de que no existe configuración nueva de Supabase;
- comprobación de que no existen migrations, SQL o RLS nuevas;
- comprobación de que no existen secrets añadidos;
- `git diff --check` o verificación equivalente de integridad básica del diff;
- `git status` final;
- listado final de archivos creados/modificados;
- listado final de dependencias añadidas;
- listado final de decisiones técnicas menores tomadas.

Si cualquiera de los checks obligatorios falla, Codex no debe declarar `PASS`.

La corrección de un fallo sólo puede realizarse si permanece dentro del alcance explícito de `TASK-002`. De lo contrario debe informarse `BLOCKER`.

# 19. Definition of Done

La implementación futura de `TASK-002` podrá proponerse como `DONE` únicamente cuando:

- todos los criterios de aceptación estén cumplidos;
- todas las verificaciones obligatorias hayan sido ejecutadas y registradas;
- lint pase;
- typecheck pase;
- tests base pasen;
- build pase;
- la verificación agregada pase;
- TypeScript strict permanezca intacto;
- el bootstrap de `TASK-001` permanezca intacto funcionalmente;
- `/docs` permanezca intacto;
- no exista scope creep hacia skeleton modular, CI, Supabase o Fase 2+;
- no existan secrets;
- no se haya creado ADR;
- no se haya resuelto ningún `DO-*` o `*-OPEN-*`;
- el diff haya sido revisado desde arquitectura, seguridad y regresiones;
- el informe de Codex sea completo;
- una revisión humana posterior acepte expresamente el resultado.

El estado actual de esta especificación permanece:

`APPROVED FOR IMPLEMENTATION`

La aprobación documental de esta tarea no implica que haya sido ejecutada.

# 20. Instrucciones para Codex

Cuando `TASK-002` sea formalmente aprobada para implementación, Codex deberá seguir estas instrucciones:

1. leer las seis fuentes obligatorias completas;
2. inspeccionar el repositorio antes de decidir herramientas, versiones o archivos;
3. repetir el preflight Git inmediatamente antes del primer cambio;
4. confirmar worktree limpio y registrar `HEAD`;
5. trabajar exclusivamente sobre `TASK-002`;
6. preservar el bootstrap y comportamiento técnico de `TASK-001`;
7. preservar `/docs` sin cambios;
8. preservar `strict: true`;
9. usar el estado real del repositorio como fuente técnica para versiones instaladas;
10. seleccionar sólo versiones compatibles y activamente mantenidas de las herramientas propuestas;
11. configurar únicamente:
    - lint;
    - typecheck;
    - tests base;
    - build;
    - verificación local básica;
12. no instalar tooling de fases futuras;
13. no añadir Prettier;
14. no crear skeleton modular;
15. no configurar CI;
16. no crear `.github/workflows/*`;
17. no configurar Supabase;
18. no crear schema;
19. no crear migrations;
20. no crear SQL;
21. no crear RLS;
22. no implementar Auth;
23. no implementar tenancy;
24. no implementar Fase 2+;
25. no resolver silenciosamente ningún `DO-*` ni `*-OPEN-*`;
26. no crear ADR por decisiones técnicas menores;
27. reportar `BLOCKER` si aparece una decisión arquitectónica material o un requisito fuera de alcance imprescindible;
28. ejecutar:
    - lint;
    - typecheck;
    - tests;
    - build;
    - verificación agregada;
29. registrar todos los comandos ejecutados y sus resultados relevantes;
30. listar todos los archivos creados;
31. listar todos los archivos modificados;
32. listar todas las dependencias añadidas y su propósito;
33. registrar todas las decisiones técnicas menores tomadas;
34. informar cualquier corrección técnica realizada sobre archivos heredados de `TASK-001`;
35. informar el resultado final usando exactamente uno de:
    - `PASS`;
    - `FAIL`;
    - `BLOCKER`;
36. no hacer commit;
37. no hacer push;
38. no generar `TASK-003`.

Codex no debe interpretar esta tarea como autorización para mejorar el proyecto más allá del baseline solicitado.

# 21. Resultado esperado

Al finalizar correctamente la futura implementación de `TASK-002`, el repositorio debe conservar todo el resultado válido de `TASK-001` y añadir exclusivamente un baseline local de calidad reproducible.

Estado técnico esperado:

- Next.js 16.x real o la versión realmente integrada por `TASK-001`, sin migración no solicitada;
- React 19.x real o la versión realmente integrada por `TASK-001`;
- App Router operativo;
- TypeScript strict operativo;
- Tailwind CSS base operativo;
- npm preservado;
- instalación reproducible;
- ESLint configurado de forma mínima y compatible;
- lint exitoso;
- script explícito de typecheck;
- typecheck sin emit exitoso;
- Vitest operativo;
- smoke test técnico mínimo exitoso;
- build de Next.js exitoso;
- comando de verificación local agregada exitoso.

Estado funcional esperado:

`NINGUNA FUNCIONALIDAD DE PRODUCTO NUEVA IMPLEMENTADA`

Estado de arquitectura esperado:

- sin skeleton modular nuevo;
- sin bounded contexts físicos nuevos;
- `ADR-0001` preservado sin reinterpretación;
- sin microservicios;
- sin ADR nuevo.

Estado de infraestructura posterior esperado:

- CI: no configurada;
- Supabase local: no configurado;
- schema: inexistente;
- migrations: inexistentes;
- SQL: inexistente;
- RLS: inexistente;
- Auth: no implementado;
- tenancy: no implementada;
- Fase 2+: no iniciada.

# 22. Gate posterior

Después de la futura implementación de `TASK-002` debe realizarse una revisión explícita antes de autorizar cualquier tarea siguiente.

El Gate posterior debe verificar como mínimo:

- cumplimiento íntegro de los criterios de aceptación;
- lint exitoso;
- typecheck exitoso;
- tests base exitosos;
- build exitoso;
- verificación agregada exitosa;
- instalación reproducible;
- TypeScript strict preservado;
- bootstrap de `TASK-001` preservado;
- App Router preservado;
- Tailwind base preservado;
- dependencias añadidas justificadas;
- decisiones técnicas menores registradas;
- ausencia de reglas de estilo arbitrarias;
- ausencia de formatter;
- ausencia de E2E;
- ausencia de coverage thresholds avanzados;
- `/docs` intacto;
- historia Git intacta;
- ausencia de commit/push;
- ausencia de secrets;
- ausencia de skeleton modular;
- ausencia de CI;
- ausencia de Supabase;
- ausencia de schema;
- ausencia de migrations;
- ausencia de SQL;
- ausencia de RLS;
- ausencia de Auth;
- ausencia de tenancy;
- ausencia de Fase 2+;
- ningún ADR nuevo;
- ningún `DO-*` o `*-OPEN-*` resuelto;
- informe de Codex completo con `PASS`, `FAIL` o `BLOCKER`.

Sólo si este Gate se supera podrá evaluarse el siguiente trabajo de Fase 1 conforme al orden aprobado.

El siguiente paso normativo de Fase 1 después del tooling es `Paso 4 — Skeleton modular`, pero este Gate no define, autoriza ni genera ninguna tarea posterior.

Estado de `TASK-002` en este documento:

`APPROVED FOR IMPLEMENTATION`

Estado operativo actual:

- `TASK-002` implementada: no;
- Codex ejecutado: no;
- repositorio modificado por este paso: no;
- commit realizado: no;
- push realizado: no;
- `TASK-003` generada: no;
- Fase 1 completada: no;
- Fase 2 iniciada: no.
