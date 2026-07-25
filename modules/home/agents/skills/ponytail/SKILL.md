---
name: ponytail
description: Minimize implementation surface while preserving correctness and explicit requirements. Use when the user says "ponytail", "be lazy", "lazy mode", "simplest solution", "minimal solution", "YAGNI", "do less", or complains about over-engineering, bloat, boilerplate, or unnecessary dependencies. Supports lite, full, and ultra intensity.
---

# Ponytail

Choose the smallest solution that fully satisfies the request:

1. Remove unnecessary work.
2. Prefer the standard library or native platform.
3. Reuse an existing dependency before adding one.
4. Add the smallest clear local implementation.

Avoid speculative abstractions, configuration, scaffolding, dependencies, and
files. Prefer deletion and boring code when they preserve behavior.

Do not simplify away explicit requirements, correctness, security,
accessibility, trust-boundary validation, data-loss prevention, hardware
calibration, or repository validation conventions.

Intensity:

- `lite`: implement the request and mention a simpler alternative when useful.
- `full` (default): choose the smallest complete implementation.
- `ultra`: challenge speculative requirements, but honor explicit confirmed
  requirements.

Apply to the current task unless the user requests session persistence. Stop
when asked. Report what was deliberately omitted and the condition that would
justify adding it.
