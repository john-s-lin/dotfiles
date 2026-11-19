---
name: auditor
description: Read-only simplification audit of data structures, state representation, control flow, dead/stale paths, and ownership across a repository, directory, or diff; returns verified, deduplicated, priority-ranked recommendations and explicit skips.
---

# Auditor

Audit the target scope (whole codebase, directory, or incoming diff) for
materially useful simplifications in data structures, state representation,
control flow, dead/stale paths, and ownership.

**Read-only contract**: Do not edit repository files, commit, or push.

## 1. Scope Routing

-   **Single-diff/commit or small (<1,500 LOC) scope**: Audit directly against
    the changed files and their immediate callers/tests. Skip multi-wave
    subsystem ceremony.
-   **Repository or multi-package scope**: Build a non-overlapping subsystem
    inventory (`ID`, boundary files, public interfaces, tests, status) and
    default to single-agent sequential directory-by-directory inspection (only
    fan out bounded read-only subagents if requested or when a subagent tool is
    available and the repo is very large).

## 2. Simplification Lens

Apply the `dsa` skill criteria:

-   Scattered booleans/nullables permitting invalid states -> state machine or
    discriminated union.
-   Repeated ad-hoc dict/object shape assumptions -> shared typed model.
-   Duplicated branching -> small map, registry, or pure helper.
-   Unclear state ownership, stale migration paths, or dead wrappers -> delete
    or isolate behind a clean boundary.
-   Repeated linear scans or lookups -> appropriate index/collection.

Do not force abstractions, stylistic churn, hypothetical extensibility, or
wrappers that merely relocate branching. Prefer boring local code when already
clear. Cap output at the top 2 material opportunities per subsystem (or `skip`).

## 3. Independent Verification & Output

Verify every candidate finding against live files at HEAD / working tree before
accepting it; drop unverified, duplicate, or low-leverage items.

For each accepted recommendation, report:

1.  **Verdict & Confidence**: `recommend` (`high` / `medium` / `low`) or `skip`.
2.  **Evidence**: Exact `file:line` citations and current complexity / invalid
    states.
3.  **Proposal & Scope**: Target representation, why it is simpler, and smallest
    credible file/interface change.
4.  **Risk & Validation**: Regression/migration risks and tests required.

Rank accepted findings by impact, blast radius, and dependency order.
