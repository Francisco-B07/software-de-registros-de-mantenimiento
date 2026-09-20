# CORR-028 — TASK-017 Closure State Sync

## 1. Identificación

**ID:** `CORR-028`

**Título:** `CORR-028 — TASK-017 Closure State Sync`

**Clase:** `CLOSURE-STATE / DOCUMENTATION SYNC`

**Naturaleza:** corrección documental controlada de current-state; no constituye implementación ni decisión nueva de producto, arquitectura, seguridad, RLS o multitenancy.

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Archivo de specification:**

`CORR-028-task-017-closure-state-sync.md`

**Ruta canónica futura propuesta:**

`docs/tasks/CORR-028-task-017-closure-state-sync.md`

**Target futuro único:**

`docs/product/11-phase-1-scope-entry-gate.md`

**Additional targets:** `NONE`

**Estado documental después de esta generación:**

`APPROVED`

Esta specification:

```text
generates CORR-028 specification
!=
executes CORR-028
!=
modifies target
!=
canonicalizes CORR-028
!=
authorizes Codex
!=
authorizes repository mutation
!=
authorizes staging / commit / push
!=
determines TASK-018
```

No se modifica el repositorio ni ninguna fuente durante esta generación.

---

## 2. Estado de gobernanza de entrada

Se consume como estado humano vigente:

```text
CORR-028 SPECIFICATION GENERATION GATE =
AUTHORIZED

CORR-028 previous SPECIFICATION GENERATION =
BLOCKER — REQUIRED CANONICAL SOURCE UNAVAILABLE / TARGET BASELINE MATERIAL DRIFT

CORR-028 SPECIFICATION GENERATION BLOCKER REVIEW =
APPROVED

CORR-028 CANONICAL SOURCE RECOVERY =
PASS

CORR-028 CANONICAL SOURCE RECOVERY REVIEW =
APPROVED
```

El Gate original permanece vigente.

El blocker previo se considera resuelto exclusivamente porque el package físico recuperado fue verificado conforme a §3 y porque SOURCE 1 recuperada sustituye, para esta specification, al snapshot stale anteriormente disponible en el chat.

No existe nueva determinación de CORR ni nueva asignación de identidad.

---

## 3. Package autoritativo y verificación física

### 3.1 ZIP recuperado

Package físico utilizado:

`CORR-028-canonical-sources.zip`

Verificación desde bytes físicos reales:

```text
SHA-256 =
9c6ae7c61fa29ff3dd539aa52f0dfecbd1fa8fa8499b9c927faa7058890de3ae

bytes =
68124

entry count =
3

identity verification =
PASS
```

Entries exactas:

1. `SOURCE-01-11-phase-1-scope-entry-gate.md`;
2. `SOURCE-02-TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md`;
3. `SOURCE-05-CORR-026-task-016-closure-state-sync.md`.

No se detectaron entries adicionales ni nombres divergentes.

### 3.2 SOURCE 1 — target canónico recuperado

```text
entry =
SOURCE-01-11-phase-1-scope-entry-gate.md

repo-relative identity =
docs/product/11-phase-1-scope-entry-gate.md

SHA-256 =
10e2bd238af343ab462a14fac3f25bf7473f984ff35c1327ae02219b8b34e513

bytes =
88592

LF =
1505

CRLF =
0

bare CR =
0

trailing-whitespace lines =
9

final newline =
YES

identity verification =
PASS
```

Esta SOURCE 1 representa la baseline exacta recibida para:

```text
HEAD =
27c59c23a2945f44453b10ded79257b2fe182129

working-tree bytes = HEAD blob bytes =
YES
```

La specification no ejecuta Git para revalidar remotamente ese hecho; lo consume como evidencia autoritativa recibida y físicamente coherente con el package.

### 3.3 SOURCE 2 — TASK-017 canonical specification

```text
entry =
SOURCE-02-TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md

repo-relative identity =
docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md

SHA-256 =
6d70b742045537ff5accec07af50b1dbd316301ea1ddf8516c9e2fe040bacad6

bytes =
101908

LF =
2911

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES

identity verification =
PASS
```

SOURCE 2 corresponde al TASK-017 canónico y se utiliza exclusivamente para definir el alcance técnico/funcional cerrado que puede representarse después del cierre.

### 3.4 SOURCE 5 — predecessor pattern

```text
entry =
SOURCE-05-CORR-026-task-016-closure-state-sync.md

repo-relative identity =
docs/tasks/CORR-026-task-016-closure-state-sync.md

SHA-256 =
2b6e56229428ab531776fdc54e96034cced9b03e932514781099c2b423f88d6f

bytes =
46755

LF =
2444

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES

identity verification =
PASS
```

SOURCE 5 confirma:

```text
corresponds to CORR-026 = YES
closure-state sync posterior to TASK-016 = YES
synchronizes current-state documentation = YES
target = docs/product/11-phase-1-scope-entry-gate.md
structural pattern usable for CORR-028 = YES
literal-copy inference = NO
```

### 3.5 Resultado de recuperación

```text
RECOVERED SOURCE PACKAGE IDENTITY FAILURE =
NO

REQUIRED CANONICAL SOURCE UNAVAILABLE =
NO

TARGET BASELINE MATERIAL DRIFT =
RESOLVED BY RECOVERED SOURCE 1
```

---

## 4. Fuentes humanas y Git consumidas

### 4.1 SOURCE 3 — final human closure state

Se consume como evidencia humana autoritativa ya aprobada:

```text
TASK-017 FINAL HUMAN IMPLEMENTATION REVIEW =
APPROVED

TASK-017 FINAL CLOSURE =
APPROVED

TASK-017 =
DONE / CLOSED
```

Este estado no se reconstruye desde SOURCE 1 y no se infiere desde la specification de TASK-017.

Es el estado posterior que CORR-028 debe sincronizar en el current-state registry.

### 4.2 SOURCE 4 — canonical commit

Se consume como commit canónico de TASK-017 y `origin/main`:

```text
canonical commit / origin/main =
27c59c23a2945f44453b10ded79257b2fe182129

parent =
43d4d4bbad845a7762ed7fa6c5c59390c260b872
```

El mismo SHA aparece como baseline de SOURCE 1 recuperada, por lo que existe evidencia suficiente para utilizarlo como referencia de trazabilidad documental de TASK-017 donde la estructura del target lo requiera.

### 4.3 Auxiliary source

`docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md` no fue necesaria como fuente física adicional para esta specification.

La separación requerida entre proof/handoff, onboarding completion y tenant authority está suficientemente soportada por SOURCE 2 y por las invariantes preservadas en SOURCE 1.

Por tanto:

```text
AUXILIARY SOURCE loaded =
NO

source set artificially expanded =
NO
```

---

## 5. Source-of-truth hierarchy

La jerarquía de autoridad se aplica por dimensión, evitando que una fuente se utilice fuera del ámbito que demuestra:

1. **current physical target text** — autoridad para establecer el contenido físico vigente de `docs/product/11-phase-1-scope-entry-gate.md`, sus headings, sus cuatro superficies stale, sus métricas y su whitespace preexistente;
2. **approved final human closure state** — autoridad para establecer que `TASK-017 = DONE / CLOSED` y que su revisión/cierre humano final están aprobados;
3. **canonical TASK-017 specification** — autoridad para delimitar qué implementó y qué no implementó TASK-017;
4. **canonical commit / origin/main evidence** — autoridad para la identidad Git de cierre y trazabilidad de TASK-017;
5. **CORR-026 predecessor pattern** — autoridad únicamente como patrón estructural y de governance de una closure-state sync comparable;
6. documentos históricos anteriores — evidencia de lo que era cierto en su momento, sin prevalecer sobre el estado activo posterior aprobado.

Reglas obligatorias:

```text
later approved TASK-017 closure state
>
older active stale TASK-017 wording
```

pero:

```text
later closure
!=
permission to rewrite historical snapshots
```

además:

```text
TASK-017 implementation detail
!=
new product requirement
```

```text
CORR-026 structural precedent
!=
literal text template
```

---

## 6. Objetivo único

CORR-028 tiene como objetivo exclusivo especificar una futura corrección documental controlada que sincronice el **current-state registry** de:

`docs/product/11-phase-1-scope-entry-gate.md`

posterior al cierre completo de TASK-017.

La futura ejecución deberá actualizar exclusivamente las cuatro superficies activas que aún representan TASK-017 como no determinada/no generada/no iniciada y sustituir esa frontera por el estado post-cierre, sin reescribir historia ni ampliar el resultado funcional de TASK-017.

Debe preservarse:

```text
synchronize current state
!=
rewrite historical state
```

```text
TASK-017 DONE / CLOSED
!=
RF-004 end-to-end complete
```

```text
TASK-017 DONE / CLOSED
!=
RF-012 complete
```

```text
TASK-017 handoff foundation
!=
first-admin onboarding completion
```

CORR-028 no implementa ninguna capability y no determina TASK-018.

---

## 7. Estado autoritativo post-TASK-017 a sincronizar

La futura corrección debe poder representar, donde resulte semánticamente necesario:

```text
TASK-017 =
DONE / CLOSED

TASK-017 FINAL HUMAN IMPLEMENTATION REVIEW =
APPROVED

TASK-017 FINAL CLOSURE =
APPROVED

TASK-017 canonical commit =
27c59c23a2945f44453b10ded79257b2fe182129
```

El resultado acotado de TASK-017 es:

```text
existing active MaintenanceCompany
+
authoritative FirstAdminOnboardingIntent
+
current VerificationChallenge lifecycle
+
valid current proof consumed
+
corresponding SessionGrant
+
authoritative first-admin onboarding handoff durably available
```

La frontera cerrada de TASK-017 termina en:

```text
valid current VerificationChallenge consumed
+
authoritative first-admin onboarding handoff durably available
for a future continuation of RF-012
```

No se permite representar el resultado como onboarding completo.

---

## 8. Product / phase state obligatorio a preservar

Después de la futura sincronización debe permanecer:

```text
Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED

RF-004 =
PARTIAL / NOT END-TO-END

RF-012 =
INCOMPLETE

TASK-018 =
NOT DETERMINED / NOT AUTHORIZED
```

Debe mantenerse explícitamente:

```text
FirstAdminOnboardingIntent handoff
!=
Auth user creation
!=
PlatformUser creation
!=
initial CompanyMembership creation
!=
profile completion
!=
enabled tenant authority
!=
first-admin onboarding completion
```

También debe preservarse:

```text
USER_CREATED producer timing =
NOT RESOLVED BY TASK-017
```

El cierre de TASK-017 no autoriza por inferencia ningún cambio de estos estados.

---

## 9. Auditoría física del target recuperado

### 9.1 Resultado

La lectura de SOURCE 1 recuperada confirma:

```text
target =
docs/product/11-phase-1-scope-entry-gate.md

target count =
1

EXPECTED ACTIVE STALE SURFACES =
4

UNEXPECTED ACTIVE STALE SURFACES =
0

SECOND TARGET REQUIRED =
NO
```

### 9.2 Superficies stale exactas

Las únicas superficies activas que requieren sincronización son:

1. §7.9 — `Otras decisiones DO-*`;
2. §10.2 — `Requisito para entrar en Fase 2`;
3. §14.2 — `Condición adicional para cruzar hacia Fase 2`;
4. §17 — `Resultado final`.

### 9.3 Drift exacto de §7.9

El current-state físico preserva correctamente TASK-016 y ADR-0020, pero termina en:

```text
TASK-017 =
NOT DETERMINED / NOT GENERATED / NOT STARTED

Siguiente TASK autorizada automáticamente =
NO
```

Ese texto era correcto antes de la determinación/implementación/cierre de TASK-017.

Ya no describe el estado activo posterior al cierre.

### 9.4 Drift exacto de §10.2

§10.2 preserva correctamente TASK-016 y el prerequisito arquitectónico ADR-0020, pero todavía declara:

```text
TASK-016 = DONE / CLOSED
!=
TASK-017 determinada automáticamente
```

junto con:

```text
TASK-017 =
NOT DETERMINED / NOT GENERATED / NOT STARTED
```

La frontera actual debe avanzar a TASK-018 sin declarar TASK-018 determinada.

### 9.5 Drift exacto de §14.2

§14.2 conserva el resumen consolidado hasta TASK-016 y ADR-0020 y finaliza con:

```text
Fase 2 =
INICIADA / NOT DONE

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Fase 3 =
NOT STARTED

TASK-017 =
NOT DETERMINED / NOT GENERATED / NOT STARTED

Siguiente TASK autorizada automáticamente =
NO
```

Los estados de fase permanecen correctos; únicamente la frontera TASK-017 está stale.

### 9.6 Drift exacto de §17

El resultado final registra actualmente:

```text
TASK-017 determinada: no
TASK-017 generada: no
TASK-017 iniciada: no
Siguiente TASK autorizada automáticamente: no
```

Debe representar el cierre real de TASK-017 y desplazar la frontera posterior a TASK-018.

### 9.7 Unidad de alcance

Múltiples referencias textuales dentro de una misma sección no constituyen superficies distintas.

La unidad de control es:

```text
semantic current-state surface
```

No se autoriza una quinta superficie.

---

## 10. Scope exacto de futura ejecución

La futura ejecución de CORR-028 queda limitada exactamente a:

```text
target =
docs/product/11-phase-1-scope-entry-gate.md

expected modified existing paths =
EXACTLY 1

new product files =
NONE

deleted files =
NONE

renamed files =
NONE

second target =
PROHIBITED
```

Scope semántico:

1. sustituir la frontera activa pre-TASK-017 por el estado post-cierre;
2. registrar `TASK-017 = DONE / CLOSED`;
3. registrar su revisión/cierre humano final donde corresponda;
4. registrar el commit canónico donde la estructura de la superficie requiera trazabilidad;
5. registrar exclusivamente el resultado bounded de intent/challenge/proof/handoff;
6. preservar TASK-016 y todos los cierres previos;
7. preservar `RF-004 = PARTIAL / NOT END-TO-END`;
8. preservar `RF-012 = INCOMPLETE`;
9. preservar que no existen Auth user, `PlatformUser`, initial `CompanyMembership`, profile completion ni enabled tenant authority derivados de TASK-017;
10. preservar que `USER_CREATED` no fue producido por TASK-017;
11. mantener Phase 2 abierta;
12. mantener Phase 2 Exit Gate no definido/no satisfecho;
13. mantener Phase 3 no iniciada;
14. mover la frontera de gobernanza a TASK-018;
15. mantener TASK-018 no determinada/no autorizada;
16. preservar historia y whitespace no relacionado;
17. dejar diff mínimo y section-limited.

---

## 11. Fuera de scope

CORR-028 no define ni autoriza:

- cambio de producto;
- cambio de arquitectura;
- cambio de dominio;
- cambio de seguridad;
- cambio de RLS;
- cambio de multitenancy;
- código;
- TypeScript;
- React;
- UI funcional;
- Server Actions;
- Route Handlers;
- endpoints;
- SQL;
- migration;
- RPC;
- funciones PostgreSQL;
- nuevas policies;
- grants/revokes;
- schema changes;
- Supabase configuration;
- Auth configuration;
- Hosted mutation;
- JIT mutation;
- Staging environment mutation;
- Production environment mutation;
- Storage;
- Realtime;
- offline implementation;
- tests técnicos de TASK-017;
- rerun de migrations TASK-017;
- modificación de TASK-017 canónica;
- modificación de ADR-0020;
- modificación de CORR-026;
- modificación de CORR-027;
- modificación de otros product docs;
- selección de proveedor de email;
- política de retry/backoff de email;
- durable delivery queue;
- resolución de decisiones diferidas de RF-012;
- definición del momento de creación del Auth user;
- creación de Auth user;
- definición/creación de `PlatformUser` posterior al handoff;
- definición/creación de initial `CompanyMembership` posterior al handoff;
- profile fields/profile persistence;
- transition que habilita tenant authority;
- timing de `USER_CREATED`;
- onboarding completion;
- definición del Phase 2 Exit Gate;
- cierre de Phase 2;
- inicio de Phase 3;
- determinación de TASK-018;
- generación de TASK-018;
- specification de TASK-018.

---

## 12. Matriz de cambios documentales previstos

| Superficie | Significado físico/current | Estado stale exacto | Replacement meaning autorizado | Mutation class | Verificación mínima |
|---|---|---|---|---|---|
| §7.9 | Registry activo de decisiones y cierres acumulados de Fase 2 | TASK-017 aún no determinada/generada/iniciada | Incorporar cierre bounded de TASK-017 y mover frontera a TASK-018 | `CHANGE REQUIRED` | TASK-017 cerrada; TASK-018 no determinada/no autorizada |
| §10.2 | Resumen de entrada/inicio de Fase 2 y estado acumulado de increments | frontera detenida en `TASK-016 DONE != TASK-017 determinada automáticamente` | Añadir TASK-017 cerrada y reemplazar frontera por `TASK-017 DONE != TASK-018 determinada automáticamente` | `CHANGE REQUIRED` | Phase 2 sigue abierta; RF-004/RF-012 no sobredeclarados |
| §14.2 | Resumen consolidado del estado posterior al Gate de Fase 2 | TASK-017 aún pendiente | Incorporar TASK-017 como foundation cerrada sin declarar onboarding completo | `CHANGE REQUIRED` | Exit Gate/Phase 3 invariantes preservadas |
| §17 | Current-state final legible del documento | TASK-017 determinada/generada/iniciada = no | Registrar estados finales TASK-017 y mover frontera a TASK-018 | `CHANGE REQUIRED` | summary final coherente y sin scope creep |

Regla general:

```text
modify semantic current state
with minimum textual diff
```

No se exige uniformar wording si cada sección conserva un estilo propio.

---

## 13. Contrato de modificación — §7.9

### 13.1 Clasificación

```text
ACTIVE STALE REFERENCE — CHANGE REQUIRED
```

### 13.2 Contenido a preservar

Debe preservarse íntegramente:

- catálogo `DO-*` existente;
- historia TASK-008..016 ya sincronizada;
- estados de CORR-020/CORR-021 ya sincronizados;
- `ADR-0019 = ACCEPTED` como antecedente;
- ADR-0020 aceptada/canonicalizada/incorporada;
- todos los límites funcionales negativos que siguen siendo válidos;
- Phase 2 abierta.

### 13.3 Stale state a sustituir

Debe dejar de describir como current state:

```text
TASK-017 =
NOT DETERMINED / NOT GENERATED / NOT STARTED
```

### 13.4 Meaning final mínimo autorizado

Debe incorporar una representación equivalente a:

```text
TASK-017 =
DONE / CLOSED

TASK-017 FINAL HUMAN IMPLEMENTATION REVIEW =
APPROVED

TASK-017 FINAL CLOSURE =
APPROVED
```

Debe resumir su resultado de manera bounded, equivalente a:

```text
authoritative first-admin onboarding intent / challenge / proof-consume / handoff foundation =
IMPLEMENTED AND VERIFIED
```

sin presentar el handoff como onboarding completo.

Cuando resulte adecuado al estilo de §7.9, puede incluir:

```text
TASK-017 canonical commit =
27c59c23a2945f44453b10ded79257b2fe182129
```

### 13.5 Frontera posterior

La sección debe terminar conceptualmente con:

```text
TASK-018 =
NOT DETERMINED / NOT AUTHORIZED

Siguiente TASK autorizada automáticamente =
NO
```

No se requiere inventar estados `NOT GENERATED / NOT STARTED` para TASK-018 si la evidencia humana autorizada sólo fija `NOT DETERMINED / NOT AUTHORIZED`.

### 13.6 Contenido protegido

No convertir:

- intent en user;
- handoff en membership;
- proof en tenant authority;
- provider-neutral delivery port en email end-to-end;
- completion deferred en completed.

---

## 14. Contrato de modificación — §10.2

### 14.1 Clasificación

```text
ACTIVE STALE REFERENCE — CHANGE REQUIRED
```

### 14.2 Contenido a preservar

Debe conservar intactos:

- `ADR-0002 = ACCEPTED`;
- `DO-T03 = RESUELTO/APROBADO`;
- `ADR-0003 = ACCEPTED`;
- Gate de entrada a Fase 2 evaluado/satisfecho;
- formal start de Fase 2;
- cierres TASK-008..016;
- historia ADR-0019;
- ADR-0020 como prerequisito arquitectónico ya resuelto;
- límites funcionales que continúan pendientes.

### 14.3 Frontera stale

La frontera activa actual:

```text
TASK-016 = DONE / CLOSED
!=
TASK-017 determinada automáticamente
```

debe avanzar conceptualmente a:

```text
TASK-017 = DONE / CLOSED
!=
TASK-018 determinada automáticamente
```

### 14.4 Resultado TASK-017 a añadir

La sección debe poder representar, de forma proporcional a su estilo:

```text
TASK-017 =
DONE / CLOSED

TASK-017 FINAL HUMAN IMPLEMENTATION REVIEW =
APPROVED

TASK-017 FINAL CLOSURE =
APPROVED

TASK-017 canonical commit =
27c59c23a2945f44453b10ded79257b2fe182129
```

Resultado funcional máximo:

```text
FirstAdminOnboardingIntent authoritative binding
+
current VerificationChallenge issuance/replacement/verification composition
+
valid proof consumed
+
SessionGrant correlated
+
durable authoritative handoff
```

### 14.5 Límites a declarar o preservar

Debe permanecer inequívoco:

```text
RF-004 =
PARTIAL / NOT END-TO-END

RF-012 =
INCOMPLETE
```

```text
handoff ready
!= Auth user created
!= PlatformUser created
!= CompanyMembership created
!= profile completed
!= enabled tenant authority
!= first-admin onboarding completed
```

### 14.6 Frontera posterior

Debe quedar:

```text
TASK-018 =
NOT DETERMINED / NOT AUTHORIZED
```

sin determinación implícita.

---

## 15. Contrato de modificación — §14.2

### 15.1 Clasificación

```text
ACTIVE STALE REFERENCE — CHANGE REQUIRED
```

### 15.2 Contenido a preservar

Debe conservar:

```text
Fase 2 =
INICIADA / NOT DONE

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Fase 3 =
NOT STARTED
```

También debe conservar los resultados ya cerrados de TASK-008..016 y la historia de ADR-0019/ADR-0020.

### 15.3 Resultado TASK-017 a integrar

El resumen consolidado puede representar de forma equivalente:

```text
existing active MaintenanceCompany
→ authoritative FirstAdminOnboardingIntent
→ current challenge lifecycle
→ current proof consumed
→ durable authoritative onboarding handoff
→ [TASK-017 ENDS]
```

No debe duplicar innecesariamente el diseño físico completo de TASK-017.

### 15.4 Pendientes obligatorios

Debe preservar como no completados:

```text
Auth user creation = NO
PlatformUser creation for first admin = NO
initial CompanyMembership creation = NO
profile completion = NO
enabled tenant authority = NO
first-admin onboarding completion = NO
USER_CREATED producer timing = NOT RESOLVED
RF-004 end-to-end = NO
RF-012 complete = NO
```

Además siguen vigentes los pendientes generales del target no modificados por TASK-017, incluidos Client, UserClientAccess, SupportAccessGrant, Storage, Realtime y Offline donde el current-state ya los representa como pendientes.

### 15.5 Frontera final

Debe terminar conceptualmente en:

```text
Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED

TASK-018 =
NOT DETERMINED / NOT AUTHORIZED

Siguiente TASK autorizada automáticamente =
NO
```

---

## 16. Contrato de modificación — §17

### 16.1 Clasificación

```text
ACTIVE STALE REFERENCE — CHANGE REQUIRED
```

### 16.2 Current state stale

Las líneas activas que actualmente expresan:

```text
TASK-017 determinada: no
TASK-017 generada: no
TASK-017 iniciada: no
```

deben dejar de representar el current state.

### 16.3 Resultado final mínimo a incorporar

El summary final debe incluir, con estilo compatible con el bloque existente:

```text
TASK-017: DONE / CLOSED
TASK-017 FINAL HUMAN IMPLEMENTATION REVIEW: APPROVED
TASK-017 FINAL CLOSURE: APPROVED
TASK-017 canonical commit: 27c59c23a2945f44453b10ded79257b2fe182129
```

Debe representar de forma bounded:

```text
FirstAdminOnboardingIntent foundation: implemented
VerificationChallenge current-proof composition for TASK-017: implemented
valid proof consume + SessionGrant correlation: implemented
first-admin authoritative handoff: implemented
```

No es obligatorio usar esos labels literales si el implementador conserva exactamente el significado aprobado y el estilo de §17.

### 16.4 Límites negativos obligatorios

El bloque final debe preservar o incorporar inequívocamente:

```text
RF-004 end-to-end: no
RF-012 complete: no
Auth user creation for first admin: no
PlatformUser creation for first admin: no
initial CompanyMembership creation: no
profile completion: no
enabled tenant authority: no
first-admin onboarding completed: no
USER_CREATED produced by TASK-017: no
```

### 16.5 Estado de fases y frontera

Debe terminar con sentido equivalente a:

```text
Fase 2 completada: no
Phase 2 Exit Gate: NOT DEFINED / NOT SATISFIED
Fase 3 iniciada: no
TASK-018 determinada: no
TASK-018 autorizada: no
Siguiente TASK autorizada automáticamente: no
```

No debe inventarse `TASK-018 generated = no` o `TASK-018 started = no` como requisito obligatorio si no existe autoridad específica para esos labels.

---

## 17. Superficies READ / PRESERVE — NO CHANGE

Todo el resto de `docs/product/11-phase-1-scope-entry-gate.md` se clasifica:

```text
READ / PRESERVE — NO CHANGE
```

En particular deben preservarse:

- metadata histórica del documento salvo que una línea pertenezca a una de las cuatro superficies autorizadas, lo cual no ocurre en el header;
- propósito, definición y alcance históricos de Fase 1;
- matriz histórica de acciones permitidas/no permitidas de Fase 1;
- Gates históricos de Fase 1;
- secciones que describen correctamente restricciones históricas del momento en que fueron escritas;
- estados `DM-OPEN-*`;
- `FORM-OPEN-*`;
- `EVID-OPEN-*`;
- `RPT-OPEN-*`;
- `AI-OPEN-*`;
- `PAY-OPEN-*`;
- `OFF-OPEN-*`;
- `DO-*` no afectados;
- ADR y deadlines previos;
- cierres TASK-008..016 ya sincronizados;
- referencias históricas correctas;
- cualquier texto que sea histórico y no un current-state registry activo.

Una referencia antigua no se considera stale sólo por contener un estado anterior si está correctamente contextualizada como historia.

---

## 18. CHANGE FORBIDDEN

Durante la futura ejecución está prohibido modificar:

- un segundo archivo;
- una quinta superficie activa;
- headings fuera de las cuatro superficies salvo necesidad estrictamente derivada de editar contenido dentro de ellas;
- IDs de requisitos;
- decisiones abiertas;
- historia documental;
- descripción histórica de Fase 1;
- arquitectura;
- dominio;
- security model;
- RLS model;
- multitenancy;
- Auth/session architecture;
- offline strategy;
- email-provider decision;
- product semantics de RF-004;
- product semantics de RF-012;
- TASK-017 canonical specification;
- ADR-0020;
- CORR-026;
- CORR-027;
- otros product docs;
- whitespace preexistente no relacionado.

También está prohibido:

```text
global Markdown formatting
global rewrap
global whitespace cleanup
line-ending normalization outside required preservation
search/replace global of TASK-017 tokens
```

---

## 19. Resultado bounded de TASK-017 que puede registrarse

### 19.1 Intent

TASK-017 implementa una foundation purpose-specific para `FirstAdminOnboardingIntent` vinculada autoritativamente a:

- una `MaintenanceCompany` existente;
- el email objetivo del primer admin;
- el purpose first-admin onboarding;
- intended role `COMPANY_ADMIN` como consecuencia del purpose, sin crear autoridad tenant.

### 19.2 Challenge

TASK-017 reutiliza la foundation TASK-013 para:

- emitir el primer `VerificationChallenge`;
- mantener un único current challenge;
- autorizar resend/replacement;
- verificar únicamente el current challenge vinculado al intent.

### 19.3 Proof consume y handoff

La transición de éxito compone el consume válido con el `SessionGrant` correspondiente y persiste evidencia durable de handoff.

El resultado permite que una futura continuación de RF-012 derive contexto autoritativo sin confiar en tenant/role/email suministrados por browser.

### 19.4 Frontera terminal de TASK-017

Para TASK-017:

```text
handoff-ready = terminal happy-path boundary
```

No define la continuación posterior.

---

## 20. RF-004 — estado obligatorio

TASK-017 separa:

```text
authoritative business-code issuance
```

de:

```text
external email delivery
```

El delivery boundary es provider-neutral.

Concrete provider selection permanece fuera de scope de TASK-017.

Por tanto, después del cierre:

```text
RF-004 =
PARTIAL / NOT END-TO-END
```

No puede documentarse como completo únicamente porque existen issuance, challenge o delivery port.

---

## 21. RF-012 — estado obligatorio

TASK-017 únicamente proporciona una foundation parcial para la futura continuación de RF-012.

Debe permanecer:

```text
RF-012 =
INCOMPLETE
```

Pendientes incluyen, como mínimo dentro del boundary relevante:

- Auth user creation timing y creación real;
- `PlatformUser` creation timing y creación real;
- initial `CompanyMembership` creation timing y creación real;
- profile fields/persistence y completion;
- exact transition that enables tenant authority;
- eventual onboarding-completion evidence;
- exact `USER_CREATED` producer timing;
- post-handoff completion flow.

CORR-028 no resuelve ninguna de esas cuestiones.

---

## 22. Handoff, identidad y tenant authority

Debe mantenerse expresamente:

```text
intent_id alone != handoff authority
intent_id alone != tenant authority
```

```text
handoff ready
!= Auth user created
!= PlatformUser created
!= CompanyMembership created
!= profile completed
!= enabled tenant authority
!= first-admin onboarding completed
```

El `SessionGrant` asociado conserva sus propias semánticas temporales de TASK-013; el handoff durable no extiende silenciosamente su TTL.

CORR-028 no modifica ese contrato.

---

## 23. Auditoría / USER_CREATED

TASK-017 no produce `USER_CREATED` porque no crea el usuario de aplicación ni su membership.

Debe preservarse:

```text
TASK-017 USER_CREATED producer =
NO
```

`USER_CREATED` queda para la futura transición autoritativa de creación de usuario/membership.

Su timing exacto no se decide mediante CORR-028.

No se crea ni se redefine ninguna acción de `AuditEvent`.

---

## 24. Arquitectura, dominio, seguridad, RLS y multitenancy

### 24.1 Arquitectura

```text
architecture change =
NO

new ADR =
NO
```

CORR-028 documenta un estado cerrado.

No adopta un nuevo patrón técnico ni convierte detalles de TASK-017 en convenciones universales.

### 24.2 Dominio

```text
domain change =
NO
```

No redefine:

- `MaintenanceCompany`;
- `PlatformUser`;
- `CompanyMembership`;
- `VerificationChallenge`;
- `SessionGrant`;
- `FirstAdminOnboardingIntent`;
- onboarding completion.

### 24.3 Seguridad

```text
security change =
NO

Auth/session architecture change =
NO
```

Debe preservarse:

```text
authenticated != authorized
```

```text
current authoritative PostgreSQL state
>
stale token / claim / caller state
```

No se documenta browser-provided tenant/email/role como authority.

### 24.4 RLS y multitenancy

```text
RLS change =
NO

multitenancy change =
NO
```

Debe permanecer:

```text
tenant = MaintenanceCompany
RLS = primary remote isolation boundary
SUPER_ADMIN global != tenant member
SUPER_ADMIN global != ordinary tenant bypass
```

El handoff no crea membership ni tenant authority.

---

## 25. Offline

```text
offline change =
NO
```

CORR-028 no implementa ni modifica:

- Dexie;
- IndexedDB;
- replica local;
- outbox;
- Service Worker;
- offline authorization lease;
- offline onboarding.

Ninguna conclusión sobre offline se deriva del cierre documental de TASK-017.

---

## 26. Supabase / Hosted

La generación y futura ejecución documental de CORR-028 no autorizan:

```text
Supabase Cloud mutation = NO
Hosted mutation = NO
JIT mutation = NO
Staging environment mutation = NO
Production mutation = NO
```

El estado Hosted/implementation de TASK-017, ya revisado y cerrado externamente, se consume sólo como evidencia de cierre cuando corresponda.

CORR-028 no vuelve a ejecutar migrations, tests remotos, RPCs, Auth hooks ni setup de fixtures.

---

## 27. Invariantes físicas de edición

### 27.1 Baseline pre-edit

Una futura ejecución debe usar la SOURCE 1 exacta o verificar que el target actual continúa siendo materialmente compatible antes de escribir.

Baseline conocida de esta specification:

```text
SHA-256 =
10e2bd238af343ab462a14fac3f25bf7473f984ff35c1327ae02219b8b34e513

bytes =
88592

LF =
1505

CRLF =
0

bare CR =
0

trailing-whitespace lines =
9

final newline =
YES
```

### 27.2 Trailing whitespace preexistente

Las líneas de SOURCE 1 con trailing whitespace preexistente son:

```text
3
4
5
6
1415
1416
1417
1418
1419
```

Cinco están físicamente dentro de §17.

Reglas obligatorias:

```text
new trailing whitespace introduced =
NO

global trailing-whitespace cleanup =
NOT AUTHORIZED

pre-existing unrelated trailing whitespace =
PRESERVE

baseline trailing-whitespace lines =
9
```

Un cambio del count sólo puede aceptarse si deriva directamente del reemplazo de una línea físicamente autorizada dentro de §17.

No se autoriza limpiar las líneas 3–6 ni cualquier trailing whitespace fuera de las líneas semánticamente modificadas.

### 27.3 Line endings y newline final

Debe preservarse:

```text
line endings = LF
CRLF introduced = NO
bare CR introduced = NO
final newline = YES
```

### 27.4 Diff

Debe existir:

```text
exact section-limited diff = YES
unrelated content mutation = NO
global reformat = NO
global rewrap = NO
```

---

## 28. Estrategia de ejecución futura

La ejecución de CORR-028 requiere Gate humano separado posterior a aprobación/canonicalización/incorporación de esta specification.

### 28.1 Preflight Git y target

Antes de escribir, el ejecutor debe verificar al menos:

1. repo root;
2. branch;
3. `HEAD`;
4. `origin/main`;
5. divergence;
6. worktree;
7. staged;
8. unstaged;
9. untracked relevante;
10. Git operations in progress;
11. existencia del target;
12. existencia de fuentes canónicas vigentes;
13. SHA-256 pre-edit del target;
14. métricas físicas pre-edit;
15. contenido íntegro actual del target;
16. existencia y función de §7.9, §10.2, §14.2 y §17;
17. exactamente cuatro superficies active stale;
18. cero quinta superficie;
19. exactamente un target;
20. ausencia de decisión posterior que sustituya TASK-017 closure state;
21. ausencia de CORR posterior que ya haya sincronizado el mismo estado;
22. ausencia de target drift que requiera reinterpretar el scope.

### 28.2 Escritura

La futura ejecución debe:

1. modificar exclusivamente `docs/product/11-phase-1-scope-entry-gate.md`;
2. tocar únicamente §7.9, §10.2, §14.2 y §17;
3. preservar TASK-016 y cierres anteriores;
4. registrar TASK-017 cerrada;
5. registrar el resultado bounded sin onboarding scope creep;
6. preservar RF-004 parcial;
7. preservar RF-012 incompleto;
8. preservar ausencia de Auth user/PlatformUser/membership/profile/tenant authority completion;
9. preservar `USER_CREATED` no producido por TASK-017;
10. mantener Phase 2 abierta;
11. mantener Exit Gate no definido/no satisfecho;
12. mantener Phase 3 no iniciada;
13. mover la frontera a TASK-018;
14. no determinar ni autorizar TASK-018;
15. preservar historia;
16. preservar whitespace no relacionado;
17. preservar LF y final newline;
18. dejar diff mínimo;
19. dejar cambios unstaged.

### 28.3 Verificación post-edit

Después de escribir debe comprobarse:

```text
modified files =
EXACTLY 1

modified semantic surfaces =
EXACTLY 4

unexpected fifth surface =
NONE

unexpected second target =
NONE

new trailing whitespace introduced =
NO
```

Debe inspeccionarse el diff literal completo.

`git diff --check` debe ejecutarse e interpretarse sin utilizarlo como pretexto para limpiar whitespace preexistente ajeno. Si falla por cambios nuevos, la ejecución no puede pasar. Si la herramienta reporta únicamente una condición preexistente fuera del diff autorizado, debe documentarse y escalarse sin modificarla por inferencia.

No se requieren reruns técnicos de TASK-017 por esta corrección exclusivamente documental.

### 28.4 Handoff

La ejecución inicial debe terminar con cambios:

```text
unstaged
```

y devolver evidencia al Revisor Central.

Staging, commit y push requieren Gates separados.

---

## 29. Verification plan

La futura verificación debe cubrir como mínimo:

### 29.1 Source/package identity

- ZIP SHA-256 y bytes;
- entry count = 3;
- nombres exactos;
- SOURCE 1 SHA/metrics;
- SOURCE 2 SHA/metrics;
- SOURCE 5 SHA/metrics;
- SOURCE 3 closure evidence todavía vigente;
- SOURCE 4 commit todavía autoritativo o reconciliado por Gate humano posterior.

### 29.2 Target pre-edit

- SHA-256 pre-edit;
- bytes/LF/CRLF/bare CR/trailing/final newline;
- cuatro headings presentes;
- stale state aún físicamente presente;
- ningún sync posterior ya aplicado.

### 29.3 Allowed section set

```text
allowed sections =
§7.9
§10.2
§14.2
§17
```

Todo hunk debe quedar dentro de esas superficies.

### 29.4 Exact diff

Verificar:

- exactamente un path;
- cero archivo nuevo;
- cero archivo borrado;
- cero rename;
- cero hunk fuera de scope;
- cambios semánticos limitados a current-state sync.

### 29.5 Historical-state preservation

Demostrar que no se reescribieron:

- historical Gates de Fase 1;
- estados históricos anteriores contextualizados;
- TASK/CORR previas;
- ADR previos;
- open decisions no relacionadas.

### 29.6 Phase 2 invariant

Debe seguir siendo verdadero:

```text
Phase 2 = IN PROGRESS / NOT CLOSED
Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED
Phase 3 = NOT STARTED
```

### 29.7 RF-004 invariant

Debe seguir siendo:

```text
RF-004 = PARTIAL / NOT END-TO-END
```

### 29.8 RF-012 invariant

Debe seguir siendo:

```text
RF-012 = INCOMPLETE
```

### 29.9 TASK-018 invariant

Debe demostrarse:

```text
TASK-018 determined = NO
TASK-018 authorized = NO
```

No debe aparecer una specification TASK-018 generada por esta ejecución.

### 29.10 Product/architecture/security/RLS/multitenancy

Verificar:

```text
product change = NO
architecture change = NO
domain change = NO
security change = NO
RLS change = NO
multitenancy change = NO
```

### 29.11 Physical invariants

Verificar:

```text
LF preserved = YES
final newline preserved = YES
new trailing whitespace = NO
pre-existing unrelated trailing whitespace preserved = YES
global formatting = NO
```

### 29.12 Post-edit metrics

Calcular y registrar:

- post-edit SHA-256;
- bytes;
- LF;
- CRLF;
- bare CR;
- trailing-whitespace lines;
- final newline.

Cualquier cambio físico debe ser explicable únicamente por las cuatro superficies autorizadas.

### 29.13 Repository state

Después de la ejecución inicial:

- worktree contiene exclusivamente el target modificado;
- staged changes = none;
- no commit;
- no push.

---

## 30. Blockers

### 30.1 Estado actual de specification generation

Después de la recuperación física:

```text
ZIP identity mismatch =
NO

source identity mismatch =
NO

required source unavailable =
NO

expected recovered baseline present =
YES

CORR identity collision =
NO

CORR identifier > 028 collision =
NO

material source contradiction =
NO

new product decision required =
NO

new architecture decision required =
NO

new security/RLS/multitenancy decision required =
NO

Phase 2 Exit Gate determination required =
NO

TASK-018 determination required =
NO

CURRENT SPECIFICATION GENERATION BLOCKER =
NONE
```

### 30.2 Generation blockers

La specification no podría generarse si hubiera ocurrido cualquiera de:

1. ZIP identity mismatch;
2. entry count mismatch;
3. entry-name mismatch;
4. SOURCE 1 identity mismatch;
5. SOURCE 2 identity mismatch;
6. SOURCE 5 identity mismatch;
7. recovered target baseline ausente;
8. SOURCE 3 closure evidence ausente/contradictoria;
9. SOURCE 4 canonical commit evidence insuficiente;
10. CORR-028 identity collision;
11. CORR > 028 collision que invalidara la secuencia;
12. source contradiction material;
13. necesidad de cambiar producto/arquitectura/seguridad/RLS/multitenancy;
14. necesidad de determinar Phase 2 Exit Gate;
15. necesidad de determinar TASK-018.

Ninguno permanece activo en esta generación.

### 30.3 Future execution blockers

La ejecución deberá detenerse si ocurre cualquiera:

1. falta una fuente canónica material;
2. identidad física requerida no coincide;
3. target no existe;
4. Git/current-source identity no puede establecerse;
5. baseline Git difiere materialmente sin reconciliación aprobada;
6. worktree contiene cambios previos incompatibles;
7. existe operación Git incompatible;
8. una de las cuatro superficies cambió materialmente de función;
9. el stale state ya fue sincronizado por otra corrección;
10. aparece una quinta superficie activa stale que requiera corrección;
11. aparece un segundo target;
12. se necesita modificar otro documento producto;
13. no puede preservarse historia sin reescribirla;
14. se necesita cambiar un requisito de producto;
15. se necesita resolver RF-004 por decisión nueva;
16. se necesita resolver RF-012 por decisión nueva;
17. se necesita seleccionar email provider;
18. se necesita definir Auth user creation;
19. se necesita definir PlatformUser creation;
20. se necesita definir initial CompanyMembership creation;
21. se necesita definir profile completion;
22. se necesita definir tenant-authority activation;
23. se necesita definir `USER_CREATED` timing;
24. se necesita nuevo ADR;
25. se necesita modificar arquitectura;
26. se necesita modificar seguridad;
27. se necesita modificar RLS;
28. se necesita modificar multitenancy;
29. se necesita código;
30. se necesita SQL;
31. se necesita migration;
32. se necesita Supabase/Hosted mutation;
33. se necesita Staging/Production environment mutation;
34. se necesita definir Phase 2 Exit Gate;
35. se necesita declarar Phase 2 cerrada;
36. se necesita iniciar Phase 3;
37. se necesita determinar o autorizar TASK-018;
38. se requiere global whitespace cleanup;
39. se requiere global reformat/rewrap;
40. aparece secret/credential;
41. diff contiene path inesperado;
42. diff modifica superficie no autorizada;
43. se introduce nuevo trailing whitespace;
44. line endings dejan de ser LF;
45. se pierde final newline;
46. cualquier Acceptance Criterion aplicable falla.

Labels de referencia:

```text
CORR-028 EXECUTION =
BLOCKER — CANONICAL SOURCE IDENTITY MISMATCH
```

```text
CORR-028 EXECUTION =
BLOCKER — TARGET BASELINE DRIFT
```

```text
CORR-028 EXECUTION =
BLOCKER — UNEXPECTED ACTIVE STALE SURFACE
```

```text
CORR-028 EXECUTION =
BLOCKER — UNEXPECTED SECOND TARGET
```

```text
CORR-028 EXECUTION =
BLOCKER — GIT BASELINE DRIFT
```

```text
CORR-028 EXECUTION =
BLOCKER — PRODUCT / ARCHITECTURE / SECURITY DECISION REQUIRED
```

```text
CORR-028 EXECUTION =
BLOCKER — TASK-018 DETERMINATION REQUIRED
```

Ante cualquier blocker:

```text
NO SILENT REPAIR
NO SCOPE EXPANSION
STOP
NO STAGING
NO COMMIT
NO PUSH
NO TASK-018
RETURN TO REVISOR CENTRAL
```

---

## 31. Acceptance Criteria

Cada criterio aplicable deberá resultar individualmente `PASS` antes de cerrar la etapa correspondiente.

### Identidad y governance

**AC-028-001.** El ID permanece exactamente `CORR-028`.

**AC-028-002.** El título permanece exactamente `CORR-028 — TASK-017 Closure State Sync`.

**AC-028-003.** La clase permanece `CLOSURE-STATE / DOCUMENTATION SYNC`.

**AC-028-004.** La specification permanece exclusivamente documental.

**AC-028-005.** El artefacto de specification se llama exactamente `CORR-028-task-017-closure-state-sync.md`.

**AC-028-006.** La ruta canónica futura propuesta permanece `docs/tasks/CORR-028-task-017-closure-state-sync.md`.

**AC-028-007.** El estado después de generación es `DRAFT — PENDING CENTRAL REVIEW`.

**AC-028-008.** La generación no ejecuta CORR-028.

**AC-028-009.** La generación no canonicaliza CORR-028.

**AC-028-010.** La generación no determina ni autoriza TASK-018.

### Package y fuentes

**AC-028-011.** El ZIP coincide con SHA-256 `9c6ae7c61fa29ff3dd539aa52f0dfecbd1fa8fa8499b9c927faa7058890de3ae`.

**AC-028-012.** El ZIP tiene exactamente `68124` bytes.

**AC-028-013.** El ZIP contiene exactamente tres entries.

**AC-028-014.** Las tres entries tienen exactamente los nombres autorizados.

**AC-028-015.** SOURCE 1 coincide con SHA-256 `10e2bd238af343ab462a14fac3f25bf7473f984ff35c1327ae02219b8b34e513`.

**AC-028-016.** SOURCE 1 conserva métricas `88592 bytes / 1505 LF / 0 CRLF / 0 bare CR / 9 trailing-whitespace lines / final newline YES`.

**AC-028-017.** SOURCE 2 coincide con SHA-256 `6d70b742045537ff5accec07af50b1dbd316301ea1ddf8516c9e2fe040bacad6`.

**AC-028-018.** SOURCE 2 conserva métricas `101908 bytes / 2911 LF / 0 CRLF / 0 bare CR / 0 trailing-whitespace lines / final newline YES`.

**AC-028-019.** SOURCE 5 coincide con SHA-256 `2b6e56229428ab531776fdc54e96034cced9b03e932514781099c2b423f88d6f`.

**AC-028-020.** SOURCE 5 conserva métricas `46755 bytes / 2444 LF / 0 CRLF / 0 bare CR / 0 trailing-whitespace lines / final newline YES`.

**AC-028-021.** SOURCE 3 preserva `TASK-017 FINAL HUMAN IMPLEMENTATION REVIEW = APPROVED`.

**AC-028-022.** SOURCE 3 preserva `TASK-017 FINAL CLOSURE = APPROVED` y `TASK-017 = DONE / CLOSED`.

**AC-028-023.** SOURCE 4 preserva `27c59c23a2945f44453b10ded79257b2fe182129` como canonical commit/origin main.

**AC-028-024.** SOURCE 5 se utiliza como patrón estructural, no como template literal.

### Target y superficies

**AC-028-025.** El único target futuro es `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-028-026.** `additional targets = NONE`.

**AC-028-027.** `expected modified existing paths = EXACTLY 1`.

**AC-028-028.** No se crea un segundo product document.

**AC-028-029.** No se elimina ni renombra ningún archivo.

**AC-028-030.** Las únicas superficies `CHANGE REQUIRED` son §7.9, §10.2, §14.2 y §17.

**AC-028-031.** `EXPECTED ACTIVE STALE SURFACES = 4`.

**AC-028-032.** `UNEXPECTED ACTIVE STALE SURFACES = 0`.

**AC-028-033.** Ninguna quinta superficie se incorpora silenciosamente.

### TASK-017 closure

**AC-028-034.** TASK-017 queda representada como `DONE / CLOSED`.

**AC-028-035.** `TASK-017 FINAL HUMAN IMPLEMENTATION REVIEW = APPROVED` queda representada donde corresponda.

**AC-028-036.** `TASK-017 FINAL CLOSURE = APPROVED` queda representada donde corresponda.

**AC-028-037.** El canonical commit `27c59c23a2945f44453b10ded79257b2fe182129` se registra únicamente donde sea estructuralmente apropiado.

**AC-028-038.** El resultado de TASK-017 queda limitado a intent/challenge/proof-consume/SessionGrant/handoff.

**AC-028-039.** `FirstAdminOnboardingIntent` no se presenta como usuario creado.

**AC-028-040.** Handoff no se presenta como onboarding completion.

**AC-028-041.** Handoff no se presenta como enabled tenant authority.

### RF-004 / RF-012 / onboarding boundaries

**AC-028-042.** `RF-004 = PARTIAL / NOT END-TO-END` permanece.

**AC-028-043.** No se declara concreto ningún email provider.

**AC-028-044.** Provider-neutral delivery boundary no se presenta como delivery end-to-end.

**AC-028-045.** `RF-012 = INCOMPLETE` permanece.

**AC-028-046.** Auth user creation permanece pendiente.

**AC-028-047.** `PlatformUser` creation para first admin permanece pendiente.

**AC-028-048.** initial `CompanyMembership` creation permanece pendiente.

**AC-028-049.** profile completion permanece pendiente.

**AC-028-050.** enabled tenant authority permanece pendiente.

**AC-028-051.** first-admin onboarding completion permanece pendiente.

**AC-028-052.** `USER_CREATED` no se declara producido por TASK-017.

**AC-028-053.** El timing exacto de `USER_CREATED` no se resuelve.

### Fase y frontera posterior

**AC-028-054.** `Phase 2 = IN PROGRESS / NOT CLOSED` permanece.

**AC-028-055.** `Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED` permanece.

**AC-028-056.** `Phase 3 = NOT STARTED` permanece.

**AC-028-057.** TASK-018 permanece `NOT DETERMINED / NOT AUTHORIZED`.

**AC-028-058.** `Siguiente TASK autorizada automáticamente = NO` permanece.

**AC-028-059.** `CORR-028 completed != TASK-018 determined automatically` permanece como regla de governance.

### Historia / arquitectura / seguridad

**AC-028-060.** Los snapshots históricos correctos se preservan.

**AC-028-061.** Los cierres TASK-008..016 no se degradan ni reescriben.

**AC-028-062.** No existe cambio de producto.

**AC-028-063.** No existe cambio de arquitectura ni nuevo ADR.

**AC-028-064.** No existe cambio de dominio.

**AC-028-065.** No existe cambio de seguridad.

**AC-028-066.** No existe cambio de RLS.

**AC-028-067.** No existe cambio de multitenancy.

**AC-028-068.** `authenticated != authorized` permanece.

**AC-028-069.** `SUPER_ADMIN global != tenant bypass` permanece.

**AC-028-070.** TASK-017 handoff no concede tenant membership.

### Physical editing

**AC-028-071.** La futura ejecución modifica exactamente un archivo.

**AC-028-072.** El diff queda semánticamente limitado a cuatro superficies.

**AC-028-073.** No se realiza global Markdown reformat ni global rewrap.

**AC-028-074.** No se introduce nuevo trailing whitespace.

**AC-028-075.** El trailing whitespace preexistente no relacionado se preserva.

**AC-028-076.** Las líneas 3–6 de trailing whitespace preexistente no se limpian.

**AC-028-077.** Un cambio en trailing-whitespace count sólo se acepta cuando deriva directamente de una línea autorizada dentro de §17.

**AC-028-078.** LF se preserva.

**AC-028-079.** CRLF y bare CR no se introducen.

**AC-028-080.** Final newline permanece `YES`.

**AC-028-081.** El SHA-256 pre-edit se registra antes de escribir.

**AC-028-082.** El SHA-256 y las métricas post-edit se registran después de escribir.

**AC-028-083.** El diff literal completo es revisado.

**AC-028-084.** `git diff --check` no detecta errores introducidos por la ejecución.

### Repository / governance

**AC-028-085.** La ejecución inicial deja el cambio unstaged.

**AC-028-086.** No existe Supabase Cloud mutation.

**AC-028-087.** No existe mutación de Hosted, JIT, Staging environment ni Production environment.

**AC-028-088.** No existe código, SQL ni migration.

**AC-028-089.** No aparece material secreto.

**AC-028-090.** Staging requiere Gate humano separado.

**AC-028-091.** Commit requiere Gate humano separado.

**AC-028-092.** Push requiere Gate humano separado.

**AC-028-093.** La verificación exacta de `origin/main` posterior al push es obligatoria antes del cierre.

**AC-028-094.** El cierre humano final es obligatorio antes de declarar CORR-028 `DONE / CLOSED`.

Un único `FAIL` en un criterio aplicable impide declarar satisfactoria la etapa correspondiente.

---

## 32. Definition of Done

CORR-028 sólo podrá considerarse `DONE / CLOSED` cuando se complete íntegramente la secuencia aplicable.

### 32.1 SPECIFICATION

**DoD-028-001.** La specification CORR-028 ha sido generada.

**DoD-028-002.** `CORR-028 SPECIFICATION GENERATION = PASS` ha sido demostrado físicamente.

**DoD-028-003.** La specification se entrega al Revisor Central como `DRAFT — PENDING CENTRAL REVIEW`.

**DoD-028-004.** El Revisor Central completa revisión integral de la specification.

**DoD-028-005.** Cualquier corrección requerida se aplica mediante Gate separado.

**DoD-028-006.** Existe aprobación humana explícita de la specification.

**DoD-028-007.** El approved artifact se genera sólo mediante Gate separado si el workflow lo requiere.

**DoD-028-008.** El approved artifact es revisado por identidad y contenido.

**DoD-028-009.** Existe Gate separado de canonicalization.

**DoD-028-010.** La canonicalización es revisada.

**DoD-028-011.** La specification canónica se incorpora al repositorio sólo mediante Gate separado.

**DoD-028-012.** La incorporación canónica es revisada antes de autorizar ejecución.

### 32.2 EXECUTION

**DoD-028-013.** Existe autorización humana separada y explícita para ejecutar CORR-028.

**DoD-028-014.** Se ejecuta preflight Git fresco inmediatamente antes de la mutación documental.

**DoD-028-015.** Se verifica la identidad actual del target y de las fuentes relevantes.

**DoD-028-016.** Se confirma exactamente un target.

**DoD-028-017.** Se confirman exactamente cuatro superficies autorizadas.

**DoD-028-018.** Se confirma ausencia de quinta superficie activa requerida.

**DoD-028-019.** Se confirma ausencia de una corrección posterior que ya haya sincronizado el estado.

**DoD-028-020.** Se registra SHA-256 y métricas pre-edit.

**DoD-028-021.** Se modifica exactamente `docs/product/11-phase-1-scope-entry-gate.md`.

**DoD-028-022.** §7.9 queda sincronizada.

**DoD-028-023.** §10.2 queda sincronizada.

**DoD-028-024.** §14.2 queda sincronizada.

**DoD-028-025.** §17 queda sincronizada.

**DoD-028-026.** TASK-017 queda `DONE / CLOSED`.

**DoD-028-027.** El cierre humano final de TASK-017 queda representado sin scope creep.

**DoD-028-028.** El canonical commit correcto queda representado donde corresponda.

**DoD-028-029.** El resultado bounded de TASK-017 queda representado sin convertir handoff en onboarding completion.

**DoD-028-030.** RF-004 permanece parcial/no end-to-end.

**DoD-028-031.** RF-012 permanece incompleto.

**DoD-028-032.** Auth user creation permanece pendiente.

**DoD-028-033.** PlatformUser creation permanece pendiente.

**DoD-028-034.** Initial CompanyMembership creation permanece pendiente.

**DoD-028-035.** Profile completion y enabled tenant authority permanecen pendientes.

**DoD-028-036.** `USER_CREATED` no se atribuye a TASK-017.

**DoD-028-037.** Phase 2 continúa abierta.

**DoD-028-038.** Phase 2 Exit Gate continúa `NOT DEFINED / NOT SATISFIED`.

**DoD-028-039.** Phase 3 continúa `NOT STARTED`.

**DoD-028-040.** TASK-018 continúa `NOT DETERMINED / NOT AUTHORIZED`.

**DoD-028-041.** La historia normativa permanece intacta.

**DoD-028-042.** No existe producto/arquitectura/dominio/security/RLS/multitenancy change.

**DoD-028-043.** No existe mutación de Cloud, Hosted, JIT, Staging environment ni Production environment.

**DoD-028-044.** No existe path inesperado ni secret leak.

### 32.3 PHYSICAL VERIFICATION

**DoD-028-045.** El diff contiene exactamente un path modificado.

**DoD-028-046.** El diff contiene únicamente hunks dentro de las cuatro superficies autorizadas.

**DoD-028-047.** No existe global reformat/rewrap.

**DoD-028-048.** LF y final newline se preservan.

**DoD-028-049.** No se introduce nuevo trailing whitespace.

**DoD-028-050.** El trailing whitespace preexistente ajeno se preserva.

**DoD-028-051.** Se registran SHA-256 y métricas post-edit.

**DoD-028-052.** `git diff --check` no reporta errores introducidos por el cambio.

**DoD-028-053.** El diff literal completo es revisado por alcance, historia y invariantes.

**DoD-028-054.** Todos los Acceptance Criteria aplicables resultan PASS.

### 32.4 GIT

**DoD-028-055.** La ejecución inicial termina unstaged.

**DoD-028-056.** Existe Gate humano separado de staging.

**DoD-028-057.** Staging es revisado.

**DoD-028-058.** Existe Gate humano separado de commit.

**DoD-028-059.** Commit es revisado.

**DoD-028-060.** Existe Gate humano separado de push.

**DoD-028-061.** Push es revisado.

**DoD-028-062.** `origin/main` se verifica exactamente después del push.

### 32.5 CLOSURE

**DoD-028-063.** Existe revisión humana final de CORR-028.

**DoD-028-064.** Existe cierre humano final de CORR-028.

**DoD-028-065.** El cierre final preserva explícitamente que CORR-028 cerrado no determina TASK-018.

**DoD-028-066.** El cierre final preserva explícitamente que TASK-017 cerrado no equivale a RF-012 completo ni a first-admin onboarding completo.

Debe preservarse:

```text
specification generation
!=
central review
!=
human approval
!=
approved artifact
!=
canonicalization
!=
repository incorporation
!=
execution authorization
!=
documentation execution
!=
execution review
!=
staging
!=
commit
!=
push
!=
post-push verification
!=
final human closure
```

Además:

```text
CORR-028 SPECIFICATION GENERATION PASS
!=
CORR-028 SPEC REVIEW APPROVED
```

```text
CORR-028 EXECUTION PASS
!=
CORR-028 DONE / CLOSED
```

```text
CORR-028 DONE / CLOSED
!=
TASK-018 DETERMINED
```

---

## 33. Git governance

CORR-028 preserva la secuencia:

```text
specification generation
→ central spec review
→ human specification approval
→ approved artifact gates when applicable
→ canonicalization
→ canonicalization review
→ canonical repository incorporation
→ separate execution authorization
→ fresh Git/target preflight
→ controlled target-only documentation mutation
→ physical/diff verification
→ central execution review
→ staging Gate
→ staging review
→ commit Gate
→ commit review
→ push Gate
→ post-push review
→ exact remote verification
→ final human review
→ final closure
```

La generación actual no autoriza operación Git alguna.

Está prohibido ejecutar por inferencia:

```text
git add
git commit
git push
```

El commit `27c59c23a2945f44453b10ded79257b2fe182129` es evidencia de cierre/canon de TASK-017 y baseline recuperado de SOURCE 1; no es una autorización permanente para una futura ejecución si el repositorio avanza.

Toda futura ejecución debe realizar preflight fresco.

---

## 34. Gate posterior

El resultado de este acto queda limitado a:

```text
CORR-028 SPECIFICATION GENERATION =
PASS

CORR-028 SPECIFICATION =
DRAFT — PENDING CENTRAL REVIEW
```

El siguiente acto corresponde a:

```text
CORR-028 CENTRAL SPEC REVIEW
```

No se autoriza mediante este documento:

- central review approval;
- human specification approval;
- approved artifact generation;
- canonicalization;
- canonical repository incorporation;
- execution;
- Codex;
- target mutation;
- staging;
- commit;
- push;
- Supabase;
- Hosted;
- JIT;
- Staging environment;
- Production;
- TASK-018 determination;
- TASK-018 generation.

---

## 35. Estado de la specification

```text
CORR-028 identifier =
CORR-028

CORR-028 title =
CORR-028 — TASK-017 Closure State Sync

CORR-028 SPECIFICATION GENERATION GATE =
AUTHORIZED

CORR-028 previous blocker =
RESOLVED

recovered ZIP physical identity =
PASS

SOURCE 1 physical identity =
PASS

SOURCE 2 physical identity =
PASS

SOURCE 5 physical identity =
PASS

SOURCE 3 final closure evidence =
AVAILABLE / APPROVED

SOURCE 4 canonical commit evidence =
AVAILABLE

expected target baseline =
PRESENT

material contradictions =
0

target count =
1

expected active stale surfaces =
4

unexpected active stale surfaces =
0

second target required =
NO

CORR-028 SPECIFICATION GENERATION =
PASS

CORR-028 SPECIFICATION =
APPROVED

CORR-028 CENTRAL SPEC REVIEW =
APPROVED

CORR-028 HUMAN SPECIFICATION APPROVAL =
APPROVED

CORR-028 approved artifact =
GENERATED / THIS DOCUMENT

CORR-028 canonicalized =
NO

CORR-028 repository incorporation =
NO

CORR-028 execution authorized =
NO

CORR-028 executed =
NO

CORR-028 closed =
NO

repository mutation =
NO

Codex =
NOT AUTHORIZED

Supabase Cloud =
NO CHANGE

Hosted =
NO CHANGE

JIT =
NO CHANGE

staging =
NO

commit =
NO

push =
NO

TASK-018 =
NOT DETERMINED / NOT AUTHORIZED
```

---

## 36. Autoverificación final

```text
ZIP SHA-256 verified =
YES

ZIP bytes verified =
YES

ZIP entry count verified =
YES

ZIP entry names verified =
YES

SOURCE 1 SHA/metrics verified =
YES

SOURCE 2 SHA/metrics verified =
YES

SOURCE 5 SHA/metrics verified =
YES

SOURCE 1 current baseline inspected =
YES

§7.9 inspected =
YES

§10.2 inspected =
YES

§14.2 inspected =
YES

§17 inspected =
YES

expected target drift still exists =
YES

TASK-017 canonical specification consumed =
YES

TASK-017 final human closure consumed =
YES

TASK-017 canonical commit consumed =
YES

CORR-026 structural pattern consumed =
YES

CORR-028 identity collision =
NO

CORR > 028 collision =
NO

target documents =
1

expected modified paths =
EXACTLY 1

active stale surfaces =
EXACTLY 4

unexpected fifth surface =
NO

history rewrite authorized =
NO

TASK-017 bounded outcome preserved =
YES

RF-004 remains partial / not end-to-end =
YES

RF-012 remains incomplete =
YES

Auth user creation remains incomplete =
YES

PlatformUser creation remains incomplete =
YES

initial CompanyMembership creation remains incomplete =
YES

profile completion remains incomplete =
YES

enabled tenant authority remains incomplete =
YES

USER_CREATED remains unproduced by TASK-017 =
YES

architecture change =
NO

domain change =
NO

security change =
NO

RLS change =
NO

multitenancy change =
NO

offline change =
NO

email-provider decision =
NO

new ADR =
NO

Supabase Cloud change =
NO

repository mutation during generation =
NO

unrelated whitespace cleanup authorized =
NO

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED

TASK-018 =
NOT DETERMINED / NOT AUTHORIZED

current specification generation blocker =
NONE
```

# RESULTADO FINAL

```text
CORR-028 SPECIFICATION GENERATION =
PASS
```

```text
CORR-028 SPECIFICATION =
APPROVED
```

```text
approved artifact =
CORR-028-task-017-closure-state-sync-approved.md
```

```text
repository mutation =
NO
```

```text
TASK-018 =
NOT DETERMINED / NOT AUTHORIZED
```

```text
RETURN TO REVISOR CENTRAL
```
