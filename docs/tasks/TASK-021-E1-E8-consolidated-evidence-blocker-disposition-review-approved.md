# TASK-021 — Consolidated Hosted Development E1–E8 Evidence & Blocker Disposition Review

**Artifact type:** candidate external documentary evidence / Revisor Central working dossier.
**Status:** `DRAFT — PENDING INDEPENDENT REVIEW AND HUMAN APPROVAL`; **not canonical**; **not incorporated into Git**.
**Environment:** `HOSTED DEVELOPMENT` only.
**Project:** `software-registros-mantenimiento-dev`; **project ref:** `iedssfqujccxxxmayguy`.
**Scope:** read-only consolidation and disposition; no new queries, no implementation, no test execution, no schema/privilege changes, no ledger or phase transition.

> **Interpretation rule:** `26/26 queries reported executed` denotes **completion of the authorized collection**, not a finding that B-1, B-2 or B-3 have been discharged. The results below are based on the operator-provided responses and Revisor Central reviews within this conversation. Original collection reported physical access to Q-E6-01, but its file was not supplied to the prior independent reviewer; the Q-E6-01 export was newly attached and physically verified **only in this correction environment** (see §3). The other historical raw exports are not all reattached here; therefore do not claim a new independent byte-level audit of every E1–E8 result or presume Q-E6-01 custody in any later review.

## 1. Canonical and approved inputs — physically identified

| Input | Physical SHA-256 (verified in this working environment) | Relevance |
|---|---|---|
| `TASK-021-hosted-read-only-evidence-collection-E1-E8-specification-candidate.md` | `b8388668131a65ee148a83aae7ce5ba87c859eacb67982e88390450bcc314e4e` | Exact 26-query read-only approved package; historical cover/status is superseded by later human approvals, not silently edited |
| `TASK-021-hosted-read-only-evidence-collection-E1-E8-query-manifest.json` | `3e7fdb479226a486631bec0c16eb6f3673599ba9eb6dddb3671f861bb2d27813` | Query IDs and original SQL SHA-256 |
| `TASK-021-authoritative-later-user-auth-identity-reconciliation-initial-session-establishment-foundation.md` | `d0106d83633b616099f6772702ee80f4700115186e938047e19a81edba865c43` | Task and security contract |
| `ADR-0022-later-user-auth-subject-discovery-application-compatibility-initial-session-serialization.md` | `1221f653d59c44af691ea314f77660b9f66e2f691cfc4fc2afd96e3891fe7e9c` | Architecture / serialization contract |
| `CORR-047-task-021-6B-002-physical-integrity-correction.md` | `d87f3eab580fa005b95149fac806ffe39d6916664941a0274a3206ea468458d5` | NULL / CHECK physical integrity gap; future forward-only fix |
| `CORR-048-task-021-privileged-session-transition-integrity-correction.md` | `2a6e82801ec00843e7c7f67e6bc7e84bb6e47fcad1ed4e79d1c8238faefc351a` | Privileged RPC transition integrity defects; future minimal fix |
| `TASK-013-verification-challenge-foundation.md` | See physical file, no new SHA asserted here | `supabase_auth_admin` / Auth Hook `SECURITY INVOKER` minimal privileges (especially §27.4 and AC-100) |

**Prospectively tracked Git source (prior approved project evidence; not historical deployment proof):** `supabase/migrations/20261005042801_task_021_later_user_auth_identity_session_foundation.sql`, SHA-256 `f6862b27e74e4a3da81c96ea316d24451c812bcf4e4a2dea89cf12e558ca8e9f`, blob `7a9267f80dd0786e3aad084896bbe08789346ca6`; repository HEAD reference used in earlier comparison `cd6c3ed500b60682ef97a25c5f1e2894dab5754b`. Neither prospective commit nor matching present-day functions independently establishes historic applied bytes.

## 2. Authorization trail — separate Gates

| Control | Observed disposition |
|---|---|
| `TASK-021 HOSTED READ-ONLY EVIDENCE COLLECTION SPECIFICATION REVIEW` | APPROVED by prior independent review |
| `TASK-021 E1–E8 SQL PACKAGE HUMAN APPROVAL` | APPROVED, exact files and 26 query bodies |
| `TASK-021 E1–E8 HOSTED READ-ONLY EXECUTION AUTHORIZATION` | APPROVED by human for manual SQL Editor use only |
| Target confirmation | Operator affirmatively confirmed project/ref/Hosted Development in the conversation |
| Q-E6-01 initial truncation | 100-row output, STOP observed; then operator adjusted Editor row limit and supplied 205-row export; no rewritten query reported |
| Additional SQL packages or expanded review | **NOT AUTHORIZED** |
| Local or remote implementation, migrations, mutating tests, RLS/GRANT edits | **NOT AUTHORIZED** |
| Git/staging/commit/push, ledger sync, TASK-021 closure, phase progression | **NOT AUTHORIZED** |

## 3. Collected query evidence — 26 of 26

`PASS` in this section refers to the **evidence collection/query response**, not a functional test or security sign-off. Snapshot observations are bounded by their actual time and role.

| Query | Key observation from operator result / review | Qualification |
|---|---|---|
| Q-E1-01 | `postgres` database, `current_user=session_user=postgres`, PostgreSQL 17.6, `row_security=on`; UTC timestamp `2026-11-07 14:28:56.26734+00` | SQL alone cannot validate Supabase project ref |
| Q-E1-02 | `rolbypassrls=true`, `has_coordination_select=true`, `coordination_rls_active=false`, coordination owned by `postgres`, RLS enabled on table | Supports complete coordination-table visibility for same operating context; other tables not implied |
| Q-E2-01 | Six `schema_migrations` columns, including `version text`, `statements text[]`, `name text` | Schema compatible with Q-E2-02 |
| Q-E2-02 | version `20261005042801`; name `task_021_later_user_auth_identity_session_foundation`; 70 statements; rendered MD5 `37060a83062005aa6dedafe14d0335b7` | Registered version + auxiliary fingerprint ≠ historical SQL provenance |
| Q-E3-01 | 11/11 expected relations present; RLS enabled, permanent ordinary tables; 9 public owned by `postgres`; `auth.users`/`auth.sessions` owned by `supabase_auth_admin` | Scoped physical inventory only |
| Q-E3-02 | 60 columns across 9 public tables; coordination 13 columns, anchors 2 | Earlier review; raw export not presently revalidated byte-for-byte |
| Q-E3-03 | 58 constraints all validated; 15 on coordination; two CHECKs retain SQL NULL/UNKNOWN gap | CORR-047 6B-002 confirmed; constraint validation does not remedy it |
| Q-E3-04 | 30 indexes valid/ready; subject fence partial unique index observed | Existence does not prove concurrency behavior |
| Q-E3-05 | 67 triggers enabled (66 internal, one business); immutable bindings trigger on coordination | Function body separately reviewed in E4 |
| Q-E3-06 | No rewrite rules returned | Scoped to 9 public tables |
| Q-E4-01 | 13/13 expected function signatures; owner `postgres`; 10 SECURITY DEFINER, 3 SECURITY INVOKER; ACL and empty search paths reviewed | Doesn't prove correct call paths or actual runtime authorization |
| Q-E4-02 | 13 definitions returned; two CORR-048 RPC defects observed; prior comparison reported 12/12 TASK-021-migration function bodies matching current deployed definition bodies | Raw definitions require restricted custody; only present-day comparison, not B-3 provenance |
| Q-E5-01 | Five expected roles; `postgres` and `service_role` BYPASSRLS; `supabase_auth_admin` without BYPASSRLS | Scope of role attributes only |
| Q-E5-02 | 25 role/table combinations; `anon`/`authenticated` no direct CRUD for five tables; `service_role` effective S/I/U on bridge and grants as reported by `has_table_privilege`; operator-reported `stored_acl` from `relacl` for each relation is `{postgres=arwdDxtm/postgres,service_role=arw/postgres}` (original Q-E5-02 raw result not physically attached); `supabase_auth_admin` no table-level SELECT on bridge/grants | Table-level privilege false can coexist with column-specific privileges; see E5-OBS-002. Effective privileges and reported stored ACL do not equal independently verified direct-grant evidence; see E5-OBS-003 |
| Q-E5-03 | 75 role/column combinations for anchors+coordination; `supabase_auth_admin` coordination UPDATE only on `state`,`updated_at` | Does **not** inspect per-column rights on bridge/grants |
| Q-E5-04 | 65 function/role combinations; six privileged TASK-021 RPCs EXECUTE for `postgres`/`service_role`, not `anon`/`authenticated`; Auth Hook executable by `supabase_auth_admin` | EXECUTE + schema USAGE ≠ functional invocation guarantees |
| Q-E5-05 | 16 role memberships; 8 with admin_option; no reported grant of `postgres` role to `anon`/`authenticated`/`service_role` | Does not inspect `inherit_option`/`set_option` |
| Q-E5-06 | 8 RLS policies across 4 tables; all `polroles` arrays point to OID `16545`; 0 policies on enrollment intents | Role OID not resolved from this output; verify before authoritative role attribution |
| Q-E6-01 | 205 dependency records, 18/18 root objects, 174 INBOUND + 31 OUTBOUND | Export physically verified in this correction environment only; absent during prior independent review and must be reattached for re-review; `pg_depend` not exhaustive for PL/pgSQL runtime calls |
| Q-E6-02 | 5 extensions, 6 enabled event triggers | Catalog names do not prove effects of TASK-021 |
| Q-E6-03 | No foreign servers returned | Doesn't rule out all external effects |
| Q-E6-04 | 13/13 routines inspected; 0 pattern matches | Regex false is **not** proof of no side effects |
| Q-E7-01 | 0 coordination rows; C1=C2=C3=C4=C5=0 | **Empty baseline**; not a negative-test pass, not proof CHECK protection |
| Q-E7-02 | No state rows returned; consistent with total 0 | Snapshot, not durable future guarantee |
| Q-E8-01 | 6 processes: 4 idle clients, pg_cron launcher, pg_net worker; 0 lock waits in snapshot | Not a concurrency test |
| Q-E8-02 | No relevant table/advisory locks returned | Point-in-time only; not deadlock freedom |

**Q-E6-01 export custody and physical verification:** The original collection reported access to an operator JSON export; the file was **not received in the earlier independent review**. For this correction, `Texto pegado.txt` was physically attached and verified from its bytes: SHA-256 `bc3fbb5f1a30814115315cb638f412db1f3750f3c4bdf8454367fecd2cd17f91`, 205 JSON records, 18 distinct root identities, 174 INBOUND and 31 OUTBOUND. This new verification applies **only to the attachment in this correction environment** and does not imply custody by any later reviewer; the identical original export must be attached again and independently verified in the re-review. The ephemeral filename is non-unique and is not a canonical evidence ID. If retaining permanently, re-export/copy with operator custody, deterministic name and independent integrity check under an approved archival process.

## 4. Critical findings and corrected interpretation

### FIND-047 — Physical integrity 6B-002: CONFIRMED / NOT CORRECTED

The deployed CHECK conditions retain equality predicates on nullable reserved/confirmed subject fields. PostgreSQL CHECK treats `UNKNOWN` as not violated; thus validated CHECKs do not enforce required presence. CORR-047 calls for **future** forward-only narrow presence guarantees plus negative and positive regression tests. The zero C1–C5 counts arise from a table with **zero** rows and therefore cannot validate future constraints.

### FIND-048 — Privileged session transitions: CONFIRMED / NOT CORRECTED

The deployed bodies of `task_021_activate_issuance` and `task_021_finalize_initial_session` retain the documented unverified `PERFORM` eligibility/row-presence paths. Activation's incompatible-subject branch may change a coordination before full intent/coordination correlation. CORR-048 fixes only the two bodies in a **future separately approved** implementation, preserving signature, ownership, ACL, RLS, Auth Hook and lock graph. No live write-path exploit, cross-tenant leak or actual corruption was demonstrated by E1–E8.

### E5-OBS-001 — Policy OID identity: OPEN

All eight observed policies list role OID `16545`. The canonical TASK-021 policies name `supabase_auth_admin`; **the current Hosted OID ↔ role mapping has not been independently obtained from the eight rows**. A future separately approved read-only identity mapping is needed before unconditional attribution.

### E5-OBS-002 — Auth Hook effective table/column privileges: OPEN / HIGH PRIORITY

- E4 reports `public.task_013_custom_access_token_hook(jsonb)` as `SECURITY INVOKER`; the prospective TASK-021 migration also shows this body selecting/updating `public.auth_bridge_credentials` and `public.auth_session_grants`.
- E5-02 reports `supabase_auth_admin` with `has_table_privilege(..., 'SELECT') = false` for both relations; this **does not resolve column-level SELECT/UPDATE**, because E5-03 checked only anchors and coordination, not bridge/grants.
- TASK-013 §27.4 requires minimally sufficient SELECT/UPDATE rights for the Hook without grants to tenant-owned data. The observed mismatch creates a **material unresolved authorization question**. It is **not yet proven** that actual Hook operation is broken: column-level rights and exact execution context have not been fully reconciled.
- Do **not** grant or revoke privileges to make an inspection pass. First perform independent read-only, column-scoped effective ACL reconciliation and review the Hook's precise needed columns against TASK-013 and deployed body, by a **new SQL-specification/approval/execution Gate**.

### E5-OBS-003 — `service_role` grants on bridge/grants: OPEN

Q-E5-02 reports effective `service_role` `SELECT`, `INSERT`, `UPDATE` privileges on `auth_bridge_credentials` and `auth_session_grants`, but no DELETE, via `has_table_privilege`. Separately, the originally shared Revisor Central result reports `stored_acl = {postgres=arwdDxtm/postgres,service_role=arw/postgres}` for **both** relations as a `relacl` value. The original Q-E5-02 output file was **not physically attached** in this correction, so neither the ACL string nor direct grants have been independently byte-verified here. If confirmed against the raw `relacl`, `service_role=arw/postgres` would demonstrate direct table-level S/I/U grants made by `postgres`; until then direct-grant attribution remains reported, not independently demonstrated. E5-OBS-003 stays OPEN pending documentary verification and least-privilege qualification against canonical TASK-013 permissions and authorized server-side paths; neither treat these permissions as automatically unsafe nor as approved solely because they are reported.

### E5-OBS-004 — Role inheritance and session limitations: OPEN / OPTIONAL DEPENDENCY

E5-05 exposed only `admin_option` for memberships; it did not expose PostgreSQL 17 membership `inherit_option` or `set_option`. Qualification is required if the remaining access analysis materially depends on those values. E8 did not demonstrate full visibility over every backend, nor ongoing concurrency safety.

## 5. B-1/B-2/B-3 disposition matrix

| Blocker | Positive evidence | Missing proof / current boundary | Current disposition |
|---|---|---|---|
| **B-1 — Hosted baseline equivalence** | Hosted catalog E1–E5: relevant relations, 60 columns, 58 constraints, 30 indexes, 67 triggers, 13 functions, current-state 12/12 migration bodies; RLS and ACL snapshots | Independent per-object comparison with reproducible **Supabase-compatible** baseline, environment exceptions classified; E5-OBS-001..003; all indirect boundary dependencies; archival integrity for large raw exports | `NOT FULLY DEMONSTRATED` — do not certify equivalent or authorize implementation |
| **B-2 — Indirect-effect safety** | E4 deployed source review, E5 privilege/RLS inventory, E6 205 dependency rows, no foreign servers, negative pattern screening, E8 idle/no-lock snapshot | Complete call/writer/Hook/trigger/privilege/lock graph; TASK-013/015/019/020 indirect routes; resolve E5-OBS-002 and assess any unqualified side effects; no mutating test performed | `NOT CLOSED` — do not infer safety from regex or empty locks |
| **B-3 — Historical provenance** | Exact registered migration version `20261005042801`, name, 70 statement entries and MD5; prospective Git source now tracked; 12 current function bodies reported equal | Authentic application-time SQL artifact/log/hash, applicator identity and chronology; later Git tracking does not prove deployment bytes. If unrecoverable, explicit **human risk disposition** rather than invented proof | `NOT DEMONSTRATED — HUMAN DISPOSITION MAY BE REQUIRED` |

**Dependency order:** qualification of E5-OBS-002 and objective per-object B-1 comparison are required before deciding whether any remaining baseline drift is genuinely expected. B-2 must follow actual call paths and DB authority, not simply regex. B-3 is separate and must not be presented as solved by E2 MD5. CORR-047/048 implementation readiness remains `NO` until the authoritative Gates and proof requirements are satisfied.

## 6. Proposed next documentary work — NO SQL OR REPOSITORY MUTATION AUTHORIZED

**Workstream A (first priority): Close E5 qualification on paper.**

- Reconcile from already captured Q-E4-02 definitions which specific columns of bridge/grant the Auth Hook reads and updates, and which effective role is used.
- Match those to TASK-013 §27.4, TASK-021 grants and RLS policies, and current Q-E5-02 evidence. For any actual missing evidence, produce a separate, tightly scoped READ-ONLY SQL candidate package (OID-to-role mapping, `has_column_privilege` for bridge/grants, and only if necessary membership option inspection). **Do not execute** until query review, human exact SQL approval and separate Hosted authorization.
- Qualify `service_role` grants against explicit canonical server authority; record `EXPECTED`, `DRIFT`, or `INDETERMINATE` per grant. Stop and escalate any confirmed escalation/tenant boundary bypass.

**Workstream B: B-1 baseline comparison.**

- Compile reproducible metadata diff by object: `MATCH`, `EXPECTED ENVIRONMENTAL`, `DRIFT`, `INDETERMINATE` with supporting identifiers; include CHECK 6B-002 and both RPC body defects as **known pre-correction matches**, not false equivalence exceptions.
- Identify which prior raw exported evidence is absent from current custody, obtain approved secure re-attachment or custody hash if the review needs exact bytes. Do not claim an unrecoverable export was independently compared anew.

**Workstream C: B-2 static indirect-effect graph.**

- Enumerate writer paths and callers from TASK-013, TASK-015, TASK-019, TASK-020 and TASK-021 using **repo READ-ONLY sources**, plus the hosted definitions already under custody. Map `SECURITY INVOKER/DEFINER` at each hop, granted roles, tenant scope, `Auth Hook` and `SessionGrant` effects, guards/locks and conditions for fail-closed transitions.
- Mark unresolved calls `UNKNOWN`. A negative `pg_depend` or regex test does not close them. Any new SQL or tests require separate Gate; mutating tests remain unauthorized.

**Workstream D: B-3 historical provenance.**

- Review non-mutating independent deployment records if available (applier audit/CI output and original execution artifact); compare true executed bytes and timestamps to target/version. Preserve original source hashes and avoid rewriting history.
- If no authentic record can be obtained, seek a **separate human decision** expressly characterizing historical provenance as undemonstrated and identifying residual risk; do not call it proof or automatically waive a canonical hard gate.

**Workstream E: Gate review.**

- Present separate finding sheets for E5, B-1, B-2 and B-3 with evidence, limitations and acceptance criteria; authorize only the smallest required next action. Recheck worktree/HEAD and the fifteen reported local dirty paths immediately before any future authorized Git activity. Do not touch those paths during this work.

## 7. Documentary acceptance criteria for this candidate

- `AC-DOC-001`: All 26 IDs accounted for exactly once; results distinguish observation and conclusion.
- `AC-DOC-002`: Q-E6-01 initial 100-row truncation, 205-row recovery and limit of catalog dependencies preserved; no unsupported claim of a manual retry or changed SQL.
- `AC-DOC-003`: Empty coordination baseline and C1–C5 zeros correctly distinguished from actual constraint tests.
- `AC-DOC-004`: Defects CORR-047/CORR-048 preserved as **unfixed known baseline**, no implementation authorization.
- `AC-DOC-005`: E5 policy role OID unresolved; Auth Hook privilege matrix explicitly incomplete for bridge/grant; direct `service_role` grants separately qualified.
- `AC-DOC-006`: B-1/B-2/B-3 remain blocked with separate evidence and decisions; no CI, Git or migration-history shortcut.
- `AC-DOC-007`: Scope excludes new SQL execution, tests, RLS changes, repo/Git mutations, ledger/phase closure.
- `AC-DOC-008`: Source identities and current custody limitations recorded; no invented SHA for inaccessible historical raw exports.

## 8. Formal Gate recommendation and authoritative state

```text
TASK-021 E1–E8 HOSTED READ-ONLY COLLECTION = COMPLETED (26/26)
TASK-021 E1–E8 CONSOLIDATED EVIDENCE DOSSIER = CANDIDATE / PENDING REVIEW
E5 SECURITY QUALIFICATION = OPEN
B-1 HOSTED EQUIVALENCE = NOT FULLY DEMONSTRATED
B-2 INDIRECT EFFECT SAFETY = NOT CLOSED
B-3 HISTORICAL PROVENANCE = NOT DEMONSTRATED
CORR-047 6B-002 DEFECT = CONFIRMED / NOT CORRECTED
CORR-048 RPC DEFECTS = CONFIRMED / NOT CORRECTED
CORR-047 IMPLEMENTATION = NOT AUTHORIZED
CORR-048 IMPLEMENTATION = NOT AUTHORIZED
HOSTED SQL MUTATION = NOT AUTHORIZED
REPOSITORY AND GIT MUTATION = NOT AUTHORIZED
TASK-021 = NOT DONE / NOT CLOSED
PHASE 2 = IN PROGRESS / NOT CLOSED
PHASE 3 = NOT STARTED
NEXT GATE = TASK-021 E1–E8 CONSOLIDATED EVIDENCE AND BLOCKER DISPOSITION REVIEW
```

This candidate is **not** a canonical change, an ADR, a permission grant, a risk waiver, or a final security approval. It may be reviewed and corrected before separately obtaining human documentary approval and planning a new narrowly scoped READ-ONLY qualification package.

## 9. Formal human documentary approval — append-only attestation

**Approval authority:** human authorization recorded in the Revisor Central conversation on **2026-11-09**.

**Exact approved source:** `TASK-021-E1-E8-consolidated-evidence-blocker-disposition-review-corrected.md`; SHA-256 `03dde06f0d86419bf54b12166663153da52f388d20c33428021d431ef151c4fb`; **21,899 bytes**. The source's 171 lines above are preserved **byte-for-byte**, including their historical candidate labels and pending-review state as of drafting. Those historical labels are superseded for **documentary approval status only** by this attestation; they have not been silently altered or reinterpreted as technical clearance.

**Independent re-review:** `TASK-021 E1–E8 CONSOLIDATED EVIDENCE INDEPENDENT RE-REVIEW = APPROVED`. Findings `DOC-E1E8-001` and `DOC-E1E8-002` were corrected and independently re-reviewed as `PASS`.

**Human documentary disposition:** `TASK-021 E1–E8 CONSOLIDATED DOSSIER HUMAN DOCUMENTARY APPROVAL = APPROVED`. This approves **only** the documentary consolidation represented by the exact source above, not the independent byte-level validation of every Hosted raw output, security sign-off, historical provenance or implementation.

**Explicitly preserved unresolved matters:**

- `E5 = OPEN`; `E5-OBS-001 = OPEN`; `E5-OBS-002 = OPEN / HIGH PRIORITY`; `E5-OBS-003 = OPEN`.
- `B-1 = NOT FULLY DEMONSTRATED`; `B-2 = NOT CLOSED`; `B-3 = NOT DEMONSTRATED`.
- `CORR-047 = NOT CORRECTED / IMPLEMENTATION NOT AUTHORIZED`; `CORR-048 = NOT CORRECTED / IMPLEMENTATION NOT AUTHORIZED`.
- `TASK-021 = NOT DONE / NOT CLOSED`; `PHASE 2 = IN PROGRESS / NOT CLOSED`; `PHASE 3 = NOT STARTED`.

**Scope exclusion:** This attestation does **not** authorize repository canonicalization or incorporation, `git add`/commit/push, SQL execution, Hosted Supabase modification, changes to roles/RLS/ACL/schema, migrations, tests, implementation, ledger modification, TASK-021 closure, phase closure or progression, nor a waiver or automatic resolution of B-1/B-2/B-3.

**Document custody:** this approved artifact is created **outside the repository**. Its exact bytes and SHA-256 must pass a separate physical review before any subsequent human authorization to incorporate it canonically.

**Next Gate:** `TASK-021 E1–E8 CONSOLIDATED DOSSIER APPROVED ARTIFACT PHYSICAL REVIEW`.
