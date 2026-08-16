# 1. ID

`CORR-001`

# 2. Título

`Compatibilidad de TypeScript con el tooling oficial`

# 3. Fase

`Fase 1 — Corrección técnica previa a reintento de TASK-002`

Esta corrección pertenece exclusivamente a Fase 1.

No inicia Fase 2, no modifica su alcance y no implementa ninguna capacidad funcional del SaaS.

# 4. Estado

`APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`CORR-001-typescript-tooling-compatibility-approved.md`

**Ruta normativa futura:**

`docs/tasks/CORR-001-typescript-tooling-compatibility.md`

Esta especificación ha sido aprobada documentalmente para implementación futura.

La corrección todavía no fue implementada.

Este estado no autoriza reintentar `TASK-002` ni avanzar automáticamente a ninguna tarea posterior.

# 5. Problema

`TASK-002 — Tooling y comandos base de calidad` se encuentra bloqueada por una incompatibilidad del baseline técnico heredado de `TASK-001`.

Estado técnico confirmado:

- Next.js `16.3.1`;
- React `19.2.8`;
- TypeScript `7.0.2`;
- Node.js `22.23.1`;
- npm `10.9.8`;
- `strict: true`;
- App Router operativo;
- Tailwind CSS base operativo.

`TASK-002` exige correctamente:

- ESLint mediante CLI;
- configuración oficial de Next.js;
- `eslint-config-next/core-web-vitals` o equivalente oficial vigente;
- `eslint-config-next/typescript` o equivalente oficial vigente;
- integración con el ecosistema TypeScript ESLint;
- Vitest como test runner base;
- tooling estable, compatible y soportado;
- ausencia de resolución forzada de dependencias.

La configuración oficial `eslint-config-next@16.3.1` depende de `typescript-eslint`, mientras que el rango de TypeScript oficialmente soportado actualmente por TypeScript ESLint es `>=4.8.4 <6.1.0`. Por tanto, TypeScript `7.0.2` queda fuera de ese contrato de soporte. ([github.com](https://github.com/vercel/next.js/blob/v16.3.1/packages/eslint-config-next/package.json))

Continuar con TypeScript `7.0.2` obligaría a utilizar una combinación no oficialmente soportada o a introducir una excepción expresamente prohibida por esta corrección.

Por lo tanto:

`TASK-002 está bloqueada por una incompatibilidad del baseline técnico heredado de TASK-001.`

El bloqueo no demuestra un defecto conceptual de `TASK-002`. La tarea exige correctamente tooling oficial y compatible.

# 6. Causa raíz

La causa raíz es una incompatibilidad de versiones entre una decisión técnica menor tomada durante el bootstrap y el tooling requerido inmediatamente después.

`TASK-001` permitía seleccionar versiones concretas, estables y mutuamente compatibles de Next.js, React, TypeScript y Tailwind como decisiones locales y reversibles, sin convertirlas en decisiones arquitectónicas. También exigía mantener TypeScript estricto.

El baseline resultante incorporó TypeScript `7.0.2`.

Sin embargo:

- `eslint-config-next@16.3.1` incluye una dependencia sobre `typescript-eslint` `^8.46.0`;
- el paquete oficial exporta las configuraciones `core-web-vitals` y `typescript`;
- la documentación oficial de TypeScript ESLint declara como rango soportado de TypeScript `>=4.8.4 <6.1.0`;
- por ello TypeScript `7.0.2` no se encuentra actualmente dentro del rango soportado por el tooling requerido por `TASK-002`. ([github.com](https://github.com/vercel/next.js/blob/v16.3.1/packages/eslint-config-next/package.json))

La incompatibilidad no debe resolverse mediante:

- `--legacy-peer-deps`;
- `--force`;
- overrides;
- peer dependencies ignoradas;
- paquetes experimentales para mantener TypeScript 7;
- omisión de la configuración TypeScript oficial de Next.js;
- relajación de TypeScript;
- sustitución de Next.js;
- sustitución de React.

La causa raíz se clasifica como:

`desalineación menor y reversible del baseline de dependencias de desarrollo`

y no como una contradicción del diseño del producto ni de la arquitectura aprobada.

# 7. Contexto normativo

Esta corrección se encuentra restringida por las siguientes fuentes.

`TASK-001` estableció que la elección de versiones concretas y mutuamente compatibles del bootstrap era una decisión técnica local y reversible, sin necesidad de ADR mientras no apareciera una consecuencia arquitectónica material.

`TASK-002` exige linting mediante ESLint CLI, configuración oficial de Next.js para Next.js/React/TypeScript y Vitest como test runner base, preservando `strict`, npm y el bootstrap existente. También prohíbe CI, Supabase, Fase 2+, ADR nuevos y modificaciones fuera de su alcance.

El registro maestro de arquitectura distingue expresamente las decisiones técnicas menores, locales y reversibles de las decisiones arquitectónicas que justifican un ADR. Las decisiones técnicas menores no requieren ADR.

La definición aprobada de Fase 1 mantiene como alcance `Setup, repositorio, CI y Supabase local`, incluyendo TypeScript estricto y tooling base antes de avanzar hacia bounded contexts funcionales.

Esta corrección debe preservar, sin reinterpretación:

- Next.js `16.3.1`;
- React `19.2.8`;
- App Router;
- Tailwind CSS existente;
- npm;
- Node.js existente;
- TypeScript `strict: true`;
- un único proyecto Next.js;
- un único lockfile;
- `/docs`;
- el alcance aprobado de Fase 1;
- `TASK-001` como tarea ya cerrada;
- `TASK-002` como tarea aprobada pero todavía no implementada.

`CORR-001` no modifica semánticamente `TASK-001` ni `TASK-002`.

# 8. Precondiciones

Antes de cualquier futura implementación de esta corrección deben cumplirse todas las siguientes precondiciones:

1. `CORR-001` debe haber sido revisada y aprobada explícitamente por una persona.
2. El repositorio debe ser inspeccionado antes de cualquier cambio.
3. El repositorio debe continuar siendo un repositorio Git válido.
4. La base esperada debe ser `main`.
5. `main` debe estar sincronizada con `origin/main`.
6. El worktree debe estar limpio.
7. Debe registrarse el `HEAD` inicial como evidencia del preflight.
8. `TASK-001` debe continuar integrada y cerrada.
9. `TASK-002` debe continuar sin implementar.
10. Deben verificarse las versiones reales presentes en:
    - `package.json`;
    - `package-lock.json`;
    - instalación efectiva cuando corresponda.
11. Debe verificarse específicamente que la versión previa de TypeScript sea realmente `7.0.2`.
12. Debe comprobarse que Next.js continúe en `16.3.1`.
13. Debe comprobarse que React continúe en `19.2.8`.
14. Debe comprobarse que Node.js y npm continúen siendo compatibles con el baseline vigente.
15. Debe comprobarse que `strict: true` permanezca efectivo.
16. Debe existir exactamente un lockfile.
17. `/docs` debe estar íntegro antes del cambio.
18. No debe existir una implementación parcial residual de ESLint, Vitest u otro tooling procedente del intento bloqueado de `TASK-002`.
19. No deben existir cambios pendientes que puedan mezclarse con `CORR-001`.
20. No debe existir funcionalidad de Fase 2+ incorporada inesperadamente.

Si alguna precondición material falla y no puede resolverse dentro del alcance exclusivo de cambiar TypeScript y su lockfile, la implementación debe detenerse con:

`BLOCKER`

# 9. Decisión propuesta

Se propone corregir el baseline técnico mediante un único cambio de dependencia:

`TypeScript 7.0.2 → TypeScript 6.0.3`

La futura implementación correctiva debe modificar exclusivamente la versión de TypeScript y regenerar coherentemente el lockfile.

No debe modificar:

- Next.js;
- React;
- Tailwind CSS;
- Node.js;
- npm;
- package manager;
- arquitectura;
- código de aplicación;
- `tsconfig.json`, salvo que aparezca un `BLOCKER` técnico real, caso en el cual no debe modificarse automáticamente;
- documentación normativa;
- `TASK-001`;
- `TASK-002`.

La versión objetivo se fija en `6.0.3`, no en una versión genérica `6.x`.

La futura corrección deberá asegurar que la resolución efectiva registrada en el lockfile sea exactamente TypeScript `6.0.3`.

No se introduce mediante `CORR-001` una política general de versionado de dependencias para el repositorio.

# 10. Versión TypeScript propuesta

**Versión propuesta:**

`TypeScript 6.0.3`

TypeScript `6.0.3` es una versión estable publicada oficialmente y es la versión estable más reciente identificada dentro del rango `<6.1.0` actualmente soportado por TypeScript ESLint. ([github.com](https://github.com/microsoft/typescript/releases))

Cumple simultáneamente:

1. se encuentra por encima del mínimo de TypeScript requerido por Next.js 16;
2. se encuentra dentro de `>=4.8.4 <6.1.0`, rango de TypeScript oficialmente soportado por TypeScript ESLint;
3. permite conservar `strict: true`;
4. es estable;
5. no requiere `--force`;
6. no requiere `--legacy-peer-deps`;
7. no requiere overrides;
8. no requiere mantener TypeScript 7 mediante mecanismos experimentales;
9. no exige cambiar Next.js;
10. no exige cambiar React.

Next.js 16 establece TypeScript `5.1.0` como mínimo, por lo que `6.0.3` permanece dentro de la baseline soportada por Next.js. ([nextjs.org](https://nextjs.org/docs/app/guides/upgrading/version-16?utm_source=chatgpt.com))

# 11. Evidencia de compatibilidad

## 11.1 TypeScript ESLint

La documentación oficial vigente de TypeScript ESLint declara:

- TypeScript soportado: `>=4.8.4 <6.1.0`;
- Node.js soportado: `^18.18.0 || ^20.9.0 || >=21.1.0`;
- ESLint soportado: `^8.57.0 || ^9.0.0 || ^10.0.0`. ([typescript-eslint.io](https://typescript-eslint.io/users/dependency-versions/))

Resultado:

- TypeScript `7.0.2` → **fuera del rango soportado**;
- TypeScript `6.0.3` → **dentro del rango soportado**;
- Node.js `22.23.1` → **dentro del rango soportado**.

La política oficial de TypeScript ESLint también distingue soporte de versiones estables de TypeScript frente a versiones todavía no cubiertas formalmente, por lo que conservar TypeScript 7 fuera del rango no constituye una base adecuada para `TASK-002`. ([typescript-eslint.io](https://typescript-eslint.io/users/dependency-versions/))

## 11.2 `eslint-config-next@16.3.1`

La metadata oficial de `eslint-config-next@16.3.1` declara:

- dependencia `typescript-eslint: ^8.46.0`;
- peer dependency de ESLint `>=9.0.0`;
- peer dependency opcional de TypeScript `>=3.3.1`;
- export de `./core-web-vitals`;
- export de `./typescript`;
- TypeScript `6.0.2` como dependencia de desarrollo del propio paquete. ([github.com](https://github.com/vercel/next.js/blob/v16.3.1/packages/eslint-config-next/package.json))

La peer dependency amplia de TypeScript declarada directamente por `eslint-config-next` no elimina la restricción más estrecha del tooling TypeScript ESLint que la configuración utiliza.

La intersección relevante para `CORR-001` es, por tanto:

`Next.js 16.3.1`
→ `eslint-config-next 16.3.1`
→ `typescript-eslint 8.x`
→ `TypeScript >=4.8.4 <6.1.0`

TypeScript `6.0.3` pertenece a esa intersección.

## 11.3 Configuración TypeScript oficial de Next.js

La documentación oficial de Next.js indica que la configuración TypeScript de `eslint-config-next` incorpora reglas específicas provenientes de TypeScript ESLint y se utiliza junto con la configuración base o `core-web-vitals`. ([nextjs.org](https://nextjs.org/docs/app/api-reference/config/eslint?utm_source=chatgpt.com))

Por tanto, omitir esa configuración para mantener TypeScript `7.0.2` no sería equivalente a satisfacer `TASK-002`.

## 11.4 Next.js

Next.js 16 requiere como mínimo TypeScript `5.1.0`. TypeScript `6.0.3` supera ese mínimo. ([nextjs.org](https://nextjs.org/docs/app/guides/upgrading/version-16?utm_source=chatgpt.com))

`CORR-001` no cambia Next.js `16.3.1`.

## 11.5 React

La metadata oficial de Next.js `16.3.1` admite React mediante un peer range que incluye React `19.x`; por tanto React `19.2.8` puede conservarse sin cambio. ([github.com](https://github.com/vercel/next.js/blob/v16.3.1/packages/next/package.json))

`CORR-001` no cambia React.

## 11.6 Node.js

Next.js 16 requiere Node.js `20.9.0` o superior, mientras TypeScript ESLint soporta Node `>=21.1.0` además de sus ramas LTS especificadas. El Node actual `22.23.1` satisface ambas condiciones. ([nextjs.org](https://nextjs.org/docs/app/guides/upgrading/version-16?utm_source=chatgpt.com))

`CORR-001` no cambia Node.js.

## 11.7 Vitest

Vitest soporta TypeScript como parte normal de su flujo y su documentación oficial indica que puede trabajar con archivos TypeScript sin introducir un compilador TypeScript separado para el runner. ([vitest.dev](https://vitest.dev/guide/learn/writing-tests.html?utm_source=chatgpt.com))

Vitest 4 requiere Node.js 20 o superior, condición satisfecha por Node.js `22.23.1`. ([vitest.dev](https://vitest.dev/guide/migration.html?utm_source=chatgpt.com))

`CORR-001` no selecciona ni instala una versión concreta de Vitest. Esa decisión permanece dentro de `TASK-002`.

La evidencia anterior es suficiente únicamente para comprobar que TypeScript `6.0.3` no introduce el bloqueo de TypeScript que actualmente impide preparar el tooling.

## 11.8 ESLint

`CORR-001` no selecciona ni instala ESLint.

La evidencia disponible demuestra que:

- `eslint-config-next@16.3.1` requiere ESLint `>=9.0.0`;
- TypeScript ESLint admite actualmente ESLint 9 dentro de su rango oficial. ([github.com](https://github.com/vercel/next.js/blob/v16.3.1/packages/eslint-config-next/package.json))

Esto demuestra que existe al menos una intersección oficial utilizable sin depender de conservar TypeScript 7.

`CORR-001` **no autoriza ESLint 10**. La versión exacta de ESLint y la compatibilidad completa de sus plugins deberán verificarse nuevamente durante `TASK-002`.

## 11.9 Conclusión técnica

Existe una versión estable de TypeScript capaz de satisfacer la precondición requerida:

`TypeScript 6.0.3`

Por tanto:

- **BLOCKER del baseline actual:** sí;
- **BLOCKER irresoluble bajo las restricciones de CORR-001:** no;
- **corrección propuesta:** viable;
- **hacks de dependencias necesarios:** ninguno;
- **cambio de Next.js necesario:** no;
- **cambio de React necesario:** no;
- **cambio arquitectónico necesario:** no.

# 12. Dentro de alcance

La futura implementación de `CORR-001` puede realizar exclusivamente:

- cambiar TypeScript desde `7.0.2` a `6.0.3`;
- actualizar la entrada correspondiente en `package.json`;
- regenerar coherentemente `package-lock.json`;
- comprobar que el lockfile resuelve TypeScript `6.0.3`;
- realizar una instalación reproducible;
- ejecutar typecheck;
- ejecutar build;
- verificar que el bootstrap de `TASK-001` continúa intacto;
- verificar que `strict: true` continúa activo;
- comprobar que no se produjo ningún cambio funcional;
- comprobar que `/docs` permanece intacto;
- comprobar que existe un único lockfile;
- registrar las versiones anterior y nueva de TypeScript;
- registrar el resultado de las verificaciones.

El cambio técnico futuro debe quedar limitado a:

`package.json`

y:

`package-lock.json`

No se autoriza ningún tercer archivo modificado.

# 13. Fuera de alcance

Queda completamente fuera de `CORR-001`:

- cambiar Next.js;
- cambiar React;
- cambiar Tailwind CSS;
- cambiar Node.js;
- cambiar npm;
- cambiar package manager;
- instalar ESLint;
- instalar `eslint-config-next`;
- instalar TypeScript ESLint explícitamente como iniciativa de esta corrección;
- instalar Vitest;
- instalar Prettier;
- instalar cualquier otro tooling de `TASK-002`;
- crear `eslint.config.*`;
- crear configuración de Vitest;
- crear smoke tests;
- crear `verify`;
- crear formatter;
- ejecutar o reintentar `TASK-002`;
- CI;
- GitHub Actions;
- pipelines;
- Vercel;
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
- constraints;
- funciones PostgreSQL;
- RLS;
- policies;
- autenticación;
- tenancy funcional;
- roles;
- clientes;
- ubicaciones;
- equipos;
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
- OpenAI;
- IA;
- créditos IA;
- Mercado Pago;
- Subscription;
- notificaciones;
- Dashboard;
- skeleton modular;
- bounded contexts;
- arquitectura física definitiva;
- microservicios;
- Fase 2 o superior;
- secrets;
- `.env` de producto;
- modificación de ADR;
- creación de ADR;
- resolución de `DO-*`;
- resolución de `*-OPEN-*`;
- modificación de `TASK-001`;
- modificación de `TASK-002`;
- generación de `TASK-003`;
- commit;
- push.

No deben instalarse dependencias futuras “por si acaso”.

# 14. Archivos esperados

La futura implementación técnica puede modificar únicamente:

- `package.json`;
- `package-lock.json`.

Cambio esperado en `package.json`:

- exclusivamente la versión declarada de TypeScript.

Cambio esperado en `package-lock.json`:

- exclusivamente los cambios coherentes derivados de resolver TypeScript `6.0.3` y la metadata estrictamente necesaria asociada a esa resolución.

Cualquier modificación no explicable por el cambio de TypeScript debe ser investigada.

No se esperan modificaciones en:

- `tsconfig.json`;
- `next.config.*`;
- archivos `app/*`;
- CSS;
- Tailwind;
- `.gitignore`;
- `/docs`;
- tests;
- configuración de lint;
- configuración de CI;
- otros manifests.

La eventual incorporación canónica de este documento en `docs/tasks/` constituye un acto documental separado y no forma parte del cambio técnico ejecutable de `CORR-001`.

# 15. Restricciones de implementación

La futura implementación debe cumplir obligatoriamente:

- no usar `--legacy-peer-deps`;
- no usar `--force`;
- no introducir `overrides` para ocultar incompatibilidades;
- no editar manualmente el lockfile de forma inconsistente;
- no mantener TypeScript 7 mediante paquetes experimentales o capas de compatibilidad;
- no cambiar Next.js;
- no cambiar React;
- no cambiar Tailwind;
- no cambiar Node.js;
- no cambiar npm;
- no cambiar package manager;
- no instalar tooling perteneciente a `TASK-002`;
- no relajar TypeScript;
- no añadir `any` deliberados;
- no introducir suppressions para conseguir un PASS;
- no cambiar `tsconfig.json`;
- si `tsconfig.json` requiriera un cambio para que TypeScript `6.0.3` funcione, detenerse y devolver `BLOCKER`;
- preservar `strict: true`;
- preservar App Router;
- preservar la página técnica existente;
- preservar `/docs`;
- preservar un único lockfile;
- no modificar historia Git;
- no ejecutar `git init`;
- no commit;
- no push.

El objetivo no es “conseguir una instalación que termine”, sino obtener una resolución soportada y reproducible sin excepciones al contrato aprobado.

# 16. Impacto arquitectónico

**Clasificación:**

`corrección técnica menor, local y reversible del baseline de bootstrap`

No constituye una nueva decisión arquitectónica.

Motivos:

1. no cambia la arquitectura modular adoptada;
2. no cambia el framework principal;
3. no cambia React;
4. no cambia el runtime;
5. no cambia el package manager;
6. no cambia la persistencia;
7. no cambia seguridad;
8. no cambia tenancy;
9. no cambia offline;
10. no cambia integraciones;
11. no cambia contratos de dominio;
12. no crea una dependencia estructural nueva;
13. la selección de una versión compatible de TypeScript ya fue clasificada en `TASK-001` como elección técnica menor y reversible.

El registro maestro establece además que las decisiones técnicas menores no necesitan ADR; un ADR se reserva para decisiones de impacto transversal, costosas de revertir o arquitectónicamente condicionantes.

Por tanto:

`ADR requerido: NO`

`CORR-001` tampoco altera ninguna decisión de `ADR-0001` ni de los restantes ADR aceptados.

No reabre conceptualmente `TASK-001`: corrige una versión concreta del baseline preservando todos sus resultados funcionales y técnicos aprobados.

No modifica el alcance de Fase 1: constituye una corrección interna necesaria para poder continuar el `Paso 3 — Tooling y comandos de calidad`.

# 17. Impacto de seguridad

No existe cambio en el modelo de seguridad del producto.

`CORR-001`:

- no introduce autenticación;
- no modifica autorización;
- no modifica roles;
- no modifica tenant resolution;
- no modifica secretos;
- no modifica middleware;
- no modifica APIs;
- no modifica dependencias de runtime funcionales de producto;
- no introduce credenciales;
- no amplía permisos;
- no implementa soporte excepcional.

La única consideración de seguridad operativa es de supply chain/reproducibilidad:

- el lockfile debe quedar coherente;
- no deben utilizarse flags que ignoren incompatibilidades;
- no deben aparecer dependencias ajenas al cambio;
- la instalación debe poder reproducirse desde manifest y lockfile.

# 18. Impacto de datos / migrations

`NO APLICA`

`CORR-001` no crea ni modifica:

- base de datos;
- schema;
- migrations;
- tablas;
- columnas;
- índices;
- constraints;
- funciones;
- triggers;
- seeds;
- SQL;
- almacenamiento de dominio;
- datos tenant.

No debe existir ninguna migration como resultado de esta corrección.

# 19. Impacto RLS

`NO APLICA`

No existe ningún cambio de:

- RLS;
- policies;
- helpers de autorización;
- ownership;
- tenant isolation;
- claims;
- roles PostgreSQL;
- Supabase.

La obligatoriedad futura de RLS para datos tenant permanece íntegramente preservada.

# 20. Criterios de aceptación

`CORR-001` sólo puede considerarse implementada satisfactoriamente si se cumplen todos los siguientes criterios:

1. hubo aprobación humana previa de esta especificación;
2. el repositorio fue inspeccionado antes de modificarlo;
3. el preflight confirmó branch `main`;
4. el preflight confirmó sincronización con `origin/main`;
5. el preflight confirmó worktree limpio;
6. se registró el `HEAD` inicial;
7. se verificaron las versiones reales del baseline;
8. la versión previa de TypeScript fue registrada;
9. la única dependencia cuya versión cambió deliberadamente fue TypeScript;
10. TypeScript quedó resuelto efectivamente como `6.0.3`;
11. `package.json` sólo presenta el cambio autorizado de TypeScript;
12. `package-lock.json` quedó coherente con `package.json`;
13. no existe un segundo lockfile;
14. la instalación desde manifest y lockfile es reproducible;
15. `strict: true` permanece efectivo;
16. `tsconfig.json` no fue modificado;
17. no se añadió `any` deliberado;
18. no se añadió ninguna suppression;
19. `npx tsc --noEmit` finaliza exitosamente;
20. `npm run build` finaliza exitosamente;
21. Next.js permanece en `16.3.1`;
22. React permanece en `19.2.8`;
23. Tailwind permanece sin cambios;
24. App Router permanece sin cambios;
25. la página bootstrap permanece preservada;
26. Node.js no fue cambiado;
27. npm no fue cambiado;
28. no se instaló ESLint;
29. no se instaló `eslint-config-next`;
30. no se instaló Vitest;
31. no se instaló Prettier;
32. no se implementó ningún otro elemento de `TASK-002`;
33. no se creó CI;
34. no se configuró Supabase;
35. no se creó schema;
36. no se crearon migrations;
37. no se creó SQL;
38. no se creó RLS;
39. no se implementó Auth;
40. no se implementó tenancy;
41. no se creó skeleton modular;
42. no se implementó ningún bounded context;
43. `/docs` permanece intacto;
44. `TASK-001` no fue modificada;
45. `TASK-002` no fue modificada;
46. `TASK-002` no fue reintentada;
47. `TASK-003` no fue generada;
48. no se modificó historia Git;
49. no hubo commit;
50. no hubo push;
51. el informe final de ejecución identifica todos los archivos modificados;
52. el informe final identifica TypeScript anterior y nuevo;
53. el informe final registra las verificaciones efectuadas;
54. el resultado final se declara explícitamente como `PASS`, `FAIL` o `BLOCKER`.

# 21. Pruebas/verificaciones obligatorias

La futura implementación debe efectuar como mínimo las siguientes verificaciones.

## Preflight

Comprobar:

- repositorio Git válido;
- branch;
- sincronización con `origin/main`;
- worktree limpio;
- `HEAD` inicial;
- existencia de `/docs`;
- un único lockfile;
- versiones efectivas de:
  - Next.js;
  - React;
  - TypeScript;
  - Node.js;
  - npm;
- `strict: true`.

## Verificación del cambio

Comprobar después de modificar las dependencias:

- TypeScript resuelto = `6.0.3`;
- Next.js resuelto = `16.3.1`;
- React resuelto = `19.2.8`;
- ausencia de ESLint nuevo;
- ausencia de `eslint-config-next` nuevo;
- ausencia de Vitest;
- ausencia de Prettier;
- ausencia de dependencias ajenas al cambio;
- coherencia entre `package.json` y `package-lock.json`.

## Instalación reproducible

Debe ejecutarse una instalación reproducible desde el manifest y el lockfile.

No se permite que la validación dependa de:

- `--force`;
- `--legacy-peer-deps`;
- overrides;
- estado residual de una instalación anterior que oculte una incompatibilidad.

La instalación debe finalizar sin errores de resolución incompatibles.

## Typecheck

Debe ejecutarse:

`npx tsc --noEmit`

Resultado obligatorio:

`PASS`

Debe conservarse:

`strict: true`

No puede obtenerse el PASS mediante:

- cambio de `tsconfig.json`;
- `any` deliberados;
- suppressions nuevas;
- relajación de opciones estrictas.

## Build

Debe ejecutarse:

`npm run build`

Resultado obligatorio:

`PASS`

El build debe demostrar que el downgrade de TypeScript no rompe el bootstrap existente.

## Regresión de bootstrap

Debe comprobarse que continúan preservados:

- Next.js `16.3.1`;
- React `19.2.8`;
- App Router;
- Tailwind;
- root layout;
- página técnica bootstrap;
- scripts existentes de `TASK-001`;
- ausencia de funcionalidad adicional.

## Integridad documental

Debe verificarse:

- `/docs` intacto;
- `TASK-001` intacta;
- `TASK-002` intacta;
- ningún ADR modificado;
- ninguna documentación de Fase 2+ modificada.

## Integridad Git

Al finalizar debe comprobarse:

- no commit;
- no push;
- historia sin reescritura;
- diff limitado a los archivos autorizados;
- lista explícita de archivos modificados.

# 22. Definition of Done

La implementación futura de `CORR-001` se considerará completada únicamente cuando, después de aprobación humana previa:

- TypeScript haya sido cambiado de `7.0.2` a `6.0.3`;
- únicamente `package.json` y `package-lock.json` hayan sido modificados;
- el lockfile sea coherente;
- la instalación sea reproducible;
- `npx tsc --noEmit` sea exitoso;
- `npm run build` sea exitoso;
- `strict: true` permanezca activo;
- Next.js permanezca en `16.3.1`;
- React permanezca en `19.2.8`;
- Tailwind y App Router permanezcan intactos;
- el bootstrap de `TASK-001` continúe funcional;
- `/docs` permanezca intacto;
- no exista tooling de `TASK-002` instalado;
- no exista CI;
- no exista Supabase;
- no exista schema/migration/SQL/RLS;
- no exista funcionalidad de Fase 2+;
- no exista `TASK-003`;
- no exista commit ni push;
- el informe de Codex declare `PASS`.

En su estado actual:

`APPROVED FOR IMPLEMENTATION`

la corrección **todavía no fue implementada**.

# 23. Instrucciones para Codex

Cuando `CORR-001` sea formalmente aprobada para implementación, Codex deberá cumplir estrictamente estas instrucciones:

1. Leer `CORR-001` completa antes de hacer cualquier cambio.
2. Leer íntegramente:
   - `docs/tasks/TASK-001-bootstrap-nextjs.md`;
   - `docs/tasks/TASK-002-tooling-base.md`.
3. Inspeccionar primero el repositorio real.
4. No asumir que el estado declarado sustituye la inspección.
5. Verificar las versiones reales de Next.js, React, TypeScript, Node.js y npm.
6. Verificar el package manager y el único lockfile existente.
7. Ejecutar preflight Git.
8. Confirmar branch `main`.
9. Confirmar sincronización con `origin/main`.
10. Confirmar worktree limpio.
11. Registrar `HEAD` inicial.
12. Confirmar que `TASK-001` está integrada.
13. Confirmar que `TASK-002` no está implementada parcialmente.
14. Confirmar `strict: true`.
15. Cambiar exclusivamente TypeScript desde `7.0.2` a `6.0.3`.
16. Regenerar coherentemente `package-lock.json`.
17. No cambiar Next.js.
18. No cambiar React.
19. No cambiar Tailwind.
20. No cambiar Node.js.
21. No cambiar npm.
22. No cambiar package manager.
23. No instalar ESLint.
24. No instalar `eslint-config-next`.
25. No instalar Vitest.
26. No instalar Prettier.
27. No instalar ningún otro tooling de `TASK-002`.
28. No usar `--legacy-peer-deps`.
29. No usar `--force`.
30. No introducir overrides.
31. No utilizar paquetes experimentales para conservar TypeScript 7.
32. No modificar `tsconfig.json`.
33. Si TypeScript `6.0.3` exige modificar `tsconfig.json` para conseguir typecheck/build, detenerse y reportar `BLOCKER`.
34. Preservar `strict: true`.
35. No introducir `any` deliberados.
36. No introducir suppressions.
37. Ejecutar una instalación reproducible.
38. Ejecutar `npx tsc --noEmit`.
39. Ejecutar `npm run build`.
40. Comprobar la preservación del bootstrap.
41. Comprobar App Router.
42. Comprobar React.
43. Comprobar Tailwind.
44. Comprobar `/docs`.
45. Comprobar que existe un único lockfile.
46. Revisar el diff completo.
47. Confirmar que sólo se modificaron los archivos autorizados.
48. Listar todos los archivos modificados.
49. Registrar:
    - versión anterior de TypeScript;
    - versión nueva de TypeScript;
    - versión efectiva resuelta en lockfile.
50. Registrar la evidencia de compatibilidad utilizada.
51. Informar separadamente el resultado de:
    - instalación;
    - typecheck;
    - build;
    - bootstrap;
    - integridad documental;
    - integridad Git.
52. Emitir un resultado final explícito:
    - `PASS`;
    - `FAIL`;
    - o `BLOCKER`.
53. No hacer commit.
54. No hacer push.
55. No reintentar `TASK-002` automáticamente aunque `CORR-001` obtenga `PASS`.
56. No modificar `TASK-002`.
57. No generar `TASK-003`.
58. No avanzar a ninguna otra tarea.

Codex debe devolver `BLOCKER` si descubre que satisfacer esta corrección requiere cualquiera de los siguientes cambios:

- otra versión de Next.js;
- otra versión de React;
- modificación de arquitectura;
- modificación de `tsconfig.json`;
- flags de resolución forzada;
- overrides;
- tooling experimental;
- archivos adicionales fuera de `package.json` y `package-lock.json`;
- cambios de Fase 2+.

# 24. Resultado esperado

Después de una futura implementación exitosa, el baseline técnico esperado será:

- Next.js `16.3.1`;
- React `19.2.8`;
- TypeScript `6.0.3`;
- Node.js `22.23.1`;
- npm `10.9.8`;
- `strict: true`;
- App Router preservado;
- Tailwind preservado;
- bootstrap preservado;
- un único lockfile;
- instalación reproducible;
- typecheck exitoso;
- build exitoso;
- ningún tooling de `TASK-002` todavía instalado;
- ninguna modificación funcional;
- ninguna modificación de arquitectura;
- ninguna modificación de datos o seguridad;
- Fase 1 todavía en progreso;
- Fase 2 todavía no iniciada.

El resultado de `CORR-001` no equivale a implementar `TASK-002`.

Su único propósito es eliminar el bloqueo técnico del baseline y devolver el repositorio a un estado desde el cual `TASK-002` pueda ser reconsiderada de forma limpia y soportada.

# 25. Gate posterior

Aunque la futura implementación de `CORR-001` termine con:

`PASS`

queda expresamente prohibido ejecutar automáticamente `TASK-002`.

El Gate obligatorio es:

`CORR-001 implementada con PASS`
→ `revisión humana`
→ `validación de diff, versiones, typecheck y build`
→ `aprobación explícita`
→ sólo entonces podrá autorizarse un nuevo intento limpio de `TASK-002`.

La revisión humana debe confirmar como mínimo:

- TypeScript `6.0.3`;
- ningún cambio adicional de dependencias;
- Next.js intacto;
- React intacto;
- Tailwind intacto;
- `strict: true`;
- typecheck PASS;
- build PASS;
- bootstrap preservado;
- `/docs` intacto;
- ningún tooling de `TASK-002` instalado;
- ningún cambio de Fase 2+;
- ningún commit;
- ningún push.

El Gate humano puede:

- autorizar posteriormente un nuevo intento de `TASK-002`;
- rechazar la corrección;
- solicitar una nueva especificación si aparece información técnica material nueva.

El Gate no puede convertir un `PASS` de `CORR-001` en autorización implícita para avanzar.

**Estado operativo final al aprobar documentalmente CORR-001:**

- `CORR-001`: `APPROVED FOR IMPLEMENTATION`;
- corrección implementada: no;
- TypeScript actual todavía: `7.0.2`;
- TypeScript objetivo: `6.0.3`;
- `TASK-001`: no reabierta conceptualmente;
- `TASK-002`: no modificada y no reintentada;
- ADR requerido: no;
- Codex ejecutado: no;
- repositorio modificado por esta aprobación: no;
- commit técnico: no;
- push técnico: no;
- `TASK-003`: no generada;
- Fase 1: en progreso;
- Fase 2: no iniciada;
- siguiente paso: bloqueado hasta ejecución expresamente autorizada de `CORR-001` y posterior Gate humano.
