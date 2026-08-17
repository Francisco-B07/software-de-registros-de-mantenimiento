# 1. ID

`TASK-004`

# 2. Título

`Configuración de entorno y secretos`

# 3. Fase

`Fase 1 — Setup, repositorio, CI y Supabase local`

Correspondencia dentro del orden aprobado de Fase 1:

`Paso 5 — Configuración de entorno y secretos`

Esta tarea cubre exclusivamente el contrato técnico mínimo y seguro de configuración de entorno de la aplicación.

No incluye `Paso 6 — Supabase local`, `Paso 7 — CI` ni ninguna capacidad funcional de Fase 2 o posterior.

# 4. Estado

`APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`TASK-004-environment-secrets-approved.md`

**Ruta propuesta futura:**

`docs/tasks/TASK-004-environment-secrets.md`

Este documento constituye una definición previa a implementación.

Este documento está formalmente aprobado para implementación.

Codex no ha sido ejecutado durante esta aprobación documental.

# 5. Objetivo

Establecer el contrato técnico mínimo, seguro y reversible para la configuración de entorno de la aplicación Next.js, de forma que las tareas posteriores puedan introducir variables concretas sin depender de secretos hardcodeados, sin exponer valores privados al navegador y sin permitir acceso indiscriminado a `process.env` desde cualquier parte del código.

El resultado futuro de `TASK-004` debe:

- distinguir configuración pública de configuración privada server-side;
- distinguir secreto de valor público;
- distinguir variables requeridas de variables opcionales;
- distinguir disponibilidad de build de disponibilidad de runtime;
- definir el tratamiento de archivos `.env*`;
- definir un único contrato documental versionable mediante `.env.example`;
- establecer ownership técnico claro para la lectura de variables de aplicación;
- reservar `src/infrastructure/config/` como ubicación de infraestructura común para esta responsabilidad;
- preservar las convenciones oficiales de Next.js para variables privadas y `NEXT_PUBLIC_*`;
- evitar que el prefijo público sea tratado como mecanismo de seguridad;
- impedir o reducir mediante mecanismos simples el acceso arbitrario a `process.env`;
- definir una estrategia de validación que falle explícitamente ante valores obligatorios ausentes;
- conservar TypeScript `strict: true`;
- preservar íntegramente el skeleton de `TASK-003`;
- preservar lint, typecheck, tests, build y verify;
- mantener el contrato inicial deliberadamente mínimo.

La baseline actual de esta tarea no requiere ninguna variable específica de proveedor.

Por tanto, `TASK-004` no debe anticipar variables para Supabase, OpenAI, Mercado Pago, Resend, Storage, observabilidad ni otros proveedores futuros.

Las variables específicas de cada proveedor deberán incorporarse únicamente en la tarea que introduzca legítimamente esa capacidad.

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
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`.

La definición aprobada de Fase 1 establece expresamente que el `Paso 5 — Configuración de entorno y secretos` debe cubrir:

- placeholders;
- archivos de ejemplo seguros;
- reglas para no versionar secretos;
- separación server/client cuando corresponda;
- ausencia de secretos reales;
- ausencia de integraciones productivas.

El mismo orden aprobado sitúa `Supabase local` en el Paso 6 y CI en el Paso 7. En consecuencia, ninguno de esos trabajos puede incorporarse a `TASK-004`.

`ADR-0001` exige:

- un único proyecto/aplicación Next.js;
- un único deployable principal inicial;
- separación de responsabilidades;
- integraciones y detalles técnicos detrás de fronteras internas apropiadas;
- ejecución server-side cuando una operación requiera secretos, autoridad o acceso privilegiado;
- ausencia de secretos en el navegador;
- ausencia de microservicios sin necesidad demostrada y nueva decisión aprobada.

`ADR-0002` exige, dentro de su alcance:

- tenant resolution futura autoritativa;
- RLS futura como frontera primaria de aislamiento remoto;
- frontend no autoritativo;
- uso restringido de `service-role`;
- prohibición de usar `service-role` como mecanismo ordinario para simplificar autorización;
- prohibición de exponer `service-role` al navegador.

`TASK-003` ya materializó el skeleton:

- `app/` como routing/composición;
- `src/modules/`;
- `src/shared/`;
- `src/infrastructure/`;
- aliases explícitos;
- boundaries iniciales;
- module-first;
- creación lazy;
- infraestructura común reservada a mecanismos técnicos realmente compartidos;
- prohibición de convertir `shared` en un depósito genérico.

La configuración de entorno de aplicación es una responsabilidad técnica transversal sin ownership de un bounded context funcional. Por ello su ubicación propuesta es infraestructura común.

No se detecta una contradicción material entre las fuentes obligatorias que bloquee la definición de `TASK-004`.

El estado operativo más reciente recibido para esta definición es:

- Fase 0: `COMPLETADA`;
- Gate de entrada a Fase 1: `APROBADO`;
- `TASK-001`: `DONE`;
- `CORR-001`: `DONE`;
- `TASK-002`: `DONE`;
- `TASK-003`: `DONE`;
- Next.js `16.3.1`;
- React `19.2.8`;
- TypeScript `6.0.3`;
- `strict: true`;
- Tailwind CSS `4.3.3`;
- ESLint operativo;
- Vitest operativo;
- lint operativo;
- typecheck operativo;
- tests base operativos;
- build operativo;
- verify operativo;
- skeleton modular incorporado;
- repositorio en `main`;
- `origin/main` sincronizado;
- worktree limpio;
- Fase 1 en progreso;
- Fase 2 no iniciada.

Los estados operativos anteriores prevalecen sobre declaraciones históricas dentro de especificaciones previas que describían esas tareas antes de su ejecución.

Esta tarea no modifica semánticamente `TASK-001`, `CORR-001`, `TASK-002` ni `TASK-003`.

La estrategia propuesta en `TASK-004` se clasifica como una decisión técnica local y reversible expresamente permitida por el Gate de Fase 1.

No se requiere un ADR nuevo.

# 7. Precondiciones

Antes de realizar cualquier cambio de implementación, Codex debe:

1. verificar que `TASK-004` haya sido revisada y formalmente aprobada para implementación;
2. leer íntegramente todas las fuentes obligatorias indicadas en esta tarea;
3. inspeccionar el repositorio real antes de modificar archivos;
4. repetir el preflight Git inmediatamente antes del primer cambio;
5. verificar que el repositorio sea Git válido;
6. verificar branch `main`, salvo que una decisión aprobada posterior establezca expresamente otra base;
7. verificar sincronización esperada con `origin/main`;
8. verificar worktree limpio;
9. registrar el `HEAD` inicial como evidencia de preflight;
10. verificar que `/docs` esté presente e íntegro;
11. verificar que `TASK-001`, `CORR-001`, `TASK-002` y `TASK-003` estén efectivamente incorporadas y cerradas;
12. confirmar las versiones reales de Next.js, React, TypeScript, Node.js y npm;
13. confirmar que `strict: true` continúa efectivo;
14. confirmar que `npm run lint`, `npm run typecheck`, `npm run test`, `npm run build` y `npm run verify` existen y forman parte del baseline vigente;
15. inspeccionar `package.json` y el lockfile efectivo;
16. inspeccionar `tsconfig.json`;
17. inspeccionar `eslint.config.*` o configuración equivalente vigente;
18. inspeccionar la configuración de Vitest;
19. inspeccionar la configuración de Next.js;
20. inspeccionar `.gitignore`;
21. localizar todos los archivos existentes cuyo nombre coincida con `.env*`;
22. determinar cuáles de esos archivos están trackeados por Git;
23. localizar todas las referencias actuales a `process.env`;
24. localizar todas las referencias actuales a `NEXT_PUBLIC_`;
25. inspeccionar scripts de desarrollo, test, build y verify;
26. inspeccionar el código bajo `app/`;
27. inspeccionar el código bajo `src/`;
28. inspeccionar la estructura y reglas implementadas por `TASK-003`;
29. comprobar que no exista ya una solución de configuración materialmente distinta o parcialmente implementada;
30. comprobar que no exista Supabase local, Auth, schema, migrations, SQL, RLS, CI o funcionalidad de Fase 2+ incorporada inesperadamente;
31. comprobar que no exista una dependencia de validación de entorno ya introducida de forma no documentada;
32. no asumir que el estado descrito por esta especificación sustituye la inspección del repositorio real.

Debe reportarse `BLOCKER` y detenerse la implementación si:

- el worktree no está limpio y no puede aislarse `TASK-004`;
- alguna de las tareas previas no está realmente cerrada en el baseline vigente;
- el repositorio real contradice materialmente el stack declarado;
- existe una solución previa de configuración incompatible cuya sustitución requiere una decisión arquitectónica material;
- existe un secreto real trackeado por Git;
- existe un secreto real incorporado materialmente a una superficie client-side;
- existe una credencial real en documentación versionada;
- remediar una exposición existente requiere rotar, revocar, borrar o modificar credenciales reales;
- completar `TASK-004` exige cambiar un ADR aceptado;
- completar `TASK-004` exige resolver un `DO-*` o `*-OPEN-*`;
- completar `TASK-004` exige configurar Supabase;
- completar `TASK-004` exige introducir `service-role`;
- completar `TASK-004` exige Auth, tenancy, schema, migrations, SQL o RLS;
- completar `TASK-004` exige configurar un proveedor externo;
- completar `TASK-004` exige cambiar framework o package manager;
- completar `TASK-004` exige una arquitectura material nueva;
- completar `TASK-004` exige avanzar a Fase 2 o posterior.

Un secreto real detectado no debe eliminarse, rotarse, sustituirse ni reescribirse automáticamente dentro de `TASK-004`.

El `BLOCKER` debe identificar la categoría de exposición y los archivos afectados sin copiar el valor secreto al informe.

# 8. Principios de configuración y secretos

`TASK-004` debe implementar y documentar los siguientes principios.

1. **Ningún secreto real en Git.** Los valores secretos no deben almacenarse en archivos trackeados, documentación, tests, fixtures, ejemplos ni configuración versionada.

2. **Ningún secreto real en cliente.** Un valor secreto no debe quedar accesible desde Client Components, JavaScript entregado al navegador, assets públicos ni configuración bundleada.

3. **Público es una decisión explícita.** Una variable destinada al navegador debe clasificarse deliberadamente como pública. El prefijo `NEXT_PUBLIC_` expresa exposición, no seguridad.

4. **Privado es server-side.** Una variable privada debe consumirse únicamente desde una superficie server-side autorizada.

5. **Un secreto no concede autorización.** La existencia de una variable o credencial no sustituye autenticación, autorización, tenancy, ownership ni RLS.

6. **Frontend no es autoridad.** El navegador, una ruta, un ID o un valor enviado por cliente no determina tenant ni ownership.

7. **Acceso a entorno con ownership.** `process.env` no debe convertirse en una API global informal accesible desde cualquier módulo.

8. **Contrato mínimo.** Sólo se declaran variables requeridas por una capacidad ya introducida y autorizada.

9. **Sin variables futuras preventivas.** No se agregan nombres ni placeholders de proveedores que todavía no formen parte de la tarea vigente.

10. **Separación público/privado.** Una superficie client-safe no puede reexportar configuración privada ni depender de ella.

11. **Fail explicit.** Una variable obligatoria ausente debe provocar un error técnico claro antes de propagar `undefined` silenciosamente hacia lógica posterior.

12. **Tipos honestos.** TypeScript no debe declarar como siempre existente un valor que puede faltar en runtime sin una validación real.

13. **Sin bypass de tipos.** No deben usarse casts, non-null assertions o augmentations de `ProcessEnv` únicamente para esconder ausencia de validación.

14. **Errores sin secretos.** Un mensaje de validación puede mencionar el nombre de la variable, pero no debe imprimir su valor.

15. **Build y runtime son dimensiones distintas de público/privado.** Una variable puede ser privada y, aun así, leerse durante build si el código que la consume se evalúa en build. El contrato debe declarar cuándo necesita estar disponible.

16. **Configuración no es dominio.** La capa de configuración no decide roles, permisos, tenants, ownership ni reglas funcionales.

17. **Enforcement proporcional.** Se prefieren TypeScript, Next.js y ESLint ya instalados antes de introducir nuevas dependencias o frameworks de configuración.

18. **No arquitectura ceremonial.** No se crean múltiples capas, registries, schemas o adapters si todavía no existe una variable real que los justifique.

# 9. Clasificación de configuración

Cada variable futura incorporada al contrato debe clasificarse explícitamente, como mínimo, en las siguientes dimensiones.

- **Exposición:**
  - pública;
  - privada server-side.

- **Sensibilidad:**
  - no secreta;
  - secreta.

- **Obligatoriedad:**
  - requerida;
  - opcional.

- **Momento de disponibilidad:**
  - necesaria durante build;
  - necesaria durante runtime server-side;
  - necesaria en ambos momentos.

- **Ámbito de uso:**
  - desarrollo local;
  - test;
  - producción;
  - más de un entorno cuando corresponda.

- **Ownership:**
  - infraestructura común;
  - proveedor/módulo específico cuando una tarea posterior lo introduzca.

Estas dimensiones no deben colapsarse entre sí.

En particular:

- `pública` no significa `no sensible por accidente`; debe ser deliberadamente no secreta;
- `privada` no implica automáticamente `runtime`; una lectura privada puede ocurrir durante build si se evalúa en ese momento;
- `requerida` no implica que deba existir en todos los entornos si su contrato limita el ámbito;
- `opcional` no autoriza propagar `undefined` sin que el tipo lo represente;
- `desarrollo` no significa que un secreto pueda versionarse.

La variable de framework `NODE_ENV` y otras variables gestionadas automáticamente por Next.js, Node.js o la plataforma no deben agregarse a `.env.example` ni envolverse en la configuración de aplicación salvo que exista una necesidad concreta aprobada.

# 10. Contrato de variables de entorno

El contrato técnico adoptado por `TASK-004` debe cumplir estas reglas.

1. La lista versionada de variables propias de la aplicación debe tener una única representación documental equivalente a `.env.example`.

2. La lectura de variables propias de la aplicación debe tener ownership bajo `src/infrastructure/config/`.

3. No se autoriza acceso nuevo a `process.env` desde módulos funcionales, `src/shared/` o Client Components.

4. Los accesos directos que sean estrictamente requeridos por archivos de configuración del framework o tooling deben mantenerse fuera de la abstracción sólo cuando el repositorio real los necesite y su función sea técnica, explícita y no contenga secretos bundleados.

5. El contrato no debe crear un barrel único que mezcle o reexporte configuración pública y privada.

6. Una variable pública futura debe usar la convención oficial `NEXT_PUBLIC_*` cuando realmente deba ser accesible por navegador.

7. Una variable privada no debe utilizar el prefijo `NEXT_PUBLIC_`.

8. El contrato no debe usar la opción `env` de `next.config.*` como mecanismo general para exponer valores, y nunca para secretos.

9. La aplicación no debe implementar un loader `.env` propio si el comportamiento normal de Next.js es suficiente.

10. No se añadirá `dotenv`, Zod ni otra dependencia únicamente para replicar capacidades que el baseline ya puede cubrir.

11. Para variables públicas, el contrato debe asumir que los valores `NEXT_PUBLIC_*` pueden quedar incorporados al bundle durante build. Por tanto, deben considerarse públicos desde el momento en que se clasifican con ese prefijo.

12. Para variables privadas que deban cambiar entre despliegues sin rebuild, la tarea futura que las introduzca deberá garantizar que se lean desde una ruta server-side que realmente evalúe el valor en runtime y no desde una ruta estática evaluada durante build.

13. `TASK-004` no debe forzar rendering dinámico, `connection()`, Server Actions, Route Handlers ni otra mecánica de runtime únicamente para demostrar configuración.

14. Las referencias públicas deben permanecer compatibles con el reemplazo estático que Next.js realiza sobre accesos explícitos. No debe diseñarse un acceso dinámico genérico para variables públicas que dependa de indexar `process.env` por nombre.

15. Las futuras tareas que agreguen una variable deben actualizar, en el mismo cambio:
   - su declaración documental en `.env.example`;
   - su clasificación;
   - la superficie de acceso pública o privada correspondiente;
   - la validación aplicable;
   - pruebas técnicas cuando la lógica de validación lo justifique.

16. No debe existir una segunda lista divergente de variables mantenida manualmente en otra documentación normativa.

El contrato inicial de `TASK-004` debe permanecer vacío de variables de proveedor salvo que la inspección del repositorio demuestre una variable ya requerida por el baseline técnico actual y compatible con este alcance.

# 11. Configuración pública

La configuración pública futura representa exclusivamente valores que se acepta deliberadamente exponer al navegador.

Reglas obligatorias:

- sólo puede contener valores no secretos;
- debe ser safe-to-bundle;
- debe usar `NEXT_PUBLIC_*` cuando sea consumida directamente por código de cliente conforme a las convenciones de Next.js;
- no debe importar configuración privada;
- no debe reexportar configuración privada;
- no debe importar una superficie server-only;
- no debe contener tokens, API keys privadas, passwords, service-role, secretos de webhook ni credenciales de proveedor;
- no debe utilizarse para autorización, tenancy, roles u ownership;
- no debe asumir que ocultar un nombre de variable protege su valor;
- no debe incluir variables ficticias sólo para probar la estructura;
- no debe introducir actualmente variables de Supabase, OpenAI, Mercado Pago, Resend, Storage, observabilidad u otros proveedores.

Los valores `NEXT_PUBLIC_*` deben tratarse como configuración fijada para el bundle correspondiente cuando se construye la aplicación.

Si una capacidad futura necesita configuración pública verdaderamente dinámica en runtime del navegador, esa necesidad deberá definirse en la tarea que introduzca la capacidad. `TASK-004` no inventa ahora un mecanismo de runtime public config.

Mientras no exista ninguna variable pública real, no debe crearse una API pública vacía o un objeto ficticio únicamente para demostrar la separación.

La ubicación futura preferida para una superficie pública, cuando exista contenido real que la justifique, es un entrypoint explícito dentro de `src/infrastructure/config/` que no dependa de la superficie privada.

# 12. Configuración privada

La configuración privada futura representa valores que sólo pueden utilizarse server-side.

Reglas obligatorias:

- no debe usar `NEXT_PUBLIC_*`;
- no debe importarse desde Client Components;
- no debe reexportarse desde una superficie client-safe;
- no debe exportarse mediante un barrel que también sea consumible por cliente;
- sólo debe ser accesible desde código server-side que realmente necesite la capacidad;
- debe permanecer bajo ownership técnico de `src/infrastructure/config/` para configuración común;
- una credencial específica de proveedor podrá tener un punto de acceso propio cuando la tarea de ese proveedor lo justifique, manteniendo la frontera server-side;
- una variable privada requerida debe validarse antes de que el caller reciba un valor que pueda ser `undefined`;
- los errores de validación no deben registrar el valor;
- no debe utilizarse para conceder tenant access ni sustituir verificaciones de autorización;
- no debe contener actualmente `SUPABASE_SERVICE_ROLE_KEY` ni equivalentes;
- no debe contener actualmente claves OpenAI;
- no debe contener actualmente credenciales Mercado Pago;
- no debe contener actualmente secretos de webhook;
- no debe contener actualmente credenciales de Resend u otros proveedores.

Para minimizar errores de frontera server/client se adopta una estrategia progresiva:

- separación física y nominal entre superficie pública y privada;
- ausencia de barrels mixtos;
- `process.env` restringido a la zona de configuración para código de aplicación;
- uso del mecanismo oficial de separación server-only de Next.js cuando el baseline real permita aplicarlo sin ampliar dependencias y exista una superficie privada real que proteger;
- enforcement ESLint adicional únicamente cuando pueda expresarse de forma robusta con el tooling ya instalado;
- build obligatorio como verificación de que no existen imports client/server inválidos.

Si aplicar un mecanismo específico de protección server-only exigiera una dependencia nueva no aprobada, `TASK-004` no debe añadirla automáticamente. Debe conservar la frontera mediante los mecanismos existentes y reportar la alternativa evaluada.

Mientras no exista ninguna variable privada real, no debe crearse un objeto de secretos vacío ni una credencial ficticia para demostrar esta superficie.

# 13. Archivos .env y versionado

`TASK-004` adopta una política deliberadamente conservadora.

Un archivo que contenga un secreto real:

`NUNCA DEBE VERSIONARSE`

independientemente de su nombre.

## 13.1 Siempre locales/no versionables

Los siguientes patrones deben permanecer fuera de Git:

- `.env.local`;
- `.env.development.local`;
- `.env.test.local`;
- `.env.production.local`;
- cualquier `.env*.local`;
- cualquier otro archivo `.env*` que contenga secretos o valores reales no destinados deliberadamente al versionado.

`.env.test.local` permanece estrictamente local/no versionable.

## 13.2 Archivos base sin `.local`

Para:

- `.env`;
- `.env.development`;
- `.env.test`;
- `.env.production`;

no se establece una prohibición universal de versionado.

Estos archivos pueden ser versionables únicamente si:

- contienen defaults deliberadamente no secretos y reproducibles;
- su versionado fue decidido explícitamente por la TASK que realmente necesita ese archivo;
- nunca contienen secretos;
- no se utilizan para evitar `.env.example`.

En particular, `.env.test` puede utilizarse en una tarea futura para defaults técnicos reproducibles de tests, siempre que contenga exclusivamente defaults no secretos y exista una necesidad explícitamente aprobada.

Esta posibilidad futura no amplía el alcance de `TASK-004`.

`TASK-004` no crea actualmente:

- `.env`;
- `.env.development`;
- `.env.test`;
- `.env.production`.

La expectativa actual continúa siendo utilizar únicamente `.env.example` como contrato documental.

## 13.3 Ubicación de archivos `.env*`

Todos los archivos `.env*` y `.env.example` administrados por Next.js deben ubicarse en la raíz del proyecto.

No deben colocarse dentro de:

- `src/`;
- `src/infrastructure/config/`;
- `app/`;
- ningún módulo.

`src/infrastructure/config/` contiene únicamente el código y el ownership técnico de acceso y validación de configuración.

Los archivos `.env*` permanecen en la raíz del proyecto.

## 13.4 `.gitignore`

La implementación debe inspeccionar el `.gitignore` real antes de modificarlo.

La política debe garantizar:

- `.env*.local` ignorado;
- archivos con secretos no versionados;
- `.env.example` expresamente versionable;
- no introducir una regla innecesariamente amplia que impida a una futura TASK versionar un archivo base seguro como `.env.test` si existe una necesidad legítima y explícitamente aprobada.

No debe reemplazar reglas existentes válidas ni introducir patrones que ignoren accidentalmente `.env.example`.

El único contrato de ejemplo versionable propuesto y el único contrato documental creado por `TASK-004` es:

`.env.example`

Reglas para `.env.example`:

- debe ubicarse en la raíz del proyecto;
- puede contener únicamente nombres de variables propias de la aplicación;
- puede contener placeholders inequívocamente no secretos;
- puede contener comentarios técnicos mínimos;
- no puede contener una credencial con apariencia real;
- no puede contener tokens completos o parciales;
- no puede contener passwords;
- no puede contener URLs privadas con credenciales embebidas;
- no puede contener service-role;
- no puede contener claves OpenAI;
- no puede contener credenciales Mercado Pago;
- no puede contener secretos de webhook;
- no puede contener datos reales de producción;
- no debe incluir variables de proveedores todavía no introducidos.

Cuando todavía no exista ninguna variable propia requerida por la baseline actual, `.env.example` debe expresar de forma mínima que el contrato existe pero no declarar nombres de proveedor ficticios.

Los placeholders futuros deben usar marcadores evidentemente documentales, equivalentes a:

- valor requerido configurado localmente;
- valor público deliberado;
- valor opcional;

sin simular formatos de API keys reales.

Los tests técnicos de configuración de `TASK-004` deben ser autocontenidos y no depender de credenciales reales.

La implementación no debe borrar archivos `.env*` existentes sin determinar antes si contienen valores reales y si están trackeados.

Si un archivo con secreto real está trackeado, se reporta `BLOCKER`; no se remedia automáticamente dentro de esta tarea.

# 14. Validación y tipado

La estrategia de validación propuesta utiliza TypeScript estricto y mecanismos existentes.

Dependencias nuevas propuestas por `TASK-004`:

`0`

No se propone Zod ni otra librería de validación.

La validación debe obedecer las siguientes reglas.

- Una variable requerida debe producir un error explícito si no está definida o si su valor no satisface la presencia mínima definida por su contrato.
- Una variable opcional debe conservar un tipo que represente honestamente su ausencia.
- Un valor no string futuro debe parsearse y validarse explícitamente cuando la tarea que lo introduzca defina su semántica.
- No debe asumirse que declarar `ProcessEnv` con una propiedad `string` convierte el valor en existente.
- No debe utilizarse `as string` o `!` como sustituto de validación.
- El mensaje de error debe mencionar el nombre de la variable y la naturaleza del problema, nunca el valor.
- La validación pública y privada debe mantenerse separada para evitar que una importación client-safe arrastre configuración privada.
- No debe construirse un schema de todas las variables futuras.
- No debe construirse un registry de proveedores todavía inexistentes.
- No debe crearse lógica genérica de parsing sin una necesidad actual.
- La validación debe ocurrir suficientemente cerca del punto de declaración para que el resto del código consuma un valor ya validado.

Dado que el contrato inicial no requiere variables específicas de proveedor, `TASK-004` no debe introducir valores ficticios sólo para demostrar validación.

Si la implementación descubre una variable técnica real ya necesaria para ejecutar el baseline actual, puede incorporarla únicamente si:

- pertenece realmente a Fase 1;
- no introduce un proveedor que corresponde a una tarea posterior;
- su clasificación es inequívoca;
- su ausencia puede probarse;
- no exige resolver decisiones abiertas.

Los tests técnicos de validación son opcionales cuando no exista ninguna variable real que validar.

Si se añade lógica de validación real, deben existir tests unitarios mínimos que cubran como mínimo:

- requerido presente;
- requerido ausente;
- opcional ausente cuando corresponda;
- ausencia de filtrado del valor secreto en el mensaje de error.

No se añade jsdom ni tooling de UI para estas pruebas.

# 15. Ubicación dentro del skeleton

La ubicación propuesta para el ownership de configuración común es:

`src/infrastructure/config/`

Esta ubicación es coherente con `TASK-003` porque:

- representa un mecanismo técnico transversal;
- no pertenece a un bounded context funcional;
- no contiene reglas de dominio;
- no decide autorización, tenant ni ownership;
- puede ser consumida por infraestructura o composición autorizada;
- evita crear `shared/env`;
- evita crear `shared/utils/env`;
- evita helpers genéricos sin ownership.

La estructura aprobada debe seguir siendo conceptualmente:

`app/`

`src/modules/`

`src/shared/`

`src/infrastructure/`

`TASK-004` puede crear el subdirectorio `src/infrastructure/config/` porque esta tarea introduce una responsabilidad técnica real que justifica su existencia.

No debe crear bounded contexts.

No debe mover `app/`.

No debe cambiar:

- aliases aprobados;
- boundaries vigentes salvo ajuste mínimo estrictamente necesario para proteger el nuevo contrato;
- module-first;
- creación lazy;
- reglas cross-module;
- dirección de dependencias de `TASK-003`.

No debe crearse un barrel raíz de `src/infrastructure/` que reexporte configuración privada por comodidad.

La separación pública/privada, cuando existan variables reales, debe expresarse mediante entrypoints distintos bajo `src/infrastructure/config/`.

La documentación técnica de esta responsabilidad debe integrarse preferentemente en el documento técnico existente del skeleton, si existe y puede actualizarse de forma mínima, en lugar de crear documentos redundantes.

# 16. Dentro de alcance

`TASK-004` puede realizar exclusivamente lo siguiente:

- inspeccionar el estado actual de configuración de entorno;
- inspeccionar `.gitignore`;
- inspeccionar todos los `.env*`;
- inspeccionar si esos archivos están trackeados;
- inspeccionar todas las referencias a `process.env`;
- inspeccionar referencias `NEXT_PUBLIC_*`;
- inspeccionar configuración Next.js;
- inspeccionar scripts;
- inspeccionar `app/` y `src/`;
- inspeccionar documentación técnica no normativa relacionada;
- ajustar `.gitignore` si es estrictamente necesario y sin introducir una regla excesivamente amplia que impida futuros archivos base no-locales seguros;
- crear un único `.env.example` mínimo en la raíz del proyecto;
- no crear `.env`, `.env.development`, `.env.test` ni `.env.production` durante `TASK-004`;
- crear `src/infrastructure/config/` como ownership técnico de configuración común;
- preservar el subdirectorio mediante un archivo técnico mínimo si todavía no existe código real que justifique otro archivo;
- actualizar documentación técnica mínima del skeleton para describir la responsabilidad;
- definir separación futura de superficies pública y privada;
- definir reglas de requerido/opcional;
- definir reglas build/runtime;
- definir estrategia de validación;
- introducir validación mínima únicamente si existe una variable real del baseline actual que lo requiera;
- introducir tests técnicos mínimos únicamente si existe lógica real que probar;
- ajustar ESLint de forma mínima para restringir acceso arbitrario a `process.env` cuando pueda hacerse robustamente con el tooling ya instalado;
- ajustar TypeScript únicamente si una incompatibilidad técnica real lo exige y el cambio sigue siendo local/reversible;
- preservar todos los comandos de calidad;
- ejecutar el baseline completo de verificación;
- ejecutar `git diff --check`;
- producir un informe de implementación con archivos, variables y decisiones técnicas menores.

# 17. Fuera de alcance

Queda explícitamente fuera de `TASK-004`:

- Supabase;
- Supabase CLI;
- inicialización de Supabase;
- `supabase start`;
- `supabase stop`;
- variables Supabase;
- Supabase URL;
- Supabase anon/publishable key;
- `SUPABASE_SERVICE_ROLE_KEY`;
- cualquier equivalente de service-role;
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
- seeds;
- funciones PostgreSQL;
- triggers;
- RLS;
- policies;
- autenticación;
- onboarding;
- tenancy;
- `MaintenanceCompany`;
- memberships;
- roles;
- usuarios;
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
- webhooks;
- Resend;
- email provider;
- observabilidad;
- performance tooling;
- CI;
- GitHub Actions;
- pipelines;
- deploy;
- release;
- configuración Vercel;
- E2E;
- browser automation;
- Playwright;
- Cypress;
- jsdom;
- Testing Library;
- Prettier;
- Husky;
- lint-staged;
- commitlint;
- secret manager externo;
- vault externo;
- nuevas aplicaciones;
- monorepo;
- microservicios;
- nuevas variables de proveedor “por si acaso”;
- resolución de `DO-*`;
- resolución de `*-OPEN-*`;
- ADR nuevos;
- Fase 2+;
- `TASK-005`.

No debe introducirse ningún secreto real.

# 18. Archivos/categorías de archivos esperados

La implementación futura debe limitar los cambios a las categorías siguientes, y sólo cuando la inspección real los justifique.

**Esperados como creación o modificación probable:**

- `.env.example` en la raíz del proyecto;
- `.gitignore`, sólo si las reglas existentes son insuficientes y sin impedir innecesariamente futuros archivos base no-locales seguros;
- `src/infrastructure/config/` como nueva zona de ownership técnico;
- el archivo técnico mínimo necesario para preservar/documentar esa zona mientras no existan variables reales;
- documentación técnica no normativa ya existente bajo `src/`, preferentemente mediante actualización mínima en lugar de documento nuevo;
- `eslint.config.*` o equivalente, sólo si es necesario y posible para restringir acceso arbitrario a `process.env` con las capacidades ya instaladas;
- tests unitarios técnicos de configuración, sólo si se introduce lógica real de validación.

**Sólo si existe una necesidad técnica real descubierta:**

- `tsconfig.json`;
- configuración de Vitest;
- configuración Next.js.

**No esperados:**

- `.env`;
- `.env.development`;
- `.env.test`;
- `.env.production`;
- cualquier `.env*.local` versionado;
- `package.json`;
- lockfile;
- nuevas dependencias.

Si `package.json` o el lockfile necesitan cambios para completar `TASK-004`, Codex debe evaluar si la necesidad está dentro del alcance. La expectativa es no modificarlos.

Una dependencia nueva no queda autorizada por esta especificación.

# 19. Restricciones de implementación

La futura implementación debe cumplir todas las siguientes restricciones.

1. No instalar dependencias nuevas por defecto.
2. No instalar Zod.
3. No instalar `dotenv`.
4. No instalar un framework de configuración.
5. No instalar secret scanners como parte de esta tarea.
6. No cambiar package manager.
7. No cambiar Next.js.
8. No cambiar React.
9. No cambiar TypeScript salvo `BLOCKER` técnico real; no se autoriza una actualización por preferencia.
10. Mantener `strict: true`.
11. No cambiar Tailwind.
12. No mover `app/`.
13. No crear módulos funcionales.
14. No crear `shared/env`.
15. No crear `shared/utils/env`.
16. No crear `shared/helpers/env`.
17. No crear un barrel que mezcle configuración pública y privada.
18. No añadir variables de proveedores futuros.
19. No añadir credenciales ficticias con apariencia real.
20. No añadir secretos reales.
21. No introducir `service-role`.
22. No introducir una variable env como sustituto de autorización.
23. No introducir tenant IDs como configuración autoritativa.
24. No configurar Supabase.
25. No configurar CI.
26. No configurar Vercel.
27. No crear schema, migrations, SQL ni RLS.
28. No crear Auth.
29. No resolver decisiones abiertas.
30. No crear ADR.
31. No introducir código de producto.
32. No implementar Fase 2+.
33. No ejecutar `git init`.
34. No reescribir historia.
35. No crear commits.
36. No hacer push.
37. No generar `TASK-005`.
38. No modificar `/docs` durante la implementación de la tarea salvo que la tarea aprobada posterior cambie expresamente esa restricción; la documentación técnica de setup debe permanecer fuera de la documentación normativa.
39. Preservar `TASK-001`, `CORR-001`, `TASK-002` y `TASK-003`.
40. Preservar aliases y boundaries de `TASK-003` salvo ajuste mínimo explícitamente necesario y compatible.
41. Preservar lint, typecheck, test, build y verify.
42. No alterar la página bootstrap salvo necesidad técnica estricta demostrada.
43. No introducir configuración ficticia de producto para demostrar el contrato.

Si una protección ESLint contra `process.env` no puede expresarse de forma robusta con el tooling actual sin falsos positivos materiales o nueva dependencia, no debe implementarse una regla frágil. Debe documentarse la limitación en el informe y conservarse el contrato de ownership por estructura y revisión.

# 20. Seguridad

Impacto de seguridad:

`APLICA — configuración y manejo de secretos, sin implementar autorización ni datos de dominio`

Invariantes obligatorios:

- secretos reales jamás en Git;
- secretos reales jamás en documentación;
- secretos privados jamás en client bundle;
- configuración pública deliberadamente safe-to-bundle;
- `NEXT_PUBLIC_*` nunca utilizado para secretos;
- `service-role` fuera de alcance;
- frontend no autoritativo;
- variables env no conceden tenant access;
- IDs, paths o query params no conceden ownership;
- ninguna configuración sustituye autenticación o autorización;
- errores de configuración no imprimen valores secretos;
- tests no incluyen secretos reales;
- `.env.example` no incluye valores reales y permanece en la raíz del proyecto;
- `.env*.local` permanece fuera de Git;
- cualquier archivo `.env*` con secretos o valores reales no destinados deliberadamente al versionado permanece fuera de Git;
- un secreto ya expuesto se trata como `BLOCKER`, no como limpieza automática;
- la configuración privada no se expone desde una superficie client-safe;
- no se crea un mecanismo general que permita a un Client Component obtener cualquier variable por nombre.

`SUPABASE_SERVICE_ROLE_KEY` o cualquier equivalente está expresamente:

`FUERA DE ALCANCE`

La tarea no debe crearla, documentarla como requerida, generar un placeholder para ella ni introducirla en tests.

# 21. Impacto de datos / migrations

`NO APLICA TODAVÍA — configuración técnica únicamente`

`TASK-004` no crea ni modifica:

- schema de producto;
- migrations;
- SQL;
- tablas;
- columnas;
- PK/FK;
- índices;
- constraints;
- seeds;
- triggers;
- funciones PostgreSQL;
- buckets;
- paths de Storage;
- datos tenant;
- datos globales de plataforma.

No existe transformación ni migración de datos.

No existe persistencia de dominio.

# 22. Impacto RLS

`NO APLICA TODAVÍA — no existe schema de producto`

`TASK-004` no crea ni modifica políticas RLS.

No crea funciones auxiliares de autorización.

No introduce bypass RLS.

No introduce `service-role`.

La tarea debe preservar conceptualmente que RLS será la frontera primaria de aislamiento remoto cuando el schema exista, pero no debe diseñar ni anticipar ninguna policy.

# 23. Criterios de aceptación

`TASK-004` se considera aceptable para cierre de implementación únicamente si se cumplen todos los criterios siguientes.

1. El preflight se realizó sobre un worktree limpio.
2. Se registró el `HEAD` inicial.
3. Se verificó branch/base y upstream.
4. Se inspeccionó `.gitignore`.
5. Se localizaron todos los `.env*` existentes.
6. Se determinó cuáles de esos archivos están trackeados.
7. Se inspeccionaron todas las referencias a `process.env`.
8. Se inspeccionaron todas las referencias `NEXT_PUBLIC_*`.
9. Se inspeccionó configuración Next.js.
10. Se inspeccionaron scripts.
11. Se inspeccionó `app/`.
12. Se inspeccionó `src/`.
13. No se detectó un secreto real trackeado; o, si se detectó, la implementación se detuvo con `BLOCKER`.
14. No se copió ningún valor secreto al informe.
15. `.env.example` es el único contrato documental creado por `TASK-004`, se ubica en la raíz del proyecto y no contiene secretos reales, credenciales ficticias con apariencia real ni variables de proveedores futuros no introducidos.
16. `.env*.local`, incluido `.env.test.local`, permanece fuera de Git; cualquier archivo `.env*` que contenga secretos o valores reales no destinados deliberadamente al versionado permanece igualmente fuera de Git.
17. `TASK-004` no crea `.env`, `.env.development`, `.env.test` ni `.env.production`.
18. Los archivos base no-locales no quedan prohibidos universalmente para tareas futuras: `.env.test` u otro archivo base sólo podrá ser reproducible/versionable si contiene exclusivamente defaults no secretos y existe una necesidad legítima y explícitamente aprobada; todos los `.env*` administrados por Next.js deben ubicarse en la raíz del proyecto.
19. Las reglas de ignore protegen `.env*.local` y archivos con secretos, mantienen `.env.example` expresamente versionable y no introducen una regla innecesariamente amplia que impida futuros archivos base no-locales seguros.
20. El ownership de configuración común queda definido bajo `src/infrastructure/config/`.
21. No existe `shared/env`.
22. No existe `shared/utils/env`.
23. No existe un helper genérico de entorno sin ownership.
24. La separación pública/privada está explícitamente definida.
25. La configuración pública futura queda limitada a valores deliberadamente públicos.
26. La configuración privada futura queda limitada a server-side.
27. No existe barrel mixto público/privado.
28. El acceso nuevo a `process.env` desde código de aplicación queda centralizado o restringido conforme al contrato.
29. Si se añadió enforcement ESLint, usa sólo tooling existente y no rompe boundaries previos.
30. Si no se añadió enforcement ESLint, existe justificación técnica concreta en el informe.
31. La estrategia de requerido/opcional está definida.
32. La estrategia build/runtime está definida.
33. La estrategia de validación está definida.
34. No se utilizan casts o augmentations para simular validación.
35. No se añadió ninguna dependencia de validación.
36. No se añadió ninguna dependencia nueva salvo decisión posterior expresamente aprobada; expectativa de esta tarea: cero.
37. `SUPABASE_SERVICE_ROLE_KEY` no existe como variable declarada por la tarea.
38. No se introdujeron variables Supabase.
39. No se introdujeron variables OpenAI.
40. No se introdujeron variables Mercado Pago.
41. No se introdujeron variables Resend.
42. No se introdujeron variables de observabilidad.
43. No se configuró Supabase.
44. No se implementó Auth.
45. No se implementó tenancy.
46. No se creó schema.
47. No se creó migration.
48. No se añadió SQL.
49. No se creó RLS.
50. No se configuró CI.
51. No se implementó Fase 2+.
52. `app/` permanece en su ubicación.
53. `src/modules/`, `src/shared/` y `src/infrastructure/` permanecen coherentes con `TASK-003`.
54. Los aliases de `TASK-003` se preservaron.
55. Los boundaries de `TASK-003` se preservaron o sólo recibieron un ajuste mínimo explícitamente justificado.
56. `strict: true` permanece efectivo.
57. `npm run lint` finaliza `PASS`.
58. `npm run typecheck` finaliza `PASS`.
59. `npm run test` finaliza `PASS`.
60. `npm run build` finaliza `PASS`.
61. `npm run verify` finaliza `PASS`.
62. `git diff --check` finaliza `PASS`.
63. `/docs` permanece intacto.
64. No se creó commit.
65. No se hizo push.
66. No se generó `TASK-005`.

# 24. Pruebas/verificaciones obligatorias

La implementación debe ejecutar y registrar como mínimo las siguientes verificaciones.

**Preflight Git:**

- repositorio Git válido;
- branch esperado;
- upstream esperado;
- worktree limpio;
- `HEAD` inicial registrado.

**Inspección de secretos/configuración:**

- listado de `.env*`;
- estado trackeado/no trackeado de cada archivo encontrado;
- revisión de `.gitignore`;
- búsqueda de `process.env`;
- búsqueda de `NEXT_PUBLIC_`;
- revisión de configuración Next.js;
- revisión de scripts;
- revisión de `app/`;
- revisión de `src/`;
- revisión de documentación técnica relacionada.

**Contrato de archivos:**

- `.env.example` puede versionarse, es el único contrato documental creado por `TASK-004` y se ubica en la raíz del proyecto;
- `.env*.local`, incluido `.env.test.local`, permanece fuera de Git;
- cualquier archivo `.env*` con secretos o valores reales no destinados deliberadamente al versionado permanece fuera de Git;
- `TASK-004` no crea `.env`, `.env.development`, `.env.test` ni `.env.production`;
- la política no impide que una tarea futura, con necesidad explícitamente aprobada, versione `.env.test` u otro archivo base no-local si contiene exclusivamente defaults reproducibles no secretos;
- todos los archivos `.env*` administrados por Next.js se ubican en la raíz del proyecto;
- `.gitignore` no contiene una regla innecesariamente amplia que contradiga esta política;
- `.env.example` no contiene valores reales;
- no aparece `SUPABASE_SERVICE_ROLE_KEY`;
- no aparecen claves OpenAI;
- no aparecen credenciales Mercado Pago;
- no aparecen secretos de webhook;
- no aparecen variables de proveedores no introducidos.

**Frontera de acceso:**

- no existen nuevos accesos arbitrarios a `process.env` fuera de las excepciones técnicas autorizadas;
- no existe configuración privada reexportada hacia superficies client-safe;
- no existe un barrel mixto;
- no existe `shared/env` ni equivalentes prohibidos;
- si existe configuración privada real, el build debe demostrar que no puede arrastrarse a cliente mediante una importación inválida conforme a los mecanismos del baseline;
- si no existe configuración privada real, no se crea una credencial ficticia para probar esta propiedad.

**Validación:**

Si se introduce lógica real de validación, tests unitarios mínimos deben demostrar:

- required presente;
- required ausente;
- optional ausente cuando corresponda;
- mensaje de error sin valor secreto.

Si no existe ninguna variable real y no se introduce lógica de validación, no se agregan tests vacíos o ficticios.

**Baseline obligatorio:**

- `npm run lint`;
- `npm run typecheck`;
- `npm run test`;
- `npm run build`;
- `npm run verify`;
- `git diff --check`.

Todas las verificaciones deben reportarse como `PASS`, `FAIL` o `BLOCKER`.

Un `FAIL` no debe ocultarse mediante deshabilitación de reglas, casts, ignores o reducción del baseline.

# 25. Definition of Done

`TASK-004` está `DONE` únicamente cuando:

- fue aprobada formalmente antes de implementación;
- Codex ejecutó exclusivamente el alcance autorizado;
- el preflight fue válido;
- no existe un `BLOCKER` pendiente;
- la política de archivos `.env*` está establecida;
- `.env.example` constituye el único contrato documental creado por `TASK-004` y se ubica en la raíz del proyecto;
- `.env*.local` y cualquier `.env*` con secretos permanecen fuera de Git;
- `TASK-004` no crea `.env`, `.env.development`, `.env.test` ni `.env.production`;
- la política no prohíbe universalmente futuros archivos base no-locales seguros cuando exista una necesidad explícitamente aprobada;
- no contiene secretos ni proveedores anticipados;
- el ownership técnico de configuración está establecido bajo `src/infrastructure/config/`;
- la separación pública/privada está establecida;
- la clasificación requerido/opcional está establecida;
- la clasificación build/runtime está establecida;
- la estrategia de validación está establecida;
- el acceso a `process.env` queda centralizado/restringido conforme a los mecanismos permitidos;
- no se añadió `service-role`;
- no se añadieron secretos;
- no se añadieron variables Supabase/OpenAI/Mercado Pago/Resend/observabilidad;
- no se añadió una dependencia nueva;
- el skeleton modular permanece coherente;
- TypeScript strict permanece efectivo;
- lint pasa;
- typecheck pasa;
- tests pasan;
- build pasa;
- verify pasa;
- `git diff --check` pasa;
- `/docs` permanece intacto;
- no existe schema/migration/SQL/RLS;
- no existe Auth/tenancy;
- no existe Supabase local;
- no existe CI;
- no existe Fase 2+;
- no se creó commit;
- no se hizo push;
- no se generó `TASK-005`;
- el informe final de Codex enumera exactamente los archivos creados/modificados y las variables declaradas.

El estado documental aprobado para implementación es:

`APPROVED FOR IMPLEMENTATION`

La aprobación documental ya fue otorgada; la ejecución de Codex permanece como un paso posterior separado.

# 26. Instrucciones para Codex

Con `TASK-004` formalmente aprobada, Codex deberá:

1. leer íntegramente todas las fuentes obligatorias;
2. inspeccionar el repositorio antes de proponer cambios;
3. repetir el preflight inmediatamente antes del primer cambio;
4. verificar worktree limpio;
5. registrar `HEAD` inicial;
6. inspeccionar `.gitignore`;
7. localizar todos los `.env*`;
8. determinar qué `.env*` están trackeados;
9. localizar todas las referencias a `process.env`;
10. localizar todas las referencias `NEXT_PUBLIC_*`;
11. inspeccionar configuración Next.js;
12. inspeccionar scripts;
13. inspeccionar `app/`;
14. inspeccionar `src/`;
15. detectar posibles secretos versionados sin copiar sus valores al output;
16. detenerse con `BLOCKER` si existe un secreto real cuya remediación requiera trabajo fuera del alcance;
17. no borrar ni rotar secretos reales;
18. preservar `TASK-001`;
19. preservar `CORR-001`;
20. preservar `TASK-002`;
21. preservar `TASK-003`;
22. preservar `/docs`;
23. preservar el skeleton modular;
24. preservar aliases;
25. preservar boundaries;
26. preservar module-first;
27. preservar creación lazy;
28. preservar reglas cross-module;
29. preservar `app/` como routing/composición;
30. preservar TypeScript strict;
31. implementar únicamente configuración de entorno y secretos;
32. establecer el ownership técnico bajo `src/infrastructure/config/`;
33. no crear bounded contexts;
34. no crear `shared/env`;
35. no crear helpers genéricos sin ownership;
36. ajustar `.gitignore` sólo si es necesario, garantizando `.env*.local` ignorado, archivos con secretos fuera de Git, `.env.example` versionable y ausencia de una regla excesivamente amplia que impida futuros archivos base no-locales seguros;
37. crear un `.env.example` mínimo y seguro en la raíz del proyecto; mantener todos los `.env*` administrados por Next.js en la raíz; no colocar archivos `.env*` dentro de `src/`, `src/infrastructure/config/`, `app/` ni módulos; y no crear `.env`, `.env.development`, `.env.test` ni `.env.production` durante `TASK-004`;
38. no añadir variables futuras “por si acaso”;
39. no añadir placeholders Supabase;
40. no añadir placeholders OpenAI;
41. no añadir placeholders Mercado Pago;
42. no añadir placeholders Resend;
43. no añadir placeholders de observabilidad;
44. no introducir `service-role`;
45. no configurar Supabase;
46. no implementar Auth;
47. no implementar tenancy;
48. no crear schema;
49. no crear migrations;
50. no añadir SQL;
51. no crear RLS;
52. no configurar CI;
53. no implementar Fase 2+;
54. no añadir secretos reales;
55. no añadir una dependencia nueva sin autorización expresa;
56. no instalar Zod por preferencia;
57. no instalar `dotenv` por preferencia;
58. usar TypeScript y mecanismos existentes cuando sean suficientes;
59. no crear una API pública vacía o un objeto de secretos ficticio para demostrar arquitectura;
60. aplicar enforcement ESLint contra acceso arbitrario a `process.env` sólo si puede expresarse robustamente con el tooling actual;
61. no degradar reglas existentes para hacer pasar lint;
62. añadir tests técnicos sólo si existe lógica real que probar;
63. ejecutar `npm run lint`;
64. ejecutar `npm run typecheck`;
65. ejecutar `npm run test`;
66. ejecutar `npm run build`;
67. ejecutar `npm run verify`;
68. ejecutar `git diff --check`;
69. registrar archivos creados;
70. registrar archivos modificados;
71. registrar variables declaradas;
72. registrar para cada variable su clasificación pública/privada;
73. registrar para cada variable si es secreta/no secreta;
74. registrar para cada variable si es requerida/opcional;
75. registrar para cada variable si es build/runtime;
76. registrar cualquier decisión técnica menor;
77. registrar cualquier limitación de enforcement;
78. informar el resultado global como `PASS`, `FAIL` o `BLOCKER`;
79. no ejecutar `git init`;
80. no reescribir historia;
81. no commit;
82. no push;
83. no generar `TASK-005`.

El informe final de Codex debe contener como mínimo:

- `HEAD` inicial;
- branch/upstream;
- estado inicial del worktree;
- archivos creados;
- archivos modificados;
- `.env*` encontrados y su condición trackeada/no trackeada, sin valores;
- referencias a `process.env` encontradas y tratamiento aplicado;
- variables finalmente declaradas;
- clasificación pública/privada de cada variable;
- clasificación requerida/opcional de cada variable;
- clasificación build/runtime de cada variable;
- dependencias añadidas;
- confirmación de ausencia de secretos reales añadidos;
- confirmación de ausencia de `service-role`;
- confirmación de ausencia de Supabase;
- confirmación de ausencia de Auth/tenancy/schema/RLS;
- resultado de lint;
- resultado de typecheck;
- resultado de test;
- resultado de build;
- resultado de verify;
- resultado de `git diff --check`;
- resultado global `PASS`, `FAIL` o `BLOCKER`.

# 27. Resultado esperado

Al completar correctamente `TASK-004`, el repositorio debe conservar el baseline previo y añadir únicamente una frontera técnica mínima para configuración de entorno.

El estado esperado es:

- Next.js existente preservado;
- React existente preservado;
- TypeScript `6.0.3` preservado salvo corrección técnica posterior expresamente aprobada;
- `strict: true` preservado;
- Tailwind existente preservado;
- ESLint preservado;
- Vitest preservado;
- lint operativo;
- typecheck operativo;
- tests base operativos;
- build operativo;
- verify operativo;
- `app/` preservado;
- `src/modules/` preservado;
- `src/shared/` preservado;
- `src/infrastructure/` preservado;
- `src/infrastructure/config/` establecido como ownership de configuración común;
- aliases preservados;
- boundaries preservados;
- `.env.example` mínimo, seguro, ubicado en la raíz del proyecto y único contrato documental creado por `TASK-004`;
- `.env*.local` y cualquier `.env*` con secretos fuera de Git;
- `.env`, `.env.development`, `.env.test` y `.env.production` no creados por `TASK-004`;
- archivos base no-locales no prohibidos universalmente para futuras tareas cuando contengan únicamente defaults reproducibles no secretos y exista una necesidad aprobada;
- todos los `.env*` administrados por Next.js ubicados en la raíz del proyecto;
- contrato público/privado explícito;
- contrato requerido/opcional explícito;
- contrato build/runtime explícito;
- estrategia de validación explícita;
- acceso a `process.env` no indiscriminado;
- cero dependencias nuevas como resultado esperado;
- cero variables de proveedor anticipadas como resultado esperado;
- cero secretos reales añadidos;
- cero `service-role`;
- cero Supabase;
- cero Auth;
- cero tenancy;
- cero schema;
- cero migrations;
- cero SQL;
- cero RLS;
- cero CI;
- cero Fase 2+;
- cero bounded contexts nuevos.

El propósito es que `TASK-005` o cualquier tarea posterior legítima pueda introducir una variable concreta dentro de un contrato ya seguro, sin tener que decidir nuevamente dónde vive la configuración ni permitir accesos arbitrarios a `process.env`.

`TASK-004` no autoriza por sí misma ninguna variable de proveedor futuro.

# 28. Gate posterior

Antes de cerrar `TASK-004` debe revisarse formalmente la implementación y comprobarse:

- arquitectura coherente con `ADR-0001`;
- coherencia con `ADR-0002`;
- coherencia con `TASK-003`;
- ninguna ampliación de alcance;
- ningún secreto real añadido;
- ningún secreto real expuesto a cliente;
- ningún secreto real versionado;
- `.env.example` seguro y ubicado en la raíz del proyecto;
- `.env*.local` ignorados;
- ningún `.env`, `.env.development`, `.env.test` ni `.env.production` creado por `TASK-004`;
- ninguna regla de `.gitignore` excesivamente amplia que impida innecesariamente futuros archivos base no-locales seguros;
- todos los `.env*` administrados por Next.js ubicados en la raíz del proyecto;
- no existen variables futuras innecesarias;
- `service-role` ausente;
- separación pública/privada correcta;
- required/optional definido;
- build/runtime definido;
- ownership bajo infraestructura común;
- ningún `shared/env`;
- ningún bounded context nuevo;
- TypeScript strict preservado;
- tooling de `TASK-002` preservado;
- aliases preservados;
- boundaries preservados;
- `app/` no movido;
- no existe Supabase;
- no existe Auth;
- no existe tenancy;
- no existe schema;
- no existen migrations;
- no existe SQL;
- no existe RLS;
- no existe CI;
- no existe Fase 2+;
- no se resolvió ningún `DO-*`;
- no se resolvió ningún `*-OPEN-*`;
- no se requirió ADR nuevo;
- lint `PASS`;
- typecheck `PASS`;
- test `PASS`;
- build `PASS`;
- verify `PASS`;
- `git diff --check` `PASS`;
- `/docs` intacto;
- no commit;
- no push;
- `TASK-005` no generada.

Si la implementación cumple el Gate, `TASK-004` puede cerrarse documentalmente como `DONE` mediante un paso de revisión separado.

El paso normativo siguiente dentro de Fase 1 es:

`Paso 6 — Supabase local`

pero este Gate:

- no define `TASK-005`;
- no autoriza `TASK-005`;
- no configura Supabase;
- no ejecuta Codex para el siguiente paso;
- no avanza automáticamente.

Estado actual de esta definición:

`APPROVED FOR IMPLEMENTATION`
