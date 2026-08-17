# gmailctl

The Gmail Home Manager module installs `gmailctl` and manages `~/.gmailctl/config.jsonnet`.

Remote Gmail filters are the source of truth because filters are primarily edited remotely. `modules/home/gmailctl/config.jsonnet` is a versioned snapshot that is occasionally refreshed from remote and consolidated in the checkout. Home Manager materializes that snapshot as a working projection at `~/.gmailctl/config.jsonnet` on each personal workstation.

## First-Time Setup

On a personal workstation:

1. Activate the host configuration to materialize `~/.gmailctl/config.jsonnet`.
2. Initialize Gmail access:

```bash
gmailctl init
```

This does not require the `gcloud` CLI. The setup flow uses Google's web-based OAuth flow and writes local auth state under `~/.gmailctl/`.

## Managed vs Local Files

- Remote authority: Gmail filters
- Checkout-managed checkpoint: `modules/home/gmailctl/config.jsonnet`
- Home Manager-managed working projection: `~/.gmailctl/config.jsonnet`
- Local-only: OAuth credentials, tokens, and any other files created by `gmailctl init`

Never copy OAuth or generated authentication files into the checkout. Do not edit the working projection or write through its symlink.

The projection uses `force = true`. Home Manager activation reclaims the path if it was accidentally replaced locally, so changing that path is not a snapshot refresh workflow.

## Workflow

Inspect differences between the remote source of truth and the currently deployed snapshot:

```bash
gmailctl diff
```

Differences normally mean the repository snapshot needs refreshing, not that remote Gmail should be overwritten. Capture a fresh remote export in an explicit temporary directory, outside both the checkout and managed home path:

```bash
checkout_root="$(git rev-parse --show-toplevel)"
tmpdir="$(mktemp -d)"
gmailctl download --output "$tmpdir/config.jsonnet"
diff -u "$checkout_root/modules/home/gmailctl/config.jsonnet" "$tmpdir/config.jsonnet"
```

Deliberately reconcile `modules/home/gmailctl/config.jsonnet` with the downloaded remote state while preserving useful Jsonnet consolidation. Then validate the checkpoint without changing Gmail:

```bash
gmailctl --config "$checkout_root/modules/home/gmailctl" debug
rm -r "$tmpdir"
```

Activate Home Manager to update the working projection after consolidating the checkpoint. Never run `gmailctl apply`; it is not validation and would overwrite authoritative remote filters from the checkpoint.

## Upstream Notes

- This checkout uses the legacy default config location: `~/.gmailctl/config.jsonnet`
- `--config` exists as an override for alternate config directories
- Upstream versions may choose an XDG config directory for new setups, but this managed `~/.gmailctl` directory remains explicit
