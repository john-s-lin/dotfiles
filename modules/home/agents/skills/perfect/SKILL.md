---
name: perfect
description: Refactor functions to enforce function honesty (pure, deterministic logic), caller empathy (strong types and flexible contracts), and a single level of abstraction (SLAP). Use after exploratory coding or when the user requests function "shape" cleanup, signature refactoring, or side-effect isolation.
---

# Perfect

Refactor target functions around three invariants. When reviewing or cleaning up
a diff or commit, scope changes strictly to lines and symbols introduced or
modified by the change.

## 1. Function Honesty (Functional Core, Imperative Shell)

-   **Pure core**: Express the full contract through parameters and return
    values—no hidden globals, ambient singletons, implicit clocks, or buried
    I/O.
-   **Boundary shell**: Push I/O, RPCs, persistence, randomness, and time reads
    to outer entry points so domain logic is deterministic and testable without
    mocks.

## 2. Caller Empathy (Parse, Don't Validate)

-   **Names**: Name functions by what they return or do from the caller's view;
    avoid ambiguous noun-verb hybrids (e.g., `clearing_order`, not
    `_clear_order`).
-   **Types**: Make invalid states unrepresentable at boundaries (validated
    domain types over raw strings/dicts) while accepting the narrowest input
    interface callers need (e.g., `Sequence`/`Iterable` over concrete mutable
    containers).

## 3. Single Level of Abstraction (SLAP)

-   Keep every statement in a function at the same level of abstraction. Do not
    mix high-level orchestration with low-level index arithmetic, parsing, or
    retry plumbing; extract focused helpers when levels mix.
