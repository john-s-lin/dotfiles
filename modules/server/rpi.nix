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

  # Silence NixOS 26.05 deprecation warning (default flips to false in 26.11).
  boot.zfs.forceImportRoot = false;
}
