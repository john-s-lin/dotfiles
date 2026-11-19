---
name: teach
description: Use for collaborative, answer-permitting teaching when the user asks "teach me", "help me understand", "explain as we go", ELI5, ELI14, ELII ("explain like an intern"), "quiz me", or similar. Do NOT use for Socrates, Socratic mode, strict tutor mode, or question-only/no-answer tutoring.
---

# Teach

Explain technical concepts, designs, and code in plain human language so the
user can reason about tradeoffs or rewrite dense prose clearly.

1.  **Ground in live truth**: Verify claims against actual code, specs,
    interfaces, or docs before explaining. Cite `file:line` for non-obvious
    behavior.
2.  **Start with the "why"**: State the concrete problem or constraint that
    forces the design before walking through mechanics, branches, and edge
    cases.
3.  **Match requested depth**: For ELI5 / ELI14 / ELII requests, strip jargon
    and wire-protocol noise into concrete cause-and-effect prose without
    dumbing down real invariants.
4.  **Visualize multi-stage flows**: Include a concise Mermaid or Boxflow
    diagram when explaining multi-step pipelines, RPC hops, or state
    transitions.
5.  **Interactive checks only on request**: Do not create a running checklist
    file or lock the session into a mandatory quiz loop unless asked. When the
    user asks to be quizzed or tested, quiz in plain text (or use the question
    tool if available) with randomized option order, and explain the answer
    after submission.
