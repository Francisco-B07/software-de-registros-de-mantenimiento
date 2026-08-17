# 1. ID

`TASK-003`

# 2. Título

`Skeleton modular mínimo del monolito Next.js`

# 3. Fase

`Fase 1 — Setup, repositorio, CI y Supabase local`

Correspondencia dentro del orden aprobado de Fase 1:

`Paso 4 — Skeleton modular`

Esta tarea cubre exclusivamente la materialización física mínima de las fronteras internas aprobadas por `ADR-0001`.

No incluye configuración de entorno/secretos, Supabase local, CI ni ninguna capacidad funcional de Fase 2 o posterior.

# 4. Estado

`APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`TASK-003-modular-skeleton-approved.md`

**Ruta normativa futura:**

`docs/tasks/TASK-003-modular-skeleton.md`

Este documento queda formalmente aprobado para implementación.

Su incorporación canónica futura corresponde a la ruta normativa indicada.

Codex no ha sido ejecutado durante esta aprobación documental.

# 5. Objetivo

Establecer la estructura física mínima y reversible del monolito modular Next.js para que las futuras capacidades puedan incorporarse dentro de fronteras internas claras, sin implementar todavía ningún bounded context funcional, modelo de dominio ni infraestructura de producto.

El resultado futuro de `TASK-003` debe:

- preservar una única aplicación Next.js y un único deployable principal;
- mantener `app/` como frontera de routing y composición de Next.js;
- reservar una ubicación explícita para módulos internos futuros;
- separar código transversal real de código perteneciente a un módulo;
- separar infraestructura común técnica de la infraestructura específica de un módulo;
- definir una convención mínima de imports;
- introducir enforcement mínimo de boundaries mediante tooling ya disponible;
- mantener TypeScript `strict: true`;
- preservar íntegramente el tooling y los comandos establecidos por `TASK-002`;
- no crear todavía ningún bounded context funcional;
- no anticipar Fase 2.

`TASK-003` no debe introducir clases, entidades, value objects, repositories, services, use cases, modelos de persistencia ni contratos de producto ficticios sólo para demostrar arquitectura.

# 6. Contexto normativo

Esta tarea se encuentra restringida por las siguientes fuentes obligatorias:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`;
- `docs/tasks/TASK-001-bootstrap-nextjs.md`;
- `docs/tasks/TASK-002-tooling-base.md`;
- `docs/tasks/CORR-001-typescript-tooling-compatibility.md`;
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
- `ADR-0002 — Multi-tenancy, tenant ownership y aislamiento`.

La ruta normativa declarada por el ADR aprobado de multi-tenancy es:

`docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`

El encargo de `TASK-003` también menciona la forma abreviada:

`docs/architecture/adr/ADR-0002-tenant-isolation.md`

Esta diferencia nominal no cambia el ID, título ni decisión arquitectónica de `ADR-0002` y no bloquea la definición de `TASK-003`. Durante la implementación futura Codex debe inspeccionar el repositorio y consumir la ruta canónica realmente presente sin renombrar ni modificar documentación como parte de esta tarea. Si el ADR no puede localizarse de forma inequívoca por `ADR-0002` y su título aprobado, deberá reportarse `BLOCKER` en lugar de corregir rutas documentales dentro de `TASK-003`.

## Baseline arquitectónica consumida

Se preservan las siguientes decisiones aprobadas:

- una sola aplicación/proyecto Next.js;
- un único deployable principal inicial;
- arquitectura de monolito modular;
- App Router;
- TypeScript estricto;
- separación conceptual entre Presentation/UI, Application/use cases, Domain/business rules e Infrastructure/external adapters;
- las capas conceptuales no obligan a cuatro directorios físicos rígidos;
- dependencias internas explícitas y comprensibles;
- prevención de imports arbitrarios y dependencias circulares;
- integraciones externas detrás de fronteras internas apropiadas;
- ausencia de microservicios sin necesidad técnica demostrada y nueva decisión arquitectónica;
- PostgreSQL/Supabase como futura fuente de verdad remota;
- tenant resolution futura autoritativa;
- RLS futura obligatoria como frontera primaria de aislamiento remoto;
- frontend, rutas, IDs y estado de UI no son autoridad de tenancy.

## Baseline de Fase 1 consumida

`docs/product/11-phase-1-scope-entry-gate.md` permite en Fase 1 decisiones físicas locales y reversibles sobre:

- organización inicial de carpetas;
- convenciones de módulos;
- configuración TypeScript;
- configuración lint/build/test;
- documentación mínima del skeleton.

El mismo Gate exige que el skeleton sea mínimo y pragmático y prohíbe convertir `ADR-0001` en una taxonomía rígida o anticipar capacidades de fases posteriores.

## Estado operativo recibido para esta definición

Se toma como estado operativo más reciente:

- Fase 0: `COMPLETADA`;
- Gate de entrada a Fase 1: `APROBADO`;
- `TASK-001`: `DONE`;
- `CORR-001`: `DONE`;
- `TASK-002`: `DONE`;
- Next.js `16.3.1`;
- React `19.2.8`;
- TypeScript `6.0.3`;
- `strict: true`;
- Tailwind CSS `4.3.3`;
- ESLint operativo;
- Vitest operativo;
- lint, typecheck, tests base, build y verify operativos;
- package manager efectivo: `npm`;
- repositorio en `main`;
- `origin/main` sincronizado;
- worktree limpio;
- Fase 1 en progreso;
- Fase 2 no iniciada.

Los estados operativos anteriores prevalecen sobre declaraciones históricas incluidas en especificaciones previas que describían `TASK-001`, `CORR-001` o `TASK-002` antes de su ejecución.

No se detecta una contradicción arquitectónica material que bloquee la definición de `TASK-003`.

La estructura física y las reglas de imports propuestas en esta tarea son decisiones técnicas locales y reversibles expresamente permitidas por Fase 1. No requieren un ADR nuevo.

# 7. Precondiciones

Antes de realizar cualquier cambio de implementación, Codex debe:

1. verificar que `TASK-003` haya sido revisada y formalmente autorizada para implementación;
2. leer íntegramente todas las fuentes obligatorias indicadas en esta tarea;
3. inspeccionar el repositorio real antes de modificar archivos;
4. repetir el preflight Git inmediatamente antes del primer cambio;
5. verificar que el repositorio sea Git válido;
6. verificar branch `main`, salvo que una decisión aprobada posterior establezca expresamente otra base;
7. verificar sincronización esperada con `origin/main`;
8. verificar worktree limpio;
9. registrar el `HEAD` inicial como evidencia de preflight;
10. verificar que `/docs` esté presente e íntegro;
11. verificar que `TASK-001`, `CORR-001` y `TASK-002` estén efectivamente incorporadas y cerradas;
12. inspeccionar como mínimo:
    - `package.json`;
    - `package-lock.json`;
    - `tsconfig.json`;
    - `eslint.config.*` o configuración equivalente vigente;
    - configuración de Vitest;
    - scripts actuales;
    - estructura actual de `app/`;
    - estructura actual de `src/`, si ya existe;
    - aliases existentes;
    - tests existentes;
13. confirmar las versiones reales de Next.js, React y TypeScript;
14. confirmar `strict: true` efectivo;
15. confirmar que `npm run lint`, `npm run typecheck`, `npm run test`, `npm run build` y `npm run verify` existen y forman parte del baseline vigente;
16. comprobar si existe ya una estructura modular parcial no documentada;
17. comprobar si existen aliases o reglas de imports que puedan entrar en conflicto con la propuesta;
18. comprobar que no exista funcionalidad de Fase 2+ incorporada inesperadamente;
19. preservar la página bootstrap actual salvo necesidad técnica mínima demostrada;
20. no asumir que la estructura física real coincide con ejemplos de esta especificación sin inspeccionarla primero.

Debe reportarse `BLOCKER` y detenerse la implementación si:

- el worktree no está limpio y no puede aislarse `TASK-003`;
- `TASK-001`, `CORR-001` o `TASK-002` no están realmente cerradas en el baseline vigente;
- el repositorio real contradice materialmente el stack declarado;
- existe una estructura modular previa incompatible cuya sustitución requiera una decisión arquitectónica material;
- completar el skeleton exige cambiar `ADR-0001`;
- completar el skeleton exige resolver un `DO-*` o `*-OPEN-*`;
- completar el skeleton exige cambiar framework o package manager;
- completar el skeleton exige crear múltiples aplicaciones, monorepo o microservicios;
- completar el skeleton exige introducir tooling pesado adicional;
- completar el skeleton exige implementar dominio;
- completar el skeleton exige Supabase, Auth, schema, migrations, SQL o RLS;
- completar el skeleton exige avanzar a Fase 2+;
- el ADR `ADR-0002` no puede localizarse inequívocamente en el repositorio sin una corrección documental fuera de alcance.

Las decisiones locales y reversibles sobre nombres de carpetas, aliases y configuración mínima de ESLint/TypeScript no constituyen `BLOCKER` por sí mismas y no requieren ADR.

# 8. Principios del skeleton

El skeleton debe cumplir simultáneamente los siguientes principios.

## 8.1 Module-first, no layer-first global

Los futuros bounded contexts deben agruparse primariamente por módulo/capacidad y no repartirse globalmente entre grandes carpetas `domain/`, `application/`, `infrastructure/` y `presentation/` para toda la aplicación.

La separación conceptual de capas de `ADR-0001` se materializará dentro de cada módulo únicamente cuando ese módulo y esas responsabilidades existan realmente.

Esto evita dispersar una misma capacidad entre carpetas globales y mantiene cohesión por módulo.

## 8.2 Creación lazy de módulos y capas

`TASK-003` no crea carpetas de bounded contexts futuros.

Cuando una tarea posterior implemente un módulo real, debe crear únicamente las capas que esa capacidad necesite en ese momento.

No deben precrearse directorios vacíos de:

- auth;
- tenants;
- users;
- clients;
- locations;
- equipment;
- forms;
- maintenance;
- evidence;
- reports;
- AI;
- subscriptions;
- payments;
- offline;
- sync.

Tampoco deben precrearse cuatro capas vacías dentro de cada dominio futuro.

## 8.3 `app/` delgado

`app/` permanece reservado a responsabilidades propias de Next.js:

- routing;
- layouts;
- route composition;
- loading/error boundaries cuando correspondan;
- metadata;
- Route Handlers o Server Actions futuros únicamente cuando una tarea posterior los autorice;
- composición de UI y entrypoints de módulos.

`app/` no debe convertirse en ubicación principal de reglas de negocio, persistencia o adapters.

## 8.4 Dependencias explícitas

Toda dependencia entre zonas arquitectónicas debe ser intencional y visible.

La capacidad de hacer un import porque los archivos viven en el mismo repositorio no constituye una dependencia válida por sí misma.

## 8.5 Shared mínimo

`shared` existe únicamente para código realmente transversal y sin ownership razonable de un único módulo.

No debe utilizarse como depósito de helpers ambiguos o código difícil de ubicar.

## 8.6 Infraestructura común excepcional

La infraestructura común sólo debe existir para capacidades técnicas verdaderamente compartidas.

Si un adapter o detalle técnico pertenece a un único módulo, debe vivir dentro de la infraestructura de ese módulo futuro, no en la infraestructura común.

## 8.7 Sin dominio ficticio

No se deben crear entidades, interfaces de repositories, services, use cases, puertos, adapters, DTOs o tipos de producto ficticios para probar el skeleton.

## 8.8 Enforcement proporcional

Los boundaries deben protegerse mediante mecanismos ya disponibles cuando sean suficientes.

`TASK-003` no debe introducir un framework arquitectónico ni tooling dedicado de análisis de dependencias si TypeScript y ESLint existentes bastan para la frontera inicial.

# 9. Estructura física propuesta

La estructura física mínima propuesta es:

```text
app/
  ...bootstrap existente...

src/
  modules/
  shared/
  infrastructure/
```

La implementación debe materializar únicamente estos contenedores mínimos y los archivos técnicos mínimos necesarios para que Git preserve la estructura y para documentar sus reglas.

No debe crear ningún módulo funcional dentro de `src/modules/` durante `TASK-003`.

## 9.1 `src/modules/`

Ubicación reservada para futuros módulos funcionales del monolito modular.

No contiene en `TASK-003` ningún bounded context.

La forma conceptual futura de un módulo real será equivalente a:

```text
src/modules/<module>/
  domain/             # sólo si existen reglas de dominio propias
  application/        # sólo si existen casos de uso/coordinación
  infrastructure/     # sólo si existen adapters propios del módulo
  presentation/       # sólo si existe UI/composición propia reutilizable
  index.ts             # superficie pública cuando resulte necesaria
```

Esta forma es una convención de crecimiento, no una obligación de crear todos esos directorios.

Reglas:

- cada capa se crea únicamente cuando existe contenido real que la justifique;
- `index.ts` se crea únicamente cuando exista un módulo real que necesite una superficie pública;
- no se crean archivos placeholder de dominio;
- no se crean módulos de ejemplo con nombres ficticios;
- no se crea una taxonomía de bounded contexts por anticipado.

## 9.2 `src/shared/`

Ubicación para capacidades realmente transversales y sin ownership de dominio específico.

Durante `TASK-003` no debe añadirse lógica de producto ni helpers genéricos innecesarios.

La existencia de la carpeta no autoriza automáticamente subcarpetas como `utils`, `helpers`, `common` o equivalentes.

## 9.3 `src/infrastructure/`

Ubicación para infraestructura técnica común a más de un módulo o necesaria para composición general de la aplicación cuando una fase posterior la autorice.

Ejemplos conceptuales futuros podrían incluir una capacidad técnica compartida, pero `TASK-003` no implementa ninguna integración real.

La carpeta no debe utilizarse para adapters que pertenezcan claramente a un único módulo futuro.

## 9.4 Archivos de preservación/documentación

La implementación debe preferir un único documento técnico no normativo bajo `src/`, por ejemplo `src/README.md`, que explique:

- propósito de `modules`;
- propósito de `shared`;
- propósito de `infrastructure`;
- regla de creación lazy;
- regla de superficies públicas;
- dirección básica de dependencias.

Los directorios que necesiten existir sin código pueden preservarse mediante archivos técnicos mínimos equivalentes a `.gitkeep`.

No deben crearse múltiples documentos redundantes si un único archivo técnico basta.

## 9.5 Reversibilidad

Esta estructura es deliberadamente pequeña.

No fija:

- listado definitivo de bounded contexts físicos;
- cantidad definitiva de capas por módulo;
- patrón Repository;
- patrón Service;
- CQRS;
- event bus;
- DDD completo;
- Clean Architecture completa;
- Hexagonal Architecture completa;
- Onion Architecture;
- microservicios;
- monorepo.

# 10. Reglas de dependencias

Las dependencias futuras deben seguir estas reglas mínimas.

## 10.1 Regla general

Una dependencia debe apuntar hacia una responsabilidad más estable o hacia una superficie pública explícita, nunca hacia detalles incidentales de otra zona.

## 10.2 `app/`

`app/` puede depender de superficies públicas de módulos internos y, cuando corresponda, de capacidades transversales autorizadas.

Código bajo `src/` no debe depender de `app/`.

## 10.3 `shared`

`src/shared/`:

- no depende de `app/`;
- no depende de módulos funcionales;
- no depende de infraestructura común;
- no contiene reglas de un bounded context concreto;
- debe permanecer reutilizable sin conocer la topología funcional del producto.

## 10.4 Infraestructura común

`src/infrastructure/`:

- puede depender de `src/shared/`;
- no debe depender de `app/`;
- no debe importar detalles internos de módulos;
- no contiene reglas de negocio;
- no decide autorización funcional, tenant ni ownership por sí misma.

Si una implementación técnica necesita conocer un contrato propio de un módulo, el adapter debe vivir preferentemente dentro de `src/modules/<module>/infrastructure/`.

## 10.5 Módulos

Un módulo futuro puede depender de:

- su propio código interno conforme a la dirección de capas;
- `src/shared/` cuando exista una capacidad realmente transversal;
- infraestructura común desde su capa de infraestructura cuando exista una necesidad real;
- la superficie pública de otro módulo únicamente cuando una dependencia funcional explícita lo justifique.

No puede depender de detalles internos arbitrarios de otro módulo.

## 10.6 Dirección conceptual dentro de un módulo futuro

Cuando existan las capas correspondientes, se adopta como dirección base:

- `domain` → puede depender de su propio dominio y de shared verdaderamente neutral;
- `application` → puede depender de `domain` y shared neutral;
- `infrastructure` → puede depender de `application`, `domain`, shared e infraestructura común necesaria;
- `presentation` → puede depender de `application`, de tipos de dominio estrictamente necesarios y de shared permitido, pero no debe depender directamente de adapters de infraestructura;
- composición externa (`app/`) → consume la superficie pública del módulo.

No se exige crear todas estas capas ni se impone inversión de dependencias ceremonial cuando no exista una necesidad real.

## 10.7 Cross-module

Cuando existan dos módulos reales:

- el consumidor debe importar la superficie pública del proveedor;
- los deep imports hacia internals de otro módulo quedan prohibidos;
- una dependencia circular se considera defecto arquitectónico y debe bloquearse/revisarse;
- no se crea un módulo `common` para romper circularidades de forma automática;
- mover código a `shared` requiere demostrar que el código es realmente transversal y no una regla de dominio con ownership difuso.

# 11. Relación con app/

`app/` permanece en su ubicación actual y no debe moverse a `src/app/` durante `TASK-003` salvo que el repositorio real ya se encuentre así por una decisión previa válida.

Esta tarea no debe realizar una migración de routing por preferencia estética.

Reglas para la relación futura entre App Router y módulos:

1. los archivos de ruta/layout de Next.js viven en `app/`;
2. una ruta futura puede importar la superficie pública de uno o más módulos autorizados;
3. `app/` coordina routing y composición, no implementa reglas de dominio;
4. los componentes que contienen comportamiento propio de una capacidad deben vivir con el módulo cuando exista esa capacidad;
5. server/client boundaries se deciden según necesidad de confianza e interacción, no por ubicación accidental del archivo;
6. una Client Component nunca se convierte en autoridad de seguridad por estar dentro de un módulo;
7. Server Components, Server Actions o Route Handlers futuros no quedan autorizados por esta tarea;
8. la página bootstrap actual debe permanecer funcionalmente equivalente;
9. no se crean rutas funcionales nuevas;
10. no se crea navegación de producto, dashboard, auth flow ni shell funcional.

La adaptación de `app/page.*` sólo está permitida si es estrictamente necesaria para verificar un import arquitectónico permitido y puede hacerse sin introducir contenido funcional. La opción preferida es no modificar la página bootstrap.

# 12. Shared e infraestructura común

## 12.1 Criterio de entrada a `shared`

Un elemento futuro sólo debe entrar en `src/shared/` si cumple todos los criterios siguientes:

- no pertenece claramente a un único bounded context;
- no contiene reglas de negocio específicas;
- no conoce entidades o workflows de un módulo concreto;
- su reutilización es real o su naturaleza transversal es inherente;
- no se utiliza `shared` únicamente para evitar decidir ownership.

En caso de duda, el código debe permanecer con el módulo que lo necesita hasta que exista evidencia de transversalidad.

## 12.2 Prohibiciones de `shared`

Durante `TASK-003` y como convención posterior:

- no crear `shared/utils` genérico por defecto;
- no crear `shared/helpers` genérico por defecto;
- no mover reglas de dominio a `shared` para evitar dependencias;
- no colocar adapters de proveedores en `shared`;
- no colocar autorización, tenancy o RLS conceptual en `shared`;
- no crear abstractions anticipadas para Supabase, OpenAI, Mercado Pago, Dexie, PDF/DOCX u otros proveedores futuros.

## 12.3 Criterio de infraestructura común

`src/infrastructure/` se reserva para mecanismos técnicos compartidos cuyo ownership no sea de un único módulo.

Un adapter ligado a un caso de uso o bounded context concreto debe vivir en la infraestructura de ese módulo futuro.

La infraestructura común no puede convertirse en un segundo `shared` y no puede contener reglas de dominio.

## 12.4 Contenido durante TASK-003

`TASK-003` no debe introducir implementaciones reales dentro de `shared` o `infrastructure` salvo archivos técnicos mínimos necesarios para preservar/documentar la estructura.

# 13. Imports y aliases

La estrategia propuesta utiliza aliases explícitos para las tres zonas internas principales y mantiene imports relativos dentro de una misma unidad cuando sean más claros.

Aliases mínimos propuestos:

- `@modules/*` → `src/modules/*`;
- `@shared/*` → `src/shared/*`;
- `@infrastructure/*` → `src/infrastructure/*`.

## 13.1 Alias preexistente `@/*`

Si el bootstrap actual ya utiliza un alias general `@/*`, `TASK-003` no debe eliminarlo ni cambiar su semántica de forma que rompa código existente.

Sin embargo, el nuevo código modular no debe utilizar `@/*` para eludir las fronteras explícitas anteriores.

Cuando el alias general permita paths como `@/src/modules/...`, ESLint debe restringir esos accesos cuando el patrón pueda expresarse de forma robusta con la configuración actual, para que las nuevas dependencias modulares utilicen los aliases específicos. Esta restricción mecánica no sustituye la prohibición arquitectónica de utilizar el alias general para acceder a internals modulares.

## 13.2 Convención de imports

- dentro del mismo módulo o subárbol coherente: imports relativos cuando mantengan claridad;
- desde `app/` a un módulo: superficie pública del módulo;
- entre módulos: superficie pública del módulo proveedor;
- hacia shared: `@shared/...`;
- hacia infraestructura común desde una zona autorizada: `@infrastructure/...`;
- nunca deep import de internals de otro módulo;
- nunca import desde `src/**` hacia `app/**`.

## 13.3 Superficie pública de módulos

Cuando exista un módulo real, su acceso externo debe concentrarse en una superficie pública explícita, preferentemente un `index.ts` pequeño o un entrypoint equivalente.

La superficie pública:

- exporta únicamente contratos/capacidades que otros consumidores necesitan;
- no exporta internals por comodidad;
- no debe mezclar accidentalmente código server-only y client-only de forma que rompa las fronteras de Next.js;
- puede evolucionar hacia entrypoints separados si una necesidad real de server/client lo exige en una tarea posterior.

`TASK-003` no crea todavía estos entrypoints porque no existen módulos funcionales.

## 13.4 Enforcement mínimo

Las reglas de dependencias definidas en esta tarea son **reglas arquitectónicas normativas** aunque no todas puedan demostrarse mecánicamente de forma exhaustiva durante `TASK-003`.

El mecanismo de enforcement inicial es utilizar el ESLint ya instalado, sin dependencias nuevas, mediante reglas built-in equivalentes a `no-restricted-imports` y overrides por zona cuando corresponda. Este enforcement se limita al subconjunto de **imports estáticos y patrones de importación que puedan expresarse de forma robusta con la configuración ESLint actual**.

Como mínimo debe intentar impedir o marcar como error, cuando el patrón pueda expresarse de forma segura y mantenible:

- imports estáticos desde código bajo `src/**` hacia `app/**`;
- imports estáticos desde `src/shared/**` hacia aliases o paths de `src/modules/**`;
- imports estáticos desde `src/shared/**` hacia aliases o paths de `src/infrastructure/**`;
- imports estáticos desde `src/infrastructure/**` hacia `app/**`;
- deep imports mediante aliases equivalentes a `@modules/<module>/<internal>`;
- uso del alias general preexistente para acceder a internals de `src/modules/**` cuando ese patrón pueda restringirse sin bloquear imports válidos no relacionados.

No deben introducirse reglas frágiles, excesivamente amplias o dependientes de supuestos sobre módulos todavía inexistentes únicamente para aparentar cobertura completa.

`TASK-003` no pretende demostrar enforcement exhaustivo de todas las dependencias futuras entre módulos inexistentes. El enforcement inicial cubre imports estáticos y patrones expresables de forma robusta mediante el ESLint actual. Cuando existan módulos reales, sus tareas deberán ampliar el enforcement necesario para proteger sus superficies públicas y dependencias concretas sin contradecir estas reglas arquitectónicas.

En particular:

- los imports dinámicos no deben presentarse como cubiertos exhaustivamente por `no-restricted-imports`;
- la ausencia actual de módulos reales impide validar exhaustivamente todas las combinaciones de imports relativos cross-module;
- esta limitación mecánica **NO** debilita las reglas arquitectónicas definidas en esta tarea;
- esta limitación **NO** autoriza deep imports futuros ni dependencias circulares;
- las dependencias circulares continúan prohibidas arquitectónicamente aunque `TASK-003` no incorpore un analizador exhaustivo de grafos;
- esta limitación **NO** requiere ni autoriza tooling nuevo durante `TASK-003`.

No se añade:

- Nx;
- Turborepo;
- dependency-cruiser;
- madge;
- `eslint-plugin-boundaries`;
- otro framework de arquitectura.

La configuración exacta debe adaptarse al formato de ESLint realmente presente después de `TASK-002`.

Si las reglas built-in disponibles no pueden expresar de forma robusta una restricción propuesta sin añadir tooling nuevo, Codex debe conservar la regla arquitectónica documentada, implementar el subconjunto seguro que sí pueda hacer cumplir con el tooling actual y reportar la limitación. No debe instalar tooling pesado por iniciativa propia.

No es necesario mecanizar en `TASK-003` todas las reglas intra-módulo de domain/application/infrastructure/presentation porque todavía no existe ningún módulo funcional. Esas reglas quedan definidas como convención y deberán convertirse en enforcement concreto cuando existan archivos reales que hagan necesaria esa protección.

# 14. Dentro de alcance

`TASK-003` puede realizar exclusivamente lo necesario para materializar el skeleton aprobado:

- crear `src/` si no existe;
- crear los contenedores mínimos `src/modules/`, `src/shared/` y `src/infrastructure/`;
- añadir archivos técnicos mínimos para que Git preserve esos directorios cuando sea necesario;
- añadir documentación técnica no normativa mínima bajo `src/` para explicar las reglas del skeleton;
- añadir los aliases internos mínimos propuestos en la configuración TypeScript existente;
- añadir o ajustar reglas ESLint mínimas para boundaries usando el tooling ya instalado;
- preservar aliases preexistentes cuando sea necesario para compatibilidad;
- adaptar mínimamente imports existentes únicamente si la nueva configuración lo exige y el cambio no altera funcionalidad;
- adaptar mínimamente la página bootstrap únicamente si resulta imprescindible para validar una integración permitida;
- utilizar, cuando resulte útil, archivos técnicos neutrales temporales para comprobar negativamente que ESLint rechaza un import estático prohibido; esos archivos no deben introducir dominio, no deben convertirse en módulos ficticios y deben eliminarse antes del diff final;
- añadir un test técnico permanente de arquitectura sólo si es estrictamente necesario para demostrar una restricción que no pueda validarse razonablemente mediante lint/configuración existente; no es obligatorio si ESLint y una comprobación temporal son suficientes;
- ejecutar todas las verificaciones vigentes de `TASK-002`;
- registrar las decisiones técnicas menores tomadas durante implementación.

No se espera instalar ninguna dependencia nueva.

# 15. Fuera de alcance

Queda explícitamente fuera de `TASK-003`:

- cualquier bounded context funcional;
- módulos físicos de auth;
- módulos físicos de tenants;
- módulos físicos de users;
- módulos físicos de clients;
- módulos físicos de locations;
- módulos físicos de equipment;
- módulos físicos de forms;
- módulos físicos de maintenance;
- módulos físicos de evidence;
- módulos físicos de reports;
- módulos físicos de AI;
- módulos físicos de subscriptions;
- módulos físicos de payments;
- módulos físicos de offline;
- módulos físicos de sync;
- entidades de producto;
- value objects;
- aggregates;
- use cases reales;
- commands/queries reales;
- repositories reales;
- services de dominio;
- ports/adapters de producto;
- DTOs de producto;
- schemas de validación de producto;
- Supabase;
- Supabase CLI;
- Supabase local;
- Supabase Auth;
- Supabase Storage;
- Supabase Realtime;
- schema PostgreSQL de producto;
- migrations;
- SQL;
- tablas;
- columnas;
- PK/FK;
- índices;
- constraints;
- seeds;
- RLS;
- policies;
- tenant resolution implementada;
- tenancy funcional;
- roles;
- usuarios;
- autorización funcional;
- `service-role`;
- secretos;
- `.env` con valores reales;
- Dexie;
- IndexedDB;
- Service Worker;
- PWA offline-first funcional;
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
- Playwright;
- Cypress;
- formatter;
- Prettier;
- Husky;
- lint-staged;
- commitlint;
- monorepo tooling;
- microservicios;
- múltiples aplicaciones;
- cambio de framework;
- cambio de package manager;
- dependencias futuras “por si acaso”;
- ADR nuevo;
- resolución de `DO-*`;
- resolución de `*-OPEN-*`;
- cualquier funcionalidad de Fase 2+;
- `TASK-004`.

# 16. Archivos/categorías de archivos esperados

La futura implementación puede crear o modificar únicamente categorías equivalentes a las siguientes:

- `src/README.md` o un único documento técnico no normativo equivalente para las convenciones del skeleton;
- `src/modules/.gitkeep` o archivo técnico mínimo equivalente;
- `src/shared/.gitkeep` o archivo técnico mínimo equivalente;
- `src/infrastructure/.gitkeep` o archivo técnico mínimo equivalente;
- `tsconfig.json`, únicamente para aliases mínimos y sin relajar TypeScript;
- `eslint.config.*` o configuración equivalente existente, únicamente para boundaries/import rules mínimas;
- archivos de bootstrap existentes sólo si una adaptación técnica mínima resulta imprescindible y no cambia funcionalidad;
- un test técnico permanente de arquitectura únicamente si se demuestra estrictamente necesario y permanece neutral respecto del dominio;
- archivos técnicos neutrales de comprobación negativa pueden crearse temporalmente durante la implementación, pero no deben permanecer en el diff final.

No se espera modificar:

- `package.json`;
- `package-lock.json`;
- versiones de dependencias;
- configuración de Vitest;
- `app/` más allá de una adaptación excepcional mínima;
- `/docs`.

Si la implementación concluye que necesita añadir una dependencia nueva para imponer boundaries, debe evaluar primero si la regla puede expresarse mediante ESLint/TypeScript existentes. Añadir tooling dedicado de arquitectura no está autorizado por defecto.

No deben crearse:

- `src/modules/<bounded-context>/...`;
- archivos de dominio ficticio;
- `supabase/`;
- `.github/workflows/`;
- migrations;
- SQL;
- archivos RLS;
- `.env` con secretos;
- archivos de Fase 2+.

# 17. Restricciones de implementación

La implementación futura debe respetar todas las restricciones siguientes:

- inspeccionar el repositorio antes de modificar;
- repetir preflight inmediatamente antes del primer cambio;
- trabajar exclusivamente sobre `TASK-003`;
- preservar `TASK-001`;
- preservar `CORR-001`;
- preservar `TASK-002`;
- preservar `/docs` sin modificaciones;
- preservar App Router;
- preservar React `19.2.8` salvo evidencia de que el repositorio real aprobado contiene otra versión;
- preservar Next.js `16.3.1` salvo evidencia de que el repositorio real aprobado contiene otra versión;
- preservar TypeScript `6.0.3` salvo evidencia de que el repositorio real aprobado contiene otra versión;
- preservar `strict: true`;
- preservar Tailwind CSS `4.3.3` salvo evidencia de que el repositorio real aprobado contiene otra versión;
- preservar ESLint y Vitest operativos;
- preservar scripts `lint`, `typecheck`, `test`, `build` y `verify`;
- no rebajar reglas de TypeScript para facilitar imports;
- no introducir `any` para satisfacer el skeleton;
- no desactivar reglas de lint existentes para ocultar problemas;
- no regenerar la aplicación mediante scaffolding;
- no mover `app/` por preferencia;
- no crear rutas funcionales;
- no crear módulos de dominio;
- no crear un módulo demo de producto;
- no crear un módulo ficticio sólo para ilustrar capas;
- no crear carpetas vacías para todos los dominios futuros;
- no imponer cuatro capas físicas si no existe contenido real;
- no añadir tooling pesado;
- no añadir dependencia de architecture-boundary por iniciativa propia;
- no cambiar de package manager;
- no crear un segundo lockfile;
- no configurar Supabase;
- no implementar Auth;
- no implementar tenancy;
- no crear schema/migrations/SQL/RLS;
- no configurar CI;
- no añadir secrets;
- no crear ni modificar ADR;
- no resolver `DO-*` ni `*-OPEN-*`;
- no ejecutar `git init`;
- no reescribir historia Git;
- no hacer commit;
- no hacer push;
- no generar `TASK-004`;
- no avanzar a Fase 2.

Si una regla de boundaries revela un defecto previo real en el bootstrap/tooling, Codex debe distinguir:

- **ajuste técnico mínimo dentro de alcance:** cambio estrictamente necesario para aplicar la estructura aprobada sin alterar funcionalidad;
- **rediseño o migración no prevista:** debe reportarse como `BLOCKER`.

# 18. Seguridad

Impacto de seguridad de `TASK-003`:

- no implementa autenticación;
- no implementa autorización;
- no implementa tenant resolution;
- no implementa aislamiento remoto;
- no implementa RLS;
- no introduce persistencia de producto;
- no introduce secrets;
- no introduce credenciales;
- no introduce `service-role`;
- no introduce proveedores externos.

La tarea debe preservar como invariantes arquitectónicas futuras:

- el frontend nunca será autoridad del tenant efectivo;
- un ID válido no concede acceso por sí mismo;
- una ruta o parámetro no constituye prueba de ownership;
- la UI no sustituye autorización server-side;
- RLS será obligatoria cuando exista persistencia tenant-owned;
- `service-role` no debe convertirse en acceso ordinario de usuarios;
- las fronteras modulares no deben crear un bypass conceptual de autorización futura.

Está prohibido durante `TASK-003`:

- añadir claves Supabase;
- añadir service-role keys;
- añadir secretos OpenAI;
- añadir credenciales Mercado Pago;
- crear `.env` con valores reales;
- codificar tenant IDs de ejemplo que puedan parecer una estrategia de autorización;
- introducir middleware de autorización ficticio.

# 19. Impacto de datos / migrations

`NO APLICA TODAVÍA — skeleton de código únicamente`

`TASK-003` no crea ni modifica:

- schema de producto;
- tablas;
- columnas;
- relaciones;
- PK/FK;
- índices;
- constraints;
- migrations;
- seeds;
- SQL;
- datos de tenant;
- schema Dexie/IndexedDB;
- buckets;
- paths de Storage.

No debe existir ninguna migration nueva como resultado de `TASK-003`.

# 20. Impacto RLS

`NO APLICA TODAVÍA — no existe schema de producto`

`TASK-003` no crea, diseña ni modifica:

- policies RLS;
- helpers RLS;
- funciones PostgreSQL de autorización;
- claims;
- roles físicos;
- tenant resolution implementada;
- permisos de datos.

La ausencia de RLS en esta tarea no modifica su obligatoriedad futura definida por la baseline y `ADR-0002`.

# 21. Criterios de aceptación

`TASK-003` sólo puede considerarse implementada correctamente si se cumplen todos los criterios siguientes:

1. Codex leyó íntegramente todas las fuentes obligatorias antes de modificar el repositorio.
2. El repositorio real fue inspeccionado antes de seleccionar archivos o configuración.
3. Se repitió el preflight Git inmediatamente antes del primer cambio.
4. El worktree estaba limpio al comenzar.
5. Se registró el `HEAD` inicial.
6. El repositorio Git existente fue preservado.
7. No se ejecutó `git init`.
8. No se reescribió historia Git.
9. `/docs` permaneció intacto.
10. `TASK-001`, `CORR-001` y `TASK-002` permanecieron preservadas.
11. Existe una única aplicación Next.js.
12. Se preservó un único deployable principal.
13. App Router continúa operativo.
14. `app/` permanece como frontera de routing/composición y no contiene dominio nuevo.
15. No se movió `app/` únicamente por preferencia de estructura.
16. Existe `src/` o estructura equivalente aprobada para código modular interno.
17. Existe un contenedor neutral para módulos futuros equivalente a `src/modules/`.
18. No existe ningún bounded context funcional dentro de `src/modules/`.
19. Existe una zona transversal equivalente a `src/shared/` con restricciones explícitas.
20. Existe una zona de infraestructura común equivalente a `src/infrastructure/` con restricciones explícitas.
21. La estructura no crea carpetas futuras por dominio “por si acaso”.
22. La estructura no crea las cuatro capas dentro de módulos inexistentes.
23. Está documentada la creación lazy de módulos y capas.
24. Está documentada la dirección de dependencias intra-módulo definida por esta tarea —application puede depender de domain; infrastructure puede depender de application/domain; presentation no depende directamente de adapters— sin imponer arquitectura ceremonial.
25. Está documentada una superficie pública para cross-module imports futuros.
26. Los deep imports cross-module quedan prohibidos arquitectónicamente; el subconjunto de deep imports estáticos mediante aliases que pueda expresarse de forma robusta queda restringido por el enforcement ESLint disponible.
27. Existen aliases explícitos equivalentes a `@modules/*`, `@shared/*` y `@infrastructure/*`, salvo que la inspección determine una variante local más simple y equivalente que quede documentada.
28. Cualquier alias general preexistente fue preservado cuando era necesario para no romper el bootstrap.
29. El alias general preexistente queda restringido frente a accesos estáticos a internals modulares en los patrones que puedan expresarse de forma robusta, sin afirmar cobertura exhaustiva de toda forma futura de importación.
30. Se configuró enforcement mínimo mediante ESLint ya instalado para el subconjunto de imports estáticos y patrones robustamente expresables, sin añadir tooling pesado ni afirmar cobertura exhaustiva de módulos inexistentes.
31. La regla arquitectónica `src/**` no depende de `app/**` está documentada y los imports estáticos correspondientes quedan bloqueados cuando pueden expresarse robustamente con la configuración ESLint actual.
32. La regla arquitectónica `shared` no depende de módulos funcionales está documentada y sus patrones estáticos mediante aliases/paths quedan bloqueados cuando pueden expresarse robustamente con ESLint actual.
33. La regla arquitectónica `shared` no depende de infraestructura común está documentada y sus patrones estáticos mediante aliases/paths quedan bloqueados cuando pueden expresarse robustamente con ESLint actual.
34. La regla arquitectónica de que infraestructura común no depende de `app/` ni de internals arbitrarios de módulos está documentada; el subconjunto estático robustamente expresable queda mecanizado sin pretender demostrar todas las combinaciones futuras.
35. No se añadió `shared/utils` genérico sin ownership.
36. No se creó dominio ficticio para demostrar imports.
37. No se crearon entidades, value objects, repositories, services o use cases reales.
38. No se añadieron adapters de producto.
39. La página bootstrap permanece funcionalmente preservada.
40. No se crearon rutas funcionales nuevas.
41. TypeScript continúa en `strict: true` efectivo.
42. No se introdujo `any` deliberado para satisfacer el skeleton.
43. ESLint continúa operativo.
44. Vitest continúa operativo.
45. `npm run lint` finaliza exitosamente.
46. `npm run typecheck` finaliza exitosamente.
47. `npm run test` finaliza exitosamente.
48. `npm run build` finaliza exitosamente.
49. `npm run verify` finaliza exitosamente.
50. La instalación desde `package.json` y lockfile continúa siendo reproducible.
51. `npm` continúa siendo el único package manager efectivo.
52. Existe un único lockfile.
53. No se añadió una dependencia nueva salvo excepción técnica expresamente justificada y revisable; tooling pesado de boundaries sigue prohibido.
54. No se añadió Supabase.
55. No se añadió Supabase CLI.
56. No se creó schema.
57. No se crearon migrations.
58. No se creó SQL.
59. No se creó RLS.
60. No se implementó Auth.
61. No se implementó tenancy.
62. No se añadió `service-role`.
63. No se añadieron secrets.
64. No se configuró CI.
65. No se creó GitHub Actions.
66. No se implementó ninguna capacidad de Fase 2+.
67. No se creó ni modificó ningún ADR.
68. No se resolvió ningún `DO-*` ni `*-OPEN-*`.
69. No se realizó commit.
70. No se realizó push.
71. No se generó `TASK-004`.
72. Los archivos creados y modificados quedaron listados en el informe.
73. Los aliases y reglas de boundaries finales quedaron listados en el informe.
74. Las decisiones técnicas menores quedaron registradas.
75. El resultado final de Codex fue informado exactamente como `PASS`, `FAIL` o `BLOCKER`.

# 22. Pruebas/verificaciones obligatorias

Durante la futura implementación, Codex debe ejecutar y registrar como mínimo:

## Preflight

- `git status` antes de cambios;
- branch actual;
- relación con `origin/main` conforme al mecanismo disponible;
- identificación del `HEAD` inicial;
- versión de Node;
- versión de npm;
- versiones reales de Next.js, React y TypeScript;
- comprobación de `strict: true`;
- inspección de aliases existentes;
- inspección de configuración ESLint vigente;
- inspección de estructura actual de `app/` y `src/`.

## Instalación reproducible

- instalación mediante el mecanismo correspondiente al lockfile, preferentemente `npm ci` cuando el estado real lo permita;
- confirmación de un único lockfile;
- confirmación de que no se añadieron dependencias no justificadas.

## Estructura

- listado final de `src/`;
- comprobación de que sólo existen los contenedores arquitectónicos permitidos;
- comprobación de que no existen bounded contexts funcionales creados;
- comprobación de que no existen carpetas futuras de dominio precreadas;
- comprobación de que `app/` continúa siendo la frontera de routing/composición.

## Imports y boundaries

- inspección de aliases finales de TypeScript;
- inspección de las reglas arquitectónicas de dependencias documentadas;
- inspección de reglas ESLint finales de boundaries y del subconjunto estático que realmente mecanizan;
- comprobación negativa de que los patrones estáticos configurados para `src → app` son rechazados por ESLint;
- comprobación negativa de que los patrones estáticos configurados para `shared → modules` y `shared → infrastructure` son rechazados por ESLint;
- comprobación negativa de que los deep imports mediante aliases modulares configurados como prohibidos son rechazados por ESLint;
- comprobación negativa de que el alias general no puede utilizarse para los accesos a internals modulares expresamente restringidos;
- comprobación de que las reglas ESLint no se presentan como cobertura exhaustiva de imports dinámicos ni de todas las combinaciones relativas cross-module de módulos todavía inexistentes;
- comprobación de que no se añadió tooling pesado para intentar cubrir esa limitación.

Codex puede crear temporalmente archivos técnicos neutrales para demostrar que una regla ESLint rechaza un import prohibido. Esos archivos no deben introducir dominio, no deben convertirse en módulos ficticios y no deben quedar en el diff final. No es obligatorio crear tests permanentes si ESLint y una comprobación temporal son suficientes.

## Baseline de calidad

Ejecutar y registrar:

- `npm run lint`;
- `npm run typecheck`;
- `npm run test`;
- `npm run build`;
- `npm run verify`.

Todos deben finalizar con `PASS` para declarar la tarea exitosa.

## Scope negativo

Comprobar explícitamente:

- `/docs` sin cambios;
- sin Supabase;
- sin schema;
- sin migrations;
- sin SQL;
- sin RLS;
- sin Auth;
- sin tenancy;
- sin `service-role`;
- sin secrets;
- sin CI;
- sin GitHub Actions;
- sin Fase 2+;
- sin ADR nuevo;
- sin `DO-*` / `*-OPEN-*` resuelto;
- sin `TASK-004`.

## Integridad final

- `git diff --check` o verificación equivalente;
- `git status` final;
- diff completo de la tarea;
- listado final de archivos creados;
- listado final de archivos modificados;
- listado final de dependencias añadidas, que idealmente debe ser vacío;
- listado final de aliases;
- listado final de reglas de boundaries;
- listado final de decisiones técnicas menores.

Si cualquiera de las verificaciones obligatorias falla, Codex no debe declarar `PASS`.

La corrección de un fallo sólo puede realizarse si permanece dentro del alcance explícito de `TASK-003`. De lo contrario debe informarse `BLOCKER`.

# 23. Definition of Done

La futura implementación de `TASK-003` podrá proponerse como `DONE` únicamente cuando:

- todos los criterios de aceptación estén cumplidos;
- todas las verificaciones obligatorias hayan sido ejecutadas y registradas;
- la estructura modular mínima exista;
- `app/` continúe siendo routing/composición;
- no exista ningún bounded context funcional nuevo;
- no exista dominio ficticio o real de producto introducido por esta tarea;
- `shared` e infraestructura común tengan ownership y restricciones explícitas;
- los aliases internos estén definidos de forma mínima;
- las reglas arquitectónicas de dependencias estén documentadas y el subconjunto de imports estáticos robustamente expresable esté mecanizado proporcionalmente con el tooling ya disponible, sin afirmar enforcement exhaustivo;
- no se haya introducido tooling pesado;
- lint pase;
- typecheck pase;
- tests base pasen;
- build pase;
- verify pase;
- TypeScript strict permanezca intacto;
- el bootstrap permanezca funcionalmente intacto;
- el tooling de `TASK-002` permanezca intacto;
- `/docs` permanezca intacto;
- no exista scope creep hacia Supabase, Auth, schema, RLS, CI o Fase 2+;
- no existan secrets;
- no se haya creado ADR;
- no se haya resuelto ningún `DO-*` o `*-OPEN-*`;
- no se haya creado `TASK-004`;
- el diff haya sido revisado desde arquitectura, seguridad y regresiones;
- el informe de Codex sea completo;
- una revisión humana posterior acepte expresamente el resultado.

El estado actual de esta especificación permanece:

`APPROVED FOR IMPLEMENTATION`

Esta aprobación documental no ejecuta la tarea ni utiliza Codex.

# 24. Instrucciones para Codex

Cuando `TASK-003` haya sido formalmente aprobada para implementación, Codex deberá seguir estas instrucciones:

1. leer íntegramente todas las fuentes obligatorias de `TASK-003`;
2. localizar `ADR-0002` por su ID/título y usar la ruta canónica presente en el repositorio sin renombrar documentación;
3. inspeccionar el repositorio antes de decidir archivos o sintaxis de configuración;
4. repetir el preflight Git inmediatamente antes del primer cambio;
5. confirmar worktree limpio;
6. registrar `HEAD` inicial;
7. trabajar exclusivamente sobre `TASK-003`;
8. preservar `TASK-001`;
9. preservar `CORR-001`;
10. preservar `TASK-002`;
11. preservar `/docs` sin cambios;
12. preservar una única aplicación Next.js;
13. preservar App Router;
14. preservar el bootstrap actual;
15. preservar npm y un único lockfile;
16. preservar Next.js, React y Tailwind salvo discrepancia real previamente aprobada en el repositorio;
17. preservar TypeScript `6.0.3` y `strict: true` conforme al baseline real;
18. preservar ESLint y Vitest vigentes;
19. materializar únicamente el skeleton modular mínimo;
20. mantener `app/` como routing/composición;
21. crear únicamente contenedores neutrales equivalentes a `src/modules`, `src/shared` y `src/infrastructure`;
22. no crear ningún bounded context funcional;
23. no crear módulos demo de producto;
24. no crear clases, entidades, repositories, services o use cases de producto;
25. documentar creación lazy de módulos/capas;
26. configurar aliases mínimos y explícitos;
27. preservar aliases existentes cuando sea necesario para compatibilidad;
28. configurar con ESLint ya disponible el enforcement mínimo del subconjunto de imports estáticos y patrones que puedan expresarse de forma robusta;
29. preservar la prohibición arquitectónica de deep imports cross-module y restringir mecánicamente los patrones estáticos mediante aliases que puedan expresarse de forma robusta;
30. preservar la prohibición arquitectónica de dependencias `src → app` y bloquear mediante ESLint los imports estáticos correspondientes que puedan expresarse robustamente;
31. preservar la prohibición arquitectónica de dependencias `shared → modules` y `shared → infrastructure`, mecanizando sus patrones estáticos robustamente expresables sin afirmar cobertura exhaustiva ni añadir tooling;
32. no instalar Nx;
33. no instalar Turborepo;
34. no instalar dependency-cruiser;
35. no instalar tooling pesado equivalente;
36. no instalar `eslint-plugin-boundaries` por iniciativa propia;
37. no configurar Supabase;
38. no crear schema;
39. no crear migrations;
40. no crear SQL;
41. no crear RLS;
42. no implementar Auth;
43. no implementar tenancy;
44. no introducir `service-role`;
45. no introducir secrets;
46. no configurar CI;
47. no crear `.github/workflows/*`;
48. no implementar Fase 2+;
49. no resolver silenciosamente ningún `DO-*` ni `*-OPEN-*`;
50. no crear ADR por decisiones locales/reversibles;
51. reportar `BLOCKER` si aparece una decisión arquitectónica material imprescindible;
52. ejecutar `npm run lint`;
53. ejecutar `npm run typecheck`;
54. ejecutar `npm run test`;
55. ejecutar `npm run build`;
56. ejecutar `npm run verify`;
57. ejecutar `git diff --check` o equivalente;
58. registrar todos los comandos y resultados relevantes;
59. listar todos los archivos creados;
60. listar todos los archivos modificados;
61. listar dependencias añadidas y justificar cada una; la expectativa es ninguna;
62. listar aliases finales;
63. listar reglas de boundaries finales;
64. registrar decisiones técnicas menores tomadas;
65. informar cualquier adaptación excepcional de la página bootstrap y justificar por qué fue necesaria;
66. informar el resultado final usando exactamente uno de:
    - `PASS`;
    - `FAIL`;
    - `BLOCKER`;
67. no hacer commit;
68. no hacer push;
69. no generar `TASK-004`;
70. no avanzar a ninguna tarea posterior.

Codex no debe interpretar esta tarea como autorización para “preparar” módulos futuros mediante placeholders, adapters, interfaces o dependencias destinadas a fases posteriores.

# 25. Resultado esperado

Al finalizar correctamente la futura implementación de `TASK-003`, el repositorio debe conservar todo el resultado válido de `TASK-001`, `CORR-001` y `TASK-002` y añadir exclusivamente una estructura arquitectónica mínima para crecimiento modular.

Estado técnico esperado:

- Next.js `16.3.1` preservado conforme al baseline real;
- React `19.2.8` preservado conforme al baseline real;
- TypeScript `6.0.3` preservado conforme al baseline real;
- TypeScript `strict: true`;
- Tailwind CSS `4.3.3` preservado conforme al baseline real;
- App Router operativo;
- npm preservado;
- un único lockfile;
- instalación reproducible;
- ESLint operativo;
- Vitest operativo;
- lint exitoso;
- typecheck exitoso;
- tests base exitosos;
- build exitoso;
- verify exitoso.

Estado arquitectónico esperado:

- una sola aplicación Next.js;
- un solo deployable principal;
- `app/` preservado como routing/composición;
- `src/modules/` disponible para módulos futuros sin módulos funcionales creados;
- `src/shared/` disponible bajo restricciones explícitas;
- `src/infrastructure/` disponible bajo restricciones explícitas;
- módulo futuro = agrupación module-first con capas creadas sólo cuando existan responsabilidades reales;
- imports internos con aliases explícitos;
- deep imports cross-module prohibidos arquitectónicamente y patrones estáticos mediante aliases restringidos cuando son robustamente expresables;
- enforcement inicial proporcional aplicado mediante ESLint existente al subconjunto de imports estáticos robustamente expresable, sin promesa de cobertura exhaustiva;
- sin arquitectura ceremonial;
- sin microservicios;
- sin monorepo.

Estado funcional esperado:

`NINGUNA FUNCIONALIDAD DE PRODUCTO NUEVA IMPLEMENTADA`

Estado de seguridad/datos esperado:

- Supabase: no configurado;
- Auth: no implementado;
- tenancy: no implementada;
- schema: inexistente;
- migrations: inexistentes;
- SQL: inexistente;
- RLS: inexistente;
- `service-role`: inexistente;
- secrets: no añadidos.

Estado de fases esperado:

- Fase 1: en progreso;
- Fase 2: no iniciada;
- `TASK-004`: no generada.

# 26. Gate posterior

Después de la futura implementación de `TASK-003` debe realizarse una revisión humana explícita antes de autorizar cualquier tarea siguiente.

El Gate posterior debe verificar como mínimo:

- cumplimiento íntegro de los criterios de aceptación;
- estructura modular mínima y no ceremonial;
- `app/` preservado como routing/composición;
- ausencia de lógica de dominio en `app/`;
- ausencia de bounded contexts funcionales;
- ausencia de carpetas futuras por dominio creadas “por si acaso”;
- ausencia de entidades, repositories, services o use cases ficticios;
- `src/modules/` neutral y vacío de dominio funcional;
- `src/shared/` con restricciones explícitas y sin `utils` genérico no justificado;
- `src/infrastructure/` reservada a infraestructura común y sin adapters futuros implementados;
- creación lazy de módulos/capas documentada;
- aliases finales simples y comprensibles;
- reglas arquitectónicas completas de dependencias documentadas y preservadas;
- alias general preexistente restringido para los accesos estáticos a internals modulares que puedan expresarse de forma robusta;
- deep imports cross-module prohibidos arquitectónicamente y patrones estáticos mediante aliases protegidos de forma proporcional;
- imports `src → app` prohibidos arquitectónicamente y patrones estáticos correspondientes protegidos cuando sean robustamente expresables;
- enforcement inicial ESLint proporcional verificado para `shared → modules`, `shared → infrastructure`, infraestructura común `→ app` y demás patrones previstos que puedan expresarse con la configuración actual;
- ninguna afirmación de cobertura exhaustiva sobre imports dinámicos, imports relativos cross-module de módulos inexistentes o todas las dependencias futuras;
- ausencia de tooling pesado nuevo;
- ausencia de dependencias nuevas no justificadas;
- lint exitoso;
- typecheck exitoso;
- tests base exitosos;
- build exitoso;
- verify exitoso;
- TypeScript strict preservado;
- bootstrap preservado;
- tooling de `TASK-002` preservado;
- `/docs` intacto;
- historia Git intacta;
- ausencia de commit/push;
- ausencia de secrets;
- ausencia de Supabase;
- ausencia de schema;
- ausencia de migrations;
- ausencia de SQL;
- ausencia de RLS;
- ausencia de Auth;
- ausencia de tenancy;
- ausencia de CI;
- ausencia de Fase 2+;
- ningún ADR nuevo;
- ningún `DO-*` o `*-OPEN-*` resuelto;
- informe de Codex completo con `PASS`, `FAIL` o `BLOCKER`;
- `TASK-004` no generada.

Sólo si este Gate se supera podrá evaluarse el siguiente trabajo de Fase 1 conforme al orden aprobado.

El siguiente paso normativo después del skeleton es `Paso 5 — Configuración de entorno y secretos`, pero este Gate no define, autoriza ni genera `TASK-004`.

Estado de `TASK-003` en este documento:

`APPROVED FOR IMPLEMENTATION`

Estado operativo actual de este paso documental:

- `TASK-003` implementada: no;
- Codex ejecutado: no;
- repositorio modificado por este paso: no;
- commit realizado: no;
- push realizado: no;
- `TASK-004` generada: no;
- Fase 1 completada: no;
- Fase 2 iniciada: no.
