---
name: simd
description: Guide for practical SIMD vectorization. Use when the user asks for performance refactoring using SIMD.
---

## 1. Vectorization Qualification Checklist

Before writing SIMD code, evaluate the target loop against the following criteria:

* **Contiguous Memory Layout:** Data must be laid out sequentially in memory (e.g., slices, flat arrays, buffers). Linked structures and pointer chasing are disqualifiers.
* **Sufficient Data Scale:** The loop iterates over hundreds, thousands, or millions of elements. Loops over tiny collections (dozens of bytes) incur overhead that outweighs throughput gains.
* **No Loop-Carried Dependencies:** Iteration $i$ cannot depend on the computed result of iteration $i - 1$.
* **Predictable Execution Needs:** Compiler auto-vectorization (`-O3` / ReleaseFast) either fails due to complex branching/scans or must be explicitly locked down to prevent regression across toolchain upgrades.

---

## 2. The 5-Step Vectorization Recipe

Any eligible scalar loop (`for (item in items)`) decomposes into five distinct stages:

### Step 1: Broadcast Constants & Initialize Vector Types
Determine the lane count supported by the target architecture (e.g., 4 lanes for ARM NEON / Apple Silicon, 8 for AVX2, 16 for AVX-512). Broadcast scalar thresholds or comparison literals across all vector lanes using a splat operation.

### Step 2: Loop One Vector at a Time
Advance pointers/indices by complete vector chunk sizes (`offset += lanes`) as long as `offset + lanes <= total_length`.

### Step 3: Perform Parallel Lane Operations
Apply comparisons, arithmetic, bitwise shifts, min/max, or masking across all lanes simultaneously with a single vector instruction.

### Step 4: Vector Reduction or Match Extraction
Process the resulting vector according to the algorithm's goal:
* **Uniform Match (Fast Path):** Use a boolean reduction (e.g., `@reduce(.And, ...)` / `all()`) to quickly advance to the next chunk when all elements meet the condition.
* **Early Exit / Scan:** Cast boolean vector masks to an integer bitmask (`@bitCast`) and use count-trailing-zeros (`@ctz`) or count-leading-zeros (`@clz`) to locate the first failing/matching lane.
* **Aggregation:** Perform horizontal vector addition or folding to produce a scalar accumulator.

### Step 5: Execute the Scalar Tail & Fallback
Process remaining leftover elements ($0$ to $	ext{lanes} - 1$) with the original scalar loop. This dual-purpose tail also acts as the baseline fallback for architectures without vector support.

---

## 3. Generic Implementation Blueprint

```c
// 1. Setup & Broadcast
lanes = get_supported_simd_lanes()
vec_threshold = splat(threshold_val)

// 2. Vector Chunked Loop
while (offset + lanes <= data.length) {
    vec_chunk = load_vector(data, offset)
    
    // 3. Parallel Lane Operation
    vec_mask = vec_chunk > vec_threshold
    
    // 4. Vector Reduction / Early Exit Extraction
    if (all_true(vec_mask)) {
        offset += lanes
        continue
    }
    
    bitmask = to_bitmask(vec_mask)
    offset += count_trailing_zeros(~bitmask)
    break
}

// 5. Scalar Tail & Universal Fallback
while (offset < data.length && data[offset] > threshold_val) {
    offset += 1
}
```

---

## 4. Real-World Case Study: Ghostty Run Scanning

### Scalar Baseline (1x)
```zig
while (end < cps.len and cps[end] > 0xF) end += 1;
```

### Vectorized Implementation (Up to 5x–8x)
```zig
if (simd.lanes(u32)) |lanes| {
    const V = @Vector(lanes, u32);
    const threshold: V = @splat(0xF);

    while (end + lanes <= cps.len) : (end += lanes) {
        const values: V = cps[end..][0..lanes].*;
        const greater_than_threshold = values > threshold;

        // Fast path: all printable
        if (@reduce(.And, greater_than_threshold)) continue;

        // Early exit: identify the exact C0 control character lane
        const mask: std.meta.Int(.unsigned, lanes) = @bitCast(greater_than_threshold);
        end += @ctz(~mask);
        break;
    }
}

// Scalar tail & architecture fallback
while (end < cps.len and cps[end] > 0xF) end += 1;
```

---

## 5. Architectural Lane Reference

| Architecture / Feature Set | Register Width | 8-bit Lanes (`u8`) | 16-bit Lanes (`u16`) | 32-bit Lanes (`u32`) | 64-bit Lanes (`u64`) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **ARM NEON / Apple Silicon** | 128-bit | 16 | 8 | 4 | 2 |
| **x86 AVX2** | 256-bit | 32 | 16 | 8 | 4 |
| **x86 AVX-512** | 512-bit | 64 | 32 | 16 | 8 |
