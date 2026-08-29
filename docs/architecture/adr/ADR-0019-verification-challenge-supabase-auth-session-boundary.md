# ADR-0019 — VerificationChallenge, Supabase Auth y frontera de establecimiento de sesión

> **Archivo de entrega:** `ADR-0019-verification-challenge-supabase-auth-session-boundary-approved.md`  
> **Ruta canónica futura propuesta:** `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`  
> **Fase:** Fase 2 — Multitenancy, autenticación, roles y RLS  
> **Tipo:** Architecture Decision Record  
> **Status:** `ACCEPTED`  
> **Estado de revisión:** `APPROVED`  
> **Decisión:** `E2 — Application-owned challenge + one-time session grant + server-only technical password bridge + Custom Access Token Hook gate`  
> **Naturaleza:** decisión arquitectónica sobre ownership del `VerificationChallenge`, integración con Supabase Auth, establecimiento de sesión, prevención de bypass y frontera privilegiada; **NO constituye implementación, SQL, migration, RLS ejecutable, configuración aplicada a Supabase Cloud ni autorización de TASK-013**.

**ID:** `ADR-0019`  
**Title:** `VerificationChallenge, Supabase Auth y frontera de establecimiento de sesión`  
**Status:** `ACCEPTED`  
**Review state:** `APPROVED`

El estado `ACCEPTED` aprueba exclusivamente la decisión arquitectónica documentada en ADR-0019.

La aceptación **NO** autoriza implementación, código, SQL, migration, RLS, modificación de Supabase Cloud ni ejecución de TASK-013.

---

# 1. Estado de gobernanza

Se consume como estado formal:

```text
TASK-013 DETERMINATION = APPROVED

TASK-013 — Fundación física segura del lifecycle de VerificationChallenge

TASK-013 SPEC REVIEW = APPROVED AS BLOCKED

TASK-013 SPECIFICATION =
BLOCKER — ARCHITECTURE DECISION REQUIRED

VERIFICATION CHALLENGE / SUPABASE AUTH
ARCHITECTURE DECISION REQUIRED = YES

ADR-0019 DETERMINATION = APPROVED

ADR-0019 ARCHITECTURE REVIEW = APPROVED
ADR-0019 DOCUMENT CORRECTION REVIEW = APPROVED
ADR-0019 SECOND REVIEW = APPROVED
ADR-0019 HUMAN APPROVAL = APPROVED
ADR-0019 = ACCEPTED
```

Debe permanecer:

```text
ADR-0019 aceptada = SÍ
ADR-0019 canonicalizada = NO

TASK-013 sigue bloqueada = SÍ
TASK-013 implementación autorizada = NO

TASK-014 determinada = NO
TASK-014 generada = NO
```

Este ADR no implementa ninguna capacidad y no modifica el estado de ejecución de TASK-013.

---

# 2. Context

El producto exige un alta e ingreso inicial mediante:

```text
email + código
```

con un lifecycle contractual más estricto que los defaults ordinarios de un proveedor de OTP:

```text
vigencia por emisión = 8 horas
máximo intentos por emisión = 3
resend por actor autorizado = permitido
cada resend = nueva emisión
nueva emisión → emisión anterior invalidada inmediatamente
cada emisión → contador propio de intentos
vencido → no reutilizable
consumido → no reutilizable
```

La fuente de verdad de producto establece además que:

```text
tenant = MaintenanceCompany
authenticated != authorized
valid Auth session != tenant authorization
current authoritative state > stale authorization state
RLS = primary remote isolation boundary para datos tenant-owned
service-role = excepcional/restringido
service-role como client genérico de requests = PROHIBIDO
SUPER_ADMIN global != tenant bypass
VerificationChallenge = platform-owned
```

TASK-009 materializó el vínculo físico:

```text
Auth subject → PlatformUser
```

y la foundation mínima de `MaintenanceCompany` / `CompanyMembership`.

TASK-010 materializó la foundation física de `AuditEvent`, sin productores funcionales.

TASK-011 materializó únicamente el lifecycle técnico SSR de Supabase Auth en Next.js, sin login funcional.

TASK-012 materializó únicamente la resolución server-side autoritativa:

```text
validated Auth subject
→ PlatformUser
→ current enabled CompanyMembership
→ MaintenanceCompany
→ current tenant role
```

sin completar autorización de aplicación.

TASK-013 confirmó que el lifecycle de negocio de `VerificationChallenge` puede representarse de forma application-owned, pero que una prueba application-owned no dispone por sí misma de una primitive pública no privilegiada que cree una sesión Supabase. También confirmó que delegar el secreto a Email OTP de Supabase no demuestra RF-006 ni RF-009 con el contrato oficial actual.

El problema arquitectónico no es, por tanto, sólo “cómo guardar un código”. Es cómo construir una cadena no eludible:

```text
business challenge autorizado
→ proof de ese challenge
→ consumo single-use autoritativo
→ identidad Supabase Auth creada/confirmada cuando corresponda
→ sesión Supabase
```

sin permitir otra cadena pública equivalente que ignore el lifecycle aprobado.

---

# 3. Fuentes de verdad consumidas

## 3.1 Producto

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/04-offline-sync-strategy.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md`

## 3.2 Arquitectura

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`
- `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`
- `docs/architecture/adr/ADR-0012-report-document-model-renderers.md`
- `docs/architecture/adr/ADR-0013-ai-server-side-provider-boundary.md`

Los ADR posteriores se utilizan únicamente para conservar formato, disciplina de fronteras server-side/provider, mínimo privilegio e idempotencia. No se trasladan reglas de IA o Reporting a Auth.

## 3.3 Incrementos de Fase 2

- `docs/tasks/TASK-009-identity-tenant-foundation.md`
- `docs/tasks/TASK-010-audit-event-foundation.md`
- `docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md`
- `docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`
- `docs/tasks/CORR-014-task-012-closure-state-sync.md`
- `TASK-013-verification-challenge-foundation.md`

## 3.4 Regla de autoridad

No se utiliza conversación histórica como sustituto del canon.

Cuando una primitive o comportamiento de Supabase es relevante para seguridad, sólo se considera disponible si existe documentación oficial vigente suficiente para sostener el contrato requerido.

---

# 4. Problem

¿Cómo integrar un `VerificationChallenge` capaz de imponer autoritativamente RF-004…RF-011 con Supabase Auth y obtener finalmente una sesión Supabase, sin:

- debilitar los ocho horas por emisión;
- convertir un rate limit del proveedor en el presupuesto exacto de tres intentos;
- aceptar invalidación de resend “best effort”;
- permitir replay o doble consumo;
- permitir creación de `auth.users` no autorizada;
- permitir una sesión obtenida mediante un OTP del proveedor que no pasó por el challenge de negocio;
- introducir un `service-role` o secret key como cliente genérico de requests;
- exponer credenciales privilegiadas al browser;
- debilitar RLS;
- convertir `SUPER_ADMIN` en bypass tenant;
- depender de internals o comportamiento no documentado de Supabase?

La arquitectura debe ser fail-closed y debe poder explicar los fallos parciales entre PostgreSQL, Supabase Auth, Auth Hooks y el proveedor de email.

---

# 5. Decision drivers

1. Cumplimiento literal de RF-004…RF-011.
2. Tres intentos **exactos por emisión**, incluso bajo concurrencia.
3. Invalidación inmediata y autoritativa en resend.
4. Single-use y rechazo de estados terminales.
5. Prevención de bypass mediante superficies públicas de Supabase Auth.
6. Creación de `auth.users` sólo por una intención autorizada.
7. Session establishment mediante primitives oficiales, no internals.
8. Mínimo privilegio.
9. `VerificationChallenge` platform-owned sin reutilizar artificialmente RLS tenant.
10. RLS preservada como frontera primaria para datos tenant-owned.
11. Monolito modular Next.js + Supabase; no microservicios sin necesidad demostrada.
12. Idempotencia y semántica explícita de fallos parciales.
13. Secretos, tokens y PII minimizados y fuera de logs.
14. Reversibilidad razonable.
15. Testabilidad negativa: el diseño debe demostrar no sólo el happy path sino los caminos alternativos.

---

# 6. Requisitos no negociables

Se preservan literalmente:

**RF-004.** El sistema DEBE enviar un código de verificación al correo indicado.  
**RF-005.** Cada código DEBE tener una vigencia de 8 horas desde su emisión.  
**RF-006.** Cada código DEBE admitir como máximo 3 intentos de verificación.  
**RF-007.** El actor autorizado para el alta DEBE poder reenviar el código las veces que sea necesario.  
**RF-008.** Cada reenvío DEBE emitir un código nuevo.  
**RF-009.** Al emitir un nuevo código, el código anterior DEBE quedar inmediatamente invalidado.  
**RF-010.** Cada código nuevo DEBE disponer de sus propios 3 intentos.  
**RF-011.** Un código vencido NO DEBE poder recuperarse ni reutilizarse.

También se preserva como consecuencia necesaria:

```text
challenge consumido
→ no reutilizable
```

Y:

```text
provider abuse/rate limit
!=
business attempt budget
```

---

# 7. Hallazgos oficiales relevantes de Supabase — reverificación 2026-08-28

La corrección de este ADR reevalúa la frontera de sesión exclusivamente contra documentación oficial vigente de Hosted Supabase y sus APIs públicas documentadas. No se utiliza GitHub source, internals de GoTrue ni configuración self-hosted como sustituto de una capacidad Hosted.

## 7.1 Auth Hooks como gate de negocio

La documentación oficial de Auth Hooks confirma que:

- `Custom Access Token Hook` se ejecuta **cada vez que se crea un JWT**;
- el hook corre **antes de emitir el token**;
- recibe `user_id`, `claims` y `authentication_method`;
- `authentication_method` puede distinguir, entre otros, `password`, `otp`, `recovery`, `invite`, `magiclink`, `email/signup`, `token_refresh`, `oauth`, `sso/saml` y `anonymous`;
- un Postgres Hook puede devolver un runtime error por violación de una regla de negocio;
- ese error se propaga desde el hook hacia Supabase Auth y la request Auth termina en error;
- los errores runtime de Postgres Hooks no son retryable por Supabase Auth;
- los hooks poseen timeout explícito y un timeout produce error, no un allow silencioso.

Por tanto, la inferencia anterior:

```text
absence of token_hash / VerificationChallenge.id
→ Custom Access Token Hook insuficiente por definición
```

queda corregida.

La ausencia de correlación per-token sigue siendo relevante para determinadas alternatives, pero el hook **sí puede actuar como deny gate** utilizando una combinación de:

```text
user_id
+
authentication_method
+
estado application-owned autoritativo
```

## 7.2 Plan availability

La tabla oficial vigente clasifica:

```text
Before User Created        → Free, Pro
Custom Access Token        → Free, Pro
Send Email                 → Free, Pro
Password Verification      → Teams, Enterprise
```

La decisión seleccionada en este ADR **NO depende** de `Password Verification Hook`.

No se introduce como requisito implícito un upgrade a Teams/Enterprise.

## 7.3 `Password Verification Hook`

El hook documentado:

- se ejecuta cada vez que un usuario intenta iniciar sesión con password;
- recibe `user_id` y si el password fue válido;
- puede devolver `continue` o `reject`;
- puede indicar `should_logout_user`.

Es una defensa adicional potencial, pero:

```text
Password Verification Hook
!=
requisito de la arquitectura E2
```

porque su disponibilidad Teams/Enterprise no forma parte de la baseline comercial aprobada.

## 7.4 `signInWithPassword`

Supabase documenta `signInWithPassword` como primitive pública soportada para autenticar un usuario existente mediante email + password y obtener una sesión.

E2 utiliza esta primitive **server-side**, con un password técnico no conocido por el usuario ni entregado al browser.

## 7.5 `auth.admin.updateUserById`

Supabase documenta que `auth.admin.updateUserById`:

- es server-only;
- puede modificar directamente el password de un usuario;
- no debe utilizarse exponiendo una credencial privilegiada al browser.

E2 permite esta primitive exclusivamente para:

- provisioning inicial del password técnico cuando corresponda;
- rotación controlada de la credencial técnica.

No se utiliza para el sign-in ordinario.

## 7.6 `auth.admin.createUser`

Supabase documenta `auth.admin.createUser` como primitive administrativa server-only y permite:

- crear usuario con password;
- marcar `email_confirm` cuando el servidor ya posee evidencia suficiente de que el email fue verificado.

Esto permite que, después de un `VerificationChallenge` de negocio consumido, la futura operación de alta cree la identidad Auth sin depender de public signup ni de un provider OTP de Supabase.

Este ADR no implementa esa alta.

## 7.7 `auth.admin.generateLink` y `verifyOtp`

`auth.admin.generateLink` y `verifyOtp` continúan siendo primitives oficiales y forman un bridge técnicamente posible hacia sesión.

Sin embargo, E2 **no las selecciona** como camino ordinario porque el método `magiclink`/`otp` también pertenece a superficies públicas de passwordless Auth y no proporciona una prueba de origen server-only equivalente al password técnico de E2.

## 7.8 `signInWithOtp`, Email OTP y Magic Link

`signInWithOtp` soporta Email OTP/Magic Link.

La baseline de producto no puede delegar en ese provider:

- RF-006 — máximo 3 intentos exactos por emisión;
- RF-009 — invalidación inmediata de la emisión anterior por resend.

Además, para usuarios existentes, una request pública puede crear una credential passwordless que posteriormente intente obtener JWT.

E2 no depende de poder apagar esa primitive: la política de token issuance la rechaza por `authentication_method`.

## 7.9 Configuración Hosted de passwordless

La Management API oficial expone, entre otros:

```text
disable_signup
external_email_enabled
external_anonymous_users_enabled
mailer_otp_exp
mailer_otp_length
rate_limit_otp
rate_limit_verify
```

En la superficie Hosted/Management API revisada **NO se encontró** un campo documentado equivalente a:

```text
magic_link_enabled
```

ni un control granular demostrado para:

```text
disable public Email OTP / Magic Link
while
keep email+password Auth enabled
```

`external_email_enabled` existe, pero la documentación revisada no lo presenta como un switch passwordless-only.

Por tanto:

```text
hosted granular passwordless-disable capability = NOT DEMONSTRATED
```

E2 no depende de esa capacidad.

## 7.10 Signup global

La configuración general oficial documenta:

```text
Allow new users to sign up = disabled
→ only existing users can sign in
```

E2 exige que public signup permanezca deshabilitado.

La creación legítima de un Auth user ocurre, cuando corresponda, mediante la frontera Admin purpose-specific posterior a un enrollment autorizado.

## 7.11 `Before User Created Hook`

El hook:

- corre antes de insertar un usuario nuevo;
- recibe el objeto del usuario, incluido email;
- puede devolver error y bloquear la creación.

Por tanto puede actuar como **user creation gate** adicional frente a una intención/enrollment application-owned.

Pero:

```text
Before User Created Hook
!=
session issuance gate
```

E2 no confunde ambos problemas.

La autoridad primaria contra public user creation continúa siendo:

```text
public signup disabled
+
Admin createUser purpose-specific
```

`Before User Created Hook` es defensa en profundidad cuando se configure.

## 7.12 `Send Email Hook`

El Send Email Hook es Free/Pro y recibe material sensible del email Auth, incluyendo `token` / `token_hash` y `email_action_type`.

E2 no necesita entregar provider OTPs para login. El hook puede utilizarse como defensa adicional para impedir o controlar emails Auth de:

- magic link;
- recovery;
- invite;
- signup;

que no forman parte del contrato funcional seleccionado.

No se utiliza como session authority.

## 7.13 Password recovery

`resetPasswordForEmail` es una primitive pública oficial y el flujo de recovery puede conducir a una sesión/evento `PASSWORD_RECOVERY` y posteriormente a `updateUser({ password })`.

E2 exige:

```text
authentication_method = recovery
→ DENY
```

en el token issuance gate.

Por tanto el password recovery de Supabase no se convierte en una vía paralela para crear una sesión.

El producto no posee un password UX aprobado que requiera mantener recovery.

## 7.14 Cambio de password por usuario autenticado

Supabase documenta `auth.updateUser({ password })` para usuarios autenticados y también documenta una configuración Hosted:

```text
Require current password when changing password
```

que exige validar el password actual antes de aceptar el cambio.

E2 exige activar esa protección porque el usuario **no conoce** el password técnico.

Consecuencia:

```text
authenticated user
+
no technical password
→ cannot replace bridge password
```

La Management API revisada no expone de forma inequívoca este toggle como un campo específico; por tanto debe tratarse como una configuración Hosted oficial que requerirá verificación Cloud explícita y una estrategia de drift control antes de implementación.

## 7.15 Sesiones y cambios de password

Supabase documenta que una sesión puede terminar cuando el usuario cambia su password o realiza una acción sensible.

Por ello E2 **NO rota el password técnico en cada login**.

La credencial se provisiona una vez y sólo se cambia por rotación explícita o reparación autorizada.

La rotación de la credencial técnica debe considerarse una operación con impacto potencial sobre sesiones existentes.

## 7.16 Token refresh

Supabase documenta que una sesión contiene access token + refresh token y que el refresh token permite obtener un nuevo par de tokens.

El Custom Access Token Hook identifica:

```text
authentication_method = token_refresh
```

Por tanto E2 separa explícitamente:

```text
initial session establishment
!=
token refresh
```

Una sesión ya establecida legítimamente puede refrescarse sin resolver otro `VerificationChallenge`.

Esto no modifica ADR-0003:

```text
refresh/session residual
!=
current tenant authorization
```

La autorización vigente continúa resolviéndose contra estado autoritativo y RLS.

## 7.17 API keys / secret keys

Las secret keys actuales de Supabase son backend-only y elevadas; el rol asociado puede bypass RLS.

E2 permite una credencial elevada únicamente dentro de una frontera Auth Admin purpose-specific para:

- `createUser` cuando corresponda;
- `updateUserById` para provision/rotation del password técnico.

No se autoriza:

```text
generic secret-key Supabase client for ordinary requests
```

---

# 8. Alternativa A — Provider-owned OTP

Se conserva la evaluación anterior.

## 8.1 Ocho horas

El provider permite configurar expiración de Email OTP. Ocho horas no son imposibles técnicamente.

## 8.2 Tres intentos exactos

Los rate limits de Auth son antiabuso y no representan:

```text
3 attempts per VerificationChallenge emission
```

No existe un Email OTP Verification Attempt Hook equivalente que permita hacer del provider el contador autoritativo de RF-006.

## 8.3 Resend / invalidación

No existe evidencia oficial suficiente de que un nuevo passwordless OTP represente contractual y demostrablemente RF-009 para la emisión application-owned.

## 8.4 Resultado

```text
A = REJECTED
```

---

# 9. Alternativa B — Application-owned challenge sin bridge

Se conserva como fundamento necesario del lifecycle.

La aplicación puede hacer autoritativos:

- generación segura del code;
- verifier no plaintext;
- `issued_at` / expiry de 8h;
- attempt counter exacto;
- terminalidad;
- resend;
- invalidación inmediata de la emisión anterior;
- single-use;
- concurrencia.

Pero B aislada no crea access/refresh tokens de Supabase.

```text
B = NECESSARY BUT INCOMPLETE
```

---

# 10. Alternativa C — Admin `generateLink` / provider bridge original

Composición:

```text
application challenge consumed
→ auth.admin.generateLink
→ provider token_hash
→ verifyOtp
→ session
```

Las primitives son oficiales.

Sin embargo `magiclink`/`otp` continúan siendo métodos también alcanzables mediante superficies públicas de Auth para usuarios existentes.

Sin un gate adicional, C no impide direct Auth bypass.

```text
C = REJECTED AS STANDALONE BRIDGE
```

---

# 11. Alternativa D — Custom Access Token Hook original

La revisión anterior fue demasiado restrictiva al asumir que la falta de `token_hash` hacía insuficiente al hook por definición.

La corrección establece:

```text
Custom Access Token Hook CAN deny JWT issuance
```

porque un runtime error del hook se propaga a Auth.

Sin embargo D, usada sin un proof server-only adicional, sólo puede preguntar:

```text
user_id
+
authentication_method
+
application state
```

Si el método permitido también puede ser satisfecho por una credential pública alternativa, aparece una carrera de confused deputy.

```text
D = USEFUL GATE, NOT SUFFICIENT ALONE
```

---

# 12. Alternativa E1 — Application-owned challenge + one-time session grant + Custom Access Token Hook + Admin provider bridge

## 12.1 Composición evaluada

```text
1. application-owned VerificationChallenge
2. DB aplica attempts / expiry / resend / invalidation / single-use
3. challenge válido se consume
4. se crea session grant application-owned
5. server-only Admin bridge obtiene provider token
6. verifyOtp intenta crear sesión
7. Custom Access Token Hook recibe user_id + authentication_method
8. hook exige grant vigente y método permitido
9. hook consume grant atómicamente
10. Supabase emite JWT/session
```

## 12.2 El hook sí puede negar

E1 supera una objeción de la versión anterior:

```text
hook cannot deny token issuance = FALSE
```

Un runtime error es suficiente para hacer fallar la request Auth.

## 12.3 Grant application-owned

Conceptualmente:

```text
session grant
=
evidencia server-side temporal
creada sólo después de consumir
un VerificationChallenge válido
```

Debe ser:

- purpose-specific;
- short-lived;
- single-use;
- fail-closed;
- no accesible al browser como authority;
- bound al Auth user / enrollment context;
- idempotent/reconcilable;
- consumido atómicamente.

## 12.4 Política de `authentication_method`

Una hipótesis E1 podría permitir únicamente el método del bridge y `token_refresh`, rechazando los demás.

El problema es que un bridge basado en `generateLink` / `verifyOtp` usa métodos como `magiclink`/`otp` que también pertenecen a flows passwordless públicos.

El hook no recibe, de forma documentada:

- `token_hash`;
- origen Admin vs public;
- `VerificationChallenge.id`;
- `session_grant.id` aportado por el provider proof.

## 12.5 Confused deputy

Durante la corta ventana en que el grant está activo:

```text
grant(user X, method magiclink/otp)
+
provider credential alternativo válido para X
→ same hook-visible user_id + same method
```

El hook no puede demostrar cuál credential es la generada por el bridge interno.

Por tanto otra credential del mismo usuario/método puede competir por el grant.

La existencia del grant sí permite demostrar:

```text
no active grant
→ no initial JWT
```

pero no permite demostrar:

```text
active grant
→ only the intended internal provider credential can consume it
```

## 12.6 `token_refresh`

`token_refresh` puede separarse del initial sign-in y no necesita un nuevo grant.

Esto no corrige la carrera inicial.

## 12.7 Resultado

```text
E1 = REJECTED
```

Razón exacta:

```text
session grant + method gate
prevents session without grant,
but does not bind the grant to the intended provider credential
for a public-equivalent magiclink/otp method.
```

---

# 13. Alternativa E2 — Application-owned challenge + one-time session grant + server-only technical password bridge

## 13.1 Decisión seleccionada

E2 añade una propiedad que E1 no posee:

> **El proof del método Auth permitido es un password técnico de alta entropía cuya capacidad de producción/lectura pertenece exclusivamente al servidor de aplicación y que nunca forma parte del UX ni del browser.**

Composición conceptual:

```text
VerificationChallenge application-owned
→ challenge consumed
→ session grant single-use
→ server-only technical password proof
→ signInWithPassword
→ Custom Access Token Hook gate
→ Supabase session
```

## 13.2 Contrato funcional preservado

Para el usuario:

```text
email + código
```

No existe:

```text
password UI
password chosen by user
password recovery UX
password as product credential
```

El password es exclusivamente una **bridge credential técnica del provider**.

## 13.3 Ownership del business challenge secret

```text
VerificationChallenge secret authority = application
```

El code de negocio:

- no se persiste en plaintext;
- se verifica mediante un verifier keyed;
- mantiene attempts/expiry/resend/consume en PostgreSQL autoritativo.

La primitive candidata preservada es un verifier keyed equivalente a:

```text
HMAC-SHA-256(
  dedicated_challenge_key,
  domain_separator || challenge_id || normalized_code
)
```

La futura implementación deberá fijar key versioning, rotation y constant-time comparison.

## 13.4 Ownership del technical password

```text
technical password authority = application server
```

Debe ser:

- de alta entropía criptográfica;
- distinto del challenge code;
- distinto de Supabase secret key;
- no conocido por el usuario;
- no enviado al browser;
- no logueado;
- no incluido en URLs;
- no almacenado en plaintext de aplicación.

La dirección preferida es derivarlo de forma reproducible mediante una key server-only dedicada y versionada, ligada al `auth_user_id`, o utilizar protección criptográfica equivalente que mantenga el mismo contrato de no-exposición.

El ADR no define almacenamiento físico.

## 13.5 Provisioning

### Usuario nuevo

Después de que exista un enrollment autorizado y el email haya sido demostrado por el `VerificationChallenge`:

```text
purpose-specific Auth Admin boundary
→ auth.admin.createUser
→ email_confirm = true
→ technical password provisioned
```

La creación no produce por sí misma tenant authorization.

### Usuario existente sin credencial técnica

Una operación de provisioning/repair posterior a challenge consumido puede utilizar:

```text
auth.admin.updateUserById(...password...)
```

Esta no es la ruta ordinaria de login.

## 13.6 Public signup

E2 exige:

```text
public signup = disabled
```

Esto impide que un caller público cree libremente un `auth.users` con un password que controle.

La creación autorizada se mantiene en la frontera Admin purpose-specific.

## 13.7 User password mutation

Para preservar:

```text
technical password remains server-only
```

E2 exige la configuración Hosted documentada:

```text
Require current password when changing password = enabled
```

Como el usuario no conoce el technical password, una sesión Auth existente no puede sustituirlo por un password elegido por el usuario.

Si esta configuración no puede verificarse en el proyecto Hosted real antes de implementación:

```text
IMPLEMENTATION BLOCKER
```

No se sustituye por timing ni por ausencia de UI.

## 13.8 Sign-in bridge

Después del consumo del challenge:

```text
1. DB reconoce challenge success exactly-once
2. DB crea/activa one-time session grant para Auth user X
3. server deriva/obtiene technical password de X
4. server usa caller-scoped Supabase Auth client con publishable key
5. server ejecuta signInWithPassword(email, technical_password)
6. provider valida password
7. Custom Access Token Hook corre antes del JWT
8. hook recibe user_id=X, authentication_method=password
9. hook consume exactamente un grant válido para X + password-session purpose
10. sólo entonces Auth emite JWT/session
11. access/refresh tokens se integran con la boundary SSR de TASK-011
```

La secret key de Admin **no** se usa para el sign-in ordinario.

## 13.9 Por qué la falta de token_hash ya no bloquea E2

En E2 el elemento que discrimina el bridge no es un provider token compartido con una superficie pública.

Es:

```text
valid technical password
AND
active one-time session grant
AND
authentication_method = password
```

Un caller público conoce:

- email;
- endpoint público de password sign-in.

Pero no conoce el technical password.

Si además no existe grant:

- incluso la posesión del password técnico por compromiso no debe bastar para obtener JWT.

Si existe grant:

- otro actor no puede consumirlo mediante OTP/recovery/magiclink porque esos métodos son denied;
- otro actor no puede consumirlo mediante password salvo que también haya comprometido la bridge credential server-only.

Por tanto la ausencia de `token_hash` no impide correlación suficiente en E2: la correlación la aporta la combinación **server-held password proof + grant + method**.

## 13.10 Gate de `authentication_method`

Política arquitectónica:

```text
authentication_method = password
→ require active one-time session grant
→ atomically consume grant
→ allow

 authentication_method = token_refresh
→ allow existing legitimate session lifecycle
→ no new VerificationChallenge required

 authentication_method = anything else
→ deny by default
```

La implementación futura debe tratar explícitamente como denied, mientras no exista otra decisión aprobada:

- `otp`;
- `recovery`;
- `magiclink`;
- `invite`;
- `email/signup`;
- `oauth`;
- `sso/saml`;
- `anonymous`;
- unknown/future initial-auth method.

No se utiliza esta tabla como tenant authorization.

## 13.11 Token refresh

Un refresh token sólo existe después de una sesión ya creada.

Por ello:

```text
token_refresh
!=
new initial proof
```

E2 permite refresh sin session grant.

La revocación de membership continúa resolviéndose mediante estado autoritativo/RLS conforme ADR-0003/TASK-012.

Este ADR no convierte el refresh en autorización.

## 13.12 Recovery

```text
authentication_method = recovery
→ deny
```

El public password recovery de Supabase no puede producir una sesión alternativa.

Además, cuando se adopte Send Email Hook, el producto puede rechazar/suprimir los Auth emails de recovery que no forman parte del UX aprobado.

## 13.13 OTP / Magic Link

```text
authentication_method = otp | magiclink
→ deny
```

Aunque Hosted Supabase no exponga un switch granular demostrado para apagar passwordless manteniendo password, el provider no puede emitir el JWT de esos métodos mientras el gate esté activo.

## 13.14 Invite / signup

Public signup está deshabilitado.

Además:

```text
invite | email/signup
→ deny as initial session method
```

La creación Admin autorizada no necesita producir sesión automáticamente.

## 13.15 OAuth / anonymous / identity linking

No son capacidades del MVP Auth actual.

E2 exige mantener providers no utilizados deshabilitados cuando exista configuración Hosted oficial y, como frontera final:

```text
all non-selected initial JWT methods
→ default deny
```

`identity linking` no se convierte en una vía de sesión: cualquier sign-in posterior del provider enlazado volvería a pasar por el token gate y sería rechazado por método no aprobado.

## 13.16 Race de session grant

Dos `signInWithPassword` simultáneos con proof válido:

```text
one grant
→ at most one successful consume
```

El consumo se realiza dentro de una **Postgres Function Custom Access Token Hook** de forma atómica. E2 selecciona la variante Postgres —no HTTP— para mantener el session grant y su consumo dentro de la base autoritativa y evitar introducir un webhook secret/hop adicional en la decisión central.

El segundo intento observa grant consumido/no disponible y Auth termina con error.

## 13.17 Wrong pathway + grant

```text
grant exists
+
wrong auth pathway
→ DENY
```

porque el hook distingue `authentication_method`.

```text
grant exists
+
password method
+
wrong actor without technical password
→ provider password verification FAIL
```

Por tanto un actor distinto no puede consumir legítimamente el grant sin comprometer además la bridge credential server-only.

## 13.18 Multiple devices / existing sessions

E2 no rota el technical password en cada login.

Por defecto Supabase permite múltiples sesiones activas.

Las sesiones existentes no necesitan ser terminadas para cada code login.

La rotación excepcional del technical password es una acción sensible que puede afectar sesiones y debe tratarse como operación separada y deliberada.

## 13.19 ¿Convierte esto el producto en password Auth?

No desde el contrato funcional:

```text
user-facing credential = email + VerificationChallenge code
provider bridge credential = technical password server-only
```

La arquitectura utiliza password Auth como **transport primitive interna de session establishment**, no como credencial de producto.

No debe aparecer:

- password form;
- password reset UX;
- password field en perfil;
- password documentado al usuario.

## 13.20 Password Verification Hook

E2 **NO lo necesita** para su propiedad de seguridad central.

En Teams/Enterprise podría añadirse como defense in depth para rechazar password attempts antes del Custom Access Token Hook, pero:

- no sustituye el session grant;
- no sustituye el technical password;
- no debe convertirse en requisito de Free/Pro;
- no resuelve por sí solo confused deputy.

## 13.21 Account lifecycle

El technical password pertenece al bridge, no al estado de membership.

Por tanto:

```text
membership disabled / revoked
→ authorization tenant denied by current authoritative state / RLS
→ technical password is not tenant authorization
```

Una reintegración futura no requiere inventar otra identidad Auth sólo por haber estado deshabilitada. La identidad y su credential técnica pueden conservarse, mientras la autorización vigente continúa gobernada por ADR-0003.

La eliminación/destrucción del technical password no se utiliza como mecanismo contractual de revocación; RF-019 y provider-side session termination permanecen un problema de revocación separado conforme al canon.

## 13.22 Key rotation y compromise

La key que derive/proteja technical passwords debe ser:

- dedicada a este propósito;
- versionada;
- rotatable sin mezclarla con challenge key ni Supabase secret key;
- server-only;
- ausente de logs y repositorio.

Una rotación puede exigir actualizar el password Auth de los usuarios afectados y, conforme al lifecycle documentado de sesiones, puede producir terminación de sesiones. Por ello no es una operación de login ni una acción automática frecuente.

El compromiso de la technical-password key incrementa severamente el riesgo, pero **no basta por sí solo** para obtener un JWT inicial: el Custom Access Token gate sigue exigiendo un session grant activo. El compromiso conjunto de key + autoridad capaz de crear/manipular grants se considera compromiso del trust boundary.

## 13.23 Resultado

```text
E2 = SELECTED
```

E2 satisface el contrato siempre que se preserven conjuntamente:

```text
application-owned challenge
+
one-time session grant
+
server-only technical password
+
public signup disabled
+
user password mutation requires current technical password
+
Custom Access Token Hook default-deny gate
+
token_refresh separated from initial sign-in
+
Admin Auth boundary narrowly scoped
```

---

# 14. Session grant

`SessionGrant` se adopta como concepto arquitectónico técnico, no como nuevo requisito funcional de usuario.

## 14.1 Definición

```text
session grant
=
server-side evidence that exactly one
initial Supabase session issuance attempt
is authorized after a VerificationChallenge was consumed
```

## 14.2 Invariantes

Debe ser:

- creado únicamente después de consumo válido de challenge;
- short-lived;
- single-use;
- purpose-specific;
- bound al Auth user / enrollment identity suficiente;
- bound al método `password` para initial session;
- no enumerable por browser;
- no bearer authority del frontend;
- fail-closed;
- idempotent/reconcilable;
- consumido atómicamente por el token issuance gate.

## 14.3 Dos intentos simultáneos

```text
same grant
+
two valid password auth attempts
→ one may consume
→ second denied
```

## 14.4 Replay

```text
consumed grant
→ cannot issue another initial session
```

## 14.5 Leakage

El grant no debe ser un secreto entregado al browser.

Su filtración como ID no debe bastar para crear sesión porque además se requiere:

- Auth user correcto;
- `authentication_method=password`;
- technical password correcto;
- estado vigente del grant.

---

# 15. Auth user creation

## 15.1 Autoridad

```text
automatic unauthorized auth.users creation = PROHIBIDA
```

## 15.2 Public signup

```text
disable_signup = true
```

es una precondición E2.

## 15.3 Creación autorizada

La futura operación de alta, después del business proof, utiliza una frontera Admin purpose-specific para `createUser`.

No se habilita un endpoint browser Admin.

## 15.4 Confirmación de email

El `VerificationChallenge` application-owned es la prueba de posesión del email aprobada por producto.

Por ello la futura operación puede confirmar el email mediante Admin sólo después del consume válido.

## 15.5 Before User Created

Puede exigir un enrollment application-owned cuando se configure y es una defensa en profundidad de creación.

No sustituye:

- public signup disabled;
- Admin boundary;
- session grant;
- Custom Access Token gate.

---

# 16. Privileged boundary

Se preserva la frontera previa y se concreta para E2.

## 16.1 Purpose

Exclusivamente:

```text
provisionar / reparar / rotar
la identidad Auth y technical bridge credential
para una intención de alta autorizada
```

## 16.2 Allowed Auth operations

Lista cerrada:

- `auth.admin.createUser` cuando el user no existe y el enrollment está autorizado;
- `auth.admin.updateUserById` sólo para provisioning/rotation/repair de la technical password y confirmación explícitamente aprobada.

El Custom Access Token gate seleccionado es una **Postgres Function Hook**, no un HTTP Hook.

`auth.admin.generateLink` no pertenece al camino E2 ordinario.

## 16.3 Allowed callers

Sólo casos de uso server-side del módulo Identity & Auth que ya hayan demostrado:

- business intent válida;
- actor autorizado cuando aplique;
- challenge consumido cuando corresponda;
- identidad/email correlacionados;
- idempotency context.

## 16.4 Credential

Una secret key backend-only separadamente gestionada.

Nunca:

- browser;
- PWA;
- response;
- logs;
- URLs;
- source control.

## 16.5 Prohibiciones

```text
generic Supabase admin client reusable from arbitrary modules = PROHIBIDO
```

```text
service-role / secret key as ordinary request client = PROHIBIDO
```

```text
admin credential used for normal tenant reads/writes = PROHIBIDO
```

## 16.6 Sign-in client

El sign-in E2 debe utilizar una frontera separada de Auth con publishable key/caller-scoped semantics; no se reutiliza el Admin client para obtener la sesión del usuario.

## 16.7 Database scope

La privileged Auth boundary no obtiene permiso genérico para tenant data.

El Custom Access Token Postgres Hook recibe únicamente los grants necesarios para consultar/consumir el session grant platform-owned.

Supabase recomienda grants explícitos a `supabase_auth_admin` y evitar `security definer` amplio.

---

# 17. RLS / Data API

`VerificationChallenge` y `SessionGrant` son estado platform-owned de Identity & Auth.

No se convierten en tenant-owned para reutilizar RLS tenant.

Conceptualmente:

- no general SELECT desde browser;
- no general INSERT/UPDATE/DELETE para `anon`;
- no general writes para `authenticated`;
- no enumeration por email;
- mutation boundary purpose-specific;
- hook access mínimo mediante `supabase_auth_admin` sólo al estado necesario;
- RLS tenant existente no cambia.

Este ADR no define tabla, columna, policy, function ni SQL.

---

# 18. Bypass prevention

## 18.1 Direct password sign-in

```text
no grant
→ Custom Access Token Hook runtime error
→ no JWT/session
```

Incluso durante un grant, el caller requiere el technical password server-only.

## 18.2 Direct `signInWithOtp`

Puede iniciar un flow passwordless para un user existente, pero:

```text
authentication_method = otp / magiclink
→ deny
```

No puede producir sesión.

## 18.3 Direct `verifyOtp`

El provider puede reconocer un OTP válido, pero el JWT/session issuance posterior cruza el Custom Access Token gate y se rechaza por método.

## 18.4 Recovery

```text
recovery
→ deny
```

## 18.5 Signup / invite

Public signup está deshabilitado y los métodos de sesión `email/signup`/`invite` quedan denied.

## 18.6 OAuth / anonymous / nuevos métodos

Default deny.

No se acepta un nuevo método de initial authentication por aparecer en Supabase en el futuro.

Su incorporación requeriría nueva revisión arquitectónica.

## 18.7 Admin endpoints

No son públicos y requieren secret key server-only.

El browser nunca recibe la credencial.

## 18.8 Resultado

Bajo E2 puede demostrarse:

```text
initial Supabase session
→ either password method + consumed session grant
→ or DENY
```

Y:

```text
session grant
→ exists only after consumed VerificationChallenge
```

Por transitividad:

```text
initial session without consumed VerificationChallenge = impossible
```

exceptuando el compromiso de una frontera privilegiada/secret material, que constituye compromiso del trust boundary y no una vía soportada del producto.

---

# 19. Threat model actualizado

| Threat | Impact | Control E2 | Remaining risk |
|---|---|---|---|
| Brute force del business code | Account takeover | 3 attempts exactos en DB + keyed verifier + antiabuse adicional | Bajo si key/DB boundary preservada |
| Email enumeration | PII leakage | respuestas uniformes; no challenge listing; reset APIs no usados como authority | Timing/operational leakage debe probarse |
| Challenge enumeration | DoS / targeting | IDs no authority; no browser SELECT | DoS residual si endpoints no rate-limited |
| Replay de code | Account takeover | single-use challenge | Bajo |
| Expired code | Unauthorized login | DB authoritative expiry 8h | Bajo |
| Fourth attempt | RF-006 bypass | atomic budget; fourth denied before evaluation | Bajo |
| Concurrent attempts | double evaluation | serialized/atomic transition | Bajo |
| Resend race | two current emissions | atomic current-emission transition | Bajo |
| Verify vs resend | old code accepted after resend | serializable consume/invalidate | Bajo |
| Previous code after resend | replay | immediate DB invalidation | Bajo |
| Double consume | multiple grants | challenge consume exactly-once | Bajo |
| Attacker calls public password sign-in | session bypass | technical password unknown + hook requires active grant | Credential compromise |
| Attacker calls public OTP | session bypass | `otp`/`magiclink` denied by token gate | Email spam/DoS remains |
| Attacker calls recovery | password/session takeover | `recovery` denied; optional Send Email Hook suppression | Email abuse remains |
| Authenticated user changes own password | gains public password credential | require current password; user lacks technical password | Config drift |
| Race for a session grant | wrong session issuance | atomic single-use consume | First valid server proof wins |
| Direct provider credential consumes grant first | confused deputy | only `password` eligible; technical password server-only | Fails only if bridge credential compromised |
| Grant replay | second session | consumed grant denied | Low |
| Grant leakage | session creation | grant is not bearer; technical password also required | Metadata leakage/DoS |
| Bridge credential compromise | session impersonation during grant | dedicated key, rotation, grant still required | High; trust-boundary compromise |
| Bridge credential rotation | availability/session impact | versioned rotation, explicit operation | Supabase password change may terminate sessions |
| Access/refresh token theft | session hijack | TASK-011 SSR handling, no token logs, refresh-token rotation, current DB/RLS authz | Existing bearer capability until provider/session controls take effect |
| Hook secret theft | forged hook traffic | E2 selects Postgres Custom Access Token Hook, so no HTTP hook secret is required for the core gate | N/A to selected core; relevant only if implementation changes to HTTP |
| Auth Admin credential compromise | project compromise | purpose-specific adapter; rotation; no browser | Very high inherent blast radius |
| Hook unavailable | auth outage | token issuance fails closed | Availability |
| Hook timeout | auth outage/ambiguous bridge | Auth error; reconcile DB; no silent allow | Availability / user retries |
| Token refresh after grant consumed | unnecessary rechallenge | `token_refresh` explicitly separated/allowed | Hook outage affects refresh availability |
| Plan downgrade / hook unavailable | login outage | E2 requires Custom Access Token supported on Free/Pro; startup/deploy gate verifies capability | Availability/configuration |
| Password Verification Hook unavailable | none to core E2 | not required; optional only Teams/Enterprise | No security dependency |
| Passwordless granular disable absent | OTP endpoint remains callable | method default-deny at JWT gate | Spam/rate-limit surface |
| Logs/telemetry leakage | secret theft | deny-list technical password/code/tokens/grants/keys | Operational discipline |
| DB read compromise | offline business-code attack | keyed challenge verifier; grant not bearer | Metadata exposed |
| Partial Auth/DB failure | inconsistent bridge | fail-closed state machine; terminal grants; fresh challenge on ambiguity | User friction |
| Idempotency collision | wrong grant reuse | high entropy operation identity + immutable binding | Implementation must test |
| Privilege escalation | admin client reused | import boundary + allowed operation list | Code review required |
| Tenant bypass | cross-tenant access | session != authz; TASK-012 + RLS | Preserved |
| SUPER_ADMIN misuse | universal access | global actor does not infer membership | Preserved |

---

# 20. Failure model actualizado

## 20.1 DB success + email provider fail

La emisión ya creada permanece current y la anterior permanece invalidada.

No reactivar emisión previa.

Retry técnico de delivery no crea un nuevo business resend.

## 20.2 Email provider success + DB fail

El orden obligatorio es:

```text
commit challenge emission
→ then deliver code
```

No enviar un code que no tenga emisión autoritativa.

## 20.3 Concurrent verify

Attempt budget + consume se aplican atómicamente.

Máximo un success.

## 20.4 Concurrent resend

Sólo una emisión queda current conforme al orden autoritativo de transición.

Entrega tardía de una emisión ya invalidada no la revive.

## 20.5 Verify vs resend

La transición autoritativa define el ganador.

No existe ventana donde A pueda ser consumida después de que B la invalidó.

## 20.6 Challenge consume success + session grant creation fail

Challenge permanece consumido.

No reactivarlo.

Fail closed.

La recuperación requiere una nueva intención controlada; no reinterpretar el mismo code como reusable.

## 20.7 Session grant created + Auth sign-in fail before hook

El grant puede permanecer available hasta su expiry/reconciliation si existe certeza de que no fue consumido.

Un retry técnico del mismo bridge puede reutilizar el mismo logical operation identity.

No crear múltiples grants sin reconciliación.

## 20.8 Hook consumes grant + Auth success

Happy path:

```text
grant consumed
→ session returned
→ SSR cookies/session propagated
```

## 20.9 Hook consumes grant + Auth response lost / downstream fail

El grant **no** se reactiva.

Si la aplicación no puede demostrar con certeza que los tokens fueron entregados al browser:

```text
fail closed
```

Una nueva interacción de usuario puede requerir un nuevo challenge/resend.

Un posible provider session huérfano cuyos bearer tokens nunca fueron entregados no convierte el challenge en reusable.

## 20.10 Hook timeout

Supabase devuelve error.

La aplicación consulta/reconcilia el estado autoritativo del grant.

Si el estado no es inequívoco:

```text
DENY + fresh flow
```

No asumir `timeout = no effect`.

## 20.11 Hook retry

Postgres runtime errors no son retryados automáticamente por Auth.

Retries del caller conservan la misma logical operation identity y nunca resurrectan grant consumido.

## 20.12 Admin create/update success + application DB fail

La operación de provisioning debe estar precedida por una intención application-owned durable e idempotente.

Si Auth cambia y el acknowledgement de aplicación se pierde, la reconciliación usa la identidad Auth autoritativa; no repetir ciegamente user creation/password mutation.

## 20.13 Admin failure after challenge consume

Challenge sigue consumido.

No se devuelve code a estado active.

Puede requerirse nueva emisión si el flujo no puede reconciliarse con seguridad.

## 20.14 Token refresh

No consume session grant.

Un refresh válido pertenece a una sesión ya establecida.

Si el hook falla/timeout durante refresh, el refresh falla; no se convierte en login alternativo.

## 20.15 Password rotation failure

La rotación es una operación administrativa separada.

No debe ejecutarse como side effect silencioso de cada login.

Un failure de rotation no habilita fallback a password elegido por usuario ni passwordless.

---

# 21. Security Decision

| Área | Decisión |
|---|---|
| Business challenge authority | `application / PostgreSQL authoritative` |
| Business challenge storage | verifier keyed; no plaintext |
| 8h / attempts / resend / single-use | application/DB, no provider defaults |
| Session grant | application-owned, short-lived, single-use, server-only, atomic consume |
| Initial Auth method | `password` exclusivamente como technical bridge |
| Technical password | alta entropía, server-only, no UX, no browser, no plaintext app storage |
| User password mutation | current technical password required; user no lo conoce |
| Token issuance gate | **Postgres Function** `Custom Access Token Hook`, default deny initial methods, atomic grant consume |
| Token refresh | permitido como lifecycle de sesión existente; no nuevo challenge |
| Public signup | disabled |
| Auth user creation | Admin purpose-specific después de enrollment autorizado |
| Before User Created | defense in depth de creación, no session gate |
| Send Email Hook | optional defense in depth; no session authority |
| Password Verification Hook | optional Teams/Enterprise; not required |
| Passwordless Hosted disable | granular switch not demonstrated; no dependency |
| Admin privilege | narrow `createUser` / `updateUserById`; no generic client |
| RLS | tenant RLS unchanged; platform auth state not exposed generally |
| Session authorization | Auth session still not tenant authorization |
| Failure policy | fail closed; no terminal state reactivation |

---

# 22. Decision

Después de la investigación adicional requerida por el Revisor Central:

```text
ADR-0019 status = ACCEPTED

ADR-0019 decision =
E2 — APPLICATION-OWNED VERIFICATION CHALLENGE
+ ONE-TIME SESSION GRANT
+ SERVER-ONLY TECHNICAL PASSWORD BRIDGE
+ CUSTOM ACCESS TOKEN HOOK GATE

ADR-0019 DRAFT = PASS
```

Se marca `ACCEPTED` exclusivamente después de la aprobación humana formal; esta aceptación no autoriza implementación.

## 22.1 Razón principal

E2 separa tres proofs diferentes:

```text
business proof
= VerificationChallenge code

provider proof
= technical password server-only

session authorization proof
= one-time application SessionGrant
```

Supabase Auth sólo emite el JWT inicial cuando:

```text
provider password valid
AND
authentication_method = password
AND
active session grant exists
AND
grant atomic consume succeeds
```

El browser sólo conoce:

```text
email + business code
```

No conoce el provider bridge credential.

## 22.2 Por qué E1 no fue seleccionada

E1 demuestra que el hook sí puede negar, pero no demuestra que un `magiclink`/`otp` concreto sea el generado por el bridge interno.

E2 elimina esa ambigüedad mediante un proof server-only distinto de cualquier credential passwordless pública.

## 22.3 Dependencias no negociables de E2

E2 deja de ser válida si cualquiera de estas propiedades no puede demostrarse en el entorno real:

1. Custom Access Token Hook corre antes de todo JWT inicial relevante;
2. runtime error del hook impide emisión de JWT;
3. `authentication_method=password` se observa para `signInWithPassword`;
4. `token_refresh` es distinguible;
5. session grant puede consumirse atómicamente;
6. public signup puede permanecer disabled;
7. technical password puede permanecer fuera del browser;
8. user password changes pueden exigir current technical password;
9. Admin Auth credential puede encapsularse sin convertirse en client genérico;
10. direct OTP/recovery/magiclink methods son rejected por el gate.

Una contradicción futura en cualquiera de estas propiedades:

```text
IMPLEMENTATION = BLOCKER
```

No sustituirla por comportamiento observado no documentado.

---

# 23. Consequences

## 23.1 Positivas

- RF-004…RF-011 permanecen exactas.
- El provider no es autoridad de attempts/resend.
- No se necesita per-token correlation del OTP provider.
- Direct passwordless/recovery/OAuth Auth queda fail-closed en token issuance.
- Password Verification Hook Teams/Enterprise no es requisito.
- No se exige microservicio ni IdP externo.
- La sesión final sigue siendo Supabase Auth nativa.
- TASK-011 puede recibir la session resultante sin convertirse en authz.
- TASK-012/RLS conservan autoridad tenant actual.

## 23.2 Negativas / tradeoffs

- Se introduce una technical password credential que el producto no muestra al usuario.
- Existe una key de aplicación adicional que proteger/rotar.
- Se requiere un Custom Access Token Hook como componente crítico de disponibilidad Auth.
- Se requiere una frontera Auth Admin privilegiada para create/provision/rotation.
- El hosted granular passwordless-disable no está demostrado; endpoints passwordless pueden seguir siendo invocables aunque sus JWTs sean denied.
- Password recovery de Supabase deja de ser una capacidad utilizable mientras el producto no apruebe un flow específico.
- Una rotación del technical password puede impactar sesiones existentes.
- La configuración “Require current password” es security-critical y debe controlarse contra drift.

## 23.3 Plan dependency

La decisión central depende de `Custom Access Token Hook`, documentado en Free/Pro.

No depende de Teams/Enterprise.

`Password Verification Hook` queda optional.

## 23.4 Disponibilidad

Un outage/timeout del hook bloquea initial JWT issuance y puede bloquear refresh.

Es un fail-closed correcto pero aumenta la dependencia operativa del Auth path sobre el hook/DB.

---

# 24. Impacto documental

No se modifica ningún documento en esta entrega.

Tras la **aceptación humana** de ADR-0019 deberán revisarse/actualizarse:

| Documento | Estado | Motivo |
|---|---|---|
| `docs/product/02-domain-model.md` | `NO UPDATE REQUIRED` | `VerificationChallenge` ya es platform-owned. `SessionGrant` es concepto técnico de Auth boundary, no requisito funcional de producto. |
| `docs/product/03-permissions-rls-strategy.md` | `UPDATE REQUIRED` | Debe registrar la excepción narrowly scoped de Auth Hook / `supabase_auth_admin` / Auth Admin sin convertirla en bypass tenant. |
| `docs/product/10-architecture-decisions-records.md` | `UPDATE REQUIRED` | Debe registrar ADR-0019 y su estado `ACCEPTED`. |
| `docs/product/11-phase-1-scope-entry-gate.md` | `UPDATE REQUIRED` sólo si contiene referencia activa stale | Sincronizar el estado arquitectónico/Fase 2, sin declarar implementación. |
| `TASK-013-verification-challenge-foundation.md` | `UPDATE REQUIRED` | Debe consumir E2, concretar foundation física y volver a revisión antes de implementar. |

La decisión `ACCEPTED` actual **no autoriza** esas modificaciones en esta entrega.

---

# 25. Impacto sobre TASK-013

Aunque ADR-0019 quede `ACCEPTED` y el draft sea `PASS`:

```text
TASK-013 sigue bloqueada = SÍ
TASK-013 implementación autorizada = NO
```

Motivo:

```text
ADR-0019 aprobación documental = COMPLETADA
ADR-0019 canonicalización = PENDIENTE
ADR-0019 incorporación Git = PENDIENTE
sincronización documental requerida = PENDIENTE
revisión/corrección de TASK-013 = PENDIENTE
nueva aprobación de TASK-013 = PENDIENTE
```

Sólo después de completar la canonicalización, incorporación Git, sincronización documental requerida, revisión/corrección de TASK-013 y nueva aprobación de TASK-013 podrá autorizarse una implementación de TASK-013.

Una futura TASK-013 deberá poder especificar, sin reabrir arquitectura:

- challenge verifier;
- attempts/expiry/resend/consume;
- session-grant foundation;
- atomic transitions;
- Custom Access Token Hook boundary;
- mínimos grants a `supabase_auth_admin`;
- non-browser Data API surface;
- tests de bypass;
- configuración Hosted requerida;
- secrets/rotation;
- no SQL/RLS beyond its approved scope.

---

# 26. Data implications

## 26.1 VerificationChallenge

Platform-owned.

## 26.2 SessionGrant

Concepto técnico platform-owned de Identity & Auth.

No se define schema físico en este ADR.

## 26.3 Challenge verifier

No plaintext.

Dedicated keyed verifier.

## 26.4 Technical bridge credential

No plaintext application storage.

Server-only key material y versioning.

## 26.5 Provider secrets

Separar:

```text
challenge key
!=
technical-password key
!=
Supabase secret key
!=
access token
!=
refresh token
```

## 26.6 PII

Email permanece PII y login identifier, no authority tenant.

---

# 27. Security implications

- no public Admin API;
- no generic secret-key client;
- no public signup;
- no user-known password;
- no password recovery session;
- no OTP/magiclink session;
- no challenge plaintext;
- no grant bearer token browser-side;
- default-deny new Auth methods;
- no session claim as tenant authority;
- RLS unchanged as tenant boundary;
- current DB authorization remains superior to session/JWT.

---


## 27.1 Auth funcional

Se preserva explícitamente:

```text
Auth funcional = NO
```

Este ADR selecciona arquitectura y fronteras. No implementa login, signup funcional, logout, onboarding, UI Auth, creación efectiva de usuarios ni establecimiento end-to-end de sesión.

# 28. Offline implications

```text
Offline = FUERA DE ALCANCE
```

No se implementa login offline.

Permanece:

```text
ADR-0004 = BLOCKED BY OPEN DECISIONS
DO-T04
OFF-OPEN-001
OFF-OPEN-002
FORM-OPEN-004
```

---

# 29. UI implications

```text
UI = FUERA DE ALCANCE
```

E2 no autoriza UI password.

La futura UI funcional seguirá siendo email + código.

---

# 30. AuditEvent

Se preserva:

```text
AuditEvent foundation física = SÍ
AuditEvent producer ADR-0019 = NO
```

La futura alta efectiva conserva la obligación `USER_CREATED` conforme al contrato existente.

No se audita artificialmente cada challenge/session grant por este ADR.

---

# 31. Multitenancy y SUPER_ADMIN

Se preserva:

```text
tenant = MaintenanceCompany
VerificationChallenge = platform-owned
SessionGrant = platform-owned
```

`SUPER_ADMIN` sigue sin tenant membership implícita.

Una operation global de primer admin deberá tener autorización específica; no deriva de la secret key.

Para altas tenant posteriores se consume current authoritative authorization de TASK-012/ADR-0003.

---

# 32. No microservices

```text
Next.js modular monolith + Supabase
```

No se introduce:

- OTP service;
- custom identity server;
- password microservice;
- policy service;
- external IdP.

Technical password handling pertenece a una boundary interna del módulo Identity & Auth.

---

# 33. Decision matrix actualizada

| Criterio | A Provider OTP | B App challenge sin bridge | C Admin generateLink | D Hook solo | E1 Grant + provider token | E2 Grant + technical password |
|---|---|---|---|---|---|---|
| RF-005 8h | Possible provider config | **PASS** | **PASS business DB** | N/A | **PASS business DB** | **PASS business DB** |
| RF-006 exact 3 attempts | **FAIL** | **PASS** | **PASS business DB** but provider alternate path | N/A | **PASS business DB** | **PASS business DB** |
| RF-009 resend invalidation | **NOT PROVEN** | **PASS** | **PASS business DB** | N/A | **PASS business DB** | **PASS business DB** |
| Single-use | provider one-time != business contract | **PASS** | business challenge PASS | gate only | **PASS grant/challenge** | **PASS grant/challenge** |
| Direct Auth bypass | **FAIL** | no session bridge | **FAIL standalone** | conditional | **FAIL confused deputy for same method** | **PASS under stated trust boundary** |
| User creation | auto-signup risk | needs Admin | controllable | not creation gate | controllable | **public signup disabled + Admin createUser** |
| Session establishment | **PASS** | **FAIL** | **PASS** | no proof by itself | **PASS technically** | **PASS** |
| Token refresh | provider normal | N/A | normal | can distinguish | can allow `token_refresh` | **explicitly allow `token_refresh`** |
| Recovery bypass | provider flow available | N/A | not closed standalone | can deny | can deny | **deny** |
| Credential exposure | user gets provider OTP | app code user-facing | token/hash server-side | none additional | token/hash server-side | **technical password server-only** |
| Privileged surface | low | future | Auth Admin | hook DB | Auth Admin + hook | **Auth Admin provision only + hook** |
| Plan dependency | standard Auth | none | standard Auth/Admin | Custom Hook Free/Pro | Custom Hook Free/Pro | **Custom Hook Free/Pro; no Teams requirement** |
| Failure/idempotency | provider semantics | DB manageable | cross-system complex | gate only | grant + provider token ambiguity | **grant atomic; fail-closed bridge** |
| Supabase official support | yes, but wrong contract | DB/app yes | primitives yes | hook yes | primitives yes | **all selected primitives documented** |
| User can change bridge credential | provider-owned | N/A | N/A | N/A | N/A | **blocked by current-password requirement** |
| Granular passwordless-disable needed | N/A | N/A | desirable | no | desirable | **NO** |
| Reversibility | high | high | medium | medium | medium | medium; requires credential/hook migration |
| Final | REJECTED | NECESSARY/INCOMPLETE | REJECTED standalone | COMPONENT ONLY | REJECTED | **SELECTED** |

No se utilizan scores arbitrarios.

---

# 34. Testing implications

La futura implementación debe demostrar como mínimo:

## 34.1 Business challenge

- exactly 8h;
- attempt 1/2/3;
- attempt 4 denied before verifier evaluation;
- concurrent attempts;
- resend creates new issuance;
- prior issuance immediately invalid;
- independent attempt counter;
- expiry;
- consumed replay denied;
- concurrent resend;
- verify vs resend.

## 34.2 Session grant

- grant only after challenge consume;
- grant short-lived;
- one successful consume;
- concurrent consume;
- wrong `user_id` denied;
- wrong purpose denied;
- expired grant denied;
- replay denied;
- grant ID alone not sufficient.

## 34.3 Custom Access Token gate

- `password` + no grant → DENY;
- `password` + valid grant → ALLOW exactly once;
- `otp` → DENY;
- `magiclink` → DENY;
- `recovery` → DENY;
- `invite` → DENY;
- `email/signup` → DENY;
- OAuth/anonymous/unknown initial method → DENY;
- `token_refresh` of legitimate session → ALLOW without new challenge;
- hook runtime error → Auth request fails;
- hook timeout → no session.

## 34.4 Technical password

- password never browser-visible;
- absent from bundle;
- absent from logs;
- absent from responses;
- high entropy;
- correct key/version handling;
- user `updateUser(password)` without current technical password rejected when Hosted setting enabled;
- rotation procedure is explicit and does not happen on every login.

## 34.5 Public Auth negative tests

- public `signInWithPassword` without grant → no session;
- public `signInWithOtp` + `verifyOtp` → no session;
- recovery link/flow → no session;
- public signup → denied;
- invite/signup token → no session;
- OAuth/anonymous/passkey/new method → no session unless separately approved.

## 34.6 Auth user creation

- no public creation;
- Admin create requires authorized enrollment;
- duplicate/retry reconciled;
- email confirm only after business proof;
- Before User Created, if enabled, fails closed on missing enrollment.

## 34.7 Authorization regression

- Auth session without membership → no tenant access;
- disabled membership → DENY;
- stale JWT/session does not preserve revoked authorization;
- tenant spoof → DENY;
- SUPER_ADMIN no tenant bypass.

## 34.8 Plan/config regression

- Custom Access Token Hook available in selected Hosted plan;
- Password Verification Hook absence on Free/Pro does not break E2;
- public signup disabled verified;
- current-password change requirement verified;
- anonymous/OAuth providers state reviewed;
- no undocumented `magic_link_enabled` assumption.

---

# 35. Dependencies

## Depende de

- canonical product/auth requirements;
- ADR-0001/0002/0003;
- idempotency principles of ADR-0005;
- TASK-009 identity foundation;
- TASK-010 AuditEvent foundation;
- TASK-011 SSR lifecycle foundation;
- TASK-012 authoritative current authorization foundation;
- TASK-013 blocked specification;
- Hosted Supabase Auth Hooks/Admin/password primitives documented at review date.

## No depende de

- Client;
- UserClientAccess;
- SupportAccessGrant;
- Storage;
- Realtime;
- ADR-0004;
- Offline;
- Fase 3;
- Teams/Enterprise Password Verification Hook.

---

# 36. Criterios de aceptación del ADR


Los siguientes criterios son verificables individualmente.

**AC-001.** ID exacto = `ADR-0019`.  
**AC-002.** Título exacto = `VerificationChallenge, Supabase Auth y frontera de establecimiento de sesión`.  
**AC-003.** Status = `ACCEPTED`.  
**AC-004.** Estado de revisión = `APPROVED`.  
**AC-005.** ADR-0019 se declara `ACCEPTED` exclusivamente después de la aprobación humana formal.  
**AC-006.** El problema cubre challenge lifecycle + Auth session boundary.  
**AC-007.** Se evalúa alternativa A provider-owned.  
**AC-008.** Se evalúa alternativa B application-owned.  
**AC-009.** Se evalúa alternativa C Auth Hook/provider bridge.  
**AC-010.** Se evalúa una composición adicional oficial basada en Custom Access Token Hook.  
**AC-011.** Las fuentes técnicas primarias son oficiales de Supabase.  
**AC-012.** RF-004 se preserva.  
**AC-013.** RF-005 se preserva en 8 horas exactas.  
**AC-014.** RF-006 se preserva en máximo 3 intentos por emisión.  
**AC-015.** RF-007 se preserva.  
**AC-016.** RF-008 se preserva.  
**AC-017.** RF-009 exige invalidación inmediata.  
**AC-018.** RF-010 conserva contador independiente por emisión.  
**AC-019.** RF-011 prohíbe reutilización vencida.  
**AC-020.** Consumido = no reutilizable.  
**AC-021.** Rate limit del provider no se usa como attempt budget.  
**AC-022.** Provider-owned queda rechazado por RF-006/RF-009.  
**AC-023.** Se identifica application-owned como dirección necesaria para business lifecycle.  
**AC-024.** No se persiste el code en plaintext en la alternativa application-owned.  
**AC-025.** Se define una primitive criptográfica candidata keyed para analizar B.  
**AC-026.** Se exige key management y rotation.  
**AC-027.** Se exige comparación segura.  
**AC-028.** Se analiza DB read compromise.  
**AC-029.** Attempts son atómicos/concurrency-safe.  
**AC-030.** El cuarto intento se deniega antes de una cuarta evaluación.  
**AC-031.** Resend crea nueva emisión.  
**AC-032.** Resend invalida anterior autoritativamente.  
**AC-033.** Verify vs resend tiene semántica serializable.  
**AC-034.** Single-use es at-most-once.  
**AC-035.** Se identifica `verifyOtp` como primitive capaz de producir sesión.  
**AC-036.** `setSession` no se usa como creador de tokens.  
**AC-037.** `signInWithIdToken` no se usa sin IdP OIDC real.  
**AC-038.** Se analiza `auth.admin.createUser`.  
**AC-039.** Se analiza `auth.admin.generateLink`.  
**AC-040.** Auto user creation no autorizada queda prohibida.  
**AC-041.** Se analiza `shouldCreateUser`.  
**AC-042.** Se exige control global adicional a caller discipline.  
**AC-043.** Se analiza Before User Created Hook.  
**AC-044.** Se analiza Send Email Hook y custodia de token/token_hash.  
**AC-045.** Se analiza Custom Access Token Hook.  
**AC-046.** Se identifica que el hook documentado no recibe token_hash/challenge ID.  
**AC-047.** Se define privileged boundary purpose-specific.  
**AC-048.** Generic Admin client queda prohibido.  
**AC-049.** Secret/service-role ordinary request client queda prohibido.  
**AC-050.** Privileged credential en browser queda prohibida.  
**AC-051.** VerificationChallenge permanece platform-owned.  
**AC-052.** No se deriva RLS tenant artificial.  
**AC-053.** No hay Data API general browser de challenge state.  
**AC-054.** RLS tenant existente permanece primary boundary.  
**AC-055.** `tenant = MaintenanceCompany` permanece.  
**AC-056.** `authenticated != authorized` permanece.  
**AC-057.** Valid Auth session no implica tenant authorization.  
**AC-058.** Current authoritative state prevalece.  
**AC-059.** SUPER_ADMIN no adquiere tenant bypass.  
**AC-060.** Threat model cubre brute force.  
**AC-061.** Threat model cubre enumeration.  
**AC-062.** Threat model cubre replay/expiry/fourth attempt.  
**AC-063.** Threat model cubre concurrency/resend races.  
**AC-064.** Threat model cubre token/hook/admin secret theft.  
**AC-065.** Threat model cubre logs.  
**AC-066.** Threat model cubre partial failures/retry/idempotency.  
**AC-067.** Threat model cubre direct Auth bypass.  
**AC-068.** Threat model cubre confused deputy/privilege escalation.  
**AC-069.** Failure model cubre DB success + Auth fail.  
**AC-070.** Failure model cubre Auth success + DB fail.  
**AC-071.** Failure model cubre email success + DB fail.  
**AC-072.** Failure model cubre DB success + email fail.  
**AC-073.** Failure model cubre hook timeout/retry.  
**AC-074.** Failure model cubre client retry/network timeout.  
**AC-075.** Failure model cubre concurrent verify/resend.  
**AC-076.** PII/email se minimiza.  
**AC-077.** Logs no contienen secrets/tokens/codes.  
**AC-078.** `AuditEvent foundation física = SÍ` se preserva.  
**AC-079.** `AuditEvent producer ADR-0019 = NO`.  
**AC-080.** `Auth funcional = NO`.  
**AC-081.** UI queda fuera de alcance.  
**AC-082.** Offline queda fuera de alcance.  
**AC-083.** ADR-0004 no se resuelve.  
**AC-084.** DO-T04 se preserva.  
**AC-085.** OFF-OPEN-001 se preserva.  
**AC-086.** OFF-OPEN-002 se preserva.  
**AC-087.** FORM-OPEN-004 se preserva.  
**AC-088.** No se proponen microservicios.  
**AC-089.** Se incluye `Security Decision`.  
**AC-090.** Se incluye decision matrix sin scores arbitrarios.  
**AC-091.** Se documenta impacto sobre TASK-013.  
**AC-092.** Se documenta impacto documental.  
**AC-093.** No se implementa schema.  
**AC-094.** No se escribe migration.  
**AC-095.** No se escribe SQL ejecutable.  
**AC-096.** No se escribe RLS ejecutable.  
**AC-097.** No se modifica Supabase Cloud.  
**AC-098.** No se modifica repositorio.  
**AC-099.** No se usa Codex.  
**AC-100.** No se canonicaliza.  
**AC-101.** No se hace Git add/commit/push.  
**AC-102.** TASK-013 sigue bloqueada.  
**AC-103.** TASK-013 implementación autorizada = NO.  
**AC-104.** TASK-014 determinada = NO.  
**AC-105.** TASK-014 generada = NO.  
**AC-106.** La decisión no depende de Supabase internals.  
**AC-107.** La decisión no inventa una session minting primitive.  
**AC-108.** La prevención de bypass se resuelve mediante el gate default-deny de Custom Access Token Hook, un session grant application-owned y un password técnico server-only cuya prueba válida no está disponible al browser.  
**AC-109.** La revisión humana fue completada y la decisión técnica E2 fue aprobada, sin autorizar implementación.  


**AC-110.** E1 — session grant + Custom Access Token Hook + Admin provider bridge — está evaluada explícitamente.  
**AC-111.** E2 — session grant + server-only technical password bridge — está evaluada explícitamente.  
**AC-112.** Custom Access Token Hook se evalúa como deny gate y se verifica que runtime errors se propagan a Supabase Auth.  
**AC-113.** `authentication_method` se utiliza sólo como Auth-session gate y no como tenant authorization.  
**AC-114.** `token_refresh` queda separado conceptualmente de initial session establishment.  
**AC-115.** El password bridge utiliza un technical password server-only y no introduce password UX.  
**AC-116.** Password Verification Hook está evaluado y su dependencia Teams/Enterprise queda registrada como optional, no baseline.  
**AC-117.** Password recovery está evaluada y `recovery` queda denied como initial session method.  
**AC-118.** El cambio de password por usuario autenticado está evaluado y E2 requiere current-password verification Hosted.  
**AC-119.** La capacidad Hosted granular de desactivar passwordless manteniendo password se registra como `NOT DEMONSTRATED` y E2 no depende de ella.  
**AC-120.** Session grant race está evaluada con atomic single-use consume.  
**AC-121.** Wrong auth pathway + active grant queda denied; password path requiere además technical password.  
**AC-122.** Todas las vías relevantes —password, OTP, Magic Link, recovery, invite/signup, OAuth/anonymous, token refresh e identity linking cuando corresponde— están evaluadas.  
**AC-123.** La decision matrix incluye A, B, C, D, E1 y E2 con los criterios exigidos.  
**AC-124.** El threat model incorpora password sign-in público, recovery, password mutation, grant races, bridge credential, hook outage/timeout, refresh y plan dependency.  
**AC-125.** La conclusión aprobada mantiene E2, declara `ACCEPTED / APPROVED`, mantiene TASK-013 bloqueada y no autoriza implementación.  

### 36.1 Evaluación del Gate del draft

Resultado documental/arquitectónico de esta corrección:

```text
AC-001..AC-125 = REVIEWABLE
ADR-0019 DRAFT = PASS
```

El estado `ACCEPTED` de ADR-0019 no significa:

```text
TASK-013 = UNBLOCKED
implementation = authorized
```

---

# 37. Blockers / implementation gates

No queda un blocker arquitectónico de draft después de seleccionar E2.

```text
ADR-0019 DRAFT BLOCKER = NONE
```

Sí quedan gates obligatorios para una futura implementación, posteriores a aceptación/canonicalización:

1. Hosted project must support/configure Custom Access Token Hook conforme al contrato oficial;
2. hook runtime errors must be verified fail-closed in Development;
3. `authentication_method=password` y `token_refresh` must match official behavior in remote verification;
4. public signup must be disabled;
5. current-password-required setting must be enabled and verifiable;
6. public Auth methods must fail the negative session tests;
7. technical password must remain server-only;
8. Admin client must remain purpose-specific;
9. session grant atomic consume must pass concurrency tests;
10. any material discrepancy in official Hosted behavior returns TASK-013 to `BLOCKER` rather than broadening scope.

---

# 38. Fuentes oficiales verificadas

**Fecha de reverificación:** `2026-08-28`

| Fuente oficial | URL | Evidencia utilizada |
|---|---|---|
| Auth Hooks overview | `https://supabase.com/docs/guides/auth/auth-hooks` | plan availability; hook timing; grants; runtime errors; propagation; timeouts; transactions |
| Custom Access Token Hook | `https://supabase.com/docs/guides/auth/auth-hooks/custom-access-token-hook` | before-token gate; `user_id`; `authentication_method`; method values including `password`/`recovery`/`magiclink`/`token_refresh` |
| Password Verification Hook | `https://supabase.com/docs/guides/auth/auth-hooks/password-verification-hook` | password attempt hook; `continue`/`reject`; optional Teams/Enterprise |
| Before User Created Hook | `https://supabase.com/docs/guides/auth/auth-hooks/before-user-created-hook` | user creation gate; email available; error blocks creation |
| Send Email Hook | `https://supabase.com/docs/guides/auth/auth-hooks/send-email-hook` | custom Auth email boundary; token/token_hash/email action material |
| Password-based Auth | `https://supabase.com/docs/guides/auth/passwords` | `signInWithPassword`; public recovery; `updateUser(password)` |
| Password security | `https://supabase.com/docs/guides/auth/password-security` | require reauthentication/current password; password hashing |
| User sessions | `https://supabase.com/docs/guides/auth/sessions` | session creation; multiple sessions; refresh token; password-change termination semantics |
| General Auth configuration | `https://supabase.com/docs/guides/auth/general-configuration` | disable public signup; only existing users sign in; anonymous/manual linking config |
| Management API — get auth config | `https://supabase.com/docs/reference/api/v1-get-auth-service-config` | `external_email_enabled`, `disable_signup` and Hosted auth config surface |
| Management API — update auth config | `https://supabase.com/docs/reference/api/v1-update-auth-service-config` | Hosted writable auth config; rate/OTP/email fields; absence of documented `magic_link_enabled` |
| JS `signInWithPassword` | `https://supabase.com/docs/reference/javascript/auth-signinwithpassword` | supported password session primitive |
| JS `signInWithOtp` | `https://supabase.com/docs/reference/javascript/auth-signinwithotp` | public passwordless surface |
| JS `verifyOtp` | `https://supabase.com/docs/reference/javascript/auth-verifyotp` | provider OTP/token_hash verification/session |
| JS `resetPasswordForEmail` | `https://supabase.com/docs/reference/javascript/auth-resetpasswordforemail` | public recovery surface |
| JS `updateUser` | `https://supabase.com/docs/reference/javascript/auth-updateuser` | authenticated user can update password subject to security config |
| JS Admin `createUser` | `https://supabase.com/docs/reference/javascript/auth-admin-createuser` | server-only user creation; email confirm/password |
| JS Admin `updateUserById` | `https://supabase.com/docs/reference/javascript/auth-admin-updateuserbyid` | server-only password provisioning/rotation |
| JS Admin `generateLink` | `https://supabase.com/docs/reference/javascript/auth-admin-generatelink` | alternative provider-token bridge evaluated but not selected |
| JS `setSession` | `https://supabase.com/docs/reference/javascript/auth-setsession` | consumes existing access/refresh tokens; not a minting bridge |
| API keys | `https://supabase.com/docs/guides/getting-started/api-keys` | secret keys backend-only/elevated; no browser |
| RLS | `https://supabase.com/docs/guides/database/postgres/row-level-security` | elevated secret/service roles can bypass RLS |
| Securing Data API | `https://supabase.com/docs/guides/api/securing-your-api` | grants + RLS; explicit exposure control |

No se utiliza GitHub source, GoTrue internals ni self-hosted-only fields como capacidad Hosted no documentada.

---

# 39. References de proyecto

## Producto / arquitectura

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/04-offline-sync-strategy.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md`
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`
- `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`
- `docs/architecture/adr/ADR-0013-ai-server-side-provider-boundary.md`

## Fase 2

- `docs/tasks/TASK-009-identity-tenant-foundation.md`
- `docs/tasks/TASK-010-audit-event-foundation.md`
- `docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md`
- `docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`
- `docs/tasks/CORR-014-task-012-closure-state-sync.md`
- `TASK-013-verification-challenge-foundation.md`

---

# 40. Estado final

```text
ADR-0019 REVIEW PREVIOUS = RETURNED FOR CORRECTION
ADR-0019 DRAFT REVIEW = PASS
ADR-0019 ARCHITECTURE REVIEW = APPROVED
ADR-0019 DOCUMENT CORRECTION REVIEW = APPROVED
ADR-0019 SECOND REVIEW = APPROVED
ADR-0019 HUMAN APPROVAL = APPROVED

ADR-0019 status = ACCEPTED
ADR-0019 review = APPROVED
ADR-0019 DRAFT = PASS

ADR-0019 decision =
E2 — APPLICATION-OWNED VERIFICATION CHALLENGE
+ ONE-TIME SESSION GRANT
+ SERVER-ONLY TECHNICAL PASSWORD BRIDGE
+ CUSTOM ACCESS TOKEN HOOK GATE

ADR-0019 determinada = SÍ
ADR-0019 corregida = SÍ
ADR-0019 aceptada = SÍ
ADR-0019 canonicalizada = NO

TASK-013 sigue bloqueada = SÍ
TASK-013 implementación autorizada = NO

TASK-014 determinada = NO
TASK-014 generada = NO
```

---

# 41. Resumen de cambios respecto de la versión anterior

La corrección **no reabre** RF-004…RF-011 ni los invariantes de multitenancy/RLS/privilegio ya considerados correctos.

Cambios materiales:

1. se corrige la afirmación de que la falta de `token_hash` vuelve insuficiente por definición al Custom Access Token Hook;
2. se verifica que runtime errors del hook pueden denegar JWT issuance;
3. se verifica y utiliza `authentication_method`;
4. se separa explícitamente initial sign-in de `token_refresh`;
5. se añade E1 y se rechaza por confused-deputy race sobre métodos passwordless compartidos;
6. se añade E2 y se selecciona;
7. E2 introduce technical password server-only como provider proof diferenciable;
8. se añade SessionGrant single-use como authorization evidence de initial session issuance;
9. se evalúa `signInWithPassword`, `updateUserById`, public recovery y password mutation;
10. se verifica Password Verification Hook y se registra Teams/Enterprise sin hacerlo requisito;
11. se verifica que no está demostrada una config Hosted granular `disable passwordless / keep password`;
12. se actualizan bypass prevention, threat model, failure model, matrix y tests;
13. el resultado cambia de `DRAFT = BLOCKER` a `DRAFT = PASS`;
14. governance pasa a `ACCEPTED / APPROVED` por aprobación humana; TASK-013 continúa bloqueada hasta canonicalización, incorporación Git, sincronización documental requerida, revisión/corrección y nueva aprobación de TASK-013.

---

# 42. Confirmación de no ejecución

```text
NO IMPLEMENTATION
NO REPO MODIFICATION
NO CODE
NO SQL
NO MIGRATION
NO RLS
NO SUPABASE CLOUD CHANGE
NO GIT ADD
NO COMMIT
NO PUSH
NO TASK-014
```
