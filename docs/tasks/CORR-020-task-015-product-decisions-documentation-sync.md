# CORR-020 — Sincronización normativa de DECISION-001..006 previa a implementación de TASK-015

## 1. Identificación

**ID:** `CORR-020`

**Título:** `CORR-020 — Sincronización normativa de DECISION-001..006 previa a implementación de TASK-015`

**Tipo:** `DOCUMENTATION CORRECTION`

**Naturaleza:** especificación documental controlada; no constituye decisión nueva de producto, ADR, diseño físico ni implementación.

**Estado de esta especificación:** `APPROVED FOR EXECUTION`

**Archivo de entrega:** `CORR-020-task-015-product-decisions-documentation-sync-approved.md`

**CORR-020 DETERMINATION:** `APPROVED`

**CORR-020 SPECIFICATION GENERATION GATE:** `AUTHORIZED`

**CORR-020 SPECIFICATION:** `APPROVED FOR EXECUTION`

**CORR-020 SPEC REVIEW:** `APPROVED`

**CORR-020 HUMAN SPEC APPROVAL:** `APPROVED`

**CORR-020 aprobada:** `SÍ`

**CORR-020 canonicalizada:** `NO`

**CORR-020 execution authorized:** `NO`

**Implementación de esta corrección realizada:** `NO`

**Documentos target modificados durante esta especificación:** `NO`

**Repositorio modificado:** `NO`

**Codex autorizado:** `NO`

**TASK-015 implementación autorizada:** `NO`

**Supabase Cloud modificado:** `NO`

**Git:** `NO`

**TASK-016:** `NOT DETERMINED / NOT GENERATED / NOT STARTED`

El estado `APPROVED FOR EXECUTION` significa exclusivamente:

```text
APPROVED FOR EXECUTION
=
SPECIFICATION HUMAN-APPROVED

APPROVED FOR EXECUTION
!=
CORR-020 EXECUTION AUTHORIZED

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

---

## 2. Objetivo único

CORR-020 debe sincronizar documentalmente las seis decisiones humanas ya aprobadas para el lifecycle funcional de `CompanyMembership` previo a TASK-015 en exactamente:

- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`.

La corrección futura debe cerrar únicamente el drift normativo existente entre esos tres documentos y las decisiones `DECISION-001..006` ya consumidas por TASK-015.

Debe preservarse:

```text
documentation synchronization
!= new product decision
!= architecture decision
!= physical design
!= TASK-015 implementation
```

Esta especificación no ejecuta todavía ningún cambio sobre los documentos target.

---

## 3. Contexto y reanudación

La primera ejecución del Gate de especificación de CORR-020 se detuvo correctamente porque la fuente canónica D no estaba físicamente disponible.

El estado histórico aprobado fue:

```text
CORR-020 SPECIFICATION =
BLOCKER — REQUIRED CANONICAL SOURCE UNAVAILABLE

CORR-020 SPECIFICATION BLOCKER REVIEW =
APPROVED

blocker class =
REQUIRED CANONICAL SOURCE UNAVAILABLE
```

La causa única fue la ausencia física de:

`TASK-015-company-membership-lifecycle-audit-event-atomic.md`.

La fuente D fue posteriormente adjuntada. Esta reanudación consume el mismo:

```text
CORR-020 DETERMINATION = APPROVED
CORR-020 SPECIFICATION GENERATION GATE = AUTHORIZED
```

No existe nueva determinación ni nuevo Gate de generación.

La identidad física de D fue verificada antes de reanudar y coincide exactamente con el contrato esperado.

No se detectó otro blocker durante la lectura de las fuentes obligatorias y adicionales disponibles.

---

## 4. Fuentes obligatorias e identidad canónica

### 4.1 Fuentes A/B/C/D

Se leyeron íntegramente y están físicamente disponibles:

1. `docs/product/01-product-definition.md`;
2. `docs/product/02-domain-model.md`;
3. `docs/product/03-permissions-rls-strategy.md`;
4. `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`.

### 4.2 Verificación física de TASK-015

Archivo verificado desde sus bytes físicos reales:

`TASK-015-company-membership-lifecycle-audit-event-atomic.md`

Resultado:

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
```

Identidad canónica documental consumida:

```text
canonical commit =
d6bec7461f9b82344bdfdb1b085459854f6c2f14
```

La verificación de CORR-020 confirma la identidad del archivo por bytes. No ejecuta Git ni revalida el commit canónico en un repositorio.

### 4.3 Fuentes canónicas adicionales releídas

También se releen íntegramente, por estar físicamente disponibles:

- `ADR-0002 — Multi-tenancy, tenant ownership y aislamiento`;
- `ADR-0003 — Autorización, client scope y soporte excepcional`;
- `TASK-010 — Fundación física mínima de AuditEvent`;
- `TASK-012 — Fundación mínima de autorización online autoritativa`;
- `TASK-014 — Fundación mínima de identidad/autorización global de SUPER_ADMIN`.

Estas fuentes se utilizan únicamente dentro del alcance que gobiernan.

---

## 5. Autoridad documental

Se aplica el siguiente orden:

1. decisiones humanas posteriores explícitamente aprobadas dentro de su alcance, incluyendo `DECISION-001..006`;
2. `docs/product/01-product-definition.md` como baseline normativa de producto;
3. `docs/product/02-domain-model.md` dentro del modelo conceptual de dominio;
4. `docs/product/03-permissions-rls-strategy.md` dentro de autorización, seguridad y RLS conceptual;
5. ADR aceptados dentro de la decisión arquitectónica que documentan;
6. TASK/CORR como contratos de ejecución, estado y materialización física, sin convertir diseño técnico en norma general de producto;
7. documentos históricos únicamente como evidencia del estado que documentaban en su momento.

Reglas de autoridad aplicadas:

```text
later approved product decision
>
older unsynchronized wording
```

y:

```text
TASK-015 technical mechanism
!= product normative rule
```

CORR-020 debe sincronizar significado, no trasladar a producto mecanismos físicos propios de TASK-015.

---

## 6. Naturaleza de CORR-020

CORR-020 es exclusivamente una `DOCUMENTATION CORRECTION`.

Debe:

- sincronizar reglas de producto ya aprobadas;
- cerrar ambigüedades normativas;
- mantener los tres documentos coherentes entre sí;
- preservar arquitectura, dominio, seguridad, multitenancy y RLS existentes;
- dejar satisfecha la precondición documental de TASK-015 cuando la corrección futura sea ejecutada, revisada y cerrada.

CORR-020 no:

- decide cómo implementar el lifecycle;
- selecciona mecanismo de concurrencia;
- crea una capability nueva;
- cambia el modelo de roles;
- cambia la frontera tenant;
- cambia el modelo provider-side;
- cambia la estrategia offline;
- amplía permisos de `SUPER_ADMIN`;
- altera onboarding.

---

## 7. Scope exacto

La futura ejecución de CORR-020 podrá modificar exclusivamente:

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
```

Scope semántico:

- lifecycle de `CompanyMembership` para disable/revoke, reinstate y role-change;
- restricciones self-target de `COMPANY_ADMIN`;
- continuidad de al menos un `COMPANY_ADMIN` habilitado cuando el tenant ya posee administración activa;
- role-change de membership disabled;
- reinstate usando el role vigente;
- requests ya satisfechas como no-op autorizado;
- ausencia de `AuditEvent` para no-op y `DENY`;
- reevaluación contra estado autoritativo vigente bajo concurrencia;
- preservación de same-tenant, RLS, provider boundary, offline y `SUPER_ADMIN`.

No se modifica ningún requisito ajeno a este lifecycle.

---

## 8. Fuera de scope

CORR-020 no define ni autoriza:

- RPC;
- nombre de función;
- `SECURITY DEFINER`;
- row locks;
- advisory locks;
- nivel de aislamiento;
- `SERIALIZABLE`;
- conditional `UPDATE`;
- SQL;
- migrations;
- grants/revokes;
- policies RLS concretas;
- `service-role`;
- Server Actions;
- Route Handlers;
- endpoints;
- shapes de API;
- tablas;
- columnas;
- índices;
- triggers;
- provider workaround;
- nuevas action names de `AuditEvent`;
- creación de usuarios;
- creación de memberships;
- `UserClientAccess`;
- `SupportAccessGrant`;
- bootstrap de primer administrador;
- `VerificationChallenge`;
- login/logout funcional;
- lifecycle offline de administración;
- outbox administrativo;
- UI completa de administración de usuarios;
- TASK-016.

---

## 9. DECISION-001..006 consumidas sin reapertura

### 9.1 DECISION-001 — SELF-DISABLE

```text
COMPANY_ADMIN self-disable / self-revoke =
PROHIBITED
```

Un `COMPANY_ADMIN` no puede deshabilitar ni revocar su propia `CompanyMembership` mediante el lifecycle de TASK-015.

### 9.2 DECISION-002 — SELF-ROLE-CHANGE

```text
COMPANY_ADMIN self-role-change =
PROHIBITED
```

Un `COMPANY_ADMIN` no puede cambiar el role de su propia `CompanyMembership` mediante TASK-015.

### 9.3 DECISION-003 — ADMIN CONTINUITY

Una operación lifecycle de TASK-015 no puede dejar a una `MaintenanceCompany` que ya posee administración activa sin al menos una `CompanyMembership` que cumpla simultáneamente:

```text
is_enabled = true
role = COMPANY_ADMIN
```

Si una operación produciría cero administradores habilitados:

```text
result = DENY
membership mutation = NONE
AuditEvent = NONE
```

Esta regla no redefine:

- onboarding;
- bootstrap;
- creación inicial del primer `COMPANY_ADMIN`.

### 9.4 DECISION-004 — ROLE CHANGE WHILE DISABLED

```text
role-change de CompanyMembership disabled =
ALLOWED
```

Sujeto a autorización y same-tenant.

El cambio:

- modifica `role`;
- no modifica `is_enabled`;
- no restaura autoridad tenant;
- si es un cambio real, requiere `USER_ROLE_CHANGED` conforme al contrato de auditoría aprobado.

### 9.5 DECISION-005 — ALREADY-SATISFIED REQUESTS

Después de validar autoritativamente actor, target, same-tenant, permiso e invariantes:

```text
disable sobre disabled
reinstate sobre enabled
same-role non-self
```

producen:

```text
IDEMPOTENT SUCCESS
changed = false
membership mutation = NONE
AuditEvent = NONE
```

Esto no convierte en success:

- actor inválido;
- actor disabled;
- role insuficiente;
- cross-tenant;
- self-target prohibido;
- cualquier otra condición fail-closed.

### 9.6 DECISION-006 — CONCURRENT OPERATIONS

Toda operación debe evaluarse contra estado PostgreSQL vigente.

Debe preservarse funcionalmente:

- ausencia de decisión definitiva basada en estado stale;
- reevaluación del estado vigente ante concurrencia;
- reevaluación de actor, tenant, target, role e `is_enabled`;
- reevaluación de continuidad administrativa;
- actor que pierde autoridad antes de confirmar → `DENY`;
- desired state ya satisfecho → DECISION-005;
- transición todavía válida → puede ejecutarse;
- mutación real + `AuditEvent` obligatorio → misma frontera atómica.

El MVP no exige un token `expected-state/version` aportado por el cliente.

CORR-020 no selecciona el mecanismo físico para conseguir estas propiedades.

---

## 10. Revisión de contradicciones y resultado

Se contrastaron `DECISION-001..006` contra A/B/C/D y las fuentes adicionales disponibles.

Resultado:

```text
contradicciones materiales bloqueantes = 0
new product decision required = NO
new ADR required = NO
ADR-0003 reopening required = NO
onboarding change required = NO
role model change required = NO
multitenancy change required = NO
RLS architecture change required = NO
provider workaround required = NO
fourth target document required = NO
```

Las seis decisiones son compatibles con el canon vigente porque:

- `COMPANY_ADMIN` ya administra usuarios de su propio tenant, pero el canon no define todavía los límites self-target;
- `CompanyMembership` ya posee role mutable y estado enabled/disabled, pero no especifica todavía role-change while disabled ni reinstate con role vigente;
- el canon exige estado autoritativo vigente, pero no materializa todavía la semántica completa de requests concurrentes para este lifecycle;
- la auditoría ya exige eventos para disable/revoke, reinstate y role-change, pero no distingue todavía de forma inequívoca entre mutación real, no-op autorizado y `DENY`;
- RLS y autorización funcional ya están separadas conceptualmente;
- ADR-0003 ya establece PostgreSQL vigente como autoridad primaria y provider termination como defense in depth;
- `SUPER_ADMIN` ya es global y no posee bypass tenant ordinario;
- onboarding y creación inicial del primer administrador constituyen un flujo distinto.

Por tanto:

```text
CORR-020 SPECIFICATION = APPROVED FOR EXECUTION
```

---

## 11. Target `01-product-definition.md` — análisis de gaps

### 11.1 §5.2 — `COMPANY_ADMIN`

**current normative gap =**

La sección concede administración de usuarios de la empresa, pero no expresa que la administración del lifecycle de memberships está limitada por same-tenant, autoridad vigente, prohibiciones self-target y continuidad administrativa.

**required synchronization =**

Añadir una calificación mínima a la capacidad de administración de usuarios para dejar claro que disable/revoke y role-change se ejecutan únicamente bajo las invariantes aprobadas del lifecycle.

**exact semantic effect =**

La capacidad administrativa continúa existiendo, pero deja de poder interpretarse como autoridad irrestricta sobre la propia membership o como permiso para eliminar al último administrador habilitado.

**preserved semantics =**

- `COMPANY_ADMIN` continúa administrando usuarios de su empresa;
- no se modifica ninguna capacidad de mantenimiento, Reporting, IA, suscripción o soporte;
- no se concede acceso cross-tenant.

### 11.2 §7.1 — RF-017

**current normative gap =**

`RF-017` permite modificar posteriormente role y clientes autorizados, pero no define:

- self-role-change;
- cambio de role mientras la membership está disabled;
- preservación de `is_enabled`;
- same-role non-self como no-op autorizado;
- evaluación contra role vigente.

**required synchronization =**

Conservar el ID `RF-017` y ampliar únicamente su semántica de role-change para materializar DECISION-002, DECISION-004, DECISION-005 y DECISION-006.

**exact semantic effect =**

- self-role-change de `COMPANY_ADMIN` queda prohibido;
- role-change de target disabled queda permitido si actor y target son autorizables y same-tenant;
- el role-change no modifica el estado enabled/disabled;
- same-role non-self autorizado es success sin mutación;
- el estado vigente prevalece frente a estado stale.

**preserved semantics =**

- los únicos roles siguen siendo `COMPANY_ADMIN` y `TECHNICIAN`;
- el cambio de clientes autorizados permanece sin modificación en CORR-020;
- no se crea RBAC configurable.

### 11.3 §7.1 — RF-018

**current normative gap =**

`RF-018` concede disable sin eliminación, pero no define self-disable, continuidad administrativa ni disable sobre target ya disabled.

**required synchronization =**

Conservar el ID `RF-018` y acotar la operación con DECISION-001, DECISION-003, DECISION-005 y DECISION-006.

**exact semantic effect =**

- self-disable/self-revoke queda prohibido;
- no puede confirmarse una operación que deje cero `COMPANY_ADMIN` habilitados cuando ya existe administración activa;
- disable sobre disabled, después de autorización completa, se considera no-op autorizado;
- una reevaluación contra estado vigente precede a la confirmación.

**preserved semantics =**

- disable no elimina identidad ni historial;
- provider boundary continúa gobernada por RF-019/§21.2;
- no se modifica onboarding.

### 11.4 §7.1 — RF-019 y RF-020

**current normative gap =**

No existe un gap de producto que requiera modificar su semántica para CORR-020.

**required synchronization =**

`NO CHANGE`.

**exact semantic effect =**

Se preserva la revocación online inmediata basada en estado autoritativo vigente y la conservación de identidad/historial.

**preserved semantics =**

Provider termination continúa siendo defense in depth cuando exista mecanismo público, soportado y aplicable; su fallo no restaura autorización.

### 11.5 §7.1 — RF-021

**current normative gap =**

`RF-021` permite reintegrar, pero no expresa que la reintegración usa el role vigente ni que reinstate sobre enabled es no-op autorizado después de validaciones.

**required synchronization =**

Conservar el ID `RF-021` y añadir únicamente semántica de DECISION-005/006 y la consecuencia de DECISION-004.

**exact semantic effect =**

- reinstate real cambia habilitación sin recuperar un role histórico anterior;
- el role vigente en la membership es el que determina la autoridad restaurada;
- reinstate sobre enabled autorizado es success sin mutación ni auditoría;
- actor/target/tenant/permiso/invariantes se validan antes de reconocer no-op.

**preserved semantics =**

No se crea un flujo de re-verificación, password reset o nuevo `VerificationChallenge`.

### 11.6 §9 — Roles y permisos

**current normative gap =**

La fila `Deshabilitar/reintegrar usuarios` y la capacidad general de administración de usuarios podrían leerse como autorización irrestricta de `COMPANY_ADMIN` sobre cualquier membership del tenant, incluida la propia o el último administrador.

La matriz tampoco expresa la semántica del role-change sobre target disabled.

**required synchronization =**

Aplicar una calificación mínima a la fila/capacidad de lifecycle y añadir una nota normativa breve que remita a las invariantes del lifecycle.

**exact semantic effect =**

`COMPANY_ADMIN` conserva la capability dentro de su tenant, pero su ejercicio queda sujeto a:

- self-target prohibitions;
- continuidad administrativa;
- same-tenant;
- estado vigente;
- no-op autorizado;
- role-change disabled sin rehabilitación.

**preserved semantics =**

Las capacidades de los otros roles no cambian. `SUPER_ADMIN` no obtiene OP-01/02/03 por inferencia.

### 11.7 §11 — Reglas e invariantes de negocio

**current normative gap =**

`INV-001..026` no materializan todavía las seis decisiones de lifecycle.

**required synchronization =**

Añadir al final, sin renumerar invariantes existentes, cinco invariantes nuevas de mera materialización:

- `INV-027` — prohibiciones self-target de `COMPANY_ADMIN`;
- `INV-028` — continuidad administrativa sin redefinir bootstrap;
- `INV-029` — role-change disabled preserva `is_enabled` y reinstate usa role vigente;
- `INV-030` — already-satisfied autorizado = no-op sin mutation/AuditEvent; `DENY` = no AuditEvent;
- `INV-031` — lifecycle decidido contra estado autoritativo vigente bajo concurrencia, sin requerir expected-state/version token del caller.

**exact semantic effect =**

Las decisiones quedan identificables y referenciables desde los documentos derivados sin crear requisitos nuevos ni renumerar `INV-001..026`.

**preserved semantics =**

Todos los invariantes ajenos al lifecycle permanecen intactos.

### 11.8 §12 — FL-03 — Deshabilitación y reintegración

**current normative gap =**

El flujo describe disable/reintegration de forma lineal, pero omite:

- self-disable;
- continuidad administrativa;
- already-satisfied requests;
- reinstate con role vigente;
- autoridad vigente antes de confirmar.

**required synchronization =**

Ajustar FL-03 de forma mínima para expresar precondiciones y resultados observables, sin introducir mecanismo físico.

**exact semantic effect =**

El flujo pasa a distinguir:

- operación autorizada;
- `DENY`;
- no-op autorizado;
- mutación real;
- reintegración con role vigente.

**preserved semantics =**

Se mantiene la revocación online inmediata, conservación de identidad/historial, protección offline y provider boundary existentes.

### 11.9 §21.2 — Revocación

**current normative gap =**

Ninguno que exija cambio para DECISION-001..006.

**required synchronization =**

`READ / PRESERVE — NO CHANGE`.

**exact semantic effect =**

Ninguno.

**preserved semantics =**

- PostgreSQL/estado autoritativo vigente como autoridad primaria;
- JWT residual no conserva autorización;
- provider termination como defensa adicional pública/soportada/aplicable;
- fallo provider no restaura autorización.

### 11.10 §22 — Auditoría

**current normative gap =**

La sección enumera disable/revoke, reinstate y role-change como eventos obligatorios, pero no especifica que el evento corresponde a una mutación real ni que no-op autorizado y `DENY` producen cero `AuditEvent`.

**required synchronization =**

Añadir una precisión normativa mínima, sin nuevas action names.

**exact semantic effect =**

- mutación real de disable/revoke → evento requerido;
- mutación real de reinstate → evento requerido;
- mutación real de role-change → evento requerido;
- already-satisfied autorizado → no `AuditEvent`;
- `DENY` → no `AuditEvent`.

**preserved semantics =**

Actor, empresa, acción, momento y alcance continúan siendo obligatorios. No se modifica el modelo físico de `AuditEvent`.

---

## 12. Target `02-domain-model.md` — análisis de gaps

### 12.1 Identity & Access (§3.1)

**current normative gap =**

La responsabilidad del bounded context ya incluye `CompanyMembership`, roles, habilitación, deshabilitación y reintegración.

**required synchronization =**

`INSPECTED — NO CHANGE`.

**exact semantic effect =**

Ninguno.

**preserved semantics =**

Identity & Access continúa siendo owner conceptual del lifecycle sin absorber Tenant Management ni convertir `MaintenanceCompany` en agregado transaccional.

### 12.2 Entidad conceptual `CompanyMembership` (§4.4)

**current normative gap =**

La entidad define role mutable, estado mutable y lifecycle enabled/disabled/reintegrated, pero no contiene las invariantes específicas de DECISION-001..006.

**required synchronization =**

Añadir reglas conceptuales del lifecycle:

- self-disable y self-role-change prohibidos para actor `COMPANY_ADMIN`;
- continuidad administrativa;
- role-change disabled permitido sin cambio de estado;
- reinstate usa role vigente;
- no-op autorizado sin auditoría;
- decisiones contra estado autoritativo vigente.

**exact semantic effect =**

La entidad refleja completamente el comportamiento ya aprobado sin introducir estructura física.

**preserved semantics =**

- propietario = `MaintenanceCompany`;
- roles = `COMPANY_ADMIN | TECHNICIAN`;
- identidad e historial preservados;
- cardinalidad vigente no cambia.

### 12.3 §6.5 — Deshabilitación

**current normative gap =**

La sección cubre efectos de revocación y provider boundary, pero no expresa las reglas de operación del lifecycle para disable/reinstate.

**required synchronization =**

Añadir una subsección conceptual mínima que distinga:

- actor autorizable vs actor sin autoridad vigente;
- self-disable prohibido;
- continuidad administrativa;
- disable sobre disabled como no-op después de checks;
- reinstate sobre enabled como no-op después de checks;
- reinstate real usando role vigente;
- current-state semantics.

**exact semantic effect =**

Se armoniza el lifecycle del dominio con la autorización vigente, manteniendo separada la terminación provider-side.

**preserved semantics =**

La política offline de 7 días y la no destrucción de datos locales no cambian.

### 12.4 §19.4 — Eventos obligatorios actuales

**current normative gap =**

La lista no diferencia mutación real de no-op/deny.

**required synchronization =**

Precisar que disable/revoke, reinstate y role-change exigen `AuditEvent` cuando producen un cambio real autorizado.

Añadir expresamente:

```text
authorized no-op → no AuditEvent
DENY → no AuditEvent
```

**exact semantic effect =**

Se elimina la posibilidad de historial falso por intents sin cambio.

**preserved semantics =**

No se modifican otras acciones auditables ni se crean action names.

### 12.5 §20.1 — Agregado `CompanyMembership`

**current normative gap =**

El agregado protege tenant único, role permitido, same-tenant de clientes y disable sin eliminación, pero no refleja las nuevas invariantes de consistencia del lifecycle.

**required synchronization =**

Agregar como invariantes protegidas:

- self-target prohibitions;
- admin continuity;
- disabled role-change no rehabilita;
- reinstate usa current role;
- no-op/deny no generan `AuditEvent`;
- operación evaluada contra estado autoritativo vigente.

**exact semantic effect =**

El agregado explica qué consistencia conceptual debe preservar una operación de membership, sin elegir cómo materializarla físicamente.

**preserved semantics =**

`MaintenanceCompany` no se convierte en agregado gigante y no se declara que todo el tenant sea una única transacción.

### 12.6 §22.1 — Invariantes de multitenancy y acceso

**current normative gap =**

La sección mapea `INV-001..005`, `MT-005`, `MT-007` y `MT-010`, pero no referencia las nuevas invariantes de lifecycle que afectan autorización tenant.

**required synchronization =**

Añadir referencias mínimas a `INV-027..031` una vez incorporadas en `01`, sólo dentro de su semántica aplicable.

**exact semantic effect =**

Se mantiene trazabilidad entre baseline normativa y modelo de dominio.

**preserved semantics =**

Las invariantes de multitenancy existentes no cambian ni se amplía el modelo de roles.

### 12.7 §23.1 — Lifecycle del usuario tenant

**current normative gap =**

El diagrama actual muestra cambio de role y deshabilitación/reintegración, pero no expresa:

- self-target restrictions;
- continuidad administrativa;
- role-change de disabled;
- reinstate con role vigente;
- no-op;
- estado vigente bajo concurrencia.

**required synchronization =**

Ampliar el lifecycle de forma conceptual y observable, no física.

**exact semantic effect =**

El lifecycle distingue transiciones reales, transiciones prohibidas y desired-state ya satisfecho, y deja claro que una membership disabled puede cambiar role sin quedar habilitada.

**preserved semantics =**

No se cambia el alta, `VerificationChallenge`, perfil ni creación inicial del primer administrador.

---

## 13. Target `03-permissions-rls-strategy.md` — análisis de gaps

### 13.1 §2.4 — `COMPANY_ADMIN`

**current normative gap =**

Se establece que administra usuarios y permisos de su empresa, pero no se explicitan restricciones self-target ni continuidad administrativa.

**required synchronization =**

Añadir una precisión de autorización funcional para lifecycle de `CompanyMembership`.

**exact semantic effect =**

La administración de usuarios queda inequívocamente limitada a operaciones same-tenant permitidas, con actor vigente, self-disable/self-role-change denegados y continuidad administrativa preservada.

**preserved semantics =**

No se modifican permisos sobre mantenimiento, Reporting, IA, suscripción o soporte.

### 13.2 §2.6 — `CompanyMembership`

**current normative gap =**

La sección sólo define pertenencia, tenant, role y enabled state.

**required synchronization =**

Añadir reglas de lifecycle relevantes para autorización:

- conocer target no concede autorización;
- same-tenant obligatorio;
- actor debe conservar membership enabled y role `COMPANY_ADMIN`;
- role-change disabled no restaura authority;
- reinstate usa current role;
- no-op/deny no producen auditoría.

**exact semantic effect =**

`CompanyMembership` pasa a expresar de forma suficiente su papel como autoridad tenant actual.

**preserved semantics =**

No se introduce nueva entidad ni nuevo estado.

### 13.3 §7 — Matriz conceptual de permisos

**current normative gap =**

La fila `Usuarios/memberships posteriores` dice que `COMPANY_ADMIN` puede crear, cambiar role, cambiar clientes, deshabilitar y reintegrar, pero no expresa límites del lifecycle.

**required synchronization =**

Ajustar mínimamente la fila y/o añadir una nota específica bajo la matriz que haga normativas las restricciones de DECISION-001..006 sin saturar la tabla.

**exact semantic effect =**

La matriz ya no puede leerse como una autorización irrestricta sobre la propia membership, cross-tenant o el último administrador.

**preserved semantics =**

`TECHNICIAN` sigue sin administrar memberships y `SUPER_ADMIN` no obtiene administración ordinaria mediante grant.

### 13.4 §12.2 — Patrón de usuario tenant

**current normative gap =**

El patrón resuelve identidad, membership, tenant, role, ownership, scope y reglas de mutabilidad, pero no explicita que un lifecycle request aparentemente ya satisfecho debe pasar primero por toda la autorización ni que la autoridad debe continuar vigente al confirmar.

**required synchronization =**

Añadir al patrón:

- target/tenant real derivado autoritativamente;
- same-tenant;
- invariantes del lifecycle;
- reevaluación de autoridad vigente antes de confirmar;
- no-op sólo después de esas validaciones.

**exact semantic effect =**

Se previene que `changed=false` se use como bypass de autorización.

**preserved semantics =**

El patrón sigue siendo conceptual y no especifica API, RPC ni SQL.

### 13.5 §12.3 — `COMPANY_ADMIN`

**current normative gap =**

La sección exige membership enabled, role admin, same tenant y operación permitida, pero no enumera las restricciones del lifecycle de memberships.

**required synchronization =**

Añadir las reglas exactas:

- self-disable DENY;
- self-role-change DENY;
- last enabled admin protegido;
- role-change disabled permitido sin habilitar;
- desired-state ya satisfecho sólo es no-op después de autorización;
- current authoritative state prevalece.

**exact semantic effect =**

El authorization pattern de `COMPANY_ADMIN` queda completo para TASK-015.

**preserved semantics =**

No se infieren otras capabilities de administración ni ejecución inicial de mantenimiento.

### 13.6 §19.1 — Membership deshabilitada

**current normative gap =**

Define pérdida de acceso y preservación de historia, pero no define operación de disable/reinstate.

**required synchronization =**

Añadir:

- self-disable prohibido;
- protección de último admin enabled;
- already-disabled autorizado = no-op;
- reinstate usa role vigente;
- already-enabled autorizado = no-op;
- actor disabled no recupera autoridad por apuntarse a sí mismo.

**exact semantic effect =**

Se alinea revocación funcional con DECISION-001/003/005/006.

**preserved semantics =**

No se elimina `PlatformUser`, auditoría ni datos técnicos.

### 13.7 §19.3 — Cambio de rol

**current normative gap =**

La sección sólo exige estado autoritativo vigente y rechazo de role stale.

**required synchronization =**

Añadir:

- self-role-change prohibido;
- same-role non-self autorizado = no-op después de checks;
- cambio real sobre disabled permitido;
- `is_enabled` permanece false;
- promotion/demotion no reinterpreta la autoridad pasada;
- demotion destructiva de último admin enabled = `DENY`;
- reevaluación bajo concurrencia.

**exact semantic effect =**

Se materializan DECISION-002/003/004/005/006 en la estrategia de autorización.

**preserved semantics =**

Los únicos roles continúan siendo los aprobados.

### 13.8 §19.5 — Revocación efectiva y provider-side

**current normative gap =**

Ninguno.

**required synchronization =**

`READ / PRESERVE — NO CHANGE`.

**exact semantic effect =**

Ninguno.

**preserved semantics =**

```text
current authoritative PostgreSQL state = PRIMARY AUTHORIZATION AUTHORITY
provider-side termination = DEFENSE IN DEPTH WHEN PUBLIC/SUPPORTED/APPLICABLE
provider failure/unavailability = DOES NOT RESTORE AUTHORIZATION
```

CORR-020 no introduce la conclusión contextual de TASK-015 `provider-side termination = UNSUPPORTED` como norma general.

### 13.9 §25 — Auditoría de seguridad

**current normative gap =**

Se enumeran eventos mínimos, pero no se explicita la regla de ausencia de evento para no-op/deny de este lifecycle.

**required synchronization =**

Precisar en §25.1 que los eventos de disable/revoke, reinstate y role-change corresponden a mutaciones reales autorizadas y que:

```text
authorized no-op → no AuditEvent
DENY → no AuditEvent
```

**exact semantic effect =**

Se preserva la integridad semántica del historial de seguridad.

**preserved semantics =**

No se modifican actor, momento, alcance, inmutabilidad ni separación respecto de historia de dominio.

### 13.10 §26 — Pruebas RLS obligatorias

**current normative gap =**

Existen pruebas de actor disabled, cross-tenant, autoescalamiento y revocación, pero no un bloque explícito que cubra todas las decisiones del lifecycle de `CompanyMembership`.

**required synchronization =**

Añadir un bloque conceptual específico de pruebas de lifecycle, sin diseñar policy física, que exija demostrar:

- self-disable DENY;
- self-role-change DENY;
- last enabled admin protegido;
- disabled role-change permitido y sin rehabilitación;
- reinstate usa role vigente;
- authorized no-op sin mutación ni `AuditEvent`;
- unauthorized/cross-tenant no se convierte en no-op success;
- autoridad stale no prevalece;
- current authoritative state prevalece ante concurrencia;
- direct bypass continúa denegado por la arquitectura/RLS vigente.

**exact semantic effect =**

La estrategia de pruebas queda alineada con las nuevas normas sin abrir write policies.

**preserved semantics =**

RLS continúa siendo frontera primaria de datos, complementada por autorización funcional.

---

## 14. Matriz exhaustiva de cambios documentales previstos

| document | section/anchor | current text semantic | gap against DECISION-001..006 | planned minimal change | decision(s) synchronized | content explicitly preserved |
|---|---|---|---|---|---|---|
| `01-product-definition.md` | §5.2 `COMPANY_ADMIN` | Administra usuarios de su empresa | No expresa límites lifecycle | Añadir calificación breve de lifecycle same-tenant, self-target y continuidad | 001, 002, 003 | Resto de capacidades del rol |
| `01-product-definition.md` | §7.1 `RF-017` | Puede cambiar role/clientes | No self-role, disabled-role/no-op/current-state | Ampliar sólo semántica de role-change manteniendo ID | 002, 004, 005, 006 | Cambio de clientes y roles fijos |
| `01-product-definition.md` | §7.1 `RF-018` | Puede disable sin eliminar | No self-disable/last-admin/no-op/current-state | Acotar disable manteniendo ID | 001, 003, 005, 006 | No eliminación de identidad |
| `01-product-definition.md` | §7.1 `RF-021` | Disabled puede reintegrarse | No current-role/no-op/current-state | Precisar reinstate manteniendo ID | 004, 005, 006 | Reintegración como capability |
| `01-product-definition.md` | §9 Roles y permisos | Admin puede deshabilitar/reintegrar | Puede leerse como autoridad irrestricta | Ajustar fila/nota lifecycle | 001–006 | Capacidades restantes de matriz |
| `01-product-definition.md` | §11 Invariantes | INV-001..026 no cubren lifecycle | Falta materialización identificable | Añadir `INV-027..031` sin renumerar previos | 001–006 | INV-001..026 |
| `01-product-definition.md` | §12 FL-03 | Flujo lineal disable/reintegrate | Omite deny/no-op/current-role/continuity | Añadir resultados observables y precondiciones | 001, 003, 005, 006 + efecto de 004 | Provider/offline/history |
| `01-product-definition.md` | §22 Auditoría | Lista acciones auditables | No distingue real mutation vs no-op/deny | Añadir precisión mínima | 004, 005 | Action catalog y contenido mínimo |
| `02-domain-model.md` | §4.4 `CompanyMembership` | Role/state mutable; lifecycle básico | No contiene seis reglas | Añadir reglas conceptuales | 001–006 | Ownership, cardinalidad, roles |
| `02-domain-model.md` | §6.5 Deshabilitación | Revocación y provider/offline | No lifecycle operation semantics | Añadir disable/reinstate conceptual | 001, 003, 005, 006 + efecto de 004 | Provider/offline |
| `02-domain-model.md` | §19.4 Eventos obligatorios | Disable/reinstate/role change auditables | No distingue no-op/deny | Precisar sólo mutaciones reales | 004, 005 | Otros eventos |
| `02-domain-model.md` | §20.1 agregado `CompanyMembership` | Invariantes básicas | Falta consistencia lifecycle | Añadir invariantes protegidas | 001–006 | Agregado acotado |
| `02-domain-model.md` | §22.1 Multitenancy y acceso | Mapea invariantes base | No referencia nuevas INV lifecycle | Añadir trazabilidad a `INV-027..031` | 001–006 | MT/INV existentes |
| `02-domain-model.md` | §23.1 Usuario tenant | Lifecycle básico | Omite disabled-role/no-op/self/continuity/concurrency | Ampliar lifecycle conceptual | 001–006 | Alta/VerificationChallenge |
| `03-permissions-rls-strategy.md` | §2.4 `COMPANY_ADMIN` | Administra usuarios del tenant | No límites lifecycle | Añadir restricciones funcionales | 001–003, 006 | Resto de permisos |
| `03-permissions-rls-strategy.md` | §2.6 `CompanyMembership` | Tenant authority = membership/role/enabled | No reglas lifecycle | Añadir semántica autorizativa | 001–006 | Modelo de autoridad |
| `03-permissions-rls-strategy.md` | §7 matriz | Admin puede crear/change/disable/reinstate | No restricciones explícitas | Calificar fila/añadir nota | 001–006 | Matriz completa |
| `03-permissions-rls-strategy.md` | §12.2 patrón tenant | Valida actor/recurso | No target/invariants/no-op-after-auth/current-state-confirm | Ampliar patrón conceptual | 003, 005, 006 | Orden de autorización base |
| `03-permissions-rls-strategy.md` | §12.3 `COMPANY_ADMIN` | Enabled admin + same tenant + permitted op | No lifecycle-specific checks | Añadir reglas exactas | 001–006 | Prohibiciones de mantenimiento existentes |
| `03-permissions-rls-strategy.md` | §19.1 membership disabled | Pierde acceso, historia preservada | No disable/reinstate semantics | Añadir self/continuity/no-op/current-role | 001, 003, 005, 006 | Revocación general |
| `03-permissions-rls-strategy.md` | §19.3 role change | Current role state prevalece | No self/disabled/continuity/no-op | Añadir reglas lifecycle | 002–006 | Rol vigente como autoridad |
| `03-permissions-rls-strategy.md` | §25.1 auditoría mínima | Enumera eventos | No diferencia mutation/no-op/deny | Precisar eventos reales | 004, 005 | Audit model |
| `03-permissions-rls-strategy.md` | §26 pruebas obligatorias | Negativas/positivas generales | Falta cobertura completa lifecycle | Añadir bloque conceptual de tests | 001–006 | Tests RLS existentes |

Total de superficies propuestas para modificación: `23`.

Ninguna fila introduce un cuarto documento.

---

## 15. Secciones inspeccionadas pero `NO CHANGE`

### 15.1 `01-product-definition.md`

- **§7.1 RF-019:** ya preserva revocación online inmediata desde estado autoritativo vigente y provider defense in depth.
- **§7.1 RF-020:** ya preserva identidad e historial; no necesita cambio.
- **§12 FL-01:** creación inicial del primer `COMPANY_ADMIN`; DECISION-003 no redefine bootstrap.
- **§21.2 Revocación:** semántica provider/current-state ya correcta y debe preservarse.
- **secciones offline generales:** no deben alterarse por un lifecycle administrativo online-only.
- **secciones de `SUPER_ADMIN`:** ya expresan identidad global/no tenant default access; no deben ampliarse.

### 15.2 `02-domain-model.md`

- **§3.1 Identity & Access:** ya ubica correctamente el lifecycle; no necesita alterar fronteras de bounded context.
- **§6.3 Acceso efectivo tenant:** ya exige membership habilitada, tenant, role y demás autoridad vigente.
- **§19.3 Auditoría de seguridad:** definición general suficiente.
- **§19.5 No duplicación indiscriminada:** compatible con no emitir eventos sin mutación real; no requiere reformulación.
- **concepto `MaintenanceCompany`:** no debe convertirse en agregado transaccional global.
- **secciones offline:** se preservan sin cambios.

### 15.3 `03-permissions-rls-strategy.md`

- **§2.3 `SUPER_ADMIN`:** ya establece global/no membership/no tenant bypass.
- **§3.4 PostgreSQL:** ya establece source of truth remota y RLS como frontera primaria.
- **§7.1 regla conservadora:** ausencia de permiso aprobado ya implica no inferencia.
- **§19.5 provider-side:** debe preservarse exactamente en su función conceptual.
- **§20 autorización offline:** no se modifica.
- **§26.8 usuarios deshabilitados:** ya exige revocación efectiva aun con sesión/JWT residual; el nuevo bloque de tests complementa, no sustituye.
- **secciones de `service-role`:** no requieren cambio; CORR-020 no diseña frontera privilegiada física.

---

## 16. Invariantes preservadas

La futura corrección debe preservar expresamente:

```text
tenant = MaintenanceCompany
```

```text
authenticated != authorized
```

```text
current authoritative PostgreSQL state
>
JWT / session / cookies / frontend / caller-supplied authority
```

```text
RLS = primary remote isolation boundary
```

```text
same-tenant = mandatory
```

```text
COMPANY_ADMIN lifecycle authority
!= unrestricted self-administration
```

```text
SUPER_ADMIN global authority
!= tenant CompanyMembership lifecycle bypass
```

```text
disabled role-change
!= reinstate
```

```text
reinstate
→ current role
```

```text
authorized no-op
→ no mutation
→ no AuditEvent
```

```text
DENY
→ no mutation
→ no AuditEvent
```

```text
real lifecycle mutation
→ required AuditEvent
```

```text
admin continuity
does not redefine first-admin bootstrap
```

---

## 17. Seguridad

La sincronización debe dejar inequívoco que:

1. conocer un `CompanyMembership` target no concede autoridad;
2. same-tenant se valida desde relaciones autoritativas;
3. actor debe conservar membership habilitada y role vigente `COMPANY_ADMIN`;
4. self-disable/self-revoke se deniega;
5. self-role-change se deniega incluso si el requested role coincide con el vigente;
6. una operación que dejaría cero enabled `COMPANY_ADMIN` se deniega;
7. un actor que pierde autoridad antes de confirmación se deniega;
8. un estado stale de UI/JWT no prevalece;
9. role-change de target disabled no rehabilita;
10. no-op sólo se reconoce después de autorización/invariantes;
11. cross-tenant y actor no autorizado nunca se convierten en success por estado ya satisfecho;
12. el historial de auditoría no debe registrar una mutación que no ocurrió.

CORR-020 no define el mecanismo server-side, PostgreSQL o API que implementará estas garantías.

---

## 18. RLS

RLS continúa siendo obligatoria para datos tenant-owned y la frontera primaria de aislamiento remoto.

CORR-020 debe preservar:

- RLS no sustituye autorización funcional del caso de uso;
- autorización funcional no sustituye RLS;
- no se abre una write policy general de `CompanyMembership`;
- no se abre una write policy de `AuditEvent`;
- no se concede autoridad por conocer IDs;
- target disabled no requiere ampliar visibilidad ordinaria como norma de producto;
- cross-tenant continúa siendo fail-closed;
- las futuras pruebas deben demostrar bypass directo denegado.

CORR-020 no contiene:

```text
CREATE POLICY
ALTER POLICY
GRANT
REVOKE
SECURITY DEFINER
SQL
```

Esos mecanismos permanecen fuera de esta corrección documental.

---

## 19. Multitenancy, roles y `SUPER_ADMIN`

### 19.1 Multitenancy

Se preserva:

- una `CompanyMembership` pertenece a un único `MaintenanceCompany`;
- actor y target deben pertenecer al mismo tenant para el lifecycle;
- IDs caller-supplied no determinan tenant;
- no se modifica `MT-001..010`.

### 19.2 Roles tenant

Se preserva exactamente:

```text
COMPANY_ADMIN
TECHNICIAN
```

No se añade role tenant nuevo.

### 19.3 `SUPER_ADMIN`

Se preserva:

```text
SUPER_ADMIN = GLOBAL IDENTITY
SUPER_ADMIN normal = NO tenant lifecycle bypass
absence of membership != SUPER_ADMIN
```

Un `SupportAccessGrant`:

- no convierte a `SUPER_ADMIN` en `COMPANY_ADMIN`;
- no crea OP-01/02/03 por inferencia;
- no modifica el lifecycle ordinario de `CompanyMembership`.

---

## 20. Auditoría

CORR-020 debe mantener el catálogo ya aprobado y no crear nuevas action names.

Semántica normativa a sincronizar:

```text
real disable/revoke
→ AuditEvent required
```

```text
real reinstate
→ AuditEvent required
```

```text
real role-change
→ AuditEvent required
```

Para role-change real sobre membership disabled:

```text
USER_ROLE_CHANGED required
is_enabled remains false
```

Y expresamente:

```text
authorized already-satisfied no-op
→ AuditEvent = NONE
```

```text
DENY
→ AuditEvent = NONE
```

La atomicidad `real mutation + required AuditEvent` continúa siendo una propiedad requerida, pero CORR-020 no define cómo se materializa físicamente.

El modelo físico, campos, constraints y action catalog de TASK-010 permanecen intactos.

---

## 21. Offline

CORR-020 no modifica la estrategia offline general.

Debe preservarse:

- lifecycle administrativo de TASK-015 = `ONLINE-ONLY`;
- no existe outbox administrativo de membership por esta corrección;
- revocación conocida prevalece al recuperar conexión;
- ventana offline máxima aprobada permanece sin cambios;
- datos locales no se eliminan por disable/revoke;
- aislamiento local por identidad permanece obligatorio;
- trabajo previamente capturado no se destruye por revocación.

La sincronización normativa de `CompanyMembership` no debe reinterpretarse como autorización para crear mutaciones administrativas offline.

---

## 22. Provider boundary

CORR-020 preserva ADR-0003 y la baseline ya sincronizada.

Norma general preservada:

```text
current authoritative PostgreSQL state =
PRIMARY AUTHORIZATION AUTHORITY
```

```text
provider-side termination =
DEFENSE IN DEPTH WHEN PUBLIC / SUPPORTED / APPLICABLE
```

```text
provider failure / unavailability =
DOES NOT RESTORE AUTHORIZATION
```

La conclusión técnica de TASK-015 para el contrato Supabase verificado en su fecha:

```text
provider-side termination for another user under TASK-015 constraints =
UNSUPPORTED
```

no se eleva a norma general de producto mediante CORR-020.

CORR-020 no:

- selecciona primitive provider;
- introduce workaround;
- cambia password;
- accede a `auth.sessions`;
- guarda JWT de targets;
- redefine logout.

---

## 23. Concurrencia — nivel documental

La futura corrección debe normativizar exclusivamente comportamiento observable.

Debe quedar expresamente requerido:

1. una operación no puede confirmarse basándose definitivamente en actor/target/role/enabled state stale;
2. antes de confirmar se usa estado PostgreSQL vigente;
3. autoridad del actor se reevalúa;
4. tenant/target/role/`is_enabled` vigentes se reevaluan;
5. continuidad administrativa se reevalúa;
6. actor que pierde autoridad antes de confirmar → `DENY`;
7. desired state ya satisfecho después de esas reevaluaciones → DECISION-005;
8. una transición todavía válida puede confirmarse;
9. mutación real y `AuditEvent` requerido conservan una única frontera atómica;
10. el caller no necesita aportar expected-state/version token.

CORR-020 no selecciona:

- row locks;
- tenant locks;
- target locks;
- advisory locks;
- mutex;
- transaction isolation level;
- conditional update;
- RPC;
- database function.

La estrategia física permanece exclusivamente en TASK-015.

---

## 24. Onboarding y primer administrador

DECISION-003 se aplica al lifecycle de una `MaintenanceCompany` que ya posee administración activa.

No redefine:

- `FL-01`;
- creación de `MaintenanceCompany`;
- alta inicial del primer `COMPANY_ADMIN`;
- `VerificationChallenge`;
- bootstrap de autoridad;
- establecimiento inicial de sesión.

La futura corrección no debe modificar `FL-01`.

Si durante la ejecución se concluyera que `FL-01` necesita cambio semántico para hacer posible DECISION-003, el resultado obligatorio sería `BLOCKER`, no scope creep.

---

## 25. Determinación de ADR

Resultado:

```text
NEW ADR REQUIRED = NO
```

Justificación:

- ADR-0002 ya gobierna tenant ownership, same-tenant, RLS e integridad cross-tenant;
- ADR-0003 ya gobierna autorización vigente, revocación efectiva y provider defense in depth;
- las decisiones `DECISION-001..006` son decisiones de producto/lifecycle ya aprobadas;
- CORR-020 sólo las sincroniza;
- los mecanismos físicos de atomicidad/concurrencia pertenecen a TASK-015;
- no aparece una decisión arquitectónica transversal nueva.

Si una futura ejecución necesitara reabrir ADR-0003 o seleccionar una nueva arquitectura para cumplir las decisiones, CORR-020 debe detenerse con `BLOCKER`.

---

## 26. Scope físico futuro

La futura ejecución de CORR-020 está limitada exactamente a:

```text
docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md
```

Contrato:

```text
expected modified existing paths =
EXACTLY 3

new product files =
NONE

deleted files =
NONE

renamed files =
NONE

fourth path =
PROHIBITED
```

No se modifica:

- `TASK-015`;
- `11-phase-1-scope-entry-gate.md`;
- ADR;
- migration;
- código;
- tests ejecutables;
- Supabase Cloud.

---

## 27. Blockers de futura ejecución

La ejecución documental de CORR-020 debe detenerse si ocurre cualquiera:

1. una fuente canónica obligatoria deja de estar disponible;
2. la identidad canónica de TASK-015 no coincide con el baseline autorizado;
3. aparece contradicción material entre `DECISION-001..006` y canon vigente;
4. una de las seis decisiones necesita modificarse;
5. se necesita una séptima decisión de producto material;
6. se necesita nuevo ADR;
7. se necesita reabrir ADR-0003;
8. se necesita modificar onboarding o bootstrap;
9. se necesita cambiar el role model;
10. se necesita cambiar multitenancy;
11. se necesita cambiar la arquitectura RLS;
12. se necesita provider workaround;
13. se necesita introducir una nueva `AuditEvent.action`;
14. se necesita modificar el modelo físico de `AuditEvent`;
15. se necesita un cuarto documento;
16. se necesita modificar `11-phase-1-scope-entry-gate.md`;
17. se necesita introducir diseño físico de concurrencia;
18. se necesita introducir SQL/RPC/migration/policy;
19. se detecta una decisión posterior que sustituye DECISION-001..006;
20. el diff propuesto altera requisitos ajenos al lifecycle.

Ante blocker:

```text
CORR-020 EXECUTION = BLOCKER
no silent repair
no scope expansion
no Git
no TASK-015 implementation
no TASK-016
RETURN TO REVISOR CENTRAL
```

---

## 28. Acceptance Criteria

**AC-020-001.** La especificación conserva exactamente el ID `CORR-020`.

**AC-020-002.** El título continúa siendo `CORR-020 — Sincronización normativa de DECISION-001..006 previa a implementación de TASK-015`.

**AC-020-003.** La futura corrección modifica exclusivamente `01-product-definition.md`, `02-domain-model.md` y `03-permissions-rls-strategy.md`.

**AC-020-004.** No se modifica un cuarto path.

**AC-020-005.** No se genera un archivo de producto nuevo.

**AC-020-006.** DECISION-001 queda reflejada coherentemente en baseline, dominio y autorización.

**AC-020-007.** Self-disable/self-revoke de `COMPANY_ADMIN` queda inequívocamente prohibido.

**AC-020-008.** DECISION-002 queda reflejada coherentemente en baseline, dominio y autorización.

**AC-020-009.** Self-role-change de `COMPANY_ADMIN` queda inequívocamente prohibido.

**AC-020-010.** Same-role self-target no se convierte en no-op autorizado.

**AC-020-011.** DECISION-003 queda reflejada coherentemente en baseline, dominio y autorización.

**AC-020-012.** Disable del último enabled `COMPANY_ADMIN` queda prohibido cuando dejaría cero administradores habilitados.

**AC-020-013.** Demotion del último enabled `COMPANY_ADMIN` queda prohibida cuando dejaría cero administradores habilitados.

**AC-020-014.** Una denegación por continuidad produce cero mutation y cero `AuditEvent`.

**AC-020-015.** DECISION-003 no modifica `FL-01`, onboarding, bootstrap ni creación inicial del primer `COMPANY_ADMIN`.

**AC-020-016.** DECISION-004 queda reflejada coherentemente en baseline, dominio y autorización.

**AC-020-017.** Role-change de membership disabled queda permitido sujeto a autorización y same-tenant.

**AC-020-018.** Role-change de membership disabled no modifica `is_enabled`.

**AC-020-019.** Role-change de membership disabled no restaura autoridad tenant.

**AC-020-020.** Un role-change disabled real conserva `USER_ROLE_CHANGED` como acción de auditoría existente.

**AC-020-021.** Reinstate usa el role vigente en la membership y no un role histórico.

**AC-020-022.** DECISION-005 queda reflejada coherentemente en baseline, dominio y autorización.

**AC-020-023.** Disable sobre disabled autorizado produce success `changed=false`, sin mutation ni `AuditEvent`.

**AC-020-024.** Reinstate sobre enabled autorizado produce success `changed=false`, sin mutation ni `AuditEvent`.

**AC-020-025.** Same-role non-self autorizado produce success `changed=false`, sin mutation ni `AuditEvent`.

**AC-020-026.** Actor inválido, actor disabled, role insuficiente, cross-tenant o self-target prohibido nunca se convierte en no-op success.

**AC-020-027.** Toda denegación de lifecycle produce cero `AuditEvent`.

**AC-020-028.** DECISION-006 queda reflejada coherentemente en baseline, dominio y autorización.

**AC-020-029.** Estado PostgreSQL vigente prevalece sobre estado stale de JWT/UI/caller.

**AC-020-030.** Actor, target, tenant, role e `is_enabled` se reevaluan conceptualmente antes de confirmar cuando exista concurrencia.

**AC-020-031.** Continuidad administrativa se reevalúa antes de confirmar.

**AC-020-032.** Actor que pierde autoridad antes de confirmar queda en `DENY`.

**AC-020-033.** La documentación no exige expected-state/version token del cliente.

**AC-020-034.** La documentación no selecciona row lock, advisory lock, isolation level, conditional update ni otro mecanismo físico de concurrencia.

**AC-020-035.** Same-tenant continúa siendo obligatorio.

**AC-020-036.** Conocer target ID no concede autorización.

**AC-020-037.** RLS continúa siendo obligatorio y frontera primaria de aislamiento remoto.

**AC-020-038.** RLS no se convierte en la única capa del caso de uso.

**AC-020-039.** No se abre ninguna write policy normativa nueva.

**AC-020-040.** `SUPER_ADMIN` continúa siendo identidad global sin bypass ordinario de lifecycle tenant.

**AC-020-041.** `SupportAccessGrant` no concede OP-01/02/03 por inferencia.

**AC-020-042.** Provider boundary de ADR-0003 queda preservado.

**AC-020-043.** CORR-020 no declara `provider-side termination = UNSUPPORTED` como norma general de producto.

**AC-020-044.** Provider failure/unavailability no restaura autorización.

**AC-020-045.** Estrategia offline general permanece sin cambios.

**AC-020-046.** No se crea outbox administrativo de memberships.

**AC-020-047.** Datos locales no se eliminan por disable/revoke mediante CORR-020.

**AC-020-048.** Las action names existentes de `AuditEvent` se preservan.

**AC-020-049.** No se introduce SQL, RPC, migration, `SECURITY DEFINER`, grants/revokes o RLS ejecutable.

**AC-020-050.** No se duplica el diseño técnico de TASK-015 dentro de los documentos de producto.

**AC-020-051.** No se modifica ningún requisito ajeno al lifecycle de `CompanyMembership`.

**AC-020-052.** No se modifica el modelo de roles.

**AC-020-053.** No se modifica multitenancy.

**AC-020-054.** No se modifica `VerificationChallenge`.

**AC-020-055.** No se modifica TASK-015.

**AC-020-056.** TASK-016 no se determina, genera ni inicia.

**AC-020-057.** La matriz de cambios contiene una fila por cada superficie propuesta para modificación.

**AC-020-058.** Las secciones inspeccionadas y no modificadas quedan listadas con justificación.

**AC-020-059.** Todos los AC anteriores deben resultar `PASS` antes de cerrar la ejecución documental.

**AC-020-060.** `CORR-020 DONE` no se interpreta como autorización de implementación de TASK-015.

---

## 29. Definition of Done

**DoD-020-001.** Esta especificación obtiene `CORR-020 SPEC REVIEW = APPROVED`.

**DoD-020-002.** Existe aprobación humana formal de la especificación.

**DoD-020-003.** Se genera el artefacto físico aprobado de CORR-020 mediante Gate separado.

**DoD-020-004.** El artefacto físico aprobado supera su revisión.

**DoD-020-005.** CORR-020 se canonicaliza mediante Gate separado.

**DoD-020-006.** La canonicalización supera revisión.

**DoD-020-007.** El artefacto canónico se incorpora a Git mediante Gate separado.

**DoD-020-008.** Existe autorización humana separada para ejecutar la corrección documental sobre los tres targets.

**DoD-020-009.** Preflight fresco confirma exactamente los tres targets y las fuentes canónicas vigentes.

**DoD-020-010.** La ejecución modifica exactamente `01-product-definition.md`, `02-domain-model.md` y `03-permissions-rls-strategy.md`.

**DoD-020-011.** No existe un cuarto path modificado.

**DoD-020-012.** El diff demuestra exclusivamente la sincronización de DECISION-001..006.

**DoD-020-013.** Review del diff documental = `APPROVED`.

**DoD-020-014.** Todos los `AC-020-001..060 = PASS`.

**DoD-020-015.** Staging se realiza sólo mediante Gate humano separado.

**DoD-020-016.** Commit se realiza sólo mediante Gate humano separado.

**DoD-020-017.** Push se realiza sólo mediante Gate humano separado.

**DoD-020-018.** El estado final de los tres documentos demuestra que la precondición documental de TASK-015 está satisfecha.

**DoD-020-019.** Existe cierre humano final de CORR-020.

**DoD-020-020.** El cierre mantiene explícitamente `CORR-020 DONE != TASK-015 IMPLEMENTATION AUTHORIZED`.

---

## 30. Plan futuro de ejecución documental

Sólo después de aprobar, canonicalizar e incorporar esta especificación y de recibir autorización humana separada de ejecución, el implementador autorizado deberá:

1. ejecutar preflight Git y documental fresco;
2. verificar las fuentes canónicas y la identidad vigente de TASK-015;
3. confirmar que no existe decisión posterior que sustituya DECISION-001..006;
4. confirmar que el scope continúa limitado a los tres paths;
5. leer íntegramente las versiones canónicas vigentes de `01`, `02` y `03`;
6. aplicar únicamente los cambios de la matriz de §14;
7. no modificar `RF-019`, §21.2 ni §19.5 salvo que el diff mínimo requiera únicamente una referencia no semántica; cualquier cambio material debe bloquear;
8. no modificar FL-01;
9. no introducir wording de mecanismo físico de TASK-015;
10. mantener IDs existentes y evitar renumeración;
11. añadir `INV-027..031` sólo si los IDs continúan libres y el preflight confirma que esa materialización no colisiona con cambios posteriores;
12. si `INV-027..031` ya estuvieran ocupados por una evolución canónica posterior, detenerse para revisión humana en lugar de renumerar por inferencia;
13. revisar consistencia cruzada entre los tres documentos;
14. verificar que provider/offline/SUPER_ADMIN permanecen preservados;
15. verificar que no aparecen nuevas action names;
16. ejecutar revisión de diff únicamente documental;
17. reportar los paths realmente modificados;
18. no hacer staging/commit/push sin Gates posteriores;
19. devolver evidencia al Revisor Central;
20. no iniciar TASK-015 ni determinar TASK-016.

---

## 31. Autorevisión final de especificación

```text
new product decision invented =
NO

new ADR required =
NO

architecture change =
NONE

domain expansion =
NONE

role model change =
NONE

multitenancy change =
NONE

RLS physical change =
NONE

provider contract change =
NONE

onboarding change =
NONE

offline strategy change =
NONE

TASK-015 technical design duplicated =
NO

target documents =
3

target paths =
EXACTLY 3

fourth path required =
NO

DECISION-001 consumed =
YES

DECISION-002 consumed =
YES

DECISION-003 consumed =
YES

DECISION-004 consumed =
YES

DECISION-005 consumed =
YES

DECISION-006 consumed =
YES

contradiction blocker =
NONE
```

---

## 32. Governance final

```text
CORR-020 SPECIFICATION =
APPROVED FOR EXECUTION

CORR-020 SPEC REVIEW =
APPROVED

CORR-020 HUMAN SPEC APPROVAL =
APPROVED

CORR-020 aprobada =
SÍ

CORR-020 canonicalizada =
NO

CORR-020 execution =
NOT AUTHORIZED

state =
APPROVED FOR EXECUTION

artifact =
CORR-020-task-015-product-decisions-documentation-sync-approved.md

repository writes =
NONE

target document modifications =
NONE

Codex =
NOT AUTHORIZED

TASK-015 implementation =
NOT AUTHORIZED

Supabase Cloud =
NO CHANGE

Git =
NO CHANGE

TASK-016 =
NOT DETERMINED / NOT GENERATED / NOT STARTED

next gate =
CORR-020 APPROVED ARTIFACT REVIEW
```

`APPROVED FOR EXECUTION` acredita exclusivamente aprobación humana de la especificación.

No autoriza:

- ejecutar CORR-020;
- modificar los tres documentos target;
- implementar TASK-015;
- usar Codex;
- modificar el repositorio;
- tocar Supabase Cloud;
- hacer Git;
- iniciar el siguiente incremento.

**RETURN TO REVISOR CENTRAL.**
