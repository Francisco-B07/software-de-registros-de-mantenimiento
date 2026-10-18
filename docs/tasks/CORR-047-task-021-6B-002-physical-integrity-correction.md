# CORR-047 — Corrección de integridad física 6B-002 / TASK-021 §36.29

> **Identificador CORR:** `CORR-047` = **HUMAN CONFIRMED IDENTIFIER**. Era el primer identificador no observado en el inventario READ-ONLY de Codex (001–046). La confirmación humana del ID NO constituye aprobación de especificación, canonicalización ni implementación.
>
> **Identidad de este archivo:** ARTEFACTO CANÓNICO DOCUMENTAL / EXTERNO AL REPOSITORIO / GENERADO / PENDIENTE DE REVISIÓN INDEPENDIENTE DE CANONICALIZACIÓN / NO INCORPORADO.
>
> **Estado:** CORR-047 HUMAN SPEC APPROVAL = APPROVED / CENTRAL SPEC RE-REVIEW = APPROVED / APPROVED ARTIFACT REVIEW = APPROVED / CANONICAL ARTIFACT GENERATION = PASS / CANONICALIZATION REVIEW = PENDING / REPOSITORY INCORPORATION = NOT AUTHORIZED / IMPLEMENTATION = NOT AUTHORIZED.
>
> **Autorización humana recibida:** determinación y preparación documental READ-ONLY de 6B-002; confirmación de CORR-047; revisión de especificación con `CORR-047 CENTRAL SPEC RE-REVIEW = APPROVED`; aprobación humana formal de la especificación v4 identificada por SHA-256 `06d61668a3bab9c6695e671744153f67239cd766cfb15b64da8fa2cacd963c2f`; generación del artefacto documental aprobado y revisión independiente posterior con `CORR-047 APPROVED ARTIFACT REVIEW = APPROVED`; autorización humana posterior exclusivamente para generar este artefacto canónico externo desde el artefacto aprobado SHA-256 `75add231636924879f329afac8d77349e45169383bdbca9b6f8d4a3ecebef066`. Ninguna de estas autorizaciones habilita implementación, incorporación al repositorio o cambios de Supabase.
>
> **Fecha de redacción:** 2026-10-17.
>
> **Fase:** Phase 2 — multitenancy, autenticación, roles y RLS; NO CERRADA.
>
> **Objeto:** TASK-021 — Authoritative Later-User Auth Identity Reconciliation and Initial Session Establishment Foundation.

---

## 1. Gobierno, límites y autoridad

La presente especificación no constituye aprobación de implementación, autorización de modificación del repositorio, autorización de mutación de Supabase, autorización de pruebas DB, autorización de ejecución pgTAP, aprobación de cierre de TASK-021 ni decisión de avanzar de fase.

**Acciones realizadas en esta preparación:** lectura de fuentes documentales adjuntas, contraste de hallazgo y elaboración de este archivo externo. **No** se ha ejecutado Codex, SQL de escritura, migración, pgTAP, `git add`, commit ni push.

El inventario READ-ONLY posterior de Codex encontró 48 documentos `CORR`, 46 identificadores únicos `CORR-001` a `CORR-046`, sin huecos numéricos, con colisiones preexistentes de `CORR-041` y `CORR-042`. `CORR-047` fue el primer identificador no observado y **ya fue confirmado expresamente por la autoridad humana**. La aprobación humana de la especificación y la revisión independiente del artefacto aprobado ya constan `APPROVED`. La ruta canónica `docs/tasks/CORR-047-task-021-6B-002-physical-integrity-correction.md` no presenta colisión en el inventario READ-ONLY disponible; este archivo canónico externo requiere revisión independiente antes de su eventual incorporación. Antes de incorporarlo debe repetirse el preflight Git por posible concurrencia de cambios.

Ningún resultado `PASS DE INSPECCIÓN` de este expediente es equivalente a `CANONICAL EQUIVALENCE = PASS`, `HOSTED TESTS = PASS` o `TASK-021 = DONE`.

## 2. Fuentes, procedencia y nivel de verificación

### 2.1 Fuente primaria físicamente verificada aquí

- `docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md` (copia adjunta). SHA-256 real de bytes en este entorno: `d0106d83633b616099f6772702ee80f4700115186e938047e19a81edba865c43`.
- Apartados determinantes: §15.2 (nulabilidad y significado), §15.3 (nueve estados), §15.4 (invariantes y vínculos inmutables), §15.8–15.9 (boundary platform-owned y RPC), §35.2 (DB tests), §35.8 (seguridad multiempresa), §35.10–35.12 (regresiones y Hosted), §36 (verificaciones), AC-021-085..105, AC-021-171..213, DoD-021-021, 052, 061, 062.

### 2.2 Informe Codex de inspección READ-ONLY

- Archivo recibido: `Markdown pegado.md`, título «TASK-021 §36.29 — Contraste canónico del hallazgo 6B-002». SHA-256 de la copia recibida: `1ff0acb273632da8ed58bd1fc685c7bb9a3c868930f0624aa26b94dfa254ca0c`.
- Identidad de fuentes **reportada por Codex y verificada ahora de manera independiente contra los bytes físicos de los tres adjuntos**. El estado Git sigue siendo una observación declarada por Codex, no una inspección Git fresca hecha aquí:
  - ADR-0022 `docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md`, SHA reportado `1221f653d59c44af691ea314f77660b9f66e2f691cfc4fc2afd96e3891fe7e9c`.
  - Migración `supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql`, SHA reportado `f6862b27e74e4a3da81c96ea316d24451c812bcf4e4a2dea89cf12e558ca8e9f`, reportada **UNTRACKED**.
  - Test `supabase/tests/database/task_021_later_user_auth_identity_session_foundation.test.sql`, SHA reportado `860bac67b53f3e594354165e9e94aaa5da3ed0d5a4836427bbd2daf155267f33`, reportado **UNTRACKED**.
  - Contexto Git reportado: branch `main`, HEAD `b1ec60f012da50fbae5a94b58fca23632aba8f6b`.
- Las rutas y hashes del informe son evidencia **declarada por Codex**, no equivalencia independiente probada aquí contra el repositorio actual.

### 2.3 Evidencia observacional Hosted Development aportada por la autoridad humana

- Tabla: `public.later_user_initial_session_coordinations`, 13 columnas. `expected_auth_subject_id` es `NOT NULL`; `reserved_auth_subject_id` y `confirmed_auth_subject_id` son anulables; `state` es `NOT NULL`.
- Se observaron en `pg_get_constraintdef` las restricciones `task_021_coordination_confirmed_state_check` y `task_021_coordination_unknown_state_check` con comparaciones `=` sensibles a `NULL`.
- Trigger habilitado: `task_021_coordination_bindings_immutable`, `BEFORE UPDATE`, función `private.task_021_coordination_bindings_immutable()` (`SECURITY INVOKER`, `search_path=''`).
- `supabase_migrations.schema_migrations` incluye la versión `20261005042801`, nombre `task_021_later_user_auth_identity_session_foundation`, `statements` presente, 70 elementos. **Registro de versión ≠ equivalencia fuente ↔ Hosted**.
- Los inventarios de RLS, grants, privilegios de tabla/columna y ejecución completaron sus inspecciones; ello no certifica por sí solo que todos los objetos ejecutables del entorno y su provenance sean equivalentes.
- El resultado READ-ONLY del trigger descartó para las columnas protegidas con `<>` un bypass por transición a `NULL`: las correspondientes columnas son `NOT NULL`; `reserved_auth_subject_id` se compara con `IS DISTINCT FROM`.

### 2.4 Resultado de recuperación de fuentes y precondiciones restantes

**PREFLIGHT DE IDENTIDAD DE FUENTES ADJUNTAS = PASS (3/3).** Inspección de bytes realizada en 2026-10-17:

| Adjunto físico | Bytes | SHA-256 físico comprobado | Coincide con Codex |
|---|---:|---|---|
| `ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md` | 93.826 | `1221f653d59c44af691ea314f77660b9f66e2f691cfc4fc2afd96e3891fe7e9c` | SÍ |
| `20261005042801_task_021_later_user_auth_identity_session_foundation.sql` | 52.643 | `f6862b27e74e4a3da81c96ea316d24451c812bcf4e4a2dea89cf12e558ca8e9f` | SÍ |
| `task_021_later_user_auth_identity_session_foundation.test.sql` | 7.957 | `860bac67b53f3e594354165e9e94aaa5da3ed0d5a4836427bbd2daf155267f33` | SÍ |

Las tres fuentes son LF puro y tienen newline final. Se comparó físicamente la migración con el reporte READ-ONLY de catálogos Hosted aportado: la nulabilidad de las 13 columnas, el trigger y las dos definiciones `CHECK` relevantes son consistentes con lo observado; esta comprobación acotada **NO** constituye equivalencia de código/DDL desplegado total (B-1).

La migración contiene `task_021_coordination_confirmed_state_check` en las líneas 60–69 y `task_021_coordination_unknown_state_check` en las líneas 70–77; ambas permiten resultado `UNKNOWN` en ausencia del sujeto requerido. El test adjunto tiene comprobaciones de estructura, grants, Hook, coordinación y una prueba negativa de PK del anchor (líneas 136–141), pero **no prueba el rechazo específico** de `NULL` en los estados señalados.

**Inventario repo/Git posterior recibido (READ-ONLY, informe Codex 2026-10-17):** inventario CORR, estado Git de artefactos, estado posterior de ADR-0022 y ledger §36 fueron inspeccionados; véase §2.5. Este resultado **cierra la ausencia de inventario como fuente para redactar esta especificación de CORR-047, cuyo identificador fue confirmado posteriormente**, pero no resuelve el bloqueo material de procedencia Git B-3 ni prueba B-1/B-2 ni sustituye un preflight fresco inmediatamente antes de una futura implementación. El encabezado histórico `PROPOSED` de ADR-0022 fue superado por su incorporación canónica posterior; no editarlo implícitamente.

### 2.5 Inventario Git, numeración y gobernanza posteriores — evidencia Codex READ-ONLY

Informe físico adjunto: `Markdown pegado.md`, encabezado `TASK-021 §36.29 — INFORME READ-ONLY PREVIO A CORRECCIÓN 6B-002`; SHA-256 del informe recibido en esta conversación: `4ea8e686945c324b52b6d19a038e10757042bf236dfffe74dde31b2491b32187`. Sus observaciones del repositorio **son declaradas por Codex**; esta revisión contrastó por bytes las copias de TASK-021, ADR-0022, migración y test, pero no tuvo acceso directo al `.git` del usuario.

| Control | Evidencia READ-ONLY comunicada | Disposición |
|---|---|---|
| Git | `main`, `HEAD = origin/main = b1ec60f012da50fbae5a94b58fca23632aba8f6b`, divergencia `0 0` | Snapshot informado; referencia remota local, no verificación de red |
| Worktree | 7 tracked modified; 10 untracked; staged = NONE | **No está limpio; no incorporar archivos por inferencia** |
| TASK-021 specification | tracked/clean, SHA `d0106d83633b616099f6772702ee80f4700115186e938047e19a81edba865c43` | Contrato vigente usado |
| TASK-021 migration/test | ambos untracked, SHA `f6862b27e74e4a3da81c96ea316d24451c812bcf4e4a2dea89cf12e558ca8e9f` y `860bac67b53f3e594354165e9e94aaa5da3ed0d5a4836427bbd2daf155267f33` | B-3 **bloqueado**; no staging/commit implícito |
| CORR inventory | 48 archivos, 46 IDs, rango 001–046, 041/042 duplicados | `CORR-047` **HUMAN CONFIRMED IDENTIFIER**; especificación y revisión del artefacto aprobado = `APPROVED` (Gates posteriores al snapshot); ruta exacta sin colisión en el inventario disponible |
| ADR-0022 | SHA `1221f653d59c44af691ea314f77660b9f66e2f691cfc4fc2afd96e3891fe7e9c`; tracked/clean; incorporación `3bb6b34299eb512d93f2478306f1095d768b8233` | **HUMAN APPROVED / CANONICALIZED / DONE-CLOSED** según canon posterior; los metadatos `PROPOSED` dentro del archivo son históricos |
| Registro maestro ADR | `docs/product/10-architecture-decisions-records.md` no incluye ADR-0022 | Drift documental separado; no editar en esta corrección sin autorización |
| Correcciones 041–046 | Ninguna migra ni corrige 6B-002; CORR-043 aparece untracked | Scope 6B-002 permanece; no inferir cierre de CORR-043 |
| §36.29 | PENDING, segmento DB pgTAP de TASK-020 faltante | Sigue obligatorio; no ejecutado |
| §36.28 | El `0/1` documentado corresponde a este apartado, no a §36.29 | No transferir su contador/waiver a §36.29 |

**Distinción de autoridad:** el expediente conversacional del Revisor Central registra una autorización humana puntual de un intento de pgTAP para §36.29 que no fue ejecutado. Codex no encontró un registro equivalente de ese contador/autorización en `docs/`. No afirmar por ello que `0/1` sea un contador **canónico de §36.29**; tampoco confundir la ausencia documental con autorización de ejecutar. El Gate de ejecución sigue **BLOCKED** por B-1/B-2/B-3/B-4 y el hallazgo 6B-002.

**Ledger histórico:** el reporte indica que §36.3 y §36.5 conservan `PASS histórico` aunque el defecto de integridad ahora está demostrado. Preservar la evidencia histórica, pero exigir disposición explícita del hallazgo y nuevas verificaciones; no declararlos `PASS actual` ni reescribirlos silenciosamente.

## 3. Problema confirmado 6B-002

Las siguientes reglas **ya están aprobadas** por TASK-021 §15.4:

- Para `PROVISIONING_UNKNOWN`: `reserved_auth_subject_id` debe estar presente, debe coincidir con `expected_auth_subject_id` y `confirmed_auth_subject_id` debe ser `NULL`.
- Para `SUBJECT_CONFIRMED`, `ISSUANCE_ACTIVE`, `GATE_CONSUMED`, `SESSION_ESTABLISHED_NO_AUTHORITY`: `confirmed_auth_subject_id` debe estar presente y debe coincidir con `expected_auth_subject_id`.
- Siempre que exista un `reserved_auth_subject_id` o `confirmed_auth_subject_id`, tiene que corresponder al sujeto esperado de esa operación.

Las restricciones físicas observadas usan predicados que pueden evaluar a `UNKNOWN`/`NULL` para los casos de presencia requerida. PostgreSQL rechaza una fila por `CHECK` sólo cuando la expresión es `FALSE`, no cuando es `UNKNOWN`.

**Contraejemplos lógicos, no escrituras ejecutadas:**

1. `state=PROVISIONING_UNKNOWN`, `reserved_auth_subject_id=NULL`, `confirmed_auth_subject_id=NULL`: el `CHECK` de estado observado evalúa a `UNKNOWN` y no garantiza presencia del reservado.
2. `state=SUBJECT_CONFIRMED` —y por analogía los otros tres estados confirmados—, `confirmed_auth_subject_id=NULL`: el `CHECK` confirmado observado evalúa a `UNKNOWN` y no garantiza presencia del confirmado.

**Alcance de la contradicción:** integridad autónoma de la tabla. Las rutas de escritura respaldadas por el informe Codex resultan consistentes con las invariantes de presencia. No se ha demostrado fuga multiempresa, ejecución de escritura inválida en Hosted ni explotación a través de boundaries autorizadas. Tampoco se ha demostrado equivalencia completa de código desplegado y fuentes.

La insuficiencia física es relevante aun cuando los flujos operativos presentes validen la entrada, porque un futuro writer defectuoso o una escritura privilegiada podría conservar una combinación inválida.

## 4. Decisión de alcance mínimo candidata

**Objetivo:** cerrar exactamente la brecha de **presencia física obligatoria** de sujetos, preservando las restricciones actuales de coincidencia con `expected_auth_subject_id` y de nulabilidad permitida en otros estados.

**Cambio funcional/producto:** NINGUNO.

**Cambio de dominio:** NINGUNO; se materializa una regla ya aprobada.

**Cambio arquitectónico:** NO PREVISTO; no crear ADR nuevo salvo que la inspección completa identifique una nueva decisión sustantiva.

**Cambio físico esperado para una futura implementación autorizada:** UNA migración **nueva, forward-only**, que introduzca verificaciones adicionales estrechas de presencia sobre `public.later_user_initial_session_coordinations`. Diseño candidato preferido: restricciones suplementarias independientes, que obliguen a evaluar `FALSE` —y no `UNKNOWN`— cuando el sujeto requerido esté ausente, manteniendo intactas las verificaciones de igualdad previamente instaladas. Esta preferencia queda sujeta a preflight físico y review; **no se autoriza ni se proporciona SQL ejecutable** en este documento.

No reemplazar ni editar retroactivamente la migración `20261005042801...sql`: Hosted registra ya esa versión. No asumir que una edición histórica generará una actualización remota válida.

No crear tabla ni columna. No agregar índices, triggers, funciones, hooks, policies, RPC, grants o roles salvo que una contradicción demostrada fuerce STOP y nuevo Gate. No manipular historial de migraciones.

## 5. Matriz normativa y compatibilidad

| Estado | Presencia obligatoria de `reserved` | Presencia obligatoria de `confirmed` | Comportamiento de este incremento |
|---|---|---|---|
| `PREPARING` | No universal: `NULL` o sujeto esperado según preallocation | Sin ampliación aprobada por esta corrección; la boundary actual inicia con `NULL` | Conservar comportamiento válido actual; tratar la observación `confirmed=expected` prematuro separadamente |
| `PROVISIONING_UNKNOWN` | Sí; igual a `expected` | Debe ser `NULL` | Añadir garantía física de presencia del reservado; preservar restricción de confirmado ausente |
| `SUBJECT_CONFIRMED` | No universal | Sí; igual a `expected` | Añadir garantía física de presencia del confirmado |
| `ISSUANCE_ACTIVE` | No universal | Sí; igual a `expected` | Añadir garantía física de presencia del confirmado |
| `GATE_CONSUMED` | No universal | Sí; igual a `expected` | Añadir garantía física de presencia del confirmado |
| `SESSION_ESTABLISHED_NO_AUTHORITY` | No universal | Sí; igual a `expected` | Añadir garantía física de presencia del confirmado |
| `EXPIRED` | No universal | No universal | Conservar combinaciones válidas históricas y terminalización |
| `ABANDONED` | No universal | No universal | Conservar vocabulario y regla terminal; no crear nuevo writer |
| `REPAIR_REQUIRED` | No universal | No universal | Conservar combinaciones válidas históricas y terminalización |

**Fuera del contrato de este incremento:** decidir una nueva semántica para `PREPARING`, crear una ruta hacia `ABANDONED`, exigir sujetos en todos los estados terminales o redefinir identity/provider lifecycle. La observación Codex de que un `PREPARING` con `confirmed` presente podría pasar los `CHECK` requiere evaluación independiente: **no cerrar ni incorporar silenciosamente ese comportamiento en 6B-002**.

El término “garantía física” no implica conceder permisos de escritura. Tanto el owner como roles privilegiados deben quedar sujetos a la integridad de datos existente, sin debilitar RLS.

## 6. Diseño de seguridad, privilegios y aislamiento multiempresa

- Esta tabla es **platform-owned technical coordination state**, no una entidad tenant-owned y no una fuente de autorización tenant.
- No cambiar `maintenance_companies`, `company_memberships`, `platform_users`, `platform_user_auth_subjects`, intents, challenges, grants, anchors o cualquier tabla tenant.
- Mantener RLS, policy definitions, grants/revokes y permisos por columna de la tabla de coordinación **idénticos** a la baseline canónica observada. En particular, `supabase_auth_admin` continúa limitado a las columnas `state` y `updated_at` para `UPDATE`, de acuerdo con el inventario Hosted inspeccionado; no conceder nuevas capacidades tenant.
- Mantener el Hook Supabase Auth, límites `SECURITY DEFINER`, `search_path`, deny-public y single-use SessionGrant sin alteraciones.
- Una sesión Auth no crea `PlatformUser`, `CompanyMembership` ni tenant authority. Los filtros y RLS tenant existentes siguen siendo obligatorios.
- No usar `service_role` como ordinary client de aplicación, no introducir accesos directos browser, rutas SQL genéricas ni procedimientos de reparación por email.
- No cambiar estado de cuenta, credenciales, técnico, cliente o evidencia; no añadir `AuditEvent` ni nuevo tipo de acción.

### 6.1 Threat / failure model específico

| Riesgo | Mitigación/criterio esperado |
|---|---|
| `CHECK` con resultado `UNKNOWN` permite sujeto requerido ausente | Nueva garantía física negativa y tests por cada estado relevante |
| Nueva restricción bloquea filas válidas o transiciones autorizadas | Preflight read-only de datos actuales, pruebas positivas de todos los flujos y estados |
| Constraint addition encuentra registros incompatibles | STOP; no corregir datos ni omitir validación automáticamente |
| Drift entre migración Git/Hosted | STOP; demostrar equivalencia y procedencia antes de ejecutar |
| `service_role` o propietario realizan escritura inválida | PostgreSQL debe rechazar la combinación por integridad, no confiar sólo en RLS |
| Alteración involuntaria de grants/RLS/Hook | Comparación diff de catálogos antes/después, debe ser cero fuera de cambios esperados |
| Trigger adicional, lock no previsto o concurrency regression | No introducir trigger; preservar lock graph; ejecutar regresiones acotadas y revisar cualquier cambio de bloqueo |
| Migración parcial/timeout | STOP; registrar evidencia, no reintentar ni reparar automáticamente en Hosted |

## 7. Verificación previa obligatoria antes de cualquier implementación

1. Git: repo root, branch, HEAD, origin/main, divergence, `git status --porcelain=v1`, diff; preservar worktree sucio, archivos untracked y cambios de otros incrementos.
2. Fuente: confirmar bytes y SHA canónicos exactos de TASK-021, ADR-0022, migración TASK-021, test TASK-021, correcciones relevantes y ledger §36; confirmar su autoridad y ausencia de drift posterior.
3. Identidad: verificar versión Hosted aplicada y procedencia local de `20261005042801`; resolver expresamente B-3 mediante Gate Git independiente, sin incluir automáticamente la migración actual en staging.
4. Catálogo: comprobar definición actual de la tabla, `CHECK`, nulabilidad, trigger, ACL, RLS, owners, funciones dependientes e índices; comparar contra fuente aprobada y Hosted para B-1.
5. Datos existentes: obtener **sólo contadores agregados READ-ONLY** de filas que incumplirían cada nueva invariant. No exponer IDs, emails, material de challenge ni secretos. Si un contador es positivo o no confiable: STOP/RETURN, no limpiar, actualizar ni eliminar filas.
6. Compatibilidad: verificar que las nuevas comprobaciones no rechazan los casos positivos de las boundaries actuales ni las transiciones terminales permitidas.
7. Migration path: comprobar que la nueva versión/timestamp y basename aún no existen en repo ni Hosted; establecer trazabilidad de una sola migración incremental en un Gate posterior.
8. Seguridad: establecer proof de equivalencia de RLS/ACL/roles y ausencia de impactos cross-tenant/Hook/SessionGrant.
9. Pruebas: verificar test runner y extensiones requeridas, incluidos pgTAP, antes de planificar ejecuciones Local/Hosted separadas.

Cualquier fallo de precondición, fuente incompleta o contradicción requiere **BLOCKER / RETURN TO REVISOR CENTRAL**, sin reparación automática.

## 8. Protocolo de pruebas y verificaciones (NO ejecutado)

### 8.1 Pruebas negativas DB — obligatorias

- N-01: `PROVISIONING_UNKNOWN` con reservado `NULL`, confirmado `NULL` y demás campos válidos: la escritura debe fallar por integridad de presencia.
- N-02: `SUBJECT_CONFIRMED` con confirmado `NULL`: debe fallar.
- N-03: `ISSUANCE_ACTIVE` con confirmado `NULL`: debe fallar.
- N-04: `GATE_CONSUMED` con confirmado `NULL`: debe fallar.
- N-05: `SESSION_ESTABLISHED_NO_AUTHORITY` con confirmado `NULL` y `terminal_result` válido: debe fallar.
- N-06: `PROVISIONING_UNKNOWN` con reservado igual a sujeto distinto del esperado: debe fallar por la restricción existente de igualdad.
- N-07: cualquiera de los cuatro estados confirmados con confirmado distinto del esperado: debe fallar.
- N-08: invalidación de estado terminal ya confirmado debe seguir fallando; ningún grant terminal resucita.

Las pruebas deben aislar el constraint específico: el resto de campos/relaciones deberán ser válidos y no deberán producir falsos PASS por una FK, un `NOT NULL` ajeno o un error de autorización. Para N-01..N-05 la evidencia debe identificar la protección de presencia, no un error indirecto de otra clase.

### 8.2 Pruebas positivas DB — obligatorias

- P-01: `PREPARING` bound, reservado `NULL` y confirmado `NULL` continúa permitido.
- P-02: `PREPARING` preallocated, reservado igual a esperado y confirmado `NULL` continúa permitido.
- P-03: `PROVISIONING_UNKNOWN` con reservado igual al esperado y confirmado `NULL` continúa permitido.
- P-04: `SUBJECT_CONFIRMED` con confirmado igual a esperado continúa permitido, tanto en bound como preallocated cuando correspondan.
- P-05: `ISSUANCE_ACTIVE` y `GATE_CONSUMED` con confirmado igual a esperado siguen permitidos por el constraint; el tránsito real sigue sujeto a boundaries y policy.
- P-06: `SESSION_ESTABLISHED_NO_AUTHORITY` confirmado y resultado terminal no nulo continúa permitido.
- P-07: `EXPIRED`, `ABANDONED`, `REPAIR_REQUIRED` conservan las variantes lícitas que puedan proceder de distintas fases sin nuevo requisito universal de sujeto.

### 8.3 Regresión, permisos, concurrencia y aislamiento

- R-01 (regresión negativa): `state` fuera del vocabulario aprobado, vínculos inmutables y single-active uniqueness siguen rechazados.

- Confirmar no cambio de RLS, tabla/columna grants, funciones RPC, Hook y `search_path`; `anon`/`authenticated` siguen sin CRUD directo de coordinaciones.
- Comprobar casos negativos tenant cross-company, sin PlatformUser y sin membership; las sesiones Auth solas siguen sin tenant authority.
- Preservar reenvío, reconciliation exact-ID, `PROVISIONING_UNKNOWN` recovery, `ISSUANCE_ACTIVE` fence, consumo `GATE_CONSUMED`, terminalización y estado reparable.
- Verificar concurrencia relevante sin deadlocks/locks nuevos, single-active y terminal SessionGrant; no crear pruebas que muten Hosted sin Gate.
- Regresiones locales de TASK-021 y TASK-020 pertinentes, TASK-013/Hook según su Gate/waiver histórico, y verificaciones del runner de DB. El waiver §36.28, si está vigente canónicamente, es excepcional y **NO aplica automáticamente** a esta corrección.
- Evidencia pre/post con definición de constraints exacta y conteos de residuos/efectos indirectos dentro de alcance permitido.

**Todas las pruebas anteriores están PENDING y requieren autorización separada.** No se considera PASS una prueba no ejecutada, saltada, no observada o reportada sólo por texto.

## 9. Estrategia de migración y seguridad operacional futura

- La implementación posterior autorizada, si llega, añadirá una **nueva migración versionada**, no reescribirá la histórica TASK-021 ya aplicada.
- Antes de la ejecución, confirmar que no existan filas contrarias a los nuevos predicados en el target; el control es un preflight de sólo lectura con conteos agregados y visibilidad suficiente.
- Elegir un mecanismo transaccional y verificable para introducir y validar los checks nuevos; cualquier plan que los deje sin validar requiere una decisión humana específica y evidencia técnica.
- No insertar, borrar, remediar, normalizar ni limpiar filas existentes como parte tácita de la corrección. Cualquier dato incompatible produce STOP y nuevo Gate.
- Considerar lock/timeout/compatibilidad de PostgreSQL del entorno en un preflight formal; no inventar un tiempo de lock ni una ventana de mantenimiento.
- No modificar objetos de `auth` administrados por Supabase ni tocar Staging/Production. Hosted Development sigue sujeto a un Gate separado.
- Reversibilidad, si fuera necesaria, debe documentarse como procedimiento explícitamente revisado, **no como rollback automático** o manipulación histórica.
- Obtener evidencia de que nuevas constraints están presentes, habilitadas y **validadas**, y que todo cambio de catálogo externo al diff esperado es cero.

## 10. Descomposición futura para Codex — NO AUTORIZADA

### Work Item A — Reconciliación de fuentes y propuesta física (READ-ONLY)

- **Objetivo:** obtener baseline exacta y redactar plan/diff conceptual de integridad.
- **Contexto:** contradicción 6B-002, §15.4, ADR-0022, migración actual no incorporada.
- **Alcance:** comparar fuentes, catálogos, datos agregados, contratos de test y numeración.
- **Fuera de alcance:** editar repo, DB, tests, migraciones; ejecutar pgTAP.
- **Cambios esperados:** ninguno; informe con SHA, blockers, matriz y alternativas.
- **Seguridad/RLS:** sólo lectura, secretos excluidos, cero datos tenant expuestos.
- **Criterios/pruebas:** hashes y diff lógico contrastados, precondiciones reportadas, ninguna mutación.

### Work Item B — Migración incremental y tests negativos (FUTURO GATE DE IMPLEMENTACIÓN)

- **Objetivo:** imponer físicamente dos garantías de presencia con alcance mínimo.
- **Contexto:** Work Item A y spec aprobados, historial de migración existente.
- **Alcance:** un archivo nuevo de migración, pruebas DB acotadas revisadas y sólo paths autorizados.
- **Fuera de alcance:** modificar migración histórica, cambios de dominio, Auth, UI, RLS, grants, hooks, funciones o lifecycle distinto de 6B-002.
- **Cambios esperados:** nuevos checks validados y pruebas negativas/positivas de §8.
- **Seguridad/RLS:** mismas ACL/roles/RLS; sin expansión de privilegios ni tenant authority.
- **Criterios/pruebas:** N-01..N-08, P-01..P-07, regresión negativa R-01, local DB/regresión, catálogo exacto, no residuos; todo con resultados reales.

### Work Item C — Revisión técnica y regresiones (GATE INDEPENDIENTE)

- **Objetivo:** probar ausencia de regresiones y coherencia del diff.
- **Contexto:** implementación B revisada preliminarmente y entorno Local autorizado.
- **Alcance:** revisión de diff, linters/checks aplicables, tests DB/RLS y concurrencia relevantes.
- **Fuera de alcance:** expansión de producto o nuevas migraciones correctivas no autorizadas.
- **Cambios esperados:** evidencia revisable, sin nuevos cambios por defecto.
- **Seguridad/RLS:** aislamiento multiempresa, Hook, Auth y SessionGrant preservados.
- **Criterios/pruebas:** matriz §8 y herramientas canónicas en PASS; si falla, STOP y correction Gate.

### Work Item D — Hosted Development post-approval (GATE HUMANO SEPARADO)

- **Objetivo:** comprobar de forma controlada la migración nueva en Hosted Development.
- **Contexto:** Local/revisión PASS, B-1/B-2/B-3 y permisos operacionales explícitos resueltos.
- **Alcance:** preflight READ-ONLY, plan aprobado, ventana segura y verificación postflight.
- **Fuera de alcance:** pgTAP TASK-020 §36.29 por inferencia, Staging, Production, cambios adicionales, reintentos automáticos.
- **Cambios esperados:** exclusivamente los nuevos constraints aprobados, después de autorización expresa.
- **Seguridad/RLS:** snapshots pre/post, no residuos, no fugas tenant, no ampliación de grants.
- **Criterios/pruebas:** delta exactamente esperado y validado, registro de migración nuevo, no drift, revisión humana posterior.

## 11. Criterios de aceptación de la corrección (ESPECIFICACIÓN APROBADA; EJECUCIÓN PENDIENTE)

- **AC-6B002-001:** se verifica identidad de fuentes canónicas y estado Git fresco, incluidos migration/test actualmente untracked.
- **AC-6B002-002:** se asigna un identificador único a partir del registro actual, mediante decisión humana expresa.
- **AC-6B002-003:** la implementación no altera migrations históricas.
- **AC-6B002-004:** sólo la tabla platform-owned `later_user_initial_session_coordinations` recibe nueva protección física.
- **AC-6B002-005:** `PROVISIONING_UNKNOWN` sin reserved es físicamente rechazado.
- **AC-6B002-006:** los cuatro estados confirmados sin confirmed son físicamente rechazados, uno por uno.
- **AC-6B002-007:** los sujetos presentes continúan obligados a coincidir con expected.
- **AC-6B002-008:** `PROVISIONING_UNKNOWN` con confirmed no nulo sigue rechazado.
- **AC-6B002-009:** los dos flujos `PREPARING` de creación, bound/preallocated, siguen permitidos.
- **AC-6B002-010:** los estados terminales preservan las variantes lícitas; no se fuerza sujeto presente universal.
- **AC-6B002-011:** índices, FKs, PK, únicos y constraints no pertinentes conservan definición efectiva.
- **AC-6B002-012:** RLS, ACL de tabla/columna, roles, functions, hooks y SECURITY INVOKER/DEFINER no se alteran.
- **AC-6B002-013:** ninguna tabla o columna tenant se modifica; no nace tenant authority por sesión.
- **AC-6B002-014:** los cambios esperados consisten sólo en constraints aprobados y su nueva migration/test.
- **AC-6B002-015:** ningún `NULL`/`UNKNOWN` satisface las nuevas obligaciones de presencia.
- **AC-6B002-016:** negativos N-01..N-08 fallan por la razón correcta en pruebas aisladas.
- **AC-6B002-017:** positivos P-01..P-07 siguen admitidos cuando todas las demás condiciones son válidas; la regresión negativa R-01 sigue rechazando las tres clases de operación inválida previstas.
- **AC-6B002-018:** el preflight de datos existentes da cero incompatibilidades o STOP.
- **AC-6B002-019:** los nuevos constraints terminan habilitados/validados en target aprobado.
- **AC-6B002-020:** las regresiones Local, DB/RLS, Hook, SessionGrant y concurrencia aplicables mantienen su resultado válido.
- **AC-6B002-021:** no se ejecuta test Hosted, §36.29 ni pgTAP sin Gate específico.
- **AC-6B002-022:** no hay modificación de Staging ni Production.
- **AC-6B002-023:** no se confunde un PASS de esta corrección con el cierre de TASK-021 o Phase 2.
- **AC-6B002-024:** se conserva la evidencia y se reevalúa el ledger §36 donde corresponda, sin borrar ni retroetiquetar resultados históricos.
- **AC-6B002-025:** observaciones sobre `PREPARING`/`ABANDONED` tienen disposición documental explícita, sin ampliación automática de esta corrección.
- **AC-6B002-026:** se demuestra ausencia de drift fuera del diff aprobado y de mutación/remanencia en pruebas transaccionales.

## 12. Definition of Done de CORR-047

- **DoD-6B002-001:** los bytes y SHA de todas las fuentes imprescindibles están disponibles y cotejados.
- **DoD-6B002-002:** no existen contradicciones de contrato sin resolver ni decisiones de scope sin autorización.
- **DoD-6B002-003:** identificador y ruta canónica únicos determinados con fuente de verdad Git.
- **DoD-6B002-004:** revisión técnica de la especificación aprobada en Gate separado.
- **DoD-6B002-005:** aprobación humana de la especificación en Gate separado.
- **DoD-6B002-006:** artifact approval, canonicalización e incorporación ocurren cada una mediante Gate propio.
- **DoD-6B002-007:** implementación autorizada posteriormente y por paths exactos, sin inferencia de autorización documental.
- **DoD-6B002-008:** migración incremental nueva, completa y trazable; ninguna histórica reescrita.
- **DoD-6B002-009:** constraints validados, test matrices y regresiones pertinentes con evidencia real.
- **DoD-6B002-010:** seguridad multiempresa, RLS, ACL, Auth, SessionGrant y hooks preservados.
- **DoD-6B002-011:** verificación Hosted y cualquier pgTAP con autorización y presupuesto propios.
- **DoD-6B002-012:** revisión posterior de diff/catálogo, estado y documentación sin adelantar TASK-021 DONE.

La revisión formal de especificación (DoD-6B002-004) y su aprobación humana (DoD-6B002-005) constan como **APPROVED**. Los demás DoD permanecen **PENDING** y sujetos a sus Gates independientes; la corrección no está implementada ni cerrada.

## 13. Documentos que previsiblemente deben actualizarse tras Gates independientes

- Nueva especificación `docs/tasks/CORR-047-task-021-6B-002-physical-integrity-correction.md` cuando se autorice su incorporación. **ID confirmado humanamente = CORR-047; identidad canónica generada externamente / pendiente de revisión independiente; incorporación al repositorio pendiente de Gate separado.**
- Registro/ledger de TASK-021 §36 y evidencia de §36.29: reflejar nuevo hallazgo y nueva verificación sin convertir PASS históricos en PASS actual ni borrar datos de ejecución.
- Registro de estado en `docs/product/11-phase-1-scope-entry-gate.md` si su formato vigente lo requiere, únicamente mediante corrección de sincronización aprobada.
- Documento de pruebas/regresiones e inventario de migration/constraints, con SHA y provenance canónica una vez incorporados.
- Registro maestro de ADR: el inventario READ-ONLY reporta ausencia de ADR-0022 en `docs/product/10-architecture-decisions-records.md`; requiere **disposición documental separada**, sin ampliar por defecto el alcance físico de 6B-002.
- ADR-0022 y TASK-021 §15.4 **no necesitan cambio conceptual esperado**: ya describen la integridad objetivo. Si se verifica una nueva regla, contradicción o decisión, STOP y preparar la propuesta de actualización adecuada antes de implementarla.
- CORR-046/waiver §36.28, si está efectivo en el canon, debe mantener su alcance **exclusivo**. Este hallazgo no queda waived.

No se ha realizado ninguna de esas actualizaciones en esta generación documental.

## 14. Gates y estado al emitir este artefacto canónico documental externo

```text
CORRECTION ID = CORR-047 / HUMAN CONFIRMED IDENTIFIER
SPECIFICATION = HUMAN APPROVED / BASE DRAFT V4 SHA-256 VERIFIED / NO TECHNICAL CHANGES
CENTRAL SPEC RE-REVIEW = APPROVED
F-047-SPEC-R-001 = PASS / CLOSED
F-047-SPEC-R-002 = PASS / CLOSED
CORR-047 HUMAN SPEC APPROVAL = APPROVED
APPROVED ARTIFACT = GENERATED / INDEPENDENT APPROVED ARTIFACT REVIEW = APPROVED
CANONICAL ARTIFACT GENERATION = PASS / EXTERNAL FILE
CANONICALIZATION REVIEW = PENDING
REPOSITORY INCORPORATION = NOT AUTHORIZED
ADR-0022 = HUMAN APPROVED / CANONICALIZED / DONE-CLOSED (LATER EVIDENCE)
WORKTREE = DIRTY (7 MODIFIED + 10 UNTRACKED); NO MUTATION AUTHORIZED
HUMAN AUTHORIZATION = DOCUMENTATION + READ-ONLY ONLY
IMPLEMENTATION AUTHORIZATION = NO
REPOSITORY MUTATION = NONE
SUPABASE HOSTED MUTATION = NONE

FINDING 6B-001 = RESOLVED / NO DEFECT SHOWN
FINDING 6B-002 = CONFIRMED / PHYSICAL INTEGRITY GAP
OTHER OBSERVATIONS (PREPARING, ABANDONED) = OPEN FOR SCOPE DISPOSITION

B-1 HOSTED SOURCE EQUIVALENCE = NOT DEMONSTRATED
B-2 INDIRECT EFFECT SAFETY = PENDING
B-3 TASK-021 MIGRATION PROVENANCE = PENDING
B-4 IMMEDIATE PGTAP PREFLIGHT = PENDING
B-5 POSTFLIGHT EXECUTION = PENDING

§36.29 HOSTED PGTAP EXECUTED = NO
§36.29 ATTEMPTS EXECUTED = 0 (CONVERSATIONAL RECORD; NOT REPOSITORY CANONICAL COUNTER)
§36.28 REPOSITORY COUNTER = 0/1 (NOT §36.29)
TASK-021 = NOT DONE / NOT CLOSED
PHASE 2 = IN PROGRESS / NOT CLOSED
PHASE 3 = NOT STARTED
```

### Gate posterior permitido

Únicamente **CORR-047 CANONICALIZATION REVIEW**, contrastando byte a byte este artefacto canónico externo con el artefacto aprobado SHA-256 `75add231636924879f329afac8d77349e45169383bdbca9b6f8d4a3ecebef066` y exigiendo que el delta se limite a identidad canónica, metadatos y estados/Gates autorizados. La re-revisión de especificación, la aprobación humana de especificación y la revisión independiente del artefacto aprobado ya constan `APPROVED`; esta generación externa **no** equivale a incorporación al repositorio. Posteriores Gates independientes: autorización de incorporación física, resolución B-3, implementación y verificación. El preflight Git debe repetirse antes de incorporar el documento y el preflight de implementación requerirá evidencia fresca. **No** se autoriza SQL de corrección, migración ejecutable, implementación Codex, tests DB, incorporación al repositorio, Supabase Hosted, pgTAP, staging, commit o push.
