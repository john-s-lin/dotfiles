# Shared NixOS base for Raspberry Pi 4B hosts (apollo, atlas).
# Neither Pi evaluates flakes or compiles packages locally: max-jobs = 0 enforces
# binary-cache-only activation, and CI builds closures on ubuntu-24.04-arm.
{
  config,
  hostname,
  lib,
  nixos-raspberrypi,
  pkgs,
  username,
  ...
}:
{
  imports = [
    nixos-raspberrypi.nixosModules.raspberry-pi-4.base
    nixos-raspberrypi.nixosModules.sd-image
    ../gc/default.nix
  ];

  # Never build locally on the Pis; fail fast on a cache miss instead of OOMing.
  nix.settings.max-jobs = 0;

  # Tighter GC retention and store optimisation for SD card longevity.
  nix.gc.options = lib.mkForce "--delete-older-than 14d";
  nix.optimise.automatic = true;

  # Keep closure lean and minimise SD card writes.
  documentation.enable = false;
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
  services.journald.extraConfig = ''
    Storage=volatile
    RuntimeMaxUse=50M
  '';

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # Publish <hostname>.local on LAN as a headless fallback alongside Tailscale.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  # Headless first-boot bootstrap from the FAT32 /boot/firmware partition
  # (mounts natively as /Volumes/FIRMWARE on macOS after flashing the SD card).
  # Each drop-in file is optional and deleted once successfully applied so
  # credentials never remain on the boot partition.
  systemd.services = {
    rpi-firstboot-wifi = {
      description = "Import optional Wi-Fi credentials from /boot/firmware/wifi.env";
      after = [ "NetworkManager.service" ];
      wants = [ "NetworkManager.service" ];
      before = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.coreutils
        pkgs.gnused
        pkgs.networkmanager
      ];
      serviceConfig.Type = "oneshot";
      script = ''
        if [ ! -f /boot/firmware/wifi.env ]; then
          exit 0
        fi
        # Parse WIFI_SSID and WIFI_PSK safely (strip CR if edited on macOS/Windows).
        WIFI_SSID="$(sed -n 's/^WIFI_SSID=//p' /boot/firmware/wifi.env | head -n1 | tr -d '\r')"
        WIFI_PSK="$(sed -n 's/^WIFI_PSK=//p' /boot/firmware/wifi.env | head -n1 | tr -d '\r')"
        if [ -z "$WIFI_SSID" ] || [ -z "$WIFI_PSK" ]; then
          echo "wifi.env missing WIFI_SSID or WIFI_PSK; skipping"
          exit 1
        fi
        nmcli connection delete rpi-wifi 2>/dev/null || true
        nmcli connection add type wifi ifname wlan0 con-name rpi-wifi \
          ssid "$WIFI_SSID" \
          wifi-sec.key-mgmt wpa-psk \
          wifi-sec.psk "$WIFI_PSK" \
          connection.autoconnect yes
        nmcli connection up rpi-wifi || true
        rm -f /boot/firmware/wifi.env
      '';
    };

    rpi-firstboot-ssh-keys = {
      description = "Import optional SSH authorized_keys from /boot/firmware/authorized_keys";
      before = [ "sshd.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.coreutils ];
      serviceConfig.Type = "oneshot";
      script = ''
        if [ ! -f /boot/firmware/authorized_keys ]; then
          exit 0
        fi
        install -d -m 700 -o ${username} -g users /home/${username}/.ssh
        cat /boot/firmware/authorized_keys >> /home/${username}/.ssh/authorized_keys
        chown ${username}:users /home/${username}/.ssh/authorized_keys
        chmod 600 /home/${username}/.ssh/authorized_keys
        rm -f /boot/firmware/authorized_keys
      '';
    };

    rpi-firstboot-tailscale = {
      description = "Auto-join Tailscale on headless first boot from /boot/firmware/tailscale-authkey";
      after = [
        "network-online.target"
        "tailscaled.service"
        "rpi-firstboot-wifi.service"
      ];
      wants = [
        "network-online.target"
        "tailscaled.service"
      ];
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.coreutils
        pkgs.tailscale
      ];
      serviceConfig.Type = "oneshot";
      script = ''
        if [ ! -f /boot/firmware/tailscale-authkey ]; then
          exit 0
        fi
        KEY="$(tr -d '\r\n ' < /boot/firmware/tailscale-authkey)"
        if [ -z "$KEY" ]; then
          echo "tailscale-authkey is empty; skipping"
          exit 1
        fi
        tailscale up \
          --auth-key="$KEY" \
          --ssh \
          --hostname="${hostname}" \
          --advertise-tags=tag:rpi
        rm -f /boot/firmware/tailscale-authkey
      '';
    };
  };

  time.timeZone = lib.mkDefault "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  environment.shells = [ pkgs.zsh ];

  users.users.${username} = {
    isNormalUser = true;
    description = "John";
    # Used only for local TTY console login on first boot (SSH password auth is
    # disabled). Run `passwd` immediately after first boot; NixOS does not
    # overwrite an existing user's password on subsequent rebuilds.
    initialPassword = "changeme";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
  };

  system.nixos.tags =
    let
      cfg = config.boot.loader.raspberry-pi;
    in
    [
      "raspberry-pi-${cfg.variant}"
      cfg.bootloader
      config.boot.kernelPackages.kernel.version
    ];

  system.stateVersion = "26.05";

  # Host-first SD image base name so apollo and atlas images are immediately
  # distinguishable when downloaded (CI appends the commit short-SHA on upload).
  image.baseName = lib.mkForce "${hostname}-rpi${config.boot.loader.raspberry-pi.variant}-nixos-${config.system.stateVersion}";

  # Silence NixOS 26.05 deprecation warning (default flips to false in 26.11).
  boot.zfs.forceImportRoot = false;
}
