# CORR-007 — Sincronización documental de `ADR-0003 = ACCEPTED`

## 1. Identificación

**ID:** `CORR-007`

**Título:** `CORR-007 — Sincronización documental de ADR-0003 = ACCEPTED`

**Tipo:** corrección documental controlada de estado arquitectónico y referencias activas.

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega aprobado:**

`CORR-007-adr-0003-accepted-state-sync-approved.md`

**Ruta canónica futura:**

`docs/tasks/CORR-007-adr-0003-accepted-state-sync.md`

**Naturaleza:** exclusivamente documental.

**Ejecución realizada:** `NO`

**Repositorio modificado durante esta aprobación documental:** `NO`

**Codex ejecutado:** `NO`

**Gate de entrada a Fase 2 evaluado:** `NO`

**Fase 2 iniciada:** `NO`

La solicitud que origina esta corrección establece como estado canónico ya incorporado `ADR-0003 = ACCEPTED`, mantiene explícitamente el Gate de entrada a Fase 2 sin evaluar y prohíbe convertir esta sincronización en implementación.

La aprobación de CORR-007 significa exclusivamente que esta especificación documental queda aprobada como contrato para una ejecución documental futura.

No significa que una ejecución concreta esté autorizada.

---

# 2. Objetivo

CORR-007 tiene un único objetivo:

> sincronizar en la documentación normativa activa el estado arquitectónico ya aprobado e incorporado:
>
> `ADR-0003 = ACCEPTED`

La corrección debe eliminar exclusivamente metadata activa que todavía presente `ADR-0003` como:

- `READY TO DRAFT`;
- pendiente de redacción;
- pendiente de revisión;
- pendiente de aprobación;
- todavía no `ACCEPTED`;
- bloqueante exclusivamente por faltar su aceptación.

CORR-007 **no crea ni modifica la decisión arquitectónica**. El ADR canónico ya declara `Status: ACCEPTED`, mantiene `DO-T03 = RESUELTO/APROBADO`, no autoriza implementación y declara que el Gate de Fase 2 todavía no ha sido evaluado ni satisfecho.

---

# 3. Contexto y decisión que origina CORR-007

La secuencia documental previa fue:

1. CORR-005 sincronizó la reformulación técnica de DO-T03.
2. `DO-T03 = RESUELTO/APROBADO` fue aprobado mediante decisión humana separada.
3. CORR-006 sincronizó ese cierre y llevó documentalmente:
   `ADR-0003 = READY TO DRAFT`.
4. ADR-0003 fue redactado y revisado.
5. La segunda versión corregida fue aprobada formalmente.
6. ADR-0003 fue canonicalizado e incorporado a Git.
7. Su estado arquitectónico canónico actual es:
   `ADR-0003 = ACCEPTED`.

CORR-006 dejó correctamente el registro maestro con `6 ACCEPTED + 1 READY TO DRAFT + 8 BLOCKED + 3 DEFERRED`, y las referencias activas de `11` con ADR-0003 todavía `READY TO DRAFT`, porque ese era el estado correcto cuando CORR-006 fue ejecutada.

Esas referencias han quedado ahora **stale** exclusivamente por la aprobación e incorporación posterior de ADR-0003.

---

# 4. Verificación de numeración

El historial documental disponible contiene correcciones hasta:

`CORR-006`

y no se ha localizado una corrección canónica posterior con ID `CORR-007`.

Por tanto se propone:

`CORR-007`

como siguiente identificador coherente.

La numeración no debe confiarse ciegamente durante una futura canonicalización o ejecución. Antes de crear el documento canónico deberá comprobarse que no existe ya ningún `CORR-007` canónico incompatible.

Si ya existe un `CORR-007` distinto:

`BLOCKER`

No renumerar por inferencia.

---

# 5. Fuente de verdad

## 5.1 Fuente arquitectónica principal

```text
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

Debe considerarse la autoridad principal sobre el estado y contenido arquitectónico de ADR-0003.

Estado consumido:

`ADR-0003 = ACCEPTED`

El ADR aceptado declara también que su aprobación no autoriza implementación ni implica que el Gate de Fase 2 haya sido evaluado o satisfecho.

---

## 5.2 Documentos maestros prioritarios

Revisar íntegramente:

```text
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

CORR-006 dejó activamente `ADR-0003 = READY TO DRAFT` en ambos documentos y actualizó el registro a una distribución de `6 / 1 / 8 / 3`; ésa es la baseline que CORR-007 debe sincronizar.

---

## 5.3 Fuentes de preservación

Deben consultarse cuando corresponda, pero inicialmente son `NO CHANGE REQUIRED`:

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/tasks/CORR-005-do-t03-rf019-document-sync.md
docs/tasks/CORR-006-do-t03-closure-state-sync.md
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md
```

La búsqueda integral de la futura ejecución puede localizar otras referencias, pero no autoriza automáticamente ampliar el diff.

---

# 6. Alcance

## 6.1 `CHANGE REQUIRED` confirmado

La ejecución futura de CORR-007 queda inicialmente limitada a:

```text
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

Estos son los únicos documentos con cambios concretos autorizados por esta especificación.

---

## 6.2 Auditoría fuera de esos dos documentos

Debe realizarse una búsqueda read-only sobre documentación aprobada pertinente para detectar referencias adicionales a:

- `ADR-0003`;
- `READY TO DRAFT`;
- `PROPOSED`;
- `ACCEPTED`;
- `DO-T03`;
- `Fase 2`.

Una referencia adicional debe clasificarse antes de actuar:

- `ACTIVE STALE REFERENCE — CHANGE`;
- `VALID CURRENT REFERENCE — KEEP`;
- `HISTORICAL/GOVERNANCE — KEEP`;
- `UNEXPECTED — BLOCKER`.

Si una referencia adicional requiere modificación y no está incluida expresamente en §§9–10:

`BLOCKER`

CORR-007 debe volver a revisión antes de ampliar su scope.

---

# 7. Fuera de alcance

CORR-007 no puede:

- modificar las decisiones de ADR-0003;
- modificar el ADR canónico;
- implementar Auth;
- diseñar schema físico;
- crear tablas;
- definir columnas;
- definir PK/FK;
- diseñar índices;
- diseñar constraints;
- escribir SQL;
- crear migrations;
- escribir policies RLS;
- definir helper functions;
- utilizar `SECURITY DEFINER`;
- diseñar triggers;
- diseñar RPC;
- definir claims;
- definir custom claims;
- definir Auth hooks;
- seleccionar TTL;
- decidir validación física de `session_id`;
- crear un session registry;
- elegir una primitiva Supabase concreta de session termination;
- implementar Storage;
- diseñar buckets;
- diseñar paths;
- diseñar signed URLs;
- escribir Storage policies;
- seleccionar Server Actions concretas;
- seleccionar Route Handlers concretos;
- diseñar endpoints;
- resolver ADR-0004;
- resolver DO-T04;
- resolver OFF-OPEN-001;
- resolver OFF-OPEN-002;
- modificar DO-075;
- evaluar el Gate de entrada a Fase 2;
- declarar ese Gate satisfecho;
- iniciar Fase 2;
- autorizar implementación.

---

# 8. Matriz de impacto documental

| Documento | Referencia | Estado vigente | Tratamiento |
|---|---|---|---|
| `10-architecture-decisions-records.md` | §7 — fila ADR-0003 | `READY TO DRAFT` | `ACTIVE STALE REFERENCE — CHANGE` |
| `10-architecture-decisions-records.md` | §9 — estado ADR-0003 | `READY TO DRAFT` + pendiente de redactar/revisar/aprobar | `ACTIVE STALE REFERENCE — CHANGE` |
| `10-architecture-decisions-records.md` | §29 — ADR bloqueados | ADR-0003 ya no figura | `VALID CURRENT REFERENCE — KEEP` |
| `10-architecture-decisions-records.md` | §37.4 — distribución | 6 Accepted / 1 Ready / 8 Blocked / 3 Deferred | `ACTIVE STALE REFERENCE — CHANGE` |
| `10-architecture-decisions-records.md` | §37.6 | DO-T03 ya no figura abierto | `VALID CURRENT REFERENCE — KEEP` |
| `11-phase-1-scope-entry-gate.md` | §6.1 | ADR-0003 `READY TO DRAFT` | `ACTIVE STALE REFERENCE — CHANGE` |
| `11-phase-1-scope-entry-gate.md` | §7.9 inventario DO-T03 | DO-T03 resuelto | `VALID CURRENT REFERENCE — KEEP` |
| `11-phase-1-scope-entry-gate.md` | §7.9 párrafo posterior | ADR-0003 `READY TO DRAFT`; aún debe aprobarse | `ACTIVE STALE REFERENCE — CHANGE` |
| `11-phase-1-scope-entry-gate.md` | matriz — Auth funcional | razón dice ADR-0003 “aún no está aceptado” | `ACTIVE STALE REFERENCE — CHANGE` |
| `11-phase-1-scope-entry-gate.md` | matriz — policies RLS | debe respetar ADR-0003/DO-T03 | `VALID CURRENT REFERENCE — KEEP` |
| `11-phase-1-scope-entry-gate.md` | §8.1 requisito ADR-0002 + ADR-0003 | requisito arquitectónico | `VALID CURRENT REFERENCE — KEEP` |
| `11-phase-1-scope-entry-gate.md` | §10.2 | ADR-0003 READY TO DRAFT/pending approval | `ACTIVE STALE REFERENCE — CHANGE` |
| `11-phase-1-scope-entry-gate.md` | Gate keeper — verificar ADR-0003 ACCEPTED | condición de evaluación | `VALID CURRENT REFERENCE — KEEP` |
| `11-phase-1-scope-entry-gate.md` | §14.2 | READY TO DRAFT + ACCEPTED pendiente | `ACTIVE STALE REFERENCE — CHANGE` |
| `11-phase-1-scope-entry-gate.md` | §15 Paso 9 | secuencia histórica | `HISTORICAL/GOVERNANCE — KEEP` |
| `11-phase-1-scope-entry-gate.md` | `P1-RSK-003` | DO-T03 debía resolverse antes de ADR-0003 | `HISTORICAL/GOVERNANCE — KEEP` |
| `11-phase-1-scope-entry-gate.md` | `P1-RSK-006` | ADR aceptado no autoriza implementación anticipada | `VALID CURRENT REFERENCE — KEEP` |
| `11-phase-1-scope-entry-gate.md` | `P1-RSK-009` | ADR-0003 debe estar ACCEPTED antes de Fase 2 | `VALID CURRENT REFERENCE — KEEP` |
| `11-phase-1-scope-entry-gate.md` | §17 | ADR-0003 READY TO DRAFT/pending approval | `ACTIVE STALE REFERENCE — CHANGE` |
| ADR-0003 canónico | documento completo | `ACCEPTED` | `NO CHANGE REQUIRED` |
| CORR-006 | documento histórico | `READY TO DRAFT` era el estado de su momento | `HISTORICAL/GOVERNANCE — KEEP` |
| CORR-005 | documento histórico | estados anteriores | `HISTORICAL/GOVERNANCE — KEEP` |
| TASK-007 | documento histórico | estados anteriores | `HISTORICAL/GOVERNANCE — KEEP` |
| ADR-0002 | ADR aceptado | compatible | `NO CHANGE REQUIRED` |
| ADR-0005 | ADR aceptado | compatible | `NO CHANGE REQUIRED` |
| `01..04` | referencias conceptuales actuales | sin cambio de decisión requerido conocido | `VALID CURRENT REFERENCE — KEEP`, sujeto a auditoría |


---

# 9. Cambios exactos — `docs/product/10-architecture-decisions-records.md`

## 9.1 §7 — catálogo definitivo, fila de `ADR-0003`

### Texto vigente

```markdown
| `ADR-0003` | Autorización, client scope y soporte excepcional | Resolver actor, membership, `UserClientAccess`, grants, revocación y sesión | `ADR-CAND-01/02`, `ADR-CAND-SEC-02/03/06` | Ninguna | `READY TO DRAFT` | Fase 2 |
```

Este estado fue el resultado explícito de CORR-006.

### Texto final propuesto EXACTO

```markdown
| `ADR-0003` | Autorización, client scope y soporte excepcional | Resolver actor, membership, `UserClientAccess`, grants, revocación y sesión | `ADR-CAND-01/02`, `ADR-CAND-SEC-02/03/06` | Ninguna | `ACCEPTED` | Fase 2 |
```

### Justificación

Únicamente sincroniza el estado ya aprobado.

No cambia:

- título;
- problema;
- candidatos consolidados;
- dependencias;
- deadline.

---

## 9.2 §9 — ADR de autorización y soporte excepcional

### Contenido técnico

Todo el contenido técnico anterior al bloque de estado debe permanecer **sin cambios**.

En particular debe conservarse exactamente la línea ya sincronizada por CORR-005/CORR-006:

```markdown
- tratamiento provider-side de sesiones y credenciales renovables conforme a la semántica aprobada de DO-T03, exclusivamente mediante mecanismos públicos, soportados y contractualmente adecuados cuando corresponda;
```

No reformular.

### Texto vigente del bloque de estado

```markdown
## Estado

`DO-T03 = RESUELTO/APROBADO`.

DO-T03 ya no constituye un blocker de `ADR-0003`.

**Estado del futuro ADR: `READY TO DRAFT`.**

`READY TO DRAFT` autoriza únicamente preparar `ADR-0003` como documento separado. No equivale a `PROPOSED`, no equivale a `ACCEPTED` y no autoriza implementación.

`ADR-0003` todavía debe redactarse, revisarse y quedar `ACCEPTED` antes de implementar identidad/autorización de Fase 2.
```

Ese bloque es el resultado activo introducido mediante CORR-006.

### Texto final propuesto EXACTO

```markdown
## Estado

`DO-T03 = RESUELTO/APROBADO`.

DO-T03 ya no constituye un blocker de `ADR-0003`.

**Estado del ADR: `ACCEPTED`.**

`ADR-0003` fue redactado, revisado y aprobado formalmente mediante decisión humana separada. Su aceptación arquitectónica no autoriza implementación y no equivale a que el Gate de entrada a Fase 2 haya sido evaluado o satisfecho.
```

### Justificación

Elimina exclusivamente:

- “futuro ADR”;
- `READY TO DRAFT`;
- la afirmación de que falta redactarlo;
- la afirmación de que falta revisarlo;
- la afirmación de que falta aprobarlo.

Añade únicamente la distinción de governance ya declarada por el ADR aceptado:

`ACCEPTED ≠ Gate de Fase 2 evaluado/satisfecho`.

---

## 9.3 §29 — ADRs bloqueados

`VALID CURRENT REFERENCE — KEEP`

CORR-006 ya retiró ADR-0003 de esta sección.

No reinsertar ADR-0003.

No modificar ADR-0004.

ADR-0004 debe continuar:

`BLOCKED BY OPEN DECISIONS`

por sus cuatro blockers restantes:

- `DO-T04`;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `FORM-OPEN-004`.

---

## 9.4 §37.4 — distribución actual

### Texto vigente

```markdown
**ADRs definitivos propuestos: 18.**

Distribución actual:

- `ACCEPTED`: **6**;
- `READY TO DRAFT`: **1**;
- `BLOCKED BY OPEN DECISIONS`: **8**;
- `DEFERRED`: **3**.
```

La distribución fue establecida por CORR-006 cuando ADR-0003 era el único `READY TO DRAFT`.

### Derivación obligatoria

Sólo cambia el estado de ADR-0003:

```text
READY TO DRAFT: 1 → 0
ACCEPTED: 6 → 7
BLOCKED: 8 → 8
DEFERRED: 3 → 3
```

Por tanto:

```text
7 + 0 + 8 + 3 = 18
```

### Texto final propuesto EXACTO

```markdown
**ADRs definitivos propuestos: 18.**

Distribución actual:

- `ACCEPTED`: **7**;
- `READY TO DRAFT`: **0**;
- `BLOCKED BY OPEN DECISIONS`: **8**;
- `DEFERRED`: **3**.
```

### Restricción

No modificar el estado de ningún otro ADR para conseguir esta distribución.

Si el catálogo completo vigente no produce exactamente:

`7 / 0 / 8 / 3`

después de actualizar exclusivamente ADR-0003:

`BLOCKER`

---

## 9.5 §37.6 — decisiones abiertas

`VALID CURRENT REFERENCE — KEEP`

DO-T03 ya fue retirado de la lista mediante CORR-006.

`DO-T04` continúa abierto.

`DO-075` continúa cerrado.

No modificar esta sección salvo contradicción material demostrada.

---

## 9.6 Referencias históricas del Gate de Fase 0

`HISTORICAL/GOVERNANCE — KEEP`

No modificar retroactivamente snapshots donde ADR-0003 aparecía bloqueado durante el Gate de Fase 0.

En particular, una referencia histórica como §36.4 puede conservar un estado anterior porque describe el momento de cierre de Fase 0, no el estado operativo actual del ADR.

---

# 10. Cambios exactos — `docs/product/11-phase-1-scope-entry-gate.md`

## 10.1 §6.1 — Fase 2

### Texto vigente EXACTO

```markdown
`DO-T03 = RESUELTO/APROBADO` y ya no constituye un blocker de `ADR-0003`. `ADR-0003 = READY TO DRAFT`; este estado autoriza únicamente preparar el ADR como documento separado y no autoriza implementación. `ADR-0003` debe estar `ACCEPTED` antes de implementar identidad/autorización de Fase 2.
```

Este texto fue el resultado de CORR-006.

### Texto final propuesto EXACTO

```markdown
`DO-T03 = RESUELTO/APROBADO` y ya no constituye un blocker de `ADR-0003`. `ADR-0003 = ACCEPTED`; el requisito arquitectónico de aceptación previa a la implementación de identidad/autorización de Fase 2 está cumplido. Esta aceptación no autoriza por sí sola la implementación ni implica que el Gate de entrada a Fase 2 haya sido evaluado o satisfecho.
```

### Justificación

Sincroniza el requisito arquitectónico cumplido sin evaluar el Gate.

---

## 10.2 §7.9 — inventario de DO-T03

### Texto vigente

```markdown
- `DO-T03 = RESUELTO/APROBADO` — resuelta antes de Fase 2 para autorización/sesión y coordinación offline antes de Fase 5;
```

### Tratamiento

`VALID CURRENT REFERENCE — KEEP`

**No modificar.**

Preserva exactamente:

`coordinación offline antes de Fase 5`.

---

## 10.3 §7.9 — párrafo activo posterior al inventario

### Texto vigente EXACTO

```markdown
`DO-T03 = RESUELTO/APROBADO` y ya no constituye una decisión abierta ni un blocker de `ADR-0003`. `ADR-0003 = READY TO DRAFT`, pero este estado autoriza únicamente preparar el ADR como documento separado y no autoriza implementación. La implementación de identidad/autorización de Fase 2 continúa bloqueada hasta que `ADR-0003` sea redactado, revisado y quede `ACCEPTED`.
```

El diff de CORR-006 confirma esta formulación activa.

### Texto final propuesto EXACTO

```markdown
`DO-T03 = RESUELTO/APROBADO` y ya no constituye una decisión abierta ni un blocker de `ADR-0003`. `ADR-0003 = ACCEPTED`, por lo que el requisito arquitectónico de aceptación de ADR-0003 está cumplido. La implementación de identidad/autorización de Fase 2 no queda autorizada por esta aceptación: el Gate de entrada a Fase 2 permanece pendiente de evaluación separada.
```

### Justificación

Elimina exclusivamente las condiciones de redacción/revisión/aprobación ya completadas.

No declara satisfecho el Gate.

---

## 10.4 Matriz de acciones — Auth funcional

### Texto vigente EXACTO

```markdown
| Inicializar/configurar Supabase Auth funcional para usuarios del producto | **NO PERMITIDO TODAVÍA** | Autenticación, roles y RLS pertenecen a Fase 2 y `ADR-0003` aún no está aceptado. |
```

La matriz aprobada contiene expresamente esta razón normativa.

### Texto final propuesto EXACTO

```markdown
| Inicializar/configurar Supabase Auth funcional para usuarios del producto | **NO PERMITIDO TODAVÍA** | Autenticación, roles y RLS pertenecen a Fase 2. `ADR-0003 = ACCEPTED`, pero el Gate de entrada a Fase 2 todavía no ha sido evaluado ni declarado satisfecho. |
```

### Justificación

La clasificación:

`NO PERMITIDO TODAVÍA`

**no cambia**.

Sólo cambia la razón:

- antes: ADR-0003 no estaba aceptado;
- ahora: ADR-0003 está aceptado, pero todavía no existe evaluación/autorización del Gate.

Esto no constituye evaluación del Gate.

---

## 10.5 Matriz de acciones — policies RLS

### Texto vigente

```markdown
| Diseñar policies RLS ejecutables | **NO PERMITIDO TODAVÍA** | RLS funcional pertenece a Fase 2 y debe respetar `ADR-0003`/`DO-T03` cuando corresponda. |
```

### Tratamiento

`VALID CURRENT REFERENCE — KEEP`

No afirma que ADR-0003 esté pendiente.

No modificar.

---

## 10.6 §8.1 — requisito previo ADR-0002 + ADR-0003

Cualquier fila equivalente a:

`Antes de Fase 2: ADR-0002 + ADR-0003`

se clasifica:

`VALID CURRENT REFERENCE — KEEP`

Es un requisito de Gate, no una afirmación de que siga incumplido.

---

## 10.7 §8.3 — separación respecto del Gate directo de Fase 1

`HISTORICAL/GOVERNANCE — KEEP`

No modificar referencias que expliquen que ADR-0003 no era parte del Gate directo de Fase 1.

---

## 10.8 §10.2 — Requisito para entrar en Fase 2

### Texto vigente EXACTO

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

Ese bloque fue introducido por CORR-006.

### Texto final propuesto EXACTO

```markdown
## 10.2 Requisito para entrar en Fase 2

El registro maestro exige antes de Fase 2:

- `ADR-0002 = ACCEPTED`;
- `ADR-0003 = ACCEPTED`.

`ADR-0002` ya está `ACCEPTED`.

`DO-T03 = RESUELTO/APROBADO`.

`ADR-0003 = ACCEPTED`.

El requisito arquitectónico de aceptación de `ADR-0003` está cumplido. Esta aceptación no autoriza automáticamente comenzar Fase 2 ni sustituye la evaluación formal y separada de su Gate de entrada.

Por tanto:

> **Completar Fase 1, resolver DO-T03 o contar con `ADR-0003 = ACCEPTED` no autoriza automáticamente comenzar Fase 2.**

La transición requiere todavía evaluar separadamente el Gate de entrada a Fase 2 y, sólo si ese Gate resulta satisfecho mediante decisión explícita, autorizar la implementación de Fase 2.

Este documento:

- reconoce `DO-T03 = RESUELTO/APROBADO`;
- reconoce `ADR-0003 = ACCEPTED`;
- no evalúa el Gate de entrada a Fase 2;
- no declara satisfecho el Gate de entrada a Fase 2;
- no inicia Fase 2.
```

### Justificación

Se distingue estrictamente:

```text
requisito arquitectónico satisfecho
≠
Gate de Fase 2 evaluado
≠
Gate de Fase 2 satisfecho
≠
implementación autorizada
```

---

## 10.9 §10.3 — separación cierre Fase 1 / entrada Fase 2

Las formulaciones condicionales de governance que indiquen que Fase 2 no debe comenzar **hasta que ADR-0003 esté ACCEPTED** pueden permanecer si no presentan esa aceptación como pendiente actual.

Clasificación inicial:

`VALID CURRENT REFERENCE — KEEP`

Si existe una frase activa que diga expresamente que actualmente falta la aceptación:

`ACTIVE STALE REFERENCE — CHANGE`

Si la distinción no es inequívoca:

`UNEXPECTED — BLOCKER`

---

## 10.10 §14.2 — condición adicional para cruzar hacia Fase 2

### Texto vigente EXACTO

```markdown
Antes de comenzar la implementación de Fase 2 debe verificarse además:

- `ADR-0002 = ACCEPTED` — ya cumplido;
- `DO-T03 = RESUELTO/APROBADO` — ya cumplido;
- `ADR-0003 = READY TO DRAFT` — estado actual aprobado, insuficiente por sí mismo para Fase 2;
- `ADR-0003 = ACCEPTED` — pendiente y obligatorio antes de implementar Fase 2.

Por tanto, la salida de Fase 1 y la entrada a Fase 2 son controles relacionados pero no idénticos.

**Fase 2 permanece bloqueada mientras `ADR-0003` no esté `ACCEPTED`.**
```

CORR-006 estableció expresamente este estado.

### Texto final propuesto EXACTO

```markdown
Antes de comenzar la implementación de Fase 2 debe verificarse además:

- `ADR-0002 = ACCEPTED` — ya cumplido;
- `DO-T03 = RESUELTO/APROBADO` — ya cumplido;
- `ADR-0003 = ACCEPTED` — ya cumplido.

Por tanto, la salida de Fase 1 y la entrada a Fase 2 son controles relacionados pero no idénticos.

**El requisito arquitectónico `ADR-0003 = ACCEPTED` está cumplido, pero el Gate de entrada a Fase 2 permanece pendiente de evaluación separada. Este documento no declara ese Gate satisfecho ni autoriza el inicio de Fase 2.**
```

### Justificación

La antigua frase:

`Fase 2 permanece bloqueada mientras ADR-0003 no esté ACCEPTED`

ya no puede describir el estado actual porque la condición ya fue satisfecha.

No se reemplaza por:

`Fase 2 = AUTORIZADA`

sino por:

`Gate pendiente de evaluación separada`.

---

## 10.11 §15 — Paso 9

### Tratamiento

`HISTORICAL/GOVERNANCE — KEEP`

No modificar la secuencia:

- revisar DO-T03;
- desbloquear ADR-0003;
- redactar/revisar/aprobar ADR-0003;
- evaluar Gate de entrada de Fase 2.

El propio documento la presenta como secuencia de Paso 9 y no como estado actual de ADR-0003.

---

## 10.12 `P1-RSK-003`

### Tratamiento

`HISTORICAL/GOVERNANCE — KEEP`

La regla:

`DO-T03 debe resolverse documentalmente antes de aprobar ADR-0003`

describe una condición que fue cumplida.

No afirma que DO-T03 siga abierto.

---

## 10.13 `P1-RSK-006`

### Tratamiento

`VALID CURRENT REFERENCE — KEEP`

La regla de que un ADR aceptado no constituye autorización de implementación anticipada es especialmente relevante después de la aceptación de ADR-0003.

No modificar.

---

## 10.14 `P1-RSK-009`

### Tratamiento

`VALID CURRENT REFERENCE — KEEP`

El control:

```markdown
`ADR-0003` debe estar `ACCEPTED` antes de implementar Fase 2; `DO-T03` no se resuelve por inferencia.
```

continúa siendo una regla correcta de governance.

El requisito ahora está cumplido, pero la frase no afirma que esté pendiente.

---

## 10.15 §17 — Resultado final

### Texto vigente EXACTO

```markdown
`DO-T03 = RESUELTO/APROBADO` y ya no constituye un blocker de `ADR-0003`. `ADR-0003 = READY TO DRAFT`, lo que autoriza únicamente su preparación como documento separado; todavía debe redactarse, revisarse y quedar `ACCEPTED` antes de implementar Fase 2. Este documento no redacta ni aprueba `ADR-0003`.
```

CORR-006 fijó expresamente esta versión.

### Texto final propuesto EXACTO

```markdown
`DO-T03 = RESUELTO/APROBADO` y ya no constituye un blocker de `ADR-0003`. `ADR-0003 = ACCEPTED`, por lo que el requisito arquitectónico de aceptación previa a Fase 2 está cumplido. Esta aceptación no autoriza por sí sola la implementación: el Gate de entrada a Fase 2 permanece pendiente de evaluación separada. Este documento no evalúa ni declara satisfecho ese Gate y no inicia Fase 2.
```

---

# 11. Documentos revisados sin cambio

## 11.1 ADR-0003 canónico

```text
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

Clasificación:

`NO CHANGE REQUIRED`

Su contenido ya registra:

- `Status: ACCEPTED`;
- `ADR-0003 ACCEPTED = SÍ`;
- `DO-T03 = RESUELTO/APROBADO`;
- implementación no autorizada;
- Gate Fase 2 no evaluado;
- Gate Fase 2 no satisfecho;
- Fase 2 no iniciada.

Cualquier contradicción material encontrada en el ADR:

`BLOCKER`

No corregirla dentro de CORR-007.

---

## 11.2 CORR-006

```text
docs/tasks/CORR-006-do-t03-closure-state-sync.md
```

Clasificación:

`HISTORICAL/GOVERNANCE — KEEP`

Sus referencias `ADR-0003 = READY TO DRAFT` deben conservarse porque describen correctamente el resultado y Gate posterior de CORR-006.

---

## 11.3 CORR-005

```text
docs/tasks/CORR-005-do-t03-rf019-document-sync.md
```

`HISTORICAL/GOVERNANCE — KEEP`

---

## 11.4 TASK-007

```text
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
```

`HISTORICAL/GOVERNANCE — KEEP`

Sus estados anteriores no deben actualizarse retrospectivamente.

---

## 11.5 ADR-0002

```text
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
```

`NO CHANGE REQUIRED`

---

## 11.6 ADR-0005

```text
docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md
```

`NO CHANGE REQUIRED`

---

## 11.7 `docs/product/01..04`

Clasificación inicial:

`VALID CURRENT REFERENCE — KEEP`

CORR-006 ya sincronizó en estos documentos el cierre de DO-T03. No existe evidencia actual que justifique volver a alterar su contenido sólo porque ADR-0003 fue aceptado.

Si una futura búsqueda descubre en alguno una afirmación activa explícita de:

- `ADR-0003 = READY TO DRAFT`;
- ADR-0003 pendiente de aprobación;
- ADR-0003 todavía no aceptado;

la ejecución debe detenerse:

`UNEXPECTED — BLOCKER`

No ampliar el diff automáticamente.

---

# 12. Clasificación integral obligatoria

## 12.1 Ocurrencias conocidas en `10`

| Referencia | Clasificación |
|---|---|
| §7 fila ADR-0003 = READY TO DRAFT | `ACTIVE STALE REFERENCE — CHANGE` |
| §9 estado ADR-0003 = READY TO DRAFT | `ACTIVE STALE REFERENCE — CHANGE` |
| §9 “todavía debe redactarse, revisarse…” | `ACTIVE STALE REFERENCE — CHANGE` |
| §29 ausencia de ADR-0003 de bloqueados | `VALID CURRENT REFERENCE — KEEP` |
| §37.4 distribución 6/1/8/3 | `ACTIVE STALE REFERENCE — CHANGE` |
| §37.6 DO-T03 no listado | `VALID CURRENT REFERENCE — KEEP` |
| snapshots de Fase 0 con ADR-0003 históricamente bloqueado | `HISTORICAL/GOVERNANCE — KEEP` |

---

## 12.2 Ocurrencias conocidas en `11`

| Referencia | Clasificación |
|---|---|
| §6.1 ADR-0003 READY TO DRAFT | `ACTIVE STALE REFERENCE — CHANGE` |
| §7.9 DO-T03 RESUELTO/APROBADO | `VALID CURRENT REFERENCE — KEEP` |
| §7.9 ADR-0003 READY TO DRAFT / pendiente de aceptación | `ACTIVE STALE REFERENCE — CHANGE` |
| matriz Auth: “ADR-0003 aún no está aceptado” | `ACTIVE STALE REFERENCE — CHANGE` |
| matriz RLS: debe respetar ADR-0003/DO-T03 | `VALID CURRENT REFERENCE — KEEP` |
| §8.1 requisito ADR-0002 + ADR-0003 | `VALID CURRENT REFERENCE — KEEP` |
| §8.3 relación con Gate de Fase 1 | `HISTORICAL/GOVERNANCE — KEEP` |
| §10.2 ADR-0003 READY TO DRAFT | `ACTIVE STALE REFERENCE — CHANGE` |
| §10.2 redacción/revisión/aprobación pendientes | `ACTIVE STALE REFERENCE — CHANGE` |
| Gate keeper: verificar ADR-0003 ACCEPTED | `VALID CURRENT REFERENCE — KEEP` |
| §14.2 READY TO DRAFT / ACCEPTED pendiente | `ACTIVE STALE REFERENCE — CHANGE` |
| §14.2 “Fase 2 permanece bloqueada mientras ADR-0003 no esté ACCEPTED” | `ACTIVE STALE REFERENCE — CHANGE` |
| §15 Paso 9 | `HISTORICAL/GOVERNANCE — KEEP` |
| P1-RSK-003 | `HISTORICAL/GOVERNANCE — KEEP` |
| P1-RSK-006 | `VALID CURRENT REFERENCE — KEEP` |
| P1-RSK-009 | `VALID CURRENT REFERENCE — KEEP` |
| §17 ADR-0003 READY TO DRAFT / aprobación pendiente | `ACTIVE STALE REFERENCE — CHANGE` |


---

# 13. Invariantes de seguridad y multitenancy

CORR-007 no puede alterar ninguna decisión aceptada de ADR-0003.

Deben preservarse íntegramente:

1. `tenant = MaintenanceCompany`;

2. RLS como frontera primaria para datos tenant-owned;

3. autenticación no equivale a autorización;

4. cada Auth subject reconocido resuelve exactamente a un `PlatformUser`;

5. cardinalidad inversa `PlatformUser → Auth subject(s)` permanece diferida;

6. email no es identity key autoritativa;

7. `CompanyMembership` vigente es autoritativa;

8. rol vigente es autoritativo;

9. `UserClientAccess` vigente es autoritativo;

10. `SupportAccessGrant` vigente es autoritativo;

11. `TECHNICIAN` conserva ejecución inicial exclusivamente dentro de clientes autorizados;

12. `COMPANY_ADMIN` no obtiene ejecución inicial;

13. bypass directo o indirecto de ejecución inicial de `COMPANY_ADMIN` produce `DENIED`;

14. `SUPER_ADMIN` no obtiene acceso operativo normal a tenants;

15. `SupportAccessGrant` es limitado, revocable y auditable;

16. un grant no crea membership;

17. un grant no crea capacidades funcionales nuevas;

18. un grant no equivale a CRUD general;

19. Storage permanece subordinado a autorización vigente del dominio;

20. conocer una URL/path/object key no concede acceso;

21. estado autoritativo vigente prevalece;

22. revocación online es inmediata;

23. JWT/sesión residual no mantiene autorización revocada;

24. claims stale no son fuente autoritativa;

25. cache stale no es fuente autoritativa;

26. TTL no constituye garantía primaria de revocación;

27. `session_id` no constituye requisito primario de autorización;

28. backend privilegiado debe ser mínimo y explícito;

29. `service-role` permanece restringido;

30. provider-side termination es defense in depth;

31. sólo se contemplan mecanismos provider-side públicos, soportados y contractualmente adecuados;

32. ausencia/fallo de provider termination no restaura autorización;

33. comportamiento fail-closed;

34. DO-T03 permanece `RESUELTO/APROBADO`;

35. DO-075 permanece sin cambios;

36. ADR-0004 permanece sin resolver.

---

# 14. Estado de decisiones relacionadas

## 14.1 DO-T03

Debe permanecer:

`DO-T03 = RESUELTO/APROBADO`

No reabrir.

---

## 14.2 DO-075

Debe permanecer cerrada/aprobada.

No modificar:

- máximo de 7 días;
- revalidación;
- revocación conocida;
- preservación del trabajo capturado.

---

## 14.3 ADR-0004

Debe permanecer:

`BLOCKED BY OPEN DECISIONS`

CORR-007 no elimina ni resuelve sus cuatro blockers actuales:

- `DO-T04`;
- `OFF-OPEN-001`;
- `OFF-OPEN-002`;
- `FORM-OPEN-004`.

---

## 14.4 DO-T04 / OFF

Permanecen sin resolver:

```text
DO-T04
OFF-OPEN-001
OFF-OPEN-002
```

---

# 15. Prohibiciones

Durante una futura ejecución de CORR-007 queda prohibido:

- modificar ADR-0003 canónico;
- modificar las decisiones de ADR-0003;
- modificar CORR-006;
- modificar CORR-005;
- modificar TASK-007;
- modificar ADR-0002;
- modificar ADR-0005;
- cambiar el estado de cualquier ADR distinto de ADR-0003;
- cambiar ADR-0004;
- cambiar DO-T03;
- cambiar DO-075;
- resolver DO-T04;
- resolver OFF-OPEN-001/002;
- diseñar Auth;
- implementar Auth;
- diseñar schema;
- escribir SQL;
- crear migrations;
- escribir RLS;
- diseñar helpers;
- seleccionar claims;
- seleccionar custom claims;
- fijar TTL;
- fijar `session_id`;
- seleccionar session registry;
- seleccionar provider primitive;
- diseñar Storage;
- definir buckets;
- definir paths;
- definir signed URLs;
- diseñar endpoints;
- definir Server Actions;
- definir Route Handlers;
- implementar código;
- evaluar el Gate de entrada a Fase 2;
- declarar el Gate satisfecho;
- iniciar Fase 2.

---

# 16. Condiciones de `BLOCKER`

La futura ejecución debe detenerse inmediatamente con:

`BLOCKER`

si ocurre cualquiera de estas condiciones:

1. el ADR canónico no existe;

2. el ADR canónico no declara `ACCEPTED`;

3. el ADR canónico contradice la metadata aprobada consumida por CORR-007;

4. `DO-T03` ya no aparece como `RESUELTO/APROBADO`;

5. el wording vigente de un bloque `CHANGE` difiere materialmente del verificado;

6. se descubre una referencia activa adicional que requiere modificación fuera de `10` o `11`;

7. la corrección de una referencia requiere inventar requisitos;

8. existe ambigüedad entre referencia histórica y metadata activa que no puede resolverse documentalmente;

9. la distribución de los 18 ADR no resulta `7 / 0 / 8 / 3` modificando exclusivamente ADR-0003;

10. sería necesario cambiar el estado de otro ADR;

11. ADR-0004 no puede mantenerse con sus cuatro blockers;

12. sería necesario modificar DO-T03;

13. sería necesario modificar DO-075;

14. sería necesario resolver DO-T04 u OFF-OPEN;

15. sería necesario cambiar una decisión arquitectónica de ADR-0003;

16. sería necesario seleccionar diseño físico;

17. sería necesario implementar Auth/RLS/Storage;

18. sería necesario seleccionar una primitiva Supabase concreta;

19. sería necesario evaluar el Gate de Fase 2 para completar la sincronización;

20. sería necesario declarar el Gate satisfecho;

21. cualquier archivo fuera de los dos `CHANGE REQUIRED` aparece en el diff;

22. alguna referencia histórica necesita reescritura para que la corrección “funcione”;

23. aparece una `CORR-007` canónica preexistente incompatible;

24. una búsqueda material produce una coincidencia:

`UNEXPECTED`

que no puede clasificarse inequívocamente sin nueva revisión humana.

Ante `BLOCKER`:

- no continuar;
- no resolver por inferencia;
- no ampliar scope;
- no cambiar documentos adicionales;
- conservar evidencia;
- devolver CORR-007 para revisión.

---

# 17. Búsquedas read-only obligatorias

## 17.1 Auditoría general

Buscar en documentación aprobada pertinente, como mínimo:

```text
ADR-0003
READY TO DRAFT
PROPOSED
ACCEPTED
DO-T03
Fase 2
```

Las búsquedas deben incluir como mínimo:

```text
docs/product/
docs/architecture/adr/
docs/tasks/
```

Sólo son read-only.

---

## 17.2 Auditoría de `10`

Buscar adicionalmente:

```text
Estado del futuro ADR
todavía debe redactarse
todavía debe
ADRs bloqueados
Distribución actual
READY TO DRAFT
```

Resultado esperado para metadata activa posterior:

- ADR-0003 = `ACCEPTED`;
- ninguna frase activa dice que falta redactarlo/revisarlo/aprobarlo;
- ADR-0003 no aparece en ADRs bloqueados;
- distribución = `7 / 0 / 8 / 3`.

---

## 17.3 Auditoría de `11`

Buscar adicionalmente:

```text
aún no está aceptado
pendiente y obligatorio
READY TO DRAFT
redactado
revisado
aprobado
no esté `ACCEPTED`
Fase 2 permanece bloqueada
```

Cada coincidencia debe registrarse como:

```text
archivo
sección
texto
clasificación
acción
```

---

## 17.4 Clasificaciones permitidas

Únicamente:

```text
ACTIVE STALE REFERENCE — CHANGE
VALID CURRENT REFERENCE — KEEP
HISTORICAL/GOVERNANCE — KEEP
UNEXPECTED — BLOCKER
```

No crear categorías ad hoc.

---

# 18. Criterios de aceptación

CORR-007 sólo podrá considerarse correctamente ejecutada si se comprueban individualmente:

1. el diff contiene exclusivamente `docs/product/10-architecture-decisions-records.md` y `docs/product/11-phase-1-scope-entry-gate.md`;

2. ADR-0003 canónico permanece sin cambios;

3. ADR-0002 permanece sin cambios;

4. ADR-0005 permanece sin cambios;

5. CORR-006 permanece sin cambios;

6. CORR-005 permanece sin cambios;

7. TASK-007 permanece sin cambios;

8. `01-product-definition.md` permanece sin cambios;

9. `02-domain-model.md` permanece sin cambios;

10. `03-permissions-rls-strategy.md` permanece sin cambios;

11. `04-offline-sync-strategy.md` permanece sin cambios;

12. `10` §7 registra `ADR-0003 = ACCEPTED`;

13. §7 conserva `Open dependencies = Ninguna`;

14. §7 no cambia ningún otro ADR;

15. `10` §9 registra `DO-T03 = RESUELTO/APROBADO`;

16. §9 registra `ADR-0003 = ACCEPTED`;

17. §9 ya no denomina ADR-0003 “futuro ADR”;

18. §9 ya no indica que falta redactarlo;

19. §9 ya no indica que falta revisarlo;

20. §9 ya no indica que falta aprobarlo;

21. §9 conserva intacto el alcance técnico de ADR-0003;

22. §9 conserva exactamente el wording provider-side crítico;

23. §29 continúa sin listar ADR-0003 como bloqueado;

24. ADR-0004 continúa `BLOCKED BY OPEN DECISIONS`;

25. los blockers de ADR-0004 permanecen exactamente DO-T04, OFF-OPEN-001, OFF-OPEN-002 y FORM-OPEN-004;

26. §37.4 registra `ACCEPTED = 7`;

27. §37.4 registra `READY TO DRAFT = 0`;

28. §37.4 registra `BLOCKED BY OPEN DECISIONS = 8`;

29. §37.4 registra `DEFERRED = 3`;

30. la suma continúa siendo exactamente 18;

31. no se modificó el estado de ningún ADR distinto de ADR-0003;

32. §37.6 conserva DO-T03 fuera de las decisiones abiertas;

33. DO-075 continúa cerrada;

34. `11` §6.1 registra `ADR-0003 = ACCEPTED`;

35. §6.1 declara cumplido exclusivamente el requisito arquitectónico;

36. §6.1 no declara satisfecho el Gate de Fase 2;

37. §7.9 conserva `DO-T03 = RESUELTO/APROBADO`;

38. §7.9 conserva exactamente `coordinación offline antes de Fase 5`;

39. el párrafo activo de §7.9 registra `ADR-0003 = ACCEPTED`;

40. ese párrafo ya no dice que falta redactar/revisar/aprobar ADR-0003;

41. ese párrafo mantiene el Gate de Fase 2 pendiente de evaluación separada;

42. la fila de Auth funcional mantiene clasificación `NO PERMITIDO TODAVÍA`;

43. la razón de esa fila ya no dice “ADR-0003 aún no está aceptado”;

44. la razón de esa fila registra ADR-0003 aceptado y Gate todavía no evaluado/satisfecho;

45. la fila de RLS funcional permanece sin cambio;

46. §8.1 conserva el requisito arquitectónico de ADR-0002 + ADR-0003;

47. §8.3 histórico/governance permanece sin reescritura;

48. §10.2 registra `ADR-0003 = ACCEPTED`;

49. §10.2 registra DO-T03 resuelto;

50. §10.2 declara que la aceptación arquitectónica está cumplida;

51. §10.2 no equipara aceptación con inicio de Fase 2;

52. §10.2 registra explícitamente que el Gate debe evaluarse separadamente;

53. §10.2 no declara Gate satisfecho;

54. §10.2 no inicia Fase 2;

55. §14.2 registra ADR-0002 aceptado como cumplido;

56. §14.2 registra DO-T03 resuelto como cumplido;

57. §14.2 registra ADR-0003 aceptado como cumplido;

58. §14.2 ya no registra `READY TO DRAFT`;

59. §14.2 ya no registra `ACCEPTED` como pendiente;

60. §14.2 mantiene que el Gate sigue pendiente de evaluación separada;

61. §15 Paso 9 permanece sin cambios;

62. P1-RSK-003 permanece sin cambios;

63. P1-RSK-006 permanece sin cambios;

64. P1-RSK-009 permanece sin cambios;

65. §17 registra ADR-0003 aceptado;

66. §17 ya no indica que falta redactarlo/revisarlo/aprobarlo;

67. §17 mantiene el Gate pendiente de evaluación;

68. §17 no declara Fase 2 iniciada;

69. no queda ninguna referencia activa `ADR-0003 = READY TO DRAFT` en `10` o `11`;

70. no queda ninguna referencia activa que presente ADR-0003 como `PROPOSED`;

71. no queda ninguna referencia activa que indique `ADR-0003 ACCEPTED = NO`;

72. no queda ninguna referencia activa que diga que ADR-0003 aún no está aceptado;

73. las referencias históricas con estados antiguos permanecen intactas;

74. `DO-T03 = RESUELTO/APROBADO` permanece intacto;

75. las garantías de revocación inmediata permanecen intactas;

76. RLS como frontera primaria permanece intacta;

77. multitenancy permanece intacto;

78. `COMPANY_ADMIN` continúa sin ejecución inicial;

79. `TECHNICIAN` continúa limitado a clientes autorizados;

80. `SUPER_ADMIN` continúa sin bypass normal;

81. `SupportAccessGrant` mantiene sus límites;

82. Storage continúa subordinado a autorización de dominio;

83. provider-side termination continúa como defense in depth;

84. se preserva “públicos, soportados y contractualmente adecuados”;

85. DO-075 permanece intacta;

86. ADR-0004 permanece sin resolver;

87. DO-T04 permanece sin resolver;

88. OFF-OPEN-001 permanece sin resolver;

89. OFF-OPEN-002 permanece sin resolver;

90. no se diseñó schema físico;

91. no se escribió SQL;

92. no se diseñaron migrations;

93. no se escribieron policies RLS ejecutables;

94. no se implementó Auth;

95. no se implementó Storage;

96. no se seleccionó TTL;

97. no se seleccionó uso físico de `session_id`;

98. no se seleccionó primitiva Supabase concreta;

99. Gate de entrada a Fase 2 permanece `NO EVALUADO`;

100. Gate de entrada a Fase 2 permanece `NO DECLARADO SATISFECHO`;

101. Fase 2 permanece `NO INICIADA`;

102. `git diff --check` finaliza con cero errores;

103. todas las ocurrencias materiales de la auditoría fueron clasificadas;

104. no existe ningún `UNEXPECTED` pendiente;

105. no se introdujo ningún requisito nuevo por inferencia.


---

# 19. Pruebas y verificaciones documentales

## 19.1 Scope del diff

Después de una futura ejecución:

```text
git diff --name-only
```

debe devolver exactamente:

```text
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

Cualquier archivo adicional:

`BLOCKER`

---

## 19.2 Calidad del diff

Ejecutar:

```text
git diff --check
```

Resultado requerido:

`0 errores`

---

## 19.3 Diffs completos

Revisar íntegramente:

```text
git diff -- docs/product/10-architecture-decisions-records.md
git diff -- docs/product/11-phase-1-scope-entry-gate.md
```

---

## 19.4 Verificación del ADR canónico

Confirmar read-only:

```text
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

y comprobar:

```text
Status: ACCEPTED
ADR-0003 ACCEPTED = SÍ
Implementación autorizada por este ADR = NO
Gate de entrada a Fase 2 evaluado = NO
Gate de entrada a Fase 2 satisfecho = NO
Fase 2 = NO INICIADA
```

El ADR aceptado establece expresamente esas fronteras.

---

## 19.5 Taxonomía

Comprobar:

```text
ADR-0003 = ACCEPTED

ACCEPTED = 7
READY TO DRAFT = 0
BLOCKED BY OPEN DECISIONS = 8
DEFERRED = 3
TOTAL = 18
```

---

## 19.6 Gate

Comprobar que la documentación resultante distingue:

```text
ADR-0003 = ACCEPTED
```

de:

```text
Gate de entrada a Fase 2 evaluado = NO
Gate de entrada a Fase 2 satisfecho = NO
Fase 2 = NO INICIADA
```

---

# 20. Procedimiento futuro de ejecución

La aprobación formal de esta especificación ya ocurrió:

`CORR-007 = APPROVED FOR IMPLEMENTATION`

La ejecución concreta de CORR-007 sólo podrá realizarse después de:

1. canonicalización de esta especificación aprobada;
2. autorización humana separada de ejecución.

La aprobación documental actual no constituye esa autorización de ejecución.

## 20.1 Preflight Git

Verificar:

```text
git rev-parse --is-inside-work-tree
git branch --show-current
git rev-parse HEAD
git rev-parse --abbrev-ref --symbolic-full-name @{u}
git rev-parse origin/main
git rev-list --left-right --count HEAD...origin/main
git status --porcelain=v1 --untracked-files=all
```

Debe comprobar:

- repositorio válido;
- branch `main`;
- upstream `origin/main`;
- HEAD = origin/main;
- divergencia `0 0`;
- worktree limpio.

La baseline concreta deberá ser la vigente y expresamente autorizada en el momento futuro de ejecución; esta especificación no fija por adelantado un SHA que podría quedar obsoleto por su propia canonicalización.

---

## 20.2 Verificar numeración/canonicalización

Confirmar la existencia de:

```text
docs/tasks/CORR-007-adr-0003-accepted-state-sync.md
```

una vez canonicalizada.

Confirmar que no existe colisión documental de ID.

---

## 20.3 Lectura obligatoria

Leer íntegramente:

```text
docs/tasks/CORR-007-adr-0003-accepted-state-sync.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

y las fuentes `NO CHANGE REQUIRED` necesarias para la auditoría.

---

## 20.4 Auditoría antes de modificar

Ejecutar búsquedas read-only de §17.

Clasificar todas las coincidencias materiales.

Si aparece un `ACTIVE STALE REFERENCE` adicional fuera del scope exacto:

`BLOCKER`

---

## 20.5 Aplicación

Aplicar únicamente los reemplazos exactos de §§9–10.

No reformular lateralmente.

---

## 20.6 Verificación

Ejecutar:

- auditoría post-cambio;
- diff completo de `10`;
- diff completo de `11`;
- `git diff --name-only`;
- `git diff --check`;
- AC-001…AC-105.

---

# 21. Procedimiento futuro de revisión humana

Después de una futura ejecución documental:

1. revisar íntegramente ambos diffs;

2. confirmar que ADR-0003 canónico no fue modificado;

3. confirmar que sólo `10` y `11` cambiaron;

4. comprobar AC-001…AC-105;

5. confirmar distribución `7 / 0 / 8 / 3`;

6. confirmar que no queda `READY TO DRAFT` activo para ADR-0003;

7. confirmar que toda historia previa permanece intacta;

8. confirmar DO-T03 intacto;

9. confirmar DO-075 intacta;

10. confirmar ADR-0004 intacto;

11. confirmar seguridad/multitenancy intactos;

12. confirmar que la fila Auth continúa `NO PERMITIDO TODAVÍA`;

13. confirmar que la razón ya no utiliza la falsa premisa “ADR-0003 aún no está aceptado”;

14. confirmar que el Gate de Fase 2 no fue evaluado;

15. confirmar que el Gate no fue declarado satisfecho;

16. confirmar que Fase 2 no fue iniciada;

17. aprobar o devolver CORR-007.

---

# 22. Gate posterior

Después de completar la secuencia:

1. aprobación humana de CORR-007;
2. canonicalización;
3. autorización humana separada de ejecución;
4. ejecución documental;
5. verificación;
6. revisión humana del diff;
7. incorporación Git;

el estado deberá ser:

```text
ADR-0003 = ACCEPTED

Sincronización documental de ADR-0003 ACCEPTED = COMPLETADA

Gate de entrada a Fase 2 evaluado = NO

Gate de entrada a Fase 2 satisfecho = NO

Fase 2 = NO INICIADA
```

Sólo después podrá realizarse, mediante **otro acto separado**, la evaluación formal del Gate de entrada a Fase 2.

CORR-007 no anticipa el resultado de esa evaluación.

---

# 23. Estado previsto post-CORR-007

Después de una futura ejecución, revisión e incorporación aprobadas:

`ADR-0003 = ACCEPTED`

`ADR-0003 canonicalizado = SÍ`

`ADR-0003 incorporado canónicamente a Git = SÍ`

`Sincronización documental de ADR-0003 ACCEPTED = COMPLETADA`

`DO-T03 = RESUELTO/APROBADO`

`Implementación autorizada por ADR-0003 = NO`

`Gate de entrada a Fase 2 evaluado = NO`

`Gate de entrada a Fase 2 satisfecho = NO`

`Fase 2 = NO INICIADA`

---

# 24. Metadata final

**ID:** `CORR-007`

**Título:** `CORR-007 — Sincronización documental de ADR-0003 = ACCEPTED`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega aprobado:**

`CORR-007-adr-0003-accepted-state-sync-approved.md`

**Ruta canónica futura:**

`docs/tasks/CORR-007-adr-0003-accepted-state-sync.md`

**Documentos `CHANGE REQUIRED`:**

```text
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
```

**Fuente arquitectónica principal `NO CHANGE REQUIRED`:**

```text
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

**Otros documentos inicialmente `NO CHANGE REQUIRED`:**

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/tasks/CORR-005-do-t03-rf019-document-sync.md
docs/tasks/CORR-006-do-t03-closure-state-sync.md
docs/tasks/TASK-007-phase-1-smoke-docs-review.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md
```

**ADR-0003 modificado:** `NO`

**Decisión arquitectónica modificada:** `NO`

**DO-T03 modificado:** `NO`

**DO-075 modificada:** `NO`

**ADR-0004 modificado/resuelto:** `NO`

**Auth implementada:** `NO`

**Schema diseñado:** `NO`

**SQL:** `NO`

**Migrations:** `NO`

**RLS ejecutable:** `NO`

**Storage implementado:** `NO`

**Provider primitive seleccionada:** `NO`

**Ejecución realizada:** `NO`

**Gate de Fase 2 evaluado:** `NO`

**Gate de Fase 2 satisfecho:** `NO`

**Fase 2 iniciada:** `NO`

**Repositorio modificado durante esta aprobación documental:** `NO`

**Codex utilizado:** `NO`

**Especificación aprobada para futura implementación documental:** `SÍ`

**Ejecución concreta autorizada:** `NO`

---

`CORR-007 = APPROVED FOR IMPLEMENTATION`

`Ejecución realizada = NO`

`ADR-0003 = ACCEPTED`

`ADR-0003 canonicalizado = SÍ`

`ADR-0003 incorporado canónicamente a Git = SÍ`

`Sincronización documental de ADR-0003 ACCEPTED = PENDIENTE`

`DO-T03 = RESUELTO/APROBADO`

`Implementación autorizada por ADR-0003 = NO`

`Gate de entrada a Fase 2 evaluado = NO`

`Gate de entrada a Fase 2 satisfecho = NO`

`Fase 2 = NO INICIADA`
