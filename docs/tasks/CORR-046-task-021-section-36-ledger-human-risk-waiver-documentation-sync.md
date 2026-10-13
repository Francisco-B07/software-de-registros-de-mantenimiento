# CORR-046 — TASK-021 §36 Ledger and §36.28 Human Risk-Waiver Documentation Sync

> **ID:** CORR-046.
>
> **Ruta canónica propuesta:** `docs/tasks/CORR-046-task-021-section-36-ledger-human-risk-waiver-documentation-sync.md`.
>
> **Fuente documental humana aprobada:** `TASK-021-propuesta-consolidada-corregida.md`.
>
> **SHA-256 de la fuente aprobada:** `84aedf10af8ac1149e30a066adc5cd82ec50cb22c419ba0a12581b054801d090`.
>
> **Fecha de ejecución documental:** 2026-10-13.
>
> **Estado:** DOCUMENTARY EXECUTION / LOCAL WORKTREE CREATED / PENDING REVIEW / NOT CANONICALLY INCORPORATED.

## 1. Objeto y límite estricto

Esta corrección documental sincroniza, sin alterar implementación ni contratos técnicos:

1. el ledger individual reconciliado de las 31 verificaciones de TASK-021 §36;
2. el agregado vigente de 18 `PASS`, 13 `PENDING` y 0 `FAIL`;
3. la aceptación humana del riesgo residual de omitir exclusivamente la regresión TASK-013 exigida por §36.28;
4. la distinción normativa entre `WAIVED` y un `PASS` técnico inexistente;
5. las doce verificaciones distintas de §36.28 que continúan siendo obligatorias;
6. el estado administrativo de CORR-045, sin inventar cierre técnico;
7. el estado corriente de TASK-021, Phase 2 y Phase 3.

La creación local de este archivo no hace efectivo el waiver. Su revisión, aprobación e incorporación canónica requieren Gates posteriores independientes. No se autoriza en este documento ninguna prueba, implementación, operación Supabase, staging, commit ni push.

## 2. Procedencia y autoridad documental

La base de esta incorporación es el artefacto humano aprobado `TASK-021-propuesta-consolidada-corregida.md`, verificado físicamente antes de escribir con el SHA-256 declarado arriba.

Fuentes canónicas y antecedentes preservados:

- `docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md`: §36, §37, AC-021-159 y DoD-021-052/054/061/062.
- `docs/tasks/CORR-043-task-021-hosted-concurrency-harness-safety-correction.md`: evidencia reseñada de canary y concurrencia.
- `docs/tasks/CORR-044-task-021-corr-043-current-state-documentation-sync.md`: sincronización documental posterior a CORR-043.
- `docs/tasks/CORR-045-corr-023-targeted-task-013-regression-selection-compatibility.md`: incompatibilidad de selección del rerun y estado administrativo abierto.
- `docs/product/11-phase-1-scope-entry-gate.md`: registro de estado corriente.
- ADR-0019 y ADR-0022, sin modificaciones.
- Informes documentales anteriores de inventario y reconciliación de TASK-021 §36.
- Decisión humana aprobada de aceptación de riesgo limitada a §36.28.

La evidencia histórica reseñada conserva sus límites: parte de los outputs brutos no está versionada y este documento no convierte una referencia documental en una nueva ejecución.

## 3. Estado efectivo antes de la incorporación canónica

```text
TASK-021 §36 total = 31
TASK-021 §36 PASS = 18
TASK-021 §36 PENDING = 13
TASK-021 §36 current FAIL = 0

§36.28 = PENDING
§36.28 HUMAN RESIDUAL-RISK ACCEPTANCE = APPROVED DOCUMENTALLY
§36.28 CANONICAL WAIVER = NOT YET INCORPORATED / NOT EFFECTIVE
§36.28 TECHNICAL PASS = NO

§36.28 targeted rerun budget consumed = 0 / 1
§36.28 targeted rerun budget remaining = 1
automatic retry = 0

TASK-021 Work Item I = NOT COMPLETE
F-021-I-001 = OPEN
TASK-021 = NOT DONE / NOT CLOSED
CORR-045 = SUSPENDED / NO TECHNICAL CLOSURE
Phase 2 = IN PROGRESS / NOT CLOSED
Phase 2 Exit Gate = NOT DEFINED
Phase 3 = NOT STARTED
TASK-022 = NOT DETERMINED / NOT STARTED
```

El agregado vigente `FAIL = 0` no borra ni reetiqueta el intento histórico fallido/incompleto de §36.28. El estado corriente `PENDING` representa que el rerun completo no fue obtenido y que el waiver todavía no fue incorporado canónicamente.

## 4. Historial exacto de §36.28

### 4.1 Intento histórico

La evidencia recuperada registra:

```text
§36.28 HISTORICAL ATTEMPT = FAILED / INCOMPLETE
planned assertions = 72
executed assertions = 65
observed error = permission denied to set role "supabase_auth_admin"
bad plan = planned 72 / ran 65
complete TASK-013 regression PASS = NO
```

Este antecedente demuestra una ejecución incompleta por contexto/privilegios. No demuestra por sí solo un defecto funcional de TASK-013, pero tampoco demuestra ausencia de defectos. Permanece como `FAILED / INCOMPLETE` y nunca se convierte retroactivamente en `PASS`.

### 4.2 Rerun posterior

El intento posterior de ejecutar selectivamente la regresión mediante CORR-023/CORR-045 se detuvo por incompatibilidad entre el alcance autorizado y la ejecución integral del runner:

```text
LATER TARGETED RERUN = BLOCKED BEFORE DB
database connection opened = NO
complete targeted execution = NO
technical PASS = NO
rerun budget consumed = 0 / 1
rerun budget remaining = 1
§36.28 current canonical disposition = PENDING
```

Son estados distintos y no intercambiables:

```text
historical attempt FAILED / INCOMPLETE (65/72)
!= later targeted rerun BLOCKED BEFORE DB
!= accepted residual-risk waiver
!= technical PASS
```

## 5. Decisión humana y representación del waiver

La autoridad humana aprobó documentalmente aceptar el riesgo residual de no obtener una regresión completa satisfactoria de TASK-013 exclusivamente para TASK-021 §36.28.

### 5.1 Estado presente

```text
§36.28 = PENDING
risk acceptance = HUMAN APPROVED DOCUMENTALLY
canonical waiver = NOT EFFECTIVE
technical PASS = NO
```

### 5.2 Estado futuro condicionado

Sólo después de revisión, aprobación e incorporación canónica separadas podrá representarse:

```text
§36.28 = WAIVED BY EXPLICIT HUMAN RESIDUAL-RISK ACCEPTANCE
historical attempt = FAILED / INCOMPLETE (65/72)
later targeted rerun = NOT COMPLETED
technical PASS = NO
waiver scope = TASK-021 §36.28 ONLY
```

`WAIVED` constituye una disposición humana de riesgo, no una certificación técnica y no equivale a `PASS`.

### 5.3 Alcance, vigencia y revaluación

- **Alcance:** exclusivamente la ausencia de un nuevo `PASS` completo de TASK-013 para TASK-021 §36.28 en la baseline evaluada.
- **Riesgo residual:** una regresión de TASK-013, Auth bridge, roles o sesión puede permanecer sin detectar por la prueba omitida.
- **Responsable:** la autoridad humana del proyecto que expresó y aprobó la decisión; la identificación formal y su facultad de aceptar el riesgo deben conservarse en el expediente de revisión.
- **Vigencia:** limitada al cierre de TASK-021 respecto de esta baseline; no es una dispensa permanente ni un precedente para otras tareas o verificaciones.
- **Revaluación:** obligatoria ante cambios de TASK-013, fallos Auth/RLS/sesión, evidencia contradictoria, evaluación del Phase 2 Exit Gate o uso de la excepción como fundamento para Staging, Production o piloto.

La revaluación no autoriza automáticamente una prueba ni consume el presupuesto `0/1`.

## 6. Impacto normativo limitado

| Superficie | Tratamiento documentado |
| --- | --- |
| TASK-021 §36.28 | Preservar el intento 65/72, el rerun bloqueado y la futura disposición `WAIVED`, sin `PASS` técnico |
| TASK-021 §37 | Permitir, sólo tras incorporación válida, una disposición humana excepcional para la obligación identificada; no convertirla en regla general |
| AC-021-159 | Mantener la obligación original y trazar la excepción específica; no sustituirla por `PASS` |
| DoD-021-054 | Eximir únicamente el componente TASK-013 para esta baseline; mantener las demás regresiones |
| DoD-021-052 | Mantener la obligación de pruebas DB/RLS relevantes |
| DoD-021-061 | Mantener la verificación Hosted completa dentro del alcance esperado |
| DoD-021-062 | Mantener la aprobación de revisión Hosted |
| Work Item I / F-021-I-001 | Mantener abiertos hasta resolver las otras doce verificaciones y hacer efectivo el waiver |
| CORR-045 | Proponer disposición administrativa por waiver; preservar historia, bloqueo, presupuesto y ausencia de cierre técnico |
| Registro de estado | Sincronizar estado actual y futuro condicionado sin adelantar efectos canónicos |

La excepción no sustituye DoD-021-052, DoD-021-061 ni DoD-021-062. Tampoco convierte AC-021-159 o el componente TASK-013 de DoD-021-054 en `PASS` técnico.

## 7. Ledger reconciliado 31/31

Los resultados siguientes son una reconciliación documental de evidencia preexistente, no una nueva ejecución.

| §36 | Verificación | Estado vigente | Evidencia localizada / límite |
| ---: | --- | --- | --- |
| 1 | Migration aplicada exactamente una vez | PASS histórico | Matriz humana/review-approved; output bruto no versionado |
| 2 | Contrato físico `auth_subject_authority_anchors` | PASS histórico | Matriz reconciliada; output bruto no versionado |
| 3 | Contrato físico `later_user_initial_session_coordinations` | PASS histórico | Matriz reconciliada; output bruto no versionado |
| 4 | PK, uniques, single-active constraints e índices | PASS histórico | Matriz reconciliada; output bruto no versionado |
| 5 | Constraints de lifecycle y terminales | PASS histórico | Matriz reconciliada; output bruto no versionado |
| 6 | Grants y revokes esperados | PASS histórico | Matriz reconciliada; output bruto no versionado |
| 7 | Sin tabla/columna/RLS tenant inesperada | PASS histórico | Matriz reconciliada; output bruto no versionado |
| 8 | Sin privilegios tenant/application para `supabase_auth_admin` | PASS histórico | Matriz reconciliada; output bruto no versionado |
| 9 | `createUser(id=...)` exacto | PASS | Canary CORR-043 aprobado |
| 10 | `getUserById(expected_uuid)` exacto | PASS | Canary CORR-043 aprobado |
| 11 | Reserva/reconciliación de subject no vinculado | PENDING | Requiere evidencia Hosted funcional real |
| 12 | Conflict + ID ausente → repair, sin enumeración | PENDING | Requiere evidencia Hosted funcional real |
| 13 | Binding exacto provider subject / Auth bridge | PENDING | Requiere evidencia Hosted funcional real |
| 14 | Compatibilidad y activación atómica `ISSUANCE_ACTIVE` | PENDING | Requiere evidencia Hosted funcional real |
| 15 | Ningún DB lock durante provider I/O | PASS | Prueba TASK-021 `7/7 PASS`; PASS histórico número 18 |
| 16 | SessionGrant single-use bajo concurrencia real | PENDING | Requiere prueba concurrente real; CORR-043 no la sustituye |
| 17 | Hook limitado a coordinación/grant platform-owned | PASS histórico | Matriz reconciliada; output bruto no versionado |
| 18 | Recheck terminal antes de browser propagation | PENDING | Evidencia local favorable insuficiente; falta demostración Hosted específica |
| 19 | Denegar membership incompatible/disabled/cross-tenant | PENDING | Negativa de seguridad real no ejecutada |
| 20 | Denegar `SUPER_ADMIN` en later-user tenant path | PENDING | Negativa de seguridad real no ejecutada |
| 21 | Aislamiento tenant vía Data API / RLS | PENDING | Validación DB/RLS real no ejecutada |
| 22 | Sesión Auth sin membership no concede tenant authority | PENDING | Negativa de seguridad real no ejecutada |
| 23 | Concurrencia cross-flow TASK-019/CORR-035 y alias | PASS | CORR-043 Hosted review aprobado |
| 24 | Writers authority-increasing TASK-015 | PASS | CORR-043 Hosted review aprobado |
| 25 | Sin `40P01` ni hang | PASS | CORR-043 Hosted review aprobado |
| 26 | Negativas de bypass público de Auth | PENDING | Negativa de seguridad real no ejecutada |
| 27 | Compatibilidad de technical-password policy | PASS | Canary CORR-043 aprobado |
| 28 | Regresiones TASK-013 | PENDING; waiver humano no incorporado | Histórico 65/72 FAILED/INCOMPLETE; rerun posterior bloqueado antes de DB; presupuesto 0/1 |
| 29 | Regresiones TASK-020 | PENDING | Aplicación `21/21 PASS`; falta segmento DB pgTAP |
| 30 | Cleanup sin eliminar stable subject anchors | PASS | CORR-043 global cleanup review; `F-021-I-006 = RESOLVED` |
| 31 | Sin mutación Staging/Production | PASS histórico | Matriz y post-state reportados; output bruto no versionado |

### 7.1 Recuento auditado

```text
PASS (18) = §36.1–10, §36.15, §36.17, §36.23–25, §36.27, §36.30–31
PENDING (13) = §36.11–14, §36.16, §36.18–22, §36.26, §36.28, §36.29
current FAIL = 0
total = 31
```

El resultado histórico 65/72 de §36.28 permanece fuera del recuento de `FAIL` vigente, pero dentro de su historia inmutable.

### 7.2 Las doce pendientes distintas de §36.28

```text
§36.11, §36.12, §36.13, §36.14,
§36.16,
§36.18, §36.19, §36.20, §36.21, §36.22,
§36.26,
§36.29
```

La aceptación humana de riesgo sobre §36.28 no exime ninguna de estas doce verificaciones. Todas requieren evidencia de ejecución real antes de poder declararse `PASS`.

## 8. Plan mínimo futuro para las doce pendientes

1. **Provider/coordination — §36.11–14:** ejecutar evidencia Hosted de reserva/reconciliación, resolución de conflictos sin enumeración, binding exacto y activación atómica.
2. **Concurrencia — §36.16:** demostrar SessionGrant single-use bajo concurrencia real.
3. **Auth/session/RLS negativas — §36.18–22 y §36.26:** completar recheck terminal y denegaciones de membership, `SUPER_ADMIN`, Data API/RLS, sesión sin autoridad tenant y bypass público Auth.
4. **TASK-020 DB — §36.29:** preservar `21/21 PASS` de aplicación y ejecutar sólo el segmento DB pgTAP faltante bajo autorización posterior.

Este plan no concede autorización de ejecución ni cambia ningún estado actual.

## 9. Disposición administrativa propuesta de CORR-045

La investigación CORR-045 permanece suspendida y sin cierre técnico. Tras la eventual incorporación canónica del waiver podrá cerrarse administrativamente con una fórmula equivalente a:

```text
CORR-045 = CLOSED ADMINISTRATIVELY BY SUPERSEDING HUMAN RISK DISPOSITION
technical selector resolution = NO
technical regression PASS = NO
historical evidence preserved = YES
rerun budget consumed = 0/1
```

Hasta entonces:

```text
CORR-045 = SUSPENDED / NO TECHNICAL CLOSURE
```

No se modifica el runner ni se simula una resolución técnica.

## 10. Seguridad, Auth, RLS y multitenancy

```text
product/domain change = NO
Auth implementation change = NO
RLS change = NO
tenant isolation change = NO
privilege/grant change = NO
schema/migration change = NO
UI/offline behavior change = NO
Supabase Local/Hosted/Staging/Production mutation = NO
```

Permanecen íntegros los contratos de autenticación, autorización, aislamiento multiempresa, privilegios, `supabase_auth_admin`, Custom Access Token Hook, SessionGrant single-use y RLS. Una sesión Auth válida no equivale a autorización tenant. La excepción no habilita bypasses, no cambia roles y no sustituye controles negativos de seguridad.

## 11. Estados antes y después de una futura incorporación

### 11.1 Estado efectivo al crear este archivo local

```text
CORR-046 local artifact = CREATED / PENDING REVIEW
CORR-046 canonical incorporation = NOT COMPLETE
§36.28 = PENDING
§36 PASS = 18
§36 PENDING = 13
§36 WAIVED = 0
§36 current FAIL = 0
TASK-021 Work Item I = NOT COMPLETE
F-021-I-001 = OPEN
TASK-021 = NOT DONE / NOT CLOSED
Phase 2 = IN PROGRESS / NOT CLOSED
Phase 3 = NOT STARTED
TASK-022 = NOT DETERMINED / NOT STARTED
```

### 11.2 Estado futuro inmediatamente después de una incorporación canónica aprobada

```text
§36 PASS = 18
§36 PENDING = 12
§36 WAIVED = 1 (§36.28)
§36 current FAIL = 0
§36.28 technical PASS = NO
TASK-021 Work Item I = NOT COMPLETE
F-021-I-001 = OPEN
TASK-021 = NOT DONE / NOT CLOSED
```

La incorporación del waiver por sí sola no cierra TASK-021: las doce verificaciones restantes y los demás AC/DoD continúan vigentes.

### 11.3 Estado objetivo condicionado

Sólo si las doce pendientes restantes obtienen evidencia real aprobada y se satisfacen todos los demás criterios:

```text
§36 PASS = 30
§36 WAIVED = 1 (§36.28)
§36 PENDING = 0
§36 current FAIL = 0
```

Este estado no se declara presente.

## 12. Criterios de aceptación documental

- El ledger contiene exactamente 31 verificaciones.
- El agregado vigente permanece `18 PASS / 13 PENDING / 0 FAIL`.
- El intento histórico §36.28 permanece `FAILED / INCOMPLETE`, 65/72, con el error de rol preservado.
- El rerun posterior permanece diferenciado como bloqueado antes de DB y el presupuesto continúa `0/1` consumido.
- La aceptación humana no se representa como `PASS` técnico.
- El waiver queda limitado a §36.28 y no entra en vigor por crear este archivo.
- Las doce verificaciones restantes permanecen obligatorias.
- §37, AC-021-159 y DoD-021-054 conservan trazabilidad; DoD-021-052/061/062 no se eximen.
- CORR-045 no adquiere cierre técnico ficticio.
- TASK-021, Work Item I y F-021-I-001 permanecen abiertos.
- Auth, RLS, roles, privilegios y multitenancy no cambian.
- Phase 2 permanece abierta; Phase 3 y TASK-022 no comienzan.

## 13. Resultado de esta ejecución documental

```text
CORR-046 DOCUMENTARY EXECUTION = LOCAL WORKTREE CREATED / PENDING REVIEW
CANONICAL SOURCE IDENTITY = VERIFIED
CORR-046 CANONICAL INCORPORATION = NOT COMPLETE
§36.28 HUMAN RISK ACCEPTANCE = APPROVED DOCUMENTALLY
§36.28 CANONICAL WAIVER = NOT EFFECTIVE
§36.28 TECHNICAL PASS = NO
TASK-021 = NOT DONE / NOT CLOSED
Phase 2 = IN PROGRESS / NOT CLOSED
Phase 3 = NOT STARTED
TASK-022 = NOT DETERMINED / NOT STARTED
STAGING = NOT PERFORMED
COMMIT = NOT PERFORMED
PUSH = NOT PERFORMED
SUPABASE MUTATION = NONE
```

**NEXT GATE:** revisión humana del diff documental local. No existe autorización automática para staging, commit, push, pruebas, Supabase, cierre de TASK-021 ni inicio de otra tarea.
