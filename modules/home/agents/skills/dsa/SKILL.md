---
name: dsa
description: Review recent implementation or spike work for data structures or organizing models that would materially simplify the code. Use after exploratory coding or when the user asks for a data-model or abstraction cleanup review.
---

Review the recent work for accidental complexity that a better data structure or
organizing model would remove.

Consider a state machine, typed model, registry, discriminated union, reducer,
module boundary, queue, cache, index, graph, tree, or normalized collection when
it encodes the domain more directly.

Do not force an abstraction. Prefer clear local code when a new model would add
indirection without removing branches, duplicated rules, invalid states, or
lifecycle risk.

Evaluate the concrete complexity, the invariant the proposed model would encode,
the smallest useful scope, and the behavior/test risk.

Implement a clear low-risk cleanup only when the user requested changes and it
fits that scope. Otherwise, return the recommendation without modifying files.

Return:

1. Verdict: `implement`, `recommend`, or `skip`.
2. Opportunity: the concrete data structure or organizing model, or `none`.
3. Why: the complexity it removes and the invariants it makes clearer.
4. Scope: the smallest credible change.
5. Validation: tests/checks run or the checks that would be needed.
