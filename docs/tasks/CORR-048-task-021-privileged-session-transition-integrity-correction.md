# CORR-048 — TASK-021 Privileged Session Transition Integrity Correction

**Estado: SPECIFICATION APPROVED / HUMAN APPROVAL GRANTED / NON-CANONICAL / IMPLEMENTATION NOT AUTHORIZED**\
**Revisión documental:** OBS-048-001..006 revisadas; CORR-048 SPECIFICATION REVIEW = APPROVED; aprobación humana formal otorgada el 2026-11-03.\
**Identificador: CORR-048 DEFINITIVO — confirmado mediante aprobación humana el 2026-11-03.**\
**Naturaleza: especificación documental aprobada, todavía no canónica; no autoriza implementación, pruebas ni operaciones remotas.**

Ruta canónica prevista, todavía no creada ni incorporada al repositorio:

`docs/tasks/CORR-048-task-021-privileged-session-transition-integrity-correction.md`

## 1. Preflight e identidad provisional

```
Repository root =
C:/Users/Lenovo/Desktop/Software de registros de mantenimiento

Branch = main
HEAD = aa783bd532f98162e795eae45f6cf69f8737e164
origin/main local = 0788abbded2ae4eff2bc92e08fc8d7423c97f17d
Divergence = 1 0

Tracked modified = 7
Untracked = 8
Staged = 0
Git operations in progress = NONE

PREFLIGHT = PASS
```

No se encontraron usos de CORR-048 en:

- Nombres de archivos del worktree inspeccionado.
- Referencias en documentación y archivos de texto/código no secretos.
- Mensajes de commits alcanzables mediante referencias y reflogs locales.
- Cambios históricos y nombres de archivos de esos commits.
- Nombres de referencias Git locales.

El resultado acredita **ausencia de colisión local observada**. No asigna el identificador ni comprueba repositorios remotos.

El postflight conserva el mismo estado Git. Las diecinueve fuentes cuyos hashes se registraron permanecieron idénticas.

## 2. Fuentes y autoridad

| Fuente                                                                                                                                                                                                                          | Aplicación                                               |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| [TASK-021 §14 (line 964)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:964)            | Activación atómica y revalidación terminal               |
| [TASK-021 §15.4 (line 1141)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:1141)        | Bindings e integridad                                    |
| [TASK-021 §19 (line 1534)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:1534)          | Grant, consumo, terminalidad y recuperación              |
| [TASK-021 §21 (line 1721)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:1721)          | Precedencia de locks                                     |
| [CORR-047 (line 111)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/CORR-047-task-021-6B-002-physical-integrity-correction.md:111)                                                                 | Corrección independiente de presencia física 6B-002      |
| [ADR-0002 (line 437)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md:437)                                                                      | Privilegios restringidos y aislamiento tenant            |
| [ADR-0003 (line 567)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0003-authorization-client-scope-support.md:567)                                                                 | Reconstrucción del contexto privilegiado                 |
| [ADR-0019 (line 1212)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md:1212)                                            | Grant single-use y consumo por el Hook                   |
| [ADR-0022 (line 2047)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md:2047)        | Coordinación, recuperación y entrega posterior al commit |
| [Estrategia RLS (line 1545)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/product/03-permissions-rls-strategy.md:1545)                                                                                  | Mínimo privilegio y límites del backend                  |
| [Migración TASK-013 (line 114)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20260830010000_task_013_verification_challenge_foundation.sql:114)                                          | Grants, bindings, constraints y permisos                 |
| [Migración TASK-017 (line 328)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20260919153618_task_017_first_admin_onboarding_intent_verification_handoff_foundation.sql:328)              | Creación y revocación de grants                          |
| [Migración TASK-020 (line 909)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261001234520_task_020_authoritative_later_user_enrollment_intent_verification_handoff_foundation.sql:909) | Correlación de proof y handoff                           |
| [Migración TASK-021 (line 480)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql:480)                                | Implementación actual de las RPC afectadas               |
| [Test SQL TASK-021 (line 77)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/tests/database/task_021_later_user_auth_identity_session_foundation.test.sql:77)                                         | Cobertura física y de privilegios existente              |
| [Tests TypeScript (line 46)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/tests/task-021-later-user-auth-session.test.ts:46)                                                                                 | Orquestación mediante mocks                              |
| [Harness TASK-021 (line 1673)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/tests/database/task_021_later_user_auth_identity_session_concurrency.test.ps1:1673)                                     | Concurrencia existente                                   |
| [Servicio Next.js (line 190)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/src/modules/identity-authorization/application/later-user-auth-session-service.ts:190)                                            | Activación, proveedor, finalización y recuperación       |
| [Adaptador Supabase (line 123)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/src/modules/identity-authorization/infrastructure/supabase/later-user-auth-session-source.ts:123)                               | Argumentos y resultados RPC                              |
| [Current-state (line 1576)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/product/11-phase-1-scope-entry-gate.md:1576)                                                                                   | Ledger y límites de cierre vigentes                      |

Identidades principales comprobadas:

```
TASK-021:
d0106d83633b616099f6772702ee80f4700115186e938047e19a81edba865c43

CORR-047:
d87f3eab580fa005b95149fac806ffe39d6916664941a0274a3206ea468458d5

ADR-0022:
1221f653d59c44af691ea314f77660b9f66e2f691cfc4fc2afd96e3891fe7e9c

Migración TASK-013:
1d4833f38be525974d447dc0dd301211a1d6bad68edadcfe46f424f5eb4e0dbf

Migración TASK-017:
7ef2ef48f92d632fc757527a3716978c49eb5358bd852dab1b1acd7ba437d789

Migración TASK-020:
c00c749c1ec9e15364728611c3cad7183a24bcb53fb434c83ca36a4e7b38c5a2

Migración TASK-021:
f6862b27e74e4a3da81c96ea316d24451c812bcf4e4a2dea89cf12e558ca8e9f
```

Se consumen también los informes conversacionales:

- `TASK-021 SECURITY FINDINGS READ-ONLY VALIDATION`.
- `TASK-021 PRIVILEGED TRANSITION CORRECTION DESIGN PROPOSAL`.
- `TASK-021 CORRECTION DESIGN — FINAL CONTRACT RESOLUTION`.

Son antecedentes de revisión de esta conversación; no se les atribuye archivo canónico, SHA-256 físico ni aprobación humana no acreditada.

ADR-0022 se interpreta conforme a su consumo canónico posterior, sin utilizar su encabezado histórico `PROPOSED` como estado vigente. El commit local prospectivo tampoco demuestra identidad histórica de lo desplegado en Hosted.

## 3. Objetivo y contexto

Restaurar las garantías de integridad de las transiciones privilegiadas de sesión TASK-021:

- **F-021-REVIEW-001:** impedir que activación o finalización continúen sin comprobar efectivamente el resultado de la consulta del SessionGrant.
- **F-021-REVIEW-002:** impedir que la rama `IDENTITY_INCOMPATIBLE` modifique una coordinación no perteneciente al intent autoritativo.

La activación actual comprueba el `FOUND` del `UPDATE` de coordinación, pero no el resultado del `PERFORM` del grant. La finalización presenta la misma omisión. La rama incompatible ejecuta su actualización antes de comprobar la pertenencia al intent. Evidencia: [activación (line 480)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql:480) y [finalización (line 571)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql:571).

No se presupone explotación pública cross-tenant. Los hallazgos confirmados afectan a la validación de las boundaries PostgreSQL privilegiadas; existen mitigaciones en la orquestación Next.js.

**F-021-REVIEW-003 queda fuera de alcance:** no se añadirá un estado habilitado de PlatformUser. Su ausencia está deliberadamente contemplada por la autorización existente y por [T012-006 (line 134)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/tests/authoritative-online-authorization.test.ts:134).

## 4. Alcance

### Dentro de alcance

1. Una migración nueva, forward-only e independiente.
2. Modificación exclusiva de los cuerpos de:
   - `public.task_021_activate_issuance`.
   - `public.task_021_finalize_initial_session`.
3. Pruebas SQL positivas y negativas.
4. Pruebas focalizadas de concurrencia.
5. Regresiones TypeScript justificadas.
6. Evidencia de conservación de seguridad, catálogo y worktree.

### Fuera de alcance

- Editar migraciones históricas.
- Cambiar firmas RPC o introducir resultados nuevos.
- Modificar el Auth Hook o el helper de compatibilidad.
- Modificar las otras cuatro RPC mutantes TASK-021.
- Cambiar UI, endpoints o código de producción Next.js sin necesidad demostrada.
- Crear columnas, tablas, índices, triggers, policies o roles.
- Ampliar permisos o modificar RLS.
- Crear/completar PlatformUser o CompanyMembership.
- Reparar datos existentes.
- Ampliar CORR-047.
- Ejecutar §36.28, cerrar TASK-021 o avanzar de fase.

El alcance de CORR-047 excluye cambios de funciones; esta propuesta no lo reinterpreta: [CORR-047 Work Item B (line 243)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/CORR-047-task-021-6B-002-physical-integrity-correction.md:243).

## 5. Dominio e invariantes

La corrección no introduce entidades ni reglas funcionales nuevas. Materializa garantías ya exigidas por [TASK-021 (line 964)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:964), [ADR-0019 (line 1212)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md:1212) y [ADR-0022 (line 2047)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md:2047).

Debe mantenerse:

1. Un SessionGrant autoriza como máximo un consumo inicial.
2. El consumo ocurre dentro de la ventana original.
3. La coordinación nunca extiende el grant.
4. Handoff, bridge, grant, sujeto y operación lógica permanecen estables.
5. Un retry reconcilia la misma operación.
6. Un terminal no se reactiva.
7. El Hook conserva el consumo atómico.
8. La entrega de cookies ocurre después del commit terminal.
9. Una sesión Auth no concede autoridad tenant.
10. Un resultado vacío o desconocido nunca equivale a autorización.

## 6. Requisitos y contratos RPC

### 6.1 Correlación mínima común

Antes de cualquier escritura debe demostrarse:

| Relación            | Garantía requerida                                                |
| ------------------- | ----------------------------------------------------------------- |
| Intent–empresa      | La empresa se deriva del intent y corresponde a la fila bloqueada |
| Coordinación–intent | La coordinación pertenece exactamente al intent validado          |
| Coordinación–sujeto | Expected y confirmed corresponden al sujeto exacto                |
| Anchor–sujeto       | Se utiliza el anchor de ese sujeto autoritativo                   |
| Coordinación–grant  | La coordinación señala al grant inspeccionado                     |
| Intent–grant        | El handoff del intent señala al mismo grant                       |
| Coordinación–bridge | Se utiliza el bridge exacto de la coordinación                    |
| Grant–bridge        | El grant pertenece a ese mismo bridge                             |
| Bridge/grant–sujeto | Los bindings corresponden al sujeto esperado                      |

Las FK no sustituyen las igualdades entre esas relaciones. La finalización deriva intent y empresa desde la coordinación; no recibe argumentos nuevos.

Se conservan las garantías de challenge y operación lógica establecidas por TASK-020 y reconcile. No se repite el proof, no se vuelve a consumir el challenge y no se introduce una validación nueva de su vencimiento. Fuentes: [handoff TASK-020 (line 909)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261001234520_task_020_authoritative_later_user_enrollment_intent_verification_handoff_foundation.sql:909) y [reconcile TASK-021 (line 245)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql:245).

Las igualdades adicionales de emails o de expiries no se convierten automáticamente en gates nuevos de negocio. Una discrepancia relevante observada exige disposición expresa, no renormalización ni reparación tácita.

### 6.2 Comprobación efectiva de consultas

Cada consulta crítica debe distinguir inequívocamente:

- Una fila válida.
- Ninguna fila.
- Cardinalidad o resultado inesperados.

Demostrar la existencia del grant correlacionado y clasificar su elegibilidad son controles distintos. Una consulta de elegibilidad vacía no demuestra por sí sola que el registro no exista y nunca habilita una transición de éxito. El registro debe quedar inequívocamente correlacionado antes de clasificar revocación, consumo o expiración según la precedencia de §7.

Si se utiliza `PERFORM`, su `FOUND` debe comprobarse inmediatamente. Si se recupera una fila estricta, su ausencia debe producir fail-closed. La comprobación de un `UPDATE` posterior no sustituye la del grant.

El control necesario para activar exige grant y coordinación vigentes. El control para terminalizar una coordinación legítimamente expirada es diferente: requiere un grant existente y correlacionado, el estado y las precondiciones de DE, pero no puede exigir que ese grant siga temporalmente elegible para una nueva emisión. No se permite que un `PERFORM` vacío sustituya ninguna de esas demostraciones.

Cada transición autorizada debe afectar exactamente a su coordinación. La operación no puede devolver éxito tras una consulta crítica vacía. La precedencia de §7 gobierna todos los resultados antes de cualquier escritura.

### 6.3 Activación

**Precondiciones de éxito**

- Correlación completa demostrada.
- Estado `SUBJECT_CONFIRMED`, o retry válido de la misma operación en `ISSUANCE_ACTIVE`.
- Grant exacto de propósito `initial_session` y método `password`.
- Grant no consumido ni revocado.
- Grant y coordinación vigentes al decidir la transición.
- Sujeto confirmado exacto.
- Compatibilidad actual expresamente válida bajo el anchor.

**Postcondiciones**

- Se alcanza o reconcilia `ISSUANCE_ACTIVE`.
- El grant permanece sin consumir.
- No se modifican bindings, expiry ni operación.
- No se crea otro fence.
- El retry válido no extiende ninguna ventana.
- Un retry válido `ISSUANCE_ACTIVE → ISSUANCE_ACTIVE` conserva la actualización técnica vigente de `updated_at`; pertenece a DA y no exige D0 estricto. El timestamp no constituye una extensión del fence ni de los expiries.

Exigir D0 estricto para ese retry sería un cambio observable adicional que no se incorpora a esta corrección mínima. La implementación local actual actualiza `updated_at` para ambos estados de origen admitidos; el canon preserva la identidad de la operación, no impone ausencia absoluta de escritura técnica. Fuentes: [activación (line 480)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql:480), [TASK-021 §20.1]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:1660) y [ADR-0022 §29.1]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md:2093).

**Rama incompatible**

Sólo después de validar correlación, estado y elegibilidad, y de superar los rechazos prioritarios de §7, puede modificarse la coordinación exacta a `REPAIR_REQUIRED`.

Intent A con coordinación B debe rechazarse sin modificar ninguna de ellas, tanto dentro de una empresa como entre empresas. Una incompatibilidad concurrente no prevalece sobre correlación inválida, estado no admitido, revocación, consumo incompatible o expiración que impida activar.

### 6.4 Tiempo y expiración

La decisión temporal debe reevaluarse después de las esperas por locks. No basta el timestamp capturado al entrar en la función.

- Grant o coordinación expirados: no se activa nueva emisión.
- Expiración de grant y expiración de coordinación no son el mismo disparador de terminalización.
- Un `ISSUANCE_ACTIVE` expirado no obtiene una ruta nueva de limpieza automática en esta corrección.
- La expiración no permite cambiar TTL, borrar evidencia ni revivir grants.

**Condición exacta de DE**

DE sólo es admisible en `task_021_activate_issuance` cuando se demuestra conjuntamente:

1. La cadena autoritativa es válida y el grant existe y está correlacionado.
2. La coordinación está en `SUBJECT_CONFIRMED`.
3. El tiempo reevaluado ha alcanzado o superado `coordination.expires_at`.
4. No prevalece un rechazo anterior de §7 por correlación, estado, revocación o consumo incompatible.

El único delta permitido es que esa coordinación pase a `EXPIRED`, con `terminal_result = SESSION_GRANT_EXPIRED` y actualización de su `updated_at`. No se modifica el grant ni otra fila.

- Sólo grant expirado y coordinación aún vigente: `SESSION_RECOVERY_REQUIRED` con D0.
- Sólo grant revocado: resultado de revocación con D0.
- Grant consumido incompatible con activación: rechazo con D0.
- Coordinación expirada en `SUBJECT_CONFIRMED`, sin rechazo prioritario: DE.
- Grant y coordinación expirados en ese mismo caso: DE por expiración de la coordinación.
- Coordinación expirada en `ISSUANCE_ACTIVE`: D0 en este incremento.
- `GATE_CONSUMED` con consumo previo válido: no se terminaliza por DE por el mero paso del tiempo.
- Correlación inválida, aunque ambos expiries hayan vencido: D0.

El disparador físico existente de activación comprueba la expiración de la coordinación y limita el `UPDATE` a `SUBJECT_CONFIRMED`; la precedencia correctiva restringe su uso a contextos válidos. La ruta de expiración propia de reconcile no amplía el alcance de esta RPC. Fuentes: [activación, líneas 548–553]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql:548) y [reconcile, líneas 258–263]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql:258).

El Hook mantiene su comprobación temporal independiente; la activación no garantiza vigencia durante todo el I/O posterior del proveedor. Fuentes: [TASK-021 §19 (line 1534)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:1534) y [Hook (line 733)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql:733).

### 6.5 Finalización y consumo previo

**Precondiciones**

- Correlación completa revalidada.
- Grant exacto consumido y no revocado.
- Evidencia de consumo dentro de los límites definidos en §6.7.
- Estado `GATE_CONSUMED`, o éxito terminal exacto para idempotencia.
- Compatibilidad actual bajo el anchor.
- Resultado válido del proveedor o sesión existente correlacionada, comprobados por el servicio.

La finalización debe comprobar efectivamente el resultado de la consulta del grant. Un marcador no nulo sin correlación ni cronología demostradas no permite continuar. Las condiciones se evalúan conforme a §7.

**Postcondiciones**

- `GATE_CONSUMED` puede pasar a `SESSION_ESTABLISHED_NO_AUTHORITY`.
- El éxito terminal ya existente puede reconocerse sin otra escritura.
- No se vuelve a consumir el grant.
- No se crea una sesión inicial nueva.
- No se entregan cookies ante resultado negativo o indeterminado.
- El mero vencimiento actual de un grant consumido válidamente no añade una condición temporal nueva de finalización; se conserva §6.6.

El marcador `consumed_at` no demuestra por sí solo que el proveedor devolvió una sesión. Esa evidencia pertenece también al servicio y a la boundary de entrega: [servicio (line 289)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/src/modules/identity-authorization/application/later-user-auth-session-service.ts:289).

### 6.6 Finalización tardía

**Estado de aprobación:** revisión central de especificación `APPROVED` y aprobación humana formal concedida el 2026-11-03. Se conservan las condiciones contractuales de finalización tardía y las autorizaciones independientes de implementación, pruebas, Git y Hosted.

Se conserva sin cambio la semántica delimitada:

- Un consumo válido anterior al vencimiento puede sustentar la finalización o reconciliación de esa misma emisión.
- El vencimiento posterior impide reutilizar el grant para una emisión inicial.
- No se añade automáticamente una condición de vigencia actual del grant a la finalización.
- No se fija un plazo adicional.
- La coordinación debe conservar un estado recuperable y la sesión/candidato debe ser válido.
- Un estado terminal fallido no puede convertirse en éxito.
- Sin evidencia suficiente se aplica fail-closed.

Esta distinción se apoya en [TASK-021 recuperación (line 1635)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:1635), [ADR-0019 replay (line 1252)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md:1252) y [ADR-0022 recuperación y expiry (line 2070)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md:2070).

### 6.7 Límites de la evidencia de consumo

Los campos existentes permiten contrastar grant, coordinación, sujeto, revocación y cronología. Deben distinguirse las siguientes capas de evidencia.

**Definiciones temporales**

- `t0` = `grant.created_at`.
- `tc` = `grant.consumed_at`.
- `eg` = `grant.expires_at`.
- `ec` = `coordination.expires_at`.

**Constraints existentes**

- El grant exige `eg = t0 + cinco minutos`.
- `created_at` y `expires_at` son no nulos; `consumed_at` es anulable.
- El CHECK terminal impide que consumo y revocación sean simultáneamente no nulos.
- No existe un CHECK que sitúe `tc` dentro de toda la ventana de consumo.
- La coordinación se inicializa con el expiry del grant y su trigger protege el cambio posterior de ese binding. Esto no equivale a una constraint cruzada universal de igualdad entre ambos expiries.

**Garantías del Hook local**

En su camino exitoso, el Hook asigna un mismo timestamp de decisión al consumo y a la transición `GATE_CONSUMED`, exigiendo `tc < eg` y `tc < ec` y comprobando las dos actualizaciones. Las policies temporales son controles adicionales bajo su contexto aplicable.

El Hook y los CHECK inspeccionados no contienen una comparación explícita `t0 ≤ tc`. No debe presentarse esa protección inferior como ya instalada.

**Validación correctiva propuesta en finalización**

Para afirmar consumo dentro de la ventana, la finalización debe comprobar mediante los campos existentes:

- `consumed_at` no nulo.
- `t0 ≤ tc < eg`.
- `tc < ec`.
- Grant no revocado.
- Correlación y estado correspondientes.

La comparación inferior se identifica expresamente como validación correctiva propuesta, no como garantía física existente. Su inclusión está aprobada únicamente como requisito de especificación y sigue pendiente de implementación y prueba. Si los timestamps no permiten demostrar ese orden, corresponde fail-closed, sin corregir datos, relojes o timestamps por inferencia.

No se añade una condición `hora actual < expiry` para una finalización de consumo previo válido, una igualdad universal nueva entre expiries ni un plazo adicional de finalización.

**Evidencia todavía pendiente**

- Los marcadores persistidos no identifican de forma inmutable al writer.
- El protocolo del Hook aporta garantías adicionales que deben verificarse en el catálogo efectivo.
- No se declara consumo histórico válido en Hosted sin evidencia concreta de campos, correlación, catálogo y contexto.
- Hosted sigue sin demostrar la equivalencia efectiva del Hook, policies y ACL mediante este candidato.

No se proponen columnas nuevas para resolver esta limitación. Fuentes: [TASK-021 §19 (line 1534)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:1534), [TASK-013 grants (line 114)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20260830010000_task_013_verification_challenge_foundation.sql:114), [consumo atómico del Hook (line 776)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql:776) y [policies de coordinación]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql:957).

## 7. Matriz de estados, resultados y deltas

Los códigos siguientes ya existen en el adaptador. Su asignación exacta ha sido aprobada en esta especificación, sin autorización de implementación: [vocabulario RPC (line 123)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/src/modules/identity-authorization/infrastructure/supabase/later-user-auth-session-source.ts:123).

### Precedencia contractual

Las condiciones se evalúan sobre datos correlacionados y revalidados tras los locks. El canon establece las obligaciones de correlación, elegibilidad y terminalidad, pero no prescribe textualmente un orden total para todas sus combinaciones. La siguiente precedencia incorpora la resolución correctiva autorizada para el candidato completo; la especificación está aprobada documentalmente, sin autorización de implementación.

| Prioridad | Condición | Activación | Finalización | Fundamento |
|---|---|---|---|---|
| 1 | Correlación inválida, registro requerido inexistente o ambiguo | `SECURITY_CORRELATION_FAILURE`, D0 | Igual | Ninguna otra condición autoriza operar sobre un contexto ajeno |
| 2 | Estado no admitido para la RPC | `SECURITY_CORRELATION_FAILURE`, D0 | Igual | No reactivar ni cambiar de fase por inferencia |
| 3 | Grant revocado | `SESSION_RECOVERY_REQUIRED`, D0 | `SECURITY_CORRELATION_FAILURE`, D0 | Revocación no concede autorización ni demuestra consumo válido |
| 4 | Consumo incompatible con la fase | Grant consumido: `SECURITY_CORRELATION_FAILURE`, D0 | Grant no consumido o consumo no válido: igual | Activar y finalizar requieren estados distintos del grant |
| 5A | Coordinación expirada durante activación | DE sólo bajo §6.4; en otro caso D0 | No se aplica como deadline nuevo | El disparador existente depende de coordinación y estado |
| 5B | Grant expirado sin cumplirse DE | `SESSION_RECOVERY_REQUIRED`, D0 | Evaluar el momento del consumo, no exigir vigencia actual | Expiry impide consumo nuevo; no borra un consumo válido previo |
| 6 | Identidad incompatible tras superar controles anteriores | `IDENTITY_INCOMPATIBLE`, DR | `IDENTITY_INCOMPATIBLE`, D0 | Sólo una cadena válida habilita reparación de su coordinación |
| 7 | Retry o transición válidos | `ISSUANCE_ACTIVE`, DA | `SESSION_ESTABLISHED`/`SESSION_ALREADY_ESTABLISHED`, DF/D0 | Éxito sólo después de todas las precondiciones |

Precisiones de fase:

- Para activación sólo son admisibles `SUBJECT_CONFIRMED` e `ISSUANCE_ACTIVE`.
- Para finalización son admisibles `GATE_CONSUMED` y el éxito terminal exacto para idempotencia.
- `SESSION_ESTABLISHED_NO_AUTHORITY` no se rechaza por ser terminal cuando se reconoce idempotentemente mediante finalización y sus precondiciones están demostradas.
- `EXPIRED`, `ABANDONED` y `REPAIR_REQUIRED` no se convierten en éxito.
- Consumo y revocación simultáneamente no nulos no son una combinación normal admisible por el CHECK local; no se deshabilita integridad para fabricar esa prueba.
- El control de elegibilidad para activar no se utiliza para bloquear la clasificación independiente de DE sobre una coordinación legítimamente expirada.

Fuentes: [TASK-021 §19 (line 1534)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:1534), [matriz de fallos TASK-021]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:2326), [ADR-0022 activación]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md:1280) y [schema de grants]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20260830010000_task_013_verification_challenge_foundation.sql:114).

Deltas permitidos:

- **D0:** ninguna escritura propia de la RPC.
- **DA:** coordinación exacta `SUBJECT_CONFIRMED → ISSUANCE_ACTIVE`, o retry válido `ISSUANCE_ACTIVE → ISSUANCE_ACTIVE`, con actualización de `updated_at` y sin otro delta.
- **DR:** coordinación exacta a `REPAIR_REQUIRED`, resultado y timestamp.
- **DE:** coordinación exacta desde `SUBJECT_CONFIRMED`, expirada según su propio `expires_at` y sin rechazo prioritario, a `EXPIRED`, con `terminal_result = SESSION_GRANT_EXPIRED` y `updated_at`.
- **DF:** coordinación exacta desde `GATE_CONSUMED` a éxito terminal, resultado y timestamp.

En todos ellos quedan prohibidos cambios de grant, bridge, intent, sujeto, membership, roles o expiry.

| Escenario, superadas las prioridades anteriores           | Resultado propuesto            | Delta                 | Comportamiento del servicio      |
| -------------------------------------------------------- | ------------------------------ | --------------------- | -------------------------------- |
| Correlación inválida, incluso con expiry o incompatibilidad | `SECURITY_CORRELATION_FAILURE` | D0 | No emisión ni entrega |
| Estado no admisible para la RPC | `SECURITY_CORRELATION_FAILURE` | D0 | Sin reactivación |
| Activación válida desde `SUBJECT_CONFIRMED`              | `ISSUANCE_ACTIVE`              | DA                    | Puede iniciar sign-in            |
| Retry válido en `ISSUANCE_ACTIVE`                        | `ISSUANCE_ACTIVE`              | DA                    | Conserva la operación y `updated_at` técnico; sin extensión |
| Grant revocado durante activación, aunque expire la coordinación | `SESSION_RECOVERY_REQUIRED` | D0 | No sign-in |
| Grant consumido incompatible con activación, aunque expire la coordinación | `SECURITY_CORRELATION_FAILURE` | D0 | No sign-in |
| Coordinación expirada en `SUBJECT_CONFIRMED`, sin rechazo prioritario | `SESSION_RECOVERY_REQUIRED` | DE | Recuperación |
| Grant y coordinación expirados en ese mismo caso válido | `SESSION_RECOVERY_REQUIRED` | DE por expiración de coordinación | Recuperación |
| Sólo grant expirado; coordinación aún vigente | `SESSION_RECOVERY_REQUIRED` | D0 | No sign-in |
| Coordinación activa expirada                             | `SESSION_RECOVERY_REQUIRED`    | D0                    | Sin nueva emisión ni limpieza nueva |
| Grant o bridge no correlacionados                        | `SECURITY_CORRELATION_FAILURE` | D0                    | Denegación                       |
| Intent A con coordinación B                              | `SECURITY_CORRELATION_FAILURE` | D0                    | Denegación                       |
| Identidad incompatible, cadena válida y grant elegible   | `IDENTITY_INCOMPATIBLE`        | DR                    | No sign-in                       |
| Finalización válida desde `GATE_CONSUMED`                | `SESSION_ESTABLISHED`          | DF                    | Entrega posterior al commit      |
| Finalización tardía con consumo válido demostrado según §6.7 | `SESSION_ESTABLISHED` | DF | Completa la misma emisión, sin nuevo sign-in |
| Consumo no demostrado, revocado o cronología no válida en finalización | `SECURITY_CORRELATION_FAILURE` | D0 | Sin cookies |
| Incompatibilidad en recheck terminal                     | `IDENTITY_INCOMPATIBLE`        | D0                    | Sin entrega ni liberación tácita |
| Finalización ya completada y correlacionada, con precondiciones válidas | `SESSION_ALREADY_ESTABLISHED` | D0 | Sólo sesión validada |
| Terminal fallido invocado directamente                   | `SECURITY_CORRELATION_FAILURE` | D0                    | Sin reactivación; el servicio normalmente corta antes |
| Error SQL con rollback confirmado                        | Error, sin éxito               | Sin delta de esa transacción | Fallo acotado; conserva efectos previos conocidos |
| Timeout/respuesta perdida/resultado desconocido          | Sin éxito fiable               | Indeterminado hasta reconciliación | No repetir ciegamente; reconciliar antes de continuar |

La distinción entre rechazo y transición legítima conserva los deltas actuales de reparación/expiración: [implementación actual (line 480)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql:480).

La recuperación del servicio puede devolver `SESSION_RECOVERY_REQUIRED` sin invocar finalización cuando no encuentra sesión válida; no se añade ese código al retorno de la RPC finalizadora. Fuentes: [servicio]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/src/modules/identity-authorization/application/later-user-auth-session-service.ts:190) y [adaptador]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/src/modules/identity-authorization/infrastructure/supabase/later-user-auth-session-source.ts:123).

Un timeout de transporte o resultado inesperado del adaptador no demuestra rollback. El commit pudo completarse antes de perderse la respuesta; se conserva la distinción entre rollback confirmado y resultado desconocido: [ADR-0019 §20.10 (line 1613)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md:1613).

## 8. Concurrencia y atomicidad

Debe preservarse:

```
MaintenanceCompany
→ intent
→ AuthSubjectAuthorityAnchor
→ AuthBridgeCredential
→ Coordination
→ SessionGrant
```

Las lecturas preliminares son locators y se revalidan tras los locks. No se añaden locks sobre PlatformUser, mappings o CompanyMembership para comprobar compatibilidad.

La implementación futura deberá demostrar:

- Revocación concurrente serializada correctamente.
- Expiración durante cada espera relevante.
- Activaciones repetidas sin nuevo fence ni extensión.
- Carrera activación–Hook sin doble consumo.
- Finalizaciones repetidas sin nueva emisión.
- Ausencia de deadlocks, esperas no acotadas y mutaciones parciales.
- Ningún lock PostgreSQL mantenido durante I/O del proveedor.

Fuente: [lock graph TASK-021 (line 1721)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:1721).

Toda excepción transaccional debe revertir los cambios de la operación antes de devolver un resultado negativo. No se acepta una denegación que conserve una mutación parcial.

## 9. Seguridad y RLS

La corrección debe conservar exactamente:

- Firmas y tipos de retorno.
- `SECURITY DEFINER`.
- Ownership.
- `search_path`.
- Revocaciones y concesiones EXECUTE.
- RLS y ACL de tablas/columnas.
- Privilegios mínimos de `supabase_auth_admin`.
- Definición del Hook.
- Clasificación de compatibilidad existente.
- Aislamiento entre empresas.
- Ausencia de autoridad tenant por sesión inicial.

No se introduce un cliente privilegiado genérico, secretos en clientes, búsqueda de identidad por email ni cambios de roles.

Las RPC privilegiadas deben validar explícitamente sus bindings; el contexto elevado no vuelve autorizados los argumentos. Fuentes: [ADR-0002 (line 437)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md:437), [ADR-0003 (line 567)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0003-authorization-client-scope-support.md:567), [estrategia RLS (line 1545)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/product/03-permissions-rls-strategy.md:1545) y [hardening permitido por TASK-021 (line 1235)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:1235).

## 10. Failure model

| Fallo                                     | Disposición obligatoria                        |
| ----------------------------------------- | ---------------------------------------------- |
| Consulta de grant vacía                   | No transición de éxito                         |
| Argumentos incoherentes                   | D0                                             |
| Correlación válida pero grant no elegible | Sin nueva autorización                         |
| Cambio de compatibilidad                  | Revalidación bajo anchor y resultado acotado   |
| Expiry durante bloqueo                    | Reevaluación temporal; no timestamp stale      |
| Excepción con rollback confirmado         | No conservar delta parcial                     |
| Resultado RPC desconocido                 | No asumir éxito ni rollback                    |
| Commit remoto con respuesta perdida       | Inspección read-only y reconciliación          |
| Datos incompatibles existentes            | STOP; sin reparación tácita                    |
| Drift de catálogo o ACL                   | STOP                                           |
| Efectos indirectos no calificados         | BLOCKER                                        |
| Fixture en colisión                       | STOP; no borrar datos para habilitar la prueba |

Un timeout no prueba ausencia de efectos. No se permiten reintentos ciegos, reversión automática ni repetición de DDL por una respuesta desconocida. Fuente: [ADR-0019 §20.10 (line 1613)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md:1613).

## 11. Matriz de pruebas

Los identificadores forman parte de la especificación aprobada. **Todos los casos están pendientes y no ejecutados.**

| Test      | Escenario                                     | Evidencia requerida                            |
| --------- | --------------------------------------------- | ---------------------------------------------- |
| T-048-001 | Grant válido                                  | DA y grant intacto                             |
| T-048-002 | Retry activo válido                           | Un fence y mismos bindings; DA con actualización técnica de updated_at, sin extensión de expiries |
| T-048-003 | Grant revocado, incluida coordinación expirada o identidad incompatible | Rechazo prioritario y D0; no DE ni DR          |
| T-048-004 | Grant consumido en estado incoherente, incluida coordinación expirada | Rechazo prioritario y D0; no DE                |
| T-048-005 | Sólo grant expirado y coordinación aún vigente | Sin activación y D0; expiry del grant no dispara DE |
| T-048-006 | Expiry de coordinación y combinación de ambos expiries | DE sólo desde SUBJECT_CONFIRMED con precondiciones válidas; D0 en ISSUANCE_ACTIVE y ante rechazo prioritario |
| T-048-007 | Grant de otro handoff, aunque concurra expiración | Rechazo por correlación con prioridad y D0     |
| T-048-008 | Grant/bridge/sujeto desalineados, con flags concurrentes | D0 por cada binding; ninguna condición posterior habilita una mutación |
| T-048-009 | Intent A + coordinación B, misma empresa, incluso con expiry o incompatibilidad | Rechazo prioritario y ninguna fila de A o B modificada |
| T-048-010 | Intent A + coordinación B, empresas distintas, incluso con expiry o incompatibilidad | Rechazo prioritario y D0 cross-company         |
| T-048-011 | Argumentos nulos o inexistentes               | Fail-closed                                    |
| T-048-012 | Identidad incompatible con condiciones concurrentes | DR sólo con cadena válida y grant elegible tras prioridades; revocación, consumo incompatible o expiración no se convierten en DR |
| T-048-013 | Sin mapping de aplicación                     | Compatibilidad vigente preservada              |
| T-048-014 | PlatformUser no SUPER_ADMIN sin membership    | Compatibilidad preservada                      |
| T-048-015 | SUPER_ADMIN o cualquier membership            | Denegación; incluye disabled/cross-tenant      |
| T-048-016 | Finalización válida                           | DF exacto con consumo no nulo, t0 ≤ tc < eg y tc < ec, grant no revocado y correlación válida |
| T-048-017 | Finalización tardía de consumo previo válido  | Misma emisión y límites de §6.7 demostrados; sin deadline nuevo, nuevo sign-in o extensión; aprobación documental concedida, prueba aún pendiente |
| T-048-018 | Consumo ausente o cronología inválida; fronteras temporales | Sin éxito si tc < t0, tc = eg, tc > eg, tc = ec o tc > ec; tc = t0 y consumo anterior a ambos expiries se evalúan como límites válidos cuando las demás precondiciones cumplen |
| T-048-019 | Finalización idempotente con consumo y terminal válidos | D0 y resultado existente, con cronología de §6.7; sin nuevo consumo ni autorización |
| T-048-020 | Estados terminales fallidos                   | Ninguna reactivación                           |
| T-048-021 | Dos activaciones concurrentes                 | Single-active y ausencia de parcialidad        |
| T-048-022 | Revocación concurrente                        | Orden serial correcto                          |
| T-048-023 | Hook consume mientras llega retry             | Sin reconsumo ni reactivación                  |
| T-048-024 | Dos finalizaciones                            | Una transición terminal                        |
| T-048-025 | Expiry esperando locks                        | Tiempo reevaluado; grant-only expiry produce D0; coordinación expirada produce DE sólo bajo §6.4 y sin rechazo prioritario |
| T-048-026 | Timeout/resultado perdido                     | Reconciliación; sin retry ciego                |
| T-048-027 | Rechazo de activación                         | Servicio no llama sign-in                      |
| T-048-028 | Rechazo de finalización                       | Sin entrega de cookies                         |
| T-048-029 | Regresión Auth Hook                           | Consumo único y caminos históricos preservados |
| T-048-030 | Seguridad/RLS/ACL                             | Ninguna ampliación                             |
| T-048-031 | CORR-047 aplicada                             | Presencia y transiciones compatibles           |
| T-048-032 | Rollback, precedencia, deltas y residuos      | DA/DR/DE/DF o D0 exactamente según §7; preservar efectos previos conocidos; no afirmar D0 para un resultado de transporte desconocido |

### Niveles

- **Local DB:** ejecutar realmente las RPC; los mocks no bastan.
- **Integración local:** servicio, adaptador y boundary de cookies.
- **Concurrencia local:** sesiones/procesos independientes y sincronización observable.
- **Hosted:** verificaciones manuales posteriores a revisión y autorización separadas.

Los negativos deben fallar por la condición investigada. No se deshabilitarán constraints ni se fabricarán fixtures inválidos que produzcan falsos positivos por FK o permisos ajenos.

La evidencia de residuos debe incluir las tablas y efectos indirectos pertinentes. `ROLLBACK` no demuestra por sí solo ausencia de efectos externos.

La cobertura actual de estructura, mocks y harness se conserva como regresión, sin atribuirle prueba de estos predicados: [SQL (line 77)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/tests/database/task_021_later_user_auth_identity_session_foundation.test.sql:77), [TypeScript (line 46)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/tests/task-021-later-user-auth-session.test.ts:46) y [harness (line 1673)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/supabase/tests/database/task_021_later_user_auth_identity_session_concurrency.test.ps1:1673).

## 12. Criterios de aceptación

Todos los criterios permanecen pendientes.

- **AC-048-001:** identidad provisional revisada sin colisión local observada y asignación humana posterior.
- **AC-048-002:** baseline y fuentes revalidados antes de implementación.
- **AC-048-003:** ninguna migración histórica modificada.
- **AC-048-004:** sólo dos cuerpos RPC de producción modificados.
- **AC-048-005:** firmas y vocabulario de resultados preservados.
- **AC-048-006:** activación imposible sin grant elegible demostrado.
- **AC-048-007:** finalización imposible sin consumo correlacionado demostrado.
- **AC-048-008:** `FOUND` o selección estricta gobiernan efectivamente la continuación.
- **AC-048-009:** toda rama mutante valida primero la correlación.
- **AC-048-010:** Intent A + coordinación B produce D0.
- **AC-048-011:** controles temporales reevaluados después de esperas.
- **AC-048-012:** TTL y consumo single-use preservados.
- **AC-048-013:** recuperación tardía conserva la semántica delimitada y su revisión central favorable con condiciones; sólo se implementa tras aprobación definitiva de la especificación, sin plazo adicional.
- **AC-048-014:** terminales no reactivables.
- **AC-048-015:** deltas limitados a DA/DR/DE/DF o D0 según §7; DA admite updated_at en retry activo y DE sólo coordinación expirada en SUBJECT_CONFIRMED sin rechazo prioritario.
- **AC-048-016:** idempotencia sin nuevas identidades ni extensiones; el retry activo conserva la actualización técnica de updated_at bajo DA y la finalización ya completada conserva D0.
- **AC-048-017:** lock graph preservado sin mutex ni locks de identidad nuevos.
- **AC-048-018:** ownership, seguridad, ACL, RLS y Hook sin cambios.
- **AC-048-019:** ninguna autoridad tenant, membership o rol creado.
- **AC-048-020:** rechazo impide sign-in o cookies según su etapa.
- **AC-048-021:** rollback confirmado y resultado desconocido diferenciados.
- **AC-048-022:** matriz de pruebas aprobada y ejecutada con evidencia real de precedencia, condiciones exactas de DE, timestamp del retry activo y fronteras cronológicas de consumo.
- **AC-048-023:** compatibilidad con CORR-047 demostrada.
- **AC-048-024:** ejecución Hosted sólo manual y mediante Gate separado.
- **AC-048-025:** catálogo y residuos postflight verificados.
- **AC-048-026:** trazabilidad Git–despliegue–migration history demostrada sin inferencias.
- **AC-048-027:** trabajo preexistente preservado.
- **AC-048-028:** ningún cierre automático de CORR-047, TASK-021 o fase.

Los criterios materializan [TASK-021 §14/19/21 (line 964)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:964) y conservan la separación de Gates de su [Definition of Done (line 3011)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:3011).

## 13. Procedimiento Hosted futuro — exclusivamente manual

Este apartado no autoriza su ejecución.

### 13.1 Preparación y revisión

Antes de cualquier mutación:

1. Aprobar el SQL exacto y su identidad física.
2. Aprobar por separado aplicación, fixtures, pruebas y eventual limpieza.
3. Fijar el diff de catálogo permitido.
4. Revisar dependencias, triggers y posibles efectos indirectos.
5. Aprobar límites operativos y condiciones de detención.
6. Resolver el mecanismo de trazabilidad del historial.

El SQL destinado al SQL Editor debe ser compatible con ese medio. No se pegará sin revisión un archivo que dependa de comandos de `psql`.

### 13.2 Identidad del target

El operador debe verificar documentalmente y en el proyecto abierto:

```
Expected project name =
software-registros-mantenimiento-dev

Expected project ref =
iedssfqujccxxxmayguy

Expected environment =
HOSTED DEVELOPMENT
```

Estos identificadores aparecen en el antecedente de [binding CORR-043 (line 215)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/CORR-043-task-021-hosted-concurrency-harness-safety-correction.md:215). No constituyen una verificación fresca del proyecto.

Debe acreditarse también la sesión efectiva, su identidad y privilegios, sin publicar credenciales ni inferir Development únicamente por el nombre.

### 13.3 Preflight de catálogo e historial

Comprobar read-only:

- Definiciones efectivas de ambas RPC y sus metadatos.
- Tabla de coordinación, grants, bridge y dependencias.
- RLS, ACL, owners y permisos efectivos.
- Estado de CORR-047 y presencia de su corrección si corresponde.
- Versiones registradas y si la nueva corrección ya está aplicada.
- Coherencia entre catálogo y registro de migración.

Casos STOP:

- Versión ya aplicada.
- Cuerpo nuevo presente sin trazabilidad suficiente.
- Registro existente con catálogo distinto.
- Drift respecto de la fuente revisada.

No se reejecuta DDL para “asegurar” la aplicación.

### 13.4 Datos, colisiones y concurrencia

- Utilizar contadores agregados con visibilidad suficiente.
- No compartir IDs, emails o secretos de datos reales.
- Verificar colisiones de cada fixture aprobado.
- No borrar datos existentes para obtener un preflight positivo.
- Identificar sesiones competidoras y locks relevantes.
- Acreditar independencia real de sesiones de concurrencia.

Si SQL Editor no permite demostrar el escenario concurrente autorizado, esa prueba queda bloqueada. No se sustituye automáticamente por un runner remoto.

### 13.5 Ejecución

Sólo el operador humano autorizado ejecutará PostgreSQL desde Supabase SQL Editor.

La autorización debe identificar:

- Proyecto.
- SQL exacto.
- Fuente Git y SHA-256.
- Precondiciones.
- Deltas permitidos.
- Presupuesto de intentos.
- Procedimiento de postflight.

Codex no ejecutará SQL remoto, CLI, Management API ni harnesses contra Hosted.

### 13.6 Migration history

No se asumirá que ejecutar DDL desde SQL Editor registra una versión en `supabase_migrations.schema_migrations`.

Antes del despliegue debe aprobarse un procedimiento específico que vincule:

- Versión y archivo de migración.
- Commit o blob revisado.
- SQL realmente ejecutado.
- Resultado y catálogo efectivo.
- Registro de migración correspondiente.

La ausencia de ese procedimiento es un blocker. No se autoriza escribir manualmente el historial por inferencia.

### 13.7 Postflight

Obtener evidencia fresca de:

- Las dos definiciones efectivas esperadas.
- Metadatos de seguridad idénticos.
- Cero cambios de catálogo ajenos al alcance.
- Trazabilidad e historial coherentes.
- Pruebas autorizadas y resultados observados.
- Residuos, sesiones y locks.
- Conservación de datos y anchors legítimos.

Toda limpieza requiere alcance aprobado; nunca incluirá datos reales o anchors necesarios para estados vivos.

### 13.8 Resultado desconocido

Ante timeout, desconexión o respuesta perdida:

1. Detener nuevas mutaciones.
2. No repetir la migración ni los tests.
3. Conservar evidencia.
4. Inspeccionar read-only catálogo, historial y datos.
5. Clasificar el resultado como aplicado, no aplicado o indeterminado sólo con evidencia.
6. Solicitar disposición del siguiente Gate.

No se realiza rollback correctivo automático.

## 14. Dependencias y relación con CORR-047

Dependencias necesarias:

- Aprobación de esta especificación y de su identidad.
- Disposición B-1/B-2/B-3.
- Baseline reproducible de las fuentes y prerrequisitos.
- Disponibilidad de herramientas/extensiones para pruebas locales.
- Decisión central sobre interpretación temporal y matriz de resultados.
- Preservación de los quince archivos pendientes.

CORR-047 y esta corrección mantienen ciclos independientes. Ninguna corrige el defecto de la otra. Debe demostrarse el comportamiento conjunto antes de considerar completo el resultado de seguridad pertinente.

El waiver §36.28 conserva su alcance exclusivo y no exceptúa esta matriz. El ledger vigente mantiene §36.29 pendiente: [current-state (line 1576)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/product/11-phase-1-scope-entry-gate.md:1576).

## 15. Plan de ejecución futura y Gates

| Work item propuesto               | Objetivo y archivos                                        | Seguridad y aceptación                     | Dependencias/Gate                                       |
| --------------------------------- | ---------------------------------------------------------- | ------------------------------------------ | ------------------------------------------------------- |
| A — Formalización                 | Revisar candidato, confirmar ID y ruta; sin implementación | Contrato y alcance inequívocos             | Revisión central y aprobación humana                    |
| B — Implementación local          | Una nueva migración y test SQL focalizado                  | Sólo dos cuerpos RPC; AC aplicables        | Canonicalización/incorporación y autorización por paths |
| C — Regresión y concurrencia      | Harness local y tests TypeScript necesarios                | Matriz completa, sin nuevos permisos       | Autorización separada de pruebas                        |
| D — Revisión técnica              | Diff, catálogo, resultados y compatibilidad CORR-047       | Evidencia independiente y cero scope drift | Revisión de implementación                              |
| E — Paquete Hosted                | SQL Editor, manifest, pre/post y trazabilidad              | Ninguna ejecución durante preparación      | Revisión operativa                                      |
| F — Verificación Hosted           | Operador manual                                            | SQL exacto y resultados observados         | Autorización Hosted específica                          |
| G — Persistencia Git y documental | Paths revisados y evidencias finales                       | Sin mezclar trabajo pendiente              | Staging, commit y push separados                        |
| H — Cierre de corrección          | Revisión de AC/DoD y estado                                | Sin cerrar TASK-021 por inferencia         | Cierre documental/humano separado                       |

Cada Gate requiere decisión explícita. Aprobación de especificación, aprobación humana, canonicalización, implementación, pruebas, Hosted, staging, commit, push y cierre no se sustituyen entre sí. Fuente: [TASK-021 DoD (line 3011)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md:3011).

## 16. Definition of Done

- **DoD-048-001:** identidad y ruta confirmadas sin colisión.
- **DoD-048-002:** especificación revisada y aprobada humanamente.
- **DoD-048-003:** canonicalización e incorporación autorizadas y revisadas.
- **DoD-048-004:** condiciones OBS-048-001..005 incorporadas y revisadas en el candidato completo; interpretación temporal, predicados cronológicos y matriz de resultados ratificados mediante los Gates correspondientes, sin equiparar revisión central favorable con aprobación humana definitiva.
- **DoD-048-005:** implementación autorizada por paths.
- **DoD-048-006:** migración forward-only trazable; históricas intactas.
- **DoD-048-007:** sólo dos cuerpos RPC de producción modificados.
- **DoD-048-008:** pruebas locales y concurrentes aprobadas y observadas.
- **DoD-048-009:** seguridad, RLS, ACL, Hook e idempotencia preservados.
- **DoD-048-010:** compatibilidad con CORR-047 demostrada.
- **DoD-048-011:** Hosted ejecutado únicamente mediante autorización manual separada.
- **DoD-048-012:** catálogo, historial y residuos verificados.
- **DoD-048-013:** incorporación Git revisada mediante sus Gates.
- **DoD-048-014:** documentación actualizada mediante autorización específica.
- **DoD-048-015:** revisión y cierre humano de la corrección separados.

El cumplimiento individual de los DoD permanece sujeto a su Gate de verificación; la aprobación humana de la especificación no cierra los demás DoD.

## 17. Blockers y decisiones pendientes

| Elemento                                            | Estado                                             |
| --------------------------------------------------- | -------------------------------------------------- |
| Asignación definitiva CORR-048                      | Confirmada mediante aprobación humana de 2026-11-03                                          |
| Revisión/aprobación de la especificación            | CORR-048 SPECIFICATION REVIEW = APPROVED; CORR-048 HUMAN SPEC APPROVAL = APPROVED; revisión del artefacto aprobado aún pendiente |
| Ratificación de finalización tardía                 | Semántica delimitada aprobada documentalmente; implementación y validación pendientes |
| Matriz exacta de resultados/deltas                  | Precisada en §7 y aprobada documentalmente; implementación y pruebas pendientes |
| B-1 equivalencia Hosted                             | No demostrada                                      |
| B-2 seguridad de efectos indirectos                 | Pendiente                                          |
| B-3 procedencia histórica                           | Pendiente; el commit prospectivo no la reconstruye |
| Pruebas focalizadas                                 | No ejecutadas                                      |
| Procedimiento manual de historial                   | No aprobado                                        |
| Autorizaciones de implementación/pruebas/Hosted/Git | No concedidas por esta aprobación documental       |

La cronología de §6.7 distingue las protecciones instaladas, las garantías del Hook y la validación correctiva propuesta. La comprobación temporal inferior no se presenta como protección existente; su inclusión está aprobada como requisito de especificación, pero su implementación y prueba permanecen pendientes. No se acredita consumo histórico válido en Hosted mediante este documento.

Estos bloqueos no se cierran mediante esta aprobación documental. Sus antecedentes están registrados en [CORR-047 (line 351)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/CORR-047-task-021-6B-002-physical-integrity-correction.md:351).

## 18. Documentos previstos para sincronización al cerrar

Sólo mediante autorización posterior:

1. Especificación canónica de esta corrección: estados, archivos, hashes y evidencia.
2. Ledger TASK-021 §36 y expediente §36.29: disposición de hallazgos y nuevas verificaciones.
3. Registro current-state: resultado acotado sin anticipar cierre de TASK-021.
4. Inventario de migraciones y evidencia de catálogo.
5. Documentación operativa de ejecución manual y trazabilidad.
6. Referencias cruzadas con CORR-047, sin alterar su alcance.
7. Informes F-021-REVIEW-001/002: disposición independiente.

No se prevé cambio conceptual en ADR, RLS ni requisitos de producto. Si surge una necesidad real, se detiene la implementación y se vuelve a revisión.

La actualización documental no debe borrar resultados históricos, convertir §36.28 en PASS técnico ni declarar completada toda TASK-021. Fuente: [disposición documental CORR-047 (line 319)]\(C:/Users/Lenovo/Desktop/Software de registros de mantenimiento/docs/tasks/CORR-047-task-021-6B-002-physical-integrity-correction.md:319).

## 19. Estado de entrega

```
CORR-048 DOCUMENTARY APPROVED ARTIFACT =
GENERATED / PENDING APPROVED ARTIFACT REVIEW

MINIMAL CORRECTIONS OBS-048-001..005 =
AUTHORIZED FOR INCORPORATION INTO COMPLETE CANDIDATE / INCORPORATED

CORR-048 IDENTIFIER =
DEFINITIVE / HUMAN CONFIRMED 2026-11-03

SPECIFICATION REVIEW =
APPROVED

HUMAN SPECIFICATION APPROVAL =
APPROVED / 2026-11-03

APPROVED SOURCE SHA-256 =
8d0f12734fe2623157cb0216068f9657bb721568d5d6aa382ae32d0c92b7af84

PHYSICAL DOCUMENT CREATED =
YES / NEW APPROVED EXTERNAL NON-CANONICAL MARKDOWN ARTIFACT

IMPLEMENTATION / SQL / TESTS =
NOT EXECUTED

REPOSITORY CONTENT MUTATION =
NONE

GIT MUTATION =
NONE

SUPABASE OPERATIONS =
NONE

TASK/CORR GOVERNANCE STATES CHANGED =
CORR-048 SPECIFICATION AND IDENTIFIER ONLY / NO IMPLEMENTATION OR TASK-021 CLOSURE

TASK-021 =
NOT DONE / NOT CLOSED

PHASE 2 =
IN PROGRESS / NOT CLOSED

NEXT GATE =
CORR-048 APPROVED ARTIFACT REVIEW

RETURN TO REVISOR CENTRAL
```