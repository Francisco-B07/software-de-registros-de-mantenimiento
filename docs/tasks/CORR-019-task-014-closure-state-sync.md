# CORR-019 — Sincronización documental posterior al cierre de TASK-014

## 1. Identificación

**ID:** `CORR-019`

**Título:** `CORR-019 — Sincronización documental posterior al cierre de TASK-014`

**Tipo:** `CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO`

**Naturaleza:** exclusivamente documental.

**Estado:** `APPROVED FOR IMPLEMENTATION`

**CORR-019 SPECIFICATION:** `APPROVED FOR IMPLEMENTATION`

**CORR-019 SPEC REVIEW:** `APPROVED`

**CORR-019 HUMAN SPEC APPROVAL:** `APPROVED`

**Archivo de entrega:** `CORR-019-task-014-closure-state-sync-approved.md`

**Ruta canónica futura propuesta:** `docs/tasks/CORR-019-task-014-closure-state-sync.md`

**Fuente activa target:** `docs/product/11-phase-1-scope-entry-gate.md`

**CHANGE REQUIRED file count:** `1`

**Implementación realizada por esta especificación:** `NO`

**Repositorio modificado:** `NO`

**Supabase Cloud modificado:** `NO`

**Staging / commit / push:** `NO / NO / NO`

**Architecture change required:** `NO`

**New ADR required:** `NO`

**Technical implementation required:** `NO`

**TASK-015 determinada / generada / iniciada:** `NO / NO / NO`

La identificación de `CORR-019` y la apertura de este Gate de especificación fueron autorizadas humanamente de forma expresa después del audit read-only post-cierre de TASK-014.

La existencia de esta especificación no autoriza su canonicalización, ejecución, modificación del repositorio ni ninguna operación Git.

---

## 2. Objetivo único

CORR-019 tiene como objetivo exclusivo sincronizar el estado activo de:

`docs/product/11-phase-1-scope-entry-gate.md`

después del cierre técnico, Hosted Development, Git y humano de TASK-014.

La futura corrección debe eliminar únicamente el drift documental activo que todavía representa TASK-014 como no determinada, no generada o no iniciada.

La sincronización debe registrar el resultado cerrado y acotado de TASK-014 sin convertir su foundation de identidad/autorización global en Auth funcional completo, sin ampliar capacidades y sin reescribir historia normativa.

Debe preservarse la regla:

**sincronizar estado activo != reescribir snapshots históricos**

CORR-019 no implementa una capability, no modifica arquitectura, no cambia dominio, no cambia seguridad ni RLS y no determina el siguiente incremento.

---

## 3. Contexto formal consumido

El estado formal consumido por esta especificación es:

- `TASK-014 = DONE / CLOSED`;
- `TASK-014 FINAL HUMAN CLOSURE REVIEW = APPROVED`;
- `TASK-014 LOCAL IMPLEMENTATION REVIEW = APPROVED`;
- `TASK-014 HOSTED DEVELOPMENT REVIEW = APPROVED`;
- `TASK-014 TECHNICAL STAGING REVIEW = APPROVED`;
- `TASK-014 TECHNICAL COMMIT REVIEW = APPROVED`;
- `TASK-014 TECHNICAL PUSH REVIEW = APPROVED`;
- `TASK-014 implementation commit = 6b681309b3be19cbff2a785cae759131d4bf659f`;
- `HEAD = 6b681309b3be19cbff2a785cae759131d4bf659f`;
- `origin/main = 6b681309b3be19cbff2a785cae759131d4bf659f`;
- `divergence = 0 0`;
- `worktree = CLEAN`;
- `TASK-014 AC = 98 / 98 PASS`;
- `TASK-014 DoD = 68 / 68 PASS`;
- `Phase 2 = INICIADA / NOT DONE`;
- `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED`;
- `Phase 3 = NOT STARTED`;
- `Auth funcional = NO`;
- `TASK-015 = NOT DETERMINED / NOT GENERATED / NOT STARTED`.

El cierre de TASK-014 no convierte automáticamente ninguna capability pendiente en funcionalmente completa y no determina TASK-015.

---

## 4. Audit read-only post-cierre consumido

El audit read-only autorizado después del cierre de TASK-014 produjo:

| Control | Resultado |
| --- | --- |
| Branch | `main` |
| HEAD | `6b681309b3be19cbff2a785cae759131d4bf659f` |
| origin/main | `6b681309b3be19cbff2a785cae759131d4bf659f` |
| Divergence | `0 0` |
| Worktree | `CLEAN` |
| Repository writes | `NONE` |
| Active stale surfaces | `4` |
| Unexpected active stale surfaces | `0` |
| Documentary synchronization required | `YES` |

Las cuatro superficies activas stale confirmadas son:

1. §7.9 — Otras decisiones `DO-*`;
2. §10.2 — Requisito para entrar en Fase 2;
3. §14.2 — Condición adicional para cruzar hacia Fase 2;
4. §17 — Resultado final.

El audit excluyó correctamente como falsos positivos históricos las referencias anteriores a TASK-014 contenidas en ADR, TASK y CORR cuyo propósito es preservar el estado existente en el momento de su respectivo acto de gobernanza.

Resultado:

- `EXPECTED ACTIVE STALE SURFACES = 4`;
- `UNEXPECTED ACTIVE STALE SURFACES = 0`;
- `DOCUMENTARY SYNC REQUIRED = YES`;
- `TASK-015 DETERMINATION BLOCKED BY DOCUMENTARY SYNC = YES`.

Este audit sólo valida la base usada para redactar la especificación. La futura ejecución deberá repetir un preflight Git y una verificación semántica frescos antes de modificar el target.

---

## 5. Fuentes normativas

CORR-019 consume como fuentes mínimas:

### 5.1 Producto

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- `docs/product/04-offline-sync-strategy.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`.

### 5.2 Arquitectura

- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`;
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`;
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`.

### 5.3 Tareas y correcciones de estado

- `docs/tasks/CORR-018-task-013-closure-state-sync.md`;
- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`.

### 5.4 Evidencia de cierre posterior al snapshot canónico de TASK-014

La especificación canónica de TASK-014 es un contrato y snapshot histórico de su estado documental previo a la ejecución. El estado actual post-ejecución se determina por los Gates humanos posteriores y el estado Git final verificado.

Se consume como hecho posterior y autoritativo dentro de este alcance:

`TASK-014 = DONE / CLOSED`

con commit final:

`6b681309b3be19cbff2a785cae759131d4bf659f — feat(auth): implement TASK-014 global super-admin foundation`

### 5.5 Orden de autoridad

Para CORR-019 se aplica:

1. cierre humano final y Gates posteriores expresamente aprobados;
2. estado real final de Git y commit de implementación;
3. documentos canónicos vigentes dentro de la materia que gobiernan;
4. snapshots históricos, interpretados según su momento de gobernanza.

Una referencia histórica que declara `TASK-014 implementation = NOT STARTED` conserva validez histórica y no debe reescribirse retroactivamente.

---

## 6. Precondiciones para futura ejecución

La futura ejecución de CORR-019 requiere:

1. revisión humana de esta especificación;
2. `CORR-019 SPEC REVIEW = APPROVED`;
3. aprobación humana formal de la especificación;
4. canonicalización mediante Gate separado cuando corresponda;
5. revisión de la canonicalización;
6. incorporación Git del artefacto canónico mediante Gates separados;
7. autorización humana separada de ejecución documental;
8. preflight Git fresco;
9. branch, HEAD y `origin/main` exactamente en el baseline que autorice el Gate de ejecución;
10. worktree limpio y sin operaciones Git en progreso;
11. existencia del único target autorizado;
12. lectura íntegra del target vigente;
13. confirmación de que §7.9, §10.2, §14.2 y §17 siguen siendo las únicas superficies activas stale derivadas del cierre de TASK-014;
14. ausencia de una quinta superficie activa que requiera modificación;
15. ausencia de contradicción material entre el cierre de TASK-014 y las fuentes normativas vigentes;
16. preservación inequívoca de `Phase 2 = INICIADA / NOT DONE`;
17. preservación inequívoca de `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED`;
18. preservación inequívoca de `Phase 3 = NOT STARTED`;
19. preservación inequívoca de `Auth funcional = NO`;
20. preservación inequívoca de `TASK-015 = NOT DETERMINED / NOT GENERATED / NOT STARTED`.

El incumplimiento de una precondición obliga a detener la ejecución.

---

## 7. Hechos aprobados que deben poder quedar reflejados

La futura corrección debe registrar, sólo donde sean semánticamente necesarios para restaurar coherencia:

- `TASK-014 = DONE / CLOSED`;
- `TASK-014 FINAL HUMAN CLOSURE REVIEW = APPROVED`;
- `TASK-014 implementation commit = 6b681309b3be19cbff2a785cae759131d4bf659f`;
- `global SUPER_ADMIN identity/authorization foundation = IMPLEMENTADA`;
- `public.platform_users.is_super_admin = boolean NOT NULL DEFAULT false`;
- `public.resolve_current_global_authority() = IMPLEMENTADA`;
- `purpose-specific SECURITY DEFINER = YES`;
- `identity source = auth.uid() only`;
- `business identity arguments = 0`;
- `disabled CompanyMembership counts as existing for dual-authority inconsistency detection = YES`;
- `ordinary company_memberships RLS changed = NO`;
- `SUPER_ADMIN ordinary tenant bypass = NO`;
- `service-role ordinary resolver = NO`;
- `generic privileged client = NO`;
- `Hosted Development verification = PASS`;
- `TASK-014 AC = 98 / 98 PASS`;
- `TASK-014 DoD = 68 / 68 PASS`.

No es obligatorio repetir todos estos hechos en cada una de las cuatro superficies.

La redacción debe utilizar sólo el subconjunto necesario para corregir el estado vivo y mantener trazabilidad.

---

## 8. Capacidades y estados que deben continuar pendientes

CORR-019 no puede convertir la foundation de TASK-014 en una capacidad funcional completa.

El estado activo resultante debe preservar, donde corresponda:

- `Auth funcional = NO`;
- `UI/Auth flow funcional completo = NO`;
- `onboarding funcional completo = NO`;
- `alta funcional completa = NO`;
- `SUPER_ADMIN grant funcional = NO`;
- `SUPER_ADMIN revoke funcional = NO`;
- `SUPER_ADMIN bootstrap funcional = NO`;
- `SUPER_ADMIN management funcional = NO`;
- `MaintenanceCompany creation funcional = NO` salvo capability futura expresamente aprobada;
- `lifecycle funcional completo de users/memberships = NO`;
- `CompanyMembership disable/reinstate/role-change funcional = NO`;
- `route authorization funcional completa = NO`;
- `resource authorization funcional completa = NO`;
- `Application authorization completa = NO`;
- `AuditEvent producers funcionales completos = NO`;
- `auditoría funcional completa = NO`;
- `UserClientAccess completo = NO`;
- `SupportAccessGrant completo = NO`;
- `Phase 2 = INICIADA / NOT DONE`;
- `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED`;
- `Phase 3 = NOT STARTED`;
- `TASK-015 determinada = NO`;
- `TASK-015 generada = NO`;
- `TASK-015 iniciada = NO`.

Debe distinguirse expresamente:

`global SUPER_ADMIN identity/authorization foundation = IMPLEMENTADA`

de:

`Auth funcional = NO`

Y también:

`read-only global authority resolution = IMPLEMENTADA`

de:

`SUPER_ADMIN management/grant/revoke/bootstrap = NO`

---

## 9. Drift detectado

La auditoría read-only confirmó drift activo exclusivamente en:

- §7.9, líneas auditadas 610-624;
- §10.2, líneas auditadas 782-850;
- §14.2, línea auditada 1102;
- §17, líneas auditadas 1285-1345.

Los números de línea son evidencia del snapshot auditado y no deben usarse como únicos localizadores durante la ejecución.

Las cuatro superficies presentan total o parcialmente estados como:

- `TASK-014 determinada = NO`;
- `TASK-014 generada = NO`;
- `TASK-014 iniciada = NO`;
- resúmenes de Fase 2 cuyo último incremento cerrado es TASK-013;
- una frontera de siguiente tarea que todavía apunta a TASK-014 como no determinada.

Esos estados contradicen el cierre posterior aprobado:

- TASK-014 fue determinada;
- TASK-014 fue especificada y canonicalizada;
- TASK-014 fue implementada localmente;
- TASK-014 fue verificada en Hosted Development;
- TASK-014 fue incorporada y publicada en Git;
- TASK-014 obtuvo cierre humano final;
- TASK-014 está `DONE / CLOSED`.

Resultado:

- `EXPECTED ACTIVE STALE SURFACES = 4`;
- `UNEXPECTED ACTIVE STALE SURFACES = 0`;
- `SPECIFICATION BLOCKER — UNEXPECTED ACTIVE STALE SURFACE = NO`.

---

## 10. Alcance

### 10.1 Único target autorizado

La futura ejecución sólo puede modificar:

`docs/product/11-phase-1-scope-entry-gate.md`

`CHANGE REQUIRED file count = 1`

### 10.2 Superficies autorizadas

Dentro del único target, el cambio debe limitarse conceptualmente a:

- §7.9;
- §10.2;
- §14.2;
- §17.

Los números de sección son localizadores semánticos. No autorizan reemplazos ciegos ni cambios laterales.

### 10.3 Naturaleza del cambio

El cambio autorizado consiste exclusivamente en:

- reemplazar estado activo stale por estado post-cierre de TASK-014;
- preservar resultados cerrados de TASK-008 a TASK-013;
- incorporar el resultado cerrado y acotado de TASK-014;
- preservar ADR-0019 y las decisiones previas como antecedentes vigentes/históricos según corresponda;
- conservar como historia los estados previos de especificación y autorización de TASK-014;
- mover la frontera de “siguiente TASK no determinada” desde TASK-014 hacia TASK-015;
- mantener expresamente pendientes las capacidades funcionales no implementadas;
- mantener Phase 2 iniciada pero no completada;
- mantener Phase 3 no iniciada.

---

## 11. Fuera de alcance

Queda expresamente fuera de alcance:

- código;
- TypeScript;
- package files;
- SQL;
- migrations;
- RLS;
- policies;
- grants o revokes;
- Supabase config;
- Supabase Cloud;
- Hosted Development;
- Auth configuration;
- signing keys;
- hooks;
- secrets o credenciales;
- tests técnicos de TASK-014;
- modificación de TASK-014;
- modificación de CORR-018;
- modificación de ADR-0002, ADR-0003 o ADR-0019;
- modificación de cualquier otro documento;
- nueva decisión de producto;
- nueva decisión de dominio;
- nueva decisión arquitectónica;
- nueva ADR;
- creación o modificación de un Phase 2 Exit Gate;
- cierre de Phase 2;
- inicio de Phase 3;
- determinación de TASK-015;
- generación de TASK-015;
- especificación de TASK-015;
- implementación de TASK-015;
- selección o priorización formal de la siguiente capability;
- reactivación o selección automática de candidatos diferidos históricos;
- staging;
- commit;
- push.

La existencia de candidatos previamente registrados para una futura tarea no autoriza asignarles el ID TASK-015.

---

## 12. CHANGE REQUIRED

### 12.1 Archivo

`docs/product/11-phase-1-scope-entry-gate.md`

### 12.2 Cantidad

`1 archivo`

### 12.3 Secciones

- §7.9;
- §10.2;
- §14.2;
- §17.

### 12.4 Regla de mínima modificación

El diff debe ser el mínimo necesario para que las cuatro superficies expresen coherentemente el estado post-TASK-014.

No se autoriza:

- reestructuración general;
- reformateo lateral;
- renumeración;
- limpieza estilística no necesaria;
- cambio de terminología ajeno al drift;
- actualización oportunista de otras fases o tareas;
- incorporación de requisitos de TASK-015;
- normalización masiva de wording.

---

## 13. CHANGE FORBIDDEN

Está prohibido modificar cualquier path distinto de:

`docs/product/11-phase-1-scope-entry-gate.md`

En particular, permanecen inmutables:

- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`;
- `docs/tasks/CORR-018-task-013-closure-state-sync.md`;
- todos los ADR;
- todos los demás TASK/CORR;
- todos los demás archivos bajo `docs/`;
- `app/`;
- `src/`;
- `tests/`;
- `supabase/`;
- `.env` y `.env.example`;
- `package.json`;
- `package-lock.json`;
- cualquier archivo de configuración.

También está prohibido modificar una sección distinta de las cuatro autorizadas.

Si una quinta superficie activa resulta necesaria para lograr coherencia:

`SPECIFICATION BLOCKER — UNEXPECTED ACTIVE STALE SURFACE`

La ejecución debe detenerse sin incorporar esa superficie silenciosamente.

---

## 14. Detalle por sección

### 14.1 §7.9 — Otras decisiones `DO-*`

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

**Estado stale auditado:**

La sección registra correctamente el estado de Fase 2 posterior a TASK-013, pero todavía mantiene la frontera vigente como:

- `TASK-014 determinada = NO`;
- `TASK-014 generada = NO`;
- `TASK-014 iniciada = NO`.

**Contradicción:**

TASK-014 ya está formalmente `DONE / CLOSED` y su foundation global fue implementada, verificada en Development y publicada en `main`.

**Estado final requerido:**

La sección debe registrar de forma acotada:

- `TASK-014 = DONE / CLOSED`;
- foundation mínima de identidad/autorización global de `SUPER_ADMIN` = implementada;
- `public.platform_users.is_super_admin` materializada como `boolean NOT NULL DEFAULT false`;
- resolver global purpose-specific implementado y DB-authoritative;
- ordinary tenant RLS no adquiere bypass;
- capacidades funcionales no cubiertas por TASK-014 continúan pendientes;
- `Phase 2 = INICIADA / NOT DONE`;
- frontera posterior = `TASK-015 NOT DETERMINED / NOT GENERATED / NOT STARTED`;
- siguiente TASK autorizada automáticamente = `NO`.

No es obligatorio repetir todos los detalles técnicos de TASK-014.

### 14.2 §10.2 — Requisito para entrar en Fase 2

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

**Estado stale auditado:**

La sección conserva como frontera viva la regla que termina en TASK-013 y mantiene TASK-014 como no determinada/generada/iniciada.

**Contradicción:**

La secuencia histórica fue correcta en CORR-018, pero TASK-014 ya atravesó determinación, especificación, canonicalización, implementación, Hosted Development, Git y cierre humano.

**Estado final requerido:**

La sección debe:

- preservar que Fase 2 ya está iniciada;
- preservar los resultados cerrados de TASK-008..013;
- registrar TASK-014 como cerrada;
- resumir su resultado técnico exclusivamente como foundation global acotada;
- mantener que `Auth funcional = NO`;
- mantener que Phase 2 todavía no está terminada;
- mantener que el cierre de TASK-014 no determina automáticamente TASK-015;
- establecer inequívocamente:
  - `TASK-015 determinada = NO`;
  - `TASK-015 generada = NO`;
  - `TASK-015 iniciada = NO`.

La regla vigente debe poder expresarse conceptualmente como:

`TASK-014 = DONE / CLOSED != TASK-015 determinada automáticamente`

### 14.3 §14.2 — Condición adicional para cruzar hacia Fase 2

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

**Estado stale auditado:**

El consolidado actual todavía conserva `TASK-014 determinada/generada/iniciada = NO`.

**Contradicción:**

Ese consolidado ya no representa el estado real posterior al cierre de TASK-014.

**Estado final requerido:**

Debe incluir, sólo al nivel de detalle necesario:

- TASK-014 cerrada;
- foundation global de `SUPER_ADMIN` implementada y verificada;
- `is_super_admin` como fuente física explícita actual;
- resolución global purpose-specific y fail-closed;
- `CompanyMembership` sigue siendo autoridad tenant, sin bypass global ordinario;
- `Auth funcional = NO`;
- capacidades funcionales pendientes siguen pendientes;
- `Phase 2 = INICIADA / NOT DONE`;
- `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED` cuando la sección represente ese estado;
- `Phase 3 = NOT STARTED`;
- `TASK-015 = NOT DETERMINED / NOT GENERATED / NOT STARTED`.

### 14.4 §17 — Resultado final

**Clasificación:** `ACTIVE STALE REFERENCE — CHANGE`

**Estado stale auditado:**

El resumen final termina en TASK-013 y declara TASK-014 no determinada, no generada o no iniciada.

**Contradicción:**

El resumen final es una superficie viva y debe reflejar el cierre de TASK-014.

**Estado final requerido:**

Debe registrar:

- `TASK-014 = DONE / CLOSED`;
- `TASK-014 final human closure = APPROVED`;
- `TASK-014 implementation commit = 6b681309b3be19cbff2a785cae759131d4bf659f` cuando corresponda mantener trazabilidad equivalente a tareas anteriores;
- foundation mínima global implementada;
- Hosted Development verification = PASS, si el resumen usa ese nivel de evidencia;
- `Auth funcional = NO`;
- `Phase 2 = INICIADA / NOT DONE`;
- `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED`;
- `Phase 3 = NOT STARTED`;
- `TASK-015 = NOT DETERMINED / NOT GENERATED / NOT STARTED`.

No puede seleccionar ni describir formalmente el contenido de TASK-015.

---

## 15. Requisitos documentales de CORR-019

### 15.1 Requisitos obligatorios

**RD-001.** Modificar exactamente un archivo.

**RD-002.** Modificar conceptualmente sólo §7.9, §10.2, §14.2 y §17.

**RD-003.** Representar TASK-014 como `DONE / CLOSED`.

**RD-004.** Representar la foundation global sin sobredeclararla como Auth funcional completo.

**RD-005.** Preservar `public.platform_users.is_super_admin = boolean NOT NULL DEFAULT false` si se menciona su shape físico.

**RD-006.** Preservar que la resolución global es purpose-specific, server-side/DB-authoritative y no deriva autoridad de ausencia de membership.

**RD-007.** Preservar que `CompanyMembership` continúa gobernando autoridad tenant ordinaria.

**RD-008.** Preservar `SUPER_ADMIN ordinary tenant bypass = NO`.

**RD-009.** Preservar `ordinary company_memberships RLS changed = NO`.

**RD-010.** Preservar `Auth funcional = NO`.

**RD-011.** Preservar pendientes grant/revoke/bootstrap/management funcional de `SUPER_ADMIN`.

**RD-012.** Preservar pendientes los slices funcionales de lifecycle de memberships y capacidades funcionales no cerradas.

**RD-013.** Preservar `Phase 2 = INICIADA / NOT DONE`.

**RD-014.** Preservar `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED`.

**RD-015.** Preservar `Phase 3 = NOT STARTED`.

**RD-016.** Mover exclusivamente la frontera de siguiente tarea no determinada a TASK-015.

**RD-017.** Preservar `TASK-015 = NOT DETERMINED / NOT GENERATED / NOT STARTED`.

**RD-018.** No determinar ni priorizar TASK-015.

**RD-019.** No reescribir snapshots históricos.

**RD-020.** No introducir cambios técnicos, arquitectónicos, de dominio, seguridad, RLS o Cloud.

**RD-021.** Mantener el diff mínimo y semánticamente localizado.

**RD-022.** No incorporar secrets ni información sensible.

---

## 16. Arquitectura, dominio y decisiones

### 16.1 Arquitectura

`architecture change = NO`

CORR-019 sólo sincroniza el estado documental activo de una architecture ya implementada y aprobada.

No modifica ni amplía ADR-0002, ADR-0003 ni ADR-0019.

### 16.2 ADR

`new ADR required = NO`

No existe una decisión arquitectónica nueva dentro de esta corrección.

### 16.3 Dominio

`domain change = NO`

Debe preservarse:

- `PlatformUser` como identidad de aplicación;
- `SUPER_ADMIN` como autoridad global/platform-scoped;
- `CompanyMembership` como autoridad tenant ordinaria;
- roles tenant materializados `COMPANY_ADMIN | TECHNICIAN`;
- ausencia de membership `!= SUPER_ADMIN`;
- global+membership coexistente = estado inconsistente / deny según la foundation cerrada.

CORR-019 no redefine entidades, relaciones, invariantes ni lifecycle.

---

## 17. Seguridad

- `security implementation = NONE`;
- `security change = NO`;
- `Auth behavior change = NONE`;
- `secret handling change = NONE`.

La corrección sólo documenta un estado ya implementado y verificado.

Está prohibido que la redacción:

- revele secrets;
- incorpore tokens, passwords, keys o credenciales;
- sugiera autoridad global por claim stale, metadata o frontend state;
- transforme una sesión Auth válida en autorización global o tenant;
- represente `SECURITY DEFINER` como una capability genérica privilegiada;
- sugiera service-role como resolver ordinario de aplicación;
- represente el resolver global como capacidad de grant/revoke;
- transforme la foundation en bypass tenant.

Debe preservarse:

`authenticated != authorized`

---

## 18. RLS y multitenancy

- `RLS implementation = NONE`;
- `RLS change = NO`;
- `tenant isolation behavior change = NONE`;
- `policy change = NO`;
- `grant/revoke change = NO`.

Debe preservarse:

- `tenant = MaintenanceCompany`;
- `CompanyMembership` conserva autoridad tenant ordinaria;
- membership disabled puede seguir oculta por la RLS ordinaria;
- la existencia de membership disabled sólo fue resuelta purpose-specifically para detectar inconsistencia global/tenant;
- `SUPER_ADMIN` no obtiene bypass ordinario de tenant RLS;
- RLS conserva su función de frontera primaria de aislamiento remoto para datos tenant-owned;
- current authoritative database state prevalece sobre claims o client state stale.

CORR-019 no modifica policies ni grants.

---

## 19. UI, offline, reporting y Cloud

### 19.1 UI

`UI change = NO`

No existe flujo UI autorizado por CORR-019.

### 19.2 Offline

`offline behavior change = NO`

La corrección no afecta outbox, sync, leases, drafts, evidencias ni conflicto offline.

### 19.3 Reporting

`reporting change = NO`

No afecta PDF, DOCX ni reporting engine.

### 19.4 AI credits / subscriptions

`AI credits change = NO`

`subscription/payment change = NO`

### 19.5 Supabase Cloud

- `Supabase Cloud change = NO`;
- `Hosted Development mutation = NO`;
- `Auth configuration mutation = NO`;
- `Staging = NO CHANGE`;
- `Production = NO CHANGE`.

CORR-019 puede documentar que Hosted Development verification de TASK-014 fue PASS cuando sea necesario para trazabilidad.

No puede repetir ni reabrir esas operaciones.

---

## 20. Criterios de aceptación

Cada criterio deberá evaluarse individualmente como `PASS` o `FAIL` durante la futura ejecución.

**AC-001.** El único archivo modificado es `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-002.** §7.9 queda sincronizada con el cierre aprobado de TASK-014.

**AC-003.** §10.2 queda sincronizada con el cierre aprobado de TASK-014.

**AC-004.** §14.2 queda sincronizada con el cierre aprobado de TASK-014.

**AC-005.** §17 queda sincronizada con el cierre aprobado de TASK-014.

**AC-006.** TASK-014 queda representada como `DONE / CLOSED` o equivalente inequívoco de cierre.

**AC-007.** La foundation mínima de identidad/autorización global de `SUPER_ADMIN` queda representada como implementada sin declarar Auth funcional completo.

**AC-008.** Si se registra el shape físico, `public.platform_users.is_super_admin` queda descrito como `boolean NOT NULL DEFAULT false`.

**AC-009.** Si se registra el resolver, queda descrito como purpose-specific, autoritativo y sin target identity caller-supplied.

**AC-010.** `CompanyMembership` continúa representada como autoridad tenant ordinaria y no como fuente de `SUPER_ADMIN`.

**AC-011.** `SUPER_ADMIN ordinary tenant bypass = NO` continúa inequívoco.

**AC-012.** La RLS ordinaria de `company_memberships` no se presenta como modificada por TASK-014.

**AC-013.** `Auth funcional = NO` continúa inequívoco.

**AC-014.** Grant/revoke/bootstrap/management funcional de `SUPER_ADMIN` continúa fuera del estado implementado.

**AC-015.** Ninguna capability funcional no implementada es sobredeclarada.

**AC-016.** `Phase 2 = INICIADA / NOT DONE` continúa inequívoco.

**AC-017.** `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED` continúa inequívoco donde se representa el estado de fase.

**AC-018.** `Phase 3 = NOT STARTED` continúa inequívoco.

**AC-019.** TASK-015 queda `NOT DETERMINED / NOT GENERATED / NOT STARTED`.

**AC-020.** No se determina, prioriza, especifica ni inicia TASK-015.

**AC-021.** La historia normativa no se reescribe.

**AC-022.** Ningún documento histórico es modificado.

**AC-023.** No existe cambio de arquitectura, dominio, seguridad, RLS o multitenancy.

**AC-024.** No existe cambio en Supabase Cloud, Hosted Development, Staging o Production.

**AC-025.** No se modifica ni crea ningún path inesperado.

**AC-026.** `git diff --check = PASS`.

**AC-027.** No se incorporan secrets ni material sensible.

Un único `FAIL` impide declarar la ejecución de CORR-019 como satisfactoria.

---

## 21. Verificaciones de la futura ejecución

Antes de editar, Codex deberá verificar:

1. repo root exacto;
2. branch exacta;
3. HEAD exacto autorizado;
4. `origin/main` exacto autorizado;
5. divergencia;
6. worktree;
7. staged changes;
8. untracked changes;
9. operaciones Git en progreso;
10. existencia del target;
11. lectura íntegra del target;
12. lectura de las fuentes canónicas necesarias;
13. vigencia semántica de las cuatro superficies;
14. ausencia de superficies activas stale adicionales;
15. estado cerrado de TASK-014;
16. estado de Phase 2;
17. estado del Phase 2 Exit Gate;
18. estado de Phase 3;
19. frontera TASK-015 todavía no determinada.

Después de editar deberá verificar:

1. exactamente un archivo modificado;
2. exactamente cuatro superficies semánticas afectadas;
3. ningún path adicional;
4. ninguna sección adicional;
5. ningún snapshot histórico reescrito;
6. `Auth funcional = NO` preservado;
7. Phase 2 preservada `INICIADA / NOT DONE`;
8. Phase 2 Exit Gate preservado `NOT DEFINED / NOT SATISFIED`;
9. Phase 3 preservada `NOT STARTED`;
10. TASK-015 preservada `NOT DETERMINED / NOT GENERATED / NOT STARTED`;
11. ausencia de cambios técnicos;
12. ausencia de cambios Cloud;
13. ausencia de secrets;
14. `git diff --check = PASS`;
15. diff completo revisado;
16. todos los AC = PASS;
17. cambios permanecen unstaged hasta Gate posterior.

---

## 22. Plan de ejecución futura para Codex

Cuando exista autorización humana separada de ejecución, Codex deberá:

1. realizar preflight Git fresco;
2. detenerse ante cualquier drift del baseline autorizado;
3. leer íntegramente la especificación canónica de CORR-019;
4. leer íntegramente `docs/product/11-phase-1-scope-entry-gate.md`;
5. confirmar semánticamente las cuatro superficies autorizadas;
6. confirmar que no apareció una quinta superficie stale derivada del cierre de TASK-014;
7. modificar exclusivamente `docs/product/11-phase-1-scope-entry-gate.md`;
8. modificar exclusivamente §7.9, §10.2, §14.2 y §17;
9. registrar el cierre acotado de TASK-014;
10. preservar los límites funcionales negativos;
11. preservar la historia normativa;
12. mover exclusivamente la frontera no determinada a TASK-015;
13. mantener Phase 2 iniciada pero no completada;
14. mantener Phase 2 Exit Gate no definido/no satisfecho;
15. mantener Phase 3 no iniciada;
16. inspeccionar el diff completo;
17. ejecutar `git diff --check`;
18. verificar ausencia de secrets y cambios técnicos;
19. dejar todos los cambios unstaged;
20. devolver evidencia al Revisor Central.

Codex no deberá realizar `git add`, commit ni push sin Gates humanos posteriores y separados.

---

## 23. Blockers

### 23.1 Estado actual de esta especificación

- `GIT BASELINE DRIFT = NO` según audit consumido;
- `UNEXPECTED ACTIVE STALE SURFACE = NO`;
- `MISSING CANONICAL SOURCE = NO` según evidencia consumida;
- `ARCHITECTURE CONTRADICTION = NO`;
- `DOMAIN CONTRADICTION = NO`;
- `SECURITY/RLS CONTRADICTION = NO`;
- `CURRENT SPECIFICATION BLOCKER = NONE`.

### 23.2 Condiciones de blocker para la futura ejecución

La ejecución debe detenerse si:

1. branch, HEAD, `origin/main` o divergencia no coinciden con la autorización;
2. el worktree no está limpio o existe una operación Git incompatible;
3. falta una fuente canónica requerida;
4. el target no existe;
5. cambió materialmente la función semántica de una de las cuatro secciones;
6. aparece una superficie activa stale adicional derivada del cierre de TASK-014;
7. un segundo archivo requiere modificación;
8. se necesita modificar una sección no autorizada;
9. no puede distinguirse historia de estado activo;
10. la corrección exige reescribir historia;
11. se necesita cambiar producto, dominio o arquitectura;
12. se necesita cambiar seguridad, RLS o multitenancy;
13. se necesita modificar Supabase Cloud, Hosted Development, Staging o Production;
14. se necesita escribir código, SQL o migrations;
15. se necesita modificar tests o configuración técnica;
16. se necesita determinar, diseñar o generar TASK-015;
17. el diff incluye un path inesperado;
18. se detecta un secret;
19. `git diff --check` falla;
20. cualquier criterio de aceptación falla;
21. Phase 2 tendría que declararse completada;
22. Phase 3 tendría que declararse iniciada;
23. Phase 2 Exit Gate tendría que inventarse, definirse o declararse satisfecho sin acto separado;
24. la redacción exige presentar `SUPER_ADMIN` como bypass tenant;
25. la redacción exige presentar Auth funcional como completo.

Para una quinta superficie activa:

`SPECIFICATION BLOCKER — UNEXPECTED ACTIVE STALE SURFACE`

Para drift Git:

`CORR-019 SPECIFICATION/EXECUTION = BLOCKER — GIT BASELINE DRIFT`

Ante cualquier blocker:

- no ampliar scope;
- no reparar lateralmente;
- no incorporar nuevas superficies silenciosamente;
- no determinar TASK-015;
- no hacer staging;
- no hacer commit;
- no hacer push;
- devolver el blocker exacto al Revisor Central.

---

## 24. Git governance

CORR-019 preserva la secuencia:

**specification → human review → approval → canonicalization → canonicalization review → canonical artifact Git incorporation → separate execution authorization → execution → execution review → staging Gate → commit Gate → push Gate → exact remote verification → final human closure**

Deben permanecer separados:

- especificación;
- revisión humana;
- aprobación;
- canonicalización;
- incorporación Git de la especificación;
- autorización de ejecución;
- ejecución;
- revisión del diff;
- staging;
- commit;
- push;
- cierre humano.

La existencia de esta especificación no autoriza operación Git alguna.

`CORR-019 SPECIFICATION = PASS` no equivale a:

- `CORR-019 SPEC REVIEW = APPROVED`;
- canonicalización realizada;
- ejecución autorizada;
- ejecución realizada;
- staging autorizado;
- commit autorizado;
- push autorizado;
- CORR-019 completada.

---

## 25. Definition of Done de CORR-019

CORR-019 sólo podrá considerarse completada cuando:

1. esta especificación haya sido revisada humanamente;
2. `CORR-019 SPEC REVIEW = APPROVED`;
3. exista aprobación humana formal;
4. la especificación se canonicalice mediante Gate aplicable;
5. la canonicalización sea revisada;
6. la especificación canónica sea incorporada a Git mediante Gates separados;
7. exista autorización humana separada de ejecución;
8. el preflight Git fresco resulte PASS;
9. la auditoría pre-ejecución confirme exactamente cuatro superficies autorizadas;
10. se modifique exactamente un archivo;
11. §7.9 quede sincronizada;
12. §10.2 quede sincronizada;
13. §14.2 quede sincronizada;
14. §17 quede sincronizada;
15. TASK-014 quede representada como `DONE / CLOSED`;
16. el cierre humano de TASK-014 quede representado donde corresponda sin reescribir su snapshot canónico;
17. la foundation global de `SUPER_ADMIN` quede representada sin sobredeclaración funcional;
18. `is_super_admin` conserve su semántica aprobada cuando sea mencionada;
19. la resolución global conserve su semántica purpose-specific/fail-closed cuando sea mencionada;
20. `Auth funcional = NO` continúe inequívoco;
21. grant/revoke/bootstrap/management funcional de `SUPER_ADMIN` continúe pendiente;
22. las capacidades funcionales restantes continúen pendientes;
23. `Phase 2 = INICIADA / NOT DONE` continúe inequívoco;
24. `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED` continúe inequívoco;
25. `Phase 3 = NOT STARTED` continúe inequívoco;
26. TASK-015 continúe no determinada, no generada y no iniciada;
27. la historia normativa permanezca intacta;
28. no exista cambio técnico, arquitectónico, de dominio, seguridad, RLS, multitenancy o Cloud;
29. no exista un path inesperado;
30. no se incorporen secrets;
31. todos los criterios de aceptación resulten PASS;
32. `git diff --check = PASS`;
33. el diff completo sea revisado humanamente;
34. staging, commit y push ocurran únicamente mediante Gates posteriores;
35. Git final y remote exact commit sean verificados;
36. exista cierre humano final de CORR-019.

Debe mantenerse:

`execution PASS != CORR-019 completed`

Y:

`CORR-019 completed != TASK-015 determined automatically`

---

## 26. Estado de esta especificación

- `CORR-019 IDENTIFICATION = AUTHORIZED`;
- `CORR-019 SPECIFICATION GATE = AUTHORIZED`;
- `CORR-019 SPECIFICATION = APPROVED FOR IMPLEMENTATION`;
- `CORR-019 estado = APPROVED FOR IMPLEMENTATION`;
- `CORR-019 SPEC REVIEW = APPROVED`;
- `CORR-019 HUMAN SPEC APPROVAL = APPROVED`;
- `CORR-019 canonicalizada = NO`;
- `CORR-019 ejecución autorizada = NO`;
- `CORR-019 ejecutada = NO`;
- `CORR-019 completada = NO`;
- `CHANGE REQUIRED = 1`;
- `EXPECTED ACTIVE STALE SURFACES = 4`;
- `UNEXPECTED ACTIVE STALE SURFACES = 0`;
- `architecture change = NO`;
- `new ADR required = NO`;
- `technical implementation = NO`;
- `repository modification = NO`;
- `Supabase Cloud modification = NO`;
- `staging = NO`;
- `commit = NO`;
- `push = NO`;
- `TASK-015 determination = NOT PERFORMED`;
- `TASK-015 generated = NO`.

`APPROVED FOR IMPLEMENTATION` describe exclusivamente el estado documental aprobado de esta especificación y no autoriza canonicalización ni ejecución de CORR-019.

---

## 27. Gate posterior

El siguiente acto válido es:

`CORR-019 APPROVED ARTIFACT REVIEW`

La aprobación documental formal no autoriza todavía la canonicalización; el artefacto aprobado debe superar primero este Gate separado.

No corresponde todavía:

- canonicalización de CORR-019;
- ejecución de CORR-019;
- Codex;
- modificación del repositorio;
- `git add`;
- commit;
- push;
- Supabase Cloud;
- Staging;
- Production;
- determinación de TASK-015;
- generación de TASK-015.

---

## 28. Autoverificación

```text
filename =
CORR-019-task-014-closure-state-sync-approved.md

title exact = YES

ID = CORR-019

type = CORRECCIÓN DOCUMENTAL CONTROLADA DE ESTADO

nature = DOCUMENTARY ONLY

state = APPROVED FOR IMPLEMENTATION

SPECIFICATION = APPROVED FOR IMPLEMENTATION

SPEC REVIEW = APPROVED

CHANGE REQUIRED file count = 1

authorized target =
docs/product/11-phase-1-scope-entry-gate.md

authorized sections =
§7.9 / §10.2 / §14.2 / §17

expected stale active surfaces = 4

unexpected active stale surfaces = 0

TASK-014 = DONE / CLOSED

Auth funcional = NO

Phase 2 = INICIADA / NOT DONE

Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED

Phase 3 = NOT STARTED

TASK-015 = NOT DETERMINED / NOT GENERATED / NOT STARTED

architecture change = NO

new ADR required = NO

technical implementation required = NO

Cloud required = NO

AC count = 27

DoD count = 36

repository modified = NO

staging / commit / push = NO / NO / NO

next gate = CORR-019 APPROVED ARTIFACT REVIEW
```

<!-- FIN DEL DOCUMENTO CORR-019-task-014-closure-state-sync-approved.md -->
