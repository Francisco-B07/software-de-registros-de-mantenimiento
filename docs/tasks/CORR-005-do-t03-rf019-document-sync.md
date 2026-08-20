# CORR-005 — Sincronización documental de RF-019 / DO-T03

## 1. Identificación

**ID:** `CORR-005`

**Título:** `CORR-005 — Sincronización documental de RF-019 / DO-T03`

**Tipo:** corrección documental controlada de requisito de producto/seguridad ya aprobado.

**Archivo de entrega aprobado:**

`CORR-005-do-t03-rf019-document-sync-approved.md`

**Ruta canónica futura:**

`docs/tasks/CORR-005-do-t03-rf019-document-sync.md`

**Archivo creado durante esta aprobación documental:** `NO EN EL REPOSITORIO`

**Implementación/cambios aplicados durante esta aprobación documental:** `NO`

Esta especificación materializa exclusivamente la decisión humana ya aprobada de reformular `RF-019 / DO-T03`.

`CORR-005 = APPROVED FOR IMPLEMENTATION`

Este estado significa únicamente que la especificación documental ha sido aprobada como contrato para una futura ejecución.

No significa que una ejecución concreta esté autorizada.

---

## 2. Estado

`CORR-005 = APPROVED FOR IMPLEMENTATION`

Estado canónico consumido:

`Fase 1 = COMPLETADA`

`Paso 9 autorizado = SÍ`

`Paso 9 iniciado = SÍ`

`APROBACIÓN DE REFORMULACIÓN DE DO-T03 = SÍ`

`Consulta técnica a Supabase = CANCELADA / NO REQUERIDA`

`Consulta técnica a Supabase enviada = NO`

`Cambios documentales de CORR-005 aplicados = NO`

`DO-T03 = PARCIALMENTE ABIERTO`

`DO-T03 resuelto = NO`

`ADR-0003 = BLOCKED BY DO-T03`

`ADR-0003 redactado = NO`

`ADR-0003 modificado = NO`

`ADR-0003 ACCEPTED = NO`

`Gate de entrada a Fase 2 satisfecho = NO`

`Fase 2 = NO INICIADA`

---

# 3. Contexto

La baseline normativa actual contiene todavía wording anterior a la decisión humana que reformuló `DO-T03`.

En particular, `RF-019` continúa exigiendo literalmente que al deshabilitar o revocar un usuario sus sesiones activas **DEBAN cerrarse automáticamente**.

`03-permissions-rls-strategy.md` repite esa semántica: §19.5 declara que la baseline exige cerrar sesiones activas y §32.1 todavía registra como decisión cerrada de producto que “deshabilitar/revocar debe cerrar sesiones”.

`04-offline-sync-strategy.md` hereda esa misma interpretación en `DO-T03`.

La decisión humana posterior modificó materialmente esa baseline:

1. **revocación efectiva de autorización** pasa a ser la garantía fuerte e incondicional;
2. **terminación provider-side de sesiones/credenciales renovables** continúa siendo defense in depth, pero sólo mediante primitivas públicas, soportadas y contractualmente adecuadas;
3. ausencia, limitación o fallo de esa segunda defensa nunca restaura autorización;
4. un JWT o sesión residual no conserva autorización;
5. no se adoptan internals ni workarounds no aprobados.

CORR-005 existe para eliminar exclusivamente el drift documental producido por esa decisión posterior.

---

# 4. Problema documental

La reformulación ya está aprobada humanamente, pero todavía no está incorporada a las fuentes normativas.

Esto genera actualmente tres clases de inconsistencia:

### 4.1 Garantía de producto obsoleta

`RF-019` continúa prometiendo cierre automático incondicional de sesiones.

### 4.2 Documentos derivados obsoletos

`02`, `03` y `04` todavía consumen esa garantía absoluta.

### 4.3 Registro arquitectónico todavía no contextualizado

`10-architecture-decisions-records.md` conserva correctamente:

`DO-T03 = PARCIALMENTE ABIERTO`

y:

`ADR-0003 = BLOCKED BY DO-T03`

pero la descripción futura del ámbito de ADR-0003 debe consumir la nueva separación entre autorización y terminación provider-side. El registro actual todavía incluye “invalidación efectiva de sesiones” como parte indiferenciada del futuro ADR.

---

# 5. Decisión humana ya aprobada

CORR-005 **NO decide** la siguiente política. La consume como decisión anterior ya aprobada.

## 5.1 Garantía A — Revocación efectiva de autorización

Una revocación, deshabilitación o reducción de alcance debe retirar inmediatamente toda autorización online afectada mediante estado autoritativo vigente.

Una sesión Auth o access JWT residual:

- puede seguir existiendo técnicamente;
- no conserva membership;
- no conserva rol;
- no conserva client scope;
- no conserva `SupportAccessGrant`;
- no conserva ninguna autorización revocada.

La seguridad no puede esperar:

- logout;
- destrucción de sesión;
- refresh;
- `exp`.

## 5.2 Garantía B — Terminación provider-side

La terminación de sesiones y credenciales renovables continúa siendo una defensa adicional.

Debe utilizarse una primitiva:

- pública;
- soportada;
- contractualmente adecuada;

cuando exista una apropiada para el caso.

Su ausencia, limitación o fallo:

- no restaura autorización;
- no habilita acceso;
- no provoca rollback;
- no autoriza internals ni workarounds no aprobados.

## 5.3 Prohibiciones consumidas

No seleccionar por inferencia:

- `updateUserById(...password...)`;
- mutación directa de `auth.sessions`;
- almacenamiento de JWT ajenos;
- APIs no documentadas;
- internals de Supabase;
- `ban_duration` como equivalente contractual de global sign-out.

---

# 6. Objetivo

Aplicar, en una futura ejecución separadamente autorizada, el conjunto **mínimo, exacto y auditable de modificaciones documentales** necesario para que las fuentes canónicas vigentes reflejen la reformulación humana aprobada.

CORR-005 debe conseguir simultáneamente:

1. eliminar garantías provider-side absolutas ya sustituidas;
2. preservar y reforzar la revocación autoritativa inmediata;
3. preservar RLS como frontera primaria;
4. documentar fail-closed;
5. preservar defense in depth sin inventar una primitiva Supabase;
6. mantener `DO-T03 = PARCIALMENTE ABIERTO` durante la ejecución;
7. mantener `ADR-0003` bloqueado hasta revisión humana posterior;
8. preservar decisiones offline no relacionadas;
9. no introducir ninguna implementación.

---

# 7. Alcance

CORR-005 es exclusivamente:

`DOCUMENTACIÓN`

La futura ejecución podrá modificar únicamente, si se autoriza separadamente su ejecución:

1. `docs/product/01-product-definition.md`
2. `docs/product/02-domain-model.md`
3. `docs/product/03-permissions-rls-strategy.md`
4. `docs/product/04-offline-sync-strategy.md`
5. `docs/product/10-architecture-decisions-records.md`

La inclusión de `02-domain-model.md` es necesaria porque §6.5 todavía contiene la regla activa “sesiones activas deben cerrarse”, por lo que existe incompatibilidad real con la reformulación.

---

# 8. Fuera de alcance

CORR-005 no puede:

- implementar Auth;
- configurar Auth;
- implementar revocación;
- crear schema;
- crear migrations;
- diseñar tablas;
- diseñar columnas;
- diseñar RLS físico;
- escribir SQL;
- definir policies;
- definir claims;
- definir custom claims;
- seleccionar TTL;
- definir validación física de `session_id`;
- seleccionar una API Supabase;
- utilizar `service-role`;
- definir Server Actions;
- definir Route Handlers;
- definir endpoints;
- definir UX final;
- implementar logout;
- definir storage local;
- modificar `DO-T04`;
- resolver `OFF-OPEN-001`;
- resolver `OFF-OPEN-002`;
- modificar `DO-075`;
- redactar ADR-0003;
- modificar ADR-0003;
- aprobar ADR-0003;
- evaluar como satisfecho el Gate de Fase 2;
- iniciar Fase 2.

---

# 9. Fuentes canónicas

## 9.1 Fuentes que requieren modificación

- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/04-offline-sync-strategy.md`
- `docs/product/10-architecture-decisions-records.md`

## 9.2 Fuentes revisadas que no requieren modificación

- `docs/product/11-phase-1-scope-entry-gate.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`

`11-phase-1-scope-entry-gate.md` sigue siendo coherente: exige que `DO-T03` se resuelva documentalmente antes de ADR-0003 y mantiene ADR-0003 como requisito anterior a Fase 2, sin imponer por sí mismo la garantía absoluta que se está sustituyendo.

---

# 10. Cambios exactos — `01-product-definition.md`

La fuente normativa principal contiene varias referencias activas incompatibles, no sólo `RF-019`. Dejarlas sin cambio produciría contradicción interna dentro del mismo documento.

## 10.1 `RF-019`

### Texto vigente

```markdown
**RF-019.** Al deshabilitar o revocar un usuario, sus sesiones activas DEBEN cerrarse automáticamente.
```

### Texto final propuesto

```markdown
**RF-019.** Al deshabilitar, revocar o reducir el alcance de un usuario, toda autorización online afectada DEBE retirarse inmediatamente utilizando estado autoritativo vigente. Una sesión Auth o access JWT residual NO DEBE conservar ninguna autorización revocada. Cuando exista una primitiva pública, soportada y contractualmente adecuada para el caso, las sesiones y credenciales renovables afectadas DEBEN terminarse mediante ese mecanismo como defensa adicional; su ausencia, limitación o fallo NO DEBE restaurar autorización ni debilitar la protección de datos.
```

### Clasificación

`MATERIAL REQUIREMENT CHANGE`

Este cambio no debe presentarse como corrección editorial.

---

## 10.2 `FL-03 — Deshabilitación y reintegración`, paso 2

### Texto vigente

```markdown
2. Las sesiones activas se cierran automáticamente.
```

### Texto final propuesto

```markdown
2. Toda autorización online afectada se revoca inmediatamente según el estado autoritativo vigente; una sesión Auth o access JWT residual no conserva permisos revocados, y la terminación provider-side de sesiones/credenciales renovables se ejecuta mediante una primitiva pública soportada cuando exista una contractualmente adecuada para el caso, sin que su ausencia o fallo restaure autorización.
```

Los restantes pasos de `FL-03` permanecen sin cambios.

### Clasificación

`WORDING SYNCHRONIZATION`

---

## 10.3 §21.2 — Revocación

### Texto vigente

```markdown
La deshabilitación de usuario debe provocar cierre de sesiones activas. El usuario no se elimina y puede reintegrarse.

La implementación concreta de invalidación de sesiones, tokens y cachés se definirá en el documento de seguridad/RLS de Fase 0 sin debilitar esta regla de producto.
```

### Texto final propuesto

```markdown
La deshabilitación, revocación o reducción de alcance debe retirar inmediatamente toda autorización online afectada mediante estado autoritativo vigente. Una sesión Auth o access JWT residual no conserva autorización revocada. El usuario no se elimina y puede reintegrarse.

La terminación provider-side de sesiones y credenciales renovables constituye una defensa adicional y debe utilizar exclusivamente mecanismos públicos, soportados y contractualmente adecuados cuando exista una primitiva apropiada para el caso. La seguridad de datos no puede depender de esa terminación ni esperar logout, refresh o expiración del access JWT. Su ausencia, limitación o fallo no restaura autorización.
```

### Clasificación

`MATERIAL REQUIREMENT CHANGE`

---

## 10.4 `RSK-004`

### Texto vigente

```markdown
| RSK-004 | Revocación no corta sesiones efectivamente | Crítica | bloqueo por membresía/RLS online + revocación de sesión; autorización offline de identidad limitada a un máximo de 7 días desde la última validación online conforme a DO-075 aprobado |
```

### Texto final propuesto

```markdown
| RSK-004 | Revocación no corta autorización efectivamente | Crítica | estado autoritativo vigente + RLS/autorización online como frontera primaria; una sesión/JWT residual no conserva permisos revocados; terminación provider-side sólo mediante mecanismos públicos soportados cuando sean aplicables y sin rollback de autorización ante ausencia o fallo; autorización offline limitada conforme a DO-075 aprobado |
```

### Clasificación

`WORDING SYNCHRONIZATION`

---

## 10.5 §26.2 — `DO-T03`

### Texto vigente

```markdown
**DO-T03 — Invalidación efectiva de sesiones. PARCIALMENTE PROPUESTO.** Online: membresía/estado debe bloquear acceso en RLS aunque exista token, más revocación de sesión/credenciales renovables. Offline: DO-075 ya fija la política de producto aprobada de máximo 7 días y revalidación; la implementación técnica debe respetarla.
```

### Texto final propuesto

```markdown
**DO-T03 — Invalidación efectiva de sesiones. PARCIALMENTE ABIERTO.** Online: una revocación, deshabilitación o reducción de alcance debe retirar inmediatamente toda autorización afectada mediante estado autoritativo vigente; una sesión Auth o access JWT residual no conserva membership, rol, client scope, `SupportAccessGrant` ni ninguna otra autorización revocada. La terminación provider-side de sesiones y credenciales renovables constituye una defensa adicional y debe utilizar únicamente mecanismos públicos, soportados y contractualmente adecuados cuando exista una primitiva apropiada para el caso; su ausencia, limitación o fallo no restaura autorización y no autoriza internals, APIs no documentadas ni workarounds no aprobados. Offline: DO-075 mantiene la política aprobada de máximo 7 días y revalidación; una revocación conocida prevalece y el trabajo ya capturado no se elimina. El cierre formal de DO-T03 permanece pendiente de revisión humana posterior a esta sincronización documental.
```

### Clasificación

`MATERIAL REQUIREMENT CHANGE` + `STATE SYNCHRONIZATION`

La sincronización de estado permitida aquí es únicamente:

`PARCIALMENTE PROPUESTO → PARCIALMENTE ABIERTO`

porque el estado canónico actual ya es `PARCIALMENTE ABIERTO`.

No puede convertirse en:

`RESUELTO/APROBADO`

durante CORR-005.

---

# 11. Cambios exactos — `02-domain-model.md`

## Evaluación

`CHANGE REQUIRED`

El modelo conceptual contiene una incompatibilidad real en §6.5:

```markdown
- sesiones activas deben cerrarse;
```

mientras el mismo modelo ya establece correctamente que una sesión autenticada no basta para acceso efectivo.

---

## 11.1 §6.5 — Deshabilitación

### Texto vigente

```markdown
## 6.5 Deshabilitación

Al deshabilitar una membership:

- identidad e historial permanecen;
- sesiones activas deben cerrarse;
- acceso online debe quedar bloqueado;
- datos offline siguen aislados;
- una autorización offline previamente validada sólo puede mantenerse dentro del máximo aprobado de 7 días;
- una revocación conocida debe aplicarse cuando el dispositivo recupera conectividad.
```

### Texto final propuesto

```markdown
## 6.5 Deshabilitación

Al deshabilitar o revocar una membership, o reducir su alcance:

- identidad e historial permanecen;
- toda autorización online afectada debe quedar revocada inmediatamente según el estado autoritativo vigente;
- una sesión Auth o access JWT residual no conserva membership, rol, client scope ni otra autorización revocada;
- la terminación provider-side de sesiones y credenciales renovables se trata como defensa adicional mediante mecanismos públicos soportados cuando exista una primitiva contractualmente adecuada; su ausencia o fallo no restaura autorización;
- datos offline siguen aislados;
- una autorización offline previamente validada sólo puede mantenerse dentro del máximo aprobado de 7 días;
- una revocación conocida debe aplicarse cuando el dispositivo recupera conectividad.
```

### Clasificación

`WORDING SYNCHRONIZATION`

No cambia entidades, relaciones ni lifecycle.

---

## 11.2 §29.1 — fila `DO-T03`

### Texto vigente

```markdown
| `DO-T03` | Falta especificar invalidación técnica efectiva online; la política offline ya está cerrada. | No | Antes de Fase 2 para seguridad online; coordinación offline antes de Fase 5 |
```

### Texto final propuesto

```markdown
| `DO-T03` | La reformulación de producto/seguridad ya fue aprobada: la revocación efectiva de autorización es inmediata y la terminación provider-side es una defensa adicional condicionada a mecanismos públicos soportados. Permanece pendiente el cierre formal de DO-T03 tras la sincronización documental y su revisión humana. | No | Antes de Fase 2 para seguridad online; coordinación offline antes de Fase 5 |
```

### Clasificación

`STATE SYNCHRONIZATION`

---

# 12. Cambios exactos — `03-permissions-rls-strategy.md`

El documento actualmente distingue correctamente autenticación de autorización y exige estado autoritativo, pero §19.5 y §32.1 todavía conservan la garantía absoluta anterior.

---

## 12.1 §19.5 — Sesiones activas

### Texto vigente completo a sustituir

```markdown
## 19.5 Sesiones activas

La baseline exige que deshabilitar o revocar un usuario cierre sus sesiones activas.

La política de producto está cerrada.

El mecanismo técnico exacto continúa parcialmente abierto mediante `DO-T03`.

### Propuesta técnica para `DO-T03` — **PENDIENTE DE APROBACIÓN**

Se propone tratar el problema mediante dos defensas complementarias:

1. **corte autoritativo de datos:** toda operación online sensible debe comprobar membership/rol/client access vigentes en la frontera de datos, de forma que una sesión antigua no conserve autorización sólo por contener estado previo;
2. **cierre de sesión:** utilizar el mecanismo técnico de Supabase Auth que finalmente se apruebe para invalidar/cerrar sesiones y credenciales renovables, de modo que la UX y el estado de autenticación también reflejen la revocación.

La segunda defensa no debe ser la única barrera.

El mecanismo concreto, sus tiempos y pruebas permanecen pendientes y no se declaran resueltos en este documento.
```

### Texto final propuesto

```markdown
## 19.5 Revocación efectiva de autorización y sesiones provider-side

La baseline reformulada distingue dos defensas complementarias con garantías diferentes.

### Defensa primaria — revocación efectiva de autorización

Una revocación, deshabilitación o reducción de alcance debe retirar inmediatamente toda autorización online afectada mediante estado autoritativo vigente.

Toda operación online sensible debe evaluar según estado vigente, cuando corresponda:

- membership;
- rol;
- `UserClientAccess`;
- `SupportAccessGrant`;
- tenant y ownership;
- demás condiciones autoritativas aplicables.

Una sesión Auth o access JWT residual no conserva autorización revocada. La seguridad no puede depender de esperar logout, refresh o `exp`.

### Defensa adicional — terminación provider-side

Las sesiones y credenciales renovables afectadas deben terminarse mediante mecanismos públicos, soportados y contractualmente adecuados cuando exista una primitiva apropiada para el caso.

Esta segunda defensa:

- no es la frontera primaria de datos;
- no puede reemplazar RLS/autorización vigente;
- no puede provocar rollback de una revocación si falla o no está disponible;
- no autoriza utilizar `updateUserById(...password...)`, mutación directa de `auth.sessions`, almacenamiento de JWT ajenos, APIs no documentadas ni internals por inferencia;
- no permite tratar `ban_duration` como equivalente contractual de global sign-out sin una decisión posterior basada en un contrato soportado.

La reformulación de producto/seguridad fue aprobada humanamente. `DO-T03` permanece `PARCIALMENTE ABIERTO` únicamente hasta completar esta sincronización documental y realizar la revisión humana posterior requerida para evaluar su cierre formal.
```

### Clasificación

`MATERIAL REQUIREMENT CHANGE` + `WORDING SYNCHRONIZATION`

---

## 12.2 §22.2 — Sesiones

### Evaluación

`NO CHANGE REQUIRED`

Texto vigente:

```markdown
El cierre forzado/revocación de sesiones probablemente requiere una operación server-side privilegiada.

Su mecanismo exacto permanece en `DO-T03`.
```

La sección no afirma que el cierre provider-side sea la frontera primaria ni adopta una primitiva concreta.

Durante CORR-005 no debe modificarse.

---

## 12.3 §26.8 — Usuarios deshabilitados

### Texto vigente relevante

```markdown
La comprobación concreta de cierre de sesión se probará además según `DO-T03`.
```

### Texto final propuesto

```markdown
La revocación efectiva de autorización debe probarse aunque una sesión Auth o access JWT residual continúe técnicamente presente. Cuando exista y se adopte posteriormente un mecanismo provider-side público y soportado para terminar sesiones/credenciales renovables, su comportamiento debe probarse por separado como defensa adicional; su fallo o indisponibilidad no puede convertir una operación revocada en autorizada.
```

### Clasificación

`WORDING SYNCHRONIZATION`

---

## 12.4 §30 — `ADR-CAND-SEC-06`

### Evaluación

`NO CHANGE REQUIRED`

El candidato:

`ADR-CAND-SEC-06 — Invalidación efectiva de sesiones`

sigue siendo trazable al mismo `DO-T03`, y su motivo actual —impacto en Auth, RLS, revocación, UX y sincronización— sigue siendo correcto.

No se crea otro candidato ni otro ADR.

Su semántica futura será consumida por ADR-0003 después de resolver formalmente DO-T03.

---

## 12.5 §31.1 — `RSK-004`

### Texto vigente

```markdown
### `RSK-004` — Revocación no corta sesiones

Tratamiento:

- membership autoritativa online;
- revocación de sesión;
- `DO-T03`;
- DO-075 para offline.
```

### Texto final propuesto

```markdown
### `RSK-004` — Revocación no corta autorización efectivamente

Tratamiento:

- membership, rol, client access y grants vigentes como estado autoritativo online;
- RLS/autorización vigente como frontera primaria de datos;
- una sesión Auth o access JWT residual no conserva autorización revocada;
- terminación provider-side únicamente mediante mecanismos públicos soportados cuando sean aplicables;
- fallo o inexistencia de esa segunda defensa no produce rollback de autorización;
- `DO-T03`;
- DO-075 para offline.
```

### Clasificación

`WORDING SYNCHRONIZATION`

No se crea un riesgo nuevo; se sincroniza el riesgo ya existente.

---

## 12.6 §31.2 — riesgos derivados

### Evaluación

`NO CHANGE REQUIRED`

En particular:

- `SEC-RSK-001` ya exige estado autoritativo vigente;
- `SEC-RSK-007` ya impide que una suspensión aplicada sólo en UI sea suficiente;
- `SEC-RSK-008` ya separa revocación remota de borrado local.

Añadir un nuevo `SEC-RSK-*` sería redundante y no es necesario para materializar la decisión aprobada.

---

## 12.7 §32.1 — `DO-T03`

### Texto vigente completo del bloque DO-T03

```markdown
### `DO-T03` — Invalidación efectiva de sesiones

**Estado:** PARCIALMENTE ABIERTO.

**Cerrado a nivel de producto:**

- deshabilitar/revocar debe cerrar sesiones;
- acceso online debe quedar bloqueado;
- DO-075 define el comportamiento offline.

**Pendiente:**

- mecanismo concreto de invalidación en Supabase Auth;
- coordinación de tokens/sesiones;
- tratamiento técnico del cliente tras la revocación;
- pruebas específicas de invalidación.

**Propuesta de este documento:** defensa doble de corte autoritativo de datos + cierre de sesión.

**Estado de la propuesta:** **PENDIENTE DE APROBACIÓN**.

**Bloquea el siguiente documento `04`:** no.

**Debe resolverse antes de:** Fase 2 para implementación de identidad/autorización online, coordinando sus implicaciones offline antes de Fase 5.
```

### Texto final propuesto

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

### Clasificación

`MATERIAL REQUIREMENT CHANGE` + `STATE SYNCHRONIZATION`

---

# 13. Cambios exactos — `04-offline-sync-strategy.md`

DO-075 permanece `RESUELTA/APROBADA` con máximo de siete días, revalidación, aplicación de revocación conocida y preservación del trabajo capturado. Ese contenido no puede modificarse.

---

## 13.1 §53.2 — `DO-T03`

### Texto vigente

```markdown
## 53.2 DO-T03 — Invalidación efectiva de sesiones

**Estado:** **PARCIALMENTE ABIERTO**.

Cerrado a nivel de producto:

- revocar/deshabilitar debe cerrar sesiones;
- acceso online debe quedar bloqueado;
- DO-075 gobierna offline.

Propuesta heredada de `03`:

- corte autoritativo de datos;
- cierre efectivo de sesión/credenciales renovables.

**Estado de la propuesta:** **PENDIENTE DE APROBACIÓN**.

Este documento no la resuelve.

**Bloquea Fase 1:** no como documento, pero debe resolverse antes de implementar Fase 2; sus implicaciones offline deben estar coordinadas antes de Fase 5.
```

### Texto final propuesto

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

### Clasificación

`MATERIAL REQUIREMENT CHANGE` + `STATE SYNCHRONIZATION`

---

## 13.2 §54.4 — Estado de DO-T03

### Texto vigente

```markdown
**DO-T03: PARCIALMENTE ABIERTO.**

La propuesta técnica de corte autoritativo de datos + cierre efectivo de sesión continúa:

**PENDIENTE DE APROBACIÓN.**

No se resuelve en este documento.
```

### Texto final propuesto

```markdown
**DO-T03: PARCIALMENTE ABIERTO.**

La reformulación aprobada distingue:

- revocación inmediata y autoritativa de la autorización online como garantía fuerte;
- terminación provider-side de sesiones/credenciales renovables como defensa adicional condicionada a mecanismos públicos soportados y contractualmente adecuados.

La reformulación queda sincronizada documentalmente mediante CORR-005, pero el cierre formal de `DO-T03` continúa pendiente de revisión humana separada posterior a esta corrección.

No se resuelve automáticamente por la ejecución de CORR-005.
```

### Clasificación

`STATE SYNCHRONIZATION`

---

## 13.3 Otras referencias de revocación en `04`

### Evaluación

`NO CHANGE REQUIRED`

Las restantes referencias activas a:

- revocación conocida;
- cliente revocado;
- bloqueo de operaciones remotas;
- preservación de trabajo;
- revalidación;
- no borrado de outbox;

ya son compatibles con la nueva baseline.

No deben reescribirse.

---

# 14. Cambios exactos — `10-architecture-decisions-records.md`

## 14.1 Registro `DO-T03` en §5.1

### Evaluación durante CORR-005

`NO STATE CHANGE`

Debe permanecer:

`DO-T03 = PARCIALMENTE ABIERTO`

No puede cambiar todavía a:

`RESUELTA/APROBADA`.

---

## 14.2 Registro de ADR-0003 / matriz de ADR

### Evaluación

`NO STATE CHANGE`

Debe mantenerse:

- dependencia abierta: `DO-T03`;
- estado: `BLOCKED BY OPEN DECISIONS`.

---

## 14.3 §9 — alcance futuro de ADR-0003

### Wording vigente relevante

```markdown
- revocación;
- invalidación efectiva de sesiones;
- relación entre autorización online y el posterior contexto offline.
```

### Texto final propuesto

```markdown
- revocación efectiva de autorización mediante estado autoritativo vigente;
- separación entre autenticación residual y autorización vigente;
- tratamiento provider-side de sesiones y credenciales renovables conforme a la semántica aprobada de DO-T03, exclusivamente mediante mecanismos públicos, soportados y contractualmente adecuados cuando corresponda;
- comportamiento fail-closed ante ausencia o fallo de la terminación provider-side;
- relación entre autorización online y el posterior contexto offline.
```

### Clasificación

`WORDING SYNCHRONIZATION`

Este cambio sincroniza únicamente el alcance futuro de ADR-0003 con una decisión de producto/seguridad ya aprobada.

No redacta ADR-0003.

No modifica ADR-0003.

No cambia su estado.

---

## 14.4 §29 — ADRs bloqueados

### Evaluación

`NO CHANGE REQUIRED`

Debe seguir exactamente en estado equivalente a:

```markdown
## `ADR-0003`

**Estado:** `BLOCKED BY OPEN DECISIONS`

Bloqueador:

- `DO-T03`.
```

La corrección documental no puede retirar ese blocker.

---

## 14.5 Cambios expresamente diferidos en `10`

Sólo después de:

1. ejecutar CORR-005;
2. verificar su diff;
3. completar revisión humana;
4. decidir separadamente:
   `DO-T03 = RESUELTO/APROBADO`;

podrá evaluarse una posterior sincronización de:

- estado de `DO-T03`;
- lista de dependencias abiertas de ADR-0003;
- estado apropiado de ADR-0003 para permitir su futura redacción.

Durante CORR-005 permanecen sin modificación:

- estados de §5.1;
- estados de la matriz de ADR;
- §29;
- `ADR-0003 = BLOCKED BY DO-T03`.

CORR-005 **no prescribe ni aplica** todavía ese estado futuro.

---

# 15. Documentos revisados sin cambio

## 15.1 `docs/product/11-phase-1-scope-entry-gate.md`

`NO CHANGE REQUIRED`

Justificación:

El documento establece:

- que DO-T03 debe resolverse documentalmente;
- que ADR-0003 permanece pendiente;
- que ADR-0003 debe aprobarse antes de Fase 2;
- que no puede resolverse DO-T03 por implementación.

Nada de ello contradice la reformulación.

Además, parte de su contenido cumple función histórica de Gate de Fase 1 y no debe reescribirse para “parecer actual”.

---

## 15.2 `ADR-0002-multitenancy-tenant-isolation.md`

`NO CHANGE REQUIRED`

Justificación:

ADR-0002:

- mantiene RLS como frontera autoritativa;
- deja reglas de rol, client access, soporte, revocación y sesiones principalmente a ADR-0003;
- no decide el mecanismo de invalidación;
- no depende de DO-T03 para su decisión base.

Por tanto, la reformulación es compatible con el ADR aceptado y no modifica su decisión.

---

## 15.3 `ADR-0005-sync-idempotency-conflicts.md`

`NO CHANGE REQUIRED`

Justificación:

ADR-0005 conserva expresamente DO-T03 fuera de su decisión nuclear y sólo requiere que la autorización sea revalidada antes de aplicar operaciones remotas.

La referencia:

`mecanismo de invalidación efectiva de sesiones (DO-T03)`

sirve como identificación histórica de la decisión abierta y no establece una garantía provider-side propia.

Modificar un ADR `ACCEPTED` sólo por actualizar una etiqueta histórica sería innecesario.

---

# 16. Matriz de impacto

| Archivo | Sección | Wording/estado vigente | Problema | Cambio exacto propuesto | Motivo | Tipo | Dependencia | Riesgo si no se modifica |
|---|---|---|---|---|---|---|---|---|
| `01-product-definition.md` | RF-019 | cierre automático absoluto de sesiones | contradice decisión humana posterior | §10.1 | sincronizar requisito normativo principal | `MATERIAL REQUIREMENT CHANGE` | reformulación aprobada | baseline promete capacidad provider-side no garantizada |
| `01-product-definition.md` | FL-03 paso 2 | sesiones se cierran automáticamente | flujo contradice RF-019 reformulado | §10.2 | coherencia interna | `WORDING SYNCHRONIZATION` | RF-019 | comportamiento funcional ambiguo |
| `01-product-definition.md` | §21.2 | cierre de sesión como regla no debilitables | contradice nueva garantía primaria | §10.3 | sincronizar seguridad | `MATERIAL REQUIREMENT CHANGE` | RF-019/DO-T03 | dos contratos de seguridad incompatibles |
| `01-product-definition.md` | RSK-004 | riesgo principal = no cortar sesión | prioriza control equivocado | §10.4 | riesgo debe reflejar autorización efectiva | `WORDING SYNCHRONIZATION` | reformulación | mitigación incompleta |
| `01-product-definition.md` | §26.2 DO-T03 | corte RLS + revocación sesión sin nueva semántica | definición obsoleta | §10.5 | incorporar reformulación y estado real | `MATERIAL REQUIREMENT CHANGE` | decisión humana | DO-T03 sigue ambiguo |
| `02-domain-model.md` | §6.5 | sesiones activas deben cerrarse | incompatibilidad real | §11.1 | modelo debe consumir nuevo requisito | `WORDING SYNCHRONIZATION` | RF-019 | modelo contradice producto |
| `02-domain-model.md` | §29.1 DO-T03 | falta mecanismo técnico efectivo online | ya no describe correctamente el blocker | §11.2 | reflejar cierre documental pendiente | `STATE SYNCHRONIZATION` | CORR-005 | decisión aparece abierta por motivo sustituido |
| `03-permissions-rls-strategy.md` | §19.5 | cierre absoluto + propuesta pendiente | política ya reformulada | §12.1 | establecer defensa primaria/secundaria | `MATERIAL REQUIREMENT CHANGE` | RF-019 | estrategia contradice producto |
| `03-permissions-rls-strategy.md` | §26.8 | test específico de cierre | aceptación debe priorizar autorización | §12.3 | tests coherentes | `WORDING SYNCHRONIZATION` | DO-T03 | test exige garantía sustituida |
| `03-permissions-rls-strategy.md` | RSK-004 | revocación no corta sesiones | riesgo obsoleto | §12.5 | fail-closed/autorización | `WORDING SYNCHRONIZATION` | DO-T03 | modelo de amenaza equivocado |
| `03-permissions-rls-strategy.md` | §32.1 | cerrado: cerrar sesiones; mecanismo aún pendiente | contradice reformulación | §12.7 | sincronizar decisión abierta | `MATERIAL REQUIREMENT CHANGE` | revisión humana posterior | DO-T03 no podría cerrarse coherentemente |
| `04-offline-sync-strategy.md` | §53.2 | cierre obligatorio + propuesta pendiente | contradice reformulación aprobada | §13.1 | sincronizar offline | `MATERIAL REQUIREMENT CHANGE` | DO-T03 | offline consume regla obsoleta |
| `04-offline-sync-strategy.md` | §54.4 | propuesta pendiente de aprobación | la reformulación ya fue aprobada | §13.2 | estado documental correcto | `STATE SYNCHRONIZATION` | CORR-005 | Gate documental queda stale |
| `10-architecture-decisions-records.md` | §9 ADR-0003 | “invalidación efectiva de sesiones” indiferenciada | ámbito futuro no refleja nueva separación | §14.3 | preparar ADR futuro sin redactarlo | `WORDING SYNCHRONIZATION` | DO-T03 | ADR futuro podría reintroducir requisito obsoleto |
| `10-architecture-decisions-records.md` | estados DO-T03/ADR-0003 | abiertos/bloqueados | correcto | ninguno | debe preservarse hasta revisión posterior | `NO CHANGE` | revisión humana | desbloqueo prematuro |
| `11-phase-1-scope-entry-gate.md` | referencias DO-T03/ADR-0003 | DO-T03 debe resolverse antes de ADR | compatible/histórico | ninguno | preservar trazabilidad | `NO CHANGE` | Gate | reescritura histórica |
| ADR-0002 | autorización/RLS | delega revocación/sesión a ADR-0003 | compatible | ninguno | decisión ACCEPTED no afectada | `NO CHANGE` | ADR-0003 | cambio innecesario de ADR aceptado |
| ADR-0005 | §16.4 | DO-T03 fuera del núcleo | compatible | ninguno | decisión ACCEPTED no afectada | `NO CHANGE` | DO-T03 | cambio histórico innecesario |

---

# 17. Invariantes de seguridad obligatorias

Toda futura ejecución y revisión de CORR-005 debe verificar expresamente:

1. **autenticación no equivale a autorización**;

2. un access JWT o sesión residual nunca conserva autorización revocada;

3. membership, rol, client scope y `SupportAccessGrant` se evalúan mediante estado autoritativo vigente;

4. RLS/autorización vigente continúa como frontera primaria de datos;

5. ningún endpoint futuro puede utilizar exclusivamente:

   `user != null`

   como condición suficiente para autorizar una operación tenant;

6. una membership revocada debe dejar de autorizar requests posteriores aunque el JWT continúe técnicamente válido;

7. un `UserClientAccess` retirado debe dejar de autorizar el cliente afectado aunque el JWT sea stale;

8. una reducción de rol debe retirar sus capacidades inmediatamente;

9. un `SupportAccessGrant` revocado deja de autorizar solicitudes posteriores;

10. fallo o inexistencia de terminación provider-side no provoca rollback;

11. la revocación permanece fail-closed;

12. provider logout/session termination nunca es la única frontera de seguridad;

13. no se utiliza ninguna primitiva no aprobada;

14. no se mutan internals de Auth;

15. no se almacenan JWT de otros usuarios para revocarlos;

16. DO-075 continúa íntegramente vigente.

---

# 18. Impacto en RLS, Auth, cliente y tests

## 18.1 RLS

**Impacto conceptual:** reforzado, no reducido.

RLS debe seguir siendo frontera primaria para acceso remoto normal y debe operar coherentemente con estado autoritativo vigente.

CORR-005 no diseña:

- policies;
- SQL;
- funciones;
- tablas;
- claims.

---

## 18.2 Auth

Auth sigue identificando al sujeto.

No se convierte en fuente autoritativa exclusiva de:

- tenant;
- membership;
- rol;
- client access;
- soporte.

Una sesión residual puede representar:

`IDENTIDAD TÉCNICAMENTE AUTENTICADA`

pero no:

`AUTORIZACIÓN VIGENTE`

CORR-005 no selecciona mecanismo de terminación.

---

## 18.3 Cliente

La documentación futura deberá permitir diferenciar conceptualmente:

`authenticated`

de:

`authorized for current context`.

Cuando una revocación sea conocida:

- nuevas acciones online afectadas quedan bloqueadas;
- el cliente no debe seguir presentando capacidad operativa revocada;
- la terminación provider-side, cuando exista un mecanismo aprobado, puede actualizar también el estado Auth;
- trabajo offline ya capturado no se elimina.

No se diseña UI final.

---

## 18.4 Tests futuros obligatorios

CORR-005 debe dejar documentados, sin implementarlos:

```text
revoked membership + stale JWT
→ DENIED
```

```text
revoked client scope + stale JWT
→ DENIED
```

```text
reduced role + stale authorization state
→ capacidades retiradas DENIED
```

```text
revoked SupportAccessGrant + residual Auth
→ DENIED
```

```text
direct request bypassing UI
→ DENIED
```

```text
provider-side session termination unavailable/fails
→ autorización continúa DENIED
```

Estos tests pasan a ser pruebas primarias de la garantía de revocación.

---

# 19. Criterios de aceptación

CORR-005 sólo podrá considerarse correctamente ejecutada cuando se verifiquen todos los siguientes criterios:

1. `RF-019` refleja inequívocamente la reformulación aprobada.

2. El cambio material de `RF-019` queda visible y no se presenta como simple edición.

3. `FL-03` no promete ya cierre provider-side incondicional.

4. §21.2 no promete cierre provider-side incondicional.

5. `RSK-004` prioriza revocación efectiva de autorización.

6. §26.2 `DO-T03` refleja la distinción A/B aprobada.

7. `DO-T03` permanece `PARCIALMENTE ABIERTO`.

8. `02-domain-model.md` deja de afirmar que todas las sesiones necesariamente deben cerrarse.

9. `02-domain-model.md` conserva identidad/historial, aislamiento local y DO-075.

10. §19.5 de `03` diferencia inequívocamente autorización de terminación de sesión.

11. §32.1 de `03` deja de mantener como regla cerrada el cierre absoluto de sesiones.

12. `03` conserva RLS como frontera primaria.

13. `03` conserva fail-closed.

14. `03` conserva tests negativos.

15. `04` queda coherente con la reformulación.

16. `DO-075 = RESUELTA/APROBADA` permanece sin modificación.

17. El máximo de 7 días permanece intacto.

18. La revalidación offline permanece intacta.

19. Una revocación conocida sigue prevaleciendo.

20. El trabajo capturado continúa sin eliminarse automáticamente.

21. `DO-T04` no se resuelve.

22. `OFF-OPEN-001` no se resuelve.

23. `OFF-OPEN-002` no se resuelve.

24. No se selecciona mecanismo concreto de Supabase Auth.

25. No se adopta `updateUserById(...password...)`.

26. No se adopta `ban_duration` como global sign-out.

27. No se adopta mutación de `auth.sessions`.

28. No se almacenan JWT ajenos.

29. No se selecciona TTL.

30. No se define validación física de `session_id`.

31. No se diseña SQL.

32. No se diseñan policies RLS.

33. No se modifica ADR-0002.

34. No se modifica ADR-0005.

35. No se modifica `11-phase-1-scope-entry-gate.md`.

36. No se reabre Fase 1.

37. No se inicia Fase 2.

38. No se redacta ADR-0003.

39. No se modifica ADR-0003.

40. No se declara ADR-0003 `ACCEPTED`.

41. ADR-0003 permanece bloqueado por DO-T03.

42. No se introduce ninguna decisión nueva por inferencia.

43. Todos los cambios derivan directamente de la reformulación humana aprobada.

44. El diff está limitado a los cinco documentos autorizados.

45. El diff no contiene código ni configuración técnica.

46. No se modifican documentos históricos sin incompatibilidad real.

47. `git diff --check` no reporta errores.

48. Las búsquedas de wording obsoleto no encuentran las garantías absolutas sustituidas en los cinco documentos afectados, excepto cuando formen parte de contexto histórico expresamente preservado y revisado.

49. Los nuevos invariantes de seguridad aparecen coherentemente en producto y estrategia de permisos.

50. Tras ejecutar CORR-005 existe una revisión humana separada **antes** de evaluar:

   `DO-T03 = RESUELTO/APROBADO`.

---

# 20. Procedimiento de futura ejecución

La siguiente secuencia sólo podrá ejecutarse después de:

`CORR-005 = APPROVED FOR IMPLEMENTATION`

y una autorización humana separada y explícita para ejecutar CORR-005.

La aprobación de esta especificación **NO** autoriza por sí sola una ejecución concreta.

Antes de dicha ejecución deberá cumplirse además la incorporación/canonicalización conforme al workflow del proyecto cuando corresponda.

## 20.1 Preflight

Registrar como mínimo:

```text
git branch --show-current
git rev-parse HEAD
git rev-parse --abbrev-ref --symbolic-full-name @{u}
git rev-list --left-right --count HEAD...@{u}
git status --porcelain=v1 --untracked-files=all
```

Debe verificarse:

- repositorio válido;
- branch esperada;
- upstream conocido;
- divergencia conocida;
- worktree apto para distinguir exactamente el diff de CORR-005.

---

## 20.2 Verificación documental previa

Confirmar existencia y lectura de:

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md
docs/product/11-phase-1-scope-entry-gate.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md
```

Verificar que los textos vigentes que esta especificación pretende sustituir siguen materialmente presentes.

Si han cambiado por otra decisión canónica posterior:

`BLOCKER`

No adaptar silenciosamente CORR-005.

---

## 20.3 Aplicación

Modificar únicamente:

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md
```

Aplicar sólo los reemplazos aprobados en §§10–14.

No modificar:

```text
docs/product/11-phase-1-scope-entry-gate.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md
```

---

# 21. Procedimiento de verificación

## 21.1 Scope del diff

Ejecutar:

```text
git diff --name-only
```

Resultado esperado:

únicamente los cinco documentos autorizados.

Cualquier otro archivo:

`BLOCKER`

---

## 21.2 Calidad del diff

Ejecutar:

```text
git diff --check
```

Resultado esperado:

sin errores.

---

## 21.3 Revisión exacta del diff

Ejecutar:

```text
git diff -- docs/product/01-product-definition.md
git diff -- docs/product/02-domain-model.md
git diff -- docs/product/03-permissions-rls-strategy.md
git diff -- docs/product/04-offline-sync-strategy.md
git diff -- docs/product/10-architecture-decisions-records.md
```

Verificar:

- ningún cambio fuera de los reemplazos aprobados;
- ningún cambio técnico;
- ningún cambio de otro requisito;
- ningún cambio de permisos de mantenimiento;
- ninguna resolución accidental de decisiones abiertas.

---

## 21.4 Búsqueda de wording incompatible

Realizar búsquedas read-only de expresiones equivalentes a:

```text
sesiones activas DEBEN cerrarse automáticamente
sesiones activas se cierran automáticamente
deshabilitación de usuario debe provocar cierre de sesiones activas
deshabilitar/revocar debe cerrar sesiones
propuesta técnica de corte autoritativo de datos + cierre efectivo de sesión continúa PENDIENTE DE APROBACIÓN
```

Toda coincidencia activa debe revisarse.

No eliminar coincidencias históricas legítimas por automatismo.

---

## 21.5 Verificación de invariantes nuevas

Confirmar presencia documental inequívoca de:

- autorización inmediata;
- estado autoritativo vigente;
- JWT residual sin permisos;
- RLS/autorización primaria;
- terminación provider-side como defensa adicional;
- mecanismos públicos, soportados y contractualmente adecuados;
- fail-closed;
- prohibición de internals/workarounds;
- DO-075 intacta.

---

## 21.6 Verificación de estados

Confirmar después del diff:

`DO-T03 = PARCIALMENTE ABIERTO`

`DO-T03 resuelto = NO`

`ADR-0003 = BLOCKED BY DO-T03`

`ADR-0003 redactado = NO`

`ADR-0003 modificado = NO`

`ADR-0003 ACCEPTED = NO`

`Fase 2 = NO INICIADA`

---

# 22. Condiciones de BLOCKER

La futura ejecución debe detenerse y emitir `BLOCKER` si ocurre cualquiera de estas condiciones:

1. falta una fuente canónica obligatoria;

2. el contenido canónico vigente difiere materialmente del wording usado por CORR-005 debido a una decisión posterior no reconciliada;

3. una decisión posterior contradice la reformulación aprobada;

4. la corrección exige modificar un archivo fuera de la lista autorizada;

5. se descubre una incompatibilidad material adicional en ADR-0002 o ADR-0005;

6. se descubre que la corrección requiere cambiar el Gate histórico de Fase 1 para ser coherente;

7. no puede preservarse `DO-075` sin cambios;

8. aplicar la corrección requeriría resolver DO-T04, OFF-OPEN-001 u OFF-OPEN-002;

9. surge la necesidad de seleccionar TTL;

10. surge la necesidad de decidir `session_id`;

11. surge la necesidad de seleccionar una primitiva Supabase concreta;

12. surge la necesidad de diseñar RLS/SQL;

13. surge la necesidad de adoptar una API/internals no aprobada;

14. el diff contiene código o configuración;

15. el diff modifica ADR-0003;

16. el diff cambia el estado de ADR-0003;

17. el diff declara DO-T03 resuelto;

18. no puede demostrarse que todos los cambios derivan exclusivamente de la decisión humana aprobada.

Ante `BLOCKER`:

- no continuar;
- no completar parcialmente cambios adicionales;
- no resolver la contradicción por inferencia;
- documentar exactamente la causa para revisión humana.

---

# 23. Estado esperado después de ejecutar CORR-005

Incluso si todos los cambios documentales se aplican correctamente, el estado inmediato debe ser:

`Cambios documentales de CORR-005 aplicados = SÍ`

`Revisión humana posterior de CORR-005 = PENDIENTE`

`DO-T03 = PARCIALMENTE ABIERTO`

`DO-T03 resuelto = NO`

`ADR-0003 = BLOCKED BY DO-T03`

`ADR-0003 redactado = NO`

`ADR-0003 modificado = NO`

`ADR-0003 ACCEPTED = NO`

`Gate de entrada a Fase 2 satisfecho = NO`

`Fase 2 = NO INICIADA`

La ejecución técnica de CORR-005 **no equivale a cierre de DO-T03**.

---

# 24. Secuencia posterior obligatoria

Debe preservarse estrictamente:

1. incorporar/canonicalizar CORR-005 conforme al workflow del proyecto cuando corresponda;

2. emitir autorización humana separada y explícita para ejecutar CORR-005;

3. realizar el preflight definido por esta especificación;

4. aplicar únicamente la sincronización documental aprobada;

5. verificar scope y contenido del diff;

6. realizar revisión humana separada del resultado;

7. sólo entonces evaluar mediante decisión humana separada:

   `DO-T03 = RESUELTO/APROBADO`;

8. sólo si ese cierre es aprobado:
   - sincronizar formalmente el nuevo estado de DO-T03;
   - verificar expresamente el desbloqueo de ADR-0003;
   - determinar mediante proceso separado el siguiente estado documental apropiado de ADR-0003;

9. sólo después preparar:

   `ADR-0003`

   como entrega separada;

10. revisar/corregir/aprobar ADR-0003;

11. sólo después evaluar el Gate de entrada a Fase 2.

Ninguno de los puntos 1–11 queda autorizado para ejecución concreta por el mero estado:

`CORR-005 = APPROVED FOR IMPLEMENTATION`

---

# 25. Pasos explícitamente NO autorizados

Esta aprobación documental no autoriza:

- ejecutar CORR-005;
- modificar los cinco documentos;
- ejecutar Codex;
- hacer commit;
- hacer push;
- abrir PR;
- resolver DO-T03;
- modificar su estado canónico a `RESUELTO/APROBADO`;
- retirar el blocker de ADR-0003;
- redactar ADR-0003;
- modificar ADR-0003;
- aprobar ADR-0003;
- diseñar Auth;
- diseñar RLS físico;
- implementar Auth;
- implementar RLS;
- diseñar schema;
- crear migrations;
- iniciar Fase 2.

---

# 26. Metadata final

**ID:** `CORR-005`

**Título:** `CORR-005 — Sincronización documental de RF-019 / DO-T03`

**Estado:** `APPROVED FOR IMPLEMENTATION`

**Archivo de entrega aprobado:**

`CORR-005-do-t03-rf019-document-sync-approved.md`

**Ruta canónica futura:**

`docs/tasks/CORR-005-do-t03-rf019-document-sync.md`

**Naturaleza:** corrección documental controlada.

**Archivos cuya modificación se propone para futura ejecución:**

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
docs/product/04-offline-sync-strategy.md
docs/product/10-architecture-decisions-records.md
```

**Archivos revisados expresamente sin cambio:**

```text
docs/product/11-phase-1-scope-entry-gate.md
docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md
```

**Código:** `NO`

**Configuración técnica:** `NO`

**SQL:** `NO`

**Migrations:** `NO`

**RLS físico:** `NO`

**Supabase remoto:** `NO`

**ADR nuevo requerido por CORR-005:** `NO`

**ADR-0003 redactado/modificado:** `NO`

**Cambios documentales de CORR-005 aplicados:** `NO`

**Repositorio modificado durante esta aprobación documental:** `NO`

**Commit:** `NO`

**Push:** `NO`

**PR:** `NO`

**Especificación aprobada para futura implementación documental:** `SÍ`

**Ejecución concreta autorizada:** `NO`

---

`CORR-005 = APPROVED FOR IMPLEMENTATION`

`Cambios documentales de CORR-005 aplicados = NO`

`DO-T03 = PARCIALMENTE ABIERTO`

`DO-T03 resuelto = NO`

`ADR-0003 = BLOCKED BY DO-T03`

`ADR-0003 redactado = NO`

`ADR-0003 modificado = NO`

`ADR-0003 ACCEPTED = NO`

`Gate de entrada a Fase 2 satisfecho = NO`

`Fase 2 = NO INICIADA`
