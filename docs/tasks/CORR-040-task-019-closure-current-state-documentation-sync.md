# CORR-040 — TASK-019 Closure Current-State Documentation Sync

## 1. Identification and governance status

```text
CORR ID =
CORR-040

title =
CORR-040 — TASK-019 Closure Current-State Documentation Sync

class =
DOCUMENTATION CORRECTION

CORR-040 DETERMINATION =
APPROVED

CORR-040 SPECIFICATION GENERATION =
PASS

CORR-040 SPEC REVIEW =
APPROVED

F-040-SPEC-001 =
RESOLVED

F-040-ART-001 =
RESOLVED

open CORR-040 specification findings =
0

CORR-040 HUMAN SPEC APPROVAL =
APPROVED

CORR-040 specification =
HUMAN APPROVED

CORR-040 approved artifact =
GENERATED / REVIEW APPROVED

CORR-040 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-040 CANONICALIZATION AUTHORIZATION =
APPROVED

CORR-040 CANONICALIZATION =
PASS

CORR-040 canonicalized =
YES

canonical artifact =
GENERATED

CORR-040 CANONICALIZATION REVIEW =
PENDING

repository incorporation =
NOT AUTHORIZED

implementation authorized =
NO

Codex authorized =
NO

repository mutation authorized by this artifact =
NO

Supabase Local mutation authorized =
NO

Supabase Cloud mutation authorized =
NO

staging / commit / push =
NO / NO / NO
```

This artifact specifies only a bounded documentation synchronization after the already-approved closure of TASK-019. It does not approve itself, implement CORR-040, mutate the repository, determine TASK-020, close Phase 2, define the Phase 2 Exit Gate, or start Phase 3.

---

## 2. Objective

The unique objective of CORR-040 is to synchronize the active current-state snapshot in:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

so that its final active state reflects the already-closed TASK-019 first-admin flow without rewriting valid historical snapshots and without extending the meaning of TASK-019 into ordinary later-user onboarding or Client-dependent authorization.

Required distinction:

```text
state synchronization
!=
new capability determination
```

CORR-040 records state that already exists. It does not create new product, domain, architecture, security, RLS, multitenancy, Auth, offline, or phase-boundary semantics.

---

## 3. Authoritative source recovery state

### 3.1 Resumption state

```text
CORR-040 SOURCE A/B PHYSICAL RECOVERY =
PASS

CORR-040 SOURCE A/B PHYSICAL RECOVERY REVIEW =
APPROVED

TASK-019 CLOSURE EVIDENCE RECOVERY =
PASS

CORR-040 required source recovery =
COMPLETE

CORR-040 SPECIFICATION RESUMPTION BLOCKER =
RESOLVED
```

No CORR-040 determination is repeated or replaced.

### 3.2 SOURCE A — TASK-017 canonical

```text
path =
docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md

SHA-256 =
aa236a05162e44e083f4e75c1dc86602d55a91f454134e023b6306640370653d

bytes =
106238

LF =
2944

CRLF =
0

bare CR =
0

trailing-whitespace lines =
0

final newline =
YES

physical identity =
VERIFIED
```

TASK-017 establishes the authoritative first-admin intent/challenge/proof-consume/SessionGrant/handoff foundation and explicitly stops before profile completion, PlatformUser completion, initial CompanyMembership establishment, enabled tenant authority, and first-admin onboarding completion.

### 3.3 SOURCE B — current target

```text
path =
docs/product/11-phase-1-scope-entry-gate.md

SHA-256 =
2c57c630b0dcff95bb896a02aca97d4e464f2dfcca69b2291c55cace6201df9d

bytes =
96022

LF =
1568

CRLF =
0

bare CR =
0

trailing-whitespace lines =
9

final newline =
YES

physical identity =
VERIFIED
```

The recovered target is the authoritative physical baseline for the future CORR-040 documentation mutation. A future implementation must not normalize unrelated whitespace or line endings while applying this bounded correction.

### 3.4 SOURCE C — TASK-019 human closure evidence

```text
source type =
AUTHORITATIVE PRIOR REVISOR CENTRAL CHAT GATE
/ PROJECT CONVERSATION HISTORY

TASK-019 HUMAN CLOSURE =
APPROVED

DoD-019-057 =
PASS — HUMAN CLOSURE APPROVED

DoD-019-001..060 =
PASS / SATISFIED AS APPLICABLE

TASK-019 =
CLOSED

closure is newly approved =
NO

closure is recovered prior evidence =
YES

physical standalone closure artifact =
NO

authoritative chat Gate evidence =
RECOVERED
```

Implementation commit recovered with that state:

```text
9ddaffaa4c89041640547fdef951b4e2d018dbc5

feat(auth): implement first-admin profile completion
```

This recovery does not recreate a historical closure file and does not approve TASK-019 again.

---

## 4. Minimum source corpus consumed

CORR-040 consumes, at minimum:

```text
docs/product/11-phase-1-scope-entry-gate.md

docs/tasks/TASK-017-authoritative-first-admin-onboarding-intent-verification-handoff-foundation.md

docs/tasks/TASK-018-authoritative-first-admin-auth-identity-reconciliation-session-establishment-foundation.md

docs/tasks/TASK-019-authoritative-first-admin-profile-completion-onboarding-completion-foundation.md

docs/tasks/CORR-039-phase-2-phase-3-client-scope-boundary-documentation-sync.md

docs/product/01-product-definition.md
docs/product/02-domain-model.md
docs/product/03-permissions-rls-strategy.md

docs/architecture/adr/ADR-0002-multitenancy-tenant-isolation.md
docs/architecture/adr/ADR-0003-authorization-client-scope-support.md
```

Exact TASK-018 canonical identity consumed from the recovered physical corpus:

```text
path =
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

TASK-018 establishes/reconciles the first-admin Supabase Auth identity and establishes the initial Auth session, while explicitly leaving profile completion, initial CompanyMembership, enabled tenant authority, `USER_CREATED`, and onboarding completion to later work.

TASK-019 is the purpose-specific continuation that closes those first-admin gaps. Its approved boundary includes PlatformUser establishment/reconciliation, profile completion, one initial enabled `COMPANY_ADMIN` membership, exactly one `USER_CREATED`, terminal FirstAdminOnboardingIntent completion evidence, authoritative post-commit tenant authority, and `/onboarding-complete`.

TASK-019 explicitly excludes ordinary later-user onboarding, generic user creation, generic membership creation, `UserClientAccess`, `Client` CRUD, and `SupportAccessGrant`.

---

## 5. Source-of-truth hierarchy for CORR-040

For this correction, authority is applied in this order within each source's scope:

1. later explicit human-approved governance state, including recovered TASK-019 human closure;
2. current approved product requirements in `01-product-definition.md`;
3. current domain semantics in `02-domain-model.md`;
4. current authorization/RLS strategy in `03-permissions-rls-strategy.md`;
5. accepted ADR-0002 and ADR-0003 within their architectural boundaries;
6. approved TASK-017, TASK-018, and TASK-019 contracts for the bounded first-admin flow;
7. CORR-039 for the approved Phase 2 / Phase 3 Client boundary;
8. historical snapshots as valid historical evidence, not active-state authority after later closure.

Rule:

```text
later approved closure state
>
stale active current-state snapshot
```

but:

```text
later approved closure state
!=
permission to rewrite historical snapshots
```

---

## 6. Exact target and mutation boundary

### 6.1 Target count

```text
exact target file count =
1
```

Exact future target:

```text
docs/product/11-phase-1-scope-entry-gate.md
```

No other path may be added silently.

### 6.2 Primary active stale surface

The only authorized semantic surface for CORR-040 is:

```text
§17 — Resultado final
final active current-state snapshot
```

All TASK/CORR historical artifacts remain:

```text
READ-ONLY / PRESERVE HISTORY
```

Historical snapshots elsewhere in the target also remain historical unless a separate correction explicitly authorizes another surface.

### 6.3 No collateral formatting rewrite

A future implementation must preserve unrelated bytes as far as possible. In particular, it must not perform global Markdown normalization, global whitespace cleanup, line-ending conversion, heading refactoring, prose modernization, or unrelated status synchronization.

---

## 7. Problem statement — active stale state

The physically recovered §17 currently contains post-TASK-018 active statements that became stale after TASK-019 implementation and human closure.

Confirmed stale/current lines include:

```text
line 1535
first COMPANY_ADMIN creation: no

line 1536
PlatformUser creation for first admin: no

line 1537
initial CompanyMembership creation: no

line 1538
profile completion: no

line 1539
enabled tenant authority: no

line 1540
first-admin onboarding completed: no

line 1567
TASK-019: NOT DETERMINED / NOT AUTHORIZED
```

The surrounding active snapshot also contains valid statements that must not be incorrectly flipped merely because TASK-019 closed, including:

```text
USER_CREATED produced by TASK-017: no
USER_CREATED produced by TASK-018: no
RF-004 end-to-end: no
Subscription: no
promotional entitlement: no
PAY-OPEN-001: UNRESOLVED
PAY-OPEN-008: UNRESOLVED
Application authorization completa: no
route authorization funcional completa: no
resource authorization funcional completa: no
Client: no
UserClientAccess completo: no
SupportAccessGrant completo: no
auditoría funcional completa: no
Fase 2 completada: no
Phase 2 Exit Gate: NOT DEFINED / NOT SATISFIED
Fase 3 iniciada: no
Siguiente TASK autorizada automáticamente: no
```

The correction therefore cannot be a blind `no → yes` transformation. It must replace ambiguous broad statements with scope-qualified current-state statements where necessary.

---

## 8. Required TASK-019 current-state meaning

After future CORR-040 implementation, §17 must represent all of the following without qualification drift:

```text
TASK-019 =
CLOSED

TASK-019 HUMAN CLOSURE =
APPROVED

first-admin Auth/session flow =
IMPLEMENTED WITHIN APPROVED TASK-017/018/019 BOUNDARY

first-admin PlatformUser establishment/reconciliation =
IMPLEMENTED

first COMPANY_ADMIN profile completion =
IMPLEMENTED

first-admin onboarding completion =
IMPLEMENTED

initial enabled COMPANY_ADMIN membership establishment =
IMPLEMENTED

first-admin enabled tenant authority after authoritative completion commit =
IMPLEMENTED / OBSERVABLE

TASK-019 USER_CREATED producer =
IMPLEMENTED
```

The implementation may use wording consistent with the surrounding document, but it must preserve these exact semantic distinctions.

### 8.1 TASK ownership must remain explicit

The current-state snapshot must not reassign TASK-019 effects backward to TASK-017 or TASK-018.

Preserve:

```text
USER_CREATED produced by TASK-017 =
NO

USER_CREATED produced by TASK-018 =
NO

TASK-019 USER_CREATED producer =
IMPLEMENTED
```

Likewise:

```text
TASK-017 handoff foundation
!=
TASK-019 onboarding completion

TASK-018 Auth/session establishment
!=
TASK-019 profile/membership/onboarding completion
```

### 8.2 `USER_CREATED` meaning

TASK-019's `USER_CREATED` producer is purpose-specific to successful authoritative first-admin completion.

It does not prove:

```text
generic later-user USER_CREATED producer = IMPLEMENTED
generic user provisioning = IMPLEMENTED
generic membership creation = IMPLEMENTED
auditing as a complete product capability = IMPLEMENTED
```

---

## 9. RF-012 and RF-004 current-state distinction

`RF-012` requires the first `COMPANY_ADMIN` to enter using email + valid code and complete the profile. The closed TASK-017/018/019 chain now implements the authoritative first-admin verification/handoff, Auth/session, profile, membership, and onboarding-completion path.

Therefore §17 may no longer describe the first-admin RF-012 continuation as pending merely because TASK-019 had not yet been determined when the old snapshot was written.

Required bounded meaning:

```text
RF-012 first-admin flow =
IMPLEMENTED WITHIN TASK-017/018/019 BOUNDARY
```

This does not modify the separate delivery status:

```text
RF-004 end-to-end =
NO / PARTIAL
```

because TASK-017 deliberately did not select or implement a concrete production email-delivery provider/adapter contract end-to-end.

Consequently:

```text
RF-012 first-admin flow implemented
!=
RF-004 end-to-end complete
```

and:

```text
first-admin onboarding completion implemented
!=
full generic onboarding capability implemented
```

---

## 10. Ordinary later-user onboarding remains incomplete

TASK-019 is strictly first-admin-specific.

CORR-040 must expressly preserve:

```text
ordinary later-user onboarding =
INCOMPLETE

generic user creation =
INCOMPLETE

generic CompanyMembership creation =
INCOMPLETE

later-user email + code orchestration =
INCOMPLETE

later-user Auth/session composition =
INCOMPLETE

later-user initial role assignment =
INCOMPLETE

later-user profile completion =
INCOMPLETE

later-user USER_CREATED producer =
INCOMPLETE
```

The known physical state remains:

```text
pre-Client later-user onboarding foundation =
INCOMPLETE

reusable independent primitives =
PRESENT

ordinary later-user composition =
ABSENT
```

No sentence in the future target may imply that first-admin purpose-specific code is a generic later-user creation API.

---

## 11. CORR-039 boundary — mandatory preservation

CORR-040 consumes CORR-039 as closed and must not weaken or reinterpret its phase-boundary decision.

Preserve exactly:

```text
Client =
Phase 3

physical UserClientAccess required before Phase 2 close =
NO

physical/full SupportAccessGrant required before Phase 2 close =
NO

full Client-dependent support required before Phase 2 close =
NO

ordinary later-user onboarding remains incomplete
until RF-015 can be satisfied =
YES

pre-Client later-user onboarding foundation split =
YES

move minimal Client into Phase 2 =
NO
```

Equivalent CORR-039 semantics also remain:

```text
Phase 2 may close before Client-dependent authorization =
YES

complete SupportAccessGrant waits for Client/resources =
YES
```

CORR-040 does not itself close Phase 2.

---

## 12. RF-013..RF-017 preservation

Product requirements remain unchanged:

```text
RF-013 =
UNCHANGED

RF-014 =
UNCHANGED

RF-015 =
MANDATORY / UNCHANGED

RF-016 =
UNCHANGED

RF-017 =
UNCHANGED
```

In particular:

```text
zero client assignment satisfies RF-015 =
NO
```

The absence of physical `Client` in Phase 2 cannot be interpreted as satisfying RF-015.

A pre-Client later-user foundation may be designed in a future separately determined task, but it cannot be called complete later-user onboarding while the required client assignment cannot yet be satisfied.

CORR-040 does not determine or design that future task.

---

## 13. Domain invariants preserved

CORR-040 changes no domain meaning.

Preserve:

```text
PlatformUser
!=
CompanyMembership

CompanyMembership
→ exactly one MaintenanceCompany

UserClientAccess
→ CompanyMembership + Client

SupportAccessGrant
!=
CompanyMembership

Client
!=
tenant

MaintenanceCompany =
tenant
```

The first-admin completion implemented by TASK-019 is one purpose-specific path that establishes one PlatformUser/profile and one initial enabled `COMPANY_ADMIN` membership for the intent tenant. It is not a generic mutation surface for arbitrary users or memberships.

---

## 14. Security / RLS / multitenancy invariants preserved

Required result:

```text
architecture change =
NO

product requirement change =
NO

domain change =
NO

security change =
NO

RLS change =
NO

multitenancy change =
NO

Auth architecture change =
NO

offline change =
NO

new ADR required =
NO
```

Preserve, in particular:

```text
tenant = MaintenanceCompany

authenticated != authorized

Auth session != tenant authorization

current authoritative PostgreSQL state > stale claims

RLS = primary remote isolation boundary

SUPER_ADMIN ordinary tenant bypass = NO

ordinary generic service-role request path = NO
```

CORR-040 does not add, remove, or change any policy, grant, resolver, Auth boundary, session rule, membership rule, or same-tenant invariant.

If a future documentation implementation appears to require changing any of these semantics, the implementation must stop rather than reinterpret the canon.

---

## 15. Offline behavior

```text
offline behavior change =
NO
```

CORR-040 introduces no offline capability, IndexedDB/Dexie authority, Service Worker behavior, outbox behavior, or offline authorization rule.

The first-admin completion path remains whatever online-only contract TASK-019 already approved and implemented; CORR-040 only documents that state.

---

## 16. Historical snapshot preservation

The future implementation must distinguish:

```text
historical snapshot
!=
active current-state snapshot
```

Rules:

1. §17 is the authorized active current-state correction surface.
2. Earlier TASK/CORR documents remain byte-preserved outside their own future Gates.
3. Historical statements that were true before TASK-019 remain valid history and must not be rewritten merely to look current.
4. CORR-040 must not search-and-replace every occurrence of `TASK-019`, `profile completion`, `CompanyMembership creation`, or `onboarding completion` across the repository.
5. A historical `TASK-019 = NOT DETERMINED` statement remains historical when it belongs to a pre-determination artifact or historical snapshot.
6. Only the active §17 current-state representation is synchronized here.

---

## 17. Phase and governance state after CORR-040

The future correction must preserve:

```text
CORR-039 =
CLOSED

TASK-019 =
CLOSED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED

next TASK =
NOT DETERMINED

TASK-020 =
NOT DETERMINED
```

And preserve the non-implications:

```text
TASK-019 closure
!=
Phase 2 closure

TASK-019 closure
!=
Phase 2 Exit Gate definition

TASK-019 closure
!=
Phase 3 start

CORR-040 completion
!=
next TASK determination
```

---

## 18. Future implementation contract

This section defines the bounded future implementation of CORR-040. It does not authorize that implementation.

### 18.1 Preconditions

Before any future edit:

1. perform a fresh Git preflight;
2. verify the target path exists exactly once;
3. verify the current target physical baseline before editing;
4. confirm no unrelated Git operation is in progress;
5. confirm the intended change can be completed within §17 and one target file.

Expected pre-edit target identity for this specification baseline:

```text
SHA-256 =
2c57c630b0dcff95bb896a02aca97d4e464f2dfcca69b2291c55cace6201df9d
```

If that identity has legitimately changed before authorized implementation, do not silently apply this specification against unknown content. Return for drift review.

### 18.2 Allowed change

The future implementation may modify only the current-state statements in §17 necessary to:

- represent TASK-019 as closed;
- represent first-admin PlatformUser/profile completion as implemented;
- represent initial enabled `COMPANY_ADMIN` membership establishment as implemented;
- represent first-admin enabled tenant authority after completion as implemented/observable;
- represent first-admin onboarding completion as implemented;
- represent TASK-019 `USER_CREATED` producer as implemented;
- represent the TASK-017/018/019 first-admin Auth/session/completion chain accurately;
- remove ambiguity between first-admin completion and ordinary later-user onboarding;
- preserve RF-004's separate partial/not-end-to-end status;
- preserve CORR-039 and RF-013..RF-017 boundaries;
- preserve Phase 2 / Phase 3 governance state.

### 18.3 Explicitly forbidden change

The future implementation must not:

- modify another file;
- modify §6.1 again unless a separate Gate authorizes it;
- rewrite historical TASK/CORR artifacts;
- rewrite source code;
- write SQL or migrations;
- modify RLS;
- modify grants/revokes;
- modify Supabase configuration;
- change Auth behavior;
- change offline behavior;
- implement generic user creation;
- implement generic membership creation;
- implement later-user onboarding;
- implement `Client`;
- implement `UserClientAccess`;
- implement `SupportAccessGrant`;
- define the Phase 2 Exit Gate;
- close Phase 2;
- start Phase 3;
- determine TASK-020;
- stage, commit, or push without later explicit Gates.

---

## 19. Documentation verification strategy

Because CORR-040 is documentation-only, no application, database, or Supabase execution test is required by this specification merely to prove the text change.

A future authorized implementation must instead provide documentary/regression evidence covering at least:

1. fresh target SHA-256 and physical metrics before edit;
2. exact changed-path inventory = one path;
3. complete diff of `docs/product/11-phase-1-scope-entry-gate.md`;
4. proof that all changed hunks are confined to §17;
5. proof that TASK-019 is represented as `CLOSED`;
6. proof that first-admin profile completion, initial enabled membership, onboarding completion, and TASK-019 `USER_CREATED` are represented as implemented;
7. proof that TASK-017 and TASK-018 are not retroactively credited with TASK-019 completion effects;
8. proof that ordinary later-user onboarding remains incomplete;
9. proof that generic user/membership creation remains incomplete;
10. proof that `Client` remains Phase 3;
11. proof that physical `UserClientAccess` and full `SupportAccessGrant` remain deferred under CORR-039;
12. proof that RF-015 remains mandatory and zero client assignment does not satisfy it;
13. proof that Phase 2 remains open;
14. proof that Phase 2 Exit Gate remains not yet defined;
15. proof that Phase 3 remains not started;
16. proof that next TASK remains not determined;
17. `git diff --check = PASS`;
18. proof that no unrelated whitespace normalization occurred;
19. final target physical identity and line-ending metrics;
20. final worktree/index state and explicit no-Supabase-mutation statement.

No full application test suite is required unless the future implementation unexpectedly changes non-documentation paths, in which case CORR-040 must stop because its one-target boundary has been violated.

---

## 20. Failure / blocker model

### 20.1 Target identity drift

If the target has changed materially before authorized execution:

```text
CORR-040 IMPLEMENTATION =
STOP

BLOCKER — TARGET BASELINE DRIFT
```

Do not auto-merge or reinterpret.

### 20.2 Additional document surface required

If the required current-state correction cannot be completed within §17 of the single target:

```text
CORR-040 IMPLEMENTATION =
STOP

BLOCKER — ADDITIONAL DOCUMENT SURFACE REQUIRED
```

Report the exact additional surface and contradiction. Do not expand scope silently.

### 20.3 Additional path required

If another file must change:

```text
CORR-040 IMPLEMENTATION =
STOP

BLOCKER — ADDITIONAL DOCUMENT TARGET REQUIRED
```

### 20.4 New semantic decision required

If correcting the text requires changing product requirements, domain meaning, architecture, security, RLS, multitenancy, Auth architecture, offline behavior, or CORR-039's phase boundary:

```text
CORR-040 SPECIFICATION / IMPLEMENTATION =
BLOCKER — NEW SEMANTIC DECISION REQUIRED
```

No silent resolution is permitted.

### 20.5 Historical/current-state ambiguity

If a candidate edit would rewrite a historical snapshot merely because it contains stale-looking words:

```text
CORR-040 IMPLEMENTATION =
STOP

BLOCKER — HISTORICAL SNAPSHOT BOUNDARY VIOLATION
```

### 20.6 Phase overstatement

Any edit that implies Phase 2 closure, Phase 2 Exit Gate definition/satisfaction, Phase 3 start, or TASK-020 determination is invalid and must be rejected.

---

## 21. Acceptance Criteria

**AC-040-001.** The CORR ID is exactly `CORR-040`.

**AC-040-002.** The title is exactly `CORR-040 — TASK-019 Closure Current-State Documentation Sync`.

**AC-040-003.** The class is `DOCUMENTATION CORRECTION`.

**AC-040-004.** The specification state is `GENERATED / PENDING REVIEW`, not approved by itself.

**AC-040-005.** Exact target file count is `1`.

**AC-040-006.** The only target is `docs/product/11-phase-1-scope-entry-gate.md`.

**AC-040-007.** The primary authorized semantic surface is `§17 — Resultado final`.

**AC-040-008.** The recovered SOURCE B baseline identity is recorded as SHA-256 `2c57c630b0dcff95bb896a02aca97d4e464f2dfcca69b2291c55cace6201df9d`.

**AC-040-009.** Historical TASK/CORR artifacts remain read-only and historical snapshots are not rewritten as current state.

**AC-040-010.** TASK-019 is represented as `CLOSED`.

**AC-040-011.** TASK-019 human closure is represented as approved recovered prior evidence, not as newly approved by CORR-040.

**AC-040-012.** First-admin Auth/session flow is represented as implemented within the approved TASK-017/018/019 boundary.

**AC-040-013.** First-admin PlatformUser establishment/reconciliation is represented as implemented.

**AC-040-014.** First `COMPANY_ADMIN` profile completion is represented as implemented.

**AC-040-015.** Initial enabled `COMPANY_ADMIN` membership establishment is represented as implemented.

**AC-040-016.** First-admin enabled tenant authority after authoritative completion is represented as implemented/observable.

**AC-040-017.** First-admin onboarding completion is represented as implemented.

**AC-040-018.** TASK-019 `USER_CREATED` producer is represented as implemented.

**AC-040-019.** `USER_CREATED produced by TASK-017 = NO` remains true.

**AC-040-020.** `USER_CREATED produced by TASK-018 = NO` remains true.

**AC-040-021.** RF-012 first-admin flow is no longer represented as pending after the closed TASK-017/018/019 chain.

**AC-040-022.** `RF-004 end-to-end` remains not complete/partial and is not conflated with RF-012 completion.

**AC-040-023.** Ordinary later-user onboarding remains incomplete.

**AC-040-024.** Generic user creation remains incomplete.

**AC-040-025.** Generic CompanyMembership creation remains incomplete.

**AC-040-026.** Later-user profile completion and later-user `USER_CREATED` remain incomplete.

**AC-040-027.** Pre-Client later-user onboarding foundation remains incomplete, reusable independent primitives may be present, and ordinary later-user composition remains absent.

**AC-040-028.** `Client = Phase 3` is preserved.

**AC-040-029.** Physical `UserClientAccess` is not required before Phase 2 close and remains deferred until its Client prerequisite exists.

**AC-040-030.** Physical/full `SupportAccessGrant` and Client-dependent support are not required before Phase 2 close and remain deferred.

**AC-040-031.** `move minimal Client into Phase 2 = NO` is preserved.

**AC-040-032.** RF-013, RF-014, RF-015, RF-016, and RF-017 remain unchanged.

**AC-040-033.** RF-015 remains mandatory.

**AC-040-034.** Zero client assignment does not satisfy RF-015.

**AC-040-035.** CORR-039's boundary remains unchanged.

**AC-040-036.** Phase 2 remains `IN PROGRESS / NOT CLOSED`.

**AC-040-037.** Phase 2 Exit Gate remains `NOT YET DEFINED`.

**AC-040-038.** Phase 3 remains `NOT STARTED`.

**AC-040-039.** Next TASK remains `NOT DETERMINED`; TASK-020 is not determined.

**AC-040-040.** Architecture, product requirements, domain, security, RLS, multitenancy, Auth architecture, and offline behavior are unchanged.

**AC-040-041.** New ADR remains not required.

**AC-040-042.** CORR-040 performs no repository mutation, Supabase mutation, implementation, Codex execution, staging, commit, or push during specification generation.

**AC-040-043.** A future implementation is rejected if it needs a second target or a non-§17 semantic change.

**AC-040-044.** The next Gate after this generated specification is exclusively `CORR-040 SPEC REVIEW`.

---

## 22. Definition of Done

CORR-040 may be considered complete only after all mandatory governance Gates and all semantic preservation requirements below are satisfied through separate, explicit, reviewable steps.

Current correction state:

```text
CORR-040 SPECIFICATION GENERATION =
PASS

CORR-040 SPEC REVIEW =
APPROVED

F-040-SPEC-001 =
RESOLVED

F-040-ART-001 =
RESOLVED

open CORR-040 specification findings =
0

CORR-040 HUMAN SPEC APPROVAL =
APPROVED

CORR-040 specification =
HUMAN APPROVED

CORR-040 approved artifact =
GENERATED / REVIEW APPROVED

CORR-040 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-040 CANONICALIZATION AUTHORIZATION =
APPROVED

CORR-040 CANONICALIZATION =
PASS

CORR-040 canonicalized =
YES

canonical artifact =
GENERATED

CORR-040 CANONICALIZATION REVIEW =
PENDING

repository incorporation =
NOT AUTHORIZED

CORR-040 implementation =
NOT AUTHORIZED / NOT PERFORMED

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED

next TASK =
NOT DETERMINED

TASK-020 =
NOT DETERMINED
```

The mandatory governance lifecycle is strictly sequential:

```text
SPEC REVIEW
→ HUMAN SPEC APPROVAL
→ APPROVED ARTIFACT GENERATION
→ APPROVED ARTIFACT REVIEW
→ CANONICALIZATION AUTHORIZATION
→ CANONICALIZATION
→ CANONICALIZATION REVIEW
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

No Gate implies, authorizes, approves, satisfies, or executes the next Gate automatically.

**DoD-040-001.** `CORR-040 SPEC REVIEW = APPROVED` is obtained through a separate Revisor Central Gate after review of this corrected specification.

**DoD-040-002.** `CORR-040 HUMAN SPEC APPROVAL = APPROVED` is obtained through a separate human Gate after specification review approval; specification review does not imply human specification approval.

**DoD-040-003.** An approved CORR-040 specification artifact is generated only after human specification approval and through its own explicit artifact-generation step.

**DoD-040-004.** The generated approved artifact completes a separate `APPROVED ARTIFACT REVIEW = APPROVED` Gate before canonicalization.

**DoD-040-005.** `CORR-040 CANONICALIZATION AUTHORIZATION = SEPARATE EXPLICIT GATE`; canonicalization requires this separate explicit authorization after `CORR-040 APPROVED ARTIFACT REVIEW = APPROVED`, and approved-artifact review does not itself authorize canonicalization.

**DoD-040-006.** Canonicalization occurs only after the separate explicit `CORR-040 CANONICALIZATION AUTHORIZATION` Gate has been approved and is performed as a separate governance step.

**DoD-040-007.** Canonicalization completes a separate `CANONICALIZATION REVIEW = APPROVED` Gate before repository incorporation authorization.

**DoD-040-008.** Repository incorporation requires a separate explicit `REPOSITORY INCORPORATION AUTHORIZATION` after canonicalization review approval.

**DoD-040-009.** Repository incorporation is performed only after its explicit authorization and incorporates only the reviewed canonical CORR-040 artifact through the authorized repository path/process.

**DoD-040-010.** Repository incorporation completes a separate `REPOSITORY INCORPORATION REVIEW = APPROVED` Gate before implementation authorization.

**DoD-040-011.** CORR-040 implementation requires a separate explicit `IMPLEMENTATION AUTHORIZATION`; repository incorporation or its review does not authorize implementation automatically.

**DoD-040-012.** Immediately before implementation, a fresh Git preflight verifies the authorized repository baseline, branch, HEAD/origin state, divergence, worktree state, and absence of unrelated operations or changes; stale preflight evidence is insufficient.

**DoD-040-013.** The implementation modifies exactly one authorized repository path: `docs/product/11-phase-1-scope-entry-gate.md`.

**DoD-040-014.** All semantic implementation edits are confined exclusively to `§17 — Resultado final` of the authorized target.

**DoD-040-015.** The active snapshot represents `TASK-019 = CLOSED` and `TASK-019 HUMAN CLOSURE = APPROVED` as recovered prior human evidence, not as a closure newly granted by CORR-040.

**DoD-040-016.** The active snapshot represents the first-admin Auth/session flow as implemented within the approved TASK-017/018/019 responsibility boundary.

**DoD-040-017.** The active snapshot represents first-admin `PlatformUser` establishment/reconciliation and first `COMPANY_ADMIN` profile completion as implemented by the approved TASK-019 boundary.

**DoD-040-018.** The active snapshot represents the initial enabled `COMPANY_ADMIN` membership establishment and enabled tenant authority after authoritative first-admin completion as implemented.

**DoD-040-019.** The active snapshot represents first-admin onboarding completion as implemented without converting the result into generic or ordinary later-user onboarding completion.

**DoD-040-020.** The active snapshot represents the TASK-019 `USER_CREATED` producer as implemented exactly within first-admin completion and does not reassign that producer to TASK-017 or TASK-018.

**DoD-040-021.** TASK-017 remains responsible for authoritative first-admin onboarding intent/challenge/proof-consume/SessionGrant/handoff foundation and is not rewritten as the profile/onboarding-completion owner.

**DoD-040-022.** TASK-018 remains responsible for first-admin Auth identity reconciliation/session establishment foundation and is not rewritten as the profile/membership/onboarding-completion owner.

**DoD-040-023.** RF-012 first-admin completion state and RF-004 end-to-end delivery status remain correctly distinguished; completing the first-admin flow does not declare RF-004 delivery end-to-end complete.

**DoD-040-024.** Ordinary later-user onboarding remains incomplete.

**DoD-040-025.** Generic user creation remains incomplete and is not inferred from the first-admin-specific TASK-019 path.

**DoD-040-026.** Generic `CompanyMembership` creation remains incomplete and is not inferred from the initial first-admin membership creation performed by TASK-019.

**DoD-040-027.** Later-user profile completion and later-user `USER_CREATED` production remain incomplete; the pre-Client later-user onboarding foundation remains incomplete even where reusable independent primitives are present.

**DoD-040-028.** CORR-039 remains fully preserved, including the approved Phase 2 / Phase 3 Client-dependent authorization sequencing boundary.

**DoD-040-029.** RF-013, RF-014, RF-015, RF-016, and RF-017 remain unchanged.

**DoD-040-030.** RF-015 remains mandatory and zero client assignment does not satisfy RF-015.

**DoD-040-031.** `Client` remains in Phase 3 and no minimal, temporary, placeholder, partial, or other physical Client representation is moved into Phase 2 by CORR-040.

**DoD-040-032.** Physical `UserClientAccess` remains deferred under the approved Client prerequisite boundary and is not represented as implemented or required before Phase 2 close.

**DoD-040-033.** Physical/full `SupportAccessGrant` and full Client-dependent support remain deferred under the approved boundary and are not represented as implemented or required before Phase 2 close.

**DoD-040-034.** Historical snapshots remain preserved and no historical TASK/CORR artifact is rewritten to make prior state appear current.

**DoD-040-035.** Phase 2 remains `IN PROGRESS / NOT CLOSED` after CORR-040 implementation and after CORR-040 closure.

**DoD-040-036.** The Phase 2 Exit Gate remains `NOT YET DEFINED`; CORR-040 does not define or satisfy it.

**DoD-040-037.** Phase 3 remains `NOT STARTED`; CORR-040 does not start it.

**DoD-040-038.** `next TASK = NOT DETERMINED`; CORR-040 does not determine the next task.

**DoD-040-039.** `TASK-020 = NOT DETERMINED`; CORR-040 does not determine, design, specify, authorize, or implement TASK-020.

**DoD-040-040.** No architecture, product, domain, security, RLS, multitenancy, Auth architecture, or offline behavior change is introduced by CORR-040.

**DoD-040-041.** `new ADR required = NO` remains true; no ADR is silently created, modified, required, or inferred by this documentation correction.

**DoD-040-042.** The complete implementation diff is reviewed against the authorized target, §17-only semantic boundary, approved CORR-040 specification, and preserved historical content; partial-diff review is insufficient.

**DoD-040-043.** `git diff --check` passes on the complete implementation diff.

**DoD-040-044.** The implementation introduces no unrelated whitespace cleanup, no unrelated formatting refactor, and no line-ending normalization outside the exact authorized edits.

**DoD-040-045.** Final implementation evidence reports target SHA-256, bytes, LF, CRLF, bare CR, trailing-whitespace lines, and final-newline state from the physical target bytes.

**DoD-040-046.** `CORR-040 IMPLEMENTATION REVIEW = APPROVED` is obtained through a separate review Gate after the full implementation diff and evidence are available; implementation does not imply implementation review approval.

**DoD-040-047.** Staging requires a separate explicit `STAGING AUTHORIZATION` after implementation review approval.

**DoD-040-048.** Staging is executed only after staging authorization and contains exclusively the reviewed CORR-040 implementation changes.

**DoD-040-049.** Staging completes a separate `STAGING REVIEW = APPROVED` Gate before commit authorization.

**DoD-040-050.** Commit requires a separate explicit `COMMIT AUTHORIZATION` after staging review approval.

**DoD-040-051.** Commit is executed only after commit authorization and records exclusively the reviewed and staged CORR-040 changes.

**DoD-040-052.** Commit completes a separate `COMMIT REVIEW = APPROVED` Gate before push authorization.

**DoD-040-053.** Push requires a separate explicit `PUSH AUTHORIZATION` after commit review approval.

**DoD-040-054.** Push is executed only after push authorization and pushes only the reviewed CORR-040 commit/state authorized by the preceding Gates.

**DoD-040-055.** Push completes a separate `PUSH REVIEW / REMOTE VERIFICATION = APPROVED` Gate confirming the intended remote state before final human closure.

**DoD-040-056.** `CORR-040 FINAL HUMAN CLOSURE = SEPARATE MANDATORY GATE`; it occurs only after the preceding mandatory governance lifecycle is satisfied and is never optional or implied by push review/remote verification.

**DoD-040-057.** CORR-040 closure does not imply Phase 2 closure, Phase 2 Exit Gate definition, Phase 3 start, next TASK determination, or TASK-020 determination.

The mandatory closure distinctions are:

```text
CORR-040 closure
!=
Phase 2 closure

CORR-040 closure
!=
Phase 2 Exit Gate definition

CORR-040 closure
!=
Phase 3 start

CORR-040 closure
!=
next TASK determination

CORR-040 closure
!=
TASK-020 determination
```

No Supabase mutation is part of CORR-040 at any Gate.

---

## 23. Specification review checklist

The Revisor Central should verify at `CORR-040 SPEC REVIEW` that:

1. the source-recovery blocker is treated as resolved, not reopened;
2. SOURCE A and SOURCE B identities match the recovered physical evidence;
3. TASK-019 closure is consumed as recovered prior human evidence, not re-approved;
4. target count remains exactly one;
5. §17 remains the bounded current-state surface;
6. the specification corrects first-admin state without claiming ordinary later-user completion;
7. CORR-039 and RF-015 remain intact;
8. no architectural/security/RLS/multitenancy change was introduced;
9. no Phase 2 closure, Exit Gate definition, Phase 3 start, or TASK-020 determination was introduced;
10. implementation remains unauthorized pending later Gate(s).

---

## 24. Final specification state

```text
CORR-040 SPECIFICATION GENERATION =
PASS

CORR-040 SPEC REVIEW =
APPROVED

F-040-SPEC-001 =
RESOLVED

F-040-ART-001 =
RESOLVED

open CORR-040 specification findings =
0

CORR-040 HUMAN SPEC APPROVAL =
APPROVED

CORR-040 specification =
HUMAN APPROVED

CORR-040 approved artifact =
GENERATED / REVIEW APPROVED

CORR-040 APPROVED ARTIFACT REVIEW =
APPROVED

CORR-040 CANONICALIZATION AUTHORIZATION =
APPROVED

CORR-040 CANONICALIZATION =
PASS

CORR-040 canonicalized =
YES

canonical artifact =
GENERATED

CORR-040 CANONICALIZATION REVIEW =
PENDING

repository incorporation =
NOT AUTHORIZED

CORR-040 implementation =
NOT AUTHORIZED / NOT PERFORMED

repository mutation =
NO

Supabase Local mutation =
NO

Supabase Cloud mutation =
NO

Codex =
NOT USED

staging =
NO

commit =
NO

push =
NO

Phase 2 =
IN PROGRESS / NOT CLOSED

Phase 2 Exit Gate =
NOT YET DEFINED

Phase 3 =
NOT STARTED

next TASK =
NOT DETERMINED

TASK-020 =
NOT DETERMINED

next Gate =
CORR-040 CANONICALIZATION REVIEW

DESTINO =
REVISOR CENTRAL
```

```text
STOP
```
