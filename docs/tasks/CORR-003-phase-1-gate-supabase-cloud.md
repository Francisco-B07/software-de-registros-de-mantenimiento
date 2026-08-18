# 1. ID

`CORR-003`

**Archivo de entrega:**

`CORR-003-phase-1-gate-supabase-cloud-approved.md`

**Ruta canónica futura:**

`docs/tasks/CORR-003-phase-1-gate-supabase-cloud.md`

`CORR-003` está formalmente aprobada para implementación. Su incorporación canónica futura corresponde a la ruta indicada y no modifica por sí misma ningún documento del repositorio.

# 2. Título

`Sincronización del Gate de Fase 1 con Supabase Cloud Development`

# 3. Tipo

`CORRECCIÓN DOCUMENTAL DE CONSISTENCIA`

La corrección se limita a sincronizar una condición operativa obsoleta del Gate de Fase 1 con una decisión posterior ya aprobada y aplicada mediante `CORR-002`.

No redefine producto, arquitectura, seguridad, modelo de datos, orden de fases ni alcance funcional.

# 4. Estado

`APPROVED FOR IMPLEMENTATION`

Este documento:

- ha superado la revisión humana técnica, arquitectónica, de seguridad y documental;
- está formalmente aprobado para implementación;
- la aprobación de `CORR-003` no autoriza automáticamente la modificación de `docs/product/11-phase-1-scope-entry-gate.md`;
- no autoriza Codex en esta entrega;
- no autoriza Git en esta entrega;
- no genera `TASK-006`;
- no configura CI;
- no inicia Fase 2.

**Estado de Fase 1:** `EN PROGRESO`.

# 5. Motivo

`docs/product/11-phase-1-scope-entry-gate.md` fue aprobado antes de la corrección operativa introducida por `CORR-002` y todavía utiliza como condición de Fase 1 una estrategia basada en:

- Supabase local;
- un stack local configurable y arrancable;
- lifecycle local de arranque/parada;
- runtime Docker-compatible como precondición del workflow.

Posteriormente, `CORR-002 — Supabase Cloud Development sin Docker y operación remota manual` sustituyó expresamente esa estrategia operativa por:

`Supabase CLI reproducible + configuración Supabase versionable + un único proyecto Supabase Cloud exclusivo de Development + operaciones remotas manuales por Francisco`

sin modificar el producto ni ampliar Fase 1.

La implementación corregida de `TASK-005` fue cerrada y el baseline resultante ya no depende de Docker ni de un stack Supabase local.

Por tanto, el Gate de Fase 1 quedó documentalmente desincronizado respecto del estado aprobado y ejecutado del proyecto.

# 6. Contexto normativo

Esta corrección debe interpretarse exclusivamente a partir de las siguientes fuentes obligatorias:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`;
- `docs/tasks/TASK-005-supabase-local.md`;
- `docs/tasks/CORR-002-supabase-cloud-development.md`;
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`.

También se revisan las referencias a Fase 1 contenidas en esas fuentes para evitar que la sincronización modifique indirectamente una frontera ya aprobada.

Se aplica el orden temporal y normativo ya establecido por la documentación del proyecto:

1. una decisión explícita aprobada posteriormente que modifique una condición previa prevalece dentro del alcance exacto de esa modificación;
2. `01-product-definition.md` continúa siendo la baseline normativa de producto;
3. los documentos derivados y ADR aceptados conservan autoridad dentro de su alcance;
4. una corrección posterior no debe utilizarse para inferir cambios que no haya aprobado expresamente.

Estado operativo consumido por esta corrección:

- Fase 0: `COMPLETADA`;
- Fase 1: `EN PROGRESO`;
- `TASK-001`: cerrada;
- `CORR-001`: cerrada;
- `TASK-002`: cerrada;
- `TASK-003`: cerrada;
- `TASK-004`: cerrada;
- `TASK-005`: cerrada bajo la sustitución operativa de `CORR-002`;
- `CORR-002`: cerrada e incorporada canónicamente;
- implementación corregida de `TASK-005`: cerrada mediante `f1a13cc chore: add Supabase Cloud development baseline`;
- proyecto Supabase Cloud Development: creado;
- login de CLI: ejecutado manualmente por Francisco;
- link al proyecto Development: ejecutado manualmente por Francisco;
- Codex: sin credenciales y sin operaciones remotas;
- schema funcional: inexistente;
- `db push`: no ejecutado;
- Staging: inexistente;
- Production: inexistente;
- Fase 2: no iniciada.

# 7. Inconsistencia detectada

`docs/product/11-phase-1-scope-entry-gate.md` conserva expresiones que, tomadas literalmente como criterios vigentes, exigen todavía:

- `Supabase local` como infraestructura de desarrollo obligatoria;
- `Supabase local arrancable/configurable` como resultado esperado;
- configuración local de Supabase como objetivo de Fase 1;
- comandos de arranque/parada del entorno local;
- servicios locales arrancando correctamente;
- documentación para arrancar Supabase local;
- `Supabase local configurable/arrancable` como condición de cierre funcional de Fase 1;
- documentación y configuración de Supabase local como entregables;
- `Paso 6 — Supabase local` basado en lifecycle local;
- `Supabase local operativo` como verificación del paso final de Fase 1;
- riesgos y controles redactados suponiendo que la infraestructura Supabase de Fase 1 es necesariamente local.

Estas condiciones eran coherentes con la estrategia original de `TASK-005`, pero quedaron obsoletas exclusivamente en su dimensión operativa después de `CORR-002`.

La inconsistencia es documental, no funcional ni arquitectónica.

# 8. Decisión de sincronización

Se decide preparar una modificación documental mínima y posterior sobre:

`docs/product/11-phase-1-scope-entry-gate.md`

para sustituir exclusivamente los criterios operativos de `Supabase local / Docker / start-status-stop` por el baseline ya aprobado de Supabase Cloud Development.

La sincronización futura deberá cumplir simultáneamente estas reglas:

1. mantener exactamente el nombre normativo de Fase 1:
   `Fase 1 — Setup, repositorio, CI y Supabase local`;
2. tratar ese nombre como el nombre histórico/normativo aprobado de la fase, no como obligación de conservar un stack local después del override de `CORR-002`;
3. no modificar el propósito general de Fase 1;
4. no modificar el orden general de fases;
5. no ampliar capacidades funcionales;
6. no introducir schema de producto;
7. no introducir integración de aplicación con Supabase;
8. no introducir Auth, tenancy ni RLS;
9. no adelantar CI;
10. no iniciar Fase 2;
11. reconocer `CORR-002` como override operativo posterior de `TASK-005`;
12. preservar `TASK-005` como registro histórico de la estrategia original.

# 9. Alcance exacto

La corrección futura afecta únicamente las partes de `docs/product/11-phase-1-scope-entry-gate.md` cuyo significado dependa materialmente de que Supabase deba ejecutarse localmente mediante Docker.

La sincronización comprende, cuando aparezcan en el documento afectado:

- propósito de Fase 1 referido a Supabase local como infraestructura obligatoria;
- resultado esperado referido a Supabase local arrancable/configurable;
- objetivo de configuración de Supabase local;
- sección específica de Supabase en Fase 1;
- decisiones físicas permitidas relacionadas con configuración local de Supabase;
- documentación requerida para arrancar Supabase local;
- verificaciones del entorno Supabase local;
- frontera Fase 1/Fase 2 cuando exija Supabase local arrancable;
- entregables de Supabase local;
- secuencia de implementación del `Paso 6`;
- smoke/revisión final que exija Supabase local operativo;
- riesgos o controles que presupongan Docker/lifecycle local como condición obligatoria;
- declaraciones finales de alcance que enumeren Supabase local como capacidad operativa obligatoria.

No se autoriza una reescritura general del Gate.

# 10. Elementos preservados

La sincronización debe preservar sin cambio semántico:

- nombre normativo de Fase 1;
- objetivo de Fase 1;
- posición de Fase 1 dentro del orden del proyecto;
- orden general de trabajo de Fase 1;
- frontera Fase 1 / Fase 2;
- Fase 1 como setup técnico y operativo;
- ausencia de bounded contexts funcionales en Fase 1;
- ausencia de schema físico de producto en Fase 1;
- ausencia de migrations funcionales de producto en Fase 1;
- ausencia de Auth funcional;
- ausencia de tenancy funcional;
- ausencia de RLS ejecutable;
- ausencia de Storage funcional;
- ausencia de Realtime funcional desde la aplicación;
- ausencia de integración funcional de la aplicación con Supabase;
- monolito modular y fronteras de `ADR-0001`;
- `MaintenanceCompany` como tenant y todas las restricciones futuras de `ADR-0002`;
- Supabase PostgreSQL como futura source of truth remota del producto;
- RLS obligatoria cuando exista dato tenant-owned;
- uso restringido de `service-role`;
- CI como paso separado de Fase 1;
- Gate de salida de Fase 1;
- Gate independiente de entrada a Fase 2;
- `ADR-0003` y sus dependencias pendientes conforme al estado vigente;
- todos los `DO-*` y `*-OPEN-*` vigentes;
- ADR bloqueados y diferidos existentes;
- prohibición de adelantar capacidades de Fase 2+.

# 11. Elementos reemplazados

La futura modificación de `11` debe reemplazar únicamente conceptos equivalentes a los siguientes:

| Criterio obsoleto | Criterio sincronizado |
|---|---|
| Supabase local obligatorio | Baseline Supabase de Development conforme a `CORR-002` |
| runtime Docker-compatible obligatorio | Docker no requerido para el workflow aprobado |
| stack local arrancable | un único proyecto Supabase Cloud exclusivo de Development, creado manualmente |
| `supabase start` obligatorio | no requerido |
| `supabase status` sobre stack local obligatorio | no requerido |
| `supabase stop` obligatorio | no requerido |
| health checks del stack local como Gate | no requeridos |
| configuración local destinada a levantar servicios | Supabase CLI reproducible + `supabase/` inicializado + `supabase/config.toml` versionado |
| prohibición absoluta de Supabase Cloud | Development Cloud aprobado exclusivamente para este workflow |
| prohibición absoluta de `login`/`link` | `login`/`link` permitidos únicamente como operaciones manuales de Francisco |
| Supabase local operativo como evidencia de cierre | baseline Development configurado sin schema funcional ni integración de aplicación |

La sustitución no transforma Fase 1 en una fase de despliegue, datos o backend funcional.

# 12. Nuevo criterio Supabase para Fase 1

Después de la futura sincronización, el componente Supabase del Gate de Fase 1 debe considerarse satisfecho cuando se conserve el siguiente baseline aprobado:

1. Supabase CLI forma parte del proyecto como tooling reproducible y pinneado.
2. `supabase/` está correctamente inicializado en la raíz del repositorio.
3. `supabase/config.toml` está presente y versionado.
4. Estado temporal, sesiones y credenciales de la CLI permanecen fuera de Git.
5. Existe exactamente un proyecto Supabase Cloud destinado exclusivamente a `Development` para este workflow.
6. El proyecto Development fue creado manualmente.
7. El proyecto Development fue linked manualmente por Francisco.
8. Login y link permanecen bajo operación manual de Francisco.
9. Codex no posee credenciales, tokens, passwords ni acceso remoto a Supabase.
10. Las operaciones remotas permanecen manuales y bajo responsabilidad de Francisco salvo una decisión posterior explícita.
11. Docker no es requisito del workflow aprobado.
12. No se exige ni utiliza un lifecycle local `start/status/stop` como Gate de Fase 1.
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
26. La existencia nativa de capacidades administradas de Supabase en el proyecto Development no equivale a implementar esas capacidades en el producto.

Este criterio reemplaza únicamente la condición operativa de infraestructura Supabase de Fase 1.

No crea una migration vacía, schema artificial ni operación remota ficticia para demostrar funcionamiento.

# 13. Relación con TASK-005

`docs/tasks/TASK-005-supabase-local.md` debe permanecer sin modificaciones como registro histórico de la estrategia originalmente aprobada.

`TASK-005` conserva valor documental porque registra:

- el objetivo original del Paso 6;
- la separación entre infraestructura y dominio;
- los límites de no schema/no Auth/no tenancy/no RLS;
- la estrategia inicial basada en Supabase local;
- el bloqueo que posteriormente motivó `CORR-002`.

`CORR-003` no reescribe, corrige retroactivamente ni borra `TASK-005`.

Ante un conflicto entre el método local de `TASK-005` y el método posterior de `CORR-002`, prevalece `CORR-002` exclusivamente dentro del alcance operativo que sustituyó.

# 14. Relación con CORR-002

`docs/tasks/CORR-002-supabase-cloud-development.md` es el override operativo posterior que fundamenta esta sincronización.

`CORR-003` no modifica ni amplía `CORR-002`.

Consume como ya decididas las siguientes reglas:

- Supabase continúa siendo el proveedor previsto;
- la CLI continúa siendo reproducible desde el repositorio;
- Docker deja de ser requisito del workflow aprobado;
- existe un único proyecto Cloud exclusivo de Development;
- Francisco ejecuta manualmente operaciones autenticadas/remotas;
- Codex permanece sin acceso remoto ni credenciales;
- migrations Git serán la futura fuente de verdad de evolución de schema cuando una fase posterior autorice schema;
- no existe schema funcional en Fase 1;
- no existe integración de aplicación;
- no existen Staging ni Production;
- CI permanece separado;
- la inconsistencia de `11` debe sincronizarse antes de continuar con el siguiente paso de Fase 1.

`CORR-003` es la corrección documental destinada a cumplir ese último requisito.

# 15. Relación con CI

CI continúa siendo el siguiente paso técnico pendiente de Fase 1 después del cierre de esta sincronización documental.

`CORR-003` no define, diseña ni implementa CI.

En particular, no autoriza:

- crear `TASK-006`;
- crear workflows de GitHub Actions;
- seleccionar eventos de trigger de CI;
- introducir Supabase GitHub Integration;
- introducir credenciales Supabase en CI;
- introducir `SUPABASE_ACCESS_TOKEN` en CI;
- introducir database password en CI;
- introducir project ref como secreto de CI;
- automatizar migrations;
- ejecutar `db push` desde CI;
- desplegar a Development, Staging o Production desde CI.

El Gate obligatorio es:

`CORR-003 cerrada`
→ recién entonces preparar separadamente el siguiente paso técnico de Fase 1: CI.

# 16. Relación con Fase 2

`CORR-003` no inicia ni prepara implementación funcional de Fase 2.

Continúan fuera de alcance:

- identidad;
- Supabase Auth funcional;
- onboarding de usuarios;
- `PlatformUser` físico;
- `CompanyMembership` físico;
- roles físicos;
- `UserClientAccess` físico;
- tenancy funcional;
- tenant resolution implementada;
- schema de producto;
- tablas;
- policies RLS;
- funciones/helper de autorización;
- `SupportAccessGrant` físico;
- clientes;
- ubicaciones;
- equipos;
- formularios;
- mantenimientos;
- evidencias;
- reporting;
- IA;
- pagos.

Completar esta corrección documental no autoriza automáticamente comenzar Fase 2.

Los Gate y ADR pendientes para Fase 2 permanecen íntegramente preservados.

# 17. Seguridad

Esta corrección no reduce ninguna garantía de seguridad futura del producto.

Durante la futura modificación documental de `11` deben quedar explícitamente preservadas estas invariantes:

1. ningún secreto debe incorporarse a Git;
2. ningún token, password o credential storage debe incorporarse a `/docs`;
3. `supabase/.temp/` y estado temporal equivalente permanecen fuera de Git;
4. Codex no recibe credenciales de Supabase;
5. Codex no ejecuta operaciones remotas de Supabase bajo la frontera vigente;
6. Francisco conserva la responsabilidad de login/link y demás operaciones remotas autorizadas;
7. `service-role` no se introduce en la aplicación ni en esta corrección;
8. la existencia de un proyecto Development no implementa autorización ni aislamiento por sí sola;
9. `MaintenanceCompany` continúa siendo el tenant del producto;
10. RLS continúa siendo obligatoria cuando una fase posterior cree datos tenant-owned;
11. el frontend continúa sin ser autoridad de tenancy;
12. no se crea ninguna relación, schema o dato tenant-owned en esta corrección.

La sincronización documental no puede presentar el proyecto Development como sustituto de RLS, tenant ownership o autorización.

# 18. Dentro de alcance

Está dentro de alcance de `CORR-003`:

- documentar la inconsistencia actual de `11`;
- establecer el criterio documental que debe sustituir Supabase local/Docker;
- reconocer `CORR-002` como override operativo posterior;
- preservar `TASK-005` como histórico;
- especificar el baseline Supabase Cloud Development que debe reflejar el Gate;
- declarar Docker no requerido;
- declarar operaciones remotas manuales;
- preservar ausencia de schema funcional;
- preservar ausencia de migrations funcionales de Fase 1;
- preservar ausencia de integración de aplicación;
- preservar ausencia de Auth/tenancy/RLS/Storage/Realtime funcional;
- preservar ausencia de Staging y Production;
- preservar CI como siguiente paso separado;
- analizar si esta sincronización requiere ADR;
- definir criterios de aceptación y Gate para una futura modificación mínima de `11`.

# 19. Fuera de alcance

Queda fuera de alcance:

- modificar ahora `docs/product/11-phase-1-scope-entry-gate.md`;
- modificar cualquier otro archivo del repositorio;
- modificar `TASK-005`;
- modificar `CORR-002`;
- modificar `00-master-product-brief.md`;
- renombrar Fase 1;
- modificar `01-product-definition.md`;
- modificar `10-architecture-decisions-records.md`;
- modificar ADR aceptados;
- crear un ADR nuevo;
- cambiar arquitectura;
- cambiar proveedor;
- cambiar modelo multiempresa;
- ampliar Fase 1;
- crear `TASK-006`;
- diseñar o configurar CI;
- ejecutar Git en esta entrega;
- ejecutar Codex en esta entrega;
- ejecutar comandos Supabase;
- ejecutar operaciones remotas;
- ejecutar `db push`;
- crear migrations funcionales;
- crear schema;
- crear Auth;
- crear tenancy;
- crear RLS;
- crear Storage funcional;
- crear Realtime funcional;
- crear Staging;
- crear Production;
- iniciar Fase 2;
- implementar cualquier bounded context funcional.

# 20. Archivo a modificar posteriormente

La única ruta normativa que `CORR-003` podrá modificar posteriormente, mediante autorización separada de la modificación documental, es:

`docs/product/11-phase-1-scope-entry-gate.md`

No se autoriza en esta corrección modificar simultáneamente otro archivo para “armonizar” redacciones relacionadas.

Si durante la futura implementación se detecta una contradicción material fuera de `11`, debe detenerse la modificación y abrirse una revisión documental separada; no debe ampliarse `CORR-003` por inferencia.

# 21. Restricciones de implementación

Cuando `CORR-003` haya sido incorporada canónicamente y exista autorización separada para modificar `11`, la futura modificación de `11` deberá cumplir estas restricciones:

1. utilizar como base exacta el archivo canónico vigente `docs/product/11-phase-1-scope-entry-gate.md`;
2. modificar únicamente frases, bullets, headings o controles cuyo significado dependa de Supabase local/Docker;
3. preservar el nombre normativo de Fase 1;
4. preservar el objetivo y fronteras de Fase 1;
5. preservar el orden general de pasos;
6. sustituir el contenido operativo del Paso 6 sin convertirlo en una nueva fase;
7. preservar Paso 7 como CI separado;
8. preservar el Gate de Fase 2;
9. no resolver `ADR-0003`, `DO-T03` ni ningún otro `DO-*`/`*-OPEN-*`;
10. no modificar el estado de ADR bloqueados o diferidos;
11. no introducir schema, SQL, migrations funcionales ni RLS;
12. no introducir variables Supabase de aplicación;
13. no introducir cliente Supabase de aplicación;
14. no introducir secretos, project refs, passwords ni tokens;
15. no introducir comandos remotos como obligación automática;
16. no convertir `db push` en criterio de Fase 1;
17. no introducir Staging ni Production;
18. no introducir CI dentro del mismo diff salvo referencias ya existentes que deban preservarse;
19. no modificar otro archivo;
20. revisar el diff completo y verificar que la corrección sea estrictamente documental;
21. verificar que no quede una exigencia material de Docker/lifecycle local fuera de referencias históricas necesarias;
22. verificar que no se haya eliminado accidentalmente ninguna prohibición de Fase 2+;
23. verificar que el Gate siga permitiendo evaluar Fase 1 sin afirmar que Fase 1 está completada;
24. no generar automáticamente el siguiente paso después del cierre.

# 22. Criterios de aceptación

`CORR-003` sólo podrá considerarse implementada satisfactoriamente cuando se cumplan todos los siguientes criterios:

1. `CORR-003` fue revisada y aprobada humanamente antes de modificar `11`;
2. `CORR-003` fue incorporada canónicamente en `docs/tasks/CORR-003-phase-1-gate-supabase-cloud.md`;
3. la única especificación normativa modificada por la implementación es `docs/product/11-phase-1-scope-entry-gate.md`;
4. el nombre `Fase 1 — Setup, repositorio, CI y Supabase local` permanece intacto;
5. el propósito general de Fase 1 permanece intacto;
6. la frontera Fase 1/Fase 2 permanece intacta;
7. CI permanece como paso separado y pendiente;
8. `TASK-005` permanece intacta como histórico;
9. `CORR-002` permanece intacta y reconocida como override operativo posterior;
10. el Gate ya no exige Docker;
11. el Gate ya no exige runtime Docker-compatible;
12. el Gate ya no exige `supabase start`;
13. el Gate ya no exige `supabase status` sobre stack local;
14. el Gate ya no exige `supabase stop`;
15. el Gate ya no exige health checks del stack local;
16. el Gate ya no exige Supabase local operativo/configurable/arrancable como condición material de cierre;
17. el Gate reconoce Supabase CLI reproducible y pinneada;
18. el Gate reconoce `supabase/` inicializado;
19. el Gate reconoce `supabase/config.toml` versionado;
20. el Gate exige que estado temporal y credenciales permanezcan fuera de Git;
21. el Gate reconoce exactamente un proyecto Supabase Cloud exclusivo de Development;
22. el Gate reconoce que login/link fueron y permanecen operaciones manuales de Francisco bajo la frontera vigente;
23. el Gate mantiene Codex sin credenciales ni acceso remoto;
24. el Gate mantiene operaciones remotas manuales;
25. `db push` no aparece como requisito de Fase 1;
26. no existe schema funcional exigido ni introducido;
27. no existen migrations funcionales de producto exigidas ni introducidas;
28. no existe integración funcional de la aplicación con Supabase;
29. no existe Auth funcional;
30. no existe tenancy funcional;
31. no existe RLS ejecutable;
32. no existe Storage funcional de producto;
33. no existe Realtime funcional desde la aplicación;
34. no existe Staging;
35. no existe Production;
36. no se introdujo `service-role`;
37. no se cambió arquitectura;
38. no se cambió alcance funcional de Fase 1;
39. no se inició Fase 2;
40. no se creó `TASK-006`;
41. no se diseñó ni configuró CI;
42. no se resolvió ningún `DO-*` ni `*-OPEN-*`;
43. no se modificó ningún ADR aceptado;
44. la revisión final del diff confirma que todos los cambios son necesarios para sincronizar la condición Supabase y no para reescribir el Gate;
45. la revisión humana confirma que Fase 1 continúa `EN PROGRESO` y que el siguiente paso técnico pendiente es CI.

## Verificaciones documentales obligatorias

La revisión del diff futuro debe comprobar literalmente, como mínimo:

- búsqueda de `Supabase local` para distinguir nombre histórico de fase frente a criterios operativos obsoletos;
- búsqueda de `Docker` y `Docker-compatible`;
- búsqueda de `supabase start`;
- búsqueda de `supabase status`;
- búsqueda de `supabase stop`;
- búsqueda de `arrancable`, `configurable` y `operativo` en relación con stack local;
- búsqueda de `db push` para confirmar que no se convirtió en requisito;
- búsqueda de `Staging` y `Production` para confirmar su exclusión;
- búsqueda de `schema`, `migration`, `Auth`, `tenancy`, `RLS`, `Storage`, `Realtime` para confirmar que continúan fuera de Fase 1 funcional;
- revisión del orden de pasos para confirmar que CI continúa separado y posterior a la sincronización documental;
- revisión del Gate de Fase 2 para confirmar que permanece cerrado hasta satisfacer sus requisitos propios.

# 23. Definition of Done

`CORR-003` estará `DONE` únicamente después de completar todo el siguiente ciclo:

- especificación `CORR-003` revisada y aprobada;
- incorporación canónica de `CORR-003` en su ruta de tarea;
- modificación mínima de `docs/product/11-phase-1-scope-entry-gate.md`;
- diff documental revisado;
- confirmación de que no se modificó otro archivo fuera de la incorporación canónica de `CORR-003` y el `11` afectado conforme al proceso aprobado;
- confirmación de que no cambió arquitectura;
- confirmación de que no cambió alcance de Fase 1;
- confirmación de que no se introdujo Fase 2;
- confirmación de que no se generó `TASK-006`;
- confirmación de que no se configuró CI;
- commit/push del cambio documental conforme al workflow humano aprobado;
- revisión final posterior al commit/push;
- cierre humano explícito de `CORR-003`.

En la presente entrega esta Definition of Done **NO está satisfecha**.

Estado actual:

`APPROVED FOR IMPLEMENTATION`

# 24. ADR requerido

**Decisión:**

`ADR nuevo NO requerido`

## Justificación

Esta sincronización no toma una decisión arquitectónica nueva.

La decisión técnica que sustituyó Supabase local/Docker por Supabase Cloud Development ya fue formalizada en `CORR-002`.

`CORR-003` sólo actualiza un Gate documental que quedó obsoleto respecto de esa decisión posterior.

No cambia:

- monolito modular de `ADR-0001`;
- un único deployable principal de aplicación;
- proveedor Supabase;
- Supabase PostgreSQL como futura source of truth remota;
- modelo de tenancy de `ADR-0002`;
- `MaintenanceCompany` como tenant;
- estrategia shared PostgreSQL entre tenants del MVP;
- tenant ownership;
- tenant resolution;
- RLS obligatoria;
- integridad cross-tenant;
- uso restringido de `service-role`;
- schema;
- autorización funcional;
- fases de producto;
- despliegue productivo.

La referencia de `ADR-0002` a que una modificación relevante de la estrategia de tenancy —incluidos proyectos Supabase dedicados cuando impliquen una nueva estrategia de aislamiento— requeriría un ADR nuevo no se activa aquí: el único proyecto Cloud definido por `CORR-002` es un entorno compartido de `Development` para el workflow de desarrollo y no un proyecto por tenant, database-per-tenant, schema-per-tenant ni una nueva frontera de tenancy.

El registro maestro además establece que las decisiones técnicas menores y reversibles no requieren ADR y advierte contra generar ADR triviales.

Por tanto, la corrección documental de consistencia no justifica un ADR adicional.

## Condición de reevaluación

Debe reevaluarse un ADR sólo si una decisión posterior pretende cambiar materialmente la arquitectura, por ejemplo:

- convertir Cloud-only en política arquitectónica transversal permanente para todos los entornos y desarrolladores;
- cambiar la estrategia de tenancy mediante proyectos separados por tenant;
- introducir Staging/Production y una topología de entornos con consecuencias arquitectónicas materiales;
- automatizar migrations/deployments remotos con una nueva frontera de seguridad;
- sustituir Supabase;
- alterar el modelo de shared PostgreSQL, tenant ownership o RLS.

Nada de lo anterior forma parte de `CORR-003`.

# 25. Gate posterior

El Gate posterior de esta corrección es:

`CORR-003 APPROVED FOR IMPLEMENTATION`
→ incorporación canónica de `CORR-003`
→ autorización separada de la modificación documental
→ modificación mínima de `docs/product/11-phase-1-scope-entry-gate.md`
→ revisión del diff documental
→ confirmación de arquitectura/seguridad/alcance
→ commit/push
→ revisión posterior al commit/push
→ cierre formal de `CORR-003`
→ recién entonces preparar el siguiente paso técnico de Fase 1: CI.

Antes del cierre de `CORR-003` queda expresamente prohibido:

- generar `TASK-006`;
- diseñar CI;
- configurar CI;
- introducir secretos Supabase en CI;
- automatizar migrations;
- ejecutar `db push` como requisito de Fase 1;
- iniciar Fase 2;
- crear schema o capacidades funcionales.

Un `PASS` documental de la futura modificación de `11` no constituye autorización implícita para ejecutar el siguiente paso.

# 26. Resultado esperado

Después de una futura implementación y cierre satisfactorios de `CORR-003`:

- `CORR-003` estará canónica y cerrada;
- `docs/product/11-phase-1-scope-entry-gate.md` estará sincronizado con `CORR-002`;
- el nombre de Fase 1 permanecerá intacto;
- el alcance funcional de Fase 1 permanecerá intacto;
- Supabase local dejará de ser una condición operativa obligatoria del Gate;
- Docker dejará de ser requisito del Gate;
- el baseline reconocido será Supabase CLI reproducible + `supabase/` + `supabase/config.toml` + un único proyecto Cloud exclusivo de Development + operación remota manual por Francisco;
- Codex continuará sin credenciales ni acceso remoto;
- no existirá schema funcional;
- no existirán migrations funcionales de producto de Fase 1;
- no se habrá ejecutado `db push` como parte de esta corrección;
- la aplicación continuará sin integración funcional con Supabase;
- no existirá Auth funcional;
- no existirá tenancy funcional;
- no existirá RLS ejecutable;
- no existirá Storage funcional de producto;
- no existirá Realtime funcional desde la aplicación;
- no existirá Staging;
- no existirá Production;
- Fase 1 continuará en progreso hasta completar sus pasos restantes;
- Fase 2 continuará sin iniciar;
- CI continuará siendo el siguiente paso técnico pendiente de Fase 1;
- `TASK-006` todavía no habrá sido generada por `CORR-003`.

**Estado final de esta especificación en la presente entrega:** `APPROVED FOR IMPLEMENTATION`.

**Cambio de arquitectura:** no.

**Cambio de alcance de Fase 1:** no.

**Supabase local obligatorio después de la futura sincronización:** no.

**Supabase Cloud Development reconocido:** sí.

**Docker requerido:** no.

**Fase 2 iniciada:** no.

**ADR requerido:** no.

**Codex ejecutado durante esta preparación:** no.

**TASK-006 generada:** no.
