# NixOS Fresh-Install Runbook

This runbook takes a blank x86_64 disk to a working NixOS installation running this repository's configuration. It targets a standard NixOS disk layout: GPT, a ~512M vfat EFI System Partition mounted at `/boot`, a single ext4 root partition, and systemd-boot. There is no swap and no LUKS by default; those are documented variants only.

## When to use this runbook

Use this runbook when installing NixOS on a fresh or wiped x86_64 machine. Do not use it for virtual machines that will act as long-lived hosts. If you need LUKS or swap, read the optional variants in Phase P2 before partitioning; the default commands below do not create them.

## Done means

The installation is done when all of the following are true:

- The machine boots to the COSMIC greeter.
- You can log in as `john`.
- `nix --version` runs successfully.
- `just --list` works from the dotfiles checkout.
- A Home Manager generation exists for `john`.
- The base network works (`ping -c1 github.com`).

Expected time: 60-90 minutes.

## Before you start

Gather these items before booting the installer:

- A NixOS graphical ISO written to a USB drive.
- Wired Ethernet or known Wi-Fi credentials.
- Access to the GitHub account, plus a phone to add an SSH key through the GitHub web UI.
- A decision on the hostKey. For this runbook, the hostKey is `john-tpd-05`.
- A backup of any existing data on the target disk. Partitioning erases the disk.

Host-specific facts used throughout:

| Fact | Value |
| --- | --- |
| hostKey | `john-tpd-05` |
| hostname | `john-tpd-05` |
| username | `john` |
| groups | networkmanager, wheel, lp, scanner |
| shell | zsh |
| timezone | America/Los_Angeles |
| system.stateVersion | 25.05 |

The flake output `nixosConfigurations."john-tpd-05"` exists in this repository. If you chose a different hostKey, confirm the matching output exists before installing. See "Adding a new host" if it does not.

## Checkpoint map

| Phase | Goal | Checkpoint |
| --- | --- | --- |
| P0 | Confirm hostKey and flake output | Flake output exists |
| P1 | Boot ISO, confirm UEFI and network | UEFI directory and GitHub reachable |
| P2 | Partition, format, mount | `lsblk -f` shows expected mounts |
| P3 | Generate NixOS config | `/mnt/etc/nixos/` populated |
| P4 | Set up SSH auth, clone repo, stage hardware config | `git ls-files --error-unmatch` succeeds |
| P5 | Run `nixos-install`, set password | Installer completes without error |
| P6 | Reboot and verify the system | Login, Nix, task runner, Home Manager all work |

## Phases

### P0: HostKey decision and flake-output check

Decide the hostKey now. This runbook uses `john-tpd-05`. The hostKey must match the hostname and the `nixosConfigurations` output in `flake.nix`. If you are on a machine that already has this repository cloned, confirm the output exists:

```bash
nix eval .#nixosConfigurations.john-tpd-05.config.system.build.toplevel.drvPath
```

**Checkpoint:** the command prints a `.drv` path without error.

**If it fails:** the flake output is missing. Add the host to `flake.nix` using the "Adding a new host" procedure, or choose an existing hostKey that matches the machine.

### P1: Boot the ISO, confirm UEFI and network

Write the NixOS graphical ISO to a USB drive and boot the target machine from it. Open a terminal.

Confirm UEFI boot:

```bash
test -d /sys/firmware/efi && echo "UEFI confirmed"
```

Confirm network access:

```bash
ping -c1 github.com
```

**Checkpoint:** `UEFI confirmed` is printed and `ping` reports one successful reply.

**If it fails:** if the UEFI check prints nothing, the machine booted in BIOS/CSM mode. Disable CSM or Legacy boot in the firmware settings and reboot the ISO. If `ping` fails, connect Ethernet or run `nmtui` to join Wi-Fi and retry.

### P2: Partition, format, and mount

These commands target a single NVMe disk (`/dev/nvme0n1`). Replace the device name if your disk is different. The partition table is GPT, the ESP is ~512M and vfat, and the root partition is ext4.

```bash
sgdisk --clear /dev/nvme0n1
sgdisk --new=1:0:+512M --typecode=1:ef00 --new=2:0:0 --typecode=2:8300 /dev/nvme0n1
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

Alternatively, use `parted` to create the same GPT layout.

**Checkpoint:** run `lsblk -f`. The output should show `/dev/nvme0n1p1` formatted as `vfat` mounted at `/mnt/boot` and `/dev/nvme0n1p2` formatted as `ext4` mounted at `/mnt`.

**If it fails:** confirm the disk name with `lsblk` before retrying. If the mount fails, check whether the partitions were created in the expected order. Do not continue if `/mnt/boot` is not mounted on the ESP.

Optional variants:

- LUKS: use `cryptsetup luksFormat /dev/nvme0n1p2` before `mkfs.ext4`, then open it with `cryptsetup open` and mount the mapped device. Tradeoff: stronger data-at-rest protection, but every boot requires the passphrase.
- Swap: create an additional partition or swap file and add a `swapDevices` entry to the hardware configuration. Tradeoff: hibernation and memory pressure relief, but it changes the disk layout and requires regenerating the hardware config.

### P3: Generate the NixOS configuration

Generate a base configuration on the mounted target:

```bash
nixos-generate-config --root /mnt
```

Review the generated files under `/mnt/etc/nixos/`:

```bash
ls /mnt/etc/nixos/
```

**Checkpoint:** `/mnt/etc/nixos/configuration.nix` and `/mnt/etc/nixos/hardware-configuration.nix` exist.

**If it fails:** confirm that `/mnt` is mounted and that the target disk is correct. Re-run the command and read the error output.

### P4: Pre-clone authentication, clone, and stage the hardware config

The repository is private over SSH. The installer ISO does not have `gh`, so add an ed25519 key through GitHub's web UI from a phone.

Generate the key on the installer:

```bash
ssh-keygen -t ed25519 -C "john@john-tpd-05"
```

Read the public key and add it to the GitHub account:

```bash
cat ~/.ssh/id_ed25519.pub
```

**Checkpoint:** authenticate to GitHub:

```bash
ssh -T git@github.com
```

Expected output includes `Hi john-s-lin! You've successfully authenticated`.

**If it fails:** confirm the public key was added to the correct GitHub account and that the SSH agent is not required. Retry `ssh -T git@github.com`.

Clone the repository into the target home directory:

```bash
mkdir -p /mnt/home/john
git clone git@github.com:john-s-lin/dotfiles.git /mnt/home/john/dotfiles
```

If the ISO lacks `git`, enter a temporary shell first:

```bash
nix shell nixpkgs#git
```

Copy the generated hardware configuration into the host directory and stage it:

```bash
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/home/john/dotfiles/hosts/john-tpd-05/hardware-configuration.nix
cd /mnt/home/john/dotfiles
git add hosts/john-tpd-05/hardware-configuration.nix
```

**Checkpoint:** confirm the file is tracked:

```bash
git ls-files --error-unmatch hosts/john-tpd-05/hardware-configuration.nix
```

Expected output is the path itself, `hosts/john-tpd-05/hardware-configuration.nix`.

**If it fails:** confirm the host directory exists and the copy succeeded. If the host directory does not exist, follow "Adding a new host" first.

### P5: Install NixOS and set the password

Enable flakes for the installer and run `nixos-install` against the flake output:

```bash
cd /mnt/home/john/dotfiles
nixos-install --flake .#john-tpd-05 --root /mnt --option experimental-features "nix-command flakes"
```

If your installer's Nix already enables flakes, omit the `--option` argument. If it does not accept it, set the option through the environment instead: `export NIX_CONFIG='experimental-features = nix-command flakes'`.

Set the password for `john` inside the installed system:

```bash
nixos-enter --root /mnt -c 'passwd john'
```

The key you generated in P4 lives in the installer's `/root/.ssh`. Copy it into the installed user's home so the machine's key survives the reboot, and hand ownership of the clone and key to `john`:

```bash
install -d -m 700 -o 1000 -g 100 /mnt/home/john/.ssh
cp /root/.ssh/id_ed25519 /root/.ssh/id_ed25519.pub /mnt/home/john/.ssh/
ssh-keyscan github.com >> /mnt/home/john/.ssh/known_hosts
chown -R 1000:100 /mnt/home/john/.ssh /mnt/home/john/dotfiles
chmod 700 /mnt/home/john/.ssh
chmod 600 /mnt/home/john/.ssh/id_ed25519
chmod 644 /mnt/home/john/.ssh/id_ed25519.pub
```

**Checkpoint:** `nixos-install` completes without error, `passwd` reports the password was updated, and `nixos-enter --root /mnt -c 'stat -c "%U %a" /home/john/.ssh/id_ed25519'` prints `john 600`.

**If it fails:** read the installer output. Common causes are missing network access, insufficient disk space, or a missing flake output. Re-run after fixing the cause. Do not reboot until the install completes.

### P6: Reboot and verify

Reboot into the installed system:

```bash
reboot
```

Log in as `john` at the COSMIC greeter, open a terminal, and run the verification commands.

**Checkpoint:** `passwd -S john` shows `P` in the second field.

```bash
passwd -S john
```

**Checkpoint:** Nix is available.

```bash
nix --version
```

**Checkpoint:** `just --list` runs and lists the repository's targets.

```bash
cd ~/dotfiles
just --list
```

**Checkpoint:** a Home Manager generation exists.

```bash
home-manager generations
```

If `home-manager` is not on `PATH`, inspect the generation links directly:

```bash
ls ~/.local/state/nix/profiles/
```

**Checkpoint:** network works after the install.

```bash
ping -c1 github.com
```

**Checkpoint:** the COSMIC session loads. Log out and back in to confirm the greeter and desktop session work.

**Checkpoint:** Tailscale is running after you start it.

```bash
sudo tailscale up
tailscale status
```

**If it fails:** reboot and select the previous systemd-boot generation. If the system does not boot at all, reinstall from the ISO and review the phase that failed. For a running system with a bad switch, use the rollback procedure in "Recovery and rollback".

## Post-install tasks

These tasks are outside the base install. Complete them after the verification phase.

| Task | Command or reference |
| --- | --- |
| Configure rclone remotes | `rclone config`; prove with `rclone listremotes`; see `docs/cloud-storage.md` |
| Set up Gmail filters | `gmailctl init`, then `gmailctl diff`; see `docs/gmailctl.md` |
| Start Tailscale | `sudo tailscale up`; prove with `tailscale status` |
| Set up GPG and signing keys | Import or generate keys; prove with `git config --get user.signingkey` |
| Confirm GitHub SSH key | `ssh -T git@github.com` |

## Recovery and rollback

If a configuration switch breaks the system:

1. Reboot and select the previous generation in the systemd-boot menu.
2. Or, from a working session, run:

```bash
sudo nixos-rebuild switch --rollback
```

If the system does not boot and no generation works, boot the NixOS ISO and reinstall using this runbook. The committed `hosts/john-tpd-05/hardware-configuration.nix` contains UUIDs from the previous install; regenerate it during the reinstall as described in P3 and P4.

## Adding a new host

To add a host that does not exist in the flake yet:

1. Copy the closest existing host directory:

```bash
cp -r hosts/john-tpd-05 hosts/new-host
```

2. Add the `nixosConfigurations` output in `flake.nix`, following the existing entries.
3. Regenerate the hardware configuration for the new machine and replace the copied `hardware-configuration.nix`.
4. Review `configuration.nix` and `home.nix` for host-specific values such as the hostname and timezone.
5. Commit the changes with git (or your configured VCS).
