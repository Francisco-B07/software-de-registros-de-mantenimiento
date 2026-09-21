# CORR-030 — TASK-018 FIRST-ADMIN INTENT LOCATOR DELIVERY / NAVIGATION DECISION

## 1. Identificación

**ID:** `CORR-030`

**Título:** `CORR-030 — TASK-018 First-Admin Intent Locator Delivery / Navigation Decision`

**Tipo:** `PRODUCT / TECHNICAL DECISION CORRECTION`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context principal:** `Identity & Authorization`

**Resultado de esta especificación:**

```text
CORR-030 SPECIFICATION =
APPROVED
```

**Estado documental de aprobación de esta Gate:**

```text
CORR-030 SPEC REVIEW =
APPROVED

CORR-030 HUMAN SPEC APPROVAL =
APPROVED

CORR-030 APPROVED ARTIFACT GENERATION =
PASS

CORR-030 APPROVED ARTIFACT =
GENERATED — PENDING CENTRAL REVIEW

CORR-030 canonicalized =
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
```

Debe permanecer:

```text
TASK-018 WORK ITEM D =
REMAINS BLOCKED

TASK-018 WORK ITEM D staging =
NOT AUTHORIZED

WORK ITEM E =
NOT AUTHORIZED

Hosted Development =
NOT AUTHORIZED

TASK-019 =
NOT DETERMINED / NOT AUTHORIZED
```

Esta especificación:

- NO implementa;
- NO autoriza Codex;
- NO modifica el repositorio;
- NO modifica Supabase Cloud;
- NO autoriza staging, commit ni push;
- NO implementa profile completion;
- NO crea `PlatformUser`;
- NO crea `CompanyMembership`;
- NO habilita tenant authority;
- NO determina TASK-019.

---

## 2. Reanudación del blocker previo

La generación anterior de CORR-030 terminó correctamente como:

```text
CORR-030 SPECIFICATION =
BLOCKER — REQUIRED CANONICAL AND CURRENT IMPLEMENTATION SOURCES UNAVAILABLE
```

La causa del blocker era exclusivamente la ausencia física de:

```text
docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md

docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md

docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md

docs/tasks/CORR-029-task-018-post-auth-pending-profile-destination.md

app/page.tsx

app/first-admin-verification-form.tsx

app/api/first-admin/verification/route.ts

src/modules/identity-authorization/application/first-admin-post-verification-service.ts

src/modules/identity-authorization/server.ts

tests/task-018-first-admin-ui-integration.test.ts
```

Las diez fuentes fueron recuperadas físicamente mediante:

```text
CORR-030-required-source-recovery.zip
```

No se requiere una nueva determinación de CORR-030.

El Gate previo se reanuda desde el mismo objetivo y preserva todo estado aprobado.

---

## 3. Verificación física de las fuentes recuperadas

SHA-256 observado sobre los bytes físicos recuperados:

| Source | Artefacto físico recuperado | SHA-256 |
|---|---|---|
| 01 | `ADR-0020-authoritative-first-admin-onboarding-intent-binding.md` | `30480be7c24a260fe4d6d8231cb83134133192e9b37f052310b9522196be1a5c` |
| 02 | `TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md` | `6d70b742045537ff5accec07af50b1dbd316301ea1ddf8516c9e2fe040bacad6` |
| 03 | `TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md` | `315bee1703965de755de43d887d093048edc4b20ec64655c112a628ba8fd1f2d` |
| 04 | `CORR-029-task-018-post-auth-pending-profile-destination.md` | `f19e620f3ced35d3231cbcf3f14a6ac20d5c12931e08a9ccb4d6cb944fbf34db` |
| 05 | `app/page.tsx` | `d153e19f2604868930ac0b0cdbb9d5e76ab39400056d9f116fabbfc186086bf9` |
| 06 | `app/first-admin-verification-form.tsx` | `5272dbecc42c9437f3565067f6332e6f345ed14ec7226b0db0ebd97158d4c274` |
| 07 | `app/api/first-admin/verification/route.ts` | `f383924f33e50171dc6da4863fef80f691ec4db7487e38344eb2c32508e0f141` |
| 08 | `src/modules/identity-authorization/application/first-admin-post-verification-service.ts` | `1ddaddea165a51c4b43d4e41811a1ff6d2cd9f241b0704421f684bd02af12970` |
| 09 | `src/modules/identity-authorization/server.ts` | `8c8ca7f2374b687896f0f9f6d28e1c53598d1ad3e00a44f6b67e664a9e71c604` |
| 10 | `tests/task-018-first-admin-ui-integration.test.ts` | `7e2c6def5d8c9ae051007b80f6ea2ec5b9d23769c0360eaad3366da2e559d7b9` |

La identidad física de SOURCE-03 coincide exactamente con el SHA-256 canónico proporcionado para TASK-018:

```text
315bee1703965de755de43d887d093048edc4b20ec64655c112a628ba8fd1f2d
```

La verificación anterior sólo identifica los bytes recuperados. No convierte por inferencia los SHA observados de las demás fuentes en hashes canónicos cuando no se proporcionó un hash canónico de referencia separado.

---

## 4. Objetivo único

Resolver exclusivamente cómo el opaque:

```text
FirstAdminOnboardingIntent.id
```

llega o permanece disponible en la UI de verificación del primer `COMPANY_ADMIN` sin:

- convertirlo en bearer;
- convertirlo en una tercera prueba de usuario;
- exigir que el usuario conozca o escriba un UUID técnico;
- cambiar RF-012;
- cambiar FL-01;
- ampliar Auth/session architecture;
- crear tenant authority;
- implementar profile completion;
- modificar `/pending-profile`.

La decisión debe permitir posteriormente una corrección mínima de TASK-018 Work Item D.

---

## 5. Estado de gobernanza consumido

Se consume como estado autoritativo:

```text
TASK-018 canonical =
docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md

TASK-018 canonical SHA-256 =
315bee1703965de755de43d887d093048edc4b20ec64655c112a628ba8fd1f2d

TASK-018 canonical commit =
e2b3829b22c06c65f01a5462680adf50146df724
```

También:

```text
CORR-029 =
APPROVED / CANONICAL / REMOTELY INCORPORATED / EXECUTED / REMOTELY VERIFIED

POST_AUTH_SUCCESS_DESTINATION =
/pending-profile

TASK-018 Work Items A/B/C =
DONE / APPROVED

TASK-018 Work Item D =
IMPLEMENTED CANDIDATE — BLOCKED IN CENTRAL REVIEW

Work Item E =
NOT AUTHORIZED

Hosted Development =
NOT AUTHORIZED

TASK-019 =
NOT DETERMINED / NOT AUTHORIZED
```

El blocker que CORR-030 resuelve es exclusivamente:

```text
FIRST-ADMIN INTENT LOCATOR DELIVERY / NAVIGATION MECHANISM UNSPECIFIED
```

---

## 6. Revisión de contradicciones

### 6.1 Resultado

```text
material canonical contradictions blocking CORR-030 = 0
```

Las fuentes recuperadas son compatibles con una decisión local de delivery/navigation que:

- mantiene `intent_id` como locator;
- mantiene email + code como proof visible;
- mantiene la verificación pre-auth purpose-specific;
- mantiene el handoff autoritativo en PostgreSQL;
- mantiene TASK-017 → TASK-018 dentro de la misma orquestación server-side;
- no crea una credencial de continuación browser-held;
- no crea tenant authority;
- no cambia `/pending-profile`.

### 6.2 Distinción necesaria entre pre-auth y post-auth URL

CORR-029 prohíbe transportar `intentId` en la URL post-auth:

```text
/pending-profile
```

CORR-030 no modifica esa regla.

La decisión de CORR-030 se limita a la superficie pre-auth de verificación, donde TASK-017 ya permite expresamente que un opaque `intent_id` sea llevado por UI/navigation como locator.

Por tanto:

```text
pre-auth locator URL
!=
post-auth authority transport
```

y:

```text
/pre-auth verification pathname may contain locator
```

no contradice:

```text
/pending-profile must not contain intentId
```

---

## 7. Invariantes cerradas

Debe preservarse:

```text
authenticated != authorized

intentId = locator, not bearer

email = locator/proof input, not tenant authority

VerificationChallenge code = application-owned proof

MaintenanceCompany = tenant

current PostgreSQL state > browser state

RLS = primary boundary for tenant-owned data

trusted verification/session orchestration = server-side

technical password = server-only

SessionGrant = non-bearer / single-use

POST_AUTH_SUCCESS_DESTINATION =
/pending-profile

profile completion =
OUT OF TASK-018

CompanyMembership creation =
NO

tenant authority =
NO

dashboard =
NO

offline Auth provisioning =
NO
```

Además:

```text
intent_id alone
!= handoff authority

intent_id alone
!= tenant authority

intent_id alone
!= successful verification

intent_id alone
!= SessionGrant

intent_id alone
!= Auth session
```

---

## 8. Hecho canónico determinante

TASK-017 establece que el target first admin debe:

```text
receive/retain an opaque intent locator
through the future approved delivery/navigation mechanism
```

y después ingresar:

```text
target email
+
verification code
```

TASK-017 también permite expresamente:

```text
opaque intent_id may be carried through UI/navigation as a locator
```

mientras preserva:

```text
intent_id alone != handoff authority
intent_id alone != tenant authority
```

TASK-018 exige que la UI continúe desde el mismo flow que presentó proof a TASK-017 y que la continuación TASK-017 → TASK-018 permanezca dentro de la misma trusted server orchestration.

Por tanto, CORR-030 no necesita crear un nuevo trust primitive.

Sólo debe cerrar el mecanismo de entrega y navegación que las TASK anteriores dejaron deliberadamente abierto.

---

## 9. Evaluación de alternativas

### 9.1 ALT-1 — Dedicated verification route con locator en pathname

Forma evaluada:

```text
/first-admin/verification/{intentId}
```

Propiedades:

- el locator es entregable sin pedirlo al usuario;
- no se crea un nuevo token;
- no se crea cookie de bootstrap;
- no se crea server-side navigation session;
- el locator estable sobrevive a challenge resend porque el intent es estable;
- la UI sigue solicitando únicamente email + code;
- el mismo locator puede llegar al API como input no autoritativo;
- la boundary TASK-017 vuelve a resolver intent/current challenge en PostgreSQL;
- la misma request server-side puede invocar TASK-018 después del handoff;
- no depende del provider concreto de email;
- es compatible con App Router y el monolito modular vigente.

Riesgo:

- el locator queda visible en una URL pre-auth y puede aparecer en history/access logs/referrer si no se aplican controles explícitos.

Ese riesgo es aceptable porque el locator no es bearer ni secret, pero requiere minimización explícita.

**Resultado:**

```text
ALT-1 =
SELECTED
```

### 9.2 ALT-2 — Dedicated verification route con locator en query

Forma evaluada:

```text
/first-admin/verification?intentId={intentId}
```

Seguridad fundamental:

```text
equivalent locator semantics
```

pero no ofrece una ventaja material sobre ALT-1.

Desventajas:

- mayor probabilidad de propagación accidental del parámetro mediante URLs copiadas, instrumentación o composición de query strings;
- cache/proxy behavior puede tratar query de manera desigual si se implementa incorrectamente;
- el query no aporta una capacidad requerida;
- el locator representa la identidad estable del recurso de navegación pre-auth, por lo que un segmento de path evita un parámetro opcional o múltiple sin necesidad.

**Resultado:**

```text
ALT-2 =
REJECTED FOR CORR-030
```

No se rechaza por ser inseguro por definición; se rechaza porque no aporta una ventaja frente al mecanismo seleccionado y aumenta superficies accidentales de propagación.

### 9.3 ALT-3 — Server-generated/state-backed navigation

Ejemplos conceptuales:

- cookie bootstrap;
- server navigation session;
- state record adicional;
- clean URL después de una primera landing.

Problema:

para entregar ese estado inicialmente a un browser pre-auth remoto todavía sería necesario:

- transportar el intent locator;
- o introducir una nueva credencial/nonce;
- o introducir un nuevo state lifecycle.

Eso agrega complejidad y potencialmente una nueva frontera de confianza sin necesidad demostrada.

También crea:

- same-device coupling;
- lifecycle de expiración/cleanup;
- recuperación adicional;
- nueva deuda de pruebas;
- riesgo de transformar state en credencial de continuación.

**Resultado:**

```text
ALT-3 =
REJECTED
```

### 9.4 ALT-4 — Otra alternativa

No se encontró soporte canónico concreto que justifique otra alternativa.

En particular se rechaza:

```text
lookup intent by email alone
```

porque email no es tenant authority, no posee uniqueness global nueva y ADR-0020 prohíbe utilizarlo como clave autoritativa para derivar `MaintenanceCompany`.

También se rechaza:

```text
user manually enters intent UUID
```

porque convierte un locator técnico en un tercer input humano no aprobado.

---

## 10. Decisión seleccionada

### 10.1 Mecanismo

La entrega inicial del locator se realizará mediante el mismo canal conceptual de email utilizado para RF-004, sin seleccionar provider concreto.

La entrega provider-neutral debe poder presentar al target first admin:

1. el verification code;
2. un enlace de navegación pre-auth que contiene el opaque `FirstAdminOnboardingIntent.id` como único locator técnico.

Forma exacta del pathname:

```text
FIRST_ADMIN_VERIFICATION_PATHNAME =
/first-admin/verification/{intentId}
```

Representación física App Router esperada:

```text
app/first-admin/verification/[intentId]/page.tsx
```

El enlace absoluto debe construirse server-side desde:

```text
trusted application origin configuration
+
FIRST_ADMIN_VERIFICATION_PATHNAME
```

No debe construirse a partir de un host/origin arbitrario suministrado por el target browser.

### 10.2 Contenido visible

La UI visible de verificación debe contener únicamente los proof inputs aprobados:

```text
email
+
verification code
```

No debe existir un campo visible/editable equivalente a:

```text
intentId
Referencia de acceso
UUID
tenant
company
role
grant
challenge
```

### 10.3 Resend

El `FirstAdminOnboardingIntent.id` es estable.

Un resend:

```text
same intent
→ new current VerificationChallenge
```

Por tanto el verification pathname permanece estable:

```text
/first-admin/verification/{sameIntentId}
```

mientras el code cambia conforme a TASK-013/TASK-017.

No se genera un locator nuevo por cada resend.

---

## 11. Respuestas obligatorias A–J

### A. ¿Qué superficie aprobada entrega inicialmente el opaque intent locator al browser?

**Decisión:**

```text
provider-neutral first-admin verification email
```

El mismo delivery conceptual que transporta el verification code debe poder incluir el link:

```text
/first-admin/verification/{intentId}
```

El link no sustituye el code.

El link no es una segunda prueba.

El link no es authority.

El concrete email provider permanece fuera de esta decisión.

### B. ¿Debe transportarse mediante URL/path/query, estado server-generated u otro mecanismo?

**Decisión:**

```text
URL pathname segment
```

Forma exacta:

```text
/first-admin/verification/{intentId}
```

No query.

No fragment.

No bootstrap cookie.

No nueva navigation session.

No state token.

### C. ¿Qué pathname exacto utiliza la verificación pre-profile?

```text
/first-admin/verification/{intentId}
```

El placeholder `{intentId}` representa un opaque `FirstAdminOnboardingIntent.id`.

Después de success:

```text
SESSION_ESTABLISHED
→ /pending-profile

SESSION_ALREADY_ESTABLISHED
→ /pending-profile
```

### D. ¿El locator puede aparecer en URL?

```text
YES — PRE-AUTH VERIFICATION URL ONLY
```

No puede aparecer en:

```text
/pending-profile
```

ni en ninguna success URL post-auth.

### E. Si aparece en URL

Se confirma:

```text
intentId in URL
=
locator only
```

No:

```text
bearer
secret
tenant authority
handoff authority
session authority
```

Conocer únicamente ese locator no concede continuación.

La verificación sigue requiriendo:

```text
same authoritative intent/current challenge
+
presented target email correlation
+
valid candidate code
+
current authoritative lifecycle checks
```

Requisitos de minimización:

1. el URL pre-auth contiene únicamente el locator técnico necesario;
2. email NO aparece en URL;
3. code NO aparece en URL;
4. tenant/company ID NO aparece en URL;
5. role NO aparece en URL;
6. challenge ID NO aparece en URL;
7. grant ID NO aparece en URL;
8. Auth user ID NO aparece en URL;
9. access/refresh tokens NO aparecen en URL;
10. technical password NO aparece en URL.

Requisitos de cache:

```text
verification page =
private / no-store
```

No debe depender de static caching que preserve una respuesta asociada a un locator.

El API de verificación continúa con respuesta privada/no-store.

Requisitos de referrer:

```text
Referrer-Policy =
no-referrer
```

o mecanismo equivalente de plataforma que impida propagar el locator mediante `Referer`.

No se utilizará el URL completo como valor de redirección externa.

Requisitos de logging:

- no loguear code;
- no loguear technical password;
- no loguear access/refresh tokens;
- no loguear full target email en logs ordinarios;
- no duplicar deliberadamente el verification URL completo en application logs;
- `intentId` puede utilizarse como correlation identifier server-side conforme al contrato ya permitido por TASK-018;
- si infraestructura de acceso registra path automáticamente, ese hecho no convierte el locator en secret ni authority, pero no autoriza replicarlo a telemetría adicional;
- no enviar el URL pre-auth completo a terceros por analytics/telemetry introducidos por CORR-030.

Requisitos de history/navigation:

- success utiliza navegación de reemplazo hacia `/pending-profile`;
- `/pending-profile` no conserva el locator;
- CORR-030 no introduce persistencia local del locator.

### F. ¿Cómo se preserva el producto visible como email + code?

El form recibe `intentId` desde el pathname como prop/estado de navegación interno no editable.

Visible:

```text
Correo electrónico
Código de verificación
Continuar
```

No visible/editable:

```text
Referencia de acceso
intentId
UUID
```

El locator puede existir en browser memory/route state técnico porque el canon ya permite que el browser lo lleve como locator.

Eso no lo convierte en proof.

### G. ¿Cómo llega el mismo locator a la boundary server-side de TASK-017 sin convertirse en authority?

Flujo aprobado:

```text
verification email
→ /first-admin/verification/{intentId}
→ route composition passes intentId to verification form as opaque locator
→ form submits:
     intentId
     email
     code
     verificationOperationId
→ POST /api/first-admin/verification
→ purpose-specific server orchestration
→ TASK-017 resolves intent + current challenge from PostgreSQL
→ TASK-017 validates email/code/current binding
→ TASK-017 produces/reconciles authoritative handoff
→ same server orchestration invokes TASK-018
→ TASK-018 re-resolves authoritative handoff/current state using the locator
→ bounded outcome / Auth cookies
→ /pending-profile
```

Security rule:

```text
browser-supplied intentId =
lookup locator only
```

Never:

```text
authority
```

La API no acepta un segundo tenant target, role, challenge, grant o Auth subject para cambiar el contexto autoritativo.

La existencia de `intentId` en el POST no es un trust regression porque TASK-017 ya exige resolver el intent y el current challenge autoritativamente antes de consumir proof.

### H. ¿Qué documentos deben modificarse?

#### TASK-017

```text
UPDATE REQUIRED =
YES — MINIMAL DOCUMENTATION SYNC
```

Razón:

TASK-017 dejó expresamente abierto:

```text
future approved delivery/navigation mechanism
```

CORR-030 cierra ese punto.

Debe sincronizarse de forma mínima:

- §26.2 Target first-admin verification flow;
- §29 Email-delivery boundary;
- cualquier superficie de testing/DoD que describa el delivery material de forma incompatible con el link provider-neutral.

No cambia:

- lifecycle de intent;
- challenge;
- attempts;
- resend;
- atomicity;
- handoff;
- RLS;
- privilege;
- provider selection.

No se autoriza por CORR-030 una nueva implementación TASK-017.

#### TASK-018

```text
UPDATE REQUIRED =
YES — MINIMAL DOCUMENTATION SYNC
```

Debe fijarse expresamente en:

- §20.1 Entry;
- Work Item D;
- testing de Work Item D;
- Definition of Done / Gate relacionado con Work Item D;

que:

```text
FIRST_ADMIN_VERIFICATION_PATHNAME =
/first-admin/verification/{intentId}
```

y que el locator llega por route navigation, no por un input editable.

No se cambia `AC-018-084..090` salvo que una corrección documental posterior necesite una aclaración mínima sin alterar su semántica ni renumeración.

#### Product docs

```text
docs/product/00-master-product-brief.md =
NO UPDATE REQUIRED

docs/product/01-product-definition.md =
NO UPDATE REQUIRED

docs/product/02-domain-model.md =
NO UPDATE REQUIRED

docs/product/03-permissions-rls-strategy.md =
NO UPDATE REQUIRED
```

RF-012 y FL-01 continúan siendo email + code + profile completion posterior.

No se crea nueva entidad de dominio.

No se cambia autorización.

No se cambia RLS.

#### ADR-0020

```text
UPDATE REQUIRED =
NO
```

ADR-0020 ya permite explícitamente llevar opaque `intent_id` por UI/navigation como locator y ya define que no es authority.

CORR-030 selecciona una representación local compatible con esa arquitectura.

#### ADR-0019

```text
UPDATE REQUIRED =
NO
```

No cambia E2 ni la frontera de technical password/SessionGrant.

#### CORR-029

```text
UPDATE REQUIRED =
NO
```

`/pending-profile` permanece exactamente igual.

La prohibición de locator/authority material en la success URL post-auth permanece intacta.

### I. ¿Nuevo ADR requerido?

```text
NEW ADR REQUIRED =
NO
```

Motivos:

1. ADR-0020 ya define el trust model del intent;
2. ADR-0019 ya define la Auth/session boundary;
3. no se crea bearer;
4. no se crea token de continuación;
5. no se crea nueva session architecture;
6. no se cambia RLS;
7. no se cambia multitenancy;
8. no se cambia dominio;
9. no se crea infraestructura distribuida;
10. pathname + provider-neutral navigation link es una decisión local y reversible dentro del App Router ya aprobado.

Si una implementación futura intentara transformar el locator URL en credential, firmar un nuevo continuation token o crear una state machine/browser session nueva, esta conclusión dejaría de aplicar y sería necesario volver al Revisor Central.

### J. ¿La decisión afecta RF-004/email-delivery o puede mantenerse independiente del concrete email provider?

```text
concrete provider dependency =
NO
```

CORR-030 fija sólo un provider-neutral content/navigation contract:

```text
delivery material =
verification code
+
verification URL containing opaque intent locator
```

No selecciona:

- Resend;
- SMTP;
- Supabase email provider;
- template engine;
- retry/backoff;
- queue;
- provider credentials.

RF-004 permanece:

```text
PARTIAL / NOT END-TO-END
```

hasta que exista un adapter externo aprobado e implementado.

CORR-030 no convierte RF-004 en completado.

---

## 12. Browser-visible contract

### 12.1 URL pre-auth

Permitida:

```text
/first-admin/verification/{intentId}
```

Prohibido añadir:

```text
?email=
?code=
?tenant=
?role=
?challenge=
?grant=
```

También quedan prohibidos fragmentos que transporten esos valores.

### 12.2 Form

Campos editables:

```text
email
code
```

No existe field editable `intentId`.

No existe hidden form control requerido como proof.

El componente puede conservar el locator como prop/variable técnica para construir el request.

### 12.3 Success URL

Exactamente:

```text
/pending-profile
```

Sin query.

Sin fragment.

Sin locator.

Sin metadata de reconciliation/provider.

---

## 13. Server-side trust contract

La boundary server-side debe conservar:

```text
intentId received from browser
→ resolve authoritative intent
→ derive MaintenanceCompany from intent
→ derive target email from intent
→ resolve current challenge from intent
→ correlate presented email
→ verify candidate code
→ consume/reconcile proof
→ obtain durable handoff
```

El servidor NO debe:

- derivar tenant desde URL path;
- derivar tenant desde presented email;
- aceptar role;
- aceptar membership;
- aceptar company ID como nueva authority;
- aceptar arbitrary challenge;
- aceptar grant como bearer;
- interpretar UUID validity como autorización.

El post-verification orchestration actual puede continuar utilizando el mismo `intentId` para llamar a la session-establishment service después de un `handoffReady` válido porque:

1. ocurre dentro de la misma server request/orchestration;
2. TASK-018 re-resuelve authoritative handoff state;
3. `establish(intentId)` no concede success por conocer el UUID;
4. no existe un endpoint público separado cuya única prueba sea el locator.

Por tanto no es necesario crear un nuevo trusted browser token para enlazar TASK-017 con TASK-018.

---

## 14. No enumeración

La nueva route no debe convertirse en una lookup API de intents.

### 14.1 Render inicial

El render de:

```text
/first-admin/verification/{intentId}
```

no debe revelar:

- si el intent existe;
- empresa asociada;
- target email;
- current challenge;
- estado de Auth;
- membership;
- tenant.

La page puede aceptar el locator para componer el form sin consultar estado autoritativo de onboarding.

Si se realiza validación sintáctica del UUID, ésta sólo puede distinguir estructura inválida, no existencia de dominio.

### 14.2 Submit

Los outcomes externos continúan bounded según TASK-017/TASK-018.

No debe aparecer un mensaje específico equivalente a:

- “intent no existe”;
- “email pertenece a otra empresa”;
- “challenge de otra empresa”;
- “cuenta Auth ya existe”;
- “membership incompatible”.

### 14.3 UUID opacity

La opacidad/entropía del UUID ayuda a reducir enumeración casual, pero:

```text
UUID unpredictability
!= authorization control
```

La seguridad continúa dependiendo de proof + estado PostgreSQL autoritativo.

---

## 15. Hallazgos sobre la implementación candidata de Work Item D

### 15.1 `app/page.tsx`

Actualmente:

```text
/
→ FirstAdminVerificationForm
```

El root renderiza directamente el form sin disponer de un locator proveniente de navegación aprobada.

Esto explica por qué la implementación necesitó pedir el locator al usuario.

### 15.2 `app/first-admin-verification-form.tsx`

Actualmente existen tres inputs visibles:

```text
Referencia de acceso
Correo electrónico
Código de verificación
```

y:

```text
name="intentId"
required
type="text"
```

Luego el form envía:

```text
intentId: formData.get("intentId")
```

Este es el defecto exacto.

### 15.3 `app/api/first-admin/verification/route.ts`

Actualmente el request contract exige:

```text
code
email
intentId
verificationOperationId
```

La presencia de `intentId` en este body es compatible con el canon siempre que sea tratado como locator.

El Route Handler:

- no acepta tenant;
- no acepta role;
- no acepta membership;
- preserva origin check;
- preserva content-type check;
- preserva private/no-store response;
- invoca la server orchestration purpose-specific.

No se requiere cambiar su trust model.

### 15.4 `first-admin-post-verification-service.ts`

Actualmente:

```text
verify(input)
→ if handoffReady
→ establish(input.intentId)
```

en la misma server orchestration.

Esto es compatible con TASK-018 porque el establishment service debe re-resolver el authoritative handoff y el locator no es authority.

No se requiere un token de continuación nuevo.

### 15.5 `src/modules/identity-authorization/server.ts`

La composición actual mantiene:

```text
verification service
+
session establishment service
```

dentro del módulo server-side.

No se detecta necesidad de ampliar la boundary pública ni exportar privileged client.

### 15.6 Tests

Los tests actuales verifican correctamente:

- bounded outcomes;
- same server orchestration;
- `/pending-profile`;
- cookie/header propagation;
- origin rejection;
- generic errors;
- no post-auth authority material.

Pero no verifican:

- dedicated pre-auth verification route;
- locator recibido por navegación;
- ausencia de third editable field;
- URL hygiene pre-auth;
- referrer/cache contract de la verification page;
- stable locator across resend conceptually.

---

## 16. Corrección mínima requerida sobre Work Item D

### 16.1 Nuevo route entrypoint

Añadir:

```text
app/first-admin/verification/[intentId]/page.tsx
```

Responsabilidad exclusiva:

- recibir el dynamic segment;
- tratarlo como opaque locator;
- componer `FirstAdminVerificationForm` con ese locator;
- no consultar/mostrar tenant;
- no consultar/mostrar target email;
- no decidir authorization;
- aplicar el contrato no-store/referrer requerido mediante el mecanismo local apropiado de Next.js.

### 16.2 `app/first-admin-verification-form.tsx`

Cambios mínimos:

1. aceptar `intentId` como prop readonly;
2. eliminar completamente el input visible:

```text
Referencia de acceso
```

3. eliminar `formData.get("intentId")`;
4. enviar el prop `intentId` en el body;
5. preservar email;
6. preservar code;
7. preservar `verificationOperationId`;
8. preservar bounded UI states;
9. preservar `router.replace("/pending-profile")`;
10. no persistir locator en localStorage/sessionStorage/IndexedDB.

### 16.3 `app/page.tsx`

Debe dejar de ser una superficie first-admin verification sin locator.

Debe eliminar:

```text
<FirstAdminVerificationForm />
```

sin un `intentId` entregado por la navegación aprobada.

CORR-030 no determina una nueva función de producto para `/`.

Si el repositorio requiere conservar una root page para build/UI base, puede permanecer una shell neutral que no implemente ninguna capability nueva.

### 16.4 `app/api/first-admin/verification/route.ts`

```text
semantic trust change required =
NO
```

Puede conservar el request body actual:

```text
intentId
email
code
verificationOperationId
```

porque `intentId` es locator.

Debe preservarse:

- strict bounded body;
- origin check;
- content-type check;
- no-store response;
- no tenant/role authority;
- same server orchestration.

No debe intentar recuperar intent por email para eliminar el locator.

### 16.5 `first-admin-post-verification-service.ts`

```text
semantic change required =
NO
```

Debe preservarse:

```text
verify(input)
before
establish(intentId)
```

y:

```text
establish only after authoritative handoffReady
```

No se crea un segundo request browser-side entre verify y establish.

### 16.6 `src/modules/identity-authorization/server.ts`

```text
change required =
NO
```

salvo import/wiring mecánico estrictamente necesario si el repositorio real lo exige.

No se exporta una nueva privileged capability.

### 16.7 Tests

Deben corregirse/ampliarse conforme a §22.

---

## 17. Delivery contract provider-neutral

CORR-030 fija conceptualmente que cada first-admin code delivery utilizable debe incluir la navegación correspondiente al mismo intent.

Conceptual delivery material:

```text
target email
transient verification code
verification pathname/URL containing stable intentId
```

No se exige persistir el URL.

No se persiste plaintext code.

La absolute URL puede regenerarse desde:

```text
trusted application origin
+
stable intentId
```

El resend utiliza:

```text
same intentId
+
new code
```

El provider adapter no decide:

- tenant;
- current challenge;
- resend authorization;
- intent lifecycle;
- session;
- membership.

---

## 18. Seguridad de URL

### 18.1 Locator visible

Se acepta que el locator sea visible pre-auth porque:

- ADR-0020/TASK-017 permiten llevarlo por navigation;
- no contiene tenant authority;
- no contiene code;
- no contiene email;
- no contiene grant;
- no contiene token;
- conocerlo no alcanza para verificar.

### 18.2 Cache

La verification page debe impedir almacenamiento compartido o reutilización estática.

Contrato:

```text
Cache-Control:
private, no-store
```

o semántica equivalente soportada por Next.js para la page response.

No se autoriza usar caching como fuente de state.

### 18.3 Referrer

Contrato:

```text
Referrer-Policy:
no-referrer
```

para impedir que navegaciones/subrequests propaguen el locator.

### 18.4 Logging

TASK-018 ya permite `intent ID` como correlation identifier server-side.

CORR-030 no cambia eso.

Sin embargo:

- no registrar full verification URL en logs de aplicación cuando el `intentId` separado sea suficiente;
- no registrar code;
- no registrar full email ordinariamente;
- no registrar cookies;
- no registrar access/refresh tokens;
- no registrar technical password;
- no añadir analytics/telemetry de third party por esta decisión.

### 18.5 URL post-auth

En success:

```text
router.replace("/pending-profile")
```

Debe quedar:

```text
visible success URL =
/pending-profile
```

sin locator.

---

## 19. Multitenancy y RLS

```text
RLS change required =
NO
```

```text
schema change required =
NO
```

```text
new tenant authority =
NO
```

El intent continúa platform-owned.

El pathname no convierte el intent en tenant-owned.

El browser no deriva:

- `MaintenanceCompany`;
- role;
- membership;
- client scope.

La empresa se deriva únicamente desde `FirstAdminOnboardingIntent` en la boundary autoritativa.

RLS continúa siendo la frontera primaria para tenant-owned data.

No se crea policy nueva para resolver CORR-030.

---

## 20. Offline

```text
offline Auth provisioning =
NO
```

No introducir:

- Dexie;
- IndexedDB;
- Service Worker continuation;
- outbox;
- cached grant;
- cached technical password;
- offline proof consumption.

El locator puede existir transitoriamente en la URL/browser memory, pero no se convierte en autorización offline.

---

## 21. Impacto documental exacto

| Documento | ¿Actualizar? | Alcance |
|---|---:|---|
| `TASK-017` | YES | cerrar placeholder de delivery/navigation; email provider-neutral link + stable locator; sin cambiar lifecycle/security |
| `TASK-018` | YES | fijar pre-auth pathname, locator route contract y Work Item D UI/tests |
| `00-master-product-brief.md` | NO | producto visible no cambia |
| `01-product-definition.md` | NO | RF-012/FL-01 no cambian |
| `02-domain-model.md` | NO | no hay nueva entidad |
| `03-permissions-rls-strategy.md` | NO | no cambia autorización/RLS |
| `ADR-0019` | NO | E2 no cambia |
| `ADR-0020` | NO | ya soporta locator por UI/navigation |
| `CORR-029` | NO | `/pending-profile` permanece igual |
| architecture decision registry | NO | no nace ADR nuevo |

La posterior sincronización documental de TASK-017/TASK-018 requiere Gate separado conforme al proceso vigente.

CORR-030 no ejecuta esa sincronización.

---

## 22. Pruebas requeridas para la corrección de Work Item D

### 22.1 Dedicated route

Demostrar:

```text
/first-admin/verification/{intentId}
→ renders verification form
```

sin necesidad de third input.

### 22.2 Visible field contract

La UI contiene exactamente como proof editable:

```text
email
code
```

El test debe demostrar ausencia de:

```text
name="intentId"
Referencia de acceso
```

como input editable.

### 22.3 Request contract

Al submit:

```text
body.intentId =
locator supplied by route
```

y no un valor introducido manualmente.

Debe continuar:

```text
body.email =
user input

body.code =
user input

body.verificationOperationId =
existing operation correlation contract
```

CORR-030 no reabre el origen actual de `verificationOperationId`.

### 22.4 No email lookup fallback

Debe existir una prueba que falle si la implementación intenta resolver first-admin intent únicamente por presented email.

### 22.5 Cross-intent / invalid locator

Locator de otro intent o locator no resoluble:

- no concede tenant;
- no concede handoff;
- no establece sesión;
- produce bounded non-enumerating outcome.

### 22.6 Correct locator + wrong proof

Debe reutilizar TASK-017 attempt semantics.

No se salta code verification por disponer del locator.

### 22.7 Correct proof

Con:

```text
matching intent locator
+
matching presented email
+
valid current code
```

la misma server orchestration puede producir handoff y continuar TASK-018.

### 22.8 Post-auth URL

Ambos:

```text
SESSION_ESTABLISHED
SESSION_ALREADY_ESTABLISHED
```

convergen a:

```text
/pending-profile
```

sin locator/query/fragment.

### 22.9 Pre-auth URL hygiene

La verification URL contiene:

```text
intentId
```

pero no:

- email;
- code;
- tenant;
- role;
- challenge;
- grant;
- token.

### 22.10 Cache/referrer

Verificar mediante la superficie real elegida por Next.js que la verification page cumple:

```text
no-store
no-referrer
```

o semántica equivalente demostrable.

### 22.11 Root page

`app/page.tsx` no renderiza un first-admin form que exija locator manual.

### 22.12 Server orchestration

Preservar test:

```text
verify call order
<
establish call order
```

y demostrar que establish no ocurre ante verification failure/handoff not ready.

### 22.13 Browser secrets

Preservar ausencia de:

- technical password;
- grant bearer;
- access token JSON;
- refresh token JSON;
- provider/Admin secrets.

### 22.14 No account enumeration

Visible messages no distinguen:

- existing Auth account;
- unknown intent;
- other tenant;
- incompatible membership;
- provider detail.

### 22.15 Online only

Preservar ausencia de:

- localStorage authority;
- sessionStorage authority;
- IndexedDB;
- Dexie;
- Service Worker continuation;
- outbox.

---

## 23. Criterios de aceptación de CORR-030

**AC-030-001.** Las diez fuentes requeridas fueron recuperadas y consumidas.

**AC-030-002.** TASK-018 SOURCE-03 coincide con el SHA-256 canónico proporcionado.

**AC-030-003.** Se preserva RF-012 como email + valid code + profile completion posterior.

**AC-030-004.** Se preserva FL-01.

**AC-030-005.** `intentId` permanece locator y no bearer.

**AC-030-006.** Se selecciona una única superficie inicial de entrega del locator.

**AC-030-007.** La superficie seleccionada es el provider-neutral verification email.

**AC-030-008.** El email delivery contiene conceptualmente code + verification link.

**AC-030-009.** No se selecciona concrete email provider.

**AC-030-010.** El exact pre-auth pathname es `/first-admin/verification/{intentId}`.

**AC-030-011.** El locator se transporta en pathname y no query.

**AC-030-012.** No se crea bootstrap cookie/state token/navigation session.

**AC-030-013.** No se crea una nueva credencial de continuación.

**AC-030-014.** Conocer `intentId` no autoriza verification success.

**AC-030-015.** Conocer `intentId` no autoriza TASK-018.

**AC-030-016.** Conocer `intentId` no concede tenant authority.

**AC-030-017.** El browser-visible editable contract es email + code.

**AC-030-018.** Se elimina el requisito de introducir manualmente un raw UUID.

**AC-030-019.** No se incluye email en verification URL.

**AC-030-020.** No se incluye code en verification URL.

**AC-030-021.** No se incluye tenant/role/grant/challenge/token en verification URL.

**AC-030-022.** Verification page debe ser no-store/private.

**AC-030-023.** Verification page debe impedir referrer propagation mediante `no-referrer` o equivalente.

**AC-030-024.** Application logs no duplican innecesariamente full verification URL.

**AC-030-025.** `intentId` puede permanecer correlation ID server-side conforme a TASK-018.

**AC-030-026.** La route inicial no enumera existencia de intents.

**AC-030-027.** La seguridad no depende de UUID entropy.

**AC-030-028.** El same locator permanece estable a través de resend.

**AC-030-029.** Cada resend continúa produciendo un nuevo challenge/code conforme a TASK-017.

**AC-030-030.** La boundary verify continúa resolviendo intent/current challenge autoritativamente.

**AC-030-031.** Presented email continúa siendo locator/proof input, no authority.

**AC-030-032.** El server deriva company exclusivamente del intent.

**AC-030-033.** TASK-017 → TASK-018 continúa en la misma trusted server orchestration.

**AC-030-034.** No se introduce un segundo browser request para transportar handoff authority.

**AC-030-035.** El API puede continuar recibiendo `intentId` como body locator.

**AC-030-036.** API route no acepta tenant authority nueva.

**AC-030-037.** `first-admin-post-verification-service.ts` no requiere un nuevo bearer.

**AC-030-038.** `src/modules/identity-authorization/server.ts` no requiere nueva privileged capability.

**AC-030-039.** `app/page.tsx` deja de exigir manual locator entry.

**AC-030-040.** Se añade el dedicated pre-auth route entrypoint.

**AC-030-041.** `/pending-profile` permanece exacto.

**AC-030-042.** `/pending-profile` no contiene locator.

**AC-030-043.** CORR-029 permanece sin modificación.

**AC-030-044.** Product docs no requieren modificación.

**AC-030-045.** Domain model no requiere modificación.

**AC-030-046.** Permissions/RLS strategy no requiere modificación.

**AC-030-047.** ADR-0019 no requiere modificación.

**AC-030-048.** ADR-0020 no requiere modificación.

**AC-030-049.** TASK-017 requiere minimal documentation sync.

**AC-030-050.** TASK-018 requiere minimal documentation sync.

**AC-030-051.** Nuevo ADR no es requerido.

**AC-030-052.** RLS change no es requerido.

**AC-030-053.** Schema change no es requerido.

**AC-030-054.** No se crea `PlatformUser`.

**AC-030-055.** No se crea `CompanyMembership`.

**AC-030-056.** No se habilita tenant authority.

**AC-030-057.** Offline Auth provisioning no se introduce.

**AC-030-058.** RF-004 permanece provider-neutral y `PARTIAL / NOT END-TO-END`.

**AC-030-059.** Work Item D permanece bloqueado al terminar CORR-030 specification generation.

**AC-030-060.** Work Item E, Hosted Development y TASK-019 permanecen no autorizados.

**AC range:** `AC-030-001..AC-030-060`

**AC count:** `60`

---

## 24. Definition of Done de CORR-030 specification

**DoD-030-001.** Las fuentes previamente ausentes están físicamente disponibles.

**DoD-030-002.** Las fuentes se consumieron sin sustituirlas por convención genérica.

**DoD-030-003.** Se confirmó ausencia de contradicción bloqueante.

**DoD-030-004.** Se evaluaron pathname, query y state-backed navigation.

**DoD-030-005.** Se seleccionó una alternativa concreta.

**DoD-030-006.** Se fijó la superficie inicial de delivery.

**DoD-030-007.** Se fijó el pathname exacto pre-auth.

**DoD-030-008.** Se decidió expresamente que el locator puede aparecer en URL pre-auth.

**DoD-030-009.** Se preservó locator != bearer.

**DoD-030-010.** Se definieron cache/referrer/logging/minimization controls.

**DoD-030-011.** Se preservó visible email + code.

**DoD-030-012.** Se eliminó conceptualmente third editable technical field.

**DoD-030-013.** Se definió el server-side handoff del locator.

**DoD-030-014.** Se preservó same-request trusted orchestration TASK-017 → TASK-018.

**DoD-030-015.** Se identificaron los documentos afectados.

**DoD-030-016.** Se determinó `NEW ADR REQUIRED = NO`.

**DoD-030-017.** Se determinó RF-004 provider independence.

**DoD-030-018.** Se inspeccionó la implementación candidata path-by-path.

**DoD-030-019.** Se definió la corrección mínima de Work Item D.

**DoD-030-020.** Se definieron pruebas positivas, negativas y de seguridad.

**DoD-030-021.** `/pending-profile` permanece sin cambios.

**DoD-030-022.** Profile completion permanece fuera de scope.

**DoD-030-023.** No se autoriza implementación.

**DoD-030-024.** Work Item D permanece bloqueado.

**DoD-030-025.** Work Item E permanece no autorizado.

**DoD-030-026.** Hosted Development permanece no autorizado.

**DoD-030-027.** TASK-019 permanece no determinada/no autorizada.

**DoD range:** `DoD-030-001..DoD-030-027`

---

## 25. Gate para reanudar TASK-018 Work Item D

### 25.1 Estado al terminar esta especificación

```text
CORR-030 SPECIFICATION =
READY FOR REVIEW

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
```

### 25.2 Condiciones mínimas para retirar el blocker CORR-030

El blocker:

```text
FIRST-ADMIN INTENT LOCATOR DELIVERY / NAVIGATION MECHANISM UNSPECIFIED
```

sólo podrá considerarse resuelto operativamente después de:

1. `CORR-030 SPEC REVIEW = APPROVED`;
2. aprobación humana explícita;
3. generación del artefacto aprobado conforme al proceso vigente;
4. revisión de identidad del artefacto aprobado;
5. canonicalización de CORR-030;
6. revisión de canonicalización;
7. incorporación canónica al repositorio mediante Gate separado;
8. sincronización documental autorizada de TASK-017 y TASK-018 cuando corresponda;
9. revisión de esa sincronización;
10. autorización humana separada para corregir/reanudar Work Item D.

La aprobación de CORR-030 por sí sola:

```text
!=
Work Item D implementation authorization
```

### 25.3 Condiciones que mantienen Work Item D bloqueado

Work Item D continúa bloqueado si:

- se pretende volver a pedir `intentId` manualmente;
- se introduce query en lugar del pathname aprobado sin nueva decisión;
- se introduce bootstrap token/cookie/state con semántica de autoridad;
- se incluye code/email/tenant/role en URL;
- se intenta resolver intent por email como authority;
- se cambia ADR-0019 E2;
- se cambia ADR-0020 trust model;
- se requiere schema/RLS nuevo;
- se requiere tenant authority;
- se implementa profile completion;
- se cambia `/pending-profile`;
- se requiere concrete email provider para la corrección UI;
- se intenta implementar Work Item E;
- se intenta usar Hosted Development;
- se intenta determinar TASK-019.

---

## 26. Resultado final

La decisión de CORR-030 es:

```text
FIRST_ADMIN_INTENT_LOCATOR_INITIAL_DELIVERY =
PROVIDER-NEUTRAL VERIFICATION EMAIL LINK

FIRST_ADMIN_VERIFICATION_PATHNAME =
/first-admin/verification/{intentId}

LOCATOR_TRANSPORT =
PATHNAME SEGMENT

LOCATOR_IN_PRE_AUTH_URL =
YES

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

NEW ADR REQUIRED =
NO

PRODUCT DOC UPDATE REQUIRED =
NO

DOMAIN MODEL UPDATE REQUIRED =
NO

RLS UPDATE REQUIRED =
NO

ADR-0020 UPDATE REQUIRED =
NO

TASK-017 DOCUMENTATION SYNC REQUIRED =
YES — MINIMAL

TASK-018 DOCUMENTATION SYNC REQUIRED =
YES — MINIMAL

CONCRETE EMAIL PROVIDER REQUIRED =
NO

RF-004 END-TO-END =
REMAINS INCOMPLETE / PARTIAL
```

Por tanto:

```text
CORR-030 SPECIFICATION =
APPROVED
```

Debe permanecer:

```text
TASK-018 WORK ITEM D =
REMAINS BLOCKED

TASK-018 WORK ITEM D staging =
NOT AUTHORIZED

WORK ITEM E =
NOT AUTHORIZED

Hosted Development =
NOT AUTHORIZED

TASK-019 =
NOT DETERMINED / NOT AUTHORIZED
```

STOP.

RETURN TO REVISOR CENTRAL.
