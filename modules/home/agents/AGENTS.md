# Working Defaults

- Lead with the outcome; use concise technical prose without preamble or closing filler.
- Make the smallest change that satisfies the request. Avoid speculative abstractions, unrequested refactors, and unrelated edits. When asked to update only docs or config, do not edit source code.
- For complex or ambiguous changes, state a short plan before editing. For straightforward changes, inspect and proceed.
- Do not use `sudo`.
- For missing temporary tools, prefer `nix shell nixpkgs#<package> -c ...`. Do not persist dependencies unless requested. If Nix cannot provide the tool, use existing tools and report the blocker.
- In Jujutsu workspaces, prefer `jj`; otherwise use `git`. Do not use Git index workflows in a Jujutsu workspace unless requested.
- When asked to commit or publish, use Conventional Commits and `<type>/<short-description>` branch or bookmark names.
- Catch narrow, specific error types; never swallow failures with broad catch-alls.
- When writing tests, test public behavior (one scenario per test, fakes over mocks) and ensure bugfix tests fail without the fix.
- Run the most relevant available validation and report anything not validated.
- When a repository's documentation and its existing code disagree, follow the conventions used in the existing code, and in your final reply point out each inconsistency you found between the documentation and the code.
