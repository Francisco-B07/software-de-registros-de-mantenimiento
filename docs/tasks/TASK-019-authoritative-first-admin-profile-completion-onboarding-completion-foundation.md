# TASK-019 — Authoritative First-Admin Profile Completion and Onboarding Completion Foundation

## 0. Document identity and governance status

```text
TASK ID =
TASK-019

title =
Authoritative First-Admin Profile Completion and Onboarding Completion Foundation

class =
TASK — PHASE 2 FUNCTIONAL / AUTHORIZATION FOUNDATION

phase =
Phase 2

specification status =
GENERATED / PENDING REVIEW

implementation authorized =
NO

repository mutation authorized by this artifact =
NO

Supabase mutation authorized by this artifact =
NO
```

This document specifies the next bounded increment after TASK-017, TASK-018 and CORR-034. It does not implement the increment, authorize Codex execution, close Phase 2, define the Phase 2 Exit Gate, or start Phase 3.

The authoritative functional boundary is:

```text
authenticated first-admin
+
valid Auth session
+
authoritative FirstAdminOnboardingIntent correlation
+
/pending-profile

→

authoritative profile/onboarding completion

→

PlatformUser established/reconciled
+
profile completed
+
initial enabled COMPANY_ADMIN membership established
+
USER_CREATED exactly once
+
FirstAdminOnboardingIntent terminal completion persisted
+
tenant authority observable after commit
+
/onboarding-complete
```

Mandatory distinctions remain:

```text
authenticated != authorized
Auth session != tenant authorization
Auth identity != PlatformUser profile
PlatformUser existence != tenant authority
profile validation != onboarding completion
pathname != authority
```

---

## 1. Authorization to generate this specification

Human authorization:

```text
TASK-019 SPECIFICATION GENERATION AUTHORIZATION =
APPROVED
```

Inputs authorized for specification generation:

```text
TASK-019 DETERMINATION =
APPROVED

TASK-019 SPECIFICATION SOURCE RECOVERY =
PASS

TASK-019 SUPPLEMENTAL CANONICAL SOURCE RECOVERY =
PASS

TASK-019 SPECIFICATION SOURCE RECOVERY REVIEW =
APPROVED
```

This specification consumes the recovered physical corpus and the later human governance state. A stale historical source that states `TASK-019 NOT DETERMINED` does not override the later explicit human determination.

---

## 2. Authoritative source corpus

### 2.1 Physical corpus packages

Implementation/source package:

```text
filename =
TASK-019-specification-sources.zip

SHA-256 =
30c85464c6c05c1b69e01ffa6e5646dfccc0749504e7495b81c4f797d4f37acc

source count =
94
```

Canonical supplement:

```text
filename =
TASK-019-specification-canonical-supplement.zip

SHA-256 =
e766d98165818cffdf48e803ace9fd93c1a61f31bfda69e0dc9a10bd58161474

source count =
12
```

Recovered corpus result:

```text
total unique physical sources =
106

path overlap =
0

source identity mismatches =
0
```

### 2.2 Repository baseline represented by the corpus

```text
branch =
main

HEAD =
fb2a977f2be288312ae9d75fb057cd9dff8ca6f0

origin/main =
fb2a977f2be288312ae9d75fb057cd9dff8ca6f0

remote main HEAD =
fb2a977f2be288312ae9d75fb057cd9dff8ca6f0

divergence =
0 0

worktree =
CLEAN
```

### 2.3 Canonical documents that constrain TASK-019

At minimum:

- `docs/product/00-master-product-brief.md`
- `docs/product/01-product-definition.md`
- `docs/product/02-domain-model.md`
- `docs/product/03-permissions-rls-strategy.md`
- `docs/product/10-architecture-decisions-records.md`
- `docs/product/11-phase-1-scope-entry-gate.md`
- `docs/architecture/adr/ADR-0001-modular-nextjs-architecture.md`
- `docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md`
- `docs/architecture/adr/ADR-0003-authorization-client-scope-support.md`
- `docs/architecture/adr/ADR-0019-verification-challenge-supabase-auth-session-boundary.md`
- `docs/architecture/adr/ADR-0020-authoritative-first-admin-onboarding-intent-binding.md`
- `docs/tasks/TASK-009-identity-tenant-foundation.md`
- `docs/tasks/TASK-010-audit-event-foundation.md`
- `docs/tasks/TASK-011-auth-ssr-lifecycle-foundation.md`
- `docs/tasks/TASK-012-authoritative-online-authorization-foundation.md`
- `docs/tasks/TASK-013-verification-challenge-foundation.md`
- `docs/tasks/TASK-014-super-admin-global-identity-authorization-foundation.md`
- `docs/tasks/TASK-015-company-membership-lifecycle-audit-event-atomic.md`
- `docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md`
- `docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md`
- `docs/tasks/CORR-021-privileged-rpc-boundary-hardening.md`
- `docs/tasks/CORR-032-task-013-auth-bridge-prebound-hook-correction.md`
- `docs/tasks/CORR-034-first-admin-profile-completion-product-decision-sync.md`

### 2.4 Current implementation primitives that constrain the physical design

Material current sources include:

- TASK-009 identity/tenant migration;
- TASK-010 AuditEvent migration;
- TASK-013 verification/session migrations;
- TASK-014 global identity authorization migration;
- CORR-021 privileged RPC hardening migration;
- TASK-015 membership lifecycle migration;
- TASK-017 onboarding intent/handoff migration;
- TASK-018 handoff resolver and technical-password state migrations;
- CORR-032 auth-hook correction migration;
- `/pending-profile` current shell;
- TASK-018 verification/session route and services;
- current Supabase server/browser infrastructure;
- current identity-authorization module boundaries;
- current TASK-009..TASK-018 regression suites.

The specification must preserve these primitives unless it explicitly declares a bounded extension.

---

## 3. Problem statement and physical gaps

TASK-017 establishes authoritative onboarding intent, challenge/proof and durable handoff. TASK-018 establishes/reconciles the Supabase Auth identity and establishes the authenticated session. CORR-034 resolves the product/domain semantics of first-admin profile completion. The repository still lacks the authoritative completion transition.

Physical gaps to close:

```text
GAP-019-001 =
missing PlatformUser profile fields

GAP-019-002 =
missing durable terminal completion / operation correlation on FirstAdminOnboardingIntent

GAP-019-003 =
missing authoritative atomic completion operation

GAP-019-004 =
missing PlatformUser + initial CompanyMembership writer

GAP-019-005 =
/pending-profile is a shell, not the required form/action

GAP-019-006 =
/onboarding-complete route is absent

GAP-019-007 =
missing TASK-019-specific tests

GAP-019-011 =
existing compatible PlatformUser needs physical reconciliation semantics

GAP-019-012 =
compatible/incompatible existing PlatformUser rules need physical definition
```

No new ADR requirement was discovered while inspecting the physical corpus.

```text
new ADR required =
NO
```

If implementation cannot satisfy this specification without introducing a material architectural decision beyond ADR-0001/0002/0003/0019/0020, implementation must stop and return for an ADR Gate.

---

## 4. Scope

### 4.1 In scope

TASK-019 includes exactly:

1. `PlatformUser.first_name`.
2. `PlatformUser.last_name`.
3. `PlatformUser.profile_completed_at`.
4. durable terminal completion evidence on `FirstAdminOnboardingIntent`;
5. durable completion `operation_id` correlation;
6. purpose-specific current-session onboarding-state resolution for UI routing;
7. one purpose-specific authoritative first-admin completion operation;
8. no-identity PlatformUser creation;
9. compatible existing PlatformUser reconciliation;
10. incompatible identity fail-closed behavior;
11. current Auth subject → application identity binding when application identity does not yet exist;
12. initial `CompanyMembership` creation with fixed role `COMPANY_ADMIN` and `is_enabled = true`;
13. exactly-one `USER_CREATED` event in the completion transaction;
14. terminal `FirstAdminOnboardingIntent` update in the same transaction;
15. idempotent same-operation reconciliation;
16. concurrent winner/loser behavior;
17. ambiguous timeout reconciliation through same-operation retry;
18. `/pending-profile` minimum form;
19. online API/server boundary for submission;
20. `/onboarding-complete` minimum confirmation shell;
21. routing based on authoritative state, not pathname authority;
22. database, RLS/privilege, application and UI regression tests.

### 4.2 Out of scope

Explicitly excluded:

- ordinary later-user onboarding;
- generic user creation;
- generic membership creation;
- `UserClientAccess` establishment;
- Client CRUD;
- `SupportAccessGrant`;
- dashboard implementation;
- full application route authorization;
- resource authorization framework;
- offline onboarding;
- IndexedDB/Dexie/outbox authority for privileged onboarding;
- commercial Subscription state;
- payments;
- AI credits;
- forms engine;
- maintenance execution;
- reports;
- Phase 2 Exit Gate definition;
- Phase 2 closure;
- Phase 3 start.

No profile field other than `first_name` and `last_name` may be introduced by TASK-019.

---

## 5. Closed product decisions A–J

TASK-019 consumes these decisions without reopening them.

### A — Profile fields

```text
first_name = required
last_name = required
trimmed non-empty = required
email = Auth-derived / not editable
profile_completed_at = system-owned
```

TASK-019 does not introduce a product max length. Physical input handling must remain bounded at the HTTP layer for abuse resistance without redefining the product model; the database persists trimmed non-empty text and does not establish a product-visible max length in this increment.

### B — Ownership

```text
first_name
last_name
profile_completed_at
```

belong to `PlatformUser`, not `CompanyMembership` and not a new `UserProfile` entity.

### C — PlatformUser timing

The Supabase Auth identity/session may exist before `PlatformUser`. TASK-019 creates or reconciles `PlatformUser` inside authoritative completion.

### D — Initial membership

No pre-profile first-admin membership is created. Successful completion creates the initial enabled `COMPANY_ADMIN` membership.

### E — Ordering

Authoritative ordering remains:

1. Auth session exists;
2. resolve Auth subject;
3. resolve authoritative onboarding correlation;
4. validate intent/email/company/purpose/handoff/not-terminal/identity/operation;
5. validate profile fields;
6. create/reconcile `PlatformUser`;
7. persist profile fields and `profile_completed_at`;
8. create/reconcile initial membership;
9. produce `USER_CREATED`;
10. persist terminal onboarding evidence;
11. commit;
12. tenant authority becomes observable.

### F — Operation

One purpose-specific mutation: `complete first-admin onboarding`.

Functional caller input only:

```text
first_name
last_name
operation_id
```

### G — Durable completion authority

`FirstAdminOnboardingIntent` is the sole durable onboarding-completion authority.

### H — Audit

`USER_CREATED` is produced exactly once during successful authoritative completion.

### I — Retry/concurrency

Same operation reconciles the same result. Different operation cannot bypass terminal state. Concurrent completion has at most one winner.

### J — Destination

Successful completion routes to `/onboarding-complete`, a minimum confirmation shell.

---

## 6. Current physical model to preserve

### 6.1 `platform_users`

Current relevant state before TASK-019:

```text
id uuid primary key
is_super_admin boolean not null default false
```

`platform_user_auth_subjects` maps exactly one Auth subject primary key to one `platform_user_id`.

### 6.2 `company_memberships`

Current relevant state:

```text
id uuid primary key
platform_user_id uuid not null unique
maintenance_company_id uuid not null
role text not null in ('COMPANY_ADMIN', 'TECHNICIAN')
is_enabled boolean not null
```

The unique `platform_user_id` preserves the current `PlatformUser → 0..1 CompanyMembership` model.

### 6.3 `audit_events`

`USER_CREATED` already exists as an allowed action. `AuditEvent` requires:

- `maintenance_company_id`;
- one actor representation;
- `scope_kind = 'USER'`;
- `subject_platform_user_id`;
- role snapshots null for `USER_CREATED`.

### 6.4 `first_admin_onboarding_intents`

Current pre-TASK-019 columns:

```text
id
maintenance_company_id
target_email
initiated_by_platform_user_id
establishment_operation_id
current_challenge_id
handoff_session_grant_id
handoff_ready_at
created_at
```

It currently has no completion state.

### 6.5 TASK-018 application-identity compatibility primitive

Current TASK-018 resolver classifies a bound Auth user as:

```text
NO_APPLICATION_IDENTITY
COMPATIBLE_EXISTING_APPLICATION_IDENTITY
INCOMPATIBLE_IDENTITY
FAIL_CLOSED
```

The current physical compatibility basis is:

```text
no application mapping
→ NO_APPLICATION_IDENTITY

mapped PlatformUser
+ is_super_admin = false
+ no CompanyMembership
→ COMPATIBLE_EXISTING_APPLICATION_IDENTITY

mapped PlatformUser
+ is_super_admin = true
OR any CompanyMembership exists
→ INCOMPATIBLE_IDENTITY
```

TASK-019 must preserve this upstream classification and add the profile-state compatibility checks defined below.

---

## 7. Domain model changes

### 7.1 `PlatformUser`

Add physical attributes:

```text
first_name text null
last_name text null
profile_completed_at timestamptz null
```

They are nullable at table level because existing platform identities, including `SUPER_ADMIN`, predate this profile-completion slice and must remain valid without invented backfill data.

Add one coupled-state invariant:

```text
INCOMPLETE PROFILE =
first_name is null
AND last_name is null
AND profile_completed_at is null

COMPLETED PROFILE =
first_name is not null
AND last_name is not null
AND profile_completed_at is not null
AND first_name = btrim(first_name)
AND last_name = btrim(last_name)
AND btrim(first_name) <> ''
AND btrim(last_name) <> ''
```

Any partial profile state is invalid.

Recommended constraint identity:

```text
platform_users_profile_completion_state_check
```

The migration must not invent first/last names for existing users.

### 7.2 `FirstAdminOnboardingIntent`

Add terminal evidence:

```text
completion_operation_id uuid null
completed_platform_user_id uuid null
completed_company_membership_id uuid null
completed_at timestamptz null
```

Required FKs:

```text
completed_platform_user_id
→ public.platform_users(id)
ON DELETE RESTRICT

completed_company_membership_id
→ public.company_memberships(id)
ON DELETE RESTRICT
```

Required uniqueness:

```text
completion_operation_id UNIQUE
```

PostgreSQL nullable unique semantics are acceptable: multiple pending intents may have null; a committed operation id may identify at most one completed intent.

Required coupled terminal invariant:

```text
PENDING =
completion_operation_id is null
AND completed_platform_user_id is null
AND completed_company_membership_id is null
AND completed_at is null

COMPLETED =
completion_operation_id is not null
AND completed_platform_user_id is not null
AND completed_company_membership_id is not null
AND completed_at is not null
```

No partial terminal state is allowed.

Recommended constraint identity:

```text
first_admin_onboarding_intents_completion_state_check
```

Column comments must state that completion evidence, not handoff-ready, establishes onboarding completion.

### 7.3 No new entity

No `UserProfile`, completion table, idempotency table, generic user-provisioning table, or generic membership-creation table is introduced.

---

## 8. Authoritative current-session correlation

TASK-019 must never accept `intent_id`, company, role, membership ID, platform-user ID, target email or actor ID as caller authority.

The database boundary derives the active first-admin intent from current authenticated state.

### 8.1 Required correlation chain

For current `auth.uid()` the authoritative chain is:

```text
auth.uid()
=
auth_session_grants.auth_user_id
=
auth_bridge_credentials.auth_user_id

first_admin_onboarding_intents.handoff_session_grant_id
→ auth_session_grants.id

auth_session_grants.auth_bridge_credential_id
→ auth_bridge_credentials.id

first_admin_onboarding_intents.target_email
=
auth_bridge_credentials.email
```

Additional required handoff facts:

```text
handoff_session_grant_id is not null
handoff_ready_at is not null
session grant purpose = 'initial_session'
session grant auth_method = 'password'
session grant consumed_at is not null
session grant revoked_at is null
```

The grant does not need to remain unexpired after it was validly consumed. Completion relies on the authenticated session and durable consumed correlation, not on extending the original five-minute handoff grant lifetime.

### 8.2 Exact-one rule

The current subject must resolve to exactly one correlated first-admin intent.

```text
0 matches
→ fail closed

1 match
→ continue

>1 matches
→ fail closed
```

The caller cannot disambiguate by sending an intent identifier.

### 8.3 Lock/recheck rule

The completion mutation must:

1. read preliminary `auth.uid()`;
2. resolve the one candidate `FirstAdminOnboardingIntent` and its `maintenance_company_id` provisionally;
3. lock that authoritative `MaintenanceCompany` row `FOR UPDATE`;
4. lock the same `FirstAdminOnboardingIntent` row `FOR UPDATE`;
5. re-read `auth.uid()` and require it to match the preliminary subject;
6. re-resolve and revalidate the complete authoritative correlation after both locks are held;
7. process terminal same-operation / different-operation state only after that revalidation;
8. only then continue with Auth-subject mapping, PlatformUser and CompanyMembership locking/mutation.

The preliminary candidate read is not final authority. Authority is confirmed only after the tenant/company and intent locks are held and the complete correlation is revalidated.

This preserves the existing TASK-017 lock order:

```text
MaintenanceCompany
→ FirstAdminOnboardingIntent
```

No global platform lock is introduced.

---

## 9. PlatformUser reconciliation semantics

### 9.1 No current application identity

If no `platform_user_auth_subjects` row exists for current `auth.uid()`:

1. create one new `platform_users` row with `gen_random_uuid()`;
2. `is_super_admin = false`;
3. persist trimmed `first_name`, trimmed `last_name`, trusted `profile_completed_at`;
4. insert `platform_user_auth_subjects(auth_subject_id = auth.uid(), platform_user_id = new id)`;
5. continue to initial membership creation.

No browser-supplied platform-user ID is accepted.

### 9.2 Compatible existing application identity

An existing mapped `PlatformUser` is compatible for first completion only if all are true after row locking:

```text
auth_subject mapping belongs to current auth.uid()
is_super_admin = false
no CompanyMembership exists for that PlatformUser
first_name is null
last_name is null
profile_completed_at is null
```

If compatible:

- reuse the existing `PlatformUser.id`;
- persist trimmed first/last names and trusted completion timestamp;
- do not create a second `PlatformUser`;
- do not replace or relink the Auth-subject mapping.

### 9.3 Incompatible existing application identity

Fail closed if any of these are true before terminal reconciliation:

- mapped PlatformUser is `SUPER_ADMIN`;
- mapped PlatformUser already has any `CompanyMembership`;
- profile state is completed before this intent is terminal;
- profile state is partial/invalid;
- current Auth subject maps to an unexpected identity;
- any correlation indicates cross-identity or cross-tenant state.

No account takeover, generic linking or identity merge is introduced.

### 9.4 Terminal same-operation reconciliation takes precedence

After locking the intent, if the intent is already terminal:

```text
completion_operation_id = caller operation_id
→ reconcile the already committed result
→ no mutation
→ no second USER_CREATED

completion_operation_id != caller operation_id
→ deny/fail closed as already completed by another logical operation
```

This check occurs before treating the now-established membership/profile as an incompatible pre-completion identity. Otherwise a valid retry would be misclassified after the winner committed.

---

## 10. Initial CompanyMembership semantics

TASK-019 creates the first tenant membership only inside successful completion.

Required values:

```text
id = trusted DB-generated UUID
platform_user_id = resulting PlatformUser.id
maintenance_company_id = FirstAdminOnboardingIntent.maintenance_company_id
role = 'COMPANY_ADMIN'
is_enabled = true
```

### 10.1 Tenant/company serialization

The completion function must lock the authoritative `maintenance_companies` row for the intent before inserting the initial membership.

Purpose:

- serialize the initial membership boundary for that tenant;
- remain consistent with TASK-015 tenant-local locking patterns;
- avoid a global lock.

### 10.2 Initial-membership conflict

Before insert, require that the target `PlatformUser` has no membership and that the intent company has no existing `company_memberships` row representing an already-established tenant user population for this initial onboarding path.

If conflicting tenant membership state exists, fail closed. TASK-019 does not convert, adopt, overwrite or delete an unrelated membership.

### 10.3 TASK-015 API is not extended

Do not reinterpret:

```text
public.apply_company_membership_lifecycle
```

as a creation API. Its current scope remains:

```text
DISABLE
REINSTATE
CHANGE_ROLE
```

The first-admin creation path is a distinct purpose-specific transaction.

---

## 11. USER_CREATED audit semantics

TASK-019 uses the existing action:

```text
USER_CREATED
```

No new audit action is added.

Exactly one event is inserted on the first successful completion transaction with:

```text
id = gen_random_uuid()
maintenance_company_id = intent.maintenance_company_id
actor_kind = 'PLATFORM_USER'
actor_platform_user_id = intent.initiated_by_platform_user_id
actor_internal_process_key = null
action = 'USER_CREATED'
occurred_at = trusted database time
scope_kind = 'USER'
subject_platform_user_id = resulting PlatformUser.id
role_before = null
role_after = null
```

The actor is historical provenance from the intent. The target first-admin is not the actor of their own creation event.

No event is written for:

- render;
- client validation failure;
- server input validation failure;
- correlation failure;
- incompatible identity;
- failed transaction;
- same-operation terminal reconciliation;
- different-operation denied replay.

---

## 12. Database operation contract

### 12.1 Public mutation

Define exactly one public purpose-specific mutation:

```text
public.complete_first_admin_onboarding(
  p_first_name text,
  p_last_name text,
  p_operation_id uuid
)
```

Language: SQL or PL/pgSQL wrapper as appropriate.

Mandatory properties:

```text
VOLATILE
SECURITY INVOKER
SET search_path = ''
owner = postgres
```

It delegates to one unexposed purpose-specific internal function.

### 12.2 Private implementation

Define:

```text
private.complete_first_admin_onboarding(
  p_first_name text,
  p_last_name text,
  p_operation_id uuid
)
```

Mandatory properties:

```text
PL/pgSQL
VOLATILE
SECURITY DEFINER
SET search_path = ''
owner = postgres
```

All relations/functions must be schema-qualified.

### 12.3 Mutation result shape

Both functions return a bounded table result:

```text
outcome text
reason text
platform_user_id uuid
company_membership_id uuid
completed_at timestamptz
```

Allowed `outcome` values:

```text
COMPLETED
ALREADY_COMPLETED
DENIED
```

Allowed deterministic `reason` values:

```text
COMPLETED
ALREADY_COMPLETED
INVALID_INPUT
AUTHORIZATION_DENIED
SECURITY_CORRELATION_FAILURE
IDENTITY_INCOMPATIBLE
INITIAL_MEMBERSHIP_CONFLICT
ONBOARDING_ALREADY_COMPLETED
```

Semantics:

```text
COMPLETED
→ transaction performed now

ALREADY_COMPLETED
→ same operation_id reconciled a previously committed terminal result
→ changed state = none

DENIED
→ no successful state mutation from this call
```

Infrastructure/database exceptions that cannot safely be classified must propagate to the server boundary and become a bounded retryable failure there; they must not be translated into a false successful result.

### 12.4 Input normalization

The database boundary must:

```text
p_operation_id is not null
p_first_name is not null
p_last_name is not null
```

Canonical values:

```text
v_first_name = btrim(p_first_name)
v_last_name = btrim(p_last_name)
```

Require both canonical values non-empty.

Persist canonical values, not surrounding whitespace.

TASK-019 does not add a product max length. The HTTP parser may apply a conservative transport-size cap solely to prevent abusive payloads; that cap must not be documented or enforced as a product/profile domain limit.

---

## 13. Read-only current onboarding state contract

TASK-019 needs authoritative route-state resolution so `/pending-profile` and `/onboarding-complete` do not treat pathname as authority.

Define one read-only purpose-specific resolver pair:

```text
public.resolve_current_first_admin_onboarding_state()
private.resolve_current_first_admin_onboarding_state()
```

Public wrapper:

```text
STABLE
SECURITY INVOKER
SET search_path = ''
```

Private implementation:

```text
STABLE
SECURITY DEFINER
SET search_path = ''
```

Return exactly one bounded row:

```text
state text
completed_at timestamptz
```

Allowed states:

```text
PENDING_PROFILE
COMPLETED
UNAVAILABLE
```

Rules:

```text
PENDING_PROFILE =
current Auth subject resolves exactly one consumed authoritative first-admin handoff
AND intent is not terminal
AND identity is still eligible for completion

COMPLETED =
current Auth subject resolves exactly one correlated intent
AND terminal evidence is complete and internally consistent

UNAVAILABLE =
no unique valid authoritative state can be established
```

The resolver must not expose another tenant's intent, IDs, actor, membership, or email.

It is read-only and does not grant authority. It exists only for bounded UI routing/state projection.

---

## 14. Transaction and locking model

The private completion implementation is one PostgreSQL transaction by function execution.

Required lock order:

1. read preliminary current Auth correlation and resolve the candidate intent plus `maintenance_company_id` provisionally;
2. lock target `maintenance_companies` row;
3. lock the same `first_admin_onboarding_intents` row;
4. re-read current Auth subject and re-resolve/revalidate the complete authoritative correlation;
5. handle terminal same/different operation;
6. lock existing Auth-subject mapping and PlatformUser when present;
7. inspect/lock any existing membership relevant to the target PlatformUser/company;
8. create/reconcile PlatformUser profile;
9. create initial membership;
10. insert `USER_CREATED`;
11. update terminal intent evidence;
12. return result;
13. commit atomically.

The preliminary candidate read is not final authority. The completion operation must not treat tenant, intent or identity correlation as authoritative until the `MaintenanceCompany` and `FirstAdminOnboardingIntent` locks are both held and the correlation has been revalidated.

The lock order intentionally matches TASK-017:

```text
MaintenanceCompany
→ FirstAdminOnboardingIntent
```

No global advisory lock is permitted.

The design must not depend on application-side multi-step compensation.

Atomic invariant:

```text
PlatformUser/profile establishment
+
Auth-subject application mapping if newly required
+
initial enabled COMPANY_ADMIN membership
+
USER_CREATED
+
FirstAdminOnboardingIntent terminal evidence
=
ALL COMMIT OR NONE COMMIT
```

---

## 15. Idempotency and concurrency

### 15.1 Same-operation retry

If an intent is terminal with the same `completion_operation_id`:

- return `ALREADY_COMPLETED`;
- return the stored resulting IDs/timestamp;
- do not rewrite names;
- do not create another membership;
- do not create another audit event;
- do not change terminal state.

This is the mandatory ambiguous-timeout reconciliation path.

### 15.2 Different-operation replay

If terminal with a different operation ID:

```text
outcome = DENIED
reason = ONBOARDING_ALREADY_COMPLETED
```

No mutation.

### 15.3 Concurrent calls

Intent row locking must guarantee at most one completion winner.

For two concurrent calls:

- winner completes and commits;
- loser waits on the same intent lock;
- if same operation ID, loser reconciles `ALREADY_COMPLETED`;
- if different operation ID, loser receives deterministic denial.

### 15.4 Duplicate prevention

Must prevent durable duplicates of:

- PlatformUser for one current Auth subject in this flow;
- Auth-subject mapping;
- CompanyMembership;
- `USER_CREATED`;
- intent terminal completion.

---

## 16. RLS, grants and privilege boundary

### 16.1 Existing RLS remains mandatory

No RLS disablement.

No broad insert/update policy for `platform_users`, `platform_user_auth_subjects`, `company_memberships`, `audit_events` or `first_admin_onboarding_intents` is introduced.

Expected policy changes:

```text
new ordinary table RLS policies =
NONE

changed ordinary table RLS policies =
NONE
```

Existing post-completion own-data read policies from TASK-009 continue to make current identity/membership/company observable only after the application mapping and enabled membership commit.

### 16.2 Function grants

For both new public functions:

```text
REVOKE ALL
FROM public, anon, authenticated, service_role, supabase_auth_admin

GRANT EXECUTE
TO authenticated
```

For both private implementations:

```text
REVOKE ALL
FROM public, anon, authenticated, service_role, supabase_auth_admin

GRANT EXECUTE
TO authenticated
```

Use the existing CORR-021 private-schema model. Do not grant generic table writes to authenticated.

`anon` must not execute either operation.

`PUBLIC` must not execute either operation.

No browser/service-role generic writer is introduced.

### 16.3 SECURITY DEFINER constraints

Internal functions must:

- be purpose-specific;
- use empty `search_path`;
- use schema-qualified references;
- derive current subject from `auth.uid()`;
- derive tenant/actor/role from authoritative rows;
- reject caller-chosen authority;
- avoid dynamic SQL;
- avoid any generic table mutation parameters.

---

## 17. Server/application module design

TASK-019 remains inside the existing `identity-authorization` module.

### 17.1 New application contract

Add:

```text
src/modules/identity-authorization/application/first-admin-profile-completion.ts
```

It defines immutable TypeScript types for:

```text
FirstAdminProfileCompletionInput
FirstAdminProfileCompletionResult
FirstAdminOnboardingState
FirstAdminProfileCompletionSource
```

Input:

```text
firstName
lastName
operationId
```

No tenant/role/intent/member/user/actor authority fields.

### 17.2 Application service

Add:

```text
src/modules/identity-authorization/application/first-admin-profile-completion-service.ts
```

Responsibilities:

- validate basic shape;
- preserve operation ID;
- call source;
- strictly parse bounded database results;
- map database/infrastructure failures to bounded application outcomes;
- expose `complete()` and `resolveState()`;
- contain no service-role secret;
- contain no direct table writes.

### 17.3 Supabase source

Add:

```text
src/modules/identity-authorization/infrastructure/supabase/first-admin-profile-completion-source.ts
```

It uses the existing authenticated server Supabase client/cookie boundary and invokes only:

```text
complete_first_admin_onboarding
resolve_current_first_admin_onboarding_state
```

It must not use `supabaseSecretKey` or Auth Admin for the completion mutation.

### 17.4 Module server boundary

Modify:

```text
src/modules/identity-authorization/server.ts
```

Export the new public application types and server-only factory functions needed by API routes/server pages.

No client module imports private config or service-role infrastructure.

---

## 18. HTTP completion boundary

Add:

```text
app/api/first-admin/profile-completion/route.ts
```

Method:

```text
POST only
```

Required protections consistent with the existing first-admin verification route:

- same-origin request check;
- JSON content type check;
- exact request-key set;
- bounded input shape;
- private/no-store response headers;
- authenticated server cookie transport;
- no authority-bearing tenant/role/intent fields.

Request body keys exactly:

```text
firstName
lastName
operationId
```

Deterministic response outcome projection must be bounded. The route must not leak raw database errors or internal IDs unless required for the client flow. The browser only needs a result classification; IDs are not required by the UI and should not be returned by default.

Recommended HTTP mapping:

```text
COMPLETED / ALREADY_COMPLETED
→ 200

INVALID_INPUT
→ 400

AUTHORIZATION_DENIED / SECURITY_CORRELATION_FAILURE / IDENTITY_INCOMPATIBLE
→ 403 or bounded 400 according to non-enumerating route policy

INITIAL_MEMBERSHIP_CONFLICT / ONBOARDING_ALREADY_COMPLETED
→ 409

infrastructure/ambiguous failure
→ 503
```

The exact externally exposed error vocabulary must remain smaller than or equal to the application result vocabulary and must not become an authority oracle.

---

## 19. `/pending-profile` UI

### 19.1 Server page behavior

Modify:

```text
app/pending-profile/page.tsx
```

Before presenting the editable form, resolve authoritative current onboarding state server-side.

Routing behavior:

```text
PENDING_PROFILE
→ render profile form

COMPLETED
→ redirect('/onboarding-complete')

UNAVAILABLE
→ fail closed to the existing safe entry surface
```

TASK-019 must not introduce a dashboard redirect for `UNAVAILABLE`.

### 19.2 Client form

Add:

```text
app/first-admin-profile-form.tsx
```

Fields exactly:

```text
first_name
last_name
```

UI rules:

- both required;
- trim-aware non-empty client validation;
- email is not editable and need not be shown;
- submit while pending is disabled;
- generate one `crypto.randomUUID()` for one logical completion attempt;
- preserve the same operation ID across ambiguous/retryable network retries;
- do not generate a new operation ID merely because the first response was lost;
- if the user changes profile values after a deterministic pre-commit validation error, a new logical attempt may use a new operation ID;
- success redirects to `/onboarding-complete`;
- error UI must not claim tenant authority was established unless completion returned success/reconciliation.

No tenant selector, role selector, intent ID, membership ID or actor field is rendered.

---

## 20. `/onboarding-complete` UI

Add:

```text
app/onboarding-complete/page.tsx
```

The page is a server-rendered minimum confirmation shell.

Before displaying completion facts, resolve authoritative state.

Routing behavior:

```text
COMPLETED
→ render shell

PENDING_PROFILE
→ redirect('/pending-profile')

UNAVAILABLE
→ fail closed to the existing safe entry surface
```

The shell may state only facts established by TASK-019, for example:

```text
Perfil completado.
Tu cuenta ya está habilitada para administrar la empresa.
```

It must not claim:

- dashboard availability;
- Client access;
- UserClientAccess;
- SupportAccessGrant;
- full resource authorization;
- Phase 2 completion.

---

## 21. Online/offline behavior

```text
profile completion =
ONLINE ONLY

privileged onboarding completion =
ONLINE ONLY

IndexedDB authority =
NO

Dexie authority =
NO

outbox privileged completion =
NO
```

The browser may retain transient form state for UX, but it may not represent completion, tenant authority, terminal intent state or audit success offline.

An offline or network-failed submit is not success. Retry must use the same operation ID until the authoritative result is reconciled.

---

## 22. Failure model

### 22.1 Invalid input

Empty-after-trim names, malformed operation ID or malformed HTTP payload:

```text
no mutation
no audit event
no terminal intent state
```

### 22.2 Missing/invalid Auth session

```text
fail closed
no mutation
```

### 22.3 Correlation failure

Any mismatch among current subject, consumed grant, bridge, intent or target email:

```text
fail closed
no identity linking
no membership
no audit
```

### 22.4 Incompatible application identity

Existing SUPER_ADMIN, any preexisting membership, completed/partial pre-terminal profile, or unexpected identity mapping:

```text
fail closed
```

### 22.5 Initial tenant membership conflict

If the intended first-admin completion encounters unrelated preexisting membership state for the company:

```text
fail closed
no adoption/overwrite
```

### 22.6 Transaction exception

Any insert/update/audit/terminal-state failure rolls back the entire completion.

### 22.7 Ambiguous HTTP/database delivery failure

The client must treat the result as unknown, not failed. Retry with the same operation ID. The terminal intent row is the reconciliation authority.

---

## 23. Migration strategy

TASK-019 should be implemented by one forward-only migration whose semantic suffix is:

```text
task_019_first_admin_profile_completion_onboarding_completion_foundation.sql
```

The timestamp prefix must be generated at implementation time and must sort after the current latest migration. Do not rewrite prior migrations.

Migration responsibilities, in order:

1. add `platform_users` profile columns;
2. add profile-state check constraint;
3. add terminal-completion columns to `first_admin_onboarding_intents`;
4. add completion FKs/unique/check constraints;
5. add comments;
6. create private current-state resolver;
7. create public current-state resolver wrapper;
8. create private completion mutation;
9. create public completion wrapper;
10. apply ownership;
11. revoke broad/default execution;
12. grant only the required authenticated execution;
13. preserve RLS enabled state and existing policies.

No backfill of names is authorized.

No data migration may mark an existing intent completed by inference.

---

## 24. Database implementation requirements

The private mutation must explicitly validate all of the following before the first successful durable write:

- `auth.uid()` non-null;
- exactly one correlated intent;
- consumed and non-revoked initial-session grant;
- bridge and grant Auth user equal current subject;
- bridge email equals intent target email;
- intent row lock acquired;
- correlation still valid after lock;
- same/different operation terminal behavior;
- input names valid after trim;
- company exists and is locked;
- historical actor row exists by FK/correlation;
- current application identity either absent or physically compatible;
- target application identity is not SUPER_ADMIN;
- target PlatformUser has no membership before initial creation;
- target company has no conflicting initial membership state;
- fixed role is `COMPANY_ADMIN`;
- fixed `is_enabled = true`;
- caller supplied no authority fields because the signature contains none.

Trusted timestamps must use one database time value for the logical completion where practical so `profile_completed_at`, `completed_at` and `AuditEvent.occurred_at` represent the same transaction event consistently. Exact equality is preferred when generated from a single `clock_timestamp()` variable passed into explicit audit insert rather than relying on independent defaults.

---

## 25. Security and threat model

### 25.1 Threat: caller chooses tenant

Impossible by function signature. Tenant comes from locked intent.

### 25.2 Threat: caller chooses role

Impossible by function signature. Role literal is fixed `COMPANY_ADMIN`.

### 25.3 Threat: caller chooses actor

Impossible by function signature. Actor comes from `initiated_by_platform_user_id`.

### 25.4 Threat: caller chooses target identity

Impossible by function signature. Current Auth subject and durable handoff bind the identity.

### 25.5 Threat: authenticated unrelated user calls the RPC

Exact-one authoritative correlation fails; no mutation.

### 25.6 Threat: first-admin session tries another tenant

There is no tenant input. Cross-tenant selection is impossible through the completion contract.

### 25.7 Threat: replay with fresh operation ID

Terminal intent denies it.

### 25.8 Threat: replay with same operation ID

Returns the committed result without duplicate mutation/audit.

### 25.9 Threat: concurrent submissions

Intent row lock serializes one authoritative aggregate.

### 25.10 Threat: SECURITY DEFINER escalation

Mitigations:

- narrow private function;
- empty search path;
- schema-qualified SQL;
- no dynamic SQL;
- no generic target parameters;
- authenticated-only execution chain;
- current subject derived inside DB;
- no table write grants to caller.

---

## 26. Required implementation paths

Expected bounded path set, subject to spec review but not implementation expansion:

### New

```text
supabase/migrations/<timestamp>_task_019_first_admin_profile_completion_onboarding_completion_foundation.sql

src/modules/identity-authorization/application/first-admin-profile-completion.ts
src/modules/identity-authorization/application/first-admin-profile-completion-service.ts
src/modules/identity-authorization/infrastructure/supabase/first-admin-profile-completion-source.ts

app/api/first-admin/profile-completion/route.ts
app/first-admin-profile-form.tsx
app/onboarding-complete/page.tsx

supabase/tests/database/task_019_first_admin_profile_completion_onboarding_completion_foundation.test.sql
supabase/tests/database/task_019_first_admin_profile_completion_concurrency.test.ps1

tests/task-019-first-admin-profile-completion.test.ts
tests/task-019-first-admin-ui-integration.test.ts
```

### Modified

```text
src/modules/identity-authorization/server.ts
app/pending-profile/page.tsx
```

A change outside this bounded set requires explicit justification during implementation planning and Revisor Central approval before mutation.

No modification to TASK-009..TASK-018 migrations is permitted.

---

## 27. Implementation decomposition for Codex

Implementation is NOT authorized by this specification. If later authorized, execute in small gated work items.

### Work Item A — Database schema and privileged completion boundary

**Objective**

Implement TASK-019 schema extensions, current-state resolver and atomic completion RPC pair.

**Context**

Consumes TASK-009/010/013/014/015/017/018, CORR-021/032, ADR-0002/0003/0019/0020 and CORR-034.

**Scope**

- one new migration;
- profile columns/check;
- terminal intent columns/FKs/unique/check;
- state resolver pair;
- completion function pair;
- exact grants/revokes/comments.

**Out of scope**

TypeScript/UI/tests outside migration-level static and DB tests.

**Expected changes**

- migration file;
- database static test additions/new TASK-019 database test.

**Security/RLS**

No new broad table policy. No direct authenticated writes. CORR-021 pattern mandatory.

**Acceptance**

Database ACs in §30 pass.

**Tests**

Static migration checks plus local DB behavior tests.

**STOP/RETURN**

Stop if a new generic privilege, policy, service-role writer or ADR-level decision appears necessary.

### Work Item B — Database idempotency/concurrency regression

**Objective**

Prove atomicity, same-operation reconciliation, different-operation denial and concurrent single-winner behavior.

**Scope**

- TASK-019 SQL tests;
- TASK-019 PowerShell concurrency harness using existing project pattern;
- cross-task regression covering TASK-017 same-establishment-operation reconciliation concurrent with TASK-019 completion.

**Out of scope**

UI/application code.

**Security/RLS**

Tests must run under realistic authenticated contexts where applicable and assert denied cross-subject/cross-tenant attempts.

**Acceptance**

No PostgreSQL deadlock, no duplicate PlatformUser, exactly one resulting membership, exactly one `USER_CREATED`, at most one authoritative completion, and coherent terminal intent state.

**STOP/RETURN**

Stop if implementation requires global locks or weakening RLS.

### Work Item C — Application and authenticated Supabase source

**Objective**

Expose strict TypeScript service/source boundaries for `resolveState()` and `complete()`.

**Scope**

- new application types/service/source;
- `server.ts` exports;
- TypeScript unit/static tests.

**Out of scope**

UI route/pages.

**Security/RLS**

Authenticated publishable-key server client only. No service-role/secret-key completion path.

**Acceptance**

Strict parser; no caller authority fields; bounded errors.

**STOP/RETURN**

Stop if Auth Admin or service-role becomes necessary for application-table completion.

### Work Item D — HTTP completion route

**Objective**

Implement same-origin, JSON-only bounded submit API.

**Scope**

`app/api/first-admin/profile-completion/route.ts` and route tests.

**Out of scope**

Final page composition.

**Security/RLS**

Session cookies/current Auth subject only. No authority from body.

**Acceptance**

Exact key validation, private/no-store responses, bounded outcomes.

**STOP/RETURN**

Stop if route requires intent/tenant/role in request body.

### Work Item E — `/pending-profile` and `/onboarding-complete`

**Objective**

Complete the minimum UI flow using authoritative state.

**Scope**

- pending-profile state gate;
- client form;
- operation-ID retry behavior;
- onboarding-complete state gate/shell;
- UI integration tests.

**Out of scope**

Dashboard or other application pages.

**Security/RLS**

Pathname never grants authority; page state comes from authenticated state resolver.

**Acceptance**

UI ACs and route-state regressions pass.

**STOP/RETURN**

Stop if UI begins deriving tenant/role/completion from client state.

### Work Item F — Full regression and evidence

**Objective**

Run TASK-019 tests plus existing TASK-009..018/CORR-021/CORR-032 regressions required by this specification.

**Scope**

Test execution and evidence only unless a separate correction is authorized.

**Out of scope**

Unapproved fixes.

**STOP/RETURN**

Any regression returns to Revisor Central; do not silently repair unrelated prior foundations.

---

## 28. Test specification

### 28.1 Static migration/schema tests

Must prove:

- new columns exact names/types/nullability;
- coupled profile check exists;
- completion columns exact names/types;
- terminal check exists;
- FKs/unique exist;
- RLS remains enabled;
- no broad INSERT/UPDATE grants added;
- public wrappers are `SECURITY INVOKER`;
- internal functions are `SECURITY DEFINER`;
- empty `search_path`;
- exact revoke/grant posture;
- no service-role completion API;
- no generic user/membership writer.

### 28.2 Database behavior tests

Must cover at least:

1. unauthenticated completion denied;
2. unrelated authenticated user denied;
3. malformed/null operation ID denied;
4. empty first name denied;
5. whitespace-only first name denied;
6. empty last name denied;
7. whitespace-only last name denied;
8. names persisted trimmed;
9. no-app-identity creates one PlatformUser;
10. creates one Auth-subject mapping;
11. creates one enabled COMPANY_ADMIN membership;
12. uses intent tenant, not caller input;
13. creates exactly one `USER_CREATED`;
14. audit actor equals historical initiating SUPER_ADMIN;
15. audit subject equals resulting PlatformUser;
16. audit tenant equals intent tenant;
17. terminal intent IDs/timestamp populated;
18. profile timestamp populated;
19. same operation retry returns `ALREADY_COMPLETED`;
20. same operation retry creates no additional audit;
21. same operation retry creates no additional membership;
22. different operation after completion denied;
23. compatible existing PlatformUser reused;
24. compatible existing PlatformUser gets profile fields;
25. no second PlatformUser on compatible reconciliation;
26. existing SUPER_ADMIN target fails closed;
27. existing membership target fails closed;
28. partial/completed pre-terminal profile target fails closed;
29. cross-subject attempt fails closed;
30. broken bridge/grant correlation fails closed;
31. revoked grant fails closed;
32. unconsumed grant fails closed;
33. already consumed valid grant remains usable after original expiry when current Auth session/correlation is valid;
34. tenant with conflicting preexisting membership fails closed;
35. forced failure before audit rolls back identity/profile/membership;
36. forced failure at audit/terminal phase rolls back prior writes;
37. terminal completion cannot exist without USER_CREATED under normal operation;
38. `resolve_current_first_admin_onboarding_state()` returns PENDING for valid pre-completion session;
39. resolver returns COMPLETED after commit;
40. resolver returns UNAVAILABLE to unrelated session.

### 28.3 Concurrency tests

At least:

- two same-operation concurrent calls → one `COMPLETED`, one `ALREADY_COMPLETED` after reconciliation;
- two different-operation concurrent calls → one `COMPLETED`, one denied terminal replay;
- TASK-017 same-establishment-operation reconciliation concurrent with TASK-019 completion → no PostgreSQL deadlock, at most one authoritative completion, exactly one resulting membership, exactly one `USER_CREATED`, and coherent terminal intent state;
- final counts exactly one PlatformUser mapping/result, one membership, one `USER_CREATED`, one terminal intent;
- no global lock behavior required;
- unrelated tenant completion is not blocked by a platform-global mutex introduced by TASK-019.

### 28.4 Application/service tests

Must prove:

- strict UUID validation;
- exact result parsing;
- unknown DB outcome fails closed;
- no tenant/role/intent accepted in application input;
- source invokes only named purpose-specific RPCs;
- source uses authenticated server client;
- no private/service-role config import in completion source;
- transport failure becomes retryable/unknown rather than false denial/success.

### 28.5 HTTP route tests

Must prove:

- wrong origin denied;
- wrong content type denied;
- extra JSON key denied;
- missing key denied;
- malformed operation ID denied;
- no tenant/role/intent key accepted;
- success maps to bounded 200;
- same-operation reconciliation maps to success-equivalent 200;
- retryable failure maps 503;
- private/no-store response headers present;
- raw DB error not exposed.

### 28.6 UI tests

Must prove:

- PENDING state renders first and last name only;
- form does not render tenant selector;
- form does not render role selector;
- form does not render editable email;
- client generates operation ID;
- ambiguous retry preserves operation ID;
- success navigates `/onboarding-complete`;
- completed user visiting `/pending-profile` redirects to complete shell;
- pending user visiting `/onboarding-complete` redirects to pending form;
- unavailable session does not receive completion claims;
- shell contains no dashboard/full-authorization claim.

### 28.7 Regression suite

At minimum preserve passing behavior of:

- TASK-009 identity/tenant foundation;
- TASK-010 AuditEvent foundation;
- TASK-011 SSR Auth lifecycle;
- TASK-012 authoritative online authorization;
- TASK-013 verification/session foundation;
- TASK-014 global authorization;
- TASK-015 membership lifecycle + concurrency;
- TASK-017 onboarding intent/handoff + concurrency;
- TASK-018 handoff/auth identity/session establishment;
- CORR-021 privileged-boundary hardening;
- CORR-032 Auth hook correction;
- current Supabase config/factory tests.

---

## 29. Acceptance Criteria

### Identity / status

**AC-019-001.** TASK-019 remains Phase 2 work.

**AC-019-002.** TASK-019 implementation remains unauthorized until a later explicit Gate.

**AC-019-003.** TASK-019 does not close Phase 2.

**AC-019-004.** TASK-019 does not start Phase 3.

### Functional boundary

**AC-019-005.** Functional start requires an authenticated first-admin session produced by the approved upstream flow.

**AC-019-006.** `/pending-profile` is not tenant authority.

**AC-019-007.** Functional end requires profile, identity, membership, audit and terminal intent evidence committed.

**AC-019-008.** Tenant authority becomes observable only after commit.

### Profile model

**AC-019-009.** `platform_users.first_name` is added.

**AC-019-010.** `platform_users.last_name` is added.

**AC-019-011.** `platform_users.profile_completed_at` is added.

**AC-019-012.** No new `UserProfile` entity is created.

**AC-019-013.** Existing users require no invented profile backfill.

**AC-019-014.** Partial profile state is prohibited.

**AC-019-015.** Completed profile requires trimmed non-empty first name.

**AC-019-016.** Completed profile requires trimmed non-empty last name.

**AC-019-017.** `profile_completed_at` is system-owned.

**AC-019-018.** TASK-019 introduces no third editable profile field.

### Intent terminal state

**AC-019-019.** Intent stores completion operation ID.

**AC-019-020.** Intent stores completed PlatformUser ID.

**AC-019-021.** Intent stores completed CompanyMembership ID.

**AC-019-022.** Intent stores completed timestamp.

**AC-019-023.** Terminal state is all-null or all-present.

**AC-019-024.** Handoff-ready alone remains non-terminal.

**AC-019-025.** One completion operation ID cannot complete multiple intents.

### Authority derivation

**AC-019-026.** Mutation derives current Auth subject using `auth.uid()`.

**AC-019-027.** Mutation accepts no intent ID.

**AC-019-028.** Mutation accepts no tenant/company ID.

**AC-019-029.** Mutation accepts no role.

**AC-019-030.** Mutation accepts no PlatformUser ID.

**AC-019-031.** Mutation accepts no membership ID.

**AC-019-032.** Mutation accepts no target email.

**AC-019-033.** Mutation accepts no actor ID.

**AC-019-034.** Tenant derives from `FirstAdminOnboardingIntent`.

**AC-019-035.** Actor derives from `initiated_by_platform_user_id`.

**AC-019-036.** Role is fixed to `COMPANY_ADMIN`.

**AC-019-037.** Enabled state is fixed true.

**AC-019-038.** Current subject must correlate through consumed grant and bound Auth bridge.

**AC-019-039.** Exact-zero correlation fails closed.

**AC-019-040.** Ambiguous multi-intent current correlation fails closed.

### PlatformUser create/reconcile

**AC-019-041.** No application identity creates one PlatformUser.

**AC-019-042.** New PlatformUser is not SUPER_ADMIN.

**AC-019-043.** New current Auth-subject mapping is created only for current subject.

**AC-019-044.** Compatible existing PlatformUser is reused.

**AC-019-045.** Compatible existing PlatformUser must not be SUPER_ADMIN.

**AC-019-046.** Compatible existing PlatformUser must have no membership.

**AC-019-047.** Compatible existing PlatformUser must be profile-incomplete before first completion.

**AC-019-048.** Existing SUPER_ADMIN target fails closed.

**AC-019-049.** Existing membership target fails closed before terminal reconciliation.

**AC-019-050.** Pre-terminal completed/partial profile state fails closed.

**AC-019-051.** TASK-019 introduces no generic identity linking.

### Membership

**AC-019-052.** Pre-profile first-admin membership remains absent.

**AC-019-053.** Completion creates one membership.

**AC-019-054.** Membership uses resulting PlatformUser.

**AC-019-055.** Membership tenant is the intent tenant.

**AC-019-056.** Membership role is `COMPANY_ADMIN`.

**AC-019-057.** Membership is enabled.

**AC-019-058.** Tenant company row is locked before the correlated FirstAdminOnboardingIntent row as the tenant-local serialization boundary, preserving the TASK-017 `MaintenanceCompany → FirstAdminOnboardingIntent` lock order.

**AC-019-059.** Conflicting existing tenant membership state fails closed for this initial path.

**AC-019-060.** `apply_company_membership_lifecycle` is not expanded into a creation API.

### Audit

**AC-019-061.** `USER_CREATED` remains the action.

**AC-019-062.** Successful logical completion produces exactly one `USER_CREATED`.

**AC-019-063.** Audit event is in the same transaction.

**AC-019-064.** Audit tenant comes from intent.

**AC-019-065.** Audit actor is historical initiating SUPER_ADMIN PlatformUser.

**AC-019-066.** Audit subject is resulting first-admin PlatformUser.

**AC-019-067.** `actor_kind = PLATFORM_USER`.

**AC-019-068.** `scope_kind = USER`.

**AC-019-069.** USER_CREATED role snapshots remain null.

**AC-019-070.** Failure/denial creates no USER_CREATED.

**AC-019-071.** Same-operation reconciliation creates no duplicate USER_CREATED.

### Transactionality

**AC-019-072.** PlatformUser/profile mutation is transactional with membership.

**AC-019-073.** Auth-subject mapping creation, when needed, is in the same transaction.

**AC-019-074.** Membership is transactional with audit.

**AC-019-075.** Audit is transactional with terminal intent evidence.

**AC-019-076.** No durable enabled first-admin membership exists from a failed completion.

**AC-019-077.** No durable terminal completion exists without the required audit in the successful operation.

**AC-019-078.** No application-side compensating saga is required.

### Idempotency/concurrency

**AC-019-079.** Same operation ID reconciles a committed result.

**AC-019-080.** Same operation ID performs no duplicate writes after terminal commit.

**AC-019-081.** Different operation ID cannot reopen a terminal intent.

**AC-019-082.** The `MaintenanceCompany → FirstAdminOnboardingIntent` lock order serializes concurrent completion of one intent without inverting the existing TASK-017 reconciliation lock order; cross-task concurrency must complete without PostgreSQL deadlock.

**AC-019-083.** Concurrent same-operation calls yield one logical completion.

**AC-019-084.** Concurrent different-operation calls yield at most one winner.

**AC-019-085.** No global platform lock is introduced.

**AC-019-086.** Ambiguous timeout is reconciled by retrying the same operation ID.

### Privileges/RLS

**AC-019-087.** Public mutation is `SECURITY INVOKER`.

**AC-019-088.** Internal mutation is `SECURITY DEFINER`.

**AC-019-089.** Public state resolver is `SECURITY INVOKER`.

**AC-019-090.** Internal state resolver is `SECURITY DEFINER`.

**AC-019-091.** All new DB functions use empty `search_path`.

**AC-019-092.** All privileged references are schema-qualified.

**AC-019-093.** `PUBLIC` cannot execute new operations.

**AC-019-094.** `anon` cannot execute new operations.

**AC-019-095.** Authenticated may execute only the narrow purpose-specific entrypoints/chains.

**AC-019-096.** No generic table INSERT/UPDATE grant is added to authenticated.

**AC-019-097.** Existing tenant RLS remains enabled.

**AC-019-098.** No ordinary tenant RLS bypass is granted to SUPER_ADMIN.

**AC-019-099.** No generic service-role completion writer is introduced.

**AC-019-100.** No new broad ordinary table RLS policy is required.

### State resolver/UI routing

**AC-019-101.** Current-state resolver exposes only bounded state/timestamp.

**AC-019-102.** Resolver returns `PENDING_PROFILE` only for an authoritative pending current flow.

**AC-019-103.** Resolver returns `COMPLETED` only for terminal correlated flow.

**AC-019-104.** Resolver returns `UNAVAILABLE` when authority cannot be established.

**AC-019-105.** `/pending-profile` renders the form only for pending authoritative state.

**AC-019-106.** Completed user visiting `/pending-profile` redirects to `/onboarding-complete`.

**AC-019-107.** `/onboarding-complete` renders only for completed authoritative state.

**AC-019-108.** Pending user visiting `/onboarding-complete` redirects to `/pending-profile`.

**AC-019-109.** Unavailable state does not receive completion claims.

**AC-019-110.** Pathname alone never establishes authority.

### HTTP/application

**AC-019-111.** Request body has exactly firstName, lastName, operationId.

**AC-019-112.** Same-origin check is enforced.

**AC-019-113.** JSON content type is enforced.

**AC-019-114.** Extra body authority fields are rejected by exact-key parsing.

**AC-019-115.** API returns private/no-store responses.

**AC-019-116.** Raw database errors are not exposed.

**AC-019-117.** Application source uses authenticated server session, not service-role secret.

**AC-019-118.** Strict TypeScript result parsing fails closed on unknown values.

### Client retry/UI

**AC-019-119.** Form renders first and last name only as editable profile fields.

**AC-019-120.** Form has no tenant selector.

**AC-019-121.** Form has no role selector.

**AC-019-122.** Email is not editable.

**AC-019-123.** One logical submit generates one operation ID.

**AC-019-124.** Ambiguous/retryable retry preserves operation ID.

**AC-019-125.** Success navigates to `/onboarding-complete`.

**AC-019-126.** UI never claims completion before authoritative success/reconciliation.

**AC-019-127.** Complete shell is minimal.

**AC-019-128.** Complete shell does not claim dashboard/full application authorization.

### Offline

**AC-019-129.** Completion is online-only.

**AC-019-130.** No IndexedDB completion authority is introduced.

**AC-019-131.** No Dexie completion authority is introduced.

**AC-019-132.** No privileged completion outbox is introduced.

### Migration/regression

**AC-019-133.** Existing migrations are not rewritten.

**AC-019-134.** TASK-019 uses one new forward-only migration.

**AC-019-135.** No name backfill is inferred for existing PlatformUsers.

**AC-019-136.** No existing intent is marked completed by migration inference.

**AC-019-137.** TASK-009 regression remains passing.

**AC-019-138.** TASK-010 regression remains passing.

**AC-019-139.** TASK-011/012 regression remains passing.

**AC-019-140.** TASK-013/CORR-032 regression remains passing.

**AC-019-141.** TASK-014 regression remains passing.

**AC-019-142.** TASK-015 regression remains passing.

**AC-019-143.** TASK-017 regression remains passing.

**AC-019-144.** TASK-018 regression remains passing.

**AC-019-145.** CORR-021 privileged-boundary regression remains passing.

### Governance

**AC-019-146.** New ADR remains not required under this specification.

**AC-019-147.** If implementation needs a material new architectural decision, work stops for an ADR Gate.

**AC-019-148.** Implementation path expansion requires Revisor Central approval.

**AC-019-149.** Specification approval does not authorize implementation.

**AC-019-150.** TASK-019 closure, Phase 2 closure and Phase 3 start remain separate future Gates.

---

## 30. Definition of Done

TASK-019 implementation may be considered technically complete only when all of the following are evidenced and later approved.

**DoD-019-001.** Canonical TASK-019 specification has completed all governance Gates required before implementation.

**DoD-019-002.** Exactly one approved TASK-019 migration exists with monotonic timestamp.

**DoD-019-003.** `platform_users` contains the three approved profile columns.

**DoD-019-004.** Profile coupled-state constraint is present and tested.

**DoD-019-005.** `first_admin_onboarding_intents` contains the four approved completion fields.

**DoD-019-006.** Terminal coupled-state constraint is present and tested.

**DoD-019-007.** Completion operation uniqueness is present and tested.

**DoD-019-008.** Completion FKs are present and tested.

**DoD-019-009.** Public completion wrapper is `SECURITY INVOKER`.

**DoD-019-010.** Private completion function is purpose-specific `SECURITY DEFINER`.

**DoD-019-011.** Current-state resolver pair is implemented with bounded output.

**DoD-019-012.** All new functions have safe empty search path and qualified references.

**DoD-019-013.** PUBLIC/anon execution is denied.

**DoD-019-014.** No authenticated generic table-write grants exist.

**DoD-019-015.** No new broad RLS policy is introduced.

**DoD-019-016.** Current Auth subject is the only subject authority.

**DoD-019-017.** Caller cannot choose intent/tenant/role/user/membership/email/actor authority.

**DoD-019-018.** No-application-identity create path passes.

**DoD-019-019.** Compatible-existing-PlatformUser reconciliation path passes.

**DoD-019-020.** Incompatible identity paths fail closed.

**DoD-019-021.** Initial enabled COMPANY_ADMIN membership is created only on successful completion.

**DoD-019-022.** `USER_CREATED` is exactly once with correct provenance.

**DoD-019-023.** Terminal intent evidence is persisted in the same transaction.

**DoD-019-024.** Forced transaction failure proves rollback of all completion effects.

**DoD-019-025.** Same-operation retry reconciles without duplicate writes.

**DoD-019-026.** Different-operation replay is denied.

**DoD-019-027.** Concurrent same/different operation tests prove one authoritative winner.

**DoD-019-028.** No global lock is used.

**DoD-019-029.** New TypeScript application/source boundaries are strict-mode compatible.

**DoD-019-030.** Completion source uses authenticated server Supabase boundary.

**DoD-019-031.** No service-role secret is used by the completion application path.

**DoD-019-032.** Profile completion API route enforces exact same-origin JSON contract.

**DoD-019-033.** `/pending-profile` is state-gated and renders the minimal form.

**DoD-019-034.** Operation ID retry semantics are implemented in the form.

**DoD-019-035.** `/onboarding-complete` exists and is state-gated.

**DoD-019-036.** Complete shell makes no out-of-scope authorization claim.

**DoD-019-037.** Offline privileged completion remains absent.

**DoD-019-038.** TASK-019 database behavior suite passes.

**DoD-019-039.** TASK-019 concurrency suite passes.

**DoD-019-040.** TASK-019 application/unit suite passes.

**DoD-019-041.** TASK-019 UI integration suite passes.

**DoD-019-042.** TASK-009 regression passes.

**DoD-019-043.** TASK-010 regression passes.

**DoD-019-044.** TASK-011/012 regression passes.

**DoD-019-045.** TASK-013/CORR-032 regression passes.

**DoD-019-046.** TASK-014 regression passes.

**DoD-019-047.** TASK-015 regression and concurrency tests pass.

**DoD-019-048.** TASK-017 regression and concurrency tests pass.

**DoD-019-049.** TASK-018 regression passes.

**DoD-019-050.** CORR-021 privileged-boundary invariants remain satisfied.

**DoD-019-051.** `npm`/TypeScript/project checks required by repository conventions pass.

**DoD-019-052.** Final implementation review confirms no unexpected changed paths.

**DoD-019-053.** Final implementation review confirms no RLS weakening or tenant leakage.

**DoD-019-054.** Final implementation review confirms no new ADR was silently introduced.

**DoD-019-055.** Staging/commit/push each pass separate human authorization Gates.

**DoD-019-056.** Remote main is verified only after explicit push authorization.

**DoD-019-057.** Final human closure is a separate Gate.

**DoD-019-058.** TASK-019 closure does not automatically close Phase 2.

**DoD-019-059.** TASK-019 closure does not automatically define the Phase 2 Exit Gate.

**DoD-019-060.** TASK-019 closure does not automatically start Phase 3.

---

## 31. Implementation review evidence requirements

When implementation is later authorized, Codex evidence must include at minimum:

1. exact baseline branch/HEAD/origin/remote/divergence;
2. clean preflight and no ongoing Git operations;
3. exact changed paths;
4. migration SHA-256 and physical line-ending metrics;
5. complete migration diff;
6. complete diffs for new/modified TypeScript and UI files;
7. function signatures, security mode, owners, grants and revokes;
8. policy inventory before/after;
9. schema constraint inventory;
10. DB test output;
11. concurrency test output;
12. TypeScript/unit/UI test output;
13. prior-foundation regression output;
14. final `git diff --check`;
15. final worktree state;
16. explicit statement that no Supabase Cloud mutation occurred unless separately authorized.

A summary without the required physical diffs/evidence is insufficient for implementation review.

---

## 32. Governance Gates after canonicalization

Current state after this canonical artifact is generated:

```text
TASK-019 SPEC REVIEW =
APPROVED

TASK-019 HUMAN SPEC APPROVAL =
APPROVED

TASK-019 specification =
HUMAN APPROVED

TASK-019 approved artifact =
GENERATED

TASK-019 APPROVED ARTIFACT REVIEW =
APPROVED

TASK-019 canonicalized =
YES

TASK-019 repository incorporation =
NO

TASK-019 implementation authorization =
NO

TASK-019 implementation =
NOT PERFORMED
```

Required future sequence remains separate:

```text
TASK-019 CANONICALIZATION REVIEW
→ REPOSITORY INCORPORATION AUTHORIZATION
→ REPOSITORY INCORPORATION
→ REPOSITORY INCORPORATION REVIEW
→ IMPLEMENTATION AUTHORIZATION
→ IMPLEMENTATION
→ IMPLEMENTATION REVIEW
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

No Gate implies the next.

---

## 33. Explicit architecture conclusion

Based on the recovered 106-source corpus and the approved product decisions:

```text
TASK-019 ARCHITECTURE FINDING =
NO NEW ADR REQUIREMENT DISCOVERED

new ADR required =
NO
```

Rationale:

- ADR-0001 already establishes modular Next.js boundaries;
- ADR-0002 establishes tenant isolation;
- ADR-0003 establishes authorization/client-scope principles;
- ADR-0019 establishes verification/Auth-session boundary;
- ADR-0020 establishes authoritative first-admin onboarding intent binding;
- CORR-021 establishes the accepted exposed `SECURITY INVOKER` → narrow internal `SECURITY DEFINER` pattern;
- CORR-034 resolves the previously open product/domain choices for profile completion.

This conclusion is valid only for the bounded TASK-019 design in this specification.

---

## 34. Final specification state

```text
F-019-001 =
RESOLVED

TASK-019 SPECIFICATION GENERATION AUTHORIZATION =
APPROVED

TASK-019 SPEC REVIEW =
APPROVED

TASK-019 HUMAN SPEC APPROVAL =
APPROVED

TASK-019 specification =
HUMAN APPROVED

TASK-019 approved artifact =
GENERATED

TASK-019 APPROVED ARTIFACT REVIEW =
APPROVED

TASK-019 canonicalized =
YES

TASK-019 repository incorporation =
NO

TASK-019 implementation authorization =
NO

TASK-019 implementation =
NOT PERFORMED

repository mutation =
NO

Supabase mutation =
NO

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT DEFINED / NOT SATISFIED

Phase 3 =
NOT STARTED
```

```text
STOP
RETURN TO HUMAN
```
