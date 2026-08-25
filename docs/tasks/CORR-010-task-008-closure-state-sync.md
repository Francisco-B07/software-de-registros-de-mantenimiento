# CORR-010 — Sincronización documental posterior al cierre de TASK-008

## 1. Identificación

**ID:** `CORR-010`

**Título:** `Sincronización documental posterior al cierre de TASK-008`

**Tipo:** `CORRECCIÓN DOCUMENTAL DE CONSISTENCIA`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`CORR-010-task-008-closure-state-sync-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/CORR-010-task-008-closure-state-sync.md`

**Naturaleza:** exclusivamente documental.

**Implementación realizada:** `NO`

**Codex utilizado durante esta preparación:** `NO`

**Repositorio modificado durante esta preparación:** `NO`

**Supabase Cloud modificado durante esta preparación:** `NO`

**TASK-009 generada:** `NO`

**TASK-009 autorizada:** `NO`

La evidencia read-only recibida determina que el mayor identificador de corrección existente es `CORR-009` y que no existe una `CORR-010` canónica incompatible en el inventario inspeccionado.

Antes de cualquier futura canonicalización o ejecución deberá repetirse la comprobación contra el repositorio real.

Si ya existe una `CORR-010` incompatible:

`BLOCKER`

No renumerar por inferencia.

---

## 2. Objetivo único

CORR-010 tiene un único objetivo:

> sincronizar el estado documental **activo** posterior al cierre humano de `TASK-008 — Frontera de integración Supabase de la aplicación` con el estado real ya verificado del proyecto, eliminando contradicciones y referencias activas stale que actualmente impiden al Revisor Central determinar con seguridad el siguiente incremento de Fase 2.

CORR-010:

- no crea el cierre de TASK-008;
- no reevalúa TASK-008;
- no cambia el contrato técnico aprobado de TASK-008;
- no determina el siguiente incremento;
- no diseña TASK-009;
- no autoriza TASK-009;
- no implementa ninguna capacidad del producto.

Su efecto es exclusivamente documental:

```text
estado humano y técnico ya cerrado
→ sincronización de referencias activas incompatibles
→ documentación coherente
→ retorno al Revisor Central
```

---

## 3. Naturaleza y límites de autoridad

Esta corrección es una corrección documental de consistencia.

No constituye:

- decisión de producto;
- decisión arquitectónica;
- implementación;
- diseño físico;
- especificación de Auth;
- especificación de schema;
- especificación RLS;
- nueva TASK;
- autorización de ejecución.

CORR-010 consume estados humanos y técnicos ya producidos y los sincroniza únicamente donde la documentación **activa** todavía expresa un estado incompatible.

La regla fundamental es:

```text
sincronizar estado activo
≠
reescribir historia
```

Una referencia que describa correctamente el estado existente cuando un ADR, TASK o CORR fue aprobado, canonicalizado o ejecutado debe preservarse como histórica, aunque el proyecto haya avanzado posteriormente.

---

## 4. Estado Git autoritativo recibido para redactar CORR-010

Se consume como evidencia read-only:

```text
branch = main
HEAD = dc132796d18bc1046cb15454f1c2f6e78fd6c505
origin/main = dc132796d18bc1046cb15454f1c2f6e78fd6c505
divergencia = 0 0
worktree = limpio
staged = ninguno
untracked = ninguno
```

Último commit:

```text
dc132796d18bc1046cb15454f1c2f6e78fd6c505
feat: add Supabase application boundary
```

Este SHA es evidencia histórica del snapshot utilizado para redactar CORR-010.

No debe reutilizarse ciegamente como SHA obligatorio de una futura canonicalización o ejecución, porque las etapas documentales posteriores producirán naturalmente un estado Git diferente.

Cada etapa posterior deberá realizar su propio preflight y verificar como mínimo:

- repositorio correcto;
- branch autorizada;
- upstream esperado;
- divergencia;
- worktree;
- staged;
- untracked;
- ausencia de colisión documental.

---

## 5. Estado humano autoritativo posterior a TASK-008

CORR-010 consume como estado humano de cierre ya producido:

```text
Fase 1 = COMPLETADA

Gate de entrada a Fase 2 evaluado = SÍ
Gate de entrada a Fase 2 satisfecho = SÍ

PHASE 2 FORMAL START = APPROVED
PHASE 2 FORMAL START HUMAN REVIEW = APPROVED

Fase 2 = INICIADA

TASK-008 canonicalizada = SÍ
TASK-008 implementada = SÍ
TASK-008 incorporada a Git = SÍ
TASK-008 revisión humana final = APROBADA
TASK-008 = COMPLETADA
```

Clasificación:

`ESTADO HUMANO EXTERNO AUTORITATIVO CONSUMIDO POR CORR-010`

CORR-010 no crea ninguno de estos estados.

Una futura ejecución deberá recibirlos nuevamente dentro de la autorización humana concreta y verificar que no exista contradicción con la especificación canónica de CORR-010.

Si los estados suministrados durante una futura ejecución difieren materialmente:

`BLOCKER`

---

## 6. Resultado técnico cerrado de TASK-008

El resultado técnico que CORR-010 debe preservar es:

```text
Supabase application boundary = IMPLEMENTADA

Browser factory = IMPLEMENTADA
Server factory no privilegiada = IMPLEMENTADA

Auth funcional = NO
Auth SSR lifecycle completo = NO
Refresh funcional de access token = NO
Proxy/middleware Auth funcional = NO
Authorization ready = NO

Schema = NO
Migrations = NO
SQL = NO
RLS ejecutable = NO
Storage = NO
Realtime = NO
UI = NO
Offline = NO
```

La existencia de una factory server-side no privilegiada no debe reinterpretarse como:

- Auth funcional;
- autorización;
- tenancy funcional;
- RLS;
- session lifecycle completo;
- refresh funcional;
- privilegio;
- `service-role`;
- acceso operativo a datos.

La corrección debe preservar explícitamente la separación:

```text
Supabase application boundary
≠
Supabase Auth funcional
≠
Auth SSR lifecycle completo
≠
autorización
≠
tenancy
≠
RLS
```

---

## 7. Inventario documental y secuencia vigente

La inspección read-only recibida determinó:

```text
TASK-008 canónica =
docs/tasks/TASK-008-supabase-application-boundary.md

mayor TASK existente = TASK-008
mayor CORR existente = CORR-009

TASK-009 existente = NO
referencias a TASK-009 dentro de /docs = ninguna
```

La secuencia procesal relevante es:

```text
CORR-007
→ ADR-0003 ACCEPTED sincronizado

CORR-008
→ Gate de entrada a Fase 2 evaluado/satisfecho

CORR-009
→ Fase 2 iniciada

TASK-008
→ primera implementación PR-sized de Fase 2
```

No se detectó drift técnico respecto del alcance aprobado de TASK-008.

---

## 8. Fuentes de verdad obligatorias

Antes de una futura ejecución deberán leerse íntegramente, como mínimo:

### 8.1 Producto y governance

- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md`

### 8.2 Arquitectura

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`

### 8.3 TASK y CORR relevantes

- `docs/tasks/TASK-007-phase-1-smoke-docs-review.md`
- `docs/tasks/CORR-007-adr-0003-accepted-state-sync.md`
- `docs/tasks/CORR-008-phase-2-entry-gate-state-sync.md`
- `docs/tasks/CORR-009-phase-2-formal-start-state-sync.md`
- `docs/tasks/TASK-008-supabase-application-boundary.md`

### 8.4 Estado técnico real

La futura ejecución debe volver a inspeccionar read-only:

- Git;
- el inventario de `/docs`;
- el diff previo;
- la implementación de la frontera Supabase necesaria para verificar que no apareció drift material respecto del cierre recibido.

No deben utilizarse fuentes externas para redefinir estado documental, producto, roles, multitenancy, Auth, RLS o alcance de TASK-008.

---

## 9. Contradicciones confirmadas que originan CORR-010

En `docs/product/11-phase-1-scope-entry-gate.md` existen superficies activas que ya expresan correctamente:

```text
Gate de entrada a Fase 2 evaluado = SÍ
Gate de entrada a Fase 2 satisfecho = SÍ

PHASE 2 FORMAL START = APPROVED
PHASE 2 FORMAL START HUMAN REVIEW = APPROVED

Fase 2 = INICIADA
```

Sin embargo, el mismo documento conserva posteriormente referencias activas:

```text
Fase 1 completada: no
Fase 2 iniciada: no
```

Ambas son contradicciones respecto del estado global actual.

La inspección también localizó referencias materiales que todavía presentan a TASK-008 como:

- no autorizada;
- no redactada;
- pendiente como siguiente unidad futura.

Las localizaciones recibidas son aproximadas y no constituyen autorización automática de cambio.

Una futura ejecución debe auditar el documento completo y clasificar cada coincidencia antes de modificarla.

---

## 10. Principio histórico obligatorio para TASK-008

La especificación canónica:

`docs/tasks/TASK-008-supabase-application-boundary.md`

debe clasificarse inicialmente:

`NO CHANGE REQUIRED`

No debe convertirse retrospectivamente:

```text
TASK-008 = APPROVED FOR IMPLEMENTATION
```

en:

```text
TASK-008 = DONE
```

dentro de su contrato canónico.

Las declaraciones:

```text
Implementación autorizada = NO
Codex autorizado = NO
Ejecución concreta autorizada = NO
```

describen el acto histórico de aprobación documental de TASK-008 y no deben reescribirse como si hubieran significado otra cosa en ese momento.

El Gate de TASK-008 que expresa:

```text
un PASS de TASK-008 no autoriza automáticamente la siguiente tarea
```

también debe preservarse.

La situación correcta es:

```text
contrato histórico de TASK-008
= APPROVED FOR IMPLEMENTATION

estado humano posterior del ciclo de TASK-008
= COMPLETADA
```

No existe contradicción entre ambas afirmaciones cuando se distinguen sus niveles de autoridad y momento temporal.

---

## 11. Scope documental inicial

### 11.1 `CHANGE REQUIRED`

Único archivo inicialmente autorizado para modificación:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Cantidad prevista de archivos modificables:

```text
1
```

### 11.2 `NO CHANGE REQUIRED`

```text
docs/product/10-architecture-decisions-records.md
docs/tasks/TASK-008-supabase-application-boundary.md
docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

### 11.3 `HISTORICAL/GOVERNANCE — KEEP`

```text
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
docs/tasks/CORR-007-adr-0003-accepted-state-sync.md
docs/tasks/CORR-008-phase-2-entry-gate-state-sync.md
docs/tasks/CORR-009-phase-2-formal-start-state-sync.md
```

Si una futura auditoría demuestra que otro documento contiene una referencia **activa** que necesita modificación para alcanzar la coherencia requerida:

`UNEXPECTED — BLOCKER`

No ampliar scope automáticamente.

CORR-010 deberá volver a revisión antes de autorizar cualquier archivo adicional.

---

## 12. Auditoría documental integral obligatoria

Antes de modificar cualquier archivo, la futura ejecución deberá buscar como mínimo:

```text
Fase 1 completada
Fase 1 = COMPLETADA
Fase 1 completada: no

Fase 2 iniciada
Fase 2 = INICIADA
Fase 2 iniciada: no

TASK-008
TASK-008 autorizada
TASK-008 redactada
TASK-008 implementada
TASK-008 completada
TASK-008 = COMPLETADA

siguiente tarea
siguiente TASK
TASK-009

Gate de entrada a Fase 2
PHASE 2 FORMAL START
```

La auditoría debe abarcar como mínimo:

```text
docs/product/
docs/architecture/adr/
docs/tasks/
```

Cada coincidencia material debe clasificarse exclusivamente como una de estas cuatro categorías:

- `ACTIVE STALE REFERENCE — CHANGE`
- `VALID CURRENT REFERENCE — KEEP`
- `HISTORICAL/GOVERNANCE — KEEP`
- `UNEXPECTED — BLOCKER`

No se permiten categorías adicionales ni ambiguas.

Para cada coincidencia material debe registrarse:

- archivo;
- sección o contexto;
- patrón/texto encontrado;
- clasificación;
- acción prevista.

---

## 13. Reglas de clasificación

### 13.1 `ACTIVE STALE REFERENCE — CHANGE`

Aplicar sólo cuando una referencia:

- pretende describir el estado global actual;
- quedó materialmente obsoleta por estados posteriores ya aprobados;
- está dentro del scope autorizado;
- puede corregirse sin modificar una decisión de producto, arquitectura o seguridad.

### 13.2 `VALID CURRENT REFERENCE — KEEP`

Aplicar cuando la referencia:

- sigue siendo verdadera;
- expresa una regla general vigente;
- conserva una prohibición todavía aplicable;
- mantiene una separación de governance todavía necesaria.

### 13.3 `HISTORICAL/GOVERNANCE — KEEP`

Aplicar cuando la referencia:

- describe correctamente el estado existente al momento de una aprobación o ejecución anterior;
- preserva trazabilidad;
- documenta una condición histórica;
- expresa una regla de governance que no debe reescribirse retrospectivamente.

### 13.4 `UNEXPECTED — BLOCKER`

Aplicar cuando:

- la referencia activa stale está fuera del scope autorizado;
- no puede distinguirse con evidencia suficiente si es activa o histórica;
- corregirla exigiría una nueva decisión;
- la evidencia contradice el estado humano/técnico recibido.

---

## 14. Matriz inicial de impacto sobre `docs/product/11-phase-1-scope-entry-gate.md`

La futura ejecución debe confirmar esta matriz contra el archivo real antes de modificar.

| Superficie material | Estado inicial CORR-010 |
|---|---|
| Referencias activas `Gate de entrada a Fase 2 evaluado = SÍ` | `VALID CURRENT REFERENCE — KEEP` |
| Referencias activas `Gate de entrada a Fase 2 satisfecho = SÍ` | `VALID CURRENT REFERENCE — KEEP` |
| Referencias activas `PHASE 2 FORMAL START = APPROVED` | `VALID CURRENT REFERENCE — KEEP` |
| Referencias activas `PHASE 2 FORMAL START HUMAN REVIEW = APPROVED` | `VALID CURRENT REFERENCE — KEEP` |
| Referencias activas `Fase 2 = INICIADA` | `VALID CURRENT REFERENCE — KEEP` |
| Referencia activa `Fase 1 completada: no` | `ACTIVE STALE REFERENCE — CHANGE` |
| Referencia activa `Fase 2 iniciada: no` | `ACTIVE STALE REFERENCE — CHANGE` |
| Referencias activas que todavía presenten `TASK-008` como no redactada/no existente/futura | `ACTIVE STALE REFERENCE — CHANGE` si describen estado global actual |
| Referencias históricas a `TASK-008 autorizada = NO` dentro del contexto propio de CORR-009 | `HISTORICAL/GOVERNANCE — KEEP` fuera de `11`; dentro de `11` deben clasificarse por contexto |
| Reglas que expresen que una fase iniciada no autoriza automáticamente una implementación concreta | `VALID CURRENT REFERENCE — KEEP` |
| Reglas que expresen que una TASK completada no autoriza automáticamente la siguiente TASK | `VALID CURRENT REFERENCE — KEEP` |
| `Paso 9` histórico de Fase 1 cuando documente el plan original del Gate | `HISTORICAL/GOVERNANCE — KEEP`, salvo evidencia activa incompatible |
| Referencias a ADR-0004 y sus blockers | `VALID CURRENT REFERENCE — KEEP` |
| Filas de schema/migrations/RLS/Storage todavía no autorizadas por una TASK concreta | `VALID CURRENT REFERENCE — KEEP` salvo contradicción demostrada |
| Cualquier referencia activa stale adicional fuera del scope autorizado | `UNEXPECTED — BLOCKER` |

No se autoriza modificar una referencia sólo por contener el texto `TASK-008`.

Debe modificarse únicamente si su significado material pretende representar el estado actual y es incompatible con el cierre humano recibido.

---

## 15. Estado activo final que debe expresar `11`

Después de una futura ejecución correcta de CORR-010, las superficies activas cubiertas por la corrección deben ser coherentes con:

```text
Fase 0 = COMPLETADA
Fase 1 = COMPLETADA

DO-T03 = RESUELTO/APROBADO
DO-075 = RESUELTA/APROBADA

ADR-0001 = ACCEPTED
ADR-0002 = ACCEPTED
ADR-0003 = ACCEPTED

ADR-0004 = BLOCKED BY OPEN DECISIONS
```

Blockers de ADR-0004:

```text
DO-T04
OFF-OPEN-001
OFF-OPEN-002
FORM-OPEN-004
```

Además:

```text
Gate de entrada a Fase 2 evaluado = SÍ
Gate de entrada a Fase 2 satisfecho = SÍ

PHASE 2 FORMAL START = APPROVED
PHASE 2 FORMAL START HUMAN REVIEW = APPROVED

Fase 2 = INICIADA
```

Y el estado activo posterior de TASK-008 debe poder derivarse inequívocamente como:

```text
TASK-008 canonicalizada = SÍ
TASK-008 implementada = SÍ
TASK-008 incorporada a Git = SÍ
TASK-008 revisión humana final = APROBADA
TASK-008 = COMPLETADA
```

Debe quedar simultáneamente preservado:

```text
TASK-008 = COMPLETADA
≠
siguiente TASK autorizada automáticamente
```

---

## 16. Tratamiento obligatorio de referencias activas sobre TASK-008

Cuando `11` contenga una referencia activa que todavía diga, en sustancia:

```text
TASK-008 autorizada = NO
TASK-008 redactada = NO
TASK-008 pendiente como siguiente unidad
```

la futura ejecución deberá determinar si la referencia pretende describir:

1. el estado global actual;
2. un snapshot histórico;
3. una regla general de governance.

Sólo el caso 1 puede cambiar.

Cuando sea `ACTIVE STALE REFERENCE — CHANGE`, la corrección debe expresar semánticamente el cierre ya recibido sin inventar una metadata retrospectiva dentro de la TASK canónica.

La nueva superficie activa debe permitir concluir:

```text
TASK-008 = COMPLETADA
```

y conservar:

```text
la siguiente TASK requiere un acto humano separado
```

CORR-010 no debe sustituir esa separación por una autorización genérica de trabajo futuro.

---

## 17. Resultado técnico que debe permanecer visible

Las referencias activas que describan el resultado técnico de TASK-008 deben ser compatibles con:

```text
Supabase application boundary = IMPLEMENTADA
Browser factory = IMPLEMENTADA
Server factory no privilegiada = IMPLEMENTADA
```

y simultáneamente:

```text
Auth funcional = NO
Auth SSR lifecycle completo = NO
Refresh funcional de access token = NO
Proxy/middleware Auth funcional = NO
Authorization ready = NO

Schema = NO
Migrations = NO
SQL = NO
RLS ejecutable = NO
Storage = NO
Realtime = NO
UI = NO
Offline = NO
```

No se permite inferir que la aplicación está:

- Auth-ready;
- authorization-ready;
- tenant-ready;
- RLS-ready;
- offline-ready.

No se permite presentar una capacidad transitiva del SDK de Supabase como funcionalidad implementada por el producto.

---

## 18. Seguridad y multitenancy — preservación obligatoria

CORR-010 no modifica ninguna regla de seguridad.

Debe preservar:

```text
tenant = MaintenanceCompany
authenticated != authorized
RLS = frontera primaria para datos tenant-owned
current authoritative authorization prevalece
```

Debe preservar conceptualmente:

```text
CompanyMembership
UserClientAccess
SupportAccessGrant
```

Debe preservar:

```text
TECHNICIAN:
ejecución inicial únicamente dentro de clientes autorizados
```

Debe preservar:

```text
COMPANY_ADMIN:
NO posee ejecución inicial
```

Debe preservar:

```text
SUPER_ADMIN:
sin acceso tenant operacional normal
```

Debe preservar:

```text
service-role = excepcional/restringido
provider-side session termination = defense in depth
fail-closed
```

La corrección no implementa ninguna de estas reglas y no puede modificar su semántica para resolver una inconsistencia documental de estado.

---

## 19. ADR y decisiones abiertas

Decisión:

```text
ADR nuevo requerido = NO
```

Justificación:

CORR-010 no toma una decisión arquitectónica nueva. Únicamente sincroniza estados activos con decisiones y hechos ya aprobados.

Debe permanecer:

```text
ADR-0001 = ACCEPTED
ADR-0002 = ACCEPTED
ADR-0003 = ACCEPTED

ADR-0004 = BLOCKED BY OPEN DECISIONS
```

con exactamente:

```text
DO-T04
OFF-OPEN-001
OFF-OPEN-002
FORM-OPEN-004
```

CORR-010 no puede:

- resolver ADR-0004;
- resolver DO-T04;
- resolver OFF-OPEN-001;
- resolver OFF-OPEN-002;
- resolver FORM-OPEN-004;
- modificar DO-075;
- reabrir DO-T03.

Si sincronizar el estado exige cualquiera de esas acciones:

`BLOCKER`

---

## 20. Frontera obligatoria respecto de TASK-009

CORR-010 no determina TASK-009.

Debe preservar:

```text
TASK-009 generada = NO
TASK-009 autorizada = NO
TASK-009 implementada = NO
```

La corrección tampoco puede determinar:

- objetivo de TASK-009;
- alcance;
- requisitos;
- dominio;
- schema;
- Auth;
- RLS;
- UI;
- pruebas;
- secuencia técnica;
- tamaño PR;
- dependencias;
- si el siguiente incremento será Auth u otra capacidad.

El único efecto posterior permitido es:

```text
eliminar el BLOCKER documental
→ devolver el estado al Revisor Central
```

Sólo después del cierre humano final de CORR-010 podrá existir un acto separado para determinar el siguiente incremento PR-sized de Fase 2.

---

## 21. Fuera de alcance

CORR-010 prohíbe expresamente:

- redactar TASK-009;
- determinar el alcance técnico de TASK-009;
- autorizar TASK-009;
- implementar Auth;
- diseñar onboarding;
- diseñar `VerificationChallenge`;
- diseñar vínculo físico Auth → `PlatformUser`;
- crear tablas;
- crear columnas;
- crear PK/FK;
- crear constraints;
- crear índices;
- crear migrations;
- escribir SQL;
- escribir policies RLS;
- crear helpers PostgreSQL;
- crear triggers;
- crear RPC;
- diseñar claims;
- diseñar custom claims;
- diseñar Auth hooks;
- decidir TTL;
- decidir session registry;
- decidir primitiva provider-side de session termination;
- diseñar Storage;
- modificar código;
- modificar `package.json`;
- modificar `package-lock.json`;
- modificar `.env.example`;
- modificar Supabase Cloud;
- resolver ADR-0004;
- resolver OPEN posteriores;
- modificar el contrato técnico de TASK-008;
- reescribir retrospectivamente CORR-007;
- reescribir retrospectivamente CORR-008;
- reescribir retrospectivamente CORR-009;
- modificar el registro maestro `10` sin volver a revisión;
- ampliar el diff fuera de `11` por inferencia.

---

## 22. Cambios esperados de una futura ejecución

La futura ejecución documental de CORR-010 debe producir únicamente cambios semánticos mínimos en:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

Los cambios autorizados se limitan a:

1. corregir referencias activas que todavía expresen `Fase 1` como no completada;
2. corregir referencias activas que todavía expresen `Fase 2` como no iniciada;
3. corregir referencias activas que todavía presenten TASK-008 como no redactada, no existente o siguiente unidad futura cuando pretendan describir el estado global actual;
4. incorporar, donde sea estrictamente necesario para eliminar la contradicción activa, el cierre humano posterior de TASK-008;
5. preservar explícitamente que el cierre de TASK-008 no autoriza automáticamente una siguiente TASK;
6. preservar el resultado técnico real de TASK-008 sin ampliarlo.

No se autoriza una reescritura general de `11`.

No se autoriza modernizar redacción histórica que siga siendo correcta.

---

## 23. BLOCKERS

Resultado obligatorio:

`BLOCKER`

si ocurre cualquiera de las siguientes condiciones:

1. ya existe una `CORR-010` incompatible;
2. falta evidencia necesaria para distinguir una referencia activa de una histórica;
3. para sincronizar el cierre de TASK-008 hace falta modificar una decisión de producto;
4. hace falta modificar ADR-0001;
5. hace falta modificar ADR-0002;
6. hace falta modificar ADR-0003;
7. hace falta resolver ADR-0004;
8. hace falta resolver un OPEN;
9. hace falta reescribir retrospectivamente CORR-007;
10. hace falta reescribir retrospectivamente CORR-008;
11. hace falta reescribir retrospectivamente CORR-009;
12. hace falta modificar TASK-008 para alterar su contrato técnico;
13. una referencia activa stale aparece fuera del scope autorizado;
14. sincronizar el estado exige determinar TASK-009;
15. aparece drift técnico incompatible con el cierre humano recibido;
16. aparece evidencia de Auth funcional adelantada;
17. aparece evidencia de schema funcional adelantado;
18. aparece evidencia de migrations funcionales adelantadas;
19. aparece SQL de dominio adelantado;
20. aparece RLS ejecutable adelantada;
21. aparece Storage funcional adelantado;
22. aparece `service-role` funcional dentro del contrato normal de aplicación;
23. el estado Git real no es compatible con la autorización concreta;
24. el diff previo no está limpio cuando debería estarlo;
25. la futura ejecución requeriría modificar más de un archivo;
26. `docs/product/10-architecture-decisions-records.md` demuestra requerir una modificación activa para esta sincronización;
27. la clasificación de una coincidencia material no puede resolverse inequívocamente con una de las cuatro categorías autorizadas.

Ante `BLOCKER`:

- no modificar;
- no reparar por inferencia;
- no ampliar scope;
- conservar evidencia;
- devolver CORR-010 a revisión humana.

---

## 24. Preflight obligatorio de una futura ejecución

Antes de cualquier modificación deberá verificarse read-only:

### 24.1 Documental

- CORR-010 aprobada;
- CORR-010 canonicalizada;
- canonicalización revisada;
- no existe colisión de ID;
- TASK-008 canónica existe;
- CORR-009 canónica existe;
- TASK-009 sigue sin existir.

Si `TASK-009` existe antes de la ejecución de CORR-010:

`BLOCKER`

La ejecución:

- no debe reinterpretar, absorber ni reconciliar una TASK-009 aparecida posteriormente;
- debe devolver CORR-010 al Revisor Central;
- no debe ampliar scope;
- no debe continuar la modificación de `11`.

### 24.2 Git

- branch;
- HEAD;
- upstream;
- origin/main;
- divergencia;
- worktree;
- staged;
- untracked.

### 24.3 Scope

Confirmar:

```text
CHANGE REQUIRED =
docs/product/11-phase-1-scope-entry-gate.md
```

y:

```text
archivos modificables previstos = 1
```

### 24.4 Estado técnico

Confirmar que no apareció drift que convierta en falsa la frontera:

```text
Auth funcional = NO
Authorization ready = NO
Schema = NO
Migrations = NO
SQL = NO
RLS ejecutable = NO
Storage = NO
Offline = NO
```

Cualquier contradicción material:

`BLOCKER`

---

## 25. Verificaciones de la futura ejecución

La futura ejecución debe realizar y reportar como mínimo:

### 25.1 Auditoría integral previa

- búsqueda integral de los términos obligatorios;
- clasificación de cada coincidencia material;
- confirmación de que no existe un `UNEXPECTED`.

### 25.2 Revisión de scope

Confirmar que el diff contiene exclusivamente:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

### 25.3 Revisión semántica

Confirmar que el estado activo resultante no contiene contradicciones cubiertas por CORR-010 respecto de:

- Fase 1;
- Gate de entrada a Fase 2;
- inicio de Fase 2;
- cierre de TASK-008;
- ausencia de autorización automática de siguiente TASK.

### 25.4 Revisión histórica

Confirmar que no fueron modificados:

```text
docs/product/10-architecture-decisions-records.md
docs/tasks/TASK-008-supabase-application-boundary.md
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
docs/tasks/CORR-007-adr-0003-accepted-state-sync.md
docs/tasks/CORR-008-phase-2-entry-gate-state-sync.md
docs/tasks/CORR-009-phase-2-formal-start-state-sync.md
docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

### 25.5 Validación textual

Resultado obligatorio:

```text
git diff --check = 0
```

### 25.6 Validación negativa

Confirmar:

```text
TASK-009 generada = NO
TASK-009 autorizada = NO

Auth funcional = NO
Authorization ready = NO
Schema = NO
Migrations = NO
SQL = NO
RLS ejecutable = NO
Storage = NO
Offline = NO
```

---

## 26. Criterios de aceptación

La futura ejecución sólo podrá clasificarse como correcta si se verifican individualmente todos los criterios siguientes.

### Scope y gobernanza

- **AC-001** — el identificador utilizado es `CORR-010`.
- **AC-002** — no existe colisión documental incompatible de `CORR-010`.
- **AC-003** — CORR-010 permanece de naturaleza exclusivamente documental.
- **AC-004** — el único `CHANGE REQUIRED` inicial es `docs/product/11-phase-1-scope-entry-gate.md`.
- **AC-005** — el diff final contiene exactamente un archivo modificado.
- **AC-006** — `docs/product/10-architecture-decisions-records.md` no cambia.
- **AC-007** — `docs/tasks/TASK-008-supabase-application-boundary.md` no cambia.
- **AC-008** — ADR-0001 no cambia.
- **AC-009** — ADR-0002 no cambia.
- **AC-010** — ADR-0003 no cambia.
- **AC-011** — TASK-007 no cambia.
- **AC-012** — CORR-007 no cambia.
- **AC-013** — CORR-008 no cambia.
- **AC-014** — CORR-009 no cambia.
- **AC-015** — no se amplió scope por inferencia.
- **AC-016** — no se reescribió historia.

### Estado global activo

- **AC-017** — `Fase 0 = COMPLETADA` permanece coherente.
- **AC-018** — las superficies activas cubiertas por la corrección expresan `Fase 1 = COMPLETADA`.
- **AC-019** — las superficies activas cubiertas por la corrección expresan `Gate de entrada a Fase 2 evaluado = SÍ`.
- **AC-020** — las superficies activas cubiertas por la corrección expresan `Gate de entrada a Fase 2 satisfecho = SÍ`.
- **AC-021** — se preserva `PHASE 2 FORMAL START = APPROVED`.
- **AC-022** — se preserva `PHASE 2 FORMAL START HUMAN REVIEW = APPROVED`.
- **AC-023** — las superficies activas cubiertas por la corrección expresan `Fase 2 = INICIADA`.
- **AC-024** — desaparecen las contradicciones activas cubiertas `Fase 1 completada: no` y `Fase 2 iniciada: no`.

### TASK-008

- **AC-025** — el estado activo posterior permite concluir `TASK-008 canonicalizada = SÍ`.
- **AC-026** — el estado activo posterior permite concluir `TASK-008 implementada = SÍ`.
- **AC-027** — el estado activo posterior permite concluir `TASK-008 incorporada a Git = SÍ`.
- **AC-028** — el estado activo posterior refleja `TASK-008 revisión humana final = APROBADA`.
- **AC-029** — el estado activo posterior expresa `TASK-008 = COMPLETADA`.
- **AC-030** — la metadata histórica canónica de TASK-008 `APPROVED FOR IMPLEMENTATION` no se reescribe a `DONE`.
- **AC-031** — el commit técnico `dc132796d18bc1046cb15454f1c2f6e78fd6c505` se preserva como evidencia histórica del cierre técnico recibido.
- **AC-032** — el Gate histórico de TASK-008 que prohíbe autorizar automáticamente la siguiente tarea permanece intacto.

### Resultado técnico

- **AC-033** — `Supabase application boundary = IMPLEMENTADA`.
- **AC-034** — `Browser factory = IMPLEMENTADA`.
- **AC-035** — `Server factory no privilegiada = IMPLEMENTADA`.
- **AC-036** — `Auth funcional = NO`.
- **AC-037** — `Auth SSR lifecycle completo = NO`.
- **AC-038** — `Refresh funcional de access token = NO`.
- **AC-039** — `Proxy/middleware Auth funcional = NO`.
- **AC-040** — `Authorization ready = NO`.
- **AC-041** — `Schema = NO`.
- **AC-042** — `Migrations = NO`.
- **AC-043** — `SQL = NO`.
- **AC-044** — `RLS ejecutable = NO`.
- **AC-045** — `Storage = NO`.
- **AC-046** — `Realtime = NO`.
- **AC-047** — `UI = NO`.
- **AC-048** — `Offline = NO`.
- **AC-049** — no existe `service-role` funcional dentro del contrato normal de aplicación.

### Arquitectura, seguridad y OPEN

- **AC-050** — `ADR-0001 = ACCEPTED` permanece intacto.
- **AC-051** — `ADR-0002 = ACCEPTED` permanece intacto.
- **AC-052** — `ADR-0003 = ACCEPTED` permanece intacto.
- **AC-053** — `ADR-0004 = BLOCKED BY OPEN DECISIONS` permanece intacto.
- **AC-054** — los blockers de ADR-0004 continúan exactamente `DO-T04`, `OFF-OPEN-001`, `OFF-OPEN-002`, `FORM-OPEN-004`.
- **AC-055** — DO-075 permanece intacta.
- **AC-056** — DO-T03 no se reabre.
- **AC-057** — no se modifica ninguna regla de multitenancy.
- **AC-058** — no se modifica ninguna regla de autorización.
- **AC-059** — no se modifica ninguna regla RLS conceptual.

### Frontera posterior

- **AC-060** — ninguna TASK siguiente queda autorizada automáticamente.
- **AC-061** — `TASK-009 generada = NO`.
- **AC-062** — `TASK-009 autorizada = NO`.
- **AC-063** — `TASK-009 implementada = NO`.
- **AC-064** — CORR-010 no determina el alcance técnico de TASK-009.
- **AC-065** — las referencias históricas permanecen preservadas.
- **AC-066** — no quedan referencias activas contradictorias dentro del alcance cubierto por CORR-010.
- **AC-067** — `git diff --check = 0`.

---

## 27. Definition of Done

CORR-010 sólo podrá considerarse `COMPLETADA` después de completar todo el ciclo siguiente:

1. especificación redactada;
2. revisión humana;
3. aprobación documental;
4. canonicalización;
5. revisión humana de canonicalización;
6. autorización humana separada de ejecución;
7. ejecución documental;
8. revisión completa del diff;
9. revisión de arquitectura;
10. revisión de seguridad/multitenancy;
11. confirmación de que no se reescribió historia;
12. incorporación Git autorizada;
13. commit/push;
14. branch sincronizada;
15. worktree limpio;
16. revisión humana final;
17. cierre explícito de CORR-010.

Un PASS técnico de la ejecución documental no equivale automáticamente a:

```text
CORR-010 = COMPLETADA
```

El cierre exige el ciclo humano y Git completo.

---

## 28. Estado inmediato esperado después de una futura ejecución documental

Antes de la revisión humana del diff, debe quedar:

```text
CORR-010 cambios documentales aplicados = SÍ
Revisión humana posterior de CORR-010 = PENDIENTE

Fase 1 = COMPLETADA

Gate de entrada a Fase 2 evaluado = SÍ
Gate de entrada a Fase 2 satisfecho = SÍ

PHASE 2 FORMAL START = APPROVED
PHASE 2 FORMAL START HUMAN REVIEW = APPROVED

Fase 2 = INICIADA

TASK-008 = COMPLETADA

Supabase application boundary = IMPLEMENTADA

Auth funcional = NO
Authorization ready = NO
Schema = NO
Migrations = NO
SQL = NO
RLS ejecutable = NO
Storage = NO
Offline = NO

TASK-009 generada = NO
TASK-009 autorizada = NO
```

La ejecución documental no autoriza Git por sí sola.

Sólo una revisión humana satisfactoria del diff puede habilitar la incorporación Git.

---

## 29. Gate posterior

Después del cierre humano final de CORR-010 debe quedar:

```text
CORR-010 = COMPLETADA

Fase 1 = COMPLETADA

Gate de entrada a Fase 2 evaluado = SÍ
Gate de entrada a Fase 2 satisfecho = SÍ

PHASE 2 FORMAL START = APPROVED
PHASE 2 FORMAL START HUMAN REVIEW = APPROVED

Fase 2 = INICIADA

TASK-008 = COMPLETADA

Supabase application boundary = IMPLEMENTADA

Auth funcional = NO
Authorization ready = NO
Schema = NO
Migrations = NO
SQL = NO
RLS ejecutable = NO
Storage = NO
Offline = NO

TASK-009 generada = NO
TASK-009 autorizada = NO
```

Debe quedar además:

```text
TASK-008 completada
≠
TASK siguiente autorizada automáticamente
```

Sólo entonces el resultado vuelve al:

`REVISOR CENTRAL`

El Revisor Central podrá realizar, en otro acto separado, la determinación del siguiente incremento PR-sized de Fase 2.

CORR-010 no participa en esa determinación.

---

## 30. Instrucciones para una futura ejecución

Una futura ejecución de CORR-010 deberá:

1. leer íntegramente la especificación canónica aprobada;
2. repetir preflight documental y Git;
3. realizar la auditoría integral obligatoria;
4. clasificar cada coincidencia material con una de las cuatro categorías permitidas;
5. detenerse ante cualquier `UNEXPECTED — BLOCKER`;
6. modificar exclusivamente `docs/product/11-phase-1-scope-entry-gate.md`;
7. realizar cambios mínimos y semánticamente limitados al estado activo;
8. preservar historia;
9. preservar TASK-008 canónica;
10. preservar documento 10;
11. preservar ADR-0001/0002/0003;
12. preservar CORR-007/008/009;
13. preservar ADR-0004 y sus blockers;
14. preservar DO-075;
15. no generar TASK-009;
16. no modificar código, configuración ni Supabase;
17. validar el diff completo;
18. verificar `git diff --check = 0`;
19. reportar resultado y evidencia;
20. no realizar commit ni push salvo autorización humana posterior específica.

---

## 31. Metadata final

**ID:** `CORR-010`

**Título:** `Sincronización documental posterior al cierre de TASK-008`

**Tipo:** `CORRECCIÓN DOCUMENTAL DE CONSISTENCIA`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega:**

`CORR-010-task-008-closure-state-sync-approved.md`

**Ruta canónica futura propuesta:**

`docs/tasks/CORR-010-task-008-closure-state-sync.md`

**Documento `CHANGE REQUIRED`:**

```text
docs/product/11-phase-1-scope-entry-gate.md
```

**Documentos `NO CHANGE REQUIRED`:**

```text
docs/product/10-architecture-decisions-records.md
docs/tasks/TASK-008-supabase-application-boundary.md
docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

**Documentos `HISTORICAL/GOVERNANCE — KEEP`:**

```text
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
docs/tasks/CORR-007-adr-0003-accepted-state-sync.md
docs/tasks/CORR-008-phase-2-entry-gate-state-sync.md
docs/tasks/CORR-009-phase-2-formal-start-state-sync.md
```

**Cambio arquitectónico:** `NO`

**Cambio funcional:** `NO`

**Cambio de seguridad/RLS:** `NO`

**Cambio de multitenancy:** `NO`

**ADR nuevo requerido:** `NO`

**ADR-0004 resuelto:** `NO`

**DO-T04 resuelto:** `NO`

**OFF-OPEN-001 resuelto:** `NO`

**OFF-OPEN-002 resuelto:** `NO`

**FORM-OPEN-004 resuelto:** `NO`

**DO-075 modificado:** `NO`

**DO-T03 reabierto:** `NO`

**Auth implementada por CORR-010:** `NO`

**Schema diseñado por CORR-010:** `NO`

**SQL escrito por CORR-010:** `NO`

**Migrations creadas por CORR-010:** `NO`

**RLS ejecutable escrita por CORR-010:** `NO`

**Storage implementado por CORR-010:** `NO`

**Código modificado por CORR-010:** `NO`

**Supabase Cloud modificado por CORR-010:** `NO`

**TASK-009 generada:** `NO`

**TASK-009 autorizada:** `NO`

**TASK-009 implementada:** `NO`

**Codex utilizado durante esta preparación:** `NO`

**Repositorio modificado durante esta preparación:** `NO`

**Ejecución realizada:** `NO`

Estado de esta especificación:

```text
CORR-010 = APPROVED FOR IMPLEMENTATION
```
