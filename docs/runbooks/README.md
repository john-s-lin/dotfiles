# Runbooks

These runbooks take a machine from its starting point to "this repository's configuration is applied and verified". Use a runbook when the machine is blank, freshly reinstalled, or has no repository configuration yet. For a machine that is already bootstrapped, the top-level README's quick-reference commands are enough.

Every runbook follows the same eight-section shape: when to use it, what done means, what to gather first, a checkpoint map, the phases, post-install credential tasks, recovery and rollback, and adding a new host. Checkpoints are commands with expected output; each phase also states what to do when its checkpoint fails.

| Machine | Platform | Runbook | Starting point |
| --- | --- | --- | --- |
| `john-tpd-05` | NixOS | [nixos-fresh-install.md](./nixos-fresh-install.md) | Blank disk |
| `john-mba-03` | nix-darwin (Apple silicon) | [nix-darwin-fresh-install.md](./nix-darwin-fresh-install.md) | Fresh macOS |
| `john-mbp-04` | nix-darwin (Intel) | [nix-darwin-fresh-install.md](./nix-darwin-fresh-install.md) | Fresh macOS |
| `work-mbp-01` | nix-darwin (work-managed) | [nix-darwin-fresh-install.md](./nix-darwin-fresh-install.md), Phase P9 | After IT provisioning |
| `john@ajax` | Standalone Home Manager (aarch64-linux VPS) | [standalone-home-manager-bootstrap.md](./standalone-home-manager-bootstrap.md) | OS installed |
| `dietpi@apollo` | Standalone Home Manager (Raspberry Pi) | [standalone-home-manager-bootstrap.md](./standalone-home-manager-bootstrap.md) | OS installed |
| `dietpi@atlas` | Standalone Home Manager (Raspberry Pi) | [standalone-home-manager-bootstrap.md](./standalone-home-manager-bootstrap.md) | OS installed |
| `johnslin@nimbus` | Standalone Home Manager (x86_64-linux cloudtop) | [standalone-home-manager-bootstrap.md](./standalone-home-manager-bootstrap.md) | OS installed |

## Maintaining these runbooks

When a host's install procedure changes, update the matching runbook in the same change. A runbook that no longer matches `flake.nix`, the `justfile`, or the host configuration is worse than no runbook.
