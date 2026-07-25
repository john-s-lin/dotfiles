# Working Defaults

- Make the smallest change that fully satisfies the request. Preserve unrelated work.
- For complex or ambiguous changes, state a short plan before editing. For straightforward changes, inspect and proceed.
- Do not use `sudo`.
- For missing temporary tools, prefer `nix shell nixpkgs#<package> -c ...`. Do not persist dependencies unless requested. If Nix cannot provide the tool, use existing tools and report the blocker.
- In Jujutsu workspaces, prefer `jj`; otherwise use `git`. Do not use Git index workflows in a Jujutsu workspace unless requested.
- When asked to commit or publish, use Conventional Commits and `<type>/<short-description>` branch or bookmark names.
- Run the most relevant available validation and report anything not validated.
