# CORR-037 — TASK-018 Regression Suite Compatibility with Authorized TASK-019 Profile-Completion UI Extension

## 1. Identificación

**ID:** `CORR-037`

**Título:** `TASK-018 Regression Suite Compatibility with Authorized TASK-019 Profile-Completion UI Extension`

**Tipo:** `REGRESSION COMPATIBILITY / TEST-ONLY CORRECTION`

**Estado de esta specification:** `CANONICALIZED / PENDING CANONICALIZATION REVIEW`

**CORR-037 DETERMINATION:** `APPROVED`

**CORR-037 SPECIFICATION GENERATION AUTHORIZATION:** `APPROVED`

**CORR-037 SPECIFICATION GENERATION:** `PASS`

**CORR-037 SPEC REVIEW:** `APPROVED`

**CORR-037 HUMAN SPEC APPROVAL:** `APPROVED`

**CORR-037 APPROVED ARTIFACT GENERATION:** `PASS`

**CORR-037 approved artifact:** `REVIEW APPROVED`

**CORR-037 APPROVED ARTIFACT REVIEW:** `APPROVED`

**CORR-037 CANONICALIZATION:** `PASS`

**CORR-037 canonicalized:** `YES`

**CORR-037 CANONICALIZATION REVIEW:** `PENDING`

**CORR-037 repository incorporation:** `NO`

**CORR-037 implementation authorization:** `NO`

**CORR-037 implementation:** `NOT PERFORMED`

**Canonical future repo-relative path:** `docs/tasks/CORR-037-task-018-regression-suite-compatibility-task-019-ui-extension.md`

**Repository modified by canonicalization:** `NO`

**Supabase Cloud modified:** `NO`

**Production defect:** `NO`

**TASK-018 production defect:** `NO`

**TASK-019 production defect:** `NO EVIDENCE`

**Correction class:** `REGRESSION COMPATIBILITY / TEST-ONLY`

**Test-only correction:** `YES`

**New ADR required:** `NO`

**Candidate implementation paths:** `1`

**Production paths:** `NONE`

Esta specification define exclusivamente el contrato de una futura corrección test-only. No implementa, no modifica el repositorio, no autoriza Codex, no corrige físicamente tests, no reanuda TASK-019 Work Item F, no genera approved artifact y no canonicaliza.

---

## 2. Estado autoritativo de entrada

Se consume exactamente:

```text
CORR-037 DETERMINATION =
APPROVED

CORR-037 SPECIFICATION GENERATION AUTHORIZATION =
APPROVED

CORR-037 SPECIFICATION GENERATION =
PASS

CORR-037 specification =
HUMAN APPROVED

CORR-037 SPEC REVIEW =
APPROVED

CORR-037 HUMAN SPEC APPROVAL =
APPROVED

CORR-037 APPROVED ARTIFACT GENERATION =
PASS

CORR-037 approved artifact =
REVIEW APPROVED

CORR-037 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-037 implementation =
NOT AUTHORIZED
```

Finding vigente:

```text
F-019-F-001 =
OPEN / ROOT CAUSE CONFIRMED / CORRECTION REQUIRED
```

Clasificación autoritativa:

```text
problem class =
HISTORICAL TASK-018 STATIC UI REGRESSION EXPECTATION
INCOMPATIBLE WITH LATER AUTHORIZED TASK-019 UI EXTENSION

production defect =
NO

TASK-018 production defect =
NO

TASK-019 production defect =
NO EVIDENCE

correction class =
REGRESSION COMPATIBILITY / TEST-ONLY

test-only correction =
YES

new ADR required =
NO
```

TASK-019 permanece:

```text
TASK-019 WORK ITEM F AUTHORIZATION =
APPROVED

TASK-019 WORK ITEM F EXECUTION =
BLOCKED

TASK-019 WORK ITEM F =
STOP — REGRESSION DETECTED / NOT COMPLETE

TASK-019 WORK ITEM F REVIEW =
NOT APPROVED

TASK-019 Work Item F resume =
NOT AUTHORIZED
```

---

## 3. Objetivo único

CORR-037 debe definir una corrección mínima y exclusivamente test-only para `F-019-F-001` que:

1. elimine o sustituya únicamente las expectativas físicas históricas de TASK-018 que fueron legítimamente superadas por TASK-019;
2. preserve los invariantes funcionales y de seguridad de TASK-018 que siguen vigentes;
3. mantenga capacidad real de regresión sobre la frontera `Auth/session → /pending-profile`;
4. reconozca expresamente el ownership posterior de TASK-019 sobre el state gate y la composición de profile-completion UI;
5. evite duplicar innecesariamente la suite propia de TASK-019;
6. no modifique production code;
7. permita que, después de una implementación autorizada y revisada mediante Gates separados, la regresión TASK-018 pueda volver a `PASS`;
8. mantenga bloqueada la reanudación de TASK-019 Work Item F hasta un Gate separado del Revisor Central.

CORR-037 no autoriza implementation code.

---

## 4. Fuentes físicas y canónicas verificadas

### 4.1 Paquete de recuperación

Fuente física utilizada:

```text
TASK-019-work-item-f-regression-source-recovery.zip

SHA-256 =
419e6097339bf8f3e05ed89a122a5faed7d6a958f8eabc307a03dc5c530075b6

bytes =
44508
```

El SHA-256 físico coincide exactamente con el hash autorizado de entrada.

El paquete contiene físicamente SOURCE A, SOURCE B, SOURCE C, SOURCE D y SOURCE E.

### 4.2 SOURCE A — failing TASK-018 test

```text
tests/task-018-first-admin-ui-integration.test.ts

SHA-256 =
ba4b34c65fc7646cff7c1fac9cfd4daeea824031c53923aa422de846a7c83653

bytes =
16099

LF =
472

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES
```

### 4.3 SOURCE B — TASK-019 pending-profile gate

```text
app/pending-profile/page.tsx

SHA-256 =
18ecfa6e0f7ac0a8da8d1b6fa2c123c9415478e2177ecb25d41350d373748cbf

bytes =
944

LF =
35

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES
```

### 4.4 SOURCE C — TASK-019 profile form

```text
app/first-admin-profile-form.tsx

SHA-256 =
900309a1e6a9c97a7416ac0215cd8c2c507435bf023ba1c1409eb0d6b9fe4abe

bytes =
7728

LF =
277

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES
```

### 4.5 SOURCE D — TASK-019 UI tests

```text
tests/task-019-first-admin-ui-integration.test.ts

SHA-256 =
b7e3f85ae08e0f585ede852ab99cc783f6cd356e86932b78fcb183d6a82e8113

bytes =
13425

LF =
394

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES
```

### 4.6 SOURCE E — TASK-018 canonical

```text
docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md

SHA-256 =
f480485516dd0e9855f17f0463ec8a7c410e38ed677e75723bc93f41b2d1a4ae

bytes =
103093

LF =
2534

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES
```

### 4.7 SOURCE F — TASK-019 canonical

```text
docs/tasks/TASK-019-authoritative-first-admin-profile-completion-onboarding-completion-foundation.md

SHA-256 =
281372051bd1fb3791b23a706c7c818da99ff21bf6aa3f70954eeafbb133c902

bytes =
70381
```

El SHA-256 físico coincide exactamente con el hash autorizado de entrada.

### 4.8 SOURCE G — governance precedent

```text
docs/tasks/CORR-036-task-017-regression-suite-compatibility-task-019-schema-extension.md

SHA-256 físicamente verificado =
847581fccf495d8092e3ca62a556d6f951ebd870b71605b44cd2d869ec88f322

bytes =
34005
```

CORR-036 se consume únicamente como precedente de gobernanza para una corrección bounded de regresión histórica incompatible con una extensión posterior autorizada.

No se trasladan requisitos de TASK-017, schema, columnas, foreign keys ni SQL a CORR-037.

### 4.9 Regla de autoridad física

Las fuentes requeridas A..G están físicamente disponibles y fueron verificadas dentro de su alcance.

Por tanto:

```text
BLOCKER — REQUIRED PHYSICAL SOURCE UNAVAILABLE =
NO
```

El `HEAD = fb2a977f2be288312ae9d75fb057cd9dff8ca6f0` incluido en el MANIFEST del paquete de recuperación se trata sólo como snapshot histórico de recuperación de fuentes. No constituye baseline Git autorizada para una futura implementación de CORR-037.

---

## 5. Problema único confirmado

El único problema de CORR-037 es:

```text
F-019-F-001
```

SOURCE A contiene dentro de:

```text
TASK-018 Work Item D minimal UI integration
```

el caso histórico:

```text
renders only the minimal pending-profile shell
```

Ese caso lee directamente el source físico de:

```text
app/pending-profile/page.tsx
```

Y congela estas tres expectativas físicas:

```text
expect(shell).toContain("Sesión establecida");
expect(shell).toContain("Perfil pendiente");
expect(shell).not.toMatch(/<form|<input|dashboard|membership|tenant|from\(|rpc\(/i);
```

SOURCE E demuestra que TASK-018 definió durante su propio incremento:

```text
SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

con significado de:

```text
Supabase Auth session established
+
first-admin profile completion pending
```

También dejó profile form, profile fields y profile persistence fuera del alcance de TASK-018.

SOURCE F posteriormente autoriza expresamente a TASK-019 Work Item E a asumir ownership de:

```text
pending-profile state gate
client profile form
operation-ID retry behavior
onboarding-complete state gate/shell
UI integration tests
```

SOURCE B y SOURCE C materializan esa extensión posterior autorizada:

```text
PENDING_PROFILE
→ render FirstAdminProfileForm

COMPLETED
→ /onboarding-complete

UNAVAILABLE / resolver failure
→ safe entry path
```

Por tanto, el fallo de SOURCE A no demuestra un production defect. Demuestra que una expectativa física histórica de la shell transitoria de TASK-018 quedó incompatible con una extensión UI posterior autorizada por TASK-019.

La corrección correcta es sobre la regression suite histórica, no sobre production code.

---

## 6. Revisión de contradicciones

### 6.1 Resultado

No se detecta una contradicción técnica nueva que requiera modificar dominio, Auth, RLS, multitenancy, Supabase, offline o production UI.

```text
domain behavior change =
NONE

security behavior change =
NONE

RLS change =
NONE

RLS policy creation =
NONE

grant/revoke change =
NONE

multitenancy change =
NONE

Auth change =
NONE

Supabase configuration change =
NONE

Supabase Cloud change =
NONE

offline behavior change =
NONE

production UI change =
NONE

new ADR required =
NO
```

### 6.2 Stop condition

Si una futura implementación descubre que corregir F-019-F-001 requiere cualquiera de esos cambios:

```text
CORR-037 IMPLEMENTATION =
STOP

BLOCKER — NEW TECHNICAL CONTRADICTION
```

No se amplía scope por inferencia.

---

## 7. Implementation boundary congelado

### 7.1 Único path candidato autorizado

```text
authorized implementation path candidate =
tests/task-018-first-admin-ui-integration.test.ts

authorized path count candidate =
1
```

### 7.2 Production paths

```text
production paths =
NONE
```

### 7.3 Fuera de scope

Quedan fuera de scope de implementación CORR-037:

```text
app/pending-profile/page.tsx
app/first-admin-profile-form.tsx
app/onboarding-complete/page.tsx
tests/task-019-first-admin-ui-integration.test.ts
TASK-018 production code
TASK-019 production code
API routes
application services
Supabase migrations
RLS
grants/revokes
Auth configuration
Supabase configuration
TASK-018 canonical
TASK-019 canonical
```

No se permite un segundo path.

Si la implementación requiere otro archivo:

```text
CORR-037 IMPLEMENTATION =
STOP

BLOCKER — ADDITIONAL PATH REQUIRED
```

---

## 8. Ownership cross-task

### 8.1 TASK-018-owned contract todavía vigente

CORR-037 preserva como contrato todavía owned por TASK-018:

```text
successful session destination =
/pending-profile
```

```text
SESSION_ESTABLISHED
+
SESSION_ALREADY_ESTABLISHED
→ same pending-profile destination
```

```text
same bounded browser success
for new-compatible and existing-compatible Auth identity outcomes
```

```text
pathname != tenant authority
```

```text
no tenant metadata leakage
```

```text
no role/provider metadata leakage
```

```text
no authority-bearing URL material
```

```text
no observable branching solely from
new-vs-existing Auth identity
```

```text
safe verification/session boundary
```

También permanecen vigentes los tests TASK-018 de:

- verify antes de establish dentro de una única server orchestration;
- establish sólo después de authoritative `handoffReady`;
- bounded verification/session outcomes;
- cookie/header SSR boundary;
- same-origin request boundary;
- generic/non-enumerating failures;
- exact success destination `/pending-profile`;
- URL sin query/fragment ni authority-bearing material;
- dedicated route locator semantics;
- locator no editable;
- no email-only intent selection;
- no browser persistence de locator/authority material;
- online-only behavior.

CORR-037 no autoriza debilitar ni borrar estos controles por conveniencia.

### 8.2 TASK-019-owned contract posterior

TASK-019 es la autoridad primaria sobre la composición posterior de profile completion UI y debe conservar:

```text
/pending-profile state source =
authenticated authoritative resolver
```

```text
PENDING_PROFILE
→ FirstAdminProfileForm
```

```text
COMPLETED
→ /onboarding-complete
```

```text
UNAVAILABLE / resolver failure
→ safe entry path
```

UI contract vigente:

```text
editable profile fields =
firstName
lastName

tenant selector =
ABSENT

role selector =
ABSENT

editable email =
ABSENT

authority-bearing client fields =
ABSENT
```

Y:

```text
pathname != authority
```

SOURCE D demuestra que TASK-019 ya posee pruebas específicas para state-gating, profile fields, operation-ID retries, onboarding-complete routing y ausencia de authority-bearing/offline/direct-Supabase behavior.

CORR-037 no debe duplicar internamente esa suite salvo el mínimo necesario para comprobar la frontera cross-task TASK-018 → TASK-019.

---

## 9. Clasificación exacta de expectations

### 9.1 OBSOLETE PHYSICAL EXPECTATION — exact copy en page source

La assertion histórica:

```text
expect(shell).toContain("Sesión establecida");
```

es obsoleta como obligación de **ubicación física literal dentro de `app/pending-profile/page.tsx`**.

Justificación:

- TASK-018 exige semántica de session-established/profile-pending, pero no establece esa cadena exacta como immutable cross-task copy contract;
- TASK-019 puede componer la UI mediante un child form sin mantener ese literal en el source de la page;
- SOURCE C actualmente contiene esa copy dentro del profile form, lo que confirma que la semántica puede existir sin residir físicamente en SOURCE B;
- TASK-018 no puede reclamar ownership perpetuo sobre la colocación interna del copy de TASK-019.

Esto no autoriza eliminar la semántica de sesión establecida ni crear branching visible new-vs-existing.

### 9.2 OBSOLETE PHYSICAL EXPECTATION — literal `Perfil pendiente`

La assertion histórica:

```text
expect(shell).toContain("Perfil pendiente");
```

es obsoleta.

Justificación:

- SOURCE E define conceptualmente profile completion pending, no una cadena exacta immutable `"Perfil pendiente"`;
- SOURCE F autoriza una UI funcional de profile completion;
- SOURCE C utiliza copy distinta compatible con la semántica aprobada;
- congelar esa cadena desde TASK-018 impediría evolución UI posterior autorizada sin aportar una frontera funcional o de seguridad estable.

### 9.3 OBSOLETE PHYSICAL EXPECTATION — ausencia absoluta de form/input

Dentro de:

```text
expect(shell).not.toMatch(/<form|<input|dashboard|membership|tenant|from\(|rpc\(/i);
```

la prohibición histórica de:

```text
<form
<input
```

es obsoleta.

Justificación:

- TASK-018 excluyó profile form sólo durante su propio incremento;
- TASK-019 Work Item E autoriza expresamente el profile form;
- SOURCE B renderiza `FirstAdminProfileForm` para `PENDING_PROFILE`;
- SOURCE C contiene exactamente dos inputs editables de profile, de acuerdo con TASK-019;
- restablecer la ausencia de form/input exigiría revertir producción autorizada, lo cual está prohibido por CORR-037.

### 9.4 Compound-regex freeze no puede mantenerse como unidad

La regex histórica mezcla:

```text
superseded UI composition concerns
+
persistent security concerns
```

Por tanto no debe conservarse como una única assertion física indivisible.

La futura corrección debe separar el concern obsoleto de form/input del concern todavía válido de autoridad/no-leakage.

### 9.5 STILL-VALID TASK-018 INVARIANT — destination

Permanece contractual:

```text
SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

SOURCE A ya contiene coverage válida para:

- ambos outcomes → same bounded browser success;
- `router.replace("/pending-profile")`;
- exact destination `/pending-profile`;
- absence de query/fragment;
- absence de authority-bearing URL material.

Esa coverage no debe eliminarse.

### 9.6 STILL-VALID TASK-018 INVARIANT — no new-vs-existing branching

Permanece contractual que el success visible no se bifurque únicamente según si la identidad Auth fue creada o reconciliada.

La futura corrección no debe convertir la extensión TASK-019 en una excusa para exponer provider reconciliation state.

### 9.7 STILL-VALID TASK-018 INVARIANT — pathname is not authority

Llegar a `/pending-profile` no puede conferir por sí mismo tenant authority.

TASK-019 profundiza esa misma regla mediante state resolution autoritativa autenticada antes de renderizar profile completion UI.

Por tanto:

```text
TASK-018 pathname != tenant authority
+
TASK-019 authoritative state gate
=
compatible contracts
```

No existe contradicción entre ambos.

### 9.8 STILL-VALID TASK-018 INVARIANT — no tenant/role/provider leakage

Continúan vigentes:

- no tenant metadata en success URL;
- no role metadata en success URL;
- no provider state en success URL/copy de branching;
- no access/refresh token transport;
- no technical password transport;
- no membership/grant/challenge authority transport;
- generic/non-enumerating failures.

La futura corrección no puede reducir esa coverage.

### 9.9 STILL-VALID TASK-018 INVARIANT — safe verification/session boundary

Continúan vigentes y fuera del finding:

```text
TASK-017 verify
→ authoritative handoffReady
→ TASK-018 establish(intentId)
```

junto con cookies/anti-cache, same-origin, bounded outcomes y locator safety.

CORR-037 no modifica esas assertions.

---

## 10. Modelo de compatibilidad seleccionado

CORR-037 adopta el mismo principio general de bounded historical-regression compatibility usado como precedente en CORR-036, aplicado a UI y sin trasladar sus detalles de schema:

```text
historical task retains ownership of its persistent contract
AND
later authorized task may extend/replace implementation detail inside its approved scope
AND
historical regression must recognize that authorized extension
WITHOUT
turning into generic allow-all
```

Para CORR-037:

```text
TASK-018-owned persistent contract
=
session/navigation/security boundary
```

```text
TASK-019-owned later extension
=
authoritative pending-profile state gate
+ profile form
+ onboarding-complete flow
+ operation-ID retry UI semantics
```

TASK-018 regression debe continuar protegiendo su frontera y dejar de congelar la composición transitoria que TASK-019 fue autorizado a extender.

---

## 11. Correction design requerido

### 11.1 Unidad de corrección

La futura implementación debe concentrarse exclusivamente en el caso histórico de SOURCE A que actualmente exige una static minimal shell en `/pending-profile`.

No se autoriza una reescritura general de `tests/task-018-first-admin-ui-integration.test.ts`.

### 11.2 Assertions a eliminar o sustituir

La implementación debe eliminar o sustituir la dependencia de TASK-018 respecto de:

1. presencia literal de `"Sesión establecida"` dentro del source de `app/pending-profile/page.tsx`;
2. presencia literal de `"Perfil pendiente"` dentro del source de `app/pending-profile/page.tsx`;
3. ausencia absoluta de `<form` en la surface posterior;
4. ausencia absoluta de `<input` en la surface posterior;
5. cualquier equivalente nuevo que vuelva a imponer que `/pending-profile` continúe siendo una static shell sin profile form.

### 11.3 Assertions que deben mantenerse

La implementación debe conservar la coverage ya existente en SOURCE A que prueba, al menos:

1. `SESSION_ESTABLISHED` y `SESSION_ALREADY_ESTABLISHED` producen el mismo bounded success;
2. ambos continúan hacia `/pending-profile`;
3. la navegación usa el destination exacto sin query ni fragment;
4. el destination no transporta intent/email/company/tenant/role/user/membership/grant/challenge/token/provider/reconciliation material;
5. no existe branching visible basado únicamente en new-vs-existing compatible Auth identity;
6. verification precede session establishment;
7. session establishment depende de authoritative handoff;
8. cookie/header boundary permanece segura;
9. failures permanecen bounded y non-enumerating;
10. dedicated route locator continúa sin convertirse en authority;
11. client/browser persistence de locator/authority material permanece ausente;
12. TASK-018 continúa online-only.

### 11.4 Replacement coverage requerida

La corrección no puede consistir únicamente en borrar las tres expectations históricas.

Debe quedar una assertion strategy bounded que demuestre la compatibilidad cross-task actual:

```text
TASK-018 success boundary still lands at /pending-profile
AND
/pending-profile does not derive authority from pathname/browser-owned authority material
AND
TASK-019 may own/render the authorized profile-completion UI behind its authoritative state gate
```

La replacement coverage debe probar solamente la frontera compartida entre TASK-018 y TASK-019.

No debe volver a congelar:

- exact UI copy;
- exact DOM composition del profile form;
- exact número de labels o inputs más allá de lo que ya pertenece a TASK-019;
- internal component layout;
- Tailwind classes;
- internal helper names;
- operation-ID internals;
- onboarding-complete copy;
- TASK-019-specific route branching en detalle cuando SOURCE D ya lo cubre.

### 11.5 Estrategia de assertion permitida

La implementación puede escoger una estrategia behavior-oriented o una source-boundary assertion mínima dentro del único test autorizado, siempre que cumpla simultáneamente:

1. no depende de las strings históricas `"Sesión establecida"` / `"Perfil pendiente"` como copy contractual de TASK-018;
2. no prohíbe form/input autorizado por TASK-019;
3. demuestra que el handoff de TASK-018 sigue terminando en `/pending-profile` sin authority-bearing URL material;
4. demuestra que `/pending-profile` no se trata como autoridad por pathname y permanece detrás de resolución autoritativa de estado;
5. no duplica la verificación detallada de fields/retries/onboarding-complete ya owned por SOURCE D;
6. no introduce una allow-all genérica donde cualquier futura UI change pase sin preservar la frontera de seguridad.

Si una estrategia de source inspection se utiliza, sólo puede congelar hechos cross-task explícitamente canónicos. No puede convertir nombres internos incidentales de TASK-019 en un nuevo immutable contract de TASK-018.

### 11.6 No generic delete-all

Queda prohibido resolver el finding mediante:

```text
delete the failing test
+
add no replacement boundary coverage
```

si ello reduce la capacidad de detectar una futura ruptura real de:

```text
Auth/session success
→ /pending-profile
→ no pathname/URL authority escalation
```

---

## 12. TASK-019 preservation requirements

La implementación CORR-037 debe tratar SOURCE B, SOURCE C y SOURCE D como frozen out-of-scope evidence.

Debe permanecer byte-unchanged:

```text
app/pending-profile/page.tsx
SHA-256 pre-implementation =
18ecfa6e0f7ac0a8da8d1b6fa2c123c9415478e2177ecb25d41350d373748cbf
```

```text
app/first-admin-profile-form.tsx
SHA-256 pre-implementation =
900309a1e6a9c97a7416ac0215cd8c2c507435bf023ba1c1409eb0d6b9fe4abe
```

```text
tests/task-019-first-admin-ui-integration.test.ts
SHA-256 pre-implementation =
b7e3f85ae08e0f585ede852ab99cc783f6cd356e86932b78fcb183d6a82e8113
```

CORR-037 no puede exigir revertir:

- authenticated authoritative pending-profile resolver;
- `COMPLETED → /onboarding-complete`;
- `UNAVAILABLE / resolver failure → safe entry`;
- `PENDING_PROFILE → FirstAdminProfileForm`;
- firstName/lastName editable profile contract;
- absence de tenant selector;
- absence de role selector;
- absence de editable email;
- absence de authority-bearing client fields;
- pathname-not-authority rule;
- operation-ID retry behavior.

---

## 13. Frozen pre-implementation evidence

Una futura implementación autorizada debe comenzar verificando físicamente, antes de editar, como mínimo:

```text
tests/task-018-first-admin-ui-integration.test.ts =
ba4b34c65fc7646cff7c1fac9cfd4daeea824031c53923aa422de846a7c83653

app/pending-profile/page.tsx =
18ecfa6e0f7ac0a8da8d1b6fa2c123c9415478e2177ecb25d41350d373748cbf

app/first-admin-profile-form.tsx =
900309a1e6a9c97a7416ac0215cd8c2c507435bf023ba1c1409eb0d6b9fe4abe

tests/task-019-first-admin-ui-integration.test.ts =
b7e3f85ae08e0f585ede852ab99cc783f6cd356e86932b78fcb183d6a82e8113
```

Purpose:

```text
prove single-test-path mutation
+
prove TASK-019 production/UI sources remain unchanged
```

El SHA de SOURCE A es baseline pre-implementation, no hash esperado post-correction.

Si cualquiera de esos cuatro paths presenta drift antes de una futura implementación autorizada, el implementador no debe asumir equivalencia semántica ni aplicar la corrección sobre una base distinta sin revisión.

Resultado requerido:

```text
CORR-037 IMPLEMENTATION =
STOP / RETURN TO REVISOR CENTRAL
```

salvo que exista un Gate posterior que autorice explícitamente el nuevo baseline.

---

## 14. Seguridad, RLS y multitenancy

### 14.1 Seguridad

CORR-037 no altera comportamiento de seguridad.

Debe preservar:

- `authenticated != authorized`;
- pathname/URL no equivale a tenant authority;
- browser-controlled data no equivale a authority;
- no tenant/role/provider metadata leakage en success destination;
- no secret/token/technical-password transport;
- same-origin boundary vigente;
- generic/non-enumerating failure behavior;
- authoritative resolver de TASK-019 para current onboarding state.

### 14.2 RLS

```text
RLS change =
NONE

RLS policy creation =
NONE
```

No se crea, modifica, relaja ni elimina una policy.

### 14.3 Grants / revokes

```text
grant/revoke change =
NONE
```

### 14.4 Multitenancy

```text
multitenancy change =
NONE
```

No se introduce tenant selector, tenant ID caller-supplied como authority ni bypass cross-tenant.

### 14.5 Auth / Supabase

```text
Auth change =
NONE

Supabase configuration change =
NONE

Supabase Cloud change =
NONE
```

### 14.6 Offline

```text
offline behavior change =
NONE
```

TASK-018 continúa online-only y CORR-037 no introduce outbox, IndexedDB/Dexie, service worker authority ni replay offline.

---

## 15. Expected implementation change

La futura implementación, sólo después de todos los Gates necesarios, debe producir un diff mínimo dentro de:

```text
tests/task-018-first-admin-ui-integration.test.ts
```

El diff debe estar centrado exclusivamente en la expectation histórica de `/pending-profile` que fue superada por TASK-019.

No se espera ningún cambio fuera de ese path.

No se autoriza aquí la forma exacta de código del test corregido.

---

## 16. Test strategy posterior a implementación

Esta specification define las pruebas requeridas para una futura ejecución autorizada, pero no autoriza ejecutarlas ahora como implementación.

### 16.1 Targeted TASK-018 UI integration test

Debe ejecutarse la suite dirigida correspondiente a:

```text
tests/task-018-first-admin-ui-integration.test.ts
```

Resultado requerido:

```text
PASS
```

Debe demostrarse que:

- desaparece el failure explicado por F-019-F-001;
- las assertions persistentes de TASK-018 continúan pasando;
- no se suprime una regresión real mediante eliminación indiscriminada de coverage.

### 16.2 TASK-019 UI integration regression

Debe ejecutarse la suite correspondiente a:

```text
tests/task-019-first-admin-ui-integration.test.ts
```

Resultado requerido:

```text
PASS
```

Su finalidad es demostrar que la corrección histórica de TASK-018 no exige ni produce regresión sobre el ownership UI de TASK-019.

### 16.3 Full npm regression

Debe ejecutarse:

```text
npm test
```

Resultado requerido:

```text
PASS
```

En particular, la superficie previamente fallida por F-019-F-001 debe quedar en `PASS`.

### 16.4 TypeScript / project checks

Deben ejecutarse los checks TypeScript/typecheck exigidos por las convenciones reales del repositorio vigentes al momento de implementación.

No se inventa en esta specification un nombre de script no verificado.

Resultado requerido:

```text
PASS
```

### 16.5 ESLint / static checks

Deben ejecutarse los checks ESLint/static exigidos por las convenciones reales del repositorio vigentes al momento de implementación.

No se inventa en esta specification un nombre de script no verificado.

Resultado requerido:

```text
PASS
```

### 16.6 Git whitespace integrity

Debe ejecutarse:

```text
git diff --check
```

Resultado requerido:

```text
PASS
```

### 16.7 Changed-path evidence

La evidencia posterior debe demostrar:

```text
changed source paths =
EXACTLY 1
```

Y:

```text
changed path =
tests/task-018-first-admin-ui-integration.test.ts
```

Debe demostrarse además que SOURCE B, SOURCE C y SOURCE D permanecen byte-unchanged respecto de los hashes frozen de §13.

### 16.8 No implementation authorization by test plan

La existencia de este test plan no autoriza:

- editar el test;
- ejecutar Codex;
- modificar repositorio;
- staging;
- commit;
- push;
- Supabase Cloud.

---

## 17. Acceptance Criteria

### Scope / governance

**AC-037-001.** Only `tests/task-018-first-admin-ui-integration.test.ts` may change.

**AC-037-002.** No production file changes.

**AC-037-003.** The obsolete exact-copy/static-shell assumptions are removed or bounded.

**AC-037-004.** Still-valid TASK-018 session/navigation/security invariants remain tested.

**AC-037-005.** TASK-019 authoritative pending-profile gate remains byte-unchanged by CORR-037 implementation.

**AC-037-006.** TASK-019 profile-form production source remains byte-unchanged by CORR-037 implementation.

**AC-037-007.** TASK-019 UI integration test source remains outside implementation scope.

### Required regressions

**AC-037-008.** Targeted TASK-018 UI regression passes after correction.

**AC-037-009.** TASK-019 UI integration regression remains passing.

**AC-037-010.** Full `npm test` regression reaches `PASS` for the previously failing surface.

**AC-037-011.** TypeScript/project checks required by repository conventions remain passing.

**AC-037-012.** `git diff --check` passes.

**AC-037-013.** Implementation produces no source mutation outside the single authorized test path.

**AC-037-014.** No staging, commit, push or Supabase Cloud mutation occurs.

**AC-037-015.** F-019-F-001 may be marked `RESOLVED` only after implementation review confirms the corrected regression and preserved invariants.

### Historical expectation correction

**AC-037-016.** TASK-018 no longer requires the literal `"Sesión establecida"` to reside physically in `app/pending-profile/page.tsx`.

**AC-037-017.** TASK-018 no longer requires the literal `"Perfil pendiente"` to reside physically in `app/pending-profile/page.tsx`.

**AC-037-018.** TASK-018 no longer rejects the authorized TASK-019 profile form merely because `<form` or `<input` exists in the profile-completion surface.

**AC-037-019.** The historical compound shell regex is not retained in a form that conflates authorized form/input composition with persistent security requirements.

### Persistent TASK-018 contract

**AC-037-020.** `SESSION_ESTABLISHED` continues to converge to `/pending-profile`.

**AC-037-021.** `SESSION_ALREADY_ESTABLISHED` continues to converge to `/pending-profile`.

**AC-037-022.** Both success outcomes continue to produce the same bounded browser success without observable branching solely from new-vs-existing compatible Auth identity.

**AC-037-023.** The success destination remains exactly `/pending-profile` and carries no query or fragment.

**AC-037-024.** The success destination carries no intent/email/company/tenant/role/user/membership/grant/challenge/token/provider/reconciliation authority material.

**AC-037-025.** Verification still occurs before session establishment in the trusted server orchestration.

**AC-037-026.** Invalid/cross-intent locator or wrong proof still cannot produce session/tenant authority.

**AC-037-027.** Browser persistence/offline mechanisms remain absent from the TASK-018 locator/session authority path.

**AC-037-028.** Visible failures remain bounded and non-enumerating.

### TASK-019 compatibility boundary

**AC-037-029.** `/pending-profile` may render TASK-019 profile-completion UI for authoritative `PENDING_PROFILE` state without being treated as a TASK-018 regression.

**AC-037-030.** `/pending-profile` remains sourced from authenticated authoritative state resolution; pathname alone never establishes authority.

**AC-037-031.** `COMPLETED → /onboarding-complete` remains valid and is not reverted by CORR-037.

**AC-037-032.** `UNAVAILABLE` or authoritative resolver failure continues to fail closed to the safe entry path.

**AC-037-033.** The TASK-019 editable profile contract remains limited to first name and last name; CORR-037 does not add or require tenant selector, role selector, editable email or authority-bearing client fields.

**AC-037-034.** TASK-019 remains the primary regression authority for detailed profile-form composition, operation-ID retry behavior and onboarding-complete state behavior.

**AC-037-035.** CORR-037 replacement coverage does not freeze incidental TASK-019 internal helper names, CSS classes, exact copy or DOM composition as a new TASK-018 cross-task contract.

### Integrity / boundaries

**AC-037-036.** Pre-implementation SOURCE A SHA-256 is verified as `ba4b34c65fc7646cff7c1fac9cfd4daeea824031c53923aa422de846a7c83653` before edit, unless a separate Gate authorizes a new baseline.

**AC-037-037.** Pre-implementation SOURCE B SHA-256 is verified as `18ecfa6e0f7ac0a8da8d1b6fa2c123c9415478e2177ecb25d41350d373748cbf` and remains unchanged.

**AC-037-038.** Pre-implementation SOURCE C SHA-256 is verified as `900309a1e6a9c97a7416ac0215cd8c2c507435bf023ba1c1409eb0d6b9fe4abe` and remains unchanged.

**AC-037-039.** Pre-implementation SOURCE D SHA-256 is verified as `b7e3f85ae08e0f585ede852ab99cc783f6cd356e86932b78fcb183d6a82e8113` and remains unchanged.

**AC-037-040.** Domain, security, RLS, grants/revokes, multitenancy, Auth, Supabase configuration, Supabase Cloud, offline behavior and production UI deltas are all `NONE`.

**AC-037-041.** No new ADR is required or introduced by implementation.

**AC-037-042.** TASK-019 Work Item F is not resumed by CORR-037 implementation itself; resume requires a separate Revisor Central Gate after review.

---

## 18. Definition of Done

**DoD-037-001.** `CORR-037 DETERMINATION = APPROVED`.

**DoD-037-002.** This specification was generated from physically available SOURCE A..G.

**DoD-037-003.** The recovery ZIP hash matched `419e6097339bf8f3e05ed89a122a5faed7d6a958f8eabc307a03dc5c530075b6`.

**DoD-037-004.** Specification is reviewed and approved before implementation.

**DoD-037-005.** Human specification approval occurs through a separate Gate.

**DoD-037-006.** Approved artifact generation, if later authorized, occurs through a separate Gate.

**DoD-037-007.** Canonicalization, if later authorized, occurs through a separate Gate.

**DoD-037-008.** Repository incorporation of the specification, if later authorized, occurs through a separate Gate.

**DoD-037-009.** A separate human authorization exists before implementation.

**DoD-037-010.** A fresh implementation preflight verifies the authorized baseline and the four frozen source hashes.

**DoD-037-011.** Only the authorized test path changes.

**DoD-037-012.** Production paths remain unchanged.

**DoD-037-013.** The obsolete exact-copy/static-shell expectations are removed or replaced without deleting persistent contract coverage.

**DoD-037-014.** Successful session destination remains `/pending-profile`.

**DoD-037-015.** `SESSION_ESTABLISHED` and `SESSION_ALREADY_ESTABLISHED` continue to converge to the same pending-profile destination.

**DoD-037-016.** Pathname remains non-authoritative.

**DoD-037-017.** No tenant/role/provider/authority-bearing URL leakage is introduced.

**DoD-037-018.** Safe verification/session boundary remains unchanged.

**DoD-037-019.** TASK-019 authoritative pending-profile gate remains unchanged.

**DoD-037-020.** TASK-019 profile form remains unchanged.

**DoD-037-021.** TASK-019 UI integration test source remains unchanged.

**DoD-037-022.** Targeted TASK-018 regression = `PASS`.

**DoD-037-023.** TASK-019 UI regression = `PASS`.

**DoD-037-024.** `npm test = PASS`.

**DoD-037-025.** Required TypeScript/typecheck/project checks = `PASS`.

**DoD-037-026.** Required ESLint/static checks = `PASS`.

**DoD-037-027.** `git diff --check = PASS`.

**DoD-037-028.** Changed-path evidence proves exactly one source path changed.

**DoD-037-029.** SOURCE B, SOURCE C and SOURCE D hashes prove no mutation to TASK-019 production/UI sources.

**DoD-037-030.** Security/RLS/multitenancy behavior is unchanged.

**DoD-037-031.** Domain/Auth/offline behavior is unchanged.

**DoD-037-032.** New ADR required = `NO`.

**DoD-037-033.** Staging = `NOT PERFORMED` unless separately authorized after the required Gates.

**DoD-037-034.** Commit = `NOT PERFORMED` unless separately authorized after the required Gates.

**DoD-037-035.** Push = `NOT PERFORMED` unless separately authorized after the required Gates.

**DoD-037-036.** Supabase Cloud mutation = `NONE`.

**DoD-037-037.** `F-019-F-001` is resolved only after implementation review verifies the corrected regression and preserved invariants.

**DoD-037-038.** TASK-019 Work Item F resume requires a separate Revisor Central Gate.

**DoD-037-039.** Phase 2 is not closed by inference.

**DoD-037-040.** Phase 3 is not started.

---

## 19. Implementation blockers / STOP conditions

A future implementation must stop and return to Revisor Central if any of the following occurs:

1. more than one implementation path is required;
2. any production file must change;
3. `app/pending-profile/page.tsx` must change;
4. `app/first-admin-profile-form.tsx` must change;
5. `app/onboarding-complete/page.tsx` must change;
6. `tests/task-019-first-admin-ui-integration.test.ts` must change;
7. an API route or application service must change;
8. schema, migration, RLS, grant/revoke or Supabase configuration must change;
9. Auth behavior must change;
10. multitenancy behavior must change;
11. offline behavior must change;
12. a new ADR appears necessary;
13. F-019-F-001 is discovered to represent a production defect rather than a historical test incompatibility;
14. the correction can pass only by weakening unrelated still-valid TASK-018 assertions;
15. the correction can pass only by reverting authorized TASK-019 Work Item E behavior;
16. the correction can pass only by making TASK-018 generically accept arbitrary future UI/security drift;
17. any frozen source hash has unexpected pre-implementation drift without a separate authorized baseline update;
18. TASK-019 UI regression fails for a reason not explained by CORR-037;
19. full regression reveals an unrelated production failure.

Ante cualquiera:

```text
CORR-037 IMPLEMENTATION =
STOP / BLOCKER

no silent repair
no scope expansion
RETURN TO REVISOR CENTRAL
```

---

## 20. Review evidence required after a future implementation

La futura implementation review debe recibir evidencia suficiente para verificar, como mínimo:

```text
pre-implementation SOURCE A SHA-256
post-implementation SOURCE A SHA-256
```

```text
SOURCE B SHA-256 before/after
SOURCE C SHA-256 before/after
SOURCE D SHA-256 before/after
```

```text
changed path list
```

```text
targeted TASK-018 UI regression result
TASK-019 UI regression result
npm test result
TypeScript/project checks result
ESLint/static checks result
git diff --check result
```

Y una revisión semántica que confirme:

```text
obsolete implementation detail removed/bounded = YES
persistent functional/security contract preserved = YES
TASK-019 Work Item E reverted = NO
production mutation = NO
```

Esa evidencia no se produce en este Gate de specification generation.

---

## 21. No-op surfaces

CORR-037 no cambia ni decide:

- domain model;
- CompanyMembership;
- PlatformUser;
- tenant authority;
- role assignment;
- RLS;
- grants/revokes;
- Supabase Auth session architecture;
- VerificationChallenge;
- FirstAdminOnboardingIntent semantics;
- profile persistence semantics;
- onboarding-completion transaction semantics;
- offline strategy;
- Storage;
- Realtime;
- reporting;
- AI;
- subscription/payments;
- Phase 2 Exit Gate;
- Phase 3 entry.

---

## 22. Governance

Debe permanecer:

```text
CORR-037 DETERMINATION =
APPROVED

CORR-037 SPECIFICATION GENERATION AUTHORIZATION =
APPROVED

CORR-037 SPECIFICATION GENERATION =
PASS

CORR-037 specification =
HUMAN APPROVED

CORR-037 SPEC REVIEW =
APPROVED

CORR-037 HUMAN SPEC APPROVAL =
APPROVED

CORR-037 APPROVED ARTIFACT GENERATION =
PASS

CORR-037 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-037 approved artifact =
REVIEW APPROVED

CORR-037 CANONICALIZATION =
PASS

CORR-037 canonicalized =
YES

CORR-037 CANONICALIZATION REVIEW =
PENDING

CORR-037 repository incorporation =
NO

CORR-037 implementation authorization =
NO

CORR-037 implementation =
NOT PERFORMED

Repository modified by canonicalization =
NO

Supabase Cloud modified =
NO

F-019-F-001 =
OPEN

TASK-019 WORK ITEM F =
STOP — REGRESSION DETECTED / NOT COMPLETE

TASK-019 WORK ITEM F REVIEW =
NOT APPROVED

TASK-019 Work Item F resume =
NOT AUTHORIZED

staging =
NOT AUTHORIZED

commit =
NOT AUTHORIZED

push =
NOT AUTHORIZED

Supabase Cloud =
NOT AUTHORIZED

TASK-019 closure =
NOT AUTHORIZED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 3 =
NOT STARTED
```

Specification generation no autoriza:

```text
spec review approval
human approval
approved artifact
canonicalization
repository incorporation
implementation
staging
commit
push
```

Todos permanecen como Gates separados.

Approved artifact generation no autoriza:

```text
approved artifact review approval
canonicalization
repository incorporation
implementation
staging
commit
push
```

Canonicalization no autoriza:

```text
canonicalization review approval
repository incorporation
implementation
staging
commit
push
```

Secuencia futura obligatoria:

```text
CORR-037 CANONICALIZATION REVIEW
→ REPOSITORY INCORPORATION AUTHORIZATION
→ REPOSITORY INCORPORATION
→ REPOSITORY INCORPORATION REVIEW
→ CORR-037 IMPLEMENTATION AUTHORIZATION
→ CORR-037 IMPLEMENTATION
→ CORR-037 IMPLEMENTATION REVIEW
→ TASK-019 WORK ITEM F RESUME AUTHORIZATION
```

Ningún Gate implica automáticamente el siguiente.

Staging, commit y push permanecen sujetos a Gates humanos separados.

---

## 23. Resultado de esta canonicalization

```text
CORR-037 CANONICALIZATION =
PASS

CORR-037 canonicalized =
YES

CORR-037 CANONICALIZATION REVIEW =
PENDING
```

El candidato canónico queda preparado exclusivamente para:

```text
next Gate =
CORR-037 CANONICALIZATION REVIEW

DESTINO =
REVISOR CENTRAL
```

No se ejecuta ese review en este artefacto.
