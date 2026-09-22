# TASK-017 — Authoritative First-Admin Onboarding Intent and Verification Handoff Foundation

## 1. Identification

**TASK ID:** `TASK-017`

**Title:** `Authoritative First-Admin Onboarding Intent and Verification Handoff Foundation`

**Type:** `IMPLEMENTATION TASK / IDENTITY & AUTHORIZATION FOUNDATION`

**Phase:** `Fase 2 — Multitenancy, autenticación, roles y RLS`

**Primary bounded context:** `Identity & Authorization / Identity & Auth`

**Canonical candidate artifact:** `TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md`

**Target canonical repository path, only after Canonicalization Review and repository-incorporation authorization:** `docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md`

This artifact is a new substantive specification generated after resolving the prior canonical-source availability blocker.

The earlier file named `TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md` with SHA-256 `3b80aebea0c7ce338163e19c364bc92fdb160269a127a2f5063930f208da44c6` was exclusively a specification-generation blocker record. It is not a partial specification, is not canonical, and is not a requirements source for this document.

---

## 2. Status / authorization

```text
TASK-017 SPECIFICATION GENERATION GATE =
AUTHORIZED

TASK-017 REQUIRED CANONICAL SOURCE RECOVERY =
PASS

TASK-017 REQUIRED CANONICAL SOURCE RECOVERY REVIEW =
APPROVED

TASK-017 CANONICAL SOURCE AVAILABILITY CHECK =
PASS

TASK-017 SPECIFICATION RESUMPTION =
AUTHORIZED UNDER EXISTING GATE

TASK-017 CENTRAL SPEC REVIEW =
APPROVED

TASK-017 HUMAN SPECIFICATION APPROVAL =
APPROVED

TASK-017 APPROVED ARTIFACT REVIEW =
APPROVED

TASK-017 SPECIFICATION =
APPROVED

TASK-017 approved artifact =
GENERATED

TASK-017 canonicalization =
CANDIDATE GENERATED — PENDING CENTRAL REVIEW

TASK-017 canonical candidate =
GENERATED

TASK-017 repository incorporation =
NOT AUTHORIZED / NOT APPROVED

TASK-017 implementation =
NOT AUTHORIZED / NOT STARTED

Codex =
NOT AUTHORIZED

repository mutation =
NO

Supabase / Hosted mutation =
NO

staging / commit / push =
NO / NO / NO
```

This document does not approve itself, does not canonicalize itself, does not authorize implementation, does not authorize Codex, and does not authorize any repository, Supabase, Hosted Development, Staging, Production or Git mutation.

---

## 3. Canonical source recovery and physical identity verification

Before generating substantive content, the four recovered sources required by the existing Gate were read from their physical bytes and verified without reconstruction or reserialization.

| Source | Canonical repo-relative path | SHA-256 | Bytes | LF | CRLF | Bare CR | Trailing-whitespace lines | Final newline | Result |
|---|---|---:|---:|---:|---:|---:|---:|---|---|
| ADR-0020 | `docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md` | `30480be7c24a260fe4d6d8231cb83134133192e9b37f052310b9522196be1a5c` | 74803 | 1768 | 0 | 0 | 0 | YES | PASS |
| TASK-016 | `docs/tasks/TASK-016-maintenance-company-global-authoritative-creation.md` | `1627aa3bcece1c89c3bad8840e74a32f689e3916ebcc23c5031ff38e88dd063e` | 66725 | 2735 | 0 | 0 | 0 | YES | PASS |
| CORR-026 | `docs/tasks/CORR-026-task-016-closure-state-sync.md` | `2b6e56229428ab531776fdc54e96034cced9b03e932514781099c2b423f88d6f` | 46755 | 2444 | 0 | 0 | 0 | YES | PASS |
| CORR-027 | `docs/tasks/CORR-027-adr-0020-acceptance-documentation-state-sync.md` | `6f06a02301aa0a1d8372f4d7512ba384d436a94dae4a51047be96b3230907fff` | 45906 | 1794 | 0 | 0 | 0 | YES | PASS |

Result:

```text
TASK-017 SPECIFICATION RESUMPTION BLOCKER =
RESOLVED

CANONICAL SOURCE IDENTITY / AVAILABILITY FAILURE =
NO
```

---

## 4. Objective

TASK-017 defines one PR-sized foundation whose unique objective is to make implementable, after separate approval and execution authorization, the authoritative first-admin onboarding segment that begins after a `MaintenanceCompany` already exists and ends once the current business proof has been consumed and a durable authoritative handoff exists for a future continuation of RF-012.

The exact boundary is:

```text
START
=
existing active MaintenanceCompany
created by a current authoritative SUPER_ADMIN

END
=
valid current VerificationChallenge consumed
+
authoritative first-admin onboarding handoff durably available
for a future continuation of RF-012
```

Nominal capability:

1. establish exactly one authoritative `FirstAdminOnboardingIntent` for the target company;
2. bind it to exactly one existing `MaintenanceCompany`;
3. bind it to the first-admin target email;
4. fix the purpose to first-admin onboarding;
5. fix the intended role to `COMPANY_ADMIN` as a domain consequence of that purpose, without creating tenant authority;
6. issue the first `VerificationChallenge` by reusing TASK-013;
7. preserve exactly one current challenge;
8. support authorized resend/replacement;
9. reauthorize current `SUPER_ADMIN` authority on initial issue and every resend;
10. verify only the current challenge against the intent binding;
11. consume the proof and create/reconcile the corresponding `SessionGrant` using the existing E2 foundation;
12. persist enough authoritative handoff evidence for a future RF-012 task to continue without trusting caller-supplied tenant, role or email authority.

TASK-017 is deliberately not the first-admin onboarding completion task.

---

## 5. Sources and authority

### 5.1 Product sources

The specification consumes the current applicable canon, including:

- `docs/product/00-master-product-brief.md`;
- `docs/product/01-product-definition.md`;
- `docs/product/02-domain-model.md`;
- `docs/product/03-permissions-rls-strategy.md`;
- `docs/product/04-offline-sync-strategy.md`;
- `docs/product/10-architecture-decisions-records.md`;
- `docs/product/11-phase-1-scope-entry-gate.md`, interpreted together with later approved state-sync documents where an older attached snapshot is historical.

### 5.2 Architecture sources

- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`;
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`;
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`;
- `docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md`.

### 5.3 Phase 2 foundations

- `docs/tasks/TASK-009-identity-tenant-foundation.md`;
- `docs/tasks/TASK-010-audit-event-foundation.md`;
- `docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md`;
- `docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`;
- `docs/tasks/TASK-013-verification-challenge-foundation.md`;
- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`;
- `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`;
- `docs/tasks/TASK-016-maintenance-company-global-authoritative-creation.md`;
- `docs/tasks/CORR-026-task-016-closure-state-sync.md`;
- `docs/tasks/CORR-027-adr-0020-acceptance-documentation-state-sync.md`.

### 5.4 Order of authority

For TASK-017:

1. explicit later human-approved decisions and current Gate state within their scope;
2. `01-product-definition.md`;
3. derived product documents inside their bounded context;
4. accepted ADRs inside the decisions they govern;
5. TASK/CORR documents as implementation/state contracts;
6. the real repository, during a future authorized implementation, as the source of truth for current physical names, signatures, dependencies, migrations and tests.

Historical snapshots remain historical and are not rewritten as current state.

If future implementation inspection reveals a material contradiction between the approved TASK-017 specification and current canonical repository state, implementation must stop rather than silently repair or reinterpret the canon.

---

## 6. Current-state baseline

The current baseline consumed by this approved specification is:

```text
Phase 0 =
COMPLETED

Phase 1 =
COMPLETED

Phase 2 =
INICIADA / NOT DONE

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED

TASK-013 VerificationChallenge / SessionGrant foundation =
IMPLEMENTED / CLOSED

TASK-014 authoritative SUPER_ADMIN foundation =
IMPLEMENTED / CLOSED

TASK-015 CompanyMembership lifecycle + atomic AuditEvent =
IMPLEMENTED / CLOSED

TASK-016 authoritative MaintenanceCompany creation =
DONE / CLOSED

TASK-016 FINAL HUMAN CLOSURE =
APPROVED

TASK-016 Hosted Development =
APPLIED AND VERIFIED

ADR-0020 architecture decision =
ACCEPTED BY HUMAN APPROVAL

ADR-0020 canonicalization =
APPROVED

ADR-0020 repository incorporation =
APPROVED

first-admin onboarding intent-binding architectural prerequisite =
RESOLVED
```

TASK-016's closed functional maximum is:

```text
current authoritative SUPER_ADMIN
→ create MaintenanceCompany
→ active tenant identity exists
```

and nothing beyond RF-001, RF-002 and FL-01 steps 1–2 is inferred from that closure.

Existing relevant physical foundations include:

```text
public.maintenance_companies
public.platform_users
public.platform_user_auth_subjects
public.company_memberships
public.audit_events
public.verification_challenges
public.verification_challenge_attempts
public.auth_bridge_credentials
public.auth_session_grants
```

TASK-017 must extend these foundations without duplicating or weakening their existing security semantics.

---

## 7. Scope

### 7.1 In scope

TASK-017 may implement, after approval:

- one platform-owned physical representation of `FirstAdminOnboardingIntent`;
- establishment correlation/idempotency for the initial logical operation;
- immutable binding to one existing `MaintenanceCompany`;
- first-admin target-email binding;
- initiator provenance for the `SUPER_ADMIN` that established the intent;
- exactly one current challenge pointer;
- durable proof/handoff facts required by ADR-0020;
- initial challenge issuance by composing the existing TASK-013 challenge foundation;
- resend/replacement by composing the existing TASK-013 successor/invalidation foundation;
- verification of the current challenge only;
- atomic intent-binding check + TASK-013 challenge consume + `SessionGrant` creation/reconciliation;
- server-side application contracts and purpose-specific boundaries;
- provider-neutral email-delivery boundary only, without selecting or wiring a production provider;
- RLS/privilege hardening for the new platform-owned intent state;
- DB/application tests, concurrency tests and negative security tests;
- Hosted Development verification through a later, separately authorized Gate.

### 7.2 Product coverage boundary

The product requirements to be covered or partially covered are RF-003..RF-011 and FL-01 steps 3–5.

Verification/consume and authoritative handoff are included as the minimum technical bridge required to stop safely before the remaining RF-012 lifecycle.

### 7.3 No scope expansion by implementation convenience

A future implementation may not add a generic invitation system, generic enrollment workflow, generic idempotency framework, microservice, generic privileged Supabase client, new tenant role, new tenant state machine or commercial state merely because those abstractions could make implementation easier.

---

## 8. Out of scope

TASK-017 does not implement or decide:

- profile completion;
- profile fields;
- exact Auth user creation timing;
- Auth user creation itself;
- `PlatformUser` creation;
- initial `CompanyMembership` creation;
- disabled pre-profile membership as an invented intermediate state;
- enabled `CompanyMembership`;
- enabled tenant authority;
- exact `USER_CREATED` producer timing;
- full RF-012;
- FL-01 steps 6–8 as a completed flow;
- first-admin onboarding completion;
- ordinary later-user onboarding;
- role/client assignment for later users;
- `UserClientAccess`;
- `SupportAccessGrant`;
- Subscription;
- promotional entitlement;
- commercial anchor;
- PAY-OPEN-001;
- PAY-OPEN-008;
- target-email change;
- cancel/restart semantics;
- automatic cancellation after initiator authority revocation;
- PII retention duration or hard-delete policy;
- a production email provider;
- provider-specific delivery retry/backoff;
- durable delivery queue/outbox;
- email provider webhook processing;
- a generic privileged/service-role request client;
- offline onboarding;
- Dexie/IndexedDB onboarding state;
- Service Worker onboarding flow;
- a production visual onboarding design;
- post-onboarding dashboard/navigation;
- password UX;
- a new verification engine;
- tenant/role fields inside `VerificationChallenge`;
- a new audit action name for issue, resend or verify.

The specification also does not select a human-facing verification-code alphabet, digit count or visual format because the current canon deliberately leaves that product/UX detail undefined. The authoritative challenge foundation treats code material as an opaque transient proof value. A future production delivery/UX decision may constrain its presentation without altering TASK-013 lifecycle rules.

---

## 9. Product requirement mapping

| Requirement | Canonical meaning | TASK-017 treatment | Coverage | Acceptance coverage |
|---|---|---|---|---|
| RF-003 | During company onboarding the first `COMPANY_ADMIN` email is indicated | `SUPER_ADMIN` establishment input binds one target email to the intent and first challenge | IN SCOPE | AC-017-035, AC-017-045, AC-017-047..059 |
| RF-004 | System sends a verification code to the indicated email | TASK-017 creates authoritative issuance and a provider-neutral delivery handoff/port; no concrete provider or provider retry policy is selected | PARTIAL | AC-017-046, AC-017-057..059, AC-017-121..130 |
| RF-005 | Each emission is valid for 8 hours | Reuse TASK-013 exact server-authoritative expiry | IN SCOPE | AC-017-064, AC-017-080 |
| RF-006 | Max 3 verification attempts per emission | Reuse TASK-013 atomic attempt accounting | IN SCOPE | AC-017-065..068, AC-017-097..100 |
| RF-007 | Authorized enrollment actor can resend as needed | Current authoritative `SUPER_ADMIN` may resend while TASK-017 intent remains eligible; every call reauthorizes | IN SCOPE | AC-017-071..077 |
| RF-008 | Every resend emits a new code | Reuse successor challenge creation with new challenge identity and issue operation | IN SCOPE | AC-017-074..082 |
| RF-009 | New emission immediately invalidates previous emission | Invalidation + successor + current pointer rotate atomically | IN SCOPE | AC-017-078, AC-017-082..085 |
| RF-010 | Each new emission has its own 3 attempts | Successor starts `attempt_count = 0` under TASK-013 | IN SCOPE | AC-017-065..068, AC-017-081 |
| RF-011 | Expired emission cannot be recovered or reused | Expired challenge remains terminal; resend creates a new emission, never reactivates old | IN SCOPE | AC-017-069, AC-017-076, AC-017-101 |
| FL-01 step 3 | SUPER_ADMIN enters first-admin email | Intent establishment contract accepts target email after current SUPER_ADMIN reauthorization | IN SCOPE | AC-017-035, AC-017-045, AC-017-047..059 |
| FL-01 step 4 | Valid 8h/3-attempt code is issued | Authoritative issuance is complete; external email delivery remains a separate partial dependency | IN SCOPE / DELIVERY PARTIAL | AC-017-046, AC-017-057..068, AC-017-121..130 |
| FL-01 step 5 | Resend creates new code and invalidates previous | Atomic successor/invalidation/current pointer rotation | IN SCOPE | AC-017-071..085 |
| RF-012 | First admin enters using email + valid code and completes profile | TASK-017 only verifies/consumes current proof and creates durable authoritative handoff; profile/identity/membership/authority enablement remain future work | PARTIAL FOUNDATION ONLY | AC-017-086..120 |

TASK-017 must never report `RF-004 = fully implemented end-to-end` merely because an authoritative `VerificationChallenge` row exists.

---

## 10. Domain model

### 10.1 Domain requirement — `FirstAdminOnboardingIntent`

`FirstAdminOnboardingIntent` is a purpose-specific, platform-owned intent representing the one authoritative first-admin onboarding binding for a `MaintenanceCompany`.

Its domain identity is distinct from:

```text
MaintenanceCompany.id
VerificationChallenge.id
SessionGrant.id
target email
Auth subject
PlatformUser.id
CompanyMembership.id
```

It binds:

```text
one MaintenanceCompany
+
one target email
+
fixed purpose = first-admin onboarding
+
fixed intended role = COMPANY_ADMIN
+
exactly one current VerificationChallenge at a time
+
historical initiating SUPER_ADMIN provenance
+
durable proof/handoff state
```

### 10.2 Domain invariants

1. One `MaintenanceCompany` can have at most one authoritative first-admin intent capable of reaching onboarding completion.
2. The target company binding cannot change.
3. The target email binding cannot change in TASK-017.
4. Purpose is fixed by entity type and is not caller-selectable.
5. Intended role is fixed to `COMPANY_ADMIN` and is not caller-selectable.
6. `COMPANY_ADMIN` as intended role does not create a `CompanyMembership`.
7. Initiator provenance is historical; it is not current authority for future issue/resend.
8. Exactly one current challenge is referenced after every successful initial issue or resend.
9. Only that current challenge can produce proof for the intent.
10. A successful proof/handoff is not onboarding completion.
11. A successful proof/handoff is not enabled tenant authority.
12. No state in TASK-017 can make the initiating `SUPER_ADMIN` a tenant member.

### 10.3 Email semantics

The target email is:

- PII;
- a locator and proof target;
- not a tenant identifier;
- not application identity authority;
- not tenant authority;
- not globally unique by TASK-017;
- not mutable by TASK-017.

TASK-017 does not create a new global email-normalization policy. The same provider-correlatable canonical email value must be used consistently by the intent, TASK-013 challenge/bridge logic and future Auth continuation. If the real repository/provider behavior cannot produce an unambiguous stable correlation under the existing TASK-013 contract, implementation must fail closed and return for review rather than weaken matching.

### 10.4 Purpose and intended role

The domain type itself implies:

```text
purpose = first-admin onboarding
intended role = COMPANY_ADMIN
```

Neither value is accepted as mutable caller input.

### 10.5 Lifecycle facts

Conceptual lifecycle:

```text
intent + first challenge established
→ zero or more authorized challenge replacements
→ current challenge verified / consumed
→ authoritative handoff ready
→ [TASK-017 ENDS]
→ future RF-012 continuation
→ future profile completion
→ future authority-enabling transition
→ eventual onboarding completion
```

No generic `status` enum is required by the domain if state can be derived safely from authoritative facts.

---

## 11. Proposed physical representation

This section is the **TASK-017 physical proposal approved as part of this specification**, not a separate product or architecture decision. It is justified by ADR-0020 and is binding within the approved TASK-017 implementation scope.

### 11.1 Table

Proposed physical table:

```text
public.first_admin_onboarding_intents
```

It is platform-owned.

### 11.2 Minimal proposed fields

| Field | Proposed physical semantics |
|---|---|
| `id` | UUID primary key, stable intent identity |
| `maintenance_company_id` | required FK to the existing `MaintenanceCompany`; unique for first-admin intent |
| `target_email` | required target locator/PII; no global uniqueness |
| `initiated_by_platform_user_id` | required FK preserving historical initiating `SUPER_ADMIN` provenance |
| `establishment_operation_id` | required unique UUID for initial intent-establishment idempotency |
| `current_challenge_id` | required unique FK to the current `verification_challenges` row after a successful transaction |
| `handoff_session_grant_id` | nullable unique FK to the `auth_session_grants` row produced by successful current-proof consume |
| `handoff_ready_at` | nullable authoritative server timestamp marking durable handoff readiness |
| `created_at` | required authoritative server timestamp |

### 11.3 Constraints required by the proposal

- one intent per `maintenance_company_id`;
- unique `establishment_operation_id`;
- one intent may point to one current challenge;
- a challenge cannot be current for two intents;
- `handoff_session_grant_id` cannot be shared between intents;
- `handoff_session_grant_id` and `handoff_ready_at` are either both absent or both present;
- FKs must use restrictive deletion semantics appropriate to historical security state;
- no target-email uniqueness is introduced;
- no role column is introduced;
- no purpose column is introduced;
- no `maintenance_company_id` is added to `verification_challenges`;
- no onboarding-completion column is defined by TASK-017.

Cross-table invariants that cannot be represented safely by ordinary CHECK constraints must be enforced only through narrow transactional functions and verified by concurrent tests.

### 11.4 Why no completion field is fixed here

ADR-0020 requires the intent model to be extensible to eventual single-use completion evidence but explicitly leaves the exact physical completion shape and the transition that establishes it to future RF-012 implementation work.

TASK-017 therefore persists durable handoff facts but does not invent the exact eventual completion field/record. Before a future task can enable tenant authority, it must add or consume the approved completion representation required at that time.

### 11.5 No historical backfill

No existing `MaintenanceCompany` receives a fabricated first-admin intent by migration.

An intent is created only by an authorized first-admin establishment use case after TASK-017 is deployed.

---

## 12. Ownership model

### 12.1 Tenant-owned data

`MaintenanceCompany` remains the tenant boundary.

Existing tenant-owned data remains governed by tenant ownership and RLS. TASK-017 does not weaken any existing tenant policy.

### 12.2 Platform-owned data

The following state is platform-owned:

- `FirstAdminOnboardingIntent`;
- `VerificationChallenge`;
- `VerificationChallengeAttempt`;
- `AuthBridgeCredential`;
- `SessionGrant`.

Platform-owned does not mean public, browser-readable, browser-writable or `authenticated`-readable.

### 12.3 Binding is not ownership transfer

Although an intent references a `MaintenanceCompany`, the intent is not ordinary tenant-owned data because it exists before a first tenant member exists and coordinates platform identity/authentication with an already-created tenant identity.

The initiating `SUPER_ADMIN` does not become a tenant member by creating or resending the intent.

### 12.4 Tenant derivation for future continuation

After intent establishment, the target tenant for every verify/handoff/future continuation is derived from:

```text
FirstAdminOnboardingIntent.maintenance_company_id
```

A caller-supplied tenant identifier can be a locator only for initial establishment by an already-authorized global actor. It never becomes the authority for verify or handoff.

---

## 13. Authorization model

### 13.1 Inherited invariant

```text
authenticated != authorized

current authoritative PostgreSQL state
>
JWT / session / frontend claims / cached role
```

### 13.2 Initial establishment actor

The only functional actor allowed to establish a first-admin intent and initial challenge is:

```text
current authoritative SUPER_ADMIN
```

The mutation boundary must derive authority from the validated `auth.uid()` and current database state using the TASK-014 authority model.

Positive authority requires, at minimum:

```text
resolved PlatformUser
AND
platform_users.is_super_admin = true
AND
no CompanyMembership exists for that PlatformUser
```

Enabled or disabled membership both invalidate global classification under TASK-014 semantics.

### 13.3 Resend actor

Every resend/replacement call must re-run current authoritative `SUPER_ADMIN` classification inside the mutation boundary.

Historical initiator provenance does not authorize resend.

### 13.4 Verify actor

Verification is pre-auth for the target first admin. It is not authorized by a tenant session.

The verify boundary uses:

- an opaque intent locator;
- presented email as proof locator, not authority;
- candidate code;
- idempotency correlation;
- server-only challenge verification primitives;
- authoritative intent/current-challenge state.

Verify never accepts a tenant target or role as authority.

### 13.5 Authority loss

If a `SUPER_ADMIN` loses global authority before an initial issue/resend transaction confirms:

```text
result = DENY
intent mutation = NONE
challenge mutation = NONE
```

The same idempotency key cannot resurrect a privileged success after authority is lost.

Authority lost after a prior committed issue does not retroactively delete the intent or invalidate the proof by inference. It only prevents privileged future issue/resend by that actor while authority is absent.

### 13.6 Known incompatible bootstrap state

Initial establishment must fail closed when current authoritative application state demonstrates an identity/membership condition incompatible with initial first-admin bootstrap.

Examples of incompatible known state include an unambiguous target Auth/application identity already classified as global `SUPER_ADMIN`, or a target `PlatformUser` already possessing any `CompanyMembership`.

TASK-017 must not solve this by generic Auth user enumeration, account takeover, role reassignment or silent repair. Unknown provider-only identities remain a future reconciliation concern under ADR-0019/ADR-0020 and do not authorize generic Admin search.

---

## 14. Security invariants

TASK-017 must preserve all of the following:

```text
MaintenanceCompany = tenant

tenant isolation = MANDATORY

RLS = mandatory for tenant-owned data

FirstAdminOnboardingIntent = platform-owned

VerificationChallenge = platform-owned

SessionGrant = platform-owned

SUPER_ADMIN = global platform authority
SUPER_ADMIN != tenant member
SUPER_ADMIN != ordinary tenant bypass

email != tenant authority
challenge != tenant authority
SessionGrant != tenant authority
Auth identity != tenant authority
Supabase session != tenant authority

caller-supplied maintenance_company_id != authority
caller-supplied role != authority
caller-supplied email != authority

current PostgreSQL state > stale claims

browser direct DB mutation = FORBIDDEN

generic service-role request client = FORBIDDEN

profile completion before enabled first-admin tenant authority = PRESERVED
```

Additional TASK-017 invariants:

1. one company cannot have two competing first-admin intents;
2. one intent cannot have two current challenges;
3. a predecessor challenge cannot become current again;
4. a challenge from intent A cannot verify intent B;
5. a successful verification cannot choose a different tenant;
6. purpose and intended role cannot be caller-selected;
7. no positive privileged idempotent result is returned before current authorization is revalidated where authorization applies;
8. a handoff is not exposed as a browser bearer authority;
9. no plaintext code is persisted;
10. no challenge HMAC key, technical-password key, Supabase secret, access token or refresh token is persisted in the intent.

---

## 15. RLS / privilege model

### 15.1 New intent table

`public.first_admin_onboarding_intents` must have RLS enabled as defense in depth.

Ordinary Data API contract:

```text
anon direct SELECT/INSERT/UPDATE/DELETE =
NO

authenticated direct SELECT/INSERT/UPDATE/DELETE =
NO

PUBLIC direct CRUD =
NO

browser direct DB mutation =
NO
```

No artificial tenant policy is added to make the platform-owned intent look tenant-owned.

### 15.2 Existing tenant RLS

TASK-017 must not weaken RLS on:

- `maintenance_companies`;
- `company_memberships`;
- future client-scoped tables;
- any tenant-owned operational table.

A new intent FK to `MaintenanceCompany` does not grant read/write access to that tenant.

### 15.3 Initial issue/resend mutations

The preferred physical boundary is a purpose-specific database function/RPC that:

- preserves the real caller identity;
- anchors the actor at `auth.uid()`;
- revalidates current global authority;
- has only the minimum privileges necessary to mutate intent/challenge state;
- uses a fixed/safe `search_path`;
- uses schema-qualified references where appropriate;
- does not accept actor authority from the caller;
- does not accept role authority from the caller;
- does not expose arbitrary table operations.

Because ordinary authenticated roles do not have direct write access to the platform tables, a narrowly reviewed `SECURITY DEFINER` boundary is permitted for initial issue/resend when required by the existing TASK-014/TASK-016 pattern.

`SECURITY DEFINER` here means a narrow function with explicit internal authorization, not a generic privileged client.

### 15.4 Pre-auth verify boundary

The target first admin does not yet possess an authenticated application session. Verification therefore must enter through an application-server purpose-specific boundary that reuses the already-approved TASK-013 server-only verification facilities.

No raw privileged Supabase client may escape that module.

If a backend credential is technically necessary to invoke the existing TASK-013 server-only primitives, it remains confined behind exact methods and may not become an ordinary request client, tenant bypass or reusable repository.

### 15.5 `supabase_auth_admin`

TASK-017 does not grant new tenant privileges to `supabase_auth_admin`.

The existing Custom Access Token Hook grant model remains unchanged except for any exact platform-owned correlation that the approved physical implementation can demonstrate is strictly required. Any need to broaden `supabase_auth_admin` into intent or tenant general access is a blocker requiring security review.

### 15.6 Function EXECUTE surface

Privileged transitions must demonstrate:

```text
PUBLIC EXECUTE = NO
anon EXECUTE = NO unless an exact pre-auth wrapper contract explicitly requires a non-DB public surface
authenticated EXECUTE = only exact caller-scoped initial/resend signatures where required
raw privileged verify transition = server-only
```

The browser must never receive a database credential that can invoke server-only transitions directly.

---

## 16. FirstAdminOnboardingIntent lifecycle

### 16.1 Establishment

A new eligible company can transition from:

```text
no first-admin intent
```

to:

```text
intent established
+
first challenge current
```

only through one authorized atomic operation.

### 16.2 Pending proof

While no handoff exists, the intent may have:

- one active current challenge;
- a current challenge that expired;
- a current challenge exhausted by attempts;
- a predecessor invalidated by a successful resend.

Expired or exhausted current challenges can be replaced through an authorized resend/new emission. They are never reactivated.

### 16.3 Proof verified / handoff ready

A successful verification creates the durable distinction:

```text
business proof verified / authoritative handoff ready
```

represented by the intent's handoff facts and the existing consumed challenge / `SessionGrant`.

This remains different from:

```text
first-admin onboarding completed
enabled CompanyMembership
enabled tenant authority
```

### 16.4 TASK-017 terminal boundary

For TASK-017 itself, handoff-ready is terminal with respect to this task's happy path.

TASK-017 does not define post-handoff resend/reissue recovery. If a future RF-012 continuation needs a new business-code emission after a downstream failure, it must consume ADR-0020 and define that recovery without reactivating the consumed challenge or changing tenant/email/purpose.

### 16.5 Eventual completion

The exact physical completion evidence and the transition that sets it are deferred. Before any future task can enable first-admin tenant authority, the canon requires eventual single-use completion evidence preventing a second completed first-admin outcome.

---

## 17. Initial issue semantics

### 17.1 Application input

The initial application use case accepts only the minimum business locators/correlations needed:

- target `maintenance_company_id`;
- target email;
- purpose-specific `establishment_operation_id`;
- TASK-013 `issue_operation_id`;
- transient challenge material required by the existing verification foundation.

Actor ID, `is_super_admin`, role, membership ID and tenant authority are never accepted as authority inputs.

Challenge identifiers and idempotency IDs may be opaque technical correlation values but are never authority.

### 17.2 Preconditions

Inside the authoritative mutation boundary, before positive reconciliation or mutation:

1. require current validated `auth.uid()`;
2. resolve the actor `PlatformUser`;
3. re-evaluate `is_super_admin`;
4. detect any actor `CompanyMembership`, enabled or disabled;
5. reject unresolved, non-global or inconsistent actor state;
6. validate the target company exists;
7. confirm no competing first-admin intent exists for that company;
8. confirm no authoritative first-admin completion is known for that company;
9. reject any known identity/membership state incompatible with initial bootstrap;
10. validate operation correlation shape;
11. apply idempotency only after authorization.

### 17.3 Atomic transaction

A successful initial issue must atomically commit:

```text
FirstAdminOnboardingIntent
+
first VerificationChallenge
+
intent.current_challenge_id = first challenge
```

There is no successful state:

```text
intent committed
+
no current challenge
```

and no successful state:

```text
challenge issued for first-admin flow
+
no authoritative intent binding
```

### 17.4 TASK-013 reuse

The challenge must retain TASK-013 semantics:

- server-authoritative `issued_at`;
- `expires_at = issued_at + exactly 8 hours`;
- `attempt_count = 0`;
- no terminal timestamp at issue;
- HMAC-SHA-256 verifier;
- no plaintext code persistence;
- unique `issue_operation_id`;
- platform ownership;
- no tenant/role fields.

TASK-017 must compose the existing foundation rather than create a parallel challenge table or verifier algorithm.

### 17.5 Idempotent repeat

Same `establishment_operation_id` for the same authorized logical request:

```text
→ same intent
→ same first challenge
→ no duplicate
```

Before returning a positive reconciliation, current `SUPER_ADMIN` authority is revalidated.

If the same establishment operation ID is reused with a materially different company or target email:

```text
→ IDEMPOTENCY CONFLICT
→ no mutation
→ no silent rebinding
```

### 17.6 Distinct request collision

A different establishment operation targeting a company that already has an intent cannot create a competing intent.

The external outcome is bounded and does not reveal unrelated PII. No cancel/restart behavior is invented.

### 17.7 Authoritative issuance versus delivery

The business-code emission exists when the PostgreSQL transaction commits the challenge and current binding.

Email delivery occurs after that commit and cannot determine whether the challenge exists.

---

## 18. Resend / replacement semantics

### 18.1 Actor

Only a current authoritative `SUPER_ADMIN` can resend a first-admin challenge.

The function must reauthorize on every call.

### 18.2 Inputs

Resend accepts conceptually:

- `intent_id`;
- a new TASK-013 `issue_operation_id`;
- transient successor challenge material.

It does not accept a new company binding, new target email, new purpose or new intended role.

### 18.3 Current-state derivation

The mutation derives:

```text
MaintenanceCompany
target email
current challenge
purpose
```

from the authoritative intent.

### 18.4 Permitted predecessors

A current challenge that is active, expired or attempts-exhausted may produce a successor if the resend use case remains authorized.

A consumed challenge cannot be reopened by ordinary resend.

An already invalidated predecessor cannot become current again.

### 18.5 Atomic replacement

One transaction must:

1. lock/condition the intent and current predecessor;
2. reauthorize current `SUPER_ADMIN`;
3. resolve same-operation retry;
4. verify the predecessor is still the intent's current challenge;
5. enforce TASK-013 successor rules;
6. invalidate predecessor when required;
7. insert exactly one successor;
8. initialize successor's independent attempt budget and 8-hour expiry;
9. rotate `intent.current_challenge_id` to the successor;
10. commit once.

Forbidden:

```text
invalidate old
COMMIT
create successor later
```

Forbidden:

```text
create successor
COMMIT
rotate intent pointer later
```

### 18.6 Concurrency

Two different resends racing on one predecessor produce at most one accepted successor.

The loser receives a bounded stale/conflict result and must not silently issue another code.

### 18.7 Retry

Same `issue_operation_id` reconciles the same successor after current authority is revalidated. It does not reset attempts, change tenant/email/purpose or create another successor.

### 18.8 Response shape

The browser/UI may receive only bounded outcomes such as:

```text
RESENT
ALREADY_RECONCILED
DENIED
STALE_OR_CONFLICT
NOT_CONFIRMED
```

Exact user copy is not fixed by this specification.

---

## 19. Verification / consume semantics

### 19.1 Pre-auth application boundary

The target first admin verifies through a purpose-specific server boundary before ordinary tenant authorization exists.

Conceptual inputs:

- opaque `intent_id`;
- presented target email;
- candidate code;
- server-issued/managed `verification_operation_id`.

Not accepted:

- tenant ID as authority;
- role;
- membership ID;
- `PlatformUser` ID;
- `is_super_admin`;
- arbitrary challenge selection as authority.

### 19.2 Intent/current-challenge resolution

Before a successful consume, authoritative state must prove:

```text
intent exists
AND
intent.current_challenge_id = challenge.id
AND
intent.target_email = challenge.email
AND
presented email correlates to the same target under the existing TASK-013 email contract
AND
no TASK-017 handoff already exists for an incompatible operation
AND
no eventual completion evidence exists when that future state becomes representable
```

A challenge ID supplied or discovered without this binding is insufficient.

### 19.3 Verification material

The server-only boundary reuses TASK-013:

- verifier retrieval limited to required technical material;
- key-version resolution;
- HMAC-SHA-256 candidate derivation;
- fixed-length digest;
- constant-time comparison;
- no plaintext code persistence;
- no secret returned to browser.

TASK-017 does not create another verifier implementation.

### 19.4 Atomic attempt/consume decision

The final database transition must apply the intent-binding checks in the same authoritative transaction/composition that:

- resolves `verification_operation_id` retry;
- locks/conditions the current challenge;
- validates terminal state;
- validates exact 8-hour expiry;
- validates attempt budget;
- creates exactly one attempt row for a new effective attempt;
- increments `attempt_count` exactly once;
- consumes the challenge on a correct proof;
- creates/reconciles the TASK-013 `SessionGrant`;
- records the TASK-017 handoff facts.

A sequence that reads the intent, commits/releases that decision, and later consumes an arbitrary challenge is forbidden.

### 19.5 Wrong proof

A new wrong proof consumes exactly one effective attempt.

Third wrong proof:

```text
attempt_count = 3
exhausted_at != NULL
consumed_at = NULL
```

No fourth effective attempt exists.

### 19.6 Correct proof

A correct proof may succeed on effective attempt 1, 2 or 3.

On success:

```text
challenge consumed exactly once
+
SessionGrant created/reconciled exactly once
+
intent authoritative handoff recorded exactly once
```

### 19.7 Terminal states

Expired, invalidated, exhausted or consumed challenges cannot be used as a fresh successful proof.

Consumed replay with a different verification operation does not create another grant or handoff.

Retry of the same successful verification operation reconciles the prior result.

### 19.8 Safe external failure

Pre-auth errors must be bounded so they do not enumerate:

- whether an email exists in Auth;
- whether another company has an intent for the email;
- whether a challenge belongs to another intent;
- another company's identity;
- internal lifecycle details useful for targeting.

The UI may distinguish broad categories needed for user recovery, but must not expose cross-intent or cross-tenant state.

---

## 20. Authoritative handoff semantics

### 20.1 Meaning

`authoritative onboarding handoff durably available` means PostgreSQL contains authoritative evidence sufficient for a future RF-012 continuation to derive the correct onboarding context without trusting browser-provided tenant, role or email authority.

The future continuation must be able to prove:

- stable intent identity;
- company derived exclusively from the intent;
- target email derived exclusively from the intent;
- fixed first-admin purpose;
- fixed intended role `COMPANY_ADMIN`;
- which challenge was current for the successful proof;
- that challenge was consumed validly;
- corresponding `SessionGrant`;
- handoff-ready fact;
- no TASK-017 duplicate handoff;
- future operation correlation can be added/reused without changing tenant/email/purpose.

### 20.2 Proposed persistence

TASK-017 proposes to persist on the intent:

```text
handoff_session_grant_id
handoff_ready_at
```

The handoff's challenge is authoritatively derivable from the referenced `SessionGrant.challenge_id`, and the successful transition verifies that this challenge equals the intent's current challenge.

This avoids duplicating tenant, role or challenge proof state into a new bearer object.

### 20.3 Browser exposure

The `SessionGrant` is not returned to the browser as bearer authority.

An opaque `intent_id` may be carried through UI/navigation as a locator, but:

```text
intent_id alone != handoff authority
intent_id alone != tenant authority
```

### 20.4 Handoff is not completion

```text
handoff ready
!= Auth user created
!= PlatformUser created
!= CompanyMembership created
!= profile completed
!= enabled tenant authority
!= first-admin onboarding completed
```

### 20.5 SessionGrant expiry

`SessionGrant` retains TASK-013's short-lived semantics. Durable handoff evidence records that the business proof was consumed and which grant corresponded to that consume; it does not silently extend the grant TTL.

If a future RF-012 continuation needs recovery after grant expiry or ambiguous session establishment, that recovery must be specified separately and cannot reactivate the consumed challenge by inference.

---

## 21. Idempotency

### 21.1 Initial establishment

Stable correlation:

```text
establishment_operation_id
```

Same authorized logical establishment request:

```text
same operation
→ same intent
→ same first challenge
```

Different payload under the same operation ID is a conflict, not a rebinding.

### 21.2 Challenge issue/resend

Reuse TASK-013:

```text
issue_operation_id
```

Same operation ID:

- same emission;
- no second challenge;
- no reset of attempts;
- no tenant/email/purpose change.

### 21.3 Verification

Reuse TASK-013:

```text
verification_operation_id
```

Same operation ID:

- same effective attempt;
- no second attempt charge;
- same success/failure outcome;
- no second challenge consume;
- no second `SessionGrant`;
- no second handoff.

### 21.4 Handoff

Handoff is idempotent because it is created only as part of the same successful verification transition and is correlated to the single grant for that consumed challenge.

### 21.5 Authorization before privileged reconciliation

For initial establishment and resend, a previously successful operation ID does not itself authorize a positive response. Current `SUPER_ADMIN` authority must be revalidated before returning privileged reconciliation details.

### 21.6 Operation IDs are not secrets or authority

Knowing an operation UUID does not authorize issue, resend, verify or tenant access.

Operation IDs may be transported through untrusted layers as correlation values only.

---

## 22. Concurrency / atomicity

### 22.1 Simultaneous initial establishments

Two concurrent initial establishments for the same `MaintenanceCompany` must result in at most one intent capable of progressing.

Database uniqueness/locking must enforce this property.

### 22.2 Same establishment operation

Concurrent retries with the same establishment operation produce one intent and one first challenge.

### 22.3 Concurrent resends

Two distinct resends on the same current challenge produce at most one successor.

Exactly one successor can become the intent's current challenge.

### 22.4 Resend versus verify

There is one serializable decision over:

```text
intent
+
current challenge
```

If resend wins:

```text
old challenge becomes invalid/non-current
→ verification of old challenge cannot succeed
```

If verify/consume wins:

```text
current challenge consumed
→ ordinary resend of that consumed challenge cannot succeed
```

Both incompatible effects cannot commit.

### 22.5 Two verifies

Two verification operations on the same challenge cannot exceed the attempt budget and cannot both consume the challenge.

TASK-013 attempt and consume invariants remain authoritative.

### 22.6 Stale current pointer

A mutation based on a challenge that is no longer `intent.current_challenge_id` fails closed/stale. It never rotates the pointer backward.

### 22.7 Authority revoked during issue/resend

Final authority is evaluated within the mutation boundary, not by a prior application pre-check.

If current global authority is absent at confirmation, no privileged mutation commits.

### 22.8 Uncertain client result

Timeout/response loss after possible commit is ambiguous.

Caller must retry/reconcile the same operation identity; it must not automatically create a new establishment, resend or verify operation solely because the response was lost.

### 22.9 Atomicity matrix

The following must be atomic in PostgreSQL:

| Operation | Facts that must commit together |
|---|---|
| Initial establishment | intent + first challenge + current pointer |
| Resend | predecessor transition + successor challenge + current pointer rotation |
| Verify success | intent/current binding validation + attempt/consume + SessionGrant + handoff facts |

External email delivery is explicitly outside these transactions.

---

## 23. Failure model

| Failure class | Authoritative behavior | External behavior |
|---|---|---|
| Missing/invalid SUPER_ADMIN session | no initial/resend mutation | bounded `DENIED` |
| Actor not current SUPER_ADMIN | no initial/resend mutation | bounded `DENIED` |
| Actor global+membership inconsistent | fail closed | bounded `DENIED` / internal security signal |
| Company missing | no intent | bounded not-eligible/denied response without unrelated leakage |
| Competing intent | no duplicate | bounded conflict; no target PII disclosure |
| Known incompatible identity/membership | no intent | bounded not-eligible/denied; no silent repair |
| Invalid operation ID | no mutation | validation failure |
| Same operation + different payload | no mutation | idempotency conflict |
| DB failure before commit | rollback all DB effects | `NOT_CONFIRMED` |
| Response lost after commit | state may exist | retry same operation |
| Email delivery fails after issue commit | challenge remains issued/current | delivery failure/not-confirmed is separate |
| Current challenge expired | no verification | generic invalid/unavailable proof; authorized resend may create successor |
| Attempts exhausted | no further verify | generic invalid/unavailable proof; authorized resend may create successor |
| Challenge invalidated | no verification | generic invalid/unavailable proof |
| Challenge already consumed | no fresh verification | same-op retry may reconcile; otherwise replay denied |
| Wrong code | one effective attempt consumed | generic verification failure |
| Verify DB/internal failure before commit | no partial consume/handoff | `NOT_CONFIRMED` |
| Verify response lost after commit | consume/handoff may already exist | retry same verification operation |
| Resend race loser | no second successor | stale/conflict |
| Verify-vs-resend loser | incompatible effect does not commit | generic stale/verification outcome |
| Missing crypto key version | fail closed | configuration/internal failure, no secret echo |
| Corrupt verifier length | fail closed | internal failure |
| Email correlation ambiguity | fail closed | bounded failure / implementation blocker |
| Required TASK-013 composition unavailable | no silent parallel engine | implementation blocker |
| Generic privileged client becomes necessary | no workaround | implementation blocker |

---

## 24. Threat model

| Threat | Control / invariant | Authoritative source | Failure behavior | Required test |
|---|---|---|---|---|
| Cross-tenant binding | company only bound at intent establishment; future tenant derives from intent | ADR-0002 / ADR-0020 | deny/fail closed | intent A proof cannot target company B |
| Confused deputy | challenge/email never choose tenant | ADR-0020 | deny | arbitrary tenant parameter ignored/rejected |
| Caller-supplied tenant escalation | no tenant authority input after establishment | ADR-0020 | deny | verify with foreign tenant cannot influence result |
| Stale SUPER_ADMIN claim | current DB authority checked on each issue/resend | TASK-014 / ADR-0020 | deny | stale claim + DB false denied |
| Forged target-email association | intent email == challenge email; presented email correlation required | TASK-013 / ADR-0020 | deny | mismatched email denied |
| Cross-intent replay | challenge must equal intent current challenge | ADR-0020 | deny | challenge from intent X cannot verify Y |
| Consumed challenge replay | terminal consume | TASK-013 | deny/reconcile same op only | replay test |
| Expired challenge replay | server expiry | TASK-013 | deny | >8h rejected |
| Predecessor reuse after resend | atomic invalidation + pointer rotation | TASK-013 / ADR-0020 | deny | old code after resend denied |
| Resend race | one successor + atomic pointer | TASK-013 / ADR-0020 | one winner | concurrent resend test |
| Verify race | row/conditional atomic transition | TASK-013 | one consume; attempt cap | concurrent verify test |
| Verify-vs-resend race | single serialized decision | ADR-0020 | one winner | race test |
| Double consume/handoff | unique challenge grant + handoff transition | TASK-013 / TASK-017 | reconcile/deny | double consume test |
| Stale current pointer | current challenge checked in same transaction | ADR-0020 | stale/deny | stale pointer test |
| Email enumeration | no direct read + bounded responses | ADR-0020 | generic response | negative enumeration tests |
| Challenge enumeration | IDs not authority; no Data API | TASK-013 / ADR-0020 | deny | random challenge/intent IDs reveal no data |
| Error-message leakage | bounded outcomes, no raw DB/provider errors | ADR-0020 | sanitized error | integration test |
| Privilege escalation to COMPANY_ADMIN | intended role fixed but no membership/authority created | ADR-0020 | impossible in TASK-017 | verify success leaves membership absent |
| Premature tenant authority | proof/session != authorization; profile-first invariant | ADR-0003 / ADR-0020 | no tenant auth | authorization regression |
| Generic service-role abuse | raw generic privileged client forbidden | ADR-0002 / ADR-0020 | blocker | static/code-boundary test |
| Stale JWT/session claims | DB current state wins | ADR-0003 / TASK-014 | deny issue/resend | revocation regression |
| Partial transaction | atomic DB boundaries | ADR-0020 | rollback | forced-failure tests |
| Plaintext code leakage | no DB/log persistence | TASK-013 | fail review/test | schema/log/static tests |
| Secret leakage | server-only key config | TASK-013 | fail closed | client-bundle/config tests |
| Intent ID treated as bearer | intent ID locator only | ADR-0020 | deny without proof/current state | opaque-ID replay test |

---

## 25. Server / client trust boundary

### 25.1 Trusted authoritative sources

Trusted for their specific purpose:

- current PostgreSQL state;
- existing TASK-014 global-authority resolver/boundary;
- existing TASK-013 challenge lifecycle and crypto primitives;
- TASK-017 purpose-specific transactional functions;
- private server configuration containing approved cryptographic key material;
- narrowly encapsulated server-only provider/DB technical adapters.

### 25.2 Untrusted inputs/state

Never final authority:

- browser/PWA state;
- URL/query/body tenant ID;
- role sent by caller;
- email as authorization;
- intent ID as authorization;
- challenge ID as authorization;
- idempotency key as authorization;
- stale JWT/custom claim role;
- React state/cache;
- browser clock;
- client-reported expiry/attempt count;
- client-reported current challenge.

### 25.3 Operations initiated from UI but decided server-side

The UI may initiate:

- initial first-admin intent establishment;
- resend;
- verification.

All security decisions are repeated server-side/DB-side.

### 25.4 No client secrets

The browser must never receive:

- challenge HMAC key;
- verifier;
- technical password;
- Supabase secret/service key;
- raw Admin client;
- `SessionGrant` as a bearer token;
- access/refresh tokens outside normal Supabase session handling.

---

## 26. UI / API behavior

This specification defines behavioral contracts only. It does not define visual layout or a full onboarding UX.

### 26.1 SUPER_ADMIN flow

Minimum future UI behavior:

1. the company already exists from TASK-016;
2. `SUPER_ADMIN` selects/opens that company context as a locator;
3. enters the target first-admin email;
4. submits an initial issue action carrying a stable operation correlation;
5. UI shows a bounded result such as issue accepted / already reconciled / denied / not confirmed;
6. if proof is still pending, UI can initiate resend with a new resend operation identity;
7. after timeout/ambiguous response, UI retries/reconciles the same operation rather than silently generating a new logical request.

The UI must not imply that the first admin already exists or has tenant access.

### 26.2 Target first-admin verification flow

Minimum behavior:

1. receive the provider-neutral first-admin verification email containing the current verification code and a pre-auth verification link whose pathname is exactly `/first-admin/verification/{intentId}`;
2. obtain/retain `intentId` from that pathname as an opaque stable locator supplied by route/navigation; `intentId` is not bearer authority, proof, tenant authority or handoff authority;
3. show only the target email and verification code as editable proof inputs; no editable/manual `intentId`, UUID or `Referencia de acceso` field exists;
4. submit verification using the route-supplied `intentId`, target email, verification code and one logical verification operation identity;
5. the server-side verification boundary resolves the authoritative intent and its current challenge from PostgreSQL and applies the existing email/code/current-lifecycle checks;
6. receive only a bounded success/failure result;
7. on success, the same trusted server orchestration may continue from authoritative `handoffReady` into TASK-018; TASK-017 itself does not show profile completion or tenant administration.

### 26.3 API/application contracts

Conceptual application use cases:

```text
establishFirstAdminOnboardingIntent
resendFirstAdminOnboardingChallenge
verifyFirstAdminOnboardingChallenge
resolveFirstAdminOnboardingHandoff   // server-side future-consumer/internal use only
```

Names may adapt to repository conventions during an approved implementation without changing responsibilities.

No generic CRUD API is created for the intent table.

### 26.4 Operation correlation in UI

Idempotency correlation may be carried by the browser but should be issued/managed by the server-side application boundary under the existing TASK-013 discipline. It is never authorization.

Exact transport mechanics are implementation details to align with existing Next.js patterns after repository inspection.

---

## 27. Offline behavior

```text
TASK-017 offline support =
NOT SUPPORTED
```

Reason:

- establishment requires current global DB authority;
- resend requires current global DB authority;
- challenge expiry and attempt budget are authoritative server state;
- verify/consume is a server-authoritative atomic transition;
- handoff creation depends on current platform-owned database state;
- an offline lease cannot authorize a global `SUPER_ADMIN` mutation or pre-auth proof consume.

TASK-017 creates no:

- Dexie entity;
- IndexedDB replica;
- outbox item;
- background sync onboarding mutation;
- cached challenge authority;
- cached handoff authority;
- offline verification;
- optimistic local issue/resend.

If connectivity is lost after a request was sent, recovery is online retry/reconciliation with the same operation identity.

---

## 28. Audit implications

### 28.1 Issue

New functional `AuditEvent` for issue:

```text
NO
```

No new action name is invented.

### 28.2 Resend

New functional `AuditEvent` for resend:

```text
NO
```

### 28.3 Verify

New functional `AuditEvent` for verification:

```text
NO
```

### 28.4 Handoff

Creating the TASK-017 handoff does not produce `USER_CREATED`, because no application user/membership is created by this task.

### 28.5 Historical initiator provenance

The intent records the initiating `PlatformUser` reference required by ADR-0020.

That provenance:

```text
historical actor
!= current authority
```

It can support the future user-creation audit transition without reinterpreting who initiated the onboarding.

### 28.6 Future `USER_CREATED`

`USER_CREATED` remains the existing audit action for the future authoritative user/membership creation transition.

Its exact producer timing is out of TASK-017 scope and must not be inferred from proof consume, handoff creation, Auth user creation or session establishment.

---

## 29. Email-delivery boundary

### 29.1 Separation

TASK-017 explicitly separates:

```text
authoritative business-code issuance
```

from:

```text
external email delivery
```

Authoritative issuance occurs at DB commit.

### 29.2 Provider-neutral application port

TASK-017 may define a narrow application port conceptually equivalent to:

```text
FirstAdminVerificationCodeDelivery
```

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

The port must not:

- decide whether an emission exists;
- mutate challenge lifecycle;
- select tenant;
- authorize resend;
- persist plaintext code for later use;
- become an event bus or queue framework.
- treat the verification link or `intentId` as proof, bearer, tenant authority or handoff authority;
- construct the absolute verification URL from an arbitrary origin supplied by the target browser;
- add email, code, tenant/company ID, role, challenge ID, grant ID, Auth user ID, access/refresh tokens or technical password to the verification URL.

### 29.3 Concrete provider

Concrete provider selection:

```text
OUT OF SCOPE / UNRESOLVED
```

No Resend, SMTP, Supabase email provider or other provider is selected by this specification.

### 29.4 Delivery failure

If delivery fails after issuance committed:

```text
challenge = still issued/current
delivery = failed or not confirmed
```

No logical rollback of challenge issuance occurs.

### 29.5 Technical retry while code remains transiently available

A technical retry of the same code during the same server-side execution does not create a new business emission and does not consume a new attempt budget.

TASK-017 does not define provider-specific retry count, delay or backoff.

### 29.6 Code unavailable after failure/timeout

TASK-017 must not persist plaintext code merely to support a later delivery retry.

When code material is no longer available and a later authorized interaction needs another code:

```text
authorized resend
→ new challenge
→ predecessor invalidated as applicable
```

The resend keeps the same stable `FirstAdminOnboardingIntent.id` locator and produces the new current challenge/code according to the already-approved lifecycle. The provider-neutral delivery material is regenerated as the same verification link pathname `/first-admin/verification/{intentId}` for that stable locator plus the new current verification code. The code is never encoded in the verification URL. Resend does not create a new onboarding-intent locator.

### 29.7 RF-004 status

Until a concrete external delivery adapter and its operational contract are separately decided and implemented:

```text
RF-004 =
PARTIAL / NOT END-TO-END
```

This does not block implementing the authoritative intent/challenge/handoff foundation.

The provider-neutral content/navigation contract is nevertheless closed for TASK-017: every usable first-admin code delivery carries the current verification code plus the verification link for the same stable intent locator. Concrete provider selection remains out of scope.

---

## 30. Compatibility / regression requirements

TASK-017 must preserve:

### 30.1 TASK-009

- one Auth subject maps authoritatively to one `PlatformUser`;
- `PlatformUser → 0..1 CompanyMembership` MVP invariant;
- no email as application identity authority;
- tenant ownership remains intact.

### 30.2 TASK-010

- `AuditEvent` catalog remains unchanged by TASK-017;
- no direct browser writes to audit state;
- `USER_CREATED` is not produced by TASK-017.

### 30.3 TASK-011

- caller-scoped SSR Supabase clients remain caller-scoped;
- Auth SSR lifecycle is not converted into authorization.

### 30.4 TASK-012 / ADR-0003

- current DB authorization prevails;
- session/claims never grant tenant authority by themselves;
- no global tenant bypass.

### 30.5 TASK-013 / ADR-0019

- challenge fields and lifecycle remain unchanged;
- exact 8h expiry remains;
- exactly 3 effective attempts remains;
- verifier crypto remains HMAC-SHA-256 with server-only keys;
- resend predecessor semantics remain;
- verification operation idempotency remains;
- consume is single-use;
- `SessionGrant` remains 5-minute, single-use, platform-owned and non-bearer;
- Custom Access Token Hook remains default-deny for unsupported initial auth methods;
- no generic Auth Admin client;
- no plaintext code persistence.

### 30.6 TASK-014

- global authority remains DB-authoritative;
- `is_super_admin=true + any CompanyMembership` remains inconsistent/fail-closed;
- no membership is created for the global initiator.

### 30.7 TASK-015

- no mutation of ordinary CompanyMembership lifecycle is added;
- no bypass of self-target/continuity rules;
- no new user lifecycle action is introduced.

### 30.8 TASK-016

- existing company creation remains independent and idempotent;
- TASK-017 only starts after an existing company;
- TASK-017 does not change `creation_operation_id`;
- no commercial anchor is inferred from company creation or onboarding.

### 30.9 ADR-0020

- intent remains platform-owned;
- tenant/email/purpose binding is authoritative;
- proof/handoff remains distinct from completion;
- profile completion remains before enabled first-admin authority.

---

## 31. Acceptance Criteria

Every criterion must be individually verifiable as `PASS` or `FAIL`.

**AC-017-001.** El ID de la tarea es exactamente `TASK-017`.

**AC-017-002.** El título es exactamente `Authoritative First-Admin Onboarding Intent and Verification Handoff Foundation`.

**AC-017-003.** La specification queda `DRAFT — PENDING CENTRAL REVIEW` y no `APPROVED`.

**AC-017-004.** La implementación permanece `NOT AUTHORIZED / NOT STARTED`.

**AC-017-005.** Codex permanece `NOT AUTHORIZED`.

**AC-017-006.** No se modifica el repositorio durante la generación de esta specification.

**AC-017-007.** No se modifica Supabase/Hosted/Staging/Production durante la generación.

**AC-017-008.** No se realiza staging, commit ni push.

**AC-017-009.** El blocker record previo no se usa como fuente conceptual de requisitos.

**AC-017-010.** Las cuatro fuentes recuperadas pasan identidad física exacta según §3.

**AC-017-011.** ADR-0020 se consume como decisión aceptada/canonicalizada/incorporada conforme al estado posterior de CORR-027.

**AC-017-012.** TASK-016 se consume como `DONE / CLOSED` y no como onboarding completo.

**AC-017-013.** Fase 2 permanece iniciada/no completada y Fase 3 no iniciada.

**AC-017-014.** El boundary inicial es una `MaintenanceCompany` existente creada por autoridad global actual.

**AC-017-015.** El boundary final es current challenge consumido + handoff autoritativo durable.

**AC-017-016.** RF-012 completo permanece fuera de scope.

**AC-017-017.** Profile completion permanece fuera de scope.

**AC-017-018.** Auth user creation permanece fuera de scope.

**AC-017-019.** `PlatformUser` creation permanece fuera de scope.

**AC-017-020.** Initial `CompanyMembership` creation permanece fuera de scope.

**AC-017-021.** Enabled tenant authority permanece fuera de scope.

**AC-017-022.** Exact `USER_CREATED` producer timing permanece fuera de scope.

**AC-017-023.** Subscription, promotional entitlement y commercial anchor permanecen fuera de scope.

**AC-017-024.** PAY-OPEN-001 y PAY-OPEN-008 no se resuelven.

**AC-017-025.** Target-email change no se inventa.

**AC-017-026.** Cancel/restart no se inventa.

**AC-017-027.** PII retention period no se inventa.

**AC-017-028.** Generic privileged/service-role request client permanece prohibido.

**AC-017-029.** Offline onboarding permanece fuera de scope.

**AC-017-030.** No se inventa disabled membership pre-profile.

**AC-017-031.** `FirstAdminOnboardingIntent` se modela como platform-owned.

**AC-017-032.** Cada intent posee identidad estable propia distinta de tenant/challenge/grant/email/Auth subject.

**AC-017-033.** Cada intent vincula exactamente una `MaintenanceCompany`.

**AC-017-034.** Cada empresa puede poseer como máximo un first-admin intent capaz de progresar bajo TASK-017.

**AC-017-035.** El target email queda vinculado al intent y no es autoridad.

**AC-017-036.** No se introduce uniqueness global del target email.

**AC-017-037.** No se introduce una nueva política global de normalización de email.

**AC-017-038.** Purpose es fijo `first-admin onboarding` y no caller-supplied.

**AC-017-039.** Intended role es fijo `COMPANY_ADMIN` y no caller-supplied.

**AC-017-040.** Intended role no crea `CompanyMembership` ni tenant authority.

**AC-017-041.** Se conserva historical initiator provenance sin convertirla en current authority.

**AC-017-042.** La representación física propuesta no añade tenant/role a `verification_challenges`.

**AC-017-043.** La representación física propuesta no define onboarding-completion shape final.

**AC-017-044.** No se realiza backfill ficticio de intents a compañías existentes.

**AC-017-045.** RF-003 queda cubierto por establecimiento autorizado del target email.

**AC-017-046.** RF-004 se declara PARTIAL y no end-to-end.

**AC-017-047.** Initial issue sólo puede iniciarse por current authoritative `SUPER_ADMIN`.

**AC-017-048.** Initial issue deriva actor desde `auth.uid()` y DB vigente.

**AC-017-049.** Actor `is_super_admin=false` es denegado.

**AC-017-050.** Actor `is_super_admin=true` con cualquier membership enabled/disabled es denegado.

**AC-017-051.** Claim/metadata/frontend state no concede autoridad global.

**AC-017-052.** Target `maintenance_company_id` inicial es locator, no authority.

**AC-017-053.** Initial issue valida existencia de la empresa.

**AC-017-054.** Initial issue impide intent competidor para la misma empresa.

**AC-017-055.** Initial issue falla cerrado ante known incompatible identity/membership state.

**AC-017-056.** Initial issue no usa generic Auth enumeration para reparar incompatibilidades.

**AC-017-057.** Intent + first challenge + current pointer comparten una transaction DB.

**AC-017-058.** No puede confirmarse intent sin current challenge.

**AC-017-059.** No puede confirmarse first-admin challenge sin intent binding.

**AC-017-060.** Initial establishment posee `establishment_operation_id` único.

**AC-017-061.** Retry del mismo establishment operation reconcilia intent y first challenge.

**AC-017-062.** Same establishment operation + payload materialmente diferente falla como conflict.

**AC-017-063.** Antes de positive idempotent reconciliation se revalida current SUPER_ADMIN.

**AC-017-064.** Cada challenge emitido conserva exactamente 8 horas desde `issued_at` server-side.

**AC-017-065.** Cada nueva emisión comienza con `attempt_count=0`.

**AC-017-066.** Cada emisión admite como máximo 3 intentos efectivos.

**AC-017-067.** Cada emisión successor posee attempt budget independiente.

**AC-017-068.** Intento 4 efectivo es imposible.

**AC-017-069.** Expired challenge no se recupera ni reactiva.

**AC-017-070.** Exhausted challenge no se reactiva.

**AC-017-071.** Resend requiere current authoritative `SUPER_ADMIN` en cada call.

**AC-017-072.** Resend acepta intent/correlation y deriva tenant/email desde intent.

**AC-017-073.** Resend no acepta nuevo target email, tenant binding, purpose o role.

**AC-017-074.** Resend reutiliza TASK-013 `issue_operation_id`.

**AC-017-075.** Retry del mismo resend operation no crea un segundo successor.

**AC-017-076.** Resend sobre active/expired/exhausted current puede crear successor cuando autorizado.

**AC-017-077.** Ordinary resend de consumed current es denegado.

**AC-017-078.** Successful resend invalida predecessor según TASK-013.

**AC-017-079.** Successful resend crea nueva challenge identity.

**AC-017-080.** Successor recibe nueva ventana exacta de 8h.

**AC-017-081.** Successor recibe nuevo presupuesto de 3 intentos.

**AC-017-082.** Predecessor transition + successor + pointer rotation son atómicos.

**AC-017-083.** Dos resends concurrentes sobre un predecessor producen como máximo un successor.

**AC-017-084.** Loser de resend concurrente no emite automáticamente otro challenge.

**AC-017-085.** Un challenge viejo nunca vuelve a ser current.

**AC-017-086.** Verify ocurre por boundary pre-auth purpose-specific.

**AC-017-087.** Verify no acepta `maintenance_company_id` como authority.

**AC-017-088.** Verify no acepta role/membership/user ID como authority.

**AC-017-089.** Verify resuelve intent y current challenge antes de consume.

**AC-017-090.** Verify exige `intent.current_challenge_id = challenge.id`.

**AC-017-091.** Verify exige igualdad/correlación autoritativa intent target email ↔ challenge email.

**AC-017-092.** Presented email se trata como proof locator, no authority.

**AC-017-093.** Verify reutiliza el verifier HMAC y key-version de TASK-013.

**AC-017-094.** Candidate/stored verifier se compara con primitive constant-time aprobada.

**AC-017-095.** No se persiste plaintext code ni candidate code.

**AC-017-096.** Verification operation idempotency reutiliza `verification_operation_id`.

**AC-017-097.** Same verification operation no consume un segundo intento.

**AC-017-098.** Wrong proof consume exactamente un intento efectivo.

**AC-017-099.** Tercer wrong proof marca exhausted y no consumed.

**AC-017-100.** Correct proof puede consumir en attempt 1, 2 o 3.

**AC-017-101.** Consumed/invalidated/exhausted/expired challenge no produce fresh success.

**AC-017-102.** Different-operation replay de consumed challenge no crea otro grant/handoff.

**AC-017-103.** Same successful verification operation reconcilia el mismo result.

**AC-017-104.** Binding check + attempt/consume + SessionGrant + handoff facts forman una sola decisión atómica.

**AC-017-105.** Challenge consume no puede commit sin el grant/handoff requerido por la composición aprobada.

**AC-017-106.** SessionGrant conserva purpose `initial_session`, auth method `password` y TTL de TASK-013.

**AC-017-107.** SessionGrant no se entrega al browser como bearer authority.

**AC-017-108.** Handoff deriva company exclusivamente del intent.

**AC-017-109.** Handoff deriva target email exclusivamente del intent.

**AC-017-110.** Handoff conserva fixed purpose e intended role sin habilitarlos.

**AC-017-111.** Handoff conserva correlación al challenge consumido y SessionGrant correspondiente.

**AC-017-112.** Handoff ready no equivale a Auth user created.

**AC-017-113.** Handoff ready no equivale a PlatformUser created.

**AC-017-114.** Handoff ready no equivale a CompanyMembership created.

**AC-017-115.** Handoff ready no equivale a profile completed.

**AC-017-116.** Handoff ready no equivale a enabled tenant authority.

**AC-017-117.** Handoff ready no equivale a onboarding completed.

**AC-017-118.** `intent_id` por sí solo no es bearer authority.

**AC-017-119.** SessionGrant expiry no se extiende silenciosamente por persistir handoff.

**AC-017-120.** Post-handoff recovery/reissue queda deferred a future RF-012 work.

**AC-017-121.** Email delivery ocurre fuera de la transaction de authoritative issuance.

**AC-017-122.** DB commit define business-code emission, no el provider.

**AC-017-123.** Delivery failure no hace rollback lógico de challenge issuance.

**AC-017-124.** Technical retry del mismo delivery no es nueva business emission.

**AC-017-125.** No se persiste plaintext code para future delivery retry.

**AC-017-126.** Cuando code material ya no está disponible, una nueva entrega futura requiere authorized resend/new emission; el resend conserva el mismo stable intent locator y produce el nuevo current challenge/code conforme al lifecycle aprobado.

**AC-017-127.** No se selecciona production email provider; el provider-neutral delivery material incluye verification code + verification link con pathname exacto `/first-admin/verification/{intentId}` construido server-side desde trusted application origin y el stable intent locator.

**AC-017-128.** No se selecciona provider retry/backoff policy.

**AC-017-129.** No se crea durable delivery queue/outbox.

**AC-017-130.** RF-004 no se reporta completo hasta existir delivery adapter aprobado.

**AC-017-131.** New intent table tiene RLS enabled defense-in-depth.

**AC-017-132.** `anon` no posee direct CRUD sobre intent.

**AC-017-133.** `authenticated` no posee direct CRUD sobre intent.

**AC-017-134.** `PUBLIC` no posee direct CRUD sobre intent.

**AC-017-135.** Browser no posee direct DB mutation sobre intent/challenge/handoff.

**AC-017-136.** No se crean tenant policies artificiales sobre platform-owned intent.

**AC-017-137.** Tenant-owned RLS existente permanece sin debilitamiento.

**AC-017-138.** Initial issue/resend usan boundary purpose-specific con internal authority check.

**AC-017-139.** `SECURITY DEFINER`, si se utiliza para issue/resend, permanece estrecho, con safe/fixed `search_path` y no es bypass genérico.

**AC-017-140.** Pre-auth verify reusa server-only TASK-013 boundary y no exporta raw privileged client.

**AC-017-141.** `supabase_auth_admin` no recibe nuevos tenant privileges.

**AC-017-142.** No se introducen table write grants generales a `authenticated`.

**AC-017-143.** SUPER_ADMIN creador no recibe membership ni ordinary tenant data access.

**AC-017-144.** Current PostgreSQL state prevalece sobre stale JWT/session/frontend claims.

**AC-017-145.** Caller-supplied tenant/role/email no se convierten en authorization authority.

**AC-017-146.** Simultaneous initial establishments producen como máximo un intent para la empresa.

**AC-017-147.** Concurrent same establishment operation produce un solo intent/challenge.

**AC-017-148.** Concurrent verifies nunca exceden attempt budget.

**AC-017-149.** Concurrent verifies consumen como máximo una vez.

**AC-017-150.** Verify-vs-resend produce un único winner serializable.

**AC-017-151.** Stale current challenge/pointer falla cerrado y no rota hacia atrás.

**AC-017-152.** Authority revoked before issue/resend confirmation produce cero mutación.

**AC-017-153.** Timeout/response loss se reconcilia con same operation ID antes de crear nueva logical operation.

**AC-017-154.** Errores pre-auth no enumeran emails/intents/challenges de otros contextos.

**AC-017-155.** No se exponen raw DB/provider errors con PII/secrets.

**AC-017-156.** No se crea nuevo AuditEvent para issue.

**AC-017-157.** No se crea nuevo AuditEvent para resend.

**AC-017-158.** No se crea nuevo AuditEvent para verify.

**AC-017-159.** `USER_CREATED` no es producido por TASK-017.

**AC-017-160.** Intent conserva initiator provenance necesaria para future audit.

**AC-017-161.** TASK-017 offline support = NOT SUPPORTED.

**AC-017-162.** No se crean Dexie/IndexedDB/outbox/Service Worker artifacts para onboarding.

**AC-017-163.** TASK-009 identity/membership cardinality permanece compatible.

**AC-017-164.** TASK-010 AuditEvent catalog permanece compatible.

**AC-017-165.** TASK-011 caller-scoped SSR boundaries permanecen compatibles.

**AC-017-166.** TASK-012/ADR-0003 authorization semantics permanecen compatibles.

**AC-017-167.** TASK-013 exact expiry/attempt/idempotency/crypto/grant invariants permanecen compatibles.

**AC-017-168.** TASK-014 global authority semantics permanecen compatibles.

**AC-017-169.** TASK-015 membership lifecycle semantics permanecen compatibles.

**AC-017-170.** TASK-016 company-creation semantics permanecen compatibles.

**AC-017-171.** ADR-0020 proof/handoff/completion separation permanece compatible.

**AC-017-172.** No se introduce microservice.

**AC-017-173.** No se introduce generic invitation/enrollment framework.

**AC-017-174.** No se introduce generic idempotency framework.

**AC-017-175.** TypeScript strict permanece obligatorio en el código futuro.

**AC-017-176.** No se añade dependencia crypto/ORM/auth framework por conveniencia sin revisión.

**AC-017-177.** Implementation preflight debe releer repo real, migrations, functions, tests y current dependencies.

**AC-017-178.** Si la composición atómica con TASK-013 no puede lograrse sin degradar sus invariantes, implementation = BLOCKER.

**AC-017-179.** Si la implementación requiere generic privileged client, implementation = BLOCKER.

**AC-017-180.** Si el current SUPER_ADMIN model de TASK-014 necesita modificarse, implementation = BLOCKER.

**AC-017-181.** Si se requiere una nueva decisión de producto/arquitectura material, implementation = BLOCKER.

**AC-017-182.** Todos los tests específicos TASK-017 deben pasar antes de review.

**AC-017-183.** Regresiones TASK-009/010/011/012/013/014/015/016 relevantes deben pasar.

**AC-017-184.** `git diff --check` debe pasar durante una futura implementación autorizada.

**AC-017-185.** El diff futuro debe limitarse al scope aprobado y permanecer unstaged hasta Gate separado.

**AC-017-186.** Hosted Development mutation requiere Gate humano separado.

**AC-017-187.** Staging, commit y push requieren Gates humanos separados.

---

## 32. Test Strategy

Executable tests are not produced by this specification. A future authorized implementation must provide evidence across the following categories.

### A. DB / schema tests

At minimum:

1. exactly one new platform-owned first-admin intent table exists;
2. exact column set matches the approved TASK-017 physical contract;
3. required FK constraints exist;
4. `maintenance_company_id` uniqueness prevents competing intents;
5. `establishment_operation_id` uniqueness holds;
6. `current_challenge_id` uniqueness holds;
7. nullable handoff fields obey their all-null/all-present invariant;
8. no target-email global unique constraint exists;
9. no role/purpose/tenant fields are added to `verification_challenges`;
10. no completion field/state invented beyond the approved scope;
11. RLS is enabled on intent table;
12. no unintended table grants exist;
13. no historical intent backfill occurs.

### B. Authorization tests

1. no session → initial issue DENY;
2. unknown Auth subject → DENY;
3. unresolved PlatformUser → DENY;
4. `is_super_admin=false` → DENY;
5. `is_super_admin=true` + enabled membership → DENY;
6. `is_super_admin=true` + disabled membership → DENY;
7. stale claim says SUPER_ADMIN while DB says false → DENY;
8. DB-authoritative valid SUPER_ADMIN can establish eligible intent;
9. authority revoked before retry → retry cannot reveal privileged positive reconciliation;
10. resend repeats the same current-authority checks;
11. creator does not gain tenant membership/access.

### C. RLS / privilege tests

1. `anon` direct SELECT intent → denied;
2. `anon` INSERT/UPDATE/DELETE intent → denied;
3. `authenticated` direct SELECT intent → denied unless a separately approved exact read contract exists; default expected result is denied;
4. `authenticated` direct table write → denied;
5. browser cannot directly mutate challenge/handoff state;
6. PUBLIC has no broad EXECUTE on privileged transitions;
7. exact issue/resend EXECUTE surface only;
8. pre-auth raw verify transition is not generally executable from Data API;
9. safe/fixed `search_path` for `SECURITY DEFINER` functions;
10. no new tenant grants for `supabase_auth_admin`;
11. no generic service-role/admin client export.

### D. Challenge lifecycle tests

1. first issue produces challenge with 8h expiry;
2. first issue starts attempts at 0;
3. first issue creates intent/current pointer atomically;
4. resend from active predecessor;
5. resend from expired predecessor;
6. resend from exhausted predecessor;
7. resend from consumed predecessor denied;
8. predecessor invalid after accepted successor;
9. successor has independent attempts;
10. successor has new 8h window;
11. old code after resend denied;
12. current pointer matches successor;
13. stale predecessor cannot become current again;
14. wrong attempt 1/2/3 behavior;
15. fourth attempt impossible;
16. success on attempts 1, 2 and 3;
17. expired replay denied;
18. invalidated replay denied;
19. exhausted replay denied;
20. consumed replay denied except same-operation reconciliation.

### E. Idempotency tests

1. same establishment operation + same payload → same intent and first challenge;
2. same establishment operation + different company → conflict/no mutation;
3. same establishment operation + different email → conflict/no mutation;
4. two concurrent same establishment operations → one logical result;
5. same resend `issue_operation_id` → same successor;
6. duplicate resend operation does not reset attempts;
7. same verification operation → one effective attempt;
8. same successful verification operation → same grant/handoff;
9. operation IDs never grant authority by themselves;
10. response-lost retry paths preserve operation identity.

### F. Concurrency / atomicity tests

1. two distinct initial requests for same company → at most one intent;
2. two resends on same predecessor → at most one successor;
3. verify versus resend → exactly one compatible winner;
4. concurrent wrong verifies never exceed 3 attempts;
5. concurrent correct verifies consume at most once;
6. third/fourth attempt race cannot create a fourth effective attempt;
7. forced initial-transaction failure leaves neither partial intent nor orphan first challenge for TASK-017;
8. forced resend failure cannot leave invalidated predecessor without accepted successor/current pointer update;
9. forced verify failure cannot leave consumed challenge without required grant/handoff facts;
10. stale pointer mutation cannot rotate pointer backward.

### G. Negative security tests

1. arbitrary tenant B submitted during verify cannot influence intent A;
2. arbitrary role cannot alter intended role;
3. arbitrary email cannot rebind intent;
4. random intent IDs do not enumerate PII;
5. random challenge IDs do not enumerate state;
6. cross-intent challenge replay denied;
7. challenge/email mismatch denied;
8. current-pointer mismatch denied;
9. intent ID alone cannot obtain handoff/tenant data;
10. same operation ID after authority revocation does not return privileged success;
11. errors do not echo HMAC key, verifier, code, technical password, backend key or tokens;
12. plaintext code absent from DB;
13. code absent from ordinary logs;
14. full target email redacted/minimized in ordinary logs;
15. no direct browser access to platform tables;
16. no privilege escalation from proof/session to tenant authorization.

### H. Server integration tests

1. initial use case composes current SUPER_ADMIN authorization and TASK-013 issue primitives;
2. delivery port receives transient code only after DB commit;
3. delivery failure does not roll back issuance;
4. no concrete production email provider is required for core tests;
5. resend use case derives company/email from intent;
6. verify use case resolves intent/current challenge before verifier match/consume;
7. same email correlation contract is used across intent, challenge and bridge;
8. successful verify persists handoff facts;
9. `SessionGrant` is never returned as browser bearer authority;
10. UI/application outcomes are bounded;
11. ambiguous timeout maps to reconciliation, not automatic new operation.
12. provider-neutral delivery material contains the current verification code plus a verification link whose pathname is exactly `/first-admin/verification/{intentId}`;
13. the verification link uses the same stable intent locator across resend while the current challenge/code changes according to the existing lifecycle;
14. the verification URL contains no email, code, tenant/company ID, role, challenge ID, grant ID, Auth user ID, access/refresh tokens or technical password;
15. the delivery/link contract does not require a concrete production email provider and does not persist plaintext code or the full verification URL.

### I. Regression tests

Run all relevant existing suites for:

- TASK-009 identity/tenant;
- TASK-010 AuditEvent;
- TASK-011 SSR Auth lifecycle;
- TASK-012 authoritative authorization;
- TASK-013 VerificationChallenge / E2;
- TASK-014 SUPER_ADMIN classification;
- TASK-015 CompanyMembership lifecycle;
- TASK-016 MaintenanceCompany creation.

Also run repository-standard lint, strict typecheck, tests, build and any project verification script required by the current repository.

### J. Hosted Development verification

Hosted Development verification is required only after a separate human Gate authorizes remote mutation/testing.

It must verify, at minimum:

1. migration applied exactly as approved;
2. expected table/constraints/indexes/RLS/grants/functions exist;
3. no unexpected grants or policies;
4. direct Data API negative access;
5. current SUPER_ADMIN authorization behavior;
6. initial issue/resend/verify transaction behavior;
7. concurrency/idempotency behavior;
8. TASK-013 regressions, including hook/security boundary, remain passing;
9. no Staging/Production mutation;
10. no generic privileged client introduced.

Hosted verification must not be executed by inference from specification approval.

---

## 33. Definition of Done

TASK-017 can only be considered `DONE / CLOSED` after all applicable items below are satisfied in order.

**DoD-017-001.** Existe un artefacto TASK-017 completo con estado `DRAFT — PENDING CENTRAL REVIEW`.

**DoD-017-002.** El Revisor Central completa revisión integral de la specification.

**DoD-017-003.** Cualquier corrección documental requerida por la revisión se aplica mediante el Gate correspondiente.

**DoD-017-004.** Existe aprobación humana explícita de la specification antes de implementación.

**DoD-017-005.** Se genera el artefacto aprobado sólo mediante Gate separado.

**DoD-017-006.** Se canonicaliza la specification sólo mediante Gate separado.

**DoD-017-007.** La canonicalización es revisada por identidad/contenido.

**DoD-017-008.** La specification canónica se incorpora al repositorio sólo mediante Gate separado.

**DoD-017-009.** La incorporación al repositorio es revisada antes de autorizar implementación.

**DoD-017-010.** Existe autorización humana separada y explícita para implementar TASK-017.

**DoD-017-011.** Se ejecuta preflight Git fresco inmediatamente antes de implementación.

**DoD-017-012.** Se releen íntegramente las fuentes canónicas vigentes y el repositorio real.

**DoD-017-013.** Se verifica que ADR-0020/TASK-013/TASK-014/TASK-016 physical contracts no han cambiado materialmente.

**DoD-017-014.** Se verifica que no apareció una decisión posterior que sustituya esta specification.

**DoD-017-015.** Se implementa únicamente el scope aprobado.

**DoD-017-016.** Existe la migration TASK-017 aprobada, sin backfill ficticio ni segunda capability lateral.

**DoD-017-017.** RLS/privileges/functions coinciden con el security model aprobado.

**DoD-017-018.** No existe generic privileged/service-role request client.

**DoD-017-019.** Server/application boundaries permanecen dentro del monolito modular y TypeScript strict.

**DoD-017-020.** Provider-neutral email delivery boundary incluye el current verification code + verification link `/first-admin/verification/{intentId}` para el mismo stable intent locator, sin seleccionar concrete production provider y sin presentarse como delivery end-to-end.

**DoD-017-021.** RF-004 permanece reportado exactamente `PARTIAL / NOT END-TO-END` salvo que un Gate posterior apruebe e implemente un adapter externo.

**DoD-017-022.** Todos los DB/schema tests TASK-017 pasan.

**DoD-017-023.** Todos los authorization tests pasan.

**DoD-017-024.** Todos los RLS/privilege tests pasan.

**DoD-017-025.** Todos los lifecycle/idempotency/concurrency/security tests pasan.

**DoD-017-026.** Todos los server integration tests pasan.

**DoD-017-027.** Regresiones TASK-009..016 relevantes pasan.

**DoD-017-028.** Lint pasa.

**DoD-017-029.** Typecheck strict pasa.

**DoD-017-030.** Build pasa.

**DoD-017-031.** Repository verify/checks vigentes pasan.

**DoD-017-032.** `git diff --check` pasa.

**DoD-017-033.** El diff completo es revisado por arquitectura, seguridad, RLS, multitenancy, scope y regresiones.

**DoD-017-034.** No hay archivos/cambios fuera de scope ni normalizaciones laterales no autorizadas.

**DoD-017-035.** Si la implementación requiere Supabase Hosted mutation, existe autorización humana remota separada.

**DoD-017-036.** Hosted Development verification pasa cuando corresponda.

**DoD-017-037.** Staging y Production permanecen sin cambios salvo Gate futuro explícito.

**DoD-017-038.** Los cambios permanecen unstaged hasta review y Gate de staging.

**DoD-017-039.** Staging se realiza sólo mediante Gate humano separado.

**DoD-017-040.** Commit se realiza sólo mediante Gate humano separado.

**DoD-017-041.** Push se realiza sólo mediante Gate humano separado.

**DoD-017-042.** Se verifica `origin/main` exacto después del push cuando corresponda.

**DoD-017-043.** Existe revisión humana final de implementación.

**DoD-017-044.** El cierre final mantiene explícitamente que TASK-017 DONE no equivale a RF-012 DONE ni a first-admin onboarding complete.

**DoD-017-045.** El cierre final mantiene explícitamente que proof/handoff no equivale a enabled tenant authority.

---

## 34. Future Codex implementation decomposition

This decomposition is planning only. It does not authorize Codex.

A future authorized execution should be split into small, reviewable steps while preserving one coherent TASK-017 capability.

### Work item A — Schema and platform-owned intent boundary

**Objective:** add the minimal physical `FirstAdminOnboardingIntent` representation and its security envelope.

**Context:** ADR-0020 requires a platform-owned stable intent separate from `VerificationChallenge`.

**Scope:**

- one new intent table;
- proposed fields/constraints from §11 after repository preflight confirms compatibility;
- RLS enablement;
- grants/revokes;
- minimal indexes;
- no backfill.

**Out of scope:**

- issue/resend behavior;
- verify;
- email provider;
- RF-012;
- user/membership creation.

**Expected changes:** one migration slice containing table/constraints/RLS/privilege foundation.

**Security/RLS:** no anon/authenticated CRUD; no tenant policy; no generic privileged surface.

**Acceptance:** relevant AC-017-031..044 and AC-017-131..137.

**Tests:** DB schema, constraints, RLS/grant negative tests.

### Work item B — Authoritative initial issue + resend transactional functions

**Objective:** implement current-SUPER_ADMIN-authorized intent establishment and challenge rotation.

**Context:** TASK-014 provides global authority; TASK-013 provides issue/resend lifecycle; TASK-016 demonstrates a purpose-specific caller-scoped DB mutation pattern.

**Scope:**

- current authority check;
- initial intent + first challenge atomicity;
- establishment idempotency;
- company/known bootstrap eligibility checks;
- resend reauthorization;
- predecessor/successor/current-pointer atomicity;
- safe outcomes.

**Out of scope:**

- verify/consume;
- email provider;
- Auth user creation;
- membership creation.

**Expected changes:** purpose-specific DB functions plus thin strict-TypeScript application orchestration.

**Security/RLS:** safe/fixed `search_path`; caller identity from `auth.uid()`; no direct table writes; no generic service-role client.

**Acceptance:** AC-017-047..085 and relevant concurrency/security criteria.

**Tests:** authorization, idempotency, initial/resend concurrency, negative bypass.

### Work item C — Current-challenge verify + authoritative handoff

**Objective:** compose intent binding with TASK-013 verification/consume and persist handoff facts.

**Context:** verify is pre-auth and must not accept caller tenant authority.

**Scope:**

- intent/current-challenge resolver;
- target-email correlation under the existing TASK-013 contract;
- reuse HMAC/constant-time verifier;
- atomic attempt/consume + `SessionGrant` + handoff;
- same-operation reconciliation;
- safe pre-auth error mapping.

**Out of scope:**

- Auth user creation;
- `PlatformUser`;
- membership;
- profile;
- session establishment as a completed onboarding flow;
- completion evidence.

**Expected changes:** narrow server-only verification composition and intent handoff update.

**Security/RLS:** no raw privileged client export; no browser DB access; no tenant parameter authority.

**Acceptance:** AC-017-086..120, concurrency and threat-model criteria.

**Tests:** wrong/success attempts, replay, cross-intent, verify-vs-resend, double consume, handoff durability.

### Work item D — Provider-neutral delivery orchestration

**Objective:** expose the delivery seam without choosing a production provider.

**Context:** authoritative issuance and email delivery are distinct; RF-004 cannot be claimed end-to-end.

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

**Out of scope:**

- concrete provider;
- retry/backoff policy;
- durable delivery queue;
- provider credentials/config;
- production email template design.

**Expected changes:** strict TypeScript interface/orchestration only.

**Security/RLS:** no code/secret logs; no client secret exposure; `intentId` and verification link are locator/navigation only and never proof, bearer, handoff authority or tenant authority; verification URL contains no email/code/tenant/role/challenge/grant/Auth-user/token/technical-password material; no RLS/schema change.

**Acceptance:** AC-017-121..130.

**Tests:** delivery only after commit; failure leaves issuance intact; same-execution retry semantics; no plaintext persistence; exact verification pathname; code + link material; same locator across resend with new code; URL minimization; no concrete provider dependency.

### Work item E — Full regression and evidence package

**Objective:** prove TASK-017 without changing scope.

**Context:** TASK-017 sits on several security-sensitive foundations.

**Scope:**

- DB tests;
- TypeScript tests;
- concurrency tests;
- RLS/privilege tests;
- regression suite;
- lint/typecheck/build/verify;
- diff review evidence.

**Out of scope:** new functionality.

**Expected changes:** test files only as required by the approved implementation plan.

**Security/RLS:** explicit negative evidence for browser, anon, authenticated, `supabase_auth_admin`, global/tenant separation and no generic client.

**Acceptance:** all AC-017 criteria.

**Tests:** §32 in full.

### Work item F — Hosted Development verification

This is not an automatic Codex step.

It requires a separate human Gate before remote mutation or remote test setup.

**Objective:** verify the exact approved migration/functions/privileges and concurrency behavior in Hosted Development.

**Out of scope:** Staging, Production, commit/push by inference.

**Acceptance:** Hosted subset of §32 + all relevant security regressions.

---

## 35. Open questions / deferred decisions

### 35.1 Unresolved but NON-BLOCKING for TASK-017 authoritative foundation

The following remain unresolved and do not block the intent/challenge/handoff foundation because TASK-017 explicitly stops before or outside them:

1. concrete email provider;
2. provider-specific delivery retries/backoff;
3. durable delivery-attempt queue/outbox;
4. user-facing verification-code alphabet/digit count/visual format;
5. target-email retention/deletion period;
6. target-email change;
7. cancel/restart;
8. automatic cancellation when initiating `SUPER_ADMIN` later loses authority;
9. post-handoff delivery/session recovery beyond the TASK-017 end boundary;
10. final UX visual design.

These items may block later end-to-end product claims or later tasks, but they are not silently decided here.

### 35.2 Conditional blockers before implementation

No current material blocker is known for specification generation.

A future implementation must stop and return to the Revisor Central if any of the following becomes true:

1. current repository physical contracts materially differ from the approved TASK-013/TASK-014/TASK-016 foundations;
2. the TASK-013 verify/consume transition cannot be composed atomically with intent binding without duplicating or weakening its security invariants;
3. implementation would require tenant/role fields inside `VerificationChallenge`;
4. implementation would require a generic service-role/admin request client;
5. current SUPER_ADMIN authorization would need to be redesigned;
6. a provider-specific email decision becomes required merely to implement the authoritative DB foundation;
7. a new product rule for target-email change/cancel/restart becomes indispensable to the approved happy path;
8. a new PII retention decision becomes indispensable to schema correctness;
9. a new AuditEvent action would be required;
10. a migration would need to fabricate historical first-admin intents;
11. a required current email correlation cannot be made unambiguous under the existing TASK-013 contract;
12. a new architectural decision is necessary to preserve atomicity/concurrency/security;
13. any Acceptance Criterion becomes unsatisfiable under current canon.

Blocker label:

```text
TASK-017 IMPLEMENTATION =
BLOCKER — NEW ARCHITECTURAL/PRODUCT DECISION OR CANONICAL CONTRADICTION REQUIRED
```

No silent repair or scope expansion is allowed.

### 35.3 Deferred to future RF-012 / full onboarding

Explicitly deferred:

- exact Auth user creation timing;
- Auth provider reconciliation after handoff;
- exact `PlatformUser` creation timing;
- exact initial `CompanyMembership` creation timing;
- any pre-profile membership state;
- profile fields and profile persistence;
- exact transition that enables tenant authority;
- exact eventual onboarding-completion evidence shape;
- exact `USER_CREATED` producer timing;
- atomic completion transition after profile;
- initial Supabase session continuation/recovery as part of full onboarding;
- ordinary later-user onboarding;
- post-completion terminal behavior;
- full RF-012 and FL-01 steps 6–8.

The future task must continue to preserve:

```text
valid verification
→ profile completed
→ membership / tenant authority enabled
```

and must not reinterpret TASK-017 handoff as permission to skip that sequence.

---

## 36. Blockers

### 36.1 Current specification blockers

```text
required recovered sources available =
YES

source identity mismatch =
NO

material product contradiction =
NO

material architecture contradiction =
NO

new ADR prerequisite =
NO

new CORR prerequisite =
NO

TASK-017 SPECIFICATION BLOCKER =
NONE
```

### 36.2 Execution blocker policy

During any future implementation, a blocker produces:

```text
NO SCOPE EXPANSION
NO SILENT REPAIR
NO STAGING
NO COMMIT
NO PUSH
NO SUPABASE/HOSTED MUTATION BEYOND SEPARATELY AUTHORIZED GATE
RETURN TO REVISOR CENTRAL
```

---

## 37. Migration / repository change envelope for a future implementation

This specification does not create the migration. It defines the future change envelope.

Expected physical direction:

```text
one additive TASK-017 migration
+
minimal Identity & Authorization server/application code
+
tests
```

The migration may contain only what is needed for:

- `first_admin_onboarding_intents`;
- PK/FK/unique/check constraints;
- justified indexes;
- RLS enablement;
- grants/revokes;
- purpose-specific establishment/resend/verify-handoff functions or wrappers;
- strictly necessary helper functions internal to those boundaries.

It must not contain:

- Auth user creation;
- `PlatformUser` creation;
- `CompanyMembership` creation;
- tenant operational tables;
- client scope;
- support grants;
- Subscription;
- promotional entitlement;
- generic invitation framework;
- generic idempotency table/framework;
- email provider tables/queues;
- new audit actions;
- microservices.

If repository inspection demonstrates that more than one migration is materially required for safe compatibility, implementation must return for scope review rather than split by convenience.

---

## 38. Expected application/module placement

TASK-017 remains inside the modular monolith.

Expected conceptual ownership:

```text
src/modules/identity-authorization/
```

or the current equivalent repository location established by prior tasks.

Responsibilities should remain separated conceptually into:

- application use cases/contracts;
- server-only challenge/handoff orchestration;
- Supabase purpose-specific adapters;
- existing crypto helpers from TASK-013;
- provider-neutral delivery port.

No domain/security rule should be placed solely in React components, route middleware or ad-hoc browser queries.

Strict TypeScript remains mandatory.

No new ORM, auth framework, crypto package, queue framework or microservice SDK may be installed by inference.

---

## 39. Next Gate

The Central Spec Review, Human Specification Approval and Approved Artifact Review are complete. This canonical candidate has been generated under the authorized Canonicalization Generation Gate, but it does not approve its own canonicalization.

```text
TASK-017 canonicalization =
CANDIDATE GENERATED — PENDING CENTRAL REVIEW

next governance step =
TASK-017 CANONICALIZATION REVIEW
```

This canonical candidate does not authorize:

- canonicalization approval;
- repository incorporation;
- implementation;
- Codex;
- SQL execution;
- migrations execution;
- RLS mutation;
- Supabase/Hosted mutation;
- Staging;
- Production;
- staging in Git;
- commit;
- push.

Any later approval must remain separate from implementation authorization.

---

## 40. Final specification state

```text
TASK-017 CANONICAL SOURCE AVAILABILITY CHECK =
PASS

TASK-017 SPECIFICATION RESUMPTION =
AUTHORIZED UNDER EXISTING GATE

TASK-017 SPECIFICATION GENERATION =
PASS

TASK-017 CENTRAL SPEC REVIEW =
APPROVED

TASK-017 HUMAN SPECIFICATION APPROVAL =
APPROVED

TASK-017 APPROVED ARTIFACT REVIEW =
APPROVED

TASK-017 SPECIFICATION =
APPROVED

TASK-017 approved artifact =
GENERATED

TASK-017 canonicalization =
CANDIDATE GENERATED — PENDING CENTRAL REVIEW

TASK-017 canonical candidate =
GENERATED

TASK-017 repository incorporation =
NOT AUTHORIZED / NOT APPROVED

current specification blocker =
NONE

implementation =
NOT AUTHORIZED

Codex =
NOT AUTHORIZED

repository mutation =
NO

Supabase / Hosted mutation =
NO

staging =
NO

commit =
NO

push =
NO
```

This document is the TASK-017 canonical candidate generated for Canonicalization Review.

It does not modify the prior blocker record and does not declare canonicalization approved, repository incorporation approved or implementation authorized.
