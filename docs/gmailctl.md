# gmailctl

The Gmail Home Manager module installs `gmailctl` and manages `~/.gmailctl/config.jsonnet`.

Remote Gmail filters are normally the source of truth because filters are primarily edited remotely. `modules/home/gmailctl/config.jsonnet` is a versioned snapshot that is occasionally refreshed from remote and consolidated in the checkout. A reviewed snapshot may also be staged for manual application back to Gmail. Home Manager materializes the snapshot as a working projection at `~/.gmailctl/config.jsonnet` on each personal workstation.

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

The workflow has four explicit, one-way transitions:

1. Remote Gmail export -> checkout checkpoint
2. Checkout checkpoint -> Home Manager working projection
3. Deployed projection -> comparison against remote Gmail
4. Reviewed checkpoint -> optional user-only application to remote Gmail

### Remote Export To Checkpoint

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

Deliberately reconcile `modules/home/gmailctl/config.jsonnet` with the downloaded remote state while preserving useful Jsonnet consolidation. This is the only transition that changes the checkout checkpoint. An agent may perform this cleanup. Then validate the checkpoint without changing Gmail:

```bash
gmailctl --config "$checkout_root/modules/home/gmailctl" debug
rm -r "$tmpdir"
```

### Checkpoint To Projection

If the goal is only to preserve remote state, commit the checkpoint and activate Home Manager to update the working projection. Home Manager is the only owner of `~/.gmailctl/config.jsonnet`.

### Projection Diff

After activation, compare the deployed projection with remote Gmail:

```bash
gmailctl diff
```

If the consolidated checkpoint should replace the remote filters, inspect this diff after activation. After reviewing it, the user may manually run:

```bash
gmailctl apply
```

`gmailctl apply` is irreversible. Agents must never run it; they may only prepare the checkpoint, validate it, and present the diff for the user.

## Upstream Notes

- This checkout uses the legacy default config location: `~/.gmailctl/config.jsonnet`
- `--config` exists as an override for alternate config directories
- Upstream versions may choose an XDG config directory for new setups, but this managed `~/.gmailctl` directory remains explicit
