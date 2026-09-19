# ADR-0020 — Authoritative first-admin onboarding intent binding

## 1. ID

`ADR-0020`

## 2. Título

`ADR-0020 — Authoritative first-admin onboarding intent binding`

## 3. Estado documental

```text
DOCUMENT TYPE = ARCHITECTURE DECISION RECORD
ADR-0020 CANONICAL ARTIFACT = READY FOR CENTRAL REVIEW
ADR-0020 SPEC REVIEW = APPROVED
ADR-0020 HUMAN ARCHITECTURE APPROVAL = APPROVED
ADR-0020 architecture decision = ACCEPTED BY HUMAN APPROVAL
ADR-0020 APPROVED ARTIFACT REVIEW = APPROVED
ADR-0020 CANONICALIZATION REVIEW = NOT APPROVED
repository incorporated = NO
implementation authorized = NO
TASK-017 determined = NO
TASK-017 generated = NO
```

Ruta canónica futura propuesta:

`docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md`

Esta ruta todavía no es canónica.

La generación de este ADR no implementa ninguna capability, no autoriza Codex, no modifica el repositorio, no modifica Supabase, no genera SQL ejecutable, migrations ni RLS ejecutable y no determina la siguiente implementation task.

## 4. Contexto

La Fase 2 está iniciada y no completada. TASK-016 está cerrada y verificó exclusivamente la creación global autoritativa mínima de una `MaintenanceCompany` por un `SUPER_ADMIN` actual, limitada a RF-001, RF-002 y FL-01 steps 1–2.

El estado vigente posterior a TASK-016 preserva expresamente:

```text
TASK-016 = DONE / CLOSED
TASK-016 FINAL HUMAN CLOSURE = APPROVED
TASK-016 Hosted Development = APPLIED AND VERIFIED
TASK-016 implementation commit = 2968c408229659e245ed1c9805c327671e95fba5
first COMPANY_ADMIN = NOT IMPLEMENTED
full onboarding = NOT IMPLEMENTED
TASK-017 = NOT DETERMINED / NOT GENERATED / NOT STARTED
Phase 2 = INICIADA / NOT DONE
Phase 2 Exit Gate = NOT DEFINED / NOT SATISFIED
Phase 3 = NOT STARTED
PAY-OPEN-001 = UNRESOLVED
PAY-OPEN-008 = UNRESOLVED
```

La siguiente porción normativa del alta de empresa comprende RF-003..RF-011 y FL-01 steps 3–5:

```text
MaintenanceCompany ya existente
→ indicar email del primer COMPANY_ADMIN
→ emitir código
→ aplicar 8 horas / 3 intentos por emisión
→ permitir resend
→ cada resend produce una nueva emisión
→ nueva emisión invalida inmediatamente la anterior
```

TASK-013 y ADR-0019 ya materializaron y fijaron la foundation técnica de `VerificationChallenge`, `SessionGrant`, technical-password bridge y Custom Access Token Hook. Esa foundation deliberadamente no incorporó tenant, membership, role ni client scope dentro del challenge y dejó fuera la autorización funcional de issue/resend, el onboarding, el primer `COMPANY_ADMIN`, la creación funcional de `CompanyMembership` y los productores funcionales de auditoría.

Por tanto, el gap arquitectónico actual no es cómo almacenar o verificar el código. El gap es cómo vincular autoritativamente una emisión platform-owned con una única intención de onboarding para una empresa concreta y cómo preservar ese vínculo hasta el provisioning, sin convertir el challenge, el email, una claim o una credencial privilegiada en autoridad tenant.

## 5. Problema

Se debe representar una intención autoritativa que vincule inequívocamente:

```text
MaintenanceCompany concreta
+
target email concreto
+
purpose = first-admin onboarding
+
current VerificationChallenge
+
proof consumida
+
future provisioning
+
eventual SessionGrant/session establishment
```

La arquitectura debe impedir simultáneamente:

- que un challenge válido para un email pueda aplicarse a una `MaintenanceCompany` arbitraria;
- cross-tenant replay;
- cross-intent replay;
- confused deputy entre la prueba de email y la autoridad de provisioning;
- que el challenge o el email se conviertan en autoridad tenant;
- que una request o claim defina el tenant efectivo;
- que `SUPER_ADMIN` adquiera membership implícita;
- que un retry o carrera produzca dos primeros administradores;
- que resend mantenga dos emisiones current;
- que browser/Data API dispongan de un bypass de escritura;
- que la solución requiera un client privilegiado genérico o un microservice.

## 6. Fuentes canónicas consumidas

### 6.1 Producto

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md` post-CORR-026

### 6.2 Arquitectura

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`

### 6.3 Foundations de Fase 2

- `docs/tasks/TASK-009-identity-tenant-foundation.md`
- `docs/tasks/TASK-010-audit-event-foundation.md`
- `docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md`
- `docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`
- `docs/tasks/TASK-013-verification-challenge-foundation.md`
- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`
- `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`
- `docs/tasks/TASK-016-maintenance-company-global-authoritative-creation.md`
- `docs/tasks/CORR-026-task-016-closure-state-sync.md`

### 6.4 Identidad current canon verificada

Las tres fuentes recuperadas necesarias para reanudar este ADR fueron verificadas byte-for-byte antes de continuar:

```text
TASK-016 SHA-256 =
1627aa3bcece1c89c3bad8840e74a32f689e3916ebcc23c5031ff38e88dd063e

CORR-026 SHA-256 =
2b6e56229428ab531776fdc54e96034cced9b03e932514781099c2b423f88d6f

11-phase-1-scope-entry-gate.md post-CORR-026 SHA-256 =
abf8d980a6d4d93f15f411e0b7ddb3b4288225e00164740f9c29ba0ac7e10302
```

No se utiliza una copia histórica como sustituto de esas identidades.

## 7. Constraints heredados

Se preservan sin reapertura:

```text
tenant = MaintenanceCompany
VerificationChallenge = platform-owned
SessionGrant = platform-owned
email = PII + locator
email != application authority
authenticated != authorized
PostgreSQL current state = authoritative
SUPER_ADMIN = global identity
SUPER_ADMIN != implicit tenant member
SUPER_ADMIN ordinary tenant bypass = NO
RLS = mandatory para tenant-owned data
browser direct DB mutation = prohibited en esta frontera
service-role request client = NO
generic privileged client = NO
Next.js modular monolith + Supabase = PRESERVED
microservices = NO
ADR-0019 / E2 = PRESERVED
offline = NO para este flujo
```

`VerificationChallenge` continúa sin contener:

```text
maintenance_company_id
tenant_id
membership
role
client scope
```

El propósito `first-admin onboarding` tampoco se añade como role mutable al challenge.

## 8. Requisitos funcionales aplicables

Este ADR consume sin redefinir:

- RF-003: durante el alta se indica el correo del primer `COMPANY_ADMIN`;
- RF-004: el sistema envía un código al correo indicado;
- RF-005: cada emisión dura 8 horas;
- RF-006: máximo 3 intentos efectivos por emisión;
- RF-007: el actor autorizado para el alta puede reenviar;
- RF-008: cada resend emite un código nuevo;
- RF-009: la emisión anterior queda inmediatamente invalidada al emitir la nueva;
- RF-010: cada emisión nueva posee su propio presupuesto de 3 intentos;
- RF-011: una emisión vencida no se recupera ni reutiliza;
- FL-01 steps 3–5.

RF-012 y FL-01 steps 6–8 son consumidores posteriores relevantes de la decisión, pero no son implementados ni convertidos automáticamente en scope de una futura TASK por este ADR.

## 9. Current architecture

### 9.1 Identidad y tenant

TASK-009 materializó:

```text
Auth subject
→ PlatformUser
→ CompanyMembership
→ MaintenanceCompany
```

con `PlatformUser → 0..1 CompanyMembership` y roles tenant limitados a `COMPANY_ADMIN | TECHNICIAN`.

### 9.2 Autoridad global

TASK-014 materializó autoridad `SUPER_ADMIN` DB-authoritative. Una identidad global válida no posee `CompanyMembership`; una identidad con `is_super_admin = true` y cualquier membership es inconsistente y debe fallar cerrado.

### 9.3 Challenge y sesión

TASK-013 materializó la foundation E2:

```text
VerificationChallenge application-owned
→ consume single-use
→ SessionGrant
→ AuthBridgeCredential
→ purpose-specific Auth Admin provisioning
→ server-only technical password sign-in
→ Custom Access Token Hook gate
→ Supabase session
```

La foundation de challenge ya garantiza expiry, intentos, terminalidad, resend, idempotencia por operación, concurrencia, single-use, no browser CRUD y no generic privileged client.

### 9.4 Creación de empresa

TASK-016 materializó únicamente:

```text
current authoritative SUPER_ADMIN
→ create MaintenanceCompany
→ active tenant identity exists
```

sin primer administrador, email, challenge funcional de onboarding, `PlatformUser`, `CompanyMembership`, email delivery ni onboarding completo.

## 10. Decision drivers

La solución debe:

1. mantener tenant/email/purpose fuera del challenge;
2. preservar una única empresa intended;
3. preservar un único propósito de first-admin;
4. permitir current-challenge rotation segura;
5. impedir que proof y provisioning se separen hacia tenants distintos;
6. soportar retries y carreras sin duplicar primer admin;
7. preservar autoridad DB vigente para issue/resend;
8. separar proof de email de authority de provisioning;
9. minimizar privilege surface y Data API exposure;
10. ser compatible con la atomicidad ya materializada por TASK-013;
11. permitir recovery ante fallos de Auth Admin sin mega-transacción distribuida;
12. mantener PII minimizada y no enumerable;
13. caber en el monolito modular Next.js + Supabase;
14. permitir implementación posterior PR-sized;
15. no resolver Subscription, promotional entitlement ni PAY-OPEN-001/008.

## 11. Alternativas

### 11.1 OPTION A — Entidad purpose-specific separada

Concepto seleccionado para el ADR:

`FirstAdminOnboardingIntent`

Representa una intención de plataforma estable, separada de `VerificationChallenge`, que vincula una única `MaintenanceCompany`, un target email, el propósito first-admin y el challenge current.

### 11.2 OPTION B — Binding/state sobre MaintenanceCompany

Añadir campos purpose-specific de onboarding directamente sobre `MaintenanceCompany`, por ejemplo target email/current challenge/completion state.

### 11.3 OPTION C — Asociación externa sin entidad principal de intent

Mantener relaciones challenge↔company/purpose mediante asociaciones o lookups auxiliares sin una identidad principal estable de first-admin intent.

### 11.4 OPTION D — Reutilizar estado de Auth boundary

Intentar representar el binding mediante `VerificationChallenge`, `SessionGrant`, `AuthBridgeCredential` o una combinación de ellos, sin nuevo concepto de onboarding intent.

## 12. Análisis comparativo

| Criterio | OPTION A — separate intent | OPTION B — fields on company | OPTION C — association only | OPTION D — Auth artifacts |
|---|---|---|---|---|
| Consistencia de dominio | Alta: modela una intención de onboarding distinta del tenant | Media: mezcla identidad tenant con proceso temporal | Baja/Media: el concepto existe implícitamente pero sin identidad estable | Baja: mezcla onboarding con primitives Auth |
| Ownership | Platform-owned claro | Híbrido/confuso entre tenant identity y platform process | Difícil de expresar sin terminar creando entidad equivalente | Platform-owned pero con responsabilidad equivocada |
| Mantiene challenge sin tenant | Sí | Sí | Sí | No de forma limpia; tiende a contaminar artifacts |
| Confused deputy | Bajo con binding explícito | Medio; company row se vuelve authority carrier de proceso | Alto si asociaciones no forman una única aggregate boundary | Alto; proof/Auth state puede confundirse con tenant authority |
| Cross-tenant replay | Bloqueable por intent→company immutable | Bloqueable pero con acoplamiento de company state | Más difícil de probar | Riesgo elevado |
| Resend lifecycle | Current challenge pointer natural | Posible, pero ensucia tenant row | Complejo bajo concurrencia | No corresponde a responsibility de grant/bridge |
| Idempotencia | Natural por intent + operation IDs | Acoplada a tenant row | Fragmentada | Fragmentada entre artifacts |
| Concurrencia | Lock/constraint por intent/company | Lock sobre tenant row para Auth workflow | Requiere coordinación transversal | Requiere coordinar artifacts con lifecycles distintos |
| Provisioning handoff | Deriva tenant/email/purpose desde una fuente | Deriva desde tenant row pero mezcla responsabilidades | Handoff ambiguo | Demasiado tarde o demasiado acoplado |
| PII minimization | Email aislado en un recurso purpose-specific | Email queda incrustado en tenant identity | Depende de asociaciones | Duplica PII en Auth artifacts |
| Auditability | Puede conservar initiator provenance | Posible pero mezcla history/process | Débil | No representa bien actor de onboarding |
| Migration impact | Nueva entidad additive | Columnas sobre tabla central existente | Nueva asociación igualmente necesaria | Cambios a foundations ADR-0019/TASK-013 |
| Compatibilidad ADR-0019 | Alta | Media | Media | Baja |
| Testability | Alta | Media | Media/Baja | Baja |
| Privilege minimization | Alta mediante functions purpose-specific | Media | Media/Baja | Baja |
| PR-sized | Sí, separable | Sí, pero mayor acoplamiento | Difícil de cerrar con seguridad | No recomendable |

## 13. Decisión seleccionada

Se selecciona **OPTION A**.

La arquitectura introduce el concepto purpose-specific:

```text
FirstAdminOnboardingIntent
```

como la fuente autoritativa del binding de first-admin onboarding.

La selección se justifica porque el problema posee identidad, ownership, lifecycle, idempotencia, concurrencia, handoff y single-use propios. Ocultarlo como campos de `MaintenanceCompany`, como una asociación sin identidad o dentro de artifacts Auth produciría un agregado equivocado o una autoridad implícita difícil de probar.

`FirstAdminOnboardingIntent` es deliberadamente estrecho. No se generaliza a un framework de invitations, enrollments o workflows.

## 14. Domain / ownership model

### 14.1 Owner

`FirstAdminOnboardingIntent` es **platform-owned**.

No es tenant-owned aunque referencia una `MaintenanceCompany`, porque:

- nace en una operación global de plataforma;
- existe antes de que el primer tenant member exista;
- `SUPER_ADMIN` no posee tenant membership;
- no debe abrir RLS tenant ordinaria para permitir onboarding;
- coordina Identity/Auth con una identidad tenant ya creada.

### 14.2 Identidad estable

Cada intent posee una identidad estable UUID propia.

La identidad del intent:

```text
!= MaintenanceCompany.id
!= VerificationChallenge.id
!= SessionGrant.id
!= email
!= Auth subject
```

### 14.3 Cardinalidad first-admin

Para una `MaintenanceCompany` sólo puede existir **un binding first-admin autoritativo capaz de producir el alta inicial**.

La futura representación física debe impedir dos first-admin intents competidores para la misma empresa. La regla existe para impedir dos primeros administradores por carrera; no impide que después del bootstrap existan otros `COMPANY_ADMIN` mediante el lifecycle ordinario del producto.

### 14.4 Target email

El intent conserva el target email indicado para el primer admin.

Ese email:

- es PII;
- es locator y proof target;
- no es tenant authority;
- no es identity authority por sí solo;
- no es una clave para derivar `MaintenanceCompany`;
- no obtiene uniqueness global nueva por este ADR.

El ADR no inventa un flujo para cambiar el target email de un intent existente. Si producto necesita cancelación, reemplazo o cambio de email durante onboarding:

```text
OPEN PRODUCT DECISION REQUIRED
```

Ese punto no bloquea RF-003..RF-011 porque el flujo aprobado no exige dicha capacidad.

### 14.5 Purpose

El propósito es fijo por el tipo del concepto:

```text
FirstAdminOnboardingIntent
→ purpose = first-admin onboarding
→ resulting tenant role = COMPANY_ADMIN
```

No se introduce un role mutable ni un catálogo de purpose genérico.

### 14.6 Lifecycle

El lifecycle conceptual mínimo debe distinguir, sin imponer nombres físicos de estados:

```text
intent established with first challenge
→ zero or more safe challenge replacements
→ current challenge business proof verified / consumed
→ authoritative onboarding handoff available to continue RF-012
→ eventual first-admin onboarding completion only after the future lifecycle satisfies profile completion and tenant-authority enablement
```

Debe permanecer explícitamente:

```text
valid / consumed business proof
!= first-admin onboarding completed
!= enabled tenant authority
```

ADR-0020 decide la frontera hasta el **authoritative onboarding handoff**. No fija el detalle completo de la transición posterior que completa RF-012 / FL-01 steps 6–8.

No se introduce:

- expiración independiente del intent;
- máximo de resends;
- cancelación;
- cambio de email;
- commercial state;
- Subscription state;
- una transición de membership inventada para representar profile completion.

La expiración pertenece a cada `VerificationChallenge`, no al intent.

## 15. Authoritative binding model

El binding autoritativo es unidireccional desde el intent:

```text
FirstAdminOnboardingIntent.id
→ exactly one MaintenanceCompany.id
→ exactly one target email
→ implicit fixed purpose = first-admin onboarding
→ exactly one current VerificationChallenge.id at a time
```

`VerificationChallenge` no obtiene back-reference tenant, role o membership.

La relación current challenge debe ser autoritativa y durable. Un challenge sólo puede utilizarse para producir el authoritative first-admin onboarding handoff cuando:

1. el intent existe;
2. el intent referencia la `MaintenanceCompany` esperada internamente;
3. el target email del intent coincide con el email del challenge conforme al valor persistido;
4. el challenge es el current challenge del intent en la transición que se está evaluando;
5. el challenge satisface el lifecycle autoritativo de TASK-013;
6. el intent no posee todavía evidencia terminal de eventual onboarding completion.

Ninguna operación de verify ni ninguna continuación futura de RF-012 acepta un `maintenance_company_id` caller-supplied como autoridad para elegir el tenant de destino.

Un challenge válido para email A más un tenant B arbitrario no puede producir un handoff ni una eventual habilitación first-admin para B porque B nunca participa como input autoritativo del handoff.

## 16. Issue / resend authorization

### 16.1 Primera emisión

El actor autorizado para establecer el first-admin intent y emitir el primer challenge es únicamente:

```text
current authoritative SUPER_ADMIN
```

La autoridad debe resolverse mediante la foundation vigente de TASK-014, desde identidad Auth validada y PostgreSQL actual.

La primera operación recibe como locator funcional mínimo:

- `maintenance_company_id` target;
- target email;
- idempotency/operation correlation purpose-specific.

El `maintenance_company_id` selecciona el objeto sobre el cual el `SUPER_ADMIN` global intenta iniciar onboarding, pero conocerlo o enviarlo no concede autoridad.

La operación debe validar que:

- la empresa existe;
- no existe ya un first-admin onboarding completion autoritativo para esa empresa;
- no existe otro intent first-admin competidor;
- no existe un estado autoritativo de identidad/membership incompatible con que se trate del bootstrap inicial;
- el actor sigue siendo `SUPER_ADMIN` autoritativo en la misma mutation boundary.

### 16.2 Atomicidad de la primera emisión

La creación del intent y la creación del primer `VerificationChallenge` deben compartir una única transacción PostgreSQL.

Debe ser imposible confirmar:

```text
intent created
+
no authoritative current challenge
```

como resultado exitoso de la operación inicial.

El email delivery queda fuera de esta transacción.

### 16.3 Resend

El resend first-admin:

- requiere current authoritative `SUPER_ADMIN` en cada call;
- acepta el intent ID, no un tenant arbitrario como nueva autoridad;
- deriva la empresa y target email desde el intent;
- opera únicamente sobre el challenge current;
- reutiliza las invariantes de successor/invalidation de TASK-013;
- debe invalidar el predecessor y actualizar el current challenge del intent en la misma transacción;
- utiliza un nuevo `issue_operation_id` para una nueva emisión lógica;
- un retry del mismo operation ID reconcilia la misma emisión, no crea otra.

### 16.4 Autoridad perdida antes de issue/resend

Si la identidad pierde autoridad `SUPER_ADMIN` antes de la mutation:

```text
issue/resend = DENY
intent/challenge mutation = NONE
```

Un retry del mismo operation ID no devuelve un éxito privilegiado si la autoridad actual ya no es válida.

### 16.5 Autoridad perdida después de issue

La pérdida posterior de autoridad del emisor:

- no convierte el challenge en authority;
- no permite nuevos resends por ese actor;
- no borra ni reescribe el intent histórico;
- no invalida por inferencia un proof ya emitido porque el producto no define esa política de cancelación.

La continuación posterior hacia RF-012 no se autoriza por la autoridad histórica del emisor. El tenant y el target quedan vinculados por el intent autoritativo y la proof válida/current habilita únicamente el handoff seguro; ni el challenge consumido, ni el `SessionGrant`, ni una identidad Auth creada equivalen por sí solos a tenant authority habilitada.

La eventual autoridad `COMPANY_ADMIN` sólo puede habilitarse mediante el futuro lifecycle que respete `verificación válida → perfil completado → membership habilitada`.

Si producto desea que la revocación posterior de un `SUPER_ADMIN` cancele automáticamente intents pendientes:

```text
OPEN PRODUCT DECISION REQUIRED
```

Ese comportamiento no se inventa en ADR-0020.

## 17. Verify / provision handoff

### 17.1 Verify proof

La verificación demuestra exclusivamente control del email/code conforme a TASK-013.

```text
valid code
!= tenant authority
!= enabled COMPANY_ADMIN authority
!= first-admin onboarding completed
```

La boundary first-admin de verify debe resolver el intent y su challenge current antes de consumir la proof. No debe aceptar un tenant target separado.

### 17.2 Atomic binding check + challenge consume

La transición que consume el challenge debe verificar en estado autoritativo actual:

```text
intent.current_challenge_id = challenge.id
AND intent.target_email = challenge.email
AND intent has no terminal onboarding-completion evidence
```

antes de permitir el consume.

Esa comprobación debe formar parte de la misma frontera transaccional que hace terminal el challenge y crea el `SessionGrant` conforme a TASK-013, o de una composición PostgreSQL equivalente que preserve una única decisión atómica.

No es aceptable:

```text
read intent
→ release transaction
→ consume arbitrary challenge later
```

### 17.3 Authoritative onboarding handoff

Después de un verify exitoso debe sobrevivir evidencia autoritativa suficiente para que una futura implementación de RF-012 continúe sin volver a derivar tenant, target o purpose desde inputs no confiables.

La continuación segura debe poder demostrar conjuntamente:

- intent ID estable;
- `MaintenanceCompany` derivada exclusivamente del intent;
- target email derivado exclusivamente del intent;
- current challenge derivado del intent;
- current challenge consumido de forma válida;
- `SessionGrant` correspondiente al consume cuando corresponda a E2;
- que no existe ya un first-admin onboarding completion autoritativo para ese intent;
- operation correlation suficiente para reconciliar retries de las operaciones futuras que materialicen side effects.

Este handoff es evidencia para continuar RF-012. No constituye por sí mismo onboarding completion ni tenant authority habilitada.

### 17.4 Tenant nunca proviene del caller

Ninguna futura boundary que continúe RF-012 acepta `maintenance_company_id` como autoridad. El tenant resultante se deriva exclusivamente del intent.

Por tanto:

```text
valid challenge for email A
+
arbitrary tenant B
→ DENY / impossible by contract
```

### 17.5 Intended role

El role de destino del first-admin intent es `COMPANY_ADMIN` por el purpose fijo del intent y por FL-01.

No se acepta role caller-supplied para convertir el handoff en otro role.

Pero:

```text
intended role = COMPANY_ADMIN
!= enabled CompanyMembership
!= tenant authority before profile completion
```

ADR-0020 no decide el momento exacto de creación de `CompanyMembership`, su estado antes de profile completion ni una transición disabled→enabled para onboarding.

### 17.6 Future identity / membership reconciliation

La futura implementación de RF-012 debe preservar el modelo estable de identidad:

- un Auth subject reconocido resuelve como máximo a un `PlatformUser` autoritativo;
- un `PlatformUser` posee como máximo una `CompanyMembership` en el MVP;
- `SUPER_ADMIN` no puede convertirse silenciosamente en tenant member;
- una identidad/membership existente incompatible falla cerrado;
- una identidad global `SUPER_ADMIN` no se reutiliza como first tenant admin mientras conserve autoridad global.

La implementación puede reconciliar un Auth user ya creado por un intento anterior ambiguo conforme a TASK-013; no puede enumerar o apropiarse silenciosamente de cuentas incompatibles.

ADR-0020 no fija si `PlatformUser` o `CompanyMembership` se materializan antes, durante o después de profile completion. Esa secuencia pertenece a la futura implementación de RF-012 / FL-01 steps 6–8, que debe preservar que la membership habilitada y la autoridad tenant sólo existan conforme al lifecycle aprobado.

### 17.7 Eventual completion evidence

El intent necesita poder distinguir durablemente:

```text
business proof verified / authoritative handoff ready
!=
eventual first-admin onboarding completed
```

La evidencia terminal de completion sólo puede representar el resultado de la futura transición autoritativa que, respetando profile completion, habilite finalmente la autoridad first-admin.

El shape físico exacto y la transición que la establece se definen en la future implementation task, pero debe poder demostrar:

```text
one FirstAdminOnboardingIntent
→ at most one eventual completed first-admin onboarding outcome
```

Una vez registrado ese completion autoritativo, el intent es terminal para nuevos issue/resend y no puede producir un segundo first-admin completion.

## 18. Idempotency / concurrency

### 18.1 Intención inicial

La operación que establece intent + first challenge debe tener una operation correlation purpose-specific.

Mismo operation ID:

```text
same authorized logical request
→ same intent
→ same first challenge emission
→ no duplicate intent
```

La reconciliación positiva requiere volver a comprobar current `SUPER_ADMIN` authority antes de devolver un outcome privilegiado.

### 18.2 Issue/resend

Se reutiliza la idempotencia `issue_operation_id` de TASK-013 para cada emisión.

Un duplicate operation ID:

- no crea segundo challenge;
- no reinicia attempts;
- no cambia email;
- no cambia tenant;
- no cambia purpose.

### 18.3 Verify

Se reutiliza `verification_operation_id` de TASK-013.

Retry del mismo verification operation:

- no consume otro intento;
- no crea otro `SessionGrant` lógico;
- reconcilia el resultado previo.

### 18.4 Future RF-012 continuation / completion

Las futuras operaciones side-effecting que continúen RF-012 deben poseer operation correlation durable suficiente para retry/reconciliation.

Mismo operation ID de una operación futura:

```text
→ same logical result
→ no duplicate Auth identity / PlatformUser
→ no duplicate CompanyMembership when that membership is materialized
→ no duplicate USER_CREATED when its required transition occurs
```

Un operation ID distinto no puede eludir la eventual completion evidence del intent ni habilitar un segundo first-admin outcome.

ADR-0020 no fija cómo se divide esa correlación entre identity provisioning, profile completion y tenant-authority enablement; la futura TASK debe hacerlo sin romper el binding tenant/email/purpose.

### 18.5 Concurrent initial intent

Dos calls concurrentes para la misma `MaintenanceCompany` no pueden establecer dos intents first-admin competidores.

La base debe imponer una exclusión autoritativa equivalente a:

```text
one MaintenanceCompany
→ at most one first-admin onboarding intent capable of reaching completion
```

### 18.6 Concurrent resend

Dos resends distintos sobre el mismo current challenge:

```text
at most one successor accepted
```

El winner actualiza el current challenge del intent. El loser no crea una segunda emisión usable.

### 18.7 Verify vs resend

Debe existir un único orden serializable sobre intent + current challenge.

Si resend gana:

```text
old challenge verify = DENY
```

Si verify/consume gana:

```text
resend of consumed current challenge = DENY
```

No se permiten ambos efectos incompatibles.

### 18.8 Concurrent first-admin continuation / completion

Dos operaciones concurrentes sobre el mismo intent no pueden producir dos resultados incompatibles ni dos first-admin completion outcomes.

Cuando la futura TASK materialice la transición de alta de usuario/membership y la eventual habilitación tenant:

- como máximo un flujo puede confirmar el completion autoritativo;
- no pueden producirse dos `USER_CREATED` para la misma alta lógica;
- un loser reconcilia el resultado ya confirmado o falla cerrado;
- ninguna operación puede seleccionar otro tenant;
- ninguna puede habilitar autoridad tenant antes de profile completion.

### 18.9 Ambiguous continuation

Un timeout no se interpreta como failure definitivo.

Mientras el outcome de una operación posterior sea ambiguo:

- no se inicia una segunda intención first-admin;
- no se genera automáticamente una nueva emisión;
- se reconcilia primero la misma operation correlation;
- tenant/email/purpose permanecen inmutables;
- no se presume onboarding completion ni tenant authority habilitada.

Sólo después de establecer un failure definitivo puede una interacción autorizada iniciar una nueva business-code emission si sigue siendo necesaria.

## 19. Atomicity

### 19.1 Operaciones que deben ser atómicas en PostgreSQL

Deben compartir una transaction boundary:

1. intent establishment + first challenge issuance + current challenge binding;
2. resend predecessor transition + successor issuance + intent current-challenge update;
3. intent binding validation + challenge consume + `SessionGrant` creation;
4. cuando la futura TASK determine la transición exacta que, después de profile completion, habilita tenant authority: esa authoritative onboarding-completion mutation + el `USER_CREATED` requerido para la alta correspondiente + el intent terminal completion deben coordinarse de forma atómica para que no exista completion parcial ni autoridad habilitada sin la trazabilidad requerida.

ADR-0020 **no decide** si `PlatformUser` o `CompanyMembership` se crean antes, durante o después de profile completion, ni inventa una membership pre-profile disabled. Sólo fija que la futura transición que habilite autoridad tenant debe respetar:

```text
valid verification
→ profile completed
→ membership / tenant authority enabled
```

### 19.2 Auth Admin no participa en mega-transacción

`auth.admin.createUser` y operaciones provider-side de ADR-0019 no pueden participar en una transaction PostgreSQL atómica con las filas de aplicación.

Se preserva una composición por pasos idempotentes y reconciliables, sin convertirla en una secuencia de tenant-authority enablement ya cerrada por este ADR:

```text
consumed proof / SessionGrant + authoritative onboarding handoff
→ ADR-0019 purpose-specific Auth identity/session continuation as required
→ future RF-012 profile completion
→ future authoritative onboarding-completion / tenant-authority-enabling transition
```

El orden físico exacto de `PlatformUser` / `CompanyMembership` respecto de profile completion queda para la futura TASK, sujeto a los invariantes anteriores.

La implementación no debe simular una distributed transaction con locks largos, two-phase commit o un microservice coordinator.

### 19.3 Auth provider success + later DB failure

Si Auth user creation confirma o puede haber confirmado y luego falla una operación DB posterior del flujo:

- no se repite `createUser` ciegamente;
- se reconcilia mediante la estrategia permitida por TASK-013;
- se reintenta la misma operation correlation aplicable;
- no se crea otra first-admin intent;
- no se cambia tenant/email/purpose;
- la existencia del Auth user no se interpreta como onboarding completion ni como tenant authority habilitada.

### 19.4 Proof/handoff confirmed + session failure

Si challenge consume + `SessionGrant` + authoritative onboarding handoff confirman y luego session establishment falla:

- no se reactiva el challenge consumido;
- no se declara first-admin onboarding completed;
- no se habilita tenant authority por inferencia;
- el handoff permanece reconciliable conforme a E2;
- session retry/recovery debe preservar el mismo tenant/email/purpose binding;
- una sesión posteriormente establecida sólo permite continuar el futuro RF-012 flow; no salta profile completion ni FL-01 step 8.

## 20. Data API / RLS / grants

### 20.1 Ownership y RLS

La nueva entidad es platform-owned.

Debe tener RLS habilitada como defense-in-depth para negar Data API general, siguiendo el patrón de las tablas platform-owned de TASK-013.

No se crean tenant policies artificiales sobre el intent.

### 20.2 Direct table access

Debe quedar conceptualmente:

```text
anon = no direct CRUD
authenticated = no direct CRUD
PUBLIC = no direct CRUD
browser = no direct DB mutation
```

El intent no es enumerable por email ni por company ID mediante Data API.

### 20.3 Purpose-specific boundaries

Se requieren funciones/boundaries estrechas para, conceptualmente:

- establish first-admin intent + first challenge;
- resend current first-admin challenge;
- verify current first-admin challenge against binding;
- future RF-012 continuation/reconciliation, sin fijar todavía profile/membership activation sequence.

Los nombres físicos exactos quedan para la implementation task y no forman parte de este ADR.

### 20.4 Caller-scoped issue/resend

Issue/resend iniciados por `SUPER_ADMIN` deben preferir una boundary que preserve la identidad caller (`auth.uid()`) y revalide current global authority dentro de DB, siguiendo TASK-014/TASK-016.

### 20.5 Pre-auth verify boundary

Verify ocurre antes de que el target first admin disponga de sesión válida. Debe entrar por una boundary application server-side purpose-specific que sólo pueda invocar las primitives estrechas aprobadas de challenge/intent.

No se exporta un raw privileged Supabase client.

Una backend secret, cuando sea técnicamente necesaria para ejecutar la role server-side ya aprobada por TASK-013, permanece confinada al módulo Identity & Auth y no se convierte en ordinary request client ni tenant bypass.

### 20.6 Grants

La implementation futura debe demostrar:

- no `PUBLIC EXECUTE` sobre primitives privilegiadas;
- no `anon` direct table access;
- no `authenticated` direct table writes;
- EXECUTE mínimo sobre signatures exactas donde corresponda;
- ninguna nueva capability de lectura/escritura tenant para `supabase_auth_admin`;
- no grants generales a `service_role` como API de aplicación;
- ninguna exposición browser de secret/admin credentials.

## 21. PII / privacy

### 21.1 Minimización

El intent persiste únicamente el target email necesario para el binding y para la correlación con challenge/Auth.

No se añade por este ADR:

- nombre de perfil;
- teléfono;
- datos comerciales;
- client scope;
- payload genérico JSON;
- copia de tokens;
- plaintext code.

### 21.2 Uniqueness

No se introduce uniqueness global del target email a nivel de intent.

La protección contra doble tenant membership se mantiene en el modelo `PlatformUser → 0..1 CompanyMembership` y en la futura onboarding-completion boundary fail-closed; este ADR no fija cuándo se crea o habilita esa membership respecto del profile.

### 21.3 Logging

No deben registrarse en logs ordinarios:

- código;
- verifier;
- full target email cuando no sea necesario;
- provider secret;
- technical password;
- access/refresh tokens.

Los logs deben utilizar IDs técnicos, outcome bounded y redacción/minimización apropiada.

### 21.4 Enumeration

Errores de issue/resend/verify no deben revelar si un email ya existe en Auth, si existe un intent para otra empresa o si un challenge ID pertenece a otro target.

Los outcomes externos deben ser bounded y no permitir enumeración de PII.

### 21.5 Retention

El canon no fija una política temporal de borrado del target email en onboarding intent.

ADR-0020 no inventa una retention period ni una política de hard-delete.

Si una política de privacidad posterior exige retención/eliminación específica:

```text
OPEN PRODUCT / PRIVACY DECISION REQUIRED
```

según el Gate aplicable.

## 22. Audit implications

### 22.1 Issue

No se introduce `AuditEvent` funcional para issue por este ADR.

### 22.2 Resend

No se introduce `AuditEvent` funcional para resend por este ADR.

### 22.3 Verification

No se introduce `AuditEvent` funcional para verification por este ADR.

Estas tres decisiones preservan ADR-0019/TASK-013, que no auditan artificialmente cada challenge/grant y dejaron esos producers fuera de la foundation.

### 22.4 Future authoritative user/membership transition

`USER_CREATED` permanece como la action existente requerida para la **alta de usuario**.

ADR-0020 no decide que esa action deba producirse inmediatamente después del challenge consume, de Auth user creation o antes de profile completion.

Cuando la futura TASK materialice la transición autoritativa de alta de usuario/membership correspondiente, debe producir exactamente el `AuditEvent` existente:

```text
USER_CREATED
```

sin inventar una nueva action, y ese event debe coordinarse atómicamente con la mutación autoritativa a la que audita conforme al canon.

La futura TASK deberá ubicar esa transición dentro de un lifecycle que respete `verificación válida → perfil completado → membership habilitada`.

### 22.5 Actor histórico

El intent debe conservar provenance suficiente para identificar el `SUPER_ADMIN` que inició autoritativamente el alta.

Esa referencia histórica:

```text
!= current authority
```

Puede utilizarse para el `AuditEvent` de alta cuando corresponda, aun si el actor perdió autoridad después. La pérdida posterior no reescribe quién inició la acción.

No se utiliza el target user como actor por inferencia para reemplazar al initiator global.

## 23. Offline implications

```text
first-admin intent establish = ONLINE ONLY
issue = ONLINE ONLY
resend = ONLINE ONLY
verify = ONLINE ONLY
future RF-012 continuation/completion = ONLINE ONLY
session establishment = ONLINE ONLY
```

No se crean:

- Dexie entities;
- IndexedDB replica;
- outbox;
- offline authorization lease;
- cached challenge authority;
- cached onboarding-completion authority;
- Service Worker flow para onboarding.

Pérdida de conectividad se resuelve mediante retry/reconciliation online con la misma operation correlation cuando el outcome sea ambiguo.

## 24. Failure model

### 24.1 Mail delivery failure

Authoritative issuance y email delivery son fronteras distintas.

La nueva business-code emission ocurre formalmente cuando la transacción PostgreSQL que crea el nuevo `VerificationChallenge` y lo establece como current del intent **commits**.

El delivery ocurre después del commit.

Si delivery falla:

```text
challenge emission = EXISTS
challenge lifecycle = unchanged
delivery = not confirmed / failed side effect
```

No se hace rollback lógico de la emisión sólo porque el provider de email falle.

### 24.2 Delivery retry

Un retry técnico de delivery del **mismo código ya emitido** no constituye una nueva business-code emission y no debe consumir otro presupuesto de intentos.

Este ADR no autoriza almacenar plaintext code para permitir retries tardíos.

Mientras el código exista únicamente en memoria dentro de la misma ejecución server-side, el adapter de delivery puede intentar entregar esa misma emisión conforme a su política técnica.

Si el material del código ya no está disponible después de un failure/timeout, no se reconstruye ni se persiste plaintext por conveniencia. La recuperación funcional usa un resend autorizado que crea una **nueva emisión** conforme a RF-008/RF-009.

La selección de proveedor, retry policy y eventual durable delivery-attempt/outbox quedan como:

```text
TASK-level provider implementation decision
```

siempre que no alteren la definición anterior de business emission.

### 24.3 DB mutation failure antes de commit

```text
intent/challenge transaction rollback
→ no authoritative emission
→ delivery must not be treated as confirmed business issuance
```

La implementation debe ordenar la side effect para que un email no sea la fuente de verdad de que existe un challenge.

### 24.4 Response timeout después de DB commit

No asumir failure.

Retry con la misma operation correlation debe reconciliar intent/challenge ya existentes después de revalidar autoridad actual cuando aplique.

No se crea automáticamente un código nuevo para resolver un timeout ambiguo.

### 24.5 Duplicate operation ID

Un duplicate operation ID del mismo use case:

- reconcilia la misma operación lógica;
- no cambia tenant/email/purpose;
- no crea una emisión adicional;
- no repone attempts;
- no concede authority.

### 24.6 Challenge consumed + downstream continuation failure

El challenge permanece consumed y no se reactiva.

Una falla posterior al business proof puede ocurrir en identity/session continuation, profile flow o en la eventual transición que habilite tenant authority. Ninguna de esas fallas convierte el proof consumido en onboarding completion.

La operación futura debe reconciliar primero cualquier side effect Auth/DB ambiguo utilizando la misma operation correlation aplicable y preservando tenant/email/purpose.

Si el failure es definitivo y una interacción posterior requiere nueva business-code emission, esa emisión:

- exige autoridad actual para issue;
- recibe nuevo `issue_operation_id`;
- se convierte en current challenge del mismo intent;
- no reactiva el challenge consumido;
- no implica que el onboarding anterior haya quedado completed.

### 24.7 Provider operation succeeded, DB operation failed

No repetir provider creation ciegamente.

Reconciliar conforme a TASK-013 y reanudar la misma continuación autoritativa desde el intent/handoff. La mera existencia de Auth identity no habilita tenant authority ni marca completion.

### 24.8 Concurrent callers

Todas las mutations relevantes deben serializar o condicionar el estado mínimo necesario de intent/challenge/handoff y, cuando exista, de la futura completion transition, sin introducir lock global de plataforma.

Concurrencia no puede producir dos first-admin completion outcomes ni autoridad tenant antes de profile completion.

### 24.9 Stale authority

Issue/resend fail closed contra current DB authority.

Verify no depende de stale issuer authority.

La continuación futura de RF-012 no obtiene authority desde claims, email, challenge aislado, `SessionGrant` ni Auth identity aislada; deriva tenant/target/purpose desde el intent y sólo habilita tenant authority mediante la futura completion transition posterior a profile completion.

### 24.10 Stale tenant state

El canon actual no posee una state machine `active/suspended` en `MaintenanceCompany`; TASK-016 considera activa la identidad creada porque no introduce un estado inactive.

La futura continuación/completion exige que la `MaintenanceCompany` referenciada siga existiendo y que no exista un estado autoritativo incompatible con el bootstrap first-admin.

Si una decisión posterior introduce un estado autoritativo de elegibilidad/suspensión aplicable a onboarding, la future implementation debe consumirlo. ADR-0020 no inventa ese estado.

## 25. Threat model

| Threat | Impact | Control | Remaining risk |
|---|---|---|---|
| Cross-tenant confused deputy | Crear admin de tenant B usando proof de tenant A | Tenant sólo deriva del intent; provisioning no acepta tenant authority externa | Compromiso del intent boundary |
| Wrong-company provisioning | Usuario termina como admin de empresa equivocada | Intent immutable binding a una company + challenge current | Error humano al seleccionar company durante intent establishment; requiere UI/test claros |
| Challenge replay | Reutilizar code consumido | TASK-013 terminal consume + intent current binding | Compromiso DB/key material |
| Cross-intent replay | Challenge de intent X aplicado a intent Y | Verify exige current challenge exacto del intent + email equality | Compromiso de DB boundary |
| Successor challenge race | Dos resends current | TASK-013 one successor + atomic pointer update | DoS residual por requests repetidas |
| Verify-vs-resend race | Old code aceptado después de resend | Single serialized decision sobre intent/current challenge | Implementación incorrecta de lock/order |
| Unauthorized resend | Actor sin global authority rota código | Re-evaluate current SUPER_ADMIN dentro de mutation | Stolen valid SUPER_ADMIN session hasta revocation DB check |
| Stale SUPER_ADMIN authority | Claim antiguo permite issue | DB-authoritative TASK-014 on every issue/resend | DB compromise |
| Target email enumeration | Revelar pending onboarding/account | No direct SELECT; bounded generic errors; no email listing | Timing/operational leakage a probar |
| Challenge enumeration | Targeting/DoS | IDs not authority; no Data API CRUD; purpose-specific server boundary | Endpoint abuse/rate limiting remains implementation concern |
| Operation-id replay | Crear o reconciliar sin authority | Operation IDs are correlation only; authority rechecked | UUID disclosure may aid DoS, not authority |
| Concurrent first-admin completion | Crear dos primeros admins | one intent per company + eventual terminal completion evidence + future authority-enabling transition atomicity | DB constraint/locking bug |
| Privilege escalation to COMPANY_ADMIN | Arbitrary role/tenant injected | Role implicit/fixed by intent purpose; tenant derived from intent | Purpose boundary compromise |
| Premature tenant authority before profile completion | Valid proof, Auth identity or session is misread as enabled admin authority | Contract requires future RF-012 / FL-01 steps 6–8 completion, including profile completion, before membership/tenant authority is enabled | Future implementation bug in authority-enabling transition |
| Creating two first admins accidentally | Duplicate intent or duplicate completion | company-level uniqueness + eventual terminal completion + no duplicate USER_CREATED when the future user/membership transition occurs | Manual data corruption outside supported path |
| Direct DB/Data API bypass | Browser writes intent/member directly | RLS enabled; no direct CRUD; exact EXECUTE only | Misconfigured grants/policies |
| Supabase Auth public-method bypass | Obtain session without business proof | ADR-0019 Custom Access Token gate + public signup disabled | Secret/hook compromise |
| Generic privileged boundary abuse | Lateral tenant/admin mutation | No raw privileged client; closed purpose-specific operations | Backend secret compromise |
| Email-as-authority | Attacker supplies matching email and tenant | Email only locator; intent + challenge + DB invariants required | Email account compromise remains proof-model risk |
| Challenge-as-authority | Valid code chooses tenant | Challenge never contains/chooses tenant; intent binding required | Intent boundary compromise |
| SUPER_ADMIN implicit membership | Global actor becomes tenant admin | Only the bound target identity may eventually receive first-admin membership through the future RF-012 lifecycle; creator never receives membership | Manual privileged DB mutation outside supported path |
| Audit spoofing | Incorrect actor/company in USER_CREATED | actor provenance + company derived from intent + DB-generated event fields | Privileged DB compromise |

## 26. Security invariants

**SI-0020-001 — Tenant isolation.** `MaintenanceCompany` continúa siendo la frontera tenant; ningún first-admin flow permite elegir otro tenant después de establecer el intent.

**SI-0020-002 — Current state.** PostgreSQL current state prevalece sobre claims, JWT, cookies, frontend y caches.

**SI-0020-003 — Challenge not authority.** Un `VerificationChallenge` válido no concede tenant, role ni provisioning authority por sí solo.

**SI-0020-004 — Email not authority.** El email es PII/locator/proof target, no autoridad.

**SI-0020-005 — Single intended tenant.** Cada intent referencia exactamente una `MaintenanceCompany` estable.

**SI-0020-006 — Single purpose.** El purpose es exclusivamente first-admin onboarding y no es caller-selectable.

**SI-0020-007 — No implicit membership.** El `SUPER_ADMIN` iniciador no recibe `CompanyMembership`.

**SI-0020-008 — Issue authorization.** Primera emisión exige current authoritative `SUPER_ADMIN`.

**SI-0020-009 — Resend authorization.** Cada resend exige current authoritative `SUPER_ADMIN` nuevamente.

**SI-0020-010 — Proof/handoff separation.** Proof de email y authoritative onboarding handoff son distintos de onboarding completion y de tenant authority habilitada.

**SI-0020-011 — Current challenge.** Sólo el challenge current del intent puede entregar proof para ese intent.

**SI-0020-012 — Replay prevention.** Challenges terminales, operation IDs repetidos e intents con onboarding completion autoritativo no se reutilizan para producir un segundo alta.

**SI-0020-013 — Idempotency.** Retry de la misma operación reconcilia el mismo resultado y nunca amplía authority.

**SI-0020-014 — Concurrent safety.** Carreras issue/resend/verify/continuation/completion no pueden producir dos emisiones current ni dos first-admin completion outcomes.

**SI-0020-015 — RLS/grants.** Platform tables usan RLS defense-in-depth y no general Data API CRUD.

**SI-0020-016 — Browser prohibition.** Browser/PWA no poseen direct DB mutation de intent/challenge/onboarding-completion state.

**SI-0020-017 — Privilege minimization.** Toda elevación técnica se confina a purpose-specific boundary con capabilities cerradas.

**SI-0020-018 — No generic privileged client.** No se exporta client secret/service-role/admin genérico para requests ordinarias.

**SI-0020-019 — Supabase Auth methods are not authority.** Public OTP/magiclink/recovery/signup no sustituyen business proof ni el binding.

**SI-0020-020 — No arbitrary role.** La continuación first-admin no acepta role caller-supplied; `COMPANY_ADMIN` es el role objetivo del purpose fijo, pero no queda habilitado antes del lifecycle futuro correspondiente.

**SI-0020-021 — No arbitrary tenant.** Ninguna continuación/completion first-admin acepta tenant caller-supplied como autoridad.

**SI-0020-022 — Audit obligation.** Cuando la futura TASK materialice la transición autoritativa de alta de usuario/membership correspondiente, debe producir `USER_CREATED` atómicamente con la mutación que audita; issue/resend/verify no reciben events nuevos por este ADR.

**SI-0020-023 — No commercial inference.** Intent/challenge/handoff/completion no determinan Subscription, entitlement ni promotional anchor.

**SI-0020-024 — Proof/session not tenant authority.** Valid challenge, consumed proof, `SessionGrant`, Auth identity o Supabase session no equivalen a enabled tenant authority.

**SI-0020-025 — Profile before enabled first-admin authority.** La autoridad tenant habilitada del primer `COMPANY_ADMIN` requiere completar el futuro lifecycle RF-012 / FL-01 steps 6–8; ADR-0020 no permite habilitarla antes de profile completion.

## 27. Migration / backfill implications

### 27.1 Nueva entidad

La decisión requiere una nueva representación física purpose-specific para `FirstAdminOnboardingIntent`.

El nombre físico exacto de tabla y columnas se define en la future implementation task; la arquitectura exige que pueda representar como mínimo:

- stable intent identity;
- `MaintenanceCompany` binding;
- target email;
- historical initiator provenance;
- current challenge binding;
- idempotency correlation para establishment;
- durable distinction between verified handoff and eventual onboarding completion;
- eventual single-use completion evidence sufficient to prevent a second completed first-admin outcome, without fixing the exact membership/profile sequence.

No se exige un status enum si los invariantes pueden derivarse de facts/nullable terminal references de forma inequívoca.

### 27.2 Additive change

El cambio puede ser additive.

No requiere reescribir:

- `verification_challenges` para añadir tenant/role;
- `maintenance_companies` con onboarding state;
- `company_memberships` existentes;
- `platform_users.is_super_admin`;
- ADR-0019 artifacts.

### 27.3 Backfill

No existe población funcional first-admin onboarding previa a TASK-016/CORR-026.

Por tanto no se inventa backfill histórico de intents.

Existing `MaintenanceCompany` rows creadas como foundation/fixtures o por TASK-016 sin first-admin onboarding completion no reciben una intención ficticia automáticamente.

Una future implementation deberá decidir qué filas reales deben iniciar el flujo únicamente mediante un use case autorizado, no por migration que fabrique intent histórica.

### 27.4 Transitional compatibility

No se requiere dual-write entre company fields e intent entity porque OPTION B se rechaza.

Durante rollout, el nuevo use case debe fallar cerrado si la entity/boundaries requeridas no están disponibles.

## 28. Rejected alternatives

### 28.1 Tenant/role dentro de VerificationChallenge

**REJECTED.** Contradice ADR-0019/TASK-013 y convertiría una proof platform-owned en portadora de contexto tenant/role.

### 28.2 JWT/custom claims como binding

**REJECTED.** Estado stale y no autoritativo.

### 28.3 Email como tenant lookup authority

**REJECTED.** El mismo email no puede elegir tenant; email es locator/PII.

### 28.4 Direct browser/Data API mutation

**REJECTED.** Violenta la frontera server-side/purpose-specific y amplía superficie de privilege.

### 28.5 Generic service-role/admin client

**REJECTED.** Una credencial privilegiada no demuestra authority y amplía blast radius.

### 28.6 Implicit SUPER_ADMIN membership

**REJECTED.** Contradice modelo global/tenant y RLS.

### 28.7 OPTION B — fields on MaintenanceCompany

**REJECTED.** Mezcla tenant identity con state temporal de Identity/Auth, introduce PII/proceso en la entidad central y vuelve cada retry/resend una mutación de la fila tenant.

### 28.8 OPTION C — association without principal intent

**REJECTED.** Para demostrar single-use, current challenge, idempotencia, provisioning result y actor histórico la asociación terminaría necesitando identidad/lifecycle propios; en ese punto es una versión menos explícita de OPTION A.

### 28.9 OPTION D — Auth artifacts as onboarding binding

**REJECTED.** `SessionGrant` nace después del proof, `AuthBridgeCredential` tiene otra responsabilidad y `VerificationChallenge` no puede recibir tenant/role. Reutilizarlos crearía confused deputy y acoplaría onboarding a la session mechanism.

### 28.10 Microservice de onboarding

**REJECTED.** No existe necesidad demostrada; el problema cabe en el monolito modular + Supabase.

## 29. Consequences / trade-offs

### 29.1 Consecuencias positivas

- tenant/email/purpose binding queda explícito y auditable;
- challenge permanece limpio y platform-owned;
- no se modifica ADR-0019;
- current challenge rotation puede ser transaccional;
- provisioning deriva tenant sin caller-supplied authority;
- first-admin single-use puede probarse físicamente;
- PII queda confinada a una entidad purpose-specific;
- migrations pueden ser additives;
- la future implementation puede dividirse en slices pequeños.

### 29.2 Costes

- se añade una entidad física y nuevas purpose-specific functions;
- verify/resend deben coordinar dos aggregates técnicos: intent + challenge;
- los fallos provider/DB requieren reconciliation explícita;
- el lifecycle debe probar races adicionales;
- delivery failure sigue siendo una side effect no atómica con DB.

### 29.3 Trade-off aceptado

Se acepta una entidad adicional porque reduce privilege ambiguity y hace verificables invariantes que serían implícitas o frágiles si se escondieran en `MaintenanceCompany` o en artifacts Auth.

## 30. Relationship with ADR-0019

ADR-0019/E2 permanece intacta.

ADR-0020 se ubica **antes y alrededor** de la foundation E2 para aportar el binding de negocio que ADR-0019 deliberadamente no contiene.

```text
FirstAdminOnboardingIntent
→ authorizes/binds business issue context
→ current VerificationChallenge
→ TASK-013 consume + SessionGrant
→ authoritative onboarding handoff
→ ADR-0019 Auth identity/session boundary as required
→ future RF-012 profile completion
→ future tenant-authority enablement
```

ADR-0020 no cambia:

- application-owned challenge;
- 8h;
- 3 attempts;
- resend successor rules;
- keyed verifier;
- challenge single-use;
- `SessionGrant` purpose/auth_method;
- technical password bridge;
- Custom Access Token Hook;
- public method default-deny;
- purpose-specific Auth Admin boundary;
- secret handling.

## 31. Relationship with TASK-009..016

### TASK-009

Se reutilizan `PlatformUser`, `CompanyMembership`, tenant identity, membership cardinality y RLS foundations. No se cambia la regla `PlatformUser → 0..1 CompanyMembership`.

### TASK-010

Se reutiliza `AuditEvent` y la action existente `USER_CREATED`. No se crean action names nuevas.

### TASK-011

Se preserva SSR Auth lifecycle; no se convierte cookies/session en authority.

### TASK-012

Se preserva current authoritative tenant authorization para usuarios ya tenant. First-admin bootstrap no falsifica una membership previa.

### TASK-013

Se reutilizan challenge/grant/idempotency/concurrency/Auth boundaries. Se añade un binding externo, no campos tenant en challenge.

### TASK-014

Issue/resend consumen current global authority. `SUPER_ADMIN` continúa global-only y sin tenant bypass.

### TASK-015

No se reutiliza el lifecycle ordinario de membership como si pudiera crear la membership inicial. TASK-015 sigue siendo disable/reinstate/role-change posteriores.

### TASK-016

Se consume la `MaintenanceCompany` ya creada y activa en el sentido acotado de TASK-016. ADR-0020 comienza después de FL-01 step 2 y no reinterpreta TASK-016 como onboarding completo.

## 32. Impact on future implementation boundary

Una vez ADR-0020 sea revisada, aprobada, canonicalizada e incorporada mediante sus Gates, quedará arquitectónicamente disponible un candidate boundary equivalente a:

```text
first-admin onboarding intent establishment
+
authorized invitation issue/resend binding
+
current VerificationChallenge correlation
+
secure authoritative handoff toward RF-012 after valid challenge consume
```

Ese candidate boundary no constituye determinación de TASK-017. Tampoco especifica profile completion, el momento exacto de creación de `CompanyMembership` ni la transición concreta que habilita tenant authority.

La aceptación futura de ADR-0020:

```text
!= TASK-017 authorization
!= TASK-017 generation
!= implementation authorization
```

El Revisor Central deberá determinar por Gate separado cuál es el siguiente incremento PR-sized.

## 33. Explicit non-goals

ADR-0020 no:

- implementa TASK-017;
- genera TASK-017;
- autoriza Codex;
- modifica repositorio;
- escribe SQL ejecutable;
- escribe migration;
- escribe RLS ejecutable;
- selecciona proveedor de email;
- implementa delivery;
- implementa UI;
- completa RF-012;
- completa FL-01 steps 6–8;
- implementa profile completion;
- implementa login funcional completo;
- implementa lifecycle ordinario de nuevos tenant users;
- crea `UserClientAccess`;
- crea `SupportAccessGrant`;
- cambia email durante onboarding;
- define cancel/restart UX;
- define máximo de resends;
- define expiry independiente del intent;
- define PII deletion period;
- crea nuevos roles;
- crea nuevos estados comerciales;
- crea nueva action de `AuditEvent`;
- resuelve Subscription;
- crea promotional entitlement;
- resuelve PAY-OPEN-001;
- resuelve PAY-OPEN-008;
- selecciona commercial anchor;
- modifica ADR-0019;
- introduce microservices.

## 34. Acceptance Criteria

### Governance / sources

**AC-0020-001.** El ID es exactamente `ADR-0020`.

**AC-0020-002.** El título es exactamente `ADR-0020 — Authoritative first-admin onboarding intent binding`.

**AC-0020-003.** TASK-016, CORR-026 y el `11-phase-1-scope-entry-gate.md` post-CORR-026 fueron verificados contra sus SHA-256 canónicos antes de redactar la decisión.

**AC-0020-004.** La specification no utiliza una copia histórica de esas tres fuentes como sustituto del current canon.

**AC-0020-005.** RF-003..RF-011 y FL-01 steps 3–5 se consumen sin redefinición.

**AC-0020-006.** RF-012 y FL-01 steps 6–8 se mantienen como consumidores posteriores, no como implementación autorizada.

### Decision / domain

**AC-0020-007.** Se comparan al menos OPTION A, B, C y D antes de seleccionar.

**AC-0020-008.** Se selecciona una entidad purpose-specific separada `FirstAdminOnboardingIntent`.

**AC-0020-009.** `FirstAdminOnboardingIntent` queda clasificada platform-owned.

**AC-0020-010.** La entidad posee identidad estable distinta de company, challenge, email, grant y Auth subject.

**AC-0020-011.** Una `MaintenanceCompany` no puede tener dos first-admin intents competidores capaces de provisionar.

**AC-0020-012.** El target email permanece PII/locator y no authority.

**AC-0020-013.** No se introduce uniqueness global del email en intent.

**AC-0020-014.** El purpose first-admin es fijo y no caller-selectable.

**AC-0020-015.** No se crea un role mutable en intent o challenge.

**AC-0020-016.** No se introduce expiry independiente del intent.

### VerificationChallenge compatibility

**AC-0020-017.** `VerificationChallenge` continúa platform-owned.

**AC-0020-018.** El challenge no contiene `maintenance_company_id` ni `tenant_id`.

**AC-0020-019.** El challenge no contiene membership, role ni client scope.

**AC-0020-020.** ADR-0019/E2 permanece sin reapertura.

**AC-0020-021.** TASK-013 expiry/attempt/resend/single-use semantics permanecen intactas.

### Binding / confused deputy

**AC-0020-022.** El intent vincula exactamente una company, un target email y un current challenge.

**AC-0020-023.** El authoritative handoff y toda continuación/completion first-admin derivan `MaintenanceCompany` desde intent y no desde request.

**AC-0020-024.** Un valid challenge para email A más tenant B arbitrario no puede provisionar B.

**AC-0020-025.** Un challenge de intent X no puede utilizarse para intent Y.

**AC-0020-026.** Sólo el current challenge del intent puede entregar proof para ese intent.

### Issue / resend authority

**AC-0020-027.** Primera emisión exige current authoritative `SUPER_ADMIN`.

**AC-0020-028.** Cada resend reevalúa current authoritative `SUPER_ADMIN`.

**AC-0020-029.** Claims/JWT/frontend no otorgan authority de issue/resend.

**AC-0020-030.** Si `SUPER_ADMIN` pierde autoridad antes de confirmar issue/resend, la operación se deniega sin mutation.

**AC-0020-031.** Un retry idempotente no devuelve success privilegiado después de perder authority actual.

**AC-0020-032.** La pérdida de authority posterior a issue no convierte challenge en authority ni autoriza nuevos resends.

### Idempotency / concurrency

**AC-0020-033.** Intent establishment posee operation correlation durable.

**AC-0020-034.** Mismo establishment operation ID no crea segundo intent ni segundo first challenge.

**AC-0020-035.** Issue/resend reutiliza `issue_operation_id` semantics de TASK-013.

**AC-0020-036.** Verify reutiliza `verification_operation_id` semantics de TASK-013.

**AC-0020-037.** Las futuras operaciones side-effecting que continúen RF-012 deben poseer operation correlation durable suficiente para retry/reconciliation sin cambiar tenant/email/purpose.

**AC-0020-038.** Dos resends concurrentes producen como máximo un successor current.

**AC-0020-039.** Verify-vs-resend produce un único winner serializable.

**AC-0020-040.** Dos continuaciones/completions concurrentes sobre el mismo intent producen como máximo un first-admin onboarding completion autoritativo y nunca habilitan tenant authority antes de profile completion.

**AC-0020-041.** Retry después de un side effect o completion confirmado reconcilia el mismo resultado y no duplica Auth identity, `PlatformUser`, `CompanyMembership` ni `USER_CREATED` cuando esas entidades/eventos sean materializados por la futura TASK; su momento respecto del profile no queda fijado aquí.

### Atomicity / failures

**AC-0020-042.** Intent creation + first challenge issue + current binding comparten transaction PostgreSQL.

**AC-0020-043.** Resend invalidation + successor issue + current pointer update comparten transaction PostgreSQL.

**AC-0020-044.** Intent binding check + challenge consume + SessionGrant creation forman una única decisión atómica o composición equivalente.

**AC-0020-045.** Cuando la futura TASK determine la transición que habilita tenant authority después de profile completion, esa authoritative onboarding-completion mutation, el `USER_CREATED` requerido para la alta correspondiente y el intent terminal completion deben coordinarse atómicamente; ADR-0020 no fija una `CompanyMembership` habilitada pre-profile.

**AC-0020-046.** Auth Admin no se presenta como participante de una mega-transacción PostgreSQL.

**AC-0020-047.** `createUser` response lost se reconcilia y no se repite ciegamente.

**AC-0020-048.** Challenge consumed + cualquier falla posterior de identity/session/profile/completion no reactiva el challenge ni convierte el flow en onboarding completed; la continuación se reconcilia desde el authoritative handoff.

**AC-0020-049.** Timeout ambiguo se reconcilia antes de iniciar otra business emission.

### Delivery

**AC-0020-050.** Business-code emission se define por commit de authoritative challenge issuance, no por aceptación del provider de email.

**AC-0020-051.** Delivery side effect ocurre fuera de la transaction de issuance.

**AC-0020-052.** Retry técnico del mismo delivery no constituye nueva business emission.

**AC-0020-053.** Este ADR no autoriza plaintext code persistence para delivery retry.

**AC-0020-054.** Cuando el código ya no está disponible y debe enviarse otro, se usa resend autorizado que crea nueva emisión e invalida la anterior conforme al lifecycle aplicable.

**AC-0020-055.** No se selecciona Resend, SMTP, Supabase email provider ni otro provider.

### Data API / privilege / RLS

**AC-0020-056.** La nueva entidad platform-owned usa RLS defense-in-depth.

**AC-0020-057.** `anon`, `authenticated` y `PUBLIC` no poseen direct CRUD general sobre intent.

**AC-0020-058.** Browser direct DB mutation permanece prohibida.

**AC-0020-059.** No se crea tenant RLS artificial para la entidad platform-owned.

**AC-0020-060.** No se exporta generic privileged client.

**AC-0020-061.** `service-role`/secret backend capability no se usa como ordinary request authority.

**AC-0020-062.** `supabase_auth_admin` no obtiene tenant privileges nuevos.

### Future RF-012 continuation / identity

**AC-0020-063.** La continuación first-admin no acepta role caller-supplied; el role objetivo `COMPANY_ADMIN` no equivale a membership habilitada antes de profile completion.

**AC-0020-064.** Ninguna continuación/completion first-admin acepta tenant caller-supplied como authority.

**AC-0020-065.** `SUPER_ADMIN` initiator no recibe implicit membership.

**AC-0020-066.** Existing incompatible membership/global identity falla cerrado.

**AC-0020-067.** El intent distingue durablemente business proof verified / authoritative handoff ready de eventual onboarding completion; la completion evidence sólo puede representar el futuro resultado post-profile que habilita first-admin tenant authority y debe impedir un segundo completed first-admin outcome.

### PII / audit

**AC-0020-068.** Email no se registra como authority ni se expone por enumeration API.

**AC-0020-069.** No se persiste plaintext code por ADR-0020.

**AC-0020-070.** El ADR no inventa retention period de PII.

**AC-0020-071.** Issue no recibe nuevo `AuditEvent` por este ADR.

**AC-0020-072.** Resend no recibe nuevo `AuditEvent` por este ADR.

**AC-0020-073.** Verification no recibe nuevo `AuditEvent` por este ADR.

**AC-0020-074.** Cuando la futura TASK materialice la transición autoritativa de alta de usuario/membership correspondiente, produce la action existente `USER_CREATED` atómicamente con la mutación que audita; ADR-0020 no obliga a producirla antes de profile completion.

**AC-0020-075.** No se inventa una nueva AuditEvent action.

### Offline / commercial / scope

**AC-0020-076.** Issue/resend/verify/provision/session establishment son online-only.

**AC-0020-077.** No se crea outbox/Dexie/offline intent para onboarding.

**AC-0020-078.** PAY-OPEN-001 permanece unresolved.

**AC-0020-079.** PAY-OPEN-008 permanece unresolved.

**AC-0020-080.** Ningún evento de company creation, issue, delivery, verify, handoff o future onboarding completion se declara commercial anchor.

**AC-0020-081.** No se implementa Subscription ni promotional entitlement.

**AC-0020-082.** No se genera TASK-017.

**AC-0020-083.** No se determina TASK-017.

**AC-0020-084.** La specification no autoriza implementación.

**AC-0020-085.** No se introduce microservice.

**AC-0020-086.** La futura implementación puede dividirse en work PR-sized sin requerir un generic framework.

**AC-0020-087.** Valid challenge, consumed proof, `SessionGrant`, Auth identity o session establecida NO equivalen a enabled tenant authority ni a first-admin onboarding completed.

**AC-0020-088.** Enabled first-admin tenant authority requiere el futuro lifecycle RF-012 / FL-01 steps 6–8 y no puede existir antes de profile completion.

Un único `FAIL` material impide aprobar arquitectónicamente ADR-0020.

## 35. Definition of Done

ADR-0020 sólo podrá considerarse completada como decisión arquitectónica cuando se satisfaga, sin saltos, la siguiente secuencia:

**DoD-0020-001 — Specification generation.** Esta specification inicial fue generada y queda `READY FOR CENTRAL REVIEW`.

**DoD-0020-002 — Central spec review.** El Revisor Central revisa íntegramente la specification y emite un resultado explícito.

**DoD-0020-003 — Human architecture approval.** Existe aprobación humana explícita de la decisión arquitectónica; review técnico no equivale automáticamente a aprobación humana.

**DoD-0020-004 — Approved artifact generation.** Después de aprobación humana se genera, mediante Gate separado, el artefacto aprobado correspondiente sin modificar la decisión silenciosamente.

**DoD-0020-005 — Canonicalization.** Existe Gate separado que autoriza convertir el artefacto aprobado en la versión canónica en la ruta prevista.

**DoD-0020-006 — Canonicalization review.** La identidad y contenido de la versión canónica son revisados y aprobados separadamente.

**DoD-0020-007 — Repository incorporation.** Existe Gate separado para incorporar físicamente el ADR canónico al repositorio; canonicalization no implica automáticamente commit/push.

**DoD-0020-008 — Incorporation review.** La incorporación al repositorio, identidad Git y ausencia de cambios inesperados son revisadas antes de declarar el ADR incorporado.

**DoD-0020-009 — Documentation state-sync.** Si la aceptación/incorporación de ADR-0020 deja referencias activas stale en documentos de estado, el Revisor Central determina una corrección documental separada; no se modifica documentación lateral por inferencia durante este ADR.

**DoD-0020-010 — Eventual implementation-task determination.** Sólo después de cerrar los Gates anteriores el Revisor Central puede determinar, mediante Gate independiente, si existe y cuál es la siguiente implementation task. ADR-0020 no asigna TASK-017.

Debe permanecer:

```text
specification generated
!= central review
!= human architecture approval
!= approved artifact
!= canonicalization
!= canonicalization review
!= repository incorporation
!= incorporation review
!= documentation state-sync
!= next implementation-task determination
```

## 36. Gate posterior

El único siguiente Gate autorizado por este artefacto es:

```text
ADR-0020 CANONICALIZATION REVIEW
```

No queda autorizado por este artefacto canónico candidato:

- repository incorporation;
- repository mutation;
- Codex;
- implementation;
- Supabase mutation;
- Hosted mutation;
- staging;
- commit;
- push;
- TASK-017 determination;
- TASK-017 generation.

Si el Revisor Central detecta una contradicción material con una fuente canónica posterior o una decisión de producto necesaria no existente, debe devolver la specification para corrección o declarar el blocker correspondiente.

## 37. Estado final de la specification

```text
ADR-0020 ATTACHED CANONICAL SOURCE VERIFICATION = PASS
SOURCE 1 identity = PASS
SOURCE 2 identity = PASS
SOURCE 3 identity = PASS
ADR-0020 SPECIFICATION BLOCKER = RESOLVED

ADR-0020 CANONICAL ARTIFACT = READY FOR CENTRAL REVIEW
ADR-0020 SPEC REVIEW = APPROVED
ADR-0020 HUMAN ARCHITECTURE APPROVAL = APPROVED
ADR-0020 architecture decision = ACCEPTED BY HUMAN APPROVAL
ADR-0020 APPROVED ARTIFACT REVIEW = APPROVED
ADR-0020 CANONICALIZATION REVIEW = NOT APPROVED
repository incorporated = NO
implementation authorized = NO
TASK-017 determined = NO
TASK-017 generated = NO
repository mutation = NO
Supabase mutation = NO
staging = NO
commit = NO
push = NO
```

No se declara:

```text
ADR-0020 CANONICALIZATION REVIEW = APPROVED
```

No se declara:

```text
ADR-0020 repository incorporated = YES
```

RETURN TO REVISOR CENTRAL.
