# CORR-022 — Sincronización documental posterior al cierre de CORR-021 previa a implementación de TASK-015

## 1. Identificación

**ID:** `CORR-022`

**Título:** `CORR-022 — Sincronización documental posterior al cierre de CORR-021 previa a implementación de TASK-015`

**Tipo:** `CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO`

**Naturaleza:** sincronización documental de estado activo; no constituye decisión nueva de producto, dominio, arquitectura, seguridad, RLS ni implementación.

**Archivo de entrega:** `CORR-022-corr-021-closure-state-sync-approved-corrected-v2.md`

**CORR-022 DETERMINATION REVIEW:** `APPROVED`

**CORR-022 DETERMINATION:** `APPROVED`

**CORR-022 SPECIFICATION GENERATION GATE:** `AUTHORIZED`

**CORR-022 SPECIFICATION:** `APPROVED FOR EXECUTION`

**CORR-022 SPEC REVIEW:** `APPROVED`

**CORR-022 HUMAN SPEC APPROVAL:** `APPROVED`

**CORR-022 aprobada:** `SÍ`

**state:** `APPROVED FOR EXECUTION`

**CORR-022 canonicalized:** `NO`

**CORR-022 execution authorized:** `NO`

**Target document modified during specification generation:** `NO`

**Repository modified during specification generation:** `NO`

**Codex authorized:** `NO`

**Supabase Cloud:** `NO CHANGE`

**Git:** `NO CHANGE`

**TASK-015 implementation authorized:** `NO`

**TASK-015 implementation started:** `NO`

**TASK-016:** `NOT DETERMINED / NOT GENERATED / NOT STARTED`

La specification queda formalmente aprobada. El estado `APPROVED FOR EXECUTION` acredita exclusivamente que la specification fue revisada y aprobada humanamente y no autoriza su ejecución.

```text
CORR-022 DETERMINATION = APPROVED
!=
CORR-022 SPEC REVIEW = APPROVED
!=
CORR-022 HUMAN SPEC APPROVAL = APPROVED
!=
CORR-022 CANONICALIZED
!=
CORR-022 EXECUTION AUTHORIZED
!=
CORR-022 DONE
```

```text
APPROVED FOR EXECUTION
=
SPECIFICATION HUMAN-APPROVED

APPROVED FOR EXECUTION
!=
CORR-022 EXECUTION AUTHORIZED

APPROVED FOR EXECUTION
!=
TARGET DOCUMENT MODIFICATION AUTHORIZED

APPROVED FOR EXECUTION
!=
CODEX AUTHORIZED

APPROVED FOR EXECUTION
!=
REPOSITORY MODIFICATION AUTHORIZED

APPROVED FOR EXECUTION
!=
TASK-015 IMPLEMENTATION AUTHORIZED

APPROVED FOR EXECUTION
!=
DONE
```

y:

```text
CORR-021 DONE
!=
TASK-015 IMPLEMENTATION AUTHORIZED

CORR-022 DONE
!=
TASK-015 IMPLEMENTATION AUTHORIZED
```

---

## 2. Objetivo único

CORR-022 debe definir cómo una futura ejecución documental sincronizará exclusivamente el estado activo de:

`docs/product/11-phase-1-scope-entry-gate.md`

después del cierre formal de CORR-021 y antes de cualquier posible autorización de implementación de TASK-015.

La futura corrección debe:

- reemplazar estados activos stale por el estado aprobado posterior a CORR-020 y CORR-021;
- registrar que TASK-015 ya está determinada, especificada, aprobada humanamente y canonicalizada;
- mantener cerrada la ejecución de TASK-015;
- registrar el hardening físico ya cerrado de TASK-014 mediante CORR-021 sin convertirlo en una decisión arquitectónica general nueva;
- preservar la historia normativa y los snapshots históricos;
- limitar el cambio a un único archivo y exactamente cuatro superficies activas;
- impedir cualquier inferencia sobre TASK-016.

Principio obligatorio:

```text
documentation state synchronization
!=
product decision
!=
architecture decision
!=
implementation
!=
TASK-015 authorization
```

CORR-022 no implementa ninguna capability.

---

## 3. Contexto de reanudación

La primera ejecución del Gate de generación se detuvo correctamente con:

```text
CORR-022 SPECIFICATION =
BLOCKER — REQUIRED CANONICAL SOURCE UNAVAILABLE OR IDENTITY MISMATCH

blocker class =
REQUIRED CANONICAL SOURCE UNAVAILABLE
```

La única causa residual fue la ausencia física de SOURCE D.

SOURCE D fue posteriormente disponibilizada y verificada desde sus bytes físicos reales. Esta reanudación consume el mismo:

```text
CORR-022 DETERMINATION REVIEW = APPROVED
CORR-022 DETERMINATION = APPROVED
CORR-022 SPECIFICATION GENERATION GATE = REMAINS AUTHORIZED
```

No existe nueva determinación ni nuevo Gate de generación.

La reanudación no reabre el scope determinado.

---

## 4. Fuentes físicas obligatorias e identidad

### 4.1 SOURCE A

**Filename:** `11-phase-1-scope-entry-gate.md`

**Repo-relative identity:** `docs/product/11-phase-1-scope-entry-gate.md`

```text
SHA-256 =
72704c6af20c4591cf3139b6a5646795efd8b516cd33cdd92b064c7968e3b925

bytes =
75005

LF =
1363

CRLF =
0

bare CR =
0

final newline =
YES

integrity =
PASS

complete physical read =
PASS
```

El archivo contiene 9 líneas con trailing whitespace observadas físicamente. SOURCE A no definía una expectativa de trailing-whitespace para este Gate y ese hecho no constituye drift semántico ni autoriza limpieza lateral.

### 4.2 SOURCE B

**Filename de entrega:** `CORR-020-task-015-product-decisions-documentation-sync-approved.md`

**Canonical repo identity:** `docs/tasks/CORR-020-task-015-product-decisions-documentation-sync.md`

```text
SHA-256 =
483fb591d8069ef5ae4371b80ffe768bc34b221292a2acc1f60d01a7cbd05473

bytes =
60806

LF =
1942

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES

integrity =
PASS

complete physical read =
PASS
```

### 4.3 SOURCE C

**Filename de entrega:** `TASK-015-company-membership-lifecycle-audit-event-atomic-approved.md`

**Canonical repo identity:** `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`

```text
SHA-256 =
c00a9018a7d3293e5beff8fa3422f930d2a62a4078aa7b25a4e7d9f519f77e20

bytes =
94753

LF =
3309

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES

integrity =
PASS

complete physical read =
PASS
```

### 4.4 SOURCE D

**Filename:** `CORR-021-privileged-rpc-boundary-hardening-approved.md`

**Canonical repo identity:** `docs/tasks/CORR-021-privileged-rpc-boundary-hardening.md`

```text
SHA-256 =
63847257b3483fcb4488697532b3636628a623876b75e05dc6077d8f7875d229

bytes =
60720

LF =
1686

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES

integrity =
PASS

complete physical read =
PASS
```

### 4.5 Resultado del Gate de fuentes

```text
SOURCE A integrity = PASS
SOURCE B integrity = PASS
SOURCE C integrity = PASS
SOURCE D integrity = PASS

required source unavailable = NO
source identity mismatch = NO
```

No se reconstruyó ninguna source desde contexto, memoria o resúmenes.

---

## 5. Autoridad documental y temporal

Para CORR-022 se aplica el siguiente orden:

1. decisiones y cierres humanos posteriores explícitamente aprobados dentro de su alcance;
2. estado físico, Git y Hosted cerrado cuando documenta una materialización ya aprobada;
3. documentos canónicos vigentes dentro de su bounded context;
4. ADR aceptados dentro de la decisión que documentan;
5. TASK/CORR históricas como snapshots del momento en que fueron emitidas;
6. wording histórico únicamente como historia, nunca como estado activo contradictorio.

Reglas obligatorias:

```text
historical snapshot
!=
current active project state
```

y:

```text
synchronize active state
!=
rewrite history
```

Por ello, estados históricos correctos en SOURCE B/C/D como `canonicalized = NO`, `execution = NO` o `implementation = NO` no prevalecen sobre cierres humanos posteriores aprobados cuando se determina el estado activo actual.

---

## 6. Estado activo post-CORR-020 / post-CORR-021

La specification consume como estado de gobernanza posterior:

```text
CORR-020 =
DONE / CLOSED

CORR-020 documentation prerequisite for TASK-015 =
SATISFIED
```

```text
TASK-015 DETERMINATION =
APPROVED

TASK-015 SPEC REVIEW =
APPROVED

TASK-015 HUMAN SPEC APPROVAL =
APPROVED

TASK-015 =
DETERMINED / SPECIFIED / HUMAN-APPROVED / CANONICALIZED

TASK-015 canonical path =
docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md

TASK-015 canonical SHA-256 =
c00a9018a7d3293e5beff8fa3422f930d2a62a4078aa7b25a4e7d9f519f77e20

TASK-015 implementation authorized =
NO

TASK-015 implementation started =
NO
```

```text
CORR-021 =
DONE / CLOSED

CORR-021 FINAL HUMAN CLOSURE =
APPROVED

CORR-021 implementation commit =
b8e96bd89b246b663647711e5ad11d9dba9c2bde

CORR-021 Hosted Development =
PASS

CORR-021 migration =
APPLIED EXACTLY ONCE

CORR-021 blocker of TASK-015 =
RESOLVED
```

Baseline Git histórico de cierre:

```text
branch =
main

HEAD =
b8e96bd89b246b663647711e5ad11d9dba9c2bde

origin/main =
b8e96bd89b246b663647711e5ad11d9dba9c2bde

remote main =
b8e96bd89b246b663647711e5ad11d9dba9c2bde

divergence =
0 0

worktree =
CLEAN
```

Este baseline documenta cierre. No sustituye un preflight Git fresco de una futura ejecución.

---

## 7. Topología física vigente post-CORR-021

La futura sincronización debe registrar, donde sea semánticamente necesaria, la topología física purpose-specific ya cerrada:

```text
caller-scoped Supabase client
→ public.resolve_current_global_authority()
  SECURITY INVOKER
→ private.resolve_current_global_authority()
  SECURITY DEFINER
→ authoritative PostgreSQL state
```

Debe preservarse:

```text
private =
NON-EXPOSED SCHEMA

public.resolve_current_global_authority() arguments =
ZERO

identity anchor =
auth.uid() only

TASK-014 product semantics changed by CORR-021 =
NO

ordinary CompanyMembership RLS changed =
NO

SUPER_ADMIN ordinary tenant bypass =
NO

ordinary service-role resolver =
NO

generic privileged client =
NO
```

La materialización `private` queda ratificada para esta implementación purpose-specific de CORR-021.

CORR-022 no puede declarar:

```text
private =
MANDATORY GLOBAL NAMING CONVENTION
```

CORR-021 no creó esa regla general.

---

## 8. Auditoría integral de SOURCE A

SOURCE A fue leída íntegramente y auditada en modo read-only.

La auditoría buscó:

- estados activos de TASK-015;
- referencias activas al resultado físico de TASK-014;
- cualquier superficie que necesitara incorporar CORR-020 o CORR-021 para evitar contradicción activa;
- referencias históricas que deban permanecer intactas;
- cualquier quinta superficie cuya modificación fuera semánticamente necesaria.

Resultado:

```text
expected active stale surfaces =
4

active stale surfaces =
4

unexpected active stale surfaces =
0

second target document required =
NO
```

Las cuatro superficies activas stale son exclusivamente:

- §7.9;
- §10.2;
- §14.2;
- §17.

Las referencias fuera de estas cuatro superficies describen alcance de fases, historia normativa, reglas generales o estados que no requieren modificación para representar el cierre post-CORR-021.

No existe una quinta superficie activa materialmente necesaria.

---

## 9. Drift exacto

SOURCE A conserva como estado activo posterior a TASK-014:

```text
TASK-015 determinada = NO = STALE

TASK-015 generada = NO = STALE

TASK-015 iniciada = NO = CURRENT / PRESERVED
```

y no incorpora todavía, como estado activo:

- cierre de CORR-020;
- estado documental/canónico actual de TASK-015;
- cierre de CORR-021;
- resolución del blocker de TASK-015;
- hardening físico post-CORR-021 del resolver global de TASK-014.

El drift se clasifica exactamente:

| Superficie | Clasificación | Acción |
| --- | --- | --- |
| §7.9 | `ACTIVE STALE REFERENCE` | `CHANGE` |
| §10.2 | `ACTIVE STALE REFERENCE` | `CHANGE` |
| §14.2 | `ACTIVE STALE REFERENCE` | `CHANGE` |
| §17 | `ACTIVE STALE REFERENCE` | `CHANGE` |

Cualquier quinta superficie activa requerida produce:

```text
CORR-022 SPECIFICATION / EXECUTION =
BLOCKER — UNEXPECTED ACTIVE STALE SURFACE
```

No se amplía scope silenciosamente.

---

## 10. Target y change surface

### 10.1 Único target futuro

```text
docs/product/11-phase-1-scope-entry-gate.md
```

```text
CHANGE REQUIRED file count =
1
```

### 10.2 Secciones autorizadas

```text
CHANGE REQUIRED sections =
4
```

Exactamente:

- §7.9;
- §10.2;
- §14.2;
- §17.

### 10.3 Regla de mínima modificación

La ejecución futura debe producir el diff documental mínimo que restaure coherencia de estado activo.

Queda prohibido:

- reestructurar el documento;
- renumerar secciones;
- reformatear lateralmente;
- limpiar whitespace ajeno al cambio;
- convertir la corrección en changelog ilimitado;
- actualizar otras fases o tareas oportunísticamente;
- modificar snapshots históricos claramente identificados como tales.

Una referencia puramente mecánica fuera de las cuatro superficies sólo puede tocarse si es estrictamente imprescindible para mantener Markdown válido y no cambia semántica. Si se necesita un cambio semántico fuera de las cuatro superficies: `BLOCKER`.

---

## 11. Matriz obligatoria por superficie

| Superficie | Estado stale que debe dejar de ser activo | Estado activo que debe quedar reflejado | Límites |
| --- | --- | --- | --- |
| §7.9 | TASK-015 no determinada/no generada; frontera detenida en TASK-014 | TASK-014 closed; CORR-020 closed; TASK-015 determined/specified/approved/canonicalized pero no autorizada/iniciada; CORR-021 closed y blocker resuelto; topología post-CORR-021 cuando aporte trazabilidad | no convertir la sección en changelog general |
| §10.2 | frontera de entrada a Fase 2 termina en TASK-014 y TASK-015 no determinada | CORR-020 prerequisite satisfecho; CORR-021 security blocker resuelto; TASK-015 preparada documentalmente; ejecución cerrada; Fase 2 iniciada/no completa | no autorizar TASK-015 ni siguiente incremento |
| §14.2 | resolver TASK-014 descrito sólo con forma pre-hardening y TASK-015 no determinada | semantics TASK-014 preservadas; wrapper público INVOKER; resolver interno `private` DEFINER no expuesto; RLS/multitenancy preservados; TASK-015 documentada pero no ejecutable | no elevar `private` a convención global; no declarar capability funcional completa |
| §17 | resumen final termina en TASK-014 y TASK-015 no determinada/no generada | CORR-020 y CORR-021 closed; commit CORR-021; TASK-015 determined/specified/human-approved/canonicalized; implementation NO/started NO; capacidades pendientes; Fase 2 not done; TASK-016 untouched | no duplicar topología completa si ya queda suficientemente registrada |

---

## 12. §7.9 — Otras decisiones `DO-*`

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

La ejecución futura debe preservar el catálogo `DO-*` existente y sincronizar únicamente la frontera de estado posterior.

Debe quedar inequívoco:

```text
TASK-014 =
DONE / CLOSED

CORR-020 =
DONE / CLOSED

CORR-020 documentation prerequisite for TASK-015 =
SATISFIED

TASK-015 determinada =
SÍ

TASK-015 generada / especificada =
SÍ

TASK-015 SPEC REVIEW =
APPROVED

TASK-015 HUMAN SPEC APPROVAL =
APPROVED

TASK-015 canonicalizada =
SÍ

TASK-015 implementation authorized =
NO

TASK-015 implementation started =
NO

CORR-021 =
DONE / CLOSED

CORR-021 FINAL HUMAN CLOSURE =
APPROVED

CORR-021 blocker of TASK-015 =
RESOLVED
```

Puede registrar de forma acotada la topología post-CORR-021 cuando sea necesaria para explicar qué cambió físicamente sin cambiar semántica de TASK-014.

Debe continuar indicando que las capacidades funcionales no materializadas permanecen pendientes y que ninguna TASK posterior queda autorizada automáticamente.

No debe reescribir las decisiones `DO-*` ajenas al drift.

---

## 13. §10.2 — Requisito para entrar en Fase 2

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

Debe preservar:

```text
Fase 2 =
INICIADA / NOT DONE

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED
```

Debe registrar:

```text
CORR-020 documentation prerequisite =
SATISFIED

CORR-021 security blocker =
RESOLVED

TASK-015 =
DETERMINED / SPECIFIED / HUMAN-APPROVED / CANONICALIZED

TASK-015 implementation authorized =
NO

TASK-015 implementation started =
NO
```

Debe distinguir expresamente:

```text
CORR-021 DONE
!=
TASK-015 IMPLEMENTATION START

CORR-021 DONE
!=
TASK-015 IMPLEMENTATION AUTHORIZED
```

La satisfacción de prerequisites documentales y de seguridad sólo deja preparada la frontera para un eventual Gate humano de implementación. No crea dicho Gate ni lo aprueba.

No existe autorización automática del siguiente incremento.

---

## 14. §14.2 — Condición adicional para cruzar hacia Fase 2

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

La ejecución futura debe actualizar el estado físico del resolver TASK-014 a su forma post-CORR-021 sin declarar un cambio de semántica de producto.

Debe quedar reflejado, de manera compatible con la estructura existente:

```text
TASK-014 =
DONE / CLOSED

TASK-014 product semantics changed by CORR-021 =
NO

CORR-021 =
DONE / CLOSED

CORR-021 security blocker =
RESOLVED
```

Topología vigente:

```text
caller-scoped Supabase client
→ public.resolve_current_global_authority()
  SECURITY INVOKER
→ private.resolve_current_global_authority()
  SECURITY DEFINER
→ authoritative PostgreSQL state
```

Con:

```text
private =
NON-EXPOSED SCHEMA

public resolver arguments =
ZERO

identity anchor =
auth.uid() only

ordinary CompanyMembership RLS =
PRESERVED

SUPER_ADMIN ordinary tenant bypass =
NO

ordinary service-role resolver =
NO

generic privileged client =
NO
```

Debe quedar expresamente fuera de la sincronización cualquier afirmación de que `private` es una convención global obligatoria.

Debe además reflejar:

```text
TASK-015 =
DETERMINED / SPECIFIED / HUMAN-APPROVED / CANONICALIZED

TASK-015 implementation authorized =
NO

TASK-015 implementation started =
NO

Fase 2 =
INICIADA / NOT DONE
```

La sección debe continuar distinguiendo foundations físicas de capabilities funcionales completas.

---

## 15. §17 — Resultado final

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

El resumen activo resultante debe incluir, como mínimo:

```text
CORR-020 =
DONE / CLOSED

CORR-021 =
DONE / CLOSED

CORR-021 implementation commit =
b8e96bd89b246b663647711e5ad11d9dba9c2bde

CORR-021 FINAL HUMAN CLOSURE =
APPROVED

CORR-021 Hosted Development =
PASS

CORR-021 blocker of TASK-015 =
RESOLVED
```

```text
TASK-015 determinada =
SÍ

TASK-015 especificada =
SÍ

TASK-015 aprobada humanamente =
SÍ

TASK-015 canonicalizada =
SÍ

TASK-015 implementation authorized =
NO

TASK-015 implementation started =
NO
```

Debe preservar como pendientes:

```text
Auth funcional =
NO

lifecycle funcional completo de users/memberships =
NO

disable/reinstate/role-change funcional =
NO

Productores funcionales completos de AuditEvent =
NO

auditoría funcional completa =
NO
```

Y la frontera de fases:

```text
Fase 2 iniciada =
SÍ

Fase 2 completada =
NO

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Fase 3 iniciada =
NO

TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED

Siguiente TASK autorizada automáticamente =
NO
```

No es obligatorio duplicar toda la topología post-CORR-021 en §17 si queda suficientemente registrada en §14.2.

---

## 16. Historia normativa inmutable

CORR-022 no puede reescribir:

- TASK-014 histórica;
- CORR-019;
- TASK-015 histórica;
- CORR-020;
- CORR-021;
- ADR;
- snapshots históricos dentro de SOURCE A claramente identificados como estados de un momento anterior;
- cierre de Fase 0;
- cierre de Fase 1;
- Gate e inicio formal de Fase 2;
- resultados cerrados de TASK-008..014.

Una declaración histórica como:

```text
TASK-015 implementation authorized = NO
```

dentro de la propia specification histórica de TASK-015 continúa siendo correcta como snapshot.

El drift existe únicamente cuando SOURCE A conserva como estado activo actual declaraciones superadas por cierres posteriores.

---

## 17. Capacidades que deben continuar pendientes

CORR-022 no puede declarar como completas:

- Auth funcional;
- Auth SSR lifecycle completo;
- Refresh funcional de access token;
- Proxy/middleware Auth funcional;
- Authorization ready;
- Application authorization completa;
- route authorization funcional completa;
- resource authorization funcional completa;
- Client;
- UserClientAccess completo;
- SupportAccessGrant completo;
- Client authorization;
- Support authorization;
- Storage funcional;
- Realtime funcional;
- Offline authorization;
- Offline funcional;
- UI/Auth flow funcional completo;
- onboarding funcional completo;
- alta funcional completa;
- lifecycle funcional completo de usuarios/memberships;
- disable/reinstate/role-change funcional;
- SUPER_ADMIN grant funcional;
- SUPER_ADMIN revoke funcional;
- SUPER_ADMIN bootstrap funcional;
- SUPER_ADMIN management funcional;
- productores funcionales completos de AuditEvent;
- auditoría funcional completa.

TASK-015 aún no materializó sus operaciones.

---

## 18. Frontera exacta de TASK-015 post-CORR-022

El estado activo futuro debe ser exactamente compatible con:

```text
TASK-015 =
DETERMINED / SPECIFIED / HUMAN-APPROVED / CANONICALIZED

CORR-020 documentation prerequisite =
SATISFIED

CORR-021 security blocker =
RESOLVED

TASK-015 implementation authorized =
NO

TASK-015 implementation started =
NO

Codex TASK-015 =
NOT AUTHORIZED

Supabase Cloud TASK-015 =
NOT AUTHORIZED

next implementation automatically authorized =
NO
```

Se preserva:

```text
CORR-021 DONE
!=
TASK-015 IMPLEMENTATION AUTHORIZED

CORR-022 DONE
!=
TASK-015 IMPLEMENTATION AUTHORIZED
```

Una futura autorización de TASK-015 requiere un acto humano separado posterior a todos los Gates documentales aplicables.

---

## 19. TASK-016 hard stop

Debe permanecer exactamente:

```text
TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED
```

CORR-022 no puede:

- determinar TASK-016;
- priorizar TASK-016;
- diseñar TASK-016;
- generar TASK-016;
- inferir TASK-016 desde CORR-021;
- inferir TASK-016 desde una futura ejecución de TASK-015.

---

## 20. Producto, dominio y arquitectura

Resultado de esta specification:

```text
new product decision =
NO

new domain decision =
NO

new role decision =
NO

new architecture decision =
NO

new ADR required =
NO

multitenancy semantic change =
NO

RLS semantic change =
NO

offline strategy change =
NO

provider boundary change =
NO

Auth architecture change =
NO
```

CORR-022 registra estado aprobado existente. No crea comportamiento nuevo.

---

## 21. Seguridad, RLS y multitenancy

Resultado obligatorio:

```text
security change =
NO

RLS physical change =
NO

RLS policy change =
NO

grant change =
NO

database function change =
NO

schema change =
NO

Supabase config change =
NO

tenant isolation change =
NO

ordinary CompanyMembership RLS =
PRESERVED

SUPER_ADMIN ordinary tenant bypass =
NO

generic privileged client =
NO

service-role ordinary resolver =
NO
```

No se produce SQL ni pseudo-SQL ejecutable.

El hardening post-CORR-021 se documenta como materialización ya cerrada; CORR-022 no lo implementa ni lo modifica.

---

## 22. UI

```text
UI change =
NO
```

No se modifica flujo UI.

No se habilita UI de administración de memberships.

No se habilitan disable/reinstate/role-change.

---

## 23. Offline

```text
offline strategy change =
NO

administrative membership writes offline =
NO

outbox administrativo =
NO
```

No se reabre `ADR-0005` ni `docs/product/04-offline-sync-strategy.md`.

---

## 24. Provider boundary

```text
provider research required for CORR-022 =
NO
```

CORR-022 no toma una decisión provider-side nueva ni modifica el contrato técnico ya cerrado por CORR-021.

La specification no usa investigación web para sustituir las fuentes canónicas.

Si durante una futura ejecución una fuente canónica vigente introduce una contradicción provider real que cambie el contrato material:

```text
BLOCKER
RETURN TO REVISOR CENTRAL
```

---

## 25. CHANGE REQUIRED / CHANGE FORBIDDEN

### 25.1 CHANGE REQUIRED

| Tipo | Path / superficie |
| --- | --- |
| archivo | `docs/product/11-phase-1-scope-entry-gate.md` |
| sección | §7.9 |
| sección | §10.2 |
| sección | §14.2 |
| sección | §17 |

### 25.2 CHANGE FORBIDDEN

Quedan fuera de alcance:

- todos los demás documentos de producto;
- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- todos los ADR;
- todos los TASK;
- todos los CORR;
- source code;
- TypeScript;
- SQL;
- migrations;
- RLS policies;
- grants/revokes;
- Supabase config;
- package files;
- tests;
- Supabase Cloud;
- Hosted Development;
- Staging;
- Production.

CORR-020 ya tuvo la responsabilidad de sincronizar DECISION-001..006 en `01/02/03`. CORR-022 no reabre ese trabajo.

---

## 26. Precondiciones de una futura ejecución

Una futura ejecución documental sólo puede comenzar después de:

1. `CORR-022 SPEC REVIEW = APPROVED`;
2. aprobación humana formal de la specification;
3. generación del artefacto físico aprobado mediante Gate separado;
4. approved artifact review = `APPROVED`;
5. canonicalización mediante Gate separado;
6. canonicalization review = `APPROVED`;
7. incorporación Git canónica mediante Gates separados;
8. autorización humana separada de ejecución;
9. preflight Git fresco;
10. relectura íntegra del target y fuentes canónicas vigentes;
11. verificación de exactamente cuatro superficies stale;
12. ausencia de quinta superficie;
13. confirmación de un único target;
14. ausencia de contradicción material con el estado actual;
15. confirmación de que la ejecución sigue siendo documentation-only.

Ningún Gate anterior implica automáticamente el siguiente.

---

## 27. Preflight obligatorio de futura ejecución

Antes de modificar SOURCE A, el implementador autorizado debe verificar como mínimo:

```text
repo root
branch
HEAD
origin/main
remote main
divergence
worktree
staged
tracked unstaged
untracked
Git operations in progress
```

Además:

```text
target path exists =
YES

target current SHA-256 =
<FRESH VALUE>

CORR-022 canonical SHA-256 =
<APPROVED FUTURE VALUE>

TASK-015 canonical source =
PRESENT / VERIFIED

CORR-020 canonical source =
PRESENT / VERIFIED

CORR-021 canonical source =
PRESENT / VERIFIED

active stale surfaces =
EXACTLY 4

unexpected active stale surfaces =
0
```

Si cualquiera falla:

```text
BLOCKER
STOP
```

El baseline Git de cierre de CORR-021 es evidencia histórica y no puede reutilizarse como sustituto de este preflight.

---

## 28. Plan futuro de ejecución documental

Sólo después de cumplir §26 y §27:

1. releer íntegramente el target canónico vigente;
2. confirmar los localizadores semánticos §7.9, §10.2, §14.2 y §17;
3. confirmar que no existe una quinta superficie activa stale;
4. aplicar únicamente la sincronización definida por la matriz de §11;
5. preservar historia normativa;
6. preservar resultados cerrados de TASK-008..014;
7. preservar `Fase 2 = INICIADA / NOT DONE`;
8. preservar `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED`;
9. preservar `Fase 3 = NOT STARTED`;
10. registrar CORR-020 y CORR-021 como cerradas;
11. registrar TASK-015 como determinada/especificada/aprobada/canonicalizada, pero no autorizada ni iniciada;
12. preservar TASK-016 intacta;
13. no tocar 01/02/03, ADR, TASK, CORR ni código;
14. no producir SQL, migrations, RLS ni cambios de configuración;
15. revisar el diff para demostrar exactamente un archivo modificado;
16. verificar que el diff semántico se limita a las cuatro superficies;
17. ejecutar `git diff --check`;
18. someter el diff a revisión humana;
19. no hacer staging sin Gate separado;
20. no hacer commit sin Gate separado;
21. no hacer push sin Gate separado;
22. verificar Git final sólo después de los Gates correspondientes;
23. solicitar cierre humano final;
24. no iniciar TASK-015;
25. no determinar TASK-016.

---

## 29. Blockers

**BLOCKER-022-001 — REQUIRED SOURCE UNAVAILABLE**

Una source obligatoria A/B/C/D no está físicamente disponible cuando debe verificarse.

**BLOCKER-022-002 — SOURCE IDENTITY MISMATCH**

Una source obligatoria no coincide con la identidad física aprobada aplicable.

**BLOCKER-022-003 — UNEXPECTED ACTIVE STALE SURFACE**

La coherencia activa requiere modificar una quinta superficie de SOURCE A.

**BLOCKER-022-004 — SECOND TARGET REQUIRED**

La sincronización requiere modificar un segundo archivo.

**BLOCKER-022-005 — CURRENT CANONICAL STATE CONTRADICTS DETERMINATION**

El canon vigente contradice materialmente la determinación aprobada o el estado humano posterior consumido.

**BLOCKER-022-006 — NEW PRODUCT DECISION REQUIRED**

La corrección no puede completarse sin crear o modificar una decisión de producto.

**BLOCKER-022-007 — NEW ARCHITECTURE DECISION / ADR REQUIRED**

La corrección no puede completarse sin una decisión arquitectónica nueva o un ADR.

**BLOCKER-022-008 — SECURITY / RLS SEMANTIC CHANGE REQUIRED**

La corrección exige cambiar seguridad, RLS, grants, tenant isolation o trust model.

**BLOCKER-022-009 — TASK-015 IMPLEMENTATION WOULD BE REQUIRED**

La corrección sólo puede completarse implementando alguna capability de TASK-015.

**BLOCKER-022-010 — TASK-016 WOULD NEED DETERMINATION**

La corrección exige determinar, generar o diseñar TASK-016.

**BLOCKER-022-011 — SCOPE CANNOT REMAIN DOCUMENTATION-ONLY**

El trabajo necesario deja de ser una corrección estrictamente documental.

**BLOCKER-022-012 — UNAUTHORIZED GIT OR TARGET DRIFT**

El preflight futuro detecta branch/base/worktree/target incompatible con la autorización.

**BLOCKER-022-013 — EXACT FOUR-SURFACE CONTRACT CANNOT BE PROVEN**

La futura ejecución no puede demostrar de forma read-only que el cambio sigue limitado exactamente a §7.9, §10.2, §14.2 y §17.

Ante cualquier blocker:

```text
STOP
no silent repair
no scope expansion
no Git mutation
no TASK-015 implementation
no TASK-016
RETURN TO REVISOR CENTRAL
```

---

## 30. Acceptance Criteria

**AC-022-001.** Las cuatro fuentes obligatorias A/B/C/D están físicamente disponibles durante la generación de esta especificación.
**AC-022-002.** SOURCE A coincide con SHA-256 `72704c6af20c4591cf3139b6a5646795efd8b516cd33cdd92b064c7968e3b925`, `75005` bytes, `1363` LF, `0` CRLF, `0` bare CR y newline final presente.
**AC-022-003.** SOURCE B coincide con SHA-256 `483fb591d8069ef5ae4371b80ffe768bc34b221292a2acc1f60d01a7cbd05473`, `60806` bytes, `1942` LF, `0` CRLF, `0` bare CR, `0` líneas con trailing whitespace y newline final presente.
**AC-022-004.** SOURCE C coincide con SHA-256 `c00a9018a7d3293e5beff8fa3422f930d2a62a4078aa7b25a4e7d9f519f77e20`, `94753` bytes, `3309` LF, `0` CRLF, `0` bare CR, `0` líneas con trailing whitespace y newline final presente.
**AC-022-005.** SOURCE D coincide con SHA-256 `63847257b3483fcb4488697532b3636628a623876b75e05dc6077d8f7875d229`, `60720` bytes, `1686` LF, `0` CRLF, `0` bare CR, `0` líneas con trailing whitespace y newline final presente.
**AC-022-006.** Las sources A/B/C/D fueron leídas íntegramente durante el Gate de generación; no se reconstruyó su contenido desde memoria, resúmenes ni conversación histórica.
**AC-022-007.** El único target de una futura ejecución es `docs/product/11-phase-1-scope-entry-gate.md`.
**AC-022-008.** `CHANGE REQUIRED file count = 1` y ningún segundo target es necesario.
**AC-022-009.** Las únicas superficies `CHANGE REQUIRED` son §7.9, §10.2, §14.2 y §17.
**AC-022-010.** `active stale surface count = 4`.
**AC-022-011.** `unexpected active stale surfaces = 0` después de auditar íntegramente SOURCE A.
**AC-022-012.** Una quinta superficie activa necesaria obliga a `BLOCKER — UNEXPECTED ACTIVE STALE SURFACE` y prohíbe ampliar scope silenciosamente.
**AC-022-013.** `CORR-020 = DONE / CLOSED` queda reflejado como estado activo posterior.
**AC-022-014.** `CORR-020 documentation prerequisite for TASK-015 = SATISFIED` queda reflejado.
**AC-022-015.** `CORR-021 = DONE / CLOSED` queda reflejado como estado activo posterior.
**AC-022-016.** `CORR-021 FINAL HUMAN CLOSURE = APPROVED` queda reflejado.
**AC-022-017.** `CORR-021 implementation commit = b8e96bd89b246b663647711e5ad11d9dba9c2bde` queda registrado como evidencia de cierre.
**AC-022-018.** `CORR-021 Hosted Development = PASS` y `CORR-021 migration = APPLIED EXACTLY ONCE` quedan registrados donde aporten trazabilidad.
**AC-022-019.** `CORR-021 blocker of TASK-015 = RESOLVED` queda inequívoco.
**AC-022-020.** La topología física vigente se registra como `caller-scoped Supabase client → public.resolve_current_global_authority() SECURITY INVOKER → private.resolve_current_global_authority() SECURITY DEFINER → authoritative PostgreSQL state`.
**AC-022-021.** `private = NON-EXPOSED SCHEMA` queda preservado para la implementación purpose-specific cerrada de CORR-021.
**AC-022-022.** CORR-022 no eleva `private` a `MANDATORY GLOBAL NAMING CONVENTION` ni crea una convención arquitectónica general nueva.
**AC-022-023.** `public.resolve_current_global_authority()` conserva `arguments = ZERO` en el estado documentado.
**AC-022-024.** `identity anchor = auth.uid() only` queda preservado.
**AC-022-025.** `TASK-014 product semantics changed by CORR-021 = NO` queda preservado.
**AC-022-026.** `ordinary CompanyMembership RLS changed = NO` queda preservado.
**AC-022-027.** `SUPER_ADMIN ordinary tenant bypass = NO` queda preservado.
**AC-022-028.** `ordinary service-role resolver = NO` y `generic privileged client = NO` quedan preservados.
**AC-022-029.** `TASK-015 = DETERMINED / SPECIFIED / HUMAN-APPROVED / CANONICALIZED` queda reflejado como estado activo.
**AC-022-030.** `TASK-015 SPEC REVIEW = APPROVED` y `TASK-015 HUMAN SPEC APPROVAL = APPROVED` quedan reflejados.
**AC-022-031.** `TASK-015 implementation authorized = NO` queda explícito.
**AC-022-032.** `TASK-015 implementation started = NO` queda explícito.
**AC-022-033.** `Codex TASK-015 = NOT AUTHORIZED` y `Supabase Cloud TASK-015 = NOT AUTHORIZED` quedan preservados.
**AC-022-034.** `CORR-021 DONE != TASK-015 IMPLEMENTATION AUTHORIZED` queda explícitamente preservado.
**AC-022-035.** `CORR-022 DONE != TASK-015 IMPLEMENTATION AUTHORIZED` queda explícitamente preservado.
**AC-022-036.** `Fase 2 = INICIADA / NOT DONE` queda preservado.
**AC-022-037.** `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED` queda preservado.
**AC-022-038.** `Fase 3 = NOT STARTED` queda preservado.
**AC-022-039.** `TASK-016 = NOT DETERMINED / NOT GENERATED / NOT STARTED` queda preservado sin inferencia ni diseño.
**AC-022-040.** Los resultados cerrados de TASK-008..014 se preservan y no se reescribe su historia normativa.
**AC-022-041.** Los snapshots históricos de TASK-014, CORR-019, TASK-015, CORR-020 y CORR-021 permanecen inmutables.
**AC-022-042.** CORR-022 no declara `Auth funcional` como completa.
**AC-022-043.** CORR-022 no declara completo el lifecycle funcional de usuarios/memberships ni `disable/reinstate/role-change`.
**AC-022-044.** CORR-022 no declara completos `UserClientAccess`, `SupportAccessGrant`, Client authorization ni Support authorization.
**AC-022-045.** CORR-022 no declara completos Storage, Realtime, Offline authorization, Offline funcional ni UI/Auth flow funcional.
**AC-022-046.** CORR-022 no declara completos los productores funcionales de AuditEvent ni la auditoría funcional completa.
**AC-022-047.** `new product decision = NO`, `new domain decision = NO`, `new role decision = NO` y `new architecture decision = NO`.
**AC-022-048.** `new ADR required = NO`.
**AC-022-049.** `multitenancy semantic change = NO` y `tenant isolation change = NO`.
**AC-022-050.** `security change = NO`, `RLS physical change = NO`, `RLS policy change = NO`, `grant change = NO`, `database function change = NO`, `schema change = NO` y `Supabase config change = NO`.
**AC-022-051.** `UI change = NO` y no se habilita UI de administración de memberships.
**AC-022-052.** `offline strategy change = NO`, `administrative membership writes offline = NO` y `outbox administrativo = NO`.
**AC-022-053.** `provider research required for CORR-022 = NO`; CORR-022 consume el contrato ya cerrado por CORR-021 sin tomar decisiones provider-side nuevas.
**AC-022-054.** La futura ejecución modifica exactamente un archivo y exclusivamente las cuatro superficies autorizadas, salvo ajuste puramente mecánico imprescindible para mantener Markdown válido.
**AC-022-055.** Ningún documento `01/02/03`, ADR, TASK, CORR, source code, TypeScript, SQL, migration, RLS, grant, Supabase config, package file o test puede modificarse por CORR-022.
**AC-022-056.** Supabase Cloud, Hosted Development, Staging y Production permanecen `NO CHANGE` durante la generación y durante la futura ejecución de CORR-022; ninguna mutación de esos entornos forma parte del scope de esta corrección documental.
**AC-022-057.** La futura ejecución exige preflight Git fresco y no reutiliza como autoridad operativa el baseline histórico `b8e96bd89b246b663647711e5ad11d9dba9c2bde`.
**AC-022-058.** El preflight futuro verifica repo root, branch, HEAD, origin/main, remote main, divergence, worktree, staged, tracked unstaged, untracked y operaciones Git en progreso.
**AC-022-059.** El preflight futuro verifica target existente, SHA fresco del target, SHA canónico futuro de CORR-022 y presencia/identidad de TASK-015, CORR-020 y CORR-021 canónicas.
**AC-022-060.** El preflight futuro vuelve a demostrar `active stale surfaces = EXACTLY 4` y `unexpected active stale surfaces = 0` antes de cualquier escritura.
**AC-022-061.** El diff futuro debe ser documental mínimo, limitado al drift aprobado y superar `git diff --check`.
**AC-022-062.** Staging, commit y push permanecen Gates humanos separados; ninguno se deriva de la aprobación o ejecución documental.
**AC-022-063.** El cierre técnico/documental futuro requiere revisión humana del diff y todos los AC aplicables en PASS.
**AC-022-064.** CORR-022 sólo puede declararse `DONE / CLOSED` después del cierre humano final.
**AC-022-065.** La specification queda `APPROVED FOR EXECUTION` por aprobación humana formal; este estado no autoriza la ejecución, no auto-canonicaliza y no equivale a `DONE`.
**AC-022-066.** `next gate = CORR-022 APPROVED ARTIFACT REVIEW`.

---

## 31. Definition of Done

**DoD-022-001.** La presente generación del artefacto aprobado finaliza con artefacto físico nuevo `CORR-022-corr-021-closure-state-sync-approved-corrected-v2.md` y estado `APPROVED FOR EXECUTION`.
**DoD-022-002.** `CORR-022 SPEC REVIEW = APPROVED` mediante Gate separado ya completado.
**DoD-022-003.** Existe aprobación humana formal de la specification mediante Gate separado.
**DoD-022-004.** Se genera el artefacto formalmente aprobado mediante Gate separado, sin drift no autorizado respecto de la specification revisada.
**DoD-022-005.** El approved artifact supera `CORR-022 APPROVED ARTIFACT REVIEW`.
**DoD-022-006.** CORR-022 se canonicaliza mediante Gate separado.
**DoD-022-007.** La canonicalización supera revisión humana/técnica correspondiente.
**DoD-022-008.** El artefacto canónico se incorpora a Git mediante Gate separado.
**DoD-022-009.** La incorporación Git canónica supera su revisión.
**DoD-022-010.** Existe autorización humana separada y explícita para ejecutar la corrección documental.
**DoD-022-011.** Antes de escribir, la ejecución realiza preflight Git fresco completo y verifica que no existen operaciones Git en progreso ni drift incompatible.
**DoD-022-012.** Antes de escribir, la ejecución relee el target y las fuentes canónicas vigentes de CORR-020, TASK-015 y CORR-021.
**DoD-022-013.** El preflight confirma exactamente un target: `docs/product/11-phase-1-scope-entry-gate.md`.
**DoD-022-014.** El preflight confirma exactamente cuatro superficies activas stale: §7.9, §10.2, §14.2 y §17.
**DoD-022-015.** El preflight confirma `unexpected active stale surfaces = 0`; cualquier quinta superficie detiene la ejecución.
**DoD-022-016.** La ejecución documental modifica exactamente el único target autorizado.
**DoD-022-017.** El diff modifica semánticamente sólo §7.9, §10.2, §14.2 y §17 y no introduce cambios laterales no necesarios.
**DoD-022-018.** El estado resultante refleja CORR-020 y CORR-021 cerradas, TASK-015 preparada documentalmente pero no autorizada/iniciada y TASK-016 intacta.
**DoD-022-019.** El estado resultante preserva la topología post-CORR-021, RLS, multitenancy y capacidades funcionales todavía pendientes.
**DoD-022-020.** El diff documental supera revisión humana y `git diff --check = PASS`.
**DoD-022-021.** Todos los `AC-022-*` aplicables resultan `PASS`.
**DoD-022-022.** Staging sólo ocurre mediante Gate humano separado.
**DoD-022-023.** Commit sólo ocurre mediante Gate humano separado.
**DoD-022-024.** Push sólo ocurre mediante Gate humano separado.
**DoD-022-025.** El commit remoto final y la convergencia Git se verifican explícitamente mediante Gate/review correspondiente.
**DoD-022-026.** La revisión final confirma que no se modificó código, SQL, migrations, RLS, Supabase Cloud, Hosted Development ni producto/arquitectura fuera del scope.
**DoD-022-027.** Existe cierre humano final de CORR-022.
**DoD-022-028.** `CORR-022 = DONE / CLOSED` se declara únicamente después del cierre humano final y mantiene expresamente `CORR-022 DONE != TASK-015 IMPLEMENTATION AUTHORIZED`.

---

## 32. Estado de la specification generada

```text
CORR-022 DETERMINATION =
APPROVED

CORR-022 SPECIFICATION GENERATION GATE =
AUTHORIZED

CORR-022 SPECIFICATION =
APPROVED FOR EXECUTION

CORR-022 SPEC REVIEW =
APPROVED

CORR-022 HUMAN SPEC APPROVAL =
APPROVED

CORR-022 aprobada =
SÍ

CORR-022 canonicalized =
NO

CORR-022 execution authorized =
NO

target document modified =
NO

repository modified =
NO

Codex authorized =
NO

Supabase Cloud =
NO CHANGE

Git =
NO CHANGE

TASK-015 implementation authorized =
NO

TASK-015 implementation started =
NO

TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED

state =
APPROVED FOR EXECUTION

artifact =
CORR-022-corr-021-closure-state-sync-approved-corrected-v2.md

next gate =
CORR-022 APPROVED ARTIFACT REVIEW
```

---

## 33. Resultado de generación

La generación de esta specification no ejecuta CORR-022.

No modifica SOURCE A/B/C/D.

No modifica el target.

No modifica el repositorio.

No autoriza Codex.

No modifica Supabase Cloud, Hosted Development, Staging ni Production.

No implementa TASK-015.

No determina TASK-016.

```text
CORR-022 SPECIFICATION GENERATION =
PASS

blockers =
NONE

target files =
1

active stale surfaces =
4

unexpected active stale surfaces =
0

new product decision =
NO

new ADR required =
NO

TASK-015 implementation authorized =
NO

TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED

next gate =
CORR-022 APPROVED ARTIFACT REVIEW
```

RETURN TO REVISOR CENTRAL.
