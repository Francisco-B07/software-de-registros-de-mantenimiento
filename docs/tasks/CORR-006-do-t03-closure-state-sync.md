# CORR-006 — Sincronización documental del cierre de DO-T03

## 1. Identificación

**ID:** `CORR-006`

**Título:** `CORR-006 — Sincronización documental del cierre de DO-T03`

**Tipo:** corrección documental controlada de estado y dependencias activas.

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega aprobado:**

`CORR-006-do-t03-closure-state-sync-approved.md`

**Ruta canónica futura:**

`docs/tasks/CORR-006-do-t03-closure-state-sync.md`

**Naturaleza:** exclusivamente documental.

**Ejecución realizada:** `NO`

**Repositorio modificado durante esta aprobación documental:** `NO`

**Codex ejecutado:** `NO`

La aprobación de CORR-006 significa únicamente que esta especificación documental ha sido aprobada como contrato para una futura ejecución.

No significa que una ejecución concreta esté autorizada.

---

# 2. Objetivo

Sincronizar exclusivamente las referencias documentales activas derivadas de las decisiones humanas ya aprobadas:

`DO-T03 = RESUELTO/APROBADO`

y:

`ADR-0003 = READY TO DRAFT`

CORR-006 no vuelve a decidir ni reformular la semántica técnica de DO-T03.

Tampoco crea la clasificación `READY TO DRAFT` de ADR-0003: la sincroniza como decisión humana ya aprobada después de comprobarse separadamente que DO-T03 era su único blocker formal y que no existe otro blocker conceptual conocido para redactarlo.

Su propósito es eliminar metadata activa que todavía indique que:

- `DO-T03 = PARCIALMENTE ABIERTO`;
- el cierre formal de DO-T03 continúa pendiente;
- `DO-T03` continúa siendo blocker activo de `ADR-0003`;
- `ADR-0003 = BLOCKED BY OPEN DECISIONS`;
- `DO-T03` continúa siendo blocker activo de `ADR-0004`.

La corrección debe preservar las referencias históricas y de governance que describen correctamente estados anteriores o reglas permanentes.

---

# 3. Contexto

CORR-005 reformuló y sincronizó la semántica de seguridad de `RF-019 / DO-T03`, pero deliberadamente conservó:

`DO-T03 = PARCIALMENTE ABIERTO`

hasta una revisión humana posterior.

Posteriormente se completaron, separadamente:

1. ejecución de CORR-005;
2. revisión humana posterior;
3. `DO-T03 CLOSURE REVIEW = APPROVED`;
4. decisión humana:
   `DO-T03 = RESUELTO/APROBADO`;
5. `ADR-0003 STATUS REVIEW = READY TO DRAFT APPROVABLE`;
6. decisión humana:
   `ADR-0003 = READY TO DRAFT`.

El registro maestro vigente todavía refleja el estado anterior: ADR-0003 tiene `DO-T03` como única open dependency y aparece `BLOCKED BY OPEN DECISIONS`; ADR-0004 también incluye DO-T03 entre varios blockers.

Además, la revisión integral de `docs/product/11-phase-1-scope-entry-gate.md` confirma metadata activa adicional que no estaba cubierta por la versión anterior de CORR-006: §6.1 todavía afirma que ADR-0003 permanece bloqueado por DO-T03, y §7.9 conserva tanto `DO-T03 = PARCIALMENTE ABIERTO` como un párrafo que lo presenta como “la decisión abierta más cercana”.

Por tanto, dichas referencias son metadata activa pendiente de sincronización, no una reapertura de decisiones ya cerradas.

---

# 4. Decisiones humanas que originan CORR-006

CORR-006 consume como autoridad decisiones ya tomadas. No las crea.

## 4.1 DO-T03

`DO-T03 = RESUELTO/APROBADO`

### Garantía primaria preservada

Una revocación, deshabilitación o reducción de alcance retira inmediatamente toda autorización online afectada mediante estado autoritativo vigente.

Una sesión Auth o access JWT residual no conserva autorización revocada.

### Defensa adicional preservada

La terminación provider-side de sesiones y credenciales renovables:

- permanece como defense in depth;
- sólo puede utilizar mecanismos públicos, soportados y contractualmente adecuados;
- no es frontera primaria de autorización;
- su ausencia, limitación o fallo no restaura autorización;
- su ausencia, limitación o fallo no habilita acceso;
- su ausencia, limitación o fallo no produce rollback.

### Prohibiciones preservadas

No se adopta por inferencia:

- `updateUserById(...password...)`;
- `ban_duration` como global sign-out contractual;
- mutación directa de `auth.sessions`;
- almacenamiento de JWT ajenos;
- APIs no documentadas;
- internals;
- workarounds no aprobados.

---

## 4.2 ADR-0003

`ADR-0003 = READY TO DRAFT`

Significado estricto:

- DO-T03 ya no es blocker de ADR-0003;
- no existe otro blocker conceptual conocido que impida redactarlo;
- `READY TO DRAFT` autoriza únicamente preparar ADR-0003 como documento separado;
- `READY TO DRAFT` no equivale a `PROPOSED`;
- `READY TO DRAFT` no equivale a `ACCEPTED`;
- no autoriza implementación;
- no autoriza Auth/RLS físico;
- no satisface el Gate de entrada a Fase 2;
- Fase 2 permanece no iniciada.

---

# 5. Fuente de verdad

Para una futura ejecución, el orden de autoridad será:

1. decisión humana explícita:
   `DO-T03 = RESUELTO/APROBADO`;
2. decisión humana explícita:
   `ADR-0003 = READY TO DRAFT`;
3. esta especificación CORR-006 aprobada, una vez canonicalizada;
4. `docs/tasks/CORR-005-do-t03-rf019-document-sync.md`, exclusivamente para preservar la semántica técnica ya sincronizada y su trazabilidad histórica;
5. estado canónico vigente de:
   - `docs/product/01-product-definition.md`;
   - `docs/product/02-domain-model.md`;
   - `docs/product/03-permissions-rls-strategy.md`;
   - `docs/product/04-offline-sync-strategy.md`;
   - `docs/product/10-architecture-decisions-records.md`;
   - `docs/product/11-phase-1-scope-entry-gate.md`;
6. ADR aceptados relacionados, exclusivamente para comprobar coherencia y preservar historia.

Una decisión explícita aprobada posteriormente prevalece sobre metadata anterior todavía no sincronizada.

---

# 6. Alcance

La futura ejecución de CORR-006 podrá modificar exclusivamente:

1. `docs/product/01-product-definition.md`
2. `docs/product/02-domain-model.md`
3. `docs/product/03-permissions-rls-strategy.md`
4. `docs/product/04-offline-sync-strategy.md`
5. `docs/product/10-architecture-decisions-records.md`
6. `docs/product/11-phase-1-scope-entry-gate.md`

Sólo se permiten:

- sincronizaciones de estado;
- eliminación de wording activo que presente el cierre de DO-T03 como pendiente;
- eliminación de DO-T03 como blocker abierto;
- sincronización de `ADR-0003 = READY TO DRAFT`;
- ajustes mínimos directamente derivados de esas decisiones.

---

# 7. Fuera de alcance

CORR-006 no puede:

- reformular `RF-019`;
- modificar nuevamente la semántica aprobada de revocación;
- diseñar Auth;
- diseñar schema;
- diseñar tablas/columnas;
- escribir SQL;
- diseñar policies RLS;
- definir funciones PostgreSQL;
- definir claims/custom claims;
- seleccionar TTL;
- definir validación física de `session_id`;
- seleccionar una primitiva Supabase concreta;
- diseñar endpoints;
- diseñar Server Actions;
- diseñar Route Handlers;
- diseñar UX final;
- diseñar backend físico;
- resolver `DO-T04`;
- resolver `OFF-OPEN-001`;
- resolver `OFF-OPEN-002`;
- modificar `DO-075`;
- crear ADR-0003;
- redactar ADR-0003;
- modificar un archivo ADR-0003;
- declarar ADR-0003 `PROPOSED`;
- declarar ADR-0003 `ACCEPTED`;
- implementar ADR-0003;
- desbloquear Fase 2;
- evaluar el Gate de entrada a Fase 2;
- iniciar Fase 2.

---

# 8. Matriz de impacto documental

| Documento | Sección | Situación vigente | Cambio | Tipo |
|---|---|---|---|---|
| `01-product-definition.md` | §26.2 `DO-T03` | `PARCIALMENTE ABIERTO` + cierre formal pendiente | registrar `RESUELTO/APROBADO` y cierre efectuado | `STATE SYNCHRONIZATION` |
| `02-domain-model.md` | §29.1 fila `DO-T03` | cierre formal pendiente | registrar decisión cerrada preservando íntegramente la condición provider-side vigente | `STATE SYNCHRONIZATION` |
| `02-domain-model.md` | §6.5 | semántica ya correcta | ninguno | `NO CHANGE` |
| `03-permissions-rls-strategy.md` | §19.5 final | DO-T03 permanece abierto hasta revisión | actualizar cierre | `STATE SYNCHRONIZATION` |
| `03-permissions-rls-strategy.md` | §22.2 | mecanismo exacto “permanece en DO-T03” | trasladar diseño físico a ADR-0003/implementación posterior | `WORDING SYNCHRONIZATION` |
| `03-permissions-rls-strategy.md` | §32.1 | estado abierto + checklist de cierre pendiente | registrar cierre y preservar decisiones físicas posteriores | `STATE SYNCHRONIZATION` |
| `04-offline-sync-strategy.md` | §53.2 | `PARCIALMENTE ABIERTO` + cierre pendiente | registrar cierre | `STATE SYNCHRONIZATION` |
| `04-offline-sync-strategy.md` | §54.4 | cierre formal pendiente | registrar cierre | `STATE SYNCHRONIZATION` |
| `10-architecture-decisions-records.md` | §5.1 `DO-T03` | `PARCIALMENTE ABIERTO` | `RESUELTA/APROBADA` | `STATE SYNCHRONIZATION` |
| `10-architecture-decisions-records.md` | §7 ADR-0003 | única open dependency `DO-T03`; `BLOCKED BY OPEN DECISIONS` | `Open dependencies = Ninguna`; `READY TO DRAFT` | `STATE / DEPENDENCY SYNCHRONIZATION` |
| `10-architecture-decisions-records.md` | §7 ADR-0004 | DO-T03 entre varios blockers | retirar sólo DO-T03 | `DEPENDENCY SYNCHRONIZATION` |
| `10-architecture-decisions-records.md` | §9 ADR-0003 | DO-T03 abierto y ADR bloqueado | DO-T03 cerrado + ADR-0003 `READY TO DRAFT` | `STATE SYNCHRONIZATION` |
| `10-architecture-decisions-records.md` | §10 ADR-0004 | DO-T03 abierta parcialmente | retirar esa dependencia abierta | `DEPENDENCY SYNCHRONIZATION` |
| `10-architecture-decisions-records.md` | §29 | ADR-0003 bloqueado por DO-T03; ADR-0004 incluye DO-T03 | retirar ADR-0003 del listado y DO-T03 de ADR-0004 | `STATE / DEPENDENCY SYNCHRONIZATION` |
| `10-architecture-decisions-records.md` | §37.4 | 6/9/3 | 6 `ACCEPTED`, 1 `READY TO DRAFT`, 8 `BLOCKED`, 3 `DEFERRED` | `STATE SYNCHRONIZATION` |
| `10-architecture-decisions-records.md` | §37.6 | DO-T03 entre decisiones abiertas | retirarlo | `STATE SYNCHRONIZATION` |
| `11-phase-1-scope-entry-gate.md` | §6.1 | ADR-0003 permanece bloqueado por DO-T03 | DO-T03 resuelto + ADR-0003 `READY TO DRAFT`; ACCEPTED aún obligatorio | `STATE SYNCHRONIZATION` |
| `11-phase-1-scope-entry-gate.md` | §7.9 inventario DO-* | `DO-T03 = PARCIALMENTE ABIERTO` | `DO-T03 = RESUELTO/APROBADO`, preservando coordinación offline antes de Fase 5 | `STATE SYNCHRONIZATION` |
| `11-phase-1-scope-entry-gate.md` | §7.9 párrafo posterior | DO-T03 es “la decisión abierta más cercana” y bloquea Fase 2 | retirar condición de abierta; registrar `READY TO DRAFT` pero ACCEPTED pendiente | `STATE SYNCHRONIZATION` |
| `11-phase-1-scope-entry-gate.md` | §10.2 | DO-T03 abierto / ADR-0003 bloqueado | DO-T03 resuelto + ADR-0003 `READY TO DRAFT`; `ACCEPTED` pendiente | `STATE SYNCHRONIZATION` |
| `11-phase-1-scope-entry-gate.md` | §14.2 | DO-T03 como dependencia pendiente | DO-T03 cumplido + READY TO DRAFT actual; ACCEPTED pendiente | `STATE SYNCHRONIZATION` |
| `11-phase-1-scope-entry-gate.md` | §17 final | ADR-0003 bloqueado por DO-T03 | ADR-0003 `READY TO DRAFT`, todavía no ACCEPTED | `STATE SYNCHRONIZATION` |
| CORR-005 canónica | histórico | exigía DO-T03 abierto durante aquella ejecución | preservar | `NO CHANGE` |
| TASK-007 canónica | histórico | DO-T03 estaba abierto durante aquel Gate | preservar | `NO CHANGE` |
| ADR-0002 | histórico/arquitectónico | compatible | preservar | `NO CHANGE` |
| ADR-0005 | histórico/arquitectónico | compatible | preservar | `NO CHANGE` |

---

# 9. Cambios exactos — `docs/product/01-product-definition.md`

## 9.1 §26.2 — `DO-T03`

### Texto vigente

```markdown
**DO-T03 — Invalidación efectiva de sesiones. PARCIALMENTE ABIERTO.** Online: una revocación, deshabilitación o reducción de alcance debe retirar inmediatamente toda autorización afectada mediante estado autoritativo vigente; una sesión Auth o access JWT residual no conserva membership, rol, client scope, `SupportAccessGrant` ni ninguna otra autorización revocada. La terminación provider-side de sesiones y credenciales renovables constituye una defensa adicional y debe utilizar únicamente mecanismos públicos, soportados y contractualmente adecuados cuando exista una primitiva apropiada para el caso; su ausencia, limitación o fallo no restaura autorización y no autoriza internals, APIs no documentadas ni workarounds no aprobados. Offline: DO-075 mantiene la política aprobada de máximo 7 días y revalidación; una revocación conocida prevalece y el trabajo ya capturado no se elimina. El cierre formal de DO-T03 permanece pendiente de revisión humana posterior a esta sincronización documental.
```

### Texto final propuesto

```markdown
**DO-T03 — Invalidación efectiva de sesiones. RESUELTO/APROBADO.** Online: una revocación, deshabilitación o reducción de alcance debe retirar inmediatamente toda autorización afectada mediante estado autoritativo vigente; una sesión Auth o access JWT residual no conserva membership, rol, client scope, `SupportAccessGrant` ni ninguna otra autorización revocada. La terminación provider-side de sesiones y credenciales renovables constituye una defensa adicional y debe utilizar únicamente mecanismos públicos, soportados y contractualmente adecuados cuando exista una primitiva apropiada para el caso; su ausencia, limitación o fallo no restaura autorización y no autoriza internals, APIs no documentadas ni workarounds no aprobados. Offline: DO-075 mantiene la política aprobada de máximo 7 días y revalidación; una revocación conocida prevalece y el trabajo ya capturado no se elimina. El cierre formal de DO-T03 fue aprobado mediante decisión humana separada posterior a la ejecución y revisión de CORR-005; las decisiones físicas de implementación permanecen fuera de este cierre y corresponden a ADR-0003 y/o tareas posteriores según su alcance.
```

### Justificación

Sólo cambia:

- estado;
- metadata del cierre;
- frontera entre decisión conceptual cerrada y diseño físico posterior.

No modificar nuevamente `RF-019`.

---

# 10. Cambios exactos — `docs/product/02-domain-model.md`

## 10.1 §6.5

`NO CHANGE REQUIRED`

§6.5 ya contiene la semántica técnica sincronizada mediante CORR-005.

No modificar salvo contradicción material demostrada durante el preflight.

---

## 10.2 §29.1 — fila `DO-T03`

### Texto vigente

```markdown
| `DO-T03` | La reformulación de producto/seguridad ya fue aprobada: la revocación efectiva de autorización es inmediata y la terminación provider-side es una defensa adicional condicionada a mecanismos públicos soportados. Permanece pendiente el cierre formal de DO-T03 tras la sincronización documental y su revisión humana. | No | Antes de Fase 2 para seguridad online; coordinación offline antes de Fase 5 |
```

### Texto final propuesto

```markdown
| `DO-T03` | RESUELTO/APROBADO. La reformulación de producto/seguridad ya fue aprobada: la revocación efectiva de autorización es inmediata y la terminación provider-side es una defensa adicional condicionada a mecanismos públicos soportados. El cierre formal de DO-T03 fue aprobado mediante decisión humana separada tras la sincronización documental y su revisión humana. | No | Resuelta antes de Fase 2 para seguridad online; coordinación offline antes de Fase 5 |
```

### Justificación

Se modifica exclusivamente:

- incorporación de `RESUELTO/APROBADO`;
- “Permanece pendiente el cierre formal…” → cierre formal aprobado;
- `Antes de Fase 2` → `Resuelta antes de Fase 2`.

Se preserva materialmente y sin reformulación:

```text
la terminación provider-side es una defensa adicional condicionada a mecanismos públicos soportados
```

Se preserva exactamente:

`coordinación offline antes de Fase 5`

No se introduce ninguna nueva formulación técnica.

---

# 11. Cambios exactos — `docs/product/03-permissions-rls-strategy.md`

## 11.1 §19.5 — párrafo final

### Texto vigente

```markdown
La reformulación de producto/seguridad fue aprobada humanamente. `DO-T03` permanece `PARCIALMENTE ABIERTO` únicamente hasta completar esta sincronización documental y realizar la revisión humana posterior requerida para evaluar su cierre formal.
```

### Texto final propuesto

```markdown
La reformulación de producto/seguridad fue aprobada humanamente y, después de completar CORR-005 y su revisión humana posterior, `DO-T03` fue cerrado mediante decisión humana separada: `DO-T03 = RESUELTO/APROBADO`. Las decisiones físicas de implementación permanecen para `ADR-0003` y/o tareas posteriores según corresponda.
```

### Justificación

El resto de §19.5 permanece idéntico.

---

## 11.2 §22.2 — Sesiones

### Texto vigente

```markdown
## 22.2 Sesiones

El cierre forzado/revocación de sesiones probablemente requiere una operación server-side privilegiada.

Su mecanismo exacto permanece en `DO-T03`.
```

### Texto final propuesto

```markdown
## 22.2 Sesiones

El cierre forzado/revocación de sesiones probablemente requiere una operación server-side privilegiada.

`DO-T03 = RESUELTO/APROBADO` fija la semántica conceptual de seguridad y revocación. El mecanismo físico concreto de terminación provider-side, cuando corresponda, queda para `ADR-0003` y/o tareas posteriores de implementación, sin seleccionar aquí una primitiva concreta.
```

### Justificación

No selecciona mecanismo.

No reabre DO-T03.

No redacta ADR-0003.

---

## 11.3 §32.1 — `DO-T03`

### Texto vigente

```markdown
### `DO-T03` — Invalidación efectiva de sesiones

**Estado:** PARCIALMENTE ABIERTO.

**Reformulación de producto/seguridad aprobada:**

- una revocación, deshabilitación o reducción de alcance debe retirar inmediatamente toda autorización online afectada mediante estado autoritativo vigente;
- una sesión Auth o access JWT residual no conserva membership, rol, client scope, `SupportAccessGrant` ni ninguna otra autorización revocada;
- RLS/autorización vigente permanece como frontera primaria de datos;
- la seguridad no puede depender de esperar logout, refresh o `exp`;
- la terminación provider-side de sesiones y credenciales renovables permanece como defensa adicional y debe utilizar mecanismos públicos, soportados y contractualmente adecuados cuando exista una primitiva apropiada;
- ausencia, limitación o fallo de esa segunda defensa no restaura autorización;
- no se adoptan por inferencia `updateUserById(...password...)`, mutación directa de `auth.sessions`, almacenamiento de JWT ajenos, APIs no documentadas ni internals;
- `ban_duration` no se trata como equivalente contractual de global sign-out;
- DO-075 continúa definiendo el comportamiento offline.

**Pendiente para el cierre formal de DO-T03:**

- completar la sincronización documental controlada de CORR-005;
- verificar el diff y la coherencia de todas las fuentes afectadas;
- realizar una revisión humana separada del resultado;
- decidir explícitamente después de esa revisión si `DO-T03 = RESUELTO/APROBADO`.

El TTL exacto, la validación física de `session_id`, el diseño de RLS/SQL, la estructura física del backend y la selección futura de primitivas provider-side permanecen fuera de esta corrección y no se resuelven por inferencia.

**Bloquea el siguiente documento `04`:** no.

**Debe resolverse antes de:** Fase 2 para implementación de identidad/autorización online, coordinando sus implicaciones offline antes de Fase 5.
```

### Texto final propuesto

```markdown
### `DO-T03` — Invalidación efectiva de sesiones

**Estado:** RESUELTO/APROBADO.

**Reformulación de producto/seguridad aprobada:**

- una revocación, deshabilitación o reducción de alcance debe retirar inmediatamente toda autorización online afectada mediante estado autoritativo vigente;
- una sesión Auth o access JWT residual no conserva membership, rol, client scope, `SupportAccessGrant` ni ninguna otra autorización revocada;
- RLS/autorización vigente permanece como frontera primaria de datos;
- la seguridad no puede depender de esperar logout, refresh o `exp`;
- la terminación provider-side de sesiones y credenciales renovables permanece como defensa adicional y debe utilizar mecanismos públicos, soportados y contractualmente adecuados cuando exista una primitiva apropiada;
- ausencia, limitación o fallo de esa segunda defensa no restaura autorización;
- no se adoptan por inferencia `updateUserById(...password...)`, mutación directa de `auth.sessions`, almacenamiento de JWT ajenos, APIs no documentadas ni internals;
- `ban_duration` no se trata como equivalente contractual de global sign-out;
- DO-075 continúa definiendo el comportamiento offline.

**Cierre formal de DO-T03:**

- CORR-005 completó la sincronización de la reformulación aprobada;
- el diff y la coherencia de las fuentes afectadas fueron verificados;
- la revisión humana posterior de CORR-005 fue aprobada;
- una decisión humana separada declaró `DO-T03 = RESUELTO/APROBADO`.

El TTL exacto, la validación física de `session_id`, el diseño de RLS/SQL, la estructura física del backend y la selección futura de primitivas provider-side permanecen fuera del cierre conceptual de DO-T03 y quedan para `ADR-0003` y/o posteriores tareas de implementación según corresponda; no se resuelven por inferencia.

**Bloquea el siguiente documento `04`:** no.

**Deadline:** DO-T03 quedó resuelto antes de Fase 2 para identidad/autorización online; coordinación offline antes de Fase 5.
```

### Justificación

Se conserva íntegramente la semántica técnica.

Sólo se actualizan:

- estado;
- checklist de cierre;
- destino de decisiones físicas;
- cumplimiento del deadline.

No se amplía ni sustituye:

`coordinación offline antes de Fase 5`.

---

# 12. Cambios exactos — `docs/product/04-offline-sync-strategy.md`

## 12.1 §53.2 — `DO-T03`

### Texto vigente

```markdown
## 53.2 DO-T03 — Invalidación efectiva de sesiones

**Estado:** **PARCIALMENTE ABIERTO**.

Reformulación de producto/seguridad aprobada:

- una revocación, deshabilitación o reducción de alcance retira inmediatamente toda autorización online afectada según estado autoritativo vigente;
- una sesión Auth o access JWT residual no conserva autorización revocada;
- RLS/autorización vigente permanece como frontera primaria de datos;
- la terminación provider-side de sesiones y credenciales renovables es una defensa adicional mediante mecanismos públicos, soportados y contractualmente adecuados cuando exista una primitiva apropiada;
- ausencia, limitación o fallo de esa segunda defensa no restaura autorización;
- no se autorizan internals ni workarounds no aprobados;
- DO-075 gobierna offline sin cambios.

La reformulación está aprobada, pero `DO-T03` no se declara resuelto mediante esta corrección. Su cierre formal requiere la revisión humana separada posterior a la sincronización documental.

**Bloquea Fase 1:** no como documento, pero debe resolverse antes de implementar Fase 2; sus implicaciones offline deben estar coordinadas antes de Fase 5.
```

### Texto final propuesto

```markdown
## 53.2 DO-T03 — Invalidación efectiva de sesiones

**Estado:** **RESUELTO/APROBADO**.

Reformulación de producto/seguridad aprobada:

- una revocación, deshabilitación o reducción de alcance retira inmediatamente toda autorización online afectada según estado autoritativo vigente;
- una sesión Auth o access JWT residual no conserva autorización revocada;
- RLS/autorización vigente permanece como frontera primaria de datos;
- la terminación provider-side de sesiones y credenciales renovables es una defensa adicional mediante mecanismos públicos, soportados y contractualmente adecuados cuando exista una primitiva apropiada;
- ausencia, limitación o fallo de esa segunda defensa no restaura autorización;
- no se autorizan internals ni workarounds no aprobados;
- DO-075 gobierna offline sin cambios.

Después de la ejecución y revisión humana de CORR-005, el cierre formal de `DO-T03` fue aprobado mediante decisión humana separada.

**Bloquea Fase 1:** no. DO-T03 quedó resuelto antes de implementar Fase 2; sus implicaciones offline deben estar coordinadas antes de Fase 5.
```

---

## 12.2 §54.4 — estado de DO-T03

### Texto vigente

```markdown
**DO-T03: PARCIALMENTE ABIERTO.**

La reformulación aprobada distingue:

- revocación inmediata y autoritativa de la autorización online como garantía fuerte;
- terminación provider-side de sesiones/credenciales renovables como defensa adicional condicionada a mecanismos públicos soportados y contractualmente adecuados.

La reformulación queda sincronizada documentalmente mediante CORR-005, pero el cierre formal de `DO-T03` continúa pendiente de revisión humana separada posterior a esta corrección.

No se resuelve automáticamente por la ejecución de CORR-005.
```

### Texto final propuesto

```markdown
**DO-T03: RESUELTO/APROBADO.**

La reformulación aprobada distingue:

- revocación inmediata y autoritativa de la autorización online como garantía fuerte;
- terminación provider-side de sesiones/credenciales renovables como defensa adicional condicionada a mecanismos públicos soportados y contractualmente adecuados.

La reformulación fue sincronizada documentalmente mediante CORR-005 y, después de su revisión humana posterior, `DO-T03` fue cerrado mediante decisión humana separada.

Este cierre no modifica DO-075 ni resuelve DO-T04, OFF-OPEN-001 u OFF-OPEN-002.
```

---

## 12.3 DO-075 y restantes decisiones offline

`NO CHANGE REQUIRED`

Deben permanecer:

`DO-075 = RESUELTA/APROBADA`

`DO-T04 = pendiente`

`OFF-OPEN-001 = pendiente`

`OFF-OPEN-002 = pendiente`

---

# 13. Cambios exactos — `docs/product/10-architecture-decisions-records.md`

## 13.1 §5.1 — fila `DO-T03`

### Texto vigente

```markdown
| `DO-T03` | Invalidación efectiva de sesiones | Seguridad | `03`, `04` | `PARCIALMENTE ABIERTO` | Antes de Fase 2; coordinación offline antes de Fase 5 | Sí: `ADR-0003`, `ADR-0004` | `DO-075` ya resuelta |
```

### Texto final propuesto

```markdown
| `DO-T03` | Invalidación efectiva de sesiones | Seguridad | `03`, `04` | `RESUELTA/APROBADA` | Resuelta antes de Fase 2; coordinación offline antes de Fase 5 | Sí: `ADR-0003`, `ADR-0004` | `DO-075` ya resuelta |
```

### Justificación

Cambio mínimo de estado.

Preservar:

`coordinación offline antes de Fase 5`.

---

## 13.2 §7 — fila `ADR-0003`

### Texto vigente

```markdown
| `ADR-0003` | Autorización, client scope y soporte excepcional | Resolver actor, membership, `UserClientAccess`, grants, revocación y sesión | `ADR-CAND-01/02`, `ADR-CAND-SEC-02/03/06` | `DO-T03` | `BLOCKED BY OPEN DECISIONS` | Fase 2 |
```

### Texto final propuesto

```markdown
| `ADR-0003` | Autorización, client scope y soporte excepcional | Resolver actor, membership, `UserClientAccess`, grants, revocación y sesión | `ADR-CAND-01/02`, `ADR-CAND-SEC-02/03/06` | Ninguna | `READY TO DRAFT` | Fase 2 |
```

### Justificación

Sincroniza exclusivamente una decisión humana ya aprobada.

No utiliza una categoría ad hoc.

---

## 13.3 §7 — fila `ADR-0004`

### Texto vigente

```markdown
| `ADR-0004` | Offline local-first y aislamiento de réplica | Delimitar PWA, Service Worker, IndexedDB, réplica por identidad, logout y autorización offline | candidatos Offline + `ADR-CAND-06/09` | `DO-T03`, `DO-T04`, `OFF-OPEN-001`, `OFF-OPEN-002`, `FORM-OPEN-004` | `BLOCKED BY OPEN DECISIONS` | Fase 5 |
```

### Texto final propuesto

```markdown
| `ADR-0004` | Offline local-first y aislamiento de réplica | Delimitar PWA, Service Worker, IndexedDB, réplica por identidad, logout y autorización offline | candidatos Offline + `ADR-CAND-06/09` | `DO-T04`, `OFF-OPEN-001`, `OFF-OPEN-002`, `FORM-OPEN-004` | `BLOCKED BY OPEN DECISIONS` | Fase 5 |
```

---

## 13.4 §9 — ADR-0003

### Texto vigente de estado/bloqueo

```markdown
## Bloqueo

`DO-T03` permanece `PARCIALMENTE ABIERTO`.

Por tanto:

**Estado del futuro ADR: `BLOCKED BY OPEN DECISIONS`.**

Debe aprobarse antes de implementar identidad/autorización de Fase 2.
```

### Texto final propuesto

```markdown
## Estado

`DO-T03 = RESUELTO/APROBADO`.

DO-T03 ya no constituye un blocker de `ADR-0003`.

**Estado del futuro ADR: `READY TO DRAFT`.**

`READY TO DRAFT` autoriza únicamente preparar `ADR-0003` como documento separado. No equivale a `PROPOSED`, no equivale a `ACCEPTED` y no autoriza implementación.

`ADR-0003` todavía debe redactarse, revisarse y quedar `ACCEPTED` antes de implementar identidad/autorización de Fase 2.
```

### Regla crítica

No modificar los bullets técnicos del alcance de ADR-0003 sincronizados por CORR-005.

Debe conservarse exactamente:

```markdown
- tratamiento provider-side de sesiones y credenciales renovables conforme a la semántica aprobada de DO-T03, exclusivamente mediante mecanismos públicos, soportados y contractualmente adecuados cuando corresponda;
```

---

## 13.5 §10 — dependencias de ADR-0004

### Texto vigente

```markdown
## Dependencias

- `DO-075`: resuelta y consumida como restricción;
- `DO-T03`: abierta parcialmente;
- `DO-T04`: propuesta pendiente;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `FORM-OPEN-004`.
```

### Texto final propuesto

```markdown
## Dependencias

- `DO-075`: resuelta y consumida como restricción;
- `DO-T04`: propuesta pendiente;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `FORM-OPEN-004`.
```

Conservar:

`BLOCKED BY OPEN DECISIONS`.

---

## 13.6 §29 — bloque de ADR-0003

### Texto vigente

```markdown
## `ADR-0003`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueador:

- `DO-T03`.
```

### Texto final propuesto

Eliminar íntegramente este bloque de:

`# 29. ADRs bloqueados`

sin texto sustitutorio dentro de §29.

ADR-0003 queda clasificado formalmente como `READY TO DRAFT` en §7 y §9.

---

## 13.7 §29 — bloque de ADR-0004

### Texto vigente

```markdown
## `ADR-0004`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueadores:

- `DO-T03`;
- `DO-T04`;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `FORM-OPEN-004`.
```

### Texto final propuesto

```markdown
## `ADR-0004`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueadores:

- `DO-T04`;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `FORM-OPEN-004`.
```

---

## 13.8 §37.4 — distribución actual

### Texto vigente

```markdown
**ADRs definitivos propuestos: 18.**

Distribución actual:

- `ACCEPTED`: **6**;
- `BLOCKED BY OPEN DECISIONS`: **9**;
- `DEFERRED`: **3**.
```

### Texto final propuesto

```markdown
**ADRs definitivos propuestos: 18.**

Distribución actual:

- `ACCEPTED`: **6**;
- `READY TO DRAFT`: **1**;
- `BLOCKED BY OPEN DECISIONS`: **8**;
- `DEFERRED`: **3**.
```

### Verificación

`6 + 1 + 8 + 3 = 18`

---

## 13.9 §37.6 — decisiones que pueden permanecer abiertas

### Texto vigente relevante

```markdown
- `DO-T03`;
- `DO-T04`.
```

### Texto final propuesto

```markdown
- `DO-T04`.
```

Conservar sin cambio:

```markdown
`DO-075` permanece cerrada.
```

---

## 13.10 Referencias históricas de Fase 0

`NO CHANGE REQUIRED`

No actualizar retrospectivamente:

- §36.4, cuando describe ADR bloqueados durante el Gate de Fase 0;
- §36.6, cuando describe deadlines existentes en aquel Gate;
- cualquier snapshot inequívocamente histórico.

---

# 14. Cambios exactos — `docs/product/11-phase-1-scope-entry-gate.md`

La revisión integral del documento vigente confirma que no basta con sincronizar §10.2, §14.2 y §17. Existen referencias activas adicionales en §6.1 y §7.9.

## 14.1 §6.1 — Fase 2 — Multitenancy, autenticación, roles y RLS

### Texto vigente exacto

```markdown
`ADR-0003` permanece bloqueado por `DO-T03` y debe estar `ACCEPTED` antes de implementar identidad/autorización de Fase 2.
```

### Texto final propuesto exacto

```markdown
`DO-T03 = RESUELTO/APROBADO` y ya no constituye un blocker de `ADR-0003`. `ADR-0003 = READY TO DRAFT`; este estado autoriza únicamente preparar el ADR como documento separado y no autoriza implementación. `ADR-0003` debe estar `ACCEPTED` antes de implementar identidad/autorización de Fase 2.
```

### Justificación

Sólo se sustituye la afirmación activa ya falsa.

No modificar ningún otro contenido de §6.1.

---

## 14.2 §7.9 — inventario activo de decisiones `DO-*`

### Texto vigente exacto

```markdown
- `DO-T03 = PARCIALMENTE ABIERTO` — antes de Fase 2 para autorización/sesión y coordinación offline antes de Fase 5;
```

### Texto final propuesto exacto

```markdown
- `DO-T03 = RESUELTO/APROBADO` — resuelta antes de Fase 2 para autorización/sesión y coordinación offline antes de Fase 5;
```

### Justificación

Se modifica únicamente:

- estado;
- cumplimiento del deadline previo a Fase 2.

Se preserva literalmente:

`coordinación offline antes de Fase 5`

No se modifica ninguna otra entrada del inventario.

---

## 14.3 §7.9 — párrafo activo inmediatamente posterior al inventario

### Texto vigente exacto

```markdown
La decisión abierta más cercana a la frontera de Fase 1 es `DO-T03`, pero su deadline es **antes de Fase 2**, no antes de Fase 1. Por tanto, no impide ejecutar el setup de Fase 1, aunque sí impide entrar en la implementación de identidad/autorización de Fase 2 mientras no se resuelva y permita aprobar `ADR-0003`.
```

### Texto final propuesto exacto

```markdown
`DO-T03 = RESUELTO/APROBADO` y ya no constituye una decisión abierta ni un blocker de `ADR-0003`. `ADR-0003 = READY TO DRAFT`, pero este estado autoriza únicamente preparar el ADR como documento separado y no autoriza implementación. La implementación de identidad/autorización de Fase 2 continúa bloqueada hasta que `ADR-0003` sea redactado, revisado y quede `ACCEPTED`.
```

### Justificación

El párrafo vigente es metadata activa, no historia.

El cambio:

- elimina la afirmación ya falsa de que DO-T03 permanece abierto;
- registra `READY TO DRAFT`;
- mantiene inequívocamente el requisito `ACCEPTED` para Fase 2.

---

## 14.4 §10.2 — Requisito para entrar en Fase 2

### Texto vigente

```markdown
## 10.2 Requisito para entrar en Fase 2

El registro maestro exige antes de Fase 2:

- `ADR-0002 = ACCEPTED`;
- `ADR-0003 = ACCEPTED`.

`ADR-0002` ya está `ACCEPTED`.

`ADR-0003` todavía no puede aprobarse porque:

- `DO-T03` permanece `PARCIALMENTE ABIERTO`;
- el registro lo clasifica `BLOCKED BY OPEN DECISIONS`;
- debe aprobarse antes de implementar identidad/autorización de Fase 2.

Por tanto:

> **Completar Fase 1 no autoriza automáticamente comenzar Fase 2.**

La transición requiere resolver lo necesario de `DO-T03` sin inferencias, redactar/revisar/aprobar `ADR-0003` y verificar el Gate correspondiente antes de implementar Fase 2.

Este documento:

- no resuelve `DO-T03`;
- no redacta `ADR-0003`;
- no inicia Fase 2.
```

### Texto final propuesto

```markdown
## 10.2 Requisito para entrar en Fase 2

El registro maestro exige antes de Fase 2:

- `ADR-0002 = ACCEPTED`;
- `ADR-0003 = ACCEPTED`.

`ADR-0002` ya está `ACCEPTED`.

`DO-T03 = RESUELTO/APROBADO`.

`ADR-0003 = READY TO DRAFT`.

DO-T03 ya no constituye un blocker de ADR-0003. `READY TO DRAFT` autoriza únicamente preparar el ADR como documento separado; no equivale a `PROPOSED`, no equivale a `ACCEPTED` y no autoriza implementación.

Por tanto:

> **Completar Fase 1, resolver DO-T03 o alcanzar `ADR-0003 = READY TO DRAFT` no autoriza automáticamente comenzar Fase 2.**

La transición requiere todavía redactar, revisar y aprobar `ADR-0003`, obtener `ADR-0003 = ACCEPTED` y verificar separadamente el Gate correspondiente antes de implementar Fase 2.

Este documento:

- reconoce `DO-T03 = RESUELTO/APROBADO`;
- reconoce `ADR-0003 = READY TO DRAFT`;
- no redacta `ADR-0003`;
- no aprueba `ADR-0003`;
- no inicia Fase 2.
```

---

## 14.5 §14.2 — Condición adicional para cruzar hacia Fase 2

### Texto vigente

```markdown
Antes de comenzar la implementación de Fase 2 debe verificarse además:

- `ADR-0002 = ACCEPTED` — ya cumplido;
- `ADR-0003 = ACCEPTED` — pendiente;
- las dependencias necesarias de `ADR-0003`, especialmente `DO-T03`, resueltas/aprobadas en el alcance requerido.
```

### Texto final propuesto

```markdown
Antes de comenzar la implementación de Fase 2 debe verificarse además:

- `ADR-0002 = ACCEPTED` — ya cumplido;
- `DO-T03 = RESUELTO/APROBADO` — ya cumplido;
- `ADR-0003 = READY TO DRAFT` — estado actual aprobado, insuficiente por sí mismo para Fase 2;
- `ADR-0003 = ACCEPTED` — pendiente y obligatorio antes de implementar Fase 2.
```

Conservar inmediatamente después:

```markdown
Por tanto, la salida de Fase 1 y la entrada a Fase 2 son controles relacionados pero no idénticos.

**Fase 2 permanece bloqueada mientras `ADR-0003` no esté `ACCEPTED`.**
```

---

## 14.6 §15 — Paso 9

`HISTORICAL/GOVERNANCE — KEEP`

`NO CHANGE REQUIRED`

La secuencia:

- revisar DO-T03;
- realizar proceso documental para desbloquear ADR-0003;
- redactar/revisar/aprobar ADR-0003;
- evaluar Gate de Fase 2;

describe correctamente la secuencia aprobada en el momento de cierre de Fase 1.

---

## 14.7 Riesgos históricos `P1-RSK-003` / `P1-RSK-009`

`HISTORICAL/GOVERNANCE — KEEP`

`NO CHANGE REQUIRED`

La formulación:

```text
DO-T03 debe resolverse documentalmente antes de aprobar ADR-0003
```

registra una regla que fue cumplida.

La formulación:

```text
DO-T03 no se resuelve por inferencia
```

es una regla de governance, no una afirmación de que continúe abierto.

---

## 14.8 §17 — Resultado final

### Texto vigente exacto

```markdown
`ADR-0003` continúa bloqueado por `DO-T03` y debe quedar `ACCEPTED` antes de implementar Fase 2. Este documento no lo redacta ni resuelve su dependencia.
```

### Texto final propuesto exacto

```markdown
`DO-T03 = RESUELTO/APROBADO` y ya no constituye un blocker de `ADR-0003`. `ADR-0003 = READY TO DRAFT`, lo que autoriza únicamente su preparación como documento separado; todavía debe redactarse, revisarse y quedar `ACCEPTED` antes de implementar Fase 2. Este documento no redacta ni aprueba `ADR-0003`.
```

---

## 14.9 Clasificación integral de ocurrencias relevantes en `11`

La futura ejecución debe realizar una revisión integral, no limitada a las secciones anteriores.

Las ocurrencias conocidas se clasifican así:

| Ubicación / referencia | Clasificación | Tratamiento |
|---|---|---|
| §6.1 — “ADR-0003 permanece bloqueado por DO-T03…” | `ACTIVE — CHANGE REQUIRED` | aplicar §14.1 |
| §7.9 — `DO-T03 = PARCIALMENTE ABIERTO` | `ACTIVE — CHANGE REQUIRED` | aplicar §14.2 |
| §7.9 — “La decisión abierta más cercana…” | `ACTIVE — CHANGE REQUIRED` | aplicar §14.3 |
| §8.1 — tabla `Antes de Fase 2: ADR-0002 + ADR-0003` | `VALID CURRENT REFERENCE — KEEP` | sigue siendo correcto |
| §8.3 — ADR-0003 fuera del Gate directo de Fase 1 | `HISTORICAL/GOVERNANCE — KEEP` | no afirma que siga bloqueado |
| matriz de acciones — Auth funcional requiere ADR-0003 aún no aceptado | `VALID CURRENT REFERENCE — KEEP` | sigue siendo cierto |
| matriz de acciones — RLS debe respetar ADR-0003/DO-T03 | `VALID CURRENT REFERENCE — KEEP` | trazabilidad conceptual válida |
| §10.2 — DO-T03 abierto / ADR-0003 blocked | `ACTIVE — CHANGE REQUIRED` | aplicar §14.4 |
| Gate keeper — verificar `ADR-0003 = ACCEPTED` | `VALID CURRENT REFERENCE — KEEP` | requisito continúa vigente |
| Gate de entrada Fase 1 — DO-T03/T04 no bloqueaban Fase 1 | `HISTORICAL/GOVERNANCE — KEEP` | snapshot correcto |
| §14.2 — DO-T03 como dependencia todavía pendiente | `ACTIVE — CHANGE REQUIRED` | aplicar §14.5 |
| §15 Paso 9 | `HISTORICAL/GOVERNANCE — KEEP` | preservar |
| `P1-RSK-003` | `HISTORICAL/GOVERNANCE — KEEP` | preservar |
| `P1-RSK-009` | `HISTORICAL/GOVERNANCE — KEEP` | preservar |
| §17 — ADR-0003 continúa bloqueado por DO-T03 | `ACTIVE — CHANGE REQUIRED` | aplicar §14.8 |

Si la futura búsqueda integral descubre otra coincidencia:

`UNEXPECTED — BLOCKER`

hasta que se determine explícitamente si es activa, histórica o válida.

---

# 15. Documentos históricos revisados — `NO CHANGE REQUIRED`

## 15.1 `docs/tasks/CORR-005-do-t03-rf019-document-sync.md`

`NO CHANGE REQUIRED`

Preserva el contrato histórico que exigía mantener DO-T03 abierto durante aquella ejecución.

---

## 15.2 `docs/tasks/TASK-007-phase-1-smoke-docs-review.md`

`NO CHANGE REQUIRED`

**Ruta canónica exacta:**

`docs/tasks/TASK-007-phase-1-smoke-docs-review.md`

Durante TASK-007 debía mantenerse:

`ADR-0003 = BLOCKED BY DO-T03`

y:

`DO-T03 = PARCIALMENTE ABIERTO`.

Ese estado era correcto durante aquella tarea y no debe reescribirse retrospectivamente.

---

## 15.3 `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`

`NO CHANGE REQUIRED`

---

## 15.4 `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`

`NO CHANGE REQUIRED`

---

# 16. Referencias históricas que deben preservarse

No deben modificarse por búsquedas automáticas:

- estados de DO-T03 contenidos en CORR-005 como precondición, procedimiento o resultado histórico;
- estado de DO-T03 durante TASK-007;
- estado de ADR-0003 durante TASK-007;
- secuencia histórica de Paso 9;
- riesgos históricos que exigían resolver DO-T03 documentalmente;
- snapshots del Gate de Fase 0;
- textos de ADR aceptados que mencionen DO-T03 como decisión separada o trazabilidad sin afirmar falsamente que continúa abierta.

Regla:

`histórico correcto ≠ metadata activa stale`

---

# 17. Invariantes de seguridad

CORR-006 debe preservar íntegramente:

1. autenticación no equivale a autorización;
2. revocación/deshabilitación/reducción de alcance corta inmediatamente autorización online;
3. sesión Auth residual no conserva autorización revocada;
4. access JWT residual no conserva autorización revocada;
5. membership vigente prevalece;
6. rol vigente prevalece;
7. `UserClientAccess` vigente prevalece;
8. `SupportAccessGrant` vigente prevalece;
9. RLS/autorización vigente permanece como frontera primaria;
10. ningún endpoint puede considerar `user != null` autorización tenant suficiente;
11. seguridad no espera logout, refresh o `exp`;
12. provider-side termination permanece defense in depth;
13. sólo se permiten mecanismos públicos, soportados y contractualmente adecuados;
14. fallo/ausencia de esa defensa es fail-closed;
15. no existe rollback de revocación;
16. internals/workarounds no documentados siguen prohibidos.

---

# 18. Multitenancy y RLS

CORR-006 no modifica la arquitectura multiempresa.

Debe mantenerse:

- tenant = `MaintenanceCompany`;
- aislamiento tenant obligatorio;
- RLS como frontera primaria de datos tenant-owned;
- frontend no autoritativo;
- `service-role` restringido;
- autorización determinada mediante estado vigente.

No se diseñan:

- policies;
- predicates;
- SQL;
- funciones;
- claims;
- tablas;
- índices.

`ADR-0003 = READY TO DRAFT` no autoriza esos diseños físicos.

---

# 19. DO-075

Debe permanecer:

`DO-075 = RESUELTA/APROBADA`

CORR-006 no modifica:

- máximo de 7 días;
- revalidación;
- revocación conocida;
- preservación del trabajo capturado.

---

# 20. Decisiones que permanecen abiertas

CORR-006 no resuelve:

`DO-T04`

`OFF-OPEN-001`

`OFF-OPEN-002`

Tampoco resuelve ningún otro:

- `DM-OPEN-*`;
- `FORM-OPEN-*`;
- `EVID-OPEN-*`;
- `RPT-OPEN-*`;
- `AI-OPEN-*`;
- `PAY-OPEN-*`.

Las decisiones físicas excluidas del cierre de DO-T03 permanecen para ADR-0003 y/o implementación:

- TTL;
- `session_id`;
- schema;
- SQL;
- policies;
- claims;
- endpoints;
- estructura backend;
- UX;
- primitiva provider-side concreta.

No constituyen blockers para **redactar** ADR-0003.

---

# 21. Tratamiento de ADR-0003

CORR-006 debe sincronizar:

`ADR-0003 = READY TO DRAFT`

Debe:

1. retirar DO-T03 como open dependency;
2. retirar DO-T03 como blocker;
3. cambiar `BLOCKED BY OPEN DECISIONS` → `READY TO DRAFT`;
4. retirar ADR-0003 de `# 29. ADRs bloqueados`;
5. actualizar distribución del catálogo;
6. sincronizar las referencias activas del Gate.

`READY TO DRAFT`:

- permite preparar/redactar el ADR como documento separado;
- no equivale a `PROPOSED`;
- no equivale a `ACCEPTED`;
- no autoriza implementación;
- no satisface el Gate de Fase 2.

CORR-006 no redacta ADR-0003.

---

# 22. Tratamiento de ADR-0004

Retirar DO-T03 de sus blockers.

ADR-0004 debe continuar:

`BLOCKED BY OPEN DECISIONS`

por:

- `DO-T04`;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `FORM-OPEN-004`.

---

# 23. Prohibiciones

Durante una futura ejecución queda prohibido:

- modificar CORR-005;
- modificar TASK-007;
- modificar ADR-0002;
- modificar ADR-0005;
- crear ADR-0003;
- redactar ADR-0003;
- modificar un archivo ADR-0003;
- declarar ADR-0003 `PROPOSED`;
- declarar ADR-0003 `ACCEPTED`;
- crear ADR-0004;
- modificar RF-019;
- cambiar semántica de revocación;
- seleccionar mecanismos Supabase;
- escribir código;
- modificar package files;
- modificar workflows;
- modificar Supabase config;
- escribir migrations;
- escribir SQL;
- diseñar RLS físico;
- iniciar Fase 2;
- evaluar Gate de Fase 2.

La única transición formal de ADR-0003 sincronizada por CORR-006 es:

`BLOCKED BY OPEN DECISIONS → READY TO DRAFT`

---

# 24. Búsquedas read-only obligatorias

## 24.1 En los seis documentos modificables

Buscar como mínimo:

```text
DO-T03
PARCIALMENTE ABIERTO
cierre formal de DO-T03
cierre formal
pendiente
permanece en `DO-T03`
DO-T03 permanece
ADR-0003
BLOCKED BY OPEN DECISIONS
BLOCKED BY DO-T03
bloqueado por
READY TO DRAFT
```

Cada coincidencia debe clasificarse:

- `ACTIVE — CHANGE REQUIRED`;
- `HISTORICAL/GOVERNANCE — KEEP`;
- `VALID CURRENT REFERENCE — KEEP`;
- `UNEXPECTED — BLOCKER`.

---

## 24.2 Revisión integral obligatoria de `11`

La búsqueda sobre:

`docs/product/11-phase-1-scope-entry-gate.md`

no puede limitarse a §§6.1, 7.9, 10.2, 14.2 y 17.

Debe revisar todas las coincidencias de:

```text
DO-T03
PARCIALMENTE ABIERTO
ADR-0003
BLOCKED BY OPEN DECISIONS
bloqueado por
```

y compararlas contra la clasificación inicial de §14.9.

Una coincidencia adicional no clasificada previamente:

`UNEXPECTED — BLOCKER`

No modificar por inferencia.

---

## 24.3 ADR-0004

Buscar:

```text
ADR-0004
DO-T03
```

Las referencias activas como blocker/open dependency deben retirar DO-T03.

Las históricas pueden permanecer.

---

## 24.4 Seguridad

Comprobar que siguen presentes expresiones equivalentes a:

```text
estado autoritativo vigente
access JWT residual
RLS/autorización vigente
mecanismos públicos, soportados y contractualmente adecuados
fail-closed
```

---

# 25. Condiciones de BLOCKER

La futura ejecución debe detenerse con `BLOCKER` si:

1. falta una fuente canónica obligatoria;
2. el wording vigente difiere materialmente del verificado;
3. una decisión posterior contradice `DO-T03 = RESUELTO/APROBADO`;
4. una decisión posterior contradice `ADR-0003 = READY TO DRAFT`;
5. aparece una cuestión conceptual que implique reabrir DO-T03;
6. se requiere reformular RF-019;
7. se requiere crear/redactar/modificar ADR-0003;
8. se requiere cambiar ADR-0003 más allá de metadata `READY TO DRAFT`;
9. se requiere declarar ADR-0003 `PROPOSED` o `ACCEPTED`;
10. se requiere resolver DO-T04;
11. se requiere resolver OFF-OPEN-001/002;
12. no puede preservarse DO-075;
13. se requiere seleccionar primitiva Supabase;
14. se requiere seleccionar TTL o `session_id`;
15. se requiere diseñar SQL/RLS/schema/claims/endpoints;
16. existe contradicción material en ADR-0002 o ADR-0005;
17. se requiere reescribir retrospectivamente CORR-005 o TASK-007;
18. aparece un archivo fuera de los seis autorizados;
19. una búsqueda revela metadata activa stale no cubierta;
20. el wording reduce garantías de seguridad de CORR-005;
21. se elimina la condición “públicos, soportados y contractualmente adecuados” donde está aprobada;
22. se crea una categoría ADR no existente;
23. distribución ADR deja de totalizar 18;
24. se debilita en `02 §29.1` la condición provider-side vigente;
25. se amplía o sustituye el deadline `coordinación offline antes de Fase 5`;
26. la búsqueda integral de `11` detecta una referencia `UNEXPECTED`;
27. el cambio pudiera interpretarse como autorización de Fase 2.

Ante BLOCKER:

- no continuar;
- no resolver por inferencia;
- no ampliar CORR-006;
- conservar evidencia para revisión humana.

---

# 26. Criterios de aceptación

CORR-006 sólo podrá considerarse correctamente ejecutada si:

1. `01` registra `DO-T03 = RESUELTO/APROBADO`.
2. `01` ya no declara pendiente el cierre formal.
3. RF-019 no fue modificado.
4. `02` §29.1 registra DO-T03 como resuelto.
5. `02` §29.1 conserva materialmente `la terminación provider-side es una defensa adicional condicionada a mecanismos públicos soportados`.
6. `02` §29.1 conserva exactamente `coordinación offline antes de Fase 5`.
7. `02` §6.5 permanece sin cambios.
8. `03` §19.5 deja de indicar que DO-T03 continúa abierto.
9. `03` §22.2 deja de situar el mecanismo físico dentro de DO-T03.
10. §22.2 no selecciona mecanismo físico.
11. `03` §32.1 registra `RESUELTO/APROBADO`.
12. §32.1 preserva íntegramente la reformulación técnica.
13. §32.1 preserva `coordinación offline antes de Fase 5`.
14. `04` §53.2 registra `RESUELTO/APROBADO`.
15. §53.2 preserva coordinación offline antes de Fase 5.
16. `04` §54.4 registra `RESUELTO/APROBADO`.
17. DO-075 permanece `RESUELTA/APROBADA`.
18. máximo 7 días no cambia.
19. DO-T04 permanece abierto.
20. OFF-OPEN-001 permanece abierto.
21. OFF-OPEN-002 permanece abierto.
22. `10` §5.1 registra DO-T03 `RESUELTA/APROBADA`.
23. §5.1 preserva coordinación offline antes de Fase 5.
24. `10` §7 registra `Open dependencies = Ninguna` para ADR-0003.
25. `10` §7 registra `ADR-0003 = READY TO DRAFT`.
26. §7 retira DO-T03 de ADR-0004.
27. ADR-0004 continúa `BLOCKED BY OPEN DECISIONS`.
28. §9 registra DO-T03 resuelto.
29. §9 registra ADR-0003 `READY TO DRAFT`.
30. §9 conserva exactamente el wording provider-side crítico de CORR-005.
31. §9 deja claro que READY TO DRAFT no es PROPOSED ni ACCEPTED.
32. §10 de ADR-0004 retira DO-T03.
33. §29 deja de listar ADR-0003 como bloqueado.
34. §29 retira DO-T03 de ADR-0004.
35. §37.4 registra ACCEPTED = 6.
36. §37.4 registra READY TO DRAFT = 1.
37. §37.4 registra BLOCKED BY OPEN DECISIONS = 8.
38. §37.4 registra DEFERRED = 3.
39. §37.4 totaliza 18.
40. §37.6 ya no lista DO-T03 abierto.
41. referencias históricas de Fase 0 permanecen intactas.
42. `11` §6.1 ya no declara ADR-0003 bloqueado por DO-T03.
43. `11` §6.1 registra DO-T03 resuelto.
44. `11` §6.1 registra ADR-0003 READY TO DRAFT.
45. `11` §6.1 mantiene ACCEPTED obligatorio para Fase 2.
46. `11` §7.9 ya no registra DO-T03 PARCIALMENTE ABIERTO.
47. §7.9 registra DO-T03 RESUELTO/APROBADO.
48. §7.9 preserva `coordinación offline antes de Fase 5`.
49. §7.9 ya no denomina DO-T03 “decisión abierta”.
50. §7.9 registra ADR-0003 READY TO DRAFT.
51. §7.9 mantiene Fase 2 bloqueada hasta ADR-0003 ACCEPTED.
52. `11` §10.2 ya no presenta DO-T03 abierto.
53. §10.2 registra ADR-0003 READY TO DRAFT.
54. §10.2 mantiene ADR-0003 ACCEPTED obligatorio.
55. §14.2 registra DO-T03 cumplido.
56. §14.2 registra READY TO DRAFT actual pero insuficiente.
57. §14.2 mantiene ACCEPTED pendiente y obligatorio.
58. §15/Paso 9 histórico permanece intacto.
59. P1-RSK-003 permanece como referencia histórica/governance.
60. P1-RSK-009 permanece como referencia histórica/governance.
61. §17 deja de declarar ADR-0003 bloqueado por DO-T03.
62. §17 registra ADR-0003 READY TO DRAFT.
63. §17 mantiene ACCEPTED como requisito previo a Fase 2.
64. todas las demás ocurrencias de DO-T03/ADR-0003 en `11` fueron revisadas y clasificadas.
65. ninguna ocurrencia `ACTIVE — CHANGE REQUIRED` permanece stale.
66. ninguna coincidencia `UNEXPECTED` queda sin resolver mediante revisión humana.
67. CORR-005 canónica no fue modificada.
68. TASK-007 canónica no fue modificada.
69. ADR-0002 no fue modificado.
70. ADR-0005 no fue modificado.
71. ADR-0003 no fue creado ni redactado.
72. ningún archivo ADR-0003 fue modificado.
73. ADR-0003 no fue declarado PROPOSED.
74. ADR-0003 no fue declarado ACCEPTED.
75. no se seleccionó TTL.
76. no se seleccionó validación física de `session_id`.
77. no se diseñó schema/SQL/RLS físico.
78. no se seleccionó primitiva Supabase concreta.
79. no se introdujeron internals/workarounds.
80. `git diff --name-only` contiene exactamente seis documentos.
81. `git diff --check` produce cero errores.
82. los seis diffs fueron revisados íntegramente.
83. no existe referencia activa que presente DO-T03 como abierto.
84. no existe referencia activa que presente DO-T03 como blocker de ADR-0003.
85. no existe referencia activa que clasifique ADR-0003 como `BLOCKED BY OPEN DECISIONS`.
86. las referencias activas correspondientes clasifican ADR-0003 como `READY TO DRAFT`.
87. DO-T03 no permanece como blocker activo de ADR-0004.
88. se preserva la triple condición `públicos, soportados y contractualmente adecuados`.
89. los deadlines preservan `coordinación offline antes de Fase 5` sin ampliación semántica.
90. Gate de entrada a Fase 2 continúa no satisfecho.
91. Fase 2 continúa no iniciada.
92. no se introdujo ninguna decisión nueva por inferencia.

---

# 27. Pruebas y verificaciones documentales

## 27.1 Scope

```text
git diff --name-only
```

Debe mostrar exactamente:

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

---

## 27.2 Calidad de diff

```text
git diff --check
```

Resultado:

`0 errores`

---

## 27.3 Diffs completos

Revisar íntegramente los seis diffs.

---

## 27.4 Verificación de no cambio histórico

Comprobar ausencia de diff en:

```text
docs/tasks/CORR-005-do-t03-rf019-document-sync.md
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md
```

---

## 27.5 Verificación taxonomía ADR

```text
ADR-0003 = READY TO DRAFT
ADR-0003 PROPOSED = NO
ADR-0003 ACCEPTED = NO
```

Distribución:

```text
ACCEPTED = 6
READY TO DRAFT = 1
BLOCKED BY OPEN DECISIONS = 8
DEFERRED = 3
TOTAL = 18
```

---

## 27.6 Verificación específica de `02`

Comprobar literalmente que la fila resultante conserva:

```text
la terminación provider-side es una defensa adicional condicionada a mecanismos públicos soportados
```

y:

```text
coordinación offline antes de Fase 5
```

---

## 27.7 Verificación integral de `11`

Ejecutar búsquedas read-only por:

```text
DO-T03
PARCIALMENTE ABIERTO
ADR-0003
BLOCKED BY OPEN DECISIONS
bloqueado por
```

Registrar cada coincidencia con:

```text
ubicación
texto
clasificación
acción
```

Clasificaciones permitidas:

- `ACTIVE — CHANGE REQUIRED`;
- `HISTORICAL/GOVERNANCE — KEEP`;
- `VALID CURRENT REFERENCE — KEEP`;
- `UNEXPECTED — BLOCKER`.

No aceptar éxito si queda una referencia activa stale.

---

# 28. Procedimiento futuro de ejecución

La aprobación formal de esta especificación ya ocurrió.

La ejecución concreta de CORR-006 sólo podrá realizarse después de:

1. canonicalización de esta especificación aprobada;
2. autorización humana separada de ejecución.

## 28.1 Preflight

Verificar:

```text
git rev-parse --is-inside-work-tree
git branch --show-current
git rev-parse HEAD
git rev-parse --abbrev-ref --symbolic-full-name @{u}
git rev-list --left-right --count HEAD...origin/main
git status --porcelain=v1 --untracked-files=all
```

Requisitos:

- repositorio válido;
- branch `main`;
- upstream `origin/main`;
- divergencia `0 0`;
- worktree limpio.

Cualquier discrepancia:

`BLOCKER`

---

## 28.2 Lectura previa

Leer íntegramente:

- CORR-006 canónica;
- los seis documentos modificables;
- los cuatro documentos `NO CHANGE REQUIRED`.

En `11`, ejecutar la búsqueda integral **antes de modificar** y comparar los resultados con §14.9.

---

## 28.3 Aplicación

Aplicar únicamente los reemplazos exactos de §§9–14.

No adaptar wording por inferencia.

---

## 28.4 Verificación

Realizar:

- seis diffs completos;
- búsquedas read-only;
- auditoría integral de `11`;
- verificación específica de `02 §29.1`;
- verificación de taxonomía ADR;
- `git diff --name-only`;
- `git diff --check`;
- AC-01…AC-92 uno por uno.

---

## 28.5 Estado inmediato post-ejecución

Antes de revisión humana:

`CORR-006 cambios documentales aplicados = SÍ`

`Revisión humana posterior de CORR-006 = PENDIENTE`

`DO-T03 = RESUELTO/APROBADO`

`ADR-0003 = READY TO DRAFT`

`ADR-0003 redactado = NO`

`ADR-0003 PROPOSED = NO`

`ADR-0003 ACCEPTED = NO`

`Gate de entrada a Fase 2 satisfecho = NO`

`Fase 2 = NO INICIADA`

---

# 29. Procedimiento futuro de revisión humana

Después de ejecutar CORR-006:

1. inspeccionar los seis diffs;
2. verificar AC-01…AC-92;
3. verificar que no existan cambios fuera de alcance;
4. confirmar DO-T03 resuelto en metadata activa;
5. confirmar referencias históricas intactas;
6. confirmar ADR-0003 sin DO-T03 como blocker;
7. confirmar `ADR-0003 = READY TO DRAFT`;
8. confirmar ADR-0003 no redactado;
9. confirmar ADR-0003 no `PROPOSED`;
10. confirmar ADR-0003 no `ACCEPTED`;
11. confirmar ADR-0004 conserva sus cuatro blockers;
12. confirmar DO-075 intacta;
13. confirmar literalmente la condición provider-side de `02 §29.1`;
14. confirmar que `coordinación offline antes de Fase 5` no fue ampliada ni sustituida;
15. revisar el inventario completo de coincidencias de `11`;
16. confirmar que todas las coincidencias quedaron clasificadas como:
    - cambio aplicado;
    - histórica/governance válida;
    - referencia actual válida;
17. confirmar ausencia de `UNEXPECTED` sin resolver;
18. aprobar o devolver CORR-006.

Sólo tras aprobación de esta revisión podrá declararse:

`Sincronización documental del cierre de DO-T03 = COMPLETADA`

---

# 30. Gate posterior

Una vez CORR-006 sea:

- canonicalizada;
- ejecutada;
- verificada;
- revisada humanamente;
- incorporada;

el siguiente trabajo será:

`preparar ADR-0003`

como documento separado.

No debe existir otra revisión para decidir si ADR-0003 pasa a `READY TO DRAFT`, porque esa decisión humana ya ocurrió.

Secuencia posterior:

1. preparar/redactar ADR-0003;
2. revisión técnica, arquitectónica y de seguridad;
3. correcciones si corresponden;
4. aprobación humana;
5. `ADR-0003 = ACCEPTED`;
6. sólo después evaluar separadamente el Gate de entrada a Fase 2.

`READY TO DRAFT` no autoriza implementación.

CORR-006 no redacta ADR-0003 ni autoriza su aceptación automática.

---

# 31. Estado previsto tras CORR-006 ejecutada, revisada e incorporada

`DO-T03 = RESUELTO/APROBADO`

`Sincronización documental del cierre de DO-T03 = COMPLETADA`

`ADR-0003 = READY TO DRAFT`

`ADR-0003 redactado = NO`

`ADR-0003 PROPOSED = NO`

`ADR-0003 ACCEPTED = NO`

`Gate de entrada a Fase 2 satisfecho = NO`

`Fase 2 = NO INICIADA`

---

# 32. Metadata final

**ID:** `CORR-006`

**Título:** `CORR-006 — Sincronización documental del cierre de DO-T03`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega aprobado:**

`CORR-006-do-t03-closure-state-sync-approved.md`

**Ruta canónica futura:**

`docs/tasks/CORR-006-do-t03-closure-state-sync.md`

**Tipo:** corrección documental controlada.

**Documentos propuestos `CHANGE REQUIRED`:**

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

**Documentos revisados `NO CHANGE REQUIRED`:**

```text
docs/tasks/CORR-005-do-t03-rf019-document-sync.md
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md
```

**RF-019 modificado:** `NO`

**Semántica DO-T03 reformulada nuevamente:** `NO`

**DO-075 modificada:** `NO`

**DO-T04 resuelta:** `NO`

**OFF-OPEN-001 resuelta:** `NO`

**OFF-OPEN-002 resuelta:** `NO`

**DO-T03 sincronizada físicamente durante esta aprobación documental:** `NO`

**ADR-0003 estado lógico aprobado:** `READY TO DRAFT`

**ADR-0003 estado sincronizado físicamente durante esta aprobación documental:** `NO`

**ADR-0003 redactado:** `NO`

**ADR-0003 PROPOSED:** `NO`

**ADR-0003 ACCEPTED:** `NO`

**Gate Fase 2 evaluado:** `NO`

**Fase 2 iniciada:** `NO`

**Repositorio modificado durante esta aprobación documental:** `NO`

**Codex ejecutado:** `NO`

**Especificación aprobada para futura implementación documental:** `SÍ`

**Ejecución concreta autorizada:** `NO`

---

`CORR-006 = APPROVED FOR IMPLEMENTATION`

`DO-T03 = RESUELTO/APROBADO`

`Sincronización documental del nuevo estado de DO-T03 = PENDIENTE`

`ADR-0003 = READY TO DRAFT`

`ADR-0003 redactado = NO`

`ADR-0003 PROPOSED = NO`

`ADR-0003 ACCEPTED = NO`

`Gate de entrada a Fase 2 satisfecho = NO`

`Fase 2 = NO INICIADA`
