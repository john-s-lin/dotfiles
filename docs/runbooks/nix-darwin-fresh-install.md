# nix-darwin Fresh-Install Runbook

This runbook takes a fresh macOS installation to a working nix-darwin setup running this repository's configuration. It covers Apple-silicon (`john-mba-03`) and Intel (`john-mbp-04`) personal Macs. The work-managed Mac variant is covered in Phase P9.

## When to use this runbook

Use this runbook for a fresh or wiped personal Mac that will be managed by this repository's nix-darwin flake. It covers both aarch64 (Apple silicon) and x86_64 (Intel) Macs. Do not use it for an MDM-enrolled or IT-managed Mac; use the "work-managed Mac" variant in Phase P9 instead. If the Mac already has hand-made dotfiles in the home directory, read the warning in "Before you start" first.

## Done means

The installation is done when all of the following are true:

- `darwin-rebuild --list-generations` shows a generation.
- Home Manager is activated for the flake user (`john`).
- `brew bundle check --verbose` reports the declared casks are installed.
- `tailscale status` shows the machine connected to the tailnet.
- FileVault is on (after Phase P8).

Expected time: 60-90 minutes.

## Before you start

Gather these items before you begin:

- Administrator access to the Mac.
- A GitHub account and a phone with the GitHub web UI (for adding an SSH key).
- A decision on the hostKey. This runbook uses `john-mba-03` for Apple silicon and `john-mbp-04` for Intel. The work-managed Mac uses `work-mbp-01` and the username `johnslin`. The hostKey must match the hostname and the `darwinConfigurations` output in `flake.nix`.
- A decision on the Apple ID: sign in during Setup Assistant or skip it. The configuration does not require an Apple ID.
- A backup of any existing data on the target disk. Reinstalling macOS erases the disk.
- A decision on the Nix installation method: the upstream multi-user installer or Determinate Nix. See Phase P2 for the tradeoff.
- Homebrew installed manually before the first switch. The flake manages casks but does not install Homebrew; Phase P3 covers the install.

> [!WARNING]
> Do not run this runbook on a Mac that already has hand-made dotfiles in the home directory. `home-manager.backupFileExtension = "bak"` moves existing files aside with a `.bak` suffix when the first switch runs. If you want to keep the originals in place, move them out of the way before cloning.

Host-specific facts used throughout:

| Fact | Apple silicon | Intel |
| --- | --- | --- |
| hostKey | `john-mba-03` | `john-mbp-04` |
| system | `aarch64-darwin` | `x86_64-darwin` |
| username | `john` | `john` |
| home directory | `/Users/john` | `/Users/john` |

The flake outputs `darwinConfigurations."john-mba-03"` and `darwinConfigurations."john-mbp-04"` exist in this repository. If you chose a different hostKey, confirm the matching output exists before installing. See "Adding a new host" if it does not.

## Checkpoint map

| Phase | Goal | Checkpoint |
| --- | --- | --- |
| P0 | Confirm hostKey and flake output | Flake output evaluates |
| P1 | Run Setup Assistant, create the admin user | FileVault is Off |
| P2 | Install Nix (upstream or Determinate) | `nix --version` and flakes work |
| P3 | Install Homebrew | `brew --version` and casks captured |
| P4 | Set up SSH auth and clone the repo | Clone succeeds; tree clean |
| P5 | First switch with `nix run nix-darwin/master` | Switch completes |
| P6 | Verify the system | Generation, Homebrew, defaults, Tailscale |
| P7 | Recovery drill and rollback path | `darwin-rebuild --rollback` works |
| P8 | Enable FileVault | FileVault is On |
| P9 | Work-managed Mac variant | Generation on `work-mbp-01` |

## Phases

### P0: hostKey decision and flake-output check

Decide the hostKey now. This runbook uses `john-mba-03` for Apple silicon and `john-mbp-04` for Intel. The hostKey must match the hostname and the `darwinConfigurations` output in `flake.nix`. If you are on a machine that already has this repository cloned, confirm the output exists:

```bash
nix eval .#darwinConfigurations.john-mba-03.config.system.build.toplevel.drvPath
```

Replace `john-mba-03` with `john-mbp-04` if you are installing on Intel.

**Checkpoint:** the command prints a `.drv` path without error.

**If it fails:** the flake output is missing. Add the host to `flake.nix` using the "Adding a new host" procedure, or choose an existing hostKey that matches the machine.

### P1: Setup Assistant (first boot)

On first boot, run the macOS Setup Assistant. Create an administrator user whose name matches the flake username: `john` for personal Macs. Do not enable FileVault yet. Do not use Migration Assistant to bring over hand-made dotfiles; the first switch manages them. Skip Apple ID sign-in if you prefer; it is not required by the configuration. When the desktop loads, open Terminal.

Confirm FileVault is still off:

```bash
sudo fdesetup status
```

Expected output: `FileVault is Off.`

Confirm the admin user exists:

```bash
id john
```

**Checkpoint:** `fdesetup status` prints `FileVault is Off.` and `id john` succeeds.

**If it fails:** if FileVault is already on, turn it off in System Settings → Privacy & Security → FileVault before continuing. If the username does not match, create a matching admin user in Users & Groups, or update the flake output for the username you chose. Do not continue until the username matches the flake.

### P2: Install Nix

Choose one of the two installation paths.

#### Upstream multi-user installer

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Follow the prompts. Open a new terminal or run `source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh` so `nix` is on `PATH`.

#### Determinate Nix

Determinate Nix includes its own daemon and garbage-collection behavior. If you choose this path, read the caveat in "Work-managed Mac" and in this section. The repository's `modules/gc/darwin.nix` sets `nix.gc.automatic = true`, which conflicts with Determinate's GC. The committed `hosts/work-mbp-01/configuration.nix` documents the workaround as a commented `nix.enable = false;` line. Do not edit committed host config for a personal Mac; choose the upstream installer if you want the repository's GC module to work as written. See Phase P9 for the work-managed variant.

To install Determinate Nix:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://install.determinate.systems/nix | sh -s -- install
```

#### Enable flakes

For the upstream installer, enable flakes for the current shell and for the daemon:

```bash
export NIX_CONFIG='experimental-features = nix-command flakes'
```

To make the setting persistent for your user:

```bash
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

**Checkpoint:** Nix is installed and flakes work.

```bash
nix --version
nix flake --help
```

Expected output: a version string and the flake subcommand help text. No error.

**If it fails:** if `nix` is not found, open a new terminal or source the daemon profile as shown above. If flakes are disabled, confirm `~/.config/nix/nix.conf` contains the `experimental-features` line and retry. If the daemon fails to start, reboot and retry.

### P3: Install Homebrew

Install the Xcode Command Line Tools first:

```bash
xcode-select --install
```

Then run the Homebrew installer:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the prompts. When it finishes, add Homebrew to your shell environment as instructed by the installer. For Apple silicon this is usually:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

> [!WARNING]
> `modules/darwin/packages/common.nix` declares the `ghostty` and `rectangle` casks and sets `homebrew.onActivation.cleanup = "zap"`. It also enables upgrades on activation and disables Homebrew's global auto-update. On the first switch, Homebrew will uninstall every cask and app not declared in the configuration. There is no `nix-homebrew` flake input in this repository, so Homebrew must be installed manually before the first switch. Capture the current cask list before switching so you know what will be removed:

```bash
brew list --cask > ~/brew-casks-before-switch.txt
```

**Checkpoint:** Homebrew is installed and the cask list is captured.

```bash
brew --version
brew list --cask
```

Expected output: a Homebrew version string and the cask list. If the Mac is truly fresh, the list is empty or contains only system casks. The file `~/brew-casks-before-switch.txt` exists.

**If it fails:** if `brew` is not found, source the `brew shellenv` line from your shell profile and retry. If `xcode-select --install` did not complete, run it again and wait for the dialog to finish. If Homebrew reports a missing compiler, install the Command Line Tools and retry.

### P4: Pre-clone authentication and clone the repository

The repository is private over SSH. The fresh Mac does not have `gh`, so add an ed25519 key through GitHub's web UI from a phone.

Generate the key on the Mac:

```bash
ssh-keygen -t ed25519 -C "john@john-mba-03"
```

Read the public key and add it to the GitHub account through the web UI:

```bash
cat ~/.ssh/id_ed25519.pub
```

**Checkpoint:** authenticate to GitHub.

```bash
ssh -T git@github.com
```

Expected output includes `Hi john-s-lin! You've successfully authenticated`.

**If it fails:** confirm the public key was added to the correct GitHub account and that the SSH agent is not required. If the key was added to the wrong account or not saved, remove it in GitHub settings and repeat. Retry `ssh -T git@github.com`.

Clone the repository into the home directory:

```bash
git clone git@github.com:john-s-lin/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Flakes should already be enabled from P2. If they are not, export the experimental features as shown there.

**Checkpoint:** the clone succeeds and the working tree is clean.

```bash
git -C ~/dotfiles status --short
```

Expected output: no output (clean tree).

**If it fails:** if the clone fails with a permission error, confirm the SSH key is added and `ssh -T git@github.com` succeeds. If the destination already exists, move it aside or remove it, then retry. Do not run the first switch from a dirty tree.

### P5: First switch

The first switch uses `nix run` to fetch nix-darwin and apply the flake. It requires the user to be an administrator and prompts for sudo. Run it from the repository root:

```bash
nix run nix-darwin/master -- switch --flake .#john-mba-03
```

Replace `john-mba-03` with `john-mbp-04` if you are installing on Intel. The first switch takes several minutes and downloads the nix-darwin and Home Manager closures. After the first switch, `darwin-rebuild` and `just` exist. Confirm `darwin-rebuild` is on `PATH`:

```bash
command -v darwin-rebuild
```

**Checkpoint:** the switch completes without error and `command -v darwin-rebuild` prints a path.

**If it fails:** read the switch output. Common causes are a missing flake output, a dirty tree, or a Nix daemon that is not running. If the switch fails partway, do not run it again until you fix the cause. If Homebrew's `cleanup = "zap"` removed an app you needed, reinstall it from the backup cask list captured in P3. If the failure is a bad generation, see "Recovery and rollback".

### P6: Verification

Run these commands after the first switch.

Confirm the generation exists:

```bash
darwin-rebuild --list-generations
```

Expected output: a table with at least one generation and the current generation marked.

Confirm Homebrew matches the configuration:

```bash
brew bundle check --verbose
```

Expected output: the command reports that all dependencies are satisfied. If it reports missing casks, run `darwin-rebuild switch --flake .#john-mba-03` again after reading the output.

Spot-check a macOS default that the configuration sets:

```bash
defaults read com.apple.dock orientation
```

Expected output: `left`, matching `modules/darwin/defaults.nix`.

Confirm Tailscale is running:

```bash
tailscale status
```

Expected output: the machine appears in the tailnet list. If Tailscale is not up yet, run `sudo tailscale up` and retry.

Confirm Home Manager is active for the user:

```bash
home-manager generations
```

If `home-manager` is not on `PATH`, inspect the generation links directly:

```bash
ls ~/.local/state/nix/profiles/
```

**Checkpoint:** all of the above commands succeed. `darwin-rebuild --list-generations` shows a generation, `brew bundle check --verbose` reports satisfied, `defaults read` returns a value, and `tailscale status` lists the machine.

**If it fails:** for a missing generation, re-run the first switch. For Homebrew drift, run `darwin-rebuild switch --flake .#john-mba-03` and read the Homebrew output. For a missing default, run `darwin-rebuild switch --flake .#john-mba-03` again and confirm `modules/darwin/defaults.nix` is imported by the host config. For Tailscale, run `sudo tailscale up` and confirm the daemon is running. For Home Manager, confirm the username matches the flake. If the system is unbootable or a switch breaks the desktop, use "Recovery and rollback".

### P7: Recovery drill and rollback path

Before relying on the system, know the rollback path. If a later switch breaks the system, roll back to the previous generation:

```bash
darwin-rebuild --rollback
```

This switches to the previous generation without rebuilding. Confirm the generation list:

```bash
darwin-rebuild --list-generations
```

**Checkpoint:** `darwin-rebuild --rollback` runs without error and the generation list shows the previous generation as current.

**If it fails:** if `darwin-rebuild` is unavailable because the switch broke the tool, boot into macOS Recovery (hold the power button on Apple silicon, or Command-R on Intel), open Terminal from the Utilities menu, and inspect `/nix/var/nix/profiles`. If no generation boots, follow the Recovery-mode reinstall path in "Recovery and rollback".

### P8: Enable FileVault

FileVault stays off until after the first switch. Now that the system is working and you have verified it, enable FileVault in System Settings → Privacy & Security → FileVault, or from the command line:

```bash
sudo fdesetup enable
```

Follow the prompts and save the recovery key. Do not enable FileVault before the first switch; a failed switch on an encrypted disk is harder to recover.

**Checkpoint:** FileVault reports On.

```bash
sudo fdesetup status
```

Expected output: `FileVault is On.`

**If it fails:** if `fdesetup` reports that FileVault is already on, no action is needed. If enabling fails, confirm the user is an administrator and retry. If the recovery key was not saved, run `sudo fdesetup changerecovery -personal` to set a new one.

### P9: Work-managed Mac variant

This variant is for the IT-provisioned work Mac (`work-mbp-01`, `aarch64-darwin`, user `johnslin`). Start after IT has provisioned the Mac and you have an admin account. Do not run the Setup Assistant phases; IT has already done that. Skip Phase P1 and Phase P8 (FileVault) as IT controls those settings. Follow the Determinate Nix path in Phase P2.

The flake output for `work-mbp-01` sets `username = "johnslin"` and does not set a hostname. The host configuration imports only a subset of modules: fonts, packages, `modules/darwin/defaults.nix`, `modules/darwin/packages/common.nix`, and `modules/gc/darwin.nix`. It does not import `hosts/aqua/configuration.nix`.

On the Determinate path, `modules/gc/darwin.nix` (`nix.gc.automatic = true`) conflicts with Determinate's GC. The committed `hosts/work-mbp-01/configuration.nix` documents the workaround as a commented `nix.enable = false;` line. Do not edit committed host config to work around this; document the caveat and follow IT's instructions for the work Mac.

The first switch for the work Mac is:

```bash
nix run nix-darwin/master -- switch --flake .#work-mbp-01
```

**Checkpoint:** the switch completes without error and `darwin-rebuild --list-generations` shows a generation for `work-mbp-01`.

**If it fails:** confirm you are on the `johnslin` account and that IT has installed the Determinate Nix daemon. If the GC conflict blocks the switch, read the committed commented `nix.enable = false;` line in `hosts/work-mbp-01/configuration.nix` and follow IT's policy. Do not edit the committed host config.

## Post-install tasks

These tasks are outside the base install. Complete them after the verification phase.

| Task | Steps | Proof |
| --- | --- | --- |
| Configure rclone remotes | `rclone config`; macOS remotes are `GDrive:` and `OneDrive:`. Install macFUSE per `docs/cloud-storage.md`. | `rclone listremotes` shows the configured remotes. |
| Set up Gmail filters | `gmailctl init`, then `gmailctl diff`; see `docs/gmailctl.md`. | `gmailctl diff` completes without error. |
| Start Tailscale | `sudo tailscale up`. | `tailscale status` lists the machine. |
| Set up GPG and signing keys | Import or generate keys. | `git config --get user.signingkey` prints the key ID. |

## Recovery and rollback

If a configuration switch breaks the system:

1. Reboot and hold the power button on Apple silicon (or Command-R on Intel) to enter macOS Recovery. Open Terminal from the Utilities menu.
2. If the system boots but the desktop is broken, switch to a terminal and run:

```bash
darwin-rebuild --rollback
```

3. If no generation works, boot into Recovery mode and reinstall macOS using the Recovery assistant. Reinstall Homebrew and Nix as in P2 and P3, then re-run the first switch from P5. The committed host configurations do not contain machine-specific hardware state that must be regenerated; the flake output and host config are portable.

## Adding a new host

To add a personal Mac that does not exist in the flake yet:

1. Copy the closest existing host directory as the base. For a personal Mac, copy `hosts/aqua/`:

```bash
cp -r hosts/aqua hosts/john-mba-05
```

Replace `john-mba-05` with the hostKey you chose.

2. Add the `darwinConfigurations` output in `flake.nix`, following the existing entries. Set the right `system` (`aarch64-darwin` or `x86_64-darwin`) and `username` (`john` or `johnslin`). Set `hostname` or omit it. For example:

```nix
"john-mba-05" = mkDarwinSystem {
  hostKey = "john-mba-05";
  hostname = "john-mba-05";
  system = "aarch64-darwin";
  username = "john";
};
```

3. Review the copied `configuration.nix` and `home.nix` for host-specific values.
4. Commit the changes with git (or your configured VCS).
