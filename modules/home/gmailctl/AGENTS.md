# Gmailctl Agent Instructions

Follow the canonical workflow in [docs/gmailctl.md](../../../docs/gmailctl.md).

- Never edit the Home Manager projection at `~/.gmailctl/config.jsonnet` or write through its symlink.
- Never store OAuth state, tokens, or other authentication files in the checkout.
- Never run `gmailctl apply`; it is irreversible and reserved for the user.
- Activate Home Manager before presenting the final deployed `gmailctl diff`.
