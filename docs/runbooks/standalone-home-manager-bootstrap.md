# Standalone Home Manager Bootstrap Runbook

This runbook takes an already-installed Linux host to a working standalone Home Manager configuration from this repository. It covers Ubuntu, Debian, DietPi, AlmaLinux, and cloudtop machines. It does not cover NixOS or macOS; those have their own runbooks. The operating system stays in place and Home Manager manages the user environment on top of it.

## When to use this runbook

Use this runbook when the operating system is already installed and working, and you want to apply this repository's standalone Home Manager configuration to a user account that matches the flake. The target is a Linux host that is not NixOS and not macOS:

- Ubuntu or Debian on a VPS or physical machine.
- DietPi on a Raspberry Pi.
- AlmaLinux on a server or cloudtop.
- A work-managed cloudtop where the Nix daemon is provided by IT.

Do not use this runbook for NixOS or nix-darwin machines. Do not use it to reinstall the Nix daemon on a work-managed host such as nimbus; that daemon belongs to IT. If the target machine already has hand-made dotfiles in the home directory, read the warning in "Before you start" first.

## Done means

The bootstrap is done when all of the following are true:

- `home-manager generations` lists at least one generation and marks the current one.
- A tool from the Home Manager profile resolves on `PATH` in a fresh shell; this runbook uses `shpool` as the example.
- Shell activation works: a new login shell starts without Home Manager activation errors.
- A shpool smoke test runs; on hosts that import `modules/home/zellij.nix`, a zellij smoke test also runs.

Expected time: 20-40 minutes.

## Before you start

Gather these items before you begin:

- `sudo` access on the target host, as the user named in the flake table below. The username must match the flake's `username`; Home Manager refuses to activate for a different user.
- Network access to GitHub and to the Nix cache.
- A GitHub account and a phone with the GitHub web UI. The repository is private over SSH and `gh` is not present on a fresh OS, so the ed25519 key is added through the web UI from the phone.
- A decision on which flake host you are installing. The standalone outputs in `flake.nix` are:

| Flake output | Username | Architecture | Flags |
| --- | --- | --- | --- |
| `homeConfigurations."john@ajax"` | `john` | `aarch64-linux` (VPS) | none |
| `homeConfigurations."dietpi@apollo"` | `dietpi` | `aarch64-linux` (Raspberry Pi) | none |
| `homeConfigurations."dietpi@atlas"` | `dietpi` | `aarch64-linux` (Raspberry Pi) | none |
| `homeConfigurations."johnslin@nimbus"` | `johnslin` | `x86_64-linux` (cloudtop) | `--impure` |

The flake key is the username and hostKey joined with `@`, for example `john@ajax`. The hostKey must match the attribute name after the `@` in the flake key. Set `hostname` to the same value unless the host omits it, as nimbus does. If the machine's username does not match the table, either create a matching user or add a new host using "Adding a new host" before continuing.

Nimbus is different from the other hosts in three ways. It is a work-managed cloudtop with a work-managed Nix daemon. The `johnslin` user is not a trusted user on that daemon, so extra-cache settings are ignored; `hosts/nimbus/home.nix` disables them with `dotfiles.nix.extraCaches.enable = false`. The flake reads `$HOME` at evaluation time with `builtins.getEnv`, so every nimbus command must pass `--impure`.

> [!WARNING]
> The first switch runs with `-b bak`, which sets Home Manager's backup extension. Existing files that the configuration manages are moved aside with a `.bak` suffix rather than deleted. If you want to keep the originals in place, move them out of the way before the first switch. Review the moved files after the switch and copy back anything the configuration does not manage.

## Checkpoint map

| Phase | Goal | Checkpoint |
| --- | --- | --- |
| P0 | Confirm the host mapping and flags | Username and architecture match the table |
| P1 | Install Nix and enable flakes | `nix --version` works and flakes are enabled |
| P2 | Set up SSH auth and clone the repo | `ssh -T git@github.com` succeeds and the tree is clean |
| P3 | Run the first switch | Switch completes and `command -v home-manager` prints a path |
| P4 | Verify the user environment | Generation, profile tool, and shpool smoke test pass |
| P5 | Run the recovery drill | `home-manager --rollback` runs and the generation list changes |

## Phases

### P0: Confirm the host mapping and flags

Decide the flake key now: `john@ajax`, `dietpi@apollo`, `dietpi@atlas`, or `johnslin@nimbus`. The flag decision follows from the table: no extra flags for `john@ajax`, `dietpi@apollo`, or `dietpi@atlas`; `--impure` for `johnslin@nimbus` only. Confirm that the current user and architecture match the table in "Before you start":

```bash
id -un
uname -m
```

Expected output: the username from the table (`john`, `dietpi`, or `johnslin`) and an architecture of `aarch64` or `x86_64` matching the row. On nimbus, also note that the daemon is work-managed and that `--impure` will be required; P1 confirms the daemon trust after Nix is present.

**Checkpoint:** `id -un` and `uname -m` match the chosen row, and the flags for that row are confirmed (`--impure` only for nimbus).

**If it fails:** if the username does not match, create a matching user or choose the matching flake output. If the architecture does not match, stop: the flake output targets a different system. If you are on nimbus, confirm you will add `--impure` to every nimbus command.

### P1: Install Nix and enable flakes

Choose one installation path for a personal host. If Nix is already installed, skip the install and confirm the version.

#### Upstream multi-user installer

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Follow the prompts. Open a new terminal, or source the daemon profile so `nix` is on `PATH`:

```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

#### Determinate Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf https://install.determinate.systems/nix | sh -s -- install
```

Determinate Nix ships its own daemon and garbage-collection behavior. Either installer works for a personal host. The choice matters on nimbus: do not run either installer there. Nimbus already has a work-managed daemon, and the `johnslin` user is not a trusted user on it. Installing a second daemon would conflict with IT's daemon, and trusting the user would require an administrator change. Keep the work daemon and use `--impure` on nimbus commands.

#### Enable flakes

For the upstream installer, enable flakes for the current shell and for the daemon:

```bash
export NIX_CONFIG='experimental-features = nix-command flakes'
```

Make the setting persistent for the user:

```bash
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

Determinate Nix enables flakes by default. If `nix flake --help` works, no extra configuration is needed.

On nimbus, confirm the daemon is work-managed and that `johnslin` is not a trusted user:

```bash
nix config show trusted-users
```

Expected output: a list that does not include `johnslin`. If the user is not listed as trusted, extra caches cannot be configured by that user; this is expected on nimbus and is why `dotfiles.nix.extraCaches.enable = false` is set.

**Checkpoint:** Nix is installed and flakes work.

```bash
nix --version
nix flake --help
```

Expected output: a version string and the flake subcommand help text. No error. On nimbus, `nix config show trusted-users` also confirms `johnslin` is not trusted.

**If it fails:** if `nix` is not found, open a new terminal or source the daemon profile shown above. If flakes are disabled, confirm `~/.config/nix/nix.conf` contains the `experimental-features` line and retry. If the daemon fails to start on a personal host, reboot and retry. On nimbus, do not install a daemon; ask IT to confirm the work daemon is running and that `johnslin` can connect to it. If `johnslin` is unexpectedly trusted on nimbus, follow IT policy rather than changing daemon settings.

### P2: Pre-clone authentication and clone the repository

The repository is private over SSH. Generate an ed25519 key on the target host:

```bash
ssh-keygen -t ed25519 -C "john@ajax"
```

Replace `john@ajax` in the comment with the flake key you chose. Read the public key and add it to the GitHub account through the web UI from a phone:

```bash
cat ~/.ssh/id_ed25519.pub
```

**Checkpoint:** authenticate to GitHub.

```bash
ssh -T git@github.com
```

Expected output includes `Hi john-s-lin! You've successfully authenticated`.

**If it fails:** confirm the public key was added to the correct GitHub account and saved. If the key was added to the wrong account or not saved, remove it in GitHub settings and repeat. Confirm the phone has network access to GitHub. Retry `ssh -T git@github.com`.

Clone the repository into the home directory and enter it:

```bash
git clone git@github.com:john-s-lin/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Flakes should already be enabled from P1. If they are not, export the experimental features as shown there.

Confirm the working tree is clean and the chosen flake output evaluates:

```bash
git -C ~/dotfiles status --short
nix eval .#homeConfigurations."john@ajax".activationPackage.drvPath
```

Replace `john@ajax` with the flake key you chose. On nimbus, add `--impure` to the `nix eval` command.

**Checkpoint:** `git status --short` prints nothing and the `nix eval` command prints a `.drv` path without error.

**If it fails:** if the clone fails with a permission error, confirm the SSH key is added and `ssh -T git@github.com` succeeds. If the destination already exists, move it aside or remove it, then retry. Do not run the first switch from a dirty tree. If `nix eval` reports a missing attribute, the flake output is missing or misspelled; see "Adding a new host". If `nix eval` reports a pure-evaluation error on nimbus, add `--impure`.

### P3: First switch

The first switch uses `nix run` to fetch Home Manager and apply the flake. Run it from the repository root. Use the flake key you chose:

```bash
nix run home-manager -- switch --flake .#john@ajax -b bak
```

Replace `john@ajax` with `dietpi@apollo`, `dietpi@atlas`, or `johnslin@nimbus` as appropriate. On nimbus only, add `--impure`:

```bash
nix run home-manager -- switch --flake .#johnslin@nimbus -b bak --impure
```

The `-b bak` argument sets the backup extension so existing files are moved aside rather than deleted. The first switch takes several minutes and downloads the Home Manager and package closures. After it succeeds, `home-manager` and `just` exist. The justfile target `hm` defaults to `dietpi@atlas` and always passes `-b bak`; the `nimbus` target adds `--impure`. Do not use `just` for the first switch, because it is installed by that switch.

Confirm the tools now resolve:

```bash
command -v home-manager
command -v just
```

**Checkpoint:** the switch completes without error and both commands print a path.

**If it fails:** read the switch output. Common causes are flakes not enabled, a dirty working tree, a username mismatch, a missing flake output, or an untrusted daemon on nimbus. On nimbus, confirm `--impure` was passed and that `hosts/nimbus/home.nix` still sets `dotfiles.nix.extraCaches.enable = false`. If the switch fails partway, fix the cause before retrying. If a managed file was moved aside and you need it back, see "Recovery and rollback". If the failure is a bad generation, do not continue to P4; run the recovery drill first.

### P4: Verification

Run these commands after the first switch.

Confirm the generation exists:

```bash
home-manager generations
```

Expected output: a table with at least one generation and the current generation marked.

Confirm a profile tool resolves on `PATH`:

```bash
command -v shpool
```

Expected output: a path under the Home Manager profile. If your host imports `modules/home/zellij.nix`, also run:

```bash
zellij --version
```

Open a fresh login shell and confirm activation runs without errors. Then run the shpool smoke test:

```bash
shpool version
shpool list
```

Expected output: a shpool version string and a session list. An empty session list is fine; the command must exit without error. If zellij is configured on the host, `zellij --version` prints its version.

**Checkpoint:** `home-manager generations` lists a generation, `command -v shpool` prints a profile path, and `shpool version` plus `shpool list` run without error.

**If it fails:** if no generation is listed, re-run the first switch from P3 and read the output. If `shpool` is not found, confirm the host imports `modules/home/shpool.nix` and that the switch completed; then open a new login shell or source the activation profile. If `shpool list` fails, confirm the shpool daemon can start in the user session and retry. For a zellij failure, confirm the host imports `modules/home/zellij.nix`; standalone hosts do not import it by default. If the shell activation prints errors, run the first switch again and read the activation output.

### P5: Recovery drill and rollback path

Before relying on the environment, know the rollback path. The first switch moved pre-existing managed files aside with a `.bak` suffix. To inspect them:

```bash
find ~ -maxdepth 3 -name '*.bak' -print
```

If a later switch breaks the environment, roll back to the previous generation:

```bash
home-manager --rollback
```

This switches to the previous generation without rebuilding. Confirm the generation list changed:

```bash
home-manager generations
```

**Checkpoint:** the rollback command runs without error and `home-manager generations` shows the previous generation as current.

**If it fails:** if `home-manager` is not available because the shell environment broke, start a new login shell or use an absolute path from the profile. If the rollback command form is not accepted by the installed Home Manager version, use `home-manager rollback` instead. If no generation works, remove the broken profile links and re-run the first switch from P3. On nimbus, do not reinstall the daemon; use the work daemon and pass `--impure`.

## Post-install tasks

These tasks are outside the base bootstrap. Complete them after verification.

| Task | Steps | Proof |
| --- | --- | --- |
| Configure rclone remotes | `rclone config`; see `docs/cloud-storage.md` for the remote layout. | `rclone listremotes` shows the configured remotes. |
| Set up Gmail filters | `gmailctl init`, then `gmailctl diff`; see `docs/gmailctl.md`. | `gmailctl diff` completes without error. |
| Start Tailscale | `sudo tailscale up`. | `tailscale status` lists the machine. |
| Set up GPG and signing keys | Import or generate keys. | `git config --get user.signingkey` prints the key ID. |

## Recovery and rollback

If a switch breaks the environment:

1. Open a new login shell or another TTY. If the shell profile itself is broken, use the profile's absolute paths or a shell started without the Home Manager init files.
2. Roll back to the previous generation:

```bash
home-manager --rollback
```

3. If a managed file was moved aside and you need the original, copy it back from the matching `.bak` file. The first switch used `-b bak`, so the backup sits next to the original with a `.bak` suffix. Review the backup before copying it back; the configuration may manage that path.
4. If no generation works, remove the broken profile links and re-run the first switch from P3. The flake and host configuration are portable; the standalone outputs do not contain machine-specific hardware state that must be regenerated. On nimbus, use the work-managed daemon and pass `--impure`; do not install a replacement daemon.

## Adding a new host

To add a standalone host that is not in the flake yet:

1. Copy the closest existing host directory as the base. For a Raspberry Pi, copy `hosts/dietpi/`; for a VPS or cloudtop, copy `hosts/ajax/` or `hosts/nimbus/` as appropriate:

```bash
cp -r hosts/dietpi hosts/newpi
```

Replace `newpi` with the hostKey you chose.

2. Add a `homeConfigurations` entry in `flake.nix`, following the existing entries. Set `homeModule`, `hostKey`, `hostname`, `username`, and `system`. For example:

```nix
"dietpi@newpi" = mkStandaloneHome {
  homeModule = ./hosts/newpi/home.nix;
  hostKey = "newpi";
  hostname = "newpi";
  username = "dietpi";
  system = "aarch64-linux";
};
```

The flake key is the username and hostKey joined with `@`, so the example above is `dietpi@newpi`. If the host module reads the environment, as `hosts/nimbus/home.nix` does with `builtins.getEnv "HOME"`, set `home` explicitly and pass `--impure` on every command for that host. A host whose module reads the environment cannot be evaluated purely.

3. Review the copied `home.nix` for host-specific values. Keep `dotfiles.nix.extraCaches.enable = false` on a work-managed daemon where the user is not trusted.

4. Commit the changes with `jj commit -m "feat: add standalone home configuration for the new host"`, then run the first switch from P3 with the new flake key. Do not push until the switch and verification pass.
