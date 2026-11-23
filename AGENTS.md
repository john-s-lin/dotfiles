# Repository instructions

Repo-scoped so it loads for sessions working in this repository. The global
`modules/home/agents/AGENTS.md` stays the general-purpose instruction set.

## Machine map

| Flake output | Directory | Platform | Owner | Notes |
| --- | --- | --- | --- | --- |
| `nixosConfigurations.john-tpd-05` | `hosts/john-tpd-05` | x86_64-linux NixOS | personal | Full desktop: COSMIC, Hyprland, browsers, `packages/personal.nix` + `work.nix`. |
| `nixosConfigurations.apollo` | `hosts/apollo` | aarch64-linux NixOS | personal | Raspberry Pi 4B (`nixos-raspberrypi`, `max-jobs = 0`, CI-built on `ubuntu-24.04-arm`). |
| `nixosConfigurations.atlas` | `hosts/atlas` | aarch64-linux NixOS | personal | Raspberry Pi 4B target config (CI-validated ahead of on-site SD swap; do not deploy remotely to DietPi). |
| `darwinConfigurations.john-mba-03` | `hosts/john-mba-03` | aarch64-darwin | personal | Imports `modules/darwin/profiles/personal.nix` + `modules/home/profiles/personal/workstation.nix`. |
| `darwinConfigurations.work-mbp-01` | `hosts/work-mbp-01` | aarch64-darwin | work | User `johnslin`, no `hostname` (IT owns it), Determinate Nix. Read the GC caveat in the nix-darwin runbook P9. |
| `homeConfigurations."john@ajax"` | `hosts/ajax` | aarch64-linux standalone | personal VPS | `profiles/personal/server.nix` + `profiles/personal/ai.nix`. |
| `homeConfigurations."dietpi@apollo"` | `hosts/dietpi` | aarch64-linux standalone | personal Raspberry Pi | Shares `hosts/dietpi` with `atlas`. |
| `homeConfigurations."dietpi@atlas"` | `hosts/dietpi` | aarch64-linux standalone | personal Raspberry Pi | Shares `hosts/dietpi` with `apollo`. |
| `homeConfigurations."johnslin@nimbus"` | `hosts/nimbus` | x86_64-linux standalone | work cloudtop | `--impure` (reads `$HOME`), extra caches off, IT-managed shpool. |

`hosts/dietpi` is a shared base, not a flake output. The Intel Mac `john-mbp-04`
was retired: nixpkgs dropped `x86_64-darwin`, so that output no longer
evaluated at all.

## Airgap rules

Work hosts (`work-mbp-01`, `nimbus`) may import neutral profiles
(`modules/darwin/profiles/base.nix`,
`modules/home/profiles/{base,workstation,server}.nix`) and neutral leaf modules
only. They must never import anything under `modules/home/profiles/personal/`
or `modules/darwin/profiles/personal.nix`.

Never add personal services or credentials to a work host: `gh` auth, `gmailctl`,
`opencode`, `pi`, `antigravity`, `rclone`, `tailscale`, `mullvad`, `zen`/`chrome`.

Neutral profiles and leaves that are deliberately shared with work hosts:
- `work-mbp-01` imports `modules/darwin/profiles/base.nix` and
  `modules/home/profiles/workstation.nix`.
- `nimbus` imports `modules/home/profiles/server.nix` (which pulls in `base.nix`,
  `modules/home/server.nix`, and `modules/home/shpool.nix` for config/prompt
  only) plus `bash.nix` and `herdr.nix`. Never set `shpool.personal.enable` on
  `nimbus` or in `modules/home/profiles/server.nix`: the shpool binary on nimbus
  is IT-managed and must not come from Home Manager.

## Validation contract

- `just check` is `nix flake check`: it evaluates and builds this machine's
  checks, so it catches package build failures on the host you are on.
- `just check-all` is the cross-architecture evaluation gate: the `drvPath` of
  every output, on any architecture. It must pass before pushing, and
  `just upgrade` runs it automatically.
- Per-host `nixos-rebuild build`, `darwin-rebuild build`, or
  `home-manager build` is the final proof before switching.
- Neither gate catches everything: a build only sees this machine, and
  evaluation only proves the other architectures evaluate. Run `just check`
  where you work and `just check-all` before pushing.
- `just check-all` costs roughly 6 s per host (one `nix eval` per output), so
  it is a pre-push gate, not a save-hook gate.

## Change discipline

- No unit tests exist. The eval gate is the regression test.
- Update the matching runbook in the same change. A runbook that disagrees with
  `flake.nix`, the `justfile`, or the host config is worse than no runbook.
- Push only via `just upgrade` (fetch, rebase, lock update, check, push).
- Keep profile contents ownership-aligned: shared personal configuration goes in
  `modules/home/profiles/personal/` or `modules/darwin/profiles/personal.nix`,
  never in a host file, and nothing personal goes in neutral profiles
  (`base.nix`, `workstation.nix`, `server.nix`).
- The working copy is Jujutsu (`.jj/` colocated). Prefer `jj`; make small
  commits.

## Structure

- `hosts/` holds one directory per flake output, plus the shared `dietpi` base.
- `modules/home/profiles/{base,workstation,server}.nix` are neutral profiles;
  `modules/home/profiles/personal/{workstation,server,ai}.nix` are airgapped
  personal overlays.
- `modules/darwin/profiles/{base,personal}.nix` are the shared nix-darwin bases.
- `modules/home/server.nix` is a neutral leaf, not a profile.
- `modules/cache.nix` is evaluated by NixOS, nix-darwin, and standalone Home
  Manager, so it must not reference `config.home`. Home Manager options such as
  `dotfiles.root` live under `modules/home/`.
