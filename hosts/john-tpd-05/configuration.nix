# hosts/john-tpd-05/configuration.nix
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  hostname,
  username,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/desktop/cosmic.nix
    ../../modules/desktop/greeter.nix
    ../../modules/desktop/hyprland.nix

    ../../modules/fonts.nix

    ../../modules/packages/default.nix

    ../../modules/services/keyd.nix
    ../../modules/services/networking.nix
    ../../modules/services/printing.nix
    ../../modules/services/sound.nix
    ../../modules/services/vpn.nix

    ../../modules/gc/default.nix
  ];

  # Localsend
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kill user processes on logout so lingering sessions don't block shutdown.
  # NOTE: this also kills detached multiplexer sessions (zellij/shpool/herdr).
  services.logind.settings.Login.KillUserProcesses = true;

  # Power button: a short press should only wake the machine, never power it
  # off. Two things are needed for that.
  #
  # 1. The ACPI "tiny power button" driver is built as a module
  #    (CONFIG_ACPI_TINY_POWER_BUTTON=m) and udev autoloads it via its ACPI
  #    modalias. It binds the fixed ACPI power button and converts every notify
  #    -- including the one that wakes us from s2idle -- into SIGRTMIN+4 to
  #    PID 1, i.e. an immediate poweroff. That is why pressing the flashing
  #    power button to wake the laptop shut it down instead. The regular
  #    `button` driver handles the power button fine, so keep this one out.
  #    Ref: https://github.com/NixOS/nixpkgs/issues/577729
  boot.blacklistedKernelModules = [ "tiny_power_button" ];

  # 2. With `button` back in charge, the press reaches userspace as a power key
  #    event, so make a short press a no-op instead of logind's default
  #    "poweroff". A long press still hard-powers-off in the EC firmware, and
  #    shutdowns requested from the OS (session menu, `systemctl poweroff`)
  #    work as usual. Use "suspend" or "lock" instead if you want a short
  #    press to do something while awake.
  services.logind.settings.Login.HandlePowerKey = "ignore";

  # Wake from suspend by pressing a key on the built-in keyboard. serio0 is the
  # i8042 KBD port; arming its power/wakeup lets a key press resume the machine
  # from s2idle. This costs no extra battery (unlike arming the Bluetooth
  # controller), but note that bumping keys with the lid closed also wakes it.
  # If you also want a paired BT keyboard to wake it, add a udev rule setting
  # power/wakeup to "enabled" on the BT controller's USB device.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="serio", ATTR{description}=="i8042 KBD port", ATTR{power/wakeup}="enabled"
  '';

  # Allow unfree
  nixpkgs.config = {
    allowUnfree = true;
  };

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
  ];

  # libgphoto2 udev rules: sets ID_GPHOTO2 on PTP cameras so the gvfs
  # gphoto2 volume monitor (used by COSMIC Files and Thunar) detects them.
  services.udev.packages = [ pkgs.libgphoto2 ];

  # iPhone/iOS file access over USB. usbmuxd is the userspace daemon that
  # multiplexes the USB connection (it owns the udev rule for Apple's vendor id
  # 05ac), and ifuse/afcclient talk to the phone's AFC service through it.
  # Note that gvfs has no AFC backend, so the phone does not appear in COSMIC
  # Files or Thunar; mount it with ifuse instead.
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse
  ];

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Path
  environment.localBinInPath = true;

  # Polkit/pkexec only accepts login shells listed in /etc/shells. The user's
  # shell is set to zsh below, so register zsh here too. Without this, Noctalia's
  # Greeter appearance sync fails with:
  # "The value for the SHELL variable was not found in the /etc/shells file"
  environment.shells = [ pkgs.zsh ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "John";
    extraGroups = [
      "networkmanager"
      "wheel"
      "lp"
      "scanner"
    ];
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  networking.hostName = hostname;

  # List services that you want to enable:
  programs.nix-ld.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
