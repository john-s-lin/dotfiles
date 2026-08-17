# Gmailctl Agent Instructions

- Remote Gmail filters are the source of truth. `modules/home/gmailctl/config.jsonnet` is a versioned snapshot that is occasionally refreshed from remote and consolidated in the checkout.
- The Home Manager-managed `~/.gmailctl/config.jsonnet` is a working projection of that snapshot, not an authoritative source. Never edit it or write through its symlink.
- Home Manager uses `force = true` to reclaim the deployed path on activation. Accidental local replacement will be overwritten and must not be used to refresh the snapshot.
- Use `gmailctl diff` to inspect differences between remote state and the deployed snapshot. Never run `gmailctl apply` or use it as validation.
- Capture downloads outside both the checkout and managed home path, then deliberately reconcile the snapshot with the downloaded remote state:

  ```bash
  checkout_root="$(git rev-parse --show-toplevel)"
  tmpdir="$(mktemp -d)"
  gmailctl download --output "$tmpdir/config.jsonnet"
  diff -u "$checkout_root/modules/home/gmailctl/config.jsonnet" "$tmpdir/config.jsonnet"
  # Consolidate reviewed remote changes into the checkout snapshot.
  rm -r "$tmpdir"
  ```

- Validate the reconciled snapshot with `gmailctl --config "$checkout_root/modules/home/gmailctl" debug` before activating Home Manager.
- Keep OAuth credentials, tokens, and other authentication files local only. Never copy them into the checkout.
- Use named entries from the local `colors` map instead of repeating hex values. Add downloaded colors during reconciliation, then rerun `gmailctl debug` against the snapshot directory.
