# 1. ID

`TASK-001`

# 2. Título

`Bootstrap mínimo de la aplicación Next.js`

# 3. Fase

`Fase 1 — Setup, repositorio, CI y Supabase local`

Correspondencia dentro del orden aprobado de Fase 1:

`Paso 2 — Bootstrap de aplicación`

Esta tarea cubre exclusivamente el bootstrap técnico mínimo. El tooling de calidad ampliado, el skeleton modular, la configuración de entorno, Supabase local y CI pertenecen a pasos posteriores y no forman parte de `TASK-001`.

# 4. Estado

`APPROVED FOR IMPLEMENTATION`

La tarea está formalmente aprobada para implementación, pero todavía no fue ejecutada.

# 5. Objetivo

Integrar de forma segura en el repositorio existente una aplicación base Next.js ejecutable que establezca exclusivamente el bootstrap técnico mínimo aprobado para Fase 1.

El resultado debe proporcionar:

- Next.js;
- App Router;
- React;
- TypeScript;
- TypeScript strict efectivo;
- Tailwind CSS base;
- package manifest;
- un único lockfile coherente con el package manager utilizado;
- configuración mínima necesaria para el bootstrap;
- una página y shell exclusivamente técnicas;
- capacidad de instalar dependencias;
- capacidad de arrancar la aplicación;
- build básico exitoso.

`TASK-001` no debe materializar todavía la arquitectura modular física definitiva ni implementar capacidades funcionales del SaaS.

# 6. Contexto normativo

Esta tarea se encuentra restringida por las siguientes fuentes obligatorias:

- `docs/product/00-master-product-brief.md`: establece Next.js App Router, React, TypeScript estricto y Tailwind CSS como parte del stack; exige tareas de Codex pequeñas y verificables y prohíbe comenzar funcionalidad antes de definir requisitos, seguridad, criterios y pruebas.
- `docs/product/01-product-definition.md`: mantiene como objetivo arquitectónico una arquitectura simple y modular dentro de un único proyecto Next.js y conserva la separación del alcance funcional posterior.
- `docs/product/10-architecture-decisions-records.md`: distingue decisiones técnicas menores de decisiones que requieren ADR; las elecciones locales, reversibles y necesarias de tooling no deben convertirse automáticamente en decisiones arquitectónicas. Fase 0 está completada y los `DO-*` / `*-OPEN-*` con deadlines posteriores permanecen sin resolver.
- `docs/product/11-phase-1-scope-entry-gate.md`: define Fase 1 como `Setup, repositorio, CI y Supabase local`, exige trabajo PR-sized y establece explícitamente que el `Paso 2 — Bootstrap de aplicación` debe producir únicamente una aplicación base ejecutable con App Router, React, TypeScript estricto y styling base. También separa los pasos posteriores de tooling, skeleton modular, Supabase local y CI.
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`: establece un monolito modular dentro de un único proyecto/aplicación Next.js, un único deployable principal inicial y ausencia de microservicios, sin definir una estructura física final de carpetas ni imponer Clean Architecture, Hexagonal Architecture, Onion Architecture o DDD completo.

Reglas normativas consumidas por `TASK-001`:

- una única aplicación/proyecto Next.js;
- un único deployable principal inicial;
- App Router;
- React;
- TypeScript estricto;
- Tailwind CSS base;
- repositorio Git existente;
- documentación canónica existente que debe preservarse;
- ninguna funcionalidad de bounded contexts durante esta tarea;
- ningún `DO-*` ni `*-OPEN-*` se resuelve mediante el bootstrap;
- ningún ADR nuevo es necesario para las decisiones menores identificadas en esta tarea.

No se detecta una contradicción material entre estas fuentes que bloquee `TASK-001`.

# 7. Precondiciones

Antes de escribir o generar cualquier archivo, Codex debe:

1. leer íntegramente, como mínimo:
   - `docs/product/00-master-product-brief.md`;
   - `docs/product/01-product-definition.md`;
   - `docs/product/10-architecture-decisions-records.md`;
   - `docs/product/11-phase-1-scope-entry-gate.md`;
   - `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
2. inspeccionar el repositorio existente antes de decidir cualquier comando de scaffolding;
3. repetir el preflight operativo inmediatamente antes del primer cambio;
4. verificar:
   - repositorio Git válido;
   - base/branch esperada conforme al estado aprobado;
   - worktree limpio;
   - cierre de Fase 0 presente en `main`;
   - documentación normativa accesible;
   - ausencia de cambios pendientes que puedan mezclarse con el bootstrap;
5. registrar el `HEAD` inicial para poder demostrar posteriormente que la historia Git no fue alterada;
6. inspeccionar si ya existen:
   - `package.json`;
   - lockfiles;
   - configuración Node/package manager;
   - archivos Next.js;
   - `tsconfig.json`;
   - `.gitignore`;
   - cualquier bootstrap parcial previo;
7. preservar cualquier archivo existente que no deba ser modificado por el alcance de esta tarea;
8. no asumir que el repositorio está vacío.

Si la inspección detecta que:

- el repositorio ya contiene una implementación Next.js materialmente distinta de la baseline esperada;
- existen cambios no comprometidos que impiden aislar `TASK-001`;
- existe funcionalidad de Fase 2+ incorporada inesperadamente;
- integrar el bootstrap exigiría borrar o sobrescribir documentación normativa;
- existe una decisión arquitectónica material no cubierta por la baseline cuya resolución sea imprescindible para continuar;

Codex debe detener la implementación y reportar:

`BLOCKER`

sin resolverlo silenciosamente.

# 8. Dentro de alcance

`TASK-001` puede realizar exclusivamente lo necesario para obtener el bootstrap mínimo siguiente:

- integrar Next.js en el repositorio existente;
- utilizar App Router;
- integrar React mediante el stack normal de Next.js;
- habilitar TypeScript;
- mantener `strict` efectivo en TypeScript;
- integrar Tailwind CSS únicamente en su configuración/base mínima;
- crear o adaptar el package manifest necesario;
- producir exactamente un lockfile correspondiente al package manager adoptado;
- crear/adaptar la configuración mínima necesaria de Next.js;
- crear/adaptar la configuración mínima necesaria de TypeScript;
- incluir archivos técnicos generados/requeridos por Next.js y TypeScript;
- incluir únicamente la configuración PostCSS/Tailwind que sea necesaria para la versión compatible elegida;
- adaptar `.gitignore` sólo cuando sea necesario para artefactos normales del bootstrap y sin eliminar reglas preexistentes válidas;
- crear el `app`/App Router mínimo necesario;
- crear un root layout técnico mínimo;
- crear una página raíz técnica mínima;
- crear CSS global mínimo necesario para comprobar Tailwind/base styling;
- conservar únicamente assets estáticos técnicamente necesarios;
- disponer de scripts mínimos propios de una aplicación Next.js para desarrollo, build y arranque cuando correspondan al bootstrap generado;
- instalar únicamente dependencias requeridas directamente por este bootstrap;
- ejecutar la aplicación para comprobar que arranca;
- ejecutar un typecheck compatible con el `tsconfig`;
- ejecutar el build de producción de Next.js.

La página raíz debe limitarse a indicar técnicamente que el bootstrap funciona. No debe presentar producto, dashboard, marketing, navegación funcional ni contenido comercial.

## Decisiones técnicas menores permitidas en esta tarea

Las siguientes elecciones son necesarias para completar el bootstrap, son locales/reversibles y no requieren ADR:

- versión concreta y mutuamente compatible de Next.js, React, TypeScript y Tailwind CSS;
- versiones concretas de sus dependencias estrictamente necesarias;
- mecanismo exacto de scaffolding seguro;
- extensión concreta de los archivos de configuración cuando el tooling soporte varias equivalentes;
- boilerplate técnico mínimo del root layout y página;
- metadata técnica mínima exigida por Next.js;
- archivos técnicos generados automáticamente que sean estrictamente necesarios;
- versión de Node utilizada para ejecutar el bootstrap, siempre que sea soportada por la versión de Next.js seleccionada.

Reglas para estas decisiones:

- si el repositorio ya establece una convención válida, preservarla;
- si ya existe un único package manager adoptado, utilizarlo;
- si no existe ninguna convención de package manager, utilizar `npm` para `TASK-001`;
- no introducir más de un lockfile;
- no añadir una política avanzada de runtime o package management sólo por preferencia;
- seleccionar versiones estables y compatibles disponibles en el momento de implementación, sin convertirlas en una decisión arquitectónica;
- registrar las versiones finalmente utilizadas en el informe de Codex;
- no crear un ADR por estas elecciones salvo que durante la implementación aparezca una consecuencia arquitectónica material no contemplada actualmente.

# 9. Fuera de alcance

Queda explícitamente fuera de `TASK-001`:

- materialización del skeleton modular de `ADR-0001`;
- arquitectura modular física definitiva;
- directorios de bounded contexts preparados “por si acaso”;
- imposición de Clean Architecture;
- imposición de Hexagonal Architecture;
- imposición de Onion Architecture;
- adopción de DDD completo;
- aliases avanzados o convenciones de imports arquitectónicos;
- reglas de dependencias entre módulos;
- CI;
- GitHub Actions;
- pipelines de deploy/release;
- configuración de Vercel;
- test runner adicional;
- configuración específica de tests;
- suites de tests;
- Supabase;
- Supabase CLI;
- Supabase local;
- Supabase Auth;
- Supabase Storage;
- Supabase Realtime;
- variables de entorno de producto;
- `.env` de producto;
- schema PostgreSQL del SaaS;
- migrations de producto;
- tablas;
- columnas;
- PK/FK;
- índices;
- constraints;
- funciones PostgreSQL;
- triggers;
- SQL;
- RLS;
- policies;
- autenticación;
- onboarding;
- tenancy funcional;
- `MaintenanceCompany`;
- `PlatformUser`;
- memberships;
- roles;
- `UserClientAccess`;
- `SupportAccessGrant`;
- clientes;
- ubicaciones;
- tipos de equipos;
- equipos;
- formularios;
- `FormTemplate`;
- `FormVersion`;
- Maintenance;
- Evidence;
- Offline;
- Dexie;
- IndexedDB;
- PWA offline-first;
- Service Worker offline-first;
- outbox;
- sync;
- Reporting;
- PDF;
- DOCX;
- OpenAI;
- integración de IA;
- créditos IA;
- Mercado Pago;
- Subscription;
- notificaciones;
- Dashboard;
- cualquier funcionalidad de Fase 2+;
- dependencias destinadas a fases futuras;
- documentación operativa completa de Fase 1;
- modificación semántica de documentación normativa;
- creación o modificación de ADR;
- resolución de cualquier `DO-*` o `*-OPEN-*`;
- `TASK-002`.

No instalar dependencias futuras “por si acaso”.

No añadir ESLint, Prettier, test frameworks u otro tooling adicional como iniciativa propia de esta tarea cuando no sean necesarios para que el bootstrap Next.js compile y se ejecute. El baseline específico de tooling y comandos de calidad corresponde al Paso 3 de Fase 1.

# 10. Archivos/categorías de archivos esperados

La implementación puede crear o modificar exclusivamente categorías equivalentes a las siguientes, según lo requiera la versión concreta y segura del bootstrap:

- `package.json`;
- exactamente un lockfile del package manager adoptado;
- `next.config.*`, sólo si el bootstrap lo requiere;
- `tsconfig.json`;
- archivos técnicos de TypeScript/Next.js generados o requeridos, por ejemplo el equivalente a `next-env.d.ts`;
- configuración PostCSS/Tailwind estrictamente necesaria;
- `app/layout.*` o equivalente generado por el App Router;
- `app/page.*` o equivalente generado por el App Router;
- CSS global/base requerido por Tailwind/Next.js;
- assets mínimos de `public/` únicamente cuando sean realmente utilizados o requeridos;
- `.gitignore`, exclusivamente mediante integración conservadora con el contenido ya existente.

No debe asumirse que todos estos archivos necesariamente deben crearse: Codex debe inspeccionar primero el repositorio y reutilizar/adaptar los existentes cuando corresponda.

No se esperan en esta tarea:

- `.github/workflows/*`;
- `supabase/*`;
- archivos de migrations;
- archivos SQL;
- archivos de schema de producto;
- `.env*` de producto;
- carpetas de módulos de dominio;
- archivos de autenticación;
- archivos Dexie/PWA/offline;
- adaptadores de integraciones futuras;
- archivos de tests añadidos específicamente para esta tarea.

La existencia previa de archivos fuera de esta lista no autoriza su eliminación.

# 11. Restricciones de implementación

## Repositorio existente

Codex debe trabajar sobre el repositorio actual.

Está prohibido:

- ejecutar `git init`;
- borrar `.git`;
- reemplazar la historia Git;
- recrear el repositorio;
- borrar `/docs`;
- renombrar `/docs` para satisfacer un generador;
- mover documentación canónica;
- sobrescribir documentación normativa;
- borrar archivos existentes para hacer que un scaffolder acepte un directorio vacío;
- ejecutar un generador destructivo sin haber revisado previamente sus efectos.

Si el scaffolder seleccionado no puede aplicarse de forma segura sobre el repositorio no vacío, Codex debe utilizar una estrategia equivalente y no destructiva, por ejemplo generar el bootstrap de forma aislada y trasladar únicamente los archivos necesarios después de inspeccionar colisiones.

La estrategia concreta es una decisión menor de implementación; la preservación del repositorio no lo es.

## Next.js / App Router

Debe existir una sola aplicación Next.js principal.

Debe utilizarse App Router.

No se debe introducir:

- un segundo proyecto Next.js;
- un subproyecto alternativo;
- un backend separado;
- un microservicio;
- otro deployable.

## TypeScript

Debe:

- estar habilitado;
- tener strict mode efectivo;
- compilar/typecheck correctamente;
- no contener `any` añadido deliberadamente;
- no introducir escapes de tipado innecesarios;
- utilizar únicamente configuración necesaria para el bootstrap.

No se diseñarán todavía aliases, reglas de boundaries ni convenciones avanzadas de arquitectura.

## Tailwind CSS

Debe limitarse a:

- dependencia/configuración base necesaria;
- integración con el CSS global;
- uso técnico mínimo suficiente para verificar que está operativo, cuando resulte útil.

No debe incluir:

- design system;
- tokens de producto;
- theme comercial;
- branding;
- biblioteca de componentes;
- componentes de negocio.

## UI mínima

La página inicial puede mostrar exclusivamente contenido técnico neutro, por ejemplo:

`Next.js bootstrap OK`

o una formulación técnica equivalente.

No debe incluir:

- nombre comercial inventado;
- claims de marketing;
- navegación funcional;
- login;
- dashboard;
- cards de producto;
- datos demo del dominio;
- tenants/clientes/equipos de ejemplo;
- formularios funcionales.

## Dependencias

Sólo pueden añadirse dependencias directamente necesarias para:

- Next.js;
- React;
- TypeScript;
- Tailwind CSS;
- soporte técnico requerido por esas piezas.

No deben instalarse dependencias para fases posteriores.

## Git

Durante esta tarea Codex:

- puede modificar los archivos permitidos del worktree para implementar `TASK-001`;
- no debe ejecutar `git init`;
- no debe reescribir historia;
- no debe hacer commit;
- no debe hacer push;
- no debe crear tags;
- no debe realizar operaciones destructivas sobre branches.

La ausencia de autorización de commit/push debe preservarse salvo instrucción explícita posterior sustentada en una regla canónica aplicable.

# 12. Seguridad

`TASK-001` no implementa una frontera de autorización de producto.

Son obligatorias las siguientes restricciones:

- no introducir secretos;
- no introducir claves productivas;
- no introducir Supabase keys;
- no introducir `service-role`;
- no introducir OpenAI API keys;
- no introducir credenciales de Mercado Pago;
- no introducir tokens privados;
- no introducir `.env` con valores secretos reales;
- no exponer datos sensibles en la página técnica;
- no añadir integraciones externas.

La UI generada no constituye una frontera de seguridad y no debe incorporar ninguna lógica que pretenda anticipar autenticación o autorización.

No existe todavía lógica tenant ni acceso a datos tenant.

# 13. Impacto de datos / migrations

`NINGUNO`

`TASK-001` no crea, modifica ni diseña:

- schema de producto;
- base de datos de producto;
- tablas;
- columnas;
- relaciones;
- índices;
- constraints;
- funciones;
- triggers;
- migrations;
- seeds;
- SQL;
- almacenamiento local de dominio.

No debe existir ninguna migration de producto como resultado de esta tarea.

# 14. Impacto RLS

`NO APLICA TODAVÍA — no existe schema de producto en TASK-001`

No se crean ni diseñan:

- policies RLS;
- helpers RLS;
- funciones de autorización PostgreSQL;
- claims;
- tenant resolution;
- permisos;
- roles físicos.

La ausencia de RLS en esta tarea no constituye una excepción a su obligatoriedad futura. Simplemente no existe todavía ningún dato tenant de producto sobre el cual aplicarla.

# 15. Criterios de aceptación

`TASK-001` se considera aceptable únicamente si se cumplen todos los siguientes criterios:

1. el repositorio existente fue inspeccionado antes de generar archivos;
2. se repitió el preflight de Git antes del primer cambio;
3. el repositorio Git existente fue preservado;
4. no se ejecutó `git init`;
5. el `HEAD` inicial no fue alterado por commits, rebases, resets destructivos u otras modificaciones de historia;
6. `/docs` permanece intacto;
7. ningún documento normativo fue sobrescrito o modificado;
8. existe una única aplicación Next.js principal integrada en el repositorio;
9. utiliza App Router;
10. React está configurado exclusivamente como parte del bootstrap Next.js;
11. TypeScript está habilitado;
12. TypeScript strict está efectivamente activo;
13. no se añadió deliberadamente ningún `any`;
14. Tailwind CSS está integrado únicamente a nivel base;
15. existe un `package.json` válido;
16. existe exactamente un lockfile coherente con el package manager utilizado;
17. las dependencias pueden instalarse de forma reproducible desde el manifest y lockfile;
18. la aplicación puede arrancarse con el comando de desarrollo correspondiente;
19. la ruta raíz renderiza una superficie técnica mínima;
20. el typecheck termina exitosamente;
21. el build de producción de Next.js termina exitosamente;
22. no se creó configuración de CI;
23. no se creó GitHub Actions;
24. no se añadió test runner adicional ni configuración específica de tests;
25. no se configuró Supabase;
26. no se creó schema de producto;
27. no se crearon migrations de producto;
28. no se creó SQL de producto;
29. no se creó RLS;
30. no se implementó Auth;
31. no se implementó tenancy;
32. no se implementó ningún bounded context funcional;
33. no se añadió Dexie/IndexedDB/Service Worker offline-first;
34. no se añadió Reporting/PDF/DOCX;
35. no se añadió OpenAI/IA/créditos;
36. no se añadió Mercado Pago/Subscription;
37. no se añadieron notificaciones ni Dashboard;
38. no se instalaron dependencias destinadas exclusivamente a fases futuras;
39. no se creó un ADR;
40. no se resolvió ningún `DO-*` ni `*-OPEN-*`;
41. no se realizó commit;
42. no se realizó push;
43. `TASK-002` no fue creada ni iniciada.

# 16. Pruebas/verificaciones obligatorias

Codex debe ejecutar y registrar, como mínimo, las siguientes verificaciones.

## Antes de modificar

- comprobar el repositorio con `git status` o equivalente;
- comprobar la raíz Git con `git rev-parse --show-toplevel` o equivalente;
- registrar el commit/`HEAD` inicial;
- inspeccionar archivos existentes y detectar colisiones;
- inspeccionar package manifests/lockfiles preexistentes;
- verificar que `/docs` existe y contiene la baseline esperada.

## Instalación

Ejecutar la instalación reproducible correspondiente al package manager adoptado utilizando el manifest y lockfile resultantes.

Debe terminar sin errores.

## TypeScript

Ejecutar un typecheck explícito compatible con el `tsconfig.json`, mediante `tsc --noEmit` o el equivalente válido para el package manager/configuración seleccionados.

Debe terminar con código de salida exitoso.

Además, verificar expresamente que strict mode está activo de forma efectiva.

## Build

Ejecutar el build de producción de Next.js mediante el script correspondiente.

Debe finalizar exitosamente.

## Arranque

Ejecutar temporalmente la aplicación mediante el script de desarrollo correspondiente y comprobar que:

- el servidor inicia correctamente;
- la ruta `/` responde;
- se renderiza la superficie técnica mínima esperada;
- no existe dependencia de Supabase, Auth, secrets u otros servicios externos para arrancar.

## Preservación del repositorio

Después de la implementación:

- volver a comprobar el estado Git;
- verificar que el `HEAD` continúa siendo el mismo que antes de la tarea;
- verificar que no se reinicializó Git;
- verificar que `/docs` permanece intacto;
- comprobar que no existen cambios inesperados dentro de `/docs`;
- revisar la lista total de archivos nuevos/modificados;
- revisar que sólo correspondan a las categorías autorizadas por `TASK-001`.

## Scope negativo

Realizar una inspección final que confirme que la tarea no introdujo:

- `.github/workflows`;
- configuración de CI;
- Supabase;
- migrations;
- SQL;
- RLS;
- Auth;
- tenancy;
- módulos funcionales;
- Dexie;
- Service Worker offline-first;
- Reporting;
- IA;
- Mercado Pago;
- secretos;
- funcionalidad de Fase 2+.

Si alguno de estos elementos ya existía antes de la tarea, Codex no debe borrarlo para hacer pasar esta verificación: debe reportar la situación y distinguir claramente estado previo de cambios introducidos por `TASK-001`. Si el estado previo contradice materialmente el Gate de Fase 1, debe informarlo como `BLOCKER`.

No se exige en `TASK-001`:

- configurar CI;
- instalar un test runner;
- crear tests adicionales;
- arrancar Supabase local;
- ejecutar pruebas de RLS;
- ejecutar migrations.

# 17. Definition of Done

La `Definition of Done` de `TASK-001` se considera satisfecha únicamente cuando:

- todas las precondiciones fueron verificadas;
- el bootstrap fue integrado sin destruir contenido existente;
- Next.js arranca;
- App Router está activo;
- React funciona dentro del bootstrap;
- TypeScript strict está activo;
- el typecheck pasa;
- Tailwind CSS base está integrado;
- el build pasa;
- existe manifest y un único lockfile válido;
- la UI permanece exclusivamente técnica;
- `/docs` está intacto;
- Git no fue reinicializado;
- la historia Git no fue modificada;
- no existen cambios fuera del alcance declarado;
- no se añadieron dependencias futuras;
- no existen secrets;
- no se introdujeron schema, migrations, SQL ni RLS;
- no se introdujeron Auth ni tenancy;
- no se implementó Fase 2+;
- no se resolvió ningún `DO-*` ni `*-OPEN-*`;
- no se generó un ADR;
- Codex produjo el informe final exigido por esta tarea;
- no se realizó commit ni push;
- no se inició ni generó `TASK-002`.

El cumplimiento de la `Definition of Done` de `TASK-001` no implica:

- que el skeleton modular esté definido;
- que el tooling completo de Fase 1 esté configurado;
- que exista CI;
- que exista Supabase local;
- que Fase 1 esté completada;
- que Fase 2 pueda comenzar.

# 18. Instrucciones para Codex

Al recibir esta tarea aprobada para implementación, Codex debe actuar en el siguiente orden:

1. leer primero las fuentes normativas indicadas en la sección `Contexto normativo`;
2. inspeccionar el repositorio completo antes de escribir;
3. repetir el preflight Git inmediatamente antes del primer cambio;
4. registrar el `HEAD` inicial;
5. inspeccionar cualquier `package.json`, lockfile, `.gitignore`, configuración Node/TypeScript/Next.js existente y evitar sobrescrituras ciegas;
6. implementar exclusivamente `TASK-001`;
7. integrar el bootstrap en el repositorio existente;
8. no asumir directorio vacío;
9. no ejecutar `git init`;
10. no eliminar archivos existentes para satisfacer un generador;
11. preservar `/docs`;
12. preservar la historia Git;
13. utilizar una estrategia de scaffolding no destructiva;
14. mantener una única aplicación Next.js;
15. utilizar App Router;
16. habilitar TypeScript strict;
17. no añadir `any` deliberadamente;
18. incluir únicamente Tailwind CSS base;
19. mantener la página y shell como superficie exclusivamente técnica;
20. no materializar todavía el skeleton modular;
21. no instalar dependencias de fases futuras;
22. no configurar CI;
23. no añadir un test runner adicional;
24. no configurar Supabase;
25. no crear schema;
26. no crear migrations;
27. no escribir SQL;
28. no crear RLS;
29. no implementar Auth;
30. no implementar tenancy;
31. no implementar ningún bounded context funcional;
32. no implementar Offline/Dexie/Service Worker;
33. no implementar Reporting;
34. no implementar OpenAI/IA/créditos;
35. no implementar Mercado Pago/Subscription;
36. no resolver ningún `DO-*` ni `*-OPEN-*`;
37. no crear ni modificar ADR por una decisión menor de tooling;
38. ejecutar todas las verificaciones obligatorias definidas en `TASK-001`;
39. no hacer commit;
40. no hacer push;
41. no generar ni comenzar `TASK-002`.

## Informe obligatorio de Codex al finalizar

Codex debe devolver un informe explícito que contenga:

- resultado global: `PASS`, `FAIL` o `BLOCKER`;
- preflight realizado;
- `HEAD` inicial y confirmación de que no fue modificado por historia Git;
- archivos creados;
- archivos modificados;
- archivos existentes preservados cuando sean relevantes;
- confirmación explícita de que `/docs` permanece intacto;
- package manager utilizado;
- versión de Node utilizada;
- versiones instaladas de:
  - Next.js;
  - React;
  - TypeScript;
  - Tailwind CSS;
- decisiones técnicas menores tomadas;
- estrategia de scaffolding utilizada;
- comandos ejecutados;
- resultado de instalación;
- resultado del typecheck;
- confirmación de TypeScript strict efectivo;
- resultado del build;
- resultado de la prueba de arranque;
- confirmación de que no existen secrets añadidos;
- confirmación de que no se añadió Supabase;
- confirmación de que no se añadieron schema/migrations/SQL/RLS;
- confirmación de que no se implementó Auth/tenancy;
- confirmación de que no se implementó Fase 2+;
- confirmación de que no se resolvió ningún `DO-*` ni `*-OPEN-*`;
- confirmación de que no se creó ADR;
- confirmación de que no se hizo commit ni push;
- cualquier desviación o blocker encontrado.

Si aparece un blocker, Codex debe reportarlo y detenerse dentro de esta tarea. No debe ampliar el alcance para solucionarlo.

# 19. Resultado esperado

Al finalizar correctamente `TASK-001`, el repositorio existente debe continuar siendo el mismo repositorio Git y conservar íntegramente su documentación normativa, pero además debe contener un bootstrap Next.js mínimo y ejecutable.

El estado técnico esperado es:

- una sola aplicación Next.js;
- App Router operativo;
- React operativo;
- TypeScript strict operativo;
- Tailwind CSS base operativo;
- página raíz técnica mínima;
- instalación de dependencias reproducible;
- typecheck exitoso;
- build exitoso;
- ejecución local básica exitosa;
- package manifest presente;
- un único lockfile;
- configuración limitada al bootstrap.

El estado funcional esperado es:

`NINGUNA FUNCIONALIDAD DE PRODUCTO IMPLEMENTADA`

El estado de infraestructura posterior esperado es:

- CI: no configurada por esta tarea;
- Supabase local: no configurado por esta tarea;
- schema: inexistente;
- migrations de producto: inexistentes;
- RLS: inexistente porque todavía no existe schema de producto;
- Auth: no implementado;
- tenancy: no implementada;
- Fase 2+: no implementada.

No se espera que `TASK-001` complete Fase 1.

# 20. Gate posterior

Después de la implementación de `TASK-001` debe realizarse una revisión explícita antes de cualquier nueva tarea.

El Gate posterior debe verificar:

- cumplimiento íntegro de los criterios de aceptación;
- arquitectura coherente con `ADR-0001`;
- una única aplicación/deployable principal;
- ausencia de arquitectura modular física prematura;
- ausencia de microservicios;
- TypeScript strict efectivo;
- build exitoso;
- bootstrap ejecutable;
- Tailwind limitado a base técnica;
- repositorio preexistente preservado;
- `/docs` intacto;
- historia Git intacta;
- ausencia de secretos;
- ausencia de dependencias futuras innecesarias;
- ausencia de CI;
- ausencia de Supabase;
- ausencia de schema;
- ausencia de migrations;
- ausencia de SQL;
- ausencia de RLS;
- ausencia de Auth;
- ausencia de tenancy;
- ausencia de capacidades de Fase 2+;
- ningún `DO-*` o `*-OPEN-*` resuelto;
- ningún ADR nuevo;
- ningún commit/push realizado sin autorización;
- informe de Codex completo.

Sólo después de que `TASK-001` haya sido implementada y revisada satisfactoriamente podrá evaluarse cuál es el siguiente trabajo de Fase 1 conforme al orden aprobado.

Este Gate no autoriza, define ni genera `TASK-002`.

`TASK-001` permanece en estado:

`APPROVED FOR IMPLEMENTATION`

Estado operativo actual:

- TASK-001 ejecutada: no;
- Codex ejecutado: no;
- commit realizado: no;
- push realizado: no;
- TASK-002 generada: no;
- Fase 1 completada: no;
- Fase 2 iniciada: no.