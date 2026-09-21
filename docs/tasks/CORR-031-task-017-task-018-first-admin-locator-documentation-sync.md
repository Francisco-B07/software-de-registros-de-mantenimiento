# CORR-031 — TASK-017 / TASK-018 FIRST-ADMIN LOCATOR DOCUMENTATION SYNC

## 1. Identificación

**ID:** `CORR-031`

**Título:** `CORR-031 — TASK-017 / TASK-018 FIRST-ADMIN LOCATOR DOCUMENTATION SYNC`

**Tipo:** `DOCUMENTATION CORRECTION SPECIFICATION`

**Naturaleza:** sincronización documental mínima de decisiones ya aprobadas; no constituye decisión nueva de producto, arquitectura, dominio, seguridad, RLS ni implementación.

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Estado de esta specification:**

```text
CORR-031 SPECIFICATION =
APPROVED

CORR-031 SPEC REVIEW =
APPROVED

CORR-031 HUMAN SPEC APPROVAL =
APPROVED
```

**Gate consumido:** reanudación del Gate existente desde `source verification`; no se inicia una nueva determinación ni un nuevo Gate.

**Implementación / ejecución documental autorizada:** `NO`

**Codex autorizado:** `NO`

**Repositorio modificado durante esta specification:** `NO`

**Supabase / Hosted Development modificado:** `NO / NO`

**Staging / commit / push:** `NO / NO / NO`

**TASK-018 Work Item D correction:** `NOT AUTHORIZED`

**WORK ITEM E:** `NOT AUTHORIZED`

**TASK-019:** `NOT DETERMINED / NOT AUTHORIZED`

---

## 2. Contexto autoritativo consumido

CORR-030 completó su ciclo documental y canónico con el estado recibido:

```text
CORR-030 =
APPROVED / CANONICAL / REMOTELY INCORPORATED / REMOTELY VERIFIED
```

Ruta canónica:

```text
docs/tasks/CORR-030-task-018-first-admin-intent-locator-delivery-navigation-decision.md
```

SHA-256 canónico:

```text
7a9bb2a4c17c2fcaee6d893fb539bb6211c50d0fd3f4123092e634666a9916fa
```

Canonical commit recibido:

```text
5c3e91a9a1e4328d95bb8cdd36e5cff9d28ac709
```

CORR-030 determina expresamente:

```text
TASK-017 DOCUMENTATION SYNC REQUIRED = YES — MINIMAL
TASK-018 DOCUMENTATION SYNC REQUIRED = YES — MINIMAL
NEW ADR REQUIRED = NO
PRODUCT DOC UPDATE REQUIRED = NO
DOMAIN MODEL UPDATE REQUIRED = NO
RLS UPDATE REQUIRED = NO
CORR-029 UPDATE REQUIRED = NO
```

CORR-031 consume esas decisiones sin reabrirlas.

---

## 3. Reanudación del Gate y verificación física de fuentes

### 3.1 Estado previo del Gate

El intento anterior se detuvo correctamente con:

```text
CORR-031 SPECIFICATION =
BLOCKER — REQUIRED CANONICAL SOURCE UNAVAILABLE
```

porque las fuentes A, B, C, D y F no estaban físicamente disponibles en ese momento.

Se reanuda exactamente el mismo Gate desde la verificación de fuentes, sin repetir una determinación ni inferir contenido desde resúmenes.

### 3.2 Package físico recibido

Se recibió físicamente:

```text
CORR-031-required-canonical-sources.zip
```

El package contiene exactamente seis archivos, correspondientes uno a uno a SOURCE A..F. Los prefijos `01-`..`06-` pertenecen únicamente al package de transporte y no cambian las rutas canónicas de los documentos.

### 3.3 Resultado de integridad A..F

| Source | Documento canónico | SHA-256 esperado | SHA-256 físico | Bytes | Resultado |
|---|---|---|---|---:|---|
| A | `docs/tasks/CORR-030-task-018-first-admin-intent-locator-delivery-navigation-decision.md` | `7a9bb2a4c17c2fcaee6d893fb539bb6211c50d0fd3f4123092e634666a9916fa` | `7a9bb2a4c17c2fcaee6d893fb539bb6211c50d0fd3f4123092e634666a9916fa` | 46758 | `PASS` |
| B | `docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md` | `6d70b742045537ff5accec07af50b1dbd316301ea1ddf8516c9e2fe040bacad6` | `6d70b742045537ff5accec07af50b1dbd316301ea1ddf8516c9e2fe040bacad6` | 101908 | `PASS` |
| C | `docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md` | `315bee1703965de755de43d887d093048edc4b20ec64655c112a628ba8fd1f2d` | `315bee1703965de755de43d887d093048edc4b20ec64655c112a628ba8fd1f2d` | 94650 | `PASS` |
| D | `docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md` | `30480be7c24a260fe4d6d8231cb83134133192e9b37f052310b9522196be1a5c` | `30480be7c24a260fe4d6d8231cb83134133192e9b37f052310b9522196be1a5c` | 74803 | `PASS` |
| E | `ADR-0019-verification-challenge-supabase-auth-session-boundary.md` | `41a2f5fcd57ca26fd52ca318fc2714c5188e9c03ab5f3d58ab55f92bd98b5e09` | `41a2f5fcd57ca26fd52ca318fc2714c5188e9c03ab5f3d58ab55f92bd98b5e09` | 83188 | `PASS` |
| F | `docs/tasks/CORR-029-task-018-post-auth-pending-profile-destination.md` | `f19e620f3ced35d3231cbcf3f14a6ac20d5c12931e08a9ccb4d6cb944fbf34db` | `f19e620f3ced35d3231cbcf3f14a6ac20d5c12931e08a9ccb4d6cb944fbf34db` | 40920 | `PASS` |

SOURCE E es además byte-identical al artefacto ADR-0019 físicamente disponible en el contexto actual, con el mismo SHA-256 indicado arriba.

Métricas de serialización observadas:

```text
A: LF=2131 / CRLF=0 / bare CR=0 / trailing-whitespace=0 / final newline=YES
B: LF=2911 / CRLF=0 / bare CR=0 / trailing-whitespace=0 / final newline=YES
C: LF=2451 / CRLF=0 / bare CR=0 / trailing-whitespace=0 / final newline=YES
D: LF=1768 / CRLF=0 / bare CR=0 / trailing-whitespace=0 / final newline=YES
E: LF=2482 / CRLF=0 / bare CR=0 / trailing-whitespace=142 / final newline=YES
F: LF=1850 / CRLF=0 / bare CR=0 / trailing-whitespace=0 / final newline=YES
```

El whitespace existente en SOURCE E no se normaliza ni constituye una modificación autorizada.

Resultado:

```text
CORR-031 REQUIRED CANONICAL SOURCE AVAILABILITY =
SATISFIED

CORR-031 SOURCE VERIFICATION =
PASS
```

---

## 4. Revisión de contradicciones

### 4.1 Resultado

```text
SOURCE CONTRADICTION = NO
NEW ADR REQUIRED = NO
```

No se detecta incompatibilidad material entre CORR-030, TASK-017, TASK-018, ADR-0020, ADR-0019 y CORR-029.

### 4.2 Drift documental real en TASK-017

TASK-017 todavía declara en §26.2 que el target first admin debe:

```text
receive/retain an opaque intent locator through the future approved delivery/navigation mechanism
```

Ese placeholder era correcto antes de CORR-030. CORR-030 posterior lo cierra mediante:

```text
provider-neutral verification email
+
/first-admin/verification/{intentId}
+
pathname segment
```

Por precedencia temporal no existe contradicción: existe un texto canónico anterior que ahora requiere sincronización mínima.

TASK-017 §29 ya separa authoritative issuance de external email delivery, mantiene provider-neutralidad y deja el provider concreto fuera de scope. CORR-030 sólo concreta el material provider-neutral como `code + verification link` y fija que resend conserva el mismo stable locator mientras produce un nuevo current challenge/code.

### 4.3 Drift documental real en TASK-018

TASK-018 §20.1 ya preserva:

```text
opaque locator
+
trusted server-side handoff from TASK-017
+
locator != authority
```

pero no fija todavía:

```text
FIRST_ADMIN_VERIFICATION_PATHNAME =
/first-admin/verification/{intentId}
```

ni declara en esa superficie que el locator llega por route/navigation como prop/estado técnico no editable y que el contrato visible permanece exactamente `email + code`.

Work Item D, su test plan y su DoD están centrados actualmente en `/pending-profile` y no contienen todavía el contrato completo de entrada pre-auth seleccionado por CORR-030.

Esto es underspecification/documentation drift, no contradicción.

### 4.4 ADR-0020

ADR-0020 preserva el intent estable, el binding autoritativo, `email = locator/proof target != authority`, el tenant derivado exclusivamente del intent, la separación proof/handoff y la invariancia `Auth/session != tenant authority`.

CORR-030 no altera ese trust model; selecciona una representación local de navegación compatible con él.

```text
ADR-0020 UPDATE REQUIRED = NO
```

### 4.5 ADR-0019

CORR-030 no modifica E2, `VerificationChallenge`, `SessionGrant`, technical-password bridge, Custom Access Token Hook, Auth Admin boundary ni secret handling.

```text
ADR-0019 UPDATE REQUIRED = NO
```

### 4.6 CORR-029

CORR-029 fija exclusivamente el destino post-auth:

```text
SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

sin locator ni authority material en la success URL.

CORR-030 permite el locator únicamente en la URL pre-auth de verificación y exige eliminarlo al navegar a `/pending-profile`.

Las decisiones son complementarias:

```text
pre-auth  = /first-admin/verification/{intentId}
post-auth = /pending-profile
```

```text
CORR-029 UPDATE REQUIRED = NO
```

---

## 5. Decisiones cerradas que CORR-031 sincroniza

Debe preservarse exactamente:

```text
FIRST_ADMIN_INTENT_LOCATOR_INITIAL_DELIVERY =
PROVIDER-NEUTRAL VERIFICATION EMAIL LINK

FIRST_ADMIN_VERIFICATION_PATHNAME =
/first-admin/verification/{intentId}

LOCATOR_TRANSPORT =
PATHNAME SEGMENT

LOCATOR_IN_PRE_AUTH_URL =
YES — PRE-AUTH ONLY

LOCATOR_BEARER_AUTHORITY =
NO

VISIBLE_USER_PROOF_INPUTS =
EMAIL + CODE

MANUAL_INTENT_ID_INPUT =
NO

TASK_017_TO_TASK_018_HANDOFF =
SAME TRUSTED SERVER ORCHESTRATION

POST_AUTH_SUCCESS_DESTINATION =
/pending-profile

CONCRETE EMAIL PROVIDER REQUIRED =
NO

RF-004 =
PARTIAL / NOT END-TO-END
```

Además:

```text
same intent locator across resend = YES
new current challenge/code on resend = YES
intentId = locator only
intentId alone != proof
intentId alone != handoff authority
intentId alone != tenant authority
UUID unpredictability != authorization control
```

---

## 6. Alcance y fuera de alcance de CORR-031

### 6.1 En alcance

Exclusivamente:

1. especificar el diff documental mínimo de TASK-017;
2. especificar el diff documental mínimo de TASK-018;
3. alinear UI/navigation, delivery material, tests y DoD con CORR-030;
4. preservar AC-018-084..090 sin renumeración ni cambio semántico;
5. conservar URL security, RLS y multitenancy sin ampliaciones.

### 6.2 Fuera de alcance

CORR-031 no autoriza ni ejecuta:

- código;
- SQL;
- schema;
- migration;
- RLS;
- Supabase mutation;
- Hosted Development;
- Work Item D correction;
- Work Item D staging;
- Work Item E;
- concrete email provider;
- provider credentials;
- production email templates;
- profile completion;
- `PlatformUser` creation;
- `CompanyMembership` creation;
- tenant authority;
- TASK-019;
- nueva arquitectura.

---

# 7. TASK-017 — sincronización documental mínima exacta

## 7.1 Documento target

Único documento TASK-017 que una futura ejecución de CORR-031 podrá modificar:

```text
docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md
```

Baseline física verificada:

```text
SHA-256 =
6d70b742045537ff5accec07af50b1dbd316301ea1ddf8516c9e2fe040bacad6
```

No se modifica implementación TASK-017.

## 7.2 PATCH T17-01 — §26.2 Target first-admin verification flow

Replace FROM `### 26.2 Target first-admin verification flow` inclusive, THROUGH the complete §26.2 body, ending immediately BEFORE `### 26.3 API/application contracts`, por el texto siguiente:

~~~markdown
### 26.2 Target first-admin verification flow

Minimum behavior:

1. receive the provider-neutral first-admin verification email containing the current verification code and a pre-auth verification link whose pathname is exactly `/first-admin/verification/{intentId}`;
2. obtain/retain `intentId` from that pathname as an opaque stable locator supplied by route/navigation; `intentId` is not bearer authority, proof, tenant authority or handoff authority;
3. show only the target email and verification code as editable proof inputs; no editable/manual `intentId`, UUID or `Referencia de acceso` field exists;
4. submit verification using the route-supplied `intentId`, target email, verification code and one logical verification operation identity;
5. the server-side verification boundary resolves the authoritative intent and its current challenge from PostgreSQL and applies the existing email/code/current-lifecycle checks;
6. receive only a bounded success/failure result;
7. on success, the same trusted server orchestration may continue from authoritative `handoffReady` into TASK-018; TASK-017 itself does not show profile completion or tenant administration.
~~~

Este patch cierra únicamente el placeholder `future approved delivery/navigation mechanism`.

No cambia lifecycle, attempts, challenge semantics, handoff semantics ni authorization.

## 7.3 PATCH T17-02 — §29.2 Provider-neutral application port

Conservar el nombre conceptual `FirstAdminVerificationCodeDelivery` si la futura implementación lo mantiene; CORR-031 no renombra APIs.

Reemplazar el párrafo que actualmente limita la responsabilidad a `receive transient delivery material after authoritative issuance` por:

~~~markdown
whose responsibility is only to receive provider-neutral transient delivery material after authoritative issuance:

```text
target email
+
transient verification code
+
stable intentId locator
+
verification pathname/URL using:
  trusted application origin
  +
  /first-admin/verification/{intentId}
```

The verification link does not replace the code, is not a second proof and is not authority. The absolute URL may be generated server-side from trusted application origin configuration plus the stable locator; no persisted verification URL is required.
~~~

Mantener íntegra la lista existente de prohibiciones del port y añadir al final de esa lista:

~~~markdown
- treat the verification link or `intentId` as proof, bearer, tenant authority or handoff authority;
- construct the absolute verification URL from an arbitrary origin supplied by the target browser;
- add email, code, tenant/company ID, role, challenge ID, grant ID, Auth user ID, access/refresh tokens or technical password to the verification URL.
~~~

## 7.4 PATCH T17-03 — §29.6 Code unavailable after failure/timeout

Después del bloque existente:

```text
authorized resend
→ new challenge
→ predecessor invalidated as applicable
```

insertar exactamente esta aclaración:

~~~markdown
The resend keeps the same stable `FirstAdminOnboardingIntent.id` locator and produces the new current challenge/code according to the already-approved lifecycle. The provider-neutral delivery material is regenerated as the same verification link pathname `/first-admin/verification/{intentId}` for that stable locator plus the new current verification code. The code is never encoded in the verification URL. Resend does not create a new onboarding-intent locator.
~~~

## 7.5 PATCH T17-04 — §29.7 RF-004 status

Sustituir el bloque actual:

```text
RF-004 end-to-end =
NOT COMPLETE
```

por:

```text
RF-004 =
PARTIAL / NOT END-TO-END
```

Conservar la explicación de que no existe todavía concrete external delivery adapter aprobado/implementado.

Añadir inmediatamente después:

~~~markdown
The provider-neutral content/navigation contract is nevertheless closed for TASK-017: every usable first-admin code delivery carries the current verification code plus the verification link for the same stable intent locator. Concrete provider selection remains out of scope.
~~~

## 7.6 PATCH T17-05 — Acceptance Criteria de delivery sin crear rango nuevo

No crear nuevos IDs ni renumerar `AC-017-*`.

Modificar únicamente:

~~~markdown
**AC-017-126.** Cuando code material ya no está disponible, una nueva entrega futura requiere authorized resend/new emission; el resend conserva el mismo stable intent locator y produce el nuevo current challenge/code conforme al lifecycle aprobado.

**AC-017-127.** No se selecciona production email provider; el provider-neutral delivery material incluye verification code + verification link con pathname exacto `/first-admin/verification/{intentId}` construido server-side desde trusted application origin y el stable intent locator.
~~~

Todos los restantes `AC-017-*` permanecen con su numeración y semántica existentes.

## 7.7 PATCH T17-06 — §32.H Server integration tests

Conservar los once tests actuales y añadir al final de `### H. Server integration tests`:

~~~markdown
12. provider-neutral delivery material contains the current verification code plus a verification link whose pathname is exactly `/first-admin/verification/{intentId}`;
13. the verification link uses the same stable intent locator across resend while the current challenge/code changes according to the existing lifecycle;
14. the verification URL contains no email, code, tenant/company ID, role, challenge ID, grant ID, Auth user ID, access/refresh tokens or technical password;
15. the delivery/link contract does not require a concrete production email provider and does not persist plaintext code or the full verification URL.
~~~

No eliminar ni debilitar los tests actuales de commit ordering, delivery failure, intent/current-challenge resolution, handoff o bounded outcomes.

## 7.8 PATCH T17-07 — §33 Definition of Done

Reemplazar únicamente `DoD-017-020` y `DoD-017-021` por:

~~~markdown
**DoD-017-020.** Provider-neutral email delivery boundary incluye el current verification code + verification link `/first-admin/verification/{intentId}` para el mismo stable intent locator, sin seleccionar concrete production provider y sin presentarse como delivery end-to-end.

**DoD-017-021.** RF-004 permanece reportado exactamente `PARTIAL / NOT END-TO-END` salvo que un Gate posterior apruebe e implemente un adapter externo.
~~~

No renumerar DoD.

## 7.9 PATCH T17-08 — §34 Work item D — Provider-neutral delivery orchestration

Conservar heading, objetivo general, fuera de alcance y frontera provider-neutral, pero sustituir el bloque `**Scope:**` por:

~~~markdown
**Scope:**

- typed server-only delivery port;
- transient current verification code passed only after DB commit;
- stable `intentId` locator belonging to the same onboarding intent;
- provider-neutral verification link material whose pathname is exactly `/first-admin/verification/{intentId}`;
- absolute-link composition from trusted application origin configuration plus the stable locator, without trusting target-browser origin;
- same stable locator across resend while the new current challenge/code follows the already-approved lifecycle;
- fake/in-memory test adapter;
- delivery outcome mapping;
- no plaintext-code persistence;
- no persisted full verification URL requirement.
~~~

Sustituir `**Security/RLS:**` por:

~~~markdown
**Security/RLS:** no code/secret logs; no client secret exposure; `intentId` and verification link are locator/navigation only and never proof, bearer, handoff authority or tenant authority; verification URL contains no email/code/tenant/role/challenge/grant/Auth-user/token/technical-password material; no RLS/schema change.
~~~

Sustituir `**Tests:**` por:

~~~markdown
**Tests:** delivery only after commit; failure leaves issuance intact; same-execution retry semantics; no plaintext persistence; exact verification pathname; code + link material; same locator across resend with new code; URL minimization; no concrete provider dependency.
~~~

## 7.10 TASK-017 surfaces que permanecen sin cambio

No modificar por CORR-031:

- intent lifecycle;
- challenge lifecycle;
- 8h expiry;
- three-attempt semantics;
- predecessor/successor invalidation;
- verify/consume atomicity;
- handoff persistence;
- `SessionGrant` semantics;
- RLS/privileges;
- purpose-specific security boundaries;
- provider selection;
- provider retry/backoff policy;
- durable delivery queue/outbox decision;
- profile/member/tenant-authority boundaries;
- TASK-017 implementation authorization state.

---

# 8. TASK-018 — sincronización documental mínima exacta

## 8.1 Documento target

Único documento TASK-018 que una futura ejecución de CORR-031 podrá modificar:

```text
docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md
```

Baseline física verificada:

```text
SHA-256 =
315bee1703965de755de43d887d093048edc4b20ec64655c112a628ba8fd1f2d
```

CORR-031 no corrige Work Item D en código.

## 8.2 PATCH T18-01 — §20.1 Entry

Replace FROM `### 20.1 Entry` inclusive, THROUGH the complete §20.1 body, ending immediately BEFORE `### 20.2 Pending`, por:

~~~markdown
### 20.1 Entry

The pre-auth first-admin verification entry pathname is exactly:

```text
FIRST_ADMIN_VERIFICATION_PATHNAME =
/first-admin/verification/{intentId}
```

`{intentId}` is the opaque `FirstAdminOnboardingIntent.id` locator supplied by route/navigation. It is pre-auth navigation state only: it is not proof, bearer authority, tenant authority, handoff authority or session authority.

The route composes the first-admin verification form with `intentId` as readonly technical state/prop. The visible editable proof contract remains exactly:

```text
email
+
verification code
```

No manual/editable `intentId`, UUID or `Referencia de acceso` input is part of the user-visible form.

The form may submit the route-supplied `intentId` in the POST body as a lookup locator together with the user-entered email/code and the existing verification-operation correlation. The server must re-resolve authoritative intent/current-challenge/handoff state from PostgreSQL; browser state never becomes authority.

The trusted continuation remains one server orchestration:

```text
TASK-017 verify
→ authoritative handoffReady
→ TASK-018 establish(intentId)
```

TASK-018 must not reconstruct handoff authority from browser inputs and must not introduce a second browser-side bearer transition between TASK-017 verification and TASK-018 establishment.
~~~

## 8.3 PATCH T18-02 — §22.2 Correlation identifiers permitidos

Conservar `intent ID` como correlation identifier permitido.

Después de la regla actual de minimización del target email, añadir:

~~~markdown
Do not deliberately log or duplicate the full pre-auth verification URL when the separated `intent ID` is sufficient for server-side correlation. Automatic infrastructure access logging of a pathname does not make the locator a secret or authority, but it does not authorize copying the full verification URL into additional application telemetry or third-party analytics.
~~~

No añadir el URL a la secret deny-list: el locator no es secret. El control es de minimización y no duplicación deliberada.

## 8.4 PATCH T18-03 — Work item D — Minimal UI integration

Replace FROM `### Work item D — Minimal UI integration` inclusive, THROUGH the complete Work Item D body, ending immediately BEFORE `### Work item E — Regression + Hosted Development evidence`, por:

~~~markdown
### Work item D — Minimal UI integration

**Objetivo:** conectar el dedicated pre-auth first-admin verification route con el verification form y con la misma trusted post-verification server orchestration, preservando pending/success/failure UI y sin exponer provider state ni autoridad.

**Contexto:** el locator llega exclusivamente por route/navigation mediante el pathname aprobado `/first-admin/verification/{intentId}`. `intentId` es locator técnico, no proof ni bearer. TASK-017 produce/reconcilia `handoffReady` y la misma server orchestration continúa a TASK-018.

**Alcance:**

- dedicated route entrypoint `app/first-admin/verification/[intentId]/page.tsx`;
- el route entrypoint recibe el dynamic segment y lo trata exclusivamente como opaque locator;
- `FirstAdminVerificationForm` recibe `intentId` como readonly prop/estado técnico;
- los únicos proof inputs editables visibles son email + verification code;
- no existe input manual/editable `intentId`, UUID o `Referencia de acceso`;
- el submit puede transportar `intentId` en el POST body como lookup locator, junto con email, code y la correlation identity existente;
- el server re-resuelve authoritative intent/current challenge/handoff state y no confía en el locator como authority;
- `app/page.tsx` deja de ser una first-admin verification surface que renderiza el form sin locator; puede conservar únicamente una shell neutral si el repositorio la necesita;
- loading/pending, bounded retry y terminal error permanecen;
- success conserva exactamente:

```text
POST_AUTH_SUCCESS_DESTINATION =
/pending-profile

SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

- ambos success outcomes producen el mismo pathname y la misma shell visible, sin metadata diferenciadora;
- success utiliza exactamente replacement navigation mediante `router.replace("/pending-profile")`; `/pending-profile` no transporta locator, y la URL visible post-auth resultante contiene exactamente `/pending-profile`, sin locator, query ni fragment.

**Fuera de alcance:** profile form, profile persistence, tenant admin UI, tenant authority, dashboard, route authorization framework, full onboarding, concrete email provider, provider credentials, Work Item E y Hosted Development.

**Cambios esperados:** corrección mínima de la surface UI/handler conforme al repositorio real; dedicated verification route; form con readonly route-supplied locator; eliminación del manual locator field; root page sin first-admin form sin locator; API Route sin semantic trust change; same trusted post-verification service orchestration; minimal pending-profile shell only en `/pending-profile` sin cambios funcionales a CORR-029.

**Seguridad/RLS:**

- verification URL contiene únicamente el locator técnico necesario;
- no URL email/code/tenant/company/role/challenge/grant/Auth-user/access-token/refresh-token/technical-password;
- verification page private/no-store;
- `Referrer-Policy: no-referrer` o equivalente demostrable;
- no duplicar deliberadamente full verification URL en application telemetry/logging;
- no authority from browser email/tenant/role;
- `intentId` not bearer and UUID unpredictability is not an authorization control;
- trusted post-verification handoff remains server-internal;
- no second browser bearer request between verify and establish;
- no localStorage/sessionStorage/IndexedDB/Dexie authority or locator persistence introduced;
- no new schema/RLS/privileged capability;
- no secrets, tokens, technical password or authority identifiers transported to `/pending-profile`.

**Criterios:** `AC-018-084..090` permanecen `UNCHANGED`. Los requisitos adicionales de route/navigation/security quedan exigidos por §20.1, este Work Item D, §22.2, §24 y §28.5 sin crear ni renumerar acceptance criteria.

**Pruebas:** dedicated route; visible email+code only; absence of manual `intentId`/`Referencia de acceso`; request locator comes from route; invalid/cross-intent locator grants no authority/session; correct locator + wrong proof still fails through TASK-017 attempt semantics; correct proof continues in the same trusted server orchestration; success uses replacement navigation through `router.replace("/pending-profile")`; post-auth visible URL contains no locator, query or fragment; exact `/pending-profile` success destination; pre-auth URL hygiene; private/no-store; no-referrer; root page does not render a first-admin form requiring manual locator; verify occurs before establish and establish only after authoritative `handoffReady`; no account enumeration; online-only; no browser secrets or authority transport.

**Gate:** this documentation contract does not authorize Work Item D correction, implementation, staging, Hosted Development or Work Item E. Each remains subject to its separate human Gate.
~~~

## 8.5 PATCH T18-04 — §24.1 Unit / application integration

Conservar los tests `1..25` actuales.

Añadir al final:

~~~markdown
26. `/first-admin/verification/{intentId}` renders the first-admin verification form with the route-supplied opaque locator;
27. the visible editable proof fields are exactly email + code and there is no editable/manual `intentId`, UUID or `Referencia de acceso` field;
28. submit uses the locator supplied by the route for `body.intentId`, while email/code remain user inputs and `verificationOperationId` keeps its existing correlation contract;
29. invalid or cross-intent locator does not grant handoff, session or tenant authority and yields a bounded non-enumerating outcome;
30. correct locator + wrong proof does not bypass TASK-017 code/current-challenge verification;
31. correct locator + matching email + valid current code can continue only through authoritative `handoffReady` in the same trusted server orchestration;
32. pre-auth verification URL contains only the technical locator and excludes email, code, tenant/company ID, role, challenge ID, grant ID, Auth user ID, access/refresh tokens and technical password;
33. verification page demonstrates private/no-store plus `no-referrer` or equivalent, the root page does not render a first-admin verification form that requires manual locator entry, success uses replacement navigation through `router.replace("/pending-profile")`, and the resulting post-auth visible URL contains no locator, query or fragment;
34. presented email alone cannot resolve or select a first-admin intent; removing/bypassing the route-supplied `intentId` locator or attempting email-only intent lookup must fail and cannot produce handoff, session or tenant authority.
~~~

## 8.6 PATCH T18-05 — §24.5 Negative security tests

Conservar todas las pruebas actuales y añadir:

~~~markdown
- direct knowledge of a valid-format or real `intentId` alone cannot establish handoff/session or tenant authority;
- the verification form cannot substitute a manually edited technical locator because no editable/manual locator field exists;
- no email/code/tenant/role/challenge/grant/token/technical-password material appears in the pre-auth verification URL;
- application telemetry does not deliberately duplicate the full verification URL when `intentId` correlation is sufficient;
- presented email alone cannot resolve or select a first-admin intent; removing/bypassing the route-supplied `intentId` locator or attempting email-only intent lookup must fail and cannot produce handoff, session or tenant authority.
~~~

## 8.7 AC-018-084..090 — evaluación individual

CORR-031 inspeccionó físicamente el rango completo.

No existe ambigüedad material que requiera cambiar su semántica una vez sincronizadas §20.1, Work Item D, §24 y §28.5.

Resultado obligatorio:

| Acceptance Criterion | CORR-031 action |
|---|---|
| `AC-018-084` | `UNCHANGED` |
| `AC-018-085` | `UNCHANGED` |
| `AC-018-086` | `UNCHANGED` |
| `AC-018-087` | `UNCHANGED` |
| `AC-018-088` | `UNCHANGED` |
| `AC-018-089` | `UNCHANGED` |
| `AC-018-090` | `UNCHANGED` |

Razón:

- `AC-018-084` continúa gobernando pending/loading y double-submit UX;
- `AC-018-085` ya fija correctamente la convergencia visible a `/pending-profile`;
- `AC-018-086` ya preserva no-enumeration;
- `AC-018-087..090` ya preservan online-only y ausencia de optimistic/offline Auth provisioning.

No renumerar.

No crear un nuevo rango.

No remapear los requisitos de locator/navigation hacia esos AC.

## 8.8 PATCH T18-06 — §28.5 Local verification / Work Item D DoD

Conservar `DoD-018-033` y `DoD-018-036` sin renumeración.

Reemplazar únicamente el bloque explicativo que comienza con:

```text
Para Work Item D, DoD-018-033 y DoD-018-036 exigen conjuntamente que:
```

por:

~~~markdown
Para Work Item D, `DoD-018-033` y `DoD-018-036` exigen conjuntamente que:

- exista el dedicated pre-auth route `/first-admin/verification/{intentId}`;
- el route suministre `intentId` como opaque readonly locator al verification form;
- los únicos proof inputs editables visibles sean email + code;
- no exista input editable/manual `intentId`, UUID o `Referencia de acceso`;
- el POST utilice el locator suministrado por route/navigation y no uno introducido manualmente;
- la server boundary re-resuelva authoritative intent/current challenge/handoff state y no use UUID validity/entropy como authorization control;
- la verification URL contenga únicamente el locator técnico necesario y excluya email/code/tenant/role/challenge/grant/Auth-user/tokens/technical-password;
- la verification page cumpla private/no-store y `no-referrer` o equivalente demostrable;
- application logging/telemetry no duplique deliberadamente el full verification URL cuando el `intentId` separado sea suficiente;
- `app/page.tsx` no renderice una first-admin verification surface sin locator aprobado;
- TASK-017 verify ocurra antes de TASK-018 establish y establish sólo ocurra después de authoritative `handoffReady` dentro de la misma trusted server orchestration;
- exista `/pending-profile`;
- `SESSION_ESTABLISHED` y `SESSION_ALREADY_ESTABLISHED` converjan al mismo destino y a la misma shell visible;
- la route `/pending-profile` sea únicamente una shell mínima de sesión establecida + configuración de perfil pendiente;
- `/pending-profile` no transporte el locator y no implemente profile form, persistencia, tenant authority, dashboard ni capacidades posteriores;
- pasen las pruebas de pathname exacto, visible-field contract, request locator provenance, URL hygiene, cache/referrer, no-account-enumeration, uniformidad visible, ausencia de metadata diferenciadora y ausencia de secrets/tokens/browser authority transport.
~~~

## 8.9 TASK-018 surfaces que permanecen sin cambio

No modificar por CORR-031:

- Auth identity creation/reconciliation semantics;
- E2 session mechanism;
- SessionGrant validation/consume;
- technical-password bridge;
- Custom Access Token Hook boundary;
- Auth Admin privilege boundary;
- `PlatformUser`/`CompanyMembership` prohibitions;
- audit semantics;
- idempotency/external atomicity;
- `/pending-profile` pathname and semantics;
- online-only semantics;
- Hosted requirements;
- AC-018-084..090;
- TASK-018 implementation authorization state;
- TASK-019 state.

---

# 9. URL security contract preservado

La futura ejecución documental de CORR-031 debe dejar inequívoco en TASK-017/TASK-018:

```text
pre-auth verification URL =
/first-admin/verification/{intentId}
```

El URL contiene únicamente el locator técnico necesario.

No incluir en URL:

- email;
- verification code;
- tenant/company ID;
- role;
- challenge ID;
- grant ID;
- Auth user ID;
- access token;
- refresh token;
- technical password.

La verification page debe cumplir:

```text
private / no-store
```

Referrer:

```text
no-referrer
```

u otro mecanismo demostrablemente equivalente.

Logging/telemetry:

- `intentId` separado puede continuar como correlation identifier server-side;
- no duplicar deliberadamente el full verification URL cuando no sea necesario;
- no introducir third-party analytics/telemetry que reciba ese URL por CORR-031;
- el locator no se clasifica como secret ni authority.

Regla de seguridad:

```text
UUID unpredictability != authorization control
```

La security boundary continúa dependiendo de authoritative PostgreSQL state + matching intent/current challenge + presented email correlation + valid current code + lifecycle checks.

---

# 10. Seguridad / RLS / multitenancy preservados

CORR-031 no modifica y la futura sincronización debe preservar:

```text
authenticated != authorized
Auth identity != tenant authority
Auth session != tenant authority
intentId = locator only
browser state != authoritative state
MaintenanceCompany = tenant
current PostgreSQL state > browser state
RLS = primary tenant-data boundary
technical password = server-only
SessionGrant = non-bearer / single-use
SUPER_ADMIN global != ordinary tenant actor
```

Además:

```text
new schema = NO
new migration = NO
new RLS = NO
RLS weakening = NO
new tenant authority = NO
PlatformUser creation = NO
CompanyMembership creation = NO
profile completion = NO
new privileged capability = NO
generic service-role request client = NO
```

El pathname no determina tenant.

El server deriva `MaintenanceCompany` exclusivamente desde el authoritative `FirstAdminOnboardingIntent`.

---

# 11. Documentos explícitamente sin modificación

La inspección física no reveló contradicción material que obligue a ampliar el target documental.

Resultado:

```text
00-master-product-brief.md =
NO UPDATE

01-product-definition.md =
NO UPDATE

02-domain-model.md =
NO UPDATE

03-permissions-rls-strategy.md =
NO UPDATE

ADR-0019 =
NO UPDATE

ADR-0020 =
NO UPDATE

CORR-029 =
NO UPDATE

architecture decision registry =
NO UPDATE

NEW ADR =
NO
```

CORR-031 no autoriza modificar ningún documento de esa lista.

---

# 12. Únicos documentos canónicos que una ejecución posterior podrá modificar

Exactamente:

```text
docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md

docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md
```

No se autoriza un tercer target.

La futura ejecución deberá comenzar desde los SHA-256 verificados por esta specification o detenerse ante drift material y volver al Revisor Central.

---

# 13. Semántica mecánica de la futura sincronización

La futura ejecución documental de CORR-031 debe:

1. repetir preflight Git fresco;
2. verificar que ambos targets son exactamente los canónicos autorizados;
3. verificar que sus contenidos baseline todavía contienen los fragmentos esperados por T17-01..08 y T18-01..06;
4. aplicar únicamente esos patches;
5. no hacer reformatting general;
6. no normalizar whitespace no relacionado;
7. no reordenar secciones no afectadas;
8. no renumerar AC/DoD salvo lo expresamente autorizado — y CORR-031 no autoriza ninguna renumeración;
9. no modificar source docs A/D/E/F;
10. producir diff que pueda mapearse uno a uno a esta specification;
11. detenerse con `SOURCE CONTRADICTION` o `BLOCKER` si el baseline material ya no coincide y la corrección no puede aplicarse de forma inequívoca;
12. no usar la ejecución documental como autorización de Work Item D.

---

# 14. Acceptance Criteria de CORR-031

**AC-031-001.** Se reanuda el Gate existente desde source verification y no se crea una nueva determinación.

**AC-031-002.** El package físico contiene las seis fuentes A..F requeridas.

**AC-031-003.** SOURCE A coincide exactamente con SHA-256 `7a9bb2a4c17c2fcaee6d893fb539bb6211c50d0fd3f4123092e634666a9916fa`.

**AC-031-004.** SOURCE B coincide exactamente con SHA-256 `6d70b742045537ff5accec07af50b1dbd316301ea1ddf8516c9e2fe040bacad6`.

**AC-031-005.** SOURCE C coincide exactamente con SHA-256 `315bee1703965de755de43d887d093048edc4b20ec64655c112a628ba8fd1f2d`.

**AC-031-006.** SOURCE D coincide exactamente con SHA-256 `30480be7c24a260fe4d6d8231cb83134133192e9b37f052310b9522196be1a5c`.

**AC-031-007.** SOURCE E está físicamente disponible y fue consumida sin inferencia.

**AC-031-008.** SOURCE F coincide exactamente con SHA-256 `f19e620f3ced35d3231cbcf3f14a6ac20d5c12931e08a9ccb4d6cb944fbf34db`.

**AC-031-009.** `SOURCE CONTRADICTION = NO`.

**AC-031-010.** `NEW ADR REQUIRED = NO`.

**AC-031-011.** Se preserva `FIRST_ADMIN_INTENT_LOCATOR_INITIAL_DELIVERY = PROVIDER-NEUTRAL VERIFICATION EMAIL LINK`.

**AC-031-012.** Se preserva `FIRST_ADMIN_VERIFICATION_PATHNAME = /first-admin/verification/{intentId}`.

**AC-031-013.** Se preserva `LOCATOR_TRANSPORT = PATHNAME SEGMENT`.

**AC-031-014.** Se preserva `LOCATOR_IN_PRE_AUTH_URL = YES — PRE-AUTH ONLY`.

**AC-031-015.** Se preserva `LOCATOR_BEARER_AUTHORITY = NO`.

**AC-031-016.** Se preserva `VISIBLE_USER_PROOF_INPUTS = EMAIL + CODE`.

**AC-031-017.** Se preserva `MANUAL_INTENT_ID_INPUT = NO`.

**AC-031-018.** Se preserva TASK-017 → TASK-018 dentro de la misma trusted server orchestration.

**AC-031-019.** Se preserva `/pending-profile` como único success destination post-auth y sin locator.

**AC-031-020.** Concrete email provider permanece fuera de scope.

**AC-031-021.** `RF-004 = PARTIAL / NOT END-TO-END`.

**AC-031-022.** TASK-017 §26.2 deja de describir el delivery/navigation mechanism como futuro o abierto.

**AC-031-023.** TASK-017 §29 define provider-neutral delivery material como code + verification link para el mismo stable locator.

**AC-031-024.** TASK-017 resend conserva el mismo stable intent locator y produce el nuevo current challenge/code.

**AC-031-025.** TASK-017 no selecciona provider, retry/backoff ni durable queue.

**AC-031-026.** TASK-017 testing cubre exact pathname, same locator across resend y URL minimization.

**AC-031-027.** TASK-017 DoD mantiene provider-neutralidad y RF-004 partial.

**AC-031-028.** TASK-017 Work Item D permanece provider-neutral y no introduce UI route implementation propia de TASK-018.

**AC-031-029.** TASK-018 §20.1 fija el exact pre-auth pathname y route-supplied readonly locator.

**AC-031-030.** TASK-018 visible form contract contiene únicamente email + code como proof inputs editables.

**AC-031-031.** TASK-018 elimina conceptualmente manual `intentId`/UUID/`Referencia de acceso` input.

**AC-031-032.** TASK-018 permite `intentId` en POST únicamente como lookup locator y no como proof/authority.

**AC-031-033.** TASK-018 Work Item D incluye dedicated route, readonly locator prop y root page sin manual-locator verification surface.

**AC-031-034.** TASK-018 Work Item D preserva API Route semantic trust y same trusted post-verification orchestration.

**AC-031-035.** TASK-018 tests cubren invalid/cross locator, wrong proof, correct proof y no email-only lookup authority.

**AC-031-036.** TASK-018 tests cubren pre-auth URL hygiene, no-store/private y no-referrer/equivalent.

**AC-031-037.** TASK-018 logging contract evita duplicación deliberada del full verification URL.

**AC-031-038.** `AC-018-084 = UNCHANGED`.

**AC-031-039.** `AC-018-085 = UNCHANGED`.

**AC-031-040.** `AC-018-086 = UNCHANGED`.

**AC-031-041.** `AC-018-087 = UNCHANGED`.

**AC-031-042.** `AC-018-088 = UNCHANGED`.

**AC-031-043.** `AC-018-089 = UNCHANGED`.

**AC-031-044.** `AC-018-090 = UNCHANGED`.

**AC-031-045.** AC-018 range no se renumera ni se amplía por CORR-031.

**AC-031-046.** TASK-018 DoD Work Item D exige dedicated route, visible field contract, URL hygiene, cache/referrer, same orchestration y `/pending-profile` sin locator.

**AC-031-047.** URL pre-auth no contiene email, code, tenant/company ID, role, challenge ID, grant ID, Auth user ID, access/refresh tokens ni technical password.

**AC-031-048.** `UUID unpredictability != authorization control` permanece explícito.

**AC-031-049.** No se crea schema, migration, RLS ni tenant authority.

**AC-031-050.** No se crea `PlatformUser`, `CompanyMembership` ni profile completion.

**AC-031-051.** `00-master-product-brief.md = NO UPDATE`.

**AC-031-052.** `01-product-definition.md = NO UPDATE`.

**AC-031-053.** `02-domain-model.md = NO UPDATE`.

**AC-031-054.** `03-permissions-rls-strategy.md = NO UPDATE`.

**AC-031-055.** `ADR-0019 = NO UPDATE`.

**AC-031-056.** `ADR-0020 = NO UPDATE`.

**AC-031-057.** `CORR-029 = NO UPDATE`.

**AC-031-058.** `architecture decision registry = NO UPDATE`.

**AC-031-059.** Los únicos futuros targets documentales son TASK-017 y TASK-018 canónicos.

**AC-031-060.** CORR-031 no modifica el repositorio, no usa Codex y no modifica Supabase.

**AC-031-061.** TASK-018 Work Item D correction permanece `NOT AUTHORIZED`.

**AC-031-062.** TASK-018 Work Item D staging permanece `NOT AUTHORIZED`.

**AC-031-063.** WORK ITEM E permanece `NOT AUTHORIZED`.

**AC-031-064.** Hosted Development permanece `NOT AUTHORIZED`.

**AC-031-065.** TASK-019 permanece `NOT DETERMINED / NOT AUTHORIZED`.

**AC range:** `AC-031-001..AC-031-065`

**AC count:** `65`

---

# 15. Definition of Done de CORR-031 specification

**DoD-031-001.** El Gate previo fue reanudado desde source verification sin nueva determinación.

**DoD-031-002.** Las seis fuentes obligatorias están físicamente disponibles.

**DoD-031-003.** Los SHA fijados para A/B/C/D/F coinciden exactamente.

**DoD-031-004.** ADR-0019 fue consumida físicamente.

**DoD-031-005.** La revisión de contradicciones concluye `SOURCE CONTRADICTION = NO`.

**DoD-031-006.** La revisión arquitectónica concluye `NEW ADR REQUIRED = NO`.

**DoD-031-007.** Se identificó exactamente el drift de TASK-017 y no se reabrió su lifecycle.

**DoD-031-008.** Se definieron patches mecánicamente precisos para TASK-017 §26.2, §29, AC delivery, tests, DoD y Work Item D.

**DoD-031-009.** Se identificó exactamente el drift de TASK-018 y no se reabrió E2 ni CORR-029.

**DoD-031-010.** Se definieron patches mecánicamente precisos para TASK-018 §20.1, §22.2, Work Item D, tests y §28.5 DoD.

**DoD-031-011.** `AC-018-084..090` fueron revisados individualmente y todos quedan `UNCHANGED`.

**DoD-031-012.** Se preservó el URL security contract completo de CORR-030.

**DoD-031-013.** Se preservaron RLS, multitenancy, privilege y Auth/session boundaries.

**DoD-031-014.** Se determinó explícitamente que product docs, ADR-0019, ADR-0020, CORR-029 y architecture registry no cambian.

**DoD-031-015.** Se fijaron exactamente dos futuros documentos target.

**DoD-031-016.** Se definieron criterios de aceptación objetivos para la futura sincronización documental.

**DoD-031-017.** Se definió que la futura ejecución no puede reparar silenciosamente drift material.

**DoD-031-018.** No se produjo código, SQL, migration ni RLS.

**DoD-031-019.** No se modificó repositorio, Supabase, Hosted, Staging ni Production.

**DoD-031-020.** No se autorizó Codex.

**DoD-031-021.** Work Item D correction/implementation/staging permanecen bajo Gate separado.

**DoD-031-022.** Work Item E y Hosted Development permanecen no autorizados.

**DoD-031-023.** TASK-019 permanece no determinada/no autorizada.

**DoD-031-024.** El resultado final de esta specification es `READY FOR REVIEW`.

**DoD range:** `DoD-031-001..DoD-031-024`

**DoD count:** `24`

---

# 16. Gate posterior

Al terminar esta specification:

```text
CORR-031 SPECIFICATION =
READY FOR REVIEW

CORR-031 SOURCE VERIFICATION =
PASS

SOURCE CONTRADICTION =
NO

NEW ADR REQUIRED =
NO

TASK-018 WORK ITEM D =
REMAINS BLOCKED

TASK-018 WORK ITEM D correction =
NOT AUTHORIZED

TASK-018 WORK ITEM D staging =
NOT AUTHORIZED

WORK ITEM E =
NOT AUTHORIZED

Hosted Development =
NOT AUTHORIZED

TASK-019 =
NOT DETERMINED / NOT AUTHORIZED

repository mutation =
NO

Supabase mutation =
NO

git add / commit / push =
NO / NO / NO
```

El siguiente acto permitido es exclusivamente:

```text
CORR-031 SPEC REVIEW
```

La futura sincronización física de TASK-017/TASK-018 sólo podrá ejecutarse después de revisión/aprobación y de los Gates documentales aplicables.

La aprobación de CORR-031 no equivale a autorización de Work Item D.

---

# 17. Resultado final

```text
CORR-031 REQUIRED CANONICAL SOURCE AVAILABILITY =
SATISFIED

CORR-031 SOURCE VERIFICATION =
PASS

CORR-031 CONTRADICTION REVIEW =
PASS — NO MATERIAL SOURCE CONTRADICTION

SOURCE CONTRADICTION =
NO

NEW ADR REQUIRED =
NO

CORR-031 TASK-017 MINIMAL SYNC =
SPECIFIED

CORR-031 TASK-018 MINIMAL SYNC =
SPECIFIED

AC-018-084..090 =
UNCHANGED

DOCUMENT TARGETS =
TASK-017 + TASK-018 ONLY

CORR-031 SPECIFICATION =
APPROVED

CORR-031 SPEC REVIEW =
APPROVED

CORR-031 HUMAN SPEC APPROVAL =
APPROVED

TASK-018 WORK ITEM D =
REMAINS BLOCKED

TASK-018 WORK ITEM D correction =
NOT AUTHORIZED

TASK-018 WORK ITEM D staging =
NOT AUTHORIZED

WORK ITEM E =
NOT AUTHORIZED

Hosted Development =
NOT AUTHORIZED

TASK-019 =
NOT DETERMINED / NOT AUTHORIZED

repository mutation =
NO

Supabase mutation =
NO

git add / commit / push =
NO / NO / NO
```

STOP.

RETURN TO REVISOR CENTRAL.
