# infra

Everything is computer

## Runbooks

Full install procedures for a blank disk or a fresh macOS live in [docs/runbooks/](./docs/runbooks/README.md). Start with the index there to pick the runbook for your machine. The commands below are the quick reference for machines that are already bootstrapped.

## Machines and ownership

Every flake output is either a personal machine or a work machine, and personal configuration may not leak into the work ones: work hosts import `modules/home/profiles/base.nix` and neutral leaf modules only, never `hosts/darwin`, `profiles/personal.nix`, or `profiles/server.nix`. The machine map, the airgap rules, and the validation contract are in [AGENTS.md](./AGENTS.md).

### Module graph

```mermaid
flowchart LR
  flake["flake.nix"]
  flake -.-> cache["modules/cache.nix (all hosts)"]

  %% Output groups
  flake --> nixos["nixosConfigurations"]
  flake --> darwin["darwinConfigurations"]
  flake --> hm["homeConfigurations"]

  %% NixOS hosts
  nixos --> tpd["john-tpd-05 (personal)"]
  tpd --> tpd_cfg["hosts/john-tpd-05/configuration.nix"]
  tpd_cfg --> tpd_cfg_mods["hardware-configuration.nix<br/>desktop/{cosmic,greeter,hyprland}<br/>fonts, packages/default, gc/default<br/>services/{fingerprint,keyd,networking,printing,sound,vpn}"]
  tpd --> tpd_hm["hosts/john-tpd-05/home.nix"]
  tpd_hm --> prof_personal
  tpd_hm --> tpd_hm_mods["packages/{browsers,developer,personal,work}<br/>desktop/cosmic/default<br/>home/{alacritty,rclone}"]
  tpd_hm --> hypr["modules/desktop/hypr/default.nix"]
  hypr --> noctalia["modules/desktop/noctalia.nix"]

  nixos --> apollo["apollo (personal, RPi 4B)"]
  nixos --> atlas["atlas (personal, RPi 4B)"]
  apollo --> rpi["modules/server/rpi.nix"]
  atlas --> rpi
  rpi --> rpi_mods["nixos-raspberrypi base + sd-image<br/>modules/gc/default.nix"]
  apollo --> apollo_cfg["hosts/apollo/configuration.nix"]
  atlas --> atlas_cfg["hosts/atlas/configuration.nix"]
  apollo_cfg --> rpi_svc["modules/services/{tailscale,cockpit}.nix"]
  atlas_cfg --> rpi_svc
  apollo --> apollo_hm["hosts/apollo/home.nix"]
  atlas --> atlas_hm["hosts/atlas/home.nix"]
  apollo_hm --> prof_server
  atlas_hm --> prof_server

  %% nix-darwin hosts
  darwin --> mba["john-mba-03 (personal)"]
  mba --> mba_cfg["hosts/john-mba-03/configuration.nix"]
  mba_cfg --> mba_vpn["modules/darwin/packages/vpn.nix"]
  mba_cfg --> darwin_cfg["hosts/darwin/configuration.nix"]
  darwin_cfg --> darwin_cfg_mods["fonts, packages/{default,localsend}<br/>darwin/defaults, gc/darwin<br/>darwin/packages/{ai,common,personal,rclone}<br/>darwin/services/tailscale"]
  mba --> mba_hm["hosts/john-mba-03/home.nix"]
  mba_hm --> darwin_hm["hosts/darwin/home.nix"]
  darwin_hm --> prof_personal

  darwin --> wmbp["work-mbp-01 (work)"]:::work
  wmbp --> wmbp_cfg["hosts/work-mbp-01/configuration.nix"]
  wmbp_cfg --> wmbp_cfg_mods["fonts, packages/default<br/>darwin/defaults, darwin/packages/common<br/>gc/darwin"]
  wmbp --> wmbp_hm["hosts/work-mbp-01/home.nix"]
  wmbp_hm --> prof_base
  wmbp_hm --> wmbp_hm_mods["home/{bash,ghostty,herdr,jujutsu,shpool,starship,zellij}<br/>packages/workstation"]

  %% Standalone Home Manager hosts
  hm --> ajax["john@ajax (personal)"]
  ajax --> ajax_hm["hosts/ajax/home.nix"]
  ajax_hm --> prof_server
  ajax_hm --> ajax_ai["modules/home/{agents,opencode,pi}.nix"]

  hm --> d_apollo["dietpi@apollo (personal)"]
  hm --> d_atlas["dietpi@atlas (personal)"]
  d_apollo --> dietpi_hm["hosts/dietpi/home.nix"]
  d_atlas --> dietpi_hm
  dietpi_hm --> prof_server

  hm --> nimbus["johnslin@nimbus (work)"]:::work
  nimbus --> nimbus_hm["hosts/nimbus/home.nix"]
  nimbus_hm --> prof_base
  nimbus_hm --> nimbus_mods["modules/home/{bash,herdr,server,shpool}.nix"]

  %% Shared Home Manager profiles
  prof_personal["modules/home/profiles/personal.nix"] --> prof_base
  prof_personal --> prof_personal_mods["home/{agents,antigravity,bash,ghostty,gmailctl,herdr,jujutsu,opencode,pi,shpool,starship,zed,zellij}<br/>packages/workstation"]

  prof_server["modules/home/profiles/server.nix"] --> prof_base
  prof_server --> prof_server_mods["modules/home/{jujutsu,server,shpool}.nix"]

  prof_base["modules/home/profiles/base.nix"] --> prof_base_mods["home/{dotfiles,bat,bottom,direnv,git,grep,helix,zoxide,zsh}<br/>packages/terminal"]

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
