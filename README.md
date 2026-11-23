# infra

Everything is computer

## Runbooks

Full install procedures for a blank disk or a fresh macOS live in [docs/runbooks/](./docs/runbooks/README.md). Start with the index there to pick the runbook for your machine. The commands below are the quick reference for machines that are already bootstrapped.

## Machines and ownership

Every flake output is either a personal machine or a work machine, and personal configuration may not leak into the work ones: work hosts import neutral profiles (`modules/home/profiles/{base,workstation,server}.nix`, `modules/darwin/profiles/base.nix`) and neutral leaf modules only, never anything under `modules/home/profiles/personal/` or `modules/darwin/profiles/personal.nix`. The machine map, the airgap rules, and the validation contract are in [AGENTS.md](./AGENTS.md).

### Module graph

#### System layer (NixOS & nix-darwin)

```mermaid
flowchart LR
  flake["flake.nix<br/>(+ modules/cache.nix)"]

  flake --> tpd["john-tpd-05 (NixOS)"]
  tpd --> tpd_leaves["hardware-configuration<br/>desktop/{cosmic,greeter,hyprland}<br/>fonts, packages/default, gc/default<br/>services/{fingerprint,keyd,networking,printing,sound,vpn}"]

  flake --> rpi_hosts["apollo, atlas (NixOS RPi)"]
  rpi_hosts --> rpi["modules/server/rpi.nix"]
  rpi --> rpi_leaves["nixos-raspberrypi base + sd-image<br/>gc/default, services/{tailscale,cockpit}"]

  flake --> mba["john-mba-03 (Darwin)"]
  mba --> mba_vpn["darwin/packages/vpn"]
  mba --> d_personal["darwin/profiles/personal.nix"]
  d_personal --> d_pers_leaves["packages/localsend, darwin/services/tailscale<br/>darwin/packages/{ai,personal,rclone}"]
  d_personal --> d_base

  flake --> wmbp["work-mbp-01 (Darwin, work)"]:::work
  wmbp --> d_base["darwin/profiles/base.nix"]
  d_base --> d_base_leaves["fonts, packages/default, gc/darwin<br/>darwin/defaults, darwin/packages/common"]

  classDef work stroke-dasharray: 5 5
```

#### Home Manager layer (all hosts)

```mermaid
flowchart LR
  %% Workstations (top lane)
  tpd["john-tpd-05"] --> tpd_extra["packages/{browsers,developer,personal,work}<br/>desktop/{cosmic,hypr}, home/{alacritty,rclone}"]
  tpd --> p_ws_pers
  mba["john-mba-03"] --> p_ws_pers["profiles/personal/workstation.nix"]
  wmbp["work-mbp-01 (work)"]:::work --> p_ws

  p_ws_pers --> p_ws_pers_leaves["home/{antigravity,gmailctl,zed}"]
  p_ws_pers --> p_ws["profiles/workstation.nix"]
  p_ws_pers --> p_ai

  %% Servers (bottom lane)
  ajax["john@ajax"] --> p_ai["profiles/personal/ai.nix"]
  ajax --> p_srv_pers
  p_ai --> p_ai_leaves["home/{agents,opencode,pi}"]

  pis["apollo, atlas<br/>dietpi@{apollo,atlas}"] --> p_srv_pers["profiles/personal/server.nix"]
  p_srv_pers --> p_srv_pers_leaves["home/jujutsu<br/>shpool.personal.enable = true"]
  p_srv_pers --> p_srv

  nimbus["johnslin@nimbus (work)"]:::work --> nimbus_extra["home/{bash,herdr}<br/>genericLinux, extraCaches=false"]
  nimbus --> p_srv["profiles/server.nix"]

  %% Neutral convergence
  p_ws --> p_ws_leaves["home/{bash,ghostty,herdr,jujutsu,shpool,starship,zellij}<br/>packages/workstation"]
  p_ws --> p_base["profiles/base.nix"]
  p_srv --> p_srv_leaves["home/{server,shpool}"]
  p_srv --> p_base
  p_base --> p_base_leaves["home/{dotfiles,bat,bottom,direnv,git,grep,helix,zoxide,zsh}<br/>packages/terminal"]

  classDef work stroke-dasharray: 5 5
```

## Bootstrap (First Time Setup)

Since `just` is installed via this Nix configuration, it won't be available on the first run. Use one of these methods to bootstrap:

### Option 1: Use `nix run` with `just`

Run `just` directly from nixpkgs without installing it:

```bash
# On NixOS
nix run nixpkgs#just -- nr <hostname>

# On Linux with Home Manager (standalone)
nix run nixpkgs#just -- hm <username>@<hostname>

# For hosts requiring impure evaluation (e.g., johnslin@nimbus)
nix run nixpkgs#just -- hm johnslin@nimbus --impure
```

### Option 2: Use raw Nix commands

Bypass `just` entirely for the first rebuild (required on macOS before `darwin-rebuild` is installed, or before `home-manager` is available):

```bash
# On macOS (bootstrap)
nix run nix-darwin/master -- switch --flake .#<hostname>

# On NixOS
sudo nixos-rebuild switch --flake .#<hostname>

# On Linux with Home Manager (standalone, non-NixOS)
nix run home-manager -- switch --flake .#<username>@<hostname> -b bak

# For hosts requiring impure evaluation (e.g., johnslin@nimbus)
nix run home-manager -- switch --flake .#johnslin@nimbus --impure -b bak
```

> [!NOTE]
> If your Nix installation doesn't have flakes enabled globally yet, add `--extra-experimental-features "nix-command flakes"` to any `nix` command.

After the first successful rebuild, `just` (and `darwin-rebuild` on macOS) will be installed and available for all subsequent commands.

## NixOS

To rebuild, run

```bash
just nr <hostname>
```

## macOS

To rebuild, run

```bash
just dr <hostname>
```

## Home Manager (Standalone Linux)

For standalone Home Manager on non-NixOS Linux systems (e.g., AlmaLinux, Ubuntu with Nix installed):

To rebuild, run:

```bash
just hm <username>@<hostname>
```

For example, to apply the configuration for `john@ajax`:

```bash
just hm john@ajax
```

The `hm` command in the `justfile` accepts a host followed by native Home Manager options. It always uses `-b bak` for the normal backup behavior and defaults to `dietpi@atlas`.

To apply the configuration for `johnslin@nimbus` (which requires impure mode), pass `--impure` directly:

```bash
just hm johnslin@nimbus --impure
```

For other hosts that don't need impure mode, you can just pass the host name:

```bash
just hm john@ajax
```

If you need to run it manually without `just` (e.g., for bootstrapping):

```bash
nix run home-manager -- switch --flake .#<username>@<hostname> -b bak
```

And for `nimbus` specifically:

```bash
nix run home-manager -- switch --flake .#johnslin@nimbus --impure -b bak
```

## Garbage Collection

To collect garbage, run

```bash
just clean
```

Default is 30 days. To specify a different number of days:

```bash
just clean <days>
```

## Updating Packages

Updating packages is as easy as

```bash
just update
```

which will update your `flake.lock` file.

## Upgrade and Push

`just upgrade` is the only supported way to publish a lock update. It fetches, rebases the working copy onto `main@origin`, runs `nix flake update`, **runs `just check-all`**, then commits `flake.lock`, moves the `main` bookmark, and pushes. A lock update that breaks evaluation of any host therefore cannot be pushed.

```bash
just upgrade
```

The commit message defaults to `chore: update flake`; pass one to override it:

```bash
just upgrade "chore: bump nixpkgs"
```

## Validation

Two gates, different scopes:

```bash
just check       # this machine: nix flake check, evaluates and builds its checks
just check-all   # every output, every architecture: evaluation only
```

- `just check` is what you run while working on a host: `nix flake check` realises and builds the checks for the machine you are on, so it catches package build failures. It never looks at the other hosts.
- `just check-all` is the pre-push gate: it evaluates the `drvPath` of every NixOS, nix-darwin, and standalone Home Manager output, on any architecture. Evaluation only, so nothing is built and inputs are already locked, but each host costs a few seconds (about 45 s for all seven here).

The two overlap but catch different failures: a package can evaluate and fail to build (only `just check` sees that), and another architecture's output can be broken while this machine's is fine (only `just check-all` sees that). `just upgrade` runs `just check-all` for you.

Neither gate proves activation or runtime behaviour: run the host's own `nixos-rebuild build`, `darwin-rebuild build`, or `home-manager build` before switching.

## Additional Setup

### rclone

`rclone` is used to sync cloud storage to local drives. The configuration is pretty much ready to go, except you need to sign in to get access tokens to OneDrive and Google Drive.
Refer to [docs/cloud-storage.md](./docs/cloud-storage.md) for more info.

### gmailctl

`gmailctl` and its `~/.gmailctl/config.jsonnet` filter config are managed declaratively with Home Manager.
Refer to [docs/gmailctl.md](./docs/gmailctl.md) for setup and operational details.

## Troubleshooting

### Ghostty Terminfo Issues

If you experience garbled terminal output or repeated characters when SSH'ing into servers, see [docs/terminfo-troubleshooting.md](./docs/terminfo-troubleshooting.md) for diagnosis and solutions.
