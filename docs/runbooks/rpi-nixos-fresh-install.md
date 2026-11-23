# Raspberry Pi NixOS Fresh-Install Runbook (Headless)

This runbook takes a blank microSD card (or USB SSD) for a Raspberry Pi 4 Model B (`apollo` or `atlas`) to a working NixOS installation built from this repository's flake — **completely headless** (no monitor, mini-HDMI cable, or keyboard required). Images are built natively on GitHub Actions (`ubuntu-24.04-arm`) so neither Pi ever evaluates flakes or compiles packages locally.

## When to use this runbook

Use this runbook when provisioning a Raspberry Pi 4B directly onto NixOS from a CI-built SD card image. Keep the previous DietPi SD card untouched as a physical rollback medium.

Do not use this runbook to convert a remote-only Pi (such as `atlas` before an on-site visit) in place.

## Done means

The installation is done when all of the following are true:

- The Pi boots headlessly from the newly flashed NixOS SD card and joins Tailscale automatically as `<host>` (`tag:rpi`).
- Tailscale SSH works (`ssh john@apollo`) without password auth.
- You have changed `john`'s initial password with `passwd` over SSH.
- `nix show-config | grep max-jobs` reports `max-jobs = 0`.
- `swapon --show` shows `/dev/zram0` active.
- Home Manager tools and `zsh` are active for `john`.
- Cockpit is reachable on port `9090`.
- GitHub Actions (`deploy-apollo`) pushes and activates `apollo` cleanly over Tailscale on every `main` commit.

Expected time: 30-45 minutes (including CI SD image build).

## Before you start

Gather these items before starting:

- A spare microSD card (keep the old DietPi SD card untouched as rollback).
- A local workstation with an SD card reader (and `zstd` + `dd` or Raspberry Pi Imager / Balena Etcher).
- Wired Ethernet (preferred) or your Wi-Fi SSID + password.
- Access to GitHub Actions for `john-s-lin/dotfiles` (web UI or `gh` CLI).
- Access to the Tailscale admin console (to configure `tag:ci` / `tag:rpi` ACLs, generate a one-time Tailscale auth key for first boot, and create a Tailscale OAuth client for GitHub Actions).

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
| P0 | Configure Tailscale ACLs & GitHub Actions Secrets (one-time) | `tag:ci` / `tag:rpi` ACL saved; `TS_OAUTH_CLIENT_*` secrets set |
| P1 | Build and download the SD image from CI | `.img.zst` (or `.img`) artifact downloaded |
| P2 | Flash the new SD card and add headless drop-in files | `tailscale-authkey` (and optional `wifi.env`) placed on `FIRMWARE` |
| P3 | Power on headlessly, SSH in over Tailscale, change password | `ssh john@apollo` succeeds and `passwd` updated |
| P4 | Verify Pi guards (`max-jobs`, `zramSwap`, Cockpit) and reboot | All health checks pass after reboot |
| P5 | Verify GitHub Actions auto-deploy | `Deploy (apollo)` job succeeds on `ubuntu-24.04-arm` |

## Phases

### P0: Configure Tailscale ACLs & GitHub Actions Secrets (one-time)

Do this once before generating your first-boot Tailscale auth key so `tag:rpi` and `tag:ci` already exist:

1. **Tailscale Access Controls** (Tailscale Admin Console -> **Access controls**): add `tag:ci` and `tag:rpi` under `tagOwners`, allow `tag:ci` -> `tag:rpi:22` in `acls`, and allow Tailscale SSH in `ssh`:

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

2. **Tailscale OAuth client** (Tailscale Admin Console -> **Settings** -> **OAuth clients** -> **Generate OAuth client**):
   - Grant **`Devices: Core` (Write)** scoped to **`tag:ci`**.
   - Copy the Client ID and Client Secret.

3. **Add GitHub Actions Repository Secrets** (via [Settings -> Secrets -> Actions](https://github.com/john-s-lin/dotfiles/settings/secrets/actions) or `gh` CLI from this repo):

   ```bash
   gh secret set TS_OAUTH_CLIENT_ID
   gh secret set TS_OAUTH_CLIENT_SECRET
   ```

**Checkpoint:** `gh secret list` shows `TS_OAUTH_CLIENT_ID` and `TS_OAUTH_CLIENT_SECRET`, and the Tailscale ACL saves without syntax errors.

**If it fails:** verify your Tailscale account is an admin (`autogroup:admin`) and that `tag:ci` / `tag:rpi` are listed in `tagOwners` before referencing them in `acls`/`ssh`.

### P1: Build and download the SD image from GitHub Actions

Trigger the `Raspberry Pi NixOS` workflow (`.github/workflows/rpi.yml`) for the target host (`apollo` or `atlas`) with `build_sd_image=true`:

```bash
gh workflow run rpi.yml -f host=apollo -f build_sd_image=true
```

Wait for the run to complete and download the artifact (retained for 7 days):

```bash
gh run list --workflow=rpi.yml --limit 5
gh run download <run-id> -n apollo-sd-image -D ./rpi-image
(cd ./rpi-image && shasum -a 256 -c *.sha256)
```

**Checkpoint:** `./rpi-image/` contains `apollo-rpi4-nixos-26.05-<short-sha>.img.zst` (and matching `.sha256`), and `shasum -a 256 -c` reports `OK`.

**If it fails:** inspect the workflow logs with `gh run view <run-id> --log-failed`. If `nix build --dry-run` showed unexpected source builds, confirm `nixos-raspberrypi` and `home-manager-rpi` are pinned to a cached release branch.

### P2: Flash the new SD card & drop headless bootstrap files

Set aside the old DietPi SD card untouched. Insert the **new** SD card into your workstation.

1. **Flash the image** with Raspberry Pi Imager (*Use Custom Image*), Balena Etcher, or `dd`:

   ```bash
   # Inspect disks first — double-check the target device!
   diskutil list           # macOS
   lsblk                   # Linux

   # Example (macOS — replace diskN with the SD card):
   diskutil unmountDisk /dev/diskN
   zstdcat ./rpi-image/*.img.zst | sudo dd of=/dev/rdiskN bs=4m status=progress
   ```

2. **Mount the FAT32 `FIRMWARE` partition** (unplug and replug the SD card reader if macOS doesn't auto-mount `/Volumes/FIRMWARE`):

   - **Tailscale auth key (required for headless first boot):** In Tailscale Admin Console -> **Settings** -> **Keys** -> **Generate auth key**, create a **one-time, non-ephemeral** key with tag **`tag:rpi`**, then write it to `/Volumes/FIRMWARE/tailscale-authkey`:

     ```bash
     printf '%s\n' 'tskey-auth-...' > /Volumes/FIRMWARE/tailscale-authkey
     ```

   - **Wi-Fi credentials (only if not using wired Ethernet):** Write `/Volumes/FIRMWARE/wifi.env`:

     ```bash
     cat > /Volumes/FIRMWARE/wifi.env <<'EOF'
     WIFI_SSID=YourNetworkName
     WIFI_PSK=YourWifiPassword
     EOF
     ```

   - *(Optional LAN SSH fallback)* Drop your public key(s) into `/Volumes/FIRMWARE/authorized_keys` if you also want direct LAN SSH via `ssh john@apollo.local` (Avahi mDNS is enabled).

   All drop-in files are automatically deleted from `/boot/firmware/` by the first-boot systemd units in `modules/server/rpi.nix` once applied.

3. **Eject the SD card safely:**

   ```bash
   diskutil eject /dev/diskN
   ```

**Checkpoint:** `/Volumes/FIRMWARE/tailscale-authkey` (and `wifi.env` if on Wi-Fi) were written and the card ejected cleanly.

**If it fails:** verify the SD card is not write-protected and re-run `diskutil list` to confirm the `FIRMWARE` partition is FAT32.

### P3: Headless first boot, SSH in, and set password

Insert the newly flashed SD card into `apollo`, plug in Ethernet (unless using `wifi.env`), and power on. On first boot, NixOS automatically grows the root partition (`boot.growPartition = true`), imports `wifi.env` (if present), joins Tailscale with `--ssh --hostname=apollo --advertise-tags=tag:rpi`, and deletes the drop-in files from `/boot/firmware/`.

Wait ~60–90 seconds, then verify `apollo` appears online on your tailnet and SSH in:

```bash
tailscale status | grep apollo
ssh john@apollo
```

Once logged in, immediately change `john`'s initial password (`changeme`):

```bash
passwd
```

**Checkpoint:** `ssh john@apollo` logs into a `zsh` shell over Tailscale SSH without prompting for a password, `passwd` succeeds, and `/boot/firmware/tailscale-authkey` has been deleted.

**If it fails:**
- Wait another 60 seconds (first boot resizes the ext4 partition and starts `tailscaled`).
- If `apollo` still doesn't appear in `tailscale status`, check whether it's on LAN via `ping -c1 apollo.local` (or your router's DHCP leases).
- If you forgot to plug in Ethernet before powering on, plug in Ethernet and power-cycle — `rpi-firstboot-tailscale` only deletes `tailscale-authkey` after `tailscale up` succeeds, so it will retry automatically.

### P4: Verify Pi guards and services

Run these checks over SSH on `apollo`:

```bash
nix show-config | grep '^max-jobs'
swapon --show
journalctl --disk-usage
systemctl is-active tailscaled cockpit.socket
ls /boot/firmware/tailscale-authkey /boot/firmware/wifi.env 2>/dev/null || echo "drop-ins cleaned up"
```

**Checkpoint:**

- `max-jobs = 0`
- `/dev/zram0` is listed by `swapon --show`
- `journalctl --disk-usage` stays within the 50M volatile cap
- `tailscaled` and `cockpit.socket` are active
- `drop-ins cleaned up` is printed

Reboot once (`sudo reboot`) and confirm `ssh john@apollo` comes back automatically after ~45 seconds.

### P5: Verify GitHub Actions auto-deploy

From your workstation, trigger a deploy-only run (no SD image rebuild) to confirm CI can push and activate `apollo` over Tailscale:

```bash
gh workflow run rpi.yml -f host=apollo -f build_sd_image=false -f deploy_apollo=true
gh run watch
```

**Checkpoint:** the `Deploy (apollo)` job connects to Tailscale, pings `apollo`, and completes `nixos-rebuild switch` with exit code 0. From this point on, every push to `main` builds on `ubuntu-24.04-arm` and updates `apollo` automatically.

**If it fails:** inspect `gh run view --log-failed`. Most first-time failures are either `tag:rpi` missing from `apollo` or the Tailscale `ssh` ACL not allowing `tag:ci` -> `tag:rpi` as `root`.

## Post-install credential tasks

- Rotate any service credentials before migrating workloads (Pi-hole, Actual Budget) from `atlas` to `apollo`.

## Recovery and rollback

- **NixOS generation rollback:** if a future configuration breaks boot or services, roll back via `sudo nixos-rebuild switch --rollback`.
- **Full OS rollback:** power off the Pi, remove the NixOS SD card, and reinsert the untouched DietPi SD card.

## Adding a new Raspberry Pi host

1. Create `hosts/<name>/configuration.nix` and `hosts/<name>/home.nix` (importing `../../modules/home/profiles/personal/server.nix`).
2. Add `<name> = mkRpiNixosSystem { hostDir = "<name>"; hostname = "<name>"; username = "john"; };` under `nixosConfigurations` in `flake.nix`.
3. Add `<name>` to the `validate` matrix and `workflow_dispatch` host options in `.github/workflows/rpi.yml`, and to the host loop in `justfile`'s `rpi-check`.
4. Update `AGENTS.md` and `docs/runbooks/README.md`, then run `just check-all`.
