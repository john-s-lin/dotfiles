---
name: simd
description: Evaluate and refactor scalar loops over contiguous memory for SIMD vectorization. Applies a structured 5-step recipe (broadcast, chunked loop, parallel lanes, reduction/early-exit extraction, and scalar tail fallback) to maximize throughput. Use when the user asks for performance optimization, loop vectorization, or hardware-accelerated scanning.
---

# SIMD Vectorization

## 1. Qualification Check

Vectorize only when all four hold:

-   **Contiguous memory**: Slices or flat arrays (no pointer chasing).
-   **Sufficient scale**: Hundreds+ of elements per call (not tiny buffers where
    setup dominates).
-   **No loop-carried dependencies**: Lane `i` does not depend on lane `i - 1`.
-   **Auto-vectorization gap**: `-O3` / `ReleaseFast` misses the pattern (e.g.,
    early-exit scans) or throughput must be locked across toolchains.

## 2. 5-Step Recipe

1.  **Broadcast**: Pick target lane count and `@splat` scalar
    constants/thresholds across a vector `V`.
2.  **Chunked loop**: Step by `lanes` while `offset + lanes <= len`.
3.  **Parallel lane op**: Run elementwise comparisons, masks, or arithmetic
    across `V`.
4.  **Reduction / early exit**:
    -   *Fast path*: `@reduce(.And, mask)` / `all()` to skip uniform chunks.
    -   *First match*: `@bitCast` mask to unsigned int and `@ctz` / `@clz` to
        find the exact lane.
    -   *Aggregate*: Horizontal fold into a scalar accumulator after the loop.
5.  **Scalar tail & fallback**: Handle remaining `0` to `lanes - 1` elements
    (and unsupported targets) with the scalar loop.

## 3. Reference Pattern (Zig Early-Exit Scan)

This Zig snippet is illustrative—translate the 5 steps to the target language's native SIMD primitives.

```zig
if (simd.lanes(u32)) |lanes| {
    const V = @Vector(lanes, u32);
    const threshold: V = @splat(0xF);

    while (end + lanes <= cps.len) : (end += lanes) {
        const values: V = cps[end..][0..lanes].*;
        const greater_than_threshold = values > threshold;

        if (@reduce(.And, greater_than_threshold)) continue;

        const mask: std.meta.Int(.unsigned, lanes) = @bitCast(greater_than_threshold);
        end += @ctz(~mask);
        break;
    }
}
while (end < cps.len and cps[end] > 0xF) end += 1;
```
