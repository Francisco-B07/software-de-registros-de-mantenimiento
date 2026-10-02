# TASK-020 — Authoritative Later-User Enrollment Intent, Verification and Handoff Foundation

## 1. Identificación

**ID:** `TASK-020`

**Título:** `TASK-020 — Authoritative Later-User Enrollment Intent, Verification and Handoff Foundation`

**Tipo:** `IMPLEMENTATION TASK SPECIFICATION`

**Fase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Bounded context principal:** `Identity & Authorization`

**Estado documental:** `HUMAN APPROVED / CANONICAL ARTIFACT GENERATED / PENDING CANONICALIZATION REVIEW`

**TASK-020 SPECIFICATION GENERATION:** `PASS`

**TASK-020 CORRECTED SPEC REVIEW:** `APPROVED`

**F-020-SPEC-001:** `CLOSED`

**TASK-020 HUMAN APPROVAL:** `APPROVED`

**TASK-020 approved artifact:** `REVIEW APPROVED`

**TASK-020 APPROVED ARTIFACT REVIEW:** `APPROVED`

**TASK-020 CANONICALIZATION:** `PASS`

**TASK-020 canonical artifact:** `GENERATED / PENDING CANONICALIZATION REVIEW`

**TASK-020 implementation:** `NOT AUTHORIZED`

**Codex implementation:** `NOT AUTHORIZED`

**Repositorio modificado por esta generación:** `NO`

**Supabase Local modificado:** `NO`

**Supabase Cloud modificado:** `NO`

**Git add / commit / push:** `NO / NO / NO`

**Archivo de entrega:** `TASK-020-authoritative-later-user-enrollment-intent-verification-handoff-foundation-canonical.md`

**Ruta canónica futura propuesta:**

`docs/tasks/TASK-020-authoritative-later-user-enrollment-intent-verification-handoff-foundation.md`

Esta specification fue revisada y aprobada humanamente. El approved artifact review fue aprobado; el canonical artifact requiere `TASK-020 CANONICALIZATION REVIEW` y los Gates posteriores antes de cualquier implementación.

---

## 2. Autorización consumida

La generación se realiza exclusivamente porque existe autorización humana expresa:

```text
TASK-020 SPECIFICATION GENERATION AUTHORIZATION =
APPROVED
```

La autorización permite únicamente definir la specification.

No autoriza implementación, Codex como implementador, modificación del repositorio, migration, SQL, RLS ejecutable, Supabase Local/Cloud, staging, commit ni push.

---

## 3. Objetivo único

TASK-020 debe implementar, únicamente después de todos los Gates requeridos, la foundation autoritativa pre-Client para ordinary later-user enrollment:

```text
current authoritative COMPANY_ADMIN
→ dedicated LaterUserEnrollmentIntent
→ authoritative tenant binding
→ target-email binding
→ intended-role binding
→ ordinary later-user enrollment purpose
→ exactly one current VerificationChallenge
→ authorized issue/resend lifecycle
→ valid current proof consume
→ one-time SessionGrant created/reconciled
→ durable authoritative later-user verification handoff
→ TASK-020 END
```

El START obligatorio es:

```text
authenticated actor
+ resolved PlatformUser
+ current enabled CompanyMembership
+ current role = COMPANY_ADMIN
+ authoritative MaintenanceCompany derived from current membership
```

El END obligatorio es:

```text
valid current VerificationChallenge consumed
+ SessionGrant created/reconciled
+ durable authoritative handoff available
  for future later-user Auth/session continuation
```

TASK-020 no completa el onboarding ordinario.

---

## 4. Regla de frontera principal

Debe preservarse exactamente:

```text
TASK-020
!=
complete RF-013

TASK-020
!=
complete user creation

TASK-020
!=
complete membership onboarding

TASK-020
!=
complete ordinary later-user onboarding

TASK-020
!=
RF-015 satisfied
```

Y:

```text
pre-Client later-user handoff ready
!=
Auth identity/session established
!=
PlatformUser application completion
!=
profile completed
!=
CompanyMembership created
!=
membership enabled
!=
tenant authority established
!=
UserClientAccess created
!=
USER_CREATED produced
!=
ordinary later-user onboarding complete
```

---

## 5. Fuentes normativas y orden de autoridad

### 5.1 Producto

Consumir íntegramente dentro de su alcance:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- `docs/product/04-offline-sync-strategy.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`.

### 5.2 Arquitectura

Consumir, como mínimo:

- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`;
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`;
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`;
- `docs/architecture/adr/ADR-0005-sync-idempotency-conflicts.md`;
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`;
- `docs/architecture/adr/ADR-0021-authoritative-later-user-enrollment-intent-binding.md`.

### 5.3 Foundations implementadas que deben reutilizarse sin generalizarlas

- TASK-009 — identity/tenant physical foundation;
- TASK-010 — `AuditEvent` foundation;
- TASK-011 — Supabase Auth SSR lifecycle foundation;
- TASK-012 — authoritative online authorization foundation;
- TASK-013 — `VerificationChallenge` / `SessionGrant` / E2 foundation;
- TASK-014 — global `SUPER_ADMIN` foundation;
- TASK-015 — `CompanyMembership` lifecycle;
- TASK-016 — authoritative `MaintenanceCompany` creation;
- TASK-017 — first-admin intent/challenge/handoff precedent;
- TASK-018 — first-admin Auth/session continuation;
- TASK-019 — first-admin profile/membership/completion.

TASK-017/018/019 son precedentes purpose-specific. No constituyen una generic later-user API.

### 5.4 Current-state / sequencing

Consumir:

- CORR-039;
- CORR-040;
- CORR-041;
- CORR-042.

### 5.5 Orden de autoridad

Aplicar:

1. decisiones humanas posteriores expresas y no sustituidas;
2. requisitos de producto vigentes;
3. ADR aceptados dentro de su alcance;
4. current-state sincronizado aprobado;
5. TASK/CORR como contrato de materialización y precedentes, sin convertir sus detalles purpose-specific en reglas generales;
6. snapshots históricos sólo como historia.

Ante contradicción material no resoluble por ese orden:

```text
TASK-020 SPECIFICATION / IMPLEMENTATION =
BLOCKER — CANONICAL CONTRADICTION REQUIRES HUMAN REVIEW
```

No resolver por inferencia.

---

## 6. Estado vigente consumido

Debe preservarse:

```text
CORR-042 =
DONE / CLOSED

ADR-0021 =
ACCEPTED / HUMAN APPROVED

ADR-0021 remote persistence =
VERIFIED

ADR-0021 architectural prerequisite for TASK-020 =
RESOLVED

TASK-020 =
DETERMINED

TASK-020 CORRECTED SPEC REVIEW =
APPROVED

F-020-SPEC-001 =
CLOSED

TASK-020 HUMAN APPROVAL =
APPROVED

TASK-020 specification =
HUMAN APPROVED

TASK-020 approved artifact =
REVIEW APPROVED

TASK-020 APPROVED ARTIFACT REVIEW =
APPROVED

TASK-020 CANONICALIZATION =
PASS

TASK-020 canonical artifact =
GENERATED / PENDING CANONICALIZATION REVIEW

TASK-020 implementation =
NOT AUTHORIZED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED
```

Y:

```text
Client =
Phase 3

RF-015 =
MANDATORY / UNCHANGED

zero client assignment satisfies RF-015 =
NO

ordinary later-user onboarding =
INCOMPLETE

pre-Client later-user onboarding foundation =
INCOMPLETE
```

---

## 7. Requisitos de producto aplicables

### 7.1 RF-004..RF-011 — challenge lifecycle

TASK-020 reutiliza sin debilitar:

- `RF-004`: código enviado al correo indicado;
- `RF-005`: vigencia exacta de 8 horas;
- `RF-006`: máximo 3 intentos por emisión;
- `RF-007`: actor autorizado puede reenviar;
- `RF-008`: reenvío produce código nuevo;
- `RF-009`: código anterior queda inmediatamente invalidado;
- `RF-010`: cada código nuevo posee sus propios 3 intentos;
- `RF-011`: código vencido no se recupera ni reutiliza.

La autoridad de estos invariantes permanece en la foundation application-owned de TASK-013, no en defaults del proveedor Auth.

### 7.2 RF-013 — cobertura parcial

RF-013 exige que un `COMPANY_ADMIN` autorizado pueda dar de alta nuevos `COMPANY_ADMIN` y `TECHNICIAN` con patrón email + código.

TASK-020 cubre únicamente:

```text
current authorized COMPANY_ADMIN
→ email + intended role binding
→ challenge issue/resend
→ code verification
→ authoritative handoff
```

No completa RF-013 porque detiene el flujo antes de Auth/session, perfil, membership y client assignment.

### 7.3 RF-014 — binding, no membership assignment

TASK-020 persiste `intended_role` como binding autoritativo inmutable del intent.

Allowed values:

```text
COMPANY_ADMIN
TECHNICIAN
```

Esto no equivale todavía a asignar el role de una `CompanyMembership`, porque TASK-020 no crea membership.

### 7.4 RF-015 / RF-016

TASK-020 no crea ni selecciona `Client` ni `UserClientAccess`.

Debe permanecer:

```text
RF-015 =
MANDATORY / UNCHANGED

RF-016 =
UNCHANGED

zero client assignment satisfies RF-015 =
NO
```

### 7.5 RF-017

TASK-020 no implementa modificación posterior de role/client scope.

La futura `CompanyMembership` deberá consumir el canon vigente de RF-017; esta task no adelanta esa mutación.

### 7.6 FL-02

FL-02 vigente:

```text
1. COMPANY_ADMIN registra correo
2. define rol fijo
3. define clientes autorizados
4. se envía código
5. usuario verifica y completa perfil
6. alcance limitado por tenant, rol y clientes
```

CORR-039 autoriza separar una foundation pre-Client.

TASK-020 materializa únicamente un slice pre-Client de los pasos 1, 2, 4 y la parte de verificación de 5.

No reordena normativamente FL-02 y no declara satisfecho el paso 3.

---

## 8. Fuera de alcance absoluto

TASK-020 NO implementa ni especifica como efecto funcional:

- Auth identity establishment/reconciliation;
- Auth session establishment;
- technical-password execution como continuación de onboarding;
- `PlatformUser` application completion;
- profile completion;
- target `CompanyMembership` creation;
- membership enablement;
- tenant authority establishment;
- `Client`;
- `UserClientAccess`;
- client selector funcional;
- client assignment;
- `SupportAccessGrant`;
- `USER_CREATED`;
- ordinary later-user onboarding completion;
- RF-015 satisfaction;
- later-user membership lifecycle posterior;
- role-change posterior;
- disable/reinstate;
- subscription;
- entitlement;
- Storage;
- Realtime;
- offline enrollment;
- generic invitation framework;
- generic enrollment framework;
- generic privileged Supabase client;
- microservice.

No crear placeholder Client, wildcard client, fake client ID, empty client scope que se presente como válido ni pending `UserClientAccess`.

---

## 9. Decisiones explícitamente diferidas

TASK-020 no decide:

1. exact later-user `PlatformUser` creation/reconciliation point;
2. exact later-user profile completion point/UI;
3. exact initial `CompanyMembership` creation point;
4. final profile/membership/client-scope/audit atomicity;
5. exact later-user `USER_CREATED` producer timing;
6. cancel/restart/replace semantics beyond immutable safe retry;
7. automatic invalidation after initiating admin later loses authority;
8. FL-02 sequencing change.

Si una implementación requiere resolver cualquiera de estas decisiones:

```text
TASK-020 IMPLEMENTATION =
STOP

BLOCKER — PRODUCT DECISION REQUIRED
```

No inferir la respuesta desde first-admin onboarding.

---

## 10. Modelo de dominio — `LaterUserEnrollmentIntent`

### 10.1 Naturaleza

`LaterUserEnrollmentIntent` es una entidad purpose-specific y tenant-owned que representa el binding autoritativo previo a Client para un ordinary later-user enrollment.

Debe permanecer distinta de:

```text
FirstAdminOnboardingIntent
VerificationChallenge
SessionGrant
Auth user
PlatformUser
CompanyMembership
UserClientAccess
target email
```

### 10.2 Ownership

```text
LaterUserEnrollmentIntent ownership =
TENANT-OWNED BUSINESS STATE
```

Su tenant es exactamente una `MaintenanceCompany`.

### 10.3 Binding autoritativo

El intent vincula inmutablemente:

```text
one MaintenanceCompany
+
one target email
+
one intended role ∈ {COMPANY_ADMIN, TECHNICIAN}
+
fixed purpose = ordinary later-user enrollment
+
initiating PlatformUser provenance
+
exactly one current VerificationChallenge at a time
+
durable verification/handoff facts
```

### 10.4 Invariantes

1. `maintenance_company_id` no cambia.
2. `target_email` no cambia.
3. `intended_role` no cambia.
4. Purpose no es caller-selectable.
5. Initiator provenance es histórica; no constituye autoridad futura.
6. Exactly one current challenge pointer exists after successful issue/resend.
7. Only the current challenge may produce a fresh successful proof.
8. Handoff-ready no crea target `PlatformUser`.
9. Handoff-ready no crea target `CompanyMembership`.
10. Handoff-ready no habilita tenant authority.
11. Handoff-ready no satisface RF-015.
12. Intent ID, challenge ID y operation IDs no son bearer authority.
13. El tenant efectivo nunca se obtiene de input del frontend.
14. No existe ownership transfer desde el initiating admin hacia el target.
15. La existencia del intent no demuestra que el target email corresponda todavía a una identidad de aplicación creada.

---

## 11. Persistencia física mínima propuesta

### 11.1 Tabla

Propuesta física:

```text
public.later_user_enrollment_intents
```

No se introduce una tabla genérica de invitaciones.

### 11.2 Campos mínimos

| Campo | Semántica |
|---|---|
| `id` | UUID PK; stable intent identity |
| `maintenance_company_id` | FK required; tenant ownership autoritativo |
| `target_email` | required PII/locator; no identity authority |
| `intended_role` | required; existing fixed-role representation; sólo `COMPANY_ADMIN` o `TECHNICIAN` |
| `initiated_by_platform_user_id` | required FK; historical initiator provenance |
| `establishment_operation_id` | required unique UUID; idempotencia del establecimiento lógico |
| `current_challenge_id` | required unique FK a `verification_challenges` después del commit de establecimiento |
| `handoff_session_grant_id` | nullable unique FK a `auth_session_grants` |
| `handoff_ready_at` | nullable authoritative server timestamp |
| `created_at` | required authoritative server timestamp |

### 11.3 Campos expresamente NO incluidos

No incluir en TASK-020:

- target `platform_user_id`;
- target `company_membership_id`;
- `auth_user_id`;
- `user_client_access_id`;
- `client_id`;
- `support_access_grant_id`;
- profile fields;
- membership enabled state;
- onboarding-completed flag;
- `USER_CREATED` marker;
- cancellation state;
- replacement state;
- restart state;
- generic workflow JSON;
- arbitrary metadata JSON/JSONB;
- caller-supplied tenant snapshot;
- full verification URL;
- plaintext code;
- technical password;
- access token;
- refresh token.

### 11.4 Constraints mínimas

Requerir:

- PK sobre `id`;
- FK restrictivas apropiadas para estado histórico;
- unique `establishment_operation_id`;
- unique `current_challenge_id`;
- unique no-null `handoff_session_grant_id`;
- CHECK de `intended_role` usando exclusivamente roles tenant permitidos;
- all-or-none entre `handoff_session_grant_id` y `handoff_ready_at`;
- no mutable tenant/email/role transition exposed by TASK-020;
- no FK cross-tenant manipulable desde caller;
- no `maintenance_company_id` agregado a `verification_challenges`;
- no role agregado a `verification_challenges`;
- no tenant/role agregado a `auth_session_grants`.

### 11.5 Deliberada ausencia de uniqueness por target email

TASK-020 no introduce por sí sola una regla normativa global o tenant-wide de unicidad histórica de `target_email`.

No se fija:

```text
UNIQUE(target_email)
UNIQUE(maintenance_company_id, target_email)
```

como regla de producto.

La prevención de duplicación del mismo logical request se resuelve con `establishment_operation_id`.

Cualquier necesidad de cancel/restart/replace o de una exclusión adicional entre intents distintos para el mismo email debe volver al Revisor Central si resulta indispensable.

### 11.6 Estado terminal de TASK-020

No se crea un enum genérico de workflow.

Para esta task:

```text
handoff_ready =
handoff_session_grant_id IS NOT NULL
AND
handoff_ready_at IS NOT NULL
```

Ese estado es terminal únicamente respecto del happy path de TASK-020.

No significa onboarding completion.

---

## 12. Email semantics

`target_email` es locator, PII, parte del binding inmutable y correlación requerida con `VerificationChallenge.email`.

No es tenant authority, role authority, application identity authority ni proof.

TASK-020 no crea una nueva política global de normalización de email.

La futura implementación debe reutilizar la representación/correlación vigente de TASK-013.

Si intent, challenge y provider-visible email no pueden correlacionarse de forma estable:

```text
BLOCKER — EMAIL CORRELATION CONTRACT NOT PROVABLE
```

No debilitar la comparación.

---

## 13. Intended role

### 13.1 Input inicial

El current authoritative `COMPANY_ADMIN` selecciona exactamente uno:

```text
COMPANY_ADMIN
TECHNICIAN
```

### 13.2 Persistencia

El role queda persistido en `LaterUserEnrollmentIntent.intended_role`.

### 13.3 Inmutabilidad dentro de TASK-020

Resend y verify no aceptan role nuevo, no cambian role y derivan role desde intent.

### 13.4 No autoridad actual del target

```text
intended_role
!= CompanyMembership.role
!= current tenant authority
```

No existe target membership en TASK-020.

---

## 14. Initiator provenance

Persistir:

```text
initiated_by_platform_user_id
```

La creación debe demostrar dentro de la misma authoritative boundary:

```text
auth.uid()
→ PlatformUser
→ current enabled CompanyMembership
→ role = COMPANY_ADMIN
→ MaintenanceCompany
```

y el intent debe utilizar ese tenant derivado.

La referencia al initiator es histórica:

```text
historical initiator
!= current authority forever
```

Las ordinary authorized issue/resend operations requieren current `COMPANY_ADMIN` authorization según el contrato de cada operación.

La pérdida posterior de autoridad del initiating admin permanece como semántica diferida:

```text
initiating admin later loses authority =
DEFERRED SEMANTICS / NOT DECIDED BY TASK-020
```

TASK-020 no decide si, en ese escenario, un existing intent continúa, se invalida, puede ser asumido por otro admin, puede ser resent o puede alcanzar verify/handoff. Si implementation o testing necesita resolver cualquiera de esas alternativas:

```text
TASK-020 IMPLEMENTATION =
STOP

BLOCKER — PRODUCT DECISION REQUIRED
```

No invalidar automáticamente. No continuar automáticamente. No transferir authority automáticamente. No inferir desde TASK-017 first-admin semantics.

---

## 15. Reutilización de `VerificationChallenge`

TASK-020 no crea challenge table, verifier algorithm ni attempt ledger paralelo.

Debe reutilizar TASK-013:

```text
public.verification_challenges
public.verification_challenge_attempts
```

Preservar:

- `expires_at = issued_at + exactly 8 hours`;
- server-side authoritative clock;
- `attempt_count` en `0..3`;
- máximo 3 effective attempts;
- no plaintext code persistence;
- HMAC/key-version contract vigente;
- constant-time comparison;
- successor/invalidation semantics;
- unique `issue_operation_id`;
- idempotent `verification_operation_id`;
- terminal consumed/invalidated/exhausted behavior;
- no challenge reactivation.

---

## 16. Reutilización de `SessionGrant`

TASK-020 debe reutilizar la foundation existente:

```text
public.auth_session_grants
```

Preservar el contrato TASK-013:

```text
purpose = initial_session
auth_method = password
TTL = 5 minutes
single-use
platform-owned
not browser bearer authority
```

TASK-020 no amplía el TTL.

El handoff durable registra qué `SessionGrant` correspondió al successful consume.

La expiración posterior del grant no reactiva el consumed challenge.

La recuperación posterior al handoff/grant expiry pertenece a la continuación futura y no se diseña aquí.

---

## 17. Autorización del actor para initial issue

### 17.1 Autoridad

No aceptar actor, role o tenant desde el request como autoridad.

Derivar:

```text
validated auth.uid()
→ exact Auth-subject mapping
→ PlatformUser
→ current enabled CompanyMembership
→ MaintenanceCompany
→ current role
```

Exigir:

```text
membership exists
AND membership.is_enabled = true
AND membership.role = COMPANY_ADMIN
```

### 17.2 Input mínimo permitido

Conceptualmente:

- target email;
- intended role;
- `establishment_operation_id`;
- TASK-013 `issue_operation_id`;
- transient challenge material requerido por la foundation existente.

No aceptar como authority:

- `maintenance_company_id`;
- actor `PlatformUser` ID;
- actor membership ID;
- actor role;
- `is_super_admin`;
- target tenant;
- arbitrary challenge ID;
- client IDs.

### 17.3 Global/tenant separation

Un `SUPER_ADMIN` global sin current tenant membership no ejecuta ordinary later-user enrollment.

Una identidad inconsistente global+tenant debe seguir las reglas fail-closed vigentes.

---

## 18. Initial establishment transaction

Una successful initial establishment debe formar una única authoritative decision:

```text
current actor authorization
+
tenant derivation
+
target email validation
+
intended role validation
+
intent creation/reconciliation
+
first VerificationChallenge creation/reconciliation
+
current_challenge pointer
```

No permitir una secuencia que commit intent y challenge de forma independiente.

### 18.1 Idempotent repeat

Same `establishment_operation_id` + materially same logical payload:

```text
→ same intent
→ same first challenge
→ no duplicate
```

Antes de devolver un privileged positive reconciliation, revalidar current actor authorization.

### 18.2 Idempotency conflict

Same `establishment_operation_id` + different material payload:

```text
→ IDEMPOTENCY CONFLICT
→ no rebinding
→ no mutation
```

Material payload incluye al menos target email e intended role.

### 18.3 Distinct-operation collision for the same tenant/email

TASK-020 no define cancel/restart/replace.

Por tanto, si una new distinct `establishment_operation_id` encuentra otro `LaterUserEnrollmentIntent` ya existente para el mismo authoritative tenant + target email:

```text
→ CONFLICT — RESTART/REPLACE SEMANTICS UNDEFINED
→ no second intent mutation
→ no new challenge
→ no silent reconciliation to the existing intent
```

Esta salida es fail-closed y no constituye una decisión positiva de cancel/restart/replace.

La implementación debe proteger también la carrera concurrente de este collision check. No se fija aquí el mecanismo físico de serialización ni una uniqueness constraint permanente sobre tenant+email.

Si no puede impedirse la creación concurrente de competing intents sin introducir una nueva semántica de producto o una uniqueness rule material:

```text
BLOCKER — CANCEL/RESTART/REPLACE PRODUCT DECISION REQUIRED
```

---

## 19. Resend semantics

### 19.1 Actor

Cada resend exige:

```text
current authenticated PlatformUser
+ current enabled CompanyMembership
+ role = COMPANY_ADMIN
+ membership tenant = intent tenant
```

Current `COMPANY_ADMIN` authorization es requerida para ordinary resend, pero TASK-020 no decide la semántica de resend cuando el initiating admin perdió autoridad después de crear el intent. Si ese caso resulta material, aplicar `BLOCKER — PRODUCT DECISION REQUIRED`; no asumir continuación, invalidación ni authority transfer.

### 19.2 Inputs

Conceptualmente:

- `intent_id`;
- new TASK-013 `issue_operation_id`;
- transient successor challenge material.

No acepta new tenant, new target email, new intended role ni new purpose.

### 19.3 Source of truth

Derivar de intent:

```text
tenant
target email
intended role
current challenge
purpose
```

### 19.4 Permitted predecessor lifecycle

Reutilizar TASK-013:

- active current may be resent;
- expired current may be resent;
- exhausted current may be resent;
- consumed current cannot be ordinary-resend reactivated.

### 19.5 Atomicity

Successful resend:

```text
predecessor invalidation
+
successor creation
+
current pointer rotation
```

deben commit juntos.

### 19.6 Concurrency

Dos resends concurrentes sobre el mismo predecessor producen at most one successor.

El loser recibe bounded stale/conflict outcome y no emite automáticamente otro código.

### 19.7 Retry

Same resend `issue_operation_id` reconcilia el mismo successor y no crea otra emission.

Current admin authority debe revalidarse antes de devolver privileged reconciliation.

---

## 20. Verification / consume semantics

### 20.1 Naturaleza pre-auth

El target todavía no necesita una tenant session.

La verificación es pre-auth respecto del future target user.

TASK-020 no decide si un existing intent puede alcanzar verify/handoff después de que el initiating admin haya perdido autoridad. Si ese hecho resulta material para autorizar o denegar el consume, aplicar `BLOCKER — PRODUCT DECISION REQUIRED`; no asumir continuación ni invalidación automática.

### 20.2 Inputs conceptuales

- opaque `intent_id`;
- presented target email;
- candidate code;
- server-issued/managed `verification_operation_id`.

No aceptar tenant ID, role, membership ID, PlatformUser ID, client IDs ni arbitrary challenge selection como authority.

### 20.3 Resolution

Antes de successful consume debe demostrarse autoritativamente:

```text
intent exists
AND
intent.current_challenge_id = challenge.id
AND
intent.target_email = challenge.email
AND
presented email correlates under existing TASK-013 contract
AND
challenge is not invalidated
AND
challenge is not exhausted
AND
challenge is not consumed
AND
current server time < expires_at
```

### 20.4 Atomic attempt/consume/handoff

La final authoritative transition debe agrupar:

- intent binding validation;
- current challenge resolution;
- `verification_operation_id` reconciliation;
- attempt row creation para new effective attempt;
- attempt counter increment exactly once;
- verifier comparison;
- challenge consume on correct proof;
- `SessionGrant` creation/reconciliation;
- persistence of `handoff_session_grant_id`;
- persistence of `handoff_ready_at`.

No permitir TOCTOU entre intent resolution y challenge consume.

### 20.5 Wrong proof

Una nueva wrong proof consume exactamente un effective attempt.

Third wrong proof:

```text
attempt_count = 3
exhausted_at != NULL
consumed_at = NULL
```

No existe fourth effective attempt.

### 20.6 Correct proof

Correct proof puede consumir en attempt 1, 2 o 3.

On success:

```text
challenge consumed exactly once
+
SessionGrant created/reconciled exactly once
+
handoff recorded exactly once
```

### 20.7 Replay

- different-operation replay de consumed challenge → no new grant/handoff;
- same successful verification operation → reconcile same outcome;
- invalidated/exhausted/expired challenge → no fresh success.

---

## 21. Durable handoff contract

Después de handoff-ready, el sistema debe poder derivar tenant, target email, intended role, initiator provenance, challenge consumido, corresponding SessionGrant y handoff-ready timestamp desde authoritative state.

No entregar `SessionGrant` como bearer.

`intent_id` puede viajar como locator.

```text
intent_id alone != proof
intent_id alone != tenant authority
intent_id alone != session authority
```

La continuation futura puede usar el handoff server-side, pero TASK-020 no define Auth creation/reconciliation, session establishment, profile, target PlatformUser, target membership, client assignment ni USER_CREATED.

---

## 22. RLS y tenant isolation

### 22.1 Obligación

```text
LaterUserEnrollmentIntent =
tenant-owned

RLS =
MANDATORY / PRIMARY REMOTE TENANT ISOLATION BOUNDARY
```

`public.later_user_enrollment_intents` debe tener RLS enabled.

### 22.2 Tenant derivation

El tenant del intent se fija desde current actor membership durante establishment.

No desde body, query, pathname, header, custom cookie, stale claim o caller-provided `maintenance_company_id`.

### 22.3 Direct Data API

Baseline exacta:

```text
anon direct SELECT/INSERT/UPDATE/DELETE =
NO

authenticated direct SELECT/INSERT/UPDATE/DELETE =
NO

PUBLIC direct CRUD =
NO
```

La UI/application layer no depende de direct table reads. La lectura/reconciliación necesaria ocurre exclusivamente mediante boundaries purpose-specific que preservan el tenant derivado y devuelven resultados acotados.

No abrir generic read/write policy.

### 22.4 Privileged transition boundary

Issue/resend/verify deben usar boundaries purpose-specific.

Si para componer tenant-owned intent con platform-owned TASK-013 state se necesita privilegio técnico elevado, el boundary debe ser narrow, derivar authority internamente, usar fixed/safe `search_path`, usar schema-qualified references, no aceptar tenant authority del caller y no convertirse en generic tenant bypass.

`SECURITY DEFINER` es permitido únicamente como pattern purpose-specific ya establecido si el preflight confirma que es necesario. No autoriza un helper genérico.

### 22.5 `supabase_auth_admin`

TASK-020 no concede privilegios tenant a `supabase_auth_admin`.

El Custom Access Token Hook sigue operando sólo sobre platform-owned state aprobado por TASK-013.

---

## 23. Application / server boundary

Mantener monolito modular Next.js y el bounded context existente `Identity & Authorization`.

Initial issue/resend desde current `COMPANY_ADMIN` deben usar caller-scoped Auth/Supabase context y purpose-specific use cases.

Verification debe usar una server-only composition boundary.

No exponer raw privileged Supabase/Admin client al browser ni como utility genérica.

La implementación debe inspeccionar el mecanismo actual de TASK-017/TASK-013 y reutilizar la primitive narrow existente cuando sea compatible.

Si sólo fuera posible mediante un nuevo generic privileged client:

```text
BLOCKER — PRIVILEGED BOUNDARY EXPANSION REQUIRES REVIEW
```

TypeScript strict permanece obligatorio.

---

## 24. Delivery boundary

```text
authoritative challenge issuance
!=
external email delivery success
```

DB commit define business-code emission.

TASK-020 puede reutilizar o crear una thin purpose-specific delivery port server-only si la actual no es reusable sin convertir TASK-017 en generic API.

No seleccionar production email provider.

Delivery material puede contener transient current code, trusted-origin verification link y opaque stable intent ID.

El verification URL no debe incluir email, code, tenant/company ID, role, challenge ID, grant ID, Auth user ID, access/refresh token ni technical password.

El exact pathname no queda fijado por esta specification; debe ser purpose-specific y respetar las convenciones reales del repositorio tras preflight.

Delivery failure después del commit no hace rollback de issuance.

Si el plaintext code ya no está disponible, nueva entrega requiere authorized resend/new emission.

No persistir plaintext code para delivery retry.

Mientras no exista production adapter aprobado:

```text
RF-004 end-to-end =
NO / PARTIAL
```

---

## 25. UI / UX behavior dentro del slice

Esta specification define comportamiento, no layout visual.

### 25.1 Current COMPANY_ADMIN

1. ingresa target email;
2. selecciona intended role `COMPANY_ADMIN` o `TECHNICIAN`;
3. no selecciona clients en TASK-020;
4. submit inicia logical establishment con stable correlation;
5. UI recibe bounded outcome;
6. si proof queda pending, UI puede iniciar resend;
7. ambiguous timeout reconcilia same operation, no crea otra automáticamente.

No mostrar el resultado como “usuario creado”.

### 25.2 Resend

No permite cambiar tenant, email ni intended role.

Si se necesita cambiar email/role mediante una nueva intención, TASK-020 no define cancel/restart/replace.

### 25.3 Target verification

La superficie pre-auth:

1. obtiene `intent_id` como locator;
2. solicita/acepta target email según contract vigente;
3. solicita candidate code;
4. realiza verify;
5. muestra bounded outcome;
6. on success comunica que verification fue aceptada y onboarding continúa pendiente.

No incluye profile form, client assignment ni tenant dashboard access.

### 25.4 Error copy

Exact user copy no queda fijado.

Debe evitar enumeration y exposición de PII/secrets.

---

## 26. Offline behavior

Ordinary later-user enrollment es `ONLINE-ONLY`.

TASK-020 no crea Dexie schema, IndexedDB enrollment state, offline authority, outbox de issue/resend/verify, optimistic local enrollment ni Service Worker business workflow.

Offline UI debe impedir iniciar o confirmar estas operaciones sin conectividad autoritativa.

---

## 27. Audit implications

New functional `AuditEvent` para issue, resend o verify = `NO`.

`USER_CREATED` = `NO`.

El intent conserva `initiated_by_platform_user_id` para trazabilidad futura.

No se inventa un nuevo audit action.

---

## 28. Idempotency

- Establishment: `establishment_operation_id`.
- Issue/resend: TASK-013 `issue_operation_id`.
- Verification: TASK-013 `verification_operation_id`.

Same IDs reconcilian la misma operation; payload materialmente distinto bajo el mismo establishment ID produce conflict.

Operation IDs no son secrets ni authority.

---

## 29. Concurrency / atomicity

| Operation | Facts that commit together |
|---|---|
| Initial establishment | actor authz + tenant binding + intent + first challenge + current pointer |
| Resend | current actor authz + predecessor transition + successor + pointer rotation |
| Verify success | intent/current binding + attempt/consume + SessionGrant + handoff |
| Verify wrong | current binding + exactly one attempt row + exactly one counter increment |

Races obligatorias con transacciones/conexiones realmente concurrentes cuando corresponda:

- duplicate same establishment operation;
- same resend operation;
- two resends on same predecessor;
- verify vs resend;
- two verify operations with same code;
- attempt 2/3 concurrency;
- double successful consume;
- lost response + retry.

No ejecutar email provider call dentro de authoritative DB transaction.

---

## 30. Threat model

| Threat | Attack | Control | Expected |
|---|---|---|---|
| Tenant spoofing | caller sends another tenant | derive tenant from current membership | DENY/no effect |
| Role spoofing | caller sends actor role | derive actor role from DB | DENY/no effect |
| Intended-role tamper | change role after intent | derive immutable role from intent | no change |
| Cross-tenant intent | admin targets foreign intent | intent tenant vs membership | DENY |
| Stale current admin | membership disabled/role changed for the actor invoking issue/resend | current DB state | DENY issue/resend |
| Initiating admin later loses authority | continuation/invalidation/assumption/verify-handoff semantics would need a product decision | deferred by ADR-0021; no inference | BLOCKER — PRODUCT DECISION REQUIRED if material |
| Locator theft | attacker knows intent ID | locator is not proof | no authority |
| Email enumeration | probe combinations | bounded pre-auth errors | no disclosure |
| Challenge replay | reuse consumed code | terminal consume | DENY |
| Old code after resend | predecessor proof | invalidation/current pointer | DENY |
| Attempt race | concurrent guesses | atomic attempt ledger | max 3 |
| Verify-vs-resend | race | one authoritative ordering | no dual success |
| Cross-intent challenge | foreign challenge | pointer + email binding | DENY |
| SessionGrant theft | browser receives grant | never bearer-exposed | absent |
| RLS bypass | direct Data API write | RLS + privilege controls | DENY |
| Definer confused deputy | crafted inputs | auth.uid + derived tenant | DENY |
| Generic service-role | server bypass utility | prohibited | absent |
| PII leak | raw errors/logs | bounded mapping | absent |
| Plaintext code persistence | DB/log/queue | transient only | absent |
| Offline spoof | local acceptance | online-only | DENY |
| First-admin API reuse | genericize TASK-017 | distinct entity/use cases | absent |
| Premature onboarding | handoff treated complete | explicit boundary | absent |

---

## 31. Failure model

| Failure | Authoritative result | External result |
|---|---|---|
| no valid Auth session on initial/resend | no mutation | `DENIED` |
| unresolved PlatformUser | no mutation | `DENIED` |
| no enabled membership | no mutation | `DENIED` |
| role != COMPANY_ADMIN | no mutation | `DENIED` |
| initiating admin later loses authority and continuation semantics become material | no inferred continuation/invalidation/transfer | `BLOCKER — PRODUCT DECISION REQUIRED` |
| foreign intent on resend | no mutation | bounded `DENIED` |
| invalid intended role | no mutation | validation failure |
| malformed operation ID | no mutation | validation failure |
| same op + different payload | no mutation | `IDEMPOTENCY_CONFLICT` |
| DB error before commit | rollback | `NOT_CONFIRMED` |
| response lost after commit | state may exist | retry same operation |
| email delivery fails after commit | challenge remains issued | delivery failure separate |
| expired/exhausted/invalidated challenge | no success | bounded invalid |
| wrong proof | one attempt consumed | bounded invalid proof |
| third wrong proof | exhausted | bounded invalid proof |
| verify/resend race loser | no second success | stale/conflict |
| same verify op retry | prior result reconciled | bounded result |
| SessionGrant creation fails | no partial success | `NOT_CONFIRMED` |
| handoff persistence fails | no partial success | `NOT_CONFIRMED` |
| new privileged architecture needed | stop | blocker |
| product decision needed | stop | blocker |

Raw DB/provider errors no cruzan la boundary.

---

## 32. Secrets, PII y logging

No loggear plaintext code, candidate code, verifier, HMAC key, technical password, Supabase secret/service key, raw Admin credential, access/refresh token ni SessionGrant bearer material.

`target_email` es PII y debe minimizarse en logs.

TASK-020 no decide una nueva retention policy.

Si schema correctness exige una nueva decisión de PII retention:

```text
BLOCKER — PRODUCT/PRIVACY DECISION REQUIRED
```

---

## 33. Compatibilidad con foundations existentes

- TASK-009: no target PlatformUser creation.
- TASK-010: AuditEvent catalog unchanged; no USER_CREATED.
- TASK-011: Auth SSR technical lifecycle remains distinct from authorization.
- TASK-012 / ADR-0003: current DB authorization and tenant derivation preserved.
- TASK-013 / ADR-0019: challenge/grant/E2 semantics preserved.
- TASK-014: SUPER_ADMIN is not ordinary tenant actor.
- TASK-015: no membership lifecycle mutation.
- TASK-016: company creation independent.
- TASK-017/018/019: first-admin purpose-specific semantics remain distinct.
- CORR-039: Client remains Phase 3.
- CORR-040/CORR-042: ordinary later-user onboarding remains incomplete after TASK-020.

---

## 34. Cambios físicos esperados en futura implementación

### 34.1 Database

Expected minimum:

1. una nueva migration forward-only;
2. `public.later_user_enrollment_intents`;
3. exact minimal fields/constraints;
4. RLS enabled;
5. privilege/grant/revoke hardening;
6. purpose-specific initial issue/resend boundary;
7. purpose-specific verify/handoff composition boundary si no existe reusable exacta;
8. mínimos índices justificados;
9. no backfill ficticio.

### 34.2 Application

Expected:

- strict typed contracts;
- current COMPANY_ADMIN use case;
- resend use case;
- pre-auth verify use case;
- safe outcome mapping;
- provider-neutral delivery seam;
- UI orchestration mínima.

### 34.3 No expected changes

No cambiar `company_memberships` schema, `platform_users` schema, `user_client_access`, `audit_events` action catalog, Auth Hook decision, provider bridge semantics, Client schema ni offline schema.

---

## 35. Requisitos de índices

Como mínimo evaluar:

- PK `id`;
- unique `establishment_operation_id`;
- unique `current_challenge_id`;
- unique non-null `handoff_session_grant_id`;
- FK indexes sólo si query plan los requiere;
- tenant index sólo si una query aprobada lo justifica.

No añadir índices “por si acaso”.

No añadir target-email uniqueness sin Gate adicional.

---

## 36. Preflight obligatorio antes de implementación futura

Antes de escribir código/SQL, Codex deberá inspeccionar y reportar:

1. repo root;
2. branch;
3. HEAD;
4. upstream;
5. origin/main;
6. divergence;
7. worktree;
8. index;
9. Git operations in progress;
10. current migrations;
11. current identity/auth schemas;
12. TASK-013 challenge/grant implementation;
13. TASK-017 first-admin implementation;
14. caller-scoped Supabase factories;
15. current authorization resolver;
16. current RLS policies/grants;
17. test harness;
18. TypeScript module structure;
19. current delivery abstraction if any;
20. dependency/tool versions relevant to Supabase/Auth.

Material drift:

```text
TASK-020 IMPLEMENTATION =
STOP

BLOCKER — REPOSITORY/CANON DRIFT REQUIRES REVIEW
```

---

## 37. Provider contract recheck

Antes de una implementation que toque Hosted-relevant Auth boundaries, verificar documentación oficial vigente únicamente donde pueda haber cambio material en Custom Access Token Hook, SessionGrant interaction, Auth Admin boundaries ya utilizadas y Data API/RLS/function semantics.

Si una assumption de ADR-0019 deja de ser válida:

```text
BLOCKER — PROVIDER CONTRACT CHANGED, HUMAN REVIEW REQUIRED
```

---

## 38. Testing strategy

### 38.1 DB schema tests

Table/columns/constraints/FKs/indexes/RLS exactos; no forbidden columns; no speculative target-email unique; no generic JSON; no backfill.

### 38.2 Authorization tests

No session, unknown subject, unresolved PlatformUser, no membership, disabled membership, TECHNICIAN, valid COMPANY_ADMIN, stale claim denial, tenant spoof denial, foreign intent denial, current-authority resend checks, initiator provenance not authority, y initiating-admin-authority-loss tratado como deferred semantics con blocker cuando resulte material.

### 38.3 RLS / privilege tests

Anon direct CRUD denied; authenticated direct writes denied; no broad grants; no PUBLIC broad execute; cross-tenant denied; no tenant privilege for `supabase_auth_admin`; no generic service-role client; safe/fixed search path; Data API cannot mutate challenge/handoff directly.

### 38.4 Initial establishment tests

Both roles, invalid role, tenant derivation, atomic intent/challenge/pointer, same-op retry, payload conflict, lost-response retry.

### 38.5 Challenge lifecycle tests

Exact 8h, attempts 1/2/3, fourth impossible, expired, exhausted, consumed, resend active/expired/exhausted, consumed resend denied, predecessor invalidation, successor new identity/window/budget.

### 38.6 Verification/handoff tests

Missing intent, email mismatch, cross-intent challenge, old challenge, wrong proof, third wrong proof, correct proof attempts 1/2/3, consume once, grant once, handoff once, same-op reconcile, replay denied, grant non-bearer, no target PlatformUser/membership.

### 38.7 Concurrency tests

Real parallel connections for establishment/retry, resend races, verify-vs-resend, double verify, attempt-limit race and lost-response reconciliation.

### 38.8 Delivery tests

Delivery after commit, failure independent, transient code only, trusted origin, URL minimization, stable intent locator, no production provider dependency.

### 38.9 UI/application tests

Email+role admin form, no client selector, bounded results, immutable resend fields, no profile/client UI, success means handoff only, offline denied.

### 38.10 Regression

Relevant TASK-009..019 suites plus lint, strict typecheck, tests, build, repository verify and `git diff --check`.

---

## 39. Hosted Development verification

Hosted Development requiere Gate humano separado.

Verificar migration, table/constraints/indexes/RLS/grants/functions, Data API negatives, current COMPANY_ADMIN authz, same/cross-tenant cases, challenge lifecycle, handoff atomicity, concurrency, TASK-013 E2 regressions, absence de generic privileged client y ausencia de Client/UserClientAccess.

No Staging/Production mutation.

---

## 40. Blockers de futura implementación

Detener si:

1. fuente canónica requerida ausente;
2. repository baseline incompatible;
3. ADR-0021 no puede preservarse;
4. se requiere reutilizar `FirstAdminOnboardingIntent`;
5. tenant-owned RLS no puede preservarse;
6. caller-supplied tenant debe volverse authority;
7. generic privileged client se vuelve necesario;
8. microservice se vuelve necesario;
9. exact PlatformUser timing debe decidirse;
10. profile timing debe decidirse;
11. initial membership timing debe decidirse;
12. final client-scope atomicity debe decidirse;
13. USER_CREATED timing debe decidirse;
14. cancel/restart/replace debe decidirse;
15. automatic invalidation on initiator loss debe decidirse;
16. FL-02 sequencing change debe decidirse;
17. Client/UserClientAccess debe crearse;
18. zero-client debe tratarse como RF-015 satisfaction;
19. new AuditEvent action es necesaria;
20. challenge contract debe debilitarse;
21. SessionGrant contract debe cambiar;
22. provider-specific email choice es necesaria para core correctness;
23. global email normalization rule es necesaria;
24. PII retention decision es necesaria;
25. target-email uniqueness business semantics es necesaria;
26. definer scope se vuelve generic tenant bypass;
27. `supabase_auth_admin` necesita tenant privileges;
28. concurrency/security tests no pueden demostrarse;
29. strict TypeScript debe relajarse;
30. cualquier AC se vuelve insatisfacible.

Ante blocker:

```text
NO silent repair
NO scope expansion
NO new ADR automatically
NO fallback
RETURN TO REVISOR CENTRAL
```

---

## 41. ADR determination

Mientras se preserve este boundary:

```text
new ADR required =
NO

product decision required before spec =
NO
```

Si implementation descubre una decisión transversal nueva, debe detenerse.

---

## 42. Plan de implementación futuro — work items pequeños y verificables

Los siguientes work items son sólo descomposición futura para Codex después de approvals/Gates.

### Work item A — LaterUserEnrollmentIntent persistence + RLS foundation

**Objective:** materializar únicamente la entidad tenant-owned y constraints mínimos.

**Context:** ADR-0021 exige dedicated intent; TASK-020 termina pre-Client.

**Scope:** one new table, fields §11.2, constraints §11.4, RLS, privileges, minimal indexes, no backfill.

**Out of scope:** issue/resend, verify, UI, delivery, Auth, PlatformUser/membership/client.

**Expected changes:** one forward-only migration.

**Security/RLS:** no anon CRUD; no authenticated direct writes; tenant-owned RLS mandatory; no generic bypass.

**Acceptance:** domain/schema/RLS AC.

**Tests:** schema, constraints, grants/policies, negative direct access.

### Work item B — Current COMPANY_ADMIN initial issue + resend

**Objective:** componer current actor authority + tenant intent + TASK-013 issue/resend.

**Context:** current membership is authority; frontend tenant is not.

**Scope:** actor resolution, tenant derivation, email/role binding, establishment idempotency, initial atomicity, resend reauthorization, successor/pointer atomicity, bounded outcomes.

**Out of scope:** verify, Auth, profile/membership/client, cancel/restart/replace.

**Expected changes:** narrow DB/application use cases.

**Security/RLS:** `auth.uid()` anchor; same-tenant; no generic definer/client.

**Acceptance:** authorization/lifecycle/idempotency/concurrency AC.

**Tests:** tenant, stale actor, retries, races, replacement.

### Work item C — Pre-auth current-proof verify + authoritative handoff

**Objective:** verificar sólo current challenge y producir SessionGrant/handoff atomicamente.

**Context:** target is pre-auth; intent locator is not authority.

**Scope:** intent/current challenge resolver, email correlation, verifier/attempt reuse, consume, SessionGrant, handoff, reconciliation, safe errors.

**Out of scope:** Auth identity/session continuation, PlatformUser, membership, profile, clients, completion.

**Expected changes:** narrow server-only verification composition.

**Security/RLS:** no raw privileged client; no tenant input authority; no enumeration.

**Acceptance:** verification/handoff AC.

**Tests:** wrong/correct/replay/races/cross-intent/grant/handoff.

### Work item D — Provider-neutral delivery + bounded UI orchestration

**Objective:** conectar issuance con delivery seam y UI mínima sin declarar onboarding completo.

**Context:** RF-004 sigue partial sin production adapter.

**Scope:** server-only delivery port, transient code, safe intent-locator link, admin email+role UI, resend, target verify UI, bounded outcomes.

**Out of scope:** production provider, durable queue, profile, Client selector, authenticated completion.

**Expected changes:** strict TypeScript application/UI boundary.

**Security/RLS:** no secrets in client/logs/URL; intent locator only.

**Acceptance:** delivery/UI/offline AC.

**Tests:** commit-before-delivery, URL minimization, UI boundaries, offline denial.

### Work item E — Regression/evidence package

**Objective:** demostrar TASK-020 sin ampliar scope.

**Context:** security-sensitive composition over TASK-009..019.

**Scope:** DB, RLS, authz, concurrency, application, UI, regression, lint/typecheck/build/verify.

**Out of scope:** new feature work.

**Expected changes:** tests/evidence only as required.

**Security/RLS:** explicit negative bypass evidence.

**Acceptance:** all TASK-020 AC.

**Tests:** §38 completo.

### Work item F — Hosted Development verification

**Objective:** verificar exact approved implementation en Hosted Development.

**Context:** remote mutation/testing requiere Gate humano separado.

**Scope:** exact migration/functions/RLS/grants/tests.

**Out of scope:** Staging, Production, Git persistence by inference.

**Security/RLS:** remote evidence same-tenant isolation/no bypass.

**Acceptance:** Hosted subset of AC + regression.

**Tests:** §39.

---

## 43. Acceptance Criteria

**AC-020-001.** ID exacto = `TASK-020`.

**AC-020-002.** Título exacto = `TASK-020 — Authoritative Later-User Enrollment Intent, Verification and Handoff Foundation`.

**AC-020-003.** Fase = Phase 2 / Multitenancy, autenticación, roles y RLS.

**AC-020-004.** Bounded context principal = `Identity & Authorization`.

**AC-020-005.** Specification state = `GENERATED / PENDING SPEC REVIEW`.

**AC-020-006.** Specification generation no autoriza implementación.

**AC-020-007.** Codex implementation permanece `NOT AUTHORIZED`.

**AC-020-008.** Repositorio no se modifica durante specification generation.

**AC-020-009.** Supabase Local y Cloud no se modifican durante specification generation.

**AC-020-010.** CORR-042 permanece `DONE / CLOSED`.

**AC-020-011.** ADR-0021 permanece `ACCEPTED / HUMAN APPROVED`.

**AC-020-012.** ADR-0021 architectural prerequisite for TASK-020 permanece `RESOLVED`.

**AC-020-013.** Phase 2 permanece `IN PROGRESS / NOT CLOSED`.

**AC-020-014.** Phase 2 Exit Gate permanece `NOT YET DEFINED`.

**AC-020-015.** Phase 3 permanece `NOT STARTED`.

**AC-020-016.** Client permanece Phase 3.

**AC-020-017.** RF-015 permanece `MANDATORY / UNCHANGED`.

**AC-020-018.** Zero client assignment no satisface RF-015.

**AC-020-019.** Ordinary later-user onboarding permanece `INCOMPLETE`.

**AC-020-020.** Pre-Client later-user onboarding foundation no se declara complete por specification.

**AC-020-021.** TASK-020 START exige authenticated actor.

**AC-020-022.** TASK-020 START exige resolved PlatformUser.

**AC-020-023.** TASK-020 START exige current enabled CompanyMembership.

**AC-020-024.** TASK-020 START exige current role `COMPANY_ADMIN`.

**AC-020-025.** Tenant se deriva de current CompanyMembership.

**AC-020-026.** Caller-supplied tenant nunca es authority.

**AC-020-027.** Dedicated `LaterUserEnrollmentIntent` es obligatorio.

**AC-020-028.** `FirstAdminOnboardingIntent != LaterUserEnrollmentIntent`.

**AC-020-029.** `LaterUserEnrollmentIntent` es tenant-owned business state.

**AC-020-030.** RLS es mandatory / primary remote tenant isolation boundary.

**AC-020-031.** Target email forma parte del binding inmutable.

**AC-020-032.** Intended role forma parte del binding inmutable.

**AC-020-033.** Allowed intended roles son exactamente `COMPANY_ADMIN | TECHNICIAN`.

**AC-020-034.** Purpose es ordinary later-user enrollment y no caller-selectable.

**AC-020-035.** Initiator provenance queda persistida.

**AC-020-036.** Initiator provenance no equivale a current authority futura.

**AC-020-037.** Intent mantiene exactamente un current challenge pointer tras issue/resend exitoso.

**AC-020-038.** Only current challenge puede producir fresh successful proof.

**AC-020-039.** Handoff ready no equivale a Auth identity/session establishment.

**AC-020-040.** Handoff ready no equivale a PlatformUser completion.

**AC-020-041.** Handoff ready no equivale a profile completion.

**AC-020-042.** Handoff ready no equivale a CompanyMembership creation.

**AC-020-043.** Handoff ready no equivale a membership enabled.

**AC-020-044.** Handoff ready no equivale a tenant authority.

**AC-020-045.** Handoff ready no equivale a UserClientAccess.

**AC-020-046.** Handoff ready no produce USER_CREATED.

**AC-020-047.** Handoff ready no equivale a ordinary later-user onboarding completion.

**AC-020-048.** Physical table propuesta es `public.later_user_enrollment_intents`.

**AC-020-049.** Table contiene stable UUID identity.

**AC-020-050.** Table contiene `maintenance_company_id` required.

**AC-020-051.** Table contiene `target_email` required.

**AC-020-052.** Table contiene `intended_role` required.

**AC-020-053.** Table contiene `initiated_by_platform_user_id` required.

**AC-020-054.** Table contiene unique `establishment_operation_id`.

**AC-020-055.** Table contiene unique `current_challenge_id`.

**AC-020-056.** Table permite nullable unique `handoff_session_grant_id`.

**AC-020-057.** Table contiene nullable `handoff_ready_at`.

**AC-020-058.** Table contiene authoritative server `created_at`.

**AC-020-059.** Handoff grant y handoff timestamp cumplen all-null/all-present.

**AC-020-060.** No se agrega target PlatformUser FK.

**AC-020-061.** No se agrega target CompanyMembership FK.

**AC-020-062.** No se agrega Client/UserClientAccess FK.

**AC-020-063.** No se agrega Auth user ID.

**AC-020-064.** No se agrega onboarding completion field.

**AC-020-065.** No se agrega cancel/restart/replace state.

**AC-020-066.** No se agrega generic workflow JSON/JSONB.

**AC-020-067.** No se persiste plaintext verification code.

**AC-020-068.** No se persiste full verification URL.

**AC-020-069.** No se persiste technical password.

**AC-020-070.** No se introduce target-email global unique.

**AC-020-071.** No se introduce tenant+target-email unique como regla de producto en TASK-020.

**AC-020-072.** Target email sigue siendo locator/PII y no authority.

**AC-020-073.** Specification no crea nueva global email-normalization policy.

**AC-020-074.** Email correlation reutiliza TASK-013 contract.

**AC-020-075.** Intended role no crea CompanyMembership role todavía.

**AC-020-076.** Resend no puede cambiar target email.

**AC-020-077.** Resend no puede cambiar intended role.

**AC-020-078.** Resend no puede cambiar tenant.

**AC-020-079.** Initial issue deriva actor desde `auth.uid()`.

**AC-020-080.** Initial issue deriva current membership desde PostgreSQL.

**AC-020-081.** Initial issue deniega actor sin enabled membership.

**AC-020-082.** Initial issue deniega actor role != COMPANY_ADMIN.

**AC-020-083.** Initial issue no acepta `maintenance_company_id` como authority.

**AC-020-084.** Initial issue compone intent + first challenge + pointer atómicamente.

**AC-020-085.** Same establishment operation + same payload reconcilia sin duplicate.

**AC-020-086.** Same establishment operation + different email falla conflict.

**AC-020-087.** Same establishment operation + different role falla conflict.

**AC-020-088.** Current actor authority se revalida antes de privileged positive reconciliation.

**AC-020-089.** Resend exige current COMPANY_ADMIN del intent tenant.

**AC-020-090.** TASK-020 no decide si, después de que el initiating admin pierde autoridad, un existing intent puede continuar, ser asumido por otro admin, ser resent o alcanzar verify/handoff; si ese escenario resulta material, implementation se detiene con `BLOCKER — PRODUCT DECISION REQUIRED`.

**AC-020-091.** Resend reutiliza TASK-013 `issue_operation_id`.

**AC-020-092.** Resend active predecessor conserva semantics TASK-013.

**AC-020-093.** Resend expired predecessor conserva semantics TASK-013.

**AC-020-094.** Resend exhausted predecessor conserva semantics TASK-013.

**AC-020-095.** Consumed current no se reactiva mediante ordinary resend.

**AC-020-096.** Predecessor transition + successor + pointer rotation son atómicos.

**AC-020-097.** Concurrent resends producen at most one successor para el mismo predecessor.

**AC-020-098.** Resend loser no genera automáticamente otra emission.

**AC-020-099.** Verification es pre-auth respecto del target.

**AC-020-100.** Verify acepta intent locator, email, code y verification operation correlation.

**AC-020-101.** Verify no acepta tenant como authority.

**AC-020-102.** Verify no acepta role como authority.

**AC-020-103.** Verify no acepta arbitrary challenge como authority.

**AC-020-104.** Verify exige intent.current_challenge_id = challenge.id.

**AC-020-105.** Verify exige intent.target_email = challenge.email bajo el contract vigente.

**AC-020-106.** Expired challenge no produce fresh success.

**AC-020-107.** Invalidated challenge no produce fresh success.

**AC-020-108.** Exhausted challenge no produce fresh success.

**AC-020-109.** Consumed challenge no produce fresh success.

**AC-020-110.** Wrong proof consume exactamente un effective attempt.

**AC-020-111.** Third wrong proof marca exhausted sin consumed.

**AC-020-112.** Fourth effective attempt es imposible.

**AC-020-113.** Correct proof puede consumir en attempt 1, 2 o 3.

**AC-020-114.** Binding + attempt/consume + SessionGrant + handoff forman una decisión atómica.

**AC-020-115.** Challenge consume no puede quedar committed sin required grant/handoff.

**AC-020-116.** SessionGrant purpose permanece `initial_session`.

**AC-020-117.** SessionGrant auth method permanece `password`.

**AC-020-118.** SessionGrant TTL permanece 5 minutes.

**AC-020-119.** SessionGrant permanece single-use.

**AC-020-120.** SessionGrant permanece platform-owned.

**AC-020-121.** SessionGrant no se entrega al browser como bearer.

**AC-020-122.** Same successful verification operation reconcilia el mismo result.

**AC-020-123.** Different-operation replay no crea second grant/handoff.

**AC-020-124.** Intent handoff permite derivar tenant exclusivamente desde intent.

**AC-020-125.** Intent handoff permite derivar email exclusivamente desde intent.

**AC-020-126.** Intent handoff permite derivar intended role exclusivamente desde intent.

**AC-020-127.** Intent ID alone no es proof.

**AC-020-128.** Intent ID alone no es tenant authority.

**AC-020-129.** Intent ID alone no es session authority.

**AC-020-130.** RLS está enabled sobre later-user intent.

**AC-020-131.** Anon no obtiene direct CRUD sobre later-user intent.

**AC-020-132.** Authenticated no obtiene direct general write sobre later-user intent.

**AC-020-133.** PUBLIC no obtiene broad CRUD/EXECUTE.

**AC-020-134.** No se abre generic tenant write policy.

**AC-020-135.** Purpose-specific privileged boundary deriva tenant internamente.

**AC-020-136.** `SECURITY DEFINER`, si se usa, es narrow y hardened.

**AC-020-137.** Safe/fixed search_path se verifica para definer.

**AC-020-138.** Dynamic SQL baseline esperado = NONE.

**AC-020-139.** No generic service-role request client.

**AC-020-140.** No generic privileged Supabase/Admin client.

**AC-020-141.** `supabase_auth_admin` no recibe tenant privileges.

**AC-020-142.** Browser no muta directly intent/challenge/handoff tables.

**AC-020-143.** Pre-auth verify no expone raw privileged DB/client boundary.

**AC-020-144.** Current PostgreSQL state prevalece sobre stale claims.

**AC-020-145.** Delivery ocurre fuera de authoritative DB transaction.

**AC-020-146.** Authoritative issue commit no depende de email-provider success.

**AC-020-147.** Delivery failure no hace rollback de business emission.

**AC-020-148.** Plaintext code sólo existe transiently para delivery/verification input.

**AC-020-149.** Verification link se compone desde trusted app origin.

**AC-020-150.** Verification URL no contiene email.

**AC-020-151.** Verification URL no contiene code.

**AC-020-152.** Verification URL no contiene tenant/company ID.

**AC-020-153.** Verification URL no contiene role.

**AC-020-154.** Verification URL no contiene challenge/grant/Auth/token/password material.

**AC-020-155.** Exact URL pathname no se inventa como product requirement.

**AC-020-156.** No concrete production email provider se selecciona.

**AC-020-157.** RF-004 permanece `NO / PARTIAL` mientras delivery end-to-end no exista.

**AC-020-158.** Admin UI requiere target email + intended role.

**AC-020-159.** Admin UI de TASK-020 no incluye Client selector.

**AC-020-160.** Admin UI no presenta foundation como user creation completed.

**AC-020-161.** Resend UI no permite editar tenant/email/role.

**AC-020-162.** Target verify UI no incluye profile form.

**AC-020-163.** Target verify UI no concede tenant application access.

**AC-020-164.** Successful verify UI comunica verification/handoff, no onboarding completion.

**AC-020-165.** Enrollment es ONLINE-ONLY.

**AC-020-166.** No Dexie enrollment state.

**AC-020-167.** No IndexedDB authority.

**AC-020-168.** No issue/resend/verify outbox.

**AC-020-169.** No optimistic local enrollment.

**AC-020-170.** No new AuditEvent action para issue.

**AC-020-171.** No new AuditEvent action para resend.

**AC-020-172.** No new AuditEvent action para verify.

**AC-020-173.** USER_CREATED no es producido por TASK-020.

**AC-020-174.** `establishment_operation_id` implementa initial idempotency.

**AC-020-175.** `issue_operation_id` se reutiliza para issue/resend.

**AC-020-176.** `verification_operation_id` se reutiliza para verify.

**AC-020-177.** Operation IDs no son secrets.

**AC-020-178.** Operation IDs no son authority.

**AC-020-179.** Initial establishment atomicity queda probada.

**AC-020-180.** Resend atomicity queda probada.

**AC-020-181.** Verify success atomicity queda probada.

**AC-020-182.** Wrong-attempt atomicity queda probada.

**AC-020-183.** Concurrency tests usan conexiones/transacciones reales cuando corresponda.

**AC-020-184.** Verify-vs-resend race no produce dual authoritative success.

**AC-020-185.** Double verify no produce double consume/grant/handoff.

**AC-020-186.** Attempt-limit races no exceden 3 effective attempts.

**AC-020-187.** Secrets no se loggean.

**AC-020-188.** PII logging se minimiza.

**AC-020-189.** Task no decide new retention policy.

**AC-020-190.** TASK-009 identity foundation permanece compatible.

**AC-020-191.** TASK-010 AuditEvent catalog permanece compatible.

**AC-020-192.** TASK-011 SSR lifecycle permanece compatible.

**AC-020-193.** TASK-012 authoritative authz permanece compatible.

**AC-020-194.** TASK-013 challenge/grant/E2 permanece compatible.

**AC-020-195.** TASK-014 global authority permanece compatible.

**AC-020-196.** TASK-015 membership lifecycle permanece compatible.

**AC-020-197.** TASK-016 company creation permanece compatible.

**AC-020-198.** TASK-017 first-admin purpose-specific semantics no se generalizan.

**AC-020-199.** TASK-018 first-admin Auth/session no se ejecuta en TASK-020.

**AC-020-200.** TASK-019 first-admin completion no se ejecuta en TASK-020.

**AC-020-201.** CORR-039 Client boundary permanece intacto.

**AC-020-202.** CORR-040 ordinary later-user incomplete state permanece compatible.

**AC-020-203.** CORR-042 current state permanece compatible.

**AC-020-204.** New ADR required before implementation = NO mientras no surja decisión transversal nueva.

**AC-020-205.** Implementation requiere fresh repository preflight.

**AC-020-206.** Repository/canon drift material produce blocker.

**AC-020-207.** Provider contract material drift produce blocker.

**AC-020-208.** Hosted Development mutation requiere Gate humano separado.

**AC-020-209.** Staging/Production no se modifican por inferencia.

**AC-020-210.** All DB schema tests pasan.

**AC-020-211.** All authorization tests pasan.

**AC-020-212.** All RLS/privilege tests pasan.

**AC-020-213.** All challenge lifecycle tests pasan.

**AC-020-214.** All verify/handoff tests pasan.

**AC-020-215.** All concurrency tests pasan.

**AC-020-216.** All delivery tests pasan.

**AC-020-217.** All UI/application boundary tests pasan.

**AC-020-218.** Relevant TASK-009..019 regressions pasan.

**AC-020-219.** Lint pasa.

**AC-020-220.** Strict typecheck pasa.

**AC-020-221.** Build pasa.

**AC-020-222.** Repository verification scripts pasan.

**AC-020-223.** `git diff --check` pasa.

**AC-020-224.** No archivos/cambios fuera de scope.

**AC-020-225.** No whitespace cleanup lateral.

**AC-020-226.** Implementation review es Gate separado.

**AC-020-227.** Staging authorization es Gate separado.

**AC-020-228.** Commit authorization es Gate separado.

**AC-020-229.** Push authorization es Gate separado.

**AC-020-230.** TASK-020 closure no autoriza automáticamente la continuation Auth/session.



**AC-020-231.** Authenticated direct SELECT sobre `later_user_enrollment_intents` permanece denegado; UI/application usa boundaries purpose-specific.

**AC-020-232.** Una distinct establishment operation para el mismo authoritative tenant + target email no crea silenciosamente un competing intent mientras cancel/restart/replace permanezca indefinido.

**AC-020-233.** El collision de tenant+email usa fail-closed `CONFLICT — RESTART/REPLACE SEMANTICS UNDEFINED` sin mutation ni new challenge.

**AC-020-234.** Si la carrera de competing intents no puede protegerse sin nueva semántica de producto o uniqueness material, implementation se bloquea y vuelve al Revisor Central.

---

## 44. Definition of Done


**DoD-020-001.** Specification generation completada.

**DoD-020-002.** TASK-020 SPEC REVIEW aprobado.

**DoD-020-003.** Aprobación humana de specification realizada mediante Gate separado.

**DoD-020-004.** Approved artifact generado mediante step separado si el lifecycle vigente lo exige.

**DoD-020-005.** Approved artifact review aprobado.

**DoD-020-006.** Canonicalization authorization aprobada.

**DoD-020-007.** Canonicalization completada.

**DoD-020-008.** Canonicalization review aprobada.

**DoD-020-009.** Repository incorporation authorization aprobada.

**DoD-020-010.** Specification canónica incorporada a `docs/tasks/...`.

**DoD-020-011.** Repository incorporation review aprobada.

**DoD-020-012.** Implementation authorization aprobada mediante Gate separado.

**DoD-020-013.** Fresh Git/repository preflight PASS inmediatamente antes de implementar.

**DoD-020-014.** Canonical sources requeridas disponibles.

**DoD-020-015.** Repository schema/API baseline compatible o drift revisado humanamente.

**DoD-020-016.** Una migration forward-only TASK-020 implementa sólo el slice aprobado.

**DoD-020-017.** `public.later_user_enrollment_intents` existe exactamente una vez.

**DoD-020-018.** Exact column set coincide con specification aprobada.

**DoD-020-019.** Constraints/FKs/indexes expected-only.

**DoD-020-020.** No target-email uniqueness no aprobada.

**DoD-020-021.** RLS enabled y privilege model aprobado.

**DoD-020-022.** No generic direct table writes.

**DoD-020-023.** No generic privileged/service-role client.

**DoD-020-024.** Current COMPANY_ADMIN initial establishment implementado.

**DoD-020-025.** Tenant derivation sólo desde current membership verificada.

**DoD-020-026.** Intended role binding sólo COMPANY_ADMIN/TECHNICIAN.

**DoD-020-027.** Initial intent + challenge + pointer atomicity verificada.

**DoD-020-028.** Initial operation idempotency verificada.

**DoD-020-029.** Authorized resend implementado.

**DoD-020-030.** Resend current-authority revalidation verificada sin asumir semántica de continuation/invalidation/authority transfer cuando el initiating admin haya perdido autoridad; ese caso permanece deferred y bloquea si resulta material.

**DoD-020-031.** Resend atomic successor/current-pointer behavior verificado.

**DoD-020-032.** Current-challenge pre-auth verify implementado.

**DoD-020-033.** Attempt/consume + SessionGrant + handoff atomicity verificada.

**DoD-020-034.** Durable handoff facts implementados.

**DoD-020-035.** No Auth identity/session continuation implementada.

**DoD-020-036.** No PlatformUser/profile/membership/client scope completion implementada.

**DoD-020-037.** No USER_CREATED producido.

**DoD-020-038.** Provider-neutral delivery boundary implementada sin provider productivo nuevo.

**DoD-020-039.** RF-004 no se sobredeclara como end-to-end.

**DoD-020-040.** UI/application behavior permanece dentro del slice.

**DoD-020-041.** Offline enrollment artifacts ausentes.

**DoD-020-042.** AuditEvent catalog permanece sin cambio.

**DoD-020-043.** DB schema tests PASS.

**DoD-020-044.** Authorization tests PASS.

**DoD-020-045.** RLS/privilege tests PASS.

**DoD-020-046.** Challenge lifecycle tests PASS.

**DoD-020-047.** Verification/handoff tests PASS.

**DoD-020-048.** Real concurrency tests PASS.

**DoD-020-049.** Delivery tests PASS.

**DoD-020-050.** UI/application boundary tests PASS.

**DoD-020-051.** Relevant regression suites TASK-009..019 PASS.

**DoD-020-052.** Lint PASS.

**DoD-020-053.** Strict typecheck PASS.

**DoD-020-054.** Build PASS.

**DoD-020-055.** Repository verify/checks PASS.

**DoD-020-056.** `git diff --check` PASS.

**DoD-020-057.** Complete diff revisado por arquitectura, seguridad, RLS, multitenancy y scope.

**DoD-020-058.** No extra files o cleanup lateral.

**DoD-020-059.** Hosted Development authorization obtenida antes de cualquier remote mutation/testing cuando corresponda.

**DoD-020-060.** Hosted Development verification PASS cuando corresponda.

**DoD-020-061.** Staging permanece separado y requiere authorization/review.

**DoD-020-062.** Commit permanece separado y requiere authorization/review.

**DoD-020-063.** Push permanece separado y requiere authorization/remote review.

**DoD-020-064.** Remote content corresponde al reviewed commit.

**DoD-020-065.** Final human closure se realiza mediante Gate separado.

**DoD-020-066.** TASK-020 final closure no declara RF-013 completo.

**DoD-020-067.** TASK-020 final closure no declara RF-015 satisfecho.

**DoD-020-068.** TASK-020 final closure mantiene ordinary later-user onboarding incomplete.

**DoD-020-069.** Next continuation task no se determina ni autoriza automáticamente por esta specification.


**DoD-020-070.** Direct SELECT/CRUD de intent por `authenticated` permanece ausente y las application surfaces usan sólo boundaries purpose-specific.

**DoD-020-071.** Distinct-operation same-tenant/email collision se prueba fail-closed sin competing intent/challenge y sin resolver cancel/restart/replace por inferencia.

---

## 45. Lifecycle de governance

Debe preservarse una secuencia separada equivalente a:

```text
TASK-020 SPECIFICATION GENERATION
→ TASK-020 SPEC REVIEW
→ TASK-020 HUMAN APPROVAL
→ APPROVED ARTIFACT / REVIEW cuando corresponda
→ CANONICALIZATION AUTHORIZATION
→ CANONICALIZATION
→ CANONICALIZATION REVIEW
→ REPOSITORY INCORPORATION AUTHORIZATION
→ REPOSITORY INCORPORATION
→ REPOSITORY INCORPORATION REVIEW
→ TASK-020 IMPLEMENTATION AUTHORIZATION
→ TASK-020 IMPLEMENTATION
→ TASK-020 IMPLEMENTATION REVIEW
→ HOSTED DEVELOPMENT AUTHORIZATION/VERIFICATION cuando corresponda
→ STAGING AUTHORIZATION
→ STAGING
→ STAGING REVIEW
→ COMMIT AUTHORIZATION
→ COMMIT
→ COMMIT REVIEW
→ PUSH AUTHORIZATION
→ PUSH
→ PUSH REVIEW / REMOTE VERIFICATION
→ FINAL HUMAN CLOSURE
```

Cada Gate es separado.

```text
spec review != human approval
human approval != implementation authorization
implementation != staging
staging != commit
commit != push
push != remote verification
TASK-020 closure != next-task authorization
```

---

## 46. Resultado de esta generación

```text
TASK-020 SPECIFICATION GENERATION =
PASS

TASK-020 CORRECTED SPEC REVIEW =
APPROVED

F-020-SPEC-001 =
CLOSED

TASK-020 HUMAN APPROVAL =
APPROVED

TASK-020 specification =
HUMAN APPROVED

TASK-020 approved artifact =
REVIEW APPROVED

TASK-020 APPROVED ARTIFACT REVIEW =
APPROVED

TASK-020 CANONICALIZATION =
PASS

TASK-020 canonical artifact =
GENERATED / PENDING CANONICALIZATION REVIEW

TASK-020 implementation =
NOT AUTHORIZED

Codex implementation =
NOT AUTHORIZED

repository mutation =
NO

Supabase Local mutation =
NO

Supabase Cloud mutation =
NO

Client =
Phase 3

RF-015 =
MANDATORY / UNCHANGED

ordinary later-user onboarding =
INCOMPLETE

new ADR required before TASK-020 implementation =
NO
```

No se detectó una necesidad obligatoria de resolver las decisiones diferidas de ADR-0021 para especificar este slice.

---

## 47. Siguiente Gate

Siguiente Gate exclusivamente:

```text
TASK-020 CANONICALIZATION REVIEW
```

Destino:

```text
REVISOR CENTRAL
```

No implementar.

No usar Codex para implementación.

No modificar repositorio.

No staging.

No commit.

No push.

STOP.
