# CORR-015 — Sincronización documental posterior a la aceptación de ADR-0019

## 1. Identificación

**ID:** `CORR-015`

**Título:** `CORR-015 — Sincronización documental posterior a la aceptación de ADR-0019`

**Tipo:** `CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO ARQUITECTÓNICO`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**CORR-015 SPECIFICATION:** `PASS`

**CORR-015 SPEC REVIEW:** `APPROVED`

**CORR-015 HUMAN APPROVAL:** `APPROVED`

**Archivo de entrega:**

`CORR-015-adr-0019-accepted-state-sync-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/CORR-015-adr-0019-accepted-state-sync.md`

**Naturaleza:** exclusivamente documental.

**Implementación realizada:** `NO`

**Repositorio modificado durante esta preparación:** `NO`

**Supabase Cloud modificado:** `NO`

**Codex utilizado:** `NO`

**Canonicalización realizada:** `NO`

**Git add / commit / push realizados:** `NO / NO / NO`

Este documento especifica una corrección documental futura y ha sido aprobado para una futura ejecución. `APPROVED FOR IMPLEMENTATION` no autoriza esa ejecución: todavía requiere revisión del artefacto aprobado, canonicalización, incorporación Git de la especificación y autorización humana separada de ejecución. No ejecuta la corrección, no modifica el canon y no autoriza implementación de `TASK-013`.

---

## 2. Objetivo único

CORR-015 tiene un único objetivo:

> sincronizar de forma mínima y controlada el canon documental de producto con la aceptación e incorporación canónica de `ADR-0019 — VerificationChallenge, Supabase Auth y frontera de establecimiento de sesión`, preservando íntegramente las fronteras de seguridad, multitenancy, RLS y gobernanza ya aprobadas.

La regla central es:

```text
sincronizar estado arquitectónico aceptado
!=
implementar E2
!=
desbloquear automáticamente TASK-013
```

CORR-015 no crea la decisión arquitectónica. Consume una decisión ya aceptada e incorporada al canon.

CORR-015 no corrige ni reescribe `TASK-013`. La revisión/corrección futura de `TASK-013` constituye un Gate posterior separado.

---

## 3. Contexto formal y estado autoritativo consumido

Se consume como estado formal cerrado:

```text
Fase 2 = INICIADA

ADR-0019 ARCHITECTURE REVIEW = APPROVED
ADR-0019 DOCUMENT CORRECTION REVIEW = APPROVED
ADR-0019 SECOND REVIEW = APPROVED
ADR-0019 HUMAN APPROVAL = APPROVED
ADR-0019 DOCUMENT APPROVAL REVIEW = APPROVED

ADR-0019 = ACCEPTED

ADR-0019 CANONICALIZATION REVIEW = APPROVED
ADR-0019 CANONICALIZATION = COMPLETED

ADR-0019 STAGING REVIEW = APPROVED
ADR-0019 STAGING = COMPLETED

ADR-0019 COMMIT REVIEW = APPROVED
ADR-0019 COMMIT = COMPLETED

ADR-0019 PUSH REVIEW = APPROVED
ADR-0019 PUSH = COMPLETED
```

Commit canónico publicado:

```text
b8cab87e72e907eb54f9c2567636b29de0d1e73e
```

Ruta canónica:

`docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`

SHA-256 canónico:

```text
41a2f5fcd57ca26fd52ca318fc2714c5188e9c03ab5f3d58ab55f92bd98b5e09
```

Decisión arquitectónica aceptada:

```text
E2 — APPLICATION-OWNED VERIFICATION CHALLENGE
+ ONE-TIME SESSION GRANT
+ SERVER-ONLY TECHNICAL PASSWORD BRIDGE
+ CUSTOM ACCESS TOKEN HOOK GATE
```

Estado de `TASK-013` que debe preservarse:

```text
TASK-013 DETERMINATION = APPROVED
TASK-013 determinada = SÍ
TASK-013 generada = SÍ
TASK-013 SPEC REVIEW = APPROVED AS BLOCKED
TASK-013 SPECIFICATION =
BLOCKER — ARCHITECTURE DECISION REQUIRED

TASK-013 implementación autorizada = NO
TASK-013 implementada = NO
```

El blocker anterior forma parte de la especificación histórica revisada de `TASK-013`. La aceptación posterior de ADR-0019 no autoriza a CORR-015 a reescribir retrospectivamente ese documento ni a declarar su implementación autorizada.

Debe continuar:

```text
Auth funcional = NO

TASK-014 determinada = NO
TASK-014 generada = NO
```

---

## 4. Fuentes de verdad

La futura ejecución debe tratar como fuente de verdad al repositorio real y a los documentos canónicos vigentes.

### 4.1 Fuentes obligatorias que deben leerse íntegramente

```text
docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md

docs/product/03-permissions-rls-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

### 4.2 Contexto normativo necesario

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md
docs/product/02-domain-model.md

docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md

docs/tasks/TASK-013-verification-challenge-foundation.md
```

La conversación histórica no sustituye el canon.

Una futura ejecución debe detenerse si una fuente obligatoria falta, no es canónica, presenta identidad incompatible o contradice materialmente el estado formal consumido por esta especificación.

---

## 5. Revisión de coherencia previa

La revisión documental realizada para esta especificación no detecta una contradicción material que obligue a ampliar el scope de CORR-015.

Se preservan como invariantes:

```text
tenant = MaintenanceCompany

authenticated != authorized

valid Auth session != tenant authorization

RLS = primary remote isolation boundary para datos tenant-owned

service-role / secret key != ordinary request client

SUPER_ADMIN global != tenant member
```

ADR-0019 añade una excepción Auth estrecha y purpose-specific para el lifecycle Identity/Auth aprobado. Esa excepción no modifica el modelo de autorización tenant de ADR-0002/ADR-0003 y no convierte estado Auth platform-owned en datos tenant-owned.

Resultado de expansión de scope:

```text
CORR-015 SPECIFICATION SCOPE EXPANSION REQUIRED = NO
```

---

## 6. Clasificación documental

La auditoría de las fuentes disponibles produce la siguiente clasificación.

### 6.1 `CHANGE REQUIRED`

```text
docs/product/03-permissions-rls-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

Cantidad:

```text
CHANGE REQUIRED = 3
```

### 6.2 `NO CHANGE REQUIRED`

```text
docs/product/02-domain-model.md
```

ADR-0019 determinó expresamente que `02-domain-model.md` no requiere actualización. `VerificationChallenge` ya es conceptualmente platform-owned y CORR-015 no debe agregar `SessionGrant` al modelo conceptual de producto.

### 6.3 Fuentes de contexto / preservación

Los siguientes documentos se consumen para coherencia y no forman parte del diff autorizado de CORR-015:

```text
docs/product/00-master-product-brief.md
docs/product/01-product-definition.md

docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md

docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md
docs/tasks/TASK-013-verification-challenge-foundation.md
```

No se detecta dentro de esta revisión una modificación material obligatoria adicional de producto.

Si una futura auditoría demuestra que otro documento de producto requiere obligatoriamente una modificación material para mantener coherencia, el resultado será:

```text
CORR-015 SPECIFICATION = BLOCKER — SCOPE EXPANSION REQUIRED
```

No se incorporará ese archivo por inferencia.

---

## 7. Alcance exacto

CORR-015 autoriza exclusivamente especificar una futura modificación documental mínima de:

```text
docs/product/03-permissions-rls-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

La futura ejecución debe:

1. releer el canon vigente;
2. repetir el preflight Git;
3. auditar referencias materiales;
4. clasificar cada referencia como activa, histórica/gobernanza o inesperada;
5. aplicar únicamente las modificaciones necesarias descritas en §§8–10;
6. conservar el diff estrictamente documental;
7. dejar los cambios sin staging para revisión humana.

No se autoriza reescritura general de ninguno de los tres documentos.

---

## 8. Cambio esperado — `03-permissions-rls-strategy.md`

### 8.1 Objetivo del cambio

Registrar de forma mínima la excepción Auth aprobada por ADR-0019 sin debilitar la estrategia tenant existente.

Debe quedar conceptualmente explícito:

```text
VerificationChallenge = platform-owned
SessionGrant = platform-owned
```

Esas entidades pertenecen al lifecycle de Identity/Auth de plataforma y no se convierten en tenant-owned para reutilizar artificialmente RLS tenant.

### 8.2 Frontera Auth aprobada

La estrategia debe reconciliar expresamente que la frontera Auth aprobada puede requerir:

```text
Postgres Custom Access Token Hook
+
permisos explícitos mínimos a supabase_auth_admin
+
Auth Admin purpose-specific
```

exclusivamente para el lifecycle Identity/Auth aprobado por ADR-0019.

La redacción debe dejar claro que:

- `supabase_auth_admin` sólo puede recibir el acceso estrictamente necesario al estado platform-owned requerido por el hook;
- esos permisos no son privilegios tenant;
- el Auth Admin boundary queda restringido a las operaciones purpose-specific aprobadas por ADR-0019;
- no existe un Supabase Admin client genérico reutilizable por módulos arbitrarios;
- una secret key/backend credential nunca se convierte en client ordinario de requests;
- la frontera privilegiada no obtiene lectura/escritura genérica de datos tenant.

### 8.3 Invariantes que deben permanecer sin cambio

Debe preservarse:

```text
RLS = primary remote isolation boundary para datos tenant-owned
```

Debe preservarse:

```text
service-role / secret key
!=
ordinary request client
```

Debe preservarse:

```text
authenticated != authorized
```

Y debe quedar inequívoco:

```text
valid Auth session
!=
CompanyMembership
!=
tenant role
!=
Client scope
```

Una sesión Supabase Auth válida no concede por sí sola:

- membership tenant;
- tenant;
- rol vigente;
- `UserClientAccess`;
- `SupportAccessGrant`;
- permiso funcional;
- acceso a recursos tenant-owned.

### 8.4 Prohibiciones expresas

La actualización debe prohibir utilizar la excepción Auth para:

- reads tenant ordinarios;
- writes tenant ordinarios;
- bypass de RLS tenant;
- inferir `CompanyMembership`;
- inferir `Client` scope;
- convertir `SUPER_ADMIN` en tenant member;
- crear un Supabase privileged client genérico para módulos arbitrarios;
- entregar credenciales privilegiadas al browser/PWA;
- tratar `supabase_auth_admin` como actor tenant;
- sustituir ADR-0003 por claims o sesión Auth.

### 8.5 Naturaleza del cambio

La futura edición es conceptual/documental.

No debe incluir:

- SQL;
- `GRANT`/`REVOKE` ejecutable;
- `CREATE POLICY`;
- función PostgreSQL;
- migration;
- configuración aplicada de Auth Hook;
- secret configuration.

---

## 9. Cambio esperado — `10-architecture-decisions-records.md`

### 9.1 Incorporación de ADR-0019

El registro maestro debe incorporar explícitamente:

```text
ADR-0019
VerificationChallenge, Supabase Auth y frontera de establecimiento de sesión
Status = ACCEPTED
```

La descripción compacta de la decisión debe preservar el sentido de:

```text
application-owned VerificationChallenge
+ one-time SessionGrant
+ server-only technical password bridge
+ Custom Access Token Hook gate
```

Debe registrarse expresamente:

```text
ADR-0019 ACCEPTED
!=
TASK-013 implementation authorized
```

### 9.2 Catálogo original frente a catálogo vigente

ADR-0019 no formaba parte del catálogo original `ADR-0001..ADR-0018`.

La futura actualización no debe borrar esa realidad histórica. Debe distinguir, donde corresponda:

```text
catálogo original = 18 ADR
catálogo vigente después de ADR-0019 = 19 ADR
```

La frase activa equivalente a:

```text
Se proponen 18 ADR definitivos
```

no puede permanecer como única descripción del catálogo vigente una vez incorporado ADR-0019.

Debe actualizarse de forma mínima para conservar simultáneamente:

- la existencia histórica de 18 ADR originales;
- la incorporación posterior de ADR-0019;
- el total vigente de 19.

### 9.3 Distribución global vigente

Con ADR-0019 incorporado como `ACCEPTED` y sin modificar los estados previos de ADR-0001…ADR-0018, la distribución global vigente debe quedar coherente con:

```text
TOTAL ADR VIGENTE = 19

ACCEPTED = 8
READY TO DRAFT = 0
BLOCKED BY OPEN DECISIONS = 8
DEFERRED = 3
```

La futura ejecución debe auditar todas las estadísticas, totales, resúmenes y frases globales dependientes del número o distribución de ADR y modificar únicamente las realmente stale.

### 9.4 Estados que no deben cambiar

No se modifica por CORR-015 el estado de ningún ADR `ADR-0001..ADR-0018`.

En particular, la aceptación de ADR-0019 no resuelve por inferencia:

- ADR bloqueados por OPEN;
- ADR diferidos;
- ningún `DO-*`;
- ningún `*-OPEN-*`.

### 9.5 Snapshots históricos a preservar

Deben preservarse los bloques que describen legítimamente el Gate de Fase 0, especialmente cuando indican que los seis ADR originalmente `READY TO DRAFT` para dicho Gate fueron:

```text
ADR-0001
ADR-0002
ADR-0005
ADR-0009
ADR-0012
ADR-0013
```

ADR-0019 no debe insertarse retroactivamente como uno de esos seis.

También deben preservarse otros snapshots históricos correctos en su momento, aunque sus estados no describan el estado operativo actual, siempre que el documento los presente realmente como historia/gobernanza y no como estado vigente.

---

## 10. Cambio esperado — `11-phase-1-scope-entry-gate.md`

### 10.1 Regla de auditoría

`11-phase-1-scope-entry-gate.md` sólo debe modificarse en referencias activas que hayan quedado stale.

La futura ejecución debe distinguir estrictamente:

```text
ACTIVE CURRENT STATE
```

frente a:

```text
HISTORICAL/GOVERNANCE SNAPSHOT — KEEP
```

No se moderniza retrospectivamente el Gate de Fase 1 ni la historia de la transición a Fase 2.

### 10.2 Estado activo que debe resultar coherente

Las referencias activas cubiertas por CORR-015 deben reflejar:

```text
Fase 2 = INICIADA

TASK-013 DETERMINATION = APPROVED
TASK-013 determinada = SÍ
TASK-013 generada = SÍ
TASK-013 SPEC REVIEW = APPROVED AS BLOCKED
TASK-013 SPECIFICATION =
BLOCKER — ARCHITECTURE DECISION REQUIRED

TASK-013 implementación autorizada = NO
TASK-013 implementada = NO

ADR-0019 = ACCEPTED
ADR-0019 canonicalizada = SÍ
ADR-0019 incorporada al canon/origin/main = SÍ

Auth funcional = NO

TASK-014 determinada = NO
TASK-014 generada = NO
```

### 10.3 Regla sobre `TASK-013`

El documento puede registrar que la decisión arquitectónica faltante fue resuelta posteriormente mediante ADR-0019, pero no debe reinterpretar el resultado histórico de la especificación original de TASK-013.

Debe permanecer inequívoco:

```text
ADR-0019 accepted/canonicalized
!=
TASK-013 corrected
!=
TASK-013 approved for implementation
!=
TASK-013 implemented
```

### 10.4 Auth funcional

Debe permanecer:

```text
Auth funcional = NO
```

ADR-0019 acepta arquitectura. No implementa login, signup funcional, onboarding, sesión end-to-end ni UI Auth.

### 10.5 Historia que debe preservarse

No deben reescribirse como stale las referencias que describen correctamente:

- el alcance histórico de Fase 1;
- lo que estaba prohibido durante Fase 1;
- el Gate histórico Fase 1/Fase 2;
- el hecho de que ADR-0002/ADR-0003 eran requisitos previos de entrada a Fase 2;
- estados de TASK/CORR anteriores en el momento en que fueron aprobados;
- snapshots de gobernanza que expresamente documenten el estado anterior.

La existencia de Fase 2 iniciada hoy no convierte en incorrecta una frase histórica que describía que Fase 2 aún no había iniciado en el momento de ese Gate, siempre que la sección sea realmente histórica y no una declaración activa actual.

---

## 11. `02-domain-model.md`

Clasificación obligatoria:

```text
docs/product/02-domain-model.md = NO CHANGE REQUIRED
```

CORR-015 no debe:

- agregar `SessionGrant` como nueva entidad del modelo conceptual;
- redefinir `VerificationChallenge`;
- convertir `VerificationChallenge` en tenant-owned;
- modificar el lenguaje ubicuo por inferencia;
- ampliar el bounded context de Identity & Access por esta corrección.

Si la futura ejecución concluye que `02-domain-model.md` necesita materialmente un cambio para completar CORR-015:

```text
CORR-015 EXECUTION = BLOCKER — SCOPE EXPANSION REQUIRED
```

---

## 12. `TASK-013`

`TASK-013` está fuera del scope de ejecución de CORR-015.

Debe permanecer sin modificar:

`docs/tasks/TASK-013-verification-challenge-foundation.md`

Estado preservado:

```text
TASK-013 implementación autorizada = NO
TASK-013 implementada = NO
```

CORR-015 no debe:

- eliminar el blocker histórico de su especificación;
- regenerar TASK-013;
- diseñar su schema físico;
- decidir migration;
- decidir constraints;
- decidir implementación de `SessionGrant`;
- decidir configuración Cloud;
- crear prompt de Codex para TASK-013;
- autorizar implementación.

La futura corrección/revisión de TASK-013 será un acto separado posterior al cierre completo de CORR-015.

---

## 13. `TASK-014`

Debe permanecer exactamente:

```text
TASK-014 determinada = NO
TASK-014 generada = NO
```

CORR-015 no determina, diseña, genera ni autoriza TASK-014.

---

## 14. Seguridad, multitenancy y RLS

La futura sincronización debe demostrar que no cambia ninguna frontera de seguridad previamente aprobada salvo registrar documentalmente la excepción Auth estrecha ya decidida por ADR-0019.

### 14.1 Invariantes tenant

Debe permanecer:

```text
tenant = MaintenanceCompany
```

```text
RLS = primary remote isolation boundary para datos tenant-owned
```

```text
authenticated != authorized
```

```text
valid Auth session != tenant authorization
```

### 14.2 Estado platform-owned

Debe permanecer:

```text
VerificationChallenge = platform-owned
SessionGrant = platform-owned
```

No se convierten en tenant-owned.

### 14.3 `supabase_auth_admin`

El registro documental de grants mínimos a `supabase_auth_admin` no significa:

- rol tenant;
- membership;
- Client scope;
- permiso sobre datos operativos;
- bypass de RLS tenant;
- autorización para reads/writes tenant generales.

Su uso queda acotado al Custom Access Token Hook y al estado platform-owned estrictamente necesario conforme a ADR-0019.

### 14.4 Auth Admin

Auth Admin permanece purpose-specific.

Se prohíbe:

```text
generic Supabase admin client reusable from arbitrary modules
```

Se prohíbe:

```text
service-role / secret key as ordinary request client
```

Se prohíbe:

```text
admin credential used for normal tenant reads/writes
```

### 14.5 `SUPER_ADMIN`

CORR-015 no cambia `SUPER_ADMIN`.

Debe permanecer:

```text
SUPER_ADMIN global
!=
tenant member
!=
RLS bypass
```

ADR-0002 y ADR-0003 permanecen sin modificación.

### 14.6 Naturaleza documental

CORR-015 no cambia:

- policies RLS;
- grants físicos;
- functions;
- schema;
- migrations;
- Supabase Cloud;
- secretos;
- Auth Hooks aplicados.

---

## 15. Fuera de alcance

CORR-015 no incluye:

- código;
- TypeScript;
- SQL;
- migration;
- RLS ejecutable;
- `CREATE POLICY`;
- grants/revokes ejecutables;
- Auth Hook executable;
- schema físico;
- Supabase Cloud;
- configuración de secretos;
- technical-password implementation;
- `SessionGrant` implementation;
- `VerificationChallenge` implementation;
- Auth user provisioning;
- login funcional;
- signup funcional;
- onboarding;
- `TASK-013` modification;
- `TASK-014`;
- UI;
- offline;
- Storage;
- Realtime;
- nuevo ADR;
- resolución de `DO-*`;
- resolución de `*-OPEN-*`.

---

## 16. Precondiciones de una futura ejecución

Antes de ejecutar CORR-015 debe verificarse:

1. la especificación canónica de CORR-015 existe y está aprobada para ejecución mediante los Gates correspondientes;
2. existe autorización humana separada para esa ejecución concreta;
3. ADR-0019 continúa `ACCEPTED`;
4. su ruta canónica continúa siendo la indicada;
5. la decisión sigue siendo E2;
6. `TASK-013` sigue sin autorización de implementación;
7. `TASK-014` sigue sin determinar/generar;
8. las tres fuentes candidatas siguen siendo los únicos documentos de producto que necesitan cambio material;
9. el repositorio real se encuentra en un estado Git compatible con una ejecución aislada y revisable.

---

## 17. Preflight Git futuro obligatorio

Baseline histórica posterior al push canónico de ADR-0019:

```text
branch = main

HEAD =
b8cab87e72e907eb54f9c2567636b29de0d1e73e

origin/main =
b8cab87e72e907eb54f9c2567636b29de0d1e73e

divergence =
0 0

worktree =
clean
```

Este snapshot es evidencia histórica y **NO** constituye una verdad futura inmutable.

La futura canonicalización de CORR-015 y cualquier acto documental aprobado posterior producirán naturalmente otros SHAs.

La futura ejecución debe volver a verificar como mínimo:

```text
git rev-parse --is-inside-work-tree
git rev-parse --show-toplevel
git branch --show-current
git rev-parse HEAD
git rev-parse --abbrev-ref --symbolic-full-name @{u}
git rev-parse origin/main
git rev-list --left-right --count HEAD...origin/main
git status --short
git status --porcelain=v1 --untracked-files=all
git diff --cached --name-only
```

Debe comprobar además que no exista una operación Git en progreso.

Ante drift material inesperado:

```text
CORR-015 EXECUTION = BLOCKER
```

No se autoriza autorepair mediante:

```text
git fetch correctivo por inferencia
git pull
git merge
git rebase
git reset
git restore
git stash
git clean
```

---

## 18. Auditoría documental previa a una futura ejecución

Antes de editar, debe realizarse una auditoría read-only integral.

### 18.1 Términos obligatorios

Buscar como mínimo:

```text
ADR-0019
TASK-013
Fase 2
VerificationChallenge
SessionGrant
service-role
secret key
supabase_auth_admin
Custom Access Token Hook
Auth Admin
authenticated
authorized
Auth funcional
TOTAL ADR
18 ADR
19 ADR
ACCEPTED
READY TO DRAFT
BLOCKED BY OPEN DECISIONS
DEFERRED
```

### 18.2 Clasificación obligatoria de cada coincidencia material

Cada referencia material debe clasificarse exclusivamente como:

```text
ACTIVE STALE REFERENCE — CHANGE
ACTIVE CURRENT REFERENCE — KEEP
HISTORICAL/GOVERNANCE SNAPSHOT — KEEP
UNEXPECTED — BLOCKER
```

No se permiten categorías adicionales.

### 18.3 Regla de scope

La auditoría debe confirmar:

```text
CHANGE REQUIRED = 3
```

con exactamente:

```text
docs/product/03-permissions-rls-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

Si aparece otro documento que requiera modificación material:

```text
CORR-015 EXECUTION = BLOCKER — SCOPE EXPANSION REQUIRED
```

---

## 19. Procedimiento futuro de ejecución

Sólo después de satisfacer las precondiciones y preflight:

### Paso 1 — Releer fuentes

Leer íntegramente todas las fuentes obligatorias de §4.

### Paso 2 — Repetir auditoría

Ejecutar la búsqueda y clasificación de §18 contra el canon real.

### Paso 3 — Confirmar scope

Confirmar que únicamente los tres documentos `CHANGE REQUIRED` necesitan modificación.

### Paso 4 — Modificar `03`

Aplicar el cambio mínimo definido en §8, integrado en las secciones canónicas existentes de Auth/backend privilegiado/RLS sin reescritura general.

### Paso 5 — Modificar `10`

Registrar ADR-0019 y sincronizar únicamente el catálogo/estadísticas globales stale conforme a §9.

### Paso 6 — Modificar `11`

Sincronizar únicamente referencias activas stale conforme a §10, preservando snapshots históricos.

### Paso 7 — Revisión semántica

Verificar que el resultado mantiene:

```text
TASK-013 implementación autorizada = NO
Auth funcional = NO
TASK-014 determinada = NO
TASK-014 generada = NO
```

### Paso 8 — Revisión de seguridad

Confirmar que no existe bypass tenant, ampliación de service-role, generic Admin client ni privilegio tenant para `supabase_auth_admin`.

### Paso 9 — Validación Git/documental

Ejecutar las pruebas de §22.

### Paso 10 — Detenerse sin staging

Dejar todos los cambios `UNSTAGED` para revisión humana.

No realizar `git add`, commit ni push durante la ejecución documental.

---

## 20. Blockers

La futura ejecución debe terminar en:

```text
CORR-015 EXECUTION = BLOCKER
```

si ocurre cualquiera de las siguientes condiciones.

### 20.1 Git / baseline

1. branch, upstream o divergencia son incompatibles con la ejecución autorizada;
2. existe drift material inesperado;
3. el worktree contiene cambios ajenos que impiden aislar CORR-015;
4. existe staging previo no reconciliado;
5. existe operación Git en progreso;
6. la identidad canónica de ADR-0019 no puede sostenerse.

### 20.2 Arquitectura / gobernanza

7. ADR-0019 ya no está `ACCEPTED`;
8. la decisión E2 fue sustituida por otra decisión aprobada;
9. completar la sincronización requiere cambiar ADR-0019;
10. completar la sincronización requiere modificar ADR-0002 o ADR-0003;
11. completar la sincronización requiere resolver un `DO-*` o `*-OPEN-*`;
12. completar la sincronización requiere un ADR adicional;
13. se intenta convertir la aceptación de ADR-0019 en autorización de TASK-013.

### 20.3 Scope documental

14. aparece un cuarto documento `CHANGE REQUIRED`;
15. `02-domain-model.md` requiere cambio material;
16. no puede distinguirse una referencia activa de un snapshot histórico;
17. el wording canónico real difiere materialmente de la auditoría y exige una reescritura más amplia;
18. el diff altera historia legítima;
19. el diff modifica requisitos no relacionados.

### 20.4 Seguridad / RLS

20. el cambio reduce aislamiento tenant;
21. el cambio convierte `VerificationChallenge` o `SessionGrant` en tenant-owned;
22. el cambio modifica policies RLS;
23. el cambio necesita RLS ejecutable;
24. el cambio amplía `service-role` como camino ordinario;
25. el cambio crea un Admin client genérico;
26. el cambio otorga privilegios tenant a `supabase_auth_admin`;
27. el cambio convierte Auth session en autorización tenant;
28. el cambio convierte `SUPER_ADMIN` en tenant member/bypass.

### 20.5 Implementación no autorizada

29. se necesita código;
30. se necesita SQL;
31. se necesita migration;
32. se necesita configuración real de Auth Hook;
33. se necesita modificar Supabase Cloud;
34. se necesita crear technical password;
35. se necesita implementar `SessionGrant`;
36. se necesita implementar `VerificationChallenge`;
37. se necesita modificar TASK-013;
38. se necesita determinar o generar TASK-014.

### 20.6 Validación

39. `git diff --check` falla;
40. `git diff --name-only` contiene un archivo fuera de los tres autorizados;
41. cualquier criterio de aceptación de §21 falla.

Ante cualquier blocker:

```text
NO inferir
NO ampliar scope
NO autorepair
NO staging
NO commit
NO push
DETENERSE
```

---

## 21. Criterios de aceptación

Todos los criterios son obligatorios e individualmente verificables.

### Identidad y estado

**AC-015-001** — El ID es exactamente `CORR-015`.

**AC-015-002** — El título es exactamente `CORR-015 — Sincronización documental posterior a la aceptación de ADR-0019`.

**AC-015-003** — El tipo es una corrección documental controlada, no una implementation task.

**AC-015-004** — El estado documental de esta especificación es `APPROVED FOR IMPLEMENTATION`.

**AC-015-005** — El archivo de entrega es `CORR-015-adr-0019-accepted-state-sync-approved.md`.

### ADR-0019

**AC-015-006** — `ADR-0019 = ACCEPTED` queda reconocido.

**AC-015-007** — La decisión E2 queda preservada sin modificación semántica.

**AC-015-008** — El commit canónico `b8cab87e72e907eb54f9c2567636b29de0d1e73e` queda registrado como evidencia histórica.

**AC-015-009** — La ruta canónica de ADR-0019 queda reconocida.

**AC-015-010** — El SHA-256 canónico `41a2f5fcd57ca26fd52ca318fc2714c5188e9c03ab5f3d58ab55f92bd98b5e09` queda reconocido.

**AC-015-011** — `ADR-0019 ACCEPTED != TASK-013 implementation authorized` queda inequívoco.

### `03-permissions-rls-strategy.md`

**AC-015-012** — `03` fue auditado íntegramente antes de una futura edición.

**AC-015-013** — `03` queda clasificado `CHANGE REQUIRED`.

**AC-015-014** — `VerificationChallenge = platform-owned` queda documentado.

**AC-015-015** — `SessionGrant = platform-owned` queda documentado.

**AC-015-016** — La frontera `Custom Access Token Hook` queda registrada conceptualmente.

**AC-015-017** — Los permisos a `supabase_auth_admin` quedan descritos únicamente como mínimos, explícitos y purpose-specific.

**AC-015-018** — `Auth Admin` queda registrado como purpose-specific y server-side.

**AC-015-019** — No se crea un Supabase Admin client genérico.

**AC-015-020** — `service-role / secret key as ordinary request client = PROHIBIDO` permanece vigente.

**AC-015-021** — RLS continúa siendo la frontera primaria de aislamiento remoto para datos tenant-owned.

**AC-015-022** — `authenticated != authorized` permanece explícito o inequívocamente preservado.

**AC-015-023** — Una sesión Auth válida no concede membership tenant.

**AC-015-024** — Una sesión Auth válida no concede Client scope.

**AC-015-025** — `supabase_auth_admin` no recibe privilegios tenant.

**AC-015-026** — La excepción Auth no se usa para reads/writes tenant ordinarios.

**AC-015-027** — La excepción Auth no bypassa RLS tenant.

**AC-015-028** — `SUPER_ADMIN` no se convierte en tenant member ni bypass.

### `10-architecture-decisions-records.md`

**AC-015-029** — `10` fue auditado íntegramente antes de una futura edición.

**AC-015-030** — `10` queda clasificado `CHANGE REQUIRED`.

**AC-015-031** — ADR-0019 queda incorporado explícitamente al registro maestro con `Status = ACCEPTED`.

**AC-015-032** — La descripción compacta de ADR-0019 preserva `application-owned VerificationChallenge + one-time SessionGrant + server-only technical password bridge + Custom Access Token Hook gate`.

**AC-015-033** — El catálogo vigente reconoce 19 ADR.

**AC-015-034** — La existencia histórica del catálogo original de 18 ADR queda preservada cuando corresponda.

**AC-015-035** — La distribución global vigente queda coherente con `8 ACCEPTED / 0 READY TO DRAFT / 8 BLOCKED / 3 DEFERRED`.

**AC-015-036** — Las estadísticas globales stale dependientes del total/distribución se actualizan y sólo ellas.

**AC-015-037** — Ningún estado de ADR-0001…ADR-0018 cambia indebidamente.

**AC-015-038** — Los seis ADR históricos del Gate de Fase 0 permanecen seis y no se añade ADR-0019 retroactivamente.

**AC-015-039** — Ningún `DO-*` se resuelve por inferencia.

**AC-015-040** — Ningún `*-OPEN-*` se resuelve por inferencia.

### `11-phase-1-scope-entry-gate.md`

**AC-015-041** — `11` fue auditado íntegramente antes de una futura edición.

**AC-015-042** — `11` queda clasificado `CHANGE REQUIRED` por referencias activas stale posteriores a TASK-013/ADR-0019.

**AC-015-043** — Las referencias activas resultantes reflejan `Fase 2 = INICIADA`.

**AC-015-044** — Las referencias activas resultantes reflejan `TASK-013 determinada = SÍ`.

**AC-015-045** — Las referencias activas resultantes reflejan `TASK-013 generada = SÍ`.

**AC-015-046** — Las referencias activas resultantes reflejan `TASK-013 SPEC REVIEW = APPROVED AS BLOCKED`.

**AC-015-047** — `TASK-013 implementación autorizada = NO` permanece inequívoco.

**AC-015-048** — `TASK-013 implementada = NO` permanece inequívoco.

**AC-015-049** — Las referencias activas resultantes reflejan `ADR-0019 = ACCEPTED`.

**AC-015-050** — Las referencias activas resultantes reflejan que ADR-0019 fue canonicalizada e incorporada al canon/origin/main.

**AC-015-051** — `Auth funcional = NO` permanece inequívoco.

**AC-015-052** — `TASK-014 determinada = NO` permanece inequívoco.

**AC-015-053** — `TASK-014 generada = NO` permanece inequívoco.

**AC-015-054** — Los snapshots históricos/gobernanza legítimos de Fase 1/Fase 2 se preservan.

**AC-015-055** — El documento no falsifica retrospectivamente la especificación bloqueada de TASK-013.

### Scope y archivos preservados

**AC-015-056** — `02-domain-model.md = NO CHANGE REQUIRED`.

**AC-015-057** — No se agrega `SessionGrant` al modelo conceptual de `02`.

**AC-015-058** — `TASK-013` no se modifica.

**AC-015-059** — ADR-0019 no se modifica.

**AC-015-060** — ADR-0002 no se modifica.

**AC-015-061** — ADR-0003 no se modifica.

**AC-015-062** — Ningún documento fuera de los tres `CHANGE REQUIRED` aparece en el diff futuro.

### No implementación

**AC-015-063** — No se modifica código.

**AC-015-064** — No se escribe SQL.

**AC-015-065** — No se crea ni modifica migration.

**AC-015-066** — No se escribe RLS ejecutable.

**AC-015-067** — No se crea ni modifica una policy.

**AC-015-068** — No se aplica Auth Hook.

**AC-015-069** — No se modifica Supabase Cloud.

**AC-015-070** — No se configuran secrets.

**AC-015-071** — No se implementa technical password.

**AC-015-072** — No se implementa `SessionGrant`.

**AC-015-073** — No se implementa `VerificationChallenge`.

**AC-015-074** — No se determina ni genera TASK-014.

### Git y calidad documental

**AC-015-075** — La futura ejecución realiza preflight Git fresco.

**AC-015-076** — El SHA histórico `b8cab87...` no se trata como HEAD futuro obligatorio.

**AC-015-077** — `git diff --name-only` contiene únicamente los archivos previamente clasificados `CHANGE REQUIRED`.

**AC-015-078** — `git diff --check = PASS`.

**AC-015-079** — Se revisa el diff íntegro de cada archivo modificado.

**AC-015-080** — No existe staging al finalizar la ejecución documental.

**AC-015-081** — No se ejecuta `git add` durante la ejecución documental.

**AC-015-082** — No se realiza commit durante la ejecución documental.

**AC-015-083** — No se realiza push durante la ejecución documental.

### Preparación actual

**AC-015-084** — Durante la preparación de esta especificación no se modifica el repositorio.

**AC-015-085** — Durante la preparación de esta especificación no se modifica Supabase Cloud.

**AC-015-086** — Durante la preparación de esta especificación no se usa Codex.

**AC-015-087** — Durante la preparación de esta especificación no se realiza canonicalización, staging, commit ni push.

Un único criterio fallido durante una futura ejecución implica:

```text
CORR-015 EXECUTION = BLOCKER
```

---

## 22. Pruebas documentales de una futura ejecución

La futura ejecución debe reportar como mínimo:

```text
git diff --name-only
git diff --name-status
git diff --stat
git diff --numstat
git diff --check
git status --short
git status --porcelain=v1 --untracked-files=all
git diff --cached --name-only
```

Debe devolver el diff íntegro de cada archivo modificado:

```text
git diff --no-ext-diff -- docs/product/03-permissions-rls-strategy.md
git diff --no-ext-diff -- docs/product/10-architecture-decisions-records.md
git diff --no-ext-diff -- docs/product/11-phase-1-scope-entry-gate.md
```

Debe confirmarse:

```text
files changed = 3
unexpected files = 0
staged = none
```

La auditoría textual post-cambio debe cubrir como mínimo:

```text
ADR-0019
TASK-013
Fase 2
service-role
supabase_auth_admin
Custom Access Token Hook
Auth Admin
VerificationChallenge
SessionGrant
Auth funcional
```

Y verificar semánticamente:

```text
ADR-0019 = ACCEPTED
TASK-013 implementation authorized = NO
Auth funcional = NO
TASK-014 determined = NO
TASK-014 generated = NO
```

También debe comprobarse que no existan cambios en:

```text
app/
src/
tests/
supabase/
package.json
package-lock.json
```

salvo que el repositorio contenga drift previo ajeno, en cuyo caso debe reportarse y evaluarse como blocker conforme al preflight; CORR-015 no puede modificar esas superficies.

---

## 23. Cambios físicos esperados en una futura ejecución

Si el preflight y la auditoría resultan PASS, el diff esperado queda limitado a:

```text
MODIFY docs/product/03-permissions-rls-strategy.md
MODIFY docs/product/10-architecture-decisions-records.md
MODIFY docs/product/11-phase-1-scope-entry-gate.md
```

Cantidad esperada:

```text
files modified = 3
```

Cualquier archivo adicional:

```text
CORR-015 EXECUTION = BLOCKER
```

---

## 24. Definition of Done

La existencia de esta especificación no completa CORR-015.

Deben permanecer separados:

```text
especificación = REALIZADA
SPEC REVIEW = APPROVED
aprobación humana = APPROVED
artefacto aprobado = GENERADO
revisión del artefacto aprobado = PENDIENTE
canonicalización = PENDIENTE
revisión de canonicalización = PENDIENTE
incorporación Git de especificación = PENDIENTE
autorización separada de ejecución = PENDIENTE
ejecución documental = PENDIENTE
revisión humana del diff = PENDIENTE
incorporación Git de ejecución = PENDIENTE
cierre humano final = PENDIENTE
```

### 24.1 Definition of Done de esta aprobación documental

Esta aprobación documental queda correctamente terminada cuando:

- existe el archivo `CORR-015-adr-0019-accepted-state-sync-approved.md`;
- `CORR-015 SPECIFICATION = PASS`;
- `CORR-015 SPEC REVIEW = APPROVED`;
- `CORR-015 HUMAN APPROVAL = APPROVED`;
- su estado es `APPROVED FOR IMPLEMENTATION`;
- `CORR-015 aprobada = SÍ`;
- `CORR-015 canonicalizada = NO`;
- `CORR-015 ejecución autorizada = NO`;
- `CORR-015 ejecutada = NO`;
- `CORR-015 completada = NO`;
- clasifica `03`, `10` y `11` como `CHANGE REQUIRED`;
- preserva `02 = NO CHANGE REQUIRED`;
- no implementa E2;
- no modifica TASK-013;
- no determina TASK-014;
- no modifica repositorio ni Supabase Cloud;
- no realiza operaciones Git.

Resultado de esta aprobación documental:

```text
CORR-015 SPECIFICATION = PASS
CORR-015 SPEC REVIEW = APPROVED
CORR-015 HUMAN APPROVAL = APPROVED

CORR-015 = APPROVED FOR IMPLEMENTATION
CORR-015 estado = APPROVED FOR IMPLEMENTATION
CORR-015 determinada = SÍ
CORR-015 generada = SÍ
CORR-015 especificada = SÍ
CORR-015 aprobada = SÍ
CORR-015 canonicalizada = NO
CORR-015 ejecución autorizada = NO
CORR-015 ejecutada = NO
CORR-015 completada = NO

CHANGE REQUIRED = 3
NO CHANGE REQUIRED (02) = 1

implementación realizada = NO
repositorio modificado = NO
Supabase Cloud modificado = NO
Git modificado = NO

TASK-013 implementación autorizada = NO
TASK-014 determinada = NO
TASK-014 generada = NO
```

Debe permanecer:

```text
Codex PASS
!=
CORR-015 completada

CORR-015 completada
!=
TASK-013 implementation authorized automatically
```

### 24.2 Definition of Done de la futura corrección

CORR-015 sólo podrá considerarse completada después de que:

1. el artefacto aprobado de CORR-015 supere revisión del Revisor Central;
2. la especificación sea canonicalizada;
3. la canonicalización supere revisión;
4. la especificación sea incorporada a Git mediante autorizaciones separadas;
5. exista autorización humana separada de ejecución;
6. el preflight Git futuro sea PASS;
7. las fuentes canónicas sean releídas íntegramente;
8. la auditoría confirme exactamente tres archivos `CHANGE REQUIRED`;
9. se apliquen exclusivamente los cambios aprobados;
10. seguridad, multitenancy y RLS permanezcan intactos;
11. `git diff --check = PASS`;
12. se revise humanamente el full diff;
13. la incorporación Git de la ejecución sea autorizada separadamente;
14. se complete staging/commit/push de ejecución y verificación Git mediante autorizaciones separadas;
15. exista cierre humano final.

---

## 25. Gate posterior

El estado de esta entrega termina obligatoriamente en:

```text
CORR-015 = APPROVED FOR IMPLEMENTATION
CORR-015 canonicalizada = NO
CORR-015 ejecución autorizada = NO
CORR-015 ejecutada = NO
CORR-015 completada = NO
```

Este estado no equivale a:

```text
EXECUTION AUTHORIZED
DONE
COMPLETED
```

La secuencia posterior obligatoria es:

```text
1. artefacto aprobado de CORR-015 generado
2. revisión del artefacto aprobado por el Revisor Central
3. canonicalización
4. revisión de canonicalización
5. incorporación Git de la especificación mediante autorizaciones separadas
6. autorización humana separada de ejecución
7. prompt exacto para Codex
8. ejecución documental sin staging/commit/push
9. revisión humana del diff
10. staging/commit/push de la ejecución mediante autorizaciones separadas
11. verificación Git
12. cierre humano final de CORR-015
13. retorno al Revisor Central
14. sólo entonces podrá iniciarse un acto separado de revisión/corrección de TASK-013
```

Sólo después del cierre completo de CORR-015 podrá iniciarse un acto separado para:

```text
revisar/corregir TASK-013 para consumir ADR-0019 E2
→ nueva revisión humana de TASK-013
→ nueva aprobación de TASK-013
```

CORR-015 no diseña esa corrección.

Debe permanecer:

```text
CORR-015 completed
!=
TASK-013 implementation authorized automatically
```

Y también:

```text
TASK-013 approval future
!=
TASK-014 determined automatically
```

---

## 26. Resultado de la especificación

```text
CORR-015 SPECIFICATION = PASS
CORR-015 SPEC REVIEW = APPROVED
CORR-015 HUMAN APPROVAL = APPROVED

CORR-015 = APPROVED FOR IMPLEMENTATION
CORR-015 estado = APPROVED FOR IMPLEMENTATION
CORR-015 determinada = SÍ
CORR-015 generada = SÍ
CORR-015 especificada = SÍ
CORR-015 aprobada = SÍ
CORR-015 canonicalizada = NO
CORR-015 ejecución autorizada = NO
CORR-015 ejecutada = NO
CORR-015 completada = NO

CHANGE REQUIRED = 3
CHANGE REQUIRED:
- docs/product/03-permissions-rls-strategy.md
- docs/product/10-architecture-decisions-records.md
- docs/product/11-phase-1-scope-entry-gate.md

NO CHANGE REQUIRED (02) = 1
NO CHANGE REQUIRED:
- docs/product/02-domain-model.md

SCOPE EXPANSION REQUIRED = NO

ADR-0019 = ACCEPTED
ADR-0019 canonicalizada/incorporada = SÍ

TASK-013 implementación autorizada = NO
TASK-013 implementada = NO

Auth funcional = NO

TASK-014 determinada = NO
TASK-014 generada = NO

NO IMPLEMENTATION
NO CODE
NO SQL
NO MIGRATION
NO RLS EXECUTABLE
NO SUPABASE CLOUD CHANGE
NO CODEX
NO CANONICALIZATION
NO GIT ADD
NO COMMIT
NO PUSH
```

`CORR-015 SPECIFICATION = PASS`, `CORR-015 SPEC REVIEW = APPROVED` y `CORR-015 HUMAN APPROVAL = APPROVED` significan que la especificación documental fue revisada y aprobada para una futura ejecución conforme a sus Gates.

No significan canonicalización, autorización de ejecución, ejecución ni cierre.
