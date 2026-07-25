# Gmailctl Agent Instructions

- Never run `gmailctl apply`; it is irreversible.
- Treat the remote filter as the source of truth. Use `gmailctl diff` or `gmailctl download` to compare remote and local configuration.
- Validate changes with `gmailctl debug`.
- Before a Home Manager rebuild, validate the repository copy with:
  `gmailctl --config /Users/john/.dotfiles/modules/home/gmailctl debug`.
- Use named entries from the local `colors` map instead of repeating hex values. Add a color only when it came from `gmailctl download`, then rerun `gmailctl debug`.
