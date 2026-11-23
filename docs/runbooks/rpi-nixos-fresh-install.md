# Raspberry Pi NixOS Fresh-Install Runbook

This runbook takes a blank microSD card (or USB SSD) for a Raspberry Pi 4 Model B (`apollo` or `atlas`) to a working NixOS installation built from this repository's flake. Images are built natively on GitHub Actions (`ubuntu-24.04-arm`) so neither Pi ever evaluates flakes or compiles packages locally.

## When to use this runbook

Use this runbook when provisioning a Raspberry Pi 4B directly onto NixOS from a CI-built SD card image. Keep the previous DietPi SD card untouched as a physical rollback medium.

Do not use this runbook to convert a remote-only Pi (such as `atlas` before an on-site visit) in place.

## Done means

The installation is done when all of the following are true:

- The Pi boots cleanly from the newly flashed NixOS SD card.
- You have changed `john`'s initial local console password with `passwd`.
- Network is connected (Ethernet or Wi-Fi) and `tailscale status` shows the host online on the tailnet as `tag:rpi`.
- Tailscale SSH works (`ssh john@apollo`) without password auth.
- `nix show-config | grep max-jobs` reports `max-jobs = 0`.
- `swapon --show` shows `/dev/zram0` active.
- Home Manager tools and `zsh` are active for `john`.
- Cockpit is reachable on port `9090`.
- GitHub Actions (`deploy-apollo`) pushes and activates `apollo` cleanly over Tailscale on `main` commits.

Expected time: 30-45 minutes (including CI SD image build).

## Before you start

Gather these items before starting:

- A spare microSD card (keep the old DietPi SD card untouched as rollback).
- A local workstation with an SD card reader (and `zstd` + `dd` or Raspberry Pi Imager / Balena Etcher).
- Physical access to the Pi with a monitor, keyboard, and Ethernet cable (or known Wi-Fi credentials) for first-boot setup.
- Access to GitHub Actions for `john-s-lin/dotfiles` (web UI or `gh` CLI).
- Access to the Tailscale admin console (to configure `tag:ci` / `tag:rpi` ACLs and create a Tailscale OAuth client for GitHub Actions).

Host-specific facts used throughout:

| Fact | `apollo` | `atlas` |
| --- | --- | --- |
| hostDir | `apollo` | `atlas` |
| hostname | `apollo` | `atlas` |
| username | `john` | `john` |
| groups | `networkmanager`, `wheel` | `networkmanager`, `wheel` |
| shell | `zsh` | `zsh` |
| timezone | `America/Los_Angeles` | `America/Los_Angeles` |
| system.stateVersion | `26.05` | `26.05` |

## Checkpoint map

| Phase | Goal | Checkpoint |
| --- | --- | --- |
| P0 | Verify flake evaluation locally | `just rpi-check` prints `ok` for `toplevel` and `sdImage` |
| P1 | Build and download the SD image from CI | `.img.zst` (or `.img`) artifact downloaded |
| P2 | Flash the new SD card | Flash completes and verifies without I/O errors |
| P3 | Boot locally, change password, connect network | `ping -c1 github.com` succeeds |
| P4 | Join Tailscale (enables SSH & CI access) | `ssh john@apollo` succeeds over Tailscale |
| P5 | Verify Pi guards (`max-jobs`, `zramSwap`, Cockpit) | All health checks pass after reboot |
| P6 | Connect GitHub Actions auto-deploy | `deploy-apollo` job succeeds on `ubuntu-24.04-arm` |

## Phases

### P0: Verify flake evaluation

From a workstation checkout of this repo:

```bash
just rpi-check
```

**Checkpoint:** prints `ok` for both `toplevel` and `sdImage` for `apollo` and `atlas`.

**If it fails:** fix the Nix evaluation error and push to `main` before triggering the CI SD image build.

### P1: Build and download the SD image from GitHub Actions

Trigger the `Raspberry Pi NixOS` workflow (`.github/workflows/rpi.yml`) for the target host (`apollo` or `atlas`) with `build_sd_image=true`:

```bash
gh workflow run rpi.yml -f host=apollo -f build_sd_image=true
```

Wait for the run to complete and download the artifact:

```bash
gh run list --workflow=rpi.yml --limit 5
gh run download <run-id> -n nixos-apollo-sd-image -D ./rpi-image
```

**Checkpoint:** `./rpi-image/` contains `nixos-image-rpi4-uboot-*.img.zst` (or `.img`).

**If it fails:** inspect the workflow logs with `gh run view <run-id> --log-failed`. If `nix build --dry-run` showed unexpected source builds, confirm `nixos-raspberrypi` and `home-manager-rpi` are pinned to a cached release branch.

### P2: Flash the new SD card

Set aside the old DietPi SD card untouched. Insert the **new** SD card into your workstation.

Decompress (if `.img.zst`) and flash it with Raspberry Pi Imager (Use Custom Image), Balena Etcher, or `dd`:

```bash
# Inspect disks first — double-check the target device!
diskutil list           # macOS
lsblk                   # Linux

# Example (macOS — replace diskN with the SD card):
diskutil unmountDisk /dev/diskN
zstdcat ./rpi-image/*.img.zst | sudo dd of=/dev/rdiskN bs=4m status=progress
diskutil eject /dev/diskN
```

**Checkpoint:** `dd` (or the imager) completes with no write errors and the card ejects cleanly.

**If it fails:** verify the SD card is not write-protected and try a different card or reader.

### P3: First boot on local console

Insert the newly flashed SD card into the Pi, connect monitor + keyboard (and Ethernet if available), and power on. The root partition grows automatically on first boot (`boot.growPartition = true`).

Log in on the local TTY console as `john` with the initial password `changeme`, then immediately change it:

```bash
passwd
```

If using Wi-Fi instead of Ethernet, connect with NetworkManager:

```bash
nmtui
```

Confirm internet connectivity:

```bash
ping -c1 github.com
```

**Checkpoint:** `john`'s password is changed and `ping -c1 github.com` succeeds.

**If it fails:** check `nmcli device status` or plug in Ethernet to verify DHCP.

### P4: Join Tailscale (enables SSH & CI auto-deploy)

Bring up Tailscale with `--ssh` and `tag:rpi` (matching the Tailscale ACL for CI):

```bash
sudo tailscale up --ssh --hostname=apollo --advertise-tags=tag:rpi
```

Tailscale SSH (`services.tailscale.extraSetFlags = [ "--ssh" ]`) handles both your interactive SSH sessions and GitHub Actions CI push-deploys (`tag:ci` -> `tag:rpi`) without committing SSH keys to this public repository or manually copying `authorized_keys`.

From another machine on your tailnet, verify SSH access:

```bash
ssh john@apollo
```

**Checkpoint:** `tailscale status` lists the Pi online and `ssh john@apollo` logs into a `zsh` shell without prompting for a password.

**If it fails:** verify `systemctl status tailscaled`, confirm your Tailscale ACL allows your user and `tag:ci` to use Tailscale SSH to `tag:rpi`, and confirm `tag:rpi` is owned by your user in the Tailscale admin console (`tagOwners`).

### P5: Verify Pi guards and services

Run these checks over SSH:

```bash
nix show-config | grep '^max-jobs'
swapon --show
journalctl --disk-usage
systemctl is-active tailscaled cockpit.socket
```

**Checkpoint:**

- `max-jobs = 0`
- `/dev/zram0` is listed by `swapon --show`
- `journalctl --disk-usage` stays within the 50M volatile cap
- `tailscaled` and `cockpit.socket` are active

Reboot once (`sudo reboot`) and confirm SSH and Tailscale come back automatically.

### P6: Connect GitHub Actions auto-deploy (one-time)

Once `apollo` is online on Tailscale, wire up the one-time Tailscale ACL and OAuth client so every future commit to `main` builds on `ubuntu-24.04-arm` and pushes to `apollo` automatically:

1. **Tailscale Access Controls** (Tailscale admin console -> Access controls): add `tag:ci` and `tag:rpi` under `tagOwners`, allow `tag:ci` to reach `tag:rpi:22`, and allow Tailscale SSH from `tag:ci` to `tag:rpi` as `root`:

   ```json
   {
     "tagOwners": {
       "tag:ci":  ["autogroup:admin"],
       "tag:rpi": ["autogroup:admin"]
     },
     "acls": [
       { "action": "accept", "src": ["tag:ci"], "dst": ["tag:rpi:22"] }
     ],
     "ssh": [
       {
         "action": "accept",
         "src": ["autogroup:admin"],
         "dst": ["tag:rpi"],
         "users": ["john", "root"]
       },
       {
         "action": "accept",
         "src": ["tag:ci"],
         "dst": ["tag:rpi"],
         "users": ["root"]
       }
     ]
   }
   ```

2. **Tailscale OAuth client** (Tailscale admin console -> Settings -> OAuth clients -> Generate OAuth client):
   - Grant **`Devices: Core` (Write)** scoped to **`tag:ci`**.
   - Copy the Client ID and Client Secret.

3. **Add GitHub Actions Repository Secrets** (from your workstation):

   ```bash
   gh secret set TS_OAUTH_CLIENT_ID
   gh secret set TS_OAUTH_CLIENT_SECRET
   ```

4. **Test an end-to-end CI deploy** (no SD image rebuild needed):

   ```bash
   gh workflow run rpi.yml -f host=apollo -f build_sd_image=false -f deploy_apollo=true
   gh run watch
   ```

**Checkpoint:** the `Deploy (apollo)` job connects to Tailscale, pings `apollo`, and completes `nixos-rebuild switch` with exit code 0. From this point on, every push to `main` updates `apollo` automatically.

**If it fails:** check `gh run view --log-failed`. Most first-time failures are either `tag:rpi` missing from `apollo` (re-run `sudo tailscale up --ssh --hostname=apollo --advertise-tags=tag:rpi`) or the Tailscale `ssh` rule not allowing `tag:ci` -> `tag:rpi` as `root`.

## Post-install credential tasks

- Rotate any service credentials before migrating workloads (Pi-hole, Actual Budget) from `atlas` to `apollo`.

## Recovery and rollback

- **NixOS generation rollback:** if a future configuration breaks boot, select the previous generation in the bootloader menu or roll back via `sudo nixos-rebuild switch --rollback`.
- **Full OS rollback:** power off the Pi, remove the NixOS SD card, and reinsert the untouched DietPi SD card.

## Adding a new Raspberry Pi host

1. Create `hosts/<name>/configuration.nix` and `hosts/<name>/home.nix` (importing `../../modules/home/profiles/server.nix`).
2. Add `<name> = mkRpiNixosSystem { hostDir = "<name>"; hostname = "<name>"; username = "john"; };` under `nixosConfigurations` in `flake.nix`.
3. Add `<name>` to the `validate` matrix and `workflow_dispatch` host options in `.github/workflows/rpi.yml`, and to the host loop in `justfile`'s `rpi-check`.
4. Update `AGENTS.md` and `docs/runbooks/README.md`, then run `just check-all`.
