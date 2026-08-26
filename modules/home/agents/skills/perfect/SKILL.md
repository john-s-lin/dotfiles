---
name: perfect
description: Review recent implementation work for functions that can be rewritten with the principles of function honesty, caller empathy and single-level of abstraction. Use after exploratory coding or when the user asks for a function "shape" cleanup.
---

# 1. Core Principles

## Principle 1: Maintain Function Honesty

- **Honest Functions:** Communicate their entire contract strictly through their parameters (inputs) and return values (outputs). They touch no global state, perform no hidden I/O, and are completely deterministic.
- **Dishonest Functions:** Rely on or mutate hidden state (global variables, hidden singletons, unstated ambient environment). Dishonesty is infectious—calling a dishonest function makes the caller dishonest.
- **Architectural Strategy (Functional Core, Imperative Shell):**
  - Push "dishonesty" (I/O, database writes, network calls, randomness, clock reads) to the outermost layer / entry points of your application.
  - Keep the interior business logic 100% honest, pure, and easily testable without mocks.

## Principle 2: Empathize with the Caller

- **Signature as Communication:** A function signature is an explicit contract. Design signatures that make invalid states unrepresentable.
- **Leverage Strong Types & Invariants:**
  - Avoid raw, primitive types when an invariant is required (e.g., use a dedicated `NormalizedVec3` or `NonEmptyList` instead of raw `Vec3` or `List`).
  - Force preconditions to be verified at the call site or at type construction time, moving runtime errors to compile-time guarantees.
- **Avoid Over-Constraining:**
  - Require the minimum necessary interface (e.g., accept an iterable or slice rather than a concrete `std::vector` or rigid collection if only sequential access is needed).

## Principle 3: Single Level of Abstraction (SLAP)

- **The Golden Rule:** Every line of code within a function body must operate at the exact same level of abstraction.
- **"Stacking Bricks":** Think of function composition as stacking uniform bricks. High-level workflow functions should orchestrate other named steps; low-level algorithmic functions should handle low-level mechanics.
- **No "Zooming In":** Never mix high-level business orchestration with manual index arithmetic, raw loops, or low-level byte manipulation in the same function. If you need low-level processing, extract it into a focused helper or use standard library algorithms.

# 2. Function Taxonomy Reference

| Taxonomy Type | Description | Characteristics & Usage |
| :--- | :--- | :--- |
| **Honest** | Takes all inputs via parameters, returns all outputs explicitly. | Deterministic, locally reasonable, isolated, trivially unit-testable without mocks. |
| **Dishonest** | Accesses or modifies ambient/global state or performs side effects. | Context-dependent, harder to test, infectious up the call stack. Limit strictly to boundary layers. |
| **Backward** | Framework callbacks or entry points (e.g., `main`, event hooks, `update`). | Acts as the bridge connecting host system events/I/O into honest domain logic. |


# 3. Code Smells & Refactoring Checklist

## Red Flags (Smells)

- [ ] **Hidden Dependencies:** Reading config, singletons, or global system clocks deep inside business logic.
- [ ] **Primitive Obsession / Loose Contracts:** Passing raw floats or strings when specific validated domains (e.g., `EmailAddress`, `PositiveInt`) are expected.
- [ ] **Abstraction Mixing:** Having a high-level `process_order()` contain a manual nested `for (int i = 0; ...)` loop parsing raw buffers.
- [ ] **Overly Rigid Parameter Types:** Demanding an exact container type when only read-only traversal is required.

## Refactoring Steps

1. **Promote Hidden State:** Pass external dependencies as explicit arguments or return explicit values/commands.
1. **Lift Parsing & Invariant Checks:** Parse, don't validate. Construct dedicated types at the boundaries before passing them downward.
1. **Extract Raw Loops:** Replace manual loops with declarative standard library combinators (`map`, `filter`, `find`) or extract the loop body into a dedicated helper function.

# 4. Practical Examples

## Bad (Dishonest & Mixed Abstraction)

```cpp
// Dishonest: reads global config & system clock
// Mixed abstraction: high-level logic mixed with raw index parsing
void process_telemetry() {
    auto now = System::get_current_time();
    for (size_t i = 0; i < global_buffer.size(); ++i) {
        if (global_buffer[i].header == 0xFF) {
            // raw low-level parsing mixed in
            save_to_db(global_buffer[i], now);
        }
    }
}
```

## Good (Honest, Typed, Consistent Abstraction)

```cpp
// Caller empathy: requires validated packets and explicit timestamp
// Single abstraction level: cleanly processes items through declarative steps
std::vector<Record> parse_telemetry(std::span<const RawPacket> packets, Timestamp timestamp) {
    std::vector<Record> records;
    for (const auto& packet : packets) {
        if (packet.is_valid()) {
            records.push_back(Record::from_packet(packet, timestamp));
        }
    }
    return records;
}
```
